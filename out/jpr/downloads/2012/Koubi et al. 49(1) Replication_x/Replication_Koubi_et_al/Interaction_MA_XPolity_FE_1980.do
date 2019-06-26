set more off
clear
clear matrix

use "ClimateAndCivilConflict.dta"

xtset cowcode year

******************Analysis************************

#delimit ;
	xtreg	PENN_grgdpch temp_ma_30_GPCC preci_ma_30_GPCC  lag_xpolity pop_growth lpop lag_lGDP_pc   
			 trend if year>=1980,fe;
#delimit cr


capture drop gr
capture drop lag_gr
predict gr, xb
gen lag_gr=l.gr


*interaction
capture drop interact
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

quietly summarize xpolity, detail
local min=r(min)
local max=r(max)
local mean=r(mean)
local cen25=r(p25)
local cen50=r(p50)
local cen75=r(p75)
local numparams=14  /*Set number of coefficients to be graphed HERE */
local inc=(`max'-`min')/(`numparams'-1)
local iter=0
matrix foo2 = 0,0,0,0
local order=1  /* Replace this number with a number that will tell Stata which IV's coefs. you */
               /* want to graph -- first, second, third, etc.  In this example, we want to graph */
               /* x1's coefficients as a function of x2, and x1 is the first independent variable */
               /* listed in the regress command, so we would enter a 1. */

/* 5. Calculate coefficients for x1 across range of x2, store in matrix foo2 */
while `iter'<`numparams' { 
   gen x2a=xpolity-`min'-(`inc'*`iter')  /* Alter these four lines to fit your model. */
   summarize x2a
   gen x1x2a_1=PENN_grgdpch*x2a
   

#delimit ;
	xtreg	x1x2a_1 temp_ma_30_GPCC preci_ma_30_GPCC interact2 interact3 lag_xpolity pop_growth lpop lag_lGDP_pc   
			trend if year>=1980, fe;
#delimit cr


predict x1x2a_2, xb
gen x1x2a=l.x1x2a_2


#delimit cr
   *regress y x1 x2a x1x2a
 #delimit ;
	logit	onset_new lag_gr x2a x1x2a pop_growth lpop lag_lGDP_pc Oil ethfrac lmtnest 
			GDP_initial NAF SSA eastasia westasia MEA LAM NAM
			peaceyrs peaceyrs2 peaceyrs3 if year>=1980, vce(boots);
#delimit cr
   matrix betas=e(b)                /* Stop alterations. */
   scalar x1coef=betas[1,`order']
   matrix ses=e(V)
   scalar x1se=sqrt(ses[`order',`order'])
   local obs=e(N)                     /* Calculate 95% confidence intervals.  Assumes t-tests for signif.; */
   scalar ci95=invttail(`obs', 0.025) /* if using procedure that produces z-tests, use invnorm(0.975) */
   local xval = `min'+(`inc'*`iter')
   matrix foo = x1coef-ci95*x1se, x1coef, x1coef+ci95*x1se, `xval'
   matrix foo2 = foo2 \ foo
   drop x2a x1x2a x1x2a_1 x1x2a_2
   local iter=`iter'+1
   }

/* 6. Convert matrix into data */
matrix points=foo2[2..(`numparams'+1),1..4]
svmat points



/* 7a. Produce graph if x2 is ordinal and fractional values make no sense. */
/* For example, if x2 is number of children and a value of 2.5 is silly. */
/* Thanks to Eric Lawrence for tipping me off to the use of rcap here. */
/* Change titles, labels, etc., to fit your particular needs */
twoway (rcap points1 points3 points4, mcolor(navy maroon navy)/*
*/ clcolor(navy maroon navy) msymbol(diamond circle diamond))/*
*/ (histogram lag_xpolity, yaxis(2) blcolor(gray) bfcolor(none) bin(`numparams')), ytitle(Histogram of/*
*/ xpolity, axis(2))/*
*/ ytitle(Regression coefficients on pr. growth and 95% CIs)/*
*/ ylabel(, labsize(medium)) yline(0, lwidth(medthick)) xtitle(xpolity)/*
*/ xlabel(-6 "-6" 0 "0" 7 "7")/*
*/ title(Coefficients on predicted growth) subtitle(Overlaid with/*
*/ histogram of xpolity) legend(off)
graph export "Interaction_XPolity_Separate_MA_FE_1980.pdf", replace
