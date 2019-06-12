/*This files does the following:
1. Cleans downloaded covariates from Eurostat
2. Assembles all covariates into single database
3. Takes the aggregated data on stocks and assembles it with taxes and covariates.
4. Generates necessary data for aggregate analysis.
5. Prepares data for analysis.
*/

set more off

*Prepare covariates from raw data
cd ".\controls\demo_r_fagec.tsv\"
include clean.do
cd "..\demo_r_magec.tsv\"
include clean.do
cd "..\demo_r_pjangroup.tsv\"
include clean.do
cd "..\demo_r_pjanind2.tsv\"
include clean.do
cd "..\edat_lfse_04.tsv\"
include clean.do
cd "..\ilc_mddd21.tsv\"
include clean.do
cd "..\lfst_r_lfe2ecomm.tsv\"
include clean.do
cd "..\lfst_r_lfu2ltu.tsv\"
include clean.do
cd "..\lfst_r_lfu3pers.tsv\"
include clean.do
cd "..\nama_10r_2gdp.tsv\"
include clean.do
cd "..\nama_10r_2hhsec.tsv\"
include clean.do
cd "..\nrg_chddr2_a.tsv\"
include clean.do
cd "..\rd_e_gerdreg.tsv\"
include clean.do
cd "..\tour_occ_nin2.tsv\"
include clean.do
cd "..\tran_r_net.tsv\"
include clean.do


*Assemble on master covariate database
use ..\demo_r_pjangroup.tsv\highschool.dta, clear
merge 1:1 year code_ccaa using  ..\demo_r_pjangroup.tsv\male.dta
drop _merge
merge 1:1 year code_ccaa using  ..\demo_r_pjangroup.tsv\senior.dta
drop _merge
merge 1:1 year code_ccaa using  ..\demo_r_pjangroup.tsv\total.dta
drop _merge
merge 1:1 year code_ccaa using ..\edat_lfse_04.tsv\edu.dta
drop _merge
merge 1:1 year code_ccaa using  ..\demo_r_pjanind2.tsv\medianage.dta
drop _merge
merge 1:1 year code_ccaa using ..\ilc_mddd21.tsv\materialdep.dta
drop _merge
merge 1:1 year code_ccaa using ..\rd_e_gerdreg.tsv\RDspend.dta
drop _merge
merge 1:1 year code_ccaa using ..\lfst_r_lfe2ecomm.tsv\interstate.dta
drop _merge
merge 1:1 year code_ccaa using ..\lfst_r_lfe2ecomm.tsv\instate.dta
drop _merge
merge 1:1 year code_ccaa using ..\lfst_r_lfu2ltu.tsv\ltunemployment.dta
drop _merge
merge 1:1 year code_ccaa using ..\nama_10r_2gdp.tsv\gdpperc.dta
drop _merge
merge 1:1 year code_ccaa using ..\lfst_r_lfu3pers.tsv\unempl.dta
drop _merge
merge 1:1 year code_ccaa using ..\tour_occ_nin2.tsv\tourism.dta
drop _merge
merge 1:1 year code_ccaa using ..\tran_r_net.tsv\transport.dta
drop _merge
merge 1:1 year code_ccaa using ..\nama_10r_2hhsec.tsv\socialcont.dta
drop _merge
merge 1:1 year code_ccaa using ..\nrg_chddr2_a.tsv\CDD.dta
drop _merge
merge 1:1 year code_ccaa using ..\nrg_chddr2_a.tsv\HDD.dta
drop _merge
merge 1:1 year code_ccaa using ..\demo_r_fagec.tsv\fertility.dta
drop _merge
merge 1:1 year code_ccaa using ..\demo_r_magec.tsv\mortality.dta
drop _merge
keep if year >=2005
keep if year <=2014



cd "..\demo_r_fagec.tsv\"
shell erase *.dta
cd "..\demo_r_magec.tsv\"
shell erase *.dta
cd "..\demo_r_pjangroup.tsv\"
shell erase *.dta
cd "..\demo_r_pjanind2.tsv\"
shell erase *.dta
cd "..\edat_lfse_04.tsv\"
shell erase *.dta
cd "..\ilc_mddd21.tsv\"
shell erase *.dta
cd "..\lfst_r_lfe2ecomm.tsv\"
shell erase *.dta
cd "..\lfst_r_lfu2ltu.tsv\"
shell erase *.dta
cd "..\lfst_r_lfu3pers.tsv\"
shell erase *.dta
cd "..\nama_10r_2gdp.tsv\"
shell erase *.dta
cd "..\nama_10r_2hhsec.tsv\"
shell erase *.dta
cd "..\nrg_chddr2_a.tsv\"
shell erase *.dta
cd "..\rd_e_gerdreg.tsv\"
shell erase *.dta
cd "..\tour_occ_nin2.tsv\"
shell erase *.dta
cd "..\tran_r_net.tsv\"
shell erase *.dta


cd "..\..\"
save junk\covariates_ccaa.dta, replace

use junk\covariates_ccaa.dta, clear
gen origin_ccaa = code_ccaa
drop code_ccaa
foreach var of varlist highschool - mortality {
rename `var' origin_`var'
}
save junk\covariates_origin.dta, replace


use junk\covariates_ccaa.dta, clear
gen destination_ccaa = code_ccaa
drop code_ccaa
foreach var of varlist highschool - mortality {
rename `var' dest_`var'
}
save junk\covariates_destination.dta, replace




*Now, we generate all the necessary data for the agg analysis and assemble a final dataet


*Generate government spending controls from raw data on this.
use controls\G.dta, clear
gen code_ccaa = . 
replace code_ccaa = 1 if State == "Andalucia"
replace code_ccaa = 2 if State == "Aragon"
replace code_ccaa = 3 if State == "Asturias"
replace code_ccaa = 4 if State == "Illes Balears"
replace code_ccaa = 5 if State == "Canarias"  
replace code_ccaa = 6 if State == "Cantabria"
replace code_ccaa = 7 if State == "Castilla-Leon"
replace code_ccaa = 8 if State == "Castilla-Mancha"
replace code_ccaa = 9 if State == "Cataluna"
replace code_ccaa = 10 if State == "C, Valenciana"
replace code_ccaa = 11 if State == "Extremadura"
replace code_ccaa = 12 if State == "Galacia"
replace code_ccaa = 13 if State == "Madrid"
replace code_ccaa = 14 if State == "Murcia"
replace code_ccaa = 17 if State == "Rioja"
*Keep major categories.
keep State Year code_ccaa Total_Gastos A1_Servicios_Publicos_Basicos_ A2_Actuaciones_de_Proteccion_y_P A3_Produccion_de_Bienes_Publicos A4_Actuaciones_de_Caracter_Econo A9_Actuaciones_de_Caracter_Gener
rename Year year
rename code_ccaa destination_ccaa
rename A1_Servicios_Publicos_Basicos_ dA1_Servicios_Publicos_
rename A2_Actuaciones_de_Proteccion_y_P dA2_Actuaciones_de_
rename A3_Produccion_de_Bienes_Publicos dA3_Produccion_de_Bienes_
rename A4_Actuaciones_de_Caracter_Econo dA4_Actuaciones_de_Caracter_
rename A9_Actuaciones_de_Caracter_Gener dA9_Actuaciones_de_Caracter_
rename Total_Gastos dTotal_Gastos
save junk\GovntSpending_destination.dta, replace
rename destination_ccaa origin_ccaa
rename dA1_Servicios_Publicos_ oA1_Servicios_Publicos_
rename dA2_Actuaciones_de_ oA2_Actuaciones_de_
rename dA3_Produccion_de_Bienes_ oA3_Produccion_de_Bienes_
rename dA4_Actuaciones_de_Caracter_ oA4_Actuaciones_de_Caracter_
rename dA9_Actuaciones_de_Caracter_ oA9_Actuaciones_de_Caracter_
rename dTotal_Gastos oTotal_Gastos
save junk\GovntSpending_origin.dta, replace


use data_agg_atr.dta, clear
drop if year == .

keep id year atr_state1 - atr_state99
gen group = .
replace group = 300 if id == 9999999300
drop if group ==. 
drop id
reshape long atr_state, i( year group ) j(code_ccaa)
reshape wide atr_state, i( year code_ccaa) j( group )
rename code_ccaa destination_ccaa

rename atr_state300 dest_atr_state300

save "junk\ATR_destination.dta", replace
rename destination_ccaa origin_ccaa
rename dest_atr_state300 origin_atr_state300
save "junk\ATR_origin.dta", replace



*Create a set of variables to merge at origin and destination
use data_agg_pc.dta, clear

*gen the total of people moving into the the top 1% of the income distribution.
egen from_total = rowtotal( from_perc_*)
replace from_total = from_total- from_perc_100

*gen the total of people moving OUT of the top 1% of the income distribution.  
by code_ccaa year, sort: egen out_total = total( from_perc_100)
replace out_total = out_total - from_perc_100 if percentile ==100

sort code_ccaa year
keep if percentile ==100

*generate the net inflow into top 1% (to subtract from stock number we have)
gen net_churn =  from_total - out_total
rename from_total in_total

keep net_churn out_total in_total out_total net_churn year code_ccaa percentile

save "junk\churn.dta", replace



use data_agg.dta , clear
merge 1:1 percentile code_ccaa year using "junk\churn.dta"
drop if _merge ==2
drop _merge
gen obs_netofchurn = obs_ccaa_inpc - net_churn
drop net_churn


*reshape data so each oigin-destination-year is a row
reshape long mtr_state , i(year code_ccaa percentile) j(origin_ccaa)



rename code_ccaa destination_ccaa
rename mtr_state origin_mtr
rename mtr_own destination_mtr
rename obs_ccaa destination_obs
rename obs_ccaa_inpc destination_obs_inpc


label var year "2005-2014"
label var destination_ccaa "destination (to) state code"
label var origin_ccaa "origin (from) state code"
label var origin_mtr "origin (from) tax rate"
label var destination_mtr "destination (to) tax rate"
label var destination_obs "destination (to) total observations"
label var destination_obs_inpc "destination (to) total observations in subsample"
label var income "destination income"
rename income destination_income

gen junk = destination_obs_inpc if destination_ccaa== origin_ccaa
by year origin_ccaa percentile, sort: egen origin_obs_inpc  = median(junk)
drop junk
label var origin_obs_inpc "origin (from) total observations in subsample"

gen junk = destination_obs if destination_ccaa== origin_ccaa
by year origin_ccaa percentile, sort: egen origin_obs  = median(junk)
drop junk
label var origin_obs "origin (from) total observations"


gen junk = destination_income if destination_ccaa== origin_ccaa
by year origin_ccaa percentile, sort: egen origin_income  = median(junk)
drop junk
label var origin_income "origin (from) income"


*Construct variables
*Taxes are net of tax rates
gen mtr_dt = log(1-destination_mtr/100)
gen mtr_ot = log(1-origin_mtr/100)
gen mtr_dif = mtr_dt-mtr_ot
gen mtr_dif_pp = (1-destination_mtr)-(1-origin_mtr)
gen stockratio = log( destination_obs_inpc/ origin_obs_inpc)
gen income = log(destination_income/origin_income)


by year destination_ccaa, sort: egen destination_pop95 = total(destination_obs_inpc) if percentile <100 & percentile>95 & destination_ccaa==origin_ccaa
by year destination_ccaa, sort: ereplace destination_pop95 = min(destination_pop95)
by year origin_ccaa, sort:egen origin_pop95 = total(origin_obs_inpc) if percentile <100 & percentile>95 & destination_ccaa==origin_ccaa
by year origin_ccaa, sort: ereplace origin_pop95 = min(origin_pop95)
gen pop95 = log((destination_pop95)/(origin_pop95))
by origin_ccaa destination_ccaa year, sort: egen wpop95 = min(pop95)


by year destination_ccaa, sort: egen destination_pop5 = total(destination_obs_inpc) if percentile <=94 & percentile >=90 & destination_ccaa==origin_ccaa
by year destination_ccaa, sort: ereplace destination_pop5 = min(destination_pop5)
by year origin_ccaa, sort:egen origin_pop5 = total(origin_obs_inpc) if percentile <=94 & percentile >=90 & destination_ccaa==origin_ccaa
by year origin_ccaa, sort: ereplace origin_pop5 = min(origin_pop5)
gen pop5 = log((destination_pop5)/(origin_pop5))  
by origin_ccaa year, sort: egen worigin_pop5 = min(origin_pop5)
by destination_ccaa year, sort: egen wdestination_pop5 = min(destination_pop5)
by origin_ccaa destination_ccaa year, sort: egen wpop5 = min(pop5)


*Gnerate state pair and origin year / destination by year
gen statepair = origin_ccaa*100+ destination_ccaa if destination_ccaa<=origin_ccaa
replace statepair = destination_ccaa*100+origin_ccaa if destination_ccaa>origin_ccaa
gen origin_year = year*100+origin_ccaa
gen destination_year = year*100+destination_ccaa

*Prepare sample for analysis
drop if origin_ccaa == 99
drop if destination_ccaa == 15
drop if destination_ccaa == 16
drop if origin_ccaa==15
drop if origin_ccaa==16

rename obs_netofchurn dest_obs_netofchurn
gen junk = dest_obs_netofchurn if destination_ccaa== origin_ccaa
by year origin_ccaa percentile, sort: egen origin_obs_netofchurn  = median(junk)
drop junk

gen ratio_obs_netofchurn = log(dest_obs_netofchurn /origin_obs_netofchurn)
label var ratio_obs_netofchurn "stock after accounting people that move percentiles"

merge m:1 destination_ccaa year using  "junk\covariates_destination.dta"
drop _merge
merge m:1 origin_ccaa year using "junk\covariates_origin.dta"
drop _merge
merge m:1 destination_ccaa year using "junk\ATR_destination.dta"
drop if _merge ==2
drop _merge
merge m:1 origin_ccaa year using "junk\ATR_origin.dta"
drop if _merge ==2
drop _merge
merge m:1 destination_ccaa year using  "junk\GovntSpending_destination.dta"
drop if _merge ==2
drop _merge
merge m:1 origin_ccaa year using  "junk\GovntSpending_origin.dta"
drop if _merge ==2
drop _merge

*calculate spending per capita
local name oA1_Servicios_Publicos_ oA2_Actuaciones_de_ oA3_Produccion_de_Bienes_ oA4_Actuaciones_de_Caracter_ oA9_Actuaciones_de_Caracter_ oTotal_Gastos
foreach var of local name {
gen `var'pc = `var'*1000/origin_population
}
local name dA1_Servicios_Publicos_ dA2_Actuaciones_de_ dA3_Produccion_de_Bienes_ dA4_Actuaciones_de_Caracter_ dA9_Actuaciones_de_Caracter_ dTotal_Gastos
foreach var of local name {
gen `var'pc = `var'*1000/dest_population
}
gen Gratio_A1 = log( dA1_Servicios_Publicos_pc/oA1_Servicios_Publicos_pc)
gen Gratio_A2 = log( dA2_Actuaciones_de_pc/oA2_Actuaciones_de_pc)
gen Gratio_A3 = log(dA3_Produccion_de_Bienes_pc/oA3_Produccion_de_Bienes_pc)
gen Gratio_A4 = log(dA4_Actuaciones_de_Caracter_pc/oA4_Actuaciones_de_Caracter_pc )
gen Gratio_A9 = log(dA9_Actuaciones_de_Caracter_pc/oA9_Actuaciones_de_Caracter_pc )
gen Gratio_Total = log( dTotal_Gastospc /oTotal_Gastospc )

*Calculate average tax rate differentials
gen atr_dt300 = log(1- dest_atr_state300/100)
gen atr_ot300 = log(1- origin_atr_state300/100)
gen atr_dif300 = atr_dt300-atr_ot300


local name highschool male senior population tertiaryedu medianage materialdep RDspend interstate instate ltunemployment gdpperc unempl tourism transport socialcont HDD CDD fertility mortality 
foreach var of local name {
gen controlratio_`var' = log(dest_`var'/origin_`var')
}

gen post = 0 if year<2011
replace post = 1 if year>=2011
gen mtr_difPOST = mtr_dif*post
gen atr_dif300POST = atr_dif300*post


gen id = origin_ccaa*100+destination_ccaa



save data_agg_all.dta, replace 

