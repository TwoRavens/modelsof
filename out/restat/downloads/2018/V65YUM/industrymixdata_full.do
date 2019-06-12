
clear
cap clear matrix
set more off, permanently

* folder paths:
* History base folder path
global hist "/home/jfuenzalida/HistManf_JL"

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
log using "$hist/log/industrymixdata.log", replace


use "$dta/industries_final3", clear

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

save "$temp/temp_industrymix.dta", replace


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
merge m:1 area year using "$dta/endogenouscty4_full"
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


save "$temp/regdata_industrymix_full.dta",  replace

capture log close
