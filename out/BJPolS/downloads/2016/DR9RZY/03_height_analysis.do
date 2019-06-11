/* 	03_height_analysis.do :

	This file creates all figures and tables for the paper and appendix. */


* Bootstrap settings	
set seed 123  	
local reps 1000 /* For bootstrap. */



* Tables	

local summarystats_table 	1


local printappendix			1  
local RF_tables 			1 
	local RFmodels reg logit probit  
local IV1st_tables 			1 
local IV2nd_tables 			1 
	local IVmodels reg ivreg2 probit ivprobit  
local panel_results 		1 
local youth_table 			1 
local health_table			1
local riskaversion_table	1

local make_final_tables		1
	local finaltable1and5 	1 // Table 1 (Support conservative -- RF)  and Table 5 (Support conservative -- OLS & IV2nd)
	local finaltable2 		1 // Table 2 (Other dependent vars -- RF & OLS & IV2nd) 
	local finaltable3 		1 // Table 3 (Child height and parent characteristics)
	local finaltable4 		1 // Table 4 (IV 1st) 

	
* Figures

local height_histogram_figure 		1
local income_distribution_figure 	1
local RF_figure 					1
local RF_figure_otherdepvars 		1
local iv1st_figure 					1
	local make_iv1st_data 			1 /* Can set to zero if bootstrap dataset is already generated */
local iv2nd_figure 					1 
	local make_iv2nd_data 			1 /* Can set to zero if bootstrap dataset is already generated */
local youth_figure 					1
	local make_youth_data 			1
local height_correlates_figure 		1
	local make_heightcorr_data 		1
local over_time 					1
	local gen_parmest 				1
	local make_graphs 				1
	
	
	
****** Define specifications 

local dependent_variables 		cvote convote  
local other_dependent_variables gjo pso peo ulo  
local all_dependent_variables 	`dependent_variables' `other_dependent_variables'   
local instrument 				height 

local regional_variables 		newregion? newregion??  
	/* This is more disaggregated than england wales scotland northern_ireland.  
	   Using the wildcard ? omits the single newregion variable */ 
	   
local personal_variables 		married white yrs_school non_christian catholic nc_christian /* Omitted: no_religion */
local parents_schooling 		dadsomequal dadfurthered daduni momsomequal momfurthered momuni /* Omitted: dadnoqual momnoqual */ 

local spec1  age `regional_variables'
local spec2 `spec1' `personal_variables'   
local spec3 `spec2' gcse_points
local spec4 `spec2' `parents_schooling'  
local spec5 `spec2' father_hg 

local controls1  `spec1' female 
local controls2  `spec2' female 
local controls3  `spec3' female 
local controls4  `spec4' female 
local controls5  `spec5' female 
local controls6  `spec1' female 
local controls7  `spec2' female 
local controls8  `spec1' female 
local controls9  `spec2' female 
local controls10 `spec1' 
local controls11 `spec2' 
local controls12 `spec1' 
local controls13 `spec2' 

local samples1  if age>17 & northern_ireland==0
local samples2  if age>17 & northern_ireland==0
local samples3  if age>17 & northern_ireland==0
local samples4  if age>17 & northern_ireland==0
local samples5  if age>17 & northern_ireland==0
local samples6  if prime_age==1 & northern_ireland==0
local samples7  if prime_age==1 & northern_ireland==0
local samples8  if age>17
local samples9  if age>17
local samples10 if age>17 & northern_ireland==0 & female==1
local samples11 if age>17 & northern_ireland==0 & female==1
local samples12 if age>17 & northern_ireland==0 & male==1
local samples13 if age>17 & northern_ireland==0 & male==1

forvalues j=1/13 {
local column`j' `controls`j'' `samples`j''
}


local varstokeep wave female male hid xrwtuk2 newregion prime_age england northern_ireland scotland wales ///
	`all_dependent_variables' wincome `instrument' ///
	`spec2'  gcse_points `parents_schooling' father_hg no_religion /// 

cd $log

		
		
		
****** TABLES
   
 * SUMMARY STATS TABLE 

 if `summarystats_table'==1 { 

use `varstokeep' using $cleandta/height1416.dta , clear 

log using $log/summarystats , replace

foreach wavenumber in 14 16 {
	preserve
		keep if age>17 & northern_ireland==0 & wave==`wavenumber'
		svyset [pweight=xrwtuk2]   // See BHPS documentation for cross-sectional weights excluding Northern Ireland 

file open summarystats`wavenumber' using summarystats`wavenumber'.tex, write replace
file write summarystats`wavenumber' "\begin{tabular}{lccc}" 
file write summarystats`wavenumber' _newline "&" "&" "&" "\\" 
file write summarystats`wavenumber' _newline "\textbf{Variable}" "&" "\textbf{Whole}" "&" "\textbf{Women}" "&" "\textbf{Men}" "\\"
file write summarystats`wavenumber' _newline "" "&" "Mean" "&" "Mean" "&" "Mean" "\\"
file write summarystats`wavenumber' _newline "" "&" "(Std. Error)" "&" "(Std. Error)" "&" "(Std. Error)" "\\"
file write summarystats`wavenumber' _newline "&" "&" "&" "\\" 

foreach var of varlist `all_dependent_variables' wincome `instrument' 		///
						age `personal_variables' no_religion gcse_points 	///
						england wales scotland { 

	local longname: variable label `var' 
	
	if `"`var'"'=="convote" & `wavenumber'==14 local longname "Voted Conservative (2001 election)"
	if `"`var'"'=="convote" & `wavenumber'==16 local longname "Voted Conservative (2005 election)"

	
	* Policy preference questions are intermittently asked in BHPS 
	
	if      inlist(`"`var'"',"ulo") 			& `wavenumber'==14	di "No `var' for wave 14"
	else if inlist(`"`var'"',"gjo","pso","peo") & `wavenumber'==16 	di "No `var' for wave 16"

	else {

	di "Whole sample `var' in wave `wavenumber'"
	sum `var' , d				/* Produce std deviations for use in paper */
	quietly svy  : mean `var'  	/* Unlike -sum-, -mean- supports survey weights */
	matrix statsA=r(table)
	local A_mean`var'=round(statsA[1,1],.01)
	local A_stderr`var'=round(statsA[2,1],.01)

	di "Women sample `var' in wave `wavenumber'"
	sum `var' if female==1 , d
	quietly svy  : mean `var' if female==1 
	matrix statsF=r(table)
	local F_mean`var'=round(statsF[1,1],.01)
	local F_stderr`var'=round(statsF[2,1],.01)

	di "Men sample `var' in wave `wavenumber'"
	sum `var' if male==1 , d
	quietly svy  : mean `var' if male==1 
	matrix statsM=r(table)
	local M_mean`var'=round(statsM[1,1],.01)
	local M_stderr`var'=round(statsM[2,1],.01)
	
	file write summarystats`wavenumber' _newline "`longname'" "&" (`A_mean`var'') "&" (`F_mean`var'') "&" (`M_mean`var'') "\\"
	cap assert inlist(`var',0,1,.)
	if _rc {  /* Reporting of std error is suppressed for dummy variables */
		file write summarystats`wavenumber' _newline "" "&" "(" (`A_stderr`var'') ")" "&" "(" (`F_stderr`var'') ")" "&" "(" (`M_stderr`var'') ")" "\\"
	}
	file write summarystats`wavenumber' _newline "&" "&" "&" "\\" 
} /* else for other_dependent_variables */
} /* varlist loop */
	
	quietly xi: reg cvote `instrument' `spec1' female , vce(cluster hid)

	count if e(sample)
	local A_obs_`wavenumber' = r(N) 

	count if e(sample) & female==1
	local F_obs_`wavenumber' = r(N) 

	count if e(sample) & male==1
	local M_obs_`wavenumber' = r(N) 

	file write summarystats`wavenumber' _newline "&" "&" "&" "\\" 
	file write summarystats`wavenumber' _newline "Obs." "&" (`A_obs_`wavenumber'') "&" (`F_obs_`wavenumber'') "&" (`M_obs_`wavenumber'') "\\" 
	
	file write summarystats`wavenumber' _newline "&" "&" "&" "\\" 
	file write summarystats`wavenumber' _newline "\hline" 
	file write summarystats`wavenumber' _newline "\end{tabular}" 
	file close summarystats`wavenumber' 
restore
} /* wave loop */
	log close
} /* summarystatstable loop */
*


* REDUCED FORM TABLES
	
if `RF_tables'==1 {
log using $log/log_RF_tables , replace

use `varstokeep' using $cleandta/height1416.dta , clear

* Settings for all RF tables
local tablevars `instrument' age female `personal_variables' gcse_points `parents_schooling' father_hg	
local columnlabels Whole1 Whole2 Cog Par DadHG Prime1 Prime2 IncNI1 IncNI2 W1 W2 M1 M2

* Settings for all RF regressions
local clusteropts vce(cluster hid)
	
foreach depvar of local all_dependent_variables { 
foreach wavenumber in 14 16 {	
	preserve
	keep if wave==`wavenumber'

	* Policy preference questions are intermittently asked in BHPS
	if 		inlist(`"`depvar'"',"ulo") 			 	& `wavenumber'==14 di "No `depvar' for wave 14"
	else if inlist(`"`depvar'"',"gjo","pso","peo") 	& `wavenumber'==16 di "No `depvar' for wave 16"
	
	else {

	foreach model of local RFmodels { 	

	else {
	
	* Options for tables
	if inlist(`"`depvar'"', "ulo", "gjo", "peo", "pso") & `"`model'"'=="logit"  local model ologit
	if inlist(`"`depvar'"', "ulo", "gjo", "peo", "pso") & `"`model'"'=="probit" local model oprobit

	local table `model'RF`depvar'`wavenumber' 

	if `"`model'"'=="reg" {
		local tablestats r2 F  /* Define test statistics to be called by -est2vec */
		local modelname "OLS"
	}

	else if `"`model'"'=="logit" {
		local tablestats chi2
		local modelname "Logit"
		local marginsopts dydx(*) post
	}

	else if `"`model'"'=="ologit" {
		local tablestats chi2
		local modelname "OLogit"
		local marginsopts dydx(*) post predict(outcome(2))
	}

	else if `"`model'"'=="probit" {
		local tablestats chi2
		local modelname "Probit"
		local marginsopts dydx(*) post
	}
	
	else if `"`model'"'=="oprobit" {
		local tablestats chi2
		local modelname "OProbit"
		local marginsopts dydx(*) post predict(outcome(2))
	}
	
	forvalues j=1/13 {
		
		`model' `depvar' `instrument' `column`j'' , `clusteropts'
	
		* Only save estimates needed for final tables, else system limits will be exceeded
		if `"`model'"' == "reg" {
			if (`"`depvar'"'=="cvote" & `wavenumber'==16) 						/// Tables 1 & 2
			 | (`"`depvar'"'=="cvote" & `wavenumber'==14 & inlist(`j',2,4))  	/// Table 1 (10)-(11)  [for the old final table]
			 | (`"`depvar'"'!="cvote" & `j'==2) 								/// Table 5
			 eststo RF`depvar'`wavenumber'_`j'
									estadd local ageregion 				"X"									
		if !inrange(`j',10,13)		estadd local agesexregion 			"X"
		if !inrange(`j',10,13)		estadd local sex 					"X"
		if !inlist(`j',1,6,8,10,12) estadd local extended 				"X"
		if `j'==3 					estadd local cogability 			"X"
		if `j'==4					estadd local parentsschool 			"X"
		if `j'==5					estadd local fatherhgs 				"X"
		if inrange(`j',6,7)			estadd local primeageonly 			"X"
		if inrange(`j',8,9)			estadd local incNIreland 			"X"
		if `wavenumber'==14			estadd local wave14 				"X"
			}
			
		if `"`model'"' != "reg" {
			local chi2=round(e(chi2),.001) 	/* Storing chi2-stat, which is obliterated by -margins, post- */
			margins, `marginsopts'  /* Use -margins, dydx() to report the average marginal effects at sample means. */
			estadd scalar chi2 = `chi2'
		}
		
		if `j'==1 {  /* -est2tex- requires stats to be specified with the first -est2vec-  */
			if 		`"`model'"' == "reg" est2vec `table' , e(`tablestats') vars(`tablevars' _cons) name(`model'`j') replace  
			else if `"`model'"' != "reg" est2vec `table' , e(`tablestats') vars(`tablevars') 	   name(`model'`j') replace  /* No constant when evaluating marginal effects at means */
		}

		else est2vec `table', addto(`table')  name(`model'`j')
	} /* columns loop */
		
	if `printappendix'==1 {
		est2rowlbl `tablevars' , replace saving addto(`table') 
		est2tex `table' , 	 preserve replace mark(starb) digits(3) flexible(0) fancy label collabels(`columnlabels')
	} /* printappendix */
	
} /* else for wave 14 probit */ 
} /* model loop */
} /* else for other depvars */
	restore
} /* wave loop */
} /* depvar loop */
	log close
} /* RF_tables loop */
*
 
 
 * IV 1st STAGE TABLES
 
 if `IV1st_tables'==1 {
log using $log/log_IV1st_tables , replace

use `varstokeep' using $cleandta/height1416.dta , clear

* Settings for all IV1 tables
	label variable wincome 	"Real Income"
	label variable nc_christian 		"Non-Cath.~Christian"
	label variable yrs_school 			"Yrs school"
	label variable father_hg 			"Father HGS"

* Settings for all IV1 regressions
local clusteropts 	cluster(hid)
local varofinterest (wincome=`instrument')	
	
foreach wavenumber in 14 16 {	
	preserve 
	keep if wave==`wavenumber'
	
foreach depvar /* of local all_dependent_variables */ in cvote { 
	local columnlabels Whole1 Whole2 Cog Fam1 Fam2 Prime1 Prime2 IncNI1 IncNI2 Women1 Women2 Men1 Men2  		
	local tablevars `instrument' age female `personal_variables' gcse_points `parents_schooling' father_hg	
	local numberofcolumns 13
	
	* Policy preference questions are intermittently asked in BHPS

	if      inlist(`"`depvar'"',"ulo") 				& `wavenumber'==14 di "No `depvar' for wave 14"
	else if inlist(`"`depvar'"',"gjo","pso","peo") 	& `wavenumber'==16 di "No `depvar' for wave 16"
	
	else {

	local table regIV1`depvar'`wavenumber'
	
	forvalues j=1/`numberofcolumns' {
		xi: ivreg2 `depvar' `varofinterest' `column`j'' , `clusteropts' /* Run the second stage to generate F-stat on excluded instruments */
		local firststageF=round(e(widstat),.001) 	
		
		xi: reg wincome `instrument' `column`j'' , `clusteropts'
		
		* Only save estimates needed for final table, else system limits will be exceeded
		if `"`depvar'"'=="cvote" & `wavenumber'==16 & inlist(`j',1,2,10,11,12,13) eststo IV1`depvar'`wavenumber'_`j'
		
									estadd local ageregion 				"X"	
		if !inrange(`j',10,13)		estadd local sex 					"X"
		if !inlist(`j',1,6,8,10,12) estadd local extended 				"X"
									estadd local F_exc = `firststageF'  // For final table
		eret2 scalar F_stat_excluded = `firststageF', replace 			// For appendix tables
		if `j'==1 	est2vec `table' , e(F_stat_excluded F r2) vars(`tablevars' _cons) name(iv1st`j')
		else        est2vec `table' , addto(`table')  								  name(iv1st`j')
	}
		
	
	if `printappendix'==1 {
		est2rowlbl `tablevars' , replace saving addto(`table')  
		est2tex `table' , 	 preserve replace mark(starb) digits(3) flexible(0) fancy label collabels(`columnlabels')
	} /* printappendix */
	
} /* else for other depvars */
} /* depvar loop */
	restore
} /* wave loop */
	log close
} /* IV1st_tables loop */
* 
 
  
  
 * OLS and IV 2nd STAGE TABLES
 
if `IV2nd_tables'==1 {
log using log_IV2nd_tables , replace
use `varstokeep' using $cleandta/height1416.dta , clear

* Settings for tables
*eststo clear 
	label variable wincome "Real Income"
	label variable nc_christian 	 "Non-Cath. Christian"
	label variable yrs_school 	 	 "Yrs school"
	label variable father_hg 		 "Father HGS"
	label variable cvote 		 	 "Support"
	
foreach wavenumber in 14 16 {	
	preserve
	keep if wave==`wavenumber'

foreach depvar of local all_dependent_variables { 

	* Policy preference questions are intermittently asked in BHPS

	if      inlist(`"`depvar'"',"ulo") 				& `wavenumber'==14 di "No `depvar' for wave 14"
	else if inlist(`"`depvar'"',"gjo","pso","peo") 	& `wavenumber'==16 di "No `depvar' for wave 16"

	
else {
	
	foreach model of local IVmodels { 	
	
if inlist(`"`depvar'"',"ulo","gjo","peo","pso") & inlist(`"`model'"',"probit","ivprobit") di "probit/ivprobit only for dummy depvars" 
else if (`"`model'"'=="probit" | `"`model'"'=="ivprobit") & `wavenumber'==14 di "No probit/ivprobit for wave 14"

else {	

	local table `model'IV2`depvar'`wavenumber' 

	if `"`model'"'=="reg" {
		local tablestats r2 F
		local varofinterest wincome	
		local clusteropts vce(cluster hid) 
		}
		
	else if `"`model'"'=="ivreg2" {
		local tablestats r2 F ARconf
		local varofinterest (wincome=`instrument')	
		local clusteropts cluster(hid)
		}

	else if `"`model'"'=="probit" {
		local tablestats chi2
		local varofinterest wincome	
		local clusteropts cluster(hid)
		}	
	
	else if `"`model'"'=="ivprobit" {  /* Remember to put instrumented vars after all others so -ivprobit- doesn't error */
		local tablestats chi2
		local varofinterest (wincome=`instrument')	
		*local clusteropts twostep vce(bootstrap, cluster(hid) /* seed(`i') */ reps(500))
		local clusteropts difficult vce(cluster hid) iterate(500) technique(bfgs)  /* default technique is "backed up" */
		}

		local columnlabels 		Whole1 Whole2 Cog Fam1 Fam2 Prime1 Prime2 IncNI1 IncNI2 Women1 Women2 Men1 Men2  		
		local tablevars 		wincome age female `personal_variables' gcse_points `parents_schooling' father_hg	
		local numberofcolumns 	13
		
/*	if `"`depvar'"' == "turnout" {
		local columnlabels 	  	`columnlabels' FreeTime	
		local tablevars 	  	`tablevars'	   freetime
		local numberofcolumns 	14
	}
*/	
	forvalues j=1/`numberofcolumns' {
		
		xi: `model' `depvar' `controls`j'' `varofinterest' `samples`j'' , `clusteropts'

		* Only save estimates needed for final table, else system limits will be exceeded
		if `"`model'"'=="reg" 	 {
			if (`"`depvar'"'=="cvote" & `wavenumber'==16) 						/// Tables 1 & 2
			 | (`"`depvar'"'=="cvote" & `wavenumber'==14 & inlist(`j',2,4))		/// Table 1 (10)-(11)
			 | (`"`depvar'"'!="cvote" & `j'==2)				/// Table 5
			eststo OLS`depvar'`wavenumber'_`j' 
		}
		if `"`model'"'=="ivreg2" {
			if (`"`depvar'"'=="cvote" & `wavenumber'==16) 						/// Tables 1 & 2
			 | (`"`depvar'"'=="cvote" & `wavenumber'==14 & inlist(`j',2,4))		/// Table 1 (10)-(11)
			 | (`"`depvar'"'!="cvote" & `j'==2)				/// Table 5
			eststo IV2`depvar'`wavenumber'_`j'
 		}		
									estadd local ageregion 				"X"									
		if !inrange(`j',10,13)		estadd local agesexregion 			"X"
		if !inrange(`j',10,13)		estadd local sex 					"X"
		if !inlist(`j',1,6,8,10,12) estadd local extended 				"X"
		if `j'==3 					estadd local cogability 			"X"
		if `j'==4					estadd local parentsschool 			"X"
		if `j'==5					estadd local fatherhgs 				"X"
		if inrange(`j',6,7)			estadd local primeageonly 			"X"
		if inrange(`j',8,9)			estadd local incNIreland 			"X"
		if `wavenumber'==14			estadd local wave14 				"X"
		
		local chi2=round(e(chi2),.001) 	/* Storing chi2-stat, which is obliterated by -margins, post- */
		cap noisily rivtestRAJ, ci 		/* Produce AR confidence interval. Use -capture- as the command errors for non-IV models. */
		local ar`j'=r(ar_cset)
		estadd local ARconf "`r(ar_cset)'"
		if inlist(`"`model'"',"probit","ivprobit")  margins, dydx(*) post /* -margins, dydx()- reports avg marginal effects at sample means. */
		estadd scalar chi2 = `chi2'
		
		if `j'==1 {
		if inlist(`"`model'"',"reg","ivreg2")	   est2vec `table' , e(`tablestats') vars(`tablevars' _cons) name(`model'`j') replace  
		if inlist(`"`model'"',"probit","ivprobit") est2vec `table' , e(`tablestats') vars(`tablevars') 		 name(`model'`j') replace  /* No constant when evaluating marginal effects at means */
		}
		
		else est2vec `table', addto(`table')  name(`model'`j')
	}
			
	if `printappendix'==1 {
		est2rowlbl `tablevars' , replace saving addto(`table') 
		est2tex `table' , 	 preserve replace mark(starb) digits(3) flexible(0) fancy label collabels(`columnlabels')
	} /* printappendix */

} /* else for non-dummies and wave 14 probit/ivprobit */		
} /* model loop */
} /* else for other depvars */
} /* depvar loop */
	restore
} /* wave loop */
	log close

} /* IV2nd_tables loop */
*



 * YOUTH TABLE
 
 if `youth_table'==1 {
log using $log/youth , replace
use $cleandta/height1416.dta , clear 
	
local clusteropts vce(cluster hid)
local modelname OLS
	

merge 1:1 pid wave using $cleandta\height1416_youth

keep if age<18 & northern_ireland==0

keep `varstokeep' mom* dad* parents* 
	
foreach wavenumber in 14 16 {
	local table youth`wavenumber'
	local parentsincome parents_wincome`wavenumber' 
	label var `parentsincome' "Parents' real income (000s)"

	foreach parent in mom dad {
		local `parent'vote `parent'_cvote`wavenumber'
		local `parent'school `parent'_yrs_school`wavenumber'
	}
	label var `momvote' "Mother's Support"
	label var `dadvote' "Father's Support"
	label var `momschool' "Mother's yrs school"
	label var `dadschool' "Father's yrs school"

	preserve
	keep if wave==`wavenumber'
	
	local youthcontrols female white non_christian catholic nc_christian
	local youthvars `momvote' `dadvote' `momschool' `dadschool' `parentsincome'
	local tablevars `youthvars' age `youthcontrols' 
	
	local i=1
	foreach var of local youthvars {
		reg `instrument' `var' age i.newregion /*`spec1'*/ `youthcontrols' , `clusteropts'
		if `i'==1 	est2vec `table' , e(F r2) vars(`tablevars' _cons) name(Y`i')
		else 		est2vec `table' , addto(`table') name(Y`i')
		if `wavenumber'==16	{
			eststo Y`var'`wavenumber'		
			estadd local agesexregion 			"X"
			estadd local extended 				"X"
		}
		local colabellist `labellist' Y`i'
		local ++i
	}
	
	if `printappendix'==1 {
		est2rowlbl `tablevars' , replace saving addto(`table') 
		est2tex `table' , preserve replace mark(starb) digits(3) flexible(0) fancy label collabels(`colabellist')
	} /* printappendix */

	restore
} /* wave loop */
	log close
} /* youth_table loop */
*




if `health_table'== 1  {
* locals defining specs
local personal_variables 	married white yrs_school non_christian catholic nc_christian
local parents_schooling 	dadsomequal dadfurthered daduni momsomequal momfurthered momuni 
local cognition 			gcse_points 
local sample 				northern_ireland==0 & age>17
local dropvars 				*new*
local wave 					wave==16
local esttabopts 			b(3) se(3) star(* 0.10 ** 0.05 *** 0.05) label replace

local healthvars 			avg_inpatient avg_NHS
local healthproblems 		avg_healthproblems


use $cleandta/height, clear

* Variable construction for health care use
label define visits 0 "None" 1 "One or Two" 2 "Three to Five" 3 "Six to Ten" 4 "More than Ten"

gen outpatient_visits		=.
replace outpatient_visits	=hl2hop if inrange(hl2hop,0,4)
label var outpatient_visits   	"Number of outpatient visits in previous year (ordered)"

recode hl2gp (1=0) (2=1) (3=2) (4=3) (5=4) (else=.), gen(GP_visits)
label var GP_visits 			"Number of GP visits in previous year (ordered)"

label values GP_visits outpatient_visits visits

gen gpvisit=.
replace gpvisit=0 if GP_visits==0
replace gpvisit=1 if inrange(GP_visits,1,4)

gen 	inpatient_visits=.
replace inpatient_visits=0 if hosp==2
replace inpatient_visits=hospd if hospd>-1  & (hospnhs==1 ) & female==0 /* days in NHS hospital */
replace inpatient_visits=hospd if hospd>-1  & (hospnhs==1 ) & (hospch==3) & (female==1  & age<46) /* days in NHS hospital if none were for childbirth */
replace inpatient_visits=hospd if hospd>-1  & (hospnhs==1 ) & (female==1  & age>45) /* Didn't ask childbirth question to women over 45 */
label var inpatient_visits   "Number of inpatient visits in previous year"

* Generate totals and average per individual
bys pid: egen total_inpatient 	 =	sum(inpatient_visits) 	if inrange(wave,1,16)
bys pid: egen avg_inpatient   	 =	mean(inpatient_visits) 	if inrange(wave,1,16)
bys pid: egen avg_healthproblems = 	mean(healthproblems) 	if inrange(wave,1,16)
label var avg_healthproblems "Average Health Problems (0-13), waves 1-16"
label var avg_inpatient 	 "Average Inpatient Visits, waves 1-16"

* Similar exercise as above, but use only wave 11-16 data (which includes additional questions about cancer and strokes)
foreach x in a b c d e f g h i j k l m n o {  		
	local healthv2_`x' : variable label hlprb`x' 
	gen healthproblemv2_`x' = hlprb`x'==1 if hlprb`x' >=0 & inrange(wave,11,18)
	label var healthproblemv2_`x' "`healthv2_`x''"
	}

egen healthproblems_v2=rowtotal(healthproblemv2_a - healthproblemv2_o) if inrange(wave,11,18), missing
bys pid: egen avg_healthproblemsv2=mean(healthproblems_v2) if inrange(wave,1,16)
label var avg_healthproblemsv2 "Average Health Problems (0-15), waves 11-16"


* NHS Health Services (includes health visitor, home help, meals on wheels, social worker, other, chiropracty, psychiatric, 
* alternative medicine, speech therapist, other specialist, family planning clinic)
foreach letter in a b c d e f g h i j k l m {
 local healthserv_`letter': variable label hlsv`letter'
	gen 		NHSservices_`letter' = hlsv`letter'==1 if hlsv`letter'>=0 & hlsv`letter'n==1
	replace 	NHSservices_`letter' = 0 if hlsv`letter'==0
	label var 	NHSservices_`letter' "`healthserv_`letter''"
}

egen NHSuse=rowtotal(NHSservices_e - NHSservices_l gpvisit) , missing
bys pid: egen avg_NHSuse=mean(NHSuse) if inrange(wave,5,16)  // Many questions are not asked until wave 5 
label var avg_NHSuse "Total of NHS health services used, avg"



* Direct effect of height on healthvars

foreach depvar of local healthvars {
eststo C`depvar' : reg `depvar' height wincome female age `personal_variables' `healthproblems' i.newregion if `sample' & `wave', vce(cluster hid)
eststo U`depvar' : reg `depvar' height wincome female age `personal_variables' 			 	 	i.newregion if `sample' & `wave', vce(cluster hid)
}

esttab Cavg_inpatient Uavg_inpatient Cavg_NHS Uavg_NHS	using $log/height_utilization.tex ///
		, `esttabopts' stats(N F r2, labels("N" "F-Stat" "R-sq") fmt(%9.0f %9.3f %9.3f)) 	///
		mtitles("Conditional" "Unconditional" "Conditional" "Unconditional") drop(`dropvars') 
eststo clear


* Control for healthvars in reduced form
foreach healthvar of local healthvars {
eststo C`healthvar': reg cvote 	height female age `personal_variables' `healthvar' `healthproblems'		i.newregion if `sample' & `wave', vce(cluster hid)
eststo U`healthvar': reg cvote 	height female age `personal_variables' `healthvar' 						i.newregion if `sample' & `wave', vce(cluster hid)
}
esttab Cavg_inpatient Uavg_inpatient Cavg_NHS Uavg_NHS using $log/height_RF_health.tex ///
	, `esttabopts' stats(N F r2, labels("N" "F-Stat" "R-sq") fmt(%9.0f %9.3f %9.3f))	///
	 mtitles("Conditional" "Unconditional" "Conditional" "Unconditional") drop(`dropvars')


* Control for healthvars in IV

foreach healthvar of local healthvars {
eststo C`healthvar': ivreg2 cvote 	(wincome=height) female age `personal_variables' `healthvar' `healthproblems' 	i.newregion if `sample' & `wave', robust cluster(hid)
eststo U`healthvar': ivreg2 cvote 	(wincome=height) female age `personal_variables' `healthvar' 					i.newregion if `sample' & `wave', robust cluster(hid)
}

esttab Cavg_inpatient Uavg_inpatient Cavg_NHS Uavg_NHS using $log/height_IV2_health.tex ///
	, `esttabopts' stats(N F r2, labels("N" "F-Stat" "R-sq") fmt(%9.0f %9.3f %9.3f ))	///
		mtitles("Conditional" "Unconditional" "Conditional" "Unconditional") drop(`dropvars') 
eststo clear

}
*


if `riskaversion_table'==1 {
* locals defining specs
local personal_variables married white yrs_school /* Alternatively: higher_degree first_degree a_level 
					  */ non_christian catholic nc_christian /* Omitted: no_religion */
local sample northern_ireland==0 & age>17
local wave 					wave==16
local esttabopts 			b(3) se(3) star(* 0.10 ** 0.05 *** 0.05) label replace stats(N F r2, labels("Obs" "F-Stat" "R-sq") fmt(%9.0f %9.3f %9.3f )) drop(*new*)

use $cleandta/height, clear
*drop newregion1 newregion2 newregion3 newregion4 newregion5 newregion6 newregion7 newregion8 newregion9 newregion10 newregion11 newregion12

* Variable construction for risk

gen risk18=riska if inrange(riska,1,10) & wave==18
bys pid: egen risk=max(risk18) 
drop risk18

* Verify median and mode of ordinal risk seeking variable is 5
foreach stat in median mode {
	egen `stat'risk = `stat'(risk)
	assert `stat'risk==5
}

* Create risk propensity dummy
gen risk_dummy=inrange(risk,6,10) if inrange(risk,1,10)
label var risk_dummy "Risk-seeking"
local riskvar risk_dummy
 
* Reduced form:
eststo RF: 	reg 	cvote height 			female age `personal_variables' `riskvar' 	i.newregion if `sample' & `wave', vce(cluster hid)
eststo IV2: ivreg2 	cvote (wincome=height) 	female age `personal_variables' `riskvar' 	i.newregion if `sample' & `wave', robust cluster(hid)

esttab RF IV2 using $log/height_riskdummy.tex ///
	, `esttabopts' mtitles("Reduced Form" "IV 2nd")  
eststo clear


}
*



* PANEL DATA 
if `panel_results'==1 {
log using $log/panel_results , replace
use cvote wincome age year pid female male `instrument' northern_ireland ///
	if age>17 & northern_ireland==0 using $cleandta/height , clear
xtset pid year 

local depvar cvote
local xtregspec i.year
tab year, gen(year) /* -xtoverid- does not support omitted variable notation produced by i.year  */

local table xtregwincome

xtreg `depvar' wincome `xtregspec' , fe vce(cluster pid)
	est2vec `table' , e(r2 F) vars(wincome) name(Whole) replace 
xtreg `depvar' wincome `xtregspec' if female==1 , fe vce(cluster pid)
	est2vec `table', addto(`table')  name(Women)
xtreg `depvar' wincome `xtregspec' if male==1 , fe vce(cluster pid)
	est2vec `table', addto(`table')  name(Men)

if `printappendix'==1 {
	est2rowlbl wincome , replace saving addto(`table') 
	est2tex `table' , preserve replace mark(starb) digits(3) flexible(0) fancy label 
	erase `table'_rowlbl.dta
	erase `table'_tbl.dta
} /* printappendix */

xtreg `depvar' wincome year2-year18 , re /* Omit vce(cluster pid), instead include as option in -xtoverid- */
xtoverid , cluster(pid)  /* -hausman- test does not support clustering, and -suest- is unavailable after -xtreg- */
xtreg `depvar' wincome year2-year18 if female==1 , re
xtoverid , cluster(pid)
xtreg `depvar' wincome year2-year18 if male==1 , re 
xtoverid , cluster(pid)  /* Test statistic rejects validity of random effects model for all depvars, in all samples */

local table xtlogitwincome

xtlogit `depvar' wincome `xtregspec' , fe or
	est2vec `table' , e(chi2 ll) vars(wincome) name(Whole) replace 
xtlogit `depvar' wincome `xtregspec' if female==1 , fe or
	est2vec `table', addto(`table')  name(Women)
xtlogit `depvar' wincome `xtregspec' if male==1 , fe or
	est2vec `table', addto(`table')  name(Men)

if `printappendix'==1 {
	est2rowlbl wincome , replace saving addto(`table') 
	est2tex `table' , preserve replace mark(starb) digits(3) flexible(0) fancy label 
} /* printappendix */

	clear
	log close
	} /* panel_results */
*


if `make_final_tables'==1 {
log using $log/make_final_tables , replace

local esttabopts 	nonotes b(3) se(3) star(* 0.10 ** 0.05 *** 0.05) compress nolines nonumbers


if `finaltable1and5'==1 {
/* Not sure how to switch order of model titles and numbers, so we use this workaround */

local columnnames 	  "								& Whole & Whole & Prime & Prime &  Cog  &  Fam  &  Fam  &   F   &   F   &   M    &  M   \\ "
local columnnums 	  "								& (1)   & (2)   &  (3)  & (4)   &  (5)  &  (6)  &  (7)  &  (8)  &  (9)  &  (10)  & (11) \\ \hline"
local reducedformname "					   			& 	    &       &	    & 	   	&	   	&	   	& 	   	& 	   	&	   	& 	     &	    \\"
local secondstagename "\textbf{IV Second Stage:}  	&       & 	    &	    & 	   	&	   	&	   	& 	   	& 	   	&	   	& 	     &	    \\"
local OLSname 		  "\textbf{OLS:}  				&       & 	    &	    & 	   	&	   	&	   	& 	   	& 	   	&	   	& 	     &	    \\"
local listofmodels 						     		  16_1    16_2    16_6    16_7    16_3    16_4     16_5   16_10   16_11    16_12   16_13

#delimit;
local statslist	controlsheading
				ageregion
				sex
				extended 	 
				cogability 		 
				parentsschool 		  
				fatherhgs 	 
				primeageonly 	  
				blankline
				F 		  
				ARconf 			   
				N ;
local labelslist `" 
				"\textbf{Controls:}"
				"Age, region"
				"Sex"
				"Extended" 	
				"Cognitive ability" 
				"Parents' schooling" 
				"Father's HGS" 
				"Prime age only" 
				" "
				"F-stat" 
				"A-R Conf. interval" 
				"N" 
				"' ;
local fmtlist 	%9s %9s %9s	%9s %9s %9s	%9s %9s %9s %9.3f %9.3f %9.0f ;

#delimit cr

foreach model of local listofmodels {  /* Loop to make sure same specification is shown for IV2, OLS, and RF */
	local Tab1_RFlist  `Tab1_RFlist'   RFcvote`model'
	local Tab5_IV2list `Tab5_IV2list' IV2cvote`model'
	local Tab5_OLSlist `Tab5_OLSlist' OLScvote`model'
}	

esttab `Tab1_RFlist'  using $log/finaltable1_RF.tex  ///
	, keep(`instrument') 	  `esttabopts' replace stats(`statslist' , labels(`labelslist') fmt(`fmtlist')) ///
	  posthead("`columnnames'" "`columnnums'" "`reducedformname'") mlabels(none) coeflabels(`instrument' "Height (inches)")

esttab `Tab5_IV2list' using $log/finaltable5_IV2.tex ///
	, keep(wincome) `esttabopts' replace stats(`statslist' , labels(`labelslist') fmt(`fmtlist')) ///
      posthead("`columnnames'" "`columnnums'" "`secondstagename'") mlabels(none) coeflabels(wincome "Real Income (000s)")

esttab `Tab5_OLSlist' using $log/finaltable5_OLS.tex ///
	, keep(wincome) `esttabopts' replace stats(`statslist' , labels(`labelslist') fmt(`fmtlist')) ///
      posthead("`columnnames'" "`columnnums'" "`OLSname'") mlabels(none) coeflabels(wincome "Real Income (000s)")
 
} /* end finaltable1and5 */



if `finaltable2'==1 { // Table 2: Other dependent variables

local columnnames 								"& Pvte Enterpr &  State Ownership 	& Govt Jobs & Limit Income 	& Vote Cons. \\"
local columnnums 								"& (1)			& (2)   			& (3)    	& (4)    		& (5) 		 \\ \hline"
local reducedformname "\textbf{Reduced Form:}	 & 		 		& 		 			&		  	& 	   			&	 	 	 \\"
local secondstagename "\textbf{IV 2nd Stage:}  	 & 		 		& 		 			&		  	& 	   			&	 	 	 \\"
local OLSname 				   "\textbf{OLS:}  	 & 		 		& 		 			&		  	& 	   			&	 	 	 \\"
local listofmodels 									peo14			pso14 				gjo14 		ulo16 		   	convote16

local statslist		controlsheading 		agesexregion 		extended 		blankline	F			ARconf  				N
local labelslist `" "\textbf{Controls:}" 	"Age, sex, region" 	"Extended"  	" "			"F-Stat"	"A-R Conf. interval" 	"N" "'
local fmtlist 		%9s 					%9s 				%9s 			%9s			%9.3f 		%9s						%9.0f


foreach model of local listofmodels {  /* Loop to make sure same specification is shown for IV2 and RF */
	local Tab2_RFlist  `Tab2_RFlist'   RF`model'_2
	local Tab2_IV2list `Tab2_IV2list' IV2`model'_2
	local Tab2_OLSlist `Tab2_OLSlist' OLS`model'_2
}	

esttab `Tab2_RFlist'  using $log/finaltable2_RF.tex  ///
	, keep(`instrument') 	  `esttabopts' replace stats(`statslist' , labels(`labelslist') fmt(`fmtlist')) ///
	  posthead("`columnnames'" "`columnnums'" "`reducedformname'") 	mlabels(none) coeflabels(`instrument' "Height (inches)")

esttab `Tab2_IV2list' using $log/finaltable2_IV2.tex ///
	, keep(wincome) `esttabopts' replace stats(`statslist' , labels(`labelslist') fmt(`fmtlist')) ///
      posthead("`columnnames'" "`columnnums'" "`secondstagename'")  mlabels(none) coeflabels(wincome "Real Income (000s)")

esttab `Tab2_OLSlist' using $log/finaltable2_OLS.tex ///
	, keep(wincome) `esttabopts' replace stats(`statslist' , labels(`labelslist') fmt(`fmtlist')) ///
      posthead("`columnnames'" "`columnnums'" "`OLSname'") 			mlabels(none) coeflabels(wincome "Real Income (000s)")
	  
} /* end finaltable2 */



if `finaltable3'==1 { // Table 3: Child height	

local columnnames 							"& Height 		& Height 		& Height 		& Height 		& Height	\\"
local columnnums 							"& (1) 	 		& (2)   		& (3)    		& (4)    		& (5)  		\\ \hline"

local statslist		blankline 	controlsheading 		agesexregion 		extended 		blankline	F			N
local labelslist `" " " 		"\textbf{Controls:}" 	"Age, sex, region" 	"Extended"  	" "			"F-Stat"	"N" "'
local fmtlist 		%9s			%9s 					%9s 				%9s 			%9s			%9.3f 		%9.0f

foreach var of local youthvars {
	local Tab3_Ylist `Tab3_Ylist' Y`var'16
	}
esttab 	`Tab3_Ylist' using $log/finaltable3_Y.tex , ///
	keep(`youthvars') `esttabopts' replace label mlabels(none) stats(`statslist' , labels(`labelslist') fmt(`fmtlist')) ///
	posthead("`columnnames'" "`columnnums'")
} /* end finaltable3 */



if `finaltable4'==1 { // Table 4: First Stage

local columnnames 							"& Whole		& Whole			& Female		& Female		& Male 			& Male 			\\"
local columnnums 							"& (1) 	 		& (2)   		& (3)    		& (4)    		& (5)  			& (6)  			\\ \hline"
local Tab4_IV1list							IV1cvote16_1  	IV1cvote16_2 	IV1cvote16_10 	IV1cvote16_11 	IV1cvote16_12 	IV1cvote16_13
local firststagename "\textbf{First Stage:}  & 		 		& 		 		&		  		& 	  		 	&	  			& 	 			\\"

local statslist		blankline 	controlsheading 		ageregion 		sex 	extended 		blankline	F_exc			  			N
local labelslist `" " " 		"\textbf{Controls:}" 	"Age, region" 	"Sex"	"Extended"  	" "			"F-Stat excl. instrument" 	"N" "'
local fmtlist 		%9s			%9s 					%9s 			%9s 	%9s 			%9s			%9.3f 						%9.0f

esttab 	`Tab4_IV1list' using $log/finaltable4_IV1.tex , keep(`instrument') `esttabopts' replace ///
		posthead("`columnnames'" "`columnnums'" "`firststagename'") /* prefoot("`bottomline'") */ mlabels(none)  coeflabels(`instrument' "Height (inches)") ///
			stats(`statslist' , labels(`labelslist') fmt(`fmtlist'))	
} /* end finaltable4 */


log close
} /* make_final_tables */
*




****** FIGURES

* HEIGHT HISTOGRAM
if `height_histogram_figure'==1 {
log using histogram , replace
use `varstokeep' using $cleandta/height1416.dta , clear

foreach wavenumber in 14 16 {
tempvar esampleM_heighthist`wavenumber' esampleW_heighthist`wavenumber'
di in red "`instrument' of MEN in wave `wavenumber' :"
gen `esampleM_heighthist`wavenumber''=1 if age>17 & male==1 & northern_ireland==0 & wave==`wavenumber'
sum `instrument' if age>17 & male==1 & northern_ireland==0 & wave==`wavenumber' , d
local Mmean = r(mean)
local Msd=r(sd)
local Mmin=r(min)
local Mmax=r(max)

di in red "`instrument' of WOMEN in wave `wavenumber' :"
gen `esampleW_heighthist`wavenumber''=1 if age>17 & female==1 & northern_ireland==0 & wave==`wavenumber'
sum `instrument' if age>17 & female==1 & northern_ireland==0 & wave==`wavenumber' , d
local Wmean = r(mean)
local Wsd=r(sd)
local Wmin=r(min)
local Wmax=r(max)

twoway 	(histogram `instrument' if `esampleM_heighthist`wavenumber''==1 , width(1) fcolor(green) fintensity(inten20) legend(label(1 "Men"))) /*
*/ 		(histogram `instrument' if `esampleW_heighthist`wavenumber''==1 , width(1) lcolor(black) bfcolor(none) 		 legend(label(2 "Women")) ) /*
*/ 		(function normalden(x,`Mmean',`Msd'), range(`Mmin' `Mmax')) /*
*/		(function normalden(x,`Wmean',`Wsd'), range(`Wmin' `Wmax')) /*
*/  		, legend (order(2 1)) ytitle("Density") xtitle("Height (inches)") 
graph2tex , epsfile($log/histogram_`instrument'`wavenumber')
} /* wave loop */
	log close
} /* height_histogram_figure loop */
*


* INCOME DISTRIBUTION
if `income_distribution_figure'==1 {
log using income_distribution , replace
use wincome age female male northern_ireland wave using $cleandta/height1416.dta , clear 

foreach wavenumber in 14 16 {
di in red "wincome of MEN in wave `wavenumber' :"
sum wincome 		if age>17 & male==1 & northern_ireland==0 & wave==`wavenumber' , d

di in red "wincome of WOMEN in wave `wavenumber' :"
sum wincome 		if age>17 & female==1 & northern_ireland==0 & wave==`wavenumber' , d

twoway (kdensity wincome if age>17 & female==1 & northern_ireland==0 & wave==`wavenumber', legend(label (1 "Women") ) ) /*
*/ (kdensity wincome if age>17 & male==1 & northern_ireland==0 & wave==`wavenumber', lpattern(dash) legend(label (2 "Men") ) ) /*
*/  , ytitle("Density") xtitle("Real income (000s pounds)")
graph2tex , epsfile($log/income_dist`wavenumber')

} /* wave loop */
	log close
} /* income_distribution_figure loop */
*


* REDUCED FORM FIGURE
 
 if `RF_figure'==1 {
log using RF_figure , replace
use $cleandta/height1416.dta , clear /* Use height1416.dta , constructed in height_gen.do */

foreach wavenumber in 14 16 {
foreach depvar of local dependent_variables  { 

cd $bootstrap
use bs_dataset , clear 
keep if wave==`wavenumber'

  forvalues i=1/`reps' {  /* Create bootstrap datasets and run mrunning */
	
	preserve

	bsample if !missing(age) & !missing(`instrument') & !missing(`depvar') 
	mrunning `depvar' `instrument' age  			, nograph gen(a_`depvar') adjust(female)
	mrunning `depvar' `instrument' age if female==1 , nograph gen(f_`depvar')
	mrunning `depvar' `instrument' age if male==1 	, nograph gen(m_`depvar')

	keep height a_`depvar'1 f_`depvar'1 m_`depvar'1
	rename a_`depvar'1 a_`depvar'_`i'
	rename f_`depvar'1 f_`depvar'_`i'
	rename m_`depvar'1 m_`depvar'_`i'
	collapse (mean) a_`depvar'_`i' f_`depvar'_`i' m_`depvar'_`i' , by(`instrument')
	
	tempfile bstrapMF`depvar'`wavenumber'_`i'
	save `bstrapMF`depvar'`wavenumber'_`i''
	
	restore
  }

  forvalues i=1/`reps' {  /* Merge bootstrap datasets */
	merge m:1 `instrument' using `bstrapMF`depvar'`wavenumber'_`i''
	drop _merge
  }

egen A_`depvar'_p975=rowpctile(a_*) , p(97.5)
egen A_`depvar'_p025=rowpctile(a_*) , p(2.5)
egen F_`depvar'_p975=rowpctile(f_*) , p(97.5)
egen F_`depvar'_p025=rowpctile(f_*) , p(2.5)
egen M_`depvar'_p975=rowpctile(m_*) , p(97.5)
egen M_`depvar'_p025=rowpctile(m_*) , p(2.5)

save bsMF_`depvar'`wavenumber' , replace

/* Make figures */

mrunning `depvar' `instrument' age  			, nograph gen(A_`depvar'RF`wavenumber') adjust(female)
mrunning `depvar' `instrument' age if female==1 , nograph gen(F_`depvar'RF`wavenumber')
mrunning `depvar' `instrument' age if male==1 	, nograph gen(M_`depvar'RF`wavenumber')

sum `instrument' , d  
local p10A_`depvar'_`wavenumber' = `r(p10)'  /* Mark the 10 and 90 percentile of height distribution */
local p90A_`depvar'_`wavenumber' = `r(p90)' 
sum A_`depvar'RF`wavenumber'1 if `instrument'==`p10A_`depvar'_`wavenumber''
sum A_`depvar'RF`wavenumber'1 if `instrument'==`p90A_`depvar'_`wavenumber''

sum `instrument' if female==1 , d
local p10F_`depvar'_`wavenumber' = `r(p10)'   /* Mark the 10 and 90 percentile of height distribution */
local p90F_`depvar'_`wavenumber' = `r(p90)' 

sum `instrument' if male==1 , d
local p10M_`depvar'_`wavenumber' = `r(p10)'   /* Mark the 10 and 90 percentile of height distribution */
local p90M_`depvar'_`wavenumber' = `r(p90)' 

if `"`depvar'"'=="cvote" | `"`depvar'"'=="zvote" {
	local rangemin =0
	local rangemax =.5
	local graphtitle "Taller People Support Conservative Party"
	local yaxistitle "Supports Conservative (predicted value)"
}
if `"`depvar'"'=="turnout" {
	local rangemin =.5
	local rangemax =1
	local graphtitle "Taller People More Likely to Turn Out"
	if `wavenumber'==16 local yaxistitle "Turnout in 2005 election (predicted value)"
	if `wavenumber'==14 local yaxistitle "Turnout in 2001 election (predicted value)"
}
if `"`depvar'"'=="convote" | `"`depvar'"'=="zconvote" | `"`depvar'"'=="convote_all" {
	local rangemin =0
	local rangemax =.5
	local graphtitle "Taller People Vote Conservative"
	if `wavenumber'==14 local yaxistitle "Voted Conservative in 2001 election (predicted value)"
	if `wavenumber'==16 local yaxistitle "Voted Conservative in 2005 election (predicted value)"
}
local rangemintick=`rangemin'+.05
local rangeminlabel=`rangemintick'+.05

twoway (scatter A_`depvar'RF`wavenumber'1 `instrument' if wave==`wavenumber' /*
*/ & `instrument'~=`p10A_`depvar'_`wavenumber'' & `instrument'~=`p90A_`depvar'_`wavenumber'' , msymbol(Sh) mcolor(blue) ) /*
*/	   (scatter A_`depvar'RF`wavenumber'1 `instrument' if wave==`wavenumber' /*
*/ & ( `instrument'==`p10A_`depvar'_`wavenumber'' | `instrument'==`p90A_`depvar'_`wavenumber'' ) , msymbol(X) mcolor(black) msize(huge) ) /*
*/    (scatter A_`depvar'_p975 `instrument' if wave==`wavenumber'  , msize(vsmall) mcolor(dkgreen) ) /*
*/    (scatter A_`depvar'_p025 `instrument' if wave==`wavenumber'  , msize(vsmall) mcolor(dkgreen) ) /*
*/   ,  ytitle(`yaxistitle') yscale( range(`rangemin' `rangemax') ) ytick (`rangemintick' (.05) `rangemax') /*
*/   ylabel(`rangeminlabel' (.1) `rangemax' ) /* title(`graphtitle') */ xsize(4) legend(off)

cd $log	
graph2tex, epsfile(fig_RF_A_`depvar'_`wavenumber') 	

twoway (scatter F_`depvar'RF`wavenumber'1 `instrument' if wave==`wavenumber' & female==1  /*
*/ & `instrument'~=`p10F_`depvar'_`wavenumber'' & `instrument'~=`p90F_`depvar'_`wavenumber'' , msymbol(Oh) mcolor(dkgreen) ) /*
*/	   (scatter F_`depvar'RF`wavenumber'1 `instrument' if wave==`wavenumber' & female==1 /*
*/ & ( `instrument'==`p10F_`depvar'_`wavenumber'' | `instrument'==`p90F_`depvar'_`wavenumber'' ) , msymbol(X) mcolor(black) msize(huge) ) /*
*/    (scatter F_`depvar'_p975 `instrument' if wave==`wavenumber' & female==1 , msize(vtiny) mcolor(blue) ) /*
*/    (scatter F_`depvar'_p025 `instrument' if wave==`wavenumber' & female==1 , msize(vtiny) mcolor(blue) ) /*
*/		(scatter M_`depvar'RF`wavenumber'1 `instrument' if wave==`wavenumber' & male==1  /*
*/ & `instrument'~=`p10M_`depvar'_`wavenumber'' & `instrument'~=`p90M_`depvar'_`wavenumber'' , msymbol(Th) mcolor(red) ) /*
*/	   (scatter M_`depvar'RF`wavenumber'1 `instrument' if wave==`wavenumber' & male==1 /*
*/ & ( `instrument'==`p10M_`depvar'_`wavenumber'' | `instrument'==`p90M_`depvar'_`wavenumber'' ) , msymbol(X) mcolor(black) msize(huge) ) /*
*/    (scatter M_`depvar'_p975 `instrument' if wave==`wavenumber' & male==1 , msize(vtiny) mcolor(dkorange) ) /*
*/    (scatter M_`depvar'_p025 `instrument' if wave==`wavenumber' & male==1 , msize(vtiny) mcolor(dkorange) ) /*   
*/			,  ytitle(`yaxistitle') yscale( range(`rangemin' `rangemax') ) ytick (`rangemintick' (.05) `rangemax') /*
*/   			ylabel(`rangeminlabel' (.1) `rangemax' ) /* title(`graphtitle') */ xsize(4) /*
*/			legend(label(1 "Women") label(5 "Men") order (1 5))

graph2tex, epsfile(fig_RF_MF_`depvar'_`wavenumber') 	
} /* depvar loop */
} /* wave loop */
	cd $cleandta
	use height1416, clear
	log close
} /* RF_figure loop */
*



 * REDUCED FORM FIGURE OTHER DEPENDENT VARIABLES

if `RF_figure_otherdepvars'==1 {  
log using RF_figure_otherdepvars , replace
use $cleandta/height1416.dta , clear 

foreach depvar of local other_dependent_variables  { 
if `"`depvar'"'=="ulo" local wavenumber 16
else local wavenumber 14
cd $bootstrap

use bs_dataset , clear 
keep if wave==`wavenumber'
  forvalues i=1/`reps' {  /* Create bootstrap datasets and run mrunning */
	preserve
	bsample if !missing(age) & !missing(height) & !missing(`depvar')
	mrunning `depvar' `instrument' age , nograph gen(a_`depvar') adjust(female)
	keep height a_`depvar'1
	rename a_`depvar'1 a_`depvar'_`i'
	collapse (mean) a_`depvar'_`i' , by(height)
	tempfile bstrap`depvar'`wavenumber'_`i'
	save `bstrap`depvar'`wavenumber'_`i'' 
	restore
  }

forvalues i=1/`reps' {  /* Merge bootstrap datasets */
	merge m:1 height using `bstrap`depvar'`wavenumber'_`i''
	drop _merge
}

egen A_`depvar'_p975=rowpctile(a_*) , p(97.5)
egen A_`depvar'_p025=rowpctile(a_*) , p(2.5)

save bsA_`depvar'`wavenumber' , replace


/* Make figures */

mrunning `depvar' `instrument' age if wave==`wavenumber', nograph gen(A_`depvar'RF`wavenumber') adjust(female)
quietly sum `instrument' if wave==`wavenumber' , d  
local p10A_`depvar'_`wavenumber' = `r(p10)'  /* Mark the 10 and 90 percentile of height distribution */
local p90A_`depvar'_`wavenumber' = `r(p90)' 

	local rangemin = -1
	local rangemax =.8

local rangemintick=`rangemin'+.1
local rangeminlabel=`rangemintick'+.1
if `"`depvar'"'=="ulo"	local yaxistitle "Govt should set upper earnings limit"
if `"`depvar'"'=="gjo"	local yaxistitle "Govt should provide jobs for all"
if `"`depvar'"'=="pso"	local yaxistitle "Major public svcs and industries should be state-owned"
if `"`depvar'"'=="peo"	local yaxistitle "Private enterprise solves economic problems"

twoway (scatter A_`depvar'RF`wavenumber'1 `instrument' if wave==`wavenumber' /*
*/ & `instrument'~=`p10A_`depvar'_`wavenumber'' & `instrument'~=`p90A_`depvar'_`wavenumber'' , msymbol(Sh) mcolor(blue) ) /*
*/	   (scatter A_`depvar'RF`wavenumber'1 `instrument' if wave==`wavenumber' /*
*/ & ( `instrument'==`p10A_`depvar'_`wavenumber'' | `instrument'==`p90A_`depvar'_`wavenumber'' ) , msymbol(X) mcolor(black) msize(huge) ) /*
*/    (scatter A_`depvar'_p975 `instrument' if wave==`wavenumber'  , msize(vsmall) mcolor(dkgreen) ) /*
*/    (scatter A_`depvar'_p025 `instrument' if wave==`wavenumber'  , msize(vsmall) mcolor(dkgreen) ) /*
*/   ,  yscale( range(`rangemin' `rangemax') ) ytick(`rangemin' (.1) `rangemax') /*
*/   ylabel(`rangemin' (.2) `rangemax' )  ytitle(`yaxistitle') legend(off) xsize(4)

cd $log	
graph2tex, epsfile(fig_RF_A_`depvar'_`wavenumber') 	
} /* depvar loop */
	cd $cleandta
	use height1416, clear
	log close
} /* RF_figure_otherdepvars loop */
*



* IV FIGURE -- 1st stage
 
 if `iv1st_figure'==1 {
log using iv1st_figure , replace
use $cleandta/height1416.dta , clear 

foreach wavenumber in 14 16 {
local depvar cvote
cd $bootstrap

if 	`make_iv1st_data'==1 {
use `depvar' `instrument' wincome age female male wave using bs_dataset if wave==`wavenumber' , clear 
  forvalues i=1/`reps' {  /* Create bootstrap datasets and run mrunning */
	preserve
	bsample if !missing(age) & !missing(`instrument') & !missing(`depvar') & !missing(wincome)
	mrunning wincome `instrument' age  , 		nograph gen(a_wincome`wavenumber') adjust(female)
	mrunning wincome `instrument' age if female==1 , 	nograph gen(f_wincome`wavenumber')
	mrunning wincome `instrument' age if male==1 ,   	nograph gen(m_wincome`wavenumber')
	rename a_wincome`wavenumber'1 a_wincome`wavenumber'_`i'
	rename f_wincome`wavenumber'1 f_wincome`wavenumber'_`i'
	rename m_wincome`wavenumber'1 m_wincome`wavenumber'_`i'
	collapse (mean) a_wincome`wavenumber'_`i' /*
	*/				f_wincome`wavenumber'_`i' m_wincome`wavenumber'_`i' , by(`instrument')
	tempfile bsIV1stwincome`wavenumber'_`i'
	save `bsIV1stwincome`wavenumber'_`i''
	restore
  }
 forvalues i=1/`reps' {  /* Merge bootstrap datasets */
	merge m:1 `instrument' using `bsIV1stwincome`wavenumber'_`i'' , nogenerate
  }
 egen A_wincome_p975=rowpctile(a_*) , p(97.5)
 egen A_wincome_p025=rowpctile(a_*) , p(2.5)
 egen F_wincome_p975=rowpctile(f_*) , p(97.5)
 egen F_wincome_p025=rowpctile(f_*) , p(2.5)
 egen M_wincome_p975=rowpctile(m_*) , p(97.5)
 egen M_wincome_p025=rowpctile(m_*) , p(2.5)

 save bsIV1stAMF_wincome`wavenumber' , replace
}

else {
use bsIV1stAMF_wincome`wavenumber' , clear
}

* Make figures 

mrunning wincome `instrument' age , nograph gen(A_wincome) adjust(female)
mrunning wincome `instrument' age if female==1 , nograph gen(F_wincome)
mrunning wincome `instrument' age if male==1 , nograph gen(M_wincome)

quietly sum `instrument'  , d  
local p10A_`instrument'_`wavenumber' = `r(p10)'  /* Mark the 10 and 90 percentile of height distribution */
local p90A_`instrument'_`wavenumber' = `r(p90)' 

quietly sum `instrument' if female==1 , d
local p10F_`instrument'_`wavenumber' = `r(p10)'   /* Mark the 10 and 90 percentile of height distribution */
local p90F_`instrument'_`wavenumber' = `r(p90)' 

quietly sum `instrument' if male==1 , d
local p10M_`instrument'_`wavenumber' = `r(p10)'   /* Mark the 10 and 90 percentile of height distribution */
local p90M_`instrument'_`wavenumber' = `r(p90)' 

local yaxistitle "Real income '000s (predicted value)"
local rangemin=0
local rangemax=30
local rangemintick=`rangemin'+5
local rangeminlabel=`rangemintick'+5

twoway (scatter A_wincome1 `instrument' if /*
*/   `instrument'~=`p10A_`instrument'_`wavenumber'' & `instrument'~=`p90A_`instrument'_`wavenumber'' , msymbol(Sh) mcolor(blue) ) /*
*/	   (scatter A_wincome1 `instrument' if  /*
*/ (`instrument'==`p10A_`instrument'_`wavenumber'' | `instrument'==`p90A_`instrument'_`wavenumber'') , msymbol(X) mcolor(black) msize(huge) ) /*
*/    (scatter A_wincome_p975 `instrument' , msize(vsmall) mcolor(dkgreen) ) /*
*/    (scatter A_wincome_p025 `instrument' , msize(vsmall) mcolor(dkgreen) ) /*
*/   ,  ytitle(`yaxistitle')  yscale( range(`rangemin' `rangemax') ) ytick (`rangemintick' (5) `rangemax') /*
*/   ylabel(`rangeminlabel' (10) `rangemax' ) xsize(4)  legend(off)  /* title(`graphtitle') */

cd $log	
graph2tex, epsfile(fig_IV1stA`depvar'`wavenumber') 	

twoway (scatter F_wincome1 `instrument' if female==1  /*
*/ & `instrument'~=`p10F_`instrument'_`wavenumber'' & `instrument'~=`p90F_`instrument'_`wavenumber'' , msymbol(Oh) mcolor(dkgreen) ) /*
*/	   (scatter F_wincome1 `instrument' if female==1 /*
*/ & (`instrument'==`p10F_`instrument'_`wavenumber'' | `instrument'==`p90F_`instrument'_`wavenumber'') , msymbol(X) mcolor(black) msize(huge) ) /*
*/    (scatter F_wincome_p975 `instrument' if female==1 , msize(vtiny) mcolor(blue) ) /*
*/    (scatter F_wincome_p025 `instrument' if female==1 , msize(vtiny) mcolor(blue) ) /*
*/		(scatter M_wincome1 `instrument' if male==1  /*
*/ & `instrument'~=`p10M_`instrument'_`wavenumber'' & `instrument'~=`p90M_`instrument'_`wavenumber'' , msymbol(Th) mcolor(red) ) /*
*/	   (scatter M_wincome1 `instrument' if male==1 /*
*/ & (`instrument'==`p10M_`instrument'_`wavenumber'' | `instrument'==`p90M_`instrument'_`wavenumber'') , msymbol(X) mcolor(black) msize(huge) ) /*
*/    (scatter M_wincome_p975 `instrument' if male==1 , msize(vtiny) mcolor(dkorange) ) /*
*/    (scatter M_wincome_p025 `instrument' if male==1 , msize(vtiny) mcolor(dkorange) ) /*   
*/	, 	ytitle(`yaxistitle') yscale(range(`rangemin' `rangemax')) ytick(`rangemintick' (5) `rangemax') ylabel(`rangeminlabel' (10) `rangemax' ) /*
*/		xsize(4) /*
*/		legend(label(1 "Women") label(5 "Men") order (1 5)) /* title(`graphtitle') */
graph2tex, epsfile(fig_IV1stMF`depvar'`wavenumber') 	

*} /* depvar loop */
} /* wave loop */
	cd $cleandta
	use height1416, clear
	log close
} /* iv1st_figure loop */
*


* IV FIGURE -- 2nd stage
 
 if `iv2nd_figure'==1 {

log using iv2nd_figure , replace
use $cleandta/height1416.dta , clear /* Use height1416.dta , constructed in height_gen.do */
	
	local roundincome .25  /* Round income to make confidence intervals legible */
	
	foreach wavenumber in 14 16 {
	
		foreach depvar of local dependent_variables  { 
		
			if `make_iv2nd_data'==1 {
			
				cd $bootstrap

				
				forvalues i=1/`reps' {  /* Create bootstrap datasets and run mrunning */

use `depvar' `instrument' wincome age female male wave using bs_dataset if wave==`wavenumber' /*
*/ & !missing(age) & !missing(`instrument') & !missing(`depvar') & !missing(wincome) , clear
				
replace wincome = round(wincome,`roundincome')  /* Round in order to be able to merge bootstrap estimates */

bsample /* Draw bootstrap sample */ 
					
			* Create tempfiles
tempfile bsIV2ndOLS`depvar'`wavenumber'_`i' bsIV2ndA`depvar'`wavenumber'_`i' bsIV2ndM`depvar'`wavenumber'_`i' bsIV2ndF`depvar'`wavenumber'_`i'

			* OLS datasets
preserve
	mrunning `depvar' wincome age 				, gen(OLSa`depvar'wincome_) nograph adjust(female)
	mrunning `depvar' wincome age if male==1 		, gen(OLSm`depvar'wincome_) nograph 
	mrunning `depvar' wincome age if female==1 	, gen(OLSf`depvar'wincome_) nograph 
	keep wincome *_1
	
			/* Rename variables by bootstrap number */
	rename OLSa`depvar'wincome_1 OLSa`depvar'wincome_`i'
	rename OLSm`depvar'wincome_1 OLSm`depvar'wincome_`i'
	rename OLSf`depvar'wincome_1 OLSf`depvar'wincome_`i'
	collapse (mean) *_* , by(wincome)
	save `bsIV2ndOLS`depvar'`wavenumber'_`i''
	
			* IV datasets
restore
	reg wincome `instrument'  age  
	predict IVAwincome  , xb 
	reg wincome `instrument'  age if male==1
	predict IVMwincome if male==1 , xb 
	reg wincome `instrument'  age if female==1
	predict IVFwincome if female==1 , xb 
	mrunning `depvar' IVAwincome age					, gen(IVa`depvar'wincome_) nograph adjust(female)
	mrunning `depvar' IVMwincome age	if male==1 		, gen(IVm`depvar'wincome_) nograph 
	mrunning `depvar' IVFwincome age	if female==1 	, gen(IVf`depvar'wincome_) nograph 
	keep IVA* IVM* IVF* IV*_1 male female

/* Save bootstrap datasets.  Since the values differ for each -predict-, round and save separately so merge works.  */

preserve 
	rename IVa`depvar'wincome_1 IVa`depvar'wincome_`i'
	gen wincome = round(IVAwincome,`roundincome')
	collapse (mean) IVa`depvar'wincome_`i' , by(wincome)
	save `bsIV2ndA`depvar'`wavenumber'_`i'' 
restore 
preserve
keep if male==1	
	rename IVm`depvar'wincome_1 IVm`depvar'wincome_`i'
	gen wincome = round(IVMwincome,`roundincome')
	collapse (mean) IVm`depvar'wincome_`i' , by(wincome)
	save `bsIV2ndM`depvar'`wavenumber'_`i''
restore 
keep if female==1	
	rename IVf`depvar'wincome_1 IVf`depvar'wincome_`i'
	gen wincome = round(IVFwincome,`roundincome')
	collapse (mean) IVf`depvar'wincome_`i' , by(wincome)
	save `bsIV2ndF`depvar'`wavenumber'_`i''
}

/* Merge bootstrap datasets */
	* OLS datasets
use `bsIV2ndOLS`depvar'`wavenumber'_1' , clear
forvalues i=2/`reps' {  
	merge 1:1 wincome using `bsIV2ndOLS`depvar'`wavenumber'_`i'' , nogenerate
}
foreach letter in a m f {
  egen p975OLS`letter'`depvar'wincome=rowpctile(OLS`letter'`depvar'wincome_*) , p(97.5)
  egen p025OLS`letter'`depvar'wincome=rowpctile(OLS`letter'`depvar'wincome_*) , p(2.5)
}
drop *_*
tempfile bsIV2ndOLSAMF_`depvar'`wavenumber'
save `bsIV2ndOLSAMF_`depvar'`wavenumber''

	* IV datasets
foreach letter in a m f {
	local upperletter=upper("`letter'")
	use `bsIV2nd`upperletter'`depvar'`wavenumber'_1', clear
	forvalues i=2/`reps' {  
	merge 1:1 wincome using `bsIV2nd`upperletter'`depvar'`wavenumber'_`i'' , nogenerate
		} 
  egen p975IV`letter'`depvar'wincome=rowpctile(IV`letter'`depvar'wincome_*) , p(97.5)
  egen p025IV`letter'`depvar'wincome=rowpctile(IV`letter'`depvar'wincome_*) , p(2.5)	

  drop *_*
  tempfile bsIV2ndIV`upperletter'_`depvar'`wavenumber'
  save `bsIV2ndIV`upperletter'_`depvar'`wavenumber''
  }
  
/* Merge all datasets */
use `depvar' `instrument' wincome age female male wave using bs_dataset if wave==`wavenumber' /*
*/ & !missing(age) & !missing(`instrument') & !missing(`depvar') & !missing(wincome) , clear 
replace wincome = round(wincome,`roundincome') /*   */
merge m:1 wincome using `bsIV2ndOLSAMF_`depvar'`wavenumber'' , nogenerate
foreach letter in A M F {
	merge m:1 wincome using `bsIV2ndIV`letter'_`depvar'`wavenumber'' , nogenerate
}  
save bsIV2ndAMF_`depvar'`wavenumber' , replace
}
* /* ifcmd generate bootstrap datasets */

else {
cd $bootstrap
use bsIV2ndAMF_`depvar'`wavenumber' , clear
}

/* Make figures */
	mrunning `depvar' wincome age					, gen(A_`depvar'wincome) nograph adjust(female)
	mrunning `depvar' wincome age if male==1 		, gen(M_`depvar'wincome) nograph 
	mrunning `depvar' wincome age if female==1 	, gen(F_`depvar'wincome) nograph 
	reg wincome `instrument'  age  
	predict IVAwincome  , xb 
	reg wincome `instrument'  age if male==1 
	predict IVMwincome if male==1 , xb 
	reg wincome `instrument'  age if female==1 
	predict IVFwincome if female==1 , xb 
	mrunning `depvar' IVAwincome age 					, gen(IVA`depvar'wincome) nograph adjust(female)
	mrunning `depvar' IVMwincome age if male==1		, gen(IVM`depvar'wincome) nograph 
	mrunning `depvar' IVFwincome age if female==1		, gen(IVF`depvar'wincome) nograph  	

quietly sum wincome  , d  
local p10A_wincome_ = `r(p10)'  /* Mark the 10 and 90 percentile of income distribution */
local p90A_wincome_ = `r(p90)' 

quietly sum wincome if female==1 , d
local p10F_wincome_ = `r(p10)'   /* Mark the 10 and 90 percentile of income distribution */
local p90F_wincome_ = `r(p90)' 

quietly sum wincome if male==1 , d
local p10M_wincome_ = `r(p10)'   /* Mark the 10 and 90 percentile of income distribution */
local p90M_wincome_ = `r(p90)' 

foreach letter in A M F {
*replace IV`letter'wincome = round(IV`letter'wincome,.1)
quietly sum IV`letter'wincome , d
local p10IV`letter'_wincome_ = `r(p10)'  /* Mark the 10 and 90 percentile of predicted income */
local p90IV`letter'_wincome_ = `r(p90)' 
}	

if `"`depvar'"'=="cvote" | `"`depvar'"'=="zvote" {
	local rangemin =0
	local rangemax =.5
	local graphtitle "Richer People Support Conservative Party"
	local yaxistitle "Supports Conservative (predicted value)"
}
if `"`depvar'"'=="turnout" {
	local rangemin =.5
	local rangemax =1
	local graphtitle "Richer People More Likely to Turn Out"
	local yaxistitle "Turnout in 2005 election (predicted value)"
}
if `"`depvar'"'=="convote" | `"`depvar'"'=="zconvote" | `"`depvar'"'=="convote_all" {
	local rangemin =0
	local rangemax =.5
	local graphtitle "Richer People Vote Conservative"
	local yaxistitle "Voted Conservative in 2005 election (predicted value)"
}
local rangemintick=`rangemin'+.05
local rangeminlabel=`rangemintick'+.05

twoway (scatter A_`depvar'wincome1 wincome if /*
*/  wincome~=`p10A_wincome_' & wincome~=`p90A_wincome_' , msymbol(Sh) msize(small) mcolor(gray) ) /*
*/	   (scatter A_`depvar'wincome1 wincome if /*
*/  (wincome==`p10A_wincome_' | wincome==`p90A_wincome_' ) , msymbol(X) mcolor(black) msize(huge) ) /*
*/    (scatter p975OLSa`depvar'wincome wincome , msize(vtiny) mcolor(green) ) /*
*/    (scatter p025OLSa`depvar'wincome wincome , msize(vtiny) mcolor(green) ) /*
*/		(scatter IVA`depvar'wincome1 IVAwincome , msymbol(O) msize(vsmall) mcolor(red)) /*
*/    (scatter p975IVa`depvar'wincome wincome  , msize(vtiny) mcolor(dkorange) ) /*
*/    (scatter p025IVa`depvar'wincome wincome , msize(vtiny) mcolor(dkorange) ) /*
*/   ,  ytitle(`yaxistitle') yscale( range(`rangemin' `rangemax') ) ytick (`rangemintick' (.05) `rangemax') /*
*/   ylabel(`rangeminlabel' (.1) `rangemax' ) /*title(`graphtitle')*/ legend(label(1 "OLS") label(5 "IV") order(1 5))

cd $log
graph2tex, epsfile(fig_IV2nd_A_`depvar'`wavenumber') 	

preserve
keep if wincome<40 

twoway (scatter A_`depvar'wincome1 wincome if /*
*/  wincome~=`p10A_wincome_' & wincome~=`p90A_wincome_' , msymbol(Sh) msize(vsmall) mcolor(gray) ) /*
*/	   (scatter A_`depvar'wincome1 wincome if /*
*/  (wincome==`p10A_wincome_' | wincome==`p90A_wincome_' ) , msymbol(X) mcolor(black) msize(huge) ) /*
*/		(scatter IVA`depvar'wincome1 IVAwincome if /*
*/  (round(IVAwincome,.01)~=round(`p10IVA_wincome_',.01) | round(IVAwincome,.01)~=round(`p90IVA_wincome_',.01) ) , msymbol(O) msize(small) mcolor(orange)) /*
*/	   (scatter IVA`depvar'wincome1 IVAwincome if /*
*/  (round(IVAwincome,.01)==round(`p10IVA_wincome_',.01) | round(IVAwincome,.01)==round(`p90IVA_wincome_',.01) ) , msymbol(X) mcolor(black) msize(large) ) /*
*/   ,  ytitle(`yaxistitle') xtitle("Real income (000s pounds)") yscale( range(`rangemin' `rangemax') ) ytick (`rangemintick' (.05) `rangemax') /*
*/   ylabel(`rangeminlabel' (.1) `rangemax' ) xsize(4) /*title(`graphtitle')*/ legend(label(1 "OLS") label(3 "IV") order(1 3))

cd $log
graph2tex, epsfile(fig_IV2ndnoCI_A_`depvar'`wavenumber') 	



twoway (scatter F_`depvar'wincome1 wincome if female==1  /*
*/ &  wincome~=`p10F_wincome_' & wincome~=`p90F_wincome_' , msymbol(Oh) mcolor(dkgreen) ) /*
*/	   (scatter F_`depvar'wincome1 wincome if female==1 /*
*/ & ( wincome==`p10F_wincome_' | wincome==`p10F_wincome_' ) , msymbol(X) mcolor(black) msize(huge) ) /*
*/    (scatter p975OLSf`depvar'wincome wincome if female==1 , msize(vtiny) mcolor(blue) ) /*
*/    (scatter p025OLSf`depvar'wincome wincome if female==1 , msize(vtiny) mcolor(blue) ) /*
*/		(scatter M_`depvar'wincome1 wincome if male==1  /*
*/ &  wincome~=`p10M_wincome_' & wincome~=`p90M_wincome_'  , msymbol(Th) mcolor(gray) ) /*
*/	   (scatter M_`depvar'wincome1 wincome if male==1 /*
*/ & (wincome==`p10M_wincome_' | wincome==`p10M_wincome_' ) , msymbol(X) mcolor(black) msize(huge) ) /*
*/    (scatter p975OLSm`depvar'wincome wincome if male==1 , msize(vtiny) mcolor(dkorange) ) /*
*/    (scatter p025OLSm`depvar'wincome wincome if male==1 , msize(vtiny) mcolor(dkorange) ) /*
*/		(scatter IVF`depvar'wincome1 IVFwincome if female==1 , msymbol(+) mcolor(forest_green)) /*
*/    (scatter p975IVf`depvar'wincome wincome if female==1 , msize(vsmall) mcolor(cyan) ) /*
*/    (scatter p025IVf`depvar'wincome wincome if female==1 , msize(vsmall) mcolor(cyan) ) /*
*/		(scatter IVM`depvar'wincome1 IVMwincome if male==1 , msymbol(d) mcolor(brown)) /*
*/    (scatter p975IVm`depvar'wincome wincome if male==1 , msize(vsmall) mcolor(gold) ) /*
*/    (scatter p025IVm`depvar'wincome wincome if male==1 , msize(vsmall) mcolor(gold) ) /*
*/			,  ytitle(`yaxistitle') yscale( range(`rangemin' `rangemax') ) ytick (`rangemintick' (.05) `rangemax') /*
*/   			ylabel(`rangeminlabel' (.1) `rangemax' ) /*title(`graphtitle')*/ xsize(3.5) /*
*/			legend(label(1 "Women (OLS)") label(5 "Men (OLS)") label(9 "Women (IV)") label(12 "Men (IV)") order (1 9 5 12))
graph2tex, epsfile(fig_IV2nd_MF_`depvar'`wavenumber') 	
restore

} /* depvar loop */
} /* wave loop */
	cd $cleandta
	use height1416, clear
	log close
} /* iv2nd_figure loop */
*


** YOUTH FIGURE*/

if `youth_figure'==1 { 
	log using youth_figure , replace
*	local parentsincome parents_wincome`wavenumber' 
	cd $log

	foreach wavenumber in 14 16 {
	cd $cleandta
	use height1416_youth if northern_ireland==0 , clear
	local parentsincome parents_wincome`wavenumber' 
	keep `instrument' `parentsincome' wave age female 
	
	if `make_youth_data'==1 {
		forvalues i=1/`reps' {  /* Create bootstrap datasets and run mrunning */
			preserve
			bsample if !missing(age) & !missing(`instrument') & !missing(`parentsincome') & wave==`wavenumber'
			mrunning `instrument' `parentsincome' age , nograph gen(a_`instrument') adjust(female)
			rename a_`instrument'1 a_`instrument'_`i'
			collapse (mean) a_`instrument'_`i'  , by(`parentsincome')
			tempfile bstrapyouth`instrument'`wavenumber'_`i'
			save `bstrapyouth`instrument'`wavenumber'_`i'' 
			restore
		}
		preserve
		keep if wave==`wavenumber'
		forvalues i=1/`reps' {  /* Merge bootstrap datasets */
			merge m:1 `parentsincome' using `bstrapyouth`instrument'`wavenumber'_`i'' , nogenerate
		}
		egen A_`instrument'_p975=rowpctile(a_*) , p(97.5)
		egen A_`instrument'_p025=rowpctile(a_*) , p(2.5)
		cd $bootstrap
		save bsyouth_`instrument'`wavenumber' , replace
	}

	else {
		preserve
		cd $bootstrap
		use bsyouth_`instrument'`wavenumber' , clear
		cd $log
}

/* Make figures */

mrunning `instrument' `parentsincome' age  , nograph gen(A_`instrument'RF`wavenumber') adjust(female)

sum `parentsincome' , d  
local p10A_`instrument'_`wavenumber' = `r(p10)'  /* Mark the 10 and 90 percentile of `parentsincome' distribution */
local p90A_`instrument'_`wavenumber' = `r(p90)' 
sum A_`instrument'RF`wavenumber'1 if `parentsincome'==`p10A_`instrument'_`wavenumber''
sum A_`instrument'RF`wavenumber'1 if `parentsincome'==`p90A_`instrument'_`wavenumber''

	local rangemin =55
	local rangemax =70
	local yaxistitle "Child's height (inches, predicted value)"

local rangemintick=`rangemin'+2
local rangeminlabel=`rangemintick'

twoway (scatter A_`instrument'RF`wavenumber'1 `parentsincome' if wave==`wavenumber' /*
*/ & `parentsincome'~=`p10A_`instrument'_`wavenumber'' & `parentsincome'~=`p90A_`instrument'_`wavenumber'' , msymbol(Sh) msize(vsmall) mcolor(gray) ) /*
*/	   (scatter A_`instrument'RF`wavenumber'1 `parentsincome' if wave==`wavenumber' /*
*/ & ( `parentsincome'==`p10A_`instrument'_`wavenumber'' | `parentsincome'==`p90A_`instrument'_`wavenumber'' ) , msymbol(X) mcolor(black) msize(huge) ) /*
*/    (scatter A_`instrument'_p975 `parentsincome' if wave==`wavenumber'  , msize(vtiny) mcolor(dkgreen) ) /*
*/    (scatter A_`instrument'_p025 `parentsincome' if wave==`wavenumber'  , msize(vtiny) mcolor(dkgreen) ) /*
*/   ,  ytitle(`yaxistitle') yscale( range(`rangemin' `rangemax') ) ytick (`rangemintick' (2) `rangemax') /*
*/   ylabel(`rangeminlabel' (2) `rangemax' ) legend(off) xtitle("Parents' income (000s pounds)") xsize(4)

cd $log	
graph2tex, epsfile(fig_youth_`instrument'_`wavenumber') 	

restore
} /* wave loop */
	cd $cleandta
	use height1416, clear
	log close
} /* Youth figure loop */
*


** Correlates of height FIGURE*/

if `height_correlates_figure'==1 { 
	log using heightcorr_figure , replace
	local parentsbackground father_hg

	foreach wavenumber in 14 16 {

	if `make_heightcorr_data'==1 {

	use `instrument' `parentsbackground' wave age female northern_ireland using $cleandta/height1416 if northern_ireland==0 & age>17 /*
	*/ 				& !missing(age) & !missing(`instrument') & !missing(`parentsbackground') & wave==`wavenumber' , clear

		forvalues i=1/`reps' {  /* Create bootstrap datasets and run mrunning */
			preserve
			bsample
			mrunning `instrument' `parentsbackground' age , nograph gen(a_`instrument') adjust(female)
			rename a_`instrument'1 a_`instrument'_`i'
			collapse (mean) a_`instrument'_`i'  , by(`parentsbackground')
			tempfile bstrapHG`instrument'`wavenumber'_`i'
			save `bstrapHG`instrument'`wavenumber'_`i'' 
			restore
		}

		forvalues i=1/`reps' {  /* Merge bootstrap datasets */
			merge m:1 `parentsbackground' using `bstrapHG`instrument'`wavenumber'_`i'' , nogenerate
		}
		
		egen A_`instrument'_p975=rowpctile(a_*) , p(97.5)
		egen A_`instrument'_p025=rowpctile(a_*) , p(2.5)
		cd $bootstrap
		save bsHG_`instrument'`wavenumber' , replace
}

	else {
		cd $bootstrap
		use bsHG_`instrument'`wavenumber' , clear
}

/* Make figures */

mrunning `instrument' `parentsbackground' age  , nograph gen(A_`instrument'RF`wavenumber') adjust(female)

sum `parentsbackground' , d  
local p10A_`instrument'_`wavenumber' = `r(p10)'  /* Mark the 10 and 90 percentile of `parentsbackground' distribution */
local p90A_`instrument'_`wavenumber' = `r(p90)' 
sum A_`instrument'RF`wavenumber'1 if `parentsbackground'==`p10A_`instrument'_`wavenumber''
sum A_`instrument'RF`wavenumber'1 if `parentsbackground'==`p90A_`instrument'_`wavenumber''

	local rangemin =55
	local rangemax =80
	local yaxistitle "Height (inches, predicted value)"

local rangemintick=`rangemin'+2
local rangeminlabel=`rangemintick'

twoway (scatter A_`instrument'RF`wavenumber'1 `parentsbackground' if wave==`wavenumber' /*
*/ & `parentsbackground'~=`p10A_`instrument'_`wavenumber'' & `parentsbackground'~=`p90A_`instrument'_`wavenumber'' , msymbol(Sh) msize(vsmall) mcolor(gray) ) /*
*/	   (scatter A_`instrument'RF`wavenumber'1 `parentsbackground' if wave==`wavenumber' /*
*/ & ( round(`parentsbackground',01)==round(`p10A_`instrument'_`wavenumber'',01) | round(`parentsbackground',01)==round(`p90A_`instrument'_`wavenumber'',01) ) , msymbol(X) mcolor(black) msize(huge) ) /*
*/    (scatter A_`instrument'_p975 `parentsbackground' if wave==`wavenumber'  , msize(vtiny) mcolor(dkgreen) ) /*
*/    (scatter A_`instrument'_p025 `parentsbackground' if wave==`wavenumber'  , msize(vtiny) mcolor(dkgreen) ) /*
*/   ,  ytitle(`yaxistitle') yscale( range(`rangemin' `rangemax') ) ytick (`rangemintick' (2) `rangemax') /*
*/   ylabel(`rangeminlabel' (2) `rangemax' ) legend(off)

cd $log	
graph2tex, epsfile(fig_HG_`instrument'_`wavenumber') 	

} /* wave loop */
	cd $cleandta
	use height1416, clear
	log close
} /* height_correlates_figure loop */
*


if `over_time'==1 { 

* Need to define these locals here, since they are called in making graphs
local depvar cvote
local instrument meanheight /* height14 height16 */
local clusteropts cluster(hid)
local modellist RF OLS IV1st IV2nd
local numberofspecs 9

forvalues i=1/`numberofspecs' {
	local RF`i' 		reg 			`depvar' `instrument' 						`controls`i''	`samples`i'' 	
	local OLS`i' 		reg 			`depvar' wincome 					`controls`i''	`samples`i''
	local IV1st`i' 		reg 			wincome `instrument' 				`controls`i''	`samples`i''
	local IV2nd`i'		ivregress 2sls	`depvar' (wincome=`instrument') 	`controls`i''	`samples`i''
}

	
	
	if `gen_parmest'==1  {
log using $log/over_time_gen_parmest, replace
use $cleandta/height, clear

* Summary stats of income, for use in figures
preserve
collapse (sd) wincomesd_MF=wincome (mean) wincomemean_MF=wincome, by(female wave)
tempfile wincome_MF
save `wincome_MF'
restore

preserve
collapse (sd) wincomesd_whole=wincome (mean) wincomemean_whole=wincome, by(wave)
tempfile wincome_whole
save `wincome_whole'
restore

foreach model of local modellist {
	forvalues i=1/`numberofspecs' {
		parmby "``model'`i'' , `clusteropts'" , by(female wave) saving($log/`model'_MF`i', replace)
		parmby "``model'`i'' , `clusteropts'" , by(wave) 		saving($log/`model'_whole`i', replace)
	} /* specifications loop */
} /* model loop*/
	
* Merge mean and sd wincome info and label variables	
	foreach model of local modellist {
		forvalues i=1/`numberofspecs' {
			use $log/`model'_MF`i' , clear
			merge m:1 female wave 	using `wincome_MF'   , nogenerate
			label var wave "Wave"
			save $log/`model'_MF`i', replace

			use $log/`model'_whole`i' , clear
			merge m:1 wave 	using `wincome_whole'   , nogenerate
			label var wave "Wave"
			save $log/`model'_whole`i', replace
		} /*specs loop*/
	} /*models loop*/
	
log close
} /* over_time_gen_parmest loop */

	
	
if `make_graphs'==1 {  /* Plot results */
log using $log/over_time_make_graphs, replace

forvalues i=1/`numberofspecs' {
	
* Note that only waves 3-18 are used, since cvote cannot be constructed correctly in wave 2. 

* Reduced form and IV 1st Stage, Whole Sample and Male/Female	
	foreach model in RF IV1st {
		use $log/`model'_whole`i' if parm=="`instrument'" & wave>2 , clear 
			if `"`model'"'=="RF" 	local graphopts ylabel(0(.005).02 , grid gmax) ytitle("Point Estimate")
			if `"`model'"'=="IV1st" local graphopts ylabel(0(.25).75 , grid gmax)  ytitle("Point Estimate")
		twoway (connected estimate wave) (line max95 wave , lpattern(dot) lcolor(dkgreen)) (line min95 wave , lpattern(dot) lcolor(dkgreen)) , ///
			legend(off) `graphopts'
		graph2tex , epsfile($log/`model'_whole`i') 	

		use $log/`model'_MF`i' if parm=="`instrument'" & wave>2 , clear 
			if `"`model'"'=="RF" 	local graphopts ylabel(-0.005(.005).02)
			if `"`model'"'=="IV1st" local graphopts ylabel(0(.25).75)

		twoway (connected estimate wave if female==1  , msymbol(T) ) /*(line max95 wave if female==1, lpattern(dot)) (line min95 wave if female==1, lpattern(dot))*/ ///
			   (connected estimate wave if female==0  , msymbol(O) )/*(line max95 wave if female==0, lpattern(dot)) (line min95 wave if female==0, lpattern(dot))*/ ///
		       , legend( label(1 "Female") label(2 "Male") /*order(1 4)*/ ) `graphopts'
		graph2tex , epsfile($log/`model'_MF`i') 	
	}
	
* OLS and IV 2nd Stage, Whole Sample
	use $log/OLS_whole`i' , clear 
	gen model="OLS"
	append using $log/IV2nd_whole`i' 
	keep if parm=="wincome" & wave>2
	replace model="IV" if missing(model)
	foreach v of varlist estimate max95 min95 {
		gen `v'_times_1sd = `v'*wincomesd_whole /* Effect of a one s.d. increase in income */
	}
	local graphopts ylabel(0(.25)1 , grid gmax) ytitle("Point Estimate X 1 s.d. Income")
	twoway (connected estimate_times_1sd wave if model=="OLS",  msymbol(Sh) msize(vsmall) mcolor(gray))  ///
																(line max95_times_1sd wave if model=="OLS", lpattern(dot) lcolor(dknavy)) ///
																(line min95_times_1sd wave if model=="OLS", lpattern(dot) lcolor(dknavy)) ///
		   (connected estimate_times_1sd wave if model=="IV" ,  msymbol(O) msize(small) mcolor(orange))  ///
																(line max95_times_1sd wave if model=="IV" , lpattern(dot) lcolor(red)) ///
																(line min95_times_1sd wave if model=="IV" , lpattern(dot) lcolor(red)) ///
			, legend( label(1 "OLS") label(4 "IV") order(1 4) ) `graphopts'
		graph2tex , epsfile($log/OLSIV2nd_whole`i') 	

* OLS and IV 2nd Stage, Male/Female	
	use $log/OLS_MF`i' , clear 
	gen model="OLS"
	append using $log/IV2nd_MF`i' 
	keep if parm=="wincome" & wave>2
	replace model="IV" if missing(model)
	foreach v of varlist estimate max95 min95 {
		gen `v'_times_1sd = `v'*wincomesd_MF /* Effect of a one s.d. increase in income */
	}
	twoway (connected estimate_times_1sd wave if model=="IV" & female==1 , msymbol(T) ) /*(line max95_times_1sd wave if model=="IV" & female==1, lpattern(dot)) ///
																		  (line min95_times_1sd wave if model=="IV" & female==1, lpattern(dot)) */ ///
		   (connected estimate_times_1sd wave if model=="IV" & female==0 , msymbol(O) ) /*(line max95_times_1sd wave if model=="IV" & female==0, lpattern(dot)) ///
																		  (line min95_times_1sd wave if model=="IV" & female==0, lpattern(dot)) */ ///
			, legend( label(1 "Female") label(2 "Male") /*order(1 4)*/ ) `graphopts'
	graph2tex , epsfile($log/OLSIV2nd_MF`i') 	
		} /*specs loop*/
		
	log close	
	} /* over_time_make_graphs */	

} /* over_time  */
*

exit
