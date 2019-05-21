************************************************************************************************************************************************
***  PROJECT:		"Language Shapes People’s Time Perspective and Support for Future-Oriented Policies", American Journal of Political Science
***  AUTHORS:		Efren O. Perez and Margit Tavits
***  DESCRIPTION: 	Replicating Table SI.5.1 (ISSP survey)
***  DATE: 			October 22, 2016
************************************************************************************************************************************************

*****************************************************
*** NON-DEFAULT PACKAGES:*****
*** - outreg2 ("ssc install outreg2")
*****************************************************

*********************************************************************************************
**MAKE SURE YOU ADD YOUR DIRECTORY INFORMATION TO FILE NAMES BEFORE YOUR RUN THIS CODE
*********************************************************************************************

clear
set more off

***Call up the ISSP Analysis Dataset
use "ISSP_Analysis_Dataset.dta"


***Model 1
xi: reg AcceptCost Strong_FTR i.FixEff0, vce(cluster country)
***Model 2
xi: reg AcceptCost Strong_FTR Unemployed Married Education i.FixEff0 , vce(cluster country)
***Model 3
xi: reg AcceptCost Strong_FTR Unemployed Married Education Trust Democracy i.FixEff0, vce(cluster country)

****Generate output, Table SI.5.1
xi: reg AcceptCost Strong_FTR i.FixEff0, vce(cluster country)
outreg2 using "Output_SI_5_1", word dec(3) ctitle(Model 1 Accept Cost) se replace keep(Strong_FTR) addtext (Education, NO, Married, NO, Sex*Age, YES) 
xi: reg AcceptCost Strong_FTR Unemployed Married Education i.FixEff0 , vce(cluster country)
outreg2 using "Output_SI_5_1", word dec(3) ctitle(Model 2 Accept Cost) se append keep(Strong_FTR Unemployed) addtext (Education, YES, Married, YES, Sex*Age, YES)
xi: reg AcceptCost Strong_FTR Unemployed Married Education Trust Democracy i.FixEff0, vce(cluster country)
outreg2 using "Output_SI_5_1", word dec(3) ctitle(Model 3 Accept Cost) se append keep(Strong_FTR Unemployed Trust Democracy) addtext (Education, YES, Married, YES, Sex*Age, YES)

