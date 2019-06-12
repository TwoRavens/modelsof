*Integrated_Table.do
*Purpose: Integrates pre-submission comparison of means table and comparison of 
*means table of Census block-groups. Builds Table 2.
*Date Created: 10/15/2015
*Date Last Edited: 06/01/2016

*Key: 
* RED_GROUP=1 if encourage
* RED_GROUP=2 if control
* QUAS_GROUP=1 if in quasi-experimental sample and weatherized
* QUAS_GROUP=2 if in quasi-experimental sample and not weatherized


capture log close

clear all
capture log close
clear matrix
program drop _all
set more off

*Set directories
*Meredith Directories

global sec_dirpath "T:\Efficiency\WAP\data"
global home_dirpath "T:\Dropbox\WAP"
*global Final_Checks "T:\Dropbox\WAP\Brian Checks\RED Addresses"
*global output "T:\Dropbox\WAP\Brian Checks\Annotated Code\Output"
global output "T:\WAP_FINAL\WAP_Appendix_Final\tables_figures"



************************************************************************************************************************************************************************************
**Section 1: Generate Results in Table 2, Panel B
************************************************************************************************************************************************************************************	


use "$sec_dirpath\RED_ACS.dta", clear

drop if fwhhid == .

*Temporary line to help code run quickly to check mistakes
*keep in 1/1000

*First, we need to merge in summary_table.dta to match household IDs with encouragement indicator

merge 1:1 fwhhid using "$sec_dirpath/summary_table.dta"
assert _merge != 1
drop if _merge !=3

*Destring and Local of variables that we care about testing
#delimit ;
destring households median_income OOmedian_year_built aggregate_income population population_pl households_sizeOO 
households_under18 households_over65 utilitygasheat OO2005orlater OO2000to2004 OO1990to1999 OO1980to1989 OO1970to1979 
OO1960to1969 OO1950to1959 OO1940to1949 OO1939orearlier Occupied_units sample_pl, replace ;
#delimit cr

*Generate Percent of Poverty Variable
gen perc_pov = (population_pl/sample_pl)*100
replace perc_pov = 0 if sample_pl == 0

*Generate average household income
gen mean_income = (aggregate_income/households)

*Generate share of households with Children
gen share_children = (households_under18/households)*100

*Generate share of households with elderly
gen share_elderly = (households_over65/households)*100

*Generate share of natural gas 
gen perc_utilitygasheat = (utilitygasheat/Occupied_units)*100
replace perc_utilitygasheat = 0 if Occupied_units == 0

*Generate Median home age
gen median_age = (2011-OOmedian_year_built)

*Generate households built before a certain time
gen OOpre_1950 = (OO1940to1949 + OO1939orearlier)
gen OOpre_1960 = (OO1950to1959 + OO1940to1949 + OO1939orearlier)


#delimit ;
local test_vars median_age mean_income perc_pov median_income  
households_sizeOO share_children share_elderly perc_utilitygasheat ;
#delimit cr

* Now, generate means and t-test results for experimental control and treatment groups

destring geoid, replace
foreach var of local test_vars {

	estpost tabstat `var' , by(RED_GROUP)  s(mean sd) columns(statistics)
	est store red_`var'
	
	clttest `var', cluster(geoid) by(RED_GROUP)
	local p`var' = `r(p)'
}


** Lastly, generate household counts by category

duplicates drop
gen c=1

estpost tabstat c, by(RED_GROUP) s(count) columns(statistics)
est store RED_GROUP_count2



************************************************************************************************************************************************************************************
**Section 2: Generate Results in Table 2, Panel A and Panel C
************************************************************************************************************************************************************************************

global nn_spec_1 "2"
global nn_spec_2 "4"
global p_spec "4"
global m "3"

 
global sumvar "INCOME PC_POVERTY GAS_HEAT HH_SIZE CHILDREN DISABLED ELDERLY HS HOME_AGE GAS_HEAT "
 
use "$sec_dirpath/summary_table.dta", replace

*Clean observation with home age less than 0
replace HOME_AGE = . if HOME_AGE < 0

label var G_W "Winter gas (MMBtu)"
label var G_S "Summer gas (MMBtu)"
label var E_W "Winter electricity (MMBtu)"
label var E_S "Summer electricity (MMBtu)"
label var INCOME "Household income (\\\$)"
label var PC_POVERTY "Percent of poverty (\%)"
label var GAS_HEAT "Heat with natural gas (share)"
label var HH_SIZE "Household size (\#)"
label var CHILDREN "Children (share of households)"
label var DISABLED "Reported disability (share of households)"
label var ELDERLY "Elderly (share of households )"
label var HS "High school education (shareof households)"
*label var UNEMP "Report unemployed"
label var HOME_AGE "Age of home (years)"
label var neat_floorarea "Floor area (sq. ft.)"


* First, generate means and t-test results for experimental control and treatment groups
 
foreach var of varlist G_W G_S E_W E_S{

	estpost tabstat `var' , by(RED_GROUP)  s(mean sd) columns(statistics)
	est store red_`var'

	estpost ttest `var', by(RED_GROUP) 
	est store red_test_`var'
}

* Next, generate means and t-test results for quasi-experimental weatherized and non-weatherized groups

foreach var of varlist G_W G_S E_W E_S $sumvar{

	estpost tabstat `var', by(QUAS_GROUP) s(mean sd) columns(statistics)
	est store quas_`var'

	estpost ttest `var', by(QUAS_GROUP)
	est store quas_test_`var'
	
}


** Lastly, generate household counts by category

duplicates drop
gen c=1

foreach var of varlist RED_GROUP QUAS_GROUP WAP{
estpost tabstat c, by(`var') s(count) columns(statistics)
est store `var'_count
}


** finally - compare weatherized w matched controls

use "$sec_dirpath/summary_table.dta", clear
    capture drop _merge
	keep if IN_CAA==1
    sort fwhhid

		
	
	merge 1:1 fwhhid using "$home_dirpath/Brian Checks/Annotated Code/Input/psweight_4.dta"

	pstest G_W G_S E_W E_S $sumvar, treated(WAP) mweight(ps_w)
		
		foreach var of varlist G_W G_S E_W E_S $sumvar{

			reg `var' WAP [iweight=ps_w]
			est sto psmatch_`var'
		}
		
*Relabel variables for loops in Section 3 below
label var G_W "Winter gas (MMBtu)"
label var G_S "Summer gas (MMBtu)"
label var E_W "Winter electricity (MMBtu)"
label var E_S "Summer electricity (MMBtu)"
		

*************************************************************************************************************************************************************************
**Section 3: Write Table 2
*************************************************************************************************************************************************************************

/* Generate table for paper
Columns:   Experimental encouraged; Experimental control; Difference between experimental encouraged and experimental control;
Quasi-Experimental weatherized; quasi-experimental unweatherized. 
Rows group-specific means (standard deviations in parentheses) : winter gas; summer gas; winter electricity ; summer electricity ; 
Only quasi-experimental sample applicants vars: hh income, Percent of poverts; hh size; children; disability; elderly ; share of heat
with natural gas; home age

preamble when viewing table for editing
\documentclass{article}
\usepackage{caption}
\usepackage{subcaption}
\usepackage{tabularx}
\usepackage{multirow}
\usepackage{rotating}
\usepackage{tabularx}
\begin{document}
*/


capture file close myfile

*cd  "$output"

*file open myfile using "$output/summary_stats_version2.tex", write replace 
file open myfile using "$output/Table2.tex", write replace 
file write myfile "\begin{sidewaystable}" _n "{" _n "\small" _n ///
"\centering" _n ///
"\caption{Differences in sample means between groups of households}" _n ///
"\label{tab:summary_stats}" _n ///
"\resizebox{\columnwidth}{!}{" _n ///
"\begin{tabular*}{1.2\textwidth}{@{\extracolsep{\fill}}lccccccc}" _n ///
"\hline\hline" _n ///
"\vspace{.1pt} \\" _n ///
"& Experimental & Experimental & (1) - (2) & All & Unweatherized & (4) -  (5) & (4) - matched \\" _n ///
"& encouraged & control &  & weatherized & applicants &  & applicants \\" _n ///
"& (1) & (2) & (3) & (4) & (5) & (6) & (7) \\" _n ///
"\hline \\" _n ///
"\multicolumn{7}{l}{\textbf{Panel A: Pre-treatment period monthly energy consumption}} \\" _n ///
"\vspace{.1pt} \\" _n ///

*************************************
**Panel A
*************************************

foreach var of varlist G_W G_S {
file write myfile "`:var l `var''"
est restore red_`var'
mat b=e(mean)
file write myfile " & " %4.2f (b[1,1]) " & " %4.2f (b[1,2])

est restore red_test_`var'
mat b=e(p)
file write myfile " & " %4.2f (b[1,1])
if b[1,1]<=0.01 file write myfile "\$^{**}$"
else if b[1,1]<=0.05 file write myfile "\$^{*}$"

est restore quas_`var'
mat b=e(mean)
file write myfile " & " %4.2f (b[1,1]) "&" %4.2f (b[1,2])

est restore quas_test_`var'
mat b=e(p)
file write myfile " & " %4.2f (b[1,1])
if b[1,1]<=0.01 file write myfile "\$^{**}$"
else if b[1,1]<=0.05 file write myfile "\$^{*}$"

est replay psmatch_`var'
mat b=r(table)
file write myfile " & " %4.2f (b[4,1])
if b[4,1]<=0.01 file write myfile "\$^{**}$"
else if b[4,1]<=0.05 file write myfile "\$^{*}$"

file write myfile " \\" _n


}

foreach var of varlist E_W E_S {
file write myfile "`:var l `var''"
est restore red_`var'
mat b=e(mean)
file write myfile " & " %4.2f (b[1,1]) " & " %4.2f (b[1,2])

est restore red_test_`var'
mat b=e(p)
file write myfile " & " %4.2f (b[1,1]) 
if b[1,1]<=0.01 file write myfile "\$^{**}$"
else if b[1,1]<=0.05 file write myfile "\$^{*}$"

est restore quas_`var'
mat b=e(mean)
file write myfile " & " %4.2f (b[1,1]) " & " %4.2f (b[1,2])

est restore quas_test_`var'
mat b=e(p)
file write myfile " & " %4.2f (b[1,1])
if b[1,1]<=0.01 file write myfile "\$^{**}$"
else if b[1,1]<=0.05 file write myfile "\$^{*}$"

est replay psmatch_`var'
mat b=r(table)
file write myfile " & " %4.2f (b[4,1])
if b[4,1]<=0.01 file write myfile "\$^{**}$"
else if b[4,1]<=0.05 file write myfile "\$^{*}$"

file write myfile " \\" _n

}

*************************************
**Panel B
*************************************


file write myfile "\\" _n ///
"\multicolumn{7}{l}{\textbf{Panel B: Census block group demographics and dwelling characteristics}} \\" _n /// 
"\vspace{.1pt} \\" _n ///

	*Mean Household Income
	file write myfile "Mean household income (\\$)"
	est restore red_mean_income
	mat b=e(mean)
	file write myfile " & " %4.0f (b[1,1]) " & " %4.0f (b[1,2])
	
	matrix input p = (`pmean_income')
	file write myfile " & " %4.2f (p[1, 1])
	if abs(`pmean_income') < 0.05 file write myfile "\$^{*}"
	else if abs(`pmean_income') < 0.01 file write myfile "\$^{**}"
	file write myfile " & & & & "
	file write myfile " \\" _n

	
	*Percent below poverty line
	file write myfile "Percent of people below poverty line"
	est restore red_perc_pov
	mat b=e(mean)
	file write myfile " & " %4.2f (b[1,1]) " & " %4.2f (b[1,2])
	
	matrix input p = (`pperc_pov')
	file write myfile " & " %4.2f (p[1, 1])
	if abs(`pperc_pov') < 0.05 file write myfile "\$^{*}"
	else if abs(`pperc_pov') < 0.01 file write myfile "\$^{**}"
	file write myfile " & & & & "
	file write myfile " \\" _n

	
	
	*Mean Household Size (Owner-Occupied)
	file write myfile "Mean household size (owner-occupied)"
	est restore red_households_sizeOO
	mat b=e(mean)
	file write myfile " & " %4.2f (b[1,1]) " & " %4.2f (b[1,2])
	
	matrix input p = (`phouseholds_sizeOO')
	file write myfile " & " %4.2f (p[1, 1])
	if abs(`phouseholds_sizeOO') < 0.05 file write myfile "\$^{*}"
	else if abs(`phouseholds_sizeOO') < 0.01 file write myfile "\$^{**}"
	file write myfile " & & & & "
	file write myfile " \\" _n

	
	
	*Share of Households with Members Under 18
	file write myfile "Households with members under 18 (\%)"
	est restore red_share_children
	mat b=e(mean)
	file write myfile " & " %4.2f (b[1,1]) " & " %4.2f (b[1,2])
	
	matrix input p = (`pshare_children')
	file write myfile " & " %4.2f (p[1, 1])
	if abs(`pshare_children') < 0.05 file write myfile "\$^{*}"
	else if abs(`pshare_children') < 0.01 file write myfile "\$^{**}"
	file write myfile " & & & & "
	file write myfile " \\" _n



	*Households with Members Over 65
	file write myfile "Households with members over 65 (\%)"
	est restore red_share_elderly
	mat b=e(mean)
	file write myfile " & " %4.2f (b[1,1]) " & " %4.2f (b[1,2])
	
	matrix input p = (`pshare_elderly')
	file write myfile " & " %4.2f (p[1, 1])
	if abs(`pshare_elderly') < 0.05 file write myfile "\$^{*}"
	else if abs(`pshare_elderly') < 0.01 file write myfile "\$^{**}"
	file write myfile " & & & & "
	file write myfile " \\" _n

	
	
	*Heat with Natural Gas (Housing Units)
	file write myfile "Heat with natural gas (\% of owner-occupied housing units)"
	est restore red_perc_utilitygasheat
	mat b=e(mean)
	file write myfile " & " %4.2f (b[1,1]) " & " %4.2f (b[1,2])
	
	matrix input p = (`pperc_utilitygasheat')
	file write myfile " & " %4.2f (p[1, 1])
	if abs(`pperc_utilitygasheat') < 0.05 file write myfile "\$^{*}"
	else if abs(`pperc_utilitygasheat') < 0.01 file write myfile "\$^{**}"
	file write myfile " & & & & "
	file write myfile " \\" _n


	
	*Median home age (Owner-Occupied)
	file write myfile "Median home age (owner-occupied)" _n
	est restore red_median_age
	mat b=e(mean)
	file write myfile " & " %4.2f (b[1,1]) " & " %4.2f (b[1,2])
	
	matrix input p = (`pmedian_age')
	file write myfile " & " %4.2f (p[1, 1])
	if abs(`pmedian_age') < 0.05 file write myfile "\$^{*}"
	else if abs(`pmedian_age') < 0.01 file write myfile "\$^{**}"
	file write myfile " & & & & "
	file write myfile " \\" _n
	
	
	/*
	*Households built before 1960
	file write myfile "Households Built Before 1960 (Owner-Occupied)" _n
	est restore red_OOpre_1960
	mat b=e(mean)
	file write myfile " & " %4.2f (b[1,1]) " & " %4.2f (b[1,2])
	
	matrix input p = (`pOOpre_1960')
	file write myfile " & " %4.2f (p[1, 1])
	if abs(`pOOpre_1960') < 0.05 file write myfile "\$^{*}"
	else if abs(`pOOpre_1960') < 0.01 file write myfile "\$^{**}"
	file write myfile " & & & & "
	file write myfile " \\" _n
	

	
	*Households built before 1950
	file write myfile "Households Built Before 1950 (Owner-Occupied)" _n
	est restore red_OOpre_1950
	mat b=e(mean)
	file write myfile " & " %4.2f (b[1,1]) " & " %4.2f (b[1,2])
	
	matrix input p = (`pOOpre_1950')
	file write myfile " & " %4.2f (p[1, 1])
	if abs(`pOOpre_1950') < 0.05 file write myfile "\$^{*}"
	else if abs(`pOOpre_1950') < 0.01 file write myfile "\$^{**}"
	file write myfile " & & & & "
	file write myfile " \\" _n
	*/
	

*************************************
**Panel C
*************************************

file write myfile "\\" _n ///
"\multicolumn{7}{l}{\textbf{Panel C: Demographics and dwelling characteristics}} \\" _n /// 
"\vspace{.1pt} \\" _n ///

foreach var of varlist INCOME PC_POVERTY{
file write myfile "`:var l `var''"
file write myfile " & & & "  
est restore quas_`var'
mat b=e(mean)
file write myfile " & " %9.0fc (b[1,1]) " & " %9.0fc (b[1,2])

est restore quas_test_`var'
mat b=e(p)
file write myfile " & " %9.2f (b[1,1]) 
if b[1,1]<=0.01 file write myfile "\$^{**}$"
else if b[1,1]<=0.05 file write myfile "\$^{*}$"

est replay psmatch_`var'
mat b=r(table)
file write myfile " & " %9.2f (b[4,1])
if b[4,1]<=0.01 file write myfile "\$^{**}$"
else if b[4,1]<=0.05 file write myfile "\$^{*}$"

file write myfile " \\" _n

}

foreach var of varlist  HH_SIZE CHILDREN DISABLED ELDERLY GAS_HEAT HOME_AGE {
file write myfile "`:var l `var''"
file write myfile " & & & "  
est restore quas_`var'
mat b=e(mean)
file write myfile " & " %9.2fc (b[1,1]) "&" %9.2fc (b[1,2])

est restore quas_test_`var'
mat b=e(p)
file write myfile " & " %9.2f (b[1,1]) 
if b[1,1]<=0.01 file write myfile "\$^{**}$"
else if b[1,1]<=0.05 file write myfile "\$^{*}$"

est replay psmatch_`var'
mat b=r(table)
file write myfile " & " %9.2f (b[4,1])
if b[4,1]<=0.01 file write myfile "\$^{**}$"
else if b[4,1]<=0.05 file write myfile "\$^{*}$"

file write myfile " \\" _n

}

file write myfile "\hline \\" _n 

*Household

file write myfile "Households"
est restore RED_GROUP_count
mat b=e(count)
file write myfile " & " %9.0fc (b[1,1]) " & " %9.0fc (b[1,2]) " & "
est restore QUAS_GROUP_count
mat b=e(count)
file write myfile " & " %9.0fc (b[1,1]) " & " %9.0fc (b[1,2]) " &  " _n
file write myfile " \\" _n

file write myfile "\hline \\" _n ///
"\end{tabular*} } }" _n  ///
"\footnotesize Note: Columns numbered (1), (2), (4) and (5) report average values. Columns (3), (6), and (7) report the p-values of differences in means." ///
" Columns (1) and (2) report sample means for the randomized encouraged and the experimental control groups, respectively. Column (4) reports the sample means for all weatherized households in" /// 
" the quasi-experimental sample while column (5) reports the the sample means for households in the quasi-experimental sample that applied for weatherization but did not receive assistance as of April 2014." /// 
" Finally, column (7) reports the p-values of the differences in means between all weatherized households in the quasi-experimental sample and propensity-score matched unweatherized households. Household counts summarize energy consumption data." ///
" Panel B describes census block-group level data from the 2007-2011 American Community Survey while Panel C focuses exclusively on program applicants.  \\" _n ///
"$^{*}$ Significant at the 5 percent level \\" _n ///
"$^{**}$ Significant at the 1 percent level \\" _n ///
"\end{sidewaystable}"

file close myfile

capture log close

