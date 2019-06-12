*===================================================================================================
* set up
*===================================================================================================
cap log close

global name = "table4"
local cdate : di %tdCCYY.NN.DD date(c(current_date),"DMY")
log using "${logs}/${name}_`cdate'.log", text replace

*===============================================================================
* construct alternative matrices
*===============================================================================
cap prog drop genmatrix
prog define genmatrix 
if 1==1 {
	use "${data}/geoconflict_main.dta", clear

	* cells belong to the same country
	preserve
	keep cell lat lon country_largest_share 
	duplicates drop
	local N = _N
	forval i = 1/`N' {
		gen samectry`i'=0
	}

	encode country_largest_share, gen(ctryid)
	order ctryid, after (country_largest_share)

	forval j = 1/`N' {
		local id = ctryid[`j']
		qui replace samectry`j'= 1 if (`id' == ctryid) 
	}
	keep cell lat lon samectry*
	tempfile samectry
	save `samectry', replace
	restore

	* cells belong to different country
	preserve
	keep cell lat lon country_largest_share 
	duplicates drop
	local N = _N
	forval i = 1/`N' {
		gen diffctry`i'=0
	}

	encode country_largest_share, gen(ctryid)
	order ctryid, after (country_largest_share)

	forval j = 1/`N' {
		local id = ctryid[`j']
		qui replace diffctry`j'= 1 if (`id' != ctryid) 
	}
	keep cell lat lon diffctry*
	tempfile diffctry
	save `diffctry', replace
	restore
	
	* cells have the same main crop 
	preserve
	keep cell lat lon maincrop_harea
	duplicates drop
	local N = _N
	forval i = 1/`N' {
		gen samecrop`i'=0
	}

	encode maincrop_harea, gen(cropid)
	order cropid, after (maincrop_harea)
	
	forval j = 1/`N' {
		local id = cropid[`j']
		qui replace samecrop`j'= 1 if (`id' == cropid) 
	}
	keep cell lat lon samecrop*
	tempfile samecrop
	save `samecrop', replace
	restore
	
	* cells have different main crop 
	preserve
	keep cell lat lon maincrop_harea
	duplicates drop
	local N = _N
	forval i = 1/`N' {
		gen diffcrop`i'=0
	}

	encode maincrop_harea, gen(cropid)
	order cropid, after (maincrop_harea)
	
	forval j = 1/`N' {
		local id = cropid[`j']
		qui replace diffcrop`j'= 1 if (`id' != cropid) 
	}
	keep cell lat lon diffcrop*
	tempfile diffcrop
	save `diffcrop', replace
	restore
	
	* cells have the same main ethnic group 
	preserve
	keep cell GroupID1 lat lon
	duplicates drop
	local N = _N
	forval i = 1/`N' {
		gen sameethnic`i'=0
	}

	forval j = 1/`N' {
		local id = GroupID1[`j']
		qui replace sameethnic`j'= 1 if (`id' == GroupID1) 
	}
	keep cell lat lon sameethnic*
	tempfile sameethnic
	save `sameethnic', replace
	restore

	* cells have different main ethnic group 
	preserve
	keep cell GroupID1 lat lon
	duplicates drop
	local N = _N
	forval i = 1/`N' {
		gen diffethnic`i'=0
	}

	forval j = 1/`N' {
		local id = GroupID1[`j']
		qui replace diffethnic`j'= 1 if (`id' != GroupID1) 
	}
	keep cell lat lon diffethnic*
	tempfile diffethnic
	save `diffethnic', replace
	restore

	* neighborhood cells 
	preserve
	keep cell lat lon
	duplicates drop
	spwmatrix gecon lat lon, wn(W_bin_180) wtype(bin)  db(0 180) connect
	svmat W_bin_180
	keep cell lat lon W_bin_180*
	duplicates drop
	tempfile neighbor
	save `neighbor', replace
	restore

	if 1==1 {
		*** generate the spatial weight matrix: neighbors belong to same country
		use `neighbor', clear
		merge 1:1 cell lat lon using `samectry'
		tab _m
		drop _m
		forval j = 1/`N' {
			gen w_`j' = W_bin_180`j' * samectry`j'
		}
		keep w*

		save "${temp}/Wneighborsamectry.dta", replace

		*** generate the spatial weight matrix: neighbors belong to different country
		use `neighbor', clear
		merge 1:1 cell lat lon using `diffctry'
		tab _m
		drop _m
		forval j = 1/`N' {
			gen w_`j' = W_bin_180`j' * diffctry`j'
		}
		keep w*

		save "${temp}/Wneighbordiffctry.dta", replace
	}
	
	if 1==1 {
		*** generate the spatial weight matrix: neighbors have the same main crop
		use `neighbor', clear
		merge 1:1 cell lat lon using `samecrop'
		tab _m
		drop _m
		forval j = 1/`N' {
			gen w_`j' = W_bin_180`j' * samecrop`j'
		}
		keep w*

		save "${temp}/Wneighborsamecrop.dta", replace

		*** generate the spatial weight matrix: neighbors have different main crop
		use `neighbor', clear
		merge 1:1 cell lat lon using `diffcrop'
		tab _m
		drop _m
		forval j = 1/`N' {
			gen w_`j' = W_bin_180`j' * diffcrop`j'
		}
		keep w*

		save "${temp}/Wneighbordiffcrop.dta", replace
	}
	
	if 1==1 {
		*** generate the spatial weight matrix: neighbors have same main ethnic group 
		use `neighbor', clear
		merge 1:1 cell lat lon using `sameethnic'
		tab _m
		drop _m
		forval j = 1/`N' {
			gen w_`j' = W_bin_180`j' * sameethnic`j'
		}
		keep w*

		save "${temp}/Wneighborsamegroup.dta", replace

		*** generate the spatial weight matrix: neighbors have different main ethnic group 
		use `neighbor', clear
		merge 1:1 cell lat lon using `diffethnic'
		tab _m
		drop _m
		forval j = 1/`N' {
			gen w_`j' = W_bin_180`j' * diffethnic`j'
		}
		keep w*

		save "${temp}/Wneighbordiffgroup.dta", replace
	}
	
	if 1==1 {
		*** generate the spatial weight matrix: neighbors belong to same country and have same main ethnic group 
		use `neighbor', clear
		merge 1:1 cell lat lon using `samectry'
		tab _m
		drop _m
		merge 1:1 cell lat lon using `sameethnic'
		tab _m
		drop _m
		forval j = 1/`N' {
			gen w_`j' = W_bin_180`j' * samectry`j' * sameethnic`j' 
		}
		keep w*
		save "${temp}/Wneighborsamectrysamegroup.dta", replace

		*** generate the spatial weight matrix: neighbors belong to same country and have different main ethnic group
		use `neighbor', clear
		merge 1:1 cell lat lon using `samectry'
		tab _m
		drop _m
		merge 1:1 cell lat lon using `diffethnic'
		tab _m
		drop _m
		forval j = 1/`N' {
			gen w_`j' = W_bin_180`j' * samectry`j' * diffethnic`j' 
		}
		keep w*
		save "${temp}/Wneighborsamectrydiffgroup.dta", replace

		*** generate the spatial weight matrix: neighbors belong to different country and have same main ethnic group 
		use `neighbor', clear
		merge 1:1 cell lat lon using `diffctry'
		tab _m
		drop _m
		merge 1:1 cell lat lon using `sameethnic'
		tab _m
		drop _m
		forval j = 1/`N' {
			gen w_`j' = W_bin_180`j' * diffctry`j' * sameethnic`j' 
		}
		keep w*
		save "${temp}/Wneighbordiffctrysamegroup.dta", replace

		*** generate the spatial weight matrix: neighbors belong to different country and have different main ethnic group 
		use `neighbor', clear
		merge 1:1 cell lat lon using `diffctry'
		tab _m
		drop _m
		merge 1:1 cell lat lon using `diffethnic'
		tab _m
		drop _m
		forval j = 1/`N' {
			gen w_`j' = W_bin_180`j' * diffctry`j' * diffethnic`j' 
		}
		keep w*
		save "${temp}/Wneighbordiffctrydiffgroup.dta", replace
	}
	if 1==1 {
		*** generate the spatial weight matrix: neighbors have the same main crop and have same main ethnic group 
		use `neighbor', clear
		merge 1:1 cell lat lon using `samecrop'
		tab _m
		drop _m
		merge 1:1 cell lat lon using `sameethnic'
		tab _m
		drop _m
		forval j = 1/`N' {
			gen w_`j' = W_bin_180`j' * samecrop`j' * sameethnic`j' 
		}
		keep w*
		save "${temp}/Wneighborsamecropsamegroup.dta", replace

		*** generate the spatial weight matrix: neighbors have the same main crop and have different main ethnic group 
		use `neighbor', clear
		merge 1:1 cell lat lon using `samecrop'
		tab _m
		drop _m
		merge 1:1 cell lat lon using `diffethnic'
		tab _m
		drop _m
		forval j = 1/`N' {
			gen w_`j' = W_bin_180`j' * samecrop`j' * diffethnic`j' 
		}
		keep w*
		save "${temp}/Wneighborsamecropdiffgroup.dta", replace

		*** generate the spatial weight matrix: neighbors have the different main crop and have same main ethnic group 
		use `neighbor', clear
		merge 1:1 cell lat lon using `diffcrop'
		tab _m
		drop _m
		merge 1:1 cell lat lon using `sameethnic'
		tab _m
		drop _m
		forval j = 1/`N' {
			gen w_`j' = W_bin_180`j' * diffcrop`j' * sameethnic`j' 
		}
		keep w*
		save "${temp}/Wneighbordiffcropsamegroup.dta", replace

		*** generate the spatial weight matrix: neighbors have the different main crop and have different main ethnic group 
		use `neighbor', clear
		merge 1:1 cell lat lon using `diffcrop'
		tab _m
		drop _m
		merge 1:1 cell lat lon using `diffethnic'
		tab _m
		drop _m
		forval j = 1/`N' {
			gen w_`j' = W_bin_180`j' * diffcrop`j' * diffethnic`j' 
		}
		keep w*
		save "${temp}/Wneighbordiffcropdiffgroup.dta", replace
	}
	
}
end

* Generate matrixes
genmatrix


forval matrixnum = 1/8 {

	di _newline
	di "************** Current regression: `matrixnum' ********************"

	global matrixnum = `matrixnum'

	*===================================================================================================
	* Define Globals
	*===================================================================================================
	if ${matrixnum} == 1 {
		global altmatrix = "neighborsamectry"
	}
	else if ${matrixnum} == 2 {
		global altmatrix = "neighbordiffctry"
	}
	else if ${matrixnum} == 3 {
		global altmatrix = "neighborsamegroup"
	}
	else if ${matrixnum} == 4 {
		global altmatrix = "neighbordiffgroup"
	}
	else if ${matrixnum} == 5 {
		global altmatrix = "neighborsamectrysamegroup"
	}
	else if ${matrixnum} == 6 {
		global altmatrix = "neighborsamectrydiffgroup"
	}
	else if ${matrixnum} == 7 {
		global altmatrix = "neighbordiffctrysamegroup"
	}
	else if ${matrixnum} == 8 {
		global altmatrix = "neighbordiffctrydiffgroup"
	}
	
	global SPEI "SPEI4pg L1_SPEI4pg L2_SPEI4pg GSmain_ext_SPEI4pg L1_GSmain_ext_SPEI4pg L2_GSmain_ext_SPEI4pg"

	*===============================================================================
	* take care of the regressions that variance matrix is nonsymmetric or highly singular
	*===============================================================================
	use "${data}/geoconflict_main.dta", clear

	xtset cell year, yearly
	quie xtbalance , rang(1997 2011) miss(${x} ${SPEI})
	
	* manually fit in the alternative weight matrix
	preserve
		use "${temp}/W$altmatrix.dta", clear
		mkmat w* , mat(W$altmatrix)
	restore

	dis "${altmatrix}"
	
	* benchmark weight matrix: neighbors 180km
	preserve
		keep cell lat lon
		duplicates drop
		spwmatrix gecon lat lon, wn(W_bin_180) wtype(bin)  db(0 180) connect
	restore
	
	* generate country x year FEs
	tab year, gen(yr_)
	foreach x of varlist ctry_* {
	foreach y of varlist yr_* {
		quie gen `x'_x_`y'=`x'*`y'
	}
	}

	* to avoid problems with the ML algorithm, drop singleton vars before regression
	foreach var of varlist ctry_*_x_yr_* {
		count if `var' == 1
		if r(N) == 1{
			dis `var'
			drop `var' 
		}
	}
	
	* use coefficients from non spatial regression as starting values for ML algorithm
	qui reg ANY_EVENT_ACLED ${SPEI} ctry_*_x_yr_*
	matrix b=e(b)
	
	* regression
	xsmle_Sept16 ANY_EVENT_ACLED  ${SPEI} ctry_*_x_yr_*, wmatrix(W$altmatrix ) dmat(W_bin_180) model(sdm) dlag(1) cluster(cell) from(b, skip) fe type(ind) technique(bhhh 5 nr 5 dfp 5 bfgs 5) 
	
	if ${matrixnum} == 1 {
		outreg2 using "${output}/table4.xls",  title() ctitle(W$altmatrix) drop(${x} *ctry* *yr*)   ///
		addtext(Country x Year FE, X, Cell FE, X) nocons label replace	}
	if ${matrixnum} != 1 {
		outreg2 using "${output}/table4.xls",  title() ctitle(W$altmatrix) drop(${x} *ctry* *yr*)   ///
		addtext(Country x Year FE, X, Cell FE, X) nocons label append	}
	
}


cap log close
