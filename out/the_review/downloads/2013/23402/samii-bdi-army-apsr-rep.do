********
* Promise or peril of ethnic integration?
* Cyrus Samii, April 2013
* Replication code
********

clear all
set mem 1g
set more off
* Change to your working directory
cd "~/Dropbox/bdi_army/analysis"
use samii-bdi-army-apsr-rep

********************************************************************
* Generate necessary variables
********************************************************************

*  Forcing variable regressors
gen below_cXage_c = below_c*age_c
gen age_csq = age_c^2
gen below_cXage_csq = below_c*age_csq
gen age_ccu = age_c^3
gen below_cXage_ccu = below_c*age_ccu

* Reverse code the coethnic variable for easier interpretation:
gen ethdis = 1- ethconc

* Weights to account for unequal coethnic pair assignment probabilities
gen pwt2 = .
replace pwt2 = 24/7 if  hutu==0&ethconc==1
replace pwt2 = 24/17 if hutu==0&ethconc==0
replace pwt2 = 24/17 if  hutu==1&ethconc==1
replace pwt2 = 24/7 if   hutu==1&ethconc==0

* Instrument for interaction for prejudice estimates
gen below_cXethdis = below_c*ethdis

* Endogenous interaction for prejudice estimates
gen militaryXethdis = military*ethdis

* Interaction between military and age

g militaryXage_c = military*age_c

********************************************************************
* Labels for output
********************************************************************

label var hutu "Hutu"
label var age_c "Age-45.5"
label var prej "Non-resp. index"
label var salience "Eth. salience"
label var nrprop "Non-resp. prop."
label var below_c "Age$<$45.5"
label var military "Integrated"
label var nco "NCO"
label var milyrs "Yrs. in mil."
label var prewared "Prewar educ."
label var unitdthrt "Unit dth. rt."
label var famdthrt "Family dth. rt."
label var ecperbad "Neg. ec. perc."
label var linc "Log(income+1)"
label var placebonr "Placebo non-resp."
label var below_cXage_c "(Age$<$45.5)X(Age-45.5)"
label var age_csq "(Age-45.5)$^2$"
label var below_cXage_csq "(Age$<$45.5)X(Age-45.5)$^2$" 
label var ethdis "Non-coeth. pair"
label var below_cXethdis "(Age$<$45.5)XNon-coeth."
label var militaryXethdis "IntegratedXNon-coeth."
label var equalaccess "Equal Access"


********************************************************************
* Estimated jump in treatment variable at and away from
* the cutoff
********************************************************************

reg military below_c age_c below_cXage_c if abs(age_c)<=5, cluster(date)

********************************************************************
* Estimates for prejudice
* (local 2SLS regression)
********************************************************************

* Obtain Imbens-Kalyanamaran optimal bandwidth:
rdob prej age_c, c(0)  fuzzy(military)

eststo clear
* Imbens-Kalyanaraman optimal bandwidth is 4 years.
eststo: ivregress 2sls prej ethdis age_c below_cXage_c (military militaryXethdis = below_c below_cXethdis) [pweight=pwt2] if abs(age_c)<=4, cluster(date)
* At 5 years, based on substantive reasoning that things should be locally linear
eststo: ivregress 2sls prej ethdis age_c below_cXage_c (military militaryXethdis = below_c below_cXethdis) [pweight=pwt2] if abs(age_c)<=5, cluster(date)
* At 10 years, to get some precision (higher order terms not significant)
eststo: ivregress 2sls prej ethdis age_c below_cXage_c age_csq below_cXage_csq (military militaryXethdis = below_c below_cXethdis) [pweight=pwt2] if abs(age_c)<=10, cluster(date)
* At 5 years, only non-Hutus
eststo: ivregress 2sls prej ethdis age_c below_cXage_c (military militaryXethdis = below_c below_cXethdis) [pweight=pwt2] if abs(age_c)<=5&hutu==0, cluster(date)
esttab using prej.tex, b(2) se(2) star(* 0.10 ** 0.05 *** 0.01) l replace

********************************************************************
* Robustness checks
********************************************************************

* Effects on equal access attitudes
eststo clear
eststo: ivregress 2sls equalaccess age_c below_cXage_c (military = below_c) if abs(age_c)<=5, cluster(date)
eststo: ivregress 2sls equalaccess age_c below_cXage_c (military = below_c) if abs(age_c)<=5 & hutu==0, cluster(date)
esttab using equalaccess.tex, b(2) se(2) star(* 0.10 ** 0.05 *** 0.01) l replace

* Using the raw non-response scores:
eststo clear
eststo: ivregress 2sls nrprop ethdis age_c below_cXage_c (military militaryXethdis = below_c below_cXethdis) [pweight=pwt2] if abs(age_c)<=3, cluster(date)
eststo: ivregress 2sls nrprop ethdis age_c below_cXage_c (military militaryXethdis = below_c below_cXethdis) [pweight=pwt2] if abs(age_c)<=5, cluster(date)
eststo: ivregress 2sls nrprop ethdis age_c below_cXage_c age_csq below_cXage_csq (military militaryXethdis = below_c below_cXethdis) [pweight=pwt2] if abs(age_c)<=10, cluster(date)
esttab using regappendix.tex, b(2) se(2) star(* 0.10 ** 0.05 *** 0.01) l replace

* Triangular kernel

gen weight_4 = max(0,1 - abs(age_c)/4)
gen weight_5 = max(0,1 - abs(age_c)/5)
gen weight_10 = max(0,1 - abs(age_c)/10)
g tri4pwt2 = weight_4*pwt2
g tri5pwt2 = weight_5*pwt2
eststo clear
eststo: ivregress 2sls prej ethdis age_c below_cXage_c (military militaryXethdis = below_c below_cXethdis) [pweight= tri4pwt2], cluster(date)
eststo: ivregress 2sls prej ethdis age_c below_cXage_c (military militaryXethdis = below_c below_cXethdis) [pweight= tri5pwt2], cluster(date)
esttab using regappendix.tex, b(2) se(2) star(* 0.10 ** 0.05 *** 0.01) l append addnotes("(With triangular kernel)")

* Enumerator fixed effects
* (Only three surveys for which enumerator id was improperly recorded.
* Just drop them, hence the enumid<=24 condition.)
quietly tab enumid, gen(enum)
eststo clear
eststo : ivregress 2sls prej ethdis age_c below_cXage_c enum2-enum24 (military militaryXethdis = below_c below_cXethdis) [pweight=pwt] if abs(age_c)<=4&enumid<=24, cluster(date)
eststo : ivregress 2sls prej ethdis age_c below_cXage_c enum2-enum24 (military militaryXethdis = below_c below_cXethdis) [pweight=pwt] if abs(age_c)<=5&enumid<=24, cluster(date)
eststo : ivregress 2sls prej ethdis age_c below_cXage_c age_csq below_cXage_csq enum2-enum24 (military militaryXethdis = below_c below_cXethdis) [pweight=pwt] if abs(age_c)<=10&enumid<=24, cluster(date)
esttab using regappendix.tex, keep(military militaryXethdis ethdis age_c below_cXage_c age_csq below_cXage_csq) b(2) se(2) star(* 0.10 ** 0.05 *** 0.01) l append addnotes("(With enumerator fixed effects)")

********************************************************************
* Estimates for salience
* (local 2SLS regression, rectangular kernel)
********************************************************************
eststo clear
* Find Imbens-Kalyanaraman optimal bandwidth (requires ado from Imbens website)
rdob salience age_c, c(0)  fuzzy(military)
* Imbens-Kalyanaraman optimal bandwidth is 4 years.
eststo : ivregress 2sls salience age_c below_cXage_c (military = below_c) if abs(age_c)<=4, cluster(date)
* At 5 years, based on substantive reasoning that things should be locally linear
eststo : ivregress 2sls salience age_c below_cXage_c (military = below_c) if abs(age_c)<=5, cluster(date)
* At 10 years, to get some precision (squared terms not significant)
eststo : ivregress 2sls salience age_c below_cXage_c (military = below_c) if abs(age_c)<=10, cluster(date)
esttab using salience.tex, b(2) se(2) star(* 0.10 ** 0.05 *** 0.01) l replace

********************************************************************
* Robustness checks
********************************************************************

* Controlling for ethdis
eststo clear
eststo: ivregress 2sls salience age_c below_cXage_c ethdis (military = below_c) [pweight=pwt] if abs(age_c)<=4, cluster(date)
eststo: ivregress 2sls salience age_c below_cXage_c ethdis (military = below_c) [pweight=pwt] if abs(age_c)<=5, cluster(date)
eststo: ivregress 2sls salience age_c below_cXage_c ethdis (military = below_c) [pweight=pwt] if abs(age_c)<=10, cluster(date)
esttab using regappendix.tex, b(2) se(2) star(* 0.10 ** 0.05 *** 0.01) l append

* Enumerator fixed effects

eststo clear
eststo: ivregress 2sls salience age_c below_cXage_c enum2-enum24 (military = below_c) if abs(age_c)<=4&enumid<=24, cluster(date)
eststo: ivregress 2sls salience age_c below_cXage_c enum2-enum24 (military = below_c) if abs(age_c)<=5&enumid<=24, cluster(date)
eststo: ivregress 2sls salience age_c below_cXage_c enum2-enum24 (military = below_c) if abs(age_c)<=10&enumid<=24, cluster(date)
esttab using regappendix.tex, keep(military age_c below_cXage_c)  b(2) se(2) star(* 0.10 ** 0.05 *** 0.01) l append addnotes("(With enumerator fixed effects)")

********************************************************************
* Placebo checks
********************************************************************
replace unitdthrt = . if unitdthrt<0
eststo clear
eststo : ivregress 2sls nco       age_c below_cXage_c (military = below_c) if abs(age_c)<=5, cluster(date)
eststo : ivregress 2sls milyrs    age_c below_cXage_c (military = below_c) if abs(age_c)<=5, cluster(date)
eststo : ivregress 2sls prewared  age_c below_cXage_c (military = below_c) if abs(age_c)<=5, cluster(date)
eststo : ivregress 2sls unitdthrt age_c below_cXage_c (military = below_c) if abs(age_c)<=5, cluster(date)
eststo : ivregress 2sls famdthrt  age_c below_cXage_c (military = below_c) if abs(age_c)<=5, cluster(date)
eststo : ivregress 2sls placebonr  age_c below_cXage_c (military = below_c) if abs(age_c)<=5, cluster(date)
esttab using placebo.tex, b(2) se(2) star(* 0.10 ** 0.05 *** 0.01) l replace

********************************************************************
* Analyzing exclusion restrictions
********************************************************************

* Subjective economic perceptions
rdob ecperbad age_c, c(0)  fuzzy(military)
* Imbens-Kalyanaraman optimal bandwidth is 4 years.
eststo clear
eststo : ivregress 2sls ecperbad age_c below_cXage_c ethdis (military = below_c) if abs(age_c)<=4, cluster(date)
eststo : ivregress 2sls ecperbad  age_c below_cXage_c ethdis (military = below_c) if abs(age_c)<=5, cluster(date)
eststo : ivregress 2sls ecperbad age_c below_cXage_c ethdis (military = below_c) if abs(age_c)<=10, cluster(date)
esttab using ecper.tex, b(2) se(2) star(* 0.10 ** 0.05 *** 0.01) l replace

* Income
rdob linc age_c, c(0)  fuzzy(military)
* Imbens-Kalyanaraman optimal bandwidth is 5 years.
eststo clear
eststo : ivregress 2sls linc  age_c below_cXage_c (military = below_c) if abs(age_c)<=5, cluster(date)
eststo : ivregress 2sls linc age_c below_cXage_c age_csq below_cXage_csq (military = below_c) if abs(age_c)<=10, cluster(date)
esttab using income.tex, b(2) se(2) star(* 0.10 ** 0.05 *** 0.01) l replace

* Controlling for these economic outcomes.

eststo clear
eststo: ivregress 2sls prej ethdis age_c below_cXage_c ecperbad linc (military militaryXethdis = below_c below_cXethdis) [pweight=pwt2] if abs(age_c)<=4, cluster(date)
eststo: ivregress 2sls prej ethdis age_c below_cXage_c ecperbad linc (military militaryXethdis = below_c below_cXethdis) [pweight=pwt2] if abs(age_c)<=5, cluster(date)
eststo: ivregress 2sls prej ethdis age_c below_cXage_c age_csq below_cXage_csq ecperbad linc (military militaryXethdis = below_c below_cXethdis) [pweight=pwt2] if abs(age_c)<=10, cluster(date)
esttab using exclusioncontrolprej.tex, b(2) se(2) star(* 0.10 ** 0.05 *** 0.01) l replace

eststo clear
eststo : ivregress 2sls salience age_c below_cXage_c ecperbad linc (military = below_c) if abs(age_c)<=4, cluster(date)
eststo : ivregress 2sls salience age_c below_cXage_c ecperbad linc  (military = below_c) if abs(age_c)<=5, cluster(date)
eststo : ivregress 2sls salience age_c below_cXage_c ecperbad linc  (military = below_c) if abs(age_c)<=10, cluster(date)
esttab using exclusioncontrolsalience.tex, b(2) se(2) star(* 0.10 ** 0.05 *** 0.01) l replace

********************************************************************
* Relationship between salience and prejudice measure
********************************************************************
pwcorr prej salience if abs(age_c)<=5, sig
pwcorr prej salience if ethdis==0 & abs(age_c)<=5, sig
pwcorr prej salience if ethdis==1 & abs(age_c)<=5, sig

xi: reg prej i.ethdis*salience if abs(age_c)<=5, cluster(date)
xi: reg prej i.ethdis*salience if abs(age_c)<=10, cluster(date)

pwcorr prej salience if abs(age_c)<=10, sig
pwcorr prej salience if ethdis==0 & abs(age_c)<=10, sig
pwcorr prej salience if ethdis==1 & abs(age_c)<=10, sig

********************************************************************
* Summary statistics table
********************************************************************
drop enum* _est* weight* tri* pwt* caseid enumid fabid date 
sutex, digits(2)
keep if abs(age_c)<=10
sutex, digits(2)
keep if abs(age_c)<=5
sutex, digits(2)













