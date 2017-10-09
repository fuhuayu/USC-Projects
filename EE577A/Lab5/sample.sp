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
.param n_fin = 1
.param p_fin = 1
VSS Gnd 0 'vss'
VDD Vdd 0 'vdd'
.param LoadCap = 1f

*add transistors
*pfet is for the finfet nfet
mp1 Vdd A Z A pfet L=lg NFIN=p_fin
mp2 Vdd Gnd Z Gnd pfet L=lg NFIN=p_fin
mn1 Z A B A nfet L=lg NFIN=n_fin
mn1 B Vdd Gnd Vdd nfet L=lg NFIN=n_fin
*add cap
Cz Z Gnd 'LoadCap'

*add voltage sourse
VY A 0 PULSE Vdd 0 '1n' 'slope' 'slope' '1n' '2n'



*do transient analysis
	*syntax: .TRAN tiner tstop START=stval
	*tiner - time step
	*tstop - final time
	*stval - initial time (default 0)
.tran 1p 6n

*print the V(Z) to waveform file *.tr0
.print V(Z)

*simulation options (you can modify this. Post is needed for .tran analysis)
.OPTION Post Brief NoMod probe measout

*measurement
.MEASURE TRAN falldelay TRIG V(A) VAL='vdd/2' FALL=2 TARG V(Z) VAL='vdd/2' RISE=2
.MEASURE TRAN risedelay TRIG V(A) VAL='vdd/2' RISE=2 TARG V(Z) VAL='vdd/2' FALL=2

.end
