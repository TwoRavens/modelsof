* ==========================================================================================
* set up
*===================================================================================================
cap log close

global name = "table5"
local cdate : di %tdCCYY.NN.DD date(c(current_date),"DMY")
log using "${logs}/${name}_`cdate'.log", text replace


*===============================================================================
* Define Globals
*===============================================================================
global x "elevation_cell rough_cell area_cell use_primary dis_river_cell shared border any_mineral ELF"
global SPEI "SPEI4pg L1_SPEI4pg L2_SPEI4pg GSmain_ext_SPEI4pg L1_GSmain_ext_SPEI4pg L2_GSmain_ext_SPEI4pg"


*===============================================================================
* regression (with cell FE)
*===============================================================================

use "${data}/geoconflict_main.dta", clear
xtset cell year, yearly

quie xtbalance , rang(1997 2011) miss(${x} ${SPEI})


* generate country x year FEs
tab year, gen(yr_)
foreach x of varlist ctry_* {
foreach y of varlist yr_* {
	quie gen `x'_x_`y'=`x'*`y'
}
}

* generate weight matrix 
preserve
keep cell lat lon
duplicates drop
spwmatrix gecon lat lon, wn(W_bin_180) wtype(bin)  db(0 180) connect
restore

* regressions
foreach depvar in  BATTLE_ACLED CIVILIAN_ACLED RIOT_ACLED OTHER_REBEL_ACT_ACLED   {

qui reg `depvar' ${SPEI} ctry_*_x_yr* 
matrix b=e(b)
xsmle_Sept16 `depvar' ${SPEI} ctry_*_x_yr* , wmatrix(W_bin_180) model(sdm) dlag(1) cluster(cell) from(b, skip)  fe type(ind) technique(bhhh 5 nr 5 dfp 5 bfgs 5

if `depvar'=="BATTLE"{
outreg2 using "${output}/table5.xls", title () ctitle (MODEL III, MLE, `depvar') drop(*ctry* *yr*)  ///
addtext(Country x Year FE, X, Cell FE, X) nocons label replace
}

if `depvar'!="BATTLE"{
outreg2 using "${output}/table5.xls", title () ctitle (MODEL III, MLE, `depvar') drop(*ctry* *yr*)  ///
addtext(Country x Year FE, X, Cell FE, X) nocons label append
}


}
cap log close
