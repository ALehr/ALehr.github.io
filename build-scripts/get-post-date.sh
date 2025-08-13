#!/bin/zsh

file=$1

# date format = YYYY-MM-DD
validDateRegex='^[0-9]{4}-[0-9]{2}-[0-9]{2}$'

# check for valid date in file name
postDate=$(basename "$file" .md)
if [[ $postDate =~ $validDateRegex ]]; then
    echo $postDate
    return 0
fi

# check for valid date in yaml front matter
postDate=$(yq --front-matter=extract '.date' $file)
if [[ $postDate =~ $validDateRegex ]]; then
    echo $postDate
    return 0
fi

# get date from creation date of the file
postDate=$(GetFileInfo -d $file)



echo $postDate