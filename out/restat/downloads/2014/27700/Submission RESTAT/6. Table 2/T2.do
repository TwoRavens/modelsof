clear all
cd "H:\Superstars\Submission RESTAT\"

use "6. Table 2\input\variance_regressions.dta", clear

reg TOP1 totbyTOP1 
outreg2 totbyTOP1 using "6. Table 2\T2.out", nolabel nocons bracket ctitle("ind, nr1_SS, NO C FE")  replace
reg TOP1_not totbyTOP1 
outreg2 totbyTOP1 using "6. Table 2\T2.out", nolabel nocons bracket ctitle("ind, nr1_NSS, NO C FE")  append
areg TOP1 totbyTOP1, abs(country)
outreg2 totbyTOP1 using "6. Table 2\T2.out", nolabel nocons bracket ctitle("ind, nr1_SS, C FE")  append
areg TOP1_not totbyTOP1, abs(country)
outreg2 totbyTOP1 using "6. Table 2\T2.out", nolabel nocons bracket ctitle("ind, nr1_NSS, C FE")  append
areg TOP1 totbyTOP1, abs(ind)
outreg2 totbyTOP1 using "6. Table 2\T2.out", nolabel nocons bracket ctitle("ind, nr1_SS, ind FE")  append
areg TOP1_not totbyTOP1, abs(ind)
outreg2 totbyTOP1 using "6. Table 2\T2.out", nolabel nocons bracket ctitle("ind, nr1_NSS, ind FE")  append
xi: areg TOP1 totbyTOP1 i.country, abs(ind)
outreg2 totbyTOP1 using "6. Table 2\T2.out", nolabel nocons bracket ctitle("ind, nr1_SS, C ind FE")  append
xi: areg TOP1_not totbyTOP1 i.country, abs(ind)
outreg2 totbyTOP1 using "6. Table 2\T2.out", nolabel nocons bracket ctitle("ind, nr1_NSS, C ind FE")  append
reg TOP2 totbyTOP2 
outreg2 totbyTOP2 using "6. Table 2\T2.out", nolabel nocons bracket ctitle("ind, nr2_SS, NO C FE")  append
reg TOP2_not totbyTOP2 
outreg2 totbyTOP2 using "6. Table 2\T2.out", nolabel nocons bracket ctitle("ind, nr2_NSS, NO C FE")  append
areg TOP2 totbyTOP2, abs(country)
outreg2 totbyTOP2 using "6. Table 2\T2.out", nolabel nocons bracket ctitle("ind, nr2_SS, C FE")  append
areg TOP2_not totbyTOP2, abs(country)
outreg2 totbyTOP2 using "6. Table 2\T2.out", nolabel nocons bracket ctitle("ind, nr2_NSS, C FE")  append
areg TOP2 totbyTOP2, abs(ind)
outreg2 totbyTOP2 using "6. Table 2\T2.out", nolabel nocons bracket ctitle("ind, nr2_SS, ind FE")  append
areg TOP2_not totbyTOP2, abs(ind)
outreg2 totbyTOP2 using "6. Table 2\T2.out", nolabel nocons bracket ctitle("ind, nr2_NSS, ind FE")  append
xi: areg TOP2 totbyTOP2 i.country, abs(ind)
outreg2 totbyTOP2 using "6. Table 2\T2.out", nolabel nocons bracket ctitle("ind, nr2_SS, C ind FE")  append
xi: areg TOP2_not totbyTOP2 i.country, abs(ind)
outreg2 totbyTOP2 using "6. Table 2\T2.out", nolabel nocons bracket ctitle("ind, nr2_NSS, C ind FE")  append
reg TOP5 totbyTOP5 
outreg2 totbyTOP5 using "6. Table 2\T2.out", nolabel nocons bracket ctitle("ind, nr5_SS, NO C FE")  append
reg TOP5_not totbyTOP5 
outreg2 totbyTOP5 using "6. Table 2\T2.out", nolabel nocons bracket ctitle("ind, nr5_NSS, NO C FE")  append
areg TOP5 totbyTOP5, abs(country)
outreg2 totbyTOP5 using "6. Table 2\T2.out", nolabel nocons bracket ctitle("ind, nr5_SS, C FE")  append
areg TOP5_not totbyTOP5, abs(country)
outreg2 totbyTOP5 using "6. Table 2\T2.out", nolabel nocons bracket ctitle("ind, nr5_NSS, C FE")  append
areg TOP5 totbyTOP5, abs(ind)
outreg2 totbyTOP5 using "6. Table 2\T2.out", nolabel nocons bracket ctitle("ind, nr5_SS, ind FE")  append
areg TOP5_not totbyTOP5, abs(ind)
outreg2 totbyTOP5 using "6. Table 2\T2.out", nolabel nocons bracket ctitle("ind, nr5_NSS, ind FE")  append
xi: areg TOP5 totbyTOP5 i.country, abs(ind)
outreg2 totbyTOP5 using "6. Table 2\T2.out", nolabel nocons bracket ctitle("ind, nr5_SS, C ind FE")  append
xi: areg TOP5_not totbyTOP5 i.country, abs(ind)
outreg2 totbyTOP5 using "6. Table 2\T2.out", nolabel nocons bracket ctitle("ind, nr5_NSS, C ind FE")  append
