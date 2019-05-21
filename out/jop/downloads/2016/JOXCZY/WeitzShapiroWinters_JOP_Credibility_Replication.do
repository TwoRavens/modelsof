/****************************************************************************/
/* Replication File for 													*/
/*																			*/
/* Matthew S. Winters and Rebecca Weitz-Shapiro								*/
/* "Can Citizens Discern? Information Credibility, 							*/
/* Political Sophistication, and the Punishment of Corruption in Brazil" 	*/
/* Journal of Politics										   				*/
/****************************************************************************/

**** Variables in Data ****

* quest - questionnaire number
* reg - respondent's region
* est_temp - respondent's state
* muni_name - respondent's city
* cond - indicator for whether the municipality is a capital city (1), peripheral (2), or in the interior (3)

* voteintent - "How likely would you be to vote for this mayor? Not at all likely (1) ... Very likely (4)
* feelingtherm - "On a scale from (1) to (7), where 1 is very bad and 7 is excellent, how good a mayor is Mayor Carlos?"

* vinheta - assignment to seven experimental conditions described in Table 1
* cred_vs_pure - indicator for credible source accusations (1) versus pure control group (0)
* cred_vs_clean - indicator for credible source accusations (1) versus explicitly clean politician control group (0)
* cred_vs_nosource - indicator for credible source accusations (1) versus unsourced accusations (0)
* cred_vs_less - indicator for credible source accusations (1) versus less-credible source accusations (0)
* cred_vs_control - indicator for credible source accusations (1) versus either pure control or explicitly clean politician (0)
* less_vs_pure - indicator for less-credible source accusations (1) versus pure control group (0)
* less_vs_clean - indicator for less-credible source accusations (1) versus explicitly clean politician control group (0)
* less_vs_nosource - indicator for less-credible source accusations (1) versus unsourced accusations (0)
* less_vs_control - indicator for less-credible source accusations (1) versus either pure control or explicitly clean politician (0)
* nosource_vs_pure - indicator for unsourced accusations (1) versus pure control group (0)
* nosource_vs_clean - indicator for unsourced accusations (1) versus explicitly clean politician control group (0)
* clean_vs_pure - indicator for explicitly clean politician control group (1) versus pure control group (0)
* cred - indicator for credible source accusations (1)
* lesscred - indicator for less-credible source accusations (1)
* nosource - indicator for unsourced corruption accusations (1)
* clean - indicator for explicitly clean politician (1)
* purecontrol - indicator for pure control condition (1)
* specific - indicator for specific accusation against mayor (1) versus accusations against municipal administration (0)

* highedu - indicator for people in the highest education category (0/1)
* education - five-value measure of education: incomplete primary school or less (0); complete primary school
 * but incomplete middle school (1); complete middle school but incomplete high school (2); complete
 * high school (3); at least some university (4)
* inst - raw data on education level
* highknow - indicator for people who correctly answered both political knowledge questions (0/1)
* polknowledge - number of correct answers to two political knowledge questions (0, 1, or 2)
* hightalk - indicator for people who express the highest amount of political discussion (0/1)
* talkpol - frequency of political discussion: never (1); sometimes (2); frequently (3)

* male - indicator for male (1) or female (0)
* agecat - six-value age classification: 16-24 (1); 25-34 (2); 35-44 (3); 45-54 (4); 55-64 (5); 65 and above (6)
* idade - raw age data
* socialclass - three-value scale of Brazilian social classes: D/E (1); C1/C2 (2); A1/A2/B1/B2 (3)
* classif - raw data on social class
* income - four-value scale of household income: less than one minimum salary (1); between 1 and 2 minimum
 * salaries (2); between 2 and 5 minimum salaries (3); more than 5 minimum salaries (4)
* rend2 - raw data on household income
* rend1 - raw data on personal income
* catholic - indicator for Catholic (1) or not (0)
* reli - raw data on religious affiliation
* news - three-value scale of frequency of reading the news: rarely or never (1); sometimes (2); everyday (3)
* ptid - indicator for PT partisan (1) or not (0)
* psdbid - indicator for PSDB partisan (1) or not (0)
* pmdbid - indicator for PMDB partisan (1) or not (0)
* noid - indicator for respondent with no party identification
* partyid - raw dara on party identification

* porte - seven-value categorization of municipalities: less than 5,000 people (1); 5,001 - 10,000 (2); 
 * 10,001 - 20,000 (3); 20,001 - 50,000 (4); 50,001 - 100,000 (5); 100,001 - 500,000 (6); more than 
 * 500,000 (7)

* id_gov - partisan identity of mayor of respondent's city
* partymatch - indicator for respondent with same party identity as local mayor (0/1)
* diffparty - indicator for respondent with party identity that is different from local mayor (0/1)
* copartisans_vs_partisans - indicator for respondents with party identification that is same as local mayor (1)
 * versus respondents with a partisan identity that is not the same as their local mayor (0)
* copartisans_vs_nonpartisans - indicator for respondents with party identification that is same as local mayor (1)
 * versus respondents with no partisan identity (0)
* nonpartisans_vs_partisans - indicator for respondents with no partisan identity (1) versus 
 * respondents with a partisan identity that is not the same as their local mayor (0)

use "Weitz-ShapiroWinters_JOP_Credibility_ReplicationData.dta"

*************************
*** TABLES FROM PAPER ***
*************************

/* Table 2 */

ttest voteintent, by(cred_vs_pure)
ranksum voteintent, by(cred_vs_pure)
ttest voteintent, by(cred_vs_clean)
ranksum voteintent, by(cred_vs_clean)
ttest voteintent, by(cred_vs_nosource)
ranksum voteintent, by(cred_vs_nosource)
ttest voteintent, by(cred_vs_less)
ranksum voteintent, by(cred_vs_less)

ttest voteintent, by(less_vs_pure)
ranksum voteintent, by(less_vs_pure)
ttest voteintent, by(less_vs_clean)
ranksum voteintent, by(less_vs_clean)
ttest voteintent, by(less_vs_nosource)
ranksum voteintent, by(less_vs_nosource)

ttest voteintent, by(nosource_vs_pure)
ranksum voteintent, by(nosource_vs_pure)
ttest voteintent, by(nosource_vs_clean)
ranksum voteintent, by(nosource_vs_clean)

ttest voteintent, by(clean_vs_pure)
ranksum voteintent, by(clean_vs_pure)

/* Table 3 */

ttest voteintent if educ < 4, by(cred_vs_less)
ranksum voteintent if educ < 4, by(cred_vs_less)
ttest voteintent if educ == 4, by(cred_vs_less)
ranksum voteintent if educ == 4, by(cred_vs_less)

ttest voteintent if polknow < 2, by(cred_vs_less)
ranksum voteintent if polknow < 2, by(cred_vs_less)
ttest voteintent if polknow == 2, by(cred_vs_less)
ranksum voteintent if polknow == 2, by(cred_vs_less)

ttest voteintent if talkpol < 3, by(cred_vs_less)
ranksum voteintent if talkpol < 3, by(cred_vs_less)
ttest voteintent if talkpol == 3, by(cred_vs_less)
ranksum voteintent if talkpol == 3, by(cred_vs_less)

ttest voteintent if cred_vs_less==1, by(highedu)
ranksum voteintent if cred_vs_less==1, by(highedu)
ttest voteintent if cred_vs_less==1, by(highknow)
ranksum voteintent if cred_vs_less==1, by(highknow)
ttest voteintent if cred_vs_less==1, by(hightalk)
ranksum voteintent if cred_vs_less==1, by(hightalk)

ttest voteintent if cred_vs_less==0, by(highedu)
ranksum voteintent if cred_vs_less==0, by(highedu)
ttest voteintent if cred_vs_less==0, by(highknow)
ranksum voteintent if cred_vs_less==0, by(highknow)
ttest voteintent if cred_vs_less==0, by(hightalk)
ranksum voteintent if cred_vs_less==0, by(hightalk)

 *** Significance tests for H0: No difference in CATEs found in 
 *** WeitzShapiroWinters_JOP_Credibility_Replication.R replication file.
 
***********************
*** APPENDIX TABLES *** 
***********************

/* Randomization Check */

mlogit vinheta male agecat education socialclass income catholic talkpol news polknowledge ptid psdbid pmdbid

 *** Associated plots found in WeitzShapiroWinters_JOP_Credibility_Replication.R replication file.

/* Correlations among Measures of Political Sophistication */

tab edu
tab polknow
tab talkpol

tab polknow edu, col
tab talkpol edu, col
tab talkpol polknow, col

/* Replication of Results using Regression Analysis */

* Table 2
reg voteintent cred_vs_pure male idade education socialclass income catholic talkpol news polknowledge ptid psdbid pmdbid, robust
reg voteintent cred_vs_clean male idade education socialclass income catholic talkpol news polknowledge ptid psdbid pmdbid, robust
reg voteintent cred_vs_nosource male idade education socialclass income catholic talkpol news polknowledge ptid psdbid pmdbid, robust
reg voteintent cred_vs_less male idade education socialclass income catholic talkpol news polknowledge ptid psdbid pmdbid, robust
reg voteintent less_vs_pure male  idade education socialclass income catholic talkpol news polknowledge ptid psdbid pmdbid, robust
reg voteintent less_vs_clean male  idade education socialclass income catholic talkpol news polknowledge ptid psdbid pmdbid, robust
reg voteintent less_vs_nosource male idade education socialclass income catholic talkpol news polknowledge ptid psdbid pmdbid, robust
reg voteintent nosource_vs_pure male idade education socialclass income catholic talkpol news polknowledge ptid psdbid pmdbid, robust
reg voteintent nosource_vs_clean male idade education socialclass income catholic talkpol news polknowledge ptid psdbid pmdbid, robust
reg voteintent clean_vs_pure male idade education socialclass income catholic talkpol news polknowledge ptid psdbid pmdbid, robust

* Table 3
reg voteintent cred_vs_less male idade socialclass income catholic news ptid psdbid pmdbid if education<4, robust
reg voteintent cred_vs_less male idade socialclass income catholic news ptid psdbid pmdbid if education==4, robust
reg voteintent cred_vs_less male idade socialclass income catholic news ptid psdbid pmdbid if polknow<2, robust
reg voteintent cred_vs_less male idade socialclass income catholic news ptid psdbid pmdbid if polknow==2, robust
reg voteintent cred_vs_less male idade socialclass income catholic news ptid psdbid pmdbid if talkpol<3, robust
reg voteintent cred_vs_less male idade socialclass income catholic news ptid psdbid pmdbid if talkpol==3, robust

/* Replication of Results using Only Vignettes that Specifically Accuse the Mayor */

* Table 2
ttest voteintent if specific==1, by(cred_vs_pure)
ranksum voteintent if specific==1, by(cred_vs_pure)
ttest voteintent if specific==1, by(cred_vs_clean)
ranksum voteintent if specific==1, by(cred_vs_clean)
ttest voteintent if specific==1, by(cred_vs_nosource)
ranksum voteintent if specific==1, by(cred_vs_nosource)
ttest voteintent if specific==1, by(cred_vs_less)
ranksum voteintent if specific==1, by(cred_vs_less)

ttest voteintent if specific==1, by(less_vs_pure)
ranksum voteintent if specific==1, by(less_vs_pure)
ttest voteintent if specific==1, by(less_vs_clean)
ranksum voteintent if specific==1, by(less_vs_clean)
ttest voteintent if specific==1, by(less_vs_nosource)
ranksum voteintent if specific==1, by(less_vs_nosource)

ttest voteintent if specific==1, by(nosource_vs_pure)
ranksum voteintent if specific==1, by(nosource_vs_pure)
ttest voteintent if specific==1, by(nosource_vs_clean)
ranksum voteintent if specific==1, by(nosource_vs_clean)

ttest voteintent if specific==1, by(clean_vs_pure)
ranksum voteintent if specific==1, by(clean_vs_pure)

* Table 3
ttest voteintent if educ < 4 & specific==1, by(cred_vs_less)
ttest voteintent if educ == 4 & specific==1, by(cred_vs_less)
ttest voteintent if polknow < 2 & specific==1, by(cred_vs_less)
ttest voteintent if polknow == 2 & specific==1, by(cred_vs_less)
ttest voteintent if talkpol < 3 & specific==1, by(cred_vs_less)
ttest voteintent if talkpol == 3 & specific==1, by(cred_vs_less)
 
 *** Significance tests for H0: No difference in CATEs found in 
 *** WeitzShapiroWinters_JOP_Credibility_Replication.R replication file.

/* CATEs for PT Partisans and Others */
 
ttest voteintent if ptid==0, by(cred_vs_less)
ranksum voteintent if ptid==0, by(cred_vs_less)
ttest voteintent if ptid==1, by(cred_vs_less)
ranksum voteintent if ptid==1, by(cred_vs_less)

ttest voteintent if cred_vs_less==0, by(ptid)
ranksum voteintent if cred_vs_less==0, by(ptid)
ttest voteintent if cred_vs_less==1, by(ptid)
ranksum voteintent if cred_vs_less==1, by(ptid)

 *** Significance tests for H0: No difference in CATEs found in 
 *** WeitzShapiroWinters_JOP_Credibility_Replication.R replication file.

/* Differneces between More and Less Sophisticated Respondents for Non-PT Supporters Only */
 
ttest voteintent if educ < 4 & ptid==0, by(cred_vs_less)
ranksum voteintent if educ < 4 & ptid==0, by(cred_vs_less)
ttest voteintent if educ == 4 & ptid==0, by(cred_vs_less)
ranksum voteintent if educ == 4 & ptid==0, by(cred_vs_less)

ttest voteintent if polknow < 2 & ptid==0, by(cred_vs_less)
ranksum voteintent if polknow < 2 & ptid==0, by(cred_vs_less)
ttest voteintent if polknow == 2 & ptid==0, by(cred_vs_less)
ranksum voteintent if polknow == 2 & ptid==0, by(cred_vs_less)

ttest voteintent if talkpol < 3 & ptid==0, by(cred_vs_less)
ranksum voteintent if talkpol < 3 & ptid==0, by(cred_vs_less)
ttest voteintent if talkpol == 3 & ptid==0, by(cred_vs_less)
ranksum voteintent if talkpol == 3 & ptid==0, by(cred_vs_less)

/* Average Vote Intention for Hypothetical Mayor by Relationship with Real-World Mayor */

ttest voteintent, by(copartisans_vs_partisans)
ttest voteintent, by(copartisans_vs_nonpartisans)
ttest voteintent, by(nonpartisans_vs_partisans)
ranksum voteintent, by(copartisans_vs_partisans)
ranksum voteintent, by(copartisans_vs_nonpartisans)
ranksum voteintent, by(nonpartisans_vs_partisans)

/* Average Vote Intention for Hypothetical Mayor within Treatment Conditions by 
 Relationship with Real-World Mayor */

ttest voteintent if cred==1, by(copartisans_vs_partisans)
ranksum voteintent if cred==1, by(copartisans_vs_partisans)
ttest voteintent if lesscred==1, by(copartisans_vs_partisans)
ranksum voteintent if lesscred==1, by(copartisans_vs_partisans)
ttest voteintent if nosource==1, by(copartisans_vs_partisans)
ranksum voteintent if nosource==1, by(copartisans_vs_partisans)
ttest voteintent if clean==1, by(copartisans_vs_partisans)
ranksum voteintent if clean==1, by(copartisans_vs_partisans)
ttest voteintent if purecontrol==1, by(copartisans_vs_partisans)
ranksum voteintent if purecontrol==1, by(copartisans_vs_partisans)

ttest voteintent if cred==1, by(copartisans_vs_nonpartisans)
ranksum voteintent if cred==1, by(copartisans_vs_nonpartisans)
ttest voteintent if lesscred==1, by(copartisans_vs_nonpartisans)
ranksum voteintent if lesscred==1, by(copartisans_vs_nonpartisans)
ttest voteintent if nosource==1, by(copartisans_vs_nonpartisans)
ranksum voteintent if nosource==1, by(copartisans_vs_nonpartisans)
ttest voteintent if clean==1, by(copartisans_vs_nonpartisans)
ranksum voteintent if clean==1, by(copartisans_vs_nonpartisans)
ttest voteintent if purecontrol==1, by(copartisans_vs_nonpartisans)
ranksum voteintent if purecontrol==1, by(copartisans_vs_nonpartisans)

/* Differences in Conditional Average Treatment Effect for Credible verus Less Credible 
 Accusations by Relationship with Real-World Mayor */

 *** See WeitzShapiroWinters_JOP_Credibility_Replication.R replication file.

/* Differences between More and Less Sophisticated Respondents (Non-Partisans Only) */

ttest voteintent if educ < 4 & noid==1, by(cred_vs_less)
ranksum voteintent if educ < 4 & noid==1, by(cred_vs_less)
ttest voteintent if educ == 4 & noid==1, by(cred_vs_less)
ranksum voteintent if educ == 4 & noid==1, by(cred_vs_less)

ttest voteintent if polknow < 2 & noid==1, by(cred_vs_less)
ranksum voteintent if polknow < 2 & noid==1, by(cred_vs_less)
ttest voteintent if polknow == 2 & noid==1, by(cred_vs_less)
ranksum voteintent if polknow == 2 & noid==1, by(cred_vs_less)

ttest voteintent if talkpol < 3 & noid==1, by(cred_vs_less)
ranksum voteintent if talkpol < 3 & noid==1, by(cred_vs_less)
ttest voteintent if talkpol == 3 & noid==1, by(cred_vs_less)
ranksum voteintent if talkpol == 3 & noid==1, by(cred_vs_less)
 
/* Discernment by All Levels of Education */

ttest voteintent if edu==0, by(cred_vs_less)
ttest voteintent if edu==1, by(cred_vs_less)
ttest voteintent if edu==2, by(cred_vs_less)
ttest voteintent if edu==3, by(cred_vs_less)
ttest voteintent if edu==4, by(cred_vs_less)

 *** Significance tests for H0: No difference in CATEs found in 
 *** WeitzShapiroWinters_JOP_Credibility_Replication.R replication file.

/* Discernment by All Levels of Political Knowledge */

ttest voteintent if polknow==0, by(cred_vs_less)
ttest voteintent if polknow==1, by(cred_vs_less)
ttest voteintent if polknow==2, by(cred_vs_less)

 *** Significance tests for H0: No difference in CATEs found in 
 *** WeitzShapiroWinters_JOP_Credibility_Replication.R replication file.

/* Discernment by All Levels of Political Discussion */
 
ttest voteintent if talkpol==1, by(cred_vs_less)
ttest voteintent if talkpol==2, by(cred_vs_less)
ttest voteintent if talkpol==3, by(cred_vs_less)
 
 *** Significance tests for H0: No difference in CATEs found in 
 *** WeitzShapiroWinters_JOP_Credibility_Replication.R replication file.
 
/* Discernment by Index of Political Sophistication */

gen sophistication_index = educ + polknowledge + talkpol 
 
ttest voteintent if sophistication_index < 4, by(cred_vs_less) 
ttest voteintent if sophistication_index >= 4 & sophistication_index < 7, by(cred_vs_less) 
ttest voteintent if sophistication_index >= 7 & sophistication_index !=., by(cred_vs_less) 
 
/* Comparison with Unsourced Accusations across Levels of Sophistication */

ttest voteintent if educ < 4, by(less_vs_nosource)
ranksum voteintent if educ < 4, by(less_vs_nosource)
ttest voteintent if educ < 4, by(cred_vs_nosource)
ranksum voteintent if educ < 4, by(cred_vs_nosource)

ttest voteintent if educ==4, by(less_vs_nosource)
ranksum voteintent if educ==4, by(less_vs_nosource)
ttest voteintent if educ==4, by(cred_vs_nosource)
ranksum voteintent if educ==4, by(cred_vs_nosource)

ttest voteintent if polknow < 2, by(less_vs_nosource)
ranksum voteintent if polknow < 2, by(less_vs_nosource)
ttest voteintent if polknow < 2, by(cred_vs_nosource)
ranksum voteintent if polknow < 2, by(cred_vs_nosource)

ttest voteintent if polknow==2, by(less_vs_nosource)
ranksum voteintent if polknow==2, by(less_vs_nosource)
ttest voteintent if polknow==2, by(cred_vs_nosource)
ranksum voteintent if polknow==2, by(cred_vs_nosource)

ttest voteintent if talkpol<3, by(less_vs_nosource)
ranksum voteintent if talkpol<3, by(less_vs_nosource)
ttest voteintent if talkpol<3, by(cred_vs_nosource)
ranksum voteintent if talkpol<3, by(cred_vs_nosource)

ttest voteintent if talkpol==3, by(less_vs_nosource)
ranksum voteintent if talkpol==3, by(less_vs_nosource)
ttest voteintent if talkpol==3, by(cred_vs_nosource)
ranksum voteintent if talkpol==3, by(cred_vs_nosource)

/* Comparison with Control Conditions across Levels of Sophistication */

ttest voteintent if educ < 4, by(less_vs_control)
ranksum voteintent if educ < 4, by(less_vs_control)
ttest voteintent if educ < 4, by(cred_vs_control)
ranksum voteintent if educ < 4, by(cred_vs_control)

ttest voteintent if educ==4, by(less_vs_control)
ranksum voteintent if educ==4, by(less_vs_control)
ttest voteintent if educ==4, by(cred_vs_control)
ranksum voteintent if educ==4, by(cred_vs_control)

ttest voteintent if polknow < 2, by(less_vs_control)
ranksum voteintent if polknow < 2, by(less_vs_control)
ttest voteintent if polknow < 2, by(cred_vs_control)
ranksum voteintent if polknow < 2, by(cred_vs_control)

ttest voteintent if polknow==2, by(less_vs_control)
ranksum voteintent if polknow==2, by(less_vs_control)
ttest voteintent if polknow==2, by(cred_vs_control)
ranksum voteintent if polknow==2, by(cred_vs_control)

ttest voteintent if talkpol<3, by(less_vs_control)
ranksum voteintent if talkpol<3, by(less_vs_control)
ttest voteintent if talkpol<3, by(cred_vs_control)
ranksum voteintent if talkpol<3, by(cred_vs_control)

ttest voteintent if talkpol==3, by(less_vs_control)
ranksum voteintent if talkpol==3, by(less_vs_control)
ttest voteintent if talkpol==3, by(cred_vs_control)
ranksum voteintent if talkpol==3, by(cred_vs_control)

/* Replication of Table 2 with Feeling Thermometer Outcome */

ttest feelingtherm, by(cred_vs_pure)
ttest feelingtherm, by(cred_vs_clean)
ttest feelingtherm, by(cred_vs_nosource)
ttest feelingtherm, by(cred_vs_less)
ttest feelingtherm, by(less_vs_pure)
ttest feelingtherm, by(less_vs_clean)
ttest feelingtherm, by(less_vs_nosource)
ttest feelingtherm, by(nosource_vs_pure)
ttest feelingtherm, by(nosource_vs_clean)
ttest feelingtherm, by(clean_vs_pure)

/* Replication of Table 3 with Feeling Thermometer Outcome */

ttest feelingtherm if educ < 4, by(cred_vs_less)
ttest feelingtherm if educ == 4, by(cred_vs_less)
ttest feelingtherm if polknow < 2, by(cred_vs_less)
ttest feelingtherm if polknow == 2, by(cred_vs_less)
ttest feelingtherm if talkpol < 3, by(cred_vs_less)
ttest feelingtherm if talkpol == 3, by(cred_vs_less)
 
 *** Significance tests for H0: No difference in CATEs found in 
 *** WeitzShapiroWinters_JOP_Credibility_Replication.R replication file.


/* END OF FILE */
