
* REPLICATION CODE: JENNINGS & WLEZIEN, 'THE COMPARATIVE TIMELINE OF ELECTIONS', AMERICAN JOURNAL OF POLITICAL SCIENCE *

* FIGURE 3 

*********************************************************************************************
** MULTIPLE IMPUTATION/BOOTSTRAP - ALL ELECTIONS - VOTE = POLLS *****************************
*********************************************************************************************

use LONG_MI.dta, clear

drop if daysbeforeED>900
gen _parXcou_ = countryid+(partyid/100)

gen rmse=.
gen se_rmse=.

foreach x of numlist 1/900 {
quietly mi estimate, cmdok: mybstrprmse vote_ poll_ if daysbeforeED==`x'
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

save MI_ALL_RMSE.dta, replace

*********************************************************************************************
** MULTIPLE IMPUTATION/BOOTSTRAP - ALL ELECTIONS - VOTE = POLLS + PARTY *********************
*********************************************************************************************

use LONG_MI.dta, clear

drop if daysbeforeED>900
gen _parXcou_ = countryid+(partyid/100)

gen rmse=.
gen se_rmse=.

foreach x of numlist 1/900 {
quietly mi estimate, cmdok: mybstrprmseareg vote_ poll_ if daysbeforeED==`x'
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

save MI_P_ALL_RMSE.dta, replace

****** FIGURE 3 *****************************************************************************
*Root Mean Squared Errors Predicting the Party Vote Share from the Poll Share, By Date in Election Cycle—Pooling all Elections

use MI_ALL_RMSE.dta, clear 
rename rmse all_rmse
rename rmse_min95 all_rmse_min95
rename rmse_max95 all_rmse_max95
drop se_rmse
sort daysbeforeED
save MI_ALL_RMSE.dta, replace

use MI_P_ALL_RMSE.dta, clear
rename rmse p_all_rmse
rename rmse_min95 p_all_rmse_min95
rename rmse_max95 p_all_rmse_max95
drop se_rmse
sort daysbeforeED
save MI_P_ALL_RMSE.dta, replace

merge daysbeforeED using MI_ALL_RMSE.dta

* 
twoway /*
*/  || line all_rmse daysbeforeED if daysbeforeED<900, /*
*/  clpattern(solid) clcolor(black) clwidth(medthick)  /* 
*/  || line p_all_rmse daysbeforeED if daysbeforeED<900, /*
*/  clpattern(dash) clcolor(black) clwidth(medthick)  /* 
*/  || line all_rmse_min95 daysbeforeED if daysbeforeED<900,  /*
*/  clpattern(dot) clcolor(black) clwidth(medium) /*
*/  || line all_rmse_max95 daysbeforeED if daysbeforeED<900,  /*
*/  clpattern(dot) clcolor(black) clwidth(medium) /*
*/  || line p_all_rmse_min95 daysbeforeED if daysbeforeED<900,  /*
*/  clpattern(dot) clcolor(black) clwidth(medium) /*
*/  || line p_all_rmse_max95 daysbeforeED if daysbeforeED<900,  /*
*/  clpattern(dot) clcolor(black) clwidth(medium) /*
*/  , scheme(s2mono) graphregion(color(white)) /*
*/  xtitle("Days Until Election") /*
*/  title("") /*
*/  ylabel(0(1)10, gmax angle(horizontal)) /*
*/  ytick(0(1)10) /*
*/  ytitle(Root Mean Squared Error) /*
*/  xlabel(0(100)900) /*
*/  xscale(reverse) xscale(titlegap(2)) /*
*/  legend(order(1 "Without Party Controls" 2 "With Party Controls") /*
*/  rows(1) /*
*/  size(medsmall))

graph export Fig3.tif

