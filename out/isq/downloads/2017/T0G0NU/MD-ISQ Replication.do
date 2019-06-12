clear
clear matrix
set mem 1000m

/*	**********************************************************************		*/
/*	File Name: MD-ISQ Replication.do											*/
/*	Date:	May 10, 2015														*/
/*	Author: Geoff Dancy	and Veronica Michel										*/
/*	Purpose: This file presents all of the code necessary to replication 	 	*/
/*	findings from "Human Rights Enforcement from Below", accepted to ISQ		*/
/*	Input File #1: pros_acc.dta (Prosecutions and Accusations raw file)			*/
/*	Version: Stata 12 or above													*/
/*	**********************************************************************		*/

/*	**********************************************************************		*/
/*	Instructions for New Users: 												*/
/*	Hi User, a couple of notes here: First, the file begins by producing 		*/
/* 	descriptives for the text of the article. Each of the lines of code that 	*/
/*	produces a stat line has an asterisk line explaining what it does. Second,	*/
/*	the file moves into series of steps to reproduce the findings, including an */
/*	imputation procedure, multiple imputation negative binomial regressions, and */
/*	steps to recreate figures 													*/
/*	**********************************************************************		*/	

/*	**********************************************************************		*/
/*	Input files needed: pros_acc.dta; MD-ISQ 									*/
	**********************************************************************		
		


////////////////////////////////////////////////////////////////////////////////////////////////////
//// DESCRIPTIVE CHARTS AND TABLES FOR MAIN TEXT
////////////////////////////////////////////////////////////////////////////////////////////////////


**************************************************************
***Stat 1 Counting Trials by region and by country
***Replicates 55% stat on page 6 using full TJRC dataset of trials. 

use "pros_acc.dta", clear
keep if trialcourttype==1
keep if state==1

gen region=0
replace region=1 if ccode<200
replace region=2 if (ccode>=200 & ccode<400)
replace region=3 if (ccode>=400 & ccode<600)
replace region=4 if (ccode>=600 & ccode<700)
replace region=5 if (ccode>=700)

gen accused=1
collapse (sum) accused (max) ccode region, by(trialid)
gen trialcount=1
collapse (sum) trialcount accused (max) region, by(ccode)
tabulate region

*After collapse, divide number of trials in regions 1 and 2 by total number
collapse (sum) trialcount accused, by(region)




**************************************************************
***Stat 2: Collapsing information by trial instead of accused

use "pros_acc.dta", clear

keep if trialcourttype==1
keep if state==1
gen amer=0
replace amer=1 if ccode<200
gen euro=0
replace euro=1 if (ccode>=200 & ccode<400)
keep if (amer==1 | euro==1)

collapse (max) ccode amer euro evguilty crimeperiod lowhighrank trialplaintiff, by(trialid)
gen n=1

**Tabulating crime period
drop if (crimeperiod==99)
tabstat n, stat(sum)

**Tabulating type of plaintiff
*Replicates stat line on pg. 13 (999 of 2244)
drop if trialplaintiff==99
tabstat n, stat(sum)



**************************************************************
** Stat 3: Tabulating table of plaintiff type by crime period

gen private=0
replace private=1 if (trialplaintiff==2 | trialplaintiff==3 | trialplaintiff==5)
gen statep=0
replace statep=1 if trialplaintiff==1
gen prosecutor=0
replace prosecutor=1 if statep==1
replace prosecutor=2 if private==1

keep if (ccode==160 | ccode==145 | ccode==140 | ccode==155 | ///
ccode==100 | ccode==130 | ccode==92 | ccode==90 | ccode==91 | ///
ccode==70 | ccode==93 | ccode==95 | ccode==150 | ccode==135 | ///
ccode==165 | ccode==101 | ccode==94 | ccode==305 | ccode==211 | ///
ccode==355 | ccode==390 | ccode==220 | ccode==255 | ccode==260 | ///
ccode==350 | ccode==310 | ccode==325 | ccode==210 | ccode==385 | ///
ccode==290 | ccode==235 | ccode==360 | ccode==365 | ccode==230 | ///
ccode==380 | ccode==225)

recode crimeperiod (2=1) (3=2) (4=3) (5=3)

***Numbers used to create Table 1, pg 15
tabulate prosecutor crimeperiod

***Recreates numbers for Table 2, pg. 18
replace lowhighrank=99 if lowhighrank==.
tabulate prosecutor lowhighrank



**************************************************************
**Figure 1: 
*Type of Prosecutor by year

use "pros_acc.dta", clear

drop if trialplaintiff==99
gen private=0
replace private=1 if (trialplaintiff==2 | trialplaintiff==3 | trialplaintiff==5)
gen statep=0
replace statep=1 if trialplaintiff==1
gen prosecutor=0
replace prosecutor=1 if statep==1
replace prosecutor=2 if private==1
replace verdict=99 if verdict==.

collapse (sum) statep private, by(yearstart)





////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//// MULTIVARIATE ANALYSES AND FIGURES
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

cd "/Users/Geoff/Documents/Green Wave PSCI/14 - Spring/LSA/Data"
use "MD-ISQ", clear

*Replicating Stat line on page 14
gen pp=0
replace pp=1 if (autopp==1 | auxpp==1)
tabulate pp
*842 of 1436 obs are pp==1

*Histograms for supplementary file
histogram allpros, discrete freq
histogram allpros_everguilt, discrete freq

*Variable lags and transformations
gen trialbin=0
replace trialbin=1 if (allpros>=1 & allpros<.)
gen pp_pmauto=pp*pm_auto
gen lsji100=100*lsji
rename ptsimpute_l1 ptsi
sort ccode year
gen psus=allpros
by ccode: replace psus=sum(psus) if psus!=.
by ccode: gen polity2_l1=polity2[_n-1]
by ccode: gen polity2_d=polity2-polity2_l1
by ccode: gen cfhr_l1=cfhr[_n-1]

*Variable labels
label variable allpros "Initiated Human Rights Prosecutions" 
label variable allpros_everguilt "Guilty Verdicts" 
label variable polity2 "Level of Democracy" 
label variable cpc "CPC Reform" 
label variable pp "Private Prosecution" 
label variable autopp "Autonomous PP" 
label variable auxpp "Auxillary PP" 
label variable pm_exe "Executive PM" 
label variable pm_auto "Autonomous PM" 
label variable pm_jud "MP in Judiciary" 
label variable ji_keith "Judicial Independence" 
label variable lsji "Judicial Independence"
label variable lsji100 "Judicial Independence"
label variable ptsi "Repression (t-1)"
label variable cfhr_l1 "HR Protection"
label variable loggdp "GDP per cap (ln)" 
label variable growthper "GDP Growth"
label variable decade "World Time (Decade)"
label variable pp_pmauto "PP x Autonomous PM"
label variable ingo "Int'l NGO"
label variable hrfilled "HR NGO"
label define decade 0 "1970s" 1 "1980s" 2 "1990s" 3 "2000s"
label values decade decade
label define five 0 "70-74" 1 "75-79" 2 "80-84" 3 "85-89" 4 "90-94" 5 "95-99" 6 "00-04" 7 "05-10"
label values five five
label variable five "World Time"
label variable polity2_d "Democratic Change"
label variable psus "Previous Prosecutions"
label variable momentum "Momentum" 

****************
**Imputation
*****************
mi set mlong
mi register imputed ji_keith lsji100 ptsi ingo hrfilled
mi register regular year allpros allpros_everguilt polity2 polity2_d ///
	cpc autopp auxpp pm_exe pm_auto pm_jud loggdp cfhr_l1 growthper ///
	decade five pp momentum
mi stset, clear
mi impute chained (regress) ji_keith ptsi ingo hrfilled lsji100 = ///
	year polity2 loggdp cfhr growthper, add(20) force

*Remake variables
mi passive: by ccode (year): gen pp_hrngo=pp*hrfilled
mi passive: by ccode (year): gen year_ptsi=year*ptsi
mi passive: by ccode (year): gen year_cfhr=year*cfhr_l1
mi passive: by ccode (year): gen pp_polity2d=pp*polity2_d
mi passive: by ccode (year): gen pp_lsji=pp*lsji100
mi passive: by ccode (year): gen pp_auto=pp*pm_auto
mi passive: by ccode (year):gen hirepress=0
	replace hirepress=1 if cfhr_l1<=-.95
replace hrfilled=0 if hrfilled<0

*Table of variable summaries for Supplementary file
estpost summarize allpros allpros_everguilt psus polity2 polity2_d ///
	pp pm_auto lsji100 cfhr_l1 growthper five hrfilled momentum hirepress

	esttab using "summarytable.csv", cells("mean sd min max") replace

**************************************
*Multiple imputation Models
**************************************
mi estimate, dots post: nbreg allpros pp pm_auto hrfilled lsji100 growthper polity2 polity2_d cfhr_l1 five, cluster(ccode)
	estimates store m2
mi estimate, dots post: nbreg allpros_everguilt psus pp pm_auto hrfilled lsji100 growthper polity2 polity2_d cfhr_l1 five, cluster(ccode)
	estimates store m4
	
	**Output for Latex
	*Reminder: Divide p values for one-tailed test by two (manually)
		esttab m2 m4 using T1.tex, replace ///
		label ///
		cells(b(fmt(a3) star) se(par fmt(a3))) ///
		se scalars(N N_g) ///
		star(* 0.10 ** 0.05 *** 0.01) ///
		note(***p\sym{<}.01  **p\sym{<}.05. All independent variables lagged one year.)	///
		nonumbers 

**************************************
**FIGURE 2
**************************************
collapse (mean) ji_keith ptsi ingo hrfilled allpros allpros_everguilt psus five ///
	polity2 polity2_d cpc autopp auxpp pm_exe pm_auto pm_jud loggdp cfhr_l1 growthper ///
	pp lsji100 decade momentum, by (ccode year country)
	
	by ccode : gen hrfilled10=hrfilled/10
	by ccode : gen l_lsji100=log(lsji100)
	by ccode : gen l_growth=log(growthper)
	by ccode : gen psus10=psus/10
	gen hirepress=0
	replace hirepress=1 if cfhr_l1<=-.95
	
	*relabel
	label variable allpros "Initiated Human Rights Prosecutions" 
	label variable allpros_everguilt "Guilty Verdicts" 
	label variable polity2_d "Democratic Change" 
	label variable pp "Private Prosecution" 
	label variable pm_auto "Autonomous PM" 
	label variable l_lsji100 "Judicial Independence"
	label variable lsji100 "Judicial Independence"
	label variable cfhr "HR Protection"
	label variable loggdp "GDP per cap (ln)" 
	label variable growthper "GDP Growth"
	label variable decade "World Time (Decade)"
	label variable ingo "Int'l NGO"
	label variable hrfilled10 "HRNGOs"
	label values decade decade
	label values five five
	label variable five "World Time"
	label variable psus10 "Previous Prosecutions"
	label variable polity2 "Level of Democracy"
	

*****************************	
**Figure 2: Coefficient Plot
*****************************
set scheme s1mono

nbreg allpros pp pm_auto hrfilled10 lsji100 growthper polity2 polity2_d cfhr_l1 five, cluster(ccode)
	estimates store ch1
	
nbreg allpros_everguilt psus10 pp pm_auto hrfilled10 lsji100 growthper polity2 polity2_d cfhr_l1 five, cluster(ccode)
	estimates store ch2
	
coefplot (ch1, label(Prosecution)) (ch2, label(Guilty)),  ///
		drop(_cons) labels ///
		xline(0) levels(95) order (cfhr_l1 lsji100 growthper polity2_d polity2 hrfilled10 five pm_auto psus10 pp)
	
	
**********************	
**Figures 3 and 4**
**********************	

***Repression and PP over time
nbreg allpros i.pp i.hirepress i.five pm_auto lsji100 growthper polity2 polity2_d hrfilled10, cluster(ccode)
	margins i.pp#i.hirepress, at(five=(0 1 2 3 4 5 6 7)) vsquish
	marginsplot, noci  xlabel(0 "70-74" 1 "75-79" 2 "80-84" 3 "85-89" 4 "90-94" 5 "95-99" 6 "00-04" 7 "05-10")

	
***Momentum Pros
 nbreg allpros i.pp##c.momentum cfhr_l1, robust
	margins, dydx(pp) at(momentum=(0(5)30)) vsquish
	 matrix b=r(b)'
	matrix list b
	matrix b=b[8...,1]
	matrix list b
	matrix at=r(at)
	matrix at=at[1...,"momentum"]
	matrix list at
	matrix v=r(V)
	matrix v=v[8...,8...]
	matrix list v
	matrix se=vecdiag(cholesky(diag(vecdiag(v))))'
	matrix list se
	matrix d=at,b,se
	matrix list d
	svmat d, names(d)
	generate ul = d2 + 1.96*d3
	generate ll = d2 - 1.96*d3
	
	graph twoway (line d2 ul ll d1), yline(0) legend(off) ///
       xtitle(Time Since First Trial) ytitle(Domestic Prosecutions) ///
       name(difference1, replace)
	   
*Momentum Guilty
drop d1-ll
 nbreg allpros_everguilt i.pp##c.momentum cfhr_l1 psus, robust
	margins, dydx(pp) at(momentum=(0(5)30)) vsquish
	 matrix b=r(b)'
	matrix list b
	matrix b=b[8...,1]
	matrix list b
	matrix at=r(at)
	matrix at=at[1...,"momentum"]
	matrix list at
	matrix v=r(V)
	matrix v=v[8...,8...]
	matrix list v
	matrix se=vecdiag(cholesky(diag(vecdiag(v))))'
	matrix list se
	matrix d=at,b,se
	matrix list d
	svmat d, names(d)
	generate ul = d2 + 1.96*d3
	generate ll = d2 - 1.96*d3
	
	graph twoway (line d2 ul ll d1), yline(0) legend(off) ///
       xtitle(Time Since First Trial) ytitle(Convictions) ///
       name(difference1, replace) ysc(r(0(1)5))
	
	*Save separately and combine
	graph combine mompros.gph momguilt.gph
	
*HRNGOs Pros
drop d1-ll
 nbreg allpros i.pp##c.hrfilled pm_auto growthper lsji100 growthper polity2 polity2_d cfhr_l1 five polity2, robust
	margins, dydx(pp) at(hrfilled=(0(5)80)) vsquish
	 matrix b=r(b)'
	matrix list b
	matrix b=b[18...,1]
	matrix list b
	matrix at=r(at)
	matrix at=at[1...,"hrfilled"]
	matrix list at
	matrix v=r(V)
	matrix v=v[18...,18...]
	matrix list v
	matrix se=vecdiag(cholesky(diag(vecdiag(v))))'
	matrix list se
	matrix d=at,b,se
	matrix list d
	svmat d, names(d)
	generate ul = d2 + 1.96*d3
	generate ll = d2 - 1.96*d3
	
	graph twoway (line d2 ul ll d1), yline(0) legend(off) ///
       xtitle(HR NGOs) ytitle(Domestic Prosecutions) ///
       name(difference1, replace)	
	   
	     drop d1-ll

*NGOs Guilty
nbreg allpros_everguilt i.pp##c.hrfilled pm_auto growthper lsji100 growthper polity2 cfhr year polity2, robust	 
	margins, dydx(pp) at(hrfilled=(0(5)80)) vsquish
	 matrix b=r(b)'
	matrix list b
	matrix b=b[18...,1]
	matrix list b
	matrix at=r(at)
	matrix at=at[1...,"hrfilled"]
	matrix list at
	matrix v=r(V)
	matrix v=v[18...,18...]
	matrix list v
	matrix se=vecdiag(cholesky(diag(vecdiag(v))))'
	matrix list se
	matrix d=at,b,se
	matrix list d
	svmat d, names(d)
	generate ul = d2 + 1.96*d3
	generate ll = d2 - 1.96*d3
	
	graph twoway (line d2 ul ll d1), yline(0) legend(off) ///
       xtitle(HR NGOs) ytitle(Convictions) ///
       name(difference1, replace)	
	  
	*Save separately and combine
	graph combine ngopros.gph ngoguilt.gph
