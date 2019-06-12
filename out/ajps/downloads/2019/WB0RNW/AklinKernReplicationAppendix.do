*12345678901234567890123456789012345678901234567890123456789012345678901234567890
capture log close
clear all
set more off

*	************************************************************************
* 	File-Name: 	AklinKernReplicationAppendix.do
*	Date:  		09/25/2018
*	Author: 	Michaël Aklin & Andreas Kern
*	Data Used:  AklinKernReplicationData.dta
*	Purpose:   	.do file to replicate the appendix of:
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
versions of Stata as well. Exceptions include:

xtscc: regression with Driscoll-Kraay standard errors (writted by Daniel Hoechle)

semipar: Robinson's (1988) semiparametric regression estimator.

esttab: display formatted regression table (written by Ben Jann).

plausexog: Stata implementation of IV estimation under flexible (plausibly 
	exogenous) conditions (written by Damian Clarke).
	
coefplot: plotting regression coefficients and other results (written by Ben Jann)

These commands need to be installed from ssc (ssc install ...). 

In addition, the following needs to be installed manually:

pvar: panel vector autoregressive models (written by Michael Abriggio and Inessa
Love), available at https://sites.google.com/a/hawaii.edu/inessalove/home/pvar

*/


*	************************************************************************
*	A. Upload the data
*	************************************************************************

* CHANGE PATH HERE
// cd "PATH_TO_REPLICATION_PACKAGE"

*	Data
use "AklinKernReplicationData.dta", clear


*	************************************************************************
*	B. Replication of the main results: see AklinKernReplication.do
*	************************************************************************

*	************************************************************************
*	C. Replication of the supplementary material
*
*	Note: some commands are not installed by default on Stata. See readme.txt
*	for a list of these commands and how to obtain them.
*	************************************************************************


*	****************************************************************************
*	C.A1 Table A1 -- Market Effects of CBI: All Countries
*	****************************************************************************

eststo: xtreg f.infcpi lvaw time time2 if infcpi<50, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.infcpi lvaw time time2 loggdp loggdpcap polity2 if infcpi<50, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.infcpi lvaw i.year loggdp loggdpcap polity2 if infcpi<50, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.financedata31 lvaw time time2 if financedata31 < 50, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.financedata31 lvaw time time2 loggdp loggdpcap polity2 if financedata31 < 50, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.financedata31 lvaw i.year loggdp loggdpcap polity2 if financedata31 < 50, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
esttab using "App_TableA1.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.05 ** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE")	///
	mgroups("Inflation (\%)" "Lending Interest Rate (\%)", pattern(1 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate("Year FE = *year*" "Quadratic Time = time*", label($\checkmark$ ))		///
	noconstant nonotes
eststo clear

*	****************************************************************************
*	C.A1 Table A2 -- Market Effects of CBI: Democractic Countries
*	****************************************************************************


eststo: xtreg f.infcpi lvaw time time2 if infcpi<50 & polity2 >= 6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.infcpi lvaw time time2 loggdp loggdpcap if infcpi<50 & polity2 >= 6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.infcpi lvaw i.year loggdp loggdpcap if infcpi<50 & polity2 >= 6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.financedata31 lvaw time time2 if financedata31 < 50 & polity2 >= 6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.financedata31 lvaw time time2 loggdp loggdpcap if financedata31 < 50 & polity2 >= 6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.financedata31 lvaw i.year loggdp loggdpcap if financedata31 < 50 & polity2 >= 6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
esttab using "App_TableA2.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.05 ** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE")	///
	mgroups("Inflation (\%)" "Lending Interest Rate (\%)", pattern(1 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate("Year FE = *year*" "Quadratic Time = time*", label($\checkmark$ ))			///
	noconstant nonotes
eststo clear




*	****************************************************************************
*	C.A2 Table A3 -- Results: Financial Outcomes
*	****************************************************************************

*	Coding a few more variables
by ccode: gen lfinancedata34 = log(financedata34+1)
by ccode: gen lfinancedata33 = log(financedata33+1)
by ccode: gen lecopodata267 = log(ecopodata267)
by ccode: gen lPortfoliodebtliabilities = log(Portfoliodebtliabilities+1)
by ccode: gen lfinancedata1 = log(financedata1+1)


eststo: xtreg m2growth lvaw time time2 if m2growth<140, fe vce(robust)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg m2growth lvaw time time2 loggdp loggdpcap polity2 if m2growth<140, fe vce(robust)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg m2growth lvaw i.year loggdp loggdpcap polity2 if m2growth<140, fe vce(robust)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg d.logtotalcreditC lvaw time time2, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg d.logtotalcreditC lvaw time time2 loggdp loggdpcap polity2, fe vce(robust)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg d.logtotalcreditC lvaw i.year loggdp loggdpcap polity2, fe vce(robust)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.lPortfoliodebtliabilities lvaw time time2, fe vce(robust)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.lPortfoliodebtliabilities lvaw time time2 loggdp loggdpcap polity2, fe vce(robust)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.lPortfoliodebtliabilities lvaw i.year loggdp loggdpcap polity2, fe vce(robust)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.lecopodata267 lvaw time time2 if ecopodata267<200, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.lecopodata267 lvaw time time2 loggdp loggdpcap polity2 if ecopodata267<200, fe vce(robust)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.lecopodata267 lvaw i.year loggdp loggdpcap polity2 if ecopodata267<200, fe vce(robust)
estadd local fixed "$\checkmark$" , replace

esttab using "App_TableA3.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.05 ** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE")	///
	mgroups("M2 Growth (\%)" "Credit Growth (\%)" "Portfolio Inflows" "Debt Inflows", pattern(1 0 0 1 0 0 1 0 0 1 0 0 ) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate("Year FE = *year*" "Quadratic Time = time*", label($\checkmark$ ))			///
	noconstant nonotes
eststo clear



*	****************************************************************************
*	C.A7 Table A4 -- Financial Deregulation and Subsidies in Latin America 
*	****************************************************************************

eststo: reg melo_loansworkingcapital lvaw  if year == 1994, robust
eststo: logit melo_loansworkingcapital lvaw  if year == 1994, robust
eststo: reg melo_financeinvesproject lvaw  if year == 1994, robust
eststo: logit melo_financeinvesproject lvaw  if year == 1994, robust
eststo: reg melo_financemarketing lvaw  if year == 1994, robust
eststo: logit melo_financemarketing lvaw  if year == 1994, robust
eststo: reg melo_exportcreditinsurance lvaw  if year == 1994, robust
eststo: logit melo_exportcreditinsurance lvaw  if year == 1994, robust

esttab using "App_TableA4.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.05 ** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" ) r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("OLS" "Logit" "OLS" "Logit" "OLS" "Logit" "OLS" "Logit") eqlabels(none)	///
	mgroups("Loan Capital" "Finance Inv." "Finance Marketing" "Export Insurance", pattern(1 0 1 0 1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))		///
	noconstant nonotes	
eststo clear



*	****************************************************************************
*	C.A8 Table A6 -- Summary statistics
*	****************************************************************************

preserve
quiet xtreg f.finreform lvaw time time2 , fe 
keep if e(sample) == 1
estpost sum finreform entrybarriers privatization deposit_insurance ckaopen2010 lvaw loggdp loggdpcap polity2, d
esttab using "App_TableA6.tex", ///
	cells("mean(label(Mean) fmt(2)) p50(label(Median) fmt(2)) sd(label(S.D.) fmt(2)) min(label(Min.) fmt(0)) max(label(Max) fmt(0)) count(label(Obs.) fmt(0))") ///
	nonumber label replace noobs
eststo clear
restore

*	****************************************************************************
*	C.A8 Table A7 -- Deposit Insurance
*	****************************************************************************

*	New variable
gen cbi_refacemoglu = cbi_refyear
label var cbi_refacemoglu "CBI Reform"

eststo: xtreg f.deposit_insurance lvaw time time2, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.deposit_insurance lvaw i.year, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.deposit_insurance lvaw time time2 loggdp loggdpcap polity2 , fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.deposit_insurance lvaw i.year loggdp loggdpcap polity2 , fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.deposit_insurance cbi_refacemoglu time time2, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.deposit_insurance cbi_refacemoglu i.year, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.deposit_insurance cbi_refacemoglu time time2 loggdp loggdpcap polity2 , fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.deposit_insurance cbi_refacemoglu i.year loggdp loggdpcap polity2 , fe robust
estadd local fixed "$\checkmark$" , replace
esttab using "App_TableA7.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.05 ** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE")	///
	mgroups("Bodea/Hicks" "Acemoglu et al", pattern(1 0 0 0 1 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate("Year FE = *year*" "Quadratic Time = time*", label($\checkmark$ ))			///
	noconstant nonotes
eststo clear



*	****************************************************************************
*	C.A8 Table A8 -- Financial Reform
*	****************************************************************************

eststo: xtreg f.finreform lvaw time time2, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.finreform lvaw i.year, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.finreform lvaw time time2 loggdp loggdpcap polity2 , fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.finreform lvaw i.year loggdp loggdpcap polity2 , fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.finreform cbi_refacemoglu time time2, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.finreform cbi_refacemoglu i.year, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.finreform cbi_refacemoglu time time2 loggdp loggdpcap polity2 , fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.finreform cbi_refacemoglu i.year loggdp loggdpcap polity2 , fe robust
estadd local fixed "$\checkmark$" , replace
esttab using "App_TableA8.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.05 ** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE")	///
	mgroups("Bodea/Hicks" "Acemoglu et al", pattern(1 0 0 0 1 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate("Year FE = *year*" "Quadratic Time = time*", label($\checkmark$ ))			///
	noconstant nonotes
eststo clear


*	****************************************************************************
*	C.A8 Table A9 -- Entry Barriers
*	****************************************************************************


eststo: xtreg f.entrybarriers lvaw time time2, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.entrybarriers lvaw i.year, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.entrybarriers lvaw time time2 loggdp loggdpcap polity2 , fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.entrybarriers lvaw i.year loggdp loggdpcap polity2 , fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.entrybarriers cbi_refacemoglu time time2, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.entrybarriers cbi_refacemoglu i.year, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.entrybarriers cbi_refacemoglu time time2 loggdp loggdpcap polity2 , fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.entrybarriers cbi_refacemoglu i.year loggdp loggdpcap polity2 , fe robust
estadd local fixed "$\checkmark$" , replace
esttab using "App_TableA9.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.05 ** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE")	///
	mgroups("Bodea/Hicks" "Acemoglu et al", pattern(1 0 0 0 1 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate("Year FE = *year*" "Quadratic Time = time*", label($\checkmark$ ))			///
	noconstant nonotes
eststo clear


*	****************************************************************************
*	C.A8 Table A10 -- Bank Privatization
*	****************************************************************************


eststo: xtreg f.privatization lvaw time time2, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.privatization lvaw i.year, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.privatization lvaw time time2 loggdp loggdpcap polity2 , fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.privatization lvaw i.year loggdp loggdpcap polity2 , fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.privatization cbi_refacemoglu time time2, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.privatization cbi_refacemoglu i.year, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.privatization cbi_refacemoglu time time2 loggdp loggdpcap polity2 , fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.privatization cbi_refacemoglu i.year loggdp loggdpcap polity2 , fe robust
estadd local fixed "$\checkmark$" , replace
esttab using "App_TableA10.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.05 ** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE")	///
	mgroups("Bodea/Hicks" "Acemoglu et al", pattern(1 0 0 0 1 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate("Year FE = *year*" "Quadratic Time = time*", label($\checkmark$ ))			///
	noconstant nonotes
eststo clear



*	****************************************************************************
*	C.A9 Table A11 -- Policy Reaction to CBI: Democratic Countries
*	****************************************************************************

eststo: xtreg f.finreform lvaw time time2 if polity2 >= 6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.finreform lvaw time time2 loggdp loggdpcap polity2 i.pegtype if polity2 >= 6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.finreform lvaw i.year loggdp loggdpcap polity2 i.pegtype if polity2 >= 6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.entrybarriers lvaw time time2 if polity2 >= 6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.entrybarriers lvaw time time2 loggdp loggdpcap polity2 i.pegtype if polity2 >= 6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.entrybarriers lvaw i.year loggdp loggdpcap polity2 i.pegtype if polity2 >= 6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.privatization lvaw time time2 if polity2 >= 6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.privatization lvaw time time2 loggdp loggdpcap polity2 i.pegtype if polity2 >= 6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.privatization lvaw i.year loggdp loggdpcap polity2 i.pegtype if polity2 >= 6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.deposit_insurance lvaw time time2 if polity2 >= 6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.deposit_insurance lvaw time time2 loggdp loggdpcap polity2 i.pegtype if polity2 >= 6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.deposit_insurance lvaw i.year loggdp loggdpcap polity2 i.pegtype if polity2 >= 6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.ckaopen2010 lvaw time time2 if polity2 >= 6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.ckaopen2010 lvaw time time2 loggdp loggdpcap polity2 i.pegtype if polity2 >= 6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.ckaopen2010 lvaw i.year loggdp loggdpcap polity2 i.pegtype if polity2 >= 6 , fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

esttab using "App_TableA11.tex"	///
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


*	****************************************************************************
*	C.A9 Table A12 -- Selected Features of Deposit Insurance: All Countries
*	****************************************************************************


eststo: xtreg f.deposit_insurance lvaw i.year, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.deposit_insurance lvaw i.year loggdp loggdpcap polity2, fe robust
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.d.di2_lcoverage_gdp lvaw i.year, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.d.di2_lcoverage_gdp lvaw i.year loggdp loggdpcap polity2, fe robust
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.d.di2_lcoverage_dep lvaw i.year, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.d.di2_lcoverage_dep lvaw i.year loggdp loggdpcap polity2, fe robust
estadd local fixed "$\checkmark$" , replace

eststo: reg di_backstop llvaw if year==2003, vce(robust)
eststo: reg di_backstop llvaw lloggdp lloggdpcap lpolity2 if year==2003, vce(robust)

eststo: reg di_fxbanks llvaw if year==2003, vce(robust)
eststo: reg di_fxbanks llvaw lloggdp lloggdpcap lpolity2 if year==2003,  vce(robust)


esttab using "App_TableA12.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.05 ** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "OLS" "OLS" "OLS" "OLS")	///
	mgroups("Dep. Insurance" "$\delta$ Dep. Coverage" "$\delta$ Dep. Coverage" "Gov. Backstop" "FX Banks", pattern(1 0 1 0 1 0 1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate("Year FE = *year*", label($\checkmark$ ))			///
	noconstant nonotes
eststo clear



*	****************************************************************************
*	C.A9 Table A13 -- Policy Reaction to CBI: Additional Control Variables (v.1)
*	****************************************************************************

 
eststo: xtreg f.finreform lvaw time time2 loggdp loggdpcap polity2 gini_net ecopodata275 ecopodata178, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.finreform lvaw i.year loggdp loggdpcap polity2 gini_net ecopodata275 ecopodata178, fe robust
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.entrybarriers lvaw time time2 loggdp loggdpcap polity2 gini_net ecopodata275 ecopodata178, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.entrybarriers lvaw i.year loggdp loggdpcap polity2 gini_net ecopodata275 ecopodata178, fe robust
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.privatization lvaw time time2 loggdp loggdpcap polity2 gini_net ecopodata275 ecopodata178, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.privatization lvaw i.year loggdp loggdpcap polity2 gini_net ecopodata275 ecopodata178, fe robust
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.deposit_insurance lvaw time time2 loggdp loggdpcap polity2 gini_net ecopodata275 ecopodata178, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.deposit_insurance lvaw i.year loggdp loggdpcap polity2 gini_net ecopodata275 ecopodata178, fe robust
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.ckaopen2010 lvaw time time2 loggdp loggdpcap polity2 gini_net ecopodata275 ecopodata178, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.ckaopen2010 lvaw i.year loggdp loggdpcap polity2 gini_net ecopodata275 ecopodata178, fe robust
estadd local fixed "$\checkmark$" , replace

esttab using "App_TableA13.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.05 ** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE")	///
	mgroups("Financial Reform" "Bank. Entry Barriers" "Bank. Liberalization" "Deposit Insurance" "Capital Openness", pattern(1 0 1 0 1 0 1 0 1 0 ) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate("Year FE = *year*" "Quadratic Time = time*", label($\checkmark$ ))			///
	noconstant nonotes
eststo clear



*	****************************************************************************
*	C.A9 Table A14 -- Policy Reaction to CBI: Additional Control Variables (v.2)
*	****************************************************************************

eststo: xtreg f.finreform lvaw time time2 loggdp loggdpcap polity2 gini_net ecopodata275 ecopodata178 left presidential, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.finreform lvaw i.year loggdp loggdpcap polity2 gini_net ecopodata275 ecopodata178 left presidential, fe robust
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.entrybarriers lvaw time time2 loggdp loggdpcap polity2 gini_net ecopodata275 ecopodata178 left presidential, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.entrybarriers lvaw i.year loggdp loggdpcap polity2 gini_net ecopodata275 ecopodata178 left presidential, fe robust
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.privatization lvaw time time2 loggdp loggdpcap polity2 gini_net ecopodata275 ecopodata178 left presidential, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.privatization lvaw i.year loggdp loggdpcap polity2 gini_net ecopodata275 ecopodata178 left presidential, fe robust
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.deposit_insurance lvaw time time2 loggdp loggdpcap polity2 gini_net ecopodata275 ecopodata178 left presidential, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.deposit_insurance lvaw i.year loggdp loggdpcap polity2 gini_net ecopodata275 ecopodata178 left presidential, fe robust
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.ckaopen2010 lvaw time time2 loggdp loggdpcap polity2 gini_net ecopodata275 ecopodata178 left presidential, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.ckaopen2010 lvaw i.year loggdp loggdpcap polity2 gini_net ecopodata275 ecopodata178 left presidential, fe robust
estadd local fixed "$\checkmark$" , replace

esttab using "App_TableA14.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.05 ** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE")	///
	mgroups("Financial Reform" "Bank. Entry Barriers" "Bank. Liberalization" "Deposit Insurance" "Capital Openness", pattern(1 0 1 0 1 0 1 0 1 0 ) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate("Year FE = *year*" "Quadratic Time = time*", label($\checkmark$ ))			///
	noconstant nonotes
eststo clear

*	****************************************************************************
*	C.A9 Table A15 -- Policy Reaction to CBI: Additional Control Variables (v.3)
*	****************************************************************************



eststo: xtreg f.finreform lvaw time time2 loggdp loggdpcap polity2 imf, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.finreform lvaw i.year loggdp loggdpcap polity2 imf, fe robust
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.entrybarriers lvaw time time2 loggdp loggdpcap polity2 imf, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.entrybarriers lvaw i.year loggdp loggdpcap polity2 imf, fe robust
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.privatization lvaw time time2 loggdp loggdpcap polity2 imf, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.privatization lvaw i.year loggdp loggdpcap polity2 imf, fe robust
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.deposit_insurance lvaw time time2 loggdp loggdpcap polity2 imf, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.deposit_insurance lvaw i.year loggdp loggdpcap polity2 imf, fe robust
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.ckaopen2010 lvaw time time2 loggdp loggdpcap polity2 imf, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.ckaopen2010 lvaw i.year loggdp loggdpcap polity2 imf, fe robust
estadd local fixed "$\checkmark$" , replace

esttab using "App_TableA15.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.05 ** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE")	///
	mgroups("Financial Reform" "Bank. Entry Barriers" "Bank. Liberalization" "Deposit Insurance" "Capital Openness", pattern(1 0 1 0 1 0 1 0 1 0 ) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate("Year FE = *year*" "Quadratic Time = time*", label($\checkmark$ ))			///
	noconstant nonotes
eststo clear




*	****************************************************************************
*	C.A9 Table A16 -- Policy Reaction to CBI: Additional Control Variables (v.4)
*	****************************************************************************

eststo: xtreg f.finreform lvaw time time2 loggdp loggdpcap polity2 imf_wb, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.finreform lvaw i.year loggdp loggdpcap polity2 imf_wb, fe robust
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.entrybarriers lvaw time time2 loggdp loggdpcap polity2 imf_wb, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.entrybarriers lvaw i.year loggdp loggdpcap polity2 imf_wb, fe robust
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.privatization lvaw time time2 loggdp loggdpcap polity2 imf_wb, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.privatization lvaw i.year loggdp loggdpcap polity2 imf_wb, fe robust
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.deposit_insurance lvaw time time2 loggdp loggdpcap polity2 imf_wb, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.deposit_insurance lvaw i.year loggdp loggdpcap polity2 imf_wb, fe robust
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.ckaopen2010 lvaw time time2 loggdp loggdpcap polity2 imf_wb, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.ckaopen2010 lvaw i.year loggdp loggdpcap polity2 imf_wb, fe robust
estadd local fixed "$\checkmark$" , replace

esttab using "App_TableA16.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.05 ** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE")	///
	mgroups("Financial Reform" "Bank. Entry Barriers" "Bank. Liberalization" "Deposit Insurance" "Capital Openness", pattern(1 0 1 0 1 0 1 0 1 0 ) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate("Year FE = *year*" "Quadratic Time = time*", label($\checkmark$ ))			///
	noconstant nonotes
eststo clear



*	****************************************************************************
*	C.A9 Table A17 -- Policy Reaction to CBI: Additional Control Variables (v.5)
*	****************************************************************************

eststo: xtreg f.finreform lvaw time time2 loggdp loggdpcap polity2 imf_all, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.finreform lvaw i.year loggdp loggdpcap polity2 imf_all, fe robust
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.entrybarriers lvaw time time2 loggdp loggdpcap polity2 imf_all, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.entrybarriers lvaw i.year loggdp loggdpcap polity2 imf_all, fe robust
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.privatization lvaw time time2 loggdp loggdpcap polity2 imf_all, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.privatization lvaw i.year loggdp loggdpcap polity2 imf_all, fe robust
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.deposit_insurance lvaw time time2 loggdp loggdpcap polity2 imf_all, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.deposit_insurance lvaw i.year loggdp loggdpcap polity2 imf_all, fe robust
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.ckaopen2010 lvaw time time2 loggdp loggdpcap polity2 imf_all, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.ckaopen2010 lvaw i.year loggdp loggdpcap polity2 imf_all, fe robust
estadd local fixed "$\checkmark$" , replace

esttab using "App_TableA17.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.05 ** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE")	///
	mgroups("Financial Reform" "Bank. Entry Barriers" "Bank. Liberalization" "Deposit Insurance" "Capital Openness", pattern(1 0 1 0 1 0 1 0 1 0 ) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate("Year FE = *year*" "Quadratic Time = time*", label($\checkmark$ ))			///
	noconstant nonotes
eststo clear


*	****************************************************************************
*	C.A9 Table A18 -- Policy Reaction to CBI: Additional Control Variables (v.6)
*	****************************************************************************

eststo: xtreg f.finreform lvaw time time2 loggdp loggdpcap polity2 imf_e, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.finreform lvaw i.year loggdp loggdpcap polity2 imf_e, fe robust
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.entrybarriers lvaw time time2 loggdp loggdpcap polity2 imf_e, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.entrybarriers lvaw i.year loggdp loggdpcap polity2 imf_e, fe robust
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.privatization lvaw time time2 loggdp loggdpcap polity2 imf_e, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.privatization lvaw i.year loggdp loggdpcap polity2 imf_e, fe robust
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.deposit_insurance lvaw time time2 loggdp loggdpcap polity2 imf_e, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.deposit_insurance lvaw i.year loggdp loggdpcap polity2 imf_e, fe robust
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.ckaopen2010 lvaw time time2 loggdp loggdpcap polity2 imf_e, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.ckaopen2010 lvaw i.year loggdp loggdpcap polity2 imf_e, fe robust
estadd local fixed "$\checkmark$" , replace

esttab using "App_TableA18.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.05 ** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE")	///
	mgroups("Financial Reform" "Bank. Entry Barriers" "Bank. Liberalization" "Deposit Insurance" "Capital Openness", pattern(1 0 1 0 1 0 1 0 1 0 ) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate("Year FE = *year*" "Quadratic Time = time*", label($\checkmark$ ))			///
	noconstant nonotes
eststo clear



*	****************************************************************************
*	C.A9 Table A19 -- Policy Reaction to CBI: Additional Control Variables (v.7)
*	****************************************************************************


eststo: xtreg f.finreform lvaw time time2 loggdp loggdpcap polity2 imf_new, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.finreform lvaw i.year loggdp loggdpcap polity2 imf_new, fe robust
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.entrybarriers lvaw time time2 loggdp loggdpcap polity2 imf_new, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.entrybarriers lvaw i.year loggdp loggdpcap polity2 imf_new, fe robust
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.privatization lvaw time time2 loggdp loggdpcap polity2 imf_new, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.privatization lvaw i.year loggdp loggdpcap polity2 imf_new, fe robust
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.deposit_insurance lvaw time time2 loggdp loggdpcap polity2 imf_new, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.deposit_insurance lvaw i.year loggdp loggdpcap polity2 imf_new, fe robust
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.ckaopen2010 lvaw time time2 loggdp loggdpcap polity2 imf_new, fe robust
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.ckaopen2010 lvaw i.year loggdp loggdpcap polity2 imf_new, fe robust
estadd local fixed "$\checkmark$" , replace

esttab using "App_TableA19.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.05 ** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE")	///
	mgroups("Financial Reform" "Bank. Entry Barriers" "Bank. Liberalization" "Deposit Insurance" "Capital Openness", pattern(1 0 1 0 1 0 1 0 1 0 ) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate("Year FE = *year*" "Quadratic Time = time*", label($\checkmark$ ))			///
	noconstant nonotes
eststo clear


*	****************************************************************************
*	C.A9 Table A20 -- Policy Reaction to CBI: All Countries, Controlling for Exchange Rate Policy
*	****************************************************************************


eststo: xtreg f.finreform lvaw time time2 i.pegtype, fe cluster(ccode)
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

eststo: xtreg f.entrybarriers lvaw time time2 i.pegtype, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.entrybarriers lvaw time time2 loggdp loggdpcap polity2 i.pegtype, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.entrybarriers lvaw i.year loggdp loggdpcap polity2 i.pegtype, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.privatization lvaw time time2 i.pegtype, fe cluster(ccode)
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

eststo: xtreg f.deposit_insurance lvaw time time2 i.pegtype, fe cluster(ccode)
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

eststo: xtreg f.ckaopen2010 lvaw time time2 i.pegtype, fe cluster(ccode)
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

esttab using "App_TableA20.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.05 ** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE")	///
	mgroups("Financial Reform" "Bank. Entry Barriers" "Bank. Liberalization" "Deposit Insurance" "Capital Openness", pattern(1 0 0 1 0 0 1 0 0 1 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate("Year FE = *year*" "Exchange Rate Cat. = *pegtype*" "Quadratic Time = time*", label($\checkmark$ ))			///
	noconstant nonotes
eststo clear


*	****************************************************************************
*	C.A9 Table A21 -- Policy Reaction to CBI: Democractic Coutries, Controlling for Exchange Rate Policy
*	****************************************************************************


eststo: xtreg f.finreform lvaw time time2 i.pegtype if polity2 >= 6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.finreform lvaw time time2 loggdp loggdpcap polity2 i.pegtype if polity2 >= 6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.finreform lvaw i.year loggdp loggdpcap polity2 i.pegtype if polity2 >= 6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.entrybarriers lvaw time time2 i.pegtype if polity2 >= 6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.entrybarriers lvaw time time2 loggdp loggdpcap polity2 i.pegtype if polity2 >= 6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.entrybarriers lvaw i.year loggdp loggdpcap polity2 i.pegtype if polity2 >= 6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.privatization lvaw time time2 i.pegtype if polity2 >= 6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.privatization lvaw time time2 loggdp loggdpcap polity2 i.pegtype if polity2 >= 6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.privatization lvaw i.year loggdp loggdpcap polity2 i.pegtype if polity2 >= 6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.deposit_insurance lvaw time time2 i.pegtype if polity2 >= 6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.deposit_insurance lvaw time time2 loggdp loggdpcap polity2 i.pegtype if polity2 >= 6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.deposit_insurance lvaw i.year loggdp loggdpcap polity2 i.pegtype if polity2 >= 6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.ckaopen2010 lvaw time time2 i.pegtype if polity2 >= 6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.ckaopen2010 lvaw time time2 loggdp loggdpcap polity2 i.pegtype if polity2 >= 6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.ckaopen2010 lvaw i.year loggdp loggdpcap polity2 i.pegtype if polity2 >= 6 , fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

esttab using "App_TableA21.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.05 ** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE")	///
	mgroups("Financial Reform" "Bank. Entry Barriers" "Bank. Liberalization" "Deposit Insurance" "Capital Openness", pattern(1 0 0 1 0 0 1 0 0 1 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate("Year FE = *year*" "Exchange Rate Cat. = *pegtype*" "Quadratic Time = time*", label($\checkmark$ ))			///
	noconstant nonotes
eststo clear


*	****************************************************************************
*	C.A9 Table A22 -- Policy Reaction to CBI: All Countries, Driscoll-Kraay Standard Errors
*	****************************************************************************


eststo: xtscc f.finreform lvaw time time2 , fe
estadd local fixed "$\checkmark$" , replace
eststo: xtscc f.finreform lvaw time time2 loggdp loggdpcap polity2, fe
estadd local fixed "$\checkmark$" , replace
eststo: xtscc f.finreform lvaw i.year loggdp loggdpcap polity2, fe
estadd local fixed "$\checkmark$" , replace

eststo: xtscc f.entrybarriers lvaw time time2, fe
estadd local fixed "$\checkmark$" , replace
eststo: xtscc f.entrybarriers lvaw time time2 loggdp loggdpcap polity2, fe 
estadd local fixed "$\checkmark$" , replace
eststo: xtscc f.entrybarriers lvaw i.year loggdp loggdpcap polity2, fe 
estadd local fixed "$\checkmark$" , replace

eststo: xtscc f.privatization lvaw time time2, fe
estadd local fixed "$\checkmark$" , replace
eststo: xtscc f.privatization lvaw time time2 loggdp loggdpcap polity2, fe 
estadd local fixed "$\checkmark$" , replace
eststo: xtscc f.privatization lvaw i.year loggdp loggdpcap polity2, fe 
estadd local fixed "$\checkmark$" , replace

eststo: xtscc f.deposit_insurance lvaw time time2, fe
estadd local fixed "$\checkmark$" , replace
eststo: xtscc f.deposit_insurance lvaw time time2 loggdp loggdpcap polity2, fe 
estadd local fixed "$\checkmark$" , replace
eststo: xtscc f.deposit_insurance lvaw i.year loggdp loggdpcap polity2, fe 
estadd local fixed "$\checkmark$" , replace

eststo: xtscc f.ckaopen2010 lvaw time time2, fe
estadd local fixed "$\checkmark$" , replace
eststo: xtscc f.ckaopen2010 lvaw time time2 loggdp loggdpcap polity2, fe
estadd local fixed "$\checkmark$" , replace
eststo: xtscc f.ckaopen2010 lvaw i.year loggdp loggdpcap polity2, fe
estadd local fixed "$\checkmark$" , replace

esttab using "App_TableA22.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.05 ** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE")	///
	mgroups("Financial Reform" "Bank. Entry Barriers" "Bank. Liberalization" "Deposit Insurance" "Capital Openness", pattern(1 0 0 1 0 0 1 0 0 1 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate("Year FE = *year*" "Quadratic Time = time*", label($\checkmark$ ))			///
	noconstant nonotes
eststo clear


*	****************************************************************************
*	C.A9 Table A23 -- Policy Reaction to CBI: Democracies, Driscoll-Kraay Standard Errors
*	****************************************************************************

eststo: xtscc f.finreform lvaw time time2 if polity2 >= 6, fe
estadd local fixed "$\checkmark$" , replace
eststo: xtscc f.finreform lvaw time time2 loggdp loggdpcap polity2 if polity2 >= 6, fe
estadd local fixed "$\checkmark$" , replace
eststo: xtscc f.finreform lvaw i.year loggdp loggdpcap polity2 if polity2 >= 6, fe
estadd local fixed "$\checkmark$" , replace

eststo: xtscc f.entrybarriers lvaw time time2 if polity2 >= 6, fe
estadd local fixed "$\checkmark$" , replace
eststo: xtscc f.entrybarriers lvaw time time2 loggdp loggdpcap polity2 if polity2 >= 6, fe
estadd local fixed "$\checkmark$" , replace
eststo: xtscc f.entrybarriers lvaw i.year loggdp loggdpcap polity2 if polity2 >= 6, fe
estadd local fixed "$\checkmark$" , replace

eststo: xtscc f.privatization lvaw time time2 if polity2 >= 6, fe
estadd local fixed "$\checkmark$" , replace
eststo: xtscc f.privatization lvaw time time2 loggdp loggdpcap polity2 if polity2 >= 6, fe
estadd local fixed "$\checkmark$" , replace
eststo: xtscc f.privatization lvaw i.year loggdp loggdpcap polity2 if polity2 >= 6, fe
estadd local fixed "$\checkmark$" , replace

eststo: xtscc f.deposit_insurance lvaw time time2 if polity2 >= 6, fe 
estadd local fixed "$\checkmark$" , replace
eststo: xtscc f.deposit_insurance lvaw time time2 loggdp loggdpcap polity2 if polity2 >= 6, fe
estadd local fixed "$\checkmark$" , replace
eststo: xtscc f.deposit_insurance lvaw i.year loggdp loggdpcap polity2 if polity2 >= 6, fe
estadd local fixed "$\checkmark$" , replace

eststo: xtscc f.ckaopen2010 lvaw time time2 if polity2 >= 6, fe
estadd local fixed "$\checkmark$" , replace
eststo: xtscc f.ckaopen2010 lvaw time time2 loggdp loggdpcap polity2 if polity2 >= 6, fe
estadd local fixed "$\checkmark$" , replace
eststo: xtscc f.ckaopen2010 lvaw i.year loggdp loggdpcap polity2 if polity2 >= 6 , fe 
estadd local fixed "$\checkmark$" , replace

esttab using "App_TableA23.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.05 ** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE")	///
	mgroups("Financial Reform" "Bank. Entry Barriers" "Bank. Liberalization" "Deposit Insurance" "Capital Openness", pattern(1 0 0 1 0 0 1 0 0 1 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate("Year FE = *year*" "Quadratic Time = time*", label($\checkmark$ ))			///
	noconstant nonotes
eststo clear


*	****************************************************************************
*	C.A9 Table A24 -- Endogeneity of CBI: Financial Sector Strength and CBI
*	****************************************************************************

eststo: xtreg f.lvaw lgfdd_deposits i.year loggdp loggdpcap polity2, fe robust
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.lvaw lgfdd_nonfinanceassets i.year loggdp loggdpcap polity2, fe robust
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.lvaw lgfdd_cbassets i.year loggdp loggdpcap polity2, fe robust
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.lvaw lallfinance i.year loggdp loggdpcap polity2, fe robust
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.lvaw gfdd_assetconcentration i.year loggdp loggdpcap polity2, fe robust
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.lvaw lallfinance gfdd_assetconcentration i.year loggdp loggdpcap polity2, fe robust
estadd local fixed "$\checkmark$" , replace


esttab using "App_TableA24.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.05 ** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE")	///
	mgroups("Bank Assets" "Nonbank Assets" "CB Assets" "Concentration" "All Assets" "All Assets/Concentration", pattern(1 1 1 1 1 1) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate("Year FE = *year*", label($\checkmark$ ))			///
	noconstant nonotes
eststo clear

*	****************************************************************************
*	C.A9 Table A25 -- Policy Reaction to CBI: Capital Inflows vs. Outflow Restrictions, All Countries
*	****************************************************************************

 
eststo: xtreg f.kc_inflow lvaw time time2, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.kc_inflow lvaw time time2 loggdp loggdpcap polity2, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.kc_inflow lvaw i.year loggdp loggdpcap polity2, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.kc_outflow lvaw time time2, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.kc_outflow lvaw time time2 loggdp loggdpcap polity2, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.kc_outflow lvaw i.year loggdp loggdpcap polity2, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

esttab using "App_TableA25.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.05 ** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE")	///
	mgroups("Capital Inflows" "Capital Outflows", pattern(1 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate(Year FE = *year*, label($\checkmark$ ))	
eststo clear

*	****************************************************************************
*	C.A9 Table A26 -- Policy Reaction to CBI: Capital Inflows vs. Outflow Restrictions, Democracies
*	****************************************************************************


eststo: xtreg f.kc_inflow lvaw time time2 if polity2 >= 6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.kc_inflow lvaw time time2 loggdp loggdpcap polity2 if polity2 >= 6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.kc_inflow lvaw i.year loggdp loggdpcap polity2 if polity2 >= 6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.kc_outflow lvaw time time2 if polity2 >= 6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.kc_outflow lvaw time time2 loggdp loggdpcap polity2 if polity2 >= 6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.kc_outflow lvaw i.year loggdp loggdpcap polity2 if polity2 >= 6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

esttab using "App_TableA26.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.05 ** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE")	///
	mgroups("Capital Inflows" "Capital Outflows", pattern(1 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate(Year FE = *year*, label($\checkmark$ ))	
eststo clear



*	****************************************************************************
*	C.A10 Table A27 -- Policy Reaction to CBI: All Countries, ECM
*	****************************************************************************

* New variables for ECMs
gen l_dv_finreform = l.finreform
gen l_dv_entrybarriers = l.entrybarriers
gen l_dv_privatization = l.privatization
gen l_dv_deposit_insurance = l.deposit_insurance
gen l_dv_ckaopen2010 = l.ckaopen2010 
gen dlvaw = d.lvaw 
gen dloggdp = d.loggdp 
gen dloggdpcap = d.loggdpcap 
gen dpolity2 = d.polity2 

label var dlvaw "$\Delta$ CBI"
label var llvaw "CBI (t-1)"
label var dloggdp "$\Delta$ GDP (log)"
label var lloggdp "GDP (log) (t-1)"
label var dloggdpcap  "$\Delta$ GDP/cap (log)"
label var lloggdpcap "GDP/cap (log) (t-1)"
label var dpolity2  "$\Delta$ Democracy"
label var lpolity2 "Democracy (t-1)"

eststo: xtreg d.finreform l_dv_finreform dlvaw llvaw , fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg d.finreform l_dv_finreform dlvaw llvaw dloggdp lloggdp dloggdpcap lloggdpcap dpolity2 lpolity2, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg d.entrybarriers l_dv_entrybarriers dlvaw llvaw, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg d.entrybarriers l_dv_entrybarriers dlvaw llvaw dloggdp lloggdp dloggdpcap lloggdpcap dpolity2 lpolity2, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg d.privatization l_dv_privatization dlvaw llvaw, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg d.privatization l_dv_privatization dlvaw llvaw dloggdp lloggdp dloggdpcap lloggdpcap dpolity2 lpolity2, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg d.deposit_insurance l_dv_deposit_insurance dlvaw llvaw, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg d.deposit_insurance l_dv_deposit_insurance dlvaw llvaw dloggdp lloggdp dloggdpcap lloggdpcap dpolity2 lpolity2, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg d.ckaopen2010 l_dv_ckaopen2010 dlvaw llvaw, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg d.ckaopen2010 l_dv_ckaopen2010 dlvaw llvaw dloggdp lloggdp dloggdpcap lloggdpcap dpolity2 lpolity2, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

esttab using "App_TableA27.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.05 ** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE")	///
	mgroups("Financial Reform" "Bank. Entry Barriers" "Bank. Liberalization" "Deposit Insurance" "Capital Openness", pattern(1 0 1 0 1 0 1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	noconstant nonotes rename(l_dv_entrybarriers LDV l_dv_finreform LDV l_dv_privatization LDV l_dv_finreform LDV l_dv_deposit_insurance LDV l_dv_finreform LDV l_dv_ckaopen2010 LDV l_dv_finreform LDV)
eststo clear



*	****************************************************************************
*	C.A10 Table A28 -- Policy Reaction to CBI: Democratic Countries, ECM
*	****************************************************************************

eststo: xtreg d.finreform l_dv_finreform dlvaw llvaw if polity2 >= 6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg d.finreform l_dv_finreform dlvaw llvaw dloggdp lloggdp dloggdpcap lloggdpcap dpolity2 lpolity2 if polity2 >= 6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg d.entrybarriers l_dv_entrybarriers dlvaw llvaw if polity2 >= 6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg d.entrybarriers l_dv_entrybarriers dlvaw llvaw dloggdp lloggdp dloggdpcap lloggdpcap dpolity2 lpolity2 if polity2 >= 6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg d.privatization l_dv_privatization dlvaw llvaw if polity2 >= 6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg d.privatization l_dv_privatization dlvaw llvaw dloggdp lloggdp dloggdpcap lloggdpcap dpolity2 lpolity2 if polity2 >= 6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg d.deposit_insurance l_dv_deposit_insurance dlvaw llvaw if polity2 >= 6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg d.deposit_insurance l_dv_deposit_insurance dlvaw llvaw dloggdp lloggdp dloggdpcap lloggdpcap dpolity2 lpolity2 if polity2 >= 6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg d.ckaopen2010 l_dv_ckaopen2010 dlvaw llvaw if polity2 >= 6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg d.ckaopen2010 l_dv_ckaopen2010 dlvaw llvaw dloggdp lloggdp dloggdpcap lloggdpcap dpolity2 lpolity2 if polity2 >= 6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

esttab using "App_TableA28.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.05 ** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE")	///
	mgroups("Financial Reform" "Bank. Entry Barriers" "Bank. Liberalization" "Deposit Insurance" "Capital Openness", pattern(1 0 1 0 1 0 1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	noconstant nonotes rename(l_dv_entrybarriers LDV l_dv_finreform LDV l_dv_privatization LDV l_dv_finreform LDV l_dv_deposit_insurance LDV l_dv_finreform LDV l_dv_ckaopen2010 LDV l_dv_finreform LDV)
eststo clear



*	****************************************************************************
*	C.A10 Table A29 -- Credit Cycles
*	****************************************************************************


/*
The below measures are deviations from trend of real credit. 

t33 Private Bank Credit (=private means that it is the private sector that borrows)
t44 Private Non-Bank Credit
t66 Private Credit (=sum of bank and non-bank credit)

*/


gen elec_x_lvaw = election#c.lvaw
label var elec_x_lvaw "Election*CBI"


eststo: xtreg t33 election lvaw elec_x_lvaw i.year, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg t33 election lvaw elec_x_lvaw i.year loggdp loggdpcap polity2, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg t66 election lvaw elec_x_lvaw i.year, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg t66 election lvaw elec_x_lvaw i.year loggdp loggdpcap polity2, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg t33 election lvaw elec_x_lvaw i.year if polity2>=6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg t33 election lvaw elec_x_lvaw i.year loggdp loggdpcap polity2 if polity2>=6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg t66 election lvaw elec_x_lvaw i.year if polity2>=6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg t66 election lvaw elec_x_lvaw i.year loggdp loggdpcap polity2 if polity2>=6, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace


esttab using "App_TableA29.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.05 ** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE")	///
	mgroups("Bank Credit (All)" "Aggregate Credit (All)" "Bank Credit (Dem)" "Aggregate Credit (Dem)", pattern(1 0 1 0 1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate("Year FE = *year*", label($\checkmark$ ))			///
	noconstant nonotes
eststo clear


*	****************************************************************************
*	C.A12 Table A30 -- Policy Reaction to CBI: Bank Supervision Authorities
*	****************************************************************************

* Reclassifying and adding several interaction effects. See manuscript
* for details.

gen CBISIndexAlt = .
replace CBISIndexAlt = 1 if CBISIndex == 1 | CBISIndex == 2
replace CBISIndexAlt = 2 if CBISIndex == 3 | CBISIndex == 4
replace CBISIndexAlt = 3 if CBISIndex == 5 | CBISIndex == 6

quiet tab CBISIndexAlt, gen(cbinv)
label var cbinv1 "Low Central Bank Involvement"
label var cbinv2 "Medium Central Bank Involvement"
label var cbinv3 "High Central Bank Involvement"

gen cbinv1_x_lvaw = cbinv1*lvaw
label var cbinv1_x_lvaw "Low CB Involv. * CBI"
gen cbinv2_x_lvaw = cbinv2*lvaw
label var cbinv2_x_lvaw "Medium CB Involv. * CBI"
gen cbinv3_x_lvaw = cbinv3*lvaw
label var cbinv3_x_lvaw "High CB Involv. * CBI"

quiet tab regioncode, gen(regiond)

eststo: reg f.finreform lvaw cbinv2_x_lvaw cbinv3_x_lvaw cbinv2 cbinv3 loggdp loggdpcap regiond* polity2, r
eststo: reg f.finreform lvaw cbinv2_x_lvaw cbinv3_x_lvaw cbinv2 cbinv3 loggdp loggdpcap polity2 regiond* i.year,  r
eststo: reg f.finreform lvaw cbinv2_x_lvaw cbinv3_x_lvaw cbinv2 cbinv3 loggdp loggdpcap regiond* if polity2 >= 6, r
eststo: reg f.finreform lvaw cbinv2_x_lvaw cbinv3_x_lvaw cbinv2 cbinv3 loggdp loggdpcap regiond* i.year if polity2 >= 6,  r 

esttab using "App_TableA30.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("OLS" "FE" "OLS" "FE" )	///
	noconstant	///
	indicate("Region FE = regiond*" "Year FE = *year*", label($\checkmark$ ))	///
	mgroups("All Countries" "Democracies", pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	
eststo clear



*	****************************************************************************
*	C.A12 Table A31 -- Policy Reaction to CBI: Interacting CBI and CBIS
*	****************************************************************************

* Generating the interaction effect
gen CBISIndex_x_lvaw = CBISIndex*lvaw

eststo: reg f.finreform lvaw CBISIndex_x_lvaw CBISIndex loggdp loggdpcap polity2, r
eststo: reg f.finreform lvaw CBISIndex_x_lvaw CBISIndex loggdp loggdpcap regiond* polity2, r
eststo: reg f.finreform lvaw CBISIndex_x_lvaw CBISIndex loggdp loggdpcap polity2 regiond* i.year,  r
eststo: reg f.finreform lvaw cbinv2_x_lvaw cbinv3_x_lvaw cbinv2 cbinv3 loggdp loggdpcap polity2, r
eststo: reg f.finreform lvaw cbinv2_x_lvaw cbinv3_x_lvaw cbinv2 cbinv3 loggdp loggdpcap regiond* polity2, r
eststo: reg f.finreform lvaw cbinv2_x_lvaw cbinv3_x_lvaw cbinv2 cbinv3 loggdp loggdpcap polity2 regiond* i.year,  r
eststo: reg f.finreform lvaw cbinv2_x_lvaw cbinv3_x_lvaw cbinv2 cbinv3 loggdp loggdpcap if polity2 >= 6, r
eststo: reg f.finreform lvaw cbinv2_x_lvaw cbinv3_x_lvaw cbinv2 cbinv3 loggdp loggdpcap regiond* if polity2 >= 6, r
eststo: reg f.finreform lvaw cbinv2_x_lvaw cbinv3_x_lvaw cbinv2 cbinv3 loggdp loggdpcap regiond* i.year if polity2 >= 6,  r 

esttab using "App_TableA31.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.05 ** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("OLS" "FE" "FE" "OLS" "FE" "FE" "OLS" "FE" "FE")	///
	noconstant	///
	indicate("Region FE = regiond*" "Year FE = *year*", label($\checkmark$ ))	///
	mgroups("All Countries" "Democracies", pattern(1 0 0 0 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))			///
	noconstant nonotes
eststo clear


*	****************************************************************************
*	C.A12 Table A32 -- Explaining Bank Supervision by Central Banks
*	****************************************************************************

preserve
* Rescaling to facilitate readability
replace sw_vr = sw_vr/100
replace sw_cr = sw_cr/100
replace sw_lr = sw_lr/100
replace sw_gr = sw_gr/100

eststo: xtreg CBISIndexAlt sw_vr i.year, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg CBISIndexAlt sw_vr loggdp loggdpcap  i.year, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg CBISIndexAlt sw_cr i.year, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg CBISIndexAlt sw_cr loggdp loggdpcap  i.year, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg CBISIndexAlt sw_lr i.year, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg CBISIndexAlt sw_lr loggdp loggdpcap  i.year, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg CBISIndexAlt sw_gr i.year, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg CBISIndexAlt sw_gr loggdp loggdpcap  i.year, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

esttab using "App_TableA32.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.05 ** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("fixed Country FE") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "Fe" "FE" "FE" "FE" "Fe" "FE" )	///
	noconstant nonotes	///
	order(sw_vr sw_cr sw_lr sw_gr)	///
	indicate( "Year FE = *year*", label($\checkmark$ ))	///
	mgroups("Votes" "Cabinet" "Legislature" "Government" , pattern(1 0 1 0 1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	
eststo clear
restore



********************************************************************************
*	C.A12 Table A33 -- Controlling for strength of special interests
********************************************************************************

gen pep_x_lvaw = pepinsky_specialinterests*lvaw
label var pepinsky_specialinterests "Finance Interests"
label var pep_x_lvaw "CBI*Finance Interests"

eststo: xtreg f.finreform lvaw pepinsky_specialinterests pep_x_lvaw time time2 , fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.finreform lvaw pepinsky_specialinterests pep_x_lvaw time time2 loggdp loggdpcap polity2, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.finreform lvaw pepinsky_specialinterests pep_x_lvaw i.year loggdp loggdpcap polity2, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.entrybarriers lvaw pepinsky_specialinterests pep_x_lvaw time time2, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.entrybarriers lvaw pepinsky_specialinterests pep_x_lvaw time time2 loggdp loggdpcap polity2, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.entrybarriers lvaw pepinsky_specialinterests pep_x_lvaw i.year loggdp loggdpcap polity2, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.privatization lvaw pepinsky_specialinterests pep_x_lvaw time time2, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.privatization lvaw pepinsky_specialinterests pep_x_lvaw time time2 loggdp loggdpcap polity2, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.privatization lvaw pepinsky_specialinterests pep_x_lvaw i.year loggdp loggdpcap polity2, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.deposit_insurance lvaw pepinsky_specialinterests pep_x_lvaw time time2, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.deposit_insurance lvaw pepinsky_specialinterests pep_x_lvaw time time2 loggdp loggdpcap polity2, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.deposit_insurance lvaw pepinsky_specialinterests pep_x_lvaw i.year loggdp loggdpcap polity2, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.ckaopen2010 lvaw pepinsky_specialinterests pep_x_lvaw time time2, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.ckaopen2010 lvaw pepinsky_specialinterests pep_x_lvaw time time2 loggdp loggdpcap polity2, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.ckaopen2010 lvaw pepinsky_specialinterests pep_x_lvaw i.year loggdp loggdpcap polity2, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

esttab using "App_TableA33.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.05 ** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE")	///
	mgroups("Financial Reform" "Bank. Entry Barriers" "Bank. Liberalization" "Deposit Insurance" "Capital Openness", pattern(1 0 0 1 0 0 1 0 0 1 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate("Year FE = *year*" "Quadratic Time = time*", label($\checkmark$ ))			///
	noconstant nonotes
eststo clear

*	****************************************************************************
*	C.A14 Table A34 -- Instrumental Variable Approach
*	Note: the table in the pdf was manually created to facilitate the reader's
*	experience. This code gives the raw estimates that were used to 
*	populate it: 
*		App_TableA34_PanelA.tex was used to create App_TableA34_PanelA_MANUAL.tex
*		App_TableA34_PanelB.tex was used to create App_TableA34_PanelB_MANUAL.tex
*	****************************************************************************

*	xtivreg2 doesn't accept indicators.
quiet tab year, gen(yeard)

* 	Dropping obs to make samples comparable
preserve

gen flag1 = 0
gen flag2 = 0
gen flag3 = 0
gen flag4 = 0
gen flag5 = 0

quiet xtivreg2 f.finreform yeard* loggdp loggdpcap polity2 (lvaw=resourcerentscap), fe robust
replace flag1 = 1 if e(sample)==1
quiet xtivreg2 f.deposit_insurance yeard* loggdp loggdpcap polity2 (lvaw=resourcerentscap), fe robust
replace flag2 = 1 if e(sample)==1
quiet xtivreg2 f.ckaopen2010 yeard* loggdp loggdpcap polity2 (lvaw=resourcerentscap), fe robust  first
replace flag3 = 1 if e(sample)==1
quiet xtivreg2 f.privatization yeard* loggdp loggdpcap polity2 (lvaw=resourcerentscap), fe robust  first
replace flag4 = 1 if e(sample)==1
quiet xtivreg2 f.entrybarriers yeard* loggdp loggdpcap polity2 (lvaw=resourcerentscap), fe robust  first
replace flag5 = 1 if e(sample)==1

drop if flag1==0 | flag2==0 | flag3==0 | flag4 == 0 | flag5 == 0

eststo: xtivreg2 f.finreform time time2 loggdp loggdpcap polity2 (lvaw=resourcerentscap), fe robust first
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.finreform yeard* loggdp loggdpcap polity2 (lvaw=resourcerentscap), fe robust first
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.entrybarriers time time2 loggdp loggdpcap polity2 (lvaw=resourcerentscap), fe robust first
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.entrybarriers yeard* loggdp loggdpcap polity2 (lvaw=resourcerentscap), fe robust first
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.privatization time time2 loggdp loggdpcap polity2 (lvaw=resourcerentscap), fe robust  first
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.privatization yeard* loggdp loggdpcap polity2 (lvaw=resourcerentscap), fe robust  first
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.deposit_insurance time time2 loggdp loggdpcap polity2 (lvaw=resourcerentscap), fe robust  first
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.deposit_insurance yeard* loggdp loggdpcap polity2 (lvaw=resourcerentscap), fe robust  first
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.ckaopen2010 time time2 loggdp loggdpcap polity2 (lvaw=resourcerentscap), fe robust  first
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.ckaopen2010 yeard* loggdp loggdpcap polity2 (lvaw=resourcerentscap), fe robust  first
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
esttab using "App_TableA34_PanelA.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.05 ** 0.01) ///
	substitute(m$ m\\$)	///
	mtitles("IV" "IV" "IV" "IV" "IV" "IV" "IV" "IV" "IV" "IV" "IV" "IV")	///
	keep(lvaw)	///
	compress nogaps scalars("Ftest F-Test (1st Stage)" "N_g $\#$ Countries" "fixed Country FE" ) sfmt(%9.2f %9.0f) ///
	mgroups("Fin. Reform" "Bank. Entry Barriers" "Bank. Lib." "Deposit Ins." "Capital Contr." , pattern(1 0 1 0 1 0 1 0 1 0 1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))			///
 	indicate("Year FE = *yeard*" "Quadratic Time = time*", label($\checkmark$ ))	///
	noconstant nonotes
eststo clear

restore


* 	Dropping obs to make samples comparable
preserve

gen flag1 = 0
gen flag2 = 0
gen flag3 = 0
gen flag4 = 0
gen flag5 = 0

quiet xtivreg2 f.finreform yeard* loggdp loggdpcap polity2 (lvaw=resourcerentscap) if polity2 >= 6, fe robust
replace flag1 = 1 if e(sample)==1
quiet xtivreg2 f.deposit_insurance yeard* loggdp loggdpcap polity2 (lvaw=resourcerentscap) if polity2 >= 6, fe robust
replace flag2 = 1 if e(sample)==1
quiet xtivreg2 f.ckaopen2010 yeard* loggdp loggdpcap polity2 (lvaw=resourcerentscap) if polity2 >= 6, fe robust 
replace flag3 = 1 if e(sample)==1
quiet xtivreg2 f.entrybarriers yeard* loggdp loggdpcap polity2 (lvaw=resourcerentscap) if polity2 >= 6, fe robust 
replace flag4 = 1 if e(sample)==1
quiet xtivreg2 f.privatization yeard* loggdp loggdpcap polity2 (lvaw=resourcerentscap) if polity2 >= 6, fe robust 
replace flag5 = 1 if e(sample)==1


drop if flag1==0 | flag2==0 | flag3==0 | flag4==0 | flag5==0 

eststo: xtivreg2 f.finreform time time2 loggdp loggdpcap polity2 (lvaw=resourcerentscap) if polity2 >= 6, fe robust first
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.finreform yeard* loggdp loggdpcap polity2 (lvaw=resourcerentscap) if polity2 >= 6, fe robust first
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.entrybarriers time time2  loggdp loggdpcap polity2 (lvaw=resourcerentscap) if polity2 >= 6, fe robust first
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.entrybarriers yeard* loggdp loggdpcap polity2 (lvaw=resourcerentscap) if polity2 >= 6, fe robust first
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" 
eststo: xtivreg2 f.privatization time time2 loggdp loggdpcap polity2 (lvaw=resourcerentscap) if polity2 >= 6, fe robust first
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.privatization yeard* loggdp loggdpcap polity2 (lvaw=resourcerentscap) if polity2 >= 6, fe robust first
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.deposit_insurance time time2 loggdp loggdpcap polity2 (lvaw=resourcerentscap) if polity2 >= 6, fe robust first
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.deposit_insurance yeard* loggdp loggdpcap polity2 (lvaw=resourcerentscap) if polity2 >= 6, fe robust first
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.ckaopen2010 time time2 loggdp loggdpcap polity2 (lvaw=resourcerentscap) if polity2 >= 6, fe robust first
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.ckaopen2010 yeard* loggdp loggdpcap polity2 (lvaw=resourcerentscap) if polity2 >= 6, fe robust first
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace

esttab using "App_TableA34_PanelB.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.05 ** 0.01) ///
	substitute(m$ m\\$)	///
	mtitles("IV" "IV" "IV" "IV" "IV" "IV" "IV" "IV" "IV" "IV")	///
	keep(lvaw)	///
	compress nogaps scalars("Ftest F-Test (1st Stage)" "fixed Country FE" "N_g $\#$ Countries") sfmt(%9.2f %9.0f) ///
	mgroups("Fin. Reform" "Bank. Entry Barriers" "Bank. Lib." "Deposit Ins." "Capital Contr.", pattern(1 0 1 0 1 0 1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))			///
 	indicate("Year FE = *yeard*" "Quadratic Time = time*", label($\checkmark$ ))	///
	noconstant nonotes
eststo clear

restore




*	****************************************************************************
*	C.A14 Table A35 -- Instrumental Variable Approach: Additional Channels,
*	all countries
*	****************************************************************************

* Dropping obs to make samples comparable
preserve

gen flag1 = 0
gen flag2 = 0
gen flag3 = 0
gen flag4 = 0
gen flag5 = 0

quiet xtivreg2 f.finreform yeard* loggdp loggdpcap polity2 (lvaw=resourcerentscap), fe robust
replace flag1 = 1 if e(sample)==1
quiet xtivreg2 f.deposit_insurance yeard* loggdp loggdpcap polity2 (lvaw=resourcerentscap), fe robust
replace flag2 = 1 if e(sample)==1
quiet xtivreg2 f.ckaopen2010 yeard* loggdp loggdpcap polity2 (lvaw=resourcerentscap), fe robust  first
replace flag3 = 1 if e(sample)==1
quiet xtivreg2 f.privatization yeard* loggdp loggdpcap polity2 (lvaw=resourcerentscap), fe robust  first
replace flag4 = 1 if e(sample)==1
quiet xtivreg2 f.entrybarriers yeard* loggdp loggdpcap polity2 (lvaw=resourcerentscap), fe robust  first
replace flag5 = 1 if e(sample)==1


drop if flag1==0 | flag2==0 | flag3==0 | flag4 == 0 | flag5 == 0

eststo: xtivreg2 f.finreform time time2 loggdp loggdpcap avh logxr logccon ecopodata113 wdi_taxrev lallfinance urate polity2 corruption demaccountability politicalriskr bureaucracyqa imf (lvaw=resourcerentscap), fe robust first
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.finreform yeard* loggdp loggdpcap avh logxr logccon ecopodata113 wdi_taxrev lallfinance urate polity2 corruption demaccountability politicalriskr bureaucracyqa imf (lvaw=resourcerentscap), fe robust first
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.entrybarriers time time2 loggdp loggdpcap avh logxr logccon ecopodata113 wdi_taxrev lallfinance urate polity2 corruption demaccountability politicalriskr bureaucracyqa imf (lvaw=resourcerentscap), fe robust first
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.entrybarriers yeard* loggdp loggdpcap avh logxr logccon ecopodata113 wdi_taxrev lallfinance urate polity2 corruption demaccountability politicalriskr bureaucracyqa imf (lvaw=resourcerentscap), fe robust first
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.privatization time time2 loggdp loggdpcap avh logxr logccon ecopodata113 wdi_taxrev lallfinance urate polity2 corruption demaccountability politicalriskr bureaucracyqa imf (lvaw=resourcerentscap), fe robust  first
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.privatization yeard* loggdp loggdp loggdpcap avh logxr logccon ecopodata113 wdi_taxrev lallfinance urate polity2 corruption demaccountability politicalriskr bureaucracyqa imf (lvaw=resourcerentscap), fe robust  first
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.deposit_insurance time time2 loggdp loggdpcap avh logxr logccon ecopodata113 wdi_taxrev lallfinance urate polity2 corruption demaccountability politicalriskr bureaucracyqa imf (lvaw=resourcerentscap), fe robust  first
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.deposit_insurance yeard* loggdp loggdp loggdpcap avh logxr logccon ecopodata113 wdi_taxrev lallfinance urate polity2 corruption demaccountability politicalriskr bureaucracyqa imf (lvaw=resourcerentscap), fe robust  first
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.ckaopen2010 time time2 loggdp loggdpcap avh logxr logccon ecopodata113 wdi_taxrev lallfinance urate polity2 corruption demaccountability politicalriskr bureaucracyqa imf (lvaw=resourcerentscap), fe robust  first
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.ckaopen2010 yeard* loggdp loggdpcap avh logxr logccon ecopodata113 wdi_taxrev lallfinance urate polity2 corruption demaccountability politicalriskr bureaucracyqa imf (lvaw=resourcerentscap), fe robust  first
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
esttab using "App_TableA35.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.05 ** 0.01) ///
	substitute(m$ m\\$)	///
	mtitles("IV" "IV" "IV" "IV" "IV" "IV" "IV" "IV" "IV" "IV" "IV" "IV")	///
	compress nogaps scalars("Ftest F-Test (1st Stage)" "N_g $\#$ Countries" "fixed Country FE" ) sfmt(%9.2f %9.0f) ///
	mgroups("Fin. Reform" "Bank. Entry Barriers" "Bank. Lib." "Deposit Ins." "Capital Contr." , pattern(1 0 1 0 1 0 1 0 1 0 1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))			///
 	indicate("Year FE = *yeard*" "Quadratic Time = time*", label($\checkmark$ ))	///
	noconstant nonotes
eststo clear
restore


*	****************************************************************************
*	C.A14 Table A36 -- Instrumental Variable Approach: Additional Channels,
*	democracies
*	****************************************************************************

* Dropping obs to make samples comparable
preserve

gen flag1 = 0
gen flag2 = 0
gen flag3 = 0
gen flag4 = 0
gen flag5 = 0

quiet xtivreg2 f.finreform yeard* loggdp loggdpcap polity2 (lvaw=resourcerentscap) if polity2 >= 6, fe robust
replace flag1 = 1 if e(sample)==1
quiet xtivreg2 f.deposit_insurance yeard* loggdp loggdpcap polity2 (lvaw=resourcerentscap) if polity2 >= 6, fe robust
replace flag2 = 1 if e(sample)==1
quiet xtivreg2 f.ckaopen2010 yeard* loggdp loggdpcap polity2 (lvaw=resourcerentscap) if polity2 >= 6, fe robust 
replace flag3 = 1 if e(sample)==1
quiet xtivreg2 f.entrybarriers yeard* loggdp loggdpcap polity2 (lvaw=resourcerentscap) if polity2 >= 6, fe robust 
replace flag4 = 1 if e(sample)==1
quiet xtivreg2 f.privatization yeard* loggdp loggdpcap polity2 (lvaw=resourcerentscap) if polity2 >= 6, fe robust 
replace flag5 = 1 if e(sample)==1

drop if flag1==0 | flag2==0 | flag3==0 | flag4==0 | flag5==0 
   

eststo: xtivreg2 f.finreform time time2 loggdp loggdpcap avh logxr logccon ecopodata113 wdi_taxrev lallfinance urate polity2 corruption demaccountability politicalriskr bureaucracyqa imf (lvaw=resourcerentscap) if polity2 >= 6, fe robust first
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.finreform yeard* loggdp loggdpcap avh logxr logccon ecopodata113 wdi_taxrev lallfinance urate polity2 corruption demaccountability politicalriskr bureaucracyqa imf (lvaw=resourcerentscap) if polity2 >= 6, fe robust first
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.entrybarriers time time2 loggdp loggdpcap avh logxr logccon ecopodata113 wdi_taxrev lallfinance urate polity2 corruption demaccountability politicalriskr bureaucracyqa imf (lvaw=resourcerentscap) if polity2 >= 6, fe robust first
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.entrybarriers yeard* loggdp loggdpcap avh logxr logccon ecopodata113 wdi_taxrev lallfinance urate polity2 corruption demaccountability politicalriskr bureaucracyqa imf (lvaw=resourcerentscap) if polity2 >= 6, fe robust first
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" 
eststo: xtivreg2 f.privatization time time2 loggdp loggdpcap avh logxr logccon ecopodata113 wdi_taxrev lallfinance urate polity2 corruption demaccountability politicalriskr bureaucracyqa imf (lvaw=resourcerentscap) if polity2 >= 6, fe robust first
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.privatization yeard* loggdp loggdpcap avh logxr logccon ecopodata113 wdi_taxrev lallfinance urate polity2 corruption demaccountability politicalriskr bureaucracyqa imf (lvaw=resourcerentscap) if polity2 >= 6, fe robust first
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.deposit_insurance time time2 loggdp loggdpcap avh logxr logccon ecopodata113 wdi_taxrev lallfinance urate polity2 corruption demaccountability politicalriskr bureaucracyqa imf (lvaw=resourcerentscap) if polity2 >= 6, fe robust first
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.deposit_insurance yeard* loggdp loggdpcap avh logxr logccon ecopodata113 wdi_taxrev lallfinance urate polity2 corruption demaccountability politicalriskr bureaucracyqa imf (lvaw=resourcerentscap) if polity2 >= 6, fe robust first
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.ckaopen2010 time time2 loggdp loggdpcap avh logxr logccon ecopodata113 wdi_taxrev lallfinance urate polity2 corruption demaccountability politicalriskr bureaucracyqa imf (lvaw=resourcerentscap) if polity2 >= 6, fe robust first
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.ckaopen2010 yeard* loggdp loggdpcap avh logxr logccon ecopodata113 wdi_taxrev lallfinance urate polity2 corruption demaccountability politicalriskr bureaucracyqa imf (lvaw=resourcerentscap) if polity2 >= 6, fe robust first
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace

esttab using "App_TableA36.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.05 ** 0.01) ///
	substitute(m$ m\\$)	///
	mtitles("IV" "IV" "IV" "IV" "IV" "IV" "IV" "IV" "IV" "IV")	///
	compress nogaps scalars("Ftest F-Test (1st Stage)" "fixed Country FE" "N_g $\#$ Countries") sfmt(%9.2f %9.0f) ///
	mgroups("Fin. Reform" "Bank. Entry Barriers" "Bank. Lib." "Deposit Ins." "Capital Contr.", pattern(1 0 1 0 1 0 1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))			///
 	indicate("Year FE = *year*" "Quadratic Time = time*", label($\checkmark$ ))	///
	noconstant nonotes
eststo clear
restore
*/

*	****************************************************************************
*	D. Figures 
*	****************************************************************************


*	****************************************************************************
*	D.A9 -- Figure A1 Share of countries in a given year that have a central 
*	bank independence index above 0.5 (on a scale from 0 to 1). 
*	****************************************************************************

preserve
gen lvaw_above5 = .
replace lvaw_above5 = 0 if lvaw < 0.5
replace lvaw_above5 = 1 if lvaw >= 0.5 & lvaw != .

collapse (mean) lvaw lvaw_above5, by(year)

sum lvaw_above5 if year == 1980
sum lvaw_above5 if year == 2015

twoway	///
	(tsline lvaw_above5 if year >= 1980) ///
		,	///
		xtitle("Year")	///
		ytitle("Share of countries with CBI index above 0.5")	///
		ylabel(0(0.2)1)	///
		legend(position(6))	
graph export "App_FigureA1.pdf", replace as(pdf)

restore


*	****************************************************************************
*	D.A9 -- Figure A2 Semiparametric estimates of the effect of CBI on the main outcomes.
*	****************************************************************************

* semipar and plausexog don't accept indicators
quiet tab countryname, gen(countryd)


preserve
* Dropping to reduce computation
drop if finreform == . | lvaw == . | loggdp == . | loggdpcap == . | polity2 == . 
semipar finreform lvaw loggdp loggdpcap polity2 countryd* yeard*	///
	, nonpar(lvaw) ci 	///
	cluster(ccode) 	///
	xtitle("CBI")	///
	ytitle("Financial Reform")
graph export "App_FigureA2_a.pdf", replace as(pdf)
restore

preserve
* Dropping to reduce computation
drop if entrybarriers == . | lvaw == . | loggdp == . | loggdpcap == . | polity2 == . 
semipar entrybarriers lvaw loggdp loggdpcap polity2 countryd* yeard*	///
	, nonpar(lvaw) ci 	///
	cluster(ccode) 	///
	xtitle("CBI")	///
	ytitle("Bank Entry Barriers")
graph export "App_FigureA2_b.pdf", replace as(pdf)
restore

preserve
* Dropping to reduce computation
drop if privatization == . | lvaw == . | loggdp == . | loggdpcap == . | polity2 == . 
semipar privatization lvaw loggdp loggdpcap polity2 countryd* yeard*	///
	, nonpar(lvaw) ci 	///
	cluster(ccode) 	///
	xtitle("CBI")	///
	ytitle("Bank Liberalization")
graph export "App_FigureA2_c.pdf", replace as(pdf)
restore

preserve
* Dropping to reduce computation
drop if deposit_insurance == . | lvaw == . | loggdp == . | loggdpcap == . | polity2 == . 
semipar deposit_insurance lvaw loggdp loggdpcap polity2 countryd* yeard*	///
	, nonpar(lvaw) ci 	///
	cluster(ccode) 	///
	xtitle("CBI")	///
	ytitle("Deposit Insurance")
graph export "App_FigureA2_d.pdf", replace as(pdf)
restore

preserve
* Dropping to reduce computation
drop if ckaopen2010 == . | lvaw == . | loggdp == . | loggdpcap == . | polity2 == . 
semipar ckaopen2010 lvaw loggdp loggdpcap polity2 countryd* yeard*	///
	, nonpar(lvaw) ci 	///
	cluster(ccode) 	///
	xtitle("CBI")	///
	ytitle("Capital Openness")
graph export "App_FigureA2_e.pdf", replace as(pdf)
restore


*	****************************************************************************
*	D.A9 -- Figure A3 Credit Cycles
*	****************************************************************************

xtreg t33 election lvaw elec_x_lvaw i.year loggdp loggdpcap polity2, fe cluster(ccode)
eststo d1

xtreg t66 election lvaw elec_x_lvaw i.year loggdp loggdpcap polity2, fe cluster(ccode)
eststo d3

coefplot (d1,  label("Private Bank Credit") ) 	///
		(d3, label("Private Aggregate Credit") )	///
			, keep(lvaw elec_x_lvaw) xline(0, lpattern(solid)) aseq  ///
			 levels(95) ///
			xtitle("Credit Growth (%)") ///
			coeflabels(lvaw="Effect of CBI in off-election years" elec_x_lvaw="Additional effect in election years")	///
			legend(rows(1) position(6))
graph export "App_FigureA3.pdf", replace as(pdf)
eststo clear

*	****************************************************************************
*	D.A11 -- Figure 4 PVAR Results -- Impulse response functions
*	Need to install .pvar from 
*	https://sites.google.com/a/hawaii.edu/inessalove/home/pvar
*	****************************************************************************

* Impulse response functions panel VAR (pvar)

* Run the model
pvar lvaw finreform, exog(loggdp loggdpcap polity2) vce(robust)

* What explains what
pvarfevd, mc(200)

* Compute the IRF
pvarirf	///
	, oirf mc(200) step(5) ///
	impulse(lvaw) response(finreform) ///
	xtitle("Years after shock")	///
	ytitle("Change in Regulation")	///
	legend(off)	///
	title() 
graph export "App_FigureA4.pdf", replace as(pdf)




*	****************************************************************************
*	D.A14 -- Figure 5 Conley, Hansen, and Rossi (2010) sensitivity tests (via plausexog)
*	****************************************************************************

plausexog uci f.finreform loggdp loggdpcap polity2 countryd* time time2 (lvaw=resourcerentscap)	///
	, vce(robust) gmin(0) gmax(-0.3)  graph(lvaw) yline(0) xtitle(Delta)
graph export "App_FigureA5_PanelA.pdf", replace as(pdf)

plausexog uci f.entrybarriers loggdp loggdpcap polity2 countryd*  time time2 (lvaw=resourcerentscap)	///
	, vce(robust) gmin(0) gmax(-0.3)  graph(lvaw) yline(0) xtitle(Delta)
graph export "App_FigureA5_PanelB.pdf", replace as(pdf)

plausexog uci f.privatization loggdp loggdpcap polity2 countryd* time time2(lvaw=resourcerentscap)	///
	, vce(robust) gmin(0) gmax(-0.3)  graph(lvaw) yline(0) xtitle(Delta)
graph export "App_FigureA5_PanelC.pdf", replace as(pdf)

plausexog uci f.deposit_insurance loggdp loggdpcap polity2 countryd* time time2 (lvaw=resourcerentscap)	///
	,  gmin(0) gmax(-0.3) graph(lvaw) yline(0) xtitle(Delta) 
graph export "App_FigureA5_PanelD.pdf", replace as(pdf)

plausexog uci f.ckaopen2010 loggdp loggdpcap polity2 countryd* time time2 (lvaw=resourcerentscap)	///
	,  gmin(0) gmax(-0.3) graph(lvaw) yline(0) xtitle(Delta)
graph export "App_FigureA5_PanelE.pdf", replace as(pdf)





