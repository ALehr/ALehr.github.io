#!/bin/zsh

rm ./blog/html/*

for file in ./blog/markdown/*.md; do

  if [ -f "$file" ]; then

    NEWFILE=$(echo $file | sed "s/markdown/html/" | sed "s/.md/.html/")
    touch $NEWFILE
    ARTICLETITLE=$(basename "$file" .md)
    echo "<article id=\"$ARTICLETITLE\">" > $NEWFILE
    ARTICLETITLE=$(date -jf %F $ARTICLETITLE '+%A %-d %B %Y')
    echo "<h2>$ARTICLETITLE</h2>" >> $NEWFILE
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

sed "s/{{blog_posts}}/$INSERTHTML/" ./templates/_blog.html > ./blog.html

# sed -i "" "s/{{blog_posts}}/$INSERTHTML/" ./index.html