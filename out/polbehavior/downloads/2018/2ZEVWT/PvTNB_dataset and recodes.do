/* 
Protest Via the Null Ballot: Do File to generate dataset 
Version: April 27, 2017
Mollie J. Cohen
*/

use "/Users/molliecohen/Dropbox/AmericasBarometer Grand Merge 2004-2014 (v3.0).dta"
* Dataset used to generate this dataset: LAPOP's Internal Grand Merge (2004-2014) v3.0 

drop if year<2008 

gen close=.
replace close=1 if pais==17 & year==2008
replace close=1 if pais==10 & year==2010
replace close=1 if pais==13 & year==2014
replace close=1 if pais==9 & year==2010
replace close=1 if pais==2 & year==2008
replace close=1 if pais==4 & year==2010
replace close=1 if pais==5 & year==2012
replace close=1 if pais==7 & year==2010
replace close=1 if pais==14 & year==2010
replace close=1 if pais==16 & year==2008
replace close=1 if pais==3 & year==2014 
replace close=1 if pais==6 & year==2014
replace close=1 if pais==12 & year==2014
replace close=1 if pais==11 & year==2012
replace close=0 if close!=1

keep if close==1

***********************
* Dependent variables *
***********************

gen invalid2=0
replace invalid2=1 if vb3_08==0 | vb3_10==0 | vb3_12==0 | vb3n_14==0 | vb3n_14==97

gen abst_null_vote=.
replace abst_null_vote=1 if vb2==2
replace abst_null_vote=2 if invalid2==1
replace abst_null_vote=3 if invalid2==0 & vb2!=2

*invalid vs. abstain
gen ivabstain=.
replace ivabstain=0 if abst_null_vote==2
replace ivabstain=1 if abst_null_vote==1

*invalid vs. valid
gen ivvote=.
replace ivvote=0 if abst_null_vote==2
replace ivvote=1 if abst_null_vote==3
lab var ivvote "Invalid vs. Vote"

*************************
* independent variables *
*************************

*Democracy Variables

lab var ing4 "Support for Democracy"
tab dem2, gen(newdem2)
lab var newdem22 "Prefer Democracy"

gen trust_elec=b47
replace trust_elec=b47a if year==2014 | year==2012


* Performance Variables
gen ownecon_worse=.
replace ownecon_worse=0 if idio2==1 | idio2==2
replace ownecon_worse=1 if idio2==3
lab var ownecon_worse "Negative Personal Econ."

gen natlecon_worse=.
replace natlecon_worse=0 if soct2==1 | soct2==2
replace natlecon_worse=1 if soct2==3
lab var natlecon_worse "Negative National Econ."

alpha n1 n3 n9 n11
factor n1 n3 n9 n11

gen performance=((n1+n3+n9+n11)/4)
lab var performance "Performance"
replace performance=((n9+n11)/2) if year==2014

*Alienation Variables

*Reversing the coding of external efficacy to measure alienation
recode eff1 (7=1)(6=2)(5=3)(4=4)(3=5)(2=6)(1=7), gen(alienate)
lab var alienate "Alienation"

*Recoding so higher values indicate greater interest
recode pol1 (1=4)(2=3)(3=2)(4=1), gen(interest)
lab var interest "Political Interest"


*Political Knowledge

*Recoding so that "1" is the correct response and "0" is incorrect"
local know="gi1 gi4 gi2 gi3 gi5"
foreach x of local know {
recode `x'(2=0)(1=1), gen(`x'r)
}

*Different knowledge variables are included for different years, reflected below.
gen knowledge=.
replace knowledge=((gi1r+gi4r+gi7r)/3) if year==2012
lab var knowledge "Political Knowledge"

replace knowledge=((gi1r+gi4r+gi2r+gi3r+gi5r)/5) if year==2008
lab var knowledge "Political Knowledge"

replace knowledge=((gi1r+gi3r+gi4r)/3) if year==2010
lab var knowledge "Political Knowledge"

replace knowledge=((gi1r+gi4r+gi7r)/3) if year==2014
lab var knowledge "Political Knowledge"

replace knowledge=0 if knowledge==.
lab var knowledge "Knowledge"

*Protest Participation
recode prot3 (2=0)(1=1), gen(protest)
replace protest=1 if prot2==1
replace protest=0 if prot2==2 | prot2==3
lab var protest "Protest Participation"

*Contextual Variables
gen compulsory=.
replace compulsory=1 if pais==1 | pais==4 | pais==9 | pais==10 | pais==11 | pais==12 | pais==13 | pais==14 | pais==15 |  pais==17
replace compulsory=0 if compulsory!=1
replace compulsory=0 if pais==13 & year>2012
lab var compulsory "Mandatory Voting"

gen secondrd=.
replace secondrd=1 if pais==13 | pais==11 | pais==14 | pais==2 | pais==3 | pais==6 
replace secondrd=0 if pais==10 | pais==4 | pais==5 | pais==7 | pais==16 | pais==9 | pais==12 | pais==17
lab var secondrd "Second Round Elections"

*Additional control variables
gen female=mujer
gen agesq=q2*q2
tab pais, gen(pais)

* Keeping only those variables used in subsequent analyses:
keep abst_null_vote  ing4 newdem22  trust_elec performance ownecon_worse natlecon_worse alienate  interest knowledge protest female q2 agesq ur ed quintall pais2 pais3 pais4 pais5 pais6 pais7 pais8 pais9 pais10 pais11 pais12 pais13 pais14 pais invalid2 compulsory secondrd n1 n3 n9 n11 dem2 vb2 vb3_08 vb3_10 vb3_12 eff1 eff2 pol1 mujer soct2 idio2 pol1 vb20 year  municipio municipio04 municipio06 municipio08 municipio10 cluster ur tamano fecha wt idnum idnum_14 estratopri estratosec strata upm prov cluster ur tamano idiomaq fecha wt weight1500

save "/Users/molliecohen/Dropbox/Protest via the Null Ballot/political behavior/clean analysis/PvTNB main data.dta"
*Data file on Dataverse titled "PvTNB main data.dta"

************************************

*Appendix Table D1 uses a file titled "protest motivations.dta". This file is created using the 2014 AmericasBarometer data.
*All independent variables were generated using the same code as above, except for abst_null_vote, protest, and second level variables.


