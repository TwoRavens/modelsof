	******************************************************************************
	* Title: Inter-regional Inequality and the Dynamics of Government Spending  ** 
	* Empirical Regression Results (Main Text)                                  **
	* Authors: Dong Wook Lee & Melissa Rogers                                   **
	******************************************************************************
	clear all
	set more off 
	set mem 600m
	cd "C:\Users\DWLEE\Google Drive\companion paper with Melissa\JOP R&R Checklist\JOP R&R\JOP Final Submission Dataverse\tables (maintext)"
	use "masterdata_resulttables_maintext.dta"   
	
 	*************************************
	** Rescale variables   / Generate  **                           
	*************************************
	sort id year 
	sum ideal_pt_V1, meanonly
	gen jacoby_modified2 = ideal_pt_V1 - `r(mean)'   /*"ideal_pt_V1" is a name for the variable that measures central government spending priorities 
	                                                    across competitive policy programs. This spending priority score are normalized in distance to 
														their global mean value.*/
	replace adgini = adgini*100                      /*Rescaled as a percentage*/
	replace jacoby_modified2 = jacoby_modified2*100  /*Rescaled as a percentage*/
	gen log_pop = log(pop)	                         /*Logged population*/
	gen log_rgdpch = log(rgdpch)                     /*Logged ppp converted GDP per capita*/
	gen pop14_65 = popunder14 + popover65            /*Dependent population (% of the total): age either under 14 or above 64*/

	***************************************************************************************************************************************
	* Generate five-year moving averages for the time-variant variables to be included in central government spending models (1980-2010) ** 
	***************************************************************************************************************************************
	foreach x of varlist adgini rpop_s1_rgdppc log_pop pop14_65 a log_rgdpch gov_left2 {
	gen ma`x' = (l1.`x' + l2.`x' + l3.`x' + l4.`x'+ l5.`x')/5
	}

	************************************************************
	** Renaming variables in match with the table of results  **
	************************************************************
	rename govexp_central_cofog2 central_govtspending
	rename maadgini rdgini
	rename marpop_s1_rgdppc mm_ratio
	rename malog_pop population_logged
	rename mapop14_65 dependent_population
	rename maa economic_globalization
	rename malog_rgdpch ppp_gdppc_logged
	rename magov_left2 leftist_power
	rename Parl parliamentary
	rename Unit2 nonfederal_nonbicameral
	rename jacoby_modified2 policy_priority
	
	**************************************************************************************
	* Model Analysis: Table 1. Determinants of Change in Central Government Spending    ** 
	**************************************************************************************

	global baseline l.population_logged l.d.population_logged l.dependent_population l.d.dependent_population l.economic_globalization l.d.economic_globalization l.ppp_gdppc_logged l.d.ppp_gdppc_logged l.leftist_power

	** Models [1] through [4] with Dispersion of Inter-regional Productivity (RDGINI)**

	/* Model [1]*/
	xi:xtpcse d.central_govtspending l.central_govtspending l.rdgini $baseline l.PR i.id if year>=1991 & year<=2011, pairwise corr(psar1) 
	tempname r2_a
	scalar `r2_a' = 1 - (1 - e(r2))*( e(N) -1)/(e(N)-e(n_cf)-1)
	di in green "Adj R-Squared = " %-6.4f `r2_a'

	/* Model [2]*/
	xi:xtpcse d.central_govtspending l.central_govtspending l.rdgini $baseline l.parliamentary i.id if year>=1991 & year<=2011, pairwise corr(psar1) 
	tempname r2_a
	scalar `r2_a' = 1 - (1 - e(r2))*( e(N) -1)/(e(N)-e(n_cf)-1)
	di in green "Adj R-Squared = " %-6.4f `r2_a'

	/* Model [3]*/
	xi:xtpcse d.central_govtspending l.central_govtspending l.rdgini $baseline l.nonfederal_nonbicameral i.id if year>=1991 & year<=2011, pairwise corr(psar1) 
	tempname r2_a
	scalar `r2_a' = 1 - (1 - e(r2))*( e(N) -1)/(e(N)-e(n_cf)-1)
	di in green "Adj R-Squared = " %-6.4f `r2_a'	

	/* Model [4]*/
	xi:xtpcse d.central_govtspending l.central_govtspending l.rdgini $baseline l.PR l.parliamentary l.nonfederal_nonbicameral i.id if year>=1991 & year<=2011, pairwise corr(psar1) 
	tempname r2_a
	scalar `r2_a' = 1 - (1 - e(r2))*( e(N) -1)/(e(N)-e(n_cf)-1)
	di in green "Adj R-Squared = " %-6.4f `r2_a'

	
	** Models [5] through [8] with Skew of Inter-regional Productivity (MM_RATIO) **

	/* Model [5]*/
	xi:xtpcse d.central_govtspending l.central_govtspending l.mm_ratio $baseline l.PR i.id if year>=1991 & year<=2011, pairwise corr(psar1)
	tempname r2_a
	scalar `r2_a' = 1 - (1 - e(r2))*( e(N) -1)/(e(N)-e(n_cf)-1)
	di in green "Adj R-Squared = " %-6.4f `r2_a'

    /* Model [6]*/	
	xi:xtpcse d.central_govtspending l.central_govtspending l.mm_ratio $baseline l.parliamentary i.id  if year>=1991 & year<=2011, pairwise corr(psar1)
	tempname r2_a
	scalar `r2_a' = 1 - (1 - e(r2))*( e(N) -1)/(e(N)-e(n_cf)-1)
	di in green "Adj R-Squared = " %-6.4f `r2_a'
	
    /* Model [7]*/	
	xi:xtpcse d.central_govtspending l.central_govtspending l.mm_ratio $baseline l.nonfederal_nonbicameral i.id  if year>=1991 & year<=2011, pairwise corr(psar1)
	tempname r2_a
	scalar `r2_a' = 1 - (1 - e(r2))*( e(N) -1)/(e(N)-e(n_cf)-1)
	di in green "Adj R-Squared = " %-6.4f `r2_a'
	
    /* Model [8]*/	
	xi:xtpcse d.central_govtspending l.central_govtspending l.mm_ratio $baseline l.PR l.parliamentary l.nonfederal_nonbicameral i.id if year>=1991 & year<=2011, pairwise corr(psar1)
	tempname r2_a
	scalar `r2_a' = 1 - (1 - e(r2))*( e(N) -1)/(e(N)-e(n_cf)-1)
	di in green "Adj R-Squared = " %-6.4f `r2_a'
	
	
	**************************************************************************
	* Table 2. Determinants of Change in Central Government Policy Priority **
	**************************************************************************
	
	** Models [9] through [12] with Dispersion of Inter-regional Productivity (RDGINI)**

	/* Model [9]*/
	xi:xtpcse  d.policy_priority l.policy_priority l.rdgini $baseline l.PR i.id if year>=1991 & year<=2011, pairwise corr(psar1) 
	tempname r2_a
	scalar `r2_a' = 1 - (1 - e(r2))*( e(N) -1)/(e(N)-e(n_cf)-1)
	di in green "Adj R-Squared = " %-6.4f `r2_a'

	/* Model [10]*/
	xi:xtpcse  d.policy_priority l.policy_priority l.rdgini $baseline l.parliamentary i.id if year>=1991 & year<=2011, pairwise corr(psar1) 
	tempname r2_a
	scalar `r2_a' = 1 - (1 - e(r2))*( e(N) -1)/(e(N)-e(n_cf)-1)
	di in green "Adj R-Squared = " %-6.4f `r2_a'

	/* Model [11]*/
	xi:xtpcse  d.policy_priority l.policy_priority l.rdgini $baseline l.nonfederal_nonbicameral i.id if year>=1991 & year<=2011, pairwise corr(psar1) 
	tempname r2_a
	scalar `r2_a' = 1 - (1 - e(r2))*( e(N) -1)/(e(N)-e(n_cf)-1)
	di in green "Adj R-Squared = " %-6.4f `r2_a'

	/* Model [12]*/
	xi:xtpcse  d.policy_priority l.policy_priority l.rdgini $baseline l.PR l.parliamentary l.nonfederal_nonbicameral i.id if year>=1991 & year<=2011, pairwise corr(psar1)
	tempname r2_a
	scalar `r2_a' = 1 - (1 - e(r2))*( e(N) -1)/(e(N)-e(n_cf)-1)
	di in green "Adj R-Squared = " %-6.4f `r2_a'

	
	** Models [13] through [18] with Skew of Inter-regional Productivity (MM_RATIO) **

    /* Model [13]*/
	xi:xtpcse d.policy_priority l.policy_priority l.mm_ratio $baseline l.PR i.id if year>=1991 & year<=2011, pairwise corr(psar1) 
	tempname r2_a
	scalar `r2_a' = 1 - (1 - e(r2))*( e(N) -1)/(e(N)-e(n_cf)-1)
	di in green "Adj R-Squared = " %-6.4f `r2_a'	

	/* Model [14]*/
	xi:xtpcse d.policy_priority l.policy_priority l.mm_ratio $baseline l.parliamentary i.id if year>=1991 & year<=2011, pairwise corr(psar1) 
	tempname r2_a
	scalar `r2_a' = 1 - (1 - e(r2))*( e(N) -1)/(e(N)-e(n_cf)-1)
	di in green "Adj R-Squared = " %-6.4f `r2_a'	

	/* Model [15]*/
	xi:xtpcse d.policy_priority l.policy_priority l.mm_ratio $baseline l.nonfederal_nonbicameral i.id if year>=1991 & year<=2011, pairwise corr(psar1) 
	tempname r2_a
	scalar `r2_a' = 1 - (1 - e(r2))*( e(N) -1)/(e(N)-e(n_cf)-1)
	di in green "Adj R-Squared = " %-6.4f `r2_a'

	/* Model [16]*/
	xi:xtpcse d.policy_priority l.policy_priority l.mm_ratio $baseline l.PR l.parliamentary l.nonfederal_nonbicameral i.id if year>=1991 & year<=2011, pairwise corr(psar1) 
	tempname r2_a
	scalar `r2_a' = 1 - (1 - e(r2))*( e(N) -1)/(e(N)-e(n_cf)-1)
	di in green "Adj R-Squared = " %-6.4f `r2_a'
	


