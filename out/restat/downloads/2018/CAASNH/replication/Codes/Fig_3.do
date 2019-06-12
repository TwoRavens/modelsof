*--------------------------------------------*
*- Decomposition in terms of productivities -*
*--------------------------------------------*

clear 

* 1a. Keep only model variables and underlying variables used to construct them

use "$datadir/Data/output/master.dta", clear
keep if year == 2011

keep ctyc year ///
	 pl_gdp pl_gdp_US pl_gdp_PWT_relus /// price level data
	 gdp_const gdp_const_US gdp_const_logdifUS /// constant gdppc data
	 beta_ky cap_pc cap_pc_US /// capital/labor ratio beta, capital per capita data
	 beta_gdp gdp_curr gdp_curr_US /// gdp per capita beta, current gdppc data
	 RER_model RER_model_ky RER_model_gdp ///
	 omega_N alpha_T alpha_N theta_T theta_N sigma_TN sigma_NT  alpha_total  gdp_ppp_logdifUS pn_relUS
	 
* 1b. Compute median parameters 

foreach var in omega_N alpha_T alpha_N alpha_total theta_T theta_N sigma_TN sigma_NT {
	egen `var'_med=median(`var')
	}
	
gen theta_bar_N = theta_N + sigma_TN*(1 - theta_N) + sigma_NT*(1 - theta_T)
gen theta_bar_N_med = theta_N_med + sigma_TN_med*(1 - theta_N_med) + sigma_NT_med*(1 - theta_T_med)
gen theta_bar=theta_bar_N_med*theta_T_med+sigma_NT_med*(1-theta_T_med)*(theta_N_med-theta_T_med)

gen beta_ky_med = (omega_N_med*alpha_total_med*(theta_T_med - theta_N_med))/(theta_bar_N_med)
gen beta_gdp_med = (omega_N_med*(theta_N_med - theta_T_med))/(theta_bar_N_med)

*Simplified model with median values

gen RER_model_med = beta_ky_med*(log(cap_pc) - log(cap_pc_US)) + beta_gdp_med*(log(gdp_curr) - log(gdp_curr_US))
gen RER_model_ky_med = beta_ky_med*(log(cap_pc) - log(cap_pc_US))
gen RER_model_gdp_med = beta_gdp_med*(log(gdp_curr) - log(gdp_curr_US))
gen RER_model_resid_med = pl_gdp_PWT_relus - RER_model_med

gen RER_model_resid = pl_gdp_PWT_relus - RER_model

gen gdp_logdifUS=(log(gdp_curr) - log(gdp_curr_US))
gen k_logdifUS=log(cap_pc) - log(cap_pc_US)

*--------------------------------------------*
* 2.  Figure 3
*--------------------------------------------*

gen tfp_rel=gdp_logdifUS-alpha_total_med*k_logdifUS					/* TFP, from GDP and capital data */

* 4a. Estimating zT in the model with at+0
gen D_z_c1_mod=tfp_rel*(theta_bar/theta_bar_N_med)					/* z_1 TFP, from GDP and capital data */

* 4b. Estimating aT and zT in the model
gen D_at_c2=theta_bar_N_med/omega_N_med*pl_gdp_PWT_relus-(theta_N_med-theta_T_med)*tfp_rel						/* Solving from rer_full */
gen D_z_c2=theta_bar/theta_bar_N_med*tfp_rel-(theta_N_med+sigma_TN_med*(1-theta_N_med))/theta_bar_N_med*D_at_c2	/* Solving from PTl */

* 4c. Decompositions

gen dec_tfp=omega_N_med/theta_bar*(theta_N_med-theta_T_med)*D_z_c1_mod
gen dec_aT=omega_N_med/theta_bar_N_med*D_at_c2						/* Term on AT */
gen dec_int=omega_N_med/theta_bar_N_med*(theta_N_med+sigma_TN_med*(1-theta_N_med))*(theta_N_med-theta_T_med)/theta_bar*D_at_c2 /* Interaction term on AT */

gen dec_z=omega_N_med*(theta_N_med-theta_T_med)/theta_bar*D_z_c2    /* Term on ZT */	
gen dec_2=dec_z+dec_int			/* ZT + Interaction */	

* 4d. Checking formulas

gen tfp_check1=theta_bar_N_med/theta_bar*D_z_c2+(theta_N_med+sigma_TN_med*(1-theta_N_med))/theta_bar*D_at_c2
gen rer_check2=dec_aT+dec_z+dec_int
assert (abs(tfp_rel/tfp_check1-1)<0.001	& 	abs(pl_gdp_PWT_relus/rer_check2-1)<0.01) | ctyc=="USA"

* 4e. Figure: Estimating zT in the model with at+0

reg pl_gdp_PWT_relus gdp_logdifUS
mat b = e(b)
mat V = e(V)
global c1 = round(b[1,1],0.01)
global se1 = round(sqrt(V[1,1]),0.01)

reg dec_z gdp_logdifUS
mat b = e(b)
mat V = e(V)
global c2 = round(b[1,1],0.01)
global se2 = round(sqrt(V[1,1]),0.01)

reg dec_int gdp_logdifUS
mat b = e(b)
mat V = e(V)
global c3 = round(b[1,1],0.01)
global se3 = round(sqrt(V[1,1]),0.01)

reg dec_2 gdp_logdifUS
mat b = e(b)
mat V = e(V)
global c4 = round(b[1,1],0.01)
global se4 = round(sqrt(V[1,1]),0.01)

labelclean

two (scatter pl_gdp_PWT_relus gdp_logdifUS, sort msymbol(oh) mcolor(red)) (lfit pl_gdp_PWT_relus gdp_logdifUS, lcolor(red)) ///
(scatter dec_z gdp_logdifUS, sort msymbol(x) mcolor(blue)) (lfit dec_z gdp_logdifUS, lcolor(blue)) ///
(scatter dec_int gdp_logdifUS, sort msymbol(triangle_hollow) mcolor(brown)) (lfit dec_int gdp_logdifUS, lcolor(brown)) ///
(scatter dec_2 gdp_logdifUS, sort msymbol(sh) mcolor(purple)) (lfit dec_2 gdp_logdifUS, lcolor(purple)), ///
ytitle("Price level of GDP relative to the US (log)") xtitle("GDP per capita relative to the US (log)") graphregion(fcolor(white) lcolor(white)) xlabel(-5(1)1) ///
legend(order(1 "RER data:  $c1 ($se1)" 3 "Exercise 1: Aggregate  $c2 ($se2)" 5 "Exercise 1: Interaction  $c3 ($se3)"  7 "Exercise 2 = Aggregate+Interaction:  $c4 ($se4)") rows(4) size(medsmall) bplace(nw) ring(0)) 
graph export "$datadir/Figures/FIG3.pdf", replace
graph close

