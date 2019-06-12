/**********************************************************************
File-Name:    crross.do                         
Date:         May 25th, 2009                                    
Author:       Fernando Martel                                 
Purpose:      Convert Ross (2006) country codes to universal country codes.
              Article claims to be using WB country codes but uses YUG 
              for Serbian and Montenegro, WB does not have YUG but SCG
              Also need universal codes to merge ACLP data after those data 
              are also converted to universal ctycodes.
Data Input:   - main_replication_data.dta
              Received from author via e-mail Feb 25th 2007.  
              Contains ANNUAL data used in the paper, except for HIV data 
              and democratic years.
              Data spans 1965 to 2000
              - replication data - 5 year panels.dta
              Received from author via e-mail Aug 18th 2008. 
              Contains QUINQUENNIAL data used in the estimations. 
              Data spans 1970 to 2000
Output File:  None
Data Output:  ross1y and ross5y                                   
Previous file:crmaster.do
Status:       Complete                                     
Machine:      IBM, X201 tablet running Windows 7 64-bit SP 1                                
*************************************************************************/

clear

// Set global path to working directory for this task
global path ///
C:\Users\Fernando\Documents\docs\research_projects\Replication\data_clean
cd "$path"


*==========================================================================
*ANNUAL DATA
*
*Change codes in annual data
*==========================================================================

* Load Ross annual dataset
* ------------------------
clear
copy "..\data_raw\Ross_Replication_Data\main_replication_data.dta" ///
 ".\ross1y.dta", replace
use ross1y

* Add wbctycode variable for merging into cty dictionary 
* ------------------------------------------------------
*Ross claims to be using these (see id label)
gen wbctycode = id
order wbctycode id1 cty_name year
save ross1y, replace

* Sort universal ctycode and ctyname variables on wbctycode so we can merge 
* using data dictionary
* -------------------------------------------------------------------------
clear
use ctydic, clear
sort wbctycode, stable
save ctydic, replace
clear

* Merge ctycode ctyname
* ---------------------
use ross1y
sort wbctycode year, stable
drop _merge
merge wbctycode using ctydic, keep(ctycode ctyname)
drop wbctycode
order id cty_name ctycode ctyname
tab _merge

* The only occassion where _merge==1 is for YUG.
* Ross (2006) claims to be using WB ctycode, but WB has no code for YUG
* YUG here refers to Serbia and Montenegro
* YUG war starts 1991, when Solvenia and Croatia declare independence
* ACLP code this as Yugoslavia2
* 1993-07-28 (Newsletter III-45): Numeric code of Yugoslavia changed from 
* 890 to 891 (a consequence of the splitting off of Bosnia and Herzegovina,
* Croatia, Macedonia, and Slovenia).
* What remains is Serb & Mon. (which splits in 2006, beyond our sample)
* The correct ctycode is SCG
* See http://www.infoplease.com/spot/yugotimeline1.html

* Replace YUG with SCG
* --------------------
* In theory should replace for years >=1991 but replace all the way back 
* since that is what Ross (2006) does.
replace ctycode="SCG" if id=="YUG"
replace ctyname="Serbia and Montenegro" if ctycode=="SCG"
order id cty_name ctycode ctyname
table  cty_name _merge

* Note ctydict has more countries and territories tha Ross (2006)
* I wil drop these
table  ctyname _merge

drop if _merge==2 //Coutry dic has more countries and territories tha Ross
drop _merge
drop id cty_name id1 

* Create new numeric cty var
* --------------------------
encode  ctycode, gen(ctynum)
move ctynum year
sort ctycode year, stable
save ross1y, replace


*=========================================================================
*QUINQUENNIAL DATA
*
*=========================================================================

* Load Ross 5y dataset
clear
copy "..\data_raw\Ross_Replication_Data\replication data - 5 year panels.dta" ///
	".\ross5y.dta", replace
use ross5y

* Add wbctycode variable for merging into cty dictionary 
* ------------------------------------------------------
* Ross (2006) claims to be using EDR ctry codes (var id label:"3 letter 
* country code from WDR classification")
gen wbctycode = id
order wbctycode id country period
save ross5y, replace

* Sort universal ctycode and ctyname variables on wbctycode so we can merge 
* using data dictionary
* -------------------------------------------------------------------------
clear
use ctydic, clear
sort wbctycode, stable
save ctydic, replace
clear

*Merge ctycode ctyname
*---------------------
use ross5y
sort wbctycode, stable
merge wbctycode using ctydic, keep(ctycode ctyname)
drop wbctycode
order id country ctycode 

* Ross (2006) claims to be using WB ctycode, but WB has no code for YUG
* YUG here refers to Serbia and Montenegro
* YUG war starts 1991, when Solvenia and Croatia declare independence
* ACLP code this as Yugoslavia2
* 1993-07-28 (Newsletter III-45): Numeric code of Yugoslavia changed from 890 to 891
* (a consequence of the splitting off of Bosnia and Herzegovina, Croatia, Macedonia, and Slovenia).
* What remains is Serb & Mon. (which splits in 2006, beyond our sample)
* The correct ctycode using Ross (2006) logic is SCG
* See http://www.infoplease.com/spot/yugotimeline1.html
* duplicates e  ctycode id ctyname, clean

* Since Ross runs current countries back into history
* Hence change his coding of Yugoslavia as YUG to SCG 
* Replace YUG with SCG for years >=1991
replace ctycode="SCG" if id=="YUG"
replace ctyname="Serbia and Montenegro" if id=="YUG"
order id ctycode ctyname
table  ctycode _merge
drop if _merge==2 
drop _merge
drop id country

* Note Cyprus (CYP) only has data for Polity and small state dummy.
* All other data are mssing in quinquennial data but
* are avalable in annual data!
list ctycode period GDPgrowth_1 Polity_1 logCMRwdi logCMRwdi_1 logDEMYRS_1 ///
  logDen_1 logGDPcap_1 logHIV_1 logIMRunicef_1 logIMRwdi_1 smallstate ///
  transition_1 if ctycode=="CYP", clean noobs c


*Create new numeric cty var
encode  ctycode, gen(ctynum)
move ctynum period
sort ctycode period, stable
save ross5y, replace

clear


  
