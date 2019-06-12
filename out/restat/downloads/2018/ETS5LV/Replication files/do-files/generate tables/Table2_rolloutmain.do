
use "$data/podes_pkhrollout.dta", clear
		

xtset kecid t
global year year2000 year2003 year2005 year2011 year2014
	
/* Initialize empty table */	
loc experiments " 1 2 3 4 5 6"

	
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
*****************************Column 1: Main specification **********************
********************************************************************************
	
	
	xtreg nsuicidespc post     $year if year>=2005 [aw=pop_sizebaseline], fe cluster(kabuid)

    estadd loc thisstat14 = `e(N)': col1
	

 sigstar post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col1
    estadd loc thisstat4 = "`r(sestar)'": col1

	estadd loc thisstat6 = "Y": col1
    estadd loc thisstat7 = "Y": col1
    estadd loc thisstat8 = "N": col1
    estadd loc thisstat9 = "N": col1
    estadd loc thisstat10 = "N": col1
    estadd loc thisstat11 = "N": col1
    estadd loc thisstat12 = "Y": col1

	
sum nsuicidespc if never_treat==1 & year>2005 [aw=pop_sizebaseline]
    estadd loc thisstat13 = string(r(mean), "%9.3f"): col1			
    estadd loc thisstat15 = "05-14": col1
	
	
********************************************************************************
*****************************Column 2: Cluster subdistrict   *******************
********************************************************************************

	xtreg nsuicidespc treat_post   $year if year>=2005 [aw=pop_sizebaseline], fe cluster(kecid)

  estadd loc thisstat14 = `e(N)': col2
	
 sigstar treat_post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col2
    estadd loc thisstat4 = "`r(sestar)'": col2

		
 
	estadd loc thisstat6 = "Y": col2
    estadd loc thisstat7 = "Y": col2
    estadd loc thisstat8 = "Y": col2
    estadd loc thisstat9 = "N": col2
    estadd loc thisstat10 = "N": col2
    estadd loc thisstat11 = "N": col2
    estadd loc thisstat12 = "Y": col2
  
	
	sum nsuicidespc if never_treat==1 & year>2005 [aw=pop_sizebaseline]
    estadd loc thisstat13 = string(r(mean), "%9.3f"): col2
    estadd loc thisstat15 = "05-14": col2
	
	
	

********************************************************************************
*****************************Column 3: Drop RCT sample  ************************
********************************************************************************




	xtreg nsuicidespc treat_post     $year if year>=2005 & rctsample!=1 [aw=pop_sizebaseline], fe cluster(kabuid)

	 estadd loc thisstat14 = `e(N)': col3
	
 sigstar treat_post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col3
    estadd loc thisstat4 = "`r(sestar)'": col3

		
 
	estadd loc thisstat6 = "Y": col3
    estadd loc thisstat7 = "Y": col3
    estadd loc thisstat8 = "N": col3
    estadd loc thisstat9 = "Y": col3
    estadd loc thisstat10 = "N": col3
    estadd loc thisstat11 = "N": col3
    estadd loc thisstat12 = "Y": col3

sum nsuicidespc if never_treat==1 &rctsample!=1& year>2005 [aw=pop_sizebaseline]
    estadd loc thisstat13 = string(r(mean), "%9.3f"): col3
    estadd loc thisstat15 = "05-14": col3
	
	global year year2000 year2003 year2005 year2011 year2014
	
********************************************************************************
*****************************Column 4: All time periods ************************
********************************************************************************

	xtreg nsuicidespc treat_post    $year if year>=2000  [aw=pop_sizebaseline], fe cluster(kabuid)

  estadd loc thisstat14 = `e(N)': col4
	
 sigstar treat_post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col4
    estadd loc thisstat4 = "`r(sestar)'": col4

		
 
	estadd loc thisstat6 = "Y": col4
    estadd loc thisstat7 = "Y": col4
    estadd loc thisstat8 = "N": col4
    estadd loc thisstat9 = "N": col4
    estadd loc thisstat10 = "Y": col4
    estadd loc thisstat11 = "N": col4
    estadd loc thisstat12 = "Y": col4
	
	sum nsuicidespc if never_treat==1 & year>2005 [aw=pop_sizebaseline]
    estadd loc thisstat13 = string(r(mean), "%9.3f"): col4
    estadd loc thisstat15 = "00-14": col4
	
	
********************************************************************************
*****************************Column 5: Sub-district trends *********************
********************************************************************************
 		preserve 	
	
	 hdfe nsuicidespc  treat_post if year>=2000 [aw=pop_sizebaseline], absorb(i.kecid2000##c.year $year) clear  keepvars(kabuid never_treat) clustervars(kabuid)
	ivreg2 nsuicidespc treat_post    [aw=pop_sizebaseline], cl(kabuid)
	
		 estadd loc thisstat14 = `e(N)': col5
	


		
 sigstar treat_post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col5
    estadd loc thisstat4 = "`r(sestar)'": col5
	
		
	estadd loc thisstat6 = "Y": col5
    estadd loc thisstat7 = "Y": col5
    estadd loc thisstat8 = "N": col5
    estadd loc thisstat9 = "N": col5
    estadd loc thisstat10 = "Y": col5
    estadd loc thisstat11 = "Y": col5
    estadd loc thisstat12 = "Y": col5

	
	restore
		sum nsuicidespc if never_treat==1 &year>2005 [aw=pop_sizebaseline]
    estadd loc thisstat13 = string(r(mean), "%9.3f"): col5
    estadd loc thisstat15 = "00-14": col5


********************************************************************************
*****************************Column 6: without popweights **********************
********************************************************************************
	
	
	xtreg nsuicidespc post     $year if year>=2005, fe cluster(kabuid)

    estadd loc thisstat14 = `e(N)': col6
	

 sigstar post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col6
    estadd loc thisstat4 = "`r(sestar)'": col6

	estadd loc thisstat6 = "Y": col6
    estadd loc thisstat7 = "Y": col6
    estadd loc thisstat8 = "N": col6
    estadd loc thisstat9 = "N": col6
    estadd loc thisstat10 = "N": col6
    estadd loc thisstat11 = "N": col6
    estadd loc thisstat12 = "N": col6
	

	sum nsuicidespc if never_treat==1 & year>2005
    estadd loc thisstat13 = string(r(mean), "%9.3f"): col6
    estadd loc thisstat15 = "05-14": col6
	
		 

  
loc rowlabels " "Dependent variable: Suicide rate " "\cline{1-1} " "Treatment" " " " " "\hline Subdistrict FE" "Time FE" "Cluster subdistrict" "Exclude RCT sample" "Include pre-treatment periods" "Subdistrict trends" "Population weights" "\hline Control mean (2011 \& 2014)" "N" "Census waves" "
loc rowstats ""

forval i = 1/15 {
    loc rowstats "`rowstats' thisstat`i'"
}





esttab * using "$tables/Table2_rolloutmain.tex", replace cells(none) booktabs nonotes nomtitle compress ///
 alignment(c) nogap noobs nobaselevels label stats(`rowstats', labels(`rowlabels')) 
 


eststo clear
	
	
 
