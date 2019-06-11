clear all
set more off
cd "***INSERT DOWNLOADED DIRECTORY HERE***"
use "VisualizingInequalityData.dta", clear
**Must install outreg to export regression results

***KEY
*Fullaxis is the de-emphasis graph condition (it contains a Y-axis from 0-100),
*shown to those who were assigned rand1==4
*Truncaxis is the text-consistent graph (it contains a Y-axis from 5-25),
*shown to those who were assigned rand1==3
*the control group (text only) were assigned rand1 or rand2
*ineqfix is support for government intervention against inequality, where 1=strong opposition and 7=strong support

**Balance Check
ttest educ01,by(fullaxis)
ttest male,by(fullaxis)
ttest age01,by(fullaxis)
ttest black,by(fullaxis)
ttest anes_pid,by(fullaxis)
ttest libcon,by(fullaxis)

ttest educ01,by(truncaxis)
ttest male,by(truncaxis)
ttest age01,by(truncaxis)
ttest black,by(truncaxis)
ttest anes_pid,by(truncaxis)
ttest libcon,by(truncaxis)

logit fullaxis anes_pid educ01 male age01 libcon
logit truncaxis anes_pid educ01 male age01 libcon


****Table 1
*test the effects of either graph
ttest ineqfix01,by(graph)

*compare those exposed to the de-emphasis graph to all others
ttest ineqfix01,by(fullaxis)

*compare just those exposed to the graphs
ttest ineqfix01 if graph!=0,by(fullaxis)

****Figure 2
*examine subsets of the data group by group after exposure
*to the de-emphasis graph
ttest ineqfix01 if truncaxis!=1 & dem==1,by(fullaxis) 
ttest ineqfix01 if truncaxis!=1 & lib==1,by(fullaxis)
ttest ineqfix01 if truncaxis!=1 & rep==1,by(fullaxis)
ttest ineqfix01 if truncaxis!=1 & con==1,by(fullaxis)

****Table 2
*create strong republican identifier (0-3)
gen strep=0
replace strep=1 if anes_pidi==1
replace strep=2 if anes_pidr==2
replace strep=3 if anes_pidr==1
*create strong republican interaction term
gen interep=strep*fullaxis

*create strong conservative identifier (0-3)
gen stcon=0
replace stcon=1 if libcon==5
replace stcon=2 if libcon==6
replace stcon=3 if libcon==7
*create strong conservative interaction term
gen intecon=stcon*fullaxis
reg ineqfix01 fullaxis
outreg using "tab2.doc",  replace se starlevel (5 1)
reg ineqfix01 fullaxis  strep interep    
margins, at(strep=3 interep=3 fullaxis=1)
margins, at(strep=3 interep=0 fullaxis=0)
margins, at(strep=1 interep=1 fullaxis=1)
margins, at(strep=1 interep=0 fullaxis=0)

outreg using "tab2.doc",  merge se starlevel (5 1)
reg ineqfix01 fullaxis  stcon intecon  
margins, at(stcon=3 intecon=3 fullaxis=1)
margins, at(stcon=3 intecon=0 fullaxis=0)
margins, at(stcon=1 intecon=1 fullaxis=1)
margins, at(stcon=1 intecon=0 fullaxis=0)
outreg using "tab2.doc",  merge se starlevel (5 1)


*Appendix
**DV summary
tab ineqfix
tab ineqfix if dem==1
tab ineqfix if ind==1
tab ineqfix if rep==1
sum ineqfix01 
sum ineqfix01 if dem==1
sum ineqfix01 if ind==1
sum ineqfix01 if rep==1

*Appendix A4: comparing the de-emphasis graph with the text-consistent graph
ttest ineqfix01 if dem==1 & graph==1,by(fullaxis)
ttest ineqfix01 if lib==1 & graph==1,by(fullaxis)
ttest ineqfix01 if rep==1 & graph==1,by(fullaxis)
ttest ineqfix01 if con==1 & graph==1,by(fullaxis)



