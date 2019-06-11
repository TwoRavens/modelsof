***do file for Carlin et al. “Public Support for Latin American Presidents: The Cyclical Model in Comparative Perspective”

**Set using directory
cd "R&P submission"

use "r&p_ead_data.dta", replace
log using "log file.smcl", replace
**fig 1country by country figure
preserve
drop if LA_country~=1
twoway (line approval qtr  if LA_country==1, sort) (bar presidentialelection qtr  if LA_country==1, yaxis(2)) if   approval~=., legend(off) yscale(off axis(2))  xlabel(, angle(forty_five)) by(, graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))) by(country, cols(3) note(`""')) 
graph save Graph "approval (fig_1).gph", replace
restore

**polynomial smoothing graph
*fig2
twoway  (lpolyci approval std_ticker if country_code==21, degree(1) ciplot(rspike) clcolor(dknavy) clpattern(longdash) blcolor(dknavy)) (lpolyci approval std_ticker if LA_country==1, degree(1) ciplot(rspike) clcolor(midgreen) blcolor(midgreen)), title(`"Approval"', size(small)) legend (off) ytitle(`"Executive Approval"', size(small)) xtitle(`""') graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
graph save Graph "approval (fig2_1).gph", replace

twoway (lpolyci mc_approval std_ticker if country_code==21, degree(1) ciplot(rspike) clcolor(dknavy) clpattern(longdash) blcolor(dknavy)) (lpolyci mc_approval std_ticker if LA_country==1, degree(1) ciplot(rspike) clcolor(midgreen) blcolor(midgreen)),   title(`"Mean-Centered Approval"', size(small)) legend (off) ytitle(`"Mean-Centered Executive Approval"', size(small)) xtitle(`""') graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
graph save Graph "mc_approval (fig2_2).gph", replace


graph combine "approval (fig2_1).gph" "mc_approval (fig2_2).gph", graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) note(`"Proportion of Term"', pos(6))
graph save Graph "fig 2.gph", replace



***average at 6 month vs mean overall in LA
mean approval if admin_ticker==2 & LA_country==1
mean approval if LA_country==1

***country by country smoothing graph
twoway (lpolyci mc_approval std_ticker if LA_country==1, degree(1) ciplot(rspike)),   legend (off) ytitle(`"Mean-Centered Executive Approval"', size(small)) xtitle(`""') by(, graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)))  by(country_code) legend (off) xtitle(`""')
graph save Graph "mc_approval_by_country (fig3).gph", replace


 
***baseline regression model for honeymoons
  xtreg l(0/1).c.approval   l(0/2).presidentialelection f(1/2).presidentialelection l(0/1).q_grow_pc  l(0/1).q_log_inflation  if LA_country==1, fe

	outreg2 using "model0", excel replace

	***LRM
	mat beta=e(b)
	mat list beta
svmat  beta
gen lrm=(beta2+ beta3+ beta4)/(1-beta1)
sum lrm
gen beta1_r= beta1
replace beta1_r= beta1_r[_n-1] if beta1_r==.
gen q_period= beta2
replace q_period=(q_period[_n-1]*beta1[_n-1])+ beta3[_n-1] if q_period[_n-1]~=.
replace q_period=(q_period[_n-1]*beta1[_n-2])+ beta4[_n-2] if q_period[_n-1]~=. & q_period==.
replace q_period=(q_period[_n-1]*beta1_r) if q_period[_n-1]~=. & q_period==.

egen counter=seq()

twoway (bar q_period counter if  counter<17,  fcolor(gs9) barwidth(.7)), legend(on order(1)) title("Short and Long-Run Effects of Honeymoon", size(small)) ytitle(`"Honeymoon Effect (Apperoval Percentage Points)"', size(small)) xtitle(`"Quarters"', size(small)) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) legend(off)
graph save Graph "honeymoon LRM .gph", replace

	***Descriptive Stats: Table A1
***Descriptive Stats: Table A1
***for covariates in baseline model
sum   q_grow_pc  q_log_inflation  presidentialelection admin_ticker if e(sample) &  LA_country==1

**descriptive stat for all approval series in Latin America
  sum approval   if LA_country==1

	
	****unitroot tests for variables in baseline model
	xtunitroot ips q_grow_pc if e(sample)  &  LA_country==1, lags(1)
	xtunitroot ips approval if e(sample)  &  LA_country==1, lags(1)
	xtunitroot ips q_log_inflation if e(sample)  &  LA_country==1, lags(1)
	
	
	
******Figures for Appendix
twoway (line approval qtr, sort) (bar presidentialelection qtr, yaxis(2)) if  country_code==21 & approval~=., legend(off) yscale(off axis(2))  xlabel(, angle(forty_five)) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
graph save Graph "us approval (figA1).gph", replace


****no full terms vs all
twoway (lpolyci approval std_ticker if LA_country==1,  degree(1) ciplot(rspike) clcolor(dknavy) clpattern(longdash) blcolor(dknavy))(lpolyci approval std_ticker if no_full_term_completed==0 & LA_country==1, degree(1) ciplot(rspike) clcolor(midgreen) blcolor(midgreen)), title(`"Approval"', size(small)) legend (on) ytitle(`"Executive Approval"', size(small)) xtitle(`""') graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))
graph save Graph "approval term lengths (figA2).gph", replace



**V-Dem clientelism
gen clientelist= party_links
recode clientelist 0=1 2=0 3=0 4=0
twoway (lpolyci mc_approval std_ticker if party_links<2 & LA_country==1,  degree(1) ciplot(rspike) clcolor(dknavy) clpattern(longdash) blcolor(dknavy))(lpolyci mc_approval std_ticker if party_links>1 & LA_country==1, degree(1) ciplot(rspike) clcolor(midgreen) blcolor(midgreen)), title("Approval by Party Linkage Types", size(small)) ytitle(`"Mean-Centered Executive Approval"', size(small)) xtitle(`"Proportion of Term"', size(small)) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) legend(on order(2 4)) 
graph save Graph "clientelist-vdem .gph", replace

xtreg l(0/1).c.approval  l(0 2 1 3 4 7 8).presidentialelection l( 5 6).presidentialelection f(1/2).presidentialelection    l(0/1).q_grow_pc  l(0/1).q_log_inflation if LA_country==1, fe
estimates store m1
xtreg l(0/1).c.approval  l(0 2 1 3 4 7 8).presidentialelection l( 5 6).presidentialelection##clientelist f(1/2).presidentialelection    l(0/1).q_grow_pc  l(0/1).q_log_inflation if LA_country==1, fe
estimates store m2
lrtest m1 m2


 ***majority government
twoway (lpolyci mc_approval std_ticker if majority_gov==0 & LA_country==1,  degree(1) ciplot(rspike) clcolor(dknavy) clpattern(longdash)  blcolor(dknavy))(lpolyci mc_approval std_ticker if majority_gov==1 & LA_country==1, degree(1) ciplot(rspike) clcolor(midgreen)  blcolor(midgreen)), title(`"Approval by Type of Government"', size(small)) legend (on) ytitle(`"Mean-Centered Executive Approval"', size(small)) xtitle(`"Proportion of Term"', size(small)) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) legend(on order(2 4))
 graph save Graph "majoritarian gov .gph" , replace

  xtreg l(0/1).c.approval  l(0/2).presidentialelection  f(1/2).presidentialelection    l(0/1).q_grow_pc  l(0/1).q_log_inflation if LA_country==1, fe
estimates store m1
 xtreg l(0/1).c.approval  l(0/2).presidentialelection  f(1/2).presidentialelection##majority    l(0/1).q_grow_pc  l(0/1).q_log_inflation if LA_country==1, fe
 estimates store m2
lrtest m1 m2

 
 ****party volitility
 twoway (lpolyci mc_approval std_ticker if average_volatility<27 & LA_country==1 ,  degree(1) ciplot(rspike) clcolor(dknavy) clpattern(longdash) blcolor(dknavy))(lpolyci mc_approval std_ticker if average_volatility>27 & LA_country==1, degree(1) ciplot(rspike) clcolor(midgreen) blcolor(midgreen)), title("Approval by Party System Volitility", size(small)) ytitle(`"Mean-Centered Executive Approval"', size(small)) xtitle(`"Proportion of Term"', size(small)) graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) legend(on order(2 4)) 
  graph save Graph "majoritarian gov .gph", replace
  
 reg l(0/1).c.approval  l(0/2 ).presidentialelection##c.average_volatility  f(1/2).presidentialelection##c.average_volatility     l(0/1).q_grow_pc  l(0/1).q_log_inflation if LA_country==1, 
estimates store m1
  reg l(0/1).c.approval  l(0/2 ).presidentialelection f(1/2).presidentialelection     l(0/1).q_grow_pc  l(0/1).q_log_inflation if LA_country==1 & e(sample)
  estimates store m2
lrtest m1 m2
**dummying or excluding the no completed term presidents doesn't matter--tables for appendix


xtreg l(0/1).c.approval  l(0/2).presidentialelection f(1/2).presidentialelection   l(0/1).q_grow_pc  l(0/1).q_log_inflation no_full_term_completed if LA_country==1, fe
outreg2 using "modelA0", excel replace
xtreg l(0/1).c.approval   l(0/2).presidentialelection f(1/2).presidentialelection l(0/1).q_grow_pc  l(0/1).q_log_inflation if no_full_term_completed==0 & LA_country==1 , fe
outreg2 using "modelA1", excel replace


***excluding those that serve 2 years or less

  xtreg l(0/1).c.approval    l(0/2).presidentialelection f(1/2).presidentialelection l(0/1).q_grow_pc  l(0/1).q_log_inflation if max_tic>8  & LA_country==1, fe
outreg2 using "modelA2", excel replace


*****random-effects, robust clustered standard errors, and panel-corrected standard errors specifications
**Random effectsfu
xtreg l(0/1).c.approval    l(0/2).presidentialelection f(1/2).presidentialelection l(0/1).q_grow_pc  l(0/1).q_log_inflation if LA_country==1, re
outreg2 using "modelA3", excel replace

***robust SE
reg l(0/1).c.approval   l(0/2).presidentialelection f(1/2).presidentialelection  l(0/1).q_grow_pc  l(0/1).q_log_inflation if LA_country==1, cl(country_code)
outreg2 using "modelA4", excel replace

***PCSE SE
xtpcse l(0/1).c.approval    l(0/2).presidentialelection f(1/2).presidentialelection l(0/1).q_grow_pc  l(0/1).q_log_inflation if LA_country==1, 
outreg2 using "modelA5", excel replace



log close




