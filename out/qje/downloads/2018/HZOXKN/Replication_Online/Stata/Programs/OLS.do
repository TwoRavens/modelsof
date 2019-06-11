	clear
	clear mata
	set memory 700m
	set more off, perm

	capture log close

	local dirworking  "../IntermediateFiles/"
        local diroutput   "../Output/"
	local diroutputMat   "../../Matlab/Structural/data/"

	use `dirworking'master.dta, clear

        local whereIstarted `c(pwd)'
	cd `diroutput'

	**************************************************
	** Specify Sample Used
	**************************************************
	* Drop all after last meeting = 3/19/2014
	drop if date>mdy(03,19,2014)
	***** Specific Dates to Be Dropped ***************
	* 9/11 and market turmoil in following days
	drop if date>=mdy(09,11,2001) & date<mdy(09,22,2001)
	* Lehman and AIG
	drop if date==mdy(09,15,2008) | date==mdy(09,16,2008)
	* January 3rd, 2001 (missing in TIPS data)
	drop if date==mdy(01,03,2001)
	* Drop early data because of concerns about liquidity of TIPS
	drop if date<mdy(01,01,2000)

	***** Main Choice Of Sample *****
	* Comment to include apex of crisis ("full sample"):
	drop if date>=mdy(07,01,2008) & date<mdy(07,01,2009)
	* Uncomment for pre-crisis sample:
	* drop if date>=mdy(01,01,2008)
	* Comment to include unscheduled meetings:
	replace FOMCused = 0 if unscheduled_all==1

	******************************************************************
	** Set Local Variables: bootstrap number of replications ****
	* reps1 is for everything except the two and three year yields and forwards
	* reps2 is for the 2 and 3 year yields and forwards.
	* (These may need more reps since the sample is shorter for these variables)
	******************************************************************
	local reps1 = 5000
	local reps2 = 5000

	*****************************
	** 1. Preliminaries
	*****************************

	**************************************************
	* Construct Path Factors
	*
	* path_m and path are the first principle component of
	* dffr1 dffr2 dedfutbeg2_m dedfutbeg3 dedfutbeg4
	* path_m is only on meeting dates
	*
	* path_orth_m and path_orth are constructed by first
	* orthogonalizing dffr2 dedfutbeg2_m dedfutbeg3 dedfutbeg4
	* with respect to dffr1 and then taking the first principle
	* component of the resulting four series
	* Again path_orth_m is only defined on meeting dates
	*
	***************************************************
	* 1A. Daily path factor (i.e. first principle component of dffr1 dffr2 dedfutbeg2_m dedfutbeg3 dedfutbeg4 on FOMCused days)
	pca  dffr1 dffr2 dedfutbeg2_m dedfutbeg3 dedfutbeg4 if FOMCused==1
	predict path_m  if FOMCused==1, score
	* Rescale path_m so as to yield 1 when DNY1 is regressed on it
	reg DNY1 path_m if FOMCused==1,  r
	mat scale = e(b)
	replace path_m=path_m*scale[1,1]
	*Extrapolate path factor to nonFOMC days
	regress path_m dffr1 dffr2 dedfutbeg2_m dedfutbeg3 dedfutbeg4 if FOMCused==1, r
	mat coeff = e(b)
	gen path = coeff[1,1]*dffr1+coeff[1,2]*dffr2 +coeff[1,3]*dedfutbeg2_m +coeff[1,4]*dedfutbeg3 +coeff[1,5]*dedfutbeg4 +coeff[1,6]

	* 1B(not used) Daily path factor constructed as in GSS
	* Orthogonalize dffr2 dedfutbeg2_m dedfutbeg3 dedfutbeg4 with respect to dffr1
	foreach varb in dffr2 dedfutbeg2_m dedfutbeg3 dedfutbeg4 {
		reg `varb' dffr1 if FOMCused==1, r
		predict `varb'_inres if FOMCused==1, resid
	}
	*Calculate first principle component of resulting four series
	pca  dffr2_inres dedfutbeg2_m_inres dedfutbeg3_inres dedfutbeg4_inres if FOMCused==1
	predict path_orth_m  if FOMCused==1, score
	* Rescale path_orth
	reg DNY1 dffr1 path_orth_m if FOMCused==1,  r
	mat scale = e(b)
	replace path_orth_m=path_orth_m*scale[1,2]
	*Extrapolation of the meeting-based path factor on the non-meeting dates
	regress path_orth_m dffr1 dffr2 dedfutbeg2_m dedfutbeg3 dedfutbeg4 if FOMCused==1, r
	mat coeff = e(b)
	gen path_orth = coeff[1,1]*dffr1+coeff[1,2]*dffr2 +coeff[1,3]*dedfutbeg2_m +coeff[1,4]*dedfutbeg3 +coeff[1,5]*dedfutbeg4 +coeff[1,6]
	*drop *_inres

	* 2A. Intraday path factor
	pca  dffr1_tick_wide_scaled dffr2_tick_wide_scaled ded2_tick_wide ded3_tick_wide ded4_tick_wide if FOMCused==1
	predict path_intra_wide_m if FOMCused==1, score
	* Rescale path_intra_wide_m so as to yield 1 when DNY1 is regressed on it
	reg DNY1 path_intra_wide_m if FOMCused==1,  r
	mat scale = e(b)
	replace path_intra_wide_m=path_intra_wide_m*scale[1,1]
	*Extrapolate intraday path factor to nonFOMC days
	regress path_intra_wide_m dffr1_tick_wide_scaled dffr2_tick_wide_scaled ded2_tick_wide ded3_tick_wide ded4_tick_wide if FOMCused==1, r
	mat coeff = e(b)
	gen path_intra_wide = coeff[1,1]*dffr1_tick_wide_scaled+coeff[1,2]*dffr2_tick_wide_scaled +coeff[1,3]*ded2_tick_wide +coeff[1,4]*ded3_tick_wide +coeff[1,5]*ded4_tick_wide +coeff[1,6]

	gen dffr1_intra_wide = dffr1_tick_wide_scaled

	save `dirworking'master_path, replace

**************************************************
* Standard Deviation of shocks
**************************************************
use `dirworking'master_path, clear

keep if FOMCused==1

foreach vara in path path_intra_wide dffr1_intra_wide{
	egen sd_`vara'=sd(`vara')
}

collapse sd*

outsheet using Std_Shock.csv, c replace

**************************************************
* Variance decomposition
*
* Run regressions to figure out if path and DNY2
* have unusual variance on FOMC days
**************************************************

use `dirworking'master_path, clear

gen pathsq = path^2
reg pathsq FOMCused i.dayofweek, r
lincom FOMCused-(2.dayofweek+3.dayofweek)/2

gen DNY2sq = DNY2^2
reg DNY2sq FOMCused i.dayofweek, r
lincom FOMCused-(2.dayofweek+3.dayofweek)/2

gen dffr1sq = dffr1^2
reg dffr1sq FOMCused i.dayofweek, r
lincom FOMCused-(2.dayofweek+3.dayofweek)/2

gen DNY3Msq = DNY3M^2
reg DNY3Msq FOMCused i.dayofweek, r
lincom FOMCused-(2.dayofweek+3.dayofweek)/2

drop pathsq DNY2sq dffr1sq DNY3Msq

**************************************************
* Choose Control Sample
*
* nonFOMCused is a dummy for the control sample
**************************************************

* Drop non FOMC days after 01/01/2013, since only missing values for intraday variables then (we use Gurkaynak's data in 2013-2014)
drop if FOMCused==0 & date>=mdy(01,01,2013)
tsset seqdate

* Day before FOMC meetings
*gen nonFOMCused = F.FOMCused if FOMCused!=1
* All non-FOMC Tuesdays
*gen nonFOMCused = 1 if FOMCused!=1 & dayofweek==2
* All non-FOMC Wednesdays
*gen nonFOMCused = 1 if FOMCused!=1 & dayofweek==3
* All non-FOMC Tuesdays and Wednesdays
gen nonFOMCused = 1 if FOMCused!=1 & (dayofweek==2 | dayofweek==3)
* All non-FOMC Tuesdays and Wednesdays that are not unscheduled FOMC meetings
*gen nonFOMCused = 1 if FOMCused!=1 & (dayofweek==2 | dayofweek==3) & unscheduled==0 & isconfcall == 0
* All non-FOMC Mondays, Tuesdays, and Wednesdays
*gen nonFOMCused = 1 if FOMCused!=1 & (dayofweek==1 | dayofweek==2 | dayofweek==3)
* All non-FOMC Mondays, Tuesdays, Wednesdays, and Thursdays
*gen nonFOMCused = 1 if FOMCused!=1 & (dayofweek==1 | dayofweek==2 | dayofweek==3 | dayofweek==4)
* All non-FOMC
*gen nonFOMCused = 1 if FOMCused!=1

replace nonFOMCused=0 if nonFOMCused!=1

* Drop unscheduled meeting dates from control sample (this only affects things if we are not using unscheduled meetings)
replace nonFOMCused=0 if unscheduled==1 | isconfcall == 1

* Keep FOMC days and control sample
keep if FOMCused==1 | nonFOMCused==1

tab FOMCused
* What are the new observations after the update?
tab FOMCused if date>mdy(01,25,2012)
list date_daily if FOMCused //& date>mdy(01,25,2012)
list date_daily

*list date FOMCused path path_orth DRF3 DNF3 if abs(path)>0.15
*list date FOMCused path path_orth DRF3 DNF3 if date==mdy(08,14,2007) | date==mdy(08,22,2007)
*graph twoway (scatter DRF3 path) if nonFOMCused==1

**************************************************
* Drop DNY2, DNY3, DNF2, and DNF3 before 2004
* so as to harmonize sample relative to
* DRY2, DRY3, DRF2, and DRF3
**************************************************

gen DNY2_long = DNY2

foreach var in DNY2 DNY3 DNF2 DNF3 ///
			   Dn2y_neut Dn3y_neut Dr2y_neut Dr3y_neut ///
               Dn2y_prem Dn3y_prem Dr2y_prem Dr3y_prem ///
			   Dr2y_liq Dr3y_liq ///
			   Dn2f_neut Dn3f_neut Dr2f_neut Dr3f_neut ///
               Dn2f_prem Dn3f_prem Dr2f_prem Dr3f_prem ///
			   Dr2f_liq Dr3f_liq ///
			   Dn2y_kw Dn3y_kw ///
			   Dn2y_neut_kw Dn3y_neut_kw ///
			   Dn2y_prem_kw Dn3y_prem_kw ///
			   Dn2f_kw Dn3f_kw ///
			   Dn2f_neut_kw Dn3f_neut_kw ///
			   Dn2f_prem_kw Dn3f_prem_kw {
	replace `var' = . if date<mdy(1,1,2004)
}

**************************************************
* Create Difference between raw changes and
* risk neutral changes from Abrahams et al. (2013)
**************************************************

foreach num in 2 3 5 10 {
	gen Dn`num'y_other = DNY`num' - Dn`num'y_neut
	gen Dn`num'f_other = DNF`num' - Dn`num'f_neut
	gen Dr`num'y_other = DRY`num' - Dr`num'y_neut
	gen Dr`num'f_other = DRF`num' - Dr`num'f_neut

}

**************************************************
* Create Stratification Variable
*
* For most variables we stratify the bootstrap resampling by FOMCused.
* For the short real rates (RY2, RY3, RF2, and RF3) we, however, need
* to take account of the fact that these assests are missing before 2004.
* We therefore create three strata (pre-2004, post-2004/FOMCused,
* post-2004/nonFOMCused). This implies that we always get the same
* number of non-missing observations in each sample drawn in the bootstrap.
**************************************************

gen stratRF3 = 0 if date<mdy(1,1,2004)
replace stratRF3 = 1 if date>=mdy(1,1,2004) & FOMCused==1
replace stratRF3 = 2 if date>=mdy(1,1,2004) & FOMCused==0

* Same deal for Inflation swaps except usable sample starts in 2005
gen stratInfSw = 0 if date<mdy(1,1,2005)
replace stratInfSw = 1 if date>=mdy(1,1,2005) & FOMCused==1
replace stratInfSw = 2 if date>=mdy(1,1,2005) & FOMCused==0

**************************************************
* Export Data to Excel for use in Matlab
**************************************************
outsheet year month day FOMCused DNY3M DNY6M DNY1 DNY2 DNY3 DNY5 DNY10 DNF1 DNF2 DNF3 DNF5 DNF10 ///
         DRY2 DRY3 DRY5 DRY10 DRF2 DRF3 DRF5 DRF10 stratRF3 Dlsp500 Dbkeveny2 Dbkeveny3 Dbkeveny5 Dbkeveny10 ///
         dffr1_tick_wide_scaled dffr2_tick_wide_scaled ded2_tick_wide ded3_tick_wide ded4_tick_wide ///
         DIF2 DIF3 DIF5 DIF10 ///
         using "`diroutputMat'dataForMatlabTick.csv", comma replace

outsheet year month day FOMCused DNY3M DNY6M DNY1 DNY2 DNY3 DNY5 DNY10 DNF1 DNF2 DNF3 DNF5 DNF10 ///
         DRY2 DRY3 DRY5 DRY10 DRF2 DRF3 DRF5 DRF10 stratRF3 Dlsp500 Dbkeveny2 Dbkeveny3 Dbkeveny5 Dbkeveny10 ///
         dffr1 dffr2 dedfutbeg2_m dedfutbeg3 dedfutbeg4 ///
         using "`diroutputMat'dataForMatlabDaily.csv", comma replace

outsheet date year FOMCused dffr1_tick_wide_scaled dffr2_tick_wide_scaled ///
         ded2_tick_wide ded3_tick_wide ded4_tick_wide ///
	 path path_intra_wide dffr1_intra dffr1_intra_wide DNY2_long ///
         DNY3M DNY6M DNY1 DNY2 DNY3 DNY5 DNY10 DNF1 DNF2 DNF3 DNF5 DNF10   ///
	 DRY2 DRY3 DRY5 DRY10 DRF2 DRF3 DRF5 DRF10 path_m stratRF3 ///
         Dbkeveny2 Dbkeveny3 Dbkeveny5 Dbkeveny10 DIF2 DIF3 DIF5 DIF10 ///
         using `dirworking'dataForMatlabAltEstTick.csv, comma replace
**************************************************
* 2. OLS
*
* Outer foreach loop can loop over different
* independent variables such as:
* path path_intra_wide dffr1_intra_wide DNY2_long
**************************************************

foreach vara in path_intra_wide dffr1_intra_wide path DNY2{
	*
	reg dffr1 `vara' if FOMCused==1, r
	outreg2 using OLS_`vara'_Y_forexcel, excel replace stats(coef, se, ci) dec(2) label noaster
	foreach varb in dffr2 dedfutbeg2_m dedfutbeg3 dedfutbeg4 DNY3M DNY6M DNY1 DNY2 DNY3 DNY5 DNY10 DRY2 DRY3 DRY5 DRY10 Dbkeveny2 Dbkeveny3 Dbkeveny5 Dbkeveny10 {
		reg `varb' `vara' if FOMCused==1, r
		outreg2 using OLS_`vara'_Y_forexcel, excel append stats(coef, se, ci) dec(2) label noaster 
	}
	reg DNF2 `vara' if FOMCused==1, r
	outreg2 using OLS_`vara'_F_forexcel, excel replace stats(coef, se, ci) dec(2) label noaster 
	foreach varb in DNF3 DNF5 DNF10 DRF2 DRF3 DRF5 DRF10 DIF2 DIF3 DIF5 DIF10 {
		reg `varb' `vara'  if FOMCused==1, r
		outreg2 using OLS_`vara'_F_forexcel, excel append stats(coef, se, ci) dec(2) label noaster 
	}
	*/
	*
	reg DNY2 `vara' if FOMCused==1, r
	outreg2 using OLS_`vara'_table2_forexcel, excel replace stats(coef, se) dec(2) label noaster
	foreach varb in DNF2 DNF3 DNF5 DNF10 DRY2 DRF2 DRF3 DRF5 DRF10 {
		reg `varb' `vara'  if FOMCused==1, r
		outreg2 using OLS_`vara'_table2_forexcel, excel append stats(coef, se) dec(2) label noaster
	}
	*/
	* In these regressions we drop data from 2004 because there are flat periods in the Inflation swap data in 2004
	reg Dbkeveny2 `vara' if FOMCused==1 & year >=2005 & date_daily <= mdy(11,14,2012), r
	outreg2 using OLS_`vara'_I_forexcel, excel replace stats(coef, se) dec(2) label noaster
	foreach varb in Dbkeveny3 Dbkeveny5 Dbkeveny10 Dusswit2 Dusswit3 Dusswit5 Dusswit10 DRY2 DRY3 DRY5 DRY10 DRY2_2 DRY3_2 DRY5_2 DRY10_2 {
		reg `varb' `vara'  if FOMCused==1 & year >=2005 & date_daily <= mdy(11,14,2012), r
		outreg2 using OLS_`vara'_I_forexcel, excel append stats(coef, se) dec(2) label noaster
	}

	*SP500 and VIX
	reg Dlsp500 `vara' if FOMCused==1, r
	outreg2 using OLS_`vara'_SP_forexcel, excel replace stats(coef, se) dec(2) label noaster
	//5/1/2016: checking SP for path and path_intra_wide for Emi
	reg Dsp500gurkaynak `vara' if FOMCused==1, r
	outreg2 using OLS_`vara'_SP_forexcel, excel append stats(coef, se) dec(2) label noaster
	reg Dlvix `vara' if FOMCused==1, r
	outreg2 using OLS_`vara'_SP_forexcel, excel append stats(coef, se) dec(2) label noaster
	*

	*Decomposition of Yields from Moench Data
	*
	reg Dn2y_neut `vara' if FOMCused==1, r
	outreg2 using OLS_`vara'_Moench_Y_forexcel, excel replace stats(coef, se) dec(2) label noaster
	foreach varb in Dn3y_neut Dn5y_neut Dn10y_neut Dr2y_neut Dr3y_neut Dr5y_neut Dr10y_neut ///
					Dn2y_other Dn3y_other Dn5y_other Dn10y_other Dr2y_other Dr3y_other Dr5y_other Dr10y_other ///
	                Dn2y_prem Dn3y_prem Dn5y_prem Dn10y_prem Dr2y_prem Dr3y_prem Dr5y_prem Dr10y_prem ///
					Dr2y_liq Dr3y_liq Dr5y_liq Dr10y_liq {
		reg `varb' `vara'  if FOMCused==1, r
		outreg2 using OLS_`vara'_Moench_Y_forexcel, excel append stats(coef, se) dec(2) label noaster
	}

	*Decomposition of One-Year Forwards from Moench Data
	reg Dn2f_neut `vara' if FOMCused==1, r
	outreg2 using OLS_`vara'_Moench_F_forexcel, excel replace stats(coef, se) dec(2) label noaster
	foreach varb in Dn3f_neut Dn5f_neut Dn10f_neut Dr2f_neut Dr3f_neut Dr5f_neut Dr10f_neut ///
					Dn2f_other Dn3f_other Dn5f_other Dn10f_other Dr2f_other Dr3f_other Dr5f_other Dr10f_other ///
	                Dn2f_prem Dn3f_prem Dn5f_prem Dn10f_prem Dr2f_prem Dr3f_prem Dr5f_prem Dr10f_prem ///
					Dr2f_liq Dr3f_liq Dr5f_liq Dr10f_liq {
		reg `varb' `vara'  if FOMCused==1, r
		outreg2 using OLS_`vara'_Moench_F_forexcel, excel append stats(coef, se) dec(2) label noaster
	}

	*Decomposition of Yields from Kim-Wright data
	reg Dn2y_neut_kw `vara' if FOMCused==1, r
	outreg2 using OLS_`vara'_KW_Y_forexcel, excel replace stats(coef, se) dec(2) label noaster
	foreach varb in Dn3y_neut_kw Dn5y_neut_kw Dn10y_neut_kw ///
	                Dn2y_prem_kw Dn3y_prem_kw Dn5y_prem_kw Dn10y_prem_kw {
		reg `varb' `vara'  if FOMCused==1, r
		outreg2 using OLS_`vara'_KW_Y_forexcel, excel append stats(coef, se) dec(2) label noaster
	}

	*Decomposition of One-Year Forwards from Kim-Wright data
	reg Dn2f_neut_kw `vara' if FOMCused==1, r
	outreg2 using OLS_`vara'_KW_F_forexcel, excel replace stats(coef, se) dec(2) label noaster
	foreach varb in Dn3f_neut_kw Dn5f_neut_kw Dn10f_neut_kw ///
	                Dn2f_prem_kw Dn3f_prem_kw Dn5f_prem_kw Dn10f_prem_kw {
		reg `varb' `vara'  if FOMCused==1, r
		outreg2 using OLS_`vara'_KW_F_forexcel, excel append stats(coef, se) dec(2) label noaster
	}
  }

**************************************************
* 3. RIGOBON Method
*
* Outer foreach loop can loop over different
* independent variables such as:
* path path_intra_wide dffr1_intra_wide DNY2_long
**************************************************

capture program drop bootRig
program define bootRig, eclass
	args depvarb indepvarb
	* Calculate variance-covariance matrix of path and `depvarb'
	* on FOMC days and control sample
	correlate `indepvarb' `depvarb' if FOMCused==1 , c
	mat omega1 = r(C)
	sca N_omega1 = r(N)
	correlate `indepvarb' `depvarb' if FOMCused!=1, c
	*** Alternative control sample (only works for path_intra) *** (comment line above and uncomment line below)
	*correlate `indepvarb'_early `depvarb' if FOMCused==1, c
	mat omega2 = r(C)
	sca N_omega2 = r(N)
	* Take difference of variance-covariances on FOMC vs. nonFOMC days
	mat omega=omega1-omega2
	* Calculate coefficient of interest (see notes or Rigobon-Sack, 2004)
	sca bPATH = omega[1,2]/omega[1,1]
	*** Alternative estimator *** (comment line above and uncomment line below)
	*sca bPATH = omega[2,2]/omega[1,2]
	tempname bb
	matrix `bb'  = bPATH
	mat colnames `bb'  = Path
	mat list `bb'
	ereturn post `bb'
	ereturn local cmd="bootstrap"
	ereturn local depvar="`depvarb'"
end

set seed 20131108

foreach vara in path_intra_wide {
	/*Perform estimation for yields
	bootstrap _b, strata(FOMCused) reps(`reps1') nowarn:  bootRig dffr1 `vara'
	outreg2 using BootRig_`vara'_Y_forexcel, excel replace stats(coef, se, ci) dec(2) label noaster
	local counter1 = 1
	foreach depvarb in DNY3M DNY6M DNY1 DNY2 DNY3 DNY5 DNY10 DRY2 DRY3 DRY5 DRY10 Dbkeveny2 Dbkeveny3 Dbkeveny5 Dbkeveny10 {
		if `counter1' <= 3 | `counter1' == 6 | `counter1' == 7 | `counter1' == 10 | `counter1' == 11 | `counter1' == 14 | `counter1' == 15  {
			bootstrap _b, strata(FOMCused) reps(`reps1'):  bootRig `depvarb' `vara'
			outreg2 using BootRig_`vara'_Y_forexcel, excel append stats(coef, se, ci) dec(2) label noaster
		}
		else {
			bootstrap _b, strata(stratRF3) reps(`reps2'):  bootRig `depvarb' `vara'
			outreg2 using BootRig_`vara'_Y_forexcel, excel append stats(coef, se, ci) dec(2) label noaster
		}
		local counter1 = `counter1' + 1
	}
	*/
	/*Perform estimation for forwards
	bootstrap _b, strata(stratRF3) reps(`reps2') nowarn:  bootRig DNF2 `vara'
	outreg2 using BootRig_`vara'_F_forexcel, excel replace stats(coef, se, ci) dec(2) label noaster
	local counter1 = 1
	foreach depvarb in DNF3 DNF5 DNF10 DRF2 DRF3 DRF5 DRF10 DIF2 DIF3 DIF5 DIF10 {
		if `counter1' == 1 | `counter1' == 4 | `counter1' == 5 | `counter1' == 8 | `counter1' == 9 {
			bootstrap _b, strata(stratRF3) reps(`reps2'):  bootRig `depvarb' `vara'
			outreg2 using BootRig_`vara'_F_forexcel, excel append stats(coef, se, ci) dec(2) label noaster
		}
		else {
			bootstrap _b, strata(FOMCused) reps(`reps1'):  bootRig `depvarb' `vara'
			outreg2 using BootRig_`vara'_F_forexcel, excel append stats(coef, se, ci) dec(2) label noaster
		}
		local counter1 = `counter1' + 1
	}
	*/
	/* Perform estimation for inflation swaps and break-even inflation
	* In these regressions we drop data from 2004 because there are flat periods in the Inflation swap data in 2004
	bootstrap _b, strata(stratInfSw) reps(`reps2') nowarn:  bootRig Dbkeveny2 `vara' if year>=2005
	outreg2 using BootRig_`vara'_I_forexcel, excel replace stats(coef, se) dec(2) label noaster
	foreach varb in Dbkeveny3 Dbkeveny5 Dbkeveny10 Dusswit2 Dusswit3 Dusswit5 Dusswit10 DRY2 DRY3 DRY5 DRY10 DRY2_2 DRY3_2 DRY5_2 DRY10_2{
		bootstrap _b, strata(stratInfSw) reps(`reps2') nowarn:  bootRig `varb' `vara' if year>=2005
		outreg2 using BootRig_`vara'_I_forexcel, excel append stats(coef, se) dec(2) label noaster
	}
	*/
	/*
	*SP500 and VIX
	bootstrap _b, strata(FOMCused) reps(`reps1') nowarn:  bootRig Dlsp500 `vara'
	outreg2 using BootRig_`vara'_SP_forexcel, excel replace stats(coef, se) dec(2) label noaster
	*
	bootstrap _b, strata(FOMCused) reps(`reps1') nowarn:  bootRig Dlvix `vara'
	outreg2 using BootRig_`vara'_SP_forexcel, excel append stats(coef, se) dec(2) label noaster
	*/
}

****************************************************************
* 4. Assessing Mean Reversion a la Hanson-Stein
****************************************************************

use `dirworking'master_path, replace

sort date
tsset date

* Construct long differences
foreach var in NY1 NY2 NY3 NY5 NY10 NF2 NF3 NF5 NF10 {
	qui foreach k in 1 5 10 20 60 125 250 {
			g D`var'_`k'=`var'[_n+`k'-1]-`var'[_n-1]
	}
}


foreach var in RY2 RY3 RY5 RY10 RF2 RF3 RF5 RF10 {
	qui foreach k in 1 5 10 20 60 125 250 {
			g D`var'_`k'=`var'[_n+`k'-1]-`var'[_n-1]
	}
}

**************************************************
* Drop DNY2, DNY3, DNF2, and DNF3 before 2004
* so as to harmonize sample relative to
* DRY2, DRY3, DRF2, and DRF3
**************************************************
foreach var in DNY2 DNY3 DNF2 DNF3 {
	qui foreach k in 1 5 10 20 60 125 250 {
	replace `var'_`k' = . if date<mdy(1,1,2004)
}
}

save `dirworking'HansonSteinRep_Tick_use.dta, replace

* Run mean reversion regressions for nominal variables (changed to NW standard errors 10/17/2016)
sort date
keep if FOMCused==1
gen time = _n
tsset time

newey DNY2_1 path_intra_wide if FOMCused==1, lag(4)
outreg2 using OLS_`vara'_meanReversion_N_forexcel_NW, excel replace stats(coef, se) dec(2) label noaster

foreach k in 5 10 20 60 125 250{
	newey DNY2_`k' path_intra_wide if FOMCused==1, lag(4)
	outreg2 using OLS_`vara'_meanReversion_N_forexcel_NW, excel append stats(coef, se) dec(2) label noaster
}

foreach var in NY3 NY5 NY10 NF2 NF3 NF5 NF10 {
	foreach k in 1 5 10 20 60 125 250{
		newey D`var'_`k' path_intra_wide if FOMCused==1, lag(4)
		outreg2 using OLS_`vara'_meanReversion_N_forexcel_NW, excel append stats(coef, se) dec(2) label noaster
	}
}

* Run mean reversion neweyions for real variables
newey DRY2_1 path_intra_wide if FOMCused==1, lag(4)
outreg2 using OLS_`vara'_meanReversion_R_forexcel_NW, excel replace stats(coef, se) dec(2) label noaster

foreach k in 5 10 20 60 125 250{
	newey DRY2_`k' path_intra_wide if FOMCused==1, lag(4)
	outreg2 using OLS_`vara'_meanReversion_R_forexcel_NW, excel append stats(coef, se) dec(2) label noaster
}

foreach var in RY3 RY5 RY10 RF2 RF3 RF5 RF10 {
	foreach k in 1 5 10 20 60 125 250{
		newey D`var'_`k' path_intra_wide if FOMCused==1, lag(4)
		outreg2 using OLS_`vara'_meanReversion_R_forexcel_NW, excel append stats(coef, se) dec(2) label noaster
	}
}

*/

cd "`whereIstarted'"
