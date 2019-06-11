* KRAUSE & COOK "POLICY PRIORITIES" (JANUARY 9, 2013): ALTERNATIVE MODEL 4 ANALYSIS (RESTRICTED MODEL: EXCLUSION OF TIME DUMMY FIXED EFFECTS IN EIP MODEL -- REPORTED IN SUPPLEMENTARY APPENDIX DOCUMENT) 

* OPEN STATA OUTPUT FILE LOG

log using "D:\Asymmetric Loss Project\New Version (2012)\Data Folder\policy priorities.restricted alternative EIP models.01-09-13.smcl", replace


* OPEN "BASE 'PURSE STRINGS'" DATA SET
  
use "D:\Asymmetric Loss Project\New Version (2012)\Data Folder\policy priorities.02-01-12.dta", clear
  
  ************************************************************************************************************************************************************************************************************************************************************************************** EIP MODEL: MODEL 4 (RESTRICTED MODEL REPORTED IN SUPPLEMENTARY APPENDIX: TIMEWISE DUMMY FIXED EFFECTS IN EIP MODEL ARE OMITTED) ********

*** NOTE: THE 'RESTRICTED' EIP MODEL ONLY CONTAINS AGENCY-LEVEL (CROSS-SECTIONAL) FIXED EFFECTS *** 
************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************

**** FIRST-STAGE ESTIMATION: OBTAINING EXTERNALLY-INDUCED BUDGETARY PREFERENCE (EIP) PROPOSAL MODEL ESTIMATES *****

set more off 

xtset agencycode fiscalyear, yearly
* eststo clear

** MODEL 2 (REPORTED IN THE SUPPLEMENTARY APPENDIX): (USE FOLLOWING 'AGENCY-IDEOLOGY' ADJUSTED COVARIATES: HDEMPCTAI, SDEMPCTAI, ASCIHA, & ASCTHA INTERACTION TERMS FROM SCP PROPOSAL MODEL SPECIFICATION)
xtreg prgrowth hdempctai sdempctai congelyr cpartmajchangecorrected asctha asciha lagbudgetgap ueratepres lagfedsurpdefpctgdp vietiraqwardefense budget74amends grh any_supp, fe cluster(agencycode)	 	
		
* OBTAIN THE EXTERNALLY-INDUCED BUDEGTARY PREFERENCE (EIP) PROPOSAL MODEL ESTIMATES BY COMPUTING THE PREDICTED VALUES OF THE DEPENDENT VARIABLE FROM THE PRECEDING REGRESSION MODEL *estat icpredict eip, xbu



***************************************************************************************************************************************

***************************************************************************************************************************************

***************************************************************************************************************************************


**** SECOND-STAGE ESTIMATION: OBTAINING GENERALIZED PROPOSAL (GP) MODEL ESTIMATES *****


**** EQUATION (2.1): EXCESS FUNDINGS BIAS EQUATION ANALYSIS *****
* The xtset needs to be cleared in order to make the bootstrap process work with the cluster() and idcluster()
xtset, clearbootstrap _b, reps(10008) bca seed(123) nodots cluster(agencycode) idcluster(newagencycode): regress prgrowth eip presparty libagency modagency partymod partylibestat ic
predict bstrapeq2, xbxtile bootmedcons1=_b[_cons], nquantiles(2)xtile bootmedeip=_b[eip], nquantiles(2)xtile bootmedparty=_b[presparty], nquantiles(2)xtile bootmedlibagency=_b[libagency], nquantiles(2)xtile bootmedmodagency=_b[modagency], nquantiles(2)xtile bootmedpartymod=_b[partymod], nquantiles(2)xtile bootmedpartylib=_b[partylib], nquantiles(2)
* Now we have to Reset the Panel Data Declaration
xtset agencycode fiscalyear, yearly
* Generating Predicted Values of the Observed Proposal (OP)
gen predreq1=bootmedcons1+bootmedeip*eip+bootmedparty*presparty+bootmedlibagency*libagency+bootmedmodagency*modagency+bootmedpartymod*partymod+bootmedpartylib*partylib
* Generating the Residuals from Stage 1
gen residstage1=prgrowth-predreq1gen absresidstage1=abs(residstage1)

************************************************************************************************************************************** EQUATION (2.2) -- FIRST-STAGE ARCH(j) MODEL ESTIMATES: j=1, j=2, j=3, & j=4 (ANALYSIS FROM 1 TO 4 LAGS ON THE ARCH TERMS) **************************************************************************************************************************************
xtreg absresidstage1 l.absresidstage1, fe
predict absresid1stpred1, xbu
estat ic 
*

xtreg absresidstage1 l(1/2).absresidstage1, fe
predict absresid1stpred2, xbu
estat ic
*

xtreg absresidstage1 l(1/3).absresidstage1, fe
predict absresid1stpred3, xbu
estat ic
*

xtreg absresidstage1 l(1/4).absresidstage1, fe
predict absresid1stpred4, xbu
estat ic
*


correlate absresid1stpred1 absresid1stpred2 absresid1stpred3 absresid1stpred4 

************************************************************************************************************************************************************************************************************************************** * BASE SUBSEQUENT ANALYSIS ON ARCH(1)RESIDUAL PROCESS OBTAINED IN EQUATION (2.2) SINCE IT IS BEST FIT TO DATA AND HIGHLY CORRELATED WITH HIGHER-ORDER ARCH PROCESSES *
************************************************************************************************************************************************************************************************************************************** 


*The result from the above list of procedures is that we will use a single lag for the model to bootstrap* Bootstrapped ARCH model using the asbsolute values of the residuals from the preceding procedure *xtset agencycode fiscalyear, yearly

************************************************************************************************************************************************************************************************************************************** * EQUATION (2.3): ESTIMATE "FINAL" FIRST-STAGE ARCH(1) RESIDUAL ANALYSIS *
************************************************************************************************************************************************************************************************************************************** 
gen lagabsresidstage1=l.absresidstage1bootstrap _b, reps(10003) bca seed(123) nodots saving(eq3boot, replace): xtreg absresidstage1 lagabsresidstage1, feestat ic
predict bstrapeq3, xbuxtile bootmedcons2=_b[_cons], nquantiles(2)xtile bootmedlagabsresid2=_b[lagabsresidstage1], nquantiles(2)gen cfesdhat1=bootmedcons2+bootmedlagabsresid2*lagabsresidstage1 gen cfesd1party=cfesdhat1*prespartygen cfesd1modagency=cfesdhat1*modagencygen cfesd1libagency=cfesdhat1*libagencygen cfesd1partymodag=cfesdhat1*modagency*prespartygen cfesd1partylibag=cfesdhat1*libagency*prespartyregress prgrowth eip presparty libagency modagency partymod partylib /// 	cfesdhat1 cfesd1party cfesd1modagency cfesd1libagency cfesd1partymodag cfesd1partylibag
************************************************************************************************************************************************************************************************************************************** * EQUATION (2.4): FIRST-STAGE GENERALIZED PROPOSAL MODEL ESTIMATES *
************************************************************************************************************************************************************************************************************************************** 

xtset, clear
bootstrap _b, reps(10010) bca seed(123) nodots cluster(agencycode) idcluster(new2agencycode) saving(cfesregboot, replace): ///	regress prgrowth eip presparty libagency modagency partymod partylib cfesdhat1 cfesd1party ///	cfesd1modagency cfesd1libagency cfesd1partymodag cfesd1partylibag
    estat ic 
	
	predict bstrapeq4, xbxtile bootmedcons3=_b[_cons], nquantiles(2)xtile bootmedeip3=_b[eip], nquantiles(2)xtile bootmedparty3=_b[presparty], nquantiles(2) xtile bootmedlibagency3=_b[libagency], nquantiles(2)xtile bootmedmodagency3=_b[modagency], nquantiles(2)xtile bootmedpartymod3=_b[partymod], nquantiles(2)xtile bootmedpartylib3=_b[partylib], nquantiles(2)xtile bootmedcfesd3=_b[cfesdhat1],  nquantiles(2)xtile bootmedcfesdparty3=_b[cfesd1party],  nquantiles(2)xtile bootmedcfesdma3=_b[cfesd1modagency],  nquantiles(2)xtile bootmedcfesdla3=_b[cfesd1libagency],  nquantiles(2)xtile bootmedcfesdpma3=_b[cfesd1partymodag],  nquantiles(2)xtile bootmedcfesdpla3=_b[cfesd1partylibag], nquantiles(2)xtset agencycode fiscalyear, yearlygenerate predvalstage2= bootmedcons3 + bootmedparty3*presparty + bootmedeip3*eip + ///	bootmedlibagency3*libagency + bootmedmodagency3*modagency + bootmedpartymod3*partymod + bootmedpartylib3*partylib + ///	bootmedcfesd3*cfesdhat1+ bootmedcfesdparty3*cfesd1party + bootmedcfesdma3*cfesd1modagency + ///	bootmedcfesdla3*cfesd1libagency + bootmedcfesdpma3*cfesd1partymodag + bootmedcfesdpla3*cfesd1partylibag
	*generate residuals and absolute residuals from the prior procedures 
gen residstage2 = prgrowth-predvalstage2
gen absresidstage2 = abs(residstage2)




************************************************************************************************************************************************************************************************************************************** 
* Testing the Residual Process from SECOND-STAGE ARCH(j) Analysis (ANALYSIS FROM 1 TO 4 LAGS ON THE ARCH TERMS) *
************************************************************************************************************************************************************************************************************************************** 

xtreg absresidstage2 l(1/1).absresidstage2, feestat icpredict absresid2ndpred1, xbu
*

xtreg absresidstage2 l(1/2).absresidstage2, feestat ic
predict absresid2ndpred2, xbu
*
xtreg absresidstage2 l(1/3).absresidstage2, feestat ic
predict absresid2ndpred3, xbu
*
xtreg absresidstage2 l(1/4).absresidstage2, feestat icpredict absresid2ndpred4, xbu

correlate absresid2ndpred1 absresid2ndpred2 absresid2ndpred3 absresid2ndpred4 
* NOTE: Results of the testing process above is that we will use ARCH(1) going forward because the correlations with higher-order ARCH lag processes are > + 0.99, 
* plus we save from unnecessarily losing observations


************************************************************************************************************************************************************************************************************************************** 


gen lagabsresidstage2=l.absresidstage2
************************************************************************************************************************************************************************************************************************************** 
* EQUATION (2.5): "FINAL" SECOND-STAGE ARCH(1) RESIDUAL ANALYSIS *
************************************************************************************************************************************************************************************************************************************** 

bootstrap _b, reps(10003) bca seed(123) nodots saving(eq3primeboot, replace): xtreg absresidstage2 lagabsresidstage2, feestat ic
predict bstrapeq3p, xbuxtile bootmedcons4=_b[_cons], nquantiles(2)xtile bootmedlagstage2resid=_b[lagabsresidstage2], nquantiles(2)gen cfesdhat2=bootmedcons4+bootmedlagstage2resid*lagabsresidstage2gen cfesd2party=cfesdhat2*prespartygen cfesd2modagency=cfesdhat2*modagencygen cfesd2libagency=cfesdhat2*libagencygen cfesd2partymodag=cfesdhat2*modagency*prespartygen cfesd2partylibag=cfesdhat2*libagency*presparty



************************************************************************************************************************************************************************************************************************************** 
******* EQUATION (2.6): SECOND-STAGE/"FINAL' GENERALIZED PROPOSAL EQUATION ANALYSIS & CORRESPONDING WALD-TYPE HYPOTHESIS TESTS (DERIVED FROM THE EMPIRICAL DISTRIBUTION FUNCTION VIA 10,000 BOOTSTRAP SIMULATIONS) ********************************************************************************************************************************************************************************************************************************************** 



*** "PRELIMINARY" EQUATION (2.6) ESTIMATES (SANS BOOTSTRAP STANDARD ERRORS)-- USED TO OBTAIN MODEL FIT STATISTICS (DO NOT REPORT COEFFICIENTS AND STANDARD ERRORS FROM THIS MODEL RUN)***
 
regress prgrowth ///
	eip presparty libagency modagency partymod partylib cfesdhat2 cfesd2party cfesd2modagency cfesd2libagency ///
	cfesd2partymodag cfesd2partylibag

estat ic 



*** "FINAL" EQUATION (2.6) ESTIMATES --  REPORT COEFFICIENTS AND STANDARD ERRORS (COEFFICIENTS AND SAMPLE SIZE SHOULD BE IDENTICAL TO "PRELIMINARY ESTIMATES" ABOVE ***
	
xtset, clear
*eststo clear
quietly bootstrap _b, reps(10010) bca seed(123) cluster(agencycode) idcluster(new3agencycode) saving(cfesregboot, replace): regress prgrowth ///	eip presparty libagency modagency partymod partylib cfesdhat2 cfesd2party cfesd2modagency cfesd2libagency ///	cfesd2partymodag cfesd2partylibag
estat bootstrap, all
predict execreqgp, xbquietly bootstrap _b h1=(_b[_cons]) ///	h2=(_b[_cons] +_b[modagency]) ///	h3=(_b[_cons] +_b[libagency]) /// 	h4=(_b[libagency] - _b[modagency]) /// 	h5=(_b[_cons] + _b[presparty]) ///	h6=(_b[_cons] + _b[presparty] + _b[modagency] + _b[partymod]) /// 	h7=(_b[_cons] + _b[presparty] + _b[libagency] + _b[partylib]) ///	h8=(_b[libagency] + _b[partylib] - _b[modagency] - _b[partymod]) /// 	h9=(_b[cfesdhat2]) /// 	h10=(_b[cfesdhat2] + _b[cfesd2modagency]) ///	h11=(_b[cfesdhat2] + _b[cfesd2libagency]) ///	h12=(_b[cfesd2modagency] - _b[cfesd2libagency]) /// 	h13=(_b[cfesdhat2] + _b[cfesd2party]) ///	h14=(_b[cfesdhat2] + _b[cfesd2party] + _b[cfesd2modagency] + _b[cfesd2partymodag]) ///	h15=(_b[cfesdhat2] + _b[cfesd2party] + _b[cfesd2libagency] + _b[cfesd2partylibag])  ///	h16=(_b[cfesd2libagency] + _b[cfesd2partylibag] -  _b[cfesd2modagency] - _b[cfesd2partymodag]) h17=(_b[presparty]) ///	h18=(_b[presparty] + _b[partymod]) ///	h19=(_b[presparty] + _b[partylib]) /// 	h20=(_b[cfesd2party]) /// 	h21=(_b[cfesdhat2] + _b[cfesd2partymodag]) /// 	h22=(_b[cfesdhat2] + _b[cfesd2partylibag]), ///	cluster(agencycode) idcluster(new4agencycode) ///
	  reps(10010) bca seed(123): regress prgrowth eip presparty libagency modagency partymod partylib ///       cfesdhat2 cfesd2party cfesd2modagency cfesd2libagency cfesd2partymodag cfesd2partylibagestat bootstrap, all

*capturing the values in local macros to use in calculating the asymmetric loss function
local h1 = e(exp13)local h2 = e(exp15) local h3 = e(exp16)local h4 = e(exp17)local h5 = e(exp18)local h6 = e(exp19) local h7 = e(exp20)local h8 = e(exp21)local h9 = e(exp22)local h10 = e(exp23)local h11 = e(exp24)local h12 = e(exp25)local h13 = e(exp26)local h14 = e(exp27)local h15 = e(exp28)local h16 = e(exp29)local h17 = e(exp30)local h18 = e(exp31)local h19 = e(exp32)local h20 = e(exp33)local h21 = e(exp34)local h22 = e(exp35)***


xtset agencycode fiscalyear, yearly

************************************************************************************************************************************************************************************************************************************** 
***** CORRELATION BETWEEN (2.1), (2.4), & (2.6) -- EXCESS FUNDING BIAS ESTIMATES, FIRST-STAGE, & SECOND-STAGE GENERALIZED PROPOSAL MODEL PREDICTED VALUES  *****

correlate predreq1 predvalstage2 execreqgp
***** CORRELATION BETWEEN (2.3) and (2.5) -- FIRST-STAGE & SECOND-STAGE ARCH(1) MODEL PREDICTED VALUES  *****
correlate cfesdhat1 cfesdhat2
************************************************************************************************************************************************************************************************************************************** 


************************************************************************************************************************************************************************************************************************************** 
************************************************************************************************************************************************************************************************************************************** 
************************************************************************************************************************************************************************************************************************************** 
************************************************************************************************************************************************************************************************************************************** 
************************************************************************************************************************************************************************************************************************************** 
************************************************************************************************************************************************************************************************************************************** 
************************************************************************************************************************************************************************************************************************************** 
************************************************************************************************************************************************************************************************************************************** 
************************************************************************************************************************************************************************************************************************************** 
************************************************************************************************************************************************************************************************************************************** 
************************************************************************************************************************************************************************************************************************************** 
************************************************************************************************************************************************************************************************************************************** 
************************************************************************************************************************************************************************************************************************************** 




* APPROPRIATIONS GROWTH MODELS *


* CREATING IMPLICIT BUDGETARY PREFERENCE (IP) VARIABLE: (GENERALIZED PROPOSAL - EXTERNALLY-INDUCED BUDGETARY PREFERENCE [EIP])

gen ip=execreqgp-eipxtset agencycode fiscalyear, yearly

* ASSESSING CORRELATIONS AMONG RELEVANT : OBSERVED PROPOSAL (OP), EXTERNALLY-INDUCED BUDGETARY PREFERENCES(EIP), GENERALIZED PROPOSAL (GP = EXTERNALLY-INDUCED BUDGETARY PREFERENCES [EIP] + INTERNALLY-INDUCED BUDGETARY PREFERENCES [IP]), 
* and IMPLICIT BUDGETARY PREFERENCES (IP = GP - EIP)
correlate prgrowth eip execreqgp ip appgrowth


**************** FULL SPECIFICATION (ADDITIVE EXECUTIVE BUDGET COVARIATES) ******************************



************************************************************************************************************************************************************************************************************************************** 
* MODEL (3.1a): INCLUSION OF OBSERVED EXECUTIVE BUDGET PROPOSAL GROWTH & "CONTROL" COVARIATES FROM EIP MODEL (INCLUSION OF ADMINISTRATION SPECIFIC TIME-WISE FIXED EFFECT DUMMIES: KENNEDY-JOHNSON BASELINE CAPTURED IN THE INTERCEPT) *
************************************************************************************************************************************************************************************************************************************** 

xtreg appgrowth prgrowth hdempctai sdempctai congelyr cpartmajchangecorrected asctha asciha lagbudgetgap ueratecong lagfedsurpdefpctgdp vietiraqwardefense budget74amends grh any_supp nixonford carter reagan ghwbush clinton gwbush if ip!=., ///
	  fe vce(bootstrap, nodots bca reps(10000) seed(123))

estat ic




************************************************************************************************************************************************************************************************************************************** 
* MODEL (3.1b): INCLUSION OF ONLY GENERALIZED PROPOSAL (EXECREQGP) & "CONTROL" COVARIATES FROM EIP MODEL (INCLUSION OF ADMINISTRATION SPECIFIC TIME-WISE FIXED EFFECT DUMMIES: KENNEDY-JOHNSON BASELINE CAPTURED IN THE INTERCEPT) *
************************************************************************************************************************************************************************************************************************************** 

xtreg appgrowth execreqgp hdempctai sdempctai congelyr cpartmajchangecorrected asctha asciha lagbudgetgap ueratecong lagfedsurpdefpctgdp vietiraqwardefense budget74amends grh any_supp nixonford carter reagan ghwbush clinton gwbush if ip!=., ///
	  fe vce(bootstrap, nodots bca reps(10000) seed(123))

estat ic



************************************************************************************************************************************************************************************************************************************** 
************************************************************************************************************************************************************************************************************************************** 
************************************************************************************************************************************************************************************************************************************** 




************************************************************************************************************************************************************************************************************************************** 
* MODEL (3.1c):  EXTERNALLY-INDUCED PREFERENCE (EIP) PROPOSAL & INTERNALLY-INDUCED BUDGETARY PREFERENCES (IP), INCLUSION OF "CONTROL" COVARIATES IN EIP MODEL: INCLUSION OF ADMINISTRATION SPECIFIC TIME-WISE FIXED EFFECT DUMMIES (KENNEDY-JOHNSON BASELINE CAPTURED IN THE INTERCEPT) *
************************************************************************************************************************************************************************************************************************************** 

xtreg appgrowth eip ip hdempctai sdempctai congelyr cpartmajchangecorrected asctha asciha lagbudgetgap ueratecong lagfedsurpdefpctgdp vietiraqwardefense budget74amends grh any_supp nixonford carter reagan ghwbush clinton gwbush, fe vce(bootstrap, nodots bca reps(10000) seed(123))

estat ic





************************************************************************************************************************************************************************************************************************************** 
************************************************************************************************************************************************************************************************************************************** 
************************************************************************************************************************************************************************************************************************************** 
************************************************************************************************************************************************************************************************************************************** 
************************************************************************************************************************************************************************************************************************************** 
************************************************************************************************************************************************************************************************************************************** 



************************************************************************************************************************************************************************************************************************************** 
* ASYMMETRIC PRESIDENTIAL BUDGETARY INFLUENCE, I: MULTIPLICATIVE MODELS INVOLVING UNIFIED/DIVIDED PARTY GOVERNMENT DISTINCTION [= 1 IF ALL BRANCHES CONTROLLED BY A SINGLE PARTY, = 0 IF OTHERWISE] *
************************************************************************************************************************************************************************************************************************************** 




generate prgrowthupg=prgrowth*unifiedpartygovt

generate execreqgpupg=execreqgp*unifiedpartygovt

generate eipupg=eip*unifiedpartygovt

generate ipupg=ip*unifiedpartygovt



************************************************************************************************************************************************************************************************************************************** 
* MODEL (3.2a): INCLUSION OF OBSERVED EXECUTIVE BUDGET PROPOSAL GROWTH & "CONTROL" COVARIATES FROM EIP MODEL (INCLUSION OF ADMINISTRATION SPECIFIC TIME-WISE FIXED EFFECT DUMMIES: KENNEDY-JOHNSON BASELINE CAPTURED IN THE INTERCEPT) *
************************************************************************************************************************************************************************************************************************************** 

xtreg appgrowth prgrowth prgrowthupg unifiedpartygovt hdempctai sdempctai congelyr cpartmajchangecorrected asctha asciha lagbudgetgap ueratecong lagfedsurpdefpctgdp vietiraqwardefense budget74amends grh any_supp nixonford carter reagan ghwbush clinton gwbush if ip!=., ///
	  fe vce(bootstrap, nodots bca reps(10000) seed(123))

estat ic

*
test prgrowth + prgrowthupg = 0



************************************************************************************************************************************************************************************************************************************** 
* MODEL (3.2b): INCLUSION OF ONLY GENERALIZED PROPOSAL (EXECREQGP)  & "CONTROL" COVARIATES FROM EIP MODEL (INCLUSION OF ADMINISTRATION SPECIFIC TIME-WISE FIXED EFFECT DUMMIES: KENNEDY-JOHNSON BASELINE CAPTURED IN THE INTERCEPT) *
************************************************************************************************************************************************************************************************************************************** 

xtreg appgrowth execreqgp execreqgpupg unifiedpartygovt hdempctai sdempctai congelyr cpartmajchangecorrected asctha asciha lagbudgetgap ueratecong lagfedsurpdefpctgdp vietiraqwardefense budget74amends grh any_supp nixonford carter reagan ghwbush clinton gwbush if ip!=., ///
	  fe vce(bootstrap, nodots bca reps(10000) seed(123))

estat ic

*
test execreqgp + execreqgpupg  = 0





************************************************************************************************************************************************************************************************************************************** 
* MODEL (3.2c): EXTERNALLY-INDUCED PREFERENCE (EIP) PROPOSAL & INTERNALLY-INDUCED BUDGETARY PREFERENCES (IP), INCLUSION OF "CONTROL" COVARIATES IN EIP MODEL: INCLUSION OF ADMINISTRATION SPECIFIC TIME-WISE FIXED EFFECT DUMMIES (KENNEDY-JOHNSON BASELINE CAPTURED IN THE INTERCEPT) *
************************************************************************************************************************************************************************************************************************************** 

xtreg appgrowth eip eipupg ip ipupg unifiedpartygovt hdempctai sdempctai congelyr cpartmajchangecorrected asctha asciha lagbudgetgap ueratecong lagfedsurpdefpctgdp vietiraqwardefense budget74amends grh any_supp nixonford carter reagan ghwbush clinton gwbush, fe vce(bootstrap, nodots bca reps(10000) seed(123))

estat ic

*
test ip + ipupg = 0

test eip + eipupg = 0 

*

test ip = eip

test ip + ipupg = eip + eipupg


************************************************************************************************************************************************************************************************************************************** 
************************************************************************************************************************************************************************************************************************************** 
************************************************************************************************************************************************************************************************************************************** 
************************************************************************************************************************************************************************************************************************************** 
************************************************************************************************************************************************************************************************************************************** 
************************************************************************************************************************************************************************************************************************************** 









************************************************************************************************************************************************************************************************************************************** 
* ASYMMETRIC PRESIDENTIAL BUDGETARY INDFLUENCE, II: MULTIPLICATIVE MODELS INVOLVING PRESIDENTS SEEKS LESS OR EQUAL FUNDING VIS-A-VIS CONGRESS [= 1 if REQUEST <= APPROPRIATIONS; = 0 if REQUEST > APPROPRIATIONS] *
************************************************************************************************************************************************************************************************************************************** 


generate prgrowthasym=prgrowth*asymmetric

generate execreqgpasym=execreqgp*asymmetric

generate eipasym=eip*asymmetric

generate ipasym=ip*asymmetric



************************************************************************************************************************************************************************************************************************************** 
* MODEL (3.3a): INCLUSION OF OBSERVED EXECUTIVE BUDGET PROPOSAL GROWTH & "CONTROL" COVARIATES FROM EIP MODEL (INCLUSION OF ADMINISTRATION SPECIFIC TIME-WISE FIXED EFFECT DUMMIES: KENNEDY-JOHNSON BASELINE CAPTURED IN THE INTERCEPT) *
************************************************************************************************************************************************************************************************************************************** 

xtreg appgrowth prgrowth prgrowthasym asymmetric hdempctai sdempctai congelyr cpartmajchangecorrected asctha asciha lagbudgetgap ueratecong lagfedsurpdefpctgdp vietiraqwardefense budget74amends grh any_supp nixonford carter reagan ghwbush clinton gwbush if ip!=., ///
	  fe vce(bootstrap, nodots bca reps(10000) seed(123))

estat ic

*
test prgrowth + prgrowthasym = 0



************************************************************************************************************************************************************************************************************************************** 
* MODEL (3.3b): INCLUSION OF ONLY GENERALIZED PROPOSAL (EXECREQGP) & "CONTROL" COVARIATES FROM EIP MODEL (INCLUSION OF ADMINISTRATION SPECIFIC TIME-WISE FIXED EFFECT DUMMIES: KENNEDY-JOHNSON BASELINE CAPTURED IN THE INTERCEPT) *
************************************************************************************************************************************************************************************************************************************** 

xtreg appgrowth  execreqgp execreqgpasym asymmetric hdempctai sdempctai congelyr cpartmajchangecorrected asctha asciha lagbudgetgap ueratecong lagfedsurpdefpctgdp vietiraqwardefense budget74amends grh any_supp nixonford carter reagan ghwbush clinton gwbush if ip!=., ///
	  fe vce(bootstrap, nodots bca reps(10000) seed(123))

estat ic

*
test execreqgp + execreqgpasym = 0






************************************************************************************************************************************************************************************************************************************** 
* MODEL (3.3c): EXTERNALLY-INDUCED PREFERENCE (EIP) PROPOSAL & INTERNALLY-INDUCED BUDGETARY PREFERENCES (IP), INCLUSION OF "CONTROL" COVARIATES IN SCP MODEL: INCLUSION OF ADMINISTRATION SPECIFIC TIME-WISE FIXED EFFECT DUMMIES (KENNEDY-JOHNSON BASELINE CAPTURED IN THE INTERCEPT) *
************************************************************************************************************************************************************************************************************************************** 

xtreg appgrowth eip eipasym ip ipasym asymmetric hdempctai sdempctai congelyr cpartmajchangecorrected asctha asciha lagbudgetgap ueratecong lagfedsurpdefpctgdp vietiraqwardefense budget74amends grh any_supp nixonford carter reagan ghwbush clinton gwbush, fe vce(bootstrap, nodots bca reps(10000) seed(123))

estat ic

*
test ip + ipasym = 0

test eip + eipasym = 0

*

test ip = eip

test ip + ipasym = eip + eipasym



************************************************************************************************************************************************************************************************************************************** 
************************************************************************************************************************************************************************************************************************************** 
************************************************************************************************************************************************************************************************************************************** 
************************************************************************************************************************************************************************************************************************************** 
************************************************************************************************************************************************************************************************************************************** 
************************************************************************************************************************************************************************************************************************************** 
************************************************************************************************************************************************************************************************************************************** 
************************************************************************************************************************************************************************************************************************************** 
************************************************************************************************************************************************************************************************************************************** 
************************************************************************************************************************************************************************************************************************************** 
************************************************************************************************************************************************************************************************************************************** 
************************************************************************************************************************************************************************************************************************************** 
************************************************************************************************************************************************************************************************************************************** 
************************************************************************************************************************************************************************************************************************************** 
************************************************************************************************************************************************************************************************************************************** 
************************************************************************************************************************************************************************************************************************************** 
************************************************************************************************************************************************************************************************************************************** 
************************************************************************************************************************************************************************************************************************************** 



save "D:\Asymmetric Loss Project\New Version (2012)\Data Folder\policy priorities.restricted alternative EIP models.01-09-13.allvars.dta", replacelog close