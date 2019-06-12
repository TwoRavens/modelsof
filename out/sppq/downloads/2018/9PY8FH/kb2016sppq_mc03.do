version 12.1
set more off
  quietly log
  local logon = r(status)
  if "`logon'" == "on" { 
	log close 
	}
log using kb2016sppq_mc03.log, text replace

/* *************************************************************      */
/*  File Name:  kb2016sppq_mc03.do                                    */
/*  Authors:    Rebecca Kreitzer and Frederick J. Boehmke             */
/*  Date:       February 22, 2018                                     */
/*  Purpose:    Monte carlo of Pooled Event History Analysis models   */
/*              for Kreitzer and Boehmke, SPPQ, 2016. This runs the   */
/*              monte carlo with bimodal random effects, reported     */
/*              in Figures 7 and 8 and Table 4.                       */
/*  Input:      kb2016sppq_mc_indvars.dta                             */
/*  Output:     kb2016sppq_mc03.log,                                  */
/*              kb2016sppq_mc03.dta,                                  */
/*              kb2016sppq_mc03-XXX.gph                               */
/*  Programs:   grc1leg.ado                                            */
/* *************************************************************      */

	/********************************/
	/* Set global variables. 	    */
	/********************************/
	

global maxiters 50


	/********************************/
	/* Program for Simulation. 		*/
	/********************************/	
	
 * The program generates error, creates dependent variable, runs models, saves scalars
 
program drop _all

program define pehasim, rclass

	syntax, indvars(string) scale(real)
	
	* Generate random effects.

		/* u1 is uniform with mean=0 and sd=1 to match what we had for the normal. */
	
	clear
	set obs 30
	generat u_b0 = (uniform() - 0.5)/sqrt(1/12)
	
	drawnorm u_b1a u_b1b u_b2a u_b2b, means(-2 2 -2 2) sds(1 1 1 1)

		/* Make sure to standardize then set variance to 0.3 to match what we have for the normal. */
		/* Note that Var(u_b1) = Var(u_b1a) + E[u_b1a]^2. */
	
	generat u_b1 = sqrt(0.3)*u_b1a/sqrt(2^2 + 1) if uniform() > 0.5
	replace u_b1 = sqrt(0.3)*u_b1b/sqrt(2^2 + 1) if missing(u_b1)
	
	generat u_b2 = sqrt(0.3)*u_b2a/sqrt(2^2 + 1) if uniform() > 0.5
	replace u_b2 = sqrt(0.3)*u_b2b/sqrt(2^2 + 1) if missing(u_b2)
	
	replace u_b0 = sqrt(`scale')*u_b0
	replace u_b1 = sqrt(`scale')*u_b1
	replace u_b2 = sqrt(`scale')*u_b2
	
	generat policy_num = _n
	
	expand 50

	bysort policy_num: generat stateno = _n
	
	expand 40
	
	bysort policy_num stateno: generat year = 1972 + _n
	generat time = year - 1972
	
	* Now merge with independent variables
	
	merge m:1 stateno year using `indvars', keep(match)
	
	* generate the policy adoption latent variable

	generat adopt = .
	generat adopted = .
	generat ystar = .
	generat nbrs = .
	generat nbrs_lag = .
	
	sort policy_num year stateno
	
	summarize time
	
	* Loop over years to accumulate neighbors' adoptions.

	forvalues t = 1/40 {

	  if `t' == 1 {

	    quietly {
	  
		replace ystar = (-4 + u_b0) + (0.5 + u_b1)*berry_norm + (1 + u_b2)*medincome_norm + logit(uniform()) if time == `t'

		replace adopt = 1 if ystar > 0 & time == `t'
		replace adopt = 0 if ystar <=0 & time == `t'

		replace adopted = 1 if adopt == 1 & time == `t'
		replace adopted = 0 if adopt == 0 & time == `t'

		nbrscode adopted, generate(nbrs) sortorder(policy_num year stateno) replace
		
		}
		
		}
	  
	  if `t' > 1 {

	    quietly {
	  
		replace nbrs_lag = nbrs[_n-50] if stateno==stateno[_n-50] & policy_num==policy_num[_n-50] & time == `t'
	
		replace ystar = (-4 + u_b0) + (0.5 + u_b1)*berry_norm + (1 + u_b2)*medincome_norm + 0.25*nbrs_lag + logit(uniform()) if time == `t'

		replace adopt = 1 if (adopt[_n-50] == 1 | ystar > 0) & time == `t'
		replace adopt = 0 if ystar <=0 & time == `t'

		replace adopted = 1 if (adopted[_n-50] == 1 | adopt == 1) & time == `t'
		replace adopted = 0 if adopt == 0 & adopted[_n-50] == 0 & time == `t'

		nbrscode adopted, generate(nbrs) sortorder(policy_num year stateno) replace
		
		}
		
		}
	  
	  }

	sort policy_num stateno year
	
	* format DV *
	
		* first year any state adopted a policy
		bysort policy_num: generat adopt_years = year if adopt==1
		egen adopt_t1 = min(adopt_years), by(policy_num)
		
		* first year state x adopted policy
		egen stadopt_t1 = min(adopt_years), by(policy_num stateno)
		
		* get rid of the policies before the start of the risk set
		bysort policy_num: replace adopt = . if year < adopt_t1
		
		* get rid of policies adopted after first adoption
		bysort policy_num stateno: replace adopt = . if year > stadopt_t1
	
	* create variable for how many states have adopted a policy
	
	egen diffused = sum(adopt), by(policy_num)
		sum diffused
		tab diffused
				
	/********************************/
	/* Run Models, Store Results. 	*/
	/********************************/	
	
	* M1: an uncorrected PEHA, that doesn't account for group correlation or heterog effects
	
	logit adopt berry_norm medincome_norm nbrs_lag time 
	
	  scalar b_0_log 		= 	_b[_cons]
	  scalar b_x1_log 		= 	_b[berry_norm]
	  scalar b_x2_log 		= 	_b[medincome_norm]
	  scalar b_nb_log 		= 	_b[nbrs_lag]
	  scalar b_ti_log 		= 	_b[time]
	  scalar se_b0_log 		= 	_se[_cons]
	  scalar se_x1_log 		= 	_se[berry_norm]
	  scalar se_x2_log 		= 	_se[medincome_norm]
	  scalar se_nb_log 		= 	_se[nbrs_lag]
	  scalar se_ti_log 		= 	_se[time]
	
	* M2: PEHA with fixed effects to model heterogenerat in effects
	
	capture noisily logit adopt berry_norm medincome_norm nbrs_lag time i.policy, iterate($maxiters)
		  
	  local retcode=_rc
	  
	* Capture values if converges, missing otherwise. 

	 if _rc==0 {
		scalar b_0_fes 		= 	_b[_cons]
		scalar b_x1_fes 	= 	_b[berry_norm]
		scalar b_x2_fes 	= 	_b[medincome_norm]
		scalar b_nb_fes 	= 	_b[nbrs_lag]
		scalar b_ti_fes 	= 	_b[time]
		scalar se_b0_fes 	= 	_se[_cons]
		scalar se_x1_fes 	= 	_se[berry_norm]
		scalar se_x2_fes 	= 	_se[medincome_norm]
		scalar se_nb_fes 	= 	_se[nbrs_lag]
		scalar se_ti_fes 	= 	_se[time]
		}
	  else {	
		scalar b_0_fes 		= 	.
		scalar b_x1_fes 	= 	.
		scalar b_x2_fes 	= 	.
		scalar se_b0_fes 	= 	.
		scalar se_x1_fes 	= 	.
		scalar se_x2_fes 	= 	.
		scalar se_nb_fes 	= 	.
		scalar se_ti_fes 	= 	.
		
		} 	 	
	  
	  scalar iter_fe = e(ic) 	 	
	  
	* M3: PEHA with clustering, group is policy
	
	logit adopt berry_norm medincome_norm nbrs_lag time, cluster(policy_num)
	
	  scalar b_0_clu 		= 	_b[_cons]
	  scalar b_x1_clu 		= 	_b[berry_norm]
	  scalar b_x2_clu 		= 	_b[medincome_norm]
	  scalar b_nb_clu 		= 	_b[nbrs_lag]
	  scalar b_ti_clu 		= 	_b[time]
	  scalar se_b0_clu 		= 	_se[_cons]
	  scalar se_x1_clu 		= 	_se[berry_norm]
	  scalar se_x2_clu 		= 	_se[medincome_norm]
	  scalar se_nb_clu 		= 	_se[nbrs_lag]
	  scalar se_ti_clu 		= 	_se[time]
	
	* M4: PEHA with random effects, group is policy
	
	* Use capture in case it doesn't converge. 

	capture noisily melogit adopt berry_norm medincome_norm nbrs_lag time, iterate($maxiters) || policy_num:
	
	local retcode=_rc
	
	* Capture values if converges, missing otherwise. 

	 if _rc==0 {	
	  scalar b_0_mlm 		= 	_b[_cons]
	  scalar b_x1_mlm 		= 	_b[berry_norm]
	  scalar b_x2_mlm 		= 	_b[medincome_norm]
	  scalar b_nb_mlm 		= 	_b[nbrs_lag]
	  scalar b_ti_mlm 		= 	_b[time]
	  scalar se_b0_mlm 		= 	_se[_cons]
	  scalar se_x1_mlm 		= 	_se[berry_norm]
	  scalar se_x2_mlm 		= 	_se[medincome_norm]
	  scalar se_nb_mlm 		= 	_se[nbrs_lag]
	  scalar se_ti_mlm 		= 	_se[time]
	  
	  matrix B = e(b)
	  scalar tau2_0_mlm		=  	B[1,6]	  
	  }
	else {
	  scalar b_0_mlm 		= 	.
	  scalar b_x1_mlm 		= 	.
	  scalar b_x2_mlm 		= 	.
	  scalar b_nb_mlm 		= 	.
	  scalar b_ti_mlm 		= 	.
	  scalar se_b0_mlm 		= 	.
	  scalar se_x1_mlm 		= 	.
	  scalar se_x2_mlm 		= 	.
	  scalar se_nb_mlm 		= 	.
	  scalar se_ti_mlm 		= 	.
	  scalar tau2_0_mlm		=  	.	  
	  }
	  
	  scalar iter_mlm = e(ic)

	* M5: mlm with random parameters, group is policy and random effect on ideology and income
	
	* Use capture in case it doesn't converge. 

	capture noisily melogit adopt berry_norm medincome_norm nbrs_lag time, iterate($maxiters) || policy_num: berry_norm medincome_norm, cov(independent)
	
	local retcode=_rc
	
	* Capture values if converges, missing otherwise. 

	 if _rc==0 {
	  scalar b_0_mrc 	= 	_b[_cons]
	  scalar b_x1_mrc 	= 	_b[berry_norm]
	  scalar b_x2_mrc 	= 	_b[medincome_norm]
	  scalar b_nb_mrc 	= 	_b[nbrs_lag]
	  scalar b_ti_mrc 	= 	_b[time]
	  scalar se_b0_mrc 	= 	_se[_cons]
	  scalar se_x1_mrc 	= 	_se[berry_norm]
	  scalar se_x2_mrc 	= 	_se[medincome_norm]
	  scalar se_nb_mrc 	= 	_se[nbrs_lag]
	  scalar se_ti_mrc 	= 	_se[time]
	  
	  matrix B = e(b)
	  
	  scalar tau2_0_mrc	=  	B[1,8]	  
	  scalar tau2_1_mrc	=  	B[1,6]	  
	  scalar tau2_2_mrc	=  	B[1,7]	  
	  }
	  
	else {
	  scalar b_0_mrc 	= 	.
	  scalar b_x1_mrc 	= 	.
	  scalar b_x2_mrc 	= 	.
	  scalar b_nb_mrc 	= 	.
	  scalar b_ti_mrc 	= 	.
	  scalar se_b0_mrc 	= 	.
	  scalar se_x1_mrc 	= 	.
	  scalar se_x2_mrc 	= 	.
	  scalar se_nb_mrc 	= 	.
	  scalar se_ti_mrc 	= 	.
	  scalar tau2_0_mrc	=  	.  
	  scalar tau2_1_mrc	=  	.	  
	  scalar tau2_2_mrc	=  	.	 
	  }
	  
	  scalar iter_mrc = e(ic)
	
end

	/********************************/
	/* Simulation.				 	*/
	/********************************/	


clear

save kb2016sppq_mc03, replace emptyok


forvalues scale = 0.5(0.5)2 {

  simulate ///
	scale=(`scale') ///
	b_0_log=b_0_log 	b_x1_log=b_x1_log 	b_x2_log=b_x2_log 	b_nb_log=b_nb_log 	b_ti_log=b_ti_log  ///	
	se_b0_log=se_b0_log 	se_x1_log=se_x1_log 	se_x2_log=se_x2_log	se_nb_log=se_nb_log 	se_ti_log=se_ti_log  ///
	b_0_fes=b_0_fes		b_x1_fes=b_x1_fes 	b_x2_fes=b_x2_fes 	b_nb_fes=b_nb_fes 	b_ti_fes=b_ti_fes  ///		
	se_b0_fes=se_b0_fes 	se_x1_fes=se_x1_fes 	se_x2_fes=se_x2_fes	se_nb_fes=se_nb_fes 	se_ti_fes=se_ti_fes  ///
	b_0_clu=b_0_clu 	b_x1_clu=b_x1_clu 	b_x2_clu=b_x2_clu  	b_nb_clu=b_nb_clu 	b_ti_clu=b_ti_clu  ///	
	se_b0_clu=se_b0_clu 	se_x1_clu=se_x1_clu 	se_x2_clu=se_x2_clu 	se_nb_clu=se_nb_clu 	se_ti_clu=se_ti_clu  ///
	b_0_mlm=b_0_mlm 	b_x1_mlm=b_x1_mlm 	b_x2_mlm=b_x2_mlm  	b_nb_mlm=b_nb_mlm 	b_ti_mlm=b_ti_mlm  ///
	se_b0_mlm=se_b0_mlm 	se_x1_mlm=se_x1_mlm 	se_x2_mlm=se_x2_mlm	se_nb_mlm=se_nb_mlm 	se_ti_mlm=se_ti_mlm  ///
	b_0_mrc=b_0_mrc 	b_x1_mrc=b_x1_mrc 	b_x2_mrc=b_x2_mrc  	b_nb_mrc=b_nb_mrc 	b_ti_mrc=b_ti_mrc  /// 	
	se_b0_mrc=se_b0_mrc 	se_x1_mrc=se_x1_mrc 	se_x2_mrc=se_x2_mrc	se_nb_mrc=se_nb_mrc 	se_ti_mrc=se_ti_mrc ///
	tau2_0_mlm=tau2_0_mlm 	tau2_0_mrc=tau2_0_mrc 	tau2_1_mrc=tau2_1_mrc 	tau2_2_mrc=tau2_2_mrc ///
	iter_fe=iter_fe iter_mlm=iter_mlm iter_mrc=iter_mrc, ///
	reps(500) seed(5563): pehasim, indvars(kb2016sppq_mc_indvars) scale(`scale')

  append using kb2016sppq_mc03
	
  save kb2016sppq_mc03, replace

	
  }

  
	/****************************/
	/* Clean up the results. 	*/
	/****************************/

		/* Calculate convergence rates. */
	
tab1 iter_*, missing

		/* Exclude draws that don't converge. */
		
foreach var of varlist *_fes {

  replace `var' = . if iter_fe == $maxiters
  
  }

foreach var of varlist *_mlm {

  replace `var' = . if iter_mlm == $maxiters
  
  }

foreach var of varlist *_mrc {

  replace `var' = . if iter_mrc == $maxiters
  
  }


	* create new variables
	
generat tau_0_mlm = sqrt(tau2_0_mlm)
generat tau_0_mrc = sqrt(tau2_0_mrc)
generat tau_1_mrc = sqrt(tau2_1_mrc)
generat tau_2_mrc = sqrt(tau2_2_mrc)
  
	* label variables
  summarize

  label variable b_x1_log	"Regression"
  label variable b_x1_fes	"Fixed Effects"
  label variable b_x1_clu	"Clustered"
  label variable b_x1_mlm	"MLM"
  label variable b_x1_mrc	"MLM w/ Rand Coef"
  
  label variable b_x2_log	"Regression"
  label variable b_x2_fes	"Fixed Effects"
  label variable b_x2_clu	"Clustered"
  label variable b_x2_mlm	"MLM"
  label variable b_x2_mrc	"MLM w/ Rand Coef"
  
  label variable b_nb_log	"Regression"
  label variable b_nb_fes	"Fixed Effects"
  label variable b_nb_clu	"Clustered"
  label variable b_nb_mlm	"MLM"
  label variable b_nb_mrc	"MLM w/ Rand Coef"
  
  label variable b_ti_log	"Regression"
  label variable b_ti_fes	"Fixed Effects"
  label variable b_ti_clu	"Clustered"
  label variable b_ti_mlm	"MLM"
  label variable b_ti_mrc	"MLM w/ Rand Coef"
  
  label variable se_x1_log	"Regression"
  label variable se_x1_fes	"Fixed Effects"
  label variable se_x1_clu	"Clustered"
  label variable se_x1_mlm	"MLM"
  label variable se_x1_mrc	"MLM w/ Rand Coef"

  label variable se_x2_log	"Regression"
  label variable se_x2_fes	"Fixed Effects"
  label variable se_x2_clu	"Clustered"
  label variable se_x2_mlm	"MLM"
  label variable se_x2_mrc	"MLM w/ Rand Coef"
  
  label variable se_nb_log	"Regression"
  label variable se_nb_fes	"Fixed Effects"
  label variable se_nb_clu	"Clustered"
  label variable se_nb_mlm	"MLM"
  label variable se_nb_mrc	"MLM w/ Rand Coef"
  
  label variable se_ti_log	"Regression"
  label variable se_ti_fes	"Fixed Effects"
  label variable se_ti_clu	"Clustered"
  label variable se_ti_mlm	"MLM"
  label variable se_ti_mrc	"MLM w/ Rand Coef"
  
  egen scale_b0 = group(scale)
  egen scale_b1 = group(scale)
  egen scale_b2 = group(scale)
  egen scale_bn = group(scale)
  egen scale_bt = group(scale)
  
  label define scale_b1 1 "0.15" 2 "0.30" 3 "0.45" 4 "0.60"
  label values scale_b0-scale_bt scale_b1
   
  label variable scale_b0 	"variance of random intercept"
  label variable scale_b1 	"variance of random coefficient"
  label variable scale_b2 	"variance of random coefficient"
   
  compress
	
  save kb2016sppq_mc03, replace
  
  
	/*************************/
	/* Create density plots. */
	/*************************/
	

twoway kdensity b_x2_log, scheme(s1mono) by(scale_b2, legend(off) note("") title(Income)) subtitle(, fcolor(white)) lcolor(gs0) lpattern(shortdash) 	///
	|| kdensity b_x2_fes, lcolor(gs0) lpattern(longdash)  ///
	|| kdensity b_x2_mlm, lcolor(gs0) lpattern(dash) ///
	|| kdensity b_x2_mrc, lcolor(gs0) lpattern(solid) xline(1) ///
	ylabel(#7, grid) ytitle("") xtitle("") ///
	xsize(3.25) ysize(3) ///
	name(b2_bw, replace) 
	
twoway kdensity b_nb_log, scheme(s1mono) by(scale_bn, note("") title(Neighbors)) subtitle(, fcolor(white)) lcolor(gs0) lpattern(shortdash) 	///
	|| kdensity b_nb_fes, lcolor(gs0) lpattern(longdash)  ///
	|| kdensity b_nb_mlm, lcolor(gs0) lpattern(dash) ///
	|| kdensity b_nb_mrc, lcolor(gs0) lpattern(solid) xline(0.25) ///
	ylabel(#7, grid) ytitle("") xtitle("") ///
	xsize(3.25) ysize(3) ///
	legend(label(1 Logit) label(2 Fixed Effects) label(3 Random Effects) label(4 Random Coeffs.) rows(1) size(small) ) ///
	name(bn_bw, replace)
	
		/* Install grc1leg.ado if needed (-net search grc1leg- at the command prompt). */
	
grc1leg b2_bw bn_bw, scheme(s1mono) ///
	rows(2) ///
	imargin(tiny) ///
	xsize(6.5) ysize(8) ///
	saving(kb2016sppq_mc03-fig07, replace)


	/******************************************/
	/* Now collapse and do SE-SD comparisons. */
	/******************************************/

		
	* square before taking the average. 

foreach var of varlist se_* {

	replace `var' = `var'^2
	
	}

collapse (mean) b_* se_* ///
   (sd) sd_b0_log=b_0_log sd_x1_log=b_x1_log sd_x2_log=b_x2_log sd_nb_log=b_nb_log sd_ti_log=b_ti_log ///
	sd_b0_fes=b_0_fes sd_x1_fes=b_x1_fes sd_x2_fes=b_x2_fes sd_nb_fes=b_nb_fes sd_ti_fes=b_ti_fes ///
	sd_b0_clu=b_0_clu sd_x1_clu=b_x1_clu sd_x2_clu=b_x2_clu sd_nb_clu=b_nb_clu sd_ti_clu=b_ti_clu ///
	sd_b0_mlm=b_0_mlm sd_x1_mlm=b_x1_mlm sd_x2_mlm=b_x2_mlm sd_nb_mlm=b_nb_mlm sd_ti_mlm=b_ti_mlm ///
	sd_b0_mrc=b_0_mrc sd_x1_mrc=b_x1_mrc sd_x2_mrc=b_x2_mrc sd_nb_mrc=b_nb_mrc sd_ti_mrc=b_ti_mrc, by(scale)
	
    * then take square root to compare to sd.
    
foreach var of varlist se_* {

	replace `var' = sqrt(`var')
	
	}
	
	compress
	
	save kb2016sppq_mc03-collapsed, replace
	
		/* Reshape to use -graph bar, over()-. */

keep scale se* sd*

reshape long se_b0_ se_x1_ se_x2_ se_nb_ se_ti_ sd_b0_ sd_x1_ sd_x2_ sd_nb_ sd_ti_ , i(scale) j(model) string

  replace model = "Logit" if model == "log"
  replace model = "Clustered" if model == "clu"
  replace model = "Fixed Effects" if model == "fes"
  replace model = "Random Effects" if model == "mlm"
  replace model = "Random Coeffs. (Ind.)" if model == "mrc"
  replace model = "Random Coeffs." if model == "mru"

graph bar se_x1_ sd_x1_, over(scale) over(model, label(labsize(medsmall))) scheme(s1mono) ///
	bar(1, color(gs2)) /// 
	bar(2, color(gs8)) ///
	title(Coefficient on Ideology) ///
	legend(label(1 Standard Error) label(2 Standard Deviation) size(small)) ///
	xsize(6.5) ysize(3) ///
	name(sesd_b1, replace) 

graph bar se_nb_ sd_nb_, over(scale) over(model, label(labsize(medsmall))) scheme(s1mono) ///
	bar(1, color(gs2)) /// 
	bar(2, color(gs8)) ///
	title(Coefficient on Lagged Neighbors) ///
	legend(label(1 Standard Error) label(2 Standard Deviation) size(small)) ///
	xsize(6.5) ysize(3) ///
	name(sesd_bn, replace) 

grc1leg sesd_b1 sesd_bn, scheme(s1mono) ///
	rows(2) imargin(small) ///
	xsize(6.5) ysize(6) ///
	saving(kb2016sppq_mc03-fig08, replace)
	

	/**********************************/
	/* Make a table for the appendix. */
	/**********************************/

		
use kb2016sppq_mc03-collapsed, clear
  
renvars b*, subst(0 b0)
  
renvars b_*_*, map(substr("@",1,1) + substr("@",5,4) + substr("@",2,3)) 
renvars se_*_*, map(substr("@",1,2) + substr("@",6,4) + substr("@",3,3)) 
renvars sd_*_*, map(substr("@",1,2) + substr("@",6,4) + substr("@",3,3)) 

reshape long b_log_ b_fes_ b_clu_ b_mlm_ b_mrc_ se_log_ se_fes_ se_clu_ se_mlm_ se_mrc_ sd_log_ sd_fes_ sd_clu_ sd_mlm_ sd_mrc_, i(scale) j(variable) string

  sort variable scale
  
  generat c = scale
  
  format %9.4f b_* se_* sd_*
  
  replace variable = "Ideology" if variable == "x2"
  replace variable = "Income" if variable == "x1"
  replace variable = "Intercept" if variable == "b0"
  replace variable = "Time" if variable == "ti"
  replace variable = "Neighbors" if variable == "nb"
	
  outsheet c variable *log* *fes* *clu* *mlm* *mrc* using kb2016sppq_mc03-table04.csv, replace comma
	
clear
log close
exit, STATA
