****************************************
* Conducts Randomization Inference	   *
****************************************

clear all
set more off

capture program drop rinf
program define rinf, rclass
	syntax [anything], dv(string) bw(numlist > 0) iter(numlist > 0 integer) condition(string) condition1(string)
preserve
quietly{
	set seed 12345
	set matsize 11000
	use disc_final.dta, clear
	merge m:1 consid using rinf.dta
	`condition'
	`condition1'
	forvalues i=1(1)`iter' {
		gen rivm = vm if t`i' == pml_winner
		replace rivm = -vm if t`i' != pml_winner
		gen ripvm = t`i' * rivm
		g riw`i'=max(0,`bw'-abs(rivm)) if abs(rivm)<=`bw'
			areg `dv' t`i' rivm ripvm i_wave* [pw=riw`i'], cluster(consid) ab(district_tehsil_code)
			mat tab = r(table)
			if `i' == 1 {
			mat b = tab[1,1]
				}
			else {
				mat b = b \ tab[1,1]
				}
			drop rivm ripvm riw*
			}
	
	g wactual=max(0,`bw'-abs(vm)) if abs(vm)<=`bw'
	areg `dv' pml_winner vm pvm i_wave* [pw=wactual], cluster(consid) ab(district_tehsil_code)
		mat tab = r(table)
		local b_true = tab[1,1]
		
		svmat b, names(bval)
		keep bval
		drop if missing(bval)
		local obs = _N+1
		set obs `obs'
		replace bval = `b_true' in `obs'
		gen b_true = `b_true'
		cumul bval, gen(cbval)
	
	* Calculating pvalue
	drop if bval1 == b_true
	gen count = 0
	sum bval
	if b_true <`r(mean)' {
		replace count=1 if b_true>bval1
		}
	else {
		replace count=1 if b_true<bval1
		}
	sum count
	local pval = `r(mean)'*2
	local absbw = int(`bw')
	if `pval' <= 1 return scalar pexact`absbw' = `pval'
	else return scalar pexact`absbw' = 1
	
	* Saving confidence intervals
	matrix CI = J(1,3,.)
	sum bval1, de
		replace bval1 = . if (bval1 >= r(p95) | bval1 <= r(p5)) & ~missing(bval1)
		sum bval1
		mat CI[1,1] = r(min)
		mat CI[1,2] = b_true[1]
		mat CI[1,3] = r(max)
				
	return matrix CI`absbw' = CI
	
}
restore
end


