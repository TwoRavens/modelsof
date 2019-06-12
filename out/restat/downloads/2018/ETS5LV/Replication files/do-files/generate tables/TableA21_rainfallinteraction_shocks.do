

use "$data/podes_pkhrollout.dta", clear


	
	global year year2000 year2003 year2005 year2011 year2014
	
** Generate interactions
	
sum z_rain,d	

egen temp=xtile(z_rain), n(3)

gen shock_pos =temp==3 if z_rain!=.
gen shock_neg =temp==1 if z_rain!=.	

gen post_rain=z_rain*post
gen post_shock_pos=shock_pos*post
gen post_shock_neg=shock_neg*post
	
	** Generate weights
		
	gen weight=sqrt(pop_sizebaseline)
	
	** Generate weighted variables
	
	foreach var in nsuicidespc z_rain post shock_pos shock_neg post_shock_pos post_shock_neg  lag1_z_rain lag2_z_rain lag3_z_rain {
	gen w`var'=`var'*weight
	}
	

	** Partial out weighted fixed effects
	hdfe  wnsuicidespc wz_rain wpost wpost_shock_pos wpost_shock_neg wshock_pos wshock_neg  wlag1_z_rain wlag2_z_rain wlag3_z_rain  , absorb( i.year#c.weight i.kecid2000#c.weight ) gen(h_)


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

	

	ols_spatial_HAC h_wnsuicidespc h_wshock_pos h_wshock_neg , lat(ycoord) lon(xcoord) timevar(year) panelvar(kecid) ///
    distcutoff(100) lagcutoff(16) display star 
	
	sigstar h_wshock_pos, prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat3 = "`r(bstar)'": col1
    estadd loc thisstat4 = "`r(sestar)'": col1
   
   sigstar h_wshock_neg, prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat11 = "`r(bstar)'": col1
    estadd loc thisstat12 = "`r(sestar)'": col1
   
   
   

	reg h_wnsuicidespc h_wshock_pos h_wshock_neg   , cluster(kabuid) 
		
    estadd loc thisstat28 = `e(N)': col1
	sigstar h_wshock_pos, prec(3) sebrackets
	estadd loc thisstat5 = "`r(sestar)'": col1
	
	sigstar h_wshock_neg, prec(3) sebrackets
	estadd loc thisstat13 = "`r(sestar)'": col1
	

	


  
	estadd loc thisstat23 = "Y": col1
    estadd loc thisstat24 = "Y": col1
    estadd loc thisstat25 = "N": col1
    estadd loc thisstat26 = "N": col1
	estadd loc thisstat29 = "00-14": col1

  
  
********************************************************************************
*****************************Column 2: main interaction  ***********************
********************************************************************************

***Panel A


		
	ols_spatial_HAC h_wnsuicidespc h_wshock_pos h_wpost_shock_pos h_wshock_neg h_wpost_shock_neg h_wpost, lat(ycoord) lon(xcoord) timevar(year) panelvar(kecid) ///
    distcutoff(100) lagcutoff(16) display star
	
	sigstar h_wshock_pos, prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat3 = "`r(bstar)'": col2
    estadd loc thisstat4 = "`r(sestar)'": col2
   

	sigstar     h_wpost_shock_pos , prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat7 = "`r(bstar)'": col2
    estadd loc thisstat8 = "`r(sestar)'": col2	
		
 
   	sigstar h_wshock_neg, prec(3) 
	di  "`r(sestar)'"
	    estadd loc thisstat11 = "`r(bstar)'": col2
    estadd loc thisstat12 = "`r(sestar)'": col2	 
	
	
	sigstar    h_wpost_shock_neg , prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat15 = "`r(bstar)'": col2
    estadd loc thisstat16 = "`r(sestar)'": col2	
		
 
   	sigstar h_wpost, prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat19 = "`r(bstar)'": col2
    estadd loc thisstat20 = "`r(sestar)'": col2	 


	
	
	reg h_wnsuicidespc  h_wshock_pos h_wpost_shock_pos h_wshock_neg h_wpost_shock_neg h_wpost ,  cluster(kabuid)
    estadd loc thisstat28 = `e(N)', replace: col2
		
	sigstar h_wshock_pos, prec(3) sebrackets
	estadd loc thisstat5 = "`r(sestar)'", replace: col2
	

	sigstar h_wpost_shock_pos, prec(3) sebrackets
	estadd loc thisstat9 = "`r(sestar)'", replace: col2

	sigstar  h_wshock_neg, prec(3) sebrackets
	estadd loc thisstat13 = "`r(sestar)'", replace: col2

	sigstar  h_wshock_neg, prec(3) sebrackets
    estadd loc thisstat17 = "`r(sestar)'", replace: col2
	
	sigstar h_wpost, prec(3) sebrackets
    estadd loc thisstat21 = "`r(sestar)'", replace: col2
	
	

 
  
	estadd loc thisstat23 = "Y": col2
    estadd loc thisstat24 = "Y": col2
    estadd loc thisstat25 = "N": col2
    estadd loc thisstat26 = "N": col2
	estadd loc thisstat29 = "00-14": col2

  
  

********************************************************************************
*****************************Column 3: shocks *************************
********************************************************************************



	
	hdfe wnsuicidespc wz_rain wpost wpost_shock_pos wpost_shock_neg wshock_pos wshock_neg wlag1_z_rain wlag2_z_rain wlag3_z_rain , absorb(c.weight#i.year i.year#c.weight c.year#i.kabuid#c.weight ) gen(ht_)
	
	
	ols_spatial_HAC ht_wnsuicidespc ht_wshock_pos  ht_wshock_neg ht_wpost , lat(ycoord) lon(xcoord) timevar(year) panelvar(kecid) ///
    distcutoff(100) lagcutoff(16)  display star
		
	sigstar ht_wshock_pos, prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat3 = "`r(bstar)'": col3
    estadd loc thisstat4 = "`r(sestar)'": col3
   
   sigstar ht_wshock_neg, prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat11 = "`r(bstar)'": col3
    estadd loc thisstat12 = "`r(sestar)'": col3
   
	
	

	reg ht_wnsuicidespc ht_wshock_pos  ht_wshock_neg ht_wpost  , cluster(kabuid)

	
    estadd loc thisstat28 = `e(N)': col3
	sigstar ht_wshock_pos, prec(3) sebrackets
	estadd loc thisstat5 = "`r(sestar)'": col3
	
	sigstar ht_wshock_neg, prec(3) sebrackets
	estadd loc thisstat13 = "`r(sestar)'": col3
	

	


  
	estadd loc thisstat23 = "Y": col3
    estadd loc thisstat24 = "Y": col3
    estadd loc thisstat25 = "Y": col3
    estadd loc thisstat26 = "N": col3
	estadd loc thisstat29 = "00-14": col3

  

	
	
	
	
	
********************************************************************************
*****************************Column 4: district trends  interaction ************
********************************************************************************
	
	

	
	ols_spatial_HAC ht_wnsuicidespc ht_wshock_pos ht_wpost_shock_pos ht_wshock_neg ht_wpost_shock_neg ht_wpost , lat(ycoord) lon(xcoord) timevar(year) panelvar(kecid) ///
    distcutoff(100) lagcutoff(16)  display star
	
	sigstar ht_wshock_pos, prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat3 = "`r(bstar)'": col4
    estadd loc thisstat4 = "`r(sestar)'": col4
   

	sigstar     ht_wpost_shock_pos , prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat7 = "`r(bstar)'": col4
    estadd loc thisstat8 = "`r(sestar)'": col4	
		
 
   	sigstar ht_wshock_neg, prec(3) 
	di  "`r(sestar)'"
	    estadd loc thisstat11 = "`r(bstar)'": col4
    estadd loc thisstat12 = "`r(sestar)'": col4	 
	
	
	sigstar    ht_wpost_shock_neg , prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat15 = "`r(bstar)'": col4
    estadd loc thisstat16 = "`r(sestar)'": col4	
		
 
   	sigstar ht_wpost, prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat19 = "`r(bstar)'": col4
    estadd loc thisstat20 = "`r(sestar)'": col4	 

	

	reg ht_wnsuicidespc ht_wshock_pos ht_wpost_shock_pos ht_wshock_neg   ht_wpost_shock_neg  ht_wpost ,  cluster(kabuid)
	
    estadd loc thisstat28 = `e(N)', replace: col4
		
	sigstar ht_wshock_pos, prec(3) sebrackets
	estadd loc thisstat5 = "`r(sestar)'", replace: col4
	

	sigstar ht_wpost_shock_pos, prec(3) sebrackets
	estadd loc thisstat9 = "`r(sestar)'", replace: col4

	sigstar  ht_wshock_neg, prec(3) sebrackets
	estadd loc thisstat13 = "`r(sestar)'", replace: col4

	sigstar  ht_wshock_neg, prec(3) sebrackets
    estadd loc thisstat17 = "`r(sestar)'", replace: col4
	
	sigstar ht_wpost, prec(3) sebrackets
    estadd loc thisstat21 = "`r(sestar)'", replace: col4
	
	

 
  
	estadd loc thisstat23 = "Y": col4
    estadd loc thisstat24 = "Y": col4
    estadd loc thisstat25 = "Y": col4
    estadd loc thisstat26 = "N": col4
	estadd loc thisstat29 = "00-14": col4

  
  

	
	
  
********************************************************************************
*****************************Column 5: lags  shocks ****************************
********************************************************************************

		
	ols_spatial_HAC h_wnsuicidespc h_wshock_pos  h_wshock_neg h_wpost h_wlag1_z_rain h_wlag2_z_rain h_wlag3_z_rain, lat(ycoord) lon(xcoord) timevar(year) panelvar(kecid) ///
    distcutoff(100) lagcutoff(16) display star
	   

	sigstar h_wshock_pos, prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat3 = "`r(bstar)'": col5
    estadd loc thisstat4 = "`r(sestar)'": col5
   
   sigstar h_wshock_neg, prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat11 = "`r(bstar)'": col5
    estadd loc thisstat12 = "`r(sestar)'": col5
   
	
	
	reg h_wnsuicidespc h_wshock_pos  h_wshock_neg h_wpost h_wlag1_z_rain h_wlag2_z_rain h_wlag3_z_rain  , cluster(kabuid)


	
    estadd loc thisstat28 = `e(N)': col5
	sigstar h_wshock_pos, prec(3) sebrackets
	estadd loc thisstat5 = "`r(sestar)'": col5
	
	sigstar h_wshock_neg, prec(3) sebrackets
	estadd loc thisstat13 = "`r(sestar)'": col5
	

	


  
	estadd loc thisstat23 = "Y": col5
    estadd loc thisstat24 = "Y": col5
    estadd loc thisstat25 = "N": col5
    estadd loc thisstat26 = "Y": col5
	estadd loc thisstat29 = "00-14": col5

  
********************************************************************************
*****************************Column 6 lags interaction *************************
********************************************************************************


		
	ols_spatial_HAC h_wnsuicidespc h_wshock_pos h_wpost_shock_pos h_wshock_neg   h_wpost_shock_neg  h_wpost   h_wlag1_z_rain h_wlag2_z_rain h_wlag3_z_rain, lat(ycoord) lon(xcoord) timevar(year) panelvar(kecid) ///
    distcutoff(100) lagcutoff(16) display star
	
	sigstar h_wshock_pos, prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat3 = "`r(bstar)'": col6
    estadd loc thisstat4 = "`r(sestar)'": col6
   

	sigstar     h_wpost_shock_pos , prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat7 = "`r(bstar)'": col6
    estadd loc thisstat8 = "`r(sestar)'": col6	
		
 
   	sigstar h_wshock_neg, prec(3) 
	di  "`r(sestar)'"
	    estadd loc thisstat11 = "`r(bstar)'": col6
    estadd loc thisstat12 = "`r(sestar)'": col6	 
	
	
	sigstar    h_wpost_shock_neg , prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat15 = "`r(bstar)'": col6
    estadd loc thisstat16 = "`r(sestar)'": col6	
		
 
   	sigstar h_wpost, prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat19 = "`r(bstar)'": col6
    estadd loc thisstat20 = "`r(sestar)'": col6	 

	

	reg h_wnsuicidespc h_wshock_pos h_wpost_shock_pos h_wshock_neg   h_wpost_shock_neg  h_wpost h_wlag1_z_rain h_wlag2_z_rain h_wlag3_z_rain ,  cluster(kabuid)

	
    estadd loc thisstat28 = `e(N)', replace: col6
		
	sigstar h_wshock_pos, prec(3) sebrackets
	estadd loc thisstat5 = "`r(sestar)'", replace: col6
	

	sigstar h_wpost_shock_pos, prec(3) sebrackets
	estadd loc thisstat9 = "`r(sestar)'", replace: col6

	sigstar  h_wshock_neg, prec(3) sebrackets
	estadd loc thisstat13 = "`r(sestar)'", replace: col6

	sigstar  h_wshock_neg, prec(3) sebrackets
    estadd loc thisstat17 = "`r(sestar)'", replace: col6
	
	sigstar h_wpost, prec(3) sebrackets
    estadd loc thisstat21 = "`r(sestar)'", replace: col6
	
	
	

 
  
	estadd loc thisstat23 = "Y": col6
    estadd loc thisstat24 = "Y": col6
    estadd loc thisstat25 = "N": col6
    estadd loc thisstat26 = "Y": col6
	estadd loc thisstat29 = "00-14": col6

  
 
loc rowlabels " "Dependent variable: Suicide rate" "\cline{1-1} " " "  "Positive shock" " " " " " " "Positive shock $\times$ Treat"  " "  " " " " "Negative shock" " " " " " " "Negative shock $\times$ Treat" " " " " " " "Treat" " " " " " "  "\hline Subdistrict FE" "Time FE" "Subdistrict trends" "Include lagged rainfall" " " "\hline N" "Census waves"  "
loc rowstats ""

forval i = 0/29{
    loc rowstats "`rowstats' thisstat`i'"
}


 


esttab col1 col2 col3 col4 col5 col6 using "$tables/TableA21_rainfallinteraction_shocks.tex", replace cells(none) ///
booktabs nonotes nomtitle compress alignment(c) nogap noobs nobaselevels label stats(`rowstats', labels(`rowlabels'))


eststo clear
	
	
 
