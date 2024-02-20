#!/bin/bash

# Function to prompt user for tags (alphanumeric characters or hyphens only)
get_tags() {
    read -p "Enter tag(s) for waifu.im: " tags
    if [[ "$tags" =~ ^[a-zA-Z0-9-]+$ ]]; then
        echo "$tags"
    else
        echo "Error: Tags must consist of alphanumeric characters or hyphens only."
        exit 1
    fi
}

# Function to run the curl command and open the first valid preview link
search_and_display() {
    tag=$1
    command="curl -s -X GET 'https://api.waifu.im/search?included_tags=$tag&height=>=2000' -H 'Content-Type: application/json'"

    # Display the output of the command (used to see errors in the command, no longer needed)
#    echo "Command Output:"
#    eval "$command"

    # Run the command and extract the preview link using jq
    image_links=$(eval "$command" | jq -r '.images[0].preview_url')

    # Check if the preview link is non-empty and contains "https://www.waifu.im/preview/"
    if [ -n "$image_links" ] && [[ $image_links == *"https://www.waifu.im/preview/"* ]]; then
        # Open the valid image link in a web browser
        xdg-open "$image_links"
    else
        # If no valid preview link is found
        echo "Error: Unable to retrieve a valid image link from waifu.im."
        exit 1
    fi
}

# Main script
tags=$(get_tags)
search_and_display "$tags"
