
use ForeignPresence&ETCs.dta, clear

********************************************************************************
******************Table 3 (MLMs) in the Main Text*******************************
********************************************************************************
#delimit ;
macro define covars1 "soe collective private foreign_NonHMT foreign_HMT revenue 
lemp sales_otherprov govtsales soesales relationship licenses marketsize 
growthrate last_intensity lscale mgovthelp mtaxrate lgdpper2003 gdp2003 lpop2003";
#delimit cr


**first stage regression
reg MNC lwdist lgdpper2003 gdp2003 lpop2003 if dup_prov_first==1
** generate predicted values of MNC activity
predict MNC_hat, xb

**Second Stage Regressions (SEs Bootstrapped)
***Model 1
#delimit ;
bootstrap _b, strata(prov_ind) rep(1000) seed(977060) reject(e(converged)==0): 
mixed letcs MNC_hat $covars1 ||provinceid: ||indcode2:, iterate(20);

***Model 2
#delimit ;
bootstrap _b, strata(prov_ind) rep(1000) seed(977060) reject(e(converged)==0):
mixed letcs MNC_hat $covars1 lceopay ||provinceid: ||indcode2:, iterate(20); 

***Model 3
#delimit ;
bootstrap _b, strata(prov_ind) rep(1000) seed(977060) reject(e(converged)==0): 
mixed letcs MNC_hat $covars1 interaction ||provinceid: ||indcode2:, iterate(20); 

***Model 4
#delimit ;
bootstrap _b, strata(prov_ind) rep(1000) seed(977060) reject(e(converged)==0):
mixed letcs MNC_hat $covars1 gm_govt ||provinceid: ||indcode2:, iterate(20) ;


********************************************************************************
*********************Table 4 (Mediation Analysis) in the Main Text**************
********************************************************************************
#delimit ;
macro define covars2 "marketsize growthrate last_intensity lscale mgovthelp 
mtaxrate lgdpper2003 gdp2003 lpop2003 " ;
#delimit cr

*Note: Some results are omitted in the main text for space considerations. The 
*full results are reported in Table B in Supporting Information. Models 1-6 in 
*Table 4 correspond to Models 1, 3, 4, 6, 8, & 9 in Table B, respectively.

*Model 1
mixed  w_con_pdc4 foreign_output $covars2 ||province: if dup_ind_first==1
*Model 2
mixed letcs foreign_output $covars1 ||province: ||indcode2: 
*Model 3
mixed letcs  w_con_pdc4 foreign_output $covars1 ||province: ||indcode2:
*Model 4
mixed w_con_pdc4 NonHMT HMT $covars2 ||province: if dup_ind_first==1
*Model 5
mixed letcs NonHMT HMT $covars1 ||province: ||indcode2:
*Model 6
mixed letcs w_con_pdc4 NonHMT HMT $covars1 ||province: ||indcode2:





