cd /Users/jeff/Documents/Academic/Research/Innovation.2008/
clear
set mem 6g
set matsize 1200
set more off

/* ------- */
/* Table 2 */
/* ------- */

capture program drop table2
program define table2

sum `1' [w=perwt]
sum `1' [w=perwt] if male==0
sum `1' [w=perwt] if agr1==1 | agr2==1
sum `1' [w=perwt] if agr3==1 | agr4==1 | agr5==1 | agr6==1
sum `1' [w=perwt] if agr7==1 | agr8==1 | agr9==1 | agr10==1
sum `1' [w=perwt] if agr11==1 | agr12==1
bysort educat: sum `1' [w=perwt]
sum `1' [w=perwt] if blck==1 | asia==1 | othr==1
sum `1' [w=perwt] if hisp==0

sum `1' [w=perwt] if geo_popcat==1
sum `1' [w=perwt] if geo_popcat==4

sum `1' [w=perwt] if ind1990>=010 & ind1990<=060	/* Ag min constr */
sum `1' [w=perwt] if ind1990>=100 & ind1990<=392	/* Mfg */
sum `1' [w=perwt] if ind1990>=400 & ind1990<=472	/* TCU */
sum `1' [w=perwt] if ind1990>=500 & ind1990<=691	/* W & R Trade */
sum `1' [w=perwt] if ind1990>=761 & ind1990<=791	/* Pers Svcs */
sum `1' [w=perwt] if (ind1990>=700 & ind1990<=760) | (ind1990>=800 & ind1990<=893)	/* oth svcs */

sum `1' [w=perwt] if occ_mpr==1
sum `1' [w=perwt] if occ_tsa==1
sum `1' [w=perwt] if occ_svc==1
sum `1' [w=perwt] if occ_pcr==1
sum `1' [w=perwt] if occ_ofl==1
end

log using log/table2.log, replace
use dta/ipums/2000/2000-wk2, clear
gen matchyear = year
drop if geoid==542
sort geoid matchyear
merge geoid matchyear using tmp/geo-final, nok
	tab _m
	drop _m	
table2 new_lin
table2 new_cenx

use dta/ipums/1990/1990-wk2, clear
gen matchyear = year
drop if geoid==542
sort geoid matchyear
merge geoid matchyear using tmp/geo-final, nok
	tab _m
	drop _m	
table2 newtsh_convt
table2 newtsh_convt91

use dta/ipums/1980/1980-wk2, clear
*sample 20
gen matchyear = year
drop if geoid==542
sort geoid matchyear
merge geoid matchyear using tmp/geo-final, nok
	tab _m
	drop _m	
table2 newmaster_tsh
table2 new_tsh

log close


/* ------- */
/* Table 3 */
/* ------- */

capture program drop table3
program define table3
keep if wage>.01 & wage<=100
drop if geoid==542 * Alaska
sum `1'
reg lnw `1', vce(cluster occ)
areg lnw `1' male marr blck asia othr fb hisp hs sc col agr2-agr12 hhead ind_*, absorb(geoid) vce(cluster occ)
end

log using log/table3.log, replace
use dta/ipums/2000/2000-wk2, clear
table3 new_lin

use dta/ipums/1990/1990-wk2, clear
table3 newtsh_convt

use dta/ipums/1980/1980-wk2, clear
table3 newmaster_tsh

log close


/* ------- */
/* Table 4 */
/* ------- */

capture program drop table4
program define table4
qui drop if geoid==542 /* Drop Hawaii */
capture keep year region statefip occ-`2'
qui replace `1'=`1'*100
local basics "hs sc col potx potx2 male marr blck asia othr hisp fb"
local majori "ind_mfg ind_tcu ind_trd ind_svc ind_pub"
qui tab geoid, gen(geo_)
sum `basics'
areg `1' `basics', absorb(geoid) vce(cluster occ)
reg `1' `basics' geo_1-geo_363, vce(cluster occ) noc
testparm geo_1-geo_363
areg `1' `basics' `majori', absorb(geoid) vce(cluster occ)
reg `1' `basics' `majori' geo_1-geo_363, vce(cluster occ) noc
testparm geo_1-geo_363
end

log using log/table4.log, replace
use dta/ipums/2000/2000-wk2, clear
table4 new_lin
use dta/ipums/1990/1990-wk2, clear
table4 newtsh_convt
use dta/ipums/1980/1980-wk2, clear
table4 newmaster_tsh
log close



/* -------- */
/* Table 5  */
/* -------- */

log using log/table5.log, replace
use tmp/geo_fe_pooled1, clear
replace geo_ih_sf = -geo_ih_sf
bysort year: sum geo_col geo_hs geo_ih_sf geo_lndens
qui xi i.geoid i.year
xtset geoid year

	local main "geo_col geo_hs geo_ih_sf geo_lndens"
	local all "_Iyear_* _Igeoid_*"

	reg gt_fe1 `main' `all' [aw=gt_wt1], vce(cluster geoid)
	testparm `main'
	reg gt_fe5 `main' `all' [aw=gt_wt5], vce(cluster geoid)
	testparm `main'
	reg gt_fe6 `main' `all' [aw=gt_wt6], vce(cluster geoid)
	testparm `main'
	reg gt_fe3 `main' `all' [aw=gt_wt3], vce(cluster geoid)
	testparm `main'
	reg gt_fe5 `main' `all' [aw=gt_wt5] if year!=1980
	testparm `main'

log close

/* ----------------------- */
/* Table 6. Worker sorting */
/* ----------------------- */

capture program drop stfecapture
program define stfecapture
	* Preamble
	compress
	qui matrix drop _all
	qui scalar drop _all
	qui drop if geoid==542 /* Drop Hawaii */

	*sample 10
	qui replace `2'=`2'*100

	local basics "hs sc col potx potx2 male marr blck asia othr fb hisp"
	gen sob = bpl if bpl<100
		replace sob = . if bpl==2 | bpl==15
		replace sob = 24 if sob==11
	gen sor = statefip if statefip<100
		replace sor = . if statefip==2 | statefip==15
		replace sor = 24 if statefip==11
	qui tab sob, gen(sob_)
	qui tab sor, gen(sor_)
	gen agr = 1 if age<35
	replace agr = 2 if age>=35
	
	reg `2' `basics' sob_*, vce(cluster occ) noc
	capture matrix b1=e(b)
	capture matrix V1=vecdiag(e(V))

	reg `2' `basics' sor_*, vce(cluster occ) noc
	capture matrix b2=e(b)
	capture matrix V2=vecdiag(e(V))
	
	replace sob = bpl
	replace sob = 100 if sob>=100 & sob<=120
	replace sob = 150 if sob>=150 & sob<=199
	replace sob = 210 if sob>=210 & sob<=260
	replace sob = 400 if sob>=400 & sob<=419
	replace sob = 420 if sob>=420 & sob<=429
	replace sob = 430 if sob>=430 & sob<=440
	replace sob = 450 if sob>=450 & sob<=459
	replace sob = 460 if sob>=460 & sob<=499
	replace sob = 500 if sob>=500 & sob<=509
	replace sob = 510 if sob>=510 & sob<=519
	replace sob = 520 if sob>=520 & sob<=524
	replace sob = 530 if sob>=530 & sob<=599
	replace sob = 700 if sob>=700 & sob<=710
	replace sob = 999 if sob>=800 & sob<=999
	qui xi i.sob*i.agr

	local basics "hs sc col potx potx2 male marr blck asia othr hisp"
	ivregress 2sls `2' `basics' (sor_* = _Isob_*), vce(cluster occ) noc
	capture matrix b3=e(b)
	capture matrix V3=vecdiag(e(V))
	estat first
	*estat overid

	ivregress 2sls `2' `basics' (sor_* = _Isob_* _Iagr_* _IsobXagr_*), vce(cluster occ) noc
	capture matrix b4=e(b)
	capture matrix V4=vecdiag(e(V))
	estat first
	*estat overid

	* Collapse and generate sob and sor FE's 
	egen tag = tag(sor)
	qui keep if tag	
	replace statefip = sor
	forvalues y = 1/4 {
		qui gen st_fe`y'=.
		qui gen st_var`y'=.
	}	
	forvalues g = 1/48 {
		qui local n=colnumb(b1,"sob_`g'")
		forvalues m = 1/2 {
		qui replace st_fe`m' = b`m'[1,`n'] if sor_`g'==1
		qui replace st_var`m' = V`m'[1,`n'] if sor_`g'==1
		}
		qui local n=colnumb(b3,"sor_`g'")
		qui replace st_fe3 = b3[1,`n'] if sor_`g'==1
		qui replace st_var3 = V3[1,`n'] if sor_`g'==1
		qui replace st_fe4 = b4[1,`n'] if sor_`g'==1
		qui replace st_var4 = V4[1,`n'] if sor_`g'==1
	}
	* Weights
	forvalues z = 1/4 {
	qui gen st_wt`z' = 1/(st_var`z')
	}
	keep statefip year region st_*
	sort statefip
	save tmp/st_fe_`1'_`2', replace
end


	/* Movers and non-movers */

log using log/table6.log, replace
use tmp/geo_fe_pooled1, clear
replace geo_ih_sf = -geo_ih_sf
qui xi i.year*i.state i.year*i.region i.geoid
	local main "geo_col geo_hs geo_ih_sf geo_lndens"
	local all "_Iyear_* _Igeoid_*"
	reg gt_fe8 `main' `all' [aw=gt_wt8], vce(cluster geoid)
	reg gt_fe9 `main' `all' [aw=gt_wt9], vce(cluster geoid)
log close
		
	/* Create state characteristics as weighted averages of city characteristics */
	use tmp/geo-final, clear
	ren geo_statefip statefip
	collapse (mean) geo_col geo_hs geo_ih_sf geo_lndens [fw=geo_pop], by(statefip matchyear)
	sort statefip matchyear
	save tmp/state-final, replace	
	
	/* SOB - SOR OLS and IV regressions */
	
log using log/table6.log, append
	use dta/ipums/2000/2000-wk2, clear
	stfecapture 2000 new_lin
	use dta/ipums/1990/1990-wk2, clear
	stfecapture 1990 newtsh_convt
log close

log using log/table6.log, append
	use dta/ipums/1980/1980-wk2, clear
	stfecapture 1980 newmaster_tsh
	
	use tmp/st_fe_2000_new_lin
	append using tmp/st_fe_1990_newtsh_convt
	append using tmp/st_fe_1980_newmaster_tsh
	gen matchyear = year
	sort statefip matchyear
	merge statefip matchyear using tmp/state-final, nok
		tab _m
		drop _m
	save tmp/st_fe_pooled, replace
	
	use tmp/st_fe_pooled, clear
	replace geo_ih_sf = -geo_ih_sf
	ren statefip state
	qui xi i.year i.state

	local main "geo_col geo_hs geo_ih_sf geo_lndens"
	local all "_Iyear_* _Istate_*"
	reg st_fe1 `main' `all' [aw=st_wt1], vce(cluster state)
	reg st_fe2 `main' `all' [aw=st_wt2], vce(cluster state)
	reg st_fe3 `main' `all' [aw=st_wt3], vce(cluster state)
	reg st_fe4 `main' `all' [aw=st_wt4], vce(cluster state)
log close
	
		
		
/* -------------------------------- */
/* Table 7. Unobs city-year changes */
/* -------------------------------- */

use tmp/geo_fe_pooled1, clear
replace geo_ih_sf = -geo_ih_sf
qui xi i.year*i.state i.year*i.region i.geoid

replace matchyear = year - 10
foreach var in bbkpat bbknw bbkind age2 age3 age4 col hs ih_sf lndens {
	ren geo_`var' geo_`var't
}
sort geoid matchyear
merge geoid matchyear using tmp/geo-final, nok keep(geo_bbkind geo_bbkpat geo_bbknw geo_age2 geo_age3 geo_age4 geo_col geo_hs geo_ih_sf geo_lndens) update replace
	tab _m
	drop _m	
foreach var in bbkpat bbknw bbkind age2 age3 age4 col hs ih_sf lndens {
	ren geo_`var' geo_`var'l
	ren geo_`var't geo_`var'
}

local main "geo_col geo_hs geo_ih_sf geo_lndens"
local all "_Iyear_* _Igeoid_*"
local plus "geo_bbkind geo_bbknw geo_bbkpat"
local plus2 "geo_man_pums geo_pro_pums geo_tch_pums geo_sls_pums geo_adm_pums geo_svo_pums geo_pcr_pums geo_ofl_pums geo_trn_pums geo_mfg_pums geo_tcu_pums geo_wtr_pums geo_rtr_pums geo_svc_pums geo_pub_pums"

log using log/table7.log, replace

	/* Add additional city-year regressors */

	reg gt_fe5 `main' `all' _Ista* _IyeaXsta_* [aw=gt_wt5], vce(cluster geoid)
		testparm `main'
		testparm _Ista* _IyeaXsta_*

	reg gt_fe5 `main' `all' _Ireg* _IyeaXreg_* [aw=gt_wt5], vce(cluster geoid)
		testparm `main'
		testparm _Ireg* _IyeaXreg_* 
	reg gt_fe5 `main' `plus' `all' _Ireg* _IyeaXreg_* [aw=gt_wt5], vce(cluster geoid)
		testparm `plus'
	reg gt_fe5 `main' `plus' `plus2' `all' _Ireg* _IyeaXreg_* [aw=gt_wt5], vce(cluster geoid)
		testparm `plus' `plus2'
	
	/* Instrument for main city-year regressors */
	/* IV is lagged age structure and lagged industry structure (6) */
	ivregress 2sls gt_fe5 `all' (`main' = geo_age2l geo_age3l geo_age4l geo_bbknwl geo_bbkpatl geo_bbkindl) [aw=gt_wt5], vce(cluster geoid)
	estat first
	estat overid, forceweights

	ivregress 2sls gt_fe5 `all' (`main' = geo_age2l geo_age3l geo_age4l geo_coll geo_hsl geo_ih_sfl geo_lndensl) [aw=gt_wt5], vce(cluster geoid)
	estat first
	estat overid, forceweights

log close


/* -------------------- */
/* Table 9. Measurement */
/* -------------------- */

log using log/table8.log, replace

local all "_Iyear_* _Igeoid_*"

use tmp/geo_fe_pooled1, clear
replace geo_ih_sf = -geo_ih_sf
	gen geo_lncol = ln(geo_col*geo_pop)
	gen geo_lnhs = ln(geo_hs*geo_pop)
qui xi i.year i.geoid

sum geo_col geo_hs geo_ih_sf geo_lndens
reg gt_fe5 geo_col geo_hs geo_ih_sf geo_lndens `all' [aw=gt_wt5], vce(cluster geoid)
testparm geo_col geo_hs geo_ih_sf geo_lndens
sum geo_lncol geo_lnhs geo_id0_sf_ln geo_lndens
reg gt_fe5 geo_lncol geo_lnhs geo_id0_sf_ln geo_lndens `all' [aw=gt_wt5], vce(cluster geoid)
testparm geo_lncol geo_lnhs geo_id0_sf_ln geo_lndens
sum geo_lncol geo_lnhs geo_id1_pums_ln geo_lndens
reg gt_fe5 geo_lncol geo_lnhs geo_id1_pums_ln geo_lndens `all' [aw=gt_wt5], vce(cluster geoid)
testparm geo_lncol geo_lnhs geo_id1_pums_ln geo_lndens

use tmp/geo_fe_pooled2, clear
replace geo_ih_sf = -geo_ih_sf
	gen geo_lncol = ln(geo_col*geo_pop)
	gen geo_lnhs = ln(geo_hs*geo_pop)
qui xi i.year i.geoid

sum geo_col geo_hs geo_ih_sf geo_lndens
reg gt_fe5 geo_col geo_hs geo_ih_sf geo_lndens `all' [aw=gt_wt5], vce(cluster geoid)
testparm geo_col geo_hs geo_ih_sf geo_lndens
sum geo_lncol geo_lnhs geo_id0_sf_ln geo_lndens
reg gt_fe5 geo_lncol geo_lnhs geo_id0_sf_ln geo_lndens `all' [aw=gt_wt5], vce(cluster geoid)
testparm geo_lncol geo_lnhs geo_id0_sf_ln geo_lndens
sum geo_lncol geo_lnhs geo_id1_pums_ln geo_lndens
reg gt_fe5 geo_lncol geo_lnhs geo_id1_pums_ln geo_lndens `all' [aw=gt_wt5], vce(cluster geoid)
testparm geo_lncol geo_lnhs geo_id1_pums_ln geo_lndens

log close

/* ------------------- */
/* Table 10. Occupation */
/* ------------------- */


capture program drop fecapture
program define fecapture
	* Preamble
	compress
	qui matrix drop _all
	qui scalar drop _all
	qui drop if geoid==542 /* Drop Hawaii */
	capture keep year region statefip occ-`2' recq nwq
	
	*sample 10
	qui replace `2'=`2'*100
	
	bysort occ: egen occemp = count(occ)
	xtile occempq = occemp, n(5)
	
	egen occtag = tag(occ)

	local basics "hs sc col potx potx2 marr male blck asia othr fb hisp"
	qui tab geoid, gen(geoid_)
	
	* by occ title share
	sum `2' if nwq==3 & occtag==1
	sum `2' if nwq==5 & occtag==1
	reg `2' `basics' geoid_1-geoid_363 if (nwq==3), vce(cluster occ) noc
	capture matrix b1=e(b)
	capture matrix V1=vecdiag(e(V))
	reg `2' `basics' geoid_1-geoid_363 if (nwq==5), vce(cluster occ) noc
	capture matrix b2=e(b)
	capture matrix V2=vecdiag(e(V))
	
	* by occ employment
	sum `2' if occempq==1 & occtag==1
	sum `2' if occempq==5 & occtag==1
	reg `2' `basics' geoid_1-geoid_363 if (occempq==1), vce(cluster occ) noc
	capture matrix b3=e(b)
	capture matrix V3=vecdiag(e(V))
	reg `2' `basics' geoid_1-geoid_363 if (occempq==5), vce(cluster occ) noc
	capture matrix b4=e(b)
	capture matrix V4=vecdiag(e(V))
	

	* by occ number of titles
	sum `2' if recq==1 & occtag==1
	sum `2' if recq==3 & occtag==1
	sum `2' if recq==5 & occtag==1
	reg `2' `basics' geoid_1-geoid_363 if (recq==1), vce(cluster occ) noc
	capture matrix b5=e(b)
	capture matrix V5=vecdiag(e(V))
	reg `2' `basics' geoid_1-geoid_363 if (recq==3), vce(cluster occ) noc
	capture matrix b6=e(b)
	capture matrix V6=vecdiag(e(V))
	reg `2' `basics' geoid_1-geoid_363 if (recq==5), vce(cluster occ) noc
	capture matrix b7=e(b)
	capture matrix V7=vecdiag(e(V))
	
	* summarize censored cases
	sum `2' if occflag==0
	sum `2' if occflag==0 & occtag==1
		
	* Collapse and gen geoid FE and s.e.'s
	egen tag = tag(geoid)
	qui keep if tag	
	local k = 7
	forvalues y = 1/`k' {
		qui gen gt_fe`y'=.
		qui gen gt_var`y'=.
	}	
	forvalues m = 1/`k' {
		forvalues g = 1/363 {
		qui local n=colnumb(b`m',"geoid_`g'")
		qui replace gt_fe`m' = b`m'[1,`n'] if geoid_`g'==1
		qui replace gt_var`m' = V`m'[1,`n'] if geoid_`g'==1
	}
	}
	* Weights
	forvalues z = 1/`k' {
	qui gen gt_wt`z' = 1/(gt_var`z')
	}
	
	keep geoid year	region gt_*
	sort geoid

	save tmp/gt_tbl9fe_`1'_`2', replace
end

log using log/table9.log, replace
use dta/ipums/2000/2000-wk2, clear
	fecapture 2000 new_lin
use dta/ipums/1990/1990-wk2, clear
	fecapture 1990 newtsh_convt
use dta/ipums/1980/1980-wk2, clear
	fecapture 1980 newmaster_tsh
	
use tmp/gt_tbl9fe_2000_new_lin, clear
append using tmp/gt_tbl9fe_1990_newtsh_convt
append using tmp/gt_tbl9fe_1980_newmaster_tsh
gen matchyear = year
sort geoid matchyear
merge geoid matchyear using tmp/geo-final, nok
	tab _m
	drop _m
ren geo_statefip state	
replace geo_ih_sf = -geo_ih_sf
qui xi i.year*i.region i.geoid

	local main "geo_col geo_hs geo_ih_sf geo_lndens"
	local all "_Iyear_* _Igeoid_*"

reg gt_fe1 `main' `all' [aw=gt_wt1], vce(cluster geoid)
reg gt_fe2 `main' `all' [aw=gt_wt2], vce(cluster geoid)
reg gt_fe3 `main' `all' [aw=gt_wt3], vce(cluster geoid)
reg gt_fe4 `main' `all' [aw=gt_wt4], vce(cluster geoid)
reg gt_fe5 `main' `all' [aw=gt_wt5], vce(cluster geoid) 
reg gt_fe6 `main' `all' [aw=gt_wt6], vce(cluster geoid)
reg gt_fe7 `main' `all' [aw=gt_wt7], vce(cluster geoid)


use tmp/geo_fe_pooled1, clear
replace geo_ih_sf = -geo_ih_sf
qui xi i.year*i.region i.geoid

reg gt_fe7 `main' `all' [aw=gt_wt7], vce(cluster geoid)
reg gt_fe7 `main' `all' _Ireg* _IyeaXreg_* [aw=gt_wt7], vce(cluster geoid)

log close

	
	
/* ----------------------- */
/* Table 8. Other decomps */
/* ----------------------- */

capture program drop fecapture
program define fecapture
	* Preamble
	compress
	qui matrix drop _all
	qui scalar drop _all
	qui drop if geoid==542 /* Drop Hawaii */
	capture keep year region statefip occ-`2'
	
	*sample 10
	qui replace `2'=`2'*100
	
	local basics "hs sc col potx potx2 marr male blck asia othr fb hisp"
	qui tab geoid, gen(geoid_)
	
	gen trdsvc = (ind1990>=440 & ind1990<=442) | (ind1990>=700 & ind1990<=711) | (ind1990>=721 & ind1990<=741)
	gen tranpo = (ind1990>=400 & ind1990<=432) | (ind1990>=500 & ind1990<=571)
	gen othsvc = (ind1990>=450 & ind1990<=932) & trdsvc==0 & tranpo==0
	
	reg `2' `basics' geoid_1-geoid_363 if trdsvc==1, vce(cluster occ) noc
	capture matrix b1=e(b)
	capture matrix V1=vecdiag(e(V))
	reg `2' `basics' geoid_1-geoid_363 if tranpo==1, vce(cluster occ) noc
	capture matrix b2=e(b)
	capture matrix V2=vecdiag(e(V))
	reg `2' `basics' geoid_1-geoid_363 if othsvc==1, vce(cluster occ) noc
	capture matrix b3=e(b)
	capture matrix V3=vecdiag(e(V))
		
	* Collapse and gen geoid FE and s.e.'s
	egen tag = tag(geoid)
	qui keep if tag	
	local k = 3
	forvalues y = 1/`k' {
		qui gen gt_fe`y'=.
		qui gen gt_var`y'=.
	}	
	forvalues m = 1/`k' {
		forvalues g = 1/363 {
		qui local n=colnumb(b`m',"geoid_`g'")
		qui replace gt_fe`m' = b`m'[1,`n'] if geoid_`g'==1
		qui replace gt_var`m' = V`m'[1,`n'] if geoid_`g'==1
	}
	}
	* Weights
	forvalues z = 1/`k' {
	qui gen gt_wt`z' = 1/(gt_var`z')
	}
	
	keep geoid year	region gt_*
	sort geoid

	save tmp/gt_tbl10fe_`1'_`2', replace
end


use tmp/geo_fe_pooled1, clear
replace geo_ih_sf = -geo_ih_sf
qui xi i.year*i.region i.geoid
bysort geoid: egen geo_popcat2=min(geo_popcat)

	local main "geo_col geo_hs geo_ih_sf geo_lndens"
	local all "_Iyear_* _Igeoid_*"

log using log/table10.log, replace

* By educ attainment and prime-age males only
* Maybe as part of table 6?

	reg gt_fe19 `main' `all' [aw=gt_wt19], vce(cluster geoid)
	reg gt_fe20 `main' `all' [aw=gt_wt20], vce(cluster geoid)
	reg gt_fe21 `main' `all' [aw=gt_wt21], vce(cluster geoid)
	reg gt_fe22 `main' `all' [aw=gt_wt22], vce(cluster geoid)
	
* By year

	xi i.year|geo_col i.year|geo_hs i.year|geo_lndens i.year|geo_ih_sf _Ireg* _IyeaXreg_*, prefix(_J) noomit
	reg gt_fe5 _J* `all' [aw=gt_wt5], vce(robust)
	drop _J*

* By city size 

	reg gt_fe5 `main' `all' _Ireg* _IyeaXreg_* [aw=gt_wt5] if geo_popcat2==1, vce(cluster geoid)
	reg gt_fe5 `main' `all' _Ireg* _IyeaXreg_* [aw=gt_wt5] if geo_popcat2==2, vce(cluster geoid)
	reg gt_fe5 `main' `all' _Ireg* _IyeaXreg_* [aw=gt_wt5] if geo_popcat2==3, vce(cluster geoid)
	reg gt_fe5 `main' `all' _Ireg* _IyeaXreg_* [aw=gt_wt5] if geo_popcat2==4, vce(cluster geoid)
	
* By industry

	reg gt_fe10 `main' `all' _Ireg* _IyeaXreg_* [aw=gt_wt10], vce(cluster geoid)
	reg gt_fe11 `main' `all' _Ireg* _IyeaXreg_* [aw=gt_wt11], vce(cluster geoid)
	reg gt_fe12 `main' `all' _Ireg* _IyeaXreg_* [aw=gt_wt12], vce(cluster geoid)
	reg gt_fe13 `main' `all' _Ireg* _IyeaXreg_* [aw=gt_wt13], vce(cluster geoid)
	reg gt_fe14 `main' `all' _Ireg* _IyeaXreg_* [aw=gt_wt14], vce(cluster geoid)
	reg gt_fe15 `main' `all' _Ireg* _IyeaXreg_* [aw=gt_wt15], vce(cluster geoid)
	reg gt_fe16 `main' `all' _Ireg* _IyeaXreg_* [aw=gt_wt16], vce(cluster geoid)
	reg gt_fe17 `main' `all' _Ireg* _IyeaXreg_* [aw=gt_wt17], vce(cluster geoid)
	reg gt_fe18 `main' `all' _Ireg* _IyeaXreg_* [aw=gt_wt18], vce(cluster geoid)
	
* By region

	local main "geo_col geo_hs geo_ih_sf geo_lndens"
	local all "_Iyear_* _Igeoid_*"

	reg gt_fe5 `main' `all' [aw=gt_wt5] if region<=22, vce(cluster geoid)
	reg gt_fe5 `main' `all' [aw=gt_wt5] if region==41 | region==42, vce(cluster geoid)
	reg gt_fe5 `main' `all' [aw=gt_wt5] if region==31 | region==32 | region==33, vce(cluster geoid)
	
* By industry, cont'd

use dta/ipums/2000/2000-wk2, clear
	fecapture 2000 new_lin
use dta/ipums/1990/1990-wk2, clear
	fecapture 1990 newtsh_convt
use dta/ipums/1980/1980-wk2, clear
	fecapture 1980 newmaster_tsh

use tmp/gt_tbl10fe_2000_new_lin, clear
append using tmp/gt_tbl10fe_1990_newtsh_convt
append using tmp/gt_tbl10fe_1980_newmaster_tsh
gen matchyear = year
sort geoid matchyear
merge geoid matchyear using tmp/geo-final, nok
	tab _m
	drop _m
ren geo_statefip state	
replace geo_ih_sf = -geo_ih_sf
qui xi i.year*i.region i.geoid

	local main "geo_col geo_hs geo_ih_sf geo_lndens"
	local all "_Iyear_* _Igeoid_*"

reg gt_fe1 `main' `all' [aw=gt_wt1], vce(cluster geoid)
reg gt_fe2 `main' `all' [aw=gt_wt2], vce(cluster geoid)
reg gt_fe3 `main' `all' [aw=gt_wt3], vce(cluster geoid)



log close

