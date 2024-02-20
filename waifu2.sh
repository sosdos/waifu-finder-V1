#!/bin/bash

# Function to prompt user for tags (alphanumeric characters or hyphens only)
get_tags() {
    read -p "Enter tag for waifu.im: " tags
    if [[ "$tags" =~ ^[a-zA-Z0-9-]+$ ]]; then
        echo "$tags"
    else
        echo "Error: Tags must consist of alphanumeric characters or hyphens only."
        exit 1
    fi
}

# Function to run the curl command, download the image, and open it in feh
search_and_display() {
    tag=$1
    command="curl -s -X GET 'https://api.waifu.im/search?included_tags=$tag&height=>=2000' -H 'Content-Type: application/json'"

    # Run the command and extract the image URL using jq
    image_url=$(eval "$command" | jq -r '.images[0].url')

    # Check if the image URL is empty or null
    if [ -z "$image_url" ] || [ "$image_url" == "null" ]; then
        echo "Error: Unable to retrieve a valid image URL from waifu.im."
        exit 1
    fi

    # Create the "homework" folder in the Downloads directory if it doesn't exist
    folder_path="$HOME/Downloads/homework"
    mkdir -p "$folder_path"

    # Extract the image filename from the URL
    image_filename=$(basename "$image_url")

    # Download the image to the "homework" folder
    curl -s "$image_url" -o "$folder_path/$image_filename"

    # Open the downloaded image in the default web browser
    xdg-open "file://$folder_path/$image_filename"
}

# Main script
tags=$(get_tags)
search_and_display "$tags"
