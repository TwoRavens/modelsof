/**************************************************
Purpose: Replication data
Publication: "Do States Circumvent Constitutional Supermajority Voting Requirements to Raise Taxes?"
Journal: Forthcoming, State Politics & Policy Quarterly
Author: Soomi Lee
Contact: slee4@laverne.edu
Date: May 8, 2018 
State level panel data: 49 states from 1960 to 2008 (Nebraska excluded)

* Note to users 
1. Change directory: users set the default directory to the folder on their computer where the replication files were downloaded to. 
2. Install the user written package "estout" for eststo and esttab commands. To install, ssc install estout.

***************************************************/

* import data
use "repdata.dta", replace

* begin log
log using "tables_log.smcl", replace

* set panel by state and year
* code=state code; year=year
xtset code year
	
* control variables
global xlist lpop dratio egrowth demlow demup governor divided idec ideg elimit

/* creating state specific time trends 
Note: these variables were created and exist in the replication data)
quietly tab state, gen(statedum)
quietly for num 1/49: replace statedumX=statedumX*year
*/

eststo clear
************************************************************************
* TABLE 2. Time Effect of Supermajority Vote Requirements on Tax Burden
************************************************************************
* fixed effect panel estimation
* Alaska (code=2) and Arkansas (code=4) excluded in all models
* dependent variable: tax payment per $1,000 personal income
eststo model1: xi: xtreg ttax1k smvrd i.year if code!=2 & code!=4, i(code) fe vce(cluster code)
eststo model2: xi: xtreg ttax1k smvrd statedum* i.year if code!=2 & code!=4, i(code) fe vce(cluster code)
eststo model3: xi: xtreg ttax1k smvrd smvryr statedum* i.year if code!=2 & code!=4, i(code) fe vce(cluster code)
eststo model4: xi: xtreg ttax1k smvrd smvryr smvryr2 statedum* i.year ///
		if code!=2 & code!=4, i(code) fe vce(cluster code)
eststo model5: xi: xtreg ttax1k smvrd smvryr smvryr2 $xlist statedum* i.year ///
		if code!=2 & code!=4, i(code) fe vce(cluster code)
* save results
esttab using table2.csv, ar2(3) scalars(N  aic bic) b(3) se(3) star(* 0.05 ** 0.01) nogap replace 
eststo clear


************************************************************************
* TABLE 3. Time Effect of Supermajority Vote Requirements on Fee Burden and Tax-to-Fee Ratio
************************************************************************
* fixed effect panel estimation
* Alaska (code=2) and Arkansas (code=4) excluded in all models

* model 1: dependent variable=fee burden (fee1k)
eststo model1: xi: xtreg fee1k smvrd smvryr smvryr2 $xlist statedum* i.year ///
				if code!=2 & code!=4, i(code) fe vce(cluster code)
* model 2: dependent variable=fee share (feeshare)
eststo model2: xi: xtreg feeshare smvrd smvryr smvryr2 $xlist statedum* i.year ///
				if code!=2 & code!=4, i(code) fe vce(cluster code)
* model 3: dependent variable=tax share	(taxshare)	
eststo model3: quiet xi: xtreg taxshare smvrd smvryr smvryr2 $xlist statedum* i.year ///
				if code!=2 & code!=4, i(code) fe vce(cluster code)
* model 4: dependent variable=tax to fee ratio (tax2fee)
eststo model4: quiet xi: xtreg tax2fee smvrd smvryr smvryr2 $xlist statedum* i.year ///
				if code!=2 & code!=4, i(code) fe vce(cluster code)

* save results
esttab using table3.csv, ar2(3) scalars(N  aic bic) b(3) se(3) star(* 0.05 ** 0.01)  nogap replace 
eststo clear


************************************************************************
* TABLE 4.Robustness Checks 
************************************************************************
* fixed effect panel estimation
* Alaska (code=2) and Arkansas (code=4) excluded in all models

*** Panel A: dependent variable=tax burden (ttax1k)
* baseline: years between 1960-2008
eststo modela1: xi: xtreg ttax1k smvrd smvryr smvryr2 $xlist statedum* i.year ///
			if code!=2 & code!=4, i(code) fe vce(cluster code)
* years between 1960-2000
eststo modela2: xi: xtreg ttax1k smvrd smvryr smvryr2 $xlist statedum* i.year ///
			if year<2001 & code!=2 & code!=4, i(code) fe vce(cluster code)
* years between 1970-2000
eststo modela3: xi: xtreg ttax1k smvrd smvryr smvryr2 $xlist statedum* i.year ///
			if year>1969 & year<2001 & code!=2 & code!=4, i(code) fe vce(cluster code)		
* years between 1970-2008
eststo modela4: xi: xtreg ttax1k smvrd smvryr smvryr2 $xlist statedum* i.year ///
			if year>1969 & code!=2 & code!=4, i(code) fe vce(cluster code)

esttab using table4a.csv, ar2(3) scalars(N  aic bic) b(3) se(3) star(* 0.05 ** 0.01) nogap replace 
eststo clear

*** Panel B: dependent variable=fee burden (fee1k)
* baseline: 1960-2008
eststo modelb1: xi: xtreg fee1k smvrd smvryr smvryr2 $xlist statedum* i.year /*
	*/if code!=2 & code!=4, i(code) fe vce(cluster code)
* years between 1960-2000
eststo modelb2: xi: xtreg fee1k smvrd smvryr smvryr2 $xlist statedum* i.year if year<2001 /*
	*/& code!=2 & code!=4, i(code) fe vce(cluster code)
* years between 1970-2000
eststo modelb3: xi: xtreg fee1k smvrd smvryr smvryr2 $xlist statedum* i.year if  year>1969 & year<2001 /*
	*/& code!=2 & code!=4, i(code) fe vce(cluster code)
* years between 1970-2008
eststo modelb4: xi: xtreg fee1k smvrd smvryr smvryr2 $xlist statedum* i.year if year>1969 /*
	*/& code!=2 & code!=4, i(code) fe vce(cluster code)

* save results
esttab using table4b.csv, ar2(3) scalars(N  aic bic) b(3) se(3) star(* 0.05 ** 0.01) nogap replace 
eststo clear

*** Panel C: dependent variable=tax to fee ratio (tax2fee)
* baseline: 1960-2008
eststo modelc1: xi: xtreg tax2fee smvrd smvryr smvryr2 $xlist statedum* i.year ///
		if code!=2 & code!=4, i(code) fe vce(cluster code)
* years between 1960-2000
eststo modelc2: xi: xtreg tax2fee smvrd smvryr smvryr2 $xlist statedum* i.year /// 
		if year<2001 & code!=2 & code!=4, i(code) fe vce(cluster code)
* years between 1970-2000
eststo modelc3: xi: xtreg tax2fee smvrd smvryr smvryr2 $xlist statedum* i.year /// 
		if  year>1969 & year<2001 & code!=2 & code!=4, i(code) fe vce(cluster code)
* years between 1970-2008
eststo modelc4: xi: xtreg tax2fee smvrd smvryr smvryr2 $xlist statedum* i.year /// 
		if year>1969 & code!=2 & code!=4, i(code) fe vce(cluster code)

* save results
esttab using table4c.csv, ar2(3) scalars(N  aic bic) b(3) se(3) star(* 0.05 ** 0.01) nogap replace 
eststo clear

************************************************************************
* Table 5. Further Robustnessness
************************************************************************
* fixed effect panel estimation

*** Panel A: dependent variable=tax burden (ttax1k)
* baseline
eststo modela1: xi: xtreg ttax1k smvrd smvryr smvryr2 $xlist statedum* i.year /// 
		if code!=2 & code!=4, i(code) fe vce(cluster code)
* including Alaska and Arkansas in the sample
eststo modela2: xi: xtreg ttax1k smvrd smvryr smvryr2 $xlist statedum* i.year, i(code) fe vce(cluster code)
* using an alternative measure of supermajority rules 
eststo modela3: xi: xtreg ttax1k thresh smvryr smvryr2 $xlist statedum* ///
		i.year if code!=2 & code!=4, i(code) fe vce(cluster code)

* save results
esttab using table5a.csv, ar2(3) scalars(N  aic bic) b(3) se(3) star(* 0.05 ** 0.01) nogap replace 
eststo clear

*** Panel B: dependent variable=fee burden (fee1k)
* baseline
eststo modelb1: xi: xtreg fee1k smvrd smvryr smvryr2 $xlist statedum* i.year ///
		if code!=2 & code!=4, i(code) fe vce(cluster code)
* including Alaska and Arkansas in the sample
eststo modelb2: xi: xtreg fee1k smvrd smvryr smvryr2 $xlist statedum* i.year, i(code) fe vce(cluster code)
* using an alternative measure of supermajority rules
eststo modelb3: xi: xtreg fee1k thresh smvryr smvryr2 $xlist statedum* i.year /// 
		if code!=2 & code!=4 , i(code) fe vce(cluster code)

* save results
esttab using table5b.csv, ar2(3) scalars(N  aic bic) b(3) se(3) star(* 0.05 ** 0.01) nogap replace 
eststo clear

*** Panel C: dependent variable=tax to fee ratio (tax2fee)
* baseline
eststo modelc1: xi: xtreg tax2fee smvrd smvryr smvryr2 $xlist statedum* i.year /// 
		if code!=2 & code!=4, i(code) fe vce(cluster code)
* including Alaska and Arkansas in the sample
eststo modelc2: xi: xtreg tax2fee smvrd smvryr smvryr2 $xlist statedum* i.year, i(code) fe vce(cluster code)
* using an alternative measure of supermajority rules. 
eststo modelc3: xi: xtreg tax2fee thresh smvryr smvryr2 $xlist statedum* i.year /// 
		if code!=2 & code!=4, i(code) fe vce(cluster code)

* save results
esttab using table5c.csv, ar2(3) scalars(N  aic bic) b(3) se(3) star(* 0.05 ** 0.01) nogap replace 
eststo clear

**********************************************************
* Appendix B. SUMMARY STATISTICS 
* 1=SMVR; 0=no SMVR	
* Alaska (code=1) and Arkansas (code=2) excluded)
**********************************************************	
* smvr states (smvr=1, presence of supermajority rule)
sum  	smvrd smvryr smvryr2 thresh ///
		ttax1k fee1k feeshare feeshare tax2fee ///
		lpop dratio egrowth demlow demup governor ///
		divided idec ideg elimit if smvrd==1 & code!=2 & code!=4, sep(0)

* no smvr (smvr=0, absence of supermajority rule)
sum  	smvrd smvryr smvryr2 thresh ///
		ttax1k fee1k feeshare feeshare tax2fee ///
		lpop dratio egrowth demlow demup governor ///
		divided idec ideg elimit if smvrd==0 & code!=2 & code!=4, sep(0)

* all
sum  	smvrd smvryr smvryr2 thresh ///
		ttax1k fee1k feeshare feeshare tax2fee ///
		lpop dratio egrowth demlow demup governor ///
		divided idec ideg elimit if code!=2 & code!=4, sep(0)

log close
