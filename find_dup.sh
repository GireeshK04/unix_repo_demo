#!/bin/bash

# Duplicate File Finder Script using MD5 checksums

TARGET_DIR="$1"

# Check if a directory was provided
if [ -z "$TARGET_DIR" ]; then
    echo "Usage: $0 <directory>"
    echo "Example: $0 /path/to/my/folder"
    exit 1
fi

# Check if the provided path is a valid directory
if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Directory '$TARGET_DIR' not found or is not a directory."
    exit 1
fi

echo "Searching for duplicate files in '$TARGET_DIR'..."
echo "---"

# The core command sequence:
# 1. find: Recursively finds all files (-type f) in the target directory.
# 2. -print0: Prints the file path separated by a null character to safely handle spaces/special characters in filenames.
# 3. xargs -0 md5sum: Reads null-separated input and calculates the MD5 checksum for all files.
# 4. sort: Sorts the output, which groups files with identical checksums (content) together.
# 5. uniq: Filters the sorted list to show only the lines that are repeated (duplicates).
#    - -w 32: Only compare the first 32 characters (the MD5 hash).
#    - --all-repeated=separate: Print all duplicates in each group, separated by blank lines.

find "$TARGET_DIR" -type f -print0 | \
    xargs -0 md5sum 2>/dev/null | \
    sort | \
    uniq -w 32 --all-repeated=separate

echo "---"
echo "Finished."
