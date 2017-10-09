from subprocess import call
def replace_line(file_name, line_num, text):
    lines = open(file_name, 'r').readlines()
    lines[line_num] = text
    out = open(file_name, 'w')
    out.writelines(lines)
    out.close()
f = open("output1.txt", 'w')
f.write("Name\tnP\tnN\trisedelay\tfalldelay\trisetime\tfalltime\trisefallratio\n")
def test(name,nP,nN):
    l=[1,2,4]
    for i in l:
        replace_line(name+".sp",12,".param p_fin = "+str(nP*i)+"\n")
        replace_line(name+".sp",13,".param n_fin = "+str(nN*i)+"\n")
        f.write(name+"\t"+str(nP*i)+"\t"+str(nN*i)+"\t")
        call(["hspice",name+".sp"])
        lines = open(name+".mt0", 'r').readlines()
        n=lines[4].split()
        print n
        f.write(n[0]+"\t"+n[1]+"\t"+n[2]+"\t"+n[3]+"\t"+str(float(n[0][:4])/float(n[1][:4]))+"\n")
test('inv',7,6)
test('nand',7,7)
test('nor',10,7)
f.close()
            
            
            
        
