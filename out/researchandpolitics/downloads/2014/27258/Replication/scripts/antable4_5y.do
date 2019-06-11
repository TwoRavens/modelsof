/*
==========================================================================
File-Name:    antable4_5y.do
Date:         Sep 13, 2013
Author:       Fernando Martel                                 
Purpose:      Replicate Table 4 in Ross(2006) using multiply imputed data
Data Input:   stackca.dta // ACLP population, centered quinquennia
              stackfr.dta // Ross population, forward quinqunnia
Output File:  none
Data Output:  none
Previous file:proc_rep_master.do
Status:       In progress                                     
Machine:      Lenovo X201 tablet running Windows 7 64-bit spck 1
==========================================================================
*/

clear
global path ///
C:\Users\Fernando\Documents\docs\research_projects\Replication\analysis
cd "$path"


* USE ACLP population of sovereign country years
* ----------------------------------------------
clear
use stackca


/*
==========================================================================
OPTIONS 1: ACLP population of country years
           My polity variable created from Ross's annual data
           Centered quinquennial data
           WDI CMR
==========================================================================
*/

*Column 1 - LDV only with panel specific autocorrelation*;
mim, category(fit)  storebv: xtpcse lnCMRwdi lnCMRwdi_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1, corr(psar1)
estimates store m1

*Column 2 - LDV only with panel specific autocorrelation and polity*;
mim, category(fit)  storebv: xtpcse lnCMRwdi lnCMRwdi_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1 polity_1, corr(psar1) 
estimates store m2

*Column 3 - LDV and period dummies
mim, category(fit)  storebv: xtpcse lnCMRwdi lnCMRwdi_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1 polity_1 dperiod*, corr(psar1) 
estimates store m3

*Column 4 - FE & period dummies*;
mim, storebv: xtreg lnCMRwdi lngdppercap_1 lnhiv_1 lndensity_1 ///
     gdpgrowth_1 polity_1 dperiod*, fe vce(robust)
estimates store m4

*Column 5 - LDV only and democratic years*;
mim, category(fit) storebv: xtpcse lnCMRwdi lnCMRwdi_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1 lndemyears_1, corr(psar1) 
estimates store m5

*Column 6 - LDV and democratic years and period dummies*;
mim, category(fit) storebv: xtpcse lnCMRwdi lnCMRwdi_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1 lndemyears_1 dperiod*, corr(psar1)  
estimates store m6

*Column 7 - FE & democratic years & period dummies*;
mim, storebv: xtreg lnCMRwdi lngdppercap_1 lnhiv_1 lndensity_1 ///
     gdpgrowth_1 lndemyears_1 dperiod*, fe robust 
estimates store m7

estimates table m1 m2 m3 m4 m5 m6 m7, stats(N) b(%7.3f) se(%8.3f) 



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
     lnhiv_1 lndensity_1 gdpgrowth_1, corr(psar1)
estimates store m1

*Column 2 - LDV only with panel specific autocorrelation and polity*;
mim, category(fit)  storebv: xtpcse lnCMRunicef lnCMRunicef_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1 polity_1, corr(psar1) 
estimates store m2

*Column 3 - LDV and period dummies
mim, category(fit)  storebv: xtpcse lnCMRunicef lnCMRunicef_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1 polity_1 dperiod*, corr(psar1) 
estimates store m3

*Column 4 - FE & period dummies*;
mim, storebv: xtreg lnCMRunicef lngdppercap_1 lnhiv_1 lndensity_1 ///
     gdpgrowth_1 polity_1 dperiod*, fe vce(robust)
estimates store m4

*Column 5 - LDV only and democratic years*;
mim, category(fit) storebv: xtpcse lnCMRunicef lnCMRunicef_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1 lndemyears_1, corr(psar1) 
estimates store m5

*Column 6 - LDV and democratic years and period dummies*;
mim, category(fit) storebv: xtpcse lnCMRunicef lnCMRunicef_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1 lndemyears_1 dperiod*, corr(psar1)  
estimates store m6

*Column 7 - FE & democratic years & period dummies*;
mim, storebv: xtreg lnCMRunicef lngdppercap_1 lnhiv_1 lndensity_1 ///
     gdpgrowth_1 lndemyears_1 dperiod*, fe robust 
estimates store m7

estimates table m1 m2 m3 m4 m5 m6 m7, stats(N) b(%7.3f) se(%8.3f) 



/*
==========================================================================
OPTIONS 3: ACLP population of country years
           My polity variable created from Ross's annual data
           Centered quinquennial data
           WHO CMR
==========================================================================
*/

*Column 1 - LDV only with panel specific autocorrelation*;
mim, category(fit)  storebv: xtpcse lnCMRwho lnCMRwho_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1, corr(psar1)
estimates store m1

*Column 2 - LDV only with panel specific autocorrelation and polity*;
mim, category(fit)  storebv: xtpcse lnCMRwho lnCMRwho_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1 polity_1, corr(psar1) 
estimates store m2

*Column 3 - LDV and period dummies
mim, category(fit)  storebv: xtpcse lnCMRwho lnCMRwho_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1 polity_1 dperiod*, corr(psar1) 
estimates store m3

*Column 4 - FE & period dummies*;
mim, storebv: xtreg lnCMRwho lngdppercap_1 lnhiv_1 lndensity_1 ///
     gdpgrowth_1 polity_1 dperiod*, fe vce(robust)
estimates store m4

*Column 5 - LDV only and democratic years*;
mim, category(fit) storebv: xtpcse lnCMRwho lnCMRwho_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1 lndemyears_1, corr(psar1) 
estimates store m5

*Column 6 - LDV and democratic years and period dummies*;
mim, category(fit) storebv: xtpcse lnCMRwho lnCMRwho_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1 lndemyears_1 dperiod*, corr(psar1)  
estimates store m6

*Column 7 - FE & democratic years & period dummies*;
mim, storebv: xtreg lnCMRwho lngdppercap_1 lnhiv_1 lndensity_1 ///
     gdpgrowth_1 lndemyears_1 dperiod*, fe robust 
estimates store m7

estimates table m1 m2 m3 m4 m5 m6 m7, stats(N) b(%7.3f) se(%8.3f) 


/*
==========================================================================
OPTIONS 4: ACLP population of country years
           My polity variable created from Ross's annual data
           Centered quinquennial data
           WDI IMR
==========================================================================
*/

*Column 1 - LDV only with panel specific autocorrelation*;
mim, category(fit)  storebv: xtpcse lnIMRwdi lnIMRwdi_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1, corr(psar1)
estimates store m1

*Column 2 - LDV only with panel specific autocorrelation and polity*;
mim, category(fit)  storebv: xtpcse lnIMRwdi lnIMRwdi_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1 polity_1, corr(psar1) 
estimates store m2

*Column 3 - LDV and period dummies
mim, category(fit)  storebv: xtpcse lnIMRwdi lnIMRwdi_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1 polity_1 dperiod*, corr(psar1) 
estimates store m3

*Column 4 - FE & period dummies*;
mim, storebv: xtreg lnIMRwdi lngdppercap_1 lnhiv_1 lndensity_1 ///
     gdpgrowth_1 polity_1 dperiod*, fe vce(robust)
estimates store m4

*Column 5 - LDV only and democratic years*;
mim, category(fit) storebv: xtpcse lnIMRwdi lnIMRwdi_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1 lndemyears_1, corr(psar1) 
estimates store m5

*Column 6 - LDV and democratic years and period dummies*;
mim, category(fit) storebv: xtpcse lnIMRwdi lnIMRwdi_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1 lndemyears_1 dperiod*, corr(psar1)  
estimates store m6

*Column 7 - FE & democratic years & period dummies*;
mim, storebv: xtreg lnIMRwdi lngdppercap_1 lnhiv_1 lndensity_1 ///
     gdpgrowth_1 lndemyears_1 dperiod*, fe robust 
estimates store m7

estimates table m1 m2 m3 m4 m5 m6 m7, stats(N) b(%7.3f) se(%8.3f) 

/*
==========================================================================
OPTIONS 5: ACLP population of country years
           My polity variable created from Ross's annual data
           Centered quinquennial data
           UNICEF IMR
==========================================================================
*/

*Column 1 - LDV only with panel specific autocorrelation*;
mim, category(fit)  storebv: xtpcse lnIMRunicef lnIMRunicef_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1, corr(psar1)
estimates store m1

*Column 2 - LDV only with panel specific autocorrelation and polity*;
mim, category(fit)  storebv: xtpcse lnIMRunicef lnIMRunicef_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1 polity_1, corr(psar1) 
estimates store m2

*Column 3 - LDV and period dummies
mim, category(fit)  storebv: xtpcse lnIMRunicef lnIMRunicef_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1 polity_1 dperiod*, corr(psar1) 
estimates store m3

*Column 4 - FE & period dummies*;
mim, storebv: xtreg lnIMRunicef lngdppercap_1 lnhiv_1 lndensity_1 ///
     gdpgrowth_1 polity_1 dperiod*, fe vce(robust)
estimates store m4

*Column 5 - LDV only and democratic years*;
mim, category(fit) storebv: xtpcse lnIMRunicef lnIMRunicef_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1 lndemyears_1, corr(psar1) 
estimates store m5

*Column 6 - LDV and democratic years and period dummies*;
mim, category(fit) storebv: xtpcse lnIMRunicef lnIMRunicef_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1 lndemyears_1 dperiod*, corr(psar1)  
estimates store m6

*Column 7 - FE & democratic years & period dummies*;
mim, storebv: xtreg lnIMRunicef lngdppercap_1 lnhiv_1 lndensity_1 ///
     gdpgrowth_1 lndemyears_1 dperiod*, fe robust 
estimates store m7

estimates table m1 m2 m3 m4 m5 m6 m7, stats(N) b(%7.3f) se(%8.3f) 







* USE Ross population of sovereign country years
* Forwarde centered quinquennia 
* ----------------------------------------------
clear
use stackfr

/*
==========================================================================
OPTIONS 1: Ross population of country years
           Ross polity variable in his quinquennial data
           Forward centered quinquennial data
           WDI CMR
==========================================================================
*/

*Column 1 - LDV only with panel specific autocorrelation*;
mim, category(fit)  storebv: xtpcse lnCMRwdi lnCMRwdi_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1, corr(psar1)
estimates store m1

*Column 2 - LDV only with panel specific autocorrelation and polity*;
mim, category(fit)  storebv: xtpcse lnCMRwdi lnCMRwdi_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1 polityross_1, corr(psar1)
estimates store m2

*Column 3 - LDV and period dummies
mim, category(fit)  storebv: xtpcse lnCMRwdi lnCMRwdi_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1 polityross_1 dperiod*, corr(psar1) 
estimates store m3

*Column 4 - FE & period dummies*;
mim, storebv: xtreg lnCMRwdi lngdppercap_1 lnhiv_1 lndensity_1 ///
     gdpgrowth_1 polityross_1 dperiod*, fe vce(robust)
estimates store m4

*Column 5 - LDV only and democratic years*;
mim, category(fit) storebv: xtpcse lnCMRwdi lnCMRwdi_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1 lndemyears_1, corr(psar1) 
estimates store m5

*Column 6 - LDV and democratic years and period dummies*;
mim, category(fit) storebv: xtpcse lnCMRwdi lnCMRwdi_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1 lndemyears_1 dperiod*, corr(psar1)  
estimates store m6

*Column 7 - FE & democratic years & period dummies*;
mim, storebv: xtreg lnCMRwdi lngdppercap_1 lnhiv_1 lndensity_1 ///
     gdpgrowth_1 lndemyears_1 dperiod*, fe robust 
estimates store m7

estimates table m1 m2 m3 m4 m5 m6 m7, stats(N) b(%7.3f) se(%8.3f) 



/*
==========================================================================
OPTIONS 2: Ross population of country years
           Ross polity variable in his quinquennial data
           Forward centered quinquennial data
           UNICEF CMR
==========================================================================
*/

*Column 1 - LDV only with panel specific autocorrelation*;
mim, category(fit)  storebv: xtpcse lnCMRunicef lnCMRunicef_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1, corr(psar1)
estimates store m1

*Column 2 - LDV only with panel specific autocorrelation and polity*;
mim, category(fit)  storebv: xtpcse lnCMRunicef lnCMRunicef_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1 polityross_1, corr(psar1) 
estimates store m2

*Column 3 - LDV and period dummies
mim, category(fit)  storebv: xtpcse lnCMRunicef lnCMRunicef_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1 polityross_1 dperiod*, corr(psar1) 
estimates store m3

*Column 4 - FE & period dummies*;
mim, storebv: xtreg lnCMRunicef lngdppercap_1 lnhiv_1 lndensity_1 ///
     gdpgrowth_1 polityross_1 dperiod*, fe vce(robust)
estimates store m4

*Column 5 - LDV only and democratic years*;
mim, category(fit) storebv: xtpcse lnCMRunicef lnCMRunicef_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1 lndemyears_1, corr(psar1) 
estimates store m5

*Column 6 - LDV and democratic years and period dummies*;
mim, category(fit) storebv: xtpcse lnCMRunicef lnCMRunicef_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1 lndemyears_1 dperiod*, corr(psar1)  
estimates store m6

*Column 7 - FE & democratic years & period dummies*;
mim, storebv: xtreg lnCMRunicef lngdppercap_1 lnhiv_1 lndensity_1 ///
     gdpgrowth_1 lndemyears_1 dperiod*, fe robust 
estimates store m7

estimates table m1 m2 m3 m4 m5 m6 m7, stats(N) b(%7.3f) se(%8.3f) 



/*
==========================================================================
OPTIONS 3: Ross population of country years
           Ross polity variable in his quinquennial data
           Forward centered quinquennial data
           WHO CMR
==========================================================================
*/

*Column 1 - LDV only with panel specific autocorrelation*;
mim, category(fit)  storebv: xtpcse lnCMRwho lnCMRwho_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1, corr(psar1)
estimates store m1

*Column 2 - LDV only with panel specific autocorrelation and polity*;
mim, category(fit)  storebv: xtpcse lnCMRwho lnCMRwho_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1 polityross_1, corr(psar1) 
estimates store m2

*Column 3 - LDV and period dummies
mim, category(fit)  storebv: xtpcse lnCMRwho lnCMRwho_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1 polityross_1 dperiod*, corr(psar1) 
estimates store m3

*Column 4 - FE & period dummies*;
mim, storebv: xtreg lnCMRwho lngdppercap_1 lnhiv_1 lndensity_1 ///
     gdpgrowth_1 polityross_1 dperiod*, fe vce(robust)
estimates store m4

*Column 5 - LDV only and democratic years*;
mim, category(fit) storebv: xtpcse lnCMRwho lnCMRwho_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1 lndemyears_1, corr(psar1) 
estimates store m5

*Column 6 - LDV and democratic years and period dummies*;
mim, category(fit) storebv: xtpcse lnCMRwho lnCMRwho_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1 lndemyears_1 dperiod*, corr(psar1)  
estimates store m6

*Column 7 - FE & democratic years & period dummies*;
mim, storebv: xtreg lnCMRwho lngdppercap_1 lnhiv_1 lndensity_1 ///
     gdpgrowth_1 lndemyears_1 dperiod*, fe robust 
estimates store m7

estimates table m1 m2 m3 m4 m5 m6 m7, stats(N) b(%7.3f) se(%8.3f) 


/*
==========================================================================
OPTIONS 4: Ross population of country years
           Ross polity variable in his quinquennial data
           Forward centered quinquennial data
           WDI IMR
==========================================================================
*/

*Column 1 - LDV only with panel specific autocorrelation*;
mim, category(fit)  storebv: xtpcse lnIMRwdi lnIMRwdi_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1, corr(psar1)
estimates store m1

*Column 2 - LDV only with panel specific autocorrelation and polity*;
mim, category(fit)  storebv: xtpcse lnIMRwdi lnIMRwdi_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1 polityross_1, corr(psar1) 
estimates store m2

*Column 3 - LDV and period dummies
mim, category(fit)  storebv: xtpcse lnIMRwdi lnIMRwdi_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1 polityross_1 dperiod*, corr(psar1) 
estimates store m3

*Column 4 - FE & period dummies*;
mim, storebv: xtreg lnIMRwdi lngdppercap_1 lnhiv_1 lndensity_1 ///
     gdpgrowth_1 polityross_1 dperiod*, fe vce(robust)
estimates store m4

*Column 5 - LDV only and democratic years*;
mim, category(fit) storebv: xtpcse lnIMRwdi lnIMRwdi_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1 lndemyears_1, corr(psar1) 
estimates store m5

*Column 6 - LDV and democratic years and period dummies*;
mim, category(fit) storebv: xtpcse lnIMRwdi lnIMRwdi_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1 lndemyears_1 dperiod*, corr(psar1)  
estimates store m6

*Column 7 - FE & democratic years & period dummies*;
mim, storebv: xtreg lnIMRwdi lngdppercap_1 lnhiv_1 lndensity_1 ///
     gdpgrowth_1 lndemyears_1 dperiod*, fe robust 
estimates store m7

estimates table m1 m2 m3 m4 m5 m6 m7, stats(N) b(%7.3f) se(%8.3f) 

/*
==========================================================================
OPTIONS 5: Ross population of country years
           Ross polity variable in his quinquennial data
           Forward centered quinquennial data
           UNICEF IMR
==========================================================================
*/

*Column 1 - LDV only with panel specific autocorrelation*;
mim, category(fit)  storebv: xtpcse lnIMRunicef lnIMRunicef_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1, corr(psar1)
estimates store m1

*Column 2 - LDV only with panel specific autocorrelation and polity*;
mim, category(fit)  storebv: xtpcse lnIMRunicef lnIMRunicef_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1 polityross_1, corr(psar1) 
estimates store m2

*Column 3 - LDV and period dummies
mim, category(fit)  storebv: xtpcse lnIMRunicef lnIMRunicef_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1 polityross_1 dperiod*, corr(psar1) 
estimates store m3

*Column 4 - FE & period dummies*;
mim, storebv: xtreg lnIMRunicef lngdppercap_1 lnhiv_1 lndensity_1 ///
     gdpgrowth_1 polityross_1 dperiod*, fe vce(robust)
estimates store m4

*Column 5 - LDV only and democratic years*;
mim, category(fit) storebv: xtpcse lnIMRunicef lnIMRunicef_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1 lndemyears_1, corr(psar1) 
estimates store m5

*Column 6 - LDV and democratic years and period dummies*;
mim, category(fit) storebv: xtpcse lnIMRunicef lnIMRunicef_1 lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1 lndemyears_1 dperiod*, corr(psar1)  
estimates store m6

*Column 7 - FE & democratic years & period dummies*;
mim, storebv: xtreg lnIMRunicef lngdppercap_1 lnhiv_1 lndensity_1 ///
     gdpgrowth_1 lndemyears_1 dperiod*, fe robust 
estimates store m7

estimates table m1 m2 m3 m4 m5 m6 m7, stats(N) b(%7.3f) se(%8.3f) 


/*
==========================================================================
OPTIONS 6: Ross population of country years
           Ross polity variable in his quinquennial data
           Forward centered quinquennial data
           WDI CMR, UNICEF CMR, WHO CMR, WDI IMR, UNICEF IMR
           - In all previous specifications Polity was not significant in 
             FE model.  I assume bc of very restrictive dynamics.  Try with
             one more lag of Polity.
==========================================================================
*/


*Column 4 - FE & period dummies*;

mim, storebv: xtreg lnCMRwdi lngdppercap_1 lnhiv_1 lndensity_1 ///
     gdpgrowth_1 polityross_1 polityross_2 dperiod*, fe vce(robust)

mim, storebv: xtreg lnCMRunicef lngdppercap_1 lnhiv_1 lndensity_1 ///
     gdpgrowth_1 polityross_1 polityross_2 dperiod*, fe vce(robust)

mim, storebv: xtreg lnCMRwho lngdppercap_1 lnhiv_1 lndensity_1 ///
     gdpgrowth_1 polityross_1 polityross_2 dperiod*, fe vce(robust)

mim, storebv: xtreg lnIMRwdi lngdppercap_1 lnhiv_1 lndensity_1 ///
     gdpgrowth_1 polityross_1 polityross_2 dperiod*, fe vce(robust)

mim, storebv: xtreg lnIMRunicef lngdppercap_1 lnhiv_1 lndensity_1 ///
     gdpgrowth_1 polityross_1 polityross_2 dperiod*, fe vce(robust)
















