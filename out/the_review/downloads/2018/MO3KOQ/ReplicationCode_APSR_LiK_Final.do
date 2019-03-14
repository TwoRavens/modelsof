*****************************
** Replication Code Analysis for Revised Version of When The Money Stops Revision
*****************************

*For all analyses of Life in Kyrgyzstan (LiK) data, use the following data set:

use "LiK_Panel_Replication_Final.dta"

*****************************
**** Tables & Figures in Main Text 
*****************************

** Table 2

set more off

xtset idpp year

xtreg difftrustaltpres diffamountrec  i.educ_cat2 marital gender age_adult ethnicity employed intentmigrate total_index3 tot_inc_rec  lifesat riskaccept i.year i.hhid, i(idpp) 

xtreg difftrustaltpres difffremfreq   i.educ_cat2 marital gender age_adult ethnicity employed intentmigrate total_index3 tot_inc_rec lifesat riskaccept i.year i.hhid, i(idpp) 

xtreg difftrustaltpres  diffremitindex i.educ_cat2 marital gender age_adult ethnicity employed intentmigrate total_index3 tot_inc_rec lifesat riskaccept i.year i.hhid, i(idpp) 

** Figure 3

set more off

xtset idpp year

xtreg difftrustaltpres remit_drop  agriloss affected_landsl marital i.educ_cat2 gender age_adult ethnicity employed intentmigrate total_index3 tot_inc_rec lifesat riskaccept  i.year i.hhid, i(idpp) 

* see R code for R graphic 

** Table 3

set more off

xtset idpp year

xtreg diffeconconcern diffamountrec i.educ_cat2 marital gender age_adult ethnicity employed intentmigrate total_index3 tot_inc_rec   lifesat riskaccept i.year i.hhid, i(idpp) 

xtreg diffeconconcern difffremfreq i.educ_cat2 marital gender age_adult ethnicity employed intentmigrate total_index3 tot_inc_rec   lifesat riskaccept i.year i.hhid, i(idpp) 

xtreg diffeconconcern diffremitindex i.educ_cat2 marital gender age_adult ethnicity employed intentmigrate total_index3 tot_inc_rec   lifesat riskaccept i.year i.hhid, i(idpp) 

** Figure 4

set more off

xtset idpp year

xtreg difftrustaltpres c.diffamountrec##c.seekinfo_cat3 marital difffremfreq i.educ_cat2 gender age_adult ethnicity employed intentmigrate total_index3 tot_inc_rec  lifesat riskaccept  i.year i.hhid, i(idpp)
 
* See R code

*****************************
***** Supplementary Information Tables & Figures
*****************************

*** Section A: Study Descriptions and Descriptive Statistics

* Table A.2 Descriptives LiK

sum difftrustaltpres  diffamountrec difffremfreq diffremitindex remit_drop  agriloss affected_landsl educ_c1 educ_c2 educ_c3 educ_c4 marital  gender age_adult ethnicity employed intentmigrate total_index3 tot_inc_rec   lifesat riskaccept if hasremittances==1 & year==10

sum difftrustaltpres  diffamountrec difffremfreq diffremitindex remit_drop  agriloss affected_landsl educ_c1 educ_c2 educ_c3 educ_c4 marital gender age_adult ethnicity employed intentmigrate total_index3 tot_inc_rec   lifesat riskaccept if hasremittances==1 & year==11

sum difftrustaltpres diffamountrec difffremfreq diffremitindex remit_drop  agriloss affected_landsl educ_c1 educ_c2 educ_c3 educ_c4 marital gender age_adult ethnicity employed intentmigrate total_index3 tot_inc_rec   lifesat riskaccept if hasremittances==1 & year==12

sum difftrustaltpres  diffamountrec difffremfreq diffremitindex remit_drop  agriloss affected_landsl educ_c1 educ_c2 educ_c3 educ_c4 marital gender age_adult ethnicity employed intentmigrate total_index3 tot_inc_rec   lifesat riskaccept if hasremittances==1 & year==13

*** Section B: Full Results

* Table B.2 accompanying Figure 3

set more off

xtset idpp year

xtreg difftrustaltpres remit_drop  agriloss affected_landsl i.educ_cat2 marital gender age_adult ethnicity employed intentmigrate total_index3 tot_inc_rec lifesat riskaccept  y3 y4 i.hhid, i(idpp) 

** Table B.3 accompanying Figure 4

set more off

xtset idpp year

xtreg difftrustaltpres c.diffamountrec##c.seekinfo_cat3 difffremfreq marital i.educ_cat2 gender age_adult ethnicity employed intentmigrate total_index3 tot_inc_rec  lifesat riskaccept  i.year i.hhid, i(idpp)
 
*** Section C: Robustness Checks 

* Table C.3

set more off

reg altpres_trust hasremittances i.educ_cat2 marital gender age_adult ethnicity employed intentmigrate total_index3 tot_inc_rec   lifesat riskaccept i.hhid if year==10

* Table C.4

set more off

xtmixed difftrustaltpres diffamountrec i.educ_cat2 marital gender age_adult ethnicity employed intentmigrate total_index3 tot_inc_rec   lifesat riskaccept || hhyear:, mle variance
estat ic

xtmixed difftrustaltpres difffremfreq  i.educ_cat2 marital gender age_adult ethnicity employed intentmigrate total_index3 tot_inc_rec   lifesat riskaccept  || hhyear:, mle variance
estat ic

xtmixed difftrustaltpres diffremitindex  i.educ_cat2 marital gender age_adult ethnicity employed intentmigrate total_index3 tot_inc_rec   lifesat riskaccept  || hhyear:, mle variance
estat ic

** Table C.5

set more off

xtset idpp year

xtreg difftrustaltpres diffamountrec i.sector i.educ_cat2 marital gender age_adult ethnicity intentmigrate total_index3 tot_inc_rec  lifesat riskaccept i.year i.hhid, i(idpp) 

xtreg difftrustaltpres difffremfreq i.sector i.educ_cat2 marital gender age_adult ethnicity intentmigrate total_index3 tot_inc_rec lifesat riskaccept i.year i.hhid, i(idpp) 

xtreg difftrustaltpres  diffremitindex i.sector i.educ_cat2 marital gender age_adult ethnicity intentmigrate total_index3 tot_inc_rec lifesat riskaccept i.year i.hhid, i(idpp) 

* Table C.6

teffects nnmatch (difftrustaltpres i.sector marital i.educ_cat2 gender age_adult ethnicity intentmigrate total_index3 tot_inc_rec  lifesat riskaccept)  (remit_drop), ate metric(maha)  biasadj(marital i.sector i.educ_cat2 gender age_adult ethnicity  intentmigrate total_index3 tot_inc_rec  lifesat riskaccept)

tebalance summarize

* Table C.7

teffects nnmatch (difftrustaltpres agriloss affected_landsl i.sector marital  i.educ_cat2 gender age_adult ethnicity  intentmigrate total_index3 tot_inc_rec lifesat riskaccept i.year)  (remit_drop), ate metric(maha)  biasadj(agriloss affected_landsl marital i.sector i.educ_cat2 gender age_adult ethnicity  intentmigrate total_index3 tot_inc_rec lifesat riskaccept i.year)

tebalance summarize

* Table C.8

set more off

xtmixed difftrustaltpres remit_drop  agriloss affected_landsl  i.educ_cat2 marital gender age_adult ethnicity employed intentmigrate total_index3 tot_inc_rec lifesat riskaccept || hhyear:, mle variance
estat ic

** Table C.9

set more off

xtset idpp year

xtreg difftrustaltpres remit_drop  agriloss affected_landsl i.sector  i.educ_cat2 marital gender age_adult ethnicity intentmigrate total_index3 tot_inc_rec lifesat riskaccept  i.year i.hhid, i(idpp) 

* Table C.10

teffects nnmatch (difftrustaltpres agriloss affected_landsl i.sector marital  i.educ_cat2 gender age_adult ethnicity intentmigrate total_index3 tot_inc_rec lifesat riskaccept i.year)  (remit_drop), ate metric(maha)  biasadj(agriloss affected_landsl marital i.sector i.educ_cat2 gender age_adult ethnicity intentmigrate total_index3 tot_inc_rec lifesat riskaccept  i.year)

tebalance summarize


* Table C.11

xtmixed diffeconconcern diffamountrec i.educ_cat2 marital gender age_adult ethnicity employed intentmigrate total_index3 tot_inc_rec   lifesat riskaccept || hhyear:, mle variance
estat ic

xtmixed diffeconconcern difffremfreq i.educ_cat2 marital gender age_adult ethnicity employed intentmigrate total_index3 tot_inc_rec   lifesat riskaccept || hhyear:, mle variance 
estat ic

xtmixed diffeconconcern diffremitindex i.educ_cat2 marital gender age_adult ethnicity employed intentmigrate total_index3 tot_inc_rec   lifesat riskaccept || hhyear:, mle variance 
estat ic
 

** Table C.12

set more off

xtset idpp year

xtreg diffeconconcern diffamountrec i.sector i.educ_cat2 marital gender age_adult ethnicity intentmigrate total_index3 tot_inc_rec   lifesat riskaccept i.year i.hhid, i(idpp) 

xtreg diffeconconcern difffremfreq i.sector i.educ_cat2 marital gender age_adult ethnicity intentmigrate total_index3 tot_inc_rec   lifesat riskaccept i.year i.hhid, i(idpp) 

xtreg diffeconconcern diffremitindex i.sector i.educ_cat2 marital gender age_adult ethnicity intentmigrate total_index3 tot_inc_rec   lifesat riskaccept i.year i.hhid, i(idpp) 
 

* Table C.13

teffects nnmatch (diffeconconcern marital agriloss affected_landsl  i.educ_cat2 gender age_adult ethnicity employed intentmigrate total_index3 tot_inc_rec lifesat riskaccept i.year)  (remit_drop), ate metric(maha)  biasadj(agriloss affected_landsl marital  i.educ_cat2 gender age_adult ethnicity employed intentmigrate total_index3 tot_inc_rec lifesat riskaccept  i.year)

tebalance summarize

* Table C.14

teffects nnmatch (diffeconconcern marital agriloss affected_landsl i.sector i.educ_cat2 gender age_adult ethnicity intentmigrate total_index3 tot_inc_rec lifesat riskaccept i.year)  (remit_drop), ate metric(maha)  biasadj(agriloss affected_landsl marital i.sector i.educ_cat2 gender age_adult ethnicity  intentmigrate total_index3 tot_inc_rec lifesat riskaccept  i.year)

tebalance summarize

* Table C.16

set more off

xtset idpp year

xtreg difftrustaltpres c.diffamountrec##c.familyinfo marital difffremfreq i.educ_cat2 gender age_adult ethnicity employed intentmigrate total_index3 tot_inc_rec  lifesat riskaccept  i.year i.hhid, i(idpp)

* Figure C.1 

* see R code

*** Section D: Additional Analyses

* Table D.1

xtset hhid 

xtivreg2 difftrustaltpres  marital educ_c2 educ_c3 educ_c4 gender age_adult ethnicity employed intentmigrate total_index3 tot_inc_rec  lifesat riskaccept  (diffamountrec = fhhunem), fe first


xtset hhid 

xtivreg2 difftrustaltpres  marital educ_c2 educ_c3 educ_c4 gender age_adult ethnicity employed intentmigrate total_index3 tot_inc_rec  lifesat riskaccept reg_export  (diffamountrec = fhhunem), fe first


* Table D.2

set more off

xtset idpp year

xtreg difftrustcom  diffamountrec  marital i.educ_cat gender age_adult ethnicity employed intentmigrate total_index3 tot_inc_rec   lifesat riskaccept  i.year i.hhid, i(idpp) 

xtreg difftrustcom  difffremfreq  marital i.educ_cat gender age_adult ethnicity employed intentmigrate total_index3 tot_inc_rec   lifesat riskaccept  i.year i.hhid , i(idpp) 

xtreg difftrustcom  diffremitindex  marital i.educ_cat gender age_adult ethnicity employed intentmigrate total_index3 tot_inc_rec   lifesat riskaccept  i.year i.hhid, i(idpp) 

* Table D.3

set more off

reg satisfied_services diffamountrec i.educ_cat2 marital gender age_adult ethnicity employed intentmigrate total_index3 tot_inc_rec   lifesat riskaccept i.hhid if year==13 

reg satisfied_services difffremfreq i.educ_cat2 marital gender age_adult ethnicity employed intentmigrate total_index3 tot_inc_rec   lifesat riskaccept i.hhid if year==13 

reg satisfied_services diffremitindex i.educ_cat2 marital gender age_adult ethnicity employed intentmigrate total_index3 tot_inc_rec   lifesat riskaccept i.hhid if year==13 

* Table D.4

set more off

xtmixed satisfied_services  diffamountrec i.educ_cat2 marital gender age_adult ethnicity employed intentmigrate total_index3 tot_inc_rec   lifesat riskaccept  if year==13 || hhid:, mle variance 
estat ic

xtmixed satisfied_services  difffremfreq i.educ_cat2 marital gender age_adult ethnicity employed intentmigrate total_index3 tot_inc_rec   lifesat riskaccept  if year==13 || hhid:, mle variance
estat ic

xtmixed satisfied_services  diffremitindex i.educ_cat2 marital gender age_adult ethnicity employed intentmigrate total_index3 tot_inc_rec   lifesat riskaccept  if year==13 || hhid:, mle variance
estat ic


