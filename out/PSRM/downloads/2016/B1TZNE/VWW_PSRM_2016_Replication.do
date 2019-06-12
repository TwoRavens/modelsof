* Replication file for Volden, Wiseman, Wittmer, Political Science Research and Methods, 2016
* All calculations and analysis below employ the data written in VWW_PSRM_2016_Replication_Dataset_Stata11.tab
* Scholar needs to import VWW_PSRM_2016_Replication_Dataset_Stata11.tab file into the same directory as this .do file before executing .do file 
* For Figure 1

*Importing data

import delimited VWW_PSRM_2016_Replication_Dataset_Stata11.tab

set more off
sort issue
by issue: sum dvlaw if female==1
by issue: sum dvlaw if female==0
by issue: reg dvlaw female
* Note: regressions used to show statistical significance marked in figure.
* Note: to translate these values to the precentages in the figure, multiple these proportions by 100.


* For Figure 2
tab female womensissue if issue~="Public Lands" & issue~="Government Operations"
tab female womensissue if dvaic==1 & issue~="Public Lands" & issue~="Government Operations"
tab female womensissue if dvlaw==1 & issue~="Public Lands" & issue~="Government Operations"
* Note: dvaic is an indicator variable taking a value of 1 if the bill receives "action in committee" and 0 otherwise.
* Note: dvlaw is an indicator variable taking a value of 1 if the bill becomes law and 0 otherwise.
* Note: the percentages in the pie charts are calcuated by dividing the number of women's issues bills by the total number of bills for each gender.
* Note: the values for number of bills introduced, receiving action in committee, and becoming law are based on these tables,
* coupled with the number of women (945) and men (8424) in Congress during this time period.
* Specifically: introductions for women: 12,251/945 = 13.0; and for men: 110,094/8424 = 13.1.
* Action in committee for women: 908/945 = 1.0; and for men: 12,386/8424 = 1.5.
* Becoming law for women: 212/945 = 0.2; and for men: 3199/8424 = 0.4.

* For Figure 3
sort congress
by congress: sum dvlaw if womensissue==0
by congress: sum dvlaw if womensissue==1 & female==1
by congress: sum dvlaw if womensissue==1 & female==0
* Note: to translate these values to the precentages in the figure, multiple these proportions by 100.

* For Table 1
* The following commands are used along with the fact that, across our time period there are 945 women in Congress and 8424 men.
sort issue
by issue: tab female if issueobs==1
by issue: tab female
*See Excel spreadsheet for calculations based on these value.

* For Table 2
* Model 1
logit dvlaw womensissue time, cluster(thomas_num)
* Model 2
logit dvlaw female time, cluster(thomas_num)
* Model 3
logit dvlaw womensissue female womensissue_female time, cluster(thomas_num)
* Model 4
logit dvlaw womensissue female womensissue_female seniority sensq state_leg state_leg_prof majority maj_leader min_leader speaker chair subchr power meddist afam latino deleg_size votepct votepct_sq time, cluster(thomas_num)
* Model 5
logit dvabc womensissue female womensissue_female seniority sensq state_leg state_leg_prof majority maj_leader min_leader speaker chair subchr power meddist afam latino deleg_size votepct votepct_sq time, cluster(thomas_num)

