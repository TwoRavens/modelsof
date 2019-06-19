clear
set more 1
set mem 20m
set matsize 800

clear
use ${DTA}\LAdata_finance
capture log close
log using ${LOG}\LACoeffTests.log, replace text

keep if year>=1955&year<=1975

gen x=fracbl if year==1961
egen fracbl61=max(x), by(fipscnty)

global controls "percapinc6 perplumb6 perinclt30006 lnpop6 perurban6 fracti"

local trends "lnenrwh fracprivwh pprevtot pprevloc pprevst_psf pprevfed_esea ppexpcurr tsrat"

forvalues year=1955/1975 {
	gen _yr`year'_=(year==`year')
	gen _yr`year'Xfracbl61=(_yr`year'_*fracbl61)
	foreach var in ${controls} {
		gen _c`year'`var'=(_yr`year'_*`var')
		}
	}

drop _yr1967*

foreach var in `trends' {
	reg `var' _yr*_ _yr19*Xfracbl61 _c*, robust nocons
	test _yr1970Xfracbl61=_yr1971Xfracbl61=_yr1972Xfracbl61=_yr1973Xfracbl61=_yr1974Xfracbl61=_yr1975Xfracbl61
	test _yr1972Xfracbl61=_yr1975Xfracbl61
	
	}	

