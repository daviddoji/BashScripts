#!/bin/bash

EXTENSION=.c

# Delete everything except files ending with $EXTENSION
find . -type f ! -name "*$EXTENSION" -delete
