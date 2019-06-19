*** This file creates the natality.dta file that is used to produce figures 1, 2, and 3
*** and Tables 1, 2 (col. 4), and 5.  The .do files that create those figures and tables
*** are also publicly available.

*** the natl1989-natl2001 files used here were downloaded from the NBER website.

clear

*** insert location of directory containing files in place of DIRECTORY here:
cd "DIRECTORY"

use "natl1989"

rename birmon birthmon
gen married=dmar==1
gen teenmom=dmage<20
gen momHS=dmeduc>11
replace momHS=. if dmeduc==99
gen momwhite=mrace3==1
rename dbirwt birthwt
gen lbw=birthwt<2500
for var lbw birthwt: replace X=. if birthwt==9999
drop preterm
gen preterm=dgestat<37
for var preterm dgestat:  replace X=. if dgestat==99
destring cntyrfip, replace
rename cntyrfip fipsres
rename datayear year

keep birthmon married teenmom momHS momwhite lbw birthwt preterm dgestat fipsres year

save "natality", replace

local y = 1990
while `y' <2002 {
	use natl`y', clear
	rename birmon birthmon
	gen married=dmar==1
	gen teenmom=dmage<20
	gen momHS=dmeduc>11
	replace momHS=. if dmeduc==99
	gen momwhite=mrace3==1
	rename dbirwt birthwt
	gen lbw=birthwt<2500
	for var lbw birthwt: replace X=. if birthwt==9999
	drop preterm
	gen preterm=dgestat<37
	for var preterm dgestat:  replace X=. if dgestat==99
	destring cntyrfip, replace
	rename cntyrfip fipsres
	rename datayear year

	keep birthmon married teenmom momHS momwhite lbw birthwt preterm dgestat fipsres year

	append using "natality"
	save "natality", replace
	local y = `y' + 1
	}

