*********************************
*Replication of tables and figures in: 
*How governments shape the risk of civil violence: India’s federal reorganization, 1950–56
*By Bethany Lacina
*American Journal of Political Science
*********************************
*This replication file uses the following STATA packages: CLARIFY and 
*Uncomment the lines below to install these packages (computer must be online)
*net cd http://gking.harvard.edu/clarify/
*net install clarify.pkg
*net cd http://www.stata-journal.com/software/sj4-3/
*net install gr0002_3.pkg

set more off

*****Load data and set global macros******

use "LacinaAJPSreplication.dta", clear

notes

global controls polsim lnelgmps lnelpop eagpc elndlss ehindupc lcapdist 

global controls2 polcdist05 lnelgmps lnelpop eagpc elndlss ehindupc lcapdist 

global controls3 lnelgmps lnelpop eagpc elndlss ehindupc lcapdist

global controls4 lnelgmps lnelpop ehindupc lcapdist

******Main text*******

*Model 1

mlogit outcome_t lnrelgrepnm lnrelgrepnm2 $controls, cluster(snum)

qui: mlogit outcome_t lnrelgrepnm lnrelgrepnm2 $controls

mlogtest, suest

*Model 2

mlogit outcome_t lnrelgrepnm lnrelgrepnm2 $controls2, cluster(snum)

qui: mlogit outcome_t lnrelgrepnm lnrelgrepnm2 $controls2

mlogtest, suest

*Model 3

logit sra srv srvlnrelgrepnm lnrelgrepnm polsim $controls4, cluster(snum)

*Model 4

logit sra srv srvlnrelgrepnm lnrelgrepnm polcdist05 $controls4, cluster(snum)

*Figure 2
mlogit outcome_tri lnrelgrepnm lnrelgrepnm2 $controls, cluster(snum)

foreach var in $controls polsim_dir polcdist05_dir {

qui summ `var', detail
local `var'a=r(p50)

}

qui summ relgrepnm, detail

local min=r(p5)

local max=r(p95)

clear

range x `min' `max' 1000

gen relgrepnm=x

gen lnrelgrepnm=log(x)

gen lnrelgrepnm2=log(x)^2

drop x

foreach var in  $controls polsim_dir polcdist05_dir {

gen `var' = ``var'a'

}

save "simul.dta", replace

predict pr1c pr2c pr3c

twoway ///
line pr2c relgrepnm, sort xscale(log) xlabel(0.125 ".125" 0.25 ".25" 0.5 ".5" 1 "1" 2 "2" 4 "4" 8 "8" 16 "16") ///
|| ///
line pr3c relgrepnm, sort xscale(log) ///|| ///spike obs relgrepnm, sort xscale(log) ///
ytitle("Probability") title("") legend(pos(6) cols(2) lab(1 "Peaceful statehood") lab(2 "Violence")) ///
xtitle("Relative INC representation") scheme(lean2) ylabel(,nogrid) 

*****Figure 3*******

use "LacinaAJPSreplication.dta", clear

set seed 64374689

preserve

keep if srv==1

keep relgrepnm

rename relgrepnm iv

gen obs=-0.45

save "violentobs.dta", replace

restore

postutil clear
set more off
postfile results_clarify iv diff p5 p95 using "temp.dta", replace

estsimp logit sra srv srvlnrelgrepnm lnrelgrepnm polsim $controls4, cluster(snum)

qui: summ relgrepnm, detail

local min=r(p5)

local max=r(p95)

forval x = `min'(0.01)`max' {

setx lnrelgrepnm log(`x') srvlnrelgrepnm 0 srv 0 lnelgmps median lnelpop median ehindupc median lcapdist median 

qui: simqi, prval(1) genpr(a)

setx lnrelgrepnm log(`x') srvlnrelgrepnm log(`x') srv 1 lnelgmps median lnelpop median ehindupc median lcapdist median 

qui: simqi, prval(1) genpr(b)

gen fd=b-a

qui: summ fd	

local m=r(mean)

qui: centile fd, centile(5,95)

local lb=r(c_1) 

local ub=r(c_2)

di `m' `lb' `ub'

capture drop a b fd

post results_clarify (`x') (`m') (`lb') (`ub')

}

postclose results_clarify

use "temp.dta", clear

gen obs=.

append using "violentobs.dta"

twoway ///
line diff iv, sort xscale(log) xlabel(0.125 ".125" 0.25 ".25" 0.5 ".5" 1 "1" 2 "2" 4 "4" 8 "8" 16 "16") || ///
line p5 iv, xscale(log) sort lp(dash) lc(black) || ///
line p95 iv, xscale(log) sort lp(dash) lc(black) || ///
scatter obs iv, xscale(log) msymbol(o) msize(small) ///
ytitle("Pr(State|Violence)-Pr(State|~Violence)") ///
title("") ///
note("Points indicate levels of relative INC representation at which violence observed", pos(6)) ///
xtitle("Relative INC representation") scheme(lean2) ylabel(,nogrid) legend(off)

*****************************
*****************************
*****************************
*****************************
****Supporting materials*****
*****************************
*****************************
*****************************
*****************************

use "LacinaAJPSreplication.dta", clear

****Summary: Main text****

tabstat srv paccom sra lnrelgrepnm lnrelgrepnm2 polsim polcdist05 $controls3 srvlnrelgrepnm , statistics(mean sd min max) columns(statistics)

****The Linguistic Survey of India and the 1951 census compared ***

use "LacinaAJPS_SupportInfo_CensusvLSI.dta", clear

notes

summ lshare census

*Figure 2*

corr lshare census

local pc = (round(r(rho),0.01))

twoway ///
scatter lshare censusshare, sort msymbol(o) jitter(1) || ///
lfit lshare censusshare, lstyle(solid) ///
ytitle("Census estimate") title("") legend(off) ///
xtitle("LSI estimate") scheme(lean2) ylabel(,nogrid) ///
note("Correlation = 0`pc'", size(medium) position(6) linegap(2))

*Table 3, Model 1*

reg census lshare 

****Summary: Appendix (Table 4)*****
use "LacinaAJPSreplication.dta", clear

tabstat polcdist005 polsim_dir polcdist05_dir ///
elpolsimple elpolf elfrac ///
diffmilitary_postmutiny difflanghandbook disadvmilitary_postmutiny disadvlanghandbook ///
stclaims stlpolsim stlpolf stlfrac stagpc stlndlss agratio aghi aglo  ///
e_winshare vsabha_efnoparties vsabha_incseatsh pcc ///
lbendist borderorcoast  ergnlpartysh ehinduntnlstsh  ///
lbomdist odailies engdailies ///
, statistics(mean sd min max) columns(statistics)

****Supplementary Tables and Figures******

*Table 5*

*Model 2
mlogit outcome_t lnrelgrepnm lnrelgrepnm2 $controls3 polcdist005, cluster(snum)

*Model 3
mlogit outcome_t lnrelgrepnm lnrelgrepnm2 $controls3 polsim_dir, cluster(snum)

*Model 4
mlogit outcome_t lnrelgrepnm lnrelgrepnm2 $controls3 polcdist05_dir, cluster(snum)

*Figure 4
qui: mlogit outcome_t lnrelgrepnm lnrelgrepnm2 $controls3 polsim_dir, cluster(snum)
 
use "simul.dta", clear

predict pr1c pr2c pr3c

twoway ///
line pr2c relgrepnm, sort xscale(log) xlabel(0.125 ".125" 0.25 ".25" 0.5 ".5" 1 "1" 2 "2" 4 "4" 8 "8" 16 "16") ///
|| ///
line pr3c relgrepnm, sort xscale(log) ///
ytitle("Probability") title("") legend(pos(6) cols(2) lab(1 "Peaceful statehood") lab(2 "Violence")) ///
xtitle("Relative INC representation") scheme(lean2) ylabel(,nogrid)

*Figure 5
use "LacinaAJPSreplication.dta", clear

qui: mlogit outcome_t lnrelgrepnm lnrelgrepnm2 $controls3 polcdist05_dir, cluster(snum)
 
use "simul.dta", clear

predict pr1c pr2c pr3c

twoway ///
line pr2c relgrepnm, sort xscale(log) xlabel(0.125 ".125" 0.25 ".25" 0.5 ".5" 1 "1" 2 "2" 4 "4" 8 "8" 16 "16") ///
|| ///
line pr3c relgrepnm, sort xscale(log) ///
ytitle("Probability") title("") legend(pos(6) cols(2) lab(1 "Peaceful statehood") lab(2 "Violence")) ///
xtitle("Relative INC representation") scheme(lean2) ylabel(,nogrid)

*Model 5
use "LacinaAJPSreplication.dta", clear
logit sra srv srvlnrelgrepnm lnrelgrepnm $controls4 polcdist005, cluster(snum)

*Model 6
logit sra srv srvlnrelgrepnm lnrelgrepnm $controls4 polsim_dir, cluster(snum)

*Model 7
logit sra srv srvlnrelgrepnm lnrelgrepnm $controls4 polcdist05_dir, cluster(snum)

*Model 8
mlogit outcome_t lnrelgrepnm lnrelgrepnm2 $controls3 elpolsimple, cluster(snum)

*Model 9
mlogit outcome_t lnrelgrepnm lnrelgrepnm2 $controls3 elpolf, cluster(snum)

*Model 10
mlogit outcome_t lnrelgrepnm lnrelgrepnm2 $controls3 elfrac, cluster(snum)

*Model 11
logit sra srv srvlnrelgrepnm lnrelgrepnm $controls4 elpolsimple, cluster(snum)

*Model 12
logit sra srv srvlnrelgrepnm lnrelgrepnm $controls4 elpolf, cluster(snum)

*Model 13
logit sra srv srvlnrelgrepnm lnrelgrepnm $controls4 elfrac, cluster(snum)

*Model 14
mlogit outcome_t lnrelgrepnm lnrelgrepnm2 $controls diffmilitary_post difflanghandbook, cluster(snum)

*Model 15
mlogit outcome_t lnrelgrepnm lnrelgrepnm2 $controls disadvmilitary_post disadvlanghandbook, cluster(snum)

*Model 16
mlogit outcome_t lnrelgrepnm lnrelgrepnm2 $controls3 stclaims stlpolsim stagpc stlndlss, cluster(snum)

*Model 17
mlogit outcome_t lnrelgrepnm lnrelgrepnm2 $controls3 stclaims stlpolf stagpc stlndlss, cluster(snum)

*Model 18
mlogit outcome_t lnrelgrepnm lnrelgrepnm2 $controls3 stclaims stlfrac stagpc stlndlss, cluster(snum)

*Model 19
mlogit outcome_t lnrelgrepnm lnrelgrepnm2 $controls3 agratio stlpolf  stagpc stlndlss, cluster(snum)

*Model 20
mlogit outcome_t lnrelgrepnm lnrelgrepnm2 $controls3 aghi aglo stlpolf  stagpc stlndlss, cluster(snum)

*Model 21
mlogit outcome_t lnrelgrepnm lnrelgrepnm2 $controls vsabha_efnoparties e_winshare, cluster(snum)

*Model 22
mlogit outcome_t lnrelgrepnm lnrelgrepnm2 $controls vsabha_incseatsh pcc , cluster(snum)

*Model 23
mlogit outcome_t lnrelgrepnm lnrelgrepnm2 $controls lbendist borderorcoast ergnlpartysh, cluster(snum)

*Model 24
mlogit outcome_t lnrelgrepnm lnrelgrepnm2 $controls lbendist borderorcoast ehinduntnlstsh, cluster(snum)

*Model 25
logit sra srv srvlnrelgrepnm lnrelgrepnm polsim $controls4 lbendist borderorcoast ergnlpartysh, cluster(snum)

*Model 26
logit sra srv srvlnrelgrepnm lnrelgrepnm polsim $controls4 lbendist borderorcoast ehinduntnlstsh, cluster(snum)

*Model 27
mlogit outcome_t lnrelgrepnm lnrelgrepnm2 $controls lbomdist odailies engdailies, cluster(snum) 

*Model 28
logit sra srv srvlnrelgrepnm lnrelgrepnm polsim $controls4 lbomdist odailies engdailies, cluster(snum)
