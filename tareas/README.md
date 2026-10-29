# ¿Quién hace qué?

Tablero de tareas compartido para **Gordo, Negro y Ñuñu**.

**Enlace del tablero:** https://claude.ai/artifact/U4aQr4L2aZ5wULkWc7McAp

Es una página web, no hay que instalar nada. Se abre desde el celular o el computador y
los cambios les aparecen a los tres al instante.

## Cómo se usa

1. **Elige quién eres** (arriba: Gordo, Negro o Ñuñu). Se recuerda en ese celular y
   así queda registrado quién crea, completa y sube cada cosa.
2. **Nueva tarea** (botón verde): qué hay que hacer, a quién le toca, fecha y hora
   opcional, si se repite, si es urgente y notas.
3. **Marcar como hecha:** toca el círculo de la tarea o ábrela. Queda guardado quién la
   hizo y a qué hora, aunque le tocara a otro.
4. **Evidencias:** abre la tarea y toca *Subir foto o PDF*. Se ven en miniatura y se
   amplían al tocarlas.
5. **Comentarios e historial** dentro de cada tarea.

### Vistas

- **Agenda:** atrasadas (en rojo), hoy, los próximos 7 días y lo hecho hoy.
- **Semana:** cuadrícula persona × día, como un calendario. El `+` de cada casilla crea
  una tarea para esa persona ese día.
- **Hechas:** lo completado, quién lo hizo y sus evidencias.

Las tarjetas de arriba muestran cuántas tareas tiene pendientes cada uno, cuántas están
atrasadas y cuántas completó en la semana. Si tocas una, ves solo las tareas de esa persona.

### Tareas que se repiten y rotan

Una tarea puede repetirse cada día, cada semana o cada mes. Cuando se marca como hecha, la
siguiente se crea sola. Si además tiene **Rotar entre los tres**, la siguiente le toca a la
próxima persona: Gordo → Negro → Ñuñu → Gordo…

## Darles acceso a los otros dos

El tablero es privado al principio. Quien lo creó entra al enlace, abre **Compartir** e
invita a los otros dos por correo como **Editor**. Así pueden crear tareas, completarlas
y subir evidencias. Con permiso de solo lectura pueden ver el tablero, pero no editarlo.

## Técnico

- `quien-hace-que.html` es todo el código (HTML, CSS y JS, sin librerías).
- Las tareas viven en la base de datos compartida del tablero (colección `tareas`) y se
  sincronizan en tiempo real.
- Las evidencias se guardan en el almacén de archivos del tablero. Si alguien no tiene
  permiso de subir archivos, las fotos se comprimen y se guardan en la colección
  `evidencias`.
