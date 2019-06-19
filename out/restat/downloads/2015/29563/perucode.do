/******************************************************************************************/
/* Replication code for Kraay, Aart and Peter Murrell (2015).  "Misunderestimating Corruption".  Review of Economics and Statistics" */
/* This file replicates the results using the Peru Enterprise Survey */
/******************************************************************************************/

#delimit ;
log using perulog, replace;

/*
set memory 350m;
set more 1;
set matsize 4000;
set linesize 180;
set maxiter 200;
*/
use perudata.dta, clear ;

/******************************************************************************************/
/* Dataset has 527 observations on Peru */
/* Variables are rr1-rr10, s, x, and strata */
/* rr1-rr10 are the dummy variables summarizing responses to the ten random response questions*/
/* The order of rr1-rr10 corresponds to that in Table 1; coded 1 = yes, 0 = no */
/* s in the data set is S in the paper*/
/* x in the data set is X in the paper*/
/* strata is a categorical variable indicating membership of a particular stratum*/
/******************************************************************************************/

desc ;


/******************************************************************************************/
/* generating results for descriptive statistics*/
/* first command below generates results for Table 1*/
/* Next four commands generate the descriptive statistics on Peru appearing in Table 3*/
/******************************************************************************************/
sum rr1-rr10 ;
sum s ;
sum x ;
tab x ;
corr s x ;


/******************************************************************************************/
/* GMM Estimation */
/* Generating results on Peru appearing in Table 4 */
/******************************************************************************************/

gen xx = x*x ;
gen sx = s*x ;

/* Define bounded version of parameters for r, g, q, and k. */
global r "(exp({rb})/(1+exp({rb})))";
global g "(exp({gb})/(1+exp({gb})))";
global q "(exp({qb})/(1+exp({qb})))";
global k "(exp({kb})/(1+exp({kb})))";


/* Write moment conditions as substitutable expressions to use in GMM */
global means "$r*$g*(1-$q)+(1-$r)*$k*$g";
global meanx "0.5*7*($r*(1-$q)*(1+$g)+(1-$r)*(1+$k*$g))";
global meansx "0.5*7*($r*$g*(1+$g)*(1-$q)^2+(1-$r)*$k*$g*(1+$k*$g))";
global meanxx "(7*6*0.5^2)*($r*(1-$q)^2*(1+$g)^2+(1-$r)*(1+$k*$g)^2)+$meanx";


gmm ($means-s) ($meanx-x) ($meansx-sx) ($meanxx-xx), winitial(identity)  vce(cluster strata);
nlcom (param_g: exp(_b[/gb])/(1+exp(_b[/gb]))) 
      (param_r: exp(_b[/rb])/(1+exp(_b[/rb])))
      (param_q: exp(_b[/qb])/(1+exp(_b[/qb])))
      (param_k: exp(_b[/kb])/(1+exp(_b[/kb])))
      (overall_guilt: (exp(_b[/rb])/(1+exp(_b[/rb]))+(1-exp(_b[/rb])/(1+exp(_b[/rb])))*exp(_b[/kb])/(1+exp(_b[/kb])))*exp(_b[/gb])/(1+exp(_b[/gb])))
      (effective_reticence: exp(_b[/rb])/(1+exp(_b[/rb]))*exp(_b[/qb])/(1+exp(_b[/qb]))), post;eststo;

esttab using perugmm.csv, replace;

/******************************************************************************************/
/* Maximum Likelihood Estimation */
/* Generating results on Peru appearing in Table 5 */
/******************************************************************************************/

eststo clear;
/* Define bounded version of parameters */
global r "(exp({rb})/(1+exp({rb})))";
global g "(exp({gb})/(1+exp({gb})))";
global q "(exp({qb})/(1+exp({qb})))";
global k "(exp({kb})/(1+exp({kb})))";

/* Build up likelihood function */
/* Success probabilities on CQ and RRQ */
global psr "($g*(1-$q))";
global psc "($k*$g)"; 
global pxr "(0.5*(1+$g)*(1-$q))";
global pxc "(0.5*(1+$k*$g))";

/* Define distributions of s and x conditional on reticence */
global fsr "$psr^s*(1-$psr)^(1-s)";
global fsc "$psc^s*(1-$psc)^(1-s)";
global fxr "comb(7,x)*$pxr^x*(1-$pxr)^(7-x)";
global fxc "comb(7,x)*$pxc^x*(1-$pxc)^(7-x)";

global logl "log($r*$fsr*$fxr+(1-$r)*$fsc*$fxc)";
mlexp ($logl) , from(rb 0 gb 5 qb 0 kb 0) vce(cluster strata);
nlcom (param_g: exp(_b[/gb])/(1+exp(_b[/gb]))) 
      (param_r: exp(_b[/rb])/(1+exp(_b[/rb])))
      (param_q: exp(_b[/qb])/(1+exp(_b[/qb])))
      (param_k: exp(_b[/kb])/(1+exp(_b[/kb])))
      (overall_guilt: (exp(_b[/rb])/(1+exp(_b[/rb]))+(1-exp(_b[/rb])/(1+exp(_b[/rb])))*exp(_b[/kb])/(1+exp(_b[/kb])))*exp(_b[/gb])/(1+exp(_b[/gb])))
      (effective_reticence: exp(_b[/rb])/(1+exp(_b[/rb]))*exp(_b[/qb])/(1+exp(_b[/qb]))), post;eststo;

  
esttab using peruml.csv, replace;

exit, clear ;


