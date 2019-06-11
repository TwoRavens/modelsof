clear all 

version 14  
set more off
set logtype text
set linesize 255

cd "~/Dropbox/WRD/public/replication/"
eststo clear


set scheme plotplainblind


* Published models
******************

insheet using "./rawdata/RefugeesWar_directed.tab", clear

probit mzinit_lead logref1 logref2 /// 
	uppcivcon1 uppcivcon2 dem1 dem2 demdem trans1 /// 
	trans2 transtrans contig colcont capshare /// 
	s_wt_glo depend1 depend2 igos lpcyrs* /// 
	if year >=1955, cluster(dyad)
eststo model1

lroc,nograph
estadd r(area)


	
* Models with imputed data
*************************** 

use "./usedata/RefugeesWar_directed_imputed.dta",clear

probit mzinit_lead logref1 logref2 ///
	uppcivcon1 uppcivcon2 dem1 dem2 demdem trans1 /// 
	trans2 transtrans contig colcont capshare /// 
	s_wt_glo depend1 depend2 igos lpcyrs* /// 
	if year >=1955, cluster(dyad)
eststo model2


lsens, gensens(sens2) genspec(spec2) replace nodraw
gen spec_2 = 1-spec2
drop spec2

lroc,nograph
estadd r(area)

eststo m2: margins, dydx(logref1 logref2) post



probit mzinit_lead tot_lasso1 tot_lasso2 ///
	uppcivcon1 uppcivcon2 dem1 dem2 demdem trans1 ///
	trans2 transtrans contig colcont capshare ///
	s_wt_glo depend1 depend2 igos lpcyrs* /// 
	if year >=1955, cluster(dyad)
eststo model3

lsens, gensens(sens3) genspec(spec3) replace nodraw
gen spec_3 = 1-spec3
drop spec3

lroc,nograph
estadd r(area)

eststo m3: margins, dydx(tot_lasso1 tot_lasso2) post



probit mzinit_lead tot_linpol1 tot_linpol2 ///
	uppcivcon1 uppcivcon2 dem1 dem2 demdem trans1 ///
	trans2 transtrans contig colcont capshare ///
	s_wt_glo depend1 depend2 igos lpcyrs* /// 
	if year >=1955, cluster(dyad)
eststo model4

lsens, gensens(sens4) genspec(spec4) replace nodraw
gen spec_4 = 1-spec4
drop spec4

lroc,nograph
estadd r(area)

eststo m4: margins, dydx(tot_linpol1 tot_linpol2) post


* Output tables 
*************** 

label variable logref1 "Refugee Stock in Initiator" 
label variable logref2 "Refugee Stock from Initiator" 
label variable uppcivcon1 "Civil War in Initiator"
label variable uppcivcon2 "Civil War in Target"
label variable dem1 "Democratic in Initiator"
label variable dem2 "Democratic in Target"
label variable demdem "Both Democratic"
label variable trans1 "Transitional Initiator"
label variable trans2 "Transitional Target"
label variable transtrans "Both Transitional"
label variable contig "Contiguity"
label variable colcont "Colonial Contiguity"
label variable capshare "Capability Share"
label variable s_wt_glo "Alliance S-Score"
label variable depend1 "Initiator's Trade Dep."
label variable depend2 "Target's Trade Dep."
label variable igos "Shared IGO Membership"
label variable lpcyrs "Peace Years"
label variable lpcyrs1 "_spline1"
label variable lpcyrs2 "_spline2"
label variable lpcyrs3 "_spline2"

* Coefficient estimates
esttab model1 model2 model3 model4 using "./results/tab_long.tex", /// 
	b(3) se(4) label booktabs replace aic(0) ///
	rename(tot_lasso1 logref1 tot_lasso2 logref2 /// 
		tot_linpol1 logref1 tot_linpol2 logref2) ///
	scalars("area Area(ROC)") sfmt(3) obslast nostar nogaps
 
esttab model1 model2 model3 model4 using "./results/tab_short2.tex", /// 
	b(3) se(4) scalars("area Area(ROC)") sfmt(3) ///
	rename(tot_lasso1 logref1 tot_lasso2 logref2 /// 
		tot_linpol1 logref1 tot_linpol2 logref2) ///
	keep(logref1 logref2) ///
	replace booktabs label obslast nostar nogaps


* Partial effects 
esttab m2 m3 m4 using "./results/tab_marg2.tex" , b(4) se(5) ///
		rename(tot_lasso1 logref1 tot_lasso2 logref2 /// 
		tot_linpol1 logref1 tot_linpol2 logref2) ///
	label replace booktabs nostar nogaps noobs
	
	

* OLS * 
******* 
 
eststo clear

use "./usedata/RefugeesWar_directed_imputed.dta",clear

reg mzinit_lead logref1 logref2 ///
	uppcivcon1 uppcivcon2 dem1 dem2 demdem trans1 /// 
	trans2 transtrans contig colcont capshare /// 
	s_wt_glo depend1 depend2 igos lpcyrs* /// 
	if year >=1955, cluster(dyad)
eststo model2

reg mzinit_lead tot_lasso1 tot_lasso2 ///
	uppcivcon1 uppcivcon2 dem1 dem2 demdem trans1 ///
	trans2 transtrans contig colcont capshare ///
	s_wt_glo depend1 depend2 igos lpcyrs* /// 
	if year >=1955, cluster(dyad)
eststo model3
		
reg mzinit_lead tot_linpol1 tot_linpol2 ///
	uppcivcon1 uppcivcon2 dem1 dem2 demdem trans1 ///
	trans2 transtrans contig colcont capshare ///
	s_wt_glo depend1 depend2 igos lpcyrs* /// 
	if year >=1955, cluster(dyad)
eststo model4


label variable logref1 "Refugee Stock in Initiator" 
label variable logref2 "Refugee Stock from Initiator" 

esttab model2 model3 model4 using "./results/tab_short_ols2.tex", /// 
	ar2 label noconstant b(4) se(4) ///
	keep(logref1 logref2) ///
	rename(tot_lasso1 logref1 tot_lasso2 logref2 /// 
		tot_linpol1 logref1 tot_linpol2 logref2) ///
	booktabs replace nostar nogaps

		
	
