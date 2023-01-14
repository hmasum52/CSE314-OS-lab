#!/bin/bash
(($# <= 1))&&echo "no file name found"&&exit 1


# for debugging 
echo -n "file names: "
for fileName in $@
do 
    echo -n "$fileName "
done
echo ""



