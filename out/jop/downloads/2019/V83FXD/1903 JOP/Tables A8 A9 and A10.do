* Date: February 8, 2019
* Description: Analyze candidate support for police study

clear


import excel "...\1903 JOP\police1.xlsx", sheet("Sheet1") firstrow


* Treatments

drop if treat_endorse==.

gen lawendorse = 0
replace lawendorse = 1 if treat_endorse==2


* Trust

gen trust_poa = 0
replace trust_poa = 1 if (law_agree>=3 & law_agree<=4) & (law_knows>=3 & law_knows<=4)
replace trust_poa = . if law_agree==. | law_knows==.


* Interactions

gen trust_poa_lawendorse = trust_poa * lawendorse


gen saccounty = 0
replace saccounty = 1 if county=="sacramento"
replace saccounty = . if county==""

gen sac_lawendorse = saccounty * lawendorse

gen sac_trust_poa = saccounty * trust_poa
gen sac_trust_poa_lawendorse = saccounty * trust_poa_lawendorse


gen black = 0
replace black = 1 if race==2
replace black = . if race==.

gen black_lawendorse = black * lawendorse

gen black_trust_poa = black * trust_poa
gen black_trust_poa_lawendorse = black * trust_poa_lawendorse


* Support local POA sheriff candidates

set more off

log using "...\1903 JOP\law_sheriff_trust.log", replace

set seed X538fcd95664037d368b6aaaa80b16c380004352d

ologit law_sheriff trust_poa ///
     lawendorse trust_poa_lawendorse ///
	 saccounty sac_trust_poa ///
	 sac_lawendorse sac_trust_poa_lawendorse ///
	 black black_trust_poa ///
	 black_lawendorse black_trust_poa_lawendorse

estsimp ologit law_sheriff trust_poa ///
     lawendorse trust_poa_lawendorse ///
	 saccounty sac_trust_poa ///
	 sac_lawendorse sac_trust_poa_lawendorse ///
	 black black_trust_poa ///
	 black_lawendorse black_trust_poa_lawendorse


* Control group, non-Sac

setx median
setx lawendorse 0
setx trust_poa 0
simqi, prval(3) genpr(control_pr) listx

simqi, fd(prval(3) genpr(trust_poa_fd)) changex(trust_poa 0 1)

simqi, fd(prval(3) genpr(lawendorse_fd)) changex(lawendorse 0 1)


setx trust_poa 1
simqi, prval(3) genpr(trust_poa_pr) listx

simqi, fd(prval(3) genpr(trust_poa_lawendorse_fd)) changex(lawendorse 0 1 trust_poa_lawendorse 0 1)


* Endorsement Treatment group, non-Sac

setx median
setx lawendorse 1
setx trust_poa 0
simqi, prval(3) genpr(lawendorse_pr) listx


setx trust_poa 1
setx trust_poa_lawendorse 1
simqi, prval(3) genpr(trust_poa_lawendorse_pr) listx


* Difference in baseline probabilities

tabstat control_pr, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat lawendorse_pr, s(mean sd min p5 p10 p50 p90 p95 max)

gen dif_con_law_pr = lawendorse_pr - control_pr

tabstat dif_con_law_pr, s(mean sd min p5 p10 p50 p90 p95 max)


tabstat trust_poa_pr, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat trust_poa_lawendorse_pr, s(mean sd min p5 p10 p50 p90 p95 max)

gen dif_trust_poa_con_law_pr = trust_poa_lawendorse_pr - trust_poa_pr

tabstat dif_trust_poa_con_law_pr, s(mean sd min p5 p10 p50 p90 p95 max)


* Control group, Sac

setx median
setx lawendorse 0
setx trust_poa 0
setx saccounty 1
simqi, prval(3) genpr(sac_control_pr) listx

simqi, fd(prval(3) genpr(sac_trust_poa_fd)) changex(trust_poa 0 1 sac_trust_poa 0 1)

simqi, fd(prval(3) genpr(sac_lawendorse_fd)) changex(lawendorse 0 1 sac_lawendorse 0 1)


setx trust_poa 1
setx sac_trust_poa 1
simqi, prval(3) genpr(sac_trust_poa_pr) listx

simqi, fd(prval(3) genpr(sac_trust_poa_lawendorse_fd)) changex(lawendorse 0 1 trust_poa_lawendorse 0 1 sac_lawendorse 0 1 sac_trust_poa_lawendorse 0 1)


* Endorsement Treatment group, Sac

setx median
setx lawendorse 1
setx trust_poa 0
setx saccounty 1
setx sac_lawendorse 1
simqi, prval(3) genpr(sac_lawendorse_pr) listx


setx trust_poa 1
setx sac_trust_poa 1
setx trust_poa_lawendorse 1
setx sac_trust_poa_lawendorse 1
simqi, prval(3) genpr(sac_trust_poa_lawendorse_pr) listx


* Difference in baseline probabilities

tabstat sac_control_pr, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat sac_lawendorse_pr, s(mean sd min p5 p10 p50 p90 p95 max)

gen dif_sac_con_law_pr = sac_lawendorse_pr - sac_control_pr

tabstat dif_sac_con_law_pr, s(mean sd min p5 p10 p50 p90 p95 max)


tabstat sac_trust_poa_pr, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat sac_trust_poa_lawendorse_pr, s(mean sd min p5 p10 p50 p90 p95 max)

gen dif_sac_trust_poa_con_law_pr = sac_trust_poa_lawendorse_pr - sac_trust_poa_pr

tabstat dif_sac_trust_poa_con_law_pr, s(mean sd min p5 p10 p50 p90 p95 max)


* Control group, black

setx median
setx lawendorse 0
setx trust_poa 0
setx black 1
simqi, prval(3) genpr(black_control_pr) listx

simqi, fd(prval(3) genpr(black_trust_poa_fd)) changex(trust_poa 0 1 black_trust_poa 0 1)

simqi, fd(prval(3) genpr(black_lawendorse_fd)) changex(lawendorse 0 1 black_lawendorse 0 1)


setx trust_poa 1
setx black_trust_poa 1
simqi, prval(3) genpr(black_trust_poa_pr) listx

simqi, fd(prval(3) genpr(black_trust_poa_lawendorse_fd)) changex(lawendorse 0 1 trust_poa_lawendorse 0 1 black_lawendorse 0 1 black_trust_poa_lawendorse 0 1)


* Endorsement Treatment group, black

setx median
setx lawendorse 1
setx trust_poa 0
setx black 1
setx black_lawendorse 1
simqi, prval(3) genpr(black_lawendorse_pr) listx


setx trust_poa 1
setx black_trust_poa 1
setx trust_poa_lawendorse 1
setx black_trust_poa_lawendorse 1
simqi, prval(3) genpr(black_trust_poa_lawendorse_pr) listx


* Difference in baseline probabilities

tabstat black_control_pr, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat black_lawendorse_pr, s(mean sd min p5 p10 p50 p90 p95 max)

gen dif_black_con_law_pr = black_lawendorse_pr - black_control_pr

tabstat dif_black_con_law_pr, s(mean sd min p5 p10 p50 p90 p95 max)


tabstat black_trust_poa_pr, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat black_trust_poa_lawendorse_pr, s(mean sd min p5 p10 p50 p90 p95 max)

gen dif_black_trust_poa_con_law_pr = black_trust_poa_lawendorse_pr - black_trust_poa_pr

tabstat dif_black_trust_poa_con_law_pr, s(mean sd min p5 p10 p50 p90 p95 max)


* Calculate difference in first differences

tabstat lawendorse_fd, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat trust_poa_lawendorse_fd, s(mean sd min p5 p10 p50 p90 p95 max)

gen dif_trust_poa_con_law_fd = trust_poa_lawendorse_fd - lawendorse_fd

tabstat dif_trust_poa_con_law_fd, s(mean sd min p5 p10 p50 p90 p95 max)


tabstat sac_lawendorse_fd, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat sac_trust_poa_lawendorse_fd, s(mean sd min p5 p10 p50 p90 p95 max)

gen dif_sac_trust_poa_con_law_fd = sac_trust_poa_lawendorse_fd - sac_lawendorse_fd

tabstat dif_sac_trust_poa_con_law_fd, s(mean sd min p5 p10 p50 p90 p95 max)


tabstat black_lawendorse_fd, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat black_trust_poa_lawendorse_fd, s(mean sd min p5 p10 p50 p90 p95 max)

gen dif_black_trust_poa_con_law_fd = black_trust_poa_lawendorse_fd - black_lawendorse_fd

tabstat dif_black_trust_poa_con_law_fd, s(mean sd min p5 p10 p50 p90 p95 max)


drop b1-b13
drop control_pr-dif_black_trust_poa_con_law_fd

log close


* Support local POA DA candidates

set more off

log using "...\1903 JOP\law_da_trust.log", replace

set seed Xee41495d96a55e2ee295c4e81df0ae1c00043bb4

ologit law_da trust_poa ///
     lawendorse trust_poa_lawendorse ///
	 saccounty sac_trust_poa ///
	 sac_lawendorse sac_trust_poa_lawendorse ///
	 black black_trust_poa ///
	 black_lawendorse black_trust_poa_lawendorse

estsimp ologit law_da trust_poa ///
     lawendorse trust_poa_lawendorse ///
	 saccounty sac_trust_poa ///
	 sac_lawendorse sac_trust_poa_lawendorse ///
	 black black_trust_poa ///
	 black_lawendorse black_trust_poa_lawendorse


* Control group, non-Sac

setx median
setx lawendorse 0
setx trust_poa 0
simqi, prval(3) genpr(control_pr) listx

simqi, fd(prval(3) genpr(trust_poa_fd)) changex(trust_poa 0 1)

simqi, fd(prval(3) genpr(lawendorse_fd)) changex(lawendorse 0 1)


setx trust_poa 1
simqi, prval(3) genpr(trust_poa_pr) listx

simqi, fd(prval(3) genpr(trust_poa_lawendorse_fd)) changex(lawendorse 0 1 trust_poa_lawendorse 0 1)


* Endorsement Treatment group, non-Sac

setx median
setx lawendorse 1
setx trust_poa 0
simqi, prval(3) genpr(lawendorse_pr) listx


setx trust_poa 1
setx trust_poa_lawendorse 1
simqi, prval(3) genpr(trust_poa_lawendorse_pr) listx


* Difference in baseline probabilities

tabstat control_pr, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat lawendorse_pr, s(mean sd min p5 p10 p50 p90 p95 max)

gen dif_con_law_pr = lawendorse_pr - control_pr

tabstat dif_con_law_pr, s(mean sd min p5 p10 p50 p90 p95 max)


tabstat trust_poa_pr, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat trust_poa_lawendorse_pr, s(mean sd min p5 p10 p50 p90 p95 max)

gen dif_trust_poa_con_law_pr = trust_poa_lawendorse_pr - trust_poa_pr

tabstat dif_trust_poa_con_law_pr, s(mean sd min p5 p10 p50 p90 p95 max)


* Control group, Sac

setx median
setx lawendorse 0
setx trust_poa 0
setx saccounty 1
simqi, prval(3) genpr(sac_control_pr) listx

simqi, fd(prval(3) genpr(sac_trust_poa_fd)) changex(trust_poa 0 1 sac_trust_poa 0 1)

simqi, fd(prval(3) genpr(sac_lawendorse_fd)) changex(lawendorse 0 1 sac_lawendorse 0 1)


setx trust_poa 1
setx sac_trust_poa 1
simqi, prval(3) genpr(sac_trust_poa_pr) listx

simqi, fd(prval(3) genpr(sac_trust_poa_lawendorse_fd)) changex(lawendorse 0 1 trust_poa_lawendorse 0 1 sac_lawendorse 0 1 sac_trust_poa_lawendorse 0 1)


* Endorsement Treatment group, Sac

setx median
setx lawendorse 1
setx trust_poa 0
setx saccounty 1
setx sac_lawendorse 1
simqi, prval(3) genpr(sac_lawendorse_pr) listx


setx trust_poa 1
setx sac_trust_poa 1
setx trust_poa_lawendorse 1
setx sac_trust_poa_lawendorse 1
simqi, prval(3) genpr(sac_trust_poa_lawendorse_pr) listx


* Difference in baseline probabilities

tabstat sac_control_pr, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat sac_lawendorse_pr, s(mean sd min p5 p10 p50 p90 p95 max)

gen dif_sac_con_law_pr = sac_lawendorse_pr - sac_control_pr

tabstat dif_sac_con_law_pr, s(mean sd min p5 p10 p50 p90 p95 max)


tabstat sac_trust_poa_pr, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat sac_trust_poa_lawendorse_pr, s(mean sd min p5 p10 p50 p90 p95 max)

gen dif_sac_trust_poa_con_law_pr = sac_trust_poa_lawendorse_pr - sac_trust_poa_pr

tabstat dif_sac_trust_poa_con_law_pr, s(mean sd min p5 p10 p50 p90 p95 max)


* Control group, black

setx median
setx lawendorse 0
setx trust_poa 0
setx black 1
simqi, prval(3) genpr(black_control_pr) listx

simqi, fd(prval(3) genpr(black_trust_poa_fd)) changex(trust_poa 0 1 black_trust_poa 0 1)

simqi, fd(prval(3) genpr(black_lawendorse_fd)) changex(lawendorse 0 1 black_lawendorse 0 1)


setx trust_poa 1
setx black_trust_poa 1
simqi, prval(3) genpr(black_trust_poa_pr) listx

simqi, fd(prval(3) genpr(black_trust_poa_lawendorse_fd)) changex(lawendorse 0 1 trust_poa_lawendorse 0 1 black_lawendorse 0 1 black_trust_poa_lawendorse 0 1)


* Endorsement Treatment group, black

setx median
setx lawendorse 1
setx trust_poa 0
setx black 1
setx black_lawendorse 1
simqi, prval(3) genpr(black_lawendorse_pr) listx


setx trust_poa 1
setx black_trust_poa 1
setx trust_poa_lawendorse 1
setx black_trust_poa_lawendorse 1
simqi, prval(3) genpr(black_trust_poa_lawendorse_pr) listx


* Difference in baseline probabilities

tabstat black_control_pr, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat black_lawendorse_pr, s(mean sd min p5 p10 p50 p90 p95 max)

gen dif_black_con_law_pr = black_lawendorse_pr - black_control_pr

tabstat dif_black_con_law_pr, s(mean sd min p5 p10 p50 p90 p95 max)


tabstat black_trust_poa_pr, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat black_trust_poa_lawendorse_pr, s(mean sd min p5 p10 p50 p90 p95 max)

gen dif_black_trust_poa_con_law_pr = black_trust_poa_lawendorse_pr - black_trust_poa_pr

tabstat dif_black_trust_poa_con_law_pr, s(mean sd min p5 p10 p50 p90 p95 max)


* Calculate difference in first differences

tabstat lawendorse_fd, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat trust_poa_lawendorse_fd, s(mean sd min p5 p10 p50 p90 p95 max)

gen dif_trust_poa_con_law_fd = trust_poa_lawendorse_fd - lawendorse_fd

tabstat dif_trust_poa_con_law_fd, s(mean sd min p5 p10 p50 p90 p95 max)


tabstat sac_lawendorse_fd, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat sac_trust_poa_lawendorse_fd, s(mean sd min p5 p10 p50 p90 p95 max)

gen dif_sac_trust_poa_con_law_fd = sac_trust_poa_lawendorse_fd - sac_lawendorse_fd

tabstat dif_sac_trust_poa_con_law_fd, s(mean sd min p5 p10 p50 p90 p95 max)


tabstat black_lawendorse_fd, s(mean sd min p5 p10 p50 p90 p95 max)
tabstat black_trust_poa_lawendorse_fd, s(mean sd min p5 p10 p50 p90 p95 max)

gen dif_black_trust_poa_con_law_fd = black_trust_poa_lawendorse_fd - black_lawendorse_fd

tabstat dif_black_trust_poa_con_law_fd, s(mean sd min p5 p10 p50 p90 p95 max)


drop b1-b13
drop control_pr-dif_black_trust_poa_con_law_fd

log close

* End
