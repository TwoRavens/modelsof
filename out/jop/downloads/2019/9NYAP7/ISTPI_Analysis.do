* isis_taxes.do

local mypath "/Users/jbpetkun/Dropbox (MIT)/Grad School/Mara's Grad School/JOP Revisions/"
local today = subinstr("`c(current_date)'"," ","",.)

cap log close
log using "`mypath'Log/isis_taxes_`today'.txt", t replace

* Read in data
import excel using "`mypath'IsisData_20171008.xlsx", first clear

* Part switches
local part1 = 1
local part2 = 1

* Restrict sample
drop *sou* // drop source variables

* Rename variables
rename completeterritorialcontrolin isiscontrol
rename Oil* oil
rename Gas* gas
rename Hydro* hydro
rename Phosphate* phosphate
rename property property_tax

* Combine natural resources variables
egen natres = rowmax(oil gas hydro phosphate) 

* Recode missing as zero (if Isis was in control)
foreach var of varlist income_tax border_tax excise_tax service_fee fines licenses property_tax municipal_services ///
	police court oil gas hydro phosphate natres {
	recode `var' . = 0 if isiscontrol == 1 
}

* Code date variable
gen date_s = string(month)+"/1/"+string(year)
gen date = date(date_s,"MDY")
gen qtr = qofd(date)
gen monthyr = mofd(date)
format qtr %tq
format monthyr %tm

* Fix outlier in fines
recode fines 1184 = 1

* Plot aggregate time trends
if `part1' == 1 {
preserve 
	collapse (max) isiscontrol income_tax excise_tax border_tax service_fee fines licenses property_tax municipal_services police court oil gas hydro phosphate natres, by(qtr district)
	collapse (sum) isiscontrol income_tax excise_tax border_tax service_fee fines licenses property_tax municipal_services police court oil gas hydro phosphate natres, by(qtr)
	lab var isiscontrol "Total districts under IS control"
	lab var income_tax "Districts w/ Income Tax"
	lab var excise_tax "Districts w/ Excise Tax"
	lab var border_tax "Districts w/ Border Tax"
	lab var service_fee "Districts w/ Service Fees"
	lab var fines "Districs w/ Fines"
	lab var licenses "Districts w/ Licensure"
	lab var property_tax "Districts w/ Property Tax"
	lab var fines "Districts w/ Fines"	
	lab var police "Districts w/ Police"
	lab var court "Districts w/ Courts"
	lab var municipal_services "Districts w/ Municipal Services"
	lab var oil "Districts w/ Oil"
	lab var gas "Districts w/ Gas"
	lab var hydro "Districts w/ Hydroelectric Dams"
	lab var phosphate "Districts w/ Phosphate Mines"
	lab var natres "Districts w/ Any Natural Resource"
	
	twoway (connected isiscontrol qtr) (connected income_tax qtr, msymbol(diamond)) (connected excise_tax qtr, msymbol(triangle)) ///
		(connected border_tax qtr, msymbol(square)) (connected service_fee qtr, msymbol(circle)), ///
		title("Prevalance of IS Taxation Schemes, 2013 - 2016") xtitle("Year/Quarter") ytitle("# of Districts") graphregion(color(white)) bgcolor(white)
	graph export "`mypath'Output/Tax_timetrend_1.pdf", replace
	
	twoway (connected isiscontrol qtr) (connected fines qtr, msymbol(diamond)) (connected licenses qtr, msymbol(triangle)) (connected property_tax qtr, msymbol(square)), ///
		title("Prevalance of IS Taxation Schemes, 2013 - 2016") xtitle("Year/Quarter") ytitle("# of Districts") graphregion(color(white)) bgcolor(white)
	graph export "`mypath'Output/Tax_timetrend_2.pdf", replace
		
	twoway (connected isiscontrol qtr) (connected municipal_services qtr, msymbol(diamond)) (connected police qtr, msymbol(triangle)) ///
		(connected court qtr, msymbol(square)), ///
		title("Prevalance of IS Services, 2013 - 2016") xtitle("Year/Quarter") ytitle("# of Districts") graphregion(color(white)) bgcolor(white)		
	graph export "`mypath'Output/Service_timetrend.pdf", replace	
	
	twoway (connected isiscontrol qtr) (connected oil qtr, msymbol(diamond)) (connected gas qtr, msymbol(triangle)) ///
		(connected hydro qtr, msymbol(square)) (connected phosphate qtr, msymbol(circle)), ///
		title("Prevalance of Natural Resources in IS Territories, 2013 - 2016") xtitle("Year/Quarter") ytitle("# of Districts") graphregion(color(white)) bgcolor(white)		
	graph export "`mypath'Output/NatRes_timetrend.pdf", replace		
restore
}

* Pairwise Correlations & Mean Comparisons
* Collapse to 3-month observations
cd "`mypath'Output"

* District*quarter-level mean comparisons
if `part2' == 1 {
preserve
collapse (max) isiscontrol income_tax excise_tax border_tax service_fee fines licenses property_tax municipal_services ///
	police court oil gas hydro phosphate natres (first) province, by(qtr district)
corrtex income_tax excise_tax border_tax service_fee fines licenses property_tax police court municipal_services oil ///
	gas hydro phosphate natres, file(CorrelationMatrix) replace

foreach byvar in police court municipal_services oil gas hydro phosphate natres {
mat mean_sd_ctrl = J(8,2,.)
qui count if `byvar' == 0 & isiscontrol == 1
mat mean_sd_ctrl[1,1] = r(N)
local i = 2
foreach var in income_tax excise_tax border_tax service_fee fines licenses property_tax {
	qui summarize `var' if `byvar' == 0 & isiscontrol == 1
	mat mean_sd_ctrl[`i',1] = r(mean)
	mat mean_sd_ctrl[`i',2] = r(sd)
	local i = `i' + 1
}
mat mean_sd_treat = J(8,2,.)
qui count if `byvar' == 1 & isiscontrol == 1
mat mean_sd_treat[1,1] = r(N)
local i = 2
foreach var in income_tax excise_tax border_tax service_fee fines licenses property_tax {
	qui summarize `var' if `byvar' == 1 & isiscontrol == 1
	mat mean_sd_treat[`i',1] = r(mean)
	mat mean_sd_treat[`i',2] = r(sd)
	local i = `i' + 1
}
mat diff = J(8,2,.)
mat diff_stars = J(8,2,0)
qui count if isiscontrol == 1
mat diff[1,1] = r(N)
local i = 2
foreach var in income_tax excise_tax border_tax service_fee fines licenses property_tax {
	qui reg `var' `byvar' if isiscontrol == 1, cluster(province)
	boottest `byvar'
	mat CI = r(CI)
	local CI_spread = CI[1,2] - CI[1,1]
	local se_wild = `CI_spread'/(2*1.96)
	mat diff[`i',1] = _b[`byvar']
	*mat diff[`i',2] = _se[`byvar']
	mat diff[`i',2] = `se_wild'
/*	matrix diff_stars[`i',2] = ///
		(abs(_b[`byvar']/_se[`byvar']) > invttail(`e(df_r)',0.10/2)) + ///	
		(abs(_b[`byvar']/_se[`byvar']) > invttail(`e(df_r)',0.05/2)) + ///
		(abs(_b[`byvar']/_se[`byvar']) > invttail(`e(df_r)',0.01/2))	
*/
	matrix diff_stars[`i',2] = ///
		(abs(_b[`byvar']/`se_wild') > invttail(`e(df_r)',0.10/2)) + ///	
		(abs(_b[`byvar']/`se_wild') > invttail(`e(df_r)',0.05/2)) + ///
		(abs(_b[`byvar']/`se_wild') > invttail(`e(df_r)',0.01/2))		
	local i = `i' + 1
}
mat list diff_stars

qui frmttable, statmat(mean_sd_ctrl) substat(1) varlabels ctitles("","Mean (`byvar' = 0)") sdec(3) rtitles("N"\""\"Income Taxes"\""\"Excise Taxes"\""\"Border Taxes"\""\"Service Fees"\""\"Fines"\""\"Licensure"\""\"Property Taxes"\"")
qui frmttable, statmat(mean_sd_treat) substat(1) varlabels ctitles("","Mean (`byvar' = 1)") sdec(3) rtitles("N"\""\"Income Taxes"\""\"Excise Taxes"\""\"Border Taxes"\""\"Service Fees"\""\"Fines"\""\"Licensure"\""\"Property Taxes"\"") merge
frmttable using meancomp_`byvar', statmat(diff) substat(1) squarebrack annotate(diff_stars) asymbol(*,**,***) varlabels ///
	ctitles("","Difference in Means") sdec(3) rtitles("N"\""\"Income Taxes"\""\"Excise Taxes"\""\"Border Taxes"\""\"Service Fees"\""\"Fines"\""\"Licensure"\""\"Property Taxes"\"") title("Prevalence of IS Tax Schemes, by `byvar' (District*Quarter-level)") merge replace

qui frmttable, statmat(mean_sd_ctrl) substat(1) varlabels ctitles("Mean (`byvar' = 0)") sdec(3) tex
qui frmttable, statmat(mean_sd_treat) substat(1) varlabels ctitles("Mean (`byvar' = 1)") sdec(3) merge
frmttable using meancomp_`byvar', statmat(diff) substat(1) squarebrack annotate(diff_stars) asymbol(*,**,***) varlabels ///
	ctitles("Difference in Means") rtitles("N"\""\"Income Taxes"\""\"Excise Taxes"\""\"Border Taxes"\""\"Service Fees"\""\"Fines"\""\"Licensure"\""\"Property Taxes") sdec(3) merge tex replace
}
restore

* District-level mean comparisons
collapse (max) isiscontrol income_tax excise_tax border_tax service_fee fines licenses property_tax municipal_services ///
	police court oil gas hydro phosphate natres, by(district)
corrtex income_tax excise_tax border_tax service_fee fines licenses property_tax police court municipal_services oil ///
	gas hydro phosphate natres, file(CorrelationMatrix) replace

foreach byvar in police court municipal_services oil gas hydro phosphate natres {
mat mean_sd_ctrl = J(8,2,.)
qui count if `byvar' == 0 & isiscontrol == 1
mat mean_sd_ctrl[1,1] = r(N)
local i = 2
foreach var in income_tax excise_tax border_tax service_fee fines licenses property_tax {
	qui summarize `var' if `byvar' == 0 & isiscontrol == 1
	mat mean_sd_ctrl[`i',1] = r(mean)
	mat mean_sd_ctrl[`i',2] = r(sd)
	local i = `i' + 1
}
mat mean_sd_treat = J(8,2,.)
qui count if `byvar' == 1 & isiscontrol == 1
mat mean_sd_treat[1,1] = r(N)
local i = 2
foreach var in income_tax excise_tax border_tax service_fee fines licenses property_tax {
	qui summarize `var' if `byvar' == 1 & isiscontrol == 1
	mat mean_sd_treat[`i',1] = r(mean)
	mat mean_sd_treat[`i',2] = r(sd)
	local i = `i' + 1
}
mat diff = J(8,2,.)
mat diff_stars = J(8,2,0)
qui count if isiscontrol == 1
mat diff[1,1] = r(N)
local i = 2
foreach var in income_tax excise_tax border_tax service_fee fines licenses property_tax {
	qui reg `var' `byvar' if isiscontrol == 1
	boottest `byvar'
	mat CI = r(CI)
	local CI_spread = CI[1,2] - CI[1,1]
	local se_wild = `CI_spread'/(2*1.96)
	mat diff[`i',1] = _b[`byvar']
	*mat diff[`i',2] = _se[`byvar']
	mat diff[`i',2] = `se_wild'	
/*	matrix diff_stars[`i',2] = ///
		(abs(_b[`byvar']/_se[`byvar']) > invttail(`e(df_r)',0.10/2)) + ///	
		(abs(_b[`byvar']/_se[`byvar']) > invttail(`e(df_r)',0.05/2)) + ///
		(abs(_b[`byvar']/_se[`byvar']) > invttail(`e(df_r)',0.01/2))	
*/
	matrix diff_stars[`i',2] = ///
		(abs(_b[`byvar']/`se_wild') > invttail(`e(df_r)',0.10/2)) + ///	
		(abs(_b[`byvar']/`se_wild') > invttail(`e(df_r)',0.05/2)) + ///
		(abs(_b[`byvar']/`se_wild') > invttail(`e(df_r)',0.01/2))	
	local i = `i' + 1
}
mat list diff_stars

qui frmttable, statmat(mean_sd_ctrl) substat(1) varlabels ctitles("","Mean (`byvar' = 0)") sdec(3) rtitles("N"\""\"Income Taxes"\""\"Excise Taxes"\""\"Border Taxes"\""\"Service Fees"\""\"Fines"\""\"Licensure"\""\"Property Taxes"\"")
qui frmttable, statmat(mean_sd_treat) substat(1) varlabels ctitles("","Mean (`byvar' = 1)") sdec(3) rtitles("N"\""\"Income Taxes"\""\"Excise Taxes"\""\"Border Taxes"\""\"Service Fees"\""\"Fines"\""\"Licensure"\""\"Property Taxes"\"") merge
frmttable using meancomp_`byvar'_district, statmat(diff) substat(1) squarebrack annotate(diff_stars) asymbol(*,**,***) varlabels ///
	ctitles("","Difference in Means") sdec(3) rtitles("N"\""\"Income Taxes"\""\"Excise Taxes"\""\"Border Taxes"\""\"Service Fees"\""\"Fines"\""\"Licensure"\""\"Property Taxes"\"") title("Prevalence of IS Tax Schemes, by `byvar' (District-level)") merge replace

qui frmttable, statmat(mean_sd_ctrl) substat(1) varlabels ctitles("Mean (`byvar' = 0)") sdec(3) tex
qui frmttable, statmat(mean_sd_treat) substat(1) varlabels ctitles("Mean (`byvar' = 1)") sdec(3) merge
frmttable using meancomp_`byvar'_district, statmat(diff) substat(1) squarebrack annotate(diff_stars) asymbol(*,**,***) varlabels ///
	ctitles("Difference in Means (District-Level)") rtitles("N"\""\"Income Taxes"\""\"Excise Taxes"\""\"Border Taxes"\""\"Service Fees"\""\"Fines"\""\"Licensure"\""\"Property Taxes") sdec(3) merge tex replace
}
}
