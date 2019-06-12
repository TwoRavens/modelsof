
**************************************
* Replication illustration for research, Actors and Issues in African Non-State Conflicts 
* Contact: Nina von Uexkull nina.von_uexkull@pcr.uu.se

******
* Content 

* 1) Set working directory & import data into Stata 

* 2) Merge actors and issues data by conflict id 

* 3) Create variables

* 4) Produce figure 4 with involvement by issue 

* 5) Robustness with alternative aggregation of the issues 


*******

* 1) Set working directory & load/import data into Stata 

* please replace the path below with the path to your folder

* 2) Merge actors and issues data by conflictid 

use "/Users/ninavonuexkull/Dropbox/RESEARCH/Data_pres_issues/Non-state issues/International interactions/3Subm/issues_final.dta", clear

sort conflictid year
order conflictid year 
drop if conflictid==.
 
merge 1:1 conflictid year using "/Users/ninavonuexkull/Dropbox/RESEARCH/Data_pres_issues/Non-state issues/International interactions/3Subm/2nd_support_final.dta" 

* 3) Create variables 
 
gen any_support=0   //* this creates indicators for support to either side 
replace any_support=1 if Any_A!=. & Any_A>0
replace any_support=1 if Any_B!=. & Any_B>0
 
 
gen issues_3=0  if issueauthority!=. //this creates mutually exclusive issue cathegories
replace issues_3=1 if issueauthority==1 
replace issues_3=2 if issueauthority==0 & issueterritory==1 
replace issues_3=3 if issueauthority==0 & issueterritory==0 & issuelootable==1 
replace issues_3=3 if issueauthority==0 & issueterritory==0 & issueother==1 
replace issues_3=. if issueauthority==0 & issueterritory==0 & issueother==0 & subissueunknown==1
 
 

* 4) Produce figure 4 with involvement by issue 

tab  any_support issues_3, column chi2



graph bar any_support, over(issues_3) 


*5) Robustness with alternative aggregation of the issues 

 gen issues_3b=0  if issueauthority!=. //this creates mutually exclusive issue cathegories but for territory, this is for robustness
replace issues_3b=1 if  issueterritory==1 
replace issues_3b=2 if  issueterritory==0 & issueauthority==1 
replace issues_3b=3 if  issueterritory==0 & issueauthority==0 & issuelootable==1 
replace issues_3b=3 if  issueterritory==0 & issueauthority==0 & issueother==1 
replace issues_3b=. if  issueterritory==0 & issueauthority==0 & issueother==0 & subissueunknown==1
 hist issues_3b
 
tab  any_support issues_3b, column chi2

tab any_support issueauthority, column chi2
tab  any_support issueterritory, column chi2
tab any_support subissueformal, column chi2
tab  any_support issuelootable, column chi2

