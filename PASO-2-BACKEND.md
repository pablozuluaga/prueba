# PASO 2 — Backend compartido (app cliente + app dueño)

Las dos apps diseñadas en Claude Design se conectan a una misma base de datos en
**Supabase** (Postgres + login + tiempo real + fotos). Este paso deja lista esa base;
las pantallas se conectan cuando el diseño esté en el repo.

```
 App cliente (sin cuenta)                         App dueño (con login)
 ├─ lee carta y config  ──────► Supabase ◄──────  ├─ ve pedidos en tiempo real
 ├─ crear_pedido(...)                             ├─ cambia estado / confirma pago
 └─ ver_pedido(token) cada ~15 s                  └─ edita carta, precios, agotados, config
```

## Reglas del negocio implementadas

- **Domicilio o recoger**, a elección del cliente. Domicilio exige dirección y suma
  `costo_domicilio`; recoger no.
- **Sin pagos en la app.** `metodo_pago` = `contra_entrega` (al repartidor o en caja)
  o `transferencia` (a la cuenta Bancolombia que el dueño configura en `config`).
  El dueño marca `pago_confirmado` cuando ve la transferencia.
- **Solo el dueño** administra. Cualquier otro usuario, con o sin cuenta, no ve pedidos
  ni puede cambiar precios.
- **Los precios los calcula el servidor**, nunca el celular del cliente.
- El dueño puede **cerrar** el restaurante, apagar domicilios o recoger, marcar productos
  **agotados** u **ocultos**, y fijar un **pedido mínimo**.
- Estados: `recibido → confirmado → preparando → listo → en_camino → entregado`
  (o `cancelado` con motivo).
- Cada pedido tiene un **código corto** (p. ej. `K7P3`) para hablar por WhatsApp.

## Archivos

| Archivo | Qué es |
|---|---|
| `backend/supabase/migrations/0001_esquema.sql` | Tablas, permisos (RLS), `crear_pedido`, `ver_pedido`, tiempo real, bucket de fotos |
| `backend/supabase/seed.sql` | La carta: 46 categorías, 236 productos, 25 fotos reales. **Generado** |
| `tools/generar_seed.py` | Regenera `seed.sql` desde `assets/carta.json` |
| `backend/pruebas/correr.sh` | Prueba todo en un Postgres local (22 casos) |

Los encabezados sin precio de la carta impresa (`Cesar`, vinos, `Waffle Mickey con:`)
quedan como **un producto con variantes** (`Con Pollo $29.500` / `Con Salmón $41.900`).
La sección `SABORES DE HELADO` (solo opciones) no se carga todavía: necesita
"modificadores", que se agregan cuando el diseño los pida.

## Probar

```bash
python3 tools/generar_seed.py   # si cambió assets/carta.json
backend/pruebas/correr.sh       # TODAS LAS PRUEBAS PASARON
```

## Poner en marcha (lo hace el dueño, ~10 minutos)

1. Crear cuenta gratis en <https://supabase.com> → **New project** (región São Paulo, la
   más cercana a Medellín).
2. **SQL Editor** → pegar y ejecutar `0001_esquema.sql`, luego `seed.sql`.
3. **Authentication → Users → Add user**: crear el usuario del dueño (correo + clave).
4. En **SQL Editor**: `insert into duenos (user_id) select id from auth.users where email = 'CORREO_DEL_DUEÑO';`
5. **Table editor → config**: cuenta Bancolombia, costo de domicilio, WhatsApp, dirección.
6. **Project Settings → API**: copiar `Project URL` y la clave `anon public`. Esas dos
   van en las apps (son públicas por diseño; la seguridad la dan los permisos RLS).
   **Nunca** compartir la clave `service_role`.

## Pendiente

- Traer los diseños de Claude Design al repo y conectar las pantallas.
- Subir las 25 fotos de `assets/reales/` al bucket `fotos` (hoy `foto_url` guarda la ruta local).
- Límite de pedidos por teléfono/IP contra spam, antes de abrir al público.
- Notificaciones push al dueño cuando entra un pedido (necesarias también para App Store).
