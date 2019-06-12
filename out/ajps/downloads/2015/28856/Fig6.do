
* REPLICATION CODE: JENNINGS & WLEZIEN, 'THE COMPARATIVE TIMELINE OF ELECTIONS', AMERICAN JOURNAL OF POLITICAL SCIENCE *

* FIGURE 6

*********************************************************************************************
** MULTIPLE IMPUTATION/BOOTSTRAP - ALL ELECTIONS - VOTE = POLLS + PARTY *********************
*********************************************************************************************

use LONG_MI.dta, clear

keep if election=="Legislative"
drop if system=="Parliamentary"

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

save MI_P_ALL_ED200_RMSE_PRES_LEG.dta, replace

*********************************************************************************************
** MULTIPLE IMPUTATION/BOOTSTRAP - ALL ELECTIONS - VOTE = POLLS + PARTY *********************
*********************************************************************************************

use LONG_MI.dta, clear

keep if election=="Legislative"
keep if system=="Parliamentary"

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

save MI_P_ALL_ED200_RMSE_PARL_LEG.dta, replace

****** FIGURE 11 ****************************************************************************
*Root Mean Squared Errors for Legislative Elections in Presidential and Parliamentary Systems

use MI_P_ALL_ED200_RMSE_PRES_LEG.dta, clear 
rename rmse pres_rmse
rename rmse_min95 pres_rmse_min95
rename rmse_max95 pres_rmse_max95
drop se_rmse
sort daysbeforeED
save MI_P_ALL_ED200_RMSE_PRES_LEG.dta, replace

use MI_P_ALL_ED200_RMSE_PARL_LEG.dta, clear 
rename rmse parl_rmse
rename rmse_min95 parl_rmse_min95
rename rmse_max95 parl_rmse_max95
drop se_rmse
sort daysbeforeED
save MI_P_ALL_ED200_RMSE_PARL_LEG.dta, replace

merge daysbeforeED using MI_P_ALL_ED200_RMSE_PRES_LEG.dta

* 
twoway /*
*/  || line pres_rmse daysbeforeED if daysbeforeED<200, /*
*/  clpattern(solid) clcolor(black) clwidth(medthick)  /* 
*/  || line parl_rmse daysbeforeED if daysbeforeED<200, /*
*/  clpattern(dash) clcolor(black) clwidth(medthick)  /* 
*/  || line pres_rmse_min95 daysbeforeED if daysbeforeED<200,  /*
*/  clpattern(dot) clcolor(black) clwidth(medium) /*
*/  || line pres_rmse_max95 daysbeforeED if daysbeforeED<200,  /*
*/  clpattern(dot) clcolor(black) clwidth(medium) /*
*/  || line parl_rmse_min95 daysbeforeED if daysbeforeED<200,  /*
*/  clpattern(dot) clcolor(black) clwidth(medium) /*
*/  || line parl_rmse_max95 daysbeforeED if daysbeforeED<200,  /*
*/  clpattern(dot) clcolor(black) clwidth(medium) /*
*/  , scheme(s2mono) graphregion(color(white)) /*
*/  xtitle("Days Until Election") /*
*/  title("") /*
*/  ylabel(0(1)10, gmax angle(horizontal)) /*
*/  ytick(0(1)10) /*
*/  ytitle(Root Mean Squared Error) /*
*/  xlabel(0(50)200) /*
*/  xscale(reverse) xscale(titlegap(2)) /*
*/  legend(order(1 "Presidential" 2 "Parliamentary") /*
*/  rows(1) /*
*/  size(medsmall))

graph export Fig6.tif
