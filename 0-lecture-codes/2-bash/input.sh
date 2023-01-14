# use bash shell
# if use run the file in other machine, it still runs in bash

#!/bin/bash

# bash er sob variable string 
# x=12
# echo $x

echo -n "Enter a value: " # -n means no new line
# take user input using read
read val
echo $val # print without space
echo "$val" # print with space
