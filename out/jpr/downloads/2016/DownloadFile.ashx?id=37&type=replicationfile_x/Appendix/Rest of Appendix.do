
*TSCS FE LOGIT MODELS (TABLE 2)
clear
use "D:\Documents\groupdata3.dta", clear

*setting the panel unit
xtset countries_cowid

****************************************
**********   TABLE A5         **********
*********ADDITIONAL CONTROLS  **********
****************************************
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





set more off
logit onset JHordinal animalhusbandry agriculture agridependence peaceyears peaceyears2 peaceyears3 i.countries_cowid if status_excl==1
estimates store m0b


*fishing
set more off
logit onset JHordinal fishing rlsize animalhusbandry agriculture agridependence peaceyears peaceyears2 peaceyears3 year i.countries_cowid, cluster(cowgroupid) , if _est_m0b==1
estimates store m1d
table onset if _est_m1d==1
distinct(cowgroupid) if _est_m1d==1



*slavery
logit onset JHordinal slavery rlsize animalhusbandry agriculture agridependence peaceyears peaceyears2 peaceyears3 year i.countries_cowid, cluster(cowgroupid) ,  if _est_m0b==1
estimates store m2d
table onset if _est_m2d==1
distinct(cowgroupid) if _est_m2d==1

*clan
logit onset JHordinal clan rlsize animalhusbandry agriculture agridependence peaceyears peaceyears2 peaceyears3 year i.countries_cowid, cluster(cowgroupid)  ,  if _est_m0b==1
estimates store m3d
table onset if _est_m3d==1
distinct(cowgroupid) if _est_m3d==1

*patrilineal
logit onset JHordinal patrilineal rlsize animalhusbandry agriculture agridependence peaceyears peaceyears2 peaceyears3 year i.countries_cowid, cluster(cowgroupid) ,  if _est_m0b==1 
estimates store m4d
table onset if _est_m4d==1
distinct(cowgroupid) if _est_m4d==1

*elections
logit onset JHordinal elections rlsize animalhusbandry agriculture agridependence peaceyears peaceyears2 peaceyears3 year i.countries_cowid, cluster(cowgroupid)  ,  if _est_m0b==1
estimates store m5d
table onset if _est_m5d==1
distinct(cowgroupid) if _est_m5d==1

*classtrat
logit onset JHordinal stratification rlsize animalhusbandry agriculture agridependence peaceyears peaceyears2 peaceyears3 year i.countries_cowid, cluster(cowgroupid)   ,  if _est_m0b==1
estimates store m6d
table onset if _est_m6d==1
distinct(cowgroupid) if _est_m6d==1

*hunting
logit onset JHordinal hunting rlsize animalhusbandry agriculture agridependence peaceyears peaceyears2 peaceyears3 year i.countries_cowid, cluster(cowgroupid)  ,  if _est_m0b==1
estimates store m7d
table onset if _est_m7d==1
distinct(cowgroupid) if _est_m7d==1

*alternative group GDP

logit onset JHordinal groupgdp rlsize animalhusbandry agriculture agridependence peaceyears peaceyears2 peaceyears3 year i.countries_cowid, cluster(cowgroupid)  ,  if _est_m0b==1
estimates store m8d
table onset if _est_m8d==1
distinct(cowgroupid) if _est_m8d==1


estout  m1d m2d m3d m4d m5d m6d m7d m8d using "addcontrols2.tex", cells(b(star fmt(%9.3f)) se(par fmt(%9.2f))) starlevels ( * 0.05 ** 0.01 *** 0.001) stats (aic ll N) style (tex) label 



****************************************************************************
**********             TABLE A7                                   **********
*********       REMOVING INFLUENTIAL OBSERVATIONS                 **********
****************************************************************************

**Done in R




****************************************************************************
**********             TABLE A8                                   **********
*********       IV MODELS: FIRST STAGE                            **********
****************************************************************************


**FIRST STAGE

      * M1: Parsimonious model
set more off
regress JHordinal ecodivsimple peaceyears peaceyears2 peaceyears3 year i.countries_cowid , vce(cluster cowgroupid) , if _est_m0b==1
estimates store m1i

         * M2: Including agriculture
set more off
regress JHordinal ecodivsimple animalhusbandry agriculture agridependence peaceyears peaceyears2 peaceyears3 year i.countries_cowid , vce(cluster cowgroupid) , if _est_m0b==1
estimates store m2i

         * M3: Including size 
set more off
regress JHordinal ecodivsimple rlsize animalhusbandry agriculture agridependence peaceyears peaceyears2 peaceyears3 year i.countries_cowid , vce(cluster cowgroupid) , if _est_m0b==1
estimates store m3i

         * M4: Including --"-- + gathering nomadic
set more off
regress JHordinal ecodivsimple rlsize animalhusbandry agriculture agridependence gathering nomadic peaceyears peaceyears2 peaceyears3 year i.countries_cowid , vce(cluster cowgroupid) , if _est_m0b==1
estimates store m4i

         * M5: Including --"-- more elaborate control for power status
set more off
regress  JHordinal ecodivsimple i.status_pwrrank rlsize animalhusbandry agriculture agridependence gathering nomadic peaceyears peaceyears2 peaceyears3 year i.countries_cowid , vce(cluster cowgroupid) , if _est_m0b==1
estimates store m5i


*checking first stage regression
ivregress 2sls onset rlsize animalhusbandry agridependence lsize peaceyears peaceyears2 peaceyears3 i.countries_cowid , vce(cluster cowgroupid) , if _est_m0b==1
estat firststage
estat endogenous


estout  m1i m2i m3i m4i m5i using "firststage3.tex" , cells(b(star fmt(%9.3f)) t(par fmt(%9.2f))) starlevels ( * 0.05 ** 0.01 *** 0.001) stats (aic ll N) style (tex) label


****************************************************************************
**********             TABLE A9                                   **********
*********       IV PROBIT MODELS ON CORE MODELS FROM TABLE 2      **********
****************************************************************************

        * M1: Parsimonious model
set more off
ivprobit onset peaceyears peaceyears2 peaceyears3 year i.countries_cowid (JHordinal = ecodivsimple ), vce(cluster cowgroupid) , if _est_m0b==1
estimates store m1f

         * M2: Including agriculture
set more off
ivprobit onset animalhusbandry agriculture agridependence peaceyears peaceyears2 peaceyears3 year i.countries_cowid (JHordinal = ecodivsimple ), vce(cluster cowgroupid) , if _est_m0b==1
estimates store m2f

         * M3: Including size 
set more off
ivprobit onset rlsize animalhusbandry agriculture agridependence peaceyears peaceyears2 peaceyears3 year i.countries_cowid (JHordinal = ecodivsimple ), vce(cluster cowgroupid) , if _est_m0b==1
estimates store m3f

         * M4: Including --"-- + gathering nomadic
set more off
ivprobit onset gathering nomadic rlsize animalhusbandry agriculture agridependence gathering nomadic peaceyears peaceyears2 peaceyears3 year i.countries_cowid (JHordinal = ecodivsimple ), vce(cluster cowgroupid) , if _est_m0b==1
estimates store m4f

         * M5: Including --"-- more elaborate control for power status
set more off
ivprobit onset i.status_pwrrank gathering nomadic rlsize animalhusbandry agriculture agridependence gathering nomadic peaceyears peaceyears2 peaceyears3 year i.countries_cowid (JHordinal = ecodivsimple ), vce(cluster cowgroupid) , if _est_m0b==1
estimates store m5f
 
 
estout m1f m2f m3f m4f m5f using "allIVprobits.tex", cells(b(star fmt(%9.3f)) t(par fmt(%9.2f))) starlevels ( * 0.05 ** 0.01 *** 0.001) stats (aic ll N) style (tex) label


****************************************************************
**********             TABLE A10                      **********
********* ALTERNATIVE PATHWAYS WITH IV PROBIT MODELS  **********
****************************************************************

 *CONTROLLING FOR ALTERNATIVE PATHWAYS WITH IV PROBIT MODELS

*including mountainous terrain
set more off
ivprobit onset lmnt rlsize  animalhusbandry agriculture agridependence peaceyears peaceyears2 peaceyears3 year i.countries_cowid (JHordinal = ecodivsimple ), vce(cluster cowgroupid) , if _est_m0b==1
estimates store m1d

table onset if _est_m1d==1
distinct(cowgroupid) if _est_m1d==1



* + capital distance
set more off
ivprobit onset lcapdist lmnt rlsize  animalhusbandry agriculture agridependence peaceyears peaceyears2 peaceyears3 year i.countries_cowid (JHordinal = ecodivsimple ), vce(cluster cowgroupid) , if _est_m0b==1
estimates store m2d
 
* + border distance
ivprobit onset lbdist lcapdist lmnt rlsize  animalhusbandry agriculture agridependence peaceyears peaceyears2 peaceyears3 year i.countries_cowid (JHordinal = ecodivsimple ), vce(cluster cowgroupid) , if _est_m0b==1
estimates store m3d

* + drought index
ivprobit onset spi6 lbdist lcapdist lmnt rlsize  animalhusbandry agriculture agridependence peaceyears peaceyears2 peaceyears3 year i.countries_cowid (JHordinal = ecodivsimple ), vce(cluster cowgroupid) , if _est_m0b==1
estimates store m4d
 
* + nightlights_mean  
ivprobit onset nightlights_mean spi6 lbdist lcapdist lmnt rlsize  animalhusbandry agriculture agridependence peaceyears peaceyears2 peaceyears3 year i.countries_cowid (JHordinal = ecodivsimple ), vce(cluster cowgroupid) , if _est_m0b==1
estimates store m5d
 
* + ln rain range
ivprobit onset lnrainrange nightlights_mean spi6 lbdist lcapdist lmnt rlsize  animalhusbandry agriculture agridependence peaceyears peaceyears2 peaceyears3 year i.countries_cowid (JHordinal = ecodivsimple ), vce(cluster cowgroupid) , if _est_m0b==1
estimates store m6d
 
table onset if _est_m6d==1
distinct(cowgroupid) if _est_m6d==1
 
 
estout  m1d m2d m3d m4d m5d m6d  using "IVprobit_altpathways.tex", cells(b(star fmt(%9.3f)) t(par fmt(%9.2f))) starlevels ( * 0.05 ** 0.01 *** 0.001) stats (aic ll N) style (tex) label

****************************************************************
**********             TABLE A11                      **********
*********      2SLS MODELS: ALL BASELINE MODELS       **********
****************************************************************
        * M1: Parsimonious model
set more off
ivregress 2sls onset peaceyears peaceyears2 peaceyears3 year i.countries_cowid (JHordinal = ecodivsimple ), cluster(cowgroupid) , if _est_m0b==1
estimates store m1g
table onset if _est_m1g==1
distinct(cowgroupid) if _est_m1g==1



         * M2: Including agriculture
set more off
ivregress 2sls onset animalhusbandry agriculture agridependence peaceyears peaceyears2 peaceyears3 year i.countries_cowid (JHordinal = ecodivsimple ), cluster(cowgroupid) , if _est_m0b==1
estimates store m2g

         * M3: Including size 
set more off
ivregress 2sls onset rlsize animalhusbandry agriculture agridependence peaceyears peaceyears2 peaceyears3 year i.countries_cowid (JHordinal = ecodivsimple ), cluster(cowgroupid) , if _est_m0b==1
estimates store m3g

         * M4: Including --"-- + gathering nomadic
set more off
ivregress 2sls onset gathering nomadic rlsize animalhusbandry agriculture agridependence gathering nomadic peaceyears peaceyears2 peaceyears3 year i.countries_cowid (JHordinal = ecodivsimple ), cluster(cowgroupid) , if _est_m0b==1
estimates store m4g

         * M5: Including --"-- more elaborate control for power status
set more off
ivregress 2sls onset i.status_pwrrank gathering nomadic rlsize animalhusbandry agriculture agridependence gathering nomadic peaceyears peaceyears2 peaceyears3 year i.countries_cowid (JHordinal = ecodivsimple ), cluster(cowgroupid) , if _est_m0b==1
estimates store m5g
 
 
estout m1g m2g m3g m4g m5g using "Linearmodels.tex" , cells(b(star fmt(%9.3f)) t(par fmt(%9.2f))) starlevels ( * 0.05 ** 0.01 *** 0.001) stats (aic ll N) style (tex) label


****************************************************************
**********             TABLE A13                     **********
*********       Additional tests                **********
****************************************************************


         * M1: Random intercept
set more off
xtlogit onset JHordinal rlsize i.status_pwrrank animalhusbandry agriculture agridependence gathering nomadic peaceyears peaceyears2 peaceyears3 year , i(cowgroupid) , if _est_m0b==1 
estimates store m1e 
table onset if _est_m1e==1
distinct(dyadid) if _est_m1e==1
 
 
         *Binary treatment variable 1
gen JHbin2 =.
replace JHbin2 = 1 if JHordinal > 1
replace JHbin2 = 0 if JHordinal <=1


logit onset JHbinary rlsize i.status_pwrrank animalhusbandry agriculture agridependence gathering nomadic peaceyears peaceyears2 peaceyears3 year i.countries_cowid if _est_m0b==1 
estimates store m2e 

 
         *top category removed
gen topcat =.
replace topcat = 1 if JHordinal > 2
replace topcat = 0 if JHordinal <3

logit onset JHordinal rlsize i.status_pwrrank animalhusbandry agriculture agridependence gathering nomadic peaceyears peaceyears2 peaceyears3 year  i.countries_cowid if _est_m0b==1 & topcat==0
estimates store m3e 

        *alternative size variable
logit onset JHordinal lsize i.status_pwrrank animalhusbandry agriculture agridependence gathering nomadic peaceyears peaceyears2 peaceyears3 year i.countries_cowid  if _est_m0b==1 
estimates store m4e 


estout  m1e m2e m3e m4e using "additionaltestsR&R32.tex" , cells(b(star fmt(%9.3f)) se(par fmt(%9.2f))) starlevels ( * 0.05 ** 0.01 *** 0.001) stats (aic ll N) style (tex) label 


****************************************************************
**********             TABLE A12                      **********
*********             DYADIC MODELS                   **********
****************************************************************

clear
use "D:\Documents\dyads2.dta", clear

xtset countries_cowid

*TSCS FE LOGIT MODELS (TABLE 2)

gen rlsize= lsizeMEG/lsizeEGIP

gen rlsize2 = lsizeMEG/population

*excluding missing
set more off
logit onset precolordinalMEG rlsize  animalhusbandryMEG agricultureMEG agridependenceMEG gatheringMEG huntingMEG nomadicMEG peaceyears peaceyears2 peaceyears3 year i.countries_cowid, cluster(dyadid) 
estimates store m0

label variable precolordinalMEG "Pre-colonial Centralization"
label variable rlsize "Relative size"
label variable animalhusbandryMEG "Animal husbandry"
label variable agricultureMEG "Agriculture"
label variable agridependenceMEG "Agridependence"
label variable gatheringMEG "Gathering"
label variable nomadicMEG "Nomadic"
label variable powestatusMEG "Power status"
label variable peaceyears "Peace years"
label variable peaceyears2 "Peace years2"
label variable peaceyears3 "Peace years3"
label variable year "Year"



         * M1: Parsimonious model
logit onset precolordinalMEG peaceyears peaceyears2 peaceyears3 year i.countries_cowid, cluster(dyadid) , if _est_m0==1
estimates store m1f
table onset if _est_m1f==1
distinct(dyadid) if _est_m1f==1


         * M2: Including agriculture
logit onset precolordinalMEG animalhusbandryMEG agricultureMEG agridependenceMEG peaceyears peaceyears2 peaceyears3 year i.countries_cowid, cluster(dyadid) ,  if _est_m0==1
estimates store m2f

         * M3: Including size + agriculture
logit onset precolordinalMEG rlsize  animalhusbandryMEG agricultureMEG agridependenceMEG peaceyears peaceyears2 peaceyears3 year i.countries_cowid, cluster(dyadid) ,  if _est_m0==1
estimates store m3f

         * M4: Including --"-- + gathering nomadic
logit onset precolordinalMEG rlsize  animalhusbandryMEG agricultureMEG agridependenceMEG gatheringMEG nomadicMEG peaceyears peaceyears2 peaceyears3 year i.countries_cowid, cluster(dyadid) , if _est_m0==1
estimates store m4f
table onset if _est_m4f==1
distinct(dyadid) if _est_m4f==1

         * M5: Including --"-- + precolEGIP
logit onset precolordinalMEG i.powestatusMEG rlsize  animalhusbandryMEG agricultureMEG agridependenceMEG gatheringMEG nomadicMEG peaceyears peaceyears2 peaceyears3 year i.countries_cowid, cluster(dyadid)  , if _est_m0==1
estimates store m5f 
 table onset if _est_m5f==1
distinct(dyadid) if _est_m5f==1
*IV PROBIT MODELS

* IV PROBIT RESULTS I: ENDOGENIZING PRE_COLONIAL CENTRALIZATION

    
         * M6: Including --"-- + gathering nomadic
ivprobit onset rlsize i.powestatusMEG animalhusbandryMEG  agricultureMEG agridependenceMEG gatheringMEG nomadicMEG peaceyears peaceyears2 peaceyears3 year i.countries_cowid (precolordinalMEG = ecodivsimpleMEG ), vce(cluster dyadid) , if _est_m0==1
estimates store m6f


ivregress 2sls onset rlsize i.powestatusMEG animalhusbandryMEG agricultureMEG agridependenceMEG gatheringMEG nomadicMEG peaceyears peaceyears2 peaceyears3 year i.countries_cowid (precolordinalMEG = ecodivsimpleMEG ), vce(cluster dyadid) , if _est_m0==1
estimates store m7f


estout   m1f m2f m3f m4f m5f m6f m7f using "dyadicmodels.tex", cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) starlevels ( * 0.05 ** 0.01 *** 0.001) stats (aic ll N) style (tex) label










