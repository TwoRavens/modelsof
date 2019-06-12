/* Note: code requires user-written ado file my_ols_spatial_HAC, kindly provided by Nicolas Berman, Mathieu Couttenier, Dominic Rohner, and Mathias Thoenig,
amedned version of original ado file ols_spatial_hac by Solomon Hsiang. */

*===================================================================================================
* set up
*===================================================================================================
cap log close

global name = "table2"
local cdate : di %tdCCYY.NN.DD date(c(current_date),"DMY")
log using "${logs}/${name}_`cdate'.log", text replace

*===============================================================================
* Define Globals
*===============================================================================

global x "elevation_cell rough_cell area_cell use_primary dis_river_cell shared border any_mineral ELF"
global W_x "W_elevation_cell W_rough_cell W_area_cell W_use_primary W_dis_river_cell W_shared W_border W_any_mineral W_ELF"
global SPEI "SPEI4pg L1_SPEI4pg L2_SPEI4pg GSmain_ext_SPEI4pg L1_GSmain_ext_SPEI4pg L2_GSmain_ext_SPEI4pg"
global W_SPEI "W_SPEI4pg W_L1_SPEI4pg W_L2_SPEI4pg W_GSmain_ext_SPEI4pg W_L1_GSmain_ext_SPEI4pg W_L2_GSmain_ext_SPEI4pg"

*===============================================================================
* regressions (with cell RE)
*===============================================================================

use "${data}/geoconflict_main.dta", clear

xtset cell year, yearly

quie xtbalance , rang(1997 2011) miss(${x} ${SPEI})

tab year, gen(yr_)

* column 1: model I, Country specific linear time trend
dis "column 1"

preserve

drop if l.ANY_EVENT_ACLED == .
gen const = 1

* generate the country-specific linear time trend
foreach x of varlist ctry_* W_ctry_* {
	quie gen `x'_x_trend=`x'*(year-1996) 
}

my_ols_spatial_HAC ANY_EVENT_ACLED  ${x} ${SPEI} ctry*trend* yr_* const, lat(lat) lon(lon) timevar(year) panelvar(cell) dist(180) dropvar lag(10) display
outreg2 using "${output}/table2.xls", title () ctitle (MODEL I, OLS) drop(${x} ${W_x} *ctry* *yr*)  ///
addtext(Controls, X, Year FE, X, Country Specific Time Trend, X)   ///
addnote(" Each observation is a cell/year.  Standard errors in parenthesis. Cols. 1,2 corrected for spatial and serial correlation following  Hsiang(2010). Cols. 3-6 corrected for clustering at the cell level. W = binary contiguity matrix, cutoff 180 km.") nocons label replace

* column 2: model II, Country specific linear time trend

dis "column 2"
my_ols_spatial_HAC ANY_EVENT_ACLED ${x} ${SPEI} ${W_x} ${W_SPEI} *trend* yr_* const, lat(lat) lon(lon) timevar(year) panelvar(cell) dist(180) dropvar lag(10) display
outreg2 using "${output}/table2.xls", title () ctitle (MODEL II, OLS) drop(${x} ${W_x} *ctry* *yr*)  ///
addtext(Controls, X, Year FE, X, Country Specific Time Trend, X)  nocons label append

restore

* generate weight matrix 
preserve
	keep cell lat lon
	duplicates drop
	spwmatrix gecon lat lon, wn(W_bin_180) wtype(bin)  db(0 180) connect
restore

* column 3: model III, year FE, Country specific linear time trend

* generate the country-specific linear time trend
foreach x of varlist ctry_* {
	quie gen `x'_x_trend=`x'*(year-1996) 
}


dis "column 3"
xsmle_Sept16 ANY_EVENT_ACLED ${x} ${SPEI} yr_* *_trend , wmatrix(W_bin_180) model(sdm) dlag(1) cluster(cell) 
outreg2 using "${output}/table2.xls", title () ctitle (MODEL III, MLE) drop(${x} ${W_x} *ctry* *yr*)  ///
addtext(Controls, X, Year FE, X, Country Specific Time Trend, X) nocons label append


* generate country x year FEs
foreach x of varlist ctry_* {
foreach y of varlist yr_* {
	quie gen `x'_x_`y'=`x'*`y'
}
}

* column 4
dis "column 4"
xsmle_Sept16 ANY_EVENT_ACLED ${x} ${SPEI} ctry_*_x_yr_*, wmatrix(W_bin_180) model(sdm) dlag(1) cluster(cell)
outreg2 using "${output}/table2.xls", title () ctitle (MODEL III, MLE) drop(${x} ${W_x} *ctry* *yr*)  ///
addtext(Controls, X, Country x Year FE, X) nocons label append


* column 5
dis "column 5"
qui reg ANY_EVENT_ACLED ${SPEI}  ctry_*_x_yr*
matrix b=e(b)
xsmle_Sept16 ANY_EVENT_ACLED  ${SPEI} ctry_*_x_yr*, wmatrix(W_bin_180) dlag(1) model(sdm) cluster(cell) from(b, skip) fe type(ind) technique(bhhh 5 nr 5 dfp 5 bfgs 5) difficult
outreg2 using "${output}/table2.xls", title () ctitle (MODEL III, MLE) drop(*ctry* *yr*)  ///
addtext(Country x Year FE, X, Cell FE, X) nocons label append


cap log close
