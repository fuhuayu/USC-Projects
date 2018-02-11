#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/time.h>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <time.h>
#include "cs402.h"
#include "warmup2.h"
void Usage()
{
    fprintf(stderr,
            "usage: %s %s\n",
            gszProgName, "[-lambda lambda] [-mu mu] [-r r] [-B B] [-P P] [-n num] [-t tsfile]");
    exit(-1);
}

static
int ProcessOptions(int argc, char *argv[])
{
    int i;
    for(i=1;i<argc;i=i+2){
      if(strcmp(argv[i],"-lambda")==0){
        if(i+1<argc){
          if(sscanf(argv[i+1],"%lf",&lambda)!=1){
            fprintf(stderr,"cannot read input value of rate lambda\n");
            return FALSE;
          }
          if(lambda<=0){
            fprintf(stderr,"value of rate lambda should be greater than 0\n");
            return FALSE;
          }
        }
        else{
          fprintf(stderr,"cannot read input value of rate lambda\n");
          return FALSE;
        }
      }
      else if(strcmp(argv[i],"-mu")==0){
        if(i+1<argc){
          if(sscanf(argv[i+1],"%lf",&mu)!=1){
            fprintf(stderr,"cannot read input value of rate mu\n");
            return FALSE;
          }
          if(mu<=0){
            fprintf(stderr,"value of rate mu should be greater than 0\n");
            return FALSE;
          }
        }
        else{
          fprintf(stderr,"cannot read input value of rate mu\n");
          return FALSE;
        }
      }
      else if(strcmp(argv[i],"-r")==0){
        if(i+1<argc){
          if(sscanf(argv[i+1],"%lf",&r)!=1){
            fprintf(stderr,"cannot read input value of rate r\n");
            return FALSE;
          }
          if(r<=0){
            fprintf(stderr,"value of rate r should be greater than 0\n");
            return FALSE;
          }
        }
        else{
          fprintf(stderr,"cannot read input value of rate r\n");
          return FALSE;
        }
      }
      else if(strcmp(argv[i],"-B")==0){
        if(i+1<argc){
          if(sscanf(argv[i+1],"%d",&B)!=1){
            fprintf(stderr,"cannot read input value of depth B\n");
            return FALSE;
          }
          if(B<=0||B>2147483647){
            fprintf(stderr,"value of depth B should within range (0,2147483647]\n");
            return FALSE;
          }
        }
        else{
          fprintf(stderr,"cannot read input value of depth B\n");
          return FALSE;
        }
      }
      else if(strcmp(argv[i],"-P")==0){
        if(i+1<argc){
          if(sscanf(argv[i+1],"%d",&P)!=1){
            fprintf(stderr,"cannot read input number of tokens P");
            return FALSE;
          }
          if(P<=0||P>2147483647){
            fprintf(stderr,"number of tokens P should within range (0,2147483647]\n");
            return FALSE;
          }
        }
        else{
          fprintf(stderr,"cannot read input number of tokens P");
          return FALSE;
        }
      }
      else if(strcmp(argv[i],"-n")==0){
        if(i+1<argc){
          if(sscanf(argv[i+1],"%lld",&num)!=1){
            fprintf(stderr,"cannot read input number of packets\n");
            return FALSE;
          }
          if(num<=0||num>2147483647){
            fprintf(stderr,"number of packets should within range (0,2147483647]\n");
            return FALSE;
          }
        }
        else{
          fprintf(stderr,"cannot read input number of packets\n");
          return FALSE;
        }
      }
      else if(strcmp(argv[i],"-t")==0){
        if(i+1<argc){
          if(strlen(argv[i+1])>MAXPATHLENGTH){
            fprintf(stderr,"fileName too long\n");
            return FALSE;
          }
          if(sscanf(argv[i+1],"%s",tsfile)!=1){
            fprintf(stderr,"cannot read input fileName\n");
            return FALSE;
          }
          mode=1;
        }
        else{
          fprintf(stderr,"cannot read input fileName\n");
          return FALSE;
        }
      }
      else{
        fprintf(stderr, "(malformed command)\n");
        return FALSE;
      }
    }
    if(mode){
      char buffer[1026];

      if(mode==1){
        struct stat sb;
        stat(tsfile, &sb);
        if ((sb.st_mode & S_IFMT) == S_IFREG) {
          fp=fopen(tsfile,"r");
          if(fp==NULL){
            fprintf(stderr,"input file %s cannot be opened - access denies\n",tsfile);
            return FALSE;

          }
          if(fgets(buffer,sizeof(buffer),fp)==NULL){
            fprintf(stderr,"(input file is not in the right format)\n");
            return FALSE;

          }
          else{
            num=atoi(buffer);
            if(num<=0||num>2147483647){
              fprintf(stderr,"(input file is not in the right format)\n");
              return FALSE;
            }
          }
        }
        else if((sb.st_mode & S_IFMT) == S_IFDIR){
          fprintf(stderr, "input file %s is a directory\n",tsfile );
          return FALSE;
        }
        else{
          
          fprintf(stderr, "input file %s does not exist\n",tsfile );
          return FALSE;
        }

      }
      fprintf(stdout,"Emulation Parameters:\n");
      fprintf(stdout,"\tnumber to arrive = %lld\n",num);
      fprintf(stdout,"\tr = %0.0lf\n",r);
      fprintf(stdout,"\tB = %d\n",B);
      fprintf(stdout,"\ttsfile = %s\n\n",tsfile);
    }
    else{
      fprintf(stdout,"Emulation Parameters:\n");
      fprintf(stdout,"\tnumber to arrive = %lld\n",num);
      fprintf(stdout,"\tlambda = %.6g\n",lambda);
      fprintf(stdout,"\tmu = %.6g\n",mu);
      fprintf(stdout,"\tr = %.6g\n",r);
      fprintf(stdout,"\tB = %d\n",B);
      fprintf(stdout,"\tP = %d\n\n",P);
    }

    return TRUE;

}
