#!/bin/zsh

postHTML=$1

firstParagraph=${postHTML#*"<h2>"}
firstParagraph=${firstParagraph%%"</p>"*}

echo $firstParagraph