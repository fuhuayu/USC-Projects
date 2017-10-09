from subprocess import call
def replace_line(file_name, line_num, text):
    lines = open(file_name, 'r').readlines()
    lines[line_num] = text
    out = open(file_name, 'w')
    out.writelines(lines)
    out.close()
f = open("output.txt", 'w')
f.write("Name\tnP\tnN\trisedelay\tfalldelay\trisetime\tfalltime\trisefallratio\n")
def test(name):
    for i in range(1,11):
        replace_line(name+".sp",12,".param p_fin = "+str(i)+"\n")
        for j in range(1,11):
            f.write(name+"\t"+str(i)+"\t"+str(j)+"\t")
            replace_line(name+".sp",13,".param n_fin = "+str(j)+"\n")
            call(["hspice",name+".sp"])
            lines = open(name+".mt0", 'r').readlines()
            n=lines[4].split()
            print n
            f.write(n[0]+"\t"+n[1]+"\t"+n[2]+"\t"+n[3]+"\t"+str(float(n[0][:4])/float(n[1][:4]))+"\n")
test('inv')
test('nand')
test('nor')
f.close()
            
            
            
        
