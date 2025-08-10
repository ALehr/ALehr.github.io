#!/bin/zsh

## generate html from md files

for file in ../reviews/*/*.md; do
    NEWFILE=$(echo $file | sed "s/.md/.html/")
    TITLE=$(yq --front-matter=extract '.title' $file)
    URL=$(yq --front-matter=extract '.url' $file)
    echo "<h3><a href=\"$URL\">$TITLE</a></h3>" > $NEWFILE
    FULLSTARS=$(yq --front-matter=extract '.rating' $file)
    TOTALSTARS=$(yq --front-matter=extract '.out-of' $file)
    EMPTYSTARS=$(($TOTALSTARS - $FULLSTARS))
    RATINGSTARS="<p class=\"rating\">"
    while [ $FULLSTARS -gt 0 ]; do
        RATINGSTARS+="★"
        ((FULLSTARS -= 1))
    done
    while [ $EMPTYSTARS -gt 0 ]; do
        RATINGSTARS+="☆"
        ((EMPTYSTARS -= 1))
    done
    RATINGSTARS+="</p>"
    echo $RATINGSTARS >> $NEWFILE
    pandoc $file -f gfm -t HTML >> $NEWFILE
done

# insert generated html into index.html

INSERTHTML="<!-- BEGIN converted .md from /reviews/ -->"
category=$(ls ../reviews/ | head -n 1)
INSERTHTML+="<section id=\"$category\"><h2>$category</h2>"
for file in ../reviews/*/*.html; do
    local parentFolder=$(basename $(dirname $file))
    if [ "$parentFolder" = "$category" ]; then
    else
        INSERTHTML+="</section>"
        category=$parentFolder
        INSERTHTML+="<section id=\"$category\"><h2>$category</h2>"
    fi
    
    HTMLFRAG="<article id=\"$(basename $file | sed s/.html//)\">$(<"$file")</article>"

    INSERTHTML+="$HTMLFRAG"
done

INSERTHTML+="</section><!-- END converted .md from /reviews/ -->"

INSERTHTML=$(./escape-html.sh $INSERTHTML)

sed s/{{review_posts}}/$INSERTHTML/ ../templates/_reviews.html > ../reviews.html

# clean up temporary html fragments
rm ../reviews/*/*.html