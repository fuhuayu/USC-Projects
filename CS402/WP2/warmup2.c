

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/time.h>
#include <time.h>
#include <signal.h>
#include <math.h>
#include "cs402.h"
#include <pthread.h>
#include "my402list.h"
#include "pinput.c"


static
void SetProgramName(char *s)
{
  char *c_ptr=strrchr(s, DIR_SEP);

  if (c_ptr == NULL) {
    strcpy(gszProgName, s);
  } else {
    strcpy(gszProgName, ++c_ptr);
  }
}
double getTimeinMil(){
  struct timeval tv;
  gettimeofday(&tv,NULL);
  return tv.tv_sec*1000.0+tv.tv_usec/1000.0;
}
void ssleep(double time,int adjustment){
  long long tt=(time*1000000);
  if(time>(double)adjustment/1000.0){
    struct timespec t;
    if(time==10000.0){
      t.tv_sec=10;
      t.tv_nsec=0;
    }
    else if(tt%1000000000==0){
      t.tv_sec=tt/1000000000-1;
      t.tv_nsec=1000000000-adjustment*1000;
    }
    else{
    t.tv_sec=tt/1000000000;
    t.tv_nsec=tt%1000000000-adjustment*1000;}

    if(nanosleep(&t , NULL) < 0 )
     {
        fprintf(stderr,"filed to sleep\n");
     }
   }

}
int ProcessData(Packet* p,char* buffer,double* ct,int i){
  double l;
  sscanf(buffer,"%lf %lld %lf",&l,&(p->tokens),&(p->Stime));
  ssleep(l,(getTimeinMil()-*ct)*1000);
  *ct=getTimeinMil();
  p->number=i+1;
  p->arriveTime=getTimeinMil();
  p->enterQ1=0;
  p->leaveQ1=0;
  p->enterQ2=0;
  p->leaveQ2=0;
  p->enterS=0;
  p->leaveS=0;
  p->s=0;

  return TRUE;

}

void *threadP(){
  long long i=0;
  double prevTime=startTime,ct=startTime;
  char buffer[1026];
  for(i=0;i<num;i++){

    Packet* p=(Packet*)malloc(sizeof(Packet));
    if(mode==1){
      if(p!=NULL){
        if(fgets(buffer,sizeof(buffer),fp)==NULL){
          fprintf(stderr,"(input file is not in the right format)\n");
          exit(0);
        }

        if(!ProcessData(p,buffer,&ct,i)){
          fprintf(stderr,"(input file is not in the right format)\n");
          exit(0);
        }

      }
      else{
        fprintf(stderr, "cannot Allocate Memory for Packet\n");
        return (void*)0;
      }
    }
    else{
      double l=1.0/(double)lambda*1000;
      double s=1.0/(double)mu*1000;
      if(l>10000){
        l=10000;
      }
      if (s>10000){
        s=10000;
      }
      ssleep(l,(getTimeinMil()-ct)*1000);

      ct=getTimeinMil();
      if(p!=NULL){
        p->number=i+1;
        p->tokens=P;
        p->arriveTime=getTimeinMil();
        p->enterQ1=0;
        p->leaveQ1=0;
        p->enterQ2=0;
        p->leaveQ2=0;
        p->Stime=s;
        p->enterS=0;
        p->leaveS=0;
        p->s=0;
      }
      else{
        fprintf(stderr, "cannot Allocate Memory for Packet\n");
        return (void*)0;
      }
    }
    pthread_testcancel();
    pthread_mutex_lock(&m);
    pthread_setcancelstate(PTHREAD_CANCEL_DISABLE,0);
    if(p->tokens>bucket.depth){

      fprintf(stdout,"%012.3lfms: p%lld arrives, needs %lld tokens, inter-arrival time = %0.3lfms, dropped\n",
      getTimeinMil()-startTime,i+1,p->tokens,p->arriveTime-prevTime);
      sumInterArrival+=p->arriveTime-prevTime;
      prevTime=p->arriveTime;
      free(p);
      dropped+=1;
    }
    else{

      fprintf(stdout,"%012.3lfms: p%lld arrives, needs %lld tokens, inter-arrival time = %0.3lfms\n",
      getTimeinMil()-startTime,i+1,p->tokens,p->arriveTime-prevTime);
      sumInterArrival+=p->arriveTime-prevTime;
      prevTime=p->arriveTime;
      My402ListAppend(&listQ1,p);
      p->enterQ1=getTimeinMil();
      fprintf(stdout,"%012.3lfms: p%lld enters Q1\n",
      getTimeinMil()-startTime,i+1);
      if(My402ListLength(&listQ1)==1){
        if(bucket.num>=p->tokens){
          bucket.num-=p->tokens;
          p->leaveQ1=getTimeinMil();
          My402ListUnlinkAll(&listQ1);
          fprintf(stdout,"%012.3lfms: p%lld leaves Q1, time in Q1 = %0.3lfms, token bucket now has %lld token\n",
          getTimeinMil()-startTime,p->number,p->leaveQ1-p->enterQ1,bucket.num);
          p->enterQ2=getTimeinMil();
          My402ListAppend(&listQ2,p);
          fprintf(stdout,"%012.3lfms: p%lld enters Q2\n",
          getTimeinMil()-startTime,p->number);
          if(My402ListLength(&listQ2)==1)pthread_cond_signal(&cond);
        }
      }

    }
    num_packet+=1;
    pthread_setcancelstate(PTHREAD_CANCEL_ENABLE,0);
    pthread_mutex_unlock(&m);

  }
  if(My402ListEmpty(&listQ1))pthread_cancel(token);
  return (void*)0;
}
void *threadT(){
  double ct=startTime;
  long long i=0;
  while(!finP||!My402ListEmpty(&listQ1)){
    ssleep(bucket.rate,(getTimeinMil()-ct)*1000);
    ct=getTimeinMil();
    i++;
    pthread_testcancel();
    pthread_mutex_lock(&m);
    pthread_setcancelstate(PTHREAD_CANCEL_DISABLE,0);
    if(bucket.num<B){
      bucket.num+=1;

      if(bucket.num<2){
        fprintf(stdout,"%012.3lfms: token t%lld arrives, token bucket now has %lld token\n",
        getTimeinMil()-startTime,i,bucket.num );
      }
      else{
        fprintf(stdout,"%012.3lfms: token t%lld arrives, token bucket now has %lld tokens\n",
        getTimeinMil()-startTime,i,bucket.num );
      }
    }
    else{
      fprintf(stdout,"%012.3lfms: token t%lld arrives, dropped\n",
      getTimeinMil()-startTime,i);
      bucket.dropped+=1;
    }
    bucket.index+=1;
    if(!My402ListEmpty(&listQ1)){
      My402ListElem* elem=My402ListFirst(&listQ1);
      Packet* p= (Packet*)elem->obj;
      if(bucket.num>=p->tokens){
        bucket.num-=p->tokens;
        p->leaveQ1=getTimeinMil();
        My402ListUnlink(&listQ1,elem);
        fprintf(stdout,"%012.3lfms: p%lld leaves Q1, time in Q1 = %0.3lfms, token bucket now has %lld token\n",
        getTimeinMil()-startTime,p->number,p->leaveQ1-p->enterQ1,bucket.num);
        p->enterQ2=getTimeinMil();
        My402ListAppend(&listQ2,p);
        fprintf(stdout,"%012.3lfms: p%lld enters Q2\n",
        getTimeinMil()-startTime,p->number);
        if(My402ListLength(&listQ2)==1)pthread_cond_signal(&cond);

      }
    }
    pthread_setcancelstate(PTHREAD_CANCEL_ENABLE,0);
    pthread_mutex_unlock(&m);

  }
  return (void*)0;
}
void *threadS(void* i){
  while(!finT||!My402ListEmpty(&listQ2)){
    pthread_mutex_lock(&m);
    while(!finT&&My402ListEmpty(&listQ2)){
      pthread_cond_wait(&cond,&m);
    }
    if(My402ListEmpty(&listQ2)){
      pthread_mutex_unlock(&m);
      return (void*)0;
    }
    My402ListElem* elem=My402ListFirst(&listQ2);
    Packet* p= (Packet*)elem->obj;
    p->leaveQ2=getTimeinMil();
    My402ListUnlink(&listQ2,elem);
    fprintf(stdout,"%012.3lfms: p%lld leaves Q2, time in Q2 = %0.3lfms\n",
    getTimeinMil()-startTime,p->number,p->leaveQ2-p->enterQ2);
    p->s=*(int*)i;
    fprintf(stdout,"%012.3lfms: p%lld begins service at S%d, requesting %lfms of service\n",
    getTimeinMil()-startTime,p->number,*(int*)i,p->Stime);
    pthread_mutex_unlock(&m);
    p->enterS=getTimeinMil();
    ssleep(p->Stime,0);
    p->leaveS=getTimeinMil();
    pthread_mutex_lock(&m);
    fprintf(stdout,"%012.3lfms: p%lld departs from S%d, service time = %0.3lfms, time in system = %0.3lfms\n",
    getTimeinMil()-startTime,p->number,*(int*)i,p->leaveS-p->enterS,p->leaveS-p->arriveTime);
    sumServiceTime+=(p->leaveS-p->enterS);
    sumInQ1+=p->leaveQ1-p->enterQ1;
    sumInQ2+=p->leaveQ2-p->enterQ2;
    inSystem=(p->leaveS-p->arriveTime)/1000.0;
    sumInSystem+=inSystem;
    sumInSystemSq+=pow(inSystem,2);
    if(p->s==1){
      sumInS1+=p->leaveS-p->enterS;
    }
    else if(p->s==2){
      sumInS2+=p->leaveS-p->enterS;
    }
    serviced+=1;
    free(p);
    if(My402ListLength(&listQ2)>0)pthread_cond_signal(&cond);
    pthread_mutex_unlock(&m);


  }



  return (void*)0;
}
void init() {
  My402ListInit(&listQ1);
  My402ListInit(&listQ2);
  double rate=1.0/r*1000;
  if(rate>10000){
    rate=10000;
  }
  bucket=(Bucket){B,0,rate,0,0};
}
void Statistics(){

  double average=sumInSystem/(double)(num-dropped);
  double var=sumInSystemSq/(double)(num-dropped)-pow(average,2);
  fprintf(stdout,"\nStatistics:\n\n");
  fprintf(stdout,"\taverage packet inter-arrival time = %.6gs\n",
  sumInterArrival/(double)num_packet/1000);
  fprintf(stdout,"\taverage packet service time = %.6gs\n\n",
  sumServiceTime/(double)(serviced)/1000);
  fprintf(stdout,"\taverage number of packets in Q1 = %.6g\n",
  sumInQ1/(endTime-startTime));
  fprintf(stdout,"\taverage number of packets in Q2 = %.6g\n",
  sumInQ2/(endTime-startTime));
  fprintf(stdout,"\taverage number of packets in S1 = %.6g\n",
  sumInS1/(endTime-startTime));
  fprintf(stdout,"\taverage number of packets in S2 = %.6g\n\n",
  sumInS2/(endTime-startTime));
  fprintf(stdout,"\taverage time a packet spent in system = %0.6gs\n",
  average);
  fprintf(stdout,"\tstandard deviation for time spent in system = %.6g\n\n",
  pow(var,0.5));
  fprintf(stdout,"\ttoken drop probability = %.6g\n",
  (double)bucket.dropped/(double)bucket.index);
  fprintf(stdout,"\tpacket drop probability = %.6g\n",
  (double)dropped/(double)num);

}


void *monitor(void *arg) {
  int sig=0;
  sigwait(&set, &sig);

  pthread_mutex_lock(&m);
  pthread_cancel(packet);
  finP=TRUE;
  pthread_cancel(token);
  finT=TRUE;
  fprintf(stdout, "\n%012.3lfms: SIGINT caught, no new packets or tokens will be allowed\n",getTimeinMil()-startTime);
  My402ListElem *elem=NULL;
  for (elem=My402ListFirst(&listQ1); elem != NULL; elem=My402ListNext(&listQ1, elem)) {
      Packet* p=elem->obj;
      fprintf(stdout, "%012.3lfms: p%lld removed from Q1\n",
      getTimeinMil()-startTime,p->number);
      free(p);
  }
  My402ListUnlinkAll(&listQ1);
  for (elem=My402ListFirst(&listQ2); elem != NULL; elem=My402ListNext(&listQ2, elem)) {
      Packet* p=elem->obj;
      fprintf(stdout, "%012.3lfms: p%lld removed from Q2\n",
      getTimeinMil()-startTime,p->number);
      free(p);
  }
  My402ListUnlinkAll(&listQ2);

  pthread_cond_broadcast(&cond);
  pthread_mutex_unlock(&m);

  return (void*)0;
}

int main(int argc, char *argv[])
{

  SetProgramName(*argv);
  if(!ProcessOptions(argc,argv)){
    Usage();
    return 0;
  }
  init();
  startTime=getTimeinMil();
  fprintf(stdout,"%012.3lfms: emulation begins\n",0.0 );
  pthread_t thr;
  sigemptyset(&set);
  sigaddset(&set, SIGINT);
  sigprocmask(SIG_BLOCK,
    &set, 0);
  pthread_create(&thr, 0,
    monitor, 0);
  pthread_create(&packet,NULL,threadP,0);
  pthread_create(&token,NULL,threadT,0);
  int a=1,b=2;
  pthread_create(&S1,NULL,threadS,&a);
  pthread_create(&S2,NULL,threadS,&b);
  pthread_join(packet,NULL);
  finP=TRUE;
  pthread_join(token,NULL);
  finT=TRUE;
  pthread_cond_broadcast(&cond);
  pthread_join(S1,NULL);
  pthread_join(S2,NULL);
  endTime=getTimeinMil();
  pthread_mutex_lock(&m);
  fprintf(stdout,"%012.3lfms: emulation ends\n",endTime-startTime );
  Statistics();
  pthread_mutex_unlock(&m);
  return(0);
}
