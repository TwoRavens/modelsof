
use "$data/podes_pkhrollout.dta", clear	
		
		
	xtset kecid t
	global year year2000 year2003 year2005 year2011 year2014
	

/* Initialize empty table */	
loc experiments " 1 2 "

	
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
*****************************Column 1: Test for difference in pre-trends  ******
********************************************************************************
	
	
	** Generate entry timing variable
	gen entry= 2 if treat0708!=0 |treat1011!=0
	replace entry= 3 if treat1213!=0
	replace entry= 1 if never_treat==1
	
	reg d.nsuicidespc  ib1.entry $year if year>=2000 & year<=2005 [aw=pop_sizebaseline], cluster(kabuid)   
	
	
    estadd loc thisstat12 = `e(N)': col1
	
	sigstar 2.entry , prec(3)
	 estadd loc thisstat2 = "`r(bstar)'": col1
    estadd loc thisstat3 = "`r(sestar)'": col1
	
	sigstar 3.entry , prec(3)
    estadd loc thisstat5 = "`r(bstar)'": col1
    estadd loc thisstat6 = "`r(sestar)'": col1
	


	estadd loc thisstat11 = "N": col1
	estadd loc thisstat13 = "00-05": col1


	

********************************************************************************
*****************************Column 1: Controling for lagged suicide rates *****
********************************************************************************

	egen treat_07081011=rowtotal(treat_07081011_2000 treat_07081011_2003 treat_07081011_2005 treat_07081011_2011 treat_07081011_2014)
	gen pre_treat = year==2005 if treat_07081011>0& treat_07081011<.
	replace pre_treat = year==2011 if treat1213>0& treat1213<.
	replace pre_treat= 0 if never_treat==1

	
 

	xtreg nsuicidespc treat_post pre_treat $year if year>=2000 & year<=2014 [aw=pop_sizebaseline], fe cluster(kabuid)

    estadd loc thisstat12 = `e(N)': col2
	
	sigstar treat_post, prec(3)
    estadd loc thisstat8 = "`r(bstar)'": col2
    estadd loc thisstat9 = "`r(sestar)'": col2
	
	estadd loc thisstat11 = "Y": col2
	estadd loc thisstat13 = "00-14": col2
	


  


	
sum  nsuicidespc if never_treat==1 & year>=2005
    estadd loc thisstat19 = string(r(mean), "%9.3f"): col2
	
	 

 
loc rowlabels " " "  "Treatment wave 1: 07-11" " "  " " "Treatment wave 2: 12-13" " " " " "Treatment" " "  " "  "\midrule Include pre treatment dummy" " \midrule N" "Census waves" "
loc rowstats ""

forval i = 1/13 {
    loc rowstats "`rowstats' thisstat`i'"
}





esttab * using "$tables/TableA3_identcheck.tex", replace cells(none) booktabs nonotes  compress ///
 alignment(c) nogap noobs nobaselevels label stats(`rowstats', labels(`rowlabels')) ///
 mtitle(  "$\Delta$ Suicide rate" "Suicide rate")
 
eststo clear
	
	
 
