echo "Running h20_zem.c"
gcc zemaphore.c h2o_zem.c -o a -lpthread
./a $1 $2 $3
rm a