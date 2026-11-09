# Fundación Creo · Misión Navidad 2026 — Reel

Reel vertical 1080×1920, 30 fps, 28 s. Colores de marca: magenta, azul clarito y blanco.

| Archivo | Qué es |
|---|---|
| `mision-navidad-2026.mp4` | Reel final con música (caja musical de *Noche de paz*, dominio público, sintetizada aquí) |
| `mision-navidad-2026-sin-musica.mp4` | Mismo reel sin audio, para ponerle un audio en tendencia desde Instagram/TikTok |
| `reel.html` | La animación (cada fotograma se calcula con `setTime(t)`) |
| `render.js` | Renderiza `reel.html` fotograma a fotograma y codifica con ffmpeg |
| `musica.py` | Sintetiza la pista de música |
| `blur.py` | Genera los fondos desenfocados de `fotos/blur/` |
| `fotos/` | Fotos enviadas desde el Chocó |

## Guion

| Tiempo | Escena | Texto |
|---|---|---|
| 0–3.6 s | Intro de marca, adornos y nieve | Fundación Creo · *Misión* NAVIDAD 2026 · Recogemos donaciones |
| 3.6–6.6 s | Niños frente al altar | *La Navidad* es compartir |
| 6.6–9.4 s | Procesión | es llevar esperanza · DONDE MÁS SE NECESITA |
| 9.4–12.2 s | Banda escolar | es ser herramientas · DE ALEGRÍA |
| 12.2–15.2 s | Collage misa + altar | para los niños y familias · DEL CHOCÓ |
| 15.2–17.9 s | Procesión, zoom a la pancarta "Colombia abraza al Chocó" | *Juntos,* ABRACEMOS AL CHOCÓ |
| 17.9–21.2 s | Fachada de la parroquia | Parroquia Nuestra Señora de la Pobreza · Corregimiento de Pie de Pepé · Medio Baudó, Chocó |
| 21.2–28 s | Tarjeta de donación (queda fija hasta el final) | Especie y dinero · Bancolombia ahorros 20205780033 · NIT 830.133.398 · hasta el 14 de diciembre |

## Volver a renderizar

```bash
npm i                       # fuentes (Great Vibes, Playfair Display, Montserrat)
python3 blur.py
node render.js video-sin-audio.mp4 30
python3 musica.py musica.wav
ffmpeg -i video-sin-audio.mp4 -i musica.wav -c:v copy -c:a aac -b:a 192k -shortest mision-navidad-2026.mp4
```
