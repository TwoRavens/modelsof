* Top occupations table: Table 1
cd ..\dta
use mnvr_ipums_occ_ALM_1980, clear
gsort -sharehs
gen rank_sharehs = _n if _n<=10
gsort -sharems
gen rank_sharems = _n if _n<=10
gsort -sharels
gen rank_sharels = _n if _n<=10
keep if rank_sharehs!=. | rank_sharems!=. | rank_sharels!=.
sort rank_sharehs rank_sharems rank_sharels
keep occ8090 desc_occ8090 perwt sharehs sharems sharels normsts normfinger normmath normdcp normehf
order occ8090 desc_occ8090 perwt sharehs sharems sharels normsts normfinger normmath normdcp normehf
save ..\results\mnvr_tab1, replace


* Mean skill content by skill level: Table 2
use mnvr_ipums_occ_ALM_1980, clear
keep if _n<=5
keep s_hs_normsts- s_ls_normehf
foreach var of newlist s_hs s_ms s_ls {
replace `var'_normsts = `var'_normfinger if _n==2
replace `var'_normsts = `var'_normmath if _n==3
replace `var'_normsts = `var'_normdcp if _n==4
replace `var'_normsts = `var'_normehf if _n==5
}
keep s_hs_normsts- s_ls_normsts
foreach var of newlist s_hs s_ms s_ls {
rename `var'_normsts `var'
}
save ..\results\mnvr_tab2, replace

