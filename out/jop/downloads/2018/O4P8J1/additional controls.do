	*****************************************************************************
	* Inter-regional Inequality and the Dynamics of Government Spending 
	* Online Appendix -- Section 11. Additional Controls
	*****************************************************************************
	clear all
	set more off 
	set mem 600m
	cd "YOUR_DIRECTORY_PATH_HERE\supplements (online appendix)\appendix q"
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
	gen logmal=ln(combined_malapp)

	**************************************
	* Generate five-year moving averages 
	**************************************
	tsset id year
	foreach x of varlist rpop_s1_rgdppc log_rgdpch log_pop govexp_central_cofog2 ///
	adgini pop14_65 gov_left2 natural_resource a gini_market psns_sw adgini_housing rgdppc_adjusted2 {
	gen ma`x' = (l1.`x' + l2.`x' + l3.`x' + l4.`x'+ l5.`x')/5
	}
	
	**********************
	* Renaming variables
	********************** 
	rename govexp_central_cofog2 central_govtsp
	rename jacoby_modified2 policy_priority
	rename maadgini rdgini
	rename marpop_s1_rgdppc mm_ratio
	rename magini_market gini_household_market
	rename malog_pop population_logged
	rename mapop14_65 dependent_population
	rename maa economic_globalization
	rename malog_rgdpch gdppc_logged
	rename magov_left2 leftistgovt
	rename Parl parliamentary 
	rename Unit2 nonfed_nonbicam
	rename logmal legi_malapproportionment
	rename mapsns_sw partysysnational
	rename manatural_resource naturalresource_rent
	rename maadgini_housing rdgini_livingcost
	rename margdppc_adjusted2 mm_ratio_livingcost
	
	************************************************************************
	** Appendix Q. Robust to Additional Controls, OECD Nations (1991-2011)
	************************************************************************

	global baseline_1 l.population_logged l.d.population_logged l.dependent_population l.d.dependent_population l.economic_globalization l.d.economic_globalization l.gdppc_logged l.d.gdppc_logged l.leftistgovt l.gini_household_market	

    ** (1). Models additionally controlling for the effect of "Household Income Gini" 	
    
	* Report the estimated coefficeint of RDGINI
	xi:xtpcse d.central_govtsp l.rdgini   l.central_govtsp $baseline_1 l.PR l.parliamentary l.nonfed_nonbicam i.id if year>=1991 & year<=2011, pairwise corr(psar1)

    * Report the estimated coefficeint of MM_RATIO
	xi:xtpcse d.central_govtsp l.mm_ratio l.central_govtsp $baseline_1 l.PR l.parliamentary l.nonfed_nonbicam i.id if year>=1991 & year<=2011, pairwise corr(psar1)

    * Report the estimated coefficient of RDGINI
	xi:xtpcse d.policy_priority l.rdgini l.policy_priority $baseline_1 l.PR l.parliamentary l.nonfed_nonbicam i.id if year>=1991 & year<=2011, pairwise corr(psar1)

	* Report the estimated coefficient of MM_RATIO
	xi:xtpcse d.policy_priority l.mm_ratio l.policy_priority $baseline_1 l.PR l.parliamentary l.nonfed_nonbicam i.id if year>=1991 & year<=2011, pairwise corr(psar1)

	
	
	global baseline_2 l.population_logged l.d.population_logged l.dependent_population l.d.dependent_population l.economic_globalization l.d.economic_globalization l.gdppc_logged l.d.gdppc_logged l.partysysnational l.leftistgovt	

	** (2). Models additionally controlling for the effect of "Party System Nationalization" 
	
	* Report the estimated coefficeint of RDGINI
	xi:xtpcse d.central_govtsp l.rdgini l.central_govtsp $baseline_2 l.PR l.parliamentary l.nonfed_nonbicam i.id if year>=1991 & year<=2011, pairwise corr(psar1)

	* Report the estimated coefficeint of MM_RATIO
	xi:xtpcse d.central_govtsp l.mm_ratio l.central_govtsp $baseline_2 l.PR l.parliamentary l.nonfed_nonbicam i.id if year>=1991 & year<=2011, pairwise corr(psar1)

	* Report the estimated coefficient of RDGINI
	xi:xtpcse d.policy_priority l.rdgini l.policy_priority $baseline_2 l.PR l.parliamentary l.nonfed_nonbicam i.id if year>=1991 & year<=2011, pairwise corr(psar1)

    * Report the estimated coefficient of MM_RATIO
	xi:xtpcse d.policy_priority l.mm_ratio l.policy_priority $baseline_2 l.PR l.parliamentary l.nonfed_nonbicam i.id if year>=1991 & year<=2011, pairwise corr(psar1)

	
	
	global baseline_3 l.population_logged l.d.population_logged l.dependent_population l.d.dependent_population l.economic_globalization l.d.economic_globalization l.gdppc_logged l.d.gdppc_logged l.leftistgovt l.naturalresource_rent  

    ** (3). Models additionally controlling for the effect of "Natural Resource Rent"

    * Report the estimated coefficient of RDGINI	
	xi:xtpcse d.central_govtsp l.rdgini l.central_govtsp $baseline_3 l.PR l.parliamentary l.nonfed_nonbicam i.id if year>=1991 & year<=2011, pairwise corr(psar1)

	* Report the estimated coefficient of MM_RATIO
	xi:xtpcse d.central_govtsp l.mm_ratio l.central_govtsp $baseline_3 l.PR l.parliamentary l.nonfed_nonbicam i.id if year>=1991 & year<=2011, pairwise corr(psar1)

	* Report the estimated coefficeint of RDGINI
	xi:xtpcse d.policy_priority l.rdgini l.policy_priority $baseline_3 l.PR l.parliamentary l.nonfed_nonbicam i.id if year>=1991 & year<=2011, pairwise corr(psar1)

	* Report the estimated coefficeint of MM_RATIO
	xi:xtpcse d.policy_priority l.mm_ratio l.policy_priority $baseline_3 l.PR l.parliamentary l.nonfed_nonbicam i.id if year>=1991 & year<=2011, pairwise corr(psar1)

	
	
	global baseline_4 l.population_logged l.d.population_logged l.dependent_population l.d.dependent_population l.economic_globalization l.d.economic_globalization l.gdppc_logged l.d.gdppc_logged l.leftistgovt l.legi_malapproportionment

	** (4). Models additionally controlling for the effect of "Legislative Mal-apportionment" 

    * Report the estimated coefficient of RDGINI	
	xi:xtpcse d.central_govtsp l.rdgini l.central_govtsp  $baseline_4 l.PR l.parliamentary l.nonfed_nonbicam i.id if year>=1991 & year<=2011, pairwise corr(psar1)

	* Report the estimated coefficient of MM_RATIO
	xi:xtpcse d.central_govtsp l.mm_ratio l.central_govtsp $baseline_4 l.PR l.parliamentary l.nonfed_nonbicam i.id if year>=1991 & year<=2011, pairwise corr(psar1)
    
	* Report the estimated coefficeint of RDGINI
	xi:xtpcse d.policy_priority l.rdgini l.policy_priority $baseline_4 l.PR l.parliamentary l.nonfed_nonbicam i.id if year>=1991 & year<=2011, pairwise corr(psar1)

	* Report the estimated coefficeint of MM_RATIO
	xi:xtpcse d.policy_priority l.mm_ratio l.policy_priority $baseline_4 l.PR l.parliamentary l.nonfed_nonbicam i.id if year>=1991 & year<=2011, pairwise corr(psar1)	


	
	global baseline_5 l.population_logged l.d.population_logged l.dependent_population l.d.dependent_population l.economic_globalization l.d.economic_globalization l.gdppc_logged l.d.gdppc_logged l.leftistgovt l.nationaltheil_market
	
	** (5). Models additionally controlling for the effect of "Intra-regional Inequality (Theil Index)"
	
	* Report the estimated coefficient of RDGINI
	xi:xtpcse d.central_govtsp l.rdgini l.central_govtsp $baseline_5 l.PR l.parliamentary l.nonfed_nonbicam i.id if year>=1991 & year<=2011 ///
	& countries!="Austria" & countries!="Norway" & countries!="Netherlands" & countries!="Japan" & countries!="Slovenia", pairwise corr(psar1)

	* Report the estimated coefficient of MM_RATIO
	xi:xtpcse d.central_govtsp l.mm_ratio l.central_govtsp $baseline_5 l.PR l.parliamentary l.nonfed_nonbicam i.id if year>=1991 & year<=2011 ///
	& countries!="Austria" & countries!="Norway" & countries!="Netherlands" & countries!="Japan" & countries!="Slovenia", pairwise corr(psar1)	

	
	
	** (6). Inter-regional inequality measures using Housing Cost Deflator Data:
	* Missing data on regions
	gen samplecountry=1 if countries !="Austria" & countries != "Belgium" & countries != "Japan" & countries != "Norway" & countries != "Portugal" & countries != "Slovak Republic" & countries != "Slovenia" & countries != "Spain"
	tsset id year

	* Report the estimated coefficient of RDGINI 
	xi:xtpcse d.central_govtsp l.rdgini_livingcost l.central_govtsp l.PR l.parliamentary l.nonfed_nonbicam i.id if year>=1991 & year<=2011 & samplecountry==1, noconst pairwise corr(psar1)

	* Report the estimated coefficient of MM_RATIO
	xi:xtpcse d.central_govtsp l.mm_ratio_livingcost l.central_govtsp l.PR l.parliamentary l.nonfed_nonbicam i.id if year>=1991 & year<=2011 & samplecountry==1, noconst pairwise corr(psar1)

