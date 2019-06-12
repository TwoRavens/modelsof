***************************************************************
* final_data.do
* This do-file makes the final regressions' data 
*
*****************************************************************

clear
cap clear matrix
set more off, permanently
clear mata



cap log close
log using "$log/final_data.log", replace
clear
set more off


use "$dta/industries_final3_no0s"
sort area statea year

merge m:1 area year using "$dta/endogenouscty4_full"
drop if _merge==2
drop _merge

merge m:1 area year using "$src/r2lit-county.dta"
drop if _merge==2
drop _merge


* Variable corrections

* New denominator N=L+H
gen totalworkers=wageearners_av_total+officers /*L+H*/
replace totalworkers= wageearners_av_total if year<1890
gen wageworkers=wageearners_av_total
drop wageearners_av_total
rename totalworkers wageearners_av_total

* Correction for Outcome Y 
*gen Valueadded=Valueofproducts-Valueofmaterials
gen Valueadded=Valueaddedbymanufacture

* Correction for expenses for fuel & power
replace expenses_fuelandpower=expenses_fuel if year==1890 /* correction of the variable "fuel & power"*/

* construct endless fixed effects
gen indyear=industry_unified*10000+year
egen indarea=group(industry_unified area)
qui tab area, gen(areadum_)
qui tab industry_unified, gen(inddum_)
qui tab indyear, gen(itdum_)


* Impute Capital in 1900  by state regression (data in src/capital_1900.xls)
* Horsepower=0.004 Capital_mne
* Capital_mne= 224.4 Horsepower in 1900
gen Hpimpute=Primary
replace Hpimpute=0.004*Capital_mne if year<=1900 
replace Hpimpute=0.1 if year==1860 /*Data by industry K=0*/
replace expenses_fuelandpower=0.1 if year==1860 /*Data by industry K=0*/

* sample-defining variables (includes new definitions for K)
gen capsamp=(Capital~=. & wageearners_av_total~=. & Valueadded~=. & Capital~=0 & wageearners_av_total~=0 & Valueadded~=0 & Valueadded>0)
gen Horsesamp = (Primary~=. & Valueadded~=. & Primary~=0 & Valueadded~=0 & Valueadded>0)
gen Hpimputesamp = (Hpimpute~=. & Valueadded~=. & Hpimpute~=0 & Valueadded~=0 & Valueadded>0)
gen Rentsamp = (expenses_rent~=. & Valueadded~=. & Primary~=0 & Valueadded~=0 & Valueadded>0)
gen Fuelsamp = (expenses_fuelandpower~=. & Valueadded~=. & Primary~=0 & Valueadded~=0 & Valueadded>0)
gen xzsamp=(skratio_lit~=. & zratio_smith_lit~=.) /****/


*sample selection to drop cells with too few observations for the fixed effects to work
bysort indyear: egen small=count(area)
drop if small<=2

* industry count by area year for weights
egen indct = sum(xzsamp & wageearners_av_total~=.), by(area year)
gen weight=1/indct
drop indct



* ID areas that are available in multiple years - create balanced panel /* from analyze_sample.do, cant figure out how to do it  here */
merge m:1 area year using "$src/balpan-century.dta"

* outcome variables used below
cap program drop outcomes
program define outcomes

  gen lnkl=ln(Capital/wageearners_av_total) if capsamp & xzsamp
  replace lnkl=ln(10/wageearners_av_total) if Capital==0 & wageearners_av_total~=0 & year<1930
  replace lnkl=ln(Capital/0.1) if Capital~=0 & wageearners_av_total==0
  replace lnkl=ln(0.1) if Capital==0 & wageearners_av_total==0 & year<1930
  
  gen lnyl=ln(Valueadded/wageearners_av_total) if xzsamp /* note changed from & capsamp, now that we are imputing capital */
  replace lnyl=ln(150/wageearners_av_total) if Valueadded==0 & wageearners_av_total~=0
  replace lnyl=ln(Valueadded/0.1) if Valueadded~=0 & wageearners_av_total==0
  replace lnyl=ln(0.7) if Valueadded==0 & wageearners_av_total==0
  
  gen lnyla=ln(Valueofproducts/wageearners_av_total) if xzsamp /* note changed from & capsamp, now that we are imputing capital */
  replace lnyla=ln(150/wageearners_av_total) if Valueofproducts==0 & wageearners_av_total~=0
  replace lnyla=ln(Valueofproducts/0.1) if Valueofproducts~=0 & wageearners_av_total==0
  replace lnyla=ln(0.7) if Valueofproducts==0 & wageearners_av_total==0  
  
  gen lnky=ln(Capital/Valueadded) if capsamp & xzsamp
  replace lnky=ln(10/Valueadded) if Capital==0 & Valueadded~=0 & year<1930
  replace lnky=ln(Capital/150) if Capital~=0 & Valueadded==0
  replace lnky=ln(0.00004) if Capital==0 & Valueadded==0 & year<1930
  
  gen lnestl=ln(Numberofestablishments/wageearners_av_total) if xzsamp
  replace lnestl=ln(0.3/wageearners_av_total) if Numberofestablishments==0 & wageearners_av_total~=0
  replace lnestl=ln(Numberofestablishments/0.1) if Numberofestablishments~=0 & wageearners_av_total==0
  replace lnestl=ln(0.00004) if Numberofestablishments==0 & wageearners_av_total==0
  gen lnlest=-lnestl
  
  gen lnwagebill=ln(expenses_wageearners/wageworkers) if xzsamp
  replace lnwagebill=ln(7/wageearners_av_total) if expenses_wageearners==0 & wageworkers~=0
  replace lnwagebill=ln(expenses_wageearners/0.1) if expenses_wageearners~=0 & wageworkers==0
  replace lnwagebill=ln(0.15) if expenses_wageearners==0 & wageworkers==0
  
  gen lnHpY = ln(Primary/Valueadded) if xzsamp & Horsesamp
  gen lnHpYimpute=ln(Hpimpute/Valueadded) if xzsamp & Hpimputesamp
  gen lnHplimpute=ln(Hpimpute/wageearners_av_total) if xzsamp & Hpimputesamp
  gen lnRty = ln(expenses_rent/Valueadded) if xzsamp & Rentsamp
  gen lnFuy = ln(expenses_fuelandpower/Valueadded) if xzsamp & Fuelsamp
  gen lnFul = ln(expenses_fuelandpower/wageearners_av_total) if xzsamp & Fuelsamp
  
  gen lnwageratio=ln(expenses_officials/officers)-lnwagebill if year>=1890
  gen no_officers = expenses_officials==0 & officers==0 if year>=1890
  replace lnwageratio=ln(0.3)-lnwagebill if no_officers & year>=1890

  gen lnmy=ln(Valueofmaterials/Valueadded) if xzsamp
  gen lnml=ln(Valueofmaterials/wageearners_av_total) if xzsamp
  
********************************************************
* wage ratio using s_low & s_high from IPUMS year==1890
********************************************************
gen wageworkers_a= (officers*(1-0.9140965)+wageworkers*(1-0.8462651))
gen officers_a= (officers*(0.9140965)+wageworkers*(0.8462651))

  gen lnwagebill_a=ln((expenses_officials*(1-0.9140965)+expenses_wageearners*(1-0.8462651))/wageworkers_a) if xzsamp
  replace lnwagebill_a=ln(7/wageworkers) if (expenses_officials*(1-0.9140965)+expenses_wageearners*(1-0.8462651))==0 & wageworkers_a~=0
  replace lnwagebill_a=ln((expenses_officials*(1-0.9140965)+expenses_wageearners*(1-0.8462651))/0.1) if (expenses_officials*(1-0.9140965)+expenses_wageearners*(1-0.8462651))~=0 & wageworkers_a==0
  replace lnwagebill_a=ln(0.15) if (expenses_officials*(1-0.9140965)+expenses_wageearners*(1-0.8462651))==0 & wageworkers_a==0
  
  gen lnwageratio_a=ln((expenses_officials*0.9140965+expenses_wageearners*0.8462651)/officers_a)-lnwagebill_a if year>=1890
  gen no_officers_a = ((expenses_officials*0.9140965+expenses_wageearners*0.8462651)==0) & officers_a==0 if year>=1890
  replace lnwageratio_a=ln(0.3)-lnwagebill_a if no_officers_a & year>=1890  
********************************************************  ********************************************************  ********************************************************    
  
  gen lnHp = ln(Primary) if xzsamp & Horsesamp
  gen lnk = ln(Capital) if xzsamp & capsamp 
  gen lnRt=ln(expenses_rent) if xzsamp & Rentsamp
  gen lnFp=ln(expenses_fuelandpower) if xzsamp & Fuelsamp

  rename ar2lit_natmal lnar2lit_natmal
  rename r2lit_natmal lnr2lit_natmal
  rename r2lit_nat lnr2lit_nat
  rename r2lit_imm lnr2lit_imm
	
end
outcomes


* impute capital in years with Horsepower (1930)
qui areg lnk lnHp yrdum* areadum_*, absorb(industry_unified) cluster(area)
di _b[lnHp] " (" _se[lnHp] "), R2 = " e(r2)
local impkcoeff = _b[lnHp]
predict lnkhat if xzsamp
gen lnkyimpute = lnkhat - ln(Valueadded) if xzsamp
  replace lnkyimpute = lnky if lnky~=.
gen lnklimpute = lnkhat - ln(wageearners_av_total) if xzsamp
  replace lnklimpute = lnkl if lnkl~=.

* impute capital in years with fuel & power (1930)
qui areg lnk lnFp yrdum* areadum_*, absorb(industry_unified) cluster(area)
di _b[lnFp] " (" _se[lnFp] "), R2 = " e(r2)
local impk2coeff = _b[lnFp]
predict lnkhat2 if xzsamp
gen lnkyimpute2 = lnkhat2 - ln(Valueadded) if xzsamp
  replace lnkyimpute2 = lnky if lnky~=.
gen lnklimpute2 = lnkhat2 - ln(wageearners_av_total) if xzsamp
  replace lnklimpute2 = lnkl if lnkl~=.  

* Everything by "century":
local break 1890
local early "year<`break'"
local late "year>=`break'"
gen dearly1= (year<1890)
gen dlate1= (year>=1890)
gen dearly2=(year<1900)
gen dlate2=(year>=1900)
 
* dummy by century
gen dcentury1=(year>=1890)
gen dcentury2=(year>1890)


 
forvalues i=1(1)180 {
gen areadumcent1_`i'=areadum_`i'*dcentury1
gen areadumcent2_`i'=areadum_`i'*dcentury2
}

* define lnyl only for our sample.
gen lnylsample = lnyl if Horsesamp|capsamp

* gets counts of industries, areas, for sample means below
egen areact=tag(area dearly1)
egen indct=tag(industry_unified dearly1)

preserve

*Generate Firm Size Dummy
use "$dta/industries_final3_no0s", clear
keep if year==1900
bys industry_unified: egen establishments=sum(Numberofestablishments)
bys industry_unified: egen persons=sum(personsinindustry_total)
keep industry_unified establishments persons
duplicates drop
gen wpi=persons/establishments
sum wpi, det /* p(50)=22 */
gen fsize=0
egen wpi_median= pctile(wpi), p(50)
replace fsize=1 if wpi>wpi_median
keep industry_unified fsize
save "$dta/industry", replace


*Generate H/L and K/N size
use "$dta/industries_final3_no0s", clear
keep industry_unified hl* kl*
duplicates drop
gen sizeh=0
gen sizek=0
egen hl_median= pctile(hl_1890), p(50)
egen kl_median= pctile(kl_1860), p(50)
replace sizeh=1 if hl_1890>hl_median
replace sizek=1 if kl_1860>kl_median
keep industry_unified size*
save "$dta/industry2", replace

restore

* Add interaction with Firm Size and H/L, K/N
drop _merge
merge m:1 industry_unified using "$dta/industry"
replace fsize=0 if fsize==.
drop _merge
merge m:1 industry_unified using "$dta/industry2"
replace sizeh=0 if sizeh==.
replace sizek=0 if sizek==.
drop _merge

foreach x in fsize sizeh sizek{
gen skratio_lit_`x'=skratio_lit*`x'
gen zratio_smith_lit_`x'=zratio_smith_lit*`x'
}


* Add interaction Chandler Early adopters
gen early=0
foreach x in 3 4 6 8 9 10 12 15 17 57 58 73 80 88{
replace early=1 if industry_unified==`x'
}


foreach i of varlist dearly1 dlate1 dearly2 dlate2{
gen skratio_`i'=skratio_lit*`i'
gen  zratio_smith_`i'=zratio_smith_lit*`i'
foreach y in fsize early sizeh sizek{
gen skratio_`i'_`y'=skratio_lit*`i'*`y'
gen  zratio_smith_`i'_`y'=zratio_smith_lit*`i'*`y'
}
}

save "$temp/regdata_finaltables_full.dta", replace
capture log close
  
