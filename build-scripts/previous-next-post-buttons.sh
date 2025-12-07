#!/bin/zsh

# get markdown folder and target file from passed in args
FOLDER=$1
FILENAME=$2

# function for generating button display text
buttonText () {
    text=$1
    text=$(basename "$text" .html)
    text=$(date -jf %F $text '+%A %-d %B %Y')
    echo $text
}

cd ../markdown/$FOLDER

# save files in folder to array
FILES=(*.html)
NUMFILES=${#FILES[@]}
FILEINDEX=$FILES[(ie)$FILENAME]

BUTTONSHTML="<section><nav class=\"post-navigation\">"

# if there's a following file in the array, generate a button for it
NEXTFILEINDEX=$(($FILEINDEX+1))

if (($NEXTFILEINDEX <= $NUMFILES)); then
    NEXTFILE=${FILES[$NEXTFILEINDEX]}
    BUTTONSHTML+="<a class=\"next-button\" href=\"./${NEXTFILE%%.*}\">$(buttonText $NEXTFILE)</a>"
fi

# if there's a previous file in the array, generate a button for it
PREVFILEINDEX=$(($FILEINDEX-1))

if (($PREVFILEINDEX > 0)); then
    PREVFILE=${FILES[$PREVFILEINDEX]}
    BUTTONSHTML+="<a class=\"previous-button\" href=\"./${PREVFILE%%.*}\">$(buttonText $PREVFILE)</a>"
fi

BUTTONSHTML+="</nav></section>"

# return html for the buttons to previous call
echo $BUTTONSHTML