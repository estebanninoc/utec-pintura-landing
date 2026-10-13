#!/usr/bin/env bash
# uso: build_set.sh <set> <dir-destino-relativo-al-repo>   (cuadros ya renderizados en /tmp/pt1w/seq-{desk,mob})
set -euo pipefail; export PATH=/tmp/pt1w/bin:$PATH
L=/opt/dispatch/projects/claw/staging/o1-pt1/utec-pintura-landing; W=/tmp/pt1w; DEST=$L/$2
cd $W; rm -rf out-desk out-mob src-*.mp4
for m in desk mob; do ffmpeg -v error -y -framerate 1 -i seq-$m/f_%03d.jpg -c:v libx264 -crf 12 -preset slow -pix_fmt yuv420p -r 1 src-$m.mp4; done
bash $L/tools/frames.sh despiece   src-desk.mp4 out-desk >/dev/null 2>&1
bash $L/tools/frames.sh motor-mini src-mob.mp4  out-mob  >/dev/null 2>&1
[ "$(ls out-desk/desk | wc -l)" = 71 ] && [ "$(ls out-mob/mob | wc -l)" = 137 ] || { echo "ERROR conteo de cuadros"; exit 1; }
rm -rf $DEST; mkdir -p $DEST; mv out-desk/desk $DEST/desk; mv out-mob/mob $DEST/mob
rm -rf out-desk out-mob src-*.mp4 seq-desk seq-mob
echo "$1 -> $DEST: $(ls $DEST/desk|wc -l) desk, $(ls $DEST/mob|wc -l) mob, $(du -sh $DEST|cut -f1)"
