def main():
    f1=open('golden_result.txt','r')
    f2=open('a.csv','r')
    list1=[]
    i=0
    for line in f2:
        
        s=line
        s=s[s.find(",")+1:s.find(",")+1+10]
        if(i!=0):
            list1.append(s)
            print s
        i+=1
    print s
if __name__ == "__main__": main()
