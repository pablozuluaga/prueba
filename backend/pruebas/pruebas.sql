-- Pruebas del flujo cliente -> dueño. Correr con backend/pruebas/correr.sh
\set ON_ERROR_STOP 1
\set QUIET 1
\o /dev/null

create temp table r (clave text primary key, valor jsonb);
grant all on r to anon, authenticated;

create function pg_temp.ok(cond boolean, nombre text) returns void language plpgsql as $$
begin
  if not cond then raise exception 'FALLÓ: %', nombre; end if;
  raise notice 'ok  %', nombre;
end $$;

create function pg_temp.falla(q text, contiene text, nombre text) returns void language plpgsql as $$
begin
  execute q;
  raise exception 'FALLÓ (no dio error): %', nombre;
exception when others then
  if sqlerrm like 'FALLÓ%' then raise; end if;
  if position(contiene in sqlerrm) = 0 then
    raise exception 'FALLÓ: % (error inesperado: %)', nombre, sqlerrm;
  end if;
  raise notice 'ok  %', nombre;
end $$;

update config set costo_domicilio = 5000, pedido_minimo = 10000,
  bancolombia_titular = 'Prueba', bancolombia_tipo = 'ahorros', bancolombia_numero = '123';
insert into auth.users values ('00000000-0000-0000-0000-00000000d0e0'), ('00000000-0000-0000-0000-0000000000aa');
insert into duenos values ('00000000-0000-0000-0000-00000000d0e0');
update productos set visible = false where slug = 'vinos--vino-prosecco';

-- ── Cliente anónimo ──
set role anon;

select pg_temp.ok((select count(*) from productos) = 235, 'cliente ve la carta sin productos ocultos');
select pg_temp.ok((select bancolombia_numero from config) = '123', 'cliente ve cuenta Bancolombia');
select pg_temp.ok((select count(*) from pedidos) = 0, 'cliente no puede listar pedidos');

insert into r select 'dom', crear_pedido(jsonb_build_object(
  'tipo', 'domicilio', 'metodo_pago', 'transferencia',
  'cliente_nombre', 'Ana', 'cliente_telefono', '3001234567',
  'direccion', 'Cra 43A # 1-50', 'barrio', 'El Poblado',
  'items', jsonb_build_array(
    jsonb_build_object('producto_id', (select id from productos where slug = 'ensaladas--cesar'),
                       'variante', 'Con Salmón Ahumado', 'cantidad', 2),
    jsonb_build_object('producto_id', (select id from productos where slug = 'huevos--poche'), 'cantidad', 1,
                       'precio', 1))));
select pg_temp.ok((select (valor->>'total')::int from r where clave = 'dom') = 41900*2 + 13300 + 5000,
                  'total calculado en servidor (ignora precio enviado) + domicilio');

insert into r select 'rec', crear_pedido(jsonb_build_object(
  'tipo', 'recoger', 'metodo_pago', 'contra_entrega',
  'cliente_nombre', 'Luis', 'cliente_telefono', '3007654321', 'direccion', 'ignorada',
  'items', jsonb_build_array(jsonb_build_object(
    'producto_id', (select id from productos where slug = 'ensaladas--cesar'), 'variante', 'Con Pollo'))));
select pg_temp.ok((select (valor->>'total')::int from r where clave = 'rec') = 29500, 'recoger no cobra domicilio');

select pg_temp.ok((select ver_pedido((valor->>'token')::uuid)->>'estado' from r where clave = 'dom') = 'recibido',
                  'cliente sigue su pedido con el token');
select pg_temp.ok(ver_pedido(gen_random_uuid()) is null, 'token inventado no ve nada');

select pg_temp.falla($q$ select crear_pedido('{"tipo":"domicilio","metodo_pago":"contra_entrega","cliente_nombre":"X","cliente_telefono":"3000000000","items":[{"producto_id":1}]}') $q$,
  'domicilio_con_direccion', 'domicilio exige dirección');
select pg_temp.falla(format($q$ select crear_pedido('{"tipo":"recoger","metodo_pago":"contra_entrega","cliente_nombre":"X","cliente_telefono":"3000000000","items":[{"producto_id":%s}]}') $q$,
  (select id from productos where slug = 'ensaladas--cesar')), 'Elige una opción', 'variante obligatoria');
select pg_temp.falla($q$ select crear_pedido('{"tipo":"recoger","metodo_pago":"contra_entrega","cliente_nombre":"X","cliente_telefono":"3000000000","items":[]}') $q$,
  'no tiene productos', 'pedido vacío');
select pg_temp.falla($q$ select crear_pedido('{"tipo":"recoger","metodo_pago":"efectivo","cliente_nombre":"X","cliente_telefono":"3000000000","items":[{"producto_id":1}]}') $q$,
  'metodo_pago', 'método de pago inválido');
reset role;

-- Anónimo intentando editar: RLS deja 0 filas afectadas.
set role anon;
update productos set precio = 1;
update config set costo_domicilio = 0;
reset role;
select pg_temp.ok((select count(*) from productos where precio = 1) = 0, 'anon no cambia precios');
select pg_temp.ok((select costo_domicilio from config) = 5000, 'anon no cambia config');

-- ── Usuario logueado que NO es dueño ──
set role authenticated;
set request.jwt.claim.sub = '00000000-0000-0000-0000-0000000000aa';
select pg_temp.ok((select count(*) from pedidos) = 0, 'usuario no dueño no ve pedidos');
update pedidos set estado = 'cancelado';
reset role;
select pg_temp.ok((select count(*) from pedidos where estado = 'cancelado') = 0, 'usuario no dueño no cambia pedidos');

-- ── Dueño ──
set role authenticated;
set request.jwt.claim.sub = '00000000-0000-0000-0000-00000000d0e0';
select pg_temp.ok((select count(*) from pedidos) = 2, 'dueño ve todos los pedidos');
select pg_temp.ok((select count(*) from productos) = 236, 'dueño ve también productos ocultos');
update pedidos set estado = 'preparando', pago_confirmado = true where tipo = 'domicilio';
update productos set disponible = false where slug = 'huevos--poche';
update config set abierto = false;
reset role;

set role anon;
select pg_temp.ok((select ver_pedido((valor->>'token')::uuid)->>'estado' from r where clave = 'dom') = 'preparando',
                  'cliente ve el cambio de estado del dueño');
select pg_temp.falla($q$ select crear_pedido('{"tipo":"recoger","metodo_pago":"contra_entrega","cliente_nombre":"X","cliente_telefono":"3000000000","items":[{"producto_id":1}]}') $q$,
  'cerrado', 'restaurante cerrado no recibe pedidos');
reset role;
update config set abierto = true;
set role anon;
select pg_temp.falla(format($q$ select crear_pedido('{"tipo":"recoger","metodo_pago":"contra_entrega","cliente_nombre":"X","cliente_telefono":"3000000000","items":[{"producto_id":%s,"cantidad":2}]}') $q$,
  (select id from productos where slug = 'huevos--poche')), 'agotado', 'producto agotado no se puede pedir');
select pg_temp.falla(format($q$ select crear_pedido('{"tipo":"recoger","metodo_pago":"contra_entrega","cliente_nombre":"X","cliente_telefono":"3000000000","items":[{"producto_id":%s}]}') $q$,
  (select id from productos where precio < 10000 and variantes = '[]' order by precio limit 1)), 'mínimo', 'pedido mínimo');
reset role;
select pg_temp.ok((select count(*) from pedidos) = 2, 'los pedidos fallidos no dejan basura');

\echo 'TODAS LAS PRUEBAS PASARON'
