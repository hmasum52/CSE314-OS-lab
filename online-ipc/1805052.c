#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <string.h>
#include <errno.h>
#include <signal.h>
#include <wait.h>
#include <pthread.h>
#include "zemaphore.h"

#define NUM_THREADS 4
#define NUM_ITER 10

zem_t zems[NUM_THREADS];

char getName(int id){
    if(id == 0){
        return 'A';
    }else if(id == 1){
        return 'B';
    }else if(id == 2){
        return 'C';
    }
    return 'X';
}

int cnt = 0;
int last = 0;
int s_last = 0;

void *justprint(void *data)
{
    int thread_id = *((int *)data);

    for (int i = 0; i < NUM_ITER; i++)
    {
        zem_down(&zems[thread_id]);
        printf("%c\n", getName(thread_id));
        int r = rand()%3;
        while(r == last || r == s_last){
            r = rand()%3;
        }
        cnt++;
        if(cnt%4 == 0) {
            r = 3;
            cnt = 0;
        }
        s_last = last;
        last = r;
        zem_up(&zems[r]);
    }
    return 0;
}

int main(int argc, char *argv[])
{

    pthread_t mythreads[NUM_THREADS];
    int mythread_id[NUM_THREADS];

    for (int i = 0; i < NUM_THREADS; i++)
    {
        zem_init(&zems[i], 0);
    }
    zem_init(&zems[0], 1);

    for (int i = 0; i < NUM_THREADS; i++)
    {
        mythread_id[i] = i;
        pthread_create(&mythreads[i], NULL, justprint, (void *)&mythread_id[i]);
    }

    for (int i = 0; i < NUM_THREADS; i++)
    {
        pthread_join(mythreads[i], NULL);
    }

    return 0;
}
