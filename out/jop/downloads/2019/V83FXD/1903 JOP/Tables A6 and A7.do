* Date: February 8, 2019
* Description: Analyze candidate support for police study

clear


import excel "...\1903 JOP\police1.xlsx", sheet("Sheet1") firstrow


* Treatments

drop if treat_endorse==.

gen lawendorse = 0
replace lawendorse = 1 if treat_endorse==2


* Interactions

gen saccounty = 0
replace saccounty = 1 if county=="sacramento"
replace saccounty = . if county==""

gen sac_lawendorse = saccounty * lawendorse


gen black = 0
replace black = 1 if race==2
replace black = . if race==.

gen black_lawendorse = black * lawendorse


* Support local POA sheriff candidates

set more off

log using "...\1903 JOP\law_sheriff.log", replace

set seed X695988c5d980ea95a05262517f7cc4c2000445c8

ologit law_sheriff lawendorse ///
     saccounty sac_lawendorse ///
	 black black_lawendorse

estsimp ologit law_sheriff lawendorse ///
     saccounty sac_lawendorse ///
	 black black_lawendorse


* Control group, non-Sac

setx median
setx lawendorse 0
simqi, prval(3) genpr(control_pr) listx

simqi, fd(prval(3) genpr(lawendorse_fd)) changex(lawendorse 0 1)


* Endorsement Treatment group, non-Sac

setx lawendorse 1
simqi, prval(3) genpr(lawendorse_pr) listx


* Difference in baseline probabilities

tabstat control_pr, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat lawendorse_pr, s(mean sd min p5 p10 p50 p90 p95 max)

gen dif_con_law_pr = lawendorse_pr - control_pr

tabstat dif_con_law_pr, s(mean sd min p5 p10 p50 p90 p95 max)


* Control group, Sac

setx median
setx saccounty 1
setx lawendorse 0
simqi, prval(3) genpr(sac_control_pr) listx

simqi, fd(prval(3) genpr(sac_lawendorse_fd)) changex(lawendorse 0 1 sac_lawendorse 0 1)


* Endorsement Treatment group, Sac

setx lawendorse 1
setx sac_lawendorse 1
simqi, prval(3) genpr(sac_lawendorse_pr) listx


* Difference in baseline probabilities

tabstat sac_control_pr, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat sac_lawendorse_pr, s(mean sd min p5 p10 p50 p90 p95 max)

gen dif_sac_con_law_pr = sac_lawendorse_pr - sac_control_pr

tabstat dif_sac_con_law_pr, s(mean sd min p5 p10 p50 p90 p95 max)


* Control group, Black

setx median
setx black 1
setx lawendorse 0
simqi, prval(3) genpr(black_control_pr) listx

simqi, fd(prval(3) genpr(black_lawendorse_fd)) changex(lawendorse 0 1 black_lawendorse 0 1)


* Endorsement Treatment group, Sac

setx lawendorse 1
setx black_lawendorse 1
simqi, prval(3) genpr(black_lawendorse_pr) listx


* Difference in baseline probabilities

tabstat black_control_pr, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat black_lawendorse_pr, s(mean sd min p5 p10 p50 p90 p95 max)

gen dif_black_con_law_pr = black_lawendorse_pr - black_control_pr

tabstat dif_black_con_law_pr, s(mean sd min p5 p10 p50 p90 p95 max)


* Calculate difference in first differences

tabstat lawendorse_fd, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat sac_lawendorse_fd, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat black_lawendorse_fd, s(mean sd min p5 p10 p50 p90 p95 max)

gen dif_sac_non_law_fd = sac_lawendorse_fd - lawendorse_fd
gen dif_black_non_law_fd = black_lawendorse_fd - lawendorse_fd
gen dif_black_sac_law_fd = black_lawendorse_fd - sac_lawendorse_fd

tabstat dif_sac_non_law_fd, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat dif_black_non_law_fd, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat dif_black_sac_law_fd, s(mean sd min p5 p10 p50 p90 p95 max)


drop b1-b7
drop control_pr-dif_black_sac_law_fd

log close


* Support local POA DA candidates

set more off

log using "...\1903 JOP\law_da.log", replace

set seed Xf247741de86536d3b7894a790591f96500044064

ologit law_da lawendorse ///
     saccounty sac_lawendorse ///
	 black black_lawendorse

estsimp ologit law_da lawendorse ///
     saccounty sac_lawendorse ///
	 black black_lawendorse


* Control group, non-Sac

setx median
setx lawendorse 0
simqi, prval(3) genpr(control_pr) listx

simqi, fd(prval(3) genpr(lawendorse_fd)) changex(lawendorse 0 1)


* Endorsement Treatment group, non-Sac

setx lawendorse 1
simqi, prval(3) genpr(lawendorse_pr) listx


* Difference in baseline probabilities

tabstat control_pr, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat lawendorse_pr, s(mean sd min p5 p10 p50 p90 p95 max)

gen dif_con_law_pr = lawendorse_pr - control_pr

tabstat dif_con_law_pr, s(mean sd min p5 p10 p50 p90 p95 max)


* Control group, Sac

setx median
setx saccounty 1
setx lawendorse 0
simqi, prval(3) genpr(sac_control_pr) listx

simqi, fd(prval(3) genpr(sac_lawendorse_fd)) changex(lawendorse 0 1 sac_lawendorse 0 1)


* Endorsement Treatment group, Sac

setx lawendorse 1
setx sac_lawendorse 1
simqi, prval(3) genpr(sac_lawendorse_pr) listx


* Difference in baseline probabilities

tabstat sac_control_pr, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat sac_lawendorse_pr, s(mean sd min p5 p10 p50 p90 p95 max)

gen dif_sac_con_law_pr = sac_lawendorse_pr - sac_control_pr

tabstat dif_sac_con_law_pr, s(mean sd min p5 p10 p50 p90 p95 max)


* Control group, Black

setx median
setx black 1
setx lawendorse 0
simqi, prval(3) genpr(black_control_pr) listx

simqi, fd(prval(3) genpr(black_lawendorse_fd)) changex(lawendorse 0 1 black_lawendorse 0 1)


* Endorsement Treatment group, Sac

setx lawendorse 1
setx black_lawendorse 1
simqi, prval(3) genpr(black_lawendorse_pr) listx


* Difference in baseline probabilities

tabstat black_control_pr, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat black_lawendorse_pr, s(mean sd min p5 p10 p50 p90 p95 max)

gen dif_black_con_law_pr = black_lawendorse_pr - black_control_pr

tabstat dif_black_con_law_pr, s(mean sd min p5 p10 p50 p90 p95 max)


* Calculate difference in first differences

tabstat lawendorse_fd, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat sac_lawendorse_fd, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat black_lawendorse_fd, s(mean sd min p5 p10 p50 p90 p95 max)

gen dif_sac_non_law_fd = sac_lawendorse_fd - lawendorse_fd
gen dif_black_non_law_fd = black_lawendorse_fd - lawendorse_fd
gen dif_black_sac_law_fd = black_lawendorse_fd - sac_lawendorse_fd

tabstat dif_sac_non_law_fd, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat dif_black_non_law_fd, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat dif_black_sac_law_fd, s(mean sd min p5 p10 p50 p90 p95 max)


drop b1-b7
drop control_pr-dif_black_sac_law_fd

log close

* End
