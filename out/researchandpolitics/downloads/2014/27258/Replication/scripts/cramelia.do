/*
==========================================================================
File-Name:    cramelia.do
Date:         Sep 12, 2013
Author:       Fernando Martel Garcia
Purpose:      Prepare dataset to be imputed in R and Amelia II.  Two
              datasets:

              - martel5yca.dta  Uses ACLP population of country years and 
                                centered quinquennia (e.g. datum for 1970 
                                quinquenium is average of 1968-1972)
              - martel5yfr.dta  Uses Ross (2006) population of country years,
                                forward quinquennia (e.g. datum for 1970 
                                quinquenium is average of 1970-1974), and 
                                Ross (2006) coding of Polity in quinquennial
                                data, which cannot be replicated from annual
                                data.
Input:        martel5yc.dta, martel5yf.dta
Output File:  none
Data Output:  martel5yca.dta, martel5yfr.dta
Previous file:proc_rep_master.do
Status:       Complete                      
Machine:      IBM, X201 tablet running Windows 7 64-bit spck 1
==========================================================================
*/

clear

global path ///
C:\Users\Fernando\Documents\docs\research_projects\Replication\analysis
cd "$path"


/* 
==========================================================================
Generate five-year centered data with my Polity using ACLP population of 
country years
==========================================================================
*/
use martel5yc
keep if rosspop==1 & aclppop==1
keep ctynum ctycode period lnIMRwdi lnIMRunicef lnCMRwdi lnCMRunicef lnCMRwho polity ///
     lngdppercap lndensity lnhiv lndemyears transition gdpgrowth smallstate
tabulate period, gen(dperiod)
drop dperiod1 dperiod2 // to avoid multicollinearity
save martel5yca0, replace

/* 
==========================================================================
Generate five-year forward centered data with Ross Polity using Ross (2006)
population of country years
==========================================================================
*/
use martel5yf
keep if rosspop==1
keep ctynum ctycode period lnIMRwdi lnIMRunicef lnCMRwdi lnCMRunicef lnCMRwho polityross ///
     lngdppercap lndensity lnhiv lndemyears transition gdpgrowth smallstate
tabulate period, gen(dperiod)
drop dperiod1 dperiod2 // to avoid multicollinearity
save martel5yfr0, replace

clear