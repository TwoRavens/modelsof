
use "$data/podes_pkhrollout.dta", clear
 
keep if rctsample==1


/* Initialize empty table */
loc experiments "1 2 3 4 5 6 7"

tab treat_pkhrct

drop if treat_pkhrct>0 & treat_pkhrct<1

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

/* Statistics */

loc colnum = 1
loc colnames ""
********************************************************************************	
*****************************Column 1: ANCOVA*********************************
********************************************************************************	


	reg nsuicidespc treat_pkhrct_post nsuicidespc_baseline  $year if year==2011 [aw=pop_sizebaseline], cluster(kecid)
 sigstar treat_pkhrct_post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col1
    estadd loc thisstat4 = "`r(sestar)'": col1
    estadd loc thisstat15 = `e(N)': col1
		sum nsuicidespc if treat_pkhrct==0 & year==2011 [aw=pop_sizebaseline]
    estadd loc thisstat14 = string(r(mean), "%9.3f"): col1
 
	estadd loc thisstat7 = "N": col1
    estadd loc thisstat8 = "N": col1
    estadd loc thisstat9 = "N": col1
    estadd loc thisstat10 = "N": col1
    estadd loc thisstat11 = "N": col1		
	estadd loc thisstat12 = "Y": col1	
	estadd loc thisstat13 = "Y": col1
	estadd loc thisstat16 = "11": col1
	
	
********************************************************************************	
*****************************Column 2: Post estimator***************************
********************************************************************************	


	reg nsuicidespc treat_pkhrct_post  $year if year==2011 [aw=pop_sizebaseline], cluster(kecid)
 sigstar treat_pkhrct_post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col2
    estadd loc thisstat4 = "`r(sestar)'": col2
    estadd loc thisstat15 = `e(N)': col2
		sum nsuicidespc if treat_pkhrct==0 & year==2011 [aw=pop_sizebaseline]
    estadd loc thisstat14 = string(r(mean), "%9.3f"): col2
 
	estadd loc thisstat7 = "N": col2
    estadd loc thisstat8 = "N": col2
    estadd loc thisstat9 = "N": col2
    estadd loc thisstat10 = "N": col2
    estadd loc thisstat11 = "N": col2		
	estadd loc thisstat12 = "N": col2	
	estadd loc thisstat13 = "Y": col2
	estadd loc thisstat16 = "11": col2
 
	


********************************************************************************
*****************************Column 3: DD **************************************
********************************************************************************
	

	xtreg nsuicidespc treat_pkhrct_post treat_pkhrct year2011 year2005 if year==2005 | year==2011 [aw=pop_sizebaseline], fe cluster(kecid)
    sigstar treat_pkhrct_post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col3
    estadd loc thisstat4 = "`r(sestar)'": col3
    estadd loc thisstat15 = `e(N)': col3
		sum nsuicidespc if treat_pkhrct==0 & year==2011 [aw=pop_sizebaseline]
    estadd loc thisstat14 = string(r(mean), "%9.3f"): col3
 
	estadd loc thisstat7 = "Y": col3
    estadd loc thisstat8 = "Y": col3
    estadd loc thisstat9 = "N": col3
    estadd loc thisstat10 = "N": col3
    estadd loc thisstat11 = "N": col3
	estadd loc thisstat12 = "N": col3
	estadd loc thisstat13 = "Y": col3
	estadd loc thisstat16 = "05-11": col3

	
********************************************************************************	
*****************************Column 4: cluster kabuid **************************
********************************************************************************


	
	
	xi: xtreg nsuicidespc treat_pkhrct_post treat_pkhrct year2011  if year==2005 | year==2011 [aw=pop_sizebaseline], fe cluster(kabuid)
	sigstar treat_pkhrct_post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col4
    estadd loc thisstat4 = "`r(sestar)'": col4
    estadd loc thisstat15 = `e(N)': col4
	sum nsuicidespc if treat_pkhrct==0 & year==2011 [aw=pop_sizebaseline]
    estadd loc thisstat14 = string(r(mean), "%9.3f"): col4
 
	estadd loc thisstat7 = "Y": col4
    estadd loc thisstat8 = "Y": col4
    estadd loc thisstat9 = "Y": col4
    estadd loc thisstat10 = "N": col4
    estadd loc thisstat11 = "N": col4	
	estadd loc thisstat12 = "N": col4
	estadd loc thisstat13 = "Y": col4
	estadd loc thisstat16 = "05-11": col4

	
	
********************************************************************************	
*****************************Column 5: Include pre-periods *********************
********************************************************************************
	
	
	xtreg nsuicidespc treat_pkhrct_post treat_pkhrct $year if year<=2011 , fe cluster(kecid)
    sigstar treat_pkhrct_post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col5
    estadd loc thisstat4 = "`r(sestar)'": col5
    estadd loc thisstat15 = `e(N)': col5
	sum nsuicidespc if treat_pkhrct==0 & year==2011 [aw=pop_sizebaseline]
    estadd loc thisstat14 = string(r(mean), "%9.3f"): col5
 
	estadd loc thisstat7 = "Y": col5
    estadd loc thisstat8 = "Y": col5
    estadd loc thisstat9 = "N": col5
    estadd loc thisstat10 = "Y": col5
    estadd loc thisstat11 = "N": col5	
	estadd loc thisstat12 = "N": col5
	estadd loc thisstat13 = "Y": col5
	estadd loc thisstat16 = "00-11": col5

	
********************************************************************************
*****************************Column 6: Subdistrict trends **********************
********************************************************************************

xi:	xtreg nsuicidespc treat_pkhrct_post  treat_pkhrct  i.kecid*year  $year if year<=2011 [aw=pop_sizebaseline], fe cluster(kecid)
 sigstar treat_pkhrct_post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col6
    estadd loc thisstat4 = "`r(sestar)'": col6
    estadd loc thisstat15 = `e(N)': col6
		sum nsuicidespc if treat_pkhrct==0 & year==2011 [aw=pop_sizebaseline]
    estadd loc thisstat14 = string(r(mean), "%9.3f"): col6
 
	estadd loc thisstat7 = "Y": col6
    estadd loc thisstat8 = "Y": col6
    estadd loc thisstat9 = "N": col6
    estadd loc thisstat10 = "Y": col6
    estadd loc thisstat11 = "Y": col6
	estadd loc thisstat12 = "N": col6
	estadd loc thisstat13 = "Y": col6
	estadd loc thisstat16 = "00-11": col6
 
	

 
	
********************************************************************************	
*****************************Column 7: No Population weights******************
********************************************************************************	
	
	
reg nsuicidespc treat_pkhrct_post nsuicidespc_baseline  $year if year==2011 , cluster(kecid)

sigstar treat_pkhrct_post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col7
    estadd loc thisstat4 = "`r(sestar)'": col7
    estadd loc thisstat15 = `e(N)': col7
		sum nsuicidespc  if treat_pkhrct==0 & year==2011
    estadd loc thisstat14 = string(r(mean), "%9.3f"): col7
 
	estadd loc thisstat7 = "N": col7
    estadd loc thisstat8 = "N": col7
    estadd loc thisstat9 = "N": col7
    estadd loc thisstat10 = "N": col7
    estadd loc thisstat11 = "N": col7		
	estadd loc thisstat12 = "Y": col7
	estadd loc thisstat13 = "N": col7
	estadd loc thisstat16 = "11": col7
	


 
loc rowlabels " "Dependent variable: Suicide rate" "\cline{1-1}" "Treatment" " " " " " " "\hline Subdistrict FE" "Time FE"  "Cluster district" "Include pre-treatment periods" "Subdistrict trends" "Baseline suicide" "Population weight" "\hline Control mean (2011)" "N" "Census waves" "
loc rowstats ""

forval i = 1/16 {
    loc rowstats "`rowstats' thisstat`i'"
}





esttab * using "$tables/TableA12_RCTmain_droppartials.tex", replace cells(none) booktabs nonotes nomtitle compress /// 
alignment(c) nogap noobs nobaselevels label stats(`rowstats', labels(`rowlabels')) 


eststo clear
