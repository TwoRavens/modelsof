*12345678901234567890123456789012345678901234567890123456789012345678901234567890
capture log close
clear all
set more off

*	************************************************************************
* 	File-Name: 	AklinKernReplication.do
*	Date:  		09/22/2018
*	Author: 	Michaël Aklin & Andreas Kern
*	Data Used:  AklinKernReplicationData.dta
*	Purpose:   	.do file to replicate the results of:
*				Aklin, M. and A. Kern. "The Side Effects of Central Bank
*				Independence." American Journal of Political Science.
*	************************************************************************



*	************************************************************************
*	Nota Bene
*	************************************************************************

/*
This do file replicates the appendix of 
Aklin, M. and A. Kern. "The Side Effects of Central Bank Independence." 
American Journal of Political Science.

Most commands are already built in Stata 15 (the file should work on earlier
versions of Stata as well. Exception:

esttab: display formatted regression table (written by Ben Jann).

This command needs to be installed from ssc (ssc install ...). 
*/


*	************************************************************************
*	A. Upload the data
*	************************************************************************

* CHANGE PATH HERE
// cd "PATH_TO_REPLICATION_PACKAGE"

*	Data
use "AklinKernReplicationData.dta", clear


*	************************************************************************
*	B. Replication of the main results
*	************************************************************************

*	************************************************************************
*	Table 2
*	************************************************************************

eststo: xtreg f.finreform lvaw time time2 , fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
xtsum lvaw if e(sample)==1
di _b[lvaw]*r(sd_w)
eststo: xtreg f.finreform lvaw time time2 loggdp loggdpcap polity2 i.pegtype, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
xtsum lvaw if e(sample)==1
di _b[lvaw]*r(sd_w)
eststo: xtreg f.finreform lvaw i.year loggdp loggdpcap polity2 i.pegtype, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
xtsum lvaw if e(sample)==1
di _b[lvaw]*r(sd_w)

eststo: xtreg f.entrybarriers lvaw time time2, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
xtsum lvaw if e(sample)==1
di _b[lvaw]*r(sd_w)
eststo: xtreg f.entrybarriers lvaw time time2 loggdp loggdpcap polity2 i.pegtype, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
xtsum lvaw if e(sample)==1
di _b[lvaw]*r(sd_w)
eststo: xtreg f.entrybarriers lvaw i.year loggdp loggdpcap polity2 i.pegtype, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
xtsum lvaw if e(sample)==1
di _b[lvaw]*r(sd_w)

eststo: xtreg f.privatization lvaw time time2, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
xtsum lvaw if e(sample)==1
di _b[lvaw]*r(sd_w)
eststo: xtreg f.privatization lvaw time time2 loggdp loggdpcap polity2 i.pegtype, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
xtsum lvaw if e(sample)==1
di _b[lvaw]*r(sd_w)
eststo: xtreg f.privatization lvaw i.year loggdp loggdpcap polity2 i.pegtype, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
xtsum lvaw if e(sample)==1
di _b[lvaw]*r(sd_w)

eststo: xtreg f.deposit_insurance lvaw time time2, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
xtsum lvaw if e(sample)==1
di _b[lvaw]*r(sd_w)
eststo: xtreg f.deposit_insurance lvaw time time2 loggdp loggdpcap polity2 i.pegtype, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
xtsum lvaw if e(sample)==1
di _b[lvaw]*r(sd_w)
eststo: xtreg f.deposit_insurance lvaw i.year loggdp loggdpcap polity2 i.pegtype, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
xtsum lvaw if e(sample)==1
di _b[lvaw]*r(sd_w)

eststo: xtreg f.ckaopen2010 lvaw time time2, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
xtsum lvaw if e(sample)==1
di _b[lvaw]*r(sd_w)
eststo: xtreg f.ckaopen2010 lvaw time time2 loggdp loggdpcap polity2 i.pegtype, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
xtsum lvaw if e(sample)==1
di _b[lvaw]*r(sd_w)
eststo: xtreg f.ckaopen2010 lvaw i.year loggdp loggdpcap polity2 i.pegtype, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
xtsum lvaw if e(sample)==1
di _b[lvaw]*r(sd_w)

esttab using "Table2.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.05 ** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE")	///
	mgroups("Financial Reform" "Bank. Entry Barriers" "Bank. Liberalization" "Deposit Insurance" "Capital Openness", pattern(1 0 0 1 0 0 1 0 0 1 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate("Type of Peg = *pegtype*" "Year FE = *year*" "Quadratic Time = time*", label($\checkmark$ ))			///
	noconstant nonotes
eststo clear



*	************************************************************************
*	Figure 2
*	************************************************************************

preserve
gen country2 = countryname if countryname == "Hungary" | countryname == "Colombia" | countryname == "Brazil" | countryname == "United Kingdom"

gen lvaw_new = lvaw if country2 != ""
replace lvaw_new = lvaw_garriga if lvaw==. & country2 != ""

replace lvaw_new = . if country2 == "Colombia" & (year != 1990 & year != 1995)
replace lvaw_new = . if country2 == "Brazil" & (year != 1990 & year != 1995)
replace lvaw_new = . if country2 == "Hungary" & (year != 1990 & year != 1995 & year != 2001)
replace lvaw_new = . if country2 == "United Kingdom" & (year != 1990 & year != 1997)

egen countryyear = concat(country2 year)

label var lvaw_new "CBI"

twoway scatter finreform lvaw_new	///
	, ///
		mlabel(countryyear) ///
		yline(10.75, lstyle(refline) lpattern(dash)) ///
		xline(0.45, lstyle(refline) lpattern(dash))	///
		xlabel(0(0.2)1)	
graph export "Figure2.pdf", replace as(pdf)
restore




*	************************************************************************
*	C. Replication of the supplementary material: see separate do file
*	AklinKernReplicationAppendix.do
*	************************************************************************














