/** Study 1 **/ /** Change file pathname as needed **/

use "PATHNAME/study1_stata_initiate.dta"

/** initial file consists of the following 11 variables: [study=1; treatment=self/other; session=1-4; group=1-24; subject=1-96; period=1-10; actiontype=extraction/contribution; choice=extraction/contribution amount; runningchoice=cumulative extraction/contribution amount by period; threshold=amount of threshold created by group; metthreshold=dummy for group's contribution sufficient to meet threshold] **/


*******************************************************************************************
/** Result 1.1  **/ 
*******************************************************************************************
	/* SET OTHER=1 and SELF=0 */

gen tx_num = 0 

replace tx_num = 1 if treatment== "other.american.11" 

reg runningchoice tx_num if period==10 & actiontype=="extraction" , cluster(group)

/** Result 1.1 shows that OTHER appropriated 4.2 more than SELF on average (p=0.028)  **/ 
*******************************************************************************************


*************************************************************************************************************
/** Result 1.2  **/ 
*************************************************************************************************************
	/* Generate individual proportional contribution variables */

gen prop_contrib = choice / threshold if actiontype == "contribution"

gen prop_cum_contrib = runningchoice / threshold if actiontype == "contribution"

	/* Generate group proportional contribution variables */

sort group period

egen group_contrib = sum(choice) if actiontype == "contribution" , by(group period)

gen prop_contrib_group = group_contrib/threshold

egen group_cum_contrib = sum(runningchoice) if actiontype == "contribution" , by(group period)

gen prop_cum_contrib_group = group_cum_contrib/threshold


reg prop_cum_contrib tx_num if period==10 , cluster(group)


/** Result 1.2 shows that OTHER's proportional contributions are no different than those of SELF (p=0.46) **/ 
*************************************************************************************************************


saveold "PATHNAME/study1_stata_all-obs.dta", replace


/** get aggregate statistics for Figure 1A in the paper **/ 


tabulate tx_num if actiontype=="extraction" & period==10, summarize(runningchoice) 

/* For completeness: not necessary, because we don't report in the Figure: */
tabulate tx_num if actiontype=="contribution" & period==10, summarize(prop_cum_contrib) 

/** These results and results below & above, are copied into two .csv files: "figure-data_contribution.csv" & "figure-data_extraction.csv"
	These files are then read into an R program "Figures.R" which generates Figures 1A&1B in the paper. **/



****************************************************************************************************
/** Result 1.3  **/ 
****************************************************************************************************
sort group treatment actiontype period

keep if period==10

duplicates drop group treatment actiontype, force

*-- saveold "/Users/Reuben/Documents/Projects_current/Climate_pass-it-along/Data_studies1&2/study1_stata_group-obs.dta"

count if metthreshold==1 & actiontype=="contribution"
count if metthreshold==0 & actiontype=="contribution"
count if actiontype=="contribution"


/** Result 1.3 shows that 22 out of 24 groups met the treshold comapared to 5 of 10 for Milniski **/ 
****************************************************************************************************


clear

use "PATHNAME/study1_stata_all-obs.dta"

********************************************************
***** SUPPLEMENTARY DATA: PERIOD-by-PERIOD CHOICES *****
********************************************************
/** Supplement 1.1 EXTRACTION **/ 
 
tabulate tx_num period if actiontype=="extraction", summarize(choice)


/** Supplement 1.2 PROP CONTRIBUTION **/ 

tabulate tx_num period if actiontype=="contribution", summarize(prop_contrib)


/** Round-by-round analysis **/

/* setup the data as a time series */
	/* b/c periods 1-10 are repeated in both extraction and contribution, there are "repeated time values in panel" so we need to break it up into two files */
	
keep if actiontype=="extraction"

tsset subject period 

clear

use "PATHNAME/study1_stata_all-obs.dta"

keep if actiontype=="contribution"

tsset subject period 

/* now for contribuiton */

* .csv formatted data found in: "/Users/Reuben/Documents/Projects_current/Climate_pass-it-along/Data_studies1&2/Analysis/study.1.by.period.xlsx"
*************************************************************************************************************

********************************************************
********************************************************
********************************************************
********************************************************


/** Study 2 **/ /** Change file pathname as needed **/

use "PATHNAME/study2_stata_initiate.dta"

/** initial file consists of the following 10 variables: [confirmationcode=subject id; study=2; treatment=self12,self21,self11,other.indians.12,other.americans.12 group=1-124; actiontype=extraction/contribution; choice=extraction/contribution amount; threshold=amount of threshold created by group; guess=prediction of avg group behavior; metthreshold=dummy for group's contribution sufficient to meet threshold; avgcont=mean contribution used to determine metthreshold for groups with attrition in phase 2]**/

/** generate FACTOR variables **/

gen factor_self = .
replace factor_self = 1 if treatment=="self.11" | treatment=="self.12" | treatment=="self.21"
replace factor_self = 0 if treatment=="other.americans.12" | treatment=="other.indians.12"

gen factor_ratio = .
replace factor_ratio = 1 if treatment=="self.21" 
replace factor_ratio = 2 if treatment=="self.11"
replace factor_ratio = 3 if treatment=="self.12" | treatment=="other.americans.12" | treatment=="other.indians.12"

gen tx_12_other = .
replace tx_12_other = 1 if factor_ratio==3 & factor_self==0

replace tx_12_other = 0 if factor_ratio==3 & factor_self==1



/** Generate prop. contribution variable **/

gen prop_contrib = choice / threshold if actiontype=="contribution"

/** generate contrast to see if there is linear trend in self conditions **/
 /** Not currently reported in text**/
gen contrast=.
replace contrast=1 if treatment=="self.21"
replace contrast=0 if treatment=="self.11"
replace contrast=-1 if treatment=="self.12"

reg prop_contrib contrast 


/** create a file for aggregate data for Figures 1A and 1B in the paper, show the main tx effects for contribution and extraction **/

tabulate treatment if actiontype=="extraction", summarize(choice)

tabulate factor_self if actiontype=="extraction", summarize(choice)


/* For completeness: not necessary, because we don't report in the Figure: */
tabulate factor_ratio if actiontype=="extraction", summarize(choice)


tabulate treatment if actiontype=="contribution", summarize(prop_contrib)

tabulate factor_ratio if actiontype=="contribution", summarize(prop_contrib)


/* For completeness: not necessary, because we don't report in the Figure: */
tabulate factor_self if actiontype=="contribution", summarize(prop_contrib)

/** These results and results below, are copied into two .csv files: "figure-data_contribution.csv" & "figure-data_extraction.csv"
	These files are then read into an R program "Figures.R" which generates Figures 1A&1B in the paper. **/




*********************************************************************************************************************************
/** Result 2.1  **/ 
*********************************************************************************************************************************

ttest choice if actiontype=="extraction" & factor_self==0, by(treatment)

/** Result 2.1 shows that there is no difference between extraction amounts between the two "other" treatments p=0.98 **/ 
*********************************************************************************************************************************



****************************************************************************************************************************
/** Result 2.2 **/ 
****************************************************************************************************************************

/* comparing all treatments*/
oneway choice factor_ratio if actiontype=="extraction"

/* comparing only "self" treatments*/
oneway choice factor_ratio if actiontype=="extraction" & factor_self==1


/** Result 2.2 shows that there is no difference between extraction amounts by multiplier,both overall and for only self **/ 
****************************************************************************************************************************



*****************************************************************************************************
/** Result 2.3  **/ 
*****************************************************************************************************

ttest choice if actiontype=="extraction", by(factor_self)


ttest choice if actiontype=="extraction", by(tx_12_other)
 /* this test has 2-tailed p-value of 0.13; we're not currently reporting it */

/** Result 2.3 shows that "other" extraction amounts are sig greater thn "self", d=7.18, p=0.005  **/ 
*****************************************************************************************************



************************************************************************
/** Result 2.4 **/ 
************************************************************************

/* comparing all treatments*/
oneway prop_contrib factor_ratio if actiontype=="contribution", bonferroni

/* comparing only "self" treatments*/
oneway prop_contrib factor_ratio if actiontype=="contribution" & factor_self==1, bonferroni

/* comparing the "other" treatments */

ttest prop_contrib if actiontype=="contribution" & factor_self==0, by(treatment)


/** Result 2.4 shows that cont_21 > cont_12; _21 = _11 and _11 = _12 **/ 
************************************************************************


*****************************************************************************************
/** Result 2.5  **/ 
*****************************************************************************************

ttest choice if actiontype=="contribution" & factor_self==0, by(treatment)

/** Result 2.5 shows that "other" contribution amounts are not sig. diff from "self"  **/ 
*****************************************************************************************

/* proportion of groups meeting treshold by treatment */

count if treatment=="self.11" & actiontype=="contribution" 
count if treatment=="self.11" & actiontype=="contribution"  & metthreshold==1

count if treatment=="self.21" & actiontype=="contribution" 
count if treatment=="self.21" & actiontype=="contribution"  & metthreshold==1

count if treatment=="self.12" & actiontype=="contribution" 
count if treatment=="self.12" & actiontype=="contribution"  & metthreshold==1

count if treatment=="other.indians.12" & actiontype=="contribution" 
count if treatment=="other.indians.12" & actiontype=="contribution"  & metthreshold==1

count if treatment=="other.americans.12" & actiontype=="contribution" 
count if treatment=="other.americans.12" & actiontype=="contribution"  & metthreshold==1

keep if actiontype=="contribution"
duplicates drop group, force




