*** Uses first filter: complete balanced sample **

** Seminnual observations, local currency **

** Part 3

//      =============================     Pesaran (2006, Econometrica) CCEMG , CCEP and IRF, VD  (based on Cholesky Decp.)    ===============================
//
//        The purposes of this program are:  (1) compute CCEP estimators of a 3 variables ECM model;  (2) construct the IRF of different shocks  (3) variance Decomposition
//
//                                                                CCEP is the  estiamtor of Pesaran (2006, Econometrica)
//                                                                IRF  and VD are constructed based on Cholesky decomposition
//     
//      VECM(1) Model:   ds(ij, t)_k = a1(ij)_k + b(ij)_k*q(ij,t-1)_k +bb(ij)_a*q(ij,t-1)+ b1(ij)_k*ds(ij,t-1)_k +b2(ij)_k*dp(ij,t-1)_k+b3(ij)_k*dp(ij,t-1)+ ea(ij,t)_k.           ij=1,...,N; k=1,,,,K;  t=1,...,T.
//                                      dp(ij, t)_k = a2(ij)_k + c(ij)_k*q(ij,t-1)_k +cc(ij)_a*q(ij,t-1)+ c1(ij)_k*ds(ij,t-1)_k +c2(ij)_k*dp(ij,t-1)_k+c3(ij)_k*dp(ij,t-1)+ ea(ij,t)_k.           ij=1,...,N; k=1,,,,K;  t=1,...,T.
//                                       dp(ij, t) = a3(ij)_k + d(ij)_k*q(ij,t-1)_k +dd(ij)_a*q(ij,t-1)+ d1(ij)_k*ds(ij,t-1)_k +d2(ij)_k*dp(ij,t-1)_k+d3(ij)_k*dp(ij,t-1)+ ea(ij,t)_k.              ij=1,...,N; k=1,,,,K;  t=1,...,T.
// 
//
//      Regression equation:      ds(ij, t)_k = a1(ij)_k + b(ij)_k*q(ij,t-1)_k +bb(ij)_a*q(ij,t-1)+ b1(ij)_k*ds(ij,t-1)_k +b2(ij)_k*dp(ij,t-1)_k+b3(ij)_k*dp(ij,t-1)+ 
//                                                                 +g1(ij)_k*ds_bar(t)_k + g2(ij)_k*q_bar(t-1)_k+ g3(ij)_k*ds_bar(t-1)_k +  g4(ij)_k*dp_bar(t-1)_k + g5(ij)_k*q_bar(t-1)+  g6(ij)_k*dp_bar(t-1) +va(ij,t)_k   
//                                             dp(ij, t)_k = a2(ij)_k + c(ij)_k*q(ij,t-1)_k +cc(ij)_a*q(ij,t-1)+ c1(ij)_k*ds(ij,t-1)_k +c2(ij)_k*dp(ij,t-1)_k+c3(ij)_k*dp(ij,t-1)+ 
//                                                                 +h1(ij)_k*dp_bar(t)_k + h2(ij)_k*q_bar(t-1)_k+ h3(ij)_k*ds_bar(t-1)_k +  h4(ij)_k*dp_bar(t-1)_k + h5(ij)_k*q_bar(t-1)+  h6(ij)_k*dp_bar(t-1) +va(ij,t)_k   
//                                             dp(ij, t) = a3(ij)_k + d(ij)_k*q(ij,t-1)_k +dd(ij)_a*q(ij,t-1)+ d1(ij)_k*ds(ij,t-1)_k +d2(ij)_k*dp(ij,t-1)_k+d3(ij)_k*dp(ij,t-1)+ 
//                                                                 +j1(ij)_k*dp_bar(t)+ j2(ij)_k*q_bar(t-1)+ j3(ij)_k*ds_bar(t-1)_k +  j4(ij)_k*dp_bar(t-1)_k + j5(ij)_k*q_bar(t-1)+  j6(ij)_k*dp_bar(t-1) +va(ij,t)_k   
//
//                                              where s_k, p_k and q_k are nominal exchange rate, price differential and real exchange rate for commodity k. respectively.
//                                                          p and q are aggregate price differential and real exchange rate. respectively.
//
//      NOTE:
//                       (1) the original order of the variables is ek, pk, p and it is now (ek, p, pk)
//                       (2) if you want to change the order then you also need to change the following part of the program
//                             The order of variables is now (ek, p, pk) 
//                                    (a)
//                                           *****   Let Y=(ek, p, pk) then the Y varaibale in the above VECM model in vector form must have the same order on both sides.  
//                                                       This means that the regressors on the right hand side of the fist equation must be  de(ij,t-1)_k, dp(ij,t-1) and dp(ij,t-1)_k.  (This is important and do not forget to change the order ) .  
//                                                        Do the same changes for the second and third equations
//
//                                    (b) you need to change the following codes:
//                                                 matrix coeff_`k'=(bp1',bp2',bp3',vc[1,1],vc[2,2],vc[3,3],vc[2,1],vc[3,1],vc[3,2])'       -----  order  (ek, pk, p)
//                                                          
//                                                 matrix coeff_`k'=(bp1[1,1],bp1[2,1],bp1[3,1],bp1[5,1],bp1[4,1],bp3[1,1],bp3[2,1],bp3[3,1],bp3[5,1],bp3[4,1],bp2[1,1],bp2[2,1],bp2[3,1],bp2[5,1],bp2[4,1],vc[1,1],vc[3,3],vc[2,2],vc[3,1],vc[2,1],vc[3,2])'      
//                                                                                                                                                                                ------ order  (ek, p, pk)
//                                   (c) change the definition of beta 
//                                                                 beta=(1,1)\(-1,0)\(0,-1)          --------    order (ek, pk, p)
//                                                                 beta=(1, 1)\(0,-1)\(-1, 0)       --------    order (ek, p, pk)
//                                   (d)  girff[.,(vars+1)]=girff[.,1]-girff[.,2]     --- qk response if the order is (ek, pk, p) ;           girff[.,(vars+2)]=girff[.,1]-girff[.,3]     --- q response if the order is (ek, pk, p)
//                                                       girff[.,(vars+1)]=girff[.,1]-girff[.,3]     --- qk response if the order is (ek, p, pk) ;           girff[.,(vars+2)]=girff[.,1]-girff[.,2]     --- q response if the order is (ek, p, pk)
//                                   (e)  st_store(.,st_addvar("double", ("girff_ek","girff_pk","girff_p","girff_q","girff_qk")),xxx)    --------  order (ek, pk, p)
//                                         st_store(.,st_addvar("double", ("girff_ek","girff_p","girff_pk","girff_q","girff_qk")),xxx)    --------  order (ek, p, pk)
//                                   (f)  the following codes are under the order (ek, p, pk).  If the order is changed then you need to change the "definition"  in the following codes
//
//                                               "Variance Decomposition is explained by: ek, p and pk"
//                                                 VD 
//                                                 st_store(.,st_addvar("double", ("VD_ek","VD_p","VD_pk")),VD)    // Variance Decomposition:  explained by: e, p and pk 
// 
//                                                 end
//                                                 if (`shock'==1){
//                                                 line girff_e girff_p girff_pk girff_q girff_qk horizon,saving(girff, replace)  xlabel(0(20)`h') ytitle("Response to an E Shock") legend(c(1))  
//                                                 }
//                                                else if (`shock'==2){
//                                                line girff_e girff_p girff_pk girff_q girff_qk horizon,saving(girff, replace)  xlabel(0(20)`h') ytitle("Response to an P Shock") legend(c(1))  
//                                                }
//                                                 else if (`shock'==3){
//                                                 line girff_e girff_p girff_pk girff_q girff_qk horizon,saving(girff, replace)  xlabel(0(20)`h') ytitle("Response to an Pk Shock") legend(c(1))  
//                                                 }
//     
//      Software:  STAT
//      Provider:  Jyh-Lin Wu 
//     =============================================================================================================
// Program modified by Andy Cohn, April 2009
//   3_var_CCEP estimates

*** Note: this file uses the Indust cutdown sample: i.e. (industrial country)/(US) pairs
*** This program runs a variant of the estimation file wherein the qks are replaced by qk-Q
*** i.e. demeaned by pair average price differential

matrix drop _all
clear
clear results
clear mata
capture log close
set more off
set mem 700m
set varabbrev off




local programpath "P:\BerginGlickWu Replication\Figures 1-5\programs"
local outpath1 "P:\BerginGlickWu Replication\Figures 1-5\results"
local datapath "P:\BerginGlickWu Replication\data_creation\datasets"

global datasetPWT "semiannual_lc_newPT3_PWT_f1_wide_indust.dta"


/* Load the relevant variables of the datasets by product type, run the regresssions, 
   store the results in matrix, then open up the next product dataset.
*/
capture program drop _all

cd "`programpath'"
set maxvar 30000
set matsize 5000

local tsobs = 35
local numgoods = 101
local numpairs = 20
local nirp = 40
**************************************************
*						 *
****************** Traded Goods ******************
*						 *
**************************************************



*
************* Seminnual - Traded - PW - Filter 1 ************
*

local filename "ecm_newPT3_semiannual_PW_f1_indust.csv"
local irfcoeffs "irfcoeffs_semiannual_PW_f1_indust.dta"

matrix avg_stat1_ = J(101,47,.)
matrix avg_stat2_ = J(101,47,.)

	use "`datapath'/$datasetPWT", clear
	ccep_semiannual_ecm_newPT3, group(`numpairs') goods(`numgoods') nirp(`nirp') tsobs(`tsobs')

	preserve
	drop irf_*
	outsheet using "$outPath1/`filename'", comma replace
	restore
	
	keep irf_*
	save "`datapath'/`irfcoeffs'", replace
		*Can't use normal IRF files to calculate: have qk-Q instead of q, this changes the cointegration
	capture set obs `nirp'
	gen paramater = .
	replace paramater = `nirp' 		in 2
	forvalues j=1/`numgoods' {
		di "Calculating impulse responses for good `j'"
		quietly irf_newPT3_cvd_v2, good(`j') nirp(`nirp') 
	 
	}
	save "`datapath'/`irfcoeffs'", replace
	

capture log close

exit


