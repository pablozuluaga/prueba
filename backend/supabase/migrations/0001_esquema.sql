-- Esquema base de la app del restaurante.
--
-- Dos apps comparten esta base:
--   * App cliente (sin cuenta, rol `anon`): lee la carta, crea pedidos con
--     `crear_pedido` y los sigue con `ver_pedido` usando un token secreto.
--   * App dueño (rol `authenticated` + fila en `duenos`): ve todos los pedidos en
--     tiempo real, cambia su estado y edita la carta, precios y configuración.
--
-- No hay pagos dentro de la app: contra entrega o transferencia a Bancolombia.
-- Los precios del pedido SIEMPRE se calculan aquí, nunca se confía en el cliente.

create extension if not exists pgcrypto;

-- ─── Dueños ──────────────────────────────────────────────────────────────────

create table public.duenos (
  user_id uuid primary key references auth.users (id) on delete cascade,
  creado  timestamptz not null default now()
);

create or replace function public.es_dueno()
returns boolean
language sql stable security definer set search_path = public
as $$
  select exists (select 1 from public.duenos where user_id = auth.uid());
$$;

-- ─── Configuración del restaurante (una sola fila) ──────────────────────────

create table public.config (
  id                  int primary key default 1 check (id = 1),
  nombre              text not null default 'Restaurante',
  abierto             boolean not null default true,
  acepta_domicilio    boolean not null default true,
  acepta_recoger      boolean not null default true,
  costo_domicilio     int not null default 0 check (costo_domicilio >= 0),
  pedido_minimo       int not null default 0 check (pedido_minimo >= 0),
  direccion_local     text,
  telefono            text,
  whatsapp            text,
  bancolombia_titular text,
  bancolombia_tipo    text check (bancolombia_tipo in ('ahorros', 'corriente')),
  bancolombia_numero  text,
  actualizado         timestamptz not null default now()
);

insert into public.config (id) values (1);

-- ─── Carta ───────────────────────────────────────────────────────────────────

create table public.categorias (
  id      bigint generated always as identity primary key,
  nombre  text not null,
  nota    text,
  orden   int not null default 0,
  visible boolean not null default true
);

create table public.productos (
  id           bigint generated always as identity primary key,
  categoria_id bigint not null references public.categorias (id) on delete cascade,
  slug         text not null unique,
  nombre       text not null,
  descripcion  text,
  -- Precio en pesos COP, entero. Si hay variantes, es el precio "desde".
  precio       int not null check (precio >= 0),
  -- [{"nombre": "500ml", "precio": 14900}, ...]; vacío = sin variantes.
  variantes    jsonb not null default '[]'::jsonb check (jsonb_typeof(variantes) = 'array'),
  -- Sellos de la carta: VEGETARIANO, VEGANO, CONTIENE NUECES, LIGERAMENTE PICANTE...
  etiquetas    text[] not null default '{}',
  foto_url     text,
  disponible   boolean not null default true,  -- false = "agotado" hoy
  visible      boolean not null default true,  -- false = oculto de la carta
  orden        int not null default 0
);

create index productos_categoria_idx on public.productos (categoria_id, orden);

-- ─── Pedidos ─────────────────────────────────────────────────────────────────

create type public.estado_pedido as enum (
  'recibido',    -- lo acaba de crear el cliente
  'confirmado',  -- el dueño lo aceptó
  'preparando',
  'listo',       -- listo para recoger / para despachar
  'en_camino',   -- solo domicilio
  'entregado',
  'cancelado'
);

create table public.pedidos (
  id                uuid primary key default gen_random_uuid(),
  -- Código corto para hablar por teléfono / WhatsApp: "K7P3".
  codigo            text not null unique,
  -- Secreto que solo tiene el cliente que hizo el pedido, para seguirlo.
  token             uuid not null unique default gen_random_uuid(),
  tipo              text not null check (tipo in ('domicilio', 'recoger')),
  metodo_pago       text not null check (metodo_pago in ('contra_entrega', 'transferencia')),
  pago_confirmado   boolean not null default false,
  cliente_nombre    text not null check (length(cliente_nombre) between 1 and 120),
  cliente_telefono  text not null check (length(cliente_telefono) between 7 and 20),
  direccion         text check (length(direccion) <= 300),
  barrio            text check (length(barrio) <= 120),
  indicaciones      text check (length(indicaciones) <= 500),
  notas             text check (length(notas) <= 500),
  subtotal          int not null,
  costo_domicilio   int not null default 0,
  total             int not null,
  estado            public.estado_pedido not null default 'recibido',
  motivo_cancelacion text,
  creado            timestamptz not null default now(),
  actualizado       timestamptz not null default now(),
  constraint domicilio_con_direccion
    check (tipo <> 'domicilio' or coalesce(length(trim(direccion)), 0) > 0)
);

create index pedidos_creado_idx on public.pedidos (creado desc);
create index pedidos_estado_idx on public.pedidos (estado);

create table public.pedido_items (
  id              bigint generated always as identity primary key,
  pedido_id       uuid not null references public.pedidos (id) on delete cascade,
  producto_id     bigint references public.productos (id) on delete set null,
  -- Copia del nombre y precio al momento de pedir: si luego cambia la carta,
  -- el pedido conserva lo que el cliente vio.
  nombre          text not null,
  variante        text,
  precio_unitario int not null,
  cantidad        int not null check (cantidad between 1 and 50),
  notas           text check (length(notas) <= 300),
  subtotal        int generated always as (precio_unitario * cantidad) stored
);

create index pedido_items_pedido_idx on public.pedido_items (pedido_id);

-- ─── Marcas de tiempo ────────────────────────────────────────────────────────

create or replace function public.tocar_actualizado()
returns trigger language plpgsql as $$
begin
  new.actualizado := now();
  return new;
end;
$$;

create trigger pedidos_actualizado before update on public.pedidos
  for each row execute function public.tocar_actualizado();
create trigger config_actualizado before update on public.config
  for each row execute function public.tocar_actualizado();

-- ─── Crear pedido (app cliente) ─────────────────────────────────────────────
--
-- Entrada:
-- {
--   "tipo": "domicilio" | "recoger",
--   "metodo_pago": "contra_entrega" | "transferencia",
--   "cliente_nombre": "...", "cliente_telefono": "...",
--   "direccion": "...", "barrio": "...", "indicaciones": "...", "notas": "...",
--   "items": [{"producto_id": 12, "variante": "500ml", "cantidad": 2, "notas": "..."}]
-- }
-- Salida: {"id", "codigo", "token", "total"}

create or replace function public.crear_pedido(p jsonb)
returns jsonb
language plpgsql security definer set search_path = public
as $$
declare
  cfg        public.config;
  v_tipo     text := p ->> 'tipo';
  v_pedido   uuid;
  v_codigo   text;
  v_subtotal int := 0;
  v_envio    int := 0;
  v_item     jsonb;
  v_prod     public.productos;
  v_variante text;
  v_precio   int;
  v_cantidad int;
  v_items    int := 0;
begin
  select * into cfg from public.config where id = 1;

  if not cfg.abierto then
    raise exception 'El restaurante está cerrado en este momento' using errcode = 'P0001';
  end if;
  if v_tipo = 'domicilio' and not cfg.acepta_domicilio then
    raise exception 'Hoy no estamos haciendo domicilios' using errcode = 'P0001';
  end if;
  if v_tipo = 'recoger' and not cfg.acepta_recoger then
    raise exception 'Hoy no estamos recibiendo pedidos para recoger' using errcode = 'P0001';
  end if;
  if jsonb_typeof(p -> 'items') is distinct from 'array'
     or jsonb_array_length(p -> 'items') = 0 then
    raise exception 'El pedido no tiene productos' using errcode = 'P0001';
  end if;
  if jsonb_array_length(p -> 'items') > 60 then
    raise exception 'Demasiados productos en un solo pedido' using errcode = 'P0001';
  end if;

  -- Código corto sin letras confusas (sin 0/O, 1/I/L).
  loop
    select string_agg(substr('23456789ABCDEFGHJKMNPQRSTUVWXYZ',
                             1 + floor(random() * 31)::int, 1), '')
      into v_codigo
      from generate_series(1, 4);
    exit when not exists (select 1 from public.pedidos where codigo = v_codigo);
  end loop;

  if v_tipo = 'domicilio' then
    v_envio := cfg.costo_domicilio;
  end if;

  insert into public.pedidos (
    codigo, tipo, metodo_pago, cliente_nombre, cliente_telefono,
    direccion, barrio, indicaciones, notas,
    subtotal, costo_domicilio, total
  ) values (
    v_codigo, v_tipo, p ->> 'metodo_pago',
    trim(p ->> 'cliente_nombre'), trim(p ->> 'cliente_telefono'),
    case when v_tipo = 'domicilio' then trim(p ->> 'direccion') end,
    case when v_tipo = 'domicilio' then trim(p ->> 'barrio') end,
    case when v_tipo = 'domicilio' then trim(p ->> 'indicaciones') end,
    nullif(trim(p ->> 'notas'), ''),
    0, v_envio, 0
  ) returning id into v_pedido;

  for v_item in select * from jsonb_array_elements(p -> 'items') loop
    select * into v_prod
      from public.productos
     where id = (v_item ->> 'producto_id')::bigint
       and visible;

    if not found then
      raise exception 'Un producto del pedido ya no está en la carta' using errcode = 'P0001';
    end if;
    if not v_prod.disponible then
      raise exception '"%" está agotado', v_prod.nombre using errcode = 'P0001';
    end if;

    v_variante := nullif(v_item ->> 'variante', '');
    if jsonb_array_length(v_prod.variantes) > 0 then
      select (v ->> 'precio')::int into v_precio
        from jsonb_array_elements(v_prod.variantes) v
       where v ->> 'nombre' = v_variante;
      if v_precio is null then
        raise exception 'Elige una opción válida para "%"', v_prod.nombre using errcode = 'P0001';
      end if;
    else
      v_variante := null;
      v_precio := v_prod.precio;
    end if;

    v_cantidad := coalesce((v_item ->> 'cantidad')::int, 1);

    insert into public.pedido_items (pedido_id, producto_id, nombre, variante, precio_unitario, cantidad, notas)
    values (v_pedido, v_prod.id, v_prod.nombre, v_variante, v_precio, v_cantidad,
            nullif(trim(v_item ->> 'notas'), ''));

    v_subtotal := v_subtotal + v_precio * v_cantidad;
    v_items := v_items + 1;
    v_precio := null;
  end loop;

  if v_subtotal < cfg.pedido_minimo then
    raise exception 'El pedido mínimo es de $%', cfg.pedido_minimo using errcode = 'P0001';
  end if;

  update public.pedidos
     set subtotal = v_subtotal, total = v_subtotal + v_envio
   where id = v_pedido;

  return (
    select jsonb_build_object('id', id, 'codigo', codigo, 'token', token, 'total', total)
      from public.pedidos where id = v_pedido
  );
end;
$$;

-- ─── Seguir un pedido (app cliente) ─────────────────────────────────────────
-- Solo con el token secreto que devolvió `crear_pedido`.

create or replace function public.ver_pedido(p_token uuid)
returns jsonb
language sql stable security definer set search_path = public
as $$
  select jsonb_build_object(
    'codigo', p.codigo,
    'tipo', p.tipo,
    'metodo_pago', p.metodo_pago,
    'pago_confirmado', p.pago_confirmado,
    'estado', p.estado,
    'motivo_cancelacion', p.motivo_cancelacion,
    'direccion', p.direccion,
    'subtotal', p.subtotal,
    'costo_domicilio', p.costo_domicilio,
    'total', p.total,
    'creado', p.creado,
    'actualizado', p.actualizado,
    'items', coalesce((
      select jsonb_agg(jsonb_build_object(
               'nombre', i.nombre, 'variante', i.variante, 'cantidad', i.cantidad,
               'precio_unitario', i.precio_unitario, 'subtotal', i.subtotal, 'notas', i.notas)
             order by i.id)
        from public.pedido_items i where i.pedido_id = p.id), '[]'::jsonb)
  )
  from public.pedidos p
  where p.token = p_token;
$$;

-- ─── Permisos (Row Level Security) ──────────────────────────────────────────

alter table public.duenos       enable row level security;
alter table public.config       enable row level security;
alter table public.categorias   enable row level security;
alter table public.productos    enable row level security;
alter table public.pedidos      enable row level security;
alter table public.pedido_items enable row level security;

-- Dueños: cada quien solo ve si él mismo es dueño. Se agregan desde el panel de Supabase.
create policy "dueno se ve a si mismo" on public.duenos
  for select to authenticated using (user_id = auth.uid());

-- Config: todos la leen (horario, costo de domicilio, cuenta Bancolombia); solo el dueño la edita.
create policy "config lectura publica" on public.config
  for select to anon, authenticated using (true);
create policy "config edita dueno" on public.config
  for update to authenticated using (public.es_dueno()) with check (public.es_dueno());

-- Carta: el público ve lo visible; el dueño ve y edita todo.
create policy "categorias lectura" on public.categorias
  for select to anon, authenticated using (visible or public.es_dueno());
create policy "categorias dueno" on public.categorias
  for all to authenticated using (public.es_dueno()) with check (public.es_dueno());

create policy "productos lectura" on public.productos
  for select to anon, authenticated
  using ((visible and exists (select 1 from public.categorias c
                               where c.id = categoria_id and c.visible))
         or public.es_dueno());
create policy "productos dueno" on public.productos
  for all to authenticated using (public.es_dueno()) with check (public.es_dueno());

-- Pedidos: solo el dueño accede a las tablas. El cliente usa crear_pedido / ver_pedido.
create policy "pedidos dueno" on public.pedidos
  for all to authenticated using (public.es_dueno()) with check (public.es_dueno());
create policy "pedido_items dueno" on public.pedido_items
  for all to authenticated using (public.es_dueno()) with check (public.es_dueno());

revoke all on function public.crear_pedido(jsonb) from public;
revoke all on function public.ver_pedido(uuid) from public;
grant execute on function public.crear_pedido(jsonb) to anon, authenticated;
grant execute on function public.ver_pedido(uuid) to anon, authenticated;

-- ─── Tiempo real ─────────────────────────────────────────────────────────────
-- La app del dueño se suscribe a INSERT/UPDATE de pedidos; RLS filtra quién los recibe.

alter publication supabase_realtime add table public.pedidos;
alter publication supabase_realtime add table public.pedido_items;

-- ─── Fotos de la carta (Supabase Storage) ───────────────────────────────────

insert into storage.buckets (id, name, public)
values ('fotos', 'fotos', true)
on conflict (id) do nothing;

create policy "fotos sube dueno" on storage.objects
  for insert to authenticated with check (bucket_id = 'fotos' and public.es_dueno());
create policy "fotos cambia dueno" on storage.objects
  for update to authenticated using (bucket_id = 'fotos' and public.es_dueno());
create policy "fotos borra dueno" on storage.objects
  for delete to authenticated using (bucket_id = 'fotos' and public.es_dueno());
