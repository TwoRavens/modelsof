
clear all
set more off

local years "2007 2010 2011 2012 2013 2014"
local months "Jan Feb Mar Apr May June July Aug Sept Oct Nov Dec"

foreach y in `years' {

clear
gen init=.
save temp`y',replace

	local mn=0
	foreach m in `months' {
	local mn=`mn'+1
		di " `m' `y'"

	
		use cleantitle soc employer sector naics3 naics4 naics5 naics6 fips edu maxedu exp maxexp using  Main-`y'-`m', clear
		
	
		destring exp sector naics3 naics4 naics5 naics6 maxedu, replace force
		
		gen month=`mn'
		
	
		recode sector naics3 naics4 naics5 naics6 edu maxedu exp maxexp (-999=.)
		gen naics=naics6 
		replace naics=naics5 if naics==.
		replace naics=naics4 if naics==.
		replace naics=naics3 if naics==.
		replace naics=sector if naics==.
		
	
		replace employer="" if employer=="na"
		
	
		capture drop if regexm(exp, "Metro")
		capture drop if regexm(maxedu, "Phoe")
		
	
		drop if inlist(soc, "-999", "n/a", "", "na")
		assert length(soc)==7
		
	
		drop if fips=="" | fips==" "
		gen statefip=substr(fips,1,2)
		drop if statefip=="na"
		destring statefip, replace
		
		drop sector naics3 naics4 naics5 naics6
		
		append using temp`y'.dta
		
		save temp`y'.dta, replace
	}
	
	gen year=`y'
	save temp`y'.dta, replace
	
}


***************************************

use ./temp2007.dta, clear
append using ./temp2010 ./temp2011 ./temp2012 ./temp2013 ./temp2014

egen long employerid=group(employer)
egen long jobid=group(cleantitle)
preserve
	duplicates drop cleantitle jobid, force
	keep cleantitle jobid
	save ./temp_jobcrosswalk.dta, replace
restore
preserve
	duplicates drop employerid employer, force
	keep employerid employer
	save ./temp_employercrosswalk.dta, replace
restore
drop employer cleantitle init
compress
save ./bgt_postings_allyearsv2.dta, replace




