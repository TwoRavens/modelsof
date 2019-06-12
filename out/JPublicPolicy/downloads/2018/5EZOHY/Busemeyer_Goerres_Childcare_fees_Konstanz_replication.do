*description of the data
*each observation is one rating of a fictitious situation
*each respondent rated several situations
*therefore observations are nested in individuals
*respondents are moreover nested in boroughy (which we do not need to correct for because they are random samples from these quarters)

*technical variables not described in the text
*flag_imput = signals whether the dependent variables has an estimated value by the respondent
*modelname, rho, r2_w, r2_b, r2_o are used to store estimates for later copy and paste
*pseudo = identifier of the respondent
*the % of non German citizens and the % of Christians per borough are so highly correlated that they lead to collinearity issues, thus regression contain one or the other


*technical details
*Regressions were run with Stata 14.2
version 14.2
set more off

*figure 1: distribution of the dependent variable
set scheme s2mono
twoway (histogram fairfee, freq color(gs12)) ///
       (histogram fairfee if flag_imput==1, freq  color(red) fcolor(black) lcolor(black)), legend(off) xtitle("Fair fee level")
	   
*Table 1: Random-intercept models of the dependent variable fair fee
*generate empty variables to store model results
gen str12 modelname=""
gen rho=.
gen r2_w=.
gen r2_b=.
gen r2_o=.

*random intercept model without any predictor variables
xtreg fairfee flag_imput, i(pseudo)
replace modelname="m1null" in 1
foreach var of varlist rho r2_w r2_b r2_o { // this loop stores the fit indices 
local a=e(`var')
replace `var'=`a' in 1
}


estimates store m1null 

xtreg fairfee flag_imput ///
eklalin  alleinerz erwerbm_such erwerbm_teil erwerbm_voll erwerbv_such erwerbv_teil erwerbv_voll  grosselthilfe wurz_konstanz wurz_ausland rel_christ rel_muslim, i(pseudo)
estimates store m2
replace modelname="m2" in 4
foreach var of varlist rho r2_w r2_b r2_o {
local a=e(`var')
replace `var'=`a' in 2
}

test erwerbm_such=erwerbm_teil=erwerbm_voll=0 // F-test whether the the employment status variables of the mother can be dropped
test erwerbv_such=erwerbv_teil=erwerbv_voll=0 // F-test whether the the employment status variables of the father can be dropped  
test wurz_konstanz=wurz_ausland=rel_christ=rel_muslim=0 //F-test whether the origin of the vignette family and the religion of the child matter to the rater

xtreg fairfee flag_imput ///
eklalin  alleinerz erwerbm_such erwerbm_teil erwerbm_voll erwerbv_such erwerbv_teil erwerbv_voll  grosselthilfe wurz_konstanz wurz_ausland rel_christ rel_muslim ///
hhincome_imp age  female educ kids01 logmembers  decitizbirth01 reli_dum2 reli_dum3 ///
purchasepower_euro childcare0to3_rel popdensity noncitizen_german_perc, i(pseudo)
estimates store m3
replace modelname="m3" in 3
foreach var of varlist rho r2_w r2_b r2_o {
local a=e(`var')
replace `var'=`a' in 3
}


*export table with estimates
cd "" //to a directory of choice
esttab  m1null m2 m3 using regtable1.rtf, b(%8.2f) se(%8.2f) star brackets label nogaps scalars(r2 r2_a bic aic) replace

*interaction analysis discussed in the text and appendix D
xtreg fairfee eklalin_c alleinerz erwerbm_such erwerbm_teil erwerbm_voll erwerbv_such erwerbv_teil erwerbv_voll  grosselthilfe wurz_konstanz wurz_ausland rel_christ rel_muslim ///
hhincome_imp_c age  female educ kids01 logmembers  decitizbirth01 reli_dum2 reli_dum3 ///
purchasepower_euro_c religion_christtot_perc childcare0to3_rel popdensity, i(pseudo)
estimates store m4a

xtreg fairfee eklalin_c alleinerz erwerbm_such erwerbm_teil erwerbm_voll erwerbv_such erwerbv_teil erwerbv_voll  grosselthilfe wurz_konstanz wurz_ausland rel_christ rel_muslim ///
hhincome_imp_c eklaXincome age  female educ kids01 logmembers  decitizbirth01 reli_dum2 reli_dum3 ///
purchasepower_euro_c religion_christtot_perc childcare0to3_rel popdensity, i(pseudo)
estimates store m4b

lincom eklalin_c+0*eklaXincome
lincom eklalin_c+(-1650)*eklaXincome
lincom eklalin_c+(+1650)*eklaXincome

xtreg fairfee eklalin_c alleinerz erwerbm_such erwerbm_teil erwerbm_voll erwerbv_such erwerbv_teil erwerbv_voll  grosselthilfe wurz_konstanz wurz_ausland rel_christ rel_muslim ///
hhincome_imp_c age  female educ kids01 logmembers  decitizbirth01 reli_dum2 reli_dum3 ///
purchasepower_euro_c eklaXpurchase religion_christtot_perc childcare0to3_rel popdensity, i(pseudo)
estimates store m4c

xtreg fairfee eklalin_c alleinerz erwerbm_such erwerbm_teil erwerbm_voll erwerbv_such erwerbv_teil erwerbv_voll  grosselthilfe wurz_konstanz wurz_ausland rel_christ rel_muslim ///
hhincome_imp_c eklaXincome age  female educ kids01 logmembers  decitizbirth01 reli_dum2 reli_dum3 ///
purchasepower_euro_c eklaXpurchase religion_christtot_perc childcare0to3_rel popdensity, i(pseudo)
estimates store m4d
test eklaXpurchase=0

xtreg fairfee eklalin_c alleinerz erwerbm_such erwerbm_teil erwerbm_voll erwerbv_such erwerbv_teil erwerbv_voll  grosselthilfe wurz_konstanz wurz_ausland rel_christ rel_muslim ///
hhincome_imp_c eklaXincome age  female educ kids01 logmembers  decitizbirth01 reli_dum2 reli_dum3  ///
purchasepower_euro_c eklaXpurchase eklaXincomeXpurchase religion_christtot_perc childcare0to3_rel popdensity, i(pseudo)
estimates store m4e
test eklaXpurchase=eklaXincomeXpurchase=0


*Table Appendix 1
tab eklalin
sum alleinerz erwerbm_such erwerbm_teil erwerbm_voll erwerbv_such erwerbv_teil erwerbv_voll ///
grosselthilfe wurz_konstanz wurz_ausland rel_christ rel_muslim
