
	**************************************************************************
	**																		**
	**																		**
	**		AUTHOR:			ADRIANE FRESH									**
	**		DATE: 			October 24, 2017								**
	**																		**
	**		PAPER: 			The Effect of the Voting Rights Act on			**
	**						Enfranchisement: Evidence from North Carolina	**
	**																		**
	**		DETAILS: 		Replication materials the published article.    **  
	**				 		Including the Online Appendix.					**
	**				       													**
	**																		**	
	**		SPECS: 			Stata Version 14.2 IC for Mac 					**
	**						(64 bit Intel),									**
	**						OSX (El Capitan) 10.11.6						**
	**																		**
	**																		**
	**																		**
	**************************************************************************
	
	
	
	
	

	// set the directory to the folder on your computer where this file is located	
	global directory = "/Users/Vesper/Documents/Projects/Voting Rights/Stata/VRA_JOP_Replication" 	

	
	// if you would like to set an alternative directory to output the .tex files, set that here
	global directory_output = "/Users/Vesper/Documents/Projects/Voting Rights/Papers/Paper_v13_JOP_Final_formatted"
	
	
	

	
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* read in stata data
*-------------------------------------------------------------------------------


* preliminaries
*--------------

clear
set more off



* set directory
*--------------

cd "${directory}"



* use data
*---------

use VRA_JOP_Replication.dta, clear




			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* label variables for table
*-------------------------------------------------------------------------------

	// this code shortens the variable labels for better display in the paper
	

* labels
*-------

label var pop_t_i_ln 		"ln(population)"
label var inc_hh_med_i 		"Median income (0,000)"
label var pop_b_i_perc 		"\% population black"
label var educ_25p_i 		"Median years schooling"
label var p_vreg_bnw 		"Black voter registration"
label var post_x_covered 	"Post-1965 $\cdot$ covered ($\hat{\beta}$)"
label var post 				"Post-1965 ($\psi$)"
label var gap_bw_vreg 		"B-W registration gap"
label var net_mig_rate_t_i	"Net migration rate"
label var net_mig_rate_w	"Net migration rate, white"
label var net_mig_rate_nw	"Net migration rate, non-white"
label var vshare_p_dem		"Dem. voter turnout (gov.)"





			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* define globals for sets of control variables
*-------------------------------------------------------------------------------


* controls
*---------

global controls1 = "pop_t_i_ln  pop_b_i_perc  inc_hh_med_i"
global controls2 = "pop_t_i_ln  pop_b_i_perc  inc_hh_med_i  educ_25p_i"





			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* time series set the data
*-------------------------------------------------------------------------------


* fvset
*------

tsset county_id year
fvset base 1958 year




			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	
						   ** PAPER TABLES **

			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* table 1 (paper): black vreg AND white vreg 
*-------------------------------------------------------------------------------


* globals
*--------

global dv1 		= "p_vreg_bnw"
global dv2 		= "p_vreg_w"
global d_in_d 	= "post_x_covered"
global tag		= "tag_vreg_bnw == 1"
global fe		= "i.year"
global absorb 	= "county_id"

global filename = "Registration_1_paper"



* clear
*------

_eststo clear



* specification
*--------------
	
	// outcome: black voter registration
eststo est_1: 	areg 	${dv1} ${d_in_d} ${fe}					if ${tag}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_1
	
	cd "${directory_output}"
	capture file close myfile
	file open myfile using "coef_breg_1.tex", write replace
	file write myfile %7.0f (_b[${d_in_d}]*100)
	file close myfile
	
	xtsum ${dv1}
	capture file close myfile
	file open myfile using "sd_breg_1.tex", write replace
	file write myfile %7.0f (round(_b[${d_in_d}]/`r(sd_w)'*100,5))
	file close myfile



eststo est_2: 	areg 	${dv1} ${d_in_d} ${controls1} ${fe} 	if ${tag}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_2
	estadd local controls1 "\checkmark": est_2
	
eststo est_3: 	areg 	${dv1} ${d_in_d} ${controls2} ${fe} 	if ${tag}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_3
	estadd local controls1 "\checkmark": est_3
	estadd local controls2 "\checkmark": est_3
	
	cd "${directory_output}"
	capture file close myfile
	file open myfile using "coef_breg_2.tex", write replace
	file write myfile %7.0f (_b[${d_in_d}]*100)
	file close myfile
	
	xtsum ${dv1}
	capture file close myfile
	file open myfile using "sd_breg_2.tex", write replace
	file write myfile %7.0f (round(_b[${d_in_d}]/`r(sd_w)'*100,5))
	file close myfile

	
	// outcome: white voter registration
eststo est_4: 	areg 	${dv2} ${d_in_d} ${fe} 					if ${tag}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_4
	
	cd "${directory_output}"
	capture file close myfile
	file open myfile using "coef_white_1.tex", write replace
	file write myfile %7.0f (_b[${d_in_d}]*100)
	file close myfile
	

eststo est_5: 	areg 	${dv2} ${d_in_d} ${controls1} ${fe} 	if ${tag}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_5
	estadd local controls1 "\checkmark": est_5
	
	
eststo est_6: 	areg 	${dv2} ${d_in_d} ${controls2}  ${fe} 	if ${tag}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_6
	estadd local controls1 "\checkmark": est_6
	estadd local controls2 "\checkmark": est_6

	cd "${directory_output}"
	capture file close myfile
	file open myfile using "coef_white_2.tex", write replace
	file write myfile %7.0f (_b[${d_in_d}]*100)
	file close myfile

	
	
	* output the regressions
	*-----------------------

	cd "${directory_output}"

	#delimit;
	
	esttab 
	
			est_1
			est_2
			est_3
			est_4
			est_5
			est_6
		
		using "${filename}.tex", 
		
			b(a2) label replace nogaps compress se(a2) bookt 
			noconstant nodepvars star(* 0.1 ** 0.05 *** 0.01)
			fragment keep(${d_in_d})
			
			stats(	
					N 
					controls1 
					controls2
					, 
				labels(	
						"Observations" 
						"Controls1"
						"Controls2"
						) 
					)
			title("")
			nomtitles		
		;
		
		#delimit cr

		
		
		


			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* table 2 (paper): voter turnout
*-------------------------------------------------------------------------------


* globals
*--------

global dv1 		= "v_turnout_p"
global dv2 		= "v_turnout_c"
global d_in_d 	= "post_x_covered"
global tag1 	= "tag_turnout_p == 1"
global tag2 	= "tag_turnout_c == 1"
global fe		= "i.year"
global absorb 	= "county_id"

global filename = "Turnout_1_paper"



* clear
*------

_eststo clear



* specification
*--------------
	
	// outcome: presidential turnout
eststo est_1: 	areg 	${dv1} ${d_in_d} ${fe}								if ${tag1}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_1
	//estadd scalar r2 = e(r2): est_1
	
	cd "${directory_output}"
	capture file close myfile
	file open myfile using "coef_pres_1.tex", write replace
	file write myfile %7.0f (_b[${d_in_d}]*100)
	file close myfile

eststo est_2: 	areg 	${dv1} ${d_in_d} ${controls1} ${fe}				 	if ${tag1}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_2
	//estadd scalar r2 = e(r2): est_2
	estadd local controls1 "\checkmark": est_2
	
eststo est_3: 	areg 	${dv1} ${d_in_d} ${controls2} ${fe}				 	if ${tag1}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_3
	//estadd scalar r2 = e(r2): est_3
	estadd local controls1 "\checkmark": est_3
	estadd local controls2 "\checkmark": est_3
	
	cd "${directory_output}"
	capture file close myfile
	file open myfile using "coef_pres_2.tex", write replace
	file write myfile %7.0f (_b[${d_in_d}]*100)
	file close myfile

	
	// outcome: congressional turnout
eststo est_4: 	areg 	${dv2} ${d_in_d} ${fe}				 				if ${tag2}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_4
	//estadd scalar r2 = e(r2): est_4
	
	cd "${directory_output}"
	capture file close myfile
	file open myfile using "coef_cong_1.tex", write replace
	file write myfile %7.0f (_b[${d_in_d}]*100)
	file close myfile
	

eststo est_5: 	areg 	${dv2} ${d_in_d} ${controls1} ${fe}				 	if ${tag2}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_5
	//estadd scalar r2 = e(r2): est_5
	estadd local controls1 "\checkmark": est_5
	
eststo est_6: 	areg 	${dv2} ${d_in_d} ${controls2} ${fe}					if ${tag2}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_6
	//estadd scalar r2 = e(r2): est_6
	estadd local controls1 "\checkmark": est_6
	estadd local controls2 "\checkmark": est_6



	
	* output the regressions
	*-----------------------

	cd "${directory_output}"

	#delimit;
	
	esttab 
	
			est_1
			est_2
			est_3
			est_4
			est_5
			est_6
		
		using "${filename}.tex", 
		
			b(a2) label replace nogaps compress se(a2) bookt 
			noconstant nodepvars star(* 0.1 ** 0.05 *** 0.01)
			fragment keep(${d_in_d})
			
			stats(	
					N 
					controls1 
					controls2
					, 
				labels(	
						"Observations" 
						"Controls1"
						"Controls2"
						) 
					)
			title("")
			nomtitles		
		;
		
		#delimit cr

		
		
		

		

			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* table 3 (paper): democratic vote share 
*-------------------------------------------------------------------------------
	

* globals
*--------

_eststo clear

global dv1 		= "vshare_p_dem"
global dv2 		= "vshare_p_dem_gov"
global d_in_d 	= "post_x_covered"
global tag1 	= "tag_turnout_p == 1"
global fe		= "i.year"
global absorb 	= "county_id"

global filename = "Democrat_1_paper"



* clear
*------

_eststo clear



* specification
*--------------
	
	// outcome: presidential turnout
eststo est_1: 	areg 	${dv1} ${d_in_d} ${fe} 					if ${tag1}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_1
	//estadd scalar r2 = e(r2): est_1
	
	cd "${directory_output}"
	capture file close myfile
	file open myfile using "coef_dem_1.tex", write replace
	file write myfile %7.0f (_b[${d_in_d}]*-100)
	file close myfile

eststo est_2: 	areg 	${dv1} ${d_in_d} ${controls1} ${fe} 	if ${tag1}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_2
	//estadd scalar r2 = e(r2): est_2
	estadd local controls1 "\checkmark": est_2
	
eststo est_3: 	areg 	${dv1} ${d_in_d} ${controls2} ${fe} 	if ${tag1}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_3
	//estadd scalar r2 = e(r2): est_3
	estadd local controls1 "\checkmark": est_3
	estadd local controls2 "\checkmark": est_3


	// outcome: presidential turnout
eststo est_4: 	areg 	${dv2} ${d_in_d} ${fe}					if ${tag1},  absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_4
	//estadd scalar r2 = e(r2): est_4

eststo est_5: 	areg 	${dv2} ${d_in_d} ${controls1} ${fe}		if ${tag1}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_5
	//estadd scalar r2 = e(r2): est_5
	estadd local controls1 "\checkmark": est_5
	
eststo est_6: 	areg 	${dv2} ${d_in_d} ${controls2}  ${fe}	if ${tag1}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_6
	//estadd scalar r2 = e(r2): est_6
	estadd local controls1 "\checkmark": est_6
	estadd local controls2 "\checkmark": est_6
	
	cd "${directory_output}"
	capture file close myfile
	file open myfile using "coef_dem_2.tex", write replace
	file write myfile %7.0f (_b[${d_in_d}]*-100)
	file close myfile

	
	
	
	* output the regressions
	*-----------------------

	cd "${directory_output}"

	#delimit;
	
	esttab 
	
			est_1
			est_2
			est_3
			est_4
			est_5
			est_6
		
		using "${filename}.tex", 
		
			b(a2) label replace nogaps compress se(a2) bookt 
			noconstant nodepvars star(* 0.1 ** 0.05 *** 0.01)
			fragment keep(${d_in_d})
			
			stats(	
					N 
					controls1 
					controls2
					, 
				labels(	
						"Observations" 
						"Controls1"
						"Controls2"
						) 
					)
			title("")
			nomtitles		
		;
		
		#delimit cr

	
	
	
	
		
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
		
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	
						** ONLINE APPENDIX **

			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* table E1 (appendix): black vreg AND white vreg
*-------------------------------------------------------------------------------


* globals
*--------

global dv1 		= "p_vreg_bnw"
global dv2 		= "p_vreg_w"
global d_in_d 	= "post_x_covered"
global tag 		= "tag_vreg_bnw == 1"
global fe		= "i.year"
global absorb 	= "county_id"

global filename = "Registration_2_fullresults"



* clear
*------

_eststo clear



* specification
*--------------
	
	// outcome: black voter registration
eststo est_1: 	areg 	${dv1} ${d_in_d} ${fe} 					if ${tag}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_1

eststo est_2: 	areg 	${dv1} ${d_in_d} ${controls1} ${fe} 	if ${tag}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_2
	
eststo est_3: 	areg 	${dv1} ${d_in_d} ${controls2}  ${fe} 	if ${tag}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_3

	
	// outcome: gap bw registration
eststo est_4: 	areg 	${dv2} ${d_in_d} ${fe} 					if ${tag}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_4

eststo est_5: 	areg 	${dv2} ${d_in_d} ${controls1} ${fe} 	if ${tag}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_5
	
eststo est_6: 	areg 	${dv2} ${d_in_d} ${controls2} ${fe} 	if ${tag}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_6



	
	* output the regressions
	*-----------------------

	cd "${directory_output}"

	#delimit;
	
	esttab 
	
			est_1
			est_2
			est_3
			est_4
			est_5
			est_6
		
		using "${filename}.tex", 
		
			b(a2) label replace nogaps compress se(a2) bookt 
			noconstant nodepvars star(* 0.1 ** 0.05 *** 0.01)
			fragment keep(${d_in_d} ${controls2})
			
			stats(	
					N 
					, 
				labels(	
						"Observations" 
						) 
					)
			title("")
			nomtitles		
		;
		
		#delimit cr


	
	

			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* results dropping Graham county (not presented in the paper or appendix)
*-------------------------------------------------------------------------------


/*

* preserve
*---------

preserve


* drop Graham
*------------

drop if county == "Graham"

	
		
* globals
*--------

global dv1 		= "p_vreg_bnw"
global dv2 		= "p_vreg_w"
global d_in_d 	= "post_x_covered"
global tag 		= "tag_vreg_bnw == 1"
global fe		= "i.year"
global absorb 	= "county_id"



* specification
*--------------
	
	// outcome: black voter registration
areg 	${dv1} ${d_in_d} ${fe} 					if ${tag}, absorb(${absorb}) vce(cl county_id) 

areg 	${dv1} ${d_in_d} ${controls1} ${fe} 	if ${tag}, absorb(${absorb}) vce(cl county_id) 
	
areg 	${dv1} ${d_in_d} ${controls2} ${fe} 	if ${tag}, absorb(${absorb}) vce(cl county_id) 

	
	// outcome: gap bw registration
areg 	${dv2} ${d_in_d} ${fe} 					if ${tag}, absorb(${absorb}) vce(cl county_id) 

areg 	${dv2} ${d_in_d} ${controls1} ${fe} 	if ${tag}, absorb(${absorb}) vce(cl county_id) 
	
areg 	${dv2} ${d_in_d} ${controls2} ${fe} 	if ${tag}, absorb(${absorb}) vce(cl county_id) 

		
		
* restore
*--------

restore		
		
*/		
	
		

		
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* results dropping any county with missing registration data (not presented in the paper or appendix)
*-------------------------------------------------------------------------------


/*

* preserve
*---------

preserve


* drop any county with missing registration data
*-----------------------------------------------

drop if county == "Graham"
drop if county == "Davidson"
drop if county == "Dare"
drop if county == "Yadkin"
drop if county == "Orange"

	
		
* globals
*--------

global dv1 		= "p_vreg_bnw"
global dv2 		= "p_vreg_w"
global d_in_d 	= "post_x_covered"
global tag 		= "tag_vreg_bnw == 1"
global fe		= "i.year"
global absorb 	= "county_id"



* specification
*--------------
	
	// outcome: black voter registration
areg 	${dv1} ${d_in_d} ${fe} 					if ${tag}, absorb(${absorb}) vce(cl county_id) 

areg 	${dv1} ${d_in_d} ${controls1} ${fe} 	if ${tag}, absorb(${absorb}) vce(cl county_id) 
	
areg 	${dv1} ${d_in_d} ${controls2} ${fe} 	if ${tag}, absorb(${absorb}) vce(cl county_id) 

	
	// outcome: gap bw registration
areg 	${dv2} ${d_in_d} ${fe} 					if ${tag}, absorb(${absorb}) vce(cl county_id) 

areg 	${dv2} ${d_in_d} ${controls1} ${fe} 	if ${tag}, absorb(${absorb}) vce(cl county_id) 
	
areg 	${dv2} ${d_in_d} ${controls2} ${fe} 	if ${tag}, absorb(${absorb}) vce(cl county_id) 

		
		
* restore
*--------

restore		
			
*/
	
	
	
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* results dropping years 1966 and 1967 from analysis (not presented in the paper or appendix)
*-------------------------------------------------------------------------------


/*

* preserve
*---------

preserve


* drop years with most missing data
*----------------------------------

drop if year == 1966
drop if year == 1967

	
		
* globals
*--------

global dv1 		= "p_vreg_bnw"
global dv2 		= "p_vreg_w"
global d_in_d 	= "post_x_covered"
global tag 		= "tag_vreg_bnw == 1"
global fe		= "i.year"
global absorb 	= "county_id"



* specification
*--------------
	
	// outcome: black voter registration
areg 	${dv1} ${d_in_d} ${fe} 					if ${tag}, absorb(${absorb}) vce(cl county_id) 

areg 	${dv1} ${d_in_d} ${controls1} ${fe} 	if ${tag}, absorb(${absorb}) vce(cl county_id) 
	
areg 	${dv1} ${d_in_d} ${controls2} ${fe} 	if ${tag}, absorb(${absorb}) vce(cl county_id) 

	
	// outcome: gap bw registration
areg 	${dv2} ${d_in_d} ${fe} 					if ${tag}, absorb(${absorb}) vce(cl county_id) 

areg 	${dv2} ${d_in_d} ${controls1} ${fe} 	if ${tag}, absorb(${absorb}) vce(cl county_id) 
	
areg 	${dv2} ${d_in_d} ${controls2} ${fe} 	if ${tag}, absorb(${absorb}) vce(cl county_id) 

		
		
* restore
*--------

restore		
		
	
	*/
	
	
	


		
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* table E2 (appendix): voter turnout
*-------------------------------------------------------------------------------


* globals
*--------

global dv1 		= "v_turnout_p"
global dv2 		= "v_turnout_c"
global d_in_d 	= "post_x_covered"
global tag1 	= "tag_turnout_p == 1"
global tag2 	= "tag_turnout_c == 1"
global fe		= "i.year"
global absorb 	= "county_id"

global filename = "Turnout_2_fullresults"



* clear
*------

_eststo clear



* specification
*--------------
	
	// outcome: presidential turnout
eststo est_1: 	areg 	${dv1} ${d_in_d} ${fe} 					if ${tag1}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_1

eststo est_2: 	areg 	${dv1} ${d_in_d} ${controls1} ${fe} 	if ${tag1}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_2
	
eststo est_3: 	areg 	${dv1} ${d_in_d} ${controls2} ${fe} 	if ${tag1}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_3

	
	// outcome: congressional turnout
eststo est_4: 	areg 	${dv2} ${d_in_d} ${fe}					if ${tag2}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_4

eststo est_5: 	areg 	${dv2} ${d_in_d} ${controls1} ${fe} 	if ${tag2}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_5
	
eststo est_6: 	areg 	${dv2} ${d_in_d} ${controls2} ${fe} 	if ${tag2}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_6



	
	* output the regressions
	*-----------------------

	cd "${directory_output}"

	#delimit;
	
	esttab 
	
			est_1
			est_2
			est_3
			est_4
			est_5
			est_6
		
		using "${filename}.tex", 
		
			b(a2) label replace nogaps compress se(a2) bookt 
			noconstant nodepvars star(* 0.1 ** 0.05 *** 0.01)
			fragment keep(${d_in_d} ${controls2})
			
			stats(	
					N 
					, 
				labels(	
						"Observations" 
						) 
					)
			title("")
			nomtitles		
		;
		
		#delimit cr

		


			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* table E3 (appendix): democratic vote share 
*-------------------------------------------------------------------------------
	

* globals
*--------

_eststo clear

global dv1 		= "vshare_p_dem"
global dv2 		= "vshare_p_dem_gov"
global d_in_d 	= "post_x_covered"
global tag1 	= "tag_turnout_p == 1"
global fe		= "i.year"
global absorb 	= "county_id"

global filename = "Democrat_2_fullresults"



* clear
*------

_eststo clear



* specification
*--------------
	
	// outcome: presidential turnout
eststo est_1: 	areg 	${dv1} ${d_in_d} ${fe} 					if ${tag1}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_1

eststo est_2: 	areg 	${dv1} ${d_in_d} ${controls1} ${fe} 	if ${tag1}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_2
	
eststo est_3: 	areg 	${dv1} ${d_in_d} ${controls2} ${fe} 	if ${tag1}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_3

	
	// outcome: presidential turnout
eststo est_4: 	areg 	${dv2} ${d_in_d} ${fe} 					if ${tag1}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_4

eststo est_5: 	areg 	${dv2} ${d_in_d} ${controls1} ${fe} 	if ${tag1}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_5
	
eststo est_6: 	areg 	${dv2} ${d_in_d} ${controls2} ${fe} 	if ${tag1}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_6
	
	
	
	* output the regressions
	*-----------------------

	cd "${directory_output}"

	#delimit;
	
	esttab 
	
			est_1
			est_2
			est_3
			est_4
			est_5
			est_6
		
		using "${filename}.tex", 
		
			b(a2) label replace nogaps compress se(a2) bookt 
			noconstant nodepvars star(* 0.1 ** 0.05 *** 0.01)
			fragment keep(${d_in_d} ${controls2})
			
			stats(	
					N 
					, 
				labels(	
						"Observations" 
						) 
					)
			title("")
			nomtitles		
		;
		
		#delimit cr



			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* table C1 (appendix): pre-treatment parallel trends
*-------------------------------------------------------------------------------


* globals
*--------

global dv1 		= "p_vreg_bnw_2"
global dv2 		= "p_vreg_w_2"
global dv3 		= "gap_bw_vreg"
global dv4 		= "v_turnout_p"
global dv5 		= "v_turnout_c"
global dv6 		= "vshare_p_dem"
global dv7 		= "vshare_p_dem_gov"
global absorb 	= "county_id"

global tag1 	= "tag_vreg_bnw == 1"
global tag2 	= "tag_turnout_p == 1"
global tag3 	= "tag_turnout_c == 1"

global filename = "Reg_ParallelTrends"




* generate linear trend and interaction
*--------------------------------------

capture drop trend trend_x_covered

sort county year
bysort county: gen trend = _n
gen trend_x_covered = trend * covered

label var trend_x_covered 	"Time $\cdot$ covered ($\hat{\psi}$)"
label var trend				"Time ($\hat{\gamma}$)"



global spec = "trend trend_x_covered"



* specifications
*---------------

_eststo clear

eststo est_1: 	areg ${dv1}  ${spec} ${controls2}		if year < 1965 & ${tag1},  absorb(${absorb}) vce(cl county_id)  

eststo est_2: 	areg ${dv2}  ${spec} ${controls2}		if year < 1965 & ${tag1},  absorb(${absorb}) vce(cl county_id)	

eststo est_3: 	areg ${dv3}  ${spec} ${controls2}		if year < 1965 & ${tag1},  absorb(${absorb}) vce(cl county_id)

eststo est_4: 	areg ${dv4}  ${spec} ${controls2}		if year < 1965 & ${tag2},  absorb(${absorb}) vce(cl county_id)

eststo est_5: 	areg ${dv5}  ${spec} ${controls2} 		if year < 1965 & ${tag3},  absorb(${absorb}) vce(cl county_id)

eststo est_6: 	areg ${dv6}  ${spec} ${controls2} 		if year < 1965 & ${tag2},  absorb(${absorb}) vce(cl county_id)

eststo est_7: 	areg ${dv7}  ${spec} ${controls2} 		if year < 1965 & ${tag2},  absorb(${absorb}) vce(cl county_id)




	
	* output the regressions
	*-----------------------

	cd "${directory_output}"

	#delimit;
	
	esttab 
	
			est_1
			est_2
			est_3
			est_4
			est_5
			est_6
			est_7
		
		using "${filename}.tex", 
		
			b(a2) label replace nogaps compress se(a2) bookt 
			noconstant nodepvars star(* 0.1 ** 0.05 *** 0.01)
			fragment keep(${spec})
			
			stats(	
					N 
					, 
				labels(	
						"Observations" 
						) 
					)
			title("")
			nomtitles		
		;
		
		#delimit cr



	
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
*  trends for moderately discriminatory versus extreme counties (not presented)
*-------------------------------------------------------------------------------
	
	// examines whether pre-VRA trends were similar amongst moderately versus extremely discriminatory counties (based on 1964 voter turnout)
	

* results
*--------

/*
	
areg ${dv1}  ${spec} ${controls2}	///
		if year < 1965 & ${tag1} & vote_perc_va1 >= .4 & vote_perc_va1 <= .6,  absorb(${absorb}) vce(cl county_id)  

areg ${dv1}  ${spec} ${controls2}	///
		if year < 1965 & ${tag1} & (vote_perc_va1 <= .4 | vote_perc_va1 >= .6),  absorb(${absorb}) vce(cl county_id)  

		
areg ${dv2}  ${spec} ${controls2}	///
		if year < 1965 & ${tag1} & vote_perc_va1 >= .4 & vote_perc_va1 <= .6,  absorb(${absorb}) vce(cl county_id)  

areg ${dv2}  ${spec} ${controls2}	///
		if year < 1965 & ${tag1} & (vote_perc_va1 <= .4 | vote_perc_va1 >= .6),  absorb(${absorb}) vce(cl county_id)  

areg ${dv3}  ${spec} ${controls2}	///
		if year < 1965 & ${tag1} & vote_perc_va1 >= .4 & vote_perc_va1 <= .6,  absorb(${absorb}) vce(cl county_id)  

areg ${dv3}  ${spec} ${controls2}	///
		if year < 1965 & ${tag1} & (vote_perc_va1 <= .4 | vote_perc_va1 >= .6),  absorb(${absorb}) vce(cl county_id)  

		
areg ${dv4}  ${spec} ${controls2}	///
		if year < 1965 & ${tag1} & vote_perc_va1 >= .4 & vote_perc_va1 <= .6,  absorb(${absorb}) vce(cl county_id)  

areg ${dv4}  ${spec} ${controls2}	///
		if year < 1965 & ${tag1} & (vote_perc_va1 <= .4 | vote_perc_va1 >= .6),  absorb(${absorb}) vce(cl county_id)  

		
areg ${dv5}  ${spec} ${controls2}	///
		if year < 1965 & ${tag1} & vote_perc_va1 >= .4 & vote_perc_va1 <= .6,  absorb(${absorb}) vce(cl county_id)  

areg ${dv5}  ${spec} ${controls2}	///
		if year < 1965 & ${tag1} & (vote_perc_va1 <= .4 | vote_perc_va1 >= .6),  absorb(${absorb}) vce(cl county_id)  
	

*/



			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* table E4 (appendix): w-b gap in registration 
*-------------------------------------------------------------------------------
	

* globals
*--------

_eststo clear

global dv1 		= "gap_bw_vreg"
global d_in_d 	= "post_x_covered"
global tag1 	= "tag_vreg_bnw == 1"
global fe		= "i.year"
global absorb	= "county_id"

global filename = "Gap_1_fullresults"



* clear
*------

_eststo clear



* specification
*--------------
	
	// outcome: presidential turnout
eststo est_1: 	areg 	${dv1} ${d_in_d} ${fe} 					if ${tag1}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_1
	
	cd "${directory_output}"
	capture file close myfile
	file open myfile using "coef_gap_1.tex", write replace
	file write myfile %7.0f (_b[${d_in_d}]*100)
	file close myfile

eststo est_2: 	areg 	${dv1} ${d_in_d} ${controls1} ${fe} 	if ${tag1}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_2
	
eststo est_3: 	areg 	${dv1} ${d_in_d} ${controls2} ${fe} 	if ${tag1}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_3
	
	cd "${directory_output}"
	capture file close myfile
	file open myfile using "coef_gap_2.tex", write replace
	file write myfile %7.0f (_b[${d_in_d}]*100)
	file close myfile


	
	* output the regressions
	*-----------------------

	cd "${directory_output}"

	#delimit;
	
	esttab 
	
			est_1
			est_2
			est_3
		
		using "${filename}.tex", 
		
			b(a2) label replace nogaps compress se(a2) bookt 
			noconstant nodepvars star(* 0.1 ** 0.05 *** 0.01)
			fragment keep(${d_in_d} ${controls2})
			
			stats(	
					N 
					, 
				labels(	
						"Observations" 
						) 
					)
			title("")
			nomtitles		
		;
		
		#delimit cr


		

			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* table H1 (appendix): black vreg AND white reg with alt. denominators (interpolated population)
*-------------------------------------------------------------------------------


* globals
*--------

global dv1 		= "p_vreg_bnw_2"
global dv2 		= "p_vreg_w_2"
global d_in_d 	= "post_x_covered"
global tag 		= "tag_vreg_bnw == 1"
global fe		= "i.year"
global absorb	= "county_id"

global filename = "Registration_3_altdenom"



* clear
*------

_eststo clear



* specification
*--------------
	
	// outcome: black voter registration
eststo est_1: 	areg 	${dv1} ${d_in_d} ${fe} 					if ${tag}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_1

eststo est_2: 	areg 	${dv1} ${d_in_d} ${controls1} ${fe} 	if ${tag}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_2
	
eststo est_3: 	areg 	${dv1} ${d_in_d} ${controls2} ${fe} 	if ${tag}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_3

	
	// outcome: gap bw registration
eststo est_4: 	areg 	${dv2} ${d_in_d} ${fe} 					if ${tag}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_4

eststo est_5: 	areg 	${dv2} ${d_in_d} ${controls1} ${fe} 	if ${tag}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_5
	
eststo est_6: 	areg 	${dv2} ${d_in_d} ${controls2} ${fe} 	if ${tag}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_6



	
	* output the regressions
	*-----------------------

	cd "${directory_output}"

	#delimit;
	
	esttab 
	
			est_1
			est_2
			est_3
			est_4
			est_5
			est_6
		
		using "${filename}.tex", 
		
			b(a2) label replace nogaps compress se(a2) bookt 
			noconstant nodepvars star(* 0.1 ** 0.05 *** 0.01)
			fragment keep(${d_in_d} ${controls2})
			
			stats(	
					N 
					, 
				labels(	
						"Observations" 
						) 
					)
			title("")
			nomtitles		
		;
		
		#delimit cr

			
	

		
		
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* table H2 (appendix): white registration using alternative denominator (interpolated)
*-------------------------------------------------------------------------------
		
	
* globals
*--------

global dv1 		= "gap_bw_vreg_2"
global d_in_d 	= "post_x_covered"
global tag 		= "tag_vreg_bnw == 1"
global fe		= "i.year"
global absorb	= "county_id"

global filename = "Gap_2_altdenom"



* clear
*------

_eststo clear



* specification
*--------------
	
	// outcome: presidential turnout
eststo est_1: 	areg 	${dv1} ${d_in_d} ${fe} 					if ${tag}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_1

eststo est_2: 	areg 	${dv1} ${d_in_d} ${controls1} ${fe} 	if ${tag}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_2
	
eststo est_3: 	areg 	${dv1} ${d_in_d} ${controls2} ${fe} 	if ${tag}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_3


	
	* output the regressions
	*-----------------------

	cd "${directory_output}"

	#delimit;
	
	esttab 
	
			est_1
			est_2
			est_3
		
		using "${filename}.tex", 
		
			b(a2) label replace nogaps compress se(a2) bookt 
			noconstant nodepvars star(* 0.1 ** 0.05 *** 0.01)
			fragment keep(${d_in_d} ${controls2})
			
			stats(	
					N 
					, 
				labels(	
						"Observations" 
						) 
					)
			title("")
			nomtitles		
		;
		
		#delimit cr


		

		
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* short, medium and long term effects (appendix)
*-------------------------------------------------------------------------------
	

* globals
*--------

global dv1 		= "p_vreg_bnw"
global dv2 		= "p_vreg_w"
global dv3 		= "gap_bw_vreg"
global dv4 		= "v_turnout_p"
global dv5 		= "v_turnout_c"
global dv6 		= "vshare_p_dem"
global dv7 		= "vshare_p_dem_gov"
global fe		= "i.year"
global absorb	= "county_id"

global d_in_d 	= "post_early_x_covered post_mid_x_covered post_late_x_covered"
global d_in_d2 	= "post_early_x_covered post_mid_x_covered"

global tag1 	= "tag_vreg_bnw == 1"
global tag2 	= "tag_turnout_p == 1"
global tag3 	= "tag_turnout_c == 1"

global filename = "Duration"



* clear
*------

_eststo clear



* specification
*--------------
	
eststo est_1: 	areg 	${dv1} ${d_in_d} ${controls1} ${fe} 	if ${tag1}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_1
	estadd local controls1 "\checkmark": est_1
	
eststo est_2: 	areg 	${dv2} ${d_in_d} ${controls1} ${fe} 	if ${tag1}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_2
	estadd local controls1 "\checkmark": est_2
	
eststo est_3: 	areg 	${dv3} ${d_in_d} ${controls1} ${fe} 	if ${tag1}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_3
	estadd local controls1 "\checkmark": est_3
	
eststo est_4: 	areg 	${dv4} ${d_in_d} ${controls1} ${fe} 	if ${tag2}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_4
	estadd local controls1 "\checkmark": est_4
	
eststo est_5: 	areg 	${dv5} ${d_in_d2} ${controls1} ${fe} 	if ${tag3}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_5
	estadd local controls1 "\checkmark": est_5
	
eststo est_6: 	areg 	${dv6} ${d_in_d} ${controls1} ${fe} 	if ${tag2}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_6
	estadd local controls1 "\checkmark": est_6
	
eststo est_7: 	areg 	${dv7} ${d_in_d} ${controls1} ${fe} 	if ${tag2}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_7
	estadd local controls1 "\checkmark": est_7

	
	
	
	* output the regressions
	*-----------------------

	cd "${directory_output}"

	#delimit;
	
	esttab 
	
			est_1
			est_2
			est_3
			est_4
			est_5
			est_6
			est_7
		
		using "${filename}.tex", 
		
			b(a2)  replace nogaps compress se(a2) bookt 
			noconstant nodepvars star(* 0.1 ** 0.05 *** 0.01)
			fragment keep(${d_in_d})
			
			coeflabels (
				post_early_x_covered 	"1965-1970 $\cdot$ covered ($\hat{\beta{1}}$)"
				post_mid_x_covered 		"1970-1982 $\cdot$ covered ($\hat{\beta{2}}$)"
				post_late_x_covered		"Post-1982 $\cdot$ covered ($\hat{\beta{3}}$)"
			
				)
			stats(	
					N 
					controls1
					, 
				labels(	
						"Observations" 
						"Controls1"
						) 
					)
			title("")
			nomtitles		
		;
		
		#delimit cr
	
	
	
	
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* dropping missing years
*-------------------------------------------------------------------------------
		
		
* tag years with missing
*-----------------------		

capture drop tag_missing
gen tag_missing = 1 if year == 1966 | year == 1967


	
* globals
*--------

global dv1 		= "p_vreg_bnw"
global dv2 		= "gap_bw_vreg"
global d_in_d 	= "post_x_covered"
global tag 		= "tag_vreg_bnw == 1 & county_id != 38" //tag_missing != 1
global fe		= "i.year"
global absorb 	= "county_id"

global filename = "Registration_3_missing"



* clear
*------

_eststo clear



* specification
*--------------
	
	// outcome: black voter registration
eststo est_1: 	areg 	${dv1} ${d_in_d} ${fe} 					if ${tag}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_1

eststo est_2: 	areg 	${dv1} ${d_in_d} ${controls1} ${fe} 	if ${tag}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_2
	
eststo est_3: 	areg 	${dv1} ${d_in_d} ${controls2}  ${fe} 	if ${tag}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_3

	
	// outcome: gap bw registration
eststo est_4: 	areg 	${dv2} ${d_in_d} ${fe} 					if ${tag}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_4

eststo est_5: 	areg 	${dv2} ${d_in_d} ${controls1} ${fe} 	if ${tag}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_5
	
eststo est_6: 	areg 	${dv2} ${d_in_d} ${controls2} ${fe} 	if ${tag}, absorb(${absorb}) vce(cl county_id) 
	estadd scalar groups = e(N_g): est_6



	
	* output the regressions
	*-----------------------

	cd "${directory_output}"

	#delimit;
	
	esttab 
	
			est_1
			est_2
			est_3
			est_4
			est_5
			est_6
		
		using "${filename}.tex", 
		
			b(a2) label replace nogaps compress se(a2) bookt 
			noconstant nodepvars star(* 0.1 ** 0.05 *** 0.01)
			fragment keep(${d_in_d} ${controls2})
			
			stats(	
					N 
					, 
				labels(	
						"Observations" 
						) 
					)
			title("")
			nomtitles		
		;
		
		#delimit cr

		
		
		
		
		
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* variables for summary statistics
*-------------------------------------------------------------------------------
	

* variables
*----------
		
#delimit ;

global vars = 	"p_vreg_bnw p_vreg_w gap_bw_vreg v_turnout_p v_turnout_c vshare_p_dem vshare_p_dem_gov
				pop_t_ln pop_b_perc inc_hh_med educ_25p tot_victim intake_b_perc 
				net_mig_rate_t net_mig_rate_w net_mig_rate_nw"
				;
#delimit cr		



			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* table A2 (appendix): basic summary statistics
*-------------------------------------------------------------------------------
	
	
* set output directory
*---------------------

cd "${directory_output}"	
	
		
		
* basic summary statistics
*-------------------------
	
foreach v of global vars {	
	
			sum `v'
			
			if "`v'" == "inc_hh_med" {
				local decimals = "5.0"
			}
			else if "`v'" == "net_mig_rate_w" | "`v'" == "net_mig_rate_nw" | "`v'" == "net_mig_rate_t" {
				local decimals = "4.3"
			}
			else {
				local decimals = "4.2"
			}
			
			// mean
			capture file close myfile
			file open myfile using "`v'_mean.tex", write replace
			file write myfile %`decimals'f (`r(mean)')
			file close myfile
	
			// standard deviation
			capture file close myfile
			file open myfile using "`v'_sd.tex", write replace
			file write myfile %`decimals'f (`r(sd)')
			file close myfile
	
			// min
			capture file close myfile
			file open myfile using "`v'_min.tex", write replace
			file write myfile %`decimals'f (`r(min)')
			file close myfile
	
			//max
			capture file close myfile
			file open myfile using "`v'_max.tex", write replace
			file write myfile %`decimals'f (`r(max)')
			file close myfile
			
			//obs
			capture file close myfile
			file open myfile using "`v'_obs.tex", write replace
			file write myfile %7.0f (`r(N)')
			file close myfile

}
			
			
			
			
			
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* table A3 (appendix): pre-treatment differences in levels by coverage status
*-------------------------------------------------------------------------------
	
	
* set output directory
*---------------------

cd "${directory_output}"	
	
	
	
* pre-treatment summary statistics by coverage status
*----------------------------------------------------

forvalues coverage = 0/1 {
	
	foreach v of global vars {

		if ("`v'" == "p_vreg_bnw"| "`v'" ==  "p_vreg_w" | "`v'" ==  "gap_bw_vreg") {
		
			sum `v'  if year < 1965 & covered == `coverage' & tag_vreg_bnw == 1
		}
		else {
			sum `v'  if year < 1965 & covered == `coverage'
		}
	
	
		if "`v'" == "inc_hh_med" {
		
			local decimals = "5.0"
			
		}
		else if "`v'" == "net_mig_rate_w" | "`v'" == "net_mig_rate_nw" | "`v'" == "net_mig_rate_t" {
		
			local decimals = "4.3"
		
		}
		else {
			
			local decimals = "4.3"
			
		}
		
		
		if `coverage' == 1 {
 
			// mean
			capture file close myfile
			file open myfile using "`v'_cov_mean.tex", write replace
			file write myfile %`decimals'f (`r(mean)')
			file close myfile
	
			// standard deviation
			capture file close myfile
			file open myfile using "`v'_cov_sd.tex", write replace
			file write myfile %`decimals'f (`r(sd)')
			file close myfile
	
			// min
			capture file close myfile
			file open myfile using "`v'_cov_min.tex", write replace
			file write myfile %`decimals'f (`r(min)')
			file close myfile
	
			//max
			capture file close myfile
			file open myfile using "`v'_cov_max.tex", write replace
			file write myfile %`decimals'f (`r(max)')
			file close myfile
		
		}
		else if `coverage' == 0 {
 
			// mean
			capture file close myfile
			file open myfile using "`v'_uncov_mean.tex", write replace
			file write myfile %`decimals'f (`r(mean)')
			file close myfile
	
			// standard deviation
			capture file close myfile
			file open myfile using "`v'_uncov_sd.tex", write replace
			file write myfile %`decimals'f (`r(sd)')
			file close myfile
	
			// min
			capture file close myfile
			file open myfile using "`v'_uncov_min.tex", write replace
			file write myfile %`decimals'f (`r(min)')
			file close myfile
	
			//max
			capture file close myfile
			file open myfile using "`v'_uncov_max.tex", write replace
			file write myfile %`decimals'f (`r(max)')
			file close myfile
		
		}

	}
}





			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* plot 1 (figure F1):  diff-in-diff by registration, blacks
*-------------------------------------------------------------------------------


* locals
*-------

capture drop p_vreg_bnw_mean 
bysort covered year: egen p_vreg_bnw_mean = mean(p_vreg_bnw)

local outcome 	= "p_vreg_bnw_mean"
local tag 		= "tag_cov_yr_reg == 1" 



* plot
*-----


#delimit ;


twoway 
	
		// covered
	( line  `outcome' year	 	
		
		if `tag'  & year < 1965 & covered == 1
		, 	lcolor(black) lwidth(medthick) 
			xline(1965, lcolor(gs8) )
		)
	
	( line  `outcome' year	 	
		
		if `tag'  & year >= 1965 & covered == 1
		, 	lcolor(black) lwidth(medthick) 
		)
	( scatter  `outcome' year	 	
		
		if `tag'  & year < 1965 & covered == 1
		, 	mcolor(black) msize(medium) 
			xline(1965, lcolor(gs8) )
		)
	
	( scatter  `outcome' year	 	
		
		if `tag'  & year >= 1965 & covered == 1
		, 	mcolor(black) msize(medium)  
		)
		
			// not-covered
	( line  `outcome' year	 	
		
		if `tag'  & year < 1965 & covered == 0
		, 	lcolor(gs7) lwidth(medthick) lpattern(dash)
		)
	
	( line  `outcome' year	 	
		
		if `tag'  & year >= 1965 & covered == 0
		, 	lcolor(gs7) lwidth(medthick) lpattern(dash)
		)	
	( scatter  `outcome' year	 	
		
		if `tag'  & year < 1965 & covered == 0
		, 	mcolor(gs7) msize(medium) msymbol(Oh)
		)
	
	( scatter  `outcome' year	 	
		
		if `tag'  & year >= 1965 & covered == 0
		, 	mcolor(gs7) msize(medium) msymbol(Oh)
		)	
		

	
	,

		xscale(noline )
		yscale(noline )
		title("", color(black) size(medsmall) pos(11) ) 
		xlab( 1960(5)1990 , 
			labsize(medium) ) 
		ylab( 0(.2)1 , 
			angle(hori) labsize(medium) nogrid  )
		xtitle("Year" , 
			color(black) size(medium) )
		ytitle("Black Registration as a % of Voting Age Pop.", 
			color(black) size(medium)  )
		graphregion( fcolor(white) lcolor(white) ) 
		plotregion( fcolor(white) lstyle(none) lcolor(white) ilstyle(none)) 
		legend( 
			order(2 "Covered Counties" 6 "Uncovered Counties" )
			pos(5)
			ring(0)
			cols(1)
			region( color(none) )
			size(medium)	
		)
		
		
		 ;
		 
#delimit cr





	* export the graph
	*-----------------

	cd "${directory_output}"
	graph export "DinD_1_RegBlack.pdf", replace
	




			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* plot 2 (appendix F1):  diff-in-diff by registration, whites 
*-------------------------------------------------------------------------------


* locals
*-------

capture drop p_vreg_w_mean 
bysort covered year: egen p_vreg_w_mean = mean(p_vreg_w)

local outcome 	= "p_vreg_w_mean"
local tag 		= "tag_cov_yr_reg == 1" 



	
* plot
*-----


#delimit ;


twoway 
	
		// covered
	( line  `outcome' year	 	
		
		if `tag'  & year < 1965 & covered == 1
		, 	lcolor(black) lwidth(medthick) 
			xline(1965, lcolor(gs8) )
		)
	
	( line  `outcome' year	 	
		
		if `tag'  & year >= 1965 & covered == 1
		, 	lcolor(black) lwidth(medthick) 
		)
	( scatter  `outcome' year	 	
		
		if `tag'  & year < 1965 & covered == 1
		, 	mcolor(black) msize(medium) 
			xline(1965, lcolor(gs8) )
		)
	
	( scatter  `outcome' year	 	
		
		if `tag'  & year >= 1965 & covered == 1
		, 	mcolor(black) msize(medium)  
		)
		
			// not-covered
	( line  `outcome' year	 	
		
		if `tag'  & year < 1965 & covered == 0
		, 	lcolor(gs7) lwidth(medthick) lpattern(dash)
		)
	
	( line  `outcome' year	 	
		
		if `tag'  & year >= 1965 & covered == 0
		, 	lcolor(gs7) lwidth(medthick) lpattern(dash)
		)	
	( scatter  `outcome' year	 	
		
		if `tag'  & year < 1965 & covered == 0
		, 	mcolor(gs7) msize(medium) msymbol(Oh)
		)
	
	( scatter  `outcome' year	 	
		
		if `tag'  & year >= 1965 & covered == 0
		, 	mcolor(gs7) msize(medium) msymbol(Oh)
		)	
		

	,

		xscale(noline )
		yscale(noline )
		title("", color(black) size(medsmall) pos(11) ) 
		xlab( 1960(5)1990 , 
			labsize(medium) ) 
		ylab( 0(.2)1 , 
			angle(hori) labsize(medium) nogrid  )
		xtitle("Year" , 
			color(black) size(medium) )
		ytitle("White Registration as a % of Voting Age Pop.", 
			color(black) size(medium)  )
		graphregion( fcolor(white) lcolor(white) ) 
		plotregion( fcolor(white) lstyle(none) lcolor(white) ilstyle(none)) 
		legend( 
			order(2 "Covered Counties" 6 "Uncovered Counties" )
			pos(5)
			ring(0)
			cols(1)
			region( color(none) )
			size(medium)	
		)
		
		
		 ;
		 
#delimit cr





	* export the graph
	*-----------------

	cd "${directory_output}"
	graph export "DinD_2_RegWhite.pdf", replace
	



			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* plot 3 (appendix F1):  gap in registration 
*-------------------------------------------------------------------------------


* locals
*-------

capture drop gap_bw_vreg_mean 
bysort covered year: egen gap_bw_vreg_mean = mean(gap_bw_vreg)

local outcome 	= "gap_bw_vreg_mean"
local tag 		= "tag_cov_yr_reg == 1" 



	
	
* plot
*-----


#delimit ;


twoway 
	
		// covered
	( line  `outcome' year	 	
		
		if `tag'  & year < 1965 & covered == 1
		, 	lcolor(black) lwidth(medthick) 
			xline(1965, lcolor(gs8)) yline(0, lcolor(gs12) lpattern(longdash) )  
		)
	
	( line  `outcome' year	 	
		
		if `tag'  & year >= 1965 & covered == 1
		, 	lcolor(black) lwidth(medthick) 
		)
	( scatter  `outcome' year	 	
		
		if `tag'  & year < 1965 & covered == 1
		, 	mcolor(black) msize(medium) 
			xline(1965, lcolor(gs8) )
		)
	
	( scatter  `outcome' year	 	
		
		if `tag'  & year >= 1965 & covered == 1
		, 	mcolor(black) msize(medium)  
		)
		
			// not-covered
	( line  `outcome' year	 	
		
		if `tag'  & year < 1965 & covered == 0
		, 	lcolor(gs7) lwidth(medthick) lpattern(dash)
		)
	
	( line  `outcome' year	 	
		
		if `tag'  & year >= 1965 & covered == 0
		, 	lcolor(gs7) lwidth(medthick) lpattern(dash)
		)	
	( scatter  `outcome' year	 	
		
		if `tag'  & year < 1965 & covered == 0
		, 	mcolor(gs7) msize(medium) msymbol(Oh)
		)
	
	( scatter  `outcome' year	 	
		
		if `tag'  & year >= 1965 & covered == 0
		, 	mcolor(gs7) msize(medium) msymbol(Oh)
		)	
		

	,

		xscale(noline )
		yscale(noline )
		title("", color(black) size(medsmall) pos(11) ) 
		xlab( 1960(5)1990 , 
			labsize(medium) ) 
		ylab( -.4(.2)1 , 
			angle(hori) labsize(medium) nogrid  )
		xtitle("Year" , 
			color(black) size(medium) )
		ytitle("B-W Registration Gap as a % of Voting Age Pop.", 
			color(black) size(medium)  )
		graphregion( fcolor(white) lcolor(white) ) 
		plotregion( fcolor(white) lstyle(none) lcolor(white) ilstyle(none)) 
		legend( 
			order(2 "Covered Counties" 6 "Uncovered Counties" )
			pos(2)
			ring(0)
			cols(1)
			region( color(none) )
			size(medium)	
		)
		
		
		 ;
		 
#delimit cr




	* export the graph
	*-----------------

	cd "${directory_output}"
	graph export "DinD_3_Gap.pdf", replace
	








			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* plot 4 (appendix F2):  presidential turnout 
*-------------------------------------------------------------------------------


* locals
*-------

capture drop v_turnout_p_mean 
bysort covered year: egen v_turnout_p_mean = mean(v_turnout_p)

local outcome 	= "v_turnout_p_mean"
local tag 		= "tag_cov_yr_pres == 1" 



	
* plot
*-----


#delimit ;


twoway 
	
		// covered
	( line  `outcome' year	 	
		
		if `tag'  & year < 1965 & covered == 1
		, 	lcolor(black) lwidth(medthick) 
			xline(1965, lcolor(gs8) )
		)
	
	( line  `outcome' year	 	
		
		if `tag'  & year >= 1965 & covered == 1
		, 	lcolor(black) lwidth(medthick) 
		)
	( scatter  `outcome' year	 	
		
		if `tag'  & year < 1965 & covered == 1
		, 	mcolor(black) msize(medium) 
			xline(1965, lcolor(gs8) )
		)
	
	( scatter  `outcome' year	 	
		
		if `tag'  & year >= 1965 & covered == 1
		, 	mcolor(black) msize(medium)  
		)
		
			// not-covered
	( line  `outcome' year	 	
		
		if `tag'  & year < 1965 & covered == 0
		, 	lcolor(gs7) lwidth(medthick) lpattern(dash)
		)
	
	( line  `outcome' year	 	
		
		if `tag'  & year >= 1965 & covered == 0
		, 	lcolor(gs7) lwidth(medthick) lpattern(dash)
		)	
	( scatter  `outcome' year	 	
		
		if `tag'  & year < 1965 & covered == 0
		, 	mcolor(gs7) msize(medium) msymbol(Oh)
		)
	
	( scatter  `outcome' year	 	
		
		if `tag'  & year >= 1965 & covered == 0
		, 	mcolor(gs7) msize(medium) msymbol(Oh)
		)	
		

	,

		xscale(noline )
		yscale(noline )
		title("", color(black) size(medium) pos(11) ) 
		xlab( 1945(5)1995 , 
			labsize(medium) ) 
		ylab( 0(.2)1 , 
			angle(hori) labsize(medium) nogrid  )
		xtitle("Year" , 
			color(black) size(medium) )
		ytitle("Presidential Turnout as a % of the Voting Age Pop.", 
			color(black) size(medium)  )
		graphregion( fcolor(white) lcolor(white) ) 
		plotregion( fcolor(white) lstyle(none) lcolor(white) ilstyle(none)) 
		legend( 
			order(2 "Covered Counties" 6 "Uncovered Counties" )
			pos(5)
			ring(0)
			cols(1)
			region( color(none) )
			size(medium)	
		)
		
		
		 ;
		 
#delimit cr




	* export the graph
	*-----------------

	cd "${directory_output}"
	graph export "DinD_4_Turnout_P.pdf", replace
	


	
	


			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* plot 4 (appendix F2):  turnout congressional 
*-------------------------------------------------------------------------------


* locals
*-------

capture drop v_turnout_c_mean 
bysort covered year: egen v_turnout_c_mean = mean(v_turnout_c)

local outcome 	= "v_turnout_p_mean"
local tag 		= "tag_cov_yr_con == 1" 




	
* plot
*-----


#delimit ;


twoway 
	
		// covered
	( line  `outcome' year	 	
		
		if `tag'  & year < 1965 & covered == 1
		, 	lcolor(black) lwidth(medthick) 
			xline(1965, lcolor(gs8) )
		)
	
	( line  `outcome' year	 	
		
		if `tag'  & year >= 1965 & covered == 1
		, 	lcolor(black) lwidth(medthick) 
		)
	( scatter  `outcome' year	 	
		
		if `tag'  & year < 1965 & covered == 1
		, 	mcolor(black) msize(medium) 
			xline(1965, lcolor(gs8) )
		)
	
	( scatter  `outcome' year	 	
		
		if `tag'  & year >= 1965 & covered == 1
		, 	mcolor(black) msize(medium)  
		)
		
			// not-covered
	( line  `outcome' year	 	
		
		if `tag'  & year < 1965 & covered == 0
		, 	lcolor(gs7) lwidth(medthick) lpattern(dash)
		)
	
	( line  `outcome' year	 	
		
		if `tag'  & year >= 1965 & covered == 0
		, 	lcolor(gs7) lwidth(medthick) lpattern(dash)
		)	
	( scatter  `outcome' year	 	
		
		if `tag'  & year < 1965 & covered == 0
		, 	mcolor(gs7) msize(medium) msymbol(Oh)
		)
	
	( scatter  `outcome' year	 	
		
		if `tag'  & year >= 1965 & covered == 0
		, 	mcolor(gs7) msize(medium) msymbol(Oh)
		)	
		
	,

		xscale(noline )
		yscale(noline )
		title("", color(black) size(medsmall) pos(11) ) 
		xlab( 1950(5)1975 , 
			labsize(medium) ) 
		ylab( 0(.2)1 , 
			angle(hori) labsize(medium) nogrid  )
		xtitle("Year" , 
			color(black) size(medium) )
		ytitle("Congressional Turnout as a % of the Voting Age Pop.", 
			color(black) size(medium)  )
		graphregion( fcolor(white) lcolor(white) ) 
		plotregion( fcolor(white) lstyle(none) lcolor(white) ilstyle(none)) 
		legend( 
			order(2 "Covered Counties" 6 "Uncovered Counties" )
			pos(11)
			ring(0)
			cols(1)
			region( color(none) )
			size(medium)	
		)
		
		
		 ;
		 
#delimit cr




	* export the graph
	*-----------------

	cd "${directory_output}"
	graph export "DinD_5_Turnout_C.pdf", replace
	

	
	
	


			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* plot 5 (appendix F2):  democratic vote share
*-------------------------------------------------------------------------------


* locals
*-------

capture drop vshare_p_dem_mean 
bysort covered year: egen vshare_p_dem_mean = mean(vshare_p_dem)

local outcome 	= "vshare_p_dem_mean"
local tag 		= "tag_cov_yr_pres == 1" 



	
	
* plot
*-----


#delimit ;


twoway 
	
		// covered
	( line  `outcome' year	 	
		
		if `tag'  & year < 1965 & covered == 1
		, 	lcolor(black) lwidth(medthick) 
			xline(1965, lcolor(gs8) )
		)
	
	( line  `outcome' year	 	
		
		if `tag'  & year >= 1965 & covered == 1
		, 	lcolor(black) lwidth(medthick) 
		)
	( scatter  `outcome' year	 	
		
		if `tag'  & year < 1965 & covered == 1
		, 	mcolor(black) msize(medium) 
			xline(1965, lcolor(gs8) )
		)
	
	( scatter  `outcome' year	 	
		
		if `tag'  & year >= 1965 & covered == 1
		, 	mcolor(black) msize(medium)  
		)
		
			// not-covered
	( line  `outcome' year	 	
		
		if `tag'  & year < 1965 & covered == 0
		, 	lcolor(gs7) lwidth(medthick) lpattern(dash)
		)
	
	( line  `outcome' year	 	
		
		if `tag'  & year >= 1965 & covered == 0
		, 	lcolor(gs7) lwidth(medthick) lpattern(dash)
		)	
	( scatter  `outcome' year	 	
		
		if `tag'  & year < 1965 & covered == 0
		, 	mcolor(gs7) msize(medium) msymbol(Oh)
		)
	
	( scatter  `outcome' year	 	
		
		if `tag'  & year >= 1965 & covered == 0
		, 	mcolor(gs7) msize(medium) msymbol(Oh)
		)	
		

	,

		xscale(noline )
		yscale(noline )
		title("", color(black) size(medium) pos(11) ) 
		xlab( 1950(5)1995 , 
			labsize(medium) ) 
		ylab( 0(.2)1 , 
			angle(hori) labsize(medium) nogrid  )
		xtitle("Year" , 
			color(black) size(medium) )
		ytitle("Democratic Presidential Vote Share", 
			color(black) size(medium)  )
		graphregion( fcolor(white) lcolor(white) ) 
		plotregion( fcolor(white) lstyle(none) lcolor(white) ilstyle(none)) 
		legend( 
			order(2 "Covered Counties" 6 "Uncovered Counties" )
			pos(2)
			ring(0)
			cols(1)
			region( color(none) )
			size(medium)	
		)
		
		
		 ;
		 
#delimit cr




	* export the graph
	*-----------------

	cd "${directory_output}"
	graph export "DinD_6_DemVShare.pdf", replace
	

	


			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* plot 6 (appendix F2):  democratic vote share governor
*-------------------------------------------------------------------------------


* locals
*-------

capture drop vshare_p_dem_gov_mean 
bysort covered year: egen vshare_p_dem_gov_mean = mean(vshare_p_dem_gov)

local outcome 	= "vshare_p_dem_gov_mean"
local tag 		= "tag_cov_yr_pres == 1" 




	
* plot
*-----


#delimit ;


twoway 
	
		// covered
	( line  `outcome' year	 	
		
		if `tag'  & year < 1965 & covered == 1
		, 	lcolor(black) lwidth(medthick) 
			xline(1965, lcolor(gs8) )
		)
	
	( line  `outcome' year	 	
		
		if `tag'  & year >= 1965 & covered == 1
		, 	lcolor(black) lwidth(medthick) 
		)
	( scatter  `outcome' year	 	
		
		if `tag'  & year < 1965 & covered == 1
		, 	mcolor(black) msize(medium) 
			xline(1965, lcolor(gs8) )
		)
	
	( scatter  `outcome' year	 	
		
		if `tag'  & year >= 1965 & covered == 1
		, 	mcolor(black) msize(medium)  
		)
		
			// not-covered
	( line  `outcome' year	 	
		
		if `tag'  & year < 1965 & covered == 0
		, 	lcolor(gs7) lwidth(medthick) lpattern(dash)
		)
	
	( line  `outcome' year	 	
		
		if `tag'  & year >= 1965 & covered == 0
		, 	lcolor(gs7) lwidth(medthick) lpattern(dash)
		)	
	( scatter  `outcome' year	 	
		
		if `tag'  & year < 1965 & covered == 0
		, 	mcolor(gs7) msize(medium) msymbol(Oh)
		)
	
	( scatter  `outcome' year	 	
		
		if `tag'  & year >= 1965 & covered == 0
		, 	mcolor(gs7) msize(medium) msymbol(Oh)
		)	
		

	,

		xscale(noline )
		yscale(noline )
		title("", color(black) size(medium) pos(11) ) 
		xlab( 1950(5)1995 , 
			labsize(medium) ) 
		ylab( 0(.2)1 , 
			angle(hori) labsize(medium) nogrid  )
		xtitle("Year" , 
			color(black) size(medium) )
		ytitle("Democratic Gubernatorial Vote Share", 
			color(black) size(medium)  )
		graphregion( fcolor(white) lcolor(white) ) 
		plotregion( fcolor(white) lstyle(none) lcolor(white) ilstyle(none)) 
		legend( 
			order(2 "Covered Counties" 6 "Uncovered Counties" )
			pos(2)
			ring(0)
			cols(1)
			region( color(none) )
			size(medium)	
		)
		
		
		 ;
		 
#delimit cr



	* export the graph
	*-----------------

	cd "${directory_output}"
	graph export "DinD_7_DemVShareGov.pdf", replace
	
	
	
	
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* globals for local estimations and plots
*-------------------------------------------------------------------------------

* globals
*--------

global absorb 	= "county_id"
global fe		= "i.year"


	

			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* local plot (appendix D1): black registration
*-------------------------------------------------------------------------------


* preserve
*---------

preserve



* temporary file
*---------------

tempname memhold
tempfile results
postfile `memhold' beta se window number using `results'  





* loop
*-----

forvalues window = .1(.01).50 {  

	// display
	display " Window size: `window'"
	
	
		// locals
		local tag = "tag_vreg_bnw"
		local outcome = "p_vreg_bnw"
		
		local upper = .50 + `window'
		local lower = .50 - `window'
	
	
	// generate variables
	gen bwidth = 1  if vote_perc_va1 >= `lower' & vote_perc_va1 <= `upper'

	
	
		// regression
		areg `outcome'  ${fe} post_x_covered ${controls1}  ///
				if `tag' == 1 & bwidth == 1, absorb(${absorb}) vce(cl county_id)
		
		sum `outcome' if `tag' == 1 & bwidth == 1 & year == 1970
		post `memhold' (_b[post_x_covered]) (_se[post_x_covered]) (`window') (`r(N)')
	

	// drop
	capture drop  bwidth

}





* post the data
*--------------

postclose `memhold'
use `results', clear




* confidence intervals
*---------------------

gen sortid = _n
gen cihi = beta + 1.96*se
gen cilo = beta - 1.96*se




* plot
*-----


#delimit;

twoway 

	( line cihi window
		, 	lpattern(dot) lcolor(black) lwidth(medthick) yaxis(1)
		)
	
	( line cilo window
		, 	lpattern(dot) lcolor(black) lwidth(medthick) yaxis(1)
		)
	
	( line beta window
		, 	lcolor(black) lwidth(medthick) yaxis(1)
			yline(0 , axis(1) lpattern(dot) lcolor(gs5) lwidth(medthick) ) //, lpattern(dot) lcolor(gs9) lwidth(medthick)
		)

	( line number window
		, 	lcolor(gs10) lwidth(medium)
			yaxis(2)
		)
		

		,

		ylabel( ,
			nogrid angle(hori) labsize(small) axis(1) )
		ylabel( ,
			nogrid angle(hori) labsize(small) axis(2) )
			
		xlabel(  ,
			labsize(small) tlength(0) )
		xtitle("Bandwidth on Each Side of the 50% Threshold for Coverage",
			color(black) size(medsmall))
		xscale(noline)
		yscale(noline axis(1) )
		yscale(noline axis(2) )
		graphregion(fcolor(white) lcolor(white) ) 	
		plotregion(fcolor(white) lstyle(none) lcolor(white) ilstyle(none))
		title("  ", 
			color(black) size(medsmall) pos(11) )  
		subtitle("",
			color(black) justification(center))
		ytitle("Difference in Differences Estimate",
			angle(hori)	color(black) size(medsmall) axis(1) )
		ytitle("Number of Counties",
			angle(hori)	color(black) size(medsmall) axis(2) )
		legend(
			order(
				3 "Point Estimates"
				2 "95% Confidence Intervals"
				4 "Number of Counties"
					)
			cols(1)
			pos(11)
			ring(0)
			region( color(none) )
			size(small)
			
		)

;

#delimit cr


	* export the graph
	*-----------------

	cd "${directory_output}"
	graph export LATE_Registration_black.pdf, replace



* restore
*--------

restore




			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* local plot (appendix D1): white registration
*-------------------------------------------------------------------------------


* preserve
*---------

preserve



* temporary file
*---------------

tempname memhold
tempfile results
postfile `memhold' beta se window number using `results'  





* loop
*-----

forvalues window = .1(.01).50 {  

	// display
	display " Window size: `window'"
	
	
		// locals
		local tag = "tag_vreg_bnw"
		local outcome = "p_vreg_w"
		
		local upper = .50 + `window'
		local lower = .50 - `window'
	
	
	// generate variables
	gen bwidth = 1  if vote_perc_va1 >= `lower' & vote_perc_va1 <= `upper'

	
	
		// regression
		areg `outcome'  ${fe} post_x_covered ${controls1}  ///
				if `tag' == 1 & bwidth == 1, absorb(${absorb}) vce(cl county_id)
		
		sum `outcome' if `tag' == 1 & bwidth == 1 & year == 1970
		post `memhold' (_b[post_x_covered]) (_se[post_x_covered]) (`window') (`r(N)')
	

	// drop
	capture drop  bwidth

}





* post the data
*--------------

postclose `memhold'
use `results', clear




* confidence intervals
*---------------------

gen sortid = _n
gen cihi = beta + 1.96*se
gen cilo = beta - 1.96*se




* plot
*-----


#delimit;

twoway 

	( line cihi window
		, 	lpattern(dot) lcolor(black) lwidth(medthick) yaxis(1)
		)
	
	( line cilo window
		, 	lpattern(dot) lcolor(black) lwidth(medthick) yaxis(1)
		)
	
	( line beta window
		, 	lcolor(black) lwidth(medthick) yaxis(1)
			yline(0 , axis(1) lpattern(dot) lcolor(gs5) lwidth(medthick) ) //, lpattern(dot) lcolor(gs9) lwidth(medthick)
		)

	( line number window
		, 	lcolor(gs10) lwidth(medium)
			yaxis(2)
		)
		

		,

		ylabel( ,
			nogrid angle(hori) labsize(small) axis(1) )
		ylabel( ,
			nogrid angle(hori) labsize(small) axis(2) )
			
		xlabel(  ,
			labsize(small) tlength(0) )
		xtitle("Bandwidth on Each Side of the 50% Threshold for Coverage",
			color(black) size(medsmall))
		xscale(noline)
		yscale(noline axis(1) )
		yscale(noline axis(2) )
		graphregion(fcolor(white) lcolor(white) ) 	
		plotregion(fcolor(white) lstyle(none) lcolor(white) ilstyle(none))
		title("  ", 
			color(black) size(medsmall) pos(11) )  
		subtitle("",
			color(black) justification(center))
		ytitle("Difference in Differences Estimate",
			angle(hori)	color(black) size(medsmall) axis(1) )
		ytitle("Number of Counties",
			angle(hori)	color(black) size(medsmall) axis(2) )
		legend(
			order(
				3 "Point Estimates"
				2 "95% Confidence Intervals"
				4 "Number of Counties"
					)
			cols(1)
			pos(11)
			ring(0)
			region( color(none) )
			size(small)
			
		)

;

#delimit cr


	* export the graph
	*-----------------

	cd "${directory_output}"
	graph export LATE_Registration_white.pdf, replace



* restore
*--------

restore





			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* local plot (appendix D1): gap in registration
*-------------------------------------------------------------------------------


* preserve
*---------

preserve



* temporary file
*---------------

tempname memhold
tempfile results
postfile `memhold' beta se window number using `results'  




* loop
*-----

forvalues window = .1(.01).50 {  

	// display
	display " Window size: `window'"
	
	
		// locals
		local tag = "tag_vreg_bnw"
		local outcome = "gap_bw_vreg"
		
		local upper = .50 + `window'
		local lower = .50 - `window'
	
	
	// generate variables
	gen bwidth = 1  if vote_perc_va1 >= `lower' & vote_perc_va1 <= `upper'

	
	
		// regression
		areg `outcome'  ${fe} post_x_covered ${controls1}  ///
				if `tag' == 1 & bwidth == 1, absorb(${absorb}) vce(cl county_id)
		
		sum `outcome' if `tag' == 1 & bwidth == 1 & year == 1970
		post `memhold' (_b[post_x_covered]) (_se[post_x_covered]) (`window') (`r(N)')
	

	// drop
	capture drop  bwidth

}



* post the data
*--------------

postclose `memhold'
use `results', clear




* confidence intervals
*---------------------

gen sortid = _n
gen cihi = beta + 1.96*se
gen cilo = beta - 1.96*se




* plot
*-----


#delimit;

twoway 

	( line cihi window
		, 	lpattern(dot) lcolor(black) lwidth(medthick) yaxis(1)
		)
	
	( line cilo window
		, 	lpattern(dot) lcolor(black) lwidth(medthick) yaxis(1)
		)
	
	( line beta window
		, 	lcolor(black) lwidth(medthick) yaxis(1)
			yline(0 , axis(1) lpattern(dot) lcolor(gs5) lwidth(medthick) ) //, lpattern(dot) lcolor(gs9) lwidth(medthick)
		)

	( line number window
		, 	lcolor(gs10) lwidth(medium)
			yaxis(2)
		)
		

		,

		ylabel( ,
			nogrid angle(hori) labsize(small) axis(1) )
		ylabel( ,
			nogrid angle(hori) labsize(small) axis(2) )
			
		xlabel(  ,
			labsize(small) tlength(0) )
		xtitle("Bandwidth on Each Side of the 50% Threshold for Coverage",
			color(black) size(medsmall))
		xscale(noline)
		yscale(noline axis(1) )
		yscale(noline axis(2) )
		graphregion(fcolor(white) lcolor(white) ) 	
		plotregion(fcolor(white) lstyle(none) lcolor(white) ilstyle(none))
		title("  ", 
			color(black) size(medsmall) pos(11) )  
		subtitle("",
			color(black) justification(center))
		ytitle("Difference in Differences Estimate",
			angle(hori)	color(black) size(medsmall) axis(1) )
		ytitle("Number of Counties",
			angle(hori)	color(black) size(medsmall) axis(2) )
		legend(
			order(
				3 "Point Estimates"
				2 "95% Confidence Intervals"
				4 "Number of Counties"
					)
			cols(1)
			pos(11)
			ring(0)
			region( color(none) )
			size(small)
			
		)

;

#delimit cr




	* export the graph
	*-----------------

	cd "${directory_output}"
	graph export LATE_Gap.pdf, replace



* restore
*--------

restore




			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* local plot (appendix D2): presidential turnout
*-------------------------------------------------------------------------------


* preserve
*---------

preserve



* temporary file
*---------------

tempname memhold
tempfile results
postfile `memhold' beta se window number using `results'  





* loop
*-----

forvalues window = .1(.01).50 {  

	// display
	display " Window size: `window'"
	
	
		// locals
		local tag = "tag_turnout_p"
		local outcome = "v_turnout_p"
		
		local upper = .50 + `window'
		local lower = .50 - `window'
	
	
	// generate variables
	gen bwidth = 1  if vote_perc_va1 >= `lower' & vote_perc_va1 <= `upper'

	
	
		// regression
		areg `outcome'  ${fe} post_x_covered ${controls1}  ///
				if `tag' == 1 & bwidth == 1, absorb(${absorb}) vce(cl county_id)
		
		sum `outcome' if `tag' == 1 & bwidth == 1 & year == 1964
		post `memhold' (_b[post_x_covered]) (_se[post_x_covered]) (`window') (`r(N)')
	

	// drop
	capture drop  bwidth

}





* post the data
*--------------

postclose `memhold'
use `results', clear




* confidence intervals
*---------------------

gen sortid = _n
gen cihi = beta + 1.96*se
gen cilo = beta - 1.96*se




* plot
*-----


#delimit;

twoway 

	( line cihi window
		, 	lpattern(dot) lcolor(black) lwidth(medthick) yaxis(1)
		)
	
	( line cilo window
		, 	lpattern(dot) lcolor(black) lwidth(medthick) yaxis(1)
		)
	
	( line beta window
		, 	lcolor(black) lwidth(medthick) yaxis(1)
			yline(0 , axis(1) lpattern(dot) lcolor(gs5) lwidth(medthick) ) //, lpattern(dot) lcolor(gs9) lwidth(medthick)
		)

	( line number window
		, 	lcolor(gs10) lwidth(medium)
			yaxis(2)
		)
		

		,

		ylabel( -0.05(0.05).2,
			nogrid angle(hori) labsize(small) axis(1) )
		ylabel( ,
			nogrid angle(hori) labsize(small) axis(2) )
			
		xlabel(  ,
			labsize(small) tlength(0) )
		xtitle("Bandwidth on Each Side of the 50% Threshold for Coverage",
			color(black) size(medsmall))
		xscale(noline)
		yscale(noline axis(1) )
		yscale(noline axis(2) )
		graphregion(fcolor(white) lcolor(white) ) 	
		plotregion(fcolor(white) lstyle(none) lcolor(white) ilstyle(none))
		title("  ", 
			color(black) size(medsmall) pos(11) )  
		subtitle("",
			color(black) justification(center))
		ytitle("Difference in Differences Estimate",
			angle(hori)	color(black) size(medsmall) axis(1) )
		ytitle("Number of Counties",
			angle(hori)	color(black) size(medsmall) axis(2) )
		legend(
			order(
				3 "Point Estimates"
				2 "95% Confidence Intervals"
				4 "Number of Counties"
					)
			cols(1)
			pos(11)
			ring(0)
			region( color(none) )
			size(small)
			
		)

;

#delimit cr




	* export the graph
	*-----------------

	cd "${directory_output}"
	graph export LATE_Turnout_P.pdf, replace



* restore
*--------

restore
	

			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* local plot (appendix D2): congressional turnout
*-------------------------------------------------------------------------------


* preserve
*---------

preserve



* temporary file
*---------------

tempname memhold
tempfile results
postfile `memhold' beta se window number using `results'  



* loop
*-----

forvalues window = .1(.01).50 {  

	// display
	display " Window size: `window'"
	
	
		// locals
		local tag = "tag_turnout_c"
		local outcome = "v_turnout_c"
		
		local upper = .50 + `window'
		local lower = .50 - `window'
	
	
	// generate variables
	gen bwidth = 1  if vote_perc_va1 >= `lower' & vote_perc_va1 <= `upper'

	
	
		// regression
		areg `outcome'  ${fe} post_x_covered ${controls1}  ///
				if `tag' == 1 & bwidth == 1, absorb(${absorb}) vce(cl county_id)
		
		sum `outcome' if `tag' == 1 & bwidth == 1 & year == 1964
		post `memhold' (_b[post_x_covered]) (_se[post_x_covered]) (`window') (`r(N)')
	

	// drop
	capture drop  bwidth

}





* post the data
*--------------

postclose `memhold'
use `results', clear




* confidence intervals
*---------------------

gen sortid = _n
gen cihi = beta + 1.96*se
gen cilo = beta - 1.96*se




* plot
*-----


#delimit;

twoway 

	( line cihi window
		, 	lpattern(dot) lcolor(black) lwidth(medthick) yaxis(1)
		)
	
	( line cilo window
		, 	lpattern(dot) lcolor(black) lwidth(medthick) yaxis(1)
		)
	
	( line beta window
		, 	lcolor(black) lwidth(medthick) yaxis(1)
			yline(0 , axis(1) lpattern(dot) lcolor(gs5) lwidth(medthick) ) //, lpattern(dot) lcolor(gs9) lwidth(medthick)
		)

	( line number window
		, 	lcolor(gs10) lwidth(medium)
			yaxis(2)
		)
		

		,

		ylabel( -0.05(.05).2,
			nogrid angle(hori) labsize(small) axis(1) )
		ylabel( ,
			nogrid angle(hori) labsize(small) axis(2) )
			
		xlabel(  ,
			labsize(small) tlength(0) )
		xtitle("Bandwidth on Each Side of the 50% Threshold for Coverage",
			color(black) size(medsmall))
		xscale(noline)
		yscale(noline axis(1) )
		yscale(noline axis(2) )
		graphregion(fcolor(white) lcolor(white) ) 	
		plotregion(fcolor(white) lstyle(none) lcolor(white) ilstyle(none))
		title("  ", 
			color(black) size(medsmall) pos(11) )  
		subtitle("",
			color(black) justification(center))
		ytitle("Difference in Differences Estimate",
			angle(hori)	color(black) size(medsmall) axis(1) )
		ytitle("Number of Counties",
			angle(hori)	color(black) size(medsmall) axis(2) )
		legend(
			order(
				3 "Point Estimates"
				2 "95% Confidence Intervals"
				4 "Number of Counties"
					)
			cols(1)
			pos(11)
			ring(0)
			region( color(none) )
			size(small)
			
		)

;

#delimit cr


	* export the graph
	*-----------------

	cd "${directory_output}"
	graph export LATE_Turnout_C.pdf, replace



* restore
*--------

restore



			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* local plot (appendix D2): democratic vote share
*-------------------------------------------------------------------------------


* preserve
*---------

preserve



* temporary file
*---------------

tempname memhold
tempfile results
postfile `memhold' beta se window number using `results'  



* loop
*-----

forvalues window = .1(.01).50 {  

	// display
	display " Window size: `window'"
	
	
		// locals
		local tag = "tag_turnout_p"
		local outcome = "vshare_p_dem"
		
		local upper = .50 + `window'
		local lower = .50 - `window'
	
	
	// generate variables
	gen bwidth = 1  if vote_perc_va1 >= `lower' & vote_perc_va1 <= `upper'

	
	
		// regression
		areg `outcome'  ${fe} post_x_covered ${controls1}  ///
				if `tag' == 1 & bwidth == 1, absorb(${absorb}) vce(cl county_id)
		
		sum `outcome' if `tag' == 1 & bwidth == 1 & year == 1964
		post `memhold' (_b[post_x_covered]) (_se[post_x_covered]) (`window') (`r(N)')
	

	// drop
	capture drop  bwidth

}



* post the data
*--------------

postclose `memhold'
use `results', clear




* confidence intervals
*---------------------

gen sortid = _n
gen cihi = beta + 1.96*se
gen cilo = beta - 1.96*se




* plot
*-----


#delimit;

twoway 

	( line cihi window
		, 	lpattern(dot) lcolor(black) lwidth(medthick) yaxis(1)
		)
	
	( line cilo window
		, 	lpattern(dot) lcolor(black) lwidth(medthick) yaxis(1)
		)
	
	( line beta window
		, 	lcolor(black) lwidth(medthick) yaxis(1)
			yline(0 , axis(1) lpattern(dot) lcolor(gs5) lwidth(medthick) ) //, lpattern(dot) lcolor(gs9) lwidth(medthick)
		)

	( line number window
		, 	lcolor(gs10) lwidth(medium)
			yaxis(2)
		)
		

		,

		ylabel( ,
			nogrid angle(hori) labsize(small) axis(1) )
		ylabel( ,
			nogrid angle(hori) labsize(small) axis(2) )
			
		xlabel(  ,
			labsize(small) tlength(0) )
		xtitle("Bandwidth on Each Side of the 50% Threshold for Coverage",
			color(black) size(medsmall))
		xscale(noline)
		yscale(noline axis(1) )
		yscale(noline axis(2) )
		graphregion(fcolor(white) lcolor(white) ) 	
		plotregion(fcolor(white) lstyle(none) lcolor(white) ilstyle(none))
		title("  ", 
			color(black) size(medsmall) pos(11) )  
		subtitle("",
			color(black) justification(center))
		ytitle("Difference in Differences Estimate",
			angle(hori)	color(black) size(medsmall) axis(1) )
		ytitle("Number of Counties",
			angle(hori)	color(black) size(medsmall) axis(2) )
		legend(
			order(
				3 "Point Estimates"
				2 "95% Confidence Intervals"
				4 "Number of Counties"
					)
			cols(1)
			pos(11)
			ring(0)
			region( color(none) )
			size(small)
			
		)

;

#delimit cr



	* export the graph
	*-----------------

	cd "${directory_output}"
	graph export LATE_Democrat.pdf, replace



* restore
*--------

restore
	
	


			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* local plot (appendix D2): democratic vote share
*-------------------------------------------------------------------------------


* preserve
*---------

preserve



* temporary file
*---------------

tempname memhold
tempfile results
postfile `memhold' beta se window number using `results'  



* loop
*-----

forvalues window = .1(.01).50 {  

	// display
	display " Window size: `window'"
	
	
		// locals
		local tag = "tag_turnout_p"
		local outcome = "vshare_p_dem_gov"
		
		local upper = .50 + `window'
		local lower = .50 - `window'
	
	
	// generate variables
	gen bwidth = 1  if vote_perc_va1 >= `lower' & vote_perc_va1 <= `upper'

	
	
		// regression
		areg `outcome'  ${fe} post_x_covered ${controls1}  ///
				if `tag' == 1 & bwidth == 1, absorb(${absorb}) vce(cl county_id)
		
		sum `outcome' if `tag' == 1 & bwidth == 1 & year == 1964
		post `memhold' (_b[post_x_covered]) (_se[post_x_covered]) (`window') (`r(N)')
	

	// drop
	capture drop  bwidth

}



* post the data
*--------------

postclose `memhold'
use `results', clear




* confidence intervals
*---------------------

gen sortid = _n
gen cihi = beta + 1.96*se
gen cilo = beta - 1.96*se




* plot
*-----


#delimit;

twoway 

	( line cihi window
		, 	lpattern(dot) lcolor(black) lwidth(medthick) yaxis(1)
		)
	
	( line cilo window
		, 	lpattern(dot) lcolor(black) lwidth(medthick) yaxis(1)
		)
	
	( line beta window
		, 	lcolor(black) lwidth(medthick) yaxis(1)
		)

	( line number window
		, 	lcolor(gs10) lwidth(medium)
			yaxis(2)
		)
		

		,

		ylabel( ,
			nogrid angle(hori) labsize(small) axis(1) )
		ylabel( ,
			nogrid angle(hori) labsize(small) axis(2) )
			
		xlabel(  ,
			labsize(small) tlength(0) )
		xtitle("Bandwidth on Each Side of the 50% Threshold for Coverage",
			color(black) size(medsmall))
		xscale(noline)
		yscale(noline axis(1) )
		yscale(noline axis(2) )
		graphregion(fcolor(white) lcolor(white) ) 	
		plotregion(fcolor(white) lstyle(none) lcolor(white) ilstyle(none))
		title("  ", 
			color(black) size(medsmall) pos(11) )  
		subtitle("",
			color(black) justification(center))
		ytitle("Difference in Differences Estimate",
			angle(hori)	color(black) size(medsmall) axis(1) )
		ytitle("Number of Counties",
			angle(hori)	color(black) size(medsmall) axis(2) )
		legend(
			order(
				3 "Point Estimates"
				2 "95% Confidence Intervals"
				4 "Number of Counties"
					)
			cols(1)
			pos(11)
			ring(0)
			region( color(none) )
			size(small)
			
		)

;

#delimit cr



	* export the graph
	*-----------------

	cd "${directory_output}"
	graph export LATE_Democrat_2.pdf, replace



* restore
*--------

restore
	
	
	
	
			
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* prepare the appendix migration simulation
*-------------------------------------------------------------------------------


* preliminaries
*--------------

clear
set more off



* cd
*---

cd "${directory}"
use VRA_JOP_Replication.dta, clear




* voting reg simulation variables
*--------------------------------
	
gen p_vreg_bnw_fs 		= p_vreg_bnw
gen vreg_bnw_fs 		= vreg_bnw

gen pop_va_bnw_fs		= pop_b_va_i				if  tag_vreg_bnw == 1 & (year >= 1970)
replace pop_va_bnw_fs 	= vreg_bnw / p_vreg_bnw		if  tag_vreg_bnw == 1 & pop_va_bnw_fs == .


label var vreg_bnw_fs 	"black/non-white registration for simulation (USE)"
label var pop_va_bnw_fs	"black/non-white voting age population for simulation (USE)"



* alternative coverage variable
*------------------------------

capture drop covered2

gen covered2 = covered 	if year == 1980
sort county covered2
replace covered2 = covered2[_n-1] 	if county[_n] == county[_n-1] & covered2[_n] == . & covered2[_n-1] != .

assert covered2 != .



* tag county
*-----------

capture drop tag_ct
egen tag_ct = tag(county)
label var tag_ct "=1 for one obsv of each county; =0 otherwise"





			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* simulation 1 (appendix): uniform (geography and post-period) simulation
*-------------------------------------------------------------------------------


* preserve
*---------

preserve



* temporary file
*---------------

tempname memhold
tempfile results
postfile `memhold' beta se perc_migration total_migrants   using `results' 



* globals
*--------

global pvr		= "p_vreg_bnw_fs" 
global bvr		= "vreg_bnw_fs"
global tag		= "tag_vreg_bnw == 1"
global pbva		= "pop_va_bnw_fs"
global pop		= "pop_t_i"
global bpop		= "pop_b_i"
global bpopp	= "pop_b_i_perc"



* first one
*----------

local x = 0

global d_in_d 		= "post_x_covered"
global controls1 	= "pop_t_i_ln  inc_hh_med_i  pop_b_i_perc"
		

	
			

* loop
*-----

forvalues x =  0(.01).1 {


		* general variables for simulation change
		*----------------------------------------
		
		gen migrants = ${bvr} * `x'					if covered == 1
		
		
		bysort year: egen 	total_migrants 			= total(migrants)			if covered == 1  	// total migrants leaving covered
		sort year migrants
		replace total_migrants 						= total_migrants[_n-1]   	if total_migrants[_n] == . & total_migrants[_n-1] != . & year[_n] == year[_n-1]

		sum 	total_migrants
		local   tm = `r(mean)'
		
		
		// share of each county in total black registrants and total black population
		bysort 	covered year: egen total_b 			= total(${bpop})
		gen 	perc_b								= ${bpop} / total_b
		
		bysort 	covered year: egen total_bvreg		= total(${bvr})		
		gen 	perc_bvreg 							= ${bvr} / total_bvreg		// percentage of registrants by covered and year
		
	
		
		// where to the migrants go to
		replace migrants = total_migrants / 60		if covered == 0
		
		if `x' == .02 {
		
			cd "${directory_output}"
			capture file close myfile
			file open myfile using "migrants.tex", write replace
			file write myfile %7.0f (`tm')
			file close myfile
			
	
		}
		
		if `x' == 0 {
		
			assert migrants == 0 | migrants == .
			
		}
			
		
		* generate new variables for outcome
		*-----------------------------------

		gen 	vreg_bnw_sim 		= ${bvr} - migrants 		if covered == 1	& year > 1965 & ${tag}		// subtract migrants from covered counties
		replace vreg_bnw_sim 		= ${bvr} + migrants			if covered == 0 & year > 1965 & ${tag}		// add migrants to uncovered counties
				
		gen 	pop_b_va_i_sim 		= ${pbva} - migrants		if covered == 1	& year > 1965 & ${tag}		// subtract migrants from population in covered counties		
		replace pop_b_va_i_sim 		= ${pbva} + migrants		if covered == 0	& year > 1965 & ${tag}		// add migrats to population counties
		
		gen 	p_vreg_b_i_sim		= vreg_bnw_sim / pop_b_va_i_sim		if  ${tag}								// recalculate voter registration
		replace p_vreg_b_i_sim		= ${pvr} 							if  ${tag} & p_vreg_b_i_sim == .
	
		
		
		* generate new variables for controls
		*------------------------------------
		
		gen		pop_t_i_sim   	= ${pop} - migrants			if covered == 1	& year > 1965
		replace pop_t_i_sim   	= ${pop} + migrants			if covered == 0	& year > 1965
		replace pop_t_i_sim		= ${pop}					if pop_t_i_sim == .
				
		gen 	pop_t_i_ln_sim 	= ln(pop_t_i_sim) 
		
		gen 	pop_b_i_sim 	= ${bpop} - migrants		if covered == 1	& year > 1965
		replace	pop_b_i_sim 	= ${bpop} + migrants		if covered == 0	& year > 1965
		replace pop_b_i_sim		= ${bpop}					if pop_b_i_sim == .
		
		gen		pop_b_perc_sim  = pop_b_i_sim / pop_t_i_sim

		
		
		* estimation globals
		*-------------------
		
		global dv1 			= "p_vreg_b_i_sim"
		global d_in_d 		= "post_x_covered"
		global controls1 	= "pop_t_i_ln_sim  inc_hh_med_i  pop_b_perc_sim"
		
		if `x' == 0 {
		
			display "1"
			assert pop_t_i_sim == ${pop}
			
			display "2"
			assert pop_b_i_sim == ${bpop}
			
			display "3"
			assert pop_b_perc_sim == ${bpopp}
			
			display "4"
			assert pop_t_i_ln_sim == pop_t_i_ln
			
			display "5"
			assert (${dv1} >= p_vreg_bnw - .001) & (${dv1} <= p_vreg_bnw + .001)
			
			
		}
		
		
		* estimation
		*-----------
		
		display "total: `tm'"
		areg 	${dv1} ${d_in_d} ${controls1} i.year 	if ${tag}, absorb(county_id) vce(cl county_id) 
		post 	`memhold' (_b[${d_in_d}]) (_se[${d_in_d}]) (`x') (`tm')
		
		
		* drop
		*-----
		
		drop 			p_vreg_b_i_sim  vreg_bnw_sim  pop_b_va_i_sim  pop_b_va_i_sim
		drop 			pop_t_i_sim  pop_t_i_ln_sim  pop_b_i_sim  pop_b_perc_sim
		drop 			total_migrants perc_bvreg perc_b total_bvreg total_b
		capture drop 	migrants_p migrants_r
		capture drop 	migrants perc
		capture drop 	migrants

}




* post the data
*--------------

postclose `memhold'
use `results', clear




* confidence intervals
*---------------------

gen sortid 	= _n
gen cihi 	= beta + 1.96*se
gen cilo 	= beta - 1.96*se
gen cihi2 	= beta + 1.645*se
gen cilo2 	= beta - 1.645*se



* plot
*-----


#delimit;

twoway 

	( rcap cihi cilo perc_migration if sortid != 1
			, lwidth(medthin) color(black) msize(tiny) yaxis(1)
			) 
	( rcap cihi2 cilo2 perc_migration if sortid != 1
			, lwidth(thick) color(black) msize(vtiny) yaxis(1)
			) 
	
	( scatter beta perc_migration if sortid != 1
		, 	mcolor(black) msize(medium)
			yline(0 , axis(1) lpattern(dot) lcolor(gs5) lwidth(medthick) )  yaxis(1)
		)
	( rcap cihi cilo perc_migration if sortid == 1
			, lwidth(medthin) color(gs9) msize(tiny) yaxis(1)
			) 
	( rcap cihi2 cilo2 perc_migration if sortid == 1
			, lwidth(thick) color(gs9) msize(vtiny)  yaxis(1)
			) 
	
	( scatter beta perc_migration if sortid == 1
		, 	mcolor(gs9) msize(medium) msymbol(Oh)
			  yaxis(1)
			)
	( line total_migrants perc_migration
		, 	lcolor(gs10) lwidth(medium)
			yaxis(2) yline(2000, axis(2) lpattern(dot) lcolor(gs5) lwidth(medthick) )
		)

		,
		ylabel( ,
			nogrid angle(hori) labsize(small) axis(1) )
		ylabel( ,
			nogrid angle(hori) labsize(small) axis(2) )	
		xlabel(  ,
			labsize(small) tlength(1) )
		xtitle("Percentage of Black Migrants Arriving to Covered Counties",
			color(black) size(medsmall))
		xscale(noline)
		yscale(noline axis(1))
		yscale(noline axis(2))
		graphregion(fcolor(white) lcolor(white) ) 	
		plotregion(fcolor(white) lstyle(none) lcolor(white) ilstyle(none))
		title("  ", 
			color(black) size(medsmall) pos(11) )  
		subtitle("",
			color(black) justification(center))
		ytitle("Difference in Differences Estimate",
			angle(hori)	color(black) size(medsmall) axis(1) )
		ytitle("Total number of migrants",
			angle(hori)	color(black) size(medsmall) axis(2) )
		legend(
			off
			
		)

;

#delimit cr


	* export the graph
	*-----------------

	cd "${directory_output}"
	graph export Simulation_Black_1.pdf, replace





* restore
*--------

restore






			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* simulation 2 (appendix): send according to black population (geography and post-period) simulation
*-------------------------------------------------------------------------------


* preserve
*---------

preserve



* temporary file
*---------------

tempname memhold
tempfile results
postfile `memhold' beta se perc_migration total_migrants   using `results' 



* globals
*--------

global pvr		= "p_vreg_bnw_fs"
global bvr		= "vreg_bnw_fs"
global tag		= "tag_vreg_bnw == 1"
global pbva		= "pop_va_bnw_fs"
global pop		= "pop_t_i"
global bpop		= "pop_b_i"
global bpopp	= "pop_b_i_perc"



* first one
*----------

local x = 0
global d_in_d 		= "post_x_covered"
global controls1 	= "pop_t_i_ln  inc_hh_med_i  pop_b_i_perc"
		
		
		
			

* loop
*-----

forvalues x =  0(.01).1 {


		* general variables for simulation change
		*----------------------------------------
		
		gen migrants = ${bvr} * `x'					if covered == 1
		
		
		bysort year: egen 	total_migrants 			= total(migrants)			if covered == 1  	// total migrants leaving covered
		sort year migrants
		replace total_migrants 						= total_migrants[_n-1]   	if total_migrants[_n] == . & total_migrants[_n-1] != . & year[_n] == year[_n-1]

		sum 	total_migrants
		local   tm = `r(mean)'
		
		
		// share of each county in total black registrants and total black population
		bysort 	covered year: egen total_b 			= total(${bpop})
		gen 	perc_b								= ${bpop} / total_b
		
		bysort 	covered year: egen total_bvreg		= total(${bvr})		
		gen 	perc_bvreg 							= ${bvr} / total_bvreg		// percentage of registrants by covered and year
		
	
		
		// where to the migrants go to
		replace migrants = total_migrants * perc_b				if covered == 0
			
		
		
		* generate new variables for outcome
		*-----------------------------------

		gen 	vreg_bnw_sim 		= ${bvr} - migrants 		if covered == 1	& year > 1965 & ${tag}		// subtract migrants from covered counties
		replace vreg_bnw_sim 		= ${bvr} + migrants		if covered == 0 & year > 1965 & ${tag}		// add migrants to uncovered counties
				
		gen 	pop_b_va_i_sim 		= ${pbva} - migrants		if covered == 1	& year > 1965 & ${tag}		// subtract migrants from population in covered counties		
		replace pop_b_va_i_sim 		= ${pbva} + migrants		if covered == 0	& year > 1965 & ${tag}		// add migrats to population counties
		
		gen 	p_vreg_b_i_sim		= vreg_bnw_sim / pop_b_va_i_sim		if  ${tag}								// recalculate voter registration
		replace p_vreg_b_i_sim		= ${pvr} 							if  ${tag} & p_vreg_b_i_sim == .
	
		
		
		* generate new variables for controls
		*------------------------------------
		
		gen		pop_t_i_sim   	= ${pop} - migrants			if covered == 1	& year > 1965
		replace pop_t_i_sim   	= ${pop} + migrants			if covered == 0	& year > 1965
		replace pop_t_i_sim		= ${pop}						if pop_t_i_sim == .
				
		gen 	pop_t_i_ln_sim 	= ln(pop_t_i_sim) 
		
		gen 	pop_b_i_sim 	= ${bpop} - migrants		if covered == 1	& year > 1965
		replace	pop_b_i_sim 	= ${bpop} + migrants		if covered == 0	& year > 1965
		replace pop_b_i_sim		= ${bpop}					if pop_b_i_sim == .
		
		gen		pop_b_perc_sim  = pop_b_i_sim / pop_t_i_sim

		
		
		* estimation globals
		*-------------------
		
		global dv1 			= "p_vreg_b_i_sim"
		global d_in_d 		= "post_x_covered"
		global controls1 	= "pop_t_i_ln_sim  inc_hh_med_i  pop_b_perc_sim"
				
		
		
		* estimation
		*-----------
		
		display "total: `tm'"
		areg 	${dv1} ${d_in_d} ${controls1} i.year 	if ${tag}, absorb(county_id) vce(cl county_id) 
		post 	`memhold' (_b[${d_in_d}]) (_se[${d_in_d}]) (`x') (`tm')
		
		
		* drop
		*-----
		
		drop p_vreg_b_i_sim  vreg_bnw_sim  pop_b_va_i_sim  pop_b_va_i_sim
		drop pop_t_i_sim  pop_t_i_ln_sim  pop_b_i_sim  pop_b_perc_sim
		drop total_migrants perc_bvreg perc_b total_bvreg total_b
		capture drop migrants_p migrants_r
		capture drop migrants perc
		capture drop migrants

}




* post the data
*--------------

postclose `memhold'
use `results', clear




* confidence intervals
*---------------------

gen sortid 	= _n
gen cihi 	= beta + 1.96*se
gen cilo 	= beta - 1.96*se
gen cihi2 	= beta + 1.645*se
gen cilo2 	= beta - 1.645*se



* plot
*-----


#delimit;

twoway 

	( rcap cihi cilo perc_migration if sortid != 1
			, lwidth(medthin) color(black) msize(tiny) yaxis(1)
			) 
	( rcap cihi2 cilo2 perc_migration if sortid != 1
			, lwidth(thick) color(black) msize(vtiny) yaxis(1)
			) 
	
	( scatter beta perc_migration if sortid != 1
		, 	mcolor(black) msize(medium)
			yline(0 , axis(1) lpattern(dot) lcolor(gs5) lwidth(medthick) )  yaxis(1)
		)
	( rcap cihi cilo perc_migration if sortid == 1
			, lwidth(medthin) color(gs9) msize(tiny) yaxis(1)
			) 
	( rcap cihi2 cilo2 perc_migration if sortid == 1
			, lwidth(thick) color(gs9) msize(vtiny)  yaxis(1)
			) 
	
	( scatter beta perc_migration if sortid == 1
		, 	mcolor(gs9) msize(medium) msymbol(Oh)
			   yaxis(1)
			)
	( line total_migrants perc_migration
		, 	lcolor(gs10) lwidth(medium) yline(500, axis(2) lpattern(dot) lcolor(gs5) lwidth(medthick) )
			yaxis(2)
		)

		,
		ylabel( ,
			nogrid angle(hori) labsize(small) axis(1) )
		ylabel( ,
			nogrid angle(hori) labsize(small) axis(2) )	
		xlabel(  ,
			labsize(small) tlength(1) )
		xtitle("Percentage of Black Migrants Arriving to Covered Counties",
			color(black) size(medsmall))
		xscale(noline)
		yscale(noline axis(1))
		yscale(noline axis(2))
		graphregion(fcolor(white) lcolor(white) ) 	
		plotregion(fcolor(white) lstyle(none) lcolor(white) ilstyle(none))
		title("  ", 
			color(black) size(medsmall) pos(11) )  
		subtitle("",
			color(black) justification(center))
		ytitle("Difference in Differences Estimate",
			angle(hori)	color(black) size(medsmall) axis(1) )
		ytitle("Total number of migrants",
			angle(hori)	color(black) size(medsmall) axis(2) )
		legend(
			off
			
		)

;

#delimit cr


	* export the graph
	*-----------------

	cd "${directory_output}"
	graph export Simulation_Black_2.pdf, replace





* restore
*--------

restore




	

			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* simulation 3 (appendix): send according to black registrants (geography and post-period) simulation
*-------------------------------------------------------------------------------


* preserve
*---------

preserve



* temporary file
*---------------

tempname memhold
tempfile results
postfile `memhold' beta se perc_migration total_migrants   using `results' 



* globals
*--------

global pvr		= "p_vreg_bnw_fs"
global bvr		= "vreg_bnw_fs"
global tag		= "tag_vreg_bnw == 1"
global pbva		= "pop_va_bnw_fs"
global pop		= "pop_t_i"
global bpop		= "pop_b_i"
global bpopp	= "pop_b_i_perc"



* first one
*----------

local x = 0
global d_in_d 		= "post_x_covered"
global controls1 	= "pop_t_i_ln  inc_hh_med_i  pop_b_i_perc"
		
		
			

* loop
*-----

forvalues x =  0(.01).1 {


		* general variables for simulation change
		*----------------------------------------
		
		gen migrants = ${bvr} * `x'					if covered == 1
		
		
		bysort year: egen 	total_migrants 			= total(migrants)			if covered == 1  	// total migrants leaving covered
		sort year migrants
		replace total_migrants 						= total_migrants[_n-1]   	if total_migrants[_n] == . & total_migrants[_n-1] != . & year[_n] == year[_n-1]

		sum 	total_migrants
		local   tm = `r(mean)'
		
		
		// share of each county in total black registrants and total black population
		bysort 	covered year: egen total_b 			= total(${bpop})
		gen 	perc_b								= ${bpop} / total_b
		
		bysort 	covered year: egen total_bvreg		= total(${bvr})		
		gen 	perc_bvreg 							= ${bvr} / total_bvreg		// percentage of registrants by covered and year
		
	
		
		// where to the migrants go to
		replace migrants = total_migrants * perc_bvreg				if covered == 0
			
		
		* generate new variables for outcome
		*-----------------------------------

		gen 	vreg_bnw_sim 		= ${bvr} - migrants 		if covered == 1	& year > 1965 & ${tag}		// subtract migrants from covered counties
		replace vreg_bnw_sim 		= ${bvr} + migrants		if covered == 0 & year > 1965 & ${tag}		// add migrants to uncovered counties
				
		gen 	pop_b_va_i_sim 		= ${pbva} - migrants		if covered == 1	& year > 1965 & ${tag}		// subtract migrants from population in covered counties		
		replace pop_b_va_i_sim 		= ${pbva} + migrants		if covered == 0	& year > 1965 & ${tag}		// add migrats to population counties
		
		gen 	p_vreg_b_i_sim		= vreg_bnw_sim / pop_b_va_i_sim		if  ${tag}								// recalculate voter registration
		replace p_vreg_b_i_sim		= ${pvr} 							if  ${tag} & p_vreg_b_i_sim == .
	
		
		
		* generate new variables for controls
		*------------------------------------
		
		gen		pop_t_i_sim   	= ${pop} - migrants			if covered == 1	& year > 1965
		replace pop_t_i_sim   	= ${pop} + migrants			if covered == 0	& year > 1965
		replace pop_t_i_sim		= ${pop}						if pop_t_i_sim == .
				
		gen 	pop_t_i_ln_sim 	= ln(pop_t_i_sim) 
		
		gen 	pop_b_i_sim 	= ${bpop} - migrants		if covered == 1	& year > 1965
		replace	pop_b_i_sim 	= ${bpop} + migrants		if covered == 0	& year > 1965
		replace pop_b_i_sim		= ${bpop}					if pop_b_i_sim == .
		
		gen		pop_b_perc_sim  = pop_b_i_sim / pop_t_i_sim

		
		
		* estimation globals
		*-------------------
		
		global dv1 			= "p_vreg_b_i_sim"
		global d_in_d 		= "post_x_covered"
		global controls1 	= "pop_t_i_ln_sim  inc_hh_med_i  pop_b_perc_sim"
				
		
		
		* estimation
		*-----------
		
		display "total: `tm'"
		areg 	${dv1} ${d_in_d} ${controls1} i.year 	if ${tag}, absorb(county_id) vce(cl county_id) 
		post 	`memhold' (_b[${d_in_d}]) (_se[${d_in_d}]) (`x') (`tm')
		
		
		* drop
		*-----
		
		drop p_vreg_b_i_sim  vreg_bnw_sim  pop_b_va_i_sim  pop_b_va_i_sim
		drop pop_t_i_sim  pop_t_i_ln_sim  pop_b_i_sim  pop_b_perc_sim
		drop total_migrants perc_bvreg perc_b total_bvreg total_b
		capture drop migrants_p migrants_r
		capture drop migrants perc
		capture drop migrants

}




* post the data
*--------------

postclose `memhold'
use `results', clear




* confidence intervals
*---------------------

gen sortid 	= _n
gen cihi 	= beta + 1.96*se
gen cilo 	= beta - 1.96*se
gen cihi2 	= beta + 1.645*se
gen cilo2 	= beta - 1.645*se



* plot
*-----


#delimit;

twoway 

	( rcap cihi cilo perc_migration if sortid != 1
			, lwidth(medthin) color(black) msize(tiny) yaxis(1)
			) 
	( rcap cihi2 cilo2 perc_migration if sortid != 1
			, lwidth(thick) color(black) msize(vtiny) yaxis(1)
			) 	
	( scatter beta perc_migration if sortid != 1
		, 	mcolor(black) msize(medium)
			yline(0 , axis(1) lpattern(dot) lcolor(gs5) lwidth(medthick) )  yaxis(1)
		)
		
		
	( rcap cihi cilo perc_migration if sortid == 1
			, lwidth(medthin) color(gs9) msize(tiny) yaxis(1)
			) 
	( rcap cihi2 cilo2 perc_migration if sortid == 1
			, lwidth(thick) color(gs9) msize(vtiny)  yaxis(1)
			) 
	( scatter beta perc_migration if sortid == 1
		, 	mcolor(gs9) msize(medium) msymbol(Oh)
		   yaxis(1)
			)
			

	( line total_migrants perc_migration
		, 	lcolor(gs10) lwidth(medium) yline(400, axis(2) lpattern(dot) lcolor(gs5) lwidth(medthick) )
			yaxis(2)
		)

		,
		ylabel( ,
			nogrid angle(hori) labsize(small) axis(1) )
		ylabel( ,
			nogrid angle(hori) labsize(small) axis(2) )	
		xlabel(  ,
			labsize(small) tlength(1) )
		xtitle("Percentage of Black Migrants Arriving to Covered Counties",
			color(black) size(medsmall))
		xscale(noline)
		yscale(noline axis(1))
		yscale(noline axis(2))
		graphregion(fcolor(white) lcolor(white) ) 	
		plotregion(fcolor(white) lstyle(none) lcolor(white) ilstyle(none))
		title("  ", 
			color(black) size(medsmall) pos(11) )  
		subtitle("",
			color(black) justification(center))
		ytitle("Difference in Differences Estimate",
			angle(hori)	color(black) size(medsmall) axis(1) )
		ytitle("Total number of migrants",
			angle(hori)	color(black) size(medsmall) axis(2) )
		legend(
			off
			
		)

;

#delimit cr


	* export the graph
	*-----------------

	cd "${directory_output}"
	graph export Simulation_Black_3.pdf, replace





* restore
*--------

restore





	

			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	


*-------------------------------------------------------------------------------
* individual numbers for the paper
*-------------------------------------------------------------------------------


* percent increase in black voter registration
*---------------------------------------------

sum p_vreg_bnw if year == 1958 & covered == 1
local pre = `r(mean)'
sum p_vreg_bnw if year == 1993  & covered == 1
local post = `r(mean)'
local value = (`post'-`pre')/`pre'
display "`value'"


cd "${directory_output}"
capture file close myfile
file open myfile using "percent_change_p_vreg.tex", write replace
file write myfile %7.0f (`value'*100)
file close myfile
		
		
		
* gap
*----

sum gap_bw_vreg if year == 1958  & covered == 1
local pre = `r(mean)'
sum gap_bw_vreg if year == 1993  & covered == 1
local post = `r(mean)'


cd "${directory_output}"
capture file close myfile
file open myfile using "percent_change_gap.tex", write replace
file write myfile %7.0f (((`post'-`pre')/`pre')*-100)
file close myfile		





* average migration
*------------------

sum mig_county if year == 1970

cd "${directory_output}"
capture file close myfile
file open myfile using "avg_mig.tex", write replace
file write myfile %7.0f (round(`r(mean)',1000))
file close myfile



sum mig_county if year == 1970 & covered == 1

cd "${directory_output}"
capture file close myfile
file open myfile using "avg_mig_1.tex", write replace
file write myfile %7.0f (round(`r(mean)',100))
file close myfile

sum mig_county if year == 1970 & covered == 0

cd "${directory_output}"
capture file close myfile
file open myfile using "avg_mig_0.tex", write replace
file write myfile %7.0f (round(`r(mean)',100))
file close myfile
			
			
			
			
	
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	

			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
	
				   ** end of VRA_JOP_Replication.do **
					

