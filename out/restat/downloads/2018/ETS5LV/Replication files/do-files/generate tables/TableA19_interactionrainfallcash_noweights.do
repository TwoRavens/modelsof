

use "$data/podes_pkhrollout.dta", clear


	
	global year year2000 year2003 year2005 year2011 year2014


gen post_rain=z_rain*post


loc experiments "1 2 3 4 5 6"

	
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

***Panel A

	
	preserve
	

		
	reg2hdfespatial nsuicidespc z_rain , lat(ycoord) lon(xcoord) timevar(year) panelvar(kecid) ///
    distcutoff(100) lagcutoff(16) display star
	
	sigstar z_rain, prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat3 = "`r(bstar)'": col1
    estadd loc thisstat4 = "`r(sestar)'": col1
   

	xtreg nsuicidespc z_rain  i.year , fe cluster(kabuid)
    estadd loc thisstat20 = `e(N)': col1
	
	
	sigstar z_rain, prec(3) sebrackets
	estadd loc thisstat5 = "`r(sestar)'": col1
	

 
	restore 
  
	estadd loc thisstat15 = "Y": col1
    estadd loc thisstat16 = "Y": col1
    estadd loc thisstat17 = "N": col1
    estadd loc thisstat18 = "N": col1
	estadd loc thisstat21 = "00-14": col1

  
  
  
********************************************************************************
*****************************Column 2: main interaction  ***********************
********************************************************************************

***Panel A

	
	preserve
	

		
	reg2hdfespatial nsuicidespc z_rain post post_rain, lat(ycoord) lon(xcoord) timevar(year) panelvar(kecid) ///
    distcutoff(100) lagcutoff(16) display star
	
	sigstar z_rain, prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat3 = "`r(bstar)'": col2
    estadd loc thisstat4 = "`r(sestar)'": col2
   

	sigstar   post , prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat7 = "`r(bstar)'": col2
    estadd loc thisstat8 = "`r(sestar)'": col2	
		
 
   	sigstar post_rain, prec(3) 
	di  "`r(sestar)'"
	    estadd loc thisstat11 = "`r(bstar)'": col2
    estadd loc thisstat12 = "`r(sestar)'": col2	 
  
	restore
  
  
		preserve 
	xtreg nsuicidespc z_rain post post_rain i.year , fe cluster(kabuid)
    estadd loc thisstat20 = `e(N)': col2
	
	
	sigstar z_rain, prec(3) sebrackets
	estadd loc thisstat5 = "`r(sestar)'": col2
	

	sigstar post, prec(3) sebrackets
	estadd loc thisstat9 = "`r(sestar)'": col2

	sigstar post_rain, prec(3) sebrackets
    estadd loc thisstat13 = "`r(sestar)'": col2

 
	restore 
  
	estadd loc thisstat15 = "Y": col2
    estadd loc thisstat16 = "Y": col2
    estadd loc thisstat17 = "N": col2
    estadd loc thisstat18 = "N": col2
	estadd loc thisstat21 = "00-14": col2

  
  

********************************************************************************
*****************************Column 3: subdistrict trends *************************
********************************************************************************


	preserve
	
	hdfe nsuicidespc z_rain post post_rain, absorb(i.kecid##c.year i.year) gen(h_)
	
	
	reg2hdfespatial h_nsuicidespc h_z_rain , lat(ycoord) lon(xcoord) timevar(year) panelvar(kecid) ///
    distcutoff(100) lagcutoff(16)  display star
		
	
	sigstar h_z_rain, prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat3 = "`r(bstar)'": col3
    estadd loc thisstat4 = "`r(sestar)'": col3
	

	
	

	xtreg h_nsuicidespc h_z_rain  i.year , fe cluster(kabuid)
    estadd loc thisstat20 = `e(N)': col3
	
	
	sigstar h_z_rain, prec(3) sebrackets
	estadd loc thisstat5 = "`r(sestar)'": col3
	

  
	
	estadd loc thisstat15 = "Y": col3
    estadd loc thisstat16 = "Y": col3
    estadd loc thisstat17 = "Y": col3
    estadd loc thisstat18 = "N": col3
	estadd loc thisstat21 = "00-14": col3

	
	
	
	
	
********************************************************************************
*****************************Column 4: district trends  interaction ************
********************************************************************************
	
	

	
	reg2hdfespatial h_nsuicidespc h_z_rain h_post h_post_rain, lat(ycoord) lon(xcoord) timevar(year) panelvar(kecid) ///
    distcutoff(100) lagcutoff(16)  display star
	
	sigstar h_z_rain, prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat3 = "`r(bstar)'": col4
    estadd loc thisstat4 = "`r(sestar)'": col4
	
	sigstar   h_post , prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat7 = "`r(bstar)'": col4
    estadd loc thisstat8 = "`r(sestar)'": col4
		
 
   	sigstar h_post_rain, prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat11 = "`r(bstar)'": col4
    estadd loc thisstat12 = "`r(sestar)'": col4
	
	

	xtreg h_nsuicidespc h_z_rain h_post h_post_rain i.year , fe cluster(kabuid)
    estadd loc thisstat20 = `e(N)': col4
	
	
	sigstar h_z_rain, prec(3) sebrackets
	estadd loc thisstat5 = "`r(sestar)'": col4
	

	sigstar h_post, prec(3) sebrackets
	estadd loc thisstat9 = "`r(sestar)'": col4

	sigstar h_post_rain, prec(3) sebrackets
    estadd loc thisstat13 = "`r(sestar)'": col4

  
	
	estadd loc thisstat15 = "Y": col4
    estadd loc thisstat16 = "Y": col4
    estadd loc thisstat17 = "Y": col4
    estadd loc thisstat18 = "N": col4
	estadd loc thisstat21 = "00-14": col4

	
	restore
  
********************************************************************************
*****************************Column 5*******************************************
********************************************************************************


	
	preserve
	

		
	reg2hdfespatial nsuicidespc z_rain lag1_z_rain lag2_z_rain lag3_z_rain, lat(ycoord) lon(xcoord) timevar(year) panelvar(kecid) ///
    distcutoff(100) lagcutoff(16) display star
	
	sigstar z_rain, prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat3 = "`r(bstar)'": col5
    estadd loc thisstat4 = "`r(sestar)'": col5
   

	xtreg nsuicidespc z_rain lag1_z_rain lag2_z_rain lag3_z_rain i.year , fe cluster(kabuid)
    estadd loc thisstat20 = `e(N)': col5
	
	
	sigstar z_rain, prec(3) sebrackets
	estadd loc thisstat5 = "`r(sestar)'": col5
	

 
	restore 
  
	estadd loc thisstat15 = "Y": col5
    estadd loc thisstat16 = "Y": col5
    estadd loc thisstat17 = "N": col5
    estadd loc thisstat18 = "Y": col5
	estadd loc thisstat21 = "00-14": col5

  
  
********************************************************************************
*****************************Column 6*******************************************
********************************************************************************

	
	preserve
	

		
	reg2hdfespatial nsuicidespc z_rain post post_rain lag1_z_rain lag2_z_rain lag3_z_rain, lat(ycoord) lon(xcoord) timevar(year) panelvar(kecid) ///
    distcutoff(100) lagcutoff(16) display star
	
	sigstar z_rain, prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat3 = "`r(bstar)'": col6
    estadd loc thisstat4 = "`r(sestar)'": col6
   

	sigstar   post , prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat7 = "`r(bstar)'": col6
    estadd loc thisstat8 = "`r(sestar)'": col6	
		
 
   	sigstar post_rain, prec(3) 
	di  "`r(sestar)'"
	    estadd loc thisstat11 = "`r(bstar)'": col6
    estadd loc thisstat12 = "`r(sestar)'": col6	 
  
	restore
  
  
		preserve 
	xtreg nsuicidespc z_rain post post_rain i.year lag1_z_rain lag2_z_rain lag3_z_rain , fe cluster(kabuid)
    estadd loc thisstat20 = `e(N)': col6
	
	
	sigstar z_rain, prec(3) sebrackets
	estadd loc thisstat5 = "`r(sestar)'": col6
	

	sigstar post, prec(3) sebrackets
	estadd loc thisstat9 = "`r(sestar)'": col6

	sigstar post_rain, prec(3) sebrackets
    estadd loc thisstat13 = "`r(sestar)'": col6

 
	restore 
  
	estadd loc thisstat15 = "Y": col6
    estadd loc thisstat16 = "Y": col6
    estadd loc thisstat17 = "N": col6
    estadd loc thisstat18 = "Y": col6
	estadd loc thisstat21 = "00-14": col6

  
 
loc rowlabels " "Dependent variable: Suicide rate" "\cline{1-1} " " "  "Rain (z-scored)" " " " " " " "Treat "  " "  " " " " "Rain (z-scored)$\times$ Treat" " " " " " " "\hline Subdistrict FE" "Time FE" "Subdistrict trends" "Include lagged rainfall" " " "\hline N" "Census waves"  "
loc rowstats ""

forval i = 0/21{
    loc rowstats "`rowstats' thisstat`i'"
}





esttab col1 col2 col3 col4 col5 col6 using "$tables/TableA19_interactionrainfallcash_noweights.tex", replace cells(none) ///
booktabs nonotes nomtitle compress alignment(c) nogap noobs nobaselevels label stats(`rowstats', labels(`rowlabels'))



eststo clear
	
	
 
