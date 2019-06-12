	********************************************************************************************
	* Inter-regional Inequality and the Dynamics of Government Spending 
	* Online Appendix -- Section 7. Alternative Measures of Government Expenditure
	********************************************************************************************
	clear all
	set more off 
	set mem 600m
	cd "YOUR_DIRECTORY_PATH_HERE\supplements (online appendix)\appendix k"
	use "onlineappendix.dta"   

	*************************************
	** Rescaling / Modifying Variables                              
	*************************************
	egen govexp_subnational1 = rowtotal(govexp_state_cofog2 govexp_local_cofog2)
	replace govexp_subnational1 =. if govexp_state_cofog2==. & govexp_local_cofog2 ==.
	egen govexp_subnational2 = rowtotal(oecd_state_gdp oecd_local_gdp)
	replace govexp_subnational2 =. if oecd_state_gdp==. & oecd_local_gdp ==.	
	gen govexp_subnational3 = govexp_subnational1
	replace govexp_subnational3 = govexp_subnational2 if govexp_subnational1==. 
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
	foreach x of varlist adgini rpop_s1_rgdppc log_pop pop14_65 a log_rgdpch gov_left2 {
	gen ma`x' = (l1.`x' + l2.`x' + l3.`x' + l4.`x'+ l5.`x')/5
	}
	
	***********************
	** Renaming Variables  
	***********************
	rename govexp_central_cofog2 central_govtsp_function
	rename govexp_central_ecog2 central_govtsp_econchar
    rename govexp_general general_govtsp
	rename govexp_subnational3 local_govtsp
	rename jacoby_modified2 policy_priority
	rename maadgini rdgini
	rename marpop_s1_rgdppc mm_ratio
	rename malog_pop population_logged
	rename mapop14_65 dependent_population
	rename maa economic_globalization
	rename malog_rgdpch ppp_gdppc_logged
	rename magov_left2 leftistgovt
	rename Parl parliamentary 
	rename Unit2 nonfed_nonbicam
	
	*************************************************************************************
	** Appendix K. Robust to Alternative Measures for Change in Government Expenditure 
    *************************************************************************************

	global baseline l.population_logged l.d.population_logged l.dependent_population l.d.dependent_population l.economic_globalization l.d.economic_globalization l.ppp_gdppc_logged l.d.ppp_gdppc_logged l.leftistgovt 

	** Model [1]
	xi:xtpcse d.general_govtsp l.general_govtsp l.rdgini $baseline l.PR l.parliamentary l.nonfed_nonbicam i.id if year>=1991 & year<=2011, pairwise corr(psar1)
	predict pred if e(sample), xb
	gen resid = d.general_govtsp - pred
	egen stresid = std(resid)
	gen outlier = 0 if e(sample)
	replace outlier = 1 if abs(stresid)> 1.5
	xi:xtpcse d.general_govtsp l.general_govtsp l.rdgini $baseline l.PR l.parliamentary l.nonfed_nonbicam i.id if outlier!=1 & year>=1991 & year<=2011, pairwise corr(psar1)
	drop pred resid stresid outlier
	
	** Model [2]
	xi:xtpcse d.local_govtsp l.local_govtsp l.rdgini $baseline l.PR l.parliamentary l.nonfed_nonbicam i.id if year>=1991 & year<=2011, pairwise corr(psar1)
	predict pred if e(sample), xb
	gen resid = d.local_govtsp - pred
	egen stresid = std(resid)
	gen outlier = 0 if e(sample)
	replace outlier = 1 if abs(stresid)> 1.5
	xi:xtpcse d.local_govtsp l.local_govtsp l.rdgini $baseline l.PR l.parliamentary l.nonfed_nonbicam i.id if outlier!=1 & year>=1991 & year<=2011, pairwise corr(psar1)
	drop pred resid stresid outlier
	
	** Model [3]
	xi:xtpcse d.central_govtsp_econchar l.central_govtsp_econchar l.rdgini $baseline l.PR l.parliamentary l.nonfed_nonbicam i.id if year>=1991 & year<=2011, pairwise corr(psar1)
	predict pred if e(sample), xb
	gen resid = d.central_govtsp_econchar - pred
	egen stresid = std(resid)
	gen outlier = 0 if e(sample)
	replace outlier = 1 if abs(stresid)> 1.5
	xi:xtpcse d.central_govtsp_econchar l.central_govtsp_econchar l.rdgini $baseline l.PR l.parliamentary l.nonfed_nonbicam i.id if outlier!=1 & year>=1991 & year<=2011, pairwise corr(psar1)
	drop pred resid stresid outlier
	
	** Model [4]
	xi:xtpcse d.central_govtsp_econchar l.central_govtsp_econchar l.mm_ratio $baseline l.PR l.parliamentary l.nonfed_nonbicam i.id if year>=1991 & year<=2011, pairwise corr(psar1)
	predict pred if e(sample), xb
	gen resid = d.central_govtsp_econchar - pred
	egen stresid = std(resid)
	gen outlier = 0 if e(sample)
	replace outlier = 1 if abs(stresid)> 1.5
	xi:xtpcse d.central_govtsp_econchar l.central_govtsp_econchar l.mm_ratio $baseline l.PR l.parliamentary l.nonfed_nonbicam i.id if outlier!=1 & year>=1991 & year<=2011, pairwise corr(psar1)
	drop pred resid stresid outlier

			