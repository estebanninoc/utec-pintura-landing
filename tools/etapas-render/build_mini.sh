#!/usr/bin/env bash
# PT9b: escenas chicas "antes -> después mientras bajas" para initDespiece (copiado de motos, n:50).
# Barrido izquierda -> derecha igual al de PT8 (borde difuminado del 65% del ancho, easing smoothstep, sin pausas),
# bordes de la foto fundidos a negro (la sección es #000), casi-negros a 0. Cuadros f_001..f_050.webp con la MISMA
# calidad que tools/frames.sh (desk -q55, mob -q40, -m 6; aquí vía el shim cwebp -> ffmpeg libwebp).
# uso: build_mini.sh <antes.png> <despues.png> <dir-salida> <deskW> <deskH> <mobW> <mobH> [fade=0.12]
set -euo pipefail
FF=/opt/dispatch/projects/taller/.work-ffmpeg/ffmpeg-7.0.2-amd64-static/ffmpeg
CW="$(dirname "$0")/cwebp"
A=$1; B=$2; OUT=$3; DW=$4; DH=$5; MW=$6; MH=$7; FADE=${8:-0.12}; N=50
T=$(mktemp -d /dev/shm/pt9mini.XXXX); trap 'rm -rf "$T"' EXIT
# borde fundido a negro: factor = smoothstep(0,FADE, distancia al borde más cercano en fracción)
EDGE="st(0,min(min(X/W,1-X/W),min(Y/H,1-Y/H))/$FADE);st(0,clip(ld(0),0,1));st(1,ld(0)*ld(0)*(3-2*ld(0)));st(2,p(X,Y)*ld(1));if(lt(ld(2),6),0,ld(2))"
for k in a b; do
  src=$A; [ $k = b ] && src=$B
  $FF -v error -y -i "$src" -vf "scale=${DW}:${DH}:force_original_aspect_ratio=increase,crop=${DW}:${DH},format=gbrp,geq=r='$EDGE':g='$EDGE':b='$EDGE'" "$T/$k.png"
done
# barrido: c va de -F/2 a 1+F/2 con smoothstep; alfa(después) = clip((c - X/W)/F + 0.5)
WIPE="st(0,N/$((N-1)));st(1,ld(0)*ld(0)*(3-2*ld(0)));st(2,clip((-0.325+ld(1)*1.65-X/W)/0.65+0.5,0,1));A+(B-A)*ld(2)"
mkdir -p "$T/seq" "$OUT/desk" "$OUT/mob"
$FF -v error -y -loop 1 -i "$T/a.png" -loop 1 -i "$T/b.png" -filter_complex "[0][1]blend=all_expr='$WIPE'" -frames:v $N "$T/seq/f_%03d.png"
for f in "$T"/seq/f_*.png; do
  b=$(basename "$f" .png)
  "$CW" -q 55 -m 6 "$f" -o "$OUT/desk/$b.webp"
  $FF -v error -y -i "$f" -vf "scale=${MW}:${MH}:flags=lanczos" "$T/m.png"
  "$CW" -q 40 -m 6 "$T/m.png" -o "$OUT/mob/$b.webp"
done
echo "$OUT: desk $(ls "$OUT/desk"|wc -l) ($(du -sh "$OUT/desk"|cut -f1)), mob $(ls "$OUT/mob"|wc -l) ($(du -sh "$OUT/mob"|cut -f1))"
