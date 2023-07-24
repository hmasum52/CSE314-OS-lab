#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <string.h>
#include <errno.h>
#include <signal.h>
#include <wait.h>
#include <pthread.h>

int item_to_produce, curr_buf_size;
int total_items, max_buf_size, num_workers, num_masters;

// number of items consumed
int items_consumed;

pthread_mutex_t lock;
pthread_cond_t empty,full;

int *buffer;

void print_produced(int num, int master) {

  printf("Produced %d by master %d\n", num, master);
}

void print_consumed(int num, int worker) {

  printf("Consumed %d by worker %d\n", num, worker);
  
}


//produce items and place in buffer
//modify code below to synchronize correctly
void *generate_requests_loop(void *data)
{
  int thread_id = *((int *)data);

  while(1)
    { 
      // printf("p1\n");
      pthread_mutex_lock(&lock);
      if(item_to_produce >= total_items) {
        // printf("p2\n");
        // unlock before breaking the loop
        pthread_mutex_unlock(&lock);
	      break;
      }
      // printf("p3\n");
      // check if buffer full, if full, go to sleep
      while(curr_buf_size==max_buf_size){
        // pthread_cond_signal(&empty);
        // printf("p4\n");
        pthread_cond_wait(&full,&lock);
        // printf("p5\n");
      }
      // wake up, first check again if item_to_produce
      // exceeded items_count while it was sleeping, otherwise fill
      // up the buffer
      // printf("p6\n");
      if(item_to_produce>=total_items){
        pthread_mutex_unlock(&lock);
        break;
      }
      // printf("p7\n");
      buffer[curr_buf_size++] = item_to_produce;
      print_produced(item_to_produce, thread_id);
      item_to_produce++;
      // send signal to sleeping worker
      pthread_cond_broadcast(&empty);
      pthread_mutex_unlock(&lock);
      // printf("p8\n");
    }
    pthread_exit(NULL);
}

//write function to be run by worker threads
//ensure that the workers call the function print_consumed when they consume an item
void * consume_requests_loop(void * arg){
  int thread_id=*((int *)arg);
  while(1){
    // printf("c1\n");
    pthread_mutex_lock(&lock);
    if(items_consumed >= total_items) {
      //  printf("c2\n");
      // unlock before breaking the loop

      pthread_mutex_unlock(&lock);
	    break;
    }
    //check if buffer empty, if empty, go to sleep
    //  printf("c3\n");
    while(curr_buf_size==0){
      // pthread_cond_signal(&full);
      //  printf("c4 : worker : %d\n",thread_id);
      pthread_cond_wait(&empty,&lock);
      if(items_consumed>=total_items){
        // printf("c7\n");
        pthread_mutex_unlock(&lock);
      break;
      }
      //  printf("c5: worker: %d\n",thread_id);
    }
    // check already consumed all
    //  printf("c6\n");
    if(items_consumed>=total_items){
      // printf("c7\n");
      pthread_mutex_unlock(&lock);
      break;
       
    }
    // consume an item
    // printf("c8\n");
    int item_to_consume=buffer[--curr_buf_size];
    print_consumed(item_to_consume,thread_id);
    items_consumed++;
    // send signal to sleeping producer
    pthread_cond_broadcast(&full);
    pthread_mutex_unlock(&lock);
    // printf("c9\n");
  }
  pthread_exit(NULL);
}

int main(int argc, char *argv[])
{
  int *master_thread_id;
  pthread_t *master_thread;
  int *worker_thread_id;
  pthread_t *worker_thread;
  item_to_produce = 0;
  items_consumed=0;
  curr_buf_size = 0;
  // initialize lock
  pthread_mutex_init(&lock,NULL);
  //initialize condition variables
  pthread_cond_init(&empty,NULL);
  pthread_cond_init(&full,NULL);
  int i;
  
   if (argc < 5) {
    printf("./master-worker #total_items #max_buf_size #num_workers #masters e.g. ./exe 10000 1000 4 3\n");
    exit(1);
  }
  else {
    num_masters = atoi(argv[4]);
    num_workers = atoi(argv[3]);
    total_items = atoi(argv[1]);
    max_buf_size = atoi(argv[2]);
  }
    

   buffer = (int *)malloc (sizeof(int) * max_buf_size);

   //create master producer threads
   master_thread_id = (int *)malloc(sizeof(int) * num_masters);
   master_thread = (pthread_t *)malloc(sizeof(pthread_t) * num_masters);
  for (i = 0; i < num_masters; i++)
    master_thread_id[i] = i;

  for (i = 0; i < num_masters; i++)
    pthread_create(&master_thread[i], NULL, generate_requests_loop, (void *)&master_thread_id[i]);
  

  //create worker consumer threads
  worker_thread_id=(int *) malloc(sizeof(int) * num_workers);
  worker_thread=(pthread_t *)malloc(sizeof(pthread_t)*num_workers);
  for(i=0;i<num_workers;i++)
    worker_thread_id[i]=i;
  for(i=0;i<num_workers;i++)
    pthread_create(&worker_thread[i],NULL,consume_requests_loop,(void *) &worker_thread_id[i]);
  //wait for all threads to complete
  for (i = 0; i < num_masters; i++)
    {
      pthread_join(master_thread[i], NULL);
      printf("master %d joined\n", i);
    }
  for(i=0;i<num_workers;i++){
    pthread_join(worker_thread[i],NULL);
    printf("worker %d joined\n", i);
  }
  // printf("items produced:%d\n",item_to_produce);
  // printf("total_items: %d\n",total_items);
  // destroy condition variables
  pthread_cond_destroy(&empty);
  pthread_cond_destroy(&full);

  /*----Deallocating Buffers---------------------*/
  free(buffer);
  free(master_thread_id);
  free(master_thread);
  free(worker_thread_id);
  free(worker_thread);
  return 0;
}
