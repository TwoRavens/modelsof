#delimit cr

local filename = "Output/SupTableXV.tex"
local fixedeffects = "superstrata"

// NOTE: In the below variable names are inconsistent with the paper's reference to T1, T2, and T3. 

******* Prepare Data ********

gen branch_code = floor(club_id/100)

preserve

	// Merge information on T2 INTENSITY from randomisation
	* Merge data
	merge n:1 branch_code using "Input/ValueOfHarvestByBranchSeason0.dta"

	* Drop the one branch which dropped in/after season 1 [only unmatched observation from using]
	drop if branch_code == 5036
	
	* Calculate payment in T2 the same way it was assigned (median, times 2 to calculate total yield, re-scaled to adjust for season 0 particularity)
	gen harvest_median = round((2*harvest_median_s1/harvests1scalefactor),2000)
	gen T3_payment  = harvest_median * 0.25 / 937.36
	
	// Calculate what T2 should have been ideally
	gen  	E_yield_tr_t1 	 = Y if tt_r == 1
	egen 	T3_payment_ideal = median(E_yield_tr_t1), by(branch_code season)
	replace T3_payment_ideal = T3_payment_ideal * 0.25

	// Calculate ratio of what T2 payment was over what is should have been. 
	gen 	T3_ratio_treatment = T3_payment / T3_payment_ideal
	
	// Saving
	duplicates drop branch_code season, force
	keep branch_code season T3_ratio_treatment T3_payment T3_payment_ideal
	tempfile T3payment
	save "`T3payment'", replace 
restore	
	
******* Run Regressions ********	
	
merge n:1 branch_code season using "`T3payment'" 

reg Y T3_ratio_treatment

foreach j of numlist 1/4 {
	if `j' == 1 | `j' == 2 {
		local yvar = "Y"
	}
	else if `j' == 3 | `j' == 4 {
		local yvar = "Ysqm"
	}
	if `j' == 1 | `j' == 3 {
		local tvar = "T2_treatment T3_treatment"
		local tvar_categories = "2 3"	
	}
	else if `j' == 2 | `j' == 4 {
		local tvar = "T2_treatment T3_treatment T4_treatment"
		local tvar_categories = "2 3 4"	
	}	

	// Standard Inference: Run Regression
	cap drop T2_treatment 
	cap drop T3_treatment 
	cap drop T4_treatment
	gen T2_treatment = (tt_r == 2)
	if `j' == 1 | `j' == 3 {
		qui gen T3_treatment = (tt_r == 3) * T3_ratio_treatment
	}
	else if `j' == 2 | `j' == 4 {
		qui gen T3_treatment = (treatment_type == 3) * T3_ratio_treatment
		qui gen T4_treatment = (treatment_type == 4) * T3_ratio_treatment
	}	
	qui areg `yvar' `tvar', absorb(`fixedeffects') cl(club_id)
	local N_`j' = `e(N)'

	// Standard Inference: Save Results
	foreach c of local tvar_categories {
		local coeff_`c'_`j' = _b[T`c'_treatment]
		local se_`c'_`j' 	= _se[T`c'_treatment]
	}

	// Randomisation Inference
	foreach c of local tvar_categories {
		qui test T`c'_treatment = 0
		local teststat_`c' = r(F)	
		local pvalue_RI_`c'_`j' = 0
	}	
	forvalues i = 1/`ri_N' {
		if mod(`i',100) == 0 {
			display "`i'"
		}
		cap drop T2_treatment 
		cap drop T3_treatment 
		cap drop T4_treatment
		qui gen T2_treatment = (tt_r_`i' == 2)
		if `j' == 1 | `j' == 3 {
			qui gen T3_treatment = (tt_r_`i' == 3) * T3_ratio_treatment
		}
		else if `j' == 2 | `j' == 4 {
			qui gen T3_treatment = (treatment_type_`i' == 3) * T3_ratio_treatment
			qui gen T4_treatment = (treatment_type_`i' == 4) * T3_ratio_treatment
		}	
		
		qui areg `yvar' `tvar', a(`fixedeffects') cl(club_id)
		foreach c of local tvar_categories {
			qui test T`c'_treatment = 0
			local pvalue_RI_`c'_`j' = `pvalue_RI_`c'_`j'' + (1/`ri_N' * (r(F) >= `teststat_`c''))
		}
	}
}

******* Write Output ********

capture file close output_file
file open output_file using "`filename'", write replace

// T2
file write output_file "High \$s\$ (T1) "
local yvarname = 2

foreach j of numlist 1/4 {
	file write output_file " & " %5.3f (`coeff_`yvarname'_`j'')
	qui include "Code/do files/addstars.do"
}
file write output_file " \\[-3pt]" _n

foreach j of numlist 1/4 {
	file write output_file " & {\scriptsize(" %5.3f (`se_`yvarname'_`j'') ")}"
}
file write output_file " \\[-4pt]" _n

foreach j of numlist 1/4 {
	file write output_file " & {\scriptsize[" %5.3f (`pvalue_RI_`yvarname'_`j'') "]}"
}
file write output_file " \\[5pt]" _n

// T3
file write output_file "High \$y\$ (T2) "
local yvarname = "3"
foreach j of numlist 1 3 {
	file write output_file " & " %5.3f (`coeff_`yvarname'_`j'') " & "
	qui include "Code/do files/addstars.do"
}
file write output_file " \\[-3pt]" _n

foreach j of numlist 1 3 {
	file write output_file " & {\scriptsize(" %5.3f (`se_`yvarname'_`j'') ")} & "
}
file write output_file " \\[-4pt]" _n

foreach j of numlist 1 3 {
	file write output_file " & {\scriptsize[" %5.3f (`pvalue_RI_`yvarname'_`j'') "]} &"
}
file write output_file " \\[5pt]" _n

// T3A
file write output_file "High \$y\$, safe (T2A) "
local yvarname = "3"
foreach j of numlist 2 4 {
	file write output_file " & & " %5.3f (`coeff_`yvarname'_`j'') 
	qui include "Code/do files/addstars.do"
}
file write output_file " \\[-3pt]" _n

foreach j of numlist 2 4 {
	file write output_file " & & {\scriptsize(" %5.3f (`se_`yvarname'_`j'') ")} "
}
file write output_file " \\[-4pt]" _n

foreach j of numlist 2 4 {
	file write output_file " & & {\scriptsize[" %5.3f (`pvalue_RI_`yvarname'_`j'') "]} "
}
file write output_file " \\[5pt]" _n

// T3B
file write output_file "High \$y\$, risky (T2B) "
local yvarname = "4"
foreach j of numlist 2 4 {
	file write output_file " & & " %5.3f (`coeff_`yvarname'_`j'') 
	qui include "Code/do files/addstars.do"
}
file write output_file " \\[-3pt]" _n

foreach j of numlist 2 4 {
	file write output_file " & & {\scriptsize(" %5.3f (`se_`yvarname'_`j'') ")} "
}
file write output_file " \\[-4pt]" _n

foreach j of numlist 2 4 {
	file write output_file " & & {\scriptsize[" %5.3f (`pvalue_RI_`yvarname'_`j'') "]} "
}
file write output_file " \\[5pt]" _n

* Mean Outcome

file write output_file " \midrule" _n

file write output_file "Observations "

foreach j of numlist 1/4 {
	file write output_file " & " %3.0f (`N_`j'')
}		
file write output_file " \\ " _n


file close output_file	

*** End the .do file

#delimit ;












