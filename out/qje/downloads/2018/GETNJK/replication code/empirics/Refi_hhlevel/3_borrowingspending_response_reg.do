
use temp/refi2009_response_50pct.dta, clear // from 1_build_refi_response_data.do

keep if inrange(month_vs_refi ,-6,24)

foreach x of varlist pct80_aw pct100_aw ur_msa D_UR msa {
egen z = min(`x'), by(nid)
replace `x'=z
drop z
}

keep if ur_msa <. // only keep those in MSAs

g month_vs_refi_alt = 100 + month_vs_refi // just so they are all positive (for i.)

g month_vs_refi_alt_co  = month_vs_refi_alt*everco
g month_vs_refi_alt_nco = month_vs_refi_alt*evernco

// With month-MSA FE:
reghdfe carpurch b99.month_vs_refi_alt_co b99.month_vs_refi_alt_nco, vce(clu msa) absorb(msa#datem) 
parmest, label saving(est_msa_month,replace)
// With CID and month FE:
reghdfe carpurch b99.month_vs_refi_alt_co b99.month_vs_refi_alt_nco, vce(clu msa) absorb(datem nid) 
parmest, label saving(est_nid,replace)

preserve

	foreach x in est_msa_month est_nid {
	use `x', clear
	destring parm, gen(x) force ignore(b.month_vs_refi_alt_co b.month_vs_refi_alt_nco)
	replace x = x-100
	g nco = regexm(parm,"nco")
	tab nco

	count if x==-1
	if r(N)==0 {
	local y = _N+2
	set obs `y'
	replace x = -1 if x==.
	replace nco = _n==_N if nco==.
	replace estimate = 0 if x==-1
	replace min95 = 0 if x==-1
	replace max95 = 0 if x==-1
	sort nco x
	}

	foreach z of varlist estimate min95 max95 {
		replace `z' = `z'*100
	}
	
	line estimate min95 max95 x if inrange(x,-5,12) & nco == 1, lcolor(black black black) lpattern(solid dash dash) lwidth(thick thin thin) ///
	 || line estimate min95 max95 x if inrange(x,-5,12) & nco == 0, lcolor(gray gray gray)  lpattern(solid dash dash) lwidth(thick thin thin) xlabel(-4(2)12) ///
	 legend(order(1 "Non-cash-out refinance" 4 "Cash-out refinance")) xtitle("Distance from refinance (months)") ytitle("Estimated effect on prob(new car loan)," "in percentage points") name(`x', replace)
}
restore




