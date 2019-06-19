*** This do-file prepares the data for a given demographic group to run the bootstrap and produce standard errors for
*** the estimators in the corresponding ADO file "estimators_022609.ado". 

* Some notes:
* 1. Make sure to indicate the appropriate directory path where indicated below by "YOUR OWN DIRECTORY PATH"
* 2. User must indicate (i) name of the log file (at the beginning of code), 
*    and (ii) name of the file where bootstrap results will be saved (at the end of code)
*
*** Please refer to the documentation for additional details.
*** Flores, Flores-Lagunes, Gonzalez, and Neumann 12/02/2010 


log using boostrap_022609_ALL.log, replace  // User can provide name of log file and path here...


set more off
clear
set memory 350M
set matsize 1500

*Upload data used.  

use "YOUR OWN DIRECTORY PATH\jc_data_restat_022609.dta", clear


* 0. SELECT OUTCOME: In this program we look at earnq16 and its difference.
gen y=earnq16     //Select outcome
gen dy=earnq16 - base_wkearnr      //Generate its difference.



*** 1. GET POINTS WHERE TO ESTIMATE DRF (Tper & Tper_plus1 variables; latter variable employed to estimate the derivative of the DRF)

* (1.a). ESTIMATE GPS.  
xi: glm T 	r_2 r_3 r_4 uerateb_* uerate1635_1 uerate1635_2 uerate1635_3 uerate1635_4   /// 
moprejc_*  notenroll_* prlsi30_* prlsi90_* prlsi180_* prlsi270_* kv_haschld_* b_mar_*   /// 
base_r_head_* base_age_* b_age2_* b_age3_* base_hs_d_* base_ged_d_* base_voc_d_*    ///
base_any_ed1_* base_hgc_* b_hgc2_* b_english_* Hl_base_hea_2_* Hl_base_hea_3_* Hl_base_hea_4_*   /// 
base_py_cig_* base_py_alchl_* base_py_pot_* base_wkearnr_* base_evworkb_* base_evarrst1_*    ///
b_pmsa_* b_msa_* b_livew2parents_* base_hadworry_* TJ_base_typ_1_* TJ_base_typ_2_*    ///
TJ_base_typ_3_* TJ_base_typ_4_* TJ_base_typ_5_* TJ_base_typ_6_* TJ_base_typ_7_*    ///
TJ_base_typ_8_* TJ_base_typ_9_* TJ_base_typ_10_* TJ_base_typ_11_* base_knewcntr_*    ///
base_e_math_p_* base_e_read_p_* base_e_along_p_* base_e_contrl_p_* base_e_esteem_p_*    ///
base_e_spcjob_* base_e_friend_p_* b_hearpjc_* base_knew_jc_* base_r_crgoal_p_* base_r_train_p_*   /// 
base_r_getged_p_* base_r_nowork_p_* base_r_comm_p_* base_r_home_p_* base_r_other_p_*    ///
kv_nonres_* cent_1_* state_*, vce(robust) f(gamma) l(log) search
predict T_hat      
gen a=1/e(phi)
gen b=T_hat/a
gen Rti= gammaden(a,b,0,T)   // We call the "own" gps --f(ti|xi)-- Rti



* (1.b). IMPOSE OVERLAP CONDITION BASED ON 5 GROUPS. 
* NOTE: We generate a new variable "overlap" which equals one if satisfy overlap condition and 0 o/w.  
*** (2.a.i). Create 5 groups based on percentiles
egen Q1=pctile(T), p(20)
egen Q2=pctile(T), p(40)
egen Q3=pctile(T), p(60)
egen Q4=pctile(T), p(80)

gen G1=0
gen G2=0 
gen G3=0 
gen G4=0 
gen G5=0 
replace G1=1 if T<Q1
replace G2=1 if T<Q2 & G1~=1
replace G3=1 if T<Q3 & G1~=1 & G2~=1
replace G4=1 if T<Q4 & G1~=1 & G2~=1 & G3~=1
replace G5=1 if T>=Q4

*** Get median value of T for each of the 5 groups, and calculate the GPS, f(t|xi),
*** at each of these values for all units (i.e., 5 gps for each individual).

egen T1=pctile(T), p(10)
egen T2=pctile(T), p(30)
egen T3=pctile(T), p(50)
egen T4=pctile(T), p(70)
egen T5=pctile(T), p(90)

gen gps_G1= gammaden(a,b,0,T1)
gen gps_G2= gammaden(a,b,0,T2)
gen gps_G3= gammaden(a,b,0,T3)
gen gps_G4= gammaden(a,b,0,T4)
gen gps_G5= gammaden(a,b,0,T5)


*** Impose overlap condition as the intersection of the groups. 

* Generate all minima and maxima used in overlap condition.
local i = 1
while `i' <=5 {
		egen temp=max(gps_G`i') if G`i'==0
		egen mx_G`i'_0=max(temp)
		drop temp
		egen temp=max(gps_G`i') if G`i'==1
		egen mx_G`i'_1=max(temp)
		drop temp
		egen temp=min(gps_G`i') if G`i'==0
		egen mn_G`i'_0=min(temp)
		drop temp
		egen temp=min(gps_G`i') if G`i'==1
		egen mn_G`i'_1=min(temp)
		drop temp 
	local i = `i' + 1
}

* We get the maximum of the minimums and the minimum of the maximum for each of the
* 5 comparisons. These are the values that bind, the others can be ignored.   

forvalues i=1/5 {
	gen max_min_`i'=0   // Gives the maximum of the minima. Only one of the two lines below holds.
	replace max_min_`i'= mn_G`i'_0 if  mn_G`i'_0>= mn_G`i'_1   // Set equal to avoid ties. If equal does not matter.
	replace max_min_`i'= mn_G`i'_1 if  mn_G`i'_1> mn_G`i'_0
	
	gen min_max_`i'=0   // Gives the minimum of the maxima. Only one of the two lines below holds.
	replace min_max_`i'= mx_G`i'_0 if  mx_G`i'_0< =mx_G`i'_1   // Set equal to avoid ties. If equal does not matter.
	replace min_max_`i'= mx_G`i'_1 if  mx_G`i'_1< mx_G`i'_0
}

* Impose overlap conditions. Units must be comparale in all 5 groups.
gen overlap=0
replace overlap=1 if ( (gps_G1>max_min_1) & (gps_G1<min_max_1) & (gps_G2>max_min_2) & (gps_G2<min_max_2)    ///
& (gps_G3>max_min_3) & (gps_G3<min_max_3) & (gps_G4>max_min_4) & (gps_G4<min_max_4) & (gps_G5>max_min_5)    ///
& (gps_G5<min_max_5)  ) 

* Drop variables we no longer need
drop mx_* mn_* min_max* max_min* Q* G* T1 T2 T3 T4 T5 gps_G* T_hat



* (1.c.) GET THE 99 PERCENTILES OF THE "T" VARIABLE AT WHICH THE DRFs WILL BE ESTIMATED. 

* Get one variable for each of the 99 percentiles of T.
forvalues i=1/99 {
	quietly egen Tper`i'=pctile(T) if overlap==1, p(`i')  //Assigns missing if overlap==0
	quietly sum Tper`i',meanonly
	scalar value=r(mean)
	replace Tper`i'=value if Tper`i'==.   //Gives the value to people with overlap==0
}


* Get one variable that adds one to each of the 99 percentiles of T. 
* Please note that this might not make sense in other applications as it does for our application
* This is used to get "derivative" as DRT(Tper)-DRF(Tper+1) 

gen one=1
forvalues i=1/99 {
	quietly gen Tper`i'_plus1=Tper`i'+one   //We took care of missing values in Tper
}
drop one
scalar drop value



* (1.d.) DROP VARIABLES THAT WILL BE CREATED ALSO IN THE estimators_022609.ado PROGRAM
drop a b Rti overlap 



** GENERATE VARIABLES to be used in the ado-file to compute estimators.
gen one=1
gen T2=T^2
gen T3=T^3
gen T4=T^4
gen T5=T^5
* Generate squares and cubes of Tper variables. Call them Tper`i'_2 and Tper`i'_3
forvalues i=1/99 {
	gen Tper`i'_2=Tper`i'^2  
	gen Tper`i'_3=Tper`i'^3
}
* Generate squares and cubes of Tper_plus1 variables. Call them Tper`i'_plus1_2 
* and Tper`i'_plus1_3



forvalues i=1/99 {
	gen Tper`i'_plus1_2 =Tper`i'_plus1^2  
	gen Tper`i'_plus1_3 =Tper`i'_plus1^3
}



*** 2. DO BOOTSTRAP
* Note: The program "estimators_022609.ado" will use the variables in the current data set.

***** CHANGE NAME OF "saving file" below ACCORDING TO SUBPOPULATION. 
***** Also change the number of bootstrap replications accordingly
 
bootstrap _b, reps (10) saving(boostrap_022609_ALL.dta, double replace) seed(299374396): estimators_022609


display ("program finished running")


log close
