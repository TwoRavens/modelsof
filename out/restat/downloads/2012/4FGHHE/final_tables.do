//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
// TABLE 2 output -- summary statistics by region
//_______________________________________________________

use "2004.2006_TRM_days15-35.dta", clear

drop if acdd == .
sum measure resident
bysort measuremen: gen num_houses = _n
count if num_houses ==1
bysort regions: count if num_houses ==1

bysort resident: gen num_tenant = _n
count if num_tenant ==1
bysort regions: count if num_tenant ==1

sum adc acdd ahdd
bysort regions: sum adc acdd ahdd 

//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
// TABLE 3 output -- ln_adc difference-in-differences
//_______________________________________________________

use "2004.2006_TRM_days15-35.dta", clear

// For the non-DST control group, we exclude electricity bills in the NW counties during Nov. and Dec. of 2006, 
// when and where there was a policy change due to the shifting of time zones, NZ_TZ==1
// We also exclude periods where the billing partially overlaps DST practice (bills ending in April and November)
drop if NZ_TZ==1 | DSTper==nonDSTper

// In order to account for the unbalanced panel, we first calculate averages within tenants and then average between tenants. 
collapse ln_adc, by(NE year3 DSTperiod resident)
bysort NE year3 DSTperiod: sum ln_adc

//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
// TABLE 4 output -- Natural Experiment DST period models
//_______________________________________________________

use "2004.2006_TRM_days15-35.dta", clear

drop if DSTperiod==0
tab month_id, gen(timeper)

// Model (a)
xtreg ln_adc overalltreat acdd ahdd timeper*, fe i(resident) cluster(county_billcy)

//Model (b)
gen acdd_NE = acdd*NE
gen ahdd_NE = ahdd*NE
xtreg ln_adc overalltreat acdd ahdd acdd_NE ahdd_NE timeper*, fe i(resident) cluster(county_billcy)

//Model (c)
gen ahdd_round = floor(ahdd)
gen acdd_round = floor(acdd)
recode ahdd_round 19=15 18=15 17=15 16=15
recode acdd_round 18=17
tab ahdd_round, gen(dahdd)
tab acdd_round, gen(dacdd)
xtreg ln_adc overalltreat dahdd2-dahdd16 dacdd2-dacdd18 timeper*, fe i(resident) cluster(county_billcy)

//Model (d)
gen sdahdd1 = dahdd1*NE
gen sdahdd2 = dahdd2*NE
gen sdahdd3 = dahdd3*NE
gen sdahdd4 = dahdd4*NE
gen sdahdd5 = dahdd5*NE
gen sdahdd6 = dahdd6*NE
gen sdahdd7 = dahdd7*NE
gen sdahdd8 = dahdd8*NE
gen sdahdd9 = dahdd9*NE
gen sdahdd10 = dahdd10*NE
gen sdahdd11 = dahdd11*NE
gen sdahdd12 = dahdd12*NE
gen sdahdd13 = dahdd13*NE
gen sdahdd14 = dahdd14*NE
gen sdahdd15 = dahdd15*NE
gen sdahdd16 = dahdd16*NE
gen sdacdd1 = dacdd1*NE
gen sdacdd2 = dacdd2*NE
gen sdacdd3 = dacdd3*NE
gen sdacdd4 = dacdd4*NE
gen sdacdd5 = dacdd5*NE
gen sdacdd6 = dacdd6*NE
gen sdacdd7 = dacdd7*NE
gen sdacdd8 = dacdd8*NE
gen sdacdd9 = dacdd9*NE
gen sdacdd10 = dacdd10*NE
gen sdacdd11 = dacdd11*NE
gen sdacdd12 = dacdd12*NE
gen sdacdd13 = dacdd13*NE
gen sdacdd14 = dacdd14*NE
gen sdacdd15 = dacdd15*NE
gen sdacdd16 = dacdd16*NE
gen sdacdd17 = dacdd17*NE
gen sdacdd18 = dacdd18*NE
gen inter0 = (dahdd1+dacdd1)*NE
xtreg ln_adc overalltreat dahdd2-dahdd16 dacdd2-dacdd18 inter0 sdahdd2-sdahdd16 sdacdd2-sdacdd18 timeper*, fe i(resident) cluster(county_billcy)

//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
// TABLE 5 output -- Quasi-counterfactual
//_______________________________________________________

use "2004.2006_TRM_days15-35.dta", clear

keep if nonDSTperiod==1

tab month_id, gen(timeper)
//gives timeper1-15

gen acdd_NE = acdd*NE
gen ahdd_NE = ahdd*NE

gen ahdd_round = floor(ahdd)
tab ahdd_round

//very little variation in acdd for winter months, so include without dummies
//merge categories with less than 1000 observations
recode ahdd_round 11=13 12=13 47=43 46=43 45=43 44=43

tab ahdd_round, gen(dahdd)
//gives dahdd1 - dahdd31

//create dummy for NW, december, in 2006
gen NWdec06 = 0
recode NWdec06 0=1 if NW==1 & billing_mo==12 & year3==1 

// Model (a)
xtreg ln_adc overalltreat NWdec06 acdd ahdd timeper2-timeper15, fe i(resident) cluster(county_billcy)

// Model (b)
xtreg ln_adc overalltreat NWdec06 acdd ahdd acdd_NE ahdd_NE timeper2-timeper15, fe i(resident) cluster(county_billcy)

// Model (c)
xtreg ln_adc overalltreat NWdec06 acdd dahdd2-dahdd31 timeper2-timeper15, fe i(resident) cluster(county_billcy)

// Model (d)
//create interactions for weather dummies
gen sdahdd1 = dahdd1*NE
gen sdahdd2 = dahdd2*NE
gen sdahdd3 = dahdd3*NE
gen sdahdd4 = dahdd4*NE
gen sdahdd5 = dahdd5*NE
gen sdahdd6 = dahdd6*NE
gen sdahdd7 = dahdd7*NE
gen sdahdd8 = dahdd8*NE
gen sdahdd9 = dahdd9*NE
gen sdahdd10 = dahdd10*NE
gen sdahdd11 = dahdd11*NE
gen sdahdd12 = dahdd12*NE
gen sdahdd13 = dahdd13*NE
gen sdahdd14 = dahdd14*NE
gen sdahdd15 = dahdd15*NE
gen sdahdd16 = dahdd16*NE
gen sdahdd17 = dahdd17*NE
gen sdahdd18 = dahdd18*NE
gen sdahdd19 = dahdd19*NE
gen sdahdd20 = dahdd20*NE
gen sdahdd21 = dahdd21*NE
gen sdahdd22 = dahdd22*NE
gen sdahdd23 = dahdd23*NE
gen sdahdd24 = dahdd24*NE
gen sdahdd25 = dahdd25*NE
gen sdahdd26 = dahdd26*NE
gen sdahdd27 = dahdd27*NE
gen sdahdd28 = dahdd28*NE
gen sdahdd29 = dahdd29*NE
gen sdahdd30 = dahdd30*NE
gen sdahdd31 = dahdd31*NE

xtreg ln_adc overalltreat NWdec06 acdd acdd_NE dahdd2-dahdd31 sdahdd2-sdahdd31 timeper2-timeper15, fe i(resident) cluster(county_billcy)

//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
// FIGURE 4 output -- monthly estimates (not apr & nov)
//_______________________________________________________

// First do months within the DST period of the year
use "2004.2006_TRM_days15-35.dta", clear
drop if DSTperiod==0
keep if billing_mo==5
xtreg ln_adc overalltreat acdd ahdd year2 year3, fe i(resident) cluster(county_billcy)

clear
use "2004.2006_TRM_days15-35.dta", clear
drop if DSTperiod==0
keep if billing_mo==6
xtreg ln_adc overalltreat acdd ahdd year2 year3, fe i(resident) cluster(county_billcy)

clear
use "2004.2006_TRM_days15-35.dta", clear
drop if DSTperiod==0
keep if billing_mo==7
xtreg ln_adc overalltreat acdd ahdd year2 year3, fe i(resident) cluster(county_billcy)

clear
use "2004.2006_TRM_days15-35.dta", clear
drop if DSTperiod==0
keep if billing_mo==8
xtreg ln_adc overalltreat acdd ahdd year2 year3, fe i(resident) cluster(county_billcy)

clear
use "2004.2006_TRM_days15-35.dta", clear
drop if DSTperiod==0
keep if billing_mo==9
xtreg ln_adc overalltreat acdd ahdd year2 year3, fe i(resident) cluster(county_billcy)

clear
use "2004.2006_TRM_days15-35.dta", clear
drop if DSTperiod==0
keep if billing_mo==10
xtreg ln_adc overalltreat acdd ahdd year2 year3, fe i(resident) cluster(county_billcy)

clear
use "2004.2006_TRM_days15-35.dta", clear
drop if DSTperiod==0
keep if billing_mo==11
xtreg ln_adc overalltreat acdd ahdd year2 year3, fe i(resident) cluster(county_billcy)

//Now do months NOT in the DST period of the year
use "2004.2006_TRM_days15-35.dta", clear
keep if nonDSTperiod==1

xtreg ln_adc overalltreat acdd ahdd year2 year3 if billing_mo==1, fe i(resident) cluster(county_billcy)
xtreg ln_adc overalltreat acdd ahdd year2 year3 if billing_mo==2, fe i(resident) cluster(county_billcy)
xtreg ln_adc overalltreat acdd ahdd year2 year3 if billing_mo==3, fe i(resident) cluster(county_billcy)

gen NWdec06 = NW*year3
xtreg ln_adc overalltreat NWdec06 acdd ahdd year2 year3 if billing_mo==12, fe i(resident) cluster(county_billcy)


//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
// FIGURE 5 output -- third-of-monthly ests (not apr & nov)
//_______________________________________________________

// First do periods within the DST period of the year
use "2004.2006_TRM_days15-35.dta", clear
drop if DSTperiod==0
keep if billing_mo==5
xtreg ln_adc overalltreat acdd ahdd year2 year3 if bill_time==1, fe i(resident) cluster(county_billcy)
xtreg ln_adc overalltreat acdd ahdd year2 year3 if bill_time==2, fe i(resident) cluster(county_billcy)
xtreg ln_adc overalltreat acdd ahdd year2 year3 if bill_time==3, fe i(resident) cluster(county_billcy)

clear
use "2004.2006_TRM_days15-35.dta", clear
drop if DSTperiod==0
keep if billing_mo==6
xtreg ln_adc overalltreat acdd ahdd year2 year3 if bill_time==1, fe i(resident) cluster(county_billcy)
xtreg ln_adc overalltreat acdd ahdd year2 year3 if bill_time==2, fe i(resident) cluster(county_billcy)
xtreg ln_adc overalltreat acdd ahdd year2 year3 if bill_time==3, fe i(resident) cluster(county_billcy)

clear
use "2004.2006_TRM_days15-35.dta", clear
drop if DSTperiod==0
keep if billing_mo==7
xtreg ln_adc overalltreat acdd ahdd year2 year3 if bill_time==1, fe i(resident) cluster(county_billcy)
xtreg ln_adc overalltreat acdd ahdd year2 year3 if bill_time==2, fe i(resident) cluster(county_billcy)
xtreg ln_adc overalltreat acdd ahdd year2 year3 if bill_time==3, fe i(resident) cluster(county_billcy)

clear
use "2004.2006_TRM_days15-35.dta", clear
drop if DSTperiod==0
keep if billing_mo==8
xtreg ln_adc overalltreat acdd ahdd year2 year3 if bill_time==1, fe i(resident) cluster(county_billcy)
xtreg ln_adc overalltreat acdd ahdd year2 year3 if bill_time==2, fe i(resident) cluster(county_billcy)
xtreg ln_adc overalltreat acdd ahdd year2 year3 if bill_time==3, fe i(resident) cluster(county_billcy)

clear
use "2004.2006_TRM_days15-35.dta", clear
drop if DSTperiod==0
keep if billing_mo==9
xtreg ln_adc overalltreat acdd ahdd year2 year3 if bill_time==1, fe i(resident) cluster(county_billcy)
xtreg ln_adc overalltreat acdd ahdd year2 year3 if bill_time==2, fe i(resident) cluster(county_billcy)
xtreg ln_adc overalltreat acdd ahdd year2 year3 if bill_time==3, fe i(resident) cluster(county_billcy)

clear
use "2004.2006_TRM_days15-35.dta", clear
drop if DSTperiod==0
keep if billing_mo==10
xtreg ln_adc overalltreat acdd ahdd year2 year3 if bill_time==1, fe i(resident) cluster(county_billcy)
xtreg ln_adc overalltreat acdd ahdd year2 year3 if bill_time==2, fe i(resident) cluster(county_billcy)
xtreg ln_adc overalltreat acdd ahdd year2 year3 if bill_time==3, fe i(resident) cluster(county_billcy)

clear
use "2004.2006_TRM_days15-35.dta", clear
drop if DSTperiod==0
keep if billing_mo==11
xtreg ln_adc overalltreat acdd ahdd year2 year3 if bill_time==1, fe i(resident) cluster(county_billcy)
xtreg ln_adc overalltreat acdd ahdd year2 year3 if bill_time==2, fe i(resident) cluster(county_billcy)
xtreg ln_adc overalltreat acdd ahdd year2 year3 if bill_time==3, fe i(resident) cluster(county_billcy)

// Now do periods NOT within the DST period of the year

use "2004.2006_TRM_days15-35.dta", clear
keep if nonDSTperiod==1
keep if billing_mo==1
xtreg ln_adc overalltreat acdd ahdd year2 year3 if bill_time==1, fe i(resident) cluster(county_billcy)
xtreg ln_adc overalltreat acdd ahdd year2 year3 if bill_time==2, fe i(resident) cluster(county_billcy)
xtreg ln_adc overalltreat acdd ahdd year2 year3 if bill_time==3, fe i(resident) cluster(county_billcy)

clear
use "2004.2006_TRM_days15-35.dta", clear
keep if nonDSTperiod==1
keep if billing_mo==2
xtreg ln_adc overalltreat acdd ahdd year2 year3 if bill_time==1, fe i(resident) cluster(county_billcy)
xtreg ln_adc overalltreat acdd ahdd year2 year3 if bill_time==2, fe i(resident) cluster(county_billcy)
xtreg ln_adc overalltreat acdd ahdd year2 year3 if bill_time==3, fe i(resident) cluster(county_billcy)

clear
use "2004.2006_TRM_days15-35.dta", clear
keep if nonDSTperiod==1
keep if billing_mo==3
xtreg ln_adc overalltreat acdd ahdd year2 year3 if bill_time==1, fe i(resident) cluster(county_billcy)
xtreg ln_adc overalltreat acdd ahdd year2 year3 if bill_time==2, fe i(resident) cluster(county_billcy)
xtreg ln_adc overalltreat acdd ahdd year2 year3 if bill_time==3, fe i(resident) cluster(county_billcy)

clear
use "2004.2006_TRM_days15-35.dta", clear
keep if nonDSTperiod==1
keep if billing_mo==12
gen NWdec06 = NW*year3
xtreg ln_adc overalltreat NWdec06 acdd ahdd year2 year3 if bill_time==1, fe i(resident) cluster(county_billcy)
xtreg ln_adc overalltreat NWdec06 acdd ahdd year2 year3 if bill_time==2, fe i(resident) cluster(county_billcy)
xtreg ln_adc overalltreat NWdec06 acdd ahdd year2 year3 if bill_time==3, fe i(resident) cluster(county_billcy)

//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
// TABLE 6 output -- Transition models
//_______________________________________________________

use "2004.2006_TRM_days15-35.dta", clear
keep if DSTperiod==0 & nonDSTperiod==0

//Spring
drop if billing_mo>5
gen days_dst = read_date - d(2apr2006) if read_year == 2006
replace days_dst = read_date - d(4apr2004) if read_year == 2004
replace days_dst = read_date - d(3apr2005) if read_year == 2005

drop if days_dst < 0
replace days_dst = 0 if NE==1 & read_year != 2006

gen frac_dst = days_dst/num_of_day
gen trt_frac = frac_dst*NE
xtreg ln_adc trt_frac ahdd acdd year2 year3 if trt_frac<1, fe i(resident) cluster(county_billcy)

//Fall
use "2004.2006_TRM_days15-35.dta", clear
keep if DSTperiod==0 & nonDSTperiod==0
drop if billing_mo<7

gen days_dst = num_of_day - (read_date - d(29oct2006)) if read_year == 2006
replace days_dst = num_of_day - (read_date - d(31oct2004)) if read_year == 2004
replace days_dst = num_of_day - (read_date - d(30oct2005)) if read_year == 2005
 
drop if days_dst < 0
replace days_dst = 0 if NE==1 & read_year != 2006

gen frac_dst = days_dst/num_of_day
gen trt_frac = frac_dst*NE
xtreg ln_adc trt_frac ahdd acdd year2 year3 if trt_frac<1, fe i(resident) cluster(county_billcy)
