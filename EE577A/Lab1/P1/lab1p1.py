#!/usr/bin/python
import random
def main():
    # open in file
    infile = open('in.txt', 'r')
    # set up outputs and headers
    out1=open('out1.txt','w')
    out1.write('Word Number\tWord\n')
    out2=open('out2.txt','w')
    out2.write('Line Number with "the"\tNumber of Times per Line\n')
    out3=open('out3.txt','w')
    out3.write('Random Word Number\tWord\n')
    # set number of words as i
    i=0
    # set number of lines as l
    l=0
    # have a empty list as lis
    lis=[]
    # for each line in infile
    for line in infile:
        # increment l
        l+=1
        # num is counter for 'the'
        num=0
        # for each word in line
        for word in line.split():
            # increment i
            i+=1
            # write line in out1
            out1.write(str(i)+'\t'+word+'\n')
            # check if the word is 'the'
            if word=='the' or word=='The':
                num+=1
            # add word to list
            lis.append(word)
        # if there is 'the' in line write a line in out2
        if num!=0:
            out2.write(str(l)+'\t'+str(num)+'\n')
    # loop for 30 times
    for counter in range(0,30):
        # generate a random number at the range of 0 to i-1
        r=random.randint(1,i)
        # write line in out3
        out3.write(str(r)+'\t'+lis[r-1]+'\n')
    # close all files
    infile.close()       
    out1.close()
    out2.close()
    out3.close()
if __name__ == "__main__": main()
