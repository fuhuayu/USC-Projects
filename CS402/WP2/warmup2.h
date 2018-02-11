#ifndef _WARMUP2_H
#define _WARMUP2_H
#include "cs402.h"


typedef struct tagBucket{
  int depth;
  long long num;
  double rate;
  long long dropped;
  long long index;
} Bucket;
typedef struct tabPacket{
  long long number;
  long long tokens;
  double arriveTime;
  double enterQ1;
  double leaveQ1;
  double enterQ2;
  double leaveQ2;
  double Stime;
  double enterS;
  double leaveS;
  int s;
} Packet;
typedef struct tagServer{
  double rate;
} Server;
FILE* fp;
long long num_packet;
double lambda=1;
double mu=0.35;
double r=1.5;
int B=10;
int P=3;
long long num=20;
int mode=0;
double startTime,endTime;
char tsfile[MAXPATHLENGTH];
char gszProgName[MAXPATHLENGTH];
My402List listTs;
pthread_t packet,token,S1,S2;
pthread_mutex_t m = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t cond = PTHREAD_COND_INITIALIZER;
My402List listQ1,listQ2;
int finP=FALSE,finT=FALSE;
Bucket bucket;
double sumInterArrival=0,sumServiceTime=0,sumInQ1=0,sumInQ2=0;
double sumInS1=0,sumInS2=0,sumInSystem=0,sumInSystemSq=0,inSystem;
long long dropped=0,serviced=0;
sigset_t set;
#endif
