*************************
*  lab3 sample hspice
*************************

.include './lp32nm.pm'

*define parameters 
.param vdd=1 
.param vss=0 
*.param fin_height=18n 
*.param fin_width=7n 
.param lg=32n 
.param wg=64n
.param multiplier = 16
.param LoadCap = 5.0a

VSS Gnd 0 'vss'


*add transistors 
*pfet is for the finfet nfet 
mp1 Z Y X vdd pmos W=wg L=lg m=multiplier

*add cap
Cz Z Gnd 'LoadCap'

*add voltage sourse
VX X 0 'vdd/2'
VY Y 0 'vdd'

*define the initial condition of V(Z)
.IC V(Z)='vdd'

*do transient analysis
.tran 0.1u 70u 

*print the V(Z) to waveform file *.tr0
.print V(Z)

*simulation options (you can modify this. Post is needed for .tran analysis)
.OPTION Post Brief NoMod probe measout

*measurement
.measure tran RTL TRIG AT=0 TARG v(Z) VAL=0.8 FALL=1
.measure tran avg_current AVG I(Cz) from 0 to 'RTL'
.measure tran avg_power AVG p(Cz) 

.end
