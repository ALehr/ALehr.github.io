#!/bin/zsh

postHTML=$1

preview=${postHTML#*"<h2>"}
preview=${preview%%"</p>"*}
preview="<h2>$preview</p>"

echo $preview