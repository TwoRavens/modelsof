capture log close
log using enact.log , replace

**************************
*** TSA/UTSA Enactment ***
**************************

use macro.dta , clear

merge 1:m state year using indy.dta
drop if _m == 2   // industry data for United States 
drop _m state_name 

***US deflator 
merge m:1 year using USdeflator.dta  
drop if _m == 2
drop _m 

*** TSA legislation ***
merge m:1 state using utsa.dta 
drop _m

replace utsayr = 1980 if state == 27   // MN (wrongly coded as 1981)

gen byte utsa = 0
replace utsa = 1 if year >= utsayr & !mi(utsayr)
replace utsa = 0 if state == 45 & year >= 1997  // SC 

*** neighboring states ***  
merge m:1 state using utsa_neighbr.dta
drop _m
drop n1_code n1 n2_code n2 n3_code n3 n4_code n4 n5_code n5 ///
   n6_code n6 n7_code n7 n8_code n8
 
forvalue k = 1/8 {        
   gen utsan`k' = . 
   }

forvalue i = 1/56 {
   forvalue k = 1/8 {        
     replace utsan`k' = 0 if year < utsan`k'yr & state == `i'
     replace utsan`k' = 1 if year >= utsan`k'yr & state == `i'
     }
   }

gen utsa_nbrs = utsan1 + utsan2 + utsan3 + utsan4 + utsan5 ///
   + utsan6 + utsan7 + utsan8
gen utsa_nbrs_pct = utsa_nbrs / neighbrs * 100
replace utsa_nbrs_pct = 0 if state == 2     // AL 
replace utsa_nbrs_pct = 0 if state == 15   // HI 

label variable utsa_nbrs "Neighbor UTSA states"
label variable utsa_nbrs_pct "Neighbor UTSA pct"

drop utsan1yr utsan2yr utsan3yr utsan4yr utsan5yr utsan6yr ///
   utsan7yr utsan8yr utsan1 utsan2 utsan3 utsan4 utsan5 ///
   utsan6 utsan7 utsan8
   
*** state politics ***
sort state year
merge 1:1 state year using leg_lower.dta
drop _m

merge 1:1 state year using leg_upper.dta
drop _m

gen lower_total = lower_d + lower_r + lower_o + lower_v
gen lower_r_pct = lower_r/lower_total
gen upper_total = upper_d + upper_r + upper_o /* + upper_v */
gen upper_r_pct = upper_r/upper_total


*** state legislature ***
sort state year
merge 1:1 state year using leg_activity.dta
drop _m

destring(cdays) , replace force   
destring(ldays) , replace force
   
xtset state year
** drop suspicious data -- no of bills too low **
replace bills = . if (state == 6 & (year == 1980 | year == 1982 | year == 1983))
replace bills = . if (state == 9 & year == 2002)
replace bills = . if (state == 28 & year == 1979)

** drop years for which data was combined across years **
replace bills = . if (state == 2 & year >= 1977 & year <=1978)
replace bills = . if (state == 5 & year >= 1975 & year <=1978)
replace bills = . if (state == 6 & year == 1979 )
replace bills = . if (state == 10 & year >= 1977 & year <=1980)
replace bills = . if (state == 17 & year >= 1975 & year <=1976)
replace bills = . if (state == 18 & year >= 1975 & year <=1976)
replace bills = . if (state == 25 & year >= 1977 & year <=1978)
replace bills = . if (state == 27 & year >= 1975 & year <=1976)
replace bills = . if (state == 33 & year >= 1977 & year <=1980)
replace bills = . if (state == 34 & year >= 1976 & year <=1979)
replace bills = . if (state == 36 & year >= 1979 & year <=1980)
replace bills = . if (state == 39 & year >= 1975 & year <=1976)
replace bills = . if (state == 44 & year == 1982)
replace bills = . if (state == 55 & year >= 1977 & year <=1984)

gen bills_mavg = (bills + L1.bills)/2 if (year >= 1976 & year <= 2008)
gen cdays_mavg = (cdays + L1.cdays)/2 ///
    if ( year >= 1976 & year <= 2008 & (ldays == 0 | missing(ldays) ) )
gen ldays_mavg = (ldays + L1.ldays)/2 ///
    if ( year >= 1976 & year <= 2008 & (cdays == 0 | missing(cdays) ) )

*** education ***
sort state year
merge 1:1 state year using edu.dta
drop _m

*** R&D tax credit ***
sort state year
merge m:1 state year using R&Dcred.dta
replace taxcredrate = 0 if mi(taxcredrate) & year < taxcredrate & year <=2006 
replace taxcred = 0 if mi(taxcred) & year < taxcred & year <=2006 
drop _m

*****************
*** variables ***
*****************

sort state year
gen popn_ln = ln(popn)
gen gdp_ln = ln(gdp_gross/gdp_defltr)
gen manuf_ln = ln(mfgdp_gross/gdp_defltr)
  
gen rnd_ln = ln(rnd_nom_ip/gpdi_defltr)
gen rnd_real = rnd_nom_ip / gpdi_defltr 
bysort state (year) : gen rnd_g ///
   = (rnd_real[_n] - rnd_real[_n-1])/rnd_real[_n-1] 

bysort state (year) : replace rnd_g ///
   = sqrt( (rnd_real[_n]/rnd_real[_n-2]) ) - 1 ///
   if (year >= 1979 & year <= 1997) // R&D missing for alternate years

** manufacturing value-added **
forvalues i = 20/36 {
   gen lnva`i' = ln(1 + va`i'/gdp_defltr)
   }

foreach i in 371 372 38 39 73 {
   gen lnva`i' = ln(1 + va`i'/gdp_defltr)
   }

label variable lnva20  "Food"
label variable lnva21  "Tobacco"
label variable lnva22  "Textile"
label variable lnva23  "Apparel"
label variable lnva24  "Lumber & wood"
label variable lnva25  "Furniture"
label variable lnva26  "Papers" 
label variable lnva27  "Publishing or printing" 
label variable lnva28  "Chemicals"
label variable lnva29  "Petroleum refining" 
label variable lnva30  "Rubber & plastic products"
label variable lnva31  "Leather & leather products" 
label variable lnva32  "Glass"
label variable lnva33  "Primary metal products"
label variable lnva34  "Fabricated metal products"
label variable lnva35  "Machinery & equip"
label variable lnva36  "Electronic & elec equipment"
label variable lnva371  "Motor vehicles"
label variable lnva372  "Other transport equipment"
label variable lnva38  "Instruments and related products"
label variable lnva39  "Miscellaneous manufacturing industries"
label variable lnva73  "Business services"   
   
gen patents_ln = ln(1 + patents)
bysort state (year) : ///
   gen patents_g = (patents[_n] - patents[_n-1])/patents[_n-1]

gen bills_ln = ln(bills_mavg)
gen cdays_ln = ln(1 + cdays_mavg)
gen ldays_ln = ln(1 + ldays_mavg)
gen edu_bach_ln = ln(edu_bach)
gen edu_mstr_ln = ln(edu_mstr)
gen edu_phd_ln = ln(edu_phd)

label variable taxcred "Tax credit"
label variable taxcredrate "Tax credit rate"
label variable lower_r_pct "Lower house repub"
label variable upper_r_pct "Upper house repub"
label variable bills_ln "Bills (ln)"
label variable cdays_ln "Days (ln)"
label variable ldays_ln "Legis days (ln)"
label variable edu_bach_ln "Bachelors (ln)"
label variable edu_mstr_ln "Masters (ln)"
label variable edu_phd_ln "PhDs (ln)"

label variable popn_ln "Popn (ln)"
label variable gdp_ln "GDP (ln)"
label variable rnd_ln "R&D (ln)"
label variable rnd_g "R&D growth"
label variable manuf_ln "Manufg (ln)"
label variable patents_ln "Patents (ln)"

compress
duplicates drop state year , force
xtset state year

*******************************
*********analysis *************
*******************************

stset year , id(state) failure(utsa)  

****Supplement Table S1 ****
** policy **    
global macro gdp_ln manuf_ln popn_ln lnva28 lnva35 lnva36 lnva372 lnva38 
   // high-tech industries (Dekker 1999)
global sample (year >= 1976 & year <=1997) 
global options vce(cluster state)
global outregopt landscape coljust(lc) varlabels se starlevels(10 5 1) ///
   starloc(1) plain 
global outfile TableS1a 

xi: stcox $macro if ( $sample ) , $options
local L : display %5.3f `e(ll)'
local X : display %5.3f `e(chi2)'
outreg using $outfile , $outregopt replace ///
   addrows("ln L" , "`L'" \ "Chi-squared" , "`X'") ///
   keep($macro) ctitles("VARIABLES", "Macro") ///
   title("Table 2 . UTSA Enactment ($S_DATE)") ///
   note("Method: Cox proportional hazard model; s.e. clustered by state") 

xi: stcox $macro rnd_ln if ( $sample ) , $options
local L : display %5.3f `e(ll)'
local X : display %5.3f `e(chi2)'
outreg using $outfile , $outregopt merge ///
   addrows("ln L" , "`L'" \ "Chi-squared" , "`X'") ///
   keep($macro rnd_ln) ctitles("VARIABLES", "R&D") 
   
xi: stcox $macro taxcred if ( $sample ) , $options
local L : display %5.3f `e(ll)'
local X : display %5.3f `e(chi2)'
outreg using $outfile , $outregopt merge ///
   addrows("ln L" , "`L'" \ "Chi-squared" , "`X'") ///
   keep($macro taxcred) ctitles("VARIABLES", "Tax credit") 

xi: stcox $macro taxcredrate if ( $sample ) , $options
local L : display %5.3f `e(ll)'
local X : display %5.3f `e(chi2)'
outreg using $outfile , $outregopt merge ///
   addrows("ln L" , "`L'" \ "Chi-squared" , "`X'") ///
   keep($macro taxcredrate) ctitles("VARIABLES", "R&D tax credit") 

xi: stcox $macro edu_mstr edu_phd if ( $sample ) , $options
local L : display %5.3f `e(ll)'
local X : display %5.3f `e(chi2)'
outreg using $outfile , $outregopt merge ///
   addrows("ln L" , "`L'" \ "Chi-squared" , "`X'") ///
   keep($macro edu_mstr edu_phd ) ctitles("VARIABLES", "Education") 


global outfile Table_S1b 

xi: stcox $macro ldays_ln if ( $sample ) , $options
local L : display %5.3f `e(ll)'
local X : display %5.3f `e(chi2)'
outreg using $outfile , $outregopt replace ///
   addrows("ln L" , "`L'" \ "Chi-squared" , "`X'") ///
   keep($macro ldays_ln) ctitles("VARIABLES", "Legislative days") ///
   title("Table S1.  UTSA Enactment ($S_DATE)") ///
   note("Method: Cox proportional hazard model; s.e. clustered by state") 
   
xi: stcox $macro cdays_ln if ( $sample ) , $options
local L : display %5.3f `e(ll)'
local X : display %5.3f `e(chi2)'
outreg using $outfile , $outregopt merge ///
   addrows("ln L" , "`L'" \ "Chi-squared" , "`X'") ///
   keep($macro cdays_ln) ctitles("VARIABLES", "Calendar days") 

xi: stcox $macro bills_ln  if ( $sample ) , $options
local L : display %5.3f `e(ll)'
local X : display %5.3f `e(chi2)'
outreg using $outfile , $outregopt merge ///
   addrows("ln L" , "`L'" \ "Chi-squared" , "`X'") ///
   keep($macro bills_ln  ) ctitles("VARIABLES", "Bills") 

xi: stcox $macro lower_r_pct upper_r_pct if ( $sample ) , $options
local L : display %5.3f `e(ll)'
local X : display %5.3f `e(chi2)'
outreg using $outfile , $outregopt merge ///
   addrows("ln L" , "`L'" \ "Chi-squared" , "`X'") ///
   keep($macro lower_r_pct upper_r_pct ) ctitles("VARIABLES", "Politics") 
   

xi: stcox $macro utsa_nbrs_pct if ($sample & state != 33) , $options
local L : display %5.3f `e(ll)'
local X : display %5.3f `e(chi2)'
outreg using $outfile , $outregopt merge ///
   addrows("ln L" , "`L'" \ "Chi-squared" , "`X'") ///
   keep($macro utsa_nbrs_pct) ctitles("VARIABLES", "Neighbors") 

 
**********************  
*******Figure S1 ******
********************** 
label variable utsa_lag "Legislation lag (years)"
label variable patents_g "Growth of patents"

global sample (year >= 1979 & year <= 1998)
global depvar rnd_g  //  rnd_g patents_g

sort state year
gen bill1yrid = 0
replace bill1yrid = 1 if bill1yr == year - 1
replace bill1yrid = 1 if bill1yr == year 
scatter utsa_lag $depvar if bill1yrid == 1 & $sample
graph export FigureS3.tif, replace 

regress utsa_lag $depvar if bill1yrid == 1,robust //check the relationship 
   
******************   
****Figure 2 *****
******************
use utsan , clear 
** R&D study: top 6 states **   
gen str st_figco = "."
replace st_figco = "1. California" if state == 6
replace st_figco = "2. New York" if state == 36
replace st_figco = "3. New Jersey" if state == 34
replace st_figco = "4. Massachusetts" if state == 25
replace st_figco = "5. Pennsylvania" if state == 42
replace st_figco = "6. Ohio" if state == 39
label variable st_figco "State"

gen utsan_idxe = utsan + idxe6cl
by state , sort : replace utsan_idxe = . if utsa == 0
by state , sort : replace idxe6cl = . if utsa == 1

label variable utsan_idxe "UTSA"

twoway (tsline idxe6cl , lwidth(medthick) lpattern(dash)) ///
   (tsline utsan_idxe , lwidth(medthick) lcolor(dknavy)) if ///
   ( state == 6 | state == 36 | state == 34 | ///
   state == 25 | state == 42 | state == 39) & year >= 1979 & year <= 1998 , ///
   by(st_figco , title(" ") note(" " ) ) 
graph export Figure2.tif, replace 

log close
   