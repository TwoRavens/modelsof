
use "$data/podes_pkhrollout.dta", clear	


global control  pcn_crimebaseline  pcn_socorgbaseline   pcHealthbaseline poor perc_farmers2005baseline pcn_educ 

global control_post tpcn_crimebaseline tpcn_socorgbaseline tpcHealthbaseline tpoor tperc_farmers2005baseline tpcn_educ 
	
		 
	xtset kecid year
	global year year2000 year2003 year2005 year2011 year2014
	
/* Initialize empty table */	
loc experiments " 1 2 3 4 "

	
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
*****************************Column 1: District FE **********************
********************************************************************************
	
	
	reg nsuicidespc post     $year  i. kabuid if year>=2005 [aw=pop_sizebaseline],  cluster(kabuid)

    estadd loc thisstat14 = `e(N)': col1
	

 sigstar post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col1
    estadd loc thisstat4 = "`r(sestar)'": col1

	estadd loc thisstat6 = "N": col1
    estadd loc thisstat7 = "Y": col1
    estadd loc thisstat8 = "Y": col1
    estadd loc thisstat9 = "N": col1
    estadd loc thisstat10 = "N": col1
    estadd loc thisstat11 = "N": col1
    estadd loc thisstat12 = "Y": col1

	
sum nsuicidespc if never_treat==1 & year>2005 [aw=pop_sizebaseline]
    estadd loc thisstat13 = string(r(mean), "%9.3f"): col1			
    estadd loc thisstat15 = "05-14": col1
	
	
********************************************************************************
*****************************Column 2: District trend   *******************
********************************************************************************

	xtreg nsuicidespc treat_post   $year i.kabuid#c.year if year>=2005 [aw=pop_sizebaseline], fe cluster(kecid)

  estadd loc thisstat14 = `e(N)': col2
	
 sigstar treat_post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col2
    estadd loc thisstat4 = "`r(sestar)'": col2

		
 
	estadd loc thisstat6 = "Y": col2
    estadd loc thisstat7 = "Y": col2
    estadd loc thisstat8 = "N": col2
    estadd loc thisstat9 = "Y": col2
    estadd loc thisstat10 = "N": col2
    estadd loc thisstat11 = "N": col2
    estadd loc thisstat12 = "Y": col2
  
	
	sum nsuicidespc if never_treat==1 & year>2005 [aw=pop_sizebaseline]
    estadd loc thisstat13 = string(r(mean), "%9.3f"): col2
    estadd loc thisstat15 = "05-14": col2
	
	
	

********************************************************************************
*****************************Column 3: Include controls  ************************
********************************************************************************




	reg nsuicidespc treat_post any_treat $year $control if year>=2005 & rctsample!=1 [aw=pop_sizebaseline], cluster(kabuid)

	 estadd loc thisstat14 = `e(N)': col3
	
 sigstar treat_post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col3
    estadd loc thisstat4 = "`r(sestar)'": col3

		
 
	estadd loc thisstat6 = "N": col3
    estadd loc thisstat7 = "Y": col3
    estadd loc thisstat8 = "N": col3
    estadd loc thisstat9 = "N": col3
    estadd loc thisstat10 = "Y": col3
    estadd loc thisstat11 = "N": col3
    estadd loc thisstat12 = "Y": col3

sum nsuicidespc if never_treat==1 &rctsample!=1& year>2005 [aw=pop_sizebaseline]
    estadd loc thisstat13 = string(r(mean), "%9.3f"): col3
    estadd loc thisstat15 = "05-14": col3
	
	global year year2000 year2003 year2005 year2011 year2014
	
********************************************************************************
*****************************Column 4: Controls time spost ************************
********************************************************************************

	reg nsuicidespc treat_post any_treat $control_post  $control $year if year>=2005  [aw=pop_sizebaseline],  cluster(kabuid)

  estadd loc thisstat14 = `e(N)': col4
	
 sigstar treat_post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col4
    estadd loc thisstat4 = "`r(sestar)'": col4

		
 
	estadd loc thisstat6 = "N": col4
    estadd loc thisstat7 = "Y": col4
    estadd loc thisstat8 = "N": col4
    estadd loc thisstat9 = "N": col4
    estadd loc thisstat10 = "Y": col4
    estadd loc thisstat11 = "Y": col4
    estadd loc thisstat12 = "Y": col4
	
	sum nsuicidespc if never_treat==1 & year>2005 [aw=pop_sizebaseline]
    estadd loc thisstat13 = string(r(mean), "%9.3f"): col4
    estadd loc thisstat15 = "05-14": col4
	
	


  
loc rowlabels " "Dependent variable: Suicide rate " "\cline{1-1} " "Treatment" " " " " "\hline Subdistrict FE" "Time FE" "District FE" "District trends" "Baseline controls"  "Baseline controls $\times$ Post" "Population weights" "\hline Control mean (2011 \& 2014)" "N" "Census waves" "
loc rowstats ""

forval i = 1/15 {
    loc rowstats "`rowstats' thisstat`i'"
}





esttab * using "$tables/TableA9_rolloutmain_addrobust.tex", replace cells(none) booktabs nonotes nomtitle compress ///
 alignment(c) nogap noobs nobaselevels label stats(`rowstats', labels(`rowlabels')) 
 


eststo clear
	
	
 
