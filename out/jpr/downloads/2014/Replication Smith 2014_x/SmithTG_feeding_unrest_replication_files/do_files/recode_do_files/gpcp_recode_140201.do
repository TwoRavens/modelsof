*** PREP GPCP DATA *****
*** prepares data for use by MASTER ANALYSIS
*** Todd G. Smith
*** updated 11 November 2012


clear
use "data/raw_data/GPCP_country_precip_data_Africa_only_1979_2008.dta"

*collapse (sum) monthprecip (mean) precip_area, by(cow_code year)
*rename monthprecip annualprecip

xtset cow_code centmo
gen stdprecip = (monthprecip - monthmean) / monthsd
gen wet_precip = stdprecip
replace wet_precip = 0 if stdprecip < 0
gen dry_precip = abs(stdprecip)
replace dry_precip = 0 if stdprecip > 0
*replace stdprecip = abs(stdprecip)

* generates variables x month cumulatives and "moving standardized precipitation" (MSP)
* MSP = standard deviations above (wet_msp) or below (dry_msp) 12 month moving average

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


foreach n of numlist 6 9 12 {
	quietly egen mvg_avg`n' = mean(cumprecip`n'), by(cow_code month)
	quietly egen mvg_sd`n' = sd(cumprecip`n'), by(cow_code month)
	quietly gen mvg_std_pre`n' = (cumprecip`n' - mvg_avg`n') / mvg_sd`n'
	quietly gen msp`n' = abs(mvg_std_pre`n')
	quietly gen wet_msp`n' = msp`n'
	quietly replace wet_msp`n' = 0 if mvg_std_pre`n' < 0
	quietly gen dry_msp`n' = msp`n'
	quietly replace dry_msp`n' = 0 if mvg_std_pre`n' > 0
	quietly lab var mvg_std_pre`n' "Moving standardized cumulative precipitation over `n' months"
	quietly lab var dry_msp`n' "Dry MSCP over `n' months (GPCP)"
	quietly lab var wet_msp`n' "Wet MSCP over `n' months (GPCP)"
	}

lab var wet_precip "Wet standardized precipitaiton (GPCP)"
lab var dry_precip "Dry standardized precipitaiton (GPCP)"

egen q1 = pctile(monthprecip), p(25) by(cow_code month)
egen q3 = pctile(monthprecip), p(75) by(cow_code month)
egen iqr = iqr(monthprecip), by(cow_code month)
gen wet_month = monthprecip > (q3 + (iqr * 1))
gen dry_month = monthprecip < (q1 - (iqr * 1))

keep cow_code year month centmo wet_msp6 dry_msp6 wet_msp9 dry_msp9 wet_msp12 dry_msp12
rename centmo time
rename wet_msp6 GPCP_wet6
rename dry_msp6 GPCP_dry6
rename wet_msp9 GPCP_wet9
rename dry_msp9 GPCP_dry9
rename wet_msp12 GPCP_wet12
rename dry_msp12 GPCP_dry12

foreach var of varlist GPCP_wet6 GPCP_dry6 GPCP_wet9 GPCP_dry9 GPCP_wet12 GPCP_dry12 {
	gen l_`var' = l.`var'
	}

lab var l_GPCP_wet6 "Wet MSCP over 6 months (GPCP)"
lab var l_GPCP_dry6 "Dry MSCP over 6 months (GPCP)"
lab var l_GPCP_wet9 "Wet MSCP over 9 months (GPCP)"
lab var l_GPCP_dry9 "Dry MSCP over 9 months (GPCP)"
lab var l_GPCP_wet12 "Wet MSCP over 12 months (GPCP)"
lab var l_GPCP_dry12 "Dry MSCP over 12 months (GPCP)"

replace time = time - 721
format time %tmMon_CCYY

save "data/gpcp_africa_recode_140201", replace

exit
