# PASO 1 — Investigación y producción de imagen

Rediseño digital de **Crepes & Waffles (Medellín)**.
Este documento cubre solo el PASO 1. El PASO 2 (animar el hero + landing) no arranca
hasta que el dueño elija hero.

## Estado

| Sub-paso | Estado | Nota |
|---|---|---|
| 1A · Extracción de la carta | ✅ Hecho | `assets/carta.json` — 249 ítems + 63 opciones, precios exactos |
| 1A · Catálogo de fotos reales | ✅ Hecho | `assets/reales/` — 25 platos recortados + 6 bodegones |
| 1B · Fotos de platos | ⛔ Especificado, no ejecutado | Falta el MCP de Higgsfield |
| 1C · Fachada 21:9 | ⛔ Bloqueado | Falta el MCP **y** la foto de la fachada |
| 1D · 8 heroes | ⛔ Especificado, 4 de 8 además sin insumo | Falta el MCP y fotos del local |

## Los dos bloqueos

**1. El MCP de Higgsfield no está conectado en esta sesión.**
Los servidores MCP disponibles son Canva, Google Drive, GitHub y Claude Code Remote.
Ninguno hace generación ni edición fotorrealista de imagen. Todo 1B/1C/1D quedó
especificado al detalle en `assets/produccion/` para ejecutarse tal cual apenas se conecte.

**2. El estilo maestro y los 8 heroes del brief describen otro restaurante.**
El texto habla de una fuente de soda chileno-alemana fundada en 1975: lomito, schop de
500cc, chucrut, schoperas, garzones, chef mascota vintage. Crepes & Waffles es una casa
de crepes, waffles y helados. La REGLA DE ORO dice que la identidad no se toca y que ante
la duda se elige fiel, así que `assets/produccion/estilo-maestro.json` guarda las dos
versiones y `1d-heroes.json` guarda cada concepto traducido **y** su texto literal.
Pendiente que el dueño elija.

## 1A · La carta

`assets/carta.json` — nombres, descripciones y precios exactos, sin redondear ni reescribir.

- Páginas 1–6 del PDF traen capa de texto: se parsean por coordenadas y fuentes
  (`tools/extraer_carta.py`). El precio se imprime 2–4 pt *arriba* del nombre del plato,
  por eso el emparejamiento va en una segunda pasada por cercanía vertical.
- Páginas 7–8 son imagen pura, sin capa de texto: se transcribieron leyendo la página
  renderizada y viven en `tools/carta_paginas_imagen.json`.

Los ítems sin precio propio **no son un error de extracción**: en la carta impresa son
encabezados cuyo precio está en sus variantes (`Cesar` → `Con Pollo $29.500` /
`Con Salmón Ahumado $41.900`; `Vino AMORETINTO - Tinto` → `Media Botella` / `Botella`;
`Waffle Mickey con:` → sus dos combinaciones).

**Hueco conocido:** los sellos `VEGETARIANO`, `VEGANO`, `CONTIENE NUECES` y
`LIGERAMENTE PICANTE` de las páginas 1–6 están dibujados como vectores, no como texto,
así que no entraron en el JSON de esas páginas. Sí están en las páginas 7–8, que se
transcribieron a ojo. Hay que completarlos a mano antes del menú digital (PASO 3);
no se inventaron.

Regenerar: `python3 tools/extraer_carta.py`

## 1A · Las fotos reales

`assets/reales/catalogo.json`

La única fuente de foto real disponible hoy es la propia carta PDF. No hay banco de fotos
del local. De ahí salieron:

- **6 bodegones** en su resolución nativa (JPEG original, sin recomprimir).
- **25 platos recortados** uno por uno, ya cruzados contra su ítem y su precio en
  `carta.json`. Los recortes se renderizan de la página *después* de borrar los rótulos
  que la carta imprime encima de las fotos, así que salen limpios.

Estilo fotográfico original de la marca: cenital, plato blanco de borde fino, fondo liso
beige/terracota, luz difusa de estudio, sin props. Bebidas: vaso facetado sobre fondo hueso.

Regenerar: `python3 tools/extraer_fotos_reales.py`

## Lo que falta pedirle al dueño

1. **Foto vertical de la fachada** con el letrero completo y legible → desbloquea 1C y el hero 4.
2. **Fotos del salón, la terraza y la barra de helados** → desbloquean los heroes 5, 7 y 8.
3. **Conectar el MCP de Higgsfield** → desbloquea toda la generación.
4. **Decidir estilo maestro**: fiel a Crepes & Waffles (recomendado) o literal al brief.

## Estructura

```
assets/
  carta.json                    carta completa, precios exactos
  reales/
    catalogo.json               índice cruzado con la carta
    p{1..6}-bodegon-*.jpeg      bodegones originales
    plato-*.png                 25 recortes por plato
    p{7,8}-banda-*.png          bandas de helados y Crepes en Casa
  produccion/
    estilo-maestro.json         prompt maestro, versión fiel y versión literal
    1b-platos.json              10 platos destacados listos para image-to-image
    1c-fachada.json             outpaint 21:9 (bloqueado por falta de foto)
    1d-heroes.json              los 8 heroes candidatos
tools/
  extraer_carta.py
  extraer_fotos_reales.py
  carta_paginas_imagen.json     transcripción de las páginas sin capa de texto
```
