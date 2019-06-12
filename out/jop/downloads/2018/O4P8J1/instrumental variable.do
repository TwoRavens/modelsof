	***************************************************************************************
	* Inter-regional Inequality and the Dynamics of Government Spending 
	* Online Appendix -- Section 9. Level Results and Instrumental Variables Analysis 
	***************************************************************************************
	clear all
	set more off 
	set mem 600m
	cd "YOUR_DIRECTORY_PATH_HERE\supplements (online appendix)\appendix o"
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

    ********************************************
    ** 5 Year Averages and Modifying Variables  
    ********************************************	
	gen 	year5 = 1 if year>=1991 & year <=1995
	replace year5 = 2 if year>=1996 & year <=2000
	replace year5 = 3 if year>=2001 & year <=2005
	replace year5 = 4 if year>=2006 & year <=2010

	collapse (mean) govexp_central_cofog2 adgini adgini_01 coeff_of_var3 rpop_s1_rgdppc ///
	pop pop14_65 a rgdpch gov_left2 (max) PR Parl Unit2, by(id year5) 

	gen log_pop = log(pop)
	gen log_rgdpch = log(rgdpch)
	tab year5, gen(t5_)
	drop if year5==.
	tab id, gen(s_)
	tsset id year5
	
    ************************
	** Renaming Variables 
	************************
    rename govexp_central_cofog2 central_govtsp
    rename adgini rdgini
	rename log_pop population_logged
	rename pop14_65 dependent_population 
	rename a economic_globalization
	rename log_rgdpch ppp_gdppc_logged
	rename gov_left2 leftistgovt
	rename coeff_of_var3 dispersion_soccerpoints
	rename adgini_01 rdgini_contiguouscountries
	
	*******************************************************************************
	** Appendix O. The Level of Central Government Expenditure in 5-year Averages
	*******************************************************************************
    * Model [1]    
	xi: xtreg central_govtsp rdgini population_logged dependent_population economic_globalization ppp_gdppc_logged leftistgovt i.year5, fe robust

    * Model [2]
	jive central_govtsp population_logged dependent_population economic_globalization ppp_gdppc_logged leftistgovt t5_* s_* (rdgini = dispersion_soccerpoints rdgini_contiguouscountries), robust
	xi: ivreg2 central_govtsp population_logged dependent_population economic_globalization ppp_gdppc_logged leftistgovt i.year5 (rdgini = dispersion_soccerpoints rdgini_contiguouscountries), gmm2s robust small first
	