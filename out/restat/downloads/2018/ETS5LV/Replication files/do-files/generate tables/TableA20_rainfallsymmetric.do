

use "$data/podes_pkhrollout.dta", clear

	
	global year year2000 year2003 year2005 year2011 year2014

	
	
** Generate interactions **
	
sum z_rain,d	

egen temp=xtile(z_rain), n(3)

gen shock_pos =temp==3 if z_rain!=.
gen shock_neg =temp==1 if z_rain!=.	
drop temp	
	

	
	
	** Generate weights
		
	gen weight=sqrt(pop_sizebaseline)
	
	** Generate weighted variables
	
	foreach var in nsuicidespc z_rain post  shock_pos shock_neg lag1_z_rain lag2_z_rain lag3_z_rain {
	gen w`var'=`var'*weight
	}
	

	** Partial out weighted fixed effects
	hdfe  wnsuicidespc wz_rain wpost  wlag1_z_rain wlag2_z_rain wlag3_z_rain wshock_pos wshock_neg  , absorb( i.year#c.weight i.kecid2000#c.weight ) gen(h_)

	** Partial out weighted fixed effects and district trends
	hdfe wnsuicidespc wz_rain wpost  wlag1_z_rain wlag2_z_rain wlag3_z_rain wshock_pos wshock_neg, absorb(c.weight#i.year i.year#c.weight c.year#i.kabuid#c.weight ) gen(hs_)
	


loc experiments "nsuicidespc nsuicidespc nsuicidespc"




	
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

 
	ols_spatial_HAC h_wnsuicidespc h_wz_rain h_wshock_pos h_wshock_neg, lat(ycoord) lon(xcoord) timevar(year) panelvar(kecid) ///
    distcutoff(100) lagcutoff(16) display star
	
	sigstar  h_wz_rain, prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat9 = "`r(bstar)'": col1
    estadd loc thisstat10 = "`r(sestar)'": col1	
		
 
  
   	sigstar h_wshock_pos, prec(3) 
	di  "`r(sestar)'"
	    estadd loc thisstat13 = "`r(bstar)'": col1
    estadd loc thisstat14 = "`r(sestar)'": col1	 
  
   	sigstar h_wshock_neg, prec(3) 
	di  "`r(sestar)'"
	    estadd loc thisstat17 = "`r(bstar)'": col1
    estadd loc thisstat18 = "`r(sestar)'": col1	 

	
	test  h_wshock_pos=-h_wshock_neg
	
	 estadd scalar thisstat21 = r(p): col1	 
	
	
	
	xtreg h_wnsuicidespc h_wz_rain   , cluster(kabuid)

	
	
	xtreg h_wnsuicidespc h_wz_rain h_wshock_pos h_wshock_neg , cluster(kabuid)
	
	sigstar h_wz_rain, prec(3) sebrackets
	estadd loc thisstat11 = "`r(sestar)'": col1

	sigstar h_wshock_pos, prec(3) sebrackets
    estadd loc thisstat15 = "`r(sestar)'": col1

 
	sigstar h_wshock_neg, prec(3) sebrackets
	estadd loc thisstat19 = "`r(sestar)'": col1

	

  
	estadd loc thisstat22 = "Y": col1
    estadd loc thisstat23 = "Y": col1
    estadd loc thisstat24 = "N": col1
    estadd loc thisstat25 = "N": col1
	
	estadd loc thisstat27 = `e(N)': col1
    estadd loc thisstat28 = "00-14": col1
  
  

********************************************************************************
*****************************Column 2*******************************************
********************************************************************************
  

	ols_spatial_HAC hs_wnsuicidespc hs_wz_rain hs_wshock_pos hs_wshock_neg, lat(ycoord) lon(xcoord) timevar(year) panelvar(kecid) ///
    distcutoff(100) lagcutoff(16)  display star
	
	sigstar  hs_wz_rain, prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat9 = "`r(bstar)'": col2
    estadd loc thisstat10 = "`r(sestar)'": col2
		
 
  
   	sigstar hs_wshock_pos, prec(3) 
	di  "`r(sestar)'"
	    estadd loc thisstat13 = "`r(bstar)'": col2
    estadd loc thisstat14 = "`r(sestar)'": col2	 
  
   	sigstar hs_wshock_neg, prec(3)
	di  "`r(sestar)'"
	    estadd loc thisstat17 = "`r(bstar)'": col2
    estadd loc thisstat18 = "`r(sestar)'": col2	 
	
	
		test  hs_wshock_pos=-hs_wshock_neg
	
	 estadd scalar thisstat21 = r(p): col2
	


	reg hs_wnsuicidespc hs_wz_rain hs_wshock_pos hs_wshock_neg, cl(kabuid)
 
	
	sigstar hs_wz_rain, prec(3) sebrackets
	di  "`r(sestar)'"
    estadd loc thisstat11 = "`r(sestar)'": col2
  
   	sigstar hs_wshock_pos, prec(3) sebrackets
	di  "`r(sestar)'"
    estadd loc thisstat15 = "`r(sestar)'": col2
  
   	sigstar hs_wshock_neg, prec(3) sebrackets
	di  "`r(sestar)'"
    estadd loc thisstat19 = "`r(sestar)'": col2
  

	estadd loc thisstat22 = "Y": col2
    estadd loc thisstat23 = "Y": col2
    estadd loc thisstat24 = "Y": col2
    estadd loc thisstat25 = "N": col2
	estadd loc thisstat27 = `e(N)': col2
    estadd loc thisstat28 = "00-14": col2
			

	
	
********************************************************************************
*****************************Column 3*******************************************
********************************************************************************



	
	ols_spatial_HAC h_wnsuicidespc h_wz_rain h_wshock_pos h_wshock_neg h_wlag1_z_rain h_wlag2_z_rain h_wlag3_z_rain, lat(ycoord) lon(xcoord) timevar(year) panelvar(kecid) ///
    distcutoff(100) lagcutoff(16)  display star
	
	sigstar h_wz_rain, prec(3)
    estadd loc thisstat9 = "`r(bstar)'": col3
    estadd loc thisstat10 = "`r(sestar)'": col3
		
	sigstar h_wshock_pos, prec(3)
    estadd loc thisstat13 = "`r(bstar)'": col3
    estadd loc thisstat14 = "`r(sestar)'": col3	 
 
	sigstar h_wshock_neg, prec(3)
    estadd loc thisstat17 = "`r(bstar)'": col3
    estadd loc thisstat18 = "`r(sestar)'": col3	 
	
		test  h_wshock_pos=-h_wshock_neg
	
	 estadd scalar thisstat21 = r(p): col3
	

	xtreg h_wnsuicidespc h_wz_rain h_wshock_pos h_wshock_neg  h_wlag1_z_rain h_wlag2_z_rain h_wlag3_z_rain, cluster(kabuid)
		
	sigstar h_wz_rain, prec(3) sebrackets
	di  "`r(sestar)'"
    estadd loc thisstat11 = "`r(sestar)'": col3
  
   	sigstar h_wshock_pos, prec(3) sebrackets
	di  "`r(sestar)'"
    estadd loc thisstat15 = "`r(sestar)'": col3
	
   	sigstar h_wshock_neg, prec(3) sebrackets
	di  "`r(sestar)'"
    estadd loc thisstat19 = "`r(sestar)'": col3
  
  
  
  
	estadd loc thisstat22 = "Y": col3
    estadd loc thisstat23 = "Y": col3
    estadd loc thisstat24 = "N": col3
    estadd loc thisstat25 = "Y": col3	
	estadd loc thisstat27 = `e(N)': col3
    estadd loc thisstat28 = "00-14": col3

	
 
loc rowlabels " "Dependent variable: Suicide rate" "\cline{1-1} " "Rain (z-scored)" " " " "  " " "Positive Shock " " " " " " " "Negative Shock " " " " " " " "\midrule p($\left | \textnormal{Positive Shock} \right |=\left | \textnormal{Negative Shock} \right |$ ) ""\hline Subdistrict FE" "Time FE" "Subdistrict trends" "Include lagged rainfall" " " "\hline N" "Census waves" "
loc rowstats ""

forval i = 7/28{
    loc rowstats "`rowstats' thisstat`i'"
}





esttab col1 col2 col3 using "$tables/TableA20_rainfallasymmetric.tex", replace cells(none) ///
booktabs nonotes nomtitle compress alignment(c) nogap noobs nobaselevels label stats(`rowstats', labels(`rowlabels') fmt(3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3  3 3  3 3 ) )

eststo clear
	
	
 
