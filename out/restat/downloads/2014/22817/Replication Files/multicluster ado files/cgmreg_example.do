#delimit ;

clear ;

/* generate data */
set obs 100 ;
gen x = invnorm(uniform()) ;
gen y = 2 * x + invnorm(uniform()) ;
gen clu_id_1 = floor((_n-1) / 10) + 1 ;
gen clu_id_2 = _n - ((clu_id_1-1) * 10) ;

/* estimate model */
cgmreg y x , cluster(clu_id_1 clu_id_2) ;


