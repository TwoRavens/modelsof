* THIS BUILT OFF OF regs_main_nate_2011July28.do

clear all
set more off
set matsize 7500

global RES ""

/*-------------------------------------------------*
| Regressions -- FOCUSING NON-VAN MIN-MSRP MODELS. |
*-------------------------------------------------*/

*version 8


cap log close
log using $RES/regs_main_nate_2011July28.txt, t replace

use $RES/regs_prep_revised_limited_2011Jan25, clear

drop if vehicletype=="Van" 
keep if msrp==minmsrp
sort acode region date

	sort region acode date

*	replace maxinc_r = maxinc_r/1000
*	replace meaninc_r = meaninc_r/1000
	
*	replace maxinc_n = maxinc_n/1000
*	replace meaninc_n = meaninc_n/1000

	gen maxinc_r_lag1 = maxinc_r[_n-1] if acode==acode[_n-1] & region==region[_n-1]

	gen oc_r_lag1 = oc_r[_n-1] if acode==acode[_n-1] & region==region[_n-1]
	gen oc_r_lag2 = oc_r[_n-2] if acode==acode[_n-2] & region==region[_n-2]
	gen oc_r_lag3 = oc_r[_n-3] if acode==acode[_n-3] & region==region[_n-3]
	gen oc_r_lag4 = oc_r[_n-4] if acode==acode[_n-4] & region==region[_n-4]

	gen roc_r_model_lag1 = roc_r_model_1[_n-1] if acode==acode[_n-1] & region==region[_n-1]
	gen roc_r_model_lag2 = roc_r_model_1[_n-2] if acode==acode[_n-2] & region==region[_n-2]
	gen roc_r_model_lag3 = roc_r_model_1[_n-3] if acode==acode[_n-3] & region==region[_n-3]
	gen roc_r_model_lag4 = roc_r_model_1[_n-4] if acode==acode[_n-4] & region==region[_n-4]

	gen foc_r_model_lag1 = foc_r_model_1[_n-1] if acode==acode[_n-1] & region==region[_n-1]
	gen foc_r_model_lag2 = foc_r_model_1[_n-2] if acode==acode[_n-2] & region==region[_n-2]
	gen foc_r_model_lag3 = foc_r_model_1[_n-3] if acode==acode[_n-3] & region==region[_n-3]
	gen foc_r_model_lag4 = foc_r_model_1[_n-4] if acode==acode[_n-4] & region==region[_n-4]


	egen oc_r_lag04  = rmean(oc_r oc_r_lag*)
	egen roc_r_model_lag04 = rmean(roc_r_model_1 roc_r_model_lag*)
	egen foc_r_model_lag04 = rmean(foc_r_model_1 foc_r_model_lag*)

/*-----------------*
| TABLE 1: Panel B |
*-----------------*/	
	codebook maxinc_r if oc_r!=.
	codebook meaninc_r if oc_r!=.
	
/*--------*
| TABLE 2 |
*--------*/

sum oc_r
sum oc_r if veh=="Car"
sum oc_r if veh=="SUV"
sum oc_r if veh=="Truck"

sum msrp
sum msrp if veh=="Car"
sum msrp if veh=="SUV"
sum msrp if veh=="Truck"

sum mpg
sum mpg if veh=="Car"
sum mpg if veh=="SUV"
sum mpg if veh=="Truck"

sum hp
sum hp if veh=="Car"
sum hp if veh=="SUV"
sum hp if veh=="Truck"

sum wheelbasein
sum wheelbasein if veh=="Car"
sum wheelbasein if veh=="SUV"
sum wheelbasein if veh=="Truck"

sum numpassenger
sum numpassenger if veh=="Car"
sum numpassenger if veh=="SUV"
sum numpassenger if veh=="Truck"


/*--------*
| TABLE 4 |
*--------*/

	areg maxinc_r oc_r roc_r_model_1 foc_r_model_1 trend1-trend3 rtrend1_model_1-rtrend3_model_1 ftrend1_model_1-ftrend3_model_1 week* reg2-reg5, absorb(acode) robust cluster(acode)

	matrix v=e(V)
	matrix var=J(3,3,1)
	forvalues i=1/3 {
		forvalues j=1/3 {
			matrix var[`i',`j']=v[`i',`j']
		}
	}
	matrix list var
	matrix A=cholesky(var)
	matrix list A
	
	/* THIS "A" MATRIX IS THEN USED IN regs_relativeoffset_2011July28 */
	
	areg meaninc_r oc_r roc_r_model_1 foc_r_model_1 trend1-trend3 rtrend1_model_1-rtrend3_model_1 ftrend1_model_1-ftrend3_model_1 week* reg2-reg5, absorb(acode) robust cluster(acode)	
	
	areg maxinc_r oc_r roc_r_model_1 foc_r_model_1 trend1-trend3 rtrend1_model_1-rtrend3_model_1 ftrend1_model_1-ftrend3_model_1  reg2-reg5, absorb(acode) robust cluster(acode)
	reg maxinc_r oc_r roc_r_model_1 foc_r_model_1 trend1-trend3 rtrend1_model_1-rtrend3_model_1 ftrend1_model_1-ftrend3_model_1 week* reg2-reg5, robust cluster(acode)		

	areg maxinc_n oc_n roc_n_model_1 foc_n_model_1 trend1-trend3 rtrend1_model_1-rtrend3_model_1 ftrend1_model_1-ftrend3_model_1 week* reg2-reg5, absorb(acode) robust cluster(acode)
	
	
/*-----------------------------*
| ALTERNATIVE WEIGHTS: TABLE 6 |
*-----------------------------*/

	/* Equal within segment */
	areg maxinc_r oc_r roc_r_model_8 foc_r_model_8 trend1-trend3 rtrend1_model_1-rtrend3_model_1 ftrend1_model_1-ftrend3_model_1 week* reg2-reg5, absorb(acode) robust cluster(acode)
	areg maxinc_r oc_r roc_r_model_1 foc_r_model_1 roc_r_model_8 foc_r_model_8 trend1-trend3 rtrend1_model_1-rtrend3_model_1 ftrend1_model_1-ftrend3_model_1 week* reg2-reg5, absorb(acode) robust cluster(acode)
	
	/* Equal within type */
	areg maxinc_r oc_r roc_r_model_9 foc_r_model_9 trend1-trend3 rtrend1_model_1-rtrend3_model_1 ftrend1_model_1-ftrend3_model_1 week* reg2-reg5, absorb(acode) robust cluster(acode)
	areg maxinc_r oc_r roc_r_model_1 foc_r_model_1 roc_r_model_9 foc_r_model_9 trend1-trend3 rtrend1_model_1-rtrend3_model_1 ftrend1_model_1-ftrend3_model_1 week* reg2-reg5, absorb(acode) robust cluster(acode)
	
	/* Equal within Cars, Vans, and Trucks */ 
	areg maxinc_r oc_r roc_r_model_12 foc_r_model_12 trend1-trend3 rtrend1_model_1-rtrend3_model_1 ftrend1_model_1-ftrend3_model_1 week* reg2-reg5, absorb(acode) robust cluster(acode)
	areg maxinc_r oc_r roc_r_model_1 foc_r_model_1 roc_r_model_12 foc_r_model_12 trend1-trend3 rtrend1_model_1-rtrend3_model_1 ftrend1_model_1-ftrend3_model_1 week* reg2-reg5, absorb(acode) robust cluster(acode)

/*--------------------*
| SUBSAMPLES: TABLE 7 |
*--------------------*/	
	
	areg maxinc_r oc_r roc_r_model_1 foc_r_model_1 trend1-trend3 rtrend1_model_1-rtrend3_model_1 ftrend1_model_1-ftrend3_model_1 week* reg2-reg5 if veh=="Car", absorb(acode) robust cluster(acode)
	areg maxinc_r oc_r roc_r_model_1 foc_r_model_1 trend1-trend3 rtrend1_model_1-rtrend3_model_1 ftrend1_model_1-ftrend3_model_1 week* reg2-reg5 if veh=="SUV", absorb(acode) robust cluster(acode)
	areg maxinc_r oc_r roc_r_model_1 foc_r_model_1 trend1-trend3 rtrend1_model_1-rtrend3_model_1 ftrend1_model_1-ftrend3_model_1 week* reg2-reg5 if veh=="Truck", absorb(acode) robust cluster(acode)	

/*------------------------*
| LAGGED RESULTS: TABLE 8 |
*------------------------*/	

	areg maxinc_r oc_r roc_r_model_1 foc_r_model_1 oc_r_lag14 roc_r_model_lag14 foc_r_model_lag14 trend1-trend3 rtrend1_model_1-rtrend3_model_1 ftrend1_model_1-ftrend3_model_1 week* reg2-reg5, absorb(acode) robust cluster(acode)
	areg maxinc_r oc_r_lag14 roc_r_model_lag14 foc_r_model_lag14 trend1-trend3 rtrend1_model_1-rtrend3_model_1 ftrend1_model_1-ftrend3_model_1 week* reg2-reg5, absorb(acode) robust cluster(acode)

	
	

log close
