*===============================================================================
* File: format_online_tables.do
* Purpose: formats online tables for Patents
*===============================================================================

* Set convenient globals
global online_tables "${dropbox}/patents/online_tables"
global output "${online_tables}/aj_explore"

* Log
cap log close
log using "${output}/format_online_tables", replace

*-------------------------------------------------------------------------------
* Table 1 - Innovation Rates by Childhood CZ/State, Gender and Parent Income
*-------------------------------------------------------------------------------

* Convenient macro for cleaning table 1a and 1b
cap program drop cleantab1
program define cleantab1
	drop *top5cita*
	rename (state_id stateabbrv) (par_state par_stateabbrv)
	forvalues q = 1/5{
			rename kid_count_q_`q' kid_count_pq_`q'
	}	
	foreach stub in inventor top5cit {
		forvalues q = 1/5{
			rename `stub'_q_`q' `stub'_pq_`q'
		}
		forvalues i = 1/7 {
		forvalues q = 1/5 {
			rename `stub'_cat_`i'_q_`q' `stub'_cat_`i'_pq_`q'
		}
		}
	}
	lab var par_state			"Childhood state FIPS code"
	lab var par_stateabbrv		"State abbreviation"
	lab var kid_count 	  		"Number of children" 
	lab var kid_count_g_f 		"Number of female children" 
	lab var kid_count_g_m 		"Number of male children" 
	forvalues q = 1/5{
		lab var kid_count_pq_`q' "Number of children with parents in Q`q'" 
	}
	foreach stub in inventor top5cit {
		if "`stub'" == "inventor"   local outcome "who become inventors"
		if "`stub'" == "top5cit"    local outcome "with total citations in top 5%"
		lab var `stub' 	   		"Share of children `outcome'"
		lab var `stub'_g_m 		"Share of males `outcome'"
		lab var `stub'_g_f 		"Share of females `outcome'"
		forvalues q = 1/5{
			lab var inventor_pq_`q' "Share of children who invent among those with parents in Q`q'"
			lab var top5cit_pq_`q'  "Share of children with citations in top 5% given parents in Q`q'"
		}
		forvalues i = 1/7 {
			if `i' == 1 local cat "chemical"
			if `i' == 2 local cat "computers and communications"
			if `i' == 3 local cat "drugs and medical"
			if `i' == 4 local cat "electrical and electronic"
			if `i' == 5 local cat "mechanical"
			if `i' == 6 local cat "others"
			if `i' == 7 local cat "design and plant"
			if "`stub'" == "inventor" local outcome ""
			if "`stub'" == "top5cit"  local outcome " and have citations in top 5%"
			foreach gender in "" "_g_m" "_g_f"{
				local sample ""
				if "`gender'" == "_g_m" local sample " of males"
				if "`gender'" == "_g_f" local sample " of females"
				lab var inventor_cat_`i'`gender' "Share`sample' who patent in category `i' (`cat')"
				lab var top5cit_cat_`i'`gender'	 "Share`sample' who patent in category `i' and have total citations in top 5%"	
				forvalues q = 1/5 {
					lab var `stub'_cat_`i'_pq_`q' ///
					"Share who patent in cat `i'`outcome' given parents in Q`q' "
				}
			}
		}
	}
	
	* Mask vars at 250
	foreach v of varlist inventor-top5cit_cat_7_pq_5 kid_count {
		qui replace `v'=. if kid_count<250 | mi(kid_count)
	}
	* mask quintile-specific vars at 250
	forval i=1/5 {
		foreach v of varlist *_pq_`i' {
			replace `v'=. if kid_count_pq_`i'<250 | mi(kid_count_pq_`i')
		}
		replace kid_count_pq_`i'=. if kid_count_pq_`i'<250
	}	
	* mask gender-specific vars at 250
	foreach g in m f {
		rename kid_count_g_`g' temp
		foreach v of varlist *_g_`g' {
			replace `v'=. if temp<250 | mi(temp)
		}
		rename temp kid_count_g_`g'
		replace kid_count_g_`g'=. if kid_count_g_`g'<250
	}
end	

* Table 1a
use "${online_tables}/raw/table_1a.dta", clear
rename par_cz cz
merge 1:1 cz using "${online_tables}/cw/cz_czname.dta", nogen
rename (cz czname) (par_cz par_czname)
lab var par_cz			"Childhood CZ"
lab var par_czname		"Childhood CZ name"	
cleantab1
order par_cz par_czname par_state par_stateabbrv
drop if par_cz == .
compress
save "${online_tables}/table_1a.dta", replace
outsheet using "${online_tables}/table_1a.csv", comma replace

* Table 1b
use "${online_tables}/raw/table_1b.dta", clear
rename par_st stateabbrv
merge 1:1 stateabbrv using "${online_tables}/cw/statename.dta", nogen keep(3)
cleantab1
drop if mi(par_state)
order par_state par_stateabbrv
compress
save "${online_tables}/table_1b.dta", replace
outsheet using "${online_tables}/table_1b.csv", comma replace

*-------------------------------------------------------------------------------
* Table 2 - Innovation by Current CZ/State, Gender, Year of Birth, and Age
*-------------------------------------------------------------------------------

cap program drop cleantab2
program define cleantab2
	* Rename variables
	rename (yob state_id share_cat* share_inventor* share_patents* ///
	share_applicant* share_granted*) ///
	(cohort state grantee_cat* inventor* num_grants* applicant* grantee*)
	
	* Drop years posterior to 2012, because income panel data stops in 2012
	gen year = age + cohort
	drop if year > 2012
	
	* Drop variables we do not want to release
	drop *cit*
	drop inventor inventor_g_m inventor_g_f
	
	* Patent applications are missing before 2000
	foreach suffix in "" "_g_m" "_g_f" {
		replace applicant`suffix' = . if year <= 2000
	}

	* Label variables
	lab var stateabbrv 	"State abbreviation"
	lab var state		"State code"
	lab var cohort		"Birth cohort"
	lab var age			"Age"
	lab var year 		"Calendar Year"
	foreach suffix in "" "_g_m" "_g_f" {
		if "`suffix'" == ""  	 local sample " of individuals"
		if "`suffix'" == "_g_m"  local sample " of males"
		if "`suffix'" == "_g_f"  local sample " of females"
		lab var count`suffix' 		"Number`sample'"
		lab var applicant`suffix'   "Share`sample' who file public patent applications"
		lab var grantee`suffix'   	"Share`sample' who file patent applications subsequently granted"
		if "`suffix'" == ""  	 local sample " per individual"
		if "`suffix'" == "_g_m"  local sample " among males"
		if "`suffix'" == "_g_f"  local sample " among females"
		lab var num_grants`suffix'   	"Average number of patents granted`sample'"
	}
	forvalues i = 1/7 {
		if `i' == 1 local cat "chemical"
		if `i' == 2 local cat "computers and communic."
		if `i' == 3 local cat "drugs and medical"
		if `i' == 4 local cat "electrical and electronic"
		if `i' == 5 local cat "mechanical"
		if `i' == 6 local cat "others"
		if `i' == 7 local cat "design and plant"
		lab var grantee_cat_`i' "Share of individuals granted a patent in category `i' (`cat')"
	}
	order count_g_m, before(applicant_g_m)
	order count_g_f, before(applicant_g_f)
	
	* Mask vars at 250
	foreach v of varlist count-grantee_cat_7 {
		replace `v'=. if count<250 | mi(count)
	}
	drop if count ==.
	* mask gender-specific vars at 250
	foreach g in m f {
		foreach v of varlist *_g_`g' {
			replace `v'=. if count_g_`g'<250 | mi(count_g_`g')
		}
	}
end	

* Table 2a
use "${online_tables}/raw/table_2a.dta", clear
drop if age == .
merge m:1 cz using "${online_tables}/cw/cz_czname.dta", nogen
rename (cz_count_g_m cz_count_g_f) (count_g_m count_g_f)
lab var cz				"Current CZ"
cleantab2
order cz czname state stateabbrv cohort age year
sort cz cohort age
drop if cz == .
compress
drop if cohort>=1985
save "${online_tables}/table_2a.dta", replace
outsheet using "${online_tables}/table_2a.csv", comma replace

* Table 2b
use "${online_tables}/raw/table_2b.dta", clear
drop if age ==.
rename state stateabbrv
merge m:1 stateabbrv using "${online_tables}/cw/statename.dta", nogen keep(3)
rename state_count* count*
cleantab2
order state stateabbrv cohort age year
sort state cohort age 
compress
drop if cohort>=1985
save "${online_tables}/table_2b.dta", replace
outsheet using "${online_tables}/table_2b.csv", comma replace

*-------------------------------------------------------------------------------
* Table 3 - Patent Rates by College
*-------------------------------------------------------------------------------

use "${online_tables}/raw/table_4.dta", clear
sort super_opeid
rename count_par_q* count_pq*
rename share_inventor_q* inventor_pq*
rename share_* *
rename lifetime* total*
drop top5cita
lab var instnm "Name of institution / Super-OPEID cluster"
replace instnm = "Ohio State University " if super_opeid == 3090
lab var total_patents "Total number of patents granted to students"
lab var total_cites "Total number of patent citations obtained by students"
lab var top5cit "Share of individuals with citations in top 5% of their birth cohort"

* Drop colleges from the Everest college system (institutions all over the US)
drop if super_opeid == 6 
drop if instnm == ""

* Round lifetime citations and patents granted
replace total_patents = round(total_patents)
replace total_cites   = round(total_cites)

* I. Generate counts
forvalues i=1/5 {
	gen num_inv_`i'    = round(count_pq`i' * inventor_pq`i')
	gen num_noninv_`i' = round(count_pq`i' * (1-inventor_pq`i'))
}
egen tot_count = rowtotal(num_*)
egen tot_inventor = rowtotal(num_inv*)
drop if tot_inventor < 10

*Construct Joint and Marginal Probabilities
replace count = tot_count
replace inventor = tot_inventor / count
forvalues i=1/5 { 
	replace count_pq`i' = num_noninv_`i' + num_inv_`i'
	replace inventor_pq`i' = num_inv_`i' / count_pq`i'
}
* Drop variables
drop num* tot_* 		
compress
save "${online_tables}/table_3.dta", replace
outsheet using "${online_tables}/table_3.csv", comma replace

*-------------------------------------------------------------------------------
* Table 4 - Income Distributions of Inventors by Year and Age
*-------------------------------------------------------------------------------

* Load data
use "${online_tables}/raw/table_3.dta", clear
rename yr year
rename count_all count
order year, first
sort year age
gen  cohort = year - age

* Label variables
lab var year 		"Calendar year"
lab var age			"Age"
lab var cohort 		"Birth cohort"
lab var count		"Number of inventors"
lab var count_top5cit	"Number of inventors with citations in top 5% of their birth cohort"
foreach inc in "total_inc_" "w2_inc_" "nw_inc_" {
	if "`inc'" == "total_inc_" 		local inclab "total income"
	if "`inc'" == "w2_inc_"    		local inclab "wage earnings"
	if "`inc'" == "nw_inc_"    		local inclab "non-wage income"
	foreach group in "" "top5cit_" {
		foreach cut in "10" "20" "30" "40" "50" "60" "70" "80" "90" "99" {
			lab var `inc'`group'p`cut' "`cut'th percentile of distribution of `inclab'"
		}
		foreach cut in "mean" {
			lab var `inc'`group'mean "Mean of `inclab'"
		}
	}
}

* Format and round
qui ds year age cohort count*, not
foreach v in `r(varlist)' {
	format `v' %12.0f
	replace `v' = round(`v',100)
}

* Reorder
order cohort count*, after(age)
order total_inc_p*, after(count_top5cit)
order total_inc_top5cit_p* , after(total_inc_p99)
order w2_inc_p*, after(total_inc_top5cit_p99)
order w2_inc_top5cit_p*, after(w2_inc_p99)
order nw_inc_p* , after(w2_inc_top5cit_p99)
order nw_inc_top5cit_p* , after(nw_inc_p99)
order total_inc_mean, after(total_inc_p99)
order w2_inc_mean, after(w2_inc_p99)
order nw_inc_mean, after(nw_inc_p99)
order total_inc_top5cit_mean, after(total_inc_top5cit_p99)
order w2_inc_top5cit_mean, after(w2_inc_top5cit_p99)
order nw_inc_top5cit_mean, after(nw_inc_top5cit_p99)

* Keep ages 25-75 & years >= 1999
keep if age>=25 & age<=70
keep if year >= 1999


* Preserve at this point so we can produce a second dataset with just top5cit measures
tempfile t1
save `t1'

* Table 4a: no top5cit measures
drop *top5cit*
compress
save "${online_tables}/table_4a.dta", replace
outsheet using "${online_tables}/table_4a.csv", comma replace

* Table 4b: top5cit measures
use `t1', clear
keep age year *top5cit*
keep if year==.
drop year
compress
save "${online_tables}/table_4b.dta", replace
outsheet using "${online_tables}/table_4b.csv", comma replace


log close
