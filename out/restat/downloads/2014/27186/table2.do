
/*-----------------------------------------------------------------------------*
			    RUN REGRESSIONS OF TABLE 2
*------------------------------------------------------------------------------*/

/* This do-file runs the regressions of Table 2.
*/

cd  "~/work/bergrato_export/data"

** STEP 1: restrict the focus to Italian exports outside the EU
**-------------------------------------------------------------
use coe2003fcp_exp.dta, clear
gen eu15=1 if country==1 | country==2 | country==3 | country==4 | country==6 | country==7 | country==8 | country==9 | country==10 | country==11 | country==17 | country==18 | country==30 | country==32 | country==38 
keep if eu15!=1
keep if manuf==1 | whol==1
save coe2003fcp_exp_extraEU.dta, replace



** STEP 2: generate product-country total exports by exporter type
**------------------------------------------------------------------------
use coe2003fcp_exp_extraEU.dta, replace
egen totbypc_W= sum(export) if whol==1, by(country sh6)
collapse totbypc_W,  by(country sh6)
replace totbypc_W=0 if totbypc_W==.
gen whol=1
rename totbypc_W export_cp
save aggexport_countryproductW2003_extra.dta, replace

use coe2003fcp_exp_extraEU.dta, replace
egen totbypc_M= sum(export) if manuf==1, by(country sh6)
collapse totbypc_M,  by(country sh6)
replace totbypc_M=0 if totbypc_M==.
gen whol=0
rename totbypc_M export_cp
append using aggexport_countryproductW2003_extra.dta
gen hs6= sh6
tostring hs6, replace
gen hs4= substr(hs6,1,4)


** STEP 3: add country and product charateristics
**------------------------------------------------------------------------
sort country 
merge country using GDP.dta
tab _merge
drop  if _merge==2

drop _merge
sort country 
merge country using DIST.dta
tab _merge
drop  if _merge==2

drop _merge
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
sort country hs6
merge country hs6 using TARIFF.dta
tab _merge
drop  if _merge==2

drop _merge
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
sort sh6
merge sh6 using DISP.dta
tab _merge
drop  if _merge==2

drop xrat-smctry distcap-distwces rgdp-costexportM code-controlcorrn
gen ln_gdp=ln(gdp)
gen ln_dist=ln(dist)
gen tariff2=tariff/100
rename disp_vmu dispvmu2
gen ln_export=ln(export_cp)
gen W_dist=whol*ln_dist
gen W_gdp=whol*ln_gdp
gen W_tariff=whol*tariff2
gen W_contr2=whol*contrac2
gen W_disp=whol*dispvmu2
gen W_minA=whol*minA
gen W_factor1ST=whol*factor1ST_extraEU
gen W_WBDB=whol*WBDB_extraEU

count if export_cp==0 & whol==1
count if export_cp==0 & whol==0
drop if export_cp==0

sort country sh6
by country sh6: gen temp=_n
egen pippo=max(temp) , by(country sh6)
drop if pippo==1
drop temp pippo

** STEP 4: Run the regressions
**-----------------------------------------------------------------
gen obs1=1 if ln_export!=. & minA!=. & W_minA!=. & dispvmu2!=. & W_disp!=. & W_contr2!=. & contrac2!=. & factor1ST_extraEU!=. & W_factor1ST!=. & WBDB_extraEU!=. &  W_WBDB!=.  & ln_dist!=. & W_dist!=. & ln_gdp!=. & W_gdp!=. & tariff2!=. & W_tariff !=.

cluster2 ln_export whol ln_gdp  W_gdp ln_dist W_dist  WBDB_extraEU  W_WBDB  factor1ST_extraEU  W_factor1ST tariff2 W_tariff minA W_minA dispvmu2 W_disp contrac2 W_contr2 if obs==1, fcluster(country)  tcluster(hs6)
areg ln_export whol ln_gdp  W_gdp ln_dist W_dist  WBDB_extraEU  W_WBDB factor1ST_extraEU  W_factor1ST  if obs==1, absorb(sh6) cluster(country)
areg ln_export whol minA W_minA dispvmu2 W_disp contrac2 W_contr2 if obs==1, a(country) cluster(hs6)


**CLEANING DATA
erase coe2003fcp_exp_extraEU.dta
erase aggexport_countryproductW2003_extra.dta
