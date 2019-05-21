*	4/23/2015
*
*	Replication file for Philips, Andrew, Amanda Rutherford, and Guy D. Whitten
*	"Dynamic pie: A strategy for modeling trade-offs in compositional variables
*	over time" American Journal of Political Science.
*
*								US RESULTS
*	-------------------------------------------------------------------------

* verify burd is on here for nice graphs
foreach package in scheme-burd  {
		capture which `package'
		if _rc==111 ssc install `package'
 	}
set scheme burd
* findit estsimp		// if user needs to download clarify



use US_AJPS.dta, clear

* tlogit to express our DVs to a common baseline:
tlogit otherpie other_defense incstypie incomescty_defense scsctypie /// 
socscty_defense interestpie interest_defense,base(defensepie)



*						Graphical Simulations
* -------------------------------------------------------------
/* Note: we are still in the testing stages of producing a Stata .ado program
 "dynsimpie: A program to dynamically examine compositional dependent variables.
 Please direct all correspondence regarding this early iteration of the program
 below to Andrew Philips, (aphilips@pols.tamu.edu).	
 
 The US data presented a particular challenge. By default, the program obtains
 sample means for each of the compositions; these become the starting values. 
 We have two dummy variables in the US simulation that are set to 0 throughout, 
 leaving the sample mean compositions to "wander" towards a new equilibrium
 conditional on the values of the dummy variables. The dummy variables 
 contribute to the system since they, unlike the other independent varables, are
 not set to equilibrium values. 
 
 To solve this and create a
 flat baseline, this program iterates out 30 time points (where the baseline is 
 now stable) and then begins the simulation. We are in the testing stages of
 producing a Stata .ado program "dynsimpie_init", to be included with "dynsimpie"
 which will iterate out to find these stable starting values. 
 
 THIS DYNSIMPIE IS FOR 4 SPECIFIED DEPENDENT VARIABLES (I.E. 5 OUTCOMES IN 
	TOTAL INCLUDING THE BASELINE
	
	dvs = dependent compositional variables
	time = time of the shock
	shockvar = the variable you want to shock
	shock = the value of shock
	dummy* = dummy variables
	dumstart* = start of setting dummy to 1
	dumend* = set dummy back to 0
	sig = set significance level for confidence intervals (default = 95)
	
	Dynsimpie must have a varlist as well as dependent variables with tlogit 
	already applied and placed in the dvs() option.  A shockvar, NOT in the
	varlist must be provided, as do shock() and time().  To not shock (i.e. 
	run a baseline model) simply specify shock(0). 11 Dummy variables can be
	specified.  each dummy can be set to 1 for an interval.  Specifying a 
	dummy but not dumstart or dumend sets the dummy to 0.  The time interval
	for the dynamic simulation runs from t=1 to t=20, but iterates out to t=50.
*/


* --------------------------------------------------------------------------
*					US Dynsimpie
* 
* --------------------------------------------------------------------------

capture program drop dynsimpie
capture program define dynsimpie , rclass
syntax [varlist] [if] [in], [ dvs(varlist) shockvar(varname) 	  ///
Time(numlist integer > 1) SHock(numlist)] [dummy1(varname)				  ///
dumstart1(numlist integer >= 1) dumend1(numlist integer >= 2) ] 		  ///
[dummy2(varname) dumstart2(numlist integer >= 1) dumend2(numlist integer  ///
>= 2) ] [dummy3(varname) dumstart3(numlist integer >= 1) dumend3(numlist  ///
integer >= 2) ] [sig(numlist)]
	 	 
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
	
qui gen lag`shockvar' = l.`shockvar'		// same for the shock var	
qui gen diff`shockvar' = d.`shockvar'								

tokenize `dvs'								// do the same for dep vars	

qui gen ddepvard = d.`4'											
qui gen ldepvard = l.`4'
qui gen ddepvarc = d.`3'											
qui gen ldepvarc = l.`3'
qui gen ddepvarb = d.`2'											
qui gen ldepvarb = l.`2'
qui gen ddepvara = d.`1'											
qui gen ldepvara = l.`1'
	
qui gen depvard = `4'						// grab means for later
qui gen depvarc = `3'
qui gen depvarb = `2'
qui gen depvara = `1'
								
* ------------------------Model Estimation--------------------------------------
																
if "`dummy3'" != "" {

	qui sureg (ddepvara ldepvara D* L* lag`shockvar' diff`shockvar' 		///
	`dummy1' `dummy2' `dummy3') (ddepvarb ldepvarb D* L* lag`shockvar' 		///
	diff`shockvar' `dummy1' `dummy2' `dummy3') (ddepvarc ldepvarc D* L* 	///
	lag`shockvar' diff`shockvar' `dummy1' `dummy2' `dummy3') (ddepvard 		///
	ldepvard D* L* lag`shockvar' diff`shockvar' `dummy1' `dummy2' `dummy3')
	keep if e(sample)					// we only want to calculate in-sample
	
	estsimp sureg (ddepvara ldepvara D* L* lag`shockvar' diff`shockvar' 	///
	`dummy1' `dummy2' `dummy3') (ddepvarb ldepvarb D* L* lag`shockvar' 		///
	diff`shockvar' `dummy1' `dummy2' `dummy3') (ddepvarc ldepvarc D* L* 	///
	lag`shockvar' diff`shockvar' `dummy1' `dummy2' `dummy3') (ddepvard 		///
	ldepvard D* L* lag`shockvar' diff`shockvar' `dummy1' `dummy2' `dummy3'  ///
	), corr			
}																		

else if "`dummy2'" != "" {

	qui sureg (ddepvara ldepvara D* L* lag`shockvar' diff`shockvar' 	 	 ///
	`dummy1' `dummy2') (ddepvarb ldepvarb D* L* lag`shockvar' diff`shockvar' ///
	`dummy1' `dummy2') (ddepvarc ldepvarc D* L* lag`shockvar' diff`shockvar' ///
	`dummy1' `dummy2') (ddepvard ldepvard D* L* lag`shockvar' diff`shockvar' ///
	`dummy1' `dummy2' )
	keep if e(sample)

	estsimp sureg (ddepvara ldepvara D* L* lag`shockvar' diff`shockvar' 	 ///
	`dummy1' `dummy2') (ddepvarb ldepvarb D* L* lag`shockvar' diff`shockvar' ///
	`dummy1' `dummy2') (ddepvarc ldepvarc D* L* lag`shockvar' diff`shockvar' ///
	`dummy1' `dummy2') (ddepvard ldepvard D* L* lag`shockvar' diff`shockvar' ///
	`dummy1' `dummy2' ), corr							
}																		

else if "`dummy1'" != "" {

	qui sureg (ddepvara ldepvara D* L* lag`shockvar' diff`shockvar' 		///
	`dummy1' ) (ddepvarb ldepvarb D* L* lag`shockvar' diff`shockvar' 		///
	`dummy1' ) (ddepvarc ldepvarc D* L* lag`shockvar' diff`shockvar' 		///
	`dummy1' ) (ddepvard ldepvard D* L* lag`shockvar' diff`shockvar' 		///
	`dummy1' )
	keep if e(sample) 

	estsimp sureg (ddepvara ldepvara D* L* lag`shockvar' diff`shockvar' 	///
	`dummy1' ) (ddepvarb ldepvarb D* L* lag`shockvar' diff`shockvar' 		///
	`dummy1' ) (ddepvarc ldepvarc D* L* lag`shockvar' diff`shockvar' 		///
	`dummy1' ) (ddepvard ldepvard D* L* lag`shockvar' diff`shockvar' 		///
	`dummy1' ), corr 
}																		

else {

	qui sureg (ddepvara ldepvara D* L* lag`shockvar' diff`shockvar') 		///
	(ddepvarb ldepvarb D* L* lag`shockvar' diff`shockvar'  ) (ddepvarc		///
	ldepvarc D* L* lag`shockvar' diff`shockvar' ) (ddepvard ldepvard D* L*	///
	lag`shockvar' diff`shockvar')
	keep if e(sample)

	estsimp sureg (ddepvara ldepvara D* L* lag`shockvar' diff`shockvar') 	///
	(ddepvarb ldepvarb D* L* lag`shockvar' diff`shockvar'  ) (ddepvarc		///
	ldepvarc D* L* lag`shockvar' diff`shockvar' ) (ddepvard ldepvard D* L*	///
	lag`shockvar' diff`shockvar'), corr 
}

* ------------------------Scalars and setx--------------------------------------
qui setx mean				// cover our bases and set everything to its mean:	
																		
qui su lag`shockvar', meanonly				// scalars for lagged shock values	
local sv = r(mean) 													
local vs = `sv' + `shock'	
    												
qui setx diff`shockvar' 0					// set differenced shock to 0	
qui setx lag`shockvar' mean					// set lagged shock to mean	

qui su depvara, meanonly					// setting lagged DVs to means
qui scalar m1 = r(mean) 
qui setx ldepvara m1

qui su depvarb, meanonly
qui scalar m2 = r(mean) 
qui setx ldepvarb m2

qui su depvarc, meanonly
qui scalar m3 = r(mean) 
qui setx ldepvarc m3 

qui su depvard, meanonly
qui scalar m4 = r(mean)
qui setx ldepvard m4
								
qui setx D* 0								// set diff indep. vars to 0
	
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

* ------------------------Predict Values--------------------------------------

qui simqi, ev genev(td1log1 td2log1 td3log1 td4log1) // grab expected values
								
qui su depvara  
qui scalar m1 = r(mean) 				// generate our expected value 
gen t1log1 = m1 + td1log1 				// and add on the past value
	
qui su depvarb
qui scalar m2 = r(mean)
gen t2log1 = m2 + td2log1											
	
qui su depvarc
qui scalar m3 = r(mean)
gen t3log1 = m3  + td3log1	
	
qui su depvard
qui scalar m4 = r(mean)
gen t4log1 = m4 + td4log1									
	
qui su t1log1, meanonly					// these scalars become the new LDV	
qui scalar m1 = r(mean)												
qui su t2log1, meanonly												
qui scalar m2 = r(mean)												
qui su t3log1, meanonly												
qui scalar m3 = r(mean)	
qui su t4log1, meanonly
qui scalar m4 = r(mean)											

* ------------------------Loop Through Time------------------------------------
local time2 = `time' + 30 	
nois _dots 0, title(Simulation in Progress) reps(20)
qui forvalues i = 2/50 {													 
	noi _dots `i'  0	
	
	qui setx ldepvara m1 ldepvarb m2 ldepvarc m3 ldepvard m4 
										// set the new value of LDV

	if `i' == `time2' { 		 			// at t we experience the shock	
		qui setx diff`shockvar' `shock'	// shock affects diff at time t only	
	}	
	
	else if `i' > `time2' {												
		qui setx diff`shockvar' 0 		// diff shock back to 0	
		qui setx lag`shockvar' (`vs')	// lag shock now at new value
	}																	

	else  {								// just double check everything is 0
		qui setx diff`shockvar' 0		// pre-shock	
	}
																		
	forv m = 1/3 {						// set dummies on if applicable
		if "`dummy`m''" !="" {												
			setx `dummy`m'' 0						
		}																	
		if "`dumstart`m''" !="" {												
			setx `dummy`m'' 1 if `i' >= `dumstart`m'' & `i' < `dumend`m'' 	
		}	
	}
			
	qui setx D* 0						// dbl-check diff. vars are at 0
	
	simqi, ev genev(td1log`i' td2log`i' td3log`i' td4log`i') // new predictions
	qui gen t1log`i' = m1 + td1log`i' 	// add them to old predictions
	qui gen t2log`i' = m2 + td2log`i'
	qui gen t3log`i' = m3 + td3log`i'
	qui gen t4log`i' = m4 + td4log`i'
	qui su t1log`i' , meanonly
	qui scalar m1 = r(mean)
	qui su t2log`i' , meanonly
	qui scalar m2 = r(mean)
	qui su t3log`i' , meanonly
	qui scalar m3 = r(mean) 
	qui su t4log`i', meanonly
	qui scalar m4 = r(mean)	
}

* ------------------------Un-Transform--------------------------------------
qui forv i = 1/50 {			// the first 4 are the dependent vars from earlier
	gen vara_pie`i' = (exp(t1log`i'))/(1+(exp(t1log`i'))+(exp(t2log`i'))+	///
	(exp(t3log`i'))+(exp(t4log`i')))
	gen varb_pie`i' = (exp(t2log`i'))/(1+(exp(t1log`i'))+(exp(t2log`i'))+	///
	(exp(t3log`i'))+(exp(t4log`i')))
	gen varc_pie`i' = (exp(t3log`i'))/(1+(exp(t1log`i'))+(exp(t2log`i'))+	///
	(exp(t3log`i'))+(exp(t4log`i')))
	gen vard_pie`i' = (exp(t4log`i'))/(1+(exp(t1log`i'))+(exp(t2log`i'))+	///
	(exp(t3log`i'))+(exp(t4log`i')))
	* the last one is our baseline
	gen vare_pie`i' = 1/(1+(exp(t1log`i'))+(exp(t2log`i'))+(exp(t3log`i'))+ ///
	(exp(t4log`i')))
}

qui forv i = 1/50 {						// Grab the 90% CI for each DV
	foreach N in vara varb varc vard vare {
		_pctile `N'_pie`i', p(`sigl',`sigu')
		gen `N'_pie_p5_`i' = r(r1)
		gen `N'_pie_p95_`i' = r(r2)
	}
}
* ------------------------Graphing-------------------------------------------

keep vara_pie_* varb_pie_* varc_pie_* vard_pie_* vare_pie_*
egen count = fill(1 2)
qui drop if count > 1

qui reshape long vara_pie_p5_ vara_pie_p95_ varb_pie_p5_ varb_pie_p95_ 		///
varc_pie_p5_ varc_pie_p95_ vard_pie_p5_ vard_pie_p95_ vare_pie_p5_ 			///
vare_pie_p95_, j(time) i(count)
	 
gen mida = (vara_pie_p5_ + vara_pie_p95_)/2
gen midb = (varb_pie_p5_ + varb_pie_p95_)/2
gen midc = (varc_pie_p5_ + varc_pie_p95_)/2
gen midd = (vard_pie_p5_ + vard_pie_p95_)/2
gen mide = (vare_pie_p5_ + vare_pie_p95_)/2

qui keep if time > 30
qui drop time
qui gen time = _n

twoway rspike vara_pie_p5_ vara_pie_p95_ time, lcolor("black") 		///
lpattern(solid) lwidth(thin)   || rspike  varb_pie_p5_ varb_pie_p95_ time,  ///
lcolor("gs3") lpattern(solid) lwidth(thin)  || rspike varc_pie_p5_  	///
varc_pie_p95_ time, lcolor("gs6") lpattern(solid) lwidth(thin)  ||  ///
rspike vard_pie_p5_ vard_pie_p95_ time, lcolor("gs8") 				///
lpattern(solid) lwidth(thin)  || rspike vare_pie_p5_ vare_pie_p95_ time ,  	///
lcolor("gs11") lpattern(solid) lwidth(thin)  || scatter mida time,  	///
msymbol(o) mcolor("black")  || scatter midb time, msymbol(t)			///
mcolor("gs3") || scatter midc time, msymbol(x) mcolor("gs6") 	///
|| scatter midd time, msymbol(d) mcolor("gs8") || scatter mide time, ///
msymbol(s) mcolor("gs11") graphregion( color(white) )  legend( 		///
order(6 "Other" 7 "Welfare" 8 "Social Security" 9 "Interest Payment" 10		///
"Defense" ) rows(1)) xtitle("Year") ytitle("Predicted Proportion of Budget") ///
note("95% confidence intervals shown")
	
	
restore
end
* --------------------------------------------------------------------------


* 1 std dev decrease in unemployment
dynsimpie aged_dr popgrowth hostlev mood pctgdpchange, ///
dvs(other_defense incomescty_defense socscty_defense interest_defense) t(10) ///
shock(-1.48) shockvar(natunempct) dummy1(demcongress) dummy2(presdem) sig(95)

* 1 std dev decrease in policy mood liberalism
dynsimpie aged_dr popgrowth hostlev pctgdpchange natunempct, ///
dvs(other_defense incomescty_defense socscty_defense interest_defense) t(10) ///
shock(-4.45) shockvar(mood) dummy1(demcongress) dummy2(presdem) sig(95)

* 1 std dev increase in hostilities (MID)
dynsimpie aged_dr popgrowth pctgdpchange natunempct mood,  ///
dvs(other_defense incomescty_defense socscty_defense interest_defense) t(10) ///
shock(5.87) shockvar(hostlev) dummy1(demcongress) dummy2(presdem) sig(95)























