#!/bin/zsh

OUTPUTDIRECTORY=$1

echo "    building homepage..."

## generate html fragments from md files

for file in ../markdown/homepage/*.md; do

  # generate temporary html file
  NEWFILE=$(echo $file | sed "s/.md/.html/")

  # set section id to md file name
  echo "<section id=\"$(basename $NEWFILE .html)\" class=\"card\">" > $NEWFILE

  # generate html from the md file
  pandoc $file -f gfm -t HTML >> $NEWFILE
  echo "</section>" >> $NEWFILE

done

## generate index.html page for the site

INSERTHTML="<!-- BEGIN converted .md from /markdown/homepage/ -->"

for file in ../markdown/homepage/*.html; do

  HTMLFRAG=$(<"$file")

  INSERTHTML+="$HTMLFRAG"

done

INSERTHTML+="<!-- END converted .md from /markdown/homepage/ -->"

# escape special characters in the html for use in sed below
INSERTHTML=$(./escape-html.sh $INSERTHTML)

sed "s/{{homepage_sections}}/$INSERTHTML/" ../templates/_index.html > $OUTPUTDIRECTORY/index.html

# clean up temporary html fragments
rm ../markdown/homepage/*.html

echo "    ...homepage complete\n"
