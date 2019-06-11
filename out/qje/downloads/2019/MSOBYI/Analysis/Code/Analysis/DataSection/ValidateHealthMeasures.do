/* ValidateHealthMeasures.do */



/* Correlations for table */
** Correlations between Health Index and macro nutrients
use $Externals/Calculations/Homescan/HHxYear.dta, replace, if InSample==1
* corr HealthIndex_per1000Cal $HealthIndexNuts [aw=projection_factor]
* corr HEI $HEINuts [aw=projection_factor]

corr lHEI $HEINuts_ordered [aw=projection_factor]
matrix C = r(C)
matrix C = C[2..16,1]
preserve
	clear
	svmat C
	format %8.2f C
restore

** Output correlation between HEI and linear HEI
use $Externals/Calculations/Homescan/HHxYear.dta, replace, if InSample==1
corr HEI lHEI
local rho = r(rho)
	clear
	set obs 1
	gen var = round(`rho',0.01)
	format var %8.2fc 
	tostring var, replace force u
	outfile var using "Output/NumbersForText/rhoHEIlHEI.tex", replace noquote



/* Correlation with health outcomes */
	* Don't weight by projection factor -- already non-representative

use $Externals/Calculations/Homescan/HHxYear.dta, replace, if InSample==1
* Take the calorie-weighted average across years just to keep things simple
collapse (last) panel_year (mean) lHEI HEI [pw=Calories],by(household_code)
	* This collapse generates somewhat smaller standard errors than just using the last year in the sample, so we comment out the lines below.
	*bysort household_code: egen LastYear=max(panel_year)
	*keep if panel_year==LastYear

merge m:1 household_code panel_year using $Externals/Calculations/Homescan/Prepped-Household-Panel.dta, ///
	keep(match) keepusing(projection_factor BMI Diabetic $Ctls_Merge CTractGroup) nogen // state_countyFIPS zip_code 
keep if BMI!=. | Diabetic!=.
	
label var HEI "Healthy Eating Index (standard)"
label var lHEI "Health Index (linearized)"
est drop _all
foreach Y in BMI Diabetic {
		* Absorb fine-grained disaggregated geographies. This attenuates the coefficients, so we want this to be as local as possible.
	*reg `var' HealthIndex_per1000Cal $Ctls i.panel_year, robust cluster(household_code)
	*areg `var' HealthIndex_per1000Cal $Ctls i.panel_year, robust cluster(household_code) absorb(state_countyFIPS)
	foreach X in HEI_per1000Cal lHEI_per1000Cal { // HealthIndex_per1000Cal NutrientScore
		local XSub = substr("`X'",1,10)
		reg `Y' `X', robust cluster(household_code)
		eststo `Y'_`XSub'NoC
		estadd local Controls "No"
		sum `Y' if e(sample)
		local Ymean = r(mean)
		estadd scalar Ymean = `Ymean'
		
		areg `Y' `X'  $Ctls, robust cluster(household_code) absorb(CTractGroup)
		local `Y'_`X' = _b[`X'] // Stores coefficient for use below
		eststo `Y'_`X'C
		estadd local Controls "Yes"
		sum `Y' if e(sample)
		local Ymean = r(mean)
		estadd scalar Ymean = `Ymean'
	}
	if "`Y'"=="BMI" {
		local SigFigs=3
	}
	if "`Y'"=="Diabetic" {
		local SigFigs=4
	}
	esttab `Y'_* using "Output/DataSection/Predicting`Y'.tex", replace ///
		b(%8.`SigFigs'f) se(%8.`SigFigs'f) /// 
		stats(Controls r2 N Ymean, l("Controls" "R$^2$" "N" "Dependent var. mean")  fmt(%8.0f %8.3fc %8.0fc %8.2f)) ///
		star star(* 0.10 ** 0.05 *** 0.01) nogaps nonotes depvars label nomtitles ///
		keep(HEI_per1000Cal lHEI_per1000Cal) /// // HealthIndex_per1000Cal NutrientScore
		order(HEI_per1000Cal lHEI_per1000Cal) // HealthIndex_per1000Cal NutrientScore
}

** Output implied health effects of nutrition-income relationship for stylized facts section
* Note that these are not sample-weighted. 
if "$HealthVarQDiff"=="" {
	preserve
	use $Externals/Calculations/Homescan/HHxYear.dta, replace, if InSample==1
	reg $HealthVar ib1.IncomeQuartile $SESCtls i.panel_year, robust cluster(household_code)
	global HealthVarQDiff = _b[4.IncomeQuartile]
	restore
}
sum BMI
local sd_BMI = r(sd)
local ImpliedBMIEffect = -1 * $HealthVarQDiff * `BMI_lHEI_per1000Cal' 
local ImpliedBMIEffect_SD = -1 * $HealthVarQDiff * `BMI_lHEI_per1000Cal' / `sd_BMI'

sum Diabetic
local mean_Diabetic = r(mean)
local ImpliedDiabetesEffect = -1 * $HealthVarQDiff * `Diabetic_lHEI_per1000Cal' * 100
local ImpliedDiabetesEffect_Pct = -1 * $HealthVarQDiff * `Diabetic_lHEI_per1000Cal' / `mean_Diabetic' * 100

* Output
foreach var in ImpliedBMIEffect ImpliedBMIEffect_SD ImpliedDiabetesEffect ImpliedDiabetesEffect_Pct {
	clear
	set obs 1
	gen var = ``var''
	if "`var'" == "ImpliedBMIEffect_SD" | "`var'" == "ImpliedBMIEffect" {
		format var %8.2f
	}
	else if "`var'" == "ImpliedDiabetesEffect_Pct" {
		format var %8.0f
	}
	else if "`var'" == "ImpliedDiabetesEffect" {
		format var %8.1f
	}
	else {
		error: need a format
	}
	tostring var, replace force u
	outfile var using "Output/NumbersForText/`var'.tex", replace noquote
}

/*
reg HEI $HEINuts
reg HEI $HealthIndexNuts
reg HEI HealthIndex_per1000Cal $HEINuts
reg HEI HealthIndex_per1000Cal $HealthIndexNuts
reg lHEI $HEINuts
 
reg HEI $HealthIndexNuts $HEINuts

** How much does it help to add the fat ratio?
use $Externals/Calculations/Homescan/HHxYear.dta, replace, if InSample==1
reg HEI lHEI
reg HEI lHEI satfat_g_per1000Cal mon_unsat_fat_g_per1000Cal poly_unsat_fat_g_per1000Cal
reg HEI lHEI $HEINuts

** 
* Fat ratio
	gen fat_ratio = (mon_unsat_fat_g + poly_unsat_fat_g) / satfat_g
	replace fat_ratio = 0 if fat_ratio == . // If any component missing, zero points
	replace fat_ratio = 2.5 if satfat_g == 0 // if fat_ratio missing, then give full points	
	gen rlHEI_fatratio = rlHEI_per1000Cal + min(10,10*(fat_ratio - 1.2)/(2.5 - 1.2)) if fat_ratio>=1.2 

	

* Fat difference
gen fat_diff = (mon_unsat_fat_g + poly_unsat_fat_g) - satfat_g
	gen rlHEI_fatdiff = rlHEI_per1000Cal + 10*fat_diff/7.2

corr rHEI rlHEI_per1000Cal rlHEI_fatratio rlHEI_fatdiff


sum rHEI rlHEI_per1000Cal rlHEI_fatratio rlHEI_fatdiff fat_diff fat_ratio mon_unsat_fat_g poly_unsat_fat_g satfat_g
*/

