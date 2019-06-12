*12345678901234567890123456789012345678901234567890123456789012345678901234567890
capture log close
clear all
set more off

*	************************************************************************
* 	File-Name: 	AklinKernReplication.do
*	Log-file:	na
*	Date:  		4/14/2018
*	Author: 	Michaël Aklin and Andreas Kern
*	Data Used:  various
*	Output		AklinKernData.dta
*	Purpose:   	.do file to replicate the results of: 
*				Aklin, Michaël and Andreas Kern. Forthcoming. 
*				"Moral Hazard and Financial Crises: Evidence from US Troop 
*				Deployments." International Studies Quarterly. 
*	Structure:	A. Dataset
*				B. Tables
*				C. Appendix
*					C.1 Tables in the appendix
*					C.2 Figures in the appendix
*	************************************************************************


*	************************************************************************
*	A. Dataset
*	************************************************************************

*	Un-comment working directory: location of the data
*cd "~/Dropbox/AklinKern"
use "./AklinKernData.dta", clear

*	Un-comment working directory: location of the saved tables and figures
*cd "~/Dropbox/AklinKern"

*	************************************************************************
*	B. Tables
*	************************************************************************

*	************************************************************************
*	Table 1
*	************************************************************************

eststo: xtreg f.crisis_any2 logtroops ydummy* if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS time if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.crisis_any2 logtroops if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: logit f.crisis_any2 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS countryd* ydummy* if sample == 1 & oecd == 0

eststo: xtreg f.crisis_any2 logtroops ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS time if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

esttab using "Table1.tex"	///
	,  booktabs label replace ///
 	nodepvars se(3) b(3) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	noconstant ///
	nonotes drop(countryd*)  ///
	compress nogaps scalars("fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "Logit" "FE" "FE" "FE")	///
	mgroups("All Countries" "Non-OECD" "Credit 20-80\% of GDP", pattern(1 0 0 1 0 0 0 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate(Year FE = ydummy*, label($\checkmark$ ))	
eststo clear


*	************************************************************************
*	Table 2
*	************************************************************************

eststo: xtivreg2 f.crisis_any2 loggdpcap logpop ydummy* (logtroops=echolon_alt_DE) if pool == 1 & sample==1, fe  first r
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.crisis_any2 loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS time time2 (logtroops=echolon_alt_DE) if pool == 1 & sample==1, fe  first r
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.crisis_any2 loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS ydummy* (logtroops=echolon_alt_DE) if pool == 1 & sample==1, fe  first r
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.crisis_any2 loggdpcap logpop ecopodata83 ecopodata253 democracy ydummy* (logtroops=echolon_alt_DE) if pool == 1 & sample==1 & e(sample)==1, fe  first r
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace

eststo: xtivreg2 f.crisis_any2 loggdpcap logpop ydummy* (logtroops=echolon_alt_DE) if oecd == 0 & sample==1, fe  first r
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.crisis_any2 loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS time time2 (logtroops=echolon_alt_DE) if oecd == 0 & sample==1, fe  first r
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.crisis_any2 loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS ydummy* (logtroops=echolon_alt_DE) if oecd == 0 & sample==1, fe  first r
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.crisis_any2 loggdpcap logpop ecopodata83 ecopodata253 democracy ydummy* (logtroops=echolon_alt_DE) if oecd == 0 & sample==1 & e(sample)==1, fe  first r
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace

esttab using "Table2.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	noconstant ///
	nonotes ///	
	mtitles("IV" "IV" "IV" "IV" "IV" "IV" "IV" "IV" "IV" "IV" "IV" "IV")	///
	compress nogaps scalars("Ftest F-Test (1st Stage)" "fixed Country FE" "N_g $\#$ Countries") sfmt(%9.2f %9.0f) ///
	mgroups("Regional Subset" "Non-OECD", pattern(1 0 0 0 1 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate("Quadratic Time = time*"  "Year FE = ydummy*", label($\checkmark$ ))	
eststo clear


*	************************************************************************
*	Table 3 (two separate panels)
*	************************************************************************

eststo: reg f.logcon logtroops if sample == 1 & oecd == 0
eststo: xtreg f.logcon logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0, fe
estadd local fixed "$\checkmark$" , replace
eststo: reg f.lra66 logtroops if sample == 1 & oecd == 0
eststo: xtreg f.lra66 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0, fe
estadd local fixed "$\checkmark$" , replace
eststo: reg f.ifs_cbpr logtroops if sample == 1 & oecd == 0 & ifs_cbpr < 24
eststo: xtreg f.ifs_cbpr logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0 & ifs_cbpr < 24, fe
estadd local fixed "$\checkmark$" , replace
eststo: reg f.insurance_onset logtroops if sample == 1 & oecd == 0
eststo: xtreg f.insurance_onset logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0, fe
estadd local fixed "$\checkmark$" , replace
eststo: reg f.steinberg_ckaopen2010 logtroops if sample == 1 & oecd == 0
eststo: xtreg f.steinberg_ckaopen2010 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0, fe
estadd local fixed "$\checkmark$" , replace
esttab using "Table3PanelA.tex"	///
	,  booktabs label replace ///
 	nodepvars se(3) b(3) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	noconstant ///
	nonotes ///	
	compress nogaps scalars("fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	indicate(Year FE = ydummy*, label($\checkmark$ $$$$ ))	///
	mtitles("OLS" "FE" "OLS" "FE" "OLS" "FE" "OLS" "FE" "OLS" "FE")	///
	mgroups("Public Spending" "Public Debt" "CB Policy Rate" "Deposit Insurance" "Capital Openness", pattern(1 0 1 0 1 0 1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))
eststo clear

eststo: reg f.lrd64 logtroops if sample == 1 & oecd == 0
eststo: xtreg f.lrd64 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0, fe
estadd local fixed "$\checkmark$" , replace
eststo: reg f.logliabilities logtroops if sample == 1 & oecd == 0
eststo: xtreg f.logliabilities logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0, fe
estadd local fixed "$\checkmark$" , replace
eststo: reg f.logbank_us logtroops if sample == 1 & oecd == 0
eststo: xtreg f.logbank_us logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0, fe
estadd local fixed "$\checkmark$" , replace
eststo: reg f.financedata57 logtroops if sample == 1 & oecd == 0
eststo: xtreg f.financedata57 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0, fe
estadd local fixed "$\checkmark$" , replace
esttab using "Table3PanelB.tex"	///
	,  booktabs label replace ///
 	nodepvars se(3) b(3) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	noconstant ///
	nonotes ///
	compress nogaps scalars("fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	indicate(Year FE = ydummy*, label($\checkmark$ $$$$ ))	///
	mtitles("OLS" "FE" "OLS" "FE" "OLS" "FE" "OLS" "FE")	///
	mgroups("Private Debt" "Liabilities (log)" "US Bank" "Exchange Rate", pattern(1 0 1 0 1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))
eststo clear

*	************************************************************************
*	C. Appendix
*	************************************************************************

*	************************************************************************
*	C.1 Tables in the Appendix
*	************************************************************************

*	************************************************************************
*	Table A2
*	************************************************************************

preserve
xtreg f.crisis_any2 logtroops if sample == 1, fe 
keep if e(sample) == 1
sum ifs_cbpr if ifs_cbpr < 24, d
quiet estpost sum crisis_any2 logcon lra66 insurance_onset steinberg_ckaopen2010 lrd64 logliabilities logbank_us financedata57 logtroops loggdpcap logpop ecopodata83 ecopodata253 idealdistanceUS democracy time, d
esttab using "TableA2.tex", ///
	cells("mean(label(Mean) fmt(2)) p50(label(Median) fmt(0)) sd(label(S.D.) fmt(2)) min(label(Min.) fmt(0)) max(label(Max) fmt(0)) count(label(Obs.) fmt(0))") ///
	nonumber label replace noobs	///
	substitute(m$ m\\$)	
eststo clear
restore

*	************************************************************************
*	Table A3
*	************************************************************************

quiet xtreg f.crisis_any2 logtroops ydummy*, fe 
estpost sum crisis_any2 logtroops logtroopscapita troopscapita loggdpcap logpop ecopodata83 ecopodata253 idealdistanceUS logbank_us logexportUS unsc idealdistanceRussia war zscore if e(sample) == 1
esttab using "TableA3.tex", ///
	cells("mean(fmt(2)) sd(fmt(2)) min(fmt(0)) max(fmt(0)) count(fmt(0))") ///
	substitute(m$ m\\$)	///
	nonumber label replace
eststo clear

*	************************************************************************
*	Table A4
*	************************************************************************

quiet xtreg f.crisis_any2 logtroops if sample == 1, fe cluster(ccode)
estpost tab countryname if e(sample) == 1, nototal
quiet xtreg f.crisis_any2 logtroops if sample == 1 & oecd == 0, fe cluster(ccode)
estpost tab countryname if e(sample) == 1, nototal
esttab using "TableA4.tex", varlabels(`e(labels)') replace
eststo clear


*	************************************************************************
*	Table A6
*	************************************************************************

eststo: reg f.imfloan logtroops if sample == 1
eststo: xtreg f.imfloan logtroops if sample == 1, fe
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.imfloan logtroops ydummy* if sample == 1, fe
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.imfloan llogtroops ydummy* if sample == 1, fe
estadd local fixed "$\checkmark$" , replace
eststo: reg f.dloggdpcap logtroops if sample == 1 & crisis_any2 == 1
eststo: xtreg f.dloggdpcap logtroops if sample == 1 & crisis_any2 == 1, fe
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.dloggdpcap logtroops ydummy* if sample == 1 & crisis_any2 == 1, fe
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.dloggdpcap llogtroops ydummy* if sample == 1 & crisis_any2 == 1, fe
estadd local fixed "$\checkmark$" , replace
esttab using "TableA6.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	indicate(Year FE = ydummy*, label($\checkmark$ $$$$ ))	///
	mtitles("OLS" "FE" "FE" "FE" "OLS" "FE" "FE" "FE")	///
	mgroups("IMF Loan" "$\Delta$ GPD per Capita (t to t+1)", pattern(1 0 0 0 1 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))
eststo clear


*	************************************************************************
*	Table A7
*	************************************************************************

eststo: xtreg f.crisis_plus logtroops ydummy* if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_plus logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_plus logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.crisis_plus logtroops if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_plus logtroops ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_plus logtroops loggdpcap ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_plus logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_plus logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: probit f.crisis_plus logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0

eststo: xtreg f.crisis_plus logtroops ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_plus logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_plus logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

esttab using "TableA7.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "Probit" "FE" "FE" "FE")	///
	mgroups("All Countries" "Non-OECD" "Credit 20-80\% of GDP", pattern(1 0 0 1 0 0 0 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate(Year FE = ydummy*, label($\checkmark$ ))	
eststo clear


*	************************************************************************
*	Table A8
*	************************************************************************

eststo: xtreg f.sovereign_debt_crisis_external logtroops ydummy* if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.sovereign_debt_crisis_external logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.sovereign_debt_crisis_external logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.sovereign_debt_crisis_external logtroops if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.sovereign_debt_crisis_external logtroops ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.sovereign_debt_crisis_external logtroops loggdpcap ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.sovereign_debt_crisis_external logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.sovereign_debt_crisis_external logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: probit f.sovereign_debt_crisis_external logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0

eststo: xtreg f.sovereign_debt_crisis_external logtroops ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.sovereign_debt_crisis_external logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.sovereign_debt_crisis_external logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

esttab using "TableA8.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "Probit" "FE" "FE" "FE")	///
	mgroups("All Countries" "Non-OECD" "Credit 20-80\% of GDP", pattern(1 0 0 1 0 0 0 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate(Year FE = ydummy*, label($\checkmark$ ))	
eststo clear

*	************************************************************************
*	Table A9
*	************************************************************************

eststo: xtreg f.crisis_onset3 crisis_any2 logtroops ydummy* if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_onset3 crisis_any2 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS time if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_onset3 crisis_any2 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.crisis_onset3 crisis_any2 logtroops if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_onset3 crisis_any2 logtroops ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_onset3 crisis_any2 logtroops loggdpcap ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_onset3 crisis_any2 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_onset3 crisis_any2 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: probit f.crisis_onset3 crisis_any2 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0

eststo: xtreg f.crisis_onset3 crisis_any2 logtroops ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_onset3 crisis_any2 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS time if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_onset3 crisis_any2 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

esttab using "TableA9.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "Probit" "FE" "FE" "FE")	///
	mgroups("All Countries" "Non-OECD" "Credit 20-80\% of GDP", pattern(1 0 0 1 0 0 0 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate(Year FE = ydummy*, label($\checkmark$ ))	
eststo clear

*	************************************************************************
*	Table A10
*	************************************************************************

eststo: xtreg f.sovereign_debt_crisis_external logtroops if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.sovereign_debt_crisis_external logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.sysbank logtroops if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.sysbank logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.currency_crisis logtroops if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.currency_crisis logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.inflation_crisis logtroops if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.inflation_crisis logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.sovereign_debt_crisis_domestic logtroops if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.sovereign_debt_crisis_domestic logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

esttab using "TableA10.tex"	///
	,  booktabs label replace ///
 	nodepvars se(3) b(3) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	noconstant ///
	nonotes  ///
	compress nogaps scalars("fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE")	///
	mgroups("External Debt" "Banking" "Currency" "Inflation" "Dom. Debt", pattern(1 0 1 0 1 0 1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))
eststo clear


*	************************************************************************
*	Table A11
*	************************************************************************

eststo: xtreg f.crisis_any2 logtroopscapita ydummy* if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroopscapita loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroopscapita loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.crisis_any2 logtroopscapita if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroopscapita ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroopscapita loggdpcap ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroopscapita loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroopscapita loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: probit f.crisis_any2 logtroopscapita loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0

eststo: xtreg f.crisis_any2 logtroopscapita ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroopscapita loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroopscapita loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

esttab using "TableA11.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "Probit" "FE" "FE" "FE")	///
	mgroups("All Countries" "Non-OECD" "Credit 20-80\% of GDP", pattern(1 0 0 1 0 0 0 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate(Year FE = ydummy*, label($\checkmark$ ))	
eststo clear


*	************************************************************************
*	Table A12
*	************************************************************************

eststo: xtreg f.crisis_any2 troopscapita ydummy* if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 troopscapita loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 troopscapita loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.crisis_any2 troopscapita if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 troopscapita ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 troopscapita loggdpcap ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 troopscapita loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 troopscapita loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: probit f.crisis_any2 troopscapita loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0

eststo: xtreg f.crisis_any2 troopscapita ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 troopscapita loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 troopscapita loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

esttab using "TableA12.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "Probit" "FE" "FE" "FE")	///
	mgroups("All Countries" "Non-OECD" "Credit 20-80\% of GDP", pattern(1 0 0 1 0 0 0 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate(Year FE = ydummy*, label($\checkmark$ ))	
eststo clear

*	************************************************************************
*	Table A13
*	************************************************************************

eststo: xtreg f.crisis_any2 td ydummy* if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 td loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS time if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 td loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.crisis_any2 td if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 td ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 td loggdpcap ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 td loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 td loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: probit f.crisis_any2 td loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0

eststo: xtreg f.crisis_any2 td ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 td loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS time if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 td loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

esttab using "TableA13.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "Probit" "FE" "FE" "FE")	///
	mgroups("All Countries" "Non-OECD" "Credit 20-80\% of GDP", pattern(1 0 0 1 0 0 0 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate(Year FE = ydummy*, label($\checkmark$ ))	
eststo clear

*	************************************************************************
*	Table A14
*	************************************************************************

eststo: xtreg f.crisis_any2 logtroopsdecantm5 ydummy* if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroopsdecantm5 loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroopsdecantm5 loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.crisis_any2 logtroopsdecantm5 if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroopsdecantm5 ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroopsdecantm5 loggdpcap ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroopsdecantm5 loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroopsdecantm5 loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: probit f.crisis_any2 logtroopsdecantm5 loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0

eststo: xtreg f.crisis_any2 logtroopsdecantm5 ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroopsdecantm5 loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroopsdecantm5 loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

esttab using "TableA14.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "Probit" "FE" "FE" "FE")	///
	mgroups("All Countries" "Non-OECD" "Credit 20-80\% of GDP", pattern(1 0 0 1 0 0 0 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate(Year FE = ydummy*, label($\checkmark$ ))	
eststo clear

*	************************************************************************
*	Table A15
*	************************************************************************

eststo: xtreg f.crisis_any2 logtroops_ma3 ydummy* if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops_ma3 loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops_ma3 loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.crisis_any2 logtroops_ma3 if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops_ma3 ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops_ma3 loggdpcap ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops_ma3 loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops_ma3 loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: probit f.crisis_any2 logtroops_ma3 loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0

eststo: xtreg f.crisis_any2 logtroops_ma3 ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops_ma3 loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops_ma3 loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

esttab using "TableA15.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "Probit" "FE" "FE" "FE")	///
	mgroups("All Countries" "Non-OECD" "Credit 20-80\% of GDP", pattern(1 0 0 1 0 0 0 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate(Year FE = ydummy*, label($\checkmark$ ))	
eststo clear

*	************************************************************************
*	Table A16
*	************************************************************************

eststo: xtreg crisis_any2 logtroops ydummy* if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg crisis_any2 logtroops if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg crisis_any2 logtroops ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg crisis_any2 logtroops loggdpcap ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: probit crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0

eststo: xtreg crisis_any2 logtroops ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

esttab using "TableA16.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "Probit" "FE" "FE" "FE")	///
	mgroups("All Countries" "Non-OECD" "Credit 20-80\% of GDP", pattern(1 0 0 1 0 0 0 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate(Year FE = ydummy*, label($\checkmark$ ))	
eststo clear


*	************************************************************************
*	Table A17
*	************************************************************************

eststo: xtreg f2.crisis_any2 logtroops ydummy* if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f2.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f2.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f2.crisis_any2 logtroops if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f2.crisis_any2 logtroops ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f2.crisis_any2 logtroops loggdpcap ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f2.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f2.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: probit f2.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0

eststo: xtreg f2.crisis_any2 logtroops ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f2.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f2.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

esttab using "TableA17.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "Probit" "FE" "FE" "FE")	///
	mgroups("All Countries" "Non-OECD" "Credit 20-80\% of GDP", pattern(1 0 0 1 0 0 0 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate(Year FE = ydummy*, label($\checkmark$ ))	
eststo clear

*	************************************************************************
*	Table A18
*	************************************************************************

eststo: xtreg f3.crisis_any2 logtroops ydummy* if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f3.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f3.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f3.crisis_any2 logtroops if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f3.crisis_any2 logtroops ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f3.crisis_any2 logtroops loggdpcap ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f3.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f3.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: probit f3.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0

eststo: xtreg f3.crisis_any2 logtroops ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f3.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f3.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

esttab using "TableA18.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "Probit" "FE" "FE" "FE")	///
	mgroups("All Countries" "Non-OECD" "Credit 20-80\% of GDP", pattern(1 0 0 1 0 0 0 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate(Year FE = ydummy*, label($\checkmark$ ))	
eststo clear

*	************************************************************************
*	Table A19
*	************************************************************************

eststo: xtreg f.crisis_any2 logTroopsWOMarines ydummy* if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logTroopsWOMarines loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logTroopsWOMarines loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.crisis_any2 logTroopsWOMarines if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logTroopsWOMarines ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logTroopsWOMarines loggdpcap ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logTroopsWOMarines loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logTroopsWOMarines loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: probit f.crisis_any2 logTroopsWOMarines loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0

eststo: xtreg f.crisis_any2 logTroopsWOMarines ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logTroopsWOMarines loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logTroopsWOMarines loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

esttab using "TableA19.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "Probit" "FE" "FE" "FE")	///
	mgroups("All Countries" "Non-OECD" "Credit 20-80\% of GDP", pattern(1 0 0 1 0 0 0 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate(Year FE = ydummy*, label($\checkmark$ ))	
eststo clear

*	************************************************************************
*	Table A20
*	************************************************************************

eststo: xtreg f.crisis_any2 logTroopsMinus20pc ydummy* if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logTroopsMinus20pc loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logTroopsMinus20pc loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.crisis_any2 logTroopsMinus20pc if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logTroopsMinus20pc ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logTroopsMinus20pc loggdpcap ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logTroopsMinus20pc loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logTroopsMinus20pc loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: probit f.crisis_any2 logTroopsMinus20pc loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0

eststo: xtreg f.crisis_any2 logTroopsMinus20pc ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logTroopsMinus20pc loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logTroopsMinus20pc loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

esttab using "TableA20.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "Probit" "FE" "FE" "FE")	///
	mgroups("All Countries" "Non-OECD" "Credit 20-80\% of GDP", pattern(1 0 0 1 0 0 0 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate(Year FE = ydummy*, label($\checkmark$ ))	
eststo clear

*	************************************************************************
*	Table A21
*	************************************************************************

eststo: xtreg f.crisis_any2 logtroops crisis_any2 ydummy* if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops crisis_any2 loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops crisis_any2 loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.crisis_any2 logtroops crisis_any2 if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops crisis_any2 ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops crisis_any2 loggdpcap ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops crisis_any2 loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops crisis_any2 loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: probit f.crisis_any2 logtroops crisis_any2 loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0

eststo: xtreg f.crisis_any2 logtroops crisis_any2 ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops crisis_any2 loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops crisis_any2 loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

esttab using "TableA21.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "Probit" "FE" "FE" "FE")	///
	mgroups("All Countries" "Non-OECD" "Credit 20-80\% of GDP", pattern(1 0 0 1 0 0 0 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate(Year FE = ydummy*, label($\checkmark$ ))	
eststo clear

*	************************************************************************
*	Table A22
*	************************************************************************

eststo: xtreg f.crisis_any2 us_SH1995 ydummy* if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 us_SH1995 loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS time if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 us_SH1995 loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.crisis_any2 us_SH1995 if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 us_SH1995 ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 us_SH1995 loggdpcap ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 us_SH1995 loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 us_SH1995 loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: probit f.crisis_any2 us_SH1995 loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0

eststo: xtreg f.crisis_any2 us_SH1995 ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 us_SH1995 loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS time if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 us_SH1995 loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

esttab using "TableA22.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "Probit" "FE" "FE" "FE")	///
	mgroups("All Countries" "Non-OECD" "Credit 20-80\% of GDP", pattern(1 0 0 1 0 0 0 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate(Year FE = ydummy*, label($\checkmark$ ))	
eststo clear

*	************************************************************************
*	Table A23
*	************************************************************************

eststo: xtreg f.crisis_any2 us_SH1995 us_EH1995 ydummy* if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 us_SH1995 us_EH1995 loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS time if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 us_SH1995 us_EH1995 loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.crisis_any2 us_SH1995 us_EH1995 if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 us_SH1995 us_EH1995 ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 us_SH1995 us_EH1995 loggdpcap ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 us_SH1995 us_EH1995 loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 us_SH1995 us_EH1995 loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: probit f.crisis_any2 us_SH1995 us_EH1995 loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0

eststo: xtreg f.crisis_any2 us_SH1995 us_EH1995 ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 us_SH1995 us_EH1995 loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS time if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 us_SH1995 us_EH1995 loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

esttab using "TableA23.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "Probit" "FE" "FE" "FE")	///
	mgroups("All Countries" "Non-OECD" "Credit 20-80\% of GDP", pattern(1 0 0 1 0 0 0 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate(Year FE = ydummy*, label($\checkmark$ ))	
eststo clear

*	************************************************************************
*	Table A24 ***
*	************************************************************************

eststo: xtreg f.crisis_any2 logtroops ydummy* if sample == 1 & ustroops > 10, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & ustroops > 10, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & ustroops > 10, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.crisis_any2 logtroops if sample == 1 & oecd == 0 & ustroops > 10, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops ydummy* if sample == 1 & oecd == 0 & ustroops > 10, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap ydummy* if sample == 1 & oecd == 0 & ustroops > 10, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0 & ustroops > 10, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0 & ustroops > 10, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: probit f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0 & ustroops > 10

eststo: xtreg f.crisis_any2 logtroops ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80 & ustroops > 29, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80 & ustroops > 10, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80 & ustroops > 10, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

esttab using "TableA24.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "Probit" "FE" "FE" "FE")	///
	mgroups("All Countries" "Non-OECD" "Credit 20-80\% of GDP", pattern(1 0 0 1 0 0 0 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate(Year FE = ydummy*, label($\checkmark$ ))	
eststo clear

*	************************************************************************
*	Table A25
*	************************************************************************

eststo: logit f.crisis_any2 logtroops countryd* ydummy* if sample == 1, cluster(ccode)
eststo: logit f.crisis_any2 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS countryd* time if sample == 1,  cluster(ccode)
eststo: logit f.crisis_any2 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS countryd* ydummy* if sample == 1,  cluster(ccode)

eststo: logit f.crisis_any2 logtroops countryd* if sample == 1 & oecd == 0,  cluster(ccode)
eststo: logit f.crisis_any2 logtroops countryd* ydummy* if sample == 1 & oecd == 0,  cluster(ccode)
eststo: logit f.crisis_any2 logtroops loggdpcap countryd* ydummy* if sample == 1 & oecd == 0,  cluster(ccode)
eststo: logit f.crisis_any2 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS countryd* time if sample == 1 & oecd == 0,  cluster(ccode)
eststo: logit f.crisis_any2 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS countryd* ydummy* if sample == 1 & oecd == 0,  cluster(ccode)

eststo: logit f.crisis_any2 logtroops countryd* ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80,  cluster(ccode)
eststo: logit f.crisis_any2 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS countryd* time if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80,  cluster(ccode)
eststo: logit f.crisis_any2 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS countryd* ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80,  cluster(ccode)

esttab using "TableA25.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps  sfmt(%9.2f %9.0f) ///
	nomtitles	///
	mgroups("All Countries" "Non-OECD" "Credit 20-80\% of GDP", pattern(1 0 0 1 0 0 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate("Country FE = countryd*" "Year FE = ydummy*", label($\checkmark$ ))	
eststo clear


*	************************************************************************
*	Table A26
*	************************************************************************

eststo: logit f.crisis_any2 logtroops countryd* ydummy* if sample == 1, cluster(ccode)
eststo: logit f.crisis_any2 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS countryd* time if sample == 1,  cluster(ccode)
eststo: logit f.crisis_any2 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS countryd* ydummy* if sample == 1,  cluster(ccode)

eststo: logit f.crisis_any2 logtroops countryd* if sample == 1 & oecd == 0,  cluster(ccode)
eststo: logit f.crisis_any2 logtroops countryd* ydummy* if sample == 1 & oecd == 0,  cluster(ccode)
eststo: logit f.crisis_any2 logtroops loggdpcap countryd* ydummy* if sample == 1 & oecd == 0,  cluster(ccode)
eststo: logit f.crisis_any2 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS countryd* time if sample == 1 & oecd == 0,  cluster(ccode)
eststo: logit f.crisis_any2 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS countryd* ydummy* if sample == 1 & oecd == 0,  cluster(ccode)

eststo: logit f.crisis_any2 logtroops countryd* ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80,  cluster(ccode)
eststo: logit f.crisis_any2 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS countryd* time if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80,  cluster(ccode)
eststo: logit f.crisis_any2 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS countryd* ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80,  cluster(ccode)

esttab using "TableA26.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps  sfmt(%9.2f %9.0f) ///
	nomtitles	///
	mgroups("All Countries" "Non-OECD" "Credit 20-80\% of GDP", pattern(1 0 0 1 0 0 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate("Country FE = countryd*" "Year FE = ydummy*", label($\checkmark$ ))	
eststo clear

*	************************************************************************
*	Table A27
*	************************************************************************

eststo: xtreg f.crisis_any2 logtroops ydummy* if sample == 1 & logtroops > 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & logtroops > 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & logtroops > 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.crisis_any2 logtroops if sample == 1 & oecd == 0 & logtroops > 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops ydummy* if sample == 1 & oecd == 0 & logtroops > 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap ydummy* if sample == 1 & oecd == 0 & logtroops > 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0 & logtroops > 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0 & logtroops > 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: probit f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0 & logtroops > 0

eststo: xtreg f.crisis_any2 logtroops ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80 & logtroops > 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80 & logtroops > 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80 & logtroops > 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

esttab using "TableA27.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "Probit" "FE" "FE" "FE")	///
	mgroups("All Countries" "Non-OECD" "Credit 20-80\% of GDP", pattern(1 0 0 1 0 0 0 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate(Year FE = ydummy*, label($\checkmark$ ))	
eststo clear

*	************************************************************************
*	Table A28
*	************************************************************************

quiet probit f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0
sum ustroops if e(sample) == 1, d

eststo: xtreg f.crisis_any2 logtroops ydummy* if sample == 1 & ustroops > 19, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & ustroops > 19, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & ustroops > 19, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.crisis_any2 logtroops if sample == 1 & oecd == 0 & ustroops > 19, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops ydummy* if sample == 1 & oecd == 0 & ustroops > 19, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap ydummy* if sample == 1 & oecd == 0 & ustroops > 19, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0 & ustroops > 19, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0 & ustroops > 19, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: probit f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0 & ustroops > 19

eststo: xtreg f.crisis_any2 logtroops ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80 & ustroops > 29, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80 & ustroops > 19, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80 & ustroops > 19, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

esttab using "TableA28.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "Probit" "FE" "FE" "FE")	///
	mgroups("All Countries" "Non-OECD" "Credit 20-80\% of GDP", pattern(1 0 0 1 0 0 0 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate(Year FE = ydummy*, label($\checkmark$ ))	
eststo clear

*	************************************************************************
*	Table A29
*	************************************************************************

eststo: xtreg f.crisis_any2 logtroops ydummy* if sample == 1 & ustroops < 500, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & ustroops < 500, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & ustroops < 500, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.crisis_any2 logtroops if sample == 1 & oecd == 0 & ustroops < 500, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops ydummy* if sample == 1 & oecd == 0 & ustroops < 500, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap ydummy* if sample == 1 & oecd == 0 & ustroops < 500, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0 & ustroops < 500, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0 & ustroops < 500, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: probit f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0 & ustroops < 500

eststo: xtreg f.crisis_any2 logtroops ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80 & ustroops < 500, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80 & ustroops < 500, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80 & ustroops < 500, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

esttab using "TableA29.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "Probit" "FE" "FE" "FE")	///
	mgroups("All Countries" "Non-OECD" "Credit 20-80\% of GDP", pattern(1 0 0 1 0 0 0 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate(Year FE = ydummy*, label($\checkmark$ ))	
eststo clear

*	************************************************************************
*	Table A30
*	************************************************************************

eststo: xtreg f.crisis_any2 logtroops ydummy* if sample == 1 & year >= 1970, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & year >= 1970, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & year >= 1970, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.crisis_any2 logtroops if sample == 1 & oecd == 0 & year >= 1970, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops ydummy* if sample == 1 & oecd == 0 & year >= 1970, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap ydummy* if sample == 1 & oecd == 0 & year >= 1970, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0 & year >= 1970, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0 & year >= 1970, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: probit f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0 & year >= 1970

eststo: xtreg f.crisis_any2 logtroops ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80 & year >= 1970, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80 & year >= 1970, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80 & year >= 1970, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

esttab using "TableA30.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "Probit" "FE" "FE" "FE")	///
	mgroups("All Countries" "Non-OECD" "Credit 20-80\% of GDP", pattern(1 0 0 1 0 0 0 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate(Year FE = ydummy*, label($\checkmark$ ))	
eststo clear

*	************************************************************************
*	Table A31
*	************************************************************************

eststo: xtreg f.crisis_any2 logtroops ydummy* if sample == 1 & year < 1996, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & year < 1996, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & year < 1996, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.crisis_any2 logtroops if sample == 1 & oecd == 0 & year < 1996, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops ydummy* if sample == 1 & oecd == 0 & year < 1996, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap ydummy* if sample == 1 & oecd == 0 & year < 1996, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0 & year < 1996, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0 & year < 1996, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: probit f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0 & year < 1996

eststo: xtreg f.crisis_any2 logtroops ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80 & year < 1996, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80 & year < 1996, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80 & year < 1996, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

esttab using "TableA31.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "Probit" "FE" "FE" "FE")	///
	mgroups("All Countries" "Non-OECD" "Credit 20-80\% of GDP", pattern(1 0 0 1 0 0 0 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate(Year FE = ydummy*, label($\checkmark$ ))	
eststo clear

*	************************************************************************
*	Table A32
*	************************************************************************

eststo: xtreg f.crisis_any2 logtroops ydummy* if sample == 1 & year != 1960 & year != 1961 & year != 1969 & year != 1970 & year != 1973 & year != 1974 & year != 1975 & year != 1980 & year != 1981 & year != 1982 & year != 1990 & year != 1991 & year != 2001 & year != 2007 & year != 2008 & year != 2009, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & year != 1960 & year != 1961 & year != 1969 & year != 1970 & year != 1973 & year != 1974 & year != 1975 & year != 1980 & year != 1981 & year != 1982 & year != 1990 & year != 1991 & year != 2001 & year != 2007 & year != 2008 & year != 2009, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & year != 1960 & year != 1961 & year != 1969 & year != 1970 & year != 1973 & year != 1974 & year != 1975 & year != 1980 & year != 1981 & year != 1982 & year != 1990 & year != 1991 & year != 2001 & year != 2007 & year != 2008 & year != 2009, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.crisis_any2 logtroops if sample == 1 & oecd == 0 & year != 1960 & year != 1961 & year != 1969 & year != 1970 & year != 1973 & year != 1974 & year != 1975 & year != 1980 & year != 1981 & year != 1982 & year != 1990 & year != 1991 & year != 2001 & year != 2007 & year != 2008 & year != 2009, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops ydummy* if sample == 1 & oecd == 0 & year != 1960 & year != 1961 & year != 1969 & year != 1970 & year != 1973 & year != 1974 & year != 1975 & year != 1980 & year != 1981 & year != 1982 & year != 1990 & year != 1991 & year != 2001 & year != 2007 & year != 2008 & year != 2009, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap ydummy* if sample == 1 & oecd == 0 & year != 1960 & year != 1961 & year != 1969 & year != 1970 & year != 1973 & year != 1974 & year != 1975 & year != 1980 & year != 1981 & year != 1982 & year != 1990 & year != 1991 & year != 2001 & year != 2007 & year != 2008 & year != 2009, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0 & year != 1960 & year != 1961 & year != 1969 & year != 1970 & year != 1973 & year != 1974 & year != 1975 & year != 1980 & year != 1981 & year != 1982 & year != 1990 & year != 1991 & year != 2001 & year != 2007 & year != 2008 & year != 2009, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0 & year != 1960 & year != 1961 & year != 1969 & year != 1970 & year != 1973 & year != 1974 & year != 1975 & year != 1980 & year != 1981 & year != 1982 & year != 1990 & year != 1991 & year != 2001 & year != 2007 & year != 2008 & year != 2009, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: probit f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0 & year != 1960 & year != 1961 & year != 1969 & year != 1970 & year != 1973 & year != 1974 & year != 1975 & year != 1980 & year != 1981 & year != 1982 & year != 1990 & year != 1991 & year != 2001 & year != 2007 & year != 2008 & year != 2009

eststo: xtreg f.crisis_any2 logtroops ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80 & year != 1960 & year != 1961 & year != 1969 & year != 1970 & year != 1973 & year != 1974 & year != 1975 & year != 1980 & year != 1981 & year != 1982 & year != 1990 & year != 1991 & year != 2001 & year != 2007 & year != 2008 & year != 2009, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80 & year != 1960 & year != 1961 & year != 1969 & year != 1970 & year != 1973 & year != 1974 & year != 1975 & year != 1980 & year != 1981 & year != 1982 & year != 1990 & year != 1991 & year != 2001 & year != 2007 & year != 2008 & year != 2009, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80 & year != 1960 & year != 1961 & year != 1969 & year != 1970 & year != 1973 & year != 1974 & year != 1975 & year != 1980 & year != 1981 & year != 1982 & year != 1990 & year != 1991 & year != 2001 & year != 2007 & year != 2008 & year != 2009, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

esttab using "TableA32.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "Probit" "FE" "FE" "FE")	///
	mgroups("All Countries" "Non-OECD" "Credit 20-80\% of GDP", pattern(1 0 0 1 0 0 0 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate(Year FE = ydummy*, label($\checkmark$ ))	
eststo clear

*	************************************************************************
*	Table A33
*	************************************************************************

eststo: reg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & continent == 1, cluster(ccode)
eststo: probit f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & continent == 1
eststo: reg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & continent == 2, cluster(ccode)
eststo: probit f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & continent == 2
eststo: reg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & continent == 3, cluster(ccode)
eststo: probit f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & continent == 3
eststo: reg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & continent == 4, cluster(ccode)
eststo: probit f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & continent == 4

esttab using "TableA33.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("OLS" "Probit" "OLS" "Probit" "OLS" "Probit" "OLS" "Probit")	///
	mgroups("Africa" "Americas" "Asia" "Europe", pattern(1 0 1 0 1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))		
eststo clear

*	************************************************************************
*	Table A34
*	************************************************************************

eststo: xtreg f.crisis_any2 logtroops ydummy* if sample == 1 & wdi_oilrents < 20, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & wdi_oilrents < 20, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & wdi_oilrents < 20, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.crisis_any2 logtroops if sample == 1 & oecd == 0 & wdi_oilrents < 20, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops ydummy* if sample == 1 & oecd == 0 & wdi_oilrents < 20, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap ydummy* if sample == 1 & oecd == 0 & wdi_oilrents < 20, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0 & wdi_oilrents < 20, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0 & wdi_oilrents < 20, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: probit f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0 & wdi_oilrents < 20

eststo: xtreg f.crisis_any2 logtroops ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80 & wdi_oilrents < 20, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80 & wdi_oilrents < 20, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80 & wdi_oilrents < 20, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

esttab using "TableA34.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "Probit" "FE" "FE" "FE")	///
	mgroups("All Countries" "Non-OECD" "Credit 20-80\% of GDP", pattern(1 0 0 1 0 0 0 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate(Year FE = ydummy*, label($\checkmark$ ))	
eststo clear

*	************************************************************************
*	Table A35
*	************************************************************************

eststo: xtreg f.crisis_any2 logtroops ydummy* if sample == 1 & wdi_oilrents > 20, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & wdi_oilrents > 20, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & wdi_oilrents > 20, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.crisis_any2 logtroops if sample == 1 & oecd == 0 & wdi_oilrents > 20, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops ydummy* if sample == 1 & oecd == 0 & wdi_oilrents > 20, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap ydummy* if sample == 1 & oecd == 0 & wdi_oilrents > 20, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0 & wdi_oilrents > 20, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0 & wdi_oilrents > 20, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: probit f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0 & wdi_oilrents > 20

eststo: xtreg f.crisis_any2 logtroops ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80 & wdi_oilrents > 20, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80 & wdi_oilrents > 20, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80 & wdi_oilrents > 20, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

esttab using "TableA35.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "Probit" "FE" "FE" "FE")	///
	mgroups("All Countries" "Non-OECD" "Credit 20-80\% of GDP", pattern(1 0 0 1 0 0 0 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate(Year FE = ydummy*, label($\checkmark$ ))	
eststo clear


*	************************************************************************
*	Table A36
*	************************************************************************

eststo: xtreg f.crisis_any2 logtroops ydummy* if sample == 1 & incomegroup == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & incomegroup == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & incomegroup == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.crisis_any2 logtroops if sample == 1 & oecd == 0 & incomegroup == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops ydummy* if sample == 1 & oecd == 0 & incomegroup == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap ydummy* if sample == 1 & oecd == 0 & incomegroup == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0 & incomegroup == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0 & incomegroup == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: probit f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0 & incomegroup == 0

eststo: xtreg f.crisis_any2 logtroops ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80 & incomegroup == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80 & incomegroup == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80 & incomegroup == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

esttab using "TableA36.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "Probit" "FE" "FE" "FE")	///
	mgroups("All Countries" "Non-OECD" "Credit 20-80\% of GDP", pattern(1 0 0 1 0 0 0 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate(Year FE = ydummy*, label($\checkmark$ ))	
eststo clear

*	************************************************************************
*	Table A37
*	************************************************************************

eststo: xtreg f.crisis_any2 logtroops ydummy* if sample == 1 & incomegroup == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & incomegroup == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & incomegroup == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.crisis_any2 logtroops if sample == 1 & oecd == 0 & incomegroup == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops ydummy* if sample == 1 & oecd == 0 & incomegroup == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap ydummy* if sample == 1 & oecd == 0 & incomegroup == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0 & incomegroup == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0 & incomegroup == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: probit f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0 & incomegroup == 1

eststo: xtreg f.crisis_any2 logtroops ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80 & incomegroup == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80 & incomegroup == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80 & incomegroup == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

esttab using "TableA37.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "Probit" "FE" "FE" "FE")	///
	mgroups("All Countries" "Non-OECD" "Credit 20-80\% of GDP", pattern(1 0 0 1 0 0 0 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate(Year FE = ydummy*, label($\checkmark$ ))	
eststo clear


*	************************************************************************
*	Table A38
*	************************************************************************

eststo: xtreg f.crisis_any2 logtroops if sample == 1 & incomegroup == 2, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops ydummy* if sample == 1 & incomegroup == 2, fe  cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap ydummy* if sample == 1 & incomegroup == 2, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & incomegroup == 2, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & incomegroup == 2, fe  cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: probit f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & incomegroup == 2

esttab using "TableA38.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries" "notes Notes") r2(2) sfmt(%9.2f %9.0f) ///
	indicate(Year FE = ydummy*, label($\checkmark$ $$$$ ))	///
	mtitles("FE" "FE" "FE" "FE" "FE" "Probit")
eststo clear

*	************************************************************************
*	Table A39
*	************************************************************************

eststo: xtreg f.crisis_any2 logtroops ydummy*, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy*, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.crisis_any2 logtroops if oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops ydummy* if oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap ydummy* if  oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: probit f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if oecd == 0

eststo: xtreg f.crisis_any2 logtroops ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

esttab using "TableA39.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "Probit" "FE" "FE" "FE")	///
	mgroups("All Countries" "Non-OECD" "Credit 20-80\% of GDP", pattern(1 0 0 1 0 0 0 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate(Year FE = ydummy*, label($\checkmark$ ))	
eststo clear

*	************************************************************************
*	Table A40
*	************************************************************************

eststo: xtreg f.crisis_any2 logtroops war ydummy*, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops war loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops war loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy*, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.crisis_any2 logtroops war if oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops war ydummy* if oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops war loggdpcap ydummy* if  oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops war loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops war loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: probit f.crisis_any2 logtroops war loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if oecd == 0

eststo: xtreg f.crisis_any2 logtroops war ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops war loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops war loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

esttab using "TableA40.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "Probit" "FE" "FE" "FE")	///
	mgroups("All Countries" "Non-OECD" "Credit 20-80\% of GDP", pattern(1 0 0 1 0 0 0 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate(Year FE = ydummy*, label($\checkmark$ ))	
eststo clear

*	************************************************************************
*	Table A41
*	************************************************************************

eststo: xtreg f.crisis_any2 logtroops idealdistanceUS idealdistanceRussia ydummy* if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops idealdistanceUS idealdistanceRussia loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy time if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops idealdistanceUS idealdistanceRussia loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy ydummy* if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.crisis_any2 logtroops idealdistanceUS idealdistanceRussia if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops idealdistanceUS idealdistanceRussia ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops idealdistanceUS idealdistanceRussia loggdpcap ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops idealdistanceUS idealdistanceRussia loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy time if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops idealdistanceUS idealdistanceRussia loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: probit f.crisis_any2 logtroops idealdistanceUS idealdistanceRussia loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy time if sample == 1 & oecd == 0

eststo: xtreg f.crisis_any2 logtroops idealdistanceUS idealdistanceRussia ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops idealdistanceUS idealdistanceRussia loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy time if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops idealdistanceUS idealdistanceRussia loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace


esttab using "TableA41.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "Probit" "FE" "FE" "FE")	///
	mgroups("All Countries" "Non-OECD" "Credit 20-80\% of GDP", pattern(1 0 0 1 0 0 0 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate(Year FE = ydummy*, label($\checkmark$ ))	
eststo clear

*	************************************************************************
*	Table A42
*	************************************************************************

eststo: xtreg f.crisis_any2 logtroops unsc ydummy* if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops unsc loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops unsc loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.crisis_any2 logtroops unsc if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops unsc ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops unsc loggdpcap ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops unsc loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops unsc loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: probit f.crisis_any2 logtroops unsc loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0

eststo: xtreg f.crisis_any2 logtroops unsc ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops unsc loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops unsc loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

esttab using "TableA42.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "Probit" "FE" "FE" "FE")	///
	mgroups("All Countries" "Non-OECD" "Credit 20-80\% of GDP", pattern(1 0 0 1 0 0 0 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate(Year FE = ydummy*, label($\checkmark$ ))	
eststo clear

*	************************************************************************
*	Table A43
*	************************************************************************

eststo: xtreg f.crisis_any2 logtroops logexportUS ydummy* if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops logexportUS loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops logexportUS loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.crisis_any2 logtroops logexportUS if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops logexportUS ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops logexportUS loggdpcap ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops logexportUS loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops logexportUS loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: probit f.crisis_any2 logtroops logexportUS loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0

eststo: xtreg f.crisis_any2 logtroops logexportUS ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops logexportUS loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops logexportUS loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

esttab using "TableA43.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "Probit" "FE" "FE" "FE")	///
	mgroups("All Countries" "Non-OECD" "Credit 20-80\% of GDP", pattern(1 0 0 1 0 0 0 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate(Year FE = ydummy*, label($\checkmark$ ))	
eststo clear

*	************************************************************************
*	Table A44
*	************************************************************************

eststo: reg f.crisis_any2 logtroops ydummy* if sample == 1, cluster(ccode)
eststo: reg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1, cluster(ccode)
eststo: reg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1, cluster(ccode)

eststo: reg f.crisis_any2 logtroops if sample == 1 & oecd == 0, cluster(ccode)
eststo: reg f.crisis_any2 logtroops ydummy* if sample == 1 & oecd == 0, cluster(ccode)
eststo: reg f.crisis_any2 logtroops loggdpcap ydummy* if sample == 1 & oecd == 0, cluster(ccode)
eststo: reg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0, cluster(ccode)
eststo: reg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0, cluster(ccode)
eststo: probit f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0

eststo: reg f.crisis_any2 logtroops ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, cluster(ccode)
eststo: reg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS time if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, cluster(ccode)
eststo: reg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 financedata24 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, cluster(ccode)

esttab using "TableA44.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("OLS" "OLS" "OLS" "OLS" "OLS" "OLS" "OLS" "OLS" "Probit" "OLS" "OLS" "OLS")	///
	mgroups("All Countries" "Non-OECD" "Credit 20-80\% of GDP", pattern(1 0 0 1 0 0 0 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate(Year FE = ydummy*, label($\checkmark$ ))	
eststo clear

*	************************************************************************
*	Table A45
*	************************************************************************

eststo: xtreg f.crisis_any2 logtroops ydummy* if sample == 1, re cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS time if sample == 1, re cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1, re cluster(ccode)
estadd local fixed "$\checkmark$" , replace

eststo: xtreg f.crisis_any2 logtroops if sample == 1 & oecd == 0, re cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops ydummy* if sample == 1 & oecd == 0, re cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap ydummy* if sample == 1 & oecd == 0, re cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0, re cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0, re cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: probit f.crisis_any2 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0

eststo: xtreg f.crisis_any2 logtroops ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, re cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS time if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, re cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.crisis_any2 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, re cluster(ccode)
estadd local fixed "$\checkmark$" , replace

esttab using "TableA45.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country RE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	mtitles("RE" "RE" "RE" "RE" "RE" "RE" "RE" "RE" "Probit" "RE" "RE" "RE")	///
	mgroups("All Countries" "Non-OECD" "Credit 20-80\% of GDP", pattern(1 0 0 1 0 0 0 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate(Year FE = ydummy*, label($\checkmark$ ))	
eststo clear

*	************************************************************************
*	Table A46
*	************************************************************************

eststo: xtscc fcrisis_any2 logtroops ydummy* if sample == 1, fe 
estadd local fixed "$\checkmark$" , replace
eststo: xtscc fcrisis_any2 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS time if sample == 1, fe
estadd local fixed "$\checkmark$" , replace
eststo: xtscc fcrisis_any2 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1, fe 
estadd local fixed "$\checkmark$" , replace

eststo: xtscc fcrisis_any2 logtroops if sample == 1 & oecd == 0, fe 
estadd local fixed "$\checkmark$" , replace
eststo: xtscc fcrisis_any2 logtroops ydummy* if sample == 1 & oecd == 0, fe 
estadd local fixed "$\checkmark$" , replace
eststo: xtscc fcrisis_any2 logtroops loggdpcap ydummy* if sample == 1 & oecd == 0, fe 
estadd local fixed "$\checkmark$" , replace
eststo: xtscc fcrisis_any2 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0, fe 
estadd local fixed "$\checkmark$" , replace
eststo: xtscc fcrisis_any2 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0, fe
estadd local fixed "$\checkmark$" , replace
eststo: probit fcrisis_any2 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0

eststo: xtscc fcrisis_any2 logtroops ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe
estadd local fixed "$\checkmark$" , replace
eststo: xtscc fcrisis_any2 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS time if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe 
estadd local fixed "$\checkmark$" , replace
eststo: xtscc fcrisis_any2 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & pcrdbofgdp >= 20 & pcrdbofgdp <= 80, fe 
estadd local fixed "$\checkmark$" , replace

esttab using "TableA46.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("fixed Country FE" "N_g $\#$ Countries")  sfmt(%9.2f %9.0f) ///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" "Probit" "FE" "FE" "FE")	///
	mgroups("All Countries" "Non-OECD" "Credit 20-80\% of GDP", pattern(1 0 0 1 0 0 0 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate(Year FE = ydummy*, label($\checkmark$ ))	
eststo clear

*	************************************************************************
*	Table A47 ***
*	************************************************************************

*	************************************************************************
*	Table A48
*	************************************************************************

preserve

* 	Rescaling to have all variables going in the same predicted direction
replace ispread2 = -1*ispread2
sum ispread2
drop if ispread2 < -50

* 	Drop non-OECD
drop if oecd==1

*	Create factors
factor logcon lra66 ispread2 insurance_onset steinberg_ckaopen2010 if sample == 1  , pcf
rotate
predict policyfactor*

factor lrd64 logliabilities logbank_us financedata57 if sample == 1  , pcf
rotate
predict marketfactor*


eststo: reg f.policyfactor1 logtroops if sample == 1 
eststo: xtreg f.policyfactor1 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 , fe
estadd local fixed "$\checkmark$" , replace

eststo: reg f.marketfactor1 logtroops if sample == 1
eststo: xtreg f.marketfactor1 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 , fe
estadd local fixed "$\checkmark$" , replace

esttab using "TableA48.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	indicate(Year FE = ydummy*, label($\checkmark$ $$$$ ))	///
	mtitles("OLS" "FE" "OLS" "FE")	///
	mgroups("Policy Reaction" "Market Reaction", pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))
eststo clear

restore

*	************************************************************************
*	Table A49
*	************************************************************************

eststo: reg f.logliabTotal logtroops if sample == 1 & oecd == 0
eststo: xtreg f.logliabTotal logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0, fe
estadd local fixed "$\checkmark$" , replace
eststo: reg f.logliabDerivatives logtroops if sample == 1 & oecd == 0
eststo: xtreg f.logliabDerivatives logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0, fe
estadd local fixed "$\checkmark$" , replace
eststo: reg f.logliabDebt logtroops if sample == 1 & oecd == 0 
eststo: xtreg f.logliabDebt logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0, fe
estadd local fixed "$\checkmark$" , replace
eststo: reg f.logliabPortfolio logtroops if sample == 1 & oecd == 0
eststo: xtreg f.logliabPortfolio logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0, fe
estadd local fixed "$\checkmark$" , replace
eststo: reg f.logliabFDI logtroops if sample == 1 & oecd == 0
eststo: xtreg f.logliabFDI logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0, fe
estadd local fixed "$\checkmark$" , replace
esttab using "TableA49.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	indicate(Year FE = ydummy*, label($\checkmark$ $$$$ ))	///
	mtitles("OLS" "FE" "OLS" "FE" "OLS" "FE" "OLS" "FE" "OLS" "FE")	///
	mgroups("Total" "Derivates" "Debt" "Portfolio" "FDI", pattern(1 0 1 0 1 0 1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))
eststo clear

*	************************************************************************
*	Table A50
*	************************************************************************


eststo: reg f.ecopodata32 logtroops if sample == 1 & oecd == 0
eststo: xtreg f.ecopodata32 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0, fe
estadd local fixed "$\checkmark$" , replace
eststo: reg f.lecopodata248 logtroops if sample == 1 & oecd == 0
eststo: xtreg f.lecopodata248 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0, fe
estadd local fixed "$\checkmark$" , replace
eststo: reg f.logcon logtroops if sample == 1 & oecd == 0
eststo: xtreg f.logcon logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0, fe
estadd local fixed "$\checkmark$" , replace

eststo: reg f.pubond logtroops if sample == 1 & oecd == 0
eststo: xtreg f.pubond logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0, fe
estadd local fixed "$\checkmark$" , replace
eststo: reg f.lfinancedata11 logtroops if sample == 1 & oecd == 0 & financedata11<40 & financedata11>-11
eststo: xtreg f.lfinancedata11 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0 & financedata11<40 & financedata11>-11, fe
estadd local fixed "$\checkmark$" , replace

eststo: reg f.zscore logtroops if sample == 1 & oecd == 0 & zscore>0
eststo: xtreg f.zscore logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0 & zscore>0, fe
estadd local fixed "$\checkmark$" , replace
eststo: reg f.lfinancedata4 logtroops if sample == 1 & oecd == 0 & financedata4<25
eststo: xtreg f.lfinancedata4 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 & oecd == 0 & financedata4<25, fe
estadd local fixed "$\checkmark$" , replace

esttab using "TableA50.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	indicate(Year FE = ydummy*, label($\checkmark$ $$$$ ))	///
	mtitles("OLS" "FE" "OLS" "FE" "OLS" "FE" "OLS" "FE" "OLS" "FE" "OLS" "FE" "OLS" "FE")	///
	mgroups("Budget Balance" "Revenues" "Expenditures" "Public Bonds" "Public Credit" "Z-Score" "NPL", pattern(1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))
eststo clear


*	************************************************************************
*	Table A51
*	************************************************************************

eststo: xtivreg2 f.crisis_any2 loggdpcap logpop time (logtroops=echolon) if sample==1, fe  first r
estadd scalar Ftest=`e(widstat)'
eststo: xtivreg2 f.crisis_any2 loggdpcap logpop yd* (logtroops=echolon) if sample==1, fe  first r
estadd scalar Ftest=`e(widstat)'
eststo: xtivreg2 f.crisis_any2 loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS time (logtroops=echolon) if sample==1, fe  first
estadd scalar Ftest=`e(widstat)'
eststo: xtivreg2 f.crisis_any2 loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS yd* (logtroops=echolon) if sample==1, fe  first
estadd scalar Ftest=`e(widstat)'

esttab using "TableA51.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	mtitles("IV" "IV" "IV" "IV")	///
	compress nogaps scalars("Ftest F-Test (1st Stage)" "fixed Country FE" "N_g $\#$ Countries") sfmt(%9.2f %9.0f) ///
	indicate("Quadratic Time = time*"  "Year FE = ydummy*", label($\checkmark$ ))	
eststo clear

*	************************************************************************
*	Table A52
*	************************************************************************

eststo: xtreg logtroops dec1 dec2 x1v2 x2v2 if sample==1, fe r
estadd local fixed "$\checkmark$" , replace
eststo: xtreg logtroops dec1 dec2 x1v2 x2v2 loggdpcap logpop if sample==1, fe r
estadd local fixed "$\checkmark$" , replace

eststo: xtreg logtroops dec1 dec2 x1v2 x2v2 if sample==1 & oecd==0, fe r
estadd local fixed "$\checkmark$" , replace
eststo: xtreg logtroops dec1 dec2 x1v2 x2v2 loggdpcap logpop if sample==1 & oecd==0, fe r
estadd local fixed "$\checkmark$" , replace

eststo: xtreg logtroops dec1 dec2 x1v2 x2v2 if sample==1 & pool==1, fe r
estadd local fixed "$\checkmark$" , replace
eststo: xtreg logtroops dec1 dec2 x1v2 x2v2 loggdpcap logpop if sample==1 & pool==1 , fe r
estadd local fixed "$\checkmark$" , replace

esttab using "TableA52.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	mtitles("FE" "FE" "FE" "FE" "FE" "FE" "FE" "FE" )	///
	compress nogaps scalars("fixed Country FE" "N_g $\#$ Countries") sfmt(%9.2f %9.0f) ///
	mgroups("All" "Non-OECD" "Regional Subset" , pattern(1 0 1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	
eststo clear

*	************************************************************************
*	Table A53
*	************************************************************************

eststo: xtivreg2 f.crisis_any2 loggdpcap logpop ydummy* (logtroops=echolon_alt_isq) if pool == 1 & sample==1, fe  first r
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.crisis_any2 loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS time time2 (logtroops=echolon_alt_isq) if pool == 1 & sample==1, fe  first r
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.crisis_any2 loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS ydummy* (logtroops=echolon_alt_isq) if pool == 1 & sample==1, fe  first r
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.crisis_any2 loggdpcap logpop ecopodata83 ecopodata253 democracy ydummy* (logtroops=echolon_alt_isq) if pool == 1 & sample==1 & e(sample)==1, fe  first r
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace


eststo: xtivreg2 f.crisis_any2 loggdpcap logpop ydummy* (logtroops=echolon_alt_isq) if oecd == 0 & sample==1, fe  first r
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.crisis_any2 loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS time time2 (logtroops=echolon_alt_isq) if oecd == 0 & sample==1, fe  first r
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.crisis_any2 loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS ydummy* (logtroops=echolon_alt_isq) if oecd == 0 & sample==1, fe  first r
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.crisis_any2 loggdpcap logpop ecopodata83 ecopodata253 democracy ydummy* (logtroops=echolon_alt_isq) if oecd == 0 & sample==1 & e(sample)==1, fe  first r
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace

esttab using "TableA53.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	mtitles("IV" "IV" "IV" "IV" "IV" "IV" "IV" "IV")	///
	compress nogaps scalars("Ftest F-Test (1st Stage)" "fixed Country FE" "N_g $\#$ Countries") sfmt(%9.2f %9.0f) ///
	mgroups("Regional Subset" "Non-OECD", pattern(1 0 0 0 1 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate("Year FE = ydummy*" "Quadratic Time = time*", label($\checkmark$ ))	
eststo clear

*	************************************************************************
*	Table A54
*	************************************************************************

eststo: xtivreg2 f.crisis_any2 loggdpcap logpop yd* (logtroops=echolon_alt_DE) if pool == 1 & sample==1, fe  first r
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.crisis_any2 loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS yd*  (logtroops=echolon_alt_DE) if pool == 1 & sample==1, fe  first r
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace

eststo: xtivreg2 f.crisis_any2 loggdpcap logpop yd*  (logtroops=echolon_alt_DE) if oecd == 0 & sample==1, fe  first r
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.crisis_any2 loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS yd*  (logtroops=echolon_alt_DE) if oecd == 0 & sample==1, fe  first r
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace

esttab using "TableA54.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	mtitles("IV" "IV" "IV" "IV")	///
	compress nogaps scalars("Ftest F-Test (1st Stage)" "fixed Country FE" "N_g $\#$ Countries") sfmt(%9.2f %9.0f) ///
	mgroups("Regional Subset" "Non-OECD", pattern(1 0 1 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate("Year FE = yd*" , label($\checkmark$ ))	
eststo clear


*	************************************************************************
*	Table A55
*	************************************************************************

eststo: xtivreg2 f.crisis_any2 loggdpcap logpop yd* (logtroops=echolon_alt_DE us_casualties_x_ech_alt_DE) if pool == 1 & sample==1, fe  first r
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.crisis_any2 loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS yd*  (logtroops=echolon_alt_DE us_casualties_x_ech_alt_DE) if pool == 1 & sample==1, fe  first r
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.crisis_any2 loggdpcap logpop ecopodata83 ecopodata253 democracy yd*  (logtroops=echolon_alt_DE us_casualties_x_ech_alt_DE) if pool == 1 & sample==1, fe  first r
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace

eststo: xtivreg2 f.crisis_any2 loggdpcap logpop yd*  (logtroops=echolon_alt_DE us_casualties_x_ech_alt_DE) if oecd == 0 & sample==1, fe  first r
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.crisis_any2 loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS yd*  (logtroops=echolon_alt_DE us_casualties_x_ech_alt_DE) if oecd == 0 & sample==1, fe  first r
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.crisis_any2 loggdpcap logpop ecopodata83 ecopodata253 democracy yd*  (logtroops=echolon_alt_DE us_casualties_x_ech_alt_DE) if oecd == 0 & sample==1, fe  first r
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace

esttab using "TableA55.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	mtitles("IV" "IV" "IV" "IV" "IV" "IV" "IV" "IV")	///
	compress nogaps scalars("Ftest F-Test (1st Stage)" "fixed Country FE" "N_g $\#$ Countries") sfmt(%9.2f %9.0f) ///
	mgroups("Regional Subset" "Non-OECD", pattern(1 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate("Year FE = yd*" , label($\checkmark$ ))	
eststo clear

*	************************************************************************
*	Table A56
*	************************************************************************

eststo: xtivreg2 f.crisis_any2 loggdpcap logpop yd* (logtroops=echolon_alt_DE us_dep_ech_x_echelon) if pool == 1 & sample==1, fe  first r
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.crisis_any2 loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS yd*  (logtroops=echolon_alt_DE us_dep_ech_x_echelon) if pool == 1 & sample==1, fe  first r
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.crisis_any2 loggdpcap logpop ecopodata83 ecopodata253 democracy yd*  (logtroops=echolon_alt_DE us_dep_ech_x_echelon) if pool == 1 & sample==1, fe  first r
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace

eststo: xtivreg2 f.crisis_any2 loggdpcap logpop yd*  (logtroops=echolon_alt_DE us_dep_ech_x_echelon) if oecd == 0 & sample==1, fe  first r
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.crisis_any2 loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS yd*  (logtroops=echolon_alt_DE us_dep_ech_x_echelon) if oecd == 0 & sample==1, fe  first r
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.crisis_any2 loggdpcap logpop ecopodata83 ecopodata253 democracy yd*  (logtroops=echolon_alt_DE us_dep_ech_x_echelon) if oecd == 0 & sample==1, fe  first r
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace

esttab using "TableA56.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	mtitles("IV" "IV" "IV" "IV" "IV" "IV" "IV" "IV")	///
	compress nogaps scalars("Ftest F-Test (1st Stage)" "fixed Country FE" "N_g $\#$ Countries") sfmt(%9.2f %9.0f) ///
	mgroups("Regional Subset" "Non-OECD", pattern(1 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate("Year FE = yd*" , label($\checkmark$ ))	
eststo clear


*	************************************************************************
*	Table A57
*	************************************************************************

eststo: xtivreg2 f.crisis_any2 loggdpcap logpop war ydummy* (logtroops=echolon_alt_DE) if pool == 1, fe  first r
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.crisis_any2 loggdpcap logpop war ecopodata83 ecopodata253 democracy idealdistanceUS time time2 (logtroops=echolon_alt_DE) if pool == 1, fe  first r
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.crisis_any2 loggdpcap logpop war ecopodata83 ecopodata253 democracy idealdistanceUS ydummy* (logtroops=echolon_alt_DE) if pool == 1, fe  first r
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.crisis_any2 loggdpcap logpop war ecopodata83 ecopodata253 democracy ydummy* (logtroops=echolon_alt_DE) if pool == 1 & e(sample)==1, fe  first r
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace

eststo: xtivreg2 f.crisis_any2 loggdpcap logpop war ydummy* (logtroops=echolon_alt_DE) if oecd == 0 & sample==1, fe  first r
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.crisis_any2 loggdpcap logpop war ecopodata83 ecopodata253 democracy idealdistanceUS time time2 (logtroops=echolon_alt_DE) if oecd == 0 , fe  first r
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.crisis_any2 loggdpcap logpop war ecopodata83 ecopodata253 democracy idealdistanceUS ydummy* (logtroops=echolon_alt_DE) if oecd == 0, fe  first r
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace
eststo: xtivreg2 f.crisis_any2 loggdpcap logpop war ecopodata83 ecopodata253 democracy ydummy* (logtroops=echolon_alt_DE) if oecd == 0 & e(sample)==1, fe  first r
estadd scalar Ftest=`e(widstat)'
estadd local fixed "$\checkmark$" , replace

esttab using "TableA57.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	noconstant ///
	nonotes ///	
	mtitles("IV" "IV" "IV" "IV" "IV" "IV" "IV" "IV" "IV" "IV" "IV" "IV")	///
	compress nogaps scalars("Ftest F-Test (1st Stage)" "fixed Country FE" "N_g $\#$ Countries") sfmt(%9.2f %9.0f) ///
	mgroups("Regional Subset" "Non-OECD", pattern(1 0 0 0 1 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))	///
	indicate("Quadratic Time = time*"  "Year FE = ydummy*", label($\checkmark$ ))	
eststo clear

*	************************************************************************
*	Table A58
*	************************************************************************

eststo: reg f.regularturnover crisis_any2, cluster(ccode)
eststo: xtreg f.regularturnover crisis_any2, cluster(ccode) fe
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.regularturnover ydummy* crisis_any2 if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.regularturnover ydummy* crisis_any2 lcrisis_any2 if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.regularturnover ydummy* crisis_any2 lcrisis_any2 l2crisis_any2 if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.regularturnover ydummy* crisis_any2 lcrisis_any2 l2crisis_any2 l3crisis_any2 if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
eststo: xtreg f.regularturnover ydummy* crisis_any2 lcrisis_any2 l2crisis_any2 l3crisis_any2 dpi_pr idealdistanceUS logtroops logpop if sample == 1, fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace

esttab using "TableA58.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	indicate(Year FE = ydummy*, label($\checkmark$ $$$$ ))	///
	mtitles("OLS" "FE" "FE" "FE" "FE" "FE" "FE")	
eststo clear

*	************************************************************************
*	Table A59
*	************************************************************************

eststo: reg logarm logtroops if sample == 1 , cluster(ccode)
eststo: xtreg logarm logtroops  if sample == 1 , cluster(ccode) fe
estadd local fixed "$\checkmark$", replace
eststo: xtreg logarm logtroops time time2  if sample == 1 , cluster(ccode) fe
estadd local fixed "$\checkmark$", replace
eststo: xtreg logarm logtroops ydumm*  if sample == 1 , cluster(ccode) fe
estadd local fixed "$\checkmark$", replace
eststo: xtreg f.logarm logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS ydummy* if sample == 1 , fe cluster(ccode)
estadd local fixed "$\checkmark$" , replace
esttab using "TableA59.tex"	///
	,  booktabs label replace ///
 	nodepvars se(2) b(2) ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	substitute(m$ m\\$)	///
	compress nogaps scalars("rmse $\hat{\sigma}$" "fixed Country FE" "N_g $\#$ Countries") r2(2) sfmt(%9.2f %9.0f) ///
	indicate(Year FE = ydummy*, label($\checkmark$ $$$$ ))	///
	mtitles("OLS" "FE" "FE" "FE" "FE")	
eststo clear

*	************************************************************************
*	C.2 Figures in the Appendix
*	************************************************************************

*	************************************************************************
*	Figure A2
*	************************************************************************

hist logtroopscapita if sample == 1	
graph export "FigA2.pdf", replace as(pdf)

*	************************************************************************
*	Figure A3
*	************************************************************************

tsline totaltroopsyear if year >= 1950 & year <= 2012	///
		,	///
		ylabel(, format(%15.0fc) angle(45))	///
		ylabel(0(200000)1200000)	///
		xlabel(1950(10)2010)	
graph export "FigA3.pdf", replace as(pdf)

*	************************************************************************
*	Figure A4
*	************************************************************************

preserve
egen troopscrisis = total(ustroops) if crisis_any2 == 1, missing
egen troopscrisisf1 = total(ustroops) if l.crisis_any2 == 1, missing
egen troopscrisisf2 = total(ustroops) if l2.crisis_any2 == 1, missing
egen troopscrisisf3 = total(ustroops) if l3.crisis_any2 == 1, missing
egen troopscrisisl1 = total(ustroops) if f.crisis_any2 == 1, missing
egen troopscrisisl2 = total(ustroops) if f2.crisis_any2 == 1, missing
egen troopscrisisl3 = total(ustroops) if f3.crisis_any2 == 1, missing

sum troopscrisis
di r(mean)

gen tnorm = troopscrisis/r(mean)
gen tnormf1 = troopscrisisf1/r(mean)
gen tnormf2 = troopscrisisf2/r(mean)
gen tnormf3 = troopscrisisf3/r(mean)
gen tnorml1 = troopscrisisl1/r(mean)
gen tnorml2 = troopscrisisl2/r(mean)
gen tnorml3 = troopscrisisl3/r(mean)

gen storage = .
sum tnorml3
replace storage = r(mean) if _n == 1	
sum tnorml2
replace storage = r(mean) if _n == 2
sum tnorml1
replace storage = r(mean) if _n == 3
sum tnorm
replace storage = r(mean) if _n == 4
sum tnormf1
replace storage = r(mean) if _n == 5
sum tnormf2
replace storage = r(mean) if _n == 6
sum tnormf3
replace storage = r(mean) if _n == 7

gen nstorage = _n -4 if _n <= 7

twoway (line storage nstorage)	///
		,	///
		scheme(s2mono) graphregion(fcolor(white))	///
		legend( order(1 "Troops (normalized)") )	///
		xtitle("Years before and after Crisis")	///
		ytitle("Troops (t0=1)")	///
		xlabel(-3(1)3)	///
		xline(0)
graph export "FigA4.pdf", replace as(pdf)
restore


*	************************************************************************
*	Figure A5
*	************************************************************************

preserve
probit f.crisis_any2 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS time if sample == 1 & oecd == 0
sum ustroops
range w1 r(min) 500 40
gen logw1 = log(w1+1)
mcp2 ustroops (logtroops)	///
		, var1(w1 (logw1)) show margopts(atmeans) ci 	///
		areaopts(xtitle("Number of US Troops") ytitle("Probability of Crisis"))
graph export "FigA5.pdf", replace as(pdf)
capture drop w1 logw1
restore

*	************************************************************************
*	Figure A6
*	************************************************************************

preserve
xtreg f.crisis_onset3 crisis_any2 logtroops loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS time if sample == 1, fe 

* Create range of 'fake' troops (w1): from min to 500 in 50 categories
sum ustroops if e(sample) == 1
range w1 r(min) 500 50
* Create fake log of troops
gen logw1 = log(w1+1)

mcp2 ustroops (logtroops)	///
		, 	///
		var1(w1 (logw1)) show margopts(atmeans) ci 	///
		areaopts(xtitle("Number of US Troops") ytitle("Probability of Crisis"))
graph export "FigA6.pdf", replace as(pdf)
capture drop w1 logw1


restore

*	************************************************************************
*	Figure A7
*	************************************************************************

preserve
* Reducing observations to quicken calculations
quiet xtivreg2 f.crisis_any2 loggdpcap logpop time (logtroops=echolon_alt_DE) if pool == 1, fe  first r
drop if e(sample)==0
quiet tab countryname, gen(countrydummyV2)
plausexog uci f.crisis_any2 loggdpcap logpop ecopodata83 ecopodata253 democracy idealdistanceUS dec1 dec2 countrydummyV2* 	///
	(logtroops=echolon_alt_DE)	if pool == 1 ///
		, gmin(-0.1)	///
            gmax(0.1)  vce(robust) grid(5)	///
			graph(logtroops) graphdelta(0 0.05 0.2) yline(0)	///
			legend(position(6) col(2) label(1 "Upper Bound") label(2 "Lower Bound"))	///
			xtitle("Delta")
graph export "FigA7.pdf", replace as(pdf)
restore


