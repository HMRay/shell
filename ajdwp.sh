#!/bin/bash

DEBUG_PORT=7777
SOURCE_PATH=app/src/main/java

FILE=/var/tmp/andebug-$(date +%s)
adb jdwp > "$FILE" &
sleep 1
kill -9 $!
JDWP_ID=$(tail -1 "$FILE")
rm "$FILE"
adb forward tcp:$DEBUG_PORT jdwp:$JDWP_ID
jdb -sourcepath $SOURCE_PATH -DEBUG_PORT
