* This program renames variables
* To be run before the figures and tables do files
* The Impacts of Neighborhoods on Intergenerational Mobility II: County-Level Estimates 
* Raj Chetty and Nathaniel Hendren 

set more off

* Please change the directory to location of the appropriate files
global data "${dropbox}/movers/final_web_files/replicate_qje_submission/data"
global online_tables "${dropbox}/movers/final_web_files/replicate_qje_submission/online_tables"

* Globals for data sets
global cz_data "${online_tables}/online_table_3.dta"
global cty_data "${online_tables}/online_table_4.dta"

*****************************************************************************************************
* Online Data Table 3: Raw Causal Place Effects by Commuting Zone and Commuting Zone Characteristics
*****************************************************************************************************
	
	* use dataset 
	use "${cz_data}", clear
	keep cz causal*
	
	* take care of all Bjs
	* rename variables
	rename (*coli*) (*coli1996*) 
	rename (causal*) (Bj*)
	
	* first taking care of all the cc and cc3 spec variables
	preserve
	keep cz Bj*_cc* Bj*_cc3*
	
	tempfile temp1
	save `temp1'
	restore
	
	drop *cc* *cc3*
	rename (Bj*) (Bj*_cc2)
	rename (*_bs_se_cc2) (*_cc2_bs_se)
	rename (*_se_cc2) (*_cc2_se)
	rename (*_s1*) (*_ss1*) 
	rename (*_s2*) (*_ss2*)
	
	rename (*_16_ss1_cc2*) (*_cc2_16_ss1*) 
	rename (*_16_ss2_cc2*) (*_cc2_16_ss2*) 
	
	rename (*tlpbo_cc2_16_ss1*) (*tlpbo_16_cc2_ss1*) 
	rename (*tlpbo_cc2_16_ss2*) (*tlpbo_16_cc2_ss2*) 
	
	merge 1:1 cz using `temp1', nogen 
	tempfile temp2
	save `temp2'
	
	* now all e_rank_bs
	use "${cz_data}", clear
	keep cz perm_res*
	rename perm_res_p25_*_1980 perm_res_*_p25_1980  
	rename perm_res_p75_*_1980 perm_res_*_p75_1980   
	rename perm_res_p25_*_1981 perm_res_*_p25_1981 
	rename perm_res_p75_*_1981 perm_res_*_p75_1981 
	rename perm_res_p25_*_1982 perm_res_*_p25_1982 
	rename perm_res_p75_*_1982 perm_res_*_p75_1982 
	rename perm_res_p25_*_1983 perm_res_*_p25_1983 
	rename perm_res_p75_*_1983 perm_res_*_p75_1983 
	rename perm_res_p25_*_1984 perm_res_*_p25_1984 
	rename perm_res_p75_*_1984 perm_res_*_p75_1984 
	rename perm_res_p25_*_1985 perm_res_*_p25_1985 
	rename perm_res_p75_*_1985 perm_res_*_p75_1985 
	rename perm_res_p25_*_1986 perm_res_*_p25_1986 
	rename perm_res_p75_*_1986 perm_res_*_p75_1986 
	rename perm_res_p25_*_1987 perm_res_*_p25_1987 
	rename perm_res_p75_*_1987 perm_res_*_p75_1987 
	rename perm_res_p25_*_1988 perm_res_*_p25_1988 
	rename perm_res_p75_*_1988 perm_res_*_p75_1988 
	rename perm_res_p25_*_8386 perm_res_*_p25_8386 
	rename perm_res_p75_*_8386 perm_res_*_p75_8386 
	
	rename perm_res_p25_* perm_res_*_p25 
	rename perm_res_p75_* perm_res_*_p75 
	
	rename (perm_res*) (e_rank_b*)
	rename (*coli*) (*coli1996*) 
		
	rename *tb* *dm2*
	tempfile temp3
	save `temp3'
	
	*now merge with covariates and other descriptive variables
	use "${cz_data}", clear
	keep cz-intersects_msa cs_race_bla- unemp_rate_st parq1_kidq1- parq5_kidq5
	
	merge 1:1 cz using `temp2', nogen
	merge 1:1 cz using `temp3', nogen
	
	* save dataset 
	saveold "${data}/online_table_3", replace

*************************************************************************************
* Online Data Table 4: Raw Causal Place Effects by County and County Characteristics
*************************************************************************************

	* use dataset 
	use "${cty_data}", clear
	keep cty2000 causal*
	rename cty2000 cty 
	replace cty =12025  if cty == 12086
	replace cty = 2231 if cty == 2232
	
	* take care of all Bjs
	* rename variables
	rename (causal*) (Bj*)
	
	* first taking care of all the cc and cc3 spec variables
	preserve
	keep cty Bj*_cc* Bj*_cc3*
	
	tempfile temp1
	save `temp1'
	restore
	
	drop *cc* *cc3*
	rename (Bj*) (Bj*_cc2)
	rename (*_bs_se_cc2) (*_cc2_bs_se)
	rename (*_se_cc2) (*_cc2_se)
	rename (*_s1*) (*_ss1*) 
	rename (*_s2*) (*_ss2*)
	rename (*_ss1_cc2*) (*_cc2_ss1*) 
	rename (*_ss2_cc2*) (*_cc2_ss2*) 
		
	merge 1:1 cty using `temp1', nogen 
	tempfile temp2
	save `temp2'
		
	* now all e_rank_bs
	use "${cty_data}", clear
	keep cty2000 perm_res*
	rename cty2000 cty 
	replace cty =12025  if cty == 12086
	replace cty = 2231 if cty == 2232

	rename perm_res_par* stayers_par* 
	
	rename perm_res_p25_*_1980 perm_res_*_p25_1980  
	rename perm_res_p75_*_1980 perm_res_*_p75_1980   
	rename perm_res_p25_*_1981 perm_res_*_p25_1981 
	rename perm_res_p75_*_1981 perm_res_*_p75_1981 
	rename perm_res_p25_*_1982 perm_res_*_p25_1982 
	rename perm_res_p75_*_1982 perm_res_*_p75_1982 
	rename perm_res_p25_*_1983 perm_res_*_p25_1983 
	rename perm_res_p75_*_1983 perm_res_*_p75_1983 
	rename perm_res_p25_*_1984 perm_res_*_p25_1984 
	rename perm_res_p75_*_1984 perm_res_*_p75_1984 
	rename perm_res_p25_*_1985 perm_res_*_p25_1985 
	rename perm_res_p75_*_1985 perm_res_*_p75_1985 
	rename perm_res_p25_*_1986 perm_res_*_p25_1986 
	rename perm_res_p75_*_1986 perm_res_*_p75_1986 
	rename perm_res_p25_*_1987 perm_res_*_p25_1987 
	rename perm_res_p75_*_1987 perm_res_*_p75_1987 
	rename perm_res_p25_*_1988 perm_res_*_p25_1988 
	rename perm_res_p75_*_1988 perm_res_*_p75_1988 
	rename perm_res_p25_*_8386 perm_res_*_p25_8386 
	rename perm_res_p75_*_8386 perm_res_*_p75_8386 
	
	rename perm_res_p25_* perm_res_*_p25 
	rename perm_res_p75_* perm_res_*_p75 

	rename (perm_res*) (e_rank_b*) 
	rename (*coli*) (*coli1996*) 
	
	rename *tb* *dm2*
	
	tempfile temp3
	save `temp3'
	
	*now merge with covariates and other descriptive variables
	use "${cty_data}", clear
	keep cty2000-intersects_msa cs_race_bla- unemp_rate_st frac_1- frac_10	
	rename cty2000 cty 
	replace cty =12025  if cty == 12086
	replace cty = 2231 if cty == 2232

	merge 1:1 cty using `temp2', nogen
	merge 1:1 cty using `temp3', nogen

	* save dataset 
	saveold "${data}/online_table_4", replace
	

