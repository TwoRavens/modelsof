
/*******************************************

This do file replicates the results in the paper (Figures 1 and 2, Tables 1, 2, 3, 4 and 5)

Note 1: The infant mortality rate, the neonatal mortality rate, the birth rate, the interest rate spread, the poverty head count ratio, and the health expenditure per capita PPP come from the World Development Indicators, World Bank. See readme file (B11). 
Note 2: The economic activity index comes from the INDEC (Instituto Nacional de Estadísticas y Censos). See below (B12). For the HP-cyclical component of the log of the economic activity index see also readme file (B12). 
Note 3: In column (1), Table 4, page 558, it is 128.88 not -128.88. We don't know why the publisher added the negative sign. This negative sign was not in the proofs we received.

Before running the do file, make sure you replace "directory_name" with the actual name of your directory:

Edit --> Find --> Replace

Find what: directory_name

Replace with: the actual name of your directory  

*******************************************/


cd "directory_name\Data_Replication_Files_RESTAT\datasets"

****Figures 1 and 2

******************
**** FIGURE 1 ****
******************

clear all

use Figure_1_data.dta, clear 

twoway (tsline  bw, recast(connected)  yaxis(1) lwidth(thin)) (tsline index, recast(connected) lpattern(dot) yaxis(2) lwidth(medium))


******************
**** FIGURE 2 ****
******************

clear all

use Figure_2_data.dta, clear 

twoway (tsline  C_C, recast(connected)  yaxis(1) yline(0) lwidth(thin)) (tsline ICC_Nacional, recast(connected) lpattern(dot) yaxis(2) tline(2001m8) lwidth(medium))


****Tables 1 to 5

clear all

set mem 4000m
set matsize 2000
set more off

use dataset_weight_crisis, clear

***Generate indicators for province, year, month, age categories, parity

gen prov=mprores if (mprores==02|mprores==06|mprores==10|mprores==14|mprores==18|mprores==22|mprores==26|mprores==30|mprores==34|mprores==38|mprores==42|mprores==46|mprores==50|mprores==54|mprores==58|mprores==62|mprores==66|mprores==70|mprores==74|mprores==78|mprores==82|mprores==86|mprores==90|mprores==94)
tab prov, gen(province)
tab year, gen(year_)
tab month, gen(month_)
tab age_cat, gen(age_cat_)
tab preg_m, gen(preg_m_)
gen heduc_partner=heduc*partner

***

log using "directory_name\Data_Replication_Files_RESTAT\results\output_Tables.log", replace

*****************
**** TABLE 1 ****
*****************

***Descriptive stats for: 

*Birth weight, Low birth weight, female (fraction), age of the mother, mother has completed high-school (fraction), total number of births, mother has a partner (fraction)
reg bw month_2-month_12  province1-province23 year_2 year_3  year_4 year_5 year_6, robust cluster(time)
preserve
keep if e(sample)
count

foreach num of numlist 0 1 2 3 4 5 {
               sum bw if year==200`num'
 }


foreach num of numlist 0 1 2 3 4 5 {
               sum LBW if year==200`num'
 }

foreach num of numlist 0 1 2 3 4 5 {
               sum female if year==200`num'
 }
foreach num of numlist 0 1 2 3 4 5 {
               sum age if year==200`num'
 }
foreach num of numlist 0 1 2 3 4 5 {
               sum heduc if year==200`num'
 }
foreach num of numlist 0 1 2 3 4 5 {
               sum preg_m if year==200`num'
 }
foreach num of numlist 0 1 2 3 4 5 {
               sum partner if year==200`num'
 }
  
***


*****************
**** TABLE 2 ****
*****************

**varlist1: Month, province and year fixed effects
**varlist2: Sex of the child (female), mother's age categories, parity categories, mother's education, mother's marital status, and the interaction of these last two variables
**varlist3: Month fixed effects

local varlist1 month_2-month_12  province1-province23 year_2-year_6
local varlist2 female age_cat_1- age_cat_6  preg_m_1- preg_m_3 heduc partner heduc_partner
local varlist3 month_2-month_12
local varlist4 female age_cat_1- age_cat_6  preg_m_1- preg_m_3 partner 

foreach var of varlist bw LBW {

	reg `var' CC_duringr `varlist1', robust cluster(time)
 
	reg `var' CC_duringr  `varlist1' `varlist2', robust cluster(time)

	reg `var' CC_duringr CC_after `varlist1' `varlist2', robust cluster(time)

	xi: reg `var' CC_duringr CC_after `varlist2' `varlist3' i.prov*i.year, robust cluster(time)
	drop _Iprov_6- _IproXyea_94_2005

	xi: reg `var' CC_duringr CC_after `varlist2' i.prov*i.year i.prov*i.month, robust cluster(time)
	drop _Iprov_6- _IproXyea_94_2005
}
*

*****************
**** TABLE 3 ****
*****************

foreach var of varlist bw LBW {

	reg `var' CC_T3r CC_T2r CC_T1r `varlist1', robust cluster(time)
 
	reg `var' CC_T3r CC_T2r CC_T1r `varlist1' `varlist2', robust cluster(time)
	
	reg `var' CC_T3r CC_T2r CC_T1r CC_after `varlist1' `varlist2', robust cluster(time)
	
	xi: reg `var' CC_T3r CC_T2r CC_T1r CC_after `varlist2' `varlist3' i.prov*i.year, robust cluster(time)
	drop _Iprov_6- _IproXyea_94_2005
	
	xi: reg `var' CC_T3r CC_T2r CC_T1r CC_after `varlist2' i.prov*i.year i.prov*i.month, robust cluster(time)
	drop _Iprov_6- _IproXyea_94_2005
}
*

*****************
**** TABLE 4 ****
*****************

foreach num of numlist 0/1 {

	reg bw CC_T3r CC_T2r CC_T1r `varlist1' if heduc==`num', robust cluster(time)
	 
	reg bw CC_T3r CC_T2r CC_T1r `varlist1' `varlist4' if heduc==`num', robust cluster(time)
	 
	reg bw CC_T3r CC_T2r CC_T1r CC_after `varlist1' `varlist4' if heduc==`num', robust cluster(time)
	
	xi: reg bw CC_T3r CC_T2r CC_T1r CC_after `varlist3' `varlist4' i.prov*i.year if heduc==`num', robust cluster(time)
	drop _Iprov_6- _IproXyea_94_2005
	 
	xi: reg bw CC_T3r CC_T2r CC_T1r CC_after `varlist4' i.prov*i.month i.prov*i.year if heduc==`num', robust cluster(time)
	drop _Iprov_6- _IproXyea_94_2005
}
*

local close

*****************
**** TABLE 5 ****
*****************

foreach num of numlist 1/12 {
	gen month_`num'_00=month_`num'*year_1
}	
foreach num of numlist 1/12 {
	gen month_`num'_01=month_`num'*year_2
}	
foreach num of numlist 1/12 {
	gen month_`num'_02=month_`num'*year_3
}	
foreach num of numlist 1/12 {
	gen month_`num'_03=month_`num'*year_4
}	

foreach num of numlist 1/12 {
	gen month_`num'_04=month_`num'*year_5
}	

foreach num of numlist 1/12 {
	gen month_`num'_05=month_`num'*year_6
}	

reg bw month_1-month_12  month_1_00-month_12_00 month_1_02- month_12_05  province1- province24 female age_cat_1- age_cat_6  preg_m_1- preg_m_3 heduc partner heduc_partner if gestl>=38 & gestl<=40, noconstant robust cluster(time)
lincom (month_1+ month_2+ month_3+ month_4+ month_5+ month_6+ month_7+ month_8+ month_9+ month_10+ month_11+ month_12)/12

foreach num of numlist 0 2 3 4 5 {
               lincom (month_1_0`num'+ month_2_0`num'+ month_3_0`num'+ month_4_0`num'+ month_5_0`num'+ month_6_0`num'+ month_7_0`num'+ month_8_0`num' + month_9_0`num'+ month_10_0`num'+ month_11_0`num'+ month_12_0`num')/12
 }
************************************
************************************
************************************
log close
