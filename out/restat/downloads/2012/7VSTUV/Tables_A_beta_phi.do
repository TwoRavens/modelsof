

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

gen empl_for=empl_for_H+empl_for_L

gen w_H=(hourly_us_H*howo_us_H+hourly_for_H*howo_for_H)/(howo_us_H+howo_for_H)
gen w_L=(hourly_us_L*howo_us_L+hourly_for_L*howo_for_L)/(howo_us_L+howo_for_L)


** generate share of hours worked by high skilled
gen h=(howo_for_H+howo_us_H)/hours

** generate percentage increase in total employment, and hours per person and share of high skilled
sort statefip year


**explanatory variable
gen d_immi_empl=(empl_for-empl_for[_n-1])/empl[_n-1] if year>1960
gen d_immi_pop=(foreign_pop-foreign_pop[_n-1])/(foreign_pop[_n-1]+us_pop[_n-1]) if year>1960
gen d_immi_imputed=(foreign_imputed-foreign_imputed[_n-1])/(foreign_imputed[_n-1]+us_pop[_n-1]) if year>1960


/* capital and GSP manipulations*/
gen gsp_perworker=(gsp*1000000000)/empl

/* cap per worker a'la garofal-yamarik */
gen kap_worker=(cap*1000000000)/empl


/** construct the betas from the formula in the text****/
gen alpha=0.33
gen sigma=1.75

gen beta=( (w_H)^(sigma/(sigma-1)) * h^(1/(sigma-1)) )/( (w_H)^(sigma/(sigma-1)) * h^(1/(sigma-1)) + (w_L)^(sigma/(sigma-1)) * (1-h)^(1/(sigma-1)) )
gen phi=( (beta*h)^((sigma-1)/sigma) + ((1-beta)*(1-h))^((sigma-1)/sigma) )^(sigma/(sigma-1))
gen A=(gsp_perworker^(1/(1-alpha)))*(kap_worker^(-alpha/(1-alpha)))*(hours_perworker^(-1))*(phi^(-1))

sort statefip year
*** percentage changes:

gen d_beta=ln(beta)-ln(beta[_n-1]) if year>1960
gen d_phi=ln(phi)-ln(phi[_n-1]) if year>1960
gen d_A=ln(A)-ln(A[_n-1]) if year>1960
gen lnA=ln(A[_n-1])
gen lnA_lag=lnA[_n-1]

gen lnbeta=ln(beta[_n-1])

gen d_A_lag=d_A[_n-1] if year>1970
gen d_beta_lag=d_beta[_n-1] if year>1970
gen d_phi_lag=d_phi[_n-1] if year>1970
gen d_gsp_worker= ln(gsp_perworker)-ln(gsp_perworker[_n-1]) if year>1960
gen d_h=(h-h[_n-1])/h

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

sort year
by year: sum d_A d_beta d_phi d_h d_immi_empl

*** OLS ***
** Table 1 row 4, effect on A
xi: reg d_A d_immi_empl i.year i.statefip  [aw=empl] if year>1960, robust cluster(statefip)
xi: reg d_A d_immi_empl i.year i.statefip [aw=empl] if year>1970, robust cluster(statefip)
xi: reg d_A d_immi_empl i.year i.statefip [aw=empl] if year>1960 & year<2006, robust cluster(statefip)
xi: reg d_A d_A_lag d_immi_empl i.year i.statefip [aw=empl] if year>1970, robust cluster(statefip)
xi: ivreg d_A (d_immi_empl=d_immi_pop) i.statefip [aw=empl] if year>1960, robust cluster(statefip)


xi: reg d_A d_immi_empl lnA i.year i.statefip [aw=empl] if year>1960, robust cluster(statefip)


** Table 1 row 6, effect on beta
xi: reg d_beta d_immi_empl i.year i.statefip[aw=empl] if year>1960, robust cluster(statefip)
xi: reg d_beta d_immi_empl i.year i.statefip [aw=empl] if year>1970, robust cluster(statefip)
xi: reg d_beta d_immi_empl i.year i.statefip [aw=empl] if year>1960 & year<2006, robust cluster(statefip)
xi: reg d_beta d_beta_lag d_immi_empl i.year i.statefip [aw=empl] if year>1970, robust cluster(statefip)
xi: ivreg d_beta (d_immi_empl=d_immi_pop) i.year i.statefip [aw=empl] if year>1960, robust cluster(statefip)

** Table 1 row 8, effect on phi
xi: reg d_phi d_immi_empl i.year i.statefip [aw=empl] if year>1960, robust cluster(statefip)
xi: reg d_phi d_immi_empl i.year i.statefip [aw=empl] if year>1970, robust cluster(statefip)
xi: reg d_phi d_immi_empl i.year i.statefip [aw=empl] if year>1960 & year<2006, robust cluster(statefip)
xi: reg d_phi d_phi_lag d_immi_empl i.year i.statefip [aw=empl] if year>1970, robust cluster(statefip)
xi: ivreg d_phi (d_immi_empl=d_immi_pop) i.year i.statefip [aw=empl] if year>1960, robust cluster(statefip)



** first order reg, in table 2
**(1)
xi: reg d_immi_empl d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00 if year>1960, robust cluster(statefip)
test d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00

**(2)
xi: reg d_immi_empl d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00 if year>1970, robust cluster(statefip)
test d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00

**(3)
xi: reg d_immi_empl d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00 if year>1960 & year<2006, robust cluster(statefip)
test d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00

**(5)

xi: reg d_immi_empl bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00 if year>1960, robust cluster(statefip)
test bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00

xi: reg d_immi_empl d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00 if year>1960, robust cluster(statefip)
test bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00


****************


*** 2sls 
**Table 2 rows 4, 6 and 8.
** border and predicted instruments

xi: ivreg d_A (d_immi_empl= d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year>1960, robust cluster(statefip)
xi: ivreg d_A (d_immi_empl= d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.statefip [aw=empl] if year>1960, robust cluster(statefip)
xi: ivreg d_A (d_immi_empl= d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year>1970, robust cluster(statefip)
xi: ivreg d_A (d_immi_empl= d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00  la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year>1960 & year<2006, robust cluster(statefip)
xi: ivreg d_A (d_immi_empl= d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) d_A_lag i.year i.statefip [aw=empl] if year>1960, robust cluster(statefip)
xi: ivreg d_A (d_immi_empl= bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year>1960, robust cluster(statefip)



xi: ivreg d_phi (d_immi_empl= d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year>1960, robust cluster(statefip)
xi: ivreg d_phi (d_immi_empl= d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year>1970, robust cluster(statefip)
xi: ivreg d_phi (d_immi_empl= d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip[aw=empl] if year>1960 & year<2006, robust cluster(statefip)
xi: ivreg d_phi (d_immi_empl= d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) d_phi_lag i.year i.statefip [aw=empl] if year>1960, robust cluster(statefip)
xi: ivreg d_phi (d_immi_empl= bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year>1960, robust cluster(statefip)


xi: ivreg d_beta (d_immi_empl= d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00  la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year>1960, robust cluster(statefip)
xi: ivreg d_beta (d_immi_empl= d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year>1970, robust cluster(statefip)
xi: ivreg d_beta (d_immi_empl= d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00  la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year>1960 & year<2006, robust cluster(statefip)
xi: ivreg d_beta (d_immi_empl= d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00  la_dist_70 la_dist_80 la_dist_90 la_dist_00) d_phi_lag i.year i.statefip [aw=empl] if year>1960, robust cluster(statefip)
xi: ivreg d_beta (d_immi_empl= bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year>1960, robust cluster(statefip)



***** robustness (omitting some states )
xi: ivreg d_A (d_immi_empl= d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 ny_dist_70 ny_dist_80 ny_dist_90 ny_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year [aw=empl] if year>1960, robust cluster(statefip)
xi: ivreg d_A lnA_lag (d_immi_empl= d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 ny_dist_70 ny_dist_80 ny_dist_90 ny_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year [aw=empl] if year>1960, robust cluster(statefip)

xi: ivreg d_A (d_immi_empl= d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 ny_dist_70 ny_dist_80 ny_dist_90 ny_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year [aw=empl] if year>1960 & statefip~=4 & statefip~=6 & statefip~=35 & statefip~=48 , robust cluster(statefip)
xi: ivreg d_A (d_immi_empl= d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 ny_dist_70 ny_dist_80 ny_dist_90 ny_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year [aw=empl] if year>1960 & statefip~=48 & statefip~=6 & statefip~=36 , robust cluster(statefip)
xi: ivreg d_A (d_immi_empl= d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 ny_dist_70 ny_dist_80 ny_dist_90 ny_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year [aw=empl] if year>1980 , robust cluster(statefip)
xi: ivreg d_A (d_immi_empl= d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 ny_dist_70 ny_dist_80 ny_dist_90 ny_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year [aw=empl] if year>1960 & statefip~=6 & statefip~=12 , robust cluster(statefip)


xi: ivreg d_gsp_worker (d_immi_empl= d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 ny_dist_70 ny_dist_80 ny_dist_90 ny_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year [aw=empl] if year>1960, robust cluster(statefip)
xi: ivreg d_gsp_worker (d_immi_empl= d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 ny_dist_70 ny_dist_80 ny_dist_90 ny_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year [aw=empl] if year>1960 & statefip~=4 & statefip~=6 & statefip~=35 & statefip~=48 , robust cluster(statefip)
xi: ivreg d_gsp_worker (d_immi_empl= d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 ny_dist_70 ny_dist_80 ny_dist_90 ny_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year [aw=empl] if year>1960 & statefip~=48 & statefip~=6 & statefip~=36 , robust cluster(statefip)
xi: ivreg d_gsp_worker (d_immi_empl= d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 ny_dist_70 ny_dist_80 ny_dist_90 ny_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year [aw=empl] if year>1980 , robust cluster(statefip)
xi: ivreg d_gsp_worker (d_immi_empl= d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 ny_dist_70 ny_dist_80 ny_dist_90 ny_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year [aw=empl] if year>1960 & statefip~=6 & statefip~=12 , robust cluster(statefip)

xi: ivreg d_beta (d_immi_empl= d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 ny_dist_70 ny_dist_80 ny_dist_90 ny_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year [aw=empl] if year>1960, robust cluster(statefip)
xi: ivreg d_beta lnbeta (d_immi_empl= d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 ny_dist_70 ny_dist_80 ny_dist_90 ny_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year [aw=empl] if year>1960, robust cluster(statefip)

xi: ivreg d_beta (d_immi_empl= d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 ny_dist_70 ny_dist_80 ny_dist_90 ny_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year [aw=empl] if year>1960 & statefip~=4 & statefip~=6 & statefip~=35 & statefip~=48 , robust cluster(statefip)
xi: ivreg d_beta (d_immi_empl= d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 ny_dist_70 ny_dist_80 ny_dist_90 ny_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year [aw=empl] if year>1960 & statefip~=48 & statefip~=6 & statefip~=36 , robust cluster(statefip)
xi: ivreg d_beta (d_immi_empl= d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 ny_dist_70 ny_dist_80 ny_dist_90 ny_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year [aw=empl] if year>1980 , robust cluster(statefip)
xi: ivreg d_beta (d_immi_empl= d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 ny_dist_70 ny_dist_80 ny_dist_90 ny_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year [aw=empl] if year>1960 & statefip~=6 & statefip~=12 , robust cluster(statefip)



