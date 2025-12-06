#!/bin/zsh

# get markdown folder and target file from passed in args
FOLDER=$1
FILENAME=$2

cd ../markdown/$FOLDER

# save files in folder to array
FILES=(*.html)
NUMFILES=${#FILES[@]}
FILEINDEX=$FILES[(ie)$FILENAME]

BUTTONSHTML=""

# if there's a previous file in the array, generate a button for it
PREVFILEINDEX=$(($FILEINDEX-1))

if (($PREVFILEINDEX > 0)); then
    PREVFILE=${FILES[$PREVFILEINDEX]}
    PREVBUTTONTEXT=$(basename "$PREVFILE" .html)
    BUTTONSHTML+="<button class=\"previous\"><a href=\"./$PREVFILE\">$PREVBUTTONTEXT</a></button>"
fi

# if there's a following file in the array, generate a button for it
NEXTFILEINDEX=$(($FILEINDEX+1))

if (($NEXTFILEINDEX <= $NUMFILES)); then
    NEXTFILE=${FILES[$NEXTFILEINDEX]}
    NEXTBUTTONTEXT=$(basename "$NEXTFILE" .html)
    BUTTONSHTML+="<button class=\"next\"><a href=\"./$NEXTFILE\">$NEXTBUTTONTEXT</a></button>"
fi

# return html for the buttons to previous call
echo $BUTTONSHTML