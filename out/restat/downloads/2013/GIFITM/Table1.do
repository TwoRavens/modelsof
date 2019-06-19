set more off
set mat 800
clear
capture log close
log using Table1.log, replace
use all_vars_40_50

*
*create quartiles of household income (hhincome) and
*husband's income (ninc)
*
xtile ninc4=ninc, nq(4)
xtile hhinc4=hhincome, nq(4)
*
*define education categories
* ed=0 if HS or less
* ed=1 if some college or BA
* ed=2 if more than BA
*
generate ed=0
replace ed=1 if educ99>10
replace ed=2 if educ99>14 
*
*define location categories
*location=0 if rural
*location=2 if large 50 MSAs
*location=1 otherwise
*
generate location=0
replace location=1 if urban==2
replace location=2 if  metaread == 0160 | metaread == 0520 | metaread ==0640 | metaread ==0720 | metaread ==1000 | metaread ==1120 | metaread ==1280 | metaread ==1520  | metaread ==1600  | metaread ==1640  | metaread ==1680  | metaread ==1840  | metaread ==1920  | metaread ==2000  | metaread ==2080 | metaread == 2160  | metaread ==3120  | metaread ==3320  | metaread ==3360  | metaread ==3480  | metaread ==3760  | metaread ==4120  | metaread ==4480  | metaread ==4520  | metaread ==4920  | metaread ==5000  | metaread ==5080 | metaread == 5120  | metaread ==5360  | metaread ==5560  | metaread ==5600  | metaread ==5720  | metaread ==5880  | metaread ==5960  | metaread ==6160 | metaread == 6200  | metaread ==6280 | metaread ==6440  | metaread ==6760  | metaread ==6840 | metaread ==6920 | metaread ==7040 | metaread ==7160 | metaread ==7240 | metaread ==7320 | metaread ==7360 | metaread ==7600  | metaread ==8280| metaread ==8840 | metaread ==8960
*****
*stats
****
*
bysort hhinc4: sum child [aw=perwt]
*
bysort ninc4: sum child [aw=perwt]
*
bysort ed: sum child [aw=perwt]
*
bysort location: sum child [aw=perwt]
*
sum child [aw=perwt] if age<46
sum child [aw=perwt] if age>45
*
log close
* end
