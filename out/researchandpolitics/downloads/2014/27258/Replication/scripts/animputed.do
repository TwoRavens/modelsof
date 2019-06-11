/*
==========================================================================
File-Name:    animputed.do
Date:         Sep 9, 2013
Author:       Fernando Martel                                 
Purpose:      Check imputed datasets created by Ross
Data Input:   mr1replication1.dta
              ... 
              mr1replication5.dta
Output File:  none
Data Output:  none
Previous file:pure_rep_master.do
Status:       In progress                                     
Machine:      IBM, X201 tablet running Windows 7 64-bit spck 1                                
==========================================================================
*/

clear
global path ///
C:\Users\Fernando\Documents\docs\research_projects\Replication\analysis
cd "$path"

/*
==========================================================================
Check the imputations
==========================================================================
*/
use ../data_raw/Ross_Replication_Data/mr1replication1

#delimit;
global rossvars = "logCMRwdi logCMRwdi_1 logCMRunicef logCMRunicef_1
  logCMRwho logCMRwho_1 logIMRwdi logIMRwdi_1 logIMRunicef logIMRunicef_1
  logGDPcap_1 logHIV_1 logDen_1 GDPgrowth_1 PolityB_1  logDEMYRS_1
 transition_1 smallstate";
#delimit cr

mdesc $rossvars  // Uses mdesc package
use ../data_raw/Ross_Replication_Data/mr1replication2
mdesc $rossvars  // Uses mdesc package

* Presumably all five imputed datasets where created using the same 
* imputation routine so it seems Polity was excluded from the imputation