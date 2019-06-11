****************************************************************************************************************************
***  PROJECT:  "Language Heightens the Political Salience of Ethnic Divisions", Journal of Experimental Political Science
***  AUTHORS: Efren O. Perez and Margit Tavits
***  DESCRIPTION: Stata code to replicate comparisons of WVS sample and those of Study 1 and Study 2
***  DATE: June 6, 2018
****************************************************************************************************************************

************************************************************
**Comparison of WVS samples and Study 1&2 samples in the SI
************************************************************

set more off

***Table SI.2.1
**Compare means and proportions; WVS compared to Study 1
prtest female if study==1 | study==6, by(study)
ttest age if study==1 | study==6, by(study)
ttest edu if study==1 | study==6, by(study)

**Compare means and proportions; WVS compared to Study 2
prtest female if study==2 | study==6, by(study)
ttest age if study==2 | study==6, by(study)
ttest edu if study==2 | study==6, by(study)
ttest ideology if study==2 | study==6, by(study)

***SI.6: Comparison of median education levels
by study, sort: summarize edu, detail
