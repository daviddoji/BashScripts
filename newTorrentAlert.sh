#!/bin/bash

EMAIL=daviddoji@gmail.com

### Send an email when a torrent has been downloaded

echo "$TR_TORRENT_NAME succesfully downloaded" | mutt -s "new torrent downloaded" $EMAIL

