/* **********************************************************/
/* Code to Replicate Results in 					        */
/* Bechtel, Michael M./Hainmueller, Jens/Margalit, Yotam	*/
/* "Explaining Support for International Redistribution:    */
/* The Divide over the Eurozone Bailouts."					*/
/* In: American Journal of Political Science				*/

** 3 data files: 
* AJPSrep_online.dta -> Online Sample
* AJPSrep_phone.dta -> Phone Sample
* AJPSrep_exp.dta -> Experimental Sample

* ssc install outreg2
* ssc install ebalance

clear
set more off
* online survey sample
use AJPSrep_online.dta, clear

** ebalance weights
*ebalance ib4.educ ib5.aagegrr female , manual(.438 .257 .145 .148 .149 .205 .174 .511) gen(_webal_rep)
 
/* ********************************************* */
/* Table 1: Attitudes Towards Financial Bailouts */				  
svyset [pweight= _webal]
svy: tab alloppose
svy: tab allpayinless
svy: tab allpayinlessmessage
           
/* ************************************************************************* */
/* Table 2: Predictors of Opposition to Bailouts: Personal Economic Interest */
reg oppose 
outreg2 using table2.xls , excel dec(2) stats(coef se ) replace
set more off
foreach y of varlist oppose payinless  {
* Baseline
svy: reg  `y' female ib1.educ  ib1.hhincgr ownstocks  ib1.aagegrr  
outreg2 using table2.xls , excel dec(2) stats(coef se ) append 

* add transfers
svy: reg  `y' female ib1.educ ib1.hhincgr ownstocks ib1.aagegrr ib0.transfers  
outreg2 using table2.xls , excel dec(2) stats(coef se ) append  

* add region
svy: reg  `y' female ib1.educ ib1.hhincgr ownstocks ib1.aagegrr kk* 
outreg2 using table2.xls , excel dec(2) stats(coef se ) append
testparm kk* 

* add region, employment change, employment status
svy: reg  `y' female ib1.educ ib1.hhincgr ownstocks ib1.aagegrr kk* ib0.empchangegr i.empgr 
outreg2 using table2.xls , excel dec(2) stats(coef se ) append
testparm kk* 

* add region, employment change, employment status, trade ties 
svy: reg  `y' female ib1.educ ib1.hhincgr ownstocks ib1.aagegrr kk* ib0.empchangegr i.empgr ib2.tradeties 
outreg2 using table2.xls , excel dec(2) stats(coef se ) append
testparm kk* 

* add region, employment change, employment status, trade dependence  
svy: reg  `y' female ib1.educ ib1.hhincgr ownstocks ib1.aagegrr kk* ib0.empchangegr i.empgr ib1.TrDependence 
outreg2 using table2.xls , excel dec(2) stats(coef se ) append
testparm kk* 
}

/* ************************************************************************************** */
/* Table 3: Predictors of Opposition to Bailouts: Social Values and Political Orientation */
reg oppose 
outreg2 using table3.xls , excel dec(2) stats(coef se ) replace

foreach y of varlist oppose payinless  {
* baseline model
svy: reg  `y' i.altru_combinedgr i.cosmo female ib1.educ ib1.hhincgr ownstocks ib1.aagegrr kk*  
outreg2 using table3.xls , excel dec(2) stats(coef se ) append

* add political orientation and knowlegde
svy: reg  `y' i.altru_combinedgr i.cosmo female ib1.educ ib1.hhincgr ownstocks  ib1.aagegrr kk* ///
              votecj_* polkn1_PRvote polkn2_correct1
outreg2 using table3.xls , excel dec(2) stats(coef se ) append

* add economic controls 
svy: reg  `y' i.altru_combinedgr i.cosmo female ib1.educ ib1.hhincgr ownstocks ib1.aagegrr kk*  ///
              votecj_* polkn1_PRvote polkn2_correct1 ib0.empchangegr i.empgr ib2.tradeties 
outreg2 using table3.xls , excel dec(2) stats(coef se ) append
}

/* ****************************************************************** */
/* Table 4: Predictors of Opposition to Bailouts: Political Knowledge */
reg oppose 
outreg2 using table4.xls , excel dec(2) stats(coef se ) replace
foreach y of varlist oppose payinless {
* General Knowledge: Low
svy: reg  `y' i.altru_combinedgr i.cosmo votecj_* female ib1.educ ib1.hhincgr ownstocks ib1.aagegrr kk*  if polkn1_PRvote==0
outreg2 using table4.xls , excel dec(2) stats(coef se ) append
* General Knowledge: High
svy: reg  `y' i.altru_combinedgr i.cosmo votecj_* female ib1.educ ib1.hhincgr ownstocks ib1.aagegrr kk* if polkn1_PRvote==1
outreg2 using table4.xls , excel dec(2) stats(coef se ) append
* Specific Knowledge: Low
svy: reg  `y' i.altru_combinedgr i.cosmo votecj_* female ib1.educ ib1.hhincgr ownstocks ib1.aagegrr kk* if polkn2_correct1==0
outreg2 using table4.xls , excel dec(2) stats(coef se ) append
* Specific Knowledge: High
svy: reg  `y' i.altru_combinedgr i.cosmo votecj_* female ib1.educ ib1.hhincgr ownstocks ib1.aagegrr kk*  if polkn2_correct1==1
outreg2 using table4.xls , excel dec(2) stats(coef se ) append
}


/* ***************************************************************************************************************** */
/* Table 5: Predictors of Opposition to Bailouts: Social Values and Political Orientation (Quasi-Behavioral Measure) */
reg oppose 
outreg2 using table5.xls , excel dec(2) stats(coef se ) replace
foreach y of varlist payinlessmessage  {
* baseline model
svy: reg  `y' i.altru_combinedgr i.cosmo female ib1.educ  ib1.hhincgr ownstocks  ib1.aagegrr kk*  
outreg2 using table5.xls , excel dec(2) stats(coef se ) append

* add political orientation and knowlegde
svy: reg  `y' i.altru_combinedgr i.cosmo votecj_* polkn1_PRvote polkn2_correct1 female ib1.educ ib1.hhincgr ownstocks ib1.aagegrr kk* ///
              
outreg2 using table5.xls , excel dec(2) stats(coef se ) append

* add economic controls 
svy: reg  `y' i.altru_combinedgr i.cosmo votecj_* polkn1_PRvote polkn2_correct1 female ib1.educ ib1.hhincgr ownstocks ib1.aagegrr kk* ///
               ib0.empchangegr i.empgr ib2.tradeties 
outreg2 using table5.xls , excel dec(2) stats(coef se ) append
}


/* ************************************************************** */
/* Figure 1: The Correlates of Preferences for Financial Bailouts */ 
gen empchangegr1  = (empchangegr==1)  if empchangegr!=.
gen empchangegr2  = (empchangegr==2)  if empchangegr!=.
gen empchangegr3  = (empchangegr==3)  if empchangegr!=.
gen empchangegr99 = (empchangegr==99) if empchangegr!=.

gen tradeties1  = (tradeties==1) if tradeties!=.
gen tradeties3  = (tradeties==3) if tradeties!=.
gen tradeties4  = (tradeties==4) if tradeties!=.
gen tradeties5  = (tradeties==5) if tradeties!=.
gen tradeties99 = (tradeties==99) if tradeties!=.

* oppose bailout
svy: reg  d2opposebailouts female ib1.educ ib1.aagegrr kk* ib1.hhincgr ownstocks    empchangegr99 empchangegr1-empchangegr3  i.empgr tradeties1-tradeties99  ///
                  i.altru_combinedgr i.cosmo votecj_* polkn1_PRvote polkn2_correct1					  
outreg2 using Figure1.xls , excel dec(2) stats(coef se ) replace
matrix outt = (e(b) \ vecdiag(e(V)))'
mat2txt , matrix(outt) saving(BinaryOppose) replace

* pay in less bailout
svy: reg  d2payinless female ib1.educ ib1.aagegrr kk* ib1.hhincgr ownstocks    empchangegr99 empchangegr1-empchangegr3  i.empgr tradeties1-tradeties99  ///
                  i.altru_combinedgr i.cosmo votecj_* polkn1_PRvote polkn2_correct1					  
outreg2 using Figure1.xls , excel dec(2) stats(coef se ) append
matrix outt = (e(b) \ vecdiag(e(V)))'
mat2txt , matrix(outt) saving(BinaryOpposePayinLess) replace

* quasi behavioral
svy: reg  d2payinlessmessage female ib1.educ ib1.aagegrr kk* ib1.hhincgr ownstocks    empchangegr99 empchangegr1-empchangegr3  i.empgr tradeties1-tradeties99  ///
                  i.altru_combinedgr i.cosmo votecj_* polkn1_PRvote polkn2_correct1						  
outreg2 using Figure1.xls , excel dec(2) stats(coef se ) append
matrix outt = (e(b) \ vecdiag(e(V)))'
mat2txt , matrix(outt) saving(BinaryOpposeMessage) replace


/* ********************************** */
/* Figure 2 and Table S.1. see below   */


/* ******************************** */
/* Table S.2 Descriptive Statistics */
sum oppose payinless payinlessmessage ibn.altru_combinedgr polkn1_PRvote polkn2_correct1 ///
    ibn.cosmo votecjCDUCSU votecj_* ibn.empgr ibn.empchangegr empdelta_ft2010_08  ///
	ibn.tradeties ibn.TrDependence tradedependence_2010 ibn.hhincgr ownstocks ///
	ibn.educ ibn.aagegrr female ibn.transfers kk* BadenWuerttemberg 
                

		
/* **************************************************************************************** */
/* Table S.3: Opposition to Bailouts by Political Knowledge: Personal Economic Interest (a) */				
/* Table S.4: Opposition to Bailouts by Political Knowledge: Personal Economic Interest (b) */				
reg oppose 
outreg2 using tableS34.xls , excel dec(2) stats(coef se ) replace

foreach y of varlist oppose payinless  {
* Baseline
foreach i of numlist 0 1 {
svy: reg  `y' female ib1.educ  ib1.hhincgr ownstocks  ib1.aagegrr  if polkn1_PRvote==`i'
outreg2 using tableS34.xls , excel dec(2) stats(coef se ) append 
}
* add transfers
foreach i of numlist 0 1 {
svy: reg  `y' female ib1.educ  ib1.hhincgr ownstocks  ib1.aagegrr ib0.transfers  if polkn1_PRvote==`i'
outreg2 using tableS34.xls , excel dec(2) stats(coef se ) append  
}
* add region
foreach i of numlist 0 1 {
svy: reg  `y' female ib1.educ  ib1.hhincgr ownstocks  ib1.aagegrr kk* if polkn1_PRvote==`i'
outreg2 using tableS34.xls , excel dec(2) stats(coef se ) append
}
* add region, employment change, employment status
foreach i of numlist 0 1 {
svy: reg  `y' female ib1.educ  ib1.hhincgr ownstocks  ib1.aagegrr kk* ib0.empchangegr i.empgr if polkn1_PRvote==`i'
outreg2 using tableS34.xls , excel dec(2) stats(coef se ) append
}
* add region, employment change, employment status, trade ties 
foreach i of numlist 0 1 {
svy: reg  `y' female ib1.educ  ib1.hhincgr ownstocks  ib1.aagegrr kk* ib0.empchangegr i.empgr ib2.tradeties if polkn1_PRvote==`i'
outreg2 using tableS34.xls , excel dec(2) stats(coef se ) append
}
* add region, employment change, employment status, trade dependence  
foreach i of numlist 0 1 {
svy: reg  `y' female ib1.educ  ib1.hhincgr ownstocks ib1.aagegrr kk* ib0.empchangegr i.empgr ib1.TrDependence if polkn1_PRvote==`i'
outreg2 using tableS34.xls , excel dec(2) stats(coef se ) append
}
}

/* ************************************************* */
/* Table S.5: Skill Level and Opposition to Bailouts */				
* Includes: Full-time employed, part-time employed, less than part-time employed, temporary employed
* Rest: excluded
recode empgr (1/2=1) (4=0) (3=0) (5=0)   , gen(splitt)
 
reg oppose 
outreg2 using tableS5.xls , excel dec(2) stats(coef se ) replace
* in and out
foreach y of varlist oppose payinless payinlessmessage {
 foreach i of numlist 1 0 {
  svy: reg  `y' i.skill ib1.aagegrr ib1.hhincgr female kk* if splitt==`i'
  outreg2 using tableS5.xls , excel dec(2) stats(coef se ) append
 }
* retired
svy: reg  `y' i.skill ib1.aagegrr ib1.hhincgr female kk*   if empgr==5
outreg2 using tableS5.xls , excel dec(2) stats(coef se ) append
}


/* ****************************************************************************************************** */				
/* Table S.6: The Correlates of Preferences for Financial Bailouts: Comparison of OLS and Logit Estimates */
svy: reg  d2opposebailouts 			  
outreg2 using tableS6.xls , excel dec(2) stats(coef se ) replace
foreach y of varlist d2opposebailouts d2payinless d2payinlessmessage {
* oppose bailout
svy: reg  `y' female ib1.educ ib1.hhincgr ownstocks ib1.aagegrr empchangegr99 empchangegr1-empchangegr3 i.empgr tradeties1-tradeties99  ///
                  i.altru_combinedgr i.cosmo votecj_* polkn1_PRvote polkn2_correct1	kk*				  
outreg2 using tableS6.xls , excel dec(2) stats(coef se ) append

svy: logit  `y' female ib1.educ ib1.hhincgr ownstocks ib1.aagegrr empchangegr99 empchangegr1-empchangegr3  i.empgr tradeties1-tradeties5  ///
                  i.altru_combinedgr i.cosmo votecj_* polkn1_PRvote polkn2_correct1 kk*						  
margins , dydx(*) post vce(unconditional) 
outreg2 using tableS6.xls , excel dec(2) stats(coef se ) append
}


/* ******************************************************************************* */
/* Table S.7: The Correlates of Preferences for Financial Bailouts (Ordered Logit) */
svy: reg  oppose 			  
outreg2 using tableS7.xls , excel dec(2) stats(coef se ) replace

foreach y of varlist oppose payinless payinlessmessage {
svy: ologit  `y' female ib1.educ ib1.hhincgr ownstocks ib1.aagegrr empchangegr1-empchangegr3 i.empgr tradeties3-tradeties5   ///
                  i.altru_combinedgr i.cosmo votecj_* polkn1_PRvote polkn2_correct1	empchangegr99 tradeties1 tradeties99 kk*				  
outreg2 using tableS7.xls , excel dec(2) stats(coef se ) append
}

/* **************************************************************************************** */
/* Table S.8: Opposition to Bailouts: Personal Economic Interest (Quasi Behavioral Measure) */

reg payinlessmessage 
outreg2 using tableS8.xls , excel dec(2) stats(coef se ) replace

foreach y of varlist payinlessmessage  {
* Baseline
svy: reg  `y' female ib1.educ  ib1.hhincgr ownstocks  ib1.aagegrr  
outreg2 using tableS8.xls , excel dec(2) stats(coef se ) append 

* add transfers
svy: reg  `y' female ib1.educ  ib1.hhincgr ownstocks  ib1.aagegrr ib0.transfers  
outreg2 using tableS8.xls , excel dec(2) stats(coef se ) append  

* add region
svy: reg  `y' female ib1.educ  ib1.hhincgr ownstocks  ib1.aagegrr kk* 
outreg2 using tableS8.xls , excel dec(2) stats(coef se ) append

* add region, employment change, employment status
svy: reg  `y' female ib1.educ  ib1.hhincgr ownstocks  ib1.aagegrr kk* ib0.empchangegr i.empgr 
outreg2 using tableS8.xls , excel dec(2) stats(coef se ) append

* add region, employment change, employment status, trade ties 
svy: reg  `y' female ib1.educ  ib1.hhincgr ownstocks  ib1.aagegrr kk* ib0.empchangegr i.empgr ib2.tradeties 
outreg2 using tableS8.xls , excel dec(2) stats(coef se ) append

* add region, employment change, employment status, trade dependence  
svy: reg  `y' female ib1.educ  ib1.hhincgr ownstocks ib1.aagegrr kk* ib0.empchangegr i.empgr ib1.TrDependence 
outreg2 using tableS8.xls , excel dec(2) stats(coef se ) append
}

/* **************************************************************************************** */
/* Table S.9: Opposition to Bailouts by Political Knowledge: Personal Economic Interest (c) */
reg payinlessmessage 
outreg2 using tableS9.xls , excel dec(2) stats(coef se ) replace

foreach y of varlist payinlessmessage  {
 
* Baseline
foreach i of numlist 0 1 {
svy: reg  `y' female ib1.educ  ib1.hhincgr ownstocks  ib1.aagegrr  if polkn1_PRvote==`i'
outreg2 using tableS9.xls , excel dec(2) stats(coef se ) append 
}
* add transfers
foreach i of numlist 0 1 {
svy: reg  `y' female ib1.educ  ib1.hhincgr ownstocks  ib1.aagegrr ib0.transfers  if polkn1_PRvote==`i'
outreg2 using tableS9.xls , excel dec(2) stats(coef se ) append  
}
* add region
foreach i of numlist 0 1 {
svy: reg  `y' female ib1.educ  ib1.hhincgr ownstocks  ib1.aagegrr kk* if polkn1_PRvote==`i'
outreg2 using tableS9.xls , excel dec(2) stats(coef se ) append
}
* add region, employment change, employment status
foreach i of numlist 0 1 {
svy: reg  `y' female ib1.educ  ib1.hhincgr ownstocks  ib1.aagegrr kk* ib0.empchangegr i.empgr if polkn1_PRvote==`i'
outreg2 using tableS9.xls , excel dec(2) stats(coef se ) append
}
* add region, employment change, employment status, trade ties 
foreach i of numlist 0 1 {
svy: reg  `y' female ib1.educ  ib1.hhincgr ownstocks  ib1.aagegrr kk* ib0.empchangegr i.empgr ib2.tradeties if polkn1_PRvote==`i'
outreg2 using tableS9.xls , excel dec(2) stats(coef se ) append
}
* add region, employment change, employment status, trade dependence  
foreach i of numlist 0 1 {
svy: reg  `y' female ib1.educ  ib1.hhincgr ownstocks ib1.aagegrr kk* ib0.empchangegr i.empgr ib1.TrDependence if polkn1_PRvote==`i'
outreg2 using tableS9.xls , excel dec(2) stats(coef se ) append
 }
}

/* ************************************************************************************************ */
/* Table S.10: Predictors of Opposition to Bailouts: Political Knowledge (Quasi Behavioral Measure) */
reg payinlessmessage 
outreg2 using tableS10.xls , excel dec(2) stats(coef se ) replace
foreach y of varlist payinlessmessage {
* General Knowledge: Low
svy: reg  `y' i.altru_combinedgr i.cosmo votecj_* female ib1.educ ib1.hhincgr ownstocks ib1.aagegrr kk*  if polkn1_PRvote==0
outreg2 using tableS10.xls , excel dec(2) stats(coef se ) append
* General Knowledge: High
svy: reg  `y' i.altru_combinedgr i.cosmo votecj_* female ib1.educ ib1.hhincgr ownstocks ib1.aagegrr kk* if polkn1_PRvote==1
outreg2 using tableS10.xls , excel dec(2) stats(coef se ) append
* Specific Knowledge: Low
svy: reg  `y' i.altru_combinedgr i.cosmo votecj_* female ib1.educ  ib1.hhincgr ownstocks ib1.aagegrr kk* if polkn2_correct1==0
outreg2 using tableS10.xls , excel dec(2) stats(coef se ) append
* Specific Knowledge: High
svy: reg  `y' i.altru_combinedgr i.cosmo votecj_* female ib1.educ ib1.hhincgr ownstocks ib1.aagegrr kk* if polkn2_correct1==1
outreg2 using tableS10.xls , excel dec(2) stats(coef se ) append
}

/* ********************* */
/* Merge in Phone Survey */
gen mode = 0

* recode hhinc to make it comparable to phone survey
* Phone:  label define Hhinc 1 "<500 EUR" 2 "500-1000 EURO" 3 "1k-1.5k EUR" 4 "1.5k-2K EUR" 5 "2k-2.5k EUR" 6 "2.5k-3.5k EUR" 7 "3.5k-5k EUR" 8 ">5k EUR" 99 "dont know"
* online: label define Hhinc 1 "<500 EUR" 2 "500-1000 EURO" 3 "1k-1.5k EUR" 4 "1.5k-2K EUR" 5 "2k-2.5k EUR" 6 "2.5k-3k EUR"   7 "3k-3.5k EUR" 8 "3.5k-4k EUR" 9 "4k-4.5k EUR" 10 ">4.5k EUR" 99 "dont know"
recode hhinc (7/9=7) (10=8) 
label define Hhinc2 1 "<500 EUR" 2 "500-1000 EURO" 3 "1k-1.5k EUR" 4 "1.5k-2K EUR" 5 "2k-2.5k EUR" 6 "2.5k-3.5k EUR" 7 "3.5k-5k EUR" 8 ">5k EUR" 99 "dont know"
label values hhinc Hhinc2

* recode employment status to make it comparable to phone survey 
* FT, PT, Educ, UE, retired 
recode emp_status (2/4=2) (5/7=3) (8=4) (9/10=5)
label define emp2 1 "FT" 2 "PT" 3 "Educ" 4 "unemployed" 5 "retired"
label values emp_status emp2

* phone sample
append using AJPSrep_phone.dta

replace mode = 1 if mode==.
label define Mode 0 "online" 1 "phone"
label values mode Mode

gen agegr18_29 = (age>14 & age<30)
gen agegr30_39 = (age>29 & age<40)
gen agegr40_49 = (age>39 & age<50)
gen agegr50_59 = (age>49 & age<60)
gen agegr60p   = (age>=60 & age!=.)

tab educ, gen(educgr)
rename _webal webal

* reweight phone survey on educ, age, and gender to meet population margins
ebalance educgr* agegr18_29- agegr50_59 female , manual(.438 .257 .145 .148 .149 .205 .174 .511) , if mode==1
replace webal = _webal if webal==.
drop _webal

/* **************************************************** */
/* Table S.1: Demographics of the Survey Samples (in %) */
* col 2:  Raw Online Sample
mean educgr* agegr* female if mode==0
* col 3: Raw Phone Sample
mean educgr* agegr* female if mode==1
* col 4: Weighted Online Sample
mean educgr* agegr* female [pweight=webal] if mode==0
* col 5: Phone Sample
mean educgr* agegr* female [pweight=webal] if mode==1


/* ***************************************************************************************** */
/* Table S.11: Comparison of Attitudes Towards Financial Bailouts in Online and Phone Sample */
svyset [pweight= webal]
* Against bailouts, all Respondents: Online
svy: tab alloppose if mode==0
* Against bailouts, all Respondents: Phone
svy: tab alloppose if mode==1

* Against bailouts, w/o Neither: Online
svy: tab alloppose if mode==0 & alloppose!=3 & alloppose!=99
* Against bailouts, w/o Neither: Phone
svy: tab alloppose if mode==1 & alloppose!=3 & alloppose!=99

* Pay in less, all Respondents: Online
svy: tab allpayinless if mode==0
* Pay in less, all Respondents: Phone
svy: tab allpayinless if mode==1

* Pay in less, w/o Neither: Online
svy: tab allpayinless if mode==0 & allpayinless!=3 & allpayinless!=99
* Pay in less, w/o Neither: Phone
svy: tab allpayinless if mode==1 & allpayinless!=3 & allpayinless!=99


/* ************************************************************************ */
/* Table S.12: Predictors of Opposition to Bailouts: Online vs Phone Survey */
replace aagegrr = 1 if agegr18_29==1
replace aagegrr = 2 if agegr30_39==1
replace aagegrr = 3 if agegr40_49==1
replace aagegrr = 4 if agegr50_59==1
replace aagegrr = 5 if agegr60p==1

recode hhinc (1/2=1) (3/4=2) (5/6=3) (7=4) (8=5) 

svy: reg oppose 
outreg2 using tableS12.xls , excel dec(2) sideway stats(coef se )  replace

foreach y of varlist oppose payinless {
* weighted
svy: reg `y' mode##i.aagegrr mode##i.educ  mode##i.hhinc mode##female  mode##i.emp_status
outreg2 using tableS12.xls , excel dec(2) sideway stats(coef se ) append
* joint test
test 1.female 1.mode#2.hhinc 1.mode#3.hhinc 1.mode#4.hhinc 1.mode#5.hhinc 1.mode#99.hhinc ///
     1.mode#2.aagegrr 1.mode#3.aagegrr 1.mode#4.aagegrr 1.mode#5.aagegrr ///
	 1.mode#2.educ 1.mode#3.educ 1.mode#4.educ ///
	 1.mode#2.emp_status 1.mode#3.emp_status 1.mode#4.emp_status 1.mode#5.emp_status 
* unweighted
reg `y' mode##i.aagegrr mode##i.educ  mode##i.hhinc mode##female  mode##i.emp_status
outreg2 using tableS12.xls , excel dec(2) sideway stats(coef se ) append
* joint test
test 1.female 1.mode#2.hhinc 1.mode#3.hhinc 1.mode#4.hhinc 1.mode#5.hhinc 1.mode#99.hhinc ///
     1.mode#2.aagegrr 1.mode#3.aagegrr 1.mode#4.aagegrr 1.mode#5.aagegrr ///
	 1.mode#2.educ 1.mode#3.educ 1.mode#4.educ ///
	 1.mode#2.emp_status 1.mode#3.emp_status 1.mode#4.emp_status 1.mode#5.emp_status 
}

/* ********************** */
/* Experimental data      */
use "AJPSrep_exp.dta", replace

/* ***************************************************************************************************************************** */
/* Figure 2: The Effects of Increases in the Size of Contributions to Financial Bailouts: Experimental Results by Income Groups  */

* all 
reg rejectedd i.FeatGercontrib  , cl(ResponseID) 
matrix outt = (e(b) \ vecdiag(e(V)))'
mat2txt , matrix(outt) saving(FramInc0) replace
* low, medium, and high income
forvalues i = 1(1)3 {
reg rejectedd  i.FeatGercontrib  , cl(ResponseID) , if hhincgr==`i'
matrix outt = (e(b) \ vecdiag(e(V)))'
mat2txt , matrix(outt) saving(FramInc`i') replace
}

/* *************************************************************************************************************************** */
/* Figure S.1: The Effects of Increases in the Size of Contributions to Financial Bailouts: Experimental Results by Trade Ties */

* all
reg rejectedd i.FeatGercontrib  , cl(ResponseID) 
matrix outt = (e(b) \ vecdiag(e(V)))'
mat2txt , matrix(outt) saving(FramTrad0) replace
* no, weak, and strong trade ties
forvalues i = 1(1)3 {
reg rejectedd  i.FeatGercontrib  , cl(ResponseID), if tradetiesgr==`i'
matrix outt = (e(b) \ vecdiag(e(V)))'
mat2txt , matrix(outt) saving(FramTrad`i') replace
}
clear
exit
