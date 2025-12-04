#!/bin/zsh

FOLDER=$1
FILENAME=$2

cd ../markdown/$FOLDER

FILES=(*.html)
NUMFILES=${#FILES[@]}
FILEINDEX=$FILES[(ie)$FILENAME]
BUTTONSHTML=""

PREVFILE=$(($FILEINDEX-1))

if (($PREVFILE > 0)); then
    BUTTONSHTML+="<button class=\"previous\">${FILES[$PREVFILE]}</button>"
fi

NEXTFILE=$(($FILEINDEX+1))

if (($NEXTFILE <= $NUMFILES)); then
    BUTTONSHTML+="<button class=\"next\">${FILES[$NEXTFILE]}</button>"
fi

echo $BUTTONSHTML