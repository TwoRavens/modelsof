***********************************************************************************
*** Replication file for Hawks, Doves, and Opportunistic Opposition Parties
***
*** NOTE: In order to create all the necessary files for replication, do the steps in order!
***
*** Created: 8-5-13
***********************************************************************************

***********************************************************************************
********************************* STEP 1 ******************************************
********************** Establish the working directory and load the data **********
***********************************************************************************

* Establish the working directory with the "cd" command.
* cd 

* Open the data.
use "Opportunistic Opposition Parties.dta", clear

***********************************************************************************
********************************* STEP 2 ******************************************
****************** Run the user-created programs for substantive effects **********
***********************************************************************************

*** Figure for Model 2
capture program drop m2
program define m2

mat b = e(b)
local k = colsof(b)

*****
generate plo = .
generate phi = .
generate pr = .
generate vectaxis = .
recast float vectaxis  
local a= -60
local b=1						
while `a' <= 60 {
	setx mean
	setx  inv_force 1 rile `a' invfo_rile `a'  
              
	simqi, prval(1) genpr(prob)
	qui sum prob, meanonly
	local mn = r(mean)
	replace pr = `mn' in `b'
	_pctile prob, p(5.0,95.0)
	display `a'
	replace plo = r(r1) in `b'
	replace phi = r(r2) in `b'
	replace vectaxis = `a' in `b'      
	local a = `a' + 10
	local b=`b' + 1   
	drop prob
}

sort vectaxis

twoway (line pr vectaxis) (line plo vectaxis, clpattern(dash) sort) (line phi vectaxis, clpattern(dash) sort), /*
*/	xtitle("Left														Right ""Opposition Party Partisanship") ytitle("Pr(NCM)", orientation(horizontal)) legend(off) scheme(s1mono)

preserve
	keep vectaxis plo phi pr
	drop if vectaxis==.
	sort vectaxis
	outsheet using prm2.csv, comma replace
restore

qui sum phi if vectaxis == -50
local hi1 = r(mean)
qui sum plo if vectaxis == 50
local lo1 = r(mean)

di as result _newline(1) "CI at -50 is statistically different from: "
tab vectaxis if plo > `hi1'
di as result _newline(1) "CI at +50 is statistically different from: "
tab vectaxis if phi < `lo1'

drop plo phi vectaxis pr
drop b1-b`k'
end

*** Figure for Model 3
capture program drop m3
program define m3

mat b = e(b)
local k = colsof(b)

*****
generate plo_l = .
generate phi_l = .
generate plo_r = .
generate phi_r = .
generate pr_l = .
generate pr_r = .
generate vectaxis = .
recast float vectaxis  
local a= -50	
local b=1						
while `a' <= 50 { 
	setx mean
	setx  left 1 inv_force 1 gov_rile `a' left_gov_rile `a' left_invfo 1 invfo_grile `a' left_three_invfo `a'  

	simqi, prval(1) genpr(prob_l)
	qui sum prob_l, meanonly
	local mn_l = r(mean)
	replace pr_l = `mn_l' in `b'
	
	_pctile prob_l, p(2.5,97.5)	
	display `a'
	replace plo_l = r(r1) in `b'
	replace phi_l = r(r2) in `b' 
		
	setx mean
	setx  left 0 inv_force 1 gov_rile `a' left_gov_rile 0 left_invfo 0 invfo_grile `a' left_three_invfo 0  
	
	simqi, prval(1) genpr(prob_r)
	qui sum prob_r, meanonly
	local mn_r = r(mean)
	replace pr_r = `mn_r' in `b'
		
	_pctile prob_r, p(2.5,97.5)
	display `a'
	replace plo_r = r(r1) in `b' 
	replace phi_r = r(r2) in `b'  
	replace vectaxis = `a' in `b'      
	local a = `a' + 5               
	local b=`b' + 1                
	drop prob_l prob_r
}

sort vectaxis
twoway (rcap plo_l phi_l vectaxis, bcolor(blue) msize(large) lwidth(thick)) (rcap plo_r phi_r vectaxis, bcolor(red) lwidth(medium)),/*
*/	xtitle("Left														Right ""Government Partisanship") ytitle("Pr(NCM)", orientation(horizontal)) /*
*/	legend( label(1 "Left Opposition") label(2 "Center/Right Opposition") col(1)) scheme(s1mono)

preserve
	keep vectaxis plo_l phi_l pr_l plo_r phi_r pr_r
	drop if vectaxis==.
	sort vectaxis
	outsheet using prm3.csv, comma replace
restore

qui sum phi_l if vectaxis == -50
local hi_l = r(mean)

qui sum phi_r if vectaxis == 50
local hi_r = r(mean)

di as result _newline(1) "Left: CI at -50 is statistically different from: "
tab vectaxis if plo_l > `hi_l'
di as result _newline(1) "Right: CI at +50 is statistically different from: "
tab vectaxis if plo_r > `hi_r'

drop plo_l plo_r phi_l phi_r pr_l pr_r vectaxis
drop b1-b`k'
end

***********************************************************************************
********************************* STEP 3 ******************************************
****************** Replicate Models 1-3 in the manuscript  ************************
***********************************************************************************

*** Model 1
logit ncm_2_dummy inv_force perc niche majority sd_rile ts_govtq rgdppc_growth ciepq no_ncm_2 ts_ncm_2 if inv_force_sample==1, robust cluster(ccode)

*** Model 2
logit ncm_2_dummy inv_force rile invfo_rile perc niche majority sd_rile ts_govtq rgdppc_growth ciepq no_ncm_2 ts_ncm_2 if inv_force_sample==1, robust cluster(ccode)
estsimp logit ncm_2_dummy inv_force rile invfo_rile perc niche majority sd_rile ts_govtq rgdppc_growth ciepq no_ncm_2 ts_ncm_2 if inv_force_sample==1, robust cluster(ccode)
m2

*** Model 3
logit ncm_2_dummy inv_force left gov_rile left_invfo invfo_grile left_gov_rile left_three_invfo perc niche majority sd_rile ts_govtq rgdppc_growth ciepq no_ncm_2 ts_ncm_2 if inv_force_sample==1, robust cluster(ccode)
foreach i of numlist -50(10)50 {
	di as result _newline(2) "Following test is when govt partisanship = " `i'
	testnl ([ncm_2_dummy]inv_force + (0 * [ncm_2_dummy]left_invfo) + (`i' * [ncm_2_dummy]invfo_grile) + (0 * `i' * [ncm_2_dummy]left_three_invfo)) = ([ncm_2_dummy]inv_force + (1 * [ncm_2_dummy]left_invfo) + (`i' * [ncm_2_dummy]invfo_grile) + (1 * `i' * [ncm_2_dummy]left_three_invfo))
	
	di as result _newline(2) "Marginal effect of MID for center/right opposition parties when govt partisanship = " `i'
	lincom ([ncm_2_dummy]inv_force + (0 * [ncm_2_dummy]left_invfo) + (`i' * [ncm_2_dummy]invfo_grile) + (0 * `i' * [ncm_2_dummy]left_three_invfo)) 

	di as result _newline(2) "Marginal effect of MID for left opposition parties when govt partisanship = " `i'	
	lincom ([ncm_2_dummy]inv_force + (1 * [ncm_2_dummy]left_invfo) + (`i' * [ncm_2_dummy]invfo_grile) + (1 * `i' * [ncm_2_dummy]left_three_invfo))
}

estsimp logit ncm_2_dummy inv_force left gov_rile left_invfo invfo_grile left_gov_rile left_three_invfo perc niche majority sd_rile ts_govtq rgdppc_growth ciepq no_ncm_2 ts_ncm_2 if inv_force_sample==1, robust 
m3



***********************************************************************************
********************************* STEP 4 ******************************************
****************** Descriptive statistics and sample ******************************
***********************************************************************************
qui logit ncm_2_dummy inv_force perc niche majority sd_rile ts_govtq rgdppc_growth ciepq no_ncm_2 ts_ncm_2 if inv_force_sample==1, robust cluster(ccode)
bys countryname: tab ncm_2_dummy if e(sample)
bys countryname: tab inv_force if e(sample)
sum sd_rile perc rile gov_rile ciepq ts_govtq rgdppc_growth no_ncm_2 ts_ncm_2 majority left niche if e(sample)
tab majority if e(sample)
tab niche if e(sample)
tab left if e(sample)
tab inv_force if e(sample)
sum inv_force if e(sample)
preserve
	keep if e(sample)
	collapse (min) min_ts = ts (max) max_ts = ts, by(countryname)
	list countryname min_ts max_ts
restore

preserve
	keep if e(sample)
	collapse (max) inv_force, by(ccode ts)
	list if inv_force >=1
restore

hist gov_rile if e(sample), percent bin(27) scheme(s1mono) xtitle("Left																Right""Government Partisanship")
tab gov_rile if e(sample)

preserve
	keep if e(sample)
	tab ncm_2_dummy if left == 0
	tab ncm_2_dummy if left == 1
restore

preserve
	keep if e(sample)
	hist gov_rile if ncm_2_dummy > 0 & left == 0, percent xtitle("Government Partisanship") scheme(s1mono)
	hist gov_rile if ncm_2_dummy > 0 & left == 1, percent xtitle("Government Partisanship") scheme(s1mono)
	bys left: tab gov_rile if ncm_2_dummy > 0
	tab gov_rile if ncm_2_dummy > 0 & gov_rile < 0
	tab gov_rile if ncm_2_dummy > 0 & gov_rile > 0
restore

