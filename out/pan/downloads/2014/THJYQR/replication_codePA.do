* replication code: Causal Inference in Conjoint Analysis:
* Understanding Multidimensional Choices via Stated Preference Experiments
* Jens Hainmueller, Daniel Hopkins, Teppei Yamamoto


clear all
set more off
ssc install matmap
ssc install mat2txt

* Figure 2: candidate conjoint
use candidate.dta, clear 

** ACMEs: rating outcome with regression estimator (attribute by attribute)
foreach x of varlist atmilitary atreligion ated atprof atmale atinc atrace atage  {
reg rating i.`x' , cl(resID)
mat    coef = e(b)
mat    varr = vecdiag(e(V))
matmap varr se , m(sqrt(@))
mat    coef = coef' , se'
scalar R = rowsof(coef)-1
mat    coef = coef[1..R,1..2]
matrix resmat = nullmat(resmat) \ coef
}
* export to R for plotting
mat2txt , matrix(resmat) saving(Candrating.txt) replace
matrix drop resmat

** ACMEs: forced choiche outcome with regression estimator (attribute by attribute)
foreach x of varlist atmilitary atreligion ated atprof atmale atinc atrace atage  {
reg  selected i.`x' , cl(resID) 
mat    coef = e(b)
mat    varr = vecdiag(e(V))
matmap varr se , m(sqrt(@))
mat    coef = coef' , se'
scalar R = rowsof(coef)-1
mat    coef = coef[1..R,1..2]
matrix resmat = nullmat(resmat) \ coef
}
mat2txt , matrix(resmat) saving(Candchoiche.txt) replace

* alternative: estimate ACMEs all in one model (same in expectation as attribute by atribute)
* rating outcome 
reg rating i.atmilitary i.atreligion i.ated i.atprof i.atmale i.atinc i.atrace i.atage , cl(resID)
* forced choiche outcome 
reg selected i.atmilitary i.atreligion i.ated i.atprof i.atmale i.atinc i.atrace i.atage , cl(resID) 


* replication of Figures 3, 4, 5, A.2-5: immigration conjoint
clear all
use immigrant.dta, clear
 
* two helper programs
* program grabs estimates and SEs from model and eliminates interaction terms
capture program drop jadjust
program def jadjust
capture matrix drop resmat
* get coefficients and SEs
mat    coef = e(b)
mat    varr = vecdiag(e(V))
matmap varr se , m(sqrt(@))
mat    coef = coef' , se'
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
				   
* program to estimate and fill in correct ACME for attributes with interactions
capture program drop restrictacme
program def restrictacme
* education
foreach x of numlist 2(1)7 {
lincom  (`x'.FeatEd * 1/7  + (`x'.FeatEd + `x'.FeatEd#2.FeatJob)  * 1/7 + /// 
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
* Job
* jobs 1-4, 6,7,9 have all edcation levels
foreach x of numlist 2(1)4 6 7 9 {
lincom  (`x'.FeatJob *1/7    + (`x'.FeatJob + 2.FeatEd#`x'.FeatJob) *1/7   + /// 
                              (`x'.FeatJob + 3.FeatEd#`x'.FeatJob) *1/7   + ///
                              (`x'.FeatJob + 4.FeatEd#`x'.FeatJob) *1/7   + ///
						      (`x'.FeatJob + 5.FeatEd#`x'.FeatJob) *1/7   + ///
						      (`x'.FeatJob + 6.FeatEd#`x'.FeatJob) *1/7   + ///
						      (`x'.FeatJob + 7.FeatEd#`x'.FeatJob) *1/7 )								  
mat resmat[rownumb(resmat,"`x'.FeatJob"),1] = r(estimate) 
mat resmat[rownumb(resmat,"`x'.FeatJob"),2] = r(se)									  
}
* other jobs have high educ level only
foreach x of numlist 5 8 10 11 {
lincom  (`x'.FeatJob *0    + (`x'.FeatJob + 2.FeatEd#`x'.FeatJob) *0   + /// 
                            (`x'.FeatJob + 3.FeatEd#`x'.FeatJob) *0   + ///
                            (`x'.FeatJob + 4.FeatEd#`x'.FeatJob) *0   + ///
			     		    (`x'.FeatJob + 5.FeatEd#`x'.FeatJob) *1/3   + ///
						    (`x'.FeatJob + 6.FeatEd#`x'.FeatJob) *1/3   + ///
						    (`x'.FeatJob + 7.FeatEd#`x'.FeatJob) *1/3 )	
mat resmat[rownumb(resmat,"`x'.FeatJob"),1] = r(estimate) 
mat resmat[rownumb(resmat,"`x'.FeatJob"),2] = r(se)				  
}
* origin
* reference country 6 goes with reason 1 and 2
foreach x of numlist 1(1)5 7(1)10 {
lincom  (`x'.FeatCountry * 1/2  + (`x'.FeatCountry + `x'.FeatCountry#2.FeatReason)  * 1/2 + /// 
                                  (`x'.FeatCountry + `x'.FeatCountry#3.FeatReason)  * 0 ) 
							      
mat resmat[rownumb(resmat,"`x'.FeatCountry"),1] = r(estimate) 
mat resmat[rownumb(resmat,"`x'.FeatCountry"),2] = r(se)
}
* reason
* reason 1 and 2 reason go with all countries
foreach x of numlist 2 {
lincom  (`x'.FeatReason * 1/10  + (`x'.FeatReason + 2.FeatCountry#`x'.FeatReason)  * 1/10 + /// 
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
* reason 3 goes with only 4 countries
foreach x of numlist 3 {
lincom  (`x'.FeatReason * 0  + (`x'.FeatReason + 2.FeatCountry#`x'.FeatReason)  * 0 + /// 
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

* Figure 3: Effects of Immigrant Attributes on Preference for Admission
global mod =  "i.FeatGender i.FeatEd##i.FeatJob i.FeatLang ib6.FeatCountry##i.FeatReason i.FeatExp ib3.FeatPlans i.FeatTrips"
global ses =  "cl(CaseID)"

reg Chosen_Immigrant $mod , $ses 
* extract coeffs, ses, and delete interactions
jadjust
matlist resmat
* fill in corrected ACMEs for attributes with restrictions
restrictacme
matlist resmat
* save for plotting in R
mat2txt , matrix(resmat) saving("Immiglongregression.txt")  replace
capture matrix drop resmat
capture matrix drop resmat1

* Figure 4: By Ethnocentrism
gen     ethnocentrismgr = 1 if ethnocentrism > -100 & ethnocentrism <= 10 
replace ethnocentrismgr = 2 if ethnocentrism > 10 & ethnocentrism <= 100

forvalues i = 1/2 {			   
reg Chosen_Immigrant $mod , $ses , if ethnocentrismgr==`i'		      
jadjust
restrictacme
mat2txt , matrix(resmat) saving(Ethno`i') replace
}

* Figure 5: By Immigrant's Job Plans
recode FeatPlans (1=1) (2=.) (3=.) (4=2), gen(plans)
forvalues i = 1/2 {	
reg Chosen_Immigrant i.FeatGender i.FeatEd##i.FeatJob i.FeatLang ///
                       ib6.FeatCountry##i.FeatReason i.FeatExp i.FeatTrips ///
					   , cl(CaseID) 	, if plans==`i'
jadjust
restrictacme
mat2txt , matrix(resmat) saving(Plans`i') replace
}


* Appendix Figures

* Figure A.2: Figure A.2: Effects of Immigrant Attributes on Preference for Admission by Choice Task
forvalues i = 1/5 {			   
reg Chosen_Immigrant $mod , $ses , if contest_no==`i'		   				   
jadjust
restrictacme
mat2txt , matrix(resmat) saving(Task`i') replace
}

*test if language effects are significantly different across tasks
reg Chosen_Immigrant i.FeatGender i.FeatEd##i.FeatJob i.FeatLang##i.contest_no ///
                       ib6.FeatCountry##i.FeatReason i.FeatExp ib3.FeatPlans i.FeatTrips ///
					   ,  cl(CaseID) 			

*language effect in each task
mat drop resmat
foreach x of numlist 1(1)5 {
lincom 4.FeatLang + 4.FeatLang#`x'.contest_no	
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.FeatLang"
matrix resmat = nullmat(resmat) \ coef
}
*joint test
test 4.FeatLang#2.contest_no 4.FeatLang#3.contest_no 4.FeatLang#3.contest_no ///
     4.FeatLang#4.contest_no 4.FeatLang#5.contest_no 

 
* Figure A.3: Effects of Immigrant Attributes on Preference for Admission by Profile Number
forvalues i = 1/2 {			   
reg Chosen_Immigrant $mod , $ses , if profile==`i'		   					   
jadjust
restrictacme
mat2txt , matrix(resmat) saving(Profile`i') replace
}

*test if language effects are significantly different across profiles
reg Chosen_Immigrant i.FeatGender i.FeatEd##i.FeatJob i.FeatLang##i.profile ///
                       ib6.FeatCountry##i.FeatReason i.FeatExp ib3.FeatPlans i.FeatTrips ///
					   ,  cl(CaseID) 			
*language effect in each profile
mat drop resmat
foreach x of numlist 1(1)2 {
lincom 4.FeatLang + 4.FeatLang#`x'.profile	
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.FeatLang"
matrix resmat = nullmat(resmat) \ coef
}
*joint test
test 4.FeatLang#2.profile

* Example of Multivariate Balance Check
reg ethnocentrism i.FeatGender i.FeatEd i.FeatJob i.FeatLang ///
             ib6.FeatCountry i.FeatReason i.FeatExp ///
			 ib3.FeatPlans i.FeatTrips , cl( CaseID )


* Figure A.4: Effects of Immigrant Attributes on Preference for Admission by Row Position of Attribute

* A4a: language order effects
capture drop pe se lb up position
capture matrix drop resmat
* pooled estimate
reg Chosen_Immigrant i.FeatLang , cl(CaseID)
lincom  4.FeatLang 
mat    coef = r(estimate) , r(se) , r(estimate) - 2*r(se) , r(estimate) + 2*r(se) , -1
matrix resmat = nullmat(resmat) \ coef
* estimates by position
reg Chosen_Immigrant i.FeatLang##LangPos , cl(CaseID)
lincom  4.FeatLang  
mat    coef = r(estimate) , r(se) , r(estimate) - 2*r(se) , r(estimate) + 2*r(se) , 1
matrix resmat = nullmat(resmat) \ coef
foreach x of numlist 2(1)9 {
lincom  4.FeatLang + `x'.LangPos#4.FeatLang
mat    coef = r(estimate) , r(se)  , r(estimate) - 2*r(se) , r(estimate) + 2*r(se), `x'
matrix resmat = resmat \ coef
}
matrix colnames resmat =  pe se lb up position
matlist resmat
svmat resmat , names(col) 
mat2txt , matrix(resmat) saving(LangByPosition) replace
	
graph twoway (rcap lb up position) (scatter pe position) , legend(off)  graphr(c(gs16)) plotr(style(outline)) ///
	  xtitle("Feature Position (-1 is pooled)") ytitle("Marginal Effect of Language Skills",size(medium)) xlabel(#10)

* joint test
reg Chosen_Immigrant i.FeatLang##LangPos , cl(CaseID)
test 2.LangPos#4.FeatLang 3.LangPos#4.FeatLang 4.LangPos#4.FeatLang 5.LangPos#4.FeatLang ///
     6.LangPos#4.FeatLang 7.LangPos#4.FeatLang 8.LangPos#4.FeatLang 9.LangPos#4.FeatLang 

* A4b: prior trips order effects
* code position of prior trips attribute
capture drop pe se lb up position
capture matrix drop resmat
reg Chosen_Immigrant i.FeatTrips , cl(CaseID)
lincom  5.FeatTrips 
mat    coef = r(estimate) , r(se) , r(estimate) - 2*r(se) , r(estimate) + 2*r(se) , -1
matrix resmat = nullmat(resmat) \ coef
reg Chosen_Immigrant i.FeatTrips##PriorPos , cl(CaseID)
lincom   5.FeatTrips  
mat    coef = r(estimate) , r(se) , r(estimate) - 2*r(se) , r(estimate) + 2*r(se) , 1
matrix resmat = nullmat(resmat) \ coef
foreach x of numlist 2(1)9 {
lincom  5.FeatTrips + `x'.PriorPos#5.FeatTrips
mat    coef = r(estimate) , r(se)  , r(estimate) - 2*r(se) , r(estimate) + 2*r(se), `x'
matrix resmat = resmat \ coef
}
matrix colnames resmat =  pe se lb up position
matlist resmat
svmat resmat , names(col) 
mat2txt , matrix(resmat) saving(PriorByPosition) replace
	
graph twoway (rcap lb up position) (scatter pe position) , legend(off)  graphr(c(gs16)) plotr(style(outline)) ///
	  xtitle("Feature Position (-1 is pooled)") ytitle("Marginal Effect of Language Skills",size(medium)) xlabel(#10)

* joint test
reg Chosen_Immigrant i.FeatTrips##PriorPos , cl(CaseID)
test 2.PriorPos#5.FeatTrips 3.PriorPos#5.FeatTrips 4.PriorPos#5.FeatTrips 5.PriorPos#5.FeatTrips ///
     6.PriorPos#5.FeatTrips 7.PriorPos#5.FeatTrips 8.PriorPos#5.FeatTrips 9.PriorPos#5.FeatTrips 
	 
* Figure A.5: Effects of Immigrant Attributes on Preference for Admission by Number of Atypical Profiles

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
replace countertypical = 1 if FeatCountry==8 &  ( FeatJob==10 | FeatJob==8 | FeatJob==5)
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
replace countertypical = 1 if FeatCountry==6 & (FeatLang==3 | FeatLang==4)
* German + unauthorized
replace countertypical = 1 if FeatCountry==1 & FeatTrips==5
* French + unauthorized
replace countertypical = 1 if FeatCountry==2 & FeatTrips==5
* Female + construction worker
replace countertypical = 1 if FeatGender==1 & FeatJob==6
* Male + child care provider
replace countertypical = 1 if FeatGender==2 & FeatJob==3
* Seek better job + No plans to look for work
replace countertypical = 1 if FeatReason==2 & FeatPlans==4

* sum by respondent
egen sumct = sum(countertypical) , by( CaseID ) 
* break into three groups
recode sumct (0/3=1) (4/5=2) (6/9=3) , gen(subset)

forvalues i = 1/3 {			   
reg Chosen_Immigrant $mod , $ses ,	if subset==`i'		   		   
jadjust
restrictacme
mat2txt , matrix(resmat) saving(Atypical`i') replace
}


