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

    # convert blog date to human format for button text
    PREVBUTTONTEXT=$(basename "$PREVFILE" .html)
    PREVBUTTONTEXT=$(date -jf %F $PREVBUTTONTEXT '+%A %-d %B %Y')

    BUTTONSHTML+="<button class=\"previous\"><a href=\"./$PREVFILE\">$PREVBUTTONTEXT</a></button>"
fi

# if there's a following file in the array, generate a button for it
NEXTFILEINDEX=$(($FILEINDEX+1))

if (($NEXTFILEINDEX <= $NUMFILES)); then
    NEXTFILE=${FILES[$NEXTFILEINDEX]}
    
    # convert blog date to human format for button text
    NEXTBUTTONTEXT=$(basename "$NEXTFILE" .html)
    NEXTBUTTONTEXT=$(date -jf %F $NEXTBUTTONTEXT '+%A %-d %B %Y')

    BUTTONSHTML+="<button class=\"next\"><a href=\"./$NEXTFILE\">$NEXTBUTTONTEXT</a></button>"
fi

# return html for the buttons to previous call
echo $BUTTONSHTML