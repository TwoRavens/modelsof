* Replication Code for estimates

clear all
** two helper programs to compute AMCEs		   					   

* adjustmat
* gets coef estimates and ses from the model
* eliminates interaction terms needed for restrictions
capture program drop adjustmat
program def adjustmat
capture matrix drop resmat
* get coefficients and ses
mat    coef = e(b)
mat    varr = vecdiag(e(V))
matmap varr se , m(sqrt(@))
mat    coef = coef' , se'
* eliminate constant
scalar R = rowsof(coef)-1
mat    coef = coef[1..R,1..2]
* eliminate interactions terms
local namess : rownames coef
 foreach el of local namess {
   local include = regexm("`el'", "#")
   if "`include'" != "1" {
                    matrix getthis = coef["`el'",1..2]
                    matrix resmat = nullmat(resmat) \ getthis
            }
 }
end
* findit matmap

* restrictamce				   
* estimates AMCE for attributes with interactions
* and replaces them in the results matrix
capture program drop restrictamce
program def restrictamce
* education
* reference cat: no formal
* AMCE is defined over subset of commmon support 
* for the reference and comparison category 
* AMCEs are weighted averages of educ effect 
* we average over low-skilled jobs since 
* reference category (no formal) only occurs with low-skilled jobs
foreach x of numlist 2(1)7 {
qui: lincom  (`x'.FeatEd * 1/7  + (`x'.FeatEd + `x'.FeatEd#2.FeatJob)  * 1/7 + /// 
                             (`x'.FeatEd + `x'.FeatEd#3.FeatJob)  * 1/7 + ///
                             (`x'.FeatEd + `x'.FeatEd#4.FeatJob)  * 1/7 + ///
							 (`x'.FeatEd + `x'.FeatEd#5.FeatJob)  * 0 + ///
							 (`x'.FeatEd + `x'.FeatEd#6.FeatJob)  * 1/7 + ///
							 (`x'.FeatEd + `x'.FeatEd#7.FeatJob)  * 1/7 + ///
							 (`x'.FeatEd + `x'.FeatEd#8.FeatJob)  * 0 + ///
							 (`x'.FeatEd + `x'.FeatEd#9.FeatJob)  * 1/7 + ///
							 (`x'.FeatEd + `x'.FeatEd#10.FeatJob) * 0 + ///
							 (`x'.FeatEd + `x'.FeatEd#11.FeatJob) * 0)
mat resmat[rownumb(resmat,"`x'.FeatEd"),1] = r(estimate) 
mat resmat[rownumb(resmat,"`x'.FeatEd"),2] = r(se)	
}

* profession
* reference cat: janitor
* low skilled jobs 1-4,6,7,9 we average over all educ levels
foreach x of numlist 2(1)4 6 7 9 {
qui: lincom  (`x'.FeatJob *1/7    + (`x'.FeatJob + 2.FeatEd#`x'.FeatJob) *1/7   + /// 
                               (`x'.FeatJob + 3.FeatEd#`x'.FeatJob) *1/7   + ///
                               (`x'.FeatJob + 4.FeatEd#`x'.FeatJob) *1/7   + ///
							   (`x'.FeatJob + 5.FeatEd#`x'.FeatJob) *1/7   + ///
							   (`x'.FeatJob + 6.FeatEd#`x'.FeatJob) *1/7   + ///
							   (`x'.FeatJob + 7.FeatEd#`x'.FeatJob) *1/7 )								  
mat resmat[rownumb(resmat,"`x'.FeatJob"),1] = r(estimate) 
mat resmat[rownumb(resmat,"`x'.FeatJob"),2] = r(se)									  
}
* other jobs occur only with high educ (Financial analyst, Computer programmer, research scientist, Doctor)
* so effect of going from janitor to these only exists for high educ levels
foreach x of numlist 5 8 10 11 {
qui: lincom  (`x'.FeatJob *0    + (`x'.FeatJob + 2.FeatEd#`x'.FeatJob) *0   + /// 
                             (`x'.FeatJob + 3.FeatEd#`x'.FeatJob) *0   + ///
                             (`x'.FeatJob + 4.FeatEd#`x'.FeatJob) *0   + ///
							 (`x'.FeatJob + 5.FeatEd#`x'.FeatJob) *1/3   + ///
							 (`x'.FeatJob + 6.FeatEd#`x'.FeatJob) *1/3   + ///
							 (`x'.FeatJob + 7.FeatEd#`x'.FeatJob) *1/3 )	
mat resmat[rownumb(resmat,"`x'.FeatJob"),1] = r(estimate) 
mat resmat[rownumb(resmat,"`x'.FeatJob"),2] = r(se)				  
}

* origin
* reference cat: India 
* India only occurs with application reason 1 and 2, but not reason 3 (escape persecution)
* so we average over reason 1 and 2
foreach x of numlist 1(1)5 7(1)10 {
qui: lincom  (`x'.FeatCountry * 1/2  + (`x'.FeatCountry + `x'.FeatCountry#2.FeatReason)  * 1/2 + /// 
                                  (`x'.FeatCountry + `x'.FeatCountry#3.FeatReason)  * 0 ) 
							      
mat resmat[rownumb(resmat,"`x'.FeatCountry"),1] = r(estimate) 
mat resmat[rownumb(resmat,"`x'.FeatCountry"),2] = r(se)
}
* application reason
* reference: reunite with family 
* reason 1 and 2 go with all countries
foreach x of numlist 2 {
qui: lincom  (`x'.FeatReason * 1/10  + (`x'.FeatReason + 2.FeatCountry#`x'.FeatReason)  * 1/10 + /// 
                                  (`x'.FeatReason + 3.FeatCountry#`x'.FeatReason)  * 1/10 + /// 
							      (`x'.FeatReason + 4.FeatCountry#`x'.FeatReason)  * 1/10 + /// 
								  (`x'.FeatReason + 5.FeatCountry#`x'.FeatReason)  * 1/10 + /// 
								  (`x'.FeatReason + 6.FeatCountry#`x'.FeatReason)  * 1/10 + /// 
								  (`x'.FeatReason + 7.FeatCountry#`x'.FeatReason)  * 1/10 + /// 
								  (`x'.FeatReason + 8.FeatCountry#`x'.FeatReason)  * 1/10 + /// 
								  (`x'.FeatReason + 9.FeatCountry#`x'.FeatReason)  * 1/10 + /// 
								  (`x'.FeatReason + 10.FeatCountry#`x'.FeatReason) * 1/10) 							      
mat resmat[rownumb(resmat,"`x'.FeatReason"),1] = r(estimate) 
mat resmat[rownumb(resmat,"`x'.FeatReason"),2] = r(se)
}
* reason 3 (escape persecution) occurs only with 4 countries (China, Sudan, Somalia, Iraq)
foreach x of numlist 3 {
qui: lincom  (`x'.FeatReason * 0  + (`x'.FeatReason + 2.FeatCountry#`x'.FeatReason)  * 0 + /// 
                               (`x'.FeatReason + 3.FeatCountry#`x'.FeatReason)  * 0 + /// 
							   (`x'.FeatReason + 4.FeatCountry#`x'.FeatReason)  * 0 + /// 
							   (`x'.FeatReason + 5.FeatCountry#`x'.FeatReason)  * 0 + /// 
							   (`x'.FeatReason + 6.FeatCountry#`x'.FeatReason)  * 0 + /// 
							   (`x'.FeatReason + 7.FeatCountry#`x'.FeatReason)  * 1/4 + /// 
							   (`x'.FeatReason + 8.FeatCountry#`x'.FeatReason)  * 1/4 + /// 
							   (`x'.FeatReason + 9.FeatCountry#`x'.FeatReason)  * 1/4 + /// 
							   (`x'.FeatReason + 10.FeatCountry#`x'.FeatReason) * 1/4) 		
mat resmat[rownumb(resmat,"`x'.FeatReason"),1] = r(estimate) 
mat resmat[rownumb(resmat,"`x'.FeatReason"),2] = r(se)
}
end


* bechmark model with poststratification weights
global mod =  "i.FeatGender i.FeatEd##i.FeatJob i.FeatLang ib6.FeatCountry##i.FeatReason i.FeatExp ib3.FeatPlans i.FeatTrips [pweight=weight2]"
* clustered ses
global ses =  "cl(CaseID)"

* load data
use "repdata.dta", clear

** Figure 2: 
** Effects of Immigrant Attributes on Probability of Being Preferred for Admission
qui: reg Chosen_Immigrant $mod ,  $ses
** Table B.1. 
* findit outreg2
* outreg2 using Figure2table.xls , alpha(0.05) symbol(*) excel dec(3) label  replace sideway
* extract coefficents and delete interactions
adjustmat
* fill in correct ACMEs for attributes with restrictions
restrictamce
matlist resmat
* save for plotting in R
* findit mat2txt
mat2txt , matrix(resmat) saving("chosen.txt")  replace

* test if difference between China, Sudan, Somalia, and Iraq differs from Germany
foreach x of numlist 7(1)10{
tab FeatCountry if FeatCountry==`x'
test  (`x'.FeatCountry * 1/2  + (`x'.FeatCountry + `x'.FeatCountry#2.FeatReason)  * 1/2) = ///
	  (1.FeatCountry * 1/2  + (1.FeatCountry   +  1.FeatCountry#2.FeatReason)  * 1/2)
}



** Figure 3: 
** Probability of Being Preferred for Admission for Selected Immigrant Profiles
qui: reg Chosen_Immigrant $mod ,  $ses
predict fitted if e(sample)
sum fitted, detail
drop fitted

* 1st percentile
* Gender: Male 
* Education: 4th grade 
* Language: used interpreter 
* Origin: Sudan
* Profession: gardener 
* Job experience: 1-2 years
* Job plans: no plans to look for work 
* Application reason: escape persecution 
* Prior trips to U.S.: once w/o authorization
qui: margins, at(FeatGender=2 FeatEd=2 FeatLang=4 FeatCountry=8 FeatJob=4 FeatExp=2 FeatPlans=4 FeatReason=3 FeatTrips=5 ) ///
	 			 vce(unconditional) 
mat res = r(table)
mat res = res[1,1] , res[2,1] 
mat res = res ,2,2,4,8,4,2,4,3,5,.01
mat store = nullmat(store) \ res

* 25th percentile
* Gender: Male 
* Education: 8th grade 
* Language: tried English but unable 
* Origin: China 
* Profession: construction worker 
* Job experience: 1-2 years
* Job plans: interviews with employer 
* Application reason: seek better job 
* Prior trips to U.S.: never
qui: margins, at(FeatGender=2 FeatEd=3 FeatLang=3 FeatCountry=7 FeatJob=6 FeatExp=2 FeatPlans=2 FeatReason=2 FeatTrips=1) ///
	 			 vce(unconditional) 
mat res = r(table)
mat res = res[1,1] , res[2,1] 
mat res = res , 2,3,3,7,6,2,2,2,1,.25
mat store = nullmat(store) \ res

* 50th percentile
* Gender: Male 
* Education: high school 
* Language: broken English 
* Origin: India 
* Profession: teacher
* Job experience: 1-2 years
* Job plans: interviews with employer 
* Application reason: seek better job 
* Prior trips to U.S.: never
qui: margins, at(FeatGender=2 FeatEd=4 FeatLang=2 FeatCountry=6 FeatJob=7 FeatExp=2 FeatPlans=2 FeatReason=2 FeatTrips=1) ///
	 			 vce(unconditional) 
mat res = r(table)
mat res = res[1,1] , res[2,1] 
mat res = res ,2,4,2,6,7,2,2,2,1,.50
mat store = nullmat(store) \ res

* 75th percentile
* Gender: Male
* Education: two-year college 
* Language: broken English 
* Origin: Mexico
* Profession: nurse
* Job experience: 1-2 years
* Job plans: interviews with employer 
* Application reason: seek better job 
* Prior trips to U.S.: many times as tourist
qui: margins, at(FeatGender=2 FeatEd=5 FeatLang=2 FeatCountry=3 FeatJob=9 FeatExp=2 FeatPlans=2 FeatReason=2 FeatTrips=3) ///
	 			 vce(unconditional) 
mat res = r(table)
mat res = res[1,1] , res[2,1] 
mat res = res ,2,5,2,3,9,2,2,2,3,.75
mat store = nullmat(store) \ res

* 99th percentile
* Gender: Male
* Education: graduate degree 
* Language: fluent English
* Origin: Germany 
* Profession: research scientist
* Job experience: 3-5 years
* Job plans: contract with employer 
* Application reason: seek better job 
* Prior trips to U.S.: many times as tourist
qui: margins, at(FeatGender=2 FeatEd=7 FeatLang=1 FeatCountry=1 FeatJob=10 FeatExp=3 FeatPlans=1 FeatReason=2 FeatTrips=3) ///
	 			 vce(unconditional)  
mat res = r(table)
mat res = res[1,1] , res[2,1] 
mat res = res , 2,7,1,1,10,3,1,2,3,.99
mat store = nullmat(store) \ res

matlist store
matrix colnames store = pe se Gender_Immigrant Ed_Immigrant Language_Immigrant Country_Immigrant Job_Immigrant JobExp_Immigrant JobPlans_Immigrant Reason_Immigrant PriorTrips_Immigrant percentile
matrix rownames store = 1 2 3 4 5
mat2txt , matrix(store) saving(chosenPRs.txt) replace

** Figure 4: 
** Effects of Immigrant Attributes on Probability of Being Preferred for Admission by Education of Respondent
* education
recode ppeducat (1/2=1) (3/4=2) , gen(subset)
tab subset
forvalues i = 1/2 {
qui: reg Chosen_Immigrant $mod ,  $ses , if subset==`i'
adjustmat
restrictamce
matlist resmat
mat2txt , matrix(resmat) saving(ppeducat`i') replace 	 	  
}

** test if AMCEs differ between groups
set matsize 11000
global mod2 =  "i.FeatGender##i.subset i.FeatEd##i.FeatJob##i.subset i.FeatLang##i.subset ib6.FeatCountry##i.FeatReason##i.subset i.FeatExp##i.subset ib3.FeatPlans##i.subset i.FeatTrips##i.subset [pweight=weight2]"
qui: reg Chosen_Immigrant $mod2 ,  $ses 
* financial analyst							 					 
test  ((5.FeatJob + 5.FeatEd#5.FeatJob) *1/3   + ///
	   (5.FeatJob + 6.FeatEd#5.FeatJob) *1/3   + ///
	   (5.FeatJob + 7.FeatEd#5.FeatJob) *1/3 ) = ///				 
      ((5.FeatJob  + 5.FeatJob#2.subset + 5.FeatEd#5.FeatJob + 5.FeatEd#5.FeatJob#2.subset ) *1/3  + ///
	   (5.FeatJob  + 5.FeatJob#2.subset + 6.FeatEd#5.FeatJob + 6.FeatEd#5.FeatJob#2.subset) *1/3   + ///
	   (5.FeatJob  + 5.FeatJob#2.subset + 7.FeatEd#5.FeatJob + 7.FeatEd#5.FeatJob#2.subset) *1/3 ) 				 

* research scientist: 
test    ((10.FeatJob  + 5.FeatEd#10.FeatJob) *1/3   + ///
		 (10.FeatJob  + 6.FeatEd#10.FeatJob) *1/3   + ///
		 (10.FeatJob  + 7.FeatEd#10.FeatJob) *1/3 ) = ///				 
        ((10.FeatJob  + 10.FeatJob#2.subset + 5.FeatEd#10.FeatJob + 5.FeatEd#10.FeatJob#2.subset) *1/3   + ///
		 (10.FeatJob  + 10.FeatJob#2.subset + 6.FeatEd#10.FeatJob + 6.FeatEd#10.FeatJob#2.subset) *1/3   + ///
		 (10.FeatJob  + 10.FeatJob#2.subset + 7.FeatEd#10.FeatJob + 7.FeatEd#10.FeatJob#2.subset) *1/3 ) 				 
drop subset
  
** Figure 5: 
** Effects of Immigrant Attributes on Probability of Being Preferred for Admission by Ethnocentrism of Respondent

* ethnocentrism
* formula from Kinder and Kim chapter 3: 
* E* = [FTH in-group  - average FTH for out-groups]
* exclude Hispanics and Ethnicity: multiple or other 
gen     ingroupTM = W1_Q8a if  ppethm==1 /* whites */
replace ingroupTM = W1_Q8b if  ppethm==2 /* black */
egen    outgroupTM  = rowmean(W1_Q5 W1_Q6 W1_Q7) if  ppethm==1 | ppethm==2 /* outgroups: Hispanic, Immigrants, Asian Americans  */
gen ethnocentrism = ingroupTM - outgroupTM
drop ingroupTM outgroupTM

egen subset = cut(ethnocentrism), group(2)
replace subset = subset+1
tab subset
forvalues i = 1/2 {
qui: reg Chosen_Immigrant $mod ,  $ses , if subset==`i'
adjustmat
restrictamce
matlist resmat
mat2txt , matrix(resmat) saving(ethnocentrism`i') replace 	 	  
}

* test difference of non-european countries across subsets
qui: reg Chosen_Immigrant $mod2 ,  $ses  
test 3.FeatCountry#2.subset  + .5*3.FeatCountry#2.FeatReason#2.subset + ///
     4.FeatCountry#2.subset  + .5*4.FeatCountry#2.FeatReason#2.subset + ///
     7.FeatCountry#2.subset  + .5*7.FeatCountry#2.FeatReason#2.subset + ///
     8.FeatCountry#2.subset  + .5*8.FeatCountry#2.FeatReason#2.subset + ///
     9.FeatCountry#2.subset  + .5*9.FeatCountry#2.FeatReason#2.subset + ///
    10.FeatCountry#2.subset + .5*10.FeatCountry#2.FeatReason#2.subset = 0 
drop subset


** Figure 6: 
** Effects of Immigrant Attributes on Probability of Being Preferred for Admission by Party Identification of Respondent
recode Party_ID (-1=.) (1/3=1) (4=.) (5/7=2) , gen(subset)
tab subset
forvalues i = 1/2 {
qui: reg Chosen_Immigrant $mod ,  $ses , if subset==`i'
adjustmat
restrictamce
matlist resmat
mat2txt , matrix(resmat) saving(partyid`i') replace 	 	  
}

* test difference in penalty for Iraq
qui: reg Chosen_Immigrant $mod2 ,  $ses 
test  (10.FeatCountry * 1/2  + (10.FeatCountry + 10.FeatCountry#2.FeatReason)  * 1/2) = ///
	 ((10.FeatCountry + 10.FeatCountry#2.subset) * 1/2  + (10.FeatCountry +  10.FeatCountry#2.subset + 10.FeatCountry#2.FeatReason + 10.FeatCountry#2.FeatReason#2.subset)  * 1/2 )
drop subset


** SI Appendix

** Figure B.1: 
** Effects of Immigrant Attributes on Probability of Being Preferred for Admission by Percent of Immigrant Workers in Industry
egen    subset = cut(FB09) , group(2)
replace subset = subset+1
tab subset
forvalues i = 1/2 {
qui: reg Chosen_Immigrant $mod ,  $ses , if subset==`i'
adjustmat
restrictamce
mat2txt , matrix(resmat) saving(industryfb`i') replace 	 	  
}
drop subset

** Figure B.2: 
** Effects of Immigrant Attributes on Probability of Being Preferred for Admission by Household Income
egen    subset = cut(ppincimp), group(2)
replace subset = subset + 1
tab subset
forvalues i = 1/2 {
qui: reg Chosen_Immigrant $mod ,  $ses , if subset==`i'
adjustmat
restrictamce
mat2txt , matrix(resmat) saving(income`i') replace 	 	  
}
drop subset

** Figure B.3: 
** Effects of Immigrant Attributes on Probability of Being Preferred for Admission by Fiscal Exposure to Immigration
gen subset = fisexp2
tab subset
forvalues i = 1/2 {
qui: reg Chosen_Immigrant $mod ,  $ses , if subset==`i'
adjustmat
restrictamce
matlist resmat
mat2txt , matrix(resmat) saving(fiscalexp2`i') replace 	 	  
}

* test if AMCEs differ across subsets
qui: reg Chosen_Immigrant $mod2 ,  $ses 

* no plans to work
test 4.FeatPlans  = (4.FeatPlans + 4.FeatPlans#2.subset)

* education
test   2.FeatEd#2.subset + .1428571*2.FeatEd#2.FeatJob#2.subset + .1428571*2.FeatEd#3.FeatJob#2.subset + ///
       .1428571*2.FeatEd#4.FeatJob#2.subset + .1428571*2.FeatEd#6.FeatJob#2.subset + ///
       .1428571*2.FeatEd#7.FeatJob#2.subset + .1428571*2.FeatEd#9.FeatJob#2.subset + ///
	   3.FeatEd#2.subset + .1428571*3.FeatEd#2.FeatJob#2.subset + .1428571*3.FeatEd#3.FeatJob#2.subset + ///
       .1428571*3.FeatEd#4.FeatJob#2.subset + .1428571*3.FeatEd#6.FeatJob#2.subset + ///
       .1428571*3.FeatEd#7.FeatJob#2.subset + .1428571*3.FeatEd#9.FeatJob#2.subset + ///
	   4.FeatEd#2.subset + .1428571*4.FeatEd#2.FeatJob#2.subset + .1428571*4.FeatEd#3.FeatJob#2.subset + ///
       .1428571*4.FeatEd#4.FeatJob#2.subset + .1428571*4.FeatEd#6.FeatJob#2.subset + ///
       .1428571*4.FeatEd#7.FeatJob#2.subset + .1428571*4.FeatEd#9.FeatJob#2.subset + ///	   
	   5.FeatEd#2.subset + .1428571*5.FeatEd#2.FeatJob#2.subset + .1428571*5.FeatEd#3.FeatJob#2.subset + ///
       .1428571*5.FeatEd#4.FeatJob#2.subset + .1428571*5.FeatEd#6.FeatJob#2.subset + ///
       .1428571*5.FeatEd#7.FeatJob#2.subset + .1428571*5.FeatEd#9.FeatJob#2.subset + ///		   
	   6.FeatEd#2.subset + .1428571*6.FeatEd#2.FeatJob#2.subset + .1428571*6.FeatEd#3.FeatJob#2.subset + ///
       .1428571*6.FeatEd#4.FeatJob#2.subset + .1428571*6.FeatEd#6.FeatJob#2.subset + ///
       .1428571*6.FeatEd#7.FeatJob#2.subset + .1428571*6.FeatEd#9.FeatJob#2.subset + ///	
	   7.FeatEd#2.subset + .1428571*7.FeatEd#2.FeatJob#2.subset + .1428571*7.FeatEd#3.FeatJob#2.subset + ///
       .1428571*7.FeatEd#4.FeatJob#2.subset + .1428571*7.FeatEd#6.FeatJob#2.subset + ///
       .1428571*7.FeatEd#7.FeatJob#2.subset + .1428571*7.FeatEd#9.FeatJob#2.subset = 0
drop subset

** Figure B.4: 
** Effects of Immigrant Attributes on Probability of Being Preferred for Admission by Demographics of RespondentsÕ ZIP Codes
gen subset = censusgroup
tab subset
forvalues i = 1/3 {
qui: reg Chosen_Immigrant $mod ,  $ses , if subset==`i'
adjustmat
restrictamce
mat2txt , matrix(resmat) saving(zipcodediversity`i') replace 	 	  
}
drop subset

** Figure B.5: 
** Effects of Immigrant Attributes on Probability of Being Preferred for Admission by Ethnicity of Respondent
recode ppethm (1=2) (2/4=1) (5=.), gen(subset)
tab subset
forvalues i = 1/2 {
qui: reg Chosen_Immigrant $mod ,  $ses , if subset==`i'
adjustmat
restrictamce
mat2txt , matrix(resmat) saving(whiteornot`i') replace 	 	  
}
drop subset

** Figure B.6: 
** Effects of Immigrant Attributes on Probability of Being Preferred for Admission by Hispanic Ethnicity
recode ppethm (1/3=1) (4=2) (5=.), gen(subset)
tab subset
forvalues i = 1/2 {
qui: reg Chosen_Immigrant $mod ,  $ses , if subset==`i'
adjustmat
restrictamce
mat2txt , matrix(resmat) saving(hispanicornot`i') replace 	 	  
}
* test if AMCEs differ across subsets
* unauthorized entry
qui: reg Chosen_Immigrant $mod2 ,  $ses 
lincom  5.FeatTrips 
lincom  5.FeatTrips + 5.FeatTrips#2.subset
test 5.FeatTrips  = (5.FeatTrips + 5.FeatTrips#2.subset)
drop subset

** Figure B.7: 
** Effects of Immigrant Attributes on Probability of Being Preferred for Admission by RespondentsÕ Ideology
recode Ideology (-1=.) (1/3=1) (4=.) (5/7=2) , gen(subset)
tab subset
forvalues i = 1/2 {
qui: reg Chosen_Immigrant $mod ,  $ses , if subset==`i'
adjustmat
restrictamce
mat2txt , matrix(resmat) saving(ideology`i') replace 	 	  
}
drop subset

** Figure B.8: 
** Effects of Immigrant Attributes on Probability of Being Preferred for Admission by Immigration Attitude of Respondent
recode W1_Q4 (1/3=1) (4/5=2) , gen(subset)
tab subset
forvalues i = 1/2 {
qui: reg Chosen_Immigrant $mod ,  $ses , if subset==`i'
adjustmat
restrictamce
mat2txt , matrix(resmat) saving(opposeimmig`i') replace 	 	  
}
drop subset

** Figure B.9: 
** Effects of Immigrant Attributes on Probability of Being Preferred for Admission by Gender of Respondent
gen subset = ppgender
tab subset
forvalues i = 1/2 {
qui: reg Chosen_Immigrant $mod ,  $ses , if subset==`i'
adjustmat
restrictamce
mat2txt , matrix(resmat) saving(gender`i') replace 	 	  
}
drop subset

** Figure B.10: 
** Effects of Immigrant Attributes on Probability of Being Preferred for Admission by Age of Respondent
egen subset = cut(ppage) , group(2)
replace subset = subset + 1
tab subset
forvalues i = 1/2 {
qui: reg Chosen_Immigrant $mod ,  $ses , if subset==`i'
adjustmat
restrictamce
mat2txt , matrix(resmat) saving(age`i') replace 	 	  
}
drop subset


** Table B.2: 
** Effect of a Match between the ImmigrantÕs Profession and the RespondentÕs Profession
tab FeatJob, gen(iJob)
rename iJob1 iJanitor
rename iJob2 iWaiter
rename iJob3 iChildcare 
rename iJob4 iGardener 
rename iJob5 iFinancial
rename iJob6 iConstruction  
rename iJob7 iTeacher 
rename iJob8 iComputer  
rename iJob9 iNurse 
rename iJob10 iResearch 
rename iJob11 iDoctor

gen     match = 0 if iJanitor!=.
replace match = 1 if iJanitor==1       & OCC_JA==1
replace match = 1 if iWaiter==1        & OCC_WA==1
replace match = 1 if iGardener==1      & OCC_GA==1
replace match = 1 if iChildcare==1     & OCC_CC==1
replace match = 1 if iFinancial==1     & OCC_FA==1
replace match = 1 if iConstruction==1  & OCC_CO==1
replace match = 1 if iComputer==1      & OCC_CP==1
replace match = 1 if iTeacher==1       & OCC_TE==1
replace match = 1 if iNurse==1         & OCC_NU==1
replace match = 1 if iResearch==1      & OCC_RS==1
replace match = 1 if iDoctor==1        & OCC_DR==1

global add = "match OCC*"

reg Chosen_Immigrant $add  $mod  ,  $ses 
*outreg2 using Res1.xls, stats(coef se) dec(3) replace

reg Support_Admission $add  $mod  ,  $ses 
*outreg2 using Res1.xls, stats(coef se) dec(3) append 

reg Rating_Immigrant $add  $mod  ,  $ses 
*outreg2 using Res1.xls, stats(coef se) dec(3) append 
 
** outreg2 using Res1.xls, stats(coef se) dec(2) append 

** Figure C.1: 
** Effects of Immigrant Attributes on Support for Admission
qui: reg Support_Admission $mod ,  $ses
adjustmat
restrictamce
matlist resmat
mat2txt , matrix(resmat) saving("support.txt")  replace

** Figure C.2: 
** Effects of Immigrant Attributes on Probability of Being Preferred for Admission with Respondent Fixed Effects
qui: xtreg Chosen_Immigrant $mod ,  $ses i(CaseID) fe  
adjustmat
restrictamce
mat2txt , matrix(resmat) saving(resfixedeffects) replace 	 	  

** Figure C.3: 
** Effects of Immigrant Attributes on Probability of Being Preferred for Admission with Respondent Random Effects
global modre =  "i.FeatGender i.FeatEd##i.FeatJob i.FeatLang ib6.FeatCountry##i.FeatReason i.FeatExp ib3.FeatPlans i.FeatTrips "
qui: xtreg Chosen_Immigrant $modre ,   i(CaseID) re cl(CaseID)
adjustmat
restrictamce
mat2txt , matrix(resmat) saving(resrandomeffects) replace 	 	  

** Figure C.4: 
** Effects of Immigrant Attributes on Probability of Being Preferred for Admission by Panel Tenure
egen  subset = cut( Panel_Tenure_Months) , group(2)
replace subset = subset + 1
tab subset
forvalues i = 1/2 {
qui: reg Chosen_Immigrant $mod ,  $ses , if subset==`i'
adjustmat
restrictamce
mat2txt , matrix(resmat) saving(paneltenure`i') replace 	 	  
}
drop subset

** Figure C.5: 
** Effects of Immigrant Attributes on Probability of Being Preferred for Admission by Pairing
gen subset = contest_no
tab subset
forvalues i = 1/5 {
qui: reg Chosen_Immigrant $mod ,  $ses , if subset==`i'
adjustmat
restrictamce
mat2txt , matrix(resmat) saving(pairingno`i') replace 	 	  
}
drop subset

** Figure C.6: 
** Effects of Immigrant Attributes on Probability of Being Preferred for Admission by Self-Monitoring Level

* Self Monitoring
recode W1_Q1 W1_Q2 W1_Q3 (5=1) (4=2) (2=4) (1=5) /* increasing in self monitoring */

gen     SM_index    = (W1_Q1 + W1_Q2 + W1_Q3)/3
egen    subset  = cut(SM_index ) , group(2)
replace subset = subset+1
tab subset
forvalues i = 1/2 {
qui: reg Chosen_Immigrant $mod ,  $ses , if subset==`i'
adjustmat
restrictamce
mat2txt , matrix(resmat) saving(selfmonitor`i') replace 	 	  
}
* test if AMCEs differ across subsets
qui: reg Chosen_Immigrant $mod2 ,  $ses 

* Iraq
test (10.FeatCountry * 1/2  + (10.FeatCountry + 10.FeatCountry#2.FeatReason)  * 1/2) = ///
	 ((10.FeatCountry + 10.FeatCountry#2.subset) * 1/2  + (10.FeatCountry +  10.FeatCountry#2.subset + 10.FeatCountry#2.FeatReason + 10.FeatCountry#2.FeatReason#2.subset)  * 1/2 )

* Somalia
test (9.FeatCountry * 1/2  + (9.FeatCountry + 9.FeatCountry#2.FeatReason)  * 1/2) = ///
	 ((9.FeatCountry + 9.FeatCountry#2.subset) * 1/2  + (9.FeatCountry +  9.FeatCountry#2.subset + 9.FeatCountry#2.FeatReason + 9.FeatCountry#2.FeatReason#2.subset)  * 1/2 )
	 
* Mexico
test (3.FeatCountry * 1/2  + (3.FeatCountry + 3.FeatCountry#2.FeatReason)  * 1/2) = ///
	 ((3.FeatCountry + 3.FeatCountry#2.subset) * 1/2  + (3.FeatCountry +  3.FeatCountry#2.subset + 3.FeatCountry#2.FeatReason + 3.FeatCountry#2.FeatReason#2.subset)  * 1/2 )

* unauthorized entry
test 5.FeatTrips  = (5.FeatTrips + 5.FeatTrips#2.subset)
drop subset

** FigureC.7: 
** Effects of Immigrant Attributeson Probability of Being Preferred for Admission by Number of Atypical Profiles

* countertypical profiles
gen     countertypical = 0 if FeatCountry!=.
* Mexico + {some college or college degree or graduate degree}
replace countertypical = 1 if FeatCountry==3 & FeatEd>=5 & FeatEd!=.
* Mexico + {doctor or research scientist or computer programmer or financial analyst}
replace countertypical = 1 if FeatCountry==3 & (FeatJob==11 | FeatJob==10 | FeatJob==8 | FeatJob==5)
* Somalia + {some college or college degree or graduate degree}
replace countertypical = 1 if FeatCountry==9 & FeatEd>=5 & FeatEd!=.
* Somalia + {doctor or research scientist or computer programmer or financial analyst}
replace countertypical = 1 if FeatCountry==9 & (FeatJob==11 | FeatJob==10 | FeatJob==8 | FeatJob==5)
* Sudan + {research scientist or computer programmer or financial analyst}
replace countertypical = 1 if FeatCountry==9 & ( FeatJob==10 | FeatJob==8 | FeatJob==5)
* Iraq + {research scientist or computer programmer or financial analyst}
replace countertypical = 1 if FeatCountry==10 & ( FeatJob==10 | FeatJob==8 | FeatJob==5)
* German + {no formal education or 4th grade education or 8th grade education}
replace countertypical = 1 if FeatCountry==1 & FeatEd<=3 & FeatEd!=.
* German + {janitor or waiter or child care provider or gardener}
replace countertypical = 1 if FeatCountry==1 & ( FeatJob==1 | FeatJob==3 | FeatJob==4)
* French + {no formal education or 4th grade education or 8th grade education}
replace countertypical = 1 if FeatCountry==2 & FeatEd<=3 & FeatEd!=.
* French+ {janitor or waiter or child care provider or gardener}
replace countertypical = 1 if FeatCountry==2 & ( FeatJob==1 | FeatJob==3 | FeatJob==4)
* Indian + {no formal education or 4th grade education or 8th grade education}
replace countertypical = 1 if FeatCountry==6 & FeatEd<=3 & FeatEd!=.
* Indian + {janitor or waiter or child care provider or gardener}
replace countertypical = 1 if FeatCountry==6 & ( FeatJob==1 | FeatJob==3 | FeatJob==4)
* Indian + {tried English but unable or used interpreter}
replace countertypical = 1 if FeatCountry==6 & FeatLang==3
* German + unauthorized
replace countertypical = 1 if FeatCountry==1 & FeatTrips==5
* French + unauthorized
replace countertypical = 1 if FeatCountry==2 & FeatTrips==5
* Female + construction worker
replace countertypical = 1 if FeatCountry==1 & FeatJob==6
* Male + child care provider
replace countertypical = 1 if FeatCountry==2 & FeatJob==3
* Seek better job + No plans to look for work
replace countertypical = 1 if FeatReason==2 & FeatPlans==4

egen sumct = sum(countertypical) , by( CaseID ) , if  Chosen_Immigrant!=.
recode sumct (0/3=1) (4/5=2) (6/9=3), gen(subset)

forvalues i = 1/3 {
qui: reg Chosen_Immigrant $mod ,  $ses , if subset==`i'
adjustmat
restrictamce
mat2txt , matrix(resmat) saving(countertypical`i') replace 	 	  
}
drop subset


