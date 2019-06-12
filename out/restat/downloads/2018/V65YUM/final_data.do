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
log using log/final_data.log, replace
clear
set more off

*Generate a dataset to identify which cities are always in the panel and which ones are not.

use data/industries_final3_no0s, clear
gen capsamp=(Capital~=. & wageearners_av_total~=. & Valueofproducts~=. & Capital~=0 & wageearners_av_total~=0 & Valueofproducts~=0)

* get count of areas
collapse (sum) capsamp (count) nobs=capsamp, by(year area)

* merge to xzsamp (right hand side variables):
merge 1:1 area year using data/endogenouscty3

* how many obs in balaned panel
save temp/data0.dta, replace
gen goodobs = ( _merge==3 & skratio~=. & zratio_2mith_lit~=.)
keep if goodobs
egen ctyrs60_80 = total(goodobs) if year<=1880, by(area)
gen panel60_80 = (ctyrs60_80==3)
drop ctyrs

egen ctyrs90_40 = total(goodobs) if year>=1890, by(area)
gen panel90_40 = (ctyrs90_40==6)
drop ctyrs
keep area year panel*
save dta/balpan-century.dta, replace


*Generate information regarding returns to literacy

use src/popcens1850_1930.dta, clear

* get to a consistent sample with literacy identified
keep if age>=20 & age<=64
drop if year==1880 & datanum~=2

* define "literate"
gen byte ill=lit<4
rename lit literacy
gen byte lit=1-ill

* ID native-born
gen byte imm = bpld>=15000 if bpld~=.
gen byte nat = 1-imm

* males
gen natmal = nat & sex==1

* log occscore
gen lnocc = ln(occscore)

* occscore by group:
local mnlist ""
local obslist ""
foreach nat in nat imm natmal {
  foreach lit in lit ill {
    gen lnocc_`nat'`lit' = lnocc if `nat'==1 & `lit'==1
	gen obs_`nat'`lit' = (lnocc~=. & `nat'==1 & `lit'==1)
	
	local mnlist "`mnlist' mlnocc_`nat'`lit'=lnocc_`nat'`lit'"
	local obslist "`obslist' nobs_`nat'`lit'=obs_`nat'`lit'"
  }
}

fixgeo 
save temp/littemp, replace

use src/county_match3_old.dta
   rename state st_name
   rename county cnty_name
   rename countyid_new countyid
   drop gisjoin
   drop if countyid == 2201130 & trim(cnty_name)=="Vermilion" /* extra misspelled copy of Vermillion LA */
   drop if countyid==.
   merge 1:m statea countya using temp/littemp
   keep if _merge==3|_merge==2
   drop _merge
   
   * make missing countyid countyid=0 (really, non-city areas)
   replace countyid=0 if countyid==.  
   replace statea="" if countyid==.
   replace countya="" if countyid==.
   replace st_name="" if countyid==.
   
   * for kix, add back in Honolulu county (may drop in the future)
   replace countyid = 1500030 if statea=="150" & countya=="0030"
   replace st_name = "Hawaii" if statea=="150" & countya=="0030"
   replace cnty_name = "Honolulu" if statea=="150" & countya=="0030"
      
   * * IV.2 Construct "area," which, for now = county except in NYC.  
   * (May want to add other multi-county cities later)
   /* NYC will be sum of "five" counties (which is its real definition post-1920 or so)
      - This merges Brooklyn and New York which were separate cities pre-1900
	  - 3600060 is a merge of Bronx and New York counties, which were also once separate */
   gen area = countyid
   replace area = 3600060 if countyid==3600060|countyid==3600470|countyid==3600810|countyid==3600850
   
   save temp/littemp, replace

* collapse by group, year to the area
collapse (mean) `mnlist' (rawsum) `obslist' [pw=perwt], by(year area)
save dta/r2lit-county.dta, replace


* go back to raw data with number of nat obs
keep year area nobs_natmallit nobs_natmalill
merge 1:m area year using temp/littemp.dta
keep if nobs_natmalill>9 & nobs_natmallit>9
drop _merge

* get share literate in each 5-year age bin (in an area-year), for reweighting to matched age distribution.
gen age5 = floor(age/5)*5
egen litshr=mean(lit) if natmal==1, by(year area age5)
drop if litshr==0 | litshr == 1 /* can't balance means if 0 of one group or the other */

* reweight:
gen rewt = perwt*litshr/(1-litshr)
save temp/littemp.dta, replace

* native male literates, adjusted (just dropping unmatched cells)
collapse (mean) alnocc_natmallit = lnocc_natmallit (rawsum) anobs_natmallit = obs_natmallit [pw=perwt], by(area year)
merge 1:1 area year using dta/r2lit-county.dta
keep if _merge==2|_merge==3
drop _merge
save dta/r2lit-county.dta, replace

* native male illiterates, reweighted
use temp/littemp.dta, replace
collapse (mean) alnocc_natmalill = lnocc_natmalill (rawsum) anobs_natmalill = obs_natmalill [pw=rewt], by(area year)
merge 1:1 area year using dta/r2lit-county.dta
keep if _merge==2|_merge==3
drop _merge
save dta/r2lit-county.dta, replace

* create gap variables
foreach grp in natmal imm nat {
  gen r2lit_`grp' = mlnocc_`grp'lit - mlnocc_`grp'ill
}
gen ar2lit_natmal = alnocc_natmallit - alnocc_natmalill

su ar2lit_natmal r2lit*

* cleanup variables
order area year ar2lit_natmal r2lit_natmal r2lit_nat r2lit_imm alnocc_natmallit alnocc_natmalill
label variable ar2lit_natmal "Age-Adjusted Ret 2 Lit, Nat Males"
label variable r2lit_natmal "Raw Ret 2 Lit, Nat Males"
label variable r2lit_nat "Raw Ret 2 Lit, All Natives"
label variable r2lit_imm "Raw Ret 2 Lit, All Immigrants"
label variable anobs_natmalill "# wg obs on Nat Mal Ill, Adjusted"
label variable anobs_natmallit "# wg obs on Nat Mal Lit, Adjusted"
label variable alnocc_natmallit "Age Adj ln Wg, Nat Male Lit"
label variable alnocc_natmalill "Age Adj ln Wg, Nat Male Illiterate"
save dta/r2lit-county, replace


use dta/industries_final3_no0s
sort area statea year

merge m:1 area year using dta/endogenouscty4_full
drop if _merge==2
drop _merge

merge m:1 area year using dta/r2lit-county.dta
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
merge m:1 area year using "dta/balpan-century.dta"

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
use dta/industries_final3_no0s, clear
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
save dta/industry, replace


*Generate H/L and K/N size
use dta/industries_final3_no0s, clear
keep industry_unified hl* kl*
duplicates drop
gen sizeh=0
gen sizek=0
egen hl_median= pctile(hl_1890), p(50)
egen kl_median= pctile(kl_1860), p(50)
replace sizeh=1 if hl_1890>hl_median
replace sizek=1 if kl_1860>kl_median
keep industry_unified size*
save dta/industry2, replace

restore

* Add interaction with Firm Size and H/L, K/N
drop _merge
merge m:1 industry_unified using dta/industry
replace fsize=0 if fsize==.
drop _merge
merge m:1 industry_unified using dta/industry2
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

save temp/regdata_finaltables_full.dta, replace

*NOW DO THE SAME FOR THE AGGREGATE DATA

use dta/industries_final2, clear

collapse (sum) Numberofestablishments-Valueaddedbymanufacture officers-wageearners_av_under16 RentedK-Electricmotors, by(city countyid_new statea state year)
rename countyid_new area
sort area statea year
merge m:1 area  year using dta/endogenouscty4_full
drop if _merge==2
drop _merge

merge m:1 area year using dta/r2lit-county.dta
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

save temp/regdata_finaltables_agg_full.dta,  replace

*NOW FOR THE INDUSTRY-CITY-YEAR DATA

use dta/industries_final3, clear

keep if year<1940
* New denominator
gen totalworkers=wageearners_av_total+officers /*L+H*/
gen totalworkers_agg=wageearners_av_total_agg+officers_agg
replace totalworkers= wageearners_av_total if year<1890
replace totalworkers_agg= wageearners_av_total_agg if year<1890
gen wageworkers=wageearners_av_total
gen wageworkers_agg=wageearners_av_total_agg

drop wageearners_av_total
drop wageearners_av_total_agg

rename totalworkers wageearners_av_total
rename totalworkers_agg wageearners_av_total_agg


* Adjusted workers and hl
gen wageworkers_a= (officers*(1-0.9140965)+wageworkers*(1-0.8462651))
gen officers_a= (officers*(0.9140965)+wageworkers*(0.8462651))
gen wageworkers_agg_a= (officers_agg*(1-0.9140965)+wageworkers_agg*(1-0.8462651))
gen officers_agg_a= (officers_agg*(0.9140965)+wageworkers_agg*(0.8462651))



gen hl_1890_a=(officers_agg_a/wageworkers_agg_a) if year==1890 & officers_agg_a/wageworkers_agg_a~=.
bysort industry_unified: egen hl_mean_a=mean(officers_agg_a/wageworkers_agg_a)
bysort industry_unified: egen hl_industry_a=mean(hl_1890_a)
drop  hl_1890_a
rename hl_industry_a hl_1890_a
rename hl_mean_a hl_mean_agg_a


collapse (mean)kl_* (mean)hl_* (sum)Valueofproducts (sum)Numberofestablishments (sum)Capital (sum)wageearners_av_total (sum)wageworkers (sum)officers , by(area statea state year industry_unified)

rename hl_mean_agg hl_mean
rename hl_mean_agg_a hl_mean_a



xtile quant_kl_1860=kl_1860, nq(4)
xtile quant_kl_mean=kl_mean, nq(4)
xtile quant_hl_1890=hl_1890, nq(4)
xtile quant_hl_mean=hl_mean, nq(4)
xtile quant_hl_1890_a=hl_1890_a, nq(4)
xtile quant_hl_mean_a=hl_mean_a, nq(4)


rename Valueofproducts y
rename Numberofestablishments n
rename Capital k
rename wageworkers l

foreach var in kl_1860 kl_mean hl_1890 hl_mean hl_1890_a hl_mean_a{
foreach out in y l k n{
gen share_`var'_`out'_1=(quant_`var'==1)*`out'
gen share_`var'_`out'_2=(quant_`var'==2)*`out'
gen share_`var'_`out'_3=(quant_`var'==3)*`out'
gen share_`var'_`out'_4=(quant_`var'==4)*`out'
}
}

save temp/temp_industrymix.dta, replace


collapse (sum)share_* (sum)y (sum)n (sum)k (sum)l , by(area statea state year)

foreach var in kl_1860 kl_mean hl_1890 hl_mean hl_1890_a hl_mean_a{
foreach out in y l k n{
replace share_`var'_`out'_1=share_`var'_`out'_1/`out'
replace share_`var'_`out'_2=share_`var'_`out'_2/`out'
replace share_`var'_`out'_3=share_`var'_`out'_3/`out'
replace share_`var'_`out'_4=share_`var'_`out'_4/`out'
}
}

* construct endless fixed effects
gen century=year<1890
egen areacent = concat(area century), punct("_")
qui tab areacent, gen(acdum_)
qui tab area, gen(areadum_)

sort area year
merge m:1 area year using dta/endogenouscty4_full
drop if _merge==2


* Everything by "century":
local break 1890
local early "year<`break'"
local late "year>=`break'"
gen dearly1=(year<1890)
gen dlate1=(year>=1890)
gen dearly2=(year<1900)
gen dlate2=(year>=1900)

keep if year<1940
 
* dummy by century
gen dcentury1=(year>=1890)
gen dcentury2=(year>1890)


forvalues i=1(1)180 {
gen areadumcent1_`i'=areadum_`i'*dcentury1
gen areadumcent2_`i'=areadum_`i'*dcentury2
}




gen samp_nok=(share_hl_mean_n_4!=.)
gen samp_k=(share_hl_mean_k_4!=.)

*FIRST STAGE ALL DATA
qui reg skratio_lit zratio_smith_lit yrdum* areadum_* areadumcent2_* dcentury2  if samp_nok, cluster(area)
predict skratio_ho
test zratio_smith_lit 
estimates store all

qui reg skratio_lit zratio_smith_lit yrdum* areadum_* areadumcent2_* dcentury2  if samp_k, cluster(area)
predict skratio_ho_k
test zratio_smith_lit 
estimates store all

forvalues i=1(1)2 {
qui reg skratio_lit zratio_smith_lit yrdum* areadum_* areadumcent`i'_* dcentury`i'  if samp_nok, cluster(area)
predict skratio_ho`i'
qui reg skratio_lit zratio_smith_lit yrdum* areadum_* areadumcent`i'_* dcentury`i'  if samp_k, cluster(area)
predict skratio_ho_k`i'
}


* Predicted Instruments
foreach x in skratio_ho_k skratio_ho skratio_ho_k1 skratio_ho1 skratio_ho_k2 skratio_ho2{
gen `x'_dearly1=`x'*dearly1
gen `x'_dlate1=`x'*dlate1
gen `x'_dearly2=`x'*dearly2
gen `x'_dlate2=`x'*dlate2
}


foreach i of varlist dearly1 dlate1 dearly2 dlate2 {
gen skratio_`i'=skratio_lit*`i'
gen  zratio_smith_`i'=zratio_smith_lit*`i'
}


save temp/regdata_industrymix_full.dta,  replace

***************************
* Now building the data set for the structural estimation
***************************
use temp/regdata_finaltables_full.dta, clear


forvalues i=1(1)2{
estimates clear
qui {
estimates clear
*Area
areg skratio_lit zratio_smith_lit  yrdum*  areadumcent`i'_* dcentury`i' [aw=weight] if  (capsamp|Horsesamp) & xzsamp, absorb(area) cluster(area)
predict skratio_noind`i'
estimates store noind

*Industry
areg skratio_lit zratio_smith_lit areadum_*   yrdum* areadumcent`i'_* dcentury`i' [aw=weight] if  (capsamp|Horsesamp) & xzsamp, absorb(industry_unified) cluster(area)
predict skratio_area`i'
estimates store area 

*Industry*Year
areg skratio_lit zratio_smith_lit areadum_* inddum_*  yrdum* areadumcent`i'_* dcentury`i' [aw=weight] if (capsamp|Horsesamp) &  xzsamp , absorb(indyear) cluster(area)
predict skratio_indyr`i'
estimates store indyr
}
}

gen skratio_area=skratio_area2
gen skratio_noind=skratio_noind2
gen skratio_indyr=skratio_indyr2


foreach x in skratio_area skratio_noind skratio_indyr skratio_noind1 skratio_area1 skratio_indyr1  skratio_noind2 skratio_area2 skratio_indyr2 {
gen `x'_dearly1=`x'*dearly1
gen `x'_dlate1=`x'*dlate1
gen `x'_dearly2=`x'*dearly2
gen `x'_dlate2=`x'*dlate2
}



save temp/regdata_finaltables_xz_full.dta, replace
 



 
use temp/regdata_finaltables_xz_full.dta, clear
 * Keep kl
drop lnkyimpute lnFuy lnHpYimpute
rename lnklimpute lnkimpute
rename lnFul lnFuel
rename lnHplimpute lnHpimpute
gen dumkl=1
save temp/regdata_kl.dta, replace

*Keep ky
use temp/regdata_finaltables_xz_full.dta, clear
drop lnklimpute lnFul lnHplimpute
rename lnkyimpute lnkimpute
rename lnFuy lnFuel
rename lnHpYimpute lnHpimpute
gen dumkl=0
save temp/regdata_ky.dta, replace


* Append Data
use temp/regdata_ky.dta, clear
append using temp/regdata_kl.dta
save temp/regdata_k, replace




use temp/regdata_k, clear
gen dumky=(dumkl==0)

forvalues i=1(1)2{
foreach x in skratio_dearly`i' skratio_dlate`i'  skratio_area`i'_dearly`i' skratio_area`i'_dlate`i'{
gen `x'_dumkl=`x'*dumkl
gen `x'_dumky=`x'*dumky
}
}
forvalues i=1(1)2{
foreach x in skratio_noind`i'_dearly`i' skratio_noind`i'_dlate`i'  skratio_indyr`i'_dearly`i' skratio_indyr`i'_dlate`i'{
gen `x'_dumkl=`x'*dumkl
gen `x'_dumky=`x'*dumky
}
}





forvalues i=1(1)180 {
gen dumkl_areadumcent_`i'=areadumcent2_`i'*dumkl
}

forvalues i=1(1)180 {
gen dumkl_areadum_`i'=areadum_`i'*dumkl
}
forvalues i=1(1)146 {
gen dumkl_inddum_`i'=inddum_`i'*dumkl
}
forvalues i=1(1)9 {
gen dumkl_yrdum`i'=yrdum`i'*dumkl
}
forvalues i=1(1)1018 {
gen dumkl_itdum_`i'=itdum_`i'*dumkl
}


gen dumkl_dcentury1=dumkl*dcentury1
gen dumkl_dcentury2=dumkl*dcentury2


forvalues i=1(1)180 {
gen dumkl_areadumcent1_`i'=areadumcent1_`i'*dumkl
gen dumkl_areadumcent2_`i'=areadumcent2_`i'*dumkl
}


global dumkl_indyr "dumkl_*"
global dumkl_area  " dumkl_areadumcent_*  dumkl_areadum_* dumkl_yrdum* dumkl_dcentury dumkl_inddum_*" 
global dumkl_noind " dumkl_areadumcent_*  dumkl_areadum_* dumkl_yrdum* dumkl_dcentury" 


forvalues i=1(1)180 {
gen dumky_areadumcent_`i'=areadumcent2_`i'*dumky
gen dumky_areadum_`i'=areadum_`i'*dumky
}
forvalues i=1(1)146 {
gen dumky_inddum_`i'=inddum_`i'*dumky
}
forvalues i=1(1)9 {
gen dumky_yrdum`i'=yrdum`i'*dumky
}

forvalues i=1(1)1018 {
gen dumky_itdum_`i'=itdum_`i'*dumky
}


gen dumky_dcentury1=dumky*dcentury1
gen dumky_dcentury2=dumky*dcentury2


* Define new dependent variables to estimate -A	
foreach var in kimpute Fuel Hpimpute{
forvalues i=1(1)2{
*Industry effects
gen ln`var'_`i'=ln`var'-(1-.8599459)*skratio_dearly`i' /*k/l*/
replace ln`var'_`i'=ln`var'-(1-.8599459)*skratio_dlate`i' if dlate`i' & dumkl /*k/l*/
replace ln`var'_`i'=ln`var'-.0787483*skratio_dearly`i' if dearly`i' & dumky /*k/y*/
replace ln`var'_`i'=ln`var'-.0787483*skratio_dlate`i' if dlate`i' & dumky /*k/y*/

}
}

* 2. Define new dependent variables to estimate (1-A)
foreach var in kimpute Fuel Hpimpute{
forvalues i=1(1)2{
*Industry effects
gen ln`var'_hat_`i'=ln`var'+.8599459*skratio_dearly`i' /*k/l*/
replace ln`var'_hat_`i'=ln`var'+.8599459*skratio_dlate`i' if dlate`i' & dumkl /*k/l*/
replace ln`var'_hat_`i'=ln`var'+.5084719*skratio_dearly`i' if dearly`i' & dumky /*k/y*/
replace ln`var'_hat_`i'=ln`var'+.5084719*skratio_dlate`i' if dlate`i' & dumky /*k/y*/

}
}



forvalues i=1(1)2{
* Endogenous X
gen skratiohat_dearly`i'=skratio_dearly`i' /*k/n*/
replace skratiohat_dearly`i'= (.0787483+.5084719)*skratio_dearly`i' if  dumky /*k/y*/
gen skratiohat_dlate`i'=skratio_dlate`i' /*k/n*/
replace skratiohat_dlate`i'= (.0787483+.5084719)*skratio_dlate`i' if  dumky /*k/y*/


/*Instrument*/
* Area effects
gen skratiohatz_noind_dearly`i'=skratio_noind_dearly`i' /*k/l*/
replace skratiohatz_noind_dearly`i'= (.0787483+.5084719)*skratio_noind_dearly`i' if  dumky /*k/y*/
gen skratiohatz_noind_dlate`i'=skratio_noind_dlate`i' /*k/l*/
replace skratiohatz_noind_dlate`i'= (.0787483+.5084719)*skratio_noind_dlate`i' if  dumky /*k/y*/

*Industry Effects
gen skratiohatz_area_dearly`i'=skratio_area_dearly`i' /*k/n*/
replace skratiohatz_area_dearly`i'= (.0787483+.5084719)*skratio_area_dearly`i' if  dumky /*k/y*/
gen skratiohatz_area_dlate`i'=skratio_area_dlate`i' /*k/n*/
replace skratiohatz_area_dlate`i'= (.0787483+.5084719)*skratio_area_dlate`i' if  dumky /*k/y*/

*IndustryxYear Effect
gen skratiohatz_indyr_dearly`i'=skratio_indyr_dearly`i' /*k/l*/
replace skratiohatz_indyr_dearly`i'= (.0787483+.5084719)*skratio_indyr_dearly`i' if  dumky /*k/y*/
gen skratiohatz_indyr_dlate`i'=skratio_indyr_dlate`i' /*k/l*/
replace skratiohatz_indyr_dlate`i'= (.0787483+.5084719)*skratio_indyr_dlate`i' if  dumky /*k/y*/
}



/*Instrument by century*/
forvalues i=1(1)2{
* Area effects
gen skratiohatz_noind`i'_dearly`i'=skratio_noind`i'_dearly`i' /*k/l*/
replace skratiohatz_noind`i'_dearly`i'= (.0787483+.5084719)*skratio_noind`i'_dearly`i' if  dumky /*k/y*/
gen skratiohatz_noind`i'_dlate`i'=skratio_noind`i'_dlate`i' /*k/l*/
replace skratiohatz_noind`i'_dlate`i'= (.0787483+.5084719)*skratio_noind`i'_dlate`i' if  dumky /*k/y*/

*Industry Effects
gen skratiohatz_area`i'_dearly`i'=skratio_area`i'_dearly`i' /*k/n*/
replace skratiohatz_area`i'_dearly`i'= (.0787483+.5084719)*skratio_area`i'_dearly`i' if  dumky /*k/y*/
gen skratiohatz_area`i'_dlate`i'=skratio_area`i'_dlate`i' /*k/n*/
replace skratiohatz_area`i'_dlate`i'= (.0787483+.5084719)*skratio_area`i'_dlate`i' if  dumky /*k/y*/

*IndustryxYear Effect
gen skratiohatz_indyr`i'_dearly`i'=skratio_indyr`i'_dearly`i' /*k/l*/
replace skratiohatz_indyr`i'_dearly`i'= (.0787483+.5084719)*skratio_indyr`i'_dearly`i' if  dumky /*k/y*/
gen skratiohatz_indyr`i'_dlate`i'=skratio_indyr`i'_dlate`i' /*k/l*/
replace skratiohatz_indyr`i'_dlate`i'= (.0787483+.5084719)*skratio_indyr`i'_dlate`i' if  dumky /*k/y*/
}




forvalues i=1(1)2{
* Endogenous var.
gen skratiohat_dearly`i'_dumkl=skratiohat_dearly`i'*dumkl
gen skratiohat_dlate`i'_dumkl=skratiohat_dlate`i'*dumkl

gen skratiohat_dearly`i'_dumky=skratiohat_dearly`i'*dumky
gen skratiohat_dlate`i'_dumky=skratiohat_dlate`i'*dumky


** Instrument defined for three groups of FE
gen skratiohatz_area_dearly`i'_dumkl=skratiohatz_area_dearly`i'*dumkl
gen skratiohatz_area_dlate`i'_dumkl=skratiohatz_area_dlate`i'*dumkl
gen skratiohatz_noind_dearly`i'_dumkl=skratiohatz_noind_dearly`i'*dumkl
gen skratiohatz_noind_dlate`i'_dumkl=skratiohatz_noind_dlate`i'*dumkl
gen skratiohatz_indyr_dearly`i'_dumkl=skratiohatz_indyr_dearly`i'*dumkl
gen skratiohatz_indyr_dlate`i'_dumkl=skratiohatz_indyr_dlate`i'*dumkl

gen skratiohatz_area_dearly`i'_dumky=skratiohatz_area_dearly`i'*dumky
gen skratiohatz_area_dlate`i'_dumky=skratiohatz_area_dlate`i'*dumky
gen skratiohatz_noind_dearly`i'_dumky=skratiohatz_noind_dearly`i'*dumky
gen skratiohatz_noind_dlate`i'_dumky=skratiohatz_noind_dlate`i'*dumky
gen skratiohatz_indyr_dearly`i'_dumky=skratiohatz_indyr_dearly`i'*dumky
gen skratiohatz_indyr_dlate`i'_dumky=skratiohatz_indyr_dlate`i'*dumky

** Instrument defined for three groups of FE & 2 definitions of century
gen skratiohatz_area`i'_dearly`i'_dumkl=skratiohatz_area`i'_dearly`i'*dumkl
gen skratiohatz_area`i'_dlate`i'_dumkl=skratiohatz_area`i'_dlate`i'*dumkl
gen skratiohatz_noind`i'_dearly`i'_dumkl=skratiohatz_noind`i'_dearly`i'*dumkl
gen skratiohatz_noind`i'_dlate`i'_dumkl=skratiohatz_noind`i'_dlate`i'*dumkl
gen skratiohatz_indyr`i'_dearly`i'_dumkl=skratiohatz_indyr`i'_dearly`i'*dumkl
gen skratiohatz_indyr`i'_dlate`i'_dumkl=skratiohatz_indyr`i'_dlate`i'*dumkl

gen skratiohatz_area`i'_dearly`i'_dumky=skratiohatz_area`i'_dearly`i'*dumky
gen skratiohatz_area`i'_dlate`i'_dumky=skratiohatz_area`i'_dlate`i'*dumky
gen skratiohatz_noind`i'_dearly`i'_dumky=skratiohatz_noind`i'_dearly`i'*dumky
gen skratiohatz_noind`i'_dlate`i'_dumky=skratiohatz_noind`i'_dlate`i'*dumky
gen skratiohatz_indyr`i'_dearly`i'_dumky=skratiohatz_indyr`i'_dearly`i'*dumky
gen skratiohatz_indyr`i'_dlate`i'_dumky=skratiohatz_indyr`i'_dlate`i'*dumky

}

save temp/regdata_estruct_full.dta, replace

****************************************
*Separate by early and late immigration*
****************************************

use "src/usa_00173", clear

drop if datanum==1 & year==1880 /*this sample does not have the literacy variable*/

* account for differences in sampling rates
gen stock=100
replace stock=10 if year==1880 /*There are two 1880 samples, 10% & 100%, the 10% sample has literacy*/
replace stock=20 if year==1900|year==1930
gen byte obs=1

* drop children (< 15 years)
drop if age<15

************************
* II.A. Literacy Variables
************************
* To construct "high" and "low" skill from literacy data, 

*Gen a dummy for manufacturing industries
gen manu=(ind1950>=300 & ind1950<500) if ind1950~=0 & ind1950~=.
replace ind1950=0 if manu==0

gen literate=lit==4 if lit~=0 & lit~=.
replace literate=0 if lit==0 & year<=1860 /*literacy in 1850 & 1860*/
replace literate=higrade>5 if year==1940 & higrade~=./*05 is second grade of elementary school (attended or completed)*/

keep if literate~=.



*************************************
* III. Country groups for immigrats *
*************************************
cgrps

*********************
* III. Fix Geo*graphy *
*********************

* III.1 Make county boundaries consistent over time 
* (for city areas only -- non-city areas set to county code=0)
* is fixgeo program from original do-file

fixgeo

save dta/temp_literacy_imm_area.dta, replace 



**********
* Other years' data
* skills data by year for non-1890 years, immigrant origin from tempcty_literacy
**********
use "src/county_match3_old.dta", clear
rename state st_name
rename county cnty_name
rename countyid_new countyid
drop if countyid == 2201130 & trim(cnty_name)=="Vermilion" /* extra misspelled copy of Vermillion LA */
drop if countyid==.
keep statea countya countyid st_name cnty_name
compress
merge statea countya using dta/temp_literacy_imm_area.dta, uniqmaster sort 
tab _merge    
keep if _merge==3|_merge==2 /* for now we need the non-city counties */
drop _merge

* make missing countyid countyid=0 (really, non-city areas)
replace countyid=0 if countyid==.


* Construct "area," which, for now = county except in NYC.  
   /* NYC will be sum of "five" counties (which is its real definition post-1920 or so)
      - This merges Brooklyn and New York which were separate cities pre-1900
	  - 3600060 is a merge of Bronx and New York counties, which were also once separate */

gen area = countyid
replace area = 3600060 if countyid==3600060|countyid==3600470|countyid==3600810|countyid==3600850


gen native=(agethcode==0)
gen new_imm=(agethcode==12|agethcode==13|agethcode==14|agethcode==17|agethcode==18|agethcode==19|agethcode==21|agethcode==22|agethcode==23)
save dta/literacy_imm_area.dta, replace 


use dta/literacy_imm_area.dta, clear
keep if  year==1880 | year==1860
gen old_imm=(agethcode>=1 & agethcode<=5)

tabstat new_imm old_imm [w=perwt], by (year)

collapse (mean)new_imm old_imm native [pw=perwt], by(statea area year)
sort statea area 
drop native
reshape wide new_imm old_imm, i(statea area ) j(year)


gen newimm1880=0
replace newimm1880=1 if (new_imm1880>=.0076527) & new_imm1880!=.

gen oldimm1880=0
replace oldimm1880=1 if (old_imm1880>=.0896929) & old_imm1880!=.

gen newimm1860=0
replace newimm1860=1 if (new_imm1860>=.0027587)  & new_imm1860!=.

gen oldimm1860=0
replace oldimm1860=1 if (old_imm1860>=.1310157) & old_imm1860!=.


drop if area==0

save dta/temp_newimm, replace



***
Generate the structural data by immigration
***



* Generate same data on immigrants
sort area statea
merge m:1 area statea using dta/temp_newimm.dta
drop _merge
replace newimm1880=0 if newimm1880==.


gen nonewimm1880=(1-newimm1880)

forvalues i=1(1)2{
gen skhat_dearly`i'_newimm=skratiohat_dearly`i'*newimm1880
gen skhat_dlate`i'_newimm=skratiohat_dlate`i'*newimm1880
gen skhat_dearly`i'_nonewimm=skratiohat_dearly`i'*nonewimm1880
gen skhat_dlate`i'_nonewimm=skratiohat_dlate`i'*nonewimm1880
gen skhatz_noind`i'_dearly`i'_newimm = skratiohatz_noind`i'_dearly`i'*newimm1880
gen skhatz_noind`i'_dlate`i'_newimm = skratiohatz_noind`i'_dlate`i'*newimm1880
gen skhatz_noind`i'_dearly`i'_nonewimm = skratiohatz_noind`i'_dearly`i'*nonewimm1880
gen skhatz_noind`i'_dlate`i'_nonewimm = skratiohatz_noind`i'_dlate`i'*nonewimm1880


gen skhatz_area`i'_dearly`i'_newimm = skratiohatz_area`i'_dearly`i'*newimm1880
gen skhatz_area`i'_dlate`i'_newimm = skratiohatz_area`i'_dlate`i'*newimm1880
gen skhatz_area`i'_dearly`i'_nonewimm = skratiohatz_area`i'_dearly`i'*nonewimm1880
gen skhatz_area`i'_dlate`i'_nonewimm = skratiohatz_area`i'_dlate`i'*nonewimm1880

gen skhatz_indyr`i'_dearly`i'_newimm = skratiohatz_indyr`i'_dearly`i'*newimm1880
gen skhatz_indyr`i'_dlate`i'_newimm = skratiohatz_indyr`i'_dlate`i'*newimm1880
gen skhatz_indyr`i'_dearly`i'_nonewimm = skratiohatz_indyr`i'_dearly`i'*nonewimm1880
gen skhatz_indyr`i'_dlate`i'_nonewimm = skratiohatz_indyr`i'_dlate`i'*nonewimm1880

}

save temp/regdata_estruct_full.dta, replace


erase temp/regdata_k.dta
erase temp/regdata_kl.dta
erase temp/regdata_ky.dta

log close

