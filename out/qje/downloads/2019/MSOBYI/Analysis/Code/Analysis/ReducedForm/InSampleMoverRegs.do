/* InSampleMoverRegs.do */
* This file correlates moves with effects in the Homescan data
* Do not weight by projection factor. This significantly reduces precision, and these samples are not representative anyway.	
* Note: with two-way clustering, reghdfe gives the note that "VCV matrix was non-positive semi-definite; adjustment from Cameron, Gelbach & Miller applied." In practice, just clustering by household_code gives slightly tighter standard errors than two-way clustering by household_code and geoname, so the estimates seem reasonable in that sense. 
* reghdfe gives the same coefficients as areg and approx 10% smaller standard errors with one-way clustering.


/* SETUP */
global Fig = "Output/ReducedForm/Figures" 
global YVarList =  "$HealthVar ShareCoke" // Produce g_prot_per1000Cal g_fiber_per1000Cal g_fat_sat_per1000Cal g_sugar_per1000Cal g_sodium_per1000Cal g_cholest_per1000Cal"
global sList = "U C" // T
global AreaTypeList = "Ct Z"

/* FIGURES */
/* Event study figures*/
foreach Freq in Year { // Quarter Year
	if "`Freq'" == "Year" { 
		global WindowList = "102 300 103"
		local tvar = "panel_year"
	}
	if "`Freq'" == "Quarter" {
		global WindowList = "408 812"
		local tvar = "YQ"
	}
	foreach window in $WindowList {
		local prewindow = real(substr("`window'",1,1))
		local postwindow = real(substr("`window'",2,2))
		
		
		*** Loop over areatypes and dependent variables.
		foreach areatype in $AreaTypeList {	
		*** Figure: share of purchases in new vs. old county over time, for people who move between areatypes
			use household_code `tvar' Balanced`window'_`areatype' Post`areatype'Move`window't ///
				using $Externals/Calculations/Homescan/HHx`Freq'withInSampleMovers.dta, replace, if Balanced`window'_`areatype'==1
			merge 1:1 household_code `tvar' using $Externals/Calculations/Homescan/TripShares_Ct_`Freq'.dta, keep(match master) ///
				keepusing(TripShareInCt_* TripCountWithCt) nogen

			gen SharePreMove = TripShareInCt_10 if Post`areatype'Move`window't<10
			forvalues l = 0/`postwindow' {
				local 9minusl = 9-`l'
				replace SharePreMove = TripShareInCt_`9minusl' if Post`areatype'Move`window't==10+`l'
			}
			gen SharePostMove = TripShareInCt_10 if Post`areatype'Move`window't>=10
			forvalues l = 1/`prewindow' {
				local 10plusl = 10+`l'
				replace SharePostMove = TripShareInCt_`10plusl' if Post`areatype'Move`window't==10-`l'
			}
			
			** Collapse across households, weighting by number of trips to RMS stores
			collapse (rawsum) TripCountWithCt (mean) SharePreMove SharePostMove [pw=TripCountWithCt], by(Post`areatype'Move`window't)
			gen `Freq'sAfter = Post`areatype'Move`window't-10
			
			** Draw figure
			twoway connect SharePreMove SharePostMove `Freq'sAfter, ///
				lp(dash l) m(O S) ///
				graphregion(color(white)) ///
				title("Trips in New vs. Old County") ///
				ytitle("Share of trips") ///
				xtitle("`Freq's after move") ///
				xline(0,lp(dash) lw(thin) lc(maroon)) ///
				legend(label(1 "Old county") label(2 "New county"))
			graph save $Fig/`areatype'`window'MoverTripShares, replace // Save gph file to be combined below
			
			
			
			foreach YVar in $YVarList {
				local outcome = "`YVar'"
				include Code/Analysis/StylizedFacts/FigureTitles.do
				local YVarSub = substr("`YVar'",1,13)
				
				*** Figure: distribution of destination - origin differences in outcomes 
				use Post`areatype'Move`window't D`areatype'`window'`YVar' ///
					using $Externals/Calculations/Homescan/HHx`Freq'withInSampleMovers.dta, replace, if Post`areatype'Move`window't==10
				hist D`areatype'`window'`YVar', graphregion(color(white)) ///
					title("Distribution of New-Old Differences") ///
					xtitle("Difference in `ytitle'")
				
				graph save $Fig/InSampleMovesD`window'`areatype'`YVar', replace // Save gph file to be combined below
				

				*** Figure: Event study
				use $Externals/Calculations/Homescan/HHx`Freq'withInSampleMovers.dta, replace
				include Code/DataPrep/DefineGeonames.do

			
				** Unconditional	
					* Comment out reghdfe because I cannot specify the base level, so the figures become wrong. 
						* This sacrifices the two-way clustering, but the standard errors are almost exactly the same, and in any event the areg standard errors are larger than the reghdfe standard errors for the same estimates, so this should actually be conservative!
				/*
				reghdfe `YVar' c.Balanced`window'_`areatype'#(ib9.Post`areatype'Move`window't#c.D`areatype'`window'`YVar' ///
					i.Post`areatype'Move`window't c.D`areatype'`window'`YVar'), ///
					absorb(household_code panel_year) vce(cluster household_code `geoname')
				*/
				reg `YVar' c.Balanced`window'_`areatype'#(ib9.Post`areatype'Move`window't#c.D`areatype'`window'`YVar' ///
					i.Post`areatype'Move`window't c.D`areatype'`window'`YVar') ///
					i.panel_year, ///
					robust cluster(household_code)
					
				est store U`window'`areatype'`YVarSub'
				
				** Conditional on controls
				/*
				reghdfe `YVar' c.Balanced`window'_`areatype'#(ib9.Post`areatype'Move`window't#c.D`areatype'`window'`YVar' ///
					i.Post`areatype'Move`window't c.D`areatype'`window'`YVar') $Ctls, ///
					absorb(household_code panel_year) vce(cluster household_code `geoname')
				*/
				areg `YVar' c.Balanced`window'_`areatype'#(ib9.Post`areatype'Move`window't#c.D`areatype'`window'`YVar' ///
					i.Post`areatype'Move`window't c.D`areatype'`window'`YVar') ///
					i.panel_year $Ctls, ///
					robust cluster(household_code) absorb(household_code)
				
				est store C`window'`areatype'`YVarSub'

			}
			
			*** Income placebo test with $HealthVar as the RHS var
			/*
			reghdfe lnIncome c.Balanced`window'_`areatype'#(ib9.Post`areatype'Move`window't#c.D`areatype'`window'$HealthVar ///
				i.Post`areatype'Move`window't c.D`areatype'`window'$HealthVar), ///
				absorb(panel_year) vce(cluster household_code `geoname')
			*/
			reg lnIncome c.Balanced`window'_`areatype'#(ib9.Post`areatype'Move`window't#c.D`areatype'`window'$HealthVar ///
				i.Post`areatype'Move`window't c.D`areatype'`window'$HealthVar) i.panel_year, ///
				vce(cluster household_code)
				
			est store U`window'`areatype'lnIncome
		}
	}
}



********************************************************************************


/* Store data for figures */
clear 
** Quarterly data
*set obs 16
*gen t = _n+5
*gen PeriodsAfter = t-10

** Annual data
set obs 11
gen t = _n+4
gen PeriodsAfter = t-10


** Main estimates
foreach YVar in $YVarList {
	local YVarSub = substr("`YVar'",1,13)
	foreach areatype in $AreaTypeList {
		foreach window in $WindowList {
			foreach s in $sList { // specification
				est restore `s'`window'`areatype'`YVarSub'
					foreach param in b se {
						gen `param'`s'`window'`areatype'`YVarSub' = .
						forvalues t = 5/15 { // 6/21 { 
							capture noisily replace `param'`s'`window'`areatype'`YVarSub' = _`param'[Balanced`window'_`areatype'#`t'.Post`areatype'Move`window't#D`areatype'`window'`YVar'] if t==`t' // Capture because missing for some t.
						}
					
					}

				* Confidence intervals	
				*	gen ci`s'`window'`areatype'`YVar'l = b`s'`window'`areatype'`YVar' - 1.65*se`s'`window'`areatype'`YVar'
				*	gen ci`s'`window'`areatype'`YVar'u = b`s'`window'`areatype'`YVar' + 1.65*se`s'`window'`areatype'`YVar'
				gen ci`s'`window'`areatype'`YVarSub'l = b`s'`window'`areatype'`YVarSub' - $tstat*se`s'`window'`areatype'`YVarSub'
				gen ci`s'`window'`areatype'`YVarSub'u = b`s'`window'`areatype'`YVarSub' + $tstat*se`s'`window'`areatype'`YVarSub'
			}
		}
	}
}


** Income placebo tests
	* lnIncome is YVar, but the independent variable interaction is with Health Index
foreach window in $WindowList {
	foreach areatype in $AreaTypeList {
		foreach YVar in lnIncome {
		foreach s in U {
		est restore `s'`window'`areatype'`YVar'
			foreach param in b se {
				gen `param'`s'`window'`areatype'`YVar' = .
				forvalues t = 5/15 { 
					capture noisily replace `param'`s'`window'`areatype'`YVar' = _`param'[Balanced`window'_`areatype'#`t'.Post`areatype'Move`window't#D`areatype'`window'$HealthVar] if t==`t' // Capture because missing for some t.
				}
					
			}

		* Confidence intervals	
		*	gen ci`s'`window'`areatype'`YVar'l = b`s'`window'`areatype'`YVar' - 1.65*se`s'`window'`areatype'`YVar'
		*	gen ci`s'`window'`areatype'`YVar'u = b`s'`window'`areatype'`YVar' + 1.65*se`s'`window'`areatype'`YVar'
		gen ci`s'`window'`areatype'`YVar'l = b`s'`window'`areatype'`YVar' - $tstat*se`s'`window'`areatype'`YVar'
		gen ci`s'`window'`areatype'`YVar'u = b`s'`window'`areatype'`YVar' + $tstat*se`s'`window'`areatype'`YVar'
		}
		}
	}
}

save $Externals/Calculations/Movers/InSampleMoverFigure.dta, replace

use $Externals/Calculations/Movers/InSampleMoverFigure.dta, replace
foreach var of varlist b* se* ci* {
	replace `var' = . if `var' == 0 & PeriodsAfter!=-1
}
save $Externals/Calculations/Movers/InSampleMoverFigure.dta, replace

********************************************************************************
/* Make figures */
* This makes figures of all specifications using variables beginning with b in InSampleMoverFigure.dta
graph drop _all


use $Externals/Calculations/Movers/InSampleMoverFigure.dta, replace
foreach window in 102 {
	local prewindow = real(substr("`window'",1,1))
	local postwindow = real(substr("`window'",2,2))
	
	foreach areatype in $AreaTypeList {
		foreach s in $sList {
			foreach YVar in $YVarList {
				local YVarSub = substr("`YVar'",1,13)
	
		
				** Set labels
				local title = "`YVar'"
				local outcome = "`YVar'"
				include Code/Analysis/StylizedFacts/FigureTitles.do
		
				if "`s'"=="U" {
					local title = "No Demographic Controls"
				}
				if "`s'"=="C" {
					local title = "With Demographic Controls"
				}
				
				
				use *`s'`window'`areatype'`YVarSub'* PeriodsAfter using $Externals/Calculations/Movers/InSampleMoverFigure.dta, replace, ///
					if PeriodsAfter>=-`prewindow' & PeriodsAfter<=`postwindow'
					
				line b`s'102`areatype'`YVarSub' PeriodsAfter, lcolor(navy) lp(dash) || ///
					rcap ci`s'102`areatype'`YVarSub'l ci`s'102`areatype'`YVarSub'u PeriodsAfter, lcolor(gs8) ||, /// 
					title("`title'") ytitle("Coefficient on local environment difference") /// 
					xtitle("Years after move") xlabel(-`prewindow'(1)`postwindow') ///  xtitle("Quarters after beginning of move year") xlabel(6(4)18) ///
					legend(off) ///
					xline(-1, lp(dash) lw(thin) lc(maroon)) ///
					graphregion(color(white))
				
				graph save $Fig/InSampleMovesEventStudy`s'`areatype'`window'`YVar', replace // Save gph file to be combined below
			}
		}
	}
}

*** Create combined four-panel graph
foreach YVar in $YVarList {
	foreach window in 102 {
		foreach areatype in $AreaTypeList {
			graph combine $Fig/`areatype'`window'MoverTripShares.gph ///
				$Fig/InSampleMovesD`window'`areatype'`YVar'.gph ///
				$Fig/InSampleMovesEventStudyU`areatype'`window'`YVar'.gph ///
				$Fig/InSampleMovesEventStudyC`areatype'`window'`YVar'.gph, ///
					graphregion(color(white) lwidth(medium)) ///
					rows(2) cols(2) 
			graph export $Fig/InSampleMovesEventStudy`YVar'`areatype'.pdf, as(pdf) replace

		}
	}
}

/* Stitch together pre- and post- event study windows */
foreach areatype in $AreaTypeList {
	foreach s in $sList {
		foreach YVar in $YVarList lnIncome { 
			local YVarSub = substr("`YVar'",1,13)
			if "`YVar'" == "lnIncome" & "`s'" == "C" {
				continue // There are no conditional estimates for lnIncome
			}
			
			** Set figure titles for the individual macronutrients
			local outcome = "`YVar'"
			include Code/Analysis/StylizedFacts/FigureTitles.do
			if "`YVar'" == "lnIncome" | "`YVar'" == "$HealthVar" {
				local title = "" // These are stand-alone figures, with titles produced in lyx
			}
			
			** Stitch together estimates from different windows, offsetting slightly so that they can be seen separately on the graph
			use *`s'102`areatype'`YVarSub'* PeriodsAfter using $Externals/Calculations/Movers/InSampleMoverFigure.dta, replace, if PeriodsAfter>=-3 & PeriodsAfter<=3
			save $Externals/Calculations/Movers/Temp.dta, replace
			use *`s'300`areatype'`YVarSub'* PeriodsAfter using $Externals/Calculations/Movers/InSampleMoverFigure.dta, replace, if PeriodsAfter>=-3 & PeriodsAfter<=3
			replace PeriodsAfter = PeriodsAfter+0.03
			append using $Externals/Calculations/Movers/Temp.dta
			save $Externals/Calculations/Movers/Temp.dta, replace
			use *`s'103`areatype'`YVarSub'* PeriodsAfter using $Externals/Calculations/Movers/InSampleMoverFigure.dta, replace, if PeriodsAfter>=-3 & PeriodsAfter<=3
			replace PeriodsAfter = PeriodsAfter-0.03
			append using $Externals/Calculations/Movers/Temp.dta
			
			** Create graph
			line b`s'102`areatype'`YVarSub' PeriodsAfter, lcolor(navy) lp(dash) || rcap ci`s'102`areatype'`YVarSub'l ci`s'102`areatype'`YVarSub'u PeriodsAfter, lcolor(gs8) lw(thin) || ///
				line b`s'300`areatype'`YVarSub' PeriodsAfter, lcolor(navy) lp(longdash) || rcap ci`s'300`areatype'`YVarSub'l ci`s'300`areatype'`YVarSub'u PeriodsAfter, lcolor(gs8) lw(thin) || ///
				line b`s'103`areatype'`YVarSub' PeriodsAfter, lcolor(navy) || rcap ci`s'103`areatype'`YVarSub'l ci`s'103`areatype'`YVarSub'u PeriodsAfter, lcolor(gs8) lw(thin) ||, /// 
				title("`title'") ///
				ytitle("Coefficient on local environment difference") xtitle("Years after move") xlabel(-3(1)3) ///  
				legend(off) ///
				xline(-1, lp(dash) lw(thin) lc(maroon)) ///
				graphregion(color(white))
			
			if "`YVar'" == "lnIncome" | "`YVar'" == "$HealthVar" | "`YVar'" == "ShareCoke" {
				graph export $Fig/InSampleMovesEventStudy`s'`areatype'`YVar'.pdf, as(pdf) replace
			}
			else {
				graph save $Fig/InSampleMovesEventStudy`s'`areatype'`YVar', replace // Save gph file to be combined below
			}
			
		
		}
		
		if strpos("$YVarList","g_prot_per1000Cal")!=0 {
			** Combine graphs for the macronutrients
			graph combine $Fig/InSampleMovesEventStudy`s'`areatype'Produce.gph ///
				$Fig/InSampleMovesEventStudy`s'`areatype'g_prot_per1000Cal.gph ///
				 $Fig/InSampleMovesEventStudy`s'`areatype'g_fiber_per1000Cal.gph ///
				  $Fig/InSampleMovesEventStudy`s'`areatype'g_fat_sat_per1000Cal.gph ///
				   $Fig/InSampleMovesEventStudy`s'`areatype'g_sugar_per1000Cal.gph ///
				   $Fig/InSampleMovesEventStudy`s'`areatype'g_sodium_per1000Cal.gph ///
				   $Fig/InSampleMovesEventStudy`s'`areatype'g_cholest_per1000Cal.gph, ///
					graphregion(color(white) lwidth(medium)) ///
					rows(2) cols(4) holes(4) xcommon 
		
			graph export $Fig/InSampleMovesEventStudy`s'`areatype'MacroNutrients.pdf, as(pdf) replace
		}
	}
}
erase $Externals/Calculations/Movers/Temp.dta

******************************************************************************
	
/* REGRESSIONS FOR TABLES */
use $Externals/Calculations/Homescan/HHxYearwithInSampleMovers.dta, replace
	
	* Drop the sample where households shop less than 50% in their own county.
	tab OverMinTripShare 
	drop if OverMinTripShare==0 // approx 15% of observations are dropped.


foreach YVar in $YVarList {
	foreach areatype in $AreaTypeList {
		foreach s in U C {
			if "`s'" == "U" {
				local Ctls = ""
			}
			else if "`s'" == "C" {
				local Ctls = "$Ctls"
			}
			
			include Code/DataPrep/DefineGeonames.do
			reghdfe `YVar' `areatype'_PrD_`YVar' ///
				`Ctls', ///
				absorb(household_code panel_year) vce(cluster household_code `geoname')
				
				est store M`s'`areatype'`YVar'	
				local CI95 = _b[`areatype'_PrD_`YVar'] + 1.96*_se[`areatype'_PrD_`YVar']
				estadd scalar UB `CI95'
				if "`s'" == "U" {
					estadd local Ctls "No"
				}
				else if "`s'" == "C" {
					estadd local Ctls "Yes"
				}
				
				** Store UB for bounding exercise below
				if "`YVar'"=="$HealthVar" & "`s'"=="C" {
					local `areatype'CI95 = `CI95'
				}
		}
		
	}
	*** Output results
	
	if "`YVar'" == "ShareCoke" { // For coke, just output the county results and no need to report upper bound
		esttab MUCt`YVar' MCCt`YVar' using "Output/ReducedForm/IM`YVar'.tex", replace ///
			b(%8.4f) se(%8.4f) /// 
			keep(*_PrD_`YVar') ///
			nomtitles stats(Ctls N, l("Household demographics" "Observations") fmt(%8.0f %12.0fc)) ///
			star(* 0.10 ** 0.05 *** 0.01) label nonotes nogaps
	}
	else {	
		esttab MUZ`YVar' MCZ`YVar' MUCt`YVar' MCCt`YVar' using "Output/ReducedForm/IM`YVar'.tex", replace ///
			b(%8.4f) se(%8.4f) /// 
			keep(*_PrD_`YVar') ///
			nomtitles stats(Ctls N UB, l("Household demographics" "Observations" "95\% confidence interval upper bound") fmt(%8.0f %12.0fc %8.3f)) ///
			star(* 0.10 ** 0.05 *** 0.01) label nonotes nogaps
	}
}



/* Robustness checks */
** Is moving associated with income changes?
* Not across zips, yes across counties
local YVar = "$HealthVar"
local Ctls = ""
foreach areatype in $AreaTypeList { 

	include Code/DataPrep/DefineGeonames.do

	reghdfe lnIncome `areatype'_PrD_`YVar' `Ctls', ///
		absorb(household_code panel_year) vce(cluster household_code `geoname')
						
		est store MU`areatype'lnIncome
		local CI95 = _b[`areatype'_PrD_`YVar'] + 1.96*_se[`areatype'_PrD_`YVar']
		estadd scalar UB `CI95'
		
}
	
	*** Output results
		esttab MUZlnIncome MUCtlnIncome using "Output/ReducedForm/IMlnIncome.tex", replace ///
			nomtitles stats(Ctls N UB, l("Household demographics" "Observations" "95\% confidence interval upper bound") fmt(%8.0f %12.0fc %8.3f)) ///
			keep(*_PrD_`YVar') ///
			star(* 0.10 ** 0.05 *** 0.01) label nonotes nogaps 

			
*****************************************************************************

******************************************************************************
/* OUTPUT INFO FOR TEXT */
/* Number of RMS stores per geographic area */
foreach areatype in Z Ct {
	include Code/DataPrep/DefineGeoNames.do 
	use year `geoname' C_*  using $Externals/Calculations/RMS/RMS-Prepped.dta, replace
	gen N=1
	collapse (sum) N C_*, by(`geoname')
	
	** Normalize to per year instead of over the 10-year RMS sample
	foreach var of varlist N C_* {	
		replace `var' = `var'/10
	}
	sum N C_*
	collapse (mean) N,by(`geoname')
	save $Externals/Calculations/Temp.dta, replace
	
	use $Externals/Calculations/Homescan/Prepped-Household-Panel.dta, replace
	merge m:1 `geoname' using $Externals/Calculations/Temp.dta
	sum N // The average Homescan panelist lives in a zip code with 4.0 RMS stores and a county with 95 RMS stores.
	local AvNRMSStoresIn`areatype' = r(mean)


	clear
	set obs 1
	di "`AvNRMSStoresIn`areatype''"
	gen var = `AvNRMSStoresIn`areatype''
	if "`areatype'" == "Z" {
		format var %8.1fc
	}
	if "`areatype'" == "Ct" {
		format var %8.0fc
	} 
	tostring var, replace force u
	outfile var using "Output/NumbersForText/AvNRMSStoresIn`areatype'.tex", replace noquote
}

erase $Externals/Calculations/Temp.dta



/* How many households move zips and counties? */
use $Externals/Calculations/Homescan/HHxYearwithInSampleMovers.dta, replace
sum household_code
sort household_code panel_year
foreach geoname in zip_code state_countyFIPS {
	gen Move_`geoname' = 1 if household_code==household_code[_n-1]&`geoname'!=`geoname'[_n-1]&`geoname'!=.&`geoname'[_n-1]!=.
	sum Move_`geoname'
	local N`geoname'Moves = r(N)	
}
local NZMoves = `Nzip_codeMoves'
local NCtMoves = `Nstate_countyFIPSMoves'

** Valid moves
foreach area in Ct Z {
	sum Post`area'Move102t if Post`area'Move102t==10
	local NValid`area'Moves = r(N)
}

** Output these locals for lyx
foreach var in NZMoves NCtMoves NValidZMoves NValidCtMoves {
	clear
	set obs 1
	gen var = ``var''
	format var %8.0fc
	tostring var, replace force u
	outfile var using "Output/NumbersForText/`var'.tex", replace noquote
}


/* Median cross-county mover experiences X standard deviation change in Health Index */
* Median cross-county mover in the 102 window sample experiences a 0.15 standard deviation change in local Health Index.
local areatype = "Ct"
local window = 102
local YVar = "lHEI_per1000Cal"
local Freq = "Year"
use Post`areatype'Move`window't D`areatype'`window'`YVar' ///
					using $Externals/Calculations/Homescan/HHx`Freq'withInSampleMovers.dta, replace, if Post`areatype'Move`window't==10

	gen abs = abs(D`areatype'`window'`YVar')
	sum abs, d
	local MedHealthVarChange = r(p50)
	* output
	clear
	set obs 1
	gen var = `MedHealthVarChange'
	format var %8.2fc
	tostring var, replace force u
	outfile var using "Output/NumbersForText/MedHealthVarChange.tex", replace noquote



/* Calculation of bounds of contribution to nutrition-income relationship */
** Upper bound on contribution to nutrition-income relationship (in percentage points)
if "$HealthVarQDiff"=="" {
	preserve
	use $Externals/Calculations/Homescan/HHxYear.dta, replace, if InSample==1
	reg $HealthVar ib1.IncomeQuartile $SESCtls i.panel_year [pw=projection_factor], robust cluster(household_code)
	global HealthVarQDiff = _b[4.IncomeQuartile]
	restore
}


foreach areatype in $AreaTypeList {
	use $Externals/Calculations/Homescan/HHxYearwithInSampleMovers.dta, replace
	merge m:1 household_code panel_year using $Externals/Calculations/Homescan/Prepped-Household-Panel.dta, ///
		nogen keep(match master) keepusing(IncomeResidQuartile)	
	
	** Difference in local area Health Index for high vs. low-income households
	sum `areatype'_PrD_lHEI_per1000Cal [aw=projection_factor] if IncomeResidQuartile==1
	local Q1mean = r(mean)
	sum `areatype'_PrD_lHEI_per1000Cal [aw=projection_factor] if IncomeResidQuartile==4
	local `areatype'LocalDiff = r(mean)-`Q1mean'
	
	** Bound on place effect contribution
	local `areatype'PlaceContribution = (``areatype'CI95'*``areatype'LocalDiff' / $HealthVarQDiff)*100

	** Output all numbers for text
	foreach var in LocalDiff CI95 PlaceContribution {
		clear
		set obs 1
		gen var = ``areatype'`var''
		if "`var'" == "PlaceContribution" {
			format var %8.1f
		}
		else {
			format var %8.2f
		}
		tostring var, replace force u
		outfile var using "Output/NumbersForText/`areatype'`var'.tex", replace noquote
	}
}
	

** Additional info for internal reference
use $Externals/Calculations/Homescan/Prepped-Household-Panel.dta,replace, if panel_year <= $MaxYear

** These tabs are not used, just for reference: for Move`areatype'Year==1, we have to observe the household in the year of the move and year before, and the household has to move more than 10 miles:
tab MoveZYear
tab MoveCtYear


** Median household spends 2-3 years in panel
gen N=1
collapse (sum) N, by(household_code)
tab N

			
