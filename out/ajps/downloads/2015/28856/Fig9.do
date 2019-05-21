
* REPLICATION CODE: JENNINGS & WLEZIEN, 'THE COMPARATIVE TIMELINE OF ELECTIONS', AMERICAN JOURNAL OF POLITICAL SCIENCE *

* FIGURE 9

*********************************************************************************************
** MULTIPLE IMPUTATION/BOOTSTRAP - ALL ELECTIONS - VOTE = POLLS + PARTY *********************
*********************************************************************************************

use LONG_MI.dta, clear

keep if election=="Legislative"
keep if enpp<=3.5

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

save MI_P_ALL_ED200_RMSE_LEG_ENP_LOW.dta, replace

*********************************************************************************************
** MULTIPLE IMPUTATION/BOOTSTRAP - ALL ELECTIONS - VOTE = POLLS + PARTY *********************
*********************************************************************************************

use LONG_MI.dta, clear

keep if election=="Legislative"
keep if enpp>3.5

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

save MI_P_ALL_ED200_RMSE_LEG_ENP_HIGH.dta, replace

****** FIGURE 9 ****************************************************************************
*Root Mean Squared Errors across the Effective Number of Political Parties

use MI_P_ALL_ED200_RMSE_LEG_ENP_LOW.dta, clear 
rename rmse enpp_3_rmse
rename rmse_min95 enpp_3_rmse_min95
rename rmse_max95 enpp_3_rmse_max95
drop se_rmse
sort daysbeforeED
save MI_P_ALL_ED200_RMSE_LEG_ENP_LOW.dta, replace

use MI_P_ALL_ED200_RMSE_LEG_ENP_HIGH.dta, clear 
rename rmse enpp_4_rmse
rename rmse_min95 enpp_4_rmse_min95
rename rmse_max95 enpp_4_rmse_max95
drop se_rmse
sort daysbeforeED
save MI_P_ALL_ED200_RMSE_LEG_ENP_HIGH.dta, replace

merge daysbeforeED using MI_P_ALL_ED200_RMSE_LEG_ENP_LOW.dta

* 
twoway /*
*/  || line enpp_3_rmse daysbeforeED if daysbeforeED<201, /*
*/  clpattern(solid) clcolor(black) clwidth(medthick)  /* 
*/  || line enpp_4_rmse daysbeforeED if daysbeforeED<201, /*
*/  clpattern(dash) clcolor(black) clwidth(medthick)  /* 
*/  || line enpp_3_rmse_min95 daysbeforeED if daysbeforeED<201,  /*
*/  clpattern(dot) clcolor(black) clwidth(medium) /*
*/  || line enpp_3_rmse_max95 daysbeforeED if daysbeforeED<201,  /*
*/  clpattern(dot) clcolor(black) clwidth(medium) /*
*/  || line enpp_4_rmse_min95 daysbeforeED if daysbeforeED<201,  /*
*/  clpattern(dot) clcolor(black) clwidth(medium) /*
*/  || line enpp_4_rmse_max95 daysbeforeED if daysbeforeED<201,  /*
*/  clpattern(dot) clcolor(black) clwidth(medium) /*
*/  , scheme(s2mono) graphregion(color(white)) /*
*/  xtitle("Days Until Election") /*
*/  title("") /*
*/  ylabel(0(1)10, gmax angle(horizontal)) /*
*/  ytick(0(1)10) /*
*/  ytitle(Root Mean Squared Error) /*
*/  xlabel(0(50)200) /*
*/  xscale(reverse) xscale(titlegap(2)) /*
*/  legend(order(1 "ENP<3.5" 2 "ENP>3.5") /*
*/  rows(1) /*
*/  size(medsmall))

graph export Fig9.tif


