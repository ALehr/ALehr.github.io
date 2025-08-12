#!/bin/zsh

cd build-scripts

# Create Homepage Sections
./build-homepage.sh

# Create Blog Posts
./build-blog-posts.sh

# Create Reviews
./build-reviews.sh