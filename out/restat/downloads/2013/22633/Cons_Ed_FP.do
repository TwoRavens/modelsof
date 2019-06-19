version 9
clear
set maxvar 32500
set mem 5g
set matsize 10000
capture log close
log using "C:\Users\ecomkp\Desktop\MP_Jul_09a.log", replace

use "C:\Users\ecomkp\Desktop\090113_TotWatDat_cor_merge_Price.dta", clear

/* Note that the data file, 090113_Tot Wat Dat_cor_merge_Price.dta, was created from 080113_Total Water Data_cor_merge.dta, which is a merge of experimental sample and tax assessor data base, 
so there are more observations in the data set than there are in the experiment, but these additional observations in this data set have only a prem number and no other data information.  
The tax assessor data have been removed in 090113_Tot Wat Dat_cor_merge_Price.dta.  All that remain are the water consumption information and the unique identifying prem
number used by the water utility, as well as some other relevant variables such as route number and variables which are defined below. */
/* this do file was created from Dec 08 Cons Ed do file. Some text was trimmed and other added so outside readers could follow code */
/* remember that data are billing data and thus we assume that, for example, July 2006 billing data reflects June 2006 consumption in 1000 gallon units */
/* Cumulative water use during June, July, August and Sept 2006: the main watering months each year that Cobb County is most interested in
affecting*/

gen summer_06 =  jul06 + aug06 + sep06 + oct06


/* Cumulative water use during all outdoor watering months 2006: one could argue that outdoor watering is continuing until October and thus 
we should extend the 2006 baseline variable to increase precision further. Doesn't make a lot of difference in practice */

gen water_2006 = jun06 + jul06 + aug06 + sep06 + oct06 + nov06

/* Cumulative water use during June, July, August and Sept 2007. Note that nov07 billing data are incomplete and cannot be used to 
estimate Oct 07 consumption.  The "3x" suffix was labeled by Juan Jose to reflect the second data dump by Cobb County in Fall 2007 and his prem number
merge of the new data and old data and confirmation that the April 2007, which was in both pre-experiment and post-experiment data dumps, lined up  */

gen summer_07 =  jul07_3x + aug07_3x + sep07_3x + oct07_3x

/* Change in cumulative summer water use between 2006 and 2007 */

gen sumrwater_change =  summer_06- summer_07

/* squared summer 2006 consumption. not used in analysis, but here in case one is interested. */

gen  summer_06sq = summer_06*summer_06

/* two months before treatment: this variable represents "spring watering," which is used to control for any changes, indoor or outdoor, in the household's 
water consumption potential prior to the 2007 summer season.  */

gen apr_may_07 = apr07_3x + may07_3x

/* other "pre-treatment" water consumption variables were created and tried (winter and fall 06), but none seemed to add any additional explanatory power or, in 
the case of variables more aggregated (such as adding up all months before the treatment), the explanatory power of the model was lower than in
the one used below. recall that the intention of adding in pre-treatment water consumption variables is to increase precision of the treatment variable
estimates */

/* change definition of treatments so that it matches what will be in paper.  Treat 1 was weak social norm, Treat 2 was strong social norm, and Treat 3 was tip
sheet only.  I am changing it so that Treat 1 is tip sheet, Treat 2 is strong social norm (social comparison) and Treat 3 is weak social norm.  
Note that Group 1 is still weak social norm, Group 2 is strong social norm, Group 3 is tip sheet only, and Group 4 is control */

rename treat1 treat_3
rename treat3 treat_1
rename treat_1 treat1
rename treat_3 treat3


/* dummy for top 50th percentile of water users in 2006. Percent_report is the variable that indicates the percentile reported that would have been 
reported on a social comparison letter (actually was reported for subjects in the social comparison (strong social norm) treatment) */

gen   top50 = 1 if percent_report>=50
recode top50 (.=0)

/* in analysis below is a dummy variable called unusable, created by Juan Jose Miranda Montero and which represents households with billing mistakes and 
for which we cannot determine with certainty their actual water use */

/* in analysis below we remove three households with observable catastrophic leaks (prem~=105321 & prem~=129672 & prem~=148705); there may be others left in the data set for which we could not
confirm with certainty the presence of a leak */

/* analysis below uses sample if group~=. & prem~=105321 & unusable~=1 & prem~=129672 & prem~=148705 & summer_07~=. & summer_07~=., 
to remove unverifiable billing (unusable) and catastrophic leaks */

/* Summarize water use for sample and by group */

count if group~=. & prem~=105321 & unusable~=1 & prem~=129672 & prem~=148705 & summer_07~=. & summer_06~=.
summarize  summer_06 if group~=. & prem~=105321 & unusable~=1 & prem~=129672 & prem~=148705 & summer_07~=. & summer_06~=., detail
summarize  summer_07 if group~=. & prem~=105321 & unusable~=1 & prem~=129672 & prem~=148705 & summer_07~=. & summer_06~=., detail

/* control */

count if group==4 & prem~=105321 & unusable~=1 & prem~=129672 & prem~=148705 & summer_07~=. & summer_07~=.
summarize  summer_06 if group==4 & prem~=105321 & unusable~=1 & prem~=129672 & prem~=148705 & summer_07~=. & summer_06~=., detail
summarize  summer_07 if group==4 & prem~=105321 & unusable~=1 & prem~=129672 & prem~=148705 & summer_07~=. & summer_06~=., detail

/* Tip Sheet Treatment 1*/

count if treat1==1 & prem~=105321 & unusable~=1 & prem~=129672 & prem~=148705 & summer_07~=. & summer_07~=.
summarize  summer_06 if treat1==1 & prem~=105321 & unusable~=1 & prem~=129672 & prem~=148705 & summer_07~=. & summer_06~=., detail
summarize  summer_07 if treat1==1 & prem~=105321 & unusable~=1 & prem~=129672 & prem~=148705 & summer_07~=. & summer_06~=., detail

/* Strong Social Norm Treatment 2*/

count if treat2==1 & prem~=105321 & unusable~=1 & prem~=129672 & prem~=148705 & summer_07~=. & summer_07~=.
summarize  summer_06 if treat2==1 & prem~=105321 & unusable~=1 & prem~=129672 & prem~=148705 & summer_07~=. & summer_06~=., detail
summarize  summer_07 if treat2==1 & prem~=105321 & unusable~=1 & prem~=129672 & prem~=148705 & summer_07~=. & summer_06~=., detail

/* Weak Social Norm Treatment 3 */

count if treat3==1 & prem~=105321 & unusable~=1 & prem~=129672 & prem~=148705 & summer_07~=. & summer_07~=.
summarize  summer_06 if treat3==1 & prem~=105321 & unusable~=1 & prem~=129672 & prem~=148705 & summer_07~=. & summer_06~=., detail
summarize  summer_07 if treat3==1 & prem~=105321 & unusable~=1 & prem~=129672 & prem~=148705 & summer_07~=. & summer_06~=., detail


/* Here are the regressions included in Table 2 of the paper.*/


/* regression  1. This regression seems to have the best fit, based on BIC, of all models. Estimates change little if we use another way of controlling for
baseline water consumption in order to increase precision of the estimates. This is Model A in Table 2. */

regress summer_07 treat1 treat2 treat3 water_2006 apr_may_07 if prem~=105321 & unusable~=1 & prem~=129672 & prem~=148705 & summer_07~=. & summer_06~=.,level(95) robust
test treat1=treat2=treat3

/*

	As a robustness check, let's rerun all of the above models including block FE's.  This is the Model B in Table 2.*/

*/


 
xi: regress summer_07 treat1 treat2 treat3 water_2006 apr_may_07 i.route if prem~=105321 & unusable~=1 & prem~=129672 & prem~=148705 & summer_07~=. & summer_06~=.,level(95) robust



/*

	Now let's first look at trimming the sample using different definitions to do so.  The first set of models will restrict observations from the extreme
	tails - i.e., top and bottom 0.25%.  This is Model C in Table 2. 

*/


regress summer_07 treat1 treat2 treat3 water_2006 apr_may_07 if summer_07 > 0 & summer_07 < 205 & prem~=105321 & unusable~=1 & prem~=129672 & prem~=148705 & summer_07~=. & summer_06~=.,level(95) robust



/*  This next set of code generates the regressions from Table 3 of the paper. */

/* regression: Bottom 50th.  This is Model A in the table.  */

regress summer_07 treat1 treat2 treat3 water_2006 apr_may_07 if prem~=105321 & unusable~=1 & prem~=129672 & prem~=148705 & summer_07~=. & summer_06~=. & percent_report<50 ,level(95) robust
test treat2==treat3


/* regression: Top 50th.  This is Model B in the table. */

regress summer_07 treat1 treat2 treat3 water_2006 apr_may_07 if prem~=105321 & unusable~=1 & prem~=129672 & prem~=148705 & summer_07~=. & summer_06~=. & percent_report>=50 ,level(95) robust
test treat2==treat3



/*

	Now let's look at the treatment effects in both the first and the last month after intervention to test for a waning effect.  This is Table 4 in the paper. The models are in the order they appear in the table. 

*/


regress jul07_3x treat1 treat2 treat3 jul06 if prem~=105321 & unusable~=1 & prem~=129672 & prem~=148705 & summer_07~=. & summer_06~=.,level(95) robust
regress oct07_3x treat1 treat2 treat3 oct06 if prem~=105321 & unusable~=1 & prem~=129672 & prem~=148705 & summer_07~=. & summer_06~=.,level(95) robust
regress jul07_3x treat1 treat2 treat3 jul06 if top50==0 & prem~=105321 & unusable~=1 & prem~=129672 & prem~=148705 & summer_07~=. & summer_06~=., level(95) robust
regress oct07_3x treat1 treat2 treat3 oct06 if top50==0 & prem~=105321 & unusable~=1 & prem~=129672 & prem~=148705 & summer_07~=. & summer_06~=., level(95) robust
regress jul07_3x treat1 treat2 treat3 jul06 if top50==1 & prem~=105321 & unusable~=1 & prem~=129672 & prem~=148705 & summer_07~=. & summer_06~=., level(95) robust
regress oct07_3x treat1 treat2 treat3 oct06 if top50==1 & prem~=105321 & unusable~=1 & prem~=129672 & prem~=148705 & summer_07~=. & summer_06~=., level(95) robust

log close

exit
