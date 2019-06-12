

*******************************************************************************************************************************
****** Replication code for "Community Size, Social Capital, and Political Participation in Latin America" *******************
******************************************************************************************************************************
*******************************************************************************************************************************

*** AUHTORS CONTACT: **********************************
* Miguel Carreras
* University of California, Riverside
* Department of Political Science
* miguel.carreras@ucr.edu

* Shaun Bowler
* University of California, Riverside
* Department of Political Science
* shaun.bowler@ucr.edu
******************************************************

***Generation of new variables before analysis***

tab size_resid, gen (size_res)
tab size_municipality, gen (size_mun)

gen age_cat=.
replace age_cat=1 if  age>=18 & age <=24
replace age_cat=2 if  age>24 & age<=34
replace age_cat=3 if  age>34 & age<=49
replace age_cat=4 if  age>49 & age<=64
replace age_cat=5 if  age>64
order age_cat, a (age)

gen attend_parties_dummy = attend_parties
recode attend_parties_dummy 1=0 2/4=1

gen attend_community_dummy = attend_community
recode attend_community_dummy 1=0 2/4=1

gen attend_religion_dummy = attend_religion
recode attend_religion_dummy 1/2=0 3/4=1

gen attend_church_dummy = attend_church
recode attend_church_dummy 1/2=0 3/5=1

gen high_interptrust = interp_trust1
recode high_interptrust 1/3=0 4=1

gen attend_prof_dummy = attend_professional
recode attend_prof_dummy 1=0 2/4=1

gen attend_parents_dummy = attend_parents
recode attend_parents_dummy 1=0 2/4=1


*** Figure 1: Graph differences in social cohesiveness ***

*Panel a*
graph bar attend_prof_dummy , over (size_resid)

*panel b*
graph bar attend_religion_dummy , over (size_resid)

*panel c*
graph bar help_neighborhood_labor, over (size_resid)

*panel d*
graph bar high_interptrust , over (size_resid)


***Drop data from before 2012 & after 2014***

drop if year_survey<2012
drop if year_survey>2014



***Age differences by community size***

***Figure A1***

histogram educ, percent by(size_resid)

***Figure A2***
histogram income_decile , percent by(size_resid)

***Figure A3***
graph bar victim_violence , over (size_resid)

***Figure A4***
graph bar fear_gangs , over (size_resid)



***Factor analysis to generate latent social capital indicator (Tables A1 and A2)***

factor help_neighborhood attend_community attend_professional attend_parents interp_trust1

factor help_neighborhood attend_community attend_professional attend_parents
rotate
predict social_capital


***Multilevel regressions of determinants of social capital (Table 3)***

xtmixed social_capital size_res2 size_res3 size_res4 size_res5 age_cat male married number_children income_decile educ empstatus religiosity victim_violence if year_survey==2012 || ccode: 

xtmixed interp_trust1 size_res2 size_res3 size_res4 size_res5 age_cat male married number_children income_decile educ empstatus religiosity victim_violence  || ccode: || year_survey: 


***Figure 2***
xtmixed social_capital i.size_resid age_cat male married number_children income_decile educ empstatus religiosity victim_violence if year_survey==2012 || ccode: 
margins size_resid
marginsplot

xtmixed interp_trust1 i.size_resid age_cat male married number_children income_decile educ empstatus religiosity victim_violence || ccode: || year_survey:  
margins size_resid
marginsplot


***Generate political activism scale***

gen pol_activism = attend_municipality + attend_parties_dummy + contact_local + contact_mp + contact_municipality + contact_ministry + petition


***Multilevel regressions of determinants of political engagement (Table 4)***

xtmelogit turnout size_res2 size_res3 size_res4 size_res5 age_cat male income_decile educ empstatus pol_int int_efficacy trust_inst1 victim_violence || ccode: || year_survey: 

xtmixed pol_activism size_res2 size_res3 size_res4 size_res5 age_cat male income_decile educ empstatus pol_int int_efficacy trust_inst1 victim_violence || ccode:

***Mediation analyses (Table 5)***

logit turnout size_resid age_cat male income_decile educ empstatus pol_int int_efficacy trust_inst1 victim_violence i.ccode if year_survey==2012
reg social_capital size_resid age_cat male income_decile educ empstatus pol_int int_efficacy trust_inst1 victim_violence i.ccode if year_survey==2012
logit turnout size_resid social_capital age_cat male income_decile educ empstatus pol_int int_efficacy trust_inst1 victim_violence i.ccode if year_survey==2012


reg pol_activism size_resid age_cat male income_decile educ empstatus pol_int int_efficacy trust_inst1 victim_violence i.ccode 
reg social_capital size_resid age_cat male income_decile educ empstatus pol_int int_efficacy trust_inst1 victim_violence i.ccode 
reg pol_activism size_resid social_capital age_cat male income_decile educ empstatus pol_int int_efficacy trust_inst1 victim_violence i.ccode 


***Generate country dummies***

tab ccode, gen (pais)

***Estimation of total effect being mediated***

binary_mediation, dv(turnout) iv(size_resid) mv(social_capital) cv(age_cat male income_decile educ empstatus pol_int int_efficacy trust_inst1 victim_violence pais1 pais2 pais3 pais4 pais5 pais6 pais7 pais8 pais9 pais10 pais11 pais12 pais14 pais15 pais16 pais17 pais18 pais19 pais20)

*Turnout model*

*Political activism model*

sem (social_capital <- size_resid  age_cat male income_decile educ empstatus pol_int int_efficacy trust_inst1 victim_violence pais1 pais2 pais3 pais4 pais5 pais6 pais7 pais8 pais9 pais10 pais11 pais12 pais14 pais15 pais16 pais17 pais18 pais19 pais20)( pol_activism <- social_capital size_resid age_cat male income_decile educ empstatus pol_int int_efficacy trust_inst1 victim_violence pais1 pais2 pais3 pais4 pais5 pais6 pais7 pais8 pais9 pais10 pais11 pais12 pais14 pais15 pais16 pais17 pais18 pais19 pais20)
estat teffects //total effect mediated is (-0.0386)/(-0.0914)=0.4231


***Multilevel structural equation models***

*turnout with direct and indirect path*
gsem (age -> turnout, family(bernoulli) link(probit)) (male -> turnout, family(bernoulli) link(probit)) (income_decile -> turnout, family(bernoulli) link(probit)) (educ -> turnout, family(bernoulli) link(probit)) (pol_int -> turnout, family(bernoulli) link(probit)) (size_resid -> turnout, family(bernoulli) link(probit)) (size_resid -> social_capital, ) (social_capital -> turnout, family(bernoulli) link(probit)) (Country[ccode] -> turnout, family(bernoulli) link(probit)) if year_survey==2012, covstruct(_lexogenous, diagonal) latent(Country ) nocapslatent

*turnout with direct path only*
gsem (age -> turnout, family(bernoulli) link(probit)) (male -> turnout, family(bernoulli) link(probit)) (income_decile -> turnout, family(bernoulli) link(probit)) (educ -> turnout, family(bernoulli) link(probit)) (pol_int -> turnout, family(bernoulli) link(probit)) (size_resid -> turnout, family(bernoulli) link(probit)) (Country[ccode] -> turnout, family(bernoulli) link(probit)), covstruct(_lexogenous, diagonal) latent(Country ) nocapslatent

*political activism with direct and indirect path*
gsem (age -> pol_activism, family(gaussian) link(identity)) (male -> pol_activism, family(gaussian) link(identity)) (income_decile -> pol_activism, family(gaussian) link(identity)) (educ -> pol_activism, family(gaussian) link(identity)) (pol_int -> pol_activism, family(gaussian) link(identity)) (size_resid -> pol_activism, family(gaussian) link(identity)) (size_resid -> social_capital, ) (social_capital -> pol_activism, family(gaussian) link(identity)) (Country[ccode] -> pol_activism, family(gaussian) link(identity)) if year_survey==2012, covstruct(_lexogenous, diagonal) latent(Country ) nocapslatent

*political activism with direct path only*
gsem (age -> pol_activism, family(gaussian) link(identity)) (male -> pol_activism, family(gaussian) link(identity)) (income_decile -> pol_activism, family(gaussian) link(identity)) (educ -> pol_activism, family(gaussian) link(identity)) (pol_int -> pol_activism, family(gaussian) link(identity)) (size_resid -> pol_activism, family(gaussian) link(identity)) (Country[ccode] -> pol_activism, family(gaussian) link(identity)) if year_survey==2012, covstruct(_lexogenous, diagonal) latent(Country ) nocapslatent


***Estimation of goodness-of-fit statistics***

*turnout with direct and indirect path*
gsem (age -> turnout, family(bernoulli) link(probit)) (male -> turnout, family(bernoulli) link(probit)) (income_decile -> turnout, family(bernoulli) link(probit)) (educ -> turnout, family(bernoulli) link(probit)) (pol_int -> turnout, family(bernoulli) link(probit)) (size_resid -> turnout, family(bernoulli) link(probit)) (size_resid -> social_capital, ) (social_capital -> turnout, family(bernoulli) link(probit)) (Country[ccode] -> turnout, family(bernoulli) link(probit)) if year_survey==2012, covstruct(_lexogenous, diagonal) latent(Country ) nocapslatent
estat ic //AIC=83560.96

*turnout with direct path only*
gsem (age -> turnout, family(bernoulli) link(probit)) (male -> turnout, family(bernoulli) link(probit)) (income_decile -> turnout, family(bernoulli) link(probit)) (educ -> turnout, family(bernoulli) link(probit)) (pol_int -> turnout, family(bernoulli) link(probit)) (size_resid -> turnout, family(bernoulli) link(probit)) (Country[ccode] -> turnout, family(bernoulli) link(probit)), covstruct(_lexogenous, diagonal) latent(Country ) nocapslatent
estat ic //AIC=47707.81

*political activism with direct and indirect path*
gsem (age -> pol_activism, family(gaussian) link(identity)) (male -> pol_activism, family(gaussian) link(identity)) (income_decile -> pol_activism, family(gaussian) link(identity)) (educ -> pol_activism, family(gaussian) link(identity)) (pol_int -> pol_activism, family(gaussian) link(identity)) (size_resid -> pol_activism, family(gaussian) link(identity)) (size_resid -> social_capital, ) (social_capital -> pol_activism, family(gaussian) link(identity)) (Country[ccode] -> pol_activism, family(gaussian) link(identity)), covstruct(_lexogenous, diagonal) latent(Country ) nocapslatent
estat ic //AIC=129948.6

*political activism with direct path only*
gsem (age -> pol_activism, family(gaussian) link(identity)) (male -> pol_activism, family(gaussian) link(identity)) (income_decile -> pol_activism, family(gaussian) link(identity)) (educ -> pol_activism, family(gaussian) link(identity)) (pol_int -> pol_activism, family(gaussian) link(identity)) (size_resid -> pol_activism, family(gaussian) link(identity)) (Country[ccode] -> pol_activism, family(gaussian) link(identity)), covstruct(_lexogenous, diagonal) latent(Country ) nocapslatent
estat ic //AIC=66289.88

