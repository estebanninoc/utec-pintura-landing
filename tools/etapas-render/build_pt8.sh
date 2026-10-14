#!/usr/bin/env bash
# PT8: render continuo (71 cuadros) -> clip 1 fps -> tools/frames.sh despiece (desk 1280x732 + mob 720x412, igual que motos)
# uso: build_pt8.sh <puerto-http-sirviendo-render-dir>   (render dir con render.html, inter-tight.woff2 y negro/ -> etapas-v7)
set -euo pipefail; export PATH=/tmp/pt1w/bin:$PATH
L=/opt/dispatch/projects/claw/staging/o1-pt1/utec-pintura-landing; W=/tmp/pt1w
cd $W/render && node render.cjs "$1" 71 $W/seq negro desk
cd $W && rm -rf out src.mp4 && ffmpeg -v error -y -framerate 1 -i seq/f_%03d.jpg -c:v libx264 -crf 12 -preset slow -pix_fmt yuv420p -r 1 src.mp4
bash $L/tools/frames.sh despiece src.mp4 out >/dev/null 2>&1
[ "$(ls out/desk|wc -l)" = 71 ] && [ "$(ls out/mob|wc -l)" = 71 ] || { echo "ERROR conteo"; exit 1; }
rm -rf $L/img/dp-frames; mkdir -p $L/img/dp-frames; mv out/desk out/mob $L/img/dp-frames/
rm -rf out src.mp4
echo "dp-frames: desk $(ls $L/img/dp-frames/desk|wc -l) ($(du -sh $L/img/dp-frames/desk|cut -f1)), mob $(ls $L/img/dp-frames/mob|wc -l) ($(du -sh $L/img/dp-frames/mob|cut -f1))"
