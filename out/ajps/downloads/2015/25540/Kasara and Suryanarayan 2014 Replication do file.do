*******************************************************
** Replication Data for Kasara & Suryanarayan (2014), "When do the Rich Vote Less than the Poor and Why? Explaining Turnout Inequality across the World"
** March 25, 2014 
** Version 10 
*******************************************************

ssc install estout, replace
* install edvreg.ado From Lewis, Jeffrey B., and Drew A. Linzer. 2005. Estimating Regression Models in Which the Dependent Variable Is Based on Estimates. Political Analysis 13 (4):345-364.(Source: http://svn.cluelessresearch.com/twostep/trunk/edvreg.ado) 
set more off 


*******************************************************
** Main Tables in Paper 
*******************************************************
use "Kasara Suryanarayan 2014 Replication Dataset", clear

** Control variables 
	** Main Tables 
		local controls         pr      concurrent   compulsory polity_score_z infantmortality_z   giniall_gross_z homicide_z ef_z 
	** Net Ginis 
		local controls1        pr      concurrent   compulsory polity_score_z infantmortality_z   giniall_net_z homicide_z ef_z 


** Table 1 - Correlation Matrix 



 cor prs2_z ge_est_z dtax_per_rev_z gdp_pc_ln_z VP_z elec_dist_1_5_z giniall_gross_z giniall_net_z




** Table 2 - Determinants of Turnout Inequality

	* 1. Voting Polarization 
	
		edvreg beta_exp VP_z `controls'    , dvste(stderror_exp) cluster(country) 
		eststo m1

	* 2. Electoral Distance Q1 & Q5

		 edvreg beta_exp elec_dist_1_5_z `controls'    , dvste(stderror_exp) cluster(country)  
		 eststo m2 
		 
	* 3. Bureaucratic Quality

		edvreg beta_exp prs2_z  `controls'    , dvste(stderror_exp) cluster(country)  
		eststo m3 

	* 4. Government effectiveness

		edvreg beta_exp ge_est_z  `controls'    , dvste(stderror_exp) cluster(country) 
		eststo m4
		
	* 5. Direct Taxes/Revenue

		edvreg beta_exp dtax_per_rev_z  `controls'    , dvste(stderror_exp) cluster(country) 
		eststo m5 

	* 6. Log. GDP per capita

		edvreg beta_exp    gdp_pc_ln_z `controls'     , dvste(stderror_exp) cluster(country)  
		eststo m6 

		esttab using maintable.tex, label b(a2) se(a2)  star(* 0.10 ** 0.05 *** 0.01)  stats(N N_clust) compress title(Determinants of Turnout Inequality)  replace 
		eststo clear 
		
		

** Table 3 - Determinants of Turnout Inequality in New Countries

preserve 
** NOTE fix Costa Rica in the main file 
		keep if startyear > 1900 

				
			* 1. Voting Polarization 
				edvreg beta_exp VP_z `controls'    , dvste(stderror_exp) cluster(country) 
				eststo m1

			* 2. Electoral Distance Q1 & Q5

				 edvreg beta_exp elec_dist_1_5_z `controls'    , dvste(stderror_exp) cluster(country)  
				 eststo m2 
				 
			* 3. Bureaucratic Quality

				edvreg beta_exp prs2_z  `controls'    , dvste(stderror_exp) cluster(country)  
				eststo m3 

			* 4. Government Effectiveness

				edvreg beta_exp ge_est_z  `controls'    , dvste(stderror_exp) cluster(country) 
				eststo m4
				
			* 5. Direct Taxes/Revenue

				edvreg beta_exp dtax_per_rev_z  `controls'    , dvste(stderror_exp) cluster(country) 
				eststo m5 

			* 6. Log. GDP per capita

				edvreg beta_exp    gdp_pc_ln_z `controls'     , dvste(stderror_exp) cluster(country)  
				eststo m6 


		esttab using maintable_newcountries.tex, b(a2) se(a2)  label star(* 0.10 ** 0.05 *** 0.01)  stats(N N_clust) compress title(Determinants of Turnout Inequality in New Countries)  replace 
		eststo clear

restore 


*******************************************************
** Tables in Supporting Information 
*******************************************************


**   Table A.1: Countries and Surveys

* use "worldwide_bysurvey_betas_rescaled.dta", clear

* collapse (mean) cses  wvs lapop latinob  afrob , by(country)

 

**   Table A.2: Controlling for Gini Coef_zficients Estimated Using Net Income


	* 1. Voting Polarization 
		edvreg beta_exp VP_z `controls1'    , dvste(stderror_exp) cluster(country) 
		eststo m1

	* 2. Electoral Distance Q1 & Q5

		 edvreg beta_exp elec_dist_1_5_z `controls1'    , dvste(stderror_exp) cluster(country)  
		 eststo m2 
		 
	* 3. Bureaucratic Quality

		edvreg beta_exp prs2_z  `controls1'    , dvste(stderror_exp) cluster(country)  
		eststo m3 

	* 4. Government Effectiveness

		edvreg beta_exp ge_est_z  `controls1'    , dvste(stderror_exp) cluster(country) 
		eststo m4
		
	* 5. Direct Taxes/Revenue

		edvreg beta_exp dtax_per_rev_z  `controls1'    , dvste(stderror_exp) cluster(country) 
		eststo m5 

	* 6. Log. GDP per capita

		edvreg beta_exp    gdp_pc_ln_z `controls1'     , dvste(stderror_exp) cluster(country)  
		eststo m6 

		esttab using maintable_netginis.tex, label b(a2) se(a2)  star(* 0.10 ** 0.05 *** 0.01)  stats(N N_clust) compress title(Controlling for Gini Coef_zficients Estimated Using Net Income)  replace 
		eststo clear 
		
**   Table A.3: Wealthy Countries Only

	* 1. Voting Polarization 
		edvreg beta_exp VP_z `controls' if   gdp_pc_ln_z > 0, dvste(stderror_exp) cluster(country) 
		eststo m1

	* 2. Electoral Distance Q1 & Q5

		 edvreg beta_exp elec_dist_1_5_z `controls' if gdp_pc_ln_z >  0   , dvste(stderror_exp) cluster(country)  
		 eststo m2 
		 
	* 3. Bureaucratic Quality

		edvreg beta_exp prs2_z  `controls' if gdp_pc_ln_z > 0   , dvste(stderror_exp) cluster(country)  
		eststo m3 

	* 4. Government Effectiveness

		edvreg beta_exp ge_est_z  `controls' if gdp_pc_ln_z >   0  , dvste(stderror_exp) cluster(country) 
		eststo m4
		
	* 5. Direct Taxes/Revenue

		edvreg beta_exp dtax_per_rev_z  `controls' if gdp_pc_ln_z >   0 , dvste(stderror_exp) cluster(country) 
		eststo m5 

	* 6. Log. GDP per capita

		edvreg beta_exp    gdp_pc_ln_z `controls' if gdp_pc_ln_z >   0  , dvste(stderror_exp) cluster(country)  
		eststo m6 

		esttab using maintable_richonly.tex, label b(a2) se(a2)  star(* 0.10 ** 0.05 *** 0.01)  stats(N N_clust) compress title(Wealthy Countries Only)  replace 
		eststo clear 
	
	
**   Table A.4: Controlling for Between Group Inequality

	* 1. Voting Polarization 
		edvreg beta_exp VP_z `controls'  if bgi_z ~=.   , dvste(stderror_exp) cluster(country) 
		eststo m1

		edvreg beta_exp VP_z bgi_z  `controls'     , dvste(stderror_exp) cluster(country) 
		eststo m11

	* 2. Electoral Distance Q1 & Q5

		 edvreg beta_exp elec_dist_1_5_z `controls' if bgi_z ~=.    , dvste(stderror_exp) cluster(country)  
		 eststo m2 
		 
		 
		 edvreg beta_exp elec_dist_1_5_z  bgi_z  `controls'    , dvste(stderror_exp) cluster(country)  
		 eststo m21 
		 
		 
	* 3. Bureaucratic Quality

		edvreg beta_exp prs2_z  `controls' if bgi_z ~=.    , dvste(stderror_exp) cluster(country)  
		eststo m3 
		
		edvreg beta_exp prs2_z  bgi_z  `controls'    , dvste(stderror_exp) cluster(country)  
		eststo m31 
		
	* 4. Government Effectiveness

		edvreg beta_exp ge_est_z  `controls' if bgi_z ~=.    , dvste(stderror_exp) cluster(country) 
		eststo m4
		
		edvreg beta_exp ge_est_z   bgi_z  `controls'    , dvste(stderror_exp) cluster(country) 
		eststo m41
		
	* 5. Direct Taxes/Revenue

		edvreg beta_exp dtax_per_rev_z  `controls'  if bgi_z ~=.   , dvste(stderror_exp) cluster(country) 
		eststo m5 
		
		edvreg beta_exp dtax_per_rev_z bgi_z   `controls'    , dvste(stderror_exp) cluster(country) 
		eststo m51 

	* 6. Log. GDP per capita

		edvreg beta_exp    gdp_pc_ln_z `controls'  if bgi_z ~=.    , dvste(stderror_exp) cluster(country)  
		eststo m6 
		
		edvreg beta_exp    gdp_pc_ln_z  bgi_z  `controls'     , dvste(stderror_exp) cluster(country)  
		eststo m61 


		esttab using maintable_bgi.tex, label b(a2) se(a2)  star(* 0.10 ** 0.05 *** 0.01)  stats(N N_clust) compress title(Controlling for Between Group Inequality)  replace 
		eststo clear 		


**   Table A.5: Controlling for Ethnic Voting


	* 1. Voting Polarization 
		edvreg beta_exp VP_z `controls'  if ethnicvoting_z~=.   , dvste(stderror_exp) cluster(country) 
		eststo m1

		edvreg beta_exp VP_z ethnicvoting_z `controls'     , dvste(stderror_exp) cluster(country) 
		eststo m11

	* 2. Electoral Distance Q1 & Q5

		 edvreg beta_exp elec_dist_1_5_z `controls' if ethnicvoting_z~=.    , dvste(stderror_exp) cluster(country)  
		 eststo m2 
		 
		 
		 edvreg beta_exp elec_dist_1_5_z  ethnicvoting_z `controls'    , dvste(stderror_exp) cluster(country)  
		 eststo m21 
		 
		 
	* 3. Bureaucratic Quality

		edvreg beta_exp prs2_z  `controls' if ethnicvoting_z~=.    , dvste(stderror_exp) cluster(country)  
		eststo m3 
		
		edvreg beta_exp prs2_z  ethnicvoting_z `controls'    , dvste(stderror_exp) cluster(country)  
		eststo m31 
		
	* 4. Government Effectiveness

		edvreg beta_exp ge_est_z  `controls' if ethnicvoting_z~=.    , dvste(stderror_exp) cluster(country) 
		eststo m4
		
		edvreg beta_exp ge_est_z   ethnicvoting_z `controls'    , dvste(stderror_exp) cluster(country) 
		eststo m41
		
	* 5. Direct Taxes/Revenue

		edvreg beta_exp dtax_per_rev_z  `controls'  if ethnicvoting_z~=.   , dvste(stderror_exp) cluster(country) 
		eststo m5 
		
		edvreg beta_exp dtax_per_rev_z ethnicvoting_z  `controls'    , dvste(stderror_exp) cluster(country) 
		eststo m51 

	* 6. Log. GDP per capita

		edvreg beta_exp    gdp_pc_ln_z `controls'  if ethnicvoting_z~=.    , dvste(stderror_exp) cluster(country)  
		eststo m6 
		
		edvreg beta_exp    gdp_pc_ln_z  ethnicvoting_z `controls'     , dvste(stderror_exp) cluster(country)  
		eststo m61 

	 
esttab using maintable_ethnicvoting.tex, b(a2) se(a2)  label star(* 0.10 ** 0.05 *** 0.01)  stats(N N_clust) compress title(Controlling for Ethnic Voting)  replace 
eststo clear
 
 

**   Table A.6: Self-Reported Income



	* 1. Voting Polarization 
		edvreg rep_beta_exp VP_rep_z `controls'    , dvste(rep_stderror_exp) cluster(country) 
		eststo m1

	* 2. Electoral Distance Q1 & Q5

		 edvreg rep_beta_exp elec_dist_1_5_rep_z `controls'    , dvste(rep_stderror_exp) cluster(country)  
		 eststo m2 
		 
	* 3. Bureaucratic Quality

		edvreg rep_beta_exp prs2_z  `controls'    , dvste(rep_stderror_exp) cluster(country)  
		eststo m3 

	* 4. Government Effectiveness

		edvreg rep_beta_exp ge_est_z  `controls'    , dvste(rep_stderror_exp) cluster(country) 
		eststo m4
		
	* 5. Direct Taxes/Revenue

		edvreg rep_beta_exp dtax_per_rev_z  `controls'    , dvste(rep_stderror_exp) cluster(country) 
		eststo m5 

	* 6. Log. GDP per capita

		edvreg rep_beta_exp    gdp_pc_ln_z `controls'     , dvste(rep_stderror_exp) cluster(country)  
		eststo m6 

		

		esttab using maintable_selfreported.tex, label b(a2) se(a2)  star(* 0.10 ** 0.05 *** 0.01)  stats(N N_clust) compress title(Self-Reported Income)  replace 
		eststo clear 
		
		
		
**   Table A.7: Without Potentially Truncated Values in the Wealth Index

preserve 
keep if factor_outlier ~= 1 


	* 1. Voting Polarization 
		edvreg beta_exp VP_z `controls'    , dvste(stderror_exp) cluster(country) 
		eststo m1

	* 2. Electoral Distance Q1 & Q5

		 edvreg beta_exp elec_dist_1_5_z `controls'    , dvste(stderror_exp) cluster(country)  
		 eststo m2 
		 
	* 3. Bureaucratic Quality

		edvreg beta_exp prs2_z  `controls'    , dvste(stderror_exp) cluster(country)  
		eststo m3 

	* 4. Government Effectiveness

		edvreg beta_exp ge_est_z  `controls'    , dvste(stderror_exp) cluster(country) 
		eststo m4
		
	* 5. Direct Taxes/Revenue

		edvreg beta_exp dtax_per_rev_z  `controls'    , dvste(stderror_exp) cluster(country) 
		eststo m5 

	* 6. Log. GDP per capita

		edvreg beta_exp    gdp_pc_ln_z `controls'     , dvste(stderror_exp) cluster(country)  
		eststo m6 
		
esttab using maintable_minusfactoroutlier.tex, b(a2) se(a2)  label star(* 0.10 ** 0.05 *** 0.01)  stats(N N_clust) compress title(Without Potentially Truncated Values in the Wealth Index)  replace 
eststo clear	
restore 


**   Table A.8: Altering the Threshold for Democracies
  
	preserve 
	drop if polity_score < 0 


		* 1. Voting Polarization 
			edvreg beta_exp VP_z `controls'    , dvste(stderror_exp) cluster(country) 
			eststo m1

		* 2. Electoral Distance Q1 & Q5

			 edvreg beta_exp elec_dist_1_5_z `controls'    , dvste(stderror_exp) cluster(country)  
			 eststo m2 
			 
		* 3. Bureaucratic Quality

			edvreg beta_exp prs2_z  `controls'    , dvste(stderror_exp) cluster(country)  
			eststo m3 

		* 4. Government Effectiveness

			edvreg beta_exp ge_est_z  `controls'    , dvste(stderror_exp) cluster(country) 
			eststo m4
			
		* 5. Direct Taxes/Revenue

			edvreg beta_exp dtax_per_rev_z  `controls'    , dvste(stderror_exp) cluster(country) 
			eststo m5 

		* 6. Log. GDP per capita

			edvreg beta_exp    gdp_pc_ln_z `controls'     , dvste(stderror_exp) cluster(country)  
			eststo m6 

		esttab using maintable_polity0.tex, label b(a2) se(a2)  star(* 0.10 ** 0.05 *** 0.01)  stats(N N_clust) compress title(Altering the Threshold for Democracies)  replace 
		eststo clear 

	
restore 


**   Table A.9: Turnout Inequality in Education


	* 1. Voting Polarization 
		edvreg edu_beta_exp VP_z `controls'  nat_secondary_z  , dvste(edu_stderror_exp) cluster(country) 
		eststo m1

	* 2. Electoral Distance Q1 & Q5

		 edvreg edu_beta_exp elec_dist_1_5_z `controls' nat_secondary_z   , dvste(edu_stderror_exp) cluster(country)  
		 eststo m2 
		 
	* 3. Bureaucratic Quality

		edvreg edu_beta_exp prs2_z  `controls' nat_secondary_z   , dvste(edu_stderror_exp) cluster(country)  
		eststo m3 

	* 4. Government Effectiveness

		edvreg edu_beta_exp ge_est_z  `controls'  nat_secondary_z  , dvste(edu_stderror_exp) cluster(country) 
		eststo m4
		
	* 5. Direct Taxes/Revenue

		edvreg edu_beta_exp dtax_per_rev_z  `controls' nat_secondary_z   , dvste(edu_stderror_exp) cluster(country) 
		eststo m5 

	* 6. Log. GDP per capita

		edvreg edu_beta_exp    gdp_pc_ln_z `controls'   nat_secondary_z  , dvste(edu_stderror_exp) cluster(country)  
		eststo m6 

		
		  
esttab using maintable_education.tex, b(a2) se(a2)  label star(* 0.10 ** 0.05 *** 0.01)  stats(N N_clust) compress title(Turnout Inequality in Education)  replace 
eststo clear



**   Table A.10: OLS and IV Regressions

* 1. Bureaucratic Quality

	reg beta_exp prs2_z  laam africa  if  war_premodern_share_z~=.   
	 eststo m1

	ivregress 2sls  beta_exp  laam africa (prs2_z = war_premodern_share_z)  , first  
	 eststo m11
	 
* 2. Government Effectiveness
 
	reg beta_exp ge_est_z  laam africa  if  war_premodern_share_z~=.   
	 eststo m2
	 
	 ivregress 2sls beta_exp   laam africa (ge_est_z = war_premodern_share_z)    , first  
	 eststo m21


* 3. Direct Taxes/Revenue
	reg beta_exp dtax_per_rev_z  laam africa if  war_premodern_share_z~=.     
	eststo m3
	 
	ivregress 2sls beta_exp   laam africa   (dtax_per_rev_z = war_premodern_share_z) , first  
	eststo m31


* 4.  Log. GDP per capita
	reg beta_exp gdp_pc_ln_z  laam africa    if  war_premodern_share_z~=.     
	eststo m4
	 
	ivregress 2sls beta_exp   laam africa (gdp_pc_ln_z = war_premodern_share_z)  , first  
	eststo m41
		
esttab using maintable_IV.tex, b(a2) se(a2)  label star(* 0.10 ** 0.05 *** 0.01)  stats(N N_clust)   compress title(OLS and IV Regressions)  replace 
eststo clear


 