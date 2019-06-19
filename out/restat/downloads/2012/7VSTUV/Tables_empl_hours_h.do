


clear
clear matrix
set mem 100m
set matsize 110
cd H:\Giovanni\MyPapers\Peri_Accounting\second_Revision_spring_10\empirics

/* data with employment hours, immigrants and imputed immigrants */

insheet using "H:\Giovanni\MyPapers\Peri_Accounting\second_Revision_spring_10\revision_gsp_capital_data\cap_gsp_60_08.csv"
drop if fips==0
gen statefip=fips
drop state fips
keep if year== 1960 | year==1970 |year==1980 | year==1990 | year==2000 |year==2006
sort year statefip
merge 1:1 year statefip using "H:\Giovanni\MyPapers\Peri_Accounting\second_Revision_spring_10\empirics\empl_wages_iv_state_60_06.dta"
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

gen d_hours_perworker=ln(hours_perworker)-ln(hours_perworker[_n-1]) if year>1960
gen d_empl=(empl-empl[_n-1])/empl[_n-1] if year>1960
gen d_h=ln(h)-ln(h[_n-1]) if year>1960
gen lnempl=ln(empl)

gen d_empl_lag=d_empl[_n-1] if year>1970
gen d_hours_perworker_lag=d_hours_perworker[_n-1] if year>1970
gen d_h_lag=d_h[_n-1] if year>1970

**explanatory variable
gen d_immi_empl=(empl_for-empl_for[_n-1])/empl[_n-1] if year>1960
gen d_immi_pop=(foreign_pop-foreign_pop[_n-1])/(foreign_pop[_n-1]+us_pop[_n-1]) if year>1960
gen d_immi_imputed=(foreign_imputed-foreign_imputed[_n-1])/(foreign_imputed[_n-1]+us_pop[_n-1]) if year>1960


*** variables for the US workers
gen d_us_empl=(empl_us-empl_us[_n-1])/empl[_n-1] if year>1960
gen d_hours_perworker_us=(hours_perworker_us-hours_perworker_us[_n-1])/hours_perworker_us[_n-1] if year>1960
gen d_h_us=(h_us-h_us[_n-1])/h[_n-1] if year>1960

gen d_hourly_H=(hourly_H-hourly_H[_n-1])/hourly_H[_n-1] if year>1960
gen d_hourly_L=(hourly_L-hourly_L[_n-1])/hourly_H[_n-1] if year>1960

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



/*** effect of immigration on total employment: establishes that 
imigrants contribute to employment growth and do not crowd out natives **/

sort year
by year: sum d_empl d_hours_perworker d_immi_empl

*** table 1, row 1, OLS effect of immigration on total employment
xi: reg d_empl d_immi_empl i.year i.statefip [aw=empl] if year>1960, robust cluster(statefip)
xi: reg d_empl d_immi_empl i.year i.statefip [aw=empl] if year>1970, robust cluster(statefip)
xi: reg d_empl d_immi_empl i.year i.statefip[aw=empl] if year>1960 & year<2006, robust cluster(statefip)
xi: reg d_empl d_empl_lag d_immi_empl i.year i.statefip [aw=empl] if year>1970, robust cluster(statefip)
xi: ivreg d_empl (d_immi_empl=d_immi_pop) i.year i.statefip [aw=empl] if year>1960, robust cluster(statefip)

*** check that the effect on natives are consistent (i.e. positive and not significantly different from 0)
xi: reg d_us_empl d_immi_empl i.year [aw=empl] if year>1960, robust cluster(statefip)
xi: reg d_us_empl d_immi_empl i.year [aw=empl] if year>1970, robust cluster(statefip)
xi: reg d_us_empl d_immi_empl i.year [aw=empl] if year>1960 & year<2006, robust cluster(statefip)
xi: reg d_us_empl d_empl_lag d_immi_empl i.year [aw=empl] if year>1970, robust cluster(statefip)
xi: ivreg d_us_empl (d_immi_empl=d_immi_pop) i.year [aw=empl] if year>1960, robust cluster(statefip)
**(ok!!)*****

*** table 1 row 5, effects on hours per worker
xi: reg d_hours_perworker d_immi_empl i.year i.statefip [aw=empl] if year>1960, robust cluster(statefip)
xi: reg d_hours_perworker d_immi_empl i.year i.statefip [aw=empl] if year>1970, robust cluster(statefip)
xi: reg d_hours_perworker d_immi_empl i.year i.statefip [aw=empl] if year>1960 & year<2006, robust cluster(statefip)
xi: reg d_hours_perworker d_hours_perworker_lag d_immi_empl i.year i.statefip [aw=empl] if year>1970, robust cluster(statefip)
xi: ivreg d_hours_perworker (d_immi_empl=d_immi_pop) i.year i.statefip [aw=empl] if year>1960, robust cluster(statefip)

** effect on US workers only 
xi: reg d_hours_perworker_us d_immi_empl i.year [aw=empl] if year>1960, robust cluster(statefip)
xi: reg d_hours_perworker_us d_immi_empl i.year [aw=empl] if year>1970, robust cluster(statefip)
xi: reg d_hours_perworker_us d_immi_empl i.year [aw=empl] if year>1960 & year<2006, robust cluster(statefip)
xi: reg d_hours_perworker_us d_empl_lag d_immi_empl i.year [aw=empl] if year>1970, robust cluster(statefip)
xi: ivreg d_hours_perworker_us (d_immi_empl=d_immi_pop) i.year [aw=empl] if year>1960, robust cluster(statefip)



*** Table 1 row 7, effects on share of hours worked by high skilled
xi: reg d_h d_immi_empl i.year i.statefip [aw=empl] if year>1960, robust cluster(statefip)
xi: reg d_h d_immi_empl i.year i.statefip [aw=empl] if year>1970, robust cluster(statefip)
xi: reg d_h d_immi_empl i.year i.statefip [aw=empl] if year>1960 & year<2006, robust cluster(statefip)
xi: reg d_h d_h_lag d_immi_empl i.year i.statefip [aw=empl] if year>1970, robust cluster(statefip)
xi: ivreg d_h (d_immi_empl=d_immi_pop) i.year i.statefip [aw=empl] if year>1960, robust cluster(statefip)


**effect on US workers only
xi: reg d_h_us d_immi_empl i.year [aw=empl] if year>1960, robust cluster(statefip)
xi: reg d_h_us d_immi_empl i.year [aw=empl] if year>1970, robust cluster(statefip)
xi: reg d_h_us d_immi_empl i.year [aw=empl] if year>1960 & year<2006, robust cluster(statefip)
xi: reg d_h_us d_empl_lag d_immi_empl i.year [aw=empl] if year>1970, robust cluster(statefip)
xi: ivreg d_h_us (d_immi_empl=d_immi_pop) i.year [aw=empl] if year>1960, robust cluster(statefip)



***** 2SLS estimates *****

****
*** test of overid restriction Column 3
xi: ivreg d_empl (d_immi_empl= d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year>1960, robust cluster(statefip)
predict p1, residual
reg p1 d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00

** the r_square times 255 is the t-stat chi-square with 11 degrees of freedom
gen testa=chi2(5,7.65)
sum testa
****/

*** table 2, 2SLS 

xi: ivreg d_empl (d_immi_empl= d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year>1960, robust cluster(statefip)
xi: ivreg d_empl (d_immi_empl= d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year  i.statefip [aw=empl] if year>1970, robust cluster(statefip)
xi: ivreg d_empl (d_immi_empl= d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year  i.statefip [aw=empl] if year>1960 & year<2006, robust cluster(statefip)
xi: ivreg d_empl (d_immi_empl= bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00  la_dist_70 la_dist_80 la_dist_90 la_dist_00) d_empl_lag i.year  i.statefip [aw=empl] if year>1960, robust cluster(statefip)
xi: ivreg d_empl (d_immi_empl= bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year  i.statefip [aw=empl] if year>1960, robust cluster(statefip)

*** table 2, 2SLS row 5

xi: ivreg d_hours_perworker (d_immi_empl= d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00  la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year>1960, robust cluster(statefip)
xi: ivreg d_hours_perworker (d_immi_empl= d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year>1970, robust cluster(statefip)
xi: ivreg d_hours_perworker (d_immi_empl= d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year>1960 & year<2006, robust cluster(statefip)
xi: ivreg d_hours_perworker (d_immi_empl= d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) d_hours_perworker_lag i.year i.statefip [aw=empl] if year>1960, robust cluster(statefip)
xi: ivreg d_hours_perworker (d_immi_empl= bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year>1960, robust cluster(statefip)

*** table 2, row 7
xi: ivreg d_h (d_immi_empl= d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year>1960, robust cluster(statefip)
xi: ivreg d_h (d_immi_empl= d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00  la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year>1970, robust cluster(statefip)
xi: ivreg d_h (d_immi_empl= d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year>1960 & year<2006, robust cluster(statefip)
xi: ivreg d_h (d_immi_empl= d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) d_h_lag i.year i.statefip [aw=empl] if year>1960, robust cluster(statefip)
xi: ivreg d_h (d_immi_empl= bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00  la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year>1960, robust cluster(statefip)


*** figures
sort statefip year
egen h_ave=mean(h), by (year)


*** figures on gdp and capital
twoway connect h h_ave year if statefip~=10 & statefip~=11, mlabel(state_code)
