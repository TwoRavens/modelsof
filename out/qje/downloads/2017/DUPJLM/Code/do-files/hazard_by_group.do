*******************************
*! original file:
*******************************

*! Author: Johannes Schmieder
*! August 2011
*! Test Program to Create Regression Adjusted Hazard Figures

*******************************
*! modifications made by Balazs Reizer
*******************************

*! 1 instead simulated data it works now with oursample.dta
*! 2. I included censoration a simple but dirty way. 


/*---------------------------------------------------------*/
/* Hazard Figure by Groups - Regression Adjusted */
/*---------------------------------------------------------*/
capture program drop hazard_by_group
program define hazard_by_group
	syntax varlist, [ byvar(str) survivor(str) inclcens(integer 1) controls(varlist) censorvar(varname) ///
		title(str) subtitle(passthru) ytitle(passthru) weekly maxdur(integer 1) ///
		yscale(passthru) ylabel(passthru) xlines(str) NOLEGEND scale(integer 1)  ///
		 savefile(str) *  ]
	// ===== Parameters =====		
local line1 "lpatter(solid) msymbol(S)"
local line2 "lpattern(shortdash) msymbol(O)" 
*set trace off
	local durvar `varlist'
	local depvar hazard
	
	tempfile filename
	
 	preserve

	local noci noci
	
	qui tab `byvar' 
	local N_unique = r(r)
	
	qui tab `byvar', gen(__dby2_)
	local twogroups = `N_unique'==2
	
	forvalues i =1/`N_unique' {
		local byvardum `byvardum' __dby2_`i'
		local sebyvardum `sebyvardum' _se___dby2_`i'

		local Ngroups `Ngroups' N`i'	

		local catlabel : variable label __dby2_`i'
		local catlabel = subinstr("`catlabel'","`byvar'==","",.)

		qui sum `N' if __dby2_`i'==1
		local max = r(max)
		local notes "`notes' "Number of obs, `catlabel':    `max'""
	
		if "`noci'"!="" {
			local graphs `graphs' ///
				(connected `v' __dby2_`i' dur ,  lpattern("#") `line`i'') 
			local legendlabel `legendlabel' label(`i' "`catlabel'")
			local order `order' `i'
		}
		else {
			local graphs `graphs' ///
				(connected `v'hi __dby2_`i' , lpattern(shortdash) color(`col'*.6) msymbol(none) )  ///
				(connected `v'lo __dby2_`i' , lpattern(shortdash) color(`col'*.6) msymbol(none) )  ///
				(connected `v'   __dby2_`i' , lpattern("#") `msymbol' color(`col') )
			local legendlabel `legendlabel' label(`=`i'*3' "`catlabel'")
			local order `order' `=`i'*3'
		}
	
		gettoken col colors:colors
	}
	
			
	if 1 {
		// ===== Prep Data =====
		if "`weekly'"=="weekly" {
			replace `durvar' = `durvar'
		}
		if "`bimonthly'"=="bimonthly" {
			replace `durvar' = (`durvar'*30)/60
		}
			
		count 
		local N = r(N)
		
		tempfile cells
		save `cells'
	
		// ========= Loop over different Different Bandwidths =========
		eststo clear
		local i 1

		tempname p
		postfile `p' N dur pval `byvardum' `sebyvardum' `Ngroups'  using `filename', replace
		
		quietly if `maxdur'==1 {
				local maxdur 36
		}
		disp `maxdur'
		if "`weekly'"=="weekly" {
			if `maxdur'==1 {
				local maxdur 36
			}
		}
		if "`bimonthly'"=="bimonthly" {
			local maxdur 13
		}

		foreach dur of numlist  1(1)`maxdur' {
		
			use `cells', clear
			tempvar lhs
			if `inclcens'==0 drop if `durvar'>=.
			*different demaning needed in every period!
			if "`controls'"!="" foreach var of varlist `controls' {
				qui sum `var' if `durvar'>=`dur'
				quietly replace `var' = `var' - r(mean) 
			}		

		if "`survivor'"=="" {
			
			 if "`censorvar'"=="" {
					g `lhs' =  inrange(floor(`durvar'),`dur',`dur')  if `durvar'>=`dur'		
				}
				else {
					// LHS should be 1 if not censored and spell ends in month t, 
					// LHS should be 0 if censored or spell does not end in t
					// LHS should be missing if observation is not at risk anymore (duration shorter than t, censored or not)
					g `lhs' =  inrange(floor(`durvar'),`dur',`dur') & (`censorvar'==1) if `durvar'>=`dur'				
				}	
			}
		else if "`survivor'"=="1" {
			tempvar lhs
			g `lhs' =  `durvar'>=`dur' 
		}
		
		else if "`survivor'"=="prob" {
			tempvar lhs
			g `lhs' =  `durvar'==`dur' 
			}
	

	
			local tit : variable label `durvar'
			if "`tit'"=="" local tit `durvar'
			if `inclcens' local tit `tit' including censored spells
			else local tit `tit' excluding censored spells
			// g bins = 0
			local if 1
			local poststr1
			local poststr2
			
			qui eststo :  reg `lhs' `byvardum' `controls' if `if', noconstant 
			
			local pval .
			if `twogroups' == 1 {
				test __dby2_1==__dby2_2 
				local pval = r(p)
			}
	
			local Nobs
	
			foreach var in `byvardum' {
				local `var' = _b[`var']
				local _se_`var' = _se[`var']
				local poststr1 `poststr1' (``var'') 
				local poststr2 `poststr2' (`_se_`var'')
				count if e(sample) & `var'==1
				local Nobs `Nobs' (`=r(N)')
			}
			
			local obs =e(N) 
			post `p' (`obs') (`dur') (`pval')  `poststr1' `poststr2' `Nobs'	
			
			local i = `i'+1
			drop `lhs'
		}

		eststo clear				
		postclose `p'
	}
		
	use `filename', clear
	
	replace dur = dur*`scale'

	
	local xtitle xtitle("Duration in Months")
	if "`weekly'"=="weekly" {
		local xtitle xtitle("Number of days since UI claim")
	}
	
	if "`xlines'"!="" local xline xline(`xlines', lpattern(dash) lwidth(*.6) lcolor(gs10))
	
	local statsig  
	if `twogroups' local statsig (rcap __dby2_1 __dby2_2 dur if pval<.05 & __dby2_1<=__dby2_2, lcolor(red) lwi(*1.9)) ///
			(rcap __dby2_1 __dby2_2 dur if pval<.05 & __dby2_1>__dby2_2 , lcolor(green) lwi(*1.9) lpa(dash)) 

	if "`nolegend'"=="" local legendlabel legend( `legendlabel' col(3))
	else local legendlabel legend(off)

	if "`survivor'"=="" | "`survivor'"=="prob" { 
		local yscale="yscale(range(0 0.08)) ylabel(0 (0.01) 0.08)"
		local title title("Hazard by Duration") 
	}
	else /* "`survivor'"=="1" */ {
		local yscale="ylabel(0.2 (0.2) 1) "
		local title title("Survivor by Duration") 
	}


	
	twoway `graphs' ///  
		`statsig' ///
		, scheme(s2color) graphr(color(white))  scale(.8) ysize(7) xsize(10) ///
		`title' `subtitle' ///
		`ytitle' `xtitle' ///
		`legendlabel' /// 
		legend(note("Samplesize: `N'")) ///
		legend(region(color(none) margin(zero)) order(`order')) ///
		`xline'    `ylabel' `yscale' `options'  ///

	cap noi {
		g wsum = __dby2_1* N1/N + __dby2_2*N2/N
		label var wsum "Weighted Sum of Hazard Rates of two groups"
	}
     
	if "`savefile'"!="" save "./`savefile'.dta", replace


 	restore
		
end 

