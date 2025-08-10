#!/bin/zsh

## generate html from md files

for file in ../reviews/*.md; do
    NEWFILE=$(echo $file | sed "s/.md/.html/")
    TITLE=$(yq --front-matter=extract '.title' $file)
    URL=$(yq --front-matter=extract '.url' $file)
    echo "<h3><a href=\"$URL\">$TITLE</a></h3>" > $NEWFILE
    FULLSTARS=$(yq --front-matter=extract '.rating' $file)
    EMPTYSTARS=$(yq --front-matter=extract '.out-of' $file)
    EMPTYSTARS=$(($EMPTYSTARS - $FULLSTARS))
    RATINGSTARS="<p class=\"rating\">"
    while [ $FULLSTARS -gt 0 ]; do
        RATINGSTARS="$RATINGSTARS★"
        FULLSTARS=$(($FULLSTARS - 1))
    done
    while [ $EMPTYSTARS -gt 0 ]; do
        RATINGSTARS="$RATINGSTARS☆"
        EMPTYSTARS=$(($EMPTYSTARS - 1))
    done
    RATINGSTARS="$RATINGSTARS</p>"
    echo $RATINGSTARS >> $NEWFILE
    pandoc $file -f gfm -t HTML >> $NEWFILE
done

# insert generated html into index.html

INSERTHTML="<!-- BEGIN converted .md from \/reviews\/markdown\/ -->"
for file in ../reviews/*.html; do
    HTMLFRAG=$(<"$file")
    
    HTMLFRAG=$(./escape-html.sh $HTMLFRAG)

    INSERTHTML="${INSERTHTML} ${HTMLFRAG}"
done

INSERTHTML="${INSERTHTML}\n<!-- END converted .md from \/homepage_sections\/markdown\/ -->"

sed "s/{{review-posts}}/$INSERTHTML/" ../templates/_reviews.html > ../reviews.html

# clean up temporary html fragments
rm ../reviews/*.html