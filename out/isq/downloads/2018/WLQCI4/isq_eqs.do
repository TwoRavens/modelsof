
use isq_dvsqb.dta
mlogit dvsqb milratio alliance strvalue slc3b endriv5b ethvalue1 demdum sqtime1 if begmopog==1, cluster(dispno2) b(1)


use isq_dvesc.dta
bioprobit (dvesc2=milratio alliance strvalue slc3b ethvalue1 endriv5b demdum dvesctime) (odvesc2=omilratio alliance ostrvalue slt3b ethvalue2 endriv5b odemdum odvesctime) if endmopogb==1 & dvsqb==2, cluster(dispno2)
