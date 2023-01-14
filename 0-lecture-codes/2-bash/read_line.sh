#!/bin/bash

# only 1 argument is expected
(($# != 1 )) && exit 1

pat=$1 # pattern to search

# while read line; do
#     if echo "$line" | grep -q "$pat"; then
#         echo "\"$line\" contains $pat"
#     fi
# done


# IFS (or IFS='') prevents leading/trailing whitespace from being trimmed
# -r prevents backslash escapes from being interpreted
while IFS= read -r line; do
    if echo "$line" | grep -q "$pat"; then
        echo "\"$line\" contains $pat" >> out.txt # append to file
    fi
    # find the line with cin
    # if grep -q "cin" <(echo "$line"); then
    #     echo "found cin in \"$line\""
    # fi
done

# run
# find pattern "in" in the file a.cpp
#  ./read_line.sh in < a.cpp