#include <stdio.h>
#include <stdlib.h>
#include "my402list.h"

int  My402ListLength(My402List* list){
  return list->num_members;
}
int  My402ListEmpty(My402List* list){
  return list->num_members==0;
}

int  My402ListAppend(My402List* list, void* obj){
  My402ListElem* newElem = (My402ListElem*)malloc(sizeof(My402ListElem));
  if (newElem==NULL) {
    fprintf(stderr,"Cannot Allocate Memory");
    return FALSE;
  }
  newElem->obj=obj;
  if(My402ListEmpty(list)){
    list->anchor.prev=newElem;
    list->anchor.next=newElem;
    newElem->next=&list->anchor;
    newElem->prev=&list->anchor;
    list->num_members+=1;
  }
  else{
    newElem->prev=list->anchor.prev;
    newElem->next=&list->anchor;
    list->anchor.prev->next=newElem;
    list->anchor.prev=newElem;
    list->num_members+=1;
  }
  return TRUE;

}
int  My402ListPrepend(My402List* list, void* obj){
  My402ListElem* newElem = (My402ListElem*)malloc(sizeof(My402ListElem));
  if (newElem==NULL) {
    fprintf(stderr,"Cannot Allocate Memory");
    return FALSE;
  }
  newElem->obj=obj;
  if(My402ListEmpty(list)){
    list->anchor.prev=newElem;
    list->anchor.next=newElem;
    newElem->next=&list->anchor;
    newElem->prev=&list->anchor;
    list->num_members+=1;
  }
  else{
    newElem->prev=&list->anchor;
    newElem->next=list->anchor.next;
    list->anchor.next->prev=newElem;
    list->anchor.next=newElem;
    list->num_members+=1;
  }
  return TRUE;
}
void My402ListUnlink(My402List* list, My402ListElem* elem){
  if(My402ListEmpty(list)||elem==NULL) return;
  elem->prev->next=elem->next;
  elem->next->prev=elem->prev;
  list->num_members-=1;
  //free(elem);
  return;
}
void My402ListUnlinkAll(My402List* list){
  if(My402ListEmpty(list)) return;
  My402ListElem* currentPos=list->anchor.next;
  while(currentPos!=&list->anchor){
    My402ListElem* toFree=currentPos;
    currentPos=currentPos->next;
    My402ListUnlink(list,toFree);
  }
}
int  My402ListInsertAfter(My402List* list, void* obj, My402ListElem* elem){
  if(elem==NULL) return My402ListAppend(list,obj);
  else{
    My402ListElem* newElem = (My402ListElem*)malloc(sizeof(My402ListElem));
    if (newElem==NULL) {
      fprintf(stderr,"Cannot Allocate Memory");
      return FALSE;
    }
    newElem->obj=obj;
    newElem->next=elem->next;
    newElem->prev=elem;
    elem->next->prev=newElem;
    elem->next=newElem;
    list->num_members+=1;
    return TRUE;
  }
}
int  My402ListInsertBefore(My402List* list, void* obj, My402ListElem* elem){
  if(elem==NULL) return My402ListPrepend(list,obj);
  else{
    My402ListElem* newElem = (My402ListElem*)malloc(sizeof(My402ListElem));
    if (newElem==NULL) {
      fprintf(stderr,"Cannot Allocate Memory");
      return FALSE;
    }
    newElem->obj=obj;
    newElem->next=elem;
    newElem->prev=elem->prev;
    elem->prev->next=newElem;
    elem->prev=newElem;
    list->num_members+=1;
    return TRUE;
  }

}

My402ListElem *My402ListFirst(My402List* list){
  if(My402ListEmpty(list)) return NULL;
  else return list->anchor.next;

}
My402ListElem *My402ListLast(My402List* list){
  if(My402ListEmpty(list)) return NULL;
  else return list->anchor.prev;
}
My402ListElem *My402ListNext(My402List* list, My402ListElem* elem){
  if(My402ListLast(list)==elem) return NULL;
  else return elem->next;
}
My402ListElem *My402ListPrev(My402List* list, My402ListElem* elem){
  if(My402ListFirst(list)==elem) return NULL;
  else return elem->prev;

}

My402ListElem *My402ListFind(My402List* list, void* obj){
  if(My402ListEmpty(list)) return NULL;

  else{
    My402ListElem* currentPos=My402ListFirst(list);
    while (currentPos!=&list->anchor) {
      if(currentPos->obj==obj){
        return currentPos;
      }
      currentPos=My402ListNext(list,currentPos);
    }
    return NULL;
  }
}

int My402ListInit(My402List* list){
  list->num_members=0;
  list->anchor.obj=NULL;
  list->anchor.prev=&list->anchor;
  list->anchor.next=&list->anchor;
  return TRUE;
}
