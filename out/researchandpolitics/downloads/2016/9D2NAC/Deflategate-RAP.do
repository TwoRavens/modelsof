clear
set more off

import delimited "SM.deflategate.NE.responses.JC092815.csv", encoding(ISO-8859-1)
tab region 
gen newenglandsample=1
save "Deflategate.NE.responses.dta", replace

clear
import delimited "SM.deflategate.non.NE.responses.JC092815.csv", encoding(ISO-8859-1)
tab region
gen newenglandsample=0
append using "Deflategate.NE.responses.dta"

/*drop empty variables*/
drop firstname lastname emailaddress

/*
Experimental Treatments
Respondents will be randomly assigned to one of three conditions - two primes or a control condition asking what the respondent eats for breakfast. The treatment conditions prime a particular consideration (defending group interests or special treatment of elites) and then ask respondents to describe a time when they experienced or observed a relevant behavior. Each statement begins with, "We would like to learn more about you." The text of the prompts are as follows:
 
-Control: "Every day, millions of Americans begin their day with breakfast.  Please tell us about what you generally eat to start the day and what you ate this morning."
-GroupSolidarity:  "There are times when people have to stand up for the interests of their community even when it's not easy to do so.  Please tell us about a case where you did something difficult because it was the right thing for your community."
-EliteResentment: "Some people would say that there are two kinds of people in America — the elites and everyone else — and that those who are already on top get opportunities not available to other people.  Please tell us about a time when you think someone who already had great wealth or power got special treatment."
 
Every respondent also receives the following additional statement:
- "NOTE: Your response to this question is very important. Please take your time to answer the question thoroughly. Don't worry about spelling, grammar, or how well written your answer is. Your answers will be kept confidential and not published in any form."
*/

rename treatment TREAT
encode TREAT, gen(treatment)
drop TREAT
label define treatmentLabel 1 "Breakfast" 2 "Group Solidarity" 3 "Elite Resentment"
label value treatment treatmentLabel

gen groupsolidarity=(treatment==2)
gen eliteresentment=(treatment==3)

/* Examining rate of non-response to treatment*/
gen treatrespond = 1
replace treatrespond = 0 if treatmentresponse==""
tab treatment treatrespond, row chi2

rename statereside stateRES
encode stateRES, gen(statereside)
drop stateRES

rename stateborn stateBORN
encode stateBORN, gen(stateborn)
drop stateBORN

rename bornus bornUSA
encode bornUSA, gen(bornus)
drop bornUSA

/*
Dependent Variables
Respondents will be asked to evaluate the accuracy of four statements reflecting purported conspiracies (that is, actions involving complicity by more than one person in pursuit of a goal that is not publicly acknowledged) related to the Deflategate controversy:
 
DeflategateConspiracy:
-BradyBrokeRules: "Tom Brady broke the NFL’s rules by directing team personnel to tamper with the footballs used in the playoffs last season."
-NoEvidence: "There’s no solid evidence that Tom Brady did anything wrong during the playoffs last season."
-PunishingBrady: "The NFL is trying to punish Tom Brady in order to distract people from the league’s other problems."
-RulingInfluence: "The judge’s ruling overturning Brady’s suspension has more to do with money and influence than with the facts of the case."
*/

rename bradybroke BB
encode BB, gen(bradybrokerules)
drop BB

rename noevidence NoE
encode NoE, gen(noevidence)
drop NoE

rename nfldistract NFLdist
encode NFLdist, gen(punishingbrady)
drop NFLdist

rename judgeinfluence Judge
encode Judge, gen(rulinginfluence)
drop Judge

/* Each response is provided on a four-point Likert scale from very accurate to not at all accurate. Responses will be recoded so that higher values indicate greater belief in an anti-Patriots conspiracy. */

*install this if you don't have it: findit labrecode
labrecode bradybroke (1=4) (4=1)(2=3)(3=2),nostrict
labrecode rulinginfluence (1=4) (4=1)(2=3)(3=2),nostrict

/*
If the scores for these questions load on a single dimension in a principal components factor analysis, we will take the mean of the four questions above where 4=the highest level of agreement in an anti-Patriots conspiracy and 1=the lowest level (reverse-coded as appropriate). If the questions used for our measures do not scale together, we may analyze responses to each question separately or in subscales (violations versus motive, questions presuming Brady’s guilt versus innocence, etc.).
*/

factor bradybroke noevidence punishingbrady rulinginfluence, pcf /*loads on one factor well*/
alpha bradybroke noevidence punishingbrady rulinginfluence, item gen(deflategateconspiracy) /*makes mean*/

rename tampercommon Tamper
encode Tamper, gen(tampercommon)
drop Tamper

/*
PatsFandom:
●	US state of birth (New England states of MA, CT, RI, VT, NH, ME=1, others=0)
●	US state of residence (MA, CT, RI, VT, NH, ME=1, others=0)
●	What is your favorite NFL team? (1 for Patriots; 0 otherwise)
●	Feeling thermometer toward Tom Brady (0 to 100)
*/

/*state of birth*/
gen newenglandborn=(stateborn==7 | stateborn==22 | stateborn==20 | stateborn==30 | stateborn==40 | stateborn==46)

/*state of residence*/
gen newenglandlive=(stateres==7 | stateres==22 | stateres==20 | stateres==30 | stateres==40 | stateres==46)

tab region newenglandlive /*a handful of people moved since filling out profile - using state of birth/residence rather than profile info on region*/

/*favorite team*/
rename favoriteteam FaveTeam
encode FaveTeam, gen(favoriteteam)
drop FaveTeam

gen patsfan = 0
replace patsfan = 1 if favoriteteam == 19

/*bradytherm*/
rename tbrady bradytherm

/*
If the scores for these questions load on a single dimension in a principal components factor analysis, we will compute a factor score (for PatsFandom) or simple average (for FootballFandom/ConspiratorialMind) for each scale. If the questions used for our measures do not scale together, we may analyze responses to a subset of the items that scale together most strongly or consider the scale items individually.
*/

factor newenglandborn newenglandlive patsfan bradytherm,pcf
predict patsfandom

factor newenglandborn newenglandlive patsfan,pcf
predict patsfandomnobrady

/*
FootballFandom:
●	Level of interest in professional football (scale from 1=no interest to 4=watch more than one game per week)
●	Do you own any NFL team clothing? (scale from 1=No/DK to 3=more than 3 items)
●	Which one of the following has Tom Brady recently been accused of? (1=correct [“destroying his cell phone”], 0=incorrect/DK)
●	For how many games did the NFL originally suspend Tom Brady? (1=correct [4], 0=incorrect/DK)
●	What is the minimum pressure allowed in NFL footballs? (PSI=Pounds per square inch? (1=correct [12.5], 0=incorrect/DK)
*/

rename footballinterest FootInt
encode FootInt, gen(FootInt_trans)
recode FootInt_trans (4=1) (1=2) (2=3) (3=4), gen(footballinterest)
drop FootInt_trans FootInt
label define footballinterestLabel 1 "No interest" ///
	2 "When others watching" ///
	3 "One game" ///
	4 "More than one game"
label value footballinterest footballinterestLabel	

rename clothing Clothes
encode Clothes, gen(Cloth_trans)
recode Cloth_trans (2=1) (3=2) (4=3), gen(clothing) /*see above - No/DK together*/
drop Cloth_trans Clothes
label define clothingLabel 1 "No clothing/DK" ///
	2 "1-3 items" ///
	3 ">3 items"
label value clothing clothingLabel	

rename bradyaccused Accused
encode Accused, gen(bradyaccused)
drop Accused

rename psi PSI
encode PSI, gen(psi)
drop PSI

gen accusedknow=(bradyaccused==2)
gen suspensionknow=(suspension==4)
gen psiknow=(psi==1)

/*
If the scores for these questions load on a single dimension in a principal components factor analysis, we will compute a factor score (for PatsFandom) or simple average (for FootballFandom/ConspiratorialMind) for each scale. If the questions used for our measures do not scale together, we may analyze responses to a subset of the items that scale together most strongly or consider the scale items individually.
*/

su footballinterest clothing accusedknow suspensionknow psiknow
factor footballinterest clothing accusedknow suspensionknow psiknow,pcf
rotate,varimax
/*fandom and knowledge seem to scale separately*/

factor footballinterest clothing,pcf
predict footballfandom

factor accusedknow suspensionknow psiknow,pcf
predict deflategateknowledge

/*
ConspiratorialMind:
4-point Likert scale response (“very accurate” [4] to “not at all accurate” [1]) to the following statements:
●	“The U.S. government knew about the 9/11 attacks in advance and intentionally allowed them to happen.”
●	“The media and government have covered up the evidence that President Obama was NOT born in this country.”
*/

rename truther Truther
encode Truther, gen(truther)
drop Truther

rename birther Birther
encode Birther, gen(birther)
drop Birther

/*
If the scores for these questions load on a single dimension in a principal components factor analysis, we will compute a factor score (for PatsFandom) or simple average (for FootballFandom/ConspiratorialMind) for each scale. If the questions used for our measures do not scale together, we may analyze responses to a subset of the items that scale together most strongly or consider the scale items individually.
*/

factor truther birther, pcf
predict conspiratorialmind

/*corr is 0.3254*/
corr truther birther

rename pid PID
encode PID, gen(pid_trans)
recode pid_trans (2=9) (3=2) (4=99), gen(pid)
drop PID pid_trans
label define pidLabel 1 "Democrat" ///
	2 "Republican" ///
	9 "Independent" ///
	99 "Other"
label value pid pidLabel

rename senateterm Senate
encode Senate, gen(senateterm)
drop Senate

rename presidentterms Pres
encode Pres, gen(presidentterms)
drop Pres

rename ukpm UK
encode UK, gen(ukpm)
drop UK

rename age AGE
encode AGE, gen(age)
drop AGE

rename gender Gen
encode Gen, gen(gender)

rename income Y
encode Y, gen(INC)
recode INC (8=3) (9=4) (10=5) (3=6) (4=7) (5=8) (6=9) (7=10) (11=99), gen(income)
drop Y INC
label define incomeLabel 1 "<$10K" ///
	2 "$10-25K" ///
	3 "$25-50K" ///
	4 "$50-75K" ///
	5 "$75-100K" ///
	6 "$100-125K" ///
	7 "$125-150K" ///
	8 "$150-175K" ///
	9 "$175-200K" ///
	10 ">$200K" ///
	99 "No Answer"
label value income incomeLabel

rename region REGION
encode REGION, gen(region)
drop REGION

rename lookupinfo LOOK
encode LOOK, gen(lookupinfo)
drop LOOK

rename devicetype DEVICE
encode DEVICE, gen(devicetype)
drop DEVICE

/*make demographic controls*/
gen male=(gender==2)

/*DEVIATION - no education variable, income has a ton of missing, have to omit*/
/*DEVIATION - no race*/

tab age,gen(agedum)

/*changed order of recoding so commenting this out*/

/*reorder variables*/
/*order treatment treatmentresponse ///
	statereside bornus stateborn ///
	pmanning tbrady tswift kwest ///
	bradybroke noevidence punishingbrady rulinginfluence tampercommon ///
	footballinterest favoriteteam clothing bradyaccused suspension psi ///
	truther birther ///
	pid strongrep strongdem partycloser ///
	senateterm presidentterms ukpm ///
	age gender income region ///
	lookupinfo devicetype ///
	respondentid collectorid startdate enddate customdata consent */

/*descriptive histograms:
histogram bradybroke, discrete percent by(patsfan)
histogram noevidence, discrete percent by(patsfan)
histogram nfldistract, discrete percent by(patsfan)
histogram judgeinfluence, discrete percent by(patsfan)*/

/*make interactions*/
gen patsfandomxfootballfandom=patsfandom*footballfandom
gen patsfandomxdeflategateknow=patsfandom*deflategateknow
gen patsfandomxconspiratorialmind=patsfandom*conspiratorialmind

gen patsfandomxgroupsolidarity=patsfandom*groupsolidarity
gen patsfandomxeliteresentment=patsfandom*eliteresentment

/*
Statistical analysis

We will use OLS with robust standard errors to test each of our hypotheses following the variable coding and scale construction approaches described above. The variable names below are placeholders and we may analyze individual DVs as specified above if items do not scale together. All treatment effects will be estimated as intent to treat effects. We will estimate marginal effects as appropriate when interaction terms are included in our models.
*/

/*balance tests - all ns*/
tab age treatment, chi
tab male treatment, chi
tab income treatment, chi
tab newenglandsample treatment, chi

/*region distribution*/
tab newenglandsample /*about 50/50*/
tab newenglandlive /*48 NE, 52 not NE*/

/*descriptives*/
tab patsfan newenglandlive, col
tab age
tab male
tab income if income!=99
codebook startdate enddate

tab age if newenglandlive==0
tab income if newenglandlive==0 & income!=99
tab region if newenglandlive==0

gen partyid=.
replace partyid=1 if strongdem=="Strong Democrat"
replace partyid=2 if strongdem=="Not very strong Democrat"
replace partyid=3 if partycloser=="Closer to the Democratic Party"
replace partyid=4 if partycloser=="Neither"
replace partyid=5 if partycloser=="Closer to the Republican Party"
replace partyid=6 if strongrep=="Not very strong Republican"
replace partyid=7 if strongrep=="Strong Republican"
tab partyid

/*results for composite pro-Brady beliefs measure*/

/*h1*/
reg deflategateconspiracy patsfandom footballfandom conspiratorialmind male agedum2 agedum3 agedum4, robust 
est store A

/*verify among controls*/
reg deflategateconspiracy patsfandom footballfandom conspiratorialmind male agedum2 agedum3 agedum4 if treatment==1, robust 

/*h2a*/

/*Table 2*/
reg deflategateconspiracy patsfandom footballfandom conspiratorialmind patsfandomxfootballfandom male agedum2 agedum3 agedum4, robust
est store A
reg deflategateconspiracy patsfandom deflategateknow conspiratorialmind patsfandomxdeflategateknow male agedum2 agedum3 agedum4, robust
est store B

estout A B using "table2.txt", label style(tab) replace varwidth(25) collabels("") cells(b(star fmt(%9.2f)) se(par fmt(%9.2f))) stats(r2 N, fmt(%9.2f %9.0f) labels("R$^{2}$" "N")) starlevels(* 0.10 ** 0.05 *** 0.01) 

/*with alt version of Pats fandom scale excluding Brady feelings - robustness tests*/

/*splitting by subscales*/
gen patsfandomnbxfootballfandom=patsfandomnobrady*footballfandom
gen patsfandomnbxdeflategateknow=patsfandomnobrady*deflategateknow

reg deflategateconspiracy patsfandomnobrady footballfandom conspiratorialmind patsfandomnbxfootballfandom male agedum2 agedum3 agedum4, robust
est store A
reg deflategateconspiracy patsfandomnobrady deflategateknow conspiratorialmind patsfandomnbxdeflategateknow male agedum2 agedum3 agedum4, robust
est store B

estout A B, label style(tab) replace varwidth(25) collabels("") cells(b(star fmt(%9.2f)) se(par fmt(%9.2f))) stats(r2 N, fmt(%9.2f %9.0f) labels("R$^{2}$" "N")) starlevels(* 0.10 ** 0.05 *** 0.01) 

/*create a Pats loyalty dummy*/
gen teampats = 0
replace teampats = 1 if favoriteteam==19

/*make interactions for new dummy*/
gen teampatsxfootballfandom=teampats*footballfandom
gen teampatsxdeflategateknowledge=teampats*deflategateknowledge

/*replicate above using dummy rather than team fandom scale*/
reg deflategateconspiracy teampats footballfandom conspiratorialmind teampatsxfootballfandom male agedum2 agedum3 agedum4, robust
reg deflategateconspiracy teampats deflategateknowledge conspiratorialmind teampatsxdeflategateknow male agedum2 agedum3 agedum4, robust

reg deflategateconspiracy teampats deflategateknowledge conspiratorialmind teampatsxdeflategateknow male agedum2 agedum3 agedum4
est store A

/*testing for potential non-linearity by Deflategate knowledge*/
reg deflategateconspiracy patsfandom deflategateknow conspiratorialmind patsfandomxdeflategateknow male agedum2 agedum3 agedum4
est store A

gen deflategateknow2=deflategateknow^2
gen patsfandomXdeflategateknow2=patsfandom*deflategateknow2

reg deflategateconspiracy patsfandom deflategateknowledge deflategateknow2 conspiratorialmind patsfandomxdeflategateknow patsfandomXdeflategateknow2 male agedum2 agedum3 agedum4
est store B
lrtest A B 

foreach var of varlist bradybrokerules noevidence punishingbrady rulinginfluence {
reg `var' patsfandom deflategateknowledge conspiratorialmind patsfandomxdeflategateknow male agedum2 agedum3 agedum4
est store A
reg `var' patsfandom deflategateknowledge deflategateknow2 conspiratorialmind patsfandomxdeflategateknow patsfandomXdeflategateknow2 male agedum2 agedum3 agedum4
est store B
lrtest A B
}

twoway (lowess deflategateconspiracy deflategateknowledge if teampats==0, title("Deflategate conspiracy belief") legend(lab(1 "Non-Patriots fan") lab(2 "Patriots fan")) xtitle("Deflategate knowledge scale"))(lowess deflategateconspiracy deflategateknowledge if teampats==1, scheme(s1color) graphregion(fcolor(white) ifcolor(none)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)))

twoway (lowess bradybrokerules deflategateknowledge if teampats==0, title("Belief Brady broke rules") legend(lab(1 "Non-Patriots fan") lab(2 "Patriots fan")) xtitle("Deflategate knowledge scale"))(lowess bradybrokerules deflategateknowledge if teampats==1, scheme(s1color) graphregion(fcolor(white) ifcolor(none)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)))

twoway (lowess noevidence deflategateknowledge if teampats==0, title("Belief in no evidence of wrongdoing") legend(lab(1 "Non-Patriots fan") lab(2 "Patriots fan")) xtitle("Deflategate knowledge scale"))(lowess noevidence deflategateknowledge if teampats==1, scheme(s1color) graphregion(fcolor(white) ifcolor(none)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)))

twoway (lowess punishingbrady deflategateknowledge if teampats==0, title("Belief NFL punishing Brady") legend(lab(1 "Non-Patriots fan") lab(2 "Patriots fan")) xtitle("Deflategate knowledge scale"))(lowess punishingbrady deflategateknowledge if teampats==1, scheme(s1color) graphregion(fcolor(white) ifcolor(none)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)))

twoway (lowess rulinginfluence deflategateknowledge if teampats==0, title("Belief that Deflategate judge influenced") legend(lab(1 "Non-Patriots fan") lab(2 "Patriots fan")) xtitle("Deflategate knowledge scale"))(lowess rulinginfluence deflategateknowledge if teampats==1, scheme(s1color) graphregion(fcolor(white) ifcolor(none)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)))

drop deflategateknow2

/*verify works among controls*/
reg deflategateconspiracy patsfandom footballfandom conspiratorialmind patsfandomxfootballfandom male agedum2 agedum3 agedum4 if treatment==1, robust
reg deflategateconspiracy patsfandom deflategateknow conspiratorialmind patsfandomxdeflategateknow male agedum2 agedum3 agedum4 if treatment==1, robust

/*h2b*/
reg deflategateconspiracy patsfandom footballfandom conspiratorialmind patsfandomxconspiratorialmind male agedum2 agedum3 agedum4, robust
est store A

estout A, label style(tab) replace varwidth(25) collabels("") cells(b(star fmt(%9.2f)) se(par fmt(%9.2f))) stats(r2 N, fmt(%9.2f %9.0f) labels("R$^{2}$" "N")) starlevels(* 0.10 ** 0.05 *** 0.01) 

/*h3a/h3b*/
/*Table 3*/
reg deflategateconspiracy patsfandom groupsolidarity eliteresentment patsfandomxgroupsolidarity patsfandomxeliteresentment, robust
est store A

reg deflategateconspiracy patsfandom groupsolidarity eliteresentment patsfandomxgroupsolidarity patsfandomxeliteresentment male agedum2 agedum3 agedum4, robust 

estout A using "table3.txt", label style(tab) replace varwidth(25) collabels("") cells(b(star fmt(%9.2f)) se(par fmt(%9.2f))) stats(r2 N, fmt(%9.2f %9.0f) labels("R2" "N")) starlevels(* 0.10 ** 0.05 *** 0.01) 

/*(Note: If SurveyMonkey provides survey weights, we will verify that our results are robust to using those weights. Our primary results will be unweighted.*/
/*no weights*/

/*Individual DV results*/
/*All regression results for individual ordered dependent variables will be verified for robustness using ordered probit.*/

/*exploratory individual DV results*/
foreach var of varlist bradybrokerules noevidence punishingbrady rulinginfluence {
reg `var' patsfandom footballfandom conspiratorialmind male agedum2 agedum3 agedum4, robust 
oprobit `var' patsfandom footballfandom conspiratorialmind male agedum2 agedum3 agedum4, robust 
}

foreach var of varlist bradybrokerules noevidence punishingbrady rulinginfluence {
reg `var' patsfandom footballfandom conspiratorialmind patsfandomxfootballfandom male agedum2 agedum3 agedum4, robust
oprobit patsfandom footballfandom conspiratorialmind patsfandomxfootballfandom male agedum2 agedum3 agedum4, robust
}

foreach var of varlist bradybrokerules noevidence punishingbrady rulinginfluence {
reg `var' patsfandom deflategateknow conspiratorialmind patsfandomxdeflategateknow male agedum2 agedum3 agedum4, robust
oprobit patsfandom deflategateknow conspiratorialmind patsfandomxdeflategateknow male agedum2 agedum3 agedum4, robust
}

foreach var of varlist bradybrokerules noevidence punishingbrady rulinginfluence {
reg `var' patsfandom footballfandom conspiratorialmind patsfandomxconspiratorialmind male agedum2 agedum3 agedum4, robust
oprobit patsfandom footballfandom conspiratorialmind patsfandomxconspiratorialmind male agedum2 agedum3 agedum4, robust
}

foreach var of varlist bradybrokerules noevidence punishingbrady rulinginfluence {
reg `var' patsfandom groupsolidarity eliteresentment patsfandomxgroupsolidarity patsfandomxeliteresentment, robust
oprobit patsfandom groupsolidarity eliteresentment patsfandomxgroupsolidarity patsfandomxeliteresentment, robust
}

/*robustness to recoding patsfandom*/

preserve

su patsfandom /*2678*/

drop patsfan patsfand*

/*alt coding*/
gen patsfan = .
replace patsfan = 0 if favoriteteam != 23 & favoriteteam!=.
replace patsfan = 1 if favoriteteam == 19

/*build new scale*/
factor newenglandborn newenglandlive patsfan bradytherm,pcf
predict patsfandom

su patsfandom /*2056*/

/*make interactions again*/
gen patsfandomxfootballfandom=patsfandom*footballfandom
gen patsfandomxdeflategateknow=patsfandom*deflategateknow
gen patsfandomxconspiratorialmind=patsfandom*conspiratorialmind

gen patsfandomxgroupsolidarity=patsfandom*groupsolidarity
gen patsfandomxeliteresentment=patsfandom*eliteresentment

/*h1*/

reg deflategateconspiracy patsfandom footballfandom conspiratorialmind male agedum2 agedum3 agedum4, robust 

/*h2a*/

reg deflategateconspiracy patsfandom footballfandom conspiratorialmind patsfandomxfootballfandom male agedum2 agedum3 agedum4, robust
reg deflategateconspiracy patsfandom deflategateknow conspiratorialmind patsfandomxdeflategateknow male agedum2 agedum3 agedum4, robust

/*h2b*/
reg deflategateconspiracy patsfandom footballfandom conspiratorialmind patsfandomxconspiratorialmind male agedum2 agedum3 agedum4, robust

/*h3*/
reg deflategateconspiracy patsfandom groupsolidarity eliteresentment patsfandomxgroupsolidarity patsfandomxeliteresentment, robust

restore

/*recode individual DV direction to facilitate understanding*/

gen bradyalt=bradybrokerules
recode bradyalt (1=4)(2=3)(3=2)(4=1)

gen judgealt=rulinginfluence
recode judgealt (1=4)(2=3)(3=2)(4=1)

reg bradyalt patsfandom footballfandom conspiratorialmind male agedum2 agedum3 agedum4, robust 
est store A
reg noevidence patsfandom footballfandom conspiratorialmind male agedum2 agedum3 agedum4, robust 
est store B
reg punishingbrady patsfandom footballfandom conspiratorialmind male agedum2 agedum3 agedum4, robust 
est store C
reg judgealt patsfandom footballfandom conspiratorialmind male agedum2 agedum3 agedum4, robust 
est store D

estout A B C D, label style(tab) replace varwidth(25) collabels("") cells(b(star fmt(%9.2f)) se(par fmt(%9.2f))) stats(r2 N, fmt(%9.2f %9.0f) labels("R2" "N")) starlevels(* 0.10 ** 0.05 *** 0.01) 

/*table 1*/
reg deflategateconspiracy patsfandom footballfandom conspiratorialmind male agedum2 agedum3 agedum4, robust 
est store orig

estout orig A B C D using "table1.txt", label style(tab) replace varwidth(25) collabels("") cells(b(star fmt(%9.2f)) se(par fmt(%9.2f))) stats(r2 N, fmt(%9.2f %9.0f) labels("R2" "N")) starlevels(* 0.10 ** 0.05 *** 0.01) 

/*table 1 robustness to using no-Brady Patriots fandom scale instead*/
reg deflategateconspiracy patsfandomnobrady footballfandom conspiratorialmind male agedum2 agedum3 agedum4, robust 
est store orig

reg bradyalt patsfandomnobrady footballfandom conspiratorialmind male agedum2 agedum3 agedum4, robust 
est store A
reg noevidence patsfandomnobrady footballfandom conspiratorialmind male agedum2 agedum3 agedum4, robust 
est store B
reg punishingbrady patsfandomnobrady footballfandom conspiratorialmind male agedum2 agedum3 agedum4, robust 
est store C
reg judgealt patsfandomnobrady footballfandom conspiratorialmind male agedum2 agedum3 agedum4, robust 
est store D

estout orig A B C D, label style(tab) replace varwidth(25) collabels("") cells(b(star fmt(%9.2f)) se(par fmt(%9.2f))) stats(r2 N, fmt(%9.2f %9.0f) labels("R2" "N")) starlevels(* 0.10 ** 0.05 *** 0.01) 

/*table c2*/
reg bradyalt patsfandom footballfandom patsfandomxfootballfandom conspiratorialmind male agedum2 agedum3 agedum4, robust 
est store A
reg noevidence patsfandom footballfandom patsfandomxfootballfandom conspiratorialmind male agedum2 agedum3 agedum4, robust 
est store B
reg punishingbrady patsfandom footballfandom patsfandomxfootballfandom conspiratorialmind male agedum2 agedum3 agedum4, robust 
est store C
reg judgealt patsfandom footballfandom patsfandomxfootballfandom conspiratorialmind male agedum2 agedum3 agedum4, robust 
est store D

estout A B C D using "tablec2.txt", label style(tab) replace varwidth(25) collabels("") cells(b(star fmt(%9.2f)) se(par fmt(%9.2f))) stats(r2 N, fmt(%9.2f %9.0f) labels("R2" "N")) starlevels(* 0.10 ** 0.05 *** 0.01) 

/*table c3*/
reg bradyalt patsfandom deflategateknow patsfandomxdeflategateknow conspiratorialmind male agedum2 agedum3 agedum4, robust 
est store A
reg noevidence patsfandom deflategateknow patsfandomxdeflategateknow conspiratorialmind male agedum2 agedum3 agedum4, robust 
est store B
reg punishingbrady patsfandom deflategateknow patsfandomxdeflategateknow conspiratorialmind male agedum2 agedum3 agedum4, robust 
est store C
reg judgealt patsfandom deflategateknow patsfandomxdeflategateknow conspiratorialmind male agedum2 agedum3 agedum4, robust 
est store D

estout A B C D using "tablec3.txt", label style(tab) replace varwidth(25) collabels("") cells(b(star fmt(%9.2f)) se(par fmt(%9.2f))) stats(r2 N, fmt(%9.2f %9.0f) labels("R2" "N")) starlevels(* 0.10 ** 0.05 *** 0.01) 

/*table c4*/
reg deflategateconspiracy patsfandom footballfandom conspiratorialmind patsfandomxconspiratorialmind male agedum2 agedum3 agedum4, robust
est store orig

reg bradyalt patsfandom footballfandom conspiratorialmind patsfandomxconspiratorialmind male agedum2 agedum3 agedum4, robust
est store A
reg noevidence patsfandom footballfandom conspiratorialmind patsfandomxconspiratorialmind male agedum2 agedum3 agedum4, robust
est store B
reg punishingbrady patsfandom footballfandom conspiratorialmind patsfandomxconspiratorialmind male agedum2 agedum3 agedum4, robust
est store C
reg judgealt patsfandom footballfandom conspiratorialmind patsfandomxconspiratorialmind male agedum2 agedum3 agedum4, robust
est store D

estout orig A B C D using "tablec4.txt", label style(tab) replace varwidth(25) collabels("") cells(b(star fmt(%9.2f)) se(par fmt(%9.2f))) stats(r2 N, fmt(%9.2f %9.0f) labels("R2" "N")) starlevels(* 0.10 ** 0.05 *** 0.01) 

/*table c5*/
reg deflategateconspiracy patsfandom groupsolidarity eliteresentment patsfandomxgroupsolidarity patsfandomxeliteresentment, robust
est store orig

reg bradyalt patsfandom groupsolidarity eliteresentment patsfandomxgroupsolidarity patsfandomxeliteresentment, robust
est store A
 
reg noevidence patsfandom groupsolidarity eliteresentment patsfandomxgroupsolidarity patsfandomxeliteresentment, robust
est store B

reg punishingbrady patsfandom groupsolidarity eliteresentment patsfandomxgroupsolidarity patsfandomxeliteresentment, robust
est store C

reg judgealt patsfandom groupsolidarity eliteresentment patsfandomxgroupsolidarity patsfandomxeliteresentment, robust
est store D

estout orig A B C D using "tablec5.txt", label style(tab) replace varwidth(25) collabels("") cells(b(star fmt(%9.2f)) se(par fmt(%9.2f))) stats(r2 N, fmt(%9.2f %9.0f) labels("R2" "N")) starlevels(* 0.10 ** 0.05 *** 0.01) 

/*table c5 robustness - no brady*/
gen patsfandomnbXgroupsolidarity=patsfandomnobrady*groupsolidarity
gen patsfandomnbXeliteresentment=patsfandomnobrady*eliteresentment

reg deflategateconspiracy patsfandomnobrady groupsolidarity eliteresentment patsfandomnbXgroupsolidarity patsfandomnbXeliteresentment, robust
est store orig

reg bradyalt patsfandomnobrady groupsolidarity eliteresentment patsfandomnbXgroupsolidarity patsfandomnbXeliteresentment, robust
est store A
 
reg noevidence patsfandomnobrady groupsolidarity eliteresentment patsfandomnbXgroupsolidarity patsfandomnbXeliteresentment, robust
est store B

reg punishingbrady patsfandomnobrady groupsolidarity eliteresentment patsfandomnbXgroupsolidarity patsfandomnbXeliteresentment, robust
est store C

reg judgealt patsfandomnobrady groupsolidarity eliteresentment patsfandomnbXgroupsolidarity patsfandomnbXeliteresentment, robust
est store D

estout orig A B C D, label style(tab) replace varwidth(25) collabels("") cells(b(star fmt(%9.2f)) se(par fmt(%9.2f))) stats(r2 N, fmt(%9.2f %9.0f) labels("R2" "N")) starlevels(* 0.10 ** 0.05 *** 0.01) 

/*without patriots favorability variable*/

*robustness check for table 1 
reg bradyalt footballfandom conspiratorialmind male agedum2 agedum3 agedum4, robust 
est store A
reg noevidence footballfandom conspiratorialmind male agedum2 agedum3 agedum4, robust 
est store B
reg punishingbrady footballfandom conspiratorialmind male agedum2 agedum3 agedum4, robust 
est store C
reg judgealt footballfandom conspiratorialmind male agedum2 agedum3 agedum4, robust 
est store D
reg deflategateconspiracy footballfandom conspiratorialmind male agedum2 agedum3 agedum4, robust 
est store orig

estout orig A B C D, label style(tab) replace varwidth(25) collabels("") cells(b(star fmt(%9.2f)) se(par fmt(%9.2f))) stats(r2 N, fmt(%9.2f %9.0f) labels("R2" "N")) starlevels(* 0.10 ** 0.05 *** 0.01) 

*robustness check for table 2 
reg deflategateconspiracy footballfandom conspiratorialmind patsfandomxfootballfandom male agedum2 agedum3 agedum4, robust
est store A
reg deflategateconspiracy deflategateknow conspiratorialmind patsfandomxdeflategateknow male agedum2 agedum3 agedum4, robust
est store B

estout A B, label style(tab) replace varwidth(25) collabels("") cells(b(star fmt(%9.2f)) se(par fmt(%9.2f))) stats(r2 N, fmt(%9.2f %9.0f) labels("R$^{2}$" "N")) starlevels(* 0.10 ** 0.05 *** 0.01) 

*robustness check for table 3 (exp results without pats measure)
reg deflategateconspiracy groupsolidarity eliteresentment, robust
est store orig
reg bradyalt groupsolidarity eliteresentment, robust
est store A
reg noevidence groupsolidarity eliteresentment, robust
est store B
reg punishingbrady groupsolidarity eliteresentment, robust
est store C
reg judgealt groupsolidarity eliteresentment, robust
est store D

estout orig A B C D, label style(tab) replace varwidth(25) collabels("") cells(b(star fmt(%9.2f)) se(par fmt(%9.2f))) stats(r2 N, fmt(%9.2f %9.0f) labels("R2" "N")) starlevels(* 0.10 ** 0.05 *** 0.01) 

/*descriptive statistics - used to make table c1*/
su deflategateconspiracy bradyalt noevidence punishingbrady judgealt
mean deflategateconspiracy bradyalt noevidence punishingbrady judgealt

/*graphs*/

/*h1*/
twoway (scatter deflategateconspiracy patsfandom,jitter(5) mcolor(gs12) msymbol(o) legend(off) xtitle("Patriots favorability scale") ytitle("Deflategate conspiracy belief scale"))(lowess deflategateconspiracy patsfandom, lcolor(black) lwidth(*2) scheme(s1mono) graphregion(fcolor(white) ifcolor(none) margin(t=10 b=10)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)))

/*punishing brady*/
twoway (scatter punishingbrady patsfandom,jitter(5) mcolor(gs12) msymbol(o) legend(off) xtitle("Patriots favorability scale") title("Accuracy of claim NFL is punishing Brady to distract"))(lowess punishingbrady patsfandom, lcolor(black) lwidth(*2) scheme(s1mono) graphregion(fcolor(white) ifcolor(none) margin(t=10 b=10)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)) ylabel(1 "Not at all" 2 "Not very" 3 "Somewhat" 4 "Very",angle(0) nogrid))
 
tab punishingbrady, gen(pb)
 
preserve
collapse (mean) pb1 pb2 pb3 pb4,by(patsfan)
list
reshape long pb, i(patsfan) j(num)
label def numlab 1 "Not at all" 2 "Not very" 3 "Somewhat" 4 "Very"
label val num numlab

label def pflab 0 "Not Patriots fan" 1 "Patriots fan"
label val patsfan pflab 

graph bar pb,over(patsfan) over(num) asyvars scheme(s1mono) graphregion(fcolor(white) ifcolor(none) margin(t=10 b=10)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)) ylabel(0 "0%" .1 "10%" .2 "20%" .3 "30%" .4 "40%",angle(0)) ytitle("") title("Accuracy of claim NFL is punishing Brady to distract")
list

restore

*with error bars
*Figure 1

preserve
collapse (mean) pb1 pb2 pb3 pb4 (seb) se1=pb1 se2=pb2 se3=pb3 se4=pb4,by(patsfan)
list
reshape long pb se, i(patsfan) j(num)

label def numlab 1 "Not at all" 2 "Not very" 3 "Somewhat" 4 "Very"
label val num numlab

label def pflab 0 "Not Patriots fan" 1 "Patriots fan"
label val patsfan pflab 

gen hipb=pb+1.96*se
gen lopb=pb-1.96*se

gen catfan=patsfan if num==1
replace catfan=patsfan+2.5 if num==2
replace catfan=patsfan+5 if num==3
replace catfan=patsfan+7.5  if num==4
sort catfan
list catfan num patsfan, sepby(num)

twoway (bar pb catfan if patsfan==0)(bar pb catfan if patsfan==1)(rcap hipb lopb catfan,lcolor(black)),legend(row(1) order(1 "Not Patriots fan" 2 "Patriots fan")) scheme(s2mono) graphregion(fcolor(white) ifcolor(none)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none) margin(b = 0)) xlabel(0.5 "Not at all" 3 "Not very" 5.5 "Somewhat" 8 "Very", noticks) ylabel(0 "0%" .1 "10%" .2 "20%" .3 "30%" .4 "40%" .5 "50%",angle(0) nogrid) xtitle("") ytitle("") title("Accuracy of claim NFL is punishing Brady to distract")
graph export "fig1.pdf", replace

restore
 
/*h2*/

/*median splits*/
gen highfan=(footballfandom>-.2022402)
gen highknow=(deflategateknow>.3084141)

twoway (lowess deflategateconspiracy patsfandom if highfan==0, legend(lab(1 "Not football fan") lab(2 "Football fan")) lcolor(black) lwidth(*2) scheme(s1mono) graphregion(fcolor(white) ifcolor(none)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)) xtitle("Patriots favorability scale") ytitle("Deflategate conspiracy belief scale")) (lowess deflategateconspiracy patsfandom if highfan==1)

twoway (lowess deflategateconspiracy patsfandom if highknow==0, legend(lab(1 "Less Deflategate knowledge") lab(2 "More Deflategate knowledge")) lcolor(black) lwidth(*2) scheme(s1mono) graphregion(fcolor(white) ifcolor(none)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)) xtitle("Patriots favorability scale") ytitle("Deflategate conspiracy belief scale")) (lowess deflategateconspiracy patsfandom if highknow==1)

/*punishing brady*/
twoway (lowess punishingbrady patsfandom if highfan==0, legend(lab(1 "Not football fan") lab(2 "Football fan")) lcolor(black) lwidth(*2) scheme(s1mono) graphregion(fcolor(white) ifcolor(none)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)) xtitle("Patriots favorability scale") title("Accuracy of claim NFL is punishing Brady to distract")) (lowess punishingbrady patsfandom if highfan==1, ytitle("") ylabel(1 "Not at all" 2 "Not very" 3 "Somewhat" 4 "Very",angle(0) nogrid))

twoway (lowess punishingbrady patsfandom if highknow==0, legend(lab(1 "Less Deflategate knowledge") lab(2 "More Deflategate knowledge") size(*.9)) lcolor(black) lwidth(*2) scheme(s1mono) graphregion(fcolor(white) ifcolor(none)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)) xtitle("Patriots favorability scale") title("Accuracy of claim NFL is punishing Brady to distract")) (lowess punishingbrady patsfandom if highknow==1, ytitle("") ylabel(1 "Not at all" 2 "Not very" 3 "Somewhat" 4 "Very",angle(0) nogrid))

preserve
collapse (mean) pb1 pb2 pb3 pb4,by(patsfan highfan)
egen id=group(patsfan highfan)
reshape long pb, i(id) j(num)
label def numlab 1 "Not at all" 2 "Not very" 3 "Somewhat" 4 "Very"
label val num numlab

label def pflab 0 "Not Patriots fan" 1 "Patriots fan"
label val patsfan pflab 

label def hklab 0 "Low NFL interest" 1 "High NFL interest"
label val highfan hklab

graph bar pb,over(patsfan) over(num) by(highfan,title("Accuracy of claim NFL is punishing Brady to distract") caption("")) asyvars scheme(s1mono) graphregion(fcolor(white) ifcolor(none) margin(t=10 b=10)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)) ylabel(0 "0%" .1 "10%" .2 "20%" .3 "30%" .4 "40%",angle(0)) ytitle("") caption("")

restore

preserve
collapse (mean) pb1 pb2 pb3 pb4,by(patsfan highknow)
egen id=group(patsfan highknow)
reshape long pb, i(id) j(num)
label def numlab 1 "Not at all" 2 "Not very" 3 "Somewhat" 4 "Very"
label val num numlab

label def pflab 0 "Not Patriots fan" 1 "Patriots fan"
label val patsfan pflab 

label def hklab 0 "Low Deflategate knowledge" 1 "High Deflategate knowledge"
label val highknow hklab

graph bar pb,over(patsfan) over(num) by(highknow,title("Accuracy of claim NFL is punishing Brady to distract")) asyvars scheme(s1mono) graphregion(fcolor(white) ifcolor(none) margin(t=10 b=10)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)) ylabel(0 "0%" .1 "10%" .2 "20%" .3 "30%" .4 "40%",angle(0)) ytitle("") 

restore

/*simplified version*/
gen pbsimple=punishingbrady
recode pbsimple (2=1)(3=2)(4=2)
tab pbsimple, gen(pbs)

/*tercile splits*/
gen fanterc=.
replace fanterc=0 if footballfandom<-1
replace fanterc=1 if footballfandom>-1 & footballfandom<.3
replace fanterc=2 if footballfandom>.3 & footballfandom!=.

gen knowterc=.
replace knowterc=0 if deflategateknow<-.7
replace knowterc=1 if deflategateknow>-.7 & deflategateknow<.31
replace knowterc=2 if deflategateknow>.3 & deflategateknow!=.

tab fanterc
tab knowterc

/*modified to include error bars*/
/*Figure 2*/

preserve
collapse (mean) pbs2 (seb) se=pbs2,by(patsfan fanterc)
list
drop if fanterc==. 
label def pbs2lab 1 "Not at all/not very" 2 "Somewhat/very"
label val pbs2 pbs2lab

label def pflab 0 "Not Patriots fan" 1 "Patriots fan"
label val patsfan pflab 

label def terclab 0 "Low" 1 "Medium" 2 "High"
label val fanterc terclab

gen hipb=pbs2+1.96*se
gen lopb=pbs2-1.96*se

gen catfan=patsfan if fanterc==0
replace catfan=patsfan+2.5 if fanterc==1
replace catfan=patsfan+5 if fanterc==2
sort catfan
list catfan fanterc patsfan, sepby(fanterc)

twoway (bar pbs2 catfan if patsfan==0)(bar pbs2 catfan if patsfan==1)(rcap hipb lopb catfan,lcolor(black)),legend(row(1) order(1 "Not Patriots fan" 2 "Patriots fan")) scheme(s2mono) graphregion(fcolor(white) ifcolor(none)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none) margin(b = 0)) xlabel(0.5 "Low" 3 "Medium" 5.5 "High", noticks) ylabel(0 "0%" .2 "20%" .4 "40%" .6 "60%" .8 "80%",angle(0) nogrid) xtitle("") ytitle("") title("NFL interest level") saving("fansimple.gph",replace)

restore

preserve
collapse (mean) pbs2 (seb) se=pbs2,by(patsfan knowterc)
list
drop if knowterc==. 
label def pbs2lab 1 "Not at all/not very" 2 "Somewhat/very"
label val pbs2 pbs2lab

label def pflab 0 "Not Patriots fan" 1 "Patriots fan"
label val patsfan pflab 

label def terclab 0 "Low" 1 "Medium" 2 "High"
label val knowterc terclab

gen hipb=pbs2+1.96*se
gen lopb=pbs2-1.96*se

gen catfan=patsfan if knowterc==0
replace catfan=patsfan+2.5 if knowterc==1
replace catfan=patsfan+5 if knowterc==2
sort catfan
list catfan knowterc patsfan, sepby(knowterc)

twoway (bar pbs2 catfan if patsfan==0)(bar pbs2 catfan if patsfan==1)(rcap hipb lopb catfan,lcolor(black)),legend(row(1) order(1 "Not Patriots fan" 2 "Patriots fan")) scheme(s2mono) graphregion(fcolor(white) ifcolor(none)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none) margin(b = 0)) xlabel(0.5 "Low" 3 "Medium" 5.5 "High", noticks) ylabel(0 "0%" .2 "20%" .4 "40%" .6 "60%" .8 "80%",angle(0) nogrid) xtitle("") ytitle("") title("Deflategate knowledge level") saving("knowsimple.gph",replace)

restore

grc1leg "fansimple.gph" "knowsimple.gph", title("Belief that NFL is punishing Brady to distract") graphregion(fcolor(white) ifcolor(none) margin(t=5 b=5)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none) margin(t=0 b=0)) xsize(20) ysize(8) position(6) ring(1)
graph export "fig2.pdf", replace

/*h2*/

twoway (lowess deflategateconspiracy patsfandom if highfan==0, legend(lab(1 "Not football fan") lab(2 "Football fan")) lcolor(black) lwidth(*2) scheme(s1mono) graphregion(fcolor(white) ifcolor(none)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)) xtitle("Patriots favorability scale") ytitle("Deflategate conspiracy belief scale")) (lowess deflategateconspiracy patsfandom if highfan==1)

twoway (lowess deflategateconspiracy patsfandom if highknow==0, legend(lab(1 "Less Deflategate knowledge") lab(2 "More Deflategate knowledge")) lcolor(black) lwidth(*2) scheme(s1mono) graphregion(fcolor(white) ifcolor(none)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)) xtitle("Patriots favorability scale") ytitle("Deflategate conspiracy belief scale")) (lowess deflategateconspiracy patsfandom if highknow==1)

/*punishing brady*/
twoway (lowess punishingbrady patsfandom if highfan==0, legend(lab(1 "Not football fan") lab(2 "Football fan")) lcolor(black) lwidth(*2) scheme(s1mono) graphregion(fcolor(white) ifcolor(none)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)) xtitle("Patriots favorability scale") title("Accuracy of claim NFL is punishing Brady to distract")) (lowess punishingbrady patsfandom if highfan==1, ytitle("") ylabel(1 "Not at all" 2 "Not very" 3 "Somewhat" 4 "Very",angle(0) nogrid))

twoway (lowess punishingbrady patsfandom if highknow==0, legend(lab(1 "Less Deflategate knowledge") lab(2 "More Deflategate knowledge") size(*.9)) lcolor(black) lwidth(*2) scheme(s1mono) graphregion(fcolor(white) ifcolor(none)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)) xtitle("Patriots favorability scale") title("Accuracy of claim NFL is punishing Brady to distract")) (lowess punishingbrady patsfandom if highknow==1, ytitle("") ylabel(1 "Not at all" 2 "Not very" 3 "Somewhat" 4 "Very",angle(0) nogrid))

preserve
collapse (mean) pb1 pb2 pb3 pb4,by(patsfan highfan)
egen id=group(patsfan highfan)
reshape long pb, i(id) j(num)
label def numlab 1 "Not at all" 2 "Not very" 3 "Somewhat" 4 "Very"
label val num numlab

label def pflab 0 "Not Patriots fan" 1 "Patriots fan"
label val patsfan pflab 

label def hklab 0 "Low NFL interest" 1 "High NFL interest"
label val highfan hklab

graph bar pb,over(patsfan) over(num) by(highfan,title("Accuracy of claim NFL is punishing Brady to distract") caption("")) asyvars scheme(s1mono) graphregion(fcolor(white) ifcolor(none) margin(t=10 b=10)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)) ylabel(0 "0%" .1 "10%" .2 "20%" .3 "30%" .4 "40%",angle(0)) ytitle("") caption("")

restore

preserve
collapse (mean) pb1 pb2 pb3 pb4,by(patsfan highknow)
egen id=group(patsfan highknow)
reshape long pb, i(id) j(num)
label def numlab 1 "Not at all" 2 "Not very" 3 "Somewhat" 4 "Very"
label val num numlab

label def pflab 0 "Not Patriots fan" 1 "Patriots fan"
label val patsfan pflab 

label def hklab 0 "Low Deflategate knowledge" 1 "High Deflategate knowledge"
label val highknow hklab

graph bar pb,over(patsfan) over(num) by(highknow,title("Accuracy of claim NFL is punishing Brady to distract")) asyvars scheme(s1mono) graphregion(fcolor(white) ifcolor(none) margin(t=10 b=10)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)) ylabel(0 "0%" .1 "10%" .2 "20%" .3 "30%" .4 "40%",angle(0)) ytitle("") 

restore

/*begin brambor et al. style graphs*/
/*Figure C1*/

reg deflategateconspiracy patsfandom footballfandom patsfandomxfootballfandom conspiratorialmind male agedum2 agedum3 agedum4, robust

preserve

generate MV=-1.06+(.01*_n)
replace MV=. if _n>332

matrix b=e(b)
matrix V=e(V)
scalar b1=b[1,1]
scalar b2=b[1,2]
scalar b3=b[1,3]

scalar varb1=V[1,1]
scalar varb2=V[2,2]
scalar varb3=V[3,3]

scalar covb1b3=V[1,3]
scalar covb2b3=V[2,3]

scalar list b1 b2 b3 varb1 varb2 varb3 covb1b3 covb2b3

gen conb=b1+b3*MV if _n<333
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<333
gen a=1.96*conse
gen upper=conb+a
gen lower=conb-a

gen zero=0 if _n<333

twoway (rarea upper lower MV,bfcolor(gs12)) (line conb MV), scheme(s1mono) graphregion(fcolor(white) ifcolor(none)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)) legend(order(2 1) label(2 "Patriots favorability") label (1 "95% confidence interval")) title("NFL interest",size(*.9)) ylab(, angle(0) nogrid) xtitle("NFL interest scale") ytitle("") xlab(-1(1)2) ylab(0(.25).75) saving("fanme.gph",replace)

restore

reg deflategateconspiracy patsfandom deflategateknow patsfandomxdeflategateknow conspiratorialmind male agedum2 agedum3 agedum4, robust

preserve

generate MV=-1.97+(.01*_n)
replace MV=. if _n>304

matrix b=e(b)
matrix V=e(V)
scalar b1=b[1,1]
scalar b2=b[1,2]
scalar b3=b[1,3]

scalar varb1=V[1,1]
scalar varb2=V[2,2]
scalar varb3=V[3,3]

scalar covb1b3=V[1,3]
scalar covb2b3=V[2,3]

scalar list b1 b2 b3 varb1 varb2 varb3 covb1b3 covb2b3

gen conb=b1+b3*MV if _n<305
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<305
gen a=1.96*conse
gen upper=conb+a
gen lower=conb-a

gen zero=0 if _n<305

twoway (rarea upper lower MV,bfcolor(gs12)) (line conb MV), scheme(s1mono) graphregion(fcolor(white) ifcolor(none)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)) legend(order(2 1) label(2 "Patriots favorability") label (1 "95% confidence interval")) title("Knowledge",size(*.9)) ylab(, angle(0) nogrid) xtitle("Deflategate knowledge scale") ytitle("") ylab(0(.25).75) saving("dkme.gph",replace)
restore

grc1leg "fanme.gph" "dkme.gph", title("Marginal effect on Deflategate conspiracy beliefs") graphregion(fcolor(white) ifcolor(none) margin(t=5 b=5)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none) margin(t=0 b=0)) xsize(20) ysize(8) position(6) ring(1)
graph export "figc1.pdf", replace

/*Figures C2 and C3*/

reg deflategateconspiracy groupsolidarity  patsfandom patsfandomxgroupsolidarity  eliteresentment patsfandomxeliteresentment, robust

generate MV=-1.20+(.01*_n)
replace MV=. if _n>297

matrix b=e(b)
matrix V=e(V)
scalar b1=b[1,1]
scalar b2=b[1,2]
scalar b3=b[1,3]

scalar varb1=V[1,1]
scalar varb2=V[2,2]
scalar varb3=V[3,3]

scalar covb1b3=V[1,3]
scalar covb2b3=V[2,3]

scalar list b1 b2 b3 varb1 varb2 varb3 covb1b3 covb2b3

gen conb=b1+b3*MV if _n<298
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<298
gen a=1.96*conse
gen upper=conb+a
gen lower=conb-a

gen zero=0 if _n<298

twoway (rarea upper lower MV,bfcolor(gs12)) (line zero MV) (line conb MV), scheme(s1mono) graphregion(fcolor(white) ifcolor(none)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)) legend(order(3 1) label(3 "Group solidarity treatment") label (1 "95% confidence interval")) title("Marginal effect on Deflategate conspiracy beliefs",size(*.9)) ylab(, angle(0) nogrid) xtitle("Patriots favorability scale") ytitle("")
graph export "figc2.pdf", replace

reg deflategateconspiracy eliteresentment patsfandom patsfandomxeliteresentment groupsolidarity patsfandomxgroupsolidarity, robust

preserve

generate MV=-1.20+(.01*_n)
replace MV=. if _n>297

matrix b=e(b)
matrix V=e(V)
scalar b1=b[1,1]
scalar b2=b[1,2]
scalar b3=b[1,3]

scalar varb1=V[1,1]
scalar varb2=V[2,2]
scalar varb3=V[3,3]

scalar covb1b3=V[1,3]
scalar covb2b3=V[2,3]

scalar list b1 b2 b3 varb1 varb2 varb3 covb1b3 covb2b3

gen conb=b1+b3*MV if _n<298
gen conse=sqrt(varb1+varb3*(MV^2)+2*covb1b3*MV) if _n<298
gen a=1.96*conse
gen upper=conb+a
gen lower=conb-a

gen zero=0 if _n<298

twoway (rarea upper lower MV,bfcolor(gs12)) (line zero MV) (line conb MV), scheme(s1mono) graphregion(fcolor(white) ifcolor(none)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)) legend(order(3 1) label(3 "Elite resentment treatment") label (1 "95% confidence interval")) title("Marginal effect on Deflategate conspiracy beliefs",size(*.9)) ylab(, angle(0) nogrid) xtitle("Patriots favorability scale") ytitle("")
graph export "figc3.pdf", replace

restore

/*political results*/

gen knowledge=(senateterm==4)+(presidentterm==4)+(ukpm==1)
tab knowledge

/*very few got 0 so regrouping*/
recode knowledge (0=1)

gen highpolknow=(knowledge==3)

tab birther, gen(birth)
tab truther, gen(truth)

/*party ID with leaners*/
gen pid3=.
replace pid3=1 if pid==1 | partycloser=="Closer to the Democratic Party"
replace pid3=2 if partycloser=="Neither" | (partycloser=="" & pid!=1 & pid!=2)
replace pid3=3 if pid==2 | partycloser=="Closer to the Republican Party"

tab pid3,missing /*somewhat light on Republicans*/

preserve
drop if pid3==2
collapse (mean) birth1 birth2 birth3 birth4,by(pid3 highpolknow)
egen id=group(pid3 highpolknow)
reshape long birth, i(id) j(num)
label def numlab 1 "Not at all" 2 "Not very" 3 "Somewhat" 4 "Very"
label val num numlab

label def partylab 1 "Democrat" 3 "Republican"
label val pid3 partylab 

label def hklab 0 "Low political knowledge" 1 "High political knowledge"
label val highpolknow hklab

graph bar birth,over(pid3) over(num) by(highpolknow,title("Accuracy of claim Obama not born in U.S.")) asyvars scheme(s1mono) graphregion(fcolor(white) ifcolor(none) margin(t=10 b=10)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)) ylabel(0 "0%" .25 "25%" .5 "50%" .75 "75%" 1 "100%",angle(0)) ytitle("") 

restore

preserve
drop if pid3==2
collapse (mean) truth1 truth2 truth3 truth4,by(pid3 highpolknow)
egen id=group(pid3 highpolknow)
reshape long truth, i(id) j(num)
label def numlab 1 "Not at all" 2 "Not very" 3 "Somewhat" 4 "Very"
label val num numlab

label def partylab 1 "Democrat" 3 "Republican"
label val pid3 partylab 

label def hklab 0 "Low political knowledge" 1 "High political knowledge"
label val highpolknow hklab

graph bar truth,over(pid3) over(num) by(highpolknow,title("Accuracy of claim Bush allowed 9/11 attacks")) asyvars scheme(s1mono) graphregion(fcolor(white) ifcolor(none) margin(t=10 b=10)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)) ylabel(0 "0%" .25 "25%" .5 "50%" .75 "75%",angle(0)) ytitle("") 

restore

reg truther pid3##c.knowledge, robust
reg birther pid3##c.knowledge, robust

bysort pid3: reg truther knowledge, robust
bysort pid3: reg birther knowledge, robust

/*graphs*/

gen knowledgesum=(accusedknow+suspensionknow+psiknow)
recode knowledgesum (0=1) /*grouping into thirds*/

gen dv1binary=(bradybrokerules<3)
gen dv3binary=(punishingbrady>2 & punishing<5)

gen birtherbinary=(birther>2 & birther<5)
gen trutherbinary=(truther>2 & truther<5)

gen notfan=(favoriteteam==23 | favoriteteam==.)

/*conditional on picking a team, 97% of non-NE people pick another team, 66% of NE people pick Patriots*/
bysort newenglandsample notfan: su patsfan

/*comparison to partisan polarization*/
bysort patsfan: su dv1binary dv3binary if notfan==0  /*16% vs 66% for Brady broke rules, 39% vs 68% for NFL conspiracy*/
bysort pid3: su birtherbin trutherbin if pid3!=2 /*8% vs 56% for birther*/

preserve
drop if notfan==1
collapse (mean) dv1binary dv3binary,by(patsfan knowledgesum)

recode patsfan (0=1) (1=0)
label def fanlab 0 "Patriots fan" 1 "Fan of another team"
label val patsfan fanlab 

label def knowlab 1 "Low" 2 "Medium" 3 "High"
label val knowledgesum knowlab 

graph bar dv1binary,over(patsfan) over(knowledgesum) asyvars scheme(s1mono) graphregion(fcolor(white) ifcolor(none) margin(t=10 b=10)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)) ylabel(0 "0%" .25 "25%" .5 "50%" .75 "75%",angle(0)) ytitle("") title("Belief Tom Brady broke the rules") subtitle("By Deflategate knowledge")

graph bar dv3binary,over(patsfan) over(knowledgesum) asyvars scheme(s1mono) graphregion(fcolor(white) ifcolor(none) margin(t=10 b=10)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)) ylabel(0 "0%" .25 "25%" .5 "50%" .75 "75%",angle(0)) ytitle("") title("Belief in NFL conspiracy to punish Brady") subtitle("By Deflategate knowledge")

restore

preserve
drop if notfan==1
recode footballinterest (4=3)
collapse (mean) dv1binary dv3binary,by(patsfan footballinterest)

recode patsfan (0=1) (1=0)
label def fanlab 0 "Patriots fan" 1 "Fan of another team"
label val patsfan fanlab 

label def knowlab 1 "Low" 2 "Medium" 3 "High"
label val footballinterest knowlab 

graph bar dv1binary,over(patsfan) over(footballinterest) asyvars scheme(s1mono) graphregion(fcolor(white) ifcolor(none) margin(t=10 b=10)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)) ylabel(0 "0%" .25 "25%" .5 "50%" .75 "75%",angle(0)) ytitle("") title("Belief Tom Brady broke the rules") subtitle("By NFL interest")

graph bar dv3binary,over(patsfan) over(footballinterest) asyvars scheme(s1mono) graphregion(fcolor(white) ifcolor(none) margin(t=10 b=10)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)) ylabel(0 "0%" .25 "25%" .5 "50%" .75 "75%",angle(0)) ytitle("") title("Belief in NFL conspiracy to punish Brady") subtitle("By NFL interest")

restore

gen dv4binary=(rulinginf<3)

gen CTs=(birtherbinary+trutherbinary)

preserve
collapse (mean) dv3binary dv4binary,by(CTs)

list

label def knowlab 0 "Neither" 1 "One" 2 "Both"
label val CTs knowlab 

graph bar dv3binary, over(CTs) asyvars scheme(s1mono) graphregion(fcolor(white) ifcolor(none) margin(t=10 b=10)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)) ylabel(0 "0%" .25 "25%" .5 "50%" .75 "75%",angle(0)) ytitle("") title("Belief in NFL conspiracy to punish Brady") subtitle("By conspiracy theory belief")

graph bar dv4binary, over(CTs) asyvars scheme(s1mono) graphregion(fcolor(white) ifcolor(none) margin(t=10 b=10)) plotregion(fcolor(none) lcolor(white) ifcolor(none) ilcolor(none)) ylabel(0 "0%" .25 "25%" .5 "50%" .75 "75%",angle(0)) ytitle("") title("Belief in NFL conspiracy to punish Brady") subtitle("By conspiracy theory belief")

restore

preserve
collapse (mean) dv3binary dv4binary,by(CTs)
list
restore

preserve
collapse (mean) dv3binary dv4binary,by(birtherbinary)
list
restore

preserve
collapse (mean) dv3binary dv4binary,by(trutherbinary)
list
restore

bysort patsfan: su dv1binary if notfan==0
su dv1binary if favorite==14

rm dkme.gph
rm fanme.gph
rm knowsimple.gph
rm fansimple.gph
