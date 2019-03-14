****************************************************************************
* File-Nale: 		arab0607.do
* Date:		 04/30/2018
* Author: 		Fred Batista
* Purpose: 		individual level analyses of knowledge
* Data used: 		arab0607.dta
* Data Output:	Journal of Politics’ paper	*/
****************************************************************************

*Variables:

*Sex - q702
*Country - country
*Urban/Rural -
*Age - q701; q701agecategories
*Religiosity - q714a
*Household Income - q715incomedeciles ; q716incomedeciles ; V715onlymorocco; V716onlymorocco
*Education - q703; q703dichotomous
*Media Access - 
*Media Exposure - q222 (internet access)
*Political Interest -
*Political Discussions: 
*Political Efficacy - q2511 (external); q5075 (internal)
*Marital Status - q709
*Housewife - q705
*Number of Children - 
*Political Knowledge - q2571 (foreign minister); q2572 (speaker/leader of parliament)
* Interviewers gender - 
*Sample Weight - 


*****************RECODING VARIABLES	

tab country, gen(country)

gen woman = q702 - 1

recode woman (98=.)

gen man = 2 - woman

gen age = q701agecategories

gen age_sq = age*age

gen education = q703 - 1

recode education (96=.)

gen income = q716incomedeciles

gen income_mor = V716onlymorocco

recode income_mor (10 100=.)

gen netexposure = 5 - q222

recode netexposure (-93 -94=.)

gen externaleff = 4 - q2511

recode externaleff (-94 -95=.)

gen internaleff =  q5075 - 1

recode internaleff (96 97 98=.)

gen married = q709

recode married (2=1) (1 3=0) (97 98=.)

gen woman_married = woman*married

gen housewife = q705

recode housewife (2=1) (1 3 4=0) (.=0) (97 99=.)

gen minister = q2571

gen speaker = q2572

recode minister speaker (1=1) (2 97 98=0) (99=.)

pwcorr minister speaker, sig

gen knowledge = (minister+speaker)*50

gen minister2 = q2571

gen speaker2 = q2572

recode minister2 speaker2 (1=2) (2=1) (98=0) (97 99=.)


******** ANALYSES

*** item analyses

* "discrimination"

sort country

by country: alpha minister speaker

** difficulty

by country: summarize minister speaker


*** Jordan

* minister

khb probit minister man || income education age age_sq netexposure internaleff externaleff housewife married if country==1

probit minister man income education age age_sq netexposure internaleff externaleff housewife married if country==1

mlogit minister2 woman income education age age_sq netexposure internaleff externaleff housewife married if country==1, base(2)

* speaker

khb probit speaker man || income education age age_sq netexposure internaleff externaleff housewife married if country==1

probit speaker man income education age age_sq netexposure internaleff externaleff housewife married if country==1

mlogit speaker2 woman income education age age_sq netexposure internaleff externaleff housewife married if country==1, base(2)



*** Palestine

* minister

khb probit minister man || income education age age_sq netexposure internaleff externaleff housewife married if country==2

probit minister man income education age age_sq  netexposure internaleff externaleff housewife married if country==2

mlogit minister2 woman income education age age_sq netexposure internaleff externaleff housewife married if country==2, base(2)


* speaker

khb probit speaker man || income education age age_sq netexposure internaleff externaleff housewife married if country==2

probit speaker man income education age age_sq netexposure internaleff externaleff housewife married if country==2

mlogit speaker2 woman income education age age_sq netexposure internaleff externaleff housewife married if country==2, base(2)


*** Algeria (income removed due to high missingness, no difference in estimation)

* minister

khb probit minister man || education age age_sq netexposure internaleff externaleff housewife married if country==3

probit minister man education age age_sq netexposure internaleff externaleff housewife married if country==3

mlogit minister2 woman education age age_sq netexposure internaleff externaleff housewife married if country==3, base(2)


* speaker

khb probit speaker man || education age age_sq netexposure internaleff externaleff housewife married if country==3

probit speaker man education age age_sq netexposure internaleff externaleff housewife married if country==3

mlogit speaker2 woman education age age_sq netexposure internaleff externaleff housewife married if country==3, base(2)



*** Morocco

* minister

khb probit minister man || income_mor education age age_sq netexposure internaleff externaleff housewife married if country==4

probit minister man income_mor education age age_sq netexposure internaleff externaleff housewife married if country==4

mlogit minister2 woman income education age age_sq netexposure internaleff externaleff housewife married if country==4, base(2)


* speaker

khb probit speaker man || income_mor education age age_sq netexposure internaleff externaleff housewife married if country==4

probit speaker man income_mor education age age_sq netexposure internaleff externaleff housewife married if country==4

mlogit speaker2 woman income education age age_sq netexposure internaleff externaleff housewife married if country==4, base(2)


*** Lebanon (income removed due to missingness, does not change main results)

* minister

khb probit minister man || education age age_sq netexposure internaleff externaleff housewife married if country==6

probit minister man education age age_sq netexposure internaleff externaleff housewife married if country==6

mlogit minister2 woman education age age_sq netexposure internaleff externaleff housewife married if country==6, base(2)


* speaker

khb probit speaker man || education age age_sq netexposure internaleff externaleff housewife married if country==6

probit speaker man education age age_sq netexposure internaleff externaleff housewife married if country==6

mlogit speaker2 woman education age age_sq netexposure internaleff externaleff housewife married if country==6, base(2)


*** Yemen (income removed; no change in main results)

* minister

khb probit minister man || education age age_sq netexposure internaleff externaleff housewife married if country==7

probit minister man education age age_sq netexposure internaleff externaleff housewife married if country==7

mlogit minister2 woman education age age_sq netexposure internaleff externaleff housewife married if country==7, base(2)


* speaker

khb probit speaker man || education age age_sq netexposure internaleff externaleff housewife married if country==7

probit speaker man education age age_sq netexposure internaleff externaleff housewife married if country==7

mlogit speaker2 woman education age age_sq netexposure internaleff externaleff housewife married if country==7, base(2)

