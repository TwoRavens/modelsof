clear

* In the excel file the opposing volumes are calculated weekly using the same process
* as in the cross sectional dataset
import excel "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/Time/attacktime.xls", sheet("Sheet1") firstrow

tsset campaign week
tsfill, full
xtset campaign week

encode race, gen(race2)

recode candattack .=0
recode supattack .=0

xtdescribe

* Lagged Variables
gen outattackL1=L1.outattack
gen outattackL2=L2.outattack
gen supattackL1=outattackL1/canaud
gen supattackL2=outattackL2/canaud

gen oppattackL1=L1.oppattack
gen oppattackL2=L2.oppattack
gen oppattackrL1=oppattackL1/canaud
gen oppattackrL2=oppattackL2/canaud
gen oppattackr=oppattack/canaud

recode supattackL1 .=0
recode supattackL2 .=0
recode oppattackrL1 .=0
recode oppattackrL2 .=0

gen candattackL1=L1.candattack
gen candattackL2=L2.candattack

xtunitroot fisher candattack, lag(2) dfuller
xtunitroot fisher supattack, lag(2) dfuller

xtunitroot fisher candattack, lag(10) dfuller
xtunitroot fisher supattack, lag(10) dfuller

* DV=Candidate Attack Ratio
* Senate
xtreg candattack supattackL1 supattackL2 oppattackrL1 oppattackrL2 if race2==1 & cancount>19, fe
* House
xtreg candattack supattackL1 supattackL2 oppattackrL1 oppattackrL2 if race2==2 & cancount>19, fe
* DV=Supporting Attack Ratio
* Senate
xtreg supattack candattackL1 candattackL2 oppattackrL1 oppattackrL2 if race2==1 & cancount>19, fe
* House
xtreg supattack candattackL1 candattackL2 oppattackrL1 oppattackrL2 if race2==2 & cancount>19, fe
