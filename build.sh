#!/bin/zsh

OUTPUTDIRECTORY="/Users/anthonylehr/GitHub/blog-repos/test"

# copy images, css, and javascript to static directory
cp -r images $OUTPUTDIRECTORY/images
cp -r css $OUTPUTDIRECTORY/css
cp -r javascript $OUTPUTDIRECTORY/javascript

echo "\nbeginning build process...\n"
cd build-scripts

# Create Homepage Sections
./build-homepage.sh $OUTPUTDIRECTORY

# Create Blog Posts
./build-blog-posts.sh $OUTPUTDIRECTORY

# Create Reviews
./build-reviews.sh $OUTPUTDIRECTORY

echo "...build process complete\n"
