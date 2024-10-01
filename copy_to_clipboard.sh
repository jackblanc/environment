#!/bin/zsh

# Define the directory to list files from
DIRECTORY=${1:-$(pwd)}  # Use current directory if no argument is given

# Check if the directory exists
if [ ! -d "$DIRECTORY" ]; then
    echo "Directory $DIRECTORY does not exist."
    exit 1
fi

# Initialize output with a header for the file list
OUTPUT="List of Files Included:\n\n"
FILES_LIST=""

# Gather the list of files recursively
while IFS= read -r FILE; do
    if [ -f "$FILE" ]; then
        FILES_LIST+="$(realpath "$FILE")\n"
    fi
done < <(find "$DIRECTORY" -type f)

# Add file list to the output
if [ -z "$FILES_LIST" ]; then
    echo "No files found in $DIRECTORY."
    exit 1
else
    OUTPUT+="$FILES_LIST\n\n"
fi

# Process and add the content of each file to the output
while IFS= read -r FILE; do
    if [ -f "$FILE" ]; then
        OUTPUT+="--- Start of File: $FILE ---\n\n"
        OUTPUT+="$(cat "$FILE")\n"
        OUTPUT+="\n--- End of File: $FILE ---\n\n"
    fi
done < <(find "$DIRECTORY" -type f)

# Copy to clipboard
echo -e "$OUTPUT" | pbcopy  # For macOS
# echo -e "$OUTPUT" | xclip -selection clipboard  # For Linux with xclip

echo "All files from $DIRECTORY (recursively) and their contents have been copied to the clipboard."
