/*
==========================================================================
File-Name:    ancheckmiss.do                         
Date:         Sep 10th, 2013                                    
Author:       Fernando Martel                                 
Purpose:      Check missingness and missingness patterns.
Data Input:   - ross1y
              Created from main_replication_data.dta
              Received from author via e-mail Feb 25th 2007.  
              Contains ANNUAL data used in the paper, except for HIV data 
              and democratic years.
              Data spans 1965 to 2000.
              ross1y contains standardised country codes added by crmaster.do
              - ross5y
              cretaed from replication data - 5 year panels.dta
              Received from author via e-mail Aug 18th 2008.  
              Data spans 1970 to 2000
              ross5y contains standardised country codes added by crmaster.do
              - aclp
              Przeworski et als regime data.
Output File:  None
Data Output:  None                                   
Previous file:crmaster.do (creates aclp ross1y and ross5y)
              anmaster.do 
Status:       Complete                                     
Machine:      Lenovo X201 tablet running Windows 7 64-bit spck 1
**************************************************************************
*/

* Load datat
clear
use ../data_clean/ross5y
************************************************************************
*Define local varlist
************************************************************************
#delimit ;
global rossvars = " logCMRwdi smallstate logCMRwdi_1 logIMRunicef_1 logIMRwdi_1 
 logGDPcap_1 logHIV_1 logDen_1 GDPgrowth_1 Polity_1  logDEMYRS_1 
 transition_1";
global rossregfe = "logCMRwdi logGDPcap_1 logHIV_1 logDen_1 
 GDPgrowth_1 Polity_1 ";
global rossregldv = "logCMRwdi logCMRwdi_1 logGDPcap_1 logHIV_1 logDen_1
 GDPgrowth_1 logDEMYRS_1";
di "$rossvars";
di "$rossregfe";
di "$rossregldv";
#delimit cr

**************************************************************************
*Summary statistics for $rossvars
**************************************************************************
tabstat  $rossvars, stat(count mean sd min max) columns(statistics) ///
         format(%7.1f)
mdesc $rossvars  // Uses mdesc package


**************************************************************************
*Test - Check missing patterns for $rossvars
**************************************************************************
quietly: su ctynum
local K = wordcount("$rossvars")    //calculate no of relevant vars (cols)
local NT = `r(max)' * 7                       //calculate no of obs (rows) 
local NTK = `NT' * `K'               //calcualte number of cells in matrix 
di "Data frame has `NT' observations (rows), `K' variables (columns) and a total of `NTK' cells"

mdesc $rossvars
tabmiss $rossvars // Uses tabmiss package
mvpatterns $rossvars // Uses package dm91
misschk $rossvars, dummy gen(M_)    // generates observation matrix uses package spost9_ado

*Compute number of cells missing
su M_number
local misscells = round( r(N) * r(mean) / `NTK', .001)*100
di "`misscells' percent of cells are missing "

*Compute number of rows with at least one missing (case wise deleted)
su M_number if M_number==0
local missrow = `NT' - r(N)
local missrowpct = round(`missrow' / `NT',.001)*100
di "`missrow' out of `NT' rows (i.e country years) have at least one missing, or `missrowpct' percent"
di "Case wise deletion drops `missrowpct' percent of the cells even though only `misscells' percent are missing"

*Compute number of complete panels dropped
gen temp=1 if M_number>0
by ctycode: egen temp1 = sum(temp)
generate misspanels = 0
replace misspanels = 1/7 if temp1 == 7
su misspanels
local misspanels = round(r(N) * r(mean), .001)
di "Case wise deletion drops `misspanels' countries altogether"
drop temp temp1

*Compute number of missing years
generate temp=1 if M_number >0
tab period temp
di "Case wise deletion drops period 1-5 inclusive"
drop M_* misspanels temp


**************************************************************************
*Test - Check missing patterns for $rossregfe
**************************************************************************
quietly: su ctynum
local K = wordcount("$rossregfe")	    //calculate no of relevant vars (cols)
local NT = `r(max)' * 7              //calculate no of obs (rows) 
local NTK = `NT' * `K'                //calcualte number of cells in matrix 
di "Data frame has `NT' observations (rows), `K' variables (columns) and a total of `NTK' cells"

mdesc $rossregfe
tabmiss $rossregfe
mvpatterns $rossregfe
misschk $rossregfe, dummy gen(M_)    // generates observation matrix

*Compute number of cells missing
su M_number
local misscells = round( r(N) * r(mean) / `NTK', .001)*100
di `misscells'
di "`misscells' percent of cells are missing "

*Compute number of rows with at least one missing (case wise deleted)
su M_number if M_number==0
local missrow = `NT' - r(N)
di `missrow'
local missrowpct = round(`missrow' / `NT' *100 , .001)
di "`missrow' out of `NT' rows (i.e country years) have at least one missing, or `missrowpct' percent"
di "Casewise deletion drops `missrowpct' percent of the cells even though only `misscells' percent are missing"

*Compute number of complete panels dropped
gen temp=1 if M_number>0
by ctycode: egen temp1 = sum(temp)
generate misspanels = 0
replace misspanels = 1/7 if temp1 == 7
su misspanels
local misspanels = round(r(N) * r(mean), .001)
di "Case wise deletion drops `misspanels' countries altogether"
drop temp temp1

*Compute number of missing years
generate temp=1 if M_number >0
tab period temp
di "Case wise deletion drops period 1, 2 and 4"

drop misspanels temp

/*************************************************************************
Test - Check missing in period 1
*************************************************************************/

*Check quinuennial variables
su period
tab period
format $rossvars %7.1f
tabstat  $rossvars if period==1, ///
         stat(count mean sd min max) columns(statistics) ///
         format(%7.1f)
mdesc $rossvars  if period==1

*Data for all varaibles except CMR and polity are missing, sample really 
*only starts in 1975
*This is very surprising: (1) Annual data is available and (2) even HIV. 
*which by assumption should be 0 in 1970, is missing?!



