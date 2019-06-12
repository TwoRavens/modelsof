*RED_by_Census.do
*Purpose: Compare Differences of means of block group-level Census variables
*between the RED encouraged and RED control groups. This file can include as many
*variables from the ACS as possible.
*Date Created: 09/12/2015
*Date Last Edited:01/15/2017

clear all
set more off

*Set directories

*Meredith Directories

global sec_dirpath "T:\Efficiency\WAP\data"
*global home "T:/Dropbox/WAP/Brian Checks/Annotated Code/Input/"
global home "T:\WAP_FINAL\WAP_Appendix_Final\data_files"
global output "T:/WAP_FINAL/WAP_Appendix_Final/tables_figures"

***********************************************************************************
**Section 1: Destring Variables
***********************************************************************************

use "$home\RED_ACS_redux.dta", clear

*First, we need to merge in summary_table.dta to match household IDs with encouragement indicator

merge 1:1 fwhhid using "$sec_dirpath\summary_table.dta"
assert _merge !=1
drop if _merge !=3
*Temporary to help code run quickly to check mistakes
*keep in 1/1000


*Destring and Local of variables that we care about testing
#delimit ;
destring households median_income OOmedian_year_built aggregate_income population sample_pl 
population_pl households_sizeOO households_under18 households_over65 utilitygasheat 
population_black population_latino OO2005orlater OO2000to2004 OO1990to1999 
OO1980to1989 OO1970to1979 OO1960to1969 OO1950to1959 OO1940to1949 OO1939orearlier 
population_male population_female public_assistance noschool_male nursery_grade4_male 
grade5to6_male grade7to8_male grade9_male grade10_male grade11_male grade12_nodip_male 
highschool_male college_1year_male college_someyears_male associates_male bachelors_male 
masters_male professional_school_male doctorate_male noschool_female 
nursery_grade4_female grade5to6_female grade7to8_female grade9_female grade10_female 
grade11_female grade12_nodip_female highschool_female college_1year_female 
college_someyears_female associates_female bachelors_female masters_female 
professional_school_female doctorate_female OO_units housing_units bottledgasheat 
electricityheat fueloilheat coalcokeheat woodheat solarheat otherheat nofuelheat
population_25older Occupied_units associates_male associates_female, replace ;
#delimit cr

***********************************************************************************
**Section 2: Generate Variables
***********************************************************************************


*Generate Percent of Poverty Variable
gen perc_pov = (population_pl/sample_pl)*100
replace perc_pov = 0 if sample_pl == 0

*Generate average household income
gen mean_income = (aggregate_income/households)

*Generate share of households with Children
gen share_children = (households_under18/households)*100

*Generate share of households with elderly
gen share_elderly = (households_over65/households)*100

*Generate Median home age (Owner-Occupied housing units)
gen median_age = (2011-OOmedian_year_built)

*Generate Percent Black variable
gen perc_black = (population_black/population)*100
replace perc_black = 0 if population == 0

*Generate Percent Hispanic or Latino
gen perc_hispanic = (population_latino/population)*100
replace perc_hispanic = 0 if population == 0

*Generate Percent Male
gen perc_population_male = (population_male/population)*100
replace perc_population_male = 0 if population == 0

*Generate Percent Female
gen perc_population_female = (population_female/population)*100
replace perc_population_female = 0 if population == 0

*Generate Percent Less than High School Equivalent
#delimit ;
gen less_than_HS = (noschool_male + nursery_grade4_male + grade5to6_male + grade7to8_male
+ grade9_male + grade10_male + grade11_male + grade12_nodip_male + noschool_female 
+ nursery_grade4_female + grade5to6_female + grade7to8_female + grade9_female + grade10_female 
+ grade11_female + grade12_nodip_female) ;
#delimit cr

gen perc_less_than_HS = (less_than_HS/population_25older)*100
replace perc_less_than_HS = 0 if population_25older == 0

*Generate Percent of High School Some College (Associate's Degree not Included here)
#delimit ;
gen HS_somecollege = (highschool_male + college_1year_male + college_someyears_male
 + highschool_female + college_1year_female + college_someyears_female) ;
#delimit cr

gen perc_HS_somecollege = (HS_somecollege/population_25older)*100
replace perc_HS_somecollege = 0 if population_25older == 0

*Generate Percent of Bachelor's
gen BA = (bachelors_male + bachelors_female)

gen perc_BA = (BA/population_25older)*100
replace perc_BA = 0 if population_25older == 0

*Generate Percent of Associate's Degree
gen associates = (associates_male + associates_female)

gen perc_associates = (associates/population_25older)*100
replace perc_associates = 0 if population_25older == 0

*Generate Percent of Master's
gen masters = (masters_male + masters_female)

gen perc_masters = (masters/population_25older)*100
replace perc_masters = 0 if population_25older == 0

*Generate Number of Professional Degree
gen professional_degree = (professional_school_male + professional_school_female)

gen perc_prof_degree= (professional_degree/population_25older)*100
replace perc_prof_degree = 0 if population_25older == 0

*Generate Number of Doctorates
gen phd = (doctorate_male + doctorate_female)

gen perc_phd = (phd/population_25older)*100
replace perc_phd = 0 if population_25older == 0

*Generate Home Ownership Rate
gen home_ownership = (OO_units/Occupied_units)*100
replace home_ownership = 0 if Occupied_units == 0

*Generate Percent of Households that Receive Public Assistance
gen perc_public_assistance = (public_assistance/households)*100
replace perc_public_assistance = 0 if households == 0

#delimit ;
local genvars utilitygasheat bottledgasheat electricityheat fueloilheat coalcokeheat woodheat
solarheat otherheat nofuelheat ;
#delimit cr

*Generate Share of Occupied Households that Heat with given substance
foreach var of local genvars {
	gen perc_`var' = (`var'/Occupied_units)*100
	replace perc_`var' = 0 if Occupied_units == 0
	}




***********************************************************************************
**Section 3: Label and Local Variables
***********************************************************************************

*Label All Variables that Need to be Labelled (i.e. generated above)
label var households "Total households"
label var median_age "Median home age (owner-occupied)"
label var mean_income "Mean household income (\\\$)"
label var households_sizeOO "Mean household size (owner-occupied)"
label var share_children "Percent of households with members under 18 (\%)"
label var share_elderly "Percent of households with members over 65 (\%)"
label var perc_black "Percentage Black or African American"
label var perc_hispanic "Percentage Hipanic or Latino"
label var perc_pov "Percent of people below poverty line"
label var median_income "Median household income (\\\$)"
label var perc_less_than_HS "Percent of people with less than HS education"
label var perc_HS_somecollege "Percent of people with high school degree"
label var perc_BA "Percent of people with bachelor's degree"
label var perc_prof_degree "Percent of people with professional degree"
label var perc_phd "Percent of people with doctorate degree"
label var perc_population_male "Percent male"
label var perc_population_female "Percent female"
label var home_ownership "Homeownership rate (owner-occupied/occupied)"
label var perc_public_assistance "Percent of households receiving public assistance income"


***********************************************************************************
**Section 4: Test Variables
***********************************************************************************

#delimit ;
local test_vars median_age mean_income perc_pov median_income population_pl households_sizeOO 
share_children share_elderly perc_black perc_hispanic population perc_population_male perc_population_female 
perc_less_than_HS perc_HS_somecollege perc_BA perc_prof_degree perc_phd 
OO_units housing_units home_ownership OO2005orlater OO2000to2004 OO1990to1999 OO1980to1989 
OO1970to1979 OO1960to1969 OO1950to1959 OO1940to1949 OO1939orearlier perc_utilitygasheat 
perc_bottledgasheat perc_electricityheat perc_fueloilheat perc_coalcokeheat perc_woodheat 
perc_solarheat perc_otherheat perc_nofuelheat perc_associates perc_masters Occupied_units
perc_public_assistance;

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
est store RED_GROUP_count

*Demographic Variables
#delimit ;
local socioeconomics "population perc_population_male perc_population_female 
mean_income median_income  perc_pov perc_black perc_hispanic households_sizeOO share_children 
share_elderly perc_public_assistance" ;
#delimit cr

*Housing Variables
local housing median_age OO_units Occupied_units housing_units home_ownership 
drop walt_id neat_floorarea HS CHILDREN ELDERLY DISABLED HH_SIZE HOME_AGE PC_POVERTY INCOME E_S E_W G_S G_W _merge
drop cons_hh_id normal CMP_CONS WAP IN_CAA GAS_HEAT _mergefinal
save "$home\Census_sum_table.dta", replace

***********************************************************************************
**Section 5: Generate Results in Appendix Table
***********************************************************************************

/* Generate table for paper
Columns:   

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

***************************************************************************
**First Table
***************************************************************************

capture file close myfile

file open myfile using "$output/summary_Census1.tex", write replace 
file write myfile "\begin{table}[H]" _n "{" _n "\small" _n ///
"\centering" _n ///
"\resizebox{\columnwidth}{!}{" _n ///
"\begin{tabular*}{1.35\textwidth}{@{\extracolsep{\fill}}lccc}" _n ///
"\hline\hline" _n ///
"\vspace{.1pt} \\" _n ///
"& Experimental & Experimental & (1) - (2) \\" _n ///
"& encouraged & control & P-values of difference \\" _n ///
"& (1) & (2) & (3) \\" _n ///
"\hline \\" _n ///
"\multicolumn{4}{l}{\textbf{Sociodemographic information}} \\" _n ///
"\vspace{.1pt} \\" _n ///
	
	*********************************************
	**Demographic Information
	*********************************************
	foreach var of local socioeconomics {
		file write myfile "`:var l `var''"
		est restore red_`var'
		mat b=e(mean)
		file write myfile " & " %4.2f (b[1,1]) " & " %4.2f (b[1,2])
		
		matrix input p = (`p`var'')
		file write myfile " & " %4.2f (p[1, 1])
		if abs(`p`var'') < 0.05 file write myfile "\$^{*}"
		else if abs(`p`var'') < 0.01 file write myfile "\$^{**}"
		file write myfile " \\" _n
	}
	
	*Education Levels
	file write myfile "Percent of population $>$ 25 by educational attainment:" _n
	file write myfile " \\" _n
	
	*Less than HS Equivalent
	file write myfile "\hspace{4ex} Less than high school equivalent"
	est restore red_perc_less_than_HS
	mat b=e(mean)
	file write myfile " & " %4.2f (b[1,1]) " & " %4.2f (b[1,2])
	
	matrix input p = (`pperc_less_than_HS')
	file write myfile " & " %4.2f (p[1, 1])
		if abs(`pperc_less_than_HS') < 0.05 file write myfile "\$^{*}"
		else if abs(`pperc_less_than_HS') < 0.01 file write myfile "\$^{**}"
		file write myfile " \\" _n
		
	*HS Equivalent
	file write myfile "\hspace{4ex} High school or equivalent"
	est restore red_perc_HS_somecollege
	mat b=e(mean)
	file write myfile " & " %4.2f (b[1,1]) " & " %4.2f (b[1,2])
	
	matrix input p = (`pperc_HS_somecollege')
	file write myfile " & " %4.2f (p[1, 1])
		if abs(`pperc_HS_somecollege') < 0.05 file write myfile "\$^{*}"
		else if abs(`pperc_HS_somecollege') < 0.01 file write myfile "\$^{**}"
		file write myfile " \\" _n
		
	*Associates
	file write myfile "\hspace{4ex} Associate's degree"
	est restore red_perc_associates
	mat b=e(mean)
	file write myfile " & " %4.2f (b[1,1]) " & " %4.2f (b[1,2])
	
	matrix input p = (`pperc_associates')
	file write myfile " & " %4.2f (p[1, 1])
		if abs(`pperc_associates') < 0.05 file write myfile "\$^{*}"
		else if abs(`pperc_associates') < 0.01 file write myfile "\$^{**}"
		file write myfile " \\" _n
		
	*Bachelor's Degree
	file write myfile "\hspace{4ex} Bachelor's degree"
	est restore red_perc_BA 
	mat b=e(mean)
	file write myfile " & " %4.2f (b[1,1]) " & " %4.2f (b[1,2])
	
	matrix input p = (`pperc_BA')
	file write myfile " & " %4.2f (p[1, 1])
		if abs(`pperc_BA ') < 0.05 file write myfile "\$^{*}"
		else if abs(`pperc_BA') < 0.01 file write myfile "\$^{**}"
		file write myfile " \\" _n
		
	*Masters
	file write myfile "\hspace{4ex} Master's degree"
	est restore red_perc_masters
	mat b=e(mean)
	file write myfile " & " %4.2f (b[1,1]) " & " %4.2f (b[1,2])
	
	matrix input p = (`pperc_masters')
	file write myfile " & " %4.2f (p[1, 1])
		if abs(`pperc_masters') < 0.05 file write myfile "\$^{*}"
		else if abs(`pperc_masters') < 0.01 file write myfile "\$^{**}"
		file write myfile " \\" _n
		
	*Professional School Degree
	file write myfile "\hspace{4ex} Professional school degree"
	est restore red_perc_prof_degree 
	mat b=e(mean)
	file write myfile " & " %4.2f (b[1,1]) " & " %4.2f (b[1,2])
	
	matrix input p = (`pperc_prof_degree')
	file write myfile " & " %4.2f (p[1, 1])
		if abs(`pperc_prof_degree') < 0.05 file write myfile "\$^{*}"
		else if abs(`pperc_prof_degree') < 0.01 file write myfile "\$^{**}"
		file write myfile " \\" _n
		

	*Doctorate Degree
	file write myfile "\hspace{4ex} Doctorate degree"
	est restore red_perc_phd 
	mat b=e(mean)
	file write myfile " & " %4.2f (b[1,1]) " & " %4.2f (b[1,2])
	
	matrix input p = (`pperc_phd')
	file write myfile " & " %4.2f (p[1, 1])
		if abs(`pperc_phd') < 0.05 file write myfile "\$^{*}"
		else if abs(`pperc_phd') < 0.01 file write myfile "\$^{**}"
		file write myfile " \\" _n
		
	*Households 
file write myfile "\hline \\" _n 

file write myfile "Households"
est restore RED_GROUP_count
mat b=e(count)
file write myfile " & " %9.0fc (b[1,1]) " & " %9.0fc (b[1,2]) " & " _n


file write myfile " \\" _n

file write myfile "\hline \\" _n ///
"\end{tabular*} } }" _n  ///
"\footnotesize Note: Columns (1) and (2) report average values. Columns (3) reports the p-values of the differences in means." ///
"P-values reflect clustering at the census block group level." ///
" All variables are at the Census block group level and come from the American Community Survey 5-year estimates (2007-2011). \\" _n ///
"$^{*}$ Significant at the 5 percent level \\" _n ///
"$^{**}$ Significant at the 1 percent level \\" _n ///
"\end{table}"

file close myfile
		
	
***************************************************************************
**Second Table
***************************************************************************
	
capture file close myfile

file open myfile using "$output/summary_Census2.tex", write replace 
file write myfile "\begin{table}[H]" _n "{" _n "\small" _n ///
"\centering" _n ///
"\resizebox{\columnwidth}{!}{" _n ///
"\begin{tabular*}{1.3\textwidth}{@{\extracolsep{\fill}}lccc}" _n ///
"\hline\hline" _n ///
"\vspace{.1pt} \\" _n ///
"& Experimental & Experimental & (1) - (2) \\" _n ///
"& encouraged & control & P-values of difference \\" _n ///
"& (1) & (2) & (3) \\" _n ///
"\hline \\" _n 
	
	file write myfile "\\" _n
	file write myfile "\multicolumn{4}{l}{\textbf{Housing information}} \\" _n ///
	"\vspace{.1pt} \\" _n
	
	foreach var of local housing {
		file write myfile "`:var l `var''"
		est restore red_`var'
		mat b=e(mean)
		file write myfile " & " %4.2f (b[1,1]) " & " %4.2f (b[1,2])
		
		matrix input p = (`p`var'')
		file write myfile " & " %4.2f (p[1, 1])
		if abs(`p`var'') < 0.05 file write myfile "\$^{*}"
		else if abs(`p`var'') < 0.01 file write myfile "\$^{**}"
		file write myfile " \\" _n
	}
	
	
	
	*Owner-Occupied Housing Units Built Since 2005
	file write myfile "Housing units (owner-occupied) built:" _n
	file write myfile " \\" _n
	file write myfile "\hspace{4ex} Since 2005"
	est restore red_OO2005orlater
	mat b=e(mean)
	file write myfile " & " %4.2f (b[1,1]) " & " %4.2f (b[1,2])
	
	matrix input p = (`pOO2005orlater')
	file write myfile " & " %4.2f (p[1, 1])
		if abs(`pOO2005orlater') < 0.05 file write myfile "\$^{*}"
		else if abs(`pOO2005orlater') < 0.01 file write myfile "\$^{**}"
		file write myfile " \\" _n

	
	*Owner-Occupied Housing Units Built Between 2000 and 2004
	file write myfile "\hspace{4ex} 2000-2004"
	est restore red_OO2000to2004
	mat b=e(mean)
	file write myfile " & " %4.2f (b[1,1]) " & " %4.2f (b[1,2])
	
	matrix input p = (`pOO2000to2004')
	file write myfile " & " %4.2f (p[1, 1])
		if abs(`pOO2000to2004') < 0.05 file write myfile "\$^{*}"
		else if abs(`pOO2000to2004') < 0.01 file write myfile "\$^{**}"
		file write myfile " \\" _n



	*Owner-Occupied Housing Units Built Between 1990-1999
	file write myfile "\hspace{4ex} 1990-1999"
	est restore red_OO1990to1999
	mat b=e(mean)
	file write myfile " & " %4.2f (b[1,1]) " & " %4.2f (b[1,2])
	
	matrix input p = (`pOO1990to1999')
	file write myfile " & " %4.2f (p[1, 1])
		if abs(`pOO1990to1999') < 0.05 file write myfile "\$^{*}"
		else if abs(`pOO1990to1999') < 0.01 file write myfile "\$^{**}"
		file write myfile " \\" _n


	
	*Owner-Occupied Housing Units Built Between 1980-1989
	file write myfile "\hspace{4ex} 1980-1989"
	est restore red_OO1980to1989
	mat b=e(mean)
	file write myfile " & " %4.2f (b[1,1]) " & " %4.2f (b[1,2])
	
	matrix input p = (`pOO1980to1989')
	file write myfile " & " %4.2f (p[1, 1])
		if abs(`pOO1980to1989') < 0.05 file write myfile "\$^{*}"
		else if abs(`pOO1980to1989') < 0.01 file write myfile "\$^{**}"
		file write myfile " \\" _n

	
	*Owner-Occupied Housing Units Built Between 1970-1979
	file write myfile "\hspace{4ex} 1970-1979"
	est restore red_OO1970to1979
	mat b=e(mean)
	file write myfile " & " %4.2f (b[1,1]) " & " %4.2f (b[1,2])
	
	matrix input p = (`pOO1970to1979')
	file write myfile " & " %4.2f (p[1, 1])
		if abs(`pOO1970to1979') < 0.05 file write myfile "\$^{*}"
		else if abs(`pOO1970to1979') < 0.01 file write myfile "\$^{**}"
		file write myfile " \\" _n
	
	
	
	*Owner-Occupied Housing Units Built Between 1960-1969
	file write myfile "\hspace{4ex} 1960-1969"
	est restore red_OO1960to1969
	mat b=e(mean)
	file write myfile " & " %4.2f (b[1,1]) " & " %4.2f (b[1,2])
	
	matrix input p = (`pOO1960to1969')
	file write myfile " & " %4.2f (p[1, 1])
		if abs(`pOO1960to1969') < 0.05 file write myfile "\$^{*}"
		else if abs(`pOO1960to1969') < 0.01 file write myfile "\$^{**}"
		file write myfile " \\" _n
	
	
	
	*Owner-Occupied Housing Units Built Between 1950-1959
	file write myfile "\hspace{4ex} 1950-1959"
	est restore red_OO1950to1959
	mat b=e(mean)
	file write myfile " & " %4.2f (b[1,1]) " & " %4.2f (b[1,2])
	
	matrix input p = (`pOO1950to1959')
	file write myfile " & " %4.2f (p[1, 1])
		if abs(`pOO1950to1959') < 0.05 file write myfile "\$^{*}"
		else if abs(`pOO1950to1959') < 0.01 file write myfile "\$^{**}"
		file write myfile " \\" _n
	
	
	*Owner-Occupied Housing Units Built Between 1940-1949
	file write myfile "\hspace{4ex} 1940-1949"
	est restore red_OO1940to1949
	mat b=e(mean)
	file write myfile " & " %4.2f (b[1,1]) " & " %4.2f (b[1,2])
	
	matrix input p = (`pOO1940to1949')
	file write myfile " & " %4.2f (p[1, 1])
		if abs(`pOO1940to1949') < 0.05 file write myfile "\$^{*}"
		else if abs(`pOO1940to1949') < 0.01 file write myfile "\$^{**}"
		file write myfile " \\" _n
	

	
	*Owner-Occupied Housing Units Built Between 1939 or Earlier
	file write myfile "\hspace{4ex} 1939 or earlier"
	est restore red_OO1939orearlier
	mat b=e(mean)
	file write myfile " & " %4.2f (b[1,1]) " & " %4.2f (b[1,2])
	
	matrix input p = (`pOO1939orearlier')
	file write myfile " & " %4.2f (p[1, 1])
		if abs(`pOO1939orearlier') < 0.05 file write myfile "\$^{*}"
		else if abs(`pOO1939orearlier') < 0.01 file write myfile "\$^{**}"
		file write myfile " \\" _n
	
	
	*Share of Owner Occupied Households that Heat with: 
	file write myfile "Percent of housing units (occupied) that heat with:" _n
	file write myfile " \\" _n
	
	*Utility Gas
	file write myfile "\hspace{4ex} Utiliy natural gas"
	est restore red_perc_utilitygasheat
	mat b=e(mean)
	file write myfile " & " %4.2f (b[1,1]) " & " %4.2f (b[1,2])
	
	matrix input p = (`pperc_utilitygasheat')
	file write myfile " & " %4.2f (p[1, 1])
		if abs(`pperc_utilitygasheat') < 0.05 file write myfile "\$^{*}"
		else if abs(`pperc_utilitygasheat') < 0.01 file write myfile "\$^{**}"
		file write myfile " \\" _n
	
	*Bottled Gas
	file write myfile "\hspace{4ex} Bottled, tank, or LP gas"
	est restore red_perc_bottledgasheat
	mat b=e(mean)
	file write myfile " & " %4.2f (b[1,1]) " & " %4.2f (b[1,2])
	
	matrix input p = (`pperc_bottledgasheat')
	file write myfile " & " %4.2f (p[1, 1])
		if abs(`pperc_bottledgasheat') < 0.05 file write myfile "\$^{*}"
		else if abs(`pperc_bottledgasheat') < 0.01 file write myfile "\$^{**}"
		file write myfile " \\" _n
		
	*Electricity
	file write myfile "\hspace{4ex} Electricity"
	est restore red_perc_electricityheat
	mat b=e(mean)
	file write myfile " & " %4.2f (b[1,1]) " & " %4.2f (b[1,2])
	
	matrix input p = (`pperc_electricityheat')
	file write myfile " & " %4.2f (p[1, 1])
		if abs(`pperc_electricityheat') < 0.05 file write myfile "\$^{*}"
		else if abs(`pperc_electricityheat') < 0.01 file write myfile "\$^{**}"
		file write myfile " \\" _n
		
	*Fuel Oil
	file write myfile "\hspace{4ex} Fuel oil, kerosene, etc."
	est restore red_perc_fueloilheat
	mat b=e(mean)
	file write myfile " & " %4.2f (b[1,1]) " & " %4.2f (b[1,2])
	
	matrix input p = (`pperc_fueloilheat')
	file write myfile " & " %4.2f (p[1, 1])
		if abs(`pperc_fueloilheat') < 0.05 file write myfile "\$^{*}"
		else if abs(`pperc_fueloilheat') < 0.01 file write myfile "\$^{**}"
		file write myfile " \\" _n
	
	*There are no Census Block Groups in our sample that have housing units that use coal or coke for heat
	/*
	*Coal or Coke
	file write myfile "\hspace{4ex} Coal or coke"
	est restore red_perc_coalcokeheat
	mat b=e(mean)
	file write myfile " & " %4.2f (b[1,1]) " & " %4.2f (b[1,2])
	
	matrix input p = (`pperc_coalcokeheat')
	file write myfile " & " %4.2f (p[1, 1])
		if abs(`pperc_coalcokeheat') < 0.05 file write myfile "\$^{*}"
		else if abs(`pperc_coalcokeheat') < 0.01 file write myfile "\$^{**}"
		file write myfile " \\" _n
		
		*/
	*Wood
	file write myfile "\hspace{4ex} Wood"
	est restore red_perc_woodheat
	mat b=e(mean)
	file write myfile " & " %4.2f (b[1,1]) " & " %4.2f (b[1,2])
	
	matrix input p = (`pperc_woodheat')
	file write myfile " & " %4.2f (p[1, 1])
		if abs(`pperc_woodheat') < 0.05 file write myfile "\$^{*}"
		else if abs(`pperc_woodheat') < 0.01 file write myfile "\$^{**}"
		file write myfile " \\" _n
		
	*Solar
	file write myfile "\hspace{4ex} Solar"
	est restore red_perc_solarheat
	mat b=e(mean)
	file write myfile " & " %4.2f (b[1,1]) " & " %4.2f (b[1,2])
	
	matrix input p = (`pperc_solarheat')
	file write myfile " & " %4.2f (p[1, 1])
		if abs(`pperc_solarheat') < 0.05 file write myfile "\$^{*}"
		else if abs(`pperc_solarheat') < 0.01 file write myfile "\$^{**}"
		file write myfile " \\" _n
		
	*Other
	file write myfile "\hspace{4ex} Other"
	est restore red_perc_otherheat 
	mat b=e(mean)
	file write myfile " & " %4.2f (b[1,1]) " & " %4.2f (b[1,2])
	
	matrix input p = (`pperc_otherheat')
	file write myfile " & " %4.2f (p[1, 1])
		if abs(`pperc_otherheat') < 0.05 file write myfile "\$^{*}"
		else if abs(`pperc_otherheat') < 0.01 file write myfile "\$^{**}"
		file write myfile " \\" _n
		
	*No Fuel Heat
	file write myfile "\hspace{4ex} No fuel used"
	est restore red_perc_nofuelheat
	mat b=e(mean)
	file write myfile " & " %4.2f (b[1,1]) " & " %4.2f (b[1,2])
	
	matrix input p = (`pperc_nofuelheat')
	file write myfile " & " %4.2f (p[1, 1])
		if abs(`pperc_nofuelheat') < 0.05 file write myfile "\$^{*}"
		else if abs(`pperc_nofuelheat') < 0.01 file write myfile "\$^{**}"
		file write myfile " \\" _n


*Households 
file write myfile "\hline \\" _n 

file write myfile "Households"
est restore RED_GROUP_count
mat b=e(count)
file write myfile " & " %9.0fc (b[1,1]) " & " %9.0fc (b[1,2]) " & " _n


file write myfile " \\" _n

file write myfile "\hline \\" _n ///
"\end{tabular*} } }" _n  ///
"\footnotesize Note: Columns (1) and (2) report average values. Columns (3) reports the p-values of the differences in means." ///
" P-values reflect clustering at the census block group level." ///
" All variables are at the Census block group level and come from the American Community Survey 5-year estimates (2007-2011). \\" _n ///
"$^{*}$ Significant at the 5 percent level \\" _n ///
"$^{**}$ Significant at the 1 percent level \\" _n ///
"\end{table}"

file close myfile




