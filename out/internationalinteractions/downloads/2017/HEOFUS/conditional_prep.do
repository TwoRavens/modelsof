***this do file use all years (1960 - 1999), OECD countries, and average values for each election cycle.

use "conditional_allctys.dta", clear

*now I add US data of government partisanship according to riteleft variable
gen riteleft_nml =51.440849 - riteleft
*54.81613-3.375281=51.440849
gen govid2006_1_us = govid2006_1
replace govid2006_1_us = riteleft_nml if wbcode=="USA"

gen govid2006_1_inv = 100 - govid2006_1
gen govid2006_1_us_inv = 100 - govid2006_1_us

sort ctycode year

/*
I will create a variable before and after 1980, to see if there are systematic difference between the two periods.
***
*/

gen post1980 = .
replace post1980 = 0 if year <=1980
replace post1980 = 1 if year > 1980

gen govid = govid2006_1_inv
by ctycode: replace govid = govid[_n-1] if govid==.
replace govid=. if year >1999

gen govid_us = govid2006_1_us_inv
by ctycode: replace govid_us = govid_us[_n-1] if govid_us==.
replace govid_us=. if year >1999

move govid2006_1_us_inv barglev2
move govid_us barglev2

***************************************
gen gid_group = year-1959
replace gid_group = . if govid2006_1_us_inv ==.
by ctycode: replace gid_group = gid_group[_n-1] if gid_group ==. 
replace gid_group = . if year>1999
drop if year>1999
keep if oecd==1

*generate categorical variable of union centralization
gen C_cent = .
replace C_cent =0 if (barglev2==1 | barglev2==2)
replace C_cent =1 if barglev2==3
replace C_cent =2 if (barglev2==4 | barglev2==5)

gen C_kenw = .
replace C_kenw =0 if (kenwcoor==1 | kenwcoor==2)
replace C_kenw =1 if kenwcoor==3
replace C_kenw =2 if (kenwcoor==4 | kenwcoor==5)

gen D_cent =.
replace D_cent =0 if (barglev2==1 | barglev2==2)
replace D_cent =1 if (barglev2==4 | barglev2==5)

gen D_kenw =.
replace D_kenw =0 if (kenwcoor==1 | kenwcoor==2 | kenwcoor==3)
replace D_kenw =1 if (kenwcoor==4 | kenwcoor==5)

gen D_cent_m=0
replace D_cent_m = 1 if barglev2==3
replace D_cent_m = . if barglev2==.

gen D_cent_h=0
replace D_cent_h = 1 if (barglev2==4 | barglev2==5)
replace D_cent_h = . if barglev2==.

gen D_kenw_m=0
replace D_kenw_m = 1 if kenwcoor==3
replace D_kenw_m = . if kenwcoor==.

gen D_kenw_h=0
replace D_kenw_h = 1 if (kenwcoor==4 | kenwcoor==5)
replace D_kenw_h = . if kenwcoor==.

gen D_govid = .
replace D_govid = 0 if govid2006_1_us_inv <=44.72609
replace D_govid = 1 if govid2006_1_us_inv >44.72609 & govid2006_1_us_inv~=.

*sum govid2006_1_us_inv
*I got mean = 44.72609
gen govid_mean_centered = govid2006_1_us_inv - 44.72609
*sum barglev2
*I got mean = 3.2304
gen barglev2_mean_centered = barglev2 - 3.2304

sort ctycode year
gen beta_all_temp = beta_all
replace beta_all_temp = 0 if beta_all_temp==.
by ctycode: gen temp = beta_all_temp[_n-1] +beta_all_temp[_n-2] +beta_all_temp[_n-3] +beta_all_temp[_n-4] +beta_all_temp[_n-5] +beta_all_temp[_n-6] + beta_all_temp[_n-7] +beta_all_temp[_n-8] +beta_all_temp[_n-9] +beta_all_temp[_n-10]
gen temp01 = 1 if beta_all_temp[_n-1]~=0 & year>=1970
gen temp02 = 1 if beta_all_temp[_n-2]~=0 & year>=1970
gen temp03 = 1 if beta_all_temp[_n-3]~=0 & year>=1970
gen temp04 = 1 if beta_all_temp[_n-4]~=0 & year>=1970
gen temp05 = 1 if beta_all_temp[_n-5]~=0 & year>=1970
gen temp06 = 1 if beta_all_temp[_n-6]~=0 & year>=1970
gen temp07 = 1 if beta_all_temp[_n-7]~=0 & year>=1970
gen temp08 = 1 if beta_all_temp[_n-8]~=0 & year>=1970
gen temp09 = 1 if beta_all_temp[_n-9]~=0 & year>=1970
gen temp10 = 1 if beta_all_temp[_n-10]~=0 & year>=1970
egen float temp01_10 = rsum(temp01 temp02 temp03 temp04 temp05 temp06 temp07 temp08 temp09 temp10)
gen beta_all_past10 = 10* (temp/temp01_10)
drop beta_all_temp temp*


gen wagecov_temp = wagecov
replace wagecov_temp = 0 if wagecov_temp==.
by ctycode: gen temp = wagecov_temp[_n-1] +wagecov_temp[_n-2] +wagecov_temp[_n-3] +wagecov_temp[_n-4] +wagecov_temp[_n-5] +wagecov_temp[_n-6] + wagecov_temp[_n-7] +wagecov_temp[_n-8] +wagecov_temp[_n-9] +wagecov_temp[_n-10]
gen temp01 = 1 if wagecov_temp[_n-1]~=0 & year>=1970
gen temp02 = 1 if wagecov_temp[_n-2]~=0 & year>=1970
gen temp03 = 1 if wagecov_temp[_n-3]~=0 & year>=1970
gen temp04 = 1 if wagecov_temp[_n-4]~=0 & year>=1970
gen temp05 = 1 if wagecov_temp[_n-5]~=0 & year>=1970
gen temp06 = 1 if wagecov_temp[_n-6]~=0 & year>=1970
gen temp07 = 1 if wagecov_temp[_n-7]~=0 & year>=1970
gen temp08 = 1 if wagecov_temp[_n-8]~=0 & year>=1970
gen temp09 = 1 if wagecov_temp[_n-9]~=0 & year>=1970
gen temp10 = 1 if wagecov_temp[_n-10]~=0 & year>=1970
egen float temp01_10 = rsum(temp01 temp02 temp03 temp04 temp05 temp06 temp07 temp08 temp09 temp10)
gen wagecov_past10 = 10* (temp/temp01_10)
drop wagecov_temp temp*

sort ctycode year
by ctycode, sort: egen beta_min = min(beta_all)
by ctycode, sort: egen beta_max = max(beta_all)
by ctycode, sort: gen beta_std = (beta_all - beta_min)/ (beta_max - beta_min)
drop beta_min beta_max

gen wagecov_inv = (-1) * wagecov
by ctycode, sort: egen wagecov_inv_min = min(wagecov_inv)
by ctycode, sort: egen wagecov_inv_max = max(wagecov_inv)
by ctycode, sort: gen wagecov_inv_std = (wagecov_inv- wagecov_inv_min)/ (wagecov_inv_max - wagecov_inv_min)
drop wagecov_inv_min wagecov_inv_max

collapse (mean) ctycode beta_std wagecov_inv_std govid2006_1_us_inv govid2006_1_inv avgannhr_pc restrictions necongovtzs gctaxgsrvrvzs openc openk govexp_nomil lcr govid_mean_centered beta_all_past10 wagecov_past10 barglev2_mean_centered D_cent D_kenw D_cent_m D_cent_h D_kenw_m D_kenw_h D_govid barglev2 C_cent C_kenw kenwcoor barglev1 eta_l_median eta_l_v2_median beta_all beta_2sls beta_2sls_v2 irpct wagecov unemploy_pct_labor gdp_growth fh_pr democracy trade_union_density_edt lnpop65 gdp_pc_ppp_cur_thd openness cpi_allitems post1980 state eu, by(wbcode gid_group)
*generate categorical variable of union centralization
gen C_cent2 = .
replace C_cent2 =0 if (barglev2>=1 & barglev2<2.5)
replace C_cent2 =1 if (barglev2>=2.5 & barglev2<3.5)
replace C_cent2 =2 if (barglev2>=3.5 & barglev2<=5)

sort ctycode gid_group
by ctycode, sort : egen float year = rank(gid_group)
sort ctycode year
move year ctycode
drop if year==.

gen C_cent_orginal = C_cent
replace C_cent=2 if C_cent>=1.5 & C_cent~=.
replace C_cent=1 if C_cent< 1.5 & C_cent>=0.5
replace C_cent=0 if C_cent< 0.5 & C_cent~=.
