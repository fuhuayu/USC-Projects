/******************************************************************************/
/* Important CSCI 402 usage information:                                      */
/*                                                                            */
/* This fils is part of CSCI 402 programming assignments at USC.              */
/*         53616c7465645f5f2e8d450c0c5851acd538befe33744efca0f1c4f9fb5f       */
/*         3c8feabc561a99e53d4d21951738da923cd1c7bbd11b30a1afb11172f80b       */
/*         984b1acfbbf8fae6ea57e0583d2610a618379293cb1de8e1e9d07e6287e8       */
/*         de7e82f3d48866aa2009b599e92c852f7dbf7a6e573f1c7228ca34b9f368       */
/*         faaef0c0fcf294cb                                                   */
/* Please understand that you are NOT permitted to distribute or publically   */
/*         display a copy of this file (or ANY PART of it) for any reason.    */
/* If anyone (including your prospective employer) asks you to post the code, */
/*         you must inform them that you do NOT have permissions to do so.    */
/* You are also NOT permitted to remove or alter this comment block.          */
/* If this comment block is removed or altered in a submitted file, 20 points */
/*         will be deducted.                                                  */
/******************************************************************************/

/*
 * Author:      William Chia-Wei Cheng (bill.cheng@acm.org)
 *
 * @(#)$Id: listtest.c,v 1.1 2016/12/21 19:22:34 william Exp $
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/time.h>
#include <time.h>
#include "cs402.h"

#include "my402list.h"

static char gszProgName[MAXPATHLENGTH];

int gnDebug=0;

/* ----------------------- Utility Functions ----------------------- */
typedef struct tagBankData {
    long amount;
    int timestamp;
    char description[25];
}BankData;
static
void Usage()
{
    fprintf(stderr,
            "usage: %s %s\n",
            gszProgName, "sort [tfile]");
    exit(-1);
}

static
void ProcessOptions(int argc, char *argv[])
{
    if(argc<2){
      fprintf(stderr,"Too Few Arguments\n");
      Usage();
    }
    else if(strcmp(argv[1],"sort")){
      fprintf(stderr,"malformed commands\n");
      Usage();
    }
    if(argc==2) gnDebug=0;
    else gnDebug=1;
}

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


static
void AtoStr(long lamount){
  char amount[15];
    amount[14]='\0';
    if(abs(lamount)>=100000000){
      snprintf(amount,15," ?,???,???.?? ");
    }
    else{
      char str[10];
      amount[0]=' ';
      amount[13]=' ';
      sprintf(str, "%d", abs(lamount));
      char *start=str;
      char* p=strchr(start,'\0');
      int i=p-str-1;
      int j,k=0,l=0;
      for(j=12;j>0;j--){
        if(i>=0){
          if(k==2){
            amount[j]='.';
          }
          else if((l-2)%4==0){
            amount[j]=',';
          }
          else{
            amount[j]=str[i--];
          }
          k++;
          l++;
        }
        else{
          amount[j]=' ';
        }
      }
      if(abs(lamount)<100){
        amount[9]='0';
        amount[10]='.';
      }
    }
    if(lamount<0){
      amount[0]='(';
      amount[13]=')';
    }

    fprintf(stdout,"%s",amount);

}




static
void PrintStatement(My402List *pList)
{
  My402ListElem *elem=NULL;
  long balance=0;
  int currT=0,nextT=0;
  for (elem=My402ListFirst(pList); elem != NULL; elem=My402ListNext(pList, elem)) {
      BankData* data=elem->obj;
      nextT=data->timestamp;
      if(currT==nextT){
        fprintf(stderr,"identical timestamp found\n");
        return;
      }
      currT=nextT;
  }
  fprintf(stdout, "+-----------------+--------------------------+----------------+----------------+\n");
  fprintf(stdout, "|       Date      | Description              |         Amount |        Balance |\n");
  fprintf(stdout, "+-----------------+--------------------------+----------------+----------------+\n");
  for (elem=My402ListFirst(pList); elem != NULL; elem=My402ListNext(pList, elem)) {
      BankData* data=elem->obj;

      time_t t=data->timestamp;
      char date[11];
      char year[5];
      char ct[32];

      long lamount=data->amount;
      strcpy(ct,ctime(&t));
      strncpy(date,ct,10);
      int i;
      for(i=0;i<4;i++){
        year[i]=ct[i+20];
      }
      date[10]='\0';
      year[4]='\0';
      balance+=lamount;
      fprintf(stdout, "| %s %s | %s | ", date,year,data->description);
      AtoStr(lamount);
      fprintf(stdout, " | ");
      AtoStr(balance);
      fprintf(stdout, " |\n");
  }
  fprintf(stdout, "+-----------------+--------------------------+----------------+----------------+\n");

}


static
void BubbleForward(My402List *pList, My402ListElem **pp_elem1, My402ListElem **pp_elem2)
    /* (*pp_elem1) must be closer to First() than (*pp_elem2) */
{
    My402ListElem *elem1=(*pp_elem1), *elem2=(*pp_elem2);
    void *obj1=elem1->obj, *obj2=elem2->obj;
    My402ListElem *elem1prev=My402ListPrev(pList, elem1);
/*  My402ListElem *elem1next=My402ListNext(pList, elem1); */
/*  My402ListElem *elem2prev=My402ListPrev(pList, elem2); */
    My402ListElem *elem2next=My402ListNext(pList, elem2);

    My402ListUnlink(pList, elem1);
    My402ListUnlink(pList, elem2);
    if (elem1prev == NULL) {
        (void)My402ListPrepend(pList, obj2);
        *pp_elem1 = My402ListFirst(pList);
    } else {
        (void)My402ListInsertAfter(pList, obj2, elem1prev);
        *pp_elem1 = My402ListNext(pList, elem1prev);
    }
    if (elem2next == NULL) {
        (void)My402ListAppend(pList, obj1);
        *pp_elem2 = My402ListLast(pList);
    } else {
        (void)My402ListInsertBefore(pList, obj1, elem2next);
        *pp_elem2 = My402ListPrev(pList, elem2next);
    }
}

static
void SortInput(My402List *pList)
{
    My402ListElem *elem=NULL;
    int i=0;

    int num_items=pList->num_members;
    for (i=0; i < num_items; i++) {
        int j=0, something_swapped=FALSE;
        My402ListElem *next_elem=NULL;

        for (elem=My402ListFirst(pList), j=0; j < num_items-i-1; elem=next_elem, j++) {
            BankData *data=elem->obj;
            int cur_val=data->timestamp, next_val=0;
            next_elem=My402ListNext(pList, elem);
            data=next_elem->obj;
            next_val = data->timestamp;
            if (cur_val > next_val) {
                BubbleForward(pList, &elem, &next_elem);
                something_swapped = TRUE;
            }
        }
        if (!something_swapped) break;
    }
}
static
int ProcessData(My402List *list,char* buffer,long *x){
  char *start_ptr = buffer;
  char *tab_ptr = strchr(start_ptr, '\t');
  if(tab_ptr!=NULL)*tab_ptr++='\0';
  else{
    fprintf(stderr,"not enough data\n");
    return FALSE;
  }
  char *second_ptr = tab_ptr;
  tab_ptr = strchr(second_ptr,'\t');
  if(tab_ptr!=NULL)*tab_ptr++='\0';
  else{
    fprintf(stderr,"not enough data\n");
    return FALSE;
  }
  char *third_ptr = tab_ptr;
  tab_ptr = strchr(third_ptr,'\t');
  if(tab_ptr!=NULL)*tab_ptr++='\0';
  else{
    fprintf(stderr,"not enough data\n");
    return FALSE;
  }
  char *fourth_ptr = tab_ptr;
  if(strchr(fourth_ptr,'\t')){
    fprintf(stderr,"Too many fields\n");
    return FALSE;
  }
  BankData *data=(BankData*)malloc(sizeof(BankData));
  *x=(long)data;
  char* fDot=third_ptr;
  char* nfDot=fDot+1;
  int trigger=0;
  while(*fDot!='\0'){
    if(trigger==0){
      fDot++;
      nfDot++;
      if(*fDot=='.'){
        *fDot=*nfDot;
        trigger=1;
      }
    }
    else{
      fDot++;
      nfDot++;
      *fDot=*nfDot;
      fDot++;
      nfDot++;
      *fDot=*nfDot;
      if(*fDot!='\0'){
        fprintf(stderr,"Wrong amount format\n");
        return FALSE;
      }
    }
  }
  if(start_ptr[0]=='+') data->amount=(long)(atoi(third_ptr)*1);
  else data->amount=(long)(atoi(third_ptr)*-1);
  data->timestamp=atoi(second_ptr);
  time_t ti;
  time(&ti);
  if(ti<data->timestamp){
    fprintf(stderr,"Date cannot in the future\n");
    return FALSE;
  }
  int c,t=0;
  for(c=0;c<25;c++){
    if(c!=24){
      if(t==0){
        if(fourth_ptr[c]=='\n'){
          data->description[c]=' ';
          t=1;
        }
        else data->description[c]=fourth_ptr[c];
      }
      else data->description[c]=' ';
    }
    else data->description[24]='\0';
  }

  return TRUE;
}
static
int ReadInput(FILE *fp,My402List *list){
  char buffer[1026];

  while(fgets(buffer,sizeof(buffer),fp)!=NULL){
    //symble
    if(buffer[0]!='+'&&buffer[0]!='-'){
      fprintf(stderr,"wrong input\n");
      return FALSE;
    }
    else{
      long i=0;

      if(ProcessData(list,buffer,&i)==TRUE){
      BankData* d=(BankData*)i;
      (void)My402ListAppend(list,d);
      }
      else{
        return FALSE;
      }
    }
  }
  return TRUE;
}

/* ----------------------- Process() ----------------------- */

static
void Process(char* fileName)
{
  FILE* fp;
  if(fileName!=NULL){
    fp=fopen(fileName, "r");
    if(fp==NULL){
      fprintf(stderr,"File %s Cannot Be Opened\n",fileName);
      return;
    }
  }
  else fp=stdin;
  My402List list;
  if (!My402ListInit(&list)) {
    fprintf(stderr,"List cannot be initiallized\n");
    return;
   }
  if (!ReadInput(fp, &list)) {
    fprintf(stderr,"Cannot Read Input\n");
    return;
   }
   else{
     SortInput(&list);
     PrintStatement(&list);
   }
  //if (fp != stdin) fclose(fp);

}

/* ----------------------- main() ----------------------- */

int main(int argc, char *argv[])
{
    SetProgramName(*argv);
    ProcessOptions(argc, argv);
    if(gnDebug==1) Process(argv[2]);
    else Process(NULL);
    return(0);
}
