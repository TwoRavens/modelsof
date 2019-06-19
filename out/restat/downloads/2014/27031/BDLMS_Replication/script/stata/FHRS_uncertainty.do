
* Uncertainty in Fisher, Hanemann, Roberts, Schlenker 2010/2012
* Focusing on their yield regression with year FE and their reconstructed data, 
*	This is Specification 1b in Table 1

clear
set memory 100m
set more off

* INSERT DIRECTORY WHERE REPLICATION FILE WAS UNZIPPED INTO QUOTATION MARKS:
cd ""
cd data/FHRS/

use DATA1, clear
drop sst* state
* merge in corrected weather data from Schlenker et al 2009
merge 1:1 fips year using dataPanelNew
drop _merge

* create variables
gen yield = corn_prod/corn_planted
gen dry_dd89dm=   (dry==1)*dday8_32dm
gen dry_dd89dm_sq=(dry==1)*dday8_32dm*dday8_32dm
gen dry_prec =    (dry==1)*prec
gen dry_prec_sq=  (dry==1)*prec*prec
gen irr_dd89dm=   (dry==0)*dday8_32dm
gen irr_dd89dm_sq=(dry==0)*dday8_32dm*dday8_32dm
gen irr_prec =    (dry==0)*prec
gen irr_prec_sq=  (dry==0)*prec*prec


* write out some variables we need to evaluate climate projections
outsheet fips year yield dday8_32dm prec dry corn_planted using fhrs_data.csv, comma replace 

* keep slimmed down version of data for running bootstrap
keep yield dry_dd89dm dry_dd89dm_sq dry_prec dry_prec_sq irr_dd89dm irr_dd89dm_sq irr_prec irr_prec_sq dry x1-x9 corn_planted year fips
save bootsample, replace

* bootstrap regression 1000 times, saving coefficients
clear
set seed 42
capture postutil clear
postfile boot runum dry_dd89_b dry_dd89_sq_b dry_prcp_b dry_prcp_sq_b ///
		irr_dd89_b irr_dd89_sq_b irr_prcp_b irr_prcp_sq_b using boot_fhrs, replace
forvalues i = 1/1000 {
	use bootsample, clear
	bsample  //draw a sample of equal size, with replacement
	qui areg yield dry_dd89dm dry_dd89dm_sq dry_prec dry_prec_sq irr_dd89dm ///
		irr_dd89dm_sq irr_prec irr_prec_sq dry x1-x9 i.year [aweight=corn_planted], a(fips) 
	post boot (`i') (_b[dry_dd89dm]) (_b[dry_dd89dm_sq])  (_b[dry_prec]) (_b[dry_prec_sq])  (_b[irr_dd89dm]) ///
		 (_b[irr_dd89dm_sq]) (_b[irr_prec])  (_b[irr_prec_sq]) 
	di `i'
	}
postclose boot

* write out a copy that we will use to evaluate climate projections
use boot_fhrs, clear
outsheet using boot_fhrs.csv, comma replace
