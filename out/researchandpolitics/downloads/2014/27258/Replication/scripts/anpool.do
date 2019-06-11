/*
==========================================================================
File-Name:    anpool.do
Date:         Sep 14, 2013
Author:       Fernando Martel                                 
Purpose:      Analyze whether Gulf States belong in pooled model
Data Input:   stackfr   // Stack if imputed and orignial datasets.  I use
                        // Ross's population, Polity, and forward lag to
                        // show what happens under Ross's own procedures
Output File:  
Data Output:  none
Previous file:proc_rep_master.do
Status:       Complete                                     
Machine:      Lenovo, X201 tablet running Windows 7 64-bit spck 1
==========================================================================
*/

clear
global path ///
C:\Users\Fernando\Documents\docs\research_projects\Replication\analysis
cd "$path"

* =========================================================================
* Test restriction for polling Gulf states
* Need to test over 5 imputed datasets to get right confidence intervals
* Will weight the sum of squares across imputations to compute F test
* One way is to stack them 
* =========================================================================
  
use stackfr   //This uses Ross's population 

* For some reason option xbu for predict not working with mim and xtreg fe
* I will work with reg and country dummies
* generate country dummies
tabulate ctycode, gen(IDdum)


*Flag Gulf states
*----------------
generate gulf = 0
replace gulf = 1 if ctycode=="ARE" | ctycode=="QAT" | ctycode=="KWT" ///
| ctycode=="SAU" | ctycode=="OMN" | ctycode=="BHR" 

set matsize 5915


*Estimate restricted (i.e pooled) model and compute residual sum squares
*-----------------------------------------------------------------------
mim, sto: reg lnCMRwdi lngdppercap_1 lnhiv_1 lndensity_1 gdpgrowth_1 polityross_1 dperiod* IDd*
estimates store res
mim: predict yhatres, xb  // generate linear predicted yhat
su yhatres

gen eres = lnCMRwdi - yhatres if _mj!=0  // generate residuals
mkmat eres if _mj!=0  //exclude original data
mat RSS_res= 1/5*eres' *1/5 *eres


*Estimate unrestricted (i.e unpooled) model and compute residual sum squares
*---------------------------------------------------------------------------
mim, sto: reg lnCMRwdi lngdppercap_1 lnhiv_1 lndensity_1 gdpgrowth_1 polityross_1 dperiod* IDd* ///
   if gulf==1 //Gulf model
estimates store gulf
mim: predict yhatgulf, xb
gen egulf = lnCMRwdi - yhatgulf if _mj!=0 & gulf==1
mkmat egulf if _mj!=0 & gulf==1 //exclude original data
mat RSS_gulf = 1/5*egulf' *1/5 *egulf

mim, sto: reg lnCMRwdi lngdppercap_1 lnhiv_1 lndensity_1 gdpgrowth_1 polityross_1 dperiod* IDd* ///
   if gulf==0  //Other model
estimates store other
mim: predict yhatother, xb
gen eother = lnCMRwdi - yhatother if _mj!=0
mkmat eother if _mj!=0 & gulf==0 //exclude original data
mat RSS_other = 1/5*eother' *1/5 *eother

*Tabulate model results
*----------------------
estimates table res gulf other, stats(N) b(%7.3f) se(%8.3f) 
estimates table res gulf other, stats(N) b(%7.3f) star(.1 .05 .01) 


*Compute F test - Rejects null of restricted model
*-------------------------------------------------
* Compute number of observations
su _mi if _mj==1

#delimit;
di ((RSS_res[1,1] - (RSS_gulf[1,1]+RSS_other[1,1]))/12)  / 
   (((RSS_gulf[1,1]+RSS_other[1,1]))/(`r(max)'-24));
#delimit cr
di invF(12,`r(max)',.95)
di invF(12,`r(max)',.99)
mat list RSS_other
mat list RSS_res
mat list RSS_gulf


*Compute average GDP per capita
*------------------------------
gen temp = exp(lngdppercap_1)
su temp if _mj!=0
su temp if _mj!=0 & gulf==1
su temp if _mj!=0 & gulf==0


* =========================================================================
* REPEAT USING ACLP POPULATION
* Test restriction for polling Gulf states
* Need to test over 5 imputed datasets to get right confidence intervals
* Will weight the sum of squares across imputations to compute F test
* One way is to stack them 
* =========================================================================
clear
use stackca   //This uses CLP population to check results using ACLP 
              
* For some reason option xbu for predict not working with mim and xtreg fe
* I will work with reg and country dummies
* generate country dummies
tabulate ctycode, gen(IDdum)


*Flag Gulf states
*----------------
generate gulf = 0
replace gulf = 1 if ctycode=="ARE" | ctycode=="QAT" | ctycode=="KWT" ///
| ctycode=="SAU" | ctycode=="OMN" | ctycode=="BHR" // | ctycode=="LBY" | ctycode=="CUB"

set matsize 5915


*Estimate restricted (i.e pooled) model and compute residual sum squares
*-----------------------------------------------------------------------
mim, sto: reg lnCMRunicef lngdppercap_1 lnhiv_1 lndensity_1 gdpgrowth_1 polity_1 dperiod* IDd*
estimates store res
mim: predict yhatres, xb  // generate linear predicted yhat
su yhatres

gen eres = lnCMRunicef - yhatres if _mj!=0  // generate residuals
mkmat eres if _mj!=0  //exclude original data
mat RSS_res= 1/5*eres' *1/5 *eres


*Estimate unrestricted (i.e unpooled) model and compute residual sum squares
*---------------------------------------------------------------------------
mim, sto: reg lnCMRunicef lngdppercap_1 lnhiv_1 lndensity_1 gdpgrowth_1 polity_1 dperiod* IDd* ///
   if gulf==1 //Gulf model
estimates store gulf
mim: predict yhatgulf, xb

gen egulf = lnCMRunicef - yhatgulf if _mj!=0 & gulf==1
mkmat egulf if _mj!=0 & gulf==1 //exclude original data
mat RSS_gulf = 1/5*egulf' *1/5 *egulf

mim, sto: reg lnCMRunicef lngdppercap_1 lnhiv_1 lndensity_1 gdpgrowth_1 polity_1 dperiod* IDd* ///
   if gulf==0  //Other model
estimates store other
mim: predict yhatother, xb
gen eother = lnCMRunicef - yhatother if _mj!=0
mkmat eother if _mj!=0 & gulf==0 //exclude original data
mat RSS_other = 1/5*eother' *1/5 *eother

*Tabulate model results
*----------------------
estimates table res gulf other, stats(N) b(%7.3f) se(%8.3f) 
estimates table res gulf other, stats(N) b(%7.3f) star(.1 .05 .01) 


*Compute F test - Rejects null of restricted model
*-------------------------------------------------
* Compute number of observations
su _mi if _mj==1

#delimit;
di ((RSS_res[1,1] - (RSS_gulf[1,1]+RSS_other[1,1]))/12)  / 
   (((RSS_gulf[1,1]+RSS_other[1,1]))/(`r(max)'-24));
#delimit cr
di invF(12+168,`r(max)',.95)
di invF(12,`r(max)',.99)
mat list RSS_other
mat list RSS_res
mat list RSS_gulf


*Compute average GDP per capita
*------------------------------
gen temp = exp(lngdppercap_1)
su temp if _mj!=0
su temp if _mj!=0 & gulf==1
su temp if _mj!=0 & gulf==0


/*
==========================================================================
OPTIONS 2: ACLP population of country years
           My polity variable created from Ross's annual data
           Centered quinquennial data
           UNICEF CMR
==========================================================================
*/

*Column 1 - LDV only with panel specific autocorrelation*;
mim, category(fit)  storebv: xtpcse lnCMRunicef lnCMRunicef_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1 if gulf==0, corr(psar1)
estimates store m1

*Column 2 - LDV only with panel specific autocorrelation and polity*;
mim, category(fit)  storebv: xtpcse lnCMRunicef lnCMRunicef_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1 polity_1 if gulf==0, corr(psar1) 
estimates store m2

*Column 3 - LDV and period dummies
mim, category(fit)  storebv: xtpcse lnCMRunicef lnCMRunicef_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1 polity_1 dperiod* if gulf==0, corr(psar1) 
estimates store m3

*Column 4 - FE & period dummies*;
mim, storebv: xtreg lnCMRunicef lngdppercap_1 lnhiv_1 lndensity_1 ///
     gdpgrowth_1 polity_1 dperiod* if gulf==0, fe vce(robust)
estimates store m4

*Column 5 - LDV only and democratic years*;
mim, category(fit) storebv: xtpcse lnCMRunicef lnCMRunicef_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1 lndemyears_1 if gulf==0, corr(psar1) 
estimates store m5

*Column 6 - LDV and democratic years and period dummies*;
mim, category(fit) storebv: xtpcse lnCMRunicef lnCMRunicef_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1 lndemyears_1 dperiod* if gulf==0, corr(psar1)  
estimates store m6

*Column 7 - FE & democratic years & period dummies*;
mim, storebv: xtreg lnCMRunicef lngdppercap_1 lnhiv_1 lndensity_1 ///
     gdpgrowth_1 lndemyears_1 dperiod* if gulf==0, fe robust 
estimates store m7

estimates table m1 m2 m3 m4 m5 m6 m7, stats(N) b(%7.3f) se(%8.3f) 
estimates table m1 m2 m3 m4 m5 m6 m7, stats(N) b(%7.3f) star(.1 .05 .01)