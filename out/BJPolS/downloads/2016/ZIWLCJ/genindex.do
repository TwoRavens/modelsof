cap program drop _all
program genindex

	version 12
	syntax varlist [aw] , nv(string)
	
	*qui {
		center `varlist' , pre(z_) st

	// #1-a Mean of those zscores, 0/1 at median: M
		egen `nv'M = rowmean(z_*)
		if "`exp'" != "" {
			qui su `nv'M [weight `exp'] , de
			}
		if "`exp'" == "" {
			qui su `nv'M , de
			}
		gen `nv'M_B = (`nv'M > r(p50))
		
	// #1-b Factor, 0/1 at median: F
		factor z_*
		predict `nv'F
		su `nv'F , de
		gen `nv'F_B = (`nv'F > r(p50))
		
	// #1-c Anderson ('08) wgt'd by Var-Cov mat, 0/1 at median: A
		tempname R J T A
		mat accum `R' = `varlist' , nocons dev
		mat `R' = syminv(`R'/r(N))
		mat `J' = J(colsof(`R') , 1 , 1)

		local c = 1
		while `c' <= colsof(`R') {
			mat `T' = `R'[`c' , 1..colsof(`R')]
			mat `A' = `T'*`J'
			global wgt`c' = `A'[1 , 1]
			local ++c
			}
		
		tempvar samp1 outp1
		gen `samp1' = 0
		gen `outp1' = 0
		local c = 1
		foreach z in `varlist' {
			replace `samp1' = `samp1' + $wgt`c'
			replace z_`z' = 0 if missing(`z') 
			replace `outp1' = z_`z'*($wgt`c') + `outp1'
			local ++c
			}

		replace `outp1' = `outp1'/`samp1'
		rename `samp1' n_`nv'_var
		rename `outp1' `nv'A

		su `nv'A , de
		gen `nv'A_B = (`nv'A > r(p50))
		
		local ab M F A
		local ful Mean Factor Anderson
		forval n = 1/3 {
			local a : word `n' of `ab'
			local b : word `n' of `ful'
			lab var `nv'`a' "`nv'`a': `nv' `b'"
			lab var `nv'`a'_B "`nv'`a'_B: `nv' `b' 0/1"
			}
		
		drop z_*
		macro drop _all
		*}	
end
