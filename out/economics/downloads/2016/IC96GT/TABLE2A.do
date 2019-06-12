// NOTE:  I have to run this program in two parts because the RURAL
// gologit2 program hangs when I run it after URBAN.  It "works" if I run it
// at the start of the program.  I put "works" in quotation marks because the 
// error var-cov matrix has something wrong with it.  This does not concern me 
// too much because all I care about is getting a starting point for determining 
// which variables belong in the variance component of the oglm model.  

// Furthermore, before running the second part of the program, STATA has to be
// shut down and restarted.  

clear
etime, start
log using "\\file\UsersW$\wrr15\Home\My Documents\My Files\XINDONG XUE\ECONOMICS E-JOURNAL (Revision)\DATA AND PROGRAMS\TABLE2A.log", replace
set more off
set scheme s2mono
set type double

///CGSS 2005 data
use "\\file\UsersW$\wrr15\Home\My Documents\My Files\XINDONG XUE\ECONOMICS E-JOURNAL (Revision)\DATA AND PROGRAMS/data2005b.dta" 
//merge with county identifier
sort serial 
merge serial using "\\file\UsersW$\wrr15\Home\My Documents\My Files\XINDONG XUE\ECONOMICS E-JOURNAL (Revision)\DATA AND PROGRAMS/county 2005.dta"
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


//We first estimate an ordered probit equation for URBAN with SC variables

// URBAN

oprobit SRH3 stdtrust stdsocial stdsp age female han partymember loginc  ///
midses highses unmarried divorced widowed primaryeduc junioreduc univeduc ///
gini lpincom if urban==1, cluster(county) 

test midses highses 
test unmarried divorced widowed 
test primaryeduc junioreduc univeduc 

gologit2 SRH3 stdtrust stdsocial stdsp age female han partymember loginc  ///
midses highses unmarried divorced widowed primaryeduc junioreduc univeduc gini ///
lpincom if urban==1, autofit cluster(county) link(probit)
/* The gologit2 results indicate that the variables (stdsocial stdsp age han loginc midses ///
unmarried gini) violate the parallel lines assumption. As a result, we move to ///
estimating this with oglm. */

oglm SRH3 stdtrust stdsocial stdsp age female han partymember loginc  ///
midses highses unmarried divorced widowed  primaryeduc junioreduc univeduc ///
gini lpincom if urban==1, hetero(stdsocial stdsp age han loginc midses unmarried ///
gini) link(probit) cluster(county)

// I reestimate the oglm model, dropping (stdsocial stdsp age and han) from the heteroskedastic
// component of the likelihood function since they are not significant there.
// This produced my final HO Probit model

// FINAL HO PROBIT MODEL 
// 2005 URBAN

oglm SRH3 stdtrust stdsocial stdsp age female han partymember loginc  ///
midses highses unmarried divorced widowed  primaryeduc junioreduc univeduc ///
gini lpincom if urban==1, hetero(loginc midses unmarried gini) link(probit) cluster(county)

test midses highses 
test unmarried divorced widowed 
test primaryeduc junioreduc univeduc 

etime

log close







	
	
	
