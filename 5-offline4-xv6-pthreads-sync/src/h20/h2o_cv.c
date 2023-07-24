#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

int hydrogen_count = 0; // number of hydrogen available for h2o production
int oxygen_count = 0;   // number of oxygen available fpr h2o production

pthread_mutex_t lock;
pthread_cond_t oxygen_queue, hydrogen_queue;

int total_molecules = 0; // total number of h2o produced

int max_h2o = 6; // maximum number of h2o that we want to produce
int hyrdo_t_cnt = 20; // number of hydrogen threads count
int oxy_t_cnt = 70;   // number of oxygen threads count

void bond()
{
    total_molecules++;
    hydrogen_count -= 2;
    oxygen_count--;
    printf("------------------------\n");
    printf("H20 produced\n");
    printf("total h20: %d\n", total_molecules);
    printf("------------------------\n");
}

void *produce_hydrogen(void *data)
{
    int thread_id = data;

    while (1)
    {
        // acquire lock
        pthread_mutex_lock(&lock);
        if (total_molecules == max_h2o)
        {
            pthread_mutex_unlock(&lock);
            break;
        }

        // produce hydrogen
        hydrogen_count++;

        printf("Thread %d: Hydrogen produced\n", thread_id);
        printf("Oxygen: %d, hydrogen: %d \n\n", oxygen_count, hydrogen_count);

        if (hydrogen_count >= 2 && oxygen_count >= 1)
        {
            // produce water
            printf("Hydrogen is ready for H20 production\n");

            // wake hydrogen and oxygen thread
            pthread_cond_signal(&hydrogen_queue);
            pthread_cond_signal(&oxygen_queue);

            bond();
            if (total_molecules == max_h2o)
            {
                // printf("finishing hydro thread from master: %d\n", thread_id);
                pthread_cond_broadcast(&hydrogen_queue);
                pthread_cond_broadcast(&oxygen_queue);
                pthread_mutex_unlock(&lock);
                break;
            }
        }
        // wait
        else
        {
            pthread_cond_wait(&hydrogen_queue, &lock);
        }
        pthread_mutex_unlock(&lock);
    }
    // printf("ending hydro %d\n", thread_id);
    pthread_exit(NULL);
}

void *produce_oxygen(void *data)
{
    int thread_id = data;

    while (1)
    {
        // acquire lock
        pthread_mutex_lock(&lock);
        if (total_molecules == max_h2o)
        {
            pthread_mutex_unlock(&lock);
            break;
        }

        // procude oxygen
        oxygen_count++;

        printf("Thread %d: Oxygen produced\n", thread_id);
        printf("Oxygen: %d, hydrogen: %d \n\n", oxygen_count, hydrogen_count);

        if (oxygen_count == 1 && hydrogen_count >= 2)
        {
            // produce water
            printf("Oxygen is ready for H20 production\n");

            // wake hydrogen and oxygen thread
            pthread_cond_signal(&hydrogen_queue);
            pthread_cond_signal(&hydrogen_queue);

            bond();
            if (total_molecules == max_h2o)
            {
                pthread_cond_broadcast(&hydrogen_queue);
                pthread_cond_broadcast(&oxygen_queue);
                pthread_mutex_unlock(&lock);
                // printf("finishing oxy thread from master: %d\n", thread_id);
                break;
            }
        }

        // else hobe
        else
        {
            pthread_cond_wait(&oxygen_queue, &lock);
        }
        pthread_mutex_unlock(&lock);
    }
    // printf("ending oxy %d\n", thread_id);
    pthread_exit(NULL);
}

int main(int argc, char const *argv[])
{
    if (argc < 4)
    {
        printf("./h2o_cv #max_h2o #h2_thread #o2_thread\n");
        exit(1);
    }
    else
    {
        max_h2o = atoi(argv[1]);
        hyrdo_t_cnt = atoi(argv[2]);
        oxy_t_cnt = atoi(argv[3]);
    }

    pthread_t hydro_threads[hyrdo_t_cnt];
    pthread_t oxy_threads[oxy_t_cnt];

    // init lock and cvs
    pthread_mutex_init(&lock, NULL);
    pthread_cond_init(&hydrogen_queue, NULL);
    pthread_cond_init(&oxygen_queue, NULL);

    // create thread
    for (int i = 0; i < hyrdo_t_cnt; i++)
    {
        pthread_create(&hydro_threads[i], NULL, produce_hydrogen, (void *)i);
    }
    for (int i = 0; i < oxy_t_cnt; i++)
    {
        pthread_create(&oxy_threads[i], NULL, produce_oxygen, (void *)i);
    }

    // join
    for (int i = 0; i < hyrdo_t_cnt; i++)
    {
        pthread_join(hydro_threads[i], NULL);
        // printf("hydro thread %d joined\n", i);
    }
    printf("all hydro thread joined\n");
    for (int i = 0; i < oxy_t_cnt; i++)
    {
        pthread_join(oxy_threads[i], NULL);
        // printf("ox thread %d joined\n", i);
    }
    printf("all oxy thread joined\n");

    // destroy
    pthread_mutex_destroy(&lock);
    pthread_cond_destroy(&hydrogen_queue);
    pthread_cond_destroy(&oxygen_queue);
    return 0;
}
