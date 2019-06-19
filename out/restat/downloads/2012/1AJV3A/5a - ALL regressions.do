/*Open log file, set memory, etc*/
set more off
clear all 
set mem 150m
set matsize 150
version 9
global datapath "C:\Users\Michael McMahon\Dropbox\GSOEP21"
cd "$datapath\GiavazziMcMahonReStat"

use final.dta, replace

*BASELINE SAVING RESULTS

drop if age>68
drop if age<24

bysort new_hhnum: gen obs = _N
drop if obs!=6

drop if foreign==1

* DEFINING REGRESSORS

global main "uncertainty inter_uncertainty"
global others "kohl inter_kohl CS_reform inter_CSreform"
global covariates "D_pension_status1 ue  change_income"
global labour_cov "worry_job D_east constructor"
global time_dum "D_year*"

* >>>>>>>>>>>>>>>>>>>>>>>>>> BASELINE REGRESSIONS >>>>>>>>>>>>>>>>>>>>>>>>>>

xtreg change_sr_y $main $covariates $others $time_dum, fe
outreg2 $main $covariates $others using baseline_saving, label symbol(***, **, *) nor2 tstat replace auto(1) tex tdec(1) addnote("", "Balanced Panel, 1995-2000", "All regressions include individual fixed-effects and time fixed-effects")

xtreg change_sr_y $main $covariates $others $time_dum $labour_cov , fe
outreg2 $main $covariates $others $labour_cov using baseline_saving, label  nor2 tstat append auto(1) tex tdec(1)

xtreg change_sr_y $main $covariates $others $time_dum $labour_cov if ue==0, fe
outreg2 $main $covariates $others $labour_cov using baseline_saving, label nor2 tstat append  auto(1) tex tdec(1)

xtreg change_sr_y $main $covariates $others $time_dum $labour_cov  if constructor==0, fe
outreg2 $main $covariates $others worry_job  using baseline_saving, label  nor2 tstat append  auto(1) tex tdec(1)

xtreg change_sr_y $main $covariates $others $time_dum $labour_cov if ue==0 & D_east==0, fe
outreg2 $main $covariates $others worry_job using baseline_saving, label  nor2 tstat append  auto(1) tex tdec(1)

* >>>>>>>>>>>>>>>>>>>>>>>>>> ROBUSTNESS REGRESSIONS >>>>>>>>>>>>>>>>>>>>>>>>>>

xtreg change_sr_y $main $covariates $others $time_dum $labour_cov , fe
outreg2 $main $covariates $others $labour_cov using robust_saving1, label symbol(***, **, *) nor2 tstat replace auto(1) tex tdec(1) addnote("", "Balanced Panel, 1995-2000", "All regressions include individual fixed-effects and time fixed-effects")
 
* ADD ROBUSTNESS REGRESSIONS 1
preserve 

replace inter_uncertainty =0
replace inter_uncertainty = 1 if (year==1998 & month>=10 & affected==1 ) |  (year>=1999 & year<2000 & affected==1 ) | (year==2000 & month<1 & affected==1 )

replace uncertainty = 0
replace uncertainty = 1 if (year==1998 & month>=10  ) |  (year>=1999 & year<2000) | (year==2000 & month<1 ) 

xtreg change_sr_y $main $covariates $others $time_dum $labour_cov , fe
outreg2 $main $covariates $others $labour_cov using robust_saving1, label  nor2 tstat append  auto(1) tex tdec(1)
restore

* ADD ROBUSTNESS REGRESSIONS 2
preserve 

replace inter_uncertainty =0
replace inter_uncertainty = 1 if (year==1998 & month>7 & affected==1 ) |  (year>=1999 & year<2000 & affected==1 ) | (year==2000 & month<7 & affected==1 )

replace uncertainty = 0
replace uncertainty = 1 if (year==1998 & month>7  ) |  (year>=1999 & year<2000) | (year==2000 & month<7 ) 

xtreg change_sr_y $main $covariates $others $time_dum $labour_cov , fe
outreg2 $main $covariates $others $labour_cov using robust_saving1, label  nor2 tstat append  auto(1) tex tdec(1)

restore

* ADD ROBUSTNESS REGRESSIONS 3
preserve 

replace inter_uncertainty =0
replace inter_uncertainty = 1 if (year==1998 & month>=10 & affected==1 ) |  (year>=1999 & year<2000 & affected==1 ) | (year==2000 & month<7 & affected==1 )

replace uncertainty = 0
replace uncertainty = 1 if (year==1998 & month>=10  ) |  (year>=1999 & year<2000) | (year==2000 & month<7 ) 

xtreg change_sr_y $main $covariates $others $time_dum $labour_cov , fe
outreg2 $main $covariates $others $labour_cov using robust_saving1, label  nor2 tstat append  auto(1) tex tdec(1)

restore

* LEVEL REGRESSION IN ROBUSTNESS
xtreg sr_y_pos $main D_pension_status1 ue $others $time_dum $labour_cov hh_y_postgov if sr_y_pos>0, fe
outreg2 $main $covariates $others $labour_cov hh_y_postgov using robust_saving1, label  nor2 tstat append  auto(1) tex tdec(1)

* >>>>>>>>>>>>>>>>>>>>>>>>>> AGE REGRESSIONS >>>>>>>>>>>>>>>>>>>>>>>>>>

gen D_age = 0
replace D_age=1 if age>50

gen age_inter=age*uncertainty
gen age_inter2=age*affected*uncertainty

global ages "age age_inter age_inter2"

xtreg change_sr_y $main $covariates $others $time_dum $labour_cov $ages, fe
outreg2 $main $covariates $others /* $labour_cov  */$ages using age_saving1, label nor2 tstat replace  auto(1) tex tdec(1) addnote("", "Balanced Panel, 1995-2000", "All regressions include individual fixed-effects and time fixed-effects")
estimates store fixed

xtreg change_sr_y $main $covariates $others $time_dum $labour_cov $ages, re
outreg2 $main $covariates $others /* $labour_cov  */$ages using age_saving1, label symbol(***, **, *) nor2 tstat append  auto(1) tex tdec(1)
estimates store random

gen age_inter_2=D_age*uncertainty
gen age_inter2_2=D_age*affected*uncertainty

global ages "D_age age_inter_2 age_inter2_2"

xtreg change_sr_y $main $covariates $others $time_dum $labour_cov $ages, fe
outreg2 $main $covariates $others /* $labour_cov  */$ages using age_saving1, label tstat append  auto(1) tex tdec(1) 

xtreg change_sr_y $main $covariates $others $time_dum $labour_cov $ages, re
outreg2 $main $covariates $others /* $labour_cov  */$ages using age_saving1, label symbol(***, **, *) nor2 tstat append  auto(1) tex tdec(1)
hausman fixed random

* >>>>>>>>>>>>>>>>>>>>>>>>>> LABOUR MARKET REGRESSIONS >>>>>>>>>>>>>>>>>>>>>>>>>>

gen PT_96 = 0
gen temp = 1 if year==1996 & labour_split==3 
bysort new_hhnum: egen temp2 = max(temp)
replace PT_96 = temp2

quietly tab occ_ind , gen(ind)

global main "uncertainty inter_uncertainty"
global others "kohl inter_kohl CS_reform inter_CSreform"
global covariates "D_pension_status1 ue"
global labour_cov "worry_job D_east constructor"
global industry "ind1-ind11" 
global time_dum "D_year*"

*BASELINE LABOUR RESULTS

xtreg hours $main $covariates $others $time_dum $labour_cov $industry if labour_split>=3, fe
outreg2 $main $covariates $others $labour_cov using baseline_hours, nolabel symbol(***, **, *) nor2 tstat replace  auto(1) tex tdec(1) addnote("", "Balanced Panel, 1995-2000", "All regressions include individual fixed-effects, time fixed-effects, and industry fixed-effects")

xtreg hours $main $covariates $others $time_dum $labour_cov $industry if labour_split==3 , fe
outreg2 $main $covariates $others $labour_cov using baseline_hours , nolabel symbol(***, **, *) nor2 tstat append  auto(1) tex tdec(1) 

xtreg hours $main $covariates $others $time_dum $labour_cov $industry if PT_96==1 , fe
outreg2 $main $covariates $others $labour_cov using baseline_hours , nolabel symbol(***, **, *) nor2 tstat append auto(1) tex tdec(1)

xtreg additional_hours $main $covariates $others $time_dum $labour_cov $industry if labour_split>=3, fe
outreg2 $main $covariates $others $labour_cov using baseline_hours , nolabel symbol(***, **, *) nor2 tstat append auto(1) tex tdec(1)

xtreg additional_hours $main $covariates $others $time_dum $labour_cov $industry if labour_split==3, fe
outreg2 $main $covariates $others $labour_cov using baseline_hours , nolabel symbol(***, **, *) nor2 tstat append  auto(1) tex tdec(1)

*************************************************************************************************
