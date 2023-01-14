echo -e "hello world\nThis is masum2" > a.txt
echo -e "hello\nThis is masum" > b.txt

# diff a.txt b.txt
# diff -s a.txt b.txt # report when files are the same
# diff -y a.txt b.txt # outpout in two columns
# diff -y --suppress-common-lines a.txt b.txt # suppress common lines
# diff -w a.txt b.txt # ignore white space
# diff -i a.txt b.txt # ignore case
# diff -B a.txt b.txt # ignore blank lines
# diff -Z a.txt b.txt # ignore trailing blanks


x=$(diff -w a.txt b.txt | grep "<" | wc -l)
echo $x

# rm  a.txt b.txt
