*********************************************************************************
*********************************************************************************
*********************************************************************************
*********************************************************************************
*Transparency, Class Bias, and Redistribution: Evidence from the American States*
***********************Severson SPPQ Submission .do File*************************
**************************Last edited: 3-6-2018*********************************
*********************************************************************************
*********************************************************************************
*********************************************************************************
*********************************************************************************


*************************************************************
*************************************************************
*************SECTION 1: DEFINE WORKSPACE********************
*************************************************************
*************************************************************

clear
set more off
use "transparency.dta", clear

*************************************************************
*************************************************************
*************SECTION 2: VARIABLE CLEANING********************
*************************************************************
*************************************************************

**************************
*Define Global Parameters*
**************************

global id state_id
global t year
gen id = state_id

*************************
**Independent Variables**
*************************

*Adjust Relevant Economic Variables for Inflation, Scale to U.S. Dollars (2000) 

*State Welfare Expenditures

**Install the cpigen package to run**

ssc install cpigen 
cpigen
gen welf_ad = publicwelftotalexp/cpi 
su welf_ad
gen welfpc = welf_ad/pop

*State Gross Product

gen gsp_edit = gsp*1000000
gen gsp_ad = gsp_edit/cpi 
su gsp_ad
gen new_gsp = gsp_ad/100000000000
sum new_gsp

*Generate Log of State's Population

gen lpop = log(pop)

*Rename Relevant Independent Variables and Generate LaTeX Table of Descriptive Statistics

rename pctscore tran
rename media_pen med
rename cbias bias
rename govparty_c gparty
rename leg_cont control
rename citi cideo
rename nominate lideo
rename divided_gov div
rename unem1 unemploy
sum nonwhite

*Drop Years with Missing Data

drop if year<=1977

*Summary Statistics of Relevant Variables - Used to Generate Paper Table 1

sutex tran med bias gini new_gsp unemploy  lpop pop65 nonwhite cideo lideo gparty control div, minmax  
  
*************************
***Dependent Variables***
*************************

*Welfare Effort Per Capita (Non-Logged vs. Logged) + Correlation Matrix - Used to Generate Paper Table 2

gen lwelf = log(welfpc)
corr welfpc tran med bias
pwcorr welfpc tran med bias,  star(.10)
pwcorr welfpc tran med bias,  star(.05)


*************************************************************
*************************************************************
********SECTION 3: PREDICTING WELFARE  EXPENDITURES**********
*************************************************************
*************************************************************

*Declare Data as Panel Data

sort $id $t
xtset $id $t
xtdescribe
xtsum $id $t $ylist $xlist

*Define xlist for clustergen Transformation

global xlist tran med bias gini gsp_ad new_gsp unemploy lpop pop65 nonwhite gparty control cideo lideo div 

*Uses Clustergen Command to Develop Within and Between Transformations
    
*net from https://home.gwu.edu/~bartels/stata 

*Click on the blue link called clustergen. A new window will pop up. Simply click on
*the link on the right side of the page that says “click here to install.”
*This program assumes that your cluster identification variable is called “id.” If your
*cluster variable is called, e.g., “countryid,” simply issue the following command before using
*clustergen: *gen id=countryid 

clustergen $xlist 

*Diagnostic Tests for Log Transformation

qui xtreg welfpc  tran_wi tran_bw  med_wi med_bw  bias_wi bias_bw gini_wi gini_bw new_gsp_wi new_gsp_bw unemploy_wi unemploy_bw lpop_wi lpop_bw pop65_wi pop65_bw nonwhite_wi nonwhite_bw  cideo_wi cideo_bw  lideo_wi lideo_bw  gparty_wi gparty_bw  control_wi control_bw  div_wi div_bw i.year , i(state_id) mle
predict res1, e
swilk res1
hist res1

qui xtreg lwelf  tran_wi tran_bw  med_wi med_bw  bias_wi bias_bw gini_wi gini_bw new_gsp_wi new_gsp_bw unemploy_wi unemploy_bw lpop_wi lpop_bw pop65_wi pop65_bw nonwhite_wi nonwhite_bw  cideo_wi cideo_bw  lideo_wi lideo_bw  gparty_wi gparty_bw  control_wi control_bw  div_wi div_bw i.year , i(state_id) mle
predict res2, e
swilk res2
hist res2

*************************
******WBE Models*********
*************************

*WBE Models (1-4) - Reproduces Paper Table 3 and Figure 2

qui xtreg lwelf  tran_wi tran_bw  med_wi med_bw  bias_wi bias_bw gini_wi gini_bw new_gsp_wi new_gsp_bw unemploy_wi unemploy_bw lpop_wi lpop_bw pop65_wi pop65_bw nonwhite_wi nonwhite_bw  cideo_wi cideo_bw  lideo_wi lideo_bw  gparty_wi gparty_bw  control_wi control_bw  div_wi div_bw i.year , i(state_id) re mle
estimates store wbe1

qui xtreg lwelf c.tran_wi##c.med_wi bias_wi gini_wi   new_gsp_wi unemploy_wi lpop_wi pop65_wi nonwhite_wi  cideo_wi  lideo_wi  gparty_wi  control_wi  div_wi c.tran_bw##c.med_bw bias_bw gini_bw  new_gsp_bw unemploy_bw lpop_bw pop65_bw nonwhite_bw  cideo_bw  lideo_bw  gparty_bw  control_bw  div_bw i.year  , i(state_id) re mle
estimates store wbe2
margins, dydx(tran_bw) at(med_bw=(.8(.1)1.5)) vsquish
marginsplot, yline(0)

qui xtreg lwelf c.tran_wi##c.bias_wi med_wi  gini_wi  new_gsp_wi unemploy_wi lpop_wi pop65_wi nonwhite_wi  cideo_wi  lideo_wi  gparty_wi  control_wi  div_wi c.tran_bw##c.bias_bw  med_bw gini_bw  new_gsp_bw unemploy_bw lpop_bw pop65_bw nonwhite_bw  cideo_bw  lideo_bw  gparty_bw  control_bw  div_bw  i.year , i(state_id) re mle
estimates store wbe3
margins, dydx(tran_wi) at (bias_wi=(-.2(.1).2))vsquish
marginsplot, yline(0)

qui xtreg lwelf c.tran_wi##c.med_wi##c.bias_wi gini_wi  new_gsp_wi unemploy_wi lpop_wi pop65_wi nonwhite_wi  cideo_wi  lideo_wi  gparty_wi  control_wi  div_wi c.tran_bw##c.med_bw##c.bias_bw gini_bw  new_gsp_bw unemploy_bw lpop_bw pop65_bw nonwhite_bw  cideo_bw  lideo_bw  gparty_bw  control_bw  div_bw i.year  , i(state_id) re mle
estimates store wbe4

estout wbe1 wbe2 wbe3 wbe4, style(tex) starlevels(* 0.10 ** 0.05 ) cells(b(star fmt(%9.3f)) t(par fmt(%9.2f)))stats(r2  N) 

*Assess Cluster Confounding - Reproduces Appendix Table C.1

qui xtreg lwelf  tran tran_bw  med med_bw  bias bias_bw gini gini_bw new_gsp new_gsp_bw unemploy unemploy_bw lpop lpop_bw pop65 pop65_bw nonwhite nonwhite_bw  cideo cideo_bw  lideo lideo_bw  gparty gparty_bw  control control_bw  div div_bw i.year , i(state_id) re mle
estimates store cctest

estout cctest, style(tex) starlevels(* 0.10 ** 0.05 ) cells(b(star fmt(%9.3f)) t(par fmt(%9.2f)))stats(r2  N) 

*************************
***Static FE/RE Models***
*************************

*Fixed Effects Models (1-4) - Reproduces Paper Table 4

qui xtreg lwelf tran med bias gini new_gsp unemploy  lpop pop65 nonwhite cideo lideo gparty control div i.year, fe 
estimates store fe1
qui xtreg lwelf c.tran##c.med bias gini new_gsp unemploy  lpop pop65 nonwhite cideo lideo gparty control div i.year, fe 
estimates store fe2
qui xtreg lwelf c.tran##c.bias med gini new_gsp unemploy  lpop pop65 nonwhite cideo lideo gparty control div i.year, fe 
estimates store fe3
qui xtreg lwelf c.tran##c.med##c.bias gini new_gsp unemploy  lpop pop65 nonwhite cideo lideo gparty control div i.year, fe 
estimates store fe4

estout fe1 fe2 fe3 fe4, style(tex) starlevels(* 0.10 ** 0.05 ) cells(b(star fmt(%9.3f)) t(par fmt(%9.2f)))stats(r2  N) 

*Random Effects Models (1-4) - Reproduces Paper Table 5

qui xtreg lwelf tran med bias gini new_gsp unemploy  lpop pop65 nonwhite cideo lideo gparty control div i.year, re 
estimates store re1
qui xtreg lwelf c.tran##c.med bias gini new_gsp unemploy  lpop pop65 nonwhite cideo lideo gparty control div i.year, re 
estimates store re2
qui xtreg lwelf c.tran##c.bias med gini new_gsp unemploy  lpop pop65 nonwhite cideo lideo gparty control div i.year, re 
estimates store re3
qui xtreg lwelf c.tran##c.med##c.bias gini new_gsp unemploy  lpop pop65 nonwhite cideo lideo gparty control div i.year, re 
estimates store re4

estout re1 re2 re3 re4, style(tex) starlevels(* 0.10 ** 0.05 ) cells(b(star fmt(%9.3f)) t(par fmt(%9.2f)))stats(r2  N) 

*******************************
*Alternate DV Robustness Checks
*******************************

* Albritton Measure (1990)

gen inc_ad = total_income/cpi
gen albritton = welf_ad/inc_ad
sum albritton
hist albritton
swilk albritton 

qui xtreg albritton  tran_wi tran_bw  med_wi med_bw  bias_wi bias_bw gini_wi gini_bw gsp_ad_wi gsp_ad_bw unemploy_wi unemploy_bw lpop_wi lpop_bw pop65_wi pop65_bw nonwhite_wi nonwhite_bw  cideo_wi cideo_bw  lideo_wi lideo_bw  gparty_wi gparty_bw  control_wi control_bw  div_wi div_bw i.year , i(state_id) mle
estimates store wbe9

qui xtreg albritton c.tran_wi##c.med_wi bias_wi gini_wi  gsp_ad_wi unemploy_wi lpop_wi pop65_wi nonwhite_wi  cideo_wi  lideo_wi  gparty_wi  control_wi  div_wi c.tran_bw##c.med_bw bias_bw gini_bw gsp_ad_bw unemploy_bw lpop_bw pop65_bw nonwhite_bw  cideo_bw  lideo_bw  gparty_bw  control_bw  div_bw i.year  , i(state_id) mle
estimates store wbe10
margins, dydx(tran_bw) at(med_bw=(.8(.1)1.5)) vsquish
marginsplot, yline(0)

qui xtreg albritton c.tran_wi##c.bias_wi med_wi  gini_wi gsp_ad_wi unemploy_wi lpop_wi pop65_wi nonwhite_wi  cideo_wi  lideo_wi  gparty_wi  control_wi  div_wi c.tran_bw##c.bias_bw  med_bw gini_bw gsp_ad_bw unemploy_bw lpop_bw pop65_bw nonwhite_bw  cideo_bw  lideo_bw  gparty_bw  control_bw  div_bw  i.year , i(state_id) mle
estimates store wbe11
margins, dydx(tran_wi) at (bias_wi=(-.2(.1).2))vsquish
marginsplot, yline(0)

qui xtreg albritton c.tran_wi##c.med_wi##c.bias_wi gini_wi gsp_ad_wi unemploy_wi lpop_wi pop65_wi nonwhite_wi  cideo_wi  lideo_wi  gparty_wi  control_wi  div_wi c.tran_bw##c.med_bw##c.bias_bw gini_bw gsp_ad_bw unemploy_bw lpop_bw pop65_bw nonwhite_bw  cideo_bw  lideo_bw  gparty_bw  control_bw  div_bw i.year  , i(state_id) mle
estimates store wbe12

estout wbe9 wbe10 wbe11 wbe12, style(tex) starlevels(* 0.10 ** 0.05 ) cells(b(star fmt(%9.3f)) t(par fmt(%9.2f)))stats(r2  N) 

*Log of Albritton Measure (1990)

gen logal = log(albritton)

qui xtreg logal  tran_wi tran_bw  med_wi med_bw  bias_wi bias_bw gini_wi gini_bw gsp_ad_wi gsp_ad_bw unemploy_wi unemploy_bw lpop_wi lpop_bw pop65_wi pop65_bw nonwhite_wi nonwhite_bw  cideo_wi cideo_bw  lideo_wi lideo_bw  gparty_wi gparty_bw  control_wi control_bw  div_wi div_bw i.year , i(state_id) mle
estimates store wbe13

qui xtreg logal c.tran_wi##c.med_wi bias_wi gini_wi  gsp_ad_wi unemploy_wi lpop_wi pop65_wi nonwhite_wi  cideo_wi  lideo_wi  gparty_wi  control_wi  div_wi c.tran_bw##c.med_bw bias_bw gini_bw gsp_ad_bw unemploy_bw lpop_bw pop65_bw nonwhite_bw  cideo_bw  lideo_bw  gparty_bw  control_bw  div_bw i.year  , i(state_id) mle
estimates store wbe14
margins, dydx(tran_bw) at(med_bw=(.8(.1)1.5)) vsquish
marginsplot, yline(0)

qui xtreg logal c.tran_wi##c.bias_wi med_wi  gini_wi gsp_ad_wi unemploy_wi lpop_wi pop65_wi nonwhite_wi  cideo_wi  lideo_wi  gparty_wi  control_wi  div_wi c.tran_bw##c.bias_bw  med_bw gini_bw gsp_ad_bw unemploy_bw lpop_bw pop65_bw nonwhite_bw  cideo_bw  lideo_bw  gparty_bw  control_bw  div_bw  i.year , i(state_id) mle
estimates store wbe15
margins, dydx(tran_wi) at (bias_wi=(-.2(.1).2))vsquish
marginsplot, yline(0)

qui xtreg logal c.tran_wi##c.med_wi##c.bias_wi gini_wi gsp_ad_wi unemploy_wi lpop_wi pop65_wi nonwhite_wi  cideo_wi  lideo_wi  gparty_wi  control_wi  div_wi c.tran_bw##c.med_bw##c.bias_bw gini_bw gsp_ad_bw unemploy_bw lpop_bw pop65_bw nonwhite_bw  cideo_bw  lideo_bw  gparty_bw  control_bw  div_bw i.year  , i(state_id) mle
estimates store wbe16

estout wbe13 wbe14 wbe15 wbe16, style(tex) starlevels(* 0.10 ** 0.05 ) cells(b(star fmt(%9.3f)) t(par fmt(%9.2f)))stats(r2  N) 

*Take Out Gini Coefficient

qui xtreg lwelf  tran_wi tran_bw  med_wi med_bw  bias_wi bias_bw  gsp_ad_wi gsp_ad_bw unemploy_wi unemploy_bw lpop_wi lpop_bw pop65_wi pop65_bw nonwhite_wi nonwhite_bw  cideo_wi cideo_bw  lideo_wi lideo_bw  gparty_wi gparty_bw  control_wi control_bw  div_wi div_bw i.year, i(state_id) re mle
estimates store gini1

qui xtreg lwelf c.tran_wi##c.med_wi bias_wi  gsp_ad_wi unemploy_wi lpop_wi pop65_wi nonwhite_wi  cideo_wi  lideo_wi  gparty_wi  control_wi  div_wi c.tran_bw##c.med_bw bias_bw  gsp_ad_bw unemploy_bw lpop_bw pop65_bw nonwhite_bw  cideo_bw  lideo_bw  gparty_bw  control_bw  div_bw i.year  , i(state_id) re mle
estimates store gini2
margins, dydx(tran_bw) at(med_bw=(.8(.1)1.5)) vsquish
marginsplot, yline(0)

qui xtreg lwelf c.tran_wi##c.bias_wi med_wi   gsp_ad_wi unemploy_wi lpop_wi pop65_wi nonwhite_wi  cideo_wi  lideo_wi  gparty_wi  control_wi  div_wi c.tran_bw##c.bias_bw  med_bw  gsp_ad_bw unemploy_bw lpop_bw pop65_bw nonwhite_bw  cideo_bw  lideo_bw  gparty_bw  control_bw  div_bw  i.year , i(state_id) re mle
estimates store gini3
margins, dydx(tran_wi) at (bias_wi=(-.2(.1).2))vsquish
marginsplot, yline(0)

qui xtreg lwelf c.tran_wi##c.med_wi##c.bias_wi  gsp_ad_wi unemploy_wi lpop_wi pop65_wi nonwhite_wi  cideo_wi  lideo_wi  gparty_wi  control_wi  div_wi c.tran_bw##c.med_bw##c.bias_bw gsp_ad_bw unemploy_bw lpop_bw pop65_bw nonwhite_bw  cideo_bw  lideo_bw  gparty_bw  control_bw  div_bw i.year  , i(state_id) re mle
estimates store gini4

estout gini1 gini2 gini3 gini4, style(tex) starlevels(* 0.10 ** 0.05 ) cells(b(star fmt(%9.3f)) t(par fmt(%9.2f)))stats(r2  N) 

*Inequality Interaction (Gini)

xtreg lwelf c.med_wi##c.gini_wi tran_wi bias_wi gsp_ad_wi unemploy_wi lpop_wi pop65_wi nonwhite_wi  cideo_wi  lideo_wi  gparty_wi  control_wi  div_wi tran_bw c.med_bw##c.gini_bw  bias_bw gsp_ad_bw unemploy_bw lpop_bw pop65_bw nonwhite_bw  cideo_bw  lideo_bw  gparty_bw  control_bw  div_bw  i.year , i(state_id) mle
estimates store gini5
margins, dydx(tran_wi) at (gini_wi=(-.2(.1).2))vsquish
marginsplot, yline(0)

xtreg lwelf c.tran_wi##c.gini_wi med_wi bias_wi gsp_ad_wi unemploy_wi lpop_wi pop65_wi nonwhite_wi  cideo_wi  lideo_wi  gparty_wi  control_wi  div_wi c.tran_bw##c.gini_bw  bias_bw  med_bw gsp_ad_bw unemploy_bw lpop_bw pop65_bw nonwhite_bw  cideo_bw  lideo_bw  gparty_bw  control_bw  div_bw  i.year , i(state_id) mle
estimates store gini6
margins, dydx(tran_wi) at (gini_wi=(-.2(.1).2))vsquish
marginsplot, yline(0)

estout gini5 gini6, style(tex) starlevels(* 0.10 ** 0.05 ) cells(b(star fmt(%9.3f)) t(par fmt(%9.2f)))stats(r2  N) 
