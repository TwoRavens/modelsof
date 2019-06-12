
* REPLICATION CODE: JENNINGS & WLEZIEN, 'THE COMPARATIVE TIMELINE OF ELECTIONS', AMERICAN JOURNAL OF POLITICAL SCIENCE *

* FIGURE 7

*********************************************************************************************
** MULTIPLE IMPUTATION/BOOTSTRAP - ALL ELECTIONS - VOTE = POLLS + PARTY *********************
*********************************************************************************************

use LONG_MI.dta, clear

keep if election=="Legislative"
keep if rule=="SMDP"

drop if daysbeforeED>200
gen _parXcou_ = countryid+(partyid/100)

gen rmse=.
gen se_rmse=.

foreach x of numlist 1/200 {
quietly mi estimate, cmdok: mybstrprmseareg vote_ poll_ if daysbeforeED==`x' & pollcycle>199
matrix bts = e(b_mi)
scalar bt = bts[1,1]
replace rmse=bt in `x'
matrix bts = e(V_mi)
scalar bt = bts[1,1]
replace se_rmse=sqrt(bt) in `x'
ereturn clear
}

*********************************************************************************************
** OUTPUT/FORMAT THE TIMELINE DATASET *******************************************************
*********************************************************************************************

keep rmse se_rmse
gen daysbeforeED=_n

drop if rmse == .
mi xtset, clear 
sort daysbeforeED

gen rmse_min95=rmse+se_rmse
gen rmse_max95=rmse-se_rmse

save MI_P_ALL_ED200_RMSE_LEG_SMDP.dta, replace

*********************************************************************************************
** MULTIPLE IMPUTATION/BOOTSTRAP - ALL ELECTIONS - VOTE = POLLS + PARTY *********************
*********************************************************************************************

use LONG_MI.dta, clear

keep if election=="Legislative"
keep if rule=="PR"

drop if daysbeforeED>200
gen _parXcou_ = countryid+(partyid/100)

gen rmse=.
gen se_rmse=.

foreach x of numlist 1/200 {
quietly mi estimate, cmdok: mybstrprmseareg vote_ poll_ if daysbeforeED==`x' & pollcycle>199
matrix bts = e(b_mi)
scalar bt = bts[1,1]
replace rmse=bt in `x'
matrix bts = e(V_mi)
scalar bt = bts[1,1]
replace se_rmse=sqrt(bt) in `x'
ereturn clear
}

*********************************************************************************************
** OUTPUT/FORMAT THE TIMELINE DATASET *******************************************************
*********************************************************************************************

keep rmse se_rmse
gen daysbeforeED=_n

drop if rmse == .
mi xtset, clear 
sort daysbeforeED

gen rmse_min95=rmse+se_rmse
gen rmse_max95=rmse-se_rmse

save MI_P_ALL_ED200_RMSE_LEG_PR.dta, replace

****** FIGURE 7 *****************************************************************************
*Root Mean Squared Errors for Legislative Elections in Proportional and Plurality Systems  

use MI_P_ALL_ED200_RMSE_LEG_PR.dta, clear 
rename rmse pr_rmse
rename rmse_min95 pr_rmse_min95
rename rmse_max95 pr_rmse_max95
drop se_rmse
sort daysbeforeED
save MI_P_ALL_ED200_RMSE_LEG_PR.dta, replace

use MI_P_ALL_ED200_RMSE_LEG_SMDP.dta, clear 
rename rmse smdp_rmse
rename rmse_min95 smdp_rmse_min95
rename rmse_max95 smdp_rmse_max95
drop se_rmse
sort daysbeforeED
save MI_P_ALL_ED200_RMSE_LEG_SMDP.dta, replace

merge daysbeforeED using MI_P_ALL_ED200_RMSE_LEG_PR.dta

* 
twoway /*
*/  || line pr_rmse daysbeforeED if daysbeforeED<200, /*
*/  clpattern(solid) clcolor(black) clwidth(medthick)  /* 
*/  || line smdp_rmse daysbeforeED if daysbeforeED<200, /*
*/  clpattern(dash) clcolor(black) clwidth(medthick)  /* 
*/  || line pr_rmse_min95 daysbeforeED if daysbeforeED<200,  /*
*/  clpattern(dot) clcolor(black) clwidth(medium) /*
*/  || line pr_rmse_max95 daysbeforeED if daysbeforeED<200,  /*
*/  clpattern(dot) clcolor(black) clwidth(medium) /*
*/  || line smdp_rmse_min95 daysbeforeED if daysbeforeED<200,  /*
*/  clpattern(dot) clcolor(black) clwidth(medium) /*
*/  || line smdp_rmse_max95 daysbeforeED if daysbeforeED<200,  /*
*/  clpattern(dot) clcolor(black) clwidth(medium) /*
*/  , scheme(s2mono) graphregion(color(white)) /*
*/  xtitle("Days Until Election") /*
*/  title("") /*
*/  ylabel(0(1)10, gmax angle(horizontal)) /*
*/  ytick(0(1)10) /*
*/  ytitle(Root Mean Squared Error) /*
*/  xlabel(0(50)200) /*
*/  xscale(reverse) xscale(titlegap(2)) /*
*/  legend(order(1 "PR" 2 "SMDP") /*
*/  rows(1) /*
*/  size(medsmall))

graph export Fig7.tif
