*this is to generate country specific figure of ILM variance
use "conditional_allctys.dta", clear
gen riteleft_nml =51.440849 - riteleft
gen govid2006_1_us = govid2006_1
replace govid2006_1_us = riteleft_nml if wbcode=="USA"

gen govid2006_1_inv = 100 - govid2006_1
gen govid2006_1_us_inv = 100 - govid2006_1_us

drop if year>1999
keep if oecd==1

gen C_cent = .
replace C_cent =0 if (barglev2==1 | barglev2==2)
replace C_cent =1 if barglev2==3
replace C_cent =2 if (barglev2==4 | barglev2==5)

*the following do file create the moving average of lagged variable over the 3/5/10 previous years
sort ctycode year
**the centralized union
gen ccent_temp = l1.C_cent
****************************
label variable beta_all "Labor Mobility"
twoway (connected beta_all year, sort), yline(0) by(, title(Variance of Labor Mobility) note(Graphs by country)) by(wbcode)
*graph export "D:\Stata12\working\ii\variance_ILM.pdf", as(pdf) replace
*********************************
*The following is to draw figure 3.1(s)
***************
run "conditional_prep.do"
gen xz= govid2006_1_us_inv * C_cent

estimates clear
graph drop _all
set more off

xi: xtpcse beta_all govid2006_1_us_inv C_cent xz lnpop65 unemploy_pct_labor gdp_pc_ppp_cur_thd openness gdp_growth cpi_allitems state eu year i.ctycode, het corr(ar1)

quietly do "ci_graph.do"
twoway (line conb Z, lcolor(black) lpattern(solid) lwidth(medium)) (line top Z, lcolor(black) lpattern(dash) lwidth(thin)) ///
(line bottom Z, lcolor(black) lpattern(dash) lwidth(thin)), ytitle(Marginal Partisanship Effect, margin(sides)) yline(0) ///
xtitle(Union Centralization) title("(s): Partisan Influence on ILM using Continuous Partisanship Measure", size(medsmall) position(11)) ///
legend(off) scheme(sj) graphregion(ifcolor(white)) ///
yscale(noline) xscale(noline) yline(-.03 -.02 -.01 .01 .02, lcolor(white)) xlabel(0 1 2)

graph copy gm1_smooth

drop Z conb conse a top bottom

graph combine gm1_smooth, iscale(*1) title("Figure 3.1(s): Estimated marginal partisan influence on levels of ILM", ///
size(medsmall)) subtitle("Conditional on Union Centralization and using PCSE", size(medsmall)) ///
caption("Circles represent marginal influence on ILM, squares represent 95% confidence intervals", size(small) ///
position(6) box fcolor(white)) scheme(sj) 


