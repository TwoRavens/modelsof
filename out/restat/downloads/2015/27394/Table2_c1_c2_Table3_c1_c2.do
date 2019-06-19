*This is a STATA Do-file to replicate Table 2, columns (1)-(2) and Table 3, column (1)-(2) in Feenstra-Li-Yu (2014, ReSTATA)*
*The code is by Robert Feenstra (UC-Davis), Zhiyuan Li(SHUFE), and Miaojie Yu(Peking Univ.)                                 *
*To run the code, please put all datasets in the same directoray in your PC                                                 *

********** STATA SETUP
clear
drop _all
set memory 31g
set matsize 10100
set more off

capture log close   
log using Table2_c1_c2_Table3_c1_c2.out, text replace


***********READ DATA**************************************
u Table2_c1c2_Table3_c1c2

***Table 1, Module 2: Summary Statistics for Key variables for Chinese firms (excluding pure exporters)***
su int_usd  rev_usd  FX expint  tang_percent tang_dummy 
su expint if FX==1      //export share conditional on exporting       
de

****Table 2, Column (1), OLS Estimate********

xi: reg rev_usd int_usd    expint_int expintsq_int expint FX   i.cic1d dyear* if expint!=1, robust 

****Table 2,NEW Column (2)********
* There are in fact 5 steps to obtain the estimates in column (2) of Table 2 
*(1) The pliminary regression of firm TFP (called tfpop) on firm-level indicators, 4-digit industry indicators and ex-ante TFP (called tfpop2), and interactions between 2-digit industry indicators and other variables that appead on the right of Equ. (30) in the text
*(2) The selectin equation (30) in the text using fitted TFP
*(3) The second-step Heckman Equation excluding fitted TFP, used to obtain predicted export share
*(4) The  first-step of the 2SLS estimates, see footnote 26 in the text for details
*(5) The second-step of the 2SLS estimates, see footnote 26 in the text for details
* Panel bootstrapping by randomly drawing firms will be done over all five steps, which thereby correcs for clustering by firms, as shown in other files



***Step (1): Prelim Fit**********
local i 2
while `i'<=9 { 
g klratio_dy`i'=klratio*dyear`i'
local i=`i'+1
}

xi i.cic2d
local i 14
while `i'<=37 { 
g klratio_Icic2d_`i'=klratio*_Icic2d_`i'
local i=`i'+1
}

local i 39
while `i'<=42 { 
g klratio_Icic2d_`i'=klratio*_Icic2d_`i'
local i=`i'+1
}

*****
local i 2
while `i'<=9 { 
g tang_dy`i'=tang_percent*dyear`i'
local i=`i'+1
}

xi i.cic2d
local i 14
while `i'<=37 { 
g tang_Icic2d_`i'=tang_percent*_Icic2d_`i'
local i=`i'+1
}

local i 39
while `i'<=42 { 
g tang_Icic2d_`i'=tang_percent*_Icic2d_`i'
local i=`i'+1
}


xi i.cic_adj
xtreg tfpop tfpop2  lntang tang*  klratio*  dyear* _Icic_adj*, fe i(newid)
predict tfpp if e(sample), xbu

drop _Icic_adj*  tang_Icic* tang_dy*
save Table2_c1c2_Table3_c1c2_tfpp, replace

***Step (2): The Selection Equation with fitted TFP (tfpp), shown as Column (1) of Table 3*******************
xi: probit FX tfpp  tang_percent tang_dummy  klratio* dyear2-dyear9 i.cic_adj
predict XI

predict PROBITXB, xb
gen PDFPROBIT=(1/sqrt(2*_pi))*exp(-(PROBITXB^2/2))
gen CDFPROBIT = normprob(PROBITXB)
gen IMR_klratio = PDFPROBIT/CDFPROBIT      /* gets the inverse mills ratio*/
su IMR_klratio


***Step (3): the second-step Heckman Equation excluding fitted TFP, used to obtain predicted export share, shown as Column (2) of Table 3******************
xi: reg expint  tang_percent tang_dummy klratio* IMR_klratio dyear2-dyear9 i.cic_adj
predict expint_p

g diff=expint-expint_p
su diff if FX==1, d
g diffvar=r(Var)  
su diffvar

su expint if FX==1,d   
g etamean=r(mean)
su etamean

g expintpsq=(expint_p)^2
g expintsqp=expintpsq/XI*(1+diffvar/(etamean)^2)
su expintsqp expintpsq
g expintsqp_int=expintsqp*int_usd



*****Generate variables for main estimates*********************
 g       iv            =exp(tfpop2) 
 g       iv_expintp    =iv*expint_p
 g       iv_expintpsq  =iv*(expint_p)^2  
 


g iv_expintsqp =iv*(expintsqp)  
g expintsqp_tang =expintsqp*tang_percent
g expintp_int    =expint_p*int_usd
g expintp_tang   =expint_p*tang_percent




****Step (4)-(5): 2SLS estimates of Equ. (25), shown as Column (3) of Table 2********
**Coefficients of the 2nd-step results are reported in the text, though t-values will be corrected by using bootstrap as reported in other files


xi: ivreg2 rev_usd  (int_usd  expintp_int expintsqp_int =iv  iv_expintp iv_expintsqp) expint_p   FX    i.cic1d    dyear* , robust ffirst


********** CLOSE OUTPUT
drop _all
log close
