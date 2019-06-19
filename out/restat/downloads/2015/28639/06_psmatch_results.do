*********************************************************
* LOCUS OF CONTROL AND JOB SEARCH STRATEGIES
* Marco Caliendo, Deborah Cobb-Clark, and Arne Uhlendorff
* Review of Economics and Statistics 
* DOI: 
*********************************************************
* THIS FILE: 06_psmatch_results / Combine Matching Results 
* for Table 6 based on 05_psmatch.do  
*********************************************************


version 9.2
capture log close

log using 06_psmatch_results, text replace

clear

set mem 50m
set matsize 800
set more off

set trace off
set tracedepth 1

/* ========================================== */
/* ------------------------------------------ */
/* --- PSMATCH (bootstrap) ------------------ */
/* ========================================== */

global data "DATA DIRECTORY"
global desc "OUTPUT DIRECTORY" 
global score "OUTPUT DIRECTORY"  	
global save  "OUTPUT DIRECTORY"    

foreach loc in LOC {

forvalues sex = 0/2 {            

        forvalues reg = 2/2 {

	forvalues sample = 1/1 {
	

use ${save}/`loc'_int3_logestwage_1_r`reg's`sex'_sa`sample', clear
append using ${save}/`loc'_int3_logestwage_2_r`reg's`sex'_sa`sample'
append using ${save}/`loc'_ext6_logestwage_1_r`reg's`sex'_sa`sample'
append using ${save}/`loc'_ext6_logestwage_2_r`reg's`sex'_sa`sample'
append using ${save}/`loc'_full36_logestwage_1_r`reg's`sex'_sa`sample'
append using ${save}/`loc'_full36_logestwage_2_r`reg's`sex'_sa`sample'
append using ${save}/LOC4_intext36_logestwage_1_r`reg's`sex'_sa`sample'
append using ${save}/LOC4_intext36_logestwage_2_r`reg's`sex'_sa`sample'
gen outcome ="logestwage" 

append using ${save}/`loc'_int3_own_1_r`reg's`sex'_sa`sample'
append using ${save}/`loc'_int3_own_2_r`reg's`sex'_sa`sample'
append using ${save}/`loc'_ext6_own_1_r`reg's`sex'_sa`sample'
append using ${save}/`loc'_ext6_own_2_r`reg's`sex'_sa`sample'
append using ${save}/`loc'_full36_own_1_r`reg's`sex'_sa`sample'
append using ${save}/`loc'_full36_own_2_r`reg's`sex'_sa`sample'
append using ${save}/LOC4_intext36_own_1_r`reg's`sex'_sa`sample'
append using ${save}/LOC4_intext36_own_2_r`reg's`sex'_sa`sample'
replace outcome ="Search-own" if outcome==""


gen a = 1 if art=="Kernel = epan common 0.06"
replace a = 2 if art=="Kernel = epan common 0.02"
replace a = 3 if art=="Kernel = epan common 0.06 trim10"
replace a = 4 if art=="Kernel = epan common 0.02 trim10"

save ${save}/`loc'_real_out_r`reg's`sex'_sa`sample', replace					
outsheet using ${save}/`loc'_real_out_r`reg's`sex'_sa`sample'.csv, comma noquote replace			 
gen effect2 = effect
replace effect2 = . if abs(t)<1.645
order group outcome spec art effect2 effect
sort outcome group spec a
drop meanbiasbef mdebiasbef a
rename meanbiasaft biasaft
rename medbiasaft mdbaft
dta2tex using ${save}/`loc'_real_out_r`reg's`sex'_sa`sample', digits(4) nodigits(TN NT Off spec) replace tableoff 
dta2tex using ${datagw}/`loc'_real_out_r`reg's`sex'_sa`sample', digits(4) nodigits(TN NT Off spec) replace tableoff 
}
}
}
}


log close
exit

