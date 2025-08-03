#!/bin/bash


# create homepage sections

rm ./homepage_sections/html/*

for file in ./homepage_sections/markdown/*.md; do

  if [ -f "$file" ]; then

    NEWFILE=$(echo $file | sed "s/markdown/html/" | sed "s/.md/.html/")
    touch $NEWFILE
    echo "<section id=\"$(basename $NEWFILE .html)\">" > $NEWFILE
    pandoc $file -f gfm -t HTML >> $NEWFILE
    echo "</section>" >> $NEWFILE

  fi
done

INSERTHTML="<!-- BEGIN converted .md from \/homepage_sections\/markdown\/ -->"

for file in ./homepage_sections/html/*.html; do

  if [ -f "$file" ]; then # Check if it's a regular file (not a directory)

    NEWTEXT=$(<"$file")

    NEWTEXT=${NEWTEXT//\</\\<}
    NEWTEXT=${NEWTEXT//\>/\\>}
    NEWTEXT=${NEWTEXT//\//\\/}
    NEWTEXT=${NEWTEXT//\&/\\&}
    NEWTEXT=${NEWTEXT//$'\n'/\\n}

    INSERTHTML="${INSERTHTML}\n${NEWTEXT}"    
  fi
done

INSERTHTML="${INSERTHTML}\n<!-- END converted .md from \/homepage_sections\/markdown\/ -->"

sed "s/{{homepage_sections}}/$INSERTHTML/" ./templates/_index.html > ./index.html


# create blog posts

rm ./blog/html/*

for file in ./blog/markdown/*.md; do

  if [ -f "$file" ]; then

    NEWFILE=$(echo $file | sed "s/markdown/html/" | sed "s/.md/.html/")
    touch $NEWFILE
    ARTICLETITLE=$(basename "$file" .md)
    echo "<article id=\"$ARTICLETITLE\">" > $NEWFILE
    ARTICLETITLE=$(date -jf %F $ARTICLETITLE '+%A %-d %B %Y')
    echo "<h3>$ARTICLETITLE</h3>" >> $NEWFILE
    pandoc $file -f gfm -t HTML >> $NEWFILE
    echo "</article>" >> $NEWFILE

  fi
done

INSERTHTML=""

for file in ./blog/html/*.html; do

  if [ -f "$file" ]; then # Check if it's a regular file (not a directory)

    NEWTEXT=$(<"$file")

    NEWTEXT=${NEWTEXT//\</\\<}
    NEWTEXT=${NEWTEXT//\>/\\>}
    NEWTEXT=${NEWTEXT//\//\\/}
    NEWTEXT=${NEWTEXT//\&/\\&}
    NEWTEXT=${NEWTEXT//$'\n'/\\n}

    INSERTHTML="${NEWTEXT}\n${INSERTHTML}"    
  fi
done

INSERTHTML="<!-- BEGIN converted .md from \/blog\/markdown\/ -->\n${INSERTHTML}"
INSERTHTML="${INSERTHTML}<!-- END converted .md from \/blog\/markdown\/ -->"

sed -i "" "s/{{blog_posts}}/$INSERTHTML/" ./index.html