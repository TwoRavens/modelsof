/******************************************************************************************/
/* Replication code for Kraay, Aart and Peter Murrell (2015).  "Misunderestimating Corruption".  Review of Economics and Statistics */
/* This file replicates the results using 9 countries in the Gallup World Poll */
/* The data file required to run this code is proprietary and is available on request from */
/* Gallup.  To request access to this dataset please contact the corresponding author */
/* Aart Kraay (akraay@worldbank.org) who will forward your request to Gallup */
/******************************************************************************************/


#delimit ;
clear;
log using gwplog.smcl, replace;
use gwpdata;



/******************************************************************************************/
/* Dataset has 12864 observations covering 9 countries */
/* Countries are identified by wp5 (numerical, country names identified as labels in data) */
/* Variables are rr1-rr10, s, x, and stratapsu */
/* rr1-rr10 are the dummy variables summarizing responses to the ten random response questions*/
/* The order of rr1-rr10 corresponds to that in Table 2; coded 1 = yes, 0 = no */
/* s in the data set is S in the paper*/
/* x in the data set is X in the paper*/
/* stratapsu is a categorical variable indicating membership of a particular stratum/psu */
/******************************************************************************************/

desc ;

/******************************************************************************************/
/* generating results for descriptive statistics reported in Table 2 and Table 3 */
/******************************************************************************************/
sort wp5;
tabstat rr1-rr10 s x, by(wp5) stats(mean n);
by wp5: tab x;
by wp5: corr s x;

	
/**********************************************************************************************/
/* GMM Estimation */
/* Generates results in Table 4 */
/**********************************************************************************************/
eststo clear;
/* Define bounded version of parameters */
global r "(exp({rb})/(1+exp({rb})))";
global g "(exp({gb})/(1+exp({gb})))";
global q "(exp({qb})/(1+exp({qb})))";
global k "(exp({kb})/(1+exp({kb})))";
/* Write moment conditions as substitutable expressions to use in GMM */
global meansr "$r*$g*(1-$q)+(1-$r)*$k*$g";
global meanxr "0.5*7*($r*(1-$q)*(1+$g)+(1-$r)*(1+$k*$g))";
global meansxr "0.5*7*($r*$g*(1+$g)*(1-$q)^2+(1-$r)*$k*$g*(1+$k*$g))";
global meanxxr "(7*6*0.5^2)*($r*(1-$q)^2*(1+$g)^2+(1-$r)*(1+$k*$g)^2)+$meanxr";

foreach cntry in 11 52 31 10 146 153 9 49 51 {;
gmm ($meansr-s) ($meanxr-x) ($meansxr-s*x) ($meanxxr-x*x) if wp5==`cntry', winitial(identity) vce(cluster stratapsu) from(rb 0 gb 0 qb 0 kb 0);
nlcom (param_g: exp(_b[/gb])/(1+exp(_b[/gb]))) 
      (param_r: exp(_b[/rb])/(1+exp(_b[/rb])))
      (param_q: exp(_b[/qb])/(1+exp(_b[/qb])))
      (param_k: exp(_b[/kb])/(1+exp(_b[/kb])))
      (guilt: (exp(_b[/rb])/(1+exp(_b[/rb]))+(1-exp(_b[/rb])/(1+exp(_b[/rb])))*exp(_b[/kb])/(1+exp(_b[/kb])))*exp(_b[/gb])/(1+exp(_b[/gb])))
      (effectivereticence: exp(_b[/rb])/(1+exp(_b[/rb]))*exp(_b[/qb])/(1+exp(_b[/qb]))), post;eststo;
};

esttab using gwpgmm.csv, replace;

	
/**********************************************************************************************/
/* Maximum Likelihood Estimation */
/* Generates results in Table 5 */
/**********************************************************************************************/
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

foreach cntry in 11 52 31 10 146 153 9 49 51 {; 
mlexp ($logl) if wp5==`cntry',  vce(cluster stratapsu) from(rb 0 gb 10 qb 0 kb 0) ;
nlcom (param_g: exp(_b[/gb])/(1+exp(_b[/gb]))) 
      (param_r: exp(_b[/rb])/(1+exp(_b[/rb])))
      (param_q: exp(_b[/qb])/(1+exp(_b[/qb])))
      (param_k: exp(_b[/kb])/(1+exp(_b[/kb])))
      (guilt: (exp(_b[/rb])/(1+exp(_b[/rb]))+(1-exp(_b[/rb])/(1+exp(_b[/rb])))*exp(_b[/kb])/(1+exp(_b[/kb])))*exp(_b[/gb])/(1+exp(_b[/gb])))
      (effectivereticence: exp(_b[/rb])/(1+exp(_b[/rb]))*exp(_b[/qb])/(1+exp(_b[/qb]))), post;eststo;
};
esttab using gwpml.csv, replace;



log close;
exit, clear;


