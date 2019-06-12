******************************************************************************
** Replication for "Male vs. Female Career Ambassadors: Is the U.S. Foreign **
** Service Still Biased?"													**
** Authors: Costel Calin and Kevin Buterbaugh								**
** Purpose: Replication code for Foreign Policy Analysis					**
** Software: Stata 15														**
******************************************************************************
** Code uses 3 datasets:													**
** (1) All career ambassadors												**
** (2) Total number of career ambassadors per year, by sex					**
** (3) Main dataset: main results for paper (7 models)						**
******************************************************************************

******************************************************************************
** Table 1: Ambassadors’ status, marital status, children, 					**
** and education, by sex (uses dataset_1)									**
******************************************************************************
tab sex
tab married if sex==1
tab married if sex==0
tab children if sex==1
tab children if sex==0
tab ivy if sex==1
tab ivy if sex==0
tab graduate2 if sex==1
tab graduate2 if sex==0
tab graduate1 if sex==1
tab graduate1 if sex==0
tab sex yearofapp

******************************************************************************
** Fig. 1: The annual number of ambassadors appointed						**
** in the period 1993-2008, by sex (uses dataset_2)							**
******************************************************************************
graph twoway connected male female yearofapp, ///
title("Career ambassadors, by sex") xtitle("Year of appointment") ///
ytitle("Total number of ambassadors")

******************************************************************************
** Table 2: Logit Model of Male Ambassador Appointment, 1993-2008			** 
** (uses Main dataset)														**
******************************************************************************
*Regression Model1
logit sexofamb married children ivy time HDI empindex logcap_2 sexofsecr
*Regression Model2
logit sexofamb married children graduate1 time HDI empindex logcap_2 sexofsecr
*Regression Model3
logit sexofamb married children graduate2 time HDI empindex logcap_2 sexofsecr
*Regression Model4
logit sexofamb married children ivy time infmort empindex logcap_2 sexofsecr
*Regression Model5
logit sexofamb married children ivy time loggdp2 empindex logcap_2 sexofsecr
*Regression Model6
logit sexofamb married children ivy time HDI polity2 logcap_2 sexofsecr
*Regression Model7
logit sexofamb married children ivy time loggdp2 polity2 logcap_2 sexofsecr
*Marginal effects Model1
logit sexofamb i.married i.children i.ivy time HDI empindex logcap_2 i.sexofsecr
margins, dydx(married children ivy time HDI empindex logcap_2 sexofsecr) atmeans
*Marginal effects Model7
logit sexofamb i.married i.children i.ivy time loggdp2 polity2 logcap_2 i.sexofsecr
margins, dydx(married children ivy time loggdp2 polity2 logcap_2 sexofsecr) atmeans






