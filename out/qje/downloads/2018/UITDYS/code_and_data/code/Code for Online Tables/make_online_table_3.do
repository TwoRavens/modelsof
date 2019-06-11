*================================================================================
* File: make_online_table_3.do
* Purpose: Makes online data table 3 for the patents paper
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
* 1. Prepare data for patents online data table 3
*--------------------------------------------------------------------------------

* Load data from event_20_v1
use "${data_dir}/event_20_v1", clear
rename (tax_yr non_spouse_f1040) (yr total_inc)

* Construct lifetime citations and adjusted lifetime citations manually
egen lcit = sum(fcit), by(tin)

* Make within-age-year ranks for fcit_adj and fcit for inventors (inventor==1)
preserve
	keep if patents > 0 & ~mi(patents)
	keep tin yr age lcit
	gen cohort = yr - age
	foreach v of varlist lcit {
		egen rank_`v' = rank(`v'), by(cohort)
		forvalues j = 1900/1984 {
			qui sum rank_`v' if cohort==`j'
			if "`r(max)'"!="" {
				qui replace rank_`v' = rank_`v' / `r(max)' if cohort==`j'
			}
		}
	}
	keep tin yr rank*
	tempfile inventor_ranks
	save `inventor_ranks'
restore
merge 1:1 tin yr using `inventor_ranks', keepusing(rank_*) keep(1 3) nogen

* Generate indicators for top 5% citations
gen top5cit 	 = 1 if (rank_lcit 		> 0.95 	& ~mi(rank_lcit))
replace top5cit  = 0 if (rank_lcit 		<= 0.95 & ~mi(rank_lcit))

* Save prepped microdata for table 3
save "${int_data}/table3_input", replace

*--------------------------------------------------------------------------------
* 2. Counts by age-year, age pooling years, year pooling ages, and pooled
*--------------------------------------------------------------------------------

* Counts by age-year
use tin age yr top5cit total_inc if total_inc!=. & ~mi(age) & ~mi(yr) using "${int_data}/table3_input", clear
gen x1 = tin               	// use this variable to count all inventors
gen x2 = tin if top5cit==1 	// use this variable to count top 5% cited inventors
gcollapse (count) count_all=x1 count_top5cit=x2, by(age yr)
save "${int_data}/count_age_yr.dta", replace

* Counts by age, pooled across years
use tin age yr top5cit total_inc if total_inc!=. & ~mi(age) & ~mi(yr) using "${int_data}/table3_input", clear
gen x1 = tin               	// use this variable to count all inventors
gen x2 = tin if top5cit==1 	// use this variable to count top 5% cited inventors
gcollapse (count) count_all=x1 count_top5cit=x2 , by(age)
gen yr = .
append using "${int_data}/count_age_yr.dta"
save "${int_data}/count_age_yr.dta", replace

* Counts by year, pooled across ages
use tin age yr top5cit total_inc if total_inc!=. & ~mi(age) & ~mi(yr) using "${int_data}/table3_input", clear
gen x1 = tin               	// use this variable to count all inventors
gen x2 = tin if top5cit==1 	// use this variable to count top 5% cited inventors
gcollapse (count) count_all=x1 count_top5cit=x2, by(yr)
gen age = .
append using "${int_data}/count_age_yr.dta"
save "${int_data}/count_age_yr.dta", replace

* Counts, pooled across ages and years
use tin age yr top5cit total_inc if total_inc!=. & ~mi(age) & ~mi(yr) using "${int_data}/table3_input", clear
gen x1 = tin               	// use this variable to count all inventors
gen x2 = tin if top5cit==1 	// use this variable to count top 5% cited inventors
gcollapse (count) count_all=x1 count_top5cit=x2
gen yr  = .
gen age = .
append using "${int_data}/count_age_yr.dta"
save "${int_data}/count_age_yr.dta", replace
*/
*--------------------------------------------------------------------------------
* 3. Collapse decile cut points for each outcome by age-year
*--------------------------------------------------------------------------------

use tin age yr total_inc nw_inc w2_inc top5cit if ~mi(age) & ~mi(yr) using "${int_data}/table3_input", clear
		
gen total_inc_top5cit  	= total_inc if top5cit==1
gen nw_inc_top5cit  	= nw_inc 	if top5cit==1
gen w2_inc_top5cit  	= w2_inc 	if top5cit==1

* Produce decile cutpoints 
gcollapse ///
		(mean) total_inc_mean 		  = total_inc ///
			   nw_inc_mean    		  = nw_inc ///
			   w2_inc_mean    		  = w2_inc ///
			   total_inc_top5cit_mean = total_inc_top5cit ///
			   nw_inc_top5cit_mean    = nw_inc_top5cit ///
			   w2_inc_top5cit_mean    = w2_inc_top5cit ///
		 (p10) total_inc_p10 		  = total_inc ///
			   nw_inc_p10    		  = nw_inc ///
			   w2_inc_p10    		  = w2_inc ///
			   total_inc_top5cit_p10  = total_inc_top5cit ///
			   nw_inc_top5cit_p10  	  = nw_inc_top5cit ///
			   w2_inc_top5cit_p10     = w2_inc_top5cit ///
		 (p20) total_inc_p20 		  = total_inc ///
			   nw_inc_p20    		  = nw_inc ///
			   w2_inc_p20    		  = w2_inc ///
			   total_inc_top5cit_p20  = total_inc_top5cit ///
			   nw_inc_top5cit_p20  	  = nw_inc_top5cit ///
			   w2_inc_top5cit_p20     = w2_inc_top5cit ///
		 (p30) total_inc_p30 		  = total_inc ///
			   nw_inc_p30    		  = nw_inc ///
			   w2_inc_p30    		  = w2_inc ///
			   total_inc_top5cit_p30  = total_inc_top5cit ///
			   nw_inc_top5cit_p30  	  = nw_inc_top5cit ///
			   w2_inc_top5cit_p30     = w2_inc_top5cit ///
		 (p40) total_inc_p40 		  = total_inc ///
			   nw_inc_p40    		  = nw_inc ///
			   w2_inc_p40    		  = w2_inc ///
			   total_inc_top5cit_p40  = total_inc_top5cit ///
			   nw_inc_top5cit_p40  	  = nw_inc_top5cit ///
			   w2_inc_top5cit_p40     = w2_inc_top5cit ///
		 (p50) total_inc_p50 		  = total_inc ///
			   nw_inc_p50    		  = nw_inc ///
			   w2_inc_p50    		  = w2_inc ///
			   total_inc_top5cit_p50  = total_inc_top5cit ///
			   nw_inc_top5cit_p50  	  = nw_inc_top5cit ///
			   w2_inc_top5cit_p50     = w2_inc_top5cit ///
		 (p60) total_inc_p60 		  = total_inc ///
			   nw_inc_p60    		  = nw_inc ///
			   w2_inc_p60    		  = w2_inc ///
			   total_inc_top5cit_p60  = total_inc_top5cit ///
			   nw_inc_top5cit_p60  	  = nw_inc_top5cit ///
			   w2_inc_top5cit_p60     = w2_inc_top5cit ///
		 (p70) total_inc_p70 		  = total_inc ///
			   nw_inc_p70    		  = nw_inc ///
			   w2_inc_p70    		  = w2_inc ///
			   total_inc_top5cit_p70  = total_inc_top5cit ///
			   nw_inc_top5cit_p70  	  = nw_inc_top5cit ///
			   w2_inc_top5cit_p70     = w2_inc_top5cit ///
		 (p80) total_inc_p80 		  = total_inc ///
			   nw_inc_p80    		  = nw_inc ///
			   w2_inc_p80    		  = w2_inc ///
			   total_inc_top5cit_p80  = total_inc_top5cit ///
			   nw_inc_top5cit_p80  	  = nw_inc_top5cit ///
			   w2_inc_top5cit_p80     = w2_inc_top5cit ///
		 (p90) total_inc_p90 		  = total_inc ///
			   nw_inc_p90    		  = nw_inc ///
			   w2_inc_p90    		  = w2_inc ///
			   total_inc_top5cit_p90  = total_inc_top5cit ///
			   nw_inc_top5cit_p90  	  = nw_inc_top5cit ///
			   w2_inc_top5cit_p90     = w2_inc_top5cit /// 
		 (p99) total_inc_p99 		  = total_inc ///
			   nw_inc_p99    		  = nw_inc ///
			   w2_inc_p99    		  = w2_inc ///
			   total_inc_top5cit_p99  = total_inc_top5cit ///
			   nw_inc_top5cit_p99  	  = nw_inc_top5cit ///
			   w2_inc_top5cit_p99     = w2_inc_top5cit ///
			, by(age yr)
			
* Save because the step above took a while
save "${int_data}/distrib_age_yr_temp", replace
use "${int_data}/distrib_age_yr_temp", clear	

* Round each quantile to nearest $100
qui ds age yr, not
qui foreach i in `r(varlist)' {
	replace `i'=round(`i', 100)
}

* Mask pooled quantiles
merge 1:1 age yr using "${int_data}/count_age_yr.dta", nogen keep(1 3)
ds total_inc_p* nw_inc_p* w2_inc_p* total_inc_mean nw_inc_mean w2_inc_mean
qui foreach var in `r(varlist)' {
	replace `var' = . if count_all <10
}
qui replace count_all=. if count_all < 10

* Mask top5cit quantiles
ds *_top5cit_p* *_top5cit_mean
qui foreach var in `r(varlist)' {
	replace `var' = . if count_top5cit < 10
}
qui replace count_top5cit = . if count_top5cit< 10
	
save "${int_data}/distrib_age_yr", replace

*--------------------------------------------------------------------------------
* 4. Collapse decile cut points for each outcome by age, pooling across years
*--------------------------------------------------------------------------------

use tin age yr total_inc nw_inc w2_inc top5cit if ~mi(age) & ~mi(yr) using "${int_data}/table3_input", clear
replace yr = .
gen total_inc_top5cit  	= total_inc if top5cit==1
gen nw_inc_top5cit  	= nw_inc 	if top5cit==1
gen w2_inc_top5cit  	= w2_inc 	if top5cit==1

* Produce decile cutpoints 
gcollapse ///
		(mean) total_inc_mean 		  = total_inc ///
			   nw_inc_mean    		  = nw_inc ///
			   w2_inc_mean    		  = w2_inc ///
			   total_inc_top5cit_mean = total_inc_top5cit ///
			   nw_inc_top5cit_mean    = nw_inc_top5cit ///
			   w2_inc_top5cit_mean    = w2_inc_top5cit ///
		 (p10) total_inc_p10 		  = total_inc ///
			   nw_inc_p10    		  = nw_inc ///
			   w2_inc_p10    		  = w2_inc ///
			   total_inc_top5cit_p10  = total_inc_top5cit ///
			   nw_inc_top5cit_p10  	  = nw_inc_top5cit ///
			   w2_inc_top5cit_p10     = w2_inc_top5cit ///
		 (p20) total_inc_p20 		  = total_inc ///
			   nw_inc_p20    		  = nw_inc ///
			   w2_inc_p20    		  = w2_inc ///
			   total_inc_top5cit_p20  = total_inc_top5cit ///
			   nw_inc_top5cit_p20  	  = nw_inc_top5cit ///
			   w2_inc_top5cit_p20     = w2_inc_top5cit ///
		 (p30) total_inc_p30 		  = total_inc ///
			   nw_inc_p30    		  = nw_inc ///
			   w2_inc_p30    		  = w2_inc ///
			   total_inc_top5cit_p30  = total_inc_top5cit ///
			   nw_inc_top5cit_p30  	  = nw_inc_top5cit ///
			   w2_inc_top5cit_p30     = w2_inc_top5cit ///
		 (p40) total_inc_p40 		  = total_inc ///
			   nw_inc_p40    		  = nw_inc ///
			   w2_inc_p40    		  = w2_inc ///
			   total_inc_top5cit_p40  = total_inc_top5cit ///
			   nw_inc_top5cit_p40  	  = nw_inc_top5cit ///
			   w2_inc_top5cit_p40     = w2_inc_top5cit ///
		 (p50) total_inc_p50 		  = total_inc ///
			   nw_inc_p50    		  = nw_inc ///
			   w2_inc_p50    		  = w2_inc ///
			   total_inc_top5cit_p50  = total_inc_top5cit ///
			   nw_inc_top5cit_p50  	  = nw_inc_top5cit ///
			   w2_inc_top5cit_p50     = w2_inc_top5cit ///
		 (p60) total_inc_p60 		  = total_inc ///
			   nw_inc_p60    		  = nw_inc ///
			   w2_inc_p60    		  = w2_inc ///
			   total_inc_top5cit_p60  = total_inc_top5cit ///
			   nw_inc_top5cit_p60  	  = nw_inc_top5cit ///
			   w2_inc_top5cit_p60     = w2_inc_top5cit ///
		 (p70) total_inc_p70 		  = total_inc ///
			   nw_inc_p70    		  = nw_inc ///
			   w2_inc_p70    		  = w2_inc ///
			   total_inc_top5cit_p70  = total_inc_top5cit ///
			   nw_inc_top5cit_p70  	  = nw_inc_top5cit ///
			   w2_inc_top5cit_p70     = w2_inc_top5cit ///
		 (p80) total_inc_p80 		  = total_inc ///
			   nw_inc_p80    		  = nw_inc ///
			   w2_inc_p80    		  = w2_inc ///
			   total_inc_top5cit_p80  = total_inc_top5cit ///
			   nw_inc_top5cit_p80  	  = nw_inc_top5cit ///
			   w2_inc_top5cit_p80     = w2_inc_top5cit ///
		 (p90) total_inc_p90 		  = total_inc ///
			   nw_inc_p90    		  = nw_inc ///
			   w2_inc_p90    		  = w2_inc ///
			   total_inc_top5cit_p90  = total_inc_top5cit ///
			   nw_inc_top5cit_p90  	  = nw_inc_top5cit ///
			   w2_inc_top5cit_p90     = w2_inc_top5cit /// 
		 (p99) total_inc_p99 		  = total_inc ///
			   nw_inc_p99    		  = nw_inc ///
			   w2_inc_p99    		  = w2_inc ///
			   total_inc_top5cit_p99  = total_inc_top5cit ///
			   nw_inc_top5cit_p99  	  = nw_inc_top5cit ///
			   w2_inc_top5cit_p99     = w2_inc_top5cit /// 
			, by(age yr)
			
* Save because the above took a while
save "${int_data}/distrib_age_temp", replace
use "${int_data}/distrib_age_temp", clear
			
* Round each quantile to nearest $100
qui ds age yr, not
qui foreach i in `r(varlist)' {
	qui replace `i'=round(`i', 100)
}

* Mask pooled quantiles
merge 1:1 age yr using "${int_data}/count_age_yr.dta", nogen keep(1 3)
ds total_inc_p* nw_inc_p* w2_inc_p* total_inc_mean nw_inc_mean w2_inc_mean
qui foreach var in `r(varlist)' {
	replace `var' = . if count_all <10
}
qui replace count_all=. if count_all < 10

* Mask top5cit quantiles
ds *_top5cit_p* *_top5cit_mean
qui foreach var in `r(varlist)' {
	replace `var' = . if count_top5cit <10
}
qui replace count_top5cit=. if count_top5cit < 10

* Save out
save "${int_data}/distrib_age", replace

*--------------------------------------------------------------------------------
* 5. Collapse decile cut points for each outcome by year, pooling across ages
*--------------------------------------------------------------------------------

use tin age yr total_inc nw_inc w2_inc top5cit if ~mi(age) & ~mi(yr) using "${int_data}/table3_input", clear
replace age = .
gen total_inc_top5cit  	= total_inc if top5cit==1
gen nw_inc_top5cit  	= nw_inc 	if top5cit==1
gen w2_inc_top5cit  	= w2_inc 	if top5cit==1

* Produce decile cutpoints 
gcollapse ///
		(mean) total_inc_mean 		  = total_inc ///
			   nw_inc_mean    		  = nw_inc ///
			   w2_inc_mean    		  = w2_inc ///
			   total_inc_top5cit_mean = total_inc_top5cit ///
			   nw_inc_top5cit_mean    = nw_inc_top5cit ///
			   w2_inc_top5cit_mean    = w2_inc_top5cit ///
		 (p10) total_inc_p10 		  = total_inc ///
			   nw_inc_p10    		  = nw_inc ///
			   w2_inc_p10    		  = w2_inc ///
			   total_inc_top5cit_p10  = total_inc_top5cit ///
			   nw_inc_top5cit_p10  	  = nw_inc_top5cit ///
			   w2_inc_top5cit_p10     = w2_inc_top5cit ///
		 (p20) total_inc_p20 		  = total_inc ///
			   nw_inc_p20    		  = nw_inc ///
			   w2_inc_p20    		  = w2_inc ///
			   total_inc_top5cit_p20  = total_inc_top5cit ///
			   nw_inc_top5cit_p20  	  = nw_inc_top5cit ///
			   w2_inc_top5cit_p20     = w2_inc_top5cit ///
		 (p30) total_inc_p30 		  = total_inc ///
			   nw_inc_p30    		  = nw_inc ///
			   w2_inc_p30    		  = w2_inc ///
			   total_inc_top5cit_p30  = total_inc_top5cit ///
			   nw_inc_top5cit_p30  	  = nw_inc_top5cit ///
			   w2_inc_top5cit_p30     = w2_inc_top5cit ///
		 (p40) total_inc_p40 		  = total_inc ///
			   nw_inc_p40    		  = nw_inc ///
			   w2_inc_p40    		  = w2_inc ///
			   total_inc_top5cit_p40  = total_inc_top5cit ///
			   nw_inc_top5cit_p40  	  = nw_inc_top5cit ///
			   w2_inc_top5cit_p40     = w2_inc_top5cit ///
		 (p50) total_inc_p50 		  = total_inc ///
			   nw_inc_p50    		  = nw_inc ///
			   w2_inc_p50    		  = w2_inc ///
			   total_inc_top5cit_p50  = total_inc_top5cit ///
			   nw_inc_top5cit_p50  	  = nw_inc_top5cit ///
			   w2_inc_top5cit_p50     = w2_inc_top5cit ///
		 (p60) total_inc_p60 		  = total_inc ///
			   nw_inc_p60    		  = nw_inc ///
			   w2_inc_p60    		  = w2_inc ///
			   total_inc_top5cit_p60  = total_inc_top5cit ///
			   nw_inc_top5cit_p60  	  = nw_inc_top5cit ///
			   w2_inc_top5cit_p60     = w2_inc_top5cit ///
		 (p70) total_inc_p70 		  = total_inc ///
			   nw_inc_p70    		  = nw_inc ///
			   w2_inc_p70    		  = w2_inc ///
			   total_inc_top5cit_p70  = total_inc_top5cit ///
			   nw_inc_top5cit_p70  	  = nw_inc_top5cit ///
			   w2_inc_top5cit_p70     = w2_inc_top5cit ///
		 (p80) total_inc_p80 		  = total_inc ///
			   nw_inc_p80    		  = nw_inc ///
			   w2_inc_p80    		  = w2_inc ///
			   total_inc_top5cit_p80  = total_inc_top5cit ///
			   nw_inc_top5cit_p80  	  = nw_inc_top5cit ///
			   w2_inc_top5cit_p80     = w2_inc_top5cit ///
		 (p90) total_inc_p90 		  = total_inc ///
			   nw_inc_p90    		  = nw_inc ///
			   w2_inc_p90    		  = w2_inc ///
			   total_inc_top5cit_p90  = total_inc_top5cit ///
			   nw_inc_top5cit_p90  	  = nw_inc_top5cit ///
			   w2_inc_top5cit_p90     = w2_inc_top5cit ///
		 (p99) total_inc_p99 		  = total_inc ///
			   nw_inc_p99    		  = nw_inc ///
			   w2_inc_p99    		  = w2_inc ///
			   total_inc_top5cit_p99  = total_inc_top5cit ///
			   nw_inc_top5cit_p99  	  = nw_inc_top5cit ///
			   w2_inc_top5cit_p99     = w2_inc_top5cit ///
			, by(age yr)
			

* Save because the above took a while
save "${int_data}/distrib_yr_temp", replace
use "${int_data}/distrib_yr_temp", clear

* Round each quantile to nearest $100
qui ds age yr, not
foreach i in `r(varlist)' {
	replace `i'=round(`i', 100)
}

* Mask pooled quantiles
merge 1:1 age yr using "${int_data}/count_age_yr.dta", nogen keep(1 3)
ds total_inc_p* nw_inc_p* w2_inc_p* total_inc_mean nw_inc_mean w2_inc_mean
qui foreach var in `r(varlist)' {
	replace `var' = . if count_all <10
}
qui replace count_all=. if count_all < 10

* Mask top5cit quantiles
ds *_top5cit_p* *_top5cit_mean
qui foreach var in `r(varlist)' {
	replace `var' = . if count_top5cit <10
}
qui replace count_top5cit=. if count_top5cit < 10

* Save out		
save "${int_data}/distrib_yr", replace

*--------------------------------------------------------------------------------
* Merge everything together
*--------------------------------------------------------------------------------

* Append all three datasets above
use "${int_data}/distrib_age_yr", clear
append using "${int_data}/distrib_yr"
append using "${int_data}/distrib_age"

* Save out
save "${output}/table_3.dta", replace

