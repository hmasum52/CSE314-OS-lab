#!/bin/bash

expr 4 + 5 # print 9
x=$((4+5)) # print 9
echo $x
x=$((5*4))
echo $x 
echo $((2+3)) # print 5

x=$(ls)
echo $x # print all file name in current directory