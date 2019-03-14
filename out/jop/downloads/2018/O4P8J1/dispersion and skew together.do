	***********************************************************************************
	* Inter-regional Inequality and the Dynamics of Government Spending 
	* Online Appendix -- Section 12. Models Including Dispersion and Skew
	***********************************************************************************
	clear all
	set more off 
	set mem 600m
	cd "YOUR_DIRECTORY_PATH_HERE\supplements (online appendix)\appendix s"
	use "onlineappendix.dta"   

	*************************************
	** Rescaling / Modifying Variables                              
	*************************************
	sort id year 
	sum ideal_pt_V1, meanonly
	gen jacoby_modified2 = ideal_pt_V1 - `r(mean)'
	replace adgini = adgini*100
	replace jacoby_modified2 = jacoby_modified2*100
	replace ineq_spns = ineq_spns*100
	gen log_pop = log(pop)	
	gen log_rgdpch = log(rgdpch)
	gen pop14_65 = popunder14 + popover65

	**************************************
	* Generate five-year moving averages 
	**************************************
	foreach x of varlist adgini rpop_s1_rgdppc ///
	ineq_spns rgdppc_density ///
    log_pop pop14_65 a log_rgdpch gov_left2 {
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

    /*Spearsman*/
	spearman rdgini mm_ratio, bonferroni 
	
	*************************************************************
	* Appendix S. Robust to Models Including Dispersin and Skew 
	*************************************************************

	global baseline l.population_logged l.d.population_logged l.dependent_population l.d.dependent_population l.economic_globalization l.d.economic_globalization l.ppp_gdppc_logged l.d.ppp_gdppc_logged l.leftist_power
	
    * Model [1]
	xi:xtpcse d.central_govtspending l.central_govtspending l.rdgini l.mm_ratio $baseline i.id if year>=1991 & year<=2011, pairwise corr(psar1) noconst het 	
	est store j1
	tempname r2_a
	scalar `r2_a' = 1 - (1 - e(r2))*( e(N) -1)/(e(N)-e(n_cf)-1)
	di in green "Adj R-Squared = " %-6.4f `r2_a'	

	* Model [2]
	xi:xtpcse d.central_govtspending l.central_govtspending l.rdgini l.mm_ratio $baseline l.PR l.parliamentary l.nonfederal_nonbicameral i.id if year>=1991 & year<=2011, pairwise corr(psar1) noconst	het	
	est store j2
	tempname r2_a
	scalar `r2_a' = 1 - (1 - e(r2))*( e(N) -1)/(e(N)-e(n_cf)-1)
	di in green "Adj R-Squared = " %-6.4f `r2_a'	

	* Model [3]
	xi:xtpcse d.policy_priority l.policy_priority l.rdgini l.mm_ratio id if year>=1991 & year<=2011, pairwise corr(psar1) noconst het	
	est store j3
	tempname r2_a
	scalar `r2_a' = 1 - (1 - e(r2))*( e(N) -1)/(e(N)-e(n_cf)-1)
	di in green "Adj R-Squared = " %-6.4f `r2_a' 	
	
	* Model [4]
	xi:xtpcse d.policy_priority l.policy_priority l.rdgini l.mm_ratio $baseline l.PR l.parliamentary l.nonfederal_nonbicameral i.id if year>=1991 & year<=2011, pairwise corr(psar1) noconst het	
	est store j4
	tempname r2_a
	scalar `r2_a' = 1 - (1 - e(r2))*( e(N) -1)/(e(N)-e(n_cf)-1)
	di in green "Adj R-Squared = " %-6.4f `r2_a'
	
