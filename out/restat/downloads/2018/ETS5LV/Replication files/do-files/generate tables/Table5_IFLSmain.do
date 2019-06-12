
use "$data/ifls_complete.dta", clear

*******************************************************************************************************************************


duplicates tag pidlink, gen(panel_var)


keep if panel_var==4 // Keep balanced panel
	
	
	
/* Initialize empty table */


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
************Column 1: food expenditure  -- agriculture sample*******************
********************************************************************************


	
	

	reg2hdfespatial hhexp_ z_rain if working_agr_hh_any==1, lat(ycoord) lon(xcoord) timevar(year) panelvar(id) ///
    distcutoff(100) lagcutoff(30) display star
	
	estadd loc thisstat10 = `e(N)': col1
	
	sigstar z_rain, prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat3 = "`r(bstar)'": col1
    estadd loc thisstat4 = "`r(sestar)'": col1
   
	
	
	xtreg hhexp_ z_rain i.year if working_agr_hh_any==1, fe cluster(kabid) nonest
	
	sigstar z_rain, prec(3) sebrackets
    estadd loc thisstat5= "`r(sestar)'": col1
	
	
    estadd loc thisstat7 = "Y": col1
	estadd loc thisstat8= "Y": col1
	*estadd loc thisstat9= "N": col1

	
		estadd loc thisstat11 = "1-5": col1

		


********************************************************************************
**************Column 2: Total expenditure-- agriculture sample*******************
********************************************************************************


	
	

	reg2hdfespatial lnhhexp z_rain if working_agr_hh_any==1, lat(ycoord) lon(xcoord) timevar(year) panelvar(id) ///
    distcutoff(100) lagcutoff(30) display star
	
	estadd loc thisstat10 = `e(N)': col2
	
	sigstar z_rain, prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat3 = "`r(bstar)'": col2
    estadd loc thisstat4 = "`r(sestar)'": col2
   
	
	
	xtreg lnhhexp z_rain i.year if working_agr_hh_any==1, fe cluster(kabid) nonest
	
	global percent_impact=_b[z_rain] // Used below for effect size calculations.
	
	sigstar z_rain, prec(3) sebrackets
    estadd loc thisstat5= "`r(sestar)'": col2
	
	
    estadd loc thisstat7 = "Y": col2
	estadd loc thisstat8= "Y": col2
	*estadd loc thisstat9= "N": col2
	
	estadd loc thisstat11 = "1-5": col2


********************************************************************************
********************Column 3: Depression-- agriculture sample*******************
********************************************************************************


	
	

	reg2hdfespatial z_depression z_rain if working_agr_hh_any==1, lat(ycoord) lon(xcoord) timevar(year) panelvar(id) ///
    distcutoff(100) lagcutoff(30) display star
	
	estadd loc thisstat10 = `e(N)': col3
	
	sigstar z_rain, prec(3) 
	estadd loc thisstat3 = "`r(bstar)'": col3
    estadd loc thisstat4 = "`r(sestar)'": col3
   
	
	xtreg z_depression z_rain i.year if working_agr_hh_any==1, fe cluster(kabid) nonest
	
	sigstar z_rain, prec(3) sebrackets
    estadd loc thisstat5= "`r(sestar)'": col3
   

    estadd loc thisstat7 = "Y": col3
	estadd loc thisstat8= "Y": col3
	*estadd loc thisstat9= "N": col3
	
	estadd loc thisstat11 = "4-5", replace : col3
	
	
	
********************************************************************************
************Column 4: food expenditure  -- non- agriculture sample*******************
********************************************************************************


	
	

	reg2hdfespatial hhexp_ z_rain if working_agr_hh_any==0, lat(ycoord) lon(xcoord) timevar(year) panelvar(id) ///
    distcutoff(100) lagcutoff(30) display star
	
	estadd loc thisstat10 = `e(N)': col4
	
	sigstar z_rain, prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat3 = "`r(bstar)'": col4
    estadd loc thisstat4 = "`r(sestar)'": col4
   
	
	
	xtreg hhexp_ z_rain i.year if working_agr_hh_any==0, fe cluster(kabid) nonest
	
	sigstar z_rain, prec(3) sebrackets
    estadd loc thisstat5= "`r(sestar)'": col4
	
	
    estadd loc thisstat7 = "Y": col4
	estadd loc thisstat8= "Y": col4
	*estadd loc thisstat9= "N": col4

	
	estadd loc thisstat11 = "1-5": col4

		


********************************************************************************
**************Column 5: Total expenditure-- non-agriculture sample*******************
********************************************************************************


	
	

	reg2hdfespatial  lnhhexp z_rain if working_agr_hh_any==0, lat(ycoord) lon(xcoord) timevar(year) panelvar(id) ///
    distcutoff(100) lagcutoff(30) display star
	
	estadd loc thisstat10 = `e(N)': col5
	
	sigstar z_rain, prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat3 = "`r(bstar)'": col5
    estadd loc thisstat4 = "`r(sestar)'": col5
   
	
	
	xtreg lnhhexp z_rain i.year if working_agr_hh_any==0, fe cluster(kabid) nonest
	
	sigstar z_rain, prec(3) sebrackets
    estadd loc thisstat5= "`r(sestar)'": col5
	
	
    estadd loc thisstat7 = "Y": col5
	estadd loc thisstat8= "Y": col5
	*estadd loc thisstat9= "N": col5
	
	estadd loc thisstat11 = "1-5": col5


********************************************************************************
********************Column 6: Depression-- non-agriculture sample*******************
********************************************************************************


	
	

	reg2hdfespatial z_depression z_rain if working_agr_hh_any==0, lat(ycoord) lon(xcoord) timevar(year) panelvar(id) ///
    distcutoff(100) lagcutoff(30) display star
	
	estadd loc thisstat10 = `e(N)': col6
	
	sigstar z_rain, prec(3) 
	estadd loc thisstat3 = "`r(bstar)'": col6
    estadd loc thisstat4 = "`r(sestar)'": col6
   
	
	xtreg z_depression z_rain i.year if working_agr_hh_any==0, fe cluster(kabid) nonest
	
	sigstar z_rain, prec(3) sebrackets
    estadd loc thisstat5= "`r(sestar)'": col6
   

    estadd loc thisstat7 = "Y": col6
	estadd loc thisstat8= "Y": col6
	*estadd loc thisstat9= "N": col6
	
	estadd loc thisstat11 = "4-5", replace : col6
		
	
	
	
loc rowlabels " " " " " " " "Rain (z-scored)" " " " " " "  "\hline Individual Fixed Effect" "Time FE"  " " "\hline N" "IFLS waves used"  "
loc rowstats ""

forval i = 0/11{
    loc rowstats "`rowstats' thisstat`i'"
}




esttab col1 col2 col3 col4 col5 col6   using "$tables/Table5_IFLSmain.tex", replace cells(none) ///
booktabs nonotes compress alignment(c) nogap noobs nobaselevels label stats(`rowstats', labels(`rowlabels')) ///
   mtitle("Per capita cons. " "Log per capita cons."  "Depression (z)" "Per capita cons. " "Log per capita cons."  "Depression (z)") ///
    mgroup("Working in agriculture"  "Not working in agriculture", pattern(1 0 0 1 0 0) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) 

est clear 

****************************************************************
*** Test for equality of coefficients (reported in footnote) ***
****************************************************************

	gen rain_agr=working_agr_hh_any*z_rain
	
	foreach y in 1998 2000 2001 2008 2015 {
	gen year_`y'_agr=working_agr_hh_any if year==`y'
	replace  year_`y'_agr=0 if year!=`y'
	
	}

	reg2hdfespatial hhexp_ z_rain rain_agr working_agr_hh_any year_*_agr , lat(ycoord) lon(xcoord) timevar(year) panelvar(id) ///
    distcutoff(100) lagcutoff(30) display star
	
	reg2hdfespatial lnhhexp z_rain rain_agr working_agr_hh_any year_*_agr , lat(ycoord) lon(xcoord) timevar(year) panelvar(id) ///
    distcutoff(100) lagcutoff(30) display star
	
	reg2hdfespatial z_depression z_rain rain_agr working_agr_hh_any  year_*_agr , lat(ycoord) lon(xcoord) timevar(year) panelvar(id) ///
    distcutoff(100) lagcutoff(30) display star

	

	
*** Calculation for intepretation of log-expenditure coefficient used for effect size ***
	
	sum hhexp_, d
	di "This is an $percent_impact increase over the long-term median: " r(p50)*$percent_impact
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
