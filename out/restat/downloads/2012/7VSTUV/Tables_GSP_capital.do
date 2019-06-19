


clear
clear matrix
set mem 100m
set matsize 110
cd Z:\Giovanni\MyPapers\Peri_Accounting\second_Revision_spring_10\empirics

/* data with employment hours, immigrants and imputed immigrants */

insheet using "Z:\Giovanni\MyPapers\Peri_Accounting\second_Revision_spring_10\revision_gsp_capital_data\cap_gsp_60_08.csv"
drop if fips==0
gen statefip=fips
drop state fips
keep if year== 1960 | year==1970 |year==1980 | year==1990 | year==2000 |year==2006
sort year statefip
merge 1:1 year statefip using "Z:\Giovanni\MyPapers\Peri_Accounting\second_Revision_spring_10\empirics\empl_wages_iv_state_60_06.dta"
drop _merge
sort statefip year


** generate labor supply, (hours and employment) and wages for more and less educated

gen empl=empl_us_H+empl_for_H+empl_us_L+empl_for_L
gen hours=howo_for_L+howo_for_H+howo_us_L+howo_us_H
gen hours_perworker=hours/empl

gen hours_perworker_us=(howo_us_L+howo_us_H)/(empl_us_H+empl_us_L)
gen empl_for=empl_for_H+empl_for_L
gen empl_us=empl_us_H+empl_us_L

gen hourly_H=(hourly_us_H*howo_us_H+hourly_for_H*howo_for_H)/(howo_us_H+howo_for_H)
gen hourly_L=(hourly_us_L*howo_us_L+hourly_for_L*howo_for_L)/(howo_us_L+howo_for_L)


** generate share of hours worked by high skilled
gen h=(howo_for_H+howo_us_H)/hours
gen h_us=(howo_us_H)/(howo_us_L+howo_us_H)

** generate percentage increase in total employment, and hours per person and share of high skilled
sort statefip year

gen d_hours_perworker=(hours_perworker-hours_perworker[_n-1])/hours_perworker[_n-1] if year>1960
gen d_empl=(empl-empl[_n-1])/empl[_n-1] if year>1960
gen d_h=(h-h[_n-1])/h[_n-1] if year>1960

gen d_empl_lag=d_empl[_n-1] if year>1970

**explanatory variable
gen d_immi_empl=(empl_for-empl_for[_n-1])/empl[_n-1] if year>1960
gen d_immi_pop=(foreign_pop-foreign_pop[_n-1])/(foreign_pop[_n-1]+us_pop[_n-1]) if year>1960
gen d_immi_imputed=(foreign_imputed-foreign_imputed[_n-1])/(foreign_imputed[_n-1]+us_pop[_n-1]) if year>1960


/* capital and GSP manipulations*/
gen gsp_worker=(gsp*1000000000)/empl
gen gsp_worker_lag=gsp_worker[_n-1]

/* cap per worker a'la garofal-yamarik */
gen kap=(cap*1000000000)
gen kap_worker=(cap*1000000000)/empl
gen k_y_ratio=(kap_worker/gsp_worker)


/***
*** graph of capital-labor (logs) and capital-output
twoway connect ave_lnk2_worker lnk2_worker year if statefip==06
***/

**** growth rates
sort statefip year
gen d_gsp_worker= ln(gsp_worker)-ln(gsp_worker[_n-1]) if year>1960
gen d_kap= ln(kap)-ln(kap[_n-1]) if year>1960
gen d_kap_worker = ln(kap_worker)-ln(kap_worker[_n-1]) if year>1960
gen d_k_y_ratio_corrected= (0.34/0.66)*(ln(k_y_ratio)-ln(k_y_ratio[_n-1])) if year>1960
gen lnk_y_ratio_lag=ln(k_y_ratio[_n-1])

gen lnkap=ln(kap)
gen d_gsp_worker_lag= d_gsp_worker[_n-1] if year>1970
gen d_k_y_ratio_lag=d_k_y_ratio_corrected[_n-1] if year>1970
gen d_kap_lag=d_kap[_n-1] if year >1970
gen d_k_y_ratio= ln(k_y_ratio)-ln(k_y_ratio[_n-1]) if year>1960


gen lngsp_worker=ln(gsp_worker)
gen lngsp_worker_lag=lngsp_worker[_n-1]
gen lnkap_worker=ln(kap_worker)

*** distance IV

gen bord_dist_70=0
replace bord_dist_70=ln(border_distance) if year==1970
gen bord_dist_80=0
replace bord_dist_80=ln(border_distance) if year==1980
gen bord_dist_90=0
replace bord_dist_90=ln(border_distance) if year==1990
gen bord_dist_00=0
replace bord_dist_00=ln(border_distance) if year==2000
gen bord_dist_06=0
replace bord_dist_06=ln(border_distance) if year==2006

gen ny_dist_70=0
replace ny_dist_70=ln(ny_dist) if year==1970
gen ny_dist_80=0
replace ny_dist_80=ln(ny_dist) if year==1980
gen ny_dist_90=0
replace ny_dist_90=ln(ny_dist) if year==1990
gen ny_dist_00=0
replace ny_dist_00=ln(ny_dist) if year==2000
gen ny_dist_06=0
replace ny_dist_06=ln(ny_dist) if year==2006

gen miami_dist_70=0
replace miami_dist_70=ln(miami_dist) if year==1970
gen miami_dist_80=0
replace miami_dist_80=ln(miami_dist) if year==1980
gen miami_dist_90=0
replace miami_dist_90=ln(miami_dist) if year==1990
gen miami_dist_00=0
replace miami_dist_00=ln(miami_dist) if year==2000
gen miami_dist_06=0
replace miami_dist_06=ln(miami_dist) if year==2006


gen la_dist_70=0
replace la_dist_70=ln(la_dist) if year==1970
gen la_dist_80=0
replace la_dist_80=ln(la_dist) if year==1980
gen la_dist_90=0
replace la_dist_90=ln(la_dist) if year==1990
gen la_dist_00=0
replace la_dist_00=ln(la_dist) if year==2000
gen la_dist_06=0
replace la_dist_06=ln(la_dist) if year==2006

***not in any table, this for my peace of mind
*** checks of the correlation with hourly wages

sort year
by year: sum d_gsp_worker d_k_y_ratio 

** Table 1 row 2, GSP per worker and immigrants
xi: reg d_gsp_worker d_immi_empl i.year i.statefip [aw=empl] if year>1960, robust cluster(statefip)
xi: reg d_gsp_worker d_immi_empl i.year i.statefip [aw=empl] if year>1970, robust cluster(statefip)
xi: reg d_gsp_worker d_immi_empl i.year  i.statefip [aw=empl] if year>1960 & year<2006, robust cluster(statefip)
xi: reg d_gsp_worker d_gsp_worker_lag d_immi_empl i.year i.statefip [aw=empl] if year>1970, robust cluster(statefip)
xi: ivreg d_gsp_worker (d_immi_empl=d_immi_pop) i.year i.statefip [aw=empl] if year>1960, robust cluster(statefip)


***Table 1, row 3
xi: reg d_k_y_ratio_corrected d_immi_empl i.year i.statefip [aw=empl] if year>1960, robust cluster(statefip)
xi: reg d_k_y_ratio_corrected d_immi_empl i.year i.statefip [aw=empl] if year>1970, robust cluster(statefip)
xi: reg d_k_y_ratio_corrected d_immi_empl i.year i.statefip [aw=empl] if year>1960 & year<2006, robust cluster(statefip)
xi: reg d_k_y_ratio_corrected d_k_y_ratio_lag d_immi_empl i.year i.statefip [aw=empl] if year>1970, robust cluster(statefip)
xi: ivreg d_k_y_ratio_corrected (d_immi_empl=d_immi_pop) i.year i.statefip [aw=empl] if year>1960, robust cluster(statefip)


/***
*** Effect on capital stock capital stock, larger than one for one (suppressed in the last version).
xi: reg d_kap d_immi_empl i.year lnkap [aw=empl] if year>1960, robust cluster(statefip)
xi: reg d_kap d_immi_empl i.year [aw=empl] if year>1970, robust cluster(statefip)
xi: reg d_kap d_immi_empl i.year [aw=empl] if year<2006, robust cluster(statefip)
xi: reg d_kap d_immi_empl d_kap_lag i.year [aw=empl] if year<2006, robust cluster(statefip)
****/


** 2sls with border and imputed immi as IV
*** Table 2, row 2 GSP per worker
xi: ivreg d_gsp_worker (d_immi_empl= d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year>1960, robust cluster(statefip)
xi: ivreg d_gsp_worker (d_immi_empl= d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year>1970, robust cluster(statefip)
xi: ivreg d_gsp_worker (d_immi_empl=d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year>1960 & year<2006, robust cluster(statefip)
xi: ivreg d_gsp_worker (d_immi_empl=d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) d_gsp_worker_lag i.year i.statefip [aw=empl] if year>1960, robust cluster(statefip)
xi: ivreg d_gsp_worker (d_immi_empl= bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year>1960, robust cluster(statefip)


**Table 2, row 3
xi: ivreg d_k_y_ratio_corrected (d_immi_empl= d_immi_imputed ny_dist_70 ny_dist_80 ny_dist_90 ny_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year>1960, robust cluster(statefip)
xi: ivreg d_k_y_ratio_corrected (d_immi_empl= d_immi_imputed ny_dist_70 ny_dist_80 ny_dist_90 ny_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year>1970, robust cluster(statefip)
xi: ivreg d_k_y_ratio_corrected (d_immi_empl= d_immi_imputed ny_dist_70 ny_dist_80 ny_dist_90 ny_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year>1960 & year<2006, robust cluster(statefip)
xi: ivreg d_k_y_ratio_corrected (d_immi_empl= d_immi_imputed ny_dist_70 ny_dist_80 ny_dist_90 ny_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) d_k_y_ratio_lag i.year i.statefip if year>1970 [aw=empl] , robust cluster(statefip)
xi: ivreg d_k_y_ratio_corrected (d_immi_empl= bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year>1960, robust cluster(statefip)


*** figures
sort statefip year

egen lngsp_worker_ave=mean(lngsp_worker), by (year)
egen lnkap_worker_ave=mean(lnkap_worker), by (year)




*** figures on gdp and capital
twoway connect lngsp_worker lngsp_worker_ave year , mlabel(state_code)
twoway connect lnkap_worker lnkap_worker_ave year if statefip~=10, mlabel(state_code)








