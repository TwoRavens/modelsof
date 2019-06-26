*please install: 
	*xtfevd.ado, available at http://www.polsci.org/pluemper/ssc.html 
	*btscs.ado available at http://www.prio.no/CSCW/Datasets/Stata-Tools/

use "ClimateAndCivilConflict.dta", clear

xtset cowcode year

******************Analysis************************

*****************
*	Table 1	+ 2	*
*	GPCC		*
*	ma			*
*****************


*growth, world
#delimit ;
	xtfevd	PENN_grgdpch temp_ma_30_GPCC preci_ma_30_GPCC  lag_xpolity pop_growth lpop lag_lGDP_pc   
			Oil ethfrac lmtnest GDP_initial NAF SSA eastasia westasia MEA LAM NAM trend if year>=1980, 
			invariant(Oil ethfrac lmtnest GDP_initial NAF SSA eastasia westasia MEA LAM NAM) ar1 corr;
#delimit cr


capture drop gr
capture drop lag_gr
predict gr, xb
gen lag_gr=l.gr


*interaction
capture drop interact*
gen interact1=xpolity*PENN_grgdpch
gen interact2=xpolity*temp_ma_30_GPCC
gen interact3=xpolity*preci_ma_30_GPCC

#delimit ;
	xtfevd	interact1 temp_ma_30_GPCC preci_ma_30_GPCC interact2 interact3 lag_xpolity pop_growth lpop lag_lGDP_pc   
			Oil ethfrac lmtnest GDP_initial NAF SSA eastasia westasia MEA LAM NAM trend if year>=1980, 
			invariant(Oil ethfrac lmtnest GDP_initial NAF SSA eastasia westasia MEA LAM NAM) ar1 corr;
#delimit cr

capture drop inter_hat
capture drop lag_inter_hat
predict inter_hat, xb
gen lag_inter_hat=l.inter_hat


*conflict
capture drop peaceyrs 
capture drop _tunti* _prefail _frstfl
btscs onset_new year cowcode, g(peaceyrs) f
label variable peaceyrs "peace years"
capture drop peaceyrs2 
gen peaceyrs2=peaceyrs^2 
label variable peaceyrs2 "peace years^2"
capture drop peaceyrs3
gen peaceyrs3=peaceyrs^3 
label variable peaceyrs3 "peace years^3"


#delimit ;
	logit	onset_new lag_gr lag_xpolity lag_inter_hat pop_growth lpop lag_lGDP_pc Oil ethfrac lmtnest 
			GDP_initial NAF SSA eastasia westasia MEA LAM NAM
			peaceyrs peaceyrs2 peaceyrs3 if year>=1980, vce(boots);
#delimit cr


*****************************Africa only******************************

#delimit ;
	xtfevd	PENN_grgdpch temp_ma_30_GPCC preci_ma_30_GPCC  lag_xpolity pop_growth lpop lag_lGDP_pc   
			Oil ethfrac lmtnest GDP_initial trend
			if year>=1980 & NAF==1 | SSA==1, 
			invariant(Oil ethfrac lmtnest GDP_initial) ar1  corr;
#delimit cr

capture drop gr
capture drop lag_gr
predict gr, xb
gen lag_gr=l.gr


*interaction
capture drop interact*
gen interact1=xpolity*PENN_grgdpch
gen interact2=xpolity*temp_ma_30_GPCC
gen interact3=xpolity*preci_ma_30_GPCC

#delimit ;
	xtfevd	interact1 temp_ma_30_GPCC preci_ma_30_GPCC interact2 interact3 lag_xpolity pop_growth lpop lag_lGDP_pc   
			Oil ethfrac lmtnest GDP_initial  trend if year>=1980 & NAF==1 | SSA==1, 
			invariant(Oil ethfrac lmtnest GDP_initial) ar1 corr;
#delimit cr


capture drop inter_hat
capture drop lag_inter_hat
predict inter_hat, xb
gen lag_inter_hat=l.inter_hat


*conflict
capture drop peaceyrs 
capture drop _tunti* _prefail _frstfl
btscs onset_new year cowcode, g(peaceyrs) f
label variable peaceyrs "peace years"
capture drop peaceyrs2 
gen peaceyrs2=peaceyrs^2 
label variable peaceyrs2 "peace years^2"
capture drop peaceyrs3
gen peaceyrs3=peaceyrs^3 
label variable peaceyrs3 "peace years^3"


#delimit ;
	logit	onset_new lag_gr lag_xpolity lag_inter_hat pop_growth lpop lag_lGDP_pc Oil ethfrac lmtnest 
			GDP_initial 
			peaceyrs peaceyrs2 peaceyrs3 if year>=1980 & NAF==1 | SSA==1, vce(boots);
#delimit cr



*****************************************************
*	Table 3 + 4										*
*	GPCC											*
*	ma												*
*	same model but with fixed effects estimator 	*
*****************************************************

#delimit ;
	xtreg	PENN_grgdpch temp_ma_30_GPCC preci_ma_30_GPCC  lag_xpolity pop_growth lpop lag_lGDP_pc   
			trend if year>=1980,fe;
#delimit cr

capture drop gr
capture drop lag_gr
predict gr, xb
gen lag_gr=l.gr


*interaction
capture drop interact*
gen interact1=xpolity*PENN_grgdpch
gen interact2=xpolity*temp_ma_30_GPCC
gen interact3=xpolity*preci_ma_30_GPCC

#delimit ;
	xtreg	interact1 temp_ma_30_GPCC preci_ma_30_GPCC interact2 interact3 lag_xpolity pop_growth lpop lag_lGDP_pc   
			trend if year>=1980, fe;
#delimit cr

capture drop inter_hat
capture drop lag_inter_hat
predict inter_hat, xb
gen lag_inter_hat=l.inter_hat

*conflict
capture drop peaceyrs 
capture drop _tunti* _prefail _frstfl
btscs onset_new year cowcode, g(peaceyrs) f
label variable peaceyrs "peace years"
capture drop peaceyrs2 
gen peaceyrs2=peaceyrs^2 
label variable peaceyrs2 "peace years^2"
capture drop peaceyrs3
gen peaceyrs3=peaceyrs^3 
label variable peaceyrs3 "peace years^3"


#delimit ;
	logit	onset_new lag_gr lag_xpolity lag_inter_hat pop_growth lpop lag_lGDP_pc Oil ethfrac lmtnest 
			GDP_initial NAF SSA eastasia westasia MEA LAM NAM
			peaceyrs peaceyrs2 peaceyrs3 if year>=1980, vce(boots);
#delimit cr



**********************
*Africa only

#delimit ;
	xtreg	PENN_grgdpch temp_ma_30_GPCC preci_ma_30_GPCC  lag_xpolity pop_growth lpop lag_lGDP_pc   
			 trend if year>=1980 & NAF==1 | SSA==1,fe;
#delimit cr

capture drop gr
capture drop lag_gr
predict gr, xb
gen lag_gr=l.gr


*interaction
capture drop interact*
gen interact1=xpolity*PENN_grgdpch
gen interact2=xpolity*temp_ma_30_GPCC
gen interact3=xpolity*preci_ma_30_GPCC

#delimit ;
	xtreg	interact1 temp_ma_30_GPCC preci_ma_30_GPCC interact2 interact3 lag_xpolity pop_growth lpop lag_lGDP_pc   
			trend if year>=1980 & NAF==1 | SSA==1,fe;
#delimit cr

capture drop inter_hat
capture drop lag_inter_hat
predict inter_hat, xb
gen lag_inter_hat=l.inter_hat

*conflict
capture drop peaceyrs 
capture drop _tunti* _prefail _frstfl
btscs onset_new year cowcode, g(peaceyrs) f
label variable peaceyrs "peace years"
capture drop peaceyrs2 
gen peaceyrs2=peaceyrs^2 
label variable peaceyrs2 "peace years^2"
capture drop peaceyrs3
gen peaceyrs3=peaceyrs^3 
label variable peaceyrs3 "peace years^3"

#delimit ;
	logit	onset_new lag_gr lag_xpolity lag_inter_hat pop_growth lpop lag_lGDP_pc Oil ethfrac lmtnest 
			GDP_initial 
			peaceyrs peaceyrs2 peaceyrs3 if year>=1980 & NAF==1 | SSA==1, vce(boots);
#delimit cr


*****************************************************
*	Figure 1										*
*****************************************************

do "Interaction_XPolity_MA_FEVD_1980.do"


*****************************************************
*	Figure 2										*
*****************************************************

do "Interaction_MA_XPolity_FEVD_1980_Africa.do"


*****************************************************
*	Figure 3										*
*****************************************************

do "Interaction_MA_XPolity_FE_1980.do"


*****************************************************
*	Figure 4										*
*****************************************************

do "Interaction_MA_XPolity_FE_1980_Africa.do"


