

use "$data/podes_pkhrollout.dta", clear

 
	xtset kecid t
	global year year2000 year2003 year2005 year2011 year2014
	
	
loc experiments " 1 2"
 
	
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

******column 1

		xtreg nsuicidespc post i.year if year>=2005  [aw=pop_sizebaseline], fe cl(kabuid)
		sigstar post, prec(3)
	estadd loc thisstat3 = "`r(bstar)'": col1
    estadd loc thisstat4 = "`r(sestar)'": col1		 
    estadd loc thisstat9 = `e(N)': col1
    estadd loc thisstat10 = "05-14": col1
		 		 

******column 2

		xtreg nsuicidespc post intensity i.year if year>=2005  [aw=pop_sizebaseline], fe cl(kabuid)
		sigstar post, prec(3)
	estadd loc thisstat3 = "`r(bstar)'": col2
    estadd loc thisstat4 = "`r(sestar)'": col2		 
		 		 
	sigstar intensity, prec(3)
	estadd loc thisstat6 = "`r(bstar)'": col2
    estadd loc thisstat7 = "`r(sestar)'": col2		 
    estadd loc thisstat9 = `e(N)': col2
    estadd loc thisstat10 = "05-14": col2
		 		 
				 		 
		 
 
loc rowlabels " "Dependent variable: Suicide rate" "\cline{1-1}"  "Treatment" " " " " "Intensity" " " " " " \midrule N" "Census Waves" "
loc rowstats ""

forval i = 1/10 {
    loc rowstats "`rowstats' thisstat`i'"
}





esttab * using "$tables/TableA18_intensity.tex", replace cells(none) booktabs nonotes nomtitle  compress ///
 alignment(c) nogap noobs nobaselevels label stats(`rowstats', labels(`rowlabels'))  


eststo clear
	
	
 
