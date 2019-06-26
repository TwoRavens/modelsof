********** WILL PROTEST FOR FOOD **********
********** WRITTEN BY TODD G. SMITH ***********
********** UPDATED 18 MARCH 2014 **************
********** THIS FILE GENERATES COMPARISON GRAPHS AND TABLES OF SCAD, ACLED AND GDELT

clear all
set more off

local date	"`c(current_date)'"
local user  "`c(username)'"

cd "/Users/tgsmitty/Documents/active_projects/feeding_unrest_global"
use "/Users/tgsmitty/Documents/active_projects/feeding_unrest_africa/analysis/data/scad_urban_recode.dta", clear
rename time emo
gen scad_riots = etype3 + etype4
save "analysis/data/scad_urban_recode.dta", replace
keep cow_code
duplicates drop
save scad_cow, replace

use "analysis/data/gdelt/gdelt_protests_riots_recode_140317.dta", clear
keep emo iso_num cow_code protests riots

drop if cow_code == .

merge m:1 cow_code using scad_cow
drop if _merge != 3
drop _merge
erase scad_cow.dta

merge 1:1 cow_code emo using "analysis/data/scad_urban_recode.dta"
*drop if _merge != 3
drop _merge

rename emo time
merge 1:1 cow_code time using "/Users/tgsmitty/Documents/active_projects/feeding_unrest_africa/analysis/data/acled_recode.dta"

rename protests gdelt_protests
lab var gdelt_protests "Number of GDELT protest events"
rename riots gdelt_riots
lab var gdelt_riots "Number of GDELT riots"
rename events scad_events
lab var scad_events "Number of SCAD unrest events"
lab var scad_riots "Number of SCAD riots"

rename time emo

rename unrest scad_unrest
gen gdelt_unrest = gdelt_protests > 0
replace gdelt_unrest = . if gdelt_protests == .
lab var gdelt_unrest "Occurence of GDELT protest or riot"
rename acled acled_unrest
gen riot_gdelt = gdelt_riots > 0
replace riot_gdelt = . if gdelt_riots == .
lab var riot_gdelt "Occurence of GDELT riot"
gen riot_scad = scad_riots > 0
replace riot_scad = . if scad_riots == .
lab var riot_scad "Occurence of SCAD riot"
keep iso_num emo gdelt_protests gdelt_riots scad_events scad_riots acled_days scad_unrest gdelt_unrest acled_unrest riot_gdelt riot_scad
do "analysis/do_files/iso_code_define.do"
order iso_num emo

lab def yesno 0 "No" 1 "Yes"
lab val scad_unrest yesno
lab val acled_unrest yesno
lab val gdelt_unrest yesno
lab val riot_gdelt yesno
lab val riot_scad yesno

preserve

collapse (sum) gdelt_protests gdelt_riots scad_events scad_riots acled_days, by(emo)

lab var gdelt_riots "Total number of GDELT riots"
lab var gdelt_protests "Total number of GDELT protests"
lab var scad_events "Total number of SCAD unrest events"
lab var scad_riots "Total number of SCAD riots"
lab var scad_events "Total number of SCAD unrest events"
lab var acled_days "Total number of ACLED days of protest"

foreach var of varlist scad_events scad_riots {
	replace `var' = . if emo < 360
	replace `var' = . if emo > 623
	}
replace acled_days = . if emo < 444
replace acled_days = . if emo > 647
replace gdelt_protests = . if emo > 638
replace gdelt_riots = . if emo > 638

*merge 1:1 time using intl
*drop _merge

tsset emo
sort emo

capture drop ma_scad ma_gdelt ma_acled
tssmooth ma ma_scad = scad_events, window(5 1 0)
tssmooth ma ma_gdelt = gdelt_protests, window(5 1 0)
tssmooth ma ma_acled = acled_days, window(5 1 0)
tssmooth ma ma_scad_riots = scad_riots, window(5 1 0)
tssmooth ma ma_gdelt_riots = gdelt_riots, window(5 1 0)
lab var ma_scad "6 month moving average"
lab var ma_gdelt "6 month moving average"
lab var ma_acled "6 month moving average"
lab var ma_scad_riots "6 month moving average"
lab var ma_gdelt_riots "6 month moving average"
/*
*** All three
twoway (tsline gdelt_protests, lwidth(vthin) connect(stairstep) lpattern(solid) lcolor(dkorange)) ///
	(tsline ma_gdelt, lcolor(dkorange) lpattern(dash) lwidth(medium)) ///
	(tsline scad_events, yaxis(2) lwidth(vthin) connect(stairstep) lpattern(solid) lcolor(dkgreen)) ///
	(tsline ma_scad, yaxis(2) lcolor(dkgreen) lpattern(dash) lwidth(medium)) ///
	(tsline acled_days, yaxis(2) lwidth(vthin) connect(stairstep) lpattern(solid) lcolor(navy)) ///
	(tsline ma_acled, yaxis(2) lcolor(navy) lpattern(dash) lwidth(medium)) ///
	if emo > 360 & emo < 480, xsize(5) ysize(3) ///
	xlabel(360(24)480, labsize(small) angle(45)) xmtick(##8) ///
	ylabel(, labsize(small)) ytitle("Number of events", size(medsmall) margin(small)) ///
	xtitle(, size(medsmall) margin(small)) title(, size(zero)) ///
	legend(region(lcolor(none)) size(medsmall)) ///
	ttitle(, size(zero)) scheme(s1color) name(alldata_90, replace)
twoway (tsline gdelt_protests, lwidth(vthin) connect(stairstep) lpattern(solid) lcolor(dkorange)) ///
	(tsline ma_gdelt, lcolor(dkorange) lpattern(dash) lwidth(medium)) ///
	(tsline scad_events, yaxis(2) lwidth(vthin) connect(stairstep) lpattern(solid) lcolor(dkgreen)) ///
	(tsline ma_scad, yaxis(2) lcolor(dkgreen) lpattern(dash) lwidth(medium)) ///
	(tsline acled_days, yaxis(2) lwidth(vthin) connect(stairstep) lpattern(solid) lcolor(navy)) ///
	(tsline ma_acled, yaxis(2) lcolor(navy) lpattern(dash) lwidth(medium)) ///
	if emo > 480 & emo < 612, xsize(5) ysize(3) ///
	xlabel(480(24)612, labsize(small) angle(45)) xmtick(##8) ///
	ylabel(, labsize(small)) ytitle("Number of events", size(medsmall) margin(small)) ///
	xtitle(, size(medsmall) margin(small)) title(, size(zero)) ///
	legend(region(lcolor(none)) size(medsmall)) ///
	ttitle(, size(zero)) scheme(s1color) name(alldata_00, replace)
*/

local scad ""204 229 255""
local ma_scad ""0 76 153""
local acled ""204 255 204""
local ma_acled ""0 102 0""
local gdelt ""255 229 204""
local ma_gdelt ""204 102 0""

*** SCAD & ACLED
corr scad_events acled_days if emo >= 444 & emo <= 611
local corr = round(r(rho),.0001)
twoway (tsline scad_events, lwidth(thin) connect(stairstep) lpattern(solid) lcolor(`scad')) ///
	(tsline acled_days, yaxis(2) lwidth(thin) connect(stairstep) lpattern(solid) lcolor(`acled')) ///
	(tsline ma_scad, lcolor(`ma_scad') lpattern(solid) lwidth(medium)) ///
	(tsline ma_acled, yaxis(2) lcolor(`ma_acled') lpattern(solid) lwidth(medium)) ///
	if emo >= 444 & emo <= 611, xsize(6) ysize(3) ///
	xlabel(444(12)611, labsize(small) angle(45)) xmtick(##4) ///
	ytitle("SCAD", size(medsmall) margin(small)) ///
	ytitle("ACLED", axis(2) size(medsmall) margin(small)) ///
	xtitle(, size(medsmall) margin(small)) title(, size(zero)) ///
	legend(region(lcolor(none)) size(medsmall)) ///
	note("Correlation = `corr'") ///
	ttitle(, size(zero)) scheme(s1color) name(scad_acled, replace)
graph export "paper/graphs/scad_acled.pdf", replace

*** SCAD & GDELT
corr scad_events gdelt_protests if emo >= 360 & emo <= 611
local corr = round(r(rho),.0001)
twoway (tsline gdelt_protests, lwidth(thin) connect(stairstep) lpattern(solid) lcolor(`gdelt')) ///
	(tsline scad_events, yaxis(2) lwidth(thin) connect(stairstep) lpattern(solid) lcolor(`scad')) ///
	(tsline ma_gdelt, lcolor(`ma_gdelt') lpattern(solid) lwidth(medium)) ///
	(tsline ma_scad, yaxis(2) lcolor(`ma_scad') lpattern(solid) lwidth(medium)) ///
	if emo >= 360 & emo <= 611, xsize(6) ysize(3) ///
	xlabel(360(12)611, labsize(small) angle(45)) xmtick(##4) ///
	ytitle("GDELT", size(medsmall) margin(small)) ///
	ytitle("SCAD", axis(2) size(medsmall) margin(small)) ///
	xtitle(, size(medsmall) margin(small)) title(, size(zero)) ///
	legend(region(lcolor(none)) size(medsmall)) ///
	note("Correlation = `corr'") ///
	ttitle(, size(zero)) scheme(s1color) name(scad_gdelt, replace)
graph export "paper/graphs/scad_gdelt.pdf", replace

*** ACLED & GDELT
corr acled_days gdelt_protests if emo >= 444 & emo <= 638
local corr = round(r(rho),.0001)
twoway (tsline gdelt_protests, lwidth(thin) connect(stairstep) lpattern(solid) lcolor(`gdelt')) ///
	(tsline acled_days, yaxis(2) lwidth(thin) connect(stairstep) lpattern(solid) lcolor(`acled')) ///
	(tsline ma_gdelt, lcolor(`ma_gdelt') lpattern(solid) lwidth(medium)) ///
	(tsline ma_acled, yaxis(2) lcolor(`ma_acled') lpattern(solid) lwidth(medium)) ///
	if emo >= 444 & emo <= 638, xsize(6) ysize(3) ///
	xlabel(444(12)638, labsize(small) angle(45)) xmtick(##4) ///
	ytitle("GDELT", size(medsmall) margin(small)) ///
	ytitle("ACLED", axis(2) size(medsmall) margin(small)) ///
	xtitle(, size(medsmall) margin(small)) title(, size(zero)) ///
	legend(region(lcolor(none)) size(medsmall)) ///
	note("Correlation = `corr'") ///
	ttitle(, size(zero)) scheme(s1color) name(acled_gdelt, replace)
graph export "paper/graphs/acled_gdelt.pdf", replace

*** SCAD & GDELT RIOTS

corr scad_riots gdelt_riots if emo >= 360 & emo <= 611
local corr = round(r(rho),.0001)
twoway (tsline gdelt_riots, lwidth(thin) connect(stairstep) lpattern(solid) lcolor(`gdelt')) ///
	(tsline scad_riots, yaxis(2) lwidth(thin) connect(stairstep) lpattern(solid) lcolor(`scad')) ///
	(tsline ma_gdelt_riots, lcolor(`ma_gdelt') lpattern(solid) lwidth(medium)) ///
	(tsline ma_scad_riots, yaxis(2) lcolor(`ma_scad') lpattern(solid) lwidth(medium)) ///
	if emo >= 360 & emo <= 611, xsize(6) ysize(3) ///
	xlabel(360(12)611, labsize(small) angle(45)) xmtick(##4) ///
	ylabel(, labsize(small)) ytitle("GDELT", size(medsmall) margin(small)) ///
	ytitle("SCAD", axis(2) size(medsmall) margin(small)) ///
	xtitle(, size(medsmall) margin(small)) title(, size(zero)) ///
	legend(region(lcolor(none)) size(medsmall)) ///
	note("Correlation = `corr'") ///
	ttitle(, size(zero)) scheme(s1color) name(scad_gdelt_riots, replace)
graph export "paper/graphs/scad_gdelt_riots.pdf", replace

restore

corr gdelt_protests scad_events acled_days
corr gdelt_riots scad_riots

corr gdelt_unrest scad_unrest acled_unrest
corr riot_gdelt riot_scad

tab gdelt_unrest scad_unrest, cell
corr gdelt_unrest scad_unrest
local corr = round(r(rho),.0001)
quietly estpost tab gdelt_unrest scad_unrest
est sto SCAD
esttab using "paper/tables/gdelt_scad_unrest.tex", cell(pct(fmt(2) label(\%))) eqlabels(, lhs("GDELT")) addn("correlation = `corr'") unstack nonumber mti bookt replace

tab gdelt_unrest acled_unrest, cell
corr gdelt_unrest acled_unrest
local corr = round(r(rho),.0001)
quietly estpost tab gdelt_unrest acled_unrest
est sto ACLED
esttab using "paper/tables/gdelt_acled_unrest.tex", cell(pct(fmt(2) label(\%))) eqlabels(, lhs("GDELT")) addn("correlation = `corr'") unstack nonumber mti bookt replace

tab scad_unrest acled_unrest, cell
corr scad_unrest acled_unrest
local corr = round(r(rho),.0001)
quietly estpost tab acled_unrest scad_unrest
est sto ACLED
esttab using "paper/tables/scad_acled_unrest.tex", cell(pct(fmt(2) label(\%))) eqlabels(, lhs("GDELT")) addn("correlation = `corr'") unstack nonumber mti bookt replace

tab riot_gdelt riot_scad, cell
corr riot_gdelt riot_scad
local corr = round(r(rho),.0001)
quietly estpost tab riot_gdelt riot_scad
est sto SCAD
esttab using "paper/tables/gdelt_scad_riot.tex", cell(pct(fmt(2) label(\%))) eqlabels(, lhs("GDELT")) addn("correlation = `corr'") unstack nonumber mti bookt replace

exit

*log close
exit
