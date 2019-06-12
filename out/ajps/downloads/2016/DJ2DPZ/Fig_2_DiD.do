
use database_parties, clear
do variables_parties

********************************************************************************

* Do graph

set scheme s1color

gen bin=running-mod(running,0.01)+0.01/2
bysort bin term_limit: egen freq=total(1)
bysort bin term_limit:keep if _n==1
xtset bin term_limit
gen dfreq=d.freq
bysort bin: keep if _n==2

keep if abs(bin)<=0.5

lpoly dfreq bin if bin<0, bw(0.5) deg(2) n(100) gen(x0 s0) ci se(se0) kernel(tri)
lpoly dfreq bin if bin>=0, bw(0.5) deg(2) n(100) gen(x1 s1) ci se(se1) kernel(tri)



/* Get the 95% CIs */
forvalues v=0/1 {
    gen ul`v' = s`v' + 1.95*se`v'

	gen ll`v' = s`v' - 1.95*se`v' 
	}
	
	
qui: tw  (rarea ul0 ll0  x0 , bcolor(gs15)  lcolor(black) lpattern(solid solid solid))  (rarea ul1 ll1  x1 ,  bcolor(gs15) lcolor(black) lpattern(solid  )) (line s0 ul0 ll0 x0 , lcolor(black dimgray dimgray) lpattern(solid solid solid))  (line s1 ul1 ll1 x1 , lcolor(black dimgray dimgray) lpattern(solid solid solid)) (scatter dfreq bin, msymbol(circle )  msize(small) mcolor(black) ), legend(off) xtitle("Vote Margin (t -1) - Diff-in-disc") ytitle("Frequency") xline(0, lcolor(black))

graph export mccrarystyle.eps, replace
