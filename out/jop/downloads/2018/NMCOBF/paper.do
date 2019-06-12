
clear *
set more off


/*-----------------------------------------------------------------------------------------*/
/* Figure 1 */
/*-----------------------------------------------------------------------------------------*/

* load conjoint survey
use conjoint-survey, clear

* first calculate legality AMCE 
ivregress 2sls dv_vote i.photo i.dist i.out_party i.record i.family i.crime ///
	i.w2010 i.wmult##i.legal (non_co_ethn = co_ethn_dummy), cl(id)
lincom (1.legal + (2.wmult#1.legal + 3.wmult#1.legal + 4.wmult#1.legal ///
	+ 5.wmult#1.legal + 6.wmult#1.legal)*(1/6))*(-1)
global legal_b = r(estimate)
global legal_se = r(se)
global legal_pval = (1-normal(abs(r(estimate)/r(se))))*2

* then store the other relevant results in a matrix
ivregress 2sls dv_vote i.photo i.dist i.out_party i.record i.family i.crime ///
	i.w2010r i.wmultr##i.legal (non_co_ethn = co_ethn_dummy), cl(id)
mat coef = e(b)
mat var = vecdiag(e(V))
matmap var se, m(sqrt(@))
mat tab = r(table)
scalar C = colsof(tab)
mat tab = tab[4..4,1..C]
mat coef = coef', se',tab'
* eliminate constant
scalar R = rowsof(coef)-1
mat coef = coef[1..R,1..3]
* put into a dataset
clear
svmat coef
* eliminate photo and district AMCEs
gen names = ""
local names : rownames coef
local k = 1
foreach j of local names {
	replace names = "`j'" in `k'
	local k = `k' + 1
	}
gen drop1 = regexm(names, "legal")
gen drop2 = regexm(names, "photo")
gen drop3 = regexm(names, "dist")
egen drop = rowtotal(drop*)
drop if drop == 1
drop drop*

* reorder ethnicity and add base category
expand 3 in 1
drop in 1
local pu = _N-1
foreach x in coef1 coef2 {
	replace `x' = 0 in `pu'
	}
replace names = "1b.non_co_ethn" in `pu'
replace coef3 = . if names == "1b.non_co_ethn"

* add legality AMCE saved above
local newn = _N+2
set obs `newn'
local pu = _N-1
foreach x in coef1 coef2 {
	replace `x' = 0 in `pu'
	}
replace names = "1b.legal" in `pu'
replace coef1 = $legal_b in `newn'
replace coef2 = $legal_se in `newn'
replace coef3 = $legal_pval in `newn'
replace names = "2.legal" in `newn'

* order AMCEs appropriately
gen lb = coef1 + invnormal(.025)*coef2
gen ub = coef1 + invnormal(.975)*coef2
local m 2 3 8 9 14 15 16 11 12 18 19 20 22 23 24 5 6 26 27
gen merge = .
local k = 1
foreach j of local m {
	replace merge = `j' in `k'
	local k = `k' + 1
	}
save graph_temp, replace
* final formatting
clear
set obs 8
local m 1 4 7 10 13 17 21 25
gen merge = .
local k = 1
foreach j of local m {
	replace merge = `j' in `k'
	local k = `k' + 1
	}
gen group = 1
merge 1:1 merge using graph_temp
sort merge
drop _m
foreach x in coef1 lb ub {
	replace `x' = 0 if `x' == .
	}
gen label = ""
for any "Co-partisanship:" "Yes" "No" "Co-ethnicity:" "Yes" "No" ///
	"Record:" "Good" "Bad" "Criminality:" "No" "Yes" ///
	"Background:" "Poor" "Middle-income" "Rich" "2010 wealth:" ///
	"Below median" "Median--75 pctile" "Above 75 pctile" ///
	"Wealth increase:" "No increase" "Below median" "Above median" ///
	"Illegal wealth incr.:" "No" "Yes" \ any 1 2 3 4 5 6 7 8 9 10 11 12 ///
	13 14 15 16 17 18 19 20 21 22 23 24 25 26 27: ///
replace label = "X" in Y
replace label = "Yes" if label == "2es"
replace label = "Yes" if label == "5es"
replace label = "Yes" if label == "12es"
replace label = "Yes" if label == "27es"
replace label = "{bf:" + label if group == 1
replace label = label + "}" if group == 1
gen order = _n
sort order
local obs = _N
forval i = 1/`obs' {
	local name = label in `i'
	label define order `i' "`name'", modify
	}
label values order order

* coefs and p-values for showing on second y-axis
gen coef = coef1
gen pval = coef3
foreach x in coef pval {
	tostring `x', replace force format(%9.2f)
	}
gen b1 = "["
gen b2 = "]"
egen pvala = concat(b1 pval b2)
replace pvala = "" if pvala == "[.]"
egen both = concat(coef pvala), punct(" ")
replace both = " " if both == "0.00"
	
gen order2 = _n
local obs = _N
forval i = 1/`obs' {
	local name = both in `i'
	lab def order2 `i' "`name'", modify
	}
lab val order2 order2

* graphing
twoway (scatter order coef1 if group == ., mcolor(black)) ///
	(scatter order coef1 if group == 1, mcolor(none)) ///
	(scatter order2 coef1, mcolor(none) yaxis(2)) ///
	(rcap ub lb order, horizontal msize(0) lcolor(black)), ///
	plotregion(color(gs13) lcolor(white)) ///
	legend(off) ///
	ylabel(#27, valuelab angle(0) labsize(small) notick glcolor(white) axis(2)) ///
	ylabel(#27, valuelab angle(0) labsize(small) notick glcolor(white)) ///
	yscale(reverse lcolor(white)) yscale(reverse lcolor(white) axis(2)) ///
	graphregion(color(white)) ///
	ytitle("") ytitle("", axis(2)) ///
	xline(0, lcolor(black) lwidth(vvthin)) ///
	xscale(lcolor(white)) ///
	xtitle("Effect on Pr(voting for candidate)")
	gr_edit yaxis2.style.editstyle draw_major_grid(yes) editcopy
erase graph_temp.dta


/*-----------------------------------------------------------------------------------------*/
/* Figure 2 */
/*-----------------------------------------------------------------------------------------*/

cap prog drop recode_info
program define recode_info
	foreach x in MLA_assetBG MLA_assetINC MLA_incBG {
		foreach y in own bihar {
			recode `y'`x' (88/99 = .)
			}
		}
	gen mlan_correct = (MLAnameid == 4)
	gen mlap_correct = (MLApartyid == 4)
end

* load second ("information") survey
use second-survey, clear

* variables to store predicted values
forval i = 1/2 {
	foreach x in g d lb ub {
		gen `x'`i'_inc = .
		}
	}
/* Good vs. bad guesses for own MLA
	For Shekhar: "two times" is the best guess
	For Rishidev: "five times" is the best guess. */
replace ownMLA_incBG = 1 if ownMLA_assetINC == 0
gen bad_guess = ownMLA_incBG-2 if MLA == "Chandra Shekhar"
replace bad_guess = ownMLA_incBG-4 if MLA == "Ramesh Rishidev"

* predicted probabilities from multinomial logit
gen wmult = _n in 1/6
lab def wmult 1 "0-0.2x" 2 "2x" 3 "3x" 4 "5x" 5 "10x" 6 "30x", replace
lab val wmult wmult
* covariates
global covar _age _schooling income _assets _occ4 
* Shekhar
qui mlogit ownMLA_incBG $covar if MLA == "Chandra Shekhar", r
margins, post
forval i = 1/6 {
	replace g1_inc = _b[`i'._predict] in `i'
	}
qui mlogit bad_guess $covar if MLA == "Chandra Shekhar", r
margins, post
mat tab = r(table)
foreach x in 1 3 4 5 6 {
	lincom _b[`x'._predict]-_b[2._predict]
	replace d1_inc = r(estimate) in `x'
	replace lb1_inc = r(estimate)+invnormal(.025)*r(se) in `x'
	replace ub1_inc = r(estimate)+invnormal(.975)*r(se) in `x'
	}
format g1_inc %9.2g
twoway (bar g1_inc wmult if wmult ~= 2, color(gs10)) ///
	(bar g1_inc wmult if wmult == 2, color(gs5)) ///
	(rcap lb1_inc ub1_inc wmult, msize(0) lcolor(black)) ///
	(scatter d1_inc wmult, msymbol(O) mcolor(black)) ///
	(scatter g1_inc wmult, msym(none) mlab(g1_inc) mlabpos(11) mlabcolor(black)), /// 
	legend(off) xlabel(#7, valuelab) xtitle("") aspect(.7) ///
	ytitle("Proportion (bars)," "difference in probabilities (caps)") ///
	title(Chandra Shekhar) scheme(s1mono) name(m1, replace) nodraw
* Rishidev
qui mlogit ownMLA_incBG $covar if MLA ~= "Chandra Shekhar", r
margins, post
forval i = 1/6 {
	replace g2_inc = _b[`i'._predict] in `i'
	}
qui mlogit bad_guess $covar if MLA ~= "Chandra Shekhar", r
margins, post
mat tab = r(table)
foreach x in 1 2 3 5 6 {
	lincom _b[`x'._predict]-_b[4._predict]
	replace d2_inc = r(estimate) in `x'
	replace lb2_inc = r(estimate)+invnormal(.025)*r(se) in `x'
	replace ub2_inc = r(estimate)+invnormal(.975)*r(se) in `x'
	}
format g2_inc %9.2g
twoway (bar g2_inc wmult if wmult ~= 4, color(gs10)) ///
	(bar g2_inc wmult if wmult == 4, color(gs5)) ///
	(rcap lb2_inc ub2_inc wmult, msize(0) lcolor(black)) ///
	(scatter d2_inc wmult, msymbol(O) mcolor(black)) ///
	(scatter g2_inc wmult, msym(none) mlab(g2_inc) mlabpos(11) mlabcolor(black)), /// 
	legend(off) xlabel(#7, valuelab) xtitle("") aspect(.7) ///
	ytitle("Proportion (bars)," "difference in probabilities (caps)") ///
	title(Ramesh Rishidev) scheme(s1mono) name(m2, replace) nodraw
gr combine m1 m2, scheme(s1mono) ycommon xsize(6) ysize(3)


/*-----------------------------------------------------------------------------------------*/
/* Figure 3 */
/*-----------------------------------------------------------------------------------------*/

* load conjoint survey
use conjoint-survey, clear

* running logit to avoid non-sensical predictions
* results very similar with OLS or 2SLS
logit dv_vote i.photo i.dist i.out_party i.record i.family i.crime ///
	i.w2010 i.wmultr non_co_ethn, cl(id)
margins, at(record=(1 2) wmultr=(1 3)) post
mat res = r(table)
matrix out = J(4,3,.)
forval i = 1/4 {
	matrix out[`i',1] = res[1,`i']
	matrix out[`i',2] = res[5,`i']
	matrix out[`i',3] = res[6,`i']
	}

* test the difference between good record and large accumulation 
* vs. bad record and no wealth increase
lincom _b[2._at] - _b[3._at]

* graph	
clear
svmat out
rename out1 est
rename out2 lb
rename out3 ub

gen order = _n
label define order 1 "Good record, no wealth increase" ///
		2 `""Good record, above-median" "wealth increase""' ///
		3 "Bad record, no wealth increase" ///
		4 `""Bad record, above-median" "wealth increase""'
label values order order
twoway (scatter order est, mcolor(black)) ///
	(rcap ub lb order, horizontal msize(0) lcolor(black)), ///
	legend(off) yscale(reverse) ///
	ylabel(#4, valuelab angle(0) notick ///
	glcolor(white)) plotregion(color(gs13) lcolor(white)) ///
	graphregion(color(white)) ///
	ytitle("") yscale(lcolor(white)) xscale(lcolor(white)) ///
	xtitle("Predicted Pr(vote for candidate)") aspect(1)


/*-----------------------------------------------------------------------------------------*/
/* Figure 4 */
/*-----------------------------------------------------------------------------------------*/

* load conjoint survey
use conjoint-survey, clear

* variables to store predicted values
foreach x in est lb ub {
	gen `x' = .
	}
egen rjd = seq() in 1/8, from(1) to(4) block(2)
egen order = seq() in 1/8, from(1) to(2)
replace order = 1.1 if order == 2

* program to store estimates and CIs for graphs
program getest
	args z w /* z = row number for below-median wealth increase estimates 
				w = row number for above-median wealth increase estimates */
	* effect of below-median wealth increase
	lincom _b[2.wmultr]
	replace est = _b[2.wmultr] in `z'
	replace lb = _b[2.wmultr]+invnormal(.025)*_se[2.wmultr] in `z'
	replace ub = _b[2.wmultr]+invnormal(.975)*_se[2.wmultr] in `z'
	* effect of above-median wealth increase
	lincom _b[3.wmultr]
	replace est = _b[3.wmultr] in `w'
	replace lb = _b[3.wmultr]+invnormal(.025)*_se[3.wmultr] in `w'
	replace ub = _b[3.wmultr]+invnormal(.975)*_se[3.wmultr] in `w'
end

* Yadav respondents and RJD candidates
qui ivregress 2sls dv_vote i.photo i.dist i.out_party i.record i.family i.crime ///
	i.w2010r i.wmultr##i.legal (non_co_ethn = co_ethn_dummy) ///
	if _ethnicity == "yadav" & party == 1, cl(id)
getest 1 2

* Yadav respondents and non-RJD candidates
qui ivregress 2sls dv_vote i.photo i.dist i.out_party i.record i.family i.crime ///
	i.w2010r i.wmultr##i.legal (non_co_ethn = co_ethn_dummy) ///
	if _ethnicity == "yadav" & party != 1, cl(id)
getest 3 4

* Non-Yadav respondents and RJD candidates
qui ivregress 2sls dv_vote i.photo i.dist i.out_party i.record i.family i.crime ///
	i.w2010r i.wmultr##i.legal (non_co_ethn = co_ethn_dummy) ///
	if _ethnicity != "yadav" & party == 1, cl(id)
getest 5 6

* Non-Yadav respondents and non-RJD candidates
qui ivregress 2sls dv_vote i.photo i.dist i.out_party i.record i.family i.crime ///
	i.w2010r i.wmultr##i.legal (non_co_ethn = co_ethn_dummy) if _ethnicity != "yadav" & party != 1, cl(id)
getest 7 8

* graph
* Yadavs, RJD
twoway (scatter order est if rjd == 1, msymbol(O) mcolor(black)) ///
	(rcap lb ub order if rjd == 1, lcolor(black) msize(0) horizontal), ///
	legend(off) ylabel(1 `""Below-median" "wealth increase""' 1.1 `""Above-median" "wealth increase""', angle(0) notick ///
	glcolor(white)) plotregion(color(gs13) lcolor(white)) ///
	graphregion(color(white)) yscale(range(.95(.05)1.15) reverse) ///
	ytitle("") xline(0, lcolor(black) lwidth(vvthin)) ///
	yscale(lcolor(white)) xscale(lcolor(white)) ///
	xtitle("Effect on" "Pr(voting for candidate)") aspect(1) ///
	title("Yadavs and" "RJD candidate", color(black)) name(yrjd, replace) nodraw
* Non-Yadavs, RJD
twoway (scatter order est if rjd == 2, msymbol(O) mcolor(black)) ///
	(rcap lb ub order if rjd == 2, lcolor(black) msize(0) horizontal), ///
	legend(off) ylabel(1 `""Below-median" "wealth increase""' 1.1 `""Above-median" "wealth increase""', angle(0) notick ///
	glcolor(white)) plotregion(color(gs13) lcolor(white)) ///
	graphregion(color(white)) yscale(range(.95(.05)1.15) reverse) ///
	ytitle("") xline(0, lcolor(black) lwidth(vvthin)) ///
	yscale(lcolor(white)) xscale(lcolor(white)) ///
	xtitle("Effect on" "Pr(voting for candidate)") aspect(1) ///
	title("Non-Yadavs and" "RJD candidate", color(black)) name(nyrjd, replace) nodraw
* Yadavs, non-RJD
twoway (scatter order est if rjd == 3, msymbol(O) mcolor(black)) ///
	(rcap lb ub order if rjd == 3, lcolor(black) msize(0) horizontal), ///
	legend(off) ylabel(1 `""Below-median" "wealth increase""' 1.1 `""Above-median" "wealth increase""', angle(0) notick ///
	glcolor(white)) plotregion(color(gs13) lcolor(white)) ///
	graphregion(color(white)) yscale(range(.95(.05)1.15) reverse) ///
	ytitle("") xline(0, lcolor(black) lwidth(vvthin)) ///
	yscale(lcolor(white)) xscale(lcolor(white)) ///
	xtitle("Effect on" "Pr(voting for candidate)") aspect(1) ///
	title("Yadavs and" "non-RJD candidate", color(black)) name(ynrjd, replace) nodraw
* Non-Yadavs, non-RJD
twoway (scatter order est if rjd == 4, msymbol(O) mcolor(black)) ///
	(rcap lb ub order if rjd == 4, lcolor(black) msize(0) horizontal), ///
	legend(off) ylabel(1 `""Below-median" "wealth increase""' 1.1 `""Above-median" "wealth increase""', angle(0) notick ///
	glcolor(white)) plotregion(color(gs13) lcolor(white)) ///
	graphregion(color(white)) yscale(range(.95(.05)1.15) reverse) ///
	ytitle("") xline(0, lcolor(black) lwidth(vvthin)) ///
	yscale(lcolor(white)) xscale(lcolor(white)) ///
	xtitle("Effect on" "Pr(voting for candidate)") aspect(1) ///
	title("Non-Yadavs and" "non-RJD candidate", color(black)) name(nynrjd, replace) nodraw
gr combine yrjd nyrjd ynrjd nynrjd, xcommon ycommon graphregion(color(white)) ///
	iscale(.6) xsize(4) ysize(4)
	
	
* clear all graphs
gr drop _all
