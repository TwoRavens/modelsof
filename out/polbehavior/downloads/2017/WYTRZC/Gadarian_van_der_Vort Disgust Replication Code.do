

*ANES 1993 pilot study
http://electionstudies.org/studypages/1993pilot/1993pilot.htm

rename V924201 female	 
rename V923008 sampleweight
rename V937347 disgusting_summary
rename V937370 PID_7
rename V937327 job_discrim
rename V937331 open_service
rename V937335 adoption_93
rename V937145 FT_gays	 
rename V925924 discrimstrong_92
rename V925926 servicestrong_92
rename V925928 adoptstrong_92
rename V923513 ideology_92
rename V937204 ideology_93
rename V937207 ideofollowup_93
rename V926115 worldchanging_92
rename V926116 tolerant_92
rename V926117 familyties_92
rename V926118 lifestyles_92
rename V923903 age_92

/*Recoding in the antigay direction; higher codes mean a less positive attitude toward gays*/ 
	 
recode disgusting_summary (0=.) (2=.75) (4=.25) (5=0) (7/8=.)
label define disgust 0 "Not uncomfor or disgusted" 1 "Strongly disgusted"
label values disgusting_summary disgust
	 
recode PID_7 (8=4) (9=.)
replace PID_7 = PID_7/6
label define pid 0 "Strong Dem" 1 "Strong Rep" 
label values PID_7 pid	

recode female (1=0) (2=1)
label define female 0 "0. Male" 1 "1. Female"
label values female female 

/*If respondents refused to give ideology, asked a followup question, placing liberals in the followup question at 2 on the 7 point scale, moderates at 4, conservatives at 6, putting those who refused to pick at 4*/
gen Ideology93 = ideology_93
replace Ideology93 = 2 if ideology_93==0 & ideofollowup_93==1
replace Ideology93 = 4 if ideology_93==0 & ideofollowup_93==3
replace Ideology93 = 4 if ideology_93==0 & ideofollowup_93==7 
replace Ideology93 = 4 if ideology_93==0 & ideofollowup_93==8
replace Ideology93 = 6 if ideology_93==0 & ideofollowup_93==5
replace Ideology93= 4 if ideology_93==8
replace Ideology93=. if ideology_93==9
replace Ideology93 = (Ideology93-1)/6
label define ideology 0 "Very liberal" 1 "Very conservative"
label values Ideology93 ideology

/*Coding so that higher values are more pro-gay rights*/
/* Question is about protections against job discrimination*/ 
recode job_discrim (0=.) (2=.75) (4=.25) (5=0) (7/8=.)
label define favor 0 "Oppose strongly" 1 "Favor strongly" 
label values job_discrim  favor

/*Should gays be allowed to serve (doesn't actually ask about open service just general*/ 
recode open_service (0=.) (2=.75) (4=.25) (5=0) (7/8=.)
label values open_service favor

recode adoption_93 (0=.) (2=.75) (4=.25) (5=0) (7/8=.)
label values adoption_93 favor

recode FT_gays (997=.)	(998=.) (999=.)

/*Moral traditionalism - scaled so that higher values indicate more traditional views*/
recode worldchanging_92 tolerant_92 (5=1) (4=.75) (3=.5) (2=.25) (1=0) (8=.5) (9=.)
recode familyties_92 lifestyles_92 (2=.75) (3=.5) (4=.25) (5=0) (8=.5) (9=.)
label define agree 1 "Agree strongly" 0 "Disagree strongly"
label values worldchanging_92 tolerant_92 familyties_92 lifestyles_92 agree
alpha worldchanging_92 tolerant_92 familyties_92 lifestyles_92, gen(moraltrad)


/*1992 questions about gay rights - same policies, coded so that higher values more pro-rights*/
recode adoptstrong_92 (0=.) (2=.75) (4=.25) (5=0) (8=.) (9=.)
recode servicestrong_92 (0=.) (2=.75) (4=.25) (5=0) (8=.) (9=.)
recode discrimstrong_92 (0=.) (2=.75) (4=.25) (5=0) (8=.) (9=.)
label values adoptstrong_92 servicestrong_92 discrimstrong_92 favor


/*Relationships between disgust and policy*/
regress FT_gays disgust PID_7 Ideology93 female moraltrad [pweight=sampleweight]
regress adoption_93 adoptstrong_92 disgust PID_7 Ideology93 female moraltrad [pweight=sampleweight]
regress open_service servicestrong_92 disgust PID_7 Ideology93 female moraltrad [pweight=sampleweight]	
regress job_discrim discrimstrong_92 disgust PID_7 Ideology female moraltrad [pweight=sampleweight]
	
/*Figure 1: Plotting the effect of disgust on these DVs while holding the others constant*/
regress FT_gays disgust PID_7 Ideology93 female moraltrad [pweight=sampleweight]
margins, at(disgusting_summary=(0(.1)1)) post
est store ft
coefplot ft, at ytitle(Feeling thermometer) xtitle(Level of disgust) recast(line) lwidth(*2) ciopts(recast(rline) lpattern(dash) scheme(s1color))

regress adoption_93 adoptstrong_92 disgust PID_7 Ideology93 female moraltrad [pweight=sampleweight]
margins, at(disgusting_summary=(0(.1)1)) post
est store adoption	
coefplot adoption, at ytitle(Support adoption) xtitle(Level of disgust) recast(line) lwidth(*2) ciopts(recast(rline) lpattern(dash) scheme(s1color))

regress open_service servicestrong_92 disgust PID_7 Ideology93 female moraltrad [pweight=sampleweight]	
margins, at(disgusting_summary=(0(.1)1)) post
est store openservice
coefplot openservice, at ytitle(Open service) xtitle(Level of disgust) recast(line) lwidth(*2) ciopts(recast(rline) lpattern(dash) scheme(s1color))

regress job_discrim discrimstrong_92 disgust PID_7 Ideology female moraltrad [pweight=sampleweight]
margins, at(disgusting_summary=(0(.1)1)) post
est store discrimination
coefplot discrimination, at ytitle(Job protections) xtitle(Level of disgust) recast(line) lwidth(*2) ciopts(recast(rline) lpattern(dash) scheme(s1color))

graph combine "Titles of graphs",  scheme(s1color)

*\Column 1 of Table 1 - Determinants of Disgust over time*\
*ANES 1993 data
regress disgust PID_7 Ideology93 female moraltrad age_92 [pweight=sampleweight]

******************************************************************************************
*\Study 1 - Bottom up disgust manipulation*\
use "C:\Study 1 Disgust Bottom Up Data.dta", clear

/*Recoding demographic variables*/

gen disgustcontrol = .
replace disgustcontrol = 0 if controltreat ==1
replace disgustcontrol=1 if disgusttreat==1
label define dc 0 "Control" 1 "Disgust"
label values disgustcontrol dc

/*PID*/
gen PID = .
replace PID = 1 if r_pid ==2 & r_strongpid ==1
replace PID = 2 if r_pid==2 & r_strongpid ==2
replace PID = 3 if r_pid==3 & r_leanerpid ==3
replace PID = 4 if r_pid ==3 & r_leanerpid==2
replace PID = 5 if r_pid==3 & r_leanerpid==1
replace PID = 6 if r_pid ==1 & r_strongpid==2
replace PID=7 if r_pid==1 & r_strongpid==1

replace PID = (PID-1)/6
label define PID 0 "Strong Dem" 1 "Strong Rep"
label values PID PID

/*Ideology*/
replace r_ideology = (r_ideology-1)/6
label define ideo 0 "Very liberal" 1 "Very conservative"
label values r_ideology ideo 

/*Gender and sexuality*/
gen female = .
replace female =0 if r_sex ==1
replace female =1 if r_sex == 2
label define female 0 "Male" 1 "Female"
label values female female

gen hetero = .
replace hetero = 0 if r_sexuality <3
replace hetero = 1 if r_sexuality ==3

/*Disgust sensitity*/
recode toilet flyswatter deadbody (1=0) (2=.25) (3=.5) (4=.75) (5=1)
label define agree  0 "Strongly disagree" 1 "Strongly agree", replace
label values toilet flyswatter deadbody agree

recode soda railroad cremated (1=0) (2=.25) (3=.5) (4=.75) (5=1)
label define disgust 0 "Not at all disgusting" 1 "Extremely disgusting", replace
label values soda railroad cremated disgust

alpha toilet flyswatter deadbody soda railroad cremated, gen(dss)

/*Moral traditionalism*/
recode trad_adjust trad_lifestyles trad_tolerant trad_familyvalue (5=0) (4=.25) (3=.5) (2=.75) 
label values trad_adjust trad_lifestyles trad_tolerant trad_familyvalue agree
alpha trad_adjust trad_lifestyles trad_tolerant trad_familyvalue, gen(moral_trad)
replace moral_trad = moral_trad +.5

/*Emotional reactions*/
alpha disgusted sickened, gen(Disgust)
alpha angry furious, gen(Angry)
alpha hopeful relieved enthused proud, gen(Enthusiasm)

*\Table 1 - Columns 2-7, Determinants of Disgust over time*\
regress Disgust female hetero PID r_ideo  r_age  moral_trad dss  if controltreat==1
regress Angry female hetero PID r_ideo  r_age  moral_trad dss if controltreat==1
regress Enthus female hetero PID r_ideo  r_age  moral_trad dss if controltreat==1
regress Disgust female hetero PID r_ideo  r_age  moral_trad dss disgusttreat 
regress Angry female hetero PID r_ideo  r_age  moral_trad dss disgusttreat 
regress Enthus female hetero PID r_ideo  r_age  moral_trad dss disgusttreat 

****************************************************************************
*\Study 2 - Disgust rhetoric*\
use "C:\Study 2 lgbt rights.dta", clear

*\Disgust Sensitivity Scale*\
recode monkey_meat-hotel (1=0) (2=.25) (3=.5) (4=.75) (5=1)
label define agree 0 "Strongly disagree" 1 "Strongly agree" 
label values monkey_meat-hotel agree 

recode intestines-ice_cream (1=0) (2=.25) (3=.5) (4=.75) (5=1)
label define disgust 0 "Not at all disgusting" 1 "Extremely disgusting" 
label values intestines-ice_cream disgust 

alpha monkey_meat-hotel intestines-ice_cream, gen(dss)
replace dss = dss+ .15

*\Experimental treatment*\ 
replace disgust_treat = 0 if disgust_treat==.
replace positive_treat = 0 if positive_treat==.
replace neutral_treat = 0 if neutral_treat==.

gen treat = .
replace treat = 1 if positive_treat == 1
replace treat = 2 if neutral_treat == 1
replace treat = 3 if disgust_treat == 1
label define treat 1 "Positive" 2 "Neutral" 3 "Disgust"
label values treat treat

*\Emotion - rescaling from 0 to 1 with higher values more emotional*\
replace worried = (worried-1)/8
replace disgusted = (disgusted-1)/8
replace angry = (angry-1)/8
replace sad = (sad-1)/8
replace hopeful = (hopeful-1)/8
replace relieved = (relieved-1)/8
replace sickened = (sickened-1)/8

alpha disgusted sickened, gen(Disgust)

*\Policy attitudes*\
label define indiana 1 "Constitutional amend to ban ssm" 2 "Legalize ssm" 3 "Keep ssm ban"
label values ssm indiana

gen ssm_support = .
replace ssm_support = 1 if ssm ==2
replace ssm_support = 0 if ssm == 3
replace ssm_support = -1 if ssm==1

gen ssm_amend = .
replace ssm_amend = 1 if ssm == 1
replace ssm_amend = 0 if ssm > 1

recode military-hate_crime (1=0) (2=.25) (3=.5) (4=.75) (5=1)
label values military-hate_crime agree

recode job_discrim-aids_spending (1=0) (2=.25) (3=.5) (4=.75) (5=1)
label values job_discrim-immigration agree

label define spending 0 "Decrease greatly" 1 "Increase greatly"
label values aids_spending spending
*\Demographics*\
label define educ 1 "Less than HS" 2 "HS dip" 3 "Some college" 4 "2 yr degree" 5 "4 yr degree" 6 "MA" 7 "PhD other"
label values education educ 

label define sexuality 1 "Homosexual" 2 "Bisexual" 3 "Heterosexual"
label values sexuality sexuality


label define marriage 1 "Married" 2 "Widowed" 3 "Divorced" 4 "Separated" 5 "Relationship" 6 "Single"
label values marital marriage

label define religion 1 "Protestant" 2 "Catholic" 3 "Other Christian" 4 "Jewish" 5 "Muslim" 6 "Other religion" 7 "None" 
label values religion religion

label define born_again 1 "Yes" 2 "No"
label values born_again born_again

gen bornagain_Christian = .
replace bornagain_Christian = 0 if religion > 3
replace bornagain_Christian = 0 if religion <= 3 & born_again==2
replace bornagain_Christian = 1 if religion <=3 & born_again==1


replace ideology = (ideology-1)/6
label define ideology 0 "Very liberal" 1 "Very conservative"
label values ideology ideology


*/5 point PID b/c not enough info about independents
gen PID = .
replace PID = 1 if pid == 2 & strong_pid == 1
replace PID = 2 if pid==2 & strong_pid ==2
replace PID = 3 if pid==3
replace PID = 4 if pid==1 & strong_pid==2
replace PID = 5 if pid==1 & strong_pid==1

replace PID = (PID-1)/4
label define pid 0 "Strong Dem" 1 "Strong Rep"
label values PID pid


*\Table 4 - Determinants of Disgust and Anger*\
regress Disgust dss disgust_treat positive_treat
regress Disgust dss disgust_treat positive_treat female educ bornagain_Christian PID ideology
regress angry dss disgust_treat positive_treat
regress angry dss disgust_treat positive_treat female educ bornagain PID ideology

*\Table 5 - Mediation of policy by emotions*\
*/Mediation models - can add other independent vars later
medeff (regress Disgust disgust_treat positive_treat dss) (regress insurance disgust_treat positive_treat Disgust angry PID ideology), treat(disgust_treat) mediate (Disgust) sims(600)
medeff(regress Disgust disgust_treat positive_treat dss) (regress ssm_support disgust_treat positive_treat Disgust angry PID ideology), treat(disgust_treat) mediate (Disgust) sims(600)
medeff (regress Disgust disgust_treat positive_treat dss) (regress adoption disgust_treat positive_treat Disgust angry PID ideology), treat(disgust_treat) mediate (Disgust) sims(600)
medeff (regress Disgust disgust_treat positive_treat dss) (regress marriage disgust_treat positive_treat Disgust angry PID ideology), treat(disgust_treat) mediate (Disgust) sims(600)
medeff (regress Disgust disgust_treat positive_treat dss) (regress gay_pres disgust_treat positive_treat Disgust angry PID ideology), treat(disgust_treat) mediate (Disgust) sims(600)
medeff (regress Disgust disgust_treat positive_treat dss) (regress hate_crime disgust_treat positive_treat Disgust angry PID ideology), treat(disgust_treat) mediate (Disgust) sims(600)
medeff (regress Disgust disgust_treat positive_treat dss) (regress job_discrim disgust_treat positive_treat Disgust angry PID ideology), treat(disgust_treat) mediate (Disgust) sims(600)
medeff(regress Disgust disgust_treat positive_treat dss) (regress immigration disgust_treat positive_treat Disgust angry PID ideology), treat(disgust_treat) mediate (Disgust) sims(600)
medeff (regress Disgust disgust_treat positive_treat dss) (regress aids_spending disgust_treat positive_treat Disgust angry PID ideology), treat(disgust_treat) mediate (Disgust) sims(600)

*/Mediation by anger
medeff (regress angry disgust_treat positive_treat dss) (regress insurance disgust_treat positive_treat angry Disgust PID ideology), treat(disgust_treat) mediate (angry) sims(600)
medeff (regress angry disgust_treat positive_treat dss) (regress ssm_support disgust_treat positive_treat angry Disgust PID ideology), treat(disgust_treat) mediate (angry) sims(600)
medeff (regress angry disgust_treat positive_treat dss) (regress adoption disgust_treat positive_treat angry Disgust PID ideology), treat(disgust_treat) mediate (angry) sims(600)
medeff (regress angry disgust_treat positive_treat dss) (regress marriage disgust_treat positive_treat angry Disgust PID ideology), treat(disgust_treat) mediate (angry) sims(600)
medeff (regress angry disgust_treat positive_treat dss) (regress gay_pres disgust_treat positive_treat angry Disgust PID ideology), treat(disgust_treat) mediate (angry) sims(600)
medeff (regress angry disgust_treat positive_treat dss) (regress hate_crime disgust_treat positive_treat angry Disgust PID ideology), treat(disgust_treat) mediate (angry) sims(600)
medeff (regress angry disgust_treat positive_treat dss) (regress job_discrim disgust_treat positive_treat angry Disgust PID ideology), treat(disgust_treat) mediate (angry) sims(600)
medeff (regress angry disgust_treat positive_treat dss) (regress immigration disgust_treat positive_treat angry Disgust PID ideology), treat(disgust_treat) mediate (angry) sims(600)
medeff (regress angry disgust_treat positive_treat dss) (regress aids_spending disgust_treat positive_treat angry Disgust PID ideology), treat(disgust_treat) mediate (angry) sims(600)

