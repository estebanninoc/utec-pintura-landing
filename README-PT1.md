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
