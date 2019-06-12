* Date: February 8, 2019
* Description: Analyze trust ratings for police study

clear


import excel "...\1903 JOP\police1.xlsx", sheet("Sheet1") firstrow


* Treatments

drop if treat_info==.

gen pattern = 0
replace pattern = 1 if treat_info==2

gen reform = 0
replace reform = 1 if treat_info==3


* Trust

gen trust_spd = 0
replace trust_spd = 1 if trust_spdleaders>=4 & trust_spdleaders<=5
replace trust_spd = . if trust_spdleaders==.

gen trust_poa = 0
replace trust_poa = 1 if (law_agree>=3 & law_agree<=4) & (law_knows>=3 & law_knows<=4)
replace trust_poa = . if law_agree==. | law_knows==.


* Interactions

gen saccounty = 0
replace saccounty = 1 if county=="sacramento"
replace saccounty = . if county==""

gen sac_pattern = saccounty * pattern
gen sac_reform = saccounty * reform


gen black = 0
replace black = 1 if race==2
replace black = . if race==.

gen black_pattern = black * pattern
gen black_reform = black * reform


* Trust SPD leaders

set more off

log using "...\1903 JOP\trust_spd.log", replace

set seed X52dd25dd95a5bf6d0bef632d25b0dd210004410b

logit trust_spd pattern reform ///
     saccounty sac_pattern sac_reform ///
	 black black_pattern black_reform

estsimp logit trust_spd pattern reform ///
     saccounty sac_pattern sac_reform ///
	 black black_pattern black_reform


* Control group, non-Sac

setx median
simqi, prval(1) genpr(control_pr) listx

simqi, fd(prval(1) genpr(pattern_fd)) changex(pattern 0 1)
simqi, fd(prval(1) genpr(reform_fd)) changex(reform 0 1)


simqi, fd(prval(1) genpr(sac_fd)) changex(saccounty 0 1)
simqi, fd(prval(1) genpr(black_fd)) changex(black 0 1)


* Pattern group, non-Sac

setx pattern 1
simqi, prval(1) genpr(pattern_pr) listx


* Reform group, non-Sac

setx pattern 0
setx reform 1
simqi, prval(1) genpr(reform_pr) listx


* Difference in baseline probabilities

tabstat control_pr, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat pattern_pr, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat reform_pr, s(mean sd min p5 p10 p50 p90 p95 max)

gen dif_con_pat_pr = pattern_pr - control_pr
gen dif_con_ref_pr = reform_pr - control_pr
gen dif_pat_ref_pr = reform_pr - pattern_pr

tabstat dif_con_pat_pr, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat dif_con_ref_pr, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat dif_pat_ref_pr, s(mean sd min p5 p10 p50 p90 p95 max)


* Control group, Sac

setx median
setx saccounty 1
simqi, prval(1) genpr(sac_control_pr) listx

simqi, fd(prval(1) genpr(sac_pattern_fd)) changex(pattern 0 1 sac_pattern 0 1)
simqi, fd(prval(1) genpr(sac_reform_fd)) changex(reform 0 1 sac_reform 0 1)


* Pattern group, Sac

setx pattern 1
setx sac_pattern 1
simqi, prval(1) genpr(sac_pattern_pr) listx


* Reform group, Sac

setx pattern 0
setx sac_pattern 0
setx reform 1
setx sac_reform 1
simqi, prval(1) genpr(sac_reform_pr) listx


* Difference in baseline probabilities

tabstat sac_control_pr, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat sac_pattern_pr, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat sac_reform_pr, s(mean sd min p5 p10 p50 p90 p95 max)

gen dif_sac_con_pat_pr = sac_pattern_pr - sac_control_pr
gen dif_sac_con_ref_pr = sac_reform_pr - sac_control_pr
gen dif_sac_pat_ref_pr = sac_reform_pr - sac_pattern_pr

tabstat dif_sac_con_pat_pr, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat dif_sac_con_ref_pr, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat dif_sac_pat_ref_pr, s(mean sd min p5 p10 p50 p90 p95 max)


* Control group, Black

setx median
setx black 1
simqi, prval(1) genpr(black_control_pr) listx

simqi, fd(prval(1) genpr(black_pattern_fd)) changex(pattern 0 1 black_pattern 0 1)
simqi, fd(prval(1) genpr(black_reform_fd)) changex(reform 0 1 black_reform 0 1)


* Pattern group, Black

setx pattern 1
setx black_pattern 1
simqi, prval(1) genpr(black_pattern_pr) listx


* Reform group, Black

setx pattern 0
setx black_pattern 0
setx reform 1
setx black_reform 1
simqi, prval(1) genpr(black_reform_pr) listx


* Difference in baseline probabilities

tabstat black_control_pr, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat black_pattern_pr, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat black_reform_pr, s(mean sd min p5 p10 p50 p90 p95 max)

gen dif_black_con_pat_pr = black_pattern_pr - black_control_pr
gen dif_black_con_ref_pr = black_reform_pr - black_control_pr
gen dif_black_pat_ref_pr = black_reform_pr - black_pattern_pr

tabstat dif_black_con_pat_pr, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat dif_black_con_ref_pr, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat dif_black_pat_ref_pr, s(mean sd min p5 p10 p50 p90 p95 max)


drop b1-b9
drop control_pr-dif_black_pat_ref_pr

log close


* Trust local POA

set more off

log using "...\1903 JOP\trust_poa.log", replace

set seed X6ebfb33df1c34e2040655e83559d6291000412ea

logit trust_poa pattern reform ///
     saccounty sac_pattern sac_reform ///
	 black black_pattern black_reform

estsimp logit trust_poa pattern reform ///
     saccounty sac_pattern sac_reform ///
	 black black_pattern black_reform


* Control group, non-Sac

setx median
simqi, prval(1) genpr(control_pr) listx

simqi, fd(prval(1) genpr(pattern_fd)) changex(pattern 0 1)
simqi, fd(prval(1) genpr(reform_fd)) changex(reform 0 1)


simqi, fd(prval(1) genpr(sac_fd)) changex(saccounty 0 1)
simqi, fd(prval(1) genpr(black_fd)) changex(black 0 1)


* Pattern group, non-Sac

setx pattern 1
simqi, prval(1) genpr(pattern_pr) listx


* Reform group, non-Sac

setx pattern 0
setx reform 1
simqi, prval(1) genpr(reform_pr) listx


* Difference in baseline probabilities

tabstat control_pr, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat pattern_pr, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat reform_pr, s(mean sd min p5 p10 p50 p90 p95 max)

gen dif_con_pat_pr = pattern_pr - control_pr
gen dif_con_ref_pr = reform_pr - control_pr
gen dif_pat_ref_pr = reform_pr - pattern_pr

tabstat dif_con_pat_pr, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat dif_con_ref_pr, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat dif_pat_ref_pr, s(mean sd min p5 p10 p50 p90 p95 max)


* Control group, Sac

setx median
setx saccounty 1
simqi, prval(1) genpr(sac_control_pr) listx

simqi, fd(prval(1) genpr(sac_pattern_fd)) changex(pattern 0 1 sac_pattern 0 1)
simqi, fd(prval(1) genpr(sac_reform_fd)) changex(reform 0 1 sac_reform 0 1)


* Pattern group, Sac

setx pattern 1
setx sac_pattern 1
simqi, prval(1) genpr(sac_pattern_pr) listx


* Reform group, Sac

setx pattern 0
setx sac_pattern 0
setx reform 1
setx sac_reform 1
simqi, prval(1) genpr(sac_reform_pr) listx


* Difference in baseline probabilities

tabstat sac_control_pr, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat sac_pattern_pr, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat sac_reform_pr, s(mean sd min p5 p10 p50 p90 p95 max)

gen dif_sac_con_pat_pr = sac_pattern_pr - sac_control_pr
gen dif_sac_con_ref_pr = sac_reform_pr - sac_control_pr
gen dif_sac_pat_ref_pr = sac_reform_pr - sac_pattern_pr

tabstat dif_sac_con_pat_pr, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat dif_sac_con_ref_pr, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat dif_sac_pat_ref_pr, s(mean sd min p5 p10 p50 p90 p95 max)


* Control group, Black

setx median
setx black 1
simqi, prval(1) genpr(black_control_pr) listx

simqi, fd(prval(1) genpr(black_pattern_fd)) changex(pattern 0 1 black_pattern 0 1)
simqi, fd(prval(1) genpr(black_reform_fd)) changex(reform 0 1 black_reform 0 1)


* Pattern group, Black

setx pattern 1
setx black_pattern 1
simqi, prval(1) genpr(black_pattern_pr) listx


* Reform group, Black

setx pattern 0
setx black_pattern 0
setx reform 1
setx black_reform 1
simqi, prval(1) genpr(black_reform_pr) listx


* Difference in baseline probabilities

tabstat black_control_pr, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat black_pattern_pr, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat black_reform_pr, s(mean sd min p5 p10 p50 p90 p95 max)

gen dif_black_con_pat_pr = black_pattern_pr - black_control_pr
gen dif_black_con_ref_pr = black_reform_pr - black_control_pr
gen dif_black_pat_ref_pr = black_reform_pr - black_pattern_pr

tabstat dif_black_con_pat_pr, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat dif_black_con_ref_pr, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat dif_black_pat_ref_pr, s(mean sd min p5 p10 p50 p90 p95 max)


drop b1-b9
drop control_pr-dif_black_pat_ref_pr

log close

* End
