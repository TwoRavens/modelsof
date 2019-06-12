use "$data/podes_pkhrollout.dta", clear
 
keep if rctsample==1
 



global control  pcn_crimebaseline  pcn_socorgbaseline   pcHealthbaseline poor perc_farmers2005baseline pcn_educ 

global control_post tpcn_crimebaseline tpcn_socorgbaseline tpcHealthbaseline tpoor tperc_farmers2005baseline tpcn_educ 
	
	 
loc experiments "1 2 3 4"
	global year year2000 year2003 year2005 year2011 year2014

/* Initialize empty table */

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



********************************************************************************
*****************************Column 1: District FE******************************
********************************************************************************
	

	reg nsuicidespc treat_pkhrct_post treat_pkhrct year2011 year2005 i.kabuid if year==2005 | year==2011 [aw=pop_sizebaseline],  cluster(kecid)
    sigstar treat_pkhrct_post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col1
    estadd loc thisstat4 = "`r(sestar)'": col1
    estadd loc thisstat15 = `e(N)': col1
		sum nsuicidespc if treat_pkhrct==0 & year==2011 [aw=pop_sizebaseline]
    estadd loc thisstat14 = string(r(mean), "%9.3f"): col1
 
	estadd loc thisstat7 = "N": col1
    estadd loc thisstat8 = "Y": col1
    estadd loc thisstat9 = "Y": col1
    estadd loc thisstat10 = "N": col1
    estadd loc thisstat11 = "N": col1
	estadd loc thisstat12 = "N": col1
	estadd loc thisstat13 = "Y": col1
	estadd loc thisstat16 = "05-11": col1

	
********************************************************************************	
*****************************Column 2: District Trend **************************
********************************************************************************


	
	
	xi: xtreg nsuicidespc treat_pkhrct_post i.kabuid*year treat_pkhrct year2011  if year==2005 | year==2011 [aw=pop_sizebaseline], fe cluster(kabuid)
	sigstar treat_pkhrct_post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col2
    estadd loc thisstat4 = "`r(sestar)'": col2
    estadd loc thisstat15 = `e(N)': col2
	sum nsuicidespc if treat_pkhrct==0 & year==2011 [aw=pop_sizebaseline]
    estadd loc thisstat14 = string(r(mean), "%9.3f"): col2
 
	estadd loc thisstat7 = "Y": col2
    estadd loc thisstat8 = "Y": col2
    estadd loc thisstat9 = "N": col2
    estadd loc thisstat10 = "Y": col2
    estadd loc thisstat11 = "N": col2	
	estadd loc thisstat12 = "N": col2
	estadd loc thisstat13 = "Y": col2
	estadd loc thisstat16 = "05-11": col2

	
	
********************************************************************************	
*****************************Column 3: Control   *******************************
********************************************************************************
	
	
	reg nsuicidespc treat_pkhrct_post treat_pkhrct $control  $year if year==2005 | year==2011, cluster(kecid)
    sigstar treat_pkhrct_post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col3
    estadd loc thisstat4 = "`r(sestar)'": col3
    estadd loc thisstat15 = `e(N)': col3
	sum nsuicidespc if treat_pkhrct==0 & year==2011 [aw=pop_sizebaseline]
    estadd loc thisstat14 = string(r(mean), "%9.3f"): col3
 
	estadd loc thisstat7 = "N": col3
    estadd loc thisstat8 = "Y": col3
    estadd loc thisstat9 = "N": col3
    estadd loc thisstat10 = "N": col3
    estadd loc thisstat11 = "Y": col3	
	estadd loc thisstat12 = "N": col3
	estadd loc thisstat13 = "Y": col3
	estadd loc thisstat16 = "05-11": col3

	
********************************************************************************
*****************************Column 4: Control times post **********************
********************************************************************************

 reg nsuicidespc treat_pkhrct_post  treat_pkhrct  $control $control_post  $year if year==2005 | year==2011 [aw=pop_sizebaseline], cluster(kecid)
 sigstar treat_pkhrct_post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col4
    estadd loc thisstat4 = "`r(sestar)'": col4
    estadd loc thisstat15 = `e(N)': col4
		sum nsuicidespc if treat_pkhrct==0 & year==2011 [aw=pop_sizebaseline]
    estadd loc thisstat14 = string(r(mean), "%9.3f"): col4
 
	estadd loc thisstat7 = "N": col4
    estadd loc thisstat8 = "Y": col4
    estadd loc thisstat9 = "N": col4
    estadd loc thisstat10 = "N": col4
    estadd loc thisstat11 = "Y": col4
	estadd loc thisstat12 = "Y": col4
	estadd loc thisstat13 = "Y": col4
	estadd loc thisstat16 = "05-11": col4
 
	


 
loc rowlabels " "Dependent variable: Suicide rate" "\cline{1-1}" "Treatment" " " " " " " "\hline Subdistrict FE" "Time FE"  "District FE" "District trends" "Baseline controls"  "Baseline controls $\times$ Post" "Population weights" "\hline Control mean (2011)" "N" "Census waves"  "
loc rowstats ""

forval i = 1/16 {
    loc rowstats "`rowstats' thisstat`i'"
}

esttab * using "$tables/TableA15_RCTmain_addrobust.tex", replace cells(none) booktabs nonotes nomtitle compress /// 
alignment(c) nogap noobs nobaselevels label stats(`rowstats', labels(`rowlabels')) 


eststo clear
