*Replication materials to reproduce Table 2 in Park, Sunhee. "Power and Civil War Termination Bargaining." International Studies Quarterly

use Park_Power_and_Civil_War_Termination_Bargaining.dta, clear

set more off

log using "Park_Power and Civil War Termination Bargaining_Replication.txt", text replace

** Summary Statistics 

sum strong status_dummy multiple_bargaining type_cabinet type_parliament participants_nums third_party battlefield intensity duration if strong!=., detail


*Running the Model
logit demand_more strong status_dummy multiple_bargaining type_cabinet type_parliament participants_nums third_party battlefield intensity duration, robust

log close














 
