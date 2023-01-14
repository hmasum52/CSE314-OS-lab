#!/bin/bash

# echo -n "enter a string: "
# read val

# expected="xyz"

# if [ $val = $expected ] #string compare
# then
#     echo "match"
# else
#     echo "not match"
# fi

# # if [ $val -eq $expected ] #number compare
# echo -n "enter a number: "
# read val

# expected = 12

# if [ $val -eq $expected ] #number compare
# then
#     echo "match 12"
# else
#     echo "not match 12"
# fi


# https://www.computerhope.com/unix/test.htm
# if [ $((2+2)) -eq 4 ]; then 
#     echo "2+2 = 4"
# else 
#     echo "balsal"
# fi

# if [ $val = "abc" -a $val1 = "xyz" ];
# if [[ $val = "abc" && $val1 = "xyz" ]] # recommended

# if [[ $val -ge 10 && $val1 -le 100 ]] # and
# if (( $val >= 10 && $val1 <= 100 )) 

# echo $? # print exit status of last command (0 means success)
# if cmd; then # if cmd is success(exit staus 0)
#     echo "success"
# else
#     echo "fail"
# fi


if grep i b.cpp; then 
    echo "found"
else
    echo "not found"
fi