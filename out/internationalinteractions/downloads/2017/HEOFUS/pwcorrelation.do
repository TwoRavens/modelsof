*****************************************************************************
*the following commands produce results that are used to generate table 4.2 *
*****************************************************************************
*pair-wise correlation by administration
run "conditional_prep.do"
pwcorr C_cent govid2006_1_us_inv beta_all, sig obs

*pair-wise correlation by different years
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

***10 year average
by ctycode: gen temp10= ccent_temp +ccent_temp[_n-1] +ccent_temp[_n-2] +ccent_temp[_n-3] +ccent_temp[_n-4] +ccent_temp[_n-5] +ccent_temp[_n-6] +ccent_temp[_n-7] +ccent_temp[_n-8] +ccent_temp[_n-9]
by ctycode: gen temp9 = ccent_temp +ccent_temp[_n-1] +ccent_temp[_n-2] +ccent_temp[_n-3] +ccent_temp[_n-4] +ccent_temp[_n-5] +ccent_temp[_n-6] +ccent_temp[_n-7] +ccent_temp[_n-8]
by ctycode: gen temp8 = ccent_temp +ccent_temp[_n-1] +ccent_temp[_n-2] +ccent_temp[_n-3] +ccent_temp[_n-4] +ccent_temp[_n-5] +ccent_temp[_n-6] +ccent_temp[_n-7]
by ctycode: gen temp7 = ccent_temp +ccent_temp[_n-1] +ccent_temp[_n-2] +ccent_temp[_n-3] +ccent_temp[_n-4] +ccent_temp[_n-5] +ccent_temp[_n-6]
by ctycode: gen temp6 = ccent_temp +ccent_temp[_n-1] +ccent_temp[_n-2] +ccent_temp[_n-3] +ccent_temp[_n-4] +ccent_temp[_n-5]
by ctycode: gen temp5 = ccent_temp +ccent_temp[_n-1] +ccent_temp[_n-2] +ccent_temp[_n-3] +ccent_temp[_n-4]
by ctycode: gen temp4 = ccent_temp +ccent_temp[_n-1] +ccent_temp[_n-2] +ccent_temp[_n-3]
by ctycode: gen temp3 = ccent_temp +ccent_temp[_n-1] +ccent_temp[_n-2]
by ctycode: gen temp2 = ccent_temp +ccent_temp[_n-1]
by ctycode: gen temp1 = ccent_temp
gen ccent_10yr_avg = temp10/10
gen ccent_9yr_avg = temp9/9
gen ccent_8yr_avg = temp8/8
gen ccent_7yr_avg = temp7/7
gen ccent_6yr_avg = temp6/6
gen ccent_5yr_avg = temp5/5
gen ccent_4yr_avg = temp4/4
gen ccent_3yr_avg = temp3/3
gen ccent_2yr_avg = temp2/2
gen ccent_1yr_avg = temp1
replace ccent_10yr_avg = ccent_9yr_avg if ccent_9yr_avg==. 
replace ccent_10yr_avg = ccent_8yr_avg if ccent_8yr_avg==. 
replace ccent_10yr_avg = ccent_7yr_avg if ccent_7yr_avg==. 
replace ccent_10yr_avg = ccent_6yr_avg if ccent_6yr_avg==. 
replace ccent_10yr_avg = ccent_5yr_avg if ccent_5yr_avg==. 
replace ccent_10yr_avg = ccent_4yr_avg if ccent_4yr_avg==. 
replace ccent_10yr_avg = ccent_3yr_avg if ccent_4yr_avg==. 
replace ccent_10yr_avg = ccent_2yr_avg if ccent_3yr_avg==. 
replace ccent_10yr_avg = ccent_1yr_avg if ccent_2yr_avg==. 
gen ccent_10yr_avg_st = temp10/10
*the above is strictly 10yr with no assumed fillings
drop temp* ccent_2yr_avg ccent_1yr_avg ccent_4yr_avg ccent_3yr_avg ccent_5yr_avg ccent_6yr_avg ccent_7yr_avg ccent_8yr_avg ccent_9yr_avg

***5 year average
by ctycode: gen temp5 = ccent_temp +ccent_temp[_n-1] +ccent_temp[_n-2] +ccent_temp[_n-3] +ccent_temp[_n-4]
by ctycode: gen temp4 = ccent_temp +ccent_temp[_n-1] +ccent_temp[_n-2] +ccent_temp[_n-3]
by ctycode: gen temp3 = ccent_temp +ccent_temp[_n-1] +ccent_temp[_n-2]
by ctycode: gen temp2 = ccent_temp +ccent_temp[_n-1]
by ctycode: gen temp1 = ccent_temp
gen ccent_5yr_avg = temp5/5
gen ccent_4yr_avg = temp4/4
gen ccent_3yr_avg = temp3/3
gen ccent_2yr_avg = temp2/2
gen ccent_1yr_avg = temp1
replace ccent_5yr_avg = ccent_4yr_avg if ccent_5yr_avg==. 
replace ccent_5yr_avg = ccent_3yr_avg if ccent_4yr_avg==. 
replace ccent_5yr_avg = ccent_2yr_avg if ccent_3yr_avg==. 
replace ccent_5yr_avg = ccent_1yr_avg if ccent_2yr_avg==. 
gen ccent_5yr_avg_st = temp5/5
*the above is strictly 5yr with no assumed fillings
drop temp* ccent_2yr_avg ccent_1yr_avg ccent_4yr_avg ccent_3yr_avg

***3 year average
by ctycode: gen temp3 = ccent_temp +ccent_temp[_n-1] +ccent_temp[_n-2]
by ctycode: gen temp2 = ccent_temp +ccent_temp[_n-1]
by ctycode: gen temp1 = ccent_temp
gen ccent_3yr_avg = temp3/3
gen ccent_2yr_avg = temp2/2
gen ccent_1yr_avg = temp1
replace ccent_3yr_avg = ccent_2yr_avg if ccent_3yr_avg==. 
replace ccent_3yr_avg = ccent_1yr_avg if ccent_2yr_avg==.
gen ccent_3yr_avg_st = temp3/3
*the above is strictly 3yr with no assumed fillings
drop temp* ccent_2yr_avg ccent_1yr_avg

**the elasticity
gen beta_temp = l1.beta_all

***10 year average
by ctycode: gen temp10= beta_temp +beta_temp[_n-1] +beta_temp[_n-2] +beta_temp[_n-3] +beta_temp[_n-4] +beta_temp[_n-5] +beta_temp[_n-6] +beta_temp[_n-7] +beta_temp[_n-8] +beta_temp[_n-9]
by ctycode: gen temp9 = beta_temp +beta_temp[_n-1] +beta_temp[_n-2] +beta_temp[_n-3] +beta_temp[_n-4] +beta_temp[_n-5] +beta_temp[_n-6] +beta_temp[_n-7] +beta_temp[_n-8]
by ctycode: gen temp8 = beta_temp +beta_temp[_n-1] +beta_temp[_n-2] +beta_temp[_n-3] +beta_temp[_n-4] +beta_temp[_n-5] +beta_temp[_n-6] +beta_temp[_n-7]
by ctycode: gen temp7 = beta_temp +beta_temp[_n-1] +beta_temp[_n-2] +beta_temp[_n-3] +beta_temp[_n-4] +beta_temp[_n-5] +beta_temp[_n-6]
by ctycode: gen temp6 = beta_temp +beta_temp[_n-1] +beta_temp[_n-2] +beta_temp[_n-3] +beta_temp[_n-4] +beta_temp[_n-5]
by ctycode: gen temp5 = beta_temp +beta_temp[_n-1] +beta_temp[_n-2] +beta_temp[_n-3] +beta_temp[_n-4]
by ctycode: gen temp4 = beta_temp +beta_temp[_n-1] +beta_temp[_n-2] +beta_temp[_n-3]
by ctycode: gen temp3 = beta_temp +beta_temp[_n-1] +beta_temp[_n-2]
by ctycode: gen temp2 = beta_temp +beta_temp[_n-1]
by ctycode: gen temp1 = beta_temp
gen beta_10yr_avg = temp10/10
gen beta_9yr_avg = temp9/9
gen beta_8yr_avg = temp8/8
gen beta_7yr_avg = temp7/7
gen beta_6yr_avg = temp6/6
gen beta_5yr_avg = temp5/5
gen beta_4yr_avg = temp4/4
gen beta_3yr_avg = temp3/3
gen beta_2yr_avg = temp2/2
gen beta_1yr_avg = temp1
replace beta_10yr_avg = beta_9yr_avg if beta_9yr_avg==. 
replace beta_10yr_avg = beta_8yr_avg if beta_8yr_avg==. 
replace beta_10yr_avg = beta_7yr_avg if beta_7yr_avg==. 
replace beta_10yr_avg = beta_6yr_avg if beta_6yr_avg==. 
replace beta_10yr_avg = beta_5yr_avg if beta_5yr_avg==. 
replace beta_10yr_avg = beta_4yr_avg if beta_4yr_avg==. 
replace beta_10yr_avg = beta_3yr_avg if beta_4yr_avg==. 
replace beta_10yr_avg = beta_2yr_avg if beta_3yr_avg==. 
replace beta_10yr_avg = beta_1yr_avg if beta_2yr_avg==. 
gen beta_10yr_avg_st = temp10/10
*the above is strictly 10yr with no assumed fillings
drop temp* beta_2yr_avg beta_1yr_avg beta_4yr_avg beta_3yr_avg beta_5yr_avg beta_6yr_avg beta_7yr_avg beta_8yr_avg beta_9yr_avg

***5 year average
by ctycode: gen temp5 = beta_temp +beta_temp[_n-1] +beta_temp[_n-2] +beta_temp[_n-3] +beta_temp[_n-4]
by ctycode: gen temp4 = beta_temp +beta_temp[_n-1] +beta_temp[_n-2] +beta_temp[_n-3]
by ctycode: gen temp3 = beta_temp +beta_temp[_n-1] +beta_temp[_n-2]
by ctycode: gen temp2 = beta_temp +beta_temp[_n-1]
by ctycode: gen temp1 = beta_temp
gen beta_5yr_avg = temp5/5
gen beta_4yr_avg = temp4/4
gen beta_3yr_avg = temp3/3
gen beta_2yr_avg = temp2/2
gen beta_1yr_avg = temp1
replace beta_5yr_avg = beta_4yr_avg if beta_5yr_avg==. 
replace beta_5yr_avg = beta_3yr_avg if beta_4yr_avg==. 
replace beta_5yr_avg = beta_2yr_avg if beta_3yr_avg==. 
replace beta_5yr_avg = beta_1yr_avg if beta_2yr_avg==. 
gen beta_5yr_avg_st = temp5/5
*the above is strictly 5yr with no assumed fillings
drop temp* beta_2yr_avg beta_1yr_avg beta_4yr_avg beta_3yr_avg

***3 year average
by ctycode: gen temp3 = beta_temp +beta_temp[_n-1] +beta_temp[_n-2]
by ctycode: gen temp2 = beta_temp +beta_temp[_n-1]
by ctycode: gen temp1 = beta_temp
gen beta_3yr_avg = temp3/3
gen beta_2yr_avg = temp2/2
gen beta_1yr_avg = temp1
replace beta_3yr_avg = beta_2yr_avg if beta_3yr_avg==. 
replace beta_3yr_avg = beta_1yr_avg if beta_2yr_avg==.
gen beta_3yr_avg_st = temp3/3
*the above is strictly 3yr with no assumed fillings
drop temp* beta_2yr_avg beta_1yr_avg

**the partisanship
gen partisan_temp = l1.govid2006_1_us_inv 

***10 year average
by ctycode: gen temp10= partisan_temp +partisan_temp[_n-1] +partisan_temp[_n-2] +partisan_temp[_n-3] +partisan_temp[_n-4] +partisan_temp[_n-5] +partisan_temp[_n-6] +partisan_temp[_n-7] +partisan_temp[_n-8] +partisan_temp[_n-9]
by ctycode: gen temp9 = partisan_temp +partisan_temp[_n-1] +partisan_temp[_n-2] +partisan_temp[_n-3] +partisan_temp[_n-4] +partisan_temp[_n-5] +partisan_temp[_n-6] +partisan_temp[_n-7] +partisan_temp[_n-8]
by ctycode: gen temp8 = partisan_temp +partisan_temp[_n-1] +partisan_temp[_n-2] +partisan_temp[_n-3] +partisan_temp[_n-4] +partisan_temp[_n-5] +partisan_temp[_n-6] +partisan_temp[_n-7]
by ctycode: gen temp7 = partisan_temp +partisan_temp[_n-1] +partisan_temp[_n-2] +partisan_temp[_n-3] +partisan_temp[_n-4] +partisan_temp[_n-5] +partisan_temp[_n-6]
by ctycode: gen temp6 = partisan_temp +partisan_temp[_n-1] +partisan_temp[_n-2] +partisan_temp[_n-3] +partisan_temp[_n-4] +partisan_temp[_n-5]
by ctycode: gen temp5 = partisan_temp +partisan_temp[_n-1] +partisan_temp[_n-2] +partisan_temp[_n-3] +partisan_temp[_n-4]
by ctycode: gen temp4 = partisan_temp +partisan_temp[_n-1] +partisan_temp[_n-2] +partisan_temp[_n-3]
by ctycode: gen temp3 = partisan_temp +partisan_temp[_n-1] +partisan_temp[_n-2]
by ctycode: gen temp2 = partisan_temp +partisan_temp[_n-1]
by ctycode: gen temp1 = partisan_temp
gen partisan_10yr_avg = temp10/10
gen partisan_9yr_avg = temp9/9
gen partisan_8yr_avg = temp8/8
gen partisan_7yr_avg = temp7/7
gen partisan_6yr_avg = temp6/6
gen partisan_5yr_avg = temp5/5
gen partisan_4yr_avg = temp4/4
gen partisan_3yr_avg = temp3/3
gen partisan_2yr_avg = temp2/2
gen partisan_1yr_avg = temp1
replace partisan_10yr_avg = partisan_9yr_avg if partisan_9yr_avg==. 
replace partisan_10yr_avg = partisan_8yr_avg if partisan_8yr_avg==. 
replace partisan_10yr_avg = partisan_7yr_avg if partisan_7yr_avg==. 
replace partisan_10yr_avg = partisan_6yr_avg if partisan_6yr_avg==. 
replace partisan_10yr_avg = partisan_5yr_avg if partisan_5yr_avg==. 
replace partisan_10yr_avg = partisan_4yr_avg if partisan_4yr_avg==. 
replace partisan_10yr_avg = partisan_3yr_avg if partisan_4yr_avg==. 
replace partisan_10yr_avg = partisan_2yr_avg if partisan_3yr_avg==. 
replace partisan_10yr_avg = partisan_1yr_avg if partisan_2yr_avg==. 
gen partisan_10yr_avg_st = temp10/10
*the above is strictly 10yr with no assumed fillings
drop temp* partisan_2yr_avg partisan_1yr_avg partisan_4yr_avg partisan_3yr_avg partisan_5yr_avg partisan_6yr_avg partisan_7yr_avg partisan_8yr_avg partisan_9yr_avg

***5 year average
by ctycode: gen temp5 = partisan_temp +partisan_temp[_n-1] +partisan_temp[_n-2] +partisan_temp[_n-3] +partisan_temp[_n-4]
by ctycode: gen temp4 = partisan_temp +partisan_temp[_n-1] +partisan_temp[_n-2] +partisan_temp[_n-3]
by ctycode: gen temp3 = partisan_temp +partisan_temp[_n-1] +partisan_temp[_n-2]
by ctycode: gen temp2 = partisan_temp +partisan_temp[_n-1]
by ctycode: gen temp1 = partisan_temp
gen partisan_5yr_avg = temp5/5
gen partisan_4yr_avg = temp4/4
gen partisan_3yr_avg = temp3/3
gen partisan_2yr_avg = temp2/2
gen partisan_1yr_avg = temp1
replace partisan_5yr_avg = partisan_4yr_avg if partisan_5yr_avg==. 
replace partisan_5yr_avg = partisan_3yr_avg if partisan_4yr_avg==. 
replace partisan_5yr_avg = partisan_2yr_avg if partisan_3yr_avg==. 
replace partisan_5yr_avg = partisan_1yr_avg if partisan_2yr_avg==. 
gen partisan_5yr_avg_st = temp5/5
*the above is strictly 5yr with no assumed fillings
drop temp* partisan_2yr_avg partisan_1yr_avg partisan_4yr_avg partisan_3yr_avg

***3 year average
by ctycode: gen temp3 = partisan_temp +partisan_temp[_n-1] +partisan_temp[_n-2]
by ctycode: gen temp2 = partisan_temp +partisan_temp[_n-1]
by ctycode: gen temp1 = partisan_temp
gen partisan_3yr_avg = temp3/3
gen partisan_2yr_avg = temp2/2
gen partisan_1yr_avg = temp1
replace partisan_3yr_avg = partisan_2yr_avg if partisan_3yr_avg==. 
replace partisan_3yr_avg = partisan_1yr_avg if partisan_2yr_avg==.
gen partisan_3yr_avg_st = temp3/3
*the above is strictly 3yr with no assumed fillings
drop temp* partisan_2yr_avg partisan_1yr_avg

*the following is one, three, five, and ten-year average
pwcorr C_cent govid2006_1_us_inv beta_all, sig obs
pwcorr ccent_3yr_avg partisan_3yr_avg beta_3yr_avg, sig obs
pwcorr ccent_5yr_avg partisan_5yr_avg beta_5yr_avg, sig obs
pwcorr ccent_10yr_avg partisan_10yr_avg beta_10yr_avg, sig obs
