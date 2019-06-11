
***Please contact Amanda Murdie if you have any questions or concerns - amandamurdie@gmail.com


cd "C:\Users\murdie\Dropbox\Carolin Purser\Coauthored Paper for Ron Special Issue\data and analyses"
use "JHR replication data.dta", replace


replace dd5a=. if dd5a==99
replace dd1=. if dd1==9


gen lnviolprotpast5 = ln(violprotpast5 +1)
gen lnnonvprotpast5check= ln(nonvprotpast5 +1)


gen lnviolprotgovtpast5 = ln(violprotgovtpast5 +1)
gen lnnonvprotgovtpast5= ln(nonvprotgovtpast5 +1)

gen lnattackatallpast5 = ln(attackatallpast5+1)

tab q6
bysort ccode: tab q6

*Table 1
melogit q6 dd1 dd2a dd5a dd6a lpolity lciri_a llnpop llngdp lnviolprotgovtpast5  lnnonvprotgovtpast5 || ccode:, vce(robust)
melogit q6 dd1 dd2a dd5a dd6a lpolity lciri_a llnpop llngdp lnviolprotpast  lnnonvprotpast5check || ccode:, vce(robust)
melogit q6 dd1 dd2a dd5a dd6a lpolity lciri_a llnpop llngdp lnviolprotpast5  lnnonvprotpast5check  lnattackatallpast5|| ccode:, vce(robust)

*Figure 1 
graph pie if e(sample), over(q6) by(country) line(lcolor(gs0)) pie(1, color(gs6) ) pie(2, color(gs0) ) 


******important to express any opinion

recode q3 4=1 3=2 2=3 1=4,gen(REVERSEDq3)

*Table 2 
meologit REVERSEDq3 dd1 dd2a dd5a dd6a lpolity lciri_s llnpop llngdp lnviolprotgovtpast5  lnnonvprotgovtpast5 || ccode:, vce(robust)
meologit REVERSEDq3  dd1 dd2a dd5a dd6a lpolity lciri_s llnpop llngdp lnviolprotpast5  lnnonvprotpast5check || ccode:, vce(robust)
meologit REVERSEDq3  dd1 dd2a dd5a dd6a lpolity lciri_s llnpop llngdp lnviolprotpast5  lnnonvprotpast5check lnattackatallpast5|| ccode:, vce(robust)

tab REVERSEDq3 q6

*Figure 2
graph pie if e(sample), over(REVERSEDq3) by(country) pie(4, color(gs0) ) pie(3, color(gs6)) pie(2, color(gs10)) pie(1, color(gs16)) line(lcolor(gs0))


*q5 - government should have right to prohibit certain political or religious views

*Table 3
melogit q5 dd1 dd2a dd5a dd6a lpolity lciri_s llnpop llngdp lnviolprotgovtpast5  lnnonvprotgovtpast5 || ccode:, vce(robust)
melogit q5 dd1 dd2a dd5a dd6a lpolity lciri_s llnpop llngdp lnviolprotpast5  lnnonvprotpast5check || ccode:, vce(robust)
melogit q5 dd1 dd2a dd5a dd6a lpolity lciri_s llnpop llngdp lnviolprotpast5  lnnonvprotpast5check lnattackatallpast5|| ccode:, vce(robust)

*Figure 3 
graph pie if e(sample), over(q5) by(country) line(lcolor(gs0)) pie(1, color(gs6) ) pie(2, color(gs0) ) 
bysort country: tab q5 if e(sample)


**Margins Graphs Figures 4-6


melogit q6 dd1 dd2a dd5a dd6a lpolity lciri_a llnpop llngdp lnviolprotpast5  lnnonvprotpast5check || ccode:, vce(robust)
margins, dydx(*) vce(unconditional)

marginsplot, horizontal recast(scatter) xline(0) allsimple 


meologit REVERSEDq3  dd1 dd2a dd5a dd6a lpolity lciri_s llnpop llngdp lnviolprotpast5  lnnonvprotpast5check || ccode:, vce(robust)
margins, dydx(*) vce(unconditional)

marginsplot, horizontal recast(scatter) xline(0) allsimple bydim(_predict) subtitle(, lc(black))



melogit q5 dd1 dd2a dd5a dd6a lpolity lciri_s llnpop llngdp lnviolprotpast5  lnnonvprotpast5check lnattackatallpast5 || ccode:, vce(robust)
margins, dydx(*) vce(unconditional)

marginsplot, horizontal recast(scatter) xline(0) allsimple  

***Robustness Tests with 1 year past ln


gen lnviolprotpast1 = ln(violprotpast1 + 1)
gen lnnonvprotpast1 = ln(nonvprotpast1 + 1)
gen lnattackatallpast1 = ln(attackatallpast1 + 1)
gen lnviolprotgovtpast1 = ln(violprotgovtpast1 +1) 
gen lnnonvprotgovtpast1 = ln(nonvprotgovtpast1  +1) 

melogit q6 dd1 dd2a dd5a dd6a lpolity lciri_a llnpop llngdp lnviolprotgovtpast1  lnnonvprotgovtpast1  || ccode:, vce(robust)
melogit q6 dd1 dd2a dd5a dd6a lpolity lciri_a llnpop llngdp lnviolprotpast1  lnnonvprotpast1 || ccode:, vce(robust)
melogit q6 dd1 dd2a dd5a dd6a lpolity lciri_a llnpop llngdp lnviolprotpast1  lnnonvprotpast1  lnattackatallpast1 || ccode:, vce(robust)

meologit REVERSEDq3 dd1 dd2a dd5a dd6a lpolity lciri_s llnpop llngdp lnviolprotgovtpast1  lnnonvprotgovtpast1 || ccode:, vce(robust)
meologit REVERSEDq3  dd1 dd2a dd5a dd6a lpolity lciri_s llnpop llngdp lnviolprotpast1  lnnonvprotpast1  || ccode:, vce(robust)
meologit REVERSEDq3  dd1 dd2a dd5a dd6a lpolity lciri_s llnpop llngdp lnviolprotpast1  lnnonvprotpast1  lnattackatallpast1 || ccode:, vce(robust)

melogit q5 dd1 dd2a dd5a dd6a lpolity lciri_s llnpop llngdp lnviolprotgovtpast1  lnnonvprotgovtpast1 || ccode:, vce(robust)
melogit q5 dd1 dd2a dd5a dd6a lpolity lciri_s llnpop llngdp  lnviolprotpast1  lnnonvprotpast1 || ccode:, vce(robust)
melogit q5 dd1 dd2a dd5a dd6a lpolity lciri_s llnpop llngdp lnviolprotpast1  lnnonvprotpast1  lnattackatallpast1 || ccode:, vce(robust)

*****robustness test - age level

replace dd5=. if dd5==99
melogit q6 dd1 dd2a dd5 dd6a lpolity lciri_a llnpop llngdp lnviolprotgovtpast5  lnnonvprotgovtpast5 || ccode:, vce(robust)
melogit q6 dd1 dd2a dd5 dd6a lpolity lciri_a llnpop llngdp lnviolprotpast  lnnonvprotpast5check || ccode:, vce(robust)
melogit q6 dd1 dd2a dd5 dd6a lpolity lciri_a llnpop llngdp lnviolprotpast5  lnnonvprotpast5check  lnattackatallpast5|| ccode:, vce(robust)


meologit REVERSEDq3 dd1 dd2a dd5 dd6a lpolity lciri_s llnpop llngdp lnviolprotgovtpast5  lnnonvprotgovtpast5 || ccode:, vce(robust)
meologit REVERSEDq3  dd1 dd2a dd5 dd6a lpolity lciri_s llnpop llngdp lnviolprotpast5  lnnonvprotpast5check || ccode:, vce(robust)
meologit REVERSEDq3  dd1 dd2a dd5 dd6a lpolity lciri_s llnpop llngdp lnviolprotpast5  lnnonvprotpast5check lnattackatallpast5|| ccode:, vce(robust)

melogit q5 dd1 dd2a dd5 dd6a lpolity lciri_s llnpop llngdp lnviolprotgovtpast5  lnnonvprotgovtpast5 || ccode:, vce(robust)
melogit q5 dd1 dd2a dd5 dd6a lpolity lciri_s llnpop llngdp lnviolprotpast5  lnnonvprotpast5check || ccode:, vce(robust)
melogit q5 dd1 dd2a dd5 dd6a lpolity lciri_s llnpop llngdp lnviolprotpast5  lnnonvprotpast5check lnattackatallpast5|| ccode:, vce(robust)


***Robustness test - add in ciriphysint  - lciri_physint


melogit q6 dd1 dd2a dd5a dd6a lpolity lciri_a lciri_physint llnpop llngdp lnviolprotgovtpast5  lnnonvprotgovtpast5 || ccode:, vce(robust)
melogit q6 dd1 dd2a dd5a dd6a lpolity lciri_a lciri_physint llnpop llngdp lnviolprotpast  lnnonvprotpast5check || ccode:, vce(robust)
melogit q6 dd1 dd2a dd5a dd6a lpolity lciri_a lciri_physint llnpop llngdp lnviolprotpast5  lnnonvprotpast5check  lnattackatallpast5|| ccode:, vce(robust)


meologit REVERSEDq3 dd1 dd2a dd5a dd6a lpolity lciri_s lciri_physint llnpop llngdp lnviolprotgovtpast5  lnnonvprotgovtpast5 || ccode:, vce(robust)
meologit REVERSEDq3  dd1 dd2a dd5a dd6a lpolity lciri_s lciri_physint llnpop llngdp lnviolprotpast5  lnnonvprotpast5check || ccode:, vce(robust)
meologit REVERSEDq3  dd1 dd2a dd5a dd6a lpolity lciri_s lciri_physint llnpop llngdp lnviolprotpast5  lnnonvprotpast5check lnattackatallpast5|| ccode:, vce(robust)

melogit q5 dd1 dd2a dd5a dd6a lpolity lciri_s lciri_physint llnpop llngdp lnviolprotgovtpast5  lnnonvprotgovtpast5 || ccode:, vce(robust)
melogit q5 dd1 dd2a dd5a dd6a lpolity lciri_s lciri_physint llnpop llngdp lnviolprotpast5  lnnonvprotpast5check || ccode:, vce(robust)
melogit q5 dd1 dd2a dd5a  dd6a lpolity lciri_s lciri_physint llnpop llngdp lnviolprotpast5  lnnonvprotpast5check lnattackatallpast5|| ccode:, vce(robust)

***Robustness test - add in measure of corruption 



melogit q6 wbgi_cce dd1 dd2a dd5a dd6a lpolity lciri_a lciri_physint llnpop llngdp lnviolprotgovtpast5  lnnonvprotgovtpast5 || ccode:, vce(robust)
melogit q6 wbgi_cce dd1 dd2a dd5a dd6a lpolity lciri_a lciri_physint llnpop llngdp lnviolprotpast  lnnonvprotpast5check || ccode:, vce(robust)
melogit q6 wbgi_cce dd1 dd2a dd5a dd6a lpolity lciri_a lciri_physint llnpop llngdp lnviolprotpast5  lnnonvprotpast5check  lnattackatallpast5|| ccode:, vce(robust)


meologit REVERSEDq3 wbgi_cce dd1 dd2a dd5a dd6a lpolity lciri_s lciri_physint llnpop llngdp lnviolprotgovtpast5  lnnonvprotgovtpast5 || ccode:, vce(robust)
meologit REVERSEDq3  wbgi_cce dd1 dd2a dd5a dd6a lpolity lciri_s lciri_physint llnpop llngdp lnviolprotpast5  lnnonvprotpast5check || ccode:, vce(robust)
meologit REVERSEDq3 wbgi_cce  dd1 dd2a dd5a dd6a lpolity lciri_s lciri_physint llnpop llngdp lnviolprotpast5  lnnonvprotpast5check lnattackatallpast5|| ccode:, vce(robust)

melogit q5 wbgi_cce dd1 dd2a dd5a dd6a lpolity lciri_s lciri_physint llnpop llngdp lnviolprotgovtpast5  lnnonvprotgovtpast5 || ccode:, vce(robust)
melogit q5 wbgi_cce dd1 dd2a dd5a dd6a lpolity lciri_s lciri_physint llnpop llngdp lnviolprotpast5  lnnonvprotpast5check || ccode:, vce(robust)
melogit q5 wbgi_cce dd1 dd2a dd5a  dd6a lpolity lciri_s lciri_physint llnpop llngdp lnviolprotpast5  lnnonvprotpast5check lnattackatallpast5|| ccode:, vce(robust)





