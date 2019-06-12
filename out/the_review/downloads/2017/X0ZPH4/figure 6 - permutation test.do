set more off

use dataset_dataverse_with_leip, clear

local Z pcteligible2013
su `Z', det
gen Z = `Z' >=r(p50)
replace Z = . if mi(`Z')
 
gen Zx = Z*x
gen Zz = Z*z
gen Zzx = Z*zx

reg dregistration20142010 z Z Zz x zx Zx Zzx `covariates20142010r' if abs(x) < 100
local est1z = _b[Zz]
reg dturnout20142010 z Z Zz x zx Zx Zzx `covariates20142010t' if abs(x) < 100
local est2z = _b[Zz]
reg dregistration20162012 z Z Zz x zx Zx Zzx `covariates20162012r' if abs(x) < 100
local est3z = _b[Zz]
reg dturnout20162012 z Z Zz x zx Zx Zzx `covariates20162012t' if abs(x) < 100
local est4z = _b[Zz]

forvalues i = 1(1)4 {
	gen B`i' = .
}
gen index = _n

local K = 1000

forvalues i = 1(1)`K' {

	di `i'
	
	qui{

		preserve
		
			

			drop border*
			merge 1:m fips using "dataset_distanceforplacebo", force	
			drop _m
			
			* randomly re-assign expansion
			save tmp, replace
					
			collapse z, by(fipsstate)
			gen rannum = runiform()
			sort rannum
			gen index = _n
			drop z
			gen z2 = index > 21

			merge 1:m fipsstate using tmp
			erase tmp.dta
			drop z
			rename z2 z
			
			drop zx
			drop x			
				
			levelsof fipsstate if z == 0, local(levels)
			foreach l of local levels {
				replace distance = -distance if fipsstate == `l'
			}
			gen x = distance
			
			* drop pairs of states with same expansion status
			egen borderz = mean(z), by(border)
			drop if borderz == 0 | borderz == 1
			
			replace x = abs(x)
			replace x = -x if z == 0
			gen zx = z*x

			drop Zx Zz Zzx Z
			
			local Z pcteligible2013
			su `Z', det
			gen Z = `Z' >=r(p50)
			replace Z = . if mi(`Z')
			 
			gen Zx = Z*x
			gen Zz = Z*z
			gen Zzx = Z*zx

			gen X = abs(x)
			egen mindist = min(X), by(fips)
			
			keep if X == mindist
			
			reg dregistration20142010 z Z Zz x zx Zx Zzx `covariates20142010r' if abs(x) < 100
			local B1 = _b[Zz]
			reg dturnout20142010 z Z Zz x zx Zx Zzx `covariates20142010t' if abs(x) < 100
			local B2 = _b[Zz]
			reg dregistration20162012 z Z Zz x zx Zx Zzx `covariates20162012r' if abs(x) < 100
			local B3 = _b[Zz]
			reg dturnout20162012 z Z Zz x zx Zx Zzx `covariates20162012t' if abs(x) < 100
			local B4 = _b[Zz]
			
		restore
			
		replace B1 = `B1' if index == `i'
		replace B2 = `B2' if index == `i'
		replace B3 = `B3' if index == `i'
		replace B4 = `B4' if index == `i'
		
	}

}

forvalues i = 1(1)4 {

	if `i' == 1 local c = abs(`est1z')
	if `i' == 2 local c = abs(`est2z')
	if `i' == 3 local c = abs(`est3z')
	if `i' == 4 local c = abs(`est4z')
	
	preserve

		count if abs(B`i') > `c' & !mi(B`i')
		local myp = string(`r(N)'/10) + "%"

		twoway__histogram_gen B`i',  gen(h xx)
		
		if `i' == 1 local mytitle "Registration 2014-2010"
		if `i' == 2 local mytitle "Turnout 2014-2010"
		if `i' == 3 local mytitle "Registration 2016-2012"
		if `i' == 4 local mytitle "Turnout 2016-2012"

		#delimit;

		gr tw 
			(area h h xx if xx > `c', color(gs10 gs10))
			(area h h xx if xx < -`c', color(gs10 gs10))
			(hist B`i', fcol(none) lcol(black))
			,
				xline(`c', lpat(dash) lcol(black))
				xline(-`c', lpat(dash) lcol(black))
				legend(off)
				plotregion(style(none))
				xtitle("Estimate")
				ylab(, angle(horiz))
				title(`mytitle')
				subtitle("(p = `myp')")
				nodraw
				name(g`i', replace)
				;

		#delimit cr
	
	restore

}

keep if !mi(B1)

count if abs(B1) > `est1z'
count if abs(B2) > `est2z'
count if abs(B3) > `est3z'
count if abs(B4) > `est4z'

count if abs(B1) > `est1z' & abs(B2) > `est2z' & abs(B3) > `est3z' & abs(B4) > `est4z'

gr combine g1 g3 g2 g4

gr export "figure6.eps", replace
shell epspdf "figure6.eps"
