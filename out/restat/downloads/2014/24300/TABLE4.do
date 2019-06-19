clear
set more off
set matsize 7000

cd ""

cap log close
log using TABLE4.log, text replace

**This file produces results (first regressions and then tests) displayed in Table 4**

use "RESTAT_REFORMS.dta", clear

preserve

drop if missing(quartexpr)

sort ifs year

tsset ifs year

xi: reg GDP_Gr lGDP1 TR1 i.year i.ifs if quartexpr==1, vce(cl ifs)

outreg2 TR1 lGDP1 using TABLE4_Q1, bdec(3) nocon word replace


foreach X in CUR100 AG NW DF BK SM CAP100 CAPRES CAPNONRES  {

xi: reg GDP_Gr lGDP1 `X'1 i.year i.ifs if quartexpr==1, vce(cl ifs)

outreg2 `X'1 lGDP1 using TABLE4_Q1, bdec(3) nocon word 

 }


xi: reg GDP_Gr lGDP1 TR1 i.year i.ifs if quartexpr==2, vce(cl ifs)

outreg2 TR1 lGDP1 using TABLE4_Q2, bdec(3) nocon word replace


foreach X in CUR100 AG NW DF BK SM CAP100 CAPRES CAPNONRES  {

xi: reg GDP_Gr lGDP1 `X'1 i.year i.ifs if quartexpr==2, vce(cl ifs)

outreg2 `X'1 lGDP1 using TABLE4_Q2, bdec(3) nocon word 

 }


 
xi: reg GDP_Gr lGDP1 TR1 i.year i.ifs if quartexpr==3, vce(cl ifs)

outreg2 TR1 lGDP1 using TABLE4_Q3, bdec(3) nocon word replace


foreach X in CUR100 AG NW DF BK SM CAP100 CAPRES CAPNONRES  {

xi: reg GDP_Gr lGDP1 `X'1 i.year i.ifs if quartexpr==3, vce(cl ifs)

outreg2 `X'1 lGDP1 using TABLE4_Q3, bdec(3) nocon word 

 }

 
xi: reg GDP_Gr lGDP1 TR1 i.year i.ifs if quartexpr==4, vce(cl ifs)

outreg2 TR1 lGDP1 using TABLE4_Q4, bdec(3) nocon word replace


foreach X in CUR100 AG NW DF BK SM CAP100 CAPRES CAPNONRES  {

xi: reg GDP_Gr lGDP1 `X'1 i.year i.ifs if quartexpr==4, vce(cl ifs)

outreg2 `X'1 lGDP1 using TABLE4_Q4, bdec(3) nocon word 

 }

restore


clear



**TESTS ***

use "RESTAT_REFORMS.dta", clear

sort ifs year

gen EXPRQ1 = .

replace EXPRQ1 = 1 if quartexpr==1

replace EXPRQ1 = 0 if quartexpr!=1 & !missing(quartexpr)


gen EXPRQ2 = .

replace EXPRQ2 = 1 if quartexpr==2

replace EXPRQ2 = 0 if quartexpr!=2 & !missing(quartexpr)


gen EXPRQ3 = .

replace EXPRQ3 = 1 if quartexpr==3

replace EXPRQ3 = 0 if quartexpr!=3 & !missing(quartexpr)


gen EXPRQ4 = .

replace EXPRQ4 = 1 if quartexpr==4

replace EXPRQ4 = 0 if quartexpr!=4 & !missing(quartexpr)


**gen interactions with the 4 dummy for risk of expropration **

foreach X in lGDP TR CUR100 AG NW DF BK SM CAP100 CAPRES CAPNONRES  {

gen `X'1_1QEX=`X'1*EXPRQ1
gen `X'1_2QEX=`X'1*EXPRQ2
gen `X'1_3QEX=`X'1*EXPRQ3
gen `X'1_4QEX=`X'1*EXPRQ4

}
 

forvalues i=1(1)163 {

gen ifsd1EQ_`i' = ifsdum`i'*EXPRQ1

}


forvalues i=1(1)163 {

gen ifsd2EQ_`i' = ifsdum`i'*EXPRQ2

}


forvalues i=1(1)163 {

gen ifsd3EQ_`i' = ifsdum`i'*EXPRQ3


}

forvalues i=1(1)163 {

gen ifsd4EQ_`i' = ifsdum`i'*EXPRQ4

}


forvalues i=1(1)34 {

gen yd1EQ_`i' = yeardum`i'*EXPRQ1

}

forvalues i=1(1)34 {

gen yd2EQ_`i' = yeardum`i'*EXPRQ2

}


forvalues i=1(1)34 {

gen yd3EQ_`i' = yeardum`i'*EXPRQ3

}


forvalues i=1(1)34 {

gen yd4EQ_`i' = yeardum`i'*EXPRQ4

}

preserve

drop if missing(quartexpr)

sort ifs year

tsset ifs year

foreach X in TR CUR100 AG NW DF BK SM CAP100 CAPRES CAPNONRES  {

reg GDP_Gr lGDP1_1QEX lGDP1_2QEX lGDP1_3QEX lGDP1_4QEX `X'1_1QEX `X'1_2QEX `X'1_3QEX `X'1_4QEX EXPRQ1-EXPRQ4 ifsd1EQ_* ifsd2EQ_*  ifsd3EQ_*  ifsd4EQ_* yd1EQ_* yd2EQ_* yd3EQ_* yd4EQ_*, noconstant vce(cl ifs)

testparm `X'1_1QEX `X'1_2QEX `X'1_3QEX `X'1_4QEX, equal

}

restore

log close

clear






          
