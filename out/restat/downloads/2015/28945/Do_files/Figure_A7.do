*-----------------------------------------------------------------------------------------------------------------------------*
* This do file constructs Figure A.7 of the web appendix of Berman and Couttenier (2014)									  *
* This version: january 29, 2014																							  *
*-----------------------------------------------------------------------------------------------------------------------------*
*
clear all
cd "$Results"
						*--------------------------------------------------*
						*--------------------------------------------------*
						*    		FIGURE A.7- Crises and trade		   *    
						*--------------------------------------------------*
						*--------------------------------------------------*

* Statistics on crises */
use "$Output_data\trade_crises_ijt", clear
collapse (max) crisis*, by(iso_d year)
keep if crisis == 1

g crisis_a = crisis_1+crisis_2
g crisis_b = crisis_3+crisis_4+crisis_5
g crisis_c = crisis_6+crisis_7+crisis_8+crisis_9
g crisis_d = crisis_10+crisis_11+crisis_12

foreach x in "_a" "_b" "_c" "_d"{
di "`x'"
distinct iso_d if crisis`x' == 1
}
forvalues x=1(1)12{
di "`x'"
distinct iso_d if crisis_`x' == 1
}
***************************
*98 crisis episodes
*66 last at least 2 years
*Half last 4 years	
***************************
*
use "$Output_data\trade_crises_ijt", clear
tsset dyad year
*
/* construct bins */
g crisis_a = crisis_1+crisis_2
g crisis_b = crisis_3+crisis_4+crisis_5
g crisis_c = crisis_6+crisis_7+crisis_8
g crisis_d = crisis_9+crisis_10+crisis_11+crisis_12
*
drop crisis_1-crisis_12
*
rename crisis_a crisis_1
rename crisis_b crisis_2
rename crisis_c crisis_3
rename crisis_d crisis_4
*
save temp, replace
use temp, clear
sum crisis*, d
qui statsby "xtreg lflow crisis_* yeard* if acled1 == 1 | acled2 == 1 | ucdp == 1, fe r cluster(dyad)" _b _se, clear
expand 4
gen crisis = .
g bk=.
g se_bk=.
forvalues x=1(1)4{
replace crisis=`x' if _n==`x'
replace bk=b_crisis_`x' if _n==`x'
replace se_bk=se_crisis_`x' if _n==`x'
}
gen beta_bk_min = bk - 1.64*se_bk
gen beta_bk_max = bk + 1.64*se_bk
keep beta_bk* se_bk* bk* crisis
g zero=0
local zero=zero
label define crisis 1 "1-2" 2 "3-5" 3 "6-8" 4 "9+" 
label values crisis crisis
*
twoway rarea beta_bk_min beta_bk_max crisis, bsty(ci) sort  xlab(1 2 3 4, valuelab) ///
|| scatter bk crisis, xline(0) scheme(s1mono) c(l l) m(s i) xtitle("Crisis year") ///
|| line zero crisis, ///
title("Effect of crisis (1=first year)", pos(11) ring(11) size(medium)) legend(off)  ysize(4) xsize(6) scale(0.8)
graph export crisis_effect.eps, as(eps) replace
erase temp.dta

