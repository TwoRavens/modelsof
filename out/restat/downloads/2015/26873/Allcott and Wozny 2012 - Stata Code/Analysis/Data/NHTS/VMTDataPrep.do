/* VMTDataPrep.do */
/* This code imports the NHTS data. */
/* Notes:
We could increase VMT by 5% to account for 9-11 effect. This might be justified because the 2001 VMT unconditional average is 11,386, compared to 12,349 in 1995 and 12,671 in 1990. The VMT is unusually low. But DOE, in an e-mail from 4-2009, told us not to do this.
*/



/* IMPORT DATA */
/* 2001 NHTS */
/* Prepare Data */
insheet using Data/NHTS/VEHPUB.csv,clear
* keep bestmile annualzd annmiles best_out vehage vehtype vehyear eiadmpg epatmpg wthhfin wthhntl
keep annualzd annmiles vehage vehtype epatmpg wthhntl makecode modlcode vehyear readate1 readate2 od_read1 od_read2
* rename bestmile VMT
drop makecode modlcode vehyear

rename od_read1 OdRead1
rename annmiles EVMT
rename annualzd OVMT
rename vehage FutureAge /* This should be FutureAge to match the variable name in GetG.do */
rename wthhntl Weight

drop if vehtype==6|vehtype == 7|vehtype==91 /* Drop RV, motorcycle, and "other" vehicle types" */

gen NHTSClass = 0 /* Note that 0 will now cover "Other Truck," "Refused" and "Don't Know". It will correspond to "Missing" in the AutoPQX data, which I think is dropped anyway. */
replace NHTSClass = 1 if vehtype == 1
replace NHTSClass = 7 if vehtype == 3
replace NHTSClass = 910 if vehtype == 2
replace NHTSClass = 8 if vehtype == 4
drop vehtype

rename epatmpg MPG

/* Finish Dataset Construction */
** Drop anomalous or missing data
foreach var in EVMT OVMT FutureAge MPG OdRead1 {
replace `var'=. if `var'<=0
}

/* Adjust MPG to get EPA 2008 MPG, i.e. MPG08 in AutoPQX.dta */
* This relationship from taking EPAMPG.csv and doing: reg comb08 combined if combined>0&comb08>0
* The relationship appears to be v. good fit and linear in MPG, not GPM
replace MPG = .8590341*MPG + .8356074
gen FutureGPM = 1/MPG /* This should be called FutureGPM, and be in GPM, to match the variables in GetG.do */
drop MPG
save Data/NHTS/EVMTData.dta, replace


** Class dummies
xi i.NHTSClass, pre(_C)

** Age variables:
gen FutureAgeLE21=cond(FutureAge<=21,1,0)
gen FutureAgexLE21 = FutureAgeLE21*FutureAge


saveold Data/NHTS/EVMTData.dta, replace


/* REGRESSIONS THAT WILL BE RUN IN GETGI.DO: 
reg OVMT FutureGPM FutureAgexLE21 FutureAgeLE21 _C* [pweight = Weight], robust nocons
*/


/* NORMALIZE MANHEIM VMT */
/* For normalizing Manheim VMT, get odometer readings as a function of observables */
insheet using Data/NHTS/VEHPUB.csv,clear
keep vehage vehtype vehyear epatmpg wthhntl readate1 readate2 od_read1 od_read2

/* Data prep as above */
rename wthhntl Weight


drop if vehtype==6|vehtype == 7|vehtype==91 /* Drop RV, motorcycle, and "other" vehicle types" */
** Vehicle classes. 
gen NHTSClass = 0 /* Note that 0 will now cover "Other Truck," "Refused" and "Don't Know". It will correspond to "Missing" in the AutoPQX data, which I think is dropped anyway. */
replace NHTSClass = 1 if vehtype == 1
replace NHTSClass = 7 if vehtype == 3
replace NHTSClass = 910 if vehtype == 2
replace NHTSClass = 8 if vehtype == 4
drop vehtype


** Class dummies
xi i.NHTSClass, pre(_C)



/* MPG */
rename epatmpg MPG

** Adjust MPG to get EPA 2008 MPG, i.e. MPG08 in AutoPQX.dta
* This relationship from taking EPAMPG.csv and doing: reg comb08 combined if combined>0&comb08>0
* The relationship appears to be v. good fit and linear in MPG, not GPM
replace MPG = .8590341*MPG + .8356074
gen GPM = 1/MPG /* This should be called FutureGPM, and be in GPM, to match the variables in GetG.do */
drop MPG


/* Prepare Odometer read data */
rename od_read1 Odometer1
rename od_read2 Odometer2
rename readate1 OdometerReadDate1
rename readate2 OdometerReadDate2

gen i = _n

reshape long Odometer OdometerReadDate, i(i) j(read)


/* Finish Dataset Construction */
** Drop anomalous or missing data
foreach var in Odometer OdometerReadDate vehyear GPM {
replace `var'=. if `var'<=0|`var'>300000 /* Odometer read dates here go up to 200306 but want to drop Odometers at 999999 */
}

/* Generate Odometer Read */
gen OdometerReadYear = floor(OdometerReadDate/100)
gen OdometerReadMonth = OdometerReadDate-OdometerReadYear*100


/* Generate Age and Age polynomial */
gen Age = OdometerReadYear + OdometerReadMonth/12 - vehyear
forvalues e = 1/5 {
gen Age_`e' = Age^`e'
}


/* This code can be used to show that the age polynomial fits the age dummies very well
* But use the age polynomial because it fits to the more continuous fxn in months
gen _Age__1 = cond(floor(Age)==-1,1,0)
forvalues y = 0/30 {
gen _Age_`y' = cond(floor(Age)==`y',1,0)
}

reg Odometer Age_*
predict OPoly
reg Odometer _Age_*
predict ONP
twoway (scatter Age OPoly) (scatter Age ONP)
*/

reg Odometer Age_* GPM _C* [pweight = Weight], robust cluster(i)
estimates save Data/NHTS/OdometerEstimates.ster, replace
reg Odometer Age_* _C* [pweight = Weight], robust cluster(i)
reg Odometer Age_* [pweight = Weight], robust cluster(i)


saveold Data/NHTS/OdometerData.dta, replace

