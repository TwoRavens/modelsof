**data preparation for replication

use "/Users/peterjohnloewen/Dropbox/Parliament Experiment/Field Experiment/Final documents/originaldata.dta", clear
set more off

drop member
gen member=IDmember


drop ERROR

rename PAULHELP HELPscorer1
rename KELLYHELP HELPscorer2

gen ERROR=HELPscorer1-HELPscorer2

gen TREATMENT=-1 if OUT==1
replace TREATMENT=0 if IN+OUT==0 
replace TREATMENT=1 if IN==1


drop email1 dateoffirstresponse dateoflastresponse issuearea INAREA SUPPORTinAREA MARGIN-CUT CHANGE FEMALEchange FRENCHchange OUTchange INchange Population Government Party Gender White Male WHITE Cabinet New  email TEST ETHNICc 
save "/Users/peterjohnloewen/Dropbox/Parliament Experiment/Field Experiment/Final documents/Replication data_Loewen and Mackenzie_public.dta", replace

