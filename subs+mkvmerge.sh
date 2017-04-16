#!/bin/bash

# Cambia la extensión mkv por mp4
for i in *".mkv"; do
    mv "$i" "${i%%".mkv"}.mp4"
done

# Cambiar el nombre del archivo de video por el del archivo de subtitulos
find . -iname "*.mp4" | while IFS= read -r f; do
    id=$(sed -n 's/.*.[Ss]\([0-9]\+\)[Ee]\([0-9]\+\)..*/\1x\2/p' <<< "$f" | sed 's/^0\+//')

    if [ -z "$id" ]; then
        echo "Warning! there's no match for $f"
    else
        for srt in *"$id"*; do
            newName=$(sed 's/ (English).srt/.mp4/g' <<< "$srt")
            mv "$f" "$newName"
        done
    fi
done 

## cambia los espacios por guiones bajos
for file in *; do   
    if [[ "$file" != "${file// /_}" ]]; then
    mv "$file" "${file// /_}"
    fi
done

# Cambia la codificación de los subtítulos en español
for i in *"_(Español_(España)).srt"; do
#  if chardetect $i | grep -q 'UTF-8-SIG' ; then ## si la salida contiene 'utf-8'
#    mv "$i" "${i%%".es.srt"}.esp.srt"
#  elif chardetect $i | grep -v 'utf-8' ; then ## si la salida no contiene 'utf-8'
#    iconv -t=UTF-8 "$i" > "${i%%".es.srt"}.esp.srt" && rm "$i"
#  else
#    mv "$i" "${i%%".es.srt"}.esp.srt"
#  fi
  ENCODE="$(file -bi "$i" | cut -d'=' -f2)"
  iconv -f "$ENCODE" -t utf8 "$i" > "${i%%"_(Español_(España)).srt"}.esp.srt" && rm "$i"
done

# Pega los subtítulos en el archivo de video
for i in *".mp4"; do
    if mkvmerge -i $i | grep -q '0: audio' ; then
        i=${i%.mp4} 
        mkvmerge -o -v "$i.mkv" \
            --language 1:eng -a 0 -d 1 -S -T "$i.mp4" \
            --language 0:eng -s 0 -D -A -T $i"_(English).srt" \
            --language 0:spa -s 0 -D -A -T "$i.esp.srt" \
            --track-order 0:0,0:1,1:0,2:0
    else
        i=${i%.mp4} 
        mkvmerge -o -v "$i.mkv" \
            --language 1:eng -a 1 -d 0 -S -T "$i.mp4" \
            --language 0:eng -s 0 -D -A -T $i"_(English).srt" \
            --language 0:spa -s 0 -D -A -T "$i.esp.srt" \
            --track-order 0:1,0:0,1:0,2:0
    fi
done

# Borra todos los archivos menos los creados 
find . -type f ! -name "*.mkv" ! -name "*.sh" -delete

# Cambia la extensión mkv por mp4
for f in *.mkv; do
    mv "$f" "${f%.mkv}.mp4"
done 

## cambia los guiones bajos por espacios 
for file in *; do
    if [[ "$file" != "${file//_/ }" ]]; then
    mv "$file" "${file//_/ }"
    fi
done

# Muestra notificación al acabar
notify-send -t 2000 "Fin de la conversión"
