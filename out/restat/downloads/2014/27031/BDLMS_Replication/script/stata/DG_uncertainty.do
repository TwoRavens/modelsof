
* Our replication of Deschenes and Greenstone 2007
* We focus on their profits regression with state-by-year FE, which would be the regression underneath Col 4 in Table 5.

clear all
set mem 100m
set more off

* INSERT DIRECTORY WHERE REPLICATION FILE WAS UNZIPPED INTO QUOTATION MARKS:
cd ""
cd data/DG/

use DATA1

*** Create variables following their script
gen y=(rtfsale-rtotexp)*1000/fland
gen dry_dd89=    (dry==1)*dd89
gen dry_dd89_sq= (dry==1)*dd89*dd89
gen dry_prcp=    (dry==1)*prcp
gen dry_prcp_sq= (dry==1)*prcp*prcp
gen irr_dd89=    (dry==0)*dd89
gen irr_dd89_sq= (dry==0)*dd89*dd89
gen irr_prcp=    (dry==0)*prcp
gen irr_prcp_sq= (dry==0)*prcp*prcp

* write out some variables we need to evaluate climate projections
outsheet fips year y dd89 prcp dry fland using dg_data.csv, comma replace 

* keep slimmed down version of data for running bootstrap
keep y dry_dd89 dry_dd89_sq dry_prcp dry_prcp_sq irr_dd89 irr_dd89_sq irr_prcp irr_prcp_sq dry x1-x9 sst* fland fips
save bootsample, replace


* bootstrap regression 1000 times, saving coefficients
clear
set seed 42
capture postutil clear
postfile boot runum dry_dd89_b dry_dd89_sq_b dry_prcp_b dry_prcp_sq_b ///
		irr_dd89_b irr_dd89_sq_b irr_prcp_b irr_prcp_sq_b using boot_dg, replace
forvalues i = 1/1000 {
	use bootsample, clear
	bsample  //draw a sample of equal size, with replacement
	qui areg y dry_dd89 dry_dd89_sq dry_prcp dry_prcp_sq ///
		irr_dd89 irr_dd89_sq irr_prcp irr_prcp_sq dry x1-x9 sst* [weight=fland], a(fips) 
	post boot (`i') (_b[dry_dd89]) (_b[dry_dd89_sq])  (_b[dry_prcp]) (_b[dry_prcp_sq])  (_b[irr_dd89]) ///
		 (_b[irr_dd89_sq]) (_b[irr_prcp])  (_b[irr_prcp_sq]) 
	di `i'
	}
postclose boot

* write out a copy that we will use to evaluate climate projections
use boot_dg, clear
outsheet using boot_dg.csv, comma replace
