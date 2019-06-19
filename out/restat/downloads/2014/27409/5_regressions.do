*****************************
* DOES PLANNING REGULATION PROTECT INDEPENDENT RETAILERS?
* Created by Raffaella Sadun (rsadun@hbs.edu)
* Do file to replicate regressions
*****************************

*** Define macros
global w_sumstats ""
global w "[aw=sha_pop]"
global control_A "i.year m_very"
global control_A_manuf "i.year "
global control_A_gro "i.year"
global demand "ln_pop  morph_u morph_v age1 mw du_mw pct_skilled1991" 
global demand_B " ln_pop age1 mw du_mw pct_skilled1991 morph_u morph_v int_mw post_mw cen_ind_manuf cen_ind_ret ln_area1" 
global demand_fe "ln_pop  morph_u morph_v age1 mw du_mw pct_skilled1" 



*************
* TABLES 1 - 4: use file retail_posted.dta
*************

log using logfile_1.txt, t replace
**********
* Table 1 - Summary Stats
***********
u retail_posted, clear
tabstat maj_gra pct_gra_maj pop_y density, s(mean median sd)


*****
* Table 2 - Drivers of planning grants
*****
u retail_posted, replace
cap estimates drop *
foreach var in ln_pop morph_u age1 pct_skilled1991 {
eststo: reg maj_gra `var' yy*  $w_sumstats, cluster(la_co)
}
eststo: reg maj_gra  mw du_mw yy* $w_sumstats, cluster(la_co)
eststo: reg maj_gra ln_pop morph_u age1 mw du_mw pct_skilled1991 yy* $w_sumstats, cluster(la_co)
esttab  using table1.csv, replace stats(N, fmt(%9.0f %9.0g)) cells(b(star fmt(3)) /// 
	se(par fmt(3))) starlevels( * 0.10 ** 0.05 *** 0.01) keep(ln_pop morph_u age1 mw du_mw pct_skilled1991) nogap

*****
* Table 3
*****
u retail_posted, replace
cap estimates drop *
eststo:reg maj_gra d_maj_CON  yy* $w_sumstats, cluster(la_co)
eststo:reg maj_gra rel  yy* $w_sumstats , cluster(la_co)
eststo:reg maj_gra sha_seat_CON  yy* $w_sumstats , cluster(la_co)
eststo:reg maj_gra sha_seat_CON  $demand yy* $w_sumstats, cluster(la_co)
eststo:xi: reg maj_gra sha_seat_CON sha_seat_LD sha_seat_OTH $demand yy* $w_sumstats, cluster(la_co) 
eststo:xi: areg maj_gra sha_seat_CON $demand yy* $w_sumstats , cluster(la_co) abs(la_co)
eststo:xi: areg maj_gra sha_seat_CON  $demand yy* i.la_co|year $w_sumstats , cluster(la_co) abs(la_co)
esttab  using table2.csv, replace stats(N, fmt(%9.0f %9.0g)) cells(b(star fmt(3)) se(par fmt(3))) ///
	starlevels( * 0.10 ** 0.05 *** 0.01) keep (d_maj_CON rel sha_seat_CON sha_seat_LD sha_seat_OTH) nogap

cap log c
	
*************
* TABLES 4 - A2
* ALL DATA USED FOR THESE REGRESSIONS CAN BE FOUND AT THE OFFICE FOR NATIONAL STATISTICS
* MICRODATA LABORATORY IN THE FOLLOWING DIRECTORY
* "T:\LSE\Raffaella Sadun May 2013\Retail\Source data"
*****************************
cd "T:\LSE\Raffaella Sadun May 2013\Retail\Source data"
clear
clear matrix
set mem 500m
global F9 do "t:\ceriba\stata_files\copymarked.do";
global F10 do "H:\_markedF10.do";
adopath +t:\ceriba\stata_files\ado
adopath +t:\ceriba\stata_files\ado\stb\
adopath +t:\ceriba\stata_files\projects
adopath + x:\code\stat-transfer-setup\ 
adopath +X:\code\ado\xtabond
adopath +X:\code\ado\
adopath +T:\Ceriba\climatelevy\do
set more 1

************************
*** Table 4 - Summary Stats
************************

u  "chains_sept12_precollapse", replace
drop if check==2
replace t_new=0 if check==1
replace firm=0 if check==1
collapse (sum) tot_emp=emp sum_store=aa1 (p10) p_10=emp (p25) p_25=emp (median) med_emp=emp (p75) p_75=emp (p90) p_90=emp , by(firm year)
tabstat tot sum p* med, by(firm) 
* Over time
tabstat tot sum p* med if firm==0, by(year)  
tabstat tot sum p* med if firm==1, by(year)  
tabstat tot sum p* med if firm==2, by(year)  



************
* Table 5 - Store Density and Small Formats
**************

u density_regs, clear
cap estimates drop *
eststo: areg msum_chains smallstore, abs(la_co) cluster(postcode)
eststo: areg msum_indep smallstore, abs(la_co) cluster(postcode)
esttab  using T6_density_clusterpcode.csv, replace stats(N, fmt(%9.0f %9.0g)) cells(b(star fmt(4)) se(par fmt(4))) starlevels( * 0.10 ** 0.05 *** 0.01) keep(smallstore) nogap


************************
* Table 6 - Planning and Retail Employment
************************
u ret_home_pop_chains_pro_v2, replace
cap estimates drop *
* Large Retail Chains - All stores
eststo: xi: reg delta_emp_ff2  maj_gra_lag2  yy* $control_A  $demand $w, cluster(la_co) 
* Look in detail at national chains and notice asymmetry in results
* Large formats
eststo: xi: reg delta_emp_tt4  maj_gra_lag2  yy* $control_A  $demand $w, cluster(la_co) 
* Small formats
eststo: xi: reg delta_emp_tt3  maj_gra_lag2  yy* $control_A  $demand $w, cluster(la_co) 
* Independents
eststo: xi: reg delta_emp_cc1  maj_gra_lag2  yy* $control_A  $demand $w, cluster(la_co) 
* Independents as a function of small stores
eststo: xi: reg delta_emp_cc1  delta_emp_tt3  yy* $control_A  $demand $w, cluster(la_co) 
* Small Retail Chains
eststo: xi: reg delta_emp_ff1  maj_gra_lag2  yy* $control_A  $demand $w, cluster(la_co) 
* MANUFACTURING
u retail_posted, replace
keep if year>=1998
eststo: xi: reg delta_lfs_manuf  maj_gra_lag2  yy* $control_A_manuf  $demand $w, cluster(la_co) 
esttab  using T3_mainresult.csv, replace stats(N, fmt(%9.0f %9.0g)) cells(b(star fmt(4)) se(par fmt(4))) starlevels( * 0.10 ** 0.05 *** 0.01) keep(maj_gra_lag2 ln_pop delta_emp_tt3) nogap


**********
* Table 7 -  Planning Grants and Employment Growth
**********
* Small formats
u ret_home_pop_chains_pro_v2, replace
cap estimates drop *
* 1. Baseline
eststo: xi: reg delta_emp_tt3  maj_gra_lag2  yy* $control_A  $demand $w, cluster(la_co) 
* 2. OLS adding richer demand controls
eststo: xi: reg delta_emp_tt3  maj_gra_lag2  yy* $control_A  $demand_B $w, cluster(la_co) 
* 3. OLS adding la_co fixed effects to spec b
eststo: xi: areg delta_emp_tt3  maj_gra_lag2  yy* $control_A $demand  $w, cluster(la_co) abs(la_co)
* 4. IV on baseline - reduced form 
eststo: xi: reg delta_emp_tt3  sha_seat_CON_lag2  yy* $control_A  $demand $w, cluster(la_co) 
* 5. IV on baseline - First stage
eststo: xi: reg  maj_gra_lag2  sha_seat_CON_lag2 yy* $control_A $demand  $w, cluster(la_co) 
* 6. IV on baseline - Second stage 
eststo: xi: ivreg2 delta_emp_tt3 (maj_gra_lag2=sha_seat_CON_lag2) yy* $control_A $demand  $w , cluster(la_co)  
esttab  using T4_smallchains.csv, replace stats(N, fmt(%9.0f %9.0g)) cells(b(star fmt(4)) se(par fmt(4))) starlevels( * 0.10 ** 0.05 *** 0.01) keep(maj_gra_cum maj_gra_lag2 sha_seat_CON_lag2 sup  ln_pop sha_seat_CON_lag2) nogap

**** Independents
u ret_home_pop_chains_pro_v2, replace
cap estimates drop *
* 1. Baseline
eststo: xi: reg delta_emp_cc1  maj_gra_lag2  yy* $control_A  $demand $w, cluster(la_co) 
* 2. OLS adding richer demand controls
eststo: xi: reg delta_emp_cc1  maj_gra_lag2  yy* $control_A  $demand_B $w, cluster(la_co) 
* 3. OLS adding la_co fixed effects to spec b
eststo: xi: areg delta_emp_cc1  maj_gra_lag2  yy* $control_A $demand  $w, cluster(la_co) abs(la_co)
* 4. IV on baseline - reduced form 
eststo: xi: reg delta_emp_cc1  sha_seat_CON_lag2  yy* $control_A  $demand $w, cluster(la_co) 
* 5. IV on baseline - First stage
eststo: xi: reg  maj_gra_lag2  sha_seat_CON_lag2 yy* $control_A $demand  $w, cluster(la_co) 
* 6. IV on baseline - Second stage 
eststo: xi: ivreg2 delta_emp_cc1 (maj_gra_lag2=sha_seat_CON_lag2) yy* $control_A $demand  $w , cluster(la_co)  
esttab  using T4_indep.csv, replace stats(N, fmt(%9.0f %9.0g)) cells(b(star fmt(4)) se(par fmt(4))) starlevels( * 0.10 ** 0.05 *** 0.01) keep(maj_gra_cum maj_gra_lag2 sha_seat_CON_lag2 sup  ln_pop sha_seat_CON_lag2) nogap


**********************
* Table 8 - Margins of adjustments
**********************
*** Small chains (see do file Chains_rellocation_v1 for construction of the dataset)
clear matrix
clear
set mem 500m
u ret_home_pop_chains_gro_long, replace

cap estimates drop *

* This keeps the small formats belonging to large chains
keep if type==3
foreach var in entry_j_type exit_j_type exp_j_type contr_j_type {
display "Margin is `var'" 
display "IV"
eststo: xi: ivreg2 `var' (maj_gra_lag2=sha_seat_CON_lag2) yy* ln_pop $control_A_gro $demand if type==3 $w, cluster(la_co) 
}
esttab  using T5_smallchains.csv, replace stats(N, fmt(%9.0f %9.0g)) cells(b(star fmt(4)) se(par fmt(4))) starlevels( * 0.10 ** 0.05 *** 0.01) keep(maj_gra_lag2   ln_pop ) nogap


*** Independents (see do file Chains_rellocation_v1 for construction of the dataset)
clear matrix
clear
set mem 500m

u ret_home_pop_basic_entry, replace
* This keeps set of Local Authorities in main sample (those with both indep. and small chains)
so la_code year
merge 1:1 la_code year using new_la_list
keep if _m==3
drop _m
tab year , gen(yy)
cap estimates drop *

* IV
foreach var in entry_j_type exit_j_type exp_j_type contr_j_type {
display "Margin is `var'" 
display "IV"
eststo: xi: ivreg2 `var' (maj_gra_lag2=sha_seat_CON_lag2) yy* ln_pop $control_A_gro $demand  $w, cluster(la_co) 
}
esttab  using T5_indep.csv, replace stats(N, fmt(%9.0f %9.0g)) cells(b(star fmt(4)) se(par fmt(4))) starlevels( * 0.10 ** 0.05 *** 0.01) keep(maj_gra_lag2   ln_pop ) nogap


************
**** Table 9 - Robustness of IV estimates
***********
u ret_home_pop_chains_pro_v2, replace
cap estimates drop *

***********
* A. Small Formats
***********

* 1. IV on baseline - Second stage 
eststo: xi: ivreg2 delta_emp_tt3 (maj_gra_lag2=sha_seat_CON_lag2) yy* $control_A $demand  $w , cluster(la_co)  

* 2. Cumulate grants
eststo: xi: ivreg2 delta_emp_tt3 (sup=sup_sha) yy* $control_A $demand $w   , cluster(la_co)  

* 3. Levels and fixed effects instead of growth rates
u ret_home_pop_chains_pro_v2_fe, replace
ge ln_emp_tt3=ln(agg_emp_tt3)
ge ln_pop=ln(pop_y)
eststo: xi: xtivreg2 ln_emp_tt3 (maj_gra_cum=sha_seat_CON_cum) yy* $control_A $demand_fe  $w , cluster(la_co)  i(la_co) fe

* 4. IV using averages
u ret_home_pop_chains_pro_v2, replace
ge per=.
replace per=1 if year<=2000
replace per=2 if year>2000 & year<=2002
replace per=3 if year>2002 & year<=2004
collapse (max) m_very (mean)  delta_emp_tt3 maj_gra_lag2 sha_seat_CON_lag2 $demand sha_pop  , by(la_co per)
rename per year
ta year, ge(yy)
eststo: xi: ivreg2 delta_emp_tt3 (maj_gra_lag2=sha_seat_CON_lag2) yy* $control_A $demand  $w , cluster(la_co)  

* 5. Control for total emp change in the local authority level
u ret_home_pop_chains_pro_v2, replace
so la_code year
merge 1:1 la_code year using lfs_all_emp
drop if _m==2 
drop _m
gen ltot_lfs_emp=ln(tot_emp_lfs)
replace ltot_lfs_emp=-99 if ltot_lfs_emp==.
gen ltot_lfs_empm=ltot_lfs_emp==-99
cap estimates drop *
eststo: xi: ivreg2 delta_emp_tt3  (maj_gra_lag2=sha_seat_CON_lag2) ltot_lfs_emp ltot_lfs_empm yy* $control_A $demand  $w , cluster(la_co)  

** 6. Robusteness to changes in neighboring LAs
u ret_home_pop_chains_pro_v2, replace
so la_code year
merge 1:1 la_code year using reg_neighboring_las
drop if _m==2
drop _m
foreach var in n_maj_gra_lag2 w_n_maj_gra_lag2 {
replace `var'=-99 if `var'==.
gen `var'm=`var'==-99
}
eststo: xi: ivreg2 delta_emp_cc1  (maj_gra_lag2=sha_seat_CON_lag2) n_maj_gra_lag2 n_maj_gra_lag2m yy* $control_A $demand  $w , cluster(la_co)  


* 7. See if results are robust to including exit of large stores (>150 emps)
* note large stores not everywhere, so replaced with zeros if missing
u ret_home_pop_chains_pro_v2, replace
so la_code year
merge 1:1 la_code year using bigstores_ally_la 
drop if _m==2
drop _m
foreach var in n_exit n_entry n_inc {
replace `var'=0 if `var'==.
}
eststo: xi: ivreg2 delta_emp_tt3 n_exit (maj_gra_lag2=sha_seat_CON_lag2) yy* $control_A $demand  $w , cluster(la_co)  


* 8. Using national elections as IV
u ret_home_pop_chains_pro_v2, replace
so la_name year
* Note match not perfect because of timing of national elections
merge 1:1 la_name year using nationalelections_lalevel_v3_ons
so la_name year
rename _m _me
egen g=group(la_name)
tsset g year

* Generate weights to attribute election results to non election years
foreach var in 1997 2001 2005 {
gen w_`var'=4/4 if year==`var'
replace w_`var'=3/4 if year==`var'+1
replace w_`var'=2/4 if year==`var'+2
replace w_`var'=1/4 if year==`var'+3
replace w_`var'=3/4 if year==`var'-1
replace w_`var'=2/4 if year==`var'-2
replace w_`var'=1/4 if year==`var'-3
replace w_`var'=0 if w_`var'==.
}
foreach y of varlist nat_sha_vote_CON* nat_sha_vote_MIN* nat_sum_electorate nat_sha_turnout {
foreach var in 1997 2001 2005 {
gen `y'_`var' = `y' if year==`var'
bys la_name: egen m_`y'_`var'=max(`y'_`var')
}
rename `y' old_`y'
gen `y'= w_1997*m_`y'_1997+w_2001*m_`y'_2001+w_2005*m_`y'_2005
so g year
bys g: gen `y'_lag2=l2.`y'
replace `y'_lag2=(3/4)*m_`y'_1997+(1/4)*m_`y'_2001  if year==2000
drop m_`y'* 
}

foreach var of varlist  prob* count_* nat_delta {
so la_name year
bys la_name: replace `var'=`var'[_n-1] if `var'==. & `var'[_n-1]!=.
bys la_name: replace `var'=`var'[_n-1] if `var'==. & `var'[_n-1]!=.
}
global prob "prob_lamerge prob_const_reorg"
eststo: xi: ivreg2 delta_emp_tt3 (maj_gra_lag2= nat_sha_vote_CON_2_lag2 ) yy* prob_lamerge  $control_A $demand  $w , cluster(la_co)



******************
* B. Independents
******************
u ret_home_pop_chains_pro_v2, replace
cap estimates drop *
* 1. IV on baseline - Second stage 
eststo: xi: ivreg2 delta_emp_cc1 (maj_gra_lag2=sha_seat_CON_lag2) yy* $control_A $demand  $w , cluster(la_co)  

* 2. IV Adding lags (1, 2 and 3)
eststo: xi: ivreg2 delta_emp_cc1 (sup=sup_sha) yy* $control_A $demand $w   , cluster(la_co)  

* 3. Levels and fixed effects instead of growth rates
u ret_home_pop_chains_pro_v2_fe, replace
ge ln_emp_cc1=ln(emp_indep)
ge ln_pop=ln(pop_y)
eststo: xi: xtivreg2 ln_emp_cc1 (maj_gra_cum=sha_seat_CON_cum) yy* $control_A $demand_fe  $w , cluster(la_co)  i(la_co) fe

* 4. IV using averages
u ret_home_pop_chains_pro_v2, replace
ge per=.
replace per=1 if year<=2000
replace per=2 if year>2000 & year<=2002
replace per=3 if year>2002 & year<=2004
collapse (max) m_very (mean)  delta_emp_cc1 delta_emp_tt3 maj_gra_lag2 sha_seat_CON_lag2 $demand sha_pop  , by(la_co per)
rename per year
ta year, ge(yy)
eststo: xi: ivreg2 delta_emp_cc1 (maj_gra_lag2=sha_seat_CON_lag2) yy* $control_A $demand  $w , cluster(la_co)  

* 5. Control for total emp change in the local authority level
u ret_home_pop_chains_pro_v2, replace
so la_code year
merge 1:1 la_code year using lfs_all_emp
drop if _m==2 
drop _m
gen ltot_lfs_emp=ln(tot_emp_lfs)
replace ltot_lfs_emp=-99 if ltot_lfs_emp==.
gen ltot_lfs_empm=ltot_lfs_emp==-99
eststo: xi: ivreg2 delta_emp_cc1  (maj_gra_lag2=sha_seat_CON_lag2) ltot_lfs_emp ltot_lfs_empm yy* $control_A $demand  $w , cluster(la_co)  

* 6. Robusteness to changes in neighboring LAs
u ret_home_pop_chains_pro_v2, replace
so la_code year
merge 1:1 la_code year using reg_neighboring_las
drop if _m==2
drop _m
foreach var in n_maj_gra_lag2 w_n_maj_gra_lag2 {
replace `var'=-99 if `var'==.
gen `var'm=`var'==-99
}
eststo: xi: ivreg2 delta_emp_tt3  (maj_gra_lag2=sha_seat_CON_lag2) n_maj_gra_lag2 n_maj_gra_lag2m yy* $control_A $demand  $w , cluster(la_co)  

* 7. See if results are robust to including exit of large stores (>150 emps)
* note large stores not everywhere, so replaced with zeros if missing
u ret_home_pop_chains_pro_v2, replace
so la_code year
merge 1:1 la_code year using bigstores_ally_la 
drop if _m==2
drop _m
foreach var in n_exit n_entry n_inc {
replace `var'=0 if `var'==.
}
eststo: xi: ivreg2 delta_emp_cc1 n_exit (maj_gra_lag2=sha_seat_CON_lag2) yy* $control_A $demand  $w , cluster(la_co)  

* 8. Using national elections as IV
u ret_home_pop_chains_pro_v2, replace
so la_name year
* Note match not perfect because of timing of national elections
merge 1:1 la_name year using nationalelections_lalevel_v3_ons
so la_name year
rename _m _me
egen g=group(la_name)
tsset g year

* Generate weights to attribute election results to non election years
foreach var in 1997 2001 2005 {
gen w_`var'=4/4 if year==`var'
replace w_`var'=3/4 if year==`var'+1
replace w_`var'=2/4 if year==`var'+2
replace w_`var'=1/4 if year==`var'+3
replace w_`var'=3/4 if year==`var'-1
replace w_`var'=2/4 if year==`var'-2
replace w_`var'=1/4 if year==`var'-3
replace w_`var'=0 if w_`var'==.
}
foreach y of varlist nat_sha_vote_CON* nat_sha_vote_MIN* nat_sum_electorate nat_sha_turnout {
foreach var in 1997 2001 2005 {
gen `y'_`var' = `y' if year==`var'
bys la_name: egen m_`y'_`var'=max(`y'_`var')
}
rename `y' old_`y'
gen `y'= w_1997*m_`y'_1997+w_2001*m_`y'_2001+w_2005*m_`y'_2005
so g year
bys g: gen `y'_lag2=l2.`y'
replace `y'_lag2=(3/4)*m_`y'_1997+(1/4)*m_`y'_2001  if year==2000
drop m_`y'* 
}

foreach var of varlist  prob* count_* nat_delta {
so la_name year
bys la_name: replace `var'=`var'[_n-1] if `var'==. & `var'[_n-1]!=.
bys la_name: replace `var'=`var'[_n-1] if `var'==. & `var'[_n-1]!=.
}
global prob "prob_lamerge prob_const_reorg"
* Second stage for independents
eststo: xi: ivreg2 delta_emp_cc1 (maj_gra_lag2= nat_sha_vote_CON_2_lag2 ) yy* prob_lamerge  $control_A $demand  $w , cluster(la_co)

**********
* Table A1 - Additional Summary Stats
***********
u retail_posted, clear
keep if year>=1998
replace mw=. if mw==-99 
tabstat maj_gra_lag2 sha_seat_CON_ p1 age1 mw pct_skilled1991 morph_u morph_v, s(mean median sd)


***************
* Table A2 and Table A3
* Robustness check on definition of major/minor and small/large chain store
* See file Chains_alternativethresholds for data creation
****************
u ret_home_pop_chains_robustness, replace
cap estimates drop *
foreach var in 1 2 3 {
foreach y in 1 2 3 4 {
foreach g in 3 4 {
* OLS
eststo: xi: reg delta_emp_`var'`y'`g'  maj_gra_lag2  yy* $control_A  $demand $w, cluster(la_co) 
* IV
eststo: xi: ivreg2 delta_emp_`var'`y'`g'  (maj_gra_lag2=sha_seat_CON_lag2) yy* $control_A $demand  $w , cluster(la_co)  
}
}
}
esttab  using ref3_definitions.csv, replace stats(N, fmt(%9.0f %9.0g)) cells(b(star fmt(4)) se(par fmt(4))) starlevels( * 0.10 ** 0.05 *** 0.01) keep(maj_gra_lag2) nogap
