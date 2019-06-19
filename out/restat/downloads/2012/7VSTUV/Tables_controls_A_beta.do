

clear
clear matrix
set mem 100m
set matsize 100
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
sort year statefip
save temp1, replace
clear

use "H:\Giovanni\MyPapers\Peri_Accounting\second_Revision_spring_10\empirics\New_data\panel_state_data.dta"
sort year statefip
merge 1:1 year statefip using temp1
drop _merge
sort year statefip
save temp1, replace
clear

use "H:\Giovanni\MyPapers\Peri_Accounting\second_Revision_spring_10\empirics\New_data\imputed_growth.dta"
sort year statefip
merge 1:1 year statefip using temp1


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
gen d_immi_empl=(empl_for[_n+1]-empl_for)/empl if year<2006
gen d_immi_pop=(foreign_pop[_n+1]-foreign_pop)/(foreign_pop+us_pop) if year<2006
gen d_immi_imputed=(foreign_imputed[_n+1]-foreign_imputed)/(foreign_imputed+us_pop) if year<2006



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

gen TFP=(gsp_perworker^(1/(1-alpha)))*(kap_worker^(-alpha/(1-alpha)))*(hours_perworker^(-1))
gen A_H=A*beta
gen A_L=A*(1-beta)


sort statefip year
*** percentage changes, so that the relative year is the beginning of the decade:

gen d_beta=ln(beta[_n+1])-ln(beta) if year<2006
gen d_phi=ln(phi[_n+1])-ln(phi) if year<2006
gen d_A=ln(A[_n+1])-ln(A) if year<2006
gen d_TFP=ln(TFP[_n+1])-ln(TFP) if year<2006
gen d_A_H=ln(A_H[_n+1])-ln(A_H) if year<2006
gen d_A_L=ln(A_L[_n+1])-ln(A_L) if year<2006

gen d_empl=(empl[_n+1]-empl)/empl if year<2006
gen d_gsp_worker=ln(gsp_perworker[_n+1])-ln(gsp_perworker) if year<2006

gen d_A_lag=d_A[_n-1] if year>1960
gen d_A_H_lag=d_A_H[_n-1] if year>1960
gen d_A_L_lag=d_A_L[_n-1] if year>1960

gen d_beta_lag=d_beta[_n-1] if year>1960
gen d_phi_lag=d_phi[_n-1] if year>1960

gen lnA=ln(A)
gen lngsp_worker=ln(gsp_perworker)
gen lnbeta=ln(beta)
gen lnempl=ln(empl)

/** controls, in decade flows */
*** RD per worker in tyhousands real dollars****
gen RD_worker=(rd_spending/empl)*1000
/* patents per thousands worker */
replace RD_worker=RD_worker[_n-1] if year==2000
replace RD_worker=RD_worker[_n-1] if year==2006

gen patents_worker=(patents/empl)*1000
gen patents_weight_worker=(patents_weighted/empl)*1000


/*** control in levels, differenced **/
gen dw_L_imputed=ln(imputed_indstruc_hourly_l[_n+1])-ln(imputed_indstruc_hourly_l) if year<2006
gen dw_H_imputed=ln(imputed_indstruc_hourly_h[_n+1])-ln(imputed_indstruc_hourly_h) if year<2006

gen comp_adoption=comp_intens[_n+1]-comp_intens if year<2006
replace comp_adoption=0 if comp_adoption==.

gen specialization_change=ln(language_n[_n+1]/manual_n[_n+1])-ln(language_n/manual_n) if year<2006



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



** IV estimates effect on A, A_H and A_L
gen dW_imputed=0.5*(dw_L_imputed+dw_H_imputed)
 
xi: reg d_A d_immi_empl imputed_tfp_growth i.statefip i.year [aw=empl]

gen imputed_LP_growth=imputed_gdp_growth-imputed_emp_growth

**Table 3 and 4, June 2010
** OLS
xi: reg d_A d_immi_empl  i.year i.statefip [aw=empl] if year<2006, robust cluster(statefip)
xi: reg d_A d_immi_empl RD_worker i.year i.statefip[aw=empl] if year<2006, robust cluster(statefip)
xi: reg d_A d_immi_empl comp_adoption i.year i.statefip[aw=empl] if  year<2006, robust cluster(statefip)
xi: reg d_A d_immi_empl d_trade_gsp i.year i.statefip[aw=empl] if  year<2006, robust cluster(statefip)

xi: reg d_A d_immi_empl imputed_tfp_growth  i.year i.statefip [aw=empl] if year<2006, robust cluster(statefip)

**2sls
xi: ivreg d_A (d_immi_empl = d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year<2006, robust 
xi: ivreg d_A RD_worker (d_immi_empl = d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00  la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year<2006, robust cluster(statefip)
xi: ivreg d_A comp_adoption (d_immi_empl =d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year<2006, robust cluster(statefip)
xi: ivreg d_A d_trade_gsp (d_immi_empl = d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year<2006, robust cluster(statefip)
xi: ivreg d_A (d_immi_empl = d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) imputed_tfp_growth i.year i.statefip [aw=empl] if year<2006, robust 

*2sls standard TFP
xi: ivreg d_TFP (d_immi_empl = d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year<2006, robust 
xi: ivreg d_TFP RD_worker (d_immi_empl = d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00  la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year<2006, robust cluster(statefip)
xi: ivreg d_TFP comp_adoption (d_immi_empl =d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year<2006, robust cluster(statefip)
xi: ivreg d_TFP d_trade_gsp (d_immi_empl = d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year<2006, robust cluster(statefip)
xi: ivreg d_TFP dW_imputed (d_immi_empl =d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year<2006, robust cluster(statefip)
xi: ivreg d_TFP (d_immi_empl = d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) imputed_tfp_growth i.year i.statefip [aw=empl] if year<2006, robust 
xi: ivreg d_TFP (d_immi_empl = d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) imputed_tfp_growth i.year i.statefip [aw=empl] if year<2006, robust 


** table 3 row 6/7
xi: ivreg d_A (d_immi_empl specialization_change = d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year<2006, robust 
xi: ivreg d_A RD_worker (d_immi_empl specialization_change = d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00  la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year<2006, robust cluster(statefip)
xi: ivreg d_A comp_adoption (d_immi_empl specialization_change =d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year<2006, robust cluster(statefip)
xi: ivreg d_A d_trade_gsp (d_immi_empl specialization_change = d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00  la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if  year<2006, robust cluster(statefip)
xi: ivreg d_A dW_imputed (d_immi_empl specialization_change =d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year<2006, robust cluster(statefip)
xi: ivreg d_A imputed_tfp_growth (d_immi_empl specialization_change = d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year<2006, robust 


**Table 4 june 2010
** OLS
xi: reg d_beta d_immi_empl imputed_tfp_growth i.year i.statefip [aw=empl] if year<2006, robust cluster(statefip)
xi: reg d_beta d_immi_empl RD_worker i.year i.statefip[aw=empl] if year<2006, robust cluster(statefip)
xi: reg d_beta d_immi_empl comp_adoption i.year i.statefip[aw=empl] if  year<2006, robust cluster(statefip)
xi: reg d_beta d_immi_empl d_trade_gsp i.year i.statefip[aw=empl] if  year<2006, robust cluster(statefip)
xi: reg d_beta d_immi_empl dW_imputed i.year i.statefip [aw=empl] if year<2006, robust cluster(statefip)




**** instruments
xi: reg d_immi_empl i.year i.statefip d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00 [aw=empl] if year<2006, robust cluster(statefip)
test d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00


xi: reg d_trade_gsp i.year i.statefip d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 [aw=empl] if year<2006, robust cluster(statefip)
test d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 

**2sls
xi: ivreg d_beta (d_immi_empl = d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year<2006, robust 
xi: ivreg d_beta RD_worker (d_immi_empl = d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00  la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year<2006, robust cluster(statefip)
xi: ivreg d_beta comp_adoption (d_immi_empl =d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year<2006, robust cluster(statefip)
xi: ivreg d_beta d_trade_gsp (d_immi_empl = d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year<2006, robust cluster(statefip)
xi: ivreg d_beta imputed_tfp_growth (d_immi_empl =d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year<2006, robust cluster(statefip)

xi: ivreg d_beta (d_trade_gsp = d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year<2006, robust cluster(statefip)


** channel
xi: ivreg d_beta (d_immi_empl specialization_change = d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year<2006, robust 
xi: ivreg d_beta RD_worker (d_immi_empl specialization_change = d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00  la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year<2006, robust cluster(statefip)
xi: ivreg d_beta comp_adoption (d_immi_empl specialization_change =d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year<2006, robust cluster(statefip)
xi: ivreg d_beta d_trade_gsp (d_immi_empl specialization_change = d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00  la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if  year<2006, robust cluster(statefip)
xi: ivreg d_beta imputed_tfp_growth (d_immi_empl specialization_change =d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year<2006, robust cluster(statefip)

**** basic, table 6
xi: ivreg d_empl  (d_immi_empl = d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year<2006, robust cluster(statefip)
xi: ivreg d_gsp_worker (d_immi_empl = d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year<2006, robust cluster(statefip)
xi: ivreg d_A (d_immi_empl = d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00  la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip[aw=empl] if year<2006, robust cluster(statefip)
xi: ivreg d_beta (d_immi_empl = d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year<2006, robust cluster(statefip)


**** more robustness checks : controlling for initial values
xi: ivreg d_empl lnempl (d_immi_empl = d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year [aw=empl] if year<2006, robust cluster(statefip)
xi: ivreg d_gsp_worker lngsp_worker (d_immi_empl = d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year [aw=empl] if year<2006, robust cluster(statefip)
xi: ivreg d_A lnA (d_immi_empl = d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00  la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year [aw=empl] if year<2006, robust cluster(statefip)
xi: ivreg d_beta lnbeta (d_immi_empl = d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year [aw=empl] if year<2006, robust cluster(statefip)


** controlling for the imputed values ***
xi: ivreg d_A imputed_tfp_growth (d_immi_empl =d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year<2006, robust cluster(statefip)
xi: ivreg d_empl imputed_emp_growth (d_immi_empl = d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.statefip i.year [aw=empl] if year<2006, robust cluster(statefip)
xi: ivreg d_gsp_worker imputed_gdp_growth (d_immi_empl = d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year<2006, robust cluster(statefip)
xi: ivreg d_beta imputed_tfp_growth (d_immi_empl =d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year<2006, robust cluster(statefip)


*** omitting border states CA, AZ, NM, TX
xi: ivreg d_empl (d_immi_empl = d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year<2006 & statefip~=4 & statefip~=6 & statefip~=35 & statefip~=48 , robust cluster(statefip)
xi: ivreg d_gsp_worker (d_immi_empl = d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip  [aw=empl] if year<2006 & statefip~=4 & statefip~=6 & statefip~=35 & statefip~=48 , robust cluster(statefip)
xi: ivreg d_A (d_immi_empl = d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00  la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip  [aw=empl] if year<2006 & statefip~=4 & statefip~=6 & statefip~=35 & statefip~=48 , robust cluster(statefip)
xi: ivreg d_beta (d_immi_empl = d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip  [aw=empl] if year<2006 & statefip~=4 & statefip~=6 & statefip~=35 & statefip~=48 , robust cluster(statefip)


*** omitting largest states: CA, TX,  NY
xi: ivreg d_empl (d_immi_empl = d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year<2006 & statefip~=48 & statefip~=6 & statefip~=36, robust cluster(statefip)
xi: ivreg d_gsp_worker (d_immi_empl = d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip  [aw=empl] if year<2006 & statefip~=48 & statefip~=6 & statefip~=36 , robust cluster(statefip)
xi: ivreg d_A (d_immi_empl = d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00  la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip  [aw=empl] if year<2006 & statefip~=48 & statefip~=6 & statefip~=36 , robust cluster(statefip)
xi: ivreg d_beta (d_immi_empl = d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip  [aw=empl] if year<2006 & statefip~=48 & statefip~=6 & statefip~=36 , robust cluster(statefip)


 
**1980-2006
xi: ivreg d_empl  (d_immi_empl = d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year<2006 & year>1970, robust cluster(statefip)
xi: ivreg d_gsp_worker (d_immi_empl = d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year<2006 & year>1970, robust cluster(statefip)
xi: ivreg d_A (d_immi_empl = d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00  la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip[aw=empl] if year<2006 & year>1970, robust cluster(statefip)
xi: ivreg d_beta (d_immi_empl = d_immi_imputed bord_dist_70 bord_dist_80 bord_dist_90 bord_dist_00 la_dist_70 la_dist_80 la_dist_90 la_dist_00) i.year i.statefip [aw=empl] if year<2006 & year>1970, robust cluster(statefip)



sum beta if year==1980
sum h if year==1990
sort statefip year

gen lnkap_worker=ln(kap_worker)

egen lngsp_worker_ave=mean(lngsp_worker), by (year)
egen lnkap_worker_ave=mean(lnkap_worker), by (year)
egen lnA_ave=mean(lnA), by (year)
egen beta_ave=mean(beta), by (year)




*** figures on gdp and capital
twoway connect lngsp_worker lngsp_worker_ave year if statefip~=10 & statefip~=11, mlabel(state_code)
twoway connect lnkap_worker lnkap_worker_ave year if statefip~=10 & statefip~=11, mlabel(state_code)
twoway connect lnA lnA_ave year if statefip~=11 & statefip~=10 , mlabel(state_code)
twoway connect beta beta_ave year if statefip~=11 & statefip~=10 , mlabel(state_code)





