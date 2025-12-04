#!/bin/zsh

FOLDER=$1
FILENAME=$2

cd ../markdown/$FOLDER

FILES=(*.html)
NUMFILES=${#FILES[@]}
FILEINDEX=$FILES[(ie)$FILENAME]
BUTTONSHTML=""

PREVFILEINDEX=$(($FILEINDEX-1))

if (($PREVFILEINDEX > 0)); then
    PREVFILE=${FILES[$PREVFILEINDEX]}
    PREVFILE=$(basename "$PREVFILE" .html)
    BUTTONSHTML+="<button class=\"previous\"><a href=\"#$PREVFILE\">$PREVFILE</a></button>"
fi

NEXTFILEINDEX=$(($FILEINDEX+1))

if (($NEXTFILEINDEX <= $NUMFILES)); then
    NEXTFILE=${FILES[$NEXTFILEINDEX]}
    NEXTFILE=$(basename "$NEXTFILE" .html)
    BUTTONSHTML+="<button class=\"next\"><a href=\"#$NEXTFILE\">$NEXTFILE</a></button>"
fi

echo $BUTTONSHTML