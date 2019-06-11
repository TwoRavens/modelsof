/*********************************************/
/* Do file to replicate:                     */
/* "The Arc of Modernization: Economic       */
/* Structure, Materialism, and the           */
/* Onset of Civil Conflict"                  */
/*                                           */
/* J. Tyson Chatagnier and Emanuele Castelli */
/*                                           */
/* Forthcoming in Political Science Research */
/* and Methods                               */
/*                                           */
/* File created 31 March 2016                */
/*********************************************/

clear all

version 11

log using "sppo_log.smcl", replace

/* Nieman's Strategic Probit with Partial Observability estimator */

#delimit;
program define sppo_lf, rclass;
  
  args lnf r_det r_war r_acq g_war;             
  tempvar pun chal;
    quietly gen double `pun' = normal(`g_war'/sqrt(2));     
    quietly gen double `chal' = normal((`pun'*`r_war' + (1-`pun')*`r_acq'-`r_det')/(sqrt(`pun'^2+ (1-`pun')^2+1))); 
  quietly replace `lnf' = ln((1-`chal')+(`chal')*(1-`pun')) if $ML_y1==0;             
  quietly replace `lnf' = ln((`chal')*(`pun')) if $ML_y1==1;
end;

/* Read in data */

use "cw_replication_data.dta", clear;

/* Run second-stage model to find initial conditions */ 

probit onset mod oil gdp p2 pop sixties seventies eighties;

matrix B2 = e(b);

predict pr;

gen prT = normal(pr);

/* Run first-stage model to find initial conditions */

gen Nmod = -mod;
gen Nmat = -mat;
gen Noil = -oil;
gen N60 = -sixties;
gen N70 = -seventies;
gen N80 = -eighties;
gen Ngdp = -gdp;
gen Ngrowth = -growth;
gen Npolity = -polity;
gen Np2 = -p2;
gen Ncons_11 = -1;
gen Tpop = prT*pop; 
gen Tmtn = prT*mtn;
gen Tef = prT*ef;
gen Tpar = prT*parity;

probit onset Nmod Nmat Noil N60 N70 N80 Ngdp Ngrowth Npolity Np2 Ncons_11 Tpop Tmtn Tef Tpar, nocons;

matrix B1 = e(b);

/* Maximize the SPPO model */
/* This gives results in Table 2 */

ml model lf sppo_lf 
  (R_SQ:onset = mod mat oil sixties seventies eighties gdp growth polity p2) 
  (R_War:onset =  pop mtn ef parity, nocons)
  (R_Acq: onset =)
  (G_War:onset = mod oil gdp p2 pop sixties seventies eighties);
ml check;
ml init B1 0 B2 , copy ;
ml maximize,  diff;

/* Save results to .txt files, for use with substantive replication */

matrix b = e(b);
matrix v = e(V);

mat2txt, matrix(b) saving("sppo_coefs_final.txt") replace;
mat2txt, matrix(v) saving("sppo_vcov_final.txt") replace;

log close;