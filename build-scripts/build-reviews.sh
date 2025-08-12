#!/bin/zsh

## generate html fragments from md files

for file in ../markdown/reviews/*/*.md; do

    # generate temporary html file
    NEWFILE=$(echo $file | sed "s/.md/.html/")

    # generate heading and handle link
    TITLE=$(yq --front-matter=extract '.title' $file)
    URL=$(yq --front-matter=extract '.url' $file)
    validURLRegex='(https?|ftp|file)://[-[:alnum:]\+&@#/%?=~_|!:,.;]*[-[:alnum:]\+&@#/%=~_|]'
    if [[ $URL =~ $validURLRegex ]]; then
        echo "<h3><a href=\"$URL\">$TITLE</a></h3>" > $NEWFILE
    else
        echo "<h3>$TITLE</h3>" > $NEWFILE
    fi
    
    # insert author name if present
    AUTHOR=$(yq --front-matter=extract '.author' $file)
    if [ "$AUTHOR" != "null" ]; then
        echo "<p class=\"author\">by $AUTHOR</p>" >> $NEWFILE
    fi

    # process star ratings
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
    
    # process body of review
    pandoc $file -f gfm -t HTML >> $NEWFILE
done

# insert generated html into index.html

INSERTHTML="<!-- BEGIN converted .md from /markdown/reviews/ -->"

# create a section for each category folder
category=$(ls ../markdown/reviews/ | head -n 1)
INSERTHTML+="<section id=\"$category\"><h2>$category</h2>"
for file in ../markdown/reviews/*/*.html; do
    local parentFolder=$(basename $(dirname $file) | sed s/-/' '/g)
    if [ "$parentFolder" = "$category" ]; then
    else
        INSERTHTML+="</section>"
        category=$parentFolder
        INSERTHTML+="<section id=\"$category\"><h2>$category</h2>"
    fi
    
    HTMLFRAG="<div id=\"$(basename $file | sed s/.html//)\">$(<"$file")</div>"

    INSERTHTML+="$HTMLFRAG"
done

INSERTHTML+="</section><!-- END converted .md from /markdown/reviews/ -->"

# escape special characters in the html for use in sed below
INSERTHTML=$(./escape-html.sh $INSERTHTML)

sed s/{{review_posts}}/$INSERTHTML/ ../templates/_reviews.html > ../reviews.html

# clean up temporary html fragments
rm ../markdown/reviews/*/*.html