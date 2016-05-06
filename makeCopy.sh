#!/bin/bash

DIR=Arreglados


# if DIR doesn't exist, create it
if [ ! -d pwd/$DIR ]
then
  mkdir $DIR
fi

# recursively copy all files from current directory 
# with extension .mp4 to directory $DIR
find . -name "*.mp4" -exec cp -t $DIR {} +

# copy all subtitles from current directory to directory $DIR
rsync -a *.srt $DIR/

# show a 2 seconds notification when done
notify-send -t 2000 "Fin de la conversión"
#play /usr/share/sounds/freedesktop/stereo/bell.oga
