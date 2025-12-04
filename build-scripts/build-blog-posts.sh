#!/bin/zsh

echo "    building blog posts..."

# generate html fragments from md files

for file in ../markdown/blog/*.md; do

  # generate temporary html file
  NEWFILE=$(echo $file | sed "s/.md/.html/")

  # set article id to numeric date from md file name
  ARTICLETITLE=$(basename "$file" .md)
  echo "<article id=\"$ARTICLETITLE\">" > $NEWFILE

  # convert article date to human readable format for html
  ARTICLETITLE=$(date -jf %F $ARTICLETITLE '+%A %-d %B %Y')
  echo "<h2>$ARTICLETITLE</h2>" >> $NEWFILE

  # generate html from the md file
  pandoc $file -f gfm -t HTML >> $NEWFILE

  echo "</article>" >> $NEWFILE

done

INSERTHTML=""

for file in ../markdown/blog/*.html; do

  HTMLFRAG=$(<"$file")

  # create previous and next post buttons
  HTMLFRAG+=$(./previous-next-post-buttons.sh blog $(basename "$file"))

  INSERTHTML="$HTMLFRAG$INSERTHTML"

done

INSERTHTML="<!-- BEGIN converted .md from /markdown/blog/ -->$INSERTHTML"
INSERTHTML+="<!-- END converted .md from /markdown/blog/ -->"

# escape special characters in the html for use in sed below
INSERTHTML=$(./escape-html.sh $INSERTHTML)

sed "s/{{blog_posts}}/$INSERTHTML/" ../templates/_blog.html > ../blog.html

# sed -i "" "s/{{blog_posts}}/$INSERTHTML/" ./index.html

# clean up temporary html fragments
rm ../markdown/blog/*.html

echo "    ...blog posts complete\n"