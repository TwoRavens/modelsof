capture log close
log using r&d_bowker.log , replace

*******************************
** Full (interpolated) panel **
*******************************
use bowker.dta, clear
* unique newid  // total record : 93,598  company: 14,988

** consolidate branches in same state **
collapse (sum) prof tech  , by(newid cmpy state year) 

drop if prof + tech == 0   // missing data

***generate the multi-state indicator ***
bysort newid (state) : gen byte multist = 1 ///
   if state[_n] != state[_n-1] & prof > 0 & prof[_n-1] > 0 & _n!= 1
bysort newid (multist) : replace multist = multist[_n-1] ///   
   if mi(multist) & !mi(multist[_n-1])
replace multist = 0 if mi(multist)   
label variable multist "Multi-state R&D professionals"

** company-state identifier **
gen newidst = newid*100 + state
label variable newidst "Company-state ID" 

xtset newidst year
tsfill

replace newid = int(newidst/100) if mi(newid)
foreach var in state multist {
   by newidst : ipolate `var' year , gen(i`var')
   drop `var'
   rename i`var' `var'
   replace `var' = . if `var' != int(`var')  // replace wrongly coded
   label variable `var' "`var' (interpolated)"
   }

foreach var in prof tech {
   by newidst : ipolate `var' year , gen(i`var')
   drop `var'
   rename i`var' `var'
   label variable `var' "`var' (interpolated)"
   }
   
** utsa index   **
merge m:1 state year using utsan.dta
drop if _m == 2
drop _m
   
***state characteristics *****
merge m:1 state year using macro.dta
drop if _m == 2
drop _m patents rnd_nominal rnd_nom_ipolate 

***tax credit ****
merge m:1 state year using R&Dcred.dta 
drop if _m ==2 
drop _m 

**To match with Compustat **
***************
merge m:1 newid using match_bowker_cpstat.dta 
drop if score < 0.99
keep if strpos(cmpy, Ucmpy) > 0 | strpos(Ucmpy, cmpy) > 0 
drop _m

***match with the compustat dataset, users need to download the data from WRDS***
***Or you can skip this step and directly go to the data preparation part ***
sort gvkey year
merge m:1 gvkey year using compustat.dta 
keep if _m == 3
drop _m conm 
** unique gvkey  /// record 22,331 company: 1697 
compress 
save bowker_cpstat_wrkg.dta,replace  

************************************
*****More on data preparation ******
************************************

use bowker_cpstat_wrkg.dta,replace
 
** U.S. deflators **
merge m:1 year using USdeflator.dta 
keep if _m == 3
drop _m
replace gdp_defltr = gdp_defltr/100
replace gpdi_defltr = gpdi_defltr/100

***state macros ***
gen mfgdp_ln = ln(mfgdp_gross/gdp_defltr)
gen gdp_ln = ln(gdp_gross/gdp_defltr)
gen popn_ln = ln(popn)
label variable gdp_ln "Real GDP (ln)"
label variable mfgdp_ln "Real manuf value added (ln)"
label variable popn_ln "Population (ln)"

** industry characteristics **
forvalues i = 2/3 {
   gen sic`i' = substr(sic, 1, `i')
   destring sic`i' , replace
   }
   
destring(sic) , replace
gen int sic4 = sic 
run hitech.do

** importance of secrecy -- Cohen et al. (2000) **
sort sic3 
merge m:1 sic3 using sic3_isic.dta
drop if _m == 2 
drop _m

**correction for the mapping using sic4 **
replace ISIC = 3230 if sic4 == 3663
replace ISIC = 3211 if sic4 == 3674  

sort ISIC 
merge m:m ISIC using cohen.dta 
drop _m 

** company-state measures **   
gen age = year - fyear
bysort gvkey year (state) : egen profttl = total(prof)
gen xrdst = xrd * prof/profttl 
gen xrdst_real = xrdst/gpdi_defltr  
gen xrdst_ln = ln(1 + xrdst/gpdi_defltr)  
label variable age "Age (since first year in Compustat)" 
label variable xrdst_real "R&D by state (real)"
label variable xrdst_ln "R&D by state (ln)"

** R&D conditional on pre-UTSA staff  
gen profst = prof/profttl if year == utsayr - 1
bysort gvkey state (profst) : replace profst = profst[_n-1] if !mi(profst[_n-1])
gen xrdstpre = xrd * profst 
gen profst0 = prof/profttl 
gen xrdstpre_real = xrd * profst/gpdi_defltr
gen xrdstpre_ln = ln(1 + xrd * profst/gpdi_defltr)   
label variable xrdstpre_real "R&D by state (real)"
label variable xrdstpre_ln "R&D by state (ln)"

gen prof_ln = ln(1 + prof)
gen profst_ln = ln(1 + prof/profttl)

gen revt_real = revt/gdp_defltr
gen revt_ln = ln(1 + revt/gdp_defltr) if  revt >= 0 
gen rdst_int = (xrdst/gpdi_defltr)/(revt/gdp_defltr)
gen mktbook000 = ((at + (csho*prcc_f) - (ceq+txdb)) / (ceq+txdb))/1000
gen ebitda_real = ebitda/gdp_defltr 
gen ebitda_ln = ln(1 + ebitda/gdp_defltr)
global sample (xrdst >= 0 & revt >= 0 & mktbook000 >= 0) 
label variable revt_real "Revenue (real)"
label variable revt_ln "Revenue (ln)"
label variable rdst_int "R&D intensity (company-state)"
label variable ebitda_real "EBITDA (real)"
label variable ebitda_ln "EBITDA (ln)"
label variable mktbook000 "Market-book value ('000)"

foreach var in utsan utsa   {
   su revt_real if $sample
   local revt_avg_ln = ln(1 + r(mean)) 
   gen `var'_revt = `var' * (revt_ln - `revt_avg_ln') 
   gen `var'_hitech1 = `var' * hitech1
   gen `var'_hitech2 = `var' * hitech2
   label variable `var'_revt "UTSA x revenue (ln)"
   label variable `var'_hitech1 "UTSA x hitech"
   label variable `var'_hitech2 "UTSA x hitech (def2)"
   }

 // states that enacted utsa after study period 
replace profst = prof/profttl if year == 1988 & (utsayr >= 1998 | mi(utsayr))  
bysort gvkey state (profst) : replace profst = profst[_n-1] ///
   if !mi(profst[_n-1])
replace xrdstpre_real = xrd * profst/gpdi_defltr
replace xrdstpre_ln = ln(1 + (xrd * profst)/gpdi_defltr)

gen double gvkeyst = gvkey * 100 + state   // "float" not sufficiently precise
compress
drop sic state_name
save bowker_cpstat.dta , replace 

**************
** Analysis **
**************

use bowker_cpstat.dta , clear

global method xtivreg2  
global depvar xrdstpre_ln   
global cntrvar revt_ln ebitda_ln mktbook000 
global utsavar utsan utsan_revt utsan_hitech1 
global sample (xrdst >= 0 & revt >= 0 & mktbook000 >= 0) 
global excldef (sic3 != 372 & sic3 != 376 & sic3 != 381)
global geog5 (state == 6 | state == 25 | state == 34 | state == 36 | state == 48)  
global options fe cluster(state gvkey)  
global outregopt landscape plain coljust(lc) varlabels se starloc(1) ///
	starlevels(10 5 1) summstat(r2 \N \ N_clust2 \N_g) ///
	summtitles("R2" \ "Observations" \"Companies" \ "Companies-states") ///
	addrows("Company-state f.e." , "Yes" \ "Year f.e." , "Yes")    
global outfile Table3

xtset gvkeyst year

xi: $method $depvar $cntrvar utsan i.year if $sample , $options
//singleton groups detected.  21 observation(s) not used  
outreg using $outfile , $outregopt replace  ///
   keep($cntrvar utsan ) ctitles("VARIABLES", "UTSA") ///
   note("Dependent variable: $depvar by company-state-year" \  ///
     "Robust standard errors clustered by state and company" )  ///
   title("Table 4. R&D expenditure (conditional on pre-UTSA professional staff)") 

gen byte smpl_all = 1 if e(sample)  
gen byte smpl_ed = 1 if e(sample) & $excldef
bysort gvkey (smpl_ed) : gen gvkey_flag = 1 if smpl_ed == 1 & _n == 1
bysort gvkey state (smpl_ed) : gen gvkeyst_flag = 1  if smpl_ed == 1 & _n == 1 
bysort state year (smpl_ed) : gen byte state_flag = 1 if _n == 1
label variable smpl_all "Sample - entire"
label variable smpl_ed "Sample - excl defense"
  
xi: $method  $depvar $cntrvar utsan utsan_revt i.year if $sample , ///
   $options
outreg using $outfile , $outregopt  merge ///
   keep($cntrvar utsan utsan_revt) ctitles("VARIABLES", "Revenue")  
   
xi: $method  $depvar $cntrvar utsan utsan_hitech1 i.year if $sample , ///
   $options
outreg using $outfile , $outregopt merge ///
   keep($cntrvar utsan utsan_hitech1) ctitles("VARIABLES", "High- technology")    

xi: $method  $depvar $cntrvar $utsavar i.year if $sample , $options
outreg using $outfile , $outregopt merge ///
   keep($cntrvar $utsavar) ctitles("VARIABLES", "Revenue & high-tech")   
   
xi: $method $depvar $cntrvar $utsavar i.year if $sample & $excldef ,$options
outreg using $outfile , $outregopt merge ///
   keep($cntrvar $utsavar) ctitles("VARIABLES", "Exclude defense")    

gen byte utsan367 = 0 
replace utsan367 = utsan if sic3 == 367 
label variable utsan367 "UTSA x eletronics" 

xi: $method  $depvar $cntrvar $utsavar utsan367 i.year if smpl_ed == 1 ///
   & (state == 6 | state == 36) , fe cluster(gvkey)  //too few states to cluster 
   
global outregopt landscape plain coljust(lc) varlabels se starloc(1) ///
	starlevels(10 5 1) summstat(N \r2 \ N_clust \N_g) ///
	summtitles("Observations" \ "R2" \"Companies" \ "Companies-states") ///
	addrows("Company-state f.e." , "Yes" \ "Year f.e." , "Yes") 
outreg using $outfile , $outregopt merge ///
   keep($cntrvar $utsavar utsan367) ctitles("VARIABLES", "CA, NY") 

xi: $method  $depvar $cntrvar $utsavar utsan367 i.year if smpl_ed == 1 ///
   & $geog5 , fe cluster(gvkey)  // too few states to cluster
outreg using $outfile , $outregopt merge ///
   keep($cntrvar $utsavar utsan367) ctitles("VARIABLES", "CA, MA, NJ, NY, TX")    
*****************************************
***Table 4: R&D: Expenditure and staff***
*****************************************
global outfile Table4
global outregopt landscape plain coljust(lc) varlabels se starloc(1) ///
	starlevels(10 5 1) summstat(r2 \N \ N_clust2 \N_g) ///
	summtitles("R2" \ "Observations" \"Companies" \ "Companies-states") ///
	addrows("Company-state f.e." , "Yes" \ "Year f.e." , "Yes")    

xi: $method $depvar $cntrvar $utsavar i.year if $sample & $excldef , $options
outreg using $outfile , $outregopt replace ///
   keep($cntrvar $utsavar) ctitles("VARIABLES", "Prefferrd")  ///
   title("Table 5. R&D: Expenditure and staff")  

xi: $method prof_ln $cntrvar $utsavar i.year if smpl_ed == 1 ,  $options
outreg using $outfile , $outregopt merge ///
   keep($cntrvar $utsavar) ///
   ctitles("VARIABLES", "Professional staff")    

xi: $method xrdst_ln $cntrvar $utsavar i.year if smpl_ed == 1  , $options
outreg using $outfile , $outregopt merge ///
   keep($cntrvar $utsavar) ///
   ctitles("VARIABLES", "R&D unconditional")    
   
**********************************************************************************
********* R& D conditional on pre-UTSA patents: please go to patent.do ***********
**********************************************************************************

******************************************************************
**** counterfactual analysis (sample excl defense contractors) ***
***** xrdstpre, prof, xrdst --------------------------Table 5 ****

foreach ind in 283 284 356 357 {
  summ revt_real if smpl_ed == 1 & sic3 == `ind'
  }
//column 1 of Table 5 

global method xtivreg2  
global cntrvar revt_ln ebitda_ln mktbook000 
global utsavar utsan utsan_revt utsan_hitech1 
global options fe cluster(state gvkey)  
global outfile Table6  //outfile contain the result for column (3)(4) (7)

xi: $method xrdstpre_ln $cntrvar $utsavar i.year if $sample & $excldef , $options  
global gvkeys = e(N_clust2)
global gvkeysts = e(N_g) 

summ revt_real if smpl_ed == 1
global revt_avg = ln(1 + r(mean))
summ utsan if smpl_ed == 1 
global utsan_avg = r(mean)   // 0.123

su prof if smpl_ed ==1 
global prof_avg = r(mean) 
su profttl if smpl_ed == 1
global profttl_avg = r(mean)  
su profst if smpl_ed == 1 
global profst_avg = r(mean) 
su xrdstpre_real if smpl_ed ==1 
global xrdstpre_ravg = r(mean)
su xrdst_real if smpl_ed == 1 
global xrdst_ravg = r(mean) 


foreach ind in 283 284 356 357 {
  summ revt_real if smpl_ed == 1 & sic3 == `ind'
  local revt_diff`ind' = ln(1 + r(mean)) - $revt_avg
  summ hitech1 if smpl_ed == 1 & sic3 == `ind'
  local ht`ind' = r(mean) 
  }
  
foreach ind in 283 284 356 357{  
 lincom $utsan_avg * utsan + $utsan_avg *`revt_diff`ind''*utsan_revt + $utsan_avg *`ht`ind''*utsan_hitech1 
 global es`ind' : di %05.3f r(estimate)*(1+1/$xrdstpre_ravg)
 global se`ind' : di %05.3f r(se)*(1+1/$xrdstpre_ravg)
 test $utsan_avg * utsan + $utsan_avg *`revt_diff`ind''*utsan_revt + $utsan_avg *`ht`ind''*utsan_hitech1 = 0
 global p`ind' : di %05.3f r(p) 
 global est`ind' = "${es`ind'}" 
 if ${p`ind'}<=0.1{
 global est`ind' = "${est`ind'}*" 
 }
 if ${p`ind'}<=0.05{
 global est`ind' = "${est`ind'}*" 
 }
 if ${p`ind'}<=0.01{
 global est`ind' = "${est`ind'}*" 
 }
 global right1`ind' =  ${coef`ind'} *  ${es`ind'}
 }

global outregopt1 landscape plain coljust(lc) varlabels se starlevels(10 5 1) ///
   starloc(1) addrows("Company-state f.e." , "Yes" \ "Year f.e." , "Yes" \ ///
   "Companies", $gvkeys \ "Companies-states", $gvkeysts \ ///
   "Drugs" , "$est283" \ "s.e.", "$se283" \ "p-value", "$p283" \ ///
   "Soaps and cleaners" ,"$est284" \ "s.e.", "$se284" \ "p-value", "$p284" \ ///
   "Industrial machinery" , "$est356" \ "s.e.", "$se356" \ "p-value", "$p356" \ ///
   "Computers and office eqpt" , "$est357" \ "s.e.", "$se357" \ "p-value", "$p357") 
outreg using $outfile , $outregopt1 replace  ///
   keep($utsavar ) ctitles("VARIABLES", "Conditional R&D") ///
   note("Dependent variable: $depvar by company-state-year" \  ///
     "Robust standard errors clustered by state and company" )  ///
   title("Table . Counterfactual analysis ($S_DATE)") 

**professional staff ****
xi: $method prof_ln $cntrvar $utsavar i.year if smpl_ed == 1 , $options  
global gvkeys = e(N_clust2)
global gvkeysts = e(N_g) 

foreach ind in 283 284 356 357 {
  summ revt_real if smpl_ed == 1 & sic3 == `ind'
  local revt_diff`ind' = ln(1 + r(mean)) - $revt_avg
  summ hitech1 if smpl_ed == 1 & sic3 == `ind'
  local ht`ind' = r(mean)
  }
  
foreach ind in 283 284 356 357{  
 lincom $utsan_avg*utsan + $utsan_avg *`revt_diff`ind''*utsan_revt + $utsan_avg *`ht`ind''*utsan_hitech1 
 global es`ind' : di  %05.3f r(estimate)*($prof_avg+1)/$prof_avg
 global se`ind' : di  %05.3f r(se)*($prof_avg+1)/$prof_avg  
 test $utsan_avg*utsan + $utsan_avg *`revt_diff`ind''*utsan_revt + $utsan_avg *`ht`ind''*utsan_hitech1  = 0
 global p`ind' : di  %05.3f r(p) 
 global est`ind' = "${es`ind'}" 
 if ${p`ind'}<=0.1{
 global est`ind' = "${est`ind'}*" 
 }
 if ${p`ind'}<=0.05{
 global est`ind' = "${est`ind'}*" 
 }
 if ${p`ind'}<=0.01{
 global est`ind' = "${est`ind'}*" 
 }
 global right2`ind' = ${es`ind'} *${coef`ind'}*(1-${coef1`ind'})
 }
 
global outregopt1 landscape plain coljust(lc) varlabels se starlevels(10 5 1) ///
   starloc(1) addrows("Company-state f.e." , "Yes" \ "Year f.e." , "Yes" \ ///
   "Companies", $gvkeys \ "Companies-states", $gvkeysts \ ///
   "Drugs" , "$est283" \ "s.e.", "$se283" \ "p-value", "$p283" \ ///
   "Soaps and cleaners" ,"$est284" \ "s.e.", "$se284" \ "p-value", "$p284" \ ///
   "Industrial machinery" , "$est356" \ "s.e.", "$se356" \ "p-value", "$p356" \ ///
   "Computers and office eqpt" , "$est357" \ "s.e.", "$se357" \ "p-value", "$p357") 
outreg using $outfile , $outregopt1 merge  ///
   keep($utsavar ) ctitles("VARIABLES", "Professional staff")

**unconditional *** 
xi: $method xrdst_ln $cntrvar $utsavar i.year if smpl_ed == 1 , $options  
global gvkeys = e(N_clust2)
global gvkeysts = e(N_g) 

foreach ind in 283 284 356 357 {
  summ revt_real if smpl_ed == 1 & sic3 == `ind'
  local revt_diff`ind' = ln(1 + r(mean)) - $revt_avg
  summ hitech1 if smpl_ed == 1 & sic3 == `ind'
  local ht`ind' = r(mean)
  }
  
foreach ind in 283 284 356 357{  
 lincom $utsan_avg*utsan + $utsan_avg *`revt_diff`ind''*utsan_revt + $utsan_avg *`ht`ind''*utsan_hitech1 
 global es`ind' : di  %05.3f r(estimate)*(1+1/$xrdst_ravg)
 global se`ind' : di  %05.3f r(se)*(1+1/$xrdst_ravg)
 test $utsan_avg*utsan + $utsan_avg *`revt_diff`ind''*utsan_revt + $utsan_avg *`ht`ind''*utsan_hitech1  = 0
 global p`ind' : di  %05.3f r(p) 
 global est`ind' = "${es`ind'}" 
 if ${p`ind'}<=0.1{
 global est`ind' = "${est`ind'}*" 
 }
 if ${p`ind'}<=0.05{
 global est`ind' = "${est`ind'}*" 
 }
 if ${p`ind'}<=0.01{
 global est`ind' = "${est`ind'}*" 
 }
 }
 
global outregopt1 landscape plain coljust(lc) varlabels se starlevels(10 5 1) ///
   starloc(1) addrows("Company-state f.e." , "Yes" \ "Year f.e." , "Yes" \ ///
   "Companies", $gvkeys \ "Companies-states", $gvkeysts \ ///
   "Drugs" , "$est283" \ "s.e.", "$se283" \ "p-value", "$p283" \ ///
   "Soaps and cleaners" ,"$est284" \ "s.e.", "$se284" \ "p-value", "$p284" \ ///
   "Industrial machinery" , "$est356" \ "s.e.", "$se356" \ "p-value", "$p356" \ ///
   "Computers and office eqpt" , "$est357" \ "s.e.", "$se357" \ "p-value", "$p357") 
outreg using $outfile , $outregopt1 merge  ///
   keep($utsavar ) ctitles("VARIABLES", "R&D (unconditional)")   

**calculate the weight of dicomposition [column (5) & (6)]****
foreach ind in 283 284 356 357 {
  global weight`ind' = ${right1`ind'}/(${right1`ind'}+${right2`ind'})
  display ${weight`ind'}  
  display 1-${weight`ind'} 
}

************************************* 
** Table 6£º Heterogeneous effects **
*************************************
global method xtivreg2 
global depvar xrdstpre_ln   
global cntrvar revt_ln ebitda_ln mktbook000 
global options fe cluster(state gvkey)  
global outfile Table6

xi: $method  $depvar $cntrvar $utsavar i.year if smpl_ed == 1 , $options 
outreg using $outfile , $outregopt replace  ///
   keep($cntrvar $utsavar) ctitles("VARIABLES", "Preferred") ///
   note("Dependent variable: $depvar by company-state-year" \  ///
     "Robust standard errors clustered by state and company" )  ///
   title("Table 7. $depvar: Heterogeneous Effects ($S_DATE)")  

**young and odl company ***
summ fyear if smpl_ed == 1 & gvkey_flag == 1 , d
global fyear_med = r(p50)  //r(p50) = 1963   16 companies 

xi: $method  $depvar $cntrvar $utsavar i.year ///
   if smpl_ed == 1 & fyear >= $fyear_med , $options 
outreg using $outfile , $outregopt merge  ///
   keep($cntrvar $utsavar) ctitles("VARIABLES", "Younger companies") 

xi: $method  $depvar $cntrvar $utsavar i.year ///
   if smpl_ed == 1 & fyear < $fyear_med , $options 
outreg using $outfile , $outregopt merge  ///
   keep($cntrvar $utsavar) ctitles("VARIABLES", "Older companies") 

summ revt_real hitech1 if smpl_ed == 1 & fyear < $fyear_med   
summ revt_real hitech1 if smpl_ed == 1 & fyear >= $fyear_med   

** single/multi state **
// set the multist to be those company have multi-state in the sample 
bysort gvkey state: gen flag =1 if _n ==1
bysort gvkey: egen ttlst = total(flag)
replace multist = 0 if ttlst == 1
replace multist = 1 if ttlst>1
drop flag ttlst 

xi: $method  $depvar $cntrvar $utsavar i.year ///
   if smpl_ed == 1 & multist == 0 , $options 
outreg using $outfile , $outregopt merge  ///
   keep($cntrvar $utsavar) ctitles("VARIABLES", "Single state") 

xi: $method  $depvar $cntrvar $utsavar i.year ///
   if smpl_ed == 1 & multist == 1 , $options 
outreg using $outfile , $outregopt merge  ///
   keep($cntrvar $utsavar) ctitles("VARIABLES", "Multi-state") 

** complex/discrete **
xi: $method  $depvar $cntrvar $utsavar i.year ///
   if smpl_ed == 1 & complex == 0 , $options 
outreg using $outfile , $outregopt merge  ///
   keep($cntrvar $utsavar) ctitles("VARIABLES", "Discrete product industries") ///

xi: $method  $depvar $cntrvar $utsavar i.year ///
   if smpl_ed == 1 & complex == 1 , $options 
outreg using $outfile , $outregopt merge  ///
   keep($cntrvar $utsavar) ctitles("VARIABLES", "Complex product industries") 
  
** cnc **   
merge m:1 state year using cnc.dta
drop if _m == 2
drop _m

summ cnc if smpl_ed == 1 & state_flag == 1 , d
global cnc_med = r(p50)

xi: $method  $depvar $cntrvar $utsavar i.year ///
   if smpl_ed == 1 & cnc < $cnc_med , $options 
outreg using $outfile , $outregopt merge  ///
   keep($cntrvar $utsavar) ctitles("VARIABLES", "Weak CNC") 

xi: $method  $depvar $cntrvar $utsavar i.year ///
   if smpl_ed == 1 & cnc >= $cnc_med , $options 
outreg using $outfile , $outregopt merge  ///
   keep($cntrvar $utsavar) ctitles("VARIABLES", "Strong CNC") 

******************************************
**** Table S2 & Figure S3 :Industries ****
******************************************
drop utsan367
foreach cat in 281 283 286 357 366 367 372 376 381 382 737 873 {
   gen utsan`cat' = 0
   replace utsan`cat' = utsan if sic3 == `cat'  // hitech industries
   } 
label variable utsan281 "Industrial inorganic chemicals"  
label variable utsan283 "Drugs"
label variable utsan286 "Industrial organic chemicals"
label variable utsan357 "Computer and office equipment"
label variable utsan366 "Communication equipment"
label variable utsan367 "Electronic components and accessories"
label variable utsan372 "Aircraft and parts"
label variable utsan376 "Guided missiles, space vehicles, parts"
label variable utsan381 "Search and navigation eqpt"
label variable utsan382 "Measuring and controlling devices"
label variable utsan737 "Computer and data processing services"
label variable utsan873 "Commercial research and test labs" 

global outfile Table_S2 
xi: $method  $depvar $cntrvar utsan utsan_revt utsan281-utsan873 ///
   i.year if $sample  , $options  
outreg using $outfile , $outregopt replace ///
   keep($cntrvar utsan utsan_revt utsan281-utsan372 utsan381-utsan737) /// 
   ctitles("VARIABLES", "Industries")    ///
   note("Dependent variable: $depvar by company-state-year" \  ///
     "Robust standard errors clustered by state and company" )  ///
   title("Table . Industries ($S_DATE)") 
   // utsan376 not identified; utsan873 dropped

** figure: high-tech industries **  
gen ht_estimate = . 
gen ht_min = . 
gen ht_max = . 
foreach cat in 281 283 286 357 366 367 372 381 382 737{
  lincom utsan`cat' 
  replace ht_est = r(estimate) if sic3 == `cat' 
  replace ht_min = r(estimate)-r(se)*1.96 if sic3 == `cat' 
  replace ht_max = r(estimate)+r(se)*1.96 if sic3 == `cat'  
}  

label variable ht_est "Coefficient"
label variable ht_est "95% upper limit"
label variable ht_est "95% lower limit"

gen hitech_ind = "" 
replace hitech_ind = "281. Industrial inorganic chemicals" if sic3==281
replace hitech_ind = "283. Drugs" if sic3==283
replace hitech_ind = "286. Industrial organic chemicals" if sic3==286
replace hitech_ind = "357. Computer and office equipment" if sic3==357
replace hitech_ind = "366. Communication equipment" if sic3==366
replace hitech_ind = "367. Electronic components and accessories" if sic3==367
replace hitech_ind = "372. Aircraft and parts" if sic3==372
replace hitech_ind = "381. Search and navigation equipment" if sic3==381
replace hitech_ind = "382. Measuring and controlling devices" if sic3==382
replace hitech_ind = "737. Computer and data processing services" if sic3==737

graph dot ht_est ht_min ht_max , over(hitech_ind) ///
   marker(1, m(O) mcolor(dknavy)) marker(2, m(Oh) mcolor(dknavy)) ///
   marker(3, m(Oh) mcolor(dknavy)) nolabel legend(off) yline(0)
qui graph export  Figure_S3.tif , replace 

**************************
** Table S3: robustness **
**************************
global outfile Table_S3a

xi: $method  $depvar $cntrvar $utsavar ///
   i.year if smpl_ed == 1 , $options 
outreg using $outfile , $outregopt replace  ///
   keep($cntrvar $utsavar) ctitles("VARIABLES", "Preferred") ///
   note("Dependent variable: $depvar by company-state-year" \  ///
     "Robust standard errors clustered by state and company" )  ///
   title("Table . $depvar: Robustness ($S_DATE)")  
   
xi: $method  $depvar $cntrvar utsa utsa_revt utsa_hitech1 i.year ///
   if smpl_ed == 1  , $options
outreg using $outfile , $outregopt merge ///
   keep($cntrvar utsa utsa_revt utsa_hitech1 ) ///
   ctitles("VARIABLES", "UTSA (binary)")  

xi: $method  $depvar $cntrvar $utsavar idxe6cl i.year ///
   if smpl_ed == 1 , $options
outreg using $outfile , $outregopt merge ///
   keep($cntrvar $utsavar idxe6cl) ctitles("VARIABLES", "Prior common law")
   
xi: $method  $depvar $cntrvar $utsavar taxcred i.year ///
   if smpl_ed == 1 , $options
outreg using $outfile , $outregopt merge ///
   keep($cntrvar $utsavar taxcred ) ctitles("VARIABLES", "R&D tax credit")

xi: $method  $depvar $cntrvar $utsavar taxcredrate i.year ///
   if smpl_ed == 1 , $options   
outreg using $outfile , $outregopt merge ///
   keep($cntrvar $utsavar taxcredrate ) ctitles("VARIABLES", "R&D tax credit")

bysort state: egen taxcred_flag = max(taxcred)

xi: $method  $depvar $cntrvar $utsavar  i.year ///
   if smpl_ed == 1 &taxcred_flag == 0  , $options
outreg using $outfile , $outregopt merge ///
   keep($cntrvar $utsavar ) ctitles("VARIABLES", "States without tax credit")

xi: $method  $depvar $cntrvar $utsavar ///
   i.year if smpl_ed == 1 & state != 6 , $options 
outreg using $outfile , $outregopt merge ///
   keep($cntrvar $utsavar) ctitles("VARIABLES", "Excl California") 
    
*** additional robustness ***
global outfile  Table_S3b

xi: $method  $depvar $cntrvar $utsavar i.year if smpl_ed == 1 , $options 
outreg using $outfile , $outregopt replace  ///
   keep($cntrvar $utsavar) ctitles("VARIABLES", "Preferred") ///
   note("Dependent variable: $depvar by company-state-year" \  ///
     "Robust standard errors clustered by state and company" )  ///
   title("Table . $depvar: Robustness ($S_DATE)")  

xi: $method  $depvar $cntrvar $utsavar  i.year ///
   if smpl_ed == 1 & score == 1 , $options
outreg using $outfile , $outregopt merge ///
   keep($cntrvar $utsavar ) ctitles("VARIABLES", "Exact match")  
 
xi: $method  $depvar $cntrvar $utsavar gdp_ln popn_ln i.year ///
   if smpl_ed == 1 , $options 
outreg using $outfile , $outregopt merge ///
   keep($cntrvar $utsavar gdp_ln popn_ln) ctitles("VARIABLES", "State macro")
   
** State trends **
forvalues i = 1/9 {
   gen trend0`i' = 0
   replace trend0`i' = year - 1975 if state == `i'
   }
   
forvalues i = 10/56 {
   gen trend`i' = 0
   replace trend`i' = year - 1975 if state == `i'
   }
   
drop trend03 trend07 trend14 trend43 trend52  

xi: $method  $depvar $cntrvar $utsavar  trend01-trend56 i.year ///
   if smpl_ed == 1 , $options
outreg using $outfile , $outregopt merge ///
   keep($cntrvar $utsavar) ctitles("VARIABLES", "State trends")   

xi: $method  $depvar $cntrvar $utsavar ///
   i.year if smpl_ed == 1 , fe cluster(state)
outreg using $outfile , $outregopt merge ///
   keep($cntrvar $utsavar) ctitles("VARIABLES", "Cluster by state") 

xi: $method  $depvar $cntrvar $utsavar ///
   i.year if smpl_ed == 1 , fe cluster(state sic3) 
global outregopt landscape plain coljust(lc) varlabels se starloc(1) ///
	starlevels(10 5 1) summstat(N \r2 \ N_clust2 \N_g) ///
	summtitles("Observations" \ "R2" \"Industries" \ "Companies-states") ///
	addrows("Company-state f.e." , "Yes" \ "Year f.e." , "Yes") 	
outreg using $outfile , $outregopt merge  ///
   keep($cntrvar $utsavar) ctitles("VARIABLES", "Cluster by state & industry")    
//number of companies should be same as the previous regression 
 
gen xsga_ln = ln(1 + (xsga * profst)/gpdi_defltr)  
xi: $method xsga_ln $cntrvar $utsavar i.year if smpl_ed == 1 , $options
global outregopt landscape plain coljust(lc) varlabels se starloc(1) ///
	starlevels(10 5 1) summstat(N \r2 \ N_clust2 \N_g) ///
	summtitles("Observations" \ "R2" \"Companies" \ "Companies-states") ///
	addrows("Company-state f.e." , "Yes" \ "Year f.e." , "Yes") 
outreg using $outfile , $outregopt merge ///
   keep($cntrvar $utsavar) ctitles("VARIABLES", "Falsification: SG&A")

**********************************
*** Summary statistics Table 2 ***
**********************************
count if smpl_all == 1 // display number of obervations 

bysort gvkey (smpl_all): gen byte gvkeys = 1 if smpl_all == 1 & _n == 1 
count if gvkeys == 1 //display number of gvkeys

bysort gvkeyst (smpl_all): gen byte gvkeysts = 1 if smpl_all == 1 & _n == 1 
count if gvkeysts == 1 // display number of  of gvkeysts 

summ revt_real if smpl_ed == 1 , d
global revt_med = r(p50)   

format utsan %4.3f
format mktbook000 hitech1 %3.2g
format revt_real ebitda_real xrdstpre_real prof xrdst_real age %5.4g

summ utsan revt_real ebitda_real mktbook000 age hitech1 xrdstpre_real ///
   prof xrdst_real if smpl_all == 1 , format
summ utsan revt_real ebitda_real mktbook000 age hitech1 xrdstpre_real ///
   prof xrdst_real if smpl_ed == 1 , format

summ utsan revt_real ebitda_real mktbook000 age hitech1 xrdstpre_real ///
   prof xrdst_real if smpl_ed == 1 & revt_real < $revt_med , format
summ utsan revt_real ebitda_real mktbook000 age hitech1 xrdstpre_real ///
   prof xrdst_real if smpl_ed == 1 & revt_real >= $revt_med , format


*****************************
** Figures : Figure 2 & S2 **
*****************************

*** trend of raw R&D intensity: three versions ***
gen utsayr1 = utsayr   
gen utsayrdiff1 = year - utsayr1 
// ignore states with no utsayr

gen utsayr2 = utsayr
summ utsayr2 if smpl_ed == 1
replace utsayr2 = int(r(mean)) if (mi(utsayr2) | utsayr2 > 1998)
gen utsayrdiff2 = year - utsayr2  
// for states with utsayr > 1998, set to mean, 1989

gen large = 1 if smpl_ed == 1 & revt_real >= $revt_med
replace large = 0 if smpl_ed == 1 & revt_real < $revt_med

forvalues i = 1/2 {
  bysort utsayrdiff`i' smpl_ed : egen rdst_int_avg`i' = mean(rdst_int) 
  bysort large utsayrdiff`i' smpl_ed : egen rdst_int_avgc`i' = mean(rdst_int) 
  gen large_`i' = rdst_int_avgc`i' if large == 1 & smpl_ed == 1
  gen small_`i' = rdst_int_avgc`i' if large == 0 & smpl_ed == 1
  drop rdst_int_avgc`i' 
  label variable utsayrdiff`i' "Year relative to UTSA in effect" 
  label variable rdst_int_avg`i' "R&D intensity"
  label variable large_`i' "R&D intensity (large companies)"
  label variable small_`i' "R&D intensity (small companies)"
  }
    
forvalues i = 1/2{
  forvalues j = 5/7{  
    global figsam`i'_`j' ( utsayrdiff`i' >= -`j' & utsayrdiff`i' <= `j' ) 
    }
  }

twoway(scatter rdst_int_avg1 utsayrdiff1 if $figsam1_5 & smpl_ed == 1,msymbol(c))  ///
(scatter rdst_int_avg2 utsayrdiff2 if $figsam2_5 & smpl_ed == 1,msymbol(t)), ///
legend(label(1 "Only UTSA states") label(2 "All states")) 
qui graph export  Figure2.tif, replace 

twoway (scatter large_1 small_1 utsayrdiff1 if $figsam1_7 , msymbol(c t)) 
qui graph export  S2a.tif , replace 

twoway (scatter large_2 small_2 utsayrdiff2 if $figsam2_7, msymbol(c t)) 
qui graph export  S2b.tif , replace 
   

************************************************** 
** Two-stage analysis: Effectiveness of secrecy **
**                Table S4 & S5                 **
**************************************************
use bowker_cpstat.dta , clear
 
** manufacturing industry **
foreach cat in 1500 1700 2100 2200 2320 2400 2411 2413 2423 2429 ///
  2500 2600 2610 2695 2700 2710 2800 2910 2920 2922 3010 3100 3110 ///
  3210 3211 3220 3230 3311 3312 3314 3410 3430 3530 3600{
    gen utsan`cat' = 0
    replace utsan`cat' = utsan if ISIC == `cat'  
  }
run isiclabel.do 

** analysis **
global method xtivreg2  
global depvar xrdstpre_ln   
global cntrvar revt_ln ebitda_ln mktbook000 
global sample (xrdst >= 0 & revt >= 0 & mktbook000 >= 0) 
global manuf (sic2 >= 20 & sic2 <= 39) 
global excldef (sic3 != 372 & sic3 != 376 & sic3 != 381)
global options fe cluster(state gvkey)  
global outfile Table_S4

xtset gvkeyst year

xi: $method $depvar $cntrvar utsan utsan_revt utsan1500-utsan3600 ///
  i.year if $sample & $excldef , $options  
local gvkeys = e(N_clust2)
local gvkeysts = e(N_g)  
global outregopt landscape plain coljust(lc) varlabels se starlevels(10 5 1) ///
   starloc(1) addrows("Company-state f.e." , "Yes" \ "Year f.e." , "Yes" \ ///
   "Companies", `gvkeys' \ "Companies-states", `gvkeysts') 
outreg using $outfile , $outregopt replace  ///
   keep($cntrvar utsan utsan_revt utsan1500-utsan3312 utsan3410 utsan3430 utsan3600 ) ///
   ctitles("VARIABLES", " ") ///
   note("Dependent variable: $depvar by company-state-year" \  ///
     "Robust standard errors clustered by state and company" )  ///
   title("Table . Effectiveness (1st stage) ($S_DATE)")    

gen isic_coef = . 
gen isic_se = . 
foreach cat in 1500 1700 2100 2200 2320 2400 2411 2413 2423 2429 ///
  2500 2600 2610 2695 2700 2710 2800 2910 2920 2922 3010 3100 3110 ///
  3210 3211 3220 3230 3311 3312 /* 3314 */ 3410 3430 /* 3530 */ 3600{
    lincom utsan`cat' 
    replace isic_coef = r(estimate) if ISIC == `cat' 
    replace isic_se = r(se) if ISIC ==`cat' 
  }
label variable isic_coef  "utsan_coef" 
  
replace pateff_prod = pateff_prod/100
replace secreff_prod = secreff_prod/100  
replace pateff_proc = pateff_proc /100 
replace secreff_proc = secreff_proc/100 
label variable pateff_prod "Patent effectiveness (product)"
label variable pateff_proc "Patent effectiveness (process)"
label variable secreff_prod "Secrecy effectiveness (product)"
label variable secreff_proc "Secrecy effectiveness (process)"
 
sort ISIC 
by ISIC : gen dup = cond(_N==1, 0, _n) 

 global depvar isic_coef
 global sample (dup <= 1 & !mi(isic_coef))
 global outregopt landscape plain coljust(lc) varlabels se ///
   starlevels(10 5 1) starloc(1) 
 global outfile Table_S5
   
 reg $depvar secreff_prod pateff_prod [aw=1/isic_se] if $sample , robust
 outreg using $outfile , $outregopt replace	///
   keep(_cons secreff_prod pateff_prod) ctitle("VARIABLES", "Products") ///
   note("Estimation by weighted least squares;" \  /// 
    "Weighted by reciprocal of standard error in R&D equation" ) ///
   title("Table . Effectiveness of appropriation (weighted least squares)") 

 reg $depvar secreff_proc pateff_proc [aw=1/isic_se] if $sample , robust
 outreg using $outfile , $outregopt merge	///
    keep(_cons secreff_proc pateff_proc) ctitle("VARIABLES", "Processes") 
	
 reg $depvar secreff_prod secreff_proc pateff_prod pateff_proc if $sample , robust 
 outreg using $outfile , $outregopt merge	///
  keep(_cons secreff_prod secreff_proc  pateff_prod pateff_proc) ///
  ctitle("VARIABLES", "All")

 log close 
