********************************************************
** Title: Economic Reasoning with a Racial Hue: Is the Immigration Consensus Purely Race Neutral? **
** Analysis of MTurk Dataset
** Authors: Ben Newman and Neil Malhotra **
** Date: November 7, 2017 **
********************************************************


******************************************* 
**CODEBOOK
***************************************** 
/*
acceptscale_01: Seven-point immigrant acceptance scale (0=asboluately not accept; 1 definitely accept)
skill: skill manipulation variable in experment (1=high-skilled immigrant; 0=low-skilled immigrant)
info: value of low-skilled immigration information manipulation variable in experiment (1=received info; 0=control group)
country: country of origin of immigrant (1=Mexico; 0=Canada)
skillbelief_01: belief in sociotropic value of workers (0=low skilled more important; .5 = both workers equally important; 1 = high skilled more important)
hisplazy: trait rating of Hispanics as lazy (1=extremely well; 5 = not well at all)
hispintel: trait rating of Hispanics as intelligent (1=extremely well; 5 = not well at all)
hispviol: trait rating of Hispanics as violent (1=extremely well; 5 = not well at all)
hispilleg: trait rating of Hispanics as illegal (1=extremely well; 5 = not well at all)
whitelazy: trait rating of whites as lazy (1=extremely well; 5 = not well at all)
whiteintel: trait rating of whites as intelligent (1=extremely well; 5 = not well at all)
whiteviol: trait rating of whites as violent (1=extremely well; 5 = not well at all)
whiteilleg: trait rating of whites as illegal (1=extremely well; 5 = not well at all)
eng_rate_01: English Proficiency (0=Low, .5 = Medium, 1 = High)
assim_rate_01: Cultural Assimilation (0=Low, .5 = Medium, 1 = High)
relig_rate_01: Christian Religion (0=Low, .5 = Medium, 1 = High)
edu_rate_01: Level of Education (0=Low, .5 = Medium, 1 = High)
skill_rate_01: Skill Level (0=Low, .5 = Medium, 1 = High)
employ_rate_01: Likelihood of Employment (0=Low, .5 = Medium, 1 = High)
female: 2 = female; 1 = male
educ: 1= less than HS; 2 = high school; 3 = associate's; 4 = bachelor's; 5 = graduate degree
race: see labels
age: born in 1920 (1) to 2000 (81)
income: Less than $20,000 (1); $20,000-$39,999 (2); $40,000-$59,999 (3); $60,000-$79,999 (4); $80,000-$99,000 (5); 100,00-$199,999 (6); Over $200,000 (7)
employment: Full-time (1); Part-time (2); Temporarily laid off (3); Unemployed (4); Retired (5); Permanently disabled (6); Homemaker (7); Student (8); Other (9)
pid: Democrat (1); Independent (2); Republican (3); Other (4)
*/

/* Upload Data */

use immigration_mturk.dta, clear




* Create Scale for anti-Hispanic prejudice

alpha hisplazy hispintel hispviol hispilleg, gen(hprej)
omscore hprej
drop hprej
rename rr_hprej hprej
gen hprej_01 = (hprej+.5)/4


* Create Scale for anti-white prejudice

alpha whitelazy whiteintel whiteviol whiteilleg, gen(wprej)
omscore wprej
drop wprej
rename rr_wprej wprej
gen wprej_01 = (wprej+.5)/4


*Results: Replicating the Skill Premium and Critical Test #1

* Table A1; Figure 2 (Panel A)

reg acceptscale_01 skill if info==0

gen skillXcountry = skill*country

reg acceptscale_01 skill country skillXcountry if info==0
lincom skill + skillXcountry

gen skillXhprej_01 = skill*hprej_01 
gen skillXwprej_01 = skill*wprej_01

reg acceptscale_01 skill wprej_01 skillXwprej_01 if info==0&country==0
lincom skill + skillXwprej_01

reg acceptscale_01 skill hprej_01 skillXhprej_01 if info==0&country==1
lincom skill + skillXhprej_01



** Three way interaction term models for p-values reported in text

* Create common prejudice measure
gen prejh = hprej_01 if country==1
gen prejw = wprej_01 if country==0
egen prej_01 = rowtotal (prejh prejw), miss

gen skillXprej_01 = skill*prej_01
gen prej_01Xcountry = prej_01*country
gen skillXprej_01Xcountry = skill*prej_01*country


reg acceptscale_01 skill prej_01 country skillXprej_01 skillXcountry prej_01Xcountry skillXprej_01Xcountry if info==0
lincom skillXprej_01Xcountry + skillXcountry


*Results: Critical Test #2

tab skillbelief_01  // distribution of skill belief variable

* Table A3, Figure 3A

** Test of Linearity **

reg acceptscale_01 skill if info==0&skillbelief_01==.5

*Pooled*

gen skillXskillbelief_01 = skill*skillbelief_01

reg acceptscale_01 skill skillbelief_01 skillXskillbelief_01 if info==0
lincom skill + (skillXskillbelief_01*.5)
lincom skill + skillXskillbelief_01

*Canada*

reg acceptscale_01 skill skillbelief_01 skillXskillbelief_01 if info==0&country==0
lincom skill + (skillXskillbelief_01*.5)
lincom skill + skillXskillbelief_01


*Mexico*

reg acceptscale_01 skill skillbelief_01 skillXskillbelief_01 if info==0&country==1
lincom skill + (skillXskillbelief_01*.5)
lincom skill + skillXskillbelief_01


*Results: Critical Test #3 

gen skillXinfo = skill*info

* Table A5, Figure 4A

*Pooled*

reg acceptscale_01 skill info skillXinfo
lincom skill + skillXinfo

* Canada

reg acceptscale_01 skill info skillXinfo if country==0
lincom skill + skillXinfo

* Mexico

reg acceptscale_01 skill info skillXinfo if country==1
lincom skill + skillXinfo

** Three-way Interaction Reported in text

gen infoXcountry = info*country
gen skillXinfoXcountry = skill*info*country

reg acceptscale_01 skill info country skillXinfo infoXcountry skillXcountry skillXinfoXcountry

* Table A6, Figure 4B

*/ mean of wprej_01 is .303; mean of hprej_01 is .34

*Canada - Low Prejudice (below mean)
reg acceptscale_01 skill info skillXinfo if country==0& wprej_01<.303&wprej_01!=.
lincom skill + skillXinfo

*Canada - High Prejudice
reg acceptscale_01 skill info skillXinfo if country==0& wprej_01>.303&wprej_01!=.
lincom skill + skillXinfo

*Mexico - Low Prejudice

reg acceptscale_01 skill info skillXinfo if country==1& hprej_01<.34&hprej_01!=.
lincom skill + skillXinfo

*Mexico - High Prejudice

reg acceptscale_01 skill info skillXinfo if country==1& hprej_01>.34&hprej_01!=.
lincom skill + skillXinfo

* Three-way interaction reported in text

gen prejh_bin = hprej_01>.34 if country==1&hprej_01!=.
gen prejw_bin = wprej_01>.303 if country==0&wprej_01!=.
egen prej_01_bin = rowtotal (prejh_bin prejw_bin), miss

gen skillXprej_01_bin = skill*prej_01_bin
gen infoXprej_01_bin = info*prej_01_bin
gen skillXinfoXprej_01_bin = skill*info*prej_01_bin

reg acceptscale_01 skill info prej_01_bin skillXinfo skillXprej_01_bin infoXprej_01_bin skillXinfoXprej_01_bin


*Results: Critical Test #4

*Figure 5 (OLS)

reg eng_rate_01 skill if country==1
reg eng_rate_01 skill if country==0
reg assim_rate_01 skill if country==1
reg assim_rate_01 skill if country==0
reg relig_rate_01 skill if country==1
reg relig_rate_01 skill if country==0
reg edu_rate_01 skill if country==1
reg edu_rate_01 skill if country==0
reg skill_rate_01 skill if country==1
reg skill_rate_01 skill if country==0
reg employ_rate_01 skill if country==1
reg employ_rate_01 skill if country==0

* interaction terms reported in text

reg eng_rate_01 skill country skillXcountry
reg assim_rate_01 skill country skillXcountry


*Table A7 (Ordered Logit)

ologit eng_rate_01 skill if country==1
ologit eng_rate_01 skill if country==0
ologit assim_rate_01 skill if country==1
ologit assim_rate_01 skill if country==0
ologit relig_rate_01 skill if country==1
ologit relig_rate_01 skill if country==0
ologit edu_rate_01 skill if country==1
ologit edu_rate_01 skill if country==0
ologit skill_rate_01 skill if country==1
ologit skill_rate_01 skill if country==0
ologit employ_rate_01 skill if country==1
ologit employ_rate_01 skill if country==0

* Table A0

tab female
tab educ
tab race
gen yearborn = 1919+age
gen age2 = 2016-yearborn 
sum age2, detail
sum income, detail
tab employment
tab pid
