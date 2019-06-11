/* GelbachDecomp.do */
* Note: Users may need to type "ssc install b1x2" to install the decomp software.

/* SETUP */
capture log close
log using Output/LogFiles/GelbachDecomp.log, replace

global YVarList = "nHealthIndex_supply" // HealthIndex_per1000Cal MilkFatPct Whole Produce FreshProduce 

global DecompX = "lnEduc R_* Married Employed WorkHours _R*" //
global DecompX_Aux = "lnEduc R_White R_Black Married Employed WorkHours" // For auxiliary regressions
global DecompControls = "HouseholdSize _A* _Y* "

/* DATA PREP */
use "$Externals/Calculations/Homescan/HHxYear.dta", clear, if InSample==1
merge 1:1 household_code panel_year using "$Externals/Calculations/Homescan/Prepped-Household-Panel.dta", ///
	keep(match master) nogen keepusing(projection_factor $Ctls_Merge Educ region_code ///
		svy_health_importance svy_health_knowledge)

* We use sample average income
drop lnIncome
gen lnIncome = ln(HHAvIncome)

merge 1:1 household_code panel_year using "$Externals/Calculations/Homescan/HealthIndexNoSupply.dta", ///
	keep(match master) nogen keepusing(HealthIndex_supply HealthIndex_true)

	
** Limit to the sample that we will use
foreach var in HealthIndex_supply $DecompX_Aux svy_health_importance svy_health_knowledge { // svy_self_control
	drop if `var' == .
}
	
foreach var in HealthIndex_supply HealthIndex_true {
	sum `var' [aw=projection_factor]
	gen n`var' = (`var'-r(mean))/r(sd)
}

** Re-normalize the survey variables given the new sample
foreach var in svy_health_importance svy_health_knowledge { // svy_self_control
	sum `var' [aw=projection_factor]
	replace `var' = (`var'-r(mean))/r(sd)
}
	
** Indicator variables
	* Gelbach code does not accommodate i. notation
xi i.region_code, pre(_R)
xi i.AgeInt, pre(_A)
xi i.panel_year, pre(_Y)


saveold "$Externals/Calculations/GelbachTemp.dta", replace


/* ESTIMATES FOR TABLE */
foreach YVar in $YVarList { 
	use "$Externals/Calculations/GelbachTemp.dta", replace

	*** Run regressions
	** Main regression
	reg `YVar' lnIncome $DecompX svy_health_importance svy_health_knowledge $DecompControls [pw=projection_factor], cluster(household_code)
	est store `YVar'
	local EducCoeff = _b[lnEduc]
		** For comparison: Leave out the health knowledge variables
		reg `YVar' lnIncome $DecompX svy_health_importance $DecompControls [pw=projection_factor], cluster(household_code), if e(sample)
		display _b[lnEduc]/`EducCoeff' // In separate regressions where we exclude the survey variables, the education coefficient rises by (1-thisamount)*100 %.
	
		** Association between educ and results
		sum Educ
		local OneYrEducAtMean = ln(r(mean)+1)-ln(r(mean))
		display "At mean, one year of education changes lnEduc by `OneYrEducAtMean'."
		display _b[lnEduc]*`OneYrEducAtMean' // At the mean, a one year education increase is associated with an X standard deviation increase in demand for healthy groceries.
	
	** Unconditional analogue
	reg `YVar' lnIncome $DecompControls [pw=projection_factor], cluster(household_code), if e(sample)
	est store `YVar'U
	
	** Gelbach decomp code
	b1x2 `YVar' [aw=projection_factor], x1all(lnIncome $DecompControls) x2all($DecompX svy_health_importance svy_health_knowledge) ///
		x1only(lnIncome) ///
		x2delta(lnEduc=lnEduc : R_White=R_White : ///
		R_Black=R_Black : Married=Married : ///
		Employed=Employed : WorkHours=WorkHours : ///
		svy_health_importance=svy_health_importance : ///
		svy_health_knowledge=svy_health_knowledge : ///
		Region = _R* ) ///
		robust cluster(household_code)

	matrix delta=e(Delta)'
	matrix Cov = e(Covdelta)
	matrix Var = vecdiag(Cov)'

	*** Output results
	*local YVar = "nHealthIndex_supply"
	** From unconditional and full regressions
	esttab `YVar' `YVar'U using "Output/ReducedForm/Decomp`YVar'.csv", replace ///
			se scalars(N r2) ///
			drop(_R* _Y* _A* _cons) ///
			staraux star(* 0.10 ** 0.05 *** 0.01) label nogaps nomtitles	
	
	** Results from Gelbach code
	clear
	svmat delta
	svmat Var
	gen SE = Var^0.5
	drop Var
	outsheet using Output/ReducedForm/GelbachDeltas`YVar'.csv, comma names replace
}



/* Run auxiliary regressions */
use "$Externals/Calculations/GelbachTemp.dta", replace
local i = 1
foreach var in $DecompX_Aux svy_health_importance svy_health_knowledge {
	reg lnIncome `var' $DecompControls [pw=projection_factor], robust cluster(household_code)
	est store Aux_`var'
	if `i'==1 {
		esttab Aux_`var' using "Output/ReducedForm/DecompAux.csv", replace ///
			drop($DecompControls _cons) ///
			staraux star(* 0.10 ** 0.05 *** 0.01) label nogaps nolines nomtitles nonotes noobs nonumbers compress se
	}
	else {
		esttab Aux_`var' using "Output/ReducedForm/DecompAux.csv", append ///
			drop($DecompControls _cons) ///
			staraux star(* 0.10 ** 0.05 *** 0.01) label nogaps nolines nomtitles nonotes noobs nonumbers compress se
	}
	local i = `i' + 1
}



/* MAKE FIGURE */
** Get the unconditional alpha
est restore nHealthIndex_supplyU
local UnrestrictedCoeff = _b[lnIncome]

** Make figure from Gelbach results
insheet using Output/ReducedForm/GelbachDeltasnHealthIndex_supply.csv, clear
drop if _n==_N // this is the "__TC" from the Gelbach output
keep delta se
foreach var in delta se {
	replace `var' = `var'/`UnrestrictedCoeff'
}
gen ciu = delta+$tstat*se
gen cil = delta-$tstat*se

gen order = _N-_n+1
sort order

twoway bar delta order, horizontal color(navy) || rcap ciu cil order, horizontal lcolor(gs8) ///
		xlabel(-.1(0.1)0.3,grid) ///
		ylabel(9 "ln(Years education)" 8 "White" 7 "Black" ///
			6 "Married" 5 "Employed" 4 "Weekly work hours" 3 "Health importance" /// 5 "ln(Household calorie need)"
			2 "Nutrition knowledge" 1 "Census division" , noticks nogrid angle(0)) ///
		graphregion(color(white)) ytitle("") legend(off) xline(0,lcolor(black)) ///
		xtitle("Contribution to income-health demand relationship")
		
graph export Output/ReducedForm/Figures/ReducedFormDecomp.pdf, as(pdf) replace

capture log close
