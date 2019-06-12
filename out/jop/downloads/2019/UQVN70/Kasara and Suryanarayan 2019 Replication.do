*******************************************************
** Replication Data for Kasara & Suryanarayan (2019), "Bureaucratic Capacity and Class Voting: Evidence from Across the World and the United States"
** January 12, 2019 
** Stata Version 12 
*******************************************************
version 12 
ssc install estout, replace
* install edvreg.ado From Lewis, Jeffrey B., and Drew A. Linzer. 2005. Estimating Regression Models in Which the Dependent Variable Is Based on Estimates. Political Analysis 13 (4):345-364.(Source: http://svn.cluelessresearch.com/twostep/trunk/edvreg.ado) 
set more off 

** Set working directory 




*******************************************************
** 1. Cross-National 
*******************************************************

use "Kasara Suryanarayan 2019 Replication Data World", clear

*******************************************************
** 1.1 Main Tables in Paper 
*******************************************************

local controls         pr           compulsory   concurrent polity_score_z     giniall_gross_z     homicide_z ef_z    


** Table 1: Electoral Distance -- No Controls

		 
	* 1. Bureaucratic Quality

		edvreg  elec_dist_1_5  prs2_z  ,  dvste(elec15_se ) cluster(country)  
		eststo m1  

	* 2. Government effectiveness

		edvreg  elec_dist_1_5  ge_est_z  ,     dvste(elec15_se ) cluster(country)      
		eststo m2 
		
	* 3. Direct Taxes/Revenue

		edvreg  elec_dist_1_5  dtax_per_rev_z  ,  dvste(elec15_se ) cluster(country)    
		eststo m3 

	* 4. Log. GDP per capita

		edvreg  elec_dist_1_5     gdp_pc_ln_z  ,  dvste(elec15_se ) cluster(country)    
		eststo m4 

 
		esttab m1 m2 m3 m4  using Table_bare.tex, replace f   label booktabs alignment(c c c c c) b(3) p(3)  stats(N N_clust  , fmt(0 0 2) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  labels(`"N"' `"Countries"' `"\(R^{2}\)"')) order(prs2_z ge_est_z dtax_per_rev_z gdp_pc_ln_z  ) nogap nomtitles  starlevels(* 0.10 ** 0.05 *** 0.01) 
		eststo clear 

 
 ** Table 2: Electoral Distance
 
		 
	* 1. Bureaucratic Quality

		edvreg  elec_dist_1_5  prs2_z  `controls',  dvste(elec15_se ) cluster(country)  
		eststo m1  

	* 2. Government effectiveness

		edvreg  elec_dist_1_5  ge_est_z  `controls',     dvste(elec15_se ) cluster(country)      
		eststo m2 
		
	* 3. Direct Taxes/Revenue

		edvreg  elec_dist_1_5  dtax_per_rev_z  `controls',  dvste(elec15_se ) cluster(country)    
		eststo m3 

	* 4. Log. GDP per capita

		edvreg  elec_dist_1_5     gdp_pc_ln_z `controls',  dvste(elec15_se ) cluster(country)    
		eststo m4 

 
		esttab m1 m2 m3 m4  using Table_main.tex, replace f   label booktabs  alignment(c c c c c) b(3) p(3)  stats(N N_clust, fmt(0 0 2) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  labels(`"N"' `"Countries"' `"\(R^{2}\)"')) order(prs2_z ge_est_z dtax_per_rev_z gdp_pc_ln_z   ) nogap nomtitles  starlevels(* 0.10 ** 0.05 *** 0.01) 
		eststo clear 

  ** Table 3: Electoral Distance -- Controlling for BGI
 
		 
	* 1. Bureaucratic Quality
 
		
		edvreg  elec_dist_1_5  prs2_z   bgi_z   `controls'    ,  dvste(elec15_se ) cluster(country)  
		eststo m1 
		
	*2. Government Effectiveness

 
		
		edvreg  elec_dist_1_5  ge_est_z    bgi_z   `controls'     ,  dvste(elec15_se ) cluster(country)  
		eststo m2 
		
	* 3. Direct Taxes/Revenue

		  
		
		edvreg  elec_dist_1_5  dtax_per_rev_z  bgi_z    `controls'       ,  dvste(elec15_se ) cluster(country)
		eststo m3  

	*4. Log. GDP per capita

 
		
		edvreg  elec_dist_1_5     gdp_pc_ln_z   bgi_z   `controls'     ,  dvste(elec15_se ) cluster(country)  
		eststo m4  

 
 		esttab m1 m2 m3 m4  using Table_bgi.tex, replace f   label booktabs alignment(c c c c c) b(3) p(3)  stats(N N_clust  , fmt(0 0 2) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  labels(`"N"' `"Countries"' `"\(R^{2}\)"')) order(prs2_z ge_est_z dtax_per_rev_z gdp_pc_ln_z   ) nogap nomtitles  starlevels(* 0.10 ** 0.05 *** 0.01) 
		eststo clear 
		
 ** Table 4: Electoral Distance -- New Countries 

					 
		* 1. Bureaucratic Quality

			edvreg  elec_dist_1_5  prs2_z  `controls' if startyear > 1899,  dvste(elec15_se ) cluster(country)     
			eststo m1 

		* 2. Government Effectiveness

			edvreg  elec_dist_1_5  ge_est_z  `controls' if startyear > 1899,   dvste(elec15_se ) cluster(country)      
			eststo m2
			
		* 3. Direct Taxes/Revenue

			edvreg  elec_dist_1_5  dtax_per_rev_z  `controls' if startyear > 1899,   dvste(elec15_se ) cluster(country)      
			eststo m3 

		* 4. Log. GDP per capita

			edvreg  elec_dist_1_5     gdp_pc_ln_z `controls' if startyear > 1899,   dvste(elec15_se ) cluster(country)      
			eststo m4 
  
  
		esttab m1 m2 m3 m4   using Table_newcountries.tex, replace f   label booktabs alignment(c c c c c) b(3) p(3)  stats(N N_clust  , fmt(0 0 2) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  labels(`"N"' `"Countries"' `"\(R^{2}\)"')) order(prs2_z ge_est_z dtax_per_rev_z gdp_pc_ln_z   ) nogap nomtitles  starlevels(* 0.10 ** 0.05 *** 0.01) 
		eststo clear   

 
 ** Table 5: Electoral Distance -- Older Countries


		* 1. Bureaucratic Quality

			edvreg  elec_dist_1_5  prs2_z  `controls4' if startyear <= 1899 ,  dvste(elec15_se ) cluster(country)     
			eststo m1 

		* 2. Government Effectiveness

			edvreg  elec_dist_1_5  ge_est_z  `controls4' if startyear <= 1899 ,  dvste(elec15_se ) cluster(country)      
			eststo m2
			
		* 3. Direct Taxes/Revenue

			edvreg  elec_dist_1_5  dtax_per_rev_z  `controls4' if startyear <= 1899 ,  dvste(elec15_se ) cluster(country)      
			eststo m3 

		* 4. Log. GDP per capita

			edvreg  elec_dist_1_5     gdp_pc_ln_z `controls4' if startyear <= 1899 ,  dvste(elec15_se ) cluster(country)      
			eststo m4 

	  
		esttab m1 m2 m3 m4   using Table_oldcountries.tex, replace f   label booktabs alignment(c c c c c) b(3) p(3)  stats(N N_clust  , fmt(0 0 2) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  labels(`"N"' `"Countries"' `"\(R^{2}\)"')) order(prs2_z ge_est_z dtax_per_rev_z gdp_pc_ln_z   ) nogap nomtitles  starlevels(* 0.10 ** 0.05 *** 0.01) 
		eststo clear   
 

 ** Table 6: Electoral Distance -- Developed Countries
 
			 
	* 1. Bureaucratic Quality

		edvreg  elec_dist_1_5  prs2_z  `controls' if gdp_pc_ln_z > 0,  dvste(elec15_se ) cluster(country)   
		eststo m1 

	*2. Government Effectiveness

		edvreg  elec_dist_1_5  ge_est_z  `controls' if gdp_pc_ln_z >   0   ,  dvste(elec15_se ) cluster(country)  
		eststo m2
		
	* 3. Direct Taxes/Revenue

		edvreg  elec_dist_1_5  dtax_per_rev_z  `controls' if gdp_pc_ln_z >   0  ,  dvste(elec15_se ) cluster(country)  
		eststo m3 

	*4. Log. GDP per capita

		edvreg  elec_dist_1_5     gdp_pc_ln_z `controls' if gdp_pc_ln_z >   0  ,  dvste(elec15_se ) cluster(country)  
		eststo m4 

	
	 
	esttab m1 m2 m3 m4 using Table_richonly.tex, replace f   label booktabs alignment(c c c c c) b(3) p(3)  stats(N N_clust  , fmt(0 0 2) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  labels(`"N"' `"Countries"' `"\(R^{2}\)"')) order(prs2_z ge_est_z dtax_per_rev_z gdp_pc_ln_z  ) nogap nomtitles  starlevels(* 0.10 ** 0.05 *** 0.01) 
	eststo clear   
	 
 ** Table 7: Electoral Distance -- Developing Countries

		 
	* 1. Bureaucratic Quality

		edvreg  elec_dist_1_5  prs2_z  `controls4' if gdp_pc_ln_z <= 0,  dvste(elec15_se ) cluster(country)   
		eststo m1 

	*2. Government Effectiveness

		edvreg  elec_dist_1_5  ge_est_z  `controls4' if gdp_pc_ln_z <=   0   ,  dvste(elec15_se ) cluster(country)  
		eststo m2
		
	* 3. Direct Taxes/Revenue

		edvreg  elec_dist_1_5  dtax_per_rev_z  `controls4' if gdp_pc_ln_z <=   0  ,  dvste(elec15_se ) cluster(country)  
		eststo m3 

	*4. Log. GDP per capita

		edvreg  elec_dist_1_5     gdp_pc_ln_z `controls4' if gdp_pc_ln_z <=  0  ,  dvste(elec15_se ) cluster(country)  
		eststo m4 

	
	 
	esttab m1 m2 m3 m4 using Table_pooronly.tex, replace f   label booktabs alignment(c c c c c) b(3) p(3)  stats(N N_clust  , fmt(0 0 2) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  labels(`"N"' `"Countries"' `"\(R^{2}\)"')) order(prs2_z ge_est_z dtax_per_rev_z gdp_pc_ln_z  ) nogap nomtitles  starlevels(* 0.10 ** 0.05 *** 0.01) 
	eststo clear   	


*******************************************************
** 1.2 Tables in Supporting Information 
*******************************************************
  
  ** Table S1: Countries and Surveys (not shown) 
  ** Table S2: Descriptive Statistics (not shown) 
  
  
  ** Table S3: Voting Polarization 
  
   
	* 1. Bureaucratic Quality

		edvreg  VP prs2_z  `controls'    ,  dvste(vp_se) cluster(country)  
		eststo m1 

	*2. Government Effectiveness

		edvreg  VP ge_est_z  `controls'     ,  dvste(vp_se) cluster(country)  
		eststo m2
		
	* 3. Direct Taxes/Revenue

		edvreg  VP dtax_per_rev_z  `controls'   ,  dvste(vp_se) cluster(country)    
		eststo m3 

	*4. Log. GDP per capita

		edvreg  VP    gdp_pc_ln_z `controls'    ,  dvste(vp_se) cluster(country)   
		eststo m4 


	  
	esttab m1 m2 m3 m4 using Table_VP.tex, replace f   label booktabs alignment(c c c c c) b(3) p(3)  stats(N N_clust  , fmt(0 0 2) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  labels(`"N"' `"Countries"' `"\(R^{2}\)"')) order(prs2_z ge_est_z dtax_per_rev_z gdp_pc_ln_z   ) nogap nomtitles  starlevels(* 0.10 ** 0.05 *** 0.01) 
	eststo clear   
		 
		 
  
  ** Table S4: Electoral Distance -- Premodern War IV 
  
   
	* 1 Bureaucratic Quality 
		reg elec_dist_1_5  prs2_z     if  war_premodern_casualties_z~=.  , vce(cluster country) 
		eststo m1 

		ivregress 2sls  elec_dist_1_5     (prs2_z = war_premodern_casualties_z)  , first  vce(cluster country) 
		eststo m2
	 
	** 2. Government Effectiveness 
		reg elec_dist_1_5  ge_est_z      if  war_premodern_casualties_z~=.   ,  vce(cluster country) 
		eststo m3
	 
		ivregress 2sls elec_dist_1_5       (ge_est_z = war_premodern_casualties_z)    , first  vce(cluster country) 
		eststo m4

	 
	** 3. Direct Taxes/Revenue 
		reg elec_dist_1_5  dtax_per_rev_z       if  war_premodern_casualties_z~=.   ,  vce(cluster country) 
		eststo m5
	 
		ivregress 2sls elec_dist_1_5        (dtax_per_rev_z = war_premodern_casualties_z)    , first  vce(cluster country) 
		eststo m6
	 
	** 4. Log GDP per capita 

		reg elec_dist_1_5  gdp_pc_ln_z    if  war_premodern_casualties_z~=.  ,  vce(cluster country)  
		eststo m7
	 
		ivregress 2sls elec_dist_1_5       (gdp_pc_ln_z = war_premodern_casualties_z)    , first  vce(cluster country) 
		eststo m8

		esttab using Table_IV.tex,  replace f   label booktabs  alignment(c c c c c c c c c ) b(3) p(3)  stats(N N_clust, fmt(0 0 2) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  labels(`"N"' `"Countries"' `"\(R^{2}\)"')) order(prs2_z ge_est_z dtax_per_rev_z gdp_pc_ln_z   ) nogap mtitles("\emph{OLS}" "\emph{IV}" "\emph{OLS}" "\emph{IV}" "\emph{OLS}" "\emph{IV}" "\emph{OLS}" "\emph{IV}"  )   starlevels(* 0.10 ** 0.05 *** 0.01) 
		eststo clear 
	
  ** Table S5: Electoral Distance -- With Infant Mortality 
 
		 
	* 1. Bureaucratic Quality

		edvreg  elec_dist_1_5  prs2_z infantmortality_z  `controls',  dvste(elec15_se ) cluster(country)   
		eststo m1 

	* 2. Government effectiveness

		edvreg  elec_dist_1_5  ge_est_z  infantmortality_z `controls',     dvste(elec15_se ) cluster(country)      
		eststo m2
		
	* 3. Direct Taxes/Revenue

		edvreg  elec_dist_1_5  dtax_per_rev_z  infantmortality_z `controls',  dvste(elec15_se ) cluster(country)    
		eststo m3 

	* 4. Log. GDP per capita

		edvreg  elec_dist_1_5     gdp_pc_ln_z infantmortality_z `controls',  dvste(elec15_se ) cluster(country)    
		eststo m4 

 
 
 		esttab m1 m2 m3 m4  using Table_infmort.tex, replace f   label booktabs alignment(c c c c c) b(3) p(3)  stats(N N_clust  , fmt(0 0 2) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  labels(`"N"' `"Countries"' `"\(R^{2}\)"')) order(prs2_z ge_est_z dtax_per_rev_z gdp_pc_ln_z   ) nogap nomtitles  starlevels(* 0.10 ** 0.05 *** 0.01) 
		eststo clear 
  
  ** Table S6: Electoral Distance -- Altering the Threshold for Democracies 
  
  
	* 1. Bureaucratic Quality

		edvreg  elec_dist_1_5  prs2_z  `controls'  if polity_score > 0  ,  dvste(elec15_se ) cluster(country)  
		eststo m1 

	*2. Government Effectiveness

		edvreg  elec_dist_1_5  ge_est_z  `controls'  if polity_score > 0   ,  dvste(elec15_se ) cluster(country)  
		eststo m2
		
	* 3. Direct Taxes/Revenue

		edvreg  elec_dist_1_5  dtax_per_rev_z  `controls' if polity_score > 0  ,  dvste(elec15_se ) cluster(country)    
		eststo m3 

	*4. Log. GDP per capita

		edvreg  elec_dist_1_5     gdp_pc_ln_z `controls'  if polity_score > 0  ,  dvste(elec15_se ) cluster(country)   
		eststo m4 
		

	 
	esttab m1 m2 m3 m4  using Table_polity0.tex, replace f   label booktabs alignment(c c c c c) b(3) p(3)  stats(N N_clust  , fmt(0 0 2) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  labels(`"N"' `"Countries"' `"\(R^{2}\)"')) order(prs2_z ge_est_z dtax_per_rev_z gdp_pc_ln_z   ) nogap nomtitles  starlevels(* 0.10 ** 0.05 *** 0.01) 
	eststo clear   
 

  ** Tables S7-S11: Dropping each survey source 
  
  local surveygroup cses wvs lapop latinob   afrob

	foreach i of local surveygroup { 


			 
		* 1. Bureaucratic Quality

			edvreg  elec_dist_1_5  prs2_z   `controls'  if `i' ~= 1 ,  dvste(elec15_se ) cluster(country)  
			eststo m1  

		* 2. Government effectiveness

			edvreg  elec_dist_1_5  ge_est_z  `controls'  if `i' ~= 1,     dvste(elec15_se ) cluster(country)      
			eststo m2 
			
		* 3. Direct Taxes/Revenue

			edvreg  elec_dist_1_5  dtax_per_rev_z  `controls'    if `i' ~= 1,  dvste(elec15_se ) cluster(country)    
			eststo m3 

		* 4. Log. GDP per capita

			edvreg  elec_dist_1_5     gdp_pc_ln_z  `controls'  if `i' ~= 1,  dvste(elec15_se ) cluster(country)    
			eststo m4 

	 
			esttab m1 m2 m3 m4  using Table_no`i'.tex, replace f   label booktabs alignment(c c c c c) b(3) p(3)  stats(N N_clust  , fmt(0 0 2) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  labels(`"N"' `"Countries"' `"\(R^{2}\)"')) order(prs2_z ge_est_z dtax_per_rev_z gdp_pc_ln_z   ) nogap nomtitles  starlevels(* 0.10 ** 0.05 *** 0.01) 
			eststo clear 
			


	}



*******************************************************
** 2. United States 
*******************************************************

use "Kasara Suryanarayan 2019 Replication Data US", clear


*******************************************************
** 2.1 Main Tables in Paper 
*******************************************************

	 local controls   deepsouth prop_black_z   prop_manuemp_z  
	 local controls1    prop_black_z   prop_manuemp_z 
	 local controls2    deepsouth prop_black_z   percent_org_39_z  
	 local controls21      prop_black_z   percent_org_39_z  


** Table 8: U.S. Electoral Distance 

	edvreg  elec_dist_1_3_36  dtax_rev32_z    `controls'     ,   dvste(elec13_se) 
	estimates store m0 
	
	
	edvreg  elec_dist_1_3_36  tax_rev32_z    `controls'     ,   dvste(elec13_se) 
	estimates store m1 

	edvreg  elec_dist_1_3_36  dtax_rev32_z  gini30_irs_z   `controls'     ,   dvste(elec13_se) 
	estimates store m2 

	edvreg  elec_dist_1_3_36  dtax_rev32_z    gini30_irs_z bgi_race_z  `controls'    ,   dvste(elec13_se) 
	estimates store m3 

	 
	edvreg  elec_dist_1_3_36  dtax_rev32_z    gini30_irs_z bgi_race_z    `controls1' if deepsouth == 0 ,   dvste(elec13_se) 
	estimates store m4 
 

	esttab m0 m1 m2 m3 m4  using USTable_main.tex, replace f   label booktabs alignment(c c c c c) b(3) p(3)  star(*  0.10 ** 0.05 *** 0.01 )  mtitle("\emph{All}" "\emph{All}" "\emph{All}" "\emph{All}" "\emph{North}")    stats(N  , fmt(0 2) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  labels(`"N"')) order(dtax_rev32_z tax_rev32_z  gini30_irs_z bgi_race_z  tax_rev32_z) nogap   
	eststo clear 

*******************************************************
** 2.2 Tables in Supporting Information 
*******************************************************


  ** Table S12: U.S.: Electoral Distance -- Controlling for Union Membership 
  
 
	edvreg  elec_dist_1_3_36  dtax_rev32_z    `controls2'     ,   dvste(elec13_se) 
	estimates store m0 
	
	
	edvreg  elec_dist_1_3_36  tax_rev32_z    `controls2'     ,   dvste(elec13_se) 
	estimates store m1 

	edvreg  elec_dist_1_3_36  dtax_rev32_z  gini30_irs_z   `controls2'     ,   dvste(elec13_se) 
	estimates store m2 

	edvreg  elec_dist_1_3_36  dtax_rev32_z    gini30_irs_z bgi_race_z  `controls2'    ,   dvste(elec13_se) 
	estimates store m3 

	 
	edvreg  elec_dist_1_3_36  dtax_rev32_z    gini30_irs_z bgi_race_z    `controls21' if deepsouth == 0 ,   dvste(elec13_se) 
	estimates store m4 
 

	esttab m0 m1 m2 m3 m4  using USTable_union.tex, replace f   label booktabs alignment(c c c c c) b(3) p(3)  star(*  0.10 ** 0.05 *** 0.01 )  mtitle("\emph{All}" "\emph{All}" "\emph{All}" "\emph{All}" "\emph{North}")  stats(N  , fmt(0 2) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  labels(`"N"')) order(dtax_rev32_z tax_rev32_z  gini30_irs_z bgi_race_z  tax_rev32_z percent_org_39_z) nogap   
	eststo clear 

  ** Table S13: U.S.: Voting Polarization 
  
 
	 reg   VP36 dtax_rev32_z     `controls'    
	 estimates store m0 
	 
	 
	 reg   VP36 tax_rev32_z     `controls'      
	 estimates store m1 

	 reg   VP36 dtax_rev32_z  gini30_irs_z   `controls'    
	 estimates store m2 

	 reg   VP36 dtax_rev32_z     gini30_irs_z bgi_race_z  `controls'   
	 estimates store m3

	 reg   VP36 dtax_rev32_z    gini30_irs_z bgi_race_z  `controls1'  if deepsouth == 0  
	 estimates store m4



		esttab m0 m1 m2 m3 m4  using USTable_VP.tex, replace f   label booktabs alignment(c c c c c) b(3) p(3)  star(*  0.10 ** 0.05 *** 0.01 )  mtitle("\emph{All}" "\emph{All}" "\emph{All}" "\emph{All}" "\emph{North}")  stats(N  , fmt(0 2) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  labels(`"N"')) order(dtax_rev32_z tax_rev32_z  gini30_irs_z bgi_race_z   ) nogap   
		eststo clear 
		
	
  ** Table S14:  U.S.: Electoral Distance - Four Groups 

		reg   elec_dist_1_4_36 dtax_rev32_z    `controls'    
		estimates store m0 
		 
		reg   elec_dist_1_4_36 tax_rev32_z    `controls'    
		estimates store m1 


		reg   elec_dist_1_4_36 dtax_rev32_z  gini30_irs_z   `controls'   
		estimates store m2 

		reg   elec_dist_1_4_36 dtax_rev32_z    gini30_irs_z bgi_race_z  `controls'   
		estimates store m3

		reg   elec_dist_1_4_36 dtax_rev32_z    gini30_irs_z bgi_race_z  `controls1'  if deepsouth == 0  
		estimates store m4
		 
		esttab m0 m1 m2 m3 m4  using USTable_4groups.tex, replace f   label booktabs alignment(c c c c c) b(3) p(3)  star(*  0.10 ** 0.05 *** 0.01 )  mtitle("\emph{All}" "\emph{All}" "\emph{All}" "\emph{All}" "\emph{North}")  stats(N  , fmt(0 2) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  labels(`"N"')) order(dtax_rev32_z tax_rev32_z  gini30_irs_z bgi_race_z  tax_rev32_z) nogap 
		eststo clear 

  ** Table S15: U.S.: Electoral Distance in Partisanship 
  
	  
		reg  elec_dist_1_3_party  dtax_rev32_z    `controls'     
		estimates store m0 
		
		reg  elec_dist_1_3_party  tax_rev32_z    `controls'     
		estimates store m1 

		reg  elec_dist_1_3_party  dtax_rev32_z  gini30_irs_z   `controls'     
		estimates store m2 

		reg  elec_dist_1_3_party  dtax_rev32_z    gini30_irs_z bgi_race_z  `controls'  
		estimates store m3 

		 
		reg  elec_dist_1_3_party  dtax_rev32_z    gini30_irs_z bgi_race_z  `controls1'  if deepsouth == 0
		estimates store m4 
		
	 
		esttab m0 m1 m2 m3 m4  using USTable_party.tex, replace f   label booktabs alignment(c c c c c) b(3) p(3)  star(*  0.10 ** 0.05 *** 0.01 )  mtitle("\emph{All}" "\emph{All}" "\emph{All}" "\emph{All}" "\emph{North}")  stats(N  , fmt(0 2) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}")  labels(`"N"')) order(dtax_rev32_z tax_rev32_z  gini30_irs_z bgi_race_z  tax_rev32_z) nogap 
		eststo clear 


 
 