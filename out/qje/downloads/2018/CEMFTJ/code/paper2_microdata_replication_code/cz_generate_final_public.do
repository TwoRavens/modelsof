/***
 This program generates raw causal estimates at the Commuting Zone level for all outcomes
 Inputs: raw estimates by CZ sent out of IRS
 Output: raw causal place effects at the CZ level
 
 	Note: the input data to this script is not publicly available.
	All variable inputs come from the output of %make_beta_ijs() in beta_macros_vSubmission_public
***/

clear all
set matsize 5000
set more off

global covariates  "${user}/Dropbox/movers/analysis/covariates/all_data/"
global crosswalks "${user}/Dropbox/movers/analysis/crosswalks/"
global irsdata "${user}/Dropbox/movers/analysis/irsdata"
global save "${user}/Dropbox/movers/analysis/beta/beta_final/CZ/used_specs"


********************************************************************************
* SPECS USED IN FINAL_CZ DATASET
********************************************************************************

* BASELINE: KR26 AND C1823

foreach outcome in "kr26" "c1823" { 
foreach spec in "_cc2" "_cc" "_cc3" "_am_cc2" "_bm_cc2" "_f_cc2" "_m_cc2" "_sp_cc2" "_tp_cc2" "_pbo_cc2" "_pmi_cc2" {

foreach ppp in 1 25 50 75 99 { 

if  "`outcome'`spec'" != "c1823_pmi_cc2" & "`outcome'`spec'" != "c1823_pbo_cc2" & "`outcome'`spec'" != "c1823_cc3" ///
&  "`outcome'`spec'" != "c1823_cc" &  "`outcome'`spec'" != "c1823_bm_cc2" &  "`outcome'`spec'" != "c1823_am_cc2" {

di in red "outcome `outcome'`spec' Parent Rank `ppp'" 

* 1) Input data and generate beta ij and precision weights
use ${irsdata}/cz_2steps_final/beta_v12_cz`outcome'`spec'.dta , clear
keep if n_od>=25

* 2) Compute beta ij, variance and precision weights
g Bij_`ppp' = -100*(ageatmove + (`ppp'/100) * ageatmove_par_rank_n)
gen var_ageatmove = se_ageatmove^2
gen var_ageatmove_par_rank_n = se_ageatmove_par_rank_n^2
gen var_Bij_p`ppp' = (100^2)*(var_ageatmove +((`ppp'/100)^2)*var_ageatmove_par_rank_n + 2*(`ppp'/100)*cov)
gen inv_var_`ppp' = 1/var_Bij_p`ppp'

tempfile beta_data 
save `beta_data'

* 3) Compute beta j to identify connected sets

	* 3.1) create gary's matrix
	local rhs=""
	rename par_cz_orig o
	rename par_cz_dest d
	drop if o == 0 | d == 0
	qui levelsof d, local(d)
	qui levelsof o, local(o)
	local places : list o | d
	qui foreach p of local places {
	if "`p'"!="19400"{ // NY CZ 19400
	  gen p`p' = (d == `p')
	  replace p`p' = -1 if o == `p'
	  local rhs "`rhs' p`p'"
	}
	}

	* 3.2) regress beta ij on gary's matrix
	qui reg Bij_`ppp' `rhs' [w=inv_var_`ppp'], nocons
	clear
	local wc : word count `places'
	set obs `wc'
	gen cz = .
	gen beta = .
	local i = 1
	qui foreach p of local places {
	if "`p'"!="19400"{ // NYC 19400
	  replace cz = `p' in `i'  
	  replace beta = 0 in `i'
	  replace beta = _b[p`p'] in `i'
	  }
	 else if "`p'"=="19400"{
	  replace cz = `p' in `i'
	  replace beta = 0 in `i' 
	}
	  local ++i
	  }
	  
	keep cz beta
	  
	tempfile raw
	save `raw'

* 4) Compute beta j

	use `beta_data', clear

	* 4.1) Merge Populations 
	rename par_cz_orig cz 
	merge m:1 cz using ${covariates}cz_characteristics.dta , keepusing(pop2000) keep(master match)
	count if _merge == 1
	assert r(N) == 0
	drop _merge
	rename pop2000 pop2000_o
	rename cz par_cz_orig
	
	rename par_cz_dest cz 
	merge m:1 cz using ${covariates}cz_characteristics.dta , keepusing(pop2000) keep(master match)
	count if _merge == 1
	assert r(N) == 0
	drop _merge
	rename pop2000 pop2000_d
	rename cz par_cz_dest

	* 4.2) create gary's matrix
	local rhs=""
	rename par_cz_orig o
	rename par_cz_dest d
	drop if o == 0 | d == 0
	qui levelsof d, local(d)
	qui levelsof o, local(o)
	local places : list o | d

	matrix c1 = .
	matrix pop = . 
	matrix czs = . 

	local c1 = " 0 = 0 "
	local i = 1 
	qui foreach p of local places {
	matrix czs = czs \ `p' 
	  gen p`p' = (d == `p')
	  replace p`p' = -1 if o == `p'
	  local rhs "`rhs' p`p'"
	  matrix temp = `p'
	  su pop2000_o if o == `p' 
	  local pop = r(mean)
	  if `pop' == .  {
		su pop2000_d if d == `p'
		local pop = r(mean)
	   }
	  local c1 = "`c1'+`pop'*p`p'"
	  local c_pop`p' = `pop'
	  matrix temp = `pop'
	  matrix pop = pop \ temp
	local i = `i' + 1 
	}
	matrix pop = pop[2...,1]
	matrix czs = czs[2...,1]

	* 4.3) Regress beta ij on gary's matrix

	qui reg Bij_`ppp' `rhs' [w=inv_var_`ppp'], nocons
	matrix VCV = e(V)
	matrix b = e(b)

	local r = rowsof(VCV)
	mata: pop = st_matrix("pop")
	mata: b = st_matrix("b")
	mata: b = b'
	mata: VCV = st_matrix("VCV")

	mata: pop_tot = colsum(pop)
	mata: JJ = (pop * J(1,`r',1))/pop_tot
	mata: Q = I(`r') - JJ
	mata: b_dm = Q'*b
	mata: st_matrix("b_dm",b_dm)
	mata: VCV_dm = Q' * VCV * Q
	mata: VCV_vec = diagonal(VCV_dm)
	mata: st_matrix("VCV_vec",VCV_vec)
	mata: st_matrix("VCV_dm",VCV_dm)

	* 4.4) Construct dataset with places
	clear

	svmat b_dm
	rename b_dm1 b_dm
	svmat czs
	rename czs1 cz 
	svmat VCV_vec
	rename VCV_vec1 VCV_vec 
	g row = _n

	gen Bj_p`ppp'_cz`outcome'`spec' = b_dm 
	gen Bj_p`ppp'_cz`outcome'`spec'_se = sqrt(VCV_vec)
	
	drop row VCV_vec b_dm

	tempfile final
	save `final'

	merge 1:1 cz using `raw', nogen

* 5) Take care of disconnected sets
	
		count if beta==0
		local N_zero = r(N)

			if `N_zero'>1{

			local N_zero2 = `N_zero'-1 
			tab cz if beta==0 & cz ~= 19400 ,  matrow(badcz) 
			di in red "ERROR : `outcome'`spec' ; Nb beta = 0 is `N_zero2'"
			matrix list badcz

			local bad = `N_zero' 
				while `bad' > 1 {

				gen goodcz = .
				replace goodcz = 1 if beta!=0 
				replace goodcz = 1 if cz==19400
				qui levelsof cz if goodcz==1 , local(places)
				
				
				* 5.1) Input data and generate beta ij and precision weights
				use ${irsdata}/cz_2steps_final/beta_v12_cz`outcome'`spec'.dta , clear
				keep if n_od>=25
				local N_badczs = `N_zero' - 1
				forval bads = 1(1)`N_badczs' {
				local badcz = badcz[`bads',1]
				drop if par_cz_orig == `badcz' | par_cz_dest == `badcz'
				}

				* 5.2) Compute beta ij, variance and precision weights
				g Bij_`ppp' = -100*(ageatmove + (`ppp'/100) * ageatmove_par_rank_n)
				gen var_ageatmove = se_ageatmove^2
				gen var_ageatmove_par_rank_n = se_ageatmove_par_rank_n^2
				gen var_Bij_p`ppp' = (100^2)*(var_ageatmove +((`ppp'/100)^2)*var_ageatmove_par_rank_n + 2*(`ppp'/100)*cov)
				gen inv_var_`ppp' = 1/var_Bij_p`ppp'

				tempfile beta_data 
				save `beta_data'

				* 5.3) Compute beta j to identify connected sets later on

					* 5.3.1) create gary's matrix
					local rhs=""
					rename par_cz_orig o
					rename par_cz_dest d
					drop if o == 0 | d == 0
					qui foreach p of local places {
					if "`p'"!="19400"{
					  gen p`p' = (d == `p')
					  replace p`p' = -1 if o == `p'
					  local rhs "`rhs' p`p'"
					}
					}

					* 5.3.2) regress beta ij on gary's matrix
					qui reg Bij_`ppp' `rhs' [w=inv_var_`ppp'], nocons
					clear
					local wc : word count `places'
					set obs `wc'
					gen cz = .
					gen beta = .
					local i = 1
					qui foreach p of local places {
					if "`p'"!="19400"{ 
					  replace cz = `p' in `i'  
					  replace beta = 0 in `i' 
					  replace beta = _b[p`p'] in `i'
					  }
					 else if "`p'"=="19400"{
					  replace cz = `p' in `i'
					  replace beta = 0 in `i' 
					}
					  local ++i
					  }
					  
					 keep cz beta

					tempfile raw
					save `raw'

				* 5.4) Compute beta j

					use `beta_data', clear

					* 5.4.1) Merge Populations (for weighting)
					rename par_cz_orig cz 
					merge m:1 cz using ${covariates}cz_characteristics.dta , keepusing(pop2000) keep(master match)
					count if _merge == 1
					assert r(N) == 0
					drop _merge
					rename pop2000 pop2000_o
					rename cz par_cz_orig
					
					rename par_cz_dest cz 
					merge m:1 cz using ${covariates}cz_characteristics.dta , keepusing(pop2000) keep(master match)
					count if _merge == 1
					assert r(N) == 0
					drop _merge
					rename pop2000 pop2000_d
					rename cz par_cz_dest

					* 5.4.2) create gary's matrix
					local rhs=""
					rename par_cz_orig o
					rename par_cz_dest d
					drop if o == 0 | d == 0

					matrix c1 = .
					matrix pop = . 
					matrix czs = . 

					local c1 = " 0 = 0 "
					local i = 1 
					qui foreach p of local places {
					matrix czs = czs \ `p' 
					  gen p`p' = (d == `p')
					  replace p`p' = -1 if o == `p'
					  local rhs "`rhs' p`p'"
					  matrix temp = `p'
					  su pop2000_o if o == `p' 
					  local pop = r(mean)
					  if `pop' == .  {
						su pop2000_d if d == `p'
						local pop = r(mean)
					   }
					  local c1 = "`c1'+`pop'*p`p'"
					  local c_pop`p' = `pop'
					  matrix temp = `pop'
					  matrix pop = pop \ temp
					local i = `i' + 1 
					}
					matrix pop = pop[2...,1]
					matrix czs = czs[2...,1]

					* 5.4.3) Regress beta ij on gary's matrix

					qui reg Bij_`ppp' `rhs' [w=inv_var_`ppp'], nocons
					matrix VCV = e(V)
					matrix b = e(b)

					local r = rowsof(VCV)
					mata: pop = st_matrix("pop")
					mata: b = st_matrix("b")
					mata: b = b'
					mata: VCV = st_matrix("VCV")

					mata: pop_tot = colsum(pop)
					mata: JJ = (pop * J(1,`r',1))/pop_tot
					mata: Q = I(`r') - JJ
					mata: b_dm = Q'*b
					mata: st_matrix("b_dm",b_dm)
					mata: VCV_dm = Q' * VCV * Q
					mata: VCV_vec = diagonal(VCV_dm)
					mata: st_matrix("VCV_vec",VCV_vec)
					mata: st_matrix("VCV_dm",VCV_dm)

					* 5.4.4) Construct dataset with places
					clear

					svmat b_dm
					rename b_dm1 b_dm
					svmat czs
					rename czs1 cz 
					svmat VCV_vec
					rename VCV_vec1 VCV_vec 
					g row = _n

					gen Bj_p`ppp'_cz`outcome'`spec' = b_dm 
					gen Bj_p`ppp'_cz`outcome'`spec'_se = sqrt(VCV_vec)
					
					drop row VCV_vec b_dm

					tempfile final
					save `final'

					merge 1:1 cz using `raw', nogen
					
				count if beta==0 
				local N_zero= r(N)
				
				local N_zero2 = `N_zero'-1 
				tab cz if beta==0 & cz ~= 19400 ,  matrow(badcz) 
				di in red "ERROR : `outcome'`spec' ; Nb beta = 0 is `N_zero2'"
				matrix list badcz

				local bad = `N_zero' 

				}
			}

tempfile perc`ppp'

save `perc`ppp''
}
}

* 6) Merge percentiles together

foreach ppp in 1 25 50 75 99  { 
merge 1:1 cz using `perc`ppp'', nogen
} 

drop beta
compress
save ${save}/cz_`outcome'`spec'.dta, replace
}		
}



* OTHER OUTCOMES

foreach outcome in c1820 ///
 kir26 kir26_f kir26_m km26  ///
 kfi26 kfi26_m kfi26_f kii26 kii26_f kii26_m ///
 kr26_c1996 kir26_c1996 ///
 krg26 krg26_m krg26_f kr26_coli1996 kr26_sq ///
 tlpbo_16 {
foreach spec in _cc2{

foreach ppp in 1 25 50 75 99 { 

di in red "outcome `outcome'`spec' Parent Rank `ppp'" 

* 1) Input data and generate beta ij and precision weights
use ${irsdata}/cz_2steps_final/beta_v12_cz`outcome'`spec'.dta , clear
keep if n_od>=25

* 2) Compute beta ij, variance and precision weights
if "`outcome'"=="kfi26" | "`outcome'"=="kfi26_m" | "`outcome'"=="kfi26_f" | "`outcome'"=="kii26" | "`outcome'"=="kii26_f" | "`outcome'"=="kii26_m" | "`outcome'"=="tlpbo_16" {
g Bij_`ppp' = -(ageatmove + (`ppp'/100) * ageatmove_par_rank_n)
gen var_ageatmove = se_ageatmove^2
gen var_ageatmove_par_rank_n = se_ageatmove_par_rank_n^2
gen var_Bij_p`ppp' = (var_ageatmove +((`ppp'/100)^2)*var_ageatmove_par_rank_n + 2*(`ppp'/100)*cov)
gen inv_var_`ppp' = 1/var_Bij_p`ppp'
}
else if  "`outcome'"=="kr26_sq"  {
g Bij_`ppp' = -100*(ageatmove + (`ppp'/100) * ageatmove_par_rank_n+ (`ppp'/100)^2 * ageatmove_par_rank_n_2 )
gen var_ageatmove = se_ageatmove^2
gen var_ageatmove_par_rank_n = se_ageatmove_par_rank_n^2
gen var_ageatmove_par_rank_n_2 = se_ageatmove_par_rank_n_2^2
gen var_Bij_p`ppp' = 100^2*(var_ageatmove +((`ppp'/100)^2)*var_ageatmove_par_rank_n+((`ppp'/100)^4)*var_ageatmove_par_rank_n_2 + 2*(`ppp'/100)*cov_a_ap+2*(`ppp'/100)^2*cov_a_ap2+2*(`ppp'/100)^3*cov_ap_ap2)
gen inv_var_`ppp' = 1/var_Bij_p`ppp'
}
else {
g Bij_`ppp' = -100*(ageatmove + (`ppp'/100) * ageatmove_par_rank_n)
gen var_ageatmove = se_ageatmove^2
gen var_ageatmove_par_rank_n = se_ageatmove_par_rank_n^2
gen var_Bij_p`ppp' = (100^2)*(var_ageatmove +((`ppp'/100)^2)*var_ageatmove_par_rank_n + 2*(`ppp'/100)*cov)
gen inv_var_`ppp' = 1/var_Bij_p`ppp'
}

tempfile beta_data 
save `beta_data'

* 3) Compute beta j to identify connected sets

	* 3.1) create gary's matrix
	local rhs=""
	rename par_cz_orig o
	rename par_cz_dest d
	drop if o == 0 | d == 0
	qui levelsof d, local(d)
	qui levelsof o, local(o)
	local places : list o | d
	qui foreach p of local places {
	if "`p'"!="19400"{ // NY CZ 19400
	  gen p`p' = (d == `p')
	  replace p`p' = -1 if o == `p'
	  local rhs "`rhs' p`p'"
	}
	}

	* 3.2) regress beta ij on gary's matrix
	qui reg Bij_`ppp' `rhs' [w=inv_var_`ppp'], nocons
	clear
	local wc : word count `places'
	set obs `wc'
	gen cz = .
	gen beta = .
	local i = 1
	qui foreach p of local places {
	if "`p'"!="19400"{ // NYC 19400
	  replace cz = `p' in `i'  
	  replace beta = 0 in `i'
	  replace beta = _b[p`p'] in `i'
	  }
	 else if "`p'"=="19400"{
	  replace cz = `p' in `i'
	  replace beta = 0 in `i' 
	}
	  local ++i
	  }
	  
	keep cz beta
	  
	tempfile raw
	save `raw'

* 4) Compute beta j

	use `beta_data', clear

	* 4.1) Merge Populations (for weighting)
	rename par_cz_orig cz 
	merge m:1 cz using ${covariates}cz_characteristics.dta , keepusing(pop2000) keep(master match)
	count if _merge == 1
	assert r(N) == 0
	drop _merge

	rename pop2000 pop2000_o
	rename cz par_cz_orig
	rename par_cz_dest cz 
	merge m:1 cz using ${covariates}cz_characteristics.dta , keepusing(pop2000) keep(master match)
	count if _merge == 1
	assert r(N) == 0
	drop _merge
	rename pop2000 pop2000_d
	rename cz par_cz_dest

	* 4.2) create gary's matrix
	local rhs=""
	rename par_cz_orig o
	rename par_cz_dest d
	drop if o == 0 | d == 0
	qui levelsof d, local(d)
	qui levelsof o, local(o)
	local places : list o | d

	matrix c1 = .
	matrix pop = . 
	matrix czs = . 

	local c1 = " 0 = 0 "
	local i = 1 
	qui foreach p of local places {
	matrix czs = czs \ `p' 
	  gen p`p' = (d == `p')
	  replace p`p' = -1 if o == `p'
	  local rhs "`rhs' p`p'"
	  matrix temp = `p'
	  su pop2000_o if o == `p' 
	  local pop = r(mean)
	  if `pop' == .  {
		su pop2000_d if d == `p'
		local pop = r(mean)
	   }
	  local c1 = "`c1'+`pop'*p`p'"
	  local c_pop`p' = `pop'
	  matrix temp = `pop'
	  matrix pop = pop \ temp
	local i = `i' + 1 
	}
	matrix pop = pop[2...,1]
	matrix czs = czs[2...,1]

	* 4.3) Regress beta ij on gary's matrix

	qui reg Bij_`ppp' `rhs' [w=inv_var_`ppp'], nocons
	matrix VCV = e(V)
	matrix b = e(b)

	local r = rowsof(VCV)
	mata: pop = st_matrix("pop")
	mata: b = st_matrix("b")
	mata: b = b'
	mata: VCV = st_matrix("VCV")

	mata: pop_tot = colsum(pop)
	mata: JJ = (pop * J(1,`r',1))/pop_tot
	mata: Q = I(`r') - JJ
	mata: b_dm = Q'*b
	mata: st_matrix("b_dm",b_dm)
	mata: VCV_dm = Q' * VCV * Q
	mata: VCV_vec = diagonal(VCV_dm)
	mata: st_matrix("VCV_vec",VCV_vec)
	mata: st_matrix("VCV_dm",VCV_dm)

	* 4.4) Construct dataset with places
	clear

	svmat b_dm
	rename b_dm1 b_dm
	svmat czs
	rename czs1 cz 
	svmat VCV_vec
	rename VCV_vec1 VCV_vec 
	g row = _n

	gen Bj_p`ppp'_cz`outcome'`spec' = b_dm 
	gen Bj_p`ppp'_cz`outcome'`spec'_se = sqrt(VCV_vec)
	
	drop row VCV_vec b_dm

	tempfile final
	save `final'

	merge 1:1 cz using `raw', nogen

* 5) Take care of disconnected sets
	
		count if beta==0
		local N_zero = r(N)

			if `N_zero'>1{

			local N_zero2 = `N_zero'-1 
			tab cz if beta==0 & cz ~= 19400 ,  matrow(badcz) 
			di in red "ERROR : `outcome'`spec' ; Nb beta = 0 is `N_zero2'"
			matrix list badcz

			local bad = `N_zero' 
				while `bad' > 1 {

				gen goodcz = .
				replace goodcz = 1 if beta!=0 
				replace goodcz = 1 if cz==19400
				qui levelsof cz if goodcz==1 , local(places)

				* 5.1) Input data and generate beta ij and precision weights
				use ${irsdata}/cz_2steps_final/beta_v12_cz`outcome'`spec'.dta , clear
				keep if n_od>=25
				local N_badczs = `N_zero' - 1
				forval bads = 1(1)`N_badczs' {
				local badcz = badcz[`bads',1]
				drop if par_cz_orig == `badcz' | par_cz_dest == `badcz'
				}

				* 2) Compute beta ij, variance and precision weights
				if "`outcome'"=="kfi26" | "`outcome'"=="kfi26_m" | "`outcome'"=="kfi26_f" | "`outcome'"=="kii26" | "`outcome'"=="kii26_f" | "`outcome'"=="kii26_m" | "`outcome'"=="tlpbo_16" {
				g Bij_`ppp' = -(ageatmove + (`ppp'/100) * ageatmove_par_rank_n)
				gen var_ageatmove = se_ageatmove^2
				gen var_ageatmove_par_rank_n = se_ageatmove_par_rank_n^2
				gen var_Bij_p`ppp' = (var_ageatmove +((`ppp'/100)^2)*var_ageatmove_par_rank_n + 2*(`ppp'/100)*cov)
				gen inv_var_`ppp' = 1/var_Bij_p`ppp'
				}
				else {
				g Bij_`ppp' = -100*(ageatmove + (`ppp'/100) * ageatmove_par_rank_n)
				gen var_ageatmove = se_ageatmove^2
				gen var_ageatmove_par_rank_n = se_ageatmove_par_rank_n^2
				gen var_Bij_p`ppp' = (100^2)*(var_ageatmove +((`ppp'/100)^2)*var_ageatmove_par_rank_n + 2*(`ppp'/100)*cov)
				gen inv_var_`ppp' = 1/var_Bij_p`ppp'
				}
				
				tempfile beta_data 
				save `beta_data'

				* 5.3) Compute beta j to identify connected sets later on

					* 5.3.1) create gary's matrix
					local rhs=""
					rename par_cz_orig o
					rename par_cz_dest d
					drop if o == 0 | d == 0
					qui foreach p of local places {
					if "`p'"!="19400"{
					  gen p`p' = (d == `p')
					  replace p`p' = -1 if o == `p'
					  local rhs "`rhs' p`p'"
					}
					}

					* 5.3.2) regress beta ij on gary's matrix
					qui reg Bij_`ppp' `rhs' [w=inv_var_`ppp'], nocons
					clear
					local wc : word count `places'
					set obs `wc'
					gen cz = .
					gen beta = .
					local i = 1
					qui foreach p of local places {
					if "`p'"!="19400"{ 
					  replace cz = `p' in `i'  
					  replace beta = 0 in `i' 
					  replace beta = _b[p`p'] in `i'
					  }
					 else if "`p'"=="19400"{
					  replace cz = `p' in `i'
					  replace beta = 0 in `i' 
					}
					  local ++i
					  }
					  
					 keep cz beta

					tempfile raw
					save `raw'

				* 5.4) Compute beta j

					use `beta_data', clear

					* 5.4.1) Merge Populations (for weighting)
					rename par_cz_orig cz 
					merge m:1 cz using ${covariates}cz_characteristics.dta , keepusing(pop2000) keep(master match)
					count if _merge == 1
					assert r(N) == 0
					drop _merge

					rename pop2000 pop2000_o
					rename cz par_cz_orig
					rename par_cz_dest cz 
					merge m:1 cz using ${covariates}cz_characteristics.dta , keepusing(pop2000) keep(master match)
					count if _merge == 1
					assert r(N) == 0
					drop _merge
					rename pop2000 pop2000_d
					rename cz par_cz_dest

					* 5.4.2) create gary's matrix
					local rhs=""
					rename par_cz_orig o
					rename par_cz_dest d
					drop if o == 0 | d == 0

					matrix c1 = .
					matrix pop = . 
					matrix czs = . 

					local c1 = " 0 = 0 "
					local i = 1 
					qui foreach p of local places {
					matrix czs = czs \ `p' 
					  gen p`p' = (d == `p')
					  replace p`p' = -1 if o == `p'
					  local rhs "`rhs' p`p'"
					  matrix temp = `p'
					  su pop2000_o if o == `p' 
					  local pop = r(mean)
					  if `pop' == .  {
						su pop2000_d if d == `p'
						local pop = r(mean)
					   }
					  local c1 = "`c1'+`pop'*p`p'"
					  local c_pop`p' = `pop'
					  matrix temp = `pop'
					  matrix pop = pop \ temp
					local i = `i' + 1 
					}
					matrix pop = pop[2...,1]
					matrix czs = czs[2...,1]

					* 5.4.3) Regress beta ij on gary's matrix

					qui reg Bij_`ppp' `rhs' [w=inv_var_`ppp'], nocons
					matrix VCV = e(V)
					matrix b = e(b)

					local r = rowsof(VCV)
					mata: pop = st_matrix("pop")
					mata: b = st_matrix("b")
					mata: b = b'
					mata: VCV = st_matrix("VCV")

					mata: pop_tot = colsum(pop)
					mata: JJ = (pop * J(1,`r',1))/pop_tot
					mata: Q = I(`r') - JJ
					mata: b_dm = Q'*b
					mata: st_matrix("b_dm",b_dm)
					mata: VCV_dm = Q' * VCV * Q
					mata: VCV_vec = diagonal(VCV_dm)
					mata: st_matrix("VCV_vec",VCV_vec)
					mata: st_matrix("VCV_dm",VCV_dm)

					* 5.4.4) Construct dataset with places
					clear

					svmat b_dm
					rename b_dm1 b_dm
					svmat czs
					rename czs1 cz 
					svmat VCV_vec
					rename VCV_vec1 VCV_vec 
					g row = _n

					gen Bj_p`ppp'_cz`outcome'`spec' = b_dm 
					gen Bj_p`ppp'_cz`outcome'`spec'_se = sqrt(VCV_vec)
					
					drop row VCV_vec b_dm

					tempfile final
					save `final'

					merge 1:1 cz using `raw', nogen
					
				count if beta==0 
				local N_zero= r(N)
				
				local N_zero2 = `N_zero'-1 
				tab cz if beta==0 & cz ~= 19400 ,  matrow(badcz) 
				di in red "ERROR : `outcome'`spec' ; Nb beta = 0 is `N_zero2'"
				matrix list badcz

				local bad = `N_zero' 

				}
			}

tempfile perc`ppp'
save `perc`ppp''
}

* 6) Merge percentiles together

foreach ppp in 1 25 50 75 99  { 
merge 1:1 cz using `perc`ppp'', nogen
} 

drop beta
compress
save ${save}\cz_`outcome'`spec'.dta, replace
}		
}		



* SPLIT SAMPLE: KR26

foreach outcome in kr26 { 
foreach spec in _cc2{
foreach splitsample in _c0 _c1 _16_ss1 _16_ss2{

foreach ppp in 1 25 50 75 99 { 

di in red "outcome `outcome'`spec' Parent Rank `ppp'" 

* 1) Input data and generate beta ij and precision weights
use ${irsdata}/cz_2steps_final/beta_v12s_cz`outcome'`spec'`splitsample'.dta , clear
keep if n_od>=25

* 2) Compute beta ij, variance and precision weights
g Bij_`ppp' = -100*(ageatmove + (`ppp'/100) * ageatmove_par_rank_n)
gen var_ageatmove = se_ageatmove^2
gen var_ageatmove_par_rank_n = se_ageatmove_par_rank_n^2
gen var_Bij_p`ppp' = (100^2)*(var_ageatmove +((`ppp'/100)^2)*var_ageatmove_par_rank_n + 2*(`ppp'/100)*cov)
gen inv_var_`ppp' = 1/var_Bij_p`ppp'

tempfile beta_data 
save `beta_data'

* 3) Compute beta j to identify connected sets later on

	* 3.1) create gary's matrix
	local rhs=""
	rename par_cz_orig o
	rename par_cz_dest d
	drop if o == 0 | d == 0
	qui levelsof d, local(d)
	qui levelsof o, local(o)
	local places : list o | d
	qui foreach p of local places {
	if "`p'"!="19400"{ // NY CZ 19400
	  gen p`p' = (d == `p')
	  replace p`p' = -1 if o == `p'
	  local rhs "`rhs' p`p'"
	}
	}

	* 3.2) regress beta ij on gary's matrix
	qui reg Bij_`ppp' `rhs' [w=inv_var_`ppp'], nocons
	clear
	local wc : word count `places'
	set obs `wc'
	gen cz = .
	gen beta = .
	local i = 1
	qui foreach p of local places {
	if "`p'"!="19400"{ // NYC 19400
	  replace cz = `p' in `i'  
	  replace beta = 0 in `i'
	  replace beta = _b[p`p'] in `i'
	  }
	 else if "`p'"=="19400"{
	  replace cz = `p' in `i'
	  replace beta = 0 in `i' 
	}
	  local ++i
	  }
	  
	keep cz beta
	  
	tempfile raw
	save `raw'

* 4) Compute beta j

	use `beta_data', clear

	* 4.1) Merge Populations (for weighting)
	rename par_cz_orig cz 
	merge m:1 cz using ${covariates}cz_characteristics.dta , keepusing(pop2000) keep(master match)
	count if _merge == 1
	assert r(N) == 0
	drop _merge

	rename pop2000 pop2000_o
	rename cz par_cz_orig
	rename par_cz_dest cz 
	merge m:1 cz using ${covariates}cz_characteristics.dta , keepusing(pop2000) keep(master match)
	count if _merge == 1
	assert r(N) == 0
	drop _merge
	rename pop2000 pop2000_d
	rename cz par_cz_dest

	* 4.2) create gary's matrix
	local rhs=""
	rename par_cz_orig o
	rename par_cz_dest d
	drop if o == 0 | d == 0
	qui levelsof d, local(d)
	qui levelsof o, local(o)
	local places : list o | d

	matrix c1 = .
	matrix pop = . 
	matrix czs = . 

	local c1 = " 0 = 0 "
	local i = 1 
	qui foreach p of local places {
	matrix czs = czs \ `p' 
	  gen p`p' = (d == `p')
	  replace p`p' = -1 if o == `p'
	  local rhs "`rhs' p`p'"
	  matrix temp = `p'
	  su pop2000_o if o == `p' 
	  local pop = r(mean)
	  if `pop' == .  {
		su pop2000_d if d == `p'
		local pop = r(mean)
	   }
	  local c1 = "`c1'+`pop'*p`p'"
	  local c_pop`p' = `pop'
	  matrix temp = `pop'
	  matrix pop = pop \ temp
	local i = `i' + 1 
	}
	matrix pop = pop[2...,1]
	matrix czs = czs[2...,1]

	* 4.3) Regress beta ij on gary's matrix

	qui reg Bij_`ppp' `rhs' [w=inv_var_`ppp'], nocons
	matrix VCV = e(V)
	matrix b = e(b)

	local r = rowsof(VCV)
	mata: pop = st_matrix("pop")
	mata: b = st_matrix("b")
	mata: b = b'
	mata: VCV = st_matrix("VCV")

	mata: pop_tot = colsum(pop)
	mata: JJ = (pop * J(1,`r',1))/pop_tot
	mata: Q = I(`r') - JJ
	mata: b_dm = Q'*b
	mata: st_matrix("b_dm",b_dm)
	mata: VCV_dm = Q' * VCV * Q
	mata: VCV_vec = diagonal(VCV_dm)
	mata: st_matrix("VCV_vec",VCV_vec)
	mata: st_matrix("VCV_dm",VCV_dm)

	* 4.4) Construct dataset with places
	clear

	svmat b_dm
	rename b_dm1 b_dm
	svmat czs
	rename czs1 cz 
	svmat VCV_vec
	rename VCV_vec1 VCV_vec 
	g row = _n

	gen Bj_p`ppp'_cz`outcome'`spec'`splitsample' = b_dm 
	gen Bj_p`ppp'_cz`outcome'`spec'`splitsample'_se = sqrt(VCV_vec)
	
	drop row VCV_vec b_dm

	tempfile final
	save `final'

	merge 1:1 cz using `raw', nogen

* 5) Take care of disconnected sets
	
		count if beta==0
		local N_zero = r(N)

			if `N_zero'>1{

			local N_zero2 = `N_zero'-1 
			tab cz if beta==0 & cz ~= 19400 ,  matrow(badcz) 
			di in red "ERROR : `outcome'`spec' ; Nb beta = 0 is `N_zero2'"
			matrix list badcz

			local bad = `N_zero' 
				while `bad' > 1 {

				gen goodcz = .
				replace goodcz = 1 if beta!=0 
				replace goodcz = 1 if cz==19400
				qui levelsof cz if goodcz==1 , local(places)

				* 5.1) Input data and generate beta ij and precision weights
				use ${irsdata}/cz_2steps_final/beta_v12s_cz`outcome'`spec'`splitsample'.dta , clear
				keep if n_od>=25
				local N_badczs = `N_zero' - 1
				forval bads = 1(1)`N_badczs' {
				local badcz = badcz[`bads',1]
				drop if par_cz_orig == `badcz' | par_cz_dest == `badcz'
				}

				* 5.2) Compute beta ij, variance and precision weights
				g Bij_`ppp' = -100*(ageatmove + (`ppp'/100) * ageatmove_par_rank_n)
				gen var_ageatmove = se_ageatmove^2
				gen var_ageatmove_par_rank_n = se_ageatmove_par_rank_n^2
				gen var_Bij_p`ppp' = (100^2)*(var_ageatmove +((`ppp'/100)^2)*var_ageatmove_par_rank_n + 2*(`ppp'/100)*cov)
				gen inv_var_`ppp' = 1/var_Bij_p`ppp'

				tempfile beta_data 
				save `beta_data'

				* 5.3) Compute beta j to identify connected sets later on

					* 5.3.1) create gary's matrix
					local rhs=""
					rename par_cz_orig o
					rename par_cz_dest d
					drop if o == 0 | d == 0
					qui foreach p of local places {
					if "`p'"!="19400"{
					  gen p`p' = (d == `p')
					  replace p`p' = -1 if o == `p'
					  local rhs "`rhs' p`p'"
					}
					}

					* 5.3.2) regress beta ij on gary's matrix
					qui reg Bij_`ppp' `rhs' [w=inv_var_`ppp'], nocons
					clear
					local wc : word count `places'
					set obs `wc'
					gen cz = .
					gen beta = .
					local i = 1
					qui foreach p of local places {
					if "`p'"!="19400"{ 
					  replace cz = `p' in `i'  
					  replace beta = 0 in `i' 
					  replace beta = _b[p`p'] in `i'
					  }
					 else if "`p'"=="19400"{
					  replace cz = `p' in `i'
					  replace beta = 0 in `i' 
					}
					  local ++i
					  }
					  
					 keep cz beta

					tempfile raw
					save `raw'

				* 5.4) Compute beta j

					use `beta_data', clear

					* 5.4.1) Merge Populations (for weighting)
					rename par_cz_orig cz 
					merge m:1 cz using ${covariates}cz_characteristics.dta , keepusing(pop2000) keep(master match)
					count if _merge == 1
					assert r(N) == 0
					drop _merge

					rename pop2000 pop2000_o
					rename cz par_cz_orig
					rename par_cz_dest cz 
					merge m:1 cz using ${covariates}cz_characteristics.dta , keepusing(pop2000) keep(master match)
					count if _merge == 1
					assert r(N) == 0
					drop _merge
					rename pop2000 pop2000_d
					rename cz par_cz_dest

					* 5.4.2) create gary's matrix
					local rhs=""
					rename par_cz_orig o
					rename par_cz_dest d
					drop if o == 0 | d == 0

					matrix c1 = .
					matrix pop = . 
					matrix czs = . 

					local c1 = " 0 = 0 "
					local i = 1 
					qui foreach p of local places {
					matrix czs = czs \ `p' 
					  gen p`p' = (d == `p')
					  replace p`p' = -1 if o == `p'
					  local rhs "`rhs' p`p'"
					  matrix temp = `p'
					  su pop2000_o if o == `p' 
					  local pop = r(mean)
					  if `pop' == .  {
						su pop2000_d if d == `p'
						local pop = r(mean)
					   }
					  local c1 = "`c1'+`pop'*p`p'"
					  local c_pop`p' = `pop'
					  matrix temp = `pop'
					  matrix pop = pop \ temp
					local i = `i' + 1 
					}
					matrix pop = pop[2...,1]
					matrix czs = czs[2...,1]

					* 5.4.3) Regress beta ij on gary's matrix

					qui reg Bij_`ppp' `rhs' [w=inv_var_`ppp'], nocons
					matrix VCV = e(V)
					matrix b = e(b)

					local r = rowsof(VCV)
					mata: pop = st_matrix("pop")
					mata: b = st_matrix("b")
					mata: b = b'
					mata: VCV = st_matrix("VCV")

					mata: pop_tot = colsum(pop)
					mata: JJ = (pop * J(1,`r',1))/pop_tot
					mata: Q = I(`r') - JJ
					mata: b_dm = Q'*b
					mata: st_matrix("b_dm",b_dm)
					mata: VCV_dm = Q' * VCV * Q
					mata: VCV_vec = diagonal(VCV_dm)
					mata: st_matrix("VCV_vec",VCV_vec)
					mata: st_matrix("VCV_dm",VCV_dm)

					* 5.4.4) Construct dataset with places
					clear

					svmat b_dm
					rename b_dm1 b_dm
					svmat czs
					rename czs1 cz 
					svmat VCV_vec
					rename VCV_vec1 VCV_vec 
					g row = _n

					gen Bj_p`ppp'_cz`outcome'`spec'`splitsample' = b_dm 
					gen Bj_p`ppp'_cz`outcome'`spec'`splitsample'_se = sqrt(VCV_vec)
					
					drop row VCV_vec b_dm

					tempfile final
					save `final'

					merge 1:1 cz using `raw', nogen
					
				count if beta==0 
				local N_zero= r(N)
				
				local N_zero2 = `N_zero'-1 
				tab cz if beta==0 & cz ~= 19400 ,  matrow(badcz) 
				di in red "ERROR : `outcome'`spec' ; Nb beta = 0 is `N_zero2'"
				matrix list badcz

				local bad = `N_zero' 

				}
			}

tempfile perc`ppp'
save `perc`ppp''
}

* 6) Merge percentiles together

foreach ppp in 1 25 50 75 99  { 
merge 1:1 cz using `perc`ppp'', nogen
} 

drop beta
compress
save ${save}\cz_`outcome'`spec'`splitsample'.dta, replace
}
}		
}		




* SPLIT SAMPLE: TLPBO

foreach outcome in tlpbo_16 {
foreach spec in _cc2{
foreach splitsample in _ss1 _ss2{

foreach ppp in 1 25 50 75 99 { 

di in red "outcome `outcome'`spec' Parent Rank `ppp'" 

* 1) Input data and generate beta ij and precision weights
use ${irsdata}/cz_2steps_final/beta_v12s_cz`outcome'`spec'`splitsample'.dta , clear
keep if n_od>=25

* 2) Compute beta ij, variance and precision weights
g Bij_`ppp' = -100*(ageatmove + (`ppp'/100) * ageatmove_par_rank_n)
gen var_ageatmove = se_ageatmove^2
gen var_ageatmove_par_rank_n = se_ageatmove_par_rank_n^2
gen var_Bij_p`ppp' = (100^2)*(var_ageatmove +((`ppp'/100)^2)*var_ageatmove_par_rank_n + 2*(`ppp'/100)*cov)
gen inv_var_`ppp' = 1/var_Bij_p`ppp'

tempfile beta_data 
save `beta_data'

* 3) Compute beta j to identify connected sets later on

	* 3.1) create gary's matrix
	local rhs=""
	rename par_cz_orig o
	rename par_cz_dest d
	drop if o == 0 | d == 0
	qui levelsof d, local(d)
	qui levelsof o, local(o)
	local places : list o | d
	qui foreach p of local places {
	if "`p'"!="19400"{ // NY CZ 19400
	  gen p`p' = (d == `p')
	  replace p`p' = -1 if o == `p'
	  local rhs "`rhs' p`p'"
	}
	}

	* 3.2) regress beta ij on gary's matrix
	qui reg Bij_`ppp' `rhs' [w=inv_var_`ppp'], nocons
	clear
	local wc : word count `places'
	set obs `wc'
	gen cz = .
	gen beta = .
	local i = 1
	qui foreach p of local places {
	if "`p'"!="19400"{ // NYC 19400
	  replace cz = `p' in `i'  
	  replace beta = 0 in `i'
	  replace beta = _b[p`p'] in `i'
	  }
	 else if "`p'"=="19400"{
	  replace cz = `p' in `i'
	  replace beta = 0 in `i' 
	}
	  local ++i
	  }
	  
	keep cz beta
	  
	tempfile raw
	save `raw'

* 4) Compute beta j

	use `beta_data', clear

	* 4.1) Merge Populations (for weighting)
	rename par_cz_orig cz 
	merge m:1 cz using ${covariates}cz_characteristics.dta , keepusing(pop2000) keep(master match)
	count if _merge == 1
	assert r(N) == 0
	drop _merge

	rename pop2000 pop2000_o
	rename cz par_cz_orig
	rename par_cz_dest cz 
	merge m:1 cz using ${covariates}cz_characteristics.dta , keepusing(pop2000) keep(master match)
	count if _merge == 1
	assert r(N) == 0
	drop _merge
	rename pop2000 pop2000_d
	rename cz par_cz_dest

	* 4.2) create gary's matrix
	local rhs=""
	rename par_cz_orig o
	rename par_cz_dest d
	drop if o == 0 | d == 0
	qui levelsof d, local(d)
	qui levelsof o, local(o)
	local places : list o | d

	matrix c1 = .
	matrix pop = . 
	matrix czs = . 

	local c1 = " 0 = 0 "
	local i = 1 
	qui foreach p of local places {
	matrix czs = czs \ `p' 
	  gen p`p' = (d == `p')
	  replace p`p' = -1 if o == `p'
	  local rhs "`rhs' p`p'"
	  matrix temp = `p'
	  su pop2000_o if o == `p' 
	  local pop = r(mean)
	  if `pop' == .  {
		su pop2000_d if d == `p'
		local pop = r(mean)
	   }
	  local c1 = "`c1'+`pop'*p`p'"
	  local c_pop`p' = `pop'
	  matrix temp = `pop'
	  matrix pop = pop \ temp
	local i = `i' + 1 
	}
	matrix pop = pop[2...,1]
	matrix czs = czs[2...,1]

	* 4.3) Regress beta ij on gary's matrix

	qui reg Bij_`ppp' `rhs' [w=inv_var_`ppp'], nocons
	matrix VCV = e(V)
	matrix b = e(b)

	local r = rowsof(VCV)
	mata: pop = st_matrix("pop")
	mata: b = st_matrix("b")
	mata: b = b'
	mata: VCV = st_matrix("VCV")

	mata: pop_tot = colsum(pop)
	mata: JJ = (pop * J(1,`r',1))/pop_tot
	mata: Q = I(`r') - JJ
	mata: b_dm = Q'*b
	mata: st_matrix("b_dm",b_dm)
	mata: VCV_dm = Q' * VCV * Q
	mata: VCV_vec = diagonal(VCV_dm)
	mata: st_matrix("VCV_vec",VCV_vec)
	mata: st_matrix("VCV_dm",VCV_dm)

	* 4.4) Construct dataset with places
	clear

	svmat b_dm
	rename b_dm1 b_dm
	svmat czs
	rename czs1 cz 
	svmat VCV_vec
	rename VCV_vec1 VCV_vec 
	g row = _n

	gen Bj_p`ppp'_cz`outcome'`spec'`splitsample' = b_dm 
	gen Bj_p`ppp'_cz`outcome'`spec'`splitsample'_se = sqrt(VCV_vec)
	
	drop row VCV_vec b_dm

	tempfile final
	save `final'

	merge 1:1 cz using `raw', nogen

* 5) Take care of disconnected sets
	
		count if beta==0
		local N_zero = r(N)

			if `N_zero'>1{

			local N_zero2 = `N_zero'-1 
			tab cz if beta==0 & cz ~= 19400 ,  matrow(badcz) 
			di in red "ERROR : `outcome'`spec' ; Nb beta = 0 is `N_zero2'"
			matrix list badcz

			local bad = `N_zero' 
				while `bad' > 1 {

				gen goodcz = .
				replace goodcz = 1 if beta!=0 
				replace goodcz = 1 if cz==19400
				qui levelsof cz if goodcz==1 , local(places)

				* 5.1) Input data and generate beta ij and precision weights
				use ${irsdata}/cz_2steps_final/beta_v12s_cz`outcome'`spec'`splitsample'.dta , clear
				keep if n_od>=25
				local N_badczs = `N_zero' - 1
				forval bads = 1(1)`N_badczs' {
				local badcz = badcz[`bads',1]
				drop if par_cz_orig == `badcz' | par_cz_dest == `badcz'
				}

				* 5.2) Compute beta ij, variance and precision weights
				g Bij_`ppp' = -100*(ageatmove + (`ppp'/100) * ageatmove_par_rank_n)
				gen var_ageatmove = se_ageatmove^2
				gen var_ageatmove_par_rank_n = se_ageatmove_par_rank_n^2
				gen var_Bij_p`ppp' = (100^2)*(var_ageatmove +((`ppp'/100)^2)*var_ageatmove_par_rank_n + 2*(`ppp'/100)*cov)
				gen inv_var_`ppp' = 1/var_Bij_p`ppp'

				tempfile beta_data 
				save `beta_data'

				* 5.3) Compute beta j to identify connected sets later on

					* 5.3.1) create gary's matrix
					local rhs=""
					rename par_cz_orig o
					rename par_cz_dest d
					drop if o == 0 | d == 0
					qui foreach p of local places {
					if "`p'"!="19400"{
					  gen p`p' = (d == `p')
					  replace p`p' = -1 if o == `p'
					  local rhs "`rhs' p`p'"
					}
					}

					* 5.3.2) regress beta ij on gary's matrix
					qui reg Bij_`ppp' `rhs' [w=inv_var_`ppp'], nocons
					clear
					local wc : word count `places'
					set obs `wc'
					gen cz = .
					gen beta = .
					local i = 1
					qui foreach p of local places {
					if "`p'"!="19400"{ 
					  replace cz = `p' in `i'  
					  replace beta = 0 in `i' 
					  replace beta = _b[p`p'] in `i'
					  }
					 else if "`p'"=="19400"{
					  replace cz = `p' in `i'
					  replace beta = 0 in `i' 
					}
					  local ++i
					  }
					  
					 keep cz beta

					tempfile raw
					save `raw'

				* 5.4) Compute beta j

					use `beta_data', clear

					* 5.4.1) Merge Populations (for weighting)
					rename par_cz_orig cz 
					merge m:1 cz using ${covariates}cz_characteristics.dta , keepusing(pop2000) keep(master match)
					count if _merge == 1
					assert r(N) == 0
					drop _merge

					rename pop2000 pop2000_o
					rename cz par_cz_orig
					rename par_cz_dest cz 
					merge m:1 cz using ${covariates}cz_characteristics.dta , keepusing(pop2000) keep(master match)
					count if _merge == 1
					assert r(N) == 0
					drop _merge
					rename pop2000 pop2000_d
					rename cz par_cz_dest

					* 5.4.2) create gary's matrix
					local rhs=""
					rename par_cz_orig o
					rename par_cz_dest d
					drop if o == 0 | d == 0

					matrix c1 = .
					matrix pop = . 
					matrix czs = . 

					local c1 = " 0 = 0 "
					local i = 1 
					qui foreach p of local places {
					matrix czs = czs \ `p' 
					  gen p`p' = (d == `p')
					  replace p`p' = -1 if o == `p'
					  local rhs "`rhs' p`p'"
					  matrix temp = `p'
					  su pop2000_o if o == `p' 
					  local pop = r(mean)
					  if `pop' == .  {
						su pop2000_d if d == `p'
						local pop = r(mean)
					   }
					  local c1 = "`c1'+`pop'*p`p'"
					  local c_pop`p' = `pop'
					  matrix temp = `pop'
					  matrix pop = pop \ temp
					local i = `i' + 1 
					}
					matrix pop = pop[2...,1]
					matrix czs = czs[2...,1]

					* 5.4.3) Regress beta ij on gary's matrix

					qui reg Bij_`ppp' `rhs' [w=inv_var_`ppp'], nocons
					matrix VCV = e(V)
					matrix b = e(b)

					local r = rowsof(VCV)
					mata: pop = st_matrix("pop")
					mata: b = st_matrix("b")
					mata: b = b'
					mata: VCV = st_matrix("VCV")

					mata: pop_tot = colsum(pop)
					mata: JJ = (pop * J(1,`r',1))/pop_tot
					mata: Q = I(`r') - JJ
					mata: b_dm = Q'*b
					mata: st_matrix("b_dm",b_dm)
					mata: VCV_dm = Q' * VCV * Q
					mata: VCV_vec = diagonal(VCV_dm)
					mata: st_matrix("VCV_vec",VCV_vec)
					mata: st_matrix("VCV_dm",VCV_dm)

					* 5.4.4) Construct dataset with places
					clear

					svmat b_dm
					rename b_dm1 b_dm
					svmat czs
					rename czs1 cz 
					svmat VCV_vec
					rename VCV_vec1 VCV_vec 
					g row = _n

					gen Bj_p`ppp'_cz`outcome'`spec'`splitsample' = b_dm 
					gen Bj_p`ppp'_cz`outcome'`spec'`splitsample'_se = sqrt(VCV_vec)
					
					drop row VCV_vec b_dm

					tempfile final
					save `final'

					merge 1:1 cz using `raw', nogen
					
				count if beta==0 
				local N_zero= r(N)
				
				local N_zero2 = `N_zero'-1 
				tab cz if beta==0 & cz ~= 19400 ,  matrow(badcz) 
				di in red "ERROR : `outcome'`spec' ; Nb beta = 0 is `N_zero2'"
				matrix list badcz

				local bad = `N_zero' 

				}
			}

tempfile perc`ppp'
save `perc`ppp''
}

* 6) Merge percentiles together

foreach ppp in 1 25 50 75 99  { 
merge 1:1 cz using `perc`ppp'', nogen
} 

drop beta
compress
save ${save}\cz_`outcome'`spec'`splitsample'.dta, replace
}
}		
}	



