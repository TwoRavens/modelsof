

use "$data/podes_pkhrollout.dta", clear


	
	global year year2000 year2003 year2005 year2011 year2014
	
	
	** use different rain measure
drop z_rain
ren  z_rain_kt z_rain
	

gen post_rain=z_rain*post
	
	** Generate weights
		
	gen weight=sqrt(pop_sizebaseline)
	
	** Generate weighted variables
	
	foreach var in nsuicidespc z_rain post post_rain lag1_z_rain lag2_z_rain lag3_z_rain {
	gen w`var'=`var'
	}
	

	** Partial out weighted fixed effects
	hdfe  wnsuicidespc wz_rain wpost wpost_rain wlag1_z_rain wlag2_z_rain wlag3_z_rain  , absorb( i.year i.kecid2000 ) gen(h_)

	
	




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

	

	ols_spatial_HAC h_wnsuicidespc h_wz_rain , lat(ycoord) lon(xcoord) timevar(year) panelvar(kecid) ///
    distcutoff(100) lagcutoff(16) display star
	
	sigstar h_wz_rain, prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat3 = "`r(bstar)'": col1
    estadd loc thisstat4 = "`r(sestar)'": col1
   
	xtreg nsuicidespc z_rain  i.year  , fe cluster(kabuid)
	reg h_wnsuicidespc h_wz_rain   , cluster(kabuid)
    estadd loc thisstat20 = `e(N)': col1
	
	
	sigstar h_wz_rain, prec(3) sebrackets
	estadd loc thisstat5 = "`r(sestar)'": col1
	


  
	estadd loc thisstat15 = "Y": col1
    estadd loc thisstat16 = "Y": col1
    estadd loc thisstat17 = "N": col1
    estadd loc thisstat18 = "N": col1
	estadd loc thisstat21 = "00-14": col1

  
  
  
********************************************************************************
*****************************Column 2: main interaction  ***********************
********************************************************************************

***Panel A


		
	ols_spatial_HAC h_wnsuicidespc h_wz_rain h_wpost h_wpost_rain , lat(ycoord) lon(xcoord) timevar(year) panelvar(kecid) ///
    distcutoff(100) lagcutoff(16) display star
	
	sigstar h_wz_rain, prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat3 = "`r(bstar)'": col2
    estadd loc thisstat4 = "`r(sestar)'": col2
   

	sigstar   h_wpost , prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat7 = "`r(bstar)'": col2
    estadd loc thisstat8 = "`r(sestar)'": col2	
		
 
   	sigstar h_wpost_rain, prec(3) 
	di  "`r(sestar)'"
	    estadd loc thisstat11 = "`r(bstar)'": col2
    estadd loc thisstat12 = "`r(sestar)'": col2	 

	
	
	reg h_wnsuicidespc h_wz_rain h_wpost h_wpost_rain  ,  cluster(kabuid)
    estadd loc thisstat20 = `e(N)', replace: col2
	
	
	sigstar h_wz_rain, prec(3) sebrackets
	estadd loc thisstat5 = "`r(sestar)'", replace: col2
	

	sigstar h_wpost, prec(3) sebrackets
	estadd loc thisstat9 = "`r(sestar)'", replace: col2

	sigstar h_wpost_rain, prec(3) sebrackets
    estadd loc thisstat13 = "`r(sestar)'", replace: col2

 
  
	estadd loc thisstat15 = "Y": col2
    estadd loc thisstat16 = "Y": col2
    estadd loc thisstat17 = "N": col2
    estadd loc thisstat18 = "N": col2
	estadd loc thisstat21 = "00-14": col2

  
  

********************************************************************************
*****************************Column 3: subdistrict trends *************************
********************************************************************************



	
	hdfe wnsuicidespc wz_rain wpost wpost_rain, absorb(i.year c.year#i.kabuid ) gen(ht_)
	
	
	ols_spatial_HAC ht_wnsuicidespc ht_wz_rain , lat(ycoord) lon(xcoord) timevar(year) panelvar(kecid) ///
    distcutoff(100) lagcutoff(16)  display star
		
	
	sigstar ht_wz_rain, prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat3 = "`r(bstar)'": col3
    estadd loc thisstat4 = "`r(sestar)'": col3
	

	
	

	reg ht_wnsuicidespc ht_wz_rain  , cluster(kabuid)
    estadd loc thisstat20 = `e(N)': col3
	
	
	sigstar ht_wz_rain, prec(3) sebrackets
	estadd loc thisstat5 = "`r(sestar)'": col3
	

  
	
	estadd loc thisstat15 = "Y": col3
    estadd loc thisstat16 = "Y": col3
    estadd loc thisstat17 = "Y": col3
    estadd loc thisstat18 = "N": col3
	estadd loc thisstat21 = "00-14": col3

	
	
	
	
	
********************************************************************************
*****************************Column 4: district trends  interaction ************
********************************************************************************
	
	

	
	ols_spatial_HAC ht_wnsuicidespc ht_wz_rain ht_wpost ht_wpost_rain, lat(ycoord) lon(xcoord) timevar(year) panelvar(kecid) ///
    distcutoff(100) lagcutoff(16)  display star
	
	sigstar ht_wz_rain, prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat3 = "`r(bstar)'": col4
    estadd loc thisstat4 = "`r(sestar)'": col4
	
	sigstar   ht_wpost , prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat7 = "`r(bstar)'": col4
    estadd loc thisstat8 = "`r(sestar)'": col4
		
 
   	sigstar ht_wpost_rain, prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat11 = "`r(bstar)'": col4
    estadd loc thisstat12 = "`r(sestar)'": col4
	
	

	reg ht_wnsuicidespc ht_wz_rain ht_wpost ht_wpost_rain  ,  cluster(kabuid)
    estadd loc thisstat20 = `e(N)': col4
	
	
	sigstar ht_wz_rain, prec(3) sebrackets
	estadd loc thisstat5 = "`r(sestar)'": col4
	

	sigstar ht_wpost, prec(3) sebrackets
	estadd loc thisstat9 = "`r(sestar)'": col4

	sigstar ht_wpost_rain, prec(3) sebrackets
    estadd loc thisstat13 = "`r(sestar)'": col4

  
	
	estadd loc thisstat15 = "Y": col4
    estadd loc thisstat16 = "Y": col4
    estadd loc thisstat17 = "Y": col4
    estadd loc thisstat18 = "N": col4
	estadd loc thisstat21 = "00-14": col4

	
	
  
********************************************************************************
*****************************Column 5*******************************************
********************************************************************************

		
	ols_spatial_HAC h_wnsuicidespc h_wz_rain h_wlag1_z_rain h_wlag2_z_rain h_wlag3_z_rain, lat(ycoord) lon(xcoord) timevar(year) panelvar(kecid) ///
    distcutoff(100) lagcutoff(16) display star
	
	sigstar h_wz_rain, prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat3 = "`r(bstar)'": col5
    estadd loc thisstat4 = "`r(sestar)'": col5
   

	reg h_wnsuicidespc h_wz_rain h_wlag1_z_rain h_wlag2_z_rain h_wlag3_z_rain  , cluster(kabuid)
    estadd loc thisstat20 = `e(N)': col5
	
	
	sigstar h_wz_rain, prec(3) sebrackets
	estadd loc thisstat5 = "`r(sestar)'": col5
	


  
	estadd loc thisstat15 = "Y": col5
    estadd loc thisstat16 = "Y": col5
    estadd loc thisstat17 = "N": col5
    estadd loc thisstat18 = "Y": col5
	estadd loc thisstat21 = "00-14": col5

  
  
********************************************************************************
*****************************Column 6*******************************************
********************************************************************************


		
	ols_spatial_HAC h_wnsuicidespc h_wz_rain h_wpost h_wpost_rain h_wlag1_z_rain h_wlag2_z_rain h_wlag3_z_rain, lat(ycoord) lon(xcoord) timevar(year) panelvar(kecid) ///
    distcutoff(100) lagcutoff(16) display star
	
	sigstar h_wz_rain, prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat3 = "`r(bstar)'": col6
    estadd loc thisstat4 = "`r(sestar)'": col6
   

	sigstar   h_wpost , prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat7 = "`r(bstar)'": col6
    estadd loc thisstat8 = "`r(sestar)'": col6	
		
 
   	sigstar h_wpost_rain, prec(3) 
	di  "`r(sestar)'"
	    estadd loc thisstat11 = "`r(bstar)'": col6
    estadd loc thisstat12 = "`r(sestar)'": col6	 
  
	
	reg h_wnsuicidespc h_wz_rain h_wpost h_wpost_rain h_wlag1_z_rain h_wlag2_z_rain h_wlag3_z_rain , cluster(kabuid)
    estadd loc thisstat20 = `e(N)': col6
	
	
	sigstar h_wz_rain, prec(3) sebrackets
	estadd loc thisstat5 = "`r(sestar)'": col6
	

	sigstar h_wpost, prec(3) sebrackets
	estadd loc thisstat9 = "`r(sestar)'": col6

	sigstar h_wpost_rain, prec(3) sebrackets
    estadd loc thisstat13 = "`r(sestar)'": col6


	
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





esttab col1 col2 col3 col4 col5 col6 using "$tables/TableA23_rain_detrend_noweights.tex", replace cells(none) ///
booktabs nonotes nomtitle compress alignment(c) nogap noobs nobaselevels label stats(`rowstats', labels(`rowlabels'))



*eststo clear
	
	
 
