set more off

use dataset, clear

*** election years  ***

gen electionyear = year == 1992 | year == 1996 | year == 2000 | year == 2004 | year == 2008 | year == 2012

keep if !mi(override) & year < 2013
tab year

replace override = 1 if numberheld > 0 & !mi(numberheld)
replace overridep = 1 if numberpassed > 0 & !mi(numberpassed)
	
egen noverride1 = sum(override) if electionyear == 1, by(town)
egen noverride0 = sum(override), by(town)

egen noverridep1 = sum(overridep) if electionyear == 1, by(town)
egen noverridep0 = sum(overridep), by(town)

collapse noverride*, by(town gisid)

foreach x in noverride1 noverride0 noverridep1 noverridep0 {
	replace `x' = 1 if `x' > 0 & !mi(`x')
} 

label variable noverridep1 "Passed at least one, election years"
label variable noverridep0 "Passed at least one, all years"

label variable noverride1 "Held at least one, election years"
label variable noverride0 "Held at least one, all years"

tab noverride0
tab noverridep0
su noverridep0 , det
su noverride0 , det

local j = 1
foreach y in noverridep1 noverridep0 noverride1 noverride0 {

	count if `y' >= 1 & !mi(`y')
	local myN = r(N)
		
	local templabel : var label `y'	
	
	tab `y'
	
	#delimit;

	spmap
		`y' using "coords"
		,
			id(gisid) 
			fcolor(
				gs15
				gs9 
									
			)
			clmethod(unique)
			legend(off)
			name(g`y', replace)
			title("`templabel'", size(large))
			subtitle("(`myN' / 351)", size(large))
			;

	#delimit cr
	
	local j = `j' + 1
	
}

gr combine gnoverride1 gnoverride0 gnoverridep1 gnoverridep0

gr export "figure A1.eps", replace

shell convert -resize 2048x1536 -density 300 "figure A1.eps" -flatten "figure A1.png"

shell rm "figure A1.eps"
