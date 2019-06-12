/***********************************
Regressions Aggregate  using H+L
& zratio_smith as an instrument for H/L
********************************/

clear
cap clear matrix
set more off, permanently

* folder paths:
* History base folder path
global hist "/home/jfuenzalida/HistManf_JL" /*Server*/

* program folder:
global log "$hist/log"

* data folder (where the 1890 spreadsheet is located)
global dta "$hist/dta"

*src folder
global src "$hist/src"

* temp folder
global temp "$hist/dta/temp"

* tab folder
global tab "$hist/tab/full"


cap log close
log using "$log/regressions-agg-pred.log", replace
clear
set more off


use "$dta/industries_final2", clear

collapse (sum) Numberofestablishments-Valueaddedbymanufacture officers-wageearners_av_under16 RentedK-Electricmotors, by(city countyid_new statea state year)
rename countyid_new area
sort area statea year
merge m:1 area  year using "$dta/endogenouscty4_full" /* "/Users/administrador/Dropbox/endogenouscty3"*/
drop if _merge==2
drop _merge

merge m:1 area year using "$src/r2lit-county.dta"
drop if _merge==2
drop _merge



* New denominator
gen totalworkers=wageearners_av_total+officers /*L+H*/
replace totalworkers= wageearners_av_total if year<1890
drop wageearners_av_total
rename totalworkers wageearners_av_total

* Correction for Outcome Y 
*gen Valueadded=Valueofproducts-Valueofmaterials
gen Valueadded=Valueaddedbymanufacture

* sample-defining variables
gen capsamp=(Capital~=. & wageearners_av_total~=. & Valueadded~=. & Capital~=0 & wageearners_av_total~=0 & Valueadded~=0)
gen Horsesamp = (Primary~=. & Valueadded~=. & Primary~=0 & Valueadded~=0)
gen xzsamp=(skratio_lit~=. & zratio_smith_lit~=.)


* outcome variables used below
cap program drop outcomes
program define outcomes

  gen lnkl=ln(Capital/wageearners_av_total) if capsamp & xzsamp
  replace lnkl=ln(Capital/wageearners_av_total) if Valueadded==0 & xzsamp /*Just one case in 1910, area: 4200490*/
  replace lnkl=ln(10/wageearners_av_total) if Capital==0 & wageearners_av_total~=0 & year<1930
  replace lnkl=ln(Capital/0.1) if Capital~=0 & wageearners_av_total==0
  replace lnkl=ln(0.1) if Capital==0 & wageearners_av_total==0 & year<1930
    
  
  gen lnyl=ln(Valueadded/wageearners_av_total) if xzsamp /* note changed from & capsamp, now that we are imputing capital */
  replace lnyl=ln(150/wageearners_av_total) if Valueadded==0 & wageearners_av_total~=0
  replace lnyl=ln(Valueadded/0.1) if Valueadded~=0 & wageearners_av_total==0
  replace lnyl=ln(0.7) if Valueadded==0 & wageearners_av_total==0
  
  gen lnky=ln(Capital/Valueadded) if capsamp & xzsamp
  replace lnky=ln(10/Valueadded) if Capital==0 & Valueadded~=0 & year<1930
  replace lnky=ln(Capital/150) if Capital~=0 & Valueadded==0
  replace lnky=ln(0.00004) if Capital==0 & Valueadded==0 & year<1930
  
  gen lnestl=ln(Numberofestablishments/wageearners_av_total) if xzsamp
  replace lnestl=ln(0.3/wageearners_av_total) if Numberofestablishments==0 & wageearners_av_total~=0
  replace lnestl=ln(Numberofestablishments/0.1) if Numberofestablishments~=0 & wageearners_av_total==0
  replace lnestl=ln(0.00004) if Numberofestablishments==0 & wageearners_av_total==0
  gen lnlest=-lnestl
  
  gen lnwagebill=ln(expenses_wageearners/wageearners_av_total) if xzsamp
  replace lnwagebill=ln(7/wageearners_av_total) if expenses_wageearners==0 & wageearners_av_total~=0
  replace lnwagebill=ln(expenses_wageearners/0.1) if expenses_wageearners~=0 & wageearners_av_total==0
  replace lnwagebill=ln(0.15) if expenses_wageearners==0 & wageearners_av_total==0
  
  gen lnHpY = ln(Primary/Valueadded) if xzsamp & Horsesamp

  gen lnmy=ln(Valueofmaterials/Valueadded) if xzsamp
  gen lnml=ln(Valueofmaterials/wageearners_av_total) if xzsamp

  
  gen lnHp = ln(Primary) if xzsamp & Horsesamp
  gen lnk = ln(Capital) if xzsamp & capsamp 

	rename ar2lit_natmal lnar2lit_natmal
	rename r2lit_natmal lnr2lit_natmal
	rename r2lit_nat lnr2lit_nat
	rename r2lit_imm lnr2lit_imm
	  
end

outcomes

gen lnkhat=lnk
replace lnkhat=.77833108*lnHp if lnk==.
gen lnkyimpute = lnkhat - ln(Valueadded) if xzsamp
  replace lnkyimpute = lnky if lnky~=.
gen lnklimpute = lnkhat - ln(wageearners_av_total) if xzsamp
  replace lnklimpute = lnkl if lnkl~=.

replace personsinindustry_total=wageearners_av_total if year<1890
gen lnltot=ln(personsinindustry_total)

gen lnwageratio=ln(expenses_officials/officers)-lnwagebill if year>=1890
replace lnwageratio=ln(0.3)-lnwagebill if expenses_officials==0 & officers==0 & year>=1890


* construct endless fixed effects
qui tab area, gen(areadum_)


* Everything by "century":
local break 1890
local early "year<`break'"
local late "year>=`break'"
gen dearly1=(year<1890)
gen dlate1=(year>=1890)
gen dearly2=(year<1900)
gen dlate2=(year>=1900)

 
* dummy by century
gen dcentury1=(year>=1890)
gen dcentury2=(year>1890)

 
forvalues i=1(1)180 {
gen areadumcent1_`i'=areadum_`i'*dcentury1
gen areadumcent2_`i'=areadum_`i'*dcentury2
}


foreach i of varlist dearly1 dlate1 dearly2 dlate2{
gen skratio_`i'=skratio_lit*`i'
gen  zratio_smith_`i'=zratio_smith_lit*`i'
}



* first stage (instrument:zratio_smith_lit) 
reg skratio_lit zratio_smith_lit yrdum* areadum_* areadumcent2_* if  lnkyimpute~=.  , cluster(area)
predict skratio_agg
test zratio_smith_lit

 * also: get predicted skill ratio, net of fixed effects, to create scatter plots
  qui predict temp if lnkyimpute~=.
  qui reg temp yrdum* areadum_* areadumcent2_* dcentury2 if  lnkyimpute~=. 
  predict Xhat, resid
  drop temp
  


forvalues i=1(1)2{
qui reg skratio_lit zratio_smith_lit yrdum* areadum_* areadumcent`i'_*  if  lnkyimpute~=.  , cluster(area)
predict skratio_agg`i'
test zratio_smith_lit 
estimates store all`i'
}
estimates clear


* Predicted Instruments
foreach x in skratio_agg skratio_agg1 skratio_agg2 {
gen `x'_dearly1=`x'*dearly1
gen `x'_dlate1=`x'*dlate1
gen `x'_dearly2=`x'*dearly2
gen `x'_dlate2=`x'*dlate2
}

save "$temp/regdata_finaltables_agg_full.dta",  replace
capture log close 
