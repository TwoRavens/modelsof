
**THIS REPLICATES THE MAIN ANALYSES IN ``Peace from the Past"

***************************************************
**********           TABLE 1           ************
************  CROSS-Sectional MODELS   ************
***************************************************

**Picking up the group-level crosssectional data 
use "groupdataGROUPLEVEL.dta", clear

*creating variable labels
label variable JHordinal "Pre-colonial Centralization"
label variable rlsize "Relative size"
label variable animalhusbandry "Animal husbandry"
label variable agriculture "Agriculture"
label variable agridependence "Agridependence"
label variable lexlyrs "L(years active)"
label variable gathering "Gathering"
label variable nomadic "Nomadic"
label variable status_pwrrank "Power status"

*LOGITS - parsimonious model
set more off
logit onset JHordinal animalhusbandry agriculture agridependence lexlyrs i.countries_cowid
estimates store m1b

* --"-- including size
set more off
logit onset JHordinal rlsize animalhusbandry agriculture agridependence lexlyrs i.countries_cowid
estimates store m2b

* --"-- including the rest
set more off
logit onset JHordinal gathering nomadic rlsize animalhusbandry agriculture agridependence lexlyrs i.countries_cowid
estimates store m3b

* --"-- including powerrrank
set more off
logit onset JHordinal status_pwrrank gathering nomadic rlsize animalhusbandry agriculture agridependence lexlyrs i.countries_cowid
estimates store m4b




**effective N==123 (out of 152)
estout m1b m2b m3b m4b, cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) starlevels ( * 0.05 ** 0.01 *** 0.001) stats (aic ll N) style (tex) label





***************************************************
**********           TABLE 2           ************
************  TSCS FE LOGIT MODELS   **************
***************************************************
*TSCS FE LOGIT MODELS (TABLE 2)
clear
use "D:\Documents\groupdata3.dta", clear

*setting the panel unit
xtset countries_cowid

*creating variable labels
label variable JHordinal "Pre-colonial Centralization"
label variable rlsize "Relative size"
label variable animalhusbandry "Animal husbandry"
label variable agriculture "Agriculture"
label variable agridependence "Agridependence"
label variable gathering "Gathering"
label variable nomadic "Nomadic"
label variable status_pwrrank "Power status"
label variable peaceyears "Peace years"
label variable peaceyears2 "Peace years2"
label variable peaceyears3 "Peace years3"
label variable year "Year"

*excluding missing and non-excluded groups
drop if status_excl==0
set more off
logit onset JHordinal animalhusbandry agriculture agridependence peaceyears peaceyears2 peaceyears3 i.countries_cowid 
estimates store m0b

         * M1: Parsimonious model
set more off
logit onset JHordinal peaceyears peaceyears2 peaceyears3 year i.countries_cowid, cluster(cowgroupid) , if _est_m0b==1
estimates store m1
table onset 

         * M2: Including agriculture
set more off
logit onset JHordinal animalhusbandry agriculture agridependence peaceyears peaceyears2 peaceyears3 year i.countries_cowid, cluster(cowgroupid) , if _est_m0b==1
estimates store m2

         * M3: Including size + agriculture
set more off
logit onset JHordinal rlsize  animalhusbandry agriculture agridependence peaceyears peaceyears2 peaceyears3 year i.countries_cowid, cluster(cowgroupid) ,if _est_m0b==1
estimates store m3

         * M4: Including --"-- + gathering nomadic
set more off
logit onset JHordinal rlsize  animalhusbandry agriculture agridependence gathering nomadic peaceyears peaceyears2 peaceyears3 year i.countries_cowid, cluster(cowgroupid), if _est_m0b==1
estimates store m4


         * M5: Including --"-- more elaborate control for power status
set more off
logit onset JHordinal rlsize i.status_pwrrank animalhusbandry agriculture agridependence gathering nomadic peaceyears peaceyears2 peaceyears3 year i.countries_cowid, cluster(cowgroupid), if _est_m0b==1
estimates store m5 ,
 

*IV MODELS

         * M6:  IVPROBIT: Including --"-- + gathering nomadic
set more off
ivprobit onset rlsize i.status_pwrrank animalhusbandry agriculture agridependence gathering nomadic peaceyears peaceyears2 peaceyears3 year i.countries_cowid (JHordinal = ecodivsimple ), vce(cluster cowgroupid) , if _est_m0b==1
estimates store m6

         * M7:  2SLS: Including --"-- 
set more off
		 
ivregress 2sls onset rlsize i.status_pwrrank animalhusbandry agriculture agridependence gathering nomadic peaceyears peaceyears2 peaceyears3 year i.countries_cowid (JHordinal = ecodivsimple ), vce(cluster cowgroupid) , if _est_m0b==1
estimates store m7
estat firststage


estout   m1 m2 m3 m4 m5 m6 m7, cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) starlevels ( * 0.05 ** 0.01 *** 0.001) stats (aic ll N) style (tex) label




***************************************************
**********           TABLE 3           ************
************  Alternative Pathways   **************
***************************************************


 *CONTROLLING FOR ALTERNATIVE PATHWAYS (TABLE 3)
clear
use "groupdata3b.dta", clear

*setting the panel unit
xtset countries_cowid

*creating variable labels
label variable JHordinal "Pre-colonial Centralization"
label variable rlsize "Relative size"
label variable animalhusbandry "Animal husbandry"
label variable agriculture "Agriculture"
label variable agridependence "Agridependence"
label variable gathering "Gathering"
label variable nomadic "Nomadic"
label variable status_pwrrank "Power status"
label variable peaceyears "Peace years"
label variable peaceyears2 "Peace years2"
label variable peaceyears3 "Peace years3"
label variable year "Year"
label variable lmnt "Mountainous terrain"
label variable lbdist "L(Border ditance)"
label variable lcapdist "L(Capital distance)"
label variable spi6 "Drought index"
label variable lnrainrange "L(Rain range)"
label variable gathering "Gathering"
label variable nightlights_mean "Economic activity"
label variable ecodivmaj "Ecological diversity"

*gen log mountains


set more off
logit onset JHordinal animalhusbandry agriculture agridependence peaceyears peaceyears2 peaceyears3 i.countries_cowid if status_excl==1
estimates store m0b

set more off
*including mountainous terrain
logit onset JHordinal lmnt rlsize  animalhusbandry agriculture agridependence peaceyears peaceyears2 peaceyears3 year i.countries_cowid, cluster(cowgroupid) ,  if _est_m0b==1 & status_excl==1
estimates store m1c

* + capital distance
logit onset JHordinal lcapdist rlsize  animalhusbandry agriculture agridependence peaceyears peaceyears2 peaceyears3 year i.countries_cowid, cluster(cowgroupid) ,   if _est_m0b==1 & status_excl==1
estimates store m2c
 
* + border distance
logit onset JHordinal lbdist rlsize  animalhusbandry agriculture agridependence peaceyears peaceyears2 peaceyears3 year i.countries_cowid, cluster(cowgroupid) ,   if _est_m0b==1 & status_excl==1
estimates store m3c
 
* + drought index
logit onset JHordinal spi6 i.status_pwrrank rlsize animalhusbandry agriculture agridependence peaceyears peaceyears2 peaceyears3 year i.countries_cowid, cluster(cowgroupid) ,   if _est_m0b==1 & status_excl==1
estimates store m4c
 
* + nightlights_mean  
logit onset JHordinal nightlights_mean rlsize  animalhusbandry agriculture agridependence peaceyears peaceyears2 peaceyears3 year i.countries_cowid, cluster(cowgroupid) ,   if _est_m0b==1 & status_excl==1
estimates store m5c  
 
* + ln rain range
logit onset JHordinal lnrainrange rlsize  animalhusbandry agriculture agridependence peaceyears peaceyears2 peaceyears3 year i.countries_cowid, cluster(cowgroupid) ,   if _est_m0b==1 & status_excl==1
estimates store m6c  
 
* + ecological diversity
logit onset JHordinal ecodivmaj rlsize  animalhusbandry agriculture agridependence peaceyears peaceyears2 peaceyears3 year i.countries_cowid, cluster(cowgroupid) ,   if _est_m0b==1 & status_excl==1
estimates store m7c   

* + placebo
logit onset JHordinal rlsize animalhusbandry agriculture agridependence peaceyears peaceyears2 peaceyears3 year i.countries_cowid, cluster(cowgroupid) ,  if status_excl==0
estimates store m8c   
 

estout  m1c m2c m3c m4c m5c m6c m7c m8c, cells(b(star fmt(%9.3f)) t(par fmt(%9.2f))) starlevels ( * 0.05 ** 0.01 *** 0.001) stats (aic ll N) style (tex) label

 
 