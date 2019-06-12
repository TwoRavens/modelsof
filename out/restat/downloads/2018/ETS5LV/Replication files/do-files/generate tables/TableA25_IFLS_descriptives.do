
*******
use "$data/ifls_complete.dta", clear

*******************************************************************************************************************************




duplicates tag pidlink, gen(tag)
drop if tag==0

drop tag temp*

gen temp1=cct if year==2015
bys pidlink: egen cct_2015=max(temp1)

destring pidlink, replace


hdfe hhexp_* ln*  bottom_decile_all_exp ///
 z_depression depression_high z_rain rain_season cct_ ,absorb(i.year  i.pidlink ) gen(h_)  clustervars(kecid_)







loc experiments "1 2 3 "

	
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
*****************************Column 1: just exp expenditure *******************
********************************************************************************


	

	reg z_depression bottom_decile_all_exp if year==2008, cluster(kecid2000)
	estadd loc thisstat9 = `e(N)': col1
	sigstar bottom_decile_all_exp, prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat3 = "`r(bstar)'": col1
    estadd loc thisstat4 = "`r(sestar)'": col1
   

    
	*estadd loc thisstat9 = `e(mean)': col1
	
	estadd loc thisstat10 = "4": col1
	

  
  

********************************************************************************
*****************************Column 2: cct target      *************************
********************************************************************************


	
	reg z_depression cct_2015  if year==2008 , cluster(kecid2000)
	estadd loc thisstat9 = `e(N)': col2
	
	
	sigstar  cct_2015  , prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat6 = "`r(bstar)'": col2
    estadd loc thisstat7 = "`r(sestar)'": col2
   
	*estadd loc thisstat9 = `e(mean)': col2
	estadd loc thisstat10 = "4": col2


   
   
********************************************************************************
*****************************Column 3: both   		   *************************
********************************************************************************


	
	reg z_depression  bottom_decile_all_exp cct_2015 if year==2008 , cluster(kecid2000)
	estadd loc thisstat9 = `e(N)': col3
	
	
	sigstar bottom_decile_all_exp, prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat3 = "`r(bstar)'": col3
    estadd loc thisstat4 = "`r(sestar)'": col3

	
	sigstar cct_2015 , prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat6 = "`r(bstar)'": col3
    estadd loc thisstat7 = "`r(sestar)'": col3

	
	estadd loc thisstat10 = "4": col3
	


 
loc rowlabels " "Dependent variable: " "Baseline depression z-score" "\cline{1-1}" "Bottom decile " "of expenditure " " " "CCT recipient in 2014" " "  "\hline"  "N" "IFLS wave used" " 

forval i = 0/10{
    loc rowstats "`rowstats' thisstat`i'"
}





esttab col1 col2 col3  using "$tables/TableA25_IFLS_descriptives.tex", replace cells(none) ///
booktabs nonotes nomtitle compress alignment(c) nogap noobs nobaselevels label stats(`rowstats', labels(`rowlabels'))






















