*****casulaty data are from https://www.dmdc.osd.mil/dcas/pages/report_oif_namesalp.xhtml
**** create 3 data sets: inter-election, 30 days prior to election and 60 days prior
*** first the interelection casulaties
use "US casualty data 2012.dta" 
gen casualty_sum=1
gen grouping = 1 if year <2007 & year >2004
replace grouping =1 if year ==2004 & month >10
replace grouping = 2 if year ==2006 & month ==11
replace grouping = 2 if year ==2006 & month ==12
replace grouping=2 if year >2006 & year <2009
replace grouping = 3 if year ==2008 & month ==11
replace grouping = 3 if year ==2008 & month ==12
replace grouping=3 if year >2008 & year <2011
replace grouping = 4 if year ==2010 & month ==11
replace grouping = 4 if year ==2010 & month ==12
replace grouping =4 if year >2010 & year <2013
replace grouping = . if year ==2012 & month ==11
replace grouping = . if year ==2012 & month ==12
collapse (sum) casualty_sum,  by (home_of_record_county state grouping)
rename home_of_record_county co_name
save "county_level cas by month.dta", replace
sort co_name state
save, replace
use "countyfipscodes.dta", clear
sort co_name state
merge co_name state using  "county_level cas by month.dta"

****generate inter-election casualty data
keep if _merge ==3
drop _merge
gen str3 z = string( fipsstate ,"%03.0f")
gen str3 zz = string( fipscounty ,"%03.0f")
egen fips_code =concat( z zz )
destring fips_code, replace
drop z zz
collapse (sum) casualty_sum , by( fips_code grouping)
save "inter-election casulaties.dta", replace 

*****proximate casualty data
*** the 30 days prior
use "US casualty data 2012.dta"
drop if year <2006
drop if year ==2007
drop if year ==2009
drop if year ==2011
drop if year >2012

rename home_of_record_county  co_name


save "recent_cas.dta", replace
sort co_name state
save, replace
use "countyfipscodes.dta", clear
sort co_name state
merge co_name state using "recent_cas.dta"
keep if _merge ==3
gen casualty_sum =1
gen str3 z = string( fipsstate ,"%03.0f")
gen str3 zz = string( fipscounty ,"%03.0f")
egen fips_code =concat( z zz )
destring fips_code, replace
drop z zz
save "recent_cas2.dta", replace

gen cas30 = 1 if year ==2006 & month ==10 
replace cas30= 1 if year ==2006 & month ==11 & day <7
replace cas30 = 1 if year ==2008 & month ==10 
replace cas30= 1 if year ==2008 & month ==11 & day <4
replace cas30 = 1 if year ==2010 & month ==10 
replace cas30= 1 if year ==2010 & month ==11 & day <2
replace cas30 = 1 if year ==2012 & month ==10 
replace cas30= 1 if year ==2012 & month ==11 & day <2
collapse (sum) casualty_sum if cas30==1, by(fips_code year)
rename casualty_sum cas30
save "30daycas.dta", replace

**** the 60 days prior measure
use "recent_cas2.dta"
gen cas60 = 1 if year ==2006 & month ==9 
replace cas60 = 1 if year ==2006 & month ==10
replace cas60= 1 if year ==2006 & month ==11 & day <7
replace cas60 = 1 if year ==2008 & month ==9 
replace cas60 = 1 if year ==2008 & month ==10 
replace cas60= 1 if year ==2008 & month ==11 & day <4
replace cas60 = 1 if year ==2010 & month ==9 
replace cas60 = 1 if year ==2010 & month ==10 
replace cas60= 1 if year ==2010 & month ==11 & day <2
replace cas60 = 1 if year ==2012 & month ==9 
replace cas60= 1 if year ==2012 & month ==10
replace cas60= 1 if year ==2012 & month ==11 & day <6

collapse (sum) casualty_sum if cas60==1, by(fips_code year)
rename casualty_sum cas60
save "60daycas.dta" , replace


