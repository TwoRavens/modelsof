********************************************************************************
*                                                                              *
*                           GRAPHICAL ANALYSIS                                 *
*                                                                              *
********************************************************************************

clear all
set matsize 5000
cd "U:\"  // Set directory

// Set options
global trends = 0
global rddfig = 0
global rddfigfirst = 0

// Set key parameters
global dT = 2.5
global c = 7.3


use "NVM_20002014.dta", clear
global house dlogsize drooms dmaintgood dcentralheating dlisted 
global neighbourhood dlogpopdens dshforeign dshyoung dshold dhhsize dluinfr dluind dluopens dluwater
global year dyear*
global fe pc4
global se pc4

if $trends == 1 {

	keep obsid pricesqm daysonmarket percask year inkw winsemius zscore kwexcl

	g price_kw = .
	g price_wins = .
	g price_oth = .

	drop if zscore < 5.3 | zscore > 9.3 | kwexcl == 1

	xi, noomit: regress pricesqm i.year, noconstant, if inkw == 1
		forvalues i = 2000(1)2014 {
			replace price_kw = _b[_Iyear_`i'] if year == `i'
		}
	xi, noomit: regress pricesqm i.year, noconstant, if inkw == 0 & winsemius == 1
		forvalues i = 2000(1)2014 {
			replace price_wins = _b[_Iyear_`i'] if year == `i'
		}
	xi, noomit: regress pricesqm i.year, noconstant, if inkw == 0
		forvalues i = 2000(1)2014 {
			replace price_oth = _b[_Iyear_`i'] if year == `i'
		}

	g days_kw = .
	g days_wins = .
	g days_oth = .
	xi, noomit: regress daysonmarket i.year, noconstant, if inkw == 1
		forvalues i = 2000(1)2014 {
			replace days_kw = _b[_Iyear_`i'] if year == `i'
		}
	xi, noomit: regress daysonmarket i.year, noconstant, if inkw == 0 & winsemius == 1
		forvalues i = 2000(1)2014 {
			replace days_wins = _b[_Iyear_`i'] if year == `i'
		}
	xi, noomit: regress daysonmarket i.year, noconstant, if inkw == 0
		forvalues i = 2000(1)2014 {
			replace days_oth = _b[_Iyear_`i'] if year == `i'
		}

	g percask_kw = .
	g percask_wins = .
	g percask_oth = .
	xi, noomit: regress percask i.year, noconstant, if inkw == 1
		forvalues i = 2000(1)2014 {
			replace percask_kw = _b[_Iyear_`i'] if year == `i'
		}
	xi, noomit: regress percask i.year, noconstant, if inkw == 0 & winsemius == 1
		forvalues i = 2000(1)2014 {
			replace percask_wins = _b[_Iyear_`i'] if year == `i'
		}
	xi, noomit: regress percask i.year, noconstant, if inkw == 0
		forvalues i = 2000(1)2014 {
			replace percask_oth = _b[_Iyear_`i'] if year == `i'
		}

	collapse (mean) price_* days_* percask_*, by(year)
	order year price_* days_* percask_*
	sort year
		

	export excel using "Results\Figures.xlsx", sheet("Fig Select") sheetmodify cell(A3) firstrow(variables)

}

if $rddfig == 1 {
	
	// Define fundamentals
	global vars dlogpricesqm dlogdaysonmarket dlogsize dmaintgood dlogincome dlogpopdens dshforeign dhhsize
	local orderleft = 3
	local orderright = 3
	local step = 0.01
	
		
	keep $vars dkw dscorerule year yearmin inkw $se kwdist zscore pc4 dyear*
		
	g constant = 1
	g dlogpricesqm_pyear = dlogpricesqm/(year-yearmin)
	bysort pc4: egen countpc4 = count(pc4)
	g weightpc4 = 1/countpc4
	
	forvalues i = 1(1)`orderleft' {
		g zscorenscrule_`i' = (zscore-$c )^`i'*(zscore < $c )
		
	}
	forvalues i = 1(1)`orderright' {
		g zscorescrule_`i' = (zscore-$c )^`i'*(zscore >= $c )
	}
	
	local r = 1
	
	foreach var of varlist $vars {
		ivreg2 `var' (dkw=dscorerule) zscorescrule_* zscorenscrule_* constant dyear* [weight=weightpc4],  cluster($se) noconstant, if (inkw == 1 | kwdist > $dT)
		estimates store reg`r'
		local r = `r'+1
	}
	
	
	g zscore_base = .
	g dkw_base = .
	
	foreach var of varlist $vars {
		g `var'_dots = .
	}
	
	local n = 1
		
	forvalues z = -6.6(`step')12.98 {
		
		qui replace zscore_base = `z' in `n'
		qui replace dkw_base = 1*(`z'>=$c) in `n'
		foreach var of varlist $vars {
			qui su `var' [weight=weightpc4] if round(`z',`step') == round(zscore,`step') & (inkw == 1 | kwdist > $dT)
			qui replace `var'_dots = r(mean) in `n'
		}
		local n = `n'+1
	}
	
	
	drop zscore dkw
	rename (zscore_base dkw_base) (zscore dkw)

	forvalues i = 1(1)`orderleft' {
		replace zscorenscrule_`i' = (zscore-$c )^`i'*(zscore < $c )
		
	}
	forvalues i = 1(1)`orderright' {
		replace zscorescrule_`i' = (zscore-$c )^`i'*(zscore >= $c )
	}
	
	forvalues i = 2000(1)2014 {
		replace dyear`i' = 0
	}
	
	local r = 1
	
	foreach var of varlist $vars {
		estimates restore reg`r'
		predict `var'_pred, xb
		predict `var'_se, stdp
		g `var'_predupper = `var'_pred+1.96*`var'_se
		g `var'_predlower = `var'_pred-1.96*`var'_se
		drop `var'_se
		local r = `r'+1
		
		su `var'_dots, meanonly
		local mean1 = r(mean)
		su `var'_pred, meanonly
		local mean2 = r(mean)
		replace `var'_pred = `var'_pred + `mean1' - `mean2'
		replace `var'_predupper = `var'_predupper + `mean1' - `mean2'
		replace `var'_predlower = `var'_predlower + `mean1' - `mean2'
	}

	
	keep zscore dkw dlogpricesqm_* dlogdaysonmarket_* dlogsize_* dmaintgood_* dlogincome_* dlogpopdens_* dshforeign_* dhhsize_*
	order zscore dkw dlogpricesqm_* dlogdaysonmarket_* dlogsize_* dmaintgood_* dlogincome_* dlogpopdens_* dshforeign_* dhhsize_*
	drop if zscore == .
	
	export excel using "Results\Figures.xlsx", sheet("Fig 3+4") sheetmodify cell(A33) firstrow(variables)

}

if $rddfigfirst == 1 {

	// Define fundamentals
	global vars inkw
	local orderleft = 3
	local orderright = 3
	local step = 0.01
	
	keep if year > 2007
	keep inkw zscore scorerule pc4 kwdist
	*collapse (mean) inkw zscore scorerule, by(pc4)
	
	g constant = 1
	bysort pc4: egen countpc4 = count(pc4)
	g weightpc4 = 1/countpc4
	
	forvalues i = 1(1)`orderleft' {
		g zscorenscrule_`i' = (zscore-$c )^`i'*(zscore < $c )
		
	}
	forvalues i = 1(1)`orderright' {
		g zscorescrule_`i' = (zscore-$c )^`i'*(zscore >= $c )
	}
	
	local r = 1
	

	regress inkw scorerule zscorescrule_* zscorenscrule_* constant [weight=weightpc4],  cluster($se) noconstant, //if (inkw == 1 | kwdist > $dT)
	estimates store reg1
	
	estimates restore reg1
	predict kw_pred, xb
	predict kw_se, stdp
	g kw_predupper = kw_pred+1.96*kw_se
	g kw_predlower = kw_pred-1.96*kw_se
	drop kw_se
	
	keep zscore kw_*
	duplicates drop zscore, force
	sort zscore
	
	export excel using "Results\Figures.xlsx", sheet("Fig 2") sheetmodify cell(A9) firstrow(variables)

	
	}
	
