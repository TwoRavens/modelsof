** Run under Stata 14.

/*	Svolik (2015)'s already in discrete-time format.  Just need to fill in
	the ND periods and convert to stages.

*/
***************************************************************************
// Preload the state data, to figure out where to fill and where to drop.

* merge in the independence dates for the ccodes
tempfile statesYr

* ccodeYr, to get the right years.  (can get specific months from there)
use "system, v0 (original).dta", clear
save `statesYr', replace
	
*************************************************************************	
// Load the Svolik dataset file.
	
use "dem_cov_small 3, vichy, std.dta", clear		// fewer missing obsvs.

gen orig = 1


//PAK goes from ccode==769 to ccode==770  The time periods don't overlap at all, for the two ccode panels.
	* force PAK update for merge.
	recode ccode (769=770)	
	

// Gen the stage variables
	* 1 = democratic
	* 2 = exog
	* 3 = endog
	* 4 = other (see p. 730, 2nd para)
			
	gen stage = 1 if(y==0 & y_coup==0 & y_inc==0)
		replace stage = 2 if(y_coup==1)	// the exogenous
		replace stage = 3 if(y_inc==1)	// the endogenous
		replace stage = 4 if(y==1 & y_inc==0 & y_coup==0)		// the others 		

	
// Fill.

	// tsset and fill.
	tsset ccode year
	preserve
		tempfile names
		duplicates drop ccode, force
		keep cname ccode
		save `names', replace
	restore
	
	qui levelsof ccode, local(ccs)
	
	foreach c of local ccs{
		qui cap tsappend, last(2007) tsfmt(float) panel(`c')	// add in a 2007 observation, for all the states.
	}
	
	tsfill
	recode orig (.=0)
	
	** MERGE IN THE NAMES AND STUFF FOR THE FILLS
		merge ccode using `names', uniqusing sort update keep(cname)
		tab _merge
		drop _merge
	
		
		
// Start figuring out the proper observations to add/drop, given the fills	
id ccode year, gen(ccodeYr)
merge ccodeYr using `statesYr', uniqusing sort nokeep keep(exists)
recode exists (.=0)
tab _merge
tab ccode if(_merge==1)				// which countries don't have obsvs, in general
tab ccode if(_merge==1 & orig==0)	// which of the *filled* obsvs don't have dates.  This should be colonial observations (or countries that otherwise stopped existing) only.  E.g.) France doesn't exist in 1943.  Neither does unified Germany, from 1946-1989.
drop _merge	
	
keep if(orig==1 | (orig==0 & exists==1))


	// manually modify Germany 255 1990 here, so that the start time in the continuous dataset will be right
	replace stage = 1 if(ccode==255 & year==1990)
	replace y = 0 if(ccode==255 & year==1990)
	

	
// Fill in the stages variable.
rename y demend

gen endmode = 0
	recode endmode (0=1) if(y_coup==1)
	recode endmode (0=2) if(y_inc==1)

// the new bit, to deal with France (and the other similar cases) [20OCT15]
bysort ccode (year): gen stRes = (year!=(L1.year+1)) & !(_n==1)	

	
bysort ccode (year): gen panelC = sum((demend!=0 & demend!=.) | stRes!=0)	// create new mini-panels for fill
bysort ccode panelC (year): egen maxS = max(stage)
replace stage = maxS if(stage==. & orig==0)

replace stage = 5 if(orig==0 & stage==1)

drop maxS panelC

sort ccode year
replace stage = L1.stage if(demend==1 & L1.demend==0)	// fix the stage fills, now.  so for the first spell in particular, 
order stage, after(year)	


// Create a new, more sound mini-panel counter.
sort ccode year
bysort ccode (year): genD transition = 1 if((F1.stage!=stage & F1.year==year+1 & stage!=5) | ///
											(demend==1))	, dummy		

bysort ccode (year): genD transFake = 1 if(L1.stage!=stage | L1.demend==1), dummy		
bysort ccode (year): gen panelC = sum(transFake)
drop transFake
order panelC, first
order transition, after(stage)




// Gen stage duration
gen temp = 1
bysort ccode panelC (year): egenD stageDuration = total(temp), label(Time in stage, in years)
order stageDuration, after(transition)

// t0 gen	
	bysort ccode panelC (year): egen t0 = min(T) //because the clock needs to start at 0
	replace t0 = t0-1
	bysort ccode panelC (year): egen t = max(T) // shouldn't need to add anything, because with the panelC in the bysort, it returns the correct value (e.g., 9 for Haiti's first reversion in 1991m8, instead of 10)
		bysort ccode panelC (year): egen temp22 = max(stageDur) // you *do* need to do the fills for the newly added stages.
		replace t = temp22 if(stage!=1)
	order t0 t, after(transition)
	
		// NOTE: t0 isn't completely right--easier to fix after everything's collapsed


// Lags
sort ccode year
gen temp123 = L1.year
id ccode temp123, gen(ccodeYrL)
drop temp123

clonevar mergeYear = year


// merge in start/end year from full dataset
preserve
	tempfile full
	use "dem_cov, full, std.dta", clear	
	id ccode year, gen(ccodeYr)
	save `full', replace
restore

merge ccodeYr using `full', unique sort nokeep keep(start_year end_year)
tab _merge
drop _m

	// fill in start/ends, when constant within panel
	foreach x of varlist start_year end_year{
		bysort ccode (year): egen `x'min = min(`x')
		bysort ccode (year): egen `x'max = max(`x')
		replace `x' = `x'min if(`x'min==`x'max)
		drop `x'min `x'max
	}

// ---  Save the discrete time version ---
	
drop temp	
compress
saveold "1 - svolik 2015 - discrete.dta", replace version(11)

// DONE.  Switch
