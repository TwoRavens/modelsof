
* Setup

program drop _all 
*do "ivreg2.ado" 
*do "outreg.ado" 

* data 
do "$dofiles/data.recoding2_jan09.do" 
do "$dofiles/data.merging_jan09.do" 
do "$dofiles/data.panel2_jan09.do" 
do "$dofiles/data.final_data.do" 
