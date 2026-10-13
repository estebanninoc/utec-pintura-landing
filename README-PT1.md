# PT1 — Curso de Pintura Automotriz Profesional + Polarizado (UTEC) · v1 (fase DISEÑO)

Clonado de `/tmp/landing-kit` (sin .git). `engine/scrub.js`, `tools/build.py` y `tools/frames.sh` sin tocar.
Cambiado: `config.json`, `template/index.html` (contenido del producto), assets en `img/`.

- Paleta: la oscura del kit; acento **rojo cereza metalizado** `--red:#B3122E` (rellenos, botones de compra con
  degradado metalizado #8E0D24→#B3122E→#D8324B) y `--red-tx:#FF5C70` (texto sobre negro). Es el color del carro terminado.
- Scrub 7 etapas (fotos de Claw `pt-assets/etapas/`): cuadros dibujados con `tools/etapas-render/render.html`
  (barrido suave de arriba a abajo tipo pasada de pistola + chip de etapa en español), clip fuente a 1 fps con N cuadros,
  luego `tools/frames.sh` con sus parámetros: desktop = preset `despiece` (1280x732, 71 cuadros, initEscena),
  móvil = preset `motor-mini` (403x703 recorte vertical centrado, 137 cuadros, initMotor con LUT lineal `LUT_PT`).
  Solo queda en el DOM el stage del ancho actual (corte 720px del engine).
- `cwebp` no existe en el host: `tools/etapas-render/cwebp` es un shim a ffmpeg/libwebp con los mismos -q/-m.
- Nota frames.sh: su filtro `fps=nb_frames/(N-1)` solo da N cuadros parejos si el clip fuente va a 1 fps con N cuadros
  (por eso el clip se armó así). Con un video normal saca menos cuadros o corta el final.

Pendiente: precio real (US$XX), links de pago (#PAGO-PENDIENTE), pixel, clips de la grilla
(`data-src` vacío en cada `<video>` de #temas → `vid/temas/NN-*.mp4`), og:image absoluta al publicar.

## PT2 — scrub rehecho con las fotos APROBADAS (`pt-assets/etapas-v3/` y `etapas-v3-negro/`), 2 variantes

- **A "taller"** → `img/pt-frames/{desk,mob}` (reemplaza los cuadros de las fotos rechazadas).
- **B "negro"** → `img/pt-frames-negro/{desk,mob}`. Al renderizar se aplastan los negros (≤12 → 0) y se funden los bordes
  a #000 (las fotos traían fondo ~5,5,5, no negro puro); la sección queda en #000 y el canvas sin esquinas → no hay caja visible.
- **Cambiar de variante = UNA línea** en `template/index.html` (luego `python3 tools/build.py`), o directo en `index.html`:
  `<script>var PT_SCRUB='negro';...` → `'taller'`. Por defecto: `'negro'`.
  `config.json` sigue apuntando a `img/pt-frames/`; con `'negro'` un wrapper en el bootstrap del template cambia SOLO la
  carpeta de cuadros antes de llamar a `initEscena/initMotor` (engine/scrub.js intacto). La clase `scrub-negro` en `<html>`
  pone las secciones en #000 y quita el radio del canvas.
- Regenerar: `tools/etapas-render/render.cjs <puerto> <N> <dir> <taller|negro>` (servido desde una carpeta con
  `render.html`, `inter-tight.woff2` y subcarpetas `taller/` y `negro/` con las 7 fotos) para N=71 y N=137, y luego
  `tools/etapas-render/build_set.sh <set> img/pt-frames[-negro]` (clip 1 fps + `tools/frames.sh` despiece / motor-mini).
- Chips: Latonería, Lijado, Pre-pintura, Pintura, Clear coat, Polish, Resultado final.

## PT7 — orden real del taller (fotos `pt-assets/etapas-v7/`, 2172x724, fondo negro)

- Etapas/chips: Golpes, Latonería, Masilla, Masilla lijada, Primer, Pintura base, Clear coat (FILES/NAMES en render.html).
- Barrido HORIZONTAL izquierda → derecha (trompa → puerta) en las 6 transiciones, borde suave, SIN neblina. Línea de
  tiempo y holds sin cambios. Verificado cuadro a cuadro (franja trompa cambia antes que franja puerta, nunca al revés).
- Encuadre 3:1 sin deformar ni cortar: `render.html?layout=desk` pone el carro a todo el ancho (frames.sh despiece recorta
  1280x732 al centro, el carro entra completo); `?layout=mob` lo mete en la columna central que sobrevive al recorte vertical
  de frames.sh motor-mini (x 474..1061 del lienzo 1536x1024). Caja del carro = unión de las 7 fotos (luma>28) + 3%.
  El reflejo del piso se funde a negro en el 15% inferior de la foto (antes cortaba en seco).
- Regenerar: `node render.cjs <puerto> 71 /tmp/pt1w/seq-desk negro desk` y `node render.cjs <puerto> 137 /tmp/pt1w/seq-mob negro mob`,
  luego `tools/etapas-render/build_set.sh negro img/pt-frames-negro`.
- La variante taller (`img/pt-frames/`) NO se rehízo en PT7 (no hay fotos v7 de taller): sigue con las etapas viejas.
