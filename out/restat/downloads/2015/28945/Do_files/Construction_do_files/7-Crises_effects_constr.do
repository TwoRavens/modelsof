*-----------------------------------------------------------------------------------------------------------------------------*
* This do file construct dataset used to test the effect of crises on trade in Berman and Couttenier (2014)					  *
* This version: nov. 11, 2013																								  *
*-----------------------------------------------------------------------------------------------------------------------------*
*
cd "$Output_data"
*
************************************
* A - CRISES AND BILATERAL EXPORTS *
************************************
*
/* crisis data */
use "$Data\crises\crises_rr2011", clear
rename iso3 iso_d
sort iso_d year
rename banking_crisis crisis
egen country = group(iso_d)
tsset country year
*
drop country
sort iso_d year
save crises, replace
*
/* Decomposing crisis episodes */
use crises, replace
egen imp=group(iso_d)
sort imp year
tsset imp year
*
g crisis_1  = (l.crisis==0   & crisis==1)
g crisis_2  = (l2.crisis==0  & l.crisis==1   & crisis==1)
g crisis_3  = (l3.crisis==0  & l2.crisis==1  & l1.crisis==1  & crisis==1)
g crisis_4  = (l4.crisis==0  & l3.crisis==1  & l2.crisis==1  & l1.crisis==1 & crisis==1)
g crisis_5  = (l5.crisis==0  & l4.crisis==1  & l3.crisis==1  & l2.crisis==1 & l1.crisis==1 & crisis==1)
g crisis_6  = (l6.crisis==0  & l5.crisis==1  & l4.crisis==1  & l3.crisis==1 & l2.crisis==1 & l1.crisis==1 & crisis==1 )
g crisis_7  = (l7.crisis==0  & l6.crisis==1  & l5.crisis==1  & l4.crisis==1 & l3.crisis==1 & l2.crisis==1 & l1.crisis==1 & crisis==1)
g crisis_8  = (l8.crisis==0  & l7.crisis==1  & l6.crisis==1  & l5.crisis==1 & l4.crisis==1 & l3.crisis==1 & l2.crisis==1 & l1.crisis==1 & crisis==1)
g crisis_9  = (l9.crisis==0  & l8.crisis==1  & l7.crisis==1  & l6.crisis==1 & l5.crisis==1 & l4.crisis==1 & l3.crisis==1 & l2.crisis==1 & l1.crisis==1 & crisis==1)
g crisis_10 = (l10.crisis==0 & l9.crisis==1  & l8.crisis==1  & l7.crisis==1 & l6.crisis==1 & l5.crisis==1 & l4.crisis==1 & l3.crisis==1 & l2.crisis==1 & l1.crisis==1 & crisis==1)
g crisis_11 = (l11.crisis==0 & l10.crisis==1 & l9.crisis==1  & l8.crisis==1 & l7.crisis==1 & l6.crisis==1 & l5.crisis==1 & l4.crisis==1 & l3.crisis==1 & l2.crisis==1 & l1.crisis==1 & crisis==1)
g crisis_12 = (l12.crisis==0 & l11.crisis==1 & l10.crisis==1 & l9.crisis==1 & l8.crisis==1 & l7.crisis==1 & l6.crisis==1 & l5.crisis==1 & l4.crisis==1 & l3.crisis==1 & l2.crisis==1 & l1.crisis==1 & crisis==1)
*
g test=crisis_1+crisis_2+crisis_3+crisis_4+crisis_5+crisis_6+crisis_7+crisis_8+crisis_9+crisis_10+crisis_11+crisis_12
cor test crisis 
drop test imp crisis
sort iso_d year
forvalues x=1(1)12{
label var crisis_`x' "`x' years since crisis started"
}
save temp, replace
*	
/* countries in final sample */
use "$Output_data\base_reg_afr", replace
collapse (max) conflict_c1 conflict_c2 conflict_c3, by(iso3)
rename iso3 iso_o
rename conflict_c1 acled1
rename conflict_c2 acled2
rename conflict_c3 ucdp
sort iso_o
drop if iso_o == "EGY" | iso_o == "MAR" | iso_o == "TUN" | iso_o == "LBY" | iso_o == "DZA"
save countries, replace
*
/* make gdp data bilateral */
use "$Data\WBDI\WBDI_gdp", clear
rename iso3 iso_o
rename gdp  gdp_o
sort iso_o year
save wbdi_o, replace
*
use "$Data\WBDI\WBDI_gdp", clear
rename iso3 iso_d
rename gdp  gdp_d
sort iso_d year
save wbdi_d, replace
*		
/* Start with bilateral trade data */
use "$Data\trade_data\dots\dots1948_2009", clear
replace iso_o = "COD" if iso_o=="ZAR"
replace iso_d = "COD" if iso_d=="ZAR"
*
drop if year<1980 | year>2006		
*
/* merge with banking crisis data */
sort iso_d year
merge iso_d year using crises, nokeep	
tab _merge
drop _merge
*
sort iso_d year
merge iso_d year using temp, nokeep	
tab _merge
drop _merge
*
/* merge with GDP data */
sort iso_o year
merge iso_o year using wbdi_o, nokeep
tab _merge
drop _merge
*
sort iso_d year
merge iso_d year using wbdi_d, nokeep
tab _merge
drop _merge
*
/* get list of countries in sample */
sort iso_o
merge iso_o using countries, nokeep
tab _merge
drop _merge
* 
g lgdp_o = log(gdp_o)
g lgdp_d = log(gdp_d)
g lflow  = log(flow_dots)
*
egen dyad = group(iso_o iso_d)
tab year, gen(yeard)
*
sort dyad year
tsset dyad year
*
label var year      "Year"
label var flow_dots "Bil. exports, DOTS"
label var gdp_o  	"GDP, exporter"
label var gdp_d  	"GDP, importer"
label var lgdp_o 	"ln GDP, exporter"
label var lgdp_d 	"ln GDP, importer"
label var lflow  	"ln bilateral exports"
label var acled1 	"1 if exporter in Acled I sample"
label var acled2 	"1 if exporter in Acled II sample"
label var ucdp   	"1 if exporter in UCDP sample"
*
save trade_crises_ijt, replace
*
************************************
* B - CRISES AND BILATERAL EXPORTS *
************************************
*
import excel "$Data\WBDI\export_vars_wbdi.xls", sheet("Sheet1") firstrow clear
keep if IndicatorName=="Exports of goods and services (current US$)"
reshape long export_, i(CountryCode) j(year)
rename CountryCode iso3
rename export export_wb
sort iso3 year
save WBDI_exp, replace
/* start from country level */	
use WBDI_exp, clear
drop if year<1980 | year>2006	
/* WBDI data */
sort iso3 year
merge iso3 year using "$Data\WBDI\WBDI_gdp", nokeep
tab _merge
drop _merge
/* get crises */
replace iso3 = "COD" if iso3 =="ZAR"
sort iso3 year 
merge iso3 year using "$Output_data\exposure_crisis_all", nokeep
tab _merge
drop _merge
/* get list of countries in sample */
rename iso3 iso_o
sort iso_o
merge iso_o using countries, nokeep
tab _merge
drop _merge
rename iso_o iso3
*
egen country = group(iso3)
tsset country year
tab year, gen(yeard)
*
g lexport_wb       = log(export_wb)
g lgdp_wb          = log(gdp_wb)
*
label var year 		"Year"
label var export_wb "Exports, WBDI"
label var gdp_wb 	"GDP, WBDI"
label var acled1 	"1 if exporter in Acled I sample"
label var acled2 	"1 if exporter in Acled II sample"
label var ucdp   	"1 if exporter in UCDP sample"
label var lexport_wb "ln exports"
label var lgdp_wb "ln GDP"
label var exposure_crisis "Exposure to crises"
*
save trade_crises_it, replace
*
***********************************
* C - AVERAGE DURACTION OF CRISES *
***********************************
*
/* crisis data */
use "$Output_data/crises_stats", clear
drop if year<1980 | year > 2006
egen nb_crises = sum(start_crisis)
egen nb_years  = sum(banking_crisis)
g av_year = nb_years / nb_crises
sum av_year
*
erase countries.dta
erase wbdi_d.dta
erase wbdi_o.dta
erase crises.dta
erase WBDI_exp.dta
erase temp.dta
*
