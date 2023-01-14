#!/bin/bash

# var=$([[ CONDITION ]] && X || Y )
# -z = empty string
max_score=$( [[ -z $1 ]]&&echo "100" || echo $1)
max_student_id=$( [[ -z $2 ]]&&echo "5" || echo $2)

########################
#### Validate input ####
########################
## check if the param is a number or not
validateInput() {
    re='^[0-9]+$'
    if ! [[ $1 =~ $re ]] ; then
        echo "error: $1 is not a number"; exit 1
    fi
}
validateInput $max_score
validateInput $max_student_id


#######################################################
#### run the student sh file, using the student's  ####
#### folder as the working directory and compare   ####
#### the student's output with the expected output ####
#######################################################
scores={}
for (( i=0; i<$max_student_id; i++ ))
do 
    # echo "Student ID: $i"
    sid=$((1805121+$i))
    if [[ -d "Submissions/$sid" ]]; then
        cd Submissions/$sid # change to the student's folder
        if [[ -f "./$sid.sh" ]]; then
            # Compare the student’s output against the expected output file using diff
            # -w Run diff so that it ignores all white space 
            # definition of mismatch: number of < or a > 
            count=$(diff -w <(bash ./$sid.sh) ../../AcceptedOutput.txt | grep -E '<|>' | wc -l)
            # For each unmatched line, deduct 5 points from the student’s score
            scores[i]=$(($max_score - $count*5))
            scores[i]=$( ((${scores[i]}<0)) && echo "0" || echo ${scores[i]})
            cd ../.. # change back to the parent folder
        else
            scores[i]="0"
            cd ..
        fi
    else 
        # echo "directory does not exist: $sid"
        scores[i]="0"
    fi
done


######################
#### copy checker ####
######################

# if a student is caught in the copy-checker, 
# his/her score will be negative of his/her initial score
applyCopyCheckerPenalty() {
    # negate the score if score is positive
    echo $( (($1<0))&&echo $1} || echo $((-$1)) )
}

# definition of copy: two scripts copies of each other if they
# exactly match i.e: the diff command produces no output.
# trailing whitespaces and blank lines are ignored while comparing
isCopied() {
    # check if file exists
    if ! [[ -f "Submissions/$1/$1.sh" ]]; then
        echo "false"
        return
    fi 

    if ! [[ -f "Submissions/$2/$2.sh" ]]; then
        echo "false"
        return
    fi

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


###################################
#### save scores in output.csv ####
###################################
#echo "Scores:"
echo "student_id,score" > output.csv
for (( i=0; i<$max_student_id; i++ ))
do
    sid=$((1805121+$i)) # student id
    # echo "Student ID: $sid, Score: ${scores[i]}"
    echo "$sid,${scores[i]}" >> output.csv
done

exit 0 # Exit with a status of 0