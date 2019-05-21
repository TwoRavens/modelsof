**********************************************
*****KAM, CINDY D. AND ELIZABETH J. ZECHMEISTER*****
*****"NAME RECOGNITION AND CANDIDATE SUPPORT*****
*****AMERICAN JOURNAL OF POLITICAL SCIENCE*****

/*THIS DO FILE CONTAINS SYNTAX TO REPLICATE TABLES AND FIGURES*/

**********STUDY 1**********
*Analysis for name recognition paper
use "C:/KamZech replication/Study1_2.dta", clear

/*Create study condition variable*/
gen study1cond=.
replace study1cond=1 if gnw25_1==0
replace study1cond=2 if gpos25_1==0
replace study1cond=3 if gneg25_1==0
replace study1cond=4 if nw_1==0
replace study1cond=5 if pos_1==0
replace study1cond=6 if neg_1==0
gen griffinnw=.
replace griffinnw=1 if study1cond==1
replace griffinnw=0 if study1cond!=1&study1cond!=.
gen griffinpos=.
replace griffinpos=1 if study1cond==2
replace griffinpos=0 if study1cond!=2&study1cond!=.
gen griffinneg=.
replace griffinneg=1 if study1cond==3
replace griffinneg=0 if study1cond!=3&study1cond!=.

/*Covariates*/
gen female=.
replace female=1 if gender=="Female"
replace female=0 if gender=="Male"

gen democrat=.
replace democrat=1 if Dem1==1
replace democrat=5/6 if Dem1==2
replace democrat=4/6 if Other==2
replace democrat=.5 if Other==3
replace democrat=2/6 if Other==1
replace democrat=1/6 if Rep1==2
replace democrat=0 if Rep1==1


gen liberal=.
replace liberal=1 if ideo1==1
replace liberal=5/6 if ideo1==2
replace liberal=4/6 if ideo1==3
replace liberal=.5 if ideo2=="I haven't thought much about this"
replace liberal=.5 if ideo1==4
replace liberal=2/6 if ideo1==5
replace liberal=1/6 if ideo1==6
replace liberal=0 if ideo1==7

gen race1=.
replace race1=1 if race=="Asian"
replace race1=2 if race=="Black"
replace race1=3 if race=="Hispanic-Latino"
replace race1=4 if race=="Native American"
replace race1=4 if race=="Other"
replace race1=5 if race=="White"

gen Asian=.
replace Asian=1 if race1==1
replace Asian=0 if race1!=1&race1!=.

gen Black=.
replace Black=1 if race1==2
replace Black=0 if race1!=2&race1!=.

gen Hispanic=.
replace Hispanic=1 if race1==3
replace Hispanic=0 if race1!=3&race1!=.

gen Raceother=.
replace Raceother=1 if race1==4
replace Raceother=0 if race1!=4&race1!=.

recode race1 (5=0)(1 2 3 4=1), gen(nonwhite)
tab nonwhite

gen age1=.
replace age1=age if age>17 & age<45

gen housemaj=.
replace housemaj=1 if D1=="Democrats"
replace housemaj=1 if D1all=="Democrats"
replace housemaj=0 if D1=="Republican"
replace housemaj=0 if D1all=="Republican"

gen senatemaj=.
replace senatemaj=1 if D2=="Democrats"
replace senatemaj=1 if D2all=="Democrats"
replace senatemaj=0 if D2=="Republican"
replace senatemaj=0 if D2all=="Republican"

gen unconstitutional=.
replace unconstitutional=1 if D3=="Supreme Court"
replace unconstitutional=1 if D3all=="Supreme Court"
replace unconstitutional=0 if D3=="President"|D3=="Congress"
replace unconstitutional=0 if D3all=="President"|D3all=="Congress"

gen nomjudge=.
replace nomjudge=1 if D4=="President"
replace nomjudge=1 if D4all=="President"
replace nomjudge=0 if D4=="Congress"|D4=="Supreme Court"
replace nomjudge=0 if D4all=="Congress"|D4all=="Supreme Court"

gen infoinst=0
replace infoinst=infoinst+1 if housemaj==1
replace infoinst=infoinst+1 if senatemaj==1
replace infoinst=infoinst+1 if unconstitutional==1
replace infoinst=infoinst+1 if nomjudge==1

replace infoinst=infoinst/4

alpha housemaj senatemaj unconstitutional nomjudge
factor housemaj senatemaj unconstitutional nomjudge

*Any Name condition
recode study1cond (1/3=1)(4/6=0), gen(namecond)

//BALANCE CHECK - FOOTNOTE 14//
hotelling female democrat liberal Asian Black Hispanic age1 infoinst, by(namecond)
*can reject that vectors of means are equal at .19
*so, proceed with no covariates

/*VOTE CHOICE MODEL*/
gen votegriffin=.
replace votegriffin=1 if q2==2
replace votegriffin=0 if q2==1
tab votegriffin

probit votegriffin namecond 
prtest votegriffin, by(namecond)  /*THESE RESULTS ARE IN FIGURE 1*/

/*AFFECT*/
gen FTdiff=.
replace FTdiff=FTgriffin - FTwilliams

tab FTgriffin
tab FTwilliams

tab FTdiff
sum FTdiff
recode FTdiff (-100/-1=-1)(0=0)(1/100=1), gen(FTdiff3cat)

reg FTdiff namecond 
ttest FTdiff, by(namecond) unequal  /*THESE RESULTS ARE IN FIGURE 1*/


//FOOTNOTE 8//
/*Checking for spillover effectds*/
*cliphvj; cliphvu; cliplvj; cliplvu
*clip1 clip2 clip3 clip4
gen prevcond = .
replace prevcond = 1 if cliphvj==57
replace prevcond = 2 if cliphvu==57
replace prevcond = 3 if cliplvj==57
replace prevcond = 4 if cliplvu==57
replace prevcond = 5 if clip1==57
replace prevcond = 6 if clip2==57
replace prevcond = 7 if clip3==57
replace prevcond = 8 if clip4==57
probit votegriffin namecond 
xi: probit votegriffin namecond i.prevcond
xi: probit votegriffin namecond i.prevcond*namecond

//*FOOTNOTE 10//
//SUBLIMINAL RECOGNITION TASKS//
//RESULTS REPORTED IN ONLINE APPENDIX//
tab1 wind2 tab2 
gen recogwind = 0 
replace recogwind = 1 if wind2=="WINDOW"
gen recogtable = 0 
replace recogtable= 1 if tab2=="TABLE"
tab recogwind recogtable, cell
tab1 moment salad street pencil jelly custom
gen recogscale = (moment+salad+street+pencil+jelly+custom)
tab recogscale

/*SUPPORTING INFORMATION*/
/*CHECKING ACROSS CONDITIONS*/
probit votegriffin griffinnw griffinpos griffinneg 
test griffinneg=griffinnw=griffinpos 
est store model1c
*can't reject the null that the three are the same

reg FTdiff griffinnw griffinpos griffinneg 
test griffinnw=griffinpos=griffinneg
*can't reject the null that the three are the same

//INCLUDING COVARIATES//
//DISCUSSED IN FOOTNOTE 15 AND FULL RESULTS IN ONLINE APPENDIX//
probit votegriffin namecond 
est store model1a
probit votegriffin namecond female democrat liberal Asian Black Hispanic Raceother age1 infoinst
est store model1b
reg FTdiff namecond  
est store model2a
reg FTdiff namecond female democrat liberal Asian Black Hispanic Raceother age1 infoinst 
est store model2b
est table model1a model1b model2a model2b, b(%9.2f) se stats(N) style(col)
est table model1a model1b model2a model2b, b(%9.2f) star(.1 .05 .01)


/*NONPARAMETRIC TESTS, REPORTED IN FOOTNOTE 15*/
ranksum votegriffin, by(namecond)
ranksum FTdiff, by(namecond)

/*TRAITS*/
recode griffintrait_1 (4=0)(3=.33)(2=.67)(1=1)(else=.), gen(griffinhonest)
recode griffintrait_2 (4=0)(3=.33)(2=.67)(1=1)(else=.), gen(griffinleader)
recode griffintrait_3 (4=0)(3=.33)(2=.67)(1=1)(else=.), gen(griffincares)
recode griffintrait_4 (4=0)(3=.33)(2=.67)(1=1)(else=.), gen(griffinintelligent)

/*Test alpha for Griffin traits, create scale*/
factor griffinhonest griffinleader griffincares griffinintelligent
alpha griffinhonest griffinleader griffincares griffinintelligent
gen griffinscale=.
replace griffinscale = (griffinhonest + griffinleader + griffincares + griffinintelligent)/4
sum griffinscale

*****EXPERIENCE*****
recode griffinexp (1=0)(2=.33)(3=.67)(4=1)(else=.), gen(griffinexperience)

*****VIABILITY*****
recode griffinpredict (2=1)(1=0)(else=.), gen(griffinwin)
tab griffinwin

*All DVs, Any Name condition
//IN FIGURE 2//
ttest griffinscale, by(namecond) unequal
ttest griffinexperience, by(namecond) unequal
prtest griffinwin, by(namecond)

reg griffinscale griffinnw griffinpos griffinneg female democrat liberal Asian Black Hispanic Raceother age1 infoinst
test griffinnw griffinpos griffinneg
reg griffinexperience griffinnw griffinpos griffinneg female democrat liberal Asian Black Hispanic Raceother age1 infoinst
test griffinnw griffinpos griffinneg
probit griffinwin griffinnw griffinpos griffinneg female democrat liberal Asian Black Hispanic Raceother age1 infoinst
test griffinnw griffinpos griffinneg


//TABLE 2//
*CAUSAL STEPS ANALYSIS
reg votegriffin namecond
est store votegriffin
reg griffinwin namecond 
est store griffinwin
reg votegriffin griffinwin 
est store votegriffin2
reg votegriffin namecond griffinwin
est store votegriffin3
est table votegriffin griffinwin votegriffin2 votegriffin3, b(%9.2f) star(.1 .05 .01) stat(N)
est table votegriffin griffinwin votegriffin2 votegriffin3, b(%9.2f) se stat(N) style(col)

*sobel test, in text
scalar z = (.1256536*.52043)/sqrt(.52043^2*.0496017^2+.1256536^2*.0382894^2)
scalar list z
disp 2*(1-normal(z))

*sobel test, in FN 19
reg FTdiff namecond
reg griffinwin namecond 
reg FTdiff griffinwin 
reg FTdiff namecond griffinwin
scalar z = (.1256536*15.22616)/sqrt(15.22616^2*.0496017^2+.1256536^2*1.725563^2)
scalar list z
disp 2*(1-normal(z))

preserve 
save "C:/CDK WORK/name recognition project/mediation_data", replace
keep FTdiff votegriffin griffinwin namecond 
reg FTdiff votegriffin griffinwin namecond 
keep if e(sample)
save, replace
restore

/*****ACME R CODE*****
install.packages("mediation")
library("mediation")
setwd ("C:/CDK WORK/name recognition project")
data<-read.csv(file="mediation_data.csv", header=TRUE)
model.m<-lm(griffinwin~namecond, data=data)
model.y<-lm(votegriffin~griffinwin+namecond, data=data)
summary(model.m)
out.1<-mediate(model.m, model.y, sims = 1000, boot = TRUE, treat = "namecond", mediator = "griffinwin")
summary(out.1)

model.m2<-glm(griffinwin~namecond, family=binomial(link= "probit"), data=data)
model.y2<-glm(votegriffin~griffinwin+namecond, family=binomial(link= "probit"), data=data)
out.2<-mediate(model.m2, model.y2, sims = 1000, boot = TRUE, treat = "namecond", mediator = "griffinwin")
summary(out.2)

#####FTDIFF
data<-read.csv(file="mediation_data.csv", header=TRUE)
model.m3<-lm(griffinwin~namecond, data=data)
model.y3<-lm(FTdiff~griffinwin+namecond, data=data)
out.3<-mediate(model.m3, model.y3, sims = 1000, boot = TRUE, treat = "namecond", mediator = "griffinwin")

model.m4<-glm(griffinwin~namecond, family=binomial(link= "probit"), data=data)
model.y4<-lm(FTdiff~griffinwin+namecond, data=data)
out.4<-mediate(model.m4, model.y4, sims = 1000, boot = TRUE, treat = "namecond", mediator = "griffinwin")

summary(out.3)
summary(out.4)
*****ACME R CODE*****/



**********STUDY 2**********
//programming glitch for the first 2 days, so missing treatment subjects on those days//
//remove first two days//
drop if cleandate==110209
drop if cleandate==110309
/*Generate variable for study condition*/
gen study23cond=.
replace study23cond=1 if jnw25_1==0
replace study23cond=2 if jpos25_1==0
replace study23cond=3 if jneg25_1==0
replace study23cond=4 if nw_1__2==0
replace study23cond=5 if pos_1__2==0
replace study23cond=6 if neg_1__2==0

recode study23cond (1 2 3=1)( 4 5 6=0), gen(s2namecond)
replace s2namecond= . if q10>3
tab s2namecond

/*hotelling test*/
hotelling female democrat liberal Asian Black Hispanic Raceother age1 infoinst, by(s2namecond)
//cannot reject at p<.47 that there are diffs, so no need to control//

/*Recode dependent variables*/
recode q10 (2=1)(1=0)(else=.), gen(votejenkins)
gen FTdiff_s2=(FTjenkins - FTdavis)

recode jenkinstrait_1 (4=0)(3=.33)(2=.67)(1=1)(else=.), gen(jenkinshonest)
recode jenkinstrait_2 (4=0)(3=.33)(2=.67)(1=1)(else=.), gen(jenkinsleader)
recode jenkinstrait_3 (4=0)(3=.33)(2=.67)(1=1)(else=.), gen(jenkinscares)
recode jenkinstrait_4 (4=0)(3=.33)(2=.67)(1=1)(else=.), gen(jenkinsintelligent)
recode jenkinsexp (1=0)(2=.33)(3=.67)(4=1)(else=.), gen(jenkinsexperience)
recode jenkinspredict (2=1)(1=0)(else=.), gen(jenkinswin)

factor jenkinshonest jenkinsleader jenkinscares jenkinsintelligent
alpha jenkinshonest jenkinsleader jenkinscares jenkinsintelligent
/*Create scale of traits*/
gen jenkinsscale=.
replace jenkinsscale=jenkinshonest + jenkinsleader + jenkinscares + jenkinsintelligent

/*Dependent variable analyses*/
/*Vote choice*/
tab votejenkins
tab votejenkins s2namecond
prtest votejenkins, by(s2namecond)

/*Affect - Davis*/
ttest FTdiff_s2, by(s2namecond) unequal

/*Traits - scale*/
ttest jenkinsscale, by(s2namecond) unequal

/*Inferences - Experience*/
ttest jenkinsexperience, by(s2namecond) unequal

/*Inferences - Will Jenkins win?*/
prtest jenkinswin, by(s2namecond)

/*What exactly does incumbency indicate?*/
tab jenkinswin s2namecond, col
sum jenkinshonest jenkinsleader jenkinscares jenkinsintelligent

corr votejenkins jenkinswin

probit votejenkins jenkinswin
probit votejenkins jenkinswin s2namecond
probit jenkinswin s2namecond


**********STUDY 3**********
use "C:/KamZech replication/Study3.dta", clear

/*Generate variable for study condition*/
gen study23cond=.
replace study23cond=1 if jnw25_1==0
replace study23cond=2 if jpos25_1==0
replace study23cond=3 if jneg25_1==0
replace study23cond=4 if nw_1==0
replace study23cond=5 if pos_1==0
replace study23cond=6 if neg_1==0

recode study23cond (1 2 3=1)(4 5 6=0), gen(s3namecond)
replace s3namecond=. if q9>5
tab s3namecond

/*Recode demographic variables*/
gen female=.
replace female=0 if gen_2==1
replace female=0 if gen_3==1
replace female=1 if gen_2==2
replace female=1 if gen_3==2

gen democrat=.
replace democrat=1 if Dem1_6==1
replace democrat=5/6 if Dem1_6==2
replace democrat=4/6 if Other_6==2
replace democrat=.5 if Other_6==3
replace democrat=2/6 if Other_6==1
replace democrat=1/6 if Rep1_6==2
replace democrat=0 if Rep1_6==1

gen liberal=. 
replace liberal=0 if ideo_7==7
replace liberal=1/6 if ideo_7==6
replace liberal=2/6 if ideo_7==5
replace liberal=3/6 if ideo_7==4
replace liberal=4/6 if ideo_7==3
replace liberal=5/6 if ideo_7==2
replace liberal=1 if ideo_7==1
replace liberal=3/6 if ideo_7==8

gen asian=0
replace asian=1 if race==1

gen black=0
replace black=1 if race==2

gen hispanic=0
replace hispanic=1 if race==3

gen otherrace=0
replace otherrace=1 if race==4|race==6

gen age1=.
replace age1=age_3 if age_3>17&age_3<45
replace age1=age_4 if age_4>17&age_4<45

gen lawconst=.
replace lawconst=1 if law_1==3
replace lawconst=0 if law_1==1|law_1==2|law_1==4

gen nomjudge=.
replace nomjudge=1 if court==1
replace nomjudge=0 if court==2|court==3|court==4

gen housemaj=.
replace housemaj=1 if house_3==1
replace housemaj=0 if house_3==2|house_3==3

gen consparty=.
replace consparty=1 if cons_4==2
replace consparty=0 if cons_4==1|cons_4==3

gen reidjob=.
replace reidjob=1 if reid_5==2
replace reidjob=0 if reid_5==1|reid_5==3|reid_5==4|reid_5==5

gen gatesjob=.
replace gatesjob=1 if gates_6==4
replace gatesjob=0 if gates_6==1|gates_6==2|gates_6==3|gates_6==5

gen scaliajob=.
replace scaliajob=1 if scalia_7==1
replace scaliajob=0 if scalia_7==2|scalia_7==3|scalia_7==4|scalia_7==5

gen brownjob=.
replace brownjob=1 if brown_8==2
replace brownjob=0 if brown_8==1|brown_8==3|brown_8==4|brown_8==5

gen polinfo = lawconst + nomjudge + housemaj + consparty + reidjob + gatesjob + scaliajob + brownjob
replace polinfo = polinfo/8

alpha lawconst nomjudge housemaj consparty reidjob gatesjob scaliajob brownjob

/*Hotelling's Vector of Means Tests*/
hotelling female democrat liberal asian black hispanic otherrace age1 polinfo, by(s3namecond)
//can reject at p<.15//

sum female democrat liberal asian black hispanic otherrace age1 polinfo if s3namecond<2

/*Recode dependent variables*/
gen votejenkins=.
replace votejenkins=1 if q10==2
replace votejenkins=0 if q10==1

gen FTdiff=.
replace FTdiff=(FTJenkins - FTDavis)

recode Jenkins_honest (4=0)(3=.33)(2=.67)(1=1)(else=.), gen(jenkinshonest)
recode Jenkins_leader (4=0)(3=.33)(2=.67)(1=1)(else=.), gen(jenkinsleader)
recode Jenkins_cares (4=0)(3=.33)(2=.67)(1=1)(else=.), gen(jenkinscares)
recode Jenkins_smart (4=0)(3=.33)(2=.67)(1=1)(else=.), gen(jenkinsintelligent)
recode jenkinsexp_12 (1=0)(2=.33)(3=.67)(4=1)(else=.), gen(jenkinsexperience)
recode jenkinspredict_13 (2=1)(1=0)(else=.), gen(jenkinswin)

factor jenkinshonest jenkinsleader jenkinscares jenkinsintelligent
alpha jenkinshonest jenkinsleader jenkinscares jenkinsintelligent
/*Create scale of traits*/
gen jenkinsscale=.
replace jenkinsscale=jenkinshonest + jenkinsleader + jenkinscares + jenkinsintelligent

/*Dependent variable analyses*/
tab votejenkins
prtest votejenkins, by(s3namecond)
ttest FTdiff, by(s3namecond) unequal
ttest jenkinsscale, by(s3namecond) unequal
ttest jenkinsexperience, by(s3namecond) unequal
prtest jenkinswin, by(s3namecond)

tab jenkinswin s3namecond, chi2 col

corr votejenkins jenkinswin

probit votejenkins jenkinswin
probit votejenkins s3namecond
probit votejenkins jenkinswin s3namecond




**********STUDY 4**********
use "C:\KamZech replication\Study4.dta", clear

/*DV*/
gen jenkins1=.
replace jenkins1=mj1 if mj1!=.
replace jenkins1=mj2 if mj2!=.
replace jenkins1=mj3 if mj3!=.
replace jenkins1=mj4 if mj4!=.
replace jenkins1=mj5 if mj5!=.
replace jenkins1=mj6 if mj6!=.
replace jenkins1=mj7 if mj7!=.
tab jenkins1

gen griffin1=.
replace griffin1=bg1 if bg1!=.
replace griffin1=bg2 if bg2!=.
replace griffin1=bg3 if bg3!=.
replace griffin1=bg4 if bg4!=.
replace griffin1=bg5 if bg5!=.
replace griffin1=bg6 if bg6!=.
replace griffin1=bg7 if bg7!=.
tab griffin1

mvdecode jenkins1-griffin1, mv(-99)


/*ANALYSIS OF DATA*/
/*TREATMENT CONDITIONS*/
tab pickup
tab ppedir
drop if pickup~=1 /*eliminating bussers & walkers*/

gen treated = 0
replace treated = 1 if ppedir==2
tab treated

tab griffin1 treated, chi2 col /*RANKING, 0=FIRST, 1=SECOND, 2=THIRD*/

recode griffin1 (0 1 2 = 1)(else=0), gen(anygriffin)
recode jenkins1 (0 1 2 =1)(else=0), gen(anyjenkins)
tab anygriffin treated, chi2 col

/*TABLE 3*/
prtest anygriffin, by(treated)
prtest anyjenkins, by(treated)

/*THIRD SET OF RESULTS*/
prtest anygriffin=anyjenkins if treated==1
prtest anygriffin=anyjenkins if treated==0


