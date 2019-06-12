
use "D:\masaustu\2010hba\2010stata\fert_cd_2010.dta", clear

**** 

**recoding employment
recode 	calis_ay (2=0), gen (emp)

**recoding education to obtain years of schooling
recode 	egitim (1=0) (2=0) (3=5) (4=8) (5=8) (6=8) (7=11) (8=11) /*
		*/	(9=13) (10=15) (11=18), gen(educ)

***generating other income ****************

gen		emekl=emekl_yl/12
replace 	emekl=0 if emekl==.
gen		yasli=yasli_yl/12
replace 	yasli=0 if yasli==.
gen		dul=dul_yl/12
replace 	dul=0 if dul==.
gen		gazi=gazi_yl/12
replace 	gazi=0 if gazi==.
gen		burs=burs_yl/12
replace 	burs=0 if burs==.
gen		ydemk=ydemk_yl/12
replace 	ydemk=0 if ydemk==.
gen		yddov=yddov_yl/12
replace 	yddov=0 if yddov==.
gen		dgnfk=dgnfk_yl/12
replace 	dgnfk=0 if dgnfk==.
gen		dayni=dayni_yl/12
replace 	dayni=0 if dayni==.
gen		ydayn=ydayn_yl/12
replace 	ydayn=0 if ydayn==.
gen		dgayn=dgayn_yl/12
replace 	dgayn=0 if dgayn==.

gen		gmkn=gmkn_yl/12
replace 	gmkn=0 if gmkn==.
gen		gmka=gmka_yl/12
replace 	gmka=0 if gmka==.
gen		banka=banka_yl/12
replace 	banka=0 if banka==.
gen		doviz=doviz_yl/12
replace 	doviz=0 if doviz==.
gen		nema=nema_yl/12
replace 	nema=0 if nema==.
gen 		temet=temet_yl/12
replace 	temet=0 if temet==.
gen		kar=kar_yl/12
replace 	kar=0 if kar==.
gen		toprn=toprn_yl/12
replace 	toprn=0 if toprn==.
gen		topra=topra_yl/12
replace 	topra=0 if topra==.

gen		otherinc = gmkn+gmka+banka+doviz+nema+temet+kar+toprn+topra+yasli+/*
*/ 		gazi+burs+yddov+dgnfk+dayni+ydayn+dgayn+emekl+dul+ydemk

** generating formal-informal status 

recode	sgk (1=0) (3=0) (2=1), gen(informal)


**generating industry dummies

recode 	sekkod (5/18=1) (1=2) (2/4=3), gen(industry)
tab 		industry, gen(inddum)

** recoding marital status

recode 	medenidr (1=0)(3/4=0) (2=1), gen(married)

**recoding age (age was reported as age groups)
recode	yas (1=3) (2=10) (3=17) (4=22) (5=27) (6=32) (7=37) (8=42) /*
		*/	(9=47) (10=52) (11=57)(12=62)(13=65), gen(age)
gen 		agesq=age*age

*** recoding gender
recode 	cinsiyet (1=0)(2=1), gen(sex)

*** generating children dummy
gen		chyoungtemp=1 if yakinlik==2 & yas==1  	
recode      chyoungtemp (1=1) (.=0), gen (chyoung2) 
egen 		chyoung= max (chyoung2), by(bulten)

*** generating student dummy
recode 	ogrenci (2=0), gen(student)

***generating household dummy
recode 	yakinlik (1/9=0) (0=1), gen(head)

***generating household size
egen 		hhsize=count(yakinlik), by(bulten)

*** generating occupation dummies
tab	      meslek, gen(occupation)

***taking the logarithm of wage
gen 		wage=ln(ucrn_ay)

***generating tenure and tenure square
gen		tenure=sure_yil
gen 		tenuresq=sure_yil*sure_yil

***generating hours worked
gen		hoursw=calsur

***genearting public-private sector status
recode 	is_statu (2/3=0) (1=1), gen (private)

***generating exprience
gen 		exp=yas-educ-7
gen 		expsq=exp*exp

***generating union
recode	sendika (1=1) (2=0)


*** generating Cohort dummies 

recode 	yas (3/4=1) (5/6=2) (7/8=3) (9/10=4) (11/12=5), gen(agegr)
tab	      agegr, gen(cohort)

***limiting the data for ages 15-64

drop 		if yas<3
drop 		if yas>12

***excluding casual workers, employers, own-account workers and unpaid family workers. 
	
drop if isdur==3
drop if isdur==4
drop if isdur==5


**in the analyses below, cal_kisi refers to the number of people in the firm


*** two-step Heckman for females

heckman wage  educ exp expsq tenure tenuresq hoursw occupation1 occupation2 occupation3 occupation4 /*
*/ occupation5 occupation7 occupation8 occupation9 private sendika cohort2 cohort3 cohort4 cohort5 inddum2 inddum3 informal cal_kisi, twostep select /*
*/ (emp = married  chyoung educ  student hhsize age agesq head cohort2 cohort3 cohort4 cohort5 otherinc) rhosigma, if sex==1

*** two-step Heckman for males

heckman wage  educ exp expsq tenure tenuresq hoursw occupation1 occupation2 occupation3 occupation4 /*
*/ occupation5 occupation7 occupation8 occupation9 private sendika cohort2 cohort3 cohort4 cohort5 inddum2 inddum3 informal cal_kisi, twostep select /*
*/ (emp = married  chyoung educ student hhsize age agesq head cohort2 cohort3 cohort4 cohort5 otherinc) rhosigma, if sex==0

* Oaxaca (with selectivity bias correction) - Female coefficiens are the refence

oaxaca wage  educ exp expsq tenure tenuresq hoursw occupation1 occupation2 occupation3  /*
*/ occupation4 occupation5 occupation7 occupation8 occupation9 private sendika cohort2 cohort3 cohort4 cohort5 inddum2 inddum3 informal cal_kisi, /*
*/ by (sex) weight(1)  model2(heckman, twostep select  (emp = married chyoung educ student hhsize age agesq head cohort2 /*
*/ cohort3 cohort4 cohort5 otherinc))noisily 


* Oaxaca (with selectivity bias correction) - Male coefficiens are the refence

oaxaca wage  educ exp expsq tenure tenuresq hoursw occupation1 occupation2 occupation3  /*
*/ occupation4 occupation5 occupation7 occupation8 occupation9 private sendika cohort2 cohort3 cohort4 cohort5 inddum2 inddum3 informal cal_kisi, /*
*/ by (sex) weight(0) model2(heckman, twostep select  (emp = married chyoung educ student hhsize age agesq head cohort2 /*
*/ cohort3 cohort4 cohort5 otherinc))noisily 


* jmp decomposition

reg wage  educ exp expsq tenure tenuresq hoursw occupation1 occupation2 occupation3 occupation4 /*
*/ occupation5 occupation7 occupation8 occupation9 private sendika cohort2 cohort3 cohort4 cohort5 inddum2 inddum3 informal cal_kisi if sex==1 

estimates store female

reg wage  educ exp expsq tenure tenuresq hoursw occupation1 occupation2 occupation3 occupation4 /*
*/ occupation5 occupation7 occupation8 occupation9 private sendika cohort2 cohort3 cohort4 cohort5 inddum2 inddum3 informal cal_kisi  if sex==0 

estimates store male

* reference female
jmpierce female male, reference(1) stat (p10 p25 p50 p75 p90)

* reference male
jmpierce female male, reference(2) stat (p10 p25 p50 p75 p90)


