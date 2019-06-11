clear all
set mem 20g
set matsize 10000
set maxvar  10000
set more off

cd "output"

*************
** Table 8  *
*************
use "..\data\sample_call_final", clear

sort cert quar
merge m:1 cert using  "..\temp\cert_branches.dta"
drop if _merge==2
drop _merge

sort cert quar
gen mergercontrol2=0
replace mergercontrol2=1 if (assets-l1.assets)/l1.assets>1
drop if mergercontrol2==1

gen zerolower=0
replace zerolower=1 if year>=2009
egen certzero = group(cert zerolower)

keep if quar>=tq(1994q1) & quar<=tq(2013q4)

drop if d1_totdep==. | d1_transdep==. | d1_savdep==. |  d1_timedepg100k==. | d1_timedepl100k==. | d1_timedep==. | d1_spread_tot==.
drop if d1_assets==.  | d1_cash==. | d1_securities==. | d1_reloans==. | d1_ciloansother==. | d1_persloans==. | d1_otherassets==. | d1_loans==.
drop if d1_totliab==. | d1_nondep==. | d1_wholesale==. 


********************************************
** Summary statistics  -- Table 1, Panel D *
********************************************
gen highherf=.
sum l1_herfdepcty, detail
replace highherf=1 if l1_herfdepcty>=r(p50)
replace highherf=0 if l1_herfdepcty<r(p50)

gen assets_mil=assets/1000
gen totliab_mil=totliab/1000
gen totdep_mil=totdep/1000

outreg2 if highherf~=. using  "..\tables\table1_panel_d.txt", replace sum(log) keep(assets_mil totdep_mil totdep_l branches l1_herfdepcty) eqkeep(N mean sd)
outreg2 if highherf==0 & highherf~=. using  "..\tables\table1_panel_d.txt", append sum(log) keep(assets_mil totdep_mil totdep_l branches l1_herfdepcty) eqkeep(N mean sd)
outreg2 if highherf==1 & highherf~=.  using  "..\tables\table1_panel_d.txt", append sum(log) keep(assets_mil totdep_mil totdep_l branches l1_herfdepcty) eqkeep(N mean sd)


reghdfe d1_totdep d1_ff_l1_herfdepcty l1_herfdepcty, absorb(cert quar certzero) vce(cluster cert) tolerance(0.00001) maxiterations(100000)
outreg2 using "..\tables\table8.txt", replace se bdec(3) bracket e(r2 r2_a df_r df_a )
reghdfe d1_spread_tot d1_ffavg_l1_herfdepcty l1_herfdepcty, absorb(cert quar certzero) vce(cluster cert ) tolerance(0.00001) maxiterations(100000)
outreg2 using "..\tables\table8.txt", append se bdec(3) bracket e(r2 r2_a df_r df_a )
reghdfe d1_savdep d1_ff_l1_herfdepcty l1_herfdepcty, absorb(cert quar certzero) vce(cluster cert ) tolerance(0.00001) maxiterations(100000)
outreg2 using "..\tables\table8.txt", append se bdec(3) bracket e(r2 r2_a df_r df_a )
reghdfe d1_timedep  d1_ff_l1_herfdepcty l1_herfdepcty, absorb(cert quar certzero) vce(cluster cert ) tolerance(0.00001) maxiterations(100000)
outreg2 using "..\tables\table8.txt", append se bdec(3) bracket e(r2 r2_a df_r df_a )
reghdfe d1_wholesale d1_ff_l1_herfdepcty l1_herfdepcty, absorb(cert quar certzero) vce(cluster cert) tolerance(0.00001) maxiterations(100000)
outreg2 using "..\tables\table8.txt", append se bdec(3) bracket e(r2 r2_a df_r df_a )
reghdfe d1_totliab  d1_ff_l1_herfdepcty l1_herfdepcty, absorb(cert quar certzero) vce(cluster cert) tolerance(0.00001) maxiterations(100000)
outreg2 using "..\tables\table8.txt", append se bdec(3) bracket e(r2 r2_a df_r df_a )

reghdfe d1_assets d1_ff_l1_herfdepcty l1_herfdepcty, absorb(cert quar certzero) vce(cluster cert) tolerance(0.00001) maxiterations(100000)
outreg2 using "..\tables\table8.txt", append se bdec(3) bracket e(r2 r2_a df_r df_a )
reghdfe d1_cash d1_ff_l1_herfdepcty l1_herfdepcty, absorb( cert quar  certzero ) vce(cluster   cert) tolerance(0.00001) maxiterations(100000)
outreg2 using "..\tables\table8.txt", append se bdec(3) bracket e(r2 r2_a df_r df_a )
reghdfe d1_securities d1_ff_l1_herfdepcty l1_herfdepcty, absorb( cert quar certzero) vce(cluster   cert) tolerance(0.00001) maxiterations(100000)
outreg2 using "..\tables\table8.txt", append se bdec(3) bracket e(r2 r2_a df_r df_a )
reghdfe d1_loans d1_ff_l1_herfdepcty l1_herfdepcty, absorb( cert quar  certzero) vce(cluster cert) tolerance(0.00001) maxiterations(100000)
outreg2 using "..\tables\table8.txt", append se bdec(3) bracket e(r2 r2_a df_r df_a )
reghdfe d1_reloans d1_ff_l1_herfdepcty l1_herfdepcty, absorb( cert quar  certzero) vce(cluster  cert) tolerance(0.00001) maxiterations(100000)
outreg2 using "..\tables\table8.txt", append se bdec(3) bracket e(r2 r2_a df_r df_a )
reghdfe d1_ciloansother d1_ff_l1_herfdepcty l1_herfdepcty, absorb( cert quar  certzero) vce(cluster  cert) tolerance(0.00001) maxiterations(100000)
outreg2 using "..\tables\table8.txt", append se bdec(3) bracket e(r2 r2_a df_r df_a )
