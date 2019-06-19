******************************************************************
* DESCRIPTIVE STATS FOR GROWTH PAPER
* Figures, Tables 1-5 + figures
******************************************************************
clear 
set mem 50m
set matsize 800
set more off

******************************************************************
* FIG 1
* background 
* Single persaon hhs where person died by W4 
use roster_public,clear
gen died=stat_w1==5|stat_w2==5|stat_w3==5|stat_w4==5
gen memb=stat_w1==1|stat_w2==1|stat_w3==1|stat_w4==1
collapse (sum) died memb, by(cluster hh)
drop if memb==0
list cluster hh died if died==memb 

use khds2_recontact,clear
list result if (cluster==6  & hh==21)|(cluster==18 & hh==11)|(cluster==44 & hh==23)
drop if (cluster==6 & hh==21)|(cluster==18 & hh==11)|(cluster==44 & hh==23)
gen obs=1
gen intv=result==1
gen deceased=result==2
collapse (sum) obs deceased (max) intv , by(cluster hh)
sum
gen cat=1 if intv==1
replace cat=2 if intv==0 & dece==obs 
replace cat=3 if cat==.
label define cat 1 "Recontacted" 2 "Deceased" 3 "Untraced"
label values cat cat
tab cat
sort cluster hh
tempfile cat
save `cat'

use khds2_recontact,clear
drop if (cluster==6  & hh==21)|(cluster==18 & hh==11)|(cluster==44 & hh==23)
keep if result==1
bys hhid2: drop if _n>1
count
tab si2c
tab distr if si2c==3,m
tab region if si2c==4,m

* TABLES 1 & 2
use khds2_recontact,clear
drop if (cluster==6 & hh==21)|(cluster==18 & hh==11)|(cluster==44 & hh==23)

gen agecat=rostage<10
replace agecat=2 if rostage>=10 & rostage<=19
replace agecat=3 if rostage>=20 & rostage<=39
replace agecat=4 if rostage>=40 & rostage<=59
replace agecat=5 if rostage>=60 & rostage<.
label define agecat 1 "<10" 2 "10-19" 3 "20-39" 4 "40-59" 5 "60+"
label values agecat agecat 

* TABLE 1
tab agecat result,row 
tab agecat result if result~=2,row 

* TABLE 2
tab result
tab si2c 
tab where

bys hhid2: drop if _n>1|hhid2==""
tab si2c

***********************************************************
* Table 3 MATCHED INDIVIUDAL LEVEL STATS n=4115
***********************************************************
use growth_data,clear

capture drop mean* sig*
replace si2c=4 if si2c==5 /* combine last 2 categories */
replace foodpc1=. if conspc1==.
replace nfoodpc1=. if conspc1==.
replace foodpc2=. if conspc2==.
replace nfoodpc2=. if conspc2==.

foreach i in pconspc conspc foodpc nfoodpc  {
	sum `i'1 if si2c==1
	gen	  mean`i'1 = r(mean) 	in 1
	sum `i'1 if si2c==2
	replace mean`i'1 = r(mean) 	in 2
	sum `i'1 if si2c==3
	replace mean`i'1 = r(mean) 	in 3
	sum `i'1 if si2c==4
	replace mean`i'1 = r(mean) 	in 4
	sum `i'1
	replace mean`i'1 = r(mean) 	in 5
	*
	sum `i'2 if si2c==1
	gen	 mean`i'2 = r(mean) 	in 1
	sum `i'2 if si2c==2
	replace mean`i'2 = r(mean) 	in 2	
	sum `i'2 if si2c==3
	replace mean`i'2 = r(mean) 	in 3
	sum `i'2 if si2c==4
	replace mean`i'2 = r(mean) 	in 4
	sum `i'2
	replace mean`i'2 = r(mean) 	in 5
	*
	ttest `i'1==`i'2 if si2c==1
	gen 	  sig`i'=r(p_l)	 	in 1
	gen 	  obs`i'=r(N_1)		in 1	
	ttest `i'1==`i'2 if si2c==2
	replace sig`i'=r(p_l)	 	in 2	
	replace obs`i'=r(N_1)	 	in 2	
	ttest `i'1==`i'2 if si2c==3
	replace sig`i'=r(p_l)	 	in 3
	replace obs`i'=r(N_1)	 	in 3
	ttest `i'1==`i'2 if si2c==4
	replace sig`i'=r(p_l)	 	in 4
	replace obs`i'=r(N_1)	 	in 4
	ttest `i'1==`i'2
	replace sig`i'=r(p_l) 		in 5
	replace obs`i'=r(N_1)	 	in 5	
	*
	replace  sig`i' = 1 - sig`i' if sig`i'>.5
	gen str3 star`i' = "ns"   if sig`i' >0.1  & sig`i'~=.
	replace  star`i' = "*"    if sig`i'<=0.1 
	replace  star`i' = "**"   if sig`i'<=0.05
	replace  star`i' = "***"  if sig`i'<=0.01
	* 
	gen mov`i' = _n
}
format mean* %9.2fc
keep in 1/5
stack obspconspc  meanpconspc1  meanpconspc2  starpconspc 	movpconspc 	/*
 */   obsconspc   meanconspc1   meanconspc2   starconspc   	movconspc 	/*
 */ 	obsfoodpc   meanfoodpc1   meanfoodpc2   starfoodpc 	movfoodpc 	/*
 */	obsnfoodpc  meannfoodpc1  meannfoodpc2  starnfoodpc 	movnfoodpc 	/*
 */ 	, into (obs mean1 mean2 star move)
label define cons 1"pconspc" 2"conspc" 3"foodpc" 4"nfoodpc"
label values _stack cons
gen str1 sign = "+"  if mean2>mean1
replace  sign = "-"  if mean2<mean1
replace  sign = "0"  if mean2==mean1
bys _stack: assert move==_n
gen dif = mean2 - mean1
format mean1 mean2 dif %9.2f
bys _stack: list move mean1 mean2 dif star obs
format mean1 mean2 dif %12.2fc
list _stack move mean1 mean2 dif star obs

***********************************************************
* TABLE 4
***********************************************************
use growth_data,clear
for varlist moved1 moved2 moved3: ttest dconspc, by(X)
* chi-sq test in text (no table)
gen dpconspc = pconspc2 - pconspc1
for varlist moved1 moved2 moved3: tab dpconspc X, chi
for varlist moved1 moved2 moved3: ttest dpconspc, by(X)

***********************************************************
* TABLE 5
***********************************************************
for numlist 1/4: ci dconspc if si2c<=X
for numlist 1/4: ci dpconspc if si2c<=X

***********************************************************
* Figure 2 - panel A
preserve
keep  if conspc1<=500000 & conspc2<=500000 
gen conspc1a = conspc1 if (si2c==1)
gen conspc2a = conspc2 if (si2c==1)	
sum conspc1a conspc2a
cumul conspc1a, gen(cdf1993)
cumul conspc2a, gen(cdf2004)
stack cdf1993 conspc1a 	/*
 */   cdf2004 conspc2a	/* 
 */ , into(cdf conspc) wide clear
label var cdf1993 	"1991"
label var cdf2004		"2004"
line cdf1993 cdf2004 conspc, sort xline(109663) title("Panel A: Within Community") saving(fig2a,replace)
restore

* Figure 2 - panel B
preserve
keep  if conspc1<=500000 & conspc2<=500000 
gen conspc1a = conspc1 if (si2c==2)
gen conspc2a = conspc2 if (si2c==2)	
sum conspc1a conspc2a
cumul conspc1a, gen(cdf1993)
cumul conspc2a, gen(cdf2004)
stack cdf1993 conspc1a 	/*
 */   cdf2004 conspc2a	/* 
 */ , into(cdf conspc) wide clear
label var cdf1993 	"1991"
label var cdf2004		"2004"
line cdf1993 cdf2004 conspc, sort  xline(109663) title("Panel B: Nearby Community") saving(fig2b,replace)
restore

* Figure 2 - panel C
preserve
keep  if conspc1<=500000 & conspc2<=500000 
gen conspc1a = conspc1 if (si2c==3)
gen conspc2a = conspc2 if (si2c==3)	
sum conspc1a conspc2a if si2c==3
cumul conspc1a, gen(cdf1993)
cumul conspc2a, gen(cdf2004)
stack cdf1993 conspc1a 	/*
 */   cdf2004 conspc2a	/* 
 */ , into(cdf conspc) wide clear
label var cdf1993 	"1991"
label var cdf2004		"2004"
line cdf1993 cdf2004 conspc, sort  xline(109663) title("Panel C: Elsewhere in Kagera") saving(fig2b,replace)
restore

* Figure 2 - panel D
preserve
keep  if conspc1<=500000 & conspc2<=500000 
gen conspc1a = conspc1 if (si2c==4 | si2c==5)
gen conspc2a = conspc2 if (si2c==4 | si2c==5)	
sum conspc1a conspc2a
cumul conspc1a, gen(cdf1993)
cumul conspc2a, gen(cdf2004)
stack cdf1993 conspc1a 	/*
 */   cdf2004 conspc2a	/* 
 */ , into(cdf conspc) wide clear
label var cdf1993 	"1991"
label var cdf2004		"2004"
line cdf1993 cdf2004 conspc, sort  xline(109663) title("Panel D: Outside Kagera") saving(fig2d,replace)
restore

* Figure 3 - panel A
preserve
keep  if conspc1<=500000 & conspc1<=500000 
gen conspc1a = conspc1 if (si2c==1)
gen conspc1b = conspc1 if (si2c==2)
cumul conspc1a, gen(cdf1993a)
cumul conspc1b, gen(cdf1993b)
stack cdf1993a conspc1a	/*
 */   cdf1993b conspc1b	/* 
 */ , into(cdf conspc) wide clear
label var cdf1993a 	"1991 in village"
label var cdf1993b 	"1991 nearby village"
line cdf1993a cdf1993b conspc, sort  xline(109663) title("Panel A: 1991") saving(fig3a,replace)
restore

* Figure 3 - panel B
preserve
keep  if conspc2<=500000 & conspc2<=500000 
gen conspc2a = conspc2 if (si2c==1)
gen conspc2b = conspc2 if (si2c==2)
cumul conspc2a, gen(cdf2004a)
cumul conspc2b, gen(cdf2004b)
stack cdf2004a conspc2a	/*
 */   cdf2004b conspc2b	/* 
 */ , into(cdf conspc) wide clear
label var cdf2004a 	"2004 in village"
label var cdf2004b 	"2004 nearby village"
line cdf2004a cdf2004b conspc, sort  xline(109663) title("Panel B: 2004") saving(fig3b,replace)
restore

* Figure 4 - panel A
preserve
keep  if conspc1<=500000 & conspc1<=500000 
gen conspc1a = conspc1 if (si2c==1)
gen conspc1b = conspc1 if (si2c==3)
cumul conspc1a, gen(cdf1993a)
cumul conspc1b, gen(cdf1993b)
stack cdf1993a conspc1a	/*
 */   cdf1993b conspc1b	/* 
 */ , into(cdf conspc) wide clear
label var cdf1993a 	"1991 in village"
label var cdf1993b 	"1991 elswhere Kagera"
line cdf1993a cdf1993b conspc, sort  xline(109663) title("Panel A: 1991") saving(fig4a,replace)
restore

* Figure 4 - panel B
preserve
keep  if conspc2<=500000 & conspc2<=500000 
gen conspc2a = conspc2 if (si2c==1)
gen conspc2b = conspc2 if (si2c==3)
cumul conspc2a, gen(cdf2004a)
cumul conspc2b, gen(cdf2004b)
stack cdf2004a conspc2a	/*
 */   cdf2004b conspc2b	/* 
 */ , into(cdf conspc) wide clear
label var cdf2004a 	"2004 in village"
label var cdf2004b 	"2004 elsewhere Kagera"
line cdf2004a cdf2004b conspc, sort  xline(109663)  title("Panel B: 2004") saving(fig4b,replace)

restore

* Figure 5 - panel A
preserve
keep  if conspc1<=500000 & conspc1<=500000 
gen conspc1a = conspc1 if (si2c==1)
gen conspc1b = conspc1 if (si2c==4 | si2c==5)
cumul conspc1a, gen(cdf1993a)
cumul conspc1b, gen(cdf1993b)
stack cdf1993a conspc1a	/*
 */   cdf1993b conspc1b	/* 
 */ , into(cdf conspc) wide clear
label var cdf1993a 	"1991 in village"
label var cdf1993b 	"1991 outside Kagera"
line cdf1993a cdf1993b conspc, sort  xline(109663) title("Panel A: 1991") saving(fig5a,replace)
restore

* Figure 5 - panel B
preserve
keep  if conspc2<=500000 & conspc2<=500000 
gen conspc2a = conspc2 if (si2c==1)
gen conspc2b = conspc2 if (si2c==4 | si2c==5)
cumul conspc2a, gen(cdf2004a)
cumul conspc2b, gen(cdf2004b)
stack cdf2004a conspc2a	/*
 */   cdf2004b conspc2b	/* 
 */ , into(cdf conspc) wide clear
label var cdf2004a 	"2004 in village"
label var cdf2004b 	"2004 outside Kagera"
line cdf2004a cdf2004b conspc, sort  xline(109663) title("Panel B: 2004") saving(fig5b,replace)
restore









