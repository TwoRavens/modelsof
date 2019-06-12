/*
**************************************************************************
File-Name:    antable3.do                         
Date:         Aug 23, 2008                                    
Author:       Fernando Martel                                 
Purpose:      Replicate Table 3 in Ross, Michael "Is Democracy Good for 
              the Poor?", American Journal of Political Science, Vol. 50,
              No. 4, October 2006, Pg. 860-­874.  
              I use data kindly provided to me by the author.
Data Input:   - replication data - 5 year panels.dta
              Received from author via e-mail Aug 18th 2008.  
              Contains QUINQUENNIAL averages of all data used in Table 3 
              except for UNICEF's child mortality rate, the dependent 
              variable in table 3 according to the paper.  However it con-
              tains cmr from WDI which is what the author actually used:
              there is an inconsistency btw what is said in the paper and
              done in the estimations.
Output File:  table3.tex
Data Output:  None
Previous file:pure_rep_master.do
Status:       Complete
Machine:      IBM, X41 tablet running Windows XP spck 3                                
**************************************************************************
*/

clear
global path ///
C:\Users\Fernando\Documents\docs\research_projects\Replication\analysis
cd "$path"
#delimit;


* Open original quinqennial replication file sent by Prof Ross and*;
*Copy it to local drive and sort it by merge variables*;
copy "..\data_raw\Ross_Replication_Data\replication data - 5 year panels.dta" 
     actual.dta, replace;
use actual;


* Replicate all columns in table 3;
* Column 1 - LDV only with panel specific autocorrelation;
xtpcse logCMRwdi  logCMRwdi_1 logGDPcap_1  logHIV_1 logDen_1 GDPgrowth_1, corr(psar1);
est2vec table3, replace vars(logGDPcap_1  logHIV_1 logDen_1 GDPgrowth_1 Polity_1 logDEMYRS_1) name(c1);

*Column 2 - LDV only with panel specific autocorrelation and polity*;
xtpcse logCMRwdi  logCMRwdi_1 logGDPcap_1  logHIV_1 logDen_1 GDPgrowth_1 Polity_1, corr(psar1);
est2vec table3, addto(table3) name(c2);

*Column 3 - LDV and period dummies*;
xtpcse logCMRwdi  logCMRwdi_1 logGDPcap_1  logHIV_1 logDen_1 GDPgrowth_1 Polity_1 dperiod*, 
	corr(psar1);
est2vec table3, addto(table3) name(c3);

*Column 4 - FE & period dummies*;
reg logCMRwdi logGDPcap_1  logHIV_1 logDen_1 GDPgrowth_1  Polity_1  dperiod* IDdum*, robust;
est2vec table3, addto(table3) name(c4);

*Column 5 - LDV only and democratic years*;
xtpcse logCMRwdi logCMRwdi_1 logGDPcap_1  logHIV_1 logDen_1 GDPgrowth_1   logDEMYRS_1, corr(psar1);
est2vec table3, addto(table3) name(c5);

*Column 6 - LDV and democratic years and period dummies*;
xtpcse logCMRwdi  logCMRwdi_1 logGDPcap_1  logHIV_1 logDen_1 GDPgrowth_1 logDEMYRS_1 dperiod*, 
	corr(psar1);
est2vec table3, addto(table3) name(c6);

*Column 7 - FE & democratic years & period dummies*;
reg logCMRwdi logGDPcap_1  logHIV_1 logDen_1 GDPgrowth_1  logDEMYRS_1  dperiod* IDdum*, robust;
est2vec table3, addto(table3) name(c7);
est2tex table3, replace preserve dot;
copy table3.tex ..\reports\table3.tex, replace;

clear;
