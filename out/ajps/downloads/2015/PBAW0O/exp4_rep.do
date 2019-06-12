** Experiment 4, Wave 1 Replication Data ** 
** September 2012 ** 

** Read in the wave 1 data ** 
use exp4_wave1_rep.dta, clear 

** Analysis for All Respondents, Wave 1 (colum 1, table A4.4) ** 
reg rs_immig1 i.relational_treat

** Read in the data with both waves merged together ** 
use exp4_both_rep.dta, clear 
 
** Analysis for time 1 compliers (column 2) ** 
reg rs_immig1 i.relational_treat 

** Analysis for time 2 (column 3) ** 
reg rs_immig2 i.relational_treat 

** Sample characteristics ** 
table q33 
table q34 
table q35 
table q41 

** Manipulation Check ** 
oneway q93 relational_treat
