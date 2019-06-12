
use "$data/podes_pkhrollout.dta", clear

replace pcexp = pcexp*0.83 //Deflating to 2005 numbers
replace perc_farmers2005=perc_farmers2005/100 // Rescaling for consistence



/* Initialize empty table */
loc experiments " 1 2 3 4 5" // Number of columns


	
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

 
loc rowstats ""

forval i = 0/14{
    loc rowstats "`rowstats' thisstat`i'"
}

********************************************************************************
*****************************column 1: fraction poor ***************************
********************************************************************************

reg nsuicidespc  poor  if year==2005 [aw=pop_size2005], cl(kabuid)
    estadd loc thisstat28 = `e(N)': col1
    estadd loc thisstat27 = string(`e(r2)', "%9.3f"): col1
    estadd loc thisstat29 = "05": col1
	
	
	sigstar poor, prec(3)
	estadd loc thisstat3 = "`r(bstar)'": col1
    estadd loc thisstat4 = "`r(sestar)'": col1		

	sigstar _cons, prec(3)
	estadd loc thisstat24 = "`r(bstar)'": col1
    estadd loc thisstat25 = "`r(sestar)'": col1	
	
	
	
********************************************************************************
*****************************column 2: percentage farmers **********************
********************************************************************************

reg nsuicidespc  perc_farmers2005  if year==2005 [aw=pop_size2005], cl(kabuid)
    estadd loc thisstat28 = `e(N)': col2
    estadd loc thisstat27 = string(`e(r2)', "%9.3f"): col2
    estadd loc thisstat29 = "05": col2
	
	
	sigstar perc_farmers2005, prec(3)
	estadd loc thisstat6 = "`r(bstar)'": col2
    estadd loc thisstat7 = "`r(sestar)'": col2	

	sigstar _cons, prec(3)
	estadd loc thisstat24 = "`r(bstar)'": col2
    estadd loc thisstat25 = "`r(sestar)'": col2	

	
********************************************************************************
*****************************column 3: per capita district expenditure**********
********************************************************************************

reg nsuicidespc pcexp   if year==2005 [aw=pop_size2005], cl(kabuid)

    estadd loc thisstat28 = `e(N)': col3
    estadd loc thisstat27 = string(`e(r2)', "%9.3f"): col3
    estadd loc thisstat29 = "05": col3

	sigstar pcexp, prec(3)
	estadd loc thisstat9 = "`r(bstar)'": col3
    estadd loc thisstat10 = "`r(sestar)'": col3	
	
	
	sigstar _cons, prec(3)
	estadd loc thisstat24 = "`r(bstar)'": col3
    estadd loc thisstat25 = "`r(sestar)'": col3	

			

			
********************************************************************************
*****************************column 4: Poverty measures jointly ****************
********************************************************************************
			
reg nsuicidespc perc_farmers2005 pcexp poor if year==2005 [aw=pop_size2005], cl(kabuid)
    estadd loc thisstat28 = `e(N)': col4
    estadd loc thisstat27 = string(`e(r2)', "%9.3f"): col4
    estadd loc thisstat29 = "05": col4
	
	sigstar poor, prec(3)
	estadd loc thisstat3 = "`r(bstar)'": col4
    estadd loc thisstat4 = "`r(sestar)'": col4		
	
	sigstar perc_farmers2005, prec(3)
	estadd loc thisstat6 = "`r(bstar)'": col4
    estadd loc thisstat7 = "`r(sestar)'": col4	
	

	sigstar pcexp, prec(3)
	estadd loc thisstat9 = "`r(bstar)'": col4 
	estadd loc thisstat10 = "`r(sestar)'": col4	
	
	sigstar _cons, prec(3)
	estadd loc thisstat24 = "`r(bstar)'": col4
    estadd loc thisstat25 = "`r(sestar)'": col4	



********************************************************************************
*****************************column 5: All descriptive *************************
********************************************************************************

reg nsuicidespc  poor  perc_farmers2005  pcexp pcn_educ pcn_socorg pcn_crime pcn_healthfacilities  if year==2005 [aw=pop_size2005], cl(kabuid)
    estadd loc thisstat28 = `e(N)': col5
    estadd loc thisstat27 = string(`e(r2)', "%9.3f"): col5
    estadd loc thisstat29 = "05": col5

	
	sigstar poor, prec(3)
	estadd loc thisstat3 = "`r(bstar)'": col5
    estadd loc thisstat4 = "`r(sestar)'": col5		
	
	sigstar perc_farmers2005, prec(3)
	estadd loc thisstat6 = "`r(bstar)'": col5
    estadd loc thisstat7 = "`r(sestar)'": col5
	

	sigstar pcexp, prec(3)
	estadd loc thisstat9 = "`r(bstar)'": col5
    estadd loc thisstat10 = "`r(sestar)'": col5	
	
	
sigstar pcn_educ, prec(3)
	estadd loc thisstat12 = "`r(bstar)'": col5
    estadd loc thisstat13 = "`r(sestar)'": col5		
			
	
sigstar pcn_healthfacilities, prec(3)
	estadd loc thisstat15= "`r(bstar)'": col5
    estadd loc thisstat16 = "`r(sestar)'": col5		
		
sigstar pcn_socorg, prec(3)
	estadd loc thisstat18 = "`r(bstar)'": col5
    estadd loc thisstat19= "`r(sestar)'": col5		

sigstar pcn_crime, prec(3)
	estadd loc thisstat21 = "`r(bstar)'": col5
    estadd loc thisstat22 = "`r(sestar)'": col5		
	
sigstar _cons, prec(3)
	estadd loc thisstat24 = "`r(bstar)'": col5
    estadd loc thisstat25 = "`r(sestar)'": col5		
**

		
		
	
loc rowlabels " "Dependent variable: Suicide rate" "\cline{1-1} " " " "Fraction poor" " " " " "Fraction farmers" " " " " "Average HH expenditure (per capita)" " " " " "Education (per capita)" " " " "  "Health facilities (per capita)" " " " " "Social organisations (per capita)"  " " " " "Crime (per capita)" " " " " "Constant" " " " " "\hline R2" "N" "Census wave"  "
loc rowstats ""

forval i = 0/29{
    loc rowstats "`rowstats' thisstat`i'"
}


esttab col1 col2 col3 col4 col5 using "$tables/TableA1_correlates_suicides.tex", replace cells(none) ///
booktabs nonotes nomtitle compress alignment(c) nogap noobs nobaselevels label stats(`rowstats', labels(`rowlabels'))
 

est clear
