
* Replication materials for 
* Cirone, Alexandra and Van Coppenolle, Brenda
* ‘Cabinets, Committees and Careers: The Causal Effect of Committee Service'
* The Journal of Politics

* Dofile 3/3 (historical budget incumbency table seen in main paper and online appendix)
 

/* 0. Budget Incumbency */
*******************************


* Table 1: Budget Committees and Budget Incumbency (main paper)
* Table 2: Budget Committees and Budget Incumbency: Full Period  (online appendix)

* Number of deputies
egen idtag=tag(id)
tab idtag,m


use budget_incumbency_CCC.dta, clear

bysort term year: tab year budgetincumbent if budget==1, m


 


 
