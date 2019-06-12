***************************************************
* Title: Pakistan, Democracy, and Militancy
* Function: Data analysis                          
* Date: June 9, 2016                              
***************************************************

clear
set more off

// NOTE: Please copy all replication files into the same working directory

use "FMS-four provinces data-ANALYSIS.dta"

log using "ReplicationResults.smcl", replace


/********************* PAPER ANALYSES **********************/


************************************************
***************** Paper Tables *****************
************************************************


*************************************
**** Table 1. DESCRIPTIVE STATS ****
*************************************

// Summary statistics for demographic covariates

	tab1 gender_z urban_z
	tab d010 // head of household
	tab d050 // able to read
	tab d070 // able to do math
		
	summ d030 // age
	summ d080 // education level
	summ d140 // household expenditures

	summ assets

// Summary statistics for religiosity covariates

	tab q020 // religious sect
	summ q050 // prays namaz
	tab q052 // prays tah namaz


***********************************
**** Table 2. FACTOR ANALYSIS ****
***********************************

// Confirmatory Factor Analysis

	factor d_services d_noncorrupt d_security d_justice d_punish d_restrict, pcf
	rotate
	
	** Note: Rotated factor loadings (pattern matrix) and unique variances’ table in the output file  
	* correspond to Table 2


************************************************
**** Table 3. SHARIA AND DEMOCRACY RESULTS ****
************************************************

// Sharia and support for democratic values

	** Note: Table 3 shows results for all four models, but not does present covariates in the table.
	** For a version of the table with covariates presented, see Appendix 3 Table 2.

	// (1) Basic model + district fixed effects

	areg democracy d_provides d_imposes, cluster(psu_new) a(a7)
	test d_provides = d_imposes

	// (2) Basic model + district fixed effects + demographic covariates

	areg democracy d_provides d_imposes *_z *_miss, cluster(psu_new) a(a7)
	test d_provides = d_imposes

	// (3) Basic model + district fixed effects + demographic covariates + religion covariates

	areg democracy d_provides d_imposes *_z *_miss *_r *_rmiss, cluster(psu_new) a(a7)
	test d_provides = d_imposes

	// (4) Basic model + tehsil fixed effects + demographic covariates

	areg democracy d_provides d_imposes *_z *_miss *_r *_rmiss, cluster(psu_new) a(a8)
	test d_provides = d_imposes

// Binning people
	
	areg democracy highprov_highimp lowprov_lowimp lowprov_highimp *_z *_miss, cluster(psu_new) a(a7)
	areg democracy highprov_highimp lowprov_lowimp highprov_lowimp *_z *_miss, cluster(psu_new) a(a7)


************************************************
**** Table 4. SHARIA AND MILITANCY RESULTS ****
************************************************

// First half of Table 4: Sharia and support for militancy - Direct questions

	** Note: Table 4 shows results for all four models, but not does present covariates in the table.
	** For a version of this part of the table with covariates presented, see Appendix 3 Table 3.

	// (1) Basic model + district fixed effects

	areg support_mil d_provides d_imposes, cluster(psu_new) a(a7)
	test d_provides = d_imposes

	// (2) Basic model + district fixed effects + demographic covariates

	areg support_mil d_provides d_imposes *_z *_miss, cluster(psu_new) a(a7)
	test d_provides = d_imposes

	// (3) Basic model + district fixed effects + demographic covariates + religion covariates

	areg support_mil d_provides d_imposes *_z *_miss *_r *_rmiss, cluster(psu_new) a(a7)
	test d_provides = d_imposes

	// (4) Basic model + tehsil fixed effects + demographic covariates
	
	areg support_mil d_provides d_imposes *_z *_miss *_r *_rmiss, cluster(psu_new) a(a8)
	test d_provides = d_imposes


// Second half of Table 4: Sharia and support for militancy - Endorsement experiment

	** Note: Table 4 shows results for all four models, but not does present covariates in the table.
	** For a version of this part of table with covariates presented, see Appendix 3 Table 4.

	// Two-way interactions: provides * endorsement treatment group and imposes * endoresement treatment group
	
		// (1) Basic model + district fixed effects
	
		local group  "militancy"
		foreach x of local group {
			areg policy_pref_`x' treat_`x' d_provides dprovides_treat_`x' d_imposes dimposes_treat_`x', cluster(psu_new) a(a7)		}

		test dprovides_treat_militancy = dimposes_treat_militancy

		// (2) Basic model + district fixed effects + demographic covariates

		local group  "militancy"
		foreach x of local group {
			areg policy_pref_`x' treat_`x' d_provides dprovides_treat_`x' d_imposes dimposes_treat_`x' *_z *_miss, cluster(psu_new) a(a7)		}

		test dprovides_treat_militancy = dimposes_treat_militancy

		// (3) Basic model + district fixed effects + demographic covariates + religion covariates
	
		local group  "militancy"
		foreach x of local group {
			areg policy_pref_`x' treat_`x' d_provides dprovides_treat_`x' d_imposes dimposes_treat_`x' *_z *_miss *_r *_rmiss, cluster(psu_new) a(a7)		}

		test dprovides_treat_militancy = dimposes_treat_militancy

		// (4) Basic model + tehsil fixed effects + demographic covariates
	
		local group  "militancy"
		foreach x of local group {
			areg policy_pref_`x' treat_`x' d_provides dprovides_treat_`x' d_imposes dimposes_treat_`x' *_z *_miss *_r *_rmiss, cluster(psu_new) a(a8)		}

		test dprovides_treat_militancy = dimposes_treat_militancy
	
	
// Binning people - Direct questions
		
	areg support_mil highprov_highimp lowprov_lowimp highprov_lowimp *_z *_miss, cluster(psu_new) a(a7)



*************************************************
***************** PAPER FIGURES *****************
*************************************************


***************************************
**** FIGURE 1: SUPPORT FOR SHARIA ****
***************************************

// Descriptives: Shari'a indices (note: code for Figure 1 in R file)

	// Shari`a as providing
	
	summ d_services d_noncorrupt d_security d_justice d_provides
	
	// Shari`a as imposing

	summ d_punish d_restrict d_imposes


// Support for the different conceptualizations of Shari'a 
	// (Note: these regressions are not part of Figure 1, but some p-values from the imposes regression
	// appear in the section "Defining a Shari`a Based Government," in the 4th paragraph describing Figure 1)

	areg d_provides *_z *_miss *_r *_rmiss, cluster(psu_new) a(a7)
	areg d_imposes *_z *_miss *_r *_rmiss, cluster(psu_new) a(a7)


******************************************
**** FIGURE 2: SUPPORT FOR DEMOCRACY ****
******************************************
	
// Support for Democracy (note: code for Figure 2 in R file)

	summ democracy

	
******************************************
**** FIGURE 3: SUPPORT FOR MILITANCY ****
******************************************
	
// Support for Militancy - Direct Questions (note: code for Figure 3 in R file)
	
	summ support_ssp   // ssp is an abbreviation for Sipah-e-Sahaba Pakistan
	summ support_atal   // atal is an abbreviation for the Afghan Taliban
	summ support_mil   // mil is an abbreviation for Militant Group

// Support for Militancy - Endorsement Experiment (note: code for Figure 3 in R file)

	areg policy_pref_b treat_b, cluster(psu_new) a(a7)   // SSP
	areg policy_pref_c treat_c, cluster(psu_new) a(a7)   // Pakistan Taliban
	areg policy_pref_d treat_d, cluster(psu_new) a(a7)   // Afghan Tabliban
	areg policy_pref_militancy treat_militancy, cluster(psu_new) a(a7)  // All three groups combined
	


************************************************************
********** ADDITIONAL APPENDIX TABLES AND FIGURES **********
************************************************************


*********************************
**** APPENDIX 1: TABLES 1-3 ****
*********************************

// Factor Analysis of Shari'a Questions

	// Note: this code produces the values found in Appendix 1 Tables 1-3.

	factor d_services d_noncorrupt d_security d_justice d_punish d_restrict, pcf
	rotate


******************************
**** APPENDIX 1: TABLE 4 ****
******************************
	
// Binning Respondents by Scores on Shari`a Indices 

	ta prov_imp


*********************************
**** APPENDIX 2: TABLES 1-2 ****
*********************************

// Factor Analysis of Democracy Questions

	// Note: this code produces the values found in Appendix 2 Tables 1-2.

	factor q1030_resc q1050_resc q1070_resc q1090_resc q1110_resc q1130_resc, pcf
	rotate


******************************
**** APPENDIX 3: TABLE 1 ****
******************************

	// (1) Basic model + district fixed effects

	areg policy_pref_militancy treat_militancy, cluster(psu_new) a(a7)

	// (2) Basic model + district fixed effects + demographic covariates

	areg policy_pref_militancy treat_militancy *_z *_miss, cluster(psu_new) a(a7)

	// (3) Basic model + district fixed effects + demographic covariates + religion covariates

	areg policy_pref_militancy treat_militancy *_z *_miss *_r *_rmiss, cluster(psu_new) a(a7)

	// (4) Basic model + tehsil fixed effects + demographic covariates

	areg policy_pref_militancy treat_militancy *_z *_miss *_r *_rmiss, cluster(psu_new) a(a8)


******************************
**** APPENDIX 3: TABLE 2 ****
******************************
	
	// (1) Basic model + district fixed effects

	areg democracy d_provides d_imposes, cluster(psu_new) a(a7)
	test d_provides = d_imposes

	// (2) Basic model + district fixed effects + demographic covariates

	areg democracy d_provides d_imposes *_z *_miss, cluster(psu_new) a(a7)
	test d_provides = d_imposes

	// (3) Basic model + district fixed effects + demographic covariates + religion covariates

	areg democracy d_provides d_imposes *_z *_miss *_r *_rmiss, cluster(psu_new) a(a7)
	test d_provides = d_imposes

	// (4) Basic model + tehsil fixed effects + demographic covariates

	areg democracy d_provides d_imposes *_z *_miss *_r *_rmiss, cluster(psu_new) a(a8)
	test d_provides = d_imposes


******************************
**** APPENDIX 3: TABLE 3 ****
******************************

	// (1) Basic model + district fixed effects

	areg support_mil d_provides d_imposes, cluster(psu_new) a(a7)
	test d_provides = d_imposes

	// (2) Basic model + district fixed effects + demographic covariates

	areg support_mil d_provides d_imposes *_z *_miss, cluster(psu_new) a(a7)
	test d_provides = d_imposes

	// (3) Basic model + district fixed effects + demographic covariates + religion covariates

	areg support_mil d_provides d_imposes *_z *_miss *_r *_rmiss, cluster(psu_new) a(a7)
	test d_provides = d_imposes

	// (4) Basic model + tehsil fixed effects + demographic covariates
	
	areg support_mil d_provides d_imposes *_z *_miss *_r *_rmiss, cluster(psu_new) a(a8)
	test d_provides = d_imposes


******************************
**** APPENDIX 3: TABLE 4 ****
******************************

	// Two-way interactions: provides * endorsement treatment group and imposes * endoresement treatment group
	
		// (1) Basic model + district fixed effects
	
		local group  "militancy"
		foreach x of local group {
			areg policy_pref_`x' treat_`x' d_provides dprovides_treat_`x' d_imposes dimposes_treat_`x', cluster(psu_new) a(a7)		}

		test dprovides_treat_militancy = dimposes_treat_militancy

		// (2) Basic model + district fixed effects + demographic covariates

		local group  "militancy"
		foreach x of local group {
			areg policy_pref_`x' treat_`x' d_provides dprovides_treat_`x' d_imposes dimposes_treat_`x' *_z *_miss, cluster(psu_new) a(a7)		}

		test dprovides_treat_militancy = dimposes_treat_militancy

		// (3) Basic model + district fixed effects + demographic covariates + religion covariates
	
		local group  "militancy"
		foreach x of local group {
			areg policy_pref_`x' treat_`x' d_provides dprovides_treat_`x' d_imposes dimposes_treat_`x' *_z *_miss *_r *_rmiss, cluster(psu_new) a(a7)		}

		test dprovides_treat_militancy = dimposes_treat_militancy

		// (4) Basic model + tehsil fixed effects + demographic covariates
	
		local group  "militancy"
		foreach x of local group {
			areg policy_pref_`x' treat_`x' d_provides dprovides_treat_`x' d_imposes dimposes_treat_`x' *_z *_miss *_r *_rmiss, cluster(psu_new) a(a8)		}

		test dprovides_treat_militancy = dimposes_treat_militancy


log close
