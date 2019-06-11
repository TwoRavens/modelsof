* BJPS_tables_main_paper.do
* This do-file is used to produce results in Table 1 and Table 2 
* in the paper "Political Competition and Ethnic Riots in Democratic Transition: A Lesson from Indonesia"
* submitted to BJPS
* Author: Risa J. Toha
* Replication do-file
* Last updated: 07 September 2015
* Run in Stata 12 

** note1:  change the pathways to match where the data is stored in your computer
** note2: if not yet installed in your personal computer, findit estout and findit esttab

clear *
capture log close
set more off
global path "/Users/`c(username)'/Dropbox/PoliticalCompetition"
use "$path/Data/BJPS_data_clean_052115 copy.dta", clear
tis year
iis dist_c

***Results in Main Paper 
** Results on Table 1 
xtnbreg unkomptemp revvotmar afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0
est store m1, title(1)
xtnbreg unkomptemp golkarvs afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0
est store m2, title(2)
xtnbreg unkomptemp gol8797_percent afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java postsoeharto if sepstrict==0
est store m3, title(3)
xtnbreg unkomptemp revvotmar afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java if sepstrict==0 & postsoeharto==0
est store m4, title(4)
xtnbreg unkomptemp revvotmar afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea urban java if sepstrict==0 & postsoeharto==1
est store m5, title(5)
estout m1 m2 m3 m4 m5 using "$path/Tables/Table1_Main_final.xls", cells(b(star fmt(2)) se(par(`"="("' `")""'))) starlevels(^ .1 * .05 ** .01 *** .001) stats(N ll AIC, labels("Observations" "Log Likelihood" "AIC")) legend label varlabels(_cons Intercept)
est stats m1 m2 m3 m4 m5

** Results on Table 2
xtnbreg unkomptemp turnopp afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea postsoeharto urban java if sepstrict==0
est store m1, title(1)
xtnbreg unkomptemp turnopp afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea postsoeharto urban java if compcut3==0 & sepstrict==0
est store m2, title (2)
xtnbreg unkomptemp turnopp afterel rel5050gr21 unkomptemp_1 lpdrbcap lpop larea urban if postsoe==1 & conflictprov==1 & compcut3==0 & sepstrict==0
est store m3, title (3)
xtnbreg unkomptemp delta_v afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea postsoeharto urban java if sepstrict==0
est store m4, title (4)
xtnbreg unkomptemp delta_v afterel rel5050gr21 unkomptemp_1 securityadj lpdrbcap lpop larea postsoeharto urban java if sepstrict==0 & compcut3==0
est store m5, title (5)
xtnbreg unkomptemp delta_v afterel rel5050gr21 unkomptemp_1 lpdrbcap lpop larea urban if postsoe==1 & conflictprov==1 & compcut3==0 & sepstrict==0
est store m6, title (6)
estout m1 m2 m3 m4 m5 m6  using "$path/Tables/Table2_Main_final.xls", cells(b(star fmt(2)) se(par(`"="("' `")""'))) starlevels(^ .1 * .05 ** .01 *** .001) stats(N ll AIC, labels("Observations" "Log Likelihood" "AIC")) legend label varlabels(_cons Intercept)
est stats m1 m2 m3 m4 m5 m6 

capture log close

*** Do appedix_tables.do for results in the Online Appendices. 





