***** wisconsin_school_covars_1miles

clear *
set more off

* For schools with with multiple locations, uses mean lat/long. Change mean_lat and mean_lon back to g_lat and
* g_lon to swith back to doing locations separately

global data "H:/Milwaukee Vouchers/Data"

// Open WI tracts
use "$data/ustracts2000.dta", clear
keep if postal=="WI"
tempfile tracts2000
save `tracts2000'

use "$data/ustracts2010.dta", clear
keep if postal=="WI"
tempfile tracts2010
save `tracts2010'

// Open covars
foreach year in 2000 2009 2010 2011 2012 2013 {
	use "$data/wisconsin_tract_covars.dta", clear
	keep if year==`year'
	tempfile covars`year'
	save `covars`year''
}

// Mean covariates for tracts within two miles
use "$data/wisconsin_school_parish_locations.dta", clear
drop if address=="" | name==""
sort type name
gen idnum = _n
tempfile temp
save `temp'

foreach year in 2000 2009 2010 2011 2012 2013 {
	use `temp', clear
	if `year'<=2009 {
		geonear id mean_lat mean_lon using `tracts2000', n(id latitude longitude) long within(1) miles
		tempfile near`year'
		save `near`year''
	}
	if `year'>=2010 {
		geonear id mean_lat mean_lon using `tracts2010', n(id latitude longitude) long within(1) miles
		tempfile near`year'
		save `near`year''
	}
	
	use `temp', clear
	merge 1:m idnum using `near`year''
	drop _merge

	rename id id2
	merge m:1 id2 using `covars`year''
	keep if _merge==3
	drop _merge
	
	gen within1 = mi_to_id
	replace within1 = . if mi_to_id>1

	collapse (mean) share* lfpr ur medhhinc medfaminc povrate* educ* nevmarried married separated widowed divorced native foreign* lah_* (count) nclose1 = mi_to_id within1 [aw=pop_all], by(idnum year)
	tempfile means`year'
	save `means`year''
}

clear
foreach year in 2000 2009 2010 2011 2012 2013 {
	append using `means`year''
}

merge m:1 idnum using `temp'
drop _merge

order type name code idnum year
sort  type name year

saveold "$data/wisconsin_school_covars_1miles.dta", replace





***** wisconsin_school_covars_2miles

clear *
set more off

* For schools with with multiple locations, uses mean lat/long. Change mean_lat and mean_lon back to g_lat and
* g_lon to swith back to doing locations separately

global data "H:/Milwaukee Vouchers/Data"

// Open WI tracts
use "$data/ustracts2000.dta", clear
keep if postal=="WI"
tempfile tracts2000
save `tracts2000'

use "$data/ustracts2010.dta", clear
keep if postal=="WI"
tempfile tracts2010
save `tracts2010'

// Open covars
foreach year in 2000 2009 2010 2011 2012 2013 {
	use "$data/wisconsin_tract_covars.dta", clear
	keep if year==`year'
	tempfile covars`year'
	save `covars`year''
}

// Mean covariates for tracts within two miles
use "$data/wisconsin_school_parish_locations.dta", clear
drop if address=="" | name==""
sort type name
gen idnum = _n
tempfile temp
save `temp'

foreach year in 2000 2009 2010 2011 2012 2013 {
	use `temp', clear
	if `year'<=2009 {
		geonear id mean_lat mean_lon using `tracts2000', n(id latitude longitude) long within(2) miles
		tempfile near`year'
		save `near`year''
	}
	if `year'>=2010 {
		geonear id mean_lat mean_lon using `tracts2010', n(id latitude longitude) long within(2) miles
		tempfile near`year'
		save `near`year''
	}
	
	use `temp', clear
	merge 1:m idnum using `near`year''
	drop _merge

	rename id id2
	merge m:1 id2 using `covars`year''
	keep if _merge==3
	drop _merge
	
	gen within2 = mi_to_id
	replace within2 = . if mi_to_id>2

	collapse (mean) share* lfpr ur medhhinc medfaminc povrate* educ* nevmarried married separated widowed divorced native foreign* lah_* (count) nclose2 = mi_to_id within2 [aw=pop_all], by(idnum year)
	tempfile means`year'
	save `means`year''
}

clear
foreach year in 2000 2009 2010 2011 2012 2013 {
	append using `means`year''
}

merge m:1 idnum using `temp'
drop _merge

order type name code idnum year
sort  type name year

saveold "$data/wisconsin_school_covars_2miles.dta", replace





***** wisconsin_school_covars_3miles

clear *
set more off

* For schools with with multiple locations, uses mean lat/long. Change mean_lat and mean_lon back to g_lat and
* g_lon to swith back to doing locations separately

global data "H:/Milwaukee Vouchers/Data"

// Open WI tracts
use "$data/ustracts2000.dta", clear
keep if postal=="WI"
tempfile tracts2000
save `tracts2000'

use "$data/ustracts2010.dta", clear
keep if postal=="WI"
tempfile tracts2010
save `tracts2010'

// Open covars
foreach year in 2000 2009 2010 2011 2012 2013 {
	use "$data/wisconsin_tract_covars.dta", clear
	keep if year==`year'
	tempfile covars`year'
	save `covars`year''
}

// Mean covariates for tracts within two miles
use "$data/wisconsin_school_parish_locations.dta", clear
drop if address=="" | name==""
sort type name
gen idnum = _n
tempfile temp
save `temp'

foreach year in 2000 2009 2010 2011 2012 2013 {
	use `temp', clear
	if `year'<=2009 {
		geonear id mean_lat mean_lon using `tracts2000', n(id latitude longitude) long within(3) miles
		tempfile near`year'
		save `near`year''
	}
	if `year'>=2010 {
		geonear id mean_lat mean_lon using `tracts2010', n(id latitude longitude) long within(3) miles
		tempfile near`year'
		save `near`year''
	}
	
	use `temp', clear
	merge 1:m idnum using `near`year''
	drop _merge

	rename id id2
	merge m:1 id2 using `covars`year''
	keep if _merge==3
	drop _merge
	
	gen within3 = mi_to_id
	replace within3 = . if mi_to_id>3

	collapse (mean) share* lfpr ur medhhinc medfaminc povrate* educ* nevmarried married separated widowed divorced native foreign* lah_* (count) nclose3 = mi_to_id within3 [aw=pop_all], by(idnum year)
	tempfile means`year'
	save `means`year''
}

clear
foreach year in 2000 2009 2010 2011 2012 2013 {
	append using `means`year''
}

merge m:1 idnum using `temp'
drop _merge

order type name code idnum year
sort  type name year

saveold "$data/wisconsin_school_covars_3miles.dta", replace





***** wisconsin_school_fpl_1miles_faminc_famtype

clear *
set more off

* For schools with with multiple locations, uses mean lat/long. Change mean_lat and mean_lon back to g_lat and
* g_lon to swith back to doing locations separately

global data "H:/Milwaukee Vouchers/Data"

// Open WI tracts
use "$data/ustracts2000.dta", clear
keep if postal=="WI"
tempfile tracts2000
save `tracts2000'

use "$data/ustracts2010.dta", clear
keep if postal=="WI"
tempfile tracts2010
save `tracts2010'

// Open FPL shares (using family income among families with children)
foreach year in 2000 2009 2010 2011 2012 2013 {
	use "$data/wisconsin_tract_fpl_shares_faminc_famtype.dta", clear
	keep if year==`year'
	tempfile covars`year'
	save `covars`year''
}

// Mean covariates for tracts within two miles
use "$data/wisconsin_school_parish_locations.dta", clear
drop if address=="" | name==""
sort type name
gen idnum = _n
tempfile temp
save `temp'

foreach year in 2000 2009 2010 2011 2012 2013 {
	use `temp', clear
	if `year'<=2009 {
		geonear id mean_lat mean_lon using `tracts2000', n(id latitude longitude) long within(1) miles
		tempfile near`year'
		save `near`year''
	}
	if `year'>=2010 {
		geonear id mean_lat mean_lon using `tracts2010', n(id latitude longitude) long within(1) miles
		tempfile near`year'
		save `near`year''
	}
	
	use `temp', clear
	merge 1:m idnum using `near`year''
	drop _merge

	rename id id2
	merge m:1 id2 using `covars`year''
	keep if _merge==3
	drop _merge

	collapse (mean) *share (rawsum) fpl*count famcount [fw=famcount], by(idnum year)
	tempfile means`year'
	save `means`year''
}

clear
foreach year in 2000 2009 2010 2011 2012 2013 {
	append using `means`year''
}

merge m:1 idnum using `temp'
drop _merge

order type name code idnum year
sort  type name year

saveold "$data/wisconsin_school_fpl_1miles_faminc_famtype.dta", replace





***** wisconsin_school_fpl_2miles_faminc_famtype

clear *
set more off

* For schools with with multiple locations, uses mean lat/long. Change mean_lat and mean_lon back to g_lat and
* g_lon to swith back to doing locations separately

global data "H:/Milwaukee Vouchers/Data"

// Open WI tracts
use "$data/ustracts2000.dta", clear
keep if postal=="WI"
tempfile tracts2000
save `tracts2000'

use "$data/ustracts2010.dta", clear
keep if postal=="WI"
tempfile tracts2010
save `tracts2010'

// Open FPL shares (using family income among families with children)
foreach year in 2000 2009 2010 2011 2012 2013 {
	use "$data/wisconsin_tract_fpl_shares_faminc_famtype.dta", clear
	keep if year==`year'
	tempfile covars`year'
	save `covars`year''
}

// Mean covariates for tracts within two miles
use "$data/wisconsin_school_parish_locations.dta", clear
drop if address=="" | name==""
sort type name
gen idnum = _n
tempfile temp
save `temp'

foreach year in 2000 2009 2010 2011 2012 2013 {
	use `temp', clear
	if `year'<=2009 {
		geonear id mean_lat mean_lon using `tracts2000', n(id latitude longitude) long within(2) miles
		tempfile near`year'
		save `near`year''
	}
	if `year'>=2010 {
		geonear id mean_lat mean_lon using `tracts2010', n(id latitude longitude) long within(2) miles
		tempfile near`year'
		save `near`year''
	}
	
	use `temp', clear
	merge 1:m idnum using `near`year''
	drop _merge

	rename id id2
	merge m:1 id2 using `covars`year''
	keep if _merge==3
	drop _merge

	collapse (mean) *share (rawsum) fpl*count famcount [fw=famcount], by(idnum year)
	tempfile means`year'
	save `means`year''
}

clear
foreach year in 2000 2009 2010 2011 2012 2013 {
	append using `means`year''
}

merge m:1 idnum using `temp'
drop _merge

order type name code idnum year
sort  type name year

save "$data/wisconsin_school_fpl_2miles_faminc_famtype.dta", replace





***** wisconsin_school_fpl_3miles_faminc_famtype

clear *
set more off

* For schools with with multiple locations, uses mean lat/long. Change mean_lat and mean_lon back to g_lat and
* g_lon to swith back to doing locations separately

global data "H:/Milwaukee Vouchers/Data"

// Open WI tracts
use "$data/ustracts2000.dta", clear
keep if postal=="WI"
tempfile tracts2000
save `tracts2000'

use "$data/ustracts2010.dta", clear
keep if postal=="WI"
tempfile tracts2010
save `tracts2010'

// Open FPL shares (using family income among families with children)
foreach year in 2000 2009 2010 2011 2012 2013 {
	use "$data/wisconsin_tract_fpl_shares_faminc_famtype.dta", clear
	keep if year==`year'
	tempfile covars`year'
	save `covars`year''
}

// Mean covariates for tracts within two miles
use "$data/wisconsin_school_parish_locations.dta", clear
drop if address=="" | name==""
sort type name
gen idnum = _n
tempfile temp
save `temp'

foreach year in 2000 2009 2010 2011 2012 2013 {
	use `temp', clear
	if `year'<=2009 {
		geonear id mean_lat mean_lon using `tracts2000', n(id latitude longitude) long within(3) miles
		tempfile near`year'
		save `near`year''
	}
	if `year'>=2010 {
		geonear id mean_lat mean_lon using `tracts2010', n(id latitude longitude) long within(3) miles
		tempfile near`year'
		save `near`year''
	}
	
	use `temp', clear
	merge 1:m idnum using `near`year''
	drop _merge

	rename id id2
	merge m:1 id2 using `covars`year''
	keep if _merge==3
	drop _merge

	collapse (mean) *share (rawsum) fpl*count famcount [fw=famcount], by(idnum year)
	tempfile means`year'
	save `means`year''
}

clear
foreach year in 2000 2009 2010 2011 2012 2013 {
	append using `means`year''
}

merge m:1 idnum using `temp'
drop _merge

order type name code idnum year
sort  type name year

saveold "$data/wisconsin_school_fpl_3miles_faminc_famtype.dta", replace





***** Interpolate

clear *
set more off

global data "H:/Milwaukee Vouchers/Data"

foreach file in covars_1miles fpl_1miles_faminc_famtype covars_2miles fpl_2miles_faminc_famtype covars_3miles fpl_3miles_faminc_famtype {
	use "$data/wisconsin_school_`file'.dta", clear
	keep type name code idnum street city state zip parish note G address g_lat g_lon mean_lat mean_lon
	duplicates drop
	expand 14
	sort idnum
	bys idnum: gen year = 1999 + _n
	order type name code idnum year

	merge 1:1 idnum year using "$data/wisconsin_school_`file'.dta"
	drop name address g_status _merge

	qui ds
	local allvars = r(varlist)
	local exclude type name code idnum year street city state zip parish note G address g_lat g_lon mean_lat mean_lon
	local vars: list allvars - exclude
	disp "`vars'"

	foreach var in `vars' {
		by idnum: ipolate `var' year, generate(i_`var')
	}
	drop `vars'
	saveold "$data/wisconsin_school_`file'_interp.dta", replace
}
