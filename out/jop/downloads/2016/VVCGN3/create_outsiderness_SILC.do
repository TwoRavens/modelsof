**********************************************************************************************************
* Replication Code
* Sharing the Risk? Households, labor market vulnerability and social policy preferences in Western Europe
* Silja H�usermann, Thomas Kurer and Hanna Schwander
* Journal of Politics, 2016
**********************************************************************************************************

* Code to create group- and country specific outsiderness values based on EU-SILC data
* Files to merge EU-SILC and ESS-data are created and saved at the end of this script

version 13
cd "/Volumes/projects$/dualization/replicationJoP"
* Use EU-SILC 2007, Version 3 from 01-03-10
* confidentiality undertaking prohibits granting access to these data
* apply for microdata: http://tinyurl.com/gpkjs4t

use "UDB_c07P_ver 2007-3 from 01-03-10.dta"


***********************************************************************
* 1. Create occupational groups


(baseline groups for continuous measure of labor market vulnerability)*/
* 2. Create/Recode vulnerability variables
***********************************************************************

* 3. Create outsiderness
***********************************************************************

/* Atypical Dummy: Unemployment as a Form of atypical Employment*/

gen atypical=.
replace atypical=1 if temp_plus==1
replace atypical=1 if parttime==1
replace atypical=1 if pl040==4
replace atypical=1 if unempl==1

replace atypical=0 if pl030==1 & temp!=1

replace atypical=0 if pl031==1 & temp!=1 & pb020=="CH"

la var atypical "atypical dummy"

la de atypical 1 "atypical" 0 "NOT atypical", modify
la val atypical atypical

gen NOT_atypical = atypical==0
label variable NOT_atypical "Not atypically employed dummy"

label variable nr_cn "Number of atypically employed, by Country"

bysort exlgroup pb020: egen nr_not_cn = total(NOT_atypical)
label variable nr_not_cn "Number of NOT atypically employed, by Country"

gen nr_total_cn = nr_cn + nr_not_cn
label variable nr_total_cn "Number of atypically or NOT atypically employed people (total without missings), by Country"


* 3.2 Country averages of vulnerability 

* 3.3 "Normalized" group-specific values

** This is, group-specific rate - country average, i.e. relative vulnerability **

** This is an (unweighted) average of the three group-specific measures of relative vulnerability **

***********************************************************************
* 4. Export Outsiderness values
***********************************************************************

* Table of group- and country-specific values of outsiderness (to merge with ESS data)

table exlgroups pb020, content(mean outsiderness2c)

* save manually to excel (copy table)

* load excel table to reshape into long format

clear all
cd "/Volumes/projects$/dualization/replicationJoP"
import excel "outsiderness.xlsx", sheet("Blatt1") firstrow
rename * outsiderness2c*
rename outsiderness2cexlgroup exlgroups
reshape long outsiderness2c, i(exlgroups) j(cntry) string 
sort cntry exlgroups

* generate analoguous categories for partner's occupational group and outsiderness

* save file in .dta-format to merge with ESS data
save "outsiderness_tomerge.dta", replace

* save file for partner's outsiderness
rename exlgroups exlgroups_sp
rename outsiderness2c outsiderness2c_sp
save "outsiderness_sp_tomerge.dta", replace
