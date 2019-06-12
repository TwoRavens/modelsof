
********** Master Do File for "How Labor Unions Increase Political Knowledge: Evidence From the United States" **********

***** The tables and figures use data from three sources: 
**** 1) The 2012 American National Election Study (ANES), 2) The 2004 National Annenberg Election Study (NAES), and 3) The Cumulative American National Election Studies (CANES)

*** Code for Figure 2 in Main Paper (2012 ANES) ***
clear
use "C:\Users\dmac9\Dropbox\Political Behavior Accepted Unions Manuscript\anes_2012_matched.dta"

reg tpk c.union_mem##i.educ3 mode female white /// 
age age2 i.income i.church_attend unemployed married i.interest_attention ///
i.sfe , cluster(sfe)

margins, dydx(union_mem) at(educ3=(1(1)3))
marginsplot, yline(0) recast(scatter) 

*** Code for Table 3 in Main Paper (2012 ANES) ***
clear
use "C:\Users\dmac9\Dropbox\Political Behavior Accepted Unions Manuscript\anes_2012_matched.dta"

*Row 1
margins, at(educ3=1)
margins, at(educ3=2)
margins, at(educ3=3)

*Row 2
margins, at(educ3=1 union_mem=0)
margins, at(educ3=2 union_mem=0)
margins, at(educ3=3 union_mem=0)

*Row 3
margins, at(educ3=1 union_mem=1)
margins, at(educ3=2 union_mem=1)
margins, at(educ3=3 union_mem=1)

*** Code for Table 4 in Main Paper (2012 ANES) ***
clear
use "C:\Users\dmac9\Dropbox\Political Behavior Accepted Unions Manuscript\anes_2012_matched.dta"

*Row 1
margins, at(educ3=1 union_mem=0)
margins, at(educ3=1 union_mem=1)

*Row 2
margins, at(income=2)
margins, at(income=3)

*Row 3
margins, at(interest_attention=3)
margins, at(interest_attention=4)

*** Code for Figure 3 in Main Paper (2004 NAES) ***
clear
use "C:\Users\dmac9\Dropbox\Political Behavior Accepted Unions Manuscript\naes_2004_matched.dta"

reg pk c.union_mem##i.educ3 female white age age2 unemployed married i.income  /// 
i.church_attend i.interest_politics ///
i.state_num, cluster(state)

margins, dydx(union_mem) at(educ3=(1(1)3))
marginsplot, yline(0) recast(scatter)

*** Code for Table 5 in Main Paper (CANES) ***
clear
use "C:\Users\dmac9\Dropbox\Political Behavior Unions and Knowledge R and R\canes_data.dta"

*Pre-1996, 1968-1992
reg pol_info_pre c.union_mem##i.educ3 i.year if year<1996, r
outreg2 using canes.tex, replace dec(3) sideway

*1996 and later, 1996-2016
reg pol_info_pre c.union_mem##i.educ3 i.year if year>=1996 & year!=2002, r
outreg2 using canes.tex, append dec(3) sideway


*** Code for Table 6 in Main Paper (2012 ANES) ***
clear
use "C:\Users\dmac9\Dropbox\Political Behavior Accepted Unions Manuscript\anes_2012_matched.dta"

*Non RTW states
reg tpk c.union_mem##i.educ3 mode female white /// 
age age2 i.income i.church_attend unemployed married i.interest_attention ///
i.sfe if rtw==0, cluster(sfe)

margins, dydx(union_mem) at(educ3=(1(1)3))
marginsplot, yline(0) recast(scatter) 

*RTW states
reg tpk c.union_mem##i.educ3 mode female white /// 
age age2 i.income i.church_attend unemployed married i.interest_attention ///
i.sfe if rtw==1, cluster(sfe)

margins, dydx(union_mem) at(educ3=(1(1)3))
marginsplot, yline(0) recast(scatter) 

*** Code for Table 7 in Main Paper (2004 NAES) ***
clear
use "C:\Users\dmac9\Dropbox\Political Behavior Accepted Unions Manuscript\naes_2004_matched.dta"

*Private Sector
reg pk c.union_mem##i.educ3 female white age age2 unemployed married i.income  /// 
i.church_attend i.interest_politics ///
i.state_num if public_sector==0, cluster(state)

outreg2 using ann04_sector.tex, replace dec(3) sideway

*Public Sector
reg pk c.union_mem##i.educ3 female white age age2 unemployed married i.income  /// 
i.church_attend i.interest_politics ///
i.state_num if public_sector==1, cluster(state)

outreg2 using ann04_sector.tex, append dec(3) sideway

*** Code for Table 8 in Main Paper (2012 ANES) ***
clear 
use "C:\Users\dmac9\Dropbox\Political Behavior Accepted Unions Manuscript\anes_2012_matched.dta"

*High Union States
reg tpk c.union_mem##i.educ3 mode female white /// 
age age2 i.income i.church_attend unemployed married i.interest_attention ///
i.sfe if state_union_pct>10.6, cluster(sfe)

margins, dydx(union_mem) at(educ3=(1(1)3))
marginsplot, yline(0) recast(scatter) 

*Low Union States
reg tpk c.union_mem##i.educ3 mode female white /// 
age age2 i.income i.church_attend unemployed married i.interest_attention ///
i.sfe if state_union_pct<=10.6, cluster(sfe)

margins, dydx(union_mem) at(educ3=(1(1)3))
marginsplot, yline(0) recast(scatter) 
