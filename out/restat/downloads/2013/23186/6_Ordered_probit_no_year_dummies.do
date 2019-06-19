**** ROBUSTNESS CHECK: THIS PROGRAM ESTIMATES 
**** AN UNCONSTRAINED DYNAMIC STATE-DEPENDENT MODEL 
**** WITHOUT YEAR DUMMIES  ****

capture clear
capture log close

adopath + C:\ado_stata

log using "C:\6_Ordered_probit_no_year_dummies.log", replace

clear

set memory 800m
set more off

use "C:\stata_base_q3_asym_chocs"

preserve

tsset ident_stata numenq


/** FIRST STEP INSTRUMENTAL REGRESSIONS **/
local instruments  l1_evprmp l2_evprmp l3_evprmp l4_evprmp l5_evprmp   l6_evprmp ///  
                   l1_evpro   l2_evpro l3_evpro l4_evpro l5_evpro   l6_evpro    ///
                   l1_txipp2   l2_txipp2 l3_txipp2 l4_txipp2 l5_txipp2   l6_txipp2   ///
                   l1_isalmtot2   l2_isalmtot2 l3_isalmtot2 l4_isalmtot2 l5_isalmtot2 l6_isalmtot2  ///
                    /*ind_DA*/ ind_db ind_dc ind_dd ind_de ind_dg ind_dh ind_di ///
                   ind_dj ind_dk ind_dl ind_dm ind_dn ///
                tva_2000 tva_2000_2 euro_2002 euro_2002_2 ///
      mois_1 mois_7   trim1 trim2 trim3 

regress cum_evprmp  `instruments'  
predict pred_cum_evprmp, xb 
predict res_cum_evprmp, residual 

regress cum_evpro `instruments'   
predict pred_cum_evpro, xb 
predict res_cum_evpro, residual 

regress cum_evcom `instruments'   
predict pred_cum_evcom, xb 
predict res_cum_evcom, residual 

regress cum_evstpf `instruments'   
predict pred_cum_evstpf, xb 
predict res_cum_evstpf, residual 

regress cum_isalmtot `instruments'
predict pred_cum_isalmtot, xb 
predict res_cum_isalmtot, residual 


regress cum_ipp2  `instruments'   
predict pred_cum_ipp2, xb 
predict res_cum_ipp2, residual 

regress evprmp_f1 `instruments'   
predict pred_evprmp_f1, xb 
predict res_evprmp_f1, residual 

regress evprmp  `instruments'   
predict pred_evprmp, xb 
predict res_evprmp, residual 

regress evprmp_l1 `instruments' 
predict pred_evprmp_l1, xb 
predict res_evprmp_l1, residual 

regress evprmp_l2 `instruments' 
predict pred_evprmp_l2, xb 
predict res_evprmp_l2, residual 

regress evprmp_l3  `instruments'
predict pred_evprmp_l3, xb 
predict res_evprmp_l3, residual 

regress prevpro   `instruments' 
predict pred_prevpro, xb 
predict res_prevpro, residual 


regress evpro   `instruments'   
predict pred_evpro, xb 
predict res_evpro, residual 

regress evpro_l1  `instruments' 
predict pred_evpro_l1, xb 
predict res_evpro_l1, residual 

regress evpro_l2  `instruments' 
predict pred_evpro_l2, xb 
predict res_evpro_l2, residual 

regress evpro_l3  `instruments' 
predict pred_evpro_l3, xb 
predict res_evpro_l3, residual 

regress evcom   `instruments'   
predict pred_evcom, xb 
predict res_evcom, residual 

regress evcom_l1  `instruments' 
predict pred_evcom_l1, xb 
predict res_evcom_l1, residual 

regress evcom_l2  `instruments' 
predict pred_evcom_l2, xb 
predict res_evcom_l2, residual 

regress evcom_l3  `instruments' 
predict pred_evcom_l3, xb 
predict res_evcom_l3, residual 


regress evstpf   `instruments'   
predict pred_evstpf, xb 
predict res_evstpf, residual 

regress evstpf_l1  `instruments' 
predict pred_evstpf_l1, xb 
predict res_evstpf_l1, residual 

regress evstpf_l2  `instruments' 
predict pred_evstpf_l2, xb 
predict res_evstpf_l2, residual 

regress evstpf_l3  `instruments' 
predict pred_evstpf_l3, xb 
predict res_evstpf_l3, residual 

regress isalmtot2_f1   `instruments'   
predict pred_isalmtot_f1, xb 
predict res_isalmtot_f1, residual 



regress isalmtot2   `instruments'   
predict pred_isalmtot, xb 
predict res_isalmtot, residual 

regress isalmtot2_l1  `instruments' 
predict pred_isalmtot_l1, xb 
predict res_isalmtot_l1, residual 

regress isalmtot2_l2  `instruments' 
predict pred_isalmtot_l2, xb 
predict res_isalmtot_l2, residual 

regress isalmtot2_l3  `instruments' 
predict pred_isalmtot_l3, xb 
predict res_isalmtot_l3, residual 

regress txipp2_f1  `instruments' 
predict pred_txipp2_f1, xb 
predict res_txipp2_f1, residual 


regress txipp2  `instruments'   
predict pred_txipp2, xb 
predict res_txipp2, residual 

regress txipp2_l1   `instruments'  
predict pred_txipp2_l1, xb 
predict res_txipp2_l1, residual 

regress txipp2_l2   `instruments'  
predict pred_txipp2_l2, xb 
predict res_txipp2_l2, residual 

regress txipp2_l3   `instruments'  
predict pred_txipp2_l3, xb 
predict res_txipp2_l3, residual 


regress cum_evprmp_l123  `instruments' 
predict pred_cum_evprmp_l123, xb 
predict res_cum_evprmp_l123, residual 

regress cum_evpro_l123  `instruments'   
predict pred_cum_evpro_l123, xb 
predict res_cum_evpro_l123, residual 

regress cum_evcom_l123  `instruments'   
predict pred_cum_evcom_l123, xb 
predict res_cum_evcom_l123, residual 

regress cum_evstpf_l123  `instruments'   
predict pred_cum_evstpf_l123, xb 
predict res_cum_evstpf_l123, residual 

regress cum_isalmtot_l123  `instruments'
predict pred_cum_isalmtot_l123, xb 
predict res_cum_isalmtot_l123, residual 

regress cum_ipp2_l123  `instruments' 
predict pred_cum_ipp2_l123, xb 
predict res_cum_ipp2_l123, residual 


/*** UNCONSTRAINED DYNAMIC MODELS WITH LAGGED REGRESSORS  **/
/** Ordered Probit "à la Rivers-Vuong/Wooldridge" with random effects **/

reoprob  evprpf evprmp evprmp_l1 evprmp_l2 evprmp_l3 cum_evprmp_l123 ///
                isalmtot2 isalmtot2_l1 isalmtot2_l2 isalmtot2_l3 cum_isalmtot_l123  ///
                evpro evpro_l1  evpro_l2  evpro_l3  cum_evpro_l123   ///
                txipp2 txipp2_l1 txipp2_l2 txipp2_l3 cum_ipp2_l123  ///
                tva_2000 tva_2000_2 euro_2002 euro_2002_2 ///
                y_null res_evprmp  res_evprmp_l1 res_evprmp_l2 res_evprmp_l3 res_cum_evprmp_l123 ///
                res_isalmtot res_isalmtot_l1 res_isalmtot_l2 res_isalmtot_l3 res_cum_isalmtot_l123  ///
                res_evpro res_evpro_l1  res_evpro_l2  res_evpro_l3  res_cum_evpro_l123   ///
                res_txipp2_l1 res_txipp2_l2 res_txipp2_l3 res_cum_ipp2_l123  ///
                    /*ind_DA*/ ind_db ind_dc ind_dd ind_de ind_dg ind_dh ind_di ///
                   ind_dj ind_dk ind_dl ind_dm ind_dn ///
                ,  i(ident_stata)






