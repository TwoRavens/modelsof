/*********************************************************************+*********
***********           SAVINGS IN TRANSNATIONAL HOUSEHOLDS:           ***********
***********    A FIELD EXPERIMENT AMONG MIGRANTS FROM EL SALVADOR    ***********
********************************************************************************

	AUTHORS	     : Nava Ashraf, Diego Ayciena, Claudia Martinez, Dean Yang
	LAST MODIFIED: April 24, 2014
	PURPOSE		 : Replicate the main tables of the paper
	REQUIREMENTS : The do-file must be ran at the directory containing at least 
	the folowing folders:
		- /dta
		- /log
		- /fig
		- /do
																	  		  */		
********************************************************************************
******* 	PREAMBLE								 	     			 *******
********************************************************************************

clear all
set more off
set matsize 5000
cap log close
cap log using log/tables, replace text

	// P.1 Set the directory
	
cd "Replication RESTAT"

	// P.2 Define globals

global fe="i.moa2 i.marketer i.celda"

	// P3. Call the data

use dta/BAdata_2013.dta, clear

********************************************************************************
******* 	Table 1.									 	     		 *******
********************************************************************************

	//1.1 Define relevant variables 
	
*Treatment indicators and stratification variables
global visit visit0 visit1 visit2 visit3
global treat USfemale USusacct parent spouse child other USyears_0_5 USyears_6_10 USyears_11_15	

*Baseline variables from DC migrant survey
global bl_dcsurvey US_years USesacct USearnings_bl UShhearnings_bl USeduc_bl 	///
		  US_age US_rem US_saving US_nat US_numper US_mar_par diddirpay			///
		  diddirsave likedirpaycont knowconflict conflict likecontrol finlitq1 	///
		  finlitq2 finlitq3 trackbud

*Baseline variables from El Salvador household survey
global bl_essurvey ES_saving_tot ES_rem 

*Pre-treatment savings at partner bank
global pre_treat savo_avg_0112_quart savo_avg_0112

global sum $visit $treat $bl_dcsurvey $bl_essurvey $pre_treat

order $sum
tabstat $sum, s(mean sd p10 median p90 N) c(statistics)


********************************************************************************
******* 	Table 2.									 	     		 *******
********************************************************************************

*Define the outcomes global y1 = "dsavc_max0112 dsava_max0112 dsavo_max0112"
foreach X in $y1 {
svy: reg `X' visit3 visit2 visit1
scalar cons_2 = _b[_cons]
test visit3 = visit2
test visit3 = visit1
test visit1 = visit2

xi: svy: reg `X' visit3 visit2 visit1 likecontrol $fe
test visit3 = visit2
test visit3 = visit1
test visit1 = visit2
}

********************************************************************************
******* 	Table 3.									 	     		 *******
********************************************************************************

*Define the outcomes 
global y1="savc_avg0112 sava_avg0112 savo_avg0112 savcao_avg0112"
	
	// Panel A: quart transformation

foreach X in $y1 {
svy: reg `X'_quart visit3 visit2 visit1
scalar cons_3a = _b[_cons]
test visit3 = visit2
test visit3 = visit1
test visit1 = visit2

xi: svy: reg `X'_quart visit3 visit2 visit1 likecontrol $fe
test visit3 = visit2
test visit3 = visit1
test visit1 = visit2
}

	// Panel B: in dollars

foreach X in $y1 {
svy: reg `X' visit3 visit2 visit1		
scalar cons_3b = _b[_cons]
test visit3 = visit2
test visit3 = visit1
test visit1 = visit2

xi: svy: reg `X' visit3 visit2 visit1 likecontrol $fe
test visit3 = visit2
test visit3 = visit1
test visit1 = visit2
}

********************************************************************************
******* 	Table 4.									 	     		 *******
********************************************************************************

*Define the outcomes 
global y1="USsavings_ines USsavings_inus USsavings_cash USsavings2"

	// Panel A: quart transformation

foreach X in $y1 {
svy: reg `X'_quart visit3 visit2 visit1	
scalar cons_4a = _b[_cons]	
xi: svy: reg `X'_quart visit3 visit2 visit1 likecontrol $fe
test visit3 = visit2
test visit3 = visit1
test visit1 = visit2
}

	// Panel B: in dollars

foreach X in $y1 {
svy: reg `X' visit3 visit2 visit1	
scalar cons_4b = _b[_cons]	
xi: svy: reg `X' visit3 visit2 visit1 likecontrol $fe
test visit3 = visit2
test visit3 = visit1
test visit1 = visit2
}


********************************************************************************
******* 	Table 5.									 	     		 *******
********************************************************************************

*Define the outcomes 
global y1="savc_avg0112 sava_avg0112 savo_avg0112 savcao_avg0112"

	// Panel A: quart transformation

foreach X in $y1 {
xi: svy: reg `X'_quart visit3_likecontrol visit3_nolikecontrol visit2_likecontrol 	///
			  visit2_nolikecontrol visit1_likecontrol visit1_nolikecontrol 		 		///
			  likecontrol $fe

test visit3_likecontrol = visit3_nolikecontrol
test visit2_likecontrol = visit2_nolikecontrol
test visit1_likecontrol = visit1_nolikecontrol

sum `X'_quart if visit3_likecontrol==0 & visit2_likecontrol==0 & visit1_likecontrol==0 	///
   & visit3_nolikecontrol==0 & visit2_nolikecontrol==0 & visit1_nolikecontrol==0 		///
   & likecontrol==1, meanonly
scalar cons_5a_control=r(mean)
sum `X'_quart if visit3_likecontrol==0 & visit2_likecontrol==0 & visit1_likecontrol==0 	///
   & visit3_nolikecontrol==0 & visit2_nolikecontrol==0 & visit1_nolikecontrol==0 		///
   & likecontrol==0, meanonly
scalar cons_5a_nocontrol=r(mean)	
}

	// Panel B: in dollars

foreach X in $y1 {
xi: svy: reg `X' visit3_likecontrol visit3_nolikecontrol visit2_likecontrol 		///
			  visit2_nolikecontrol visit1_likecontrol visit1_nolikecontrol 				///
			  likecontrol $fe

test visit3_likecontrol = visit3_nolikecontrol
test visit2_likecontrol = visit2_nolikecontrol
test visit1_likecontrol = visit1_nolikecontrol

sum `X' if visit3_likecontrol==0 & visit2_likecontrol==0 & visit1_likecontrol==0 		///
   & visit3_nolikecontrol==0 & visit2_nolikecontrol==0 & visit1_nolikecontrol==0 		///
   & likecontrol==1, meanonly
scalar cons_5b_control=r(mean)
sum `X' if visit3_likecontrol==0 & visit2_likecontrol==0 & visit1_likecontrol==0 		///
   & visit3_nolikecontrol==0 & visit2_nolikecontrol==0 & visit1_nolikecontrol==0 		///
   & likecontrol==0, meanonly
scalar cons_5b_nocontrol=r(mean)	
}

********************************************************************************
******* 	Table 6.									 	     		 *******
********************************************************************************

*Define the outcomes
global y1="savcao_avg0106 savcao_avg0712 savcao_avg1318 savcao_avg1924 savcao_avg2530 savcao_avg3136 savcao_avg3742 savcao_avg4348"

	// Panel A: quartic 

foreach X in $y1 {
xi: svy: reg `X'_quart visit3 visit2 visit1 likecontrol $fe
test visit3 = visit2
test visit3 = visit1
test visit1 = visit2
sum `X'_quart if visit3==0 & visit2==0 & visit1==0, meanonly
scalar cons_6a=r(mean)
}

	// Panel B: in dollars

foreach X in $y1 {
xi: svy: reg `X' visit3 visit2 visit1 likecontrol $fe
test visit3 = visit2
test visit3 = visit1
test visit1 = visit2
sum `X' if visit3==0 & visit2==0 & visit1==0, meanonly
scalar cons_6b=r(mean)
}

********************************************************************************
******* 	Table 7.									 	     		 *******
********************************************************************************

*Define the outcomes
global y1="cumrem_0708_0609 cumrem_0708_0609_USsamponly USremit_p2h"
	
	// 7.1 Convert remittance and earnings yearly data to monthly data
	
foreach X in cumrem_0708_0609 cumrem_0708_0609_USsamponly {
replace `X' = `X'/12
}
foreach X in USremit_p2h {
replace `X' = `X'/6
		}

	// 7.2 Panel A: Main effects of treatments
	
foreach X in $y1{
xi: svy: reg `X' visit3 visit2 visit1 likecontrol $fe
test visit3 = visit2
test visit3 = visit1
test visit1 = visit2
sum `X' if visit3==0 & visit2==0 & visit1==0, meanonly
scalar cons_7a=r(mean)
}

	// 7.3 Panel B: Separate Treatment Effects
	
foreach X in $y1{
xi: svy: reg `X' visit3_likecontrol visit3_nolikecontrol visit2_likecontrol ///
		      visit2_nolikecontrol visit1_likecontrol visit1_nolikecontrol 		 ///
		      likecontrol $fe 

test visit3_likecontrol = visit3_nolikecontrol
test visit2_likecontrol = visit2_nolikecontrol
test visit1_likecontrol = visit1_nolikecontrol

sum `X' if visit3_likecontrol==0 & visit2_likecontrol==0 & visit1_likecontrol==0 ///
   & visit3_nolikecontrol==0 & visit2_nolikecontrol==0 & visit1_nolikecontrol==0 ///
   & likecontrol==1, meanonly
scalar cons_7b_control=r(mean)
sum `X' if visit3_likecontrol==0 & visit2_likecontrol==0 & visit1_likecontrol==0 ///
   & visit3_nolikecontrol==0 & visit2_nolikecontrol==0 & visit1_nolikecontrol==0 ///
   & likecontrol==0, meanonly
scalar cons_7b_nocontrol=r(mean)
}

********************************************************************************
******* 	Table A1.									 	     		 *******
********************************************************************************

	//A1.1 Summarize relevant data (US Census 2000)

* Call the data
use dta/census.dta, clear
	
*Keep relevant data

drop if yrsusa1>15					// More than 15 years in the US
drop if age>65						// Drop individuals over 65
drop if hispand==0					// Drop non-hispanics
recode sex 2=0

*Gen dummies for years in the U.S.
gen USyears_0_5   = yrsusa1<6
gen USyears_6_10  = yrsusa1>=6 & yrsusa1<11
gen USyears_11_15 = yrsusa1>=11

*Gen dummies for educational attainment, citizenship and marital status
gen edu_cat=.
replace edu_cat=1 if educd==2
replace edu_cat=2 if educd>=10 & educd<=61
replace edu_cat=3 if educd>=62 
tab edu_cat, g(edu_cat)
gen US_nat=citizen==2
gen US_mar_par=marst<=2

*Define the outcomes
global app1 sex age USyears_0_5 USyears_6_10 USyears_11_15 edu_cat1-edu_cat3 US_nat US_mar_par 

*Salvadoran-born
sum $app1 [fw=perwt] if bpld==21030 , sep(10)
sum $app1 [fw=perwt] if bpld==21030 & sex==1 , sep(10)
sum $app1 [fw=perwt] if bpld==21030 & sex==0 , sep(10)

*Salvadoran-born, not US citizen
sum $app1 [fw=perwt] if bpld==21030 , sep(10)
sum $app1 [fw=perwt] if bpld==21030 & sex==1 & citizen==3, sep(10)
sum $app1 [fw=perwt] if bpld==21030 & sex==0 & citizen==3, sep(10)

*Hispanic, not US citizen
sum $app1 [fw=perwt], sep(30)
sum $app1 [fw=perwt] if sex==1 & citizen==3, sep(15)
sum $app1 [fw=perwt] if sex==0 & citizen==3, sep(15)

	//A1.2 Summarize relevant data (Baseline Survey)

*Call the data
use dta/BAdata_2013.dta, clear

gen sex=0
replace sex=1 if USfemale==0
replace sex=0 if USfemale==1

gen edu_cat=.
replace edu_cat=1 if USeduc_bl==0 
replace edu_cat=2 if USeduc_bl>0 & USeduc_bl<=11
replace edu_cat=3 if USeduc_bl>=12
replace edu_cat=. if USeduc_bl==.
tab edu_cat, g(edu_cat)

*Define the outcomes
global app1 sex US_age USyears_0_5 USyears_6_10 USyears_11_15 edu_cat1-edu_cat3 US_nat US_mar_par 

*Baseline survey
sum $app1, sep(15)
sum $app1 if sex==1, sep(15)
sum $app1 if sex==0, sep(15)


********************************************************************************
******* 	Table A2.									 	     		 *******
********************************************************************************

*Call the data	
use dta/BAdata_2013.dta, clear

*Define the outcomes
global app2 $treat $bl_dcsurvey $bl_essurvey $pre_treat attrit_US_savings

foreach X in $app2 {
svy: reg `X' visit0 visit1 visit2 visit3, nocons 
test visit0=visit1=visit2=visit3 
test visit0=visit1 
test visit0=visit2 
test visit0=visit3 
}

********************************************************************************
******* 	Table A3.									 	     		 *******
********************************************************************************

*Drop the attritors	
keep if USsavings2~=.
drop if likecontrol==.	

*Define the outcomes
global app3 $treat $bl_dcsurvey $bl_essurvey $pre_treat

foreach X in $app3 {
svy: reg `X' visit0 visit1 visit2 visit3, nocons 
test visit0=visit1=visit2=visit3 
test visit0=visit1 
test visit0=visit2 
test visit0=visit3 
}

********************************************************************************
******* 	Table A4.									 	     		 *******
********************************************************************************

use dta/BAdata_2013.dta, clear
	
*Define the outcomes 
global y1="savc_avg0112 sava_avg0112 savo_avg0112 savcao_avg0112"
	
	// Panel A: quart transformation

foreach X in $y1 {
svy: reg `X'_quart visit3 visit2 visit1 if USsavings2~=.
scalar cons_A4a = _b[_cons]	
test visit3 = visit2
test visit3 = visit1
test visit1 = visit2

xi: svy: reg `X'_quart visit3 visit2 visit1 likecontrol $fe if USsavings2~=.
test visit3 = visit2
test visit3 = visit1
test visit1 = visit2
}

	// Panel B: in dollars

foreach X in $y1 {
svy: reg `X' visit3 visit2 visit1 if USsavings2~=.
scalar cons_A4b = _b[_cons]	 
test visit3 = visit2
test visit3 = visit1
test visit1 = visit2

xi: svy: reg `X' visit3 visit2 visit1 likecontrol $fe if USsavings2~=.
test visit3 = visit2
test visit3 = visit1
test visit1 = visit2
}

cap: erase tab/ltableA4b.txt

********************************************************************************
******* 	Table A5.									 	     		 *******
********************************************************************************

keep if USsavings2~=.
drop if likecontrol==.

*Define the outcomes 
global y1="USsavings_jointpr_nonBA USsavings_jointoth_nonBA"

	// Panel A: quart transformation

foreach X in $y1 {
xi: svy: reg `X'_quart visit3 visit2 visit1 likecontrol $fe
test visit3 = visit2
test visit3 = visit1
test visit1 = visit2
}

	// Panel B: in dollars

foreach X in $y1 {
xi: svy: reg `X' visit3 visit2 visit1 likecontrol $fe
test visit3 = visit2
test visit3 = visit1
test visit1 = visit2
}


********************************************************************************
******* 	Figure 1.									 	     		 *******
********************************************************************************

use dta/BAdata_2013.dta, clear
	
cumul savcao_avg0112_quart if visita==0, gen (cum0)
cumul savcao_avg0112_quart if visita==1, gen (cum1)
cumul savcao_avg0112_quart if visita==2, gen (cum2)
cumul savcao_avg0112_quart if visita==3, gen (cum3)

sort savcao_avg0112_quart cum0 cum1 cum2 cum3
keep cum0 cum1 cum2 cum3 savcao_avg0112_quart

export excel using fig/fig1, firstrow(variables) replace


********************************************************************************
******* 	ONLINE APPENDIX: Figures 1 to 4						 	     *******
********************************************************************************

use dta/BAdata_2013.dta, clear

global savcao savcao_22 savcao_21 savcao_20 savcao_19 savcao_18 savcao_17 		///
			  savcao_16 savcao_15 savcao_14 savcao_13 savcao_12 savcao_11 		///
			  savcao_10 savcao_9  savcao_8  savcao_7  savcao_6  savcao_5  		///
			  savcao_4  savcao_3  savcao_2 savcao_1 savcao0-savcao56 			

global savc   savc_22 savc_21 savc_20 savc_19 savc_18 savc_17 savc_16 savc_15 	///
			  savc_14 savc_13 savc_12 savc_11 savc_10 savc_9  savc_8  savc_7  	///
			  savc_6  savc_5  savc_4  savc_3  savc_2  savc_1  savc0-savc56 		

global sava   sava_22 sava_21 sava_20 sava_19 sava_18 sava_17 sava_16 sava_15 	///
			  sava_14 sava_13 sava_12 sava_11 sava_10 sava_9  sava_8  sava_7  	///
			  sava_6  sava_5  sava_4  sava_3  sava_2  sava_1  sava0-sava56 		
			  
global savo   savo_22 savo_21 savo_20 savo_19 savo_18 savo_17 savo_16 savo_15 	///
			  savo_14 savo_13 savo_12 savo_11 savo_10 savo_9  savo_8  savo_7  	///
			  savo_6  savo_5  savo_4  savo_3  savo_2  savo_1  savo0-savo56 					  

keep $savcao $savc $sava $savo visita 

collapse (mean) $savcao $savc $sava $savo, by(visita)

order visita $savcao $savc $sava $savo

export excel visita $savcao using fig/appendix_fig, firstrow(variables) sheet("app_fig1") replace
export excel visita $savc   using fig/appendix_fig, firstrow(variables) sheet("app_fig2") 
export excel visita $sava   using fig/appendix_fig, firstrow(variables) sheet("app_fig3") 
export excel visita $savo   using fig/appendix_fig, firstrow(variables) sheet("app_fig4")


********************************************************************************

log close

