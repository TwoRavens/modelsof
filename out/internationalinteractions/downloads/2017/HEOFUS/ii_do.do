run "conditional_prep.do"
gen xz= govid2006_1_us_inv * C_cent

estimates clear
graph drop _all
set more off

xi: xtpcse beta_all govid2006_1_us_inv C_cent xz lnpop65 unemploy_pct_labor gdp_pc_ppp_cur_thd openness gdp_growth cpi_allitems state eu year i.ctycode, het corr(ar1)

estimates store m1
quietly do "ci_graph_temp.do"

twoway  (connected conb Z, msymbol(circle) lcolor(gs10) lpattern(dash) lwidth(medium)) ///
(scatter conb Z, msymbol(circle) msize(medium) mcolor(black) lpattern(solid) lwidth(medium)) (scatter top Z, msymbol(square) msize(medsmall) mcolor(gs8) lcolor(black) lpattern(dash) lwidth(thin)) ///
(scatter bottom Z, msymbol(square) msize(medsmall) mcolor(gs8) lcolor(black) lpattern(dash) lwidth(thin)), ytitle(Marginal Partisanship Effect, margin(sides)) yline(0) ///
xtitle(Union Centralization) title("Partisan Influence on ILM using Continuous Partisanship Measure", size(medsmall) position(11)) ///
legend(off) scheme(sj) graphregion(ifcolor(white)) ///
yscale(noline) xscale(noline) yline(-.03 -.02 -.01 .01 .02, lcolor(white)) xlabel(0 1 2)

graph copy gm1_scatter
*the above (gm1_scatter) is what I will finally use.

drop Z conb conse a top bottom

graph combine gm1_scatter, iscale(*1) title("Figure 3.1: Estimated marginal partisan influence on levels of ILM", ///
size(medsmall)) subtitle("Conditional on Union Centralization and using PCSE", size(medsmall)) ///
caption("Circles represent marginal influence on ILM, squares represent 95% confidence intervals", size(small) ///
position(6) box fcolor(white)) scheme(sj) 
*****************************************
*the above command generates Figure 3.1 *
*****************************************
xi: xtpcse beta_all govid2006_1_us_inv C_cent xz lnpop65 unemploy_pct_labor gdp_pc_ppp_cur_thd openness gdp_growth cpi_allitems state eu year i.ctycode if post1980~=0, het corr(ar1)
estimates store m3

***********
***II. second, use Left-Right as dummy, and Union centralization as 0, 1, 2 categorical variable
***and ILM in original levels
quietly do "conditional_prep.do"
gen xz =  D_govid *  C_cent

xi: xtpcse beta_all D_govid C_cent xz lnpop65 unemploy_pct_labor gdp_pc_ppp_cur_thd openness gdp_growth cpi_allitems state eu year i.ctycode, het corr(ar1)
estimates store m2

xi: xtpcse beta_all D_govid C_cent xz lnpop65 unemploy_pct_labor gdp_pc_ppp_cur_thd openness gdp_growth cpi_allitems state eu year i.ctycode if post1980~=0, het corr(ar1)
estimates store m4


estout m1 m2 using temp_all.txt, replace cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
stats(N N_g chi2 p r2, labels("Observations" "# of Countries" "Wald chi2" "Prob>chi2" "R-squared")) ///
varlabels (_cons Constant govid2006_1_us_inv "Gov Partisanship (continuous)" D_govid "Gov Partisanship (Dummy)" ///
C_cent "Union Centralization" xz "Partisanship*Centralization" lnpop65 "Population over 65" unemploy_pct_labor ///
"Unemployment" gdp_pc_ppp_cur_thd "GDP PPP per capita" gdp_growth "GDP Growth" openness "Openness" ///
cpi_allitems "Inflation" year "Time period" state "Federalism" eu "EU Membership" ) ///
style(tab)  ///
title("Table 3.1. Estimation of the partisan influence on levels of ILM, using OLS with PCSEs") legend starlevels(* .10 ** .05 *** .01)
****************************************
*the above command generates table 3.1 *
****************************************
estout m3 m4 using temp_all.txt, replace cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
stats(N N_g chi2 p r2, labels("Observations" "# of Countries" "Wald chi2" "Prob>chi2" "R-squared")) ///
varlabels (_cons Constant govid2006_1_us_inv "Gov Partisanship (continuous)" D_govid "Gov Partisanship (Dummy)" ///
C_cent "Union Centralization" xz "Partisanship*Centralization" lnpop65 "Population over 65" unemploy_pct_labor ///
"Unemployment" gdp_pc_ppp_cur_thd "GDP PPP per capita" gdp_growth "GDP Growth" openness "Openness" ///
cpi_allitems "Inflation" year "Time period"  state "Federalism" eu "EU Membership" ) ///
style(tab)  ///
title("Table 3.2. Estimation of the partisan influence on levels of ILM, using OLS with PCSEs") legend starlevels(* .10 ** .05 *** .01) ///
prehead( @title "For post 1980 era" )
****************************************
*the above command generates table 3.2 *
****************************************
*********
*reverse causality
run "conditional_prep.do"
gen xz= govid2006_1_us_inv * C_cent

gen beta_all_lag1 = L1.beta_all
gen C_cent_lag1 = L1.C_cent


xi: xtpcse beta_all govid2006_1_us_inv C_cent xz lnpop65 unemploy_pct_labor gdp_pc_ppp_cur_thd openness gdp_growth cpi_allitems state eu year i.ctycode, het corr(ar1)
*the original m1
xi: xtpcse govid2006_1_us_inv beta_all_lag1 C_cent lnpop65 unemploy_pct_labor gdp_pc_ppp_cur_thd openness gdp_growth cpi_allitems state eu year i.ctycode, het corr(ar1)
*reverse labor mobility to partisanship, and lag it one period
xi: xtpcse beta_all govid2006_1_us_inv C_cent xz lnpop65 unemploy_pct_labor gdp_pc_ppp_cur_thd openness gdp_growth cpi_allitems state eu year i.ctycode if post1980~=0, het corr(ar1)
*the original m3
xi: xtpcse govid2006_1_us_inv beta_all_lag1 C_cent lnpop65 unemploy_pct_labor gdp_pc_ppp_cur_thd openness gdp_growth cpi_allitems state eu year i.ctycode if post1980~=0, het corr(ar1)
*reverse labor mobility to partisanship, and lag it one period


xi: xtpcse beta_all govid2006_1_us_inv C_cent xz lnpop65 unemploy_pct_labor gdp_pc_ppp_cur_thd openness gdp_growth cpi_allitems state eu year i.ctycode, het corr(ar1)
*the original m1
xi: xtpcse C_cent beta_all_lag1 govid2006_1_us_inv lnpop65 unemploy_pct_labor gdp_pc_ppp_cur_thd openness gdp_growth cpi_allitems state eu year i.ctycode, het corr(ar1)
*reverse labor mobility to union centralization, and lag it one period
xi: xtpcse beta_all govid2006_1_us_inv C_cent xz lnpop65 unemploy_pct_labor gdp_pc_ppp_cur_thd openness gdp_growth cpi_allitems state eu year i.ctycode if post1980~=0, het corr(ar1)
*the original m3
xi: xtpcse C_cent beta_all_lag1 govid2006_1_us_inv lnpop65 unemploy_pct_labor gdp_pc_ppp_cur_thd openness gdp_growth cpi_allitems state eu year i.ctycode if post1980~=0, het corr(ar1)
*reverse labor mobility to union centralization, and lag it one period

*************************************************************************
*the above commands produce results that are used to generate table 4.1 *
*************************************************************************

*****************
*instrument variables
run "conditional_prep.do"
gen xz= govid2006_1_us_inv * C_cent
gen gov_lag1 = L1.govid2006_1_us_inv 
gen dgov_lag1= L1.D_govid
gen cent_lag1 = L1.C_cent
gen xz_lag1 = L1.xz
gen xlagz = govid2006_1_us_inv * cent_lag1

xtreg beta_all govid2006_1_us_inv C_cent xz lnpop65 unemploy_pct_labor gdp_pc_ppp_cur_thd openness gdp_growth cpi_allitems state eu year, fe
estimates store m1reg

xtivreg beta_all govid2006_1_us_inv lnpop65 unemploy_pct_labor gdp_pc_ppp_cur_thd openness gdp_growth cpi_allitems state eu year (C_cent xz =  cent_lag1 xlagz), fe
estimates store m1iv
*************************************************************************
*the above commands produce results that are used to generate table 4.3 *
*************************************************************************

