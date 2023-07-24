# cmd 1
date
# >> Tue Nov 22 19:40:36 +06 2022

# cmd 2
which date # find the directory of the date command
# >> /usr/bin/date

# cmd 3
echo $PATH # print all the path directories
# >> /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin

# cmd 4
pwd # print present working deirectory

# cmd 5
ls # list all the files in the current directory
ls -1 # list all the files in the current directory in a single column
ls -l # list all the files in the current directory with details
ls -a # list all the files in the current directory including hidden files
ls -a1 # list all the files in the current directory including hidden files in a single column
ls -l test.sh # details of the test.sh file
# ls -l <file_name> # details of the file_name file
# ls -l <directory_name> # details of the directory_name directory


# cmd 6
cd # change directory
cd ~ # change directory to home directory
cd - # change directory to previous directory
cd .. # change directory to parent directory
cd . # change directory to current directory(no use)
cd / # change directory to root directory
cd /home # change directory to home directory
cd test # change directory to test directory relative to the current directory

# cmd 7 # clear the terminal
clear
# or crtl + l

# cmd 8
# change the mode (permissions) of a file or directory
chmod a+x test.sh # make the file executable
chmod a-x test.sh # make the file non-executable
chmod o+x test.sh # make the file executable for others
chmod 775 test.sh # make the -rwxrwxr-x -> 111 111 101 -> 7 7 5

# permission of the file
# rwx rwx rwx -> owner group any
# r : read , w : write , x : execute, - : no permission
# directory permission: 
#   r -> ls into that directory
#   x -> search into that directory
#   w -> modify the directory

# cmd 9
touch dummy.txt # create a dummy file
rm dummy.txt # remove the dummy file
touch .hidden.txt # create a hidden file
# ls -a # list all the files including hidden files
rm .hidden.txt # remove the hidden file

# ##### file opearations #####
# cmd 10
cat intro.sh # print the content of the file
cat a.cpp test.sh # concatenate the content of the files

# cmd 11
head -n3 intro.sh # print the first 3 lines of the file
tail -n3 intro.sh # print the last 3 lines of the file

# cmd 12
man ls # print the manual for ls . use j to navigate down and k to navigate up and q to quit

# cmd 13
# install tldr
sudo apt install tldr
tldr -u

tldr ls # print the manual for ls . use j to navigate down and k to navigate up and q to quit

# cmd 14
mkdir test test1 # create two directories
rmdir test test1 # remove the two directories recursively
rm -r test test1 # remove the two directories recursively
rm -ri test test1 # remove the two directories recursively with confirmation

# cmd 15
mv test.sh test # move the file test.sh to the directory test
mv a.cpp test
mv a.cpp b.cpp # rename the file a.cpp to b.cpp
mv ../a.cpp . # move the file a.cpp to the current directory from the parent directory
mv test dir # rename the directory test to dir

# copy
cp dir/a.cpp a.cpp # copy the file a.cpp to the current directory and create the file if not exists
# replace the file if exists

# I/O redirection
# cmd 16
echo "12  15"> in.txt # write 12 15 to the file in.txt, create the file if not exists
./a.out < in.txt # read from the file in.txt
./a.out < in.txt > out.txt # read from in.txt and write to out.txt

echo -e "#include<bits/stdc++.h>
using namespace std;
int main(){\n\
    cout<<\"Hello\"<<endl;\n\
    return 0;\n\
}" > hello.cpp # write the code to the file a.cpp

## PIPELINES ##
wc -l a.cpp # count the number of lines in the file a.cpp
ls -l | wc -l # count the number of files in the current directory

echo -e "Twinkle twinkle little star\n
How I wonder what you are\n
Up above the wolrd so high\n
Like a diamond in the sky" > twinkle.txt
head -n3 twinkle.txt # print the first 3 lines of the file
# print line 3
cat twinkle.txt | head -n3 | tail -n1

# grep
# grep <pattern> <file_name>
grep "the" twinkle.txt # print the lines containing the word "the"
grep -i "I" twinkle.txt # print the lines containing the word "the" ignoring the case
# or
cat twinkle.txt | grep -i "I" # print the lines containing the word "the" ignoring the case
grep -v "the" twinkle.txt # print the lines not containing the word "the"


# grep all the words containing i ignoring the case
# convert upper case to lower case
# sort the words
# remove the duplicate words
grep -o -i  "\w*i\w*" twinkle.txt | tr '[:upper:]' '[:lower:]'  |sort | uniq

## VARIABLES ##
x=10 # declare a variable x and assign 10 to it
# can't use spaces

echo $x # print the value of the variable x

x = 10 # error: can't use spaces
#o/p: x: command not found
echo "Hello $x" # prints Hello 10
echo 'Hello $x' # prints Hello $x

((x = x + 1)) # increment the value of x by 1
echo $x # prints 11