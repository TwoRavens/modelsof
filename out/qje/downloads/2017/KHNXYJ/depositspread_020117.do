set more off
cd "output"

use "..\data\sample_call_final", clear
keep cert totdep assets loans reloans ciloansother securities depexp date ff_tar_quar_avg ff_tar quar assets_2010

save "..\temp\callreprt_short", replace

******************************
** STEP 1: CREATE VARIABLES 
*******************************'

use "..\temp\callreprt_short", clear

sort cert quar
tsset cert quar

foreach name in  "totdep" "assets" "loans" "securities" "reloans" "ciloansother"  {
	gen temp1 = ln(`name')
	gen temp2 = 100*d1.temp1
	winsor temp2, gen(d1_`name') p(0.01)
	drop temp1 temp2	
	}	
	

gen quarter=quarter(date)
gen depexp_q=depexp if quarter==1
replace depexp_q=depexp-l1.depexp if quarter>1
gen temp = 4*100*(depexp_q)/l1.totdep
winsor temp, gen(exp_tot) p(0.01)
gen spread_tot = ff_tar_quar_avg-exp_tot
gen d1_spread_tot=d1.spread_tot
drop temp exp_tot

gen d1_fftar=d1.ff_tar

********************************
** STEP 2: ESTIMATE BANK-LEVEL REGRESSIONS
*******************************'

keep if quar>=tq(1994,q1) & quar<=tq(2013,q4)

foreach name in  "spread_tot" "totdep" "assets" "loans" "securities" "reloans" "ciloansother"   {
	statsby _b _se, by(cert) saving("../temp/betas_4lags_`name'", replace):  reg  d1_`name' d1_fftar l1.d1_fftar l2.d1_fftar l3.d1_fftar l4.d1_fftar
}


********************************
** STEP 3: COUNT OBS BY BANK
*******************************'

* NOTE:  Assets 2010 is inflation-adjusted assets (using CPI)
collapse (mean) assets_2010 (count) obs=spread_tot, by(cert) fast
sort cert
save "..\temp\bank_obs", replace


********************************
** STEP 4: COMPUTE BETAS
*******************************'

foreach name in "spread_tot" "totdep" "assets" "loans" "securities"  "reloans" "ciloansother" {

		use "..\temp\betas_4lags_`name'", clear

		merge 1:1 cert using "..\temp\bank_obs"
		keep if _merge==3
		drop _merge	
*		keep if obs>=20
		
		drop if _b_d1_fftar==. | _stat_2==. |  _stat_3==. |  _stat_4==. | _stat_5==.
		drop if _b_d1_fftar==0 | _stat_2==0 |  _stat_3==0 |  _stat_4==0 | _stat_5==0
*		drop if _se_d1_fftar==0 
	
		gen temp = _b_d1_fftar+ _stat_2+ _stat_3+ _stat_4+ _stat_5
		drop if temp==.
		
		winsor temp, gen(`name'_beta10) p(0.10)	
		winsor temp, gen(`name'_beta1) p(0.01)	
		sort cert
		
		keep `name'_beta10 `name'_beta1 cert
		sort cert
		
		save "..\temp\betas_4lags_`name'_short", replace
}


********************************
** STEP 5: CREATE FINAL SAMPLE
*******************************'


use "../temp/betas_4lags_spread_tot_short", clear

foreach name in "totdep" "assets" "securities" "loans" "reloans" "ciloansother"  {

	merge 1:1 cert using "../temp/betas_4lags_`name'_short"
	keep if _merge==3
	drop _merge	

}
	
	
merge 1:1 cert using "..\temp\bank_obs"
keep if _merge==3
drop _merge	

save "..\temp\merged_betas", replace


********************************
** STEP 6: CREATE FIGURES AND TABLES
*******************************'

local loop=0
 
foreach name in "totdep" "assets" "securities" "loans" "reloans" "ciloansother" {

	use "..\temp\merged_betas", clear

	xtile size = spread_tot_beta10, nq(100)
	replace size = 1 if size==10
	sort size
	by size: egen quantity=mean(`name'_beta10)
	by size: egen price=mean(spread_tot_beta10)

	graph twoway (scatter quantity price,  name(`name') xtitle("Deposit Spread Beta") xlabel(0.3(0.1)0.9)  legend(off))  (lfit quantity price)
	graph export "..\figures\depositspread_`name'.pdf", replace
	
	reg `name'_beta1 spread_tot_beta1, robust
	if `loop'==0 {
		outreg2 using "..\tables\table9.txt", ctitle(`name') replace se bdec(3) bracket e(r2 r2_a df_r df_a )
	}
	else  {
		outreg2 using "..\tables\table9.txt", ctitle(`name') append se bdec(3) bracket e(r2 r2_a df_r df_a )
	}
		
	sum assets_2010, detail
	gen cutoff = r(p95)
	
	gen temp=spread_tot_beta10 if assets_2010>=cutoff
	xtile size2 = temp, nq(100)
	replace size2 = 1 if size2==15
	sort size2
	by size2: egen quantity2=mean(`name'_beta10)
	by size2: egen price2=mean(spread_tot_beta10)
	
	*  ylabel(-8(4)8)

	graph twoway (scatter quantity2 price2 if assets_2010>=cutoff, xtitle("Deposit Spread Beta") xlabel(0.3(0.1)0.9)  name(l_`name')  legend(off))  (lfit quantity2 price2)
	graph export "..\figures\depositspread_l_`name'.pdf", replace
	reg `name'_beta1 spread_tot_beta1 if assets_2010>=cutoff, robust	
	
	if `loop'==0 {
		outreg2 using "..\tables\table10.txt", ctitle(`name') replace se bdec(3) bracket e(r2 r2_a df_r df_a )
	}
	else  {
		outreg2 using "..\tables\table10.txt", ctitle(`name') append se bdec(3) bracket e(r2 r2_a df_r df_a )
	}
	local loop=`loop'+1
	
}

graph combine totdep assets securities loans 
graph export "..\figures\figure_6.pdf", replace
graph combine l_totdep l_assets l_securities l_loans 
graph export "..\figures\figure_7.pdf", replace

graph drop _all

