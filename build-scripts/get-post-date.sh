#!/bin/zsh

file=$1

# valid date format = YYYY-MM-DD
validDateRegex='^[0-9]{4}-[0-9]{2}-[0-9]{2}$'

# 1. check for valid date in yaml front matter
postDate=$(yq --front-matter=extract '.date' $file)
if [[ $postDate =~ $validDateRegex ]]; then
    echo $postDate
    exit 0
fi

# 2. check for valid date in file name
postDate=$(basename "$file" .md)
if [[ $postDate =~ $validDateRegex ]]; then
    echo $postDate
    exit 0
fi

# 3. get date from creation date of the file
creationDate=$(GetFileInfo -d $file)

# extract date components
month=$(echo "$creationDate" | cut -d'/' -f1)
day=$(echo "$creationDate" | cut -d'/' -f2)
year_and_time=$(echo "$creationDate" | cut -d'/' -f3)

# extract year and time separately
year=$(echo "$year_and_time" | cut -d' ' -f1)
# time=$(echo "$year_and_time" | cut -d' ' -f2)

# Reassemble into yyyy-mm-dd format with time
postDate="${year}-${month}-${day}"

echo $postDate