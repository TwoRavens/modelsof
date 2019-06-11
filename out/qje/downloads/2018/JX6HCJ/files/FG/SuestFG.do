
use DatFG1, clear
tab fahrer, gen(F)
drop F1

*Table 3

global i = 1

reg totrev high block2 block3 F* if maxhigh==1,  
	estimates store M$i
	global i = $i + 1

reg totrev high block2 block3 F* if vebli==1,  
	estimates store M$i
	global i = $i + 1

reg totrev high exp block2 block3 F*,  
	estimates store M$i
	global i = $i + 1

reg shifts high block2 block3 F* if maxhigh==1,  
	estimates store M$i
	global i = $i + 1

reg shifts high block2 block3 F* if vebli==1,  
	estimates store M$i
	global i = $i + 1

reg shifts high exp block2 block3 F*,  
	estimates store M$i
	global i = $i + 1

suest M1 M2 M3 M4 M5 M6, cluster(fahrer)
test high
matrix F = (r(p), r(drop), r(df), r(chi2), 3)

**********************************
 
use DatFG2, clear
tab datum, gen(D)
drop D1

global i = 1

*Table 5 
reg lnum high lnten female D*,  
	estimates store M$i
	global i = $i + 1

reg lnum high lnten fdum* D*,  
	estimates store M$i
	global i = $i + 1

suest M1 M2, cluster(datum)
test high
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 5)


global i = 1

*Table 6 
reg lnum high_la high_not0 lnten fdum* D*,  
	estimates store M$i
	global i = $i + 1

reg lnum high_la1 high_la2 high_not0 lnten fdum* D*,  
	estimates store M$i
	global i = $i + 1

suest M1 M2, cluster(datum)
test high_la high_la1 high_la2 high_not0
matrix F = F \ (r(p), r(drop), r(df), r(chi2), 6)

drop _all
svmat double F
save results/SuestFG, replace



