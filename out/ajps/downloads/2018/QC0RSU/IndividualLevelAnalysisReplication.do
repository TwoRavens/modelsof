/*	Clinton, Lewis & Selin				              */
/*	CONDUCT ANALYSIS FOR SECTION 4 & Appendix		  */
/*	Replication for Individual Level Analysis 			  */

/*	NOTE: We are limited by IRB in what we can release because of the need to protect the identity of our respondents*/
/*  If you are IRB certified, please contact us for data to replicate the following tables

/*	In the text: Table 3                */
/*	In the appendix: A2, A4, A6, and B1 */


use "IndividualLevelDataAllReplication.dta"

/*	Replicate Table 2 in text	*/

/* recode jobset_3 (1=4) (2=3) (3=2) (4=1) (5=.) */

reg commi changes burrow numapp jobset_3 policyareas bushagenda

/*	agcode hidden for confidentiality reasons */

reg commi changes burrow numapp jobset_3 policyareas bushagenda, cluster(agcode)
reg commi changes burrow numapp jobset_3 policyareas if bushagenda==0, cluster(agcode)
