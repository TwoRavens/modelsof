*Replication code for "Service Representation in a Federal System: A Field Experiment"
*Peter Loewen (University of Toronto) and Michael Mackenzie (University of Pittsburgh)
**NOTE 1: This replication archive includes code to generate all results in our paper published in the Journal of Experimental Political Science.
**NOTE 2: In each table estimating results, Model 3 includes variables which in raw data can be used to identify the politician recipient. The editor has been provided with the complete data and replication code necessary to see replicate these models. However, due to ethics restrictions, we do not make those variables available in this public file.

use "/Users/peterjohnloewen/Dropbox/Parliament Experiment/Field Experiment/Final documents/Replication data_Loewen and Mackenzie_public.dta", clear
set more off

**Table 1 - distribution of treatments by round and level of government
**assignment to out(-1), shared (0), and in treatment (1) by level and round
bys _j: tab federal TREATMENT

**Table 2 -- Helpfulness by issue area
**Model 1
regress HELP OUT IN, cluster(IDmember)
test OUT=IN

**Model 2
xi: regress HELP OUT IN FRENCH ETHNIC FEMALE support emailfo, cluster(IDmember)
test OUT=IN

**Model 3
*** see NOTE 2, above

***Other statistics in main text

**properties of helpfulness scores
**correlation of scores
pwcorr HELPscorer1 HELPscorer2
**alpha score
alpha HELPscorer1 HELPscorer2
**relationship of treatment condition to error in scores
mlogit TREATMENT ERROR
**mean helpfulness score
ci mean HELP
sum HELP

**average helpfulness by treatment condition
bys TREATMENT: ci mean HELP
**unpaired ttests of differences in helpfulness by conditions
**out vs in
ttest HELP if TREATMENT~=0, by(TREAT) unpaired
**out vs shared
ttest HELP if TREATMENT~=1, by(TREAT) unpaired
**in vs shared
ttest HELP if TREATMENT~=-1, by(TREAT) unpaired
******************************************************************************
******************************************************************************
******************************************************************************
******************************************************************************

**Appendix

**Replication with dichotomous dependent variable

**Model 1
logit DICT OUT IN, cluster(IDmember) or
test IN=OUT
**Model 2
xi: logit DICT OUT IN FRENCH ETHNIC FEMALE support emailfo, cluster(IDmember) or
test IN=OUT
**Model 3
*** see NOTE 2, above

*Replication with response count

**Model 1
poisson RESPONSE OUT IN, cluster(IDmember)
test IN=OUT

**Model 2
xi: poisson RESPONSE OUT IN FRENCH ETHNIC FEMALE support emailfor, cluster(IDmember)
test IN=OUT

**Model 3
*** see NOTE 2, above

**Replication with Coder 1
**Model 1
regress HELPscorer1 OUT IN, cluster(IDmember)
test OUT=IN

**Model 2
xi: regress HELPscorer1 OUT IN FRENCH ETHNIC FEMALE support email, cluster(IDmember)
test OUT=IN

**Model 3
*** see NOTE 2, above

**Replication with Coder 2
**Model 1
regress HELPscorer2 OUT IN, cluster(IDmember)
test OUT=IN

**Model 2
xi: regress HELPscorer2 OUT IN FRENCH ETHNIC FEMALE support email, cluster(IDmember)
test OUT=IN

**Model 3
*** see NOTE 2, above

**Statistics in text
**bivariate logit of dichotomous response variable on helpfulness
logit DICT HELP

**descriptive statistics for count variable
ci mean RESPONSE
sum RESPONSE


***Figures

*Figure 1, Appendix
dotplot HELP HELPscorer1 HELPscorer2, ytitle(Score) xtitle(Frequency of scores) xlabel(1 "Combined Score" 2 "Coder 1 Score" 3 "Coder 2 Score") name(DIST, replace) graphregion(fcolor(white) lcolor(white) ifcolor(white))
graph export "/Users/peterjohnloewen/Dropbox/Parliament Experiment/Field Experiment/Final documents/DIST.pdf", replace


**Balance tests
* treatment balance against Model 2 predictors
mlogit TREATMENT FRENCH ETHNIC FEMALE support emailfo, cluster(IDmember)
* treatment balance against Model 3 predictors
*** see NOTE 2, above

