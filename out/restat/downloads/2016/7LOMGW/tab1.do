

********************************************************************************************************
*THIS DO-FILE REPLICATES TABLES 1 IN:                                                  			   
* PATRICIA FUNK: 							                       	
* "HOW ACCURATE ARE SURVEYED PREFERENCES FOR PUBLIC POLICIES? EVIDENCE FROM
* A UNIQUE INSTITUTIONAL SETUP"                                                                                         
********************************************************************************************************


global data ="[your path]"

clear all
set more off
set matsize 2000

use "$data\PUS", clear 

rename zjhr year
rename altj agegroup
rename gesl gender
rename konf religion
rename spr93 language


***step 1: drop respondents younger than 20; keep swiss citizens
drop if agegroup<5

*Share Women (1 male; 2 female):

count if gender==2 & year==1990 
gen fem1990=r(N)
count if gender==1 & year==1990 
gen male1990=r(N)
gen PUSshare_women1990=(fem1990/(fem1990+male1990))


count if gender==2 & year==2000 
gen fem2000=r(N)
count if gender==1 & year==2000 
gen male2000=r(N)
gen PUSshare_women2000=(fem2000/(fem2000+male2000))


*Share Protestants (1 protestant):
count if religion==1 & year==1990 
gen prot1990=r(N)
count if  year==1990 
gen tot1990=r(N)
gen PUSshare_prot1990=(prot1990/tot1990)


count if religion==1 & year==2000 
gen prot2000=r(N)
count if  year==2000 
gen tot2000=r(N)
gen PUSshare_prot2000=(prot2000/tot2000)


*Share Caths (2 catholic):
count if religion==2 & year==1990 
gen cath1990=r(N)
gen PUSshare_cath1990=(cath1990/tot1990)

count if religion==2 & year==2000 
gen cath2000=r(N)
gen PUSshare_cath2000=(cath2000/tot2000)


*Age 20-39
count if agegroup<9 & year==1990 
gen age_2039_1990=r(N)
gen PUSshare_2039_1990=(age_2039_1990/tot1990)

count if agegroup<9 & year==2000 
gen age_2039_2000=r(N)
gen PUSshare_2039_2000=(age_2039_2000/tot2000)


*Age 40-59
count if agegroup<13 &  agegroup>=9 & year==1990 
gen age_4059_1990=r(N)
gen PUSshare_4059_1990=(age_4059_1990/tot1990)

count if agegroup<13 &  agegroup>=9 & year==2000 
gen age_4059_2000=r(N)
gen PUSshare_4059_2000=(age_4059_2000/tot2000)


*Age 60plus
count if agegroup>12 & year==1990 
gen age_60plus_1990=r(N)
gen PUSshare_60plus_1990=(age_60plus_1990/tot1990)

count if agegroup>12 & year==2000
gen age_60plus_2000=r(N)
gen PUSshare_60plus_2000=(age_60plus_2000/tot2000)


*German speaking
count if language==1 & year==1990 
gen german_1990=r(N)
gen PUSshare_ger_1990=(german_1990/tot1990)

count if language==1 & year==2000 
gen german_2000=r(N)
gen PUSshare_ger_2000=(german_2000/tot2000)


*French Speaking
count if language==2 & year==1990 
gen french_1990=r(N)
gen PUSshare_french_1990=(french_1990/tot1990)

count if language==2 & year==2000 
gen french_2000=r(N)
gen PUSshare_french_2000=(french_2000/tot2000)


*Italian speaking
count if language==3 & year==1990 
gen it_1990=r(N)
gen PUSshare_it_1990=(it_1990/tot1990)

count if language==3 & year==2000 
gen it_2000=r(N)
gen PUSshare_it_2000=(it_2000/tot2000)



#delimit;
keep PUSshare_women1990 PUSshare_women2000 PUSshare_prot1990 PUSshare_prot2000 PUSshare_cath1990 PUSshare_cath2000 PUSshare_2039_1990 PUSshare_2039_2000 
PUSshare_4059_1990 PUSshare_4059_2000 PUSshare_60plus_1990 PUSshare_60plus_2000 PUSshare_ger_1990 PUSshare_ger_2000 PUSshare_french_1990 PUSshare_french_2000 PUSshare_it_1990 PUSshare_it_2000;

#delimit cr

duplicates drop

summarize



use "$data\VOX_prepared", clear 

*Share Women (1 male; 2 female):
count if gender==2 &  year==1990 & age>19
gen fem1990=r(N)
count if gender==1 &  year==1990 & age>19
gen male1990=r(N)
gen share_women1990=(fem1990/(fem1990+male1990))


count if gender==2 &  year==2000 & age>19
gen fem2000=r(N)
count if gender==1 &  year==2000 & age>19
gen male2000=r(N)
gen share_women2000=(fem2000/(fem2000+male2000))

*Share Protestants (1 protestant):

count if religion==1 &  year==1990 & age>19
gen prot1990=r(N)
count if  year==1990 & age>19
gen tot1990=r(N)
gen share_prot1990=(prot1990/tot1990)

count if religion==1 &  year==2000 & age>19
gen prot2000=r(N)
count if  year==2000 & age>19
gen tot2000=r(N)
gen share_prot2000=(prot2000/tot2000)

*Share Catholics (2 catholic):

count if religion==2 &  year==1990 & age>19
gen cath1990=r(N)
gen share_cath1990=(cath1990/tot1990)

count if religion==2 &  year==2000 & age>19
gen cath2000=r(N)
gen share_cath2000=(prot2000/tot2000)


*Age 20-39
count if age>19 & age<40 & year==1990 
gen age_2039_1990=r(N)
gen share_2039_1990=(age_2039_1990/tot1990)

count if age>19 & age<40 & year==2000 
gen age_2039_2000=r(N)
gen share_2039_2000=(age_2039_2000/tot2000)


*Age 40-59
count if  year==1990 & age>39 & age<60
gen age_4059_1990=r(N)
gen share_4059_1990=(age_4059_1990/tot1990)

count if  year==2000 & age>39 & age<60
gen age_4059_2000=r(N)
gen share_4059_2000=(age_4059_2000/tot2000)

*Age 60plus
count if  year==1990 & age>59
gen age_60plus_1990=r(N)
gen share_60plus_1990=(age_60plus_1990/tot1990)

count if  year==2000 & age>59
gen age_60plus_2000=r(N)
gen share_60plus_2000=(age_60plus_2000/tot2000)

*German
count if language==1 &  year==1990 & age>19
gen german_1990=r(N)
gen share_ger_1990=(german_1990/tot1990)

count if language==1 &  year==2000 & age>19
gen german_2000=r(N)
gen share_ger_2000=(german_2000/tot2000)

*French
count if language==2 & year==1990  & age>19 
gen french_1990=r(N)
gen share_french_1990=(french_1990/tot1990)

count if language==2 & year==2000  & age>19 
gen french_2000=r(N)
gen share_french_2000=(french_2000/tot2000)

*Italian
count if language==3 & year==1990 & age>19
gen it_1990=r(N)
gen share_it_1990=(it_1990/tot1990)

count if language==3 & year==2000 & age>19
gen it_2000=r(N)
gen share_it_2000=(it_2000/tot2000)



#delimit;
drop fem1990 male1990 fem2000 male2000 prot1990 tot1990 prot2000 tot2000 cath1990 cath2000 age_2039_1990 age_2039_2000 age_4059_1990 age_4059_2000 
age_60plus_1990 age_60plus_2000 german_1990 german_2000 french_1990 french_2000 it_1990 it_2000;

#delimit cr

sum share_women1990- share_it_2000

 
****T tests: use only one observation per survey respondent


preserve

bysort id: gen nrid=_n
drop if nrid>1

ttest female=0.5125371 if year==1990 
ttest female=0.5160894 if year==2000 

 ttest prot=0.4053055 if year==1990 
 ttest prot=0.3549941 if year==2000

  ttest cath=0.4573691 if year==1990 
 ttest cath=0.4196917 if year==2000

ttest age2039=0.419063 if year==1990 
ttest age2039=0.3805808 if year==2000 

ttest age4059=0.3324807 if year==1990 
ttest age4059=0.3584979 if year==2000

ttest age60plus=0.2484563 if year==1990 
ttest age60plus=0.2609214 if year==2000

ttest German=0.7181186 if year==1990 
ttest German=0.7149077 if year==2000

ttest French=0.2331058 if year==1990 
ttest French=0.2354663 if year==2000

ttest Italian=0.0487756 if year==1990 
ttest Italian=0.049626 if year==2000

ttest highedu=0.19 if year==1990 
ttest highedu=0.27 if year==2000


restore








