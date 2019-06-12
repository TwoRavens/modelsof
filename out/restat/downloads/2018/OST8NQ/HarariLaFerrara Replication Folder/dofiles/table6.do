*===================================================================================================
* set up
*===================================================================================================
cap log close

global name = "table6"
local cdate : di %tdCCYY.NN.DD date(c(current_date),"DMY")
log using "${logs}/${name}_`cdate'.log", text replace

forval depnum = 1/25 {

	di _newline
	di "************** Current iteration: `depnum' ********************"

	global depnum = `depnum'

	*===================================================================================================
	* Define Globals
	*===================================================================================================
	if ${depnum} == 1 {
		global depvar = "ACTOR1_GOVT_ACTOR2_GOVT"
	}
	else if ${depnum} == 2 {
		global depvar = "ACTOR1_GOVT_ACTOR2_REBEL"
	}
	else if ${depnum} == 3 {
		global depvar = "ACTOR1_GOVT_ACTOR2_POLMIL"
	}
	else if ${depnum} == 4 {
		global depvar = "ACTOR1_GOVT_ACTOR2_ETHMIL"
	}
	else if ${depnum} == 5 {
		global depvar = "ACTOR1_GOVT_ACTOR2_OTHER"
	}
	else if ${depnum} == 6 {
		global depvar = "ACTOR1_REBEL_ACTOR2_GOVT"
	}
	else if ${depnum} == 7 {
		global depvar = "ACTOR1_REBEL_ACTOR2_REBEL"
	}
	else if ${depnum} == 8 {
		global depvar = "ACTOR1_REBEL_ACTOR2_POLMIL"
	}
	else if ${depnum} == 9 {
		global depvar = "ACTOR1_REBEL_ACTOR2_ETHMIL"
	}
	else if ${depnum} == 10 {
		global depvar = "ACTOR1_REBEL_ACTOR2_OTHER"
	}
	else if ${depnum} == 11 {
		global depvar = "ACTOR1_POLMIL_ACTOR2_GOVT"
	}
	else if ${depnum} == 12 {
		global depvar = "ACTOR1_POLMIL_ACTOR2_REBEL"
	}
	else if ${depnum} == 13 {
		global depvar = "ACTOR1_POLMIL_ACTOR2_POLMIL"
	}
	else if ${depnum} == 14 {
		global depvar = "ACTOR1_POLMIL_ACTOR2_ETHMIL"
	}
	else if ${depnum} == 15 {
		global depvar = "ACTOR1_POLMIL_ACTOR2_OTHER"
	}
	else if ${depnum} == 16 {
		global depvar = "ACTOR1_ETHMIL_ACTOR2_GOVT"
	}
	else if ${depnum} == 17 {
		global depvar = "ACTOR1_ETHMIL_ACTOR2_REBEL"
	}
	else if ${depnum} == 18 {
		global depvar = "ACTOR1_ETHMIL_ACTOR2_POLMIL"
	}
	else if ${depnum} == 19 {
		global depvar = "ACTOR1_ETHMIL_ACTOR2_ETHMIL"
	}
	else if ${depnum} == 20 {
		global depvar = "ACTOR1_ETHMIL_ACTOR2_OTHER"
	}
	else if ${depnum} == 21 {
		global depvar = "ACTOR1_OTHER_ACTOR2_GOVT"
	}
	else if ${depnum} == 22 {
		global depvar = "ACTOR1_OTHER_ACTOR2_REBEL"
	}
	else if ${depnum} == 23 {
		global depvar = "ACTOR1_OTHER_ACTOR2_POLMIL"
	}
	else if ${depnum} == 24 {
		global depvar = "ACTOR1_OTHER_ACTOR2_ETHMIL"
	}
	else if ${depnum} == 25 {
		global depvar = "ACTOR1_OTHER_ACTOR2_OTHER"
	}
	
	global x "elevation_cell rough_cell area_cell use_primary dis_river_cell shared border any_mineral ELF"
	global SPEI "SPEI4pg L1_SPEI4pg L2_SPEI4pg GSmain_ext_SPEI4pg L1_GSmain_ext_SPEI4pg L2_GSmain_ext_SPEI4pg"

	
	* ========================================================
	* Regression
	* ========================================================

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
	dis "weight matrix"
	preserve
		keep cell lat lon
		duplicates drop
		spwmatrix gecon lat lon, wn(W_bin_180) wtype(bin)  db(0 180) connect
	restore

	* use coefficients from non spatial regression as starting values for ML algorithm
	qui reg ${depvar} ${SPEI} ctry_*_x_yr_*
	matrix b=e(b)
	
	* regression
	xsmle_Sept16 ${depvar} ${SPEI} ctry_*_x_yr_*, wmatrix(W_bin_180) model(sdm) dlag(1) cluster(cell) from(b, skip) fe type(ind) technique(bhhh 5 nr 5 dfp 5 bfgs 5) 
	
	if ${depnum} == 1 {
		outreg2 using "${output}/table6.xls", title () ctitle (`depvar') drop(*ctry* *yr*)  ///
		addtext(Country x Year FE, X, Cell FE, X) nocons label replace
		}
	else if ${depnum} !=1 {
		outreg2 using "${output}/table6.xls", title () ctitle (`depvar') drop(*ctry* *yr*)  ///
		addtext(Country x Year FE, X, Cell FE, X) nocons label append
	}
	
}	

cap log close
