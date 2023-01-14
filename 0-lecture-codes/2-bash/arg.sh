# ./arg.sh 12 abc 
echo "total argument number $#"
echo "$1 $2" # print first and second arg

for arg in "$*"; do 
    echo $arg
done