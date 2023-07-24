#include "rwlock.h"

void InitalizeReadWriteLock(struct read_write_lock * rw)
{
  //	Write the code for initializing your read-write lock.
  rw->reader_count=0;
  rw->writer_count=0;
  rw->reader_waiting=0;
  rw->writer_waiting=0;
  pthread_mutex_init(&rw->sync_lock,NULL);
  pthread_cond_init(&rw->read,NULL);
  pthread_cond_init(&rw->write,NULL);
}

void ReaderLock(struct read_write_lock * rw)
{
  //	Write the code for aquiring read-write lock by the reader.
  pthread_mutex_lock(&rw->sync_lock);
  while(rw->writer_count==1 || rw->writer_waiting>0){
    rw->reader_waiting++;
    // printf("reader waiting\n");
    pthread_cond_wait(&rw->read,&rw->sync_lock);
    rw->reader_waiting--;
    // printf("reader awaken\n");
  }
  rw->reader_count++;
  // printf("reader acquired\n");
  pthread_mutex_unlock(&rw->sync_lock);
}

void ReaderUnlock(struct read_write_lock * rw)
{
  //	Write the code for releasing read-write lock by the reader.
  pthread_mutex_lock(&rw->sync_lock);
  rw->reader_count--;
  if(rw->reader_count==0){
    // printf("reader broadcast to writer\n");
    pthread_cond_broadcast(&rw->write);
  }
  pthread_mutex_unlock(&rw->sync_lock);
}

void WriterLock(struct read_write_lock * rw)
{
  //	Write the code for aquiring read-write lock by the writer.
  pthread_mutex_lock(&rw->sync_lock);
  while(rw->writer_count==1 || rw->reader_count>0){
    rw->writer_waiting++;
    // printf("writer waiting\n");
    pthread_cond_wait(&rw->write,&rw->sync_lock);
    rw->writer_waiting--;
    // printf("writer woke up\n");
  }
  rw->writer_count=1;
  // printf("writer acquired\n");
  pthread_mutex_unlock(&rw->sync_lock);
}

void WriterUnlock(struct read_write_lock * rw)
{
  //	Write the code for releasing read-write lock by the writer.
  pthread_mutex_lock(&rw->sync_lock);
  rw->writer_count=0;
  if(rw->reader_waiting>0 && rw->writer_waiting==0){
    // printf("writer broadcast to reader\n");
    pthread_cond_broadcast(&rw->read);
  }
  else{
    pthread_cond_broadcast(&rw->write);
    // printf("writer broadcast to writer\n");
  }
  pthread_mutex_unlock(&rw->sync_lock);
}
