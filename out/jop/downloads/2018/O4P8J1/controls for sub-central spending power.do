	************************************************************************
	* Inter-regional Inequality and the Dynamics of Government Spending 
	* Online Appendix -- Section 4. Controls for Sub-central Spending Power
	************************************************************************
	clear all
	set more off 
	set mem 600m
	cd "YOUR_DIRECTORY_PATH_HERE\supplements (online appendix)\appendix f"
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

	*************************************
	* Generate five-year moving averages 
	*************************************
	foreach x of varlist adgini rpop_s1_rgdppc ///
    log_pop pop14_65 a log_rgdpch gov_left2 ///
	n_fiscauto n_fisccon local_taxrevenue socialprotection_statelocal education_statelocal health_statelocal {
	gen ma`x' = (l1.`x' + l2.`x' + l3.`x' + l4.`x'+ l5.`x')/5
	}

	**********************
	** Renaming Variables  
	**********************
	rename jacoby_modified2 policy_priority
    rename maadgini rdgini
	rename marpop_s1_rgdppc mm_ratio
	rename malog_pop population_logged
	rename mapop14_65 dependent_population 
	rename maa economic_globalization
	rename malog_rgdpch ppp_gdppc_logged
	rename magov_left2 leftistgovt
	rename man_fiscauto taxautonomy
	rename Parl parliamentary
	rename Unit2 nonfed_nonbicam
	rename malocal_taxrevenue taxrevenue
	rename masocialprotection_statelocal socialprotectionspending
	rename maeducation_statelocal educationspending
	rename mahealth_statelocal healthspending
	
	**************************************************************************
	** Appendix F. Regional Controls for Financial Responsibility for Policy 
	**************************************************************************
	tab countries, gen(kcountry_)

	global baseline l.population_logged l.d.population_logged l.dependent_population l.d.dependent_population l.economic_globalization l.d.economic_globalization l.ppp_gdppc_logged l.d.ppp_gdppc_logged l.leftistgovt l.taxautonomy l.d.taxautonomy 

	* Model [1]
	xi:xtpcse d.policy_priority l.policy_priority l.rdgini $baseline l.PR l.parliamentary l.nonfed_nonbicam kcountry_* if year>=1991 & year<=2011, noconst pairwise corr(psar1)

	* Model [2]
	xi:xtpcse d.policy_priority l.policy_priority l.mm_ratio $baseline l.PR l.parliamentary l.nonfed_nonbicam kcountry_* if year>=1991 & year<=2011,noconst pairwise corr(psar1)

	* Model [3] 
	global baseline_add l.population_logged l.d.population_logged l.dependent_population l.d.dependent_population l.economic_globalization l.d.economic_globalization l.ppp_gdppc_logged l.d.ppp_gdppc_logged l.leftistgovt l.taxrevenue l.d.taxrevenue
	xi:xtpcse d.policy_priority l.policy_priority l.rdgini $baseline_add l.PR l.parliamentary l.nonfed_nonbicam kcountry_* if year>=1991 & year<=2011, noconst pairwise corr(psar1)

	* Model [4] 	
	xi:xtpcse d.policy_priority l.policy_priority l.mm_ratio $baseline_add l.PR l.parliamentary l.nonfed_nonbicam kcountry_* if year>=1991 & year<=2011, noconst pairwise corr(psar1)


	
	global baseline_add3 l.population_logged l.d.population_logged l.dependent_population l.d.dependent_population l.economic_globalization l.d.economic_globalization l.ppp_gdppc_logged l.d.ppp_gdppc_logged l.leftistgovt l.socialprotectionspending l.d.socialprotectionspending

    * Model [5]
	xi:xtpcse d.policy_priority l.policy_priority l.rdgini $baseline_add3 l.PR l.parliamentary l.nonfed_nonbicam kcountry_* if year>=1991 & year<=2011, noconst pairwise corr(psar1)
    predict pred if e(sample), xb
    gen resid = d.policy_priority-pred
    egen stresid=std(resid)
    gen outlier = 0 if e(sample)
    replace outlier = 1 if abs(stresid)>1.5
	xi:xtpcse d.policy_priority l.policy_priority l.rdgini $baseline_add3 l.PR l.parliamentary l.nonfed_nonbicam kcountry_* if year>=1991 & year<=2011 & outlier!=1, noconst pairwise corr(psar1)
	drop pred resid stresid outlier	

	* Model [6] 
	xi:xtpcse d.policy_priority l.policy_priority l.mm_ratio $baseline_add3 l.PR l.parliamentary l.nonfed_nonbicam kcountry_* if year>=1991 & year<=2011, noconst pairwise corr(psar1)
    predict pred if e(sample), xb
    gen resid = d.policy_priority-pred
    egen stresid=std(resid)
    gen outlier = 0 if e(sample)
    replace outlier = 1 if abs(stresid)>1.5
	xi:xtpcse d.policy_priority l.policy_priority l.mm_ratio $baseline_add3 l.PR l.parliamentary l.nonfed_nonbicam kcountry_* if year>=1991 & year<=2011 & outlier!=1, noconst pairwise corr(psar1)
    est store m6
	drop pred resid stresid outlier
	
	* Model [7]
	global baseline_add2 l.population_logged l.d.population_logged l.dependent_population l.d.dependent_population l.economic_globalization l.d.economic_globalization l.ppp_gdppc_logged l.d.ppp_gdppc_logged l.leftistgovt l.educationspending l.d.educationspending
	xi:xtpcse d.policy_priority l.policy_priority l.rdgini $baseline_add2 l.PR l.parliamentary l.nonfed_nonbicam kcountry_* if year>=1991 & year<=2011, noconst pairwise corr(psar1)
    predict pred if e(sample), xb
    gen resid = d.policy_priority-pred
    egen stresid=std(resid)
    gen outlier = 0 if e(sample)
    replace outlier = 1 if abs(stresid)>1.5
	xi:xtpcse d.policy_priority l.policy_priority l.rdgini $baseline_add2 l.PR l.parliamentary l.nonfed_nonbicam kcountry_* if year>=1991 & year<=2011 & outlier!=1, noconst pairwise corr(psar1)
    est store m7
	drop pred resid stresid outlier

	* Model [8]
	xi:xtpcse d.policy_priority l.policy_priority l.mm_ratio $baseline_add2 l.PR l.parliamentary l.nonfed_nonbicam kcountry_* if year>=1991 & year<=2011, noconst pairwise corr(psar1)
    predict pred if e(sample), xb
    gen resid = d.policy_priority-pred
    egen stresid=std(resid)
    gen outlier = 0 if e(sample)
    replace outlier = 1 if abs(stresid)>1.5
	xi:xtpcse d.policy_priority l.policy_priority l.mm_ratio $baseline_add2 l.PR l.parliamentary l.nonfed_nonbicam kcountry_* if year>=1991 & year<=2011 & outlier!=1, noconst pairwise corr(psar1)
    est store m8
	drop pred resid stresid outlier	
	
    * Model [9] 
	global baseline_add3 l.population_logged l.d.population_logged l.dependent_population l.d.dependent_population l.economic_globalization l.d.economic_globalization l.ppp_gdppc_logged l.d.ppp_gdppc_logged l.leftistgovt l.healthspending l.d.healthspending
	xi:xtpcse d.policy_priority l.policy_priority l.rdgini $baseline_add3 l.PR l.parliamentary l.nonfed_nonbicam kcountry_* if year>=1991 & year<=2011, noconst pairwise corr(psar1)
    predict pred if e(sample), xb
    gen resid = d.policy_priority-pred
    egen stresid=std(resid)
    gen outlier = 0 if e(sample)
    replace outlier = 1 if abs(stresid)>1.5
	xi:xtpcse d.policy_priority l.policy_priority l.rdgini $baseline_add3 l.PR l.parliamentary l.nonfed_nonbicam kcountry_* if year>=1991 & year<=2011 & outlier!=1, noconst pairwise corr(psar1)
    est store m9
	drop pred resid stresid outlier	

	* Model [10]
	xi:xtpcse d.policy_priority l.policy_priority l.mm_ratio $baseline_add3 l.PR l.parliamentary l.nonfed_nonbicam kcountry_* if year>=1991 & year<=2011, noconst pairwise corr(psar1)
    predict pred if e(sample), xb
    gen resid = d.policy_priority-pred
    egen stresid=std(resid)
    gen outlier = 0 if e(sample)
    replace outlier = 1 if abs(stresid)>1.5
	xi:xtpcse d.policy_priority l.policy_priority l.mm_ratio $baseline_add3 l.PR l.parliamentary l.nonfed_nonbicam kcountry_* if year>=1991 & year<=2011 & outlier!=1, noconst pairwise corr(psar1)
    est store m10
	drop pred resid stresid outlier	
	
	