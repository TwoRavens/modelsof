set mem 10m
set more off 
set rmsg on

*need to rename variables to correspond to the paper
*throw out all variables not needed for any output


**********************************************
*
*    Table 3
*
**********************************************

use data_file1, clear 

gen simultaneous=(taskall==1)
gen elimination=(taskall==2)
gen tournament=(taskall==3)
gen choose=(task==4)

gen first_stage=(task==1 | task==2 | task==3)

tab numericaltaskorder, g(taskorder)
tab pdf, g(pdf)

*table 3
probit optimal elimination tournament age male somecollege college pdf2 pdf3 pdf4 taskorder2 taskorder3 if first_stage, robust cluster(id)
outreg2 using table3, excel bdec(3) tdec(3) adec(0) addstat(log likelihood, e(ll)) ctitle(optimal choice probit) replace

regress optimal elimination tournament age male somecollege college pdf2 pdf3 pdf4 taskorder2 taskorder3 if first_stage, robust cluster(id)
outreg2 using table3, excel bdec(3) tdec(3) adec(0) addstat(log likelihood, e(ll)) ctitle(optimal choice lpm) append

regress mlot elimination tournament age male somecollege college pdf2 pdf3 pdf4 taskorder2 taskorder3 if first_stage, robust cluster(id)
outreg2 using table3, excel bdec(3) tdec(3) adec(0) addstat(log likelihood, e(ll)) ctitle(mlot ols) append




**********************************************
*
*    Table 5
*
**********************************************

use data_file2, clear

gen elimination=(taskall==2)
gen tournament=(taskall==3)

*table 5
clogit chosen payoff chosen_lastround if elimination, group(csevar) vce(cluster id)
outreg2 using table5, excel bdec(3) tdec(3) adec(0) addstat(log likelihood, e(ll)) ctitle(elimination) replace

clogit chosen payoff if tournament, group(csevar) vce(cluster id)
outreg2 using table5, excel bdec(3) tdec(3) adec(0) addstat(log likelihood, e(ll)) ctitle(sequential) append

clogit chosen payoff chosen_lastround, group(csevar) vce(cluster id)
outreg2 using table5, excel bdec(3) tdec(3) adec(0) addstat(log likelihood, e(ll)) ctitle(pooled) append




**********************************************
*
*    Tables 2, 4, and 6
*
**********************************************

use data_file3, clear

gen first_stage=(task==1 | task==2 | task==3)

*table 2
tabstat optimal mlot time if first_stage, by(taskall) format(%4.2f)

*table 4
tabstat optimalround mlotround if first_stage, by(taskall) format(%4.2f)

*table 6 - the table is created by appending the second command's outout to the appropriate columns created by the first command
tabstat optimal mlot if task==4, by(taskall) format(%4.2f)
tabstat optimal mlot if first_stage, by(taskall) format(%4.2f)




**********************************************
*
*    Tables 7 and 8
*
**********************************************

use data_file4.dta, clear

gen relative31=time3/time1

egen med_relative31=median(relative31)

gen below_med_relative31=(relative31<=med_relative31)
gen above_med_relative31=(relative31>med_relative31)

*table 7
tab mostpreferred if unambest==1
tab mostpreferred if unambest==2
tab mostpreferred if unambest==3
tab mostpreferred if unambest==0


*table 8
tab2 unambest mostpreferred if  below_med_relative31
tab2 unambest mostpreferred if  above_med_relative31


