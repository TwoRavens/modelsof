clear all

use "working.dta", clear

* Table 1. Each grouping corresponds to one section of the table.
sum impressions if gaffe==0 & ownad==1
di r(N) * r(mean) // # impressions
scalar denom = r(N) * r(mean)
sum clicks if gaffe==0 & ownad==1 
di r(N) * r(mean) // # clicks 
scalar num = r(N) * r(mean)
di (num / denom) * 100 // click-through percentage

sum impressions if gaffe==0 & ownad==0
di r(N) * r(mean) // # impressions
scalar denom = r(N) * r(mean)
sum clicks if gaffe==0 & ownad==0
di r(N) * r(mean) // # clicks. 
scalar num = r(N) * r(mean)
di (num / denom) * 100 // click-through percentage

sum impressions if gaffe==0 & ind==1
di r(N) * r(mean) // # impressions
scalar denom = r(N) * r(mean)
sum clicks if gaffe==0 & ind==1
di r(N) * r(mean) // # clicks 
scalar num = r(N) * r(mean)
di (num / denom) * 100 // click-through percentage

sum impressions if gaffe==1 & ownad==1
di r(N) * r(mean) // # impressions
scalar denom = r(N) * r(mean)
sum clicks if gaffe==1 & ownad==1 
di r(N) * r(mean) // # clicks 
scalar num = r(N) * r(mean)
di (num / denom) * 100 // click-through percentage

sum impressions if gaffe==1 & ownad==0
di r(N) * r(mean) // # impressions
scalar denom = r(N) * r(mean)
sum clicks if gaffe==1 & ownad==0
di r(N) * r(mean) // # clicks. 
scalar num = r(N) * r(mean)
di (num / denom) * 100 // click-through percentage

sum impressions if gaffe==1 & ind==1
di r(N) * r(mean) // # impressions
scalar denom = r(N) * r(mean)
sum clicks if gaffe==1 & ind==1
di r(N) * r(mean) // # clicks 
scalar num = r(N) * r(mean)
di (num / denom) * 100 // click-through percentage

* Table 2
reg ctpr gaffe [aw=impressions], robust
reg ctpr gaffe female geog relat age2 [aw=impressions], robust
reg ctpr gaffe female geog relat age2 [aw=impressions] if lib==1, robust
reg ctpr gaffe female geog relat age2 [aw=impressions] if cons==1, robust
reg ctpr gaffe female geog relat age2 [aw=impressions] if ind==1, robust

* Table 3, left side
preserve
keep if gaffe==0
reg ctpr ownad [aw=impressions], robust
reg ctpr ownad female geog relat age2 [aw=impressions], robust
reg ctpr ownad female geog relat age2 [aw=impressions] if lib==1, robust
reg ctpr ownad female geog relat age2 [aw=impressions] if cons==1, robust
restore

* Table 3, right side
preserve
keep if gaffe==1
reg ctpr ownad [aw=impressions], robust
reg ctpr ownad female geog relat age2 [aw=impressions], robust
reg ctpr ownad female geog relat age2 [aw=impressions] if lib==1, robust
reg ctpr ownad female geog relat age2 [aw=impressions] if cons==1, robust
restore

* Figure 2
reg ctpr ownad##gaffe female geog relat age2 [aw=impressions], robust
margins, at(ownad=(0 1) gaffe=(0 1)) atmeans
collapse (mean) ctpr (semean) sectpr=ctpr [aw=impressions], by(ownad gaffe)

* These numbers come from the margins command above. Regression-adjusted means and standard errors.
replace ctpr = .8096 in 1
replace sectpr = .1278 in 1
replace ctpr = 1.045 in 2
replace sectpr = .0773 in 2
replace ctpr = 1.010 in 3
replace sectpr = .0998 in 3
replace ctpr = 1.681 in 4
replace sectpr = .1879 in 4

* Standard error whiskers
gen sehigh = ctpr+sectpr
gen selow = ctpr-sectpr

gen space = . // space = where the bar will be on the x-axis
replace space = 0 if gaffe==0 & ownad==0
replace space = 1 if gaffe==1 & ownad==0
replace space = 2.5 if gaffe==0 & ownad==1
replace space = 3.5 if gaffe==1 & ownad==1

* Make Figure
set scheme sj
twoway (bar ctpr space if gaffe==0) ///
	(bar ctpr space if gaffe==1) ///
	(rcap sehigh selow space, lcolor(black)), ///
	legen(row(1) order(1 "Policy" 2 "Gaffe")) ///
	xlabel( .5 "Inconsistent" 3 "Consistent") ///
	xtitle("") ///
	ytitle("Click-through percentage * 100") ///
	ysc(r(0 1.8)) ///
	ylab(0(.4)1.8)
	
* "Overall, our ads were displayed..."
use "working.dta", clear
sum impressions
di 16569.42*846 // Total impressions
sum clicks
di 1.7068 * 846 // Total clicks

* "As a result, the number of ad displays..."
sum impressions, detail // examine max and min

* Paragraph about cost
* Assumption: $0.07 for 1,000 impressions (Approximate actual cost in our study)
* $1,000 Campaign buys (1000/.07) * 1000 = 14,285,714 impressions. Rounded to 14M
* Clicks in Policy campaign: 14000000 * .00009085 = 1,272
* Clicks in Gaffe campaign: 14000000 * (.00009085 + .0000235) = 1,601
* Cost per click in Policy campaign: 1000 / 1272 = $0.78
* Cost per click in Gaffe campaign: 1000 / 1601 = $0.62

* "... the estimated effect of the gaffe manipulation among 
* individuals who saw an uncongenial ad is positive (but not significant: p<.22)"
reg ctpr gaffe female geog relat age2 if ownad==0 [aw=impressions], robust

* Footnote 15
use "working.dta", clear
tab impressions // look at 10th and 90th percentile

* Table A3
use "working.dta", clear
tobit ctpr gaffe [aw=impressions], ll(0) robust
tobit ctpr gaffe female geog relat age2 [aw=impressions], ll(0) robust
tobit ctpr gaffe female geog relat age2 [aw=impressions] if lib==1, ll(0) robust
tobit ctpr gaffe female geog relat age2 [aw=impressions] if cons==1, ll(0) robust
tobit ctpr gaffe female geog relat age2 [aw=impressions] if ind==1, ll(0) robust

* Table A4, left side
preserve
keep if gaffe==0
tobit ctpr ownad [aw=impressions], ll(0) robust
tobit ctpr ownad female geog relat age2 [aw=impressions], ll(0) robust
tobit ctpr ownad female geog relat age2 [aw=impressions] if lib==1, ll(0) robust
tobit ctpr ownad female geog relat age2 [aw=impressions] if cons==1, ll(0) robust
restore

* Table A4, right side
preserve
keep if gaffe==1
tobit ctpr ownad [aw=impressions], ll(0) robust
tobit ctpr ownad female geog relat age2 [aw=impressions], ll(0) robust
tobit ctpr ownad female geog relat age2 [aw=impressions] if lib==1, ll(0) robust
tobit ctpr ownad female geog relat age2 [aw=impressions] if cons==1, ll(0) robust
restore

* Table A5
reg ctpr ownad##gaffe [aw=impressions], robust
reg ctpr ownad##gaffe female geog relat age2 [aw=impressions], robust

* The combination of 1) a Tobit model, 2) interaction terms, and 
* 3) the robust option causes Stata to get standard errors wrong. 
* Hence, these are specified as interval regressions, which 
* are mathematically equivalent to Tobit in this case, and 
* generate correct standard errors.

intreg ctpr2 ctpr3 ownad##gaffe [aw=impressions], robust
intreg ctpr2 ctpr3 ownad##gaffe female geog relat age2 [aw=impressions], robust

* Just for reference, the Tobit models with ridiculous (wrong) standard errors:
tobit ctpr ownad##gaffe [aw=impressions], ll(0) robust
tobit ctpr ownad##gaffe female geog relat age2 [aw=impressions], ll(0) robust
