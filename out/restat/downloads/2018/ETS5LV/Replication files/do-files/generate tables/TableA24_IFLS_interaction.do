

use "$data/ifls_complete.dta", clear


*******************************************************************************************************************************


duplicates tag pidlink, gen(panel_var)

keep if panel_var==4
	
keep if working_agr_hh_any==1 


*** Genearte interactions **

gen male=sex==1 if sex!=.

gen young=age<50 if age!=.&year==2008
bys pidlink: egen temp=max(young)
replace young=temp
drop temp

gen young_men=young*(sex==1)
gen young_women=young*(sex==3)

gen male_trends=year*male
gen young_trends=year*young

gen male_rain=z_rain*male
gen young_rain=z_rain*young



gen temp =hhexp_ if year==2001|year==2000

bys pidlink: egen hhexp_base=max(temp)

sum hhexp_base, d

replace hhexp_base=(hhexp_base-r(mean))/r(sd)

gen hhexp_trends =hhexp_base*year

gen hhexp_rain=z_rain*hhexp_base

drop temp



loc experiments "1 2 3"
	
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
*****************************Column 1: Depression male       *******************
********************************************************************************


	
	

	reg2hdfespatial z_depression z_rain male male_rain male_trends , lat(ycoord) lon(xcoord) timevar(year) panelvar(id) ///
    distcutoff(100) lagcutoff(30) display star
	
	estadd loc thisstat14= `e(N)': col1
	
	sigstar z_rain, prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat3 = "`r(bstar)'": col1
    estadd loc thisstat4 = "`r(sestar)'": col1
	
	sigstar male_rain, prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat7 = "`r(bstar)'": col1
    estadd loc thisstat8 = "`r(sestar)'": col1
	
	
 
	
	
	xtreg z_depression z_rain z_rain male male_rain male_trends i.year, fe cluster(kabid) nonest
	
	sigstar z_rain, prec(3) sebrackets
    estadd loc thisstat5= "`r(sestar)'": col1
	
	sigstar male_rain, prec(3) sebrackets
    estadd loc thisstat9= "`r(sestar)'": col1
	
	
	
    estadd loc thisstat11 = "Y": col1
	estadd loc thisstat12= "Y": col1


	
		estadd loc thisstat15 = "4-5": col1

		


********************************************************************************
*****************************Column 2: Young workers               *************
********************************************************************************

	reg2hdfespatial z_depression z_rain young_rain young young_trend  , lat(ycoord) lon(xcoord) timevar(year) panelvar(id) ///
    distcutoff(100) lagcutoff(30) display star

	estadd loc thisstat14= `e(N)': col2
	
	sigstar z_rain, prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat3 = "`r(bstar)'": col2
    estadd loc thisstat4 = "`r(sestar)'": col2
	
	sigstar young_rain, prec(3) 
	di  "`r(sestar)'"
	estadd loc thisstat7 = "`r(bstar)'": col2
    estadd loc thisstat8 = "`r(sestar)'": col2
	
	 
	
	
	xtreg z_depression z_rain young_rain young young_trend i.year, fe cluster(kabid) nonest
	
	sigstar z_rain, prec(3) sebrackets
    estadd loc thisstat5= "`r(sestar)'": col2
	
	sigstar young_rain, prec(3) sebrackets
    estadd loc thisstat9= "`r(sestar)'": col2
	
	
    estadd loc thisstat11 = "Y": col2
	estadd loc thisstat12= "Y": col2


	
	estadd loc thisstat15 = "4-5": col2

	


********************************************************************************
*****************************Column 3: Depression     *******************
********************************************************************************


	
	

	reg2hdfespatial z_depression  hhexp_base z_rain hhexp_rain hhexp_trend, lat(ycoord) lon(xcoord) timevar(year) panelvar(id) ///
    distcutoff(100) lagcutoff(30) display star
	
	estadd loc thisstat14= `e(N)': col3
	
	sigstar z_rain, prec(3) 
	estadd loc thisstat3 = "`r(bstar)'": col3
    estadd loc thisstat4 = "`r(sestar)'": col3
	
	sigstar hhexp_rain, prec(3) 
	estadd loc thisstat7 = "`r(bstar)'": col3
    estadd loc thisstat8 = "`r(sestar)'": col3
 
	xtreg z_depression z_rain i.year hhexp_base hhexp_rain hhexp_trend, fe cluster(kabid) nonest
	
	sigstar z_rain, prec(3) sebrackets
    estadd loc thisstat5= "`r(sestar)'": col3
   
   	sigstar hhexp_rain, prec(3) sebrackets
    estadd loc thisstat9 = "`r(sestar)'": col3
   
   

    estadd loc thisstat11 = "Y": col3
	estadd loc thisstat12= "Y": col3

	
	estadd loc thisstat15 = "4-5", replace : col3
	
	
	
	
loc rowlabels " "Dependent variable: depression z-score " "\cline{1-1} " " " "Rain (z-scored)" " " " " " " "Rain (z-scored) $\times$ Heterogeneity" " " " " " " "\hline Individual FE" "Time FE" " " "\hline N" "IFLS Waves used"  "
loc rowstats ""

forval i = 0/15 {
    loc rowstats "`rowstats' thisstat`i'"
}




esttab col1 col2 col3 using "$tables/TableA24_IFLS_interaction.tex", replace cells(none) ///
booktabs nonotes nomtitle compress alignment(c) nogap noobs nobaselevels label stats(`rowstats', labels(`rowlabels')) ///
    mgroup("Male"  "Aged < 50 (median)" "Baseline expenditure (z-scored)" , pattern(1 1 1) prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span})) 

est clear 
