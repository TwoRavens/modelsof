
*     ***************************************************************** * 
*     ***************************************************************** * 
*       File-Name:      master.do                                       * 
*       Date:           April 5, 2019                                   * 
*       Author:         Bowler, Gschwend, Indridason                    * 
*       Purpose:      	replicate analysis of                           *
*                       Coalition Policy Perceptions                    * 
* 	    Input File:                                                     * 
*       Data Output:                                                    *              
*       Machine:        office computer                 				* 
*     ****************************************************************  * 
*     ****************************************************************  * 


* You need to dowload the following ado's before running this code:
* - parmest - 
* - parmby - 
* - dsconcat - 
* - fre - 
* - estout -




clear
set more off
version 15.1





* ********************************************************************* * 
*       Performs basic recoding and analysis of German data               
* 	    Input File:     ZA5305_en_v5-0-0.dta                                    
*       Data Output:    analysis.dta                                        
* ********************************************************************  * 

do recode



* ********************************************************************* * 
*       Uses analysis.dta to generate Figure 4 for CS and CF coalitions               
* 	    Input File:     analysis.dta                                    
*       Data Output:                                            
* ********************************************************************  * 


do sim_new_csk_i
do sim_new_cfk_i




* ************************************************************************************** * 
*       Uses analysis.dta to graph further results for CS and CF coalitions for APPENDIX              
* 	    Input File:     analysis.dta                                    
*       Data Output:    description_g.dta                                       
* **************************************************************************************  * 


* Figure A1 (in Appendix)
do sim_new_csk_ib    // Replication of Figure 4 in paper with Banzhaf instead of Party Size
do sim_new_cfk_ib    // Replication of Figure 4 in paper with Banzhaf instead of Party Size


* Figures A2 & A4 (in Appendix)
do sim_know_csk_margin  // average marginal effect conditional on Political Knowledge CDU-SPD (for bargaining power = Party Size)
do sim_know_cfk_margin  // average marginal effect conditional on Political Knowledge CDU-FDP (for bargaining power = Party Size)


* Figures A3 & A5 (in Appendix)
do sim_know_csk_margin_banz  // average marginal effect conditional on Political Knowledge CDU-SPD (for bargaining power = Banzhaf)
do sim_know_cfk_margin_banz  // average marginal effect conditional on Political Knowledge CDU-FDP (for bargaining power = Banzhaf)




* ********************************************************* * 
*       Performs basic recoding and analysis  for Austria              
* 	    Input File:     ZA5859_en_v2-0-1.dta                                    
*       Data Output:    description_a.dta                                        
* ********************************************************  * 

do austria



* ********************************************************* * 
*       Performs basic recoding and analysis  for Sweden              
* 	    Input File:     w2_w5_w6_w7_CampaignSweden.dta                                    
*       Data Output:    description_s.dta                                        
* ********************************************************  * 

do sweden


* ******************************************************************************************* * 
*       Compiles description*.dta from all studies and generates overveiw table for APPENDIX              
* 	    Input File:     description*.dta                                    
*       Data Output:                                            
* *******************************************************************************************  * 

do description



