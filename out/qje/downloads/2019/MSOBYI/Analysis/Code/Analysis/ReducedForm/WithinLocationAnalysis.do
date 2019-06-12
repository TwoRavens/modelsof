/* WithinLocationAnalysis.do */
* This file measures the disparities that persist (as documented in Stylized Facts)
* 	after controlling for location or store fixed effects

/* SETUP */
clear  all
set more off
set matsize 10000
set maxvar 8000
set scheme s2color
set printcolor auto

capture net install grc1leg2.pkg
	
/* STATEMENTS IN TEXT */


********************************************************************************
********************************************************************************

/* GRAPHS: HEALTHFULNESS AND EXPENDITURES BY INCOME LEVEL */
global Fig = "Output/ReducedForm/Figures"
global NutrientList = "lHEI_per1000Cal HealthIndex_per1000Cal NutrientScore" // "" g_sugar_per1000Cal Whole Produce"
global SESList = "HHAvIncome" // Educ "
global Ctls_keep = subinstr("$Ctls","i.","",.)+" HHAvIncome "
global Ctls_Income = "$SESCtls i.panel_year" // i.AgeInt CalorieNeed" // i.household_size - replaced with CalorieNeed
global Ctls_Educ = ""
global Ctls_all=subinstr(subinstr(subinstr("${Ctls} i.panel_year","HHAvIncome","",.),"lnIncome","",.),"lnEduc","",.) // +" household_size"

global base_Income = 50000
global base_Educ = 12

capture program drop main
program define main

	global first=1
	global zip_code_lab="Zip Code"
	global gisjoin_lab="Tract"
	global store_code_uc_lab="Store"
	global chain_lab="Chain"
	global chain_x_zip_lab="Chain x Zip Code"
	global chain_x_county_lab="Chain x County"
	global chain_x_state_lab="Chain x State"
	
	global chain_var="retailer_code"
	global zip_code_var="zip_code"
	global county_var="fips_county_code"
	global state_var="fips_state_code"
	
	global Ctls_Income_lab="Household Size and Age Controls"
	global Ctls_Educ_lab="No Demographic Controls"
	global Ctls_all_lab="All Demographic Controls"
	
	global suf_lHEI_per1000Cal="lHEI"
	global suf_NutrientScore="Nutr"
	global suf_HealthIndex_per1000Cal="HI"
	
	global outlab_Educ="Educ"
	global outlab_HHAvIncome="Income"
	global title_Educ="Years of Education"
	global title_HHAvIncome="Household income ($000s)"
	global xaxis_Educ="xlabel(10(2)18) xscale(range(10 18)) "
	global xaxis_HHAvIncome="xlabel(0(25)125) xscale(range(0 125)) "
	
	foreach SESvar in ${SESList} {

		global SESvar="`SESvar'"
		capture rm temp${SESvar}.dta
	
	** Within-zipcode (or tract: gisjoin)		
		sub_figuredata, xsfe(zip_code) 
		
	** Within-retailer x location (other alternatives: chain_x_zip, chain_x_state, store_code_uc, chain)
		sub_figuredata, xsfe(chain)  minexpsh(50)   
*		sub_figuredata, xsfe(chain_x_county)  minexpsh(50) 
			//Limiting sample to household-store-years that reflect over 50% of HH-year expenditures

	** Make figures
		foreach nutr in ${NutrientList} {
			foreach loc in zip_code { 
			foreach store in chain { // chain_x_county
*				sub_figures, xsfe1(`loc') xsfe2(`store') outcome(`nutr') 
				sub_figures, xsfe1(`loc') xsfe2(`store') outcome(`nutr') minexpsh(50) 
*				sub_figures, xsfe1(`loc') xsfe2(`store') outcome(`nutr')  idsample(ID)
				sub_figures, xsfe1(`loc') xsfe2(`store') outcome(`nutr') minexpsh(50)  idsample(ID)
			}
			}
		}

		global first=1
		rm temp${SESvar}.dta
	}
	
end

********************************************************************************
********************************************************************************
capture program drop sub_figuredata
program define sub_figuredata
	syntax [anything], xsfe(string) [minexpsh(string) tractsubsample(string)]
	
	if 1==1 {
		local xsfes=subinstr("`xsfe'","_x_"," ",.)
		local nxsfe=wordcount("`xsfes'")
		local xsfevarlist=""
		disp "xsfes: `xsfes'"
		forvalues i=1/`nxsfe' {
			local xsfevar`i'=word("`xsfes'",`i')
			local xsfevar`i'="${`xsfevar`i''_var}"
			local xsfevarlist="`xsfevarlist' `xsfevar`i''"
		}
		
		disp "`xsfe' --> `xsfes' --> `xsfevarlist': var1 `xsfevar1', var2 `xsfevar2'"
		
	** Purchase data
		if strpos("`xsfe'","chain")>0 {
			use "$Externals/Calculations/Homescan/HHxYearxStore.dta", clear
			drop if inlist(retailer_code,3996,3997,3998,3999,.)
		}
		else use "$Externals/Calculations/Homescan/HHxYear.dta", clear
			// created in DataPrep/Homescan/TransactionDataPrep.do 
		
	** Merge in zips, income groups & projection_factor
		merge m:1 household_code panel_year using "$Externals/Calculations/Homescan/Prepped-Household-Panel.dta", ///
			keepusing(HHAvIncome IncomeQuartile zip_code projection_factor gisjoin fips_county_code fips_state_code HaveTract ${Ctls_keep}) keep(match master) nogen 
			// created in DataPrep/Homescan/HomescanHouseholdDataPrep.do 		
		if "`tractsubsample'"!="" keep if HaveTract==1

		gen Educ=exp(lnEduc)
		drop if Educ<10
			
	** If limiting to stores with high household-year calorie shares
		if "`minexpsh'"!="" {
			bys household_code panel_year: egen totalcal=total(Calories)
			gen shcal=Calories/totalcal
			drop if shcal==.
			gsort household_code panel_year -shcal
			bys household_code panel_year: gen first=(_n==1)
			sum shcal if first
			drop if shcal<`minexpsh'/100
			local gphnote "note(Sample limited to stores where households buy at least half of their annual observed Calories.)"
			local suffix "_minexpsh50"
		}

	** Generate interacted fixed effect
		foreach xsfevar in `xsfevarlist' {
			keep if `xsfevar'!=.
		}
		egen `xsfe'_x_yr=group(`xsfevarlist' panel_year)
	
	** SES dummies:
		drop if ${SESvar}==.
		egen tempgrp=group(${SESvar})
		if "${SESvar}"=="HHAvIncome" {
			xtile byte Income15ile = HHAvIncome [aw=projection_factor], nq(15)
			replace tempgrp=Income15ile
		}
		
	** Identification sample:	
		bys `xsfe'_x_yr: egen idsample=nvals(${SESvar})
		replace idsample=min(idsample-1,1)
		global IDsamplelimit="if idsample"
		global samplelimit=""
		tab idsample
		
		if "${SESvar}"=="HHAvIncome" {
			bys `xsfe'_x_yr: egen quartileidsample=nvals(IncomeQuartile)
			replace quartileidsample=min(quartileidsample-1,1)
			global qIDsamplelimit="if quartileidsample"
			tab quartileidsample
		}
		
		quietly sum tempgrp
		local dropgrp=`r(min)'
		
	** Plot for each outcome...
		foreach outcome in $NutrientList { 
			local outlab_`outcome'=subinstr("`outcome'","_per1000Cal","",.)
			
			foreach ctrl in ${outlab_${SESvar}} all {
			
				foreach sample in "" ID {
				
				disp "************"
				disp "estimating mean `outcome' with and without ${`xsfe'_lab} x Year FEs ${`sample'samplelimit}..."
				disp "...with controls: ${Ctls_`ctrl'}"
		*	
					quietly {
						eststo `ctrl'`sample'noFE_${suf_`outcome'}: reg `outcome' ib`dropgrp'.tempgrp ${Ctls_`ctrl'} ///
							${`sample'samplelimit}  [aw=projection_factor], vce(cluster household_code) 
						eststo `ctrl'`sample'locyrFE_${suf_`outcome'}: areg `outcome' ib`dropgrp'.tempgrp  ${Ctls_`ctrl'}  ///
							${`sample'samplelimit}  [aw=projection_factor], absorb(`xsfe'_x_yr) vce(cluster household_code)  
						quietly sum `outcome' ${`sample'samplelimit}  [aw=projection_factor]
							local base_`sample'_${suf_`outcome'}=`r(mean)'
					}
		*
				*output numbers required for text for base specs:
					if ("`ctrl'"=="${outlab_${SESvar}}" & "${SESvar}"=="HHAvIncome" & "`xsfe'"=="zip_code" & "`tractsubsample'"=="") | ///
						("`ctrl'"=="${outlab_${SESvar}}" & "${SESvar}"=="HHAvIncome" & strpos("`xsfe'","chain")>0 & "`minexpsh'"=="50" ) {
						   if "`sample'"=="ID"  {
								quietly reg `outcome' ib1.IncomeQuartile ${Ctls_`ctrl'} ///
									${qIDsamplelimit}   [aw=projection_factor], vce(cluster household_code) 
								local noFE=_b[4.IncomeQuartile]
							     quietly areg `outcome' ib1.IncomeQuartile ${Ctls_`ctrl'}  ///
									${qIDsamplelimit}   [aw=projection_factor], absorb(`xsfe'_x_yr) vce(cluster household_code)  
								local LocYrFE=_b[4.IncomeQuartile]
								preserve
								clear
								set obs 1
								gen var = `noFE'
								disp "without fixed effects, ID sample, all quartiles: interquartile gap = `noFE'"
								format var %12.2fc
								tostring var, replace force u
								outfile var using "Output/NumbersForText/${suf_`outcome'}QDiff_nofes_within`xsfe'data.tex", replace noquote
								clear
								set obs 1
								gen var=`LocYrFE'
								disp "with fixed effects, ID sample, all quartiles: interquartile gap = `LocYrFE'"
								format var %12.2fc
								tostring var, replace force u
								outfile var using "Output/NumbersForText/${suf_`outcome'}QDiff_within`xsfe'.tex", replace noquote
								restore		
							}
							else {
								quietly reg `outcome' ib1.IncomeQuartile ${Ctls_`ctrl'} ///
									${`sample'samplelimit}   [aw=projection_factor], vce(cluster household_code) 
								count if e(sample)
								local totalobs=`r(N)'
								count if idsample==1
								local pctIDsample=100*(`r(N)'/`totalobs')
								disp "identification sample reduced from `totalobs' to `r(N)' (`pctIDsample'%)"
								preserve
								clear
								set obs 1
								gen var=`pctIDsample'
								format var %12.0fc
								tostring var, replace force u
								outfile var using "Output/NumbersForText/${suf_`outcome'}idsamplepct_within`xsfe'.tex", replace noquote
								restore
							}
					}
		*
				}
			}
		}
	
	*
	** Pull estimates
		collapse (mean) ${SESvar} [pw=projection_factor], by(tempgrp) fast
		foreach outcome in $NutrientList  { 
			foreach ctrl in "${outlab_${SESvar}}" "all" {
				foreach fe in noFE locyrFE  {
					foreach sample in "" ID {
						quietly {
							local outlab_`outcome'=subinstr("`outcome'","_per1000Cal","",.)
							est restore `ctrl'`sample'`fe'_${suf_`outcome'}
							matrix A=e(b)'
							matrix B=vecdiag(e(V))'
							matrix C=[A, B]
							svmat C, names(`ctrl'`sample'`fe'_${suf_`outcome'})
							rename *1 b_*
							rename *2 se_*
						}
						drop if tempgrp==.
						quietly sum b_`ctrl'`sample'`fe'_${suf_`outcome'}
						replace b_`ctrl'`sample'`fe'_${suf_`outcome'} =  b_`ctrl'`sample'`fe'_${suf_`outcome'} - `r(mean)' + `base_`sample'_${suf_`outcome'}'
					}
				}
			}
		}
			
		drop tempgrp	
	
	** Identifiers
		gen xsfe="`xsfe'"
		gen tractsubsample="`tractsubsample'"
		gen minexpsh="`minexpsh'"
		
	if ${first}==1 global first=0
	else append using temp${SESvar}
	save temp${SESvar}, replace
	*
}	
	
end

********************************************************************************
capture program drop sub_figures
program define sub_figures
	syntax [anything], xsfe1(string) xsfe2(string) outcome(string) [tractsubsample(string) minexpsh(string) idsample(string)]

	if "`minexpsh'"!="" {
		*local gphnote "note(Sample limited to stores where households spend at least half of their annual observed expenditure.)"
		local suffix "_minexpsh50"
	}

	** Create individual plots
		quietly include Code/Analysis/StylizedFacts/FigureTitles.do
		local outlab_`outcome'=subinstr("`outcome'","_per1000Cal","",.)
		
		** plots
		foreach xsfe in `xsfe1' `xsfe2' {
			use temp${SESvar} if xsfe=="`xsfe'", clear
			tab xsfe tractsubsample
			drop if strpos("`xsfe'","chain")>0  & minexpsh!="`minexpsh'"
			drop if xsfe=="retailer_code" & minexpsh!="`minexpsh'"
			drop if xsfe=="store_code_uc" & minexpsh!="`minexpsh'"
			drop if xsfe=="zip_code" & tractsubsample!="`tractsubsample'"
			count
			foreach ctrl in ${outlab_${SESvar}} all {
				if "`idsample'"=="" {
					twoway (scatter b_`ctrl'IDnoFE_${suf_`outcome'} ${SESvar}, msymbol(O)) /// 
						(scatter b_`ctrl'locyrFE_${suf_`outcome'} ${SESvar}, msymbol(X)), ///
						graphregion(color(white)) subtitle("${Ctls_`ctrl'_lab}") ///
						xtitle("${title_${SESvar}}") ytitle("`ytitle'") ///
						${xaxis_${SESvar}} ///
						name(`xsfe'`ctrl', replace) nodraw ///
						legend(size(vsmall) label(1 "Raw") label(2 "Residualized from Market FE"))
				}			
				else {	
					twoway (scatter b_`ctrl'IDnoFE_${suf_`outcome'} ${SESvar}, msymbol(O)) /// 					
						(scatter b_`ctrl'locyrFE_${suf_`outcome'} ${SESvar}, msymbol(X)) ///
						(scatter b_`ctrl'noFE_${suf_`outcome'} ${SESvar}, msymbol(Th) mcolor(black)), ///
						graphregion(color(white)) subtitle("${Ctls_`ctrl'_lab}") ///
						xtitle("${title_${SESvar}}") ytitle("`ytitle'") ///
						${xaxis_${SESvar}} ///
						name(`xsfe'`ctrl', replace) nodraw ///
						legend(size(vsmall) label(1 "Raw (FE identification sample)")   label(2 "Residualized from Market FE") label(3 "Raw (Full Sample)"))
					
				}
			}
		}
	
	** Combine for main 2x2
		grc1leg2 `xsfe1'${outlab_${SESvar}} `xsfe1'all, graphregion(color(white))  ///
				subtitle(Within ${`xsfe1'_lab} x Year) xcommon ycommon rows(1) cols(2) name(`xsfe1', replace)

		grc1leg2 `xsfe2'${outlab_${SESvar}} `xsfe2'all, graphregion(color(white))  ///
				subtitle(Within ${`xsfe2'_lab} x Year) xcommon ycommon rows(1) cols(2) name(`xsfe2', replace)
				
		grc1leg2 `xsfe1' `xsfe2', rows(2) cols(1) graphregion(color(white)) 
		graph export $Fig/`outlab_`outcome''_${outlab_${SESvar}}_`xsfe1'_`xsfe2'_x_yr`suffix'`idsample'`tractsubsample'.pdf, as(pdf) replace

end


********************************************************************************
********************************************************************************
********************************************************************************

capture log close
log using $Fig/WithinLocation.txt, replace text
	main
log close
