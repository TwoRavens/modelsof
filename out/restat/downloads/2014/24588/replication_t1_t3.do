#delimit ;
clear;
set mem 700m;
set more off;
set matsize 800;
capture log close;
log using replication_t1_t3.log, replace;

use replicationdata_t1-t3.dta, clear;

gen des2000_1999 = des2000*ano1999;
gen des2000_2000 = des2000*ano2000;
gen des2000_2001 = des2000*ano2001;
gen des2000_2002 = des2000*ano2002;
gen des2000_2003 = des2000*ano2003;

gen des1999_1999 = des1999*ano1999;
gen des1999_2000 = des1999*ano2000;
gen des1999_2001 = des1999*ano2001;
gen des1999_2002 = des1999*ano2002;
gen des1999_2003 = des1999*ano2003;

gen dropout00 = des1999==0 &des2000==0;
gen dropout01 = des1999==0 &des2000==1;
gen dropout10 = des1999==1 &des2000==0;
gen dropout11 = des1999==1 &des2000==1;

quietly foreach var of varlist dropout00 dropout10 dropout01 dropout11 {;
 gen `var'_1999 = `var'*ano1999;
 gen `var'_2000 = `var'*ano2000;
 gen `var'_2001 = `var'*ano2001;
 gen `var'_2002 = `var'*ano2002;
 gen `var'_2003 = `var'*ano2003;
};


gen fimpact = .;
gen fse = .;
gen ftest=.;
gen u_i = .;
forvalues x=1/258 {;
   *capture reg desistiu be_ano2000 bolsa ano2000-ano2003 if idmuni==`x'&ano<=2000, robust;
   *capture xtreg desistiu be_ano2000 ano2000 des1999_1999 if idmuni==`x'&ano<=2000, robust fe i(id);
   capture xtreg desistiu be_ano2000 ano2000 if idmuni==`x'&ano<=2000, robust fe i(id);
   capture predict ui if idmuni==`x', u;
   capture replace u_i =ui if idmuni==`x';
   capture drop ui;
   capture replace fimpact = _b[be_ano2000] if idmuni==`x';
   capture replace fse = _se[be_ano2000] if idmuni==`x';
   capture replace ftest = abs(fimpact/fse);
   disp `x';
};


*******************************************;
*  Table 1
*******************************************;
areg desistiu  bolsa be_ano2000- be_ano2003  ano2000- ano2003 des2000_* des1999_*  if nid>=3, rob abs(id);
 gen esample1 = e(sample);
reg desistiu  bolsa be_ano2000- be_ano2003  ano2000- ano2003 if esample1==1, rob;
 table ano bolsa if esample1==1, c(mean desistiu );

 *************************************************;
***               TABLE 3                    ****;
*************************************************;

areg desistiu treat2 ano2000-ano2003, absorb(id) cluster(id_est);
 sum desistiu if e(sample)==1;
areg desistiu treat2 ano2000-ano2003 des2000_*, absorb(id) cluster(id_est);
 sum desistiu if e(sample)==1;
areg desistiu treat2 ano2000-ano2003 des2000_* des1999_*, absorb(id) cluster(id_est);
 gen ESAMPLE2=e(sample);
 sum desistiu if e(sample)==1;
areg desistiu treat2 ano2000-ano2003 dropout00_* dropout10_* dropout01_* dropout11_* if ESAMPLE2==1, absorb(id) cluster(id_est);
 sum desistiu if e(sample)==1;

areg desistiu treat2 ano2000-ano2003 if dropout00==1&ESAMPLE==1, absorb(id) cluster(id_est);
 sum desistiu if e(sample)==1;
areg desistiu treat2 ano2000-ano2003 if dropout10==1&ESAMPLE==1, absorb(id) cluster(id_est);
 sum desistiu if e(sample)==1;
areg desistiu treat2 ano2000-ano2003 if dropout01==1&ESAMPLE==1, absorb(id) cluster(id_est);
 sum desistiu if e(sample)==1;
areg desistiu treat2 ano2000-ano2003 if dropout11==1&ESAMPLE==1, absorb(id) cluster(id_est);
 sum desistiu if e(sample)==1;

sum dropout00 dropout10 dropout01 dropout11 if ESAMPLE==1;

areg desistiu treat2 ano2000-ano2003 dropout00_* dropout10_* dropout01_* dropout11_* if ftest<=2, absorb(id) cluster(id_est);
 sum desistiu if e(sample)==1;
areg desistiu treat2 ano2000-ano2003 dropout00_* dropout10_* dropout01_* dropout11_* if fimpact>-0.01, absorb(id) cluster(id_est);
 sum desistiu if e(sample)==1;


log close;
exit;

