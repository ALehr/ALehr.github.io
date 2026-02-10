#!/bin/zsh

echo "    building blog posts..."

# delete previous contents of blog directory
rm ../blog/*.html

# generate html fragments from md post files

for file in ../markdown/blog/*.md; do

  # generate temporary html file
  NEWFILE=$(echo $file | sed "s/.md/.html/")

  # set article id to numeric date from md file name
  ARTICLETITLE=$(basename "$file" .md)
  echo "<article id=\"$ARTICLETITLE\" class=\"card\">" > $NEWFILE

  # convert article date to human readable format for html
  ARTICLETITLE=$(date -jf %F $ARTICLETITLE '+%A %-d %B %Y')
  echo "<h2>$ARTICLETITLE</h2>" >> $NEWFILE

  # generate html from the md file
  pandoc $file -f gfm -t HTML >> $NEWFILE

  echo "</article>" >> $NEWFILE

done

# create summary of blog posts to insert into blog/index.html
INSERTHTML=""

for file in ../markdown/blog/*.html; do

  # get contents of file
  HTMLFRAG=$(<"$file")

  FILENAME=$(basename "$file")

  # get preview for blog/index
  PREVIEW="<article id=\"${FILENAME%%.*}\">$(./get-post-preview.sh $HTMLFRAG)<p><a class=\"read-more\" href=\"./${FILENAME%%.*}\">...read more</a></p></article>"
  INSERTHTML="$PREVIEW$INSERTHTML"

  # create previous and next post buttons
  HTMLFRAG+=$(./previous-next-post-buttons.sh blog $FILENAME)

  # escape special characters in the html for use in sed below
  HTMLFRAG=$(./escape-html.sh $HTMLFRAG)

  #create standalone blog page for post
  sed "s/{{blog_posts}}/$HTMLFRAG/" ../templates/_blog.html > ../blog/$FILENAME

done

INSERTHTML="<!-- BEGIN converted .md from /markdown/blog/ -->$INSERTHTML"
INSERTHTML+="<!-- END converted .md from /markdown/blog/ -->"

# escape special characters in the html for use in sed below
INSERTHTML=$(./escape-html.sh $INSERTHTML)

# generate blog index page
sed "s/{{blog_posts}}/$INSERTHTML/" ../templates/_blog.html > ../blog/index.html

# sed -i "" "s/{{blog_posts}}/$INSERTHTML/" ./index.html

# clean up temporary html fragments
rm ../markdown/blog/*.html

echo "    ...blog posts complete\n"
