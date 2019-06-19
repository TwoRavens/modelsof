   
/******************************************

	Code to generate reduced form 
	tables and figures for 
	"Technology Adoption Under Uncertainty"
	
	Oliva, Jack, Bell, Severen, Walker
	File last modified: 11-25-18
		
*******************************************/


**********************
** (0) SETUP 
**********************

clear all 
mata: mata clear
cap log close
set more off
set trace off
set linesize 140
set memory 200m
set matsize 1000
set maxvar 10000
set scheme s2color
set seed 123456789
timer clear

* cap cd "/Users/kelsey/Dropbox/zambiatrees/data_package/data_package_share/reduced_form/"

use "red_form_dataset.dta"

global controls hh_head Bd12_fhhh hi_ed hh_size q_wealth Bh01_howlongdun ///
	land_tot num_fields avg_dist Bg162_poorsoil ygl_contact cfucomaco Bi03_masanguknol Bi04_msanguplanted ///
	knows_risks	
	

********* Main Tables *********
	
*************************
* Table 1: Summary stats
*************************

preserve

	gen zero = tree_survive == 0
	replace zero = . if tree_survive == .
	
	gen positive = tree_survive
	replace positive = . if tree_survive == 0
	
	gen rcat = 1 if r == 0
	replace rcat = 2 if r > 0 & r <= 70000
	replace rcat = 3 if r > 70000 & r <= 150000
	label define rcat 1 "0" 2 "(0,70000]" 3 "(70000,150000]"
	label var rcat rcat
	
	tabstat takeup comply zero positive, by(a) stat(mean sd n) long format(%9.3g)
	tabstat takeup comply zero positive, by(rcat) stat(mean sd n) long format(%9.3g) nototal
	
	estpost tabstat takeup comply zero positive, by(a) stat(mean sd)
	esttab using Table1, ///
			cell("takeup(fmt(2)) comply(fmt(2)) zero(fmt(2)) positive(fmt(2))") nostar label csv replace noobs 
			
	estpost tabstat takeup comply zero positive, by(rcat) stat(mean sd) nototal
	esttab using Table1, ///
			cell("takeup(fmt(2)) comply(fmt(2)) zero(fmt(2)) positive(fmt(2))") nostar label csv append noobs

restore

*****************************************
* Table 2: Reduced form treatment effects
*****************************************

preserve

	replace tree_survive = 0 if takeup == 0
	replace comply = 0 if takeup == 0
	gen zero = tree_survive == 0
	replace zero = . if tree_survive == .

	reg takeup athou, cluster(group)
		sum takeup if e(sample)
		estadd local mean = r(mean)
		local mean: display %-9.2f `mean'
		est store t1
	
	reg takeup rthou if treat == 0, cluster(group)
		sum takeup if e(sample)
		estadd local mean = r(mean)
		local mean: display %-9.2f `mean'	
		estadd local no_surp "x"
		est store t2
	
	reg comply athou, cluster(group)
		sum comply if e(sample)
		estadd local mean = r(mean)
		local mean: display %-9.2f `mean'	
		est store c1
		
	reg comply rthou if treat == 0, cluster(group)
		sum comply if e(sample)
		estadd local mean = r(mean)
		local mean: display %-9.2f `mean'	
		estadd local no_surp "x"
		est store c2
		
	reg tree_survive athou if tree_survive>0, cluster(group)
		sum tree_survive if e(sample)
		estadd local mean = r(mean)
		local mean: display %-9.2f `mean'	
		est store s1
	
	reg tree_survive rthou if tree_survive>0 & treat == 0, cluster(group)
		sum tree_survive if e(sample)
		estadd local mean = r(mean)
		local mean: display %-9.2f `mean'
		estadd local no_surp "x"
		est store s2
		
	reg zero athou, cluster(group)
		sum zero if e(sample)
		estadd local mean = r(mean)
		local mean: display %-9.2f `mean'
		est store z1
	
	reg zero rthou if treat == 0, cluster(group)
		sum zero if e(sample)
		estadd local mean = r(mean)
		local mean: display %-9.2f `mean'
		estadd local no_surp "x"
		est store z2

esttab t* c* s* z* ///
	using "Table2.csv", b(3) se(3) wrap noobs nonumbers nonotes legend label csv nogaps ///
	star(* 0.10 ** 0.05 *** 0.01) title("Unconditional") stats(no_surp mean N, ///
	labels("Knew reward at take-up" "Dep. Var. Mean" "Observations") fmt(%10s %9.2f %9.0f)) ///
	mtitle("Take up" "" "Tree survival" "" "# trees | trees > 0" "" "1.(zero trees)" "") replace

est clear

	reg comply athou if takeup == 1, cluster(group)
		sum comply if e(sample)
		estadd local mean = r(mean)
		est store c1
		
	reg comply rthou if takeup == 1, cluster(group)
		sum comply if e(sample)
		estadd local mean = r(mean)
		estadd local surp "x"
		est store c2
		
	reg tree_survive athou if tree_survive>0 & takeup == 1, cluster(group)
		sum tree_survive if e(sample)
		estadd local mean = r(mean)
		est store s1
	
	reg tree_survive  rthou if tree_survive>0 & takeup == 1, cluster(group)
		sum tree_survive if e(sample)
		estadd local mean = r(mean)
		estadd local surp "x"
		est store s2
		
	reg zero athou if takeup == 1, cluster(group)
		sum zero if e(sample)
		estadd local mean = r(mean)
		est store z1
	
	reg zero rthou if takeup == 1, cluster(group)
		sum zero if e(sample)
		estadd local mean = r(mean)
		estadd local surp "x"
		est store z2

esttab c* s* z* ///
	using "Table2.csv", b(3) se(3) wrap noobs nonumbers nonotes legend label csv nogaps ///
	star(* 0.10 ** 0.05 *** 0.01) title("Conditional on take up") stats(mean N, ///
	labels("Dep. Var. Mean" "Observations") fmt(%10s %9.2f %9.0f)) ///
	mtitle("Tree survival" "" "# trees | trees > 0" "" "1.(zero trees)" "") append
	

restore



********* Appendix Tables and Figures *********

***********************************
* Figure A.5.1: Survival histogram
***********************************

hist tree_survive if r>0, ///
	xscale(range(0(10)50)) xlabel(0(10)50) bin(50) ///
	xline(35, lcolor(black) lpattern(dash)) fcolor(forest_green) ///
	xtitle(Tree survival) ytitle(Fraction) ylabel(0(.2).4) ///
	graphregion(fcolor(white) lcolor(white)) plotregion(fcolor(white) lcolor(white))
		

************************************
* Figure A.7.2: Treatment histogram
************************************

** Reward (R)

hist r, discrete freq ///
		graphregion(fcolor(white) lcolor(white)) title("") ///
		xlabel(0(50000)150000) xtitle(Reward in ZMK)

** Subsidy (A)

hist a, discrete freq ///
		graphregion(fcolor(white) lcolor(white)) title("") ///
		gap(50) xscale(range(0(4000)12000)) xlabel(0(4000)12000) ///
		xtitle(Take-up subsidy in ZMK)
	


***********************
* Table A.7.1: Balance
***********************

preserve
	 
	gen rcat = 0 if rthou == 0
	replace rcat = 1 if rthou > 0 & rthou <= 75
	replace rcat = 2 if rthou > 75 & rthou != .
	
	gen acat = 0 if athou == 0
	replace acat = 1 if athou == 4
	replace acat = 2 if athou == 8
	replace acat = 3 if athou == 12
	
	cap file close balance
	file open balance using "TableA.7.1.txt", write text replace
	
	file write balance  "" _tab "" _tab "" _tab "" _tab "" _tab "" _tab "" _tab "" _tab "" _tab "" _tab "" _tab "" _tab "" _n
	file write balance "" _tab "A = 0" _tab "A = 4" _tab "A = 8" _tab "A = 12" _tab "Max delta" _tab ///
		"R = 0" _tab "0 < R <= 75" _tab "75 < R <= 150" _tab "Max delta" _tab "Surprise = 0" _tab "Surprise = 1" _tab "Max delta" _n
	
	
	foreach X of varlist $controls {
	
		local variable_label : variable label `X'
		
		foreach treat of varlist acat rcat treat {
			
				levelsof `treat', local(levels)
		
				foreach i of local levels {
			
					sum `X' if `treat'==`i'
					local `treat'mean`i' : display %-8.3f `r(mean)'
					local `treat'sd`i' : display %-4.3f `r(sd)'
					local `treat'`i' `r(N)'
					local `treat'var`i' `r(Var)'
					
					} // end levels loop
		
			// generate normalized differences
			
			gen `treat'D_`X'_01 = [ ``treat'mean0' - ``treat'mean1' ] / sqrt( ``treat'var0' + ``treat'var1' )
			
			if "`treat'" == "acat" | "`treat'" == "rcat" {
				gen `treat'D_`X'_02 = [ ``treat'mean0' - ``treat'mean2' ] / sqrt( ``treat'var0' + ``treat'var2' )
				gen `treat'D_`X'_12 = [ ``treat'mean1' - ``treat'mean2' ] / sqrt( ``treat'var1' + ``treat'var2' )
				}
			
			if "`treat'" == "acat" {
				gen `treat'D_`X'_03 = [ ``treat'mean0' - ``treat'mean3' ] / sqrt( ``treat'var0' + ``treat'var3' )
				gen `treat'D_`X'_13 = [ ``treat'mean1' - ``treat'mean3' ] / sqrt( ``treat'var1' + ``treat'var3' )
				gen `treat'D_`X'_23 = [ ``treat'mean2' - ``treat'mean3' ] / sqrt( ``treat'var2' + ``treat'var3' )
				}
					
			for var `treat'D_`X'*: replace X=abs(X)		
			egen `treat'MAX`X'=rowmax(`treat'D_`X'*)
			sum `treat'MAX`X'
			local `treat'maxD : display %-8.3f `r(mean)'
			
			} // end treat loop
			
			file write balance "`variable_label'" _tab "`acatmean0'" _tab "`acatmean1'" _tab "`acatmean2'" _tab "`acatmean3'" _tab "`acatmaxD'" _tab ///
				"`rcatmean0'" _tab "`rcatmean1'" _tab "`rcatmean2'" _tab "`rcatmaxD'" _tab "`treatmean0'" _tab "`treatmean1'" _tab "`treatmaxD'" _n
			file write balance "" _tab "[`acatsd0']" _tab "[`acatsd1']" _tab "[`acatsd2']" _tab "[`acatsd3']" _tab "" _tab ///
				"[`rcatsd0']" _tab "[`rcatsd1']" _tab "[`rcatsd2']" _tab "" _tab "[`treatsd0']" _tab "[`treatsd1']" _tab "" _n
			
			} // end variable loop
	
	file close balance
		
	drop *MAX* acat* rcat* treatD*

restore

*************************
* Table A.7.2: Attrition
*************************

preserve
	
	gen rmiss = r == . & takeup == 0
	replace r = 0 if r == . & takeup == 0
	
		
	file open attrition_alt using ///
		TableA.7.2.txt, ///
		write text replace
		
	file write attrition_alt "Variable" _tab "Take up mean [SD]" _tab "Baseline coeff (se)" _tab "Endline Coeff (se)" _tab  "Tree Monitoring Coeff (se)" _n 
		
	local TREAT athou rthou treat rmiss
		
	foreach X of local TREAT {

	local variable_label : variable label `X'

	summ `X' if takeup != . 		
	local mean_takeup 	: display %-8.3f `r(mean)'
	local SD_takeup 	 	: display %-8.3f `r(sd)'
	
	
	* Run regressions
	
	reg in_baseline `X', cl(group) 
	local coef_base		= _b[`X'] 
	local coef_base 	: display %-8.3f `coef_base'
	local se_base 		= _se[`X']
	local se_base		: display %-8.3f `se_base'
	
	local p_base  		= (2 * ttail(e(df_r), abs(_b[`X']/_se[`X']))) 
    if `p_base'>0.1 	local stars_base =""
	if `p_base'<=0.1	local stars_base = "*" 
	if `p_base'<=0.05	local stars_base = "**" 
	if `p_base'<=0.01   local stars_base = "***"
		
	reg in_endline `X', cl(group) 
	local coef_end		= _b[`X'] 
	local coef_end 		: display %-8.3f `coef_end'
	local se_end		= _se[`X']
	local se_end		: display %-8.3f `se_end'
	
	local p_end  		= (2 * ttail(e(df_r), abs(_b[`X']/_se[`X']))) 
    if `p_end'>0.1 		local stars_end =""
	if `p_end'<=0.1		local stars_end = "*" 
	if `p_end'<=0.05	local stars_end	= "**" 
	if `p_end'<=0.01  	local stars_end = "***"
	
	reg in_treemon `X' if takeup == 1, cl(group) 
	local coef_treemon		= _b[`X'] 
	local coef_treemon 	: display %-8.3f `coef_treemon'
	local se_treemon		= _se[`X']
	local se_treemon		: display %-8.3f `se_treemon'
	
	local p_treemon  		= (2 * ttail(e(df_r), abs(_b[`X']/_se[`X']))) 
    if `p_treemon'>0.1 		local stars_treemon =""
	if `p_treemon'<=0.1		local stars_treemon = "*" 
	if `p_treemon'<=0.05	local stars_treemon	= "**" 
	if `p_treemon'<=0.01  	local stars_treemon = "***"
			
	
	* Get N values for all surveys  
	summ takeup if takeup != .
	local N_takeup	 	: display %-4.0f `r(N)'
	summ in_baseline if in_baseline == 1 
	local N_base	 	: display %-4.0f `r(N)'
	summ in_endline if in_endline == 1 		
	local N_end	 	: display %-4.0f `r(N)'
	summ in_treemon if in_treemon == 1 		
	local N_treemon 	: display %-4.0f `r(N)'
		
	file write attrition_alt "`X'" _tab "`mean_takeup'" _tab "`coef_base'`stars_base'" _tab "`coef_end'`stars_end'" _tab "`coef_treemon'`stars_treemon'" _n
	file write attrition_alt "" _tab "[`SD_takeup']" _tab "(`se_base')" _tab "(`se_end')" _tab "(`se_treemon')" _n

		} 
	file write attrition_alt "N, outcome = 1" _tab "`N_takeup'" _tab  "`N_base'" _tab "`N_end'" _tab "`N_treemon'" _tab "" _n

	file close attrition_alt
		
restore

	
************************************
* Table A.7.3: Incentive spillovers
************************************

preserve

	bys group: egen groupTakers = total(takeup)
	gen groupOthers = groupTakers - 1 if takeup == 1
	bys group: egen groupRewards = total(rdollar) if takeup == 1
	gen othersRewards = groupRewards - rdollar
	gen avgOthers = othersRewards/groupOthers
	
	reg tree_survive avgOthers rdollar if takeup == 1, cl(group)
	est sto m1
	reg tree_survive c.avgOthers##c.rdollar if takeup == 1, cl(group)
	est sto m2

	esttab m1 m2 using ///
	"TableA.7.3.csv", replace se obslast ///
		star(* 0.10 ** 0.05) label nogaps noeqlines mtitles stats(N r2, labels ("# obs" "r2"))
	
restore	

*****************************
* Table A.7.4: Reward timing
*****************************

preserve

	gen zero = tree_survive == 0
	replace zero = . if tree_survive == .
	
	gen positive = tree_survive
	replace positive = . if tree_survive == 0
	
	gen rcat = 1 if r == 0
	replace rcat = 2 if r > 0 & r <= 70000
	replace rcat = 3 if r > 70000 & r <= 150000
	label define rcat 1 "0" 2 "(0,70000]" 3 "(70000,150000]"
	label var rcat rcat
	
	file open surprise using ///
		TableA.7.4.txt, ///
		write text replace
		
	file write surprise "" _tab "Surprise = 0" _tab "Surprise = 1" _tab "Tree survival"  _n 
	file write surprise "" _tab "Mean [SD]" _tab "Mean [SD]" _tab "Coef: Reward x Surprise" _n
	
	forval i = 1/3 {

	summ tree_survive if treat == 0 & takeup == 1 & rcat == `i'		
	local mean_notreat`i' 	: display %-8.3f `r(mean)'
	local SD_notreat`i' 	 	: display %-8.3f `r(sd)'
	
	summ tree_survive if treat == 1 & takeup == 1 & rcat == `i'	 		
	local mean_treat`i'		: display %-8.3f `r(mean)'
	local SD_treat`i'	 	: display %-8.3f `r(sd)'	
	
	* Run regression, save interaction term
	
	reg tree_survive i.rcat##i.treat if takeup == 1, cl(group) 
	local coef`i'		= _b[`i'.rcat#1.treat] 
	local coef`i' 		: display %-8.3f `coef`i''
	local se`i' 		= _se[`i'.rcat#1.treat]
	local se`i'		: display %-8.3f `se`i''
	
			
	file write surprise "`X'" _tab "`mean_notreat`i''" _tab "`mean_treat`i''" _tab "`coef`i''" _n
	file write surprise "" _tab "[`SD_notreat`i'']" _tab "[`SD_treat`i'']" _tab "(`se`i'')"_n

		} 

	file close surprise

restore

*******************************
* Table A.7.5: A x R
*******************************

preserve 

	keep if takeup == 1
	
	gen rhigh = rthou > 75
	replace rhigh = . if rthou == .
	
	gen pos_a = a != 12000
	gen known = treat == 0
	
	
	reg comply rhigh pos_a if known == 1, cl(group)
		est store int1
		
	reg comply rhigh##pos_a if known == 1, cl(group)
		est store int2
	
	reg comply rhigh pos_a if known == 0, cl(group)
		est store int3
		
	reg comply rhigh##pos_a if known == 0, cl(group)
		est store int4
		
	esttab int* using ///
		"TableA.7.5.csv", replace pr2 se obslast b(3) se(3) ///
		 label nogaps noeqlines mtitles stats(mean N, labels("# obs") fmt(3 0)) ///
		star(* 0.10 ** 0.05 *** 0.01)
	
restore


***************************
* Table A.7.6: Observables
***************************

preserve
	
	drop if in_baseline == 0
	
	gen rmiss = r == . & takeup == 0
	replace r = 0 if r == . & takeup == 0
	
	replace tree_survive = . if takeup == 0
	replace comply = . if takeup == 0
	
	gen zero = tree_survive == 0
	replace zero = . if tree_survive == .
			
	* Take up
	
	reg takeup $controls, cl(group)
	sum takeup if e(sample)==1		
	estadd scalar mean = r(mean)
	est store tu
	
	reg takeup $controls rmiss#c.r a treat monitored, cl(group)
	sum takeup if e(sample)==1		
	estadd scalar mean = r(mean)
	est store tuT
	
	reg takeup $controls rmiss#c.r a, cl(group)

	
	* Follow through (trees>=35)

	reg comply $controls, cl(group)
	sum comply if e(sample)==1		
	estadd scalar mean = r(mean)
	est store ft
	
	reg comply $controls rmiss#c.r a treat monitored, cl(group)
	sum comply if e(sample)==1		
	estadd scalar mean = r(mean)
	est store ftT

	reg comply $controls rmiss#c.r a, cl(group)
	
	* Zeros
	
	reg zero $controls, cl(group)
	sum zero if e(sample)==1		
	estadd scalar mean = r(mean)
	est store z
	
	reg zero $controls rmiss#c.r a treat monitored, cl(group)
	sum zero if e(sample)==1		
	estadd scalar mean = r(mean)
	est store zT

	reg zero $controls rmiss#c.r a, cl(group)
		
	* Tree survival
	
	reg tree_survive $controls, cl(group)
	sum tree_survive if e(sample)==1		
	estadd scalar mean = r(mean)
	est store t
	
	reg tree_survive $controls rmiss#c.r a treat monitored, cl(group)
	sum tree_survive if e(sample)==1		
	estadd scalar mean = r(mean)
	est store tT
	
	reg tree_survive $controls rmiss#c.r a, cl(group)

	esttab tuT zT ftT tT using ///
	"TableA.7.6.csv", replace pr2 se obslast nogap ///
	 b(3) se(3) label noeqlines mtitles stats(r2 N mean, labels ("R squared" "Obs" "Dep. Var. Mean"))
	
restore


*********************************
* Table A.7.7: Farmer investments 
*********************************

preserve

	* (1) observed during field visit
	
	gen evid_weed = evid_weeding1
	replace evid_weed = 1 if evid_weeding2 == 1 & (evid_weed == 0 | evid_weed == .)
	replace evid_weed = 0 if evid_weed == 4 // all have zero trees and 4's for all observed field care vars
	label var evid_weed "Observed evidence of weeding"
	
	replace evid_fire1 = . if evid_fire1 == 0 & evid_weed == . & evid_water == . // no other behaviors recorded by monitor
	gen evid_fire = evid_fire1
	replace evid_fire = 1 if evid_fire2 == 1 & (evid_fire == 0 | evid_fire == .)
	replace evid_fire = 0 if evid_fire == 4 
	label var evid_fire "Observed evidence of fire breaks"
	
	gen evid_burning = evid_burning1
	replace evid_burning = 1 if evid_burning2 == 1 & (evid_burning == 0 | evid_burning == .)
	replace evid_burning = 0 if evid_burning == 4 
	label var evid_burning "Observed evidence of burning"
	
	gen evid_water = evid_watering
	replace evid_water = 0 if evid_water == 4 | evid_water == 3
	label var evid_water "Observed evidence of watering"
	
	
	foreach var of varlist evid_weed evid_fire evid_water evid_burning {
		
		reg `var' rthou athou monitored if takeup == 1, cl(group)
		estadd scalar pval = (2 * ttail(e(df_r), abs(_b[rthou]/_se[rthou])))
		sum `var' if e(sample)
		estadd scalar mean=r(mean)
		est store `var'
		
		}
	
		replace evid_weed = 0 if evid_weed == . & takeup == 1
		replace evid_fire = 0 if evid_fire == . & takeup == 1
		replace evid_burning = 0 if evid_burning == . & takeup == 1
		replace evid_water = 0 if evid_water == . & takeup == 1
		
	foreach var of varlist evid_weed evid_fire evid_water evid_burning {
		
		reg `var' rthou athou monitored if takeup == 1, cl(group)
		estadd scalar pval = (2 * ttail(e(df_r), abs(_b[rthou]/_se[rthou])))
		sum `var' if e(sample)
		estadd scalar mean=r(mean)
		est store `var'_imp
		
		}
		
	esttab evid_weed evid_fire evid_water evid_burning ///
		using "TableA.7.7.csv", b(4) se(4) wrap noobs nonumbers nonotes legend label csv nogaps ///
		star(* 0.10 ** 0.05 *** 0.01) title("Sample: Recorded by monitor") scalars(pval mean N) sfmt(%9.3f %9.2f %9.0f) ///
		mtitle("Weeding" "Fire breaks" "Watering" "Burning") replace
		
	esttab evid_weed_imp evid_fire_imp evid_water_imp evid_burning_imp ///
		using "TableA.7.7.csv", b(4) se(4) wrap noobs nonumbers nonotes legend label csv nogaps ///
		star(* 0.10 ** 0.05 *** 0.01) title("Sample: Imputed zeros") scalars(pval mean N) sfmt(%9.3f %9.2f %9.0f) ///
		mtitle("Weeding" "Fire breaks" "Watering" "Burning") append

restore

*******************************
* Table A.7.8: Procrastination
*******************************

	// Self reported procrastination tendencies

preserve

	gen posR = r > 0 
	replace posR = . if r == .
	
	replace tree_survive = 0 if takeup == 0
	gen any_surv = tree_survive > 0
	replace any_surv = 0 if takeup == 0
	replace comply = 0 if takeup == 0
	
	* Column 1: Takeup as a result of procrastination binary measure 
	reg takeup procrast_ab athou $controls, cl(group)  
	est stor procrast_takeupa
	
	* Column 2: Survival on procrastination binary
	reg tree_survive procrast_ab athou $controls if takeup==1, cl(group)    
	est stor procrast_survivea
	
	* Column 3: Survival on procrastination binary, plus reward
	reg tree_survive procrast_ab athou rthou $controls if takeup==1, cl(group)    
	est stor procrast_survivear
	
	* Column 4: Interactions 
	reg takeup procrast_ab##c.athou $controls, cl(group) 
	est stor procrast_intera
	
	* Column 5: Interactions 
	reg takeup procrast_ab##c.athou rthou $controls if treat == 0, cl(group) 
	est stor procrast_interar

	esttab procrast_takeupa procrast_survivea procrast_survivear  procrast_intera procrast_interar using ///
	"TableA.7.8.csv", replace pr2 se obslast b(3) se(3) ///
	 label nogaps noeqlines mtitles stats(mean N, labels("# obs") fmt(3 0)) ///
	star(* 0.10 ** 0.05 *** 0.01)


	// Procrastination in other activities 
	
	* Column 1: Takeup as a result of acting late binary measure 
	reg takeup actlate athou $controls, cl(group)  
	est stor actlate_takeupa
	
	* Column 2: Survival on acting late binary
	reg tree_survive actlate athou $controls if takeup==1, cl(group)    // will only be those who took up bc missing for those who did not
	est stor actlate_survivea
	
	* Column 3: Survival on acting late binary, plus reward
	reg tree_survive actlate athou rthou $controls if takeup==1, cl(group)    // will only be those who took up bc missing for those who did not
	est stor actlate_survivear
	
	* Column 4: Interactions 
	reg takeup actlate##c.athou $controls, cl(group) 
	est stor actlate_intera
	
	* Column 5: Interactions 
	reg takeup actlate##c.athou rthou $controls if treat == 0, cl(group) //gaining 5 obs?
	est stor actlate_interar

	esttab actlate_takeupa actlate_survivea actlate_survivear actlate_intera actlate_interar using ///
	"TableA.7.8.csv", append pr2 se obslast b(3) se(3) ///
	 label nogaps noeqlines mtitles stats(mean N, labels("# obs") fmt(3 0)) ///
	star(* 0.10 ** 0.05 *** 0.01)

restore


*************************
* Table A.7.9: Learning
*************************

preserve
	
	bys group: egen group_msangu = max(Bi04_msanguplanted)
	gen zero = tree_survive == 0
	gen pos_a = a != 12000
	gen free = a == 12000

	tab zero Bi04_msanguplanted if takeup == 1, mi col
	tab zero Bi04_msanguplanted if takeup == 1 & a == 12000, mi col
	tab zero Bi04_msanguplanted if takeup == 1 & a != 12000, mi col

	local controls hh_head Bd12_fhhh hh_size Bh01_howlongdun ///
	land_tot num_field avg_dist Bg162_poorsoil ygl_contact cfucomaco Bi03_masanguknol 
	
	reg zero pos_a##Bi04_msanguplanted rthou monitored treat $controls if takeup == 1, cl(group)
	est store learn1

	reg zero pos_a##group_msangu rthou monitored treat $controls if takeup == 1, cl(group)
	est store learn2
	
	reg zero pos_a##knows_risks rthou monitored treat `controls' if takeup == 1, cl(group)
	est store learn3

	esttab learn1 learn2 learn3 using ///
		"TableA.7.9.csv", replace pr2 se obslast b(3) se(3) ///
		 label nogaps noeqlines mtitles ///
		star(* 0.10 ** 0.05 *** 0.01)	

restore
