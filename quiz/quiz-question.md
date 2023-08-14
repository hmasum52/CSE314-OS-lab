# Final Quiz Question CSE313(CSE18 batch)

> ⚠️Disclaimer: I have no idea why I wrote this query down after the quiz. There were more questions on the exam but I only remember these few. Also, I don't exactly recall the questions🤔.So, please read at your  own risk! 👈👈

## MCQ:🤔
1) what is the total number of virtual address in xv6-riscv?
2) What is the size of the memory in xv6-riscv?
3) what happens when a process tries to allocate more memory than available physicall memory in xv6?

## CQ:✍
### Question 1: 

Write system call for adding username in xv6.

---
### Question 2:

```
// thread1 
void *printA(){
	while(1)
	printf("A");
}
// thread2
void *printB(){
	while(1)
	printf("B");
}
```
use semaphore in both thread so that output is "ABBABBABBABB..."
that is everytime one "A" is printed only after "B" printed twice.

---

### Question 3
```
semaphore U=3
semaphore V=0
// process 1
L1: 
   wait(U);
   print("C");
   post(V);
   goto L1
// process 2
L2:
  wait(V)
  print("A")
  print("B")
  post(V)
  goto L2
// process 3
L3:
  wait(V)
  print("D")
  goto L3
```
write nesseary codes

---

### Question 4
```
genarete.py => generate random input
naive.py => runs a naive algorithm to generate output
bug.py => generate correct ouput most of the time but fials for some input
```
caputure the 1st input in input.txt for which bug.py fails and prints the number of attempt before failing
hint: use diff file1 file2 returns 0 if 2 file have same contents

### Question 5
```
for i in {1..1000}; do
	python intensive.py # run in background without blockings
done
```
write a script to run 5 instances of intensive.py simultananeasouly and wait.
then run next 5 and wait and so on