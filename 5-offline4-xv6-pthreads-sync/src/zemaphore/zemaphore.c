#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <string.h>
#include <errno.h>
#include <signal.h>
#include <wait.h>
#include "zemaphore.h"

/**
 * @brief  initializes the specified zemaphore 
 * to the specified value s
 *
 * @param s is the specified zemaphore
 * @param value is the value to initialized
 */
void zem_init(zem_t *s, int value) {
    s->value = value;
    s->cond = PTHREAD_COND_INITIALIZER;
    s->lock = PTHREAD_MUTEX_INITIALIZER;
}

/**
 * decrements the counter value of the zemaphore 
 * by one. If the value is negative, the thread 
 * blocks and is context switched out, to be 
 * woken up by an up operation on the
 * zemaphore at a later point.
 */
void zem_down(zem_t *s) {
    pthread_mutex_lock(&s->lock);
    while(s->value<=0){
        pthread_cond_wait(&s->cond, &s->lock);
    }
    s->value--;
    pthread_mutex_unlock(&s->lock);
}

/**
 * increments the counter value of the zemaphore
 * by one, and wakes up any
 * one sleeping thread.
 */
void zem_up(zem_t *s) {
    pthread_mutex_lock(&s->lock);
    s->value++;
    pthread_cond_signal(&s->cond);
    pthread_mutex_unlock(&s->lock);
}
