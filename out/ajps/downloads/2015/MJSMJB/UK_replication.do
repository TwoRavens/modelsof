*	4/23/2015
*
*	Replication file for Philips, Andrew, Amanda Rutherford, and Guy D. Whitten
*	"Dynamic pie: A strategy for modeling trade-offs in compositional variables
*	over time" American Journal of Political Science.
*
*								UK RESULTS
*	-------------------------------------------------------------------------

* verify burd is on here for nice graphs
foreach package in scheme-burd  {
		capture which `package'
		if _rc==111 ssc install `package'
 	}
set scheme burd
* findit estsimp		// if user needs to download clarify


use UK_AJPS.dta, clear



*		Table 2 -------------------------------------------------------------
global sureg_relative_Lab	"sureg (D.Con_Lab L.Con_Lab D.all_LabLeaderEval_W L.all_LabLeaderEval_W  D.all_ConLeaderEval_W L.all_ConLeaderEval_W D.all_LDLeaderEval_W L.all_LDLeaderEval_W D.all_pidW L.all_pidW D.all_nat_retW L.all_nat_retW D.all_b_mii_lab_pct L.all_b_mii_lab_pct)	(D.lDM_Lab L.lDM_Lab D.all_LabLeaderEval_W L.all_LabLeaderEval_W  D.all_ConLeaderEval_W L.all_ConLeaderEval_W D.all_LDLeaderEval_W L.all_LDLeaderEval_W D.all_pidW L.all_pidW D.all_nat_retW L.all_nat_retW D.all_b_mii_lab_pct L.all_b_mii_lab_pct), corr	"
$sureg_relative_Lab

global sureg_relative_Con	"sureg (D.lDM_Con L.lDM_Con D.all_LabLeaderEval_W L.all_LabLeaderEval_W  D.all_ConLeaderEval_W L.all_ConLeaderEval_W D.all_LDLeaderEval_W L.all_LDLeaderEval_W D.all_pidW L.all_pidW D.all_nat_retW L.all_nat_retW D.all_b_mii_lab_pct L.all_b_mii_lab_pct) (D.lab_Con L.lab_Con D.all_LabLeaderEval_W L.all_LabLeaderEval_W  D.all_ConLeaderEval_W L.all_ConLeaderEval_W D.all_LDLeaderEval_W L.all_LDLeaderEval_W D.all_pidW L.all_pidW D.all_nat_retW L.all_nat_retW D.all_b_mii_lab_pct L.all_b_mii_lab_pct), corr "
$sureg_relative_Con

* LR effects for table 2
$sureg_relative_Lab
nlcom [D_Con_Lab]L.all_LabLeaderEval_W/(-[D_Con_Lab]_b[L.Con_Lab])
nlcom [D_Con_Lab]L.all_ConLeaderEval_W/(-[D_Con_Lab]_b[L.Con_Lab])
nlcom [D_Con_Lab]L.all_LDLeaderEval_W/(-[D_Con_Lab]_b[L.Con_Lab])
nlcom [D_Con_Lab]L.all_pidW/(-[D_Con_Lab]_b[L.Con_Lab])
nlcom [D_Con_Lab]L.all_nat_retW/(-[D_Con_Lab]_b[L.Con_Lab])
nlcom [D_Con_Lab]L.all_b_mii_lab_pct/(-[D_Con_Lab]_b[L.Con_Lab])

$sureg_relative_Lab
nlcom [D_lDM_Lab]L.all_LabLeaderEval_W/(-[D_lDM_Lab]_b[L.lDM_Lab])
nlcom [D_lDM_Lab]L.all_ConLeaderEval_W/(-[D_lDM_Lab]_b[L.lDM_Lab])
nlcom [D_lDM_Lab]L.all_LDLeaderEval_W/(-[D_lDM_Lab]_b[L.lDM_Lab])
nlcom [D_lDM_Lab]L.all_pidW/(-[D_lDM_Lab]_b[L.lDM_Lab])
nlcom [D_lDM_Lab]L.all_nat_retW/(-[D_lDM_Lab]_b[L.lDM_Lab])
nlcom [D_lDM_Lab]L.all_b_mii_lab_pct/(-[D_lDM_Lab]_b[L.lDM_Lab])

$sureg_relative_Con
nlcom [D_lDM_Con]L.all_LabLeaderEval_W/(-[D_lDM_Con]_b[L.lDM_Con])
nlcom [D_lDM_Con]L.all_ConLeaderEval_W/(-[D_lDM_Con]_b[L.lDM_Con])
nlcom [D_lDM_Con]L.all_LDLeaderEval_W/(-[D_lDM_Con]_b[L.lDM_Con])
nlcom [D_lDM_Con]L.all_pidW/(-[D_lDM_Con]_b[L.lDM_Con])
nlcom [D_lDM_Con]L.all_nat_retW/(-[D_lDM_Con]_b[L.lDM_Con])
nlcom [D_lDM_Con]L.all_b_mii_lab_pct/(-[D_lDM_Con]_b[L.lDM_Con])

*	-------------------------------------------------------------------------



*						Graphical Simulations
* -------------------------------------------------------------
/* Note: we are still in the testing stages of producing a Stata .ado program
 "dynsimpie: A program to dynamically examine compositional dependent variables.
 Please direct all correspondence regarding this early iteration of the program
 below to Andrew Philips, (aphilips@pols.tamu.edu).	
*/

*				UK	Dynsimpie (3 Dependent variables)
*
* --------------------------------------------------------------------------
/* 
	Dynsimpie must have a varlist as well as dependent variables with tlogit 
	already applied and placed in the dvs() option. A shockvar, NOT in the
	varlist must be provided, as do shock() and time(). To not shock (i.e. 
	run a baseline model) simply specify shock(0). 3 Dummy variables can be
	specified.  each dummy can be set to 1 for an interval.  Specifying a 
	dummy but not dumstart or dumend sets the dummy to 0.  The time interval
	for the dynamic simulation runs from t=1 to t=20. there are options for up
	to 3 shocks. All shocks occur at the same time.  The other shock variables
	are shockvar2 and shockvar3. You ALWAYS need to at least specify shockvar(),
	but don't have to include shockvar2 or shockvar3 if you don't need them.
	Remember that the shocked variables you specify should NOT be included in
	the varlist also.
	
	dvs = dependent compositional variables
	time = time of the shock
	shockvar = the variable you want to shock
	shock = the value of shock
	dummy* = dummy variables
	dumstart* = start of setting dummy to 1
	dumend* = set dummy back to 0
	
	
	 
*/

capture program drop dynsimpie
capture program define dynsimpie , rclass
syntax [varlist] [if] [in], [ dvs(varlist) shockvar(varname) 	///
shockvar2(varname) shockvar3(varname) Time(numlist integer > 1)		    /// 
SHock(numlist) shock2(numlist) shock3(numlist)] [dummy1(varname) 		///
dumstart1(numlist integer >= 1) dumend1(numlist integer >= 2) ] 		///
[dummy2(varname) dumstart2(numlist integer >= 1) dumend2(numlist		///
integer >= 2) ] [dummy3(varname) dumstart3(numlist integer >= 1)		///
dumend3(numlist integer >= 2) ]  [sig(numlist)]
		 
version 8
marksample touse
preserve

if "`sig'" != ""	{						// getting the CI's signif
	local signif `sig'
}
else	{
	local signif 95
}
local sigl = (100-`signif')/2
local sigu = 100-((100-`signif')/2)

* ------------------------Generating Variables----------------------------------

qui foreach var of varlist `varlist'  {		// get d. and l. indep vars
	gen L`var' = l.`var'
	gen D`var' = d.`var'
}			
								
qui if "`shockvar3'" != "" {				// same for the shock var(s)
	gen lag`shockvar' = l.`shockvar'  
	gen diff`shockvar' = d.`shockvar'
	gen lag`shockvar2' = l.`shockvar2'								
	gen diff`shockvar2' = d.`shockvar2'
	gen lag`shockvar3' = l.`shockvar3'								
	gen diff`shockvar3' = d.`shockvar3'	
}
else if "`shockvar2'" !="" {
	gen lag`shockvar' = l.`shockvar'  
	gen diff`shockvar' = d.`shockvar'
	gen lag`shockvar2' = l.`shockvar2'								
	gen diff`shockvar2' = d.`shockvar2'
}	
else	{
	gen lag`shockvar' = l.`shockvar'  
	gen diff`shockvar' = d.`shockvar'	
}
							
tokenize `dvs'								// do the same for dep vars		
qui gen ddepvara = d.`1'											
qui gen ldepvara = l.`1'											
qui gen ddepvarb = d.`2'											
qui gen ldepvarb = l.`2'											
qui gen depvara = `1'						// grab means for later
qui gen depvarb = `2'									

* ------------------------Model Estimation-------------------------------------
if "`dummy3'" != "" {

	if "`shockvar3'" != "" {
		qui sureg (ddepvara ldepvara D* L* lag`shockvar' 			///
		diff`shockvar' lag`shockvar2' diff`shockvar2' lag`shockvar3' 	///
		diff`shockvar3' `dummy1' `dummy2' `dummy3') (ddepvarb ldepvarb	///
		D* L* lag`shockvar' diff`shockvar' lag`shockvar2'				///
		lag`shockvar3' diff`shockvar3' diff`shockvar2' `dummy1' 		///
		`dummy2' `dummy3')
		keep if e(sample)			// we only want to calculate in-sample
		
		estsimp sureg (ddepvara ldepvara D* L* lag`shockvar' 			///
		diff`shockvar' lag`shockvar2' diff`shockvar2' lag`shockvar3' 	///
		diff`shockvar3' `dummy1' `dummy2' `dummy3') (ddepvarb ldepvarb	///
		D* L* lag`shockvar' diff`shockvar' lag`shockvar2'				///
		diff`shockvar2' lag`shockvar3' diff`shockvar3' `dummy1'			///
		`dummy2' `dummy3') , corr		
	}
	
	else if "`shockvar2'" !="" {
	
		qui sureg (ddepvara ldepvara D* L* lag`shockvar' diff`shockvar' ///
		lag`shockvar2' diff`shockvar2' `dummy1' `dummy2' `dummy3')		///
		(ddepvarb ldepvarb D* L* lag`shockvar' diff`shockvar' 			///
		lag`shockvar2' diff`shockvar2' `dummy1' `dummy2' `dummy3')
		keep if e(sample)	
		
		estsimp sureg (ddepvara ldepvara D* L* lag`shockvar'			///
		diff`shockvar' lag`shockvar2' diff`shockvar2' `dummy1' `dummy2' ///
		`dummy3') (ddepvarb ldepvarb D* L* lag`shockvar' diff`shockvar' ///
		lag`shockvar2' diff`shockvar2' `dummy1' `dummy2' `dummy3'), corr
	}
	
	else	{
	
		qui sureg (ddepvara ldepvara D* L* lag`shockvar' diff`shockvar' ///
		`dummy1' `dummy2' `dummy3') (ddepvarb ldepvarb D* L*			///
		lag`shockvar' diff`shockvar' `dummy1' `dummy2' `dummy3') 
		keep if e(sample)
		
		estsimp sureg (ddepvara ldepvara D* L* lag`shockvar' 			///
		diff`shockvar'  `dummy1' `dummy2' `dummy3') (ddepvarb ldepvarb  ///
		D* L* lag`shockvar' diff`shockvar' `dummy1' `dummy2' `dummy3')	///
		, corr		
	}	
							
}	

else if "`dummy2'" != "" {

	if "`shockvar3'" != "" {
	
		qui sureg (ddepvara ldepvara D* L* lag`shockvar' 				///
		diff`shockvar' lag`shockvar2' diff`shockvar2' lag`shockvar3' 	///
		diff`shockvar3' `dummy1' `dummy2' ) (ddepvarb ldepvarb			///
		D* L* lag`shockvar' diff`shockvar' lag`shockvar2'				///
		lag`shockvar3' diff`shockvar3' diff`shockvar2' `dummy1' 		///
		`dummy2' )
		keep if e(sample)			// we only want to calculate in-sample
		
		estsimp sureg (ddepvara ldepvara D* L* lag`shockvar' 			///
		diff`shockvar' lag`shockvar2' diff`shockvar2' lag`shockvar3' 	///
		diff`shockvar3' `dummy1' `dummy2') (ddepvarb ldepvarb			///
		D* L* lag`shockvar' diff`shockvar' lag`shockvar2'				///
		diff`shockvar2' lag`shockvar3' diff`shockvar3' `dummy1'			///
		`dummy2' ) , corr		
	}
	
	else if "`shockvar2'" !="" {
		
		qui sureg (ddepvara ldepvara D* L* lag`shockvar' diff`shockvar' ///
		lag`shockvar2' diff`shockvar2' `dummy1' `dummy2' )				///
		(ddepvarb ldepvarb D* L* lag`shockvar' diff`shockvar' 			///
		lag`shockvar2' diff`shockvar2' `dummy1' `dummy2' )
		keep if e(sample)	
		
		estsimp sureg (ddepvara ldepvara D* L* lag`shockvar'			///
		diff`shockvar' lag`shockvar2' diff`shockvar2' `dummy1' `dummy2' ///
		) (ddepvarb ldepvarb D* L* lag`shockvar' diff`shockvar'			///
		lag`shockvar2' diff`shockvar2' `dummy1' `dummy2' ), corr		
	}
	
	else	{
		qui sureg (ddepvara ldepvara D* L* lag`shockvar' diff`shockvar' ///
		`dummy1' `dummy2') (ddepvarb ldepvarb D* L*						///
		lag`shockvar' diff`shockvar' `dummy1' `dummy2' ) 
		keep if e(sample)
		
		estsimp sureg (ddepvara ldepvara D* L* lag`shockvar' 			///
		diff`shockvar'  `dummy1' `dummy2') (ddepvarb ldepvarb  			///
		D* L* lag`shockvar' diff`shockvar' `dummy1' `dummy2' )			///
		, corr		
	}								
}																	

else if "`dummy1'" != "" {

	if "`shockvar3'" != "" {
		
		qui sureg (ddepvara ldepvara D* L* lag`shockvar' diff`shockvar' ///
		lag`shockvar2' diff`shockvar2' lag`shockvar3' diff`shockvar3'	///
		`dummy1' ) (ddepvarb ldepvarb D* L* lag`shockvar'				///
		diff`shockvar' lag`shockvar2' lag`shockvar3' diff`shockvar3' 	///
		diff`shockvar2' `dummy1')
		keep if e(sample)			// we only want to calculate in-sample
		
		estsimp sureg (ddepvara ldepvara D* L* lag`shockvar' 			///
		diff`shockvar' lag`shockvar2' diff`shockvar2' lag`shockvar3' 	///
		diff`shockvar3' `dummy1') (ddepvarb ldepvarb D* L*				///
		lag`shockvar' diff`shockvar' lag`shockvar2' diff`shockvar2' 	///
		lag`shockvar3' diff`shockvar3' `dummy1') , corr		
	}
	
	else if "`shockvar2'" !="" {
		
		qui sureg (ddepvara ldepvara D* L* lag`shockvar' diff`shockvar' ///
		lag`shockvar2' diff`shockvar2' `dummy1') (ddepvarb ldepvarb D*	///
		L* lag`shockvar' diff`shockvar' lag`shockvar2' diff`shockvar2'	///
		`dummy1')
		keep if e(sample)	
		
		estsimp sureg (ddepvara ldepvara D* L* lag`shockvar'			///
		diff`shockvar' lag`shockvar2' diff`shockvar2' `dummy1')			///
		(ddepvarb ldepvarb D* L* lag`shockvar' diff`shockvar' 			///
		lag`shockvar2' diff`shockvar2' `dummy1'), corr	
	}
	
	else	{
		
		qui sureg (ddepvara ldepvara D* L* lag`shockvar' diff`shockvar' ///
		`dummy1') (ddepvarb ldepvarb D* L* lag`shockvar' diff`shockvar' ///
		`dummy1') 
		keep if e(sample)
		
		estsimp sureg (ddepvara ldepvara D* L* lag`shockvar' 			///
		diff`shockvar' `dummy1') (ddepvarb ldepvarb D* L* lag`shockvar' ///
		diff`shockvar' `dummy1') , corr
	}							
}		

else {

	if "`shockvar3'" != "" {
		
		qui sureg (ddepvara ldepvara D* L* lag`shockvar' diff`shockvar' ///
		lag`shockvar2' diff`shockvar2' lag`shockvar3' diff`shockvar3'	///
		) (ddepvarb ldepvarb D* L* lag`shockvar'						///
		diff`shockvar' lag`shockvar2' lag`shockvar3' diff`shockvar3' 	///
		diff`shockvar2')
		keep if e(sample)			// we only want to calculate in-sample
		
		estsimp sureg (ddepvara ldepvara D* L* lag`shockvar' 			///
		diff`shockvar' lag`shockvar2' diff`shockvar2' lag`shockvar3' 	///
		diff`shockvar3') (ddepvarb ldepvarb D* L*						///
		lag`shockvar' diff`shockvar' lag`shockvar2' diff`shockvar2' 	///
		lag`shockvar3' diff`shockvar3') , corr	
	}
	
	else if "`shockvar2'" !="" {
	
		qui sureg (ddepvara ldepvara D* L* lag`shockvar' diff`shockvar' ///
		lag`shockvar2' diff`shockvar2') (ddepvarb ldepvarb D*			///
		L* lag`shockvar' diff`shockvar' lag`shockvar2' diff`shockvar2')
		keep if e(sample)
		
		estsimp sureg (ddepvara ldepvara D* L* lag`shockvar'			///
		diff`shockvar' lag`shockvar2' diff`shockvar2')					///
		(ddepvarb ldepvarb D* L* lag`shockvar' diff`shockvar' 			///
		lag`shockvar2' diff`shockvar2' ), corr		
	}
	
	else	{
		
		qui sureg (ddepvara ldepvara D* L* lag`shockvar' diff`shockvar' ///
		) (ddepvarb ldepvarb D* L* lag`shockvar' diff`shockvar') 
		keep if e(sample)
		
		estsimp sureg (ddepvara ldepvara D* L* lag`shockvar' 			///
		diff`shockvar') (ddepvarb ldepvarb D* L* lag`shockvar'			///
		diff`shockvar' ) , corr
	}						
}		
					
* ------------------------Scalars and setx--------------------------------------
qui setx mean		// cover our bases and set everything to its mean:			

* scalars for the lagged shock values
if "`shockvar3'" != "" {
	qui su lag`shockvar3', meanonly											
   	local sv3 = r(mean) 				// sample mean of lagged shockvar
   	local vs3 = `sv3' + `shock3'		// post shock value of shockvar
   	qui setx diff`shockvar3' 0			// set differenced shocks to 0		
	qui setx lag`shockvar3' mean		// set lagged shocks to mean
   	
   	qui su lag`shockvar2', meanonly											
   	local sv2 = r(mean) 											
    local vs2 = `sv2' + `shock2'
    qui setx diff`shockvar2' 0											
	qui setx lag`shockvar2' mean
   	
	qui su lag`shockvar', meanonly												
	local sv = r(mean) 													
	local vs = `sv' + `shock'
	qui setx diff`shockvar' 0			
	qui setx lag`shockvar' mean	
}
else if "`shockvar2'" !="" {
	qui su lag`shockvar2', meanonly											
   	local sv2 = r(mean) 											
    local vs2 = `sv2' + `shock2'
    qui setx diff`shockvar2' 0											
	qui setx lag`shockvar2' mean
   	
	qui su lag`shockvar', meanonly												
	local sv = r(mean) 													
	local vs = `sv' + `shock'
	qui setx diff`shockvar' 0			
	qui setx lag`shockvar' mean	
}
else { 		   	
	qui su lag`shockvar', meanonly												
	local sv = r(mean) 													
	local vs = `sv' + `shock'	
}																	
	qui su depvara						// set lagged DVs to means
	qui scalar m1 = r(mean)
	qui setx ldepvara m1
	
	qui su depvarb
	qui scalar m2 = r(mean)
	qui setx ldepvarb m2	
							 
	qui setx D* 0						// set diff indep. vars to 0
	
forv m = 1/3 {							// sets dummy to 0 if it exists at t=1	
	if "`dummy`m''" !="" {													
		setx `dummy`m'' 0	
		di "You have specified `dummy`m'' as a dummy variable"	
	}
	if "`dumstart`m''" == "1" {			// set dummy to 1 if specified at t=1
		setx `dummy`m'' 1 
		di "You have specified `dummy`m'' to start at the beginning of the simulation"
		di 
		di " --------------------------------------------------"
	}
}	
				
* ------------------------Predict Values-------------------------------------
qui simqi, ev genev(td1log1 td2log1)	// grab expected values	at t=1

qui su depvara
qui scalar m1 = r(mean)					// generate our expected value 
gen t1log1 = m1 + td1log1				// and add on the past value
					
qui su depvarb
qui scalar m2 = r(mean)											
gen t2log1 = m2 + td2log1											
	
qui su t1log1, meanonly					// these scalars become the new LDV	
qui scalar m1 = r(mean)												
qui su t2log1, meanonly												
qui scalar m2 = r(mean)							
					
* ------------------------Loop Through Time------------------------------------
nois _dots 0, title(Simulation in Progress) reps(20)
qui forvalues i = 2/20 {													 
	noi _dots `i'  0	
	
	qui setx ldepvara m1 ldepvarb m2 	// set the new value of LDV
	 			
	if `i' == `time' { 					// at t we experience the shock 		
		if "`shockvar3'" != "" {		// shock affects diff at time t only
			qui setx diff`shockvar3' `shock3'
			qui setx diff`shockvar2' `shock2'			
			qui setx diff`shockvar' `shock'		
		}
		else if "`shockvar2'" !="" {
			qui setx diff`shockvar2' `shock2'			
			qui setx diff`shockvar' `shock'
		}
		else	{
			qui setx diff`shockvar' `shock'	
		}																		
	}																				
	else if `i' > `time' {	
		if "`shockvar3'" != "" {										
			qui setx diff`shockvar3' 0 										
			qui setx lag`shockvar3' (`vs3')
			qui setx diff`shockvar2' 0 										
			qui setx lag`shockvar2' (`vs2')
			qui setx diff`shockvar' 0 		// diff shock back to 0			
			qui setx lag`shockvar' (`vs')	// lag shock now at new value
		}
		else if "`shockvar2'" !="" {
			qui setx diff`shockvar2' 0 										
			qui setx lag`shockvar2' (`vs2')
			qui setx diff`shockvar' 0 				
			qui setx lag`shockvar' (`vs')	
		}
		else	{
			qui setx diff`shockvar' 0 				
			qui setx lag`shockvar' (`vs')
		}	
	}							
																			
	else  {									// just double check everything is 0
		if "`shockvar3'" != "" {			// pre-shock
			qui setx diff`shockvar3' 0	
			qui setx diff`shockvar2' 0	
			qui setx diff`shockvar' 0
		}										
		else if "`shockvar2'" !="" {
			qui setx diff`shockvar2' 0	
			qui setx diff`shockvar' 0
		}
		else	{
			qui setx diff`shockvar' 0	
		}
	}
																			
	forv m = 1/3 {							// set dummies on if applicable
		if "`dummy`m''" !="" {												
			setx `dummy`m'' 0						
		}																	
		if "`dumstart`m''" !="" {												
			setx `dummy`m'' 1 if `i' >= `dumstart`m'' & `i' < `dumend`m'' 	
		}	
	}	
		
	qui setx D* 0							// dbl-check diff. vars are at 0
	
	simqi, ev genev(td1log`i' td2log`i' )	// generate new predictions
	qui gen t1log`i' = m1 + td1log`i'		// add them to the old predictions
	qui gen t2log`i' = m2 + td2log`i'
	qui su t1log`i' , meanonly
	qui scalar m1 = r(mean)
	qui su t2log`i' , meanonly
	qui scalar m2 = r(mean)
}			

* ------------------------Un-Transform--------------------------------------
qui forv i = 1/20 {						// the first two are the dependent vars	
										// we operated on earlier
	gen vara_pie`i' = exp(t1log`i')/(1+(exp(t1log`i'))+(exp(t2log`i'))) 
	gen varb_pie`i' = exp(t2log`i')/(1+(exp(t1log`i'))+(exp(t2log`i')) )
	gen varc_pie`i' = 1/(1+(exp(t1log`i'))+(exp(t2log`i')))
	* the last is our baseline
}

qui forv i = 1/20 {						// Grab the 90% CI for each DV
	foreach N in vara varb varc {
		_pctile `N'_pie`i', p(`sigl',`sigu')
		gen `N'_pie_p5_`i' = r(r1)
		gen `N'_pie_p95_`i' = r(r2)
	}
}
	
* ------------------------Graphing-------------------------------------------
keep vara_pie_* varb_pie_* varc_pie_* 
egen count = fill(1 2)
qui drop if count > 1
	
	qui reshape long vara_pie_p5_ vara_pie_p95_ varb_pie_p5_			///
	varb_pie_p95_ varc_pie_p5_ varc_pie_p95_, j(time) i(count)
	
	gen mida = (vara_pie_p5_ + vara_pie_p95_)/2
	gen midb = (varb_pie_p5_ + varb_pie_p95_)/2
	gen midc = (varc_pie_p5_ + varc_pie_p95_)/2
 
	twoway rspike vara_pie_p5_ vara_pie_p95_ time , lpattern(solid)		///
	lwidth(thin) lcolor("black") || rspike varb_pie_p5_ 			///
	varb_pie_p95_ time, lpattern(solid) lcolor("gs5") 			///
	lwidth(thin) || rspike varc_pie_p5_  varc_pie_p95_ time,			///
	lpattern(solid) lcolor("gs8") lwidth(thin) || scatter mida	///
	time, msymbol(o)  mcolor("black") || scatter midb time,			///
	msymbol(x)  mcolor("gs5") || scatter midc time, symbol(d)	///
	mcolor("gs8") graphregion( color(white) )  legend( order(		///
	4 "Conservatives" 5 "Lib-Dems" 6 "Labour"  ) rows(1)) 				///
	xtitle("Month")	ytitle("Predicted Proportion of Support")	///
	note("95% confidence intervals shown")
			
restore

end
* --------------------------------------------------------------------------

* increase in Labour being best for the economy:	---------------------
dynsimpie all_pidW all_LabLeaderEval_W all_ConLeaderEval_W ///
all_LDLeaderEval_W all_nat_retW ,  ///
dvs(Con_Lab lDM_Lab) t(9) shock(0.054) ///
shockvar(all_b_mii_lab_pct) sig(95)

* increase in average Labour leader evaluation:	---------------------
dynsimpie all_pidW all_ConLeaderEval_W ///
all_nat_retW all_LDLeaderEval_W all_b_mii_lab_pct,  ///
dvs(Con_Lab lDM_Lab) t(9) shock(0.366) ///
shockvar(all_LabLeaderEval_W) sig(95)

* increase in average LibDem leader evaluation:	---------------------
dynsimpie all_pidW all_LabLeaderEval_W all_ConLeaderEval_W ///
all_b_mii_lab_pct all_nat_retW,  ///
dvs(Con_Lab lDM_Lab) t(9) shock(0.412) ///
shockvar(all_LDLeaderEval_W)  sig(95)

* SI Fig 3: decrease in Labour as best manager of most important issue, all of
* which goes to conservatives
dynsimpie all_pidW all_ConLeaderEval_W ///
all_LDLeaderEval_W all_nat_retW all_LabLeaderEval_W,  ///
dvs(Con_Lab lDM_Lab) t(9) shock(-0.054) ///
shockvar(all_b_mii_lab_pct) shockvar2(all_b_mii_con_pct) shock2(0.054) ///
sig(95)

* SI Fig 4: 3 shocks...labours loss goes 2/3 cons 1/3 lib dems:
dynsimpie all_pidW all_LabLeaderEval_W all_nat_retW all_ConLeaderEval_W ///
all_LDLeaderEval_W  , dvs(Con_Lab lDM_Lab) t(9) shock(-0.054) ///
shockvar(all_b_mii_lab_pct) shockvar2(all_b_mii_ldm_pct) shock2(0.018) ///
shockvar3(all_b_mii_con_pct) shock3(.036) sig(95)













