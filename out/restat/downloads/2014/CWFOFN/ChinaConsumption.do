** Title: Access to Markets and Rural Poverty: Evidence from Household Consumption in China

** Authors: M. Shahe Emran, Department of Economics and ESIA, George Washington University
**          Zhaoyang Hou, Georgetown University School of Foreign Service in Qatar

** Final revision date: February, 2011
 

#delimit;
clear;
set mem 500m;
set matsize 800;

use ChinaConsumption.dta, clear;

capture log close;
capture log using ChinaConsumption.log, replace;

****************************************************************;
****	1. OLS                                                    ;
****************************************************************;
xi: reg Ci        Ad Ag AdAg 
			i.province
			ter rain temperature elevation VAR_EL MEAN_SL STD_SL RIVER_LG soil
			gdp cargo socprod90_d socprod90_i, robust;
outreg using ChinaConsumption.xls, nolabel 3aster se bdec(2) ctitle("OLS") replace;

*****************************************************************;
** 2. GMM-1                                                      ;
*****************************************************************;
xi: ivreg2 Ci  	ter rain temperature elevation VAR_EL MEAN_SL STD_SL RIVER_LG soil
			gdp cargo socprod90_d socprod90_i i.province 
			(Ad Ag AdAg= AVdist Idist AVI 
					Dch_slop_me_Wsum Ich_slop_me_Wsum
					Dch_slop_su_Wsum Ich_slop_su_Wsum
					Ddem_1k_std_Wsum Idem_1k_std_Wsum
					Ddem_1k_max_Wtmax Idem_1k_max_Wtmax
					Dch_slop_mi_Wsum Ich_slop_mi_Wsum 
					Dch_slop_su_Wtmax Ich_slop_su_Wtmax 
					Dch_slop_ra_Wtmin Ich_slop_ra_Wtmin 
					Ddem_1k_std_Wtmax Idem_1k_std_Wtmax
					ielevation delevation), gmm2s first cluster(teamid);
ivhettest, all;
test Ad=Ag;
correlate Ad Ag, _coef covariance;
outreg using ChinaConsumption.xls, nolabel 3aster se bdec(2) ctitle("GMM-1") append;

*****************************************************************;
** 3. 2SLS                                                       ;
*****************************************************************;
xi: ivreg2 Ci  	ter rain temperature elevation VAR_EL MEAN_SL STD_SL RIVER_LG soil
			gdp cargo socprod90_d socprod90_i i.province 
			(Ad Ag AdAg= AVdist Idist AVI 
					Dch_slop_me_Wsum Ich_slop_me_Wsum
					Dch_slop_su_Wsum Ich_slop_su_Wsum
					Ddem_1k_std_Wsum Idem_1k_std_Wsum
					Ddem_1k_max_Wtmax Idem_1k_max_Wtmax
					Dch_slop_mi_Wsum Ich_slop_mi_Wsum 
					Dch_slop_su_Wtmax Ich_slop_su_Wtmax 
					Dch_slop_ra_Wtmin Ich_slop_ra_Wtmin 
					Ddem_1k_std_Wtmax Idem_1k_std_Wtmax
					ielevation delevation), first cluster(teamid);
ivhettest, all;
test Ad=Ag;
correlate Ad Ag, _coef covariance;
outreg using ChinaConsumption.xls, nolabel 3aster se bdec(2) ctitle("2SLS") append;

*****************************************************************;
** 4. GMM-2                                                      ;
*****************************************************************;
xi: ivreg2 Ci 	ter rain temperature elevation VAR_EL MEAN_SL STD_SL RIVER_LG soil
			gdp cargo socprod90_d socprod90_i i.province 
			(Ad Ag AdAg= AVdist Idist AVI 
					Dch_slop_me_Wsum Ich_slop_me_Wsum
					Ddem_1k_std_Wsum Idem_1k_std_Wsum
					Ddem_1k_max_Wtmax Idem_1k_max_Wtmax
					Dch_slop_ra_Wtmin Ich_slop_ra_Wtmin 
					Ddem_1k_std_Wtmax Idem_1k_std_Wtmax
					ielevation delevation), gmm2s first cluster(teamid);
ivhettest, all;
test Ad=Ag;
correlate Ad Ag, _coef covariance; 
outreg using ChinaConsumption.xls, nolabel 3aster se bdec(2) ctitle("GMM-2") append;

*****************************************************************;
** 5. Lewbel                                                     ;
*****************************************************************;
global Z = "Ddem_1k_std_Wsum D1 Idem_1k_mea_Wsum ";
global Z2 = "Idem_1k_std_Wsum ";

xi: reg Ad	ter temperature VAR_EL MEAN_SL STD_SL RIVER_LG soil gdp cargo socprod90_d socprod90_i i.province  $Z $Z2; 	
hettest;	
predict ld1, resid;
	
xi: reg Ag	ter temperature VAR_EL MEAN_SL STD_SL RIVER_LG soil gdp cargo socprod90_d socprod90_i i.province  $Z $Z2;	
hettest;	
predict li1, resid;	

xi: reg AdAg ter temperature VAR_EL MEAN_SL STD_SL RIVER_LG soil gdp cargo socprod90_d socprod90_i i.province  $Z $Z2; 	
hettest;	
predict ldi1, resid;	

foreach i in $Z $Z2 {;	
	egen `i'bar = mean(`i');
	gen `i'_1=(`i'-`i'bar)*ld1;
	gen `i'_2=(`i'-`i'bar)*li1;
	gen `i'_3=(`i'-`i'bar)*ldi1;	
	order `i'_1 `i'_2 `i'_3;
	};		

xi: ivreg2 Ci ter temperature VAR_EL MEAN_SL STD_SL RIVER_LG soil gdp cargo socprod90_d socprod90_i i.province $Z $Z2
			(Ad Ag AdAg= Idem_1k_std_Wsum_1 - Ddem_1k_std_Wsum_3), gmm2s ffirst cluster(county); 		
test Ad=Ag;
ivhettest, all;
correlate Ad Ag, _coef covariance;
outreg using ChinaConsumption.xls, nolabel 3aster se bdec(2) ctitle("Lewbel two-stage estimator") append;

/** F-stat for the 1st-stage regression, which degrees of freedom are based on observations **/
xi: ivreg2 Ci   ter rain temperature VAR_EL MEAN_SL STD_SL RIVER_LG soil
			    gdp cargo socprod90_d socprod90_i i.province  $Z $Z2
			(Ad Ag AdAg= Idem_1k_std_Wsum_1 - Ddem_1k_std_Wsum_3), gmm2s ffirst; 

foreach i in $Z $Z2{;
	drop `i'_1 `i'_2 `i'_3 `i'bar;
};
drop ld1 li1 ldi1 ;

*****************************************************************;
** 6.1. GMM - Include Household Controls                         ;
*****************************************************************;
xi: ivreg2 Ci	ter rain temperature elevation VAR_EL MEAN_SL STD_SL RIVER_LG soil
			gdp cargo socprod90_d socprod90_i i.province $hh1 $hh2 $hh3
			(Ad Ag AdAg= AVdist Idist AVI 
					Dch_slop_me_Wsum Ich_slop_me_Wsum
					Dch_slop_su_Wsum Ich_slop_su_Wsum
					Ddem_1k_std_Wsum Idem_1k_std_Wsum
					Ddem_1k_max_Wtmax Idem_1k_max_Wtmax
					Dch_slop_mi_Wsum Ich_slop_mi_Wsum 
					Dch_slop_su_Wtmax Ich_slop_su_Wtmax 
					Dch_slop_ra_Wtmin Ich_slop_ra_Wtmin 
					Ddem_1k_std_Wtmax Idem_1k_std_Wtmax
					ielevation delevation), gmm2s ffirst cluster(teamid);
ivhettest, all;
outreg using ChinaConsumption.xls, nolabel 3aster se bdec(2) ctitle("GMM 1: include HH controls") append;

*****************************************************************;
** 6.2. GMM - Include Public Goods                               ;
*****************************************************************;
xi: ivreg2 Ci	ter rain temperature elevation VAR_EL MEAN_SL STD_SL RIVER_LG soil
			gdp cargo socprod90_d socprod90_i i.province $pub
			(Ad Ag AdAg= AVdist Idist AVI 
					Dch_slop_me_Wsum Ich_slop_me_Wsum
					Dch_slop_su_Wsum Ich_slop_su_Wsum
					Ddem_1k_std_Wsum Idem_1k_std_Wsum
					Ddem_1k_max_Wtmax Idem_1k_max_Wtmax
					Dch_slop_mi_Wsum Ich_slop_mi_Wsum 
					Dch_slop_su_Wtmax Ich_slop_su_Wtmax 
					Dch_slop_ra_Wtmin Ich_slop_ra_Wtmin 
					Ddem_1k_std_Wtmax Idem_1k_std_Wtmax
					ielevation delevation), gmm2s ffirst cluster(teamid);
ivhettest, all;
outreg using ChinaConsumption.xls, nolabel 3aster se bdec(2) ctitle("GMM 1: include Public goods") append;

*****************************************************************;
** 6.3. GMM - Include Household Controls & Public Goods          ;
*****************************************************************;
xi: ivreg2 Ci	ter rain temperature elevation VAR_EL MEAN_SL STD_SL RIVER_LG soil
			gdp cargo socprod90_d socprod90_i i.province $hh1 $hh2 $hh3 $pub
			(Ad Ag AdAg= AVdist Idist AVI 
					Dch_slop_me_Wsum Ich_slop_me_Wsum
					Dch_slop_su_Wsum Ich_slop_su_Wsum
					Ddem_1k_std_Wsum Idem_1k_std_Wsum
					Ddem_1k_max_Wtmax Idem_1k_max_Wtmax
					Dch_slop_mi_Wsum Ich_slop_mi_Wsum 
					Dch_slop_su_Wtmax Ich_slop_su_Wtmax 
					Dch_slop_ra_Wtmin Ich_slop_ra_Wtmin 
					Ddem_1k_std_Wtmax Idem_1k_std_Wtmax
					ielevation delevation), gmm2s ffirst cluster(teamid);
ivhettest, all;
outreg using ChinaConsumption.xls, nolabel 3aster se bdec(2) ctitle("GMM 1: include HH controls & Public goods") append;

*****************************************************************;
** 7.1.  Different functional form: log-log                      ;
*****************************************************************;
xi: ivreg2 lgCi	ter rain temperature elevation VAR_EL MEAN_SL STD_SL RIVER_LG soil
			gdp cargo socprod90_d socprod90_i i.province 
			(Ad Ag AdAg= AVdist Idist AVI 
					Dch_slop_me_Wsum Ich_slop_me_Wsum
					Dch_slop_su_Wsum Ich_slop_su_Wsum
					Ddem_1k_std_Wsum Idem_1k_std_Wsum
					Ddem_1k_max_Wtmax Idem_1k_max_Wtmax
					Dch_slop_mi_Wsum Ich_slop_mi_Wsum), gmm2s ffirst cluster(teamid);
ivhettest, all;
test Ad=Ag;
correlate Ad Ag, _coef covariance;
outreg using ChinaConsumption.xls, nolabel 3aster se bdec(2) ctitle("GMM-1:log-log") append;

*****************************************************************;
** 7.2.  Different functional form: level-level                  ;
*****************************************************************;
g DdDi = distance_d*dif_id;
xi: ivreg2 lgCi	ter rain temperature elevation VAR_EL MEAN_SL STD_SL RIVER_LG soil
			gdp cargo socprod90_d socprod90_i i.province 
			(distance_d dif_id DdDi = AVdist Idist AVI 
								Dch_slop_me_Wsum Ich_slop_me_Wsum
								Dch_slop_su_Wsum Ich_slop_su_Wsum
								Ddem_1k_std_Wsum Idem_1k_std_Wsum
								Ddem_1k_max_Wtmax Idem_1k_max_Wtmax
								Dch_slop_mi_Wsum Ich_slop_mi_Wsum 
								Dch_slop_su_Wtmax Ich_slop_su_Wtmax 
     								Ddem_1k_std_Wtmax Idem_1k_std_Wtmax), gmm2s ffirst cluster(teamid);
outreg using ChinaConsumption.xls, nolabel 3aster se bdec(5) ctitle("GMM-1:level-level") append;



*********************************************************************;
** 8.	Boostrap to calculate the standard deviation of the coefficient ;
**	    difference between GMM-1 and with Different Sets of Controls ;
*********************************************************************;

use ChinaConsumption.dta, clear;

set seed 123;

********************************************************************;
** 8.1. GMM-1                                                       ;
********************************************************************;
bootstrap "xi: ivreg2 Ci  
			ter rain temperature elevation VAR_EL MEAN_SL STD_SL RIVER_LG soil
			gdp cargo socprod90_d socprod90_i i.province 
			(Ad Ag AdAg= AVdist Idist AVI 
		Dch_slop_me_Wsum Ich_slop_me_Wsum
		Dch_slop_su_Wsum Ich_slop_su_Wsum
		Ddem_1k_std_Wsum Idem_1k_std_Wsum
		Ddem_1k_max_Wtmax Idem_1k_max_Wtmax
		Dch_slop_mi_Wsum Ich_slop_mi_Wsum 
		Dch_slop_su_Wtmax Ich_slop_su_Wtmax 
		Dch_slop_ra_Wtmin Ich_slop_ra_Wtmin 
		Ddem_1k_std_Wtmax Idem_1k_std_Wtmax
		ielevation delevation), gmm2s cluster(teamid) "_b, reps(300)  saving (b1);

set seed 123;

********************************************************************;
** 8.2. GMM-1 - Include Household Controls                          ;
********************************************************************;
bootstrap "xi: ivreg2 Ci  
			ter rain temperature elevation VAR_EL MEAN_SL STD_SL RIVER_LG soil
			gdp cargo socprod90_d socprod90_i i.province 
			sex age asq min gov com agr edu
			nchild nold assignedland initial_assets initial_livestock
			d_housing tap_water lighting bankcredit machinery nma
			(Ad Ag AdAg= AVdist Idist AVI 
		Dch_slop_me_Wsum Ich_slop_me_Wsum
		Dch_slop_su_Wsum Ich_slop_su_Wsum
		Ddem_1k_std_Wsum Idem_1k_std_Wsum
		Ddem_1k_max_Wtmax Idem_1k_max_Wtmax
		Dch_slop_mi_Wsum Ich_slop_mi_Wsum 
	 	Dch_slop_su_Wtmax Ich_slop_su_Wtmax 
		Dch_slop_ra_Wtmin Ich_slop_ra_Wtmin 
		Ddem_1k_std_Wtmax Idem_1k_std_Wtmax
		ielevation delevation), gmm2s cluster(teamid)" _b, reps(300) saving(b2);

set seed 123;

********************************************************************;
** 8.3. GMM-1 - Include Public Goods                                ;
********************************************************************;
bootstrap "xi: ivreg2 Ci  
			ter rain temperature elevation VAR_EL MEAN_SL STD_SL RIVER_LG soil
			gdp cargo socprod90_d socprod90_i i.province health_clinic d_school a90193 a90196 a90199 
			(Ad Ag AdAg= AVdist Idist AVI 
		Dch_slop_me_Wsum Ich_slop_me_Wsum
		Dch_slop_su_Wsum Ich_slop_su_Wsum
		Ddem_1k_std_Wsum Idem_1k_std_Wsum
		Ddem_1k_max_Wtmax Idem_1k_max_Wtmax
		Dch_slop_mi_Wsum Ich_slop_mi_Wsum 
		Dch_slop_su_Wtmax Ich_slop_su_Wtmax 
		Dch_slop_ra_Wtmin Ich_slop_ra_Wtmin 
		Ddem_1k_std_Wtmax Idem_1k_std_Wtmax
		ielevation delevation), gmm2s cluster(teamid) " _b, reps(300) saving(b3);

set seed 123;

********************************************************************;
** 8.4. GMM-1 - Include Household Controls & Public Goods           ;                           ;
********************************************************************;
bootstrap "xi: ivreg2 Ci  
			ter rain temperature elevation VAR_EL MEAN_SL STD_SL RIVER_LG soil
			gdp cargo socprod90_d socprod90_i i.province 
			sex age asq min gov com agr edu
			nchild nold assignedland initial_assets initial_livestock
			d_housing tap_water lighting bankcredit machinery nma
			health_clinic d_school a90193 a90196 a90199 
			(Ad Ag AdAg= AVdist Idist AVI 
		Dch_slop_me_Wsum Ich_slop_me_Wsum
		Dch_slop_su_Wsum Ich_slop_su_Wsum
		Ddem_1k_std_Wsum Idem_1k_std_Wsum
		Ddem_1k_max_Wtmax Idem_1k_max_Wtmax
		Dch_slop_mi_Wsum Ich_slop_mi_Wsum 
		Dch_slop_su_Wtmax Ich_slop_su_Wtmax 
		Dch_slop_ra_Wtmin Ich_slop_ra_Wtmin 
		Ddem_1k_std_Wtmax Idem_1k_std_Wtmax
		ielevation delevation), gmm2s cluster(teamid)" _b, reps(300) saving(b4);


use b1, clear;

generate b_Ad_model1  = b_Ad;
generate b_Ag_model1  = b_Ag;
generate b_AdAg_model1 = b_AdAg;
keep     b_Ad_model1 b_Ag_model1 b_AdAg_model1;
save b1, replace;

#delimit;
foreach i in 2 3 4 {;
use b`i', clear;

generate b_Ad_model`i'  = b_Ad;
generate b_Ag_model`i'  = b_Ag;
generate b_AdAg_model`i' = b_AdAg;
keep     b_Ad_model`i' b_Ag_model`i' b_AdAg_model`i';

save b`i', replace;

merge using b1;
tabulate _merge;
drop     _merge;

generate diff_b_Ad`i' = b_Ad_model1 - b_Ad_model`i';
generate diff_b_Ag`i' = b_Ag_model1 - b_Ag_model`i';
generate diff_b_AdAg`i' = b_AdAg_model1 - b_AdAg_model`i';

list b_Ad_model1   b_Ag_model1   b_AdAg_model1
     b_Ad_model`i' b_Ag_model`i' b_AdAg_model`i' diff_b*;

summarize diff_b*;

};

erase b1.dta;
erase b2.dta;
erase b3.dta;
erase b4.dta;

log close;




