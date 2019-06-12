// The previous analysis showed that there was little difference between marginal effects
// estimated from a heteroskedastic probit model and a linear probability model.
// As a result, all the instrumental variable analysis focuses on the LPM.

clear
etime, start
set more off
set scheme s2mono
set type double

///CGSS 2005 data
use "\\file\UsersW$\wrr15\Home\My Documents\My Files\XINDONG XUE\ECONOMICS E-JOURNAL (Revision)\DATA AND PROGRAMS\data2005b.dta" 
//merge with county identifier
sort serial 
merge serial using "\\file\UsersW$\wrr15\Home\My Documents\My Files\XINDONG XUE\ECONOMICS E-JOURNAL (Revision)\DATA AND PROGRAMS\county 2005.dta"
drop _merge

//generate county-mean trust by urban and rural 
sort county 
by county: egen murbtrust = mean(stdtrust) if urban 
by county: egen mrurtrust = mean(stdtrust) if urban ==0


//generate county-mean social relationship by urban and rural 
sort county 
by county: egen murbsocial = mean(stdsocial) if urban 
by county: egen mrursocial = mean(stdsocial) if urban ==0

//generate county-mean social participation by urban and rural 
sort county 
by county: egen murbsp = mean(stdsp) if urban 
by county: egen mrursp = mean(stdsp) if urban ==0

gen mtrust = murbtrust if urban
replace mtrust = mrurtrust if urban==0
gen msocial = murbsocial if urban
replace msocial = mrursocial if urban==0
gen msp = murbsp if urban
replace msp = mrursp if urban==0


//Other IVs

gen phone = qc11f + qc11g                                            //number of phones and cell phones (household)
by county : egen murbphone = mean(phone) if urban 
by county : egen mrurphone = mean(phone) if urban ==0

mvencode qe19* , mv(. =0) override
gen caring =  qe19a+ qe19b+ qe19c+ qe19d+ qe19e+ qe19f+ qe19g        //caring each other
by county : egen murbcare= mean(caring) if urban 
by county : egen mrurcare = mean(caring) if urban ==0

replace qg15a = 0 if qg15a ==2 
replace qg15a = 0 if qg15a ==.
mvencode qg16*, mv(.= 0) override     
gen pub = qg15a + qg1601+ qg1602+ qg1603+ qg1604+ qg1605+ qg1606+ qg1607+ qg1608    //index of public decision 


mvencode qf12* qf13*, mv(.= 0) override     
recode qf12* (1=3)  (3=1) 
recode qf13* (6=0)
gen kin =   qf12a+ qf12b+ qf12c+ qf12d+ qf12e+ qf12f+ qf13a+ qf13b+ qf13c+ qf13d+ qf13e+ qf13f+ qf13g+ qf13h+ qf13i+ qf13j   //kinship 

mvencode qe15* , mv(.=0) override
gen judge =  qe15a+ qe15b+ qe15c+ qe15d+ qe15e+ qe15f               //an index of judging other people


//Generate per capita income and Gini coefficnet 
gen hsize = qc08  
gen pinc = familyincome/hsize                                      // household average per capita income
drop if pinc==.
egen gini = inequal(pinc), by(county) weight(hsize) index(gini)    // gini by county for income*/
gen loginc = log(pinc)
gen loginc2 = loginc^2
by county: egen tincom = sum(familyincome)
by county: egen tsize = sum(hsize)
gen pincom = tincom/tsize                                           
gen lpincom = log(pincom)                                          //county average per capita income
gen lpincom2 = lpincom^2


// First I create a binary self reported health variable
gen SRHH = SRH3
replace SRHH =[SRH3==4 | SRH3==5  | SRH3==6]

// URBAN

/*
// I first re-estimate a homoskedastic probit
probit SRHH stdtrust stdsocial stdsp age female han partymember loginc  ///
midses highses unmarried divorced widowed  primaryeduc junioreduc univeduc ///
gini lpincom if urban==1, cluster(county)

// This section calculates the effect of a one-unit change in each of the 
// variables on the probability that SRHH = 1
margins, dydx(*) 

//Now I adjust for endogeneity 
ivprobit SRHH age female han partymember loginc midses highses unmarried ///
divorced widowed  primaryeduc junioreduc univeduc gini lpincom ///
(stdtrust  stdsocial stdsp = murbtrust murbsocial murbsp) if urban==1, vce(cluster county)

// This section calculates the effect of a one-unit change in each of the 
// variables on the probability that SRHH = 1
margins, dydx(_all) pred(pr)
*/

sort county
by county: egen numbert = count(county)
by county: egen numberu = count(county) if urban 
by county: egen numberr = count(county) if urban ==0
tabstat numbert  , stat(mean median max min sd n) 
tabstat numberu  , stat(mean median max min sd n)    
tabstat numberr  , stat(mean median max min sd n) 


///CGSS 2006 data
clear
set more off
use "\\file\UsersW$\wrr15\Home\My Documents\My Files\XINDONG XUE\ECONOMICS E-JOURNAL (Revision)\DATA AND PROGRAMS\data2006b.dta", clear
//merge with county identifier
sort serial 
merge serial using "\\file\UsersW$\wrr15\Home\My Documents\My Files\XINDONG XUE\ECONOMICS E-JOURNAL (Revision)\DATA AND PROGRAMS\county 2006.dta"
drop _merge 


//generate county-mean social network
sort county 
by county: egen murbsn = mean(stdurbsn) if urban 
by county: egen mrursn = mean(stdrursn) if urban ==0
gen msn = murbsn if urban 
replace msn = mrursn if urban==0

//generate the index of the freedom in the workplace
mvencode qc2* , mv(.= 0) override
recode qc24* (1=0) (0=1)
recode qc21 (9=0)
recode qc22 (4=0) (1=4)
recode qc23 (6=0) (7=0)
gen discretion =  qc21+ qc22+ qc23+ qc241+ qc242+ qc243+ qc244                  //an index of the freedom in the workplace, including questions like "Can you freely speak different opinions to you leader?". the higher the index the more freedom


//generate the index of to what extent the interviewee's end-year bonus is determined by his position in workplace
gen position = quc325

//Generate per capita income and Gini coefficnet 
recode qd10b* (2=1) (.=0)
gen hsize = qd10b01+ qd10b02+ qd10b03+ qd10b04+ qd10b05+ qd10b06+ qd10b07+ qd10b08+ ///
qd10b09+ qd10b10+ qd10b11+ qd10b12+ qd10b13+ qd10b14+ qd10b15+ qd10b16    //generate household size
gen pinc = familyincome/hsize                                      // household average per capita income
drop if pinc==.
egen gini = inequal(pinc), by(county) weight(hsize) index(gini)    // gini by county for income*/
gen loginc = log(pinc)
gen loginc2 = loginc^2
by county: egen tincom = sum(familyincome)
by county: egen tsize = sum(hsize)
gen pincom = tincom/tsize                                           
gen lpincom = log(pincom)                                          //county average per capita income
gen lpincom2 = lpincom^2


//generate binary dependent variable
gen SRHH = SRH1
replace SRHH =[SRH1==3 | SRH1==4]
replace SRHH = 0 if SRH1==1 | SRH1==2


sort county
by county: egen numbert = count(county)
by county: egen numberu = count(county) if urban 
by county: egen numberr = count(county) if urban ==0
tabstat numbert  , stat(mean median max min sd n)    
tabstat numberu  , stat(mean median max min sd n)    
tabstat numberr  , stat(mean median max min sd n) 



	
	
	
