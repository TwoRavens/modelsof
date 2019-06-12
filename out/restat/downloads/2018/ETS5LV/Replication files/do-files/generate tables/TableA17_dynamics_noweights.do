

use "$data/podes_pkhrollout.dta", clear

	
global year year2000 year2003 year2005 year2011 year2014


loc experiments "1 2 3 4"

	
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
*****************************Column 1*******************************************
********************************************************************************



	

	xtreg nsuicidespc treat_pkhrct_post treat_pkhrct year2011 year2005 if year==2005 | year==2011, fe cluster(kecid)
    sigstar treat_pkhrct_post, prec(3)
    estadd loc thisstat4 = "`r(bstar)'": col1
    estadd loc thisstat5 = "`r(sestar)'": col1

	estadd loc thisstat7 = "3-4": col1
	estadd loc thisstat8 = "05 \& 11": col1
	sum nsuicidespc if year==2005 & treat_pkhrct>0 & treat_pkhrct!=.	
    estadd loc thisstat9 = "`r(N)'": col1	
	sum nsuicidespc if year==2005 & treat_pkhrct==0		
    estadd loc thisstat10 = "`r(N)'": col1		
	estadd loc thisstat11 = "Y": col1
	
	xtreg nsuicidespc treat_pkhrct_post treat_pkhrct year2011 year2005 if year==2005 | year==2014, fe cluster(kecid)
    sigstar treat_pkhrct_post, prec(3)	
	estadd loc thisstat15 = "`r(bstar)'": col1
    estadd loc thisstat16 = "`r(sestar)'": col1
	
	
    estadd loc thisstat18 = "6-7": col1
	estadd loc thisstat19 = "05 \& 14": col1
	sum nsuicidespc if year==2005 & treat_pkhrct>0 & treat_pkhrct!=.
    estadd loc thisstat20 = "`r(N)'": col1
	sum nsuicidespc if year==2005 & treat_pkhrct==0	
    estadd loc thisstat21 = "`r(N)'": col1
	estadd loc thisstat22 = "Partial": col1
    estadd loc thisstat23 = "Y": col1
	 
	
********************************************************************************
*****************************Column 2*******************************************
********************************************************************************


	xtreg   nsuicidespc treat0708_2000 treat0708_2003 treat0708_2011 treat0708_2014  treat1011_2000 treat1011_2003 treat1011_2011 treat1011_2014   treat1213_2000 treat1213_2003 treat1213_2005  treat1213_2014  $year , fe cluster(kabuid)
	  
	sigstar treat0708_2011, prec(3)
    estadd loc thisstat4 = "`r(bstar)'": col2
    estadd loc thisstat5 = "`r(sestar)'": col2
	estadd loc thisstat7 = "3-4": col2
	estadd loc thisstat8 = "05 \& 11": col2
	sum nsuicidespc if (treat0708>0) & year==2005  
	estadd loc thisstat9 = "`r(N)'": col2
	sum nsuicidespc if (any_treat==0)		& year==2005   
	estadd loc thisstat10 = "`r(N)'": col2
	estadd loc thisstat11 = "Y": col2
	
	
	sigstar treat0708_2014, prec(3)
	estadd loc thisstat15 = "`r(bstar)'": col2
    estadd loc thisstat16 = "`r(sestar)'": col2
	
	estadd loc thisstat18 = "6-7": col2
	estadd loc thisstat19 = "05 \& 14": col2
	sum nsuicidespc if (treat0708>0) & year==2005  
    estadd loc thisstat20 = "`r(N)'": col2	
	
	sum nsuicidespc if (any_treat==0)		& year==2005  
    estadd loc thisstat21 = "`r(N)'": col2	
	
	estadd loc thisstat22 = "Partial": col2
	 

	
********************************************************************************
*****************************Column 3*******************************************
********************************************************************************
	

	xtreg   nsuicidespc treat0708_2000 treat0708_2003 treat0708_2011 treat0708_2014 ///
    treat1011_2000 treat1011_2003 treat1011_2011 treat1011_2014  ///
    treat1213_2000 treat1213_2003 treat1213_2005  treat1213_2014  $year, fe cluster(kabuid)
	  	
	
	sigstar treat1011_2011, prec(3)
    estadd loc thisstat4 = "`r(bstar)'": col3
    estadd loc thisstat5 = "`r(sestar)'": col3

	estadd loc thisstat7 = "0-1": col3
	estadd loc thisstat8 = "05 \& 11": col3
	sum nsuicidespc if (treat1011>0) & year==2005  
	estadd loc thisstat9 = "`r(N)'": col3
	sum nsuicidespc if (any_treat==0)		 & year==2005   
	estadd loc thisstat10 = "`r(N)'": col3
	estadd loc thisstat11 = "Partial": col3
	
	
	sigstar treat1011_2014, prec(3)
	estadd loc thisstat15 = "`r(bstar)'": col3
    estadd loc thisstat16 = "`r(sestar)'": col3
	
	estadd loc thisstat18 = "3-4": col3
	estadd loc thisstat19 = "05 \& 14": col3 
	
	sum nsuicidespc if (treat1011>0) & year==2005   
    estadd loc thisstat20 = "`r(N)'": col3
	sum nsuicidespc if (any_treat==0)	& year==2005   
    estadd loc thisstat21 = "`r(N)'": col3
	
	estadd loc thisstat22 = "Y": col3
    estadd loc thisstat23 = "Y": col3
  		

********************************************************************************
*****************************Column 4*******************************************
********************************************************************************
	

	xtreg   nsuicidespc treat0708_2000 treat0708_2003 treat0708_2011 treat0708_2014 ///
    treat1011_2000 treat1011_2003 treat1011_2011 treat1011_2014  ///
    treat1213_2000 treat1213_2003 treat1213_2005  treat1213_2014  $year, fe cluster(kabuid)
	  		
	
	sigstar treat1213_2014, prec(3)
    estadd loc thisstat4 = "`r(bstar)'": col4
    estadd loc thisstat5 = "`r(sestar)'": col4

	estadd loc thisstat7 = "1-2": col4
	estadd loc thisstat8 = "11 \& 14": col4
	sum nsuicidespc if (treat2012>0 | treat2013>0) & year==2005    
    estadd loc thisstat9 = "`r(N)'": col4
	sum nsuicidespc if (any_treat==0)  & year==2005   
    estadd loc thisstat10 = "`r(N)'": col4	
	estadd loc thisstat11 = "Y": col4
	
	
						
 
loc rowlabels " "Dependent variable: Suicide rate" "\cline{1-1} {\bf Panel A: First  post treatment census wave}" " "  "Treatment" " " " "  "\midrule Years since launch of PKH" "Census waves" "Number of treated" "Number of counterfactuals" "Receiving Treatment" "\midrule" "{\bf Panel B: Second  post treatment census wave}" " " "Treatment" " " " " "\midrule Years since launch of PKH " "Census waves" "Number of treated" "Number of counterfactuals"  "Receiving treatment" " " " " "
loc rowstats ""

forval i = 1/22 {
    loc rowstats "`rowstats' thisstat`i'"
}





esttab * using "$tables/TableA17_dynamics_noweights.tex", replace cells(none) booktabs nonotes compress alignment(c) ///
 nogap noobs nobaselevels label stats(`rowstats', labels(`rowlabels')) ///
  mtitle("RCT" "Treat 07-08" "Treat 10-11" "Treat 12-13")

eststo clear
	
	
 
