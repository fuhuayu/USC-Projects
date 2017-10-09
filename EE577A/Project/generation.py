def writeVEC(i,period,out,Op,Sa,Sb,Sd,Sel,Load_sel,imm,Mem_add,RF_Wen,Mem_Wen,Mem_Ren,ADD0SUB1,AND0OR1,SFR0SFL1,LoadI,ALU_EN):
    
    imm4=imm/pow(16,3)
    imm3=(imm%pow(16,3))/pow(16,2)
    imm2=(imm%pow(16,2))/(16)
    imm1=(imm%(16))
    Mem_add2=(Mem_add%pow(16,2))/(16)
    Mem_add1=Mem_add%16
    clock=0
    nclock=1
    
    #print imm4,imm3,imm2,imm1
    out.write(str(i*period)+'\t'+hex(Op)[2]+'\t'+hex(Sa)[2]+'\t'+
              hex(Sb)[2]+'\t'+hex(Sd)[2]+'\t'+
              hex(Sel)[2]+'\t'+hex(Load_sel)[2]+'\t'+
              hex(imm4)[2]+'\t'+hex(imm3)[2]+'\t'+
              hex(imm2)[2]+'\t'+hex(imm1)[2]+'\t'+
              hex(Mem_add2)[2]+'\t'+hex(Mem_add1)[2]+'\t'+
              hex(RF_Wen)[2]+'\t'+hex(Mem_Wen)[2]+'\t'+
              hex(Mem_Ren)[2]+'\t'+hex(clock)[2]+'\t'+hex(nclock)[2]+'\t'+
              hex(ADD0SUB1)[2]+'\t'+hex(AND0OR1)[2]+'\t'+hex(SFR0SFL1)[2]+'\t'+hex(LoadI)[2]+'\t'+hex(ALU_EN)[2]+'\n')
    i+=0.5
    clock=1
    nclock=0
    out.write(str(i*period)+'\t'+hex(Op)[2]+'\t'+hex(Sa)[2]+'\t'+
              hex(Sb)[2]+'\t'+hex(Sd)[2]+'\t'+
              hex(Sel)[2]+'\t'+hex(Load_sel)[2]+'\t'+
              hex(imm4)[2]+'\t'+hex(imm3)[2]+'\t'+
              hex(imm2)[2]+'\t'+hex(imm1)[2]+'\t'+
              hex(Mem_add2)[2]+'\t'+hex(Mem_add1)[2]+'\t'+
              hex(RF_Wen)[2]+'\t'+hex(Mem_Wen)[2]+'\t'+
              hex(Mem_Ren)[2]+'\t'+hex(clock)[2]+'\t'+hex(nclock)[2]+'\t'+
              hex(ADD0SUB1)[2]+'\t'+hex(AND0OR1)[2]+'\t'+hex(SFR0SFL1)[2]+'\t'+hex(LoadI)[2]+'\t'+hex(ALU_EN)[2]+'\n')
def CD():
    cmd=open('cmd.txt','r')
    l=[]
    for line in cmd:
        l.append(line)
    for i in range(len(l)):
        dl=[]
        line=l[i].split()
        if(line[0]=='STOREI'):
            Sd=int(line[1][1:],16)
            if(line[1]=='2'):
                if(int(line[1][:1],16)%2==0):
                    Mem_add=int(line[2][:2],16)
                    dl.append(Mem_add)
                    dl.append(Mem_add+1)
                else:
                    print "Error001: Command  is not aligned properly."
                    continue
            elif(line[1]=='4'):
                if(int(line[1][:1],16)%4==0):
                    Mem_add=int(line[2][:2],16)
                    dl.append(Mem_add)
                    dl.append(Mem_add+1)
                    dl.append(Mem_add+2)
                    dl.append(Mem_add+3)
                else:
                    print "Error001: Command  is not aligned properly."
                    continue
            else:
                Mem_add=int(line[2][:2],16)
        
def main():
    cmd=open('cmd.txt','r')
    out=open('ins.vec','w')
    out.write("radix\t4\t3\t3\t3\t1\t1\t4\t4\t4\t4\t1\t4\t1\t1\t1\t1\t1\t1\t1\t1\t1\t1\n")
    out.write("io\ti\ti\ti\ti\ti\ti\ti\ti\ti\ti\ti\ti\ti\ti\ti\ti\ti\ti\ti\ti\ti\ti\n")
    out.write("vname\tOP<[3:0]>\tSa<[2:0]>\tSb<[2:0]>\tSd<[2:0]>"+
               "\tI_SEL\tLOAD\tIMM<[15:12]>\tIMM<[11:8]>\tIMM<[7:4]>\tIMM<[3:0]>"+
               "\tMEM_WA<4>\tMEM_WA<[3:0]>\tRF_WE\tWRITE_EN\tREAD_EN\tclk\t~clk\tADD0SUB1\tAND0OR1\tSFR0SFL1\tLoadI\tALU_EN\n")
    out.write("slope\t0.01\n")
    out.write("vih\t1.8\n")
    out.write("tunit\tns\n")
    out.write('')
    op=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
    i=0.0
    mem=[0]*512
    reg=[0]*8
    period=4
    for line in cmd:
        Op=0#Op code
        Sa=0#register A
        Sb=0#register B
        Sd=0#destination register
        Sel=0#select imm or register A
        Load_sel=0#select load imm or MEM
        imm=0#immediate
        Mem_add=0#memory address


        RF_Wen=0#RF write enable
        Mem_Wen=0#MEM write enable
        Mem_Ren=0#MEM read enable
        ADD0SUB1=0
        AND0OR1=0
        SFR0SFL1=0
        LoadI=0
        ALU_EN=0
        line=line.split()
        if(len(line)==0):
           continue
        if(line[0]=='STOREI'):
            Sel=1
            Mem_Wen=1
            if(line[1]=='2'):
                if(int(line[1][:1],16)%2==0):
                    Mem_add=int(line[2][:2],16)
                    imm=int(line[3][1:],16)
                    print imm
                    mem[Mem_add]=imm
                    writeVEC(i,period,out,Op,Sa,Sb,Sd,Sel,Load_sel,imm,Mem_add,RF_Wen,Mem_Wen,Mem_Ren,ADD0SUB1,AND0OR1,SFR0SFL1,LoadI,ALU_EN)
                    i+=1
                    Mem_add+=1
                    imm=int(line[4][1:],16)
                    mem[Mem_add]=imm
                else:
                    print "Error001: Command  is not aligned properly."
                    continue
            elif(line[1]=='4'):
                if(int(line[1][:1],16)%4==0):
                    Mem_add=int(line[2][:2],16)
                    imm=int(line[3][1:],16)
                    mem[Mem_add]=imm
                    writeVEC(i,period,out,Op,Sa,Sb,Sd,Sel,Load_sel,imm,Mem_add,RF_Wen,Mem_Wen,Mem_Ren,ADD0SUB1,AND0OR1,SFR0SFL1,LoadI,ALU_EN)
                    i+=1
                    Mem_add+=1
                    imm=int(line[4][1:],16)
                    mem[Mem_add]=imm
                    writeVEC(i,period,out,Op,Sa,Sb,Sd,Sel,Load_sel,imm,Mem_add,RF_Wen,Mem_Wen,Mem_Ren,ADD0SUB1,AND0OR1,SFR0SFL1,LoadI,ALU_EN)
                    i+=1
                    Mem_add+=1
                    imm=int(line[5][1:],16)
                    mem[Mem_add]=imm
                    writeVEC(i,period,out,Op,Sa,Sb,Sd,Sel,Load_sel,imm,Mem_add,RF_Wen,Mem_Wen,Mem_Ren,ADD0SUB1,AND0OR1,SFR0SFL1,LoadI,ALU_EN)
                    i+=1
                    Mem_add+=1
                    imm=int(line[6][1:],16)
                    mem[Mem_add]=imm
                else:
                    print "Error001: Command  is not aligned properly."
                    continue
            else:
                Mem_add=int(line[1][:2],16)
                imm=int(line[2][1:],16)
                mem[Mem_add]=imm
        elif(line[0]=='STORE'):
            Sel=0
            Mem_Wen=1
            Mem_add=int(line[1][:2],16)
            Sb=int(line[2][1:],16)
            mem[Mem_add]=reg[Sb]
        elif(line[0]=='LOADI'):
            
            Load_sel=1
            Sel=1
            RF_Wen=1
            imm=int(line[2][1:],16)
            print line[2][1:]
            print imm
            Sd=int(line[1][1:],16)
            reg[Sd]=imm
        elif(line[0]=='LOAD'):
            LoadI=1
            Load_sel=1
            Mem_Ren=1
            Mem_add=int(line[2][:2],16)
            Sd=int(line[1][1:],16)
            writeVEC(i,period,out,Op,Sa,Sb,Sd,Sel,Load_sel,imm,Mem_add,0,Mem_Wen,Mem_Ren,ADD0SUB1,AND0OR1,SFR0SFL1,LoadI,ALU_EN)
            i+=1
            Mem_Ren=0
            RF_Wen=1
            reg[Sd]=mem[Mem_add]
        elif(line[0]=='AND'):
            Op=0
            RF_Wen=1
            Sel=0
            ALU_EN=1
            Sd=int(line[1][1:],16)
            Sa=int(line[2][1:],16)
            Sb=int(line[3][1:],16)
            reg[Sd]=reg[Sa] & reg[Sb]
        elif(line[0]=='ANDI'):
            Op=0
            RF_Wen=1
            Sel=1
            ALU_EN=1
            Sd=int(line[1][1:],16)
            Sa=int(line[2][1:],16)
            imm=int(line[3][1:],16)
            reg[Sd]=reg[Sa] & imm
        elif(line[0]=='OR'):
            Op=0
            RF_Wen=1
            AND0OR1=1
            Sel=0
            ALU_EN=1
            Sd=int(line[1][1:],16)
            Sa=int(line[2][1:],16)
            Sb=int(line[3][1:],16)
            reg[Sd]=reg[Sa] | reg[Sb]
        elif(line[0]=='ORI'):
            Op=0
            RF_Wen=1
            AND0OR1=1
            Sel=1
            ALU_EN=1
            Sd=int(line[1][1:],16)
            Sa=int(line[2][1:],16)
            imm=int(line[3][1:],16)
            reg[Sd]=reg[Sa] | imm
        elif(line[0]=='NOP'):
            Op=0
        elif(line[0]=='ADD'):
            Op=2
            RF_Wen=1
            Sel=0
            ALU_EN=1
            Sd=int(line[1][1:],16)
            Sa=int(line[2][1:],16)
            Sb=int(line[3][1:],16)
            reg[Sd]=reg[Sa] + reg[Sb]
        elif(line[0]=='ADDI'):
            Op=2
            RF_Wen=1
            Sel=1
            ALU_EN=1
            Sd=int(line[1][1:],16)
            Sa=int(line[2][1:],16)
            imm=int(line[3][1:],16)
            reg[Sd]=reg[Sa] + imm
        elif(line[0]=='MUL'):
            Op=1
            RF_Wen=1
            Sel=0
            ALU_EN=1
            Sd=int(line[1][1:],16)
            Sa=int(line[2][1:],16)
            Sb=int(line[3][1:],16)
            writeVEC(i,period,out,Op,Sa,Sb,Sd,Sel,Load_sel,imm,Mem_add,0,Mem_Wen,Mem_Ren,ADD0SUB1,AND0OR1,SFR0SFL1,LoadI,ALU_EN)
            i+=1
            writeVEC(i,period,out,Op,Sa,Sb,Sd,Sel,Load_sel,imm,Mem_add,0,Mem_Wen,Mem_Ren,ADD0SUB1,AND0OR1,SFR0SFL1,LoadI,ALU_EN)
            i+=1
            writeVEC(i,period,out,Op,Sa,Sb,Sd,Sel,Load_sel,imm,Mem_add,0,Mem_Wen,Mem_Ren,ADD0SUB1,AND0OR1,SFR0SFL1,LoadI,ALU_EN)
            i+=1
            writeVEC(i,period,out,Op,Sa,Sb,Sd,Sel,Load_sel,imm,Mem_add,0,Mem_Wen,Mem_Ren,ADD0SUB1,AND0OR1,SFR0SFL1,LoadI,ALU_EN)
            i+=1
            writeVEC(i,period,out,Op,Sa,Sb,Sd,Sel,Load_sel,imm,Mem_add,0,Mem_Wen,Mem_Ren,ADD0SUB1,AND0OR1,SFR0SFL1,LoadI,ALU_EN)
            i+=1
            reg[Sd]=reg[Sa] * reg[Sb]
        elif(line[0]=='MULI'):
            Op=1
            RF_Wen=1
            Sel=1
            ALU_EN=1
            Sd=int(line[1][1:],16)
            Sa=int(line[2][1:],16)
            imm=int(line[3][1:],16)
            writeVEC(i,period,out,Op,Sa,Sb,Sd,Sel,Load_sel,imm,Mem_add,0,Mem_Wen,Mem_Ren,ADD0SUB1,AND0OR1,SFR0SFL1,LoadI,ALU_EN)
            i+=1
            writeVEC(i,period,out,Op,Sa,Sb,Sd,Sel,Load_sel,imm,Mem_add,0,Mem_Wen,Mem_Ren,ADD0SUB1,AND0OR1,SFR0SFL1,LoadI,ALU_EN)
            i+=1
            writeVEC(i,period,out,Op,Sa,Sb,Sd,Sel,Load_sel,imm,Mem_add,0,Mem_Wen,Mem_Ren,ADD0SUB1,AND0OR1,SFR0SFL1,LoadI,ALU_EN)
            i+=1
            writeVEC(i,period,out,Op,Sa,Sb,Sd,Sel,Load_sel,imm,Mem_add,0,Mem_Wen,Mem_Ren,ADD0SUB1,AND0OR1,SFR0SFL1,LoadI,ALU_EN)
            i+=1
            writeVEC(i,period,out,Op,Sa,Sb,Sd,Sel,Load_sel,imm,Mem_add,0,Mem_Wen,Mem_Ren,ADD0SUB1,AND0OR1,SFR0SFL1,LoadI,ALU_EN)
            i+=1
            reg[Sd]=reg[Sa] * imm
        elif(line[0]=='MIN'):
            Op=2
            ADD0SUB1=1
            RF_Wen=1
            Sel=0
            ALU_EN=1
            Sd=int(line[1][1:],16)
            Sa=int(line[2][1:],16)
            Sb=int(line[3][1:],16)
            reg[Sd]=reg[Sa] - reg[Sb]
        elif(line[0]=='MINI'):
            Op=2
            ADD0SUB1=1
            RF_Wen=1
            Sel=1
            ALU_EN=1
            Sd=int(line[1][1:],16)
            Sa=int(line[2][1:],16)
            imm=int(line[3][1:],16)
            reg[Sd]=reg[Sa] - imm
        elif(line[0]=='SFL'):
            Op=3
            Sel=1
            RF_Wen=1
            SFR0SFL1=1
            ALU_EN=1
            Sd=int(line[1][1:],16)
            Sa=int(line[2][1:],16)
            imm=int(line[3][1:],16)
            reg[Sd]=reg[Sa] << imm
        elif(line[0]=='SFR'):
            Op=3
            Sel=1
            RF_Wen=1
            ALU_EN=1
            Sd=int(line[1][1:],16)
            Sa=int(line[2][1:],16)
            imm=int(line[3][1:],16)
            reg[Sd]=reg[Sa] >> imm
        else:
            continue
        writeVEC(i,period,out,Op,Sa,Sb,Sd,Sel,Load_sel,imm,Mem_add,RF_Wen,Mem_Wen,Mem_Ren,ADD0SUB1,AND0OR1,SFR0SFL1,LoadI,ALU_EN)
        i+=1
        print reg

    Op=0#Op code
    Sa=0#register A
    Sb=0#register B
    Sd=0#destination register
    Sel=0#select imm or register A
    Load_sel=0#select load imm or MEM
    imm=0#immediate
    Mem_add=0#memory address
    RF_Wen=0#RF write enable
    Mem_Wen=0#MEM write enable
    Mem_Ren=0#MEM read enable
    ADD0SUB1=0
    AND0OR1=0
    SFR0SFL1=0
    LoadI=0
    
    #Add 5 NOP
    writeVEC(i,period,out,Op,Sa,Sb,Sd,Sel,Load_sel,imm,Mem_add,RF_Wen,Mem_Wen,Mem_Ren,ADD0SUB1,AND0OR1,SFR0SFL1,LoadI,ALU_EN)
    i+=1
    writeVEC(i,period,out,Op,Sa,Sb,Sd,Sel,Load_sel,imm,Mem_add,RF_Wen,Mem_Wen,Mem_Ren,ADD0SUB1,AND0OR1,SFR0SFL1,LoadI,ALU_EN)
    i+=1
    writeVEC(i,period,out,Op,Sa,Sb,Sd,Sel,Load_sel,imm,Mem_add,RF_Wen,Mem_Wen,Mem_Ren,ADD0SUB1,AND0OR1,SFR0SFL1,LoadI,ALU_EN)
    i+=1
    writeVEC(i,period,out,Op,Sa,Sb,Sd,Sel,Load_sel,imm,Mem_add,RF_Wen,Mem_Wen,Mem_Ren,ADD0SUB1,AND0OR1,SFR0SFL1,LoadI,ALU_EN)
    i+=1
    writeVEC(i,period,out,Op,Sa,Sb,Sd,Sel,Load_sel,imm,Mem_add,RF_Wen,Mem_Wen,Mem_Ren,ADD0SUB1,AND0OR1,SFR0SFL1,LoadI,ALU_EN)
    i+=1
    cmd.close()
if __name__ == "__main__": main()
