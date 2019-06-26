******************************************************************************
*** This do file analyzes resettlement and violence, with final code, for JPR Resettlement article
*** Abbey Steele 
*** 21 June 2017
******************************************************************************
 

use "JPR_Steele_replication_17.dta", clear

set more off
xtset codmpio MY 


// create time dependence variables; install btscs.ado in Stata (see ReadMe.pdf file)

**use the following commands to generate splines:	
		drop _spline* timecount _tuntilf _prefail _frstfl 
		btscs mas_dummy MY codmpio, gen(timecount) nspline(3) f 
	
*fix labels for tables
		la var _spline1 "Spline 1"
		la var _spline2 "Spline 2"
		la var _spline3 "Spline 3"
		la var timecount "Timecount"		

*--------------*
// TABLES I-IV:
*--------------*

	// Table I: IDP arrivals and the probability of a massacre
	
		eststo clear
				
		* bivariate, w time controls
		
			eststo: xtlogit mas_dummy Lln_idp _spline1 _spline2 _spline3 timecount, re
			eststo: xtlogit mas_dummy Lln_idp, fe 
		
		* geographical and economic
		
			eststo: xtlogit mas_dummy Lln_idp area distance altura ln_pob1993 groad95 nbi ICA _spline1 _spline2 _spline3 timecount, re
			eststo: xtlogit mas_dummy Lln_idp ICA, fe

		* violence
		
			eststo: xtlogit mas_dummy Lln_idp Lhomicide LFARC_events Lpara_events LFARC_events_sum Lpara_events_sum area distance altura ln_pob1993 ///
				groad95 nbi ICA _spline1 _spline2 _spline3 timecount, re
			eststo: xtlogit mas_dummy Lln_idp Lhomicide LFARC_events Lpara_events LFARC_events_sum Lpara_events_sum ICA, fe



	// Table II: IDP arrivals and the probability of a massacre (account for spatial dependence; 2-stage MLE)
		
		eststo clear
		drop masdummylag_pr

		* first stage
	
			eststo: xtlogit mas_dummylag Lln_idp Lhomicide LFARC_events Lpara_events LFARC_events_sum Lpara_events_sum ///
			w_Llnidp w_hom w_LFARC_events_sum w_LFARC_events w_Lpara_events w_Lpara_events_sum ///
			area distance altura ln_pob1993 groad95 nbi ICA   ///
			 _spline1 _spline2 _spline3 timecount, re
		
			predict masdummylag_pr
		
		* second stage

			eststo: xtlogit mas_dummy masdummylag_pr Lln_idp Lhomicide LFARC_events Lpara_events LFARC_events_sum Lpara_events_sum ///
			w_Llnidp w_hom w_LFARC_events_sum w_LFARC_events w_Lpara_events w_Lpara_events_sum ///
			area distance altura ln_pob1993 groad95 nbi ICA   ///
			 _spline1 _spline2 _spline3 timecount, re
			 	


	// Table III: IDP arrivals and the probability of a massacre (Proportion of IDPs analysis)
 		
		eststo clear
		
		* bivariate, w time controls
		
			eststo: xtlogit mas_dummy Lprop_idp_std Lprop_idp_std2 _spline1 _spline2 _spline3 timecount, re
			eststo: xtlogit mas_dummy Lprop_idp_std Lprop_idp_std2, fe 
		
		* geographical and economic
		
			eststo: xtlogit mas_dummy Lprop_idp_std Lprop_idp_std2 area distance altura ln_pob1993 groad95 nbi ICA _spline1 _spline2 _spline3 timecount, re
			eststo: xtlogit mas_dummy Lprop_idp_std Lprop_idp_std2 ICA, fe

		* violence
		
			eststo: xtlogit mas_dummy Lprop_idp_std Lprop_idp_std2 Lhomicide LFARC_events Lpara_events LFARC_events_sum Lpara_events_sum area distance altura ln_pob1993 ///
				groad95 nbi ICA _spline1 _spline2 _spline3 timecount, re
			eststo: xtlogit mas_dummy Lprop_idp_std Lprop_idp_std2 Lhomicide LFARC_events Lpara_events LFARC_events_sum Lpara_events_sum ICA, fe

	

	// Table IV: IDP arrivals and the probability of a massacre (spatial lag)

		eststo clear
		drop masdummylag_pr

	* first stage
			eststo: xtlogit mas_dummylag Lprop_idp_std Lprop_idp_std2 Lhomicide LFARC_events Lpara_events LFARC_events_sum Lpara_events_sum ///
			w_LFARC_events_sum w_LFARC_events w_Lpara_events w_Lpara_events_sum Lprop_idp_stdlag Lprop_idp_std2lag ///
			area distance altura ln_pob1993 groad95 nbi ICA   ///
			_spline1 _spline2 _spline3 timecount, re
			
			predict masdummylag_pr

		
		* second stage

			eststo: xtlogit mas_dummy masdummylag_pr Lprop_idp_std Lprop_idp_std2 Lhomicide LFARC_events Lpara_events LFARC_events_sum Lpara_events_sum ///
			w_LFARC_events_sum w_LFARC_events w_Lpara_events w_Lpara_events_sum Lprop_idp_stdlag Lprop_idp_std2lag ///
			area distance altura ln_pob1993 groad95 nbi ICA   ///
			_spline1 _spline2 _spline3 timecount, re
			 		
	

*--------------*
// APPENDIX	
*--------------*


	// Table A: Descriptive statistics

	**Change the following path to the folder where the table would be saved:
	cap cd  "/Users/rafaelch/Desktop/RESEARCH/Abbey_resettlement/Replication_final/Tables"

		est clear
		estpost summarize mas_dummy massacre idp_arr_hh Lln_idp origins prop_idp FARC_events_sum FARC_events ///
		para_events_sum para_events homicide area distance altura ln_pob1993 groad95 nbi ICA
		
	
	
	// Table B: IDP arrivals and the probability of a massacre, rare events models

		eststo clear
	
		* Bivariate, w time controls
			eststo: relogit mas_dummy Lln_idp _spline1 _spline2 _spline3 timecount, cluster(codmpio)
			eststo: relogit mas_dummy Lprop_idp_std Lprop_idp_std2 _spline1 _spline2 _spline3 timecount, cluster(codmpio)
		
		* Geographical and economic
			eststo: relogit mas_dummy Lln_idp area distance altura ln_pob1993 groad95 nbi ICA _spline1 _spline2 _spline3 timecount, cluster(codmpio)
			eststo: relogit mas_dummy Lprop_idp_std Lprop_idp_std2 area distance altura ln_pob1993 groad95 nbi  ICA _spline1 _spline2 _spline3 timecount, cluster(codmpio)

		* Violence
			eststo: relogit mas_dummy Lln_idp Lhomicide LFARC_events Lpara_events LFARC_events_sum Lpara_events_sum area distance altura ln_pob1993 ///
			groad95 nbi  ICA _spline1 _spline2 _spline3 timecount, cluster(codmpio)
			eststo: relogit mas_dummy Lprop_idp_std Lprop_idp_std2 Lhomicide LFARC_events Lpara_events LFARC_events_sum Lpara_events_sum area distance altura ln_pob1993 ///
			groad95 nbi  ICA _spline1 _spline2 _spline3 timecount, cluster(codmpio)

	
	
	// Table C: IDP arrivals and forms of violence (New count DVs, IDP arrivals)

		eststo clear

		* Count of Massacres (neg binomial)
			eststo: xtnbreg massacre Lln_idp Lhomicide LFARC_events Lpara_events LFARC_events_sum Lpara_events_sum area distance altura ln_pob1993 ///
			groad95 nbi  ICA, re irr

		* Rate of massacres (/100k) 
			eststo: xtnbreg mass_rate Lln_idp Lhomicide LFARC_events Lpara_events LFARC_events_sum Lpara_events_sum area distance altura ln_pob1993 ///
			groad95 nbi  ICA, re irr 		
	
		* Homicides
			eststo: xtnbreg homicide Lln_idp Lhomicide LFARC_events Lpara_events LFARC_events_sum Lpara_events_sum area distance altura ln_pob1993 ///
			groad95 nbi  ICA, re irr



	// Table D: IDP arrivals per origin and forms of violence (New count DVs, IDP clustering)

		eststo clear

		* Count of Massacres (neg binomial)
			eststo: xtnbreg massacre Lprop_idp_std Lprop_idp_std2 Lhomicide LFARC_events Lpara_events LFARC_events_sum Lpara_events_sum area distance altura ln_pob1993 ///
			groad95 nbi  ICA, re irr
			
		* Rate of massacres (/100k) 
			eststo: xtnbreg mass_rate Lprop_idp_std Lprop_idp_std2 Lhomicide LFARC_events Lpara_events LFARC_events_sum Lpara_events_sum area distance altura ln_pob1993 ///
			groad95 nbi  ICA, re irr 

		* Homicides
			eststo: xtnbreg homicide Lprop_idp_std Lprop_idp_std2 Lhomicide LFARC_events Lpara_events LFARC_events_sum Lpara_events_sum area distance altura ln_pob1993 ///
			groad95 nbi  ICA, re irr
		
	

