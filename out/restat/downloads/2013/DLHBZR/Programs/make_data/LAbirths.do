set more 1
clear
set mem 20m

insheet using ${CSV}/LAbirths.csv

gen fipscnty=22000+cycode

gen byear=year+1900
drop year
sort fipscnty byear

replace bi_rbl=. if bi_rnr==1
replace bi_rwh=. if bi_rnr==1

foreach race in bl wh to {
	gen mis_`race'=0
	gen birthlag_`race'=bi_r`race'
	forvalues n=1/11{
		replace birthlag_`race'=birthlag_`race'+bi_r`race'[_n-`n'] if fipscnty==fipscnty[_n-`n']
		replace birthlag_`race'=. if fipscnty~=fipscnty[_n-`n']
		replace mis_`race'=mis_`race'+bi_rnr[_n-`n']
		}
		replace mis_`race'=(mis_`race'>0)
	}

replace birthlag_bl=. if mis_bl==1
replace birthlag_wh=. if mis_wh==1
	
gen year=byear+6
sort fipscnty year

keep fipscnty year birthlag* mis*
save ${DTA}/LAbirths, replace

