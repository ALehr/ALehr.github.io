#!/bin/zsh

echo "\nbeginning build process...\n"
cd build-scripts

# Create Homepage Sections
./build-homepage.sh

# Create Blog Posts
./build-blog-posts.sh

# Create Reviews
./build-reviews.sh

echo "...build process complete\n"