***************************************************************************
*** Replication File for Rotschild and Malhotra, "Are Public Opinion Polls Self-Fulfilling Prophecies?"
*** Research and Politics
*** Last updated: July 7, 2014
***************************************************************************


***************************************************************************
*** Open Dataset *** 
***************************************************************************
use Data, clear
set more off


***************************************************************************
*** Key: ques 101-Afghanistan, ques 102-Free Trade, ques 103-Public Financing ***
***************************************************************************

order obs ques pre post treat InfoQues InfoTreat party years gen edu race randrev_order_issues ques1 ques2 ques3 delta


***************************************************************************
*** TABLE 1: The Effect of Polling Information on Individual-Level Policy Support *** 
***************************************************************************
set more off
xtset obs
gen treat01 = (treat - 20)/60

*** Col 1: Random Effects ***
xtreg post pre treat01 ques1 ques3, re vce(cluster obs)

*** Col 2-4: One Issue Each ***
forvalues k = 101/103 {
reg post pre treat01 if ques == `k'
}

*** Col 5: Fixed Effects ***
xtreg post pre treat01 ques1 ques3, fe vce(cluster obs)

gen start = abs(pre - 50)
gen startTreat = start*treat01

*** Col 6: Random Effects ***
xtreg post pre treat01 ques1 ques3 start startTreat, re vce(cluster obs)


***************************************************************************
*** Appendix Table 1: Randomization Checks for Assignment to Treatment Support Value *** 
***************************************************************************
tabulate race, gen(race)
tabulate edu, gen(edu)

/* Standard ranges for age */
gen age1 = 1 if (years >= 18 & years <= 29)
gen age2 = 1 if (years > 29 & years <= 39)
gen age3 = 1 if (years > 39 & years <= 49)
gen age4 = 1 if (years > 49 & years <= 59)
gen age5 = 1 if (years > 59 & years <= 100)
recode age1-age5 (mis = 0)

reg treat gen race1-race6 edu1-edu5 age1-age4 if ques == 101
reg treat gen race1-race6 edu1-edu5 age1-age4 if ques == 102
reg treat gen race1-race6 edu1-edu5 age1-age4 if ques == 103


***************************************************************************
*** Note in text on party id *** 
***************************************************************************
gen party01 = party - 4
replace party01 = 0 if party01 == 4
replace party01 = -1*(party01/6 + 0.5)+1

reg pre party01 if ques == 101
reg pre party01 if ques == 102
reg pre party01 if ques == 103


***************************************************************************
*** Note in text on pre-treatment support near 50% *** 
***************************************************************************
gen mid = 1 if pre >= 49 & pre <= 51
recode mid (mis = 0)

tab mid if ques == 101
tab mid if ques == 102
tab mid if ques == 103


***************************************************************************
*** Figure 1: Row 1 Col 1 *** 
***************************************************************************
histogram pre, ///
yscale(range(0 0.06)) ///
yline(0.01, lcolor(purple) lwidth(thin)) ///
yline(0.02, lcolor(purple) lwidth(thin)) ///
yline(0.03, lcolor(purple) lwidth(thin)) ///
yline(0.04, lcolor(purple) lwidth(thin)) ///
yline(0.05, lcolor(purple) lwidth(thin)) ///
xtitle(Pre-Treatment Policy Support) ///
ylabel(0(0.01)0.06)

histogram post, ///
yscale(range(0 0.06)) ///
yline(0.01, lcolor(purple) lwidth(thin)) ///
yline(0.02, lcolor(purple) lwidth(thin)) ///
yline(0.03, lcolor(purple) lwidth(thin)) ///
yline(0.04, lcolor(purple) lwidth(thin)) ///
yline(0.05, lcolor(purple) lwidth(thin)) ///
xtitle(Post-Treatment Policy Support) ///
ylabel(0(0.01)0.06)

***************************************************************************
*** Figure 1: Row 2 Col 1 *** 
***************************************************************************
histogram pre if ques == 101, ///
yscale(range(0 0.06)) ///
yline(0.01, lcolor(purple) lwidth(thin)) ///
yline(0.02, lcolor(purple) lwidth(thin)) ///
yline(0.03, lcolor(purple) lwidth(thin)) ///
yline(0.04, lcolor(purple) lwidth(thin)) ///
yline(0.05, lcolor(purple) lwidth(thin)) ///
xtitle(Pre-Treatment Policy Support) ///
ylabel(0(0.01)0.06)

histogram post if ques == 101, ///
yscale(range(0 0.06)) ///
yline(0.01, lcolor(purple) lwidth(thin)) ///
yline(0.02, lcolor(purple) lwidth(thin)) ///
yline(0.03, lcolor(purple) lwidth(thin)) ///
yline(0.04, lcolor(purple) lwidth(thin)) ///
yline(0.05, lcolor(purple) lwidth(thin)) ///
xtitle(Pre-Treatment Policy Support) ///
ylabel(0(0.01)0.06)

***************************************************************************
*** Figure 1: Row 3 Col 1 *** 
***************************************************************************
histogram pre if ques == 102, ///
yscale(range(0 0.06)) ///
yline(0.01, lcolor(purple) lwidth(thin)) ///
yline(0.02, lcolor(purple) lwidth(thin)) ///
yline(0.03, lcolor(purple) lwidth(thin)) ///
yline(0.04, lcolor(purple) lwidth(thin)) ///
yline(0.05, lcolor(purple) lwidth(thin)) ///
xtitle(Pre-Treatment Policy Support) ///
ylabel(0(0.01)0.06)

histogram post if ques == 102, ///
yscale(range(0 0.06)) ///
yline(0.01, lcolor(purple) lwidth(thin)) ///
yline(0.02, lcolor(purple) lwidth(thin)) ///
yline(0.03, lcolor(purple) lwidth(thin)) ///
yline(0.04, lcolor(purple) lwidth(thin)) ///
yline(0.05, lcolor(purple) lwidth(thin)) ///
xtitle(Pre-Treatment Policy Support) ///
ylabel(0(0.01)0.06)

***************************************************************************
*** Figure 1: Row 4 Col 1 *** 
***************************************************************************
histogram post if ques == 103, ///
yscale(range(0 0.06)) ///
yline(0.01, lcolor(purple) lwidth(thin)) ///
yline(0.02, lcolor(purple) lwidth(thin)) ///
yline(0.03, lcolor(purple) lwidth(thin)) ///
yline(0.04, lcolor(purple) lwidth(thin)) ///
yline(0.05, lcolor(purple) lwidth(thin)) ///
xtitle(Pre-Treatment Policy Support) ///
ylabel(0(0.01)0.06)
graph export "Post_103.eps", as(eps) preview(off) replace

histogram pre if ques == 103, ///
yscale(range(0 0.06)) ///
yline(0.01, lcolor(purple) lwidth(thin)) ///
yline(0.02, lcolor(purple) lwidth(thin)) ///
yline(0.03, lcolor(purple) lwidth(thin)) ///
yline(0.04, lcolor(purple) lwidth(thin)) ///
yline(0.05, lcolor(purple) lwidth(thin)) ///
xtitle(Pre-Treatment Policy Support) ///
ylabel(0(0.01)0.06)

***************************************************************************
*** Figure 1: Col 2 *** 
***************************************************************************
histogram delta, ///
yscale(range(0 0.06)) ///
yline(0.01, lcolor(purple) lwidth(thin)) ///
yline(0.02, lcolor(purple) lwidth(thin)) ///
yline(0.03, lcolor(purple) lwidth(thin)) ///
yline(0.04, lcolor(purple) lwidth(thin)) ///
yline(0.05, lcolor(purple) lwidth(thin)) ///
xtitle(Post-Treatment - Pre-Treatent Policy Support) ///
ylabel(0(0.01)0.06)

histogram delta if ques == 101, ///
yscale(range(0 0.06)) ///
yline(0.01, lcolor(purple) lwidth(thin)) ///
yline(0.02, lcolor(purple) lwidth(thin)) ///
yline(0.03, lcolor(purple) lwidth(thin)) ///
yline(0.04, lcolor(purple) lwidth(thin)) ///
yline(0.05, lcolor(purple) lwidth(thin)) ///
xtitle(Post-Treatment - Pre-Treatent Policy Support) ///
ylabel(0(0.01)0.06)

histogram delta if ques == 102, ///
yscale(range(0 0.06)) ///
yline(0.01, lcolor(purple) lwidth(thin)) ///
yline(0.02, lcolor(purple) lwidth(thin)) ///
yline(0.03, lcolor(purple) lwidth(thin)) ///
yline(0.04, lcolor(purple) lwidth(thin)) ///
yline(0.05, lcolor(purple) lwidth(thin)) ///
xtitle(Post-Treatment - Pre-Treatent Policy Support) ///
ylabel(0(0.01)0.06)

histogram delta if ques == 103, ///
yscale(range(0 0.06)) ///
yline(0.01, lcolor(purple) lwidth(thin)) ///
yline(0.02, lcolor(purple) lwidth(thin)) ///
yline(0.03, lcolor(purple) lwidth(thin)) ///
yline(0.04, lcolor(purple) lwidth(thin)) ///
yline(0.05, lcolor(purple) lwidth(thin)) ///
xtitle(Post-Treatment - Pre-Treatent Policy Support) ///
ylabel(0(0.01)0.06)

**** Online Appendix 1 (also correlations in footnote 7)  *****

use mturk_followup.dta, clear

// Correlations Between DVs

foreach var of varlist q60 q62 q64 {
gen `var'_x = `var'
}

foreach var of varlist q60_x q62_x q64_x {
recode `var' (5=1) (4=2) (2=4) (1=5)
}

cor q65_1 q60_x // Afghanistan
tabstat q65_1, by(q60_x) 
count if q65_1!=.&q60_x!=.

cor q66_1 q62_x // Free Trade
tabstat q66_1, by(q62_x)
count if q66_1!=.&q62_x!=.

cor q67_1 q64_x // Pub Fin
tabstat q67_1, by(q64_x)
count if q67_1!=.&q64_x!=.

*** Online Appendix 2 ****

sum v61 q57_1 q59_1, detail

*** Information in Footnote 10  ****

reg q65_1 v61

reg q66_1 q57_1

reg q67_1 q59_1

