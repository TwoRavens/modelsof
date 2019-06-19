
clear 
set more off
set memory 8g
set matsize 2000

global RES ""

cap log close

log using $RES\regs_prep_nodemean_limited_meanmpg.txt, t replace

use $RES\startstop2_revised_limited, clear

drop if mpg==.
drop if man==""
drop if year<2003
drop dsfp dsep t1-t4 ptrend*



/*------------------------------------------------*
| Step 1: incentives |
*------------------------------------------------*/

	gen p_mean_r_all = (msrp - meaninc_r)/1000
	gen p_mean_r_all_noenergy = (msrp_noenergy - meaninc_r_noenergy)/1000
	gen p_mean_r_all_real = (msrp_real - meaninc_r_real)/1000

	gen p_max_r_all = (msrp - maxinc_r)/1000

	gen p_mean_n_all = (msrp - meaninc_n)/1000

*****************************************************************************************************
/*-------------------------------------*
| Step 2: operating costs |
*-------------------------------------*/
	* ONLY DO THIS IF YOU'RE USING MEAN MPG
	egen meanmpg=mean(mpg), by(model modelyear date reg)
	drop  mpg
	rename meanmpg mpg

	egen temp1 = mean(dsgp_n)
	egen temp2 = mean(dsfp_n)
	replace dsfp_n = dsfp_n*(temp1/temp2)

	gen oc_r       = dsgp_r / mpg
	gen oc_n       = dsgp_n / mpg

	gen gpmpg_n = dsgp_n*mpg
	gen gpmpg_r = dsgp_r*mpg
********************************************************************************************************

/*------------------------*
| Bringing in the weights |
*------------------------*/

	sort acode date reg
	save $RES\temp0, replace

	/* The do file takes 12 hours to run.  The output is saved, don't call every time */

*	do $RES\regs_weight_revised
*	use $RES\regs_weight_output_segment, clear

*	do $RES\regs_weight_robustness
*	use $RES\regs_weight_output_segment_rmsrppassbasempghp, clear

		drop if reg==.

	merge 1:1 acode date reg using $RES\temp0
		*tab _merge
		*keep if _merge==3
		drop _merge
		sort model modelyear segment date reg
	save $RES\temp0, replace

		use $RES\temp0, clear
	*do $RES\regs_weight_revised_model_meanmpg
	do $RES\regs_weight_revised_model

	use $RES\regs_weight_output_segment_model	
		drop acode
		drop if reg==.
	*merge 1:m model modelyear date reg $RES\temp0
		*drop _merge
	merge 1:m model modelyear segment date reg using $RES\temp0
		drop _merge
		sort model modelyear date reg
	save $RES\temp0, replace


/*-----------------------------------------------------------------------------------*
| Step 4: create and demean time dummies, are pull 
| in the pre-created dataset.  Re-do the time dummies
| for every sample change!
*-------------------------------------------------------------------------------------*/

	
	gen reg1 = reg==1
	gen reg2 = reg==2
	gen reg3 = reg==3
	gen reg4 = reg==4
	gen reg5 = reg==5



	***** Creating week dummies, pulled out of the above code *****

	sort date acode 
	save $RES\temp1, replace

	save $RES\temp0, replace
		keep date
		duplicates drop
		gen n=1
		replace n = n[_n-1]+1 if _n>1
		capture program drop loopery
		program loopery
			local q=1
			while `q' <= _N {
				gen week`q'= n==`q'
			local q=`q'+1
			}
		end 
		loopery
		drop n
		sort date
	merge date using $RES\temp0
		tab _merge
		drop _merge
		keep acode date week*
		duplicates drop
		sort date acode
		merge date acode using $RES\temp1
			tab _merge
			drop _merge

		compress
	*save $RES\regs_prep_revised_limited_meanmpg, replace
	save $RES\regs_prep_revised_limited, replace
	

/* DIFFERENCES */
	sort reg acode date
	gen dmeaninc_r = meaninc_r-meaninc_r[_n-1] if acode==acode[_n-1]
	gen dmaxinc_r = maxinc_r-maxinc_r[_n-1] if acode==acode[_n-1]
	gen dmean36_r = mean36_r-mean36_r[_n-1] if acode==acode[_n-1]
	gen dmean60_r = mean60_r-mean60_r[_n-1] if acode==acode[_n-1]


	gen dmeaninc_r_noenergy = meaninc_r_noenergy-meaninc_r_noenergy[_n-1] if acode==acode[_n-1]
	gen dmeaninc_r_real = meaninc_r_real-meaninc_r_real[_n-1] if acode==acode[_n-1]
	gen doc_r = oc_r-oc_r[_n-1] if acode==acode[_n-1]

	*gen droc_r = roc_r-roc_r[_n-1] if acode==acode[_n-1]
	*gen dfoc_r = foc_r-foc_r[_n-1] if acode==acode[_n-1]

	
	forvalues l=1/13 {
		gen droc_r_model_`l' = roc_r_model_`l'-roc_r_model_`l'[_n-1] if acode==acode[_n-1]
		gen dfoc_r_model_`l' = foc_r_model_`l'-foc_r_model_`l'[_n-1] if acode==acode[_n-1]
	}
	
	/*
	forvalues i=1/3 {
		gen dtrend`i' = trend`i'-trend`i'[_n-1] if acode==acode[_n-1]
		gen drtrend`i' = rtrend`i'-rtrend`i'[_n-1] if acode==acode[_n-1]
		gen dftrend`i' = ftrend`i'-ftrend`i'[_n-1] if acode==acode[_n-1]
	}
	*/
	
	forvalues l=1/13 { 
		forvalues i=1/3 {
			gen drtrend`i'_model_`l' = rtrend`i'_model_`l'-rtrend`i'_model_`l'[_n-1] if acode==acode[_n-1]
			gen dftrend`i'_model_`l' = ftrend`i'_model_`l'-ftrend`i'_model_`l'[_n-1] if acode==acode[_n-1]
		}
	}
	
	
	forvalues i=1/208 {
		gen dweek`i' = week`i'-week`i'[_n-1] if acode==acode[_n-1]
	}
	gen dweek = week-week[_n-1] if acode== acode[_n-1]
	
	
/* GENERATE LAGS */
	sort reg acode date

	forvalues i=1/4 {
		gen lag`i'doc_r = doc_r[_n-`i'] if acode ==acode[_n-`i'] & reg==reg[_n-`i']
		gen lag`i'droc_r = droc_r[_n-`i'] if acode ==acode[_n-`i'] & reg==reg[_n-`i']
		gen lag`i'dfoc_r = dfoc_r[_n-`i'] if acode ==acode[_n-`i'] & reg==reg[_n-`i']
	}
	
	forvalues l=1/13 {
		forvalues i=1/4 {
			gen lag`i'droc_r_model_`l' = droc_r_model_`l'[_n-`i'] if acode ==acode[_n-`i'] & reg==reg[_n-`i']
			gen lag`i'dfoc_r_model_`l' = dfoc_r_model_`l'[_n-`i'] if acode ==acode[_n-`i'] & reg==reg[_n-`i']
		}
	}
	
	sort reg acode date
	forvalues i=1/4 {
		gen lag`i'oc_r = oc_r[_n-`i'] if acode==acode[_n-`i']
			gen lag`i'roc_r = roc_r[_n-`i'] if acode==acode[_n-`i']
			gen lag`i'foc_r = foc_r[_n-`i'] if acode==acode[_n-`i']
		gen lag`i'meaninc_r = meaninc_r[_n-`i'] if acode==acode[_n-`i']
	}
	sort reg acode date
	forvalues i=1/4 {
		forvalues l=1/13 {
			gen lag`i'roc_r_model_`l' = roc_r_model_`l'[_n-`i'] if acode==acode[_n-`i']
			gen lag`i'foc_r_model_`l' = foc_r_model_`l'[_n-`i'] if acode==acode[_n-`i']
		}
	}
	
	/* select is whether the incentive changes in the current week */
	gen select = (dmeaninc_r_real!=0 & dmeaninc_r_real!=.)
	gen select2 = (dmeaninc_r!=0 & dmeaninc_r!=.)
/* depvar_real is the change in incentive only if the incentive chages */
	gen depvar_real = dmeaninc_r_real if abs(dmeaninc_r_real)>0 & dmeaninc_r_real!=.
	gen depvar = dmeaninc_r if abs(dmeaninc_r)>0 & dmeaninc_r!=.
	gen depvar_max = dmaxinc_r if abs(dmaxinc_r)>0 & dmaxinc_r!=.
	gen depvar_mean36 = dmean36_r if abs(dmean36_r)>0 & dmean36_r!=.
	gen depvar_mean60 = dmean60_r if abs(dmean60_r)>0 & dmean60_r!=.

/* sumselect will be the number of weeks since the incentive was last changed */
	gen sumselect = 0
	replace sumselect = 1 if select[_n-1] == 1
	replace sumselect = sumselect[_n-1]+1 if sumselect==0

/* figure out which acode is the minimum MSRP in the set of same model modelyear */

	egen minmsrp = min(msrp), by( model modelyear reg date)
	gen tagminmsrp = (minmsrp==msrp)
	egen test = sum(tagminmsrp), by(model modelyear reg date)
	tab test
	egen pickmin = tag(model modelyear reg date tagminmsrp)
	replace pickmin = 0 if tagminmsrp==0

	sort reg acode date
	gen lag1oneending = oneending[_n-1] if acode==acode[_n-1]
	gen lag2oneending = oneending[_n-2] if acode==acode[_n-2]
	gen lead1oneending = oneending[_n+1] if acode==acode[_n+1]
	gen lead2oneending = oneending[_n+2] if acode==acode[_n+2]

	*gen sumselect = sum(select), by(region acode)
	*gen havebefore = (sumselect>0 & sumselect!=.)
	*egen modelid=group(acode)
	*graph twoway (line meaninc_r date if modelid==296 & reg==1), title("Time Path of Incentives for One Model (Pontiac Grand Am)") ytitle(Vehicle Incentive) xtitle(Time)

/* Positive and negative changes in operating costs sometimes enter seperately */	
	gen posdoc_r = max(doc_r,0)
	replace posdoc_r = . if doc_r == .
	gen negdoc_r = min(doc_r,0)
	replace negdoc_r = . if doc_r == .
	forvalues l=1/13 {
		gen posdroc_r_model_`l' = max(droc_r_model_`l',0)
		replace posdroc_r_model_`l' = . if droc_r_model_`l'==.
		gen negdroc_r_model_`l' = min(droc_r_model_`l',0)
		replace negdroc_r_model_`l' = . if droc_r_model_`l'==.
		gen posdfoc_r_model_`l' = max(dfoc_r_model_`l',0)
		replace posdfoc_r_model_`l' = . if dfoc_r_model_`l' == .
		gen negdfoc_r_model_`l' = min(dfoc_r_model_`l',0)
		replace negdfoc_r_model_`l' = . if dfoc_r_model_`l' == .
	}
	gen posdroc_r = max(droc_r,0)
	replace posdroc_r = . if droc_r == .
	gen negdroc_r = min(droc_r,0)
	replace negdroc_r = . if droc_r == .
	gen posdfoc_r = max(dfoc_r,0)
	replace posdfoc_r = . if dfoc_r == .
	gen negdfoc_r = min(dfoc_r,0)	
	replace negdfoc_r = . if dfoc_r == .


/* generating the change in opcost since the last price change*/
	sort reg acode date
	gen chngoc_r = .
	forvalues l=1/13 {
		gen chngroc_r_model_`l' = .
		gen chngfoc_r_model_`l' = .
	}
	forvalues w = 1/208 {
			replace chngoc_r = oc_r-oc_r[_n-`w'] if sumselect==`w'
			forvalues l=1/13 {
				replace chngroc_r_model_`l' = roc_r_model_`l'-roc_r_model_`l'[_n-`w'] if sumselect==`w'
				replace chngfoc_r_model_`l' = foc_r_model_`l'-foc_r_model_`l'[_n-`w'] if sumselect==`w'
			}
	}

		
	gen poschngoc_r = max(chngoc_r,0)
	replace poschngoc_r = . if chngoc_r==.
	gen negchngoc_r = min(chngoc_r,0)
	replace negchngoc_r = . if chngoc_r==.
	
	forvalues l=1/13 {
		gen poschngroc_r_model_`l' = max(chngroc_r_model_`l',0)
		replace poschngroc_r_model_`l' = . if  chngroc_r_model_`l'==.
		gen poschngfoc_r_model_`l' = max(chngfoc_r_model_`l',0)
		replace poschngfoc_r_model_`l' = . if  chngfoc_r_model_`l'==.
		gen negchngroc_r_model_`l' = min(chngroc_r_model_`l',0)
		replace negchngroc_r_model_`l' = . if  chngroc_r_model_`l'==.
		gen negchngfoc_r_model_`l' = min(chngfoc_r_model_`l',0)
		replace negchngfoc_r_model_`l' = . if  chngfoc_r_model_`l'==.
	}
	
	
	sort reg acode date
	gen inclastweek = (meaninc_r[_n-1]>0 & meaninc_r[_n-1]!=.) if acode==acode[_n-1]
	
	compress
	
	save $RES\regs_prep_revised_limited_2011Jan25, replace
	*save $RES\regs_prep_revised_limited_meanmpg, replace




	log close
	erase $RES\temp0.dta
	erase $RES\temp1.dta




