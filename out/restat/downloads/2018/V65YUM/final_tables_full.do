***************************************************************
* final_tables.do
*****************************************************************

clear
cap clear matrix
set more off, permanently
clear mata
set maxvar  32000
set matsize 11000

clear
set more off

cap log close
log using log/final_tables.log, replace

***************************
* Table B3: First Stage
***************************
use temp/regdata_finaltables_full.dta, clear
gen nonyc=(area!=3600060)  /*no NY city*/

*Label Variable
label variable zratio_smith_lit "ln($\widehat{H/L}$)"

*First stage to create the predicted instrument: these include the interaction areadum*dcentury
forvalues i=1(1)2{
estimates clear
qui {
estimates clear
* Area Fixed Effect
areg skratio_lit zratio_smith_lit  yrdum*  areadumcent`i'_*  [aw=weight] if  (capsamp|Horsesamp) & xzsamp, absorb(area) cluster(area)
predict skratio_noind`i'
estimates store noind

* Industry Fixed Effect
areg skratio_lit zratio_smith_lit areadum_*   yrdum* areadumcent`i'_*  [aw=weight] if  (capsamp|Horsesamp) & xzsamp, absorb(industry_unified) cluster(area)
predict skratio_area`i'
estimates store area 

* Industry*Year Fixed Effect
areg skratio_lit zratio_smith_lit areadum_* inddum_*  yrdum* areadumcent`i'_* [aw=weight]  if (capsamp|Horsesamp) &  xzsamp , absorb(indyear) cluster(area)
predict skratio_indyr`i'
estimates store indyr
}
estout * using  "tab/TableB3_`i'.txt", label keep(zratio_smith*) stats(r2 rmse N, labels("$ R^2$" "RootMSE" "N")) cells(b(fmt(%9.3f) star) se(par fmt(%9.3f)) ) starlevels (* 0.10 ** 0.05 *** 0.01 ) style(tex) replace  notype mlabels(, numbers )
}



* Predicted Instruments
forvalues i=1(1)2{
foreach x in skratio_noind`i' skratio_area`i' skratio_indyr`i'{
gen `x'_dearly`i'=`x'*dearly`i'
gen `x'_dlate`i'=`x'*dlate`i'
}
}

*Label variables
label variable dearly1 "ln(H/L)*(1860 to 1880)"
label variable dlate1 "ln(H/L)*(1890 to 1930)"
label variable dearly2 "ln(H/L)*(1860 to 1890)"
label variable dlate2 "ln(H/L)*(1900 to 1930)"


*Save data
save temp/regdata_finaltables+fs_full.dta, replace

***************************
*Table B.4: First Stage Tables
***************************

use temp/regdata_finaltables+fs_full.dta, clear

 
forvalues i=1(1)2{
estimates clear

**** Area
qui areg skratio_dearly`i' skratio_noind`i'_dearly`i' skratio_noind`i'_dlate`i'  yrdum*  areadumcent`i'_*  [aw=weight] if  (capsamp|Horsesamp) & xzsamp, absorb(area) cluster(area)
estimates store noind_early
qui areg skratio_dlate`i' skratio_noind`i'_dearly`i' skratio_noind`i'_dlate`i'  yrdum*  areadumcent`i'_* [aw=weight]  if  (capsamp|Horsesamp) & xzsamp, absorb(area) cluster(area)
estimates store noind_late

**** Industry
qui areg skratio_dearly`i' skratio_area`i'_dearly`i' skratio_area`i'_dlate`i'  areadum_*  yrdum* areadumcent`i'_* [aw=weight]  if  (capsamp|Horsesamp) & xzsamp, absorb(industry_unified) cluster(area)
estimates store area_early
qui areg skratio_dlate`i' skratio_area`i'_dearly`i' skratio_area`i'_dlate`i'  areadum_*   yrdum* areadumcent`i'_*  [aw=weight] if  (capsamp|Horsesamp) & xzsamp, absorb(industry_unified) cluster(area)
estimates store area_late

**** Industry*year
qui areg skratio_dearly`i' skratio_indyr`i'_dearly`i' skratio_indyr`i'_dlate`i'  areadum_*  yrdum*  inddum_* areadumcent`i'_* [aw=weight] if (capsamp|Horsesamp) &  xzsamp , absorb(indyear) cluster(area)
estimates store indyr_early
qui areg skratio_dlate`i' skratio_indyr`i'_dearly`i' skratio_indyr`i'_dlate`i'  areadum_*   yrdum* areadumcent`i'_* inddum_* [aw=weight]  if (capsamp|Horsesamp) &  xzsamp , absorb(indyear) cluster(area)
estimates store indyr_late

estout *_early *_late using  "tab/TableB4_`i'.txt", label keep(dearly* dlate*) rename(skratio_noind`i'_dearly`i' dearly`i', skratio_noind`i'_dlate`i' dlate`i', skratio_area`i'_dearly`i' dearly`i', skratio_area`i'_dlate`i' dlate`i', skratio_indyr`i'_dearly`i' dearly`i', skratio_indyr`i'_dlate`i' dlate`i') ///
stats(r2 rmse N, labels("$ R^2$" "RootMSE" "N")) cells(b(fmt(%9.3f) star) se(par fmt(%9.3f)) ) starlevels (* 0.10 ** 0.05 *** 0.01 ) style(tex) replace  notype mlabels(, numbers )
}
estimates clear


***************************
* Table 1: agg estimates
***************************

use temp/regdata_finaltables_agg_full.dta, clear



*Label
foreach i in 1 2{
label variable skratio_dearly`i' "ln(H/L)*Early"
label variable skratio_dlate`i' "ln(H/L)*Late"
}


local subsamp "& lnkyimpute~=."
forvalues i=1(1)2{
estimates clear
foreach out in klimpute kyimpute {

*OLS
di "Running ols regression for ln`out'_`i'"
qui reg ln`out' skratio_dearly`i' skratio_dlate`i'  areadum_* yrdum* areadumcent`i'_*  if xzsamp `subsamp', cluster(area) 
estimates store ols_`out'

*IV
di "Running iv  regression for ln`out'_`i'"	
qui ivreg2 ln`out' (skratio_dearly`i' skratio_dlate`i' = skratio_agg`i'_dearly`i' skratio_agg`i'_dlate`i') areadum_* yrdum* areadumcent`i'_*  if   xzsamp `subsamp', cluster(area) savefirst  savefp(fs)
estimates store iv_`out'
qui test (skratio_dearly`i'=skratio_dlate`i') 
di "ln`out'_`i',  Chi-stat: " r(chi2) ", p-value = " r(p)
	
}
estout ols_* iv_* using  "tab/Table1_`i'.txt", label keep(skratio_*) stats(r2 rmse N, labels("$ R^2$" "RootMSE" "N")) cells(b(fmt(%9.3f) star) se(par fmt(%9.3f)) ) starlevels (* 0.10 ** 0.05 *** 0.01 ) style(tex) replace  notype mlabels(, numbers )
}

estimates clear


******************************************************
* Table 2: Industry mix
******************************************************

use temp/regdata_industrymix_full.dta, clear

 *Label
foreach i in 1 2{
label variable skratio_dearly`i' "ln(H/L)*Early"
label variable skratio_dlate`i' "ln(H/L)*Late"
}
  

forvalues i=1(1)2{
estimates clear
foreach var in kl_1860 hl_1890{
foreach out in  l {

*Area
qui ivreg2 share_`var'_`out'_1 (skratio_dearly`i' skratio_dlate`i' = skratio_ho`i'_dearly`i' skratio_ho`i'_dlate`i') yrdum* areadum_*  areadumcent`i'_* , cluster(area) savefirst  savefp(fs)
qui estimates store share_`out'_`var'_1
qui test (skratio_dearly`i'=skratio_dlate`i') 
di "share_`var'_`out'_1,  Chi-stat: " r(chi2) ", p-value = " r(p)	

*Industry
qui ivreg2 share_`var'_`out'_2 (skratio_dearly`i' skratio_dlate`i' = skratio_ho`i'_dearly`i' skratio_ho`i'_dlate`i') yrdum* areadum_*  areadumcent`i'_* , cluster(area) savefirst  savefp(fs)
qui estimates store share_`out'_`var'_2
qui test (skratio_dearly`i'=skratio_dlate`i') 
di "share_`var'_`out'_2,  Chi-stat: " r(chi2) ", p-value = " r(p)	

*Industry*Year
qui ivreg2 share_`var'_`out'_3 (skratio_dearly`i' skratio_dlate`i' = skratio_ho`i'_dearly`i' skratio_ho`i'_dlate`i') yrdum* areadum_*  areadumcent`i'_* , cluster(area) savefirst  savefp(fs)
qui estimates store share_`out'_`var'_3
qui test (skratio_dearly`i'=skratio_dlate`i') 
di "share_`var'_`out'_3,  Chi-stat: " r(chi2) ", p-value = " r(p)	
}
}
estout share* using  "tab/Table2_`i'.txt", label keep(skratio_*) stats(r2 rmse N, labels("$ R^2$" "RootMSE" "N")) cells(b(fmt(%9.3f) star) se(par fmt(%9.3f)) ) starlevels (* 0.10 ** 0.05 *** 0.01 ) style(tex) replace  notype mlabels(, numbers )
}




use temp/temp_industrymix.dta, clear
foreach var in kl_mean hl_mean kl_1860 hl_1890 hl_mean_a hl_1890_a{
tabstat `var', by(quant_`var')
}

**************
*reduced form
**************
forvalues i=1(1)2{
estimates clear
foreach var in kl_1860 hl_1890 {
foreach out in  l {
qui areg share_`var'_`out'_1 skratio_ho`i'_dearly`i' skratio_ho`i'_dlate`i' yrdum*   areadumcent`i'_* , absorb(area) cluster(area) 
qui test (skratio_ho`i'_dearly`i'=0) (skratio_ho`i'_dlate`i'=0)
di "share_`var'_`out'_1_`i' joint,  F-stat: " r(F) ", p-value = " r(p)
qui test (skratio_ho`i'_dearly`i'=0) 
di "share_`var'_`out'_1_`i' early,  F-stat: " r(F) ", p-value = " r(p)
qui test  (skratio_ho`i'_dlate`i'=0)
di "share_`var'_`out'_1_`i' late,  F-stat: " r(F) ", p-value = " r(p)

qui areg share_`var'_`out'_2  skratio_ho`i'_dearly`i' skratio_ho`i'_dlate`i' yrdum*  areadumcent`i'_* , absorb(area) cluster(area) 
qui test (skratio_ho`i'_dearly`i'=0) (skratio_ho`i'_dlate`i'=0)
di "share_`var'_`out'_2_`i' joint,  F-stat: " r(F) ", p-value = " r(p)
qui test (skratio_ho`i'_dearly`i'=0) 
di "share_`var'_`out'_2_`i' early,  F-stat: " r(F) ", p-value = " r(p)
qui test  (skratio_ho`i'_dlate`i'=0)
di "share_`var'_`out'_2_`i' late,  F-stat: " r(F) ", p-value = " r(p)

qui areg share_`var'_`out'_3 skratio_ho`i'_dearly`i' skratio_ho`i'_dlate`i' yrdum*  areadumcent`i'_* , absorb(area) cluster(area)
qui test (skratio_ho`i'_dearly`i'=0) (skratio_ho`i'_dlate`i'=0)
di "share_`var'_`out'_3_`i' joint,  F-stat: " r(F) ", p-value = " r(p)
qui test (skratio_ho`i'_dearly`i'=0) 
di "share_`var'_`out'_3_`i' early,  F-stat: " r(F) ", p-value = " r(p)
qui test (skratio_ho`i'_dlate`i'=0)
di "share_`var'_`out'_3_`i' late,  F-stat: " r(F) ", p-value = " r(p)
}
}
}

estimates clear




***************************
* Table 3: IV estimates
***************************
use temp/regdata_finaltables+fs_full.dta, clear


* IV estimates

* define outcome samples
local klimputesamp "(capsamp|Horsesamp) & xzsamp"
local kyimputesamp "(capsamp|Horsesamp) & xzsamp"

***************************************************************************
* iv by century, with various effects & 2 different cut-offs
***************************************************************************
forvalues i=1(1)2{
estimates clear
  foreach out in klimpute kyimpute {
  
*Area
di "ivreg ln`out'`i' noind "
qui ivreg2 ln`out' (skratio_dearly`i' skratio_dlate`i' = skratio_noind`i'_dearly`i' skratio_noind`i'_dlate`i') areadum_* yrdum*  areadumcent`i'_*  if ``out'samp' , cluster(area) 
estimates store noind_`out'		  
qui test (skratio_dearly`i'=skratio_dlate`i') 
di "ln`out'_`i' no ind,  Chi-stat: " r(chi2) ", p-value = " r(p)	

*Industry
di "ivreg ln`out'`i' ind "
qui ivreg2 ln`out' (skratio_dearly`i' skratio_dlate`i' = skratio_area`i'_dearly`i' skratio_area`i'_dlate`i') areadum_* yrdum*  areadumcent`i'_* inddum_*  if ``out'samp', cluster(area) 
estimates store ind_`out'
qui test (skratio_dearly`i'=skratio_dlate`i') 
di "ln`out'_`i' ind,  Chi-stat: " r(chi2) ", p-value = " r(p)	

*Industry*Year
di "ivreg ln`out'`i' indyear "
qui ivreg2 ln`out' (skratio_dearly`i' skratio_dlate`i' = skratio_indyr`i'_dearly`i' skratio_indyr`i'_dlate`i') areadum_* yrdum*  areadumcent`i'_* itdum_*  if ``out'samp', cluster(area) 
estimates store indyr_`out'
qui test (skratio_dearly`i'=skratio_dlate`i') 
di "ln`out'_`i' indyr,  Chi-stat: " r(chi2) ", p-value = " r(p)		  
  }	
  
estout *_klimpute *_kyimpute using  "tab/Table3_`i'.txt", label keep(skratio_*) stats(r2 rmse N, labels("$ R^2$" "RootMSE" "N")) cells(b(fmt(%9.3f) star) se(par fmt(%9.3f)) ) starlevels (* 0.10 ** 0.05 *** 0.01 ) style(tex) replace  notype mlabels(, numbers )
  } 
 
**************
*reduced form
**************


 forvalues i=1(1)2{
estimates clear
  foreach out in klimpute kyimpute {
* No ind  
   di "areg ln`out'_noind_`i' "
  qui areg ln`out'  skratio_noind`i'_dearly`i' skratio_noind`i'_dlate`i' yrdum*  areadumcent`i'_* [aw=weight] if ``out'samp' , cluster(area) absorb(area)
  estimates store noind_`out'
  qui test (skratio_noind`i'_dearly`i'=0) (skratio_noind`i'_dlate`i'=0) 
  di "ln`out'_noind`i'_`i' joint,  F-stat: " r(F) ", p-value = " r(p)	

  qui test (skratio_noind`i'_dearly`i'=0) 
  di "ln`out'_noind`i'_`i' early,  F-stat: " r(F) ", p-value = " r(p)	

  qui test (skratio_noind`i'_dlate`i'=0) 
  di "ln`out'_noind`i'_`i' late,  F-stat: " r(F) ", p-value = " r(p)	

* Industry  
  di "areg ln`out'_ind_`i' "
  qui areg ln`out'  skratio_area`i'_dearly`i' skratio_area`i'_dlate`i' yrdum* areadum_*  areadumcent`i'_* [aw=weight] if ``out'samp' , cluster(area) absorb(industry_unified)
  estimates store area_`out'
  qui test (skratio_area`i'_dearly`i'=0) (skratio_area`i'_dlate`i'=0) 
  di "ln`out'_ind`i'_`i' joint,  F-stat: " r(F) ", p-value = " r(p)	

  qui test (skratio_area`i'_dearly`i'=0) 
  di "ln`out'_ind`i'_`i' early,  F-stat: " r(F) ", p-value = " r(p)	

  qui test (skratio_area`i'_dlate`i'=0) 
  di "ln`out'_ind`i'_`i' late,  F-stat: " r(F) ", p-value = " r(p)	

* Indyr
 di " areg ln`out'_indyr_`i' "
qui areg ln`out'  skratio_indyr`i'_dearly`i' skratio_indyr`i'_dlate`i' areadum_* yrdum*  areadumcent`i'_* [aw=weight] if ``out'samp' , absorb(indyear) cluster(area) 
estimates store indyr_`out'
qui test (skratio_indyr`i'_dearly`i'=0) (skratio_indyr`i'_dlate`i'=0) 
di "ln`out'_indyr_`i' joint,  F-stat: " r(F) ", p-value = " r(p)	

qui test (skratio_indyr`i'_dearly`i'=0) 
di "ln`out'_indyr_`i' early,  F-stat: " r(F) ", p-value = " r(p)	

qui test (skratio_indyr`i'_dlate`i'=0) 
di "ln`out'_indyr_`i' late,  F-stat: " r(F) ", p-value = " r(p)	

  }	
  }
  
estimates clear
 
 

***************************************************************************
* Table B5: Chandler, Firm Size and H/L, K/N
***************************************************************************

use temp/regdata_finaltables+fs_full.dta, clear

* define outcome samples
local klimputesamp "(capsamp|Horsesamp) & xzsamp"
local kyimputesamp "(capsamp|Horsesamp) & xzsamp"


  **First Stage
  forvalues i=1(1)2{
  qui reg skratio_dearly`i' skratio_noind`i'_dearly`i' skratio_noind`i'_dlate`i' areadum_* yrdum* itdum_*  areadumcent`i'_*  if (capsamp|Horsesamp) & xzsamp , cluster(area) 
  predict skratio_dearly`i'_indyrp
  qui reg skratio_dlate`i' skratio_noind`i'_dearly`i' skratio_noind`i'_dlate`i' areadum_* yrdum* itdum_*  areadumcent`i'_*  if (capsamp|Horsesamp) & xzsamp , cluster(area) 
  predict skratio_dlate`i'_indyrp

  
  **Interaction
  foreach y in fsize early sizek sizeh{
  gen skratio_dearly`i'_indyrp_`y'=skratio_dearly`i'_indyrp*`y'
  gen skratio_dlate`i'_indyrp_`y'=skratio_dlate`i'_indyrp*`y'
   }	
   }
   
  **Label
label variable skratio_dearly1_indyrp_early "ln(H/L)*(1860 to 1880)*Early industries"
label variable skratio_dlate1_indyrp_early "ln(H/L)*(1890 to 1930)*Early industries"
label variable skratio_dearly2_indyrp_early "ln(H/L)*(1860 to 1890)*Early industries"
label variable skratio_dlate2_indyrp_early "ln(H/L)*(1900 to 1930)*Early industries"



forvalues i=1(1)2{
estimates clear
  foreach out in klimpute kyimpute {
  foreach y in fsize early sizek sizeh{ 
  * Industry*Year
 	  di "ivreg ln`out' skratio_dearly`j' skratio_dlate`j' areadum_* yrdum*  if `out'samp', cluster(area) "
      qui reg ln`out' skratio_dearly`i'_indyrp skratio_dlate`i'_indyrp skratio_dearly`i'_indyrp_`y'  skratio_dlate`i'_indyrp_`y' areadum_* yrdum* itdum_* areadumcent`i'_*  if ``out'samp' , cluster(area) 
      estimates store indyrp_`y'_`out' 	  
	  
 }
 }	

estout *_klimpute *_kyimpute using  "tab/TableB5_`i'.txt", label keep(skratio_*) rename(skratio_dearly`i'_indyrp_fsize skratio_dearly`i'_indyrp_early, skratio_dlate`i'_indyrp_fsize skratio_dlate`i'_indyrp_early, skratio_dearly`i'_indyrp_sizeh skratio_dearly`i'_indyrp_early, skratio_dlate`i'_indyrp_sizeh skratio_dlate`i'_indyrp_early, skratio_dearly`i'_indyrp_sizek skratio_dearly`i'_indyrp_early, skratio_dlate`i'_indyrp_sizek skratio_dlate`i'_indyrp_early) stats(r2 rmse N, labels("$ R^2$" "RootMSE" "N")) cells(b(fmt(%9.3f) star) se(par fmt(%9.3f)) ) starlevels (* 0.10 ** 0.05 *** 0.01 ) style(tex) replace  notype mlabels(, numbers )
 
 } 
 
 
***************************
* Table 4 : IV estimates for fuel & horsepower 
***************************

estimates clear
use temp/regdata_finaltables+fs_full.dta, clear

* define outcome samples
local Fulsamp "(capsamp|Fuelsamp) & xzsamp & lnFul!=. & lnFuy!=.  "
local Fuysamp "(capsamp|Fuelsamp) & xzsamp & lnFul!=. & lnFuy!=. "
local Hplimputesamp  "(capsamp|Hpimputesamp) & xzsamp & lnHplimpute!=. & lnHpYimpute!=. "
local HpYimputesamp  "(capsamp|Hpimputesamp) & xzsamp & lnHplimpute!=. & lnHpYimpute!=. "

  
forvalues i=2(1)2{
estimates clear
  foreach out in Ful Hplimpute Fuy HpYimpute {
  
*Area
di "ivreg ln`out' noind "
qui ivreg2 ln`out' (skratio_dearly`i' skratio_dlate`i' = skratio_noind`i'_dearly`i' skratio_noind`i'_dlate`i') areadum_* yrdum*  areadumcent`i'_*  if ``out'samp' , cluster(area) savefirst  savefp(fsnoind)
estimates store `out'_noind
qui test (skratio_dearly`i'=skratio_dlate`i') 
di "ln`out'_`i' no ind,  Chi-stat: " r(chi2) ", p-value = " r(p)	

*Industry
di "ivreg ln`out' inddum "
qui ivreg2 ln`out' (skratio_dearly`i' skratio_dlate`i' = skratio_area`i'_dearly`i' skratio_area`i'_dlate`i') areadum_* yrdum*  areadumcent`i'_* inddum_*  if ``out'samp', cluster(area) savefirst  savefp(fsind)
estimates store `out'_ind
qui test (skratio_dearly`i'=skratio_dlate`i') 
di "ln`out'_`i' ind,  Chi-stat: " r(chi2) ", p-value = " r(p)	

*Industry*Year
di "ivreg ln`out' indyear "
qui ivreg2 ln`out' (skratio_dearly`i' skratio_dlate`i' = skratio_indyr`i'_dearly`i' skratio_indyr`i'_dlate`i') areadum_* yrdum*  areadumcent`i'_* itdum_*  if ``out'samp', cluster(area) savefirst  savefp(fsindyr)
estimates store `out'_indyr
qui test (skratio_dearly`i'=skratio_dlate`i') 
di "ln`out'_`i' indyr,  Chi-stat: " r(chi2) ", p-value = " r(p)	

  }	
  
estout Ful* Hplimpute* Fuy* HpYimpute*  using  "tab/Table4_iv.txt", label keep(skratio_*) stats(r2 rmse N, labels("$ R^2$" "RootMSE" "N")) cells(b(fmt(%9.3f) star) se(par fmt(%9.3f)) ) starlevels (* 0.10 ** 0.05 *** 0.01 ) style(tex) replace  notype mlabels(, numbers )
  }  

**************
*reduced form
**************
forvalues i=2(1)2{
estimates clear
  foreach out in Ful Hplimpute Fuy HpYimpute {
* AREA     
qui areg ln`out' skratio_noind`i'_dearly`i' skratio_noind`i'_dlate`i'  yrdum*  areadumcent`i'_* [aw=weight] if ``out'samp' , absorb(area) cluster(area) 
estimates store `out'_noind
qui test (skratio_noind`i'_dearly`i'=0) (skratio_noind`i'_dlate`i'=0) 
di "ln`out'_noind`i'_`i' joint,  F-stat: " r(F) ", p-value = " r(p)	

qui test (skratio_noind`i'_dearly`i'=0) 
di "ln`out'_noind`i'_`i' early,  F-stat: " r(F) ", p-value = " r(p)	

qui test (skratio_noind`i'_dlate`i'=0) 
di "ln`out'_noind`i'_`i' late,  F-stat: " r(F) ", p-value = " r(p)	

* INDUSTRY
qui areg ln`out' skratio_area`i'_dearly`i' skratio_area`i'_dlate`i' areadum_* yrdum*  areadumcent`i'_*  [aw=weight] if ``out'samp', absorb(industry_unified) cluster(area) 
estimates store `out'_ind
qui test (skratio_area`i'_dearly`i'=0) (skratio_area`i'_dlate`i'=0) 
di "ln`out'_ind`i'_`i' joint,  F-stat: " r(F) ", p-value = " r(p)	

qui test (skratio_area`i'_dearly`i'=0) 
di "ln`out'_ind`i'_`i' early,  F-stat: " r(F) ", p-value = " r(p)	

qui test (skratio_area`i'_dlate`i'=0) 
di "ln`out'_ind`i'_`i' late,  F-stat: " r(F) ", p-value = " r(p)	
  
 * INDUSTRY*YEAR 
qui areg ln`out'  skratio_indyr`i'_dearly`i' skratio_indyr`i'_dlate`i' areadum_* yrdum*  areadumcent`i'_* itdum_* [aw=weight] if ``out'samp', cluster(area) absorb(indyear)
estimates store `out'_indyr

qui test (skratio_indyr`i'_dearly`i'=0) (skratio_indyr`i'_dlate`i'=0) 
di "ln`out'_indyr_`i' joint,  F-stat: " r(F) ", p-value = " r(p)	

qui test (skratio_indyr`i'_dearly`i'=0) 
di "ln`out'_indyr_`i' early,  F-stat: " r(F) ", p-value = " r(p)	

qui test (skratio_indyr`i'_dlate`i'=0) 
di "ln`out'_indyr_`i' late,  F-stat: " r(F) ", p-value = " r(p)	
  }	
  }  
  
estimates clear


 
******************************************************
* Table B6: Workers per establishment
******************************************************

use temp/regdata_finaltables_full.dta, clear

* define outcome samples
local lestsamp "xzsamp & year<1940"

* first stage to create the predicted instrument: these include the interaction areadum*dcentury
forvalues i=1(1)2{
qui {
estimates clear

* Area
areg skratio_lit zratio_smith_lit  yrdum*  areadumcent`i'_*   if `lestsamp', absorb(area) cluster(area)
predict skratio_noind`i'
estimates store noind

*Industry
areg skratio_lit zratio_smith_lit areadum_*   yrdum* areadumcent`i'_*   if  `lestsamp', absorb(industry_unified) cluster(area)
predict skratio_area`i'
estimates store area 

*Industr*Year
areg skratio_lit zratio_smith_lit areadum_* inddum_*  yrdum* areadumcent`i'_*   if `lestsamp' , absorb(indyear) cluster(area)
predict skratio_indyr`i'
estimates store indyr
}
}

*  Instruments

foreach x in skratio_noind1 skratio_area1 skratio_indyr1  skratio_noind2 skratio_area2 skratio_indyr2 {
gen `x'_dearly1=`x'*dearly1
gen `x'_dlate1=`x'*dlate1
gen `x'_dearly2=`x'*dearly2
gen `x'_dlate2=`x'*dlate2
}


***************************************************************************
* iv by century, with various effects & 2 different cut-offs
***************************************************************************

forvalues i=1(1)2{
estimates clear
 foreach out in lest {

di "reg ln`out'_`i' noind "
qui reg ln`out' skratio_dearly`i' skratio_dlate`i' areadum_* yrdum*  areadumcent`i'_*   if ``out'samp', cluster(area)
estimates store ols_noind

di "reg ln`out'_`i' ind "
qui reg ln`out' skratio_dearly`i' skratio_dlate`i' areadum_* yrdum*  areadumcent`i'_* inddum_*  if ``out'samp', cluster(area)
estimates store ols_ind

di "reg ln`out'_`i' indyr "
qui reg ln`out' skratio_dearly`i' skratio_dlate`i' areadum_* yrdum*  areadumcent`i'_* itdum_*  if ``out'samp', cluster(area)
estimates store ols_indyr	

*IV  
di "ivreg ln`out'_`i' noind "
qui ivreg2 ln`out' (skratio_dearly`i' skratio_dlate`i' = skratio_noind`i'_dearly`i' skratio_noind`i'_dlate`i') areadum_* yrdum*  areadumcent`i'_*  if ``out'samp' , cluster(area) saverf  saverfp(rfnoind)
estimates store iv_noind		  
qui test (skratio_dearly`i'=skratio_dlate`i') 
di "ln`out'_`i' noind,  Chi-stat: " r(chi2) ", p-value = " r(p)

di "ivreg ln`out'_`i' ind "
qui ivreg2 ln`out' (skratio_dearly`i' skratio_dlate`i' = skratio_area`i'_dearly`i' skratio_area`i'_dlate`i') areadum_* yrdum*  areadumcent`i'_* inddum_*  if ``out'samp', cluster(area) saverf  saverfp(rfind)
estimates store iv_ind
qui test (skratio_dearly`i'=skratio_dlate`i') 
di "ln`out'_`i' ind,  Chi-stat: " r(chi2) ", p-value = " r(p)

di "ivreg ln`out'_`i' indyr "
qui ivreg2 ln`out' (skratio_dearly`i' skratio_dlate`i' = skratio_indyr`i'_dearly`i' skratio_indyr`i'_dlate`i') areadum_* yrdum*  areadumcent`i'_* itdum_*  if ``out'samp', cluster(area) saverf  saverfp(rfindyr)
estimates store iv_indyr
qui test (skratio_dearly`i'=skratio_dlate`i') 
di "ln`out'_`i' indyr,  Chi-stat: " r(chi2) ", p-value = " r(p)

  }	
estout ols* iv* using  "tab/TableB6_`i'.txt", keep(skratio_*) stats( r2 rmse N , fmt(%9.3f %9.3f %9.0gc)) cells(b(fmt(%9.3f) star) se(par fmt(%9.3f)) ) starlevels (* 0.10 ** 0.05 *** 0.01 ) style(tex) replace  notype mlabels(, numbers )
}  

 
***************************
* Table 5: structural estimates
***************************

  
estimates clear

use temp/regdata_estruct_full.dta, clear


global dumkl_indyr1 " dumkl_areadumcent1_*  dumkl_areadum_* dumkl_yrdum* dumkl_dcentury1 dumkl_inddum_* dumkl_itdum_*"
global dumkl_area1  " dumkl_areadumcent1_*  dumkl_areadum_* dumkl_yrdum* dumkl_dcentury1 dumkl_inddum_*" 
global dumkl_noind1 " dumkl_areadumcent1_*  dumkl_areadum_* dumkl_yrdum* dumkl_dcentury1"

global dumkl_indyr2 " dumkl_areadumcent2_*  dumkl_areadum_* dumkl_yrdum* dumkl_dcentury2 dumkl_inddum_* dumkl_itdum_*"
global dumkl_area2  " dumkl_areadumcent2_*  dumkl_areadum_* dumkl_yrdum* dumkl_dcentury2 dumkl_inddum_*" 
global dumkl_noind2 " dumkl_areadumcent2_*  dumkl_areadum_* dumkl_yrdum* dumkl_dcentury2"

  

 *Label
foreach x in noind area indyr{
foreach i in 1 2{
label variable skratiohatz_`x'`i'_dearly`i' "$ \kappa$ *Early"
label variable skratiohatz_`x'`i'_dlate`i' "$ \kappa$ *Late"
}
} 

 *Label
foreach i in 1 2{
label variable skratiohat_dearly`i' "$ \kappa$ *Early"
label variable skratiohat_dlate`i' "$ \kappa$ *Late"
}
  

/*Run Tables*/
local Fuelsamp "(capsamp|Fuelsamp) & xzsamp "
local Hpimputesamp  "(capsamp|Hpimputesamp) & xzsamp "
local kimputesamp "(capsamp|Horsesamp) & xzsamp"




/*estimates clear
foreach out in kimpute  {
di "Running  regression for ln`out'1 noind"
qui ivreg2 ln`out'_hat_1 (skratiohat_dearly1 skratiohat_dlate1 = skratiohatz_noind1_dearly1 skratiohatz_noind1_dlate1)   areadum_*  yrdum* dcentury1 areadumcent1_* dumkl $dumkl_noind1  if ``out'samp',  cluster(area) savefirst  savefp(fsnoind)
estimates store noind_`out'
qui test (skratiohat_dearly1=skratiohat_dlate1) 
di "ln`out'_1 noind,  Chi-stat: " r(chi2) ", p-value = " r(p)	

di "Running  regression for ln`out'1 indum"
qui ivreg2 ln`out'_hat_1 (skratiohat_dearly1 skratiohat_dlate1 = skratiohatz_area1_dearly1 skratiohatz_area1_dlate1) inddum_*  areadum_*  yrdum* dcentury1 areadumcent1_* dumkl $dumkl_area1  if ``out'samp' ,  cluster(area) savefirst  savefp(fsind)
estimates store area_`out'
qui test (skratiohat_dearly1=skratiohat_dlate1) 
di "ln`out'_1 ind,  Chi-stat: " r(chi2) ", p-value = " r(p)	


di "Running  regression for ln`out'1 indyear"
qui ivreg2 ln`out'_hat_1 (skratiohat_dearly1 skratiohat_dlate1 = skratiohatz_indyr1_dearly1 skratiohatz_indyr1_dlate1) itdum_*  areadum_*  yrdum* dcentury1 areadumcent1_* dumkl $dumkl_indyr1  if ``out'samp',  cluster(area) savefirst  savefp(fsindyr)
estimates store indyr_`out'
qui test (skratiohat_dearly1=skratiohat_dlate1) 
di "ln`out'_1 indyr,  Chi-stat: " r(chi2) ", p-value = " r(p)	

estout noind* area* indyr* using  "tab/Table5_1.txt", label keep(skratio*) cells(b(fmt(%9.3f) star) se(par fmt(%9.3f)) ) starlevels (* 0.10 ** 0.05 *** 0.01 ) style(tex) replace  notype mlabels(, numbers )
}


estimates clear
foreach out in kimpute Fuel Hpimpute {
di "Running  regression for ln`out'2 noind"
qui ivreg2 ln`out'_hat_2 (skratiohat_dearly2 skratiohat_dlate2 = skratiohatz_noind2_dearly2 skratiohatz_noind2_dlate2)   areadum_*  yrdum* dcentury2 areadumcent2_* dumkl $dumkl_noind2  if ``out'samp',  cluster(area) savefirst  savefp(fsnoind_`out')
estimates store noind_`out'
qui test (skratiohat_dearly2=skratiohat_dlate2) 
di "ln`out'_2 noind,  Chi-stat: " r(chi2) ", p-value = " r(p)	

di "Running  regression for ln`out'2 inddum"
qui ivreg2 ln`out'_hat_2 (skratiohat_dearly2 skratiohat_dlate2 = skratiohatz_area2_dearly2 skratiohatz_area2_dlate2) inddum_*  areadum_*  yrdum* dcentury2 areadumcent2_* dumkl $dumkl_area2  if ``out'samp' ,  cluster(area) savefirst  savefp(fsind_`out')
estimates store area_`out'
qui test (skratiohat_dearly2=skratiohat_dlate2) 
di "ln`out'_2 ind,  Chi-stat: " r(chi2) ", p-value = " r(p)	

di "Running  regression for ln`out'2 indyear"
qui ivreg2 ln`out'_hat_2 (skratiohat_dearly2 skratiohat_dlate2 = skratiohatz_indyr2_dearly2 skratiohatz_indyr2_dlate2) itdum_*  areadum_*  yrdum* dcentury2 areadumcent2_* dumkl $dumkl_indyr2  if ``out'samp',  cluster(area) savefirst  savefp(fsindyr_`out')
estimates store indyr_`out'
qui test (skratiohat_dearly2=skratiohat_dlate2) 
di "ln`out'_2 indyr,  Chi-stat: " r(chi2) ", p-value = " r(p)	

}

estout *kimpute *Fuel *Hpimpute using  "tab/Table5_2.txt", label keep(skratio*) cells(b(fmt(%9.3f) star) se(par fmt(%9.3f)) ) starlevels (* 0.10 ** 0.05 *** 0.01 ) style(tex) replace  notype mlabels(, numbers )
*/
******************************************************
* Table B.7 Structural estimates for new immigrants
******************************************************

local Fuelsamp "(capsamp|Fuelsamp) & xzsamp "
local Hpimputesamp  "(capsamp|Hpimputesamp) & xzsamp "
local kimputesamp "(capsamp|Horsesamp) & xzsamp"


/*
foreach out in kimpute  {
estimates clear
di "Running  regression for ln`out'1 noind"
qui ivreg2 ln`out'_hat_1 (skratiohat_dearly1 skratiohat_dlate1 skhat_dearly1_newimm skhat_dlate1_newimm  = skratiohatz_noind1_dearly1  skratiohatz_noind1_dlate1 skhatz_noind1_dearly1_newimm skhatz_noind1_dlate1_newimm)  newimm1880 areadum_*  yrdum*  areadumcent1_* dumkl $dumkl_noind1  if ``out'samp',  cluster(area) 
estimates store noind_`out'

di "Running  regression for ln`out'1 inddum"
qui ivreg2 ln`out'_hat_1 (skratiohat_dearly1 skratiohat_dlate1 skhat_dearly1_newimm skhat_dlate1_newimm = skratiohatz_area1_dearly1 skratiohatz_area1_dlate1 skhatz_area1_dearly1_newimm  skhatz_area1_dlate1_newimm)  newimm1880 inddum_*  areadum_*  yrdum*  areadumcent1_* dumkl $dumkl_area1  if ``out'samp' ,  cluster(area) 
estimates store area_`out'

di "Running  regression for ln`out'1 indyear"
qui ivreg2 ln`out'_hat_1 (skratiohat_dearly1 skratiohat_dlate1 skhat_dearly1_newimm  skhat_dlate1_newimm  = skratiohatz_indyr1_dearly1 skratiohatz_indyr1_dlate1 skhatz_indyr1_dearly1_newimm skhatz_indyr1_dlate1_newimm)  newimm1880 itdum_*  areadum_*  yrdum*  areadumcent1_* dumkl $dumkl_indyr1 if ``out'samp',  cluster(area) 
estimates store indyr_`out'

estout noind* area* indyr* using  "tab/TableB7_1.txt", keep(sk*) cells(b(fmt(%9.3f) star) se(par fmt(%9.3f)) ) starlevels (* 0.10 ** 0.05 *** 0.01 ) style(tex) replace  notype mlabels(, numbers )
}

*/

local Fuelsamp "(capsamp|Fuelsamp) & xzsamp "
local Hpimputesamp  "(capsamp|Hpimputesamp) & xzsamp "
local kimputesamp "(capsamp|Horsesamp) & xzsamp"


estimates clear
foreach out in  kimpute Fuel Hpimpute {
di "Running  regression for ln`out'2 noind"
qui ivreg2 ln`out'_hat_2 (skratiohat_dearly2 skratiohat_dlate2 skhat_dearly2_newimm skhat_dlate2_newimm  = skratiohatz_noind2_dearly2  skratiohatz_noind2_dlate2 skhatz_noind2_dearly2_newimm skhatz_noind2_dlate2_newimm)   areadum_*  yrdum* dcentury2 areadumcent2_* dumkl $dumkl_noind2 [aw=weight] if ``out'samp',  cluster(area) 
estimates store noind_`out'

di "Running  regression for ln`out'2 inddum"
qui ivreg2 ln`out'_hat_2 (skratiohat_dearly2 skratiohat_dlate2 skhat_dearly2_newimm skhat_dlate2_newimm = skratiohatz_area2_dearly2 skratiohatz_area2_dlate2 skhatz_area2_dearly2_newimm  skhatz_area2_dlate2_newimm) inddum_*  areadum_*  yrdum* dcentury2 areadumcent2_* dumkl $dumkl_area2 [aw=weight] if ``out'samp' ,  cluster(area) 
estimates store area_`out'

di "Running  regression for ln`out'2 indyear"
qui ivreg2 ln`out'_hat_2 (skratiohat_dearly2 skratiohat_dlate2 skhat_dearly2_newimm  skhat_dlate2_newimm  = skratiohatz_indyr2_dearly2 skratiohatz_indyr2_dlate2 skhatz_indyr2_dearly2_newimm skhatz_indyr2_dlate2_newimm) itdum_*  areadum_*  yrdum* dcentury2 areadumcent2_* dumkl $dumkl_indyr2 [aw=weight] if ``out'samp',  cluster(area) 
estimates store indyr_`out'
}  

estout *kimpute *Fuel *Hpimpute using  "tab/TableB7_2.txt", keep(sk*) cells(b(fmt(%9.3f) star) se(par fmt(%9.3f)) ) starlevels (* 0.10 ** 0.05 *** 0.01 ) style(tex) replace  notype mlabels(, numbers )
  
log close

********************
*Tables 6 and A.2***
********************

*These tables are obtained from the Excel commands in the file SimulationTables-MayUpdate.xls which requires as an input the following information:

use src/usa_00173.dta
   
* need 1880 data with literacy
drop if year==1880
append using src/cens1880.dta

* also, skip 1940 for now
drop if year==1940
   
* literacy among age 15+
keep if age>=15
gen byte ill=lit<4
rename lit literacy
gen byte lit=1-ill

* by nativity
gen byte imm = bpld>=15000 if bpld~=.
gen byte nat = 1-imm
gen illimm = ill if imm==1
gen litimm = lit if imm==1
gen illnat = ill if nat==1
gen litnat = lit if nat==1

* pre-post 1897 immms (the year that literacy test was first proposed)
gen byte pre1897 = yrimmig<1897 if yrimmig~=. & imm==1 & yrimmig~=0 & year>=1900
gen byte post1897 = yrimmig>=1897 if yrimmig~=. & imm==1  & yrimmig~=0 & year>=1900
foreach per in pre post {
  gen ill`per' = ill if `per'1897==1
  gen lit`per' = lit if `per'1897==1
}

* While I'm at it, divide some later years into artisans and laborers, to match Goldin's regressions
gen manfconstr = (ind1950>=246 & ind1950<=499)
gen byte goldinH = (occ1950==501|occ1950==503|occ1950==504|occ1950==505|occ1950==510|occ1950==512|occ1950==544|occ1950==564|occ1950==570|occ1950==573|occ1950==574|occ1950==575) if manfconstr
gen byte goldinL=(occ1950==970)  if manfconstr

* immigrants who arrived in the 1890s
gen byte arr1890s=imm & yrimmig>1899 & year==1900

* get share low skill:
* (1) among goldin's set of workers, by nativity
sum goldinL if year==1900 & (goldinH|goldinL) [iw=perwt]
sum goldinL if nat & year==1900 & (goldinH|goldinL) [iw=perwt]
sum goldinL if imm & year==1900 & (goldinH|goldinL) [iw=perwt]
sum goldinL if (goldinH|goldinL) & arr1890s [iw=perwt]

* (2) among all consruction and manufacturing workers, by nativity
sum goldinL if year==1900 & manfconstr [iw=perwt]
sum goldinL if nat & year==1900 & manfconstr [iw=perwt]
sum goldinL if imm & year==1900 & manfconstr [iw=perwt]
sum goldinL if manfconstr & arr1890s [iw=perwt]

* get share literate among goldin workers
sum lit if goldinH & year==1900 [iw=perwt]
sum lit if goldinL & year==1900 [iw=perwt]

* count up by year
collapse (sum) ill lit illimm litimm illnat litnat illpre litpre illpost litpost [iw=perwt], by(year)
list
export excel using temp/ill_by_natyr, replace firstrow(var)
