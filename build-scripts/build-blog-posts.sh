#!/bin/zsh

rm ../blog/html/*

for file in ../blog/markdown/*.md; do

  if [ -f "$file" ]; then

    NEWFILE=$(echo $file | sed "s/markdown/html/" | sed "s/.md/.html/")
    touch $NEWFILE

    # set article id to numeric date from md file name
    ARTICLETITLE=$(basename "$file" .md)
    echo "<article id=\"$ARTICLETITLE\">" > $NEWFILE

    # convert article date to human readable format for html
    ARTICLETITLE=$(date -jf %F $ARTICLETITLE '+%A %-d %B %Y')
    echo "<h2>$ARTICLETITLE</h2>" >> $NEWFILE

    # generate html from the md file
    pandoc $file -f gfm -t HTML >> $NEWFILE
    echo "</article>" >> $NEWFILE

  fi
done

INSERTHTML=""

for file in ../blog/html/*.html; do

  if [ -f "$file" ]; then # Check if it's a regular file (not a directory)

    NEWTEXT=$(<"$file")

    INSERTHTML="$NEWTEXT$INSERTHTML"
  fi
done

INSERTHTML="<!-- BEGIN converted .md from \/blog\/markdown\/ -->$INSERTHTML"
INSERTHTML="$INSERTHTML<!-- END converted .md from \/blog\/markdown\/ -->"

# escape special characters in the html for use in sed below
INSERTHTML=$(./escape-html.sh $INSERTHTML)

sed "s/{{blog_posts}}/$INSERTHTML/" ../templates/_blog.html > ../blog.html

# sed -i "" "s/{{blog_posts}}/$INSERTHTML/" ./index.html