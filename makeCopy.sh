#!/bin/bash

DIR=Arreglados


# si el directorio no existe lo crea
if [ ! -d pwd/$DIR ]
then
  mkdir $DIR
fi

# copia recursivamente desde el directorio actual todos los archivos 
# con extension .mp4 al directorio $DIR
find . -name "*.mp4" -exec cp -t $DIR {} +

# copia todos los subtitulos del directorio actual al directorio $DIR
rsync -a *.srt $DIR/

# muestra notificacion de 2 s al acabar
notify-send -t 2000 "Fin de la conversión"
#play /usr/share/sounds/freedesktop/stereo/bell.oga
