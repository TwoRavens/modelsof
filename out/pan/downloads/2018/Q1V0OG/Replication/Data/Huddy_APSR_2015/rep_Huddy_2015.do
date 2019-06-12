clear

use13 "/Users/jonathanmummolo/Dropbox/Interaction Paper/Data/data_for_apsr_sample/Huddy_APSR_2015/blog study data coded.dta", clear



***Model 2
***Anger with id and issue strength
reg totangry c.pidstr2##i.threat c.pidentity##i.threat c.issuestr2##i.threat c.knowledge c.educ i.male c.age10 if miss3==0, robust  


gen sample = e(sample)

keep if sample==1

saveold "rep_huddy_2015a"

clear

use13 "/Users/jonathanmummolo/Dropbox/Interaction Paper/Data/data_for_apsr_sample/Huddy_APSR_2015/blog study data coded.dta", clear


***Enthusiasm and support with id and issue strength
reg totpos c.pidstr2##i.support c.pidentity##i.support c.issuestr2##i.support c.knowledge c.educ i.male c.age10 if miss3==0, robust


gen sample = e(sample)

keep if sample==1

saveold "rep_huddy_2015b"
