#!/bin/bash

# Clear up
rm -rf dist
mkdir -p dist

# Find all JavaScript files within src/components directory
JS_FILES=$(find src/components -type f -name "doge-*.js")
CSS_FILES=$(find src/components -type f -name "*initial.css")

# For each JS file, copy it to the root for convenient
# consumption from fetch.dogecoin.org/<component>.js
for file in $JS_FILES
do
   filename=$(basename "$file")
   echo "JS File: $filename"
   cp "$file" "dist/$filename"
done

# For each css file, concatinate and create a single file
# for component consumers to include within the <head>
# of their webpage, to reduce flash of unstyled content.
for file in $CSS_FILES
do
   echo "CSS File: $file"
   cat "$file" >> "dist/initial.css"
   echo >> "dist/initial.css" #Adds line
done

# Write CNAME file
echo "fetch.dogecoin.org" > dist/CNAME
echo "fetch.dogecoin.org" > CNAME

# Copy the static files to the dist directory.
cp src/index.html dist/index.html
cp src/index.css dist/index.css
cp -R src/lib dist/lib
cp -R resources dist/
cp -R example dist/

# Write some version data
echo "Commit:$(git log -1 --pretty=format:%h)" >> dist/version.txt
echo "UTC:$(date -u)" >> dist/version.txt

# Run docs script.
./build-docs.sh
