**** THIS PROGRAM ESTIMATES A STANDARD STATE-DEPENDENT MODEL 
**** AND AN UNCONSTRAINED DYNAMIC STATE-DEPENDENT MODEL ****

capture clear
capture log close

adopath + C:\ado_stata

log using "C:\4_ordered_probit_qualit3_prod.log", replace

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
                   /*ind_da*/ ind_db ind_dc ind_dd ind_de ind_dg ind_dh ind_di ///
                   ind_dj ind_dk ind_dl ind_dm ind_dn ///
                tva_2000 tva_2000_2 euro_2002 euro_2002_2 ///
      mois_1 mois_7   trim1 trim2 trim3 ///
      annee_1999 annee_2000 annee_2001 annee_2002 annee_2003 annee_2004


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


/***** STATE-DEPENDENT MODEL ***********/ 
/* "Ordinary" ordered probit model **/

oprobit  evprpf cum_evprmp cum_isalmtot  cum_evpro cum_ipp2   ///
                 tva_2000 tva_2000_2 euro_2002 euro_2002_2 ///
                   /*ind_da*/ ind_db ind_dc ind_dd ind_de ind_dg ind_dh ind_di ///
                   ind_dj ind_dk ind_dl ind_dm ind_dn ///
      annee_1999 annee_2000 annee_2001 annee_2002 annee_2003 annee_2004 /*annee_2005*/


predict py, xb
sum py 
scalar mxb =r(mean) 

sum cum_evprmp 
scalar mcum_evprmp =r(mean) 
sum cum_evpro 
scalar mcum_evpro =r(mean) 
sum cum_isalmtot 
scalar mcum_isalmtot =r(mean) 
sum cum_ipp2 
scalar mcum_ipp2 =r(mean) 
sum tva_2000 
scalar mtva_2000 =r(mean) 
sum tva_2000_2 
scalar mtva_2000_2 =r(mean) 
sum euro_2002 
scalar meuro_2002 =r(mean) 
sum euro_2002_2 
scalar meuro_2002_2 =r(mean) 

/** Computation of marginal effects **/
/** 0 -> 1  : Ref. = 0 **/
scalar me_evprmp_decrease= normal(_b[cut1:_cons]-mxb+_b[evprpf:cum_evprmp]*mcum_evprmp-_b[evprpf:cum_evprmp])- normal(_b[cut1:_cons]-mxb +_b[evprpf:cum_evprmp]*mcum_evprmp) 
scalar me_evprmp_nochange= normal(_b[cut2:_cons]-mxb+_b[evprpf:cum_evprmp]*mcum_evprmp-_b[evprpf:cum_evprmp])- normal(_b[cut2:_cons]-mxb +_b[evprpf:cum_evprmp]*mcum_evprmp) /// 
          -(normal(_b[cut1:_cons]-mxb+_b[evprpf:cum_evprmp]*mcum_evprmp-_b[evprpf:cum_evprmp])-normal(_b[cut1:_cons]-mxb +_b[evprpf:cum_evprmp]*mcum_evprmp)) 
scalar me_evprmp_increase=-(normal(_b[cut2:_cons]-mxb+_b[evprpf:cum_evprmp]*mcum_evprmp-_b[evprpf:cum_evprmp])-normal(_b[cut2:_cons]-mxb +_b[evprpf:cum_evprmp]*mcum_evprmp)) 

scalar me_evpro_decrease= normal(_b[cut1:_cons]-mxb+_b[evprpf:cum_evpro]*mcum_evpro-_b[evprpf:cum_evpro])- normal(_b[cut1:_cons]-mxb +_b[evprpf:cum_evpro]*mcum_evpro) 
scalar me_evpro_nochange= normal(_b[cut2:_cons]-mxb+_b[evprpf:cum_evpro]*mcum_evpro-_b[evprpf:cum_evpro])- normal(_b[cut2:_cons]-mxb +_b[evprpf:cum_evpro]*mcum_evpro) /// 
          -(normal(_b[cut1:_cons]-mxb+_b[evprpf:cum_evpro]*mcum_evpro-_b[evprpf:cum_evpro])-normal(_b[cut1:_cons]-mxb +_b[evprpf:cum_evpro]*mcum_evpro)) 
scalar me_evpro_increase=-(normal(_b[cut2:_cons]-mxb+_b[evprpf:cum_evpro]*mcum_evpro-_b[evprpf:cum_evpro])-normal(_b[cut2:_cons]-mxb +_b[evprpf:cum_evpro]*mcum_evpro)) 

scalar me_isalmtot_decrease= normal(_b[cut1:_cons]-mxb+_b[evprpf:cum_isalmtot]*mcum_isalmtot-_b[evprpf:cum_isalmtot])- normal(_b[cut1:_cons]-mxb +_b[evprpf:cum_isalmtot]*mcum_isalmtot) 
scalar me_isalmtot_nochange= normal(_b[cut2:_cons]-mxb+_b[evprpf:cum_isalmtot]*mcum_isalmtot-_b[evprpf:cum_isalmtot])- normal(_b[cut2:_cons]-mxb +_b[evprpf:cum_isalmtot]*mcum_isalmtot) /// 
          -(normal(_b[cut1:_cons]-mxb+_b[evprpf:cum_isalmtot]*mcum_isalmtot-_b[evprpf:cum_isalmtot])-normal(_b[cut1:_cons]-mxb +_b[evprpf:cum_isalmtot]*mcum_isalmtot)) 
scalar me_isalmtot_increase=-(normal(_b[cut2:_cons]-mxb+_b[evprpf:cum_isalmtot]*mcum_isalmtot-_b[evprpf:cum_isalmtot])-normal(_b[cut2:_cons]-mxb +_b[evprpf:cum_isalmtot]*mcum_isalmtot)) 

scalar me_ipp2_decrease= _b[evprpf:cum_ipp2]*(-normalden(_b[cut1:_cons]-mxb)) 
scalar me_ipp2_nochange= _b[evprpf:cum_ipp2]*(-normalden(_b[cut2:_cons]-mxb) + normalden(_b[cut1:_cons]-mxb)) 
scalar me_ipp2_increase= _b[evprpf:cum_ipp2]*(normalden(_b[cut2:_cons]-mxb)) 


/** impact of VAT changes and Euro cash changeover (Ref. = 0) **/
scalar me_tva_2000_decrease= normal(_b[cut1:_cons]-mxb+_b[evprpf:tva_2000]*mtva_2000-_b[evprpf:tva_2000])- normal(_b[cut1:_cons]-mxb +_b[evprpf:tva_2000]*mtva_2000) 
scalar me_tva_2000_nochange= normal(_b[cut2:_cons]-mxb+_b[evprpf:tva_2000]*mtva_2000-_b[evprpf:tva_2000])- normal(_b[cut2:_cons]-mxb +_b[evprpf:tva_2000]*mtva_2000) /// 
          -(normal(_b[cut1:_cons]-mxb+_b[evprpf:tva_2000]*mtva_2000-_b[evprpf:tva_2000])-normal(_b[cut1:_cons]-mxb +_b[evprpf:tva_2000]*mtva_2000)) 
scalar me_tva_2000_increase=-(normal(_b[cut2:_cons]-mxb+_b[evprpf:tva_2000]*mtva_2000-_b[evprpf:tva_2000])-normal(_b[cut2:_cons]-mxb +_b[evprpf:tva_2000]*mtva_2000)) 

scalar me_tva_2000_2_decrease= normal(_b[cut1:_cons]-mxb+_b[evprpf:tva_2000_2]*mtva_2000_2-_b[evprpf:tva_2000_2])- normal(_b[cut1:_cons]-mxb +_b[evprpf:tva_2000_2]*mtva_2000_2) 
scalar me_tva_2000_2_nochange= normal(_b[cut2:_cons]-mxb+_b[evprpf:tva_2000_2]*mtva_2000_2-_b[evprpf:tva_2000_2])- normal(_b[cut2:_cons]-mxb +_b[evprpf:tva_2000_2]*mtva_2000_2) /// 
          -(normal(_b[cut1:_cons]-mxb+_b[evprpf:tva_2000_2]*mtva_2000_2-_b[evprpf:tva_2000_2])-normal(_b[cut1:_cons]-mxb +_b[evprpf:tva_2000_2]*mtva_2000_2)) 
scalar me_tva_2000_2_increase=-(normal(_b[cut2:_cons]-mxb+_b[evprpf:tva_2000_2]*mtva_2000_2-_b[evprpf:tva_2000_2])-normal(_b[cut2:_cons]-mxb +_b[evprpf:tva_2000_2]*mtva_2000_2)) 

scalar me_euro_2002_decrease= normal(_b[cut1:_cons]-mxb+_b[evprpf:euro_2002]*meuro_2002-_b[evprpf:euro_2002])- normal(_b[cut1:_cons]-mxb +_b[evprpf:euro_2002]*meuro_2002) 
scalar me_euro_2002_nochange= normal(_b[cut2:_cons]-mxb+_b[evprpf:euro_2002]*meuro_2002-_b[evprpf:euro_2002])- normal(_b[cut2:_cons]-mxb +_b[evprpf:euro_2002]*meuro_2002) /// 
          -(normal(_b[cut1:_cons]-mxb+_b[evprpf:euro_2002]*meuro_2002-_b[evprpf:euro_2002])-normal(_b[cut1:_cons]-mxb +_b[evprpf:euro_2002]*meuro_2002)) 
scalar me_euro_2002_increase=-(normal(_b[cut2:_cons]-mxb+_b[evprpf:euro_2002]*meuro_2002-_b[evprpf:euro_2002])-normal(_b[cut2:_cons]-mxb +_b[evprpf:euro_2002]*meuro_2002)) 

scalar me_euro_2002_2_decrease= normal(_b[cut1:_cons]-mxb+_b[evprpf:euro_2002_2]*meuro_2002_2-_b[evprpf:euro_2002_2])- normal(_b[cut1:_cons]-mxb +_b[evprpf:euro_2002_2]*meuro_2002_2) 
scalar me_euro_2002_2_nochange= normal(_b[cut2:_cons]-mxb+_b[evprpf:euro_2002_2]*meuro_2002_2-_b[evprpf:euro_2002_2])- normal(_b[cut2:_cons]-mxb +_b[evprpf:euro_2002_2]*meuro_2002_2) /// 
          -(normal(_b[cut1:_cons]-mxb+_b[evprpf:euro_2002_2]*meuro_2002_2-_b[evprpf:euro_2002_2])-normal(_b[cut1:_cons]-mxb +_b[evprpf:euro_2002_2]*meuro_2002_2)) 
scalar me_euro_2002_2_increase=-(normal(_b[cut2:_cons]-mxb+_b[evprpf:euro_2002_2]*meuro_2002_2-_b[evprpf:euro_2002_2])-normal(_b[cut2:_cons]-mxb +_b[evprpf:euro_2002_2]*meuro_2002_2)) 

scalar list me_evprmp_decrease   me_isalmtot_decrease   me_evpro_decrease  me_ipp2_decrease  ///
            me_tva_2000_decrease  me_tva_2000_2_decrease   me_euro_2002_decrease  me_euro_2002_2_decrease  

scalar list  me_evprmp_increase  me_isalmtot_increase  me_evpro_increase   me_ipp2_increase    ///
             me_tva_2000_increase  me_tva_2000_2_increase  me_euro_2002_increase  me_euro_2002_2_increase 

scalar drop _all


/***** STATE-DEPENDENT MODEL ***********/ 
/* "Augmented" Ordered probit model "à la" Rivers-Vuong **/

oprobit  evprpf cum_evprmp cum_isalmtot  cum_evpro cum_ipp2   ///
                 tva_2000 tva_2000_2 euro_2002 euro_2002_2 ///
                res_cum_evprmp res_cum_isalmtot res_cum_evpro  res_cum_ipp2 ///
                   /*ind_da*/ ind_db ind_dc ind_dd ind_de ind_dg ind_dh ind_di ///
                   ind_dj ind_dk ind_dl ind_dm ind_dn ///
      annee_1999 annee_2000 annee_2001 annee_2002 annee_2003 annee_2004 /*annee_2005*/


sum py 
scalar mxb =r(mean) 

sum cum_evprmp 
scalar mcum_evprmp =r(mean) 
sum cum_evpro 
scalar mcum_evpro =r(mean) 
sum cum_isalmtot 
scalar mcum_isalmtot =r(mean) 
sum cum_ipp2 
scalar mcum_ipp2 =r(mean) 
sum tva_2000 
scalar mtva_2000 =r(mean) 
sum tva_2000_2 
scalar mtva_2000_2 =r(mean) 
sum euro_2002 
scalar meuro_2002 =r(mean) 
sum euro_2002_2 
scalar meuro_2002_2 =r(mean) 


/** Computation of marginal effects **/
/** 0 -> 1  : Ref. = 0 **/

scalar me_evprmp_decrease= normal(_b[cut1:_cons]-mxb+_b[evprpf:cum_evprmp]*mcum_evprmp-_b[evprpf:cum_evprmp])- normal(_b[cut1:_cons]-mxb +_b[evprpf:cum_evprmp]*mcum_evprmp) 
scalar me_evprmp_nochange= normal(_b[cut2:_cons]-mxb+_b[evprpf:cum_evprmp]*mcum_evprmp-_b[evprpf:cum_evprmp])- normal(_b[cut2:_cons]-mxb +_b[evprpf:cum_evprmp]*mcum_evprmp) /// 
          -(normal(_b[cut1:_cons]-mxb+_b[evprpf:cum_evprmp]*mcum_evprmp-_b[evprpf:cum_evprmp])-normal(_b[cut1:_cons]-mxb +_b[evprpf:cum_evprmp]*mcum_evprmp)) 
scalar me_evprmp_increase=-(normal(_b[cut2:_cons]-mxb+_b[evprpf:cum_evprmp]*mcum_evprmp-_b[evprpf:cum_evprmp])-normal(_b[cut2:_cons]-mxb +_b[evprpf:cum_evprmp]*mcum_evprmp)) 

scalar me_evpro_decrease= normal(_b[cut1:_cons]-mxb+_b[evprpf:cum_evpro]*mcum_evpro-_b[evprpf:cum_evpro])- normal(_b[cut1:_cons]-mxb +_b[evprpf:cum_evpro]*mcum_evpro) 
scalar me_evpro_nochange= normal(_b[cut2:_cons]-mxb+_b[evprpf:cum_evpro]*mcum_evpro-_b[evprpf:cum_evpro])- normal(_b[cut2:_cons]-mxb +_b[evprpf:cum_evpro]*mcum_evpro) /// 
          -(normal(_b[cut1:_cons]-mxb+_b[evprpf:cum_evpro]*mcum_evpro-_b[evprpf:cum_evpro])-normal(_b[cut1:_cons]-mxb +_b[evprpf:cum_evpro]*mcum_evpro)) 
scalar me_evpro_increase=-(normal(_b[cut2:_cons]-mxb+_b[evprpf:cum_evpro]*mcum_evpro-_b[evprpf:cum_evpro])-normal(_b[cut2:_cons]-mxb +_b[evprpf:cum_evpro]*mcum_evpro)) 

scalar me_isalmtot_decrease= normal(_b[cut1:_cons]-mxb+_b[evprpf:cum_isalmtot]*mcum_isalmtot-_b[evprpf:cum_isalmtot])- normal(_b[cut1:_cons]-mxb +_b[evprpf:cum_isalmtot]*mcum_isalmtot) 
scalar me_isalmtot_nochange= normal(_b[cut2:_cons]-mxb+_b[evprpf:cum_isalmtot]*mcum_isalmtot-_b[evprpf:cum_isalmtot])- normal(_b[cut2:_cons]-mxb +_b[evprpf:cum_isalmtot]*mcum_isalmtot) /// 
          -(normal(_b[cut1:_cons]-mxb+_b[evprpf:cum_isalmtot]*mcum_isalmtot-_b[evprpf:cum_isalmtot])-normal(_b[cut1:_cons]-mxb +_b[evprpf:cum_isalmtot]*mcum_isalmtot)) 
scalar me_isalmtot_increase=-(normal(_b[cut2:_cons]-mxb+_b[evprpf:cum_isalmtot]*mcum_isalmtot-_b[evprpf:cum_isalmtot])-normal(_b[cut2:_cons]-mxb +_b[evprpf:cum_isalmtot]*mcum_isalmtot)) 

scalar me_ipp2_decrease= _b[evprpf:cum_ipp2]*(-normalden(_b[cut1:_cons]-mxb)) 
scalar me_ipp2_nochange= _b[evprpf:cum_ipp2]*(-normalden(_b[cut2:_cons]-mxb) + normalden(_b[cut1:_cons]-mxb)) 
scalar me_ipp2_increase= _b[evprpf:cum_ipp2]*(normalden(_b[cut2:_cons]-mxb)) 


/** impact of VAT changes and Euro cash changeover (Ref. = 0) **/
scalar me_tva_2000_decrease= normal(_b[cut1:_cons]-mxb+_b[evprpf:tva_2000]*mtva_2000-_b[evprpf:tva_2000])- normal(_b[cut1:_cons]-mxb +_b[evprpf:tva_2000]*mtva_2000) 
scalar me_tva_2000_nochange= normal(_b[cut2:_cons]-mxb+_b[evprpf:tva_2000]*mtva_2000-_b[evprpf:tva_2000])- normal(_b[cut2:_cons]-mxb +_b[evprpf:tva_2000]*mtva_2000) /// 
          -(normal(_b[cut1:_cons]-mxb+_b[evprpf:tva_2000]*mtva_2000-_b[evprpf:tva_2000])-normal(_b[cut1:_cons]-mxb +_b[evprpf:tva_2000]*mtva_2000)) 
scalar me_tva_2000_increase=-(normal(_b[cut2:_cons]-mxb+_b[evprpf:tva_2000]*mtva_2000-_b[evprpf:tva_2000])-normal(_b[cut2:_cons]-mxb +_b[evprpf:tva_2000]*mtva_2000)) 

scalar me_tva_2000_2_decrease= normal(_b[cut1:_cons]-mxb+_b[evprpf:tva_2000_2]*mtva_2000_2-_b[evprpf:tva_2000_2])- normal(_b[cut1:_cons]-mxb +_b[evprpf:tva_2000_2]*mtva_2000_2) 
scalar me_tva_2000_2_nochange= normal(_b[cut2:_cons]-mxb+_b[evprpf:tva_2000_2]*mtva_2000_2-_b[evprpf:tva_2000_2])- normal(_b[cut2:_cons]-mxb +_b[evprpf:tva_2000_2]*mtva_2000_2) /// 
          -(normal(_b[cut1:_cons]-mxb+_b[evprpf:tva_2000_2]*mtva_2000_2-_b[evprpf:tva_2000_2])-normal(_b[cut1:_cons]-mxb +_b[evprpf:tva_2000_2]*mtva_2000_2)) 
scalar me_tva_2000_2_increase=-(normal(_b[cut2:_cons]-mxb+_b[evprpf:tva_2000_2]*mtva_2000_2-_b[evprpf:tva_2000_2])-normal(_b[cut2:_cons]-mxb +_b[evprpf:tva_2000_2]*mtva_2000_2)) 

scalar me_euro_2002_decrease= normal(_b[cut1:_cons]-mxb+_b[evprpf:euro_2002]*meuro_2002-_b[evprpf:euro_2002])- normal(_b[cut1:_cons]-mxb +_b[evprpf:euro_2002]*meuro_2002) 
scalar me_euro_2002_nochange= normal(_b[cut2:_cons]-mxb+_b[evprpf:euro_2002]*meuro_2002-_b[evprpf:euro_2002])- normal(_b[cut2:_cons]-mxb +_b[evprpf:euro_2002]*meuro_2002) /// 
          -(normal(_b[cut1:_cons]-mxb+_b[evprpf:euro_2002]*meuro_2002-_b[evprpf:euro_2002])-normal(_b[cut1:_cons]-mxb +_b[evprpf:euro_2002]*meuro_2002)) 
scalar me_euro_2002_increase=-(normal(_b[cut2:_cons]-mxb+_b[evprpf:euro_2002]*meuro_2002-_b[evprpf:euro_2002])-normal(_b[cut2:_cons]-mxb +_b[evprpf:euro_2002]*meuro_2002)) 

scalar me_euro_2002_2_decrease= normal(_b[cut1:_cons]-mxb+_b[evprpf:euro_2002_2]*meuro_2002_2-_b[evprpf:euro_2002_2])- normal(_b[cut1:_cons]-mxb +_b[evprpf:euro_2002_2]*meuro_2002_2) 
scalar me_euro_2002_2_nochange= normal(_b[cut2:_cons]-mxb+_b[evprpf:euro_2002_2]*meuro_2002_2-_b[evprpf:euro_2002_2])- normal(_b[cut2:_cons]-mxb +_b[evprpf:euro_2002_2]*meuro_2002_2) /// 
          -(normal(_b[cut1:_cons]-mxb+_b[evprpf:euro_2002_2]*meuro_2002_2-_b[evprpf:euro_2002_2])-normal(_b[cut1:_cons]-mxb +_b[evprpf:euro_2002_2]*meuro_2002_2)) 
scalar me_euro_2002_2_increase=-(normal(_b[cut2:_cons]-mxb+_b[evprpf:euro_2002_2]*meuro_2002_2-_b[evprpf:euro_2002_2])-normal(_b[cut2:_cons]-mxb +_b[evprpf:euro_2002_2]*meuro_2002_2)) 


scalar list me_evprmp_decrease   me_isalmtot_decrease   me_evpro_decrease  me_ipp2_decrease  ///
            me_tva_2000_decrease  me_tva_2000_2_decrease   me_euro_2002_decrease  me_euro_2002_2_decrease  

scalar list  me_evprmp_increase  me_isalmtot_increase  me_evpro_increase   me_ipp2_increase    ///
             me_tva_2000_increase  me_tva_2000_2_increase  me_euro_2002_increase  me_euro_2002_2_increase 

scalar drop _all

                
/***** STATE-DEPENDENT MODEL ***********/ 
/** Ordered Probit "à la Rivers-Vuong/Wooldridge" with random effects **/

reoprob  evprpf cum_evprmp cum_isalmtot cum_evpro cum_ipp2   ///
                 tva_2000 tva_2000_2 euro_2002 euro_2002_2 ///
                y_null res_cum_evprmp res_cum_isalmtot res_cum_evpro  res_cum_ipp2 ///
                   /*ind_da*/ ind_db ind_dc ind_dd ind_de ind_dg ind_dh ind_di ///
                   ind_dj ind_dk ind_dl ind_dm ind_dn ///
      annee_1999 annee_2000 annee_2001 annee_2002 annee_2003 annee_2004 /*annee_2005*/ ///
      , i(ident_stata) 


scalar cc = sqrt(1-_b[rho:_cons]) 
scalar list cc

predict pyr, xb
sum pyr 
scalar mxb =r(mean) 

sum cum_evprmp 
scalar mcum_evprmp =r(mean) 
sum cum_evpro 
scalar mcum_evpro =r(mean) 
sum cum_isalmtot 
scalar mcum_isalmtot =r(mean) 
sum cum_ipp2 
scalar mcum_ipp2 =r(mean) 
sum tva_2000 
scalar mtva_2000 =r(mean) 
sum tva_2000_2 
scalar mtva_2000_2 =r(mean) 
sum euro_2002 
scalar meuro_2002 =r(mean) 
sum euro_2002_2 
scalar meuro_2002_2 =r(mean) 


/** Computation of marginal effects **/
/** 0 -> 1  : Ref. = 0 **/

scalar me_evprmp_decrease= normal(cc * _b[_cut1:_cons]-cc * mxb+cc * _b[eq1:cum_evprmp]*mcum_evprmp-cc * _b[eq1:cum_evprmp])- normal(cc * _b[_cut1:_cons]-cc * mxb +cc * _b[eq1:cum_evprmp]*mcum_evprmp) 
scalar me_evprmp_nochange= normal(cc * _b[_cut2:_cons]-cc * mxb+cc * _b[eq1:cum_evprmp]*mcum_evprmp-cc * _b[eq1:cum_evprmp])- normal(cc * _b[_cut2:_cons]-cc * mxb +cc * _b[eq1:cum_evprmp]*mcum_evprmp) /// 
          -(normal(cc * _b[_cut1:_cons]-cc * mxb+cc * _b[eq1:cum_evprmp]*mcum_evprmp-cc * _b[eq1:cum_evprmp])-normal(cc * _b[_cut1:_cons]-cc * mxb +cc * _b[eq1:cum_evprmp]*mcum_evprmp)) 
scalar me_evprmp_increase=-(normal(cc * _b[_cut2:_cons]-cc * mxb+cc * _b[eq1:cum_evprmp]*mcum_evprmp-cc * _b[eq1:cum_evprmp])-normal(cc * _b[_cut2:_cons]-cc * mxb +cc * _b[eq1:cum_evprmp]*mcum_evprmp)) 

scalar me_evpro_decrease= normal(cc * _b[_cut1:_cons]-cc * mxb+cc * _b[eq1:cum_evpro]*mcum_evpro-cc * _b[eq1:cum_evpro])- normal(cc * _b[_cut1:_cons]-cc * mxb +cc * _b[eq1:cum_evpro]*mcum_evpro) 
scalar me_evpro_nochange= normal(cc * _b[_cut2:_cons]-cc * mxb+cc * _b[eq1:cum_evpro]*mcum_evpro-cc * _b[eq1:cum_evpro])- normal(cc * _b[_cut2:_cons]-cc * mxb +cc * _b[eq1:cum_evpro]*mcum_evpro) /// 
          -(normal(cc * _b[_cut1:_cons]-cc * mxb+cc * _b[eq1:cum_evpro]*mcum_evpro-cc * _b[eq1:cum_evpro])-normal(cc * _b[_cut1:_cons]-cc * mxb +cc * _b[eq1:cum_evpro]*mcum_evpro)) 
scalar me_evpro_increase=-(normal(cc * _b[_cut2:_cons]-cc * mxb+cc * _b[eq1:cum_evpro]*mcum_evpro-cc * _b[eq1:cum_evpro])-normal(cc * _b[_cut2:_cons]-cc * mxb +cc * _b[eq1:cum_evpro]*mcum_evpro)) 

scalar me_isalmtot_decrease= normal(_b[_cut1:_cons]-mxb+_b[eq1:cum_isalmtot]*mcum_isalmtot-_b[eq1:cum_isalmtot])- normal(_b[_cut1:_cons]-mxb +_b[eq1:cum_isalmtot]*mcum_isalmtot) 
scalar me_isalmtot_nochange= normal(_b[_cut2:_cons]-mxb+_b[eq1:cum_isalmtot]*mcum_isalmtot-_b[eq1:cum_isalmtot])- normal(_b[_cut2:_cons]-mxb +_b[eq1:cum_isalmtot]*mcum_isalmtot) /// 
          -(normal(_b[_cut1:_cons]-mxb+_b[eq1:cum_isalmtot]*mcum_isalmtot-_b[eq1:cum_isalmtot])-normal(_b[_cut1:_cons]-mxb +_b[eq1:cum_isalmtot]*mcum_isalmtot)) 
scalar me_isalmtot_increase=-(normal(_b[_cut2:_cons]-mxb+_b[eq1:cum_isalmtot]*mcum_isalmtot-_b[eq1:cum_isalmtot])-normal(_b[_cut2:_cons]-mxb +_b[eq1:cum_isalmtot]*mcum_isalmtot)) 

scalar me_ipp2_decrease= _b[eq1:cum_ipp2]*(-normalden(_b[_cut1:_cons]-mxb)) 
scalar me_ipp2_nochange= _b[eq1:cum_ipp2]*(-normalden(_b[_cut2:_cons]-mxb) + normalden(_b[_cut1:_cons]-mxb)) 
scalar me_ipp2_increase= _b[eq1:cum_ipp2]*(normalden(_b[_cut2:_cons]-mxb)) 


/** impact of VAT changes and Euro cash changeover (Ref. = 0) **/
scalar me_tva_2000_decrease= normal(cc * _b[_cut1:_cons]-cc * mxb+cc * _b[eq1:tva_2000]*mtva_2000-cc * _b[eq1:tva_2000])- normal(cc * _b[_cut1:_cons]-cc * mxb +cc * _b[eq1:tva_2000]*mtva_2000) 
scalar me_tva_2000_nochange= normal(cc * _b[_cut2:_cons]-cc * mxb+cc * _b[eq1:tva_2000]*mtva_2000-cc * _b[eq1:tva_2000])- normal(cc * _b[_cut2:_cons]-cc * mxb +cc * _b[eq1:tva_2000]*mtva_2000) /// 
          -(normal(cc * _b[_cut1:_cons]-cc * mxb+cc * _b[eq1:tva_2000]*mtva_2000-cc * _b[eq1:tva_2000])-normal(cc * _b[_cut1:_cons]-cc * mxb +cc * _b[eq1:tva_2000]*mtva_2000)) 
scalar me_tva_2000_increase=-(normal(cc * _b[_cut2:_cons]-cc * mxb+cc * _b[eq1:tva_2000]*mtva_2000-cc * _b[eq1:tva_2000])-normal(cc * _b[_cut2:_cons]-cc * mxb +cc * _b[eq1:tva_2000]*mtva_2000)) 

scalar me_tva_2000_2_decrease= normal(cc * _b[_cut1:_cons]-cc * mxb+cc * _b[eq1:tva_2000_2]*mtva_2000_2-cc * _b[eq1:tva_2000_2])- normal(cc * _b[_cut1:_cons]-cc * mxb +cc * _b[eq1:tva_2000_2]*mtva_2000_2) 
scalar me_tva_2000_2_nochange= normal(cc * _b[_cut2:_cons]-cc * mxb+cc * _b[eq1:tva_2000_2]*mtva_2000_2-cc * _b[eq1:tva_2000_2])- normal(cc * _b[_cut2:_cons]-cc * mxb +cc * _b[eq1:tva_2000_2]*mtva_2000_2) /// 
          -(normal(cc * _b[_cut1:_cons]-cc * mxb+cc * _b[eq1:tva_2000_2]*mtva_2000_2-cc * _b[eq1:tva_2000_2])-normal(cc * _b[_cut1:_cons]-cc * mxb +cc * _b[eq1:tva_2000_2]*mtva_2000_2)) 
scalar me_tva_2000_2_increase=-(normal(cc * _b[_cut2:_cons]-cc * mxb+cc * _b[eq1:tva_2000_2]*mtva_2000_2-cc * _b[eq1:tva_2000_2])-normal(cc * _b[_cut2:_cons]-cc * mxb +cc * _b[eq1:tva_2000_2]*mtva_2000_2)) 

scalar me_euro_2002_decrease= normal(cc * _b[_cut1:_cons]-cc * mxb+cc * _b[eq1:euro_2002]*meuro_2002-cc * _b[eq1:euro_2002])- normal(cc * _b[_cut1:_cons]-cc * mxb +cc * _b[eq1:euro_2002]*meuro_2002) 
scalar me_euro_2002_nochange= normal(cc * _b[_cut2:_cons]-cc * mxb+cc * _b[eq1:euro_2002]*meuro_2002-cc * _b[eq1:euro_2002])- normal(cc * _b[_cut2:_cons]-cc * mxb +cc * _b[eq1:euro_2002]*meuro_2002) /// 
          -(normal(cc * _b[_cut1:_cons]-cc * mxb+cc * _b[eq1:euro_2002]*meuro_2002-cc * _b[eq1:euro_2002])-normal(cc * _b[_cut1:_cons]-cc * mxb +cc * _b[eq1:euro_2002]*meuro_2002)) 
scalar me_euro_2002_increase=-(normal(cc * _b[_cut2:_cons]-cc * mxb+cc * _b[eq1:euro_2002]*meuro_2002-cc * _b[eq1:euro_2002])-normal(cc * _b[_cut2:_cons]-cc * mxb +cc * _b[eq1:euro_2002]*meuro_2002)) 

scalar me_euro_2002_2_decrease= normal(cc * _b[_cut1:_cons]-cc * mxb+cc * _b[eq1:euro_2002_2]*meuro_2002_2-cc * _b[eq1:euro_2002_2])- normal(cc * _b[_cut1:_cons]-cc * mxb +cc * _b[eq1:euro_2002_2]*meuro_2002_2) 
scalar me_euro_2002_2_nochange= normal(cc * _b[_cut2:_cons]-cc * mxb+cc * _b[eq1:euro_2002_2]*meuro_2002_2-cc * _b[eq1:euro_2002_2])- normal(cc * _b[_cut2:_cons]-cc * mxb +cc * _b[eq1:euro_2002_2]*meuro_2002_2) /// 
          -(normal(cc * _b[_cut1:_cons]-cc * mxb+cc * _b[eq1:euro_2002_2]*meuro_2002_2-cc * _b[eq1:euro_2002_2])-normal(cc * _b[_cut1:_cons]-cc * mxb +cc * _b[eq1:euro_2002_2]*meuro_2002_2)) 
scalar me_euro_2002_2_increase=-(normal(cc * _b[_cut2:_cons]-cc * mxb+cc * _b[eq1:euro_2002_2]*meuro_2002_2-cc * _b[eq1:euro_2002_2])-normal(cc * _b[_cut2:_cons]-cc * mxb +cc * _b[eq1:euro_2002_2]*meuro_2002_2)) 

scalar list me_evprmp_decrease   me_isalmtot_decrease   me_evpro_decrease  me_ipp2_decrease  ///
            me_tva_2000_decrease  me_tva_2000_2_decrease   me_euro_2002_decrease  me_euro_2002_2_decrease  

scalar list  me_evprmp_increase  me_isalmtot_increase  me_evpro_increase   me_ipp2_increase    ///
             me_tva_2000_increase  me_tva_2000_2_increase  me_euro_2002_increase  me_euro_2002_2_increase 

scalar drop _all


/*** UNCONSTRAINED DYNAMIC MODELS WITH LAGGED REGRESSORS  **/
/* Ordered probit model "à la "Rivers-Vuong **/

oprobit  evprpf evprmp evprmp_l1 evprmp_l2 evprmp_l3 cum_evprmp_l123 ///
                isalmtot2 isalmtot2_l1 isalmtot2_l2 isalmtot2_l3 cum_isalmtot_l123  ///
                evpro evpro_l1  evpro_l2  evpro_l3  cum_evpro_l123   ///
                txipp2 txipp2_l1 txipp2_l2 txipp2_l3 cum_ipp2_l123  ///
                tva_2000 tva_2000_2 euro_2002 euro_2002_2 ///
                res_evprmp  res_evprmp_l1 res_evprmp_l2 res_evprmp_l3 res_cum_evprmp_l123 ///
                res_isalmtot res_isalmtot_l1 res_isalmtot_l2 res_isalmtot_l3 res_cum_isalmtot_l123  ///
                res_evpro res_evpro_l1  res_evpro_l2  res_evpro_l3  res_cum_evpro_l123   ///
                res_txipp2_l1 res_txipp2_l2 res_txipp2_l3 res_cum_ipp2_l123  ///
                   /*ind_da*/ ind_db ind_dc ind_dd ind_de ind_dg ind_dh ind_di ///
                   ind_dj ind_dk ind_dl ind_dm ind_dn ///
                annee_1999 annee_2000 annee_2001 annee_2002 annee_2003 annee_2004 /*annee_2005*/

predict pylag, xb
sum pylag 
scalar mxb =r(mean) 

sum evprmp 
scalar mevprmp =r(mean) 
sum evprmp_l1 
scalar mevprmp_l1 =r(mean) 
sum evprmp_l2 
scalar mevprmp_l2 =r(mean) 
sum evprmp_l3 
scalar mevprmp_l3 =r(mean) 
sum cum_evprmp_l123 
scalar mcum_evprmp_l123 =r(mean) 

sum evpro 
scalar mevpro =r(mean) 
sum evpro_l1 
scalar mevpro_l1 =r(mean) 
sum evpro_l2 
scalar mevpro_l2 =r(mean) 
sum evpro_l3 
scalar mevpro_l3 =r(mean) 
sum cum_evpro_l123 
scalar mcum_evpro_l123 =r(mean) 

sum isalmtot2 
scalar misalmtot2 =r(mean) 
sum isalmtot2_l1 
scalar misalmtot2_l1 =r(mean) 
sum isalmtot2_l2 
scalar misalmtot2_l2 =r(mean) 
sum isalmtot2_l3 
scalar misalmtot2_l3 =r(mean) 
sum cum_isalmtot_l123 
scalar mcum_isalmtot_l123 =r(mean) 

sum txipp2 
scalar mtxipp2 =r(mean) 
sum txipp2_l1 
scalar mtxipp2_l1 =r(mean) 
sum txipp2_l2 
scalar mtxipp2_l2 =r(mean) 
sum txipp2_l3 
scalar mtxipp2_l3 =r(mean) 
sum cum_ipp2_l123 
scalar mcum_ipp2_l123 =r(mean) 

sum tva_2000 
scalar mtva_2000 =r(mean) 
sum tva_2000_2 
scalar mtva_2000_2 =r(mean) 
sum euro_2002 
scalar meuro_2002 =r(mean) 
sum euro_2002_2 
scalar meuro_2002_2 =r(mean) 


/** Computation of marginal effects **/
/** 0 -> 1  : Ref. = 0 **/

scalar me_evprmp_decrease= normal(_b[cut1:_cons]-mxb+_b[evprpf:evprmp]*mevprmp-_b[evprpf:evprmp])- normal(_b[cut1:_cons]-mxb +_b[evprpf:evprmp]*mevprmp) 
scalar me_evprmp_nochange= normal(_b[cut2:_cons]-mxb+_b[evprpf:evprmp]*mevprmp-_b[evprpf:evprmp])- normal(_b[cut2:_cons]-mxb +_b[evprpf:evprmp]*mevprmp) /// 
          -(normal(_b[cut1:_cons]-mxb+_b[evprpf:evprmp]*mevprmp-_b[evprpf:evprmp])-normal(_b[cut1:_cons]-mxb +_b[evprpf:evprmp]*mevprmp)) 
scalar me_evprmp_increase=-(normal(_b[cut2:_cons]-mxb+_b[evprpf:evprmp]*mevprmp-_b[evprpf:evprmp])-normal(_b[cut2:_cons]-mxb +_b[evprpf:evprmp]*mevprmp)) 

scalar me_evprmp_l1_decrease= normal(_b[cut1:_cons]-mxb+_b[evprpf:evprmp_l1]*mevprmp_l1-_b[evprpf:evprmp_l1])- normal(_b[cut1:_cons]-mxb +_b[evprpf:evprmp_l1]*mevprmp_l1) 
scalar me_evprmp_l1_nochange= normal(_b[cut2:_cons]-mxb+_b[evprpf:evprmp_l1]*mevprmp_l1-_b[evprpf:evprmp_l1])- normal(_b[cut2:_cons]-mxb +_b[evprpf:evprmp_l1]*mevprmp_l1) /// 
          -(normal(_b[cut1:_cons]-mxb+_b[evprpf:evprmp_l1]*mevprmp_l1-_b[evprpf:evprmp_l1])-normal(_b[cut1:_cons]-mxb +_b[evprpf:evprmp_l1]*mevprmp_l1)) 
scalar me_evprmp_l1_increase=-(normal(_b[cut2:_cons]-mxb+_b[evprpf:evprmp_l1]*mevprmp_l1-_b[evprpf:evprmp_l1])-normal(_b[cut2:_cons]-mxb +_b[evprpf:evprmp_l1]*mevprmp_l1)) 

scalar me_evprmp_l2_decrease= normal(_b[cut1:_cons]-mxb+_b[evprpf:evprmp_l2]*mevprmp_l2-_b[evprpf:evprmp_l2])- normal(_b[cut1:_cons]-mxb +_b[evprpf:evprmp_l2]*mevprmp_l2) 
scalar me_evprmp_l2_nochange= normal(_b[cut2:_cons]-mxb+_b[evprpf:evprmp_l2]*mevprmp_l2-_b[evprpf:evprmp_l2])- normal(_b[cut2:_cons]-mxb +_b[evprpf:evprmp_l2]*mevprmp_l2) /// 
          -(normal(_b[cut1:_cons]-mxb+_b[evprpf:evprmp_l2]*mevprmp_l2-_b[evprpf:evprmp_l2])-normal(_b[cut1:_cons]-mxb +_b[evprpf:evprmp_l2]*mevprmp_l2)) 
scalar me_evprmp_l2_increase=-(normal(_b[cut2:_cons]-mxb+_b[evprpf:evprmp_l2]*mevprmp_l2-_b[evprpf:evprmp_l2])-normal(_b[cut2:_cons]-mxb +_b[evprpf:evprmp_l2]*mevprmp_l2)) 

scalar me_evprmp_l3_decrease= normal(_b[cut1:_cons]-mxb+_b[evprpf:evprmp_l3]*mevprmp_l3-_b[evprpf:evprmp_l3])- normal(_b[cut1:_cons]-mxb +_b[evprpf:evprmp_l3]*mevprmp_l3) 
scalar me_evprmp_l3_nochange= normal(_b[cut2:_cons]-mxb+_b[evprpf:evprmp_l3]*mevprmp_l3-_b[evprpf:evprmp_l3])- normal(_b[cut2:_cons]-mxb +_b[evprpf:evprmp_l3]*mevprmp_l3) /// 
          -(normal(_b[cut1:_cons]-mxb+_b[evprpf:evprmp_l3]*mevprmp_l3-_b[evprpf:evprmp_l3])-normal(_b[cut1:_cons]-mxb +_b[evprpf:evprmp_l3]*mevprmp_l3)) 
scalar me_evprmp_l3_increase=-(normal(_b[cut2:_cons]-mxb+_b[evprpf:evprmp_l3]*mevprmp_l3-_b[evprpf:evprmp_l3])-normal(_b[cut2:_cons]-mxb +_b[evprpf:evprmp_l3]*mevprmp_l3)) 

scalar me_cum_evprmp_l123_decrease= normal( _b[cut1:_cons]- mxb+ _b[evprpf:cum_evprmp_l123]*mcum_evprmp_l123- _b[evprpf:cum_evprmp_l123])- normal( _b[cut1:_cons]- mxb + _b[evprpf:cum_evprmp_l123]*mcum_evprmp_l123) 
scalar me_cum_evprmp_l123_nochange= normal( _b[cut2:_cons]- mxb+ _b[evprpf:cum_evprmp_l123]*mcum_evprmp_l123- _b[evprpf:cum_evprmp_l123])- normal( _b[cut2:_cons]- mxb + _b[evprpf:cum_evprmp_l123]*mcum_evprmp_l123) /// 
          -(normal( _b[cut1:_cons]- mxb+ _b[evprpf:cum_evprmp_l123]*mcum_evprmp_l123- _b[evprpf:cum_evprmp_l123])-normal( _b[cut1:_cons]- mxb + _b[evprpf:cum_evprmp_l123]*mcum_evprmp_l123)) 
scalar me_cum_evprmp_l123_increase=-(normal( _b[cut2:_cons]- mxb+ _b[evprpf:cum_evprmp_l123]*mcum_evprmp_l123- _b[evprpf:cum_evprmp_l123])-normal( _b[cut2:_cons]- mxb + _b[evprpf:cum_evprmp_l123]*mcum_evprmp_l123)) 



scalar me_evpro_decrease= normal(_b[cut1:_cons]-mxb+_b[evprpf:evpro]*mevpro-_b[evprpf:evpro])- normal(_b[cut1:_cons]-mxb +_b[evprpf:evpro]*mevpro) 
scalar me_evpro_nochange= normal(_b[cut2:_cons]-mxb+_b[evprpf:evpro]*mevpro-_b[evprpf:evpro])- normal(_b[cut2:_cons]-mxb +_b[evprpf:evpro]*mevpro) /// 
          -(normal(_b[cut1:_cons]-mxb+_b[evprpf:evpro]*mevpro-_b[evprpf:evpro])-normal(_b[cut1:_cons]-mxb +_b[evprpf:evpro]*mevpro)) 
scalar me_evpro_increase=-(normal(_b[cut2:_cons]-mxb+_b[evprpf:evpro]*mevpro-_b[evprpf:evpro])-normal(_b[cut2:_cons]-mxb +_b[evprpf:evpro]*mevpro)) 

scalar me_evpro_l1_decrease= normal(_b[cut1:_cons]-mxb+_b[evprpf:evpro_l1]*mevpro_l1-_b[evprpf:evpro_l1])- normal(_b[cut1:_cons]-mxb +_b[evprpf:evpro_l1]*mevpro_l1) 
scalar me_evpro_l1_nochange= normal(_b[cut2:_cons]-mxb+_b[evprpf:evpro_l1]*mevpro_l1-_b[evprpf:evpro_l1])- normal(_b[cut2:_cons]-mxb +_b[evprpf:evpro_l1]*mevpro_l1) /// 
          -(normal(_b[cut1:_cons]-mxb+_b[evprpf:evpro_l1]*mevpro_l1-_b[evprpf:evpro_l1])-normal(_b[cut1:_cons]-mxb +_b[evprpf:evpro_l1]*mevpro_l1)) 
scalar me_evpro_l1_increase=-(normal(_b[cut2:_cons]-mxb+_b[evprpf:evpro_l1]*mevpro_l1-_b[evprpf:evpro_l1])-normal(_b[cut2:_cons]-mxb +_b[evprpf:evpro_l1]*mevpro_l1)) 

scalar me_evpro_l2_decrease= normal(_b[cut1:_cons]-mxb+_b[evprpf:evpro_l2]*mevpro_l2-_b[evprpf:evpro_l2])- normal(_b[cut1:_cons]-mxb +_b[evprpf:evpro_l2]*mevpro_l2) 
scalar me_evpro_l2_nochange= normal(_b[cut2:_cons]-mxb+_b[evprpf:evpro_l2]*mevpro_l2-_b[evprpf:evpro_l2])- normal(_b[cut2:_cons]-mxb +_b[evprpf:evpro_l2]*mevpro_l2) /// 
          -(normal(_b[cut1:_cons]-mxb+_b[evprpf:evpro_l2]*mevpro_l2-_b[evprpf:evpro_l2])-normal(_b[cut1:_cons]-mxb +_b[evprpf:evpro_l2]*mevpro_l2)) 
scalar me_evpro_l2_increase=-(normal(_b[cut2:_cons]-mxb+_b[evprpf:evpro_l2]*mevpro_l2-_b[evprpf:evpro_l2])-normal(_b[cut2:_cons]-mxb +_b[evprpf:evpro_l2]*mevpro_l2)) 

scalar me_evpro_l3_decrease= normal(_b[cut1:_cons]-mxb+_b[evprpf:evpro_l3]*mevpro_l3-_b[evprpf:evpro_l3])- normal(_b[cut1:_cons]-mxb +_b[evprpf:evpro_l3]*mevpro_l3) 
scalar me_evpro_l3_nochange= normal(_b[cut2:_cons]-mxb+_b[evprpf:evpro_l3]*mevpro_l3-_b[evprpf:evpro_l3])- normal(_b[cut2:_cons]-mxb +_b[evprpf:evpro_l3]*mevpro_l3) /// 
          -(normal(_b[cut1:_cons]-mxb+_b[evprpf:evpro_l3]*mevpro_l3-_b[evprpf:evpro_l3])-normal(_b[cut1:_cons]-mxb +_b[evprpf:evpro_l3]*mevpro_l3)) 
scalar me_evpro_l3_increase=-(normal(_b[cut2:_cons]-mxb+_b[evprpf:evpro_l3]*mevpro_l3-_b[evprpf:evpro_l3])-normal(_b[cut2:_cons]-mxb +_b[evprpf:evpro_l3]*mevpro_l3)) 

scalar me_cum_evpro_l123_decrease= normal( _b[cut1:_cons]- mxb+ _b[evprpf:cum_evpro_l123]*mcum_evpro_l123- _b[evprpf:cum_evpro_l123])- normal( _b[cut1:_cons]- mxb + _b[evprpf:cum_evpro_l123]*mcum_evpro_l123) 
scalar me_cum_evpro_l123_nochange= normal( _b[cut2:_cons]- mxb+ _b[evprpf:cum_evpro_l123]*mcum_evpro_l123- _b[evprpf:cum_evpro_l123])- normal( _b[cut2:_cons]- mxb + _b[evprpf:cum_evpro_l123]*mcum_evpro_l123) /// 
          -(normal( _b[cut1:_cons]- mxb+ _b[evprpf:cum_evpro_l123]*mcum_evpro_l123- _b[evprpf:cum_evpro_l123])-normal( _b[cut1:_cons]- mxb + _b[evprpf:cum_evpro_l123]*mcum_evpro_l123)) 
scalar me_cum_evpro_l123_increase=-(normal( _b[cut2:_cons]- mxb+ _b[evprpf:cum_evpro_l123]*mcum_evpro_l123- _b[evprpf:cum_evpro_l123])-normal( _b[cut2:_cons]- mxb + _b[evprpf:cum_evpro_l123]*mcum_evpro_l123)) 


scalar me_isalmtot2_decrease= normal(_b[cut1:_cons]-mxb+_b[evprpf:isalmtot2]*misalmtot2-_b[evprpf:isalmtot2])- normal(_b[cut1:_cons]-mxb +_b[evprpf:isalmtot2]*misalmtot2) 
scalar me_isalmtot2_nochange= normal(_b[cut2:_cons]-mxb+_b[evprpf:isalmtot2]*misalmtot2-_b[evprpf:isalmtot2])- normal(_b[cut2:_cons]-mxb +_b[evprpf:isalmtot2]*misalmtot2) /// 
          -(normal(_b[cut1:_cons]-mxb+_b[evprpf:isalmtot2]*misalmtot2-_b[evprpf:isalmtot2])-normal(_b[cut1:_cons]-mxb +_b[evprpf:isalmtot2]*misalmtot2)) 
scalar me_isalmtot2_increase=-(normal(_b[cut2:_cons]-mxb+_b[evprpf:isalmtot2]*misalmtot2-_b[evprpf:isalmtot2])-normal(_b[cut2:_cons]-mxb +_b[evprpf:isalmtot2]*misalmtot2)) 

scalar me_isalmtot2_l1_decrease= normal(_b[cut1:_cons]-mxb+_b[evprpf:isalmtot2_l1]*misalmtot2_l1-_b[evprpf:isalmtot2_l1])- normal(_b[cut1:_cons]-mxb +_b[evprpf:isalmtot2_l1]*misalmtot2_l1) 
scalar me_isalmtot2_l1_nochange= normal(_b[cut2:_cons]-mxb+_b[evprpf:isalmtot2_l1]*misalmtot2_l1-_b[evprpf:isalmtot2_l1])- normal(_b[cut2:_cons]-mxb +_b[evprpf:isalmtot2_l1]*misalmtot2_l1) /// 
          -(normal(_b[cut1:_cons]-mxb+_b[evprpf:isalmtot2_l1]*misalmtot2_l1-_b[evprpf:isalmtot2_l1])-normal(_b[cut1:_cons]-mxb +_b[evprpf:isalmtot2_l1]*misalmtot2_l1)) 
scalar me_isalmtot2_l1_increase=-(normal(_b[cut2:_cons]-mxb+_b[evprpf:isalmtot2_l1]*misalmtot2_l1-_b[evprpf:isalmtot2_l1])-normal(_b[cut2:_cons]-mxb +_b[evprpf:isalmtot2_l1]*misalmtot2_l1)) 

scalar me_isalmtot2_l2_decrease= normal(_b[cut1:_cons]-mxb+_b[evprpf:isalmtot2_l2]*misalmtot2_l2-_b[evprpf:isalmtot2_l2])- normal(_b[cut1:_cons]-mxb +_b[evprpf:isalmtot2_l2]*misalmtot2_l2) 
scalar me_isalmtot2_l2_nochange= normal(_b[cut2:_cons]-mxb+_b[evprpf:isalmtot2_l2]*misalmtot2_l2-_b[evprpf:isalmtot2_l2])- normal(_b[cut2:_cons]-mxb +_b[evprpf:isalmtot2_l2]*misalmtot2_l2) /// 
          -(normal(_b[cut1:_cons]-mxb+_b[evprpf:isalmtot2_l2]*misalmtot2_l2-_b[evprpf:isalmtot2_l2])-normal(_b[cut1:_cons]-mxb +_b[evprpf:isalmtot2_l2]*misalmtot2_l2)) 
scalar me_isalmtot2_l2_increase=-(normal(_b[cut2:_cons]-mxb+_b[evprpf:isalmtot2_l2]*misalmtot2_l2-_b[evprpf:isalmtot2_l2])-normal(_b[cut2:_cons]-mxb +_b[evprpf:isalmtot2_l2]*misalmtot2_l2)) 

scalar me_isalmtot2_l3_decrease= normal(_b[cut1:_cons]-mxb+_b[evprpf:isalmtot2_l3]*misalmtot2_l3-_b[evprpf:isalmtot2_l3])- normal(_b[cut1:_cons]-mxb +_b[evprpf:isalmtot2_l3]*misalmtot2_l3) 
scalar me_isalmtot2_l3_nochange= normal(_b[cut2:_cons]-mxb+_b[evprpf:isalmtot2_l3]*misalmtot2_l3-_b[evprpf:isalmtot2_l3])- normal(_b[cut2:_cons]-mxb +_b[evprpf:isalmtot2_l3]*misalmtot2_l3) /// 
          -(normal(_b[cut1:_cons]-mxb+_b[evprpf:isalmtot2_l3]*misalmtot2_l3-_b[evprpf:isalmtot2_l3])-normal(_b[cut1:_cons]-mxb +_b[evprpf:isalmtot2_l3]*misalmtot2_l3)) 
scalar me_isalmtot2_l3_increase=-(normal(_b[cut2:_cons]-mxb+_b[evprpf:isalmtot2_l3]*misalmtot2_l3-_b[evprpf:isalmtot2_l3])-normal(_b[cut2:_cons]-mxb +_b[evprpf:isalmtot2_l3]*misalmtot2_l3)) 

scalar me_cum_isalmtot_l123_decrease= normal( _b[cut1:_cons]- mxb+ _b[evprpf:cum_isalmtot_l123]*mcum_isalmtot_l123- _b[evprpf:cum_isalmtot_l123])- normal( _b[cut1:_cons]- mxb + _b[evprpf:cum_isalmtot_l123]*mcum_isalmtot_l123) 
scalar me_cum_isalmtot_l123_nochange= normal( _b[cut2:_cons]- mxb+ _b[evprpf:cum_isalmtot_l123]*mcum_isalmtot_l123- _b[evprpf:cum_isalmtot_l123])- normal( _b[cut2:_cons]- mxb + _b[evprpf:cum_isalmtot_l123]*mcum_isalmtot_l123) /// 
          -(normal( _b[cut1:_cons]- mxb+ _b[evprpf:cum_isalmtot_l123]*mcum_isalmtot_l123- _b[evprpf:cum_isalmtot_l123])-normal( _b[cut1:_cons]- mxb + _b[evprpf:cum_isalmtot_l123]*mcum_isalmtot_l123)) 
scalar me_cum_isalmtot_l123_increase=-(normal( _b[cut2:_cons]- mxb+ _b[evprpf:cum_isalmtot_l123]*mcum_isalmtot_l123- _b[evprpf:cum_isalmtot_l123])-normal( _b[cut2:_cons]- mxb + _b[evprpf:cum_isalmtot_l123]*mcum_isalmtot_l123)) 



scalar me_txipp2_decrease= normal(_b[cut1:_cons]-mxb+_b[evprpf:txipp2]*mtxipp2-_b[evprpf:txipp2])- normal(_b[cut1:_cons]-mxb +_b[evprpf:txipp2]*mtxipp2) 
scalar me_txipp2_nochange= normal(_b[cut2:_cons]-mxb+_b[evprpf:txipp2]*mtxipp2-_b[evprpf:txipp2])- normal(_b[cut2:_cons]-mxb +_b[evprpf:txipp2]*mtxipp2) /// 
          -(normal(_b[cut1:_cons]-mxb+_b[evprpf:txipp2]*mtxipp2-_b[evprpf:txipp2])-normal(_b[cut1:_cons]-mxb +_b[evprpf:txipp2]*mtxipp2)) 
scalar me_txipp2_increase=-(normal(_b[cut2:_cons]-mxb+_b[evprpf:txipp2]*mtxipp2-_b[evprpf:txipp2])-normal(_b[cut2:_cons]-mxb +_b[evprpf:txipp2]*mtxipp2)) 

scalar me_txipp2_l1_decrease= normal(_b[cut1:_cons]-mxb+_b[evprpf:txipp2_l1]*mtxipp2_l1-_b[evprpf:txipp2_l1])- normal(_b[cut1:_cons]-mxb +_b[evprpf:txipp2_l1]*mtxipp2_l1) 
scalar me_txipp2_l1_nochange= normal(_b[cut2:_cons]-mxb+_b[evprpf:txipp2_l1]*mtxipp2_l1-_b[evprpf:txipp2_l1])- normal(_b[cut2:_cons]-mxb +_b[evprpf:txipp2_l1]*mtxipp2_l1) /// 
          -(normal(_b[cut1:_cons]-mxb+_b[evprpf:txipp2_l1]*mtxipp2_l1-_b[evprpf:txipp2_l1])-normal(_b[cut1:_cons]-mxb +_b[evprpf:txipp2_l1]*mtxipp2_l1)) 
scalar me_txipp2_l1_increase=-(normal(_b[cut2:_cons]-mxb+_b[evprpf:txipp2_l1]*mtxipp2_l1-_b[evprpf:txipp2_l1])-normal(_b[cut2:_cons]-mxb +_b[evprpf:txipp2_l1]*mtxipp2_l1)) 

scalar me_txipp2_l2_decrease= normal(_b[cut1:_cons]-mxb+_b[evprpf:txipp2_l2]*mtxipp2_l2-_b[evprpf:txipp2_l2])- normal(_b[cut1:_cons]-mxb +_b[evprpf:txipp2_l2]*mtxipp2_l2) 
scalar me_txipp2_l2_nochange= normal(_b[cut2:_cons]-mxb+_b[evprpf:txipp2_l2]*mtxipp2_l2-_b[evprpf:txipp2_l2])- normal(_b[cut2:_cons]-mxb +_b[evprpf:txipp2_l2]*mtxipp2_l2) /// 
          -(normal(_b[cut1:_cons]-mxb+_b[evprpf:txipp2_l2]*mtxipp2_l2-_b[evprpf:txipp2_l2])-normal(_b[cut1:_cons]-mxb +_b[evprpf:txipp2_l2]*mtxipp2_l2)) 
scalar me_txipp2_l2_increase=-(normal(_b[cut2:_cons]-mxb+_b[evprpf:txipp2_l2]*mtxipp2_l2-_b[evprpf:txipp2_l2])-normal(_b[cut2:_cons]-mxb +_b[evprpf:txipp2_l2]*mtxipp2_l2)) 

scalar me_txipp2_l3_decrease= normal(_b[cut1:_cons]-mxb+_b[evprpf:txipp2_l3]*mtxipp2_l3-_b[evprpf:txipp2_l3])- normal(_b[cut1:_cons]-mxb +_b[evprpf:txipp2_l3]*mtxipp2_l3) 
scalar me_txipp2_l3_nochange= normal(_b[cut2:_cons]-mxb+_b[evprpf:txipp2_l3]*mtxipp2_l3-_b[evprpf:txipp2_l3])- normal(_b[cut2:_cons]-mxb +_b[evprpf:txipp2_l3]*mtxipp2_l3) /// 
          -(normal(_b[cut1:_cons]-mxb+_b[evprpf:txipp2_l3]*mtxipp2_l3-_b[evprpf:txipp2_l3])-normal(_b[cut1:_cons]-mxb +_b[evprpf:txipp2_l3]*mtxipp2_l3)) 
scalar me_txipp2_l3_increase=-(normal(_b[cut2:_cons]-mxb+_b[evprpf:txipp2_l3]*mtxipp2_l3-_b[evprpf:txipp2_l3])-normal(_b[cut2:_cons]-mxb +_b[evprpf:txipp2_l3]*mtxipp2_l3)) 

scalar me_cum_ipp2_l123_decrease= normal( _b[cut1:_cons]- mxb+ _b[evprpf:cum_ipp2_l123]*mcum_ipp2_l123- _b[evprpf:cum_ipp2_l123])- normal( _b[cut1:_cons]- mxb + _b[evprpf:cum_ipp2_l123]*mcum_ipp2_l123) 
scalar me_cum_ipp2_l123_nochange= normal( _b[cut2:_cons]- mxb+ _b[evprpf:cum_ipp2_l123]*mcum_ipp2_l123- _b[evprpf:cum_ipp2_l123])- normal( _b[cut2:_cons]- mxb + _b[evprpf:cum_ipp2_l123]*mcum_ipp2_l123) /// 
          -(normal( _b[cut1:_cons]- mxb+ _b[evprpf:cum_ipp2_l123]*mcum_ipp2_l123- _b[evprpf:cum_ipp2_l123])-normal( _b[cut1:_cons]- mxb + _b[evprpf:cum_ipp2_l123]*mcum_ipp2_l123)) 
scalar me_cum_ipp2_l123_increase=-(normal( _b[cut2:_cons]- mxb+ _b[evprpf:cum_ipp2_l123]*mcum_ipp2_l123- _b[evprpf:cum_ipp2_l123])-normal( _b[cut2:_cons]- mxb + _b[evprpf:cum_ipp2_l123]*mcum_ipp2_l123)) 


/** impact of VAT changes and Euro cash changeover (Ref. = 0) **/
scalar me_tva_2000_decrease= normal( _b[cut1:_cons]- mxb+ _b[evprpf:tva_2000]*mtva_2000- _b[evprpf:tva_2000])- normal( _b[cut1:_cons]- mxb + _b[evprpf:tva_2000]*mtva_2000) 
scalar me_tva_2000_nochange= normal( _b[cut2:_cons]- mxb+ _b[evprpf:tva_2000]*mtva_2000- _b[evprpf:tva_2000])- normal( _b[cut2:_cons]- mxb + _b[evprpf:tva_2000]*mtva_2000) /// 
          -(normal( _b[cut1:_cons]- mxb+ _b[evprpf:tva_2000]*mtva_2000- _b[evprpf:tva_2000])-normal( _b[cut1:_cons]- mxb + _b[evprpf:tva_2000]*mtva_2000)) 
scalar me_tva_2000_increase=-(normal( _b[cut2:_cons]- mxb+ _b[evprpf:tva_2000]*mtva_2000- _b[evprpf:tva_2000])-normal( _b[cut2:_cons]- mxb + _b[evprpf:tva_2000]*mtva_2000)) 

scalar me_tva_2000_2_decrease= normal( _b[cut1:_cons]- mxb+ _b[evprpf:tva_2000_2]*mtva_2000_2- _b[evprpf:tva_2000_2])- normal( _b[cut1:_cons]- mxb + _b[evprpf:tva_2000_2]*mtva_2000_2) 
scalar me_tva_2000_2_nochange= normal( _b[cut2:_cons]- mxb+ _b[evprpf:tva_2000_2]*mtva_2000_2- _b[evprpf:tva_2000_2])- normal( _b[cut2:_cons]- mxb + _b[evprpf:tva_2000_2]*mtva_2000_2) /// 
          -(normal( _b[cut1:_cons]- mxb+ _b[evprpf:tva_2000_2]*mtva_2000_2- _b[evprpf:tva_2000_2])-normal( _b[cut1:_cons]- mxb + _b[evprpf:tva_2000_2]*mtva_2000_2)) 
scalar me_tva_2000_2_increase=-(normal( _b[cut2:_cons]- mxb+ _b[evprpf:tva_2000_2]*mtva_2000_2- _b[evprpf:tva_2000_2])-normal( _b[cut2:_cons]- mxb + _b[evprpf:tva_2000_2]*mtva_2000_2)) 

scalar me_euro_2002_decrease= normal( _b[cut1:_cons]- mxb+ _b[evprpf:euro_2002]*meuro_2002- _b[evprpf:euro_2002])- normal( _b[cut1:_cons]- mxb + _b[evprpf:euro_2002]*meuro_2002) 
scalar me_euro_2002_nochange= normal( _b[cut2:_cons]- mxb+ _b[evprpf:euro_2002]*meuro_2002- _b[evprpf:euro_2002])- normal( _b[cut2:_cons]- mxb + _b[evprpf:euro_2002]*meuro_2002) /// 
          -(normal( _b[cut1:_cons]- mxb+ _b[evprpf:euro_2002]*meuro_2002- _b[evprpf:euro_2002])-normal( _b[cut1:_cons]- mxb + _b[evprpf:euro_2002]*meuro_2002)) 
scalar me_euro_2002_increase=-(normal( _b[cut2:_cons]- mxb+ _b[evprpf:euro_2002]*meuro_2002- _b[evprpf:euro_2002])-normal( _b[cut2:_cons]- mxb + _b[evprpf:euro_2002]*meuro_2002)) 

scalar me_euro_2002_2_decrease= normal( _b[cut1:_cons]- mxb+ _b[evprpf:euro_2002_2]*meuro_2002_2- _b[evprpf:euro_2002_2])- normal( _b[cut1:_cons]- mxb + _b[evprpf:euro_2002_2]*meuro_2002_2) 
scalar me_euro_2002_2_nochange= normal( _b[cut2:_cons]- mxb+ _b[evprpf:euro_2002_2]*meuro_2002_2- _b[evprpf:euro_2002_2])- normal( _b[cut2:_cons]- mxb + _b[evprpf:euro_2002_2]*meuro_2002_2) /// 
          -(normal( _b[cut1:_cons]- mxb+ _b[evprpf:euro_2002_2]*meuro_2002_2- _b[evprpf:euro_2002_2])-normal( _b[cut1:_cons]- mxb + _b[evprpf:euro_2002_2]*meuro_2002_2)) 
scalar me_euro_2002_2_increase=-(normal( _b[cut2:_cons]- mxb+ _b[evprpf:euro_2002_2]*meuro_2002_2- _b[evprpf:euro_2002_2])-normal( _b[cut2:_cons]- mxb + _b[evprpf:euro_2002_2]*meuro_2002_2)) 

scalar list me_evprmp_decrease     me_evprmp_l1_decrease     me_evprmp_l2_decrease     me_evprmp_l3_decrease      me_cum_isalmtot_l123_decrease  ///
               me_isalmtot2_decrease  me_isalmtot2_l1_decrease  me_isalmtot2_l2_decrease  me_isalmtot2_l3_decrease   me_cum_isalmtot_l123_decrease  ///
               me_evpro_decrease      me_evpro_l1_decrease      me_evpro_l2_decrease      me_evpro_l3_decrease       me_cum_evpro_l123_decrease  ///
               me_txipp2_decrease     me_txipp2_l1_decrease     me_txipp2_l2_decrease     me_txipp2_l3_decrease      me_cum_ipp2_l123_decrease   ///
               me_tva_2000_decrease   me_tva_2000_2_decrease    me_euro_2002_decrease     me_euro_2002_2_decrease  

 
scalar list me_evprmp_increase     me_evprmp_l1_increase     me_evprmp_l2_increase     me_evprmp_l3_increase      me_cum_isalmtot_l123_increase  ///
               me_isalmtot2_increase  me_isalmtot2_l1_increase  me_isalmtot2_l2_increase  me_isalmtot2_l3_increase   me_cum_isalmtot_l123_increase  ///
               me_evpro_increase      me_evpro_l1_increase      me_evpro_l2_increase      me_evpro_l3_increase       me_cum_evpro_l123_increase  ///
               me_txipp2_increase     me_txipp2_l1_increase     me_txipp2_l2_increase     me_txipp2_l3_increase      me_cum_ipp2_l123_increase   ///
               me_tva_2000_increase   me_tva_2000_2_increase    me_euro_2002_increase     me_euro_2002_2_increase  

scalar drop _all


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
                   /*ind_da*/ ind_db ind_dc ind_dd ind_de ind_dg ind_dh ind_di ///
                   ind_dj ind_dk ind_dl ind_dm ind_dn ///
                annee_1999 annee_2000 annee_2001 annee_2002 annee_2003 annee_2004 /*annee_2005*/   ///
                ,  i(ident_stata)


predict pylagr, xb
sum pylagr 
scalar mxb =r(mean) 

scalar cc = sqrt(1-_b[rho:_cons]) 
scalar list cc

sum evprmp 
scalar mevprmp =r(mean) 
sum evprmp_l1 
scalar mevprmp_l1 =r(mean) 
sum evprmp_l2 
scalar mevprmp_l2 =r(mean) 
sum evprmp_l3 
scalar mevprmp_l3 =r(mean) 
sum cum_evprmp_l123 
scalar mcum_evprmp_l123 =r(mean) 

sum evpro 
scalar mevpro =r(mean) 
sum evpro_l1 
scalar mevpro_l1 =r(mean) 
sum evpro_l2 
scalar mevpro_l2 =r(mean) 
sum evpro_l3 
scalar mevpro_l3 =r(mean) 
sum cum_evpro_l123 
scalar mcum_evpro_l123 =r(mean) 

sum isalmtot2 
scalar misalmtot2 =r(mean) 
sum isalmtot2_l1 
scalar misalmtot2_l1 =r(mean) 
sum isalmtot2_l2 
scalar misalmtot2_l2 =r(mean) 
sum isalmtot2_l3 
scalar misalmtot2_l3 =r(mean) 
sum cum_isalmtot_l123 
scalar mcum_isalmtot_l123 =r(mean) 

sum txipp2 
scalar mtxipp2 =r(mean) 
sum txipp2_l1 
scalar mtxipp2_l1 =r(mean) 
sum txipp2_l2 
scalar mtxipp2_l2 =r(mean) 
sum txipp2_l3 
scalar mtxipp2_l3 =r(mean) 
sum cum_ipp2_l123 
scalar mcum_ipp2_l123 =r(mean) 

sum tva_2000 
scalar mtva_2000 =r(mean) 
sum tva_2000_2 
scalar mtva_2000_2 =r(mean) 
sum euro_2002 
scalar meuro_2002 =r(mean) 
sum euro_2002_2 
scalar meuro_2002_2 =r(mean) 



/** Computation of marginal effects **/
/** 0 -> 1  : Ref. = 0 **/
scalar me_evprmp_decrease= normal(cc * _b[_cut1:_cons]-cc *mxb+cc * _b[eq1:evprmp]*mevprmp-cc * _b[eq1:evprmp])- normal(cc * _b[_cut1:_cons]-cc *mxb +cc * _b[eq1:evprmp]*mevprmp) 
scalar me_evprmp_nochange= normal(cc * _b[_cut2:_cons]-cc *mxb+cc * _b[eq1:evprmp]*mevprmp-cc * _b[eq1:evprmp])- normal(cc * _b[_cut2:_cons]-cc *mxb +cc * _b[eq1:evprmp]*mevprmp) /// 
          -(normal(cc * _b[_cut1:_cons]-cc *mxb+cc * _b[eq1:evprmp]*mevprmp-cc * _b[eq1:evprmp])-normal(cc * _b[_cut1:_cons]-cc *mxb +cc * _b[eq1:evprmp]*mevprmp)) 
scalar me_evprmp_increase=-(normal(cc * _b[_cut2:_cons]-cc *mxb+cc * _b[eq1:evprmp]*mevprmp-cc * _b[eq1:evprmp])-normal(cc * _b[_cut2:_cons]-cc *mxb +cc * _b[eq1:evprmp]*mevprmp)) 

scalar me_evprmp_l1_decrease= normal(cc * _b[_cut1:_cons]-cc *mxb+cc * _b[eq1:evprmp_l1]*mevprmp_l1-cc * _b[eq1:evprmp_l1])- normal(cc * _b[_cut1:_cons]-cc *mxb +cc * _b[eq1:evprmp_l1]*mevprmp_l1) 
scalar me_evprmp_l1_nochange= normal(cc * _b[_cut2:_cons]-cc *mxb+cc * _b[eq1:evprmp_l1]*mevprmp_l1-cc * _b[eq1:evprmp_l1])- normal(cc * _b[_cut2:_cons]-cc *mxb +cc * _b[eq1:evprmp_l1]*mevprmp_l1) /// 
          -(normal(cc * _b[_cut1:_cons]-cc *mxb+cc * _b[eq1:evprmp_l1]*mevprmp_l1-cc * _b[eq1:evprmp_l1])-normal(cc * _b[_cut1:_cons]-cc *mxb +cc * _b[eq1:evprmp_l1]*mevprmp_l1)) 
scalar me_evprmp_l1_increase=-(normal(cc * _b[_cut2:_cons]-cc *mxb+cc * _b[eq1:evprmp_l1]*mevprmp_l1-cc * _b[eq1:evprmp_l1])-normal(cc * _b[_cut2:_cons]-cc *mxb +cc * _b[eq1:evprmp_l1]*mevprmp_l1)) 

scalar me_evprmp_l2_decrease= normal(cc * _b[_cut1:_cons]-cc *mxb+cc * _b[eq1:evprmp_l2]*mevprmp_l2-cc * _b[eq1:evprmp_l2])- normal(cc * _b[_cut1:_cons]-cc *mxb +cc * _b[eq1:evprmp_l2]*mevprmp_l2) 
scalar me_evprmp_l2_nochange= normal(cc * _b[_cut2:_cons]-cc *mxb+cc * _b[eq1:evprmp_l2]*mevprmp_l2-cc * _b[eq1:evprmp_l2])- normal(cc * _b[_cut2:_cons]-cc *mxb +cc * _b[eq1:evprmp_l2]*mevprmp_l2) /// 
          -(normal(cc * _b[_cut1:_cons]-cc *mxb+cc * _b[eq1:evprmp_l2]*mevprmp_l2-cc * _b[eq1:evprmp_l2])-normal(cc * _b[_cut1:_cons]-cc *mxb +cc * _b[eq1:evprmp_l2]*mevprmp_l2)) 
scalar me_evprmp_l2_increase=-(normal(cc * _b[_cut2:_cons]-cc *mxb+cc * _b[eq1:evprmp_l2]*mevprmp_l2-cc * _b[eq1:evprmp_l2])-normal(cc * _b[_cut2:_cons]-cc *mxb +cc * _b[eq1:evprmp_l2]*mevprmp_l2)) 

scalar me_evprmp_l3_decrease= normal(cc * _b[_cut1:_cons]-cc *mxb+cc * _b[eq1:evprmp_l3]*mevprmp_l3-cc * _b[eq1:evprmp_l3])- normal(cc * _b[_cut1:_cons]-cc *mxb +cc * _b[eq1:evprmp_l3]*mevprmp_l3) 
scalar me_evprmp_l3_nochange= normal(cc * _b[_cut2:_cons]-cc *mxb+cc * _b[eq1:evprmp_l3]*mevprmp_l3-cc * _b[eq1:evprmp_l3])- normal(cc * _b[_cut2:_cons]-cc *mxb +cc * _b[eq1:evprmp_l3]*mevprmp_l3) /// 
          -(normal(cc * _b[_cut1:_cons]-cc *mxb+cc * _b[eq1:evprmp_l3]*mevprmp_l3-cc * _b[eq1:evprmp_l3])-normal(cc * _b[_cut1:_cons]-cc *mxb +cc * _b[eq1:evprmp_l3]*mevprmp_l3)) 
scalar me_evprmp_l3_increase=-(normal(cc * _b[_cut2:_cons]-cc *mxb+cc * _b[eq1:evprmp_l3]*mevprmp_l3-cc * _b[eq1:evprmp_l3])-normal(cc * _b[_cut2:_cons]-cc *mxb +cc * _b[eq1:evprmp_l3]*mevprmp_l3)) 

scalar me_cum_evprmp_l123_decrease= normal(cc * cc * _b[_cut1:_cons]-cc * cc *mxb+cc * cc * _b[eq1:cum_evprmp_l123]*mcum_evprmp_l123-cc * cc * _b[eq1:cum_evprmp_l123])- normal(cc * cc * _b[_cut1:_cons]-cc * cc *mxb +cc * cc * _b[eq1:cum_evprmp_l123]*mcum_evprmp_l123) 
scalar me_cum_evprmp_l123_nochange= normal(cc * cc * _b[_cut2:_cons]-cc * cc *mxb+cc * cc * _b[eq1:cum_evprmp_l123]*mcum_evprmp_l123-cc * cc * _b[eq1:cum_evprmp_l123])- normal(cc * cc * _b[_cut2:_cons]-cc * cc *mxb +cc * cc * _b[eq1:cum_evprmp_l123]*mcum_evprmp_l123) /// 
          -(normal(cc * cc * _b[_cut1:_cons]-cc * cc *mxb+cc * cc * _b[eq1:cum_evprmp_l123]*mcum_evprmp_l123-cc * cc * _b[eq1:cum_evprmp_l123])-normal(cc * cc * _b[_cut1:_cons]-cc * cc *mxb +cc * cc * _b[eq1:cum_evprmp_l123]*mcum_evprmp_l123)) 
scalar me_cum_evprmp_l123_increase=-(normal(cc * cc * _b[_cut2:_cons]-cc * cc *mxb+cc * cc * _b[eq1:cum_evprmp_l123]*mcum_evprmp_l123-cc * cc * _b[eq1:cum_evprmp_l123])-normal(cc * cc * _b[_cut2:_cons]-cc * cc *mxb +cc * cc * _b[eq1:cum_evprmp_l123]*mcum_evprmp_l123)) 


scalar me_evpro_decrease= normal(cc * _b[_cut1:_cons]-cc *mxb+cc * _b[eq1:evpro]*mevpro-cc * _b[eq1:evpro])- normal(cc * _b[_cut1:_cons]-cc *mxb +cc * _b[eq1:evpro]*mevpro) 
scalar me_evpro_nochange= normal(cc * _b[_cut2:_cons]-cc *mxb+cc * _b[eq1:evpro]*mevpro-cc * _b[eq1:evpro])- normal(cc * _b[_cut2:_cons]-cc *mxb +cc * _b[eq1:evpro]*mevpro) /// 
          -(normal(cc * _b[_cut1:_cons]-cc *mxb+cc * _b[eq1:evpro]*mevpro-cc * _b[eq1:evpro])-normal(cc * _b[_cut1:_cons]-cc *mxb +cc * _b[eq1:evpro]*mevpro)) 
scalar me_evpro_increase=-(normal(cc * _b[_cut2:_cons]-cc *mxb+cc * _b[eq1:evpro]*mevpro-cc * _b[eq1:evpro])-normal(cc * _b[_cut2:_cons]-cc *mxb +cc * _b[eq1:evpro]*mevpro)) 

scalar me_evpro_l1_decrease= normal(cc * _b[_cut1:_cons]-cc *mxb+cc * _b[eq1:evpro_l1]*mevpro_l1-cc * _b[eq1:evpro_l1])- normal(cc * _b[_cut1:_cons]-cc *mxb +cc * _b[eq1:evpro_l1]*mevpro_l1) 
scalar me_evpro_l1_nochange= normal(cc * _b[_cut2:_cons]-cc *mxb+cc * _b[eq1:evpro_l1]*mevpro_l1-cc * _b[eq1:evpro_l1])- normal(cc * _b[_cut2:_cons]-cc *mxb +cc * _b[eq1:evpro_l1]*mevpro_l1) /// 
          -(normal(cc * _b[_cut1:_cons]-cc *mxb+cc * _b[eq1:evpro_l1]*mevpro_l1-cc * _b[eq1:evpro_l1])-normal(cc * _b[_cut1:_cons]-cc *mxb +cc * _b[eq1:evpro_l1]*mevpro_l1)) 
scalar me_evpro_l1_increase=-(normal(cc * _b[_cut2:_cons]-cc *mxb+cc * _b[eq1:evpro_l1]*mevpro_l1-cc * _b[eq1:evpro_l1])-normal(cc * _b[_cut2:_cons]-cc *mxb +cc * _b[eq1:evpro_l1]*mevpro_l1)) 

scalar me_evpro_l2_decrease= normal(cc * _b[_cut1:_cons]-cc *mxb+cc * _b[eq1:evpro_l2]*mevpro_l2-cc * _b[eq1:evpro_l2])- normal(cc * _b[_cut1:_cons]-cc *mxb +cc * _b[eq1:evpro_l2]*mevpro_l2) 
scalar me_evpro_l2_nochange= normal(cc * _b[_cut2:_cons]-cc *mxb+cc * _b[eq1:evpro_l2]*mevpro_l2-cc * _b[eq1:evpro_l2])- normal(cc * _b[_cut2:_cons]-cc *mxb +cc * _b[eq1:evpro_l2]*mevpro_l2) /// 
          -(normal(cc * _b[_cut1:_cons]-cc *mxb+cc * _b[eq1:evpro_l2]*mevpro_l2-cc * _b[eq1:evpro_l2])-normal(cc * _b[_cut1:_cons]-cc *mxb +cc * _b[eq1:evpro_l2]*mevpro_l2)) 
scalar me_evpro_l2_increase=-(normal(cc * _b[_cut2:_cons]-cc *mxb+cc * _b[eq1:evpro_l2]*mevpro_l2-cc * _b[eq1:evpro_l2])-normal(cc * _b[_cut2:_cons]-cc *mxb +cc * _b[eq1:evpro_l2]*mevpro_l2)) 

scalar me_evpro_l3_decrease= normal(cc * _b[_cut1:_cons]-cc *mxb+cc * _b[eq1:evpro_l3]*mevpro_l3-cc * _b[eq1:evpro_l3])- normal(cc * _b[_cut1:_cons]-cc *mxb +cc * _b[eq1:evpro_l3]*mevpro_l3) 
scalar me_evpro_l3_nochange= normal(cc * _b[_cut2:_cons]-cc *mxb+cc * _b[eq1:evpro_l3]*mevpro_l3-cc * _b[eq1:evpro_l3])- normal(cc * _b[_cut2:_cons]-cc *mxb +cc * _b[eq1:evpro_l3]*mevpro_l3) /// 
          -(normal(cc * _b[_cut1:_cons]-cc *mxb+cc * _b[eq1:evpro_l3]*mevpro_l3-cc * _b[eq1:evpro_l3])-normal(cc * _b[_cut1:_cons]-cc *mxb +cc * _b[eq1:evpro_l3]*mevpro_l3)) 
scalar me_evpro_l3_increase=-(normal(cc * _b[_cut2:_cons]-cc *mxb+cc * _b[eq1:evpro_l3]*mevpro_l3-cc * _b[eq1:evpro_l3])-normal(cc * _b[_cut2:_cons]-cc *mxb +cc * _b[eq1:evpro_l3]*mevpro_l3)) 

scalar me_cum_evpro_l123_decrease= normal(cc * cc * _b[_cut1:_cons]-cc * cc *mxb+cc * cc * _b[eq1:cum_evpro_l123]*mcum_evpro_l123-cc * cc * _b[eq1:cum_evpro_l123])- normal(cc * cc * _b[_cut1:_cons]-cc * cc *mxb +cc * cc * _b[eq1:cum_evpro_l123]*mcum_evpro_l123) 
scalar me_cum_evpro_l123_nochange= normal(cc * cc * _b[_cut2:_cons]-cc * cc *mxb+cc * cc * _b[eq1:cum_evpro_l123]*mcum_evpro_l123-cc * cc * _b[eq1:cum_evpro_l123])- normal(cc * cc * _b[_cut2:_cons]-cc * cc *mxb +cc * cc * _b[eq1:cum_evpro_l123]*mcum_evpro_l123) /// 
          -(normal(cc * cc * _b[_cut1:_cons]-cc * cc *mxb+cc * cc * _b[eq1:cum_evpro_l123]*mcum_evpro_l123-cc * cc * _b[eq1:cum_evpro_l123])-normal(cc * cc * _b[_cut1:_cons]-cc * cc *mxb +cc * cc * _b[eq1:cum_evpro_l123]*mcum_evpro_l123)) 
scalar me_cum_evpro_l123_increase=-(normal(cc * cc * _b[_cut2:_cons]-cc * cc *mxb+cc * cc * _b[eq1:cum_evpro_l123]*mcum_evpro_l123-cc * cc * _b[eq1:cum_evpro_l123])-normal(cc * cc * _b[_cut2:_cons]-cc * cc *mxb +cc * cc * _b[eq1:cum_evpro_l123]*mcum_evpro_l123)) 


scalar me_isalmtot2_decrease= normal(cc * _b[_cut1:_cons]-cc *mxb+cc * _b[eq1:isalmtot2]*misalmtot2-cc * _b[eq1:isalmtot2])- normal(cc * _b[_cut1:_cons]-cc *mxb +cc * _b[eq1:isalmtot2]*misalmtot2) 
scalar me_isalmtot2_nochange= normal(cc * _b[_cut2:_cons]-cc *mxb+cc * _b[eq1:isalmtot2]*misalmtot2-cc * _b[eq1:isalmtot2])- normal(cc * _b[_cut2:_cons]-cc *mxb +cc * _b[eq1:isalmtot2]*misalmtot2) /// 
          -(normal(cc * _b[_cut1:_cons]-cc *mxb+cc * _b[eq1:isalmtot2]*misalmtot2-cc * _b[eq1:isalmtot2])-normal(cc * _b[_cut1:_cons]-cc *mxb +cc * _b[eq1:isalmtot2]*misalmtot2)) 
scalar me_isalmtot2_increase=-(normal(cc * _b[_cut2:_cons]-cc *mxb+cc * _b[eq1:isalmtot2]*misalmtot2-cc * _b[eq1:isalmtot2])-normal(cc * _b[_cut2:_cons]-cc *mxb +cc * _b[eq1:isalmtot2]*misalmtot2)) 

scalar me_isalmtot2_l1_decrease= normal(cc * _b[_cut1:_cons]-cc *mxb+cc * _b[eq1:isalmtot2_l1]*misalmtot2_l1-cc * _b[eq1:isalmtot2_l1])- normal(cc * _b[_cut1:_cons]-cc *mxb +cc * _b[eq1:isalmtot2_l1]*misalmtot2_l1) 
scalar me_isalmtot2_l1_nochange= normal(cc * _b[_cut2:_cons]-cc *mxb+cc * _b[eq1:isalmtot2_l1]*misalmtot2_l1-cc * _b[eq1:isalmtot2_l1])- normal(cc * _b[_cut2:_cons]-cc *mxb +cc * _b[eq1:isalmtot2_l1]*misalmtot2_l1) /// 
          -(normal(cc * _b[_cut1:_cons]-cc *mxb+cc * _b[eq1:isalmtot2_l1]*misalmtot2_l1-cc * _b[eq1:isalmtot2_l1])-normal(cc * _b[_cut1:_cons]-cc *mxb +cc * _b[eq1:isalmtot2_l1]*misalmtot2_l1)) 
scalar me_isalmtot2_l1_increase=-(normal(cc * _b[_cut2:_cons]-cc *mxb+cc * _b[eq1:isalmtot2_l1]*misalmtot2_l1-cc * _b[eq1:isalmtot2_l1])-normal(cc * _b[_cut2:_cons]-cc *mxb +cc * _b[eq1:isalmtot2_l1]*misalmtot2_l1)) 

scalar me_isalmtot2_l2_decrease= normal(cc * _b[_cut1:_cons]-cc *mxb+cc * _b[eq1:isalmtot2_l2]*misalmtot2_l2-cc * _b[eq1:isalmtot2_l2])- normal(cc * _b[_cut1:_cons]-cc *mxb +cc * _b[eq1:isalmtot2_l2]*misalmtot2_l2) 
scalar me_isalmtot2_l2_nochange= normal(cc * _b[_cut2:_cons]-cc *mxb+cc * _b[eq1:isalmtot2_l2]*misalmtot2_l2-cc * _b[eq1:isalmtot2_l2])- normal(cc * _b[_cut2:_cons]-cc *mxb +cc * _b[eq1:isalmtot2_l2]*misalmtot2_l2) /// 
          -(normal(cc * _b[_cut1:_cons]-cc *mxb+cc * _b[eq1:isalmtot2_l2]*misalmtot2_l2-cc * _b[eq1:isalmtot2_l2])-normal(cc * _b[_cut1:_cons]-cc *mxb +cc * _b[eq1:isalmtot2_l2]*misalmtot2_l2)) 
scalar me_isalmtot2_l2_increase=-(normal(cc * _b[_cut2:_cons]-cc *mxb+cc * _b[eq1:isalmtot2_l2]*misalmtot2_l2-cc * _b[eq1:isalmtot2_l2])-normal(cc * _b[_cut2:_cons]-cc *mxb +cc * _b[eq1:isalmtot2_l2]*misalmtot2_l2)) 

scalar me_isalmtot2_l3_decrease= normal(cc * _b[_cut1:_cons]-cc *mxb+cc * _b[eq1:isalmtot2_l3]*misalmtot2_l3-cc * _b[eq1:isalmtot2_l3])- normal(cc * _b[_cut1:_cons]-cc *mxb +cc * _b[eq1:isalmtot2_l3]*misalmtot2_l3) 
scalar me_isalmtot2_l3_nochange= normal(cc * _b[_cut2:_cons]-cc *mxb+cc * _b[eq1:isalmtot2_l3]*misalmtot2_l3-cc * _b[eq1:isalmtot2_l3])- normal(cc * _b[_cut2:_cons]-cc *mxb +cc * _b[eq1:isalmtot2_l3]*misalmtot2_l3) /// 
          -(normal(cc * _b[_cut1:_cons]-cc *mxb+cc * _b[eq1:isalmtot2_l3]*misalmtot2_l3-cc * _b[eq1:isalmtot2_l3])-normal(cc * _b[_cut1:_cons]-cc *mxb +cc * _b[eq1:isalmtot2_l3]*misalmtot2_l3)) 
scalar me_isalmtot2_l3_increase=-(normal(cc * _b[_cut2:_cons]-cc *mxb+cc * _b[eq1:isalmtot2_l3]*misalmtot2_l3-cc * _b[eq1:isalmtot2_l3])-normal(cc * _b[_cut2:_cons]-cc *mxb +cc * _b[eq1:isalmtot2_l3]*misalmtot2_l3)) 

scalar me_cum_isalmtot_l123_decrease= normal(cc * cc * _b[_cut1:_cons]-cc * cc *mxb+cc * cc * _b[eq1:cum_isalmtot_l123]*mcum_isalmtot_l123-cc * cc * _b[eq1:cum_isalmtot_l123])- normal(cc * cc * _b[_cut1:_cons]-cc * cc *mxb +cc * cc * _b[eq1:cum_isalmtot_l123]*mcum_isalmtot_l123) 
scalar me_cum_isalmtot_l123_nochange= normal(cc * cc * _b[_cut2:_cons]-cc * cc *mxb+cc * cc * _b[eq1:cum_isalmtot_l123]*mcum_isalmtot_l123-cc * cc * _b[eq1:cum_isalmtot_l123])- normal(cc * cc * _b[_cut2:_cons]-cc * cc *mxb +cc * cc * _b[eq1:cum_isalmtot_l123]*mcum_isalmtot_l123) /// 
          -(normal(cc * cc * _b[_cut1:_cons]-cc * cc *mxb+cc * cc * _b[eq1:cum_isalmtot_l123]*mcum_isalmtot_l123-cc * cc * _b[eq1:cum_isalmtot_l123])-normal(cc * cc * _b[_cut1:_cons]-cc * cc *mxb +cc * cc * _b[eq1:cum_isalmtot_l123]*mcum_isalmtot_l123)) 
scalar me_cum_isalmtot_l123_increase=-(normal(cc * cc * _b[_cut2:_cons]-cc * cc *mxb+cc * cc * _b[eq1:cum_isalmtot_l123]*mcum_isalmtot_l123-cc * cc * _b[eq1:cum_isalmtot_l123])-normal(cc * cc * _b[_cut2:_cons]-cc * cc *mxb +cc * cc * _b[eq1:cum_isalmtot_l123]*mcum_isalmtot_l123)) 

scalar me_txipp2_decrease= normal(cc * _b[_cut1:_cons]-cc *mxb+cc * _b[eq1:txipp2]*mtxipp2-cc * _b[eq1:txipp2])- normal(cc * _b[_cut1:_cons]-cc *mxb +cc * _b[eq1:txipp2]*mtxipp2) 
scalar me_txipp2_nochange= normal(cc * _b[_cut2:_cons]-cc *mxb+cc * _b[eq1:txipp2]*mtxipp2-cc * _b[eq1:txipp2])- normal(cc * _b[_cut2:_cons]-cc *mxb +cc * _b[eq1:txipp2]*mtxipp2) /// 
          -(normal(cc * _b[_cut1:_cons]-cc *mxb+cc * _b[eq1:txipp2]*mtxipp2-cc * _b[eq1:txipp2])-normal(cc * _b[_cut1:_cons]-cc *mxb +cc * _b[eq1:txipp2]*mtxipp2)) 
scalar me_txipp2_increase=-(normal(cc * _b[_cut2:_cons]-cc *mxb+cc * _b[eq1:txipp2]*mtxipp2-cc * _b[eq1:txipp2])-normal(cc * _b[_cut2:_cons]-cc *mxb +cc * _b[eq1:txipp2]*mtxipp2)) 

scalar me_txipp2_l1_decrease= normal(cc * _b[_cut1:_cons]-cc *mxb+cc * _b[eq1:txipp2_l1]*mtxipp2_l1-cc * _b[eq1:txipp2_l1])- normal(cc * _b[_cut1:_cons]-cc *mxb +cc * _b[eq1:txipp2_l1]*mtxipp2_l1) 
scalar me_txipp2_l1_nochange= normal(cc * _b[_cut2:_cons]-cc *mxb+cc * _b[eq1:txipp2_l1]*mtxipp2_l1-cc * _b[eq1:txipp2_l1])- normal(cc * _b[_cut2:_cons]-cc *mxb +cc * _b[eq1:txipp2_l1]*mtxipp2_l1) /// 
          -(normal(cc * _b[_cut1:_cons]-cc *mxb+cc * _b[eq1:txipp2_l1]*mtxipp2_l1-cc * _b[eq1:txipp2_l1])-normal(cc * _b[_cut1:_cons]-cc *mxb +cc * _b[eq1:txipp2_l1]*mtxipp2_l1)) 
scalar me_txipp2_l1_increase=-(normal(cc * _b[_cut2:_cons]-cc *mxb+cc * _b[eq1:txipp2_l1]*mtxipp2_l1-cc * _b[eq1:txipp2_l1])-normal(cc * _b[_cut2:_cons]-cc *mxb +cc * _b[eq1:txipp2_l1]*mtxipp2_l1)) 

scalar me_txipp2_l2_decrease= normal(cc * _b[_cut1:_cons]-cc *mxb+cc * _b[eq1:txipp2_l2]*mtxipp2_l2-cc * _b[eq1:txipp2_l2])- normal(cc * _b[_cut1:_cons]-cc *mxb +cc * _b[eq1:txipp2_l2]*mtxipp2_l2) 
scalar me_txipp2_l2_nochange= normal(cc * _b[_cut2:_cons]-cc *mxb+cc * _b[eq1:txipp2_l2]*mtxipp2_l2-cc * _b[eq1:txipp2_l2])- normal(cc * _b[_cut2:_cons]-cc *mxb +cc * _b[eq1:txipp2_l2]*mtxipp2_l2) /// 
          -(normal(cc * _b[_cut1:_cons]-cc *mxb+cc * _b[eq1:txipp2_l2]*mtxipp2_l2-cc * _b[eq1:txipp2_l2])-normal(cc * _b[_cut1:_cons]-cc *mxb +cc * _b[eq1:txipp2_l2]*mtxipp2_l2)) 
scalar me_txipp2_l2_increase=-(normal(cc * _b[_cut2:_cons]-cc *mxb+cc * _b[eq1:txipp2_l2]*mtxipp2_l2-cc * _b[eq1:txipp2_l2])-normal(cc * _b[_cut2:_cons]-cc *mxb +cc * _b[eq1:txipp2_l2]*mtxipp2_l2)) 

scalar me_txipp2_l3_decrease= normal(cc * _b[_cut1:_cons]-cc *mxb+cc * _b[eq1:txipp2_l3]*mtxipp2_l3-cc * _b[eq1:txipp2_l3])- normal(cc * _b[_cut1:_cons]-cc *mxb +cc * _b[eq1:txipp2_l3]*mtxipp2_l3) 
scalar me_txipp2_l3_nochange= normal(cc * _b[_cut2:_cons]-cc *mxb+cc * _b[eq1:txipp2_l3]*mtxipp2_l3-cc * _b[eq1:txipp2_l3])- normal(cc * _b[_cut2:_cons]-cc *mxb +cc * _b[eq1:txipp2_l3]*mtxipp2_l3) /// 
          -(normal(cc * _b[_cut1:_cons]-cc *mxb+cc * _b[eq1:txipp2_l3]*mtxipp2_l3-cc * _b[eq1:txipp2_l3])-normal(cc * _b[_cut1:_cons]-cc *mxb +cc * _b[eq1:txipp2_l3]*mtxipp2_l3)) 
scalar me_txipp2_l3_increase=-(normal(cc * _b[_cut2:_cons]-cc *mxb+cc * _b[eq1:txipp2_l3]*mtxipp2_l3-cc * _b[eq1:txipp2_l3])-normal(cc * _b[_cut2:_cons]-cc *mxb +cc * _b[eq1:txipp2_l3]*mtxipp2_l3)) 

scalar me_cum_ipp2_l123_decrease= normal(cc * cc * _b[_cut1:_cons]-cc * cc *mxb+cc * cc * _b[eq1:cum_ipp2_l123]*mcum_ipp2_l123-cc * cc * _b[eq1:cum_ipp2_l123])- normal(cc * cc * _b[_cut1:_cons]-cc * cc *mxb +cc * cc * _b[eq1:cum_ipp2_l123]*mcum_ipp2_l123) 
scalar me_cum_ipp2_l123_nochange= normal(cc * cc * _b[_cut2:_cons]-cc * cc *mxb+cc * cc * _b[eq1:cum_ipp2_l123]*mcum_ipp2_l123-cc * cc * _b[eq1:cum_ipp2_l123])- normal(cc * cc * _b[_cut2:_cons]-cc * cc *mxb +cc * cc * _b[eq1:cum_ipp2_l123]*mcum_ipp2_l123) /// 
          -(normal(cc * cc * _b[_cut1:_cons]-cc * cc *mxb+cc * cc * _b[eq1:cum_ipp2_l123]*mcum_ipp2_l123-cc * cc * _b[eq1:cum_ipp2_l123])-normal(cc * cc * _b[_cut1:_cons]-cc * cc *mxb +cc * cc * _b[eq1:cum_ipp2_l123]*mcum_ipp2_l123)) 
scalar me_cum_ipp2_l123_increase=-(normal(cc * cc * _b[_cut2:_cons]-cc * cc *mxb+cc * cc * _b[eq1:cum_ipp2_l123]*mcum_ipp2_l123-cc * cc * _b[eq1:cum_ipp2_l123])-normal(cc * cc * _b[_cut2:_cons]-cc * cc *mxb +cc * cc * _b[eq1:cum_ipp2_l123]*mcum_ipp2_l123)) 

/** impact of VAT changes and Euro cash changeover (Ref. = 0) **/
scalar me_tva_2000_decrease= normal( cc * _b[_cut1:_cons]- cc *mxb+ cc * _b[eq1:tva_2000]*mtva_2000- cc * _b[eq1:tva_2000])- normal( cc * _b[_cut1:_cons]- cc *mxb + cc * _b[eq1:tva_2000]*mtva_2000) 
scalar me_tva_2000_nochange= normal( cc * _b[_cut2:_cons]- cc *mxb+ cc * _b[eq1:tva_2000]*mtva_2000- cc * _b[eq1:tva_2000])- normal( cc * _b[_cut2:_cons]- cc *mxb + cc * _b[eq1:tva_2000]*mtva_2000) /// 
          -(normal( cc * _b[_cut1:_cons]- cc *mxb+ cc * _b[eq1:tva_2000]*mtva_2000- cc * _b[eq1:tva_2000])-normal( cc * _b[_cut1:_cons]- cc *mxb + cc * _b[eq1:tva_2000]*mtva_2000)) 
scalar me_tva_2000_increase=-(normal( cc * _b[_cut2:_cons]- cc *mxb+ cc * _b[eq1:tva_2000]*mtva_2000- cc * _b[eq1:tva_2000])-normal( cc * _b[_cut2:_cons]- cc *mxb + cc * _b[eq1:tva_2000]*mtva_2000)) 

scalar me_tva_2000_2_decrease= normal( cc * _b[_cut1:_cons]- cc *mxb+ cc * _b[eq1:tva_2000_2]*mtva_2000_2- cc * _b[eq1:tva_2000_2])- normal( cc * _b[_cut1:_cons]- cc *mxb + cc * _b[eq1:tva_2000_2]*mtva_2000_2) 
scalar me_tva_2000_2_nochange= normal( cc * _b[_cut2:_cons]- cc *mxb+ cc * _b[eq1:tva_2000_2]*mtva_2000_2- cc * _b[eq1:tva_2000_2])- normal( cc * _b[_cut2:_cons]- cc *mxb + cc * _b[eq1:tva_2000_2]*mtva_2000_2) /// 
          -(normal( cc * _b[_cut1:_cons]- cc *mxb+ cc * _b[eq1:tva_2000_2]*mtva_2000_2- cc * _b[eq1:tva_2000_2])-normal( cc * _b[_cut1:_cons]- cc *mxb + cc * _b[eq1:tva_2000_2]*mtva_2000_2)) 
scalar me_tva_2000_2_increase=-(normal( cc * _b[_cut2:_cons]- cc *mxb+ cc * _b[eq1:tva_2000_2]*mtva_2000_2- cc * _b[eq1:tva_2000_2])-normal( cc * _b[_cut2:_cons]- cc *mxb + cc * _b[eq1:tva_2000_2]*mtva_2000_2)) 

scalar me_euro_2002_decrease= normal( cc * _b[_cut1:_cons]- cc *mxb+ cc * _b[eq1:euro_2002]*meuro_2002- cc * _b[eq1:euro_2002])- normal( cc * _b[_cut1:_cons]- cc *mxb + cc * _b[eq1:euro_2002]*meuro_2002) 
scalar me_euro_2002_nochange= normal( cc * _b[_cut2:_cons]- cc *mxb+ cc * _b[eq1:euro_2002]*meuro_2002- cc * _b[eq1:euro_2002])- normal( cc * _b[_cut2:_cons]- cc *mxb + cc * _b[eq1:euro_2002]*meuro_2002) /// 
          -(normal( cc * _b[_cut1:_cons]- cc *mxb+ cc * _b[eq1:euro_2002]*meuro_2002- cc * _b[eq1:euro_2002])-normal( cc * _b[_cut1:_cons]- cc *mxb + cc * _b[eq1:euro_2002]*meuro_2002)) 
scalar me_euro_2002_increase=-(normal( cc * _b[_cut2:_cons]- cc *mxb+ cc * _b[eq1:euro_2002]*meuro_2002- cc * _b[eq1:euro_2002])-normal( cc * _b[_cut2:_cons]- cc *mxb + cc * _b[eq1:euro_2002]*meuro_2002)) 

scalar me_euro_2002_2_decrease= normal( cc * _b[_cut1:_cons]- cc *mxb+ cc * _b[eq1:euro_2002_2]*meuro_2002_2- cc * _b[eq1:euro_2002_2])- normal( cc * _b[_cut1:_cons]- cc *mxb + cc * _b[eq1:euro_2002_2]*meuro_2002_2) 
scalar me_euro_2002_2_nochange= normal( cc * _b[_cut2:_cons]- cc *mxb+ cc * _b[eq1:euro_2002_2]*meuro_2002_2- cc * _b[eq1:euro_2002_2])- normal( cc * _b[_cut2:_cons]- cc *mxb + cc * _b[eq1:euro_2002_2]*meuro_2002_2) /// 
          -(normal( cc * _b[_cut1:_cons]- cc *mxb+ cc * _b[eq1:euro_2002_2]*meuro_2002_2- cc * _b[eq1:euro_2002_2])-normal( cc * _b[_cut1:_cons]- cc *mxb + cc * _b[eq1:euro_2002_2]*meuro_2002_2)) 
scalar me_euro_2002_2_increase=-(normal( cc * _b[_cut2:_cons]- cc *mxb+ cc * _b[eq1:euro_2002_2]*meuro_2002_2- cc * _b[eq1:euro_2002_2])-normal( cc * _b[_cut2:_cons]- cc *mxb + cc * _b[eq1:euro_2002_2]*meuro_2002_2)) 


scalar list me_evprmp_decrease     me_evprmp_l1_decrease     me_evprmp_l2_decrease     me_evprmp_l3_decrease      me_cum_isalmtot_l123_decrease  ///
               me_isalmtot2_decrease  me_isalmtot2_l1_decrease  me_isalmtot2_l2_decrease  me_isalmtot2_l3_decrease   me_cum_isalmtot_l123_decrease  ///
               me_evpro_decrease      me_evpro_l1_decrease      me_evpro_l2_decrease      me_evpro_l3_decrease       me_cum_evpro_l123_decrease  ///
               me_txipp2_decrease     me_txipp2_l1_decrease     me_txipp2_l2_decrease     me_txipp2_l3_decrease      me_cum_ipp2_l123_decrease   ///
               me_tva_2000_decrease   me_tva_2000_2_decrease    me_euro_2002_decrease     me_euro_2002_2_decrease  

 
scalar list me_evprmp_increase     me_evprmp_l1_increase     me_evprmp_l2_increase     me_evprmp_l3_increase      me_cum_isalmtot_l123_increase  ///
               me_isalmtot2_increase  me_isalmtot2_l1_increase  me_isalmtot2_l2_increase  me_isalmtot2_l3_increase   me_cum_isalmtot_l123_increase  ///
               me_evpro_increase      me_evpro_l1_increase      me_evpro_l2_increase      me_evpro_l3_increase       me_cum_evpro_l123_increase  ///
               me_txipp2_increase     me_txipp2_l1_increase     me_txipp2_l2_increase     me_txipp2_l3_increase      me_cum_ipp2_l123_increase   ///
               me_tva_2000_increase   me_tva_2000_2_increase    me_euro_2002_increase     me_euro_2002_2_increase  
















 
