*** PREP GPCP DATA *****
*** prepares data for use by MASTER ANALYSIS
*** Todd G. Smith
*** updated 11 November 2012


clear
use "data/country_precip_data_Africa_only_1979_2008.dta"

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


foreach n of numlist 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 {
	quietly egen mvg_avg`n' = mean(cumprecip`n'), by(cow_code month)
	quietly egen mvg_sd`n' = sd(cumprecip`n'), by(cow_code month)
	quietly gen mvg_std_pre`n' = (cumprecip`n' - mvg_avg`n') / mvg_sd`n'
	quietly gen msp`n' = abs(mvg_std_pre`n')
	quietly gen wet_msp`n' = msp`n'
	quietly replace wet_msp`n' = 0 if mvg_std_pre`n' < 0
	quietly gen dry_msp`n' = msp`n'
	quietly replace dry_msp`n' = 0 if mvg_std_pre`n' > 0
	quietly lab var mvg_std_pre`n' "Moving standardized cumulative precipitation over `n' months"
	quietly lab var dry_msp`n' "Dry MSCP over `n' months"
	quietly lab var wet_msp`n' "Wet MSCP over `n' months"
	}

/*
sort cow_code month year

*quietly gen mvg_avg8 = (cumprecip8[_n-1] + cumprecip8[_n-2] + cumprecip8[_n-3] + cumprecip8[_n-4] + cumprecip8[_n-5] + cumprecip8[_n-6] + cumprecip8[_n-7] + cumprecip8[_n-8] + cumprecip8[_n-9] + cumprecip8[_n-10]) /10 if cow_code == 200 & month == month[_n-1]
*quietly gen mvg_sd8 = (((cumprecip8[_n-1] - mvg_avg8)^2 + (cumprecip8[_n-2] - mvg_avg8)^2 + (cumprecip8[_n-3]-mvg_avg8)^2 + (cumprecip8[_n-4]-mvg_avg8)^2 + (cumprecip8[_n-5]-mvg_avg8)^2 + (cumprecip8[_n-6]-mvg_avg8)^2 + (cumprecip8[_n-7]-mvg_avg8)^2 + (cumprecip8[_n-8]-mvg_avg8)^2 + (cumprecip8[_n-9]-mvg_avg8)^2 + (cumprecip8[_n-10]-mvg_avg8)^2)/10)^.5 if cow_code == 200 & month == month[_n-1]

foreach n of numlist 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 {
	quietly gen mvg_avg`n' = (cumprecip`n'[_n-1] + cumprecip`n'[_n-2] + cumprecip`n'[_n-3] + cumprecip`n'[_n-4] + cumprecip`n'[_n-5] + cumprecip`n'[_n-6] + cumprecip`n'[_n-7] + cumprecip`n'[_n-8] + cumprecip`n'[_n-9] + cumprecip`n'[_n-10]) / 10 if cow_code == 200 & month == month[_n-1]
	quietly gen mvg_sd`n' = (((cumprecip`n'[_n-1] - mvg_avg`n')^2 + (cumprecip`n'[_n-2] - mvg_avg`n')^2 + (cumprecip`n'[_n-3]-mvg_avg`n')^2 + (cumprecip`n'[_n-4]-mvg_avg`n')^2 + (cumprecip`n'[_n-5]-mvg_avg`n')^2 + (cumprecip`n'[_n-6]-mvg_avg`n')^2 + (cumprecip`n'[_n-7]-mvg_avg`n')^2 + (cumprecip`n'[_n-8]-mvg_avg`n')^2 + (cumprecip`n'[_n-9]-mvg_avg`n')^2 + (cumprecip`n'[_n-10]-mvg_avg`n')^2) / 10)^.5 if cow_code == 200 & month == month[_n-1]
	quietly gen mvg_std_pre`n' = (cumprecip`n' - mvg_avg`n') / mvg_sd`n' if cow_code == 200
	quietly gen msp`n' = abs(mvg_std_pre`n') if cow_code == 200
	quietly gen wet_msp`n' = msp`n' if cow_code == 200
	quietly replace wet_msp`n' = 0 if mvg_std_pre`n' < 0 & cow_code == 200
	quietly gen dry_msp`n' = msp`n' if cow_code == 200
	quietly replace dry_msp`n' = 0 if mvg_std_pre`n' > 0 & cow_code == 200
	quietly lab var mvg_std_pre`n' "Moving standardized cumulative precipitation over `n' months"
	quietly lab var dry_msp`n' "Dry MSCP over `n' months"
	quietly lab var wet_msp`n' "Wet MSCP over `n' months"
	}

foreach c of numlist 402 403 404 411 420 432 433 434 435 436 437 438 439 450 451 452 461 471 475 481 482 483 484 490 500 501 510 516 517 520 522 540 541 551 552 553 560 565 570 571 572 580 581 590 600 615 616 620 625 651 {
	foreach n of numlist 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 {
		quietly replace mvg_avg`n' = (cumprecip`n'[_n-1] + cumprecip`n'[_n-2] + cumprecip`n'[_n-3] + cumprecip`n'[_n-4] + cumprecip`n'[_n-5] + cumprecip`n'[_n-6] + cumprecip`n'[_n-7] + cumprecip`n'[_n-8] + cumprecip`n'[_n-9] + cumprecip`n'[_n-10]) /10 if cow_code == `c' & month == month[_n-1]
		quietly replace mvg_sd`n' = (((cumprecip`n'[_n-1] - mvg_avg`n')^2 + (cumprecip`n'[_n-2] - mvg_avg`n')^2 + (cumprecip`n'[_n-3]-mvg_avg`n')^2 + (cumprecip`n'[_n-4]-mvg_avg`n')^2 + (cumprecip`n'[_n-5]-mvg_avg`n')^2 + (cumprecip`n'[_n-6]-mvg_avg`n')^2 + (cumprecip`n'[_n-7]-mvg_avg`n')^2 + (cumprecip`n'[_n-8]-mvg_avg`n')^2 + (cumprecip`n'[_n-9]-mvg_avg`n')^2 + (cumprecip`n'[_n-10]-mvg_avg`n')^2)/10)^.5 if cow_code == `c' & month == month[_n-1]
		quietly replace mvg_std_pre`n' = (cumprecip`n' - mvg_avg`n') / mvg_sd`n' if cow_code == `c'
		quietly replace msp`n' = abs(mvg_std_pre`n') if cow_code == `c'
		quietly replace wet_msp`n' = msp`n' if cow_code == `c'
		quietly replace wet_msp`n' = 0 if mvg_std_pre`n' < 0 & cow_code == `c'
		quietly replace dry_msp`n' = msp`n' if cow_code == `c'
		quietly replace dry_msp`n' = 0 if mvg_std_pre`n' > 0 & cow_code == `c'
		}
	}
*/
lab var wet_precip "Wet standardized precipitaiton (SDs above long-term monthly mean)"
lab var dry_precip "Dry standardized precipitaiton (SDs below long-term monthly mean)"

egen q1 = pctile(monthprecip), p(25) by(cow_code month)
egen q3 = pctile(monthprecip), p(75) by(cow_code month)
egen iqr = iqr(monthprecip), by(cow_code month)
gen wet_month = monthprecip > (q3 + (iqr * 1))
gen dry_month = monthprecip < (q1 - (iqr * 1))

drop monthcv-month95pct

*gen drought = 0
*replace drought = 1 if stdprecip < -1 & l1.stdprecip < -1 & l2.stdprecip < -1
*gen dry = stdprecip < -1

tempfile `precip'
save precip, replace

exit
