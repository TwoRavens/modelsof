************************************************************************************************************
**** Basic Descriptives re: different regime types' accountability, flexibility, and transparency **********
************************************************************************************************************

use "AccFlexTrans.dta"

***** Accountability -- Audience Cost Capacity (Uzonyi et al. 2012)
tab acc if sp==1
tab acc if mil==1
tab acc if per==1

*Comparison of sp regime to mil regimegen sp_mil=.replace sp_mil=1 if sp==1replace sp_mil=0 if mil==1ranksum acc, by (sp_mil) *Comparison of sp regime to per regimegen sp_per=.replace sp_per=1 if sp==1replace sp_per=0 if per==1ranksum acc, by (sp_per) *Comparison of mil regime to per dyadsgen mil_per=.replace mil_per=1 if mil==1replace mil_per=0 if per==1ranksum acc, by (mil_per)


***** Flexibility -- POLCON (Henisz 2000)
sum h_polcon5 if sp==1
sum h_polcon5 if mil==1
sum h_polcon5 if per==1

*Comparison of sp regime to mil regimettest h_polcon5, by (sp_mil) unpaired unequal*Comparison of sp regime to per regimettest h_polcon5, by (sp_per) unpaired unequal *Comparison of mil regime to per dyadsttest h_polcon5, by (mil_per) unpaired unequal


****** Transparency -- Freedom of the Press (Freedom House)
sum fh_press if sp==1
sum fh_press if mil==1
sum fh_press if per==1

*Comparison of sp regime to mil regimettest fh_press, by (sp_mil) unpaired unequal*Comparison of sp regime to per regimettest fh_press, by (sp_per) unpaired unequal *Comparison of mil regime to per dyadsttest fh_press, by (mil_per) unpaired unequal

