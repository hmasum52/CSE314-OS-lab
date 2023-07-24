# fact() {
#     if (( $1 <= 1 )); then echo 1
#     else echo $(( $1 * $(fact $(( $1 - 1 )) ) ))
#     fi
# }

fact() {
    if [ $1 -eq 0 ]; then 
        echo 1 
        return
    fi

    last=$(fact $(( $1 - 1 )))
    echo $(( $1 * $last ))
}

fact $1