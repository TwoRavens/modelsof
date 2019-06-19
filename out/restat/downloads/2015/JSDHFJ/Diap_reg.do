*****************************************************************************
*** Diap_reg.do
***
*****************************************************************************

use Databases\2001-2005PackLev_NonLinearRegressions, clear
keep ProdChainID
duplicates drop ProdChainID, force
sort ProdChainID
gen ProdChainID_short=_n

merge 1:m ProdChainID using Databases\2001-2005PackLev_NonLinearRegressions
drop _merge

compress
drop ppdiaper*l ppdiaper*f

gen I_S=InvSizeRank==1
gen I_L=InvSizeRank==2

gen L_QS=I_L*QSPeriod
gen S_QS=I_S*QSPeriod
gen D=I_S-I_L
gen D_QS= D*QSPeriod

sort uniquepackid week
xtset uniquepackid week

replace L_QS=0 if L_QS==1 & L.L_QS==1
replace S_QS=0 if S_QS==1 & L.S_QS==1
replace L_QS=0 if MultPromotions==1
replace S_QS=0 if MultPromotions==1



reg totsales I_S S_QS I_L L_QS if ProdChainID_short==1, robust noconstant
display 1+_b[L_QS]/_b[I_L]
nlcom (alpha:1+_b[L_QS]/_b[I_L]), post
display _b[alpha]
display _se[alpha]

gen est_alpha=_b[alpha] if ProdChainID==1
gen est_SE_alpha=_se[alpha] if ProdChainID==1

compress

drop WeeksAvail MinConcWeeks ConcWeeks HMed* PercDiscount units Ltotsales pperdiaper iri_short 


**************************************************************************************************************
save Databases\2001-2005PackLev_NonLinearRegressions-Compressed, replace
**************************************************************************************************************



****************************************************************************************************
************************		   			  Get the Subsamples              **********************
****************************************************************************************************


******************************   3 QS   ************************************************************
use Databases\2001-2005PackLev_NonLinearRegressions-Compressed, clear
****************************************************************************************************
keep ProdChainID* week uniquepackid totsales I_* est_* QuantSurcharge QSPeriod MultPromotions
capture drop L_QS
capture drop S_QS
gen L_QS=I_L*QSPeriod
gen S_QS=I_S*QSPeriod
sort uniquepackid week
xtset uniquepackid week
replace L_QS=0 if L_QS==1 & L.L_QS==1
replace S_QS=0 if S_QS==1 & L.S_QS==1
replace L_QS=0 if MultPromotions==1
replace S_QS=0 if MultPromotions==1
gen NonMissing=totsales!=.
egen NumObsProdChain=total(NonMissing), by (ProdChainID_short)
egen NumQS=total(S_QS),  by (ProdChainID_short)
keep if NumObsProdChain>=50

histogram NumQS, w(1)
histogram NumQS if NumQS>3, w(1)

keep if NumQS>=3
drop ProdChainID_short NonMissing NumObsProdChain
*****************************************************************************************************************************
save Databases\2001-2005PackLev_NonLinear-Regressions-Compressed-2-3, replace
*****************************************************************************************************************************


**************************************************************************************************************
************************		   			  REGRESSIONS         			      ****************************
**************************************************************************************************************

set matsize 11000

*************************************************************************

******************************   3  QS   *******************************
use Databases\2001-2005PackLev_NonLinear-Regressions-Compressed-2-3, clear
*************************************************************************
keep ProdChainID
duplicates drop ProdChainID, force
sort ProdChainID
gen ProdChainID_short=_n

merge 1:m ProdChainID using Databases\2001-2005PackLev_NonLinear-Regressions-Compressed-2-3
drop _merge

codebook ProdChainID_short



**************************************************
**********    Linear Regressions    **************
**********    	Per Product		    **************
**********        247 prods         **************
**************************************************

quietly forvalues v=1/247 {
		 reg totsales I_S S_QS I_L L_QS if ProdChainID_short==`v', robust noconstant
		 nlcom (alpha:1+_b[L_QS]/_b[I_L]), post
		 replace est_alpha=_b[alpha] if ProdChainID_short==`v'
		 replace est_SE_alpha=_se[alpha] if ProdChainID_short==`v'

}

replace est_SE_alpha=. if est_SE_alpha==0
replace est_alpha=. if est_SE_alpha==0
replace est_alpha=. if est_SE_alpha==.

label var est_alpha "Estimated Alpha"
label var est_SE_alpha "SE of Estiamted Alpha"

egen ProdChainID_Seq=seq(), by (ProdChainID)

log using Log_Files_and_Graphs\Diapers_Alpha_3, replace

sum est_alpha if ProdChainID_Seq==1, d
histogram est_alpha if ProdChainID_Seq==1, bin(50) kdensity
graph save Log_Files_and_Graphs\est_alpha_3, replace


***** Hypothesis Testing ****
**** alpha =0

gen alphaHyp_0=est_alpha/est_SE_alpha
label var alphaHyp_0 "T-statistic for Hyp:alpha=0"
gen alpha_Abs_Hyp_0=abs(alphaHyp_0)
label var alpha_Abs_Hyp_0 "Absolute value of alphaHyp_0"
gen alpha_StatSign=(alpha_Abs_Hyp_0>2 & alpha_Abs_Hyp_0!=.)
label var alpha_StatSign "Reject Hyp:alpha=0 Vs alpha!=0"


**** alpha =1 

gen alphaHyp_1=(est_alpha-1)/est_SE_alpha
label var alphaHyp_1 "T-statistic for Hyp:alpha=1"
gen alpha_less_1=(alphaHyp_1<-1.645 & alphaHyp_1!=.)
label var alpha_less_1 "Reject Hyp:alpha>=1 Vs alpha<1"
gen alpha_higher_1=(alphaHyp_1>1.645 & alphaHyp_1!=.)
label var alpha_higher_1 "Reject Hyp:alpha<=1 Vs alpha>1"
gen alpha_Abs_Hyp_1=abs(alphaHyp_1)
label var alpha_Abs_Hyp_0 "Absolute value of alphaHyp_0"
gen alpha_notequal_1=(alpha_Abs_Hyp_1>2& alphaHyp_1!=.)
label var alpha_notequal_1 "Reject Hyp:alpha=1 Vs alpha!=1"
gen alpha_notequal10Per_1=(alpha_Abs_Hyp_1>1.645 & alphaHyp_1!=.)
label var alpha_notequal_1 "Reject at 10% Hyp:alpha=1 Vs alpha!=1"


tab1 alpha_StatSign alpha_less_1 alpha_higher_1 alpha_notequal_1 alpha_notequal10Per_1 if est_alpha !=. & ProdChainID_Seq==1

***************************************************************************

save Databases\2001-2005PackLev_NonLinear-Regressions-estimated_alpha-3, replace

log close

***************************************************************************
***************************************************************************

