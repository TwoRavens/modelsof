*Cost_comparison.do
*Purpose: Compares cost of measures between WAP and WECC. Builds Appendix Tables 8 and 9.
*Date Created: 10/30/15
*Date Last Edited: 01/04/16

clear all
set more off

**************************************************************
**Set Directory Paths Here: sec_dirpath is for 
**confidential data while home_dirpath is for all other input.
**Output is for .tex table output.
**************************************************************

global sec_dirpath "T:\Efficiency\WAP\data"
global home_dirpath "T:\Dropbox\WAP"
*global output "T:/Dropbox/wap/Brian Checks/Annotated Code/Output"
global output "T:\WAP_FINAL\WAP_Appendix_Final\tables_figures"

capture log close


*Switches
local wap = 1
local wecc = 1
local exceltable = 0
local textable = 1

*************************************************************************************
**Section 1: WAP Costs
*************************************************************************************
if `wap' == 1 {

	* Import household-level floor area data
	use "$sec_dirpath\CAA_demog.dta", clear
	
	* Drop if neat id is missing (signal that no audit for these households)
	drop if neat_clientid ==.

	* Merge with measure-level measure cost data. "_old" suffix denotes file that Meredith regenerates with cost data
	merge 1:m neat_clientid using "$sec_dirpath\savings_CO2_by_measure_for_all_NEAT_agencies_old.dta", gen(_mergefirst)
	
	order neat_clientid fwhhid measure cost

	*Limit sample to the experimental sample?
	keep if IN_RED == 1

	*Limit sample to those households that received a neat audit
	keep if IN_NEAT == 1
	
	*Limit sample to those households that received some installed measure
	keep if measure != ""
	
	*Limit sample to those households that have non-missing measure cost data
	keep if cost != .
	
	*Make sure that no households are missing floor area data
	assert neat_floorarea != .
	
	drop if _mergefirst !=3
	
	collapse (rawsum) cost, by(fwhhid measure neat_floorarea HOME_AGE)
	
	*Truncate measure title in order to sum different types of attic insulation below. 
	* I do this in order to treat them together as one measure
	gen measure2 = substr(measure, 1, 10)
	
	*Collapse again to sum different types of attic insulation
	collapse (rawsum) cost, by(fwhhid measure2 neat_floorarea HOME_AGE)
	
	*Generate how many measures there are by household
	duplicates tag fwhhid, gen(dups)
	sum dups, d
	matrix input dupsWAP = (`r(p10)'\ `r(p25)' \ `r(p50)' \ `r(p75)'\ `r(p90)'\ `r(p95)'\ `r(p99)'\ `r(mean)' \ `r(min)'\ `r(max)'\ `r(N)')
	
	*Augment dups by 1 to represent total measures by household
	replace dups = dups + 1
	
	*Convert costs to 2013 dollars (CPI conversion comes from Minneapolis Fed)
	replace cost = cost*(233/229.6)
	
	*Generate Cost by Floor Area
	gen cost_by_floor = (cost/neat_floorarea)
	
	gen program = "WAP"
	
	keep if measure2 == "Attic Ins." | measure2 == "Wall Insul" | measure2 == "Kneewall I" | measure2 == "General Ai"
	
	tempfile measureswap
	saveold `measureswap', replace
	
	*Summarize Results
	sum cost_by_floor if measure2 == "Attic Ins.", d
	matrix input WAPAttic = (`r(p10)'\ `r(p25)' \ `r(p50)' \ `r(p75)'\ `r(p90)'\ `r(p95)'\ `r(p99)'\ `r(mean)' \ `r(min)'\ `r(max)'\ `r(N)')

	sum cost_by_floor if measure2 == "Wall Insul", d
	matrix input WAPWall = (`r(p10)'\ `r(p25)' \ `r(p50)' \ `r(p75)'\ `r(p90)'\ `r(p95)'\ `r(p99)'\ `r(mean)' \ `r(min)'\ `r(max)'\ `r(N)')
	
	sum cost_by_floor if measure2 == "Kneewall I", d
	matrix input WAPKneeWall = (`r(p10)'\ `r(p25)' \ `r(p50)' \ `r(p75)'\ `r(p90)'\ `r(p95)'\ `r(p99)'\ `r(mean)' \ `r(min)'\ `r(max)'\ `r(N)')
	
	sum cost_by_floor if measure2 == "General Ai", d
	matrix input WAPAir = (`r(p10)'\ `r(p25)' \ `r(p50)' \ `r(p75)'\ `r(p90)'\ `r(p95)'\ `r(p99)'\ `r(mean)' \ `r(min)'\ `r(max)'\ `r(N)')
	
	sum cost if measure2 == "Attic Ins.", d
	matrix input WAPAttic2 = (`r(p10)'\ `r(p25)' \ `r(p50)' \ `r(p75)'\ `r(p90)'\ `r(p95)'\ `r(p99)'\ `r(mean)' \ `r(min)'\ `r(max)'\ `r(N)')

	sum cost if measure2 == "Wall Insul", d
	matrix input WAPWall2 = (`r(p10)'\ `r(p25)' \ `r(p50)' \ `r(p75)'\ `r(p90)'\ `r(p95)'\ `r(p99)'\ `r(mean)' \ `r(min)'\ `r(max)'\ `r(N)')
	
	sum cost if measure2 == "Kneewall I", d
	matrix input WAPKneeWall2 = (`r(p10)'\ `r(p25)' \ `r(p50)' \ `r(p75)'\ `r(p90)'\ `r(p95)'\ `r(p99)'\ `r(mean)' \ `r(min)'\ `r(max)'\ `r(N)')
	
	sum cost if measure2 == "General Ai", d
	matrix input WAPAir2 = (`r(p10)'\ `r(p25)' \ `r(p50)' \ `r(p75)'\ `r(p90)'\ `r(p95)'\ `r(p99)'\ `r(mean)' \ `r(min)'\ `r(max)'\ `r(N)')
	
	correlate neat_floorarea cost if measure2 == "Attic Ins."
	local corrWAPattic = `r(rho)'
	
	correlate neat_floorarea cost if measure2 == "Wall Insul"
	local corrWAPwall = `r(rho)'
	
	correlate neat_floorarea cost if measure2 == "Kneewall I"
	local corrWAPkneewall = `r(rho)'
	
	correlate neat_floorarea cost if measure2 == "General Ai"
	local corrWAPair = `r(rho)'

	#delimit ;
	sum neat_floorarea if (measure2 == "Attic Ins." | measure2 == "Wall Insul" | 
	measure2 == "Kneewall I" | measure2 == "General Ai"), d ;
	#delimit cr
	matrix input WAPfloor = (`r(p10)'\ `r(p25)' \ `r(p50)' \ `r(p75)'\ `r(p90)'\ `r(p95)'\ `r(p99)'\ `r(mean)' \ `r(min)'\ `r(max)'\ `r(N)')
	
	}


*************************************************************************************
**Section 2: WECC Costs
*************************************************************************************
if `wecc' == 1 {

	* Import hosuehold-level floor area data 
	import delimited "$sec_dirpath\MilwaukeeGroupAssignments2.csv", clear

	tempfile milwaukee
	saveold `milwaukee', replace

	* Import measure-level cost data
	import excel "$sec_dirpath\MITData_Combined.xlsx", sheet("InstalledMeasures") firstrow clear
	
	rename ID id
	di _N

	* Merge measure-level cost data with household-level floor area data
	merge m:1 id using `milwaukee'
	
	* only 1 household in Milwaukee with installed measures does not merge)
	*gen city = substr(id, 1, 2)
	* browse if city == "mk" & _merge == 1
	
	*Drop those households in floor area data that do not merge
	drop if _merge ==2
	
	*Drop any measures with 0 cost (we assume that these are direct install measures)
	drop if Cost == 0
	
	*Generate home age. Most of installations (and data gathering) were in 2013. 
	gen HOME_AGE = (2013-yr_built)

	*Sum the amount for same types of jobs that occur in the same household.
	collapse (rawsum) Cost, by(id ImprovementType bldg_area HOME_AGE)
	
	*Generate how many measures there are by household
	duplicates tag id, gen(dups)
	sum dups, d
	matrix input dupsWECC = (`r(p10)'\ `r(p25)' \ `r(p50)' \ `r(p75)'\ `r(p90)'\ `r(p95)'\ `r(p99)'\ `r(mean)' \ `r(min)'\ `r(max)'\ `r(N)')
	*Augment dups by 1 to represent total measures by household
	replace dups = dups + 1
	
	
	*Generate cost per square footage
	gen cost_by_floor = (Cost/bldg_area)
	
	#delimit ;
	keep if ImprovementType == "Attic Insulation" | ImprovementType == "Above Grade Wall Insulation" | 
	ImprovementType == "Attic Knee Wall Insulation" | ImprovementType == "Air Sealing" ;
	#delimit cr
	
	gen program = "WECC"
	
	tempfile measureswecc
	saveold `measureswecc', replace
	
	*Summarize Results
	sum cost_by_floor if ImprovementType == "Attic Insulation", d
	matrix input WECCAttic = (`r(p10)'\ `r(p25)' \ `r(p50)' \ `r(p75)'\ `r(p90)'\ `r(p95)'\ `r(p99)'\ `r(mean)' \ `r(min)'\ `r(max)'\ `r(N)')
	
	sum cost_by_floor if ImprovementType == "Above Grade Wall Insulation", d
	matrix input WECCWall = (`r(p10)'\ `r(p25)' \ `r(p50)' \ `r(p75)'\ `r(p90)'\ `r(p95)'\ `r(p99)'\ `r(mean)' \ `r(min)'\ `r(max)'\ `r(N)')
	
	sum cost_by_floor if ImprovementType == "Attic Knee Wall Insulation", d
	matrix input WECCKneeWall = (`r(p10)'\ `r(p25)' \ `r(p50)' \ `r(p75)'\ `r(p90)'\ `r(p95)'\ `r(p99)'\ `r(mean)' \ `r(min)'\ `r(max)'\ `r(N)')
	
	sum cost_by_floor if ImprovementType == "Air Sealing", d
	matrix input WECCAir = (`r(p10)'\ `r(p25)' \ `r(p50)' \ `r(p75)'\ `r(p90)'\ `r(p95)'\ `r(p99)'\ `r(mean)' \ `r(min)'\ `r(max)'\ `r(N)')
	
	sum Cost if ImprovementType == "Attic Insulation", d
	matrix input WECCAttic2 = (`r(p10)'\ `r(p25)' \ `r(p50)' \ `r(p75)'\ `r(p90)'\ `r(p95)'\ `r(p99)'\ `r(mean)' \ `r(min)'\ `r(max)'\ `r(N)')
	
	sum Cost if ImprovementType == "Above Grade Wall Insulation", d
	matrix input WECCWall2 = (`r(p10)'\ `r(p25)' \ `r(p50)' \ `r(p75)'\ `r(p90)'\ `r(p95)'\ `r(p99)'\ `r(mean)' \ `r(min)'\ `r(max)'\ `r(N)')
	
	sum Cost if ImprovementType == "Attic Knee Wall Insulation", d
	matrix input WECCKneeWall2 = (`r(p10)'\ `r(p25)' \ `r(p50)' \ `r(p75)'\ `r(p90)'\ `r(p95)'\ `r(p99)'\ `r(mean)' \ `r(min)'\ `r(max)'\ `r(N)')
	
	sum Cost if ImprovementType == "Air Sealing", d
	matrix input WECCAir2 = (`r(p10)'\ `r(p25)' \ `r(p50)' \ `r(p75)'\ `r(p90)'\ `r(p95)'\ `r(p99)'\ `r(mean)' \ `r(min)'\ `r(max)'\ `r(N)')

	
	#delimit ;
	sum bldg_area if (ImprovementType == "Attic Insulation" | ImprovementType == "Above Grade Wall Insulation" | 
	ImprovementType == "Attic Knee Wall Insulation" |  ImprovementType == "Air Sealing"), d ;
	#delimit cr
	matrix input WECCfloor = (`r(p10)'\ `r(p25)' \ `r(p50)' \ `r(p75)'\ `r(p90)'\ `r(p95)'\ `r(p99)'\ `r(mean)' \ `r(min)'\ `r(max)'\ `r(N)')

	}


*************************************************************************************
**Section 3: Produce Excel Table
*************************************************************************************


if `exceltable' == 1 {

	matrix final = (WAPAttic, WECCAttic, WAPWall, WECCWall, WAPKneeWall, WECCKneeWall, WAPAir, WECCAir, WAPfloor, WECCfloor)
	
	*matrix colnames final = (10th, 25th, 50th, 75th, 90th, 95th, 99th,  Mean, Min, Max, Households)
	preserve
	svmat final

	keep final1-final10
	export excel "`home'Output\Cost_Comparison.xlsx", firstrow(variables) sheet(Raw1) sheetreplace
	restore 
	
	#delimit ;
	matrix final2 = (WAPAttic2, WECCAttic2, WAPWall2, WECCWall2, WAPKneeWall2, WECCKneeWall2, WAPAir2, 
	WECCAir2) ;
	#delimit cr
	
	svmat final2

	keep final21-final28 
	export excel "`home'Output\Cost_Comparison.xlsx", firstrow(variables) sheet(Raw2) sheetreplace
	
	}


	
*************************************************************************************
**Section 4: Regression estimates to hold constant number of measures
*************************************************************************************

if `textable' == 1 {

	*Append WAP and WECC data from sections 1 and 2 above
	use `measureswap', clear

	append using `measureswecc'
	
	*Edit variables after append to create new measure-level dataset
	tostring fwhhid, replace
	replace fwhhid = id if fwhhid == "."
	replace neat_floorarea = bldg_area if neat_floorarea == .
	replace measure2 = ImprovementType if measure2 == ""
	replace cost = Cost if cost == .
	
	
	replace measure2 = "Attic Insulation" if measure2 == "Attic Ins." 
	replace measure2 = "Kneewall Insulation" if measure2 == "Kneewall I" | measure2 == "Attic Knee Wall Insulation"
	replace measure2 = "Wall Insulation" if measure2 == "Above Grade Wall Insulation" | measure2 == "Wall Insul"
	replace measure2 = "Air Sealing" if measure2 == "General Ai" 
	
	
	rename neat_floorarea floor_area
	rename measure2 measure
	rename fwhhid household_id
	rename dups Number_of_Measures
	
	drop Cost ImprovementType bldg_area id
	
	gen WAP = (program == "WAP")
	
	gen cost_by_area = (cost/floor_area)

	*Regressions for first table below
	
	reg cost floor_area HOME_AGE Number_of_Measures WAP if measure == "Wall Insulation"
	est store wall
	
	reg cost floor_area HOME_AGE Number_of_Measures WAP if measure == "Kneewall Insulation"
	est store kneewall
	
	reg cost floor_area HOME_AGE Number_of_Measures WAP if measure == "Attic Insulation"
	est store attic
	
	reg cost floor_area HOME_AGE Number_of_Measures WAP if measure == "Air Sealing"
	est store air
	
	*T-tests
	
	local testvars cost cost_by_area
	
	estpost tabstat cost if measure == "Attic Insulation", by(WAP) s(mean sd) columns(statistics) 
	
	mat b = [e(N_1), e(N_2)]
	
	estpost ttest cost  if measure == "Attic Insulation", by(WAP)

	mat c = e(N_2)
	matrix list b
	matrix list c
	
	tab WAP if measure == "Wall Insulation"
	tab WAP if measure == "Kneewall Insulation"
	tab WAP if measure == "Air Sealing"
	tab WAP if measure == "Attic Insulation"
	
	*T Test variables for second table below
	foreach var of local testvars {
	
		estpost tabstat `var' if measure == "Attic Insulation", by(WAP) s(mean sd) columns(statistics) 
		est store test_`var'_attic

		estpost ttest `var'  if measure == "Attic Insulation", by(WAP)
		est store ttest_`var'_attic
		
		estpost tabstat `var' if measure == "Wall Insulation", by(WAP) s(mean sd) columns(statistics) 
		est store test_`var'_wall

		estpost ttest `var' if measure == "Wall Insulation", by(WAP) 
		est store ttest_`var'_wall
		
		estpost tabstat `var' if measure == "Kneewall Insulation", by(WAP) s(mean sd) columns(statistics) 
		est store test_`var'_kneewall

		estpost ttest `var' if measure == "Kneewall Insulation", by(WAP) 
		est store ttest_`var'_kneewall
		
		estpost tabstat `var'  if measure == "Air Sealing", by(WAP) s(mean sd) columns(statistics)
		est store test_`var'_air

		estpost ttest `var' if measure == "Air Sealing", by(WAP) 
		est store ttest_`var'_air
		
		}

	***********************
	**Build First Table****
	***********************
			
	*Premable when viewing table for editing
	/*
	\documentclass{article}
	\usepackage{caption}
	\usepackage{subcaption}
	\usepackage{tabularx}
	\usepackage{multirow}
	\usepackage{rotating}
	\begin{document}
	*/
	capture file close myfile
	  cd  "$output"
	  
	file open myfile using "Cost_Comparison.tex", write replace 
	file write myfile "\begin{table}[H]" _n "{" _n "\small" _n ///
	 "\centering" _n ///
	  "\resizebox{\columnwidth}{!}{" _n ///
	  "\begin{tabular*}{1.1\textwidth}{@{\extracolsep{\fill}}lcccc}" _n ///
	  "\hline\hline" _n ///
	  "\vspace{.1pt} \\" _n /// 
	  "\multicolumn{5}{l}{\textbf{Dependent variable is measure cost (in dollars)}}" _n ///
	  "\vspace{.2pt} \\" _n /// 
	  "\vspace{.1pt} \\" _n ///
	  "& Wall Insulation & Kneewall Insulation & Attic Insulation & Air Sealing \\" _n /// 
	  "\hline " _n ///
	  "\vspace{.2pt} \\" _n //
	  

	local measures wall kneewall attic air
	
	file write myfile "Floor Area"
	
	*Coefficients
	
	foreach measure of local measures {
	
	
		est res `measure'
		mat beta = e(b)
		file write myfile " & " %4.2f (beta[1, 1])
		qui est r wall
		mat b=r(table)
		if b[4,1]<=0.01 file write myfile "\$^{**}$"
		else if b[4,1]<=0.05 file write myfile "\$^{*}$"
		
		}
		
	file write myfile " \\" _n
	
	*Standard Errors
	
	foreach measure of local measures {
	
		qui est r `measure'
		mat b = r(table)
		file write myfile " & (" %4.2f (b[2, 1]) ")"
		
		}
		
	file write myfile " \\" _n
		
	*Coefficients
		
	file write myfile "Home Age"
		
		foreach measure of local measures {
	
		est res `measure'
		mat beta = e(b)
		file write myfile " & " %4.2f (beta[1, 2])
		qui est r wall
		mat b=r(table)
		if b[4,2]<=0.01 file write myfile "\$^{**}$"
		else if b[4,2]<=0.05 file write myfile "\$^{*}$"
		
		}
		
		file write myfile " \\" _n
		
		*Standard Errors
	
		foreach measure of local measures {
	
			qui est r `measure'
			mat b = r(table)
			file write myfile " & (" %4.2f (b[2, 2]) ")"
		
		}
		
		file write myfile " \\" _n
		
		*Coefficients 
		
		file write myfile "Number of Measures"
		
		foreach measure of local measures {
		
		est res `measure'
		mat beta = e(b)
		file write myfile " & " %4.2f (beta[1, 3])
		qui est r `measure'
		mat b=r(table)
		if b[4,3]<=0.01 file write myfile "\$^{**}$"
		else if b[4,3]<=0.05 file write myfile "\$^{*}$"
	
		}
		
		file write myfile " \\" _n
		
		*Standard Errors
	
		foreach measure of local measures {
	
			qui est r `measure'
			mat b = r(table)
			file write myfile " & (" %4.2f (b[2, 3]) ")"
		
		}
		
		file write myfile " \\" _n
		
		file write myfile "WAP"
		
		foreach measure of local measures {
		
		est res `measure'
		mat beta = e(b)
		file write myfile " & " %4.2f (beta[1, 4])
		qui est r `measure'
		mat b=r(table)
		if b[4,4]<=0.01 file write myfile "\$^{**}$"
		else if b[4,4]<=0.05 file write myfile "\$^{*}$"
	
		}
		
		file write myfile " \\" _n
		
		*Standard Errors
	
		foreach measure of local measures {
	
			qui est r `measure'
			mat b = r(table)
			file write myfile " & (" %4.2f (b[2, 4]) ")"
		
		}
		
	file write myfile "\\" _n
	
	* R Squared 
	
	file write myfile "\hline \\" _n 
	 
	file write myfile "R-squared"
	 
	foreach measure of local measures {
		
		est restore `measure'
		mat b=e(r2)
		file write myfile " & " %4.2f (b[1,1])
		
		}
		
	* Households 
	
	file write myfile "\\" _n 
	 
	file write myfile "Number of Homes"
	 
	foreach measure of local measures {
		
		est restore `measure'
		mat b=e(N)
		file write myfile " & " %5.0fc (b[1,1])
		
		}
		
	file write myfile " \\" _n
		
	file write myfile "\hline \\" _n
	
	file write myfile "\end{tabular*} }}" _n  ///
"\footnotesize Note: The sample is restricted to those households in the experimental sample that have received an audit and" ///
" installed at least one measure. \\" _n ///
"$^{*}$ Significant at the 5 percent level \\" _n ///
"$^{**}$ Significant at the 1 percent level \\" _n ///
	
	
	
	file write myfile "\end{table}"

	file close myfile	
	
	
	***********************
	**Build Second Table***
	***********************
	
	*Premable when viewing table for editing
	/*
	\documentclass{article}
	\usepackage{caption}
	\usepackage{subcaption}
	\usepackage{tabularx}
	\usepackage{multirow}
	\usepackage{rotating}
	\begin{document}
	*/
	capture file close myfile
	cd  "$output"
	
	file open myfile using "ttests.tex", write replace 
	file write myfile "\begin{sidewaystable}" _n "{" _n "\small" _n ///
	"\centering" _n ///
	"\caption{Differences in Mean Costs Between Programs}" _n ///
	"\label{tab:summary_stats}" _n ///
	"\resizebox{\columnwidth}{!}{" _n ///
	"\begin{tabular*}{1.2\textwidth}{@{\extracolsep{\fill}}lcccccccccccc}" _n ///
	"\hline\hline" _n ///
	"\vspace{.1pt} \\" _n ///
	"& \multicolumn{3}{c}{\textbf{Wall Insulation}} & \multicolumn{3}{c}{\textbf{Knee Wall Insulation}} & \multicolumn{3}{c}{\textbf{Attic Insulation}}  & \multicolumn{3}{c}{\textbf{Air Sealing}} \\" _n ///
	"& WAP & WECC & Difference & WAP & WECC & Difference  & WAP & WECC & Difference  & WAP & WECC & Difference \\" _n ///
	"\hline \\" _n ///
	"\multicolumn{12}{l}{\textbf{Panel A: Job Cost}} \\" _n ///
	"\vspace{.1pt} \\" _n ///
	
	local measures wall kneewall attic air
	
	*T tests
	
	file write myfile "Means"
	
	foreach measure of local measures {
	
		est restore test_cost_`measure'
		mat b=e(mean)
		file write myfile " & " %4.0f (b[1,2]) " & " %4.0f (b[1,1])
		
		est restore ttest_cost_`measure'
		mat c = e(b)
		file write myfile " & " %4.0f (c[1,1])
		mat b=e(p)
		if b[1,1]<=0.01 file write myfile "\$^{**}$"
		else if b[1,1]<=0.05 file write myfile "\$^{*}$"
		
		}
		
	file write myfile " \\" _n
	
	file write myfile "Standard Deviations"
	
	foreach measure of local measures {
	
		local i = 1
	
		est restore test_cost_`measure'
		mat b=e(sd)
		file write myfile " & (" %3.0f (b[1,2]) ") & (" %3.0f (b[1,1]) ")"
		
		if  `i' != 4 {
			file write myfile " & "
			}
		
		local i = 1 + `i'
		
		}
	
	file write myfile " \\" _n
	
	* Household Count
	
	file write myfile "Households"
	
	foreach measure of local measures {
	
		local i = 1
		
		est restore ttest_cost_`measure'
		mat b=[e(N_1), e(N_2)]
		file write myfile " & " %4.0f (b[1,2]) " & " %4.0f (b[1,1])

		if  `i' != 4 {
			file write myfile " & "
			}
		local i = 1 + `i'
		
		}
	
	file write myfile "\vspace{.1pt} \\" _n ///
	
	file write myfile "\vspace{.1pt} \\" _n ///
	
	file write myfile "\multicolumn{12}{l}{\textbf{Panel B: Job Cost Per Square Foot of Home}} \\" _n ///
	"\vspace{.1pt} \\" _n ///
	
	*T tests
	
	file write myfile "Means"
	
	foreach measure of local measures {
	
		est restore test_cost_by_area_`measure'
		mat b=e(mean)
		file write myfile " & " %4.2f (b[1,2]) " & " %4.2f (b[1,1])
		
		est restore ttest_cost_by_area_`measure'
		mat c = e(b)
		file write myfile " & " %4.2f (c[1,1])
		mat b=e(p)
		if b[1,1]<=0.01 file write myfile "\$^{**}$"
		else if b[1,1]<=0.05 file write myfile "\$^{*}$"
		
		}
		
	file write myfile " \\" _n
			
	file write myfile "Standard Deviations"
	
	foreach measure of local measures {
	
		local i = 1
	
		est restore test_cost_by_area_`measure'
		mat b=e(sd)
		file write myfile " & (" %4.2f (b[1,2]) ") & (" %4.2f (b[1,1]) ")"
		
		if  `i' != 4 {
			file write myfile " & "
			}
		
		local i = 1 + `i'
		
		}
		
	file write myfile " \\" _n
			
	file write myfile "Households"
	
	foreach measure of local measures {
	
		local i = 1
		
		est restore ttest_cost_by_area_`measure'
		mat b=[e(N_1), e(N_2)]
		file write myfile " & " %4.0f (b[1,2]) " & " %4.0f (b[1,1])

		if  `i' != 4 {
			file write myfile " & "
			}
		local i = 1 + `i'
		
		}
		
	file write myfile " \\" _n
		
	file write myfile "\hline \\" _n
	
	file write myfile "\end{tabular*} }}" _n  ///
	"\footnotesize Note: The sample for the above table consists of households in both our experimental sample and " ///
	" the experimental sample of Allcott and Greenstone (2015), which received weatherization assistance through WECC. " ///
	" We further limit the sample to those who received an energy audit and installed at least one energy efficiency measure. Furthermore, in Panel B we limit the sample " ///
	" to those households for which we have floor area data. For the WECC program, this limits our sample to households in Milwaukee. \\" _n ///
	"$^{*}$ Significant at the 5 percent level \\" _n ///
	"$^{**}$ Significant at the 1 percent level \\" _n ///

	file write myfile "\end{sidewaystable}"

	file close myfile	
	

}

