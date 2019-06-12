* Replication file for "Market Potecting Institutions and the WTO's Ability to Promote Trade"

****************************
*** Open the Dyadic Data ***
****************************

use "E:\Jesse's Documents\WTO Paper\ISQ\Final\JohnsonSouvaSmithISQrep\JohnsonSouvaSmithISQrep.dta", clear

****************
*** Table 1 ****
****************

*******************
*** Base Model ****
*******************

* Our base model (Rose data, dyad fixed effects, and year fixed effects)

#delimit ;

areg ltrade WTO MPI WTOxMPI 
oneinWTO gsp lrgdp lrgdppc regional custrict curcol yr*, 
absorb(pairid) cluster(pairid);

********************
*** MPI Summaries***
********************

#delimit ;

gen strong=1 if MPI>.65 & MPI~=. ;
replace strong=0 if MPI<=.65 & MPI~=. ; 
tab strong  ;

sum MPI if WTO==1, d ;

gen strongWTO=1 if MPI>.65 & MPI~=. & WTO==1 ;
replace strongWTO=0 if MPI<=.65 & MPI~=. & WTO==1 ;
tab strongWTO ;

drop strong strongWTO ;

*****************************
*** Goldstein et al. Data ***
*****************************

* Using the Goldstein et al. data 

#delimit ;

areg ltrade g_WTO MPI g_WTOxMPI 
g_oneinWTO gsp lrgdp lrgdppc regional custrict curcol yr*, 
absorb(pairid) cluster(pairid);

*******************************
*** MPIs for Goldstein Data ***
*******************************

#delimit ;

gen g_add=1 if WTO==0 & g_WTO==1 ;
recode g_add(.=0) if WTO==0 ;

ttest MPI, by(g_add) ;

gen strongGWTO=1 if MPI>.65 & MPI~=. & g_add==1 ;
replace strongGWTO=0 if MPI<=.65 & MPI~=. & g_add==1 ;
tab strongGWTO ;

drop g_add strongGWTO ;

****************
*** Table 2 ****
****************

*************************
*** Industrial Models ***
*************************

* First the Rose data

#delimit ;

areg ltrade indWTO  notindWTO MPI indWTOxMPI  notindWTOxMPI 
oneinWTO gsp lrgdp lrgdppc regional custrict curcol yr*, 
absorb(pairid) cluster(pairid); 

* Second the Goldstein et al. data

#delimit ;

areg ltrade g_indWTO g_notindWTO MPI g_indWTOxMPI  g_notindWTOxMPI  
g_oneinWTO gsp lrgdp lrgdppc regional custrict curcol yr*, 
absorb(pairid) cluster(pairid); 

****************
*** Table 3 ****
****************

************************
*** Using ICRG index ***
************************

* First the Rose data

#delimit ;

areg ltrade WTO ICRG WTOxICRG 
oneinWTO gsp lrgdp lrgdppc regional custrict curcol yr*, 
absorb(pairid) cluster(pairid);

* Second the Goldstein et al. data

#delimit ;

areg ltrade g_WTO ICRG g_WTOxICRG 
g_oneinWTO gsp lrgdp lrgdppc regional custrict curcol yr*, 
absorb(pairid) cluster(pairid);

*******************************************************************************************************************************************

*********************
*** Web Appendix ****
*********************

*****************************
*** Open the Monadic Data ***
*****************************

#delimit ;

use "E:\Jesse's Documents\WTO Paper\ISQ\Final\JohnsonSouvaSmithISQrep\JohnsonSouvaSmithISQrepMonadic.dta", clear ;

************************
*** Monadic Analysis ***
************************

* First the Rose data

#delimit ;

areg lnopen WTO MPI WTOxMPI lnpop lnrgdpch remote, absorb(year); 

* Second the Goldstein et al. data

#delimit ;

areg lnopen g_WTO MPI g_WTOxMPI lnpop lnrgdpch remote, absorb(year);

****************************
*** Open the Dyadic Data ***
****************************

#delimit ;

use "E:\Jesse's Documents\WTO Paper\ISQ\Final\JohnsonSouvaSmithISQrep\JohnsonSouvaSmithISQrep.dta", clear ;

*******************************
*** Just Fixed Year Effects ***
*******************************

* First the Rose data

#delimit ;

areg ltrade WTO MPI WTOxMPI 
oneinWTO gsp lrgdp lrgdppc regional custrict curcol
ldist comlang border landl island lareap comcol colony, 
absorb(year) cluster(pairid);

* Second the Goldstein et al. data

#delimit ;

areg ltrade g_WTO MPI g_WTOxMPI 
g_oneinWTO gsp lrgdp lrgdppc regional custrict curcol
ldist comlang border landl island lareap comcol colony, 
absorb(year) cluster(pairid);

**********************************************
*** Controlling for Financial Development ****
**********************************************

* First the Rose data

#delimit ;

areg ltrade WTO MPI WTOxMPI llgdp
oneinWTO gsp lrgdp lrgdppc regional custrict curcol yr*, 
absorb(pairid) cluster(pairid);

* Second the Goldstein et al. data

#delimit ;

areg ltrade g_WTO MPI g_WTOxMPI llgdp
g_oneinWTO gsp lrgdp lrgdppc regional custrict curcol yr*, 
absorb(pairid) cluster(pairid);

****************************
*** Dropping  "oneinWTO" ***
****************************

* First the Rose data

#delimit ;

areg ltrade WTO MPI WTOxMPI 
gsp lrgdp lrgdppc regional custrict curcol yr*, 
absorb(pairid) cluster(pairid);

* Second the Goldstein et al. data

#delimit ;

areg ltrade g_WTO MPI g_WTOxMPI 
gsp lrgdp lrgdppc regional custrict curcol yr*, 
absorb(pairid) cluster(pairid);
