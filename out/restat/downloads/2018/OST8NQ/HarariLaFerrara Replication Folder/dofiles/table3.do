*===============================================================================
* set up
*===============================================================================
clear all
set more off
cap log close
set matsize 11000
set maxvar 32000

*global terminal "put your diretory here"
*global terminal "C:\Users\harari\Dropbox\Geoconflict ReStat revision\2nd revision\Replication\AcceptedVersion"
global terminal "C:\Users\Nina\Dropbox (Personal)\Geoconflict ReStat revision\2nd revision\Replication\AcceptedVersion"

global data "${terminal}/dataset"
global temp "${data}/temp"
global output "${terminal}/output"
global dofiles "${terminal}/dofiles"
global logs "${dofiles}/Logs"

cap mkdir "${output}"
cap mkdir "${logs}"
cap mkdir "${temp}"


*===================================================================================================
* set up
*===================================================================================================
cap log close

global name = "table3"
local cdate : di %tdCCYY.NN.DD date(c(current_date),"DMY")
log using "${logs}/${name}_`cdate'.log", text replace

*===================================================================================================
* Define Globals
*===================================================================================================
foreach znum in 1 2 3 4 5 {

if `znum' == 1 {
	global zvar = "road"
}
else if `znum' == 2 {
	global zvar = "tax_gdp"
}
else if `znum' == 3 {
	global zvar = "polity2"
}
else if `znum' == 4 {
	global zvar = "discrimnr"
}
else if `znum' == 5 {
	global zvar = "partition"
}

global x "elevation_cell rough_cell area_cell use_primary dis_river_cell shared border any_mineral ELF"
global SPEI "SPEI4pg L1_SPEI4pg L2_SPEI4pg GSmain L1_GSmain L2_GSmain"
global SPEI_x_z "GSmain_x_${zvar} L1_GSmain_x_${zvar} L2_GSmain_x_${zvar}" 

*===============================================================================
* regression (with cell FE)
*===============================================================================

use "${data}/geoconflict_main.dta", clear

gen road=use_primary
renvars  *GSmain_ext_SPEI4pg*, subst (GSmain_ext_SPEI4pg GSmain) 
* name too long to generate interaction terms

xtset cell year, yearly

* generate country x year FEs
tab year, gen(yr_)
foreach x of varlist ctry_* {
foreach y of varlist yr_* {
	quie gen `x'_x_`y'=`x'*`y'
}
}

if "${zvar}" == "tax_gdp" {
	preserve
	qui keep year tax_gdp 
	keep if tax_gdp !=.
	sum year
	local maxyear = r(max)
	sum year
	local minyear = r(min)
	restore
	foreach var of varlist GSmain L1_GSmain L2_GSmain {
		gen `var'_x_${zvar} = `var' * ${zvar}
	}
	quie xtbalance , rang(`minyear' `maxyear') miss( ${SPEI} ${SPEI_x_z})
}
else {
	foreach var of varlist GSmain L1_GSmain L2_GSmain {
		gen `var'_x_${zvar} = `var' * ${zvar}
	}
	quie xtbalance , rang(1997 2011) miss( ${SPEI} ${SPEI_x_z})
}

* generate weight matrix 
dis "weight matrix"
preserve
	keep cell lat lon
	duplicates drop
	spwmatrix gecon lat lon, wn(W_bin_180) wtype(bin)  db(0 180) connect
restore

* cell FE regression
qui reg ANY_EVENT_ACLED ${SPEI} ${SPEI_x_z} ctry_*_x_yr*
matrix b=e(b)
xsmle_Sept16 ANY_EVENT_ACLED  ${SPEI} ${SPEI_x_z} ctry_*_x_yr*, wmatrix(W_bin_180) dlag(1) model(sdm) cluster(cell) from(b, skip)  fe type(ind) technique(bhhh 5 nr 5 dfp 5 bfgs 5) 

if `znum' == 1 {
outreg2 using "${output}/table3.xls", title () ctitle ("${zvar}") drop(*ctry* *yr*)  ///
addtext(Country x Year FE, X, Cell FE, X) nocons label replace
}

if `znum' != 1 {
outreg2 using "${output}/table3.xls", title () ctitle ("${zvar}") drop(*ctry* *yr*)  ///
addtext(Country x Year FE, X, Cell FE, X) nocons label append
}

}

cap log close
