from subprocess import call
def replace_line(file_name, line_num, text):
    lines = open(file_name, 'r').readlines()
    lines[line_num] = text
    out = open(file_name, 'w')
    out.writelines(lines)
    out.close()
f = open("dram.txt", 'w')
f.write("W\tS\trtl\tavg_current\tavg_power\n")
for i in range(1,17):
    replace_line("dram.sp",13,".param multiplier = "+str(i)+"\n")
    f.write(str(i)+"\t"+str(0.01)+"\t")
    replace_line("dram.sp",14,".param LoadCap = "+str(0.01)+"a\n")
    #call(["hspice","dram.sp"])
    lines = open("dram.mt0", 'r').readlines()
    n=lines[4].split()
    f.write(n[0]+"\t"+n[1]+"\t"+n[2]+"\n")
    for j in range(1,11):
        f.write(str(i)+"\t"+str(pow(5,j*0.1))+"\t")
        replace_line("dram.sp",14,".param LoadCap = "+str(pow(5,j*0.1))+"a\n")
        #call(["hspice","dram.sp"])
        lines = open("dram.mt0", 'r').readlines()
        n=lines[4].split()
        f.write(n[0]+"\t"+n[1]+"\t"+n[2]+"\n")
f.close()
            
            
            
        
