***********************************************************************
***********************************************************************
****  STATA REPLICATION CODE                                      *****
****  Title: "Mass Shootings and Public Support for Gun Control"  *****
****  Authors: Benjamin J. Newman and Todd K. Hartman             *****
****  Journal: British Journal of Political Science               *****
****  Version: April 2017  (Version 1)                            *****
***********************************************************************
***********************************************************************

** Install GLLAMM (if needed)
net from http://www.gllamm.org
net install gllamm, replace

***********************************************************************
**  2010 Cooperative Congressional Election Study (CCES) Analyses    **
**  hdl: 1902.1/17705 (with author-added contextual variables)       **
***********************************************************************
use "2010_CCES_with_Mass_Public_Shootings_and_Contextual_Variables.dta""

** Generate constant for multilevel models
gen cons = 1

*** Table 1: The Effect of Proximity to Mass Shootings on Preferences over Gun Control Policy
** Proximity to Nearest Mass Shooting
eq cons: cons
eq f1: e1_prox_01 medinc0711zip_01 pcollege0711zip_01 pblack0711zip_01 pmccain_01 murdcap08_01 gunstorepc10_01 popden0711zip_01 totpop0711zip_01 zip_st_totevents
gllamm guns education_01 incomei01 age male black latino asian ownhouse children military militaryfam partyid_01 ideology_01 relig01 south, i(zip) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)

** Average Proximity to TWO Nearest Mass Shootings
eq cons: cons
eq f1: e12_prox_01 medinc0711zip_01 pcollege0711zip_01 pblack0711zip_01 pmccain_01 murdcap08_01 gunstorepc10_01 popden0711zip_01 totpop0711zip_01 zip_st_totevents
gllamm guns education_01 incomei01 age male black latino asian ownhouse children military militaryfam partyid_01 ideology_01 relig01 south, i(zip) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)

** Average Proximity to THREE Nearest Mass Shootings
eq cons: cons
eq f1: e123_prox_01 medinc0711zip_01 pcollege0711zip_01 pblack0711zip_01 pmccain_01 murdcap08_01 gunstorepc10_01 popden0711zip_01 totpop0711zip_01 zip_st_totevents
gllamm guns education_01 incomei01 age male black latino asian ownhouse children military militaryfam partyid_01 ideology_01 relig01 south, i(zip) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)


*** Table 2: Preferences Over Treatment-Irrelevant Policy Issues (Placebo Tests)
** Climate Change 
eq cons: cons
eq f1: e1_prox_01 medinc0711zip_01 pcollege0711zip_01 pblack0711zip_01 pmccain_01 murdcap08_01 gunstorepc10_01 popden0711zip_01 totpop0711zip_01 zip_st_totevents
gllamm climate education_01 incomei01 age male black latino asian ownhouse children military militaryfam partyid_01 ideology_01 relig01 south, i(zip) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)

** Abortion
eq cons: cons
eq f1: e1_prox_01 medinc0711zip_01 pcollege0711zip_01 pblack0711zip_01 pmccain_01 murdcap08_01 gunstorepc10_01 popden0711zip_01 totpop0711zip_01 zip_st_totevents
gllamm abortion education_01 incomei01 age male black latino asian ownhouse children military militaryfam partyid_01 ideology_01 relig01 south, i(zip) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)

** Gay Marriage
xtlogit bangaymarry e1_prox_01 medinc0711zip_01 pcollege0711zip_01 pblack0711zip_01 murdcap08_01 gunstorepc10_01 zip_st_totevents pmccain_01 popden0711zip_01 totpop0711zip_01 education_01 incomei01 age male black latino asian ownhouse children military militaryfam partyid_01 ideology_01 relig01 south, i(zip)

** Immigration
xtlogit grantlegal e1_prox_01 medinc0711zip_01 pcollege0711zip_01 pblack0711zip_01 pmccain_01 murdcap08_01 gunstorepc10_01 popden0711zip_01 totpop0711zip_01 zip_st_totevents education_01 incomei01 age male black latino asian ownhouse children military militaryfam partyid_01 ideology_01 relig01 south, i(zip)


*** Table B1: Re-Estimation of Table 1 using three-level random-intercept model
gllamm guns e1_prox_01 medinc0711zip_01 pcollege0711zip_01 pblack0711zip_01 popden0711zip_01 totpop0711zip_01 zip_st_totevents pmccain_01 murdcap08_01 gunstorepc10_01 education_01 incomei01 age male black latino asian ownhouse children military militaryfam partyid_01 ideology_01 relig01 south, i(zip fips) l(ologit)  f(binom) adapt nip(4)


*** Table B2: Testing the non-linear effect of proximity to mass shootings using a quadratic term 
eq cons: cons
eq f1: e1_prox_01 e1_prox_2 medinc0711zip_01 pcollege0711zip_01 pblack0711zip_01 pmccain_01 murdcap08_01 gunstorepc10_01 popden0711zip_01 totpop0711zip_01 zip_st_totevents
gllamm guns education_01 incomei01 age male black latino asian ownhouse children military militaryfam partyid_01 ideology_01 relig01 south, i(zip) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)


*** Table B3: Effect of proximity to mass shooting by whether respondent was alive (and not alive)
** Respondent was alive when shooting occurred
eq cons: cons
eq f1: e1_prox_01 medinc0711zip_01 pcollege0711zip_01 pblack0711zip_01 pmccain_01 murdcap08_01 gunstorepc10_01 popden0711zip_01 totpop0711zip_01 zip_st_totevents
gllamm guns education_01 incomei01 age male black latino asian ownhouse children military militaryfam partyid_01 ideology_01 relig01 south if alive==1, i(zip) l(ologit) f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)

** Respondent was not alive when shooting occurred
eq cons: cons
eq f1: e1_prox_01 medinc0711zip_01 pcollege0711zip_01 pblack0711zip_01 pmccain_01 murdcap08_01 gunstorepc10_01 popden0711zip_01 totpop0711zip_01 zip_st_totevents
gllamm guns education_01 incomei01 age male black latino asian ownhouse children military militaryfam partyid_01 ideology_01 relig01 south if alive==0, i(zip) l(ologit) f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)


*** Table B4: Effect of proximity to mass shooting controlling for time elapsed since shooting
** Time elapsed
eq cons: cons
eq f1: e1_prox_01 e1time_01 medinc0711zip_01 pcollege0711zip_01 pblack0711zip_01 pmccain_01 murdcap08_01 gunstorepc10_01 popden0711zip_01 totpop0711zip_01 zip_st_totevents
gllamm guns education_01 incomei01 age male black latino asian ownhouse children military militaryfam partyid_01 ideology_01 relig01 south, i(zip) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)


*** Table B5: Subsample analyses
** Number of victims: < 5 victims
eq cons: cons
eq f1: e1_prox_01 medinc0711zip_01 pcollege0711zip_01 pblack0711zip_01 pmccain_01 murdcap08_01 gunstorepc10_01 popden0711zip_01 totpop0711zip_01 zip_st_totevents
gllamm guns education_01 incomei01 age male black latino asian ownhouse children military militaryfam partyid_01 ideology_01 relig01 south if e1_totvictims<5, i(zip) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)

** Number of victims: > 8 victims
eq cons: cons
eq f1: e1_prox_01 medinc0711zip_01 pcollege0711zip_01 pblack0711zip_01 pmccain_01 murdcap08_01 gunstorepc10_01 popden0711zip_01 totpop0711zip_01 zip_st_totevents
gllamm guns education_01 incomei01 age male black latino asian ownhouse children military militaryfam partyid_01 ideology_01 relig01 south if e1_totvictims>8, i(zip) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)

** Number of victims: > 20 victims
eq cons: cons
eq f1: e1_prox_01 medinc0711zip_01 pcollege0711zip_01 pblack0711zip_01 pmccain_01 murdcap08_01 gunstorepc10_01 popden0711zip_01 totpop0711zip_01 zip_st_totevents
gllamm guns education_01 incomei01 age male black latino asian ownhouse children military militaryfam partyid_01 ideology_01 relig01 south if e1_totvictims>20, i(zip) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)

** Time elapsed: > 10 years
eq cons: cons
eq f1: e1_prox_01 medinc0711zip_01 pcollege0711zip_01 pblack0711zip_01 pmccain_01 murdcap08_01 gunstorepc10_01 popden0711zip_01 totpop0711zip_01 zip_st_totevents
gllamm guns education_01 incomei01 age male black latino asian ownhouse children military militaryfam partyid_01 ideology_01 relig01 south if e1time>10, i(zip) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)

** Time elapsed: > 20 years
eq cons: cons
eq f1: e1_prox_01 medinc0711zip_01 pcollege0711zip_01 pblack0711zip_01 pmccain_01 murdcap08_01 gunstorepc10_01 popden0711zip_01 totpop0711zip_01 zip_st_totevents
gllamm guns education_01 incomei01 age male black latino asian ownhouse children military militaryfam partyid_01 ideology_01 relig01 south if e1time>20, i(zip) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)

** Partisanship: Democrats only
eq cons: cons
eq f1: e1_prox_01 medinc0711zip_01 pcollege0711zip_01 pblack0711zip_01 pmccain_01 murdcap08_01 gunstorepc10_01 popden0711zip_01 totpop0711zip_01 zip_st_totevents
gllamm guns education_01 incomei01 age male black latino asian ownhouse children military militaryfam ideology_01 relig01 south if partyid<3, i(zip) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)

** Partisanship: Republicans only
eq cons: cons
eq f1: e1_prox_01 medinc0711zip_01 pcollege0711zip_01 pblack0711zip_01 pmccain_01 murdcap08_01 gunstorepc10_01 popden0711zip_01 totpop0711zip_01 zip_st_totevents
gllamm guns education_01 incomei01 age male black latino asian ownhouse children military militaryfam ideology_01 relig01 south if partyid>5, i(zip) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)


*** Table B6: Effect of proximity to mass shooting before 2000 by time at current address
** Time at address: < 10 years
eq cons: cons
eq f1: e1_prox_01 medinc0711zip_01 pcollege0711zip_01 pblack0711zip_01 pmccain_01 murdcap08_01 gunstorepc10_01 popden0711zip_01 totpop0711zip_01 zip_st_totevents
gllamm guns education_01 incomei01 age male black latino asian ownhouse children military militaryfam partyid_01 ideology_01 relig01 south if (e1time>10 & e1time!=.) & yrslivedadd<10, i(zip) l(ologit) f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)

** Time at address: > 10 years
eq cons: cons
eq f1: e1_prox_01 medinc0711zip_01 pcollege0711zip_01 pblack0711zip_01 pmccain_01 murdcap08_01 gunstorepc10_01 popden0711zip_01 totpop0711zip_01 zip_st_totevents
gllamm guns education_01 incomei01 age male black latino asian ownhouse children military militaryfam partyid_01 ideology_01 relig01 south if (e1time>10 & e1time!=.) & (yrslivedadd>10 & yrslivedadd!=.), i(zip) l(ologit) f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)


*** Table B7: Effect of proximity to mass shootings before 1990 by population size and density
** Population size: Below median
eq cons: cons
eq f1: e1_prox_01 medinc0711zip_01 pcollege0711zip_01 pblack0711zip_01 pmccain_01 murdcap08_01 gunstorepc10_01 zip_st_totevents
gllamm guns education_01 incomei01 age male black latino asian ownhouse children military militaryfam partyid_01 ideology_01 relig01 south if (e1time>20 & e1tim!=.) & totpop0711zip<26864, i(zip) l(ologit) f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)

** Population size: Above median
eq cons: cons
eq f1: e1_prox_01 medinc0711zip_01 pcollege0711zip_01 pblack0711zip_01 pmccain_01 murdcap08_01 gunstorepc10_01 zip_st_totevents
gllamm guns education_01 incomei01 age male black latino asian ownhouse children military militaryfam partyid_01 ideology_01 relig01 south if (e1time>20 & e1time!=.) & (totpop0711zip>26864 & totpop0711zip!=.), i(zip) l(ologit) f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)

** Population density: Below median
eq cons: cons
eq f1: e1_prox_01 medinc0711zip_01 pcollege0711zip_01 pblack0711zip_01 pmccain_01 murdcap08_01 gunstorepc10_01 zip_st_totevents
gllamm guns education_01 incomei01 age male black latino asian ownhouse children military militaryfam partyid_01 ideology_01 relig01 south if (e1time>20 & e1time!=.) & popden0711zip<1339.482, i(zip) l(ologit) f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)

** Population density: Above mediam
eq cons: cons
eq f1: e1_prox_01 medinc0711zip_01 pcollege0711zip_01 pblack0711zip_01 pmccain_01 murdcap08_01 gunstorepc10_01 zip_st_totevents
gllamm guns education_01 incomei01 age male black latino asian ownhouse children military militaryfam partyid_01 ideology_01 relig01 south if (e1time>20 & e1time!=.) & (popden0711zip>1339.482 & popden0711zip!=.), i(zip) l(ologit) f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)



***********************************************************************
**  2010-2012 CCES Panel Study Analyses                              **
**  doi:10.7910/DVN/TOE8I1 (with author-added contextual variables)  **
***********************************************************************
use "2010-2012_CCES with_Mass_Public_Shootings_and_Contexual_Variables.dta"

** Generate constant for multilevel models
gen cons = 1

*** Table 3: Panel data, where treatment = mass shooting
eq cons: cons
eq f1: medinc0711zip_01 pcollege0711zip_01 pblack0711zip_01 murdcap08_01 gunstorespc10_01 pmccain_01 popden0711zip_01 totpop0711zip_01
gllamm guns12 guns10 treat10_12_2 educ10_01 income10i_01 age10 male partyid3_10 ideology10_01 black latino asian ownhouse10 children10 military10 militaryfam10 pray10_01 south if sameres==1, i(zip) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)


*** Table B8: Re-Estimation of results in Table 3 using dynamic dependent variable model
eq cons: cons
eq f1: medinc0711zip_01 pcollege0711zip_01 pblack0711zip_01 murdcap08_01 gunstorespc10_01 pmccain_01 popden0711zip_01 totpop0711zip_01 zip_st_totevents
gllamm d_guns1012 treat10_12_2 educ10_01 income10i_01 age10 male partyid3_10 ideology10_01 black latino asian ownhouse10 children10 military10 militaryfam10 pray10_01 south if sameres==1, i(zip) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)


*** Table B9: Placebo test of impact of treatment on pre-treatment (2010) gun control attitudes
eq cons: cons
eq f1: medinc0711zip_01 pcollege0711zip_01 pblack0711zip_01 murdcap08_01 gunstorespc10_01 pmccain_01 popden0711zip_01 totpop0711zip_01 zip_st_totevents
gllamm guns10 treat10_12_2 educ10_01 income10i_01 age10 male partyid3_10 ideology10_01 black latino asian ownhouse10 children10 military10 militaryfam10 pray10_01 south, i(zip) l(ologit)  f(binom) nrf(1) eqs(cons) geqs(f1) adapt nip(4)



***********************************************************************
**  2010 Pew Political Independents Survey Analyses                  **
**  (with author-added contextual variables)                         **
***********************************************************************
use "2010_Pew_Survey_with_Mass_Public_Shootings_and_Contextual_Variables.dta"

*** Table 4: Effect of proximity to mass shootings on chosen trade-Off between gun rights vs. gun control
xtlogit guns e1_prox_01 medinc0711zip_01 pcollege0711zip_01 pblack0711zip_01 totpop0711zip_01 popden0711zip_01 gunspc10_01 pmccain_01 murdpc08_01 zip_st_totevents education_01 incomei_01 r_age male black hispanic asian children partyid_01 ideology_01 religattend_01 south, i(zip)
xtlogit guns e12_prox_01 medinc0711zip_01 pcollege0711zip_01 pblack0711zip_01 totpop0711zip_01 popden0711zip_01 gunspc10_01 pmccain_01 murdpc08_01 zip_st_totevents education_01 incomei_01 r_age male black hispanic asian children partyid_01 ideology_01 religattend_01 south, i(zip)
xtlogit guns e123_prox_01 medinc0711zip_01 pcollege0711zip_01 pblack0711zip_01 totpop0711zip_01 popden0711zip_01 gunspc10_01 pmccain_01 murdpc08_01 zip_st_totevents education_01 incomei_01 r_age male black hispanic asian children partyid_01 ideology_01 religattend_01 south, i(zip)


*** Table B10: Subsample analyses
** Number of victims: < 5 victims
xtlogit guns e1_prox_01 medinc0711zip_01 pcollege0711zip_01 pblack0711zip_01 totpop0711zip_01 popden0711zip_01 gunspc10_01 pmccain_01 murdpc08_01 zip_st_totevents education_01 incomei_01 r_age male black hispanic asian children partyid_01 ideology_01 religattend_01 south if e1_totvictims < 5, i(zip)

** Number of victims: > 8 victims
xtlogit guns e1_prox_01 medinc0711zip_01 pcollege0711zip_01 pblack0711zip_01 totpop0711zip_01 popden0711zip_01 gunspc10_01 pmccain_01 murdpc08_01 zip_st_totevents education_01 incomei_01 r_age male black hispanic asian children partyid_01 ideology_01 religattend_01 south if (e1_totvictims > 8  & e1_totvictims !=.), i(zip)

** Number of victims: > 20 victims
xtlogit guns e1_prox_01 medinc0711zip_01 pcollege0711zip_01 pblack0711zip_01 totpop0711zip_01 popden0711zip_01 gunspc10_01 pmccain_01 murdpc08_01 zip_st_totevents education_01 incomei_01 r_age male black hispanic asian children partyid_01 ideology_01 religattend_01 south if (e1_totvictims > 20  & e1_totvictims !=.), i(zip)

** Time elapsed: > 10 years
xtlogit guns e1_prox_01 medinc0711zip_01 pcollege0711zip_01 pblack0711zip_01 totpop0711zip_01 popden0711zip_01 gunspc10_01 pmccain_01 murdpc08_01 zip_st_totevents education_01 incomei_01 r_age male black hispanic asian children partyid_01 ideology_01 religattend_01 south if (e1time > 10  & e1time !=.), i(zip)

** Time elapsed: > 20 years
xtlogit guns e1_prox_01 medinc0711zip_01 pcollege0711zip_01 pblack0711zip_01 totpop0711zip_01 popden0711zip_01 gunspc10_01 pmccain_01 murdpc08_01 zip_st_totevents education_01 incomei_01 r_age male black hispanic asian children partyid_01 ideology_01 religattend_01 south if (e1time > 20  & e1time !=.), i(zip)

** Partisanship: Democrats only
xtlogit guns e1_prox_01 medinc0711zip_01 pcollege0711zip_01 pblack0711zip_01 totpop0711zip_01 popden0711zip_01 gunspc10_01 pmccain_01 murdpc08_01 zip_st_totevents education_01 incomei_01 r_age male black hispanic asian children ideology_01 religattend_01 south if partyid < 3, i(zip)

** Partisanship: Republicans only
xtlogit guns e1_prox_01 medinc0711zip_01 pcollege0711zip_01 pblack0711zip_01 totpop0711zip_01 popden0711zip_01 gunspc10_01 pmccain_01 murdpc08_01 zip_st_totevents education_01 incomei_01 r_age male black hispanic asian children ideology_01 religattend_01 south if (partyid > 3  & partyid !=.), i(zip)












