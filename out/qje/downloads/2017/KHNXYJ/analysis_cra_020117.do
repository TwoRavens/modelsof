clear all
set mem 20g
set matsize 10000
set maxvar  10000
set more off

cd "output"

******************************************
* create file with bank characteristics **
******************************************

use "..\data\sample_call_final", clear

gen quarter=quarter(date)
keep if quarter==4
rename bankid rssd_id
rename ff_tar fftar_end
keep assets_2010 assets herfdepcty  year rssd_id fftar_end

tsset rssd_id year
gen l1_herfdepcty=l1.herfdepcty
drop herfdepcty
rename l1_herfdepcty herfdepcty

merge 1:m rssd_id year using "..\data\cra_short"
keep if _merge==3
drop _merge
keep if year>=1997

sort  year
merge m:1 year using "..\data\ff_tar_yearend"
drop if _merge==2
drop _merge

sort year
merge m:1 year using "..\data\cpi_fred_year"
drop if _merge==2
drop _merge

rename rssd_id bankid
gen double fips=state*1000+county
gen double fipsyear=fips*10000+year
gen double fipsbank=bankid*100000+fips

sort fips
merge m:1 fips using "..\data\avgherfdepcty"
drop if _merge==2
drop _merge

gen d1_ffm_herfdepcty=d1_fftar_yearend*herfdepcty
gen d1_ffm_avgherfdepcty=d1_fftar_yearend*avgherfdepcty

gen tot_amt=small_loan_amt+medium_loan_amt+large_loan_amt
gen log_tot_amt=log(small_loan_amt+medium_loan_amt+large_loan_amt)

sort fipsbank year 
tsset fipsbank year

save "..\temp\cra_bank_county", replace


*****************
*** Table 6  ***
****************
use "..\temp\cra_bank_county", clear

gen tot_amt_2010=tot_amt/cpi
sort fipsbank year 
by fipsbank: egen avg_tot_amt=mean(tot_amt_2010)
keep if tot_amt_2010>=100

gen zerolower=0
replace zerolower=1 if year>=2009
egen bankidzero = group(bankid zerolower)
egen fipszero = group(fips zerolower)
egen fipsbankzero = group(fipsbank zerolower)

drop if log_tot_amt==. | d1_ffm_herfdepcty==. |  d1_ffm_avgherfdepcty==. | herfdepcty==.

forvalues i = 1(1)5 {
	foreach fixedeffect in fipsyear fipsbank bankid year fipszero {
		sort `fixedeffect'
		by `fixedeffect': egen obs=count(fips)
		drop if obs==1
		drop obs
	}
}

*************************
*** Table 1, Panel E  ***
*************************
gen highherf=.
sum herfdepcty, detail
replace highherf=1 if herfdepcty>=r(p50)
replace highherf=0 if herfdepcty<r(p50)
gen assets_2010_bil=assets_2010/1000000

outreg2 using  "..\tables\table1_panel_e.txt", replace sum(log) keep(tot_amt_2010 log_tot_amt assets_2010_bil herfdepcty) eqkeep(N mean sd)
outreg2 if highherf==0   using "..\tables\table1_panel_e.txt", append sum(log) keep(tot_amt_2010 log_tot_amt assets_2010_bil herfdepcty) eqkeep(N mean sd)
outreg2 if highherf==1  using "..\tables\table1_panel_e.txt", append sum(log) keep(tot_amt_2010 log_tot_amt assets_2010_bil herfdepcty) eqkeep(N mean sd)

******************************
******** Table 6, Cols 1-2 **
******************************

reghdfe log_tot_amt d1_ffm_herfdepcty herfdepcty avgherfdepcty, absorb(fipsyear fipsbank bankid year fipszero) cluster(bankid fips) tolerance(0.00001) maxiterations(100000)
outreg2 using "..\tables\table6.txt", replace se bdec(3) bracket e(r2 r2_a df_r df_a )
reghdfe log_tot_amt  d1_ffm_herfdepcty d1_ffm_avgherfdepcty herfdepcty avgherfdepcty, absorb(fipsbank bankid year fipszero fips) cluster(bankid fips) tolerance(0.00001) maxiterations(100000)
outreg2 using "..\tables\table6.txt", append  se bdec(3) bracket e(r2 r2_a df_r df_a )
reghdfe log_tot_amt  d1_ffm_herfdepcty d1_ffm_avgherfdepcty herfdepcty avgherfdepcty, absorb(fips fipszero bankid year) cluster(bankid fips) tolerance(0.00001) maxiterations(100000)
outreg2 using "..\tables\table6.txt" , append  se bdec(3) bracket e(r2 r2_a df_r df_a )
reghdfe log_tot_amt  d1_ffm_herfdepcty herfdepcty avgherfdepcty, absorb(fips fipszero bankid year) cluster(bankid fips) tolerance(0.00001) maxiterations(100000)
outreg2 using "..\tables\table6.txt", append  se bdec(3) bracket e(r2 r2_a df_r df_a )

***********************************************************************
*** analysis at the county level
**********************************************************************

* compute bank market shares by county-year
use "..\temp\cra_bank_county", replace

sort fips year
by fips year: egen fips_amt = total(tot_amt)
gen bank_fips_amt = tot_amt/fips_amt

* multiply bank-level HHI with market share
gen herfdepcty_amt=bank_fips_amt*herfdepcty

collapse (sum) herfdepcty_amt, by(fips year) fast
save "..\temp\herfdepcty_fips", replace

* analysis at county-level
use "..\temp\cra_bank_county", replace
collapse (sum) tot_amt, by(fips year)

merge m:1 fips using "..\data\avgherfdepcty"
drop if _merge==2
drop _merge

sort fips year
merge m:1 fips year using "..\temp\herfdepcty_fips"
drop if _merge==2
drop _merge

sort  year
merge m:1 year using "..\data\ff_tar_yearend"
drop if _merge==2
drop _merge

sort fips year
merge m:1 fips year using "..\data\bls_final"
drop if _merge==2
drop _merge

gen d1_ffm_herfdepcty_amt=d1_fftar_yearend*herfdepcty_amt
gen d1_ffm_avgherfdepcty=d1_fftar_yearend*avgherfdepcty

gen log_tot_amt=log(tot_amt)

gen zerolower=0
replace zerolower=1 if year>=2009
egen fipszero = group(fips zerolower)

************
* Table 7 **
************

drop if log_tot_amt==. |  d1_ffm_herfdepcty_amt==. | herfdepcty_amt==. |  d1_ffm_avgherfdepcty==. | d1_lnemp==. | d1_lntotwage==.

foreach fixedeffect in fips fipszero {
	sort `fixedeffect'
	by `fixedeffect': egen obs=count(fips)
	drop if obs==1
	drop obs
}

reghdfe log_tot_amt d1_ffm_herfdepcty_amt herfdepcty_amt, absorb(fips year fipszero) cluster(fips) tolerance(0.00001) maxiterations(100000)
outreg2 using "..\tables\table7.txt", replace se bdec(3) bracket e(r2 r2_a df_r df_a )
reghdfe log_tot_amt d1_ffm_herfdepcty_amt herfdepcty_amt  d1_ffm_avgherfdepcty, absorb(fips year fipszero) cluster(fips) tolerance(0.00001) maxiterations(100000)
outreg2 using "..\tables\table7.txt", append se bdec(3) bracket e(r2 r2_a df_r df_a )

reghdfe d1_lnemp d1_ffm_herfdepcty_amt herfdepcty_amt, absorb(fips year fipszero) cluster(fips) tolerance(0.00001) maxiterations(100000)
outreg2 using "..\tables\table7.txt", append se bdec(3) bracket e(r2 r2_a df_r df_a )
reghdfe d1_lnemp  d1_ffm_herfdepcty_amt herfdepcty_amt  d1_ffm_avgherfdepcty, absorb(fips year fipszero) cluster(fips) tolerance(0.00001) maxiterations(100000)
outreg2 using "..\tables\table7.txt", append se bdec(3) bracket e(r2 r2_a df_r df_a )

reghdfe d1_lntotwage d1_ffm_herfdepcty_amt herfdepcty_amt, absorb(fips year fipszero) cluster(fips) tolerance(0.00001) maxiterations(100000)
outreg2 using "..\tables\table7.txt", append se bdec(3) bracket e(r2 r2_a df_r df_a )
reghdfe d1_lntotwage  d1_ffm_herfdepcty_amt herfdepcty_amt  d1_ffm_avgherfdepcty, absorb(fips year fipszero) cluster(fips) tolerance(0.00001) maxiterations(100000)
outreg2 using "..\tables\table7.txt", append se bdec(3) bracket e(r2 r2_a df_r df_a )
