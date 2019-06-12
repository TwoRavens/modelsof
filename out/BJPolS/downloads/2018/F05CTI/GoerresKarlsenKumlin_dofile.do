
 
**Prepare data set for the analysis
**kick out the ones who did not get the experiment, in the Norwegian sample
drop if exA_group==.

**dop the ones who bypassed the experiment, not in the German sample
drop if exA_group==9

**kick out Germans who took less than 10 minutes 

drop if time_used_min<10

** make sure that no respondent . in all DVs
drop if dv1_health==dv2_pension==dv3_sick==dv4_unemp==dv5_welben==dv6_eldercare==dv7_childcare==. 

*create a variety of new dvs: one where missings are giving value 4, one where missings are coded ad missings, new variable whether giving don't know
*those DVs with a "." remain so
**coding mistakes in dependent variables 777 for Germany = dk
foreach var of varlist dv1_health dv2_pension dv3_sick dv4_unemp dv5_welben dv6_eldercare dv7_childcare {
	tab `var' country, mis
	*next step to make sure that all don't knows have an eight
	recode `var' 777=8, gen(`var'rec)
	*generate a variable where the don't knows are recoded to the neutral category 4
	recode `var'rec 8=4, gen(`var'mid)
	*generate an indicator variable that shows if the respondent gave a dk for an item
	recode `var'rec 8=1 1/7=0, gen(`var'dk01)
}

*we now have 7979 obs

**save the cleaned data set with coded DVs to prepare a data set for reproduction later
save "C:\Users\goerres\sciebo\paper Comparative Experiments welfare state\R&RAnalysis\Worry_Welfare_State_coded_data_20180119.dta", replace

*coding

*new dependent index variable with dks as middle category
gen super_d1_mid=dv1_healthmid+ dv2_pensionmid+ dv3_sickmid+ dv4_unempmid+ dv5_welbenmid+ dv6_eldercaremid+ dv7_childcaremid


*make dummies from experimental groups and countries and German regions
tabulate exA_group, gen(expergr)

tabulate country, gen(cntrynum)
ren cntrynum1 cntry_de
ren cntrynum2 cntry_no
ren cntrynum3 cntry_se

gen cntry_dew=cntry_de 
gen cntry_dee=cntry_de
recode cntry_dew 1=0 if ger_WestEast==2
recode cntry_dee 1=0 if ger_WestEast==1

*generate coarse categories positive frame / negative frame
recode exA_group 8/9=0 1/5=1 6=2 7=1, gen(exA012)
label define a  0 "control" 1 "negative pressure" 2 "positive pressure"
label values exA012 a

tab exA012, gen(exAgroups012)
ren exAgroups0121 exAcontrol
ren exAgroups0122 exAnegative
ren exAgroups0123 exApositive

*control group to zero for technical reasons
recode exA_group 8=0, gen(expgroups07)

*coding some controls that are not used
tab edu, gen(edulevel)
recode gender 0=0 1=1 else=., gen(female)

**don't know get recoded to the neutral category
recode genwelfsup 99=5, gen(welfaresuprec)

**interactions with support for specific groups
recode resp_old 99=5, gen(resp_oldrec)
recode resp_unemp 99=5, gen(resp_unemprec)
recode resp_immi  99=5, gen(resp_immirec)
recode ex_gr1 99=., gen(treatmentgreywavecontrol)
recode ex_gr2 99=., gen(treatmenttoofewworking)
recode ex_gr3 99=., gen(treatmentimmieu)
recode ex_gr4 99=., gen(treatmentimminoneu)

*explore indicator variable whether at least one don't know in one of the items
gen indexdks=dv1_healthdk01+dv2_pensiondk01+dv3_sickdk01+dv4_unempdk01+dv5_welbendk01+dv6_eldercaredk01+dv7_childcaredk01
recode indexdks 1/7=1 .=. 0=0, gen (superd1_dk)



*all case dropping must be finished before this step
*calculate approporiate weights to make Germans weigh in one third, Norwegians one third, Swedes one third
tab country, mis
display (1/3)/(1860/7979)
display (1/3)/(2836/7979)
display (1/3)/(3283/7979)
recode country 1=1.4299283 2=.93782323 3=.81013301, gen(sampleweight)
*the sample weight is only necessary for regressions with more than one country



*create variable where each item has don't know coded as missing "."
foreach var of varlist dv1_healthrec dv2_pensionrec dv3_sickrec dv4_unemprec dv5_welbenrec dv6_eldercarerec dv7_childcarerec {
	recode `var' 8=., gen(`var'mis)
}


*index with missings
gen super_d1_mis=dv1_healthrecmis+ dv2_pensionrecmis+ dv3_sickrecmis+ dv4_unemprecmis+ dv5_welbenrecmis+ dv6_eldercarerecmis+ dv7_childcarerecmis

**test the impact of experiments on prob of saying don't know
foreach var of varlist dv1_healthdk01 dv2_pensiondk01 dv3_sickdk01 dv4_unempdk01 dv5_welbendk01 dv6_eldercaredk01 dv7_childcaredk01 {
logit `var' cntry_de cntry_se expergr1 expergr2 expergr3 expergr4 expergr5 expergr6 expergr7 [pweight=sampleweight]
}

**how do dks vary by item and country
forvalues i = 1(1)3 {
summ dv1_healthdk01 dv2_pensiondk01 dv3_sickdk01 dv4_unempdk01 dv5_welbendk01 dv6_eldercaredk01 dv7_childcaredk01 if country==`i'
}






*Analysis in the paper**main text-------------------------

**check dimensionality and scale reliablity of items with don't knows as missing, Cronach's Alpha with new DVs, all load very highly on one dimension
pca dv1_healthrecmis dv2_pensionrecmis dv3_sickrecmis dv4_unemprecmis dv5_welbenrecmis dv6_eldercarerecmis dv7_childcarerecmis, com(1)
alpha dv1_healthrecmis dv2_pensionrecmis dv3_sickrecmis dv4_unemprecmis dv5_welbenrecmis dv6_eldercarerecmis dv7_childcarerecmis
alpha dv1_healthrecmis dv2_pensionrecmis dv3_sickrecmis dv4_unemprecmis dv5_welbenrecmis dv6_eldercarerecmis dv7_childcarerecmis if country==1
alpha dv1_healthrecmis dv2_pensionrecmis dv3_sickrecmis dv4_unemprecmis dv5_welbenrecmis dv6_eldercarerecmis dv7_childcarerecmis if country==2
alpha dv1_healthrecmis dv2_pensionrecmis dv3_sickrecmis dv4_unemprecmis dv5_welbenrecmis dv6_eldercarerecmis dv7_childcarerecmis if country==3



**table 2, means of items and index
forvalues i = 1(1)3 {
summ  super_d1_mid dv1_healthmid dv2_pensionmid dv3_sickmid dv4_unempmid dv5_welbenmid dv6_eldercaremid dv7_childcaremid if country==`i'
}

forvalues i = 1(1)3 {
summ  super_d1_mid if dv1_healthmid~=. & dv2_pensionmid~=. & dv3_sickmid~=. & dv4_unempmid~=. & dv5_welbenmid~=. & dv6_eldercaremid~=. & dv7_childcaremid~=. & country==`i'
}

forvalues i = 1(1)3 {
summ  dv1_healthmid if dv2_pensionmid~=. & dv3_sickmid~=. & dv4_unempmid~=. & dv5_welbenmid~=. & dv6_eldercaremid~=. & dv7_childcaremid~=. & country==`i'
}

forvalues i = 1(1)3 {
summ  dv2_pensionmid if dv1_healthmid~=. & dv3_sickmid~=. & dv4_unempmid~=. & dv5_welbenmid~=. & dv6_eldercaremid~=. & dv7_childcaremid~=. & country==`i'
}

forvalues i = 1(1)3 {
summ  dv3_sickmid  if dv1_healthmid~=. & dv2_pensionmid~=. & dv4_unempmid~=. & dv5_welbenmid~=. & dv6_eldercaremid~=. & dv7_childcaremid~=. & country==`i'
}

forvalues i = 1(1)3 {
summ  dv4_unempmid  if dv1_healthmid~=. & dv2_pensionmid~=. & dv3_sickmid~=. & dv5_welbenmid~=. & dv6_eldercaremid~=. & dv7_childcaremid~=. & country==`i'
}

forvalues i = 1(1)3 {
summ  dv5_welbenmid if dv1_healthmid~=. & dv2_pensionmid~=. & dv3_sickmid~=. & dv4_unempmid~=. & dv6_eldercaremid~=. & dv7_childcaremid~=. & country==`i'
}

forvalues i = 1(1)3 {
summ  dv6_eldercaremid  if dv1_healthmid~=. & dv2_pensionmid~=. & dv3_sickmid~=. & dv4_unempmid~=. & dv5_welbenmid~=. & dv7_childcaremid~=. & country==`i'
}

forvalues i = 1(1)3 {
summ  dv7_childcaremid if dv1_healthmid~=. & dv2_pensionmid~=. & dv3_sickmid~=. & dv4_unempmid~=. & dv5_welbenmid~=. & dv6_eldercaremid~=.  & country==`i'
}
 
*table 3
**table 3**, dummies for Norway (baseline), Sweden, East germany, West Germany
regress super_d1_mid superd1_dk cntry_dew cntry_dee cntry_se exAnegative exApositive [pweight=sampleweight]
estimates store m1
test exAnegative=exApositive=0

*Germany
regress super_d1_mid superd1_dk  cntry_dee exAnegative exApositive if country==1
estimates store m1de
test exAnegative=exApositive=0

*Sweden
regress super_d1_mid superd1_dk exAnegative exApositive if country==3
estimates store m1se
test exAnegative=exApositive=0

*Norway
regress super_d1_mid superd1_dk exAnegative exApositive if country==2
estimates store m1no
test exAnegative=exApositive=0


regress super_d1_mid superd1_dk cntry_dew cntry_dee cntry_se 	expergr1 expergr2 expergr3 expergr4 expergr5 expergr6 expergr7 [pweight=sampleweight]
estimate store m2
test expergr1=expergr2=expergr3=expergr4=expergr5=expergr6=expergr7=0
**diagnostics 
vif
predict yhat
gen yhat_2=yhat*yhat
regress super_d1_mid yhat yhat_2[pweight=sampleweight]
drop yhat*
*yhat_2 not significant coefficient ==> heteroscedasticity not a problem


regress super_d1_mid superd1_dk cntry_dee				expergr1 expergr2 expergr3 expergr4 expergr5 expergr6 expergr7 if country==1
estimate store m2de
test expergr1=expergr2=expergr3=expergr4=expergr5=expergr6=expergr7=0
predict yhat
gen yhat_2=yhat*yhat
regress super_d1_mid yhat yhat_2	if country==1
drop yhat*
**HK not a problem
regress super_d1_mid superd1_dk 					expergr1 expergr2 expergr3 expergr4 expergr5 expergr6 expergr7 if country==3
estimate store m2se
test expergr1=expergr2=expergr3=expergr4=expergr5=expergr6=expergr7=0
predict yhat
gen yhat_2=yhat*yhat
regress super_d1_mid yhat yhat_2	if country==3
drop yhat*
**HK not a problem
regress super_d1_mid superd1_dk 					expergr1 expergr2 expergr3 expergr4 expergr5 expergr6 expergr7 if country==2
estimate store m2no
test expergr1=expergr2=expergr3=expergr4=expergr5=expergr6=expergr7=0
predict yhat
gen yhat_2=yhat*yhat
regress super_d1_mid yhat yhat_2	if country==2
drop yhat*
**HK not a problem
*collinearity, distribution of DV and hetroscedasticity are checked
*output table 3
esttab m1 m1de m1se m1no m2 m2de m2se m2no using table1.csv, p(3) brackets star(* 0.05)  r2 ar2 nogaps label replace

*interaction analysis main text
 **I run the dependent variables as the summative index as they  correlate to highly and we have nothing adequate for migrants
**ancilliary analyses about the deviation in the policy-specific item from the mean
estimates clear
**nothing going on in population ageing
regress super_d1_mid superd1_dk cntry_dee i.treatmentgreywavecontrol##c.resp_old if country==1
estimates store m3de
testparm i.treatmentgreywavecontrol#c.resp_old
margins, dydx(treatmentgreywavecontrol) at(resp_old =(0(1) 10))
regress super_d1_mid superd1_dk i.treatmentgreywavecontrol##c.resp_old if country==2
estimates store m3no
testparm i.treatmentgreywavecontrol#c.resp_old
margins, dydx(treatmentgreywavecontrol) at(resp_old =(0(1) 10))

**nothing going on in unemployment
regress super_d1_mid superd1_dk cntry_dee i.treatmenttoofewworking##c.resp_unemprec if country==1
estimates store m4de
testparm i.treatmenttoofewworking#c.resp_unemprec
margins, dydx(treatmenttoofewworking) at(resp_unemprec =(0(1) 10))

regress super_d1_mid superd1_dk i.treatmenttoofewworking##c.resp_unemprec if country==2
estimates store m4no
testparm i.treatmenttoofewworking#c.resp_unemprec // this test yield .02
margins, dydx(treatmenttoofewworking) at(resp_unemprec =(0(1) 10))

**much going on in immigration, non EU
set scheme s2mono
regress super_d1_mid superd1_dk cntry_dee i.treatmentimmieu##c.resp_immirec if country==1
estimates store m5de
testparm i.treatmentimmieu#c.resp_immirec 
margins, dydx(treatmentimmieu) at(resp_immirec =(0(1) 10))
marginsplot,  recastci(rarea) yline(0) xtitle ("") ytitle ("marg. effect EU immigration v. control") title("Germany")
graph save euimmi_de, replace

regress super_d1_mid superd1_dk i.treatmentimmieu##c.resp_immirec if country==2
estimates store m5no
testparm i.treatmentimmieu#c.resp_immirec 
margins, dydx(treatmentimmieu) at(resp_immirec =(0(1) 10))
marginsplot,  recastci(rarea) yline(0) xtitle ("") ytitle ("") title("Norway")
graph save euimmi_no, replace
graph combine euimmi_de.gph euimmi_no.gph, ycommon
graph save euimmi_combined, replace

regress super_d1_mid superd1_dk cntry_dee i.treatmentimminoneu##c.resp_immirec if country==1
estimates store m6de
testparm i.treatmentimminoneu#c.resp_immirec 
margins, dydx(treatmentimminoneu) at(resp_immirec =(0(1) 10))
marginsplot,  recastci(rarea) yline(0) xtitle ("support for govt resp reasonable std. of living immigrants") ytitle ("marg. effect Western/non-Europ. immigration v. control") title("")
graph save noneuimmi_de, replace

regress super_d1_mid superd1_dk i.treatmentimminoneu##c.resp_immirec if country==2
estimates store m6no
testparm i.treatmentimminoneu#c.resp_immirec 
margins, dydx(treatmentimminoneu) at(resp_immirec =(0(1) 10))
marginsplot,  recastci(rarea) yline(0) xtitle ("support for govt resp reasonable std. of living immigrants") ytitle ("") title("")
graph save noneuimmi_no, replace
graph combine noneuimmi_de.gph noneuimmi_no.gph, ycommon
graph save noneuimmi_combined, replace

graph combine euimmi_combined.gph noneuimmi_combined.gph, cols(1)
graph save immi_combined, replace

esttab m3de m3no m4de m4no m5de m5no m6de m6no using table4.csv, p(3) brackets star (* 0.05)  r2 ar2 nogaps label replace

*interaction graphs for migration for two countries
**look at poprortion with specific values on contextual variable
tab   resp_immirec if country==2
tab   resp_immirec if country==1


 
**appendix-------------------------------------------------------------

*descriptives of all variables that are not control variables
summ  dv1_healthmid dv2_pensionmid dv3_sickmid dv4_unempmid dv5_welbenmid dv6_eldercaremid dv7_childcaremid super_d1_mid resp_oldrec resp_unemprec resp_immirec
**histogram DV that is in the appendix
set scheme s2mono
histogram super_d1_mid, freq norm

*16 models of welfare state support, not reported, we actually only ran 
*****************only Norway and Germany from this section onwards
**interaction with general welfare state support

*not shown in main text
regress super_d1_mid superd1_dk cntry_dew cntry_dee i.expgroups07##c.welfaresuprec
margins, dydx(i.expgroups07) at(welfaresuprec =(0(1) 10))
marginsplot,  recastci(rarea) yline(0) xtitle ("general welfare state support") ytitle ("marginal effect of treaments")
testparm expgroups07#c.welfaresuprec 

regress super_d1_mid superd1_dk i.expgroups07##c.welfaresuprec if country==1
testparm expgroups07#c.welfaresuprec 
margins, dydx(i.expgroups07) at(welfaresuprec =(0(1) 10))
regress super_d1_mid superd1_dk i.expgroups07##c.welfaresuprec if country==2
testparm expgroups07#c.welfaresuprec 
margins, dydx(i.expgroups07) at(welfaresuprec =(0(1) 10))

foreach var of varlist super_d1_mid dv1_healthmid dv2_pensionmid dv3_sickmid dv4_unempmid dv5_welbenmid dv6_eldercaremid dv7_childcaremid {
regress `var' superd1_dk i.expgroups07##c.welfaresuprec if country==1
testparm expgroups07#c.welfaresuprec 
regress `var' superd1_dk i.expgroups07##c.welfaresuprec if country==2
testparm expgroups07#c.welfaresuprec 
}

**calculate proportion who give the same value on all items, reported in appendix, rellay hwere?
gen thesameanswer=0
recode thesameanswer 0=1 if dv1_healthmid==dv2_pensionmid & dv1_healthmid==dv3_sickmid & dv1_healthmid==dv4_unempmid & dv1_healthmid==dv5_welbenmid &dv1_healthmid==dv6_eldercaremid & dv1_healthmid==dv7_childcaremid




*anicllary test whetehr experiments in East and West Germany work differently
regress super_d1_mid superd1_dk 					expergr1 expergr2 expergr3 expergr4 expergr5 expergr6 expergr7 if cntry_dee==1
regress super_d1_mid superd1_dk 					expergr1 expergr2 expergr3 expergr4 expergr5 expergr6 expergr7 if cntry_dew==1
*weird: East German coefficients are all positive
regress super_d1_mid superd1_dk i.cntry_dee##i.expgroups07 if country==1
margins, dydx(i.expgroups07) at(cntry_dee =(0(1) 1))
**not much difference, but it is weird that the Eastern coefficients are positive

twoway (histogram super_d1_mid if cntry_dee==1, width(3) color(red)) ///
       (histogram super_d1_mid if cntry_dew==1, width(3) ///
	   fcolor(none) lcolor(black)), legend(order(1 "East" 2 "West" ))

tab edu if cntry_dew==1, summarize(super_d1_mid)
tab edu if cntry_dee==1, summarize(super_d1_mid)

**does it help to include further control variables from socio-demographics? NO!
*no variance in Gender for current data set
recode income 777/999=., gen(incomerec)
recode gender 3=., gen(genderrec)
regress super_d1_mid superd1_dk age incomerec gender cntry_de cntry_se 	expergr1 expergr2 expergr3 expergr4 expergr5 expergr6 expergr7 [pweight=sampleweight]
regress super_d1_mid superd1_dk age incomerec gender 					expergr1 expergr2 expergr3 expergr4 expergr5 expergr6 expergr7  if country==1

**can the experimental set-up explain the deviation from one's personal mean?
foreach var of varlist dv1_healthmiddev dv2_pensionmiddev dv3_sickmiddev dv4_unempmiddev dv5_welbenmiddev dv6_eldercaremiddev dv7_childcaremiddev {
forvalues i = 1(1)3 {
regress `var' expergr1 expergr2 expergr3 expergr4 expergr5 expergr6 expergr7 if country==`i'
}
}





*R&R new analysis-----------------------------------------------
*check whether moderator variables are themselves affected by the experimental treatment
*general welfare state support
oneway  welfaresuprec expgroups07  if country==1 // p=.
oneway welfaresuprec expgroups07  if country==2 // p=.

*govt responsibility for the old, unemployed, immigrants
oneway resp_oldrec expgroups07  if country==1 // p=.
oneway resp_oldrec expgroups07  if country==2 // p=.

oneway resp_unemprec expgroups07  if country==1 // p=.
oneway resp_unemprec expgroups07  if country==2 // p=.

oneway resp_immirec expgroups07  if country==1 // p=.
oneway resp_immirec expgroups07  if country==2 // p=.07
oneway resp_immirec expgroups07  if country==2, tab sidak // p=.07
oneway resp_immirec expgroups07  if country==2, tab bonferroni // p=.07


