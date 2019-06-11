/************************************************************************** A do file for "Asking About Numbers"		 ** By Ansolabehere, Meredith, and Snowberg							 **************************************************************************/cd "C:\Users\marcmere\Dropbox\asking\Replication\"
//cd "/Users/snowberg/Documents/Dropbox/asking/Replication"
cap log close
log using "replicateTablesAndFigures.log", replace

drop _allclear allset mem 100mset matsize 100set more 1
local seedvalue = 12345
local num_bootstraps = 1000

global bandwidth=.8global poly=1
/************************************************************************** single dimension lowess program							 **************************************************************************/#delimit crcap program drop wtlowessprogram define wtlowess 	version 9.2	syntax varlist(min=2 max=2 numeric) [if] [fweight/] [, GENerate(string) BWidth(real 0.8) POLY(real 1) NODOTS STDP]	marksample touse	tokenize `varlist'	local y `1'	local x `2'	confirm new var `generate'	qui gen `generate'=.	confirm new var `generate'_stdp	qui gen `generate'_stdp=.	local bw=`bwidth'	if `bw'<=0 | `bw'>=1 {	 		local bw .8		}	local p=`poly'	if `p'<0 {		local `p'=1		}	qui summ `x' `if'	local nobs=r(N)	qui summ `x' `if' [fw = `exp']	local nwt=r(N)	local k=(`nwt'*`bwidth'-0.5)/2		tempvar n nlower nupper nmid xplusy	qui gen `xplusy'=`x'+`y' `if'	sort `x'	gen `n'=_n	gen `nupper'=sum(`exp')+0.5	gen `nlower'=max(`nupper'[_n-1],0.5)	gen `nmid'=(`nlower'+`nupper')/2	display("`nobs' loops to process")	forvalues i=0/`p' {		tempvar v_`i'		gen `v_`i''=`x'^`i'		local rhs `rhs' `v_`i''		}	forvalues i=1/`nobs' {		tempvar tricube triwt prediction pred_stdp		if `i'==round(`i',500) & "`nodots'"=="" {				display("Loop `i'")		}		local xi=`x'[`i']		local nmidi=`nmid'[`i']		local i_lower=max(1,`nmidi'-`k')		local i_upper=min(`nmidi'+`k',`nwt')		qui summ `x' if `nlower'<=`i_lower' & `nupper'>=`i_lower'		local xi_lower=r(mean)		qui summ `x' if `nlower'<=`i_upper' & `nupper'>=`i_upper'		local xi_upper=r(mean)		local delta=1.0001*max(`xi_upper'-`xi', `xi'-`xi_lower')		* qui gen `tricube'=(1-(abs(`x'-`xi')/`delta')^3)^3		qui gen `tricube'=max(0,(1-(abs(`x'-`xi')/`delta')^3)^3) /*creates variable with nascent tricube weight for all x relative to xi; created for all obs; zero for those outside neighborhood*/		qui replace `tricube'=`tricube'*min(1,max(0,(min(`nupper', `i_upper') - max(`nlower',`i_lower'))/(`nupper'-`nlower'))) /*linear weight if bw ends in a specified bin */		qui gen `triwt'=`exp'*`tricube'		qui summ `xplusy' `if' [aw=`triwt']		if r(N)>`p' {			qui reg `y' `rhs' `if' [aw=`triwt']			qui predict `prediction'			qui predict `pred_stdp', stdp		}		else {  // If bandwidth is too small, just give me the mean (unless the observation has 0 weight, in which case leave missing)			qui gen `prediction'=`y' if `n'==`i' & `exp'>0			qui replace `prediction'=. if `n'==`i' & `exp'<=0			qui gen `pred_stdp'=. if `n'==`i' 		}		qui replace `generate'=`prediction' if `n'==`i' 		qui replace `generate'_stdp=`pred_stdp' if `n'==`i' & `pred_stdp'>0		drop `prediction' `pred_stdp' `tricube' `triwt'	}	drop `n' `nupper' `nlower' `nmid' `xplusy'end



//
// 2006 ANES Regressions
//

insheet using gasprices06.csv, comma clear
keep fips october
rename fips STATE
rename october ActGasPrice
replace ActGasPrice = ActGasPrice / 100
sort STATE
save temp.dta, replace

use UnemploymentByState.dta, clear
keep FIPSstate oct2006
rename FIPSstate STATE
rename oct2006 ActUnemploy
sort STATE
save temp1.dta, replace

use anes2004TS.dta, clear
rename V040001 ID
sort ID
save temp2.dta, replace

use anes2006pilot.dta, clear
rename V06P102 STATE
sort STATE
merge n:1 STATE using temp.dta
drop if _merge == 2
drop _merge
erase temp.dta
sort STATE
merge n:1 STATE using temp1.dta
drop if _merge == 2
drop _merge
erase temp1.dta
rename V06P001 ID
sort ID
merge 1:1 ID using temp2.dta
keep if _merge == 3
drop _merge
erase temp2.dta

// Gas Prices (Table 1)

tab V06P548
rename V06P548 RptGasPrice
replace RptGasPrice = . if RptGasPrice == 88

gen Bias = (RptGasPrice - ActGasPrice)
count if (Bias < -1 | Bias > 1) & missing(Bias) == 0
replace Bias = -1 if Bias < -1 & missing(Bias) == 0
replace Bias = 1 if Bias > 1 & missing(Bias) == 0
gen Accuracy = -abs(Bias)

tab V06P680
gen Dem = (V06P680 == 0 | V06P680 == 1) 
label variable Dem "Democrat"
gen Ind = (V06P680 == 2 | V06P680 == 3 | V06P680 == 4)
label variable Ind "Independent"
gen OthPty = (V06P680 == 7 | V06P680 == 9)

tab V06P006 
gen Age1844 = (V06P006 >= 18 & V06P006 < 45)
label variable Age1844 "Age 18 - 44"
gen Age4564 = (V06P006 >= 45 & V06P006 < 65)
label variable Age4564 "Age 45 - 64"

tab V06P005
gen Female = (V06P005 == 2)

tab V043251
gen Married = (V043251 == 1)

tab V043299
gen Black = (V043299 == 10 | V043299 == 12)
gen Hispanic = (V043299 == 12 | V043299 == 40)

tab V043254
gen SomeCollege = (V043254 == 4 | V043254 == 5)
label variable SomeCollege "Some College"
gen BADegree = (V043254 == 6 | V043254 == 7)
label variable BADegree "Bachelor's Degree"

tab V043293x
gen IncomeU20k = (V043293x >= 1 & V043293x <= 9)
label variable IncomeU20k "Income Less Than \\\$20,000"
gen Income2040k = (V043293x >= 10 & V043293x <= 14)
label variable Income2040k "Income Between \\\$20,000 and \\\$40,000"
gen Income4080k = (V043293x >= 15 & V043293x <= 19)
label variable Income4080k "Income Between \\\$40,000 and \\\$80,000"
gen Income80120k = (V043293x >= 20 & V043293x <= 22)  
label variable Income80120k "Income Between \\\$80,000 and \\\$120,000"
gen MissingIncome = (V043293x == 0 | V043293x == 88 | V043293x == 89)

tab V043260a
gen Unemployed = (V043260a == 20 | V043260a == 40)

tab V06P549
gen DrivePerWeek = V06P549
label variable DrivePerWeek "Days Driving Per Week"

tab V06P550
gen NoticePerWeek = V06P550
replace NoticePerWeek = . if NoticePerWeek == 888 | NoticePerWeek == 999
replace NoticePerWeek = 7 if NoticePerWeek > 7 & missing(NoticePerWeek) == 0
label variable NoticePerWeek "Days Notice Gas Prices Per Week"

tab V06P554x
gen ChurchWeekly = (V06P554x == 0 | V06P554x == 1)
gen ChurchSometimes = (V06P554x == 2 | V06P554x == 3 | V06P554x == 4)

tab V043290
gen Union = (V043290 == 1)

gen Sample = 1
foreach var of varlist Bias-Union {
replace Sample = 0 if missing(`var') == 1
}

regress Bias if Sample 
local Mean = _b[_cons]
qreg Bias if Sample 
local Median = _b[_cons]
regress Bias Dem-Union if Sample 
outreg2 Dem-Ind Age1844-Income80120k Unemployed-NoticePerWeek using Table1.tex, /*
*/ replace tex(pretty)  stats(coef se) parenthesis(se) label /*
*/ alpha(.01,.05,.1) symbol(***, **, *) dec(3) nor2 addstat(Mean, `Mean', Median, `Median') nonotes 

regress Accuracy if Sample 
local Mean = _b[_cons]
qreg Accuracy if Sample 
local Median = _b[_cons]
regress Accuracy Dem-Union if Sample
outreg2 Dem-Ind Age1844-Income80120k Unemployed-NoticePerWeek using Table1.tex, /*
*/ append tex(pretty) stats(coef se) parenthesis(se) label /*
*/ alpha(.01,.05,.1) symbol(***, **, *) dec(3) nor2 noobs addstat(Mean, `Mean', Median, `Median') nonotes 

/************************************************************************** histograms of gas prices in 2006		**************************************************************************/
gen rptGasPriceTC = RptGasPrice
replace rptGasPriceTC = 1.25 if rptGasPriceTC < 1.25 
replace rptGasPriceTC = 4 if rptGasPriceTC > 4 & RptGasPrice ~= . 

#delimit;hist rptGasPriceTC if Sample,	width(.2) start(1) percent	lcolor(black) fcolor(gs10)	ytitle("")	ylabel(0 "0" 10 "10%" 20 "20%" 30 "30%" 40 "40%" 50 "50%", angle(horizontal)) 	yline(50, lcolor(gs15))	xlabel(0 "$0" .5 "$0.50" 1 "$1" 1.5 "$1.50" 2 "$2" 2.5 "$2.50" 3 "$3" 3.5 "$3.50" 4 "$4")	xtitle("November, 2006 (ANES Pilot: N = 668)")	xline(2.26, lwidth(thick) lcolor(red))	text(36 2.26 "Average Actual Price" " " "(in Sample)", orientation(vertical))	graphregion(color(gs16))	saving(reportedPrice06, replace);

#delimit cr
gen error = 100*(rptGasPriceTC - ActGasPrice) gen errorTC = errorreplace errorTC = -100 if error < -100replace errorTC = 100 if error > 100 & error ~= .

#delimit;hist errorTC if Sample,	width(10) start(-100) percent	lcolor(black) fcolor(gs10)	ytitle("")	ylabel(0 "0" 10 "10%" 20 "20%" 30 "30%", angle(horizontal))	xlabel(-100 "-$1" -50 "-$0.50" 0 "$0" 50 "$0.50" 100 "$1")	xtitle("November, 2006 (ANES: N = 668)")	graphregion(color(gs16))	saving(error06, replace);

#delimit cr	
drop Bias-Sample

// ANES Unemployment (Table A.2)

tab V06P551
gen RptUnemploy = V06P551
replace RptUnemploy = . if V06P551 == 888

tab V06P680
gen Dem = (V06P680 == 0 | V06P680 == 1) 
label variable Dem "Democrat"
gen Ind = (V06P680 == 2 | V06P680 == 3 | V06P680 == 4)
label variable Ind "Independent"
gen OthPty = (V06P680 == 7 | V06P680 == 9)

tab V06P006 
gen Age1824 = (V06P006 >= 18 & V06P006 < 25)
label variable Age1824 "Age 18 - 24"
gen Age2544 = (V06P006 >= 25 & V06P006 < 44)
label variable Age2544 "Age 25 - 44"
gen Age4564 = (V06P006 >= 45 & V06P006 < 65)
label variable Age4564 "Age 45 - 64"

tab V06P005
tab V043251

gen MarriedXMale = (V043251 == 1)*(V06P005 == 1)
label variable MarriedXMale "Married Male"
gen UnmarriedXFemale = (V043251 ~= 1)*(V06P005 == 2)
label variable UnmarriedXFemale "Unmarried Female"
gen MarriedXFemale = (V043251 == 1)*(V06P005 == 2)
label variable MarriedXFemale "Married Female"

tab V043299
gen Black = (V043299 == 10 | V043299 == 12)
gen Hispanic = (V043299 == 12 | V043299 == 40)

tab V043254
gen SomeCollege = (V043254 == 4 | V043254 == 5)
label variable SomeCollege "Some College"
gen BADegree = (V043254 == 6 | V043254 == 7)
label variable BADegree "Bachelor's Degree"

tab V043293x
gen IncomeU20k = (V043293x >= 1 & V043293x <= 9)
label variable IncomeU20k "Income Less Than \\\$20,000"
gen Income2040k = (V043293x >= 10 & V043293x <= 14)
label variable Income2040k "Income Between \\\$20,000 and \\\$40,000"
gen Income4080k = (V043293x >= 15 & V043293x <= 19)
label variable Income4080k "Income Between \\\$40,000 and \\\$80,000"
gen Income80120k = (V043293x >= 20 & V043293x <= 22)  
label variable Income80120k "Income Between \\\$80,000 and \\\$120,000"
gen MissingIncome = (V043293x == 0 | V043293x == 88 | V043293x == 89)

tab V043260a
gen Unemployed = (V043260a == 20 | V043260a == 40)

tab ActUnemploy
gen StateUnemp = ActUnemploy
label variable StateUnemp "State Unemployment"

tab V06P554x
gen ChurchWeekly = (V06P554x == 0 | V06P554x == 1)
gen ChurchSometimes = (V06P554x == 2 | V06P554x == 3 | V06P554x == 4)

tab V043290
gen Union = (V043290 == 1)

gen Sample = 1
foreach var of varlist RptUnemploy-Union {
replace Sample = 0 if missing(`var') == 1
}

gsort - Sample + RptUnemploy 
gen temp = 1 if _n == 1
replace temp = temp[_n-1] + 1 if _n > 1 & Sample
egen temp2 = mean(temp), by(RptUnemploy) 
egen temp3 = max(temp), by(Sample)
gen Percentile = 100*temp2 / temp3
drop temp temp2 temp3
save "temp.dta", replace

use temp.dta, clear
keep if Sample
qreg RptUnemploy Dem-Union,  quantile(.5)
matrix observe = e(b)
capture program drop myboot
program define myboot, eclass
preserve
bsample, cluster(STATE)
qreg RptUnemploy Dem-Union, quantile(.5)
restore
end
simulate _b, reps(`num_bootstraps') seed(`seedvalue'): myboot
bstat, stat(observe)
outreg2 _b_Dem-_b_Ind _b_Age1824-_b_Income80120k _b_Unemployed _b_StateUnemp using TableA2a.tex, /*
*/ replace tex(pretty)  stats(coef se) parenthesis(se) label /*
*/ alpha(.01,.05,.1) symbol(***, **, *) dec(2) nor2 noobs nonotes 

use temp.dta, clear
regress Percentile Dem-Union if Sample, cluster(STATE)
outreg2 Dem-Ind Age1824-Income80120k Unemployed StateUnemp using TableA2b.tex, /*
*/ replace tex(pretty)  stats(coef se) parenthesis(se) label /*
*/ alpha(.01,.05,.1) symbol(***, **, *) dec(2) nor2 noobs nonotes 

erase temp.dta

//
// 2008 Harvard CCES Regressions
//

insheet using gasprices08.csv, comma clear
keep state_fips priceoct
rename state_fips STATE
rename priceoct ActGasPrice
replace ActGasPrice = ActGasPrice / 100
sort STATE
save temp.dta, replace

use UnemploymentByState.dta, clear
keep FIPSstate oct2008
rename FIPSstate STATE
rename oct2008 ActUnemploy
sort STATE
save temp1.dta, replace

use cces08_harvard_output.dta, clear
rename v206 STATE
sort STATE
merge n:1 STATE using temp.dta
drop if _merge == 2
drop _merge
erase temp.dta
sort STATE
merge n:1 STATE using temp1.dta
drop if _merge == 2
drop _merge
erase temp1.dta

// Gas Prices (Table 1 and A1)

tab hum304
rename hum304 RptGasPrice

gen Bias = (RptGasPrice - ActGasPrice)
count if (Bias < -1 | Bias > 1) & missing(Bias) == 0
replace Bias = -1 if Bias < -1 & missing(Bias) == 0
replace Bias = 1 if Bias > 1 & missing(Bias) == 0
gen Accuracy = -abs(Bias)

tab cc307a
gen Dem = (cc307a == 1 | cc307a == 2) 
label variable Dem "Democrat"
gen Ind = (cc307a == 3 | cc307a == 4 | cc307a == 5)
label variable Ind "Independent"
gen OthPty = (cc307a == 8 | missing(cc307a))

tab v207 
gen Age1844 = (v207 >= 1964 & v207<= 1990)
label variable Age1844 "Age 18 - 44"
gen Age4564 = (v207 >= 1944 & v207 <= 1963)
label variable Age4564 "Age 45 - 64"

tab v208
gen Female = (v208 == 2)

tab v214
gen Married = (v214 == 1)

tab v211
gen Black = (v211 == 2)
gen Hispanic = (v211 == 3)

tab v213
gen SomeCollege = (v213 == 3 | v213 == 4)
label variable SomeCollege "Some College"
gen BADegree = (v213 == 5 | v213 == 6)
label variable BADegree "Bachelor's Degree"

tab v246
gen IncomeU20k = (v246 >= 1 & v246 <= 3)
label variable IncomeU20k "Income Less Than \\\$20,000"
gen Income2040k = (v246 >= 4 & v246 <= 6)
label variable Income2040k "Income Between \\\$20,000 and \\\$40,000"
gen Income4080k = (v246 >= 7 & v246 <= 10)
label variable Income4080k "Income Between \\\$40,000 and \\\$80,000"
gen Income80120k = (v246 >= 11 & v246<= 12)  
label variable Income80120k "Income Between \\\$80,000 and \\\$120,000"
gen MissingIncome = (v246 == 15)

tab v209
gen Unemployed = (v209 == 3 | v209 == 4)

tab v217
gen ChurchWeekly = (v217 == 1 | v217 == 2)
gen ChurchSometimes = (v217  == 3 | v217 == 4)

tab cc329
gen Union = (cc329 == 2 | cc329 == 3 | cc329 == 4)

gen Sample = 1
foreach var of varlist Bias-Union {
replace Sample = 0 if missing(`var') == 1
}

regress Bias if Sample 
local Mean = _b[_cons]
qreg Bias if Sample 
local Median = _b[_cons]
regress Bias Dem-Union if Sample 
outreg2 Dem-Ind Age1844-Income80120k Unemployed using Table1.tex, /*
*/ append tex(pretty) stats(coef se) parenthesis(se) label /*
*/ alpha(.01,.05,.1) symbol(***, **, *) dec(3) nor2 addstat(Mean, `Mean', Median, `Median') nonotes 

regress Accuracy if Sample 
local Mean = _b[_cons]
qreg Accuracy if Sample 
local Median = _b[_cons]
regress Accuracy Dem-Union if Sample
outreg2 Dem-Ind Age1844-Income80120k Unemployed using Table1.tex, /*
*/ append tex(pretty) stats(coef se) parenthesis(se) label /*
*/ alpha(.01,.05,.1) symbol(***, **, *) dec(3) nor2 noobs addstat(Mean, `Mean', Median, `Median') nonotes 

/************************************************************************** histograms of gas prices in October, 2008		**************************************************************************/
gen rptGasPriceTC = RptGasPrice
replace rptGasPriceTC = 2.15 if rptGasPriceTC < 2.15replace rptGasPriceTC = 4 if rptGasPriceTC > 4 & RptGasPrice ~= . 

#delimit;hist rptGasPriceTC if Sample,	width(.2) start(1) percent	lcolor(black) fcolor(gs10)	ytitle("")	ylabel(0 "0" 10 "10%" 20 "20%" 30 "30%" 40 "40%" 50 "50%", angle(horizontal)) 	yline(30, lcolor(gs15))	yline(40, lcolor(gs15))	yline(50, lcolor(gs15))	xlabel(0 "$0" .5 "$0.50" 1 "$1" 1.5 "$1.50" 2 "$2" 2.5 "$2.50" 3 "$3" 3.5 "$3.50" 4 "$4")	xtitle("October, 2008 (CCES: N = 2,985)")	xline(2.94, lwidth(thick) lcolor(red))	text(36 2.94 "Average Actual Price" " " "(in Sample)", orientation(vertical))	graphregion(color(gs16))	saving(reportedPriceOct08, replace);

#delimit cr
gen error = 100*(rptGasPriceTC - ActGasPrice) gen errorTC = errorreplace errorTC = -100 if error < -100replace errorTC = 100 if error > 100 & error ~= .

#delimit;hist errorTC if Sample,	width(10) start(-100) percent	lcolor(black) fcolor(gs10)	ytitle("")	ylabel(0 "0" 10 "10%" 20 "20%" 30 "30%", angle(horizontal))	yline(30, lcolor(gs15))	xlabel(-100 "-$1" -50 "-$0.50" 0 "$0" 50 "$0.50" 100 "$1")	xtitle("October, 2008 (CCES: N = 2,985)")	graphregion(color(gs16))	saving(errorOct08, replace);

#delimit cr	
drop Bias-Sample

// Unemployment Rate (Table 2)

tab hum302
gen RptUnemploy = hum302

tab cc302 
gen RetroEcon = cc302 if cc302 <= 5 

tab cc303a
gen CCCurBus = cc303a if cc303a <= 3

tab cc303b
gen CCCurEmploy = cc303b if cc303b <= 3

tab cc307a
gen Dem = (cc307a == 1 | cc307a == 2) 
label variable Dem "Democrat"
gen Ind = (cc307a == 3 | cc307a == 4 | cc307a == 5)
label variable Ind "Independent"
gen OthPty = (cc307a == 8 | missing(cc307a))

tab v207 
gen Age1824 = (v207 >= 1984 & v207<= 1990)
label variable Age1824 "Age 18 - 24"
gen Age2544 = (v207 >= 1964 & v207<= 1983)
label variable Age2544 "Age 25 - 44"
gen Age4564 = (v207 >= 1944 & v207 <= 1963)
label variable Age4564 "Age 45 - 64"

tab v208
tab v214
gen MarriedXMale = (v214 == 1)*(v208 == 1)
label variable MarriedXMale "Married Male"
gen UnmarriedXFemale = (v214 ~= 1)*(v208 == 2)
label variable UnmarriedXFemale "Unmarried Female"
gen MarriedXFemale = (v214 == 1)*(v208 == 2)
label variable MarriedXFemale "Married Female"

tab v211
gen Black = (v211 == 2)
gen Hispanic = (v211 == 3)

tab v213
gen SomeCollege = (v213 == 3 | v213 == 4)
label variable SomeCollege "Some College"
gen BADegree = (v213 == 5 | v213 == 6)
label variable BADegree "Bachelor's Degree"

tab v246
gen IncomeU20k = (v246 >= 1 & v246 <= 3)
label variable IncomeU20k "Income Less Than \\\$20,000"
gen Income2040k = (v246 >= 4 & v246 <= 6)
label variable Income2040k "Income Between \\\$20,000 and \\\$40,000"
gen Income4080k = (v246 >= 7 & v246 <= 10)
label variable Income4080k "Income Between \\\$40,000 and \\\$80,000"
gen Income80120k = (v246 >= 11 & v246<= 12)  
label variable Income80120k "Income Between \\\$80,000 and \\\$120,000"
gen MissingIncome = (v246 == 15)

tab v209
gen Unemployed = (v209 == 3 | v209 == 4)

tab ActUnemploy
gen StateUnemp = ActUnemploy
label variable StateUnemp "State Unemployment"

tab v217
gen ChurchWeekly = (v217 == 1 | v217 == 2)
gen ChurchSometimes = (v217  == 3 | v217 == 4)

tab cc329
gen Union = (cc329 == 2 | cc329 == 3 | cc329 == 4)

gen Sample = 1
foreach var of varlist RptUnemploy-Union {
replace Sample = 0 if missing(`var') == 1
}

/************************************************************************** unemployment histogram for 2008, benchmarked	**************************************************************************/
gen rptUnemployTC = RptUnemploy
replace rptUnemployTC = 50 if rptUnemployTC > 50 & RptUnemploy ~= .

#delimit;hist rptUnemployTC if Sample,	width(1) start(0) percent	lcolor(black) fcolor(gs10)	ytitle("")	ylabel(0 "0" 10 "10%" 20 "20%" 30 "30%" 40 "40%", angle(horizontal))	xlabel(0 "0" 10 "10%" 20 "20%" 30 "30%" 40 "40%" 50 "50%") 	xtitle("Responses to Benchmarked Question, 2008 (N = 2,943)")	graphregion(color(gs16))	saving(unemploymentFramed, replace);

#delimit cr		
gsort - Sample + RptUnemploy 
gen temp = 1 if _n == 1
replace temp = temp[_n-1] + 1 if _n > 1 & Sample
egen temp2 = mean(temp), by(RptUnemploy) 
egen temp3 = max(temp), by(Sample)
gen Percentile = 100*temp2 / temp3
drop temp temp2 temp3
save "temp.dta", replace

use temp.dta, clear
keep if Sample
qreg RptUnemploy Dem-Union,  quantile(.5)
matrix observe = e(b)
capture program drop myboot
program define myboot, eclass
preserve
bsample, cluster(STATE)
qreg RptUnemploy Dem-Union, quantile(.5)
restore
end
simulate _b, reps(`num_bootstraps') seed(`seedvalue'): myboot
bstat, stat(observe)
outreg2 _b_Dem-_b_Ind _b_Age1824-_b_Income80120k _b_Unemployed _b_StateUnemp using Table2a.tex, /*
*/ replace tex(pretty)  stats(coef se) parenthesis(se) label /*
*/ alpha(.01,.05,.1) symbol(***, **, *) dec(2) nor2 noobs nonotes 
outreg2 _b_Dem-_b_Ind _b_Age1824-_b_Income80120k _b_Unemployed _b_StateUnemp using TableA1a.tex, /*
*/ replace tex(pretty)  stats(coef se) parenthesis(se) label /*
*/ alpha(.01,.05,.1) symbol(***, **, *) dec(2) nor2 noobs nonotes 
matrix coeff_benchmark_lad = e(b)
matrix var_benchmark_lad = e(V)

use temp.dta, clear
regress Percentile Dem-Union if Sample, cluster(STATE)
outreg2 Dem-Ind Age1824-Income80120k Unemployed StateUnemp using Table2b.tex, /*
*/ replace tex(pretty)  stats(coef se) parenthesis(se) label /*
*/ alpha(.01,.05,.1) symbol(***, **, *) dec(2) nor2 noobs nonotes 
outreg2 Dem-Ind Age1824-Income80120k Unemployed StateUnemp using TableA1b.tex, /*
*/ replace tex(pretty)  stats(coef se) parenthesis(se) label /*
*/ alpha(.01,.05,.1) symbol(***, **, *) dec(2) nor2 noobs nonotes 
matrix coeff_benchmark_pct = e(b)
matrix var_benchmark_pct = e(V)

erase temp.dta

// Table 3

regress RetroEcon Dem-Union if Sample, robust cluster(STATE)
outreg2 Dem-Ind Age1824-Income80120k Unemployed StateUnemp using Table3.tex, /*
*/ replace tex(pretty)  stats(coef se) parenthesis(se) label /*
*/ alpha(.01,.05,.1) symbol(***, **, *) dec(2) nor2 noobs nonotes 
regress CCCurBus Dem-Union if Sample, robust cluster(STATE)
outreg2 Dem-Ind Age1824-Income80120k Unemployed StateUnemp using Table3.tex, /*
*/ append tex(pretty) stats(coef se) parenthesis(se) label /*
*/ alpha(.01,.05,.1) symbol(***, **, *) dec(2) nor2 noobs nonotes 
regress CCCurEmploy Dem-Union if Sample, robust cluster(STATE)
outreg2 Dem-Ind Age1824-Income80120k Unemployed StateUnemp using Table3.tex, /*
*/ append tex(pretty) stats(coef se) parenthesis(se) label /*
*/ alpha(.01,.05,.1) symbol(***, **, *) dec(2) nor2 noobs nonotes 

//  Table 4

gen Rep = (cc307a == 6 | cc307a == 7) 
gen RptUnempOrd = 1*(RptUnemploy < 5.6) + 2*(RptUnemploy >= 5.6 & RptUnemploy <= 7.0) + 3*(RptUnemploy > 7.0)

tab CCCurEmploy if Rep & Sample, matcell(temp1)
matrix temp2 = temp1 * 100 / r(N)
tab CCCurEmploy if Ind & Sample, matcell(temp3)
matrix temp4 = temp3 * 100 / r(N)
tab CCCurEmploy if Dem & Sample, matcell(temp5)
matrix temp6 = temp5 * 100 / r(N)
matrix temp7 = temp1 + temp3 + temp5
matrix temp8 = temp7,temp2,temp4,temp6

tab RptUnempOrd if Rep & Sample, matcell(temp9)
matrix temp10 = temp9 * 100 / r(N)
tab RptUnempOrd if Ind & Sample, matcell(temp11)
matrix temp12 = temp11 * 100 / r(N)
tab RptUnempOrd if Dem & Sample, matcell(temp13)
matrix temp14 = temp13 * 100 / r(N)
matrix temp15 = temp9 + temp11 + temp13
matrix temp16 = temp15,temp10,temp12,temp14

matrix temp = temp8 \ temp16
matlist temp

//  Table 5

local i = 0

forvalues j = 1(1)3 {
foreach var of varlist Rep Ind Dem {
qui centile RptUnemploy if Sample & `var' & CCCurEmploy == `j', centile(25 50 75)
display r(c_25)
local i = `i' + 1
matrix crap`i' = r(c_1),r(c_2),r(c_3)   
}
}

matrix crap = crap1
forvalues i = 2(1)9 {
matrix crap = crap \ crap`i'
}
matlist crap

//  Table A3

tab cc327
gen Obama = 0 if cc327 == 1
replace Obama = 1 if cc327 == 2

gen Centered = (RptUnemploy - 10.8)
gen Above = (RptUnemploy >  10.8)
gen CenteredXBelow = Centered * (1 - Above)
gen CenteredXAbove = Centered * Above

matrix AppendixA3 = J(8, 8, 0)
local i = 1
foreach var of varlist CCCurEmploy RetroEcon CCCurBus Obama {
regress `var' CenteredXBelow CenteredXAbove Above if Sample, robust
matrix AppendixA3[1, `i'] = _b[CenteredXBelow]
matrix AppendixA3[2, `i'] = _se[CenteredXBelow]
matrix AppendixA3[3, `i'] = _b[CenteredXAbove]
matrix AppendixA3[4, `i'] = _se[CenteredXAbove]
matrix AppendixA3[5, `i'] = _b[Above]
matrix AppendixA3[6, `i'] = _se[Above]
matrix AppendixA3[7, `i'] = _b[_cons]
matrix AppendixA3[8, `i'] = _se[_cons]
local i = `i' + 2
}
save tmpBenchmarked, replace

//
// 2008 Caltech CCES Regressions
//

use UnemploymentByState.dta, clear
keep FIPSstate oct2008
rename FIPSstate STATE
rename oct2008 ActUnemploy
sort STATE
save temp1.dta, replace

use CCES08_CAL_OUTPUT_mod.dta, clear
rename v206 STATE
sort STATE
merge n:1 STATE using temp1.dta
drop if _merge == 2
drop _merge
erase temp1.dta

// Unemployment Rate (Table 2)

tab cal348
tab cal349
gen RptUnemploy = cal348
replace RptUnemploy = cal349 if missing(cal348)

tab cc302 
gen RetroEcon = cc302 if cc302 <= 5 

tab cc303a
gen CCCurBus = cc303a if cc303a <= 3

tab cc303b
gen CCCurEmploy = cc303b if cc303b <= 3

tab cc307a
gen Dem = (cc307a == 1 | cc307a == 2) 
label variable Dem "Democrat"
gen Ind = (cc307a == 3 | cc307a == 4 | cc307a == 5)
label variable Ind "Independent"
gen OthPty = (cc307a == 8 | missing(cc307a))

tab v207 
gen Age1824 = (v207 >= 1984 & v207<= 1990)
label variable Age1824 "Age 18 - 24"
gen Age2544 = (v207 >= 1964 & v207<= 1983)
label variable Age2544 "Age 25 - 44"
gen Age4564 = (v207 >= 1944 & v207 <= 1963)
label variable Age4564 "Age 45 - 64"

tab v208
tab v214
gen MarriedXMale = (v214 == 1)*(v208 == 1)
label variable MarriedXMale "Married Male"
gen UnmarriedXFemale = (v214 ~= 1)*(v208 == 2)
label variable UnmarriedXFemale "Unmarried Female"
gen MarriedXFemale = (v214 == 1)*(v208 == 2)
label variable MarriedXFemale "Married Female"

tab v211
gen Black = (v211 == 2)
gen Hispanic = (v211 == 3)

tab v213
gen SomeCollege = (v213 == 3 | v213 == 4)
label variable SomeCollege "Some College"
gen BADegree = (v213 == 5 | v213 == 6)
label variable BADegree "Bachelor's Degree"

tab v246
gen IncomeU20k = (v246 >= 1 & v246 <= 3)
label variable IncomeU20k "Income Less Than \\\$20,000"
gen Income2040k = (v246 >= 4 & v246 <= 6)
label variable Income2040k "Income Between \\\$20,000 and \\\$40,000"
gen Income4080k = (v246 >= 7 & v246 <= 10)
label variable Income4080k "Income Between \\\$40,000 and \\\$80,000"
gen Income80120k = (v246 >= 11 & v246<= 12)  
label variable Income80120k "Income Between \\\$80,000 and \\\$120,000"
gen MissingIncome = (v246 == 15)

tab v209
gen Unemployed = (v209 == 3 | v209 == 4)

tab ActUnemploy
gen StateUnemp = ActUnemploy
label variable StateUnemp "State Unemployment"

tab v217
gen ChurchWeekly = (v217 == 1 | v217 == 2)
gen ChurchSometimes = (v217  == 3 | v217 == 4)

tab cc329
gen Union = (cc329 == 2 | cc329 == 3 | cc329 == 4)

gen Sample = 1
foreach var of varlist RptUnemploy-Union {
replace Sample = 0 if missing(`var') == 1
}

/************************************************************************** unemployment histogram for 2008, non-benchmarked	**************************************************************************/
gen rptUnemployTC = RptUnemploy
replace rptUnemployTC = 50 if rptUnemployTC > 50 & RptUnemploy ~= .

#delimit;hist rptUnemployTC if Sample,	width(1) start(0) percent	lcolor(black) fcolor(gs10)	ytitle("")	ylabel(0 "0" 10 "10%" 20 "20%" 30 "30%" 40 "40%", angle(horizontal))	yline(40, lcolor(gs15))	xlabel(0 "0" 10 "10%" 20 "20%" 30 "30%" 40 "40%" 50 "50%") 	xtitle("Responses to Non-benchmarked Question, 2008 (N = 969)")	graphregion(color(gs16))	saving(unemploymentUnFramed, replace);

#delimit cr	
gsort - Sample + RptUnemploy 
gen temp = 1 if _n == 1
replace temp = temp[_n-1] + 1 if _n > 1 & Sample
egen temp2 = mean(temp), by(RptUnemploy) 
egen temp3 = max(temp), by(Sample)
gen Percentile = 100*temp2 / temp3
drop temp temp2 temp3
save "temp.dta", replace

use temp.dta, clear
keep if Sample
qreg RptUnemploy Dem-Union,  quantile(.5)
matrix observe = e(b)
capture program drop myboot
program define myboot, eclass
preserve
bsample, cluster(STATE)
qreg RptUnemploy Dem-Union, quantile(.5)
restore
end
simulate _b, reps(`num_bootstraps') seed(`seedvalue'): myboot
bstat, stat(observe)
outreg2 _b_Dem-_b_Ind _b_Age1824-_b_Income80120k _b_Unemployed _b_StateUnemp using Table2a.tex, /*
*/ append tex(pretty)  stats(coef se) parenthesis(se) label /*
*/ alpha(.01,.05,.1) symbol(***, **, *) dec(2) nor2 noobs nonotes 
matrix coeff_nbenchmark_lad = e(b)
matrix var_nbenchmark_lad = e(V)

use temp.dta, clear
regress Percentile Dem-Union if Sample, cluster(STATE)
outreg2 Dem-Ind Age1824-Income80120k Unemployed StateUnemp using Table2b.tex, /*
*/ append tex(pretty)  stats(coef se) parenthesis(se) label /*
*/ alpha(.01,.05,.1) symbol(***, **, *) dec(2) nor2 noobs nonotes 
matrix coeff_nbenchmark_pct = e(b)
matrix var_nbenchmark_pct = e(V)
erase temp.dta

matrix temp1 = (coeff_benchmark_lad - coeff_nbenchmark_lad)'
matrix temp2 =  J(rowsof(temp1), 1, 0)
matrix temp3 =  J(rowsof(temp1), 1, 0)
matrix temp4 = (coeff_benchmark_pct - coeff_nbenchmark_pct)'
matrix temp5 =  J(rowsof(temp4), 1, 0)
matrix temp6 =  J(rowsof(temp4), 1, 0)
local crap1 = rowsof(temp1)
display `crap1'
forvalues i = 1(1)`crap1' { 
		matrix temp2[`i', 1] = (var_benchmark_lad[`i', `i'] + var_nbenchmark_lad[`i', `i'])^(1/2)
	    matrix temp3[`i', 1] = (1 - normal(abs(temp1[`i', 1] / temp2[`i', 1]))) * 2 
		matrix temp5[`i', 1] = (var_benchmark_pct[`i', `i'] + var_nbenchmark_pct[`i', `i'])^(1/2)
		matrix temp6[`i', 1] = (1 - normal(abs(temp4[`i', 1] / temp5[`i', 1]))) * 2 
} 
matrix temp = temp1, temp2, temp3, temp4, temp5, temp6

// Data for Table 2
// Column 1 - Difference in Coefficients LAD
// Column 2 - Standard Error in Difference in Coefficients LAD
// Column 3 - p-value on Hypothesis Test on No Difference in Coefficients in LAD
// Column 4 - Difference in Coefficients Percentile
// Column 5 - Standard Error in Difference in Coefficients Percentile
// Column 6 - p-value on Hypothesis Test on No Difference in Coefficients in Percentile
matlist temp

//  Table A3

tab cc327
gen Obama = 0 if cc327 == 1
replace Obama = 1 if cc327 == 2

gen Centered = (RptUnemploy - 10.8)
gen Above = (RptUnemploy >  10.8)
gen CenteredXBelow = Centered * (1 - Above)
gen CenteredXAbove = Centered * Above

local i = 2
foreach var of varlist CCCurEmploy RetroEcon CCCurBus Obama {
regress `var' CenteredXBelow CenteredXAbove Above if Sample, robust
matrix AppendixA3[1, `i'] = _b[CenteredXBelow]
matrix AppendixA3[2, `i'] = _se[CenteredXBelow]
matrix AppendixA3[3, `i'] = _b[CenteredXAbove]
matrix AppendixA3[4, `i'] = _se[CenteredXAbove]
matrix AppendixA3[5, `i'] = _b[Above]
matrix AppendixA3[6, `i'] = _se[Above]
matrix AppendixA3[7, `i'] = _b[_cons]
matrix AppendixA3[8, `i'] = _se[_cons]
local i = `i' + 2
}

matlist AppendixA3

matrix temp = J(3, 4, 0)
forvalues i = 1(2)7 {
local j = 1 + (`i' - 1)/2
matrix temp[1, `j'] = AppendixA3[1, `i'] - AppendixA3[1, `i' + 1] 
matrix temp[2, `j'] = (AppendixA3[2, `i']^2 + AppendixA3[2, `i' + 1]^2)^(1/2)
matrix temp[3, `j'] = (1 - normal(abs(temp[1, `j'] / temp[2, `j']))) * 2 
}
// Data for Table A3
// Row 1 - Difference in Slope Below 10.8%
// Row 2 - Standard Error on Difference in Slope Below 10.8%
// Row 3 - p-value on Hypothesis Test on No Difference in Slope Below 10.8%
matlist temp

save tmpNonBenchmarked, replace

//
// 2008 ANES Regressions
//

insheet using gasprices08.csv, comma clear
keep state_fips pricenov
rename state_fips STATE
rename pricenov ActGasPrice
replace ActGasPrice = ActGasPrice / 100
sort STATE
save temp.dta, replace

use UnemploymentByState.dta, clear
keep FIPSstate oct2008
rename FIPSstate STATE
rename oct2008 ActUnemploy
sort STATE
save temp1.dta, replace

use anes_timeseries_2008.dta, clear
rename V081201b STATE
sort STATE
merge n:1 STATE using temp.dta
drop if _merge == 2
drop _merge
erase temp.dta
sort STATE
merge n:1 STATE using temp1.dta
drop if _merge == 2
drop _merge
erase temp1.dta

tab V085071
rename V085071 RptGasPrice
replace RptGasPrice = . if RptGasPrice == -2 | RptGasPrice == -8

gen Bias = (RptGasPrice - ActGasPrice)
count if (Bias < -1 | Bias > 1) & missing(Bias) == 0
replace Bias = -1 if Bias < -1 & missing(Bias) == 0
replace Bias = 1 if Bias > 1 & missing(Bias) == 0
gen Accuracy = -abs(Bias)

tab V083097
tab V083098a
tab V083098b
gen Dem = (V083097 == 1) 
label variable Dem "Democrat"
gen Ind = (V083097 == 3)
label variable Ind "Independent"
gen OthPty = (V083097 == -9 | V083097 == -8 | V083097 == 4 | V083097 == 5)

tab V083215x
gen Age1844 = (V083215x >= 18 & V083215x <= 44)
label variable Age1844 "Age 18 - 44"
gen Age4564 = (V083215x >= 45 & V083215x <= 64)
label variable Age4564 "Age 45 - 64"

tab V081101
gen Female = (V081101 == 2)

tab V083216x
gen Married = (V083216x == 1)

tab V081102
tab V081103
gen Black = (V081102 == 2 | V081102 == 6 | V081102 == 7)
gen Hispanic = (V081103 == 1)

tab V083217
gen SomeCollege = (V083217 > 12 & V083217 < 16)
label variable SomeCollege "Some College"
gen BADegree = (V083217 >= 16)
label variable BADegree "Bachelor's Degree"

tab V083247
tab V083248 if V083247==1 
tab V083249 if V083247==5
gen IncomeU20k = (V083248 >= 1 & V083248 <= 9) if V083247==1 
replace IncomeU20k = (V083249 >= 1 & V083249 <= 9) if V083247==5 
label variable IncomeU20k "Income Less Than \\\$20,000"
gen Income2040k = (V083248 >= 10 & V083248 <= 14) if V083247==1 
replace Income2040k = (V083249 >= 10 & V083249 <= 14) if V083247==5
label variable Income2040k "Income Between \\\$20,000 and \\\$40,000"
gen Income4080k = (V083248 >= 15 & V083248 <= 18) if V083247==1 
replace Income4080k = (V083249 >= 15 & V083249 <= 18) if V083247==5
label variable Income4080k "Income Between \\\$40,000 and \\\$80,000" // Actually 75k
gen Income80120k = (V083248 >= 19 & V083248 <= 22) if V083247==1 
replace Income80120k = (V083249 >= 19 & V083249 <= 22) if V083247==5
label variable Income80120k "Income Between \\\$80,000 and \\\$120,000"
gen MissingIncome = (V083248 >= -9 & V083248 <= -8) if V083247==1 
replace MissingIncome = (V083249 >= -9 & V083249 <= -8) if V083247==5

tab V083222
gen Unemployed = (V083222 == 2 | V083222 == 4)  

tab V083186a
gen ChurchWeekly = (V083186a == 1 | V083186a == 2)
gen ChurchSometimes = (V083186a == 3 | V083186a == 4)

tab V083246
gen Union = (V083246 == 1)

gen Sample = 1
foreach var of varlist Bias-Union {
replace Sample = 0 if missing(`var') == 1
}

regress Bias if Sample 
local Mean = _b[_cons]
qreg Bias if Sample 
local Median = _b[_cons]
regress Bias Dem-Union if Sample 
outreg2 Dem-Ind Age1844-Income80120k Unemployed using Table1.tex, /*
*/ append tex(pretty) stats(coef se) parenthesis(se) label /*
*/ alpha(.01,.05,.1) symbol(***, **, *) dec(3) nor2 addstat(Mean, `Mean', Median, `Median') nonotes 

regress Accuracy if Sample 
local Mean = _b[_cons]
qreg Accuracy if Sample 
local Median = _b[_cons]
regress Accuracy Dem-Union if Sample
outreg2 Dem-Ind Age1844-Income80120k Unemployed using Table1.tex, /*
*/ append tex(pretty) stats(coef se) parenthesis(se) label /*
*/ alpha(.01,.05,.1) symbol(***, **, *) dec(3) nor2 noobs addstat(Mean, `Mean', Median, `Median') nonotes 

/************************************************************************** histograms of gas prices in November, 2008		**************************************************************************/
gen rptGasPriceTC = RptGasPrice
replace rptGasPriceTC = 1.4 if rptGasPriceTC < 1.4replace rptGasPriceTC = 4 if rptGasPriceTC > 4 & RptGasPrice ~= . 

#delimit;hist rptGasPriceTC if Sample,	width(.2) start(1) percent	lcolor(black) fcolor(gs10)	ytitle("")	ylabel(0 "0" 10 "10%" 20 "20%" 30 "30%" 40 "40%" 50 "50%", angle(horizontal)) 	yline(30, lcolor(gs15))	yline(40, lcolor(gs15))	yline(50, lcolor(gs15))	xlabel(0 "$0" .5 "$0.50" 1 "$1" 1.5 "$1.50" 2 "$2" 2.5 "$2.50" 3 "$3" 3.5 "$3.50" 4 "$4")	xtitle("November, 2008 (ANES: N = 2,069)")	xline(1.99, lwidth(thick) lcolor(red))	text(36 1.99 "Average Actual Price" " " "(in Sample)", orientation(vertical))	graphregion(color(gs16))	saving(reportedPriceNov08, replace);	#delimit;	graph combine reportedPrice06.gph reportedPriceOct08.gph reportedPriceNov08.gph, 		rows(3) cols(1) 		imargin(small)		l1title("Percent of Observations")		graphregion(color(gs16))		xsize(7) ysize(10)		saving(reportedPrice, replace);graph export reportedPrice.eps, replace; graph export reportedPrice.png, replace; erase reportedPrice.gph; erase reportedPrice06.gph; erase reportedPriceOct08.gph;erase reportedPriceNov08.gph;

#delimit cr
gen error = 100*(rptGasPriceTC - ActGasPrice) gen errorTC = errorreplace errorTC = -100 if error < -100replace errorTC = 100 if error > 100 & error ~= .

#delimit;hist errorTC if Sample,	width(10) start(-100) percent	lcolor(black) fcolor(gs10)	ytitle("")	ylabel(0 "0" 10 "10%" 20 "20%" 30 "30%", angle(horizontal))	yline(30, lcolor(gs15))	xlabel(-100 "-$1" -50 "-$0.50" 0 "$0" 50 "$0.50" 100 "$1")	xtitle("November, 2008 (ANES: N = 2,069)")	graphregion(color(gs16))	saving(errorNov08, replace);	#delimit;	graph combine error06.gph errorOct08.gph errorNov08.gph, 		rows(3) cols(1) 		imargin(small)		l1title("Percent of Observations")		graphregion(color(gs16))		xsize(7) ysize(10)		saving(error, replace);graph export error.eps, replace; graph export error.png, replace; erase error.gph;erase error06.gph; erase errorOct08.gph; erase errorNov08.gph;

#delimit cr	
drop Bias-Sample


// ANES Unemployment (Table A.2)

tab V085070
gen RptUnemploy = V085070
replace RptUnemploy = . if V085070 == -9 | V085070 == -8 | V085070 == -2 

tab V083097
tab V083098a
tab V083098b
gen Dem = (V083097 == 1) 
label variable Dem "Democrat"
gen Ind = (V083097 == 3)
label variable Ind "Independent"
gen OthPty = (V083097 == -9 | V083097 == -8 | V083097 == 4 | V083097 == 5)

tab V083215x
gen Age1824 = (V083215x >= 18 & V083215x < 25)
label variable Age1824 "Age 18 - 24"
gen Age2544 = (V083215x >= 25 & V083215x < 44)
label variable Age2544 "Age 25 - 44"
gen Age4564 = (V083215x >= 45 & V083215x < 65)
label variable Age4564 "Age 45 - 64"

tab V081101
tab V083216x
gen MarriedXMale = (V083216x == 1)*(V081101 == 1)
label variable MarriedXMale "Married Male"
gen UnmarriedXFemale = (V083216x ~= 1)*(V081101 == 2)
label variable UnmarriedXFemale "Unmarried Female"
gen MarriedXFemale = (V083216x == 1)*(V081101 == 2)
label variable MarriedXFemale "Married Female"

tab V081102
tab V081103
gen Black = (V081102 == 2 | V081102 == 6 | V081102 == 7)
gen Hispanic = (V081103 == 1)

tab V083217
gen SomeCollege = (V083217 > 12 & V083217 < 16)
label variable SomeCollege "Some College"
gen BADegree = (V083217 >= 16)
label variable BADegree "Bachelor's Degree"

tab V083247
tab V083248 if V083247==1 
tab V083249 if V083247==5
gen IncomeU20k = (V083248 >= 1 & V083248 <= 9) if V083247==1 
replace IncomeU20k = (V083249 >= 1 & V083249 <= 9) if V083247==5 
label variable IncomeU20k "Income Less Than \\\$20,000"
gen Income2040k = (V083248 >= 10 & V083248 <= 14) if V083247==1 
replace Income2040k = (V083249 >= 10 & V083249 <= 14) if V083247==5
label variable Income2040k "Income Between \\\$20,000 and \\\$40,000"
gen Income4080k = (V083248 >= 15 & V083248 <= 18) if V083247==1 
replace Income4080k = (V083249 >= 15 & V083249 <= 18) if V083247==5
label variable Income4080k "Income Between \\\$40,000 and \\\$80,000" // Actually 75k
gen Income80120k = (V083248 >= 19 & V083248 <= 22) if V083247==1 
replace Income80120k = (V083249 >= 19 & V083249 <= 22) if V083247==5
label variable Income80120k "Income Between \\\$80,000 and \\\$120,000"
gen MissingIncome = (V083248 >= -9 & V083248 <= -8) if V083247==1 
replace MissingIncome = (V083249 >= -9 & V083249 <= -8) if V083247==5

tab V083222
gen Unemployed = (V083222 == 2 | V083222 == 4)  

tab ActUnemploy
gen StateUnemp = ActUnemploy
label variable StateUnemp "State Unemployment"

tab V083186a
gen ChurchWeekly = (V083186a == 1 | V083186a == 2)
gen ChurchSometimes = (V083186a == 3 | V083186a == 4)

tab V083246
gen Union = (V083246 == 1)

gen Sample = 1
foreach var of varlist RptUnemploy-Union {
replace Sample = 0 if missing(`var') == 1
}

gsort - Sample + RptUnemploy 
gen temp = 1 if _n == 1
replace temp = temp[_n-1] + 1 if _n > 1 & Sample
egen temp2 = mean(temp), by(RptUnemploy) 
egen temp3 = max(temp), by(Sample)
gen Percentile = 100*temp2 / temp3
drop temp temp2 temp3
save "temp.dta", replace

use temp.dta, clear
keep if Sample
qreg RptUnemploy Dem-Union,  quantile(.5)
matrix observe = e(b)
capture program drop myboot
program define myboot, eclass
preserve
bsample, cluster(STATE)
qreg RptUnemploy Dem-Union, quantile(.5)
restore
end
simulate _b, reps(`num_bootstraps') seed(`seedvalue'): myboot
bstat, stat(observe)
outreg2 _b_Dem-_b_Ind _b_Age1824-_b_Income80120k _b_Unemployed _b_StateUnemp using TableA2a.tex, /*
*/ append tex(pretty)  stats(coef se) parenthesis(se) label /*
*/ alpha(.01,.05,.1) symbol(***, **, *) dec(2) nor2 noobs nonotes 

use temp.dta, clear
regress Percentile Dem-Union if Sample, cluster(STATE)
outreg2 Dem-Ind Age1824-Income80120k Unemployed StateUnemp using TableA2b.tex, /*
*/ append tex(pretty)  stats(coef se) parenthesis(se) label /*
*/ alpha(.01,.05,.1) symbol(***, **, *) dec(2) nor2 noobs nonotes 

erase temp.dta

//
// 2009 CCES Regressions
//

use UnemploymentByState.dta, clear
keep FIPSstate oct2009
rename FIPSstate STATE
rename oct2009 ActUnemploy
sort STATE
save temp1.dta, replace

use cces09_hamster_harvard_output.dta, clear
rename inputstate STATE
sort STATE
merge n:1 STATE using temp1.dta
drop if _merge == 2
drop _merge
erase temp1.dta

// Unemployment Rate (Table A1)

tab hms_4
gen RptUnemploy = hms_4

tab pid3
gen Dem = (pid3 == 1) 
label variable Dem "Democrat"
gen Ind = (pid3 == 3)
label variable Ind "Independent"
gen OthPty = (pid3 == 4 | pid3 == 5)

tab age
gen Age1824 = (age >= 18 & age <= 24)
label variable Age1824 "Age 18 - 24"
gen Age2544 = (age >= 25 & age <= 44)
label variable Age2544 "Age 25 - 44"
gen Age4564 = (age >= 45 & age <= 64)
label variable Age4564 "Age 45 - 64"

tab gender
tab marstat
gen MarriedXMale = (marstat == 1)*(gender == 1)
label variable MarriedXMale "Married Male"
gen UnmarriedXFemale = (marstat ~= 1)*(gender == 2)
label variable UnmarriedXFemale "Unmarried Female"
gen MarriedXFemale = (marstat == 1)*(gender == 2)
label variable MarriedXFemale "Married Female"

tab race
gen Black = (race == 2)
gen Hispanic = (race == 3)

tab educ
gen SomeCollege = (educ == 3 | educ == 4)
label variable SomeCollege "Some College"
gen BADegree = (educ == 5 | educ == 6)
label variable BADegree "Bachelor's Degree"

tab income
gen IncomeU20k = (income>= 1 & income <= 3)
label variable IncomeU20k "Income Less Than \\\$20,000"
gen Income2040k = (income >= 4 & income <= 6)
label variable Income2040k "Income Between \\\$20,000 and \\\$40,000"
gen Income4080k = (income >= 7 & income <= 10)
label variable Income4080k "Income Between \\\$40,000 and \\\$80,000"
gen Income80120k = (income >= 11 & income <= 12)  
label variable Income80120k "Income Between \\\$80,000 and \\\$120,000"
gen MissingIncome = (income == 15)

tab employ
gen Unemployed = (employ == 3 | employ == 4)

tab ActUnemploy
gen StateUnemp = ActUnemploy
label variable StateUnemp "State Unemployment"

tab pew_churatd
gen ChurchWeekly = (pew_churatd == 1 | pew_churatd == 2)
gen ChurchSometimes = (pew_churatd  == 3 | pew_churatd == 4)

tab unionhh
gen Union = (unionhh == 1)

gen Sample = 1
foreach var of varlist RptUnemploy-Union {
replace Sample = 0 if missing(`var') == 1
}

/************************************************************************** unemployment histogram for 2009	**************************************************************************/
gen rptUnemployTC = RptUnemploy
replace rptUnemployTC = 50 if rptUnemployTC > 50 & RptUnemploy ~= .

#delimit;hist rptUnemployTC if Sample,	width(1) start(0) percent	lcolor(black) fcolor(gs10)	ytitle("")	ylabel(0 "0" 10 "10%" 20 "20%" 30 "30%" 40 "40%", angle(horizontal))	xlabel(0 "0" 10 "10%" 20 "20%" 30 "30%" 40 "40%" 50 "50%") 	xtitle("Responses to Benchmarked Question, 2009 (N = 983)")	graphregion(color(gs16))	saving(unemployment2009, replace);
	
#delimit;	graph combine unemploymentUnFramed.gph unemploymentFramed.gph unemployment2009.gph, 		rows(3) cols(1) 		imargin(small)		l1title("Percent of Observations")		graphregion(color(gs16))		xsize(10) ysize(7)		saving(unemployment, replace);graph export unemployment.eps, replace; graph export unemployment.png, replace; 

erase unemployment.gph;erase unemploymentFramed.gph;erase unemploymentUnFramed.gph;erase unemployment2009.gph;

#delimit cr	
gsort - Sample + RptUnemploy 
gen temp = 1 if _n == 1
replace temp = temp[_n-1] + 1 if _n > 1 & Sample
egen temp2 = mean(temp), by(RptUnemploy) 
egen temp3 = max(temp), by(Sample)
gen Percentile = 100*temp2 / temp3
drop temp temp2 temp3
save "temp.dta", replace

use temp.dta, clear
keep if Sample
qreg RptUnemploy Dem-Union,  quantile(.5)
matrix observe = e(b)
capture program drop myboot
program define myboot, eclass
preserve
bsample, cluster(STATE)
qreg RptUnemploy Dem-Union, quantile(.5)
restore
end
simulate _b, reps(`num_bootstraps') seed(`seedvalue'): myboot
bstat, stat(observe)
outreg2 _b_Dem-_b_Ind _b_Age1824-_b_Income80120k _b_Unemployed _b_StateUnemp using TableA1a.tex, /*
*/ append tex(pretty)  stats(coef se) parenthesis(se) label /*
*/ alpha(.01,.05,.1) symbol(***, **, *) dec(2) nor2 noobs nonotes 
matrix coeff_benchmark09_lad = e(b)
matrix var_benchmark09_lad = e(V)

use temp.dta, clear
regress Percentile Dem-Union if Sample, cluster(STATE)
outreg2 Dem-Ind Age1824-Income80120k Unemployed StateUnemp using TableA1b.tex, /*
*/ append tex(pretty)  stats(coef se) parenthesis(se) label /*
*/ alpha(.01,.05,.1) symbol(***, **, *) dec(2) nor2 noobs nonotes 
matrix coeff_benchmark09_pct = e(b)
matrix var_benchmark09_pct = e(V)
erase temp.dta

matrix temp1 = (coeff_benchmark_lad - coeff_benchmark09_lad)'
matrix temp2 =  J(rowsof(temp1), 1, 0)
matrix temp3 =  J(rowsof(temp1), 1, 0)
matrix temp4 = (coeff_benchmark_pct - coeff_benchmark09_pct)'
matrix temp5 =  J(rowsof(temp4), 1, 0)
matrix temp6 =  J(rowsof(temp4), 1, 0)
local crap1 = rowsof(temp1)
display `crap1'
forvalues i = 1(1)`crap1' { 
		matrix temp2[`i', 1] = (var_benchmark_lad[`i', `i'] + var_benchmark09_lad[`i', `i'])^(1/2)
	    matrix temp3[`i', 1] = (1 - normal(abs(temp1[`i', 1] / temp2[`i', 1]))) * 2 
		matrix temp5[`i', 1] = (var_benchmark_pct[`i', `i'] + var_benchmark09_pct[`i', `i'])^(1/2)
		matrix temp6[`i', 1] = (1 - normal(abs(temp4[`i', 1] / temp5[`i', 1]))) * 2 
} 
matrix temp = temp1, temp2, temp3, temp4, temp5, temp6

// Data for Table A1
// Column 1 - Difference in Coefficients LAD
// Column 2 - Standard Error in Difference in Coefficients LAD
// Column 3 - p-value on Hypothesis Test on No Difference in Coefficients in LAD
// Column 4 - Difference in Coefficients Percentile
// Column 5 - Standard Error in Difference in Coefficients Percentile
// Column 6 - p-value on Hypothesis Test on No Difference in Coefficients in Percentile
matlist temp

/************************************************************************** group everything by RptUnemployTC								 **************************************************************************/
use RptUnemploy CCCurEmploy CCCurBus RetroEcon Obama Sample using tmpBenchmarked, clear
keep if Sample
gen Frame = 1
save temp, replace 

use RptUnemploy CCCurEmploy CCCurBus RetroEcon Obama Sample using tmpNonBenchmarked, clear
keep if Sample
gen Frame = 0
append using temp
erase temp.dta
erase tmpBenchmarked.dta
erase tmpNonBenchmarked.dta

gen RptUnemployTC = RptUnemploy
replace RptUnemployTC = 25 if RptUnemployTC > 25 & RptUnemployTC ~= .

foreach x of varlist CCCurEmploy CCCurBus RetroEcon Obama {
	gen wt`x' = 1 if missing(`x') == 0
}

save tmp, replace

keep if Frame
drop Frame
collapse (sum) wt* CCCurEmploy CCCurBus RetroEcon Obama, by(RptUnemployTC)
foreach x of varlist CCCurEmploy CCCurBus RetroEcon Obama {
	gen mean`x' = `x'/wt`x'
	drop `x'
}
gen frame = 1
save tmp2, replace

use tmp, clear
keep if ~Frame
drop Frame
collapse (sum) wt* CCCurEmploy CCCurBus RetroEcon Obama, by(RptUnemployTC)
foreach x of varlist CCCurEmploy CCCurBus RetroEcon  Obama {
	gen mean`x' = `x'/wt`x'
	drop `x'
}
gen frame = 0
append using tmp2

erase tmp.dta
erase tmp2.dta

rename meanCCCurEmploy employ
rename meanCCCurBus business
rename meanRetroEcon retro
rename meanObama obama
rename wtCCCurEmploy wtEmploy
rename wtCCCurBus wtBusiness
rename wtRetroEcon wtRetro
rename RptUnemployTC rptUnemploy

reshape wide employ business retro obama wt*, i(rptUnemploy) j(frame)

foreach x in employ business retro obama wtEmploy wtBusiness wtRetro wtObama {
	rename `x'0 `x'NoFrame 
	rename `x'1 `x'Frame
}
/* makes sure that each 0.05 has an observation*/local nobs=r(N)local nobs500=`nobs'+25*20set obs `nobs500'egen unemploy=rank(_n) if rptUnemploy==.replace rptUnemploy=unemploy/20 if rptUnemploy==.replace rptUnemploy=round(rptUnemploy,.01)
foreach x of varlist wt* {
	replace `x' = 0 if `x' == .
}

drop unemploy
drop if rptUnemploy < 3

collapse (sum) wt* employ* business* retro* obama*, by(rptUnemploy)

gen invRpt = 1/rptUnemploy
gen lnRpt = ln(rptUnemploy)
save tmpHetero, replace

/************************************************************************** generate lowess figures (log scale)							 **************************************************************************/
use tmpHetero, clear

wtlowess employFrame lnRpt [w=wtEmployFrame], gen(employFrameHat) bwidth($bandwidth) poly($poly)
wtlowess employNoFrame lnRpt [w=wtEmployNoFrame], gen(employNoFrameHat) bwidth($bandwidth) poly($poly)

#delimit;
twoway 
	(line employFrameHat lnRpt if rptUnemploy > 4, lcolor(blue) lwidth(thick) lpattern(solid))
	(line employNoFrameHat lnRpt if rptUnemploy > 4, lcolor(red) lwidth(medium) lpattern(dash)) 
	, 
	legend(off rows(1) order (1 "Benchmarked Sample" 2 "Non-benchmarked Sample")) 
	ylabel(1.6 "1.6" 1.8 "1.8" 2 "2" 2.2 "2.2" 2.4 "2.4" 2.6 "2.6" ,angle(horizontal))
	ytitle("Current Employment Siutation" "(1 = Plenty of Jobs to 3 = Hard to Get)",size(small))
	xlabel(1.6094379 "5%" 2.3025851 "10%" 2.9957323 "20%")
	xtitle("")
	xline(2.3978953, lcolor(green) lwidth(thick))
	text(2 2.35 "Historical Maximum", orientation(vertical) size(small))	
	graphregion(color(gs16))
	name(fig4a, replace)
	; 

#delimit cr
use tmpHetero, clear

wtlowess businessFrame lnRpt [w=wtBusinessFrame], gen(businessFrameHat) bwidth($bandwidth) poly($poly)
wtlowess businessNoFrame lnRpt [w=wtBusinessNoFrame], gen(businessNoFrameHat) bwidth($bandwidth) poly($poly)

#delimit;
twoway 
	(line businessFrameHat lnRpt if rptUnemploy > 4, lcolor(blue) lwidth(thick) lpattern(solid))
	(line businessNoFrameHat lnRpt if rptUnemploy > 4, lcolor(red) lwidth(medium) lpattern(dash)) 
	, 
	ytitle("Current Business Conditions" "(1 = Good to 3 = Bad)", size(small))  
	ylabel(1.6 "1.6" 1.8 "1.8" 2 "2" 2.2 "2.2" 2.4 "2.4" 2.6 "2.6" ,angle(horizontal))
	xlabel(1.6094379 "5%" 2.3025851 "10%" 2.9957323 "20%")
	xtitle("")
	xline(2.3978953, lcolor(green) lwidth(thick))
	text(2 2.35 "Historical Maximum", orientation(vertical) size(small))
	legend(off)
	graphregion(color(gs16))
	name(fig4b, replace)
	; 
	
#delimit cr
use tmpHetero, clear

wtlowess retroFrame lnRpt [w=wtRetroFrame], gen(retroFrameHat) bwidth($bandwidth) poly($poly)
wtlowess retroNoFrame lnRpt [w=wtRetroNoFrame], gen(retroNoFrameHat) bwidth($bandwidth) poly($poly)

#delimit;
twoway 
	(line retroFrameHat lnRpt if rptUnemploy > 4, lcolor(blue) lwidth(thick) lpattern(solid))
	(line retroNoFrameHat lnRpt if rptUnemploy >= 4.35, lcolor(red) lwidth(medium) lpattern(dash)) 
	, 
	ytitle("Retrospective Economic Evaluation" "(1 = Much Better to 5 = Much Worse)",size(small)) 
	ylabel(4.2 "4.2" 4.3 "4.3" 4.4 "4.4" 4.5 "4.5" 4.6 "4.6" 4.7 "4.7",angle(horizontal))
	xlabel(1.6094379 "5%" 2.3025851 "10%" 2.9957323 "20%")
	xtitle("")
	xline(2.3978953, lcolor(green) lwidth(thick))
	text(4.4 2.35 "Historical Maximum", orientation(vertical) size(small))
	legend(off)
	graphregion(color(gs16))
	name(fig4c, replace)
	;
	
#delimit cr
use tmpHetero, clear

wtlowess obamaFrame lnRpt [w=wtObamaFrame], gen(obamaFrameHat) bwidth($bandwidth) poly($poly)
wtlowess obamaNoFrame lnRpt [w=wtObamaNoFrame], gen(obamaNoFrameHat) bwidth($bandwidth) poly($poly)

#delimit;
twoway 
	(line obamaFrameHat lnRpt if rptUnemploy > 4, lcolor(blue) lwidth(thick) lpattern(solid))
	(line obamaNoFrameHat lnRpt if rptUnemploy > 4, lcolor(red) lwidth(medium) lpattern(dash)) 
	, 
	ytitle("Presidential Vote" "(1 = Obama, 0 = McCain)",size(small)) 
	ylabel(0.2 "0.2" 0.3 "0.3" 0.4 "0.4" 0.5 "0.5" 0.6 "0.6" 0.7 "0.7",angle(horizontal))
	xlabel(1.6094379 "5%" 2.3025851 "10%" 2.9957323 "20%")
	xtitle("")
	xline(2.3978953, lcolor(green) lwidth(thick))
	text(.4 2.35 "Historical Maximum", orientation(vertical) size(small))
	legend(off)
	graphregion(color(gs16))
	name(fig4d, replace)
	; 

#delimit;grc1leg fig4a fig4b fig4c fig4d,		rows(2) cols(2)	 			b1title("Reported Unemployment Rate (Log Scale)",size(medium))
		legendfrom(fig4a)
		position(12)		graphregion(color(gs16))		xsize(10) ysize(7.5);
graph export distributionsLog.eps, replace;
graph export distributionsLog.png, replace;

#delimit cr
erase tmpHetero.dta

log close
