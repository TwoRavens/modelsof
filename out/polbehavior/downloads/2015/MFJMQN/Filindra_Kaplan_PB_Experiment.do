
* use "C:\Work_Kaplan\gun_control\Qualtrics_Data_Final\Filindra_Kaplan_PB_Experiment.dta", clear

* log using "C:\Work_Kaplan\gun_control\Qualtrics_Data_Final\Filindra_Kaplan_PB_Experiment.log", replace

* must open "Filindra_Kaplan_PB_Experiment.dta" datafile before running this do file

gen time1=(V9-V8)/60000

* following drops (1%, 13 cases) at both ends)
drop if time1<8.65
drop if time1>161

***********************************
* DV: Beliefs/Attitudes 

gen gprotects=(4-Q6_3_1)/3
gen gdanger=(Q6_3_2-1)/3
gen safenhood=(Q6_3_3-1)/3
gen gsports=(Q6_3_4-1)/3
gen gnogood=(Q6_3_6-1)/3
gen gsafer=(4-Q6_3_7)/3
gen police=(Q6_3_8-1)/3
gen ggovt=(4-Q6_3_9)/3

sum gprotects gdanger safenhood gsports gnogood gsafer police ggovt

pwcorr gprotects gdanger safenhood gsports gnogood gsafer police ggovt

factor gprotects gdanger safenhood gsports gnogood gsafer police ggovt, fac(1)

alpha gprotects gdanger safenhood gsports gnogood gsafer police ggovt

egen dvbeliefs1=rowmean(gprotects gdanger safenhood gsports gnogood gsafer police ggovt)

gen dvbeliefs=dvbeliefs1*8

gen dvbeliefs0=gprotects+gdanger+safenhood+gsports+gnogood+gsafer+police+ggovt

******************************
* DV: Policy Preferences

gen waitper=(Q6_1_1-1)/3
gen assaultban=(Q6_1_4-1)/3
gen limitnum=(Q6_1_5-1)/3
gen feddb=(Q6_1_14-1)/3
gen ammoban=(Q6_2_1-1)/3
gen triglock=(Q6_2_2-1)/3
gen hgunban=(Q6_2_4-1)/3

sum waitper assaultban limitnum feddb ammoban triglock hgunban

pwcorr waitper assaultban limitnum feddb ammoban triglock hgunban

factor waitper assaultban limitnum feddb ammoban triglock hgunban

alpha waitper assaultban limitnum feddb ammoban triglock hgunban

egen dvalex1=rowmean(waitper assaultban limitnum feddb ammoban triglock hgunban)

gen dvalex=dvalex1*7

gen dvalex0=waitper+assaultban+limitnum+feddb+ammoban+triglock+hgunban


***************************

****************************

* Symbolic racism
factor Q12_1_1 Q12_1_2 Q12_1_3 Q12_1_4, fac(1)
predict symrace1

gen srace1=(Q12_1_1-1)/3
gen srace2=(4-Q12_1_2)/3
gen srace3=(4-Q12_1_3)/3
gen srace4=(Q12_1_4-1)/3
pwcorr srace1 srace2 srace3 srace4
egen symracei=rowmean(srace1 srace2 srace3 srace4)

*****************************************
*****************************************

* TREATMENT

gen bface1t=0
replace bface1t=1 if Q129==1

gen bface2t=0
replace bface2t=1 if Q352==1

gen bfacebt=0
replace bfacebt=1 if Q352==1 | Q129==1

tab1 bface1t bface2t bfacebt

********************************
* Socio-Demographic Controls

* Gender
gen female=0
replace female=1 if Q136==1

* Age
gen agec=2013-Q19_3

gen age1829=0
replace age1829=1 if Q137==1

gen age3044=0
replace age3044=1 if Q137==2

gen age4564=0
replace age4564=1 if Q137==3

gen age65p=0
replace age65p=1 if Q137==4

* Religion
gen prot=0
replace prot=1 if Q19_12==1
replace prot=1 if Q19_13==1 | Q19_13==4 | Q19_13==10

* Education Level
gen educ=(Q19_2-1)/5

gen ba=0
replace ba=1 if Q19_2==4 | Q19_2==5 | Q19_2==6

* Income (binary above or below 50,000)
gen inc=Q19_5-1

* Income (scale)
gen income=.
replace income=0 if Q19_6==1
replace income=1 if Q19_6==2
replace income=2 if Q19_6==3
replace income=3 if Q19_6==4
replace income=4 if Q19_6==5
replace income=5 if Q19_7==1
replace income=6 if Q19_7==2
replace income=7 if Q19_7==3
replace income=8 if Q19_7==4
replace income=9 if Q19_7==5

gen income1=income/9

* Ideology
gen ideol=(Q19_16-1)/4

* Partisanship
gen pid=.
replace pid=0 if Q19_14==1 & Q88==1
replace pid=1 if Q19_14==1 & Q88==2
replace pid=2 if Q19_14==3 & Q89==1
replace pid=3 if Q19_14==3 & Q89==3
replace pid=4 if Q19_14==3 & Q89==2
replace pid=5 if Q19_14==2 & Q87==2
replace pid=6 if Q19_14==2 & Q87==1
gen pid2=pid/6

* dem and rep does *not* include leaners
gen dem=0
replace dem=1 if Q19_14==1

gen rep=0
replace rep=1 if Q19_14==2

gen ind=0
replace ind=1 if Q19_14==3

*****************************
*************************************************

* SUBJECT POOL CHARACTERISTICS

sum dvalex dvbeliefs bfacebt symracei age3044 age4564 age65p female prot ba inc pid2 ideol

pwcorr dvalex dvbeliefs bfacebt symracei age3044 age4564 age65p female prot ba inc pid2 ideol

*****************************
********************************

* Reported Results

* Model of Policy Preferences without Robust Errors
reg dvalex bfacebt age3044 age4564 age65p female prot ba inc pid2 ideol
reg dvalex bfacebt c.symracei age3044 age4564 age65p female prot ba inc pid2 ideol
reg dvalex bfacebt##c.symracei age3044 age4564 age65p female prot ba inc pid2 ideol

* Model of Policy Preferences With Robust Errors
reg dvalex bfacebt age3044 age4564 age65p female prot ba inc pid2 ideol, r
reg dvalex bfacebt c.symracei age3044 age4564 age65p female prot ba inc pid2 ideol, r
reg dvalex bfacebt##c.symracei age3044 age4564 age65p female prot ba inc pid2 ideol, r

* Model of Beliefs without Robust Errors
reg dvbeliefs bfacebt age3044 age4564 age65p female prot ba inc pid2 ideol
reg dvbeliefs bfacebt c.symracei age3044 age4564 age65p female prot ba inc pid2 ideol
reg dvbeliefs bfacebt##c.symracei age3044 age4564 age65p female prot ba inc pid2 ideol

* Model of Beliefs without Robust Errors
reg dvbeliefs bfacebt age3044 age4564 age65p female prot ba inc pid2 ideol, r
reg dvbeliefs bfacebt c.symracei age3044 age4564 age65p female prot ba inc pid2 ideol, r
reg dvbeliefs bfacebt##c.symracei age3044 age4564 age65p female prot ba inc pid2 ideol, r

**************************
**************************

* log close
