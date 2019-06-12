/***************************************************************************
* Stata source code file used for ``Killing Two Birds with One Stone?      *
* Examining the Diffusion Effect of Militant Leadership Decapitation''     *
* International Studies Quarterly                                          *
* Author: Yasutaka Tominaga                                                *
* For questions, email at y-tominaga@yasutakatominaga.com                  *
* Last Updated on March 24th, 2017                                         *
* Session Info:                                                            *
* Stata version 14.2        									           *
* Platform: x86_64-apple-darwin13.4.0 (64-bit)						 	   *
* Running under: macOS Sierra 10.12.2									   *
****************************************************************************/

/*****************************************************************************
* Memo: For producing the statistical results, table, and figures,           *
*       I utilized both Stata and R. In particular, I use Stata for the      *
*       statistical analysis and R for making figures. This do file contains *
*       both stata and R code (later section).                               *
*****************************************************************************/



//-----------------------------------------------------------------------------//



/***************************************************************************
*																		   *
*							 STATA code 								   *
*																		   *
****************************************************************************/

#delimit ;

/* Setting */
set more off; 
set scheme s1mono;
set graphics off;

/* Data used */ 
/* Please set directory to which the datafile is located */ 
use "~/Data.dta", replace;

/************************************************************************
*          Model 1(a): Killing + Covariates (Domestic) 					*
*************************************************************************/

reg lnCountDomes Kill_Lag3 Kill_Lag2 Kill Kill_Lead1 Kill_Lead2 Kill_Lead3 i.Year i.Identifier lnGDP lnpop polity2 group_age lnMilExp f_icrg, vce(cluster Identifier); 
estimates store re1a; //For producing the regression table

/* Derive Wild Bootstrap Standard Errors */ 
//For wild bootstrap, I refered the stata codes by Cameron and Trevidi (2010)// 
scalar theta=_b[Kill_Lag3];
scalar theta1=_b[Kill_Lag2];
scalar theta2=_b[Kill];
scalar theta3=_b[Kill_Lead1];
scalar theta4=_b[Kill_Lead2];
scalar theta5=_b[Kill_Lead3];
scalar se=_se[Kill_Lag3];
scalar se1=_se[Kill_Lag2];
scalar se2=_se[Kill];
scalar se3=_se[Kill_Lead1];
scalar se4=_se[Kill_Lead2];
scalar se5=_se[Kill_Lead3];

program bootwild;
version 11;
drop _all;
use "~/Data.dta", replace;
reg lnCountDomes Kill_Lag3 Kill_Lag2 Kill Kill_Lead1 Kill_Lead2 Kill_Lead3 i.Year i.Identifier lnGDP lnpop polity2 group_age lnMilExp f_icrg, vce(cluster Identifier);
predict xb1;
predict u1, resid;
gen ustar1=-1*u1;
replace ustar1=1*u1 if runiform()>0.5;
gen ystar1=xb1+ustar1;
reg ystar1 Kill_Lag3 Kill_Lag2 Kill Kill_Lead1 Kill_Lead2 Kill_Lead3 i.Year i.Identifier lnGDP lnpop polity2 group_age lnMilExp f_icrg, vce(cluster Identifier);
end;
simulate _b _se, seed(0802) reps(999): bootwild;

//Find standard errors in Table// 
mean _se_Kill_Lag3 _se_Kill_Lag2 _se_Kill _se_Kill_Lead1 _se_Kill_Lead2 _se_Kill_Lead3;

/* Find the significance */ 
gen tstr=((_b_Kill_Lag3)-(theta))/(_se_Kill_Lag3);
gen tstr1=((_b_Kill_Lag2)-(theta1))/(_se_Kill_Lag2);
gen tstr2=((_b_Kill)-(theta2))/(_se_Kill);
gen tstr3=((_b_Kill_Lead1)-(theta3))/(_se_Kill_Lead1);
gen tstr4=((_b_Kill_Lead2)-(theta4))/(_se_Kill_Lead2);
gen tstr5=((_b_Kill_Lead3)-(theta5))/(_se_Kill_Lead3);

//For Lagged 3// 
count if abs(theta/se)<abs(tstr);
dis "p-value=" r(N)/_N;

//For Lagged 2// 
count if abs(theta1/se1)<abs(tstr1);
dis "p-value=" r(N)/_N;

//For Kill// 
count if abs(theta2/se2)<abs(tstr2);
dis "p-value=" r(N)/_N;

//For Lead 1//  
count if abs(theta3/se3)<abs(tstr3);
dis "p-value=" r(N)/_N;

//For Lead 2// 
count if abs(theta4/se4)<abs(tstr4);
dis "p-value=" r(N)/_N;

//For Lead3// 
count if abs(theta5/se5)<abs(tstr5);
dis "p-value=" r(N)/_N;

program drop _all;
pause on;

/************************************************************************
*          Model 1(b): Killing + Covariates (Transnatoinal) 			*
*************************************************************************/

use "~/Data.dta", replace;

reg lnCountTrans Kill_Lag3 Kill_Lag2 Kill Kill_Lead1 Kill_Lead2 Kill_Lead3 i.Year i.Identifier lnGDP lnpop polity2 group_age lnMilExp f_icrg, vce(cluster Identifier);
estimates store re1b //For producing the regression table

/* Derive Wild Bootstrap Standard Errors */ 
//For wild bootstrap, I refered the stata codes by Cameron and Trevidi (2010)// 
scalar theta=_b[Kill_Lag3];
scalar theta1=_b[Kill_Lag2];
scalar theta2=_b[Kill];
scalar theta3=_b[Kill_Lead1];
scalar theta4=_b[Kill_Lead2];
scalar theta5=_b[Kill_Lead3];
scalar se=_se[Kill_Lag3];
scalar se1=_se[Kill_Lag2];
scalar se2=_se[Kill];
scalar se3=_se[Kill_Lead1];
scalar se4=_se[Kill_Lead2];
scalar se5=_se[Kill_Lead3];

program bootwild;
version 11;
drop _all;
use "~/Data.dta", replace;
reg lnCountTrans Kill_Lag3 Kill_Lag2 Kill Kill_Lead1 Kill_Lead2 Kill_Lead3 i.Year i.Identifier lnGDP lnpop polity2 group_age lnMilExp f_icrg, vce(cluster Identifier);
predict xb1;
predict u1, resid;
gen ustar1=-1*u1;
replace ustar1=1*u1 if runiform()>0.5;
gen ystar1=xb1+ustar1;
reg ystar1 Kill_Lag3 Kill_Lag2 Kill Kill_Lead1 Kill_Lead2 Kill_Lead3 i.Year i.Identifier lnGDP lnpop polity2 group_age lnMilExp f_icrg, vce(cluster Identifier);
end;
simulate _b _se, seed(0802) reps(999): bootwild;

//Find standard errors in Table// 
mean _se_Kill_Lag3 _se_Kill_Lag2 _se_Kill _se_Kill_Lead1 _se_Kill_Lead2 _se_Kill_Lead3;

/* Find the significance */
gen tstr=((_b_Kill_Lag3)-(theta))/(_se_Kill_Lag3);
gen tstr1=((_b_Kill_Lag2)-(theta1))/(_se_Kill_Lag2);
gen tstr2=((_b_Kill)-(theta2))/(_se_Kill);
gen tstr3=((_b_Kill_Lead1)-(theta3))/(_se_Kill_Lead1);
gen tstr4=((_b_Kill_Lead2)-(theta4))/(_se_Kill_Lead2);
gen tstr5=((_b_Kill_Lead3)-(theta5))/(_se_Kill_Lead3);

//For Lagged 3// 
count if abs(theta/se)<abs(tstr);
dis "p-value=" r(N)/_N;

//For Lagged 2// 
count if abs(theta1/se1)<abs(tstr1);
dis "p-value=" r(N)/_N;

//For Kill// 
count if abs(theta2/se2)<abs(tstr2);
dis "p-value=" r(N)/_N;

//For Lead 1//  
count if abs(theta3/se3)<abs(tstr3);
dis "p-value=" r(N)/_N;

//For Lead 2// 
count if abs(theta4/se4)<abs(tstr4);
dis "p-value=" r(N)/_N;

//For Lead3// 
count if abs(theta5/se5)<abs(tstr5);
dis "p-value=" r(N)/_N;

program drop _all;
pause on;

/************************************************************
*       Model 2(a): Capturing + Covariates (Domestic)		*
*************************************************************/

use "~/Data.dta", replace;

reg lnCountDomes Cap_Lag3 Cap_Lag2 Capture Cap_Lead1 Cap_Lead2 Cap_Lead3 i.Year i.Identifier lnGDP lnpop polity2 group_age lnMilExp f_icrg, vce(cluster Identifier);
estimates store re2a //For producing the regression table

/* Derive Wild Bootstrap Standard Errors */ 
//For wild bootstrap, I refered the stata codes by Cameron and Trevidi (2010)// 
scalar theta=_b[Cap_Lag3];
scalar theta1=_b[Cap_Lag2];
scalar theta2=_b[Capture];
scalar theta3=_b[Cap_Lead1];
scalar theta4=_b[Cap_Lead2];
scalar theta5=_b[Cap_Lead3];
scalar se=_se[Cap_Lag3];
scalar se1=_se[Cap_Lag2];
scalar se2=_se[Capture];
scalar se3=_se[Cap_Lead1];
scalar se4=_se[Cap_Lead2];
scalar se5=_se[Cap_Lead3];

program bootwild;
version 11;
drop _all;
use "~/Data.dta", replace;
reg lnCountDomes Cap_Lag3 Cap_Lag2 Capture Cap_Lead1 Cap_Lead2 Cap_Lead3 i.Year i.Identifier lnGDP lnpop polity2 group_age lnMilExp f_icrg, vce(cluster Identifier);
predict xb1;
predict u1, resid;
gen ustar1=-1*u1;
replace ustar1=1*u1 if runiform()>0.5;
gen ystar1=xb1+ustar1;
reg ystar1 Cap_Lag3 Cap_Lag2 Capture Cap_Lead1 Cap_Lead2 Cap_Lead3 i.Year i.Identifier lnGDP lnpop polity2 group_age lnMilExp f_icrg, vce(cluster Identifier);
end ;
simulate _b _se, seed(0802) reps(999): bootwild;

//Find standard errors in Table//
mean _se_Cap_Lag3 _se_Cap_Lag2 _se_Capture _se_Cap_Lead1 _se_Cap_Lead2 _se_Cap_Lead3;

/* Find the significance */
gen tstr=((_b_Cap_Lag3)-(theta))/(_se_Cap_Lag3);
gen tstr1=((_b_Cap_Lag2)-(theta1))/(_se_Cap_Lag2);
gen tstr2=((_b_Capture)-(theta2))/(_se_Capture);
gen tstr3=((_b_Cap_Lead1)-(theta3))/(_se_Cap_Lead1);
gen tstr4=((_b_Cap_Lead2)-(theta4))/(_se_Cap_Lead2);
gen tstr5=((_b_Cap_Lead3)-(theta5))/(_se_Cap_Lead3);

//For Lagged 3// 
count if abs(theta/se)<abs(tstr);
dis "p-value=" r(N)/_N;

//For Lagged 2// 
count if abs(theta1/se1)<abs(tstr1);
dis "p-value=" r(N)/_N;

//For Kill// 
count if abs(theta2/se2)<abs(tstr2);
dis "p-value=" r(N)/_N;

//For Lead 1//  
count if abs(theta3/se3)<abs(tstr3);
dis "p-value=" r(N)/_N;

//For Lead 2// 
count if abs(theta4/se4)<abs(tstr4);
dis "p-value=" r(N)/_N;

//For Lead3// 
count if abs(theta5/se5)<abs(tstr5);
dis "p-value=" r(N)/_N;

program drop _all;
pause on;

/************************************************************
*   Model 2(b): Capturing + Covariates (Transnational)		*
*************************************************************/

use "~/Data.dta", replace;

reg lnCountTrans Cap_Lag3 Cap_Lag2 Capture Cap_Lead1 Cap_Lead2 Cap_Lead3 i.Year i.Identifier lnGDP lnpop polity2 group_age lnMilExp f_icrg, vce(cluster Identifier);
estimates store re2b; //For producing the regression table

/* Derive Wild Bootstrap Standard Errors */ 
//For wild bootstrap, I refered the stata codes by Cameron and Trevidi (2010)// 
scalar theta=_b[Cap_Lag3];
scalar theta1=_b[Cap_Lag2];
scalar theta2=_b[Capture];
scalar theta3=_b[Cap_Lead1];
scalar theta4=_b[Cap_Lead2];
scalar theta5=_b[Cap_Lead3];
scalar se=_se[Cap_Lag3];
scalar se1=_se[Cap_Lag2];
scalar se2=_se[Capture];
scalar se3=_se[Cap_Lead1];
scalar se4=_se[Cap_Lead2];
scalar se5=_se[Cap_Lead3];

program bootwild;
version 11;
drop _all;
use "~/Data.dta", replace;
reg lnCountTrans Cap_Lag3 Cap_Lag2 Capture Cap_Lead1 Cap_Lead2 Cap_Lead3 i.Year i.Identifier lnGDP　lnpop　polity2 group_age lnMilExp f_icrg, vce(cluster Identifier);
predict xb1;
predict u1, resid;
gen ustar1=-1*u1;
replace ustar1=1*u1 if runiform()>0.5;
gen ystar1=xb1+ustar1;
reg ystar1 Cap_Lag3 Cap_Lag2 Capture Cap_Lead1 Cap_Lead2 Cap_Lead3 i.Year i.Identifier lnGDP　lnpop　polity2 group_age lnMilExp f_icrg, vce(cluster Identifier);
end;
simulate _b _se, seed(0802) reps(999): bootwild;

//Find standard errors in Table//
mean _se_Cap_Lag3 _se_Cap_Lag2 _se_Capture _se_Cap_Lead1 _se_Cap_Lead2 _se_Cap_Lead3;

/* Find the significance */
gen tstr=((_b_Cap_Lag3)-(theta))/(_se_Cap_Lag3);
gen tstr1=((_b_Cap_Lag2)-(theta1))/(_se_Cap_Lag2);
gen tstr2=((_b_Capture)-(theta2))/(_se_Capture);
gen tstr3=((_b_Cap_Lead1)-(theta3))/(_se_Cap_Lead1);
gen tstr4=((_b_Cap_Lead2)-(theta4))/(_se_Cap_Lead2);
gen tstr5=((_b_Cap_Lead3)-(theta5))/(_se_Cap_Lead3);

//For Lagged 3// 
count if abs(theta/se)<abs(tstr);
dis "p-value=" r(N)/_N;

//For Lagged 2// 
count if abs(theta1/se1)<abs(tstr1);
dis "p-value=" r(N)/_N;

//For Kill// 
count if abs(theta2/se2)<abs(tstr2);
dis "p-value=" r(N)/_N;

//For Lead 1//  
count if abs(theta3/se3)<abs(tstr3);
dis "p-value=" r(N)/_N;

//For Lead 2// 
count if abs(theta4/se4)<abs(tstr4);
dis "p-value=" r(N)/_N;

//For Lead3// 
count if abs(theta5/se5)<abs(tstr5);
dis "p-value=" r(N)/_N;

program drop _all;
pause on;


/********************************************************************************
*      Model 3: Killing + Spatial Diffusion + Covariates (Transnational)		*
*********************************************************************************/

use "~/Data.dta", replace;

reg lnCountDomes Kill_Lag3 Kill_Lag2 Kill Kill_Lead1 Kill_Lead2 Kill_Lead3 wntt_sp_kill_l3 wntt_sp_kill_l2 wntt_sp_kill wntt_sp_kill_a1 wntt_sp_kill_a2 wntt_sp_kill_a3 i.Year i.Identifier lnGDP lnpop polity2 group_age lnMilExp f_icrg, vce(cluster Identifier);
estimates store re3; //For producing the regression table

/* Derive Wild Bootstrap Standard Errors */ 
//For wild bootstrap, I refered the stata codes by Cameron and Trevidi (2010)// 
scalar theta=_b[Kill_Lag3];
scalar theta1=_b[Kill_Lag2];
scalar theta2=_b[Kill];
scalar theta3=_b[Kill_Lead1];
scalar theta4=_b[Kill_Lead2];
scalar theta5=_b[Kill_Lead3];
scalar theta6=_b[wntt_sp_kill_l3];
scalar theta7=_b[wntt_sp_kill_l2];
scalar theta8=_b[wntt_sp_kill];
scalar theta9=_b[wntt_sp_kill_a1];
scalar theta10=_b[wntt_sp_kill_a2];
scalar theta11=_b[wntt_sp_kill_a3];
scalar se=_se[Kill_Lag3];
scalar se1=_se[Kill_Lag2];
scalar se2=_se[Kill];
scalar se3=_se[Kill_Lead1];
scalar se4=_se[Kill_Lead2];
scalar se5=_se[Kill_Lead3];
scalar se6=_se[wntt_sp_kill_l3];
scalar se7=_se[wntt_sp_kill_l2];
scalar se8=_se[wntt_sp_kill];
scalar se9=_se[wntt_sp_kill_a1];
scalar se10=_se[wntt_sp_kill_a2];
scalar se11=_se[wntt_sp_kill_a3];

program bootwild;
version 11;
drop _all;
use "~/Data.dta", replace;
reg lnCountDomes Kill_Lag3 Kill_Lag2 Kill Kill_Lead1 Kill_Lead2 Kill_Lead3 wntt_sp_kill_l3 wntt_sp_kill_l2 wntt_sp_kill wntt_sp_kill_a1 wntt_sp_kill_a2 wntt_sp_kill_a3 i.Year i.Identifier lnGDP lnpop polity2 group_age lnMilExp f_icrg, vce(cluster Identifier);
predict xb1;
predict u1, resid;
gen ustar1=-1*u1;
replace ustar1=1*u1 if runiform()>0.5;
gen ystar1=xb1+ustar1;
reg ystar1 Kill_Lag3 Kill_Lag2 Kill Kill_Lead1 Kill_Lead2 Kill_Lead3 wntt_sp_kill_l3 wntt_sp_kill_l2 wntt_sp_kill wntt_sp_kill_a1 wntt_sp_kill_a2 wntt_sp_kill_a3 i.Year i.Identifier lnGDP lnpop polity2 group_age lnMilExp f_icrg, vce(cluster Identifier);
end;
simulate _b _se, seed(0802) reps(999): bootwild;

//Find standard errors in Table//
mean _se_Kill_Lag3 _se_Kill_Lag2 _se_Kill _se_Kill_Lead1 _se_Kill_Lead2 _se_Kill_Lead3 _se_wntt_sp_kill_l3 _se_wntt_sp_kill_l2 _se_wntt_sp_kill _se_wntt_sp_kill_a1 _se_wntt_sp_kill_a2 _se_wntt_sp_kill_a3;

/* Find the significance */
gen tstr=((_b_Kill_Lag3)-(theta))/(_se_Kill_Lag3);
gen tstr1=((_b_Kill_Lag2)-(theta1))/(_se_Kill_Lag2);
gen tstr2=((_b_Kill)-(theta2))/(_se_Kill);
gen tstr3=((_b_Kill_Lead1)-(theta3))/(_se_Kill_Lead1);
gen tstr4=((_b_Kill_Lead2)-(theta4))/(_se_Kill_Lead2);
gen tstr5=((_b_Kill_Lead3)-(theta5))/(_se_Kill_Lead3);
gen tstr6=((_b_wntt_sp_kill_l3)-(theta6))/(_se_wntt_sp_kill_l3);
gen tstr7=((_b_wntt_sp_kill_l2)-(theta7))/(_se_wntt_sp_kill_l2);
gen tstr8=((_b_wntt_sp_kill)-(theta8))/(_se_wntt_sp_kill);
gen tstr9=((_b_wntt_sp_kill_a1)-(theta9))/(_se_wntt_sp_kill_a1);
gen tstr10=((_b_wntt_sp_kill_a2)-(theta10))/(_se_wntt_sp_kill_a2);
gen tstr11=((_b_wntt_sp_kill_a3)-(theta11))/(_se_wntt_sp_kill_a3);

//For Lagged 3// 
count if abs(theta/se)<abs(tstr);
dis "p-value=" r(N)/_N;

//For Lagged 2// 
count if abs(theta1/se1)<abs(tstr1);
dis "p-value=" r(N)/_N;

//For Kill// 
count if abs(theta2/se2)<abs(tstr2);
dis "p-value=" r(N)/_N;

//For Lead 1//  
count if abs(theta3/se3)<abs(tstr3);
dis "p-value=" r(N)/_N;

//For Lead 2// 
count if abs(theta4/se4)<abs(tstr4);
dis "p-value=" r(N)/_N;

//For Lead3// 
count if abs(theta5/se5)<abs(tstr5);
dis "p-value=" r(N)/_N;

/*For Lagged 3 for Spatial Neighbor*/ 
count if abs(theta6/se6)<abs(tstr6);
dis "p-value=" r(N)/_N;

/*For Lagged 2 for Spatial Neighbor*/ 
count if abs(theta7/se7)<abs(tstr7);
dis "p-value=" r(N)/_N;

/*For no lag for Spatial Neighbor*/ 
count if abs(theta8/se8)<abs(tstr8);
dis "p-value=" r(N)/_N;

/*For Lead 1 for Spatial Neighbor*/ 
count if abs(theta9/se9)<abs(tstr9);
dis "p-value=" r(N)/_N;

/*For Lead 2 for Spatial Neighbor*/ 
count if abs(theta10/se10)<abs(tstr10);
dis "p-value=" r(N)/_N;

/*For Lead 3 for Spatial Neighbor*/ 
count if abs(theta11/se11)<abs(tstr11);
dis "p-value=" r(N)/_N;

program drop _all;
pause on;


/********************************************************************************
*      Model 4: Capturing + Spatial Diffusion + Covariates (Transnational)		*
*********************************************************************************/

use "~/Data.dta", replace;

reg lnCountDomes Cap_Lag3 Cap_Lag2 Capture Cap_Lead1 Cap_Lead2 Cap_Lead3 wntt_sp_cap_l3 wntt_sp_cap_l2 wntt_sp_cap wntt_sp_cap_a1 wntt_sp_cap_a2 wntt_sp_cap_a3 i.Year i.Identifier lnGDP lnpop polity2 group_age lnMilExp f_icrg, vce(cluster Identifier);
estimates store re4; //For producing the regression table

/* Derive Wild Bootstrap Standard Errors */ 
//For wild bootstrap, I refered the stata codes by Cameron and Trevidi (2010)// 
scalar theta=_b[Cap_Lag3];
scalar theta1=_b[Cap_Lag2];
scalar theta2=_b[Capture];
scalar theta3=_b[Cap_Lead1];
scalar theta4=_b[Cap_Lead2];
scalar theta5=_b[Cap_Lead3];
scalar theta6=_b[wntt_sp_cap_l3];
scalar theta7=_b[wntt_sp_cap_l2];
scalar theta8=_b[wntt_sp_cap];
scalar theta9=_b[wntt_sp_cap_a1];
scalar theta10=_b[wntt_sp_cap_a2];
scalar theta11=_b[wntt_sp_cap_a3];
scalar se=_se[Cap_Lag3];
scalar se1=_se[Cap_Lag2];
scalar se2=_se[Capture];
scalar se3=_se[Cap_Lead1];
scalar se4=_se[Cap_Lead2];
scalar se5=_se[Cap_Lead3];
scalar se6=_se[wntt_sp_cap_l3];
scalar se7=_se[wntt_sp_cap_l2];
scalar se8=_se[wntt_sp_cap];
scalar se9=_se[wntt_sp_cap_a1];
scalar se10=_se[wntt_sp_cap_a2];
scalar se11=_se[wntt_sp_cap_a3];

program bootwild;
version 11;
drop _all;
use "~/Data.dta", replace;
reg lnCountDomes Cap_Lag3 Cap_Lag2 Capture Cap_Lead1 Cap_Lead2 Cap_Lead3 wntt_sp_cap_l3 wntt_sp_cap_l2 wntt_sp_cap wntt_sp_cap_a1 wntt_sp_cap_a2 wntt_sp_cap_a3 i.Year i.Identifier lnGDP lnpop polity2 group_age lnMilExp f_icrg, vce(cluster Identifier);
predict xb1;
predict u1, resid;
gen ustar1=-1*u1;
replace ustar1=1*u1 if runiform()>0.5;
gen ystar1=xb1+ustar1;
reg ystar1 Cap_Lag3 Cap_Lag2 Capture Cap_Lead1 Cap_Lead2 Cap_Lead3 wntt_sp_cap_l3 wntt_sp_cap_l2 wntt_sp_cap wntt_sp_cap_a1 wntt_sp_cap_a2 wntt_sp_cap_a3 i.Year i.Identifier lnGDP lnpop polity2 group_age lnMilExp f_icrg, vce(cluster Identifier);
end;
simulate _b _se, seed(0802) reps(999): bootwild;

//Find standard errors in Table//
mean _se_Cap_Lag3 _se_Cap_Lag2 _se_Capture _se_Cap_Lead1 _se_Cap_Lead2 _se_Cap_Lead3 _se_wntt_sp_cap_l3 _se_wntt_sp_cap_l2 _se_wntt_sp_cap _se_wntt_sp_cap_a1 _se_wntt_sp_cap_a2 _se_wntt_sp_cap_a3;

/* Find the significance */
gen tstr=((_b_Cap_Lag3)-(theta))/(_se_Cap_Lag3);
gen tstr1=((_b_Cap_Lag2)-(theta1))/(_se_Cap_Lag2);
gen tstr2=((_b_Capture)-(theta2))/(_se_Capture);
gen tstr3=((_b_Cap_Lead1)-(theta3))/(_se_Cap_Lead1);
gen tstr4=((_b_Cap_Lead2)-(theta4))/(_se_Cap_Lead2);
gen tstr5=((_b_Cap_Lead3)-(theta5))/(_se_Cap_Lead3);
gen tstr6=((_b_wntt_sp_cap_l3)-(theta6))/(_se_wntt_sp_cap_l3);
gen tstr7=((_b_wntt_sp_cap_l2)-(theta7))/(_se_wntt_sp_cap_l2);
gen tstr8=((_b_wntt_sp_cap)-(theta8))/(_se_wntt_sp_cap);
gen tstr9=((_b_wntt_sp_cap_a1)-(theta9))/(_se_wntt_sp_cap_a1);
gen tstr10=((_b_wntt_sp_cap_a2)-(theta10))/(_se_wntt_sp_cap_a2);
gen tstr11=((_b_wntt_sp_cap_a3)-(theta11))/(_se_wntt_sp_cap_a3);

//For Lagged 3// 
count if abs(theta/se)<abs(tstr);
dis "p-value=" r(N)/_N;

//For Lagged 2// 
count if abs(theta1/se1)<abs(tstr1);
dis "p-value=" r(N)/_N;

//For Capture// 
count if abs(theta2/se2)<abs(tstr2);
dis "p-value=" r(N)/_N;

//For Lead 1//  
count if abs(theta3/se3)<abs(tstr3);
dis "p-value=" r(N)/_N;

//For Lead 2// 
count if abs(theta4/se4)<abs(tstr4);
dis "p-value=" r(N)/_N;

//For Lead3// 
count if abs(theta5/se5)<abs(tstr5);
dis "p-value=" r(N)/_N;

/*For Lagged 3 for Spatial Neighbor*/ 
count if abs(theta6/se6)<abs(tstr6);
dis "p-value=" r(N)/_N;

/*For Lagged 2 for Spatial Neighbor*/ 
count if abs(theta7/se7)<abs(tstr7);
dis "p-value=" r(N)/_N;

/*For no lag for Spatial Neighbor*/ 
count if abs(theta8/se8)<abs(tstr8);
dis "p-value=" r(N)/_N;

/*For Lead 1 for Spatial Neighbor*/ 
count if abs(theta9/se9)<abs(tstr9);
dis "p-value=" r(N)/_N;

/*For Lead 2 for Spatial Neighbor*/ 
count if abs(theta10/se10)<abs(tstr10);
dis "p-value=" r(N)/_N;

/*For Lead 3 for Spatial Neighbor*/ 
count if abs(theta11/se11)<abs(tstr11);
dis "p-value=" r(N)/_N;

program drop _all;
pause on;

/********************************************************************************
*           Model 5: Killing + Alliance + Covariates (Transnational)		    *
*********************************************************************************/

use "~/Data.dta", replace;

reg lnCountTrans Kill_Lag3 Kill_Lag2 Kill Kill_Lead1 Kill_Lead2 Kill_Lead3 wntt_al_kill_l3 wntt_al_kill_l2 wntt_al_kill wntt_al_kill_a1 wntt_al_kill_a2 wntt_al_kill_a3 i.Year i.Identifier lnGDP lnpop polity2 group_age lnMilExp f_icrg, vce(cluster Identifier);
estimates store re5; //For producing the regression table

/* Derive Wild Bootstrap Standard Errors */ 
//For wild bootstrap, I refered the stata codes by Cameron and Trevidi (2010)// 
scalar theta=_b[Kill_Lag3];
scalar theta1=_b[Kill_Lag2];
scalar theta2=_b[Kill];
scalar theta3=_b[Kill_Lead1];
scalar theta4=_b[Kill_Lead2];
scalar theta5=_b[Kill_Lead3];
scalar theta6=_b[wntt_al_kill_l3];
scalar theta7=_b[wntt_al_kill_l2];
scalar theta8=_b[wntt_al_kill];
scalar theta9=_b[wntt_al_kill_a1];
scalar theta10=_b[wntt_al_kill_a2];
scalar theta11=_b[wntt_al_kill_a3];
scalar se=_se[Kill_Lag3];
scalar se1=_se[Kill_Lag2];
scalar se2=_se[Kill];
scalar se3=_se[Kill_Lead1];
scalar se4=_se[Kill_Lead2];
scalar se5=_se[Kill_Lead3];
scalar se6=_se[wntt_al_kill_l3];
scalar se7=_se[wntt_al_kill_l2];
scalar se8=_se[wntt_al_kill];
scalar se9=_se[wntt_al_kill_a1];
scalar se10=_se[wntt_al_kill_a2];
scalar se11=_se[wntt_al_kill_a3];

program bootwild;
version 11;
drop _all;
use "~/Data.dta", replace;
reg lnCountTrans Kill_Lag3 Kill_Lag2 Kill Kill_Lead1 Kill_Lead2 Kill_Lead3 wntt_al_kill_l3 wntt_al_kill_l2 wntt_al_kill wntt_al_kill_a1 wntt_al_kill_a2 wntt_al_kill_a3 i.Year i.Identifier lnGDP lnpop polity2 group_age lnMilExp f_icrg, vce(cluster Identifier);
predict xb1;
predict u1, resid;
gen ustar1=-1*u1;
replace ustar1=1*u1 if runiform()>0.5;
gen ystar1=xb1+ustar1;
reg ystar1 Kill_Lag3 Kill_Lag2 Kill Kill_Lead1 Kill_Lead2 Kill_Lead3 wntt_al_kill_l3 wntt_al_kill_l2 wntt_al_kill wntt_al_kill_a1 wntt_al_kill_a2 wntt_al_kill_a3 i.Year i.Identifier lnGDP lnpop polity2 group_age lnMilExp f_icrg, vce(cluster Identifier);
end;
simulate _b _se, seed(0802) reps(999): bootwild;

//Find standard errors in Table//
mean _se_Kill_Lag3 _se_Kill_Lag2 _se_Kill _se_Kill_Lead1 _se_Kill_Lead2 _se_Kill_Lead3 _se_wntt_al_kill_l3 _se_wntt_al_kill_l2 _se_wntt_al_kill _se_wntt_al_kill_a1 _se_wntt_al_kill_a2 _se_wntt_al_kill_a3;

/* Find the significance */
gen tstr=((_b_Kill_Lag3)-(theta))/(_se_Kill_Lag3);
gen tstr1=((_b_Kill_Lag2)-(theta1))/(_se_Kill_Lag2);
gen tstr2=((_b_Kill)-(theta2))/(_se_Kill);
gen tstr3=((_b_Kill_Lead1)-(theta3))/(_se_Kill_Lead1);
gen tstr4=((_b_Kill_Lead2)-(theta4))/(_se_Kill_Lead2);
gen tstr5=((_b_Kill_Lead3)-(theta5))/(_se_Kill_Lead3);
gen tstr6=((_b_wntt_al_kill_l3)-(theta6))/(_se_wntt_al_kill_l3);
gen tstr7=((_b_wntt_al_kill_l2)-(theta7))/(_se_wntt_al_kill_l2);
gen tstr8=((_b_wntt_al_kill)-(theta8))/(_se_wntt_al_kill);
gen tstr9=((_b_wntt_al_kill_a1)-(theta9))/(_se_wntt_al_kill_a1);
gen tstr10=((_b_wntt_al_kill_a2)-(theta10))/(_se_wntt_al_kill_a2);
gen tstr11=((_b_wntt_al_kill_a3)-(theta11))/(_se_wntt_al_kill_a3);

//For Lagged 3// 
count if abs(theta/se)<abs(tstr);
dis "p-value=" r(N)/_N;

//For Lagged 2// 
count if abs(theta1/se1)<abs(tstr1);
dis "p-value=" r(N)/_N;

//For Killing// 
count if abs(theta2/se2)<abs(tstr2);
dis "p-value=" r(N)/_N;

//For Lead 1//  
count if abs(theta3/se3)<abs(tstr3);
dis "p-value=" r(N)/_N;

//For Lead 2// 
count if abs(theta4/se4)<abs(tstr4);
dis "p-value=" r(N)/_N;

//For Lead3// 
count if abs(theta5/se5)<abs(tstr5);
dis "p-value=" r(N)/_N;

/*For Lagged 3 for Alliance Partner*/ 
count if abs(theta6/se6)<abs(tstr6);
dis "p-value=" r(N)/_N;

/*For Lagged 2 for Alliance Partner*/ 
count if abs(theta7/se7)<abs(tstr7);
dis "p-value=" r(N)/_N;

/*For no lag for Alliance Partner*/ 
count if abs(theta8/se8)<abs(tstr8);
dis "p-value=" r(N)/_N;

/*For Lead 1 for Alliance Partner*/ 
count if abs(theta9/se9)<abs(tstr9);
dis "p-value=" r(N)/_N;

/*For Lead 2 for Alliance Partner*/ 
count if abs(theta10/se10)<abs(tstr10);
dis "p-value=" r(N)/_N;

/*For Lead 3 for Alliance Partner*/ 
count if abs(theta11/se11)<abs(tstr11);
dis "p-value=" r(N)/_N;

program drop _all;
pause on;


/********************************************************************************
*          Model 6: Capturing + Alliance + Covariates (Transnational)		    *
*********************************************************************************/

use "~/Data.dta", replace;

reg lnCountTrans Cap_Lag3 Cap_Lag2 Capture Cap_Lead1 Cap_Lead2 Cap_Lead3 wntt_al_cap_l3 wntt_al_cap_l2 wntt_al_cap wntt_al_cap_a1 wntt_al_cap_a2 wntt_al_cap_a3 i.Year i.Identifier lnGDP lnpop polity2 group_age lnMilExp f_icrg, vce(cluster Identifier);
estimates store re6; //For producing the regression table

/* Derive Wild Bootstrap Standard Errors */ 
//For wild bootstrap, I refered the stata codes by Cameron and Trevidi (2010)// 
scalar theta=_b[Cap_Lag3];
scalar theta1=_b[Cap_Lag2];
scalar theta2=_b[Capture];
scalar theta3=_b[Cap_Lead1];
scalar theta4=_b[Cap_Lead2];
scalar theta5=_b[Cap_Lead3];
scalar theta6=_b[wntt_al_cap_l3];
scalar theta7=_b[wntt_al_cap_l2];
scalar theta8=_b[wntt_al_cap];
scalar theta9=_b[wntt_al_cap_a1];
scalar theta10=_b[wntt_al_cap_a2];
scalar theta11=_b[wntt_al_cap_a3];
scalar se=_se[Cap_Lag3];
scalar se1=_se[Cap_Lag2];
scalar se2=_se[Capture];
scalar se3=_se[Cap_Lead1];
scalar se4=_se[Cap_Lead2];
scalar se5=_se[Cap_Lead3];
scalar se6=_se[wntt_al_cap_l3];
scalar se7=_se[wntt_al_cap_l2];
scalar se8=_se[wntt_al_cap];
scalar se9=_se[wntt_al_cap_a1];
scalar se10=_se[wntt_al_cap_a2];
scalar se11=_se[wntt_al_cap_a3];

program bootwild;
version 11;
drop _all;
use "~/Data.dta", replace;
reg lnCountTrans Cap_Lag3 Cap_Lag2 Capture Cap_Lead1 Cap_Lead2 Cap_Lead3 wntt_al_cap_l3 wntt_al_cap_l2 wntt_al_cap wntt_al_cap_a1 wntt_al_cap_a2 wntt_al_cap_a3 i.Year i.Identifier lnGDP lnpop polity2 group_age lnMilExp f_icrg, vce(cluster Identifier);
predict xb1;
predict u1, resid;
gen ustar1=-1*u1;
replace ustar1=1*u1 if runiform()>0.5;
gen ystar1=xb1+ustar1;
reg ystar1 Cap_Lag3 Cap_Lag2 Capture Cap_Lead1 Cap_Lead2 Cap_Lead3 wntt_al_cap_l3 wntt_al_cap_l2 wntt_al_cap wntt_al_cap_a1 wntt_al_cap_a2 wntt_al_cap_a3 i.Year i.Identifier lnGDP lnpop polity2 group_age lnMilExp f_icrg, vce(cluster Identifier);
end ;
simulate _b _se, seed(0802) reps(999): bootwild;

//Find standard errors in Table//
mean _se_Cap_Lag3 _se_Cap_Lag2 _se_Capture _se_Cap_Lead1 _se_Cap_Lead2 _se_Cap_Lead3 _se_wntt_al_cap_l3 _se_wntt_al_cap_l2 _se_wntt_al_cap _se_wntt_al_cap_a1 _se_wntt_al_cap_a2 _se_wntt_al_cap_a3;

/* Find the significance */
gen tstr=((_b_Cap_Lag3)-(theta))/(_se_Cap_Lag3);
gen tstr1=((_b_Cap_Lag2)-(theta1))/(_se_Cap_Lag2);
gen tstr2=((_b_Capture)-(theta2))/(_se_Capture);
gen tstr3=((_b_Cap_Lead1)-(theta3))/(_se_Cap_Lead1);
gen tstr4=((_b_Cap_Lead2)-(theta4))/(_se_Cap_Lead2);
gen tstr5=((_b_Cap_Lead3)-(theta5))/(_se_Cap_Lead3);
gen tstr6=((_b_wntt_al_cap_l3)-(theta6))/(_se_wntt_al_cap_l3);
gen tstr7=((_b_wntt_al_cap_l2)-(theta7))/(_se_wntt_al_cap_l2);
gen tstr8=((_b_wntt_al_cap)-(theta8))/(_se_wntt_al_cap);
gen tstr9=((_b_wntt_al_cap_a1)-(theta9))/(_se_wntt_al_cap_a1);
gen tstr10=((_b_wntt_al_cap_a2)-(theta10))/(_se_wntt_al_cap_a2);
gen tstr11=((_b_wntt_al_cap_a3)-(theta11))/(_se_wntt_al_cap_a3);

//For Lagged 3// 
count if abs(theta/se)<abs(tstr);
dis "p-value=" r(N)/_N;

//For Lagged 2// 
count if abs(theta1/se1)<abs(tstr1);
dis "p-value=" r(N)/_N;

//For Capture// 
count if abs(theta2/se2)<abs(tstr2);
dis "p-value=" r(N)/_N;

//For Lead 1//  
count if abs(theta3/se3)<abs(tstr3);
dis "p-value=" r(N)/_N;

//For Lead 2// 
count if abs(theta4/se4)<abs(tstr4);
dis "p-value=" r(N)/_N;

//For Lead3// 
count if abs(theta5/se5)<abs(tstr5);
dis "p-value=" r(N)/_N;

/*For Lagged 3 for Spatial Neighbor*/ 
count if abs(theta6/se6)<abs(tstr6);
dis "p-value=" r(N)/_N;

/*For Lagged 2 for Spatial Neighbor*/ 
count if abs(theta7/se7)<abs(tstr7);
dis "p-value=" r(N)/_N;

/*For no lag for Spatial Neighbor*/ 
count if abs(theta8/se8)<abs(tstr8);
dis "p-value=" r(N)/_N;

/*For Lead 1 for Spatial Neighbor*/ 
count if abs(theta9/se9)<abs(tstr9);
dis "p-value=" r(N)/_N;

/*For Lead 2 for Spatial Neighbor*/ 
count if abs(theta10/se10)<abs(tstr10);
dis "p-value=" r(N)/_N;

/*For Lead 3 for Spatial Neighbor*/ 
count if abs(theta11/se11)<abs(tstr11);
dis "p-value=" r(N)/_N;

program drop _all;
pause on;

/********************************************************************************
*   Model 7: Capturing + Spatial Neighbor + Alliance + Covariates (Domestic)	*
*********************************************************************************/

use "~/Data.dta", replace;

reg lnCountDomes Cap_Lag3 Cap_Lag2 Capture Cap_Lead1 Cap_Lead2 Cap_Lead3 wntt_spal_cap_l3 wntt_spal_cap_l2 wntt_spal_cap wntt_spal_cap_a1 wntt_spal_cap_a2 wntt_spal_cap_a3 i.Year i.Identifier lnGDP lnpop polity2 group_age lnMilExp f_icrg, vce(cluster Identifier);
estimates store re7; //For producing the regression table

/* Derive Wild Bootstrap Standard Errors */ 
//For wild bootstrap, I refered the stata codes by Cameron and Trevidi (2010)// 
scalar theta=_b[Cap_Lag3];
scalar theta1=_b[Cap_Lag2];
scalar theta2=_b[Capture];
scalar theta3=_b[Cap_Lead1];
scalar theta4=_b[Cap_Lead2];
scalar theta5=_b[Cap_Lead3];
scalar theta6=_b[wntt_spal_cap_l3];
scalar theta7=_b[wntt_spal_cap_l2];
scalar theta8=_b[wntt_spal_cap];
scalar theta9=_b[wntt_spal_cap_a1];
scalar theta10=_b[wntt_spal_cap_a2];
scalar theta11=_b[wntt_spal_cap_a3];
scalar se=_se[Cap_Lag3];
scalar se1=_se[Cap_Lag2];
scalar se2=_se[Capture];
scalar se3=_se[Cap_Lead1];
scalar se4=_se[Cap_Lead2];
scalar se5=_se[Cap_Lead3];
scalar se6=_se[wntt_spal_cap_l3];
scalar se7=_se[wntt_spal_cap_l2];
scalar se8=_se[wntt_spal_cap];
scalar se9=_se[wntt_spal_cap_a1];
scalar se10=_se[wntt_spal_cap_a2];
scalar se11=_se[wntt_spal_cap_a3];

program bootwild;
version 11;
drop _all;
use "~/Data.dta", replace;
reg lnCountDomes Cap_Lag3 Cap_Lag2 Capture Cap_Lead1 Cap_Lead2 Cap_Lead3 wntt_spal_cap_l3 wntt_spal_cap_l2 wntt_spal_cap wntt_spal_cap_a1 wntt_spal_cap_a2 wntt_spal_cap_a3 i.Year i.Identifier lnGDP lnpop polity2 group_age lnMilExp f_icrg, vce(cluster Identifier);
predict xb1;
predict u1, resid;
gen ustar1=-1*u1;
replace ustar1=1*u1 if runiform()>0.5;
gen ystar1=xb1+ustar1;
reg ystar1 Cap_Lag3 Cap_Lag2 Capture Cap_Lead1 Cap_Lead2 Cap_Lead3 wntt_spal_cap_l3 wntt_spal_cap_l2 wntt_spal_cap wntt_spal_cap_a1 wntt_spal_cap_a2 wntt_spal_cap_a3 i.Year i.Identifier lnGDP lnpop polity2 group_age lnMilExp f_icrg, vce(cluster Identifier);
end;
simulate _b _se, seed(0802) reps(999): bootwild;

//Find standard errors in Table//
mean _se_Cap_Lag3 _se_Cap_Lag2 _se_Capture _se_Cap_Lead1 _se_Cap_Lead2 _se_Cap_Lead3 _se_wntt_spal_cap_l3 _se_wntt_spal_cap_l2 _se_wntt_spal_cap _se_wntt_spal_cap_a1 _se_wntt_spal_cap_a2 _se_wntt_spal_cap_a3;

/* Find the significance */
gen tstr=((_b_Cap_Lag3)-(theta))/(_se_Cap_Lag3);
gen tstr1=((_b_Cap_Lag2)-(theta1))/(_se_Cap_Lag2);
gen tstr2=((_b_Capture)-(theta2))/(_se_Capture);
gen tstr3=((_b_Cap_Lead1)-(theta3))/(_se_Cap_Lead1);
gen tstr4=((_b_Cap_Lead2)-(theta4))/(_se_Cap_Lead2);
gen tstr5=((_b_Cap_Lead3)-(theta5))/(_se_Cap_Lead3);
gen tstr6=((_b_wntt_spal_cap_l3)-(theta6))/(_se_wntt_spal_cap_l3);
gen tstr7=((_b_wntt_spal_cap_l2)-(theta7))/(_se_wntt_spal_cap_l2);
gen tstr8=((_b_wntt_spal_cap)-(theta8))/(_se_wntt_spal_cap);
gen tstr9=((_b_wntt_spal_cap_a1)-(theta9))/(_se_wntt_spal_cap_a1);
gen tstr10=((_b_wntt_spal_cap_a2)-(theta10))/(_se_wntt_spal_cap_a2);
gen tstr11=((_b_wntt_spal_cap_a3)-(theta11))/(_se_wntt_spal_cap_a3);

//For Lagged 3// 
count if abs(theta/se)<abs(tstr);
dis "p-value=" r(N)/_N;

//For Lagged 2// 
count if abs(theta1/se1)<abs(tstr1);
dis "p-value=" r(N)/_N;

//For Capture// 
count if abs(theta2/se2)<abs(tstr2);
dis "p-value=" r(N)/_N;

//For Lead 1//  
count if abs(theta3/se3)<abs(tstr3);
dis "p-value=" r(N)/_N;

//For Lead 2// 
count if abs(theta4/se4)<abs(tstr4);
dis "p-value=" r(N)/_N;

//For Lead3// 
count if abs(theta5/se5)<abs(tstr5);
dis "p-value=" r(N)/_N;

/*For Lagged 3 for Spatial Alliance Neighbor*/ 
count if abs(theta6/se6)<abs(tstr6);
dis "p-value=" r(N)/_N;

/*For Lagged 2 for Spatial Alliance Neighbor*/ 
count if abs(theta7/se7)<abs(tstr7);
dis "p-value=" r(N)/_N;

/*For no lag for Spatial Alliance Neighbor*/ 
count if abs(theta8/se8)<abs(tstr8);
dis "p-value=" r(N)/_N;

/*For Lead 1 for Spatial Alliance Neighbor*/ 
count if abs(theta9/se9)<abs(tstr9);
dis "p-value=" r(N)/_N;

/*For Lead 2 for Spatial Alliance Neighbor*/ 
count if abs(theta10/se10)<abs(tstr10);
dis "p-value=" r(N)/_N;

/*For Lead 3 for Spatial Alliance Neighbor*/ 
count if abs(theta11/se11)<abs(tstr11);
dis "p-value=" r(N)/_N;

program drop _all;
pause on;


/********************************************************************************
*            Model 8: Killing + Enemy + Covariates (Transnational)		        *
*********************************************************************************/

use "~/Data.dta", replace;

reg lnCountTrans Kill_Lag3 Kill_Lag2 Kill Kill_Lead1 Kill_Lead2 Kill_Lead3 wntt_en_kill_l3 wntt_en_kill_l2 wntt_en_kill wntt_en_kill_a1 wntt_en_kill_a2 wntt_en_kill_a3 i.Year i.Identifier lnGDP lnpop polity2 group_age lnMilExp f_icrg, vce(cluster Identifier);
estimates store re8; //For producing the regression table

/* Derive Wild Bootstrap Standard Errors */ 
//For wild bootstrap, I refered the stata codes by Cameron and Trevidi (2010)// 
scalar theta=_b[Kill_Lag3];
scalar theta1=_b[Kill_Lag2];
scalar theta2=_b[Kill];
scalar theta3=_b[Kill_Lead1];
scalar theta4=_b[Kill_Lead2];
scalar theta5=_b[Kill_Lead3];
scalar theta6=_b[wntt_en_kill_l3];
scalar theta7=_b[wntt_en_kill_l2];
scalar theta8=_b[wntt_en_kill];
scalar theta9=_b[wntt_en_kill_a1];
scalar theta10=_b[wntt_en_kill_a2];
scalar theta11=_b[wntt_en_kill_a3];
scalar se=_se[Kill_Lag3];
scalar se1=_se[Kill_Lag2];
scalar se2=_se[Kill];
scalar se3=_se[Kill_Lead1];
scalar se4=_se[Kill_Lead2];
scalar se5=_se[Kill_Lead3];
scalar se6=_se[wntt_en_kill_l3];
scalar se7=_se[wntt_en_kill_l2];
scalar se8=_se[wntt_en_kill];
scalar se9=_se[wntt_en_kill_a1];
scalar se10=_se[wntt_en_kill_a2];
scalar se11=_se[wntt_en_kill_a3];

program bootwild;
version 11;
drop _all;
use "~/Data.dta", replace;
reg lnCountTrans Kill_Lag3 Kill_Lag2 Kill Kill_Lead1 Kill_Lead2 Kill_Lead3 wntt_en_kill_l3 wntt_en_kill_l2 wntt_en_kill wntt_en_kill_a1 wntt_en_kill_a2 wntt_en_kill_a3 i.Year i.Identifier lnGDP lnpop polity2 group_age lnMilExp f_icrg, vce(cluster Identifier);
predict xb1;
predict u1, resid;
gen ustar1=-1*u1;
replace ustar1=1*u1 if runiform()>0.5;
gen ystar1=xb1+ustar1;
reg ystar1 Kill_Lag3 Kill_Lag2 Kill Kill_Lead1 Kill_Lead2 Kill_Lead3 wntt_en_kill_l3 wntt_en_kill_l2 wntt_en_kill wntt_en_kill_a1 wntt_en_kill_a2 wntt_en_kill_a3 i.Year i.Identifier lnGDP lnpop polity2 group_age lnMilExp f_icrg, vce(cluster Identifier);
end;
simulate _b _se, seed(0802) reps(999): bootwild;

//Find standard errors in Table//
mean _se_Kill_Lag3 _se_Kill_Lag2 _se_Kill _se_Kill_Lead1 _se_Kill_Lead2 _se_Kill_Lead3 _se_wntt_en_kill_l3 _se_wntt_en_kill_l2 _se_wntt_en_kill _se_wntt_en_kill_a1 _se_wntt_en_kill_a2 _se_wntt_en_kill_a3;

/* Find the significance */
gen tstr=((_b_Kill_Lag3)-(theta))/(_se_Kill_Lag3);
gen tstr1=((_b_Kill_Lag2)-(theta1))/(_se_Kill_Lag2);
gen tstr2=((_b_Kill)-(theta2))/(_se_Kill);
gen tstr3=((_b_Kill_Lead1)-(theta3))/(_se_Kill_Lead1);
gen tstr4=((_b_Kill_Lead2)-(theta4))/(_se_Kill_Lead2);
gen tstr5=((_b_Kill_Lead3)-(theta5))/(_se_Kill_Lead3);
gen tstr6=((_b_wntt_en_kill_l3)-(theta6))/(_se_wntt_en_kill_l3);
gen tstr7=((_b_wntt_en_kill_l2)-(theta7))/(_se_wntt_en_kill_l2);
gen tstr8=((_b_wntt_en_kill)-(theta8))/(_se_wntt_en_kill);
gen tstr9=((_b_wntt_en_kill_a1)-(theta9))/(_se_wntt_en_kill_a1);
gen tstr10=((_b_wntt_en_kill_a2)-(theta10))/(_se_wntt_en_kill_a2);
gen tstr11=((_b_wntt_en_kill_a3)-(theta11))/(_se_wntt_en_kill_a3);

//For Lagged 3// 
count if abs(theta/se)<abs(tstr);
dis "p-value=" r(N)/_N;

//For Lagged 2// 
count if abs(theta1/se1)<abs(tstr1);
dis "p-value=" r(N)/_N;

//For Killing// 
count if abs(theta2/se2)<abs(tstr2);
dis "p-value=" r(N)/_N;

//For Lead 1//  
count if abs(theta3/se3)<abs(tstr3);
dis "p-value=" r(N)/_N;

//For Lead 2// 
count if abs(theta4/se4)<abs(tstr4);
dis "p-value=" r(N)/_N;

//For Lead3// 
count if abs(theta5/se5)<abs(tstr5);
dis "p-value=" r(N)/_N;

/*For Lagged 3 for Enemy Group*/ 
count if abs(theta6/se6)<abs(tstr6);
dis "p-value=" r(N)/_N;

/*For Lagged 2 for Enemy Group*/ 
count if abs(theta7/se7)<abs(tstr7);
dis "p-value=" r(N)/_N;

/*For no lag for Enemy Group*/ 
count if abs(theta8/se8)<abs(tstr8);
dis "p-value=" r(N)/_N;

/*For Lead 1 for Enemy Group*/ 
count if abs(theta9/se9)<abs(tstr9);
dis "p-value=" r(N)/_N;

/*For Lead 2 for Enemy Group*/ 
count if abs(theta10/se10)<abs(tstr10);
dis "p-value=" r(N)/_N;

/*For Lead 3 for Enemy Group*/ 
count if abs(theta11/se11)<abs(tstr11);
dis "p-value=" r(N)/_N;

program drop _all;
pause on;


/********************************************************************************
*            Model 9: Capturing + Enemy + Covariates (Transnational)		    *
*********************************************************************************/

use "~/Data.dta", replace;

reg lnCountTrans Cap_Lag3 Cap_Lag2 Capture Cap_Lead1 Cap_Lead2 Cap_Lead3 wntt_en_cap_n3 wntt_en_cap_n2 wntt_en_cap wntt_en_cap_a1 wntt_en_cap_a2 wntt_en_cap_a3 i.Year i.Identifier lnGDP lnpop polity2 group_age lnMilExp f_icrg, vce(cluster Identifier);
estimates store re9; //For producing the regression table

/* Derive Wild Bootstrap Standard Errors */ 
//For wild bootstrap, I refered the stata codes by Cameron and Trevidi (2010)// 
scalar theta=_b[Cap_Lag3];
scalar theta1=_b[Cap_Lag2];
scalar theta2=_b[Capture];
scalar theta3=_b[Cap_Lead1];
scalar theta4=_b[Cap_Lead2];
scalar theta5=_b[Cap_Lead3];
scalar theta6=_b[wntt_en_cap_l3];
scalar theta7=_b[wntt_en_cap_l2];
scalar theta8=_b[wntt_en_cap];
scalar theta9=_b[wntt_en_cap_a1];
scalar theta10=_b[wntt_en_cap_a2];
scalar theta11=_b[wntt_en_cap_a3];
scalar se=_se[Cap_Lag3];
scalar se1=_se[Cap_Lag2];
scalar se2=_se[Capture];
scalar se3=_se[Cap_Lead1];
scalar se4=_se[Cap_Lead2];
scalar se5=_se[Cap_Lead3];
scalar se6=_se[wntt_en_cap_l3];
scalar se7=_se[wntt_en_cap_l2];
scalar se8=_se[wntt_en_cap];
scalar se9=_se[wntt_en_cap_a1];
scalar se10=_se[wntt_en_cap_a2];
scalar se11=_se[wntt_en_cap_a3];

program bootwild;
version 11;
drop _all;
use "~/Data.dta", replace;
reg lnCountTrans Cap_Lag3 Cap_Lag2 Capture Cap_Lead1 Cap_Lead2 Cap_Lead3 wntt_en_cap_n3 wntt_en_cap_n2 wntt_en_cap wntt_en_cap_a1 wntt_en_cap_a2 wntt_en_cap_a3 i.Year i.Identifier lnGDP lnpop polity2 group_age lnMilExp f_icrg, vce(cluster Identifier);
predict xb1;
predict u1, resid;
gen ustar1=-1*u1;
replace ustar1=1*u1 if runiform()>0.5;
gen ystar1=xb1+ustar1;
reg ystar1 Cap_Lag3 Cap_Lag2 Capture Cap_Lead1 Cap_Lead2 Cap_Lead3 wntt_en_cap_n3 wntt_en_cap_n2 wntt_en_cap wntt_en_cap_a1 wntt_en_cap_a2 wntt_en_cap_a3 i.Year i.Identifier lnGDP lnpop polity2 group_age lnMilExp f_icrg, vce(cluster Identifier);
end;
simulate _b _se, seed(0802) reps(999): bootwild;

//Find standard errors in Table//
mean _se_Cap_Lag3 _se_Cap_Lag2 _se_Capture _se_Cap_Lead1 _se_Cap_Lead2 _se_Cap_Lead3 _se_wntt_en_cap_n3 _se_wntt_en_cap_n2 _se_wntt_en_cap _se_wntt_en_cap_a1 _se_wntt_en_cap_a2 _se_wntt_en_cap_a3;

/* Find the significance */
gen tstr=((_b_Cap_Lag3)-(theta))/(_se_Cap_Lag3);
gen tstr1=((_b_Cap_Lag2)-(theta1))/(_se_Cap_Lag2);
gen tstr2=((_b_Capture)-(theta2))/(_se_Capture);
gen tstr3=((_b_Cap_Lead1)-(theta3))/(_se_Cap_Lead1);
gen tstr4=((_b_Cap_Lead2)-(theta4))/(_se_Cap_Lead2);
gen tstr5=((_b_Cap_Lead3)-(theta5))/(_se_Cap_Lead3);
gen tstr6=((_b_wntt_en_cap_l3)-(theta6))/(_se_wntt_en_cap_l3);
gen tstr7=((_b_wntt_en_cap_l2)-(theta7))/(_se_wntt_en_cap_l2);
gen tstr8=((_b_wntt_en_cap)-(theta8))/(_se_wntt_en_cap);
gen tstr9=((_b_wntt_en_cap_a1)-(theta9))/(_se_wntt_en_cap_a1);
gen tstr10=((_b_wntt_en_cap_a2)-(theta10))/(_se_wntt_en_cap_a2);
gen tstr11=((_b_wntt_en_cap_a3)-(theta11))/(_se_wntt_en_cap_a3);

//For Lagged 3// 
count if abs(theta/se)<abs(tstr);
dis "p-value=" r(N)/_N;

//For Lagged 2// 
count if abs(theta1/se1)<abs(tstr1);
dis "p-value=" r(N)/_N;

//For Capture// 
count if abs(theta2/se2)<abs(tstr2);
dis "p-value=" r(N)/_N;

//For Lead 1//  
count if abs(theta3/se3)<abs(tstr3);
dis "p-value=" r(N)/_N;

//For Lead 2// 
count if abs(theta4/se4)<abs(tstr4);
dis "p-value=" r(N)/_N;

//For Lead3// 
count if abs(theta5/se5)<abs(tstr5);
dis "p-value=" r(N)/_N;

/*For Lagged 3 for Enemy Group*/ 
count if abs(theta6/se6)<abs(tstr6);
dis "p-value=" r(N)/_N;

/*For Lagged 2 for Enemy Group*/ 
count if abs(theta7/se7)<abs(tstr7);
dis "p-value=" r(N)/_N;

/*For no lag for Enemy Group*/ 
count if abs(theta8/se8)<abs(tstr8);
dis "p-value=" r(N)/_N;

/*For Lead 1 for Enemy Group*/ 
count if abs(theta9/se9)<abs(tstr9);
dis "p-value=" r(N)/_N;

/*For Lead 2 for Enemy Group*/ 
count if abs(theta10/se10)<abs(tstr10);
dis "p-value=" r(N)/_N;

/*For Lead 3 for Enemy Group*/ 
count if abs(theta11/se11)<abs(tstr11);
dis "p-value=" r(N)/_N;

program drop _all;
pause on;


/********************************************************************************
*   						       Table 	 		                            *
*********************************************************************************/

//Table 1//
estimates table re1a re1b re3 re2a re2b, star stats(aic bic N r2 r2_a F);

//Table 2//
estimates table re3 re4 re5 re6 re7, star stats(aic bic N r2 r2_a F);

//Table 3//
estimates table re8 re9b, star stats(aic bic N r2 r2_a F);

pause;


//-----------------------------------------------------------------------------//




/***************************************************************************
*																		   *
*							    R code 								       *
*																		   *
****************************************************************************/


/***************************************************************************
* Data2 contains the results (coefficients and confidence interval of      *
*  regression analysis and series of variables that are used for producing *														   
*  Figures in the manuscript.   					       				   * 
****************************************************************************/


library(googleVis)
library(plotrix)
library(lattice)
library(ggplot2)
library(oce)

setwd(~/)
load("Data2.RData")
ls(all.names=T) # lis all variables stored (Coefficients and standard errors are obtained from the analysis above)

//* Figure 1 a *//

col2_1$Date <- as.yearmon(col2_1$Date)
col2_1$Date <- as.Date(col2_1$Date)
col2_2$Date <- as.yearmon(col2_2$Date)
col2_2$Date <- as.Date(col2_2$Date)

par(mar=c(4.5,4.5,2.7,2.5)+.1, cex.main = 2.2, cex.axis = 2.2, cex.lab = 2.2, xaxt="n")
plot(x=col2_1$Date, y=col2_1$count.sum, ylim=c(0, 25), axes=FALSE, ylab="Numbers of Militant Attacks (per month)",
     xlab="Date", main="", cex.axis=2.2)
axis(side=2)
par(xaxt = "s")
axis.Date(1, at = seq(min(col2_1$Date), max(col2_1$Date),"months"),format = "%Y/%m")


abline(v=as.Date("1981-03-15"), lty=3, lwd=1, col="blue")
abline(h=0, lty=2, lwd=1, col="gray60")

points(x=col2_1$Date, y=col2_1$count.sum, pch=19)
points(x=col2_2$Date, y=col2_2$count.sum, pch=18, col="red")
lines(x=col2_1$Date, y=col2_1$count.sum)
lines(x=col2_2$Date, y=col2_2$count.sum, lty="dashed", col="red")
text(as.Date("1981-03-18"), 25, paste("Capturing of Carlos Toledo Plata"), pos = 4, cex=2.2)
text(as.Date("1981-03-18"), 23, paste("(Mid-March 1981)"), pos = 4, cex=2)
legend("topright", legend = c("M-19", "Other Groups"), pch = c(19, 18), lty=c(1,3), col=c(1,2),cex=2.2)


//* Figure 1 b *//

is2_1$Date <- as.yearmon(is2_1$Date)
is2_1$Date <- as.Date(is2_1$Date)
is2_2$Date <- as.yearmon(is2_2$Date)
is2_2$Date <- as.Date(is2_2$Date)

plot(x=is2_1$Date, y=is2_1$count.sum, 
     ylim=c(0, 35), axes=FALSE, ylab="Numbers of Militant Attacks (per month)",
     xlab="Date", main="", cex.axis=2.2)
axis(side=2)
par(xaxt = "s")
axis.Date(1, at = seq(min(is2_1$Date), max(is2_1$Date),"months"),format = "%Y/%m")


abline(v=as.Date("2008-02-12"), lty=3, lwd=1, col="blue")
abline(h=0, lty=2, lwd=1, col="gray60")

points(x=is2_1$Date, y=is2_1$count.sum, pch=19)
points(x=is2_2$Date, y=is2_2$count.sum, pch=18, col="red")
lines(x=is2_1$Date, y=is2_1$count.sum)
lines(x=is2_2$Date, y=is2_2$count.sum, lty="dashed", col="red")
text(as.Date("2007-08-20"), 35, paste("Killing of Imad Fayez Mughniyeh"), pos = 4, cex=2.2)
text(as.Date("2007-08-20"), 32.5, paste("(12th February 2008)"), pos = 4, cex=2.2)
legend("topright", legend = c("Hizballah-related", "Other Groups"), pch = c(19, 18), lty=c(1,3), col=c(1,2),cex=2.2)


//* Figure 2 *// 

cols <- c("grey10", "grey15", "grey20", "grey25", "grey30", "grey35", "grey40", "grey45", "grey50",
          "grey55", "grey60", "grey65", "grey70", "grey75", "grey80", "grey85", "grey90")
pie3D(decap1$decap1,labels=decap1$X,explode=0.08,main="Targeted Killing (1970-2008)",col=cols,labelcex=0.9,title="Targeted Killing (1970-2008)")


cols2 <- c("grey10", "grey15", "grey20", "grey25", "grey30", "grey35", "grey40", "grey45", "grey50",
          "grey55", "grey60", "grey65", "grey70", "grey75", "grey80", "grey85", "grey90", "grey90", "grey90")
pie3D(decap2$decap2,labels=decap2$X,explode=0.08,main="Targeted Capturing (1970-2008)",col=cols2,labelcex=0.9,title="Targeted Killing (1970-2008)")

dev.new(width=6, height=4)
dd$Year <- as.factor(dd$year)       
LL <- barchart(kill1~Year, data = dd, cex=2,
              groups = tac, stack = TRUE,  
              between = list(y=0.5),
              lty=1, horizontal=F, ylim=c(0,13),
              ylab=list(label="Numbers of Decapitation", fontface="bold", size=0.8, cex=2), 
              xlab=list(fontface="bold", cex=2),
              par.settings=list(superpose.polygon=list(col=gray(c(0.3,0.9))),
              grid.pars = list(fontfamily = 'serif', fontface = "bold", cex=0.5)),
              auto.key=list(corner=c(0.5,0.95), columns=2, fontface="bold", density=2, angle=45, cex=2))
print(LL)



//* Figure 3 *// 

//Figure 3 was manually created// 



//* Figure 4 *//
Year <- 1970:2008

par(mar=c(4.5,4.6,2.5,1)+.1, cex.main = 1.5, cex.axis = 1.5, cex.lab = 1.5) #

plot(x=NULL, y=NULL, xlim=c(1970,2010), ylim=c(0,70), axes=FALSE, ylab="Number of Militant Groups",
 xlab="Year", main="", cex.axis=1.5)
axis(side=1)
axis(side=2)

points(x=Year, y=Neighbors, pch=19)
lines(x=Year, y=Neighbors)


//* Figure 5 *// 

//Figure 5 was manually created//




//* Figure 6 *// 

par(mar=c(4.5,4.6,2.5,1)+.1, cex.main = 2.4, cex.axis = 2.4, cex.lab = 2.4) #
layout(matrix(c(rep(1:2,each=2),rep(3:4,each=2)),nrow=2,byrow=TRUE))

plot(x=NULL, y=NULL, xlim=c(-3,3), ylim=c(-1.5,1.5), axes=FALSE, ylab="Impact of Decapitation",
 xlab="Year before/ after Decapitation", main="Model 3: Targeted Killing (Direct Effect)", cex.axis=2.4)
axis(side=1)
axis(side=2)

abline(v=-1, lty=2, lwd=1, col="gray60")
abline(h=0, lty=2, lwd=1, col="gray60")

polygon(c(Index2, rev(Index2)),c(Direct4a_lb1, rev(Direct4b_ub1)),col=rgb(0.8,0.8,0.8,0.8), border=NA)
points(x=Index2, y=Coefficient4a, pch=19)
points(x=Index3, y=Coefficient4b, pch=19)
lines(x=Index2, y=Coefficient4a, lty="dashed")
lines(x=Index3, y=Coefficient4b, lwd=2)
lines(x=Index2, y=Direct4a_lb1, lty="dashed")
lines(x=Index3, y=Direct4a_lb2, lwd=2, lty="dashed")
lines(x=Index2, y=Direct4b_ub1, lty="dashed")
lines(x=Index3, y=Direct4b_ub2, lwd=2, lty="dashed")
text(-2.8, 1.5, paste("Before Treatment"), pos = 4, cex=2.4)
text(0.5, 1.5, paste("After Treatment"), pos = 4, cex=2.4)

# 2
plot(x=NULL, y=NULL, xlim=c(-3,3), ylim=c(-1.5,1.5), axes=FALSE, ylab="Impact of Decapitation",
     xlab="Year before/ after Decapitation", main="Model 3: Targeted Killing (Indirect Effect)", cex.axis=2.4)
axis(side=1)
axis(side=2)

abline(v=-1, lty=2, lwd=1, col="gray60")
abline(h=0, lty=2, lwd=1, col="gray60")

polygon(c(Index2, rev(Index2)),c(Direct5a_lb1, rev(Direct5b_ub1)),col=rgb(0.8,0.8,0.8,0.8), border=NA)
points(x=Index2, y=Coefficient5a, pch=19)
points(x=Index3, y=Coefficient5b, pch=19)
lines(x=Index2, y=Coefficient5a, lty="dashed")
lines(x=Index3, y=Coefficient5b, lwd=2)
lines(x=Index2, y=Direct5a_lb1, lty="dashed")
lines(x=Index3, y=Direct5a_lb2, lwd=2, lty="dashed")
lines(x=Index2, y=Direct5b_ub1, lty="dashed")
lines(x=Index3, y=Direct5b_ub2, lwd=2, lty="dashed")
text(-2.8, 1.5, paste("Before Treatment"), pos = 4, cex=2.4)
text(0.5, 1.5, paste("After Treatment"), pos = 4, cex=2.4)

# 3
plot(x=NULL, y=NULL, xlim=c(-3,3), ylim=c(-1.5,1.5), axes=FALSE, ylab="Impact of Decapitation",
     xlab="Year before/ after Decapitation", main="Model 4: Targeted Capturing (Direct Effect)", cex.axis=2.4)
axis(side=1)
axis(side=2)

abline(v=-1, lty=2, lwd=1, col="gray60")
abline(h=0, lty=2, lwd=1, col="gray60")

polygon(c(Index2, rev(Index2)),c(Direct6a_lb1, rev(Direct6b_ub1)),col=rgb(0.8,0.8,0.8,0.8), border=NA)
points(x=Index2, y=Coefficient6a, pch=19)
points(x=Index3, y=Coefficient6b, pch=19)
lines(x=Index2, y=Coefficient6a, lty="dashed")
lines(x=Index3, y=Coefficient6b, lwd=2)
lines(x=Index2, y=Direct6a_lb1, lty="dashed")
lines(x=Index3, y=Direct6a_lb2, lwd=2, lty="dashed")
lines(x=Index2, y=Direct6b_ub1, lty="dashed")
lines(x=Index3, y=Direct6b_ub2, lwd=2, lty="dashed")
text(-2.8, 1.5, paste("Before Treatment"), pos = 4, cex=2.4)
text(0.5, 1.5, paste("After Treatment"), pos = 4, cex=2.4)

# 4
plot(x=NULL, y=NULL, xlim=c(-3,3), ylim=c(-1.5,1.5), axes=FALSE, ylab="Impact of Decapitation",
     xlab="Year before/ after Decapitation", main="Model 4: Targeted Capturing (Indirect Effect)", cex.axis=2.4)
axis(side=1)
axis(side=2)

abline(v=-1, lty=2, lwd=1, col="gray60")
abline(h=0, lty=2, lwd=1, col="gray60")

polygon(c(Index2, rev(Index2)),c(Direct7a_lb1, rev(Direct7b_ub1)),col=rgb(0.8,0.8,0.8,0.8), border=NA)
points(x=Index2, y=Coefficient7a, pch=19)
points(x=Index3, y=Coefficient7b, pch=19)
lines(x=Index2, y=Coefficient7a, lty="dashed")
lines(x=Index3, y=Coefficient7b, lwd=2)
lines(x=Index2, y=Direct7a_lb1, lty="dashed")
lines(x=Index3, y=Direct7a_lb2, lwd=2, lty="dashed")
lines(x=Index2, y=Direct7b_ub1, lty="dashed")
lines(x=Index3, y=Direct7b_ub2, lwd=2, lty="dashed")
text(-2.8, 1.5, paste("Before Treatment"), pos = 4, cex=2.4)
text(0.5, 1.5, paste("After Treatment"), pos = 4, cex=2.4)



//* Figure 7 *//

par(mar=c(4.5,4.5,2.5,1)+.1, cex.main = 2.4, cex.axis = 2.4, cex.lab = 2.4) #
layout(matrix(c(rep(1:3,each=2),rep(4:6,each=2)),nrow=2,byrow=TRUE))
#1
plot(x=NULL, y=NULL, xlim=c(-3,3), ylim=c(-1.5,1.5), axes=FALSE, ylab="Impact of Decapitation",
     xlab="Year before/ after Decapitation", main="Model 5: Targeted Killing (Direct Effect)", cex.axis=2.4)
axis(side=1)
axis(side=2)

abline(v=-1, lty=2, lwd=1, col="gray60")
abline(h=0, lty=2, lwd=1, col="gray60")

polygon(c(Index2, rev(Index2)),c(Direct8a_lb1, rev(Direct8b_ub1)),col=rgb(0.8,0.8,0.8,0.8), border=NA)
points(x=Index2, y=Coefficient8a, pch=19)
points(x=Index3, y=Coefficient8b, pch=19)
lines(x=Index2, y=Coefficient8a, lty="dashed")
lines(x=Index3, y=Coefficient8b, lwd=2)
lines(x=Index2, y=Direct8a_lb1, lty="dashed")
lines(x=Index3, y=Direct8a_lb2, lwd=2, lty="dashed")
lines(x=Index2, y=Direct8b_ub1, lty="dashed")
lines(x=Index3, y=Direct8b_ub2, lwd=2, lty="dashed")
text(-2.8, 1.5, paste("Before Treatment"), pos = 4, cex=2.4)
text(0.6, 1.5, paste("After Treatment"), pos = 4, cex=2.4)

#2
plot(x=NULL, y=NULL, xlim=c(-3,3), ylim=c(-1.5,1.5), axes=FALSE, ylab="Impact of Decapitation",
     xlab="Year before/ after Decapitation", main="Model 5: Targeted Killing (Indirect Effect)", cex.axis=1.2)
axis(side=1)
axis(side=2)

abline(v=-1, lty=2, lwd=1, col="gray60")
abline(h=0, lty=2, lwd=1, col="gray60")

polygon(c(Index2, rev(Index2)),c(Direct9a_lb1, rev(Direct9b_ub1)),col=rgb(0.8,0.8,0.8,0.8), border=NA)
points(x=Index2, y=Coefficient9a, pch=19)
points(x=Index3, y=Coefficient9b, pch=19)
lines(x=Index2, y=Coefficient9a, lty="dashed")
lines(x=Index3, y=Coefficient9b, lwd=2)
lines(x=Index2, y=Direct9a_lb1, lty="dashed")
lines(x=Index3, y=Direct9a_lb2, lwd=2, lty="dashed")
lines(x=Index2, y=Direct9b_ub1, lty="dashed")
lines(x=Index3, y=Direct9b_ub2, lwd=2, lty="dashed")
text(-2.8, 1.5, paste("Before Treatment"), pos = 4, cex=2.4)
text(0.6, 1.5, paste("After Treatment"), pos = 4, cex=2.4)

#3
plot(x=NULL, y=NULL, xlim=c(-3,3), ylim=c(-1.5,1.5), axes=FALSE, ylab="Impact of Decapitation",
     xlab="Year before/ after Decapitation", main="Model 6: Targeted Capturing (Direct Effect)", cex.axis=2.4)
axis(side=1)
axis(side=2)

abline(v=-1, lty=2, lwd=1, col="gray60")
abline(h=0, lty=2, lwd=1, col="gray60")

polygon(c(Index2, rev(Index2)),c(Direct10a_lb1, rev(Direct10b_ub1)),col=rgb(0.8,0.8,0.8,0.8), border=NA)
points(x=Index2, y=Coefficient10a, pch=19)
points(x=Index3, y=Coefficient10b, pch=19)
lines(x=Index2, y=Coefficient10a, lty="dashed")
lines(x=Index3, y=Coefficient10b, lwd=2)
lines(x=Index2, y=Direct10a_lb1, lty="dashed")
lines(x=Index3, y=Direct10a_lb2, lwd=2, lty="dashed")
lines(x=Index2, y=Direct10b_ub1, lty="dashed")
lines(x=Index3, y=Direct10b_ub2, lwd=2, lty="dashed")
text(-2.8, 1.5, paste("Before Treatment"), pos = 4, cex=2.4)
text(0.6, 1.5, paste("After Treatment"), pos = 4, cex=2.4)

#4
plot(x=NULL, y=NULL, xlim=c(-3,3), ylim=c(-1.5,1.5), axes=FALSE, ylab="Impact of Decapitation",
     xlab="Year before/ after Decapitation", main="Model 6: Targeted Capturing (Indirect Effect)", cex.axis=2.4)
axis(side=1)
axis(side=2)

abline(v=-1, lty=2, lwd=1, col="gray60")
abline(h=0, lty=2, lwd=1, col="gray60")

polygon(c(Index2, rev(Index2)),c(Direct11a_lb1, rev(Direct11b_ub1)),col=rgb(0.8,0.8,0.8,0.8), border=NA)
points(x=Index2, y=Coefficient11a, pch=19)
points(x=Index3, y=Coefficient11b, pch=19)
lines(x=Index2, y=Coefficient11a, lty="dashed")
lines(x=Index3, y=Coefficient11b, lwd=2)
lines(x=Index2, y=Direct11a_lb1, lty="dashed")
lines(x=Index3, y=Direct11a_lb2, lwd=2, lty="dashed")
lines(x=Index2, y=Direct11b_ub1, lty="dashed")
lines(x=Index3, y=Direct11b_ub2, lwd=2, lty="dashed")
text(-2.8, 1.5, paste("Before Treatment"), pos = 4, cex=2.4)
text(0.6, 1.5, paste("After Treatment"), pos = 4, cex=2.4)

#5
plot(x=NULL, y=NULL, xlim=c(-3,3), ylim=c(-1.5,1.5), axes=FALSE, ylab="Impact of Decapitation",
     xlab="Year before/ after Decapitation", main="Model 7: Targeted Capturing (Direct, Alliance Neighbors)", cex.axis=2.4)
axis(side=1)
axis(side=2)

abline(v=-1, lty=2, lwd=1, col="gray60")
abline(h=0, lty=2, lwd=1, col="gray60")

polygon(c(Index2, rev(Index2)),c(Direct16a_lb1, rev(Direct16b_ub1)),col=rgb(0.8,0.8,0.8,0.8), border=NA)
points(x=Index2, y=Coefficient16a, pch=19)
points(x=Index3, y=Coefficient16b, pch=19)
lines(x=Index2, y=Coefficient16a, lty="dashed")
lines(x=Index3, y=Coefficient16b, lwd=2)
lines(x=Index2, y=Direct16a_lb1, lty="dashed")
lines(x=Index3, y=Direct16a_lb2, lwd=2, lty="dashed")
lines(x=Index2, y=Direct16b_ub1, lty="dashed")
lines(x=Index3, y=Direct16b_ub2, lwd=2, lty="dashed")
text(-2.8, 1.5, paste("Before Treatment"), pos = 4, cex=2.4)
text(0.6, 1.5, paste("After Treatment"), pos = 4, cex=2.4)

#6
plot(x=NULL, y=NULL, xlim=c(-3,3), ylim=c(-1.5,1.5), axes=FALSE, ylab="Impact of Decapitation",
     xlab="Year before/ after Decapitation", main="Model 7: Targeted Capturing (Indirect, Alliance Neighbors)", cex.axis=2.4)
axis(side=1)
axis(side=2)

abline(v=-1, lty=2, lwd=1, col="gray60")
abline(h=0, lty=2, lwd=1, col="gray60")

polygon(c(Index2, rev(Index2)),c(Direct17a_lb1, rev(Direct17b_ub1)),col=rgb(0.8,0.8,0.8,0.8), border=NA)
points(x=Index2, y=Coefficient17a, pch=19)
points(x=Index3, y=Coefficient17b, pch=19)
lines(x=Index2, y=Coefficient17a, lty="dashed")
lines(x=Index3, y=Coefficient17b, lwd=2)
lines(x=Index2, y=Direct17a_lb1, lty="dashed")
lines(x=Index3, y=Direct17a_lb2, lwd=2, lty="dashed")
lines(x=Index2, y=Direct17b_ub1, lty="dashed")
lines(x=Index3, y=Direct17b_ub2, lwd=2, lty="dashed")
text(-2.8, 1.5, paste("Before Treatment"), pos = 4, cex=2.4)
text(0.6, 1.5, paste("After Treatment"), pos = 4, cex=2.4)



//* Figure 8 *//

par(mar=c(4.5,4.6,2.5,1)+.1, cex.main = 2.4, cex.axis = 2.4, cex.lab = 2.4)
layout(matrix(c(rep(1:2,each=2),rep(3:4,each=2)),nrow=2,byrow=TRUE))

plot(x=NULL, y=NULL, xlim=c(-3,3), ylim=c(-1.5,1.5), axes=FALSE, ylab="Impact of Decapitation",
     xlab="Year before/ after Decapitation", main="Model 8: Targeted Killing (Direct Effect)", cex.axis=2.4)
axis(side=1)
axis(side=2)

abline(v=-1, lty=2, lwd=1, col="gray60")
abline(h=0, lty=2, lwd=1, col="gray60")

polygon(c(Index2, rev(Index2)),c(Direct12a_lb1, rev(Direct12b_ub1)),col=rgb(0.8,0.8,0.8,0.8), border=NA)
points(x=Index2, y=Coefficient12a, pch=19)
points(x=Index3, y=Coefficient12b, pch=19)
lines(x=Index2, y=Coefficient12a, lty="dashed")
lines(x=Index3, y=Coefficient12b, lwd=2)
lines(x=Index2, y=Direct12a_lb1, lty="dashed")
lines(x=Index3, y=Direct12a_lb2, lwd=2, lty="dashed")
lines(x=Index2, y=Direct12b_ub1, lty="dashed")
lines(x=Index3, y=Direct12b_ub2, lwd=2, lty="dashed")
text(-2.5, 1.5, paste("Before Treatment"), pos = 4, cex=2.4)
text(0.8, 1.5, paste("After Treatment"), pos = 4, cex=2.4)

#2
plot(x=NULL, y=NULL, xlim=c(-3,3), ylim=c(-1.5,1.5), axes=FALSE, ylab="Impact of Decapitation",
     xlab="Year before/ after Decapitation", main="Model 8: Targeted Killing (Indirect Effect)", cex.axis=2.4)
axis(side=1)
axis(side=2)

abline(v=-1, lty=2, lwd=1, col="gray60")
abline(h=0, lty=2, lwd=1, col="gray60")

polygon(c(Index2, rev(Index2)),c(Direct13a_lb1, rev(Direct13b_ub1)),col=rgb(0.8,0.8,0.8,0.8), border=NA)
points(x=Index2, y=Coefficient13a, pch=19)
points(x=Index3, y=Coefficient13b, pch=19)
lines(x=Index2, y=Coefficient13a, lty="dashed")
lines(x=Index3, y=Coefficient13b, lwd=2)
lines(x=Index2, y=Direct13a_lb1, lty="dashed")
lines(x=Index3, y=Direct13a_lb2, lwd=2, lty="dashed")
lines(x=Index2, y=Direct13b_ub1, lty="dashed")
lines(x=Index3, y=Direct13b_ub2, lwd=2, lty="dashed")
text(-2.5, 1.5, paste("Before Treatment"), pos = 4, cex=2.4)
text(0.8, 1.5, paste("After Treatment"), pos = 4, cex=2.4)

#3
plot(x=NULL, y=NULL, xlim=c(-3,3), ylim=c(-1.5,1.5), axes=FALSE, ylab="Impact of Decapitation",
     xlab="Year before/ after Decapitation", main="Model 9: Targeted Capturing (Direct Effect)", cex.axis=2.4)
axis(side=1)
axis(side=2)

abline(v=-1, lty=2, lwd=1, col="gray60")
abline(h=0, lty=2, lwd=1, col="gray60")

polygon(c(Index2, rev(Index2)),c(Direct14a_lb1, rev(Direct14b_ub1)),col=rgb(0.8,0.8,0.8,0.8), border=NA)
points(x=Index2, y=Coefficient14a, pch=19)
points(x=Index3, y=Coefficient14b, pch=19)
lines(x=Index2, y=Coefficient14a, lty="dashed")
lines(x=Index3, y=Coefficient14b, lwd=2)
lines(x=Index2, y=Direct14a_lb1, lty="dashed")
lines(x=Index3, y=Direct14a_lb2, lwd=2, lty="dashed")
lines(x=Index2, y=Direct14b_ub1, lty="dashed")
lines(x=Index3, y=Direct14b_ub2, lwd=2, lty="dashed")
text(-2.5, 1.5, paste("Before Treatment"), pos = 4, cex=2.4)
text(0.8, 1.5, paste("After Treatment"), pos = 4, cex=2.4)

#4
plot(x=NULL, y=NULL, xlim=c(-3,3), ylim=c(-1.5,1.5), axes=FALSE, ylab="Impact of Decapitation",
     xlab="Year before/ after Decapitation", main="Model 9: Targeted Capturing (Indirect Effect)", cex.axis=2.4)
axis(side=1)
axis(side=2)

abline(v=-1, lty=2, lwd=1, col="gray60")
abline(h=0, lty=2, lwd=1, col="gray60")

polygon(c(Index2, rev(Index2)),c(Direct15a_lb1, rev(Direct15b_ub1)),col=rgb(0.8,0.8,0.8,0.8), border=NA)
points(x=Index2, y=Coefficient15a, pch=19)
points(x=Index3, y=Coefficient15b, pch=19)
lines(x=Index2, y=Coefficient15a, lty="dashed")
lines(x=Index3, y=Coefficient15b, lwd=2)
lines(x=Index2, y=Direct15a_lb1, lty="dashed")
lines(x=Index3, y=Direct15a_lb2, lwd=2, lty="dashed")
lines(x=Index2, y=Direct15b_ub1, lty="dashed")
lines(x=Index3, y=Direct15b_ub2, lwd=2, lty="dashed")
text(-2.5, 1.5, paste("Before Treatment"), pos = 4, cex=2.4)
text(0.8, 1.5, paste("After Treatment"), pos = 4, cex=2.4)



//* Figure 9 *//


par(mar=c(4.5,4.6,2.5,1)+.1, cex.main = 2.2, cex.axis = 2.2, cex.lab = 2.2)
plot(x=NULL, y=NULL, xlim=c(1985,2015), ylim=c(0, 52), axes=FALSE, ylab="Numbers of Militant Attacks",
     xlab="Year", main="", cex.axis=6)
axis(side=1)
axis(side=2)

abline(v=-1, lty=2, lwd=1, col="gray60")
arrest <- as.yearmon("2004-04")
abline(v=arrest, lty=4, lwd=1.5, col="blue")
text(1997.5, 45, paste("Capture of Mohan Vaidya"), pos = 4, cex=2.2)
text(1997.5, 43, paste("(April 2004)"), pos = 4, cex=2)


points(x=time_nep$time, y=time_nep$count.sum, pch=20)
lines(x=time_nep$time, y=time_nep$count.sum)
points(x=time_nep2$time, y=time_nep2$count.sum, pch=5, col="red")
lines(x=time_nep2$time, y=time_nep2$count.sum, lty="dashed", col="red")

legend("topleft", legend = c("Domestic Incidents", "Transnational Incidents"), pch = c(20, 5), lty=c(1,3), col=c(1,2),cex=2)

xx <- time_nep[which(time_nep$time>2004),]
xx <- xx[which(xx$time<2005),]

plotInset(1996, 10, 2003, 40,
          expr=plot(xx$time,xx$count.sum,type='l', xlab="2004", ylab="# of Attacks", cex=1.2),
          mar=c(2.5,2.5,1,1))

plotInset(1996, 10, 2003, 40,
          expr=abline(v=as.yearmon("1990-12"), lty=4, lwd=1.5, col="blue"), #For some reason, the year and month in the Figure does not return as exactly what I specified. After several try, we found that "1990-12" is set to "2004-12"
          mar=c(2.5,2.5,1,1))
