## ###################
## Replication Stata Do File
## Blair, Fair, Malhotra, and Shapiro (2012),
## Poverty and Support for Militant Politics: Evidence from Pakistan.
## Forthcoming, American Journal of Political Science.
## Created 24 March 2011
## Modified 3 April 2012
## 
## Contact Graeme Blair, gblair@princeton.edu with questions
## ####################

## some commands in this file (xtmixed) can only be run with Stata 11 or later
## the optimization fails in earlier versions of xtmixed

## !!
## this file must be run after replication_dataprep.do

## in addition, this file requires a user-written ADO command file
## which cannot be downloaded from within Stata. It can be found at
## http://www.econ.ucdavis.edu/faculty/dlmiller/statafiles
## and is entitled "cgmreg.ado". Place it in the same folder as this
## do file and the replication will work appropriately.

version 11

clear
set more off

use "data_for_analysis.dta", clear

log using "analysis.log", text

***********************REPORTED RESULTS***********************************************

* Unconditional
  
svyset spn [pweight=militancy_weight], strata(province)

svy: reg militancy_support treatment if complete==1
est store militants

forval x = 1/4 {
  svyset spn [pweight=group`x'weight], strata(province)
  svy: reg comb_avgx_group`x' treatment if complete==1
  est store group`x'
}

estout militants group* using "results/Table1A-unconditional.doc", cells(b(fmt(%5.3f) star) se(fmt(%5.3f) par)) stat(r2 N) replace starlevels( + .1 * .05 ** .01 *** .001)

* Conditional

svyset spn [pweight=militancy_weight], strata(province)

svy: reg militancy_support treatment prov_2-prov_4  female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 if complete==1
est store militants

forval x = 1/4 {
  svyset spn [pweight=group`x'weight], strata(province)
  svy: reg comb_avgx_group`x' treatment prov_2-prov_4 female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 if complete==1
  est store group`x'
}

estout militants group* using "results/Table1B-conditional.doc", cells(b(fmt(%5.3f) star) se(fmt(%5.3f) par)) stat(r2 N) replace starlevels( + .1 * .05 ** .01 *** .001)

**
** First table, SES result with trichotomous indicator

svyset spn [pweight=militancy_weight], strata(province)

drop *low_urprov* *high_urprov*

gen low_urprov = 0
gen high_urprov = 0
	
forval y = 0/1 {
	forval x = 1/4 {
		_pctile d13 if province==`x' & urban==`y' [pweight=wtpru], p(20 80)
		replace low_urprov = 1 if d13 <= r(r1) & province==`x' & urban==`y'
		replace high_urprov = 1 if d13 > r(r2) & province==`x' & urban==`y'
		}
	}

replace low_urprov = . if d13 == .
replace high_urprov = . if d13 == .

g treatment_low_urprov = treatment * low_urprov
g treatment_high_urprov = treatment * high_urprov
g low_urprov_urban = low_urprov * urban
g high_urprov_urban = high_urprov * urban
g treatment_low_urprov_urban = treatment * low_urprov_urban
g treatment_high_urprov_urban = treatment * high_urprov_urban

est drop *

svy: reg militancy_support treatment low_urprov high_urprov prov_2-prov_4  treatment_low_urprov treatment_high_urprov  if complete==1
est store ses1

lincom treatment + treatment_low_urprov
lincom treatment + treatment_high_urprov

svy: reg militancy_support treatment low_urprov high_urprov prov_2-prov_4  treatment_low_urprov treatment_high_urprov female married age online cellphone read write math educ2 sunni if complete==1
est store ses2

lincom treatment + treatment_low_urprov
lincom treatment + treatment_high_urprov

svy: reg militancy_support treatment low_urprov high_urprov prov_2-prov_4  treatment_low_urprov treatment_high_urprov female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 if complete==1
est store ses4

lincom treatment + treatment_low_urprov
lincom treatment + treatment_high_urprov

svy: reg militancy_support treatment low_urprov high_urprov prov_2-prov_4  treatment_low_urprov treatment_high_urprov female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 treatment_female treatment_married treatment_age treatment_online treatment_cellphone treatment_read treatment_write treatment_math treatment_educ2 treatment_sunni treatment_usviews1 treatment_usviews2 treatment_sharia_phys treatment_demvalues2 treatment_prov_2 treatment_prov_3 treatment_prov_4 if complete==1
est store ses5

lincom treatment + treatment_low_urprov
lincom treatment + treatment_high_urprov

estout ses* using "results/Table2-SESresult.doc", cells(b(fmt(%5.3f) star) se(fmt(%5.3f) par)) stat(r2 N) replace starlevels( + .1 * .05 ** .01 *** .001)



** Urban

est drop *

g treatment_urban = treatment * urban

svy: reg militancy_support treatment low_urprov high_urprov urban low_urprov_urban high_urprov_urban prov_2-prov_4  treatment_low_urprov treatment_high_urprov treatment_urban treatment_low_urprov_urban treatment_high_urprov_urban  if complete==1
est store sesurban1

*** Urban
lincom treatment + treatment_low_urprov + treatment_low_urprov_urban + treatment_urban
lincom treatment + treatment_urban
lincom treatment + treatment_high_urprov + treatment_high_urprov_urban + treatment_urban

*** Rural
lincom treatment + treatment_low_urprov
lincom treatment 
lincom treatment + treatment_high_urprov

svy: reg militancy_support treatment low_urprov high_urprov urban low_urprov_urban high_urprov_urban  prov_2-prov_4  treatment_low_urprov treatment_high_urprov treatment_urban treatment_low_urprov_urban treatment_high_urprov_urban  female married age online cellphone read write math educ2 sunni if complete==1
est store sesurban2

*** Urban
lincom treatment + treatment_low_urprov + treatment_low_urprov_urban + treatment_urban
lincom treatment + treatment_urban
lincom treatment + treatment_high_urprov + treatment_high_urprov_urban + treatment_urban

*** Rural
lincom treatment + treatment_low_urprov
lincom treatment 
lincom treatment + treatment_high_urprov


svy: reg militancy_support treatment low_urprov high_urprov urban low_urprov_urban high_urprov_urban  prov_2-prov_4  treatment_low_urprov treatment_high_urprov treatment_urban treatment_low_urprov_urban treatment_high_urprov_urban female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 if complete==1
est store sesurban4

*** Urban
lincom treatment + treatment_low_urprov + treatment_low_urprov_urban + treatment_urban
lincom treatment + treatment_urban
lincom treatment + treatment_high_urprov + treatment_high_urprov_urban + treatment_urban

*** Rural
lincom treatment + treatment_low_urprov
lincom treatment 
lincom treatment + treatment_high_urprov

svy: reg militancy_support treatment low_urprov high_urprov urban low_urprov_urban high_urprov_urban  prov_2-prov_4  treatment_low_urprov treatment_high_urprov treatment_urban treatment_low_urprov_urban treatment_high_urprov_urban female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 treatment_female treatment_married treatment_age treatment_online treatment_cellphone treatment_read treatment_write treatment_math treatment_educ2 treatment_sunni treatment_usviews1 treatment_usviews2 treatment_sharia_phys treatment_demvalues2 treatment_prov_2 treatment_prov_3 treatment_prov_4 if complete==1
est store sesurban5

*** Urban
lincom treatment + treatment_low_urprov + treatment_low_urprov_urban + treatment_urban
lincom treatment + treatment_urban
lincom treatment + treatment_high_urprov + treatment_high_urprov_urban + treatment_urban

*** Rural
lincom treatment + treatment_low_urprov
lincom treatment 
lincom treatment + treatment_high_urprov

estout sesurban* using "results/Table4-SESurban.doc", cells(b(fmt(%5.3f) star) se(fmt(%5.3f) par)) stat(r2 N) replace starlevels( + .1 * .05 ** .01 *** .001)


******
  * ROBUSTNESS CHECKS

clonevar low_urprov_orig = low_urprov
clonevar high_urprov_orig = high_urprov

est drop *

drop *low_urprov* *high_urprov*

gen low_urprov = 0
gen high_urprov = 0
	
forval y = 0/1 {
	forval x = 1/4 {
		_pctile d13 if province==`x' & urban==`y' [pweight=wtpru], p(20 80)
		replace low_urprov = 1 if d13 <= r(r1) & province==`x' & urban==`y'
		replace high_urprov = 1 if d13 > r(r2) & province==`x' & urban==`y'
		}
	}

replace low_urprov = . if d13 == .
replace high_urprov = . if d13 == .

g treatment_low_urprov = treatment * low_urprov
g treatment_high_urprov = treatment * high_urprov
g low_urprov_urban = low_urprov * urban
g high_urprov_urban = high_urprov * urban
g treatment_low_urprov_urban = treatment * low_urprov_urban
g treatment_high_urprov_urban = treatment * high_urprov_urban

svy: reg militancy_support treatment low_urprov high_urprov prov_2-prov_4  treatment_low_urprov treatment_high_urprov female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 if complete==1
est store ses20

lincom treatment + treatment_low_urprov
lincom treatment + treatment_high_urprov

svy: reg militancy_support treatment low_urprov high_urprov urban low_urprov_urban high_urprov_urban  prov_2-prov_4  treatment_low_urprov treatment_high_urprov treatment_urban treatment_low_urprov_urban treatment_high_urprov_urban female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 if complete==1
est store ses20urban

*** Urban
lincom treatment + treatment_low_urprov + treatment_low_urprov_urban + treatment_urban
lincom treatment + treatment_urban
lincom treatment + treatment_high_urprov + treatment_high_urprov_urban + treatment_urban

*** Rural
lincom treatment + treatment_low_urprov
lincom treatment 
lincom treatment + treatment_high_urprov

drop *low_urprov* *high_urprov*

gen low_urprov = 0
gen high_urprov = 0
	
forval y = 0/1 {
	forval x = 1/4 {
		_pctile d13 if province==`x' & urban==`y' [pweight=wtpru], p(10 80)
		replace low_urprov = 1 if d13 <= r(r1) & province==`x' & urban==`y'
		replace high_urprov = 1 if d13 > r(r2) & province==`x' & urban==`y'
		}
	}

replace low_urprov = . if d13 == .
replace high_urprov = . if d13 == .

g treatment_low_urprov = treatment * low_urprov
g treatment_high_urprov = treatment * high_urprov
g low_urprov_urban = low_urprov * urban
g high_urprov_urban = high_urprov * urban
g treatment_low_urprov_urban = treatment * low_urprov_urban
g treatment_high_urprov_urban = treatment * high_urprov_urban

svy: reg militancy_support treatment low_urprov high_urprov prov_2-prov_4  treatment_low_urprov treatment_high_urprov female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 if complete==1
est store ses10

lincom treatment + treatment_low_urprov
lincom treatment + treatment_high_urprov

svy: reg militancy_support treatment low_urprov high_urprov urban low_urprov_urban high_urprov_urban  prov_2-prov_4  treatment_low_urprov treatment_high_urprov treatment_urban treatment_low_urprov_urban treatment_high_urprov_urban female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 if complete==1
est store ses10urban

*** Urban
lincom treatment + treatment_low_urprov + treatment_low_urprov_urban + treatment_urban
lincom treatment + treatment_urban
lincom treatment + treatment_high_urprov + treatment_high_urprov_urban + treatment_urban

*** Rural
lincom treatment + treatment_low_urprov
lincom treatment 
lincom treatment + treatment_high_urprov


drop *low_urprov* *high_urprov*

gen low_urprov = 0
gen high_urprov = 0
	
forval y = 0/1 {
	forval x = 1/4 {
		_pctile d13 if province==`x' & urban==`y' [pweight=wtpru], p(15 80)
		replace low_urprov = 1 if d13 <= r(r1) & province==`x' & urban==`y'
		replace high_urprov = 1 if d13 > r(r2) & province==`x' & urban==`y'
		}
	}

replace low_urprov = . if d13 == .
replace high_urprov = . if d13 == .

g treatment_low_urprov = treatment * low_urprov
g treatment_high_urprov = treatment * high_urprov
g low_urprov_urban = low_urprov * urban
g high_urprov_urban = high_urprov * urban
g treatment_low_urprov_urban = treatment * low_urprov_urban
g treatment_high_urprov_urban = treatment * high_urprov_urban

svy: reg militancy_support treatment low_urprov high_urprov prov_2-prov_4  treatment_low_urprov treatment_high_urprov female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 if complete==1
est store ses15

lincom treatment + treatment_low_urprov
lincom treatment + treatment_high_urprov

svy: reg militancy_support treatment low_urprov high_urprov urban low_urprov_urban high_urprov_urban  prov_2-prov_4  treatment_low_urprov treatment_high_urprov treatment_urban treatment_low_urprov_urban treatment_high_urprov_urban female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 if complete==1
est store ses15urban

*** Urban
lincom treatment + treatment_low_urprov + treatment_low_urprov_urban + treatment_urban
lincom treatment + treatment_urban
lincom treatment + treatment_high_urprov + treatment_high_urprov_urban + treatment_urban

*** Rural
lincom treatment + treatment_low_urprov
lincom treatment 
lincom treatment + treatment_high_urprov

drop *low_urprov* *high_urprov*

gen low_urprov = 0
gen high_urprov = 0
	
forval y = 0/1 {
	forval x = 1/4 {
		_pctile d13 if province==`x' & urban==`y' [pweight=wtpru], p(25 80)
		replace low_urprov = 1 if d13 <= r(r1) & province==`x' & urban==`y'
		replace high_urprov = 1 if d13 > r(r2) & province==`x' & urban==`y'
		}
	}

replace low_urprov = . if d13 == .
replace high_urprov = . if d13 == .

g treatment_low_urprov = treatment * low_urprov
g treatment_high_urprov = treatment * high_urprov
g low_urprov_urban = low_urprov * urban
g high_urprov_urban = high_urprov * urban
g treatment_low_urprov_urban = treatment * low_urprov_urban
g treatment_high_urprov_urban = treatment * high_urprov_urban

svy: reg militancy_support treatment low_urprov high_urprov prov_2-prov_4  treatment_low_urprov treatment_high_urprov female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 if complete==1
est store ses25

lincom treatment + treatment_low_urprov
lincom treatment + treatment_high_urprov

svy: reg militancy_support treatment low_urprov high_urprov urban low_urprov_urban high_urprov_urban  prov_2-prov_4  treatment_low_urprov treatment_high_urprov treatment_urban treatment_low_urprov_urban treatment_high_urprov_urban female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 if complete==1
est store ses25urban

*** Urban
lincom treatment + treatment_low_urprov + treatment_low_urprov_urban + treatment_urban
lincom treatment + treatment_urban
lincom treatment + treatment_high_urprov + treatment_high_urprov_urban + treatment_urban

*** Rural
lincom treatment + treatment_low_urprov
lincom treatment 
lincom treatment + treatment_high_urprov

drop *low_urprov* *high_urprov*

gen low_urprov = 0
gen high_urprov = 0
	
forval y = 0/1 {
	forval x = 1/4 {
		_pctile d13 if province==`x' & urban==`y' [pweight=wtpru], p(30 80)
		replace low_urprov = 1 if d13 <= r(r1) & province==`x' & urban==`y'
		replace high_urprov = 1 if d13 > r(r2) & province==`x' & urban==`y'
		}
	}

replace low_urprov = . if d13 == .
replace high_urprov = . if d13 == .

g treatment_low_urprov = treatment * low_urprov
g treatment_high_urprov = treatment * high_urprov
g low_urprov_urban = low_urprov * urban
g high_urprov_urban = high_urprov * urban
g treatment_low_urprov_urban = treatment * low_urprov_urban
g treatment_high_urprov_urban = treatment * high_urprov_urban

svy: reg militancy_support treatment low_urprov high_urprov prov_2-prov_4  treatment_low_urprov treatment_high_urprov female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 if complete==1
est store ses30

lincom treatment + treatment_low_urprov
lincom treatment + treatment_high_urprov

svy: reg militancy_support treatment low_urprov high_urprov urban low_urprov_urban high_urprov_urban  prov_2-prov_4  treatment_low_urprov treatment_high_urprov treatment_urban treatment_low_urprov_urban treatment_high_urprov_urban female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 if complete==1
est store ses30urban

*** Urban
lincom treatment + treatment_low_urprov + treatment_low_urprov_urban + treatment_urban
lincom treatment + treatment_urban
lincom treatment + treatment_high_urprov + treatment_high_urprov_urban + treatment_urban

*** Rural
lincom treatment + treatment_low_urprov
lincom treatment 
lincom treatment + treatment_high_urprov

estout ses10 ses15 ses20 ses25 ses30 using "results/TableOnlineApp4-SESrobustness.doc", cells(b(fmt(%5.3f) star) se(fmt(%5.3f) par)) stat(r2 N) replace starlevels( + .1 * .05 ** .01 *** .001)

estout ses10urban ses15urban ses20urban ses25urban ses30urban using "results/TableOnlineApp10-SESurbanrobustness.doc", cells(b(fmt(%5.3f) star) se(fmt(%5.3f) par)) stat(r2 N) replace starlevels( + .1 * .05 ** .01 *** .001)


** Iteratively dropping policies analysis

svyset spn [pweight=militancy_weight], strata(province)

drop *low_urprov* *high_urprov*

gen low_urprov = 0
gen high_urprov = 0
	
forval y = 0/1 {
	forval x = 1/4 {
		_pctile d13 if province==`x' & urban==`y' [pweight=wtpru], p(20 80)
		replace low_urprov = 1 if d13 <= r(r1) & province==`x' & urban==`y'
		replace high_urprov = 1 if d13 > r(r2) & province==`x' & urban==`y'
		}
	}

replace low_urprov = . if d13 == .
replace high_urprov = . if d13 == .

g treatment_low_urprov = treatment * low_urprov
g treatment_high_urprov = treatment * high_urprov
g low_urprov_urban = low_urprov * urban
g high_urprov_urban = high_urprov * urban
g treatment_low_urprov_urban = treatment * low_urprov_urban
g treatment_high_urprov_urban = treatment * high_urprov_urban

est drop *

  svy: reg militancy_support treatment low_urprov high_urprov prov_2-prov_4  treatment_low_urprov treatment_high_urprov  if complete==1
est store ses1

lincom treatment + treatment_low_urprov
lincom treatment + treatment_high_urprov

svy: reg militancy_support treatment low_urprov high_urprov prov_2-prov_4  treatment_low_urprov treatment_high_urprov female married age online cellphone read write math educ2 sunni if complete==1
est store ses2

lincom treatment + treatment_low_urprov
lincom treatment + treatment_high_urprov

svy: reg militancy_support treatment low_urprov high_urprov prov_2-prov_4  treatment_low_urprov treatment_high_urprov female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 if complete==1
est store ses4

lincom treatment + treatment_low_urprov
lincom treatment + treatment_high_urprov

svy: reg militancy_support treatment low_urprov high_urprov prov_2-prov_4  treatment_low_urprov treatment_high_urprov female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 treatment_female treatment_married treatment_age treatment_online treatment_cellphone treatment_read treatment_write treatment_math treatment_educ2 treatment_sunni treatment_usviews1 treatment_usviews2 treatment_sharia_phys treatment_demvalues2 treatment_prov_2 treatment_prov_3 treatment_prov_4 if complete==1
est store ses5

lincom treatment + treatment_low_urprov
lincom treatment + treatment_high_urprov

*****
  * Drop first

egen control_combxD1 = rowtotal ( newq810a newq830a newq840a)
gen control_comb_avgxD1 = control_combxD1/15 if control_combxD1 > 0 &complete==1

egen pakmil_combxD1 = rowtotal ( newq810b newq830b newq840b)
gen pakmil_comb_avgxD1 = pakmil_combxD1/5 if pakmil_combx > 0 & complete==1

egen afgmil_combxD1 = rowtotal ( newq810c newq830c newq840c)
gen afgmil_comb_avgxD1 = afgmil_combxD1/5 if afgmil_combx > 0 & complete==1

egen alq_combxD1 = rowtotal ( newq810d newq830d newq840d)
gen alq_comb_avgxD1 = alq_combxD1/5 if alq_combx > 0 & complete==1

egen tanzeem_combxD1 = rowtotal ( newq810e newq830e newq840e)
gen tanzeem_comb_avgxD1 = tanzeem_combxD1/5 if tanzeem_combx > 0 & complete==1

****combines control condition with each group individually*****

egen comb_avgx_pakmilxD1 = rowtotal (control_comb_avgxD1 pakmil_comb_avgxD1)
egen comb_avgx_afgmilxD1 = rowtotal (control_comb_avgxD1 afgmil_comb_avgxD1) 
egen comb_avgx_alqxD1 = rowtotal (control_comb_avgxD1 alq_comb_avgxD1) 
egen comb_avgx_tanzeemxD1 = rowtotal (control_comb_avgxD1 tanzeem_comb_avgxD1)

rename comb_avgx_pakmilxD1 comb_avgx_group1D1
rename comb_avgx_afgmilxD1 comb_avgx_group2D1
rename comb_avgx_alqxD1 comb_avgx_group3D1
rename comb_avgx_tanzeemxD1 comb_avgx_group4D1

gen pakmilD1 = pakmil_comb_avgxD1!=. if complete==1
gen afgmilD1 = afgmil_comb_avgxD1!=. if complete==1
gen alqD1 = alq_comb_avgxD1!=. if complete==1
gen tanzeemD1 = tanzeem_comb_avgxD1!=. if complete==1

rename pakmilD1 group1D1
rename afgmilD1 group2D1
rename alqD1 group3D1
rename tanzeemD1 group4D1

** Generate generic measure of support
gen militancy_supportD1 = (comb_avgx_group1D1+comb_avgx_group2D1+comb_avgx_group3D1+comb_avgx_group4D1)/4

svy: reg militancy_supportD1 treatment low_urprov high_urprov prov_2-prov_4  treatment_low_urprov treatment_high_urprov  if complete==1
est store D1ses1

lincom treatment + treatment_low_urprov
lincom treatment + treatment_high_urprov

svy: reg militancy_supportD1 treatment low_urprov high_urprov prov_2-prov_4  treatment_low_urprov treatment_high_urprov female married age online cellphone read write math educ2 sunni if complete==1
est store D1ses2

lincom treatment + treatment_low_urprov
lincom treatment + treatment_high_urprov

svy: reg militancy_supportD1 treatment low_urprov high_urprov prov_2-prov_4  treatment_low_urprov treatment_high_urprov female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 if complete==1
est store D1ses4

lincom treatment + treatment_low_urprov
lincom treatment + treatment_high_urprov

svy: reg militancy_supportD1 treatment low_urprov high_urprov prov_2-prov_4  treatment_low_urprov treatment_high_urprov female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 treatment_female treatment_married treatment_age treatment_online treatment_cellphone treatment_read treatment_write treatment_math treatment_educ2 treatment_sunni treatment_usviews1 treatment_usviews2 treatment_sharia_phys treatment_demvalues2 treatment_prov_2 treatment_prov_3 treatment_prov_4 if complete==1
est store D1ses5

lincom treatment + treatment_low_urprov
lincom treatment + treatment_high_urprov

****
  * Drop second

egen control_combxD2 = rowtotal (newq800a  newq830a newq840a)
gen control_comb_avgxD2 = control_combxD2/15 if control_combxD2 > 0 &complete==1

egen pakmil_combxD2 = rowtotal (newq800b  newq830b newq840b)
gen pakmil_comb_avgxD2 = pakmil_combxD2/5 if pakmil_combx > 0 & complete==1

egen afgmil_combxD2 = rowtotal (newq800c  newq830c newq840c)
gen afgmil_comb_avgxD2 = afgmil_combxD2/5 if afgmil_combx > 0 & complete==1

egen alq_combxD2 = rowtotal (newq800d  newq830d newq840d)
gen alq_comb_avgxD2 = alq_combxD2/5 if alq_combx > 0 & complete==1

egen tanzeem_combxD2 = rowtotal (newq800e  newq830e newq840e)
gen tanzeem_comb_avgxD2 = tanzeem_combxD2/5 if tanzeem_combx > 0 & complete==1

****combines control condition with each group individually*****

egen comb_avgx_pakmilxD2 = rowtotal (control_comb_avgxD2 pakmil_comb_avgxD2)
egen comb_avgx_afgmilxD2 = rowtotal (control_comb_avgxD2 afgmil_comb_avgxD2) 
egen comb_avgx_alqxD2 = rowtotal (control_comb_avgxD2 alq_comb_avgxD2) 
egen comb_avgx_tanzeemxD2 = rowtotal (control_comb_avgxD2 tanzeem_comb_avgxD2)

rename comb_avgx_pakmilxD2 comb_avgx_group1D2
rename comb_avgx_afgmilxD2 comb_avgx_group2D2
rename comb_avgx_alqxD2 comb_avgx_group3D2
rename comb_avgx_tanzeemxD2 comb_avgx_group4D2

gen pakmilD2 = pakmil_comb_avgxD2!=. if complete==1
gen afgmilD2 = afgmil_comb_avgxD2!=. if complete==1
gen alqD2 = alq_comb_avgxD2!=. if complete==1
gen tanzeemD2 = tanzeem_comb_avgxD2!=. if complete==1

rename pakmilD2 group1D2
rename afgmilD2 group2D2
rename alqD2 group3D2
rename tanzeemD2 group4D2

** Generate generic measure of support
gen militancy_supportD2 = (comb_avgx_group1D2+comb_avgx_group2D2+comb_avgx_group3D2+comb_avgx_group4D2)/4

svy: reg militancy_supportD2 treatment low_urprov high_urprov prov_2-prov_4  treatment_low_urprov treatment_high_urprov  if complete==1
est store D2ses1

lincom treatment + treatment_low_urprov
lincom treatment + treatment_high_urprov

svy: reg militancy_supportD2 treatment low_urprov high_urprov prov_2-prov_4  treatment_low_urprov treatment_high_urprov female married age online cellphone read write math educ2 sunni if complete==1
est store D2ses2

lincom treatment + treatment_low_urprov
lincom treatment + treatment_high_urprov

svy: reg militancy_supportD2 treatment low_urprov high_urprov prov_2-prov_4  treatment_low_urprov treatment_high_urprov female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 if complete==1
est store D2ses4

lincom treatment + treatment_low_urprov
lincom treatment + treatment_high_urprov

svy: reg militancy_supportD2 treatment low_urprov high_urprov prov_2-prov_4  treatment_low_urprov treatment_high_urprov female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 treatment_female treatment_married treatment_age treatment_online treatment_cellphone treatment_read treatment_write treatment_math treatment_educ2 treatment_sunni treatment_usviews1 treatment_usviews2 treatment_sharia_phys treatment_demvalues2 treatment_prov_2 treatment_prov_3 treatment_prov_4 if complete==1
est store D2ses5

lincom treatment + treatment_low_urprov
lincom treatment + treatment_high_urprov

****
  * Drop third

egen control_combxD3 = rowtotal (newq800a newq810a  newq840a)
gen control_comb_avgxD3 = control_combxD3/15 if control_combxD3 > 0 &complete==1

egen pakmil_combxD3 = rowtotal (newq800b newq810b  newq840b)
gen pakmil_comb_avgxD3 = pakmil_combxD3/5 if pakmil_combx > 0 & complete==1

egen afgmil_combxD3 = rowtotal (newq800c newq810c  newq840c)
gen afgmil_comb_avgxD3 = afgmil_combxD3/5 if afgmil_combx > 0 & complete==1

egen alq_combxD3 = rowtotal (newq800d newq810d  newq840d)
gen alq_comb_avgxD3 = alq_combxD3/5 if alq_combx > 0 & complete==1

egen tanzeem_combxD3 = rowtotal (newq800e newq810e  newq840e)
gen tanzeem_comb_avgxD3 = tanzeem_combxD3/5 if tanzeem_combx > 0 & complete==1

****combines control condition with each group individually*****

egen comb_avgx_pakmilxD3 = rowtotal (control_comb_avgxD3 pakmil_comb_avgxD3)
egen comb_avgx_afgmilxD3 = rowtotal (control_comb_avgxD3 afgmil_comb_avgxD3) 
egen comb_avgx_alqxD3 = rowtotal (control_comb_avgxD3 alq_comb_avgxD3) 
egen comb_avgx_tanzeemxD3 = rowtotal (control_comb_avgxD3 tanzeem_comb_avgxD3)

rename comb_avgx_pakmilxD3 comb_avgx_group1D3
rename comb_avgx_afgmilxD3 comb_avgx_group2D3
rename comb_avgx_alqxD3 comb_avgx_group3D3
rename comb_avgx_tanzeemxD3 comb_avgx_group4D3

gen pakmilD3 = pakmil_comb_avgxD3!=. if complete==1
gen afgmilD3 = afgmil_comb_avgxD3!=. if complete==1
gen alqD3 = alq_comb_avgxD3!=. if complete==1
gen tanzeemD3 = tanzeem_comb_avgxD3!=. if complete==1

rename pakmilD3 group1D3
rename afgmilD3 group2D3
rename alqD3 group3D3
rename tanzeemD3 group4D3

** Generate generic measure of support
gen militancy_supportD3 = (comb_avgx_group1D3+comb_avgx_group2D3+comb_avgx_group3D3+comb_avgx_group4D3)/4

svy: reg militancy_supportD3 treatment low_urprov high_urprov prov_2-prov_4  treatment_low_urprov treatment_high_urprov  if complete==1
est store D3ses1

lincom treatment + treatment_low_urprov
lincom treatment + treatment_high_urprov

svy: reg militancy_supportD3 treatment low_urprov high_urprov prov_2-prov_4  treatment_low_urprov treatment_high_urprov female married age online cellphone read write math educ2 sunni if complete==1
est store D3ses2

lincom treatment + treatment_low_urprov
lincom treatment + treatment_high_urprov

svy: reg militancy_supportD3 treatment low_urprov high_urprov prov_2-prov_4  treatment_low_urprov treatment_high_urprov female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 if complete==1
est store D3ses4

lincom treatment + treatment_low_urprov
lincom treatment + treatment_high_urprov

svy: reg militancy_supportD3 treatment low_urprov high_urprov prov_2-prov_4  treatment_low_urprov treatment_high_urprov female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 treatment_female treatment_married treatment_age treatment_online treatment_cellphone treatment_read treatment_write treatment_math treatment_educ2 treatment_sunni treatment_usviews1 treatment_usviews2 treatment_sharia_phys treatment_demvalues2 treatment_prov_2 treatment_prov_3 treatment_prov_4 if complete==1
est store D3ses5

lincom treatment + treatment_low_urprov
lincom treatment + treatment_high_urprov


***
  * Drop fourth

egen control_combxD4 = rowtotal (newq800a newq810a newq830a )
gen control_comb_avgxD4 = control_combxD4/15 if control_combxD4 > 0 &complete==1

egen pakmil_combxD4 = rowtotal (newq800b newq810b newq830b )
gen pakmil_comb_avgxD4 = pakmil_combxD4/5 if pakmil_combx > 0 & complete==1

egen afgmil_combxD4 = rowtotal (newq800c newq810c newq830c )
gen afgmil_comb_avgxD4 = afgmil_combxD4/5 if afgmil_combx > 0 & complete==1

egen alq_combxD4 = rowtotal (newq800d newq810d newq830d )
gen alq_comb_avgxD4 = alq_combxD4/5 if alq_combx > 0 & complete==1

egen tanzeem_combxD4 = rowtotal (newq800e newq810e newq830e )
gen tanzeem_comb_avgxD4 = tanzeem_combxD4/5 if tanzeem_combx > 0 & complete==1

****combines control condition with each group individually*****

egen comb_avgx_pakmilxD4 = rowtotal (control_comb_avgxD4 pakmil_comb_avgxD4)
egen comb_avgx_afgmilxD4 = rowtotal (control_comb_avgxD4 afgmil_comb_avgxD4) 
egen comb_avgx_alqxD4 = rowtotal (control_comb_avgxD4 alq_comb_avgxD4) 
egen comb_avgx_tanzeemxD4 = rowtotal (control_comb_avgxD4 tanzeem_comb_avgxD4)

rename comb_avgx_pakmilxD4 comb_avgx_group1D4
rename comb_avgx_afgmilxD4 comb_avgx_group2D4
rename comb_avgx_alqxD4 comb_avgx_group3D4
rename comb_avgx_tanzeemxD4 comb_avgx_group4D4

gen pakmilD4 = pakmil_comb_avgxD4!=. if complete==1
gen afgmilD4 = afgmil_comb_avgxD4!=. if complete==1
gen alqD4 = alq_comb_avgxD4!=. if complete==1
gen tanzeemD4 = tanzeem_comb_avgxD4!=. if complete==1

rename pakmilD4 group1D4
rename afgmilD4 group2D4
rename alqD4 group3D4
rename tanzeemD4 group4D4

** Generate generic measure of support
gen militancy_supportD4 = (comb_avgx_group1D4+comb_avgx_group2D4+comb_avgx_group3D4+comb_avgx_group4D4)/4

svy: reg militancy_supportD4 treatment low_urprov high_urprov prov_2-prov_4  treatment_low_urprov treatment_high_urprov  if complete==1
est store D4ses1

lincom treatment + treatment_low_urprov
lincom treatment + treatment_high_urprov

svy: reg militancy_supportD4 treatment low_urprov high_urprov prov_2-prov_4  treatment_low_urprov treatment_high_urprov female married age online cellphone read write math educ2 sunni if complete==1
est store D4ses2

lincom treatment + treatment_low_urprov
lincom treatment + treatment_high_urprov

svy: reg militancy_supportD4 treatment low_urprov high_urprov prov_2-prov_4  treatment_low_urprov treatment_high_urprov female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 if complete==1
est store D4ses4

lincom treatment + treatment_low_urprov
lincom treatment + treatment_high_urprov

svy: reg militancy_supportD4 treatment low_urprov high_urprov prov_2-prov_4  treatment_low_urprov treatment_high_urprov female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 treatment_female treatment_married treatment_age treatment_online treatment_cellphone treatment_read treatment_write treatment_math treatment_educ2 treatment_sunni treatment_usviews1 treatment_usviews2 treatment_sharia_phys treatment_demvalues2 treatment_prov_2 treatment_prov_3 treatment_prov_4 if complete==1
est store D4ses5

lincom treatment + treatment_low_urprov
lincom treatment + treatment_high_urprov

estout ses4 D*ses4 using "results/TableOnlineApp5-DropPolicies.doc", cells(b(fmt(%5.3f) star) se(fmt(%5.3f) par)) stat(r2 N) replace starlevels( + .1 * .05 ** .01 *** .001)

***

* Sociotropic

** Same analysis, with LFS data

use "data_for_analysis.dta", clear

g district_merge = district
replace district_merge = "karachi" if district == "west (karachi)" | district == "south (karachi)" | district == "malir (karachi)" | district == "east (karachi)" | district == "central (karachi)"

merge district_merge using "district_income_data.dta", nokeep _merge(_m_lfs) sort uniqusing

g treatment_low_inc_dist_median = treatment * low_inc_dist_median

g treatment_high_inc_dist_median = treatment * high_inc_dist_median


est drop *

svy: reg militancy_support treatment low_inc_dist_median high_inc_dist_median prov_2-prov_4 treatment_low_inc_dist_median treatment_high_inc_dist_median  if complete==1
est store ses1

lincom treatment + treatment_low_inc_dist_median
lincom treatment + treatment_high_inc_dist_median

svy: reg militancy_support treatment low_inc_dist_median high_inc_dist_median prov_2-prov_4  treatment_low_inc_dist_median treatment_high_inc_dist_median female married age online cellphone read write math educ2 sunni if complete==1
est store ses2

lincom treatment + treatment_low_inc_dist_median
lincom treatment + treatment_high_inc_dist_median

svy: reg militancy_support treatment low_inc_dist_median high_inc_dist_median prov_2-prov_4 treatment_low_inc_dist_median treatment_high_inc_dist_median female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 if complete==1
est store ses4

lincom treatment + treatment_low_inc_dist_median
lincom treatment + treatment_high_inc_dist_median

svy: reg militancy_support treatment low_inc_dist_median high_inc_dist_median prov_2-prov_4 treatment_low_inc_dist_median treatment_high_inc_dist_median female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 treatment_female treatment_married treatment_age treatment_online treatment_cellphone treatment_read treatment_write treatment_math treatment_educ2 treatment_sunni treatment_usviews1 treatment_usviews2 treatment_sharia_phys treatment_demvalues2 treatment_prov_2 treatment_prov_3 treatment_prov_4 if complete==1
est store ses5

lincom treatment + treatment_low_inc_dist_median
lincom treatment + treatment_high_inc_dist_median

estout ses* using "results/Table3-LFSnoindividual.doc", cells(b(fmt(%5.3f) star) se(fmt(%5.3f) par)) stat(r2 N) replace starlevels( + .1 * .05 ** .01 *** .001)

  
est drop *

svy: reg militancy_support treatment low_urprov high_urprov low_inc_dist_median high_inc_dist_median prov_2-prov_4  treatment_low_urprov treatment_high_urprov treatment_low_inc_dist_median treatment_high_inc_dist_median  if complete==1
est store ses1

lincom treatment + treatment_low_urprov
lincom treatment + treatment_high_urprov

lincom treatment + treatment_low_inc_dist_median
lincom treatment + treatment_high_inc_dist_median

svy: reg militancy_support treatment low_urprov high_urprov low_inc_dist_median high_inc_dist_median prov_2-prov_4  treatment_low_urprov treatment_high_urprov treatment_low_inc_dist_median treatment_high_inc_dist_median female married age online cellphone read write math educ2 sunni if complete==1
est store ses2

lincom treatment + treatment_low_urprov
lincom treatment + treatment_high_urprov

lincom treatment + treatment_low_inc_dist_median
lincom treatment + treatment_high_inc_dist_median

svy: reg militancy_support treatment low_urprov high_urprov low_inc_dist_median high_inc_dist_median prov_2-prov_4  treatment_low_urprov treatment_high_urprov treatment_low_inc_dist_median treatment_high_inc_dist_median female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 if complete==1
est store ses4

lincom treatment + treatment_low_urprov
lincom treatment + treatment_high_urprov

lincom treatment + treatment_low_inc_dist_median
lincom treatment + treatment_high_inc_dist_median

svy: reg militancy_support treatment low_urprov high_urprov low_inc_dist_median high_inc_dist_median prov_2-prov_4  treatment_low_urprov treatment_high_urprov treatment_low_inc_dist_median treatment_high_inc_dist_median female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 treatment_female treatment_married treatment_age treatment_online treatment_cellphone treatment_read treatment_write treatment_math treatment_educ2 treatment_sunni treatment_usviews1 treatment_usviews2 treatment_sharia_phys treatment_demvalues2 treatment_prov_2 treatment_prov_3 treatment_prov_4 if complete==1
est store ses5

lincom treatment + treatment_low_urprov
lincom treatment + treatment_high_urprov

lincom treatment + treatment_low_inc_dist_median
lincom treatment + treatment_high_inc_dist_median

estout ses* using "results/TableOnlineApp6-LFSindivcontrol.doc", cells(b(fmt(%5.3f) star) se(fmt(%5.3f) par)) stat(r2 N) replace starlevels( + .1 * .05 ** .01 *** .001)

/// Robustness to Model Choice

est drop *

svyset d24 [pweight=militancy_weight], strata(province)

svy: reg militancy_support treatment low_inc_dist_median high_inc_dist_median prov_2-prov_4 treatment_low_inc_dist_median treatment_high_inc_dist_median female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 if complete==1
est store ses1

lincom treatment + treatment_low_inc_dist_median
lincom treatment + treatment_high_inc_dist_median

cgmreg militancy_support treatment low_inc_dist_median high_inc_dist_median prov_2-prov_4 treatment_low_inc_dist_median treatment_high_inc_dist_median female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 if complete==1, cluster(province d24 spn)
est store ses2

lincom treatment + treatment_low_inc_dist_median
lincom treatment + treatment_high_inc_dist_median

xtmixed militancy_support treatment low_inc_dist_median high_inc_dist_median prov_2-prov_4 treatment_low_inc_dist_median treatment_high_inc_dist_median female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 if complete==1, ||  province:, covariance(independent) || d24:, covariance(independent) || spn:, covariance(independent) mle
 est store ses3

lincom treatment + treatment_low_inc_dist_median
lincom treatment + treatment_high_inc_dist_median

svy: reg militancy_support treatment low_inc_dist_median high_inc_dist_median prov_2-prov_4  treatment_low_inc_dist_median treatment_high_inc_dist_median female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 if complete==1
est store ses4

lincom treatment + treatment_low_inc_dist_median
lincom treatment + treatment_high_inc_dist_median

cgmreg militancy_support treatment low_inc_dist_median high_inc_dist_median prov_2-prov_4  treatment_low_inc_dist_median treatment_high_inc_dist_median female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 if complete==1, cluster(province d24 spn)
est store ses5

lincom treatment + treatment_low_inc_dist_median
lincom treatment + treatment_high_inc_dist_median

xtmixed militancy_support treatment low_inc_dist_median high_inc_dist_median prov_2-prov_4  treatment_low_inc_dist_median treatment_high_inc_dist_median female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2  if complete==1, ||  province:, covariance(independent) || d24:, covariance(independent) || spn:, covariance(independent) mle
est store ses6

lincom treatment + treatment_low_inc_dist_median
lincom treatment + treatment_high_inc_dist_median

estout ses1 ses2 ses3 using "results/TableOnlineApp7-LFSrobustness.doc", cells(b(fmt(%5.3f) star) se(fmt(%5.3f) par)) stat(r2 N) replace starlevels( + .1 * .05 ** .01 *** .001)

*******
** Next use retrospective evaluation of community economic situation

use "data_for_analysis.dta", clear

g sociotropic_retro = q130*-1 +6
g treatment_sociotropic_retro = treatment * sociotropic_retro

est drop *

svy: reg militancy_support treatment sociotropic_retro prov_2-prov_4 treatment_sociotropic_retro  if complete==1
est store ses1

svy: reg militancy_support treatment sociotropic_retro prov_2-prov_4  treatment_sociotropic_retro female married age online cellphone read write math educ2 sunni if complete==1
est store ses2

svy: reg militancy_support treatment sociotropic_retro prov_2-prov_4  treatment_sociotropic_retro female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 if complete==1
est store ses4

svy: reg militancy_support treatment sociotropic_retro prov_2-prov_4  treatment_sociotropic_retro female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 treatment_female treatment_married treatment_age treatment_online treatment_cellphone treatment_read treatment_write treatment_math treatment_educ2 treatment_sunni treatment_usviews1 treatment_usviews2 treatment_sharia_phys treatment_demvalues2 treatment_prov_2 treatment_prov_3 treatment_prov_4 if complete==1
est store ses5

estout ses* using "results/TableOnlineApp8-retrospective.doc", cells(b(fmt(%5.3f) star) se(fmt(%5.3f) par)) stat(r2 N) replace starlevels( + .1 * .05 ** .01 *** .001)

est drop *

svy: reg militancy_support treatment low_urprov high_urprov sociotropic_retro prov_2-prov_4  treatment_low_urprov treatment_high_urprov treatment_sociotropic_retro  if complete==1
est store ses1

svy: reg militancy_support treatment low_urprov high_urprov sociotropic_retro prov_2-prov_4  treatment_low_urprov treatment_high_urprov treatment_sociotropic_retro female married age online cellphone read write math educ2 sunni if complete==1
est store ses2

svy: reg militancy_support treatment low_urprov high_urprov sociotropic_retro prov_2-prov_4  treatment_low_urprov treatment_high_urprov treatment_sociotropic_retro female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 if complete==1
est store ses4

svy: reg militancy_support treatment low_urprov high_urprov sociotropic_retro prov_2-prov_4  treatment_low_urprov treatment_high_urprov treatment_sociotropic_retro female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 treatment_female treatment_married treatment_age treatment_online treatment_cellphone treatment_read treatment_write treatment_math treatment_educ2 treatment_sunni treatment_usviews1 treatment_usviews2 treatment_sharia_phys treatment_demvalues2 treatment_prov_2 treatment_prov_3 treatment_prov_4 if complete==1
est store ses5

estout ses* using "results/TableOnlineApp9-retrospectiveincomecontrol.doc", cells(b(fmt(%5.3f) star) se(fmt(%5.3f) par)) stat(r2 N) replace starlevels( + .1 * .05 ** .01 *** .001)


***
** Violence

use "data_for_analysis.dta", clear

decode d24, gen(d24text)
replace d24text=trim(d24text)
replace d24text="karachi" if d24text=="malir (karachi)" | d24text=="west (karachi)" | d24text=="south (karachi)" | d24text=="east (karachi)" | d24text=="central (karachi)"
drop d24
gen d24 = d24text
merge d24 using district_violence_data.dta, uniqusing _merge(_m_violence) sort
foreach x of varlist tot_milv-_b_milv_cas {
  ** This fixes zeros for places with no incidents recorded in the year before the survey. */
       replace `x'=0 if _m_violence==1
       }
* And then drop places with no surveys
drop if _m_violence==2

/// Defining Urban Violence

gen tot_milv3 = urban==1&tot_milv>0
gen treatment_tot_milv3 = treatment*tot_milv3
gen low_urprov_tot_milv3 = low_urprov*tot_milv3
gen high_urprov_tot_milv3 = high_urprov*tot_milv3
gen threeway_low_milv3 = treatment*tot_milv3*low_urprov
gen threeway_high_milv3 = treatment*tot_milv3*high_urprov

gen tot_milv4 = urban==1&tot_milv_cas>0
gen treatment_tot_milv4 = treatment*tot_milv4
gen low_urprov_tot_milv4 = low_urprov*tot_milv4
gen high_urprov_tot_milv4 = high_urprov*tot_milv4
gen threeway_low_milv4 = treatment*tot_milv4*low_urprov
gen threeway_high_milv4 = treatment*tot_milv4*high_urprov

/// Table Subsetting Data

est drop *

svyset spn [pweight=militancy_weight], strata(province)

svy: reg militancy_support treatment low_urprov high_urprov prov_2-prov_4  treatment_low_urprov treatment_high_urprov female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 if complete==1&tot_milv>0&urban==1
est store vio1

lincom treatment + treatment_low_urprov
lincom treatment + treatment_high_urprov

svy: reg militancy_support treatment low_urprov high_urprov prov_2-prov_4  treatment_low_urprov treatment_high_urprov female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 if complete==1&tot_milv>0&urban==0
est store vio2

lincom treatment + treatment_low_urprov
lincom treatment + treatment_high_urprov

svy: reg militancy_support treatment low_urprov high_urprov prov_2-prov_4  treatment_low_urprov treatment_high_urprov female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 if complete==1&tot_milv==0
est store vio3

lincom treatment + treatment_low_urprov
lincom treatment + treatment_high_urprov

svy: reg militancy_support treatment low_urprov high_urprov prov_2-prov_4  treatment_low_urprov treatment_high_urprov female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 if complete==1&tot_milv_cas>0&urban==1
est store vio4

lincom treatment + treatment_low_urprov
lincom treatment + treatment_high_urprov

svy: reg militancy_support treatment low_urprov high_urprov prov_2-prov_4  treatment_low_urprov treatment_high_urprov female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 if complete==1&tot_milv_cas>0&urban==0
est store vio5

lincom treatment + treatment_low_urprov
lincom treatment + treatment_high_urprov

svy: reg militancy_support treatment low_urprov high_urprov prov_2-prov_4  treatment_low_urprov treatment_high_urprov female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 if complete==1&tot_milv_cas==0
est store vio6

lincom treatment + treatment_low_urprov
lincom treatment + treatment_high_urprov

estout vio* using "results/Table5-violenceSubsetting.doc", cells(b(fmt(%5.3f) star) se(fmt(%5.3f) par)) stat(r2 N) replace starlevels( + .1 * .05 ** .01 *** .001)

///  Interaction Term Table

est drop *

svy: reg militancy_support prov_2-prov_4 treatment low_urprov  high_urprov  tot_milv3 low_urprov_tot_milv3 high_urprov_tot_milv3  treatment_low_urprov treatment_high_urprov treatment_tot_milv3  threeway_low_milv3 threeway_high_milv3 if complete==1
est store vio1

* Low violence
lincom treatment + treatment_low_urprov
lincom treatment 
lincom treatment + treatment_high_urprov

* High violence
lincom treatment + treatment_low_urprov + threeway_low_milv3 + treatment_tot_milv3
lincom treatment + treatment_tot_milv3
lincom treatment + treatment_high_urprov + threeway_high_milv3 + treatment_tot_milv3

svy: reg militancy_support prov_2-prov_4 female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 treatment low_urprov  high_urprov  tot_milv3 low_urprov_tot_milv3 high_urprov_tot_milv3  treatment_low_urprov treatment_high_urprov treatment_tot_milv3  threeway_low_milv3 threeway_high_milv3 if complete==1
est store vio2

* Low violence
lincom treatment + treatment_low_urprov
lincom treatment 
lincom treatment + treatment_high_urprov

* High violence
lincom treatment + treatment_low_urprov + threeway_low_milv3 + treatment_tot_milv3
lincom treatment + treatment_tot_milv3
lincom treatment + treatment_high_urprov + threeway_high_milv3 + treatment_tot_milv3

svy: reg militancy_support prov_2-prov_4 female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 treatment_female treatment_married treatment_age treatment_online treatment_cellphone treatment_read treatment_write treatment_math treatment_educ2 treatment_sunni treatment_usviews1 treatment_usviews2 treatment_sharia_phys treatment_demvalues2 treatment_prov_2 treatment_prov_3 treatment_prov_4  treatment low_urprov  high_urprov  tot_milv3 low_urprov_tot_milv3 high_urprov_tot_milv3  treatment_low_urprov treatment_high_urprov treatment_tot_milv3  threeway_low_milv3 threeway_high_milv3 if complete==1
est store vio3

* Low violence
lincom treatment + treatment_low_urprov
lincom treatment 
lincom treatment + treatment_high_urprov

* High violence
lincom treatment + treatment_low_urprov + threeway_low_milv3 + treatment_tot_milv3
lincom treatment + treatment_tot_milv3
lincom treatment + treatment_high_urprov + threeway_high_milv3 + treatment_tot_milv3

svy: reg militancy_support prov_2-prov_4 treatment low_urprov  high_urprov  tot_milv4 low_urprov_tot_milv4 high_urprov_tot_milv4  treatment_low_urprov treatment_high_urprov treatment_tot_milv4  threeway_low_milv4 threeway_high_milv4 if complete==1
est store vio4

* Low violence
lincom treatment + treatment_low_urprov
lincom treatment 
lincom treatment + treatment_high_urprov

* High violence
lincom treatment + treatment_low_urprov + threeway_low_milv4 + treatment_tot_milv4
lincom treatment + treatment_tot_milv4
lincom treatment + treatment_high_urprov + threeway_high_milv4 + treatment_tot_milv4

svy: reg militancy_support prov_2-prov_4 female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 treatment low_urprov  high_urprov  tot_milv4 low_urprov_tot_milv4 high_urprov_tot_milv4  treatment_low_urprov treatment_high_urprov treatment_tot_milv4  threeway_low_milv4 threeway_high_milv4 if complete==1
est store vio5

* Low violence
lincom treatment + treatment_low_urprov
lincom treatment 
lincom treatment + treatment_high_urprov

* High violence
lincom treatment + treatment_low_urprov + threeway_low_milv4 + treatment_tot_milv4
lincom treatment + treatment_tot_milv4
lincom treatment + treatment_high_urprov + threeway_high_milv4 + treatment_tot_milv4

svy: reg militancy_support prov_2-prov_4 female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 treatment_female treatment_married treatment_age treatment_online treatment_cellphone treatment_read treatment_write treatment_math treatment_educ2 treatment_sunni treatment_usviews1 treatment_usviews2 treatment_sharia_phys treatment_demvalues2 treatment_prov_2 treatment_prov_3 treatment_prov_4  treatment low_urprov  high_urprov  tot_milv4 low_urprov_tot_milv4 high_urprov_tot_milv4  treatment_low_urprov treatment_high_urprov treatment_tot_milv4  threeway_low_milv4 threeway_high_milv4 if complete==1
est store vio6

* Low violence
lincom treatment + treatment_low_urprov
lincom treatment 
lincom treatment + treatment_high_urprov

* High violence
lincom treatment + treatment_low_urprov + threeway_low_milv4 + treatment_tot_milv4
lincom treatment + treatment_tot_milv4
lincom treatment + treatment_high_urprov + threeway_high_milv4 + treatment_tot_milv4

estout vio* using "results/TableOnlineApp11-violenceInteraction.doc", cells(b(fmt(%5.3f) star) se(fmt(%5.3f) par)) stat(r2 N) replace starlevels( + .1 * .05 ** .01 *** .001)

/// Robustness to Model Choice

est drop *

svyset d24 [pweight=militancy_weight], strata(province)

svy: reg militancy_support prov_2-prov_4  female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 treatment low_urprov  high_urprov  tot_milv3 low_urprov_tot_milv3 high_urprov_tot_milv3  treatment_low_urprov treatment_high_urprov treatment_tot_milv3  threeway_low_milv3 threeway_high_milv3 if complete==1
est store vio1

cgmreg militancy_support prov_2-prov_4  female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 treatment low_urprov  high_urprov  tot_milv3 low_urprov_tot_milv3 high_urprov_tot_milv3 treatment_low_urprov treatment_high_urprov treatment_tot_milv3  threeway_low_milv3 threeway_high_milv3 if complete==1, cluster(province d24 spn)
est store vio2

xtmixed militancy_support prov_2-prov_4  female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 treatment low_urprov  high_urprov  tot_milv3 low_urprov_tot_milv3 high_urprov_tot_milv3 treatment_low_urprov treatment_high_urprov treatment_tot_milv3  threeway_low_milv3 threeway_high_milv3 if complete==1, ||  province:, covariance(independent) || d24:, covariance(independent) || spn:, covariance(independent) mle
 est store vio3

svy: reg militancy_support prov_2-prov_4 female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 treatment low_urprov  high_urprov  tot_milv4 low_urprov_tot_milv4 high_urprov_tot_milv4  treatment_low_urprov treatment_high_urprov treatment_tot_milv4  threeway_low_milv4 threeway_high_milv4 if complete==1
est store vio4

cgmreg militancy_support prov_2-prov_4 female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 treatment low_urprov  high_urprov  tot_milv4 low_urprov_tot_milv4 high_urprov_tot_milv4 treatment_low_urprov treatment_high_urprov treatment_tot_milv4  threeway_low_milv4 threeway_high_milv4 if complete==1, cluster(province d24 spn)
est store vio5

xtmixed militancy_support prov_2-prov_4  female married age online cellphone read write math educ2 sunni usviews1 usviews2 sharia_phys demvalues2 treatment low_urprov  high_urprov  tot_milv4 low_urprov_tot_milv4 high_urprov_tot_milv4 treatment_low_urprov treatment_high_urprov treatment_tot_milv4  threeway_low_milv4 threeway_high_milv4  if complete==1, ||  province:, covariance(independent) || d24:, covariance(independent) || spn:, covariance(independent) mle
est store vio6

estout vio* using "results/TableOnlineApp12-violenceModelChoice.doc", cells(b(fmt(%5.3f) star) se(fmt(%5.3f) par)) stat(r2 N) replace starlevels( + .1 * .05 ** .01 *** .001)


