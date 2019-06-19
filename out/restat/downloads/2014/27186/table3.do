
/*-----------------------------------------------------------------------------*
			    RUN REGRESSIONS OF TABLE 3
*------------------------------------------------------------------------------*/

/* This do-file runs the regressions of Table 3.
*/

cd  "~/work/bergrato_export/data"

** REGRESSIONS AT PRODUCT-COUNTRY LEVEL


** STEP 1: generate aggregate export by country and product using micro-data
**--------------------------------------------------------------------------
local t=2000
while `t'<2008{
	use coe`t'fcp_exp.dta, clear
	keep if export!=.
	keep if manuf==1 | whol==1
	drop if country == 1 | country == 2 | country == 3 | country == 4 | country == 5 | country == 6 | country == 7 | country == 8 | country == 9 | country == 10 | country == 11 | country == 17 | country == 18 | country == 30 | country == 32 | country == 38
	egen export_cp=sum(export), by(country sh6 whol)
	keep export_cp country whol sh6
	collapse export_cp, by(country sh6 whol)
	gen year=`t'
	if `t'==2000 {
   save export_cp.dta, replace
		}
	else {
		append using export_cp.dta
		save export_cp.dta, replace
		}
	local t=`t'+1
	}


** STEP 2: generate the dummy for product-country with whol share greater then median/mean
**--------------------------------------------------------------------------
use export_cp.dta, clear
egen export_tot=sum(export_cp), by(country sh6 year)
gen temp=export_cp/export_tot
egen share_export=mean(temp), by (whol sh6 country)
drop temp
keep if whol==1
collapse share_export, by(country sh6)
egen median=median(share_export) 
egen mean=mean(share_export) 
sum share_export, d
gen Dmed=1 if share_export>=median
replace Dmed=0 if share_export<median
gen Dmean=1 if share_export>=mean
replace Dmean=0 if share_export<mean
keep country sh6 Dmed Dmean  
sort country sh6
save export_pc_temp.dta, replace

** STEP 3: generate product-country dataset for all (W+M) and link with the dummy Dmed/Dmean
**--------------------------------------------------------------------------
use export_cp.dta, clear
egen export_tot=sum(export_cp), by (country sh6 year)
collapse export_tot, by (country sh6 year)
sort country sh6
merge m:1 country sh6 using export_pc_temp.dta
erase export_pc_temp.dta
keep if _merge==3
drop _merge
egen pc=group(country sh6)
sort pc year
tsset pc year
gen ln_export=ln(export_tot)
gen delta_exp=D.ln_export
keep if delta_exp!=.
sort country year
merge country year using RER_CPI.dta
tab _merge
keep if _merge==3
drop _merge

tab year, gen(y)
gen Dmed_RER=Dmed*delta_rer
gen Dmean_RER=Dmean*delta_rer

sort country 
merge country using WBDB.dta
tab _merge
drop  if _merge==2
drop _merge

sort country 
merge country using WGI.dta
tab _merge
drop  if _merge==2
drop _merge

gen fix_rer=delta_rer*WBDB_extraEU
gen wgi_rer=delta_rer*factor1ST_extraEU 

sort sh6
merge sh6 using CONTRACT.dta
tab _merge
drop  if _merge==2

drop _merge
sort sh6
merge sh6 using ENTRYEXIT.dta
tab _merge
drop  if _merge==2
drop _merge

gen entry_rer=delta_rer*minA
gen contr_rer=delta_rer*contrac2

** STEP 4: run the regressions
**--------------------------------------------------------------------------
eststo clear
eststo: areg delta_exp  delta_rer Dmed_RER  fix_rer wgi_rer  entry_rer contr_rer y1-y7, a(pc) cluster(pc)
eststo: areg delta_exp  delta_rer Dmean_RER  fix_rer wgi_rer  entry_rer contr_rer y1-y7, a(pc) cluster(pc)
esttab using rer_pc.tex, keep(delta_rer Dmed_RER Dmean_RER  fix_rer wgi_rer disp_rer entry_rer contr_rer) nodepvars se(3) b(3) ar2 replace star(* 0.10 ** 0.05 *** 0.01) 


** REGRESSIONS AT COUNTRY LEVEL

** STEP 1: generate aggregate export by country using micro-data
**--------------------------------------------------------------------------

local t=2000
while `t'<2008{
	use coe`t'fcp_exp.dta, clear
	keep if export!=.
	keep if manuf==1 | whol==1
	drop if country == 1 | country == 2 | country == 3 | country == 4 | country == 5 | country == 6 | country == 7 | country == 8 | country == 9 | country == 10 | country == 11 | country == 17 | country == 18 | country == 30 | country == 32 | country == 38
	egen export_c=sum(export), by(country whol)
	keep export_c country whol 
	collapse export_c, by(country whol)
	gen year=`t'
	if `t'==2000 {
   save export_c.dta, replace
		}
	else {
		append using export_c.dta
		save export_c.dta, replace
		}
	local t=`t'+1
	}


** STEP 2: generate the dummy for country with whol share greater then median/mean
**--------------------------------------------------------------------------

use export_c.dta, clear
egen export_tot=sum(export_c), by(country year)
gen temp=export_c/export_tot
egen share_export=mean(temp), by (whol country)
drop temp
keep if whol==1
collapse share_export, by(country)
egen median=median(share_export) 
egen mean=mean(share_export) 
sum share_export, d
gen Dmed=1 if share_export>=median
replace Dmed=0 if share_export<median
gen Dmean=1 if share_export>=mean
replace Dmean=0 if share_export<mean
keep country Dmed Dmean  
sort country
save export_country_temp.dta, replace


** STEP 3: generate country dataset for all (W+M) and link with the dummy Dmed/Dmean
**--------------------------------------------------------------------------
use export_c.dta, clear
egen export_tot=sum(export_c), by (country year)
collapse export_tot, by (country year)
sort country
merge country using export_country_temp.dta
erase export_country_temp.dta
tab _merge
keep if _merge==3
drop _merge
sort country
tsset country year
gen ln_export=ln(export_tot)
gen delta_exp=D.ln_export
keep if delta_exp!=.
sort country year
merge country year using RER_CPI.dta
tab _merge
keep if _merge==3
drop _merge
tab year, gen(y)
gen Dmed_RER=Dmed*delta_rer
gen Dmean_RER=Dmean*delta_rer

sort country 
merge country using WBDB.dta
tab _merge
drop  if _merge==2
drop _merge

sort country 
merge country using WGI.dta
tab _merge
drop  if _merge==2
drop _merge
	
gen fix_rer=delta_rer*WBDB_extraEU
gen wgi_rer=delta_rer*factor1ST_extraEU 


** STEP 4: run the regressions
**----------------------------
eststo clear
eststo:areg delta_exp    delta_rer  Dmed_RER fix_rer  wgi_rer y1-y7,  a(country)  cluster(country)
eststo:areg delta_exp    delta_rer  Dmean_RER fix_rer  wgi_rer y1-y7,  a(country)  cluster(country)
esttab using reg_c.tex, keep(Dmed Dmean delta_rer Dmed_RER Dmean_RER WBDB_extraEU fix_rer factor1ST_extraEU wgi_rer) nodepvars se(3) b(3) ar2 replace star(* 0.10 ** 0.05 *** 0.01) 

