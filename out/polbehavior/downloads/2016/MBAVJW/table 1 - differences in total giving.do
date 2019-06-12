set more off

capture program drop myest
program define myest
	args r d i
	* point est
	preserve
		replace `r' = 0
		replace `d' = 1
		replace `i' = 0
		predict yhat, xb
		su yhat
		local y0 = exp(`r(mean)')-1
	restore
	preserve
		replace `r' = 1
		replace `d' = 0
		replace `i' = 0
		predict yhat, xb
		su yhat
		local y1 = exp(`r(mean)')-1
	restore
	estadd scalar mydiff = `y1' - `y0'
end

local j = 1

eststo clear

forvalues j = 0(1)3 {

	di "`j'"

	if `j' == 0 {
		use "sccbs", clear
	}
	if `j' == 1 | `j' == 2 {
		use "gss", clear
	}
	if `j' == 3 {
		use "ssi", clear
	}
	if `j' == 0 | `j' == 1 {
		local X0 "liberal"
		local X1 "conservative" 
		local X2 "moderate"
	}
	if `j' == 2 | `j' == 3 {
		local X0 "democrat"
		local X1 "republican"
		local X2 "independent"
	}
	
	local X `X1' `X2'
	
	local control male married family_size age hs coll grad white black i.region	
	
	eststo: qui xi: reg ln_totgiv `X' income `control', r
	myest `X1' `X0' `X2'

}

#delimit;

esttab
	using "table1.tex"
	,
		replace
		width(\textwidth)
		booktabs
		gap
		label
		collabels(none)
		nomtitles
		order(conservative moderate republican independent)
		cells(b(fmt(2) star) se(par))
		drop(*region*)
		stats(
			N 
			r2 
			mydiff 
			,
				label(
					"Sample size"
					"R-squared"
					"Effect size (\\$)"

				)
				fmt(
					%20.00fc
					%20.02fc
					%20.00fc
				)
		)
		mgroups(
			"SCCBS" "GSS" "SSI"
			,
				pattern(1 1 0 1)
				prefix(\multicolumn{@span}{c}{) suffix(})
				span erepeat(\cmidrule(lr){@span})
		)		
		;
		
#delimit cr
		
