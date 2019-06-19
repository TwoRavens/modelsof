* PROGRAM: PREPARE_DATA.DO
*
* This program prepares datasets to be used in all subsequent analyses
*
* Program written for Flores, Carlos A. and Oscar A. Mitnik (2013). 
* "Comparing Treatments across Labor Markets: An Assessment of Nonexperimental 
* Multiple-Treatment Strategies", Review of Economics and Statistics, 
* December 2013, Vol. 95, No. 5, Pages 1691-1707.
*
* This version:  November 2010
*

version 11
clear all
set more off
set mem 250m


* Fill in here information on directories (if desired)
local pgsdir 	""	// Directory with all the programs
local datadir ""	// Directory with the NEWWS data
local lecdir 	""	// Directory with Local Economic Conditions data
local savedir ""	// Directory where analysis file will be saved


capture log close
log using "`pgsdir'prepare_data.log", replace

use "`datadir'newws_5yr", clear

***** MERGE IN LOCAL ECONOMIC CONDITIONS (LEC) DATA *****
sort alphsite radatp
merge alphsite radatp using "`lecdir'lec_data_msa_us_wide.dta"
keep if _merge==3
drop _merge


***** CREATE VARIABLES TO USE

* Gen dummies for whether received welfare in quarter x before random assignment
gen afdcpq1=adcpc1>0 
gen afdcpq2=adcpc2>0 
gen afdcpq3=adcpc3>0 
gen afdcpq4=adcpc4>0 
gen afdcpq5=adcpc5>0 
gen afdcpq6=adcpc6>0 
gen afdcpq7=adcpc7>0 

label variable afdcpq1 "Received Welfare in Q1 before RA" 
label variable afdcpq2 "Received Welfare in Q2 before RA" 
label variable afdcpq3 "Received Welfare in Q3 before RA" 
label variable afdcpq4 "Received Welfare in Q4 before RA" 
label variable afdcpq5 "Received Welfare in Q5 before RA" 
label variable afdcpq6 "Received Welfare in Q6 before RA" 
label variable afdcpq7 "Received Welfare in Q7 before RA" 


* Gen dummies for whether received food stamps in quarter x before random assignment
gen fspq1=fspc1>0 
gen fspq2=fspc2>0 
gen fspq3=fspc3>0 
gen fspq4=fspc4>0 
gen fspq5=fspc5>0 
gen fspq6=fspc6>0 
gen fspq7=fspc7>0 

label variable fspq1 "Received Food Stamps in Q1 before RA"
label variable fspq2 "Received Food Stamps in Q2 before RA"
label variable fspq3 "Received Food Stamps in Q3 before RA"
label variable fspq4 "Received Food Stamps in Q4 before RA"
label variable fspq5 "Received Food Stamps in Q5 before RA"
label variable fspq6 "Received Food Stamps in Q6 before RA"
label variable fspq7 "Received Food Stamps in Q7 before RA"


* Gen dummies for whether employed in quarter x before RA. Quarters 1-4 already created
gen emppq5=pearn5>0 
gen emppq6=pearn6>0 
gen emppq7=pearn7>0 
gen emppq8=pearn8>0 

label variable emppq5 "Employed in pre-RA Qrtr 5"
label variable emppq6 "Employed in pre-RA Qrtr 6"
label variable emppq7 "Employed in pre-RA Qrtr 7"
label variable emppq8 "Employed in pre-RA Qrtr 8"

* Gen yearly earnings and employment
egen pearn_y1=rowtotal(pearn1 pearn2 pearn3 pearn4)
egen pearn_y2=rowtotal(pearn5 pearn6 pearn7 pearn8)
egen emp_py1=rowtotal(emppq1 emppq2 emppq3 emppq4)
egen emp_py2=rowtotal(emppq5 emppq6 emppq7 emppq8)

label variable pearn_y1 "Earnings Q1-Q4 pre-RA"
label variable pearn_y2 "Earnings Q5-Q8 pre-RA"
label variable emp_py1  "# Qtrs Employed Q1-Q4 pre-RA"
label variable emp_py2  "# Qtrs Employed Q5-Q8 pre-RA"

* Gen real earnings /$1,000 in quarters prior to RA ($ 1999 - national CPI) 
gen r_pearn1 = pearn1 /1000 * 166.6 / cpi_1
gen r_pearn2 = pearn2 /1000 * 166.6 / cpi_1
gen r_pearn3 = pearn3 /1000 * 166.6 / cpi_1
gen r_pearn4 = pearn4 /1000 * 166.6 / cpi_1
gen r_pearn5 = pearn5 /1000 * 166.6 / cpi_2
gen r_pearn6 = pearn6 /1000 * 166.6 / cpi_2
gen r_pearn7 = pearn7 /1000 * 166.6 / cpi_2
gen r_pearn8 = pearn8 /1000 * 166.6 / cpi_2
* Sum of real earnings in Q1-Q8 pre RA
gen r_pearn_q1_q8=(r_pearn1+r_pearn2+r_pearn3+r_pearn4+r_pearn5+r_pearn6+r_pearn7+r_pearn8)

* Gen real earnings /$1,000 in 2 years afte RA ($ 1999 - national CPI)  (OUTCOME)
gen r_earnq2t9 = earnq2t9 /1000 * 166.6 / cpi_1

* For LEC adjustment
* Dependent variables in periods t-1 and t-2
* Employment indicators
gen emp_1 = emp_py1>0
gen emp_2 = emp_py2>0
* Employed all four quaters
gen emp4qtrs_1 = emp_py1==4
gen emp4qtrs_2 = emp_py2==4

* Gen dummy for whether the observation has NO missing values of the covariates used
gen nomissx=sexm==0 & maritalm==0 & agem==0 & jchldm==0 & ethnicm==0 & oadcm==0 & degrm == 0 & gradem == 0 & bernm==0 & currhrm==0 & housm==0 & movem==0 & wrkftm==0
label variable nomissx "No missing values of the covariates"

* Gen random assignment dummies
gen ra92=radatp==1992
gen ra93=radatp==1993
gen ra94=radatp==1994
label variable ra92 "RA in 1992"
label variable ra93 "RA in 1993"
label variable ra94 "RA in 1994"

** Generate number of quarters employed 2 years before random assignment
egen pkemp_q1q8=rowtotal(emppq1 emppq2 emppq3 emppq4 emppq5 emppq6 emppq7 emppq8)
label variable pkemp_q1q8 "Number qrts employed 2 years previous to RA"

** Generate ever employed in 2 years before random assignment
gen pvemp_q1q8=(pkemp_q1q8>0)
label variable pvemp_q1q8 "Ever employed 2 years previous to RA"

***** RESTRICT SAMPLE TO ONLY FEMALES CONTROLS WITH NO MISSING VALUES IN THE COVARIATES AND SUBJECT TO SHORT 
***** AND LONG TERM EMBARGO (AT LEAST 3 YEARS)

tab female nomissx, missing
keep if female == 1 & nomissx == 1 & c2 == 1 & (inemblt4 == 1 | inemb4t5 == 1) 

* All counties
tab alphsite

***** Also drop Columbus and Oklahoma
drop if columbus == 1 | oklahoma == 1
tab alphsite


******** ----- DEFINE DIFFERENCE IN OUTCOMES---- 
* Adds "grand mean" so the DID outcomes have the same mean as level outcomes
egen m_pvemp_q1q8=mean(pvemp_q1q8)

*Differences for outcome ever employed in quarters 2 to 9 after RA (years 1 and 2 after RA)
gen dvempq2t9=vempq2t9-pvemp_q1q8+m_pvemp_q1q8


* Creates some LEC-related variables

* Growth rates of unemployment rate
gen unemp_rateg_1 = log(unemp_rate_1) - log(unemp_rate_2)
gen unemp_rateg0 = log(unemp_rate0) - log(unemp_rate_1)
gen unemp_rateg1 = log(unemp_rate1) - log(unemp_rate0)
gen unemp_rateg2 = log(unemp_rate2) - log(unemp_rate1)
gen unemp_rateg3 = log(unemp_rate3) - log(unemp_rate2)
gen unemp_rateg4 = log(unemp_rate4) - log(unemp_rate3)
gen unemp_rateg5 = log(unemp_rate5) - log(unemp_rate4)
* Two-year growth rate
gen unemp_rateg0_2 = log(unemp_rate0) - log(unemp_rate_2)
gen unemp_rateg2_0 = log(unemp_rate2) - log(unemp_rate0)

* Growth rates of employment/population ratio
gen tot_emp_popg_1 = log(tot_emp_pop_1) - log(tot_emp_pop_2)
gen tot_emp_popg0 = log(tot_emp_pop0) - log(tot_emp_pop_1)
gen tot_emp_popg1 = log(tot_emp_pop1) - log(tot_emp_pop0)
gen tot_emp_popg2 = log(tot_emp_pop2) - log(tot_emp_pop1)
gen tot_emp_popg3 = log(tot_emp_pop3) - log(tot_emp_pop2)
gen tot_emp_popg4 = log(tot_emp_pop4) - log(tot_emp_pop3)
gen tot_emp_popg5 = log(tot_emp_pop5) - log(tot_emp_pop4)
* Two-year growth rate
gen tot_emp_popg0_2 = log(tot_emp_pop0) - log(tot_emp_pop_2)
gen tot_emp_popg2_0 = log(tot_emp_pop2) - log(tot_emp_pop0)

* Growth rates of real total average earninngs
gen avg_tot_rerng_1 = log(avg_tot_rern_1) - log(avg_tot_rern_2)
gen avg_tot_rerng0 = log(avg_tot_rern0) - log(avg_tot_rern_1)
gen avg_tot_rerng1 = log(avg_tot_rern1) - log(avg_tot_rern0)
gen avg_tot_rerng2 = log(avg_tot_rern2) - log(avg_tot_rern1)
gen avg_tot_rerng3 = log(avg_tot_rern3) - log(avg_tot_rern2)
gen avg_tot_rerng4 = log(avg_tot_rern4) - log(avg_tot_rern3)
gen avg_tot_rerng5 = log(avg_tot_rern5) - log(avg_tot_rern4)
* Two-year growth rate
gen avg_tot_rerng0_2 = log(avg_tot_rern0) - log(avg_tot_rern_2)
gen avg_tot_rerng2_0 = log(avg_tot_rern2) - log(avg_tot_rern0)
 
 
* Extra Dummies (based on other variables)
* Dummy never in welfare in Q1-Q7 prior to RA
gen nowelf_pq1_pq7=(afdcpq1+afdcpq2+afdcpq3+afdcpq4+afdcpq5+afdcpq6+afdcpq7)==0
* Dummy never received food stamps in Q1-Q7 prior to RA
gen nofs_pq1_pq7=(fspq1+fspq2+fspq3+fspq4+fspq5+fspq6+fspq7)==0
* Dummy never employed in Q1-Q8 prior to RA
gen noemp_pq1_pq8=(emppq1+emppq2+emppq3+emppq4+emppq5+emppq6+emppq7+emppq8)==0


* Interactions and higher order terms
* squares and cubes
foreach x of varlist r_pearn1 r_pearn2 r_pearn3 r_pearn4  r_pearn5 r_pearn6 r_pearn7 r_pearn8 r_pearn_q1_q8 {
	gen `x'_2=`x'^2
	gen `x'_3=`x'^3
}

* Interactions
foreach x of varlist black nevmar chld0t5 gradge12 hsged pshous movesge3 oadclt2y {
	foreach y of varlist  nowelf_pq1_pq7 nofs_pq1_pq7 r_pearn_q1_q8 r_pearn_q1_q8_2 r_pearn_q1_q8_3 {
		gen `x'_`y' = `x' * `y'
	}
}

foreach x of varlist black age30t39 agege40 birth19u nevmar chld0t5 chld6t12 twochild thrchild grade10 grade11 gradge12 hsged pshous moves1t2 movesge3 oadclt2y oadc2t5y oadc5t10 afdcpq1 afdcpq2 afdcpq3 afdcpq4 afdcpq5 afdcpq6 afdcpq7 fspq1 fspq2 fspq3 fspq4 fspq5 fspq6 fspq7  emppq5 emppq6 emppq7 emppq8 curemp wrkft6mo r_pearn5 r_pearn6 r_pearn7 r_pearn8  emppq1 emppq2 emppq3 emppq4  r_pearn1 r_pearn2 r_pearn3 r_pearn4 bernv  {
	foreach y of varlist  noemp_pq1_pq8 {
		gen `x'_`y' = `x' * `y'
	}
}

* To run LEC adjustments on levels and diff-in-diff models with two-year averages
* Log of LEC variables in each year prior to RA (to run LEC adjustment regressions)
foreach v in unemp_rate tot_emp_pop avg_tot_rern {
	foreach p in _2 _1 1 2 {
		gen l`v'`p'=log(`v'`p')
		gen l`v'_sq`p'=l`v'`p'^2
	}
	* Two-year averages
	gen l`v'12 = (l`v'1 + l`v'2) /2
	gen l`v'_1_2 = (l`v'_1 + l`v'_2) /2
	
	* Two-year averages of squares
	gen l`v'_sq12 = (l`v'_sq1 + l`v'_sq2) /2
	gen l`v'_sq_1_2 = (l`v'_sq_1 + l`v'_sq_2) /2
	
	* For DID model calculate "DID" LECs
	* One year
	gen l`v'1_1 = l`v'1 - l`v'_1
	gen l`v'_sq1_1 = l`v'_sq1 - l`v'_sq_1
	gen l`v'2_2 = l`v'2 - l`v'_2
	gen l`v'_sq2_2 = l`v'_sq2 - l`v'_sq_2
	* Two-year averages
	gen l`v'12_1_2 = l`v'12 - l`v'_1_2
	gen l`v'_sq12_1_2 = l`v'_sq12 - l`v'_sq_1_2
}

**** SAVE "ANALYSIS FILE" *****
compress
sort idnumber
save "`savedir'analysis.dta", replace

******************************************************************
*	Benchmark file creation
*
* This file allows generating the placebo experiment (benchmark) 
* results
******************************************************************

* Defines for each site (of the 5 we keep) the number of treatments per site, 
* and creates variable treat which assigns value 0 to control group, 
* value 1 to treatment 1, and value 2 to treatment 2 (when applicable)
gen ntreats=3 if alphsite==1 | alphsite==4 | alphsite==7
replace ntreats=2 if alphsite==3 | alphsite==6
gen treat=0 if c2==1
replace treat=1 if j==1 | p==1
replace treat=2 if b==1

* Creates "fake" alphsite to run benchmark results (only for control individuals)
set seed 1000
gen u=uniform() if c2==1
sort u
drop u
qui tab alphsite if c2==1, matcell(tab_alphsite) matrow(val_alphsite)
gen fake_alphsite=0 if c2==1
local initial "0"
local ending "0"
mat list tab_alphsite
foreach r of num 1/5 {
	local value=val_alphsite[`r',1]
	local initial=`ending'+1
	local step = tab_alphsite[`r',1]
	local ending=`initial'+`step'-1
	di "initial = `initial', step `step' & ending = `ending'"
	replace fake_alphsite=`value' in `initial'/`ending'
}

**** SAVE "BENCHMARK ANALYSIS FILE" *****
compress
sort idnumber
save "`savedir'benchmark_analysis.dta", replace

log close
