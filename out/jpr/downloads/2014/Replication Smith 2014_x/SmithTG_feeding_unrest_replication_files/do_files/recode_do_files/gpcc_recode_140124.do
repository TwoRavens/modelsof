*** PREP GPCC DATA *****
*** prepares data for use by MASTER ANALYSIS
*** Todd G. Smith
*** updated 24 January 2014

set more off
clear all

*local user "`c(username)'"
*cd "/Users/`user'/Documents/Active Projects/Feeding Unrest Africa/analysis"
use "data/raw_data/MASTER_GPCC_195101-201305_130727.dta"

*collapse (sum) monthprecip (mean) precip_area, by(cow_code year)
*rename monthprecip annualprecip

rename month time
gen year = (ceil(centmo / 12) + 1899)
gen month = centmo - ((year - 1900) *12) 
order month year, a(centmo)

drop sd sum
rename min ctrymin
rename max ctrymax
rename mean monthprecip
*gen year = floor(time / 12) + 1960
*gen month = (((time / 12) - (year - 1960)) * 12) + 1
lab def month 1 "Jan" 2 "Feb" 3 "Mar" 4 "Apr" 5 "May" 6 "Jun" 7 "Jul" 8 "Aug" 9 "Sep" 10 "Oct" 11 "Nov" 12 "Dec"
lab val month month
*order name iso3 iso2 iso_num wb_code cow_abbrev cow_code time time year month
egen monthmean = mean(monthprecip), by(iso_num month)
egen monthsd = sd(monthprecip), by(iso_num month)

xtset iso_num time
gen stdprecip = (monthprecip - monthmean) / monthsd
gen wet_precip = stdprecip
replace wet_precip = 0 if stdprecip < 0
gen dry_precip = abs(stdprecip)
replace dry_precip = 0 if stdprecip > 0
lab var wet_precip "Wet standardized precipitaiton (SDs above long-term monthly mean)"
lab var dry_precip "Dry standardized precipitaiton (SDs below long-term monthly mean)"

egen q1 = pctile(monthprecip), p(25) by(iso_num month)
egen q3 = pctile(monthprecip), p(75) by(iso_num month)
egen iqr = iqr(monthprecip), by(cow_code month)
gen wet_month = monthprecip > (q3 + (iqr * 1))
gen dry_month = monthprecip < (q1 - (iqr * 1))

* generates variables x month cumulatives and "moving standardized cumulative precipitation" (MSCP)
* MSCP = standard deviations above (wet_msp) or below (dry_msp) 12 month moving average

gen cumprecip1 = monthprecip
gen cumprecip2 = monthprecip + l.monthprecip
gen cumprecip3 = monthprecip + l.monthprecip + l2.monthprecip
gen cumprecip4 = monthprecip + l.monthprecip + l2.monthprecip + l3.monthprecip
gen cumprecip5 = monthprecip + l.monthprecip + l2.monthprecip + l3.monthprecip + l4.monthprecip
gen cumprecip6 = monthprecip + l.monthprecip + l2.monthprecip + l3.monthprecip + l4.monthprecip + l5.monthprecip
gen cumprecip7 = monthprecip + l.monthprecip + l2.monthprecip + l3.monthprecip + l4.monthprecip + l5.monthprecip + l6.monthprecip
gen cumprecip8 = monthprecip + l.monthprecip + l2.monthprecip + l3.monthprecip + l4.monthprecip + l5.monthprecip + l6.monthprecip + l7.monthprecip
gen cumprecip9 = monthprecip + l.monthprecip + l2.monthprecip + l3.monthprecip + l4.monthprecip + l5.monthprecip + l6.monthprecip + l7.monthprecip + l8.monthprecip
gen cumprecip10 = monthprecip + l.monthprecip + l2.monthprecip + l3.monthprecip + l4.monthprecip + l5.monthprecip + l6.monthprecip + l7.monthprecip + l8.monthprecip + l9.monthprecip
gen cumprecip11 = monthprecip + l.monthprecip + l2.monthprecip + l3.monthprecip + l4.monthprecip + l5.monthprecip + l6.monthprecip + l7.monthprecip + l8.monthprecip + l9.monthprecip + l10.monthprecip
gen cumprecip12 = monthprecip + l.monthprecip + l2.monthprecip + l3.monthprecip + l4.monthprecip + l5.monthprecip + l6.monthprecip + l7.monthprecip + l8.monthprecip + l9.monthprecip + l10.monthprecip + l11.monthprecip
gen cumprecip13 = monthprecip + l.monthprecip + l2.monthprecip + l3.monthprecip + l4.monthprecip + l5.monthprecip + l6.monthprecip + l7.monthprecip + l8.monthprecip + l9.monthprecip + l10.monthprecip + l11.monthprecip + l12.monthprecip
gen cumprecip14 = monthprecip + l.monthprecip + l2.monthprecip + l3.monthprecip + l4.monthprecip + l5.monthprecip + l6.monthprecip + l7.monthprecip + l8.monthprecip + l9.monthprecip + l10.monthprecip + l11.monthprecip + l12.monthprecip + l13.monthprecip
gen cumprecip15 = monthprecip + l.monthprecip + l2.monthprecip + l3.monthprecip + l4.monthprecip + l5.monthprecip + l6.monthprecip + l7.monthprecip + l8.monthprecip + l9.monthprecip + l10.monthprecip + l11.monthprecip + l12.monthprecip + l13.monthprecip + l14.monthprecip
gen cumprecip16 = monthprecip + l.monthprecip + l2.monthprecip + l3.monthprecip + l4.monthprecip + l5.monthprecip + l6.monthprecip + l7.monthprecip + l8.monthprecip + l9.monthprecip + l10.monthprecip + l11.monthprecip + l12.monthprecip + l13.monthprecip + l14.monthprecip + l15.monthprecip
gen cumprecip17 = monthprecip + l.monthprecip + l2.monthprecip + l3.monthprecip + l4.monthprecip + l5.monthprecip + l6.monthprecip + l7.monthprecip + l8.monthprecip + l9.monthprecip + l10.monthprecip + l11.monthprecip + l12.monthprecip + l13.monthprecip + l14.monthprecip + l15.monthprecip + l16.monthprecip
gen cumprecip18 = monthprecip + l.monthprecip + l2.monthprecip + l3.monthprecip + l4.monthprecip + l5.monthprecip + l6.monthprecip + l7.monthprecip + l8.monthprecip + l9.monthprecip + l10.monthprecip + l11.monthprecip + l12.monthprecip + l13.monthprecip + l14.monthprecip + l15.monthprecip + l16.monthprecip + l17.monthprecip

sort iso_num month year

foreach n of numlist 3(3)18 {
*foreach n of numlist 3(3)18 {
	quietly gen mvg_avg`n' = ///
		(cumprecip`n'[_n-1] + cumprecip`n'[_n-2] + cumprecip`n'[_n-3] + cumprecip`n'[_n-4] + ///
		cumprecip`n'[_n-5] + cumprecip`n'[_n-6] + cumprecip`n'[_n-7] + cumprecip`n'[_n-8] + ///
		cumprecip`n'[_n-9] + cumprecip`n'[_n-10] + cumprecip`n'[_n-11] + cumprecip`n'[_n-12] + ///
		cumprecip`n'[_n-13] + cumprecip`n'[_n-14] + cumprecip`n'[_n-15] + cumprecip`n'[_n-16] + ///
		cumprecip`n'[_n-17] + cumprecip`n'[_n-18] + cumprecip`n'[_n-19] + cumprecip`n'[_n-20]) / 20 if month == month[_n-20]
	quietly gen mvg_sd`n' = ///
		(((cumprecip`n'[_n-1] - mvg_avg`n')^2 + (cumprecip`n'[_n-2] - mvg_avg`n')^2 + ///
		(cumprecip`n'[_n-3] - mvg_avg`n')^2 + (cumprecip`n'[_n-4] - mvg_avg`n')^2 + ///
		(cumprecip`n'[_n-5] - mvg_avg`n')^2 + (cumprecip`n'[_n-6] - mvg_avg`n')^2 + ///
		(cumprecip`n'[_n-7] - mvg_avg`n')^2 + (cumprecip`n'[_n-8] - mvg_avg`n')^2 + ///
		(cumprecip`n'[_n-9] - mvg_avg`n')^2 + (cumprecip`n'[_n-10] - mvg_avg`n')^2 + ///
		(cumprecip`n'[_n-11] - mvg_avg`n')^2 + (cumprecip`n'[_n-12] - mvg_avg`n')^2 + ///
		(cumprecip`n'[_n-13] - mvg_avg`n')^2 + (cumprecip`n'[_n-14] - mvg_avg`n')^2 + ///
		(cumprecip`n'[_n-15] - mvg_avg`n')^2 + (cumprecip`n'[_n-16] - mvg_avg`n')^2 + ///
		(cumprecip`n'[_n-17] - mvg_avg`n')^2 + (cumprecip`n'[_n-18] - mvg_avg`n')^2 + ///
		(cumprecip`n'[_n-19] - mvg_avg`n')^2 + (cumprecip`n'[_n-20] - mvg_avg`n')^2) / 20)^.5 if month == month[_n-20]
	quietly gen mscp`n' = (cumprecip`n' - mvg_avg`n') / mvg_sd`n'
	quietly gen wet_mscp`n' = abs(mscp`n')
	quietly replace wet_mscp`n' = 0 if mscp`n' < 0
	quietly gen dry_mscp`n' = mscp`n'
	quietly replace dry_mscp`n' = 0 if mscp`n' > 0
	quietly replace dry_mscp`n' = . if mscp`n' == .
	quietly replace dry_mscp`n' = abs(dry_mscp`n')
	quietly lab var mscp`n' "Moving standardized cumulative precipitation over `n' months"
	quietly lab var dry_mscp`n' "`n' month dry MSCP"
	quietly lab var wet_mscp`n' "`n' month wet MSCP"
	}

*gen drought = 0
*replace drought = 1 if stdprecip < -1 & l1.stdprecip < -1 & l2.stdprecip < -1
*gen dry = stdprecip < -1

lab var monthprecip "Monthly preciption (country average)"
lab var monthmean "Long-term monthly mean precipitation"
lab var monthsd "Long-term monthly precipitation standard deviation"
lab var stdprecip "Standardized monthly precipitation"
drop ctrymin ctrymax centmo q1 q3 iqr wet_month dry_month cumprecip1-cumprecip18  mvg_avg3 mvg_sd3 mvg_avg6 mvg_sd6 mvg_avg9 mvg_sd9 mvg_avg12 mvg_sd12 mvg_avg15 mvg_sd15 mvg_avg18 mvg_sd18

*tempfile `precip'
*save precip, replace
compress
sort iso_num year month
save "data/gpcc_mscp_africa_recode.dta", replace
*outsheet using "data/GPCC_MSCP_Africa_recode.csv", replace

exit
