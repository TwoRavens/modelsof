
*** This do-file conducts the effect-size calculations in the Online Appendix ***


clear all 

set scheme lean2
set obs 1000
*Generate running variable

*** Calculation for poor (CCT receipients)***

*Calculate implied means*

global mu_nonpoor=1.147  // Regression constant
global share_poor=0.1 // Simplification
global slope=1.422 // Regression slope


global mu_poor=($mu_nonpoor + $slope * $share_poor- (1-$share_poor )* $mu_nonpoor )/ $share_poor

di $mu_poor

global multiplier= $mu_poor / $mu_nonpoor //Ratio of poor to non-poor

di $multiplier

global mu_pooled_1114=2.02 //control mean 2011 2014

global mu_poor_1114= $mu_pooled_1114 /( (1-$share_poor )/ $multiplier + $share_poor )

global mu_nonpoor_1114=$mu_pooled_1114 /( (1-$share_poor ) + $multiplier * $share_poor)

di $mu_poor_1114

di $mu_nonpoor_1114



gen x=(_n-1)/1000 in 1/1000




*Cash transfer
global s_c_nopkh=$mu_nonpoor_1114 //non treated control mean
global s_new=$mu_pooled_1114 -0.36 // Ex-post mean
global mu_treat=0.1 // fraction treated

global s_c_pkh=$mu_poor_1114 //treated control mean


gen treat_perc =  ((($s_new -(1-$mu_treat )*$s_c_nopkh +x*$s_c_pkh )/((1-$mu_treat) * x + $mu_treat )  - $s_c_pkh )) / $s_c_pkh

****************************************
*** Calculation for farmers/rainfall ***
****************************************


global mu_nonfarm=0.715  // Regression constant
global share_farm=0.56 // Simplification
global slope_farm=1.194 // Regression slope


global mu_farm=($mu_nonfarm + $slope_farm * $share_farm- (1-$share_farm )* $mu_nonfarm )/ $share_farm

di $mu_farm

global multiplier_farm= $mu_farm / $mu_nonfarm //Ratio of poor to non-poor

di $multiplier_farm

global mu_pooled_farm=1.39 //Mean across all years
global mu_farm_all= $mu_pooled_farm /( (1-$share_farm )/ $multiplier_farm + $share_farm )

di $mu_farm_all

global mu_nonfarm_all=$mu_farm_all /$multiplier_farm

di $mu_nonfarm_all


global s_new_r=$mu_pooled_farm -0.08  // Treated mean
global mu_treat_r=$share_farm // fraction treated
global s_c_nofarm_r=$mu_nonfarm_all //non treated control mean
global s_c_farm_r=$mu_farm_all //treated control mean


gen treat_perc_r=  (($s_new_r -(1-$mu_treat_r )*$s_c_nofarm_r +x*$s_c_farm_r )/((1-$mu_treat_r ) * x + $mu_treat_r )-$s_c_farm_r )/ $s_c_farm_r

/* Uncomment to show how direct effect varies with spillovers 
twoway (line  treat_perc x if treat_perc<=0)(line treat_perc_r x if treat_perc_r<=0), legend(order(1 "Cash transfer" 2 "Rainfall") pos(6) rows(1)) ///
ytitle("% of implied control mean") xtitle("Spillover multiplier") xline(0.034, lcolor(red))
*/

*************************
*** In absolute terms ***
*************************

gen treat_abs_pkh=  ((($s_new -(1-$mu_treat )*$s_c_nopkh +x*$s_c_pkh )/((1-$mu_treat) * x + $mu_treat )  - $s_c_pkh )) 


gen treat_abs_rain =  (($s_new_r -(1-$mu_treat_r )*$s_c_nofarm_r +x*$s_c_farm_r )/((1-$mu_treat_r ) * x + $mu_treat_r )-$s_c_farm_r )



/* Uncomment to show hwo direct effect varies with spillovers 
twoway (line  treat_abs_pkh x if treat_perc<=0)(line treat_abs_rain x if treat_perc_r<=0), legend(order(1 "Cash transfer" 2 "Rainfall") pos(6) rows(1)) ///
ytitle("Direct treatment effect") xtitle("Spillover multiplier") xline(0.034, lcolor(red))
*/


*** Calculate spillover rates that equal ex-post suicide rate ***

di "Post-treatment rate is: " $s_new

di "The pkh eligible control mean is: " $s_c_pkh

gen temp = abs($s_c_pkh + treat_abs_pkh -$s_new) // Difference from implied control mean

qui sum temp , d

qui sum x  if temp==r(min)

di "The spillover rate to equal ex-post rates is: " r(mean)





