ar={"cat" "dog" "mouse" "frog"}
ar[10]="far" 

for str in "${ar[@]}"; do 
    echo $str
done

for i in ${!ar[@]}; do 
    echo "element $i is ${ar[$i]}"
done