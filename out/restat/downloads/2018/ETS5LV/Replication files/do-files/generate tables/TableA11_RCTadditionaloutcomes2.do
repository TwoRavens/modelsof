
use "$data/podes_pkhrollout.dta", clear	
 
keep if rctsample==1
 
 
/* Initialize empty table */
 
loc experiments "1 2 3 4 5 6 7 8 9 10 11 12 13 14 15"



preserve

clear all
eststo clear
estimates drop _all

set obs 10
qui gen x = 1
qui gen y = 1

loc columns = 0

foreach choice in `experiments' {

    loc ++columns
    qui eststo col`columns': reg x y

}

restore

/* Statistics */

loc colnum = 1
loc colnames ""



********************************************************************************	
*****************************Column 1: ANCOVA*********************************
********************************************************************************	


	reg n_numberofsuicidespc treat_pkhrct_post  n_suicides_possionpc_baseline  $year if year==2011  [aw=pop_sizebaseline], cluster(kecid)
 sigstar treat_pkhrct_post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col1
    estadd loc thisstat4 = "`r(sestar)'": col1
    estadd loc thisstat14 = `e(N)': col1 
		sum n_numberofsuicidespc if treat_pkhrct==0 & year==2011  [aw=pop_sizebaseline]
    estadd loc thisstat13 = string(r(mean), "%9.3f"): col1
 
	estadd loc thisstat7 = "N": col1
    estadd loc thisstat8 = "N": col1
    estadd loc thisstat11 = "Y": col1
    estadd loc thisstat9 = "N": col1
	estadd loc thisstat10 = "Y": col1	
    estadd loc thisstat15 = "11": col1

********************************************************************************
*****************************Column 2: Post ************************************
********************************************************************************
	

	reg n_numberofsuicidespc treat_pkhrct_post  if  year==2011  [aw=pop_sizebaseline], cluster(kecid)
    sigstar treat_pkhrct_post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col2
    estadd loc thisstat4 = "`r(sestar)'": col2
    estadd loc thisstat14 = `e(N)': col2
	
	sum n_numberofsuicidespc if treat_pkhrct==0 & year==2011  [aw=pop_sizebaseline]
    estadd loc thisstat13 = string(r(mean), "%9.3f"): col2
 
	estadd loc thisstat7 = "N": col2
    estadd loc thisstat8 = "N": col2
    estadd loc thisstat11 = "Y": col2
    estadd loc thisstat9 = "N": col2
	estadd loc thisstat10 = "N": col2
    estadd loc thisstat15 = "11": col2
	
	
******************************************************************
*****************************Column 3: DD   **********************
******************************************************************

xtreg n_numberofsuicidespc treat_pkhrct_post  treat_pkhrct  i.year $year if year==2005 | year==2011  [aw=pop_sizebaseline], fe cluster(kecid)
 sigstar treat_pkhrct_post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col3
    estadd loc thisstat4 = "`r(sestar)'": col3
    estadd loc thisstat14 = `e(N)': col3
		sum n_numberofsuicidespc if treat_pkhrct==0 & year==2011  [aw=pop_sizebaseline]
    estadd loc thisstat13 = string(r(mean), "%9.3f"): col3
 
	estadd loc thisstat7 = "Y": col3
    estadd loc thisstat8 = "Y": col3
    estadd loc thisstat11 = "Y": col3
    estadd loc thisstat9 = "N": col3
	estadd loc thisstat10 = "N": col3
    estadd loc thisstat15 = "05 - 11": col3
	

	

	

	
********************************************************************************	
*****************************Column 4: DD include pre-treatment ****************
********************************************************************************
	
	
	xtreg n_numberofsuicidespc treat_pkhrct_post treat_pkhrct i.year if year<=2011  [aw=pop_sizebaseline], fe cluster(kecid)
    sigstar treat_pkhrct_post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col4
    estadd loc thisstat4 = "`r(sestar)'": col4
    estadd loc thisstat14 = `e(N)': col4
	sum n_numberofsuicidespc if treat_pkhrct==0 & year==2011  [aw=pop_sizebaseline]
    estadd loc thisstat13 = string(r(mean), "%9.3f"): col4
 
	estadd loc thisstat7 = "Y": col4
    estadd loc thisstat8 = "Y": col4
    estadd loc thisstat11 = "Y": col4
    estadd loc thisstat9 = "Y": col4
	estadd loc thisstat10 = "N": col4
    estadd loc thisstat15 = "00 - 11": col4
	
	
**************************************************************
*****************************Column 4: ANCOVA no weight  *****
**************************************************************
	
	reg n_numberofsuicidespc treat_pkhrct_post  n_suicides_possionpc_baseline  $year if year==2011  , cluster(kecid)
	sigstar treat_pkhrct_post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col5
    estadd loc thisstat4 = "`r(sestar)'": col5
    estadd loc thisstat14 = `e(N)': col5
	sum n_numberofsuicidespc  if treat_pkhrct==0 & year==2011
    estadd loc thisstat13 = string(r(mean), "%9.3f"): col5
 
	estadd loc thisstat7 = "N": col5
    estadd loc thisstat8 = "N": col5
    estadd loc thisstat11 = "N": col5
    estadd loc thisstat9 = "N": col5
	estadd loc thisstat10 = "Y": col5
    estadd loc thisstat15 = "11": col5

	

********************************************************************************	
*****************************Column 6: ANCOVA*********************************
********************************************************************************	



	reg n_suicides_possion treat_pkhrct_post nsuicidespc2_baseline  $year if year==2011  , cluster(kecid)
	sigstar treat_pkhrct_post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col6
    estadd loc thisstat4 = "`r(sestar)'": col6
    estadd loc thisstat14 = `e(N)': col6
		sum n_suicides_possion if treat_pkhrct==0 & year==2011  
    estadd loc thisstat13 = string(r(mean), "%9.3f"): col6
 
	estadd loc thisstat7 = "N": col6
    estadd loc thisstat8 = "N": col6
    estadd loc thisstat11 = "N": col6
    estadd loc thisstat9 = "N": col6
	estadd loc thisstat10 = "Y": col6	
    estadd loc thisstat15 = "11": col6
	
	
********************************************************************************
*****************************Column 7: Post               **********************
********************************************************************************

reg n_numberofsuicides treat_pkhrct_post  if year==2011  , cluster(kecid)
 sigstar treat_pkhrct_post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col7
    estadd loc thisstat4 = "`r(sestar)'": col7
    estadd loc thisstat14 = `e(N)': col7
	sum n_suicides_possion if treat_pkhrct==0 & year==2011  
    estadd loc thisstat13 = string(r(mean), "%9.3f"): col7
 
	estadd loc thisstat7 = "N": col7
    estadd loc thisstat8 = "N": col7
    estadd loc thisstat11 = "N": col7
    estadd loc thisstat9 = "N": col7
	estadd loc thisstat10 = "N": col7
    estadd loc thisstat15 = "11": col7	
 

********************************************************************************
*****************************Column 8: DD **************************************
********************************************************************************
	

	xtreg n_suicides_possion treat_pkhrct_post treat_pkhrct year2011 year2005 if year==2005 | year==2011  , fe cluster(kecid)
    sigstar treat_pkhrct_post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col8
    estadd loc thisstat4 = "`r(sestar)'": col8
    estadd loc thisstat14 = `e(N)': col8
	
	
	sum n_suicides_possion  if treat_pkhrct==0 & year==2011 
    estadd loc thisstat13 = string(r(mean), "%9.3f"): col8
 
	estadd loc thisstat7 = "Y": col8
    estadd loc thisstat8 = "Y": col8
    estadd loc thisstat11 = "N": col8
    estadd loc thisstat9 = "N": col8
	estadd loc thisstat10 = "N": col8
    estadd loc thisstat15 = "05 - 11": col8
	

	
	
	
********************************************************************************	
*****************************Column 9: DD include pre-periods ******************
********************************************************************************
	
	
	xtreg n_suicides_possion treat_pkhrct_post treat_pkhrct i.year if year<=2011  , fe cluster(kecid)
    sigstar treat_pkhrct_post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col9
    estadd loc thisstat4 = "`r(sestar)'": col9
    estadd loc thisstat14 = `e(N)': col9
	sum n_suicides_possion if treat_pkhrct==0 & year==2011  
    estadd loc thisstat13 = string(r(mean), "%9.3f"): col9
 
	estadd loc thisstat7 = "Y": col9
    estadd loc thisstat8 = "Y": col9
    estadd loc thisstat11 = "N": col9
    estadd loc thisstat9 = "Y": col9
	estadd loc thisstat10 = "N": col9
    estadd loc thisstat15 = "00 - 11": col9
	
	
	
********************************************************************************	
*****************************Column 10: ANCOVA weighted ********************
********************************************************************************

	
	reg n_suicides_possion treat_pkhrct_post nsuicidespc2_baseline  $year if year==2011 [aw=pop_sizebaseline] , cluster(kecid)
	sigstar treat_pkhrct_post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col10
    estadd loc thisstat4 = "`r(sestar)'": col10
    estadd loc thisstat14 = `e(N)': col10
	sum n_suicides_possion   if treat_pkhrct==0 & year==2011  [aw=pop_sizebaseline]
    estadd loc thisstat13 = string(r(mean), "%9.3f"): col10
 
	estadd loc thisstat7 = "N": col10
    estadd loc thisstat8 = "N": col10
    estadd loc thisstat11 = "Y": col10
    estadd loc thisstat9 = "N": col10
	estadd loc thisstat10 = "Y": col10
    estadd loc thisstat15 = "11": col10
	


	


	
********************************************************************************	
*****************************Column 11: ANCOVA*********************************
********************************************************************************	


	reg n_numberofsuicides treat_pkhrct_post  suicide_baseline  $year if year==2011  , cluster(kecid)
	sigstar treat_pkhrct_post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col11
    estadd loc thisstat4 = "`r(sestar)'": col11
    estadd loc thisstat14 = `e(N)': col11
	sum n_numberofsuicides if treat_pkhrct==0 & year==2011  
    estadd loc thisstat13 = string(r(mean), "%9.3f"): col11
 
	estadd loc thisstat7 = "N": col11
    estadd loc thisstat8 = "N": col11
    estadd loc thisstat11 = "N": col11
    estadd loc thisstat9 = "N": col11
	estadd loc thisstat10 = "Y": col11	
    estadd loc thisstat15 = "11": col11
	
	
	
********************************************************************************
*****************************Column 12: Post              **********************
********************************************************************************

reg n_numberofsuicides treat_pkhrct_post  if year==2011  ,  cluster(kecid)
 sigstar treat_pkhrct_post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col12
    estadd loc thisstat4 = "`r(sestar)'": col12
    estadd loc thisstat14 = `e(N)': col12
	sum n_numberofsuicides if treat_pkhrct==0 & year==2011  
    estadd loc thisstat13 = string(r(mean), "%9.3f"): col12
 
	estadd loc thisstat7 = "N": col12
    estadd loc thisstat8 = "N": col12
    estadd loc thisstat11 = "N": col12
    estadd loc thisstat9 = "N": col12
	estadd loc thisstat10 = "N": col12
    estadd loc thisstat15 = "11": col12
	
 

 	
********************************************************************************
*****************************Column 13: DD *************************************
********************************************************************************
	

	xtreg n_numberofsuicides treat_pkhrct_post treat_pkhrct year2011 year2005 if year==2005 | year==2011  , fe cluster(kecid)
    sigstar treat_pkhrct_post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col13
    estadd loc thisstat4 = "`r(sestar)'": col13
    estadd loc thisstat14 = `e(N)': col13
	
	
	sum n_numberofsuicides  if treat_pkhrct==0 & year==2011 
    estadd loc thisstat13 = string(r(mean), "%9.3f"): col13
 
	estadd loc thisstat7 = "Y": col13
    estadd loc thisstat8 = "Y": col13
    estadd loc thisstat11 = "N": col13
    estadd loc thisstat9 = "N": col13
	estadd loc thisstat10 = "N": col13
    estadd loc thisstat15 = "05 - 11": col13


	
********************************************************************************	
*****************************Column 14: DD with pre-periods ********************
********************************************************************************
	
	
	xtreg n_numberofsuicides treat_pkhrct_post treat_pkhrct i.year if year<=2011  , fe cluster(kecid)
    sigstar treat_pkhrct_post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col14
    estadd loc thisstat4 = "`r(sestar)'": col14
    estadd loc thisstat14 = `e(N)': col14
	sum n_numberofsuicides if treat_pkhrct==0 & year==2011  
    estadd loc thisstat13 = string(r(mean), "%9.3f"): col14
 
	estadd loc thisstat7 = "Y": col14
    estadd loc thisstat8 = "Y": col14
    estadd loc thisstat11 = "N": col14
    estadd loc thisstat9 = "Y": col14
	estadd loc thisstat10 = "N": col14
    estadd loc thisstat15 = "00 - 11": col14
	

	
	
********************************************************************************	
*****************************Column 15: ANCOVA  weighted ************************
********************************************************************************


	
	
	reg n_numberofsuicides treat_pkhrct_post  suicide_baseline  $year if year==2011 [aw=pop_sizebaseline] , cluster(kecid)
	sigstar treat_pkhrct_post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col15
    estadd loc thisstat4 = "`r(sestar)'": col15
    estadd loc thisstat14 = `e(N)': col15
	sum n_numberofsuicides  if treat_pkhrct==0 & year==2011 [aw=pop_sizebaseline]
    estadd loc thisstat13 = string(r(mean), "%9.3f"): col15
 
	estadd loc thisstat7 = "N": col15
    estadd loc thisstat8 = "N": col15
    estadd loc thisstat11 = "Y": col15
    estadd loc thisstat9 = "N": col15
	estadd loc thisstat10 = "Y": col15
    estadd loc thisstat15 = "11": col15

	

	
	

	

 
loc rowlabels " " " "  " "Treatment" " " " " " " "\hline Subdistrict FE" "Time FE"  "Include pre-treatment periods" "Baseline suicide" "Population weights" " " "\hline Control mean (2011)" "N" "Census waves" "
loc rowstats ""

forval i = 1/15 {
    loc rowstats "`rowstats' thisstat`i'"
}





esttab * using "$tables/TableA11_RCTaltoutcomes2.tex", replace cells(none) booktabs nonotes nomtitle  compress /// 
alignment(c) nogap noobs nobaselevels label stats(`rowstats', labels(`rowlabels')) ///
    mgroup("Suicide rate (2005 population)"   "Number of suicides (extrapolated - Poisson)" "Number of suicides", pattern(1 0 0 0 0 1 0 0 0 0 1 0 0 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) 



*eststo clear
