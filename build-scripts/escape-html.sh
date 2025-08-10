#!/bin/zsh

HTML=$1
HTML=${HTML//\</\\<}
HTML=${HTML//\>/\\>}
HTML=${HTML//\//\\/}
HTML=${HTML//\&/\\&}
HTML=${HTML//$'\n'/" "}

echo $HTML