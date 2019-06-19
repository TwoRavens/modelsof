clear
clear matrix
cd "C:\Users\wb200090\Dropbox\DavidMcKenzie\otherresearch\Jordan\"
use "JN_FinalSubmission.dta", clear
***** Tables: Employer and Individual Characteristics for Jobs
cap drop _merge
sort seatno
merge seatno using "C:\Users\wb200090\Dropbox\DavidMcKenzie\otherresearch\Jordan\Jordanvoucheradminvars.dta"
drop if _merge==2


**************Table 1 -- Most Common Courses of Study for Experimental Sample *********
***************************************************************************************
tab b_programcode if treats~=., sort
tab b_c3specialization if treats~=., sort


*** Generate treatment variables
drop if treatstat==.
gen voucheronly=treatstat==1
gen trainingonly=treatstat==2
gen bothtreat=treatstat==3


*** rename variables and then put in panel format
rename mid_lfp lfp_1
rename end_lfp lfp_2
rename end2_lfp lfp_3
rename mid_x employed_1
rename end_x employed_2
rename end2_x employed_3
rename mid_reg_ssc reg_ssc_1
rename end_reg_ssc reg_ssc_2
rename end2_reg_ssc reg_ssc_3
rename ssc_mid_employment ssc_employment_1
rename ssc_end_employment ssc_employment_2
rename mid_ever everemployed_1
rename ever_employed everemployed_2
rename end2_everemployed everemployed_3
rename m_c20 monthsworked_1
rename totaljob_duration monthsworked_2
rename totalmonthsworked_t monthsworked_3
rename mid_hours_week hoursworked_1
rename end_hours_week hoursworked_2
rename end2_hours_week hoursworked_3
rename mid_salary salary_1
rename end_salary salary_2
rename end2_salary salary_3
rename mid_salary_c salarycond_1
rename end_salary_c salarycond_2
rename end2_salary_c salarycond_3

reshape long lfp_ employed_ reg_ssc_ ssc_employment_ everemployed_ monthsworked_ hoursworked_ salary_ salarycond_, i(seatno) j(time)

**** Appendix Table 1 *************************************
**** Main employment outcome, showing can pool voucher only and voucher+training, and training with control
gen post1=time==2
label var post1 "Second Follow-up"
gen post2=time==3
label var post2 "Third Follow-up"
gen control=voucheronly==0 & trainingonly==0 & bothtreat==0

foreach var of varlist voucheronly trainingonly bothtreat {
gen `var'_post1=`var'*post1
gen `var'_post2=`var'*post2
}
eststo clear
#delimit ;
areg employed_ voucheronly trainingonly bothtreat 
voucheronly_post1 voucheronly_post2 trainingonly_post1 trainingonly_post2
bothtreat_post1 bothtreat_post2 post1 post2, cluster(seatno) r a(strata);
sum employed_ if control==1 & time==1;
estadd scalar mean=r(mean);
test trainingonly==trainingonly_post1==trainingonly_post2==0;
estadd scalar p1=r(p);
test voucheronly=bothtreat;
test voucheronly_post1=bothtreat_post1, accum;
test voucheronly_post2=bothtreat_post2, accum;
estadd scalar p2=r(p);
eststo tableA_1;

#delimit ;
areg salary_ voucheronly trainingonly bothtreat 
voucheronly_post1 voucheronly_post2 trainingonly_post1 trainingonly_post2
bothtreat_post1 bothtreat_post2 post1 post2, cluster(seatno) r a(strata);
sum employed_ if control==1 & time==1;
estadd scalar mean=r(mean);
test trainingonly==trainingonly_post1==trainingonly_post2==0;
estadd scalar p1=r(p);
test voucheronly=bothtreat;
test voucheronly_post1=bothtreat_post1, accum;
test voucheronly_post2=bothtreat_post2, accum;
estadd scalar p2=r(p);
eststo tableA_2;

#delimit ;
esttab tableA_* using output\tableA1.csv, replace depvar legend label nonumbers nogaps
	drop(_cons) 
	b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01)
	stats(mean N p1 p2, fmt(%9.3f %9.0g %9.3f %9.3f) labels("Control Mean in First Follow-up" "Sample Size" "p-value for training zero" "p-value for equality of voucher only and both")) 
	title("Appendix Table 1: Pooling of Treatments and No Complementarity") addnotes("""") ;
#delimit cr


**** Appendix Table 2 ***************************************************
* reweighting to account for a larger control group when combining treatments
gen weight=1
replace weight=749/300 if trainingonly==1
replace weight=749/449 if control==1

* How sensitive to weighting are results
gen anyvoucher=voucheronly==1|bothtreat==1
gen anyvoucher_post1=anyvoucher*post1
gen anyvoucher_post2=anyvoucher*post2
eststo clear
areg employed_ anyvoucher anyvoucher_post1 anyvoucher_post2 post1 post2, cluster(seatno) a(strata) r
sum employed_ if anyvoucher==0 & time==1
estadd scalar mean=r(mean)
eststo tableA2_1

areg employed_ anyvoucher anyvoucher_post1 anyvoucher_post2 post1 post2 [pweight=weight], cluster(seatno) a(strata) r
sum employed_ if anyvoucher==0 & time==1
estadd scalar mean=r(mean)
eststo tableA2_2

#delimit ;
esttab tableA2_* using output\tableA2.csv, replace depvar legend label nonumbers nogaps
	drop(_cons) 
	b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01)
	stats(mean N p1 p2, fmt(%9.3f %9.0g) labels("Control Mean in First Follow-up" "Sample Size")) 
	title("Appendix Table 2: Robustness to weighting choice") addnotes("""") ;
#delimit cr


*********** Table 2 -- Comparison of Means of Baseline Characteristics by Treatment Group ***********
*****************************************************************************************************
gen constant1=1

mat y = J(16,3,.)	
local k=1
foreach var of varlist l t w e b_b1age b_married  motherwork fatherwork b_d7prviouswork  b_f1foundjob b_i1englishcourse b_k3car b_k4computer b_k13internet b_h4govbetterthanprivate {
sum `var' if anyvoucher==1 & time==1
mat y[`k',1] = r(mean)
reg `var' constant [pweight=weight] if anyvoucher==0 & time==1, r
mat y[`k',2] = _b[_cons]
areg `var' anyvoucher [pweight=weight] if time==1, r a(strata)
test anyvoucher=0
mat y[`k', 3]=r(p)
local k=`k'+1
}
sum anyvoucher if anyvoucher==1 & time==1
mat y[16,1]=r(N)
sum anyvoucher if anyvoucher==0 & time==1
mat y[16,2]=r(N)
mat rownames y = Location TawjihiMedian Work Empowerment Age Marital MomWork DadWork PreviousWork JobafterGrad English Car Computer Internet Gov "Sample Size"
mat colnames y = "Voucher" "Control" "P-value"
mat2txt, matrix(y) saving("Output\Table2_ReStat.xls") replace

* chi-squared test of orthogonality
reg anyvoucher l t w e b_b1age b_married  motherwork fatherwork b_d7prviouswork  b_f1foundjob b_i1englishcourse b_k3car b_k4computer b_k13internet b_h4govbetterthanprivate if time==1, r
* p-value is 0.9902


**** Table 3 : Voucher Usage Statistics ************************************
****************************************************************************
mat y = J(6,3,.)
local j=1 
forval x=1/6 {
count if nummonths1==`x' & time==1
mat y[`j',1]= r(N)
mat y[`j',2] = 100*r(N)/300
sum uniqueemployer if nummonths1==`x' & time==1
mat y[`j',3] = r(mean)
local j=`j'+1
}
mat rownames y = "1 Month" "2 Months" "3 Months" "4 Months" "5 Months" "6 Months"
mat colnames y = "Number Using Voucher" "Percent" "Same Employer"
mat2txt, matrix(y) saving("Output\Table3.xls") replace



*********** Table 4: Treatment Impacts on Employment ******************
***********************************************************************

**** outcome of formal employment: having a contract
gen fcontract=e1_c20a==1 if e1_c20a~=. & time==2
replace fcontract=0 if employed_==0 & time==2
replace fcontract=m_c21==1 if m_c21~=. & time==1
replace fcontract=0 if employed==0 & time==1
replace fcontract=e2_l23a if time==3 & e2_l6a==1
replace fcontract=e2_l23b if time==3 & e2_l6b==1
replace fcontract=e2_l23c if time==3 & e2_l6c==1
replace fcontract=e2_l23d if time==3 & e2_l6d==1
replace fcontract=e2_l23e if time==3 & e2_l6e==1
replace fcontract=0 if time==3 & employed==0

eststo clear
local i=1
foreach var of varlist lfp_ employed_ fcontract reg_ssc_ ssc_employment_  hoursworked_ salary_ salarycond_ everemployed_ monthsworked_ {
areg `var' anyvoucher anyvoucher_post1 anyvoucher_post2 post1 post2 [pweight=weight], cluster(seatno) a(strata) r
sum `var' if anyvoucher==0 & time==1
estadd scalar mean=r(mean)
test anyvoucher_post1+anyvoucher==0
estadd scalar p1=r(p)
test anyvoucher_post2+anyvoucher==0
estadd scalar p2=r(p)
test anyvoucher_post1==anyvoucher_post2
estadd scalar p3=r(p)
eststo table4_`i'
local i=`i'+1
}


#delimit ;
esttab table4_* using output\table4.csv, replace depvar legend label nonumbers nogaps
	drop(_cons) 
	b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01)
	stats(mean N p1 p2 p3, fmt(%9.3f %9.0g %9.3f %9.3f %9.3f) labels("Control Mean in First Follow-up" "Sample Size" "p-value: no effect at follow-up 2" "p-value: no effect at follow-up 3" "p-value: equality of follow-up 2 and 3 effects")) 
	title("Table 4: Treatment Impacts on Employment") addnotes("""") ;
#delimit cr


***** Appendix Table 3: Response Rates by Treatment Status
clear matrix

mat y = J(4,3,.)	

sum mid_attrition if anyvoucher==1 & time==1
mat y[1,1] = r(mean)
sum mid_attrition if anyvoucher==0 & time==1
mat y[1,2] = r(mean)
ttest mid_attrition if time==1, by(anyvoucher)
mat y[1,3] = r(p)

sum end_attrition if anyvoucher==1 & time==1
mat y[2,1] = r(mean)
sum end_attrition if anyvoucher==0 & time==1
mat y[2,2] = r(mean)
ttest end_attrition if time==1, by(anyvoucher)
mat y[2,3] = r(p)

sum end2_attrition if anyvoucher==1 & time==1
mat y[3,1] = r(mean)
sum end2_attrition if anyvoucher==0 & time==1
mat y[3,2] = r(mean)
ttest end2_attrition if time==1, by(anyvoucher)
mat y[3,3] = r(p)

sum ssc_attr if anyvoucher==1 & time==1
mat y[4,1] = r(mean)
sum ssc_attr if anyvoucher==0 & time==1
mat y[4,2] = r(mean)
ttest ssc_attr if time==1, by(anyvoucher)
mat y[4,3] = r(p)
mat rownames y = "First Follow-up" "Second Follow-up" "Third Follow-up" "Social Security"
mat colnames y = "Voucher" "Control" "p-value"
mat2txt, matrix(y)  saving("Output\AppendixTable3.xls") replace

***** Appendix Table 4: Attrition Bounds ************************

* lower bound 1 - assume all missing control were employed, all missing treatment unemployed
gen emp_lb=employed_
replace emp_lb=1 if emp_lb==. & anyvoucher==0
replace emp_lb=0 if emp_lb==. & anyvoucher==1
* upper bound 1 - assume all missing control unemployed, all missing treatment employed
gen emp_ub=employed
replace emp_ub=0 if emp_ub==. & anyvoucher==0
replace emp_ub=1 if emp_ub==. & anyvoucher==1

* Narrower bounds - just adjust for differential attrition
gen emp_lb2=employed_
gen emp_up2=employed_
set seed 124
gen randomX=uniform()
egen rankX=rank(randomX) if employed_==., by(anyvoucher time)
replace emp_lb2=1 if emp_lb2==. & ((time==1 & rankX<=40)|(time==2 & rankX<=24)|(time==3 & rankX<=29)) & anyvoucher==0
replace emp_up2=0 if emp_up2==. & ((time==1 & rankX<=40)|(time==2 & rankX<=24)|(time==3 & rankX<=29)) & anyvoucher==0

eststo clear
local i=1
foreach var of varlist employed_ emp_lb emp_ub emp_lb2 emp_up2 {
areg `var' anyvoucher anyvoucher_post1 anyvoucher_post2 post1 post2 [pweight=weight], cluster(seatno) a(strata) r
sum `var' if anyvoucher==0 & time==1
estadd scalar mean=r(mean)
test anyvoucher_post1+anyvoucher==0
estadd scalar p1=r(p)
test anyvoucher_post2+anyvoucher==0
estadd scalar p2=r(p)
test anyvoucher_post1==anyvoucher_post2
estadd scalar p3=r(p)
eststo tablea2_`i'
local i=`i'+1
}


#delimit ;
esttab tablea2_* using "Output\tableapp4.csv", replace depvar legend label nonumbers nogaps
	drop(_cons) 
	b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01)
	stats(mean N p1 p2 p3, fmt(%9.3f %9.0g %9.3f %9.3f %9.3f) labels("Control Mean in First Follow-up" "Sample Size" "p-value: no effect at follow-up 2" "p-value: no effect at follow-up 3" "p-value: equality of follow-up 2 and 3 effects")) 
	title("Appendix Table 4: Bounds for Attrition") addnotes("""") ;
#delimit cr

**** Appendix Table 5: Occupations in Administrative data
tab occupation if time==1


*** Appendix Table 6: Impacts pooling together both follow-up rounds *********************
gen post=post1==1|post2==1
gen anyvoucher_post=anyvoucher*post
eststo clear
local i=1
foreach var of varlist lfp_ employed_ reg_ssc_ everemployed_ monthsworked_ hoursworked_ salary_ salarycond_ {
areg `var' anyvoucher anyvoucher_post post1 post2 [pweight=weight], cluster(seatno) a(strata) r
sum `var' if anyvoucher==0 & time==1
estadd scalar mean=r(mean)
test anyvoucher_post+anyvoucher==0
estadd scalar p1=r(p)
eststo table6a_`i'
local i=`i'+1
}


#delimit ;
esttab table6a_* using output\appendixtable6.csv, replace depvar legend label nonumbers nogaps
	drop(_cons) 
	b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01)
	stats(mean N p1, fmt(%9.3f %9.0g %9.3f %9.3f %9.3f) labels("Control Mean in First Follow-up" "Sample Size" "p-value: no effect at follow-up")) 
	title("Appendix Table 6: Treatment Impacts on Employment Pooled across two rounds") addnotes("""") ;
#delimit cr

********  Appendix Table 7: Correlates of Employment for Control Group **************************
gen madmin=b_programcode==5
gen mmed=b_programcode==9
gen meduc=b_programcode==13
eststo clear
dprobit employed l t w e if anyvoucher==0 & time==1, r
sum employed if anyvoucher==0 & time==1
estadd scalar mean=r(mean)
eststo tableA7_1
dprobit employed l t w e if anyvoucher==0 & time==2, r
sum employed if anyvoucher==0 & time==2
estadd scalar mean=r(mean)
eststo tableA7_2
dprobit employed l t w e if anyvoucher==0 & time==3, r
sum employed if anyvoucher==0 & time==3
estadd scalar mean=r(mean)
eststo tableA7_3
dprobit employed l t w e b_b1age b_married  motherwork fatherwork b_d7prviouswork  b_f1foundjob b_i1englishcourse b_k3car b_k4computer b_k13internet b_h4govbetterthanprivate madmin mmed meduc if time==1 & anyvoucher==0, r
sum employed if anyvoucher==0 & time==1
estadd scalar mean=r(mean)
eststo tableA7_4
dprobit employed l t w e b_b1age b_married  motherwork fatherwork b_d7prviouswork  b_f1foundjob b_i1englishcourse b_k3car b_k4computer b_k13internet b_h4govbetterthanprivate madmin mmed meduc if time==2 & anyvoucher==0, r
sum employed if anyvoucher==0 & time==2
estadd scalar mean=r(mean)
eststo tableA7_5
dprobit employed l t w e b_b1age b_married  motherwork fatherwork b_d7prviouswork  b_f1foundjob b_i1englishcourse b_k3car b_k4computer b_k13internet b_h4govbetterthanprivate madmin mmed meduc if time==3 & anyvoucher==0, r
sum employed if anyvoucher==0 & time==3
estadd scalar mean=r(mean)
eststo tableA7_6
#delimit ;
esttab tableA7_* using output\tableA7.csv, replace depvar legend label nonumbers margin nogaps
	drop(_cons) 
	b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01)
	stats(mean N, fmt(%9.3f %9.0g) labels("Mean Employment Rate for Control Group" "Sample Size")) 
	title("Appendix Table 7: Correlates of Control Group Employment") addnotes("""") ;
#delimit cr

** Table 5 - see below

**** Table 6: Heterogeneity of Impacts ***************************************
** Pool together second and third follow-ups for power and ease of presentation
eststo clear
local i=1
foreach var of varlist l t w e b_married mmed {
cap drop anyvoucher_`var' anyvoucher_post_`var' post1_`var' post2_`var'
gen anyvoucher_`var'=anyvoucher*`var'
gen anyvoucher_post_`var'=anyvoucher_post*`var'
gen post1_`var'=post1*`var'
gen post2_`var'=post2*`var'
areg employed anyvoucher anyvoucher_post  post1 post2 `var' anyvoucher_`var' anyvoucher_post_`var'  post1_`var' post2_`var' [pweight=weight], cluster(seatno) a(strata) r
sum employed if anyvoucher==0 & time==1 & `var'==0
estadd scalar mean1=r(mean)
sum employed if anyvoucher==0 & time==1 & `var'==1
estadd scalar mean2=r(mean)
test anyvoucher_post+anyvoucher==0
estadd scalar p1=r(p)
test anyvoucher_post+anyvoucher+anyvoucher_post_`var'+anyvoucher_`var'==0
estadd scalar p2=r(p)
test anyvoucher_post_`var'+anyvoucher_`var'==0
estadd scalar p3=r(p)
eststo table6_`i'
local i=`i'+1
}
#delimit ;
esttab table6_* using output\table6.csv, replace depvar legend label nonumbers nogaps
	drop(_cons) 
	b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01)
	stats(mean1 mean2 N p1 p2 p3, fmt(%9.3f %9.3f %9.0g %9.3f %9.3f %9.3f %9.3f) labels("Control Mean when Interaction 0" "Control Mean when Interaction 1" "Sample Size" "p-value: no effect when interaction=0 at follow-ups 2 and 3" "p-value: no effect for interaction=1 at follow-ups 2 and 3" "p-value: no effect for interaction=1 at follow-up 3" "p-value: no interaction effect in follow-up periods 2 and 3")) 
	title("Table 6: Heterogeneity in Treatment Effects") addnotes("""") ;
#delimit cr



****** Table 7: How do characteristics of voucher jobs differ from other jobs? *************
*** count only jobs found pre Aug 2011 (ie pre-end of voucher period)
gen prevoucherend=e1_c5ayear<2011|(e1_c5ayear==2011 & e1_c5amonth<=8)

*** classifications
* voucher group vs control group
gen status1=1 if anyvoucher==1 & prevoucherend==1
replace status1=0 if anyvoucher==0 & prevoucherend==1
* voucher group: got job using voucher vs didn't
gen status2=1 if status1==1 & e1_c24a==1
replace status2=0 if status1==1 & e1_c24a==0
* got job using voucher: stayed in job vs left job
gen status3=1 if status2==1 & e1_c25a==1
replace status3=0 if status2==1 & e1_c25a==0

**** Occupation types
gen oteacher=e1_c6a=="teacher"|e1_c6a=="Teacher"|e1_c6a=="special needs teacher"
gen oaccount=e1_c6a=="clerk"|e1_c6a=="accountant"|e1_c6a=="Accountant"|e1_c6a=="Clerk"
gen onurse=e1_c6a=="nurse"|e1_c6a=="Nursing"
gen oadmin=e1_c6a=="administrative"|e1_c6a=="secretary"|e1_c6a=="Secretary"|e1_c6a=="Administration"
gen opharmacist=e1_c6a=="pharmacist"|e1_c6a=="Pharmacist"|e1_c6a=="pharamcist"
gen privatesector=e1_c7a==2 if e1_c7a~=.
gen relatedtosomeone=e1_c9a==1 if e1_c9a~=.
gen numemployees=e1_c10a
replace numemployees=. if numemployees==998
gen femployer=e1_c12a==1 if e1_c12a~=.
gen ffamilyfriend=(e1_c12a==2|e1_c12a==3) if e1_c12a~=.
gen fadvertised=e1_c12a==6 if e1_c12a~=.
gen jobhours=e1_c13a
gen monthlyinc=e1_c16a 
gen regssc=e1_c19a==1 if e1_c19a~=.
gen formalcontract=e1_c20a==1 if e1_c20a~=.

* Do they expect to work in job after voucher ends?
tab m_c5 if time==1 & anyvoucher==1

* do they think experience of voucher will help long-term
tab e1_i19 if time==2 & status2==1

* For those with jobs in treatment group who didn't use voucher, why?
tab m_c10 if time==1 & anyvoucher==1 & status2==0
tab m_c10other if time==1 & anyvoucher==1 & status2==0

* reservation wage of unemployed control group at first endline
tab e1_d13 if time==2 & anyvoucher==0 & employed==0
gen wsupply=e1_d13
replace wsupply=salarycond_ if salarycond_~=.
tab wsupply if anyvoucher==0 & time==2


gen mid_related=m_c15
gen mid_income=m_c18
gen mid_formal=m_c21
gen mid_ssc=m_c22
gen usedwasta=e2_l17a if e2_l5ayear==2010|(e2_l5ayear==2011 & e2_l5amonth<=8)
gen needexperience=e2_l18a if e2_l5ayear==2010|(e2_l5ayear==2011 & e2_l5amonth<=8)
gen hoursunrelated=e2_l27a if e2_l5ayear==2010|(e2_l5ayear==2011 & e2_l5amonth<=8)
gen hoursrealwork=e2_l28a if e2_l5ayear==2010|(e2_l5ayear==2011 & e2_l5amonth<=8)
mat y = J(20,10,.)	
local j=1
foreach var of varlist oteacher oaccount onurse oadmin opharmacist privatesector numemployees relatedtosome usedwasta femployer ffamilyfriend fadvert mid_income m_c19hour m_c19days mid_formal mid_ssc hoursunrelated hoursrealwork {
sum `var' if time==1 & status1==1
mat y[`j',1] = r(mean)
sum `var' if time==1 & status2==1
mat y[`j',2] = r(mean)
sum `var' if time==1 & status3==1
mat y[`j',3] = r(mean)
sum `var' if time==1 & status3==0
mat y[`j',4] = r(mean)
ttest `var' if time==1 & status3~=., by(status3)
mat y[`j',5] = r(p)
sum `var' if time==1 & status2==0
mat y[`j',6] = r(mean)
ttest `var' if time==1 & status2~=., by(status2)
mat y[`j',7] = r(p)
sum `var' if time==1 & status1==0
mat y[`j',8] = r(mean)
ttest `var' if time==1 & status1~=., by(status1)
mat y[`j',9] = r(p)
ttest `var' if time==1 & status1~=. & (status1==0|status2==1), by(status1)
mat y[`j',10] = r(p)
local j=`j'+1
}
count if time==1 & status1==1
mat y[20,1] = r(N)
count if time==1 & status2==1
mat y[20,2] = r(N)
count if  time==1 & status3==1
mat y[20,3] = r(N)
count if  time==1 & status3==0
mat y[20,4] = r(N)
count if  time==1 & status2==0
mat y[20,6] = r(N)
count if time==1 & status1==0
mat y[20,8] = r(N)
mat rownames y = "Teacher" "Accountant" "Nurse" "Administrative" "Pharmacist" "Private Sector"  "Number of employees" "Related to someone" "Used Wasta" "Contacted Employer" "Found through family/friends" "Replied to Job ad"  "Monthly income" "Hours per day" "Days per month"  "Formal Contract" "Registered SSC" "Hours unrelated work" "Hours real work" "Sample Size"
mat colnames y = "Voucher Group" "Used Voucher" "Used Voucher - Stay in Job" "Used Voucher- Left Job" "p-value stayed vs left" "Didn't Use Voucher" "p-value used vs didn't" "Control Group" "p-value voucher vs control" "p-value voucher used vs control"
mat2txt, matrix(y) saving("output\Table7.xls") replace

***** Table 8: How do characteristics of voucher jobs differ from other jobs? ********
**************************************************************************************
mat y = J(16,10,.)	
local j=1
foreach var of varlist l t w e b_b1age b_married  motherwork fatherwork b_d7prviouswork  b_f1foundjob b_i1englishcourse b_k3car b_k4computer b_k13internet b_h4govbetterthanprivate {
sum `var' if time==1 & status1==1
mat y[`j',1] = r(mean)
sum `var' if time==1 & status2==1
mat y[`j',2] = r(mean)
sum `var' if time==1 & status3==1
mat y[`j',3] = r(mean)
sum `var' if time==1 & status3==0
mat y[`j',4] = r(mean)
ttest `var' if time==1 & status3~=., by(status3)
mat y[`j',5] = r(p)
sum `var' if time==1 & status2==0
mat y[`j',6] = r(mean)
ttest `var' if time==1 & status2~=., by(status2)
mat y[`j',7] = r(p)
sum `var' if time==1 & status1==0
mat y[`j',8] = r(mean)
ttest `var' if time==1 & status1~=., by(status1)
mat y[`j',9] = r(p)
ttest `var' if time==1 & status1~=. & (status1==0|status2==1), by(status1)
mat y[`j',10] = r(p)
local j=`j'+1
}
count if time==1 & status1==1
mat y[16,1] = r(N)
count if time==1 & status2==1
mat y[16,2] = r(N)
count if  time==1 & status3==1
mat y[16,3] = r(N)
count if  time==1 & status3==0
mat y[16,4] = r(N)
count if  time==1 & status2==0
mat y[16,6] = r(N)
count if time==1 & status1==0
mat y[16,8] = r(N)
mat rownames y = "Amman, Salt or Zarqa" "Tawjihi score above median" "Low desire to work full-time" "Travel" "Age" "Married" "Mother currently works" "Father currently works" "Has previously worked" "Had a job set up" "English" "Household Owns a Car" "Household Owns a Computer" "Household has Internet" "Prefers Government" "Sample Size"
mat colnames y = "Voucher Group" "Used Voucher" "Used Voucher - Stay in Job" "Used Voucher- Left Job" "p-value stayed vs left" "Didn't Use Voucher" "p-value used vs didn't" "Control Group" "p-value voucher vs control"
mat2txt, matrix(y) saving("output\Table8.xls") replace


**** Table 5: Impact on Employment Transitions **********
tsset seatno time
gen exitjob=L.employed==1 & employed==0
gen gainjob=L.employed==0 & employed==1
gen stayemployed=L.employed==1 & employed==1
gen stayunemployed=L.employed==0 & employed==0
gen staysameemployer=1 if time==2 & stayemployed==1 & ((e1_c5ayear<=2010|(e1_c5ayear==2011 & e1_c5amonth<=4)) & e1_c25a==1)
replace staysameemployer=1 if time==2 & stayemployed==1 & ((e1_c5byear<=2010|(e1_c5byear==2011 & e1_c5bmonth<=4)) & e1_c25b==1)
replace staysameemployer=0 if time==2 & staysameemployer==.

gen y=2 if e2_l5amonth<=12 & e2_l5ayear<=2011 & e2_l6a==1
replace y=2 if e2_l5amonth<=12 & e2_l5byear<=2011 & e2_l6b==1
replace y=2 if e2_l5amonth<=12 & e2_l5cyear<=2011 & e2_l6c==1
replace y=2 if e2_l5amonth<=12 & e2_l5dyear<=2011 & e2_l6d==1
replace y=2 if e2_l5amonth<=12 & e2_l5eyear<=2011 & e2_l6e==1

replace staysameemployer=1 if time==3 & stayemployed==1 & y==2
replace staysameemployer=0 if time==3 & staysameemployer==.

gen stayswitch=1 if stayemployed==1 & staysameemployer==0
replace stayswitch=0 if time>=2 & stayswitch==.

eststo clear
local i=1
foreach var of varlist stayemployed gainjob exitjob stayunemployed staysameemployer stayswitch {
areg `var' anyvoucher_post1 anyvoucher_post2 post1 post2 [pweight=weight] if time>=2, cluster(seatno) a(strata) r
sum `var' if anyvoucher==0 & time==2
estadd scalar mean1=r(mean)
sum `var' if anyvoucher==0 & time==3
estadd scalar mean2=r(mean)
eststo table9_`i'
local i=`i'+1
}

#delimit ;
esttab table9_* using output\table9.csv, replace depvar legend label nonumbers nogaps
	drop(_cons) 
	b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01)
	stats(mean1 mean2 N, fmt(%9.3f %9.3f %9.0g) labels("Control Mean in First Endline" "Control Mean in Second Endline" "Sample Size")) 
	title("Table 9: Impact on Employment Transitions") addnotes("""") ;
#delimit cr

*** Appendix Table 8: allowing dynamics to vary with location ****************
gen anyvoucher_post1_amman=anyvoucher_post1*l
gen anyvoucher_post2_amman=anyvoucher_post2*l
gen post1_amman=post1*l
gen post2_amman=post2*l

eststo clear
local i=1
foreach var of varlist stayemployed gainjob exitjob stayunemployed staysameemployer stayswitch {
areg `var' anyvoucher_post1 anyvoucher_post1_amman anyvoucher_post2 anyvoucher_post2_amman post1 post2 post1_amman post2_amman [pweight=weight] if time>=2, cluster(seatno) a(strata) r
sum `var' if anyvoucher==0 & time==2 & l==1
estadd scalar mean1=r(mean)
sum `var' if anyvoucher==0 & time==2 & l==0
estadd scalar mean2=r(mean)
sum `var' if anyvoucher==0 & time==3 & l==1
estadd scalar mean3=r(mean)
sum `var' if anyvoucher==0 & time==3 & l==0
estadd scalar mean4=r(mean)
eststo tabler3_`i'
local i=`i'+1
}

#delimit ;
esttab tabler3_* using output\appendixtable8.csv, replace depvar legend label nonumbers nogaps
	drop(_cons) 
	b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01)
	stats(mean1 mean2 mean3 mean4 N, fmt(%9.3f %9.3f %9.3f %9.3f %9.0g) labels("Control Mean in First Endline in Amman" "Control Mean in First Endline outside Amman" "Control Mean in Second Endline in Amman" "Control Mean in Second Endline outside Amman" "Sample Size")) 
	title("Appendix Table 8: Impact on Employment Transitions by Location") addnotes("""") ;
#delimit cr


********** Table 9: Why do firms hire graduates and why let them go? **************************

gen jobvoucherfirm=firm_e1==1
gen lookingtohire=firm_e3==1
gen wouldhavehiredwithoutvoucher=firm_e6==1
gen wouldhavehired50=firm_e8==1|wouldhavehiredwithoutvoucher==1
gen addition=firm_e10==2
gen stayer=firm_e11==1
gen employeequit=firm_e12<=3
gen employeefired=firm_e12==4
gen employee_unafford=firm_e12==5


mat y = J(8,7,.)	
local j=1
foreach var of varlist lookingtohire wouldhavehiredwithoutvoucher wouldhavehired50 addition employeequit employeefired employee_unafford {
sum `var' if time==2 & jobvoucherfirm==1
mat y[`j',1] = r(mean)
sum `var' if time==2 & jobvoucherfirm==1 & stayer==1
mat y[`j',2] = r(mean)
sum `var' if time==2 & jobvoucherfirm==1 & stayer==0
mat y[`j',3] = r(mean)
ttest `var' if time==2 & jobvoucherfirm==1, by(stayer)
mat y[`j',4] = r(p)
sum `var' if time==2 & jobvoucherfirm==1 & stayer==0 & l==1
mat y[`j',5] = r(mean)
sum `var' if time==2 & jobvoucherfirm==1 & stayer==0 & l==0
mat y[`j',6] = r(mean)
ttest `var' if time==2 & jobvoucherfirm==1 & stayer==0, by(l)
mat y[`j',7] = r(p)
local j=`j'+1
}
count if time==2 & jobvoucherfirm==1
mat y[8,1] = r(N)
count if time==2 & jobvoucherfirm==1 & stayer==1
mat y[8,2] = r(N)
count if  time==2 & jobvoucherfirm==1 & stayer==0
mat y[8,3] = r(N)
count if  time==2 & jobvoucherfirm==1 & stayer==0 & l==1
mat y[8,5] = r(N)
count if  time==2 & jobvoucherfirm==1 & stayer==0 & l==0
mat y[8,6] = r(N)
mat rownames y = "Were looking to hire" "Would have hired without voucher" "Would have hired for 50" "Worker was addition" "Employee quit" "Employee fired" "Employee unaffordable" "Sample Size"
mat colnames y = "All Voucher Users" "Kept Worker" "Worker Left" "p-value" "Amman Left" "Non-Amman Left" "p-value"
mat2txt, matrix(y) saving("output\Table10.xls") replace


***** Appendix Table 9 : Impact on Reservation Wages
gen reswage1=e1_d13
gen reswage2=e2_u9
gen reservationwage=reswage1 if time==2
replace reservationwage=reswage2 if time==3

eststo clear
areg reservationwage anyvoucher_post1 anyvoucher_post2  post2 [pweight=weight] if time>=2 & employed_==0, cluster(seatno) a(strata) r
sum reservationwage if anyvoucher==0 & time==2
estadd scalar mean1=r(mean)
sum reservationwage if anyvoucher==0 & time==3
estadd scalar mean2=r(mean)
ttest anyvoucher_post1==anyvoucher_post2
estadd scalar pval=r(p)
eststo tableapp9

#delimit ;
esttab tableapp9 using output\tableapp9.csv, replace depvar legend label nonumbers nogaps
	drop(_cons) 
	b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01)
	stats(mean1 mean2 pval N, fmt(%9.3f %9.3f %9.3f %9.0g) labels("Control Mean in Second Follow-up" "Control Mean in Third Follow-up" "Test of Equality of Time Effects" "Sample Size")) 
	title("Appendix Table 9: Impact on Reservation Wage") addnotes("""") ;
#delimit cr



**** Reason for Leaving Job discussed in text
* recode other answers
gen reasonforleaving=e1_c27a
* found better job
replace reasonforleaving=12 if e1_c27aother=="I found a better job"|e1_c27aother=="getting better job opportunities"
replace reasonforleaving=4 if e1_c27aother=="Salary few"|e1_c27aother=="Travel"|e1_c27aother=="disagreement on the salary"|e1_c27aother=="long working hours"|e1_c27aother=="personal reasons"|e1_c27aother=="the work is not comfortable"|e1_c27aother=="the work place is far away"|e1_c27aother=="transportation"
replace reasonforleaving=2 if e1_c27aother=="end of the employment period"
replace reasonforleaving=5 if reasonforleaving==6|reasonforleaving==7|reasonforleaving==8
replace reasonforleaving=1 if reasonforleaving==2|reasonforleaving==3
tab reasonforleaving if anyvoucher==1 & time==2 & e1_c24a==1, nol
bysort l: tab reasonforleaving if anyvoucher==1 & time==2 & e1_c24a==1, nol



******* Appendix Table 10 -- Employment Rates by Location and Treatment Status for Graduates Between 20 and 25

bysort l: tab employed_ if age_end<26 & anyvoucher==0 & time==2
bysort l: tab employed_ if age_end<26 & anyvoucher==1 & time==2
bysort l: tab employed_ if age_end<26 & anyvoucher==0 & time==3
bysort l: tab employed_ if age_end<26 & anyvoucher==1 & time==3




***************************************************************************************
***** Figures when data are formatted at monthly frequency *********************
**************************************************************************************
* Figure 1, Figure 2

use "JN_FinalSubmission.dta", clear

drop if seatno==.
drop if treatstat==.

for num 1/24: gen employed_X=e1_monthX
for num 25/36: gen employed_X=e2_monthX

gen voucheronly=treatstat==1
gen trainingonly=treatstat==2
gen bothtreat=treatstat==3
gen anyvoucher=voucheronly==1|bothtreat==1
gen weight=1
gen control=voucheronly==0 & trainingonly==0 & bothtreat==0
replace weight=749/300 if trainingonly==1
replace weight=749/449 if control==1

keep seatno strata voucheronly trainingonly bothtreat anyvoucher weight l employed_1-employed_36 mid_x end_x end2_x
reshape long employed_ ,i(seatno) j(time) 

* ensure consistency with months of surveys
replace employed_=mid_x if time==16
replace employed_=end_x if time==24
replace employed_=end2_x if time==36

for num 1/36: gen anyvoucherX=anyvoucher if time==X
for num 1/36: replace anyvoucherX=0 if anyvoucherX==.
for num 1/36: gen timeX=time==X

label var anyvoucher1 "Jan 2010"
label var anyvoucher2 "Feb 2010"
label var anyvoucher3 "Mar 2010"
label var anyvoucher4 "Apr 2010"
label var anyvoucher5 "May 2010"
label var anyvoucher6 "Jun 2010"
label var anyvoucher7 "Jul 2010"
label var anyvoucher8 "Aug 2010"
label var anyvoucher9 "Sep 2010"
label var anyvoucher10 "Oct 2010" 
label var anyvoucher11 "Nov 2010"
label var anyvoucher12 "Dec 2010"
label var anyvoucher13 "Jan 2011"
label var anyvoucher14 "Feb 2011"
label var anyvoucher15 "Mar 2011"
label var anyvoucher16 "Apr 2011"
label var anyvoucher17 "May 2011"
label var anyvoucher18 "Jun 2011"
label var anyvoucher19 "Jul 2011"
label var anyvoucher20 "Aug 2011"
label var anyvoucher21 "Sep 2011"
label var anyvoucher22 "Oct 2011"
label var anyvoucher23 "Nov 2011"
label var anyvoucher24 "Dec 2011"
label var anyvoucher25 "Jan 2012"
label var anyvoucher26 "Feb 2012"
label var anyvoucher27 "Mar 2012"
label var anyvoucher28 "Apr 2012"
label var anyvoucher29 "May 2012"
label var anyvoucher30 "Jun 2012"
label var anyvoucher31 "Jul 2012"
label var anyvoucher32 "Aug 2012"
label var anyvoucher33 "Sep 2012"
label var anyvoucher34 "Oct 2012"
label var anyvoucher35 "Nov 2012"
label var anyvoucher36 "Dec 2012"

**** Figure 1 ****************
areg employed_ anyvoucher1-anyvoucher36 time1-time36 [pweight=weight], a(strata) cluster(seatno) r
coefplot, drop(_cons time*) xline(0) xtitle("Treatment Effect on Employment") yline(8 20)

* other version of this
mat y = J(36,3,.)
forval w=1/36 {
areg employed_ anyvoucher [pweight=weight] if time==`w', a(strata) r
mat y[`w',1] = _b[anyvoucher]
mat y[`w',2] = _b[anyvoucher]+(-1.96*_se[anyvoucher])
mat y[`w',3] = _b[anyvoucher]+(1.96*_se[anyvoucher])
}
mat rownames y = "1/1/10" "2/1/10" "3/1/10" "4/1/10" "5/1/10" "6/1/10" "7/1/10" "8/1/10" "9/1/10" "10/1/10" "11/1/10" "12/1/10" "1/1/11" "2/1/11" "3/1/11" "4/1/11" "5/1/11" "6/1/11" "7/1/11" "8/1/11" "9/1/11" "10/1/11" "11/1/11" "12/1/11" "1/1/12" "2/1/12" "3/1/12" "4/1/12" "5/1/12" "6/1/12" "7/1/12" "8/1/12" "9/1/12" "10/1/12" "11/1/12" "12/1/12" 
mat colnames y = "t50" "t5" "t95"
  
mat2txt, matrix(y) saving("DataforFigure1.xls") replace

* then import this data and graph for figure 1
import excel "C:\Users\wb200090\Dropbox\DavidMcKenzie\otherresearch\Jordan\DataforFigure1.xlsx", sheet("DataforFigure1") firstrow
twoway line t50 t5 t95 Time, xline(18474 18839)
* edited with Figure1recorder.grec, saved as Figure1_ReStatRevised


*** regression reported in the text
*** all post august 2011 effects together
gen postintervention=time>=21
areg employed_ anyvoucher time21-time36 [pweight=weight] if time>=21, cluster(seatno) r a(strata)
sum employed if anyvoucher==0 & time>=21
estadd scalar mean=r(mean)
eststo tablepanel
#delimit ;
esttab tablepanel using output\table5.csv, replace depvar legend label nonumbers nogaps
	drop(_cons) 
	b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01)
	stats(mean N p1, fmt(%9.3f %9.0g) labels("Control Mean" "Sample Size")) 
	title("Table Panel") addnotes("""") ;
#delimit cr

***** Figure 2
**** Gaining jobs and Exiting Jobs
tsset seatno time
gen exitjob=L.employed==1 & employed==0
replace exitjob=. if employed==.|L.employed==.
gen gainjob=L.employed==0 & employed==1
replace gainjob=. if employed==.|L.employed==.


mat y = J(36,6,.)
forval w=2/36 {
areg gainjob anyvoucher [pweight=weight] if time==`w', a(strata) r
mat y[`w',1] = _b[anyvoucher]
mat y[`w',2] = _b[anyvoucher]+(-1.96*_se[anyvoucher])
mat y[`w',3] = _b[anyvoucher]+(1.96*_se[anyvoucher])
areg exitjob anyvoucher [pweight=weight] if time==`w', a(strata) r
mat y[`w',4] = _b[anyvoucher]
mat y[`w',5] = _b[anyvoucher]+(-1.96*_se[anyvoucher])
mat y[`w',6] = _b[anyvoucher]+(1.96*_se[anyvoucher])
}
mat rownames y = "1/1/10" "2/1/10" "3/1/10" "4/1/10" "5/1/10" "6/1/10" "7/1/10" "8/1/10" "9/1/10" "10/1/10" "11/1/10" "12/1/10" "1/1/11" "2/1/11" "3/1/11" "4/1/11" "5/1/11" "6/1/11" "7/1/11" "8/1/11" "9/1/11" "10/1/11" "11/1/11" "12/1/11" "1/1/12" "2/1/12" "3/1/12" "4/1/12" "5/1/12" "6/1/12" "7/1/12" "8/1/12" "9/1/12" "10/1/12" "11/1/12" "12/1/12" 
mat colnames y = "t50gain" "t5gain" "t95gain" "t50exit" "t5exit" "t95exit"
  
mat2txt, matrix(y) saving("DataforFigure2.xls") replace

clear
 import excel "C:\Users\wb200090\Dropbox\DavidMcKenzie\otherresearch\Jordan\DataforFigure2.xls.xlsx", sheet("DataforFigure2") firstrow
destring t5*, force replace
destring t9*, force replace
twoway line t50gain t5gain t95gain  time, xline(18474 18839)
graph save Graph "C:\Users\wb200090\Dropbox\DavidMcKenzie\otherresearch\Jordan\Figure2a.gph"
twoway line t50exit t5exit t95exit  time, xline(18474 18839)
graph save Graph "C:\Users\wb200090\Dropbox\DavidMcKenzie\otherresearch\Jordan\Figure2b.gph"

graph combine  Figure2a.gph Figure2b.gph, col(1)
graph save Graph "C:\Users\wb200090\Dropbox\DavidMcKenzie\otherresearch\Jordan\Figure2_ReStatRevised.gph"

areg exitjob anyvoucher1-anyvoucher36 time1-time36 [pweight=weight], a(strata) cluster(seatno) r
estimates store D
areg gainjob anyvoucher1-anyvoucher36 time1-time36 [pweight=weight], a(strata) cluster(seatno) r
estimates store F
coefplot D F, drop(_cons time*) xline(0) xtitle("Treatment Effect on Entry and Exit") yline(8 20)




