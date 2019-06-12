set more off

use dataset_dataverse_with_leip, clear

gen B = .
gen UB = .
gen LB = .

* programs to store estimates (eststo doesn't work well with cgmboot)
capture program drop myest1
program define myest1
	args i bw cov
	mat bootresults = e(bootresults)
	svmat bootresults
	replace B = _b[Zz] if index == `i'
	_pctile bootresults6 if bootresults3 == 0, nq(1000)
	replace LB = `r(r25)' if index == `i'
	replace UB = `r(r975)' if index == `i'
	drop bootresults*
end
 
local Z pcteligible2013

su `Z', det
gen Z = `Z' >=r(p50)
replace Z = . if mi(`Z')
 
gen Zx = Z*x
gen Zz = Z*z
gen Zzx = Z*zx

keep if abs(x) < 100

local nreps 500

foreach y in registration turnout {

	if "`y'" == "registration" local mytitle = "Registration"
	if "`y'" == "turnout" local mytitle = "Turnout"

	preserve

		gen index = _n + 2007
		 
		cgmwildboot d`y'20082004 z Z Zz x zx Zx Zzx logvap2008 `y'2004, cl(fipsstate) bootcluster(fipsstate) reps(`nreps')
		myest1 2008
		cgmwildboot d`y'20102006 z Z Zz x zx Zx Zzx logvap2010 `y'2006, cl(fipsstate) bootcluster(fipsstate) reps(`nreps')
		myest1 2010
		cgmwildboot d`y'20122008 z Z Zz x zx Zx Zzx logvap2012 `y'2008, cl(fipsstate) bootcluster(fipsstate) reps(`nreps')
		myest1 2012
		cgmwildboot d`y'20142010 z Z Zz x zx Zx Zzx logvap2014 `y'2010, cl(fipsstate) bootcluster(fipsstate) reps(`nreps')
		myest1 2014
		cgmwildboot d`y'20162012 z Z Zz x zx Zx Zzx logvap2016 `y'2012, cl(fipsstate) bootcluster(fipsstate) reps(`nreps')
		myest1 2016

		keep if !mi(B)

		#delimit;

		gr tw
			(sc B index, col(black))
			(rspike UB LB index, col(black))
			,
				xlab(2008(2)2016)
				xline(2013)
				ylab(, angle(horiz))
				yline(0)
				legend(off)
				plotregion(style(none))
				name(g`y', replace)
				title(`mytitle')
				ytitle("Estimate")
				xtitle("Year")
				;
				
		#delimit cr

	restore

}

gr combine gregistration gturnout

gr export "figure7.eps", replace
shell epstopdf "figure7.eps"
