* This do file will replicate the analysis presented in Katja Kleinberg and Benjamin Fordham,
* "Don't Know Much about Foreign Policy: Assessing the Impact of "Don't Know" and "No Opinion" 
* Responses on Inferences aboutForeign Policy Attitudes," to be published in Foreign Policy Analysis.

* There are five data files. One is from a survey the authors conducted through the Time-Sharing Experiments
* in the Social Sciences (TESS) project. The other four are ANES datasets. Those from 1992 and 1996 came from 
* a replication file assembled by Jens Hainmueller and Michael Hiscox. Those from 2004 and 2012 came from
* the ANES but were transformed from SPSS to Stata files for our purposes.

* Before running this file, place the contents of the replication data folder into a common directory,
* then change to that directory in Stata.

* Replication for Table 1, column 1, using 1992 ANES Time Series Study
* This employs the NES excerpt assembled by Hainmueller and Hiscox, but the original 
* data from the ANES would work equally well.
cd "C:\Users\Babak\Dropbox\FPA replicated\FPA-15-Nov-0180.R1\KF_FPA_replication 08292016"

use "nes1992.dta", clear

* New limits on foreign imports
gen imports=v900432 if v900462~=2
recode imports (9=.) (8=0)
tab imports

* Sanctions on South Africa
gen sanctions=v900433 if v900462~=2
recode sanctions (9=.) (8=0)
tab sanctions

* Increase or decrease defense spending
gen defense=v900439
recode defense (9=.) (8=0)
tab defense

* Equality for women in business, industry, and government
gen women=v900438 if v900462~=1
recode women (9=.) (8=0)
tab women

* Urban unrest and rioting
gen unrest=v923746
recode unrest (9=.) (8=0)
tab unrest

* Improving the social and economic position of blacks
gen blacks=v900447
recode blacks (9=.) (8=0)
tab blacks

* Government-provided health insurance
gen insurance=v923716
recode insurance (9=.) (8=0)
tab insurance

* Government-guaranteed jobs and standard of living
gen guarantee=v923718
recode guarantee (9=.) (8=0)
tab guarantee

* Provide more or fewer government services
gen services=v900452
recode services (9=.) (8=0)
tab services

* Replication for Table 1, column 2, using 2004 ANES Time Series Study
use "anes2004TS.dta", clear

* New limits on foreign imports
gen imports=V045114
recode imports (8=7)
tab imports

* Use military force or diplomatic pressure to solve international problems
tab V045124

* Increase or decrease defense spending
gen defense=V043142
recode defense (88=80)
tab defense

* Equality for women in business, industry, and government
gen women=V043196
recode women (88=80)
tab women

* Improving the social and economic position of blacks
gen blacks=V043158
recode blacks (88=80)
tab blacks

* Government-provided health insurance
gen insurance=V043150
recode insurance (88=80)
tab insurance

* Government-guaranteed jobs and standard of living
gen guarantee=V043152
recode guarantee (88=80)
tab guarantee

* Provide more or fewer government services
tab V045121

* Protect the environment or protect jobs
gen environment=V043182
recode environment (88=80)
tab environment

* Replication for Table 1, column 3, using 2012 ANES Time Series Study
use "anes_timeseries_2012.dta", clear

* New limits on foreign imports
gen imports=imports_limit
recode imports (-8=-2) (-6=.) (-7=.)
tab imports

* Increase or decrease defense spending
gen defense=defsppr_self
recode defense (-8=-2)
tab defense

* Improving the social and economic position of blacks
gen blacks=aidblack_self
recode blacks (-8=-2)
tab blacks

* Government-provided health insurance
gen insurance=inspre_self
recode insurance (-8=-2)
tab insurance

* Government-guaranteed jobs and standard of living
gen guarantee=guarpr_self
recode guarantee (-8=-2)
tab guarantee

* Provide more or fewer government services
gen services=spsrvpr_ssself
recode services (-8=-2)
tab services

* Protect the environment or protect jobs
gen environment=envjob_self
recode environment (-8=-2)
tab environment

* Tables 2-4 and Figures 1-2 are based on our survey experiment
use "KF_FPA_replication.dta", clear
svyset weight

* These commands transform the questions we analyze from 5 categories to 3
gen tradeq2=tradeq
recode tradeq2 (-1=.) (1=2) (2=2) (3=1) (4=1) (5=0)

gen forceq2=forceq
recode forceq2 (-1=.) (1=2) (2=2) (3=1) (4=1) (5=0)

gen isolatq2=isolatq
recode isolatq2 (-1=.) (1=2) (2=2) (3=1) (4=1) (5=0)

* These commands set up the 2 category dependent variables for logit models
gen tradeql=tradeq
recode tradeql (-1=.) (1=1) (2=1) (3=0) (4=0) (5=.)

gen forceql=forceq
recode forceql (-1=.) (1=1) (2=1) (3=0) (4=0) (5=.)

gen isolatql=isolatq
recode isolatql (-1=.) (1=1) (2=1) (3=0) (4=0) (5=.)


* These commands set up the independent variables for our analysis
gen incquint=ppincimp
recode incquint (1=1) (2=1) (3=1) (4=1) (5=1) (6=1) (7=2) (8=2) (9=2) (10=2) (11=3) (12=3) (13=4) (14=4) (15=4) (16=5) (17=5) (18=5) (19=5) 

gen male=ppgender
recode male (1=1) (2=0)

gen strongdem=party7
recode strongdem (1=0) (2=0) (3=0) (4=0) (5=0) (6=0) (7=1)

gen strongrep=party7
recode strongrep (1=1) (2=0) (3=0) (4=0) (5=0) (6=0) (7=0)


* Table 2
svy: tab tradeq2 if xcondition==1
svy: tab tradeq2 if xcondition==2
svy: tab forceq2 if xcondition==1
svy: tab forceq2 if xcondition==2
svy: tab isolatq2 if xcondition==1
svy: tab isolatq2 if xcondition==2


* Table 3
* Trade question 
svy: mlogit tradeq2 i.ppeducat i.male ppage i.strongdem i.strongrep if xcondition==1, baseoutcome(1)
testparm i.ppeducat, equation(0)
testparm i.ppeducat, equation(2)
svy: logit tradeql i.ppeducat i.male ppage i.strongdem i.strongrep if xcondition==2
testparm i.ppeducat
* Use of force question
svy: mlogit forceq2 i.ppeducat i.male ppage i.strongdem i.strongrep if xcondition==1, baseoutcome(1)
testparm i.ppeducat, equation(0)
testparm i.ppeducat, equation(2)
svy: logit forceql i.ppeducat i.male ppage i.strongdem i.strongrep if xcondition==2
testparm i.ppeducat
* Internationalism-isolationism question
svy: mlogit isolatq2 i.ppeducat i.male ppage i.strongdem i.strongrep if xcondition==1, baseoutcome(1)
testparm i.ppeducat, equation(0)
testparm i.ppeducat, equation(2)
svy: logit isolatql i.ppeducat i.male ppage i.strongdem i.strongrep if xcondition==2
testparm i.ppeducat


* Table 4
svy: logit tradeql i.ppeducat i.male ppage i.strongdem i.strongrep if xcondition==1
testparm i.ppeducat
svy: logit forceql i.ppeducat i.male ppage i.strongdem i.strongrep if xcondition==1
testparm i.ppeducat
svy: logit isolatql i.ppeducat i.male ppage i.strongdem i.strongrep if xcondition==1
testparm i.ppeducat


* Figure 1
* The figure presents marginal effects on the probability of a "support" response
* to each of the three questions.
* The figure displays the confidence intervals reported below.
* TRADE
* Marginal effects for "DKNO modeled" (i.e., the multinomial logit model):
svy: mlogit tradeq2 i.ppeducat i.male ppage i.strongdem i.strongrep if xcondition==1, baseoutcome(1)
*     Lowest to Highest Education
margins, dydx(4.ppeducat) at(ppage=48 male=0 strongdem=0 strongrep=0) predict(outcome(2))
*     Female to male
margins, dydx(i.male) at(ppage=48 ppeducat=3 strongdem=0 strongrep=0) predict(outcome(2))
*     No Party ID to Strong Democrat
margins, dydx(i.strongdem) at(ppage=48 male=0 ppeducat=3 strongrep=0) predict(outcome(2))
*     No Party ID to Strong Republican
margins, dydx(i.strongrep) at(ppage=48 male=0 ppeducat=3 strongdem=0) predict(outcome(2))

* Marginal effects for "DKNO dropped" (i.e., logit model of treatment group, dropping DKNO responses)
svy: logit tradeql i.ppeducat i.male ppage i.strongdem i.strongrep if xcondition==1
*     Lowest to Highest Education
margins, dydx(4.ppeducat) at(ppage=48 male=0 strongdem=0 strongrep=0) 
*     Female to male
margins, dydx(i.male) at(ppage=48 ppeducat=3 strongdem=0 strongrep=0) 
*     No Party ID to Strong Democrat
margins, dydx(i.strongdem) at(ppage=48 male=0 ppeducat=3 strongrep=0) 
*     No Party ID to Strong Republican
margins, dydx(i.strongrep) at(ppage=48 male=0 ppeducat=3 strongdem=0)

* Marginal effects for "DKNO not offered" (i.e., logit model of control group)
svy: logit tradeql i.ppeducat i.male ppage i.strongdem i.strongrep if xcondition==2
*     Lowest to Highest Education
margins, dydx(4.ppeducat) at(ppage=48 male=0 strongdem=0 strongrep=0) 
*     Female to male
margins, dydx(i.male) at(ppage=48 ppeducat=3 strongdem=0 strongrep=0) 
*     No Party ID to Strong Democrat
margins, dydx(i.strongdem) at(ppage=48 male=0 ppeducat=3 strongrep=0) 
*     No Party ID to Strong Republican
margins, dydx(i.strongrep) at(ppage=48 male=0 ppeducat=3 strongdem=0)

* USE OF FORCE
* Marginal effects for "DKNO modeled" (i.e., the multinomial logit model):
svy: mlogit forceq2 i.ppeducat i.male ppage i.strongdem i.strongrep if xcondition==1, baseoutcome(1)
*     Lowest to Highest Education
margins, dydx(4.ppeducat) at(ppage=48 male=0 strongdem=0 strongrep=0) predict(outcome(2))
*     Female to male
margins, dydx(i.male) at(ppage=48 ppeducat=3 strongdem=0 strongrep=0) predict(outcome(2))
*     No Party ID to Strong Democrat
margins, dydx(i.strongdem) at(ppage=48 male=0 ppeducat=3 strongrep=0) predict(outcome(2))
*     No Party ID to Strong Republican
margins, dydx(i.strongrep) at(ppage=48 male=0 ppeducat=3 strongdem=0) predict(outcome(2))

* Marginal effects for "DKNO dropped" (i.e., logit model of treatment group, dropping DKNO responses)
svy: logit forceql i.ppeducat i.male ppage i.strongdem i.strongrep if xcondition==1
*     Lowest to Highest Education
margins, dydx(4.ppeducat) at(ppage=48 male=0 strongdem=0 strongrep=0) 
*     Female to male
margins, dydx(i.male) at(ppage=48 ppeducat=3 strongdem=0 strongrep=0) 
*     No Party ID to Strong Democrat
margins, dydx(i.strongdem) at(ppage=48 male=0 ppeducat=3 strongrep=0) 
*     No Party ID to Strong Republican
margins, dydx(i.strongrep) at(ppage=48 male=0 ppeducat=3 strongdem=0)

* Marginal effects for "DKNO not offered" (i.e., logit model of control group)
svy: logit forceql i.ppeducat i.male ppage i.strongdem i.strongrep if xcondition==2
*     Lowest to Highest Education
margins, dydx(4.ppeducat) at(ppage=48 male=0 strongdem=0 strongrep=0) 
*     Female to male
margins, dydx(i.male) at(ppage=48 ppeducat=3 strongdem=0 strongrep=0) 
*     No Party ID to Strong Democrat
margins, dydx(i.strongdem) at(ppage=48 male=0 ppeducat=3 strongrep=0) 
*     No Party ID to Strong Republican
margins, dydx(i.strongrep) at(ppage=48 male=0 ppeducat=3 strongdem=0)

* INTERNATIONALISM
* Marginal effects for "DKNO modeled" (i.e., the multinomial logit model):
svy: mlogit isolatq2 i.ppeducat i.male ppage i.strongdem i.strongrep if xcondition==1, baseoutcome(1)
*     Lowest to Highest Education
margins, dydx(4.ppeducat) at(ppage=48 male=0 strongdem=0 strongrep=0) predict(outcome(2))
*     Female to male
margins, dydx(i.male) at(ppage=48 ppeducat=3 strongdem=0 strongrep=0) predict(outcome(2))
*     No Party ID to Strong Democrat
margins, dydx(i.strongdem) at(ppage=48 male=0 ppeducat=3 strongrep=0) predict(outcome(2))
*     No Party ID to Strong Republican
margins, dydx(i.strongrep) at(ppage=48 male=0 ppeducat=3 strongdem=0) predict(outcome(2))

* Marginal effects for "DKNO dropped" (i.e., logit model of treatment group, dropping DKNO responses)
svy: logit isolatql i.ppeducat i.male ppage i.strongdem i.strongrep if xcondition==1
*     Lowest to Highest Education
margins, dydx(4.ppeducat) at(ppage=48 male=0 strongdem=0 strongrep=0) 
*     Female to male
margins, dydx(i.male) at(ppage=48 ppeducat=3 strongdem=0 strongrep=0) 
*     No Party ID to Strong Democrat
margins, dydx(i.strongdem) at(ppage=48 male=0 ppeducat=3 strongrep=0) 
*     No Party ID to Strong Republican
margins, dydx(i.strongrep) at(ppage=48 male=0 ppeducat=3 strongdem=0)

* Marginal effects for "DKNO not offered" (i.e., logit model of control group)
svy: logit isolatql i.ppeducat i.male ppage i.strongdem i.strongrep if xcondition==2
*     Lowest to Highest Education
margins, dydx(4.ppeducat) at(ppage=48 male=0 strongdem=0 strongrep=0) 
*     Female to male
margins, dydx(i.male) at(ppage=48 ppeducat=3 strongdem=0 strongrep=0) 
*     No Party ID to Strong Democrat
margins, dydx(i.strongdem) at(ppage=48 male=0 ppeducat=3 strongrep=0) 
*     No Party ID to Strong Republican
margins, dydx(i.strongrep) at(ppage=48 male=0 ppeducat=3 strongdem=0)


* Figure 2
* This figure reports the marginal effects on each of the three possible response
* options for the trade question.
* The figure displays the confidence intervals reported below.

* Marginal effects for "DKNO modeled" (i.e., the multinomial logit model):
* Effects on Pr(Support)
svy: mlogit tradeq2 i.ppeducat i.male ppage i.strongdem i.strongrep if xcondition==1, baseoutcome(1)
*     Lowest to Highest Education
margins, dydx(4.ppeducat) at(ppage=48 male=0 strongdem=0 strongrep=0) predict(outcome(2))
*     Female to male
margins, dydx(i.male) at(ppage=48 ppeducat=3 strongdem=0 strongrep=0) predict(outcome(2))
*     No Party ID to Strong Democrat
margins, dydx(i.strongdem) at(ppage=48 male=0 ppeducat=3 strongrep=0) predict(outcome(2))
*     No Party ID to Strong Republican
margins, dydx(i.strongrep) at(ppage=48 male=0 ppeducat=3 strongdem=0) predict(outcome(2))

* Marginal effects for "DKNO modeled" (i.e., the multinomial logit model):
* Effects on Pr(Oppose)
*     Lowest to Highest Education
margins, dydx(4.ppeducat) at(ppage=48 male=0 strongdem=0 strongrep=0) predict(outcome(1))
*     Female to male
margins, dydx(i.male) at(ppage=48 ppeducat=3 strongdem=0 strongrep=0) predict(outcome(1))
*     No Party ID to Strong Democrat
margins, dydx(i.strongdem) at(ppage=48 male=0 ppeducat=3 strongrep=0) predict(outcome(1))
*     No Party ID to Strong Republican
margins, dydx(i.strongrep) at(ppage=48 male=0 ppeducat=3 strongdem=0) predict(outcome(1))

* Marginal effects for "DKNO modeled" (i.e., the multinomial logit model):
* Effects on Pr(DKNO)
*     Lowest to Highest Education
margins, dydx(4.ppeducat) at(ppage=48 male=0 strongdem=0 strongrep=0) predict(outcome(0))
*     Female to male
margins, dydx(i.male) at(ppage=48 ppeducat=3 strongdem=0 strongrep=0) predict(outcome(0))
*     No Party ID to Strong Democrat
margins, dydx(i.strongdem) at(ppage=48 male=0 ppeducat=3 strongrep=0) predict(outcome(0))
*     No Party ID to Strong Republican
margins, dydx(i.strongrep) at(ppage=48 male=0 ppeducat=3 strongdem=0) predict(outcome(0))

* Marginal effects for "DKNO dropped" (i.e., logit model of treatment group, dropping DKNO responses)
* Effects on Pr(Support)
* Because the dependent variable in this model has only two categories, marginal effects on Pr(Oppose) 
* are equal to those on Pr(Support) but with the opposite sign. They are reported in the Figure for ease
* of comparison but are not computed separately here.
svy: logit tradeql i.ppeducat i.male ppage i.strongdem i.strongrep if xcondition==1
*     Lowest to Highest Education
margins, dydx(4.ppeducat) at(ppage=48 male=0 strongdem=0 strongrep=0) 
*     Female to male
margins, dydx(i.male) at(ppage=48 ppeducat=3 strongdem=0 strongrep=0) 
*     No Party ID to Strong Democrat
margins, dydx(i.strongdem) at(ppage=48 male=0 ppeducat=3 strongrep=0) 
*     No Party ID to Strong Republican
margins, dydx(i.strongrep) at(ppage=48 male=0 ppeducat=3 strongdem=0)

* Marginal effects for "DKNO not offered" (i.e., logit model of control group)
* Effects on Pr(Support)
* Because the dependent variable in this model has only two categories, marginal effects on Pr(Oppose) 
* are equal to those on Pr(Support) but with the opposite sign. They are reported in the Figure for ease
* of comparison but are not computed separately here.
svy: logit tradeql i.ppeducat i.male ppage i.strongdem i.strongrep if xcondition==2
*     Lowest to Highest Education
margins, dydx(4.ppeducat) at(ppage=48 male=0 strongdem=0 strongrep=0) 
*     Female to male
margins, dydx(i.male) at(ppage=48 ppeducat=3 strongdem=0 strongrep=0) 
*     No Party ID to Strong Democrat
margins, dydx(i.strongdem) at(ppage=48 male=0 ppeducat=3 strongrep=0) 
*     No Party ID to Strong Republican
margins, dydx(i.strongrep) at(ppage=48 male=0 ppeducat=3 strongdem=0)


* The following will replicate our re-analysis of the data from Hainmueller and Hiscox's IO article
* We begin by setting up their data as they did, using their replication code
* Our results are reported in Figure 3

use nes1992.dta, clear
* Start HH2006 replication code

/* *************************************************************************************************************************** */
/* Recodings from raw dataset NES 1992 */

/* DV */
gen     trade_opinion=. 
replace trade_opinion=1 if v923802==1
replace trade_opinion=0 if v923802==5

/* Treatment Vars: Skill Proxies */
/* Schooling */
gen     schooling=v923905
replace schooling=. if v923905==96
replace schooling=. if v923905==99
replace schooling=. if v923905==.
/* Note cap at 17 years of schooling */

/* Attainment Dummies */
gen     college=. 
replace college=1 if v923908==6 
replace college=0 if v923908~=6
replace college=. if v923908==0 | v923908==98 | v923908==99 | v923908==.

gen     graduate=1 if v923908==7 
replace graduate=0 if v923908~=7 
replace graduate=. if v923908==0 | v923908==98 | v923908==99 | v923908==.

gen     communitycol=1 if v923908==5 | v923908==4 /* some years of post high school education (including junior or community college) */
replace communitycol=0 if v923908~=5 & v923908~=4
replace communitycol=. if v923908==0 | v923908==98 | v923908==99 | v923908==.

gen     highschool=.
replace highschool=1 if v923908==3
replace highschool=0 if v923908~=3 
replace highschool=. if v923908==0 | v923908==98 | v923908==99 | v923908==.

gen     juniorhigh=. 
replace juniorhigh=1 if v923905==8  /* 8 years of schooling completed */
replace juniorhigh=0 if v923905~=8 
replace juniorhigh=. if v923905==96 | v923905==99 | v923905==. 

/* Covariates */
/* Limited Set */
gen     age=v923903
replace age=. if v923903==.

/* age dummies used for robustness only */
gen      agedu18_29=.
replace  agedu18_29=0 if age~=.
replace  agedu18_29=1 if age>=18 & age<=29
gen      agedu30_44=.
replace  agedu30_44=0 if age~=.
replace  agedu30_44=1 if age>=30 & age<=44
gen      agedu45_59=.
replace  agedu45_59=0 if age~=.
replace  agedu45_59=1 if age>=45 & age<=59

gen     male=v924201
replace male=0 if v924201==2
replace male=. if v924201==.
gen     race=v924202
replace race=. if v924202==. | v924202==0 | v924202==9
label   define race 1 White 2 Black 3 Indian 4 Asian
label   values race race
tab     race, gen(RACE)
rename  RACE1 White
rename  RACE2 Black
rename  RACE3 Indian
rename  RACE4 Asian
drop    race

/* Extensive Covariate set */
gen     TUrecoding=1 if v924102==11 | v924102==20 | v924102==21 | v924102==32
replace TUrecoding=0 if v924102==13 | v924102==14 | v924102==15 | v924102==26
gen     TUmember=1 if v924101==1 & TUrecoding==1
replace TUmember=0 if v924101==5 | TUrecoding==0
drop    TUrecoding
gen     partyid=v923634
replace partyid=. if v923634==. | v923634==7 | v923634==8 | v923634==9
label   values partyid v923634
gen     ideology=2 if v923513==1
replace ideology=1 if v923513==3 
replace ideology=0 if v923513==5
label   define ideology 2 Liberal 1 Moderate 0 Conservative
label   values ideology ideology 

/* Married or currently living with partner */
/* Sample delimiter used for table 3        */
gen     partner=1 if v923909==1
replace partner=0 if v923909==2

/* Tolerance proxies (these are just used for the additional tests in the web appendix) */

gen      trueamerican=v923523 
replace  trueamerican=. if v923523==. | v923523==0 | v923523==8 | v923523==9
gen      ETHNO_DISTINCT=1 if v923524==1 
replace  ETHNO_DISTINCT=0  if v923524==3 | v923524==5
gen      ETHNO_BLEND=1 if v923524==5 
replace  ETHNO_BLEND=0  if v923524==3    | v923524==1
gen      treatequal=v923522
replace  treatequal=. if v923522==. | v923522==0 | v923522==8 | v923522==9
gen      adjust=v926115    
replace  adjust=.  if v926115==. | v926115==0 | v926115==8 | v926115==9

/* Sample weight */
gen weight=v923008  
/* *************************************************************************************************************************** */
* End HH2006 replication code

* We created an additional trade variable with DKNOs included rather than treated
* as missing data
* Note that for trade_opinion, 1=favor new limits, 0=oppose new limits, 2=DKNO
gen     trade_opinion2=. 
replace trade_opinion2=1 if v923802==1
replace trade_opinion2=0 if v923802==5
replace trade_opinion2=2 if v923802==0
replace trade_opinion2=2 if v923802==8

* These commands give the marginal effects for the 1992 ANES reported in Figure 3. 
* The Figure displays the confidence intervals produced below.
svyset weight
svy: mlogit trade_opinion2 i.juniorhigh i.highschool i.communitycol i.college i.graduate White Black Indian age male

* Marginal effects on Pr(Support new limits) for "DKNO modeled" using 1992 ANES
margins, dydx(juniorhigh) at(highschool=0 communitycol=0 college=0 graduate=0 White=1 Black=0 Indian=0 age=46 male=0) predict(outcome(1))
margins, dydx(highschool) at(juniorhigh=0 communitycol=0 college=0 graduate=0 White=1 Black=0 Indian=0 age=46 male=0) predict(outcome(1))
margins, dydx(communitycol) at(juniorhigh=0 highschool=0 college=0 graduate=0 White=1 Black=0 Indian=0 age=46 male=0) predict(outcome(1))
margins, dydx(college) at(juniorhigh=0 highschool=0 communitycol=0 graduate=0 White=1 Black=0 Indian=0 age=46 male=0) predict(outcome(1))
margins, dydx(graduate) at(juniorhigh=0 highschool=0 communitycol=0 college=0 White=1 Black=0 Indian=0 age=46 male=0) predict(outcome(1))

* Marginal effects on Pr(Oppose new limits) for "DKNO modeled" using 1992 ANES
margins, dydx(juniorhigh) at(highschool=0 communitycol=0 college=0 graduate=0 White=1 Black=0 Indian=0 age=46 male=0) predict(outcome(0))
margins, dydx(highschool) at(juniorhigh=0 communitycol=0 college=0 graduate=0 White=1 Black=0 Indian=0 age=46 male=0) predict(outcome(0))
margins, dydx(communitycol) at(juniorhigh=0 highschool=0 college=0 graduate=0 White=1 Black=0 Indian=0 age=46 male=0) predict(outcome(0))
margins, dydx(college) at(juniorhigh=0 highschool=0 communitycol=0 graduate=0 White=1 Black=0 Indian=0 age=46 male=0) predict(outcome(0))
margins, dydx(graduate) at(juniorhigh=0 highschool=0 communitycol=0 college=0 White=1 Black=0 Indian=0 age=46 male=0) predict(outcome(0))

* Marginal effects on Pr(DKNO) for "DKNO modeled" using 1992 ANES
margins, dydx(juniorhigh) at(highschool=0 communitycol=0 college=0 graduate=0 White=1 Black=0 Indian=0 age=46 male=0) predict(outcome(2))
margins, dydx(highschool) at(juniorhigh=0 communitycol=0 college=0 graduate=0 White=1 Black=0 Indian=0 age=46 male=0) predict(outcome(2))
margins, dydx(communitycol) at(juniorhigh=0 highschool=0 college=0 graduate=0 White=1 Black=0 Indian=0 age=46 male=0) predict(outcome(2))
margins, dydx(college) at(juniorhigh=0 highschool=0 communitycol=0 graduate=0 White=1 Black=0 Indian=0 age=46 male=0) predict(outcome(2))
margins, dydx(graduate) at(juniorhigh=0 highschool=0 communitycol=0 college=0 White=1 Black=0 Indian=0 age=46 male=0) predict(outcome(2))

* Marginal effects on Pr(Support new limits) for "DKNO dropped" using 1992 ANES
* Because the dependent variable in this model has only two categories, marginal effects on Pr(Oppose) 
* are equal to those on Pr(Support) but with the opposite sign. They are reported in the Figure for ease
* of comparison but are not computed separately here.
svy: probit trade_opinion i.juniorhigh i.highschool i.communitycol i.college i.graduate White Black Indian age male
margins, dydx(juniorhigh) at(highschool=0 communitycol=0 college=0 graduate=0 White=1 Black=0 Indian=0 age=46 male=0)
margins, dydx(highschool) at(juniorhigh=0 communitycol=0 college=0 graduate=0 White=1 Black=0 Indian=0 age=46 male=0)
margins, dydx(communitycol) at(juniorhigh=0 highschool=0 college=0 graduate=0 White=1 Black=0 Indian=0 age=46 male=0)
margins, dydx(college) at(juniorhigh=0 highschool=0 communitycol=0 graduate=0 White=1 Black=0 Indian=0 age=46 male=0)
margins, dydx(graduate) at(juniorhigh=0 highschool=0 communitycol=0 college=0 White=1 Black=0 Indian=0 age=46 male=0)



* We conducted the same exercise for the 1996 ANES; use the Hainmueller and Hiscox replication data and code,
* then adding an additional dependent variable and analysis

* First running their replication code on the 1996 NES data they used
use nes1996.dta, clear

* Start HH2006 replication code
/* *************************************************************************************************************************** */
/* Recodings from raw dataset NES 1996 */

/* DV */
gen     trade_opinion=.
replace trade_opinion=1 if v961327==1
replace trade_opinion=0 if v961327==5

/* Treatment Vars: Skill Proxies */

/* Schooling */
gen     schooling=v960607
replace schooling=. if v960607==99 | v960607==.
/* Note cap at 17 years of schooling */

/* Attainment Dummies */
gen     graduate=1 if  v960610==7
replace graduate=0 if  v960610~=7
replace graduate=. if  v960610==. | v960610==9

gen     college=1 if v960610==6 
replace college=0 if v960610~=6
replace college=. if v960610==. | v960610==9

gen     communitycol=1 if v960610==5 | v960610==4 /* some years of post high school education (including junior or community college) */
replace communitycol=0 if v960610~=5 & v960610~=4
replace communitycol=. if v960610==. | v960610==9

gen     highschool=1 if v960610==3 
replace highschool=0 if v960610~=3
replace highschool=. if v960610==. | v960610==9

gen     juniorhigh=1 if v960607==8 /* 8 years of schooling completed */
replace juniorhigh=0 if v960607~=8 
replace juniorhigh=. if v960607==. | v960607==99 

/* Covariates */
/* Limted  Set */
gen      age=v960605  
replace  age=. if v960605==99 | v960605==.

/* age dummies used for robustness only */
gen      agedu18_29=.
replace  agedu18_29=0 if age~=.
replace  agedu18_29=1 if age>=18 & age<=29
gen      agedu30_44=.
replace  agedu30_44=0 if age~=.
replace  agedu30_44=1 if age>=30 & age<=44
gen      agedu45_59=.
replace  agedu45_59=0 if age~=.
replace  agedu45_59=1 if age>=45 & age<=59

gen     male=v960066
replace male=0 if v960066==2
replace male=. if v960066==.
gen     race=v960067
replace race=. if v960067==. | v960067==9
label   define race 1 White 2 Black 3 Indian 4 Asian
label   values race race
tab     race, gen(RACE)
rename  RACE1 White
rename  RACE2 Black
rename  RACE3 Indian
rename  RACE4 Asian
drop    race

/* Extensive Set */
gen     YUrecoding=1 if v960699==11 | v960699==21 | v960699==22 
replace YUrecoding=0 if v960699==12 | v960699==12 | v960699==23 
gen     TUmember=1 if v960698==1 & YUrecoding==1
replace TUmember=0 if v960698==5 | YUrecoding==0
drop    YUrecoding
gen     partyid=v960420
replace partyid=. if v960420==. | v960420==7 | v960420==8 | v960420==9
label   values partyid v960420
gen     house=1 if v960714==1
replace house=0 if v960714~=1
replace house=. if v960714==. | v960714==9 
gen     ideology=2 if v960368==1
replace ideology=1 if v960368==3 
replace ideology=0 if v960368==5
label   define ideology 2 Liberal 1 Moderate 0 Conservative
label   values ideology ideology 


/* Sample weight */
gen weight=v960003
/* *************************************************************************************************************************** */
* End HH2006 replication code

* We created an additional trade variable with DKNOs included rather than treated
* as missing data
* Note that for trade_opinion, 1=favor new limits, 0=oppose new limits, 2=DKNO
gen     trade_opinion2=.
replace trade_opinion2=1 if v961327==1
replace trade_opinion2=0 if v961327==5
replace trade_opinion2=2 if v961327==0
replace trade_opinion2=2 if v961327==8

* These commands give the marginal effects for the 1996 ANES reported in Figure 3. 
* The Figure displays the confidence intervals produced below.
svyset weight
svy: mlogit trade_opinion2 i.juniorhigh i.highschool i.communitycol i.college i.graduate White Black Indian age male

* Marginal effects on Pr(Support new limits) for "DKNO modeled" using 1996 ANES
margins, dydx(juniorhigh) at(highschool=0 communitycol=0 college=0 graduate=0 White=1 Black=0 Indian=0 age=46 male=0) predict(outcome(1))
margins, dydx(highschool) at(juniorhigh=0 communitycol=0 college=0 graduate=0 White=1 Black=0 Indian=0 age=46 male=0) predict(outcome(1))
margins, dydx(communitycol) at(juniorhigh=0 highschool=0 college=0 graduate=0 White=1 Black=0 Indian=0 age=46 male=0) predict(outcome(1))
margins, dydx(college) at(juniorhigh=0 highschool=0 communitycol=0 graduate=0 White=1 Black=0 Indian=0 age=46 male=0) predict(outcome(1))
margins, dydx(graduate) at(juniorhigh=0 highschool=0 communitycol=0 college=0 White=1 Black=0 Indian=0 age=46 male=0) predict(outcome(1))

* Marginal effects on Pr(Oppose new limits) for "DKNO modeled" using 1996 ANES
margins, dydx(juniorhigh) at(highschool=0 communitycol=0 college=0 graduate=0 White=1 Black=0 Indian=0 age=46 male=0) predict(outcome(0))
margins, dydx(highschool) at(juniorhigh=0 communitycol=0 college=0 graduate=0 White=1 Black=0 Indian=0 age=46 male=0) predict(outcome(0))
margins, dydx(communitycol) at(juniorhigh=0 highschool=0 college=0 graduate=0 White=1 Black=0 Indian=0 age=46 male=0) predict(outcome(0))
margins, dydx(college) at(juniorhigh=0 highschool=0 communitycol=0 graduate=0 White=1 Black=0 Indian=0 age=46 male=0) predict(outcome(0))
margins, dydx(graduate) at(juniorhigh=0 highschool=0 communitycol=0 college=0 White=1 Black=0 Indian=0 age=46 male=0) predict(outcome(0))

* Marginal effects on Pr(DKNO) for "DKNO modeled" using 1996 ANES
margins, dydx(juniorhigh) at(highschool=0 communitycol=0 college=0 graduate=0 White=1 Black=0 Indian=0 age=46 male=0) predict(outcome(2))
margins, dydx(highschool) at(juniorhigh=0 communitycol=0 college=0 graduate=0 White=1 Black=0 Indian=0 age=46 male=0) predict(outcome(2))
margins, dydx(communitycol) at(juniorhigh=0 highschool=0 college=0 graduate=0 White=1 Black=0 Indian=0 age=46 male=0) predict(outcome(2))
margins, dydx(college) at(juniorhigh=0 highschool=0 communitycol=0 graduate=0 White=1 Black=0 Indian=0 age=46 male=0) predict(outcome(2))
margins, dydx(graduate) at(juniorhigh=0 highschool=0 communitycol=0 college=0 White=1 Black=0 Indian=0 age=46 male=0) predict(outcome(2))

* Marginal effects on Pr(Support new limits) for "DKNO dropped" using 1996 ANES
* Because the dependent variable in this model has only two categories, marginal effects on Pr(Oppose) 
* are equal to those on Pr(Support) but with the opposite sign. They are reported in the Figure for ease
* of comparison but are not computed separately here.
svy: probit trade_opinion i.juniorhigh i.highschool i.communitycol i.college i.graduate White Black Indian age male
margins, dydx(juniorhigh) at(highschool=0 communitycol=0 college=0 graduate=0 White=1 Black=0 Indian=0 age=46 male=0)
margins, dydx(highschool) at(juniorhigh=0 communitycol=0 college=0 graduate=0 White=1 Black=0 Indian=0 age=46 male=0)
margins, dydx(communitycol) at(juniorhigh=0 highschool=0 college=0 graduate=0 White=1 Black=0 Indian=0 age=46 male=0)
margins, dydx(college) at(juniorhigh=0 highschool=0 communitycol=0 graduate=0 White=1 Black=0 Indian=0 age=46 male=0)
margins, dydx(graduate) at(juniorhigh=0 highschool=0 communitycol=0 college=0 White=1 Black=0 Indian=0 age=46 male=0)


