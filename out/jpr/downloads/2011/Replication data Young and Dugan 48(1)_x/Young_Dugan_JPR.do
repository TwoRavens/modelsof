****************************************************  Model Estimation and Robustness Checks         **  Author: Joe Young                              **  Date: 8/20/08 updated 12/17/09                 **  Project: Veto Players and Terror               * *  Co-author: Laura Dugan                         ****************************************************
version 10.1
*use Young_Dugan_JPR.dtaset more off// The delimiter is changed to a ;
// Grab the delimiter line and the several lines of code to
// estimate models separately*************************************************** Models for Table 1                             ******************************************************************************************************  Model 1--NBREG                                **       Fatal Attacks as the Dep. Var            **       HOMEGROWN                                **       veto as the ind. var.                    **                                                ***************************************************#delimit ;nbreg home_fattacks_lead veto pressfree1 partdem lpop gdpen war coldwar durable home_pastfatt Europe Africa Asia America, nolog cluster(cowcode);***************************************************  Model 2--NBREG                                **       Fatal Attacks as the dep. var.           **       AMBIGUOUS				                 **       veto as the ind. var.                    **                                                ***************************************************#delimit ;nbreg ambig_fattacks_lead veto pressfree1 partdem lpop gdpen war coldwar durable ambig_pastfatt Europe Africa Asia America, nolog cluster(cowcode);***************************************************  Model 3--NBREG                                **       Fatal Attacks as the dep. var.           **		FOREIGN                          		 **       veto as the ind. var.                    **                                                ***************************************************#delimit ;nbreg foreign_fattacks_lead veto pressfree1 partdem lpop gdpen war coldwar durable Europe Africa Asia America foreign_pastfatt, nolog cluster(cowcode);***************************************************  Model 4--NBREG                                **       Fatal Attacks as the dep. var.           **		ALL FATAL ATTACKS                        **       veto as the ind. var.                    **                                                ***************************************************#delimit ;nbreg all_fattacks veto pressfree1 partdem lpop gdpen war coldwar durable Europe Africa Asia America past_fattack_all, nolog cluster(cowcode);*************************************************** Models for Table 2--Other Estimation Techniques********************************************************************************************** ZINBs-Only Press Freedom at 1st Stage  **********************************************************************************************  Model 5--ZINB                                 **       Fatal Attacks as the Dep. Var            **       ALL ATTACKS                              **       veto as the ind. var.                    **                                                ***************************************************#delimit ;zinb all_fattacks veto pressfree1 partdem lpop gdpen war coldwar durable past_fattack_all Europe Africa Asia America, inflate(pressfree1) nolog cluster(cowcode);***************************************************  Model 6--ZINB                                 **       Fatal Attacks as the Dep. Var            **       HOMEGROWN                                **       veto as the ind. var.                    **                                                ***************************************************#delimit ;zinb home_fattacks_lead veto pressfree1 partdem lpop gdpen war coldwar durable home_pastfatal Europe Africa Asia America, inflate(pressfree1) nolog cluster(cowcode);***************************************************  Model 7--ZINB                                 **       Fatal Attacks as the dep. var.           **       AMBIGUOUS       						 *
*       veto as the ind. var.                    **                                                ***************************************************#delimit ;zinb ambig_fattacks_lead veto pressfree1 partdem lpop gdpen war coldwar durable ambig_fattacks Europe Africa Asia America, inflate(pressfree1) nolog cluster(cowcode);***************************************************  Model 8--ZINB                                 **       Fatal Attacks as the dep. var.           **		FOREIGN                                  **       veto as the ind. var.                    **                                                ***************************************************#delimit ;zinb foreign_fattacks_lead veto pressfree1 partdem lpop gdpen war coldwar durable Europe Africa Asia America foreign_pastfatt, inflate(pressfree1) nolog cluster(cowcode);

***************************************************************************** Different Operationalizations of the DV-LOGIT, XTLOGIT, RELOGIT, TOBIT   *****************************************************************************

*************************************************
* Model 9--LOGIT                                *
* Terror dummy as the dep. var.                 *
*************************************************     
#delimit ;logit terrordum veto pressfree1 partdem lpop gdpen war coldwar durable ambig_fattacks Europe Africa Asia America lmtnest, nolog cluster(cowcode);


*************************************************
* Model 10--XTLOGIT                             *
* Terror dummy as the dep. var.                 *
*************************************************     

#delimit ;xtlogit terrordum veto pressfree1 partdem lpop gdpen war coldwar durable ambig_fattacks Europe Africa Asia America lmtnest, nolog;

*************************************************** Model 11-RELOGIT                               *
* Terror dummy as the dep. var.                  ***************************************************
//You will need the relogit command from King
//http://gking.harvard.edu/stats.shtml#relogit
#delimit ;relogit terrordum veto pressfree1 partdem lpop gdpen war coldwar durable ambig_fattacks Europe Africa Asia America lmtnest, cluster(cowcode);

************************************************** Model 12-TOBIT                                *
* FATPOP-Fatalities/population as the DV        **************************************************#delimit ;tobit fatpop veto pressfree1 partdem lpop gdpen war coldwar durable ambig_fattacks Europe Africa Asia America lmtnest, ll(0);

**************************************************
* Different Data (ITERATE)/Samples (Democracies) *
**************************************************

************************************************** Model 13-NBREG                                * 
* All Fatal Attack as the DV                    *
* Sample - Democracies as defined  by ACLP      **************************************************#delimit ;nbreg all_fattacks checks partdem pressfree1 lpop gdpen war coldwar durable past_fattack_all Europe Africa Asia America if reg==0, nolog cluster(cowcode);


***************************************************  Model 14--NBREG                               **       ITERATE as the Dep. Var    	  	         **       veto as the ind. var.                    **                                                ***************************************************#delimit ;nbreg event1lead veto pressfree1 partdem lpop gdpen war coldwar durable historyl Europe Africa Asia America, nolog cluster(cowcode);
***************************************************  Model 15--ZINB                                *
*       ITERATE as the Dep. Var          	     *
*       veto as the ind. var.                    *
*                                                ***************************************************#delimit ;zinb event1lead veto pressfree1 partdem lpop gdpen war coldwar durable historyl Europe Africa Asia America, inflate(pressfree1) nolog cluster(cowcode);