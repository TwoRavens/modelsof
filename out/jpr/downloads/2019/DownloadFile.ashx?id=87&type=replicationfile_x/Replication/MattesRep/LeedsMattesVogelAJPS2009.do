*Replication file for Leeds, Mattes, Vogel (2009) AJPS article-- Interests, Institutions, and the Reliability of International Commitments
clear
set mem 256m
set matsize 400
set more off
log using "LeedsMattesVogelAJPS2009.smcl", replace

use "LeedsMattesVogelAJPS2009.dta", clear
su wcchangedA demwcchangeA ldrtransA demldrtransA capcheither20 regchangeeither chTEAltorBmt alformA demdA asymmetry  nomicoop treaty milinst time timesquare timecube
corr wcchangedA demwcchangeA ldrtransA demldrtransA capcheither20 regchangeeither chTEAltorBmt alformA demdA asymmetry  nomicoop treaty milinst time timesquare timecube
tab wcchangedA 
tab demwcchangeA
tab ldrtransA 
tab demldrtransA 
tab capchangeeither
tab capcheither20 
tab capcheither25
tab capcheither30
tab regchangeeither 
tab chTEAltorBmt 
tab alformA 
tab demdA 
tab asymmetry  
tab nomicoop 
tab treaty 
tab milinst

tab demdA wcchangedA
tab demdA ldrtransA
tab ldrtransA if demdA==1
tab wcchangedA if demdA==1
tab ldrtransA if demdA==0
tab wcchangedA if demdA==0

tab wcchangesameform2 wcchangensameform2
tab wcchangesameformdem2 wcchangensameformdem2
tab wcchangensameformndem2

**replicate Leeds and Savun with smaller sample
logit violate capcheither20 regchangeeither chTEAltorBmt alformA demdA asymmetry  nomicoop treaty milinst time timesquare timecube, robust cluster (atopidphase)

**without interaction term-- first column of Table 1 and first row of Table 2
tab violate
logit violate wcchangedA capcheither20 regchangeeither chTEAltorBmt alformA demdA asymmetry  nomicoop treaty milinst time timesquare timecube, robust cluster (atopidphase)

estsimp logit violate wcchangedA capcheither20 regchangeeither chTEAltorBmt alformA demdA asymmetry  nomicoop treaty milinst time timesquare timecube, robust cluster (atopidphase)
setx mean
setx wcchangedA 0
simqi, prval(1) genpr(pr9)
drop  b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14

estsimp logit violate wcchangedA capcheither20 regchangeeither chTEAltorBmt alformA demdA asymmetry  nomicoop treaty milinst time timesquare timecube, robust cluster (atopidphase)
setx mean
setx wcchangedA 1
simqi, prval(1) genpr(pr10)
drop  b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14

gen rr5 = pr10 / pr9
sumqi rr5

**main model-- Table 1 Column 2 and Table 2 Rows 2 & 3
logit violate wcchangedA demwcchangeA capcheither20 regchangeeither chTEAltorBmt alformA demdA asymmetry  nomicoop treaty milinst time timesquare timecube, robust cluster (atopidphase)

estsimp logit violate wcchangedA demwcchangeA capcheither20 regchangeeither chTEAltorBmt alformA demdA asymmetry  nomicoop treaty milinst time timesquare timecube, robust cluster (atopidphase)
setx mean
setx wcchangedA 0
setx demwcchangeA 0
setx demdA 0
simqi, prval(1) genpr(pr1)
drop  b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14 b15

estsimp logit violate wcchangedA demwcchangeA capcheither20 regchangeeither chTEAltorBmt alformA demdA asymmetry  nomicoop treaty milinst time timesquare timecube, robust cluster (atopidphase)
setx mean
setx wcchangedA 1
setx demwcchangeA 0
setx demdA 0
simqi, prval(1) genpr(pr2)
drop  b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14 b15

gen rr1 = pr2 / pr1
sumqi rr1

estsimp logit violate wcchangedA demwcchangeA capcheither20 regchangeeither chTEAltorBmt alformA demdA asymmetry  nomicoop treaty milinst time timesquare timecube, robust cluster (atopidphase)
setx mean
setx wcchangedA 0
setx demwcchangeA 0
setx demdA 1
simqi, prval(1) genpr(pr3)
drop  b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14 b15

estsimp logit violate wcchangedA demwcchangeA capcheither20 regchangeeither chTEAltorBmt alformA demdA asymmetry  nomicoop treaty milinst time timesquare timecube, robust cluster (atopidphase)
setx mean
setx wcchangedA 1
setx demwcchangeA 1
setx demdA 1
simqi, prval(1) genpr(pr4)
drop  b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14 b15

gen rr2 = pr4 / pr3
sumqi rr2

**leadertrans without wcchange-- column 3 of table 1 
logit violate ldrtransA demldrtransA capcheither20 regchangeeither chTEAltorBmt alformA demdA asymmetry  nomicoop treaty milinst time timesquare timecube, robust cluster (atopidphase)

estsimp logit violate ldrtransA demldrtransA capcheither20 regchangeeither chTEAltorBmt alformA demdA asymmetry  nomicoop treaty milinst time timesquare timecube, robust cluster (atopidphase)
setx mean
setx ldrtransA 0
setx demldrtransA 0
setx demdA 0
simqi, prval(1) genpr(pr5)
drop  b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14 b15

estsimp logit violate ldrtransA demldrtransA capcheither20 regchangeeither chTEAltorBmt alformA demdA asymmetry  nomicoop treaty milinst time timesquare timecube, robust cluster (atopidphase)
setx mean
setx ldrtransA 1
setx demldrtransA 0
setx demdA 0
simqi, prval(1) genpr(pr6)
drop  b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14 b15

gen rr3 = pr6 / pr5
sumqi rr3

estsimp logit violate ldrtransA demldrtransA capcheither20 regchangeeither chTEAltorBmt alformA demdA asymmetry  nomicoop treaty milinst time timesquare timecube, robust cluster (atopidphase)
setx mean
setx ldrtransA 0
setx demldrtransA 0
setx demdA 1
simqi, prval(1) genpr(pr7)
drop  b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14 b15

estsimp logit violate ldrtransA demldrtransA capcheither20 regchangeeither chTEAltorBmt alformA demdA asymmetry  nomicoop treaty milinst time timesquare timecube, robust cluster (atopidphase)
setx mean
setx ldrtransA 1
setx demldrtransA 1
setx demdA 1
simqi, prval(1) genpr(pr8)
drop  b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14 b15

gen rr4 = pr8 / pr7
sumqi rr4

**renegotiation model-- this analysis uses all renegotiation cases.  We also analyzed leaving out renegsame, and the results were unchanged.
tab renegotiate
logit renegotiate wcchangedA demwcchangeA capcheither20 regchangeeither chTEAltorBmt alformA demdA asymmetry  nomicoop treaty milinst time timesquare timecube, robust cluster (atopidphase)

estsimp logit renegotiate wcchangedA demwcchangeA capcheither20 regchangeeither chTEAltorBmt alformA demdA asymmetry  nomicoop treaty milinst time timesquare timecube, robust cluster (atopidphase)
setx mean
setx wcchangedA 0
setx demwcchangeA 0
setx demdA 1
simqi, prval(1) genpr(pr11)
drop  b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14 b15

estsimp logit renegotiate wcchangedA demwcchangeA capcheither20 regchangeeither chTEAltorBmt alformA demdA asymmetry  nomicoop treaty milinst time timesquare timecube, robust cluster (atopidphase)
setx mean
setx wcchangedA 1
setx demwcchangeA 1
setx demdA 1
simqi, prval(1) genpr(pr12)
drop  b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14 b15

gen rr6 = pr12 / pr11
sumqi rr6

estsimp logit renegotiate wcchangedA demwcchangeA capcheither20 regchangeeither chTEAltorBmt alformA demdA asymmetry  nomicoop treaty milinst time timesquare timecube, robust cluster (atopidphase)
setx mean
setx wcchangedA 0
setx demwcchangeA 0
setx demdA 0
simqi, prval(1) genpr(pr13)
drop  b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14 b15

estsimp logit renegotiate wcchangedA demwcchangeA capcheither20 regchangeeither chTEAltorBmt alformA demdA asymmetry  nomicoop treaty milinst time timesquare timecube, robust cluster (atopidphase)
setx mean
setx wcchangedA 1
setx demwcchangeA 0
setx demdA 0
simqi, prval(1) genpr(pr14)
drop  b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14 b15

gen rr7 = pr14 / pr13
sumqi rr7

**robustness checks

**same wc returns to power
**this checks what happens when we leave out of wcchange the cases where the coalition that comes to power is the same one that formed the alliance.
**this does not affect nondemocracies because it is never the case that the same coalition that formed the alliance comes back to power after an interim wc has maintained the alliance.
**effectively, what this does is eliminate 85 WC changes in democracies where the coalition that comes to power formed the alliance, and the alliance was maintained by another WC.
logit violate wcchangensameform2 wcchangensameformdem2 capcheither20 regchangeeither chTEAltorBmt alformA demdA asymmetry  nomicoop treaty milinst time timesquare timecube, robust cluster (atopidphase)

**two year window on WC change
logit violate lagwcchangeA lagdemwcchangeA capcheither20 regchangeeither chTEAltorBmt alformA demdA asymmetry  nomicoop treaty milinst time timesquare timecube, robust cluster (atopidphase)

**cluster on stateA-year instead of atopidphase
logit violate ldrtransA demldrtransA capcheither20 regchangeeither chTEAltorBmt alformA demdA asymmetry  nomicoop treaty milinst time timesquare timecube, robust cluster (stateAyear)
logit violate wcchangedA demwcchangeA capcheither20 regchangeeither chTEAltorBmt alformA demdA asymmetry  nomicoop treaty milinst time timesquare timecube, robust cluster (stateAyear)

**run separately for demdA=1 and demdA=0
tab demdA
tab demdA violate
logit violate wcchangedA capcheither20 regchangeeither chTEAltorBmt alformA asymmetry  nomicoop treaty milinst time timesquare timecube if demdA==1, robust cluster (atopidphase)
logit violate wcchangedA capcheither20 regchangeeither chTEAltorBmt alformA asymmetry  nomicoop treaty milinst time timesquare timecube if demdA==0, robust cluster (atopidphase) 

**different thresholds for capchange  (10, 25, 30)
logit violate wcchangedA demwcchangeA capchangeeither regchangeeither chTEAltorBmt alformA demdA asymmetry  nomicoop treaty milinst time timesquare timecube, robust cluster (atopidphase)
logit violate wcchangedA demwcchangeA capcheither25 regchangeeither chTEAltorBmt alformA demdA asymmetry  nomicoop treaty milinst time timesquare timecube, robust cluster (atopidphase)
logit violate wcchangedA demwcchangeA capcheither30 regchangeeither chTEAltorBmt alformA demdA asymmetry  nomicoop treaty milinst time timesquare timecube, robust cluster (atopidphase)

**different thresholds for regchange (1, 3)
logit violate wcchangedA demwcchangeA capcheither20 regchangeeither1 chTEAltorBmt alformA demdA asymmetry  nomicoop treaty milinst time timesquare timecube, robust cluster (atopidphase)
logit violate wcchangedA demwcchangeA capcheither20 regchangeeither3 chTEAltorBmt alformA demdA asymmetry  nomicoop treaty milinst time timesquare timecube, robust cluster (atopidphase)


save "LeedsMattesVogelAJPS2009b.dta", replace

**only cases with wc change sometime in history
contract atopidphase stateA wcchangedA
drop if wcchangedA==0
keep atopidphase stateA
gen wcchangeAever=1
save "WCchAonly.dta", replace

use "LeedsMattesVogelAJPS2009b.dta", clear
merge atopidphase stateA using "WCchAonly.dta"
tab _merge
drop _merge
tab wcchangeAever
recode wcchangeAever .=0
tab wcchangeAever

logit violate wcchangedA demwcchangeA capcheither20 regchangeeither chTEAltorBmt alformA demdA asymmetry  nomicoop treaty milinst time timesquare timecube if wcchangeAever==1, robust cluster (atopidphase)

estsimp logit violate wcchangedA demwcchangeA capcheither20 regchangeeither chTEAltorBmt alformA demdA asymmetry  nomicoop treaty milinst time timesquare timecube if wcchangeAever==1, robust cluster (atopidphase)
setx mean
setx wcchangedA 0
setx demwcchangeA 0
setx demdA 0
simqi, prval(1) genpr(pr23)
drop  b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14 b15

estsimp logit violate wcchangedA demwcchangeA capcheither20 regchangeeither chTEAltorBmt alformA demdA asymmetry  nomicoop treaty milinst time timesquare timecube if wcchangeAever==1, robust cluster (atopidphase)
setx mean
setx wcchangedA 1
setx demwcchangeA 0
setx demdA 0
simqi, prval(1) genpr(pr24)
drop  b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14 b15

gen rr12 = pr24 / pr23
sumqi rr12

estsimp logit violate wcchangedA demwcchangeA capcheither20 regchangeeither chTEAltorBmt alformA demdA asymmetry  nomicoop treaty milinst time timesquare timecube if wcchangeAever==1, robust cluster (atopidphase)
setx mean
setx wcchangedA 0
setx demwcchangeA 0
setx demdA 1
simqi, prval(1) genpr(pr25)
drop  b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14 b15

estsimp logit violate wcchangedA demwcchangeA capcheither20 regchangeeither chTEAltorBmt alformA demdA asymmetry  nomicoop treaty milinst time timesquare timecube if wcchangeAever==1, robust cluster (atopidphase)
setx mean
setx wcchangedA 1
setx demwcchangeA 1
setx demdA 1
simqi, prval(1) genpr(pr26)
drop  b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14 b15

gen rr13 = pr26 / pr25
sumqi rr13



**only cases with leadership change sometime in history
use "LeedsMattesVogelAJPS2009b.dta", clear
contract atopidphase stateA ldrtransA
drop if ldrtransA==0
keep atopidphase stateA
gen ldrtransAever=1
save "ldrtransAonly.dta", replace

use "LeedsMattesVogelAJPS2009b.dta", clear
merge atopidphase stateA using "ldrtransAonly.dta"
tab _merge
drop _merge
tab ldrtransAever
recode ldrtransAever .=0
tab ldrtransAever
logit violate ldrtransA demldrtransA capcheither20 regchangeeither chTEAltorBmt alformA demdA asymmetry  nomicoop treaty milinst time timesquare timecube if ldrtransAever==1, robust cluster (atopidphase)

log close
