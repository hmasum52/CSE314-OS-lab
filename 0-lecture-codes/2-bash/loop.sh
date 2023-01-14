#!/bin/bash

# for var in list 
# do
#     command
# done

# c style for loop
for (( i=0; i<10; i++ ))
do
    echo -n "$i "
done
echo "" # print newline

# c style for loop
for i in {1..5}
do
    echo -n "$i "
done
echo "" # print newline

for f in $(ls)
do
    echo -n "$f "
done
echo ""


for f in `ls`
do
    echo -n "$f "
done
echo ""

# list of files in a directory
# for file in * ; do
#     echo -n "$file is: "
#     if [[ -f $file ]]; then # -f means file : true if the file is regular file
#         echo "regular file"
#     elif [[ -d $file ]]; then
#         echo "directory"
#     else
#         echo "something else"
#     fi

# run the script serially
for i in {1..5}
    # ./script.sh 
    # ./script1.sh
    # ./script2.sh 
done 

# run the script in parallel
for i in {1..5}
    # ./script.sh &
    # ./script1.sh &
    # ./script2.sh &
done 