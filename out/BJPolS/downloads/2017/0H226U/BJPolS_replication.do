* Data replication BJPolS, June 2017
clear all 
set more off
set matsize 11000, perm
set maxvar 30000, perm
set more off, perm
cd "C:\Users\oloro\Documents\RD voting eligibility\Data"

***************************** WORK WITH THE FILE THAT CONTAINS EXACT DATE OF BIRTH FOR ALL INDIVIDUALS BORN IN SWEDEN 1969-*****************************************
use "raw\Historiskafbr_2009", clear 
keep if fodd==1 /* keep if the observation is concerned with a birth*/
drop fodd
capture rename dnr2014115 Person_ID
capture rename datfran Birth_Date 
bysort Person_ID: keep if _n==1  /*keep one observation per individual*/
gen YearOfBirth=substr(Birth_Date,1,4) /* runs from 1969-2009*/
capture destring YearOfBirth, replace
gen MonthOfBirth=substr(Birth_Date,5,2)
capture destring MonthOfBirth, replace
gen DayOfBirth=substr(Birth_Date,7,2)
capture destring DayOfBirth, replace
gen NumericalBirthDateValue=mdy(MonthOfBirth, DayOfBirth, YearOfBirth)
gen DayOfTheWeekBirth=dow(NumericalBirthDateValue)
 

gen Keep=0
replace Keep=1 if NumericalBirthDateValue>=3866 & NumericalBirthDateValue<=3961 /* 08/02/1970 to 11/05/1970 */  
replace Keep=1 if NumericalBirthDateValue>=4959 & NumericalBirthDateValue<=5054 /* 07/30/1973 to 11/02/1973 */
replace Keep=1 if NumericalBirthDateValue>=6114 & NumericalBirthDateValue<=6209 /* 09/27/1976 to 12/31/1976 */
replace Keep=1 if NumericalBirthDateValue>=7521 & NumericalBirthDateValue<=7616 /* 08/04/1980 to 11/07/1980 */
replace Keep=1 if NumericalBirthDateValue>=8977 & NumericalBirthDateValue<=9072 /* 07/30/1984 to 11/02/1984 */
replace Keep=1 if NumericalBirthDateValue>=9341 & NumericalBirthDateValue<=9436 /* 07/29/1985 to 11/01/1985 */
replace Keep=1 if NumericalBirthDateValue>=10440 & NumericalBirthDateValue<=10535 /* 08/01/1988 to 11/04/1988 */

keep if Keep==1
drop Keep

gen Voting_Right=0
replace Voting_Right=1 if NumericalBirthDateValue>=3866 & NumericalBirthDateValue<=3913 /* 08/02/1970 to 09/18/1970 */  
replace Voting_Right=1 if NumericalBirthDateValue>=4959 & NumericalBirthDateValue<=5006 /* 07/30/1973 to 09/15/1973 */
replace Voting_Right=1 if NumericalBirthDateValue>=6114 & NumericalBirthDateValue<=6161 /* 09/27/1976 to 11/13/1976 */
replace Voting_Right=1 if NumericalBirthDateValue>=7521 & NumericalBirthDateValue<=7568 /* 08/04/1980 to 09/20/1980 */
replace Voting_Right=1 if NumericalBirthDateValue>=8977 & NumericalBirthDateValue<=9024 /* 07/30/1984 to 09/15/1984 */
replace Voting_Right=1 if NumericalBirthDateValue>=9341 & NumericalBirthDateValue<=9388 /* 07/29/1985 to 09/14/1985 */
replace Voting_Right=1 if NumericalBirthDateValue>=10440 & NumericalBirthDateValue<=10487 /* 08/01/1988 to 09/17/1988 */


keep Person_ID YearOfBirth MonthOfBirth DayOfBirth NumericalBirthDateValue DayOfTheWeekBirth Voting_Right 
order Person_ID YearOfBirth MonthOfBirth DayOfBirth NumericalBirthDateValue DayOfTheWeekBirth Voting_Right
save "temp\BJPolS_MainBirthFile", replace

* Now, we have a clean dataset with personal identifers and complete birth date information for all individuals born in the relevant time periods (see Table 2 in the paper)
* To this baseline dataset we will add information on gender, parental characteristics, grades and all other relevant variables
********************************************************************************************************************************************************************


****************CLEAN FILES WITH INFORMATION ON PARENTS IN 1990**************************************

* Clean Fob1990 parents
use "raw\Fob1990foraldra", clear
keep dnr2014115 syss_far syss_mor sun5_far sun5_mor 
capture rename dnr2014115 Person_ID
capture rename syss_far Employment_Father
capture rename syss_mor Employment_Mother
capture rename sun5_far Education_Father 
capture rename sun5_mor Education_Mother 
bysort Person_ID: keep if _n==1
save "temp\BJPolS_Fob1990foraldra", replace
***********

**********************************************************************************************



****************CLEAN FILES WITH INFORMATION ON MULTIGENERATIONAL LINKS, PERSONAL IDENTIFIERS FOR CHILDREN AND PARENTS****************************
* Clean Flergen 2009
use "raw\Flergen_2009", clear
keep dnr2014115 dnr2014115m dnr2014115f 
capture rename dnr2014115 Person_ID 
capture rename dnr2014115m Person_ID_Mother
capture rename dnr2014115f Person_ID_Father
bysort Person_ID: keep if _n==1
save "temp\BJPolS_Flergen_2009", replace
***********

**********************************************************************************************




****************CLEAN LOUISE FILES************************************************************

* Clean Louise files
forvalues I=1990(1)2009{
	use "raw\Louisegeo`I'",clear
	capture keep dnr2014115 kon sun2000niva syssstat syssstatj hutbsun 
	capture rename dnr2014115 Person_ID
	bysort Person_ID: keep if _n==1
	capture rename kon Gender
	capture rename sun2000niva Education_Level_Newcode 
	capture rename syssstat Employment_Status 
	capture rename syssstatj Employment_Status_j
	capture rename hutbsun Education_Level_Oldcode  
	
	
	capture tostring Gender, replace
	capture tostring Education_Level_Newcode, replace
	
	save "use\BJPolS_Louisegeo`I'",replace 
}

*
**********************************************************************************************


* USE THE MAIN BIRTH FILE AND ADD GENDER FROM LOUISE************************************************ 
set more off
* The individuals in the main birth file must appear in Louise at some point between 1990-2009

forvalues I=1990(1)2009{
use "temp\BJPolS_MainBirthFile", clear
merge 1:1 Person_ID using "use\BJPolS_Louisegeo`I'", keep(match) keepusing(Gender)
drop _merge
*Save
		if `I'!=1990{
			append using "temp\BJPolS_MainBirthFileLouise"
			} 
		save "temp\BJPolS_MainBirthFileLouise", replace
}
*
use "temp\BJPolS_MainBirthFileLouise", clear
bysort Person_ID: keep if _n==1 
keep if Gender=="1" | Gender=="2" /* gender must be known*/
gen Male=(Gender=="1")
keep Person_ID YearOfBirth MonthOfBirth DayOfBirth NumericalBirthDateValue DayOfTheWeekBirth Voting_Right Male 
order Person_ID YearOfBirth MonthOfBirth DayOfBirth NumericalBirthDateValue DayOfTheWeekBirth Voting_Right Male 
save "temp\BJPolS_MainBirthFileGender", replace 
**************************************************************************************************


**************************** ADD INFORMATION ON PERSONAL IDENTIFIERS FOR PARENTS*************************************************************
* The individuals in the main birth file must appear in the multigenerational register to be part of the study
set more off
use "temp\BJPolS_MainBirthFileGender", clear 
merge 1:1 Person_ID using "temp\BJPolS_Flergen_2009", keep(match) keepusing(Person_ID_Mother Person_ID_Father) 
drop _merge
keep Person_ID YearOfBirth MonthOfBirth DayOfBirth NumericalBirthDateValue DayOfTheWeekBirth Voting_Right Male Person_ID_Mother Person_ID_Father 
order Person_ID YearOfBirth MonthOfBirth DayOfBirth NumericalBirthDateValue DayOfTheWeekBirth Voting_Right Male Person_ID_Mother Person_ID_Father 
save "temp\BJPolS_MainBirthFileGender2", replace
********************************************************************************************************************************************




****************************************GENERATE AGE AT FIRST MAJOR VOTING OPPORTUNITY************************************************************
use "temp\BJPolS_MainBirthFileGender2", clear

gen AgeAtFirst=.
* Born in 1970 and voting right==1

replace AgeAtFirst=(10488-NumericalBirthDateValue)/365 if YearOfBirth==1970 & Voting_Right==1 /* the first election is:    SP election	09/18/1988  */   

* Born in 1970 and voting right==0

replace AgeAtFirst=(11580-NumericalBirthDateValue)/365 if YearOfBirth==1970 & Voting_Right==0 /* the first election is:    SP election 	09/15/1991  */

* Born in 1973 and voting right==1

replace AgeAtFirst=(11580-NumericalBirthDateValue)/365 if YearOfBirth==1973 & Voting_Right==1 /* the first election is:    SP election 	09/15/1991  */

* Born in 1973 and voting right==0

replace AgeAtFirst=(12679-NumericalBirthDateValue)/365 if YearOfBirth==1973 & Voting_Right==0 /* the first election is:    SP election	09/18/1994  */

* Born in 1976 and voting right==1

replace AgeAtFirst=(12735-NumericalBirthDateValue)/365 if YearOfBirth==1976 & Voting_Right==1 /* the first election is:  Referendum 	11/13/1994    */

* Born in 1976 and voting right==0

replace AgeAtFirst=(14142-NumericalBirthDateValue)/365 if YearOfBirth==1976 & Voting_Right==0 /* the first election is:  SP election	09/20/1998    */

* Born in 1980 and voting right==1

replace AgeAtFirst=(14142-NumericalBirthDateValue)/365 if YearOfBirth==1980 & Voting_Right==1 /* the first election is:  SP election	09/20/1998    */

* Born in 1980 and voting right==0

replace AgeAtFirst=(15598-NumericalBirthDateValue)/365 if YearOfBirth==1980 & Voting_Right==0 /* the first election is:  SP election	09/15/2002    */

* Born in 1984 and voting right==1

replace AgeAtFirst=(15598-NumericalBirthDateValue)/365 if YearOfBirth==1984 & Voting_Right==1 /* the first election is:  SP election	09/15/2002    */

* Born in 1984 and voting right==0

replace AgeAtFirst=(15962-NumericalBirthDateValue)/365 if YearOfBirth==1984 & Voting_Right==0 /* the first election is:  Referendum 	09/14/2003    */

* Born in 1985 and voting right==1

replace AgeAtFirst=(15962-NumericalBirthDateValue)/365 if YearOfBirth==1985 & Voting_Right==1 /* the first election is:  Referendum 	09/14/2003    */

* Born in 1985 and voting right==0

replace AgeAtFirst=(17061-NumericalBirthDateValue)/365 if YearOfBirth==1985 & Voting_Right==0 /* the first election is:  SP election	09/17/2006    */

* Born in 1988 and voting right==1

replace AgeAtFirst=(17061-NumericalBirthDateValue)/365 if YearOfBirth==1988 & Voting_Right==1 /* the first election is:  SP election	09/17/2006    */

* Born in 1988 and voting right==0

replace AgeAtFirst=(18524-NumericalBirthDateValue)/365 if YearOfBirth==1988 & Voting_Right==0 /* the first election is:  SP election	09/19/2010 */




save "temp\BJPolS_MainBirthFileGender3", replace


***************** CLEANING General Knowledge section of the Swedish Scholastic Assessment Test (SweSAT)*******************************************
* The section was in the test between 1977-1995. The test was given twice a year (1=Spring, 2=Fall)

* 1977:1
use "raw\Hspresultat7795", clear
capture rename dnr2014115 Person_ID
keep if provar==77
keep if provtillfalle==1
keep Person_ID ao provar provtillfalle
rename ao General_Knowledge
rename provar YearOfTest
rename provtillfalle TimingOfTest
keep if General_Knowledge>=0 & General_Knowledge<=30 
egen StandGeneral_Knowledge=std(General_Knowledge)
bysort Person_ID: keep if _n==1
order Person_ID YearOfTest TimingOfTest General_Knowledge StandGeneral_Knowledge
save "use\BJPolS_UniTest_1977_1", replace    

* 1977:2
use "raw\Hspresultat7795", clear
capture rename dnr2014115 Person_ID
keep if provar==77
keep if provtillfalle==2
keep Person_ID ao provar provtillfalle
rename ao General_Knowledge
rename provar YearOfTest
rename provtillfalle TimingOfTest
keep if General_Knowledge>=0 & General_Knowledge<=30 
egen StandGeneral_Knowledge=std(General_Knowledge)
bysort Person_ID: keep if _n==1
order Person_ID YearOfTest TimingOfTest General_Knowledge StandGeneral_Knowledge
save "use\BJPolS_UniTest_1977_2", replace    

* 1978:1
use "raw\Hspresultat7795", clear
capture rename dnr2014115 Person_ID
keep if provar==78
keep if provtillfalle==1
keep Person_ID ao provar provtillfalle
rename ao General_Knowledge
rename provar YearOfTest
rename provtillfalle TimingOfTest
keep if General_Knowledge>=0 & General_Knowledge<=30 
egen StandGeneral_Knowledge=std(General_Knowledge)
bysort Person_ID: keep if _n==1
order Person_ID YearOfTest TimingOfTest General_Knowledge StandGeneral_Knowledge
save "use\BJPolS_UniTest_1978_1", replace    

* 1978:2
use "raw\Hspresultat7795", clear
capture rename dnr2014115 Person_ID
keep if provar==78
keep if provtillfalle==2
keep Person_ID ao provar provtillfalle
rename ao General_Knowledge
rename provar YearOfTest
rename provtillfalle TimingOfTest
keep if General_Knowledge>=0 & General_Knowledge<=30 
egen StandGeneral_Knowledge=std(General_Knowledge)
bysort Person_ID: keep if _n==1
order Person_ID YearOfTest TimingOfTest General_Knowledge StandGeneral_Knowledge
save "use\BJPolS_UniTest_1978_2", replace    

* 1979:1
use "raw\Hspresultat7795", clear
capture rename dnr2014115 Person_ID
keep if provar==79
keep if provtillfalle==1
keep Person_ID ao provar provtillfalle
rename ao General_Knowledge
rename provar YearOfTest
rename provtillfalle TimingOfTest
keep if General_Knowledge>=0 & General_Knowledge<=30 
egen StandGeneral_Knowledge=std(General_Knowledge)
bysort Person_ID: keep if _n==1
order Person_ID YearOfTest TimingOfTest General_Knowledge StandGeneral_Knowledge
save "use\BJPolS_UniTest_1979_1", replace    

* 1979:2
use "raw\Hspresultat7795", clear
capture rename dnr2014115 Person_ID
keep if provar==79
keep if provtillfalle==2
keep Person_ID ao provar provtillfalle
rename ao General_Knowledge
rename provar YearOfTest
rename provtillfalle TimingOfTest
keep if General_Knowledge>=0 & General_Knowledge<=30 
egen StandGeneral_Knowledge=std(General_Knowledge)
bysort Person_ID: keep if _n==1
order Person_ID YearOfTest TimingOfTest General_Knowledge StandGeneral_Knowledge
save "use\BJPolS_UniTest_1979_2", replace    

* 1980:1
use "raw\Hspresultat7795", clear
capture rename dnr2014115 Person_ID
keep if provar==79
keep if provtillfalle==2
keep Person_ID ao provar provtillfalle
rename ao General_Knowledge
rename provar YearOfTest
rename provtillfalle TimingOfTest
keep if General_Knowledge>=0 & General_Knowledge<=30 
egen StandGeneral_Knowledge=std(General_Knowledge)
bysort Person_ID: keep if _n==1
order Person_ID YearOfTest TimingOfTest General_Knowledge StandGeneral_Knowledge
save "use\BJPolS_UniTest_1980_1", replace    

* 1980:2
use "raw\Hspresultat7795", clear
capture rename dnr2014115 Person_ID
keep if provar==80
keep if provtillfalle==2
keep Person_ID ao provar provtillfalle
rename ao General_Knowledge
rename provar YearOfTest
rename provtillfalle TimingOfTest
keep if General_Knowledge>=0 & General_Knowledge<=30 
egen StandGeneral_Knowledge=std(General_Knowledge)
bysort Person_ID: keep if _n==1
order Person_ID YearOfTest TimingOfTest General_Knowledge StandGeneral_Knowledge
save "use\BJPolS_UniTest_1980_2", replace    

* 1981:1
use "raw\Hspresultat7795", clear
capture rename dnr2014115 Person_ID
keep if provar==81
keep if provtillfalle==1
keep Person_ID ao provar provtillfalle
rename ao General_Knowledge
rename provar YearOfTest
rename provtillfalle TimingOfTest
keep if General_Knowledge>=0 & General_Knowledge<=30 
egen StandGeneral_Knowledge=std(General_Knowledge)
bysort Person_ID: keep if _n==1
order Person_ID YearOfTest TimingOfTest General_Knowledge StandGeneral_Knowledge
save "use\BJPolS_UniTest_1981_1", replace    

* 1981:2
use "raw\Hspresultat7795", clear
capture rename dnr2014115 Person_ID
keep if provar==81
keep if provtillfalle==2
keep Person_ID ao provar provtillfalle
rename ao General_Knowledge
rename provar YearOfTest
rename provtillfalle TimingOfTest
keep if General_Knowledge>=0 & General_Knowledge<=30 
egen StandGeneral_Knowledge=std(General_Knowledge)
bysort Person_ID: keep if _n==1
order Person_ID YearOfTest TimingOfTest General_Knowledge StandGeneral_Knowledge
save "use\BJPolS_UniTest_1981_2", replace    

* 1982:1
use "raw\Hspresultat7795", clear
capture rename dnr2014115 Person_ID
keep if provar==82
keep if provtillfalle==1
keep Person_ID ao provar provtillfalle
rename ao General_Knowledge
rename provar YearOfTest
rename provtillfalle TimingOfTest
keep if General_Knowledge>=0 & General_Knowledge<=30 
egen StandGeneral_Knowledge=std(General_Knowledge)
bysort Person_ID: keep if _n==1
order Person_ID YearOfTest TimingOfTest General_Knowledge StandGeneral_Knowledge
save "use\BJPolS_UniTest_1982_1", replace    

* 1982:2
use "raw\Hspresultat7795", clear
capture rename dnr2014115 Person_ID
keep if provar==82
keep if provtillfalle==2
keep Person_ID ao provar provtillfalle
rename ao General_Knowledge
rename provar YearOfTest
rename provtillfalle TimingOfTest
keep if General_Knowledge>=0 & General_Knowledge<=30 
egen StandGeneral_Knowledge=std(General_Knowledge)
bysort Person_ID: keep if _n==1
order Person_ID YearOfTest TimingOfTest General_Knowledge StandGeneral_Knowledge
save "use\BJPolS_UniTest_1982_2", replace    

* 1983:1
use "raw\Hspresultat7795", clear
capture rename dnr2014115 Person_ID
keep if provar==83
keep if provtillfalle==1
keep Person_ID ao provar provtillfalle
rename ao General_Knowledge
rename provar YearOfTest
rename provtillfalle TimingOfTest
keep if General_Knowledge>=0 & General_Knowledge<=30 
egen StandGeneral_Knowledge=std(General_Knowledge)
bysort Person_ID: keep if _n==1
order Person_ID YearOfTest TimingOfTest General_Knowledge StandGeneral_Knowledge
save "use\BJPolS_UniTest_1983_1", replace    

* 1983:2
use "raw\Hspresultat7795", clear
capture rename dnr2014115 Person_ID
keep if provar==83
keep if provtillfalle==2
keep Person_ID ao provar provtillfalle
rename ao General_Knowledge
rename provar YearOfTest
rename provtillfalle TimingOfTest
keep if General_Knowledge>=0 & General_Knowledge<=30 
egen StandGeneral_Knowledge=std(General_Knowledge)
bysort Person_ID: keep if _n==1
order Person_ID YearOfTest TimingOfTest General_Knowledge StandGeneral_Knowledge
save "use\BJPolS_UniTest_1983_2", replace 

* 1984:1
use "raw\Hspresultat7795", clear
capture rename dnr2014115 Person_ID
keep if provar==84
keep if provtillfalle==1
keep Person_ID ao provar provtillfalle
rename ao General_Knowledge
rename provar YearOfTest
rename provtillfalle TimingOfTest
keep if General_Knowledge>=0 & General_Knowledge<=30 
egen StandGeneral_Knowledge=std(General_Knowledge)
bysort Person_ID: keep if _n==1
order Person_ID YearOfTest TimingOfTest General_Knowledge StandGeneral_Knowledge
save "use\BJPolS_UniTest_1984_1", replace       

* 1984:2
use "raw\Hspresultat7795", clear
capture rename dnr2014115 Person_ID
keep if provar==84
keep if provtillfalle==2
keep Person_ID ao provar provtillfalle
rename ao General_Knowledge
rename provar YearOfTest
rename provtillfalle TimingOfTest
keep if General_Knowledge>=0 & General_Knowledge<=30 
egen StandGeneral_Knowledge=std(General_Knowledge)
bysort Person_ID: keep if _n==1
order Person_ID YearOfTest TimingOfTest General_Knowledge StandGeneral_Knowledge
save "use\BJPolS_UniTest_1984_2", replace    

* 1985:1
use "raw\Hspresultat7795", clear
capture rename dnr2014115 Person_ID
keep if provar==85
keep if provtillfalle==1
keep Person_ID ao provar provtillfalle
rename ao General_Knowledge
rename provar YearOfTest
rename provtillfalle TimingOfTest
keep if General_Knowledge>=0 & General_Knowledge<=30 
egen StandGeneral_Knowledge=std(General_Knowledge)
bysort Person_ID: keep if _n==1
order Person_ID YearOfTest TimingOfTest General_Knowledge StandGeneral_Knowledge
save "use\BJPolS_UniTest_1985_1", replace    

* 1985:2
use "raw\Hspresultat7795", clear
capture rename dnr2014115 Person_ID
keep if provar==85
keep if provtillfalle==2
keep Person_ID ao provar provtillfalle
rename ao General_Knowledge
rename provar YearOfTest
rename provtillfalle TimingOfTest
keep if General_Knowledge>=0 & General_Knowledge<=30 
egen StandGeneral_Knowledge=std(General_Knowledge)
bysort Person_ID: keep if _n==1
order Person_ID YearOfTest TimingOfTest General_Knowledge StandGeneral_Knowledge
save "use\BJPolS_UniTest_1985_2", replace   

* 1986:1
use "raw\Hspresultat7795", clear
capture rename dnr2014115 Person_ID
keep if provar==86
keep if provtillfalle==1
keep Person_ID ao provar provtillfalle
rename ao General_Knowledge
rename provar YearOfTest
rename provtillfalle TimingOfTest
keep if General_Knowledge>=0 & General_Knowledge<=30 
egen StandGeneral_Knowledge=std(General_Knowledge)
bysort Person_ID: keep if _n==1
order Person_ID YearOfTest TimingOfTest General_Knowledge StandGeneral_Knowledge
save "use\BJPolS_UniTest_1986_1", replace     

* 1986:2
use "raw\Hspresultat7795", clear
capture rename dnr2014115 Person_ID
keep if provar==86
keep if provtillfalle==2
keep Person_ID ao provar provtillfalle
rename ao General_Knowledge
rename provar YearOfTest
rename provtillfalle TimingOfTest
keep if General_Knowledge>=0 & General_Knowledge<=30 
egen StandGeneral_Knowledge=std(General_Knowledge)
bysort Person_ID: keep if _n==1
order Person_ID YearOfTest TimingOfTest General_Knowledge StandGeneral_Knowledge
save "use\BJPolS_UniTest_1986_2", replace  

* 1987:1
use "raw\Hspresultat7795", clear
capture rename dnr2014115 Person_ID
keep if provar==87
keep if provtillfalle==1
keep Person_ID ao provar provtillfalle
rename ao General_Knowledge
rename provar YearOfTest
rename provtillfalle TimingOfTest
keep if General_Knowledge>=0 & General_Knowledge<=30 
egen StandGeneral_Knowledge=std(General_Knowledge)
bysort Person_ID: keep if _n==1
order Person_ID YearOfTest TimingOfTest General_Knowledge StandGeneral_Knowledge
save "use\BJPolS_UniTest_1987_1", replace      

* 1987:2
use "raw\Hspresultat7795", clear
capture rename dnr2014115 Person_ID
keep if provar==87
keep if provtillfalle==2
keep Person_ID ao provar provtillfalle
rename ao General_Knowledge
rename provar YearOfTest
rename provtillfalle TimingOfTest
keep if General_Knowledge>=0 & General_Knowledge<=30 
egen StandGeneral_Knowledge=std(General_Knowledge)
bysort Person_ID: keep if _n==1
order Person_ID YearOfTest TimingOfTest General_Knowledge StandGeneral_Knowledge
save "use\BJPolS_UniTest_1987_2", replace    

* 1988:1
use "raw\Hspresultat7795", clear
capture rename dnr2014115 Person_ID
keep if provar==88
keep if provtillfalle==1
keep Person_ID ao provar provtillfalle
rename ao General_Knowledge
rename provar YearOfTest
rename provtillfalle TimingOfTest
keep if General_Knowledge>=0 & General_Knowledge<=30 
egen StandGeneral_Knowledge=std(General_Knowledge)
bysort Person_ID: keep if _n==1
order Person_ID YearOfTest TimingOfTest General_Knowledge StandGeneral_Knowledge
save "use\BJPolS_UniTest_1988_1", replace    

* 1988:2
use "raw\Hspresultat7795", clear
capture rename dnr2014115 Person_ID
keep if provar==88
keep if provtillfalle==2
keep Person_ID ao provar provtillfalle
rename ao General_Knowledge
rename provar YearOfTest
rename provtillfalle TimingOfTest
keep if General_Knowledge>=0 & General_Knowledge<=30 
egen StandGeneral_Knowledge=std(General_Knowledge)
bysort Person_ID: keep if _n==1
order Person_ID YearOfTest TimingOfTest General_Knowledge StandGeneral_Knowledge
save "use\BJPolS_UniTest_1988_2", replace   

* 1989:1
use "raw\Hspresultat7795", clear
capture rename dnr2014115 Person_ID
keep if provar==89
keep if provtillfalle==1
keep Person_ID ao provar provtillfalle
rename ao General_Knowledge
rename provar YearOfTest
rename provtillfalle TimingOfTest
keep if General_Knowledge>=0 & General_Knowledge<=30 
egen StandGeneral_Knowledge=std(General_Knowledge)
bysort Person_ID: keep if _n==1
order Person_ID YearOfTest TimingOfTest General_Knowledge StandGeneral_Knowledge
save "use\BJPolS_UniTest_1989_1", replace 

* 1989:2
use "raw\Hspresultat7795", clear
capture rename dnr2014115 Person_ID
keep if provar==89
keep if provtillfalle==2
keep Person_ID ao provar provtillfalle
rename ao General_Knowledge
rename provar YearOfTest
rename provtillfalle TimingOfTest
keep if General_Knowledge>=0 & General_Knowledge<=30 
egen StandGeneral_Knowledge=std(General_Knowledge)
bysort Person_ID: keep if _n==1
order Person_ID YearOfTest TimingOfTest General_Knowledge StandGeneral_Knowledge
save "use\BJPolS_UniTest_1989_2", replace   

* 1990:1
use "raw\Hspresultat7795", clear
capture rename dnr2014115 Person_ID
keep if provar==90
keep if provtillfalle==1
keep Person_ID ao provar provtillfalle
rename ao General_Knowledge
rename provar YearOfTest
rename provtillfalle TimingOfTest
keep if General_Knowledge>=0 & General_Knowledge<=30 
egen StandGeneral_Knowledge=std(General_Knowledge)
bysort Person_ID: keep if _n==1
order Person_ID YearOfTest TimingOfTest General_Knowledge StandGeneral_Knowledge
save "use\BJPolS_UniTest_1990_1", replace        

* 1990:2
use "raw\Hspresultat7795", clear
capture rename dnr2014115 Person_ID
keep if provar==90
keep if provtillfalle==2
keep Person_ID ao provar provtillfalle
rename ao General_Knowledge
rename provar YearOfTest
rename provtillfalle TimingOfTest
keep if General_Knowledge>=0 & General_Knowledge<=30 
egen StandGeneral_Knowledge=std(General_Knowledge)
bysort Person_ID: keep if _n==1
order Person_ID YearOfTest TimingOfTest General_Knowledge StandGeneral_Knowledge
save "use\BJPolS_UniTest_1990_2", replace   

* 1991:1
use "raw\Hspresultat7795", clear
capture rename dnr2014115 Person_ID
keep if provar==91
keep if provtillfalle==1
keep Person_ID ao provar provtillfalle
rename ao General_Knowledge
rename provar YearOfTest
rename provtillfalle TimingOfTest
keep if General_Knowledge>=0 & General_Knowledge<=30 
egen StandGeneral_Knowledge=std(General_Knowledge)
bysort Person_ID: keep if _n==1
order Person_ID YearOfTest TimingOfTest General_Knowledge StandGeneral_Knowledge
save "use\BJPolS_UniTest_1991_1", replace      

* 1991:2
use "raw\Hspresultat7795", clear
capture rename dnr2014115 Person_ID
keep if provar==91
keep if provtillfalle==2
keep Person_ID ao provar provtillfalle
rename ao General_Knowledge
rename provar YearOfTest
rename provtillfalle TimingOfTest
keep if General_Knowledge>=0 & General_Knowledge<=30 
egen StandGeneral_Knowledge=std(General_Knowledge)
bysort Person_ID: keep if _n==1
order Person_ID YearOfTest TimingOfTest General_Knowledge StandGeneral_Knowledge
save "use\BJPolS_UniTest_1991_2", replace  

* 1992:1
use "raw\Hspresultat7795", clear
capture rename dnr2014115 Person_ID
keep if provar==92
keep if provtillfalle==1
keep Person_ID ao provar provtillfalle
rename ao General_Knowledge
rename provar YearOfTest
rename provtillfalle TimingOfTest
keep if General_Knowledge>=0 & General_Knowledge<=30 
egen StandGeneral_Knowledge=std(General_Knowledge)
bysort Person_ID: keep if _n==1
order Person_ID YearOfTest TimingOfTest General_Knowledge StandGeneral_Knowledge
save "use\BJPolS_UniTest_1992_1", replace  

* 1992:2
use "raw\Hspresultat7795", clear
capture rename dnr2014115 Person_ID
keep if provar==92
keep if provtillfalle==2
keep Person_ID ao provar provtillfalle
rename ao General_Knowledge
rename provar YearOfTest
rename provtillfalle TimingOfTest
keep if General_Knowledge>=0 & General_Knowledge<=30 
egen StandGeneral_Knowledge=std(General_Knowledge)
bysort Person_ID: keep if _n==1
order Person_ID YearOfTest TimingOfTest General_Knowledge StandGeneral_Knowledge
save "use\BJPolS_UniTest_1992_2", replace  

* 1993:1
use "raw\Hspresultat7795", clear
capture rename dnr2014115 Person_ID
keep if provar==93
keep if provtillfalle==1
keep Person_ID ao provar provtillfalle
rename ao General_Knowledge
rename provar YearOfTest
rename provtillfalle TimingOfTest
keep if General_Knowledge>=0 & General_Knowledge<=30 
egen StandGeneral_Knowledge=std(General_Knowledge)
bysort Person_ID: keep if _n==1
order Person_ID YearOfTest TimingOfTest General_Knowledge StandGeneral_Knowledge
save "use\BJPolS_UniTest_1993_1", replace   

* 1993:2
use "raw\Hspresultat7795", clear
capture rename dnr2014115 Person_ID
keep if provar==93
keep if provtillfalle==2
keep Person_ID ao provar provtillfalle
rename ao General_Knowledge
rename provar YearOfTest
rename provtillfalle TimingOfTest
keep if General_Knowledge>=0 & General_Knowledge<=30 
egen StandGeneral_Knowledge=std(General_Knowledge)
bysort Person_ID: keep if _n==1
order Person_ID YearOfTest TimingOfTest General_Knowledge StandGeneral_Knowledge
save "use\BJPolS_UniTest_1993_2", replace  

* 1994:1
use "raw\Hspresultat7795", clear
capture rename dnr2014115 Person_ID
keep if provar==94
keep if provtillfalle==1
keep Person_ID ao provar provtillfalle
rename ao General_Knowledge
rename provar YearOfTest
rename provtillfalle TimingOfTest
keep if General_Knowledge>=0 & General_Knowledge<=30 
egen StandGeneral_Knowledge=std(General_Knowledge)
bysort Person_ID: keep if _n==1
order Person_ID YearOfTest TimingOfTest General_Knowledge StandGeneral_Knowledge
save "use\BJPolS_UniTest_1994_1", replace 

* 1994:2
use "raw\Hspresultat7795", clear
capture rename dnr2014115 Person_ID
keep if provar==94
keep if provtillfalle==2
keep Person_ID ao provar provtillfalle
rename ao General_Knowledge
rename provar YearOfTest
rename provtillfalle TimingOfTest
keep if General_Knowledge>=0 & General_Knowledge<=30 
egen StandGeneral_Knowledge=std(General_Knowledge)
bysort Person_ID: keep if _n==1
order Person_ID YearOfTest TimingOfTest General_Knowledge StandGeneral_Knowledge
save "use\BJPolS_UniTest_1994_2", replace                


* 1995:1
use "raw\Hspresultat7795", clear
capture rename dnr2014115 Person_ID
keep if provar==95
keep if provtillfalle==1
keep Person_ID ao provar provtillfalle
rename ao General_Knowledge
rename provar YearOfTest
rename provtillfalle TimingOfTest
keep if General_Knowledge>=0 & General_Knowledge<=30 
egen StandGeneral_Knowledge=std(General_Knowledge)
bysort Person_ID: keep if _n==1
order Person_ID YearOfTest TimingOfTest General_Knowledge StandGeneral_Knowledge
save "use\BJPolS_UniTest_1995_1", replace    

* 1995:2
use "raw\Hspresultat7795", clear
capture rename dnr2014115 Person_ID
keep if provar==95
keep if provtillfalle==2
keep Person_ID ao provar provtillfalle
rename ao General_Knowledge
rename provar YearOfTest
rename provtillfalle TimingOfTest
keep if General_Knowledge>=0 & General_Knowledge<=30 
egen StandGeneral_Knowledge=std(General_Knowledge)
bysort Person_ID: keep if _n==1
order Person_ID YearOfTest TimingOfTest General_Knowledge StandGeneral_Knowledge
save "use\BJPolS_UniTest_1995_2", replace







* append data for years 1988-1990
use "use\BJPolS_UniTest_1988_1", clear
append using "use\BJPolS_UniTest_1988_2" 
append using "use\BJPolS_UniTest_1989_1"
append using "use\BJPolS_UniTest_1989_2"
append using "use\BJPolS_UniTest_1990_1"
append using "use\BJPolS_UniTest_1990_2"

egen Time=group(YearOfTest TimingOfTest)
bysort Person_ID: egen MinTime=min(Time)
keep if Time==MinTime

save "use\BJPolS_Swesat1970", replace

* append data for years 1991-1993
use "use\BJPolS_UniTest_1991_1", clear
append using "use\BJPolS_UniTest_1991_2" 
append using "use\BJPolS_UniTest_1992_1"
append using "use\BJPolS_UniTest_1992_2"
append using "use\BJPolS_UniTest_1993_1"
append using "use\BJPolS_UniTest_1993_2"

egen Time=group(YearOfTest TimingOfTest)
bysort Person_ID: egen MinTime=min(Time)
keep if Time==MinTime

save "use\BJPolS_Swesat1973", replace

* append data for years 1994-1995

use "use\BJPolS_UniTest_1994_1", clear
append using "use\BJPolS_UniTest_1994_2" 
append using "use\BJPolS_UniTest_1995_1"
append using "use\BJPolS_UniTest_1995_2"


egen Time=group(YearOfTest TimingOfTest)
bysort Person_ID: egen MinTime=min(Time)
keep if Time==MinTime

save "use\BJPolS_Swesat1976", replace


   
   


*************************************************************************************************************************************************

********************************* CLEAN JUNIOR HIGH SCHOOL DATA***********************************************************************************
* INDIVIDUALS THAT LEFT JUNIOR HIGHSCHOOL IN 1988-1997 GOT 1-5 GRADES, BETWEEN 1998-2010 THEY GOT G, VG OR MVG, THE DIFFERENCE BETWEEN EXAMINATION YEAR AND BIRTHYEAR SHOULD TYPICALLY BE 16 

* Translation:

*medelbetyg=grade point average
*meritvarde=grade point average
*avgangsar=examination year
*avgar=examination year
*soc=overall grade in social science (the performance on Social Studies was a part of this grade in some schools) 
*sh= grade in Social Studies/ knowledge of society

* some schools did not grade Social Studies separately, they bundled it together with other subjects within social science and gave an overall grade
* when this is done the non-existing grade in Social studies is replace by the overall grade in social science

* WORK WITH 1988-1989 JUNIOR HIGHSCHOOL FILE
use "raw\Ak9avg8889", clear 
capture rename dnr2014115 Person_ID
drop if medelbetyg==0 | medelbetyg==. /* drop if GPA is not clearly defined*/
keep Person_ID avgangsar medelbetyg soc sh /* keep the relevant variables*/  
order Person_ID avgangsar medelbetyg soc sh 
replace sh=soc if sh=="0" /* if an overall grade in social science was set, replace the societyknowledge grade with this overall grade*/
drop soc /* drop the overall grade in social science*/ 
keep if sh=="1" | sh=="2" | sh=="3" | sh=="4" | sh=="5" 
destring sh, replace
bysort Person_ID: keep if _n==1 /* keep one observation per individual*/
rename medelbetyg JuniorHighSchoolGPA
rename avgangsar ExaminationYear
rename sh SocietyKnowlegdeGrade
save "use\BJPolS_JuniorHS1988_1989", replace 
*************************************

* WORK WITH 1990-1997 JUNIOR HIGHSCHOOL FILE
use "raw\Ak9avg9097", clear 
capture rename dnr2014115 Person_ID
drop if medelbetyg==0 | medelbetyg==. /* drop if GPA is not clearly defined*/
keep Person_ID avgangsar medelbetyg so sh /* keep the relevant variables*/  
order Person_ID avgangsar medelbetyg so sh
replace sh=so if sh=="0" /* if an overall grade in social science was set, replace the societyknowledge grade with this overall grade*/
drop so /* drop the overall grade in social science*/ 
keep if sh=="1" | sh=="2" | sh=="3" | sh=="4" | sh=="5" 
destring sh, replace
bysort Person_ID: keep if _n==1 /* keep one observation per individual*/
rename medelbetyg JuniorHighSchoolGPA
rename avgangsar ExaminationYear
rename sh SocietyKnowlegdeGrade
save "use\BJPolS_JuniorHS1990_1997", replace 
*************************************

* WORK WITH 1998 JUNIOR HIGHSCHOOL FILE
use "raw\Ak9avg98", clear 
capture rename dnr2014115 Person_ID
drop if meritvarde==0 | meritvarde==. /* drop if GPA is not clearly defined*/
keep Person_ID avgangsar meritvarde so sh /* keep the relevant variables*/  
order Person_ID avgangsar meritvarde so sh
replace sh=so if sh=="2" /* if an overall grade in social science was set, replace the societyknowledge grade with this overall grade*/
drop so /* drop the overall grade in social science*/ 
keep if sh=="1" | sh=="G" | sh=="VG" | sh=="MVG" 
replace sh="0" if sh=="1"
replace sh="10" if sh=="G"
replace sh="15" if sh=="VG"
replace sh="20" if sh=="MVG"
destring sh, replace
bysort Person_ID: keep if _n==1 /* keep one observation per individual*/
rename meritvarde JuniorHighSchoolGPA
rename avgangsar ExaminationYear
rename sh SocietyKnowlegdeGrade
save "use\BJPolS_JuniorHS1998", replace 
*************************************

* WORK WITH 1999-2000 JUNIOR HIGHSCHOOL FILE
use "raw\Ak9avg9900", clear 
capture rename dnr2014115 Person_ID
drop if meritvarde==0 | meritvarde==. /* drop if GPA is not clearly defined*/
keep Person_ID avgangsar meritvarde so sh /* keep the relevant variables*/  
order Person_ID avgangsar meritvarde so sh
replace sh=so if sh=="2" /* if an overall grade in social science was set, replace the societyknowledge grade with this overall grade*/
drop so /* drop the overall grade in social science*/ 
keep if sh=="1" | sh=="G" | sh=="V" | sh=="M" 
replace sh="0" if sh=="1"
replace sh="10" if sh=="G"
replace sh="15" if sh=="V"
replace sh="20" if sh=="M"
destring sh, replace
bysort Person_ID: keep if _n==1 /* keep one observation per individual*/
rename meritvarde JuniorHighSchoolGPA
rename avgangsar ExaminationYear
rename sh SocietyKnowlegdeGrade
save "use\BJPolS_JuniorHS1999_2000", replace 
*************************************

* WORK WITH 2001 JUNIOR HIGHSCHOOL FILE
use "raw\Ak9avg01", clear 
capture rename dnr2014115 Person_ID
drop if meritvarde==0 | meritvarde==. /* drop if GPA is not clearly defined*/
keep Person_ID avgangsar meritvarde so sh /* keep the relevant variables*/  
order Person_ID avgangsar meritvarde so sh
replace sh=so if sh=="2" /* if an overall grade in social science was set, replace the societyknowledge grade with this overall grade*/
drop so /* drop the overall grade in social science*/ 
keep if sh=="1" | sh=="G" | sh=="V" | sh=="M" 
replace sh="0" if sh=="1"
replace sh="10" if sh=="G"
replace sh="15" if sh=="V"
replace sh="20" if sh=="M"
destring sh, replace
bysort Person_ID: keep if _n==1 /* keep one observation per individual*/
rename meritvarde JuniorHighSchoolGPA
rename avgangsar ExaminationYear
rename sh SocietyKnowlegdeGrade
save "use\BJPolS_JuniorHS2001", replace 
*************************************

* WORK WITH 2002-2004 JUNIOR HIGHSCHOOL FILE
use "raw\Ak9avg0204", clear 
capture rename dnr2014115 Person_ID
drop if meritvarde==0 | meritvarde==. /* drop if GPA is not clearly defined*/
keep Person_ID avgangsar meritvarde so sh /* keep the relevant variables*/  
order Person_ID avgangsar meritvarde so sh
replace sh=so if sh=="2" /* if an overall grade in social science was set, replace the societyknowledge grade with this overall grade*/
drop so /* drop the overall grade in social science*/
keep if sh=="1" | sh=="G" | sh=="V" | sh=="M"  
replace sh="0" if sh=="1"
replace sh="10" if sh=="G"
replace sh="15" if sh=="V"
replace sh="20" if sh=="M"
destring sh, replace
bysort Person_ID: keep if _n==1 /* keep one observation per individual*/
rename meritvarde JuniorHighSchoolGPA
rename avgangsar ExaminationYear
rename sh SocietyKnowlegdeGrade
save "use\BJPolS_JuniorHS2002_2004", replace 
*************************************

* WORK WITH 2005-2006 JUNIOR HIGHSCHOOL FILE
use "raw\Ak9avg0506", clear 
capture rename dnr2014115 Person_ID
destring meritvarde, replace
destring avgar, replace
drop if meritvarde==0 | meritvarde==. /* drop if GPA is not clearly defined*/
keep Person_ID avgar meritvarde so sh /* keep the relevant variables*/  
order Person_ID avgar meritvarde so sh
replace sh=so if sh=="2" /* if an overall grade in social science was set, replace the societyknowledge grade with this overall grade*/
drop so /* drop the overall grade in social science*/
keep if sh=="1" | sh=="G" | sh=="V" | sh=="M"  
replace sh="0" if sh=="1"
replace sh="10" if sh=="G"
replace sh="15" if sh=="V"
replace sh="20" if sh=="M"
destring sh, replace
bysort Person_ID: keep if _n==1 /* keep one observation per individual*/
rename meritvarde JuniorHighSchoolGPA
rename avgar ExaminationYear
rename sh SocietyKnowlegdeGrade
save "use\BJPolS_JuniorHS2005_2006", replace 
*************************************

* WORK WITH 2007 JUNIOR HIGHSCHOOL FILE
use "raw\Ak9avg07", clear 
capture rename dnr2014115 Person_ID
destring meritvarde, replace
destring avgar, replace
drop if meritvarde==0 | meritvarde==. /* drop if GPA is not clearly defined*/
keep Person_ID avgar meritvarde so sh /* keep the relevant variables*/  
order Person_ID avgar meritvarde so sh
replace sh=so if sh=="2" /* if an overall grade in social science was set, replace the societyknowledge grade with this overall grade*/
drop so /* drop the overall grade in social science*/
keep if sh=="1" | sh=="G" | sh=="V" | sh=="M"  
replace sh="0" if sh=="1"
replace sh="10" if sh=="G"
replace sh="15" if sh=="V"
replace sh="20" if sh=="M"
destring sh, replace
bysort Person_ID: keep if _n==1 /* keep one observation per individual*/
rename meritvarde JuniorHighSchoolGPA
rename avgar ExaminationYear
rename sh SocietyKnowlegdeGrade
save "use\BJPolS_JuniorHS2007", replace 
*************************************

* WORK WITH 2008 JUNIOR HIGHSCHOOL FILE (also contains 2009 graduates)
use "raw\Ak9avg08", clear 
capture rename dnr2014115 Person_ID
destring meritvarde, replace
destring avgar, replace
drop if meritvarde==0 | meritvarde==. /* drop if GPA is not clearly defined*/
keep Person_ID avgar meritvarde so sh /* keep the relevant variables*/  
order Person_ID avgar meritvarde so sh
replace sh=so if sh=="2" /* if an overall grade in social science was set, replace the societyknowledge grade with this overall grade*/
drop so /* drop the overall grade in social science*/
keep if sh=="1" | sh=="G" | sh=="V" | sh=="M"  
replace sh="0" if sh=="1"
replace sh="10" if sh=="G"
replace sh="15" if sh=="V"
replace sh="20" if sh=="M"
destring sh, replace
bysort Person_ID: keep if _n==1 /* keep one observation per individual*/
rename meritvarde JuniorHighSchoolGPA
rename avgar ExaminationYear
rename sh SocietyKnowlegdeGrade
save "use\BJPolS_JuniorHS2008", replace 
*************************************

* WORK WITH 2009 JUNIOR HIGHSCHOOL FILE
use "raw\Ak9avg09", clear 
capture rename dnr2014115 Person_ID
destring meritvarde, replace
destring avgar, replace
drop if meritvarde==0 | meritvarde==. /* drop if GPA is not clearly defined*/
keep Person_ID avgar meritvarde so sh /* keep the relevant variables*/  
order Person_ID avgar meritvarde so sh
replace sh=so if sh=="2" /* if an overall grade in social science was set, replace the societyknowledge grade with this overall grade*/
drop so /* drop the overall grade in social science*/
keep if sh=="1" | sh=="G" | sh=="V" | sh=="M"  
replace sh="0" if sh=="1"
replace sh="10" if sh=="G"
replace sh="15" if sh=="V"
replace sh="20" if sh=="M"
destring sh, replace
bysort Person_ID: keep if _n==1 /* keep one observation per individual*/
rename meritvarde JuniorHighSchoolGPA
rename avgar ExaminationYear
rename sh SocietyKnowlegdeGrade
save "use\BJPolS_JuniorHS2009", replace 
*************************************

* WORK WITH 2010 JUNIOR HIGHSCHOOL FILE
use "raw\Ak9avg10", clear 
capture rename dnr2014115 Person_ID
destring meritvarde, replace
destring avgar, replace
drop if meritvarde==0 | meritvarde==. /* drop if GPA is not clearly defined*/
keep Person_ID avgar meritvarde so sh /* keep the relevant variables*/  
order Person_ID avgar meritvarde so sh
replace sh=so if sh=="2" /* if an overall grade in social science was set, replace the societyknowledge grade with this overall grade*/
drop so /* drop the overall grade in social science*/
keep if sh=="1" | sh=="G" | sh=="V" | sh=="M"  
replace sh="0" if sh=="1"
replace sh="10" if sh=="G"
replace sh="15" if sh=="V"
replace sh="20" if sh=="M"
destring sh, replace
bysort Person_ID: keep if _n==1 /* keep one observation per individual*/
rename meritvarde JuniorHighSchoolGPA
rename avgar ExaminationYear
rename sh SocietyKnowlegdeGrade
save "use\BJPolS_JuniorHS2010", replace 
*************************************

* PUT TOGETHER ALL THE JUNIOR HIGH SCHOOL FILES	
use "use\BJPolS_JuniorHS1988_1989", clear
capture rename dnr2014115 Person_ID
append using "use\BJPolS_JuniorHS1990_1997", force
append using "use\BJPolS_JuniorHS1998", force
append using "use\BJPolS_JuniorHS1999_2000", force
append using "use\BJPolS_JuniorHS2001", force
append using "use\BJPolS_JuniorHS2002_2004", force
append using "use\BJPolS_JuniorHS2005_2006", force
append using "use\BJPolS_JuniorHS2007", force
append using "use\BJPolS_JuniorHS2008", force
append using "use\BJPolS_JuniorHS2009", force
append using "use\BJPolS_JuniorHS2010", force
bysort Person_ID: keep if _n==1 /* remove multiple observations*/
save "use\BJPolS_JuniorHS1988_2010", replace 
************************************************

* STANDARDIZE OVERALL GPA AND SOCIETYKNOWLEDGE GPA BY EXAMINATION YEAR
set more off
use "use\BJPolS_JuniorHS1988_2010", clear
capture rename dnr2014115 Person_ID
forvalues I=1988(1)2010{
egen StandOverallGPA`I'=std(JuniorHighSchoolGPA) if ExaminationYear==`I'
egen StandSocietyGPA`I'=std(SocietyKnowlegdeGrade) if ExaminationYear==`I'
}
*
gen StandJuniorHSOverallGPA=.
gen StandJuniorHSSocietyGPA=.

forvalues I=1988(1)2010{
replace StandJuniorHSOverallGPA=StandOverallGPA`I' if StandJuniorHSOverallGPA==. 
replace StandJuniorHSSocietyGPA=StandSocietyGPA`I' if StandJuniorHSSocietyGPA==.
}
*
keep Person_ID ExaminationYear StandJuniorHSOverallGPA StandJuniorHSSocietyGPA  
save "use\BJPolS_JuniorHS1988_2010Std", replace

****************************************************************************************************************************************************

**************************************** CLEAN HIGH SCHOOL DATA***********************************************************************************

* INDIVIDUALS THAT LEFT HIGHSCHOOL IN 1985-1996 GOT 1-5 GRADES IN SUBJECTS, BETWEEN 1997-2010 THEY GOT IG, G, VG OR MVG IN COURSES, THE DIFFERENCE BETWEEN EXAMINATION YEAR AND BIRTHYEAR SHOULD TYPICALLY BE 19 

* The numerical values of the grades are: IG=0, G=10, VG=15 and MVG=20

* THE SUBJECTCODE FOR "SAMHÄLLSKUNSKAP"=SOCIETYKNOWLEDGE IS 54800(0) or 5480K0, RELEVANT FOR YEARS 1985-1996

* THE FOLLOWING COURSECODES ARE RELEVANT FOR YEARS 1997-2002: SAMHÄLLSKUNSKAP (social studies) A - SH200, SAMHÄLLSKUNSKAP B - SH201, SAMHÄLLSKUNSKAP C - SH202

* THE FOLLOWING COURSECODES ARE RELEVANT FOR THE YEARS 2003-2010: SAMHÄLLSKUNSKAP A - SH1201, SAMHÄLLSKUNSKAP B - SH1202, SAMHÄLLSKUNSKAP C - SH1203

* social studies and SocietyKnowlegde is used interchangably 

* Translation pf variable names

*mbet=grade point average
*mbetyg=grade point average
*jmftal=grade point average
*argang=examination year
*avgangsar=examination year
*ar=examination year
*amnekod=subject code
*kurskod=course code
*betyg=grade

set more off
* WORK WITH 1985-1989 HIGHSCHOOL FILE
use "raw\Gymnavg8589", clear 
capture rename dnr2014115 Person_ID
drop if mbet==0 | mbet==. /* drop if GPA is not clearly defined*/
rename mbet HighSchoolOverallGPA
rename argang ExaminationYearHighSchool
gen str SocietyKnowlegdeGPA=""

forvalues i=1(1)28{
capture tostring amnekod`i', replace
capture tostring betyg`i', replace
replace SocietyKnowlegdeGPA=betyg`i' if amnekod`i'=="548000" | amnekod`i'=="5480K0" 
}
*
keep Person_ID ExaminationYearHighSchool HighSchoolOverallGPA SocietyKnowlegdeGPA
keep if SocietyKnowlegdeGPA=="1" | SocietyKnowlegdeGPA=="2" | SocietyKnowlegdeGPA=="3"  | SocietyKnowlegdeGPA=="4"  | SocietyKnowlegdeGPA=="5"    
destring SocietyKnowlegdeGPA ,replace
bysort Person_ID: keep if _n==1 /* keep one observation per individual*/
save "use\BJPolS_HighSchool1985_1989", replace 
****************************************************************************

* WORK WITH 1990 HIGHSCHOOL FILE
use "raw\Gymnavg1990", clear 
capture rename dnr2014115 Person_ID
drop if mbetyg==0 | mbetyg==. /* drop if GPA is not clearly defined*/
rename mbetyg HighSchoolOverallGPA
rename avgangsar ExaminationYearHighSchool
gen str SocietyKnowlegdeGPA=""

forvalues i=1(1)28{
capture tostring amnekod`i', replace
capture tostring betyg`i', replace
replace SocietyKnowlegdeGPA=betyg`i' if amnekod`i'=="548000" | amnekod`i'=="5480K0"
}
*
keep Person_ID ExaminationYearHighSchool HighSchoolOverallGPA SocietyKnowlegdeGPA
keep if SocietyKnowlegdeGPA=="1" | SocietyKnowlegdeGPA=="2" | SocietyKnowlegdeGPA=="3"  | SocietyKnowlegdeGPA=="4"  | SocietyKnowlegdeGPA=="5"   
destring SocietyKnowlegdeGPA ,replace
bysort Person_ID: keep if _n==1 /* keep one observation per individual*/
save "use\BJPolS_HighSchool1990", replace  
****************************************************************************

* WORK WITH 1991 HIGHSCHOOL FILE
use "raw\Gymnavg1991", clear 
capture rename dnr2014115 Person_ID
drop if mbetyg==0 | mbetyg==. /* drop if GPA is not clearly defined*/
rename mbetyg HighSchoolOverallGPA
rename avgangsar ExaminationYearHighSchool
gen str SocietyKnowlegdeGPA=""

forvalues i=1(1)28{
capture tostring amnekod`i', replace
capture tostring betyg`i', replace
replace SocietyKnowlegdeGPA=betyg`i' if amnekod`i'=="548000" | amnekod`i'=="5480K0"
}
*
keep Person_ID ExaminationYearHighSchool HighSchoolOverallGPA SocietyKnowlegdeGPA
keep if SocietyKnowlegdeGPA=="1" | SocietyKnowlegdeGPA=="2" | SocietyKnowlegdeGPA=="3"  | SocietyKnowlegdeGPA=="4"  | SocietyKnowlegdeGPA=="5"   
destring SocietyKnowlegdeGPA ,replace
bysort Person_ID: keep if _n==1 /* keep one observation per individual*/
save "use\BJPolS_HighSchool1991", replace  
****************************************************************************

* WORK WITH 1992 HIGHSCHOOL FILE
use "raw\Gymnavg1992", clear 
capture rename dnr2014115 Person_ID
drop if mbetyg==0 | mbetyg==. /* drop if GPA is not clearly defined*/
rename mbetyg HighSchoolOverallGPA
rename avgangsar ExaminationYearHighSchool
gen str SocietyKnowlegdeGPA=""

forvalues i=1(1)28{
capture tostring amnekod`i', replace
capture tostring betyg`i', replace
replace SocietyKnowlegdeGPA=betyg`i' if amnekod`i'=="548000" | amnekod`i'=="5480K0"
}
*
keep Person_ID ExaminationYearHighSchool HighSchoolOverallGPA SocietyKnowlegdeGPA
keep if SocietyKnowlegdeGPA=="1" | SocietyKnowlegdeGPA=="2" | SocietyKnowlegdeGPA=="3"  | SocietyKnowlegdeGPA=="4"  | SocietyKnowlegdeGPA=="5"   
destring SocietyKnowlegdeGPA ,replace
bysort Person_ID: keep if _n==1 /* keep one observation per individual*/
save "use\BJPolS_HighSchool1992", replace 
****************************************************************************

* WORK WITH 1993 HIGHSCHOOL FILE
use "raw\Gymnavg1993", clear 
capture rename dnr2014115 Person_ID
drop if mbetyg==0 | mbetyg==. /* drop if GPA is not clearly defined*/
rename mbetyg HighSchoolOverallGPA
rename avgangsar ExaminationYearHighSchool
gen str SocietyKnowlegdeGPA=""

forvalues i=1(1)28{
capture tostring amnekod`i', replace
capture tostring betyg`i', replace
replace SocietyKnowlegdeGPA=betyg`i' if amnekod`i'=="548000" | amnekod`i'=="5480K0"
}
*
keep Person_ID ExaminationYearHighSchool HighSchoolOverallGPA SocietyKnowlegdeGPA
keep if SocietyKnowlegdeGPA=="1" | SocietyKnowlegdeGPA=="2" | SocietyKnowlegdeGPA=="3"  | SocietyKnowlegdeGPA=="4"  | SocietyKnowlegdeGPA=="5"   
destring SocietyKnowlegdeGPA ,replace
bysort Person_ID: keep if _n==1 /* keep one observation per individual*/
save "use\BJPolS_HighSchool1993", replace 
****************************************************************************

* WORK WITH 1994 HIGHSCHOOL FILE
use "raw\Gymnavg1994", clear 
capture rename dnr2014115 Person_ID
drop if mbetyg==0 | mbetyg==. /* drop if GPA is not clearly defined*/
rename mbetyg HighSchoolOverallGPA
rename avgangsar ExaminationYearHighSchool
gen str SocietyKnowlegdeGPA=""

forvalues i=1(1)28{
capture tostring amnekod`i', replace
capture tostring betyg`i', replace
replace SocietyKnowlegdeGPA=betyg`i' if amnekod`i'=="548000" | amnekod`i'=="5480K0"
}
*
keep Person_ID ExaminationYearHighSchool HighSchoolOverallGPA SocietyKnowlegdeGPA
keep if SocietyKnowlegdeGPA=="1" | SocietyKnowlegdeGPA=="2" | SocietyKnowlegdeGPA=="3"  | SocietyKnowlegdeGPA=="4"  | SocietyKnowlegdeGPA=="5"   
destring SocietyKnowlegdeGPA ,replace
bysort Person_ID: keep if _n==1 /* keep one observation per individual*/
save "use\BJPolS_HighSchool1994", replace 
****************************************************************************

* WORK WITH 1995 HIGHSCHOOL FILE
use "raw\Gymnavg1995", clear 
capture rename dnr2014115 Person_ID
drop if mbetyg==0 | mbetyg==. /* drop if GPA is not clearly defined*/
rename mbetyg HighSchoolOverallGPA
rename avgangsar ExaminationYearHighSchool
gen str SocietyKnowlegdeGPA=""

forvalues i=1(1)28{
capture tostring amnekod`i', replace
capture tostring betyg`i', replace
replace SocietyKnowlegdeGPA=betyg`i' if amnekod`i'=="548000" | amnekod`i'=="5480K0"
}
*
keep Person_ID ExaminationYearHighSchool HighSchoolOverallGPA SocietyKnowlegdeGPA
keep if SocietyKnowlegdeGPA=="1" | SocietyKnowlegdeGPA=="2" | SocietyKnowlegdeGPA=="3"  | SocietyKnowlegdeGPA=="4"  | SocietyKnowlegdeGPA=="5"   
destring SocietyKnowlegdeGPA ,replace
bysort Person_ID: keep if _n==1 /* keep one observation per individual*/
save "use\BJPolS_HighSchool1995", replace 
****************************************************************************

* WORK WITH 1996 HIGHSCHOOL FILE
use "raw\Gymnavg1996", clear 
capture rename dnr2014115 Person_ID
drop if mbetyg==0 | mbetyg==. /* drop if GPA is not clearly defined*/
rename mbetyg HighSchoolOverallGPA
rename avgangsar ExaminationYearHighSchool
gen str SocietyKnowlegdeGPA=""

forvalues i=1(1)28{
capture tostring amnekod`i', replace
capture tostring betyg`i', replace
replace SocietyKnowlegdeGPA=betyg`i' if amnekod`i'=="548000" | amnekod`i'=="5480K0"
}
*
keep Person_ID ExaminationYearHighSchool HighSchoolOverallGPA SocietyKnowlegdeGPA
keep if SocietyKnowlegdeGPA=="1" | SocietyKnowlegdeGPA=="2" | SocietyKnowlegdeGPA=="3"  | SocietyKnowlegdeGPA=="4"  | SocietyKnowlegdeGPA=="5"   
destring SocietyKnowlegdeGPA ,replace
bysort Person_ID: keep if _n==1 /* keep one observation per individual*/
save "use\BJPolS_HighSchool1996", replace  
****************************************************************************

* WORK WITH 1997 HIGHSCHOOL FILE*************************************************************
use "raw\Gymnavg1997", clear
capture rename dnr2014115 Person_ID
drop if jmftal==0
keep if kurskod=="SH200" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge grade*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M"
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID argang jmftal betyg
order Person_ID argang jmftal betyg
rename argang ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA 
replace SocietyKnowlegdeGPA="0" if SocietyKnowlegdeGPA=="I" 
replace SocietyKnowlegdeGPA="10" if SocietyKnowlegdeGPA=="G" 
replace SocietyKnowlegdeGPA="15" if SocietyKnowlegdeGPA=="V" 
replace SocietyKnowlegdeGPA="20" if SocietyKnowlegdeGPA=="M" 
destring SocietyKnowlegdeGPA, replace 
save "use\BJPolS_HighSchool1997", replace 
********************************************************************************************************************************************

* WORK WITH 1998 HIGHSCHOOL FILE*************************************************************
use "raw\Gymnavg1998", clear
capture rename dnr2014115 Person_ID 
drop if jmftal==0
keep if kurskod=="SH200" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge grade*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M"
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID argang jmftal betyg
order Person_ID argang jmftal betyg
rename argang ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA 
replace SocietyKnowlegdeGPA="0" if SocietyKnowlegdeGPA=="I" 
replace SocietyKnowlegdeGPA="10" if SocietyKnowlegdeGPA=="G" 
replace SocietyKnowlegdeGPA="15" if SocietyKnowlegdeGPA=="V" 
replace SocietyKnowlegdeGPA="20" if SocietyKnowlegdeGPA=="M" 
destring SocietyKnowlegdeGPA, replace 
save "use\BJPolS_HighSchool1998", replace 
********************************************************************************************************************************************

* WORK WITH 1999 HIGHSCHOOL FILE*************************************************************
use "raw\Gymnavg1999", clear
capture rename dnr2014115 Person_ID
drop if jmftal==0
keep if kurskod=="SH200" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge grade*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M"
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID argang jmftal betyg
order Person_ID argang jmftal betyg
rename argang ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA 
replace SocietyKnowlegdeGPA="0" if SocietyKnowlegdeGPA=="I" 
replace SocietyKnowlegdeGPA="10" if SocietyKnowlegdeGPA=="G" 
replace SocietyKnowlegdeGPA="15" if SocietyKnowlegdeGPA=="V" 
replace SocietyKnowlegdeGPA="20" if SocietyKnowlegdeGPA=="M" 
destring SocietyKnowlegdeGPA, replace 
save "use\BJPolS_HighSchool1999", replace 
********************************************************************************************************************************************

* WORK WITH 2000 HIGHSCHOOL FILE*************************************************************
use "raw\Gymnavg2000", clear
capture rename dnr2014115 Person_ID 
drop if jmftal==0
keep if kurskod=="SH200" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge grade*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M"
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID argang jmftal betyg
order Person_ID argang jmftal betyg
rename argang ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA 
replace SocietyKnowlegdeGPA="0" if SocietyKnowlegdeGPA=="I" 
replace SocietyKnowlegdeGPA="10" if SocietyKnowlegdeGPA=="G" 
replace SocietyKnowlegdeGPA="15" if SocietyKnowlegdeGPA=="V" 
replace SocietyKnowlegdeGPA="20" if SocietyKnowlegdeGPA=="M" 
destring SocietyKnowlegdeGPA, replace 
save "use\BJPolS_HighSchool2000", replace 
********************************************************************************************************************************************

* WORK WITH 2001 HIGHSCHOOL FILE*************************************************************
use "raw\Gymnavg2001", clear
capture rename dnr2014115 Person_ID 
drop if jmftal==0
keep if kurskod=="SH200" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge grade*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M"
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID argang jmftal betyg
order Person_ID argang jmftal betyg
rename argang ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA 
replace SocietyKnowlegdeGPA="0" if SocietyKnowlegdeGPA=="I" 
replace SocietyKnowlegdeGPA="10" if SocietyKnowlegdeGPA=="G" 
replace SocietyKnowlegdeGPA="15" if SocietyKnowlegdeGPA=="V" 
replace SocietyKnowlegdeGPA="20" if SocietyKnowlegdeGPA=="M" 
destring SocietyKnowlegdeGPA, replace 
save "use\BJPolS_HighSchool2001", replace 
********************************************************************************************************************************************

* WORK WITH 2002 HIGHSCHOOL FILES*************************************************************
* clean the "raw\Gymnavg2002elev" file 
use "raw\Gymnavg2002elev", clear
capture rename dnr2014115 Person_ID
bysort Person_ID: keep if _n==1
save "temp\BJPolS_Gymnavg2002elev", replace
*********
use "raw\Gymnavg2002kurs", clear
capture rename dnr2014115 Person_ID
merge m:1 Person_ID using "temp\BJPolS_Gymnavg2002elev", keep(match master) keepusing(jmftal) 
destring jmftal, replace
drop if jmftal==0
keep if kurskod=="SH1201" | kurskod=="SH200"  /* every individual has one observation per course, keep the course that carries the SocietyKnowledge grade*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M"
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID avgangsar jmftal betyg
order Person_ID avgangsar jmftal betyg
rename avgangsar ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA 
replace SocietyKnowlegdeGPA="0" if SocietyKnowlegdeGPA=="I" 
replace SocietyKnowlegdeGPA="10" if SocietyKnowlegdeGPA=="G" 
replace SocietyKnowlegdeGPA="15" if SocietyKnowlegdeGPA=="V" 
replace SocietyKnowlegdeGPA="20" if SocietyKnowlegdeGPA=="M" 
destring SocietyKnowlegdeGPA, replace 
save "use\BJPolS_HighSchool2002", replace 
********************************************************************************************************************************************

* WORK WITH 2003 HIGHSCHOOL FILES*************************************************************
* clean the "raw\Gymnavg2003elev" file 
use "raw\Gymnavg2003elev", clear
capture rename dnr2014115 Person_ID
bysort Person_ID: keep if _n==1
save "temp\BJPolS_Gymnavg2003elev", replace
*********
use "raw\Gymnavg2003kurs", clear
capture rename dnr2014115 Person_ID
merge m:1 Person_ID using "temp\BJPolS_Gymnavg2003elev", keep(match master) keepusing(jmftal) 
destring jmftal, replace
drop if jmftal==0
keep if kurskod=="SH1201" | kurskod=="SH200" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge grade*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M" | betyg=="IG" | betyg=="VG" | betyg=="MVG" 
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID avgangsar jmftal betyg
order Person_ID avgangsar jmftal betyg
rename avgangsar ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA 
replace SocietyKnowlegdeGPA="0" if SocietyKnowlegdeGPA=="I" | SocietyKnowlegdeGPA=="IG"  
replace SocietyKnowlegdeGPA="10" if SocietyKnowlegdeGPA=="G" 
replace SocietyKnowlegdeGPA="15" if SocietyKnowlegdeGPA=="V" | SocietyKnowlegdeGPA=="VG"   
replace SocietyKnowlegdeGPA="20" if SocietyKnowlegdeGPA=="M" | SocietyKnowlegdeGPA=="MVG"  
destring SocietyKnowlegdeGPA, replace 
save "use\BJPolS_HighSchool2003", replace 
********************************************************************************************************************************************

* WORK WITH 2004 HIGHSCHOOL FILES*************************************************************
* clean the "raw\Gymnavg2004elev" file 
use "raw\Gymnavg2004elev", clear
capture rename dnr2014115 Person_ID
bysort Person_ID: keep if _n==1
save "temp\BJPolS_Gymnavg2004elev", replace
*********
use "raw\Gymnavg2004kurs", clear
capture rename dnr2014115 Person_ID
merge m:1 Person_ID using "temp\BJPolS_Gymnavg2004elev", keep(match master) keepusing(jmftal) 
destring jmftal, replace
drop if jmftal==0
keep if kurskod=="SH1201" | kurskod=="SH200" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge grade*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M" | betyg=="IG" | betyg=="VG" | betyg=="MVG" 
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID avgangsar jmftal betyg
order Person_ID avgangsar jmftal betyg
rename avgangsar ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA 
replace SocietyKnowlegdeGPA="0" if SocietyKnowlegdeGPA=="I" | SocietyKnowlegdeGPA=="IG"  
replace SocietyKnowlegdeGPA="10" if SocietyKnowlegdeGPA=="G" 
replace SocietyKnowlegdeGPA="15" if SocietyKnowlegdeGPA=="V" | SocietyKnowlegdeGPA=="VG"   
replace SocietyKnowlegdeGPA="20" if SocietyKnowlegdeGPA=="M" | SocietyKnowlegdeGPA=="MVG"  
destring SocietyKnowlegdeGPA, replace 
save "use\BJPolS_HighSchool2004", replace 
********************************************************************************************************************************************

* WORK WITH 2005 HIGHSCHOOL FILES*************************************************************
* clean the "raw\Gymnavg2005elev" file 
use "raw\Gymnavg2005elev", clear
capture rename dnr2014115 Person_ID
bysort Person_ID: keep if _n==1
save "temp\BJPolS_Gymnavg2005elev", replace
*********
use "raw\Gymnavg2005kurs", clear
capture rename dnr2014115 Person_ID
merge m:1 Person_ID using "temp\BJPolS_Gymnavg2005elev", keep(match master) keepusing(jmftal)  
destring jmftal, replace
drop if jmftal==0
keep if kurskod=="SH1201" | kurskod=="SH200" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge grade*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M" | betyg=="IG" | betyg=="VG" | betyg=="MVG" 
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID avgangsar jmftal betyg
order Person_ID avgangsar jmftal betyg
rename avgangsar ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA 
replace SocietyKnowlegdeGPA="0" if SocietyKnowlegdeGPA=="I" | SocietyKnowlegdeGPA=="IG"  
replace SocietyKnowlegdeGPA="10" if SocietyKnowlegdeGPA=="G" 
replace SocietyKnowlegdeGPA="15" if SocietyKnowlegdeGPA=="V" | SocietyKnowlegdeGPA=="VG"   
replace SocietyKnowlegdeGPA="20" if SocietyKnowlegdeGPA=="M" | SocietyKnowlegdeGPA=="MVG"  
destring SocietyKnowlegdeGPA, replace 
save "use\BJPolS_HighSchool2005", replace 
******************************************************************************************************

* WORK WITH 2006 HIGHSCHOOL FILES*************************************************************
* clean the "raw\Gymnavg2006elev" file 
use "raw\Gymnavg2006elev", clear
capture rename dnr2014115 Person_ID
bysort Person_ID: keep if _n==1
save "temp\BJPolS_Gymnavg2006elev", replace
*********
use "raw\Gymnavg2006kurs", clear
capture rename dnr2014115 Person_ID
merge m:1 Person_ID using "temp\BJPolS_Gymnavg2006elev", keep(match master) keepusing(jmftal) 
destring avgangsar, replace 
destring jmftal, replace
drop if jmftal==0
keep if kurskod=="SH1201" | kurskod=="SH200" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge grade*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M" | betyg=="IG" | betyg=="VG" | betyg=="MVG" 
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID avgangsar jmftal betyg
order Person_ID avgangsar jmftal betyg
rename avgangsar ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA 
replace SocietyKnowlegdeGPA="0" if SocietyKnowlegdeGPA=="I" | SocietyKnowlegdeGPA=="IG"  
replace SocietyKnowlegdeGPA="10" if SocietyKnowlegdeGPA=="G" 
replace SocietyKnowlegdeGPA="15" if SocietyKnowlegdeGPA=="V" | SocietyKnowlegdeGPA=="VG"   
replace SocietyKnowlegdeGPA="20" if SocietyKnowlegdeGPA=="M" | SocietyKnowlegdeGPA=="MVG"  
destring SocietyKnowlegdeGPA, replace 
save "use\BJPolS_HighSchool2006", replace 
******************************************************************************************************

* WORK WITH 2007 HIGHSCHOOL FILES*************************************************************
* clean the "raw\Gymnavg2007elev" file 
use "raw\Gymnavg2007elev", clear
capture rename dnr2014115 Person_ID
bysort Person_ID: keep if _n==1
save "temp\BJPolS_Gymnavg2007elev", replace
*********
use "raw\Gymnavg2007kurs", clear
capture rename dnr2014115 Person_ID
merge m:1 Person_ID using "temp\BJPolS_Gymnavg2007elev", keep(match master) keepusing(jmftal) 
destring ar, replace
destring jmftal, replace
drop if jmftal==0
keep if kurskod=="SH1201" | kurskod=="SH200" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge grade*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M" | betyg=="IG" | betyg=="VG" | betyg=="MVG" 
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID ar jmftal betyg
order Person_ID ar jmftal betyg
rename ar ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA 
replace SocietyKnowlegdeGPA="0" if SocietyKnowlegdeGPA=="I" | SocietyKnowlegdeGPA=="IG"  
replace SocietyKnowlegdeGPA="10" if SocietyKnowlegdeGPA=="G" 
replace SocietyKnowlegdeGPA="15" if SocietyKnowlegdeGPA=="V" | SocietyKnowlegdeGPA=="VG"   
replace SocietyKnowlegdeGPA="20" if SocietyKnowlegdeGPA=="M" | SocietyKnowlegdeGPA=="MVG"  
destring SocietyKnowlegdeGPA, replace 
save "use\BJPolS_HighSchool2007", replace 
******************************************************************************************************

* WORK WITH 2008 HIGHSCHOOL FILES*************************************************************
* clean the "raw\Gymnavg2008elev" file 
use "raw\Gymnavg2008elev", clear
capture rename dnr2014115 Person_ID
bysort Person_ID: keep if _n==1
save "temp\BJPolS_Gymnavg2008elev", replace
*********
use "raw\Gymnavg2008kurs", clear
capture rename dnr2014115 Person_ID
merge m:1 Person_ID using "temp\BJPolS_Gymnavg2008elev", keep(match master) keepusing(jmftal) 
destring ar, replace
destring jmftal, replace
drop if jmftal==0
keep if kurskod=="SH1201" | kurskod=="SH200" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge grade*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M" | betyg=="IG" | betyg=="VG" | betyg=="MVG" 
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID ar jmftal betyg
order Person_ID ar jmftal betyg
rename ar ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA 
replace SocietyKnowlegdeGPA="0" if SocietyKnowlegdeGPA=="I" | SocietyKnowlegdeGPA=="IG"  
replace SocietyKnowlegdeGPA="10" if SocietyKnowlegdeGPA=="G" 
replace SocietyKnowlegdeGPA="15" if SocietyKnowlegdeGPA=="V" | SocietyKnowlegdeGPA=="VG"   
replace SocietyKnowlegdeGPA="20" if SocietyKnowlegdeGPA=="M" | SocietyKnowlegdeGPA=="MVG"  
destring SocietyKnowlegdeGPA, replace 
save "use\BJPolS_HighSchool2008", replace 
******************************************************************************************************

* WORK WITH 2009 HIGHSCHOOL FILES*************************************************************
* clean the "raw\Gymnavg2009elev" file 
use "raw\Gymnavg2009elev", clear
capture rename dnr2014115 Person_ID
bysort Person_ID: keep if _n==1
save "temp\BJPolS_Gymnavg2009elev", replace
*********
use "raw\Gymnavg2009kurs", clear
capture rename dnr2014115 Person_ID
merge m:1 Person_ID using "temp\BJPolS_Gymnavg2009elev", keep(match master) keepusing(jmftal) 
destring ar, replace
destring jmftal, replace
drop if jmftal==0
keep if kurskod=="SH1201" | kurskod=="SH200" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge grade*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M" | betyg=="IG" | betyg=="VG" | betyg=="MVG" 
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID ar jmftal betyg
order Person_ID ar jmftal betyg
rename ar ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA 
replace SocietyKnowlegdeGPA="0" if SocietyKnowlegdeGPA=="I" | SocietyKnowlegdeGPA=="IG"  
replace SocietyKnowlegdeGPA="10" if SocietyKnowlegdeGPA=="G" 
replace SocietyKnowlegdeGPA="15" if SocietyKnowlegdeGPA=="V" | SocietyKnowlegdeGPA=="VG"   
replace SocietyKnowlegdeGPA="20" if SocietyKnowlegdeGPA=="M" | SocietyKnowlegdeGPA=="MVG"  
destring SocietyKnowlegdeGPA, replace 
save "use\BJPolS_HighSchool2009", replace 
******************************************************************************************************

* WORK WITH 2010 HIGHSCHOOL FILES*************************************************************
* clean the "raw\Gymnavg2009elev" file 
use "raw\Gymnavg2010elev", clear
capture rename dnr2014115 Person_ID
bysort Person_ID: keep if _n==1
save "temp\BJPolS_Gymnavg2010elev", replace
*********
use "raw\Gymnavg2010kurs", clear
capture rename dnr2014115 Person_ID
merge m:1 Person_ID using "temp\BJPolS_Gymnavg2010elev", keep(match master) keepusing(jmftal) 
destring ar, replace
destring jmftal, replace
drop if jmftal==0
keep if kurskod=="SH1201" | kurskod=="SH200" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge grade*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M" | betyg=="IG" | betyg=="VG" | betyg=="MVG" 
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID ar jmftal betyg
order Person_ID ar jmftal betyg
rename ar ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA 
replace SocietyKnowlegdeGPA="0" if SocietyKnowlegdeGPA=="I" | SocietyKnowlegdeGPA=="IG"  
replace SocietyKnowlegdeGPA="10" if SocietyKnowlegdeGPA=="G" 
replace SocietyKnowlegdeGPA="15" if SocietyKnowlegdeGPA=="V" | SocietyKnowlegdeGPA=="VG"   
replace SocietyKnowlegdeGPA="20" if SocietyKnowlegdeGPA=="M" | SocietyKnowlegdeGPA=="MVG"  
destring SocietyKnowlegdeGPA, replace 
save "use\BJPolS_HighSchool2010", replace 
******************************************************************************************************

* PUT TOGETHER ALL THE  HIGH SCHOOL FILES	
use "use\BJPolS_HighSchool1985_1989", clear
capture rename dnr2014115 Person_ID
append using "use\BJPolS_HighSchool1990", force
append using "use\BJPolS_HighSchool1991", force
append using "use\BJPolS_HighSchool1992", force
append using "use\BJPolS_HighSchool1993", force
append using "use\BJPolS_HighSchool1994", force
append using "use\BJPolS_HighSchool1995", force
append using "use\BJPolS_HighSchool1996", force
append using "use\BJPolS_HighSchool1997", force
append using "use\BJPolS_HighSchool1998", force
append using "use\BJPolS_HighSchool1999", force
append using "use\BJPolS_HighSchool2000", force
append using "use\BJPolS_HighSchool2001", force
append using "use\BJPolS_HighSchool2002", force
append using "use\BJPolS_HighSchool2003", force
append using "use\BJPolS_HighSchool2004", force
append using "use\BJPolS_HighSchool2005", force
append using "use\BJPolS_HighSchool2006", force
append using "use\BJPolS_HighSchool2007", force
append using "use\BJPolS_HighSchool2008", force
append using "use\BJPolS_HighSchool2009", force
append using "use\BJPolS_HighSchool2010", force
bysort Person_ID: keep if _n==1 /*remove duplicates */
save "use\BJPolS_HighSchool1985_2010", replace 
************************************************


* STANDARDIZE OVERALL GPA AND SOCIETYKNOWLEDGE GPA BY EXAMINATION YEAR
set more off
use "use\BJPolS_HighSchool1985_2010", clear
capture rename dnr2014115 Person_ID
forvalues I=1985(1)2010{
egen StandOverallGPA`I'=std(HighSchoolOverallGPA) if ExaminationYearHighSchool==`I'
egen StandSocietyGPA`I'=std(SocietyKnowlegdeGPA) if ExaminationYearHighSchool==`I'
}
*
gen StandHSOverallGPA=.
gen StandHSSocietyGPA=.

forvalues I=1985(1)2010{
replace StandHSOverallGPA=StandOverallGPA`I' if StandHSOverallGPA==. 
replace StandHSSocietyGPA=StandSocietyGPA`I' if StandHSSocietyGPA==.
}
*
keep Person_ID ExaminationYearHighSchool StandHSOverallGPA StandHSSocietyGPA 
order Person_ID ExaminationYearHighSchool StandHSOverallGPA StandHSSocietyGPA  
save "use\BJPolS_HighSchool1985_2010Std", replace
**********************************************************************







* work with social studies A, B and C separately

* Social studies A, 1997-2010
* WORK WITH 1997 HIGHSCHOOL FILE*************************************************************
use "raw\Gymnavg1997", clear
capture rename dnr2014115 Person_ID
drop if jmftal==0
keep if kurskod=="SH200" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge A grade*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M"
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID argang jmftal betyg
order Person_ID argang jmftal betyg
rename argang ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA_A 
replace SocietyKnowlegdeGPA_A="0" if SocietyKnowlegdeGPA=="I" 
replace SocietyKnowlegdeGPA_A="10" if SocietyKnowlegdeGPA=="G" 
replace SocietyKnowlegdeGPA_A="15" if SocietyKnowlegdeGPA=="V" 
replace SocietyKnowlegdeGPA_A="20" if SocietyKnowlegdeGPA=="M" 
destring SocietyKnowlegdeGPA_A, replace 
save "use\BJPolS_HighSchool1997_A", replace 
********************************************************************************************************************************************

* WORK WITH 1998 HIGHSCHOOL FILE*************************************************************
use "raw\Gymnavg1998", clear
capture rename dnr2014115 Person_ID
 
drop if jmftal==0
keep if kurskod=="SH200" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge A grade*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M"
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID argang jmftal betyg
order Person_ID argang jmftal betyg
rename argang ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA_A 
replace SocietyKnowlegdeGPA_A="0" if SocietyKnowlegdeGPA=="I" 
replace SocietyKnowlegdeGPA_A="10" if SocietyKnowlegdeGPA=="G" 
replace SocietyKnowlegdeGPA_A="15" if SocietyKnowlegdeGPA=="V" 
replace SocietyKnowlegdeGPA_A="20" if SocietyKnowlegdeGPA=="M" 
destring SocietyKnowlegdeGPA_A, replace 
save "use\BJPolS_HighSchool1998_A", replace 
********************************************************************************************************************************************

* WORK WITH 1999 HIGHSCHOOL FILE*************************************************************
use "raw\Gymnavg1999", clear
capture rename dnr2014115 Person_ID

drop if jmftal==0
keep if kurskod=="SH200" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge A grade*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M"
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID argang jmftal betyg
order Person_ID argang jmftal betyg
rename argang ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA_A 
replace SocietyKnowlegdeGPA_A="0" if SocietyKnowlegdeGPA=="I" 
replace SocietyKnowlegdeGPA_A="10" if SocietyKnowlegdeGPA=="G" 
replace SocietyKnowlegdeGPA_A="15" if SocietyKnowlegdeGPA=="V" 
replace SocietyKnowlegdeGPA_A="20" if SocietyKnowlegdeGPA=="M" 
destring SocietyKnowlegdeGPA_A, replace
save "use\BJPolS_HighSchool1999_A", replace 
********************************************************************************************************************************************

* WORK WITH 2000 HIGHSCHOOL FILE*************************************************************
use "raw\Gymnavg2000", clear
capture rename dnr2014115 Person_ID

drop if jmftal==0
keep if kurskod=="SH200" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge A grade*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M"
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID argang jmftal betyg
order Person_ID argang jmftal betyg
rename argang ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA_A 
replace SocietyKnowlegdeGPA_A="0" if SocietyKnowlegdeGPA=="I" 
replace SocietyKnowlegdeGPA_A="10" if SocietyKnowlegdeGPA=="G" 
replace SocietyKnowlegdeGPA_A="15" if SocietyKnowlegdeGPA=="V" 
replace SocietyKnowlegdeGPA_A="20" if SocietyKnowlegdeGPA=="M" 
destring SocietyKnowlegdeGPA_A, replace
save "use\BJPolS_HighSchool2000_A", replace 
********************************************************************************************************************************************

* WORK WITH 2001 HIGHSCHOOL FILE*************************************************************
use "raw\Gymnavg2001", clear
capture rename dnr2014115 Person_ID

drop if jmftal==0
keep if kurskod=="SH200" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge A grade*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M"
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID argang jmftal betyg
order Person_ID argang jmftal betyg
rename argang ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA_A 
replace SocietyKnowlegdeGPA_A="0" if SocietyKnowlegdeGPA=="I" 
replace SocietyKnowlegdeGPA_A="10" if SocietyKnowlegdeGPA=="G" 
replace SocietyKnowlegdeGPA_A="15" if SocietyKnowlegdeGPA=="V" 
replace SocietyKnowlegdeGPA_A="20" if SocietyKnowlegdeGPA=="M" 
destring SocietyKnowlegdeGPA_A, replace
save "use\BJPolS_HighSchool2001_A", replace 
********************************************************************************************************************************************

* WORK WITH 2002 HIGHSCHOOL FILES*************************************************************
* clean the "raw\Gymnavg2002elev" file 
use "raw\Gymnavg2002elev", clear
capture rename dnr2014115 Person_ID
bysort Person_ID: keep if _n==1
save "temp\BJPolS_Gymnavg2002elev", replace
*********
use "raw\Gymnavg2002kurs", clear
capture rename dnr2014115 Person_ID
merge m:1 Person_ID using "temp\BJPolS_Gymnavg2002elev", keep(match master) keepusing(jmftal) 
destring jmftal, replace
drop if jmftal==0
keep if kurskod=="SH1201" | kurskod=="SH200"  /* every individual has one observation per course, keep the course that carries the SocietyKnowledge A grade*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M"
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID avgangsar jmftal betyg
order Person_ID avgangsar jmftal betyg
rename avgangsar ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA_A 
replace SocietyKnowlegdeGPA_A="0" if SocietyKnowlegdeGPA=="I" 
replace SocietyKnowlegdeGPA_A="10" if SocietyKnowlegdeGPA=="G" 
replace SocietyKnowlegdeGPA_A="15" if SocietyKnowlegdeGPA=="V" 
replace SocietyKnowlegdeGPA_A="20" if SocietyKnowlegdeGPA=="M" 
destring SocietyKnowlegdeGPA_A, replace
save "use\BJPolS_HighSchool2002_A", replace 
********************************************************************************************************************************************

* WORK WITH 2003 HIGHSCHOOL FILES*************************************************************
* clean the "raw\Gymnavg2003elev" file 
use "raw\Gymnavg2003elev", clear
capture rename dnr2014115 Person_ID
bysort Person_ID: keep if _n==1
save "temp\BJPolS_Gymnavg2003elev", replace
*********
use "raw\Gymnavg2003kurs", clear
capture rename dnr2014115 Person_ID
merge m:1 Person_ID using "temp\BJPolS_Gymnavg2003elev", keep(match master) keepusing(jmftal) 
destring jmftal, replace
drop if jmftal==0
keep if kurskod=="SH1201" | kurskod=="SH200" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge A grade*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M" | betyg=="IG" | betyg=="VG" | betyg=="MVG" 
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID avgangsar jmftal betyg
order Person_ID avgangsar jmftal betyg
rename avgangsar ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA_A 
replace SocietyKnowlegdeGPA_A="0" if SocietyKnowlegdeGPA_A=="I" | SocietyKnowlegdeGPA=="IG"  
replace SocietyKnowlegdeGPA_A="10" if SocietyKnowlegdeGPA_A=="G" 
replace SocietyKnowlegdeGPA_A="15" if SocietyKnowlegdeGPA_A=="V" | SocietyKnowlegdeGPA=="VG"   
replace SocietyKnowlegdeGPA_A="20" if SocietyKnowlegdeGPA_A=="M" | SocietyKnowlegdeGPA=="MVG"  
destring SocietyKnowlegdeGPA_A, replace
save "use\BJPolS_HighSchool2003_A", replace 
********************************************************************************************************************************************

* WORK WITH 2004 HIGHSCHOOL FILES*************************************************************
* clean the "raw\Gymnavg2004elev" file 
use "raw\Gymnavg2004elev", clear
capture rename dnr2014115 Person_ID
bysort Person_ID: keep if _n==1
save "temp\BJPolS_Gymnavg2004elev", replace
*********
use "raw\Gymnavg2004kurs", clear
capture rename dnr2014115 Person_ID
merge m:1 Person_ID using "temp\BJPolS_Gymnavg2004elev", keep(match master) keepusing(jmftal) 
destring jmftal, replace
drop if jmftal==0
keep if kurskod=="SH1201" | kurskod=="SH200" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge A grade*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M" | betyg=="IG" | betyg=="VG" | betyg=="MVG" 
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID avgangsar jmftal betyg
order Person_ID avgangsar jmftal betyg
rename avgangsar ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA_A 
replace SocietyKnowlegdeGPA_A="0" if SocietyKnowlegdeGPA_A=="I" | SocietyKnowlegdeGPA=="IG"  
replace SocietyKnowlegdeGPA_A="10" if SocietyKnowlegdeGPA_A=="G" 
replace SocietyKnowlegdeGPA_A="15" if SocietyKnowlegdeGPA_A=="V" | SocietyKnowlegdeGPA=="VG"   
replace SocietyKnowlegdeGPA_A="20" if SocietyKnowlegdeGPA_A=="M" | SocietyKnowlegdeGPA=="MVG"  
destring SocietyKnowlegdeGPA_A, replace
save "use\BJPolS_HighSchool2004_A", replace 
********************************************************************************************************************************************

* WORK WITH 2005 HIGHSCHOOL FILES*************************************************************
* clean the "raw\Gymnavg2005elev" file 
use "raw\Gymnavg2005elev", clear
capture rename dnr2014115 Person_ID
bysort Person_ID: keep if _n==1
save "temp\BJPolS_Gymnavg2005elev", replace
*********
use "raw\Gymnavg2005kurs", clear
capture rename dnr2014115 Person_ID
merge m:1 Person_ID using "temp\BJPolS_Gymnavg2005elev", keep(match master) keepusing(jmftal)  
destring jmftal, replace
drop if jmftal==0
keep if kurskod=="SH1201" | kurskod=="SH200" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge A grade*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M" | betyg=="IG" | betyg=="VG" | betyg=="MVG" 
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID avgangsar jmftal betyg
order Person_ID avgangsar jmftal betyg
rename avgangsar ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA_A 
replace SocietyKnowlegdeGPA_A="0" if SocietyKnowlegdeGPA_A=="I" | SocietyKnowlegdeGPA=="IG"  
replace SocietyKnowlegdeGPA_A="10" if SocietyKnowlegdeGPA_A=="G" 
replace SocietyKnowlegdeGPA_A="15" if SocietyKnowlegdeGPA_A=="V" | SocietyKnowlegdeGPA=="VG"   
replace SocietyKnowlegdeGPA_A="20" if SocietyKnowlegdeGPA_A=="M" | SocietyKnowlegdeGPA=="MVG"  
destring SocietyKnowlegdeGPA_A, replace
save "use\BJPolS_HighSchool2005_A", replace 
******************************************************************************************************

* WORK WITH 2006 HIGHSCHOOL FILES*************************************************************
* clean the "raw\Gymnavg2006elev" file 
use "raw\Gymnavg2006elev", clear
capture rename dnr2014115 Person_ID
bysort Person_ID: keep if _n==1
save "temp\BJPolS_Gymnavg2006elev", replace
*********
use "raw\Gymnavg2006kurs", clear
capture rename dnr2014115 Person_ID
merge m:1 Person_ID using "temp\BJPolS_Gymnavg2006elev", keep(match master) keepusing(jmftal) 
destring avgangsar, replace 
destring jmftal, replace
drop if jmftal==0
keep if kurskod=="SH1201" | kurskod=="SH200" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge A grade*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M" | betyg=="IG" | betyg=="VG" | betyg=="MVG" 
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID avgangsar jmftal betyg
order Person_ID avgangsar jmftal betyg
rename avgangsar ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA_A 
replace SocietyKnowlegdeGPA_A="0" if SocietyKnowlegdeGPA_A=="I" | SocietyKnowlegdeGPA=="IG"  
replace SocietyKnowlegdeGPA_A="10" if SocietyKnowlegdeGPA_A=="G" 
replace SocietyKnowlegdeGPA_A="15" if SocietyKnowlegdeGPA_A=="V" | SocietyKnowlegdeGPA=="VG"   
replace SocietyKnowlegdeGPA_A="20" if SocietyKnowlegdeGPA_A=="M" | SocietyKnowlegdeGPA=="MVG"  
destring SocietyKnowlegdeGPA_A, replace 
save "use\BJPolS_HighSchool2006_A", replace 
******************************************************************************************************

* WORK WITH 2007 HIGHSCHOOL FILES*************************************************************
* clean the "raw\Gymnavg2007elev" file 
use "raw\Gymnavg2007elev", clear
capture rename dnr2014115 Person_ID
bysort Person_ID: keep if _n==1
save "temp\BJPolS_Gymnavg2007elev", replace
*********
use "raw\Gymnavg2007kurs", clear
capture rename dnr2014115 Person_ID
merge m:1 Person_ID using "temp\BJPolS_Gymnavg2007elev", keep(match master) keepusing(jmftal) 
destring ar, replace
destring jmftal, replace
drop if jmftal==0
keep if kurskod=="SH1201" | kurskod=="SH200" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge A grade*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M" | betyg=="IG" | betyg=="VG" | betyg=="MVG" 
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID ar jmftal betyg
order Person_ID ar jmftal betyg
rename ar ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA_A 
replace SocietyKnowlegdeGPA_A="0" if SocietyKnowlegdeGPA_A=="I" | SocietyKnowlegdeGPA=="IG"  
replace SocietyKnowlegdeGPA_A="10" if SocietyKnowlegdeGPA_A=="G" 
replace SocietyKnowlegdeGPA_A="15" if SocietyKnowlegdeGPA_A=="V" | SocietyKnowlegdeGPA=="VG"   
replace SocietyKnowlegdeGPA_A="20" if SocietyKnowlegdeGPA_A=="M" | SocietyKnowlegdeGPA=="MVG"  
destring SocietyKnowlegdeGPA_A, replace
save "use\BJPolS_HighSchool2007_A", replace 
******************************************************************************************************

* WORK WITH 2008 HIGHSCHOOL FILES*************************************************************
* clean the "raw\Gymnavg2008elev" file 
use "raw\Gymnavg2008elev", clear
capture rename dnr2014115 Person_ID
bysort Person_ID: keep if _n==1
save "temp\BJPolS_Gymnavg2008elev", replace
*********
use "raw\Gymnavg2008kurs", clear
capture rename dnr2014115 Person_ID
merge m:1 Person_ID using "temp\BJPolS_Gymnavg2008elev", keep(match master) keepusing(jmftal) 
destring ar, replace
destring jmftal, replace
drop if jmftal==0
keep if kurskod=="SH1201" | kurskod=="SH200" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge A grade*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M" | betyg=="IG" | betyg=="VG" | betyg=="MVG" 
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID ar jmftal betyg
order Person_ID ar jmftal betyg
rename ar ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA_A 
replace SocietyKnowlegdeGPA_A="0" if SocietyKnowlegdeGPA_A=="I" | SocietyKnowlegdeGPA=="IG"  
replace SocietyKnowlegdeGPA_A="10" if SocietyKnowlegdeGPA_A=="G" 
replace SocietyKnowlegdeGPA_A="15" if SocietyKnowlegdeGPA_A=="V" | SocietyKnowlegdeGPA=="VG"   
replace SocietyKnowlegdeGPA_A="20" if SocietyKnowlegdeGPA_A=="M" | SocietyKnowlegdeGPA=="MVG"  
destring SocietyKnowlegdeGPA_A, replace
save "use\BJPolS_HighSchool2008_A", replace 
******************************************************************************************************

* WORK WITH 2009 HIGHSCHOOL FILES*************************************************************
* clean the "raw\Gymnavg2009elev" file 
use "raw\Gymnavg2009elev", clear
capture rename dnr2014115 Person_ID
bysort Person_ID: keep if _n==1
save "temp\BJPolS_Gymnavg2009elev", replace
*********
use "raw\Gymnavg2009kurs", clear
capture rename dnr2014115 Person_ID
merge m:1 Person_ID using "temp\BJPolS_Gymnavg2009elev", keep(match master) keepusing(jmftal) 
destring ar, replace
destring jmftal, replace
drop if jmftal==0
keep if kurskod=="SH1201" | kurskod=="SH200" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge A grade*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M" | betyg=="IG" | betyg=="VG" | betyg=="MVG" 
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID ar jmftal betyg
order Person_ID ar jmftal betyg
rename ar ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA_A 
replace SocietyKnowlegdeGPA_A="0" if SocietyKnowlegdeGPA_A=="I" | SocietyKnowlegdeGPA=="IG"  
replace SocietyKnowlegdeGPA_A="10" if SocietyKnowlegdeGPA_A=="G" 
replace SocietyKnowlegdeGPA_A="15" if SocietyKnowlegdeGPA_A=="V" | SocietyKnowlegdeGPA=="VG"   
replace SocietyKnowlegdeGPA_A="20" if SocietyKnowlegdeGPA_A=="M" | SocietyKnowlegdeGPA=="MVG"  
destring SocietyKnowlegdeGPA_A, replace
save "use\BJPolS_HighSchool2009_A", replace 
******************************************************************************************************

* WORK WITH 2010 HIGHSCHOOL FILES*************************************************************
* clean the "raw\Gymnavg2009elev" file 
use "raw\Gymnavg2010elev", clear
capture rename dnr2014115 Person_ID
bysort Person_ID: keep if _n==1
save "temp\BJPolS_Gymnavg2010elev", replace
*********
use "raw\Gymnavg2010kurs", clear
capture rename dnr2014115 Person_ID
merge m:1 Person_ID using "temp\BJPolS_Gymnavg2010elev", keep(match master) keepusing(jmftal) 
destring ar, replace
destring jmftal, replace
drop if jmftal==0
keep if kurskod=="SH1201" | kurskod=="SH200" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge A grade*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M" | betyg=="IG" | betyg=="VG" | betyg=="MVG" 
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID ar jmftal betyg
order Person_ID ar jmftal betyg
rename ar ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA_A 
replace SocietyKnowlegdeGPA_A="0" if SocietyKnowlegdeGPA_A=="I" | SocietyKnowlegdeGPA=="IG"  
replace SocietyKnowlegdeGPA_A="10" if SocietyKnowlegdeGPA_A=="G" 
replace SocietyKnowlegdeGPA_A="15" if SocietyKnowlegdeGPA_A=="V" | SocietyKnowlegdeGPA=="VG"   
replace SocietyKnowlegdeGPA_A="20" if SocietyKnowlegdeGPA_A=="M" | SocietyKnowlegdeGPA=="MVG"  
destring SocietyKnowlegdeGPA_A, replace 
save "use\BJPolS_HighSchool2010_A", replace 
******************************************************************************************************


* PUT TOGETHER ALL THE  HIGH SCHOOL FILES	
use "use\BJPolS_HighSchool1997_A", clear
capture rename dnr2014115 Person_ID
append using "use\BJPolS_HighSchool1998_A", force
append using "use\BJPolS_HighSchool1999_A", force
append using "use\BJPolS_HighSchool2000_A", force
append using "use\BJPolS_HighSchool2001_A", force
append using "use\BJPolS_HighSchool2002_A", force
append using "use\BJPolS_HighSchool2003_A", force
append using "use\BJPolS_HighSchool2004_A", force
append using "use\BJPolS_HighSchool2005_A", force
append using "use\BJPolS_HighSchool2006_A", force
append using "use\BJPolS_HighSchool2007_A", force
append using "use\BJPolS_HighSchool2008_A", force
append using "use\BJPolS_HighSchool2009_A", force
append using "use\BJPolS_HighSchool2010_A", force
bysort Person_ID: keep if _n==1 /* remove duplicates */
save "use\BJPolS_HighSchool1997_2010_A", replace 
************************************************


* STANDARDIZE SOCIETYKNOWLEDGE A GPA BY EXAMINATION YEAR
set more off
use "use\BJPolS_HighSchool1997_2010_A", clear
capture rename dnr2014115 Person_ID
forvalues I=1997(1)2010{
egen StandSocietyGPA_A`I'=std(SocietyKnowlegdeGPA_A) if ExaminationYearHighSchool==`I'
}
*

gen StandHSSocietyGPA_A=.

forvalues I=1997(1)2010{
replace StandHSSocietyGPA_A=StandSocietyGPA_A`I' if StandHSSocietyGPA_A==.
}
*
keep Person_ID ExaminationYearHighSchool StandHSSocietyGPA_A 
order Person_ID ExaminationYearHighSchool StandHSSocietyGPA_A  
save "use\BJPolS_HighSchool1997_2010_A_Std", replace
**********************************************************************






* Social studies B, 1997-2010
* WORK WITH 1997 HIGHSCHOOL FILE*************************************************************
use "raw\Gymnavg1997", clear
capture rename dnr2014115 Person_ID
drop if jmftal==0
keep if kurskod=="SH201" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge B grade, Samhällskunskap B*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M"
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID argang jmftal betyg
order Person_ID argang jmftal betyg
rename argang ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA_B 
replace SocietyKnowlegdeGPA_B="0" if SocietyKnowlegdeGPA=="I" 
replace SocietyKnowlegdeGPA_B="10" if SocietyKnowlegdeGPA=="G" 
replace SocietyKnowlegdeGPA_B="15" if SocietyKnowlegdeGPA=="V" 
replace SocietyKnowlegdeGPA_B="20" if SocietyKnowlegdeGPA=="M" 
destring SocietyKnowlegdeGPA_B, replace 
save "use\BJPolS_HighSchool1997_B", replace 
********************************************************************************************************************************************

* WORK WITH 1998 HIGHSCHOOL FILE*************************************************************
use "raw\Gymnavg1998", clear
capture rename dnr2014115 Person_ID 
drop if jmftal==0
keep if kurskod=="SH201" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge B grade, Samhällskunskap B*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M"
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID argang jmftal betyg
order Person_ID argang jmftal betyg
rename argang ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA_B 
replace SocietyKnowlegdeGPA_B="0" if SocietyKnowlegdeGPA=="I" 
replace SocietyKnowlegdeGPA_B="10" if SocietyKnowlegdeGPA=="G" 
replace SocietyKnowlegdeGPA_B="15" if SocietyKnowlegdeGPA=="V" 
replace SocietyKnowlegdeGPA_B="20" if SocietyKnowlegdeGPA=="M" 
destring SocietyKnowlegdeGPA_B, replace 
save "use\BJPolS_HighSchool1998_B", replace 
********************************************************************************************************************************************

* WORK WITH 1999 HIGHSCHOOL FILE*************************************************************
use "raw\Gymnavg1999", clear
capture rename dnr2014115 Person_ID
drop if jmftal==0
keep if kurskod=="SH201" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge B grade, Samhällskunskap B*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M"
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID argang jmftal betyg
order Person_ID argang jmftal betyg
rename argang ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA_B 
replace SocietyKnowlegdeGPA_B="0" if SocietyKnowlegdeGPA=="I" 
replace SocietyKnowlegdeGPA_B="10" if SocietyKnowlegdeGPA=="G" 
replace SocietyKnowlegdeGPA_B="15" if SocietyKnowlegdeGPA=="V" 
replace SocietyKnowlegdeGPA_B="20" if SocietyKnowlegdeGPA=="M" 
destring SocietyKnowlegdeGPA_B, replace
save "use\BJPolS_HighSchool1999_B", replace 
********************************************************************************************************************************************

* WORK WITH 2000 HIGHSCHOOL FILE*************************************************************
use "raw\Gymnavg2000", clear
capture rename dnr2014115 Person_ID
drop if jmftal==0
keep if kurskod=="SH201" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge B grade, Samhällskunskap B*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M"
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID argang jmftal betyg
order Person_ID argang jmftal betyg
rename argang ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA_B 
replace SocietyKnowlegdeGPA_B="0" if SocietyKnowlegdeGPA=="I" 
replace SocietyKnowlegdeGPA_B="10" if SocietyKnowlegdeGPA=="G" 
replace SocietyKnowlegdeGPA_B="15" if SocietyKnowlegdeGPA=="V" 
replace SocietyKnowlegdeGPA_B="20" if SocietyKnowlegdeGPA=="M" 
destring SocietyKnowlegdeGPA_B, replace
save "use\BJPolS_HighSchool2000_B", replace 
********************************************************************************************************************************************

* WORK WITH 2001 HIGHSCHOOL FILE*************************************************************
use "raw\Gymnavg2001", clear
capture rename dnr2014115 Person_ID 
drop if jmftal==0
keep if kurskod=="SH201" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge B grade, Samhällskunskap B*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M"
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID argang jmftal betyg
order Person_ID argang jmftal betyg
rename argang ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA_B 
replace SocietyKnowlegdeGPA_B="0" if SocietyKnowlegdeGPA=="I" 
replace SocietyKnowlegdeGPA_B="10" if SocietyKnowlegdeGPA=="G" 
replace SocietyKnowlegdeGPA_B="15" if SocietyKnowlegdeGPA=="V" 
replace SocietyKnowlegdeGPA_B="20" if SocietyKnowlegdeGPA=="M" 
destring SocietyKnowlegdeGPA_B, replace
save "use\BJPolS_HighSchool2001_B", replace 
********************************************************************************************************************************************

* WORK WITH 2002 HIGHSCHOOL FILES*************************************************************
* clean the "raw\Gymnavg2002elev" file 
use "raw\Gymnavg2002elev", clear
capture rename dnr2014115 Person_ID
bysort Person_ID: keep if _n==1
save "temp\BJPolS_Gymnavg2002elev", replace
*********
use "raw\Gymnavg2002kurs", clear
capture rename dnr2014115 Person_ID
merge m:1 Person_ID using "temp\BJPolS_Gymnavg2002elev", keep(match master) keepusing(jmftal) 
destring jmftal, replace
drop if jmftal==0
keep if kurskod=="SH1202" | kurskod=="SH201"  /* every individual has one observation per course, keep the course that carries the SocietyKnowledge B grade, Samhällskunskap B*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M"
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID avgangsar jmftal betyg
order Person_ID avgangsar jmftal betyg
rename avgangsar ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA_B 
replace SocietyKnowlegdeGPA_B="0" if SocietyKnowlegdeGPA=="I" 
replace SocietyKnowlegdeGPA_B="10" if SocietyKnowlegdeGPA=="G" 
replace SocietyKnowlegdeGPA_B="15" if SocietyKnowlegdeGPA=="V" 
replace SocietyKnowlegdeGPA_B="20" if SocietyKnowlegdeGPA=="M" 
destring SocietyKnowlegdeGPA_B, replace
save "use\BJPolS_HighSchool2002_B", replace 
********************************************************************************************************************************************

* WORK WITH 2003 HIGHSCHOOL FILES*************************************************************
* clean the "raw\Gymnavg2003elev" file 
use "raw\Gymnavg2003elev", clear
capture rename dnr2014115 Person_ID
bysort Person_ID: keep if _n==1
save "temp\BJPolS_Gymnavg2003elev", replace
*********
use "raw\Gymnavg2003kurs", clear
capture rename dnr2014115 Person_ID
merge m:1 Person_ID using "temp\BJPolS_Gymnavg2003elev", keep(match master) keepusing(jmftal) 
destring jmftal, replace
drop if jmftal==0
keep if kurskod=="SH1202" | kurskod=="SH201" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge B grade, Samhällskunskap B*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M" | betyg=="IG" | betyg=="VG" | betyg=="MVG" 
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID avgangsar jmftal betyg
order Person_ID avgangsar jmftal betyg
rename avgangsar ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA_B 
replace SocietyKnowlegdeGPA_B="0" if SocietyKnowlegdeGPA_B=="I" | SocietyKnowlegdeGPA=="IG"  
replace SocietyKnowlegdeGPA_B="10" if SocietyKnowlegdeGPA_B=="G" 
replace SocietyKnowlegdeGPA_B="15" if SocietyKnowlegdeGPA_B=="V" | SocietyKnowlegdeGPA=="VG"   
replace SocietyKnowlegdeGPA_B="20" if SocietyKnowlegdeGPA_B=="M" | SocietyKnowlegdeGPA=="MVG"  
destring SocietyKnowlegdeGPA_B, replace
save "use\BJPolS_HighSchool2003_B", replace 
********************************************************************************************************************************************

* WORK WITH 2004 HIGHSCHOOL FILES*************************************************************
* clean the "raw\Gymnavg2004elev" file 
use "raw\Gymnavg2004elev", clear
capture rename dnr2014115 Person_ID
bysort Person_ID: keep if _n==1
save "temp\BJPolS_Gymnavg2004elev", replace
*********
use "raw\Gymnavg2004kurs", clear
capture rename dnr2014115 Person_ID
merge m:1 Person_ID using "temp\BJPolS_Gymnavg2004elev", keep(match master) keepusing(jmftal) 
destring jmftal, replace
drop if jmftal==0
keep if kurskod=="SH1202" | kurskod=="SH201" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge B grade, Samhällskunskap B*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M" | betyg=="IG" | betyg=="VG" | betyg=="MVG" 
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID avgangsar jmftal betyg
order Person_ID avgangsar jmftal betyg
rename avgangsar ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA_B 
replace SocietyKnowlegdeGPA_B="0" if SocietyKnowlegdeGPA_B=="I" | SocietyKnowlegdeGPA=="IG"  
replace SocietyKnowlegdeGPA_B="10" if SocietyKnowlegdeGPA_B=="G" 
replace SocietyKnowlegdeGPA_B="15" if SocietyKnowlegdeGPA_B=="V" | SocietyKnowlegdeGPA=="VG"   
replace SocietyKnowlegdeGPA_B="20" if SocietyKnowlegdeGPA_B=="M" | SocietyKnowlegdeGPA=="MVG"  
destring SocietyKnowlegdeGPA_B, replace
save "use\BJPolS_HighSchool2004_B", replace 
********************************************************************************************************************************************

* WORK WITH 2005 HIGHSCHOOL FILES*************************************************************
* clean the "raw\Gymnavg2005elev" file 
use "raw\Gymnavg2005elev", clear
capture rename dnr2014115 Person_ID
bysort Person_ID: keep if _n==1
save "temp\BJPolS_Gymnavg2005elev", replace
*********
use "raw\Gymnavg2005kurs", clear
capture rename dnr2014115 Person_ID
merge m:1 Person_ID using "temp\BJPolS_Gymnavg2005elev", keep(match master) keepusing(jmftal) 
destring jmftal, replace
drop if jmftal==0
keep if kurskod=="SH1202" | kurskod=="SH201" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge B grade, Samhällskunskap B*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M" | betyg=="IG" | betyg=="VG" | betyg=="MVG" 
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID avgangsar jmftal betyg
order Person_ID avgangsar jmftal betyg
rename avgangsar ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA_B 
replace SocietyKnowlegdeGPA_B="0" if SocietyKnowlegdeGPA_B=="I" | SocietyKnowlegdeGPA=="IG"  
replace SocietyKnowlegdeGPA_B="10" if SocietyKnowlegdeGPA_B=="G" 
replace SocietyKnowlegdeGPA_B="15" if SocietyKnowlegdeGPA_B=="V" | SocietyKnowlegdeGPA=="VG"   
replace SocietyKnowlegdeGPA_B="20" if SocietyKnowlegdeGPA_B=="M" | SocietyKnowlegdeGPA=="MVG"  
destring SocietyKnowlegdeGPA_B, replace
save "use\BJPolS_HighSchool2005_B", replace 
******************************************************************************************************

* WORK WITH 2006 HIGHSCHOOL FILES*************************************************************
* clean the "raw\Gymnavg2006elev" file 
use "raw\Gymnavg2006elev", clear
capture rename dnr2014115 Person_ID
bysort Person_ID: keep if _n==1
save "temp\BJPolS_Gymnavg2006elev", replace
*********
use "raw\Gymnavg2006kurs", clear
capture rename dnr2014115 Person_ID
merge m:1 Person_ID using "temp\BJPolS_Gymnavg2006elev", keep(match master) keepusing(jmftal) 
destring avgangsar, replace 
destring jmftal, replace
drop if jmftal==0
keep if kurskod=="SH1202" | kurskod=="SH201" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge B grade, Samhällskunskap B*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M" | betyg=="IG" | betyg=="VG" | betyg=="MVG" 
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID avgangsar jmftal betyg
order Person_ID avgangsar jmftal betyg
rename avgangsar ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA_B 
replace SocietyKnowlegdeGPA_B="0" if SocietyKnowlegdeGPA_B=="I" | SocietyKnowlegdeGPA=="IG"  
replace SocietyKnowlegdeGPA_B="10" if SocietyKnowlegdeGPA_B=="G" 
replace SocietyKnowlegdeGPA_B="15" if SocietyKnowlegdeGPA_B=="V" | SocietyKnowlegdeGPA=="VG"   
replace SocietyKnowlegdeGPA_B="20" if SocietyKnowlegdeGPA_B=="M" | SocietyKnowlegdeGPA=="MVG"  
destring SocietyKnowlegdeGPA_B, replace 
save "use\BJPolS_HighSchool2006_B", replace 
******************************************************************************************************

* WORK WITH 2007 HIGHSCHOOL FILES*************************************************************
* clean the "raw\Gymnavg2007elev" file 
use "raw\Gymnavg2007elev", clear
capture rename dnr2014115 Person_ID
bysort Person_ID: keep if _n==1
save "temp\BJPolS_Gymnavg2007elev", replace
*********
use "raw\Gymnavg2007kurs", clear
capture rename dnr2014115 Person_ID
merge m:1 Person_ID using "temp\BJPolS_Gymnavg2007elev", keep(match master) keepusing(jmftal) 
destring ar, replace
destring jmftal, replace
drop if jmftal==0
keep if kurskod=="SH1202" | kurskod=="SH201" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge B grade, Samhällskunskap B*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M" | betyg=="IG" | betyg=="VG" | betyg=="MVG" 
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID ar jmftal betyg
order Person_ID ar jmftal betyg
rename ar ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA_B 
replace SocietyKnowlegdeGPA_B="0" if SocietyKnowlegdeGPA_B=="I" | SocietyKnowlegdeGPA=="IG"  
replace SocietyKnowlegdeGPA_B="10" if SocietyKnowlegdeGPA_B=="G" 
replace SocietyKnowlegdeGPA_B="15" if SocietyKnowlegdeGPA_B=="V" | SocietyKnowlegdeGPA=="VG"   
replace SocietyKnowlegdeGPA_B="20" if SocietyKnowlegdeGPA_B=="M" | SocietyKnowlegdeGPA=="MVG"  
destring SocietyKnowlegdeGPA_B, replace
save "use\BJPolS_HighSchool2007_B", replace 
******************************************************************************************************

* WORK WITH 2008 HIGHSCHOOL FILES*************************************************************
* clean the "raw\Gymnavg2008elev" file 
use "raw\Gymnavg2008elev", clear
capture rename dnr2014115 Person_ID
bysort Person_ID: keep if _n==1
save "temp\BJPolS_Gymnavg2008elev", replace
*********
use "raw\Gymnavg2008kurs", clear
capture rename dnr2014115 Person_ID
merge m:1 Person_ID using "temp\BJPolS_Gymnavg2008elev", keep(match master) keepusing(jmftal) 
destring ar, replace
destring jmftal, replace
drop if jmftal==0
keep if kurskod=="SH1202" | kurskod=="SH201" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge B grade, Samhällskunskap B*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M" | betyg=="IG" | betyg=="VG" | betyg=="MVG" 
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID ar jmftal betyg
order Person_ID ar jmftal betyg
rename ar ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA_B 
replace SocietyKnowlegdeGPA_B="0" if SocietyKnowlegdeGPA_B=="I" | SocietyKnowlegdeGPA=="IG"  
replace SocietyKnowlegdeGPA_B="10" if SocietyKnowlegdeGPA_B=="G" 
replace SocietyKnowlegdeGPA_B="15" if SocietyKnowlegdeGPA_B=="V" | SocietyKnowlegdeGPA=="VG"   
replace SocietyKnowlegdeGPA_B="20" if SocietyKnowlegdeGPA_B=="M" | SocietyKnowlegdeGPA=="MVG"  
destring SocietyKnowlegdeGPA_B, replace
save "use\BJPolS_HighSchool2008_B", replace 
******************************************************************************************************

* WORK WITH 2009 HIGHSCHOOL FILES*************************************************************
* clean the "raw\Gymnavg2009elev" file 
use "raw\Gymnavg2009elev", clear
capture rename dnr2014115 Person_ID
bysort Person_ID: keep if _n==1
save "temp\BJPolS_Gymnavg2009elev", replace
*********
use "raw\Gymnavg2009kurs", clear
capture rename dnr2014115 Person_ID
merge m:1 Person_ID using "temp\BJPolS_Gymnavg2009elev", keep(match master) keepusing(jmftal) 
destring ar, replace
destring jmftal, replace
drop if jmftal==0
keep if kurskod=="SH1202" | kurskod=="SH201" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge B grade, Samhällskunskap B*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M" | betyg=="IG" | betyg=="VG" | betyg=="MVG" 
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID ar jmftal betyg
order Person_ID ar jmftal betyg
rename ar ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA_B 
replace SocietyKnowlegdeGPA_B="0" if SocietyKnowlegdeGPA_B=="I" | SocietyKnowlegdeGPA=="IG"  
replace SocietyKnowlegdeGPA_B="10" if SocietyKnowlegdeGPA_B=="G" 
replace SocietyKnowlegdeGPA_B="15" if SocietyKnowlegdeGPA_B=="V" | SocietyKnowlegdeGPA=="VG"   
replace SocietyKnowlegdeGPA_B="20" if SocietyKnowlegdeGPA_B=="M" | SocietyKnowlegdeGPA=="MVG"  
destring SocietyKnowlegdeGPA_B, replace
save "use\BJPolS_HighSchool2009_B", replace 
******************************************************************************************************

* WORK WITH 2010 HIGHSCHOOL FILES*************************************************************
* clean the "raw\Gymnavg2009elev" file 
use "raw\Gymnavg2010elev", clear
capture rename dnr2014115 Person_ID
bysort Person_ID: keep if _n==1
save "temp\BJPolS_Gymnavg2010elev", replace
*********
use "raw\Gymnavg2010kurs", clear
capture rename dnr2014115 Person_ID
merge m:1 Person_ID using "temp\BJPolS_Gymnavg2010elev", keep(match master) keepusing(jmftal) 
destring ar, replace
destring jmftal, replace
drop if jmftal==0
keep if kurskod=="SH1202" | kurskod=="SH201" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge B grade, Samhällskunskap B*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M" | betyg=="IG" | betyg=="VG" | betyg=="MVG" 
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID ar jmftal betyg
order Person_ID ar jmftal betyg
rename ar ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA_B 
replace SocietyKnowlegdeGPA_B="0" if SocietyKnowlegdeGPA_B=="I" | SocietyKnowlegdeGPA=="IG"  
replace SocietyKnowlegdeGPA_B="10" if SocietyKnowlegdeGPA_B=="G" 
replace SocietyKnowlegdeGPA_B="15" if SocietyKnowlegdeGPA_B=="V" | SocietyKnowlegdeGPA=="VG"   
replace SocietyKnowlegdeGPA_B="20" if SocietyKnowlegdeGPA_B=="M" | SocietyKnowlegdeGPA=="MVG"  
destring SocietyKnowlegdeGPA_B, replace 
save "use\BJPolS_HighSchool2010_B", replace 
******************************************************************************************************


* PUT TOGETHER ALL THE  HIGH SCHOOL FILES	
use "use\BJPolS_HighSchool1997_B", clear
capture rename dnr2014115 Person_ID
append using "use\BJPolS_HighSchool1998_B", force
append using "use\BJPolS_HighSchool1999_B", force
append using "use\BJPolS_HighSchool2000_B", force
append using "use\BJPolS_HighSchool2001_B", force
append using "use\BJPolS_HighSchool2002_B", force
append using "use\BJPolS_HighSchool2003_B", force
append using "use\BJPolS_HighSchool2004_B", force
append using "use\BJPolS_HighSchool2005_B", force
append using "use\BJPolS_HighSchool2006_B", force
append using "use\BJPolS_HighSchool2007_B", force
append using "use\BJPolS_HighSchool2008_B", force
append using "use\BJPolS_HighSchool2009_B", force
append using "use\BJPolS_HighSchool2010_B", force
bysort Person_ID: keep if _n==1 /* remove duplicates */
save "use\BJPolS_HighSchool1997_2010_B", replace 
************************************************


* STANDARDIZE SOCIETYKNOWLEDGE B GPA BY EXAMINATION YEAR
set more off
use "use\BJPolS_HighSchool1997_2010_B", clear
capture rename dnr2014115 Person_ID
forvalues I=1997(1)2010{
egen StandSocietyGPA_B`I'=std(SocietyKnowlegdeGPA_B) if ExaminationYearHighSchool==`I'
}
*

gen StandHSSocietyGPA_B=.

forvalues I=1997(1)2010{
replace StandHSSocietyGPA_B=StandSocietyGPA_B`I' if StandHSSocietyGPA_B==.
}
*
keep Person_ID ExaminationYearHighSchool StandHSSocietyGPA_B 
order Person_ID ExaminationYearHighSchool StandHSSocietyGPA_B  
save "use\BJPolS_HighSchool1997_2010_B_Std", replace
**********************************************************************







* Social studies C, 1997-2010
* WORK WITH 1997 HIGHSCHOOL FILE*************************************************************
use "raw\Gymnavg1997", clear
capture rename dnr2014115 Person_ID
drop if jmftal==0
keep if kurskod=="SH202" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge C grade*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M"
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID argang jmftal betyg
order Person_ID argang jmftal betyg
rename argang ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA_C 
replace SocietyKnowlegdeGPA_C="0" if SocietyKnowlegdeGPA=="I" 
replace SocietyKnowlegdeGPA_C="10" if SocietyKnowlegdeGPA=="G" 
replace SocietyKnowlegdeGPA_C="15" if SocietyKnowlegdeGPA=="V" 
replace SocietyKnowlegdeGPA_C="20" if SocietyKnowlegdeGPA=="M" 
destring SocietyKnowlegdeGPA_C, replace 
save "use\BJPolS_HighSchool1997_C", replace 
********************************************************************************************************************************************

* WORK WITH 1998 HIGHSCHOOL FILE*************************************************************
use "raw\Gymnavg1998", clear
capture rename dnr2014115 Person_ID 
drop if jmftal==0
keep if kurskod=="SH202" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge C grade*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M"
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID argang jmftal betyg
order Person_ID argang jmftal betyg
rename argang ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA_C 
replace SocietyKnowlegdeGPA_C="0" if SocietyKnowlegdeGPA=="I" 
replace SocietyKnowlegdeGPA_C="10" if SocietyKnowlegdeGPA=="G" 
replace SocietyKnowlegdeGPA_C="15" if SocietyKnowlegdeGPA=="V" 
replace SocietyKnowlegdeGPA_C="20" if SocietyKnowlegdeGPA=="M" 
destring SocietyKnowlegdeGPA_C, replace 
save "use\BJPolS_HighSchool1998_C", replace 
********************************************************************************************************************************************

* WORK WITH 1999 HIGHSCHOOL FILE*************************************************************
use "raw\Gymnavg1999", clear
capture rename dnr2014115 Person_ID
drop if jmftal==0
keep if kurskod=="SH202" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge C grade*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M"
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID argang jmftal betyg
order Person_ID argang jmftal betyg
rename argang ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA_C 
replace SocietyKnowlegdeGPA_C="0" if SocietyKnowlegdeGPA=="I" 
replace SocietyKnowlegdeGPA_C="10" if SocietyKnowlegdeGPA=="G" 
replace SocietyKnowlegdeGPA_C="15" if SocietyKnowlegdeGPA=="V" 
replace SocietyKnowlegdeGPA_C="20" if SocietyKnowlegdeGPA=="M" 
destring SocietyKnowlegdeGPA_C, replace
save "use\BJPolS_HighSchool1999_C", replace 
********************************************************************************************************************************************

* WORK WITH 2000 HIGHSCHOOL FILE*************************************************************
use "raw\Gymnavg2000", clear
capture rename dnr2014115 Person_ID 
drop if jmftal==0
keep if kurskod=="SH202" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge C grade*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M"
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID argang jmftal betyg
order Person_ID argang jmftal betyg
rename argang ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA_C 
replace SocietyKnowlegdeGPA_C="0" if SocietyKnowlegdeGPA=="I" 
replace SocietyKnowlegdeGPA_C="10" if SocietyKnowlegdeGPA=="G" 
replace SocietyKnowlegdeGPA_C="15" if SocietyKnowlegdeGPA=="V" 
replace SocietyKnowlegdeGPA_C="20" if SocietyKnowlegdeGPA=="M" 
destring SocietyKnowlegdeGPA_C, replace
save "use\BJPolS_HighSchool2000_C", replace 
********************************************************************************************************************************************

* WORK WITH 2001 HIGHSCHOOL FILE*************************************************************
use "raw\Gymnavg2001", clear
capture rename dnr2014115 Person_ID
drop if jmftal==0
keep if kurskod=="SH202" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge C grade*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M"
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID argang jmftal betyg
order Person_ID argang jmftal betyg
rename argang ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA_C 
replace SocietyKnowlegdeGPA_C="0" if SocietyKnowlegdeGPA=="I" 
replace SocietyKnowlegdeGPA_C="10" if SocietyKnowlegdeGPA=="G" 
replace SocietyKnowlegdeGPA_C="15" if SocietyKnowlegdeGPA=="V" 
replace SocietyKnowlegdeGPA_C="20" if SocietyKnowlegdeGPA=="M" 
destring SocietyKnowlegdeGPA_C, replace
save "use\BJPolS_HighSchool2001_C", replace 
********************************************************************************************************************************************

* WORK WITH 2002 HIGHSCHOOL FILES*************************************************************
* clean the "raw\Gymnavg2002elev" file 
use "raw\Gymnavg2002elev", clear
capture rename dnr2014115 Person_ID
bysort Person_ID: keep if _n==1
save "temp\BJPolS_Gymnavg2002elev", replace
*********
use "raw\Gymnavg2002kurs", clear
capture rename dnr2014115 Person_ID
merge m:1 Person_ID using "temp\BJPolS_Gymnavg2002elev", keep(match master) keepusing(jmftal) 
destring jmftal, replace
drop if jmftal==0
keep if kurskod=="SH1203" | kurskod=="SH202"  /* every individual has one observation per course, keep the course that carries the SocietyKnowledge C grade*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M"
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID avgangsar jmftal betyg
order Person_ID avgangsar jmftal betyg
rename avgangsar ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA_C 
replace SocietyKnowlegdeGPA_C="0" if SocietyKnowlegdeGPA=="I" 
replace SocietyKnowlegdeGPA_C="10" if SocietyKnowlegdeGPA=="G" 
replace SocietyKnowlegdeGPA_C="15" if SocietyKnowlegdeGPA=="V" 
replace SocietyKnowlegdeGPA_C="20" if SocietyKnowlegdeGPA=="M" 
destring SocietyKnowlegdeGPA_C, replace
save "use\BJPolS_HighSchool2002_C", replace 
********************************************************************************************************************************************

* WORK WITH 2003 HIGHSCHOOL FILES*************************************************************
* clean the "raw\Gymnavg2003elev" file 
use "raw\Gymnavg2003elev", clear
capture rename dnr2014115 Person_ID
bysort Person_ID: keep if _n==1
save "temp\BJPolS_Gymnavg2003elev", replace
*********
use "raw\Gymnavg2003kurs", clear
capture rename dnr2014115 Person_ID
merge m:1 Person_ID using "temp\BJPolS_Gymnavg2003elev", keep(match master) keepusing(jmftal) 
destring jmftal, replace
drop if jmftal==0
keep if kurskod=="SH1203" | kurskod=="SH202" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge C grade*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M" | betyg=="IG" | betyg=="VG" | betyg=="MVG" 
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID avgangsar jmftal betyg
order Person_ID avgangsar jmftal betyg
rename avgangsar ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA_C 
replace SocietyKnowlegdeGPA_C="0" if SocietyKnowlegdeGPA_C=="I" | SocietyKnowlegdeGPA=="IG"  
replace SocietyKnowlegdeGPA_C="10" if SocietyKnowlegdeGPA_C=="G" 
replace SocietyKnowlegdeGPA_C="15" if SocietyKnowlegdeGPA_C=="V" | SocietyKnowlegdeGPA=="VG"   
replace SocietyKnowlegdeGPA_C="20" if SocietyKnowlegdeGPA_C=="M" | SocietyKnowlegdeGPA=="MVG"  
destring SocietyKnowlegdeGPA_C, replace
save "use\BJPolS_HighSchool2003_C", replace 
********************************************************************************************************************************************

* WORK WITH 2004 HIGHSCHOOL FILES*************************************************************
* clean the "raw\Gymnavg2004elev" file 
use "raw\Gymnavg2004elev", clear
capture rename dnr2014115 Person_ID
bysort Person_ID: keep if _n==1
save "temp\BJPolS_Gymnavg2004elev", replace
*********
use "raw\Gymnavg2004kurs", clear
capture rename dnr2014115 Person_ID
merge m:1 Person_ID using "temp\BJPolS_Gymnavg2004elev", keep(match master) keepusing(jmftal) 
destring jmftal, replace
drop if jmftal==0
keep if kurskod=="SH1203" | kurskod=="SH202" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge C grade*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M" | betyg=="IG" | betyg=="VG" | betyg=="MVG" 
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID avgangsar jmftal betyg
order Person_ID avgangsar jmftal betyg
rename avgangsar ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA_C 
replace SocietyKnowlegdeGPA_C="0" if SocietyKnowlegdeGPA_C=="I" | SocietyKnowlegdeGPA=="IG"  
replace SocietyKnowlegdeGPA_C="10" if SocietyKnowlegdeGPA_C=="G" 
replace SocietyKnowlegdeGPA_C="15" if SocietyKnowlegdeGPA_C=="V" | SocietyKnowlegdeGPA=="VG"   
replace SocietyKnowlegdeGPA_C="20" if SocietyKnowlegdeGPA_C=="M" | SocietyKnowlegdeGPA=="MVG"  
destring SocietyKnowlegdeGPA_C, replace
save "use\BJPolS_HighSchool2004_C", replace 
********************************************************************************************************************************************

* WORK WITH 2005 HIGHSCHOOL FILES*************************************************************
* clean the "raw\Gymnavg2005elev" file 
use "raw\Gymnavg2005elev", clear
capture rename dnr2014115 Person_ID
bysort Person_ID: keep if _n==1
save "temp\BJPolS_Gymnavg2005elev", replace
*********
use "raw\Gymnavg2005kurs", clear
capture rename dnr2014115 Person_ID
merge m:1 Person_ID using "temp\BJPolS_Gymnavg2005elev", keep(match master) keepusing(jmftal) 

destring jmftal, replace
drop if jmftal==0
keep if kurskod=="SH1203" | kurskod=="SH202" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge C grade*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M" | betyg=="IG" | betyg=="VG" | betyg=="MVG" 
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID avgangsar jmftal betyg
order Person_ID avgangsar jmftal betyg
rename avgangsar ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA_C 
replace SocietyKnowlegdeGPA_C="0" if SocietyKnowlegdeGPA_C=="I" | SocietyKnowlegdeGPA=="IG"  
replace SocietyKnowlegdeGPA_C="10" if SocietyKnowlegdeGPA_C=="G" 
replace SocietyKnowlegdeGPA_C="15" if SocietyKnowlegdeGPA_C=="V" | SocietyKnowlegdeGPA=="VG"   
replace SocietyKnowlegdeGPA_C="20" if SocietyKnowlegdeGPA_C=="M" | SocietyKnowlegdeGPA=="MVG"  
destring SocietyKnowlegdeGPA_C, replace
save "use\BJPolS_HighSchool2005_C", replace 
******************************************************************************************************

* WORK WITH 2006 HIGHSCHOOL FILES*************************************************************
* clean the "raw\Gymnavg2006elev" file 
use "raw\Gymnavg2006elev", clear
capture rename dnr2014115 Person_ID
bysort Person_ID: keep if _n==1
save "temp\BJPolS_Gymnavg2006elev", replace
*********
use "raw\Gymnavg2006kurs", clear
capture rename dnr2014115 Person_ID
merge m:1 Person_ID using "temp\BJPolS_Gymnavg2006elev", keep(match master) keepusing(jmftal) 
destring avgangsar, replace 
destring jmftal, replace
drop if jmftal==0
keep if kurskod=="SH1203" | kurskod=="SH202" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge C grade*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M" | betyg=="IG" | betyg=="VG" | betyg=="MVG" 
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID avgangsar jmftal betyg
order Person_ID avgangsar jmftal betyg
rename avgangsar ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA_C 
replace SocietyKnowlegdeGPA_C="0" if SocietyKnowlegdeGPA_C=="I" | SocietyKnowlegdeGPA=="IG"  
replace SocietyKnowlegdeGPA_C="10" if SocietyKnowlegdeGPA_C=="G" 
replace SocietyKnowlegdeGPA_C="15" if SocietyKnowlegdeGPA_C=="V" | SocietyKnowlegdeGPA=="VG"   
replace SocietyKnowlegdeGPA_C="20" if SocietyKnowlegdeGPA_C=="M" | SocietyKnowlegdeGPA=="MVG"  
destring SocietyKnowlegdeGPA_C, replace 
save "use\BJPolS_HighSchool2006_C", replace 
******************************************************************************************************

* WORK WITH 2007 HIGHSCHOOL FILES*************************************************************
* clean the "raw\Gymnavg2007elev" file 
use "raw\Gymnavg2007elev", clear
capture rename dnr2014115 Person_ID
bysort Person_ID: keep if _n==1
save "temp\BJPolS_Gymnavg2007elev", replace
*********
use "raw\Gymnavg2007kurs", clear
capture rename dnr2014115 Person_ID
merge m:1 Person_ID using "temp\BJPolS_Gymnavg2007elev", keep(match master) keepusing(jmftal) 
destring ar, replace
destring jmftal, replace
drop if jmftal==0
keep if kurskod=="SH1203" | kurskod=="SH202" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge C grade*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M" | betyg=="IG" | betyg=="VG" | betyg=="MVG" 
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID ar jmftal betyg
order Person_ID ar jmftal betyg
rename ar ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA_C 
replace SocietyKnowlegdeGPA_C="0" if SocietyKnowlegdeGPA_C=="I" | SocietyKnowlegdeGPA=="IG"  
replace SocietyKnowlegdeGPA_C="10" if SocietyKnowlegdeGPA_C=="G" 
replace SocietyKnowlegdeGPA_C="15" if SocietyKnowlegdeGPA_C=="V" | SocietyKnowlegdeGPA=="VG"   
replace SocietyKnowlegdeGPA_C="20" if SocietyKnowlegdeGPA_C=="M" | SocietyKnowlegdeGPA=="MVG"  
destring SocietyKnowlegdeGPA_C, replace
save "use\BJPolS_HighSchool2007_C", replace 
******************************************************************************************************

* WORK WITH 2008 HIGHSCHOOL FILES*************************************************************
* clean the "raw\Gymnavg2008elev" file 
use "raw\Gymnavg2008elev", clear
capture rename dnr2014115 Person_ID
bysort Person_ID: keep if _n==1
save "temp\BJPolS_Gymnavg2008elev", replace
*********
use "raw\Gymnavg2008kurs", clear
capture rename dnr2014115 Person_ID
merge m:1 Person_ID using "temp\BJPolS_Gymnavg2008elev", keep(match master) keepusing(jmftal) 
destring ar, replace
destring jmftal, replace
drop if jmftal==0
keep if kurskod=="SH1203" | kurskod=="SH202" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge C grade*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M" | betyg=="IG" | betyg=="VG" | betyg=="MVG" 
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID ar jmftal betyg
order Person_ID ar jmftal betyg
rename ar ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA_C 
replace SocietyKnowlegdeGPA_C="0" if SocietyKnowlegdeGPA_C=="I" | SocietyKnowlegdeGPA=="IG"  
replace SocietyKnowlegdeGPA_C="10" if SocietyKnowlegdeGPA_C=="G" 
replace SocietyKnowlegdeGPA_C="15" if SocietyKnowlegdeGPA_C=="V" | SocietyKnowlegdeGPA=="VG"   
replace SocietyKnowlegdeGPA_C="20" if SocietyKnowlegdeGPA_C=="M" | SocietyKnowlegdeGPA=="MVG"  
destring SocietyKnowlegdeGPA_C, replace
save "use\BJPolS_HighSchool2008_C", replace 
******************************************************************************************************

* WORK WITH 2009 HIGHSCHOOL FILES*************************************************************
* clean the "raw\Gymnavg2009elev" file 
use "raw\Gymnavg2009elev", clear
capture rename dnr2014115 Person_ID
bysort Person_ID: keep if _n==1
save "temp\BJPolS_Gymnavg2009elev", replace
*********
use "raw\Gymnavg2009kurs", clear
capture rename dnr2014115 Person_ID
merge m:1 Person_ID using "temp\BJPolS_Gymnavg2009elev", keep(match master) keepusing(jmftal) 
destring ar, replace
destring jmftal, replace
drop if jmftal==0
keep if kurskod=="SH1203" | kurskod=="SH202" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge C grade*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M" | betyg=="IG" | betyg=="VG" | betyg=="MVG" 
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID ar jmftal betyg
order Person_ID ar jmftal betyg
rename ar ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA_C 
replace SocietyKnowlegdeGPA_C="0" if SocietyKnowlegdeGPA_C=="I" | SocietyKnowlegdeGPA=="IG"  
replace SocietyKnowlegdeGPA_C="10" if SocietyKnowlegdeGPA_C=="G" 
replace SocietyKnowlegdeGPA_C="15" if SocietyKnowlegdeGPA_C=="V" | SocietyKnowlegdeGPA=="VG"   
replace SocietyKnowlegdeGPA_C="20" if SocietyKnowlegdeGPA_C=="M" | SocietyKnowlegdeGPA=="MVG"  
destring SocietyKnowlegdeGPA_C, replace
save "use\BJPolS_HighSchool2009_C", replace 
******************************************************************************************************

* WORK WITH 2010 HIGHSCHOOL FILES*************************************************************
* clean the "raw\Gymnavg2009elev" file 
use "raw\Gymnavg2010elev", clear
capture rename dnr2014115 Person_ID
bysort Person_ID: keep if _n==1
save "temp\BJPolS_Gymnavg2010elev", replace
*********
use "raw\Gymnavg2010kurs", clear
capture rename dnr2014115 Person_ID
merge m:1 Person_ID using "temp\BJPolS_Gymnavg2010elev", keep(match master) keepusing(jmftal) 
destring ar, replace
destring jmftal, replace
drop if jmftal==0
keep if kurskod=="SH1203" | kurskod=="SH202" /* every individual has one observation per course, keep the course that carries the SocietyKnowledge C grade*/
keep if betyg=="I" | betyg=="G" | betyg=="V" | betyg=="M" | betyg=="IG" | betyg=="VG" | betyg=="MVG" 
bysort Person_ID: keep if _n==1 /* remove potential duplicates*/
keep Person_ID ar jmftal betyg
order Person_ID ar jmftal betyg
rename ar ExaminationYearHighSchool
rename jmftal HighSchoolOverallGPA
rename betyg SocietyKnowlegdeGPA_C 
replace SocietyKnowlegdeGPA_C="0" if SocietyKnowlegdeGPA_C=="I" | SocietyKnowlegdeGPA=="IG"  
replace SocietyKnowlegdeGPA_C="10" if SocietyKnowlegdeGPA_C=="G" 
replace SocietyKnowlegdeGPA_C="15" if SocietyKnowlegdeGPA_C=="V" | SocietyKnowlegdeGPA=="VG"   
replace SocietyKnowlegdeGPA_C="20" if SocietyKnowlegdeGPA_C=="M" | SocietyKnowlegdeGPA=="MVG"  
destring SocietyKnowlegdeGPA_C, replace 
save "use\BJPolS_HighSchool2010_C", replace 
******************************************************************************************************


* PUT TOGETHER ALL THE  HIGH SCHOOL FILES	
use "use\BJPolS_HighSchool1997_C", clear
capture rename dnr2014115 Person_ID
append using "use\BJPolS_HighSchool1998_C", force
append using "use\BJPolS_HighSchool1999_C", force
append using "use\BJPolS_HighSchool2000_C", force
append using "use\BJPolS_HighSchool2001_C", force
append using "use\BJPolS_HighSchool2002_C", force
append using "use\BJPolS_HighSchool2003_C", force
append using "use\BJPolS_HighSchool2004_C", force
append using "use\BJPolS_HighSchool2005_C", force
append using "use\BJPolS_HighSchool2006_C", force
append using "use\BJPolS_HighSchool2007_C", force
append using "use\BJPolS_HighSchool2008_C", force
append using "use\BJPolS_HighSchool2009_C", force
append using "use\BJPolS_HighSchool2010_C", force
bysort Person_ID: keep if _n==1 /* remove duplicates */
save "use\BJPolS_HighSchool1997_2010_C", replace 
************************************************


* STANDARDIZE SOCIETYKNOWLEDGE C GPA BY EXAMINATION YEAR
set more off
use "use\BJPolS_HighSchool1997_2010_C", clear
capture rename dnr2014115 Person_ID
forvalues I=1997(1)2010{
egen StandSocietyGPA_C`I'=std(SocietyKnowlegdeGPA_C) if ExaminationYearHighSchool==`I'
}
*

gen StandHSSocietyGPA_C=.

forvalues I=1997(1)2010{
replace StandHSSocietyGPA_C=StandSocietyGPA_C`I' if StandHSSocietyGPA_C==.
}
*
keep Person_ID ExaminationYearHighSchool StandHSSocietyGPA_C 
order Person_ID ExaminationYearHighSchool StandHSSocietyGPA_C  
save "use\BJPolS_HighSchool1997_2010_C_Std", replace
**********************************************************************
****************************************************************************************************************************************************


************************************USE MAIN FILE AND ADD DATA ON SWESAT SCORE***********************************************************************
use "temp\BJPolS_MainBirthFileGender3", clear
keep if YearOfBirth>1976
save "temp\BJPolS_post1976",replace

use "temp\BJPolS_MainBirthFileGender3", clear
keep if YearOfBirth==1970
merge 1:1 Person_ID using "use\BJPolS_Swesat1970", keep(match master) keepusing(StandGeneral_Knowledge) 
drop _merge
save "temp\BJPolS_1970",replace

use "temp\BJPolS_MainBirthFileGender3", clear
keep if YearOfBirth==1973
merge 1:1 Person_ID using "use\BJPolS_Swesat1973", keep(match master) keepusing(StandGeneral_Knowledge) 
drop _merge
save "temp\BJPolS_1973",replace  

use "temp\BJPolS_MainBirthFileGender3", clear
keep if YearOfBirth==1976
merge 1:1 Person_ID using "use\BJPolS_Swesat1976", keep(match master) keepusing(StandGeneral_Knowledge) 
drop _merge
save "temp\BJPolS_1976",replace


use "temp\BJPolS_1970",clear
append using "temp\BJPolS_1973" 
append using "temp\BJPolS_1976"
append using "temp\BJPolS_post1976"

rename StandGeneral_Knowledge SweSAT
gen SweSAT_exists=SweSAT!=. 


save "temp\BJPolS_MainBirthFile_4", replace
****************************************************************************************************************************************************

**********************************************USE MAIN FILE AND ADD DATA ON JUNIOR HIGH SCHOOL GRADES********************************************
use "temp\BJPolS_MainBirthFile_4", clear

merge 1:1 Person_ID using "use\BJPolS_JuniorHS1988_2010Std", keep(match master) keepusing(ExaminationYear StandJuniorHSOverallGPA StandJuniorHSSocietyGPA) /* add results from junior high school*/
gen JuniorHSDataExists=_merge==3
drop _merge
drop ExaminationYear
save "temp\BJPolS_MainBirthFile_5", replace  

***********************************************************************************************************************************************


**********************************************USE MAIN FILE AND ADD DATA ON HIGH SCHOOL GRADES (MAIN OUTCOME)********************************************
use "temp\BJPolS_MainBirthFile_5", clear

merge 1:1 Person_ID using "use\BJPolS_HighSchool1985_2010Std", keep(match master) keepusing(ExaminationYearHighSchool StandHSOverallGPA StandHSSocietyGPA ) /* add results from high school*/
gen HighSchoolDataExists=_merge==3
drop _merge

* I require that the individuals graduate from high school at age 18, 19 or 20, otherwise they cannot be affected by the voting right while in high school
* 98 % of the individuals in the sample graduate at those ages
gen AgeAtHighSchoolGraduation=ExaminationYearHighSchool-YearOfBirth /* should typically be 19*/ 
gen HighSchoolCorrectTiming=AgeAtHighSchoolGraduation==18 | AgeAtHighSchoolGraduation==19 | AgeAtHighSchoolGraduation==20
gen HighSchoolDataExists_2=HighSchoolDataExists==1 & HighSchoolCorrectTiming==1
replace StandHSSocietyGPA=. if HighSchoolDataExists_2==0  

rename StandHSSocietyGPA HS_SocialStudies_Grade 
save "temp\BJPolS_MainBirthFile_6", replace
***********************************************************************************************************************************************





**************************************** ADD DATA ON PARENTAL CHARACTERISTICS***********************************************************************************
use "temp\BJPolS_MainBirthFile_6", clear
keep if YearOfBirth==1970
merge 1:1 Person_ID using "temp\BJPolS_Fob1990foraldra", keep(match master) 
gen InFob1990=_merge==3
drop _merge

gen FatherEmploymentDuringTeenExists=InFob1990==1 & Employment_Father!=.
gen FatherEmployedDuringTeen=Employment_Father==1

gen MotherEmploymentDuringTeenExists=InFob1990==1 & Employment_Mother!=.
gen MotherEmployedDuringTeen=Employment_Mother==1

gen FatherEducationDuringTeenExists=InFob1990==1 & Education_Father!=. & Education_Father!=0
capture tostring Education_Father, replace
gen Father2=substr(Education_Father,2,1)
gen FatherHighEducation=(Father2=="6") | (Father2=="7")
 
gen MotherEducationDuringTeenExists=InFob1990==1 & Education_Mother!=. & Education_Mother!=0
capture tostring Education_Mother, replace
gen Mother2=substr(Education_Mother,2,1)
gen MotherHighEducation=(Mother2=="6") | (Mother2=="7")
save "temp\BJPolS_Parent_1970", replace

use "temp\BJPolS_MainBirthFile_6", clear
keep if YearOfBirth==1973
merge 1:1 Person_ID using "temp\BJPolS_Fob1990foraldra", keep(match master) 
gen InFob1990=_merge==3
drop _merge

gen FatherEmploymentDuringTeenExists=InFob1990==1 & Employment_Father!=.
gen FatherEmployedDuringTeen=Employment_Father==1

gen MotherEmploymentDuringTeenExists=InFob1990==1 & Employment_Mother!=.
gen MotherEmployedDuringTeen=Employment_Mother==1

gen FatherEducationDuringTeenExists=InFob1990==1 & Education_Father!=. & Education_Father!=0
capture tostring Education_Father, replace
gen Father2=substr(Education_Father,2,1)
gen FatherHighEducation=(Father2=="6") | (Father2=="7")
 
gen MotherEducationDuringTeenExists=InFob1990==1 & Education_Mother!=. & Education_Mother!=0
capture tostring Education_Mother, replace
gen Mother2=substr(Education_Mother,2,1)
gen MotherHighEducation=(Mother2=="6") | (Mother2=="7")
save "temp\BJPolS_Parent_1973", replace


use "temp\BJPolS_MainBirthFile_6", clear
keep if YearOfBirth==1976
rename Person_ID Temp_ID

rename Person_ID_Father Person_ID
merge m:1 Person_ID using "use\BJPolS_Louisegeo1994", keep(match master) keepusing(Education_Level_Oldcode Employment_Status)
gen FatherInLouise=_merge==3
drop _merge
gen FatherEmploymentDuringTeenExists=FatherInLouise==1 & Employment_Status!=.
gen FatherEmployedDuringTeen=Employment_Status==1
gen FatherEducationDuringTeenExists=FatherInLouise==1 & Education_Level_Oldcode!=. & Education_Level_Oldcode!=0
capture tostring Education_Level_Oldcode, replace
gen Father2=substr(Education_Level_Oldcode,2,1)
gen FatherHighEducation=(Father2=="6") | (Father2=="7")
drop Education_Level_Oldcode Employment_Status 
rename Person_ID Person_ID_Father 


rename Person_ID_Mother Person_ID
merge m:1 Person_ID using "use\BJPolS_Louisegeo1994", keep(match master) keepusing(Education_Level_Oldcode Employment_Status)
gen MotherInLouise=_merge==3
drop _merge
gen MotherEmploymentDuringTeenExists=MotherInLouise==1 & Employment_Status!=.
gen MotherEmployedDuringTeen=Employment_Status==1
gen MotherEducationDuringTeenExists=MotherInLouise==1 & Education_Level_Oldcode!=. & Education_Level_Oldcode!=0
capture tostring Education_Level_Oldcode, replace
gen Mother2=substr(Education_Level_Oldcode,2,1)
gen MotherHighEducation=(Mother2=="6") | (Mother2=="7")
drop Education_Level_Oldcode Employment_Status
rename Person_ID Person_ID_Mother

rename Temp_ID Person_ID 
save "temp\BJPolS_Parent_1976", replace

use "temp\BJPolS_MainBirthFile_6", clear
keep if YearOfBirth==1980
rename Person_ID Temp_ID

rename Person_ID_Father Person_ID
merge m:1 Person_ID using "use\BJPolS_Louisegeo1995", keep(match master) keepusing(Education_Level_Oldcode Employment_Status)
gen FatherInLouise=_merge==3
drop _merge
gen FatherEmploymentDuringTeenExists=FatherInLouise==1 & Employment_Status!=.
gen FatherEmployedDuringTeen=Employment_Status==1
gen FatherEducationDuringTeenExists=FatherInLouise==1 & Education_Level_Oldcode!=. & Education_Level_Oldcode!=0
capture tostring Education_Level_Oldcode, replace
gen Father2=substr(Education_Level_Oldcode,2,1)
gen FatherHighEducation=(Father2=="6") | (Father2=="7")
drop Education_Level_Oldcode Employment_Status 
rename Person_ID Person_ID_Father 


rename Person_ID_Mother Person_ID
merge m:1 Person_ID using "use\BJPolS_Louisegeo1995", keep(match master) keepusing(Education_Level_Oldcode Employment_Status)
gen MotherInLouise=_merge==3
drop _merge
gen MotherEmploymentDuringTeenExists=MotherInLouise==1 & Employment_Status!=.
gen MotherEmployedDuringTeen=Employment_Status==1
gen MotherEducationDuringTeenExists=MotherInLouise==1 & Education_Level_Oldcode!=. & Education_Level_Oldcode!=0
capture tostring Education_Level_Oldcode, replace
gen Mother2=substr(Education_Level_Oldcode,2,1)
gen MotherHighEducation=(Mother2=="6") | (Mother2=="7")
drop Education_Level_Oldcode Employment_Status
rename Person_ID Person_ID_Mother

rename Temp_ID Person_ID 
save "temp\BJPolS_Parent_1980", replace

use "temp\BJPolS_MainBirthFile_6", clear
keep if YearOfBirth==1984
rename Person_ID Temp_ID

rename Person_ID_Father Person_ID
merge m:1 Person_ID using "use\BJPolS_Louisegeo1999", keep(match master) keepusing(Education_Level_Oldcode Employment_Status)
gen FatherInLouise=_merge==3
drop _merge
gen FatherEmploymentDuringTeenExists=FatherInLouise==1 & Employment_Status!=.
gen FatherEmployedDuringTeen=Employment_Status==1
gen FatherEducationDuringTeenExists=FatherInLouise==1 & Education_Level_Oldcode!=. & Education_Level_Oldcode!=0
capture tostring Education_Level_Oldcode, replace
gen Father2=substr(Education_Level_Oldcode,2,1)
gen FatherHighEducation=(Father2=="6") | (Father2=="7")
drop Education_Level_Oldcode Employment_Status 
rename Person_ID Person_ID_Father 


rename Person_ID_Mother Person_ID
merge m:1 Person_ID using "use\BJPolS_Louisegeo1999", keep(match master) keepusing(Education_Level_Oldcode Employment_Status)
gen MotherInLouise=_merge==3
drop _merge
gen MotherEmploymentDuringTeenExists=MotherInLouise==1 & Employment_Status!=.
gen MotherEmployedDuringTeen=Employment_Status==1
gen MotherEducationDuringTeenExists=MotherInLouise==1 & Education_Level_Oldcode!=. & Education_Level_Oldcode!=0
capture tostring Education_Level_Oldcode, replace
gen Mother2=substr(Education_Level_Oldcode,2,1)
gen MotherHighEducation=(Mother2=="6") | (Mother2=="7")
drop Education_Level_Oldcode Employment_Status
rename Person_ID Person_ID_Mother

rename Temp_ID Person_ID 
save "temp\BJPolS_Parent_1984", replace

use "temp\BJPolS_MainBirthFile_6", clear
keep if YearOfBirth==1985
rename Person_ID Temp_ID

rename Person_ID_Father Person_ID
merge m:1 Person_ID using "use\BJPolS_Louisegeo2000", keep(match master) keepusing(Education_Level_Newcode Employment_Status)
gen FatherInLouise=_merge==3
drop _merge
gen FatherEmploymentDuringTeenExists=FatherInLouise==1 & Employment_Status!=.
gen FatherEmployedDuringTeen=Employment_Status==1
gen FatherEducationDuringTeenExists=FatherInLouise==1 & Education_Level_Newcode!="" & Education_Level_Newcode!="0"
gen Father12=substr(Education_Level_Newcode,1,2)
gen FatherHighEducation=(Father12=="53") | (Father12=="54") | (Father12=="60") | (Father12=="62") | (Father12=="64")
drop Education_Level_Newcode Employment_Status 
rename Person_ID Person_ID_Father 


rename Person_ID_Mother Person_ID
merge m:1 Person_ID using "use\BJPolS_Louisegeo2000", keep(match master) keepusing(Education_Level_Newcode Employment_Status)
gen MotherInLouise=_merge==3
drop _merge
gen MotherEmploymentDuringTeenExists=MotherInLouise==1 & Employment_Status!=.
gen MotherEmployedDuringTeen=Employment_Status==1
gen MotherEducationDuringTeenExists=MotherInLouise==1 & Education_Level_Newcode!="" & Education_Level_Newcode!="0"
gen Mother12=substr(Education_Level_Newcode,1,2)
gen MotherHighEducation=(Mother12=="53") | (Mother12=="54") | (Mother12=="60") | (Mother12=="62") | (Mother12=="64")
drop Education_Level_Newcode Employment_Status
rename Person_ID Person_ID_Mother

rename Temp_ID Person_ID 
save "temp\BJPolS_Parent_1985", replace

use "temp\BJPolS_MainBirthFile_6", clear
keep if YearOfBirth==1988
rename Person_ID Temp_ID

rename Person_ID_Father Person_ID
merge m:1 Person_ID using "use\BJPolS_Louisegeo2003", keep(match master) keepusing(Education_Level_Newcode Employment_Status)
gen FatherInLouise=_merge==3
drop _merge
gen FatherEmploymentDuringTeenExists=FatherInLouise==1 & Employment_Status!=.
gen FatherEmployedDuringTeen=Employment_Status==1
gen FatherEducationDuringTeenExists=FatherInLouise==1 & Education_Level_Newcode!="" & Education_Level_Newcode!="0"
gen Father12=substr(Education_Level_Newcode,1,2)
gen FatherHighEducation=(Father12=="53") | (Father12=="54") | (Father12=="60") | (Father12=="62") | (Father12=="64")
drop Education_Level_Newcode Employment_Status 
rename Person_ID Person_ID_Father 


rename Person_ID_Mother Person_ID
merge m:1 Person_ID using "use\BJPolS_Louisegeo2003", keep(match master) keepusing(Education_Level_Newcode Employment_Status)
gen MotherInLouise=_merge==3
drop _merge
gen MotherEmploymentDuringTeenExists=MotherInLouise==1 & Employment_Status!=.
gen MotherEmployedDuringTeen=Employment_Status==1
gen MotherEducationDuringTeenExists=MotherInLouise==1 & Education_Level_Newcode!="" & Education_Level_Newcode!="0"
gen Mother12=substr(Education_Level_Newcode,1,2)
gen MotherHighEducation=(Mother12=="53") | (Mother12=="54") | (Mother12=="60") | (Mother12=="62") | (Mother12=="64")
drop Education_Level_Newcode Employment_Status
rename Person_ID Person_ID_Mother

rename Temp_ID Person_ID 
save "temp\BJPolS_Parent_1988", replace

use "temp\BJPolS_Parent_1970", clear
append using "temp\BJPolS_Parent_1973" 
append using "temp\BJPolS_Parent_1976"
append using "temp\BJPolS_Parent_1980"
append using "temp\BJPolS_Parent_1984"
append using "temp\BJPolS_Parent_1985"
append using "temp\BJPolS_Parent_1988"

replace MotherHighEducation=. if MotherEducationDuringTeenExists==0  
replace FatherHighEducation=. if FatherEducationDuringTeenExists==0 
replace MotherEmployedDuringTeen=. if MotherEmploymentDuringTeenExists==0  
replace FatherEmployedDuringTeen=. if FatherEmploymentDuringTeenExists==0

save "temp\BJPolS_MainBirthFile_7", replace
****************************************************************************************************************************************************

************************************FINALIZE THE ANALYSIS DATA SET*******************************************************************************
use "temp\BJPolS_MainBirthFile_7", clear

gen Gender_exists=Male!=.
gen AgeAtFirst_exists=AgeAtFirst!=.

gen Birth_Relative_Cutoff=.
replace Birth_Relative_Cutoff=NumericalBirthDateValue-3913 if YearOfBirth==1970 
replace Birth_Relative_Cutoff=NumericalBirthDateValue-5006 if YearOfBirth==1973
replace Birth_Relative_Cutoff=NumericalBirthDateValue-6161 if YearOfBirth==1976 
replace Birth_Relative_Cutoff=NumericalBirthDateValue-7568 if YearOfBirth==1980
replace Birth_Relative_Cutoff=NumericalBirthDateValue-9024 if YearOfBirth==1984
replace Birth_Relative_Cutoff=NumericalBirthDateValue-9388 if YearOfBirth==1985
replace Birth_Relative_Cutoff=NumericalBirthDateValue-10487 if YearOfBirth==1988

gen Interaction_Day=Voting_Right*Birth_Relative_Cutoff

gen Week_relative_cutoff=.
replace Week_relative_cutoff=1 if Birth_Relative_Cutoff<=7 & Birth_Relative_Cutoff>=1
replace Week_relative_cutoff=2 if Birth_Relative_Cutoff<=14 & Birth_Relative_Cutoff>=8 
replace Week_relative_cutoff=3 if Birth_Relative_Cutoff<=21 & Birth_Relative_Cutoff>=15
replace Week_relative_cutoff=4 if Birth_Relative_Cutoff<=28 & Birth_Relative_Cutoff>=22
replace Week_relative_cutoff=5 if Birth_Relative_Cutoff<=35 & Birth_Relative_Cutoff>=29
replace Week_relative_cutoff=6 if Birth_Relative_Cutoff<=42 & Birth_Relative_Cutoff>=36
replace Week_relative_cutoff=7 if Birth_Relative_Cutoff<=48 & Birth_Relative_Cutoff>=43

replace Week_relative_cutoff=0 if Birth_Relative_Cutoff<=0 & Birth_Relative_Cutoff>=-6
replace Week_relative_cutoff=-1 if Birth_Relative_Cutoff<=-7 & Birth_Relative_Cutoff>=-13 
replace Week_relative_cutoff=-2 if Birth_Relative_Cutoff<=-14 & Birth_Relative_Cutoff>=-20
replace Week_relative_cutoff=-3 if Birth_Relative_Cutoff<=-21 & Birth_Relative_Cutoff>=-27
replace Week_relative_cutoff=-4 if Birth_Relative_Cutoff<=-28 & Birth_Relative_Cutoff>=-34
replace Week_relative_cutoff=-5 if Birth_Relative_Cutoff<=-35 & Birth_Relative_Cutoff>=-41
replace Week_relative_cutoff=-6 if Birth_Relative_Cutoff<=-42 & Birth_Relative_Cutoff>=-47


gen Interaction_Week=Voting_Right*Week_relative_cutoff

gen Week_Square=Week_relative_cutoff^2
gen Week_Square_Interaction=Week_Square*Voting_Right

* Add data on the course social studies B and C
merge 1:1 Person_ID using "use\BJPolS_HighSchool1997_2010_B_Std", keep(match master) keepusing(StandHSSocietyGPA_B)
gen Society_B_Exists=_merge==3
drop _merge

merge 1:1 Person_ID using "use\BJPolS_HighSchool1997_2010_C_Std", keep(match master) keepusing(StandHSSocietyGPA_C)
gen Society_C_Exists=_merge==3
drop _merge

gen B_Exist=Society_B_Exists*HighSchoolDataExists_2
gen C_Exist=Society_C_Exists*HighSchoolDataExists_2

replace StandHSSocietyGPA_B=. if B_Exist==0  
replace StandHSSocietyGPA_C=. if C_Exist==0



keep Person_ID YearOfBirth MonthOfBirth DayOfBirth NumericalBirthDateValue DayOfTheWeekBirth Voting_Right Gender_exists Male AgeAtFirst_exists AgeAtFirst JuniorHSDataExists StandJuniorHSOverallGPA StandJuniorHSSocietyGPA ///
MotherEducationDuringTeenExists MotherHighEducation FatherEducationDuringTeenExists FatherHighEducation MotherEmploymentDuringTeenExists MotherEmployedDuringTeen FatherEmploymentDuringTeenExists FatherEmployedDuringTeen ///
HighSchoolDataExists_2 HS_SocialStudies_Grade SweSAT_exists SweSAT Birth_Relative_Cutoff Interaction_Day Week_relative_cutoff Interaction_Week B_Exist StandHSSocietyGPA_B C_Exist StandHSSocietyGPA_C Week_Square Week_Square_Interaction 

order Person_ID YearOfBirth MonthOfBirth DayOfBirth NumericalBirthDateValue DayOfTheWeekBirth Voting_Right Gender_exists Male AgeAtFirst_exists AgeAtFirst JuniorHSDataExists StandJuniorHSOverallGPA StandJuniorHSSocietyGPA ///
MotherEducationDuringTeenExists MotherHighEducation FatherEducationDuringTeenExists FatherHighEducation MotherEmploymentDuringTeenExists MotherEmployedDuringTeen FatherEmploymentDuringTeenExists FatherEmployedDuringTeen ///
HighSchoolDataExists_2 HS_SocialStudies_Grade SweSAT_exists SweSAT Birth_Relative_Cutoff Interaction_Day Week_relative_cutoff Interaction_Week B_Exist StandHSSocietyGPA_B C_Exist StandHSSocietyGPA_C Week_Square Week_Square_Interaction 

label variable Person_ID "Personal identifier"
label variable YearOfBirth "Year of birth" 
label variable MonthOfBirth "Month of birth"
label variable DayOfBirth "Day of birth" 
label variable NumericalBirthDateValue "Numerical birth date value, command mdy in Stata"
label variable DayOfTheWeekBirth "Day of the week indicator"
label variable Voting_Right "Dummy variable for turning 18 just before an election"
label variable Gender_exists "Information on gender exists (dummy)"
label variable Male "Dummy variable for being male"
label variable AgeAtFirst_exists "Information on age at first major voting opportunity exists (dummy)"
label variable AgeAtFirst "Age at first major voting opportunity"
label variable JuniorHSDataExists "Information on junior high school data exists (dummy)"
label variable StandJuniorHSOverallGPA "Junior high school GPA, standardized by graduation year"
label variable StandJuniorHSSocietyGPA "Junior high school grade in Social Studies, standardized by graduation year"
label variable MotherEducationDuringTeenExists "Information on mothers education at age 15 exists (dummy)"
label variable MotherHighEducation "Mother highly educated (dummy)"
label variable FatherEducationDuringTeenExists "Information on fathers education at age 15 exists (dummy)"
label variable FatherHighEducation "Father highly educated (dummy)"
label variable MotherEmploymentDuringTeenExists "Information on mothers employment at age 15 exists (dummy)"
label variable MotherEmployedDuringTeen "Mother employed (dummy)"
label variable FatherEmploymentDuringTeenExists "Information on fathers employment at age 15 exists (dummy)"
label variable FatherEmployedDuringTeen "Father employed (dummy)"
label variable HighSchoolDataExists_2 "Information on high school data exists (dummy)"
label variable HS_SocialStudies_Grade "High school grade in Social Studies, standardized by graduation year"
label variable SweSAT_exists "Information on the SweSAT score exists (dummy)"
label variable SweSAT "SweSAT score standardized within a given test"
label variable Birth_Relative_Cutoff "Birth date relative to cutoff for voting right in election 18 years later"
label variable Interaction_Day "Birth_Relative_Cutoff interacted with voting right dummy"
label variable Week_relative_cutoff "Birth week relative to cutoff for voting right in election 18 years later"
label variable Interaction_Week "Week_relative_cutoff interacted with voting right dummy"
label variable B_Exist "Information on grade in Social Studies B exists (dummy)"
label variable StandHSSocietyGPA_B "Grade in Social Studies B, standardized by graduation year"
label variable C_Exist "Information on grade in Social Studies C exists (dummy)"
label variable StandHSSocietyGPA_C "Grade in Social Studies C, standardized by graduation year"
label variable Week_Square "Week_relative_cutoff to the power of 2"
label variable Week_Square_Interaction "Week_Square interacted with voting right dummy"



save "temp\BJPolS_AnalysisData", replace

*generate post description file
capture log close
log using "USE\BJPolS_PostDescription", replace text
use "temp\BJPolS_AnalysisData", clear
describe
log close







****************************************************************************************************************************************************


* GENERATE ALL THE TABLES AND THE FIGURES IN THE PAPER






************** Generate Table 3*******************************************************************************************************************
use "temp\BJPolS_AnalysisData", clear

*column 1
sum Gender_exists AgeAtFirst_exists JuniorHSDataExists MotherEducationDuringTeenExists FatherEducationDuringTeenExists MotherEmploymentDuringTeenExists FatherEmploymentDuringTeenExists HighSchoolDataExists_2 SweSAT_exists 

*column 2
sum Male AgeAtFirst StandJuniorHSOverallGPA StandJuniorHSSocietyGPA MotherHighEducation FatherHighEducation MotherEmployedDuringTeen FatherEmployedDuringTeen HS_SocialStudies_Grade SweSAT

*column 3
sum Male AgeAtFirst StandJuniorHSOverallGPA StandJuniorHSSocietyGPA MotherHighEducation FatherHighEducation MotherEmployedDuringTeen FatherEmployedDuringTeen HS_SocialStudies_Grade SweSAT if Voting_Right==1

*column 4
sum Male AgeAtFirst StandJuniorHSOverallGPA StandJuniorHSSocietyGPA MotherHighEducation FatherHighEducation MotherEmployedDuringTeen FatherEmployedDuringTeen HS_SocialStudies_Grade SweSAT if Voting_Right==0


****************************************************************************************************************************************************

**** Generate Figure 1 ***************************************************************************************************************************************************
use "temp\BJPolS_AnalysisData", clear
keep if HS_SocialStudies_Grade!=. 

egen FE=group(YearOfBirth)
egen Cluster=group(YearOfBirth Week_relative_cutoff) 
xtreg HS_SocialStudies_Grade Voting_Right Week_relative_cutoff Interaction_Week , fe i(FE) vce(cluster Cluster) nonest 
append using "raw\BJPolS_appendforfigdata1week.dta" /* lets the regression lines reach the vertical line*/ 
predict PredPart
gen PredPartL1=PredPart if Voting_Right==1
gen PredPartL0=PredPart if Voting_Right==0
collapse (mean) HS_SocialStudies_Grade PredPartL1 PredPartL0  , by(Week_relative_cutoff)
twoway scatter HS_SocialStudies_Grade PredPartL1 PredPartL0  Week_relative_cutoff, ylabel(-0.16(0.04)0.12) legend(off) connect(. l l) ///
 symbol(O i i) /// 
ytitle("Standardized grade") xtitle("Birth week relative to the cut") xlabel(-6(1)7) xline(0.5)

**************************************************************************************************************************************************************************

**** Generate Table 4 ***************************************************************************************************************************************************
*Panel A
use "temp\BJPolS_AnalysisData", clear
keep if HS_SocialStudies_Grade!=.
egen FE=group(YearOfBirth)
egen Cluster=group(YearOfBirth Week_relative_cutoff) 

* Column 1
xtreg HS_SocialStudies_Grade Voting_Right Week_relative_cutoff Interaction_Week , fe i(FE) vce(cluster Cluster) nonest 
* Column 2
xtreg HS_SocialStudies_Grade Voting_Right Week_relative_cutoff Interaction_Week if Week_relative_cutoff<=6 & Week_relative_cutoff>=-5, fe i(FE) vce(cluster Cluster) nonest
* Column 3 
xtreg HS_SocialStudies_Grade Voting_Right Week_relative_cutoff Interaction_Week if Week_relative_cutoff<=5 & Week_relative_cutoff>=-4, fe i(FE) vce(cluster Cluster) nonest 
* Column 4
xtreg HS_SocialStudies_Grade Voting_Right Week_relative_cutoff Interaction_Week if Week_relative_cutoff<=4 & Week_relative_cutoff>=-3, fe i(FE) vce(cluster Cluster) nonest 
* Column 5
xtreg HS_SocialStudies_Grade Voting_Right Week_relative_cutoff Interaction_Week Week_Square Week_Square_Interaction, fe i(FE) vce(cluster Cluster) nonest 

* Column 6
replace StandJuniorHSOverallGPA=0 if JuniorHSDataExists==0   
replace StandJuniorHSSocietyGPA=0 if JuniorHSDataExists==0 
replace MotherHighEducation=0 if MotherEducationDuringTeenExists==0     
replace FatherHighEducation=0 if FatherEducationDuringTeenExists==0
replace MotherEmployedDuringTeen=0 if MotherEmploymentDuringTeenExists==0 
replace FatherEmployedDuringTeen=0 if FatherEmploymentDuringTeenExists==0

xtreg HS_SocialStudies_Grade Voting_Right Week_relative_cutoff Interaction_Week StandJuniorHSOverallGPA StandJuniorHSSocietyGPA JuniorHSDataExists MotherHighEducation MotherEducationDuringTeenExists ///
FatherHighEducation FatherEducationDuringTeenExists MotherEmployedDuringTeen MotherEmploymentDuringTeenExists FatherEmployedDuringTeen FatherEmploymentDuringTeenExists, fe i(FE) vce(cluster Cluster) nonest

* Column 7
xtreg HS_SocialStudies_Grade Voting_Right Birth_Relative_Cutoff Interaction_Day i.DayOfTheWeekBirth, fe i(FE) vce(cluster NumericalBirthDateValue) nonest

*Panel B
use "temp\BJPolS_AnalysisData", clear
keep if HS_SocialStudies_Grade!=.
keep if YearOfBirth<1980
egen FE=group(YearOfBirth)
egen Cluster=group(YearOfBirth Week_relative_cutoff)

* Column 1
xtreg HS_SocialStudies_Grade Voting_Right Week_relative_cutoff Interaction_Week , fe i(FE) vce(cluster Cluster) nonest 
* Column 2
xtreg HS_SocialStudies_Grade Voting_Right Week_relative_cutoff Interaction_Week if Week_relative_cutoff<=6 & Week_relative_cutoff>=-5, fe i(FE) vce(cluster Cluster) nonest
* Column 3 
xtreg HS_SocialStudies_Grade Voting_Right Week_relative_cutoff Interaction_Week if Week_relative_cutoff<=5 & Week_relative_cutoff>=-4, fe i(FE) vce(cluster Cluster) nonest 
* Column 4
xtreg HS_SocialStudies_Grade Voting_Right Week_relative_cutoff Interaction_Week if Week_relative_cutoff<=4 & Week_relative_cutoff>=-3, fe i(FE) vce(cluster Cluster) nonest 
* Column 5
xtreg HS_SocialStudies_Grade Voting_Right Week_relative_cutoff Interaction_Week Week_Square Week_Square_Interaction, fe i(FE) vce(cluster Cluster) nonest 

* Column 6
replace StandJuniorHSOverallGPA=0 if JuniorHSDataExists==0   
replace StandJuniorHSSocietyGPA=0 if JuniorHSDataExists==0 
replace MotherHighEducation=0 if MotherEducationDuringTeenExists==0     
replace FatherHighEducation=0 if FatherEducationDuringTeenExists==0
replace MotherEmployedDuringTeen=0 if MotherEmploymentDuringTeenExists==0 
replace FatherEmployedDuringTeen=0 if FatherEmploymentDuringTeenExists==0

xtreg HS_SocialStudies_Grade Voting_Right Week_relative_cutoff Interaction_Week StandJuniorHSOverallGPA StandJuniorHSSocietyGPA JuniorHSDataExists MotherHighEducation MotherEducationDuringTeenExists ///
FatherHighEducation FatherEducationDuringTeenExists MotherEmployedDuringTeen MotherEmploymentDuringTeenExists FatherEmployedDuringTeen FatherEmploymentDuringTeenExists, fe i(FE) vce(cluster Cluster) nonest

* Column 7
xtreg HS_SocialStudies_Grade Voting_Right Birth_Relative_Cutoff Interaction_Day i.DayOfTheWeekBirth, fe i(FE) vce(cluster NumericalBirthDateValue) nonest

*Panel C
use "temp\BJPolS_AnalysisData", clear
keep if StandHSSocietyGPA_B!=.
keep if YearOfBirth>1976
egen FE=group(YearOfBirth)
egen Cluster=group(YearOfBirth Week_relative_cutoff)

* Column 1
xtreg StandHSSocietyGPA_B Voting_Right Week_relative_cutoff Interaction_Week , fe i(FE) vce(cluster Cluster) nonest 
* Column 2
xtreg StandHSSocietyGPA_B Voting_Right Week_relative_cutoff Interaction_Week if Week_relative_cutoff<=6 & Week_relative_cutoff>=-5, fe i(FE) vce(cluster Cluster) nonest
* Column 3 
xtreg StandHSSocietyGPA_B Voting_Right Week_relative_cutoff Interaction_Week if Week_relative_cutoff<=5 & Week_relative_cutoff>=-4, fe i(FE) vce(cluster Cluster) nonest 
* Column 4
xtreg StandHSSocietyGPA_B Voting_Right Week_relative_cutoff Interaction_Week if Week_relative_cutoff<=4 & Week_relative_cutoff>=-3, fe i(FE) vce(cluster Cluster) nonest 
* Column 5
xtreg StandHSSocietyGPA_B Voting_Right Week_relative_cutoff Interaction_Week Week_Square Week_Square_Interaction, fe i(FE) vce(cluster Cluster) nonest 

* Column 6
replace StandJuniorHSOverallGPA=0 if JuniorHSDataExists==0   
replace StandJuniorHSSocietyGPA=0 if JuniorHSDataExists==0 
replace MotherHighEducation=0 if MotherEducationDuringTeenExists==0     
replace FatherHighEducation=0 if FatherEducationDuringTeenExists==0
replace MotherEmployedDuringTeen=0 if MotherEmploymentDuringTeenExists==0 
replace FatherEmployedDuringTeen=0 if FatherEmploymentDuringTeenExists==0

xtreg StandHSSocietyGPA_B Voting_Right Week_relative_cutoff Interaction_Week StandJuniorHSOverallGPA StandJuniorHSSocietyGPA JuniorHSDataExists MotherHighEducation MotherEducationDuringTeenExists ///
FatherHighEducation FatherEducationDuringTeenExists MotherEmployedDuringTeen MotherEmploymentDuringTeenExists FatherEmployedDuringTeen FatherEmploymentDuringTeenExists, fe i(FE) vce(cluster Cluster) nonest

* Column 7
xtreg StandHSSocietyGPA_B Voting_Right Birth_Relative_Cutoff Interaction_Day i.DayOfTheWeekBirth, fe i(FE) vce(cluster NumericalBirthDateValue) nonest

*Panel D 
use "temp\BJPolS_AnalysisData", clear
keep if StandHSSocietyGPA_C!=.
keep if YearOfBirth>1976
egen FE=group(YearOfBirth)
egen Cluster=group(YearOfBirth Week_relative_cutoff)

* Column 1
xtreg StandHSSocietyGPA_C Voting_Right Week_relative_cutoff Interaction_Week , fe i(FE) vce(cluster Cluster) nonest 
* Column 2
xtreg StandHSSocietyGPA_C Voting_Right Week_relative_cutoff Interaction_Week if Week_relative_cutoff<=6 & Week_relative_cutoff>=-5, fe i(FE) vce(cluster Cluster) nonest
* Column 3 
xtreg StandHSSocietyGPA_C Voting_Right Week_relative_cutoff Interaction_Week if Week_relative_cutoff<=5 & Week_relative_cutoff>=-4, fe i(FE) vce(cluster Cluster) nonest 
* Column 4
xtreg StandHSSocietyGPA_C Voting_Right Week_relative_cutoff Interaction_Week if Week_relative_cutoff<=4 & Week_relative_cutoff>=-3, fe i(FE) vce(cluster Cluster) nonest 
* Column 5
xtreg StandHSSocietyGPA_C Voting_Right Week_relative_cutoff Interaction_Week Week_Square Week_Square_Interaction, fe i(FE) vce(cluster Cluster) nonest 

* Column 6
replace StandJuniorHSOverallGPA=0 if JuniorHSDataExists==0   
replace StandJuniorHSSocietyGPA=0 if JuniorHSDataExists==0 
replace MotherHighEducation=0 if MotherEducationDuringTeenExists==0     
replace FatherHighEducation=0 if FatherEducationDuringTeenExists==0
replace MotherEmployedDuringTeen=0 if MotherEmploymentDuringTeenExists==0 
replace FatherEmployedDuringTeen=0 if FatherEmploymentDuringTeenExists==0

xtreg StandHSSocietyGPA_C Voting_Right Week_relative_cutoff Interaction_Week StandJuniorHSOverallGPA StandJuniorHSSocietyGPA JuniorHSDataExists MotherHighEducation MotherEducationDuringTeenExists ///
FatherHighEducation FatherEducationDuringTeenExists MotherEmployedDuringTeen MotherEmploymentDuringTeenExists FatherEmployedDuringTeen FatherEmploymentDuringTeenExists, fe i(FE) vce(cluster Cluster) nonest

* Column 7
xtreg StandHSSocietyGPA_C Voting_Right Birth_Relative_Cutoff Interaction_Day i.DayOfTheWeekBirth, fe i(FE) vce(cluster NumericalBirthDateValue) nonest

**************************************************************************************************************************************************************************

**** Generate Table 5 ***************************************************************************************************************************************************
use "temp\BJPolS_AnalysisData", clear
keep if SweSAT!=.
egen FE=group(YearOfBirth)
egen Cluster=group(YearOfBirth Week_relative_cutoff)

* Column 1
xtreg SweSAT Voting_Right Week_relative_cutoff Interaction_Week , fe i(FE) vce(cluster Cluster) nonest 
* Column 2
xtreg SweSAT Voting_Right Week_relative_cutoff Interaction_Week if Week_relative_cutoff<=6 & Week_relative_cutoff>=-5, fe i(FE) vce(cluster Cluster) nonest
* Column 3 
xtreg SweSAT Voting_Right Week_relative_cutoff Interaction_Week if Week_relative_cutoff<=5 & Week_relative_cutoff>=-4, fe i(FE) vce(cluster Cluster) nonest 
* Column 4
xtreg SweSAT Voting_Right Week_relative_cutoff Interaction_Week if Week_relative_cutoff<=4 & Week_relative_cutoff>=-3, fe i(FE) vce(cluster Cluster) nonest 
* Column 5
xtreg SweSAT Voting_Right Week_relative_cutoff Interaction_Week Week_Square Week_Square_Interaction, fe i(FE) vce(cluster Cluster) nonest 

* Column 6
replace StandJuniorHSOverallGPA=0 if JuniorHSDataExists==0   
replace StandJuniorHSSocietyGPA=0 if JuniorHSDataExists==0 
replace MotherHighEducation=0 if MotherEducationDuringTeenExists==0     
replace FatherHighEducation=0 if FatherEducationDuringTeenExists==0
replace MotherEmployedDuringTeen=0 if MotherEmploymentDuringTeenExists==0 
replace FatherEmployedDuringTeen=0 if FatherEmploymentDuringTeenExists==0

xtreg SweSAT Voting_Right Week_relative_cutoff Interaction_Week StandJuniorHSOverallGPA StandJuniorHSSocietyGPA JuniorHSDataExists MotherHighEducation MotherEducationDuringTeenExists ///
FatherHighEducation FatherEducationDuringTeenExists MotherEmployedDuringTeen MotherEmploymentDuringTeenExists FatherEmployedDuringTeen FatherEmploymentDuringTeenExists, fe i(FE) vce(cluster Cluster) nonest

* Column 7
xtreg SweSAT Voting_Right Birth_Relative_Cutoff Interaction_Day i.DayOfTheWeekBirth, fe i(FE) vce(cluster NumericalBirthDateValue) nonest


**************************************************************************************************************************************************************************

**** Generate Figure B1 ***************************************************************************************************************************************************
use "temp\BJPolS_AnalysisData", clear
keep if HS_SocialStudies_Grade!=.	
gen N=1
collapse (sum) N, by(Week_relative_cutoff)
twoway bar N Week_relative_cutoff, ytitle(N) xtitle("Birth week relative to cutoff") ylabel(6000(1000)10000) xlabel(-6(1)7) xline(0.5) 


**************************************************************************************************************************************************************************

**** Generate Figure B2 ***************************************************************************************************************************************************
use "temp\BJPolS_AnalysisData", clear
keep if HS_SocialStudies_Grade!=.	

preserve
keep if YearOfBirth==1970
collapse (mean) HS_SocialStudies_Grade, by(Birth_Relative_Cutoff)
twoway scatter HS_SocialStudies_Grade Birth_Relative_Cutoff, ylabel(-0.35(0.15)0.20)ytitle("Standardized grade") xtitle("Birth day relative to the cutoff") xlabel(-47(10)48) xline(0.5) title("1988 election")
graph save "graphs\Figure_1970", replace 
restore

preserve
keep if YearOfBirth==1973
collapse (mean) HS_SocialStudies_Grade, by(Birth_Relative_Cutoff)
twoway scatter HS_SocialStudies_Grade Birth_Relative_Cutoff, ylabel(-0.35(0.15)0.20)ytitle("Standardized grade") xtitle("Birth day relative to the cutoff") xlabel(-47(10)48) xline(0.5) title("1991 election")
graph save "graphs\Figure_1973", replace 
restore

preserve
keep if YearOfBirth==1976
collapse (mean) HS_SocialStudies_Grade, by(Birth_Relative_Cutoff)
twoway scatter HS_SocialStudies_Grade Birth_Relative_Cutoff, ylabel(-0.35(0.15)0.20)ytitle("Standardized grade") xtitle("Birth day relative to the cutoff") xlabel(-47(10)48) xline(0.5) title("1994 election")
graph save "graphs\Figure_1976", replace 
restore

preserve
keep if YearOfBirth==1980
collapse (mean) HS_SocialStudies_Grade, by(Birth_Relative_Cutoff)
twoway scatter HS_SocialStudies_Grade Birth_Relative_Cutoff, ylabel(-0.35(0.15)0.20)ytitle("Standardized grade") xtitle("Birth day relative to the cutoff") xlabel(-47(10)48) xline(0.5) title("1998 election")
graph save "graphs\Figure_1980", replace 
restore

preserve
keep if YearOfBirth==1984
collapse (mean) HS_SocialStudies_Grade, by(Birth_Relative_Cutoff)
twoway scatter HS_SocialStudies_Grade Birth_Relative_Cutoff, ylabel(-0.35(0.15)0.20)ytitle("Standardized grade") xtitle("Birth day relative to the cutoff") xlabel(-47(10)48) xline(0.5) title("2002 election")
graph save "graphs\Figure_1984", replace 
restore

preserve
keep if YearOfBirth==1985
collapse (mean) HS_SocialStudies_Grade, by(Birth_Relative_Cutoff)
twoway scatter HS_SocialStudies_Grade Birth_Relative_Cutoff, ylabel(-0.35(0.15)0.20)ytitle("Standardized grade") xtitle("Birth day relative to the cutoff") xlabel(-47(10)48) xline(0.5) title("2003 election")
graph save "graphs\Figure_1985", replace 
restore

preserve
keep if YearOfBirth==1988
collapse (mean) HS_SocialStudies_Grade, by(Birth_Relative_Cutoff)
twoway scatter HS_SocialStudies_Grade Birth_Relative_Cutoff, ylabel(-0.35(0.15)0.20)ytitle("Standardized grade") xtitle("Birth day relative to the cutoff") xlabel(-47(10)48) xline(0.5) title("2006 election")
graph save "graphs\Figure_1988", replace 
restore

graph combine "graphs\Figure_1970" "graphs\Figure_1973" "graphs\Figure_1976" "graphs\Figure_1980" "graphs\Figure_1984" "graphs\Figure_1985" "graphs\Figure_1988", cols(3) iscale(0.6) 



**************************************************************************************************************************************************************************

**** Generate Figure B3 (different data) ***********************************************************************************************************************************
use "raw\Historiskafbr_2009", clear 
keep if fodd==1
capture rename dnr2014115 Person_ID
bysort Person_ID: keep if _n==1  
gen YearOfBirth=substr(datfran,1,4) /* runs from 1969-2009*/
capture destring YearOfBirth, replace
gen MonthOfBirth=substr(datfran,5,2)
capture destring MonthOfBirth, replace
gen DayOfBirth=substr(datfran,7,2)
capture destring DayOfBirth, replace
gen NumericalBirthDateValue=mdy(MonthOfBirth, DayOfBirth, YearOfBirth)
gen DayOfTheWeekBirth=dow(NumericalBirthDateValue)
keep Person_ID YearOfBirth MonthOfBirth DayOfBirth NumericalBirthDateValue DayOfTheWeekBirth 
order Person_ID YearOfBirth MonthOfBirth DayOfBirth NumericalBirthDateValue DayOfTheWeekBirth 

keep if YearOfBirth>=1979 & YearOfBirth<=1989 
 


merge 1:1 Person_ID using "use\BJPolS_HighSchool1997_2010_A", keep(match master) keepusing(SocietyKnowlegdeGPA_A)
drop _merge  

egen group=group(YearOfBirth MonthOfBirth)

label define example 1 "Jan 1979" 13 "Jan 1980" 25 "Jan 1981" 37 "Jan 1982" 49 "Jan 1983" 61 "Jan 1984" 73 "Jan 1985" 85 "Jan 1986" 97 "Jan 1987" 109 "Jan 1988" 121 "Jan 1989"
label val group example


collapse (mean) SocietyKnowlegdeGPA_A, by(group)
twoway scatter SocietyKnowlegdeGPA_A group,  ytitle("High school grade in Social Studies") xtitle("Birth month") xline(12.5 24.5 60.5 72.5 84.5 108.5 120.5) xlabel(1 13 25 37 49 61 73 85 97 109 121, valuelabel alternate) 



**************************************************************************************************************************************************************************

**** Generate Table B1 ***************************************************************************************************************************************************
use "temp\BJPolS_AnalysisData", clear
keep if HS_SocialStudies_Grade!=.
egen FE=group(YearOfBirth)
egen Cluster=group(YearOfBirth Week_relative_cutoff)

*Panel A
*column 1
xtreg StandJuniorHSOverallGPA Voting_Right Week_relative_cutoff Interaction_Week , fe i(FE) vce(cluster Cluster) nonest

*column 2
xtreg StandJuniorHSSocietyGPA Voting_Right Week_relative_cutoff Interaction_Week , fe i(FE) vce(cluster Cluster) nonest

*column 3
xtreg MotherHighEducation Voting_Right Week_relative_cutoff Interaction_Week , fe i(FE) vce(cluster Cluster) nonest

*column 4
xtreg FatherHighEducation Voting_Right Week_relative_cutoff Interaction_Week , fe i(FE) vce(cluster Cluster) nonest

*column 5
xtreg MotherEmployedDuringTeen Voting_Right Week_relative_cutoff Interaction_Week , fe i(FE) vce(cluster Cluster) nonest

*column 6
xtreg FatherEmployedDuringTeen Voting_Right Week_relative_cutoff Interaction_Week , fe i(FE) vce(cluster Cluster) nonest

*Panel B
*column 1
xtreg StandJuniorHSOverallGPA Voting_Right Week_relative_cutoff Interaction_Week if Week_relative_cutoff<=6 & Week_relative_cutoff>=-5, fe i(FE) vce(cluster Cluster) nonest

*column 2
xtreg StandJuniorHSSocietyGPA Voting_Right Week_relative_cutoff Interaction_Week if Week_relative_cutoff<=6 & Week_relative_cutoff>=-5, fe i(FE) vce(cluster Cluster) nonest

*column 3
xtreg MotherHighEducation Voting_Right Week_relative_cutoff Interaction_Week if Week_relative_cutoff<=6 & Week_relative_cutoff>=-5, fe i(FE) vce(cluster Cluster) nonest

*column 4
xtreg FatherHighEducation Voting_Right Week_relative_cutoff Interaction_Week if Week_relative_cutoff<=6 & Week_relative_cutoff>=-5, fe i(FE) vce(cluster Cluster) nonest

*column 5
xtreg MotherEmployedDuringTeen Voting_Right Week_relative_cutoff Interaction_Week if Week_relative_cutoff<=6 & Week_relative_cutoff>=-5, fe i(FE) vce(cluster Cluster) nonest

*column 6
xtreg FatherEmployedDuringTeen Voting_Right Week_relative_cutoff Interaction_Week if Week_relative_cutoff<=6 & Week_relative_cutoff>=-5, fe i(FE) vce(cluster Cluster) nonest

*Panel C
*column 1
xtreg StandJuniorHSOverallGPA Voting_Right Week_relative_cutoff Interaction_Week if Week_relative_cutoff<=5 & Week_relative_cutoff>=-4, fe i(FE) vce(cluster Cluster) nonest

*column 2
xtreg StandJuniorHSSocietyGPA Voting_Right Week_relative_cutoff Interaction_Week if Week_relative_cutoff<=5 & Week_relative_cutoff>=-4, fe i(FE) vce(cluster Cluster) nonest

*column 3
xtreg MotherHighEducation Voting_Right Week_relative_cutoff Interaction_Week if Week_relative_cutoff<=5 & Week_relative_cutoff>=-4, fe i(FE) vce(cluster Cluster) nonest

*column 4
xtreg FatherHighEducation Voting_Right Week_relative_cutoff Interaction_Week if Week_relative_cutoff<=5 & Week_relative_cutoff>=-4, fe i(FE) vce(cluster Cluster) nonest

*column 5
xtreg MotherEmployedDuringTeen Voting_Right Week_relative_cutoff Interaction_Week if Week_relative_cutoff<=5 & Week_relative_cutoff>=-4, fe i(FE) vce(cluster Cluster) nonest

*column 6
xtreg FatherEmployedDuringTeen Voting_Right Week_relative_cutoff Interaction_Week if Week_relative_cutoff<=5 & Week_relative_cutoff>=-4, fe i(FE) vce(cluster Cluster) nonest

*Panel D
*column 1
xtreg StandJuniorHSOverallGPA Voting_Right Week_relative_cutoff Interaction_Week if Week_relative_cutoff<=4 & Week_relative_cutoff>=-3, fe i(FE) vce(cluster Cluster) nonest

*column 2
xtreg StandJuniorHSSocietyGPA Voting_Right Week_relative_cutoff Interaction_Week if Week_relative_cutoff<=4 & Week_relative_cutoff>=-3, fe i(FE) vce(cluster Cluster) nonest

*column 3
xtreg MotherHighEducation Voting_Right Week_relative_cutoff Interaction_Week if Week_relative_cutoff<=4 & Week_relative_cutoff>=-3, fe i(FE) vce(cluster Cluster) nonest

*column 4
xtreg FatherHighEducation Voting_Right Week_relative_cutoff Interaction_Week if Week_relative_cutoff<=4 & Week_relative_cutoff>=-3, fe i(FE) vce(cluster Cluster) nonest

*column 5
xtreg MotherEmployedDuringTeen Voting_Right Week_relative_cutoff Interaction_Week if Week_relative_cutoff<=4 & Week_relative_cutoff>=-3, fe i(FE) vce(cluster Cluster) nonest

*column 6
xtreg FatherEmployedDuringTeen Voting_Right Week_relative_cutoff Interaction_Week if Week_relative_cutoff<=4 & Week_relative_cutoff>=-3, fe i(FE) vce(cluster Cluster) nonest

*Panel E
*column 1
xtreg StandJuniorHSOverallGPA Voting_Right Week_relative_cutoff Interaction_Week Week_Square Week_Square_Interaction, fe i(FE) vce(cluster Cluster) nonest

*column 2
xtreg StandJuniorHSSocietyGPA Voting_Right Week_relative_cutoff Interaction_Week Week_Square Week_Square_Interaction, fe i(FE) vce(cluster Cluster) nonest

*column 3
xtreg MotherHighEducation Voting_Right Week_relative_cutoff Interaction_Week Week_Square Week_Square_Interaction, fe i(FE) vce(cluster Cluster) nonest

*column 4
xtreg FatherHighEducation Voting_Right Week_relative_cutoff Interaction_Week Week_Square Week_Square_Interaction, fe i(FE) vce(cluster Cluster) nonest

*column 5
xtreg MotherEmployedDuringTeen Voting_Right Week_relative_cutoff Interaction_Week Week_Square Week_Square_Interaction, fe i(FE) vce(cluster Cluster) nonest

*column 6
xtreg FatherEmployedDuringTeen Voting_Right Week_relative_cutoff Interaction_Week Week_Square Week_Square_Interaction, fe i(FE) vce(cluster Cluster) nonest


**************************************************************************************************************************************************************************

**** Generate Table B2 ***************************************************************************************************************************************************
use "temp\BJPolS_AnalysisData", clear
keep if HS_SocialStudies_Grade!=.
egen FE=group(YearOfBirth)
egen Cluster=group(YearOfBirth Week_relative_cutoff)
*column 1
reg HS_SocialStudies_Grade Voting_Right Birth_Relative_Cutoff Interaction_Day i.FE i.DayOfTheWeekBirth if Week_relative_cutoff<=6 & Week_relative_cutoff>=-5, vce(hc2)

*column 2
reg HS_SocialStudies_Grade Voting_Right Birth_Relative_Cutoff Interaction_Day i.FE i.DayOfTheWeekBirth if Week_relative_cutoff<=5 & Week_relative_cutoff>=-4, vce(hc2)

*column 3
reg HS_SocialStudies_Grade Voting_Right Birth_Relative_Cutoff Interaction_Day i.FE i.DayOfTheWeekBirth if Week_relative_cutoff<=4 & Week_relative_cutoff>=-3, vce(hc2)


**************************************************************************************************************************************************************************

**** Generate Table B3 ***************************************************************************************************************************************************
use "temp\BJPolS_AnalysisData", clear
keep if HS_SocialStudies_Grade!=.
egen FE=group(YearOfBirth)
egen Cluster=group(YearOfBirth Week_relative_cutoff) 

* Column 1
reg HS_SocialStudies_Grade Voting_Right Week_relative_cutoff Interaction_Week i.FE ,vce(hc2) 
* Column 2
reg HS_SocialStudies_Grade Voting_Right Week_relative_cutoff Interaction_Week i.FE if Week_relative_cutoff<=6 & Week_relative_cutoff>=-5, vce(hc2)
* Column 3 
reg HS_SocialStudies_Grade Voting_Right Week_relative_cutoff Interaction_Week i.FE if Week_relative_cutoff<=5 & Week_relative_cutoff>=-4, vce(hc2) 
* Column 4
reg HS_SocialStudies_Grade Voting_Right Week_relative_cutoff Interaction_Week i.FE if Week_relative_cutoff<=4 & Week_relative_cutoff>=-3, vce(hc2) 
* Column 5
reg HS_SocialStudies_Grade Voting_Right Week_relative_cutoff Interaction_Week Week_Square Week_Square_Interaction i.FE, vce(hc2) 

* Column 6
replace StandJuniorHSOverallGPA=0 if JuniorHSDataExists==0   
replace StandJuniorHSSocietyGPA=0 if JuniorHSDataExists==0 
replace MotherHighEducation=0 if MotherEducationDuringTeenExists==0     
replace FatherHighEducation=0 if FatherEducationDuringTeenExists==0
replace MotherEmployedDuringTeen=0 if MotherEmploymentDuringTeenExists==0 
replace FatherEmployedDuringTeen=0 if FatherEmploymentDuringTeenExists==0

reg HS_SocialStudies_Grade Voting_Right Week_relative_cutoff Interaction_Week StandJuniorHSOverallGPA StandJuniorHSSocietyGPA JuniorHSDataExists MotherHighEducation MotherEducationDuringTeenExists ///
FatherHighEducation FatherEducationDuringTeenExists MotherEmployedDuringTeen MotherEmploymentDuringTeenExists FatherEmployedDuringTeen FatherEmploymentDuringTeenExists i.FE, vce(hc2)

* Column 7
reg HS_SocialStudies_Grade Voting_Right Birth_Relative_Cutoff Interaction_Day i.FE i.DayOfTheWeekBirth, vce(hc2)


**************************************************************************************************************************************************************************




