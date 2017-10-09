def main():
    f1=open('golden_result.txt','r')
    f2=open('actual_result.txt','r')
    for i in range(5):
        ff1=f1.readline()
        ff2=f2.readline()
        if(f1.readline()!=f2.readline()):
            print "line "+str(i+1)+" does not match"
            print ff1
            print ff2
        else:
            print "line "+str(i+1)+" matches"
if __name__ == "__main__": main()
