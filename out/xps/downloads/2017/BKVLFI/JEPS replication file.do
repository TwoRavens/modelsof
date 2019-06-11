/*Analyses DO file for Football and Public Opinion - A Partial Replication, Busby and Druckman
January 9, 2017; updated and cleaned October 18, 2017*/

set maxvar 30000
*First, load in the data (change the filepath to match your local directory:*/
use "\\Client\C$\Users\busby\OneDrive\For Jamie\Irrelevant Effects\2016\Data\Football 2016 Replication Data 10-13-17 (Stata 13).dta"


***Table 1:***
*Clemson
ttest papprove, by(condition), if condition==1 | condition == 2
ttest collsat, by(condition), if condition==1 | condition == 2
ttest pospan, by(condition), if condition==1 | condition == 2
ttest negpan, by(condition), if condition==1 | condition == 2
ttest econstat, by(condition), if condition==1 | condition == 2
ttest popefav, by(condition), if condition==1 | condition == 2
ttest lifesat, by(condition), if condition==1 | condition == 2
ttest collid, by(condition), if condition==1 | condition == 2
ttest postsm, by(condition), if condition==1 | condition == 2

*Alabama
ttest papprove, by(condition), if condition==3 | condition == 4
ttest collsat, by(condition), if condition==3 | condition == 4
ttest pospan, by(condition), if condition==3 | condition == 4
ttest negpan, by(condition), if condition==3 | condition == 4
ttest econstat, by(condition), if condition==3 | condition == 4
ttest popefav, by(condition), if condition==3 | condition == 4
ttest lifesat, by(condition), if condition==3 | condition == 4
ttest collid, by(condition), if condition==3 | condition == 4
ttest postsm, by(condition), if condition==3 | condition == 4

***Table 2***
ttest papprove=t2papprove if condition==1
ttest collsat=t2collsat if condition==1
ttest papprove=t2papprove if condition==2
ttest collsat=t2collsat if condition==2


***Results from the appendix***
**Table A.1**
*Clemson:
tab gender if condition==1 | condition==2
tab white if condition==1 | condition==2
summ pid if condition==1 | condition==2
summ income if condition==1 | condition==2, d
summ age if condition==1 | condition==2
*Alabama:
tab gender if condition==3 | condition==4
tab white if condition==3 | condition==4
summ pid if condition==3 | condition==4
summ income if condition==3 | condition==4, d
summ age if condition==3 | condition==4
*Oklahoma:
tab gender if condition==5 | condition==6
tab white if condition==5 | condition==6
summ pid if condition==5 | condition==6
summ income if condition==5 | condition==6, d
summ age if condition==5 | condition==6
*Michigan State:
tab gender if condition==7 | condition==8
tab white if condition==7 | condition==8
summ pid if condition==7 | condition==8
summ income if condition==7 | condition==8, d
summ age if condition==7 | condition==8

**Balance checks (in text, not table)**
*Clemson - no significant predictors
logit post age year gpa topchoice alum income gender white cath ido pid interest wchamp if condition == 1 | condition == 2
*Alabama - significant predictors of age (more likely to be farther along in after-game), income (richer in after-game), and interest (more interested in before game group)
logit post age year gpa topchoice alum income gender white cath ido pid interest wchamp if condition == 3 | condition == 4 
*Oklahoma - suggestive result on income (richer in before-game)
logit post age year gpa topchoice alum income gender white cath ido pid interest wchamp if condition == 5 | condition == 6 
*MSU - no significant predictors
logit post age year gpa topchoice alum income gender white cath ido pid interest wchamp if condition == 7 | condition == 8 
**For imputed commands, see imputation code beginning on lines 282

**Results for Oklahoma and MSU**
*Table A.2
*MSU
ttest papprove, by(condition), if condition==7 | condition == 8
ttest collsat, by(condition), if condition==7 | condition == 8
ttest pospan, by(condition), if condition==7 | condition == 8
ttest negpan, by(condition), if condition==7 | condition == 8
ttest econstat, by(condition), if condition==7 | condition == 8
ttest popefav, by(condition), if condition==7 | condition == 8
ttest lifesat, by(condition), if condition==7 | condition == 8
ttest collid, by(condition), if condition==7 | condition == 8
ttest postsm, by(condition), if condition==7 | condition == 8

*Oklahoma
ttest papprove, by(condition), if condition==5 | condition == 6
ttest collsat, by(condition), if condition==5 | condition == 6
ttest pospan, by(condition), if condition==5 | condition == 6
ttest negpan, by(condition), if condition==5 | condition == 6
ttest econstat, by(condition), if condition==5 | condition == 6
ttest popefav, by(condition), if condition==5 | condition == 6
ttest lifesat, by(condition), if condition==5 | condition == 6
ttest collid, by(condition), if condition==5 | condition == 6
ttest postsm, by(condition), if condition==5 | condition == 6

*Table A.3
ttest papprove=t2papprove if condition==7
ttest collsat=t2collsat if condition==7
ttest papprove=t2papprove if condition==8
ttest collsat=t2collsat if condition==8

**Mediation(in text, not table)**
*Alphas on the emotion items*
alpha elated enthusiastic proud interested 
alpha sad afraid angry hatred bitter contempt worried anxious resentful

regress  papprove post if condition == 1| condition == 2
regress  papprove pospan negpan if condition == 1| condition == 2
regress  papprove post pospan negpan if condition == 1| condition == 2

regress  collsat post if condition == 1| condition == 2
regress  collsat pospan negpan if condition == 1| condition == 2
regress  collsat post pospan negpan if condition == 1| condition == 2

*Table A.4
**Posting on social media**
*posting to social media
*Social media models:
*posting to social media

tab condition, sum(postsm)
regress postsm pospan negpan, r
regress postsm pospan negpan if condition == 1 | condition == 2,r 
regress postsm  post if condition == 1 | condition == 2,r
regress postsm pospan negpan post if condition == 1 | condition == 2,r
regress postsm pospan negpan post age year gpa income gender cath pid interest wcham if condition == 1 | condition == 2,r

regress postsm pospan negpan if condition == 3 | condition == 4, r 
regress postsm  post if condition == 3 | condition == 4,r
regress postsm pospan negpan post if condition == 3 | condition == 4,r
regress postsm pospan negpan post age year gpa income gender cath pid interest wcham if condition == 3 | condition == 4,r

**Over-time robustness checks**

*Table A.5
*Clemson
ttest papprove, by(condition), if (condition==1 | condition == 2) & t2papprove != .
ttest collsat, by(condition), if (condition==1 | condition == 2) & t2collsat != .
ttest pospan, by(condition), if (condition==1 | condition == 2) & t2papprove != .
ttest negpan, by(condition), if (condition==1 | condition == 2) & t2papprove != .
*Alabama
ttest papprove, by(condition), if (condition==3 | condition == 4) & t2papprove != .
ttest collsat, by(condition), if (condition==3 | condition == 4) & t2collsat != .
ttest pospan, by(condition), if (condition==3 | condition == 4) & t2papprove != .
ttest negpan, by(condition), if (condition==3 | condition == 4) & t2papprove != .

*Table A.6
*Modeling nonresponse at time 2
*Clemson
logit time papprove collsat pospan negpan post age year2 gpa income gender cath pid interest wchamp if condition == 1 | condition == 2
*Alabama
logit time papprove collsat pospan negpan post age year2 gpa income gender cath pid interest wchamp if condition == 3 | condition == 4
*Oklahoma
logit time papprove collsat pospan negpan post age year2 gpa income gender cath pid interest wchamp if condition == 5 | condition == 6
*MSU
logit time papprove collsat pospan negpan  post age year2 gpa income gender cath pid interest wchamp if condition == 7 | condition == 8
*See the imputed .do file for details on those analyses

**Robustness checks**
*Table A.7
*Games watched*
tab condition, sum(gamesw)
ttest gamesw, by(condition), if condition == 1 | condition == 2
ttest gamesw, by(condition), if condition == 3 | condition == 4
ttest gamesw, by(condition), if condition == 5 | condition == 6
ttest gamesw, by(condition), if condition == 7 | condition == 8
*State of the union*
tab sunion
tab t2sunion
tab sunion if condition == 1 | condition == 2
tab t2sunion if condition == 1 | condition == 2
tab sunion if condition == 3 | condition == 4
tab t2sunion if condition == 3 | condition == 4
summ t2sunionmedia, d
summ t2sunionmedia if condition == 1 | condition == 2, d
summ t2sunionmedia if condition == 3 | condition == 4, d
summ t2suniontalk, d
summ t2suniontalk if condition == 1 | condition == 2,d
summ t2suniontalk if condition == 3 | condition == 4,d

*Repeating analysese for those who didn't see or hear much about the State of the Union
*(in text, not table)
*Clemson
ttest papprove, by(condition), if (condition==1 | condition == 2) & sunion != 1
ttest collsat, by(condition), if (condition==1 | condition == 2) & sunion != 1
ttest pospan, by(condition), if (condition==1 | condition == 2) & sunion != 1
ttest negpan, by(condition), if (condition==1 | condition == 2) & sunion != 1

ttest papprove, by(condition), if (condition==1 | condition == 2) & t2sunion != 1
ttest collsat, by(condition), if (condition==1 | condition == 2) & t2sunion != 1
ttest pospan, by(condition), if (condition==1 | condition == 2) & t2sunion != 1
ttest negpan, by(condition), if (condition==1 | condition == 2) & t2sunion != 1

ttest papprove, by(condition), if (condition==1 | condition == 2) & t2sunionmedia <3
ttest collsat, by(condition), if (condition==1 | condition == 2) & t2sunionmedia <3
ttest pospan, by(condition), if (condition==1 | condition == 2) & t2sunionmedia <3
ttest negpan, by(condition), if (condition==1 | condition == 2) & t2sunionmedia <3

ttest papprove, by(condition), if (condition==1 | condition == 2)& t2suniontalk <3
ttest collsat, by(condition), if (condition==1 | condition == 2) & t2suniontalk <3
ttest pospan, by(condition), if (condition==1 | condition == 2) & t2suniontalk <3
ttest negpan, by(condition), if (condition==1 | condition == 2) & t2suniontalk <3

*Alabama
ttest papprove, by(condition), if (condition==3 | condition == 4) & sunion != 1
ttest collsat, by(condition), if (condition==3 | condition == 4) & sunion != 1
ttest pospan, by(condition), if (condition==3 | condition == 4) & sunion != 1
ttest negpan, by(condition), if (condition==3 | condition == 4) & sunion != 1

ttest papprove, by(condition), if (condition==3 | condition == 4) & t2sunion != 1
ttest collsat, by(condition), if (condition==3 | condition == 4) & t2sunion != 1
ttest pospan, by(condition), if (condition==3 | condition == 4) & t2sunion != 1
ttest negpan, by(condition), if (condition==3 | condition == 4) & t2sunion != 1

ttest papprove, by(condition), if (condition==3 | condition == 4) & t2sunionmedia <3
ttest collsat, by(condition), if (condition==3 | condition == 4) & t2sunionmedia <3
ttest pospan, by(condition), if (condition==3 | condition == 4) & t2sunionmedia <3
ttest negpan, by(condition), if (condition==3 | condition == 4) & t2sunionmedia <3

ttest papprove, by(condition), if (condition==3 | condition == 4)& t2suniontalk <3
ttest collsat, by(condition), if (condition==3 | condition == 4) & t2suniontalk <3
ttest pospan, by(condition), if (condition==3 | condition == 4) & t2suniontalk <3
ttest negpan, by(condition), if (condition==3 | condition == 4) & t2suniontalk <3

*Results for those who watched the game:
*(in text, not table)
tab condition, sum(wchamp)
*Clemson
ttest papprove, by(condition), if (condition==1 | condition == 2) & wchamp==1
ttest collsat, by(condition), if (condition==1 | condition == 2) & wchamp==1
ttest pospan, by(condition), if (condition==1 | condition == 2) & wchamp==1
ttest negpan, by(condition), if (condition==1 | condition == 2) & wchamp==1

*Alabama
ttest papprove, by(condition), if (condition==3 | condition == 4) & wchamp==1
ttest collsat, by(condition), if (condition==3 | condition == 4) & wchamp==1
ttest pospan, by(condition), if (condition==3 | condition == 4) & wchamp==1
ttest negpan, by(condition), if (condition==3 | condition == 4) & wchamp==1

*Only for those, who, after the fact, reported watching the game
*(in text, not table)
*Clemson
ttest papprove, by(condition), if (condition==1 | condition == 2) & t2wchamp==1
ttest collsat, by(condition), if (condition==1 | condition == 2) & t2wchamp==1
ttest pospan, by(condition), if (condition==1 | condition == 2) & t2wchamp==1
ttest negpan, by(condition), if (condition==1 | condition == 2) & t2wchamp==1

*Alabama
ttest papprove, by(condition), if (condition==3 | condition == 4) & t2wchamp==1
ttest collsat, by(condition), if (condition==3 | condition == 4) & t2wchamp==1
ttest pospan, by(condition), if (condition==3 | condition == 4) & t2wchamp==1
ttest negpan, by(condition), if (condition==3 | condition == 4) & t2wchamp==1

*Only for undergraduate respondents
*(in text, not table)
*Clemson
ttest papprove, by(condition), if (condition==1 | condition == 2) & year<=4
ttest collsat, by(condition), if (condition==1 | condition == 2) & year<=4
ttest pospan, by(condition), if (condition==1 | condition == 2) & year<=4
ttest negpan, by(condition), if (condition==1 | condition == 2) & year<=4
*Alabama
ttest papprove, by(condition), if (condition==3 | condition == 4) & year<=4
ttest collsat, by(condition), if (condition==3 | condition == 4) & year<=4
ttest pospan, by(condition), if (condition==3 | condition == 4) & year<=4
ttest negpan, by(condition), if (condition==3 | condition == 4) & year<=4

*Pope results, by Catholic status
*(in text, not table)
*Clemson
ttest popefav, by(condition), if (condition==1 | condition == 2) & cath==1
ttest popefav, by(condition), if (condition==1 | condition == 2) & cath==0
*Alabama
ttest popefav, by(condition), if (condition==3 | condition == 4) & cath==1
ttest popefav, by(condition), if (condition==3 | condition == 4) & cath==0

*Table A.8
*These data were drawn from Weather Underground
*For Clemson, see this link:
**https://www.wunderground.com/history/airport/KCEU/2016/1/9/DailyHistory.html?req_city=&req_state=&req_statename=&reqdb.zip=&reqdb.magic=&reqdb.wmo=
*For the University of Alabama, see this link:
**https://www.wunderground.com/history/airport/KTCL/2016/1/9/DailyHistory.html?req_city=&req_state=&req_statename=&reqdb.zip=&reqdb.magic=&reqdb.wmo=

**Imputation replications**
*(in text, not table)*
*These commands create the imputed dataset and run the imputed analyses reported
*on in the appendix.
*Let's tweak the format around a bit so that we can use the estimation commands
*in mi (we can't do ttests in that format, but we can do regression)

*Difference variables
gen diff_pap=papprove-t2papprove
gen diff_econ=econstat-t2econstat
gen diff_collsat=collsat-t2collsat
gen diff_popefav=popefav-t2popefav
gen diff_collid=collid-t2collid
gen diff_lifesat=lifesat-t2lifesat
*Test it to see if it produces similar results to the ttests
mean diff_pap, over(condition) level(90)
mean diff_econ, over(condition) level(90)
mean diff_collsat, over(condition) level(90)
mean diff_collid, over(condition) level(90)
mean diff_popefav, over(condition) level(90)
mean diff_lifesat, over(condition) level(90)
*The significance is the same as the ttest

*Now for the imputation
*First set the data
mi set w
mi register imputed papprove econstat collsat collid popefav lifesat t2papprove ///
	t2econstat t2collsat t2collid t2popefav t2lifesat pospan negpan age gpa topchoice ///
	alum income year gender white cath citizen ido pid interest wchamp gamesa gamesw
mi register regular condition post
mi impute chained (regress) papprove econstat collsat collid popefav lifesat t2papprove ///
		t2econstat t2collsat t2collid t2popefav t2lifesat pospan negpan age gpa income ///
		ido pid interest gamesa gamesw year (logit) topchoice alum gender white cath ///
		citizen wchamp = condition post , rseed(60981565) add(200) 
*Generate the differences between t1 and t2:
mi passive: gen diff_pap_i=papprove-t2papprove
mi passive: gen diff_econ_i=econstat-t2econstat
mi passive: gen diff_collsat_i=collsat-t2collsat
mi passive: gen diff_popefav_i=popefav-t2popefav
mi passive: gen diff_collid_i=collid-t2collid
mi passive: gen diff_lifesat_i=lifesat-t2lifesat

*Now let's redo the analyses with the imputed data
*(in text, not table)
*Here are the balance analyses again:
*Clemson - more political interest in the after-game group
mi estimate: logit post age year gpa topchoice alum income gender white cath ido pid interest wchamp if condition == 1 | condition == 2
*Alabama - significant predictors of age (more likely to be farther along in after-game), income (richer in after-game), and interest (more interested in before game group)
mi estimate: logit post age year gpa topchoice alum income gender white cath ido pid interest wchamp if condition == 3 | condition == 4 
*Oklahoma - suggestive result on income (richer in before-game)
mi estimate: logit post age year gpa topchoice alum income gender white cath ido pid interest wchamp if condition == 5 | condition == 6 
*MSU - no significant predictors
mi estimate: logit post age year gpa topchoice alum income gender white cath ido pid interest wchamp if condition == 7 | condition == 8 

*Clemson models, controlling for political interest
*(in text, not table)
mi estimate: regress papprove i.condition interest if condition==1 | condition == 2
mi estimate: regress collsat i.condition interest if condition==1 | condition == 2
mi estimate: regress popefav i.condition interest if condition==1 | condition == 2
mi estimate: regress lifesat i.condition interest if condition==1 | condition == 2
mi estimate: regress econstat i.condition interest if condition==1 | condition == 2
mi estimate: regress collid i.condition interest if condition==1 | condition == 2
mi estimate: regress postsm i.condition interest if condition==1 | condition == 2
mi estimate: regress pospan i.condition interest if condition==1 | condition == 2
mi estimate: regress negpan i.condition interest if condition==1 | condition == 2


*Over time effects with the imputed data
*(in text, not table)
*Looking for significance on the after game group (condition 2) and negative
*estimates which means that the T2 measure is higher (suggesting fading effects)
mi estimate, level(98): mean diff_pap_i if condition == 1 | condition == 2, over(condition)
mi estimate, level(90): mean diff_pap_i if condition == 1 | condition == 2, over(condition)
mi estimate, level(98): mean diff_collsat_i if condition == 1 | condition == 2, over(condition)
mi estimate, level(90): mean diff_collsat_i if condition == 1 | condition == 2, over(condition)

*With controlss (for this, we use the imputed data)
*(in text, not table)
*Models with control varaibles
*Pres approval
mi estimate: regress papprove post age year gpa income gender cath pid interest wcham
mi estimate: regress papprove post age year gpa income gender cath pid interest wcham if condition == 1 | condition == 2
mi estimate: regress papprove post age year gpa income gender cath pid interest wcham if condition == 3 | condition == 4
mi estimate: regress papprove post age year gpa income gender cath pid interest wcham if condition == 5 | condition == 6
mi estimate: regress papprove post age year gpa income gender cath pid interest wcham if condition == 7 | condition == 8

*College satisfaction
mi estimate: regress collsat post age year gpa topchoice alum income gender pid interest wchamp collid
mi estimate: regress collsat post age year gpa topchoice alum income gender pid interest wchamp collid if condition == 1 | condition == 2
mi estimate: regress collsat post age year gpa topchoice alum income gender pid interest wchamp collid if condition == 3 | condition == 4
mi estimate: regress collsat post age year gpa topchoice alum income gender pid interest wchamp collid if condition == 5 | condition == 6
mi estimate: regress collsat post age year gpa topchoice alum income gender pid interest wchamp collid if condition == 7 | condition == 8

*Unimputed
*Pres approval
regress papprove post age year gpa income gender cath pid interest wchamp
regress papprove post age year gpa income gender cath pid interest wcham if condition == 1 | condition == 2
regress papprove post age year gpa income gender cath pid interest wcham if condition == 3 | condition == 4
regress papprove post age year gpa income gender cath pid interest wcham if condition == 5 | condition == 6
regress papprove post age year gpa income gender cath pid interest wcham if condition == 7 | condition == 8

*College satisfaction
regress collsat post age year gpa topchoice alum income gender pid interest wchamp collid
regress collsat post age year gpa topchoice alum income gender pid interest wchamp collid if condition == 1 | condition == 2
regress collsat post age year gpa topchoice alum income gender pid interest wchamp collid if condition == 3 | condition == 4
regress collsat post age year gpa topchoice alum income gender pid interest wchamp collid if condition == 5 | condition == 6
regress collsat post age year gpa topchoice alum income gender pid interest wchamp collid if condition == 7 | condition == 8
