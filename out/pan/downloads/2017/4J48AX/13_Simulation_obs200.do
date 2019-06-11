
*Compare estimated and true survival curves

set more off

set seed 224677	// acquired from random.org 2016-09-14 11:26:49 UTC

*negative, getting positive

use sim, clear
count
local N=r(N)
drop in 1/`N'

save sim, replace

local g=1

forvalues p=0.75(0.25)1.25 {				

forvalues i=1/200 {

local lambda=0.05 		
local b1=-0.8			
local b2=.3			

clear

set obs 200
gen var=rnormal()>0
survsim ftime, cov(var `b1') tde(var `b2') distribution(weibull) lambda(`lambda') gammas(`p')

gen id=_n
gen fail=1
stset ftime, id(id) failure(fail)
capture scurve_tvc, gen(S_est) at(var 1) tvc(var) texp(ln(_t))

gen S_true=exp(-(exp(ln(`lambda')+`b1')*`p'*_tscurve^(`p'+`b2')/(`p'+`b2')))

keep S* _tscurve

gen sim_nr=`i'

gen p=`p'

append using sim.dta

save sim, replace

}

keep if p==`p'

gen failgroup=ceil(_tscurve)

bysort fail: gen num=_N
drop if num<20

gen diff=S_est-S_true

bysort fail: egen p5=pctile(diff), p(5)
bysort fail: egen p95=pctile(diff), p(95)
bysort fail: egen median=pctile(diff)

lpoly diff _tscurve, ci noscatter addplot(line p5 p95 median _ts, lp(dash dash shortdash) lcol(gs10 gs10 black)) t2title("p=`p'") title("") ytitle("") legend(off) saving(p1`g'_obs200,replace) note("")
local g=`g'+1
}

graph combine p11_obs200.gph p12_obs200.gph p13_obs200.gph, col(3) ycommon subtitle("negative hazard ratio, turning positive") saving(p1_obs200, replace)


*postive, getting negative

use sim, clear
count
local N=r(N)
drop in 1/`N'
local g=1

save sim, replace

forvalues p=0.75(0.25)1.25 {				

forvalues i=1/200 {

local lambda=0.05 		
local b1=0.8			
local b2=-.3				

clear

set obs 200
gen var=rnormal()>0
survsim ftime, cov(var `b1') tde(var `b2') distribution(weibull) lambda(`lambda') gammas(`p')

gen id=_n
gen fail=1
stset ftime, id(id) failure(fail)
capture scurve_tvc, gen(S_est) at(var 1) tvc(var) texp(ln(_t))

gen S_true=exp(-(exp(ln(`lambda')+`b1')*`p'*_tscurve^(`p'+`b2')/(`p'+`b2')))

keep S* _tscurve

gen sim_nr=`i'

gen p=`p'

append using sim.dta

save sim, replace

}

keep if p==`p'

gen failgroup=ceil(_tscurve)

bysort fail: gen num=_N
drop if num<20

gen diff=S_est-S_true

bysort fail: egen p5=pctile(diff), p(5)
bysort fail: egen p95=pctile(diff), p(95)
bysort fail: egen median=pctile(diff)

lpoly diff _tscurve, ci noscatter addplot(line p5 p95 median _ts, lp(dash dash shortdash) lcol(gs10 gs10 black)) t2title("p=`p'") title("") ytitle("") legend(off) saving(p2`g'_obs200,replace) note("")
local g=`g'+1
}

graph combine p21_obs200.gph p22_obs200.gph p23_obs200.gph, col(3) ycommon subtitle("positive hazard ratio, turning negative") saving(p2_obs200, replace)



*positive, getting more positive

use sim, clear
count
local N=r(N)
drop in 1/`N'
local g=1

save sim, replace


forvalues p=0.75(0.25)1.25 {				

forvalues i=1/200 {

local lambda=0.05 		
local b1=.8			
local b2=.3				

clear

set obs 200
gen var=rnormal()>0
survsim ftime, cov(var `b1') tde(var `b2') distribution(weibull) lambda(`lambda') gammas(`p')

gen id=_n
gen fail=1
stset ftime, id(id) failure(fail)
capture scurve_tvc, gen(S_est) at(var 1) tvc(var) texp(ln(_t))

gen S_true=exp(-(exp(ln(`lambda')+`b1')*`p'*_tscurve^(`p'+`b2')/(`p'+`b2')))

keep S* _tscurve

gen sim_nr=`i'

gen p=`p'

append using sim.dta

save sim, replace

}

keep if p==`p'

gen failgroup=ceil(_tscurve)

bysort fail: gen num=_N
drop if num<20

gen diff=S_est-S_true

bysort fail: egen p5=pctile(diff), p(5)
bysort fail: egen p95=pctile(diff), p(95)
bysort fail: egen median=pctile(diff)

lpoly diff _tscurve, ci noscatter addplot(line p5 p95 median _ts, lp(dash dash shortdash) lcol(gs10 gs10 black)) t2title("p=`p'") title("") ytitle("") legend(off) saving(p3`g'_obs200,replace) note("")
local g=`g'+1
}

graph combine p31_obs200.gph p32_obs200.gph p33_obs200.gph, col(3) ycommon subtitle("positive hazard ratio, getting more positive") saving(p3_obs200, replace)


*negative, getting more negative

use sim, clear
count
local N=r(N)
drop in 1/`N'
local g=1

save sim, replace


forvalues p=0.75(0.25)1.25 {				

forvalues i=1/200 {

local lambda=0.05 		
local b1=-.8			
local b2=-.3				

clear

set obs 200
gen var=rnormal()>0
survsim ftime, cov(var `b1') tde(var `b2') distribution(weibull) lambda(`lambda') gammas(`p')

gen id=_n
gen fail=1
stset ftime, id(id) failure(fail)
capture scurve_tvc, gen(S_est) at(var 1) tvc(var) texp(ln(_t))

gen S_true=exp(-(exp(ln(`lambda')+`b1')*`p'*_tscurve^(`p'+`b2')/(`p'+`b2')))

keep S* _tscurve

gen sim_nr=`i'

gen p=`p'

append using sim.dta

save sim, replace

}

keep if p==`p'

gen failgroup=ceil(_tscurve)

bysort fail: gen num=_N
drop if num<20

gen diff=S_est-S_true

bysort fail: egen p5=pctile(diff), p(5)
bysort fail: egen p95=pctile(diff), p(95)
bysort fail: egen median=pctile(diff)

lpoly diff _tscurve, ci noscatter addplot(line p5 p95 median _ts, lp(dash dash shortdash) lcol(gs10 gs10 black)) t2title("p=`p'") title("") ytitle("") legend(off) saving(p4`g'_obs200,replace)  note("")
local g=`g'+1
}

graph combine p41_obs200.gph p42_obs200.gph p43_obs200.gph, col(3) ycommon subtitle("negative hazard ratio, getting more negative") saving(p4_obs200, replace)

graph combine p1_obs200.gph p2_obs200.gph p3_obs200.gph p4_obs200.gph, col(1)
graph display, ysize(10)
graph export simulation_scurve_tvc_obs200.pdf, replace
