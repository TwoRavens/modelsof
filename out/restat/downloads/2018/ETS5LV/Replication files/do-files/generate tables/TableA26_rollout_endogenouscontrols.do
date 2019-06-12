
use "$data/podes_pkhrollout.dta", clear
		
	xtset kecid t
	global year year2000 year2003 year2005 year2011 year2014
	
	
loc experiments " 1 2 3 4 5"

	
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

foreach var of varlist anycrime pcn_crime pctheft pcrobbery pclooting pcviolence pccombustion pcrape pcdrugtraficking pcmurder pcchildsale gotong  pcHealth  pcn_educ {
count if `var'==. & year==2011
count if `var'==. & year==2014
count if `var'==. & year==2005
sum `var' if year>=2005, d
}

	
	global crimecontrols anycrime pcn_crime pctheft pcrobbery pclooting pcviolence pccombustion pcrape pcdrugtraficking pcmurder pcchildsale 
	global instututions gotong  pcHealth  pcn_educ 
	global socialcontrols pcn_socorg pcn_actinst pcrel_org socorg
	

	
********************************************************************************
*****************************Column 1: Main specification **********************
********************************************************************************
	
	
	xtreg nsuicidespc post     $year if year>=2005 [aw=pop_sizebaseline], fe cluster(kabuid)

    estadd loc thisstat14 = `e(N)': col1
	

 sigstar post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col1
    estadd loc thisstat4 = "`r(sestar)'": col1

	estadd loc thisstat8 = "Y": col1
    estadd loc thisstat9 = "Y": col1
    estadd loc thisstat10 = "N": col1
    estadd loc thisstat11 = "N": col1
    estadd loc thisstat12 = "N": col1
	estadd loc thisstat15 = "05-14": col1


	
sum nsuicidespc [aw=pop_sizebaseline] if never_treat==1 & year>=2005
    estadd loc thisstat13 = string(r(mean), "%9.3f"): col1			
	


********************************************************************************
*****************************Column 2: Crime controls***************************
********************************************************************************
		

	xtreg nsuicidespc post  $crimecontrols   $year if year>=2005 [aw=pop_sizebaseline], fe cluster(kabuid)

    estadd loc thisstat14 = `e(N)': col2
	

 sigstar post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col2
    estadd loc thisstat4 = "`r(sestar)'": col2

	estadd loc thisstat8 = "Y": col2
    estadd loc thisstat9 = "Y": col2
    estadd loc thisstat10 = "Y": col2
    estadd loc thisstat11 = "N": col2
    estadd loc thisstat12 = "N": col2
	estadd loc thisstat15 = "05-14": col2

	
sum nsuicidespc [aw=pop_sizebaseline] if never_treat==1 & year>=2005
    estadd loc thisstat13 = string(r(mean), "%9.3f"): col2			
	
		
		

********************************************************************************
*****************************Column 3: institution controls*********************
********************************************************************************
				
	xtreg nsuicidespc post  $instututions   $year if year>=2005 [aw=pop_sizebaseline], fe cluster(kabuid)

    estadd loc thisstat14 = `e(N)': col3
	

 sigstar post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col3
    estadd loc thisstat4 = "`r(sestar)'": col3

	estadd loc thisstat8 = "Y": col3
    estadd loc thisstat9 = "Y": col3
    estadd loc thisstat10 = "N": col3
    estadd loc thisstat11 = "Y": col3
    estadd loc thisstat12 = "N": col3
	estadd loc thisstat15 = "05-14": col3


	
sum nsuicidespc [aw=pop_sizebaseline] if never_treat==1 & year>=2005
    estadd loc thisstat13 = string(r(mean), "%9.3f"): col3		
	

********************************************************************************
*****************************Column 4: baseline********************************
********************************************************************************
				
	
		xtreg nsuicidespc post    $year if year>=2005 & year<=2011 [aw=pop_sizebaseline], fe cluster(kabuid)
    estadd loc thisstat14 = `e(N)': col4


 sigstar post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col4
    estadd loc thisstat4 = "`r(sestar)'": col4

	estadd loc thisstat8 = "Y": col4
    estadd loc thisstat9 = "Y": col4
    estadd loc thisstat10 = "N": col4
    estadd loc thisstat11 = "N": col4
    estadd loc thisstat12 = "N": col4
	estadd loc thisstat15 = "05-11": col4

sum nsuicidespc [aw=pop_sizebaseline] if never_treat==1 & year>=2005
    estadd loc thisstat13 = string(r(mean), "%9.3f"): col4	
	

		
********************************************************************************
*****************************Column 5: social capital***************************
********************************************************************************
					
	xtreg nsuicidespc post  $socialcontrols  $year if year>=2005 & year<=2011 [aw=pop_sizebaseline], fe cluster(kabuid)
    estadd loc thisstat14 = `e(N)': col5

	sigstar post, prec(3)
    estadd loc thisstat3 = "`r(bstar)'": col5
    estadd loc thisstat4 = "`r(sestar)'": col5

	estadd loc thisstat8 = "Y": col5
    estadd loc thisstat9 = "Y": col5
    estadd loc thisstat10 = "N": col5
    estadd loc thisstat11 = "N": col5
    estadd loc thisstat12 = "Y": col5
	estadd loc thisstat15 = "05-11": col5


sum nsuicidespc [aw=pop_sizebaseline] if never_treat==1 & year>=2005
    estadd loc thisstat13 = string(r(mean), "%9.3f"): col5		
	


	
 
loc rowlabels " "Dependent variable: Suicide rate " "\cline{1-1} " "Treatment" " " " " " " " " "\hline Subdistrict FE" "Time FE" "Crime controls" "Institution controls" "Social capital controls" "\hline Control mean (2011 \& 2014)"  "N" "Census waves" "
loc rowstats ""

forval i = 1/15 {
    loc rowstats "`rowstats' thisstat`i'"
}





esttab * using "$tables/TableA26_rollout_endogenouscontrols.tex", replace cells(none) booktabs nonotes nomtitle compress ///
 alignment(c) nogap noobs nobaselevels label stats(`rowstats', labels(`rowlabels')) 
 


eststo clear
	
	
 
