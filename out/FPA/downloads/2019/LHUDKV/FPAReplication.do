* This .do file uses the 2016 CCGA Leader Survey and a 2017 YouGov Survey commissioned by the 
* Texas National Security Network to generate the tables in the paper "Multilateralism and the
* Use of Force: Experimental Evidence on the Views of Foreign Policy Elites."

* Note: To preserve anonymity, a variable indicating whether a respondent had served in a foreign policy position 
* in the Executive Branch (previously or at the time of the survey) was generated in a separate file, and 
* any potentially identifying information related to this reported government service has been removed.

cd "/Users/jonathanmonten/Dropbox/CCGA Survey Project/Survey Experiment Paper/FPA/Replication"
log using "FPAReplication.log", replace

*** Clean Elite Dataset

use "AllGroups_dropINC_Anonymous.dta" 
save "MultilateralismExperiment.dta", replace

* Define Experimental Conditions

gen Condition = .
replace Condition = 0 if condition == "UNILATERAL"
replace Condition = 1 if condition == "UN"
label variable Condition "Experimental Condition"
label define condition 0 "Unilateral" 1 "UN"
label values Condition condition

* Define New Group Variable With Consolidated Interest Group Category */

gen groupnew = 0
replace groupnew = 1 if group == 1 /* academic */
replace groupnew = 4 if group == 2 /* business -> interest group category */ 
replace groupnew = 2 if group == 3 /* congress */
replace groupnew = 3 if group == 4 /* executive branch */
replace groupnew = 4 if group == 5 /* interest groups -> interest group category */
replace groupnew = 4 if group == 6 /* labor -> interest group category */
replace groupnew = 5 if group == 7 /* media */
replace groupnew = 4 if group == 8 /* religion -> interest group category */
replace groupnew = 6 if group == 9 /* think tank */
label variable groupnew "Professional Groups"
label define groupnewlabels 1 "Academic" 2 "Congress" 3 "Executive" 4 "Interest Groups" 5 "Media" 6 "Think Tank"
label values groupnew groupnewlabels

* Recode indicator variables for each scenario as 0 "Oppose" 1 "Favor" 

label define batteryfavoroppose 0 "Oppose" 1 "Favor"

gen KoreaForce = nq30_1
recode KoreaForce (2=0)
label values KoreaForce batteryfavoroppose
label variable KoreaForce "If North Korea Invaded South Korea"

gen GenocideForce = nq30_2
recode GenocideForce (2=0) 
label values GenocideForce batteryfavoroppose
label variable GenocideForce "To Stop a Government From Committing Genocide"

gen IsraelForce = nq30_3
recode IsraelForce (2=0) 
label values IsraelForce batteryfavoroppose
label variable IsraelForce "If Israel Were Attacked"

gen IranForce = nq30_4
recode IranForce (2=0) 
label values IranForce batteryfavoroppose
label variable IranForce "To Stop Iran from Obtaining Nuclear Weapons"

gen IraqSyriaForce = nq30_5
recode IraqSyriaForce (2=0)
label values IraqSyriaForce batteryfavoroppose
label variable IraqSyriaForce "To Fight Violent Islamic Extremist Groups in Iraq and Syria"

gen OilForce = nq30_6
recode OilForce (2=0)
label values OilForce batteryfavoroppose
label variable OilForce "To Ensure the Oil Supply"

gen HumanForce = nq30_7
recode HumanForce (2=0) 
label values HumanForce batteryfavorforce
label variable HumanForce "To Deal with Humanitarian Crises"

gen AllScenarios = (KoreaForce + GenocideForce + IsraelForce + IranForce + IraqSyriaForce + OilForce + HumanForce)/7
label variable AllScenarios "All Scenarios (Average)"

* Generate Indicator for Manipulation Check

gen correct = 0
replace correct = 1 if Condition == 0 & nq30_common == 4
replace correct = 1 if Condition == 1 & nq30_common == 3
replace correct = . if nq30_common == .

* Generate Indicator for Elite Sample

gen elite = 1

* Generate Descriptive Variables for Appendix Tables

gen activepart = 0
replace activepart = 1 if q2 == 1

gen democrat = 0
replace democrat = 1 if q1010 == 2
replace democrat = . if q1010 == .

gen male = 0
replace male = 1 if gender == 1
replace male = . if gender == .

gen over45 = 0
replace over45 = 1 if age == 3 | age == 4 | age == 5
replace over45 = . if age == . 

gen white = 0
replace white = 1 if race == 1
replace white = . if race == .

gen postgrad = 0
replace postgrad = 1 if edu == 4
replace postgrad = . if edu == .

gen strengthenunvery = 0
replace strengthenunvery = 1 if q8_1 == 1 
replace strengthenunvery = . if q8_1 == .

gen superiormilapproachvery = 0
replace superiormilapproachvery = 1 if q8_2 == 1 
replace superiormilapproachvery = . if q8_2 == .

save "MultilateralismExperiment.dta", replace

*** Clean Public Dataset

use  "UTEX0032_OUTPUT.dta"
save "UTEX0032_OUTPUT_premerge.dta", replace

* Define Experimental Conditions

gen Condition = .
replace Condition = 0 if condition == 1
replace Condition = 1 if condition == 2
label variable Condition "Experimental Condition"
label values Condition condition

* Recode dummy variables for each scenario as 0 "Oppose" 1 "Favor" 

gen KoreaForce = Q4_1
recode KoreaForce (2=0)
label values KoreaForce batteryfavoroppose
label variable KoreaForce "If North Korea Invaded South Korea"

gen GenocideForce = Q4_2
recode GenocideForce (2=0) 
label values GenocideForce batteryfavoroppose
label variable GenocideForce "To Stop a Government From Committing Genocide"

gen IsraelForce = Q4_3
recode IsraelForce (2=0) 
label values IsraelForce batteryfavoroppose
label variable IsraelForce "If Israel Were Attacked"

gen IranForce = Q4_4
recode IranForce (2=0) 
label values IranForce batteryfavoroppose
label variable IranForce "To Stop Iran from Obtaining Nuclear Weapons"

gen IraqSyriaForce = Q4_5
recode IraqSyriaForce (2=0)
label values IraqSyriaForce batteryfavoroppose
label variable IraqSyriaForce "To Fight Violent Islamic Extremist Groups in Iraq and Syria"

gen OilForce = Q4_6
recode OilForce (2=0)
label values OilForce batteryfavoroppose
label variable OilForce "To Ensure the Oil Supply"

gen HumanForce = Q4_7
recode HumanForce (2=0) 
label values HumanForce batteryfavorforce
label variable HumanForce "To Deal with Humanitarian Crises"

gen AllScenarios = (KoreaForce + GenocideForce + IsraelForce + IranForce + IraqSyriaForce + OilForce + HumanForce)/7
label variable AllScenarios "All Scenarios (Average)"

* Generate Indicator for Manipulation Check

gen correct = 0
replace correct = 1 if Condition == 0 & Q4_COMMON == 4
replace correct = 1 if Condition == 1 & Q4_COMMON == 3

* Generate Indicator for Elite Sample

gen elite = 0

* Generate Descriptive Variables for Appendix Tables

gen activepart = 0
replace activepart = 1 if Q1 == 1
replace activepart = . if Q1 == 8

gen democrat = 0
replace democrat = 1 if pid3 == 1

gen male = 0
replace male = 1 if gender == 1

gen over45 = 0
replace over45 = 1 if birthyr >= 1972

gen white = 0
replace white = 1 if race == 1

gen postgrad = 0
replace postgrad = 1 if educ == 6

gen strengthenunvery = 0
replace strengthenunvery = 1 if Q3_1 == 1 

gen superiormilapproachvery = 0
replace superiormilapproachvery = 1 if Q3_2 == 1 

save "UTEX0032_OUTPUT_premerge.dta", replace

*** Merge Elite and Public Datasets

use "MultilateralismExperiment.dta"

append using "UTEX0032_OUTPUT_premerge.dta", ///
 keep(Condition KoreaForce GenocideForce IsraelForce IranForce IraqSyriaForce OilForce HumanForce AllScenarios ///
 activepart democrat male over45 white postgrad correct strengthenunvery superiormilapproachvery elite weight pid3)
 
*** Table 1. Effect of UNSC Authorization on Support for the Use of Force

* Elites
tab KoreaForce Condition if elite == 1 & correct == 1, chi2 col
tab GenocideForce Condition if elite == 1 & correct == 1, chi2 col
tab IsraelForce Condition if elite == 1 & correct == 1, chi2 col
tab IranForce  Condition if elite == 1 & correct == 1, chi2 col
tab IraqSyriaForce Condition if elite == 1 & correct == 1, chi2 col
tab OilForce Condition if elite == 1 & correct == 1, chi2 col
tab HumanForce Condition if elite == 1 & correct == 1, chi2 col
ttest AllScenarios if elite == 1 & correct == 1, by(Condition)

* Public
tab KoreaForce Condition if elite == 0 & correct == 1, chi2 col
tab GenocideForce Condition if elite == 0 & correct == 1, chi2 col
tab IsraelForce Condition if elite == 0 & correct == 1, chi2 col
tab IranForce  Condition if elite == 0 & correct == 1, chi2 col
tab IraqSyriaForce Condition if elite == 0 & correct == 1, chi2 col
tab OilForce Condition if elite == 0 & correct == 1, chi2 col
tab HumanForce Condition if elite == 0 & correct == 1, chi2 col
ttest AllScenarios if elite == 0 & correct == 1, by(Condition)

* Executive Branch Experience
tab KoreaForce Condition if Exec == 1 & correct == 1, chi2 col
tab GenocideForce Condition if Exec == 1 & correct == 1, chi2 col
tab IsraelForce Condition if Exec == 1 & correct == 1, chi2 col
tab IranForce  Condition if Exec == 1 & correct == 1, chi2 col
tab IraqSyriaForce Condition if Exec == 1 & correct == 1, chi2 col
tab OilForce Condition if Exec == 1 & correct == 1, chi2 col
tab HumanForce Condition if Exec == 1 & correct == 1, chi2 col
ttest AllScenarios if Exec == 1 & correct == 1, by(Condition)

*** Table 2. Effect of UNSC Authorization on Support for the Use of Force by Partisanship

* Elites: Republican
tab KoreaForce Condition if elite == 1 & q1010 == 1 & correct == 1, chi2 col
tab GenocideForce Condition if elite == 1 & q1010 == 1 & correct == 1, chi2 col
tab IsraelForce Condition if elite == 1 & q1010 == 1 & correct == 1, chi2 col
tab IranForce  Condition if elite == 1 & q1010 == 1 & correct == 1, chi2 col
tab IraqSyriaForce Condition if elite == 1 & q1010 == 1 & correct == 1, chi2 col
tab OilForce Condition if elite == 1 & q1010 == 1 & correct == 1, chi2 col
tab HumanForce Condition if elite == 1 & q1010 == 1 & correct == 1, chi2 col
ttest AllScenarios if elite == 1 & q1010 == 1 & correct == 1, by(Condition)

* Elites: Democrat
tab KoreaForce Condition if elite == 1 & q1010 == 2 & correct == 1, chi2 col
tab GenocideForce Condition if elite == 1 & q1010 == 2 & correct == 1, chi2 col
tab IsraelForce Condition if elite == 1 & q1010 == 2 & correct == 1, chi2 col
tab IranForce  Condition if elite == 1 & q1010 == 2 & correct == 1, chi2 col
tab IraqSyriaForce Condition if elite == 1 & q1010 == 2 & correct == 1, chi2 col
tab OilForce Condition if elite == 1 & q1010 == 2 & correct == 1, chi2 col
tab HumanForce Condition if elite == 1 & q1010 == 2 & correct == 1, chi2 col
ttest AllScenarios if elite == 1 & q1010 == 2 & correct == 1, by(Condition)

* Elites: Independent
tab KoreaForce Condition if elite == 1 & q1010 == 3 & correct == 1, chi2 col
tab GenocideForce Condition if elite == 1 & q1010 == 3 & correct == 1, chi2 col
tab IsraelForce Condition if elite == 1 & q1010 == 3 & correct == 1, chi2 col
tab IranForce  Condition if elite == 1 & q1010 == 3 & correct == 1, chi2 col
tab IraqSyriaForce Condition if elite == 1 &  q1010 == 3 & correct == 1, chi2 col
tab OilForce Condition if elite == 1 & q1010 == 3 & correct == 1, chi2 col
tab HumanForce Condition if elite == 1 & q1010 == 3 & correct == 1, chi2 col
ttest AllScenarios if elite == 1 & q1010 == 3 & correct == 1, by(Condition)

* Public: Republican
tab KoreaForce Condition if elite == 0 & pid3 == 2 & correct == 1, chi2 col
tab GenocideForce Condition if elite == 0 & pid3 == 2 & correct == 1, chi2 col
tab IsraelForce Condition if elite == 0 & pid3 == 2 & correct == 1, chi2 col
tab IranForce Condition if elite == 0 & pid3 == 2 & correct == 1, chi2 col
tab IraqSyriaForce Condition if elite == 0 & pid3 == 2 & correct == 1, chi2 col
tab OilForce Condition if elite == 0 & pid3 == 2 & correct == 1, chi2 col
tab HumanForce Condition if elite == 0 & pid3 == 2 & correct == 1, chi2 col
ttest AllScenarios if elite == 0 & pid3 == 2 & correct == 1, by(Condition)

* Public: Democrat 
tab KoreaForce Condition if elite == 0 & pid3 == 1 & correct == 1, chi2 col
tab GenocideForce Condition if elite == 0 & pid3 == 1 & correct == 1, chi2 col
tab IsraelForce Condition if elite == 0 & pid3 == 1 & correct == 1, chi2 col
tab IranForce Condition if elite == 0 & pid3 == 1 & correct == 1, chi2 col
tab IraqSyriaForce Condition if elite == 0 & pid3 == 1 & correct == 1, chi2 col
tab OilForce Condition if elite == 0 & pid3 == 1 & correct == 1, chi2 col
tab HumanForce Condition if elite == 0 & pid3 == 1 & correct == 1, chi2 col
ttest AllScenarios if elite == 0 & pid3 == 1 & correct == 1, by(Condition)

* Public: Independent 
tab KoreaForce Condition if elite == 0 & pid3 == 3 & correct == 1, chi2 col
tab GenocideForce Condition if elite == 0 & pid3 == 3 & correct == 1, chi2 col
tab IsraelForce Condition if elite == 0 & pid3 == 3 & correct == 1, chi2 col
tab IranForce Condition if elite == 0 & pid3 == 3 & correct == 1, chi2 col
tab IraqSyriaForce Condition if elite == 0 & pid3 == 3 & correct == 1, chi2 col
tab OilForce Condition if elite == 0 & pid3 == 3 & correct == 1, chi2 col
tab HumanForce Condition if elite == 0 & pid3 == 3 & correct == 1, chi2 col
ttest AllScenarios if elite == 0 & pid3 == 3 & correct == 1, by(Condition)

*** Appendix Table B1. Descriptive Statistics for Foreign Policy Elite and Public Samples

* Elites
tab activepart if elite == 1
tab strengthenunvery if elite == 1
tab superiormilapproachvery if elite == 1
tab democrat if elite == 1
tab male if elite == 1
tab over45 if elite == 1
tab white if elite == 1
tab postgrad if elite == 1

* Public
tab activepart if elite == 0
tab strengthenunvery if elite == 0
tab superiormilapproachvery if elite == 0
tab democrat if elite == 0
tab male if elite == 0
tab over45 if elite == 0
tab white if elite == 0
tab postgrad if elite == 0

* Executive Branch Experience 
tab activepart if Exec == 1
tab strengthenunvery if Exec == 1
tab superiormilapproachvery if Exec == 1
tab democrat if Exec == 1
tab male if Exec == 1
tab over45 if Exec == 1
tab white if Exec == 1
tab postgrad if Exec == 1

*** Table B2. Covariate Balance Across Treatment and Control Groups 

* Elites
prtest activepart if elite == 1, by(Condition)
prtest strengthenunvery if elite == 1, by(Condition)
prtest superiormilapproachvery if elite == 1, by(Condition)
prtest democrat if elite == 1, by(Condition)
prtest male if elite == 1, by(Condition)
prtest over45 if elite == 1, by(Condition)
prtest white if elite == 1, by(Condition)
prtest postgrad if elite == 1, by(Condition)

* Public
prtest activepart if elite == 0, by(Condition)
prtest strengthenunvery if elite == 0, by(Condition)
prtest superiormilapproachvery if elite == 0, by(Condition)
prtest democrat if elite == 0, by(Condition)
prtest male if elite == 0, by(Condition)
prtest over45 if elite == 0, by(Condition)
prtest white if elite == 0, by(Condition)
prtest postgrad if elite == 0, by(Condition)

* Executive Branch Experience
prtest activepart if Exec == 1, by(Condition)
prtest strengthenunvery if Exec == 1, by(Condition)
prtest superiormilapproachvery if Exec == 1, by(Condition)
prtest democrat if Exec == 1, by(Condition)
prtest male if Exec == 1, by(Condition)
prtest over45 if Exec == 1, by(Condition)
prtest white if Exec == 1, by(Condition)
prtest postgrad if Exec == 1, by(Condition)

* Table B3. Covariate Balance: Excluding Respondents that Failed Manipulation Check

* Elites
prtest activepart if elite == 1 & correct == 1, by(Condition)
prtest strengthenunvery if elite == 1 & correct == 1, by(Condition)
prtest superiormilapproachvery if elite == 1 & correct == 1, by(Condition)
prtest democrat if elite == 1 & correct == 1, by(Condition)
prtest male if elite == 1 & correct == 1, by(Condition)
prtest over45 if elite == 1 & correct == 1, by(Condition)
prtest white if elite == 1 & correct == 1, by(Condition)
prtest postgrad if elite == 1 & correct == 1, by(Condition)

* Public
prtest activepart if elite == 0 & correct == 1, by(Condition)
prtest strengthenunvery if elite == 0 & correct == 1, by(Condition)
prtest superiormilapproachvery if elite == 0 & correct == 1, by(Condition)
prtest democrat if elite == 0 & correct == 1, by(Condition)
prtest male if elite == 0 & correct == 1, by(Condition)
prtest over45 if elite == 0 & correct == 1, by(Condition)
prtest white if elite == 0 & correct == 1, by(Condition)
prtest postgrad if elite == 0 & correct == 1, by(Condition)

* Executive Branch Experience
prtest activepart if Exec == 1 & correct == 1, by(Condition)
prtest strengthenunvery if Exec == 1 & correct == 1, by(Condition)
prtest superiormilapproachvery if Exec ==1 & correct == 1, by(Condition)
prtest democrat if Exec == 1 & correct == 1, by(Condition)
prtest male if Exec == 1 & correct == 1, by(Condition)
prtest over45 if Exec == 1 & correct == 1, by(Condition)
prtest white if Exec == 1 & correct == 1, by(Condition)
prtest postgrad if Exec == 1 & correct == 1, by(Condition)

*** Table B4. Effect of UNSC Authorization on Support for the Use of Force: Alternative Weighting (Elite Sample)

* No Weights
tab KoreaForce Condition if elite == 1 & correct == 1, chi2 col
tab GenocideForce Condition if elite == 1 & correct == 1, chi2 col
tab IsraelForce Condition if elite == 1 & correct == 1, chi2 col
tab IranForce  Condition if elite == 1 & correct == 1, chi2 col
tab IraqSyriaForce Condition if elite == 1 & correct == 1, chi2 col
tab OilForce Condition if elite == 1 & correct == 1, chi2 col
tab HumanForce Condition if elite == 1 & correct == 1, chi2 col
ttest AllScenarios if elite == 1 & correct == 1, by(Condition)

* Equal Group Weights

/* Add Equal Weights (With Aggregated Interest Group) */ 
/* Weights Calculated by Authors */
gen equalwt=.
replace equalwt = 0.7401 if groupnew==1
replace equalwt = 0.4862 if groupnew==2
replace equalwt = 0.6198 if groupnew==3
replace equalwt = 0.9545 if groupnew==4
replace equalwt = 0.8306 if groupnew==5
replace equalwt = 1.5868 if groupnew==6
label var equalwt "Equal Weight (Combined Interest Group Category)

svyset [iweight = equalwt]
svy: tab Condition KoreaForce if elite == 1 & correct == 1, row
svy: tab Condition GenocideForce if elite == 1 & correct == 1, row 
svy: tab Condition IsraelForce if elite == 1 & correct == 1, row 
svy: tab Condition IranForce if elite == 1 & correct == 1, row 
svy: tab Condition IraqSyriaForce if elite == 1 & correct == 1, row 
svy: tab Condition OilForce if elite == 1 & correct == 1, row 
svy: tab Condition HumanForce if elite == 1 & correct == 1, row 
svy: mean AllScenarios if elite == 1 & correct == 1, over(Condition)
 svy: regress AllScenarios Condition if elite == 1 & correct == 1

*** Table B5. Effect of UNSC Authorization on Support for the Use of Force: Alternative Weighting (Public Sample) 

* No Weights
tab KoreaForce Condition if elite == 0 & correct == 1, chi2 col
tab GenocideForce Condition if elite == 0 & correct == 1, chi2 col
tab IsraelForce Condition if elite == 0 & correct == 1, chi2 col
tab IranForce  Condition if elite == 0 & correct == 1, chi2 col
tab IraqSyriaForce Condition if elite == 0 & correct == 1, chi2 col
tab OilForce Condition if elite == 0 & correct == 1, chi2 col
tab HumanForce Condition if elite == 0 & correct == 1, chi2 col
ttest AllScenarios if elite == 0 & correct == 1, by(Condition)

* Population Weights
svyset [pweight = weight]
svy: tab Condition KoreaForce if elite == 0 & correct == 1, row
svy: tab Condition GenocideForce if elite == 0 & correct == 1, row 
svy: tab Condition IsraelForce if elite == 0 & correct == 1, row 
svy: tab Condition IranForce if elite == 0 & correct == 1, row 
svy: tab Condition IraqSyriaForce if elite == 0 & correct == 1, row 
svy: tab Condition OilForce if elite == 0 & correct == 1, row 
svy: tab Condition HumanForce if elite == 0 & correct == 1, row 
svy: mean AllScenarios if elite == 0 & correct == 1, over(Condition)
 svy: regress AllScenarios Condition if elite == 0 & correct == 1

save "MultilateralismExperiment.dta", replace

* Within-Condition Weights

/* Clean Public Dataset Including Within-Condition Weights */
use "UTEX0032_OUTPUT_New_S12.dta" 
save "UTEX0032_OUTPUT_withinconditionweights.dta", replace

gen Condition = .
replace Condition = 0 if condition == 1
replace Condition = 1 if condition == 2
label variable Condition "Experimental Condition"
label values Condition condition

gen KoreaForce = Q4_1
recode KoreaForce (2=0)
label values KoreaForce batteryfavoroppose
label variable KoreaForce "If North Korea Invaded South Korea"

gen GenocideForce = Q4_2
recode GenocideForce (2=0) 
label values GenocideForce batteryfavoroppose
label variable GenocideForce "To Stop a Government From Committing Genocide"

gen IsraelForce = Q4_3
recode IsraelForce (2=0) 
label values IsraelForce batteryfavoroppose
label variable IsraelForce "If Israel Were Attacked"

gen IranForce = Q4_4
recode IranForce (2=0) 
label values IranForce batteryfavoroppose
label variable IranForce "To Stop Iran from Obtaining Nuclear Weapons"

gen IraqSyriaForce = Q4_5
recode IraqSyriaForce (2=0)
label values IraqSyriaForce batteryfavoroppose
label variable IraqSyriaForce "To Fight Violent Islamic Extremist Groups in Iraq and Syria"

gen OilForce = Q4_6
recode OilForce (2=0)
label values OilForce batteryfavoroppose
label variable OilForce "To Ensure the Oil Supply"

gen HumanForce = Q4_7
recode HumanForce (2=0) 
label values HumanForce batteryfavorforce
label variable HumanForce "To Deal with Humanitarian Crises"

gen AllScenarios = (KoreaForce + GenocideForce + IsraelForce + IranForce + IraqSyriaForce + OilForce + HumanForce)/7
label variable AllScenarios "All Scenarios (Average)"

gen correct = 0
replace correct = 1 if Condition == 0 & Q4_COMMON == 4
replace correct = 1 if Condition == 1 & Q4_COMMON == 3

save "UTEX0032_OUTPUT_withinconditionweights.dta", replace

/* Appendix Table B5 Columns (5) and (6) */
svyset [pweight = weight]
svy: tab Condition KoreaForce if correct == 1, row
svy: tab Condition GenocideForce if correct == 1, row 
svy: tab Condition IsraelForce if correct == 1, row 
svy: tab Condition IranForce if correct == 1, row 
svy: tab Condition IraqSyriaForce if correct == 1, row 
svy: tab Condition OilForce if correct == 1, row 
svy: tab Condition HumanForce if correct == 1, row 
svy: mean AllScenarios if correct == 1, over(Condition)
 svy: regress AllScenarios Condition if correct == 1

*** Table B6. Differential Effect of UNSC Authorization on Elite and Public Support for the Use of Force
use "MultilateralismExperiment.dta"

* Column (1)
logit KoreaForce C.Condition##C.elite if correct == 1
logit GenocideForce C.Condition##C.elite if correct == 1
logit IsraelForce C.Condition##C.elite if correct == 1
logit IranForce C.Condition##C.elite if correct == 1
logit IraqSyriaForce C.Condition##C.elite if correct == 1
logit OilForce C.Condition##C.elite if correct == 1
logit HumanForce C.Condition##C.elite if correct == 1    
reg AllScenarios C.Condition##C.elite if correct == 1  

* Column (2): Adding Policy Attitude Control variables
logit KoreaForce C.Condition##C.elite activepart strengthenunvery superiormilapproachvery  if correct == 1
logit GenocideForce C.Condition##C.elite activepart strengthenunvery superiormilapproachvery  if correct == 1
logit IsraelForce C.Condition##C.elite activepart strengthenunvery superiormilapproachvery  if correct == 1
logit IranForce C.Condition##C.elite activepart strengthenunvery superiormilapproachvery  if correct == 1
logit IraqSyriaForce C.Condition##C.elite activepart strengthenunvery superiormilapproachvery if correct == 1
logit OilForce C.Condition##C.elite activepart strengthenunvery superiormilapproachvery if  correct == 1
logit HumanForce C.Condition##C.elite activepart strengthenunvery superiormilapproachvery  if  correct == 1    
reg AllScenarios C.Condition##C.elite activepart strengthenunvery superiormilapproachvery  if  correct == 1  

* Column (3): Adding Partisanship
logit KoreaForce C.Condition##C.elite activepart strengthenunvery superiormilapproachvery democrat if correct == 1
logit GenocideForce C.Condition##C.elite activepart strengthenunvery superiormilapproachvery democrat if correct == 1
logit IsraelForce C.Condition##C.elite activepart strengthenunvery superiormilapproachvery democrat if correct == 1
logit IranForce C.Condition##C.elite activepart strengthenunvery superiormilapproachvery democrat if correct == 1
logit IraqSyriaForce C.Condition##C.elite activepart strengthenunvery superiormilapproachvery democrat if correct == 1
logit OilForce C.Condition##C.elite activepart strengthenunvery superiormilapproachvery democrat if  correct == 1
logit HumanForce C.Condition##C.elite activepart strengthenunvery superiormilapproachvery democrat if  correct == 1    
reg AllScenarios C.Condition##C.elite activepart strengthenunvery superiormilapproachvery democrat if  correct == 1  

*** Table B7. Effect of UNSC Authorization on Support for the Use of Force: Including Manipulation Check Failures

* Elites
tab KoreaForce Condition if elite == 1, chi2 col
tab GenocideForce Condition if elite == 1, chi2 col
tab IsraelForce Condition if elite == 1, chi2 col
tab IranForce  Condition if elite == 1, chi2 col
tab IraqSyriaForce Condition if elite == 1, chi2 col
tab OilForce Condition if elite == 1, chi2 col
tab HumanForce Condition if elite == 1 , chi2 col
ttest AllScenarios if elite == 1, by(Condition)

* Public
tab KoreaForce Condition if elite == 0, chi2 col
tab GenocideForce Condition if elite == 0, chi2 col
tab IsraelForce Condition if elite == 0, chi2 col
tab IranForce  Condition if elite == 0, chi2 col
tab IraqSyriaForce Condition if elite == 0, chi2 col
tab OilForce Condition if elite == 0, chi2 col
tab HumanForce Condition if elite == 0, chi2 col
ttest AllScenarios if elite == 0, by(Condition)

* Executive Branch Experience
tab KoreaForce Condition if Exec == 1, chi2 col
tab GenocideForce Condition if Exec == 1, chi2 col
tab IsraelForce Condition if Exec == 1, chi2 col
tab IranForce  Condition if Exec == 1, chi2 col
tab IraqSyriaForce Condition if Exec == 1, chi2 col
tab OilForce Condition if Exec == 1, chi2 col
tab HumanForce Condition if Exec == 1, chi2 col
ttest AllScenarios if Exec == 1, by(Condition)

*** Table B8. Descriptive Statistics for the U.S. Public (Pre- and Post-Presidential Election)

* CCGA Public Survey Figures From Smeltz et al. 2016. 

* YouGov Public Survey (May-June 2017)
svyset [pweight = weight]
svy: mean activepart
svy: mean strengthenunvery
svy: mean superiormilapproachvery

log close 








