********************************************************
** Title: Economic Reasoning with a Racial Hue: Is the Immigration Consensus Purely Race Neutral? **
** Analysis of SSI Dataset
** Authors: Ben Newman and Neil Malhotra **
** Date: November 7, 2017 **
********************************************************


******************************************* 
**CODEBOOK
***************************************** 
/*
admitscale_01: Seven-point immigrant acceptance scale (0=asboluately not accept; 1 definitely accept)
skill: skill manipulation variable in experment (1=high-skilled immigrant; 0=low-skilled immigrant)
mexico: country of immigrant (1= Mexico; 0 = Sweden)
sweden: country of immigrant (0= Mexico; 1 = Sweden)
skillbelief: belief in sociotropic value of workers (0=low skilled more important; 1 = high skilled more important)
hisplazy: trait rating of Hispanics as lazy (5=extremely well; 1 = not well at all)
hispintel: trait rating of Hispanics as intelligent (5=extremely well; 1 = not well at all)
hispviol: trait rating of Hispanics as violent (5=extremely well; 1 = not well at all)
whitelazy: trait rating of whites as lazy (5=extremely well; 1 = not well at all)
whiteintel: trait rating of whites as intelligent (5=extremely well; 1 = not well at all)
whiteviol: trait rating of whites as violent (5=extremely well; 1 = not well at all)
AW: gender (1=male, 2=female, 3 = other)
Q910: education (Less than high school (1); High school diploma (2); Associates degree (3); Bachelors degree (4) Graduate degree (5))
Q94: race (White (1); Asian (2); Black (3); Hispanic or Latino/a (4); Other (5))
Q95: age (Born in 1999 (4) to 1915 (88))
Q98: income (Less than $25,000 (1); $25,000-$49,999 (2); $50,000-$74,999 (3); $75,000-$99,999 (4); $100,000-$249,000 (5); $250,000-$1 million (6); More than $1 million (7))
Q72: PID (Democrat (1); Republican (2); Something else (3))
*/

/* Upload Data */

use immigration_ssi.dta, clear


* Create Scale for anti-Hispanic prejudice

alpha hisplazy hispintel hispviol, gen(hprej2)
gen hprej2_01 = (hprej2-1)/4
	
* Create Scale for anti-white prejudice

alpha whitelazy whiteintel whiteviol, gen(wprej)

gen wprej_01 = (wprej+1)/6


*Table A2; Figure 2, Panel B


gen country = mexico==1 if (mexico==1|sweden==1)
gen skillXcountry = skill*country
gen skillXwprej_01 = skill*wprej_01
gen skillXhprej2_01 = skill*hprej2_01

* Pooled
reg admitscale_01 skill if Q94~=4
* By Country
reg admitscale_01 skill country skillXcountry if Q94~=4
lincom skill + skillXcountry
* Interaction with Prejudice (Sweden)
reg admitscale_01 skill wprej_01 skillXwprej_01 if sweden==1 & Q94~=4
lincom skill + skillXwprej_01
* Interaction with Prejudice (Mexico)
reg admitscale_01 skill hprej2_01 skillXhprej2_01 if mexico==1 & Q94~=4
lincom skill + skillXhprej2_01

** three-way interaction reported in text

gen prejh = hprej2_01 if country==1
gen prejw = wprej_01 if country==0
egen prej_01 = rowtotal (prejh prejw), miss

gen skillXprej_01 = skill*prej_01
gen countryXprej_01 = country*prej_01
gen skillXcountryXprej_01 = skill*country*prej_01

reg admitscale_01 skill country prej_01 skillXcountry skillXprej_01 countryXprej_01 skill*country*prej_01


* Table A4, Figure 3, Panel B

gen skillXskillbelief = skill*skillbelief 

*Pooled
reg admitscale_01 skill skillbelief skillXskillbelief if Q94~=4
lincom skill + skillXskillbelief

*Sweden
reg admitscale_01 skill skillbelief skillXskillbelief if Q94~=4 & sweden==1
lincom skill + skillXskillbelief

*Mexico
reg admitscale_01 skill skillbelief skillXskillbelief if Q94~=4 & mexico==1
lincom skill + skillXskillbelief

** three-way interaction reported in text

gen skillbeliefXcountry = skillbelief*country
gen skillXskillbeliefXcountry = skill*skillbelief*country

reg admitscale_01 skill skillbelief country skillXcountry skillXskillbelief skillbeliefXcountry skillXskillbeliefXcountry if Q94~=4 




// Summary Statistic for Online Appendix Table A0
tab AW // gender
tab Q910  // education
tab Q94 // race
gen age = Q95 + 14
sum age, detail // age
tab Q98 // income
tab Q72  // PID