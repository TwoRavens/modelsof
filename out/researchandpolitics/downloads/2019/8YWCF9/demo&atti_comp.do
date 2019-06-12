*************** set working directory ******************************************
use "zhubajie.dta", clear

**************** Zhubajie Sample *************************************
*dichotomize attitudinal measures 
recode trust_ngovt (1/2=1)(3/4=0)(.=.), gen (trust_ngovt2)
recode trust_lgovt (1/2=1)(3/4=0)(.=.), gen (trust_lgovt2)
recode pride (1/2=1)(3/4=0)(.=.), gen (pride2)
recode equality (1/2=1)(3/5=0)(.=.), gen (equality2)


gen weight=1
svyset [pw=weight]
svy: mean age female yearsedu urban ccp employed
est store zbj_unweighted

svy: mean ptrust
est store zbj_unweighted_ptrust

svy: tab trust_ngovt2
est store zbj_unweighted_ngvt

svy: tab trust_lgovt2
est store zbj_unweighted_lgovt

svy: tab pride2
est store zbj_unweighted_pride

svy: tab equality2
est store zbj_unweighted_equality

svyset [pw=wt_census]
svy: mean age female yearsedu urban ccp employed
est store zbj_census

svy: mean ptrust
est store zbj_census_ptrust

svy: tab trust_ngovt2
est store zbj_census_ngvt

svy: tab trust_lgovt2
est store zbj_census_lgovt

svy: tab pride2
est store zbj_census_pride

svy: tab equality2
est store zbj_census_equality

svyset [pw=wt_internet]
svy: mean age female yearsedu urban ccp employed
est store zbj_internet

svy: mean ptrust
est store zbj_internet_ptrust

svy: tab trust_ngovt2
est store zbj_internet_ngvt

svy: tab trust_lgovt2
est store zbj_internet_lgovt

svy: tab pride2
est store zbj_internet_pride

svy: tab equality2
est store zbj_internet_equality

************* ABS Sample *******************************************************
use "abs.dta", clear
*dichotomize attitudinal measures 
recode trust_ngovt (1/2=1)(3/4=0)(.=.), gen (trust_ngovt2)
recode trust_lgovt (1/2=1)(3/4=0)(.=.), gen (trust_lgovt2)
recode pride (1/2=1)(3/4=0)(.=.), gen (pride2)

svyset [pw=CNweight]
svy: mean age female yearsedu employed
est store abs_census

svy: mean ptrust
est store abs_census_ptrust

svy: tab trust_ngovt2
est store abs_census_ngvt

svy: tab trust_lgovt2
est store abs_census_lgovt

svy: tab pride2
est store abs_census_pride


svy: mean age female yearsedu employed if internet_abs2 == 1
est store abs_internet

svy: mean ptrust if internet_abs2 == 1
est store abs_internet_ptrust

svy: tab trust_ngovt2 if internet_abs2 == 1
est store abs_internet_ngvt

svy: tab trust_lgovt2 if internet_abs2 == 1
est store abs_internet_lgovt

svy: tab pride2 if internet_abs2 == 1
est store abs_internet_pride

************* CGSS Sample ******************************************************

use "cgss.dta", clear

gen weight=1
svyset [pw=weight]
svy: mean age female yearsedu urban ccp employed
est store cgss_census

svy: mean ptrust
est store cgss_census_ptrust

svy: mean age female yearsedu urban ccp employed if internet == 1
est store cgss_internet

svy: mean ptrust if internet == 1
est store cgss_internet_ptrust

************* CS Sample ********************************************************
use "cs.dta", clear
*dichotomize attitudinal measures 
recode pride (1/2=1)(3/4=0)(.=.), gen (pride2)
recode equality (1/2=1)(3/5=0)(.=.), gen (equality2)

svyset [pw=wt_psbfc_cs]
svy: mean age female yearsedu urban ccp employed
est store cs_census

svy: mean ptrust
est store cs_census_ptrust

svy: tab pride2
est store cs_census_pride

svy: tab equality2
est store cs_census_equality

svy: mean age female yearsedu urban ccp employed if internet == 1
est store cs_internet

svy: mean ptrust if internet == 1
est store cs_internet_ptrust

svy: tab pride2 if internet == 1
est store cs_internet_pride

svy: tab equality2 if internet == 1
est store cs_internet_equality

************* WVS Sample *******************************************************

use "wvs.dta", clear
*dichotomize attitudinal measures 
recode trust_ngovt (1/2=1)(3/4=0)(.=.), gen (trust_ngovt2)
recode pride (1/2=1)(3/4=0)(.=.), gen (pride2)

svyset [pw=V258_wvs]
svy: mean age yearsedu female ccp employed
est store wvs_census

svy: mean ptrust
est store wvs_census_ptrust

svy: tab trust_ngovt2
est store wvs_census_ngvt

svy: tab pride2
est store wvs_census_pride

svy: mean age female yearsedu ccp employed if internet == 1
est store wvs_internet

svy: mean ptrust if internet == 1
est store wvs_internet_ptrust

svy: tab trust_ngovt2 if internet == 1
est store wvs_internet_ngvt

svy: tab pride2 if internet == 1
est store wvs_internet_pride


******** Table 1: Comparing Demographic Variables*******************************

estout zbj_unweighted zbj_census zbj_internet

estout abs_census cgss_census cs_census wvs_census

estout abs_internet cgss_internet cs_internet wvs_internet


******** Table 2: Comparisons on Common Attitudinal Measures *******************
***Interpersonal Trust
* Zhubajie Sample
estout zbj_unweighted_ptrust zbj_census_ptrust zbj_internet_ptrust 

* Benchmark Samples with Census Weights
estout abs_census_ptrust cgss_census_ptrust cs_census_ptrust  wvs_census_ptrust

* Internet Users in Benchmark Samples with CNNIC Weights
estout abs_internet_ptrust cgss_internet_ptrust cs_internet_ptrust wvs_internet_ptrust


****Trust in Central Government
* Zhubajie Sample
estout zbj_unweighted_ngvt zbj_census_ngvt zbj_internet_ngvt

* Benchmark Samples with Census Weights
estout abs_census_ngvt  wvs_census_ngvt

* Internet Users in Benchmark Samples with CNNIC Weights
estout abs_internet_ngvt wvs_internet_ngvt

******Trust in Local Government
* Zhubajie Sample
estout zbj_unweighted_lgovt zbj_census_lgovt zbj_internet_lgovt

* Benchmark Samples with Census Weights
estout abs_census_lgovt  

* Internet Users in Benchmark Samples with CNNIC Weights
estout abs_internet_lgovt 


******National Pride
* Zhubajie Sample
estout zbj_unweighted_pride zbj_census_pride zbj_internet_pride

* Benchmark Samples with Census Weights
estout abs_census_pride cs_census_pride wvs_census_pride

* Internet Users in Benchmark Samples with CNNIC Weights
estout abs_internet_pride cs_internet_pride wvs_internet_pride


******Equality
* Zhubajie Sample
estout zbj_unweighted_equality zbj_census_equality zbj_internet_equality

* Benchmark Samples with Census Weights
estout cs_census_equality 

* Internet Users in Benchmark Samples with CNNIC Weights
estout cs_internet_equality 

