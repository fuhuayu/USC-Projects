*************************
*  lab5 sample hspice (1bit 1T DRAM cell)
*************************

.include './hp7nfet.pm'
.include './hp7pfet.pm'

*define parameters
.param vdd=0.7
.param vss=0
.param lg=11n
.param slope=10p
.param p_fin = 7
.param n_fin = 7
VSS Gnd 0 'vss'
VDD Vdd 0 'vdd'
.param LoadCap = 1f
.global Vdd
.global Gnd

.subckt nand A B Z
mp1 Vdd A Z A pfet L=lg NFIN=p_fin
mp2 Vdd B Z B pfet L=lg NFIN=p_fin
mn1 Z B C B nfet L=lg NFIN=n_fin
mn2 C A Gnd A nfet L=lg NFIN=n_fin
.ends
*add transistors
*pfet is for the finfet nfet
X1 A B Net1 nand
X2 A Net1 Net2 nand
X3 B Net1 Net3 nand
X4 Net2 Net3 Net4 nand
X5 Net4 C Net5 nand
X6 Net4 Net5 Net6 nand
X7 C Net5 Net7 nand
X8 Net6 Net7 S nand
X9 Net5 Net1 Cout nand
*add cap
Cs S Gnd 'LoadCap'
Ccout Cout Gnd 'LoadCap'
*add voltage sourse
VA A 0 PULSE Vdd 0 '1n' 'slope' 'slope' '1n-slope' '2n'
VB B 0 PULSE Vdd 0 '1n' 'slope' 'slope' '2n-slope' '4n'
VC C 0 PULSE Vdd 0 '1n' 'slope' 'slope' '4n-slope' '8n'

*do transient analysis
	*syntax: .TRAN tiner tstop START=stval
	*tiner - time step
	*tstop - final time
	*stval - initial time (default 0)
.tran 1p 18n

*print the V(Z) to waveform file *.tr0
.print V(A)
.print V(B)
.print V(C)
.print V(Cout)
.print V(S)
*simulation options (you can modify this. Post is needed for .tran analysis)
.OPTION Post Brief NoMod probe measout

*measurement
.MEASURE TRAN S_risedelay TRIG V(A) VAL='vdd/2' RISE=1 TARG V(S) VAL='vdd/2' RISE=1
.MEASURE TRAN S_falldelay TRIG V(A) VAL='vdd/2' RISE=2 TARG V(S) VAL='vdd/2' FALL=2
.MEASURE TRAN Cout_risedelay TRIG V(A) VAL='vdd/2' RISE=2 TARG V(Cout) VAL='vdd/2' RISE=1
.MEASURE TRAN Cout_falldelay TRIG V(A) VAL='vdd/2' FALL=1 TARG V(Cout) VAL='vdd/2' FALL=1
.end
