#!/bin/bash

# var=$([[ CONDITION ]] && X || Y )
# -z = empty string
max_score=$( [[ -z $1 ]]&&echo "100" || echo $1)
max_student_id=$( [[ -z $2 ]]&&echo "5" || echo $2)

## check if the param is a number or not
validateInput() {
    re='^[0-9]+$'
    if ! [[ $1 =~ $re ]] ; then
        echo "error: $1 is not a number"; exit 1
    fi
}

checkIfDirectoryExists() {
    if [[ ! -d $1 ]]; then
        echo "false"
    else 
        echo "true"
    fi
}

checkIfFileExists() {
    if [[ ! -f $1 ]]; then
        echo "false"
    else 
        echo "true"
    fi
}

validateInput $max_score
validateInput $max_student_id

# echo "max score: $max_score"
# echo "Student id: $max_student_id"

######################################################
#### run the student sh file, using the student's ####
#### folder as the working directory              ####
######################################################
scores={}
for (( i=0; i<$max_student_id; i++ ))
do 
    # echo "Student ID: $i"
    sid=$((1805121+$i))
    if [[ -d "Submissions/$sid" ]]; then
        cd Submissions/$sid # change to the student's folder
        if [[ -f "./$sid.sh" ]]; then
            echo "file exists: $sid/$sid.sh"
            bash ./$sid.sh > $sid.txt # capture the student's output into a text file
            cd ../.. # change back to the parent folder
        else
            cd ..
        fi
    else 
        echo "directory does not exist: $i"
        scores[i]="0"
    fi
    
done

###############################################################
#### compare the student's output with the expected output ####
###############################################################
for (( i=0; i<$max_student_id; i++ ))
do 
    sid=$((1805121+$i)) # student id
    count=$(diff -w Submissions/$sid/$sid.txt AcceptedOutput.txt | grep -E '<|>' | wc -l)
    scores[i]=$(($max_score - $count*5))
    # scores[i]=$([[ ${scores[i]} -lt 0 ]] && echo "0" || echo ${scores[i]})
    scores[i]=$( ((${scores[i]}<0)) && echo "0" || echo ${scores[i]})
done

######################
#### copy checker ####
######################
applyCopyCheckerPenalty() {
    # negate the score if score is positive
    echo $( (($1<0))&&echo $1} || echo $((-$1)) )
}

isCopied() {
    # -BZw -> ignore blank lines, trailing blanks, and white space
    count=$(diff -BZw Submissions/$1/$1.sh Submissions/$2/$2.sh | grep -E '<|>' | wc -l)
    [[ $count -eq 0 ]] && echo "true" || echo "false"
}

for (( i=0; i<$max_student_id; i++ ))
do
    for (( j=i+1; j<$max_student_id; j++ ))
    do 
        if $( isCopied $((1805121+$i)) $((1805121+$j)) )
        then
            scores[i]=$( applyCopyCheckerPenalty ${scores[i]} )
            scores[j]=$( applyCopyCheckerPenalty ${scores[j]} )
            # echo "found guilty. $sid: Score: ${scores[i]}, $sid2: Score: ${scores[j]}"
        fi
    done
done


######################
#### save scores  ####
######################
echo "Scores:"
echo "student_id,score" > output.csv
for (( i=0; i<$max_student_id; i++ ))
do
    sid=$((1805121+$i)) # student id
    echo "Student ID: $sid, Score: ${scores[i]}"
    echo "$sid,${scores[i]}" >> output.csv
done


#####################################
#### delete student output files ####
#####################################
for (( i=1805121; i<(($max_student_id+1805121)); i++ ))
do 
    rm Submissions/$i/$i.txt
done

exit 0 # Exit with a status of 0