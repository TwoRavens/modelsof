/**********************************************************************************
		acsanalysis.do
**********************************************************************************/

/**********************************************************************************
		GLOBALS
**********************************************************************************/

global folder myfolder		// replace 'myfolder' with datafolder

/**********************************************************************************
		LOAD DATA
**********************************************************************************/

cd "${folder}"
set more off

use ipums20113yrs_select.dta, clear

/**********************************************************************************
		PREDICTED EARNINGS
**********************************************************************************/

// Online Appendix Table A.10: Mincer regression
* Column (1)
reg ln_incwage cohort2-cohort4 female age_s age_s_2 child married educd2-educd4 degfield2-degfield37 if german == 0, robust 
predict ln_incwagepredict, xb

* Column (2)
reg ln_incwage cohort2-cohort4 female age_s age_s_2 child married educd2-educd4 degfield2-degfield37 if german == 1, robust 

* Keep Germans who are closest to graduates in Germany
keep if include == 1

* Sumstats of predicted earnings
sum ln_incwagepredict if german == 1,d
sum ln_incwagepredict if german == 0,d


// Figure 6b, left panel: CDF of predicted earnings
local pattern_bw_usa = "-#"
local pattern_bw_ger = "l"

local bw_usa = "gs3"
local bw_ger = "gs0"

	cumul ln_incwagepredict if german == 1, gen(cumllnincwagep_german) equal
	cumul ln_incwagepredict if german == 0, gen(cumllnincwagep_usa) equal
	ksmirnov ln_incwagepredict, by(german)

#delimit;
twoway	(line cumllnincwagep_usa	ln_incwagepredict if german == 0, sort connect(J) lpattern("`pattern_bw_usa'") lcolor("`bw_usa'") lwidth(medthick)) ||
		(line cumllnincwagep_german	ln_incwagepredict if german == 1, sort connect(J) lpattern("`pattern_bw_ger'") lcolor("`bw_ger'") lwidth(medthick)),
		legend(region(lcolor(gs16)) row(2) ring(0) position(4) label(1 "US natives ({it:N}=289,538)") label(2 "Germans ({it:N}=565)"))
		xtitle(Log predicted earnings, size(medsmall))
		xscale(titlegap(3))
		ylabel(0 "0" 0.25 "0.25" 0.5 "0.5" 0.75 "0.75" 1 "1", labsize(medsmall))
		graphregion(color(white))		
;
#delimit cr




// Figure 6b, right panel: Decomposition of predicted earnings

recode german (0 = 1) (1 = 0)

oaxaca ln_incwagepredict (educ:educd2-educd4) (subject:degfield2-degfield37) (age: age age_2) female  (personalfamily: child married) (cohort:cohort2-cohort4), by(german) relax

#delimit ;
matrix A = (7, _b[overall:difference], _b[overall:difference] - invttail(e(N),0.025) * _se[overall:difference], _b[overall:difference] + invttail(e(N),0.025) * _se[overall:difference] \
			6, _b[endowments:educ], _b[endowments:educ] - invttail(e(N),0.025) * _se[endowments:educ], _b[endowments:educ] + invttail(e(N),0.025) * _se[endowments:educ] \
			5, _b[endowments:subject], _b[endowments:subject] - invttail(e(N),0.025) * _se[endowments:subject], _b[endowments:subject] + invttail(e(N),0.025) * _se[endowments:subject] \
			4, _b[endowments:age], _b[endowments:age] - invttail(e(N),0.025) * _se[endowments:age], _b[endowments:age] + invttail(e(N),0.025) * _se[endowments:age] \
			3, _b[endowments:female], _b[endowments:female] - invttail(e(N),0.025) * _se[endowments:female], _b[endowments:female] + invttail(e(N),0.025) * _se[endowments:female] \
			2, _b[endowments:personalfamily], _b[endowments:personalfamily] - invttail(e(N),0.025) * _se[endowments:personalfamily], _b[endowments:personalfamily] + invttail(e(N),0.025) * _se[endowments:personalfamily] \
			1, _b[endowments:cohort], _b[endowments:cohort] - invttail(e(N),0.025) * _se[endowments:cohort], _b[endowments:cohort] + invttail(e(N),0.025) * _se[endowments:cohort]
)
;
#delimit cr
matrix list A

recode german (0 = 1) (1 = 0)

preserve
	xsvmat A, saving(Decomposition,replace) names(w)

	clear
	use Decomposition.dta
	rename w1 order
		la var order "Order of variables"
	rename w2 coeff
		la var coeff "Coefficient, Oaxaca"
	rename w3 lb
		la var lb "Lower bound, Oaxaca"
	rename w4 ub
		la var ub "Upper bound, Oaxaca"
	gen variable = ""
		la var variable "Variable name"
	replace variable = "Total" if order == 7
	replace variable = "University degree" if order == 6
	replace variable = "University subject" if order == 5
	replace variable = "Age" if order == 4
	replace variable = "Gender" if order == 3
	replace variable = "Partner/Children" if order == 2
	replace variable = "Graduate cohort" if order == 1

	save Decomposition_formatted.dta, replace
restore

drop ln_incwagepredict
// Bootstrap
qui {
set seed 12345

forvalues r = 1/4999{
preserve
matrix drop _all
set more off

// Draw bootstrap sample
bsample, strata(german)

// Predicted Earnings
reg ln_incwage cohort2-cohort4 female age age_2 child married educd2-educd4 degfield2-degfield37 if german == 0, robust 
predict ln_incwagepredict, xb

recode german (0 = 1) (1 = 0)

oaxaca ln_incwagepredict (educ:educd2-educd4) (subject:degfield2-degfield37) (age: age age_2) female  (personalfamily: child married) (cohort:cohort2-cohort4) , by(german) relax

// Save coefficients in matrix
#delimit ;
matrix A`r' = (`r', 7 , _b[overall:difference] \
			   `r', 6 , _b[endowments:educ] \
			   `r', 5 , _b[endowments:subject] \
			   `r', 4 , _b[endowments:age] \
			   `r', 3 , _b[endowments:female] \
			   `r', 2 , _b[endowments:personalfamily] \ 
			   `r', 1 , _b[endowments:cohort])
;
#delimit cr
	xsvmat A`r', saving(Decomposition_bootstrap`r',replace) names(w)
restore
}
}
*

	use Decomposition_bootstrap1.dta, clear
	forval xx = 2/4999{
	append using Decomposition_bootstrap`xx'.dta
	}
	rename w1 round
	rename w2 order
	rename w3 coeffboot
	gen variable = ""
	replace variable = "Total" if order == 7
	replace variable = "University degree" if order == 6
	replace variable = "University subject" if order == 5
	replace variable = "Age" if order == 4
	replace variable = "Gender" if order == 3
	replace variable = "Partner/Children" if order == 2
	replace variable = "Graduate cohort" if order == 1
	save Decomposition_bootstrap.dta, replace

	clear
	use Decomposition_bootstrap.dta
	collapse  (mean) coeffboot, by(order variable)
	la var coeffboot "Coefficient, bootstrapped"
	save Decomposition_bootstrap_mean.dta, replace

	clear
	use Decomposition_bootstrap.dta
	collapse  (sd) coeffboot, by(order variable)
	rename coeffboot se
	la var se "SE, bootstrapped"
	save Decomposition_bootstrap_se.dta, replace

	
use Decomposition_formatted.dta, clear
merge 1:1 order using Decomposition_bootstrap_mean.dta
	drop _merge
merge 1:1 order using Decomposition_bootstrap_se.dta
	drop _merge
order variable order coeff

gen lbboot = coeff - invttail(298238,0.05)*se
	la var lbboot "Lower bound, bootstrapped"
gen ubboot = coeff + invttail(298238,0.05)*se
	la var ubboot "Upper bound, bootstrapped"	

gen tstat = coeff/se
	la var tstat "t-statistic"
gen pvalue = 2*ttail(298238,abs(tstat))
	la var pvalue "p-value"
gen stars = ""
	la var stars "Significance levels"
	replace stars = "***" if pvalue <= 0.01
	replace stars = "**" if pvalue > 0.01 & pvalue <= 0.05
	replace stars = "*" if pvalue > 0.05 & pvalue <= 0.1
	
	
// Figure 6b, left panel

gen marker = 0.26
gen label2 = ""
replace label2 = "(p=0.924)" if order == 1
replace label2 = "(p=0.169)" if order == 2
replace label2 = "(p=0.000)***" if order == 3
replace label2 = "(p=0.000)***" if order == 4
replace label2 = "(p=0.000)***" if order == 5
replace label2 = "(p=0.000)***" if order == 6
replace label2 = "(p=0.000)***" if order == 7

#delimit ;
graph twoway 
(bar coeff order if order == 1, horizontal color(gray) barwidth(.8))
(bar coeff order if order == 2, horizontal color(gray) barwidth(.8))
(bar coeff order if order == 3, horizontal color(gray) barwidth(.8))
(bar coeff order if order == 4, horizontal color(gray) barwidth(.8))
(bar coeff order if order == 5, horizontal color(gray) barwidth(.8))
(bar coeff order if order == 6, horizontal color(gray) barwidth(.8))
(bar coeff order if order == 7, horizontal color(black) barwidth(.8))
(scatter order ubboot if order != 7, msymbol(dh) mcolor(black))
(scatter order ubboot if order == 7, msymbol(dh) mcolor(gray))
(scatter order lbboot if order != 7, msymbol(dh) mcolor(black))
(scatter order lbboot if order == 7, msymbol(dh) mcolor(gray))
(scatter order marker, msymbol(i) mlabpos(3) mlabel(label2) mlabcolor(black) mlabsize(small)),

legend(off)
xline(0, lcolor(black))
graphregion(color(white))
xscale(range(0.00 0.30)) xtick(0.00(0.05)0.25) xlabel(0 "0" 0.05 "0.05" 0.1 "0.1" 0.15 "0.15" 0.2 "0.2" 0.25 "0.25", grid)

ylabel(1 "Graduate cohort" 2 "Partner/Children" 3 "Gender" 4 "Age" 5 "University subject" 6 "University degree" 7 "Total", notick nogrid angle(0))
ytitle("")
;
#delimit cr









