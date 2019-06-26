*Note: This code replicates the summary statistics reported in Table A.II of our Supplemental Appendix

********************************************************************************************************************
*************************Generate Summary Statistics for All Relevant Conditions************************************
********************************************************************************************************************

*clear Stata and generate first set of summary statistics
clear
set more off

*read in data
use "\JPR Replication Files\Data\LOTL_Rep.dta", clear 

*drop nuisance years
drop if year>2009
drop if year<1997

keep if lagcivconflagtemp==1

collapse (sum) incidentacledfull, by(croplanddum)
*croplanddum	incidentacledfull
*0	22
*1	4331


*clear Stata and generate second set of summary statistics
clear
set more off

*read in data
use "\JPR Replication Files\Data\LOTL_Rep.dta", clear 

*drop nuisance years
drop if year>2009
drop if year<1997

keep if lagcivconflagtemp==0

collapse (sum) incidentacledfull, by(croplanddum)
*croplanddum	incidentacledfull
*0	38
*1	6974


*clear Stata and generate third set of summary statistics
clear
set more off

*read in data
use "\JPR Replication Files\Data\LOTL_Rep.dta", clear 

*drop nuisance years
drop if year>2009
drop if year<1997

keep if lagcivconflagtemp==1
drop croplanddum
generate croplanddum=0
replace croplanddum=1 if cropland>=15.225
replace croplanddum=. if cropland==.

collapse (sum) incidentacledfull, by(croplanddum)
*croplanddum	incidentacledfull
*0	627
*1	3726



*clear Stata and generate fourth set of summary statistics
clear
set more off

*read in data
use "\JPR Replication Files\Data\LOTL_Rep.dta", clear 

*drop nuisance years
drop if year>2009
drop if year<1997

keep if lagcivconflagtemp==0
drop croplanddum
generate croplanddum=0
replace croplanddum=1 if cropland>=15.225
replace croplanddum=. if cropland==.

collapse (sum) incidentacledfull, by(croplanddum)
*croplanddum	incidentacledfull
*0	1745
*1	6108


*clear Stata and generate fifth set of summary statistics
clear
set more off

*read in data
use "\JPR Replication Files\Data\LOTL_Rep.dta", clear 

*drop nuisance years
drop if year>2009
drop if year<1997

keep if lagcivconflagtemp==1
drop croplanddum
generate croplanddum=0
replace croplanddum=1 if cropland>=50
replace croplanddum=. if cropland==.

collapse (sum) incidentacledfull, by(croplanddum)
*croplanddum	incidentacledfull
*0	2522
*1	1831


*clear Stata and generate sixth set of summary statistics
clear
set more off

*read in data
use "\JPR Replication Files\Data\LOTL_Rep.dta", clear 

*drop nuisance years
drop if year>2009
drop if year<1997

keep if lagcivconflagtemp==0
drop croplanddum
generate croplanddum=0
replace croplanddum=1 if cropland>=50
replace croplanddum=. if cropland==.

collapse (sum) incidentacledfull, by(croplanddum)
*croplanddum	incidentacledfull
*0	6697
*1	1156

