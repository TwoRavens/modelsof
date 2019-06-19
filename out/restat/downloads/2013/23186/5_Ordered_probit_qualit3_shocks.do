**** THIS PROGRAM ESTIMATES A DYNAMIC STATE-DEPENDENT MODEL 
**** WITH PERMANENT OR TRANSITORY INCREASES OR DECREASES 
**** IN INPUT PRICES, PRODUCTION, ETC.  ****

capture clear
capture log close

adopath + C:\ado_stata

log using "C:\5_ordered_probit_qualit3_shocks.log", replace

clear

set memory 800m
set more off

use "C:\stata_base_q3_asym_chocs"

preserve

tsset ident_stata numenq


/** FIRST STEP INSTRUMENTAL REGRESSIONS **/
local instruments   l1_evprmp_i3_up   l2_evprmp_i3_up l3_evprmp_i3_up l4_evprmp_i3_up l5_evprmp_i3_up   l6_evprmp_i3_up /*l7_evprmp_i3_up l8_evprmp_i3_up l9_evprmp_i3_up l10_evprmp_i3_up*/       ///  
		        l1_evprmp_p3_up   l2_evprmp_p3_up l3_evprmp_p3_up l4_evprmp_p3_up l5_evprmp_p3_up   l6_evprmp_p3_up /*l7_evprmp_p3_up l8_evprmp_p3_up l9_evprmp_p3_up l10_evprmp_p3_up*/       ///  
                    l1_evpro_i3_up   l2_evpro_i3_up l3_evpro_i3_up l4_evpro_i3_up l5_evpro_i3_up   l6_evpro_i3_up /*l7_evpro_i3_up l8_evpro_i3_up l9_evpro_i3_up l10_evpro_i3_up */        ///
                    l1_evpro_p3_up   l2_evpro_p3_up l3_evpro_p3_up l4_evpro_p3_up l5_evpro_p3_up   l6_evpro_p3_up /*l7_evpro_p3_up l8_evpro_p3_up l9_evpro_p3_up l10_evpro_p3_up */        ///
                    l1_isalmtot2_up   l2_isalmtot2_up l3_isalmtot2_up l4_isalmtot2_up l5_isalmtot2_up  l6_isalmtot2_up /*l7_isalmtot2 l8_isalmtot2 l9_isalmtot2 l10_isalmtot2 */        ///
                    l1_txipp2_i3_up   l2_txipp2_i3_up l3_txipp2_i3_up l4_txipp2_i3_up l5_txipp2_i3_up   l6_txipp2_i3_up /*l7_txipp2 l8_txipp2 l9_txipp2 l10_txipp2 */       ///
                    l1_txipp2_p3_up   l2_txipp2_p3_up l3_txipp2_p3_up l4_txipp2_p3_up l5_txipp2_p3_up   l6_txipp2_p3_up /*l7_txipp2 l8_txipp2 l9_txipp2 l10_txipp2 */       ///
                   l1_evprmp_i3_down   l2_evprmp_i3_down l3_evprmp_i3_down l4_evprmp_i3_down l5_evprmp_i3_down   l6_evprmp_i3_down /*l7_evprmp_i3_down l8_evprmp_i3_down l9_evprmp_i3_down l10_evprmp_i3_down*/       ///  
		        l1_evprmp_p3_down   l2_evprmp_p3_down l3_evprmp_p3_down l4_evprmp_p3_down l5_evprmp_p3_down   l6_evprmp_p3_down /*l7_evprmp_p3_down l8_evprmp_p3_down l9_evprmp_p3_down l10_evprmp_p3_down*/       ///  
                    l1_evpro_i3_down   l2_evpro_i3_down l3_evpro_i3_down l4_evpro_i3_down l5_evpro_i3_down   l6_evpro_i3_down /*l7_evpro_i3_down l8_evpro_i3_down l9_evpro_i3_down l10_evpro_i3_down */        ///
                    l1_evpro_p3_down   l2_evpro_p3_down l3_evpro_p3_down l4_evpro_p3_down l5_evpro_p3_down   l6_evpro_p3_down /*l7_evpro_p3_down l8_evpro_p3_down l9_evpro_p3_down l10_evpro_p3_down */        ///
                    l1_isalmtot2_down   l2_isalmtot2_down l3_isalmtot2_down l4_isalmtot2_down l5_isalmtot2_down  l6_isalmtot2_down /*l7_isalmtot2 l8_isalmtot2 l9_isalmtot2 l10_isalmtot2 */        ///
                    l1_txipp2_i3_down   l2_txipp2_i3_down l3_txipp2_i3_down l4_txipp2_i3_down l5_txipp2_i3_down   l6_txipp2_i3_down /*l7_txipp2 l8_txipp2 l9_txipp2 l10_txipp2 */       ///
                    l1_txipp2_p3_down   l2_txipp2_p3_down l3_txipp2_p3_down l4_txipp2_p3_down l5_txipp2_p3_down   l6_txipp2_p3_down /*l7_txipp2 l8_txipp2 l9_txipp2 l10_txipp2 */       ///
                    /*ind_DA*/ ind_db ind_dc ind_dd ind_de ind_dg ind_dh ind_di ///
                   ind_dj ind_dk ind_dl ind_dm ind_dn ///
	tva_2000 tva_2000_2 euro_2002 euro_2002_2 ///
      mois_1 mois_7 trim1 trim2 trim3 ///
      annee_1999 annee_2000 annee_2001 annee_2002 annee_2003 annee_2004 /*annee_2005*/ 


regress evprmp_i3_up  `instruments'   
predict pred_evprmp_i3_up, xb 
predict res_evprmp_i3_up, residual 

regress evprmp_l1_i3_up `instruments' 
predict pred_evprmp_l1_i3_up, xb 
predict res_evprmp_l1_i3_up, residual 

regress evprmp_l2_i3_up `instruments' 
predict pred_evprmp_l2_i3_up, xb 
predict res_evprmp_l2_i3_up, residual 

regress evprmp_l3_i3_up  `instruments'
predict pred_evprmp_l3_i3_up, xb 
predict res_evprmp_l3_i3_up, residual 


regress prevpro_i3_up   `instruments'   
predict pred_prevpro_i3_up, xb 
predict res_prevpro_i3_up, residual 

regress evpro_i3_up   `instruments'   
predict pred_evpro_i3_up, xb 
predict res_evpro_i3_up, residual 

regress evpro_l1_i3_up  `instruments' 
predict pred_evpro_l1_i3_up, xb 
predict res_evpro_l1_i3_up, residual 

regress evpro_l2_i3_up  `instruments' 
predict pred_evpro_l2_i3_up, xb 
predict res_evpro_l2_i3_up, residual 

regress evpro_l3_i3_up  `instruments' 
predict pred_evpro_l3_i3_up, xb 
predict res_evpro_l3_i3_up, residual 


regress txipp2_f1_i3_up  `instruments'   
predict pred_txipp2_f1_i3_up, xb 
predict res_txipp2_f1_i3_up, residual 

regress txipp2_i3_up  `instruments'   
predict pred_txipp2_i3_up, xb 
predict res_txipp2_i3_up, residual 

regress txipp2_l1_i3_up   `instruments'  
predict pred_txipp2_l1_i3_up, xb 
predict res_txipp2_l1_i3_up, residual 

regress txipp2_l2_i3_up   `instruments'  
predict pred_txipp2_l2_i3_up, xb 
predict res_txipp2_l2_i3_up, residual 

regress txipp2_l3_i3_up   `instruments'  
predict pred_txipp2_l3_i3_up, xb 
predict res_txipp2_l3_i3_up, residual 


regress evprmp_p3_up  `instruments'   
predict pred_evprmp_p3_up, xb 
predict res_evprmp_p3_up, residual 

regress evprmp_l1_p3_up `instruments' 
predict pred_evprmp_l1_p3_up, xb 
predict res_evprmp_l1_p3_up, residual 

regress evprmp_l2_p3_up `instruments' 
predict pred_evprmp_l2_p3_up, xb 
predict res_evprmp_l2_p3_up, residual 

regress evprmp_l3_p3_up  `instruments'
predict pred_evprmp_l3_p3_up, xb 
predict res_evprmp_l3_p3_up, residual 


regress prevpro_p3_up   `instruments'   
predict pred_prevpro_p3_up, xb 
predict res_prevpro_p3_up, residual 

regress evpro_p3_up   `instruments'   
predict pred_evpro_p3_up, xb 
predict res_evpro_p3_up, residual 

regress evpro_l1_p3_up  `instruments' 
predict pred_evpro_l1_p3_up, xb 
predict res_evpro_l1_p3_up, residual 

regress evpro_l2_p3_up  `instruments' 
predict pred_evpro_l2_p3_up, xb 
predict res_evpro_l2_p3_up, residual 

regress evpro_l3_p3_up  `instruments' 
predict pred_evpro_l3_p3_up, xb 
predict res_evpro_l3_p3_up, residual 



regress txipp2_f1_p3_up  `instruments'   
predict pred_txipp2_f1_p3_up, xb 
predict res_txipp2_f1_p3_up, residual 

regress txipp2_l1_p3_up   `instruments'  
predict pred_txipp2_l1_p3_up, xb 
predict res_txipp2_l1_p3_up, residual 

regress txipp2_l2_p3_up   `instruments'  
predict pred_txipp2_l2_p3_up, xb 
predict res_txipp2_l2_p3_up, residual 

regress txipp2_l3_p3_up   `instruments'  
predict pred_txipp2_l3_p3_up, xb 
predict res_txipp2_l3_p3_up, residual 


regress evprmp_i3_down  `instruments'   
predict pred_evprmp_i3_down, xb 
predict res_evprmp_i3_down, residual 

regress evprmp_l1_i3_down `instruments' 
predict pred_evprmp_l1_i3_down, xb 
predict res_evprmp_l1_i3_down, residual 

regress evprmp_l2_i3_down `instruments' 
predict pred_evprmp_l2_i3_down, xb 
predict res_evprmp_l2_i3_down, residual 

regress evprmp_l3_i3_down  `instruments'
predict pred_evprmp_l3_i3_down, xb 
predict res_evprmp_l3_i3_down, residual 


regress prevpro_i3_down   `instruments'   
predict pred_prevpro_i3_down, xb 
predict res_prevpro_i3_down, residual 

regress evpro_i3_down   `instruments'   
predict pred_evpro_i3_down, xb 
predict res_evpro_i3_down, residual 

regress evpro_l1_i3_down  `instruments' 
predict pred_evpro_l1_i3_down, xb 
predict res_evpro_l1_i3_down, residual 

regress evpro_l2_i3_down  `instruments' 
predict pred_evpro_l2_i3_down, xb 
predict res_evpro_l2_i3_down, residual 

regress evpro_l3_i3_down  `instruments' 
predict pred_evpro_l3_i3_down, xb 
predict res_evpro_l3_i3_down, residual 


regress txipp2_f1_i3_down  `instruments'   
predict pred_txipp2_f1_i3_down, xb 
predict res_txipp2_f1_i3_down, residual 

regress txipp2_i3_down  `instruments'   
predict pred_txipp2_i3_down, xb 
predict res_txipp2_i3_down, residual 

regress txipp2_l1_i3_down   `instruments'  
predict pred_txipp2_l1_i3_down, xb 
predict res_txipp2_l1_i3_down, residual 

regress txipp2_l2_i3_down   `instruments'  
predict pred_txipp2_l2_i3_down, xb 
predict res_txipp2_l2_i3_down, residual 

regress txipp2_l3_i3_down   `instruments'  
predict pred_txipp2_l3_i3_down, xb 
predict res_txipp2_l3_i3_down, residual 


regress evprmp_p3_down  `instruments'   
predict pred_evprmp_p3_down, xb 
predict res_evprmp_p3_down, residual 

regress evprmp_l1_p3_down `instruments' 
predict pred_evprmp_l1_p3_down, xb 
predict res_evprmp_l1_p3_down, residual 

regress evprmp_l2_p3_down `instruments' 
predict pred_evprmp_l2_p3_down, xb 
predict res_evprmp_l2_p3_down, residual 

regress evprmp_l3_p3_down  `instruments'
predict pred_evprmp_l3_p3_down, xb 
predict res_evprmp_l3_p3_down, residual 


regress prevpro_p3_down   `instruments'   
predict pred_prevpro_p3_down, xb 
predict res_prevpro_p3_down, residual 

regress evpro_p3_down   `instruments'   
predict pred_evpro_p3_down, xb 
predict res_evpro_p3_down, residual 

regress evpro_l1_p3_down  `instruments' 
predict pred_evpro_l1_p3_down, xb 
predict res_evpro_l1_p3_down, residual 

regress evpro_l2_p3_down  `instruments' 
predict pred_evpro_l2_p3_down, xb 
predict res_evpro_l2_p3_down, residual 

regress evpro_l3_p3_down  `instruments' 
predict pred_evpro_l3_p3_down, xb 
predict res_evpro_l3_p3_down, residual 


regress txipp2_f1_p3_down  `instruments'   
predict pred_txipp2_f1_p3_down, xb 
predict res_txipp2_f1_p3_down, residual 

regress txipp2_l1_p3_down   `instruments'  
predict pred_txipp2_l1_p3_down, xb 
predict res_txipp2_l1_p3_down, residual 

regress txipp2_l2_p3_down   `instruments'  
predict pred_txipp2_l2_p3_down, xb 
predict res_txipp2_l2_p3_down, residual 

regress txipp2_l3_p3_down   `instruments'  
predict pred_txipp2_l3_p3_down, xb 
predict res_txipp2_l3_p3_down, residual 


regress cum_evprmp_l123_up  `instruments' 
predict pred_cum_evprmp_l123_up, xb 
predict res_cum_evprmp_l123_up, residual 

regress cum_evpro_l123_up  `instruments'   
predict pred_cum_evpro_l123_up, xb 
predict res_cum_evpro_l123_up, residual 

regress cum_isalmtot_l123_up  `instruments'
predict pred_cum_isalmtot_l123_up, xb 
predict res_cum_isalmtot_l123_up, residual 

regress cum_ipp2_l123_up  `instruments' 
predict pred_cum_ipp2_l123_up, xb 
predict res_cum_ipp2_l123_up, residual 

        
regress isalmtot2_up   `instruments'   
predict pred_isalmtot_up, xb 
predict res_isalmtot_up, residual 

regress isalmtot2_l1_up  `instruments' 
predict pred_isalmtot_l1_up, xb 
predict res_isalmtot_l1_up, residual 

regress isalmtot2_l2_up  `instruments' 
predict pred_isalmtot_l2_up, xb 
predict res_isalmtot_l2_up, residual 

regress isalmtot2_l3_up  `instruments' 
predict pred_isalmtot_l3_up, xb 
predict res_isalmtot_l3_up, residual 


regress isalmtot2_down   `instruments'   
predict pred_isalmtot_down, xb 
predict res_isalmtot_down, residual 

regress isalmtot2_l1_down  `instruments' 
predict pred_isalmtot_l1_down, xb 
predict res_isalmtot_l1_down, residual 

regress isalmtot2_l2_down  `instruments' 
predict pred_isalmtot_l2_down, xb 
predict res_isalmtot_l2_down, residual 

regress isalmtot2_l3_down  `instruments' 
predict pred_isalmtot_l3_down, xb 
predict res_isalmtot_l3_down, residual 


regress cum_evprmp_l123_down  `instruments' 
predict pred_cum_evprmp_l123_down, xb 
predict res_cum_evprmp_l123_down, residual 

regress cum_evpro_l123_down  `instruments'   
predict pred_cum_evpro_l123_down, xb 
predict res_cum_evpro_l123_down, residual 

regress cum_isalmtot_l123_down  `instruments'
predict pred_cum_isalmtot_l123_down, xb 
predict res_cum_isalmtot_l123_down, residual 

regress cum_ipp2_l123_down  `instruments' 
predict pred_cum_ipp2_l123_down, xb 
predict res_cum_ipp2_l123_down, residual 


            
/*** UNCONSTRAINED DYNAMIC MODELS WITH LAGGED REGRESSORS  **/
/* Ordered probit model "à la Rivers-Vuong/Wooldridge" with random effects**/

reoprob  evprpf evprmp_i3_up evprmp_l1_i3_up evprmp_l2_i3_up evprmp_l3_i3_up  cum_evprmp_l123_up ///
                isalmtot2_up isalmtot2_l1_up isalmtot2_l2_up isalmtot2_l3_up cum_isalmtot_l123_up  ///
                evpro_i3_up evpro_l1_i3_up evpro_l2_i3_up evpro_l3_i3_up cum_evpro_l123_up  ///
                txipp2_i3_up txipp2_l1_i3_up txipp2_l2_i3_up txipp2_l3_i3_up cum_ipp2_l123_up  ///
                evprmp_p3_up evprmp_l1_p3_up evprmp_l2_p3_up evprmp_l3_p3_up  ///
                evpro_p3_up evpro_l1_p3_up evpro_l2_p3_up evpro_l3_p3_up   ///
                txipp2_p3_up txipp2_l1_p3_up txipp2_l2_p3_up txipp2_l3_p3_up   ///
                evprmp_i3_down evprmp_l1_i3_down evprmp_l2_i3_down evprmp_l3_i3_down  cum_evprmp_l123_down  ///
                isalmtot2_down isalmtot2_l1_down isalmtot2_l2_down isalmtot2_l3_down cum_isalmtot_l123_down  ///
                evpro_i3_down evpro_l1_i3_down evpro_l2_i3_down evpro_l3_i3_down  cum_evpro_l123_down   ///
                txipp2_i3_down txipp2_l1_i3_down txipp2_l2_i3_down txipp2_l3_i3_down cum_ipp2_l123_down  ///
                evprmp_p3_down evprmp_l1_p3_down evprmp_l2_p3_down evprmp_l3_p3_down  ///
                evpro_p3_down evpro_l1_p3_down evpro_l2_p3_down evpro_l3_p3_down  ///
                txipp2_p3_down txipp2_l1_p3_down txipp2_l2_p3_down txipp2_l3_p3_down   ///
                tva_2000 tva_2000_2 euro_2002 euro_2002_2 ///
                y_null res_evprmp_i3_up  res_evprmp_l1_i3_up res_evprmp_l2_i3_up res_evprmp_l3_i3_up  res_cum_evprmp_l123_up ///
                res_isalmtot_up res_isalmtot_l1_up res_isalmtot_l2_up res_isalmtot_l3_up res_cum_isalmtot_l123_up  ///
                res_evpro_i3_up res_evpro_l1_i3_up res_evpro_l2_i3_up res_evpro_l3_i3_up  res_cum_evpro_l123_up ///
	          res_txipp2_l1_i3_up res_txipp2_l2_i3_up res_txipp2_l3_i3_up res_cum_ipp2_l123_up  ///
                res_evprmp_p3_up  res_evprmp_l1_p3_up res_evprmp_l2_p3_up res_evprmp_l3_p3_up  ///
                res_evpro_p3_up res_evpro_l1_p3_up res_evpro_l2_p3_up res_evpro_l3_p3_up  ///
                res_txipp2_l1_p3_up res_txipp2_l2_p3_up res_txipp2_l3_p3_up    ///
                res_evprmp_i3_down  res_evprmp_l1_i3_down res_evprmp_l2_i3_down res_evprmp_l3_i3_down res_cum_evprmp_l123_down  ///
                res_isalmtot_down res_isalmtot_l1_down res_isalmtot_l2_down res_isalmtot_l3_down res_cum_isalmtot_l123_down  ///
                res_evpro_i3_down res_evpro_l1_i3_down res_evpro_l2_i3_down res_evpro_l3_i3_down  res_cum_evpro_l123_down ///
	          res_txipp2_l1_i3_down res_txipp2_l2_i3_down res_txipp2_l3_i3_down res_cum_ipp2_l123_down ///
                res_evprmp_p3_down  res_evprmp_l1_p3_down res_evprmp_l2_p3_down res_evprmp_l3_p3_down  ///
                res_evpro_p3_down res_evpro_l1_p3_down res_evpro_l2_p3_down res_evpro_l3_p3_down  ///
                res_txipp2_l1_p3_down res_txipp2_l2_p3_down res_txipp2_l3_p3_down    ///
                    /*ind_DA*/ ind_db ind_dc ind_dd ind_de ind_dg ind_dh ind_di ///
                   ind_dj ind_dk ind_dl ind_dm ind_dn ///
                annee_1999 annee_2000 annee_2001 annee_2002 annee_2003 annee_2004 /*annee_2005*/ ///
                ,  i(ident_stata)


