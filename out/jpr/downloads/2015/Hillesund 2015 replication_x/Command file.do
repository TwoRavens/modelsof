
*----------------------------------------------------------------------------
*
* Article:		A Dangerous Discrepancy: Testing the microdynamics of 
*				horizontal inequality on Palestinian support for 
*				armed resistance
*
* Author: 		Solveig Hillesund
*
* Program:		Stata 13
* Datasets:		"Original data" & "Full imputed dataset"
*
*----------------------------------------------------------------------------


*----------------------------------------------------------------------------
* Do-file contents
*----------------------------------------------------------------------------

* 0 Defining directory and log
* 1 List of most important variables
* 2 Individual level variables (Original dataset)
* 		2.1 Dependent variable
*		2.2 Civil and political rights status (H3)
*		2.3 Opportunity: Self-evaluated wealth
*		2.4 Relative deprivation: Interaction income/education
*		2.5 Gender
*		2.6 Political affiliation
*		2.7 Confidence in Fatah government (Fayyad)
*		2.8 Employment status
*		2.9 Perceived security
*		2.10 Binominal dependent variable: Support for violence
* 3 Governorate level variables (Original dataset)
*		3.1 Palestinian governorate population (2007 census)
*		3.2 Number of households per governorate (2007 census)
*		3.3 Horizontal inequality: Durables index (H1)
* 		3.4 Horizontal inequality: Expenditures (H1)
* 		3.5 Horizontal inequality: Educational attainment (H2)
* 		3.6 Absolute level of regional wealth
* 		3.7 Conflict intensity
* 		3.8 Proportion of young men (age 15-29)
* 4 Standardizing relevant variables (Original dataset)
* 5 Multiple imputation
* 6 Descriptive statistics (Full dataset)
*	 	6.1 Dependent variable distribution (Table A-I)
* 		6.2 Summary statistics (Table A-II)
* 7 Main model (Full dataset)
* 		7.1 Installing the gllamm program
* 		7.2 Defining program for combining results across imputations
* 		7.3 Main model (Table I)
* 		7.4 Random intercept model (Table A-V)
* 		7.5 Baseline model for models run in third imputed dataset only
* 8 Predicted probabilities (Third imputed dataset)
* 		8.1 Defining program for considence intervals around predicted probabilities
*		8.2 Durables index (Figure 1)
*		8.3 HI expenditures (Figure 2)
*		8.4 Civil and political rights status (Figure 3)
*		8.5 HI variables combined (Figure 4)
* 9 Predictive power (Third imputed dataset)
*		9.1 Outcome dummies
*		9.2 In-sample predictive power (Table II)
*		9.3 Out-of-sample predictive power (Table II)
* 10 Alternative model specifications (Full dataset)
* 		10.1 With Gaza dummy (Table III, Model R2)
* 		10.2 Binominal model (Table III, Model R1)
* 		10.3 Conflict intensity: Self-reported exposure (Table III, Model R3)
* 		10.4 Conflict intensity: 12 month casualty (Table A-VI, Model R4)
* 		10.5 Conflict intensity: Martyrs of the intifada (Table A-VI, Model R5)
* 		10.6 Excluding HI durables (Table A-VI, Model R6)
* 		10.7 Excluding HI expenditures (Table A-VI, Model R7)
* 		10.8 Daily wage replacing expenditures level (Table A-VI, Model R8)
* 11 Outliers and influential data points (Third imputed dataset)
* 		11.1 Individual level (Table A-VI, Model R9)
*		11.2 Governorate level (Table A-VI, Model R10)
*		10.3 Unimputed (Table A-VI, Model R11)
* 12 List of main results stored as matrixes and estimates 


*----------------------------------------------------------------------------
* 0 Defining directory and log
*----------------------------------------------------------------------------

* Defining directory/folder 
cd "C:\Users\Eier\Documents\Replication_Hillesund"
	* Make sure replication datasets are saved in the specified folder, 
	* as "Original data" and "Full imputed dataset"
  
* Defining log 
set logtype smcl
log using "Replication log, Hillesund"


*----------------------------------------------------------------------------
* 1 List of most important variables
*----------------------------------------------------------------------------

* p0607d 			- Support for resistance (dependent variable) */
* z_HI_ostby 		- HI durables index, standardized */
* z_HI_exp_ostby	- HI expenditure, standardized */
* z_HI_edu_h  		- HI education, standardized */
* z_p42s 			- Civil and political rigths status, standardized */
* z_inc_edu			- Wealth*education, standardized */ 
* z_b29s 			- Self-evaluated wealth, standardized */
* z_R_exp_pc		- Regional expenditure level, standardized */

* p22_2				- Political affiliation: Hamas */
* conf_fayyad		- High level of confidence in Fatah government (Fayyad)*/
* y05				- Personal security: Feel safe */ 
* b03				- Gender: Woman */
* z_b10    			- Education completed, standardized */
* b13m_4 			- Employment status: Unemployed */
* aretype_2 		- Living area: Rural */
* aretype_3 		- Living area: Refugee camp*/
* z_R_trend_casualty - Casualty trend, standardized */
* z_R_youngmen		- Proportion of young men, standardized */


* region			- Gaza-dummy */ 
* resistance_d 		- Binominal dependent variable: Support for violence */
* z_R_violence 		- Exposure to Israeli violence, share of governorate population */
* z_R_martyrs 		- Number of martyrs per governorate 2000-2009 */
* z_R_casualties 	- Number of casualties per governorate, previous 12 months*/
* z_R_wage			- Regional daily wage level*/



*----------------------------------------------------------------------------
* 2 Individual level variables (Original dataset)
*----------------------------------------------------------------------------

use "Original dataset", clear

*** 2.1 Dependent variable
generate p06m = P06
mvdecode p06m, mv(8=.b)
label variable p06m "Rocket attacks must stop"
label values p06m p06m
label define p06m 1 "Strongly agree" 2 "Agree" 3 "Disagree" 4 "Strongly disagree" .a "No answer" .b "DK"

generate p07m = P07
mvdecode p07m, mv(8=.b)
label variable p07m "More emphasis on non-violent resistance"
label values p07m p07m
label define p07m 1 "Strongly agree" 2 "Agree" 3 "Disagree" 4 "Strongly disagree" .a "NA" .b "DK"

recode p06m (1/2 = 0) (3/4 = 1), gen(p06d)
label variable p06d "Support for rocket attacks, dichotomy"
recode p07m (1/2 = 1) (3/4 = 0), gen(p07d)
label variable p07d "Support for non-violent means, dichotomy"

gen p0607d = 0
replace p0607d = 1 if p07d==1 & p06d==0
replace p0607d = 2 if p07d==0 & p06d==1
replace p0607d = 3 if p07d==1 & p06d==1
replace p0607d = . if missing(p06d)
replace p0607d = . if missing(p07d)
label variable p0607d "Support for violent vs non-violent resistance"
label values p0607d p0607d
label define p0607d 0 "Neither" 1 "Non-violence only" 2 "Rocket attacks only" 3 "Both" 

*** 2.2 Civil and political rights status (H3)
generate p42m = P42
mvdecode p42m, mv(8=.b)
generate p42s = 5 - p42m
label variable p42s "Civil and political rights status"
label values p42s p42s
label define p42s 1 "Very poor" 2 "Poor" 3 "Satisfactory" 4 "Very satisfactory" .b "DK"

*** 2.3 Opportunity: Self-evaluated wealth
generate b29m = b29
mvdecode b29m, mv(5=.a)
label variable b29m "Self-evaluated economic status of household"
label values b29m b29m
label define b29m 1 "Among the well-offs" 2 "Not rich, but live well" 3 "Neither rich nor poor" 4 "Among the poor"
		
generate b29s = 5 - b29m
label variable b29s "Self-evaluated wealth"
label values b29s b29s 
label define b29s 4 "Among the well-offs" 3 "Not rich, but live well" 2 "Neither rich nor poor" 1 "Among the poor"
		
*** 2.4 Relative deprivation: Interaction income/education
recode B10 (5/6 = 5) (7/8 = 6), generate(b10)
mvdecode b10, mv(99=.a)
label variable b10 "Education completed"
label values b10 b10
label define b10 1 "Never attended school" 2 "Never finished elementary" 3 "Elementary (1-6)" 4 "Intermediate (7-9)" 5 "Secondary/Vocational training (10-12)" 6 "Diploma/University studies (>12)" .a "NA"

generate inc_edu = b29s * b10 
label variable inc_edu "Self-evaluated wealth*Education" 

*** 2.5 Gender
recode B03 (1=0)(2=1), generate(b03) 
label variable b03 "Woman"
label values b03 b03
label define b03 0 "Male" 1 "Female"

*** 2.6 Political affiliation
generate p22 = P22
recode p22(3/10 = 3) (11=4)(98=5)
label variable p22 "Would vote for"
label value p22 p22
label define p22 1 "Fatah" 2 "Hamas" 3 "Other" 4 "Will not participate" 5 "DK"

*** 2.7 Confidence in Fatah government (Fayyad)
generate conf_fayyad = 0
replace conf_fayyad = 1 if T02_02==1 | T02_02==2
label variable conf_fayyad "Confidence in Fatah government (Fayyad)"
tab T02_02 conf_fayyad, miss

*** 2.8 Employment status
recode B13 (5=4)(6/9=5), generate(b13m)
label variable b13m "Employment status last month"
label value b13m b13m 
label define b13m 1 "Working" 2 "Attending school" 3 "Housewife" 4 "Unemployed" 5 "Other" 

*** 2.9 Perceived security
recode Y05 (2=0), generate(y05)
label variable y05 "Feeling generally safe"
label value y05 y05
label define y05 0 "No" 1 "Yes" .a ".a" .b ".b"

*** 2.10 Binominal dependent variable: Support for violence
generate resistance_d=0
replace resistance_d=1 if p0607d==2 | p0607d==3
label variable resistance_d "Support for violent resistance, dummy"
tab resistance_d p0607d, miss



*----------------------------------------------------------------------------
* 3 Governorate level variables (Original dataset)
*----------------------------------------------------------------------------

*** 3.1 Palestinian governorate population (2007 census)
generate R_pop = 0
label variable R_pop "Governorate population (2007 census)"
replace R_pop = 256619 if governorate==1
replace R_pop = 50261 if governorate==5
replace R_pop = 157988 if governorate==10
replace R_pop = 320830 if governorate==15
replace R_pop = 91217 if governorate==20
replace R_pop = 59570 if governorate==25
replace R_pop = 279730 if governorate==30
replace R_pop = 42320 if governorate==35
replace R_pop = 363649 if governorate==40
replace R_pop = 176235 if governorate==45
replace R_pop = 552164 if governorate==50
replace R_pop = 270494 if governorate==55
replace R_pop = 496692 if governorate==60
replace R_pop = 205414 if governorate==65
replace R_pop = 270828 if governorate==70
replace R_pop = 173539 if governorate==75

*** 3.2 Number of households per governorate (2007 census)
generate R_HH = 0
label variable R_HH "Households per governorate"
replace R_HH = 46541 if governorate==1
replace R_HH = 8628 if governorate==5
replace R_HH = 29708 if governorate==10
replace R_HH = 58750 if governorate==15
replace R_HH = 16000 if governorate==20
replace R_HH = 10958 if governorate==25
replace R_HH = 49637 if governorate==30
replace R_HH = 7262 if governorate==35
replace R_HH = 23190 if governorate==40
replace R_HH = 31471 if governorate==45
replace R_HH = 87645 if governorate==50
replace R_HH = 39604 if governorate==55
replace R_HH = 75023 if governorate==60
replace R_HH = 31340 if governorate==65
replace R_HH = 42402 if governorate==70
replace R_HH = 26391 if governorate==75


*** 3.3 Horizontal inequality: Durables index (H1)
	
  * Refrigerator, percentage of HH
	* Palestine 2007
generate R_refrigerator = 0
label variable R_refrigerator "Refrigerator, percent of HH"
replace R_refrigerator = (42795 / 46541)*100 if governorate==1
replace R_refrigerator = (7626 / 8628)*100 if governorate==5
replace R_refrigerator = (28368 / 29708)*100 if governorate==10
replace R_refrigerator = (56214 / 58750)*100 if governorate==15
replace R_refrigerator = (15287 / 16000)*100 if governorate==20
replace R_refrigerator = (10405 / 10958)*100 if governorate==25
replace R_refrigerator = (46677 / 49637)*100 if governorate==30
replace R_refrigerator = (6441 / 7262)*100 if governorate==35
replace R_refrigerator = (18596 / 23190)*100 if governorate==40
replace R_refrigerator = (28897 / 31471)*100 if governorate==45
replace R_refrigerator = (78535 / 87645)*100 if governorate==50
replace R_refrigerator = (36477 / 39604)*100 if governorate==55
replace R_refrigerator = (70070 / 75023)*100 if governorate==60
replace R_refrigerator = (27884 / 31340)*100 if governorate==65
replace R_refrigerator = (37618 / 42402)*100 if governorate==70
replace R_refrigerator = (23182 / 26391)*100 if governorate==75	
	* Israel 2008
generate I_refrigerator = 0
label variable I_refrigerator "Refrigerator, Israel"
replace I_refrigerator = 100.0 if governorate==1
replace I_refrigerator = 100.0 if governorate==5
replace I_refrigerator = 100.0 if governorate==10
replace I_refrigerator = 100.0 if governorate==15
replace I_refrigerator = 100.0 if governorate==20
replace I_refrigerator = 100.0 if governorate==25
replace I_refrigerator = 98.6 if governorate==30
replace I_refrigerator = 99.4 if governorate==35
replace I_refrigerator = 99.4 if governorate==40
replace I_refrigerator = 99.4 if governorate==45
replace I_refrigerator = 99.9 if governorate==50
replace I_refrigerator = 99.5 if governorate==55
replace I_refrigerator = 99.9 if governorate==60
replace I_refrigerator = 99.9 if governorate==65
replace I_refrigerator = 99.9 if governorate==70
replace I_refrigerator = 99.9 if governorate==75

  * Microwave, percentage of HH
	* Palestine 2007
generate R_microwave = 0
label variable R_microwave "Microwave, percentage"
replace R_microwave = (7487 / 46541)*100 if governorate==1
replace R_microwave = (1537 / 8628)*100 if governorate==5
replace R_microwave = (6601 / 29708)*100 if governorate==10
replace R_microwave = (14912 / 58750)*100 if governorate==15
replace R_microwave = (4147 / 16000)*100 if governorate==20
replace R_microwave = (3645 / 10958)*100 if governorate==25
replace R_microwave = (19775 / 49637)*100 if governorate==30
replace R_microwave = (1885 / 7262)*100 if governorate==35
replace R_microwave = (7675 / 23190)*100 if governorate==40
replace R_microwave = (8145 / 31471)*100 if governorate==45
replace R_microwave = (17796 / 87645)*100 if governorate==50
replace R_microwave = (5445 / 39604)*100 if governorate==55
replace R_microwave = (15158 / 75023)*100 if governorate==60
replace R_microwave = (4005 / 31340)*100 if governorate==65
replace R_microwave = (3648 / 42402)*100 if governorate==70
replace R_microwave = (3110 / 26391)*100 if governorate==75		
	* Israel 2008
generate I_microwave = 0
label variable I_microwave "Microwave, Israel"
replace I_microwave = 81.4 if governorate==1
replace I_microwave = 81.4 if governorate==5
replace I_microwave = 83.6 if governorate==10
replace I_microwave = 83.6 if governorate==15
replace I_microwave = 88.5 if governorate==20
replace I_microwave = 88.5 if governorate==25
replace I_microwave = 87.2 if governorate==30
replace I_microwave = 74.3 if governorate==35
replace I_microwave = 74.3 if governorate==40
replace I_microwave = 74.3 if governorate==45
replace I_microwave = 85.9 if governorate==50
replace I_microwave = 84.3 if governorate==55
replace I_microwave = 85.9 if governorate==60
replace I_microwave = 85.9 if governorate==65
replace I_microwave = 85.9 if governorate==70
replace I_microwave = 85.9 if governorate==75

 * Washing machine, percentage of HH
	* Palestine 2007
generate R_wash = 0
label variable R_wash "Washing machine, percentage"
replace R_wash = (42067 / 46541)*100 if governorate==1
replace R_wash = (7377 / 8628)*100 if governorate==5
replace R_wash = (27155 / 29708)*100 if governorate==10
replace R_wash = (55187 / 58750)*100 if governorate==15
replace R_wash = (14733 / 16000)*100 if governorate==20
replace R_wash = (10101 / 10958)*100 if governorate==25
replace R_wash = (44996 / 49637)*100 if governorate==30
replace R_wash = (6153 / 7262)*100 if governorate==35
replace R_wash = (17964 / 23190)*100 if governorate==40
replace R_wash = (27846 / 31471)*100 if governorate==45
replace R_wash = (78143 / 87645)*100 if governorate==50
replace R_wash = (36578 / 39604)*100 if governorate==55
replace R_wash = (70760 / 75023)*100 if governorate==60
replace R_wash = (28252 / 31340)*100 if governorate==65
replace R_wash = (37598 / 42402)*100 if governorate==70
replace R_wash = (23381 / 26391)*100 if governorate==75
	* Israel 2008
generate I_wash = 0
label variable I_wash "Washing machine, Israel"
replace I_wash = 97.1 if governorate==1
replace I_wash = 97.1 if governorate==5
replace I_wash = 99.2 if governorate==10
replace I_wash = 99.2 if governorate==15
replace I_wash = 96.0 if governorate==20
replace I_wash = 96.0 if governorate==25
replace I_wash = 96.0 if governorate==30
replace I_wash = 93.3 if governorate==35
replace I_wash = 93.3 if governorate==40
replace I_wash = 93.3 if governorate==45
replace I_wash = 91.8 if governorate==50
replace I_wash = 95.4 if governorate==55
replace I_wash = 91.8 if governorate==60
replace I_wash = 91.8 if governorate==65
replace I_wash = 91.8 if governorate==70
replace I_wash = 91.8 if governorate==75

  * Vacuum cleaner, percentage of HH
	* Palestine 2007
generate R_vacuum = 0
label variable R_vacuum "Vacuum cleaner, percentage"
replace R_vacuum = (13262 / 46541)*100 if governorate==1
replace R_vacuum = (1636 / 8628)*100 if governorate==5
replace R_vacuum = (9626 / 29708)*100 if governorate==10
replace R_vacuum = (25219 / 58750)*100 if governorate==15
replace R_vacuum = (3929 / 16000)*100 if governorate==20
replace R_vacuum = (2574 / 10958)*100 if governorate==25
replace R_vacuum = (18610 / 49637)*100 if governorate==30
replace R_vacuum = (1375 / 7262)*100 if governorate==35
replace R_vacuum = (7030 / 23190)*100 if governorate==40
replace R_vacuum = (10683 / 31471)*100 if governorate==45
replace R_vacuum = (34458 / 87645)*100 if governorate==50
replace R_vacuum = (4642 / 39604)*100 if governorate==55
replace R_vacuum = (18721 / 75023)*100 if governorate==60
replace R_vacuum = (3692 / 31340)*100 if governorate==65
replace R_vacuum = (5589 / 42402)*100 if governorate==70
replace R_vacuum = (2766 / 26391)*100 if governorate==75
	* Israel 2008
generate I_vacuum = 0
label variable I_vacuum "Vacuum cleaner, Israel"
replace I_vacuum = 63.4 if governorate==1
replace I_vacuum = 63.4 if governorate==5
replace I_vacuum = 77.3 if governorate==10
replace I_vacuum = 77.3 if governorate==15
replace I_vacuum = 75.5 if governorate==20
replace I_vacuum = 75.5 if governorate==25
replace I_vacuum = 65.6 if governorate==30
replace I_vacuum = 63.6 if governorate==35
replace I_vacuum = 63.6 if governorate==40
replace I_vacuum = 63.6 if governorate==45
replace I_vacuum = 53.1 if governorate==50
replace I_vacuum = 61.4 if governorate==55
replace I_vacuum = 53.1 if governorate==60
replace I_vacuum = 53.1 if governorate==65
replace I_vacuum = 53.1 if governorate==70
replace I_vacuum = 53.1 if governorate==75

  * Tv, percentage of HH
	* Palestine 2007
generate R_tv = 0
label variable R_tv "Tv, percentage"
replace R_tv = (43754 / 46541)*100 if governorate==1
replace R_tv = (7904 / 8628)*100 if governorate==5
replace R_tv = (28200 / 29708)*100 if governorate==10
replace R_tv = (56577 / 58750)*100 if governorate==15
replace R_tv = (15151 / 16000)*100 if governorate==20
replace R_tv = (10399 / 10958)*100 if governorate==25
replace R_tv = (46496 / 49637)*100 if governorate==30
replace R_tv = (6511 / 7262)*100 if governorate==35
replace R_tv = (18683 / 23190)*100 if governorate==40
replace R_tv = (29384 / 31471)*100 if governorate==45
replace R_tv = (81289 / 87645)*100 if governorate==50
replace R_tv = (36889 / 39604)*100 if governorate==55
replace R_tv = (70874 / 75023)*100 if governorate==60
replace R_tv = (29035 / 31340)*100 if governorate==65
replace R_tv = (37564 / 42402)*100 if governorate==70
replace R_tv = (23965 / 26391)*100 if governorate==75
	* Israel 2008
generate I_tv = 0
label variable I_tv "Tv, Israel"
replace I_tv = 99.1 if governorate==1
replace I_tv = 99.1 if governorate==5
replace I_tv = 95.7 if governorate==10
replace I_tv = 95.7 if governorate==15
replace I_tv = 93.4 if governorate==20
replace I_tv = 93.4 if governorate==25
replace I_tv = 92.1 if governorate==30
replace I_tv = 73.3 if governorate==35
replace I_tv = 73.3 if governorate==40
replace I_tv = 73.3 if governorate==45
replace I_tv = 90.8 if governorate==50
replace I_tv = 88.0 if governorate==55
replace I_tv = 90.8 if governorate==60
replace I_tv = 90.8 if governorate==65
replace I_tv = 90.8 if governorate==70
replace I_tv = 90.8 if governorate==75

  * Phone line, percentage of HH
	* Palestine 2007
generate R_phone = 0
label variable R_phone "Phone line, percentage"
replace R_phone = (19512 / 46541)*100 if governorate==1
replace R_phone = (2859 / 8628)*100 if governorate==5
replace R_phone = (15788 / 29708)*100 if governorate==10
replace R_phone = (30927 / 58750)*100 if governorate==15
replace R_phone = (6634 / 16000)*100 if governorate==20
replace R_phone = (4806 / 10958)*100 if governorate==25
replace R_phone = (28935 / 49637)*100 if governorate==30
replace R_phone = (2913 / 7262)*100 if governorate==35
replace R_phone = (8689 / 23190)*100 if governorate==40
replace R_phone = (14987 / 31471)*100 if governorate==45
replace R_phone = (30925 / 87645)*100 if governorate==50
replace R_phone = (13822 / 39604)*100 if governorate==55
replace R_phone = (34569 / 75023)*100 if governorate==60
replace R_phone = (11252 / 31340)*100 if governorate==65
replace R_phone = (12985 / 42402)*100 if governorate==70
replace R_phone = (8228 / 26391)*100 if governorate==75
	* Israel 2008
generate I_phone = 0
label variable I_phone "Phone, Israel"
replace I_phone = 80.3 if governorate==1
replace I_phone = 80.3 if governorate==5
replace I_phone = 91.8 if governorate==10
replace I_phone = 91.8 if governorate==15
replace I_phone = 88.4 if governorate==20
replace I_phone = 88.4 if governorate==25
replace I_phone = 83.1 if governorate==30
replace I_phone = 80.1 if governorate==35
replace I_phone = 80.1 if governorate==40
replace I_phone = 80.1 if governorate==45
replace I_phone = 78.3 if governorate==50
replace I_phone = 83.9 if governorate==55
replace I_phone = 78.3 if governorate==60
replace I_phone = 78.3 if governorate==65
replace I_phone = 78.3 if governorate==70
replace I_phone = 78.3 if governorate==75

  * Car, percentage of HH
	* Palestine 2007
generate R_car2 = 0
label variable R_car2 "Car, percentage"
replace R_car2 = (7887 / 46541)*100 if governorate==1
replace R_car2 = (1557 / 8628)*100 if governorate==5
replace R_car2 = (6115 / 29708)*100 if governorate==10
replace R_car2 = (13245 / 58750)*100 if governorate==15
replace R_car2 = (2623 / 16000)*100 if governorate==20
replace R_car2 = (2645 / 10958)*100 if governorate==25
replace R_car2 = (17236 / 49637)*100 if governorate==30
replace R_car2 = (1721 / 7262)*100 if governorate==35
replace R_car2 = (5880 / 23190)*100 if governorate==40
replace R_car2 = (8907 / 31471)*100 if governorate==45
replace R_car2 = (15184 / 87645)*100 if governorate==50
replace R_car2 = (4710 / 39604)*100 if governorate==55
replace R_car2 = (12481 / 75023)*100 if governorate==60
replace R_car2 = (3089 / 31340)*100 if governorate==65
replace R_car2 = (3434 / 42402)*100 if governorate==70
replace R_car2 = (2238 / 26391)*100 if governorate==75	
	* Israel 2008
generate I_car2 = 0
label variable I_car2 "Car, Israel (sub-district)"
replace I_car2 = 56.9 if governorate==1
replace I_car2 = 56.9 if governorate==5
replace I_car2 = 69.0 if governorate==10
replace I_car2 = 69.0 if governorate==15
replace I_car2 = 74.1 if governorate==20
replace I_car2 = 74.1 if governorate==25
replace I_car2 = 74.5 if governorate==30
replace I_car2 = 49.5 if governorate==35
replace I_car2 = 49.5 if governorate==40
replace I_car2 = 49.5 if governorate==45
replace I_car2 = 51.9 if governorate==50
replace I_car2 = 49.9 if governorate==55
replace I_car2 = 51.9 if governorate==60
replace I_car2 = 51.9 if governorate==65
replace I_car2 = 51.9 if governorate==70
replace I_car2 = 51.9 if governorate==75

  * Østby index
generate HI_ostby = 1 - (((R_refrigerator / I_refrigerator) + (R_microwave / I_microwave) + (R_wash / I_wash) + (R_vacuum / I_vacuum) + (R_phone / I_phone) + (R_car2 / I_car2) ) / 6 )
label variable HI_ostby "Østby index, simple"


*** 3.4 Horizontal inequality: Expenditures (H1)
		
  * Total cash(money) expenditure per month
	* Palestine 2009 - currency JD
generate R_expenditure = 0
label variable R_expenditure "Total cash expenditure (2009)"
replace R_expenditure = 746.7 if governorate==1
replace R_expenditure = 746.7 if governorate==5
replace R_expenditure = 698.2 if governorate==10
replace R_expenditure = 732.7 if governorate==15
replace R_expenditure = 809.0 if governorate==20
replace R_expenditure = 732.7 if governorate==25
replace R_expenditure = 992.1 if governorate==30
replace R_expenditure = 992.1 if governorate==35
replace R_expenditure = 1186.2 if governorate==40
replace R_expenditure = 825.6 if governorate==45
replace R_expenditure = 737.3 if governorate==50
replace R_expenditure = 664.3 if governorate==55
replace R_expenditure = 627.3 if governorate==60
replace R_expenditure = 621.8 if governorate==65
replace R_expenditure = 586.7 if governorate==70
replace R_expenditure = 743.0 if governorate==75	
	* Israel 2008 - currency NIS
generate I_expenditure = 0
label variable I_expenditure "Total money expenditure, Israel (2008)"
replace I_expenditure = 7658 if governorate==1
replace I_expenditure = 7658 if governorate==5
replace I_expenditure = 9669 if governorate==10
replace I_expenditure = 9669 if governorate==15
replace I_expenditure = 11040 if governorate==20
replace I_expenditure = 11040 if governorate==25
replace I_expenditure = 10617 if governorate==30
replace I_expenditure = 9214 if governorate==35
replace I_expenditure = 9214 if governorate==40
replace I_expenditure = 9214 if governorate==45
replace I_expenditure = 9772 if governorate==50
replace I_expenditure = 7642 if governorate==55
replace I_expenditure = 9772 if governorate==60
replace I_expenditure = 9772 if governorate==65
replace I_expenditure = 9772 if governorate==70
replace I_expenditure = 9772 if governorate==75	
	
  * Converting into same currency: 2008 US$
generate R_exp_usd = R_expenditure/0.709
label variable R_exp_usd "Expenditure USD"
generate I_exp_usd = I_expenditure/3.56
label variable I_exp_usd "Expenditure USD, Israel"
	
  * Østby index
generate HI_exp_ostby = 1 - (R_exp_usd / I_exp_usd)
label variable HI_exp_ostby "HI expenditure, Østby"


*** 3.5 Horizontal inequality: Attainment of higher education (H2)

  * Education 13+ years
	* Palestine
generate R_edu_h = 0
label variable R_edu_h "High education, percent"
replace R_edu_h = ((213 + 735 + 179 + 10787 + 6423) / 180899 *100) if governorate==1
replace R_edu_h = ((28 + 146 + 26 + 2276 + 1268) / 34169 *100) if governorate==5
replace R_edu_h = ((142 + 649 + 120 + 8875 + 6034) / 115450 *100) if governorate==10
replace R_edu_h = ((458 + 1546 + 253 + 16619 + 11415) / 229771 *100) if governorate==15
replace R_edu_h = ((49 + 276 + 54 + 3980 + 2190) / 62857 *100) if governorate==20
replace R_edu_h = ((60 + 279 + 49 + 3391 + 1569) / 42172 *100) if governorate==25
replace R_edu_h = ((625 + 2465 + 321 + 15003 + 8796) / 188775 *100) if governorate==30
replace R_edu_h = ((20 + 103 + 26 + 1305 + 874) / 27646 *100) if governorate==35
replace R_edu_h = ((316 + 1230 + 335 + 14673 + 11282) / 233325 *100) if governorate==40
replace R_edu_h = ((273 + 862 + 291 + 8234 + 4561) / 120845 *100) if governorate==45
replace R_edu_h = ((471 + 1329 + 342 + 20571 + 12249) / 367514 *100) if governorate==50
replace R_edu_h = ((322 + 848 + 245 + 13729 + 4988) / 181820 *100) if governorate==55
replace R_edu_h = ((738 + 2075 + 589 + 27141 + 11330) / 333458 *100) if governorate==60
replace R_edu_h = ((192 + 623 + 340 + 13550 + 7510) / 141528 *100) if governorate==65
replace R_edu_h = ((264 + 758 + 359 + 15258 + 6361) / 185685 *100) if governorate==70
replace R_edu_h = ((133 + 413 + 182 + 9801 + 4551) / 116198 *100) if governorate==75
	* Israel 2008
generate I_edu2_h = 0
label variable I_edu2_h "High education, Israel, sub-district"
replace I_edu2_h = (17.3 + 14.2) if governorate==1
replace I_edu2_h = (17.3 + 14.2) if governorate==5
replace I_edu2_h = (20.7 + 20.2) if governorate==10
replace I_edu2_h = (20.7 + 20.2) if governorate==15
replace I_edu2_h = (23.1 + 26.7) if governorate==20
replace I_edu2_h = (23.1 + 26.7) if governorate==25
replace I_edu2_h = (20.6 + 21.6) if governorate==30
replace I_edu2_h = (20.9 + 21.6) if governorate==35
replace I_edu2_h = (20.9 + 21.6) if governorate==40
replace I_edu2_h = (20.9 + 21.6) if governorate==45
replace I_edu2_h = (21.0 + 15.5) if governorate==50
replace I_edu2_h = (24.5 + 14.8) if governorate==55
replace I_edu2_h = (21.0 + 15.5) if governorate==60
replace I_edu2_h = (21.0 + 15.5) if governorate==65
replace I_edu2_h = (21.0 + 15.5) if governorate==70
replace I_edu2_h = (21.0 + 15.5) if governorate==75
	
  * Østby index
generate HI_edu_h = 1 - (R_edu_h / I_edu2_h)
label variable HI_edu_h "HI higher education, Østby"


*** 3.6 Absolute level of regional wealth

  * Average monthly per capita expenditure 2010 (JD)
generate R_exp_pc = 0
label variable R_exp_pc "Expenditure per capita 2010"
replace R_exp_pc = 136.5 if governorate==1
replace R_exp_pc = 133.9 if governorate==5
replace R_exp_pc = 159.4 if governorate==10
replace R_exp_pc = 191.2 if governorate==15
replace R_exp_pc = 167.5 if governorate==20
replace R_exp_pc = 167.5 if governorate==25
replace R_exp_pc = 195.0 if governorate==30
replace R_exp_pc = 133.9 if governorate==35
replace R_exp_pc = 284.3 if governorate==40
replace R_exp_pc = 138.3 if governorate==45
replace R_exp_pc = 125.5 if governorate==50
replace R_exp_pc = 100.3 if governorate==55
replace R_exp_pc = 106.8 if governorate==60
replace R_exp_pc = 101.7 if governorate==65
replace R_exp_pc = 97.7 if governorate==70
replace R_exp_pc = 104.8 if governorate==75

  * Average daily wage in NIS for wage employees, 2010 
generate R_wage = 0
label variable R_wage "Average daily wage in NIS"
replace R_wage = 75.3 if governorate==1
replace R_wage = 79.6 if governorate==5
replace R_wage = 76.8 if governorate==10
replace R_wage = 74.9 if governorate==15
replace R_wage = 76.1 if governorate==20
replace R_wage = 82.2 if governorate==25
replace R_wage = 99.9 if governorate==30
replace R_wage = 75.7 if governorate==35
replace R_wage = 113.6 if governorate==40
replace R_wage = 91.9 if governorate==45
replace R_wage = 77.7 if governorate==50
replace R_wage = 58.0 if governorate==55
replace R_wage = 60.9 if governorate==60
replace R_wage = 59.2 if governorate==65
replace R_wage = 50.2 if governorate==70
replace R_wage = 60.7 if governorate==75


*** 3.7 Conflict intensity

 * Casuality trend - December 2010 to January 2011

	* Based on OCHA database reports of how many Palestinians were reported killed 
	* in each governorate, by the IDF, Israeli border police, police, 
	* private security forces, Israeli non-settlers or settlers, 
	* in incidents directly or indirectly related to the Palestinian-Israeli conflict

generate R_trend_casualty = 0
label variable R_trend_casualty "Casualty trend (jan2011-des2010)" 
replace R_trend_casualty = (1 - 0) if governorate==1
replace R_trend_casualty = (2 - 0) if governorate==5
replace R_trend_casualty = (0 - 0) if governorate==10
replace R_trend_casualty = (1 - 0) if governorate==15
replace R_trend_casualty = (0 - 0) if governorate==20
replace R_trend_casualty = (0 - 0) if governorate==25
replace R_trend_casualty = (1 - 0) if governorate==30
replace R_trend_casualty = (0 - 0) if governorate==35
replace R_trend_casualty = (0 - 0) if governorate==40
replace R_trend_casualty = (0 - 0) if governorate==45
replace R_trend_casualty = (2 - 0) if governorate==50
replace R_trend_casualty = (2 - 3) if governorate==55
replace R_trend_casualty = (0 - 0) if governorate==60
replace R_trend_casualty = (1 - 7) if governorate==65
replace R_trend_casualty = (0 - 3) if governorate==70
replace R_trend_casualty = (0 - 0) if governorate==75

  * Percentage of households exposed to Israeli violence prior to July 2010
generate R_violence = 0
label variable R_violence "Percentage of HH exposed to Israeli violence"
replace R_violence = 59.7 if governorate==1
replace R_violence = 50.3 if governorate==5
replace R_violence = 45.4 if governorate==10
replace R_violence = 52.6 if governorate==15
replace R_violence = 60.0 if governorate==20
replace R_violence = 47.4 if governorate==25
replace R_violence = 39.6 if governorate==30
replace R_violence = 23.3 if governorate==35
replace R_violence = 34.8 if governorate==40
replace R_violence = 42.3 if governorate==45
replace R_violence = 55.0 if governorate==50
replace R_violence = 57.6 if governorate==55
replace R_violence = 45.1 if governorate==60
replace R_violence = 57.2 if governorate==65
replace R_violence = 45.7 if governorate==70
replace R_violence = 45.5 if governorate==75

  * Casualties (OCHA) - February 2010 - January 2011
generate R_casualties = 0
label variable R_casualties "Casualties 2.2010-1.2011"
replace R_casualties = 1 if governorate==1
replace R_casualties = 2 if governorate==5
replace R_casualties = 1 if governorate==10
replace R_casualties = 5 if governorate==15
replace R_casualties = 0 if governorate==20
replace R_casualties = 1 if governorate==25
replace R_casualties = 2 if governorate==30
replace R_casualties = 0 if governorate==35
replace R_casualties = 5 if governorate==40
replace R_casualties = 0 if governorate==45
replace R_casualties = 8 if governorate==50
replace R_casualties = 18 if governorate==55
replace R_casualties = 10 if governorate==60
replace R_casualties = 21 if governorate==65
replace R_casualties = 12 if governorate==70
replace R_casualties = 6 if governorate==75

  * Martyrs 29/09/2000-31/12/2009 (PCBS 1661)
generate R_martyrs = 0
label variable  R_martyrs "Martyrs of the Intifada 2000-2009 (PCBS)"
replace R_martyrs = 438 if governorate==1
replace R_martyrs = 63 if governorate==5
replace R_martyrs = 251 if governorate==10
replace R_martyrs = 600 if governorate==15
replace R_martyrs = 87 if governorate==20
replace R_martyrs = 38 if governorate==25
replace R_martyrs = 182 if governorate==30
replace R_martyrs = 15 if governorate==35
replace R_martyrs = 86 if governorate==40
replace R_martyrs = 150 if governorate==45
replace R_martyrs = 273 if governorate==50
replace R_martyrs = 1446 if governorate==55
replace R_martyrs = 1820 if governorate==60
replace R_martyrs = 515 if governorate==65
replace R_martyrs = 631 if governorate==70
replace R_martyrs = 603 if governorate==75


*** 3.8 Proportion of young men (age 15-29)

  * Number of young men
generate R_no_youngm = 0
label variable R_no_youngm  "No. of young males"
replace R_no_youngm = (14845 + 11654 + 9614) if governorate==1
replace R_no_youngm = (2773 + 2133 + 1875) if governorate==5
replace R_no_youngm = (9590 + 6916 + 5823) if governorate==10
replace R_no_youngm = (18668 + 13886 + 11702) if governorate==15
replace R_no_youngm = (5458 + 4164 + 3447) if governorate==20
replace R_no_youngm = (3635 + 2694 + 2201) if governorate==25
replace R_no_youngm = (15516 + 12099 + 9820) if governorate==30
replace R_no_youngm = (2127 + 1664 + 1483) if governorate==35
replace R_no_youngm = (17631 + 14185 + 13209) if governorate==40
replace R_no_youngm = (9833 + 7716 + 6571) if governorate==45
replace R_no_youngm = (33425 + 25231 + 20340) if governorate==50
replace R_no_youngm = (17786 + 12649 + 9428) if governorate==55
replace R_no_youngm = (30962 + 22389 + 17582) if governorate==60
replace R_no_youngm = (12813 + 9606 + 7495) if governorate==65
replace R_no_youngm = (17174 + 12826 + 10146) if governorate==70
replace R_no_youngm = (10628 + 7768 + 6059) if governorate==75

  * Proportion of young men
generate R_youngmen = R_no_youngm / R_pop 
label variable R_youngmen "Proportion of young males"




*----------------------------------------------------------------------------
* 4 Standardizing relevant variables (Original dataset)
*----------------------------------------------------------------------------

egen z_b29s = std(b29s)
summarize b29s z_b29s
correlate b29s z_b29s

egen z_inc_edu = std(inc_edu)
summarize inc_edu z_inc_edu
correlate inc_edu z_inc_edu

egen z_p42s = std(p42s)
summarize p42s z_p42s
correlate p42s z_p42s

egen z_HI_ostby = std(HI_ostby)
summarize HI_ostby z_HI_ostby
correlate HI_ostby z_HI_ostby

egen z_HI_edu_h = std(HI_edu_h)
summarize HI_edu_h z_HI_edu_h
correlate HI_edu_h z_HI_edu_h

egen z_R_exp_pc = std(R_exp_pc)
summarize R_exp_pc z_R_exp_pc
correlate R_exp_pc z_R_exp_pc

egen z_b10 = std(b10)
summarize b10 z_b10
correlate b10 z_b10

egen z_R_trend_casualty = std(R_trend_casualty)
summarize R_trend_casualty z_R_trend_casualty
correlate R_trend_casualty z_R_trend_casualty

egen z_R_youngmen = std(R_youngmen)
summarize R_youngmen z_R_youngmen
correlate R_youngmen z_R_youngmen

egen z_R_wage = std(R_wage)
summarize R_wage z_R_wage 
correlate R_wage z_R_wage 

egen z_R_violence = std(R_violence)
summarize R_violence z_R_violence
correlate R_violence z_R_violence

egen z_R_martyrs = std(R_martyrs)
summarize R_martyrs z_R_martyrs
correlate R_martyrs z_R_martyrs

egen z_R_casualties = std(R_casualties)
summarize R_casualties z_R_casualties
correlate R_casualties z_R_casualties


  * Variable labels
label variable z_HI_ostby "Østby index [z]"
label variable z_HI_exp_ostby "HI expenditure, Østby [z]"
label variable z_HI_edu_h "HI higher education, Østby [z]"
label variable z_R_exp_pc "Per capita expenditure (2010) [z]"
label variable z_R_wage "Average daily wage (NIS) [z]"
label variable z_R_trend_casualty "Casualty trend (jan2011-des2010)[z]"
label variable z_R_youngmen "Share of young men [z]"
label variable z_inc_edu "Income-education interaction [z]"
label variable z_b10 "Education completed [z]"
label variable z_R_martyrs "Martyrs of the Intifada 200-2009 [z]"
label variable z_R_casualties "Casualties 2.2010-1.2011 [z]"
label variable z_p42s "Civil and political rights status [z]"
label variable z_b29s "Self-evaluated household wealth [z]"



  * Dummy variable sets 
tab p22, gen(p22_)
tab b13m, gen(b13m_)
tab areatype, gen(aretype_)
label variable p22_2 "Political affiliation: Hamas"
label variable b13m_4 "Employment status: Unemployed"
label variable aretype_1 "Location: Urban"
label variable aretype_2 "Location: Rural"
label variable aretype_3 "Location: Refugee camp"


save "Full unimputed dataset"




*----------------------------------------------------------------------------
* 5 Multiple imputation
*----------------------------------------------------------------------------

* Multiple imputation was executed in Amelia II,
* see description in online appendix

* In the resulting full imputed dataset, the variable 'imp' denotes 
* which imputed dataset an observation belongs to. 
 
* The unimputed dataset can be identified with imp==0.

* The following analysis uses either the full imputed dataset or the 
* third imputed dataset, identified from the full dataaset with imp==3. 

* Which dataset was used is specified in section heading.


*----------------------------------------------------------------------------
* 6 Descriptive statistics (Full dataset)
*----------------------------------------------------------------------------

use "Full imputed dataset", clear

*** 6.1 Dependent variable distribution (Table A-I)

tab p0607d if imp==0 
tab p0607d if imp~=0 

*** 6.2 Summary statistics (Table A-II)

sum HI_ostby HI_exp_ostby HI_edu_h p42s inc_edu b29s R_exp_pc ///
	p22 y05 b03 z_b10 b13m_4 aretype R_trend_casualty R_youngmen ///
	region resistance_d R_violence R_martyrs R_casualties R_wage ///
	if imp~=0




*----------------------------------------------------------------------------	
* 7 Main model (Full dataset)
*----------------------------------------------------------------------------

use "Full imputed dataset", clear

*** 7.1 Installing the gllamm package

ssc install gllamm

*** 7.2 Defining program for combining results across imputations 

program define mi_gllamm 
version 13
syntax varlist, GLLAMMOPtions(string)[MODELname(string)] 
		
forvalues imp = 1/5 { 

	use "Full imputed dataset", clear
	
	mi extract `imp'
	
	quietly gllamm `varlist', `gllammoptions' 
	estimates store `modelname'_m`imp'
	
	matrix b`imp' = e(b)
	matrix V`imp' = e(V)
	matrix vd`imp' = vecdiag(V`imp')   /*row vector from diagonal of V*/
	matrix M_cov`imp' = M_cov
	matrix M_se`imp' = M_se
}

mata: mi_comb_results()

matrix `modelname'_logform = (b, T, z, CI95_low, CI95_high)
matrix colnames `modelname'_logform = b T z CI95_low CI95_high
matrix `modelname'_eform = (b_eform, z, CI95_low_e, CI95_high_e)   
matrix colnames `modelname'_eform = b_eform z CI95_low_e CI95_high_e
matrix `modelname'_level2var = (M_cov, M_se, M_z, M_CI95_low, M_CI95_high)
matrix colnames `modelname'_level2var = M_cov M_se M_z M_CI95_low M_CI95_high
matrix rownames `modelname'_level2var = level2var	

mat list `modelname'_logform        
mat list `modelname'_eform 
mat list `modelname'_level2var         

end


version 13 
mata:
void mi_comb_results()
{
	b1 = st_matrix("b1")' /*converting into colum vectors to make displaying easier later on*/
	b2 = st_matrix("b2")'
	b3 = st_matrix("b3")'
	b4 = st_matrix("b4")'
	b5 = st_matrix("b5")'
	vd1 = st_matrix("vd1")'
	vd2 = st_matrix("vd2")'
	vd3 = st_matrix("vd3")'
	vd4 = st_matrix("vd4")'
	vd5 = st_matrix("vd5")'
	M_cov1 = st_matrix("M_cov1")'
	M_cov2 = st_matrix("M_cov2")'
	M_cov3 = st_matrix("M_cov3")'
	M_cov4 = st_matrix("M_cov4")'
	M_cov5 = st_matrix("M_cov5")'
	M_var1 = st_matrix("M_se1")'
	M_var2 = st_matrix("M_se2")'
	M_var3 = st_matrix("M_se3")'
	M_var4 = st_matrix("M_se4")'
	M_var5 = st_matrix("M_se5")'
	
	b = (b1+b2+b3+b4+b5)*1/5
	vd = ((vd1+vd2+vd3+vd4+vd5)*1/5) + ///
		0.3*(((b1-b):^2)+((b2-b):^2)+((b3-b):^2)+((b4-b):^2)+((b5-b):^2))
	
	T = sqrt(vd)
	z = b:/T
	CI95_low = b - 1.96*T
	CI95_high = b + 1.96*T
	
	b_eform = exp(b)
	CI95_low_e = exp(CI95_low)
	CI95_high_e = exp(CI95_high)
	
	M_cov = (M_cov1+M_cov2+M_cov3+M_cov4+M_cov5)*1/5 
	M_var = (M_var1+M_var2+M_var3+M_var4+M_var5)*1/5+0.3*(((M_cov1-M_cov):^2)+ ///
			((M_cov2-M_cov):^2)+((M_cov3-M_cov):^2)+((M_cov4-M_cov):^2)+((M_cov5-M_cov):^2))
	M_se = sqrt(M_var)
	
	M_z = M_cov:/M_se
	M_CI95_low = M_cov - 1.96*M_se
	M_CI95_high = M_cov + 1.96*M_se
	
	st_matrix("b", b)
	st_matrix("vd", vd)
	st_matrix("T", T)     
	st_matrix("z", z)
	st_matrix("CI95_low", CI95_low)
	st_matrix("CI95_high", CI95_high)
	st_matrix("b_eform", b_eform)
	st_matrix("CI95_low_e", CI95_low_e)
	st_matrix("CI95_high_e", CI95_high_e)
	
	st_matrix("M_cov", M_cov)
	st_matrix("M_se", M_se)
	st_matrix("M_z", M_z)     
	st_matrix("M_CI95_low", M_CI95_low)
	st_matrix("M_CI95_high", M_CI95_high)
}
end



*** 7.3 Main model (Table I)

use "Full imputed dataset", clear
mi extract 0
quietly gllamm p0607d z_p42s z_inc_edu z_b29s p22_2 conf_fayyad y05 b03 z_b10 b13m_4 ///
			aretype_2 aretype_3 z_HI_ostby z_HI_exp_ostby z_HI_edu_h ///
			z_R_exp_pc z_R_trend_casualty z_R_youngmen, ///
			i(governorate) init lin(mlogit) family(binom) base(1)
matrix a=e(b)

mi_gllamm p0607d z_p42s z_inc_edu z_b29s p22_2 conf_fayyad y05 b03 z_b10 b13m_4 ///
			aretype_2 aretype_3 z_HI_ostby z_HI_exp_ostby z_HI_edu_h ///
			z_R_exp_pc z_R_trend_casualty z_R_youngmen, ///
			gllammoptions("i(governorate) lin(mlogit) family(binom) base(1) from(a) skip adapt") ///
			modelname("baseline")
			
matrix rownames baseline_logform = 0_z_p42s 0_z_inc_edu 0_z_b29s 0_p22_2 0_conf_fayyad 0_y05 0_b03 0_z_b10 0_b13m_4 ///
						0_aretype_2 0_aretype_3 0_z_HI_ostby 0_z_HI_exp_ostby 0_z_HI_edu_h ///
						0_z_R_exp_pc 0_z_R_trend_casualty 0_z_R_youngmen 0_intercept ///
						2_z_p42s 2_z_inc_edu 2_z_b29s 2_p22_2 2_conf_fayyad 2_y05 2_b03 2_z_b10 2_b13m_4 ///
						2_aretype_2 2_aretype_3 2_z_HI_ostby 2_z_HI_exp_ostby 2_z_HI_edu_h ///
						2_z_R_exp_pc 2_z_R_trend_casualty 2_z_R_youngmen 2_intercept ///
						3_z_p42s 3_z_inc_edu 3_z_b29s 3_p22_2 3_conf_fayyad 3_y05 3_b03 3_z_b10 3_b13m_4 ///
						3_aretype_2 3_aretype_3 3_z_HI_ostby 3_z_HI_exp_ostby 3_z_HI_edu_h /// 
						3_z_R_exp_pc 3_z_R_trend_casualty 3_z_R_youngmen 3_intercept ///
						gov	

matrix rownames baseline_eform = 0_z_p42s 0_z_inc_edu 0_z_b29s 0_p22_2 0_conf_fayyad 0_y05 0_b03 0_z_b10 0_b13m_4 ///
						0_aretype_2 0_aretype_3 0_z_HI_ostby 0_z_HI_exp_ostby 0_z_HI_edu_h ///
						0_z_R_exp_pc 0_z_R_trend_casualty 0_z_R_youngmen 0_intercept ///
						2_z_p42s 2_z_inc_edu 2_z_b29s 2_p22_2 2_conf_fayyad 2_y05 2_b03 2_z_b10 2_b13m_4 ///
						2_aretype_2 2_aretype_3 2_z_HI_ostby 2_z_HI_exp_ostby 2_z_HI_edu_h ///
						2_z_R_exp_pc 2_z_R_trend_casualty 2_z_R_youngmen 2_intercept ///
						3_z_p42s 3_z_inc_edu 3_z_b29s 3_p22_2 3_conf_fayyad 3_y05 3_b03 3_z_b10 3_b13m_4 ///
						3_aretype_2 3_aretype_3 3_z_HI_ostby 3_z_HI_exp_ostby 3_z_HI_edu_h /// 
						3_z_R_exp_pc 3_z_R_trend_casualty 3_z_R_youngmen 3_intercept ///
						gov		
matrix list baseline_logform
matrix list baseline_eform
matrix list baseline_level2var


*** 7.4 Random intercept model (Table A-V)

use "Full imputed dataset", clear
mi extract 0
quietly gllamm p0607d z_p42s z_inc_edu z_b29s p22_2 conf_fayyad y05 b03 z_b10 b13m_4 ///
			aretype_2 aretype_3, ///
			i(governorate) init lin(mlogit) family(binom) base(1)
matrix a=e(b)

mi_gllamm p0607d z_p42s z_inc_edu z_b29s  p22_2 conf_fayyad y05 b03 z_b10 b13m_4 ///
			aretype_2 aretype_3, ///
			gllammoptions("i(governorate) lin(mlogit) family(binom) base(1) from(a) skip adapt") ///
			modelname("random_intercept")
	
matrix rownames random_intercept_logform = 0_z_p42s 0_z_inc_edu 0_z_b29s  0_p22_2 0_conf_fayyad 0_y05 0_b03 ///
						0_z_b10 0_b13m_4 0_aretype_2 0_aretype_3 0_intercept ///
						2_z_p42s 2_z_inc_edu 2_z_b29s  2_p22_2 2_conf_fayyad 2_y05 2_b03 ///
						2_z_b10 2_b13m_4 2_aretype_2 2_aretype_3 2_intercept ///
						3_z_p42s 3_z_inc_edu 3_z_b29s  3_p22_2 3_conf_fayyad 3_y05 3_b03 ///
						3_z_b10 3_b13m_4 3_aretype_2 3_aretype_3 3_intercept ///
						gov	

matrix rownames random_intercept_eform = 0_z_p42s 0_z_inc_edu 0_z_b29s  0_p22_2 0_conf_fayyad 0_y05 0_b03 ///
						0_z_b10 0_b13m_4 0_aretype_2 0_aretype_3 0_intercept ///
						2_z_p42s 2_z_inc_edu 2_z_b29s  2_p22_2 2_conf_fayyad 2_y05 2_b03 ///
						2_z_b10 2_b13m_4 2_aretype_2 2_aretype_3 2_intercept ///
						3_z_p42s 3_z_inc_edu 3_z_b29s  3_p22_2 3_conf_fayyad 3_y05 3_b03 ///
						3_z_b10 3_b13m_4 3_aretype_2 3_aretype_3 3_intercept ///
						gov		
matrix list random_intercept_logform
matrix list random_intercept_eform
matrix list random_intercept_level2var


*** 7.5 Baseline model for models run in third imputed dataset only

use "Full imputed dataset", clear
mi extract 0
quietly gllamm p0607d z_p42s z_inc_edu z_b29s p22_2 conf_fayyad y05 b03 z_b10 b13m_4 ///
			aretype_2 aretype_3 z_HI_ostby z_HI_exp_ostby z_HI_edu_h ///
			z_R_exp_pc z_R_trend_casualty z_R_youngmen, ///
			i(governorate) init lin(mlogit) family(binom) base(1)
matrix a=e(b)

use "Full imputed dataset", clear
mi extract 3
gllamm p0607d z_p42s z_inc_edu z_b29s p22_2 conf_fayyad y05 b03 z_b10 b13m_4 ///
			aretype_2 aretype_3 z_HI_ostby z_HI_exp_ostby z_HI_edu_h ///
			z_R_exp_pc z_R_trend_casualty z_R_youngmen, ///
			i(governorate) lin(mlogit) family(binom) base(1) from(a) skip adapt
			
matrix a=e(b)
estimates store baseline3 

save "Third imputed dataset"	


*----------------------------------------------------------------------------
* 8 Predicted probabilities (Third imputed dataset)
*----------------------------------------------------------------------------

*** 8.1 Defining program for confidence intervals around predicted probabilities

		* Based on Stata program ci_marg_mu by Sophia Rabe Hesketh
		* (http://ideas.repec.org/c/boc/bocode/s456961.html)
		* but slightly rewritten to fit nominal dependent variable 

program define ci_marg_mu_o 
version 13
syntax newvarlist(min=2 max=2) [if] [in] [, DOTS Level(int $S_level) Reps(int 1000) Outcome(integer 1)]
    if "`e(cmd)'" != "gllamm" {
          di in red  "gllamm was not the last command"
          error 301
    }

    local n200 = `reps'/200
    if floor(`n200')<`reps'/200{
        disp in re "reps must be a multiple of 200"
        exit 198
    }
    tempname p b v bc vc T a cholv
    tempvar idno
    gen long `idno' = _n
    
    /* number of observation in tails */
    local extreme = `n200'*(200-2*`level')

    timer clear 6
    timer on 6

    /* deal with if and in */
    tempvar touse
    mark `touse' `if' `in'
    preserve
    qui keep if `touse'

    /* deal with estimates and constraints*/
    matrix `b'=e(b)
    matrix `v'=e(V)
    if `e(const)'==1{
        matrix `T'=e(T)
        matrix `a'=e(a)
    }
    else{
        matrix `T'=I(colsof(`b'))
        matrix `a'=J(1,colsof(`b'),0)
    }
    matrix `vc' = `T''*`v'*`T'
    matrix `cholv' = cholesky(`vc')
    matrix `bc' = (`b'-`a')*`T'

    local vlist
    forvalues i=1/`extreme' {
        tempvar pm`i'
        local vlist `vlist' `pm`i''
        mata: mf_sample_p()
        qui gllapred `pm`i'' if `touse', mu marg fsample from(`p') outcome(`outcome')
        if "`dots'"!="" noi di in gr "." _c
    }
    if "`dots'"!="" noi disp " "
    timer off 6
    quietly timer list 6
    if "`dots'"!="" noi disp in gr r(t6) " seconds = " r(t6)/60 " minutes = " r(t6)/3600 " hours"

    if "`dots'"!="" noi disp " "

    timer clear 6
    timer on 6
    local extremep = `extreme' + 1
    forvalues j=`extremep'/`reps'{
        tempvar new
        mata: mf_sample_p()
        qui gllapred `new' if `touse', mu marg fsample from(`p') outcome(`outcome')
        if "`dots'"!="" noi di in gr "." _c

        mata: rowshuffle(`extreme',"`touse'","`vlist' `new'")

        drop `new'
    }

    if "`dots'"!="" noi disp " "
    timer off 6
    quietly timer list 6
    if "`dots'"!="" noi disp in gr r(t6) " seconds = " r(t6)/60 " minutes = " r(t6)/3600 " hours"

    tokenize `varlist'
    local y "`1'"
    
    local lhalf = `extreme'/2
    local uhalf = `lhalf' + 1

    rename `pm`lhalf'' `1'
    rename `pm`uhalf'' `2'

    local lp = round((100-`level')/2,.1)
    local up = round(100-`lp',.1)
    label var `1' "`lp' percentile for gllapred, mu marg "
    label var `2' "`up' percentile for gllapred, mu marg "
 
    /* restore data */
    tempfile file
    qui keep `idno' `1' `2'
    sort `idno'
    qui save "`file'", replace
    restore
    tempvar mrge
    sort `idno'
    qui merge `idno' using "`file'", _merge(`mrge')
end

version 11
mata:
void rowshuffle(numeric scalar num, string scalar touse, string scalar varlist)
{
    veclabs = tokens(varlist)
    // veclabs

    st_view(V,.,veclabs,touse)


    // sort rows and delete 26th element

    uptoi = num/2
    fromi = uptoi + 2
    nump = num + 1 
    for (i=1;i<=rows(V);i++){
        newrow=sort(V[i,]',1)'
        newrow=newrow[1..uptoi],newrow[fromi..nump]
        V[i,1..num]=newrow
    }
}

void mf_sample_p()
{
    cholV = st_matrix(st_local("cholv"))
    p = st_matrix(st_local("bc")) + (cholV * rnormal(cols(cholV), 1, 0, 1))'
    p = p*st_matrix(st_local("T"))' + st_matrix(st_local("a"))
    st_matrix(st_local("p"),p )
}
end



*** 8.2 HI durables index (Figure 1)

use "Third imputed dataset", clear
estimates restore baseline3

save temp, replace
drop _all
set obs 50 
generate HI_ostby = 0.30 + _n*0.005 
generate z_HI_ostby = (HI_ostby-0.442)/0.0679 

generate set = 3000 + _n
expand 4 

by set, sort: generate p0607d=_n
recode p0607d (4=0)

generate z_b29s=0
generate z_p42s=0
generate z_inc_edu=0 
generate p22_2=0
generate conf_fayyad=0
generate y05=0
generate b03=0
generate z_b10=0
generate b13m_4=0
generate aretype_2=0
generate aretype_3=0
generate z_HI_exp_ostby=0
generate z_HI_edu_h=0
generate z_R_exp_pc=0
generate z_R_trend_casualty=0
generate z_R_youngmen=0

replace p0607d=.
append using temp

generate preddata = p0607d ==.

gllapred probs0, mu marginal fsample outcome(0)
gllapred probs1, mu marginal fsample outcome(1)
gllapred probs2, mu marginal fsample outcome(2)
gllapred probs3, mu marginal fsample outcome(3)

foreach outcome in 0 1 2 3 {
	ci_marg_mu_o lower95_`outcome' upper95_`outcome', dots level(95) reps(1000) outcome(`outcome')
	}
save "Figure 1 dataset"
	
twoway ///
	(rarea upper95_0 lower95_0 z_HI_ostby, sort color(gs14)) ///
	(rarea upper95_3 lower95_3 z_HI_ostby, sort color(gs14)) ///
	(rarea upper95_1 lower95_1 z_HI_ostby, sort color(gs14)) ///
	(rarea upper95_2 lower95_2 z_HI_ostby, sort color(gs14)) ///
	(line probs1 z_HI_ostby, sort lpatt(longdash) lcolor(black) lwidth(thin)) ///
	(line probs2 z_HI_ostby, sort lpatt(solid) lcolor(black) lwidth(thin)) ///
	(line probs3 z_HI_ostby, sort lpatt(dash) lcolor(black) lwidth(thin)) ///
	(line probs0 z_HI_ostby, sort lpatt(shortdash) lcolor(black) lwidth(thin)) /// 	
	if preddata==1, legend(order(5 "Non-violence only" 6 "Violence only" 7 "Both" 8 "Neither") rows(1)) ///
	xtitle(HI household durables index) ytitle(Probabilities: Support for resistance) ///
	
graph save Graph "Figure 1"
graph export Figure1.tif, width(2000)


*** 8.3 HI expenditures (Figure 2)

use "Third imputed dataset", clear
estimates restore baseline3

save temp, replace
drop _all
set obs 71 
generate HI_exp_ostby = 0.345 + _n*0.005 
generate z_HI_exp_ostby = (HI_exp_ostby-0.601)/0.0885 

generate set = 3000 + _n
expand 4 

by set, sort: generate p0607d=_n
recode p0607d (4=0)

generate z_b29s=0
generate z_p42s=0
generate z_inc_edu=0 
generate p22_2=0
generate conf_fayyad=0
generate y05=0
generate b03=0
generate z_b10=0
generate b13m_4=0
generate aretype_2=0
generate aretype_3=0
generate z_HI_ostby=0
generate z_HI_edu_h=0
generate z_R_exp_pc=0
generate z_R_trend_casualty=0
generate z_R_youngmen=0

replace p0607d=.
append using temp

generate preddata = p0607d ==.

gllapred probs0, mu marginal fsample outcome(0)
gllapred probs1, mu marginal fsample outcome(1)
gllapred probs2, mu marginal fsample outcome(2)
gllapred probs3, mu marginal fsample outcome(3)

foreach outcome in 0 1 2 3 {
	ci_marg_mu_o lower95_`outcome' upper95_`outcome', dots level(95) reps(1000) outcome(`outcome')
	}	
save "Figure 2 dataset"

twoway ///
	(rarea upper95_0 lower95_0 z_HI_exp_ostby, sort color(gs14)) ///
	(rarea upper95_3 lower95_3 z_HI_exp_ostby, sort color(gs14)) ///
	(rarea upper95_1 lower95_1 z_HI_exp_ostby, sort color(gs14)) ///
	(rarea upper95_2 lower95_2 z_HI_exp_ostby, sort color(gs14)) ///
	(line probs1 z_HI_exp_ostby, sort lpatt(longdash) lcolor(black) lwidth(thin)) ///
	(line probs2 z_HI_exp_ostby, sort lpatt(solid) lcolor(black) lwidth(thin)) ///
	(line probs3 z_HI_exp_ostby, sort lpatt(dash) lcolor(black) lwidth(thin)) ///
	(line probs0 z_HI_exp_ostby, sort lpatt(shortdash) lcolor(black) lwidth(thin)) /// 	
	if preddata==1, legend(order(5 "Non-violence only" 6 "Violence only" 7 "Both" 8 "Neither") rows(1)) ///
	xtitle(HI household expenditure) ytitle(Probabilities: Support for resistance) ///

graph save Graph "Figure 2"

	
*** 8.4 Civil and political rights status (Figure 3)

use "Third imputed dataset", clear
estimates restore baseline3

save temp, replace
drop _all
set obs 31 
generate p42s = 0.9 + _n*0.1 
generate z_p42s = (p42s-2.04)/0.776 

generate set = 3000 + _n
expand 4 /*four categories*/

by set, sort: generate p0607d=_n
recode p0607d (4=0)

generate z_b29s=0
generate z_inc_edu=0 
generate p22_2=0
generate conf_fayyad=0
generate y05=0
generate b03=0
generate z_b10=0
generate b13m_4=0
generate aretype_2=0
generate aretype_3=0
generate z_HI_ostby=0
generate z_HI_exp_ostby=0
generate z_HI_edu_h=0
generate z_R_exp_pc=0
generate z_R_trend_casualty=0
generate z_R_youngmen=0

replace p0607d=.
append using temp

generate preddata = p0607d ==.

gllapred probs0, mu marginal fsample outcome(0)
gllapred probs1, mu marginal fsample outcome(1)
gllapred probs2, mu marginal fsample outcome(2)
gllapred probs3, mu marginal fsample outcome(3)

foreach outcome in 0 1 2 3 {
	ci_marg_mu_o lower95_`outcome' upper95_`outcome', dots level(95) reps(1000) outcome(`outcome')
	}	
save "Figure 3 dataset"

twoway ///
	(rarea upper95_0 lower95_0 z_p42s, sort color(gs14)) ///
	(rarea upper95_3 lower95_3 z_p42s, sort color(gs14)) ///
	(rarea upper95_1 lower95_1 z_p42s, sort color(gs14)) ///
	(rarea upper95_2 lower95_2 z_p42s, sort color(gs14)) ///
	(line probs1 z_p42s, sort lpatt(longdash) lcolor(black) lwidth(thin)) ///
	(line probs2 z_p42s, sort lpatt(solid) lcolor(black) lwidth(thin)) ///
	(line probs3 z_p42s, sort lpatt(dash) lcolor(black) lwidth(thin)) ///
	(line probs0 z_p42s, sort lpatt(shortdash) lcolor(black) lwidth(thin)) /// 	
	if preddata==1, legend(order(5 "Non-violence only" 6 "Violence only" 7 "Both" 8 "Neither") rows(1)) ///
	xtitle(Civil and political rights status) ytitle(Probabilities: Support for resistance) ///

graph save Graph "Figure 3"		


*** 8.5 HI variables combined (Figure 4)

use "Third imputed dataset", clear

  * Reversing civil and political rights and interaction
generate z_p42n = 0-z_p42s
generate z_inc_edu_n = 0-z_inc_edu

  * Running baseline model with reversed variables
mlogit p0607d z_b29s z_inc_edu z_p42n p22_2 conf_fayyad y05 b03  ///
				z_b10 b13m_4 aretype_2 aretype_3 ib(first).governorate
matrix a=e(b)

gllamm p0607d z_b29s z_inc_edu z_p42n p22_2 conf_fayyad y05 b03 z_b10 b13m_4 ///
			aretype_2 aretype_3 z_HI_ostby z_HI_exp_ostby z_HI_edu_h ///
			z_R_exp_pc z_R_trend_casualty z_R_youngmen ///
			, i(governorate) lin(mlogit) family(binom) base(1) from(a) skip adapt
matrix a=e(b)
estimates store baseline_allHI

  * Predicting probabilities
save temp, replace
drop _all
set obs 12
generate z_HI_exp_ostby = -2 + _n*0.25 
generate z_HI_ostby = -2 + _n*0.25 
generate z_HI_edu_h = -2 + _n*0.25 
generate z_p42n = -2 + _n*0.25

generate set = 3000 + _n
expand 4 

by set, sort: generate p0607d=_n
recode p0607d (4=0)

generate z_b29s=0
generate z_inc_edu=0
generate p22_2=0
generate conf_fayyad=0
generate y05=0
generate b03=0
generate z_b10=0
generate b13m_4=0
generate aretype_2=0
generate aretype_3=0
generate z_R_exp_pc=0
generate z_R_trend_casualty=0
generate z_R_youngmen=0

replace p0607d=.
append using temp

generate preddata = p0607d ==.

gllapred probs0, mu marginal fsample outcome(0)
gllapred probs1, mu marginal fsample outcome(1)
gllapred probs2, mu marginal fsample outcome(2)
gllapred probs3, mu marginal fsample outcome(3)

foreach outcome in 0 1 2 3 {
	ci_marg_mu_o lower95_`outcome' upper95_`outcome', dots level(95) reps(1000) outcome(`outcome')
	}	
save "Figure 4 dataset"

generate SE=0 
replace SE=-1.75 if z_HI_exp_ostby==-1.75 & z_HI_ostby==-1.75 & z_HI_edu_h==-1.75 & z_p42n==-1.75
replace SE=-1.5 if z_HI_exp_ostby==-1.5 & z_HI_ostby==-1.5 & z_HI_edu_h==-1.5 & z_p42n==-1.5 
replace SE=-1.25 if z_HI_exp_ostby==-1.25 & z_HI_ostby==-1.25 & z_HI_edu_h==-1.25 & z_p42n==-1.25 
replace SE=-1 if z_HI_exp_ostby==-1 & z_HI_ostby==-1 & z_HI_edu_h==-1 & z_p42n==-1 
replace SE=-0.75 if z_HI_exp_ostby==-0.75 & z_HI_ostby==-0.75 & z_HI_edu_h==-0.75 & z_p42n==-0.75 
replace SE=-0.5 if z_HI_exp_ostby==-0.5 & z_HI_ostby==-0.5 & z_HI_edu_h==-0.5 & z_p42n==-0.5 
replace SE=-0.25 if z_HI_exp_ostby==-0.25 & z_HI_ostby==-0.25 & z_HI_edu_h==-0.25 & z_p42n==-0.25 
replace SE=0 if z_HI_exp_ostby==0 & z_HI_ostby==0 & z_HI_edu_h==0 & z_p42n==0 
replace SE=0.25 if z_HI_exp_ostby==0.25 & z_HI_ostby==0.25 & z_HI_edu_h==0.25 & z_p42n==0.25 
replace SE=0.5 if z_HI_exp_ostby==0.5 & z_HI_ostby==0.5 & z_HI_edu_h==0.5 & z_p42n==0.5 
replace SE=0.75 if z_HI_exp_ostby==0.75 & z_HI_ostby==0.75 & z_HI_edu_h==0.75 & z_p42n==0.75 
replace SE=1 if z_HI_exp_ostby==1 & z_HI_ostby==1 & z_HI_edu_h==1 & z_p42n==1 

twoway ///
	(rarea upper95_0 lower95_0 SE, sort color(gs14)) ///
	(rarea upper95_3 lower95_3 SE, sort color(gs14)) ///
	(rarea upper95_1 lower95_1 SE, sort color(gs14)) ///
	(rarea upper95_2 lower95_2 SE, sort color(gs14)) ///
	(line probs1 SE, sort lpatt(longdash) lcolor(black) lwidth(thin)) ///
	(line probs2 SE, sort lpatt(solid) lcolor(black) lwidth(thin)) ///
	(line probs3 SE, sort lpatt(dash) lcolor(black) lwidth(thin)) ///
	(line probs0 SE, sort lpatt(shortdash) lcolor(black) lwidth(thin)) /// 	
	if preddata==1, legend(order(5 "Non-violence only" 6 "Violence only" 7 "Both" 8 "Neither") rows(1)) ///
	xtitle(Std.dev: Horizontal inequality variables) ytitle(Probabilities: Support for resistance) ///

graph save Graph "Figure 4"


	
*----------------------------------------------------------------------------
* 9 Predictive power (Third imputed dataset)
*----------------------------------------------------------------------------

use "Third imputed dataset", clear


*** 9.1 Outcome dummies
generate res2_d = p0607d==2 
generate res1_d = p0607d==1
generate res3_d = p0607d==3
generate res0_d = p0607d==0


*** 9.2 In-sample predictive power (Table II)

  * Baseline model including HI variables
estimates restore baseline3

gllapred baseline, mu outcome(2) fsample /*fsample because the dataset has been
										reopened since the model was estimated, 
										so Stata no longer considers the 
										observations part of estimation sample*/
roctab res2_d baseline, graph

  * Excluding HI variables
gllamm p0607d z_b29s z_inc_edu p22_2 conf_fayyad y05 b03 z_b10 b13m_4 ///
		aretype_2 aretype_3 z_R_exp_pc z_R_trend_casualty z_R_youngmen ///
		, i(governorate) lin(mlogit) family(binom) base(1) from(a) skip adapt

gllapred excl_HI, mu outcome(2)
roctab res2_d excl_HI

roccomp res2_d excl_HI baseline, graph summary
graph save Graph "ROC curve"

save "Third imputed dataset", replace


*** 9.3 Out-of-sample predictive power (Table II)

use "Third imputed dataset", clear
estimates restore baseline3

  * If matrix a is not already defined
	quietly gllamm p0607d z_p42s z_inc_edu z_b29s p22_2 y05 b03 z_b10 b13m_4 ///
			aretype_2 aretype_3 z_HI_ostby z_HI_exp_ostby z_HI_edu_h ///
			z_R_exp_pc z_R_trend_casualty z_R_youngmen if group`s'==0, ///
			i(governorate) init lin(mlogit) family(binom) base(1) 
	matrix a=e(b) 

  * Dividing sample five times
forvalues s = 1/5 {
	generate random`s' = runiform()
	sort random`s' 
	gen group`s' = (_n > 1263) /*splits sample randomly in 70/30 with value 0 
								for the 70 percent and 1 for the 30 percent*/
	
	*Baseline model including HI variables
	quietly gllamm p0607d z_b29s z_inc_edu z_p42s p22_2 conf_fayyad y05 b03 ///
			z_b10 b13m_4 aretype_2 aretype_3 z_HI_ostby z_HI_exp_ostby ///
			z_HI_edu_h z_R_exp_pc z_R_trend_casualty z_R_youngmen ///
			if group`s'==0 ///
			, i(governorate) lin(mlogit) family(binom) base(1) from(a) skip adapt
	estimates store group`s'
	matrix a=e(b)
	
	gllapred outsample`s' if group`s'==1, mu outcome(2) fsample
	
	*Excluding HI variables
	quietly gllamm p0607d z_b29s z_inc_edu p22_2 conf_fayyad y05 b03 z_b10 b13m_4 ///
			aretype_2 aretype_3 z_R_exp_pc z_R_trend_casualty z_R_youngmen ///
			if group`s'==0 ///
			, i(governorate) lin(mlogit) family(binom) base(1) from(a) skip adapt
	estimates store group`s'_noHI

	gllapred outsample`s'_noHI if group`s'==1, mu outcome(2) fsample
}

  * Generating AUCs (to combine in Excel)
roctab res2_d outsample1 if group1==1
roctab res2_d outsample1_noHI if group1==1

roctab res2_d outsample2 if group2==1
roctab res2_d outsample2_noHI if group2==1

roctab res2_d outsample3 if group3==1
roctab res2_d outsample3_noHI if group3==1

roctab res2_d outsample4 if group4==1
roctab res2_d outsample4_noHI if group4==1

roctab res2_d outsample5 if group5==1
roctab res2_d outsample5_noHI if group5==1


save "Third imputed dataset", replace




*----------------------------------------------------------------------------
* 10 Alternative model specifications (Full dataset)
*----------------------------------------------------------------------------


*** 10.1 With Gaza dummy (Table III, Model R2)

use "Full imputed dataset", clear
mi extract 0     
quietly gllamm p0607d z_p42s z_inc_edu z_b29s p22_2 conf_fayyad y05 b03 z_b10 b13m_4 ///
			aretype_2 aretype_3 region z_HI_ostby z_HI_exp_ostby z_HI_edu_h ///
			z_R_exp_pc z_R_trend_casualty z_R_youngmen, ///
			i(governorate) init lin(mlogit) family(binom) base(1)
matrix a=e(b)

mi_gllamm p0607d z_p42s z_inc_edu z_b29s p22_2 conf_fayyad y05 b03 z_b10 b13m_4 ///
			aretype_2 aretype_3 region z_HI_ostby z_HI_exp_ostby z_HI_edu_h ///
			z_R_exp_pc z_R_trend_casualty z_R_youngmen, ///
			gllammoptions("i(governorate) lin(mlogit) family(binom) base(1) from(a) skip adapt") ///
			modelname("R2_gazadummy")
			
matrix rownames R2_gazadummy_logform = 0_z_p42s 0_z_inc_edu 0_z_b29s 0_p22_2 0_conf_fayyad 0_y05 0_b03 0_z_b10 0_b13m_4 ///
						0_aretype_2 0_aretype_3 0_region 0_z_HI_ostby 0_z_HI_exp_ostby 0_z_HI_edu_h ///
						0_z_R_exp_pc 0_z_R_trend_casualty 0_z_R_youngmen 0_intercept ///
						2_z_p42s 2_z_inc_edu 2_z_b29s 2_p22_2 2_conf_fayyad 2_y05 2_b03 2_z_b10 2_b13m_4 ///
						2_aretype_2 2_aretype_3 2_region 2_z_HI_ostby 2_z_HI_exp_ostby 2_z_HI_edu_h ///
						2_z_R_exp_pc 2_z_R_trend_casualty 2_z_R_youngmen 2_intercept ///
						3_z_p42s 3_z_inc_edu 3_z_b29s 3_p22_2 3_conf_fayyad 3_y05 3_b03 3_z_b10 3_b13m_4 ///
						3_aretype_2 3_aretype_3 3_region 3_z_HI_ostby 3_z_HI_exp_ostby 3_z_HI_edu_h /// 
						3_z_R_exp_pc 3_z_R_trend_casualty 3_z_R_youngmen 3_intercept ///
						gov	

matrix rownames R2_gazadummy_eform = 0_z_p42s 0_z_inc_edu 0_z_b29s 0_p22_2 0_conf_fayyad 0_y05 0_b03 0_z_b10 0_b13m_4 ///
						0_aretype_2 0_aretype_3 0_region 0_z_HI_ostby 0_z_HI_exp_ostby 0_z_HI_edu_h ///
						0_z_R_exp_pc 0_z_R_trend_casualty 0_z_R_youngmen 0_intercept ///
						2_z_p42s 2_z_inc_edu 2_z_b29s 2_p22_2 2_conf_fayyad 2_y05 2_b03 2_z_b10 2_b13m_4 ///
						2_aretype_2 2_aretype_3 2_region 2_z_HI_ostby 2_z_HI_exp_ostby 2_z_HI_edu_h ///
						2_z_R_exp_pc 2_z_R_trend_casualty 2_z_R_youngmen 2_intercept ///
						3_z_p42s 3_z_inc_edu 3_z_b29s 3_p22_2 3_conf_fayyad 3_y05 3_b03 3_z_b10 3_b13m_4 ///
						3_aretype_2 3_aretype_3 3_region 3_z_HI_ostby 3_z_HI_exp_ostby 3_z_HI_edu_h /// 
						3_z_R_exp_pc 3_z_R_trend_casualty 3_z_R_youngmen 3_intercept ///
						gov			
matrix list R2_gazadummy_logform
matrix list R2_gazadummy_eform
matrix list R2_gazadummy_level2var


*** 10.2 Binominal model (Table III, Model R1)

use "Full imputed dataset", clear
mi extract 0
quietly gllamm resistance_d z_p42s z_inc_edu z_b29s p22_2 conf_fayyad y05 b03 z_b10 b13m_4 ///
			aretype_2 aretype_3 z_HI_ostby z_HI_exp_ostby z_HI_edu_h ///
			z_R_exp_pc z_R_trend_casualty z_R_youngmen, ///
			i(governorate) init lin(logit) family(binom) 
matrix a=e(b)

mi_gllamm resistance_d z_p42s z_inc_edu z_b29s p22_2 conf_fayyad y05 b03 z_b10 b13m_4 ///
			aretype_2 aretype_3 z_HI_ostby z_HI_exp_ostby z_HI_edu_h ///
			z_R_exp_pc z_R_trend_casualty z_R_youngmen, ///
			gllammoptions("i(governorate) lin(logit) family(binom) from(a) skip adapt") ///
			modelname("R1_binominal")
			
matrix rownames R1_binominal_logform = z_p42s z_inc_edu z_b29s p22_2 conf_fayyad y05 b03 z_b10 b13m_4 ///
						aretype_2 aretype_3 z_HI_ostby z_HI_exp_ostby z_HI_edu_h ///
						z_R_exp_pc z_R_trend_casualty z_R_youngmen intercept ///
						gov	

matrix rownames R1_binominal_eform = z_p42s z_inc_edu z_b29s p22_2 conf_fayyad y05 b03 z_b10 b13m_4 ///
						aretype_2 aretype_3 z_HI_ostby z_HI_exp_ostby z_HI_edu_h ///
						z_R_exp_pc z_R_trend_casualty z_R_youngmen intercept ///
						gov		
matrix list R1_binominal_logform
matrix list R1_binominal_eform
matrix list R1_binominal_level2var


*** 10.3 Conflict intensity: Self-reported exposure (Table III, Model R3)

use "Full imputed dataset", clear
mi extract 0
quietly gllamm p0607d z_p42s z_inc_edu z_b29s p22_2 conf_fayyad y05 b03 z_b10 b13m_4 ///
			aretype_2 aretype_3 z_HI_ostby z_HI_exp_ostby z_HI_edu_h ///
			z_R_exp_pc z_R_trend_casualty z_R_violence z_R_youngmen, ///
			i(governorate) init lin(mlogit) family(binom) base(1)
matrix a=e(b)

mi_gllamm p0607d z_p42s z_inc_edu z_b29s p22_2 conf_fayyad y05 b03 z_b10 b13m_4 ///
			aretype_2 aretype_3 z_HI_ostby z_HI_exp_ostby z_HI_edu_h ///
			z_R_exp_pc z_R_trend_casualty z_R_violence z_R_youngmen, ///
			gllammoptions("i(governorate) lin(mlogit) family(binom) base(1) from(a) skip adapt") ///
			modelname("R3_violence")
			
matrix rownames R3_violence_logform = 0_z_p42s 0_z_inc_edu 0_z_b29s 0_p22_2 0_conf_fayyad 0_y05 0_b03 0_z_b10 0_b13m_4 ///
						0_aretype_2 0_aretype_3 0_z_HI_ostby 0_z_HI_exp_ostby 0_z_HI_edu_h ///
						0_z_R_exp_pc 0_z_R_trend_casualty 0_z_R_violence 0_z_R_youngmen 0_intercept ///
						2_z_p42s 2_z_inc_edu 2_z_b29s 2_p22_2 2_conf_fayyad 2_y05 2_b03 2_z_b10 2_b13m_4 ///
						2_aretype_2 2_aretype_3 2_z_HI_ostby 2_z_HI_exp_ostby 2_z_HI_edu_h ///
						2_z_R_exp_pc 2_z_R_trend_casualty 2_z_R_violence 2_z_R_youngmen 2_intercept ///
						3_z_p42s 3_z_inc_edu 3_z_b29s 3_p22_2 3_conf_fayyad 3_y05 3_b03 3_z_b10 3_b13m_4 ///
						3_aretype_2 3_aretype_3 3_z_HI_ostby 3_z_HI_exp_ostby 3_z_HI_edu_h /// 
						3_z_R_exp_pc 3_z_R_trend_casualty 3_z_R_violence 3_z_R_youngmen 3_intercept ///
						gov	

matrix rownames R3_violence_eform = 0_z_p42s 0_z_inc_edu 0_z_b29s 0_p22_2 0_conf_fayyad 0_y05 0_b03 0_z_b10 0_b13m_4 ///
						0_aretype_2 0_aretype_3 0_z_HI_ostby 0_z_HI_exp_ostby 0_z_HI_edu_h ///
						0_z_R_exp_pc 0_z_R_trend_casualty 0_z_R_violence 0_z_R_youngmen 0_intercept ///
						2_z_p42s 2_z_inc_edu 2_z_b29s 2_p22_2 2_conf_fayyad 2_y05 2_b03 2_z_b10 2_b13m_4 ///
						2_aretype_2 2_aretype_3 2_z_HI_ostby 2_z_HI_exp_ostby 2_z_HI_edu_h ///
						2_z_R_exp_pc 2_z_R_trend_casualty 2_z_R_violence 2_z_R_youngmen 2_intercept ///
						3_z_p42s 3_z_inc_edu 3_z_b29s 3_p22_2 3_conf_fayyad 3_y05 3_b03 3_z_b10 3_b13m_4 ///
						3_aretype_2 3_aretype_3 3_z_HI_ostby 3_z_HI_exp_ostby 3_z_HI_edu_h /// 
						3_z_R_exp_pc 3_z_R_trend_casualty 3_z_R_violence 3_z_R_youngmen 3_intercept ///
						gov		
matrix list R3_violence_logform
matrix list R3_violence_eform
matrix list R3_violence_level2var


*** 10.4 Conflict intensity: 12 month casualty (Table A-VI, Model R4)

use "Full imputed dataset", clear
mi extract 0
quietly gllamm p0607d z_p42s z_inc_edu z_b29s p22_2 conf_fayyad y05 b03 z_b10 b13m_4 ///
			aretype_2 aretype_3 z_HI_ostby z_HI_exp_ostby z_HI_edu_h ///
			z_R_exp_pc z_R_trend_casualty z_R_casualties z_R_youngmen, ///
			i(governorate) init lin(mlogit) family(binom) base(1)
matrix a=e(b)

mi_gllamm p0607d z_p42s z_inc_edu z_b29s p22_2 conf_fayyad y05 b03 z_b10 b13m_4 ///
			aretype_2 aretype_3 z_HI_ostby z_HI_exp_ostby z_HI_edu_h ///
			z_R_exp_pc z_R_trend_casualty z_R_casualties z_R_youngmen, ///
			gllammoptions("i(governorate) lin(mlogit) family(binom) base(1) from(a) skip adapt") ///
			modelname("R4_violence")
			
matrix rownames R4_violence_logform = 0_z_p42s 0_z_inc_edu 0_z_b29s 0_p22_2 0_conf_fayyad 0_y05 0_b03 0_z_b10 0_b13m_4 ///
						0_aretype_2 0_aretype_3 0_z_HI_ostby 0_z_HI_exp_ostby 0_z_HI_edu_h ///
						0_z_R_exp_pc 0_z_R_trend_casualty 0_z_R_casualties 0_z_R_youngmen 0_intercept ///
						2_z_p42s 2_z_inc_edu 2_z_b29s 2_p22_2 2_conf_fayyad 2_y05 2_b03 2_z_b10 2_b13m_4 ///
						2_aretype_2 2_aretype_3 2_z_HI_ostby 2_z_HI_exp_ostby 2_z_HI_edu_h ///
						2_z_R_exp_pc 2_z_R_trend_casualty 2_z_R_casualties 2_z_R_youngmen 2_intercept ///
						3_z_p42s 3_z_inc_edu 3_z_b29s 3_p22_2 3_conf_fayyad 3_y05 3_b03 3_z_b10 3_b13m_4 ///
						3_aretype_2 3_aretype_3 3_z_HI_ostby 3_z_HI_exp_ostby 3_z_HI_edu_h /// 
						3_z_R_exp_pc 3_z_R_trend_casualty 3_z_R_casualties 3_z_R_youngmen 3_intercept ///
						gov	

matrix rownames R4_violence_eform = 0_z_p42s 0_z_inc_edu 0_z_b29s 0_p22_2 0_conf_fayyad 0_y05 0_b03 0_z_b10 0_b13m_4 ///
						0_aretype_2 0_aretype_3 0_z_HI_ostby 0_z_HI_exp_ostby 0_z_HI_edu_h ///
						0_z_R_exp_pc 0_z_R_trend_casualty 0_z_R_casualties 0_z_R_youngmen 0_intercept ///
						2_z_p42s 2_z_inc_edu 2_z_b29s 2_p22_2 2_conf_fayyad 2_y05 2_b03 2_z_b10 2_b13m_4 ///
						2_aretype_2 2_aretype_3 2_z_HI_ostby 2_z_HI_exp_ostby 2_z_HI_edu_h ///
						2_z_R_exp_pc 2_z_R_trend_casualty 2_z_R_casualties 2_z_R_youngmen 2_intercept ///
						3_z_p42s 3_z_inc_edu 3_z_b29s 3_p22_2 3_conf_fayyad 3_y05 3_b03 3_z_b10 3_b13m_4 ///
						3_aretype_2 3_aretype_3 3_z_HI_ostby 3_z_HI_exp_ostby 3_z_HI_edu_h /// 
						3_z_R_exp_pc 3_z_R_trend_casualty 3_z_R_casualties 3_z_R_youngmen 3_intercept ///
						gov		
matrix list R4_violence_logform
matrix list R4_violence_eform
matrix list R4_violence_level2var


*** 10.5 Conflict intensity: Martyrs of the intifada (Table A-VI, Model R5)

use "Full imputed dataset", clear
mi extract 0
quietly gllamm p0607d z_p42s z_inc_edu z_b29s p22_2 conf_fayyad y05 b03 z_b10 b13m_4 ///
			aretype_2 aretype_3 z_HI_ostby z_HI_exp_ostby z_HI_edu_h ///
			z_R_exp_pc z_R_trend_casualty z_R_martyrs z_R_youngmen, ///
			i(governorate) init lin(mlogit) family(binom) base(1)
matrix a=e(b)

mi_gllamm p0607d z_p42s z_inc_edu z_b29s p22_2 conf_fayyad y05 b03 z_b10 b13m_4 ///
			aretype_2 aretype_3 z_HI_ostby z_HI_exp_ostby z_HI_edu_h ///
			z_R_exp_pc z_R_trend_casualty z_R_martyrs z_R_youngmen, ///
			gllammoptions("i(governorate) lin(mlogit) family(binom) base(1) from(a) skip adapt") ///
			modelname("R5_violence")
			
matrix rownames R5_violence_logform = 0_z_p42s 0_z_inc_edu 0_z_b29s 0_p22_2 0_conf_fayyad 0_y05 0_b03 0_z_b10 0_b13m_4 ///
						0_aretype_2 0_aretype_3 0_z_HI_ostby 0_z_HI_exp_ostby 0_z_HI_edu_h ///
						0_z_R_exp_pc 0_z_R_trend_casualty 0_z_R_martyrs 0_z_R_youngmen 0_intercept ///
						2_z_p42s 2_z_inc_edu 2_z_b29s 2_p22_2 2_conf_fayyad 2_y05 2_b03 2_z_b10 2_b13m_4 ///
						2_aretype_2 2_aretype_3 2_z_HI_ostby 2_z_HI_exp_ostby 2_z_HI_edu_h ///
						2_z_R_exp_pc 2_z_R_trend_casualty 2_z_R_martyrs 2_z_R_youngmen 2_intercept ///
						3_z_p42s 3_z_inc_edu 3_z_b29s 3_p22_2 3_conf_fayyad 3_y05 3_b03 3_z_b10 3_b13m_4 ///
						3_aretype_2 3_aretype_3 3_z_HI_ostby 3_z_HI_exp_ostby 3_z_HI_edu_h /// 
						3_z_R_exp_pc 3_z_R_trend_casualty 3_z_R_martyrs 3_z_R_youngmen 3_intercept ///
						gov	

matrix rownames R5_violence_eform = 0_z_p42s 0_z_inc_edu 0_z_b29s 0_p22_2 0_conf_fayyad 0_y05 0_b03 0_z_b10 0_b13m_4 ///
						0_aretype_2 0_aretype_3 0_z_HI_ostby 0_z_HI_exp_ostby 0_z_HI_edu_h ///
						0_z_R_exp_pc 0_z_R_trend_casualty 0_z_R_martyrs 0_z_R_youngmen 0_intercept ///
						2_z_p42s 2_z_inc_edu 2_z_b29s 2_p22_2 2_conf_fayyad 2_y05 2_b03 2_z_b10 2_b13m_4 ///
						2_aretype_2 2_aretype_3 2_z_HI_ostby 2_z_HI_exp_ostby 2_z_HI_edu_h ///
						2_z_R_exp_pc 2_z_R_trend_casualty 2_z_R_martyrs 2_z_R_youngmen 2_intercept ///
						3_z_p42s 3_z_inc_edu 3_z_b29s 3_p22_2 3_conf_fayyad 3_y05 3_b03 3_z_b10 3_b13m_4 ///
						3_aretype_2 3_aretype_3 3_z_HI_ostby 3_z_HI_exp_ostby 3_z_HI_edu_h /// 
						3_z_R_exp_pc 3_z_R_trend_casualty 3_z_R_martyrs 3_z_R_youngmen 3_intercept ///
						gov	
matrix list R5_violence_logform
matrix list R5_violence_eform
matrix list R5_violence_level2var


*** 10.6 Excluding HI durables (Table A-VI, Model R6)

use "Full imputed dataset", clear
mi extract 0
quietly gllamm p0607d z_p42s z_inc_edu z_b29s p22_2 conf_fayyad y05 b03 z_b10 b13m_4 ///
			aretype_2 aretype_3 z_HI_exp_ostby z_HI_edu_h ///
			z_R_exp_pc z_R_trend_casualty z_R_youngmen, ///
			i(governorate) init lin(mlogit) family(binom) base(1)
matrix a=e(b)

mi_gllamm p0607d z_p42s z_inc_edu z_b29s p22_2 conf_fayyad y05 b03 z_b10 b13m_4 ///
			aretype_2 aretype_3 z_HI_exp_ostby z_HI_edu_h ///
			z_R_exp_pc z_R_trend_casualty z_R_youngmen, ///
			gllammoptions("i(governorate) lin(mlogit) family(binom) base(1) from(a) skip adapt") ///
			modelname("R6_exclHIdur")
			
matrix rownames R6_exclHIdur_logform = 0_z_p42s 0_z_inc_edu 0_z_b29s 0_p22_2 0_conf_fayyad 0_y05 0_b03 0_z_b10 0_b13m_4 ///
						0_aretype_2 0_aretype_3 0_z_HI_exp_ostby 0_z_HI_edu_h ///
						0_z_R_exp_pc 0_z_R_trend_casualty 0_z_R_youngmen 0_intercept ///
						2_z_p42s 2_z_inc_edu 2_z_b29s 2_p22_2 2_conf_fayyad 2_y05 2_b03 2_z_b10 2_b13m_4 ///
						2_aretype_2 2_aretype_3 2_z_HI_exp_ostby 2_z_HI_edu_h ///
						2_z_R_exp_pc 2_z_R_trend_casualty 2_z_R_youngmen 2_intercept ///
						3_z_p42s 3_z_inc_edu 3_z_b29s 3_p22_2 3_conf_fayyad 3_y05 3_b03 3_z_b10 3_b13m_4 ///
						3_aretype_2 3_aretype_3 3_z_HI_exp_ostby 3_z_HI_edu_h /// 
						3_z_R_exp_pc 3_z_R_trend_casualty 3_z_R_youngmen 3_intercept ///
						gov	

matrix rownames R6_exclHIdur_eform = 0_z_p42s 0_z_inc_edu 0_z_b29s 0_p22_2 0_conf_fayyad 0_y05 0_b03 0_z_b10 0_b13m_4 ///
						0_aretype_2 0_aretype_3 0_z_HI_exp_ostby 0_z_HI_edu_h ///
						0_z_R_exp_pc 0_z_R_trend_casualty 0_z_R_youngmen 0_intercept ///
						2_z_p42s 2_z_inc_edu 2_z_b29s 2_p22_2 2_conf_fayyad 2_y05 2_b03 2_z_b10 2_b13m_4 ///
						2_aretype_2 2_aretype_3 2_z_HI_exp_ostby 2_z_HI_edu_h ///
						2_z_R_exp_pc 2_z_R_trend_casualty 2_z_R_youngmen 2_intercept ///
						3_z_p42s 3_z_inc_edu 3_z_b29s 3_p22_2 3_conf_fayyad 3_y05 3_b03 3_z_b10 3_b13m_4 ///
						3_aretype_2 3_aretype_3 3_z_HI_exp_ostby 3_z_HI_edu_h /// 
						3_z_R_exp_pc 3_z_R_trend_casualty 3_z_R_youngmen 3_intercept ///
						gov		
matrix list R6_exclHIdur_logform
matrix list R6_exclHIdur_eform
matrix list R6_exclHIdur_level2var


*** 10.7 Excluding HI expenditures (Table A-VI, Model R7)

use "Full imputed dataset", clear
mi extract 0
quietly gllamm p0607d z_p42s z_inc_edu z_b29s p22_2 conf_fayyad y05 b03 z_b10 b13m_4 ///
			aretype_2 aretype_3 z_HI_ostby z_HI_edu_h ///
			z_R_exp_pc z_R_trend_casualty z_R_youngmen, ///
			i(governorate) init lin(mlogit) family(binom) base(1)
matrix a=e(b)

mi_gllamm p0607d z_p42s z_inc_edu z_b29s p22_2 conf_fayyad y05 b03 z_b10 b13m_4 ///
			aretype_2 aretype_3 z_HI_ostby z_HI_edu_h ///
			z_R_exp_pc z_R_trend_casualty z_R_youngmen, ///
			gllammoptions("i(governorate) lin(mlogit) family(binom) base(1) from(a) skip adapt") ///
			modelname("R7_exclHIexp")
			
matrix rownames R7_exclHIexp_logform = 0_z_p42s 0_z_inc_edu 0_z_b29s 0_p22_2 0_conf_fayyad 0_y05 0_b03 0_z_b10 0_b13m_4 ///
						0_aretype_2 0_aretype_3 0_z_HI_ostby 0_z_HI_edu_h ///
						0_z_R_exp_pc 0_z_R_trend_casualty 0_z_R_youngmen 0_intercept ///
						2_z_p42s 2_z_inc_edu 2_z_b29s 2_p22_2 2_conf_fayyad 2_y05 2_b03 2_z_b10 2_b13m_4 ///
						2_aretype_2 2_aretype_3 2_z_HI_ostby 2_z_HI_edu_h ///
						2_z_R_exp_pc 2_z_R_trend_casualty 2_z_R_youngmen 2_intercept ///
						3_z_p42s 3_z_inc_edu 3_z_b29s 3_p22_2 3_conf_fayyad 3_y05 3_b03 3_z_b10 3_b13m_4 ///
						3_aretype_2 3_aretype_3 3_z_HI_ostby 3_z_HI_edu_h /// 
						3_z_R_exp_pc 3_z_R_trend_casualty 3_z_R_youngmen 3_intercept ///
						gov	

matrix rownames R7_exclHIexp_eform = 0_z_p42s 0_z_inc_edu 0_z_b29s 0_p22_2 0_conf_fayyad 0_y05 0_b03 0_z_b10 0_b13m_4 ///
						0_aretype_2 0_aretype_3 0_z_HI_ostby 0_z_HI_edu_h ///
						0_z_R_exp_pc 0_z_R_trend_casualty 0_z_R_youngmen 0_intercept ///
						2_z_p42s 2_z_inc_edu 2_z_b29s 2_p22_2 2_conf_fayyad 2_y05 2_b03 2_z_b10 2_b13m_4 ///
						2_aretype_2 2_aretype_3 2_z_HI_ostby 2_z_HI_edu_h ///
						2_z_R_exp_pc 2_z_R_trend_casualty 2_z_R_youngmen 2_intercept ///
						3_z_p42s 3_z_inc_edu 3_z_b29s 3_p22_2 3_conf_fayyad 3_y05 3_b03 3_z_b10 3_b13m_4 ///
						3_aretype_2 3_aretype_3 3_z_HI_ostby 3_z_HI_edu_h /// 
						3_z_R_exp_pc 3_z_R_trend_casualty 3_z_R_youngmen 3_intercept ///
						gov		
matrix list R7_exclHIexp_logform
matrix list R7_exclHIexp_eform
matrix list R7_exclHIexp_level2var


*** 10.8 Daily wage replacing expenditures level (Table A-VI, Model R8)

use "Full imputed dataset", clear
mi extract 0
quietly gllamm p0607d z_p42s z_inc_edu z_b29s p22_2 conf_fayyad y05 b03 z_b10 b13m_4 ///
			aretype_2 aretype_3 z_HI_ostby z_HI_exp_ostby z_HI_edu_h ///
			z_R_wage z_R_trend_casualty z_R_youngmen, ///
			i(governorate) init lin(mlogit) family(binom) base(1)
matrix a=e(b)

mi_gllamm p0607d z_p42s z_inc_edu z_b29s p22_2 conf_fayyad y05 b03 z_b10 b13m_4 ///
			aretype_2 aretype_3 z_HI_ostby z_HI_exp_ostby z_HI_edu_h ///
			z_R_wage z_R_trend_casualty z_R_youngmen, ///
			gllammoptions("i(governorate) lin(mlogit) family(binom) base(1) from(a) skip adapt") ///
			modelname("R8_dailywage")
			
matrix rownames R8_dailywage_logform = 0_z_p42s 0_z_inc_edu 0_z_b29s 0_p22_2 0_conf_fayyad 0_y05 0_b03 0_z_b10 0_b13m_4 ///
						0_aretype_2 0_aretype_3 0_z_HI_ostby 0_z_HI_exp_ostby 0_z_HI_edu_h ///
						0_z_R_wage 0_z_R_trend_casualty 0_z_R_youngmen 0_intercept ///
						2_z_p42s 2_z_inc_edu 2_z_b29s 2_p22_2 2_conf_fayyad 2_y05 2_b03 2_z_b10 2_b13m_4 ///
						2_aretype_2 2_aretype_3 2_z_HI_ostby 2_z_HI_exp_ostby 2_z_HI_edu_h ///
						2_z_R_wage  2_z_R_trend_casualty 2_z_R_youngmen 2_intercept ///
						3_z_p42s 3_z_inc_edu 3_z_b29s 3_p22_2 3_conf_fayyad 3_y05 3_b03 3_z_b10 3_b13m_4 ///
						3_aretype_2 3_aretype_3 3_z_HI_ostby 3_z_HI_exp_ostby 3_z_HI_edu_h /// 
						3_z_R_wage 3_z_R_trend_casualty 3_z_R_youngmen 3_intercept ///
						gov	

matrix rownames R8_dailywage_eform = 0_z_p42s 0_z_inc_edu 0_z_b29s 0_p22_2 0_conf_fayyad 0_y05 0_b03 0_z_b10 0_b13m_4 ///
						0_aretype_2 0_aretype_3 0_z_HI_ostby 0_z_HI_exp_ostby 0_z_HI_edu_h ///
						0_z_R_wage 0_z_R_trend_casualty 0_z_R_youngmen 0_intercept ///
						2_z_p42s 2_z_inc_edu 2_z_b29s 2_p22_2 2_conf_fayyad 2_y05 2_b03 2_z_b10 2_b13m_4 ///
						2_aretype_2 2_aretype_3 2_z_HI_ostby 2_z_HI_exp_ostby 2_z_HI_edu_h ///
						2_z_R_wage  2_z_R_trend_casualty 2_z_R_youngmen 2_intercept ///
						3_z_p42s 3_z_inc_edu 3_z_b29s 3_p22_2 3_conf_fayyad 3_y05 3_b03 3_z_b10 3_b13m_4 ///
						3_aretype_2 3_aretype_3 3_z_HI_ostby 3_z_HI_exp_ostby 3_z_HI_edu_h /// 
						3_z_R_wage 3_z_R_trend_casualty 3_z_R_youngmen 3_intercept ///
						gov	
matrix list R8_dailywage_logform
matrix list R8_dailywage_eform
matrix list R8_dailywage_level2var




*----------------------------------------------------------------------------
* 11 Outliers and influential data points (Third imputed dataset)
*----------------------------------------------------------------------------

use "Third imputed dataset", clear
estimates restore baseline3

*** 11.1 Individual level (Table A-VI, Model R9)

gllapred pearson2, pearson outcome(2)
gllapred pearson1, pearson outcome(1)
gllapred pearson3, pearson outcome(3)
gllapred pearson0, pearson outcome(0)

gllapred deviance2, deviance outcome(2)
gllapred deviance1, deviance outcome(1)
gllapred deviance3, deviance outcome(3)
gllapred deviance0, deviance outcome(0)

sum  pearson2 deviance2 pearson1 deviance1 pearson3 deviance3 pearson0 deviance0
	
generate std_pear2 = pearson2/1.001977
generate std_pear1 = pearson1/.9990776
generate std_pear3 = pearson3/.9997445
generate std_pear0 = pearson0/1.003825

generate std_dev2 = deviance2/1.037809
generate std_dev1 = deviance1/1.125526
generate std_dev3 = deviance3/.9737521
generate std_dev0 = deviance0/.748534

sum std_pear2 std_pear1 std_pear3 std_pear0 std_dev2 std_dev1 std_dev3 std_dev0
corr std_pear2 std_pear1 std_pear3 std_pear0 std_dev2 std_dev1 std_dev3 std_dev0

generate outlier=0
replace outlier=1 if std_pear2>=3 | std_pear1>=3 | std_pear3>=3 | std_pear0>=3 | std_dev2>=3 | std_dev1>=3 | std_dev3>=3 | std_dev0>=3 
tab outlier

save "Third imputed dataset", replace

  * Residual plot (Figure A-3)
sort AI01
generate Respondent=_n
generate line=3
generate regression_line = 0

twoway (scatter  std_pear2 std_pear1 std_pear3 std_pear0  Respondent) (line regression_line Respondent) (line line Respondent, lpatt(shortdash))
graph save Graph "Figure A-3"

  * Excluding individual level outliers (Table A-VI, Model R9)
use "Third imputed dataset", clear

svy: mlogit p0607d z_b29s z_inc_edu z_p42s p22_2 y05 b03 z_b10 b13m_4 ///
			aretype_2 aretype_3 ib(first).governorate
matrix a=e(b)

gllamm p0607d z_b29s z_inc_edu z_p42s p22_2 conf_fayyad y05 b03 z_b10 b13m_4 ///
			aretype_2 aretype_3 z_HI_ostby z_HI_exp_ostby z_HI_edu_h ///
			z_R_exp_pc z_R_trend_casualty z_R_youngmen ///
			if outlier==0 ///
			, i(governorate) lin(mlogit) family(binom) base(1) from(a) skip adapt
gllamm, eform
matrix a=e(b)
estimates store excl_indiv_outliers



*** 11.2 Governorate level (Table A-VI, Model R10)

  * Defining program to calculate governorate level residuals and DfBetas

program define res_level2_gllamm
	version 13
	syntax varlist, GLLAMMOPtions(string) MODELname(string) /*make modelname brief*/

	quietly gllamm `varlist', `gllammoptions' 
	estimates store `modelname'_baseline

	quietly gllapred res_`modelname'_, u   /*Raw residuals returned as res_m1*/
	quietly gllapred stres_`modelname'_, ustd /*Standardized residuals returned as stres_m1*/

	matrix b_base = e(b)
	matrix V_base = e(V)
	matrix vd_base = vecdiag(V_base)   /*Row vector from diagonal of V*/

	foreach gov in 1 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 {
		display _newline "." 
		
		quietly gllamm `varlist' if governorate~=`gov', `gllammoptions'
		estimates store `modelname'_nogov`gov'
		
		quietly gllapred dres_gov`gov'_`modelname' if governorate==`gov', u fsample
		quietly gllapred dstres_gov`gov'_`modelname' if governorate==`gov', ustd fsample
		
		matrix b_gov`gov' = e(b)
		}
		
	*Combining deletion residuals into one variable
	generate dres_`modelname' = 0
	label variable dres_`modelname' "Deletion residuals, governorate level"
	foreach gov in 1 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 {
		replace dres_`modelname' = dres_gov`gov'_`modelname'm1 if governorate==`gov'
		}

	*Combining standardized deletion residuals into one variable
	generate dstres_`modelname' = 0
	label variable dstres_`modelname' "Standardized deletion residuals, governorate level"
	foreach gov in 1 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 {
		replace dstres_`modelname' = dstres_gov`gov'_`modelname'm1 if governorate==`gov'
		}

	save "Third imputed dataset", replace
	
	keep p0607d governorate AI01 ///
		res_`modelname'_m1 stres_`modelname'_m1 ///
		dres_`modelname' dstres_`modelname' 
	reshape wide p0607d, i(governorate) j(AI01)
	sort governorate
	list governorate res_`modelname'_m1 stres_`modelname'_m1 dres_`modelname' dstres_`modelname'

	save "Governorate level outliers"

	use "Third imputed dataset", clear

	mata: dfbeta()

	matrix dfbetas =(dfbeta_gov1, dfbeta_gov5, dfbeta_gov10, dfbeta_gov15, ///
					dfbeta_gov20, dfbeta_gov25, dfbeta_gov30, dfbeta_gov35, ///
					dfbeta_gov40, dfbeta_gov45, dfbeta_gov50, dfbeta_gov55, ///
					dfbeta_gov60, dfbeta_gov65, dfbeta_gov70, dfbeta_gov75)
	matrix colnames dfbetas = gov1 gov5 gov10 gov15 gov20 gov25 gov30 gov35 gov40 gov45 gov50 gov55 gov60 gov65 gov70 gov75 
	mat list dfbetas

end


version 13
mata:
void dfbeta()
{
	b_base = st_matrix("b_base")'
	vd_base = st_matrix("vd_base")'
	se_base = sqrt(vd_base)
	
	b_gov1 = st_matrix("b_gov1")'
	b_gov5 = st_matrix("b_gov5")'
	b_gov10 = st_matrix("b_gov10")'
	b_gov15 = st_matrix("b_gov15")'
	b_gov20 = st_matrix("b_gov20")'
	b_gov25 = st_matrix("b_gov25")'
	b_gov30 = st_matrix("b_gov30")'
	b_gov35 = st_matrix("b_gov35")'
	b_gov40 = st_matrix("b_gov40")'
	b_gov45 = st_matrix("b_gov45")'
	b_gov50 = st_matrix("b_gov50")'
	b_gov55 = st_matrix("b_gov55")'
	b_gov60 = st_matrix("b_gov60")'
	b_gov65 = st_matrix("b_gov65")'
	b_gov70 = st_matrix("b_gov70")'
	b_gov75 = st_matrix("b_gov75")'

	dfbeta_gov1 = ((b_base - b_gov1) :/ se_base)
	dfbeta_gov5 = ((b_base - b_gov5) :/ se_base)
	dfbeta_gov10 = ((b_base - b_gov10) :/ se_base)
	dfbeta_gov15 = ((b_base - b_gov15) :/ se_base)
	dfbeta_gov20 = ((b_base - b_gov20) :/ se_base)
	dfbeta_gov25 = ((b_base - b_gov25) :/ se_base)
	dfbeta_gov30 = ((b_base - b_gov30) :/ se_base)
	dfbeta_gov35 = ((b_base - b_gov35) :/ se_base)
	dfbeta_gov40 = ((b_base - b_gov40) :/ se_base)
	dfbeta_gov45 = ((b_base - b_gov45) :/ se_base)
	dfbeta_gov50 = ((b_base - b_gov50) :/ se_base)
	dfbeta_gov55 = ((b_base - b_gov55) :/ se_base)
	dfbeta_gov60 = ((b_base - b_gov60) :/ se_base)
	dfbeta_gov65 = ((b_base - b_gov65) :/ se_base)
	dfbeta_gov70 = ((b_base - b_gov70) :/ se_base)
	dfbeta_gov75 = ((b_base - b_gov75) :/ se_base)
	
	st_matrix("se_base", se_base)
	st_matrix("dfbeta_gov1", dfbeta_gov1)
	st_matrix("dfbeta_gov5", dfbeta_gov5)
	st_matrix("dfbeta_gov10", dfbeta_gov10)
	st_matrix("dfbeta_gov15", dfbeta_gov15)
	st_matrix("dfbeta_gov20", dfbeta_gov20)
	st_matrix("dfbeta_gov25", dfbeta_gov25)
	st_matrix("dfbeta_gov30", dfbeta_gov30)
	st_matrix("dfbeta_gov35", dfbeta_gov35)
	st_matrix("dfbeta_gov40", dfbeta_gov40)
	st_matrix("dfbeta_gov45", dfbeta_gov45)
	st_matrix("dfbeta_gov50", dfbeta_gov50)
	st_matrix("dfbeta_gov55", dfbeta_gov55)
	st_matrix("dfbeta_gov60", dfbeta_gov60)
	st_matrix("dfbeta_gov65", dfbeta_gov65)
	st_matrix("dfbeta_gov70", dfbeta_gov70)
	st_matrix("dfbeta_gov75", dfbeta_gov75)
}	
end

  * Running program
use "Third imputed dataset", clear

quietly gllamm p0607d z_b29s z_inc_edu z_p42s p22_2 y05 b03 z_b10 b13m_4 ///
			aretype_2 aretype_3 z_HI_ostby z_HI_exp_ostby z_HI_edu_h ///
			z_R_exp_pc z_R_trend_casualty z_R_youngmen, ///
			i(governorate) init lin(mlogit) family(binom) base(1)
matrix a=e(b)                  

res_level2_gllamm p0607d z_b29s z_inc_edu z_p42s p22_2 conf_fayyad y05 b03 z_b10 b13m_4 ///
			aretype_2 aretype_3 z_HI_ostby z_HI_exp_ostby z_HI_edu_h ///
			z_R_exp_pc z_R_trend_casualty z_R_youngmen, ///
			gllammoptions("i(governorate) lin(mlogit) family(binom) base(1) from(a) skip adapt") ///
			modelname("outliers")
			
matrix rownames dfbetas = 0_z_b29s 0_z_inc_edu 0_z_p42s 0_p22_2 0_conf_fayyad 0_y05 0_b03 0_z_b10 0_b13m_4 ///
						0_aretype_2 0_aretype_3 0_z_HI_ostby 0_z_HI_exp_ostby 0_z_HI_edu_h ///
						0_z_R_exp_pc 0_z_R_trend_casualty 0_z_R_youngmen 0_intercept ///
						2_z_b29s 2_z_inc_edu 2_z_p42s 2_p22_2 2_conf_fayyad 2_y05 2_b03 2_z_b10 2_b13m_4 ///
						2_aretype_2 2_aretype_3 2_z_HI_ostby 2_z_HI_exp_ostby 2_z_HI_edu_h ///
						2_z_R_exp_pc 2_z_R_trend_casualty 2_z_R_youngmen 2_intercept ///
						3_z_b29s 3_z_inc_edu 3_z_p42s 3_p22_2 3_conf_fayyad 3_y05 3_b03 3_z_b10 3_b13m_4 ///
						3_aretype_2 3_aretype_3 3_z_HI_ostby 3_z_HI_exp_ostby 3_z_HI_edu_h /// 
						3_z_R_exp_pc 3_z_R_trend_casualty 3_z_R_youngmen 3_intercept ///
						gov	
matrix list dfbetas

save "Third imputed dataset", replace


  * Excluding governorate outliers (Jericho, Ramallah and Jerusalem) (Table A-VI, Model R10)
use "Third imputed imputed dataset", clear

gllamm p0607d z_b29s z_inc_edu z_p42s p22_2 conf_fayyad y05 b03 z_b10 b13m_4 ///
			aretype_2 aretype_3 z_HI_ostby z_HI_exp_ostby z_HI_edu_h ///
			z_R_exp_pc z_R_trend_casualty z_R_youngmen ///
			if governorate~=30 & governorate~=35 & governorate~=40 ///
			, i(governorate) lin(mlogit) family(binom) base(1) from(a) skip adapt
gllamm, eform
matrix a=e(b)
estimates store excl_gov_outliers



*** 10.3 Unimputed model (Table A-VI, Model R11)

use "Full imputed dataset", clear
mi extract 0

quietly gllamm p0607d z_p42s z_inc_edu z_b29s p22_2 y05 b03 z_b10 b13m_4 ///
			aretype_2 aretype_3 z_HI_ostby z_HI_exp_ostby z_HI_edu_h ///
			z_R_exp_pc z_R_trend_casualty z_R_youngmen, ///
			i(governorate) init lin(mlogit) family(binom) base(1)
matrix a=e(b)

gllamm p0607d z_p42s z_inc_edu z_b29s p22_2 conf_fayyad y05 b03 z_b10 b13m_4 ///
			aretype_2 aretype_3 z_HI_ostby z_HI_exp_ostby z_HI_edu_h ///
			z_R_exp_pc z_R_trend_casualty z_R_youngmen, ///
			i(governorate) lin(mlogit) family(binom) base(1) from(a) skip adapt ///
			eform
estimates store unimputed

*** Re-opening full imputed dataset			
use "Full imputed dataset", clear



*----------------------------------------------------------------------------
* 12 List of main results stored as matrixes and estimates 
*----------------------------------------------------------------------------

	* Matrixes can be viewed with 'mat list' command and estimates with 
	* 'estimate restore'

	
*** 12.1 Matrixes 

  * baseline_logform / baseline_eform / baseline_level2var
  * random_intercept_logform / random_intercept_eform / random_intercept_level2var
  * R1_binominal_logform / R1_binominal_eform / R1_binominal_level2var
  * R2_gazadummy_logform / R2_gazadummy_eform / R2_gazadummy_level2var
  * R3_violence_logform / R3_violence_eform / R4_violence3_level2var
  * R4_violence_logform / R4_violence_eform / R4_violence_level2var
  * R5_violence_logform / R5_violence_eform / R5_violence_level2var
  * R6_exclHIdur_logform / R6_exclHIdur_eform / R6_exclHIdur_level2var
  * R7_exclHIexp_logform / R7_exclHIexp_eform / R7_exclHIexp_level2var
  * R8_dailywage_logform / R8_dailywage_eform / R8_dailywage_level2var
  * dfbetas


*** 12.2 Estimates 

  * baseline3  			(baseline model in third imputed dataset)
  * excl_indiv_outliers	(R9, excluding individual level outliers)
  * excl_gov_outliers	(R10, excluding governorate level outliers)
  * unimputed			(R11, main model in unimputed dataset)
