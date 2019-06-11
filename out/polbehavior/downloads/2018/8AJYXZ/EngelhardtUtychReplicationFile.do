/*Engelhardt and Utych
Grand Old (Tailgate) Party? Partisan discrimination in apolitical settings Replication file*/


*Study 1

use mergeddata_stata12.dta, clear

*Table 1
logit accept partisan treat800 
reg price2n partisan treat800 
reg price partisan treat800 

*Table B1 and Figure 1 and 2

logit accept copart_treat outpart_treat control treat800 
reg price2n copart_treat outpart_treat control treat800 
reg price copart_treat outpart_treat control treat800 

logit accept copart_treat outpart_treat control treat800 
margins, at(copart_treat=(1) outpart_treat=(0) control=(0)) l(90) saving(e1, replace)
margins, at(copart_treat=(0) outpart_treat=(1) control=(0)) l(90) saving(e1, replace)
margins, at(copart_treat=(0) outpart_treat=(0) control=(1)) l(90) saving(e1, replace)
margins, at(copart_treat=(0) outpart_treat=(0) control=(0)) l(90) saving(e1, replace)

reg price2n copart_treat outpart_treat control treat800 
margins, at(copart_treat=(1) outpart_treat=(0) control=(0)) l(90) saving(e1, replace)
margins, at(copart_treat=(0) outpart_treat=(1) control=(0)) l(90) saving(e1, replace)
margins, at(copart_treat=(0) outpart_treat=(0) control=(1)) l(90) saving(e1, replace)
margins, at(copart_treat=(0) outpart_treat=(0) control=(0)) l(90) saving(e1, replace)

reg price copart_treat outpart_treat control treat800 
margins, at(copart_treat=(1) outpart_treat=(0) control=(0)) l(90) saving(e1, replace)
margins, at(copart_treat=(0) outpart_treat=(1) control=(0)) l(90) saving(e1, replace)
margins, at(copart_treat=(0) outpart_treat=(0) control=(1)) l(90) saving(e1, replace)
margins, at(copart_treat=(0) outpart_treat=(0) control=(0)) l(90) saving(e1, replace)

*Table 3
reg soc_dist partisan treat800 
reg trust partisan treat800 

*Table B2 and Figure 3
reg soc_dist copart_treat outpart_treat control treat800 
reg trust copart_treat outpart_treat control treat800 

reg soc_dist copart_treat outpart_treat control treat800 
margins, at(copart_treat=(1) outpart_treat=(0) control=(0)) l(90) saving(e1, replace)
margins, at(copart_treat=(0) outpart_treat=(1) control=(0)) l(90) saving(e1, replace)
margins, at(copart_treat=(0) outpart_treat=(0) control=(1)) l(90) saving(e1, replace)
margins, at(copart_treat=(0) outpart_treat=(0) control=(0)) l(90) saving(e1, replace)

reg trust copart_treat outpart_treat control treat800 
margins, at(copart_treat=(1) outpart_treat=(0) control=(0)) l(90) saving(e1, replace)
margins, at(copart_treat=(0) outpart_treat=(1) control=(0)) l(90) saving(e1, replace)
margins, at(copart_treat=(0) outpart_treat=(0) control=(1)) l(90) saving(e1, replace)
margins, at(copart_treat=(0) outpart_treat=(0) control=(0)) l(90) saving(e1, replace)

*Table B5
reg outcome_sc partisan treat800 
reg fan_sc partisan treat800 
reg know_sc partisan treat800 
reg tease_sc partisan treat800 
reg tgate_sc partisan treat800 

*Table B6
reg outcome_sc copart_treat outpart_treat control treat800 
reg fan_sc copart_treat outpart_treat control treat800 
reg know_sc copart_treat outpart_treat control treat800 
reg tease_sc copart_treat outpart_treat control treat800 
reg tgate_sc copart_treat outpart_treat control treat800 

*Study 2

use bsudata.dta, clear

*Table B3
logit accept c.copart2 c.bsu2 
reg price3 c.copart2 c.bsu2 
reg price4 c.copart2 c.bsu2

*Table B4
reg soc_dist c.copart2  c.bsu2
reg trust_sc c.copart2  c.bsu2

*Figure 4
logit accept c.bsu2 c.copart2 
margins, at(copart2=(0 1)) l(80) saving(e1, replace)
reg soc_dist c.bsu2 c.copart2 
margins, at(copart2=(0 1)) l(80) saving(e1, replace)	
reg trust_sc c.bsu2 c.copart2 
margins, at(copart2=(0 1)) l(80) saving(e1, replace)


*Figure 5
reg price3 c.bsu2 c.copart2 
margins, at(copart2=(0 1)) l(80) saving(e1, replace)
reg price4 c.bsu2 c.copart2
margins, at(copart2=(0 1)) l(80) saving(e1, replace)




