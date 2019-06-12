
use MNCs&Corruption.dta,clear

ssc install ivreg2
ssc install ranktest
 
#delimit ;
macro define covars1 "lgdpcap6978 gdp6978 population lgovtexp9302 pubempratio 
leduc pwratio female time";
#delimit cr

********************************************************************************
***************************Table 1 in the Main Text*****************************
********************************************************************************
*Model 1 
ivreg2 corruption1 (MNC=lwdist) $covars1, gmm2s robust ffirst
*Model 2 
ivreg2 corruption1 (MNC=lwdist) $covars1 BureauIntegr, gmm2s robust ffirst
*Model 3 
ivreg2 corruption1 (MNC=lwdist) $covars1 minicipalities, gmm2s robust ffirst
*Model 4
ivreg2 corruption1 (MNC=lwdist) $covars1 TrustCourts, gmm2s robust ffirst
*Model 5
ivreg2 corruption1 (MNC=lwdist) $covars1 BureauIntegr minicipalities TrustCourts, gmm2s robust ffirst
*Model 6
ivreg2 corruption2 (MNC=lwdist) $covars1 BureauIntegr minicipalities TrustCourts, gmm2s robust ffirst
*Model 7
ivreg2 corruption3 (MNC=lwdist) $covars1 BureauIntegr minicipalities TrustCourts, gmm2s robust ffirst


********************************************************************************
************************Table 2 in the Main Text********************************
********************************************************************************

#delimit ;
macro define covars2 "lgdpcap6978 gdp6978 population lgovtexp9302 pubempratio 
leduc pwratio female";
#delimit cr 

*Model 1: (Witnessed Corruption)
ivreg2 corrupexp (MNC2=lwdist) $covars2, gmm2s robust ffirst
*Model 1: (Corruption Perceptions)
ivreg2 corruppercep (MNC2=lwdist) $covars2, gmm2s robust ffirst
