/**********************************************************************
File Name: "phayal_etal_ISQ.dta 								
Date:	July 17, 2014												
Author: Clayton L. Thyne											
Purpose: This file replicates the regression results for 	
Phayal, Anup, Prabin Khadka, and Clayton L. Thyne. 2014. 'What Makes an
Ex-combatant Happy? A Micro Analysis of Disarmament, Demobilization and
Reintegration in South Sudan.' International Studies Quarterly, 
forthcoming.
**********************************************************************/

/*T1M1*/
ologit satis monthly_in training political_concern cattle_concern firearm UNpresence same sec_better ///
	dinka education age rank male killings cereal 
/*T1M2*/
ologit satis monthly_in training political_concern cattle_concern firearm inter1 UNpresence same sec_better ///
	dinka education age rank male killings cereal 
/*T1M3*/
ologit satis monthly_in training political_concern cattle_concern firearm inter2 UNpresence same sec_better ///
	dinka education age rank male killings cereal 
