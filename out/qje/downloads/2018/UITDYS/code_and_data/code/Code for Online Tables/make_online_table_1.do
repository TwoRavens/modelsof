*================================================================================
* File: make_online_table_1.do
* Purpose: Makes online data table 1 for the patents paper
* Author: MD and CG, September-October 2017
*================================================================================

*--------------------------------------------------------------------------------
* 0. Housekeeping
*--------------------------------------------------------------------------------

clear all
set rmsg on
global data_dir /home/stataharvard/patents/draft2016/data
global int_data /home/stataharvard/patents/draft2016/make_online_tables/intermediate_data 
global output   /home/stataharvard/patents/draft2016/make_online_tables/output

*--------------------------------------------------------------------------------
* 1. Prepare data for patents online data table 1
*--------------------------------------------------------------------------------


* Load data from kids_10_v1, cohorts 1980-1984
use * if cohort>=1980 & cohort<=1984 using "${data_dir}/kids_10_v1.dta", clear

* Define lifetime_cites and lifetime_cites_adj manually
* Need to do this because lifetime_cites_adj doesnt exist
* Note that lifetime_cites defined this way lines up with inv_precollapse, as expected
egen lcit 	  = sum(fcit), by(kid_tin)
egen lcit_adj = sum(fcit_adj), by(kid_tin)

* Define ranks for lifetime_cites and lifetime_cits_adj by cohort
preserve
	keep if inventor==1
	keep cohort kid_tin lcit lcit_adj
	foreach v of varlist lcit lcit_adj {
		egen rank_`v' = rank(`v'), by(cohort)
		forvalues i=1980/1984 {
			qui sum rank_`v' if cohort == `i'
			if "`r(max)'"!="" {
				qui replace rank_`v' = rank_`v' / `r(max)' if cohort == `i'
			}
		}
	}
	keep kid_tin rank*
	tempfile inventor_ranks
	save `inventor_ranks'
restore

* Merge on inventor ranks and define top 5% citation indicators
merge 1:1 kid_tin using `inventor_ranks', keepusing(rank_*) keep(1 3) nogen
gen top5cit  = 1 if (rank_lcit > 0.95 & ~mi(rank_lcit))
gen top5cita = 1 if (rank_lcit_adj > 0.95 & ~mi(rank_lcit_adj))
rename par_cz_1996 par_cz
replace inventor=. if inventor==0
forvalues i = 1/7 {
	gen cat_prim_kid_`i' = 1 if cat_prim_kid == `i' 
	gen top5cit_cat_`i' = 1 if cat_prim_kid == `i' & top5cit ==1
	gen top5cita_cat_`i' = 1 if cat_prim_kid == `i' & top5cita ==1
}

* Save prepped microdata for table 1
save "${int_data}/table1_input", replace

*--------------------------------------------------------------------------------
* 2. Loop over CZ and state geographies, collapse counts by geo
*--------------------------------------------------------------------------------

foreach geo in cz st {

	* Load input data
	use "${int_data}/table1_input", clear
	
	* Counts, pooled gender and income
	preserve
		collapse ///
			(count) kid_count=kid_tin inventor top5cit top5cita ///
					inventor_cat_1=cat_prim_kid_1 inventor_cat_2=cat_prim_kid_2 inventor_cat_3=cat_prim_kid_3 ///
					inventor_cat_4=cat_prim_kid_4 inventor_cat_5=cat_prim_kid_5 inventor_cat_6=cat_prim_kid_6 ///
					inventor_cat_7=cat_prim_kid_7 ///
					top5cit_cat_1 top5cit_cat_2 top5cit_cat_3 top5cit_cat_4 top5cit_cat_5 top5cit_cat_6 top5cit_cat_7 ///
					top5cita_cat_1 top5cita_cat_2 top5cita_cat_3 top5cita_cat_4 top5cita_cat_5 top5cita_cat_6 top5cita_cat_7 ///
			, by(par_`geo')
		local count inventor top5cit top5cita inventor_cat_1 inventor_cat_2 inventor_cat_3 inventor_cat_4 inventor_cat_5 ///
			inventor_cat_6 inventor_cat_7 top5cit_cat_1 top5cit_cat_2 top5cit_cat_3 top5cit_cat_4 top5cit_cat_5 ///
			top5cit_cat_6 top5cit_cat_7 top5cita_cat_1 top5cita_cat_2 top5cita_cat_3 top5cita_cat_4 ///
			top5cita_cat_5 top5cita_cat_6 top5cita_cat_7
	
		foreach i of local count {
			replace `i' = `i'/kid_count
		}
		tempfile kid_count_`geo'_total
		save `kid_count_`geo'_total', replace
	restore
	
	* Counts, by gender
	replace kid_gnd="m" if kid_gnd=="M"
	replace kid_gnd="f" if kid_gnd=="F"
	foreach gnd in m f {
		preserve
			keep if kid_gnd=="`gnd'"
			collapse ///
				(count) kid_count=kid_tin inventor top5cit top5cita ///
					inventor_cat_1=cat_prim_kid_1 inventor_cat_2=cat_prim_kid_2 inventor_cat_3=cat_prim_kid_3 ///
					inventor_cat_4=cat_prim_kid_4 inventor_cat_5=cat_prim_kid_5 inventor_cat_6=cat_prim_kid_6 ///
					inventor_cat_7=cat_prim_kid_7 ///
					top5cit_cat_1 top5cit_cat_2 top5cit_cat_3 top5cit_cat_4 top5cit_cat_5 top5cit_cat_6 top5cit_cat_7 ///
					top5cita_cat_1 top5cita_cat_2 top5cita_cat_3 top5cita_cat_4 top5cita_cat_5 top5cita_cat_6 top5cita_cat_7 ///
				, by(par_`geo')
			local count inventor top5cit top5cita inventor_cat_1 inventor_cat_2 inventor_cat_3 inventor_cat_4 inventor_cat_5 ///
				inventor_cat_6 inventor_cat_7 top5cit_cat_1 top5cit_cat_2 top5cit_cat_3 top5cit_cat_4 top5cit_cat_5 ///
				top5cit_cat_6 top5cit_cat_7 top5cita_cat_1 top5cita_cat_2 top5cita_cat_3 top5cita_cat_4 ///
				top5cita_cat_5 top5cita_cat_6 top5cita_cat_7
			foreach i of local count {
				replace `i' = `i'/kid_count
			}
			rename * *_g_`gnd'	
			rename par_`geo'_g_`gnd' par_`geo'
			tempfile kid_count_`geo'_g_`gnd'
			save `kid_count_`geo'_g_`gnd'', replace
		restore
	}
	
	* Counts, by parent quintile
	gen par_rank_n_1 = 1 if par_rank_n>0   & par_rank_n<=0.2
	gen par_rank_n_2 = 1 if par_rank_n>0.2 & par_rank_n<=0.4
	gen par_rank_n_3 = 1 if par_rank_n>0.4 & par_rank_n<=0.6
	gen par_rank_n_4 = 1 if par_rank_n>0.6 & par_rank_n<=0.8
	gen par_rank_n_5 = 1 if par_rank_n>0.8 & par_rank_n<=1
	forvalues quin = 1/5 {
		preserve
			keep if par_rank_n_`quin'==1
			collapse ///
				(count) kid_count=kid_tin inventor top5cit top5cita ///
						inventor_cat_1=cat_prim_kid_1 inventor_cat_2=cat_prim_kid_2 inventor_cat_3=cat_prim_kid_3 ///
						inventor_cat_4=cat_prim_kid_4 inventor_cat_5=cat_prim_kid_5 inventor_cat_6=cat_prim_kid_6 ///
						inventor_cat_7=cat_prim_kid_7 ///
						top5cit_cat_1 top5cit_cat_2 top5cit_cat_3 top5cit_cat_4 top5cit_cat_5 top5cit_cat_6 top5cit_cat_7 ///
						top5cita_cat_1 top5cita_cat_2 top5cita_cat_3 top5cita_cat_4 top5cita_cat_5 top5cita_cat_6 top5cita_cat_7 ///
				, by(par_`geo')
			local count inventor top5cit top5cita inventor_cat_1 inventor_cat_2 inventor_cat_3 inventor_cat_4 inventor_cat_5 ///
					inventor_cat_6 inventor_cat_7 top5cit_cat_1 top5cit_cat_2 top5cit_cat_3 top5cit_cat_4 top5cit_cat_5 ///
					top5cit_cat_6 top5cit_cat_7 top5cita_cat_1 top5cita_cat_2 top5cita_cat_3 top5cita_cat_4 ///
					top5cita_cat_5 top5cita_cat_6 top5cita_cat_7
		  
			foreach i of local count {
				replace `i' = `i'/kid_count
			}
			rename * *_q_`quin'	
			rename par_`geo'_q_`quin' par_`geo'
			tempfile kid_count_`geo'_q_`quin'
			save `kid_count_`geo'_q_`quin'', replace
		restore
	}
	
	* Merge together all counts
	use `kid_count_`geo'_total', clear
	merge 1:1 par_`geo' using `kid_count_`geo'_g_m', nogen
	merge 1:1 par_`geo' using `kid_count_`geo'_g_f', nogen
	forvalues quin = 1/5 {
		merge 1:1 par_`geo' using `kid_count_`geo'_q_`quin'', nogen
	}
	save "${output}/table_1_`geo'", replace
	
	* Mask and save
	des inventor top5cit top5cita inventor_cat_1 inventor_cat_2 inventor_cat_3 inventor_cat_4 inventor_cat_5 ///
		inventor_cat_6 inventor_cat_7 top5cit_cat_1 top5cit_cat_2 top5cit_cat_3 top5cit_cat_4 top5cit_cat_5 ///
		top5cit_cat_6 top5cit_cat_7 top5cita_cat_1 top5cita_cat_2 top5cita_cat_3 top5cita_cat_4 ///
		top5cita_cat_5 top5cita_cat_6 top5cita_cat_7
	foreach var in `r(varlist)' {
		replace `var'=. if kid_count<10
	}
	replace kid_count=. if kid_count<10
	foreach gnd in m f {
		des inventor_g_`gnd' top5cit_g_`gnd' top5cita_g_`gnd' inventor_cat_1_g_`gnd' inventor_cat_2_g_`gnd' inventor_cat_3_g_`gnd' inventor_cat_4_g_`gnd' inventor_cat_5_g_`gnd' ///
					inventor_cat_6_g_`gnd' inventor_cat_7_g_`gnd' top5cit_cat_1_g_`gnd' top5cit_cat_2_g_`gnd' top5cit_cat_3_g_`gnd' top5cit_cat_4_g_`gnd' top5cit_cat_5_g_`gnd' ///
					top5cit_cat_6_g_`gnd' top5cit_cat_7_g_`gnd' top5cita_cat_1_g_`gnd' top5cita_cat_2_g_`gnd' top5cita_cat_3_g_`gnd' top5cita_cat_4_g_`gnd' ///
					top5cita_cat_5_g_`gnd' top5cita_cat_6_g_`gnd' top5cita_cat_7_g_`gnd'
			foreach var in `r(varlist)' {
				replace `var'=. if kid_count_g_`gnd'<10
			}
		replace kid_count_g_`gnd'=. if kid_count_g_`gnd'<10
	}
	forvalues quin=1/5 {
		des inventor_q_`quin' top5cit_q_`quin' top5cita_q_`quin' inventor_cat_1_q_`quin' inventor_cat_2_q_`quin' inventor_cat_3_q_`quin' inventor_cat_4_q_`quin' inventor_cat_5_q_`quin' ///
					inventor_cat_6_q_`quin' inventor_cat_7_q_`quin' top5cit_cat_1_q_`quin' top5cit_cat_2_q_`quin' top5cit_cat_3_q_`quin' top5cit_cat_4_q_`quin' top5cit_cat_5_q_`quin' ///
					top5cit_cat_6_q_`quin' top5cit_cat_7_q_`quin' top5cita_cat_1_q_`quin' top5cita_cat_2_q_`quin' top5cita_cat_3_q_`quin' top5cita_cat_4_q_`quin' ///
					top5cita_cat_5_q_`quin' top5cita_cat_6_q_`quin' top5cita_cat_7_q_`quin'
		foreach var in `r(varlist)' {
			replace `var'=. if kid_count_q_`quin'<10
		}
		replace kid_count_q_`quin'=. if kid_count_q_`quin'<10
	}
	
	* Save masked tables out
	if "`geo'"=="cz" {
		save "${output}/table_1a", replace
	}
	if "`geo'"=="st" {
		save "${output}/table_1b", replace
	}
		
}
