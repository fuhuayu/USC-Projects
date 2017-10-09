import random
def LFSR(start_state):
    start_state=start_state%32
    lfsr=start_state
    l=[]
    while True:
        bit=((lfsr>>0)^(lfsr>>2))&1
        lfsr=((lfsr)>>1)|((bit)<<4)
        l.append(lfsr)
        if(lfsr==start_state):
            break
    return l
def rawGen(number1,number2,out):
    
    if(number1>=16):
        number1=(number1%32)-32
    if(number2>=16):
        number2=(number2%32)-32
    number=number1*number2
    print number
    i=0
    if(number>0):
        for x in range(9,-1,-1):
            i+=1
            bit=(number%(pow(2,x+1)))/pow(2,x)
            if(x==0):
                out.write(str(bit)+'\n')
            else:
                out.write(str(bit))
            if((i-1)%3==0 and x!=0):
                out.write(',')
    else:
        out.write('1,')
        number=~(number%512)+1
        bits=bin(number)
        it=10-len(bits)+3
        for x in range(10,10-it,-1):
            i+=1
            out.write('1')
            if((i)%3==0):
                out.write(',')
        for x in range(4,len(bits),1):
            i+=1
            if(x==(len(bits)-1)):
                out.write(bits[x]+'\n')
            else:
                out.write(bits[x])
            if((i)%3==0 and x!=(len(bits)-1)):
                out.write(',')
        print bits
    
def main():
    out=open('golden_result.txt','w')
    out1=open('testcase.vec','w')
    out2=open('BinaryInput.txt','w')
    out1.write("radix\t1\t4\t1\t4\n")
    out1.write("io\ti\ti\ti\ti\n")
    out1.write("vname\ta<4>\ta<[3:0]>\tb<4>\tb<[3:0]>\n")
    out1.write("slope\t0.01\n")
    out1.write("vih\t1.8\n")
    out1.write("tunit\tns\n")
    l=LFSR(47)
    for i in range(5):
        out1.write(str(i*10)+'\t')
        number1=l[random.randint(0,len(l)-1)]
        out1.write(str(number1/16)+'\t')
        out1.write(hex(number1%16)[2]+'\t')
        for x in range(4,-1,-1):
            bit=(number1%(pow(2,x+1)))/pow(2,x)
            if(x==0):
                out2.write(str(bit)+'\t')
            else:
                out2.write(str(bit))
        number2=l[random.randint(0,len(l)-1)]
        out1.write(str(number2/16)+'\t')
        out1.write(hex(number2%16)[2]+'\n')
        for x in range(4,-1,-1):
            bit=(number2%(pow(2,x+1)))/pow(2,x)
            if(x==0):
                out2.write(str(bit)+'\n')
            else:
                out2.write(str(bit))
        rawGen(number1,number2,out)
    out.close()
    out1.close()
    out2.close()
if __name__ == "__main__": main()
