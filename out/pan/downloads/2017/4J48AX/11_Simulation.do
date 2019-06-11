
*Compare estimated and true survival curves

set more off

set seed 4573707	// acquired from random.org 2016-09-14 11:26:49 UTC

*negative, getting positive

use sim, clear
count
local N=r(N)
drop in 1/`N'

save sim, replace

local g=1

forvalues p=0.75(0.25)1.25 {				

forvalues i=1/100 {

local lambda=0.05 		
local b1=-0.8			
local b2=.3			

clear

set obs 500
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

lpoly diff _tscurve, ci noscatter addplot(line p5 p95 median _ts, lp(dash dash shortdash) lcol(gs10 gs10 black)) t2title("p=`p'") title("") ytitle("") legend(off) saving(p1`g',replace) note("")
local g=`g'+1
}

graph combine p11.gph p12.gph p13.gph, col(3) ycommon subtitle("negative hazard ratio, turning positive") saving(p1, replace)


*postive, getting negative

use sim, clear
count
local N=r(N)
drop in 1/`N'
local g=1

save sim, replace

forvalues p=0.75(0.25)1.25 {				

forvalues i=1/100 {

local lambda=0.05 		
local b1=0.8			
local b2=-.3				

clear

set obs 500
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

lpoly diff _tscurve, ci noscatter addplot(line p5 p95 median _ts, lp(dash dash shortdash) lcol(gs10 gs10 black)) t2title("p=`p'") title("") ytitle("") legend(off) saving(p2`g',replace) note("")
local g=`g'+1
}

graph combine p21.gph p22.gph p23.gph, col(3) ycommon subtitle("positive hazard ratio, turning negative") saving(p2, replace)



*positive, getting more positive

use sim, clear
count
local N=r(N)
drop in 1/`N'
local g=1

save sim, replace


forvalues p=0.75(0.25)1.25 {				

forvalues i=1/100 {

local lambda=0.05 		
local b1=.8			
local b2=.3				

clear

set obs 500
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

lpoly diff _tscurve, ci noscatter addplot(line p5 p95 median _ts, lp(dash dash shortdash) lcol(gs10 gs10 black)) t2title("p=`p'") title("") ytitle("") legend(off) saving(p3`g',replace) note("")
local g=`g'+1
}

graph combine p31.gph p32.gph p33.gph, col(3) ycommon subtitle("positive hazard ratio, getting more positive") saving(p3, replace)


*negative, getting more negative

use sim, clear
count
local N=r(N)
drop in 1/`N'
local g=1

save sim, replace


forvalues p=0.75(0.25)1.25 {				

forvalues i=1/100 {

local lambda=0.05 		
local b1=-.8			
local b2=-.3				

clear

set obs 500
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

lpoly diff _tscurve, ci noscatter addplot(line p5 p95 median _ts, lp(dash dash shortdash) lcol(gs10 gs10 black)) t2title("p=`p'") title("") ytitle("") legend(off) saving(p4`g',replace)  note("")
local g=`g'+1
}

graph combine p41.gph p42.gph p43.gph, col(3) ycommon subtitle("negative hazard ratio, getting more negative") saving(p4, replace)

graph combine p1.gph p2.gph p3.gph p4.gph, col(1) l2("Prediction error of estimated survival function (S_estimated - S_true)")
graph display, ysize(10)
graph export simulation_scurve_tvc_obs500.pdf, replace


* the corresponding true survivor functions

local lambda=0.05 		
local b1=-.8			
local b2=.3

local p=.75				
twoway function exp(-(exp(ln(`lambda')+`b1')*`p'*x^(`p'+`b2')/(`p'+`b2'))), range(0 300) xtitle("Analysis time") saving(a11, replace) t2title("p=`p'") ytitle("")

local p=1				
twoway function exp(-(exp(ln(`lambda')+`b1')*`p'*x^(`p'+`b2')/(`p'+`b2'))), range(0 300) xtitle("Analysis time") saving(a12, replace) t2title("p=`p'") ytitle("")

local p=1.25				
twoway function exp(-(exp(ln(`lambda')+`b1')*`p'*x^(`p'+`b2')/(`p'+`b2'))), range(0 300) xtitle("Analysis time") saving(a13, replace) t2title("p=`p'") ytitle("")

local lambda=0.05 		
local b1=.8			
local b2=-.3

local p=.75				
twoway function exp(-(exp(ln(`lambda')+`b1')*`p'*x^(`p'+`b2')/(`p'+`b2'))), range(0 300) xtitle("Analysis time") saving(a21, replace) t2title("p=`p'") ytitle("")

local p=1				
twoway function exp(-(exp(ln(`lambda')+`b1')*`p'*x^(`p'+`b2')/(`p'+`b2'))), range(0 300) xtitle("Analysis time") saving(a22, replace) t2title("p=`p'") ytitle("")

local p=1.25				
twoway function exp(-(exp(ln(`lambda')+`b1')*`p'*x^(`p'+`b2')/(`p'+`b2'))), range(0 300) xtitle("Analysis time") saving(a23, replace) t2title("p=`p'") ytitle("")

local lambda=0.05 		
local b1=.8			
local b2=.3

local p=.75				
twoway function exp(-(exp(ln(`lambda')+`b1')*`p'*x^(`p'+`b2')/(`p'+`b2'))), range(0 100) xtitle("Analysis time") saving(a31, replace) t2title("p=`p'") ytitle("")

local p=1				
twoway function exp(-(exp(ln(`lambda')+`b1')*`p'*x^(`p'+`b2')/(`p'+`b2'))), range(0 100) xtitle("Analysis time") saving(a32, replace) t2title("p=`p'") ytitle("")

local p=1.25				
twoway function exp(-(exp(ln(`lambda')+`b1')*`p'*x^(`p'+`b2')/(`p'+`b2'))), range(0 100) xtitle("Analysis time") saving(a33, replace) t2title("p=`p'") ytitle("")

local lambda=0.05 		
local b1=-.8			
local b2=-.3

local p=.75				
twoway function exp(-(exp(ln(`lambda')+`b1')*`p'*x^(`p'+`b2')/(`p'+`b2'))), range(0 500) xtitle("Analysis time") saving(a41, replace) t2title("p=`p'") ytitle("")

local p=1				
twoway function exp(-(exp(ln(`lambda')+`b1')*`p'*x^(`p'+`b2')/(`p'+`b2'))), range(0 500) xtitle("Analysis time") saving(a42, replace) t2title("p=`p'") ytitle("")

local p=1.25				
twoway function exp(-(exp(ln(`lambda')+`b1')*`p'*x^(`p'+`b2')/(`p'+`b2'))), range(0 500) xtitle("Analysis time") saving(a43, replace) t2title("p=`p'") ytitle("")


graph combine a11.gph a12.gph a13.gph, col(3) ycommon subtitle("negative hazard ratio, turning positive") saving(a1, replace)

graph combine a21.gph a22.gph a23.gph, col(3) ycommon subtitle("positive hazard ratio, turning negative") saving(a2, replace)

graph combine a31.gph a32.gph a33.gph, col(3) ycommon subtitle("positive hazard ratio, getting more positive") saving(a3, replace)

graph combine a41.gph a42.gph a43.gph, col(3) ycommon subtitle("negative hazard ratio, getting more negative") saving(a4, replace)

graph combine a1.gph a2.gph a3.gph a4.gph, col(1) l2("P(Survival)")
graph display, ysize(10)
graph export simulation_scurve_analytical.pdf, replace

