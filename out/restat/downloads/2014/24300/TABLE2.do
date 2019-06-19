clear
set more off
set matsize 7000

cd ""

cap log close
log using TABLE2.log, text replace

**This do file produces results (first regressions and then tests)summarized in Table2**

use "RESTAT_REFORMS.dta", clear

preserve

drop if missing(QUAR_FRONT)

sort ifs year

tsset ifs year

xi: reg GDP_Gr GDP_US1 TR1 i.year i.ifs if QUAR_FRONT==1, vce(cl ifs)

outreg2 TR1 GDP_US1 using TABLE2_Q1, bdec(3) nocon word replace


foreach X in CUR100 AG NW DF BK SM CAP100 CAPRES CAPNONRES  {

xi: reg GDP_Gr GDP_US1 `X'1 i.year i.ifs if QUAR_FRONT==1, vce(cl ifs)

outreg2 `X'1 GDP_US1 using TABLE2_Q1, bdec(3) nocon word 

 }


xi: reg GDP_Gr GDP_US1 TR1 i.year i.ifs if QUAR_FRONT==2, vce(cl ifs)

outreg2 TR1 GDP_US1 using TABLE2_Q2, bdec(3) nocon word replace


foreach X in CUR100 AG NW DF BK SM CAP100 CAPRES CAPNONRES  {

xi: reg GDP_Gr GDP_US1 `X'1 i.year i.ifs if QUAR_FRONT==2, vce(cl ifs)

outreg2 `X'1 GDP_US1 using TABLE2_Q2, bdec(3) nocon word 

 }


 
xi: reg GDP_Gr GDP_US1 TR1 i.year i.ifs if QUAR_FRONT==3, vce(cl ifs)

outreg2 TR1 GDP_US1 using TABLE2_Q3, bdec(3) nocon word replace


foreach X in CUR100 AG NW DF BK SM CAP100 CAPRES CAPNONRES  {

xi: reg GDP_Gr GDP_US1 `X'1 i.year i.ifs if QUAR_FRONT==3, vce(cl ifs)

outreg2 `X'1 GDP_US1 using TABLE2_Q3, bdec(3) nocon word 

 }

 
xi: reg GDP_Gr GDP_US1 TR1 i.year i.ifs if QUAR_FRONT==4, vce(cl ifs)

outreg2 TR1 GDP_US1 using TABLE2_Q4, bdec(3) nocon word replace


foreach X in CUR100 AG NW DF BK SM CAP100 CAPRES CAPNONRES  {

xi: reg GDP_Gr GDP_US1 `X'1 i.year i.ifs if QUAR_FRONT==4, vce(cl ifs)

outreg2 `X'1 GDP_US1 using TABLE2_Q4, bdec(3) nocon word 

 }


restore

clear


***TESTS ****

use "RESTAT_REFORMS.dta", clear

sort ifs year

gen FRONTQ1 = .

replace FRONTQ1 = 1 if QUAR_FRONT==1

replace FRONTQ1 = 0 if QUAR_FRONT!=1 & !missing(QUAR_FRONT)


gen FRONTQ2 = .

replace FRONTQ2 = 1 if QUAR_FRONT==2

replace FRONTQ2 = 0 if QUAR_FRONT!=2 & !missing(QUAR_FRONT)


gen FRONTQ3 = .

replace FRONTQ3 = 1 if QUAR_FRONT==3

replace FRONTQ3 = 0 if QUAR_FRONT!=3 & !missing(QUAR_FRONT)


gen FRONTQ4 = .

replace FRONTQ4 = 1 if QUAR_FRONT==4

replace FRONTQ4 = 0 if QUAR_FRONT!=4 & !missing(QUAR_FRONT)


**gen interactions with the 4 dummy for distance frontier **

foreach X in GDP_US TR CUR100 AG NW DF BK SM CAP100 CAPRES CAPNONRES  {

gen `X'1_1QF=`X'1*FRONTQ1
gen `X'1_2QF=`X'1*FRONTQ2
gen `X'1_3QF=`X'1*FRONTQ3
gen `X'1_4QF=`X'1*FRONTQ4

}


forvalues i=1(1)163 {

gen ifsd1FQ_`i' = ifsdum`i'*FRONTQ1

}


forvalues i=1(1)163 {

gen ifsd2FQ_`i' = ifsdum`i'*FRONTQ2

}


forvalues i=1(1)163 {

gen ifsd3FQ_`i' = ifsdum`i'*FRONTQ3


}


forvalues i=1(1)163 {

gen ifsd4FQ_`i' = ifsdum`i'*FRONTQ4

}


forvalues i=1(1)34 {

gen yd1FQ_`i' = yeardum`i'*FRONTQ1

}


forvalues i=1(1)34 {

gen yd2FQ_`i' = yeardum`i'*FRONTQ2

}



forvalues i=1(1)34 {

gen yd3FQ_`i' = yeardum`i'*FRONTQ3

}


forvalues i=1(1)34 {

gen yd4FQ_`i' = yeardum`i'*FRONTQ4

}

preserve

drop if missing(QUAR_FRONT)

sort ifs year

tsset ifs year

foreach X in TR CUR100 AG NW DF BK SM CAP100 CAPRES CAPNONRES  {

reg GDP_Gr GDP_US1_1QF GDP_US1_2QF GDP_US1_3QF GDP_US1_4QF `X'1_1QF `X'1_2QF `X'1_3QF `X'1_4QF FRONTQ1-FRONTQ4 ifsd1FQ_* ifsd2FQ_*  ifsd3FQ_*  ifsd4FQ_* yd1FQ_* yd2FQ_* yd3FQ_* yd4FQ_*, noconstant vce(cl ifs)

testparm `X'1_1QF `X'1_2QF `X'1_3QF `X'1_4QF, equal

}

restore

log close

clear









