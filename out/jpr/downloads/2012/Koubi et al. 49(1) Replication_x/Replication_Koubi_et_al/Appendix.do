use "ClimateAndCivilConflict.dta", clear

xtset cowcode year

******************Analysis************************

*********************

*	Table A1+ A2	*

*********************

****************************
**********	SPI			*
******************************


#delimit ;
	xtfevd	PENN_grgdpch SPI_year lag_xpolity pop_growth lpop lag_lGDP_pc   
			Oil ethfrac lmtnest GDP_initial NAF SSA eastasia westasia MEA LAM NAM trend if year>=1980, 
			invariant(Oil ethfrac lmtnest GDP_initial NAF SSA eastasia westasia MEA LAM NAM) ar1  corr;
#delimit cr


capture drop gr
capture drop lag_gr
predict gr, xb
gen lag_gr=l.gr


*interaction
capture drop interact*
gen interact1=xpolity*PENN_grgdpch

gen interact2=xpolity*SPI_year


#delimit ;
	xtfevd	interact1 SPI_year interact2  lag_xpolity pop_growth lpop lag_lGDP_pc   
			Oil ethfrac lmtnest GDP_initial NAF SSA eastasia westasia MEA LAM NAM trend if year>=1980, 
			invariant(Oil ethfrac lmtnest GDP_initial NAF SSA eastasia westasia MEA LAM NAM) ar1 corr;
#delimit cr

capture drop inter_hat
capture drop lag_inter_hat
predict inter_hat, xb
gen lag_inter_hat=l.inter_hat

*conflict, world
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


****************************Africa only

#delimit ;
	xtfevd	PENN_grgdpch SPI_year lag_xpolity pop_growth lpop lag_lGDP_pc   
			Oil ethfrac lmtnest GDP_initial trend
			if year>=1980 & NAF==1 | SSA==1, 
			invariant(Oil ethfrac lmtnest GDP_initial) ar1 corr;
#delimit cr


capture drop gr
capture drop lag_gr
predict gr, xb
gen lag_gr=l.gr


*interaction
capture drop interact*
gen interact1=xpolity*PENN_grgdpch

gen interact2=xpolity*SPI_year


#delimit ;
	xtfevd	interact1 SPI_year interact2  lag_xpolity pop_growth lpop lag_lGDP_pc   
			Oil ethfrac lmtnest GDP_initial trend if year>=1980 & NAF==1 | SSA==1, 
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


*****************
*	CRU			*
*	ma			*
*****************

*growth, world
#delimit ;
	xtfevd	PENN_grgdpch temp_ma_30_CRU  preci_ma_30_CRU lag_xpolity pop_growth lpop lag_lGDP_pc   
			Oil ethfrac lmtnest GDP_initial NAF SSA eastasia westasia MEA LAM NAM trend if year>=1980, 
			invariant(Oil ethfrac lmtnest GDP_initial NAF SSA eastasia westasia MEA LAM NAM) ar1  corr;
#delimit cr

capture drop gr
capture drop lag_gr
predict gr, xb
gen lag_gr=l.gr


*interaction
capture drop interact*
gen interact1=xpolity*PENN_grgdpch
gen interact2=xpolity*temp_ma_30_CRU
gen interact3=xpolity*preci_ma_30_CRU

#delimit ;
	xtfevd	interact1 temp_ma_30_CRU preci_ma_30_CRU interact2 interact3 lag_xpolity pop_growth lpop lag_lGDP_pc   
			Oil ethfrac lmtnest GDP_initial NAF SSA eastasia westasia MEA LAM NAM trend if year>=1980, 
			invariant(Oil ethfrac lmtnest GDP_initial NAF SSA eastasia westasia MEA LAM NAM) ar1 corr;
#delimit cr

capture drop inter_hat
capture drop lag_inter_hat
predict inter_hat, xb
gen lag_inter_hat=l.inter_hat


*conflict, world
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


************************Africa only

#delimit ;
	xtfevd	PENN_grgdpch temp_ma_30_CRU  preci_ma_30_CRU lag_xpolity pop_growth lpop lag_lGDP_pc   
			Oil ethfrac lmtnest GDP_initial trend
			if year>=1980 & NAF==1 | SSA==1, 
			invariant(Oil ethfrac lmtnest GDP_initial) ar1 corr;
#delimit cr

capture drop gr
capture drop lag_gr
predict gr, xb
gen lag_gr=l.gr


*interaction
capture drop interact*
gen interact1=xpolity*PENN_grgdpch
gen interact2=xpolity*temp_ma_30_CRU
gen interact3=xpolity*preci_ma_30_CRU

#delimit ;
	xtfevd	interact1 temp_ma_30_CRU preci_ma_30_CRU interact2 interact3 lag_xpolity pop_growth lpop lag_lGDP_pc   
			Oil ethfrac lmtnest GDP_initial trend if year>=1980 & NAF==1 | SSA==1, 
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
*	Figure A.1										*
*****************************************************

do "Interaction_SPI_XPolity_FEVD_1980.do"



*********************

*	Table A3+ A4	*

*********************


******************************
* Polity         *
*	GPCC		*
*	ma			*
*******************************

#delimit ;
	xtfevd	PENN_grgdpch temp_ma_30_GPCC preci_ma_30_GPCC  lag_polity pop_growth lpop lag_lGDP_pc   
			Oil ethfrac lmtnest GDP_initial NAF SSA eastasia westasia MEA LAM NAM trend if year>=1980, 
			invariant(Oil ethfrac lmtnest GDP_initial NAF SSA eastasia westasia MEA LAM NAM) ar1 corr;
#delimit cr

capture drop gr
capture drop lag_gr
predict gr, xb
gen lag_gr=l.gr

*interaction
capture drop interact*
gen interact1=POL_polity2*PENN_grgdpch
gen interact2=POL_polity2*temp_ma_30_GPCC
gen interact3=POL_polity2*preci_ma_30_GPCC

#delimit ;
	xtfevd	interact1 temp_ma_30_GPCC preci_ma_30_GPCC interact2 interact3 lag_polity pop_growth lpop lag_lGDP_pc   
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
	logit	onset_new lag_gr lag_polity lag_inter_hat pop_growth lpop lag_lGDP_pc Oil ethfrac lmtnest 
			GDP_initial NAF SSA eastasia westasia MEA LAM NAM
			peaceyrs peaceyrs2 peaceyrs3 if year>=1980, vce(boots);
#delimit cr

**************Africa only

#delimit ;
	xtfevd	PENN_grgdpch temp_ma_30_GPCC preci_ma_30_GPCC  lag_polity pop_growth lpop lag_lGDP_pc   
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
gen interact1=POL_polity2*PENN_grgdpch

gen interact2=POL_polity2*temp_ma_30_GPCC
gen interact3=POL_polity2*preci_ma_30_GPCC

#delimit ;
	xtfevd	interact1 temp_ma_30_GPCC preci_ma_30_GPCC interact2 interact3 lag_polity pop_growth lpop lag_lGDP_pc   
			Oil ethfrac lmtnest GDP_initial trend if year>=1980 & NAF==1 | SSA==1, 
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
	logit	onset_new lag_gr lag_polity lag_inter_hat pop_growth lpop lag_lGDP_pc Oil ethfrac lmtnest 
			GDP_initial 
			peaceyrs peaceyrs2 peaceyrs3 if year>=1980 & NAF==1 | SSA==1, vce(boots);
#delimit cr


*****************************************************
*	Figure A.2										*
*****************************************************

do "Interaction_MA_FEVD_1980_Polity.do"

*****************************************************
*	Figure A.3										*
*****************************************************

do "Interaction_MA_FEVD_1980_Polity_Africa.do"



*********************

*	Table A5+ A6	*

*********************

*****************
*	GPCC		*
*	ma			*
*	bb			*
*****************

#delimit ;
	xtfevd	PENN_grgdpch temp_ma_30_GPCC  preci_ma_30_GPCC lag_xpolity pop_growth lpop lag_lGDP_pc   
			Oil ethfrac lmtnest GDP_initial trend if bb==1 & year>=1980, 
			invariant(Oil ethfrac lmtnest GDP_initial) ar1 corr;
#delimit cr

sort cowcode year
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
			Oil ethfrac lmtnest GDP_initial  trend if bb==1 & year>=1980,
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
			peaceyrs peaceyrs2 peaceyrs3 if bb==1 & year>=1980, vce(boots);
#delimit cr

*****************
*  1000 battle related deaths        *
*	GPCC										*
*	ma											*
*****************

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
	logit	onset_1000 lag_gr lag_xpolity lag_inter_hat pop_growth lpop lag_lGDP_pc Oil ethfrac lmtnest 
			GDP_initial NAF SSA eastasia westasia MEA LAM NAM
			peaceyrs peaceyrs2 peaceyrs3 if year>=1980, vce(boots);
#delimit cr


***************Africa only

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
			Oil ethfrac lmtnest GDP_initial trend if year>=1980 & NAF==1 | SSA==1, 
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
	logit	onset_1000 lag_gr lag_xpolity lag_inter_hat pop_growth lpop lag_lGDP_pc Oil ethfrac lmtnest 
			GDP_initial 
			peaceyrs peaceyrs2 peaceyrs3 if year>=1980 & NAF==1 | SSA==1, vce(boots);
#delimit cr
















