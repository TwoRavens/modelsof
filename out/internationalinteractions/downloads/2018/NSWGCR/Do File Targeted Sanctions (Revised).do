** Analysing the variables: Table 1 - Descriptive Statistics

tab sanctionsall

sum sanctionsall

tab targeted

sum targeted

compare sanctionsall targeted

tab sanctionsnohr

tab sanctionsnotrade

tab sanctionshr1

tab sanctionsmulti

tab sanctionsuni

tab statedept

sum statedept

tab armed

sum armed

sum gdppercapitaconstant2005us

sum populationtotal

tab polity2

sum polity2

kdensity gdppercapitaconstant2005us

gen ln_percapita = log(gdppercapitaconstant2005us)

kdensity ln_percapita

kdensity populationtotal

gen ln_pop = log(populationtotal)

kdensity ln_pop



*********** Analysing the effect of Targeted Sanctions on the Protection of Rights to Physical Integrity 1992-2008

***** Table 2 - Ordered Logistic Regression, standard errors clustered on country


Database: 1992 - 2008

xtset countryname1 year

 
ologit amnesty targeted L.amnesty, cluster (countryname1)
estimates store m1
 
ologit amnesty targeted sanctionsall armed polity2 ln_percapita ln_pop L.amnesty, cluster (countryname1)
estimates store m2
   
ologit amnesty L.targeted L.sanctionsall L.armed L.polity2 L.ln_percapita L.ln_pop L.amnesty, cluster (countryname1)
estimates store m3

ologit physint targeted L.physint, cluster (countryname1)
estimates store m4

ologit physint targeted sanctionsall armed polity2 ln_percapita ln_pop L.physint, cluster (countryname1)
estimates store m5
   
ologit physint L.targeted L.sanctionsall L.armed L.polity2 L.ln_percapita L.ln_pop L.physint, cluster (countryname1)
estimates store m6 


estout m*, style (smcl) /*
*/ cells (b (star fmt (2)) se (par fmt (2))) /*
*/ varlabels (_cons Intercept) stats (N)


************** This is table 3 - Impact of Targeted Sanctions on the Protection of Rights to Physical Integrity 
************** - Table 3 - Ordered Logistic Regression, reporting odds ratio, standard errors clustered on country, from Model 3 above

ologit amnesty L.targeted L.sanctionsall L.armed L.polity2 L.ln_percapita L.ln_pop L.amnesty, cluster (countryname1) or



*************** Table 4 – Predicted Probability of Repression Across Time: Targeted Sanctions, 1992-2008(from model 3 above) - PTS data


estsimp ologit amnesty Ltargeted Lsanctionsall Larmed Lpolity2 Lpercapita Lpop Lamnesty

setx targeted 0 Lamnesty mean Larmed mean Lpolity2 mean Lpercapita mean Lpop mean Lsanctionsall mean if amnesty==5

setx Ltargeted 1 Lamnesty mean Larmed mean Lpolity2 mean Lpercapita mean Lpop mean Lsanctionsall mean if amnesty==5

. simqi, prval (1 2 3 4 5)

setx Ltargeted 0 Lamnesty mean Larmed mean Lpolity2 mean Lpercapita mean Lpop mean Lsanctionsall mean if amnesty==4

. simqi, prval (1 2 3 4 5)

setx Ltargeted 1 Lamnesty mean Larmed mean Lpolity2 mean Lpercapita mean Lpop mean Lsanctionsall mean if amnesty==4

. simqi, prval (1 2 3 4 5)

 setx Ltargeted 0 Lamnesty mean Larmed mean Lpolity2 mean Lpercapita mean Lpop mean Lsanctionsall mean if amnesty==3

. simqi, prval (1 2 3 4 5)

 setx Ltargeted 1 Lamnesty mean Larmed mean Lpolity2 mean Lpercapita mean Lpop mean Lsanctionsall mean if amnesty==3

. simqi, prval (1 2 3 4 5)

setx Ltargeted 0 Lamnesty mean Larmed mean Lpolity2 mean Lpercapita mean Lpop mean Lsanctionsall mean if amnesty==2

. simqi, prval (1 2 3 4 5)

setx Ltargeted 1 Lamnesty mean Larmed mean Lpolity2 mean Lpercapita mean Lpop mean Lsanctionsall mean if amnesty==2

. simqi, prval (1 2 3 4 5)

setx Ltargeted 0 Lamnesty mean Larmed mean Lpolity2 mean Lpercapita mean Lpop mean Lsanctionsall mean if amnesty==1

. simqi, prval (1 2 3 4 5)

setx Ltargeted 1 Lamnesty mean Larmed mean Lpolity2 mean Lpercapita mean Lpop mean Lsanctionsall mean if amnesty==1

. simqi, prval (1 2 3 4 5)



************** ANNEX:  Analysing the effect of targeted sanctions on other variables for Protection of Rights to Physical Integrity

************ Table 1 of Annex - Impact of Conventional Economic Sanctions on the Protection of Rights to Physical Integrity 1976-2008 (PTS Data)
************ Ordered Logistic Regression, standard errors clustered on country

Database: 1976 - 2008

xtset countryname1 year


ologit statedept L.statedept sanctionsall, cluster (countryname1)
estimates store m1

ologit statedept L.statedept sanctionsnotrade, cluster (countryname1)
estimates store m2

ologit statedept L.statedept sanctionsall armed polity2 ln_percapita ln_pop, cluster (countryname1)
estimates store m3

ologit statedept L.statedept sanctionsnotrade armed polity2 ln_percapita ln_pop, cluster (countryname1)
estimates store m4

estout m*, style (smcl) /*
*/ cells (b (star fmt (2)) se (par fmt (2))) /*
*/ varlabels (_cons Intercept) stats (N)



************* Table 2 of annex: Impact of Targeted Sanctions on Killings 1992 – 2008 (Data: CIRI Killings Indicator)

************** Ordered Logistic Regression, standard errors clustered on country

Database 1992 - 2008

ologit kill targeted, cluster (countryname1)
 estimates store m1
 
ologit kill targeted L.kill, cluster (countryname1)
estimates store m2
 
ologit kill targeted sanctionsall armed polity2 ln_percapita ln_pop L.kill, cluster (countryname1)
   estimates store m3
   
ologit kill L.targeted L.sanctionsall L.armed L.polity2 L.ln_percapita L.ln_pop L.kill, cluster (countryname1)
 estimates store m4
 

estout m*, style (smcl) /*
*/ cells (b (star fmt (2)) se (par fmt (2))) /*
*/ varlabels (_cons Intercept) stats (N)

************ Table 3 of annex - Impact of Targeted Sanctions on Disappearances 1992 – 2008 (Data: CIRI Disappearances Indicator)
************ Ordered Logistic Regression, standard errors clustered on country

ologit disap targeted, cluster (countryname1)
 estimates store m1
 
ologit disap targeted L.disap, cluster (countryname1)
estimates store m2
 
ologit disap targeted sanctionsall armed polity2 ln_percapita ln_pop L.disap, cluster (countryname1)
estimates store m3
   
ologit disap L.targeted L.sanctionsall L.armed L.polity2 L.ln_percapita L.ln_pop L.disap, cluster (countryname1)
estimates store m4
 

estout m*, style (smcl) /*
*/ cells (b (star fmt (2)) se (par fmt (2))) /*
*/ varlabels (_cons Intercept) stats (N)

************** Table 4 of annex - Impact of Targeted Sanctions on Torture 1992 – 2008 (Data: CIRI Torture Indicator)
************** Ordered Logistic Regression, standard errors clustered on country

xtset countryname1 year

ologit tort targeted, cluster (countryname1)
estimates store m1
 
ologit tort targeted L.tort, cluster (countryname1)
estimates store m2
 
ologit tort targeted sanctionsall armed polity2 ln_percapita ln_pop L.tort, cluster (countryname1)
estimates store m3
   
ologit tort L.targeted L.sanctionsall L.armed L.polity2 L.ln_percapita L.ln_pop L.tort, cluster (countryname1)
estimates store m4
 

estout m*, style (smcl) /*
*/ cells (b (star fmt (2)) se (par fmt (2))) /*
*/ varlabels (_cons Intercept) stats (N)



**************** Table 5 of annex - Impact of Targeted Sanctions on Political Imprisonment 1992 – 2008 (Data: CIRI Political Imprisonment Indicator)
**************** Ordered Logistic Regression, standard errors clustered on country

xtset countryname1 year

ologit polpris targeted, cluster (countryname1)
 estimates store m1
 
ologit polpris targeted L.polpris, cluster (countryname1)
estimates store m2

ologit polpris targeted sanctionsall armed polity2 ln_percapita ln_pop L.polpris, cluster (countryname1)
estimates store m3
   
ologit polpris L.targeted L.sanctionsall L.armed L.polity2 L.ln_percapita L.ln_pop L.polpris, cluster (countryname1)
estimates store m4


estout m*, style (smcl) /*
*/ cells (b (star fmt (2)) se (par fmt (2))) /*
*/ varlabels (_cons Intercept) stats (N)


******************************** Not on paper - Predicted Probability of Repression Across Time: Targeted Sanctions, 1992-2008 - CIRI data

estsimp ologit physint Ltargeted Lsanctionsall Larmed Lpolity2 Lpercapita Lpop Lphysint

setx Ltargeted 0 Lphysint mean Larmed mean Lpolity2 mean Lpercapita mean Lpop mean Lsanctionsall mean if physint==8

. simqi, prval (1 2 3 4 5 6 7 8)

setx Ltargeted 1 Lphysint mean Larmed mean Lpolity2 mean Lpercapita mean Lpop mean Lsanctionsall mean if physint==8

. simqi, prval (1 2 3 4 5 6 7 8)

setx Ltargeted 0 Lphysint mean Larmed mean Lpolity2 mean Lpercapita mean Lpop mean Lsanctionsall mean if physint==7

. simqi, prval (1 2 3 4 5 6 7 8)

setx Ltargeted 1 Lphysint mean Larmed mean Lpolity2 mean Lpercapita mean Lpop mean Lsanctionsall mean if physint==7

. simqi, prval (1 2 3 4 5 6 7 8)

setx Ltargeted 0 Lphysint mean Larmed mean Lpolity2 mean Lpercapita mean Lpop mean Lsanctionsall mean if physint==6

. simqi, prval (1 2 3 4 5 6 7 8)

setx Ltargeted 1 Lphysint mean Larmed mean Lpolity2 mean Lpercapita mean Lpop mean Lsanctionsall mean if physint==6

. simqi, prval (1 2 3 4 5 6 7 8)

setx Ltargeted 0 Lphysint mean Larmed mean Lpolity2 mean Lpercapita mean Lpop mean Lsanctionsall mean if physint==5

. simqi, prval (1 2 3 4 5 6 7 8)

setx Ltargeted 1 Lphysint mean Larmed mean Lpolity2 mean Lpercapita mean Lpop mean Lsanctionsall mean if physint==5

. simqi, prval (1 2 3 4 5 6 7 8)

setx Ltargeted 0 Lphysint mean Larmed mean Lpolity2 mean Lpercapita mean Lpop mean Lsanctionsall mean if physint==4

. simqi, prval (1 2 3 4 5 6 7 8)

setx Ltargeted 1 Lphysint mean Larmed mean Lpolity2 mean Lpercapita mean Lpop mean Lsanctionsall mean if physint==4

. simqi, prval (1 2 3 4 5 6 7 8)

setx Ltargeted 0 Lphysint mean Larmed mean Lpolity2 mean Lpercapita mean Lpop mean Lsanctionsall mean if physint==3

. simqi, prval (1 2 3 4 5 6 7 8)

setx Ltargeted 1 Lphysint mean Larmed mean Lpolity2 mean Lpercapita mean Lpop mean Lsanctionsall mean if physint==3

. simqi, prval (1 2 3 4 5 6 7 8)

setx Ltargeted 0 Lphysint mean Larmed mean Lpolity2 mean Lpercapita mean Lpop mean Lsanctionsall mean if physint==2

. simqi, prval (1 2 3 4 5 6 7 8)

setx Ltargeted 1 Lphysint mean Larmed mean Lpolity2 mean Lpercapita mean Lpop mean Lsanctionsall mean if physint==2

. simqi, prval (1 2 3 4 5 6 7 8)

setx Ltargeted 0 Lphysint mean Larmed mean Lpolity2 mean Lpercapita mean Lpop mean Lsanctionsall mean if physint==1

. simqi, prval (1 2 3 4 5 6 7 8)

setx Ltargeted 1 Lphysint mean Larmed mean Lpolity2 mean Lpercapita mean Lpop mean Lsanctionsall mean if physint==1

. simqi, prval (1 2 3 4 5 6 7 8)
