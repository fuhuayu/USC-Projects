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

*add transistors
*pfet is for the finfet nfet
mp1 Vdd A Z Vdd pfet L=lg NFIN=p_fin
mn1 Z Vdd B Vdd nfet L=lg NFIN=n_fin
mn2 B A Gnd A nfet L=lg NFIN=n_fin
*add cap
Cz Z Gnd 'LoadCap'

*add voltage sourse
VY A 0 PULSE Vdd 0 '1n' 'slope' 'slope' '1n-slope' '2n'



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
.MEASURE TRAN risedelay TRIG V(A) VAL='vdd/2' FALL=2 TARG V(Z) VAL='vdd/2' RISE=2
.MEASURE TRAN falldelay TRIG V(A) VAL='vdd/2' RISE=2 TARG V(Z) VAL='vdd/2' FALL=2
.MEASURE TRAN risetime TRIG V(Z) VAL='vdd*0.2' RISE=2 TARG V(Z) VAL='vdd*0.8' RISE=2
.MEASURE TRAN falltime TRIG V(Z) VAL='vdd*0.8' FALL=2 TARG V(Z) VAL='vdd*0.2' FALL=2
.MEASURE TRAN SwitchPower AVG P(mp1) FROM=0.5n TO=2.5n
.MEASURE TRAN LeakPower AVG P(mn2) FROM=2.2n TO=2.8n
.MEASURE TRAN SwitchEngergy Param='SwitchPower*2n'
.end
