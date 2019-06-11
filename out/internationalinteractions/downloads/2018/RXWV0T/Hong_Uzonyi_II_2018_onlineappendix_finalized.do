**THIS IS THE DO.FILE FOR Online Appendix of "Deeper Commitment to Human Rights Treaties: Signaling and Investment Risk Perception"**
*Mi Hwa Hong and Gary Uzonyi*
*International Interactions, 2018*


********************************************************
*Table B.1-B.4: Balance Statistics for Genetic Matching*
********************************************************

/** To reproduce the balance statistics, matchediccpr_II.R(matchedcat_II.R, matchedcedaw_II.R, and matchedicerd_II.R) uses 
matchiccpr.dta (matchcat.dta, matchcedaw.dta, matchicerd.dta) to match countries who eventually accept the optional protocol/article allowing 
individual complaints to those that do not, based on a propensity scores and a genetic matching algorithm. 
This file will reproduce the matching process and matching diagnostics (balance statistics). 
"Please note, however, that a degreee of randomness is inherent in the genetic matching process, 
so the results obtained from replicating our matching will not correspond precisely to those reported in the paper.
Though the correspondence should be quite close" (Also see Hollyer and Rosendorff (2011) QJPS for the same justification when using matching).**/

*iccpr: run matchediccpr_II.R *

*cat: run matchedcat_II.R *

*cedaw: run matchedcedaw_II.R **

*icerd: run matchedicerd_II.R **

clear

cd "    "

use HU_II_2018_Onlineappendix_main.dta

*****************************
*Table C: Correlation matrix*
*****************************

*iccpr*
corr iccpronly iccprboth p_polity2 trans lnwdi_gdpc wdi_gdpgr ciri_physint fh_cl fh_pr ucdp_type3 if year>1982 & year<2010
*cat*
corr catonly catboth p_polity2 trans lnwdi_gdpc wdi_gdpgr ciri_disap ciri_kill ciri_polpris ciri_tort ucdp_type3 if year>1982 & year<2010
*cedaw*
corr cedawonly cedawboth p_polity2 trans lnwdi_gdpc wdi_gdpgr ciri_wecon ciri_wopol ciri_wosoc ucdp_type3 if year>1982 & year<2010
*icerd*
corr icerdonly icerdboth p_polity2 trans lnwdi_gdpc wdi_gdpgr ciri_empinx_new ucdp_type3 if year>1982 & year<2010

****************************
*Table D: Descriptive stats*
****************************

su iccprboth iccpronly  catboth catonly  cedawboth cedawonly  icerdboth icerdonly  p_polity2 trans lnwdi_gdpc wdi_gdpgr ciri_physint fh_cl fh_pr ciri_disap ciri_kill ciri_polpris ciri_tort ciri_wecon ciri_wopol ciri_wosoc ciri_empinx_new ucdp_type3 west eeuro lame meast ssafr easia seasia sasia pacific caribbean if year>1982 & year<2010

***************
*PCSE: Table E*
***************

set more off
xtset ccodecow year

*ICCPR AND OPI**
xtpcse INVP l.iccprboth l.iccpronly  l.p_polity2 l.trans l.lnwdi_gdpc l.wdi_gdpgr l.ciri_physint l.fh_cl l.fh_pr l.ucdp_type3 l.INVP eeuro lame meast ssafr easia seasia sasia pacific caribbean, pairwise

*CAT and ARTICLE 22*
xtpcse INVP l.catboth l.catonly  l.p_polity2 l.trans l.lnwdi_gdpc l.wdi_gdpgr l.ciri_disap l.ciri_kill l.ciri_polpris l.ciri_tort l.ucdp_type3 l.INVP eeuro lame meast ssafr easia seasia sasia pacific caribbean, pairwise

*CEDAW AND CEDAWOP**
xtpcse INVP  l.cedawboth l.cedawonly  l.p_polity2 l.trans l.lnwdi_gdpc l.wdi_gdpgr l.ciri_wecon l.ciri_wopol l.ciri_wosoc l.ucdp_type3 l.INVP eeuro lame meast ssafr easia seasia sasia pacific caribbean, pairwise

*ICERD AND ARTICLE14*
xtpcse INVP  l.icerdboth l.icerdonly  l.p_polity2 l.trans l.lnwdi_gdpc l.wdi_gdpgr l.ciri_empinx_new l.ucdp_type3 l.INVP eeuro lame meast ssafr easia seasia sasia pacific caribbean, pairwise

*******************************************
*PCSE with country fixed effects: Table F *
*******************************************

*ICCPR AND OPI**
xi: xtpcse INVP l.iccprboth l.iccpronly  l.p_polity2 l.trans l.lnwdi_gdpc l.wdi_gdpgr l.ciri_physint l.fh_cl l.fh_pr l.ucdp_type3 l.INVP  i.ccodecow, pairwise

*CAT and ARTICLE 22*
xi: xtpcse INVP l.catboth l.catonly  l.p_polity2 l.trans l.lnwdi_gdpc l.wdi_gdpgr l.ciri_disap l.ciri_kill l.ciri_polpris l.ciri_tort l.ucdp_type3 l.INVP i.ccodecow, pairwise

*CEDAW AND CEDAWOP**
xtreg INVP  l.cedawboth l.cedawonly  l.p_polity2 l.trans l.lnwdi_gdpc l.wdi_gdpgr l.ciri_wecon l.ciri_wopol l.ciri_wosoc l.ucdp_type3 l.INVP, fe cluster(ccodecow) 

*ICERD AND ARTICLE14*
xi: xtpcse INVP  l.icerdboth l.icerdonly  l.p_polity2 l.trans l.lnwdi_gdpc l.wdi_gdpgr l.ciri_empinx_new l.ucdp_type3 l.INVP i.ccodecow, pairwise

************************************
*PCSE with extra controls: Table G *
************************************

clear 

use HU_II_2018_Onlineappendix_econcontrols.dta

*ICCPR and OP*
xtpcse INVP l.iccprboth l.iccpronly l.p_polity2 l.trans l.lnwdi_gdpc l.wdi_gdpgr l.ciri_physint l.fh_cl l.fh_pr l.ucdp_type3 l.ln_inflation l.ka_open_TR l.INVP eeuro lame meast ssafr easia seasia sasia pacific caribbean, pairwise

*CAT and ARTICLE 22*
xtpcse INVP l.catboth l.catonly  l.p_polity2 l.trans l.lnwdi_gdpc l.wdi_gdpgr l.ciri_disap l.ciri_kill l.ciri_polpris l.ciri_tort l.ucdp_type3 l.ln_inflation l.ka_open_TR l.INVP eeuro lame meast ssafr easia seasia sasia pacific caribbean, pairwise

*CEDAW AND CEDAWOP**
xtpcse INVP l.cedawboth l.cedawonly  l.p_polity2 l.trans l.lnwdi_gdpc l.wdi_gdpgr l.ciri_wecon l.ciri_wopol l.ciri_wosoc l.ucdp_type3 l.ln_inflation l.ka_open_TR l.INVP eeuro lame meast ssafr easia seasia sasia pacific caribbean, pairwise

*ICERD AND ARTICLE14*
xtpcse INVP l.icerdboth l.icerdonly l.p_polity2 l.trans l.lnwdi_gdpc l.wdi_gdpgr l.ciri_empinx_new l.ucdp_type3 l.ln_inflation l.ka_open_TR l.INVP eeuro lame meast ssafr easia seasia sasia pacific caribbean, pairwise









