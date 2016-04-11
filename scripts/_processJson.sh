#!/usr/bin/env bash

regex="\<\<(.*)\>\>"

while read p; do
if [[ $p =~ $regex ]]; then
    name="${BASH_REMATCH[1]}"
    image=$(base64 images/${name})
    echo \"image\": \"${image}\"
else 
    echo $p
fi
done < $1  
