/*
==========================================================================
File-Name:    crstack.do
Date:         Sep 13, 2013
Author:       Fernando Martel                                 
Purpose:      Create stacked data for all countries and Gulf
Data Input:   martel5yca1.dta, ..., martel5yca5.dta  
              martel5yfr1.dta, ..., martel5yfr5.dta 
Output File:  
Data Output:  stackca.dta // ACLP population, centered quinquennia
              stackfr.dta // Ross population, forward quinqunnia
              stackcag.dta // ACLP, centered, Gulf countries
Previous file:proc_rep_master.do
Status:       Complete                                     
Machine:      Lenovo X201 tablet running Windows 7 64-bit spck 1
==========================================================================
*/

clear
global path ///
C:\Users\Fernando\Documents\docs\research_projects\Replication\analysis
cd "$path"


/*
==========================================================================
Create stack for ACLP population of country years with centered quinquenia
and Polity created from annual data

An unbalanced panel
==========================================================================
*/
clear
local i =0
local varlist = "gdpgrowth polity lnIMRwdi lnIMRunicef lnCMRwdi lnCMRunicef lnCMRwho lngdppercap lndensity lnhiv lndemyears"

while `i' <= 5 {

  * Copy imputed files to local folder
  copy "../data_clean/martel5yca`i'.dta" "./martel5yca`i'.dta", replace
  use martel5yca`i'
  xtset ctynum period

  * Create lags as the mim operator for stacked mulitply imputed data
  * does not accept L. operators in xtreg type commands
  foreach j of local varlist{
    gen `j'_1 = L.`j'
  }
  
  * First period of all lagged values will be missing but that is ok
  * Ross only used quinquennial data from 1970, while I have from 1965
  * Since this is an unbalanced panel, I cannot simply drop observations
  * for period 0.  Rather drop observations with missing values if it is 
  * an imputed dataset.  Be definiton this will drop the first period of 
  * each imputed panel
  by ctynum: generate counter = _n
  drop if counter==1

  * Save data
  save martel5yca`i', replace
  clear 
  local i = `i' + 1
}

*Stack them one of top of the other and all on top of original data
*------------------------------------------------------------------
mimstack, m(5) sortorder(ctynum period) istub(martel5yca) clear // package st0139_1
save stackca, replace 


/*
==========================================================================
Create stack for Ross population of coutnry years with forward quinquenia
and Ross (2006) original quinquennial Polity (could not be replicted using 
annual dataset)

A balanced panel
==========================================================================
*/
clear
local i =0
local varlist = "gdpgrowth polityross lnIMRwdi lnIMRunicef lnCMRwdi lnCMRunicef lnCMRwho lngdppercap lndensity lnhiv lndemyears"

while `i' <= 5 {

  * Copy imputed files to local folder
  copy "../data_clean/martel5yfr`i'.dta" "./martel5yfr`i'.dta", replace
  use martel5yfr`i'
  xtset ctynum period

  * Create lags as the mim operator for stacked mulitply imputed data
  * does not accept L. operators in xtreg type commands
  foreach j of local varlist{
    gen `j'_1 = L.`j'
  }

  * Create an additional lag for polity
  gen polityross_2 = L.polityross_1
  
  * First period of all lagged values will be missing but that is ok
  * Ross only used quinquennial data from 1970, while I have from 1965
  * Since this is a balanced panel drop observations for period 0.
  drop if period == 0

  * Save data
  save martel5yfr`i', replace
  clear 
  local i = `i' + 1
}

*Stack them one of top of the other and all on top of original data
*------------------------------------------------------------------
mimstack, m(5) sortorder(ctynum period) istub(martel5yfr) clear // package st0139_1
save stackfr, replace 
