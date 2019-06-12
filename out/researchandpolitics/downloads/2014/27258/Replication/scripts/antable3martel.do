/*
==========================================================================
File-Name:    antable3martel.do
Date:         Sep 9, 2013
Author:       Fernando Martel                                 
Purpose:      Replicate Table 3 in Ross, Michael "Is Democracy Good for 
              the Poor?", American Journal of Political Science, Vol. 50,
              No. 4, October 2006, Pg. 860-­874. 
              In what follows I vary the following aspects:
              - ACLP vs Ross (2006) definition of sovereign country years
              - Quinquennia that are centered averages (e.g. datum for 1970
                is average for 1968-1972) vs forward avg (e.g. datum for 1970
                is average for 1970-74),  Ross (2006) uses the latter.
              - The polity variable I generated from Ross's annual data or 
                the one he provides in the quinquennial dataset.  Note I 
                could not replicate the latter using the former. Bc the 
                quinquennial polity provided by Ross was calcualted as a
                forward average, I only consider forward average data when
                using it.
              - Note both HIV and democratic years could no be replicated 
                using annual data.  Again they are computed using forward lag
                in Ross (2006) quinquennial data.
              - In the paper Ross (2006) claims to be using UNICEF's CMR but 
                in fact is using WDI's CMR which has less data.  I try both
                dependent variables. 
Data Input:   martel5yc, martel5yf
Output File:  table3martel.tex
Data Output:  none
Previous file:proc_rep_master.do
Status:       Complete                                     
Machine:      IBM, X201 tablet running Windows 7 64-Bit spck 1
==========================================================================
*/

clear
global path ///
C:\Users\Fernando\Documents\docs\research_projects\Replication\analysis
cd "$path"

* What follows is repetitive but easier to follow than usgin a loop

/*
==========================================================================
OPTIONS 1: Ross population of country years
           My polity variable created from Ross's annual data
           Centered quinquennial data
           UNICEF CMR
==========================================================================
*/
clear
use martel5yc
xtset ctynum period
tabulate period, gen(dperiod)

* Subset to Ross population
drop if rosspop != 1

* Column 1 - LDV only with panel specific autocorrelation;
capture noisily xtpcse lnCMRunicef  L.lnCMRunicef L.lngdppercap L.lnhiv L.lndensity L.gdpgrowth, corr(psar1)
* est2vec table3, replace vars(logGDPcap_1  logHIV_1 logDen_1 GDPgrowth_1 Polity_1 logDEMYRS_1) name(c1);

* Column 2 - LDV only with panel specific autocorrelation and polity*;
capture noisily xtpcse lnCMRunicef  L.lnCMRunicef L.lngdppercap  L.lnhiv L.lndensity L.gdpgrowth L.polity, corr(psar1) 
* est2vec table3, addto(table3) name(c2);

* Column 3 - LDV and period dummies*;
capture noisily xtpcse lnCMRunicef  L.lnCMRunicef L.lngdppercap  L.lnhiv L.lndensity L.gdpgrowth L.polity dperiod*, corr(psar1)
* est2vec table3, addto(table3) name(c3);

* Column 4 - FE & period dummies*;
xtreg lnCMRunicef L.lngdppercap L.lnhiv L.lndensity L.gdpgrowth L.polity dperiod*, fe vce(robust)
* est2vec table3, addto(table3) name(c4);

* Column 5 - LDV only and democratic years*;
capture noisily xtpcse lnCMRunicef  L.lnCMRunicef  L.lngdppercap  L.lnhiv L.lndensity L.gdpgrowth L.lndemyears, corr(psar1)
* est2vec table3, addto(table3) name(c5);

* Column 6 - LDV and democratic years and period dummies*;
capture noisily xtpcse lnCMRunicef  L.lnCMRunicef  L.lngdppercap  L.lnhiv L.lndensity L.gdpgrowth L.lndemyears dperiod*, corr(psar1)
* est2vec table3, addto(table3) name(c6);

* Column 7 - FE & democratic years & period dummies*;
xtreg lnCMRunicef L.lngdppercap L.lnhiv L.lndensity L.gdpgrowth L.lndemyears dperiod*, fe vce(robust)
* est2vec table3, addto(table3) name(c7);
* est2tex table3, replace preserve dot;
* copy table3.tex ..\reports\table3.tex;

/*
==========================================================================
OPTIONS 2: Ross population of country years
           My polity variable created from Ross's annual data
           Centered quinquennial data
           WDI CMR
==========================================================================
*/
clear
use martel5yc
xtset ctynum period
tabulate period, gen(dperiod)

* Subset to Ross population
drop if rosspop!=1

* Column 1 - LDV only with panel specific autocorrelation;
capture noisily xtpcse lnCMRwdi  L.lnCMRwdi L.lngdppercap L.lnhiv L.lndensity L.gdpgrowth, corr(psar1)
* est2vec table3, replace vars(logGDPcap_1  logHIV_1 logDen_1 GDPgrowth_1 Polity_1 logDEMYRS_1) name(c1);

*Column 2 - LDV only with panel specific autocorrelation and polity*;
capture noisily xtpcse lnCMRwdi  L.lnCMRwdi L.lngdppercap  L.lnhiv L.lndensity L.gdpgrowth L.polity, corr(psar1) 
* est2vec table3, addto(table3) name(c2);

*Column 3 - LDV and period dummies*;
capture noisily xtpcse lnCMRwdi  L.lnCMRwdi L.lngdppercap  L.lnhiv L.lndensity L.gdpgrowth L.polity dperiod*, corr(psar1)
* est2vec table3, addto(table3) name(c3);

*Column 4 - FE & period dummies*;
xtreg lnCMRwdi L.lngdppercap L.lnhiv L.lndensity L.gdpgrowth L.polity dperiod*, fe vce(robust)
* est2vec table3, addto(table3) name(c4);

*Column 5 - LDV only and democratic years*;
capture noisily xtpcse lnCMRwdi  L.lnCMRwdi  L.lngdppercap  L.lnhiv L.lndensity L.gdpgrowth L.lndemyears, corr(psar1)
* est2vec table3, addto(table3) name(c5);

*Column 6 - LDV and democratic years and period dummies*;
capture noisily xtpcse lnCMRwdi  L.lnCMRwdi L.lngdppercap  L.lnhiv L.lndensity L.gdpgrowth L.lndemyears dperiod*, corr(psar1)
* est2vec table3, addto(table3) name(c6);

*Column 7 - FE & democratic years & period dummies*;
xtreg lnCMRwdi L.lngdppercap L.lnhiv L.lndensity L.gdpgrowth L.lndemyears dperiod*, fe vce(robust)
* est2vec table3, addto(table3) name(c7);
* est2tex table3, replace preserve dot;
* copy table3.tex ..\reports\table3.tex;


/*
==========================================================================
OPTIONS 3: Ross population of country years
           My polity variable created from Ross's annual data
           Forward quinquennial data
           WDI CMR
==========================================================================
*/
clear
use martel5yf
xtset ctynum period
tabulate period, gen(dperiod)

* Subset to Ross population
drop if rosspop!=1

* Column 1 - LDV only with panel specific autocorrelation;
capture noisily xtpcse lnCMRwdi  L.lnCMRwdi L.lngdppercap L.lnhiv L.lndensity L.gdpgrowth, corr(psar1)
* est2vec table3, replace vars(logGDPcap_1  logHIV_1 logDen_1 GDPgrowth_1 Polity_1 logDEMYRS_1) name(c1);

*Column 2 - LDV only with panel specific autocorrelation and polity*;
capture noisily xtpcse lnCMRwdi  L.lnCMRwdi L.lngdppercap  L.lnhiv L.lndensity L.gdpgrowth L.polity, corr(psar1) 
* est2vec table3, addto(table3) name(c2);

*Column 3 - LDV and period dummies*;
capture noisily xtpcse lnCMRwdi  L.lnCMRwdi L.lngdppercap  L.lnhiv L.lndensity L.gdpgrowth L.polity dperiod*, corr(psar1)
* est2vec table3, addto(table3) name(c3);

*Column 4 - FE & period dummies*;
xtreg lnCMRwdi L.lngdppercap L.lnhiv L.lndensity L.gdpgrowth L.polity dperiod*, fe vce(robust)
* est2vec table3, addto(table3) name(c4);

*Column 5 - LDV only and democratic years*;
capture noisily xtpcse lnCMRwdi  L.lnCMRwdi  L.lngdppercap  L.lnhiv L.lndensity L.gdpgrowth L.lndemyears, corr(psar1)
* est2vec table3, addto(table3) name(c5);

*Column 6 - LDV and democratic years and period dummies*;
capture noisily xtpcse lnCMRwdi  L.lnCMRwdi L.lngdppercap  L.lnhiv L.lndensity L.gdpgrowth L.lndemyears dperiod*, corr(psar1)
* est2vec table3, addto(table3) name(c6);

*Column 7 - FE & democratic years & period dummies*;
xtreg lnCMRwdi L.lngdppercap L.lnhiv L.lndensity L.gdpgrowth L.lndemyears dperiod*, fe vce(robust)
* est2vec table3, addto(table3) name(c7);
* est2tex table3, replace preserve dot;


/*
==========================================================================
OPTIONS 4: Ross population of country years
           My polity variable created from Ross's annual data
           Forward quinquennial data
           UNICEF CMR
==========================================================================
*/
clear
use martel5yf
xtset ctynum period
tabulate period, gen(dperiod)

* Subset to Ross population
drop if rosspop!=1

* Column 1 - LDV only with panel specific autocorrelation;
capture noisily xtpcse lnCMRunicef  L.lnCMRunicef L.lngdppercap L.lnhiv L.lndensity L.gdpgrowth, corr(psar1)
* est2vec table3, replace vars(logGDPcap_1  logHIV_1 logDen_1 GDPgrowth_1 Polity_1 logDEMYRS_1) name(c1);

*Column 2 - LDV only with panel specific autocorrelation and polity*;
capture noisily xtpcse lnCMRunicef  L.lnCMRunicef L.lngdppercap  L.lnhiv L.lndensity L.gdpgrowth L.polity, corr(psar1) 
* est2vec table3, addto(table3) name(c2);

*Column 3 - LDV and period dummies*;
capture noisily xtpcse lnCMRunicef  L.lnCMRunicef L.lngdppercap  L.lnhiv L.lndensity L.gdpgrowth L.polity dperiod*, corr(psar1)
* est2vec table3, addto(table3) name(c3);

*Column 4 - FE & period dummies*;
xtreg lnCMRunicef L.lngdppercap L.lnhiv L.lndensity L.gdpgrowth L.polity dperiod*, fe vce(robust)
* est2vec table3, addto(table3) name(c4);

*Column 5 - LDV only and democratic years*;
capture noisily xtpcse lnCMRunicef  L.lnCMRunicef  L.lngdppercap  L.lnhiv L.lndensity L.gdpgrowth L.lndemyears, corr(psar1)
* est2vec table3, addto(table3) name(c5);

*Column 6 - LDV and democratic years and period dummies*;
capture noisily xtpcse lnCMRunicef  L.lnCMRunicef  L.lngdppercap  L.lnhiv L.lndensity L.gdpgrowth L.lndemyears dperiod*, corr(psar1)
* est2vec table3, addto(table3) name(c6);

*Column 7 - FE & democratic years & period dummies*;
xtreg lnCMRunicef L.lngdppercap L.lnhiv L.lndensity L.gdpgrowth L.lndemyears dperiod*, fe vce(robust)
* est2vec table3, addto(table3) name(c7);
* est2tex table3, replace preserve dot;
* copy table3.tex ..\reports\table3.tex;


/*
==========================================================================
OPTIONS 5: Ross population of country years
           Ross's quinquennial polity variable
           Forward quinquennial data
           UNICEF CMR
==========================================================================
*/
clear
use martel5yf
xtset ctynum period
tabulate period, gen(dperiod)

* Subset to Ross population
drop if rosspop!=1

* Column 1 - LDV only with panel specific autocorrelation;
 capture noisily xtpcse lnCMRunicef  L.lnCMRunicef L.lngdppercap L.lnhiv L.lndensity L.gdpgrowth, corr(psar1)
* est2vec table3, replace vars(logGDPcap_1  logHIV_1 logDen_1 GDPgrowth_1 Polity_1 logDEMYRS_1) name(c1);

*Column 2 - LDV only with panel specific autocorrelation and polity*;
 capture noisily xtpcse lnCMRunicef  L.lnCMRunicef L.lngdppercap  L.lnhiv L.lndensity L.gdpgrowth L.polityross, corr(psar1) 
* est2vec table3, addto(table3) name(c2);

*Column 3 - LDV and period dummies*;
 capture noisily xtpcse lnCMRunicef  L.lnCMRunicef L.lngdppercap  L.lnhiv L.lndensity L.gdpgrowth L.polityross dperiod*, corr(psar1)
* est2vec table3, addto(table3) name(c3);

*Column 4 - FE & period dummies*;
xtreg lnCMRunicef L.lngdppercap L.lnhiv L.lndensity L.gdpgrowth L.polityross dperiod*, fe vce(robust)
* est2vec table3, addto(table3) name(c4);

*Column 5 - LDV only and democratic years*;
 capture noisily xtpcse lnCMRunicef  L.lnCMRunicef  L.lngdppercap  L.lnhiv L.lndensity L.gdpgrowth L.lndemyears, corr(psar1)
* est2vec table3, addto(table3) name(c5);

*Column 6 - LDV and democratic years and period dummies*;
 capture noisily xtpcse lnCMRunicef  L.lnCMRunicef  L.lngdppercap  L.lnhiv L.lndensity L.gdpgrowth L.lndemyears dperiod*, corr(psar1)
* est2vec table3, addto(table3) name(c6);

*Column 7 - FE & democratic years & period dummies*;
xtreg lnCMRunicef L.lngdppercap L.lnhiv L.lndensity L.gdpgrowth L.lndemyears dperiod*, fe vce(robust)
* est2vec table3, addto(table3) name(c7);
* est2tex table3, replace preserve dot;
* copy table3.tex ..\reports\table3.tex;

/*
==========================================================================
OPTIONS 6: Ross population of country years
           Ross's quinquennial polity variable
           Forward quinquennial data
           WDI CMR
==========================================================================
*/
clear
use martel5yf
xtset ctynum period
tabulate period, gen(dperiod)

* Subset to Ross population
drop if rosspop!=1

* Column 1 - LDV only with panel specific autocorrelation;
 capture noisily xtpcse lnCMRwdi  L.lnCMRwdi L.lngdppercap L.lnhiv L.lndensity L.gdpgrowth, corr(psar1)
* est2vec table3, replace vars(logGDPcap_1  logHIV_1 logDen_1 GDPgrowth_1 Polity_1 logDEMYRS_1) name(c1);

*Column 2 - LDV only with panel specific autocorrelation and polity*;
 capture noisily xtpcse lnCMRwdi  L.lnCMRwdi L.lngdppercap  L.lnhiv L.lndensity L.gdpgrowth L.polityross, corr(psar1) 
* est2vec table3, addto(table3) name(c2);

*Column 3 - LDV and period dummies*;
 capture noisily xtpcse lnCMRwdi  L.lnCMRwdi L.lngdppercap  L.lnhiv L.lndensity L.gdpgrowth L.polityross dperiod*, corr(psar1)
* est2vec table3, addto(table3) name(c3);

*Column 4 - FE & period dummies*;
xtreg lnCMRwdi L.lngdppercap L.lnhiv L.lndensity L.gdpgrowth L.polityross dperiod*, fe vce(robust)
xtreg lnCMRwdi L.lngdppercap L.lnhiv L.lndensity L.gdpgrowth L(1/2).polityross dperiod*, fe vce(robust)


*Column 5 - LDV only and democratic years*;
 capture noisily xtpcse lnCMRwdi  L.lnCMRwdi  L.lngdppercap  L.lnhiv L.lndensity L.gdpgrowth L.lndemyears, corr(psar1)
* est2vec table3, addto(table3) name(c5);

*Column 6 - LDV and democratic years and period dummies*;
 capture noisily xtpcse lnCMRwdi  L.lnCMRwdi  L.lngdppercap  L.lnhiv L.lndensity L.gdpgrowth L.lndemyears dperiod*, corr(psar1)
* est2vec table3, addto(table3) name(c6);

*Column 7 - FE & democratic years & period dummies*;
xtreg lnCMRwdi L.lngdppercap L.lnhiv L.lndensity L.gdpgrowth L.lndemyears dperiod*, fe vce(robust)
* est2vec table3, addto(table3) name(c7);
* est2tex table3, replace preserve dot;
* copy table3.tex ..\reports\table3.tex;



* USE ACLP population of sovereign country years
* ----------------------------------------------
/*
==========================================================================
OPTIONS 1: ACLP population of country years
           My polity variable created from Ross's annual data
           Centered quinquennial data
           UNICEF CMR
==========================================================================
*/
clear
use martel5yc
xtset ctynum period
tabulate period, gen(dperiod)

* Subset to inersection of ACLP and Ross population
keep if rosspop == aclppop ==1

* Column 1 - LDV only with panel specific autocorrelation;
 capture noisily xtpcse lnCMRunicef  L.lnCMRunicef L.lngdppercap L.lnhiv L.lndensity L.gdpgrowth, corr(psar1)
* est2vec table3, replace vars(logGDPcap_1  logHIV_1 logDen_1 GDPgrowth_1 Polity_1 logDEMYRS_1) name(c1);

*Column 2 - LDV only with panel specific autocorrelation and polity*;
 capture noisily xtpcse lnCMRunicef  L.lnCMRunicef L.lngdppercap  L.lnhiv L.lndensity L.gdpgrowth L.polity, corr(psar1) 
* est2vec table3, addto(table3) name(c2);

*Column 3 - LDV and period dummies*;
 capture noisily xtpcse lnCMRunicef  L.lnCMRunicef L.lngdppercap  L.lnhiv L.lndensity L.gdpgrowth L.polity dperiod*, corr(psar1)
* est2vec table3, addto(table3) name(c3);

*Column 4 - FE & period dummies*;
 xtreg lnCMRunicef L.lngdppercap L.lnhiv L.lndensity L.gdpgrowth L.polity dperiod*, fe vce(robust)
* est2vec table3, addto(table3) name(c4);

*Column 5 - LDV only and democratic years*;
 capture noisily xtpcse lnCMRunicef  L.lnCMRunicef  L.lngdppercap  L.lnhiv L.lndensity L.gdpgrowth L.lndemyears, corr(psar1)
* est2vec table3, addto(table3) name(c5);

*Column 6 - LDV and democratic years and period dummies*;
 capture noisily xtpcse lnCMRunicef  L.lnCMRunicef  L.lngdppercap  L.lnhiv L.lndensity L.gdpgrowth L.lndemyears dperiod*, corr(psar1)
* est2vec table3, addto(table3) name(c6);

*Column 7 - FE & democratic years & period dummies*;
 xtreg lnCMRunicef L.lngdppercap L.lnhiv L.lndensity L.gdpgrowth L.lndemyears dperiod*, fe vce(robust)
* est2vec table3, addto(table3) name(c7);
* est2tex table3, replace preserve dot;
* copy table3.tex ..\reports\table3.tex;

/*
==========================================================================
OPTIONS 2: ACLP population of country years
           My polity variable created from Ross's annual data
           Centered quinquennial data
           WDI CMR
==========================================================================
*/
clear
use martel5yc
xtset ctynum period
tabulate period, gen(dperiod)

* Subset to ACLP population
keep if rosspop == aclppop == 1

* Column 1 - LDV only with panel specific autocorrelation;
capture noisily xtpcse lnCMRwdi  L.lnCMRwdi L.lngdppercap L.lnhiv L.lndensity L.gdpgrowth, corr(psar1)
* est2vec table3, replace vars(logGDPcap_1  logHIV_1 logDen_1 GDPgrowth_1 Polity_1 logDEMYRS_1) name(c1);

*Column 2 - LDV only with panel specific autocorrelation and polity*;
 capture noisily xtpcse lnCMRwdi  L.lnCMRwdi L.lngdppercap  L.lnhiv L.lndensity L.gdpgrowth L.polity, corr(psar1) 
* est2vec table3, addto(table3) name(c2);

*Column 3 - LDV and period dummies*;
 capture noisily xtpcse lnCMRwdi L.lnCMRwdi L.lngdppercap  L.lnhiv L.lndensity L.gdpgrowth L.polity dperiod*, corr(psar1)
* est2vec table3, addto(table3) name(c3);

*Column 4 - FE & period dummies*;
xtreg lnCMRwdi L.lngdppercap L.lnhiv L.lndensity L.gdpgrowth L.polity dperiod*, fe vce(robust)
* est2vec table3, addto(table3) name(c4);

*Column 5 - LDV only and democratic years*;
capture noisily xtpcse lnCMRwdi  L.lnCMRwdi  L.lngdppercap  L.lnhiv L.lndensity L.gdpgrowth L.lndemyears, corr(psar1)
* est2vec table3, addto(table3) name(c5);

*Column 6 - LDV and democratic years and period dummies*;
capture noisily xtpcse lnCMRwdi  L.lnCMRwdi L.lngdppercap  L.lnhiv L.lndensity L.gdpgrowth L.lndemyears dperiod*, corr(psar1)
* est2vec table3, addto(table3) name(c6);

*Column 7 - FE & democratic years & period dummies*;
xtreg lnCMRwdi L.lngdppercap L.lnhiv L.lndensity L.gdpgrowth L.lndemyears dperiod*, fe vce(robust)
* est2vec table3, addto(table3) name(c7);
* est2tex table3, replace preserve dot;
* copy table3.tex ..\reports\table3.tex;

/*
==========================================================================
OPTIONS 3: ACLP population of country years
           My polity variable created from Ross's annual data
           Forward quinquennial data
           WDI CMR
==========================================================================
*/
clear
use martel5yf
xtset ctynum period
tabulate period, gen(dperiod)

* Subset to ACLP population
keep if rosspop == aclppop == 1

* Column 1 - LDV only with panel specific autocorrelation;
capture noisily xtpcse lnCMRwdi  L.lnCMRwdi L.lngdppercap L.lnhiv L.lndensity L.gdpgrowth, corr(psar1)
* est2vec table3, replace vars(logGDPcap_1  logHIV_1 logDen_1 GDPgrowth_1 Polity_1 logDEMYRS_1) name(c1);

*Column 2 - LDV only with panel specific autocorrelation and polity*;
capture noisily xtpcse lnCMRwdi  L.lnCMRwdi L.lngdppercap  L.lnhiv L.lndensity L.gdpgrowth L.polity, corr(psar1) 
* est2vec table3, addto(table3) name(c2);

*Column 3 - LDV and period dummies*;
capture noisily xtpcse lnCMRwdi  L.lnCMRwdi L.lngdppercap  L.lnhiv L.lndensity L.gdpgrowth L.polity dperiod*, corr(psar1)
* est2vec table3, addto(table3) name(c3);

*Column 4 - FE & period dummies*;
xtreg lnCMRwdi L.lngdppercap L.lnhiv L.lndensity L.gdpgrowth L.polity dperiod*, fe vce(robust)
* est2vec table3, addto(table3) name(c4);

*Column 5 - LDV only and democratic years*;
capture noisily xtpcse lnCMRwdi  L.lnCMRwdi  L.lngdppercap  L.lnhiv L.lndensity L.gdpgrowth L.lndemyears, corr(psar1)
* est2vec table3, addto(table3) name(c5);

*Column 6 - LDV and democratic years and period dummies*;
capture noisily xtpcse lnCMRwdi  L.lnCMRwdi L.lngdppercap  L.lnhiv L.lndensity L.gdpgrowth L.lndemyears dperiod*, corr(psar1)
* est2vec table3, addto(table3) name(c6);

*Column 7 - FE & democratic years & period dummies*;
xtreg lnCMRwdi L.lngdppercap L.lnhiv L.lndensity L.gdpgrowth L.lndemyears dperiod*, fe vce(robust)
* est2vec table3, addto(table3) name(c7);
* est2tex table3, replace preserve dot;


/*
==========================================================================
OPTIONS 4: ACLP population of country years
           My polity variable created from Ross's annual data
           Forward quinquennial data
           UNICEF CMR
==========================================================================
*/
clear
use martel5yf
xtset ctynum period
tabulate period, gen(dperiod)

* Subset to ACLP population
keep if rosspop == aclppop == 1

* Column 1 - LDV only with panel specific autocorrelation;
 capture noisily xtpcse lnCMRunicef  L.lnCMRunicef L.lngdppercap L.lnhiv L.lndensity L.gdpgrowth, corr(psar1)
* est2vec table3, replace vars(logGDPcap_1  logHIV_1 logDen_1 GDPgrowth_1 Polity_1 logDEMYRS_1) name(c1);

*Column 2 - LDV only with panel specific autocorrelation and polity*;
 capture noisily xtpcse lnCMRunicef  L.lnCMRunicef L.lngdppercap  L.lnhiv L.lndensity L.gdpgrowth L.polity, corr(psar1) 
* est2vec table3, addto(table3) name(c2);

*Column 3 - LDV and period dummies*;
 capture noisily xtpcse lnCMRunicef  L.lnCMRunicef L.lngdppercap  L.lnhiv L.lndensity L.gdpgrowth L.polity dperiod*, corr(psar1)
* est2vec table3, addto(table3) name(c3);

*Column 4 - FE & period dummies*;
xtreg lnCMRunicef L.lngdppercap L.lnhiv L.lndensity L.gdpgrowth L.polity dperiod*, fe vce(robust)
* est2vec table3, addto(table3) name(c4);

*Column 5 - LDV only and democratic years*;
 capture noisily xtpcse lnCMRunicef  L.lnCMRunicef  L.lngdppercap  L.lnhiv L.lndensity L.gdpgrowth L.lndemyears, corr(psar1)
* est2vec table3, addto(table3) name(c5);

*Column 6 - LDV and democratic years and period dummies*;
 capture noisily xtpcse lnCMRunicef  L.lnCMRunicef  L.lngdppercap  L.lnhiv L.lndensity L.gdpgrowth L.lndemyears dperiod*, corr(psar1)
* est2vec table3, addto(table3) name(c6);

*Column 7 - FE & democratic years & period dummies*;
xtreg lnCMRunicef L.lngdppercap L.lnhiv L.lndensity L.gdpgrowth L.lndemyears dperiod*, fe vce(robust)
* est2vec table3, addto(table3) name(c7);
* est2tex table3, replace preserve dot;
* copy table3.tex ..\reports\table3.tex;


/*
==========================================================================
OPTIONS 5: ACLP population of country years
           Ross's quinquennial polity variable
           Forward quinquennial data
           UNICEF CMR
==========================================================================
*/
clear
use martel5yf
xtset ctynum period
tabulate period, gen(dperiod)

* Subset to ACLP population
keep if rosspop == aclppop == 1

* Column 1 - LDV only with panel specific autocorrelation;
 capture noisily xtpcse lnCMRunicef  L.lnCMRunicef L.lngdppercap L.lnhiv L.lndensity L.gdpgrowth, corr(psar1)

*Column 2 - LDV only with panel specific autocorrelation and polity*;
 capture noisily xtpcse lnCMRunicef  L.lnCMRunicef L.lngdppercap  L.lnhiv L.lndensity L.gdpgrowth L.polityross, corr(psar1) 

*Column 3 - LDV and period dummies*;
 capture noisily xtpcse lnCMRunicef  L.lnCMRunicef L.lngdppercap  L.lnhiv L.lndensity L.gdpgrowth L.polityross dperiod*, corr(psar1)

*Column 4 - FE & period dummies*;
xtreg lnCMRunicef L.lngdppercap L.lnhiv L.lndensity L.gdpgrowth L.polityross dperiod*, fe vce(robust)

*Column 5 - LDV only and democratic years*;
 capture noisily xtpcse lnCMRunicef  L.lnCMRunicef  L.lngdppercap  L.lnhiv L.lndensity L.gdpgrowth L.lndemyears, corr(psar1)

*Column 6 - LDV and democratic years and period dummies*;
 capture noisily xtpcse lnCMRunicef  L.lnCMRunicef  L.lngdppercap  L.lnhiv L.lndensity L.gdpgrowth L.lndemyears dperiod*, corr(psar1)

*Column 7 - FE & democratic years & period dummies*;
xtreg lnCMRunicef L.lngdppercap L.lnhiv L.lndensity L.gdpgrowth L.lndemyears dperiod*, fe vce(robust)


