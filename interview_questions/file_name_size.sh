# Write a Bash script to check if a file exists and display its size.
#!/bin/bash

file=$1
if [ -e "$file" ]; then
        echo "file exits."
        size=$(ls -ltr|grep $file|awk '{print $5}') # $(stat -c %s $file)
        # size=$(stat -c %s "$file") # This command can also be used to get the file size
        # size=$(wc -c <"$file") # This command can also be used to get the file size
        # size=$(du -b "$file" | cut -f1) # This command can also be used to get the file size
        echo "file size of '$file': $size bytes"
else
 echo "file does not exit"
fi
# Usage: ./file_name_size.sh <filename>
# Example: ./file_name_size.sh test.txt
# Output:
# file exits.
# file size of 'test.txt': 1234 bytes
# or
# file does not exit
# Note: The script checks if the file exists and then uses `ls -ltr` to get the file size in bytes.
# The `awk` command is used to extract the size from the output of `ls -ltr`.
