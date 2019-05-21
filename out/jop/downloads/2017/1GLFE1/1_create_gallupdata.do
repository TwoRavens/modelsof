** GALLUP SERIES THAT INCLUDES NORMALLY WORDING DURING 1950s!

use "macrocount_normally.dta", clear
sort date
** Kalman filtered and smoothed Consumer Sentiment measure 
merge date using "latentics.dta", sort
tab _merge
drop _merge
sort date
** Kalman filtered and smoothed Approval measure 
merge date using "latentapproval.dta", sort
tab _merge
drop _merge

tsset date
tsfill 
sort date
order date

drop if date<quarterly("4-1951","QY")


** Create Telephone Trend and Constant for Telephone Era
drop trend-smoothtrend2
gen trend = 0
replace trend = date - quarterly("2-1984","QY") if date>=quarterly("2-1984","QY")
replace trend = trend/4
** Create constant
gen teleconstant = 0
replace teleconstant = 1 if date>=quarterly("2-1984","QY")
replace trend=.  if teleconstant==0
sum trend

** Compare Gallup Overall vs. NES
gen diff = gallup_macro_overall -nes_macro
replace diff = gallup_macro_overall -gss_macro if diff==.
mean diff if date<yq(1985,1) 
mean diff if date>=yq(1985,1) 
** Gallup has signicant bias post telephone
drop diff

** Compare CBS/NYT vs. NES
gen diff = cbsnyt_macro_landline - nes_macro
replace diff = cbsnyt_macro_landline - gss_macro if diff==.
mean diff if date>=yq(1985,1)
** CBS/NYT doesn't have similar bias
drop diff


** Create Gallup Phone bias measure for each quarter by comparing to gallup personal (gtbias) or  by comparing to either ANES or GSS personal (if ANES missing)
gen gtbias = gallup_macro_landline-gallup_macro_personal
gen obias = gallup_macro_landline -nes_macro
replace obias = gallup_macro_landline -gss_macro if obias==.

** Estimate sampling error

gen vargtbias = gallup_macro_landline*(1-gallup_macro_landline)/(gallup_repcountlandline+gallup_demcountlandline) + gallup_macro_person*(1-gallup_macro_person)/(gallup_repcountperson+gallup_demcountperson)
gen varotbias = gallup_macro_landline*(1-gallup_macro_landline)/(gallup_repcountlandline+gallup_demcountlandline) + nes_macro*(1-nes_macro)/(nes_party*nes_count)
replace varotbias = gallup_macro_landline*(1-gallup_macro_landline)/(gallup_repcountlandline+gallup_demcountlandline) + gss_macro*(1-gss_macro)/(gss_party*gss_count) if varotbias==.

** Create quarterly Telephone Bias measure that's a combination of gallup and overall
gen tbias = gtbias 
replace tbias = obias if gtbias==. 

** Create sampling measure
gen tbiasvar = vargtbias
replace tbiasvar = varotbias if gtbias==. 

gen weightedvalue = tbias/tbiasvar
gen inversetbiasvar = 1/tbiasvar

** Create cubic spline of telephone trend, estimate weighted regression model
mkspline test=trend, cubic nknots(5) displayknots

reg tbias test* [aw=inversetbiasvar] if teleconstant==1
predict yhat

** Create adjusted gallup phone measures by subtracting quarterly estimate of telephone bias (yhat)
gen adjusted_gallup_smooth = gallup_macro_landline - yhat

** Adjust sampling error estimate by adjusted percentage
gen personalvar = gallup_macro_personal*(1-gallup_macro_personal)/(gallup_repcountperson + gallup_demcountperson)
gen smoothvar= adjusted_gallup_smooth*(1-adjusted_gallup_smooth)/(gallup_repcountlandline+gallup_demcountlandline) 

** Create Adjusted Gallup measure of partisanship by combining personal and adjusted phone measures, weighted by sampling variance
gen adjusted_gallup = (adjusted_gallup_smooth/smoothvar + gallup_macro_personal/personalvar)/(1/smoothvar + 1/personalvar)
replace  adjusted_gallup = gallup_macro_overall if gallup_macro_landline==.
replace  adjusted_gallup = adjusted_gallup_smooth if gallup_macro_personal==.

** create sample size and sampling variance estimate for adjusted macropartisanship
gen macrocount = gallup_repcountoverall + gallup_demcountoverall
gen macrovar = ((1-adjusted_gallup)*adjusted_gallup)/macrocount

gen ytau = 1/macrovar

tab adjusted_gallup if ytau==.

gen month=month(dofq(date))
gen year=year(dofq(date))


saveold "1_gallupdataout.dta", replace
