x 
*  	         Atkinson, Carol
*  "Constructivist Implications of Material Power"
*       International Studies Quarterly
*               September 2006

log using "C:\a CAROL ISQ  article - 2006\DATA FOR POSTING - ISQ\table1a.log", replace
set mem 10m
set more off 
********************************************** 
* 1 - Coherent Democracy - Education Exchange
**********************************************
version 8.2
clear
use "C:\a CAROL ISQ  article - 2006\DATA FOR POSTING - ISQ\dem-stset.dta", clear
*use "dem-stset.dta"
notes
describe
gen IMETyesnoxtime=IMETyesno*_t
#delimit ;
stcox 
IMETyesno
soviet_foreign_asst 
USeconaid_norm 
newc
britcol
open_i
GDP_rescaled
Ethnic_gp 
muslim_majority_yesno
christian_majority_yesno
IMETyesnoxtime,
bases(consoldem_surv) basehc(consoldem_hazard) basechazard(consoldem_cumhaz) nohr efron schoenfeld(sch*) scaledsch(sca*) cluster(ccode);
stphtest, detail;
#delimit cr
clear

****************************************
* 2 - Coherent Democracy - Ally with US
****************************************
version 8.2
clear
use "C:\a CAROL ISQ  article - 2006\DATA FOR POSTING - ISQ\dem-stset.dta", clear
*use "dem-stset.dta"
#delimit ;
stcox 
Ally
soviet_foreign_asst 
USeconaid_norm 
newc
britcol
open_i
GDP_rescaled
Ethnic_gp 
muslim_majority_yesno
christian_majority_yesno,
bases(consoldem_surv) basehc(consoldem_hazard) basechazard(consoldem_cumhaz) nohr efron schoenfeld(sch*) scaledsch(sca*) cluster(ccode);
stphtest, detail;
#delimit cr
clear

******************************************************
* 3 - Coherent Democracy - US Military Troop Presence
******************************************************
version 8.2
clear
use "C:\a CAROL ISQ  article - 2006\DATA FOR POSTING - ISQ\dem-stset.dta", clear
*use "dem-stset.dta"
#delimit ;
stcox 
USMil_normforeignMil
soviet_foreign_asst 
USeconaid_norm 
newc
britcol
open_i
GDP_rescaled
Ethnic_gp 
muslim_majority_yesno
christian_majority_yesno,
bases(consoldem_surv) basehc(consoldem_hazard) basechazard(consoldem_cumhaz) nohr efron schoenfeld(sch*) scaledsch(sca*) cluster(ccode);
stphtest, detail;
#delimit cr
clear

*********************************************
* 4 - Coherent Democracy - US Military Sales
*********************************************
version 8.2
clear
use "C:\a CAROL ISQ  article - 2006\DATA FOR POSTING - ISQ\dem-stset.dta", clear
*use "dem-stset.dta"
#delimit ;
stcox 
USmil_sales_norm
soviet_foreign_asst 
USeconaid_norm 
newc
britcol
open_i
GDP_rescaled
Ethnic_gp 
muslim_majority_yesno
christian_majority_yesno,
bases(consoldem_surv) basehc(consoldem_hazard) basechazard(consoldem_cumhaz) nohr efron schoenfeld(sch*) scaledsch(sca*) cluster(ccode);
stphtest, detail;
#delimit cr
clear

************************************************* 
* 5 - Coherent Democracy - US Miltary Assistance
************************************************* 
version 8.2
clear
use "C:\a CAROL ISQ  article - 2006\DATA FOR POSTING - ISQ\dem-stset.dta", clear
*use "dem-stset.dta"
#delimit ;
stcox 
USmilasst_norm
soviet_foreign_asst 
USeconaid_norm 
newc
britcol
open_i
GDP_rescaled
Ethnic_gp 
muslim_majority_yesno
christian_majority_yesno,
bases(consoldem_surv) basehc(consoldem_hazard) basechazard(consoldem_cumhaz) nohr efron schoenfeld(sch*) scaledsch(sca*) cluster(ccode);
stphtest, detail;
#delimit cr
clear

**************************************************
* 6 - Coherent Authoritarian - Education Exchange
**************************************************
version 8.2
clear
use "C:\a CAROL ISQ  article - 2006\DATA FOR POSTING - ISQ\aut-stset.dta", clear
*use "aut-stset.dta"
notes
describe
gen britcolxtime = britcol*_t
gen newcxtime = newc*_t
#delimit ;
stcox 
IMETyesno
USmilact_yesno 
soviet_foreign_asst
USeconaid_norm 
newc 
britcol
open_i
GDP_rescaled
Ethnic_gp 
muslim_majority_yesno 
christian_majority_yesno
newcxtime
britcolxtime,
bases(consolauth_surv) basehc(consolauth_hazard) basechazard(consolauth_cumhaz) nohr efron schoenfeld(sch*) scaledsch(sca*) cluster(ccode);
stphtest, detail;
#delimit cr
clear

********************************************
* 7 - Coherent Authoritarian - Ally with US
********************************************
version 8.2
clear
use "C:\a CAROL ISQ  article - 2006\DATA FOR POSTING - ISQ\aut-stset.dta", clear
*use "aut-stset.dta"
gen britcolxtime = britcol*_t
gen newcxtime = newc*_t
#delimit ;
stcox 
Ally
USmilact_yesno 
soviet_foreign_asst
USeconaid_norm 
newc 
britcol
open_i
GDP_rescaled
Ethnic_gp 
muslim_majority_yesno 
christian_majority_yesno
newcxtime
britcolxtime,
bases(consolauth_surv) basehc(consolauth_hazard) basechazard(consolauth_cumhaz) nohr efron schoenfeld(sch*) scaledsch(sca*) cluster(ccode);
stphtest, detail;
#delimit cr
clear

**********************************************************
* 8 - Coherent Authoritarian - US Military Troop Presence
**********************************************************
version 8.2
clear
use "C:\a CAROL ISQ  article - 2006\DATA FOR POSTING - ISQ\aut-stset.dta", clear
*use "aut-stset.dta"
gen britcolxtime = britcol*_t
gen newcxtime = newc*_t
#delimit ;
stcox 
USMil_normforeignMil
USmilact_yesno
soviet_foreign_asst
USeconaid_norm 
newc 
britcol
open_i
GDP_rescaled
Ethnic_gp 
muslim_majority_yesno 
christian_majority_yesno
newcxtime
britcolxtime,
bases(consolauth_surv) basehc(consolauth_hazard) basechazard(consolauth_cumhaz) nohr efron schoenfeld(sch*) scaledsch(sca*) cluster(ccode);
stphtest, detail;
#delimit cr
clear

************************************************
* 9 - Coherent Authoritarian - US Miltary Sales
************************************************
version 8.2
clear
use "C:\a CAROL ISQ  article - 2006\DATA FOR POSTING - ISQ\aut-stset.dta", clear
*use "aut-stset.dta"
gen britcolxtime = britcol*_t
gen newcxtime = newc*_t
#delimit ;
stcox 
USmil_sales_norm
USmilact_yesno 
soviet_foreign_asst
USeconaid_norm 
newc 
britcol
open_i
GDP_rescaled
Ethnic_gp 
muslim_majority_yesno 
christian_majority_yesno
newcxtime
britcolxtime,
bases(consolauth_surv) basehc(consolauth_hazard) basechazard(consolauth_cumhaz) nohr efron schoenfeld(sch*) scaledsch(sca*) cluster(ccode);
stphtest, detail;
#delimit cr
clear

*******************************************************
* 10 - Coherent Authoritarian - US Military Assistance
*******************************************************
version 8.2
clear
use "C:\a CAROL ISQ  article - 2006\DATA FOR POSTING - ISQ\aut-stset.dta", clear
*use "aut-stset.dta"
gen britcolxtime = britcol*_t
gen newcxtime = newc*_t
#delimit ;
stcox 
USmilasst_norm
USmilact_yesno 
soviet_foreign_asst
USeconaid_norm 
newc 
britcol
open_i
GDP_rescaled
Ethnic_gp 
muslim_majority_yesno 
christian_majority_yesno
newcxtime
britcolxtime,
bases(consolauth_surv) basehc(consolauth_hazard) basechazard(consolauth_cumhaz) nohr efron schoenfeld(sch*) scaledsch(sca*) cluster(ccode);
stphtest, detail;
#delimit cr
clear

log close

log using "C:\a CAROL ISQ  article - 2006\DATA FOR POSTING - ISQ\table1b.log", replace
****************************************************
* 11 - MidGround to Democracy - Education Exchange
****************************************************
version 8.2
clear
use "C:\a CAROL ISQ  article - 2006\DATA FOR POSTING - ISQ\mid-to-dem-stset.dta", clear
*use "mid-to-dem-stset.dta"
notes
describe
gen britcolxtime = britcol*_t
gen IMETyesnoxtime=IMETyesno*_t
#delimit ;
stcox 
IMETyesno
USmilact_yesno
soviet_foreign_asst
USeconaid_norm 
newc
britcol
open_i 
GDP_rescaled
Ethnic_gp 
muslim_majority_yesno 
christian_majority_yesno 
IMETyesnoxtime
britcolxtime,
bases(mgtodem_surv) basehc(mgtodem_hazard) basechazard(mgtodem_cumhaz) nohr efron schoenfeld(sch*) scaledsch(sca*) cluster(ccode);
stphtest, detail;
#delimit cr
clear

*********************************************
* 12 - MidGround to Democracy - Ally With US 
*********************************************
version 8.2
clear
use "C:\a CAROL ISQ  article - 2006\DATA FOR POSTING - ISQ\mid-to-dem-stset.dta", clear
*use "mid-to-dem-stset.dta"
gen britcolxtime = britcol*_t
#delimit ;
stcox 
Ally
USmilact_yesno
soviet_foreign_asst
USeconaid_norm 
newc
britcol
open_i 
GDP_rescaled
Ethnic_gp 
muslim_majority_yesno 
christian_majority_yesno
britcolxtime,
bases(mgtodem_surv) basehc(mgtodem_hazard) basechazard(mgtodem_cumhaz) nohr efron schoenfeld(sch*) scaledsch(sca*) cluster(ccode);
stphtest, detail;
#delimit cr
clear

***********************************************************
* 13 - MidGround to Democracy - US Military Troop Presence
***********************************************************
version 8.2
clear
use "C:\a CAROL ISQ  article - 2006\DATA FOR POSTING - ISQ\mid-to-dem-stset.dta", clear
*use "mid-to-dem-stset.dta"
gen britcolxtime = britcol*_t
#delimit ;
stcox 
USMil_normforeignMil
USmilact_yesno
soviet_foreign_asst
USeconaid_norm 
newc
britcol
open_i 
GDP_rescaled
Ethnic_gp 
muslim_majority_yesno 
christian_majority_yesno
britcolxtime,
bases(mgtodem_surv) basehc(mgtodem_hazard) basechazard(mgtodem_cumhaz) nohr efron schoenfeld(sch*) scaledsch(sca*) cluster(ccode);
stphtest, detail;
#delimit cr
clear

**************************************************
* 14 - MidGround to Democracy - US Military Sales
**************************************************
version 8.2
clear
use "C:\a CAROL ISQ  article - 2006\DATA FOR POSTING - ISQ\mid-to-dem-stset.dta", clear
*use "mid-to-dem-stset.dta"
gen britcolxtime = britcol*_t
#delimit ;
stcox 
USmil_sales_norm
USmilact_yesno
soviet_foreign_asst
USeconaid_norm 
newc
britcol
open_i 
GDP_rescaled
Ethnic_gp
muslim_majority_yesno 
christian_majority_yesno
britcolxtime,
bases(mgtodem_surv) basehc(mgtodem_hazard) basechazard(mgtodem_cumhaz) nohr efron schoenfeld(sch*) scaledsch(sca*) cluster(ccode);
stphtest, detail;
#delimit cr
clear

*******************************************************
* 15 - MidGround to Democracy - US Military Assistance
*******************************************************
version 8.2
clear
use "C:\a CAROL ISQ  article - 2006\DATA FOR POSTING - ISQ\mid-to-dem-stset.dta", clear
*use "mid-to-dem-stset.dta"
gen britcolxtime = britcol*_t
#delimit ;
stcox 
USmilasst_norm
USmilact_yesno
soviet_foreign_asst
USeconaid_norm 
newc
britcol
open_i 
GDP_rescaled
Ethnic_gp
muslim_majority_yesno 
christian_majority_yesno
britcolxtime,
bases(mgtodem_surv) basehc(mgtodem_hazard) basechazard(mgtodem_cumhaz) nohr efron schoenfeld(sch*) scaledsch(sca*) cluster(ccode);
stphtest, detail;
#delimit cr
clear

*********************************************************
* 16 - MidGround to Authoritarian - Educational Exchange
*********************************************************
version 8.2
clear
use "C:\a CAROL ISQ  article - 2006\DATA FOR POSTING - ISQ\mid-to-aut-stset.dta", clear
*use "mid-to-aut-stset.dta"
notes
describe
#delimit ;
stcox 
IMETyesno
USmilact_yesno
soviet_foreign_asst 
USeconaid_norm 
newc 
britcol
open_i
GDP_rescaled
Ethnic_gp 
muslim_majority_yesno 
christian_majority_yesno,
bases(mgtoaut_surv) basehc(mgtoaut_hazard) basechazard(mgtoaut_cumhaz) nohr efron schoenfeld(sch*) scaledsch(sca*) cluster(ccode);
stphtest, detail;
#delimit cr
clear

*************************************************
* 17 - MidGround to Authoritarian - Ally With US
*************************************************
version 8.2
clear
use "C:\a CAROL ISQ  article - 2006\DATA FOR POSTING - ISQ\mid-to-aut-stset.dta", clear
*use "mid-to-aut-stset.dta"
#delimit ;
stcox 
Ally 
USmilact_yesno
soviet_foreign_asst 
USeconaid_norm 
newc 
britcol
open_i
GDP_rescaled
Ethnic_gp 
muslim_majority_yesno 
christian_majority_yesno,
bases(mgtoaut_surv) basehc(mgtoaut_hazard) basechazard(mgtoaut_cumhaz) nohr efron schoenfeld(sch*) scaledsch(sca*) cluster(ccode);
stphtest, detail;
#delimit cr
clear

***************************************************************
* 18 - MidGround to Authoritarian - US Military Troop Presence
***************************************************************
version 8.2
clear
use "C:\a CAROL ISQ  article - 2006\DATA FOR POSTING - ISQ\mid-to-aut-stset.dta", clear
*use "mid-to-aut-stset.dta"
#delimit ;
stcox 
USMil_normforeignMil 
USmilact_yesno
soviet_foreign_asst 
USeconaid_norm 
newc 
britcol
open_i
GDP_rescaled
Ethnic_gp 
muslim_majority_yesno 
christian_majority_yesno,
bases(mgtoaut_surv) basehc(mgtoaut_hazard) basechazard(mgtoaut_cumhaz) nohr efron schoenfeld(sch*) scaledsch(sca*) cluster(ccode);
stphtest, detail;
#delimit cr
clear

******************************************************
* 19 - MidGround to Authoritarian - US Military Sales
******************************************************
version 8.2
clear
use "C:\a CAROL ISQ  article - 2006\DATA FOR POSTING - ISQ\mid-to-aut-stset.dta", clear
*use "mid-to-aut-stset.dta"
#delimit ;
stcox 
USmil_sales_norm
USmilact_yesno
soviet_foreign_asst 
USeconaid_norm 
newc 
britcol
open_i
GDP_rescaled
Ethnic_gp 
muslim_majority_yesno 
christian_majority_yesno,
bases(mgtoaut_surv) basehc(mgtoaut_hazard) basechazard(mgtoaut_cumhaz) nohr efron schoenfeld(sch*) scaledsch(sca*) cluster(ccode);
stphtest, detail;
#delimit cr
clear

***********************************************************
* 20 - MidGround to Authoritarian - US Military Assistance
***********************************************************
version 8.2
clear
use "C:\a CAROL ISQ  article - 2006\DATA FOR POSTING - ISQ\mid-to-aut-stset.dta", clear
*use "mid-to-aut-stset.dta"
#delimit ;
stcox 
USmilasst_norm
USmilact_yesno
soviet_foreign_asst 
USeconaid_norm 
newc 
britcol
open_i
GDP_rescaled
Ethnic_gp 
muslim_majority_yesno 
christian_majority_yesno,
bases(mgtoaut_surv) basehc(mgtoaut_hazard) basechazard(mgtoaut_cumhaz) nohr efron schoenfeld(sch*) scaledsch(sca*) cluster(ccode);
stphtest, detail;
#delimit cr
clear

log close

log using "C:\a CAROL ISQ  article - 2006\DATA FOR POSTING - ISQ\table3.log", replace
*****************************
**     HAZARD RATIOS       **
*****************************

*** 6 - Coherent Authoritarian - Education Exchange - Hazard Ratios ***
version 8.2
clear
use "C:\a CAROL ISQ  article - 2006\DATA FOR POSTING - ISQ\aut-stset.dta", clear
*use "aut-stset.dta"
gen britcolxtime = britcol*_t
gen newcxtime = newc*_t
#delimit ;
stcox 
IMETyesno
USmilact_yesno 
soviet_foreign_asst
USeconaid_norm 
newc 
britcol
open_i
GDP_rescaled
Ethnic_gp 
muslim_majority_yesno 
christian_majority_yesno
newcxtime
britcolxtime,
bases(consolauth_surv) basehc(consolauth_hazard) basechazard(consolauth_cumhaz) efron schoenfeld(sch*) scaledsch(sca*) cluster(ccode);
stphtest, detail;
#delimit cr
clear

*** 7 - Coherent Authoritarian - Ally with US - Hazard Ratios ***
version 8.2
clear
use "C:\a CAROL ISQ  article - 2006\DATA FOR POSTING - ISQ\aut-stset.dta", clear
*use "aut-stset.dta"
gen britcolxtime = britcol*_t
gen newcxtime = newc*_t
#delimit ;
stcox 
Ally
USmilact_yesno 
soviet_foreign_asst
USeconaid_norm 
newc 
britcol
open_i
GDP_rescaled
Ethnic_gp 
muslim_majority_yesno 
christian_majority_yesno
newcxtime
britcolxtime,
bases(consolauth_surv) basehc(consolauth_hazard) basechazard(consolauth_cumhaz) efron schoenfeld(sch*) scaledsch(sca*) cluster(ccode);
stphtest, detail;
#delimit cr
clear

*** 8 - Coherent Authoritarian - US Military Troop Presence - Hazard Ratios ***
version 8.2
clear
use "C:\a CAROL ISQ  article - 2006\DATA FOR POSTING - ISQ\aut-stset.dta", clear
*use "aut-stset.dta"
gen britcolxtime = britcol*_t
gen newcxtime = newc*_t
#delimit ;
stcox 
USMil_normforeignMil
USmilact_yesno
soviet_foreign_asst
USeconaid_norm 
newc 
britcol
open_i
GDP_rescaled
Ethnic_gp 
muslim_majority_yesno 
christian_majority_yesno
newcxtime
britcolxtime,
bases(consolauth_surv) basehc(consolauth_hazard) basechazard(consolauth_cumhaz) efron schoenfeld(sch*) scaledsch(sca*) cluster(ccode);
stphtest, detail;
#delimit cr
clear

*** 11 - MidGround to Democracy - Education Exchange - Hazard Ratios ***
version 8.2
clear
use "C:\a CAROL ISQ  article - 2006\DATA FOR POSTING - ISQ\mid-to-dem-stset.dta", clear
*use "mid-to-dem-stset.dta"
gen britcolxtime = britcol*_t
gen IMETyesnoxtime=IMETyesno*_t
#delimit ;
stcox 
IMETyesno
USmilact_yesno
soviet_foreign_asst
USeconaid_norm 
newc
britcol
open_i 
GDP_rescaled
Ethnic_gp 
muslim_majority_yesno 
christian_majority_yesno 
IMETyesnoxtime
britcolxtime,
bases(mgtodem_surv) basehc(mgtodem_hazard) basechazard(mgtodem_cumhaz) efron schoenfeld(sch*) scaledsch(sca*) cluster(ccode);
stphtest, detail;
#delimit cr
clear

*** 18 - MidGround to Authoritarian - US Military Troop Presence - Hazard Ratios ***
version 8.2
clear
use "C:\a CAROL ISQ  article - 2006\DATA FOR POSTING - ISQ\mid-to-aut-stset.dta", clear
*use "mid-to-aut-stset.dta"
#delimit ;
stcox 
USMil_normforeignMil 
USmilact_yesno
soviet_foreign_asst 
USeconaid_norm 
newc 
britcol
open_i
GDP_rescaled
Ethnic_gp 
muslim_majority_yesno 
christian_majority_yesno,
bases(mgtoaut_surv) basehc(mgtoaut_hazard) basechazard(mgtoaut_cumhaz) efron schoenfeld(sch*) scaledsch(sca*) cluster(ccode);
stphtest, detail;
#delimit cr
clear

log close

log using "C:\a CAROL ISQ  article - 2006\DATA FOR POSTING - ISQ\table4.log", replace
******************************************
**     INTERACTION EFFECTS MODELS       **
******************************************

*** Coherent Democracy - Education Exchange - Latin America ***
version 8.2
clear
use "C:\a CAROL ISQ  article - 2006\DATA FOR POSTING - ISQ\dem-stset.dta", clear
*use "dem-stset.dta"
gen LatAm_IMET = LatAm*IMETyesno
gen IMETyesnoxtime=IMETyesno*_t
#delimit ;
stcox 
IMETyesno
LatAm_IMET
LatAm
soviet_foreign_asst 
USeconaid_norm 
newc
britcol
open_i
GDP_rescaled
Ethnic_gp 
muslim_majority_yesno
christian_majority_yesno
IMETyesnoxtime,
bases(consoldem_surv) basehc(consoldem_hazard) basechazard(consoldem_cumhaz) efron schoenfeld(sch*) scaledsch(sca*) cluster(ccode);
stphtest, detail;
#delimit cr
clear

*** Coherent Authoritarian - Education Exchange - Latin America ***
version 8.2
clear
use "C:\a CAROL ISQ  article - 2006\DATA FOR POSTING - ISQ\aut-stset.dta", clear
*use "aut-stset.dta"
gen britcolxtime = britcol*_t
gen newcxtime = newc*_t
gen LatAm_IMET = LatAm*IMETyesno
#delimit ;
stcox 
IMETyesno
LatAm
LatAm_IMET
USmilact_yesno 
soviet_foreign_asst
USeconaid_norm 
newc 
britcol
open_i
GDP_rescaled
Ethnic_gp 
muslim_majority_yesno 
christian_majority_yesno
newcxtime
britcolxtime,
bases(consolauth_surv) basehc(consolauth_hazard) basechazard(consolauth_cumhaz) efron schoenfeld(sch*) scaledsch(sca*) cluster(ccode);
stphtest, detail;
#delimit cr
clear

*** MidGround to Democracy - Education Exchange - Latin America ***
version 8.2
clear
use "C:\a CAROL ISQ  article - 2006\DATA FOR POSTING - ISQ\mid-to-dem-stset.dta", clear
*use "mid-to-dem-stset.dta"
gen britcolxtime = britcol*_t
gen IMETyesnoxtime=IMETyesno*_t
gen LatAm_IMET = LatAm*IMETyesno
#delimit ;
stcox 
IMETyesno
LatAm
LatAm_IMET
USmilact_yesno
soviet_foreign_asst
USeconaid_norm 
newc
britcol
open_i 
GDP_rescaled
Ethnic_gp 
muslim_majority_yesno 
christian_majority_yesno 
IMETyesnoxtime
britcolxtime,
bases(mgtodem_surv) basehc(mgtodem_hazard) basechazard(mgtodem_cumhaz) efron schoenfeld(sch*) scaledsch(sca*) cluster(ccode);
stphtest, detail;
#delimit cr
clear

*** MidGround to Authoritarian - Educational Exchange - Latin America ***
version 8.2
clear
use "C:\a CAROL ISQ  article - 2006\DATA FOR POSTING - ISQ\mid-to-aut-stset.dta", clear
*use "mid-to-aut-stset.dta"
gen LatAm_IMET = LatAm*IMETyesno
#delimit ;
stcox 
IMETyesno
LatAm
LatAm_IMET
USmilact_yesno
soviet_foreign_asst 
USeconaid_norm 
newc 
britcol
open_i
GDP_rescaled
Ethnic_gp 
muslim_majority_yesno 
christian_majority_yesno,
bases(mgtoaut_surv) basehc(mgtoaut_hazard) basechazard(mgtoaut_cumhaz) efron schoenfeld(sch*) scaledsch(sca*) cluster(ccode);
stphtest, detail;
#delimit cr
clear

*** Coherent Authoritarian - Education Exchange - Military Dictator ***
version 8.2
clear
use "C:\a CAROL ISQ  article - 2006\DATA FOR POSTING - ISQ\aut-stset.dta", clear
*use "aut-stset.dta"
gen britcolxtime = britcol*_t
gen newcxtime = newc*_t
gen mildict_IMET = mildictator*IMETyesno
#delimit ;
stcox 
IMETyesno
mildictator
mildict_IMET
USmilact_yesno 
soviet_foreign_asst
USeconaid_norm 
newc 
britcol
open_i
GDP_rescaled
Ethnic_gp 
muslim_majority_yesno 
christian_majority_yesno
newcxtime
britcolxtime,
bases(consolauth_surv) basehc(consolauth_hazard) basechazard(consolauth_cumhaz) efron schoenfeld(sch*) scaledsch(sca*) cluster(ccode);
stphtest, detail;
#delimit cr
clear

*** MidGround to Democracy - Education Exchange - Military Dictator ***
version 8.2
clear
use "C:\a CAROL ISQ  article - 2006\DATA FOR POSTING - ISQ\mid-to-dem-stset.dta", clear
*use "mid-to-dem-stset.dta"
gen britcolxtime = britcol*_t
gen IMETyesnoxtime=IMETyesno*_t
gen mildict_IMET = mildictator*IMETyesno
#delimit ;
stcox 
IMETyesno
mildictator
mildict_IMET
USmilact_yesno
soviet_foreign_asst
USeconaid_norm 
newc
britcol
open_i 
GDP_rescaled
Ethnic_gp 
muslim_majority_yesno 
christian_majority_yesno 
IMETyesnoxtime
britcolxtime,
bases(mgtodem_surv) basehc(mgtodem_hazard) basechazard(mgtodem_cumhaz) efron schoenfeld(sch*) scaledsch(sca*) cluster(ccode);
stphtest, detail;
#delimit cr
clear

*** MidGround to Authoritarian - Educational Exchange - Military Dictator ***
version 8.2
clear
use "C:\a CAROL ISQ  article - 2006\DATA FOR POSTING - ISQ\mid-to-aut-stset.dta", clear
*use "mid-to-aut-stset.dta"
gen mildict_IMET = mildictator*IMETyesno
#delimit ;
stcox 
IMETyesno
mildictator
mildict_IMET
USmilact_yesno
soviet_foreign_asst 
USeconaid_norm 
newc 
britcol
open_i
GDP_rescaled
Ethnic_gp 
muslim_majority_yesno 
christian_majority_yesno,
bases(mgtoaut_surv) basehc(mgtoaut_hazard) basechazard(mgtoaut_cumhaz) efron schoenfeld(sch*) scaledsch(sca*) cluster(ccode);
stphtest, detail;
#delimit cr
clear

log close







