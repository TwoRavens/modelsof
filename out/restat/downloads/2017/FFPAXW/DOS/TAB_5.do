********************************************************************************
* Gabriel M Ahlfeldt & Daniel P. McMillen
* Tall buildings and land values in the Review of Economics and Statistics
* (C) 2017
* Stata 15.0; Windows Server 2008 R2
********************************************************************************
* THIS DO FILE GENERATES TABLE 5

* START LOG SESSION
	log using "LOGS/TAB_5", replace

* LOAD DATA
	u "DATA/BUILDING_LV.dta", clear
		
	* GENERATE INDICATOR FOR NON-COMMERCIAL NON-RESIDENTIAL BUILDINGS		
			gen OTHER = 1-COMMERICIAL-RESIDENTIAL		
	
	* GENERATE YEAR TREND WITH 0-VALUE IN 2000
				gen Y = YEAR - 2000
				label var Y "Year - 2000"		
		
	* GEN INTERACTIONS
	
		* LAND PRICE x LAND USE INTERACTIONS
		gen lLV_RES = lLV * RESIDENTIAL		
		gen lLV_COM = lLV * COM
		gen lLV_OTHER = lLV * OTHER
		
		* LAND PRICE x LAND USE x TIME TREND INTERACTIONS
		gen lLV_Y = lLV*Y
		gen lLV_Y_COM = lLV*Y*COMMERICIAL
		gen lLV_Y_RES = lLV*Y*RESIDENTIAL
		gen lLV_Y_OTHER = lLV*Y*OTHER

		* COHORT EFFECTS x LAND USE INTERACTIONS
		tab CC, gen(CCD)
		foreach var of varlist CCD* {
			gen COM_`var' = COMMERICIAL *`var'
			gen RES_`var' = RESIDENTIAL *`var'
			}

		* LABEL GENERATED VARIABLES 	
			label var lLV_COM "Log land price x commercial"
			label var lLV_RES "Log land price x residential"
			label var lLV_OTHER "Log land price x (1 - commercial - residential)"
			label var lLV_Y "Log land price x (Year - 2000)"	
			label var lLV_Y_COM "Log land price x commercial  x (year - 2000)"
			label var lLV_Y_RES "Log land price x residential  x (year - 2000)"
			label var lLV_Y_OTHER "Log land price x (1 - commercial - residential)  x (year - 2000)"
		
		* GENERATE DISTANCE FROM RIVER DUMMY FOR IV GENERATION		
			gen Dr = dist_river < 0.1
			label var Dr "River within 0.1 mile (dummy)"
		
		* GENERATE IVs (INTERACTIONS OF GEOGRAPHIC FEATURES, LAND USE, AND TIME TREND
		local IV ldist_cbd ldist_lm Dr
		foreach var of varlist `IV' {
			gen IV_COM_`var' = `var' * COMMERICIAL
			gen IV_RES_`var' = `var' * RESIDENTIAL
			gen IV_OTHER_`var' = `var' * OTHER
			* gen IV_Y_`var' = `var' * (YEAR - 2000)
			gen IV_COM_Y_`var' = `var' * (CC - 2000) * COMMERICIAL
			gen IV_RES_Y_`var' = `var' * (CC - 2000) * RESIDENTIAL
			gen IV_OTHER_Y_`var' = `var' * (CC - 2000) * OTHER
			}
			
* REGRESSSIONS
		
	* [1] BASELINE MODEL, UNCONDITIONAL CORRELATION WITHIN COHORTS
		eststo: areg lHEIGHT lLV ,  cluster(CC) abs(CC)
				estadd local Cohort_effects = "Yes"
				estadd local Cohort_com_effects = "-"
				estadd local Cohort_res_effects = "-"
				estadd local IV = "-"
				estadd local KP_F_stat = "-"
				estadd local HJ_P_val = "-"
				estadd local KP_LM_P_val = "-"		
	* [2] [1] WITH IV
		* RECOVER OVERID STAT FROM MODEL PARTIALLING OUT COHORT EFFECTS
				ivreg2 lHEIGHT (lLV =ldist_cbd ldist_lm Dr ) CCD*,  cluster(CC)   partial(CCD*)
				local HJP = round( e(jp), 0.001)
		* REPORTED ESTIMATES
		eststo: ivreg2 lHEIGHT (lLV =`IV' ) CCD*,  cluster(CC)  
				estadd local Cohort_effects = "Yes"
				estadd local Cohort_com_effects = "-"
				estadd local Cohort_res_effects = "-"
				estadd local IV = "Yes"
				local KPF = round( e(rkf), 0.001)
				local KPP = round( e(idp), 0.001)
				estadd local KP_F_stat = `KPF'
				estadd local HJ_P_val = `HJP'
				estadd local KP_LM_P_val = `KPP'
				
	* [3] [1] WITH TIME INTERACTION
		eststo: areg lHEIGHT lLV lLV_Y , cluster(CC)	abs(CC)	
				estadd local Cohort_effects = "Yes"
				estadd local Cohort_com_effects = "-"
				estadd local Cohort_res_effects = "-"
				estadd local IV = "-"
				estadd local KP_F_stat = "-"
				estadd local HJ_P_val = "-"
				estadd local KP_LM_P_val = "-"	
				
	* [4] [3] WITH LAND USE INTERACTION
		eststo: areg lHEIGHT lLV_COM lLV_RES lLV_OTHER lLV_Y_COM lLV_Y_RES lLV_Y_OTHER RES_CCD* COM_CCD*   , cluster(CC)	abs(CC)	
				estadd local Cohort_effects = "Yes"
				estadd local Cohort_com_effects = "Yes"
				estadd local Cohort_res_effects = "Yes"
				estadd local IV = "-"
				estadd local KP_F_stat = "-"
				estadd local HJ_P_val = "-"
				estadd local KP_LM_P_val = "-"	
				
	* [5] [4] WITH BUILDING TYPE CONTROLS
		eststo: areg lHEIGHT lLV_COM lLV_RES lLV_OTHER lLV_Y_COM lLV_Y_RES lLV_Y_OTHER RES_CCD* COM_CCD*     RETAIL HOTEL  WAREHOUSE PUBLIC  CULTURE SPORTS Church, cluster(CC)	abs(CC)	
				estadd local Cohort_effects = "Yes"
				estadd local Cohort_com_effects = "Yes"
				estadd local Cohort_res_effects = "Yes"
				estadd scalar LU = 1
				estadd scalar CONTROLS = 1
				predict lEXCESSHEIGHT, res
				predict lFUNDHEIGHT
				estadd local IV = "-"
				estadd local KP_F_stat = "-"
				estadd local HJ_P_val = "-"
				estadd local KP_LM_P_val = "-"	
				
	* [6] [5] WITH IV
		* RECOVER OVERID STAT FROM MODEL PARTIALLING OUT COHORT EFFECTS (NO CLUSTERING)
				ivreg2 lHEIGHT (lLV_COM lLV_RES lLV_OTHER lLV_Y_COM lLV_Y_RES lLV_Y_OTHER = IV* )  COM_CCD* RES_CCD*    RETAIL HOTEL  WAREHOUSE PUBLIC  CULTURE SPORTS Church CCD*,  partial(CCD* COM_CCD* RES_CCD*  RETAIL HOTEL  WAREHOUSE PUBLIC  CULTURE SPORTS Church )
				local HJP = round( e(jp), 0.001)
				display `HJP'
		* REPORTED ESTIMATES
		eststo: ivreg2 lHEIGHT (lLV_COM lLV_RES lLV_OTHER lLV_Y_COM lLV_Y_RES lLV_Y_OTHER = IV* )  COM_CCD* RES_CCD*   RETAIL HOTEL  WAREHOUSE PUBLIC  CULTURE SPORTS Church CCD*,  cluster(CC)   			
				estadd local Cohort_effects = "Yes"
				estadd local Cohort_com_effects = "Yes"
				estadd local Cohort_res_effects = "Yes"
				estadd local IV = "Yes"
				local KPF = round( e(rkf), 0.001)
				local KPP = round( e(idp), 0.001)
				estadd local KP_F_stat = `KPF'
				estadd local HJ_P_val = `HJP'
				estadd local KP_LM_P_val = `KPP'
	
	* WRITE TABLE 5			
	esttab using "TABS/TAB_5.rtf", replace b(3) se(3) onecell label compress r2(3) aic(1)  drop(_cons CCD* COM_* RES_CCD*    ) ///
	title ("Elasticity of density with respect to land price: Parametric estimates") modelwidth(6) nogap star(* 0.1 ** 0.05 *** 0.01) stats(Cohort_effects Cohort_com_effects Cohort_res_effects IV KP_LM_P_val HJ_P_val r2 N , fmt(%18.3g ))  ///
	addnote("Notes:	Standard errors (in parentheses) clustered on construction date cohorts (decades). IV models in (2) and (6) are estimated using 2SLS. Instruments for log land price in model (2) are log distance from the CBD, log distance from Lake Michigan, and a dummy variable for being within a tenth of a mile of Chicago River. In model (6), interactions of the same variables and land use indicators as well as time trends are instruments for the interactions of log land prices and land use in-dicators as well as time trends. Over-identification statistis computed partialling out controls.")
	eststo clear

* SAVE DATA FOR BOOTSTRAPPING IN TAB_8.do
	save "DATA\TEMP\temp_HBOOT.dta", replace	
	
* END LOG SESSION
 log close		
