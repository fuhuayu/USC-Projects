# Copyright (c) 2017, Huayu Fu, Yang Zhang, and Huimei Cheng
# All rights reserved.

# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
    # * Redistributions of source code must retain the above copyright
      # notice, this list of conditions and the following disclaimer.
    # * Redistributions in binary form must reproduce the above copyright
      # notice, this list of conditions and the following disclaimer in the
      # documentation and/or other materials provided with the distribution.
    # * Neither the name of the University of Southern California nor the
      # names of its contributors may be used to endorse or promote products
      # derived from this software without specific prior written permission.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL HUAYU FU, YANG ZHANG, AND HUIMEI CHENG BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
import sys
import getopt
import os
EDGE_ROOT = os.environ['EDGE_ROOT']
__doc__='option -m for setting number of master\n       -s for setting number of slave\nfollowing (m+1)*s argvs are the relation of master to slave'
# inputs:outputName,filePointer,numberOfCell
# write out C element naming format :
# c_element CELE_[outputName]_l[level of c_element]{_[number for c_element in same level]} (%s,%s,%s);
def writeConnectionFor_a_ack(outputName,numberOfCell,filePointer):
    level=0 #level of C element
    l=[outputName+'_%d' %i for i in range(1,numberOfCell+1)] # List of input signal
    if len(l)==1: # if number of input=1
        filePointer.write('assign %s=%s;\n' %(outputName,l[0]))
    while len(l)>1:
        level+=1
    	length=len(l)
    	if(length==2):
            #write the top level C element connect to the output
    	    filePointer.write('c_element CELE_%s_l%d (%s,%s,%s);\n' %(outputName,level,l[0],l[1],outputName))
    	    l=[outputName]
    	else:
            # list of new wire name for next level/iteration: [outputName]_l[level of c_element]_[number for c_element in same level]
    	    nl=[outputName+'_l%d_%d' %(level,i) for i in range(1,length/2+1)]
            # create interconnected wires;
    	    filePointer.write('wire %s;\n' %','.join(nl))
            # if length not even, append last element of l to nl
    	    if(length%2==1):
                nl.append(l[-1])
            # write the c_element
    	    [filePointer.write('c_element CELE_%s_l%d_%d (%s,%s,%s);\n' %(outputName,level,i,l[i*2-2],l[i*2-1],nl[i-1])) for i in range(1,length/2+1)]
    	    l=nl
# inputs:outputName,filePointer,outList[list of port have connect to output]
# write out C element naming format :
# c_element CELE_[outputName]_out_l[level of c_element]{_[number for c_element in same level]} (%s,%s,%s);
def writeConnectionFor_b_req(outputName,outList,filePointer):
    level=0
    #write the second half dummy_buffer for output
    l=[outputName+'_db_%d_out' %i for i in outList]
    filePointer.write('wire %s;\n' %','.join(l))
    [filePointer.write('dummy_buffer s2_b_req_%d_out_BUF (s2_b_req_db_%d, s2_b_req_db_%d_out);\n'%(i,i,i)) for i in outList]
    if len(l)==1: # if number of input=1
        filePointer.write('assign %s=%s;\n' %(outputName,l[0]))
    while len(l)>1:
        level+=1
        length=len(l)
        if(length==2):
            #write the top level C element connect to the output
            filePointer.write('c_element CELE_%s_out_l%d (%s,%s,%s);\n' %(outputName,level,l[0],l[1],outputName))
            l=[]
        else:
            # list of new wire name for next level/iteration: [outputName]_out_l[level of c_element]_[number for c_element in same level]
            nl=[outputName+'_out_l%d_%d' %(level,i) for i in range(1,length/2+1)]
            filePointer.write('wire %s;\n' %','.join(nl))
            # if length not even, append last element of l to nl
            if(length%2==1):
                nl.append(l[-1])
            # write the c_element
            [filePointer.write('c_element CELE_%s_out_l%d_%d (%s,%s,%s);\n' %(outputName,level,i,l[i*2-2],l[i*2-1],nl[i-1])) for i in range(1,length/2+1)]
            l=nl
# inputs:slavePort,masterPort,mts_reverse,filePointer
# write out C element naming format :
# c_element CELE_[masterPort]_[masterNumber]_l[level of c_element] (%s,%s,%s);
def writeConnectionMasterToSlaveReq(slavePort,masterPort,mts_reverse,filePointer):
    slaveNumber=0 # counter for slave number
    for s in mts_reverse: # for connections to each slavePort
        slaveNumber+=1
        #write the second half dummy_buffer for output
        l=[masterPort+'_db_%d_m%d' %(i,slaveNumber) for i in s]
        filePointer.write('wire %s;\n' %','.join(l))
        [filePointer.write('dummy_buffer %s_%d_m%d_BUF (%s_db_%d, %s_db_%d_m%d);\n'%(masterPort,i,slaveNumber,masterPort,i,masterPort,i,slaveNumber)) for i in s]
        level=0 #level for c_element
        if len(l)==1: # if number of input=1
            filePointer.write('assign %s_%d=%s;\n' %(slavePort,slaveNumber,l[0]))
        while len(l)>1:
            level+=1
            length=len(l)
            if(length==2):
                #write the top level C element connect to the slavePort
                filePointer.write('c_element CELE_%s_%d_l%d (%s,%s,%s_%d);\n' %(masterPort,slaveNumber,level,l[0],l[1],slavePort,slaveNumber))
                l=[]
            else:
                # list of new wire name for next level/iteration: [masterPort]_l[level of c_element]_[slave number]_[number for c_element in same level]
                nl=[masterPort+'_l%d_%d_%d' %(level,slaveNumber,i) for i in range(1,length/2+1)]
                filePointer.write('wire %s;\n' %','.join(nl))
                # if length not even, append last element of l to nl
                if(length%2==1):
                    nl.append(l[-1])
                # write the c_element
                [filePointer.write('c_element CELE_%s_%d_l%d (%s,%s,%s);\n' %(masterPort,slaveNumber,level,l[i*2-2],l[i*2-1],nl[i-1])) for i in range(1,length/2+1)]
                l=nl
# inputs:slavePort,masterPort,mts,filePointer
# write out C element naming format :
# c_element CELE_[masterPort]_[masterNumber]_l[level of c_element] (%s,%s,%s);
def writeConnectionSlaveToMasterAck(masterPort,slavePort,mts,filePointer):
    masterNumber=0 # counter for master number
    for m in mts: # for connections to each masterPort
        masterNumber+=1
        level=0
        l=[slavePort+'_%d' %i for i in m]
        if len(l)==1:
            filePointer.write('assign %s_%d=%s;\n' %(masterPort,masterNumber,l[0]))
        while len(l)>1:
            level+=1
            length=len(l)
            if(length==2):
                #write the top level C element connect to the masterPort
                filePointer.write('c_element CELE_%s_%d_l%d (%s,%s,%s_%d);\n' %(slavePort,masterNumber,level,l[0],l[1],masterPort,masterNumber))
                l=[]
            else:
                # list of new wire name for next level/iteration: [masterPort]_l[level of c_element]_[slave number]_[number for c_element in same level]
                nl=[slavePort+'_l%d_%d_%d' %(level,masterNumber,i) for i in range(1,length/2+1)]
                filePointer.write('wire %s;\n' %','.join(nl))
                # if length not even, append last element of l to nl
                if(length%2==1):
                    nl.append(l[-1])
                # write the c_element
                [filePointer.write('c_element CELE_%s_%d_l%d (%s,%s,%s);\n' %(slavePort,masterNumber,level,l[i*2-2],l[i*2-1],nl[i-1])) for i in range(1,length/2+1)]
                l=nl
# inputs:slavePort,masterPort,mts,filePointer
# write out C element naming format :
# c_element CELE_[masterPort]_[masterNumber]_l[level of c_element] (%s,%s,%s);
def writeConnectionSlaveToMasterReq(masterPort,slavePort,inputReq,stm_reverse,filePointer):
    masterNumber=0# counter for master number
    for m in stm_reverse: # for connections to each masterPort
        masterNumber+=1
        l=[slavePort+'_db_%d_m%d' %(i,masterNumber) for i in m]
        if l!=[]:
            filePointer.write('wire %s;\n' %','.join(l))
            filePointer.write('wire %s_db_m%d;\n' %(inputReq,masterNumber));
            filePointer.write('dummy_buffer a_req_BUF_m%d (%s_db, %s_db_m%d);\n' %(masterNumber,inputReq,inputReq,masterNumber))
        [filePointer.write('dummy_buffer %s_%d_m%d_BUF (%s_db_%d, %s_db_%d_m%d);\n'%(slavePort,i,masterNumber,slavePort,i,slavePort,i,masterNumber)) for i in m]
        level=0
        l.append(inputReq)
        if len(l)==1:
            filePointer.write('assign %s_%d=%s;\n' %(masterPort,masterNumber,l[0]))
        while len(l)>1:
            level+=1
            length=len(l)
            if(length==2):
                #write the top level C element connect to the masterPort
                filePointer.write('c_element CELE_%s_ex_%d_l%d (%s,%s,%s_%d);\n' %(slavePort,masterNumber,level,l[0],l[1],masterPort,masterNumber))
                l=[]
            else:
                # list of new wire name for next level/iteration: [masterPort]_ex_l[level of c_element]_[slave number]_[number for c_element in same level]
                nl=[slavePort+'_ex_l%d_%d_%d' %(level,masterNumber,i) for i in range(1,length/2+1)]
                filePointer.write('wire %s;\n' %','.join(nl))
                if(length%2==1):
                    nl.append(l[-1])
                # write the c_element
                [filePointer.write('c_element CELE_%s_ex_%d_l%d (%s,%s,%s);\n' %(slavePort,masterNumber,level,l[i*2-2],l[i*2-1],nl[i-1])) for i in range(1,length/2+1)]
                l=nl
def writeConnectionMasterToSlaveAck(slavePort,masterPort,inputAck,stm,filePointer):
    slaveNumber=0 # counter for slave number
    for s in stm:
        slaveNumber+=1
        level=0
        l=[masterPort+'_%d' %i for i in s]
        l.append(inputAck)
        if len(l)==1:
            filePointer.write('assign %s_%d=%s;\n' %(slavePort,slaveNumber,l[0]))
        while len(l)>1:
            level+=1
            length=len(l)
            if(length==2):
                #write the top level C element connect to the masterPort
                filePointer.write('c_element CELE_%s_ex_%d_l%d (%s,%s,%s_%d);\n' %(masterPort,slaveNumber,level,l[0],l[1],slavePort,slaveNumber))
                l=[]
            else:
                # list of new wire name for next level/iteration: [masterPort]_ex_l[level of c_element]_[slave number]_[number for c_element in same level]
                nl=[masterPort+'_ex_l%d_%d_%d' %(level,slaveNumber,i) for i in range(1,length/2+1)]
                filePointer.write('wire %s;\n' %','.join(nl))
                if(length%2==1):
                    nl.append(l[-1])
                # write the c_element
                [filePointer.write('c_element CELE_%s_ex_%d_l%d (%s,%s,%s);\n' %(masterPort,slaveNumber,level,l[i*2-2],l[i*2-1],nl[i-1])) for i in range(1,length/2+1)]
                l=nl


def writeFile(m,s,mts,stm,sto):
    mts_reverse=[] # ack relations of master to slave relation
    stm_reverse=[] # ack relations of slave to master relation
    for i in range(s):
        temp=[]
        for j in range(m):
            if i+1 in mts[j]:
                temp.append(j+1)
        mts_reverse.append(temp)
    for i in mts_reverse:
        if i==[]:
            print 'at least one mts_reverse relation is empty'
            sys.exit(2)
    for i in range(m):
        temp=[]
        for j in range(s):
            if i+1 in stm[j]:
                temp.append(j+1)
        stm_reverse.append(temp)
    # infile=open('ctrl_path.template','r')
    # out=open(EDGE_ROOT+'/common/ctrl_path'+'.v','w')
    infile=open(EDGE_ROOT+'/common/ctrl_path.template','r')
    out=open('ctrl_path1'+'.v','w')

    count=0
    for line in infile:
        if count==25:
            break;
        out.write(line)
        count+=1
#write module
    out.write('module ctrl_path (a_req,a_ack,b_req,b_ack,reset,')
    [out.write('clk1_%d,' %i) for i in range(1,m+1)]
    [out.write('clk2_%d,' %i) for i in range(1,s)]
    out.write('clk2_%d);\n' %s)
#write input output
    out.write('input a_req,b_ack,reset;\n')
    out.write('output a_ack,b_req,')
    [out.write('clk1_%d,' %i) for i in range(1,m+1)]
    [out.write('clk2_%d,' %i) for i in range(1,s)]
    out.write('clk2_%d;\n' %s)
#write wires
    out.write('wire a_ack,b_req,')
    [out.write('clk1_%d,' %i) for i in range(1,m+1)]
    [out.write('clk2_%d,' %i) for i in range(1,s)]
    out.write('clk2_%d;\n' %s)
    [out.write('wire s1_a_req_%d, s1_a_ack_%d, s1_b_req_%d, s1_b_req_db_%d, s1_b_ack_%d;\n' %(i,i,i,i,i)) for i in range(1,m+1)]
    [out.write('wire s2_a_req_%d, s2_a_ack_%d, s2_b_req_%d, s2_b_req_db_%d, s2_b_ack_%d;\n' %(i,i,i,i,i)) for i in range(1,s+1)]
    out.write('wire s1_b_req,s2_b_req,s1_a_ack,s2_a_ack,s1_a_req,s2_b_ack;\n')
    out.write('assign a_ack=s1_a_ack;\nassign b_req=s2_b_req;\n')
    #[out.write('assign s1_a_req_%d=s1_a_req;\n' %i) for i in range(1,m+1)]
    #[out.write('assign s1_b_ack_%d=s2_a_ack;\n' %i) for i in range(1,n+1)]
    #[out.write('assign s2_a_req_%d=s1_b_req;\n' %i) for i in range(1,n+1)]
    #[out.write('assign s2_b_ack_%d=s2_b_ack;\n' %i) for i in range(1,s+1)]
#add dummy buffer
#a_req
    out.write('wire a_req_db;\n');
    out.write('dummy_buffer a_req_BUF (a_req, a_req_db);\n')
#s1 s2 b_req
    [out.write('dummy_buffer s1_b_req_%d_BUF (s1_b_req_%d, s1_b_req_db_%d);\n'%(i,i,i))   for i in range(1,m+1)]
    [out.write('dummy_buffer s2_b_req_%d_BUF (s2_b_req_%d, s2_b_req_db_%d);\n'%(i,i,i))   for i in range(1,m+1)]
#wirte controller
    [out.write('controller_notk_1req CTRL1_%d (reset, s1_a_req_%d, s1_a_ack_%d, s1_b_req_%d, s1_b_ack_%d, clk1_%d);\n' %(i,i,i,i,i,i)) for i in range(1,m+1)]
    [out.write('controller_tk_1req CTRL2_%d (reset, s2_a_req_%d, s2_a_ack_%d, s2_b_req_%d, s2_b_ack_%d, clk2_%d);\n' %(i,i,i,i,i,i)) for i in range(1,s+1)]
#write new CELE
    out.write('//s1 to s1_a_ack\n')
    writeConnectionFor_a_ack('s1_a_ack',m,out)
    #writeNewCELE('s2_a_ack',out,n)
    #writeNewCELE('s1_b_req',out,n)
    out.write('//s2 to s2_b_req\n')
    writeConnectionFor_b_req('s2_b_req',sto,out)
    out.write('//s1_b_req to s2_a_req\n')
    writeConnectionMasterToSlaveReq('s2_a_req','s1_b_req',mts_reverse,out)
    out.write('//s2_a_ack to s1_b_ack\n')
    writeConnectionSlaveToMasterAck('s1_b_ack','s2_a_ack',mts,out)
    out.write('//s2_b_req to s1_a_req\n')
    writeConnectionSlaveToMasterReq('s1_a_req','s2_b_req','a_req',stm_reverse,out)
    out.write('//s1_a_ack to s2_b_ack\n')
    writeConnectionMasterToSlaveAck('s2_b_ack','s1_a_ack','b_ack',stm,out)
    out.write('endmodule\n')
    out.close()
def main():
    m=0#number of master
    s=0#number of slave
    p=[]
    mts=[]#master to slave req relations
    stm=[]#slave to master req relations
    sto=[]#slave to output req relations
    # parse command line options
    try:
        opts, args = getopt.getopt(sys.argv[1:], 'm:s:p:', ['help','master=','slave=','parameter='])
    except getopt.error, msg:
        print msg
        print 'for help use --help'
        sys.exit(2)
    # process options
    for o, a in opts:
        if o in ('-h', '--help'):
            print __doc__
            sys.exit(0)
    	if o in ('-m', '--master'):
	        m=int(a)
    	if o in ('-s', '--slave'):
    	    s=int(a)
        if o in ('-p', '--parameter'):
	        p=a.split(' ')
    if len(p)<m*s*2+s:
        print 'p not long enough'
        sys.exit(2)
    # get mts
    for i in range(m):
        temp=[]
        for j in range(s):
            if p[i*s+j]=='1':
                temp.append(j+1)
        mts.append(temp)
    # get stm
    for i in range(s):
        temp=[]
        for j in range(m):
            if p[i*s+j+m*s]=='1':
                temp.append(j+1)
        stm.append(temp)
    # get sto
    for i in range(s):
        if p[m*s*2+i]=='1':
            sto.append(i+1)
    # check sto
    if(sto==[]):
        print 'sto cannot be empty'
        sys.exit(2)
    # check sto
    for i in mts:
        if i==[]:
            print 'at least one mts relation is empty'
            sys.exit(2)
    #print mts,stm,sto
    writeFile(m,s,mts,stm,sto)
if __name__ == '__main__':
    main()
