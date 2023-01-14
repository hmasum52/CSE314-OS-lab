myfunc() {
    echo "myfunc was called"
    echo "value passed: $1"
    # return korar way hoilo echo
    # or return <some_value> : recommended na 
}

# echo "outside func: $1"

# myfunc 10 # print result to console
x=$(myfunc 10) # store result to variable
echo $x # print result to console

# ./func.sh 12