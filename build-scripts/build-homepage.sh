#!/bin/zsh

rm ../homepage_sections/html/*

for file in ../homepage_sections/markdown/*.md; do

  if [ -f "$file" ]; then

    NEWFILE=$(echo $file | sed "s/markdown/html/" | sed "s/.md/.html/")
    touch $NEWFILE
    echo "<section id=\"$(basename $NEWFILE .html)\">" > $NEWFILE
    pandoc $file -f gfm -t HTML >> $NEWFILE
    echo "</section>" >> $NEWFILE

  fi
done

INSERTHTML="<!-- BEGIN converted .md from \/homepage_sections\/markdown\/ -->"

for file in ../homepage_sections/html/*.html; do

  if [ -f "$file" ]; then # Check if it's a regular file (not a directory)

    NEWTEXT=$(<"$file")

    INSERTHTML="$INSERTHTML$NEWTEXT"    
  fi
done

INSERTHTML="$INSERTHTML<!-- END converted .md from \/homepage_sections\/markdown\/ -->"

# escape special characters in the html for use in sed below
INSERTHTML=$(./escape-html.sh $INSERTHTML)

sed "s/{{homepage_sections}}/$INSERTHTML/" ../templates/_index.html > ../index.html