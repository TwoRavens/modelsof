clear
set more off
set matsize 7000

cd ""

cap log close
log using TABLE3.log, text replace

**This do file produces results (first regressions and then tests) displayed in Table 3 **

use "RESTAT_REFORMS.dta", clear

preserve

drop if missing(QCONSTR)

sort ifs year


xi: reg GDP_Gr lGDP1 TR1 i.year i.ifs if QCONSTR==1, vce(cl ifs)

outreg2 TR1 lGDP1 using TABLE3_Q1, bdec(3) nocon word replace


foreach X in CUR100 AG NW DF BK SM CAP100 CAPRES CAPNONRES  {

xi: reg GDP_Gr lGDP1 `X'1 i.year i.ifs if QCONSTR==1, vce(cl ifs)

outreg2 `X'1 lGDP1 using TABLE3_Q1, bdec(3) nocon word 

 }


xi: reg GDP_Gr lGDP1 TR1 i.year i.ifs if QCONSTR==2, vce(cl ifs)

outreg2 TR1 lGDP1 using TABLE3_Q2, bdec(3) nocon word replace


foreach X in CUR100 AG NW DF BK SM CAP100 CAPRES CAPNONRES  {

xi: reg GDP_Gr lGDP1 `X'1 i.year i.ifs if QCONSTR==2, vce(cl ifs)

outreg2 `X'1 lGDP1 using TABLE3_Q2, bdec(3) nocon word 

 }


xi: reg GDP_Gr lGDP1 TR1 i.year i.ifs if QCONSTR==3, vce(cl ifs)

outreg2 TR1 lGDP1 using TABLE3_Q3, bdec(3) nocon word replace


foreach X in CUR100 AG NW DF BK SM CAP100 CAPRES CAPNONRES  {

xi: reg GDP_Gr lGDP1 `X'1 i.year i.ifs if QCONSTR==3, vce(cl ifs)

outreg2 `X'1 lGDP1 using TABLE3_Q3, bdec(3) nocon word 

 }

 
xi: reg GDP_Gr lGDP1 TR1 i.year i.ifs if QCONSTR==4, vce(cl ifs)

outreg2 TR1 lGDP1 using TABLE3_Q4, bdec(3) nocon word replace


foreach X in CUR100 AG NW DF BK SM CAP100 CAPRES CAPNONRES  {

xi: reg GDP_Gr lGDP1 `X'1 i.year i.ifs if QCONSTR==4, vce(cl ifs)

outreg2 `X'1 lGDP1 using TABLE3_Q4, bdec(3) nocon word
 
 }

restore


**TESTS**

clear

use "RESTAT_REFORMS.dta", clear


**dummy quartiles xtconst ***

gen CONSTRAINQ1 = .

replace CONSTRAINQ1 = 1 if QCONSTR==1

replace CONSTRAINQ1 = 0 if QCONSTR!=1 & !missing(QCONSTR)


gen CONSTRAINQ2 = .

replace CONSTRAINQ2 = 1 if QCONSTR==2

replace CONSTRAINQ2 = 0 if QCONSTR!=2 & !missing(QCONSTR)


gen CONSTRAINQ3 = .

replace CONSTRAINQ3 = 1 if QCONSTR==3

replace CONSTRAINQ3 = 0 if QCONSTR!=3 & !missing(QCONSTR)


gen CONSTRAINQ4 = .

replace CONSTRAINQ4 = 1 if QCONSTR==4

replace CONSTRAINQ4 = 0 if QCONSTR!=4 & !missing(QCONSTR)



**gen interactions with the 4 dummy for constraints **

foreach X in lGDP TR CUR100 AG NW DF BK SM CAP100 CAPRES CAPNONRES  {

gen `X'1_1QC=`X'1*CONSTRAINQ1
gen `X'1_2QC=`X'1*CONSTRAINQ2
gen `X'1_3QC=`X'1*CONSTRAINQ3
gen `X'1_4QC=`X'1*CONSTRAINQ4

}

forvalues i=1(1)163 {

gen ifsd1CQ_`i' = ifsdum`i'*CONSTRAINQ1

}


forvalues i=1(1)163 {

gen ifsd2CQ_`i' = ifsdum`i'*CONSTRAINQ2

}


forvalues i=1(1)163 {

gen ifsd3CQ_`i' = ifsdum`i'*CONSTRAINQ3

}


forvalues i=1(1)163 {

gen ifsd4CQ_`i' = ifsdum`i'*CONSTRAINQ4

}


forvalues i=1(1)34 {

gen yd1CQ_`i' = yeardum`i'*CONSTRAINQ1

}


forvalues i=1(1)34 {

gen yd2CQ_`i' = yeardum`i'*CONSTRAINQ2

}


forvalues i=1(1)34 {

gen yd3CQ_`i' = yeardum`i'*CONSTRAINQ3

}


forvalues i=1(1)34 {

gen yd4CQ_`i' = yeardum`i'*CONSTRAINQ4

}


preserve

drop if missing(QCONSTR)

sort ifs year

tsset ifs year

foreach X in TR CUR100 AG NW DF BK SM CAP100 CAPRES CAPNONRES  {

reg GDP_Gr lGDP1_1QC lGDP1_2QC lGDP1_3QC lGDP1_4QC `X'1_1QC `X'1_2QC `X'1_3QC `X'1_4QC CONSTRAINQ1-CONSTRAINQ4 ifsd1CQ_* ifsd2CQ_* ifsd3CQ_* ifsd4CQ_* yd1CQ_* yd2CQ_* yd3CQ_* yd4CQ_*, noconstant vce(cl ifs)

testparm `X'1_1QC `X'1_2QC `X'1_3QC `X'1_4QC, equal

}

restore

log close
 
clear
 
 
 

