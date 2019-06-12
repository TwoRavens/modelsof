** Experiment 3 Replication ** 
** Sept 2012 ** 

** Read in the data ** 
use exp3_rep.dta, clear 

** Sample description ** 
table q33 
table q34 
table q35 
table q41 

** Manipulation check ** 
oneway q93 treat2 

** Analysis ** 
reg rs_dv i.treat2##i.pref  
test 2.treat2 + 2.treat2#2.pref = 0 /* p =.06, one-tailed */ 
test 3.treat2 + 3.treat2#3.pref = 0 /* p =.12, one-tailed */ 
