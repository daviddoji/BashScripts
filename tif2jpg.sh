#!/bin/bash

# Convert TIF files to JPG preserving name

convert *.TIF -set filename: "%t" %[filename:].jpg

# Wait 0.5 s and remove all TIFs
sleep 0.5  && rm *.TIF

# Show notification of 2 seconds when it finishes
notify-send -t 2000 "Terminó la conversion!"
