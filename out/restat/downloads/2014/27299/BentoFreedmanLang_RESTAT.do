
*********************************************************************
* Program: BentoFreedmanLang_RESTAT.do
* Authors: Bento, Freedman & Lang
* Date: September 1, 2014
* Description: Calculates statistics and runs regressions for figures and tables in 
*    "Who Benefits from Environmental Regulation? Evidence from the Clean Air Act Amendments" (RESTAT)
* Inputs: BentoFreedmanLang_RESTAT_main.dta, BentoFreedmanLang_RESTAT_6B.dta, 
*    BentoFreedmanLang_RESTAT_FIG2_3.dta (all must be in same directory)
*********************************************************************

version 10
capture log close 
log using BentoFreedmanLang_RESTAT_log.txt, text replace

set more off
clear
clear matrix
set mem 15000m

set scheme s1color
graph set window fontface Times


*** TABLE 1 ***

use BentoFreedmanLang_RESTAT_main.dta, clear
keep if  ring==1

postutil clear
postfile post_tt str25 variable mean_aa mean_na mean_nn aa_na aa_nn na_nn using post_table1.dta, replace
foreach var in pol_90 pol_dif median_house_value_90 median_house_value_dif median_rent_90  ///
	median_rent_dif median_family_income_90 median_family_income_dif ///
	share_white_90 share_white_dif share_same_house_90 share_same_house_dif ///
	share_unemployed_90 share_unemployed_dif pop_dense_90 pop_dense_dif ///
	total_housing_units_90 total_housing_units_dif share_occ_own_90 share_occ_own_dif ///
	share_10yrs_less90 share_10yrs_lessdif share_3m_beds_90 share_3m_beds_dif  {
	ttest `var', by(group1) unequal
		local n1 = r(N_1)
		local n2 = r(N_2)
		local m1 = r(mu_1)
		local m2 = r(mu_2)
		local tt12 = r(p)
	ttest `var', by(group2) unequal
		local n3 = r(N_2)
		local m3 = r(mu_2)
		local tt13 = r(p)
	ttest `var', by(group3) unequal
		local tt23 = r(p)
	post post_tt ("`var'") (`m1') (`m2') (`m3') (`tt12') (`tt13') (`tt23') 
}
post post_tt ("N") (`n1') (`n2') (`n3') (.) (.) (.)
postclose post_tt 
use post_table1.dta, clear
/*
mean_aa = mean of areas with county in-attainment and monitor in-attainment
mean_na = mean of areas with county out-of-attainment and monitor in-attainment
mean_nn = mean of areas with monitor out-of-attainment
aa_na = p-value for t-test of differences of means between areas with 
	county in-attainment and monitor in-attainment and areas with 
	county out-of-attainment and monitor in-attainment
aa_nn = p-value for t-test of differences of means between areas with 
	county in-attainment and monitor in-attainment and areas with 
	monitor out-of-attainment
na_nn = p-value for t-test of differences of means between areas with 
	county out-of-attainment and monitor in-attainment and areas with 
	monitor out-of-attainment
*/


*** TABLE 2 ***

use BentoFreedmanLang_RESTAT_main.dta, clear
keep if  ring==1

global controls ///
	total_housing_units_dif share_units_occupied_dif share_occ_own_dif ///
	share_black_dif share_latino_dif share_kids_dif share_over_65_dif ///
	share_foreign_born_dif share_female_hhhead_dif share_same_house_dif ///
	share_unemployed_dif share_manuf_empl_dif share_poor_dif ///
	share_public_assistance_dif ln_med_fam_income_dif share_edu_less_hs_dif ///
	share_edu_16plus_dif share_heat_coal_dif share_heat_wood_dif share_kitchen_none_dif ///
	share_plumbing_full_dif pop_dense_dif share_bdrm2_own_dif share_bdrm3_own_dif ///
	share_bdrm4_own_dif share_bdrm5_own_dif share_single_unit_d_own_dif ///
	share_single_unit_a_own_dif share_mobile_home_own_dif share_blt_5_10_own_dif ///
	share_blt_10_20_own_dif share_blt_20_30_own_dif share_blt_30_40_own_dif ///
	share_blt_40_50_own_dif share_blt_50plus_own_dif ///
	share_bdrm2_rnt_dif share_bdrm3_rnt_dif ///
	share_bdrm4_rnt_dif share_bdrm5_rnt_dif share_single_unit_d_rnt_dif ///
	share_single_unit_a_rnt_dif share_mobile_home_rnt_dif share_blt_5_10_rnt_dif ///
	share_blt_10_20_rnt_dif share_blt_20_30_rnt_dif share_blt_30_40_rnt_dif ///
	share_blt_40_50_rnt_dif share_blt_50plus_rnt_dif ///
	factor

regress pol_dif mntr_instr $controls, vce(cluster fips2)

regress pol_dif cnty_instr mntr_instr $controls, vce(cluster fips2)




*** TABLE 3 ***

use BentoFreedmanLang_RESTAT_main.dta, clear

foreach num in 1 3 5 10 20 {

display "*** RING = " `num'

	regress ln_median_house_value_dif mntr_instr $controls if ring==`num', vce(cluster fips2)

	regress ln_median_house_value_dif cnty_instr mntr_instr $controls if ring==`num', vce(cluster fips2)

	ivregress 2sls ln_median_house_value_dif $controls ///
		(pol_dif = mntr_instr) if ring==`num', vce(cluster fips2)

	ivregress 2sls ln_median_house_value_dif $controls ///
		(pol_dif =cnty_instr mntr_instr) if ring==`num', vce(cluster fips2)
}




*** TABLE 4 ***

use BentoFreedmanLang_RESTAT_main.dta, clear

foreach num in 1 3 5 10 20 {

	display "*** RING = " `num'

	regress ln_med_rent_dif mntr_instr $controls if ring==`num', vce(cluster fips2)

	regress ln_med_rent_dif cnty_instr mntr_instr $controls if ring==`num', vce(cluster fips2)

	ivregress 2sls ln_med_rent_dif $controls ///
		(pol_dif = mntr_instr) if ring==`num', vce(cluster fips2)

	ivregress 2sls ln_med_rent_dif $controls ///
		(pol_dif =cnty_instr mntr_instr) if ring==`num', vce(cluster fips2)
}



*** TABLE 5 ***

*** PANEL A ***


use BentoFreedmanLang_RESTAT_main.dta, clear

foreach num in 1 3 5 10 20 {

	display "*** RING = " `num'

	ivregress 2sls ln_median_house_value_dif $controls ///
		share_black_dif_80 pop_dif_80 total_housing_units_dif_80 ln_avg_fam_income_dif_80 ///
		(pol_dif =cnty_instr mntr_instr) if ring==`num', vce(cluster fips2)
}



*** PANEL B ***

use BentoFreedmanLang_RESTAT_5B.dta, clear

foreach num in 1 3 5 10 20 {

	display "*** RING = " `num'

	ivregress 2sls ln_median_house_value_dif $controls ///
		(pol_dif =cnty_instr mntr_instr) if ring==`num', vce(cluster fips2)
}



*** PANEL C ***

use BentoFreedmanLang_RESTAT_main.dta, clear

foreach num in 1 3 5 10 20 {

	display "*** RING = " `num'

	ivregress 2sls ln_median_house_value_dif $controls ///
		(pol_dif =mntr_cont_instr_91) if ring==`num', vce(cluster fips2)
}




*** TABLE 6 ***
   
global controls2 ///
	share_units_occupied_dif share_black_dif share_latino_dif share_kids_dif ///
	share_over_65_dif share_foreign_born_dif share_female_hhhead_dif  ///
	share_unemployed_dif share_manuf_empl_dif share_poor_dif ///
	share_public_assistance_dif ln_med_fam_income_dif share_edu_less_hs_dif ///
	share_edu_16plus_dif share_heat_coal_dif share_heat_wood_dif share_kitchen_none_dif ///
	share_plumbing_full_dif share_bdrm2_own_dif share_bdrm3_own_dif ///
	share_bdrm4_own_dif share_bdrm5_own_dif share_single_unit_d_own_dif ///
	share_single_unit_a_own_dif share_mobile_home_own_dif share_blt_5_10_own_dif ///
	share_blt_10_20_own_dif share_blt_20_30_own_dif share_blt_30_40_own_dif ///
	share_blt_40_50_own_dif share_blt_50plus_own_dif ///
	share_bdrm2_rnt_dif share_bdrm3_rnt_dif ///
	share_bdrm4_rnt_dif share_bdrm5_rnt_dif share_single_unit_d_rnt_dif ///
	share_single_unit_a_rnt_dif share_mobile_home_rnt_dif share_blt_5_10_rnt_dif ///
	share_blt_10_20_rnt_dif share_blt_20_30_rnt_dif share_blt_30_40_rnt_dif ///
	share_blt_40_50_rnt_dif share_blt_50plus_rnt_dif 


foreach num in 1 3 5 10 20 {
	use BentoFreedmanLang_RESTAT_main.dta, clear
	keep if ring == `num'
	display "*** RING = " `num'
	
	ivregress 2sls share_same_house_dif $controls2 ///
		pop_dense_dif total_housing_units_dif share_occ_own_dif ///
		(pol_dif =cnty_instr mntr_instr), vce(cluster fips2)

	ivregress 2sls pop_dense_dif $controls2 ///
		share_same_house_dif total_housing_units_dif share_occ_own_dif ///
		(pol_dif =cnty_instr mntr_instr), vce(cluster fips2)

	ivregress 2sls total_housing_units_dif $controls2 ///
		share_same_house_dif pop_dense_dif share_occ_own_dif ///
		(pol_dif =cnty_instr mntr_instr), vce(cluster fips2)

	ivregress 2sls share_occ_own_dif $controls2 ///
		share_same_house_dif pop_dense_dif total_housing_units_dif  ///
		(pol_dif =cnty_instr mntr_instr), vce(cluster fips2)
}




*** TABLE 7 ***

use BentoFreedmanLang_RESTAT_main.dta, clear

regress pol_dif cnty_instr mntr_instr $controls if ring==1, vce(cluster fips2)
local iv_cnty = _b[cnty_instr]
local iv_mntr = _b[mntr_instr]
	
ivregress 2sls ln_median_house_value_dif $controls ///
	(pol_dif =cnty_instr mntr_instr) if ring==1, vce(cluster fips2)

gen total_capitalization = _b[pol_dif]*(mntr_instr*`iv_mntr' + cnty_instr*`iv_cnty') if ring==1
gen mwtp = _b[pol_dif]*-1*median_house_value_90/11.386329 if ring==1
gen appreciation = median_house_value_90*total_capitalization if ring==1
*gen prop_mwtp = mwtp/median_family_income_90 if ring==1
gen prop_wtp = appreciation/median_family_income_90/11.386329 if ring==1


foreach num in 3 5 10 20  {

	regress pol_dif cnty_instr mntr_instr $controls if ring==`num', vce(cluster fips2)
	local iv_cnty = _b[cnty_instr]
	local iv_mntr = _b[mntr_instr]
	
	ivregress 2sls ln_median_house_value_dif $controls ///
		(pol_dif =cnty_instr mntr_instr) if ring==`num', vce(cluster fips2)

	replace total_capitalization = _b[pol_dif]*(mntr_instr*`iv_mntr' + cnty_instr*`iv_cnty') if ring==`num'
	replace mwtp = _b[pol_dif]*-1*median_house_value_90/11.386329 if ring==`num'
	replace appreciation = median_house_value_90*total_capitalization if ring==`num'
	*replace prop_mwtp = mwtp/median_family_income_90 if ring==`num'
	replace prop_wtp = appreciation/median_family_income_90/11.386329 if ring==`num'
}

keep if cnty_instr>0 | mntr_instr>0
gen double tot_value = owner_occupied_units_90*median_house_value_90/1000000
gen double total_appreciation = tot_value*total_capitalization
gen double num_units = owner_occupied_units_90/1000

foreach var in appreciation mwtp prop_wtp total_appreciation {
	replace `var' = 0 if `var'<0
}

collapse (mean) income=median_family_income_90 house=median_house_value_90 ///
	appreciation_per_house=appreciation mwtp prop_wtp (sum) num_units tot_value total_appreciation , by(ring)
order ring house income num_units tot_value mwtp appreciation_per_house ///
	total_appreciation prop_wtp 





*** FIGURE 1 ***

use BentoFreedmanLang_RESTAT_FIG1.dta, clear

twoway (connected pm year if cnty_instr==0 & mntr_instr==0, ///
	mcolor(black) msymbol(circle) lcolor(black) xscale(range(1989.7, 2000.3))) ///
	(connected pm year if cnty_instr==1 & mntr_instr==0, sort mcolor(black) msymbol(square) lcolor(black)) ///
	(connected pm year if cnty_instr==1 & mntr_instr==1, sort mcolor(black) msymbol(triangle) lcolor(black)), ///
	ytitle(PM10 concentration) xtitle(Year) legend(label(1 "County In-Attainment, Monitor In-Attainment") ///
	label(2 "County Non-Attainment, Monitor In-Attainment") label(3 "Monitor Non-Attainment") order(1 2 3) rows(3)) ///
	saving(Figure1.gph, replace)


*** FIGURE 2 ***

use BentoFreedmanLang_RESTAT_FIG2_3.dta, clear

twoway (lpoly house_90 dist if dist<20, bwidth(.5) clcolor(black) clwidth(.5) title("a) Median House Value") ///
	ylabel(,format(%7.0fc) angle(0)) ytitle(Dollars (000s)) xtitle(Miles) legend( off)), saving(house, replace)

twoway (lpoly income_90 dist if dist<20, bwidth(.5) clcolor(black) clwidth(.5) title("d) Median Family Income") ///
	ylabel(,format(%7.0fc) angle(0)) ytitle(Dollars (000s)) xtitle(Miles) legend( off)), saving(income, replace)

twoway (lpoly dense_90 dist if dist<20, bwidth(.5) clcolor(black) clwidth(.5) title("e) Population Density") ///
	ylabel(,format(%7.0fc) angle(0)) ytitle(People/sq. mile (000s)) xtitle(Miles) legend( off)), saving(dense, replace)

twoway (lpoly share_edu_16plus_90 dist if dist<20, bwidth(.5) clcolor(black) clwidth(.5) title("f) Share College Grad") ///
	ylabel(,format(%7.2fc) angle(0)) ytitle(Share) xtitle(Miles) legend( off)), saving(educ, replace)

twoway (lpoly share_white_90 dist if dist<20, bwidth(.5) clcolor(black) clwidth(.5) title("g) Share White") ///
	ylabel(,format(%7.2fc) angle(0)) ytitle(Share) xtitle(Miles) legend( off)), saving(white, replace)

twoway (lpoly unemploy_90 dist if dist<20, bwidth(.5) clcolor(black) clwidth(.5) title("h) Unemployment Rate") ///
	ylabel(,format(%7.0fc) angle(0)) ytitle(Percent) xtitle(Miles) legend( off)), saving(unemploy, replace)

twoway (lpoly median_rent_90 dist if dist<20, bwidth(.5) clcolor(black) clwidth(.5) title("b) Median Rent") ///
	ylabel(,format(%7.0fc) angle(0)) ytitle(Dollars) xtitle(Miles) legend( off)), saving(rent, replace)

twoway (lpoly share_occ_own_90 dist if dist<20, bwidth(.5) clcolor(black) clwidth(.5) title("c) Share Owner Occupied") ///
	ylabel(,format(%7.2fc) angle(0)) ytitle(Share) xtitle(Miles) legend( off)), saving(own, replace)

graph combine "house" "rent" "own" "income" "dense" "educ" "white" "unemploy" , rows(2) iscale(.5) saving(Figure2.gph, replace)
foreach g in "house" "rent" "own" "income" "dense" "educ" "white" "unemploy" {
	erase `g'.gph
}


*** FIGURE 3 ***

use BentoFreedmanLang_RESTAT_FIG2_3.dta, clear

twoway (lpoly prop_wtp income_90, ///
	legend(label(1 "Proportional WTP")) lcolor(black)  bwidth(15) yaxis(1) ytitle("Proportional WTP (percent)") xtitle("1990 Median Income (000s)")) ///
	(kdensity income_90, ///
	legend(label(2 "Median Income")) lcolor(black) lpattern(dash) yaxis(2) ytitle("Density of 1990 Median Income", axis(2))), ///
	saving(Figure3.gph, replace)


erase post_table1.dta
clear

log close
