/*
==========================================================================
File-Name:    crmartel5y.do
Date:         Sep 9, 2013
Author:       Fernando Martel                                 
Purpose:      Recreate Ross's (2006) quinquennial data from Ross's (2006) 
              annual data correcting procedural errors identified in 
              previous steps,  including:
              - Include annual data for CYP
              - CMRwdi for Eritrea is 0 in 1970, set it to missing
              - Center averages but also include forward averages so can 
                match with Ross's (2006) quinquennial polity that cannot be
                replicated
              - Take logs and lags after averaging
              - Truncate quinquenial data to 1970 after taking lag for 1970
              - Have two versions of Polity, as could not replicate 
                quinquennial data from annual data
              - Delete imputed lag for 1970 for DVs
              - Check HIV, lag missing in 1970 even though Ross (2006) codes
                it as 0
              - Take account of proper birth and death of countries 
                (unbalanced panel)
Data Input:   ross1y, ross5y
Output File:  none
Data Output:  martel1y, martel5yc, martel5yf
Previous file:proc_rep_master.do
Status:       Complete                                     
Machine:      IBM, X201 tablet running Windows 7 64-Bit spck 1
==========================================================================
*/

clear
global path ///
C:\Users\Fernando\Documents\docs\research_projects\Replication\analysis
cd "$path"

/*
==========================================================================
 Merge ACLP population for later checks
 Create ACLP population of coutry years dummy
 aclppop = 1 if country year in aclp database, . otherwise.
==========================================================================
*/
clear
use ../data_clean/aclp

* Generate flag for ACLP country years
gen aclppop = 1  
drop if year<1965 // Year where Ross's (2006) annual data starts

* Recode ctycode for Ethiopia
list ctycode ctyname year if ctycode=="ETH" | ctycode =="ET2", clean noobs

* Recode so ETH refers to the most recent entity
replace ctycode="ET1" if ctycode=="ETH" 
replace ctycode="ETH" if ctycode=="ET2"

* Correct country names to reflect changes 
replace ctyname="Ethiopia" if ctycode=="ETH"
replace ctyname="Ethiopia1" if ctycode=="ET1"
list ctycode ctyname year if ctycode=="ETH" | ctycode =="ET1", clean noobs

* Recode Cyprus.  In 1983 turkish part declares itself Republic of northern
* Cyprus. 
list ctycode ctyname year if ctycode=="CYP" | ctycode =="CY2", clean noobs

* Recode so CYP refers to the most recent entity
replace ctycode="CY1" if ctycode=="CYP" 
replace ctycode="CYP" if ctycode=="CY2"
replace ctyname="Cyprus" if ctycode=="CYP"
replace ctyname="Cyprus1" if ctycode=="CY1"

list ctycode ctyname year if ctycode=="CYP" | ctycode =="CY1", clean noobs

* Save
keep ctycode ctyname year aclppop
sort ctycode year, stable
save aclppop, replace

* Merge ross1y onto  aclppop data
merge ctycode year using ../data_clean/ross1y
tab _merge   

* Replace missing in aclpop with 0s
replace aclppop=0 if aclppop==.

* Generate dummy for ross population of country years
gen rosspop = 0
replace rosspop = 1 if _merge > 1
drop _merge
tab rosspop
tab aclppop

* Check Cyprus
list ctycode ctyname year aclppop rosspop if ctycode=="CYP"  | ctycode=="CY1", ///
   clean noobs

/*
==========================================================================
Create two versions of quinquennial data:
 - Centered (generally accepted practice, e.g. quinquennia 
   for 1970 refers to average for 1968-1972
 - Forward centered  (e.g. 1970 quinquennia refers to 
   1970-1974)
 - Note mortality data is for years 1965, 1970, ..., 
   1995, 2000
==========================================================================
*/

* Create small state dummy that was used in imputation model
gen temp = 0
replace temp = 1 if population <1000000 & year == 2000
sort ctycode year,  stable
by ctycode: egen smallstate = max(temp)
drop temp

* Select the relevant variables, note HIV missing in annual dataset
keep ctycode ctynum ctyname year aclppop ///
     IMRwdi infmort_unicef U5MRwdi kidmort_unicef kidmort_who ///
     Polity ///
     rgdpch density GDPgrowth smallstate ///
     rosspop aclppop

* Create new numeric cty var, to account for different aclp population
drop ctynum
encode  ctycode, gen(ctynum)
order ctynum ctycode ctyname year
xtset ctynum year

* Create centered and forward indicators for five year blocks
gen periodc = floor((year - 1963) / 5)
gen periodf = floor((year - 1965) / 5)

* Correct proble  data for Eritrea, CMRwdi is 0 in 1970, set it to missing
list ctycode year U5MRwdi if ctycode=="ERI" & year==1970
replace U5MRwdi = . if ctycode=="ERI" & year==1970


* Save the new annual dataset
save martel1y, replace


* Create centered quinquennial dataset
* ------------------------------------
* Note collapse creates averages ignoring missing
* Note this dataset is missing HIV which I will need to add from 
* quinquennial dataset.  HIV is not centered.
* Also polity in annual data does not match polity in quinquennial data
drop periodf
collapse (mean)  aclppop GDPgrowth IMRwdi Polity U5MRwdi density ///
   infmort_unicef kidmort_unicef kidmort_who rgdpch rosspop ///
   smallstate, by(ctynum ctycode ctyname periodc) 
sort ctycode period, stable

* Rename varaibles to have consistent mnemonics
rename infmort_unicef IMRunicef
rename U5MRwdi CMRwdi
rename kidmort_unicef CMRunicef
rename kidmort_who CMRwho
rename rgdpch gdppercap
rename Polity polity
rename GDPgrowth gdpgrowth

* Create logs 
local varlist1 "IMRwdi IMRunicef CMRwdi CMRunicef CMRwho gdppercap density"
foreach x of local varlist1 {
 di"`x'"
	gen ln`x' = ln(`x')
}
rename periodc period
sort ctycode period, stable
save martel5yc, replace


* Create forward  quinquennial dataset
* -------------------------------------
* Note collapse creates averages ignoring missing
* Note this dataset is missing HIV which I will need to add from 
* quinquennial dataset.  HIV is not centered.
clear
use martel1y
drop periodc

collapse (mean)  aclppop GDPgrowth IMRwdi Polity U5MRwdi density ///
   infmort_unicef kidmort_unicef kidmort_who rgdpch rosspop ///
   smallstate, by(ctynum ctycode ctyname periodf) 
sort ctycode period, stable

* Rename varaibles to have consistent mnemonics
rename infmort_unicef IMRunicef
rename U5MRwdi CMRwdi
rename kidmort_unicef CMRunicef
rename kidmort_who CMRwho
rename rgdpch gdppercap
rename Polity polity
rename GDPgrowth gdpgrowth

* Create logs 
local varlist1 "IMRwdi IMRunicef CMRwdi CMRunicef CMRwho gdppercap density"
foreach x of local varlist1 {
 di"`x'"
	gen ln`x' = ln(`x')
}
rename periodf period
sort ctycode period, stable
save martel5yf, replace


* Append variables from ross5y that could not be replicated from ross1y
* ---------------------------------------------------------------------
* Becasue HIV data is only available in ross5y, merge it in
* Make HIV = 0 in periods before 1970
* Start with forward centered data
clear 
use martel5yf
merge ctycode period using ../data_clean/ross5y, keep(Polity_1 logHIV_1 logDEMYRS_1 transition_1)
tab _merge
tab _merge if rosspop==1 & period>0 // as expected

* Remove the lag
xtset ctynum period
gen lnhiv = F.logHIV_1
gen polityross = F.Polity_1
gen lndemyears = F.logDEMYRS_1
gen transition = F.transition_1
drop *_1

* Ross assumes lnHIV = 0 before 1980 yet still has missings
replace lnhiv = 0 if lnhiv == . & period<=3 
save martel5yf, replace

* Now repeat for centered quinquennial data
clear 
use martel5yc
merge ctycode period using ../data_clean/ross5y, keep(Polity_1 logHIV_1 logDEMYRS_1 transition_1)
tab _merge
tab _merge if rosspop==1 & period>0  // as expected

* Remove the lag
xtset ctynum period
gen lnhiv = F.logHIV_1
gen polityross = F.Polity_1
gen lndemyears = F.logDEMYRS_1
gen transition = F.transition_1
drop *_1

* Ross assumes lnHIV = 0 before 1980 yet still has missings
replace lnhiv = 0 if lnhiv == . & period<=3 
save martel5yc, replace
