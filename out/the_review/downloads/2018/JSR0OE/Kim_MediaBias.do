* This do-file provides codes to replicate tables and figures (except Figures 2 and A1) presented in the manuscript and in the online supplementary appendix. For replication code for Figure 2 and Figure A1 in the appendix, please see Kim_MediaBias_STM.R. 
* One should have "estout", "drarea", and "grc1leg" packages installed; Please install the packages by typing "ssc install estout, replace", "ssc install drarea, replace", and "findit grc1leg" before running the following codes.
* Calculating two-way clustered standard errors reported in Table A15 requires running "probit2.ado" available at http://www.kellogg.northwestern.edu/faculty/petersen/htm/papers/se/probit2.ado)

**************************************************************
**** Table 1: Summary Statistics of Auto-Recall Reporting ****
**************************************************************

use "RecallReporting.dta", clear

set matsize 800, perm
xtset newspaper_id recall_id

egen report_prop = mean(report), by(newspaper)

egen domestic_s_report = mean(report / (classification == "Domestic" & recall_size <= 10000)), by(newspaper)
egen joint_s_report = mean(report / (classification == "Joint Venture" & recall_size <= 10000)), by(newspaper)
egen foreign_s_report = mean(report / (classification == "Foreign" & recall_size <= 10000)), by(newspaper)

egen domestic_l_report = mean(report / (classification == "Domestic" & recall_size > 10000)), by(newspaper)
egen joint_l_report = mean(report / (classification == "Joint Venture" & recall_size > 10000)), by(newspaper)
egen foreign_l_report = mean(report / (classification == "Foreign" & recall_size > 10000)), by(newspaper)

egen electrical_report = mean(report / (electrical==1)), by(newspaper)
egen engine_report = mean(report / (engine==1)), by(newspaper)
egen steering_report = mean(report / (steering==1)), by(newspaper)
egen brake_report = mean(report / (brake==1)), by(newspaper)

foreach var of varlist report_prop domestic_s_report joint_s_report foreign_s_report domestic_l_report joint_l_report foreign_l_report electrical_report engine_report steering_report brake_report  {
	replace `var'= `var'*100
}

gen official2 = official*-1
label define official2 0 "Non-Official" -1 "Official"
label values official2 official2

bysort newspaper: gen id = _n

eststo clear
estpost tabstat report_prop domestic_s_report joint_s_report foreign_s_report domestic_l_report joint_l_report foreign_l_report electrical_report engine_report steering_report brake_report if id == 1, statistics(mean min max) columns(statistics) by(official2) nototal
esttab using "Table1.tex", replace f cells("min(fmt(1)) mean(fmt(1)) max(fmt(1))") nonum label unstack noobs

drop id

************************************************************************************************
**** Table 2 & Table A3: Probit Models Estimating News Coverage Probability of Auto Recalls ****
************************************************************************************************

eststo clear 

eststo: dprobit report official foreign log_recallsize airbag brake electrical engine powertrain steering, cluster(recall_id)
eststo: dprobit report official foreign official_foreign log_recallsize airbag brake electrical engine powertrain steering, cluster(recall_id)
eststo: xi: dprobit report official foreign official_foreign log_recallsize airbag brake electrical engine powertrain steering i.province_id i.halfyear_id, cluster(recall_id)
eststo: xi: dprobit report official foreign official_foreign log_recallsize airbag brake electrical engine powertrain steering i.newspaper_id i.recall_id, cluster(recall_id)

eststo: xi: dprobit report official_central official_regional foreign log_recallsize airbag brake electrical engine powertrain steering, cluster(recall_id)
eststo: xi: dprobit report official_central official_regional foreign official_central_foreign official_regional_foreign log_recallsize airbag brake electrical engine powertrain steering, cluster(recall_id)
eststo: xi: dprobit report official_central official_regional foreign official_central_foreign official_regional_foreign log_recallsize airbag brake electrical engine powertrain steering i.province_id i.halfyear_id, cluster(recall_id)
eststo: xi: dprobit report official_central official_regional foreign official_central_foreign official_regional_foreign log_recallsize airbag brake electrical engine powertrain steering i.newspaper_id i.recall_id, cluster(recall_id)

esttab using "Table2.tex", booktabs margin label keep (official official_foreign foreign official_central official_regional foreign official_central_foreign official_regional_foreign) order (foreign official official_foreign  official_central official_central_foreign official_regional official_regional_foreign) mtitles ("" "" "" "" "" "" "" "") nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps indicate ("Province FE = *province*" "Newspaper FE = *newspaper*" "Halfyear FE = *half*" "Recall FE = *recall_id*")
esttab using "TableA3.tex", booktabs margin label keep (official official_foreign foreign  official_central official_regional foreign official_central_foreign official_regional_foreign log_recallsize airbag brake electrical engine powertrain steering) order (foreign official official_foreign  official_central official_central_foreign official_regional official_regional_foreign log_recallsize airbag brake electrical engine powertrain steering) mtitles ("" "" "" "" "" "" "" "") nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps indicate ("Province FE = *province*" "Newspaper FE = *newspaper*" "Halfyear FE = *half*" "Recall FE = *recall_id*")

***********************************************************************************
**** Table 3 & Table A4: Length and Sentiment of Article as Dependent Variable ****
***********************************************************************************

use "ReportingLengthSentiment.dta", clear

eststo clear

eststo: xi: regress wordcounts foreign log_recallsize_sum airbag brake electrical engine powertrain steering i.newspaper if official_central == 1, cluster(week_id)
eststo: xi: regress wordcounts foreign log_recallsize_sum airbag brake electrical engine powertrain steering i.newspaper i.halfyear_id  if official_central == 1, cluster(week_id) 
eststo: xi: regress wordcounts foreign log_recallsize_sum airbag brake electrical engine powertrain steering i.newspaper if official_regional == 1, cluster(week_id) 
eststo: xi: regress wordcounts foreign log_recallsize_sum airbag brake electrical engine powertrain steering i.newspaper i.halfyear_id  if official_regional == 1, cluster(week_id) 
eststo: xi: regress wordcounts foreign log_recallsize_sum airbag brake electrical engine powertrain steering i.newspaper if official == 0, cluster(week_id) 
eststo: xi: regress wordcounts foreign log_recallsize_sum airbag brake electrical engine powertrain steering i.newspaper i.halfyear_id  if official == 0, cluster(week_id) 

esttab using "Table3_A.tex", booktabs label keep (foreign) order (foreign) indicate("Newspaper FE = *newspaper*" "Halfyear FE = *halfyear*") nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps
esttab using "TableA4_A.tex", booktabs label keep (foreign log_recallsize_sum airbag brake electrical engine powertrain steering) order (foreign log_recallsize_sum airbag brake electrical engine powertrain steering) indicate("Newspaper FE = *newspaper*" "Halfyear FE = *halfyear*") nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps
   
   
eststo clear

eststo: xi: regress sentiment foreign log_recallsize_sum airbag brake electrical engine powertrain steering i.newspaper if official_central == 1
eststo: xi: regress sentiment foreign log_recallsize_sum airbag brake electrical engine powertrain steering i.newspaper i.halfyear_id  if official_central == 1
eststo: xi: regress sentiment foreign log_recallsize_sum airbag brake electrical engine powertrain steering i.newspaper if official_regional == 1
eststo: xi: regress sentiment foreign log_recallsize_sum airbag brake electrical engine powertrain steering i.newspaper i.halfyear_id  if official_regional == 1
eststo: xi: regress sentiment foreign log_recallsize_sum airbag brake electrical engine powertrain steering i.newspaper if official == 0
eststo: xi: regress sentiment foreign log_recallsize_sum airbag brake electrical engine powertrain steering i.newspaper i.halfyear_id  if official == 0

esttab using "Table3_B.tex", booktabs label keep (foreign) order (foreign) indicate("Newspaper FE = *newspaper*" "Halfyear FE = *halfyear*") nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps
esttab using "TableA4_B.tex", booktabs label keep (foreign log_recallsize_sum airbag brake electrical engine powertrain steering) order (foreign log_recallsize_sum airbag brake electrical engine powertrain steering) indicate("Newspaper FE = *newspaper*" "Halfyear FE = *halfyear*") nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps


***********************************************************************************************************
**** Table 4 & Table A5: Probit Models Estimating Effect of Auto SOE Ownership on Recall News Coverage ****
***********************************************************************************************************

use "RecallReporting.dta", clear
xtset newspaper_id recall_id

eststo clear 

eststo: dprobit report official_auto_soe official_non_auto_soe foreign log_recallsize airbag brake electrical engine powertrain steering if official_central == 0, cluster(recall_id)
eststo: dprobit report official_auto_soe official_non_auto_soe foreign official_auto_soe_f official_non_auto_soe_f log_recallsize airbag brake electrical engine powertrain steering if official_central == 0, cluster(recall_id)
eststo: xi: dprobit report official_auto_soe official_non_auto_soe foreign official_auto_soe_f official_non_auto_soe_f log_recallsize airbag brake electrical engine powertrain steering i.province i.halfyear_id  if official_central == 0, cluster(recall_id)
eststo: xi: dprobit report official_auto_soe official_non_auto_soe foreign official_auto_soe_f official_non_auto_soe_f log_recallsize airbag brake electrical engine powertrain steering log_gdp pop fdi i.province i.halfyear_id  if official_central == 0, cluster(recall_id)
eststo: xi: dprobit report official_auto_soe official_non_auto_soe foreign official_auto_soe_f official_non_auto_soe_f log_recallsize airbag brake electrical engine powertrain steering log_gdp pop fdi log_advertising i.province i.halfyear_id  if official_central == 0, cluster(recall_id)
eststo: xi: dprobit report official_auto_soe official_non_auto_soe foreign official_auto_soe_f official_non_auto_soe_f log_recallsize airbag brake electrical engine powertrain steering log_gdp pop fdi log_advertising cars log_retail_auto log_passengercars i.province i.halfyear_id  if official_central == 0, cluster(recall_id)
eststo: xi: dprobit report official_auto_soe official_non_auto_soe foreign official_auto_soe_f official_non_auto_soe_f log_recallsize airbag brake electrical engine powertrain steering log_gdp pop fdi log_advertising cars log_retail_auto log_passengercars i.newspaper_id i.recall_id   if official_central == 0, cluster(recall_id)

esttab using "Table4.tex", booktabs margin label keep (official_auto_soe official_non_auto_soe foreign official_auto_soe_f official_non_auto_soe_f log_gdp pop fdi log_advertising cars log_retail_auto log_passengercars ) order (foreign official_auto_soe official_non_auto_soe official_auto_soe_f official_non_auto_soe_f log_gdp pop fdi log_advertising cars log_retail_auto log_passengercars ) mtitles ("" "" "" "" "" "" "" "") nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps indicate ("Province FE = *province*" "Newspaper FE = *newspaper*" "Halfyear FE = *half*" "Recall FE = *recall_id*")
esttab using "TableA5.tex", booktabs margin label keep (official_auto_soe official_non_auto_soe foreign official_auto_soe_f official_non_auto_soe_f log_gdp pop fdi log_advertising cars log_retail_auto log_passengercars log_recallsize airbag brake electrical engine powertrain steering) order (foreign official_auto_soe official_non_auto_soe official_auto_soe_f official_non_auto_soe_f log_gdp pop fdi log_advertising cars log_retail_auto log_passengercars log_recallsize airbag brake electrical engine powertrain steering) mtitles ("" "" "" "" "" "" "" "") nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps indicate ("Province FE = *province*" "Newspaper FE = *newspaper*" "Halfyear FE = *half*" "Recall FE = *recall_id*")

****************************************************************************************************
**** Table 5 & Table A7: Split-Sample Analysis by Newspaper Types and Automotive SOEs Ownership ****
****************************************************************************************************

eststo clear
eststo: xi: dprobit report foreign log_recallsize airbag brake electrical engine powertrain steering log_gdp pop fdi log_advertising cars log_retail_auto log_passengercars i.newspaper_id  if official_central == 0 & auto_soe_province == 1 & official == 1, cluster(recall_id)
eststo: xi: dprobit report foreign log_recallsize airbag brake electrical engine powertrain steering log_gdp pop fdi log_advertising cars log_retail_auto log_passengercars i.newspaper_id i.halfyear_id if official_central == 0 & auto_soe_province == 1 & official == 1, cluster(recall_id)

eststo: xi: dprobit report foreign log_recallsize airbag brake electrical engine powertrain steering log_gdp pop fdi log_advertising cars log_retail_auto log_passengercars i.newspaper_id if official_central == 0 & auto_soe_province == 0 & official == 1, cluster(recall_id)
eststo: xi: dprobit report foreign log_recallsize airbag brake electrical engine powertrain steering log_gdp pop fdi log_advertising cars log_retail_auto log_passengercars i.newspaper_id i.halfyear_id if official_central == 0 & auto_soe_province == 0 & official == 1, cluster(recall_id)

eststo: xi: dprobit report foreign log_recallsize airbag brake electrical engine powertrain steering log_gdp pop fdi log_advertising cars log_retail_auto log_passengercars i.newspaper_id if official_central == 0 & auto_soe_province == 1 & official == 0, cluster(recall_id)
eststo: xi: dprobit report foreign log_recallsize airbag brake electrical engine powertrain steering log_gdp pop fdi log_advertising cars log_retail_auto log_passengercars i.newspaper_id i.halfyear_id if official_central == 0 & auto_soe_province == 1 & official == 0, cluster(recall_id)

eststo: xi: dprobit report foreign log_recallsize airbag brake electrical engine powertrain steering log_gdp pop fdi log_advertising cars log_retail_auto log_passengercars i.newspaper_id if official_central == 0 & auto_soe_province == 0 & official == 0, cluster(recall_id)
eststo: xi: dprobit report foreign log_recallsize airbag brake electrical engine powertrain steering log_gdp pop fdi log_advertising cars log_retail_auto log_passengercars i.newspaper_id i.halfyear_id if official_central == 0 & auto_soe_province == 0 & official == 0, cluster(recall_id)

esttab using "Table5.tex", booktabs margin label keep (foreign log_gdp pop fdi log_advertising cars log_retail_auto log_passengercars) order (foreign log_gdp pop fdi log_advertising cars log_retail_auto log_passengercars) indicate("Newspaper FE = *newspaper*" "Halfyear FE = *halfyear*") nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps
esttab using "TableA7.tex", booktabs margin label keep (foreign log_recallsize airbag brake electrical engine powertrain steering log_gdp pop fdi log_advertising cars log_retail_auto log_passengercars) order (foreign log_recallsize airbag brake electrical engine powertrain steering log_gdp pop fdi log_advertising cars log_retail_auto log_passengercars) indicate("Newspaper FE = *newspaper*" "Halfyear FE = *halfyear*") nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps


***************************************************************************************
**** Table 6 & Table A6: Regression Models Examining Recall-Related Web-Query Data **** 
***************************************************************************************

use "BaiduIndex.dta", clear

eststo clear

eststo: xi: regress log_index foreign log_recall_size airbag brake electrical engine powertrain steering structure i.province i.halfyear_id, cluster(recall_id)
eststo: xi: regress log_index foreign central_report log_recall_size airbag brake electrical engine powertrain steering structure i.province i.halfyear_id, cluster(recall_id)
eststo: xi: regress log_index foreign central_report regional_report log_recall_size airbag brake electrical engine powertrain steering structure i.province i.halfyear_id, cluster(recall_id)
eststo: xi: regress log_index foreign central_report regional_official_report log_recall_size airbag brake electrical engine powertrain steering structure i.province i.halfyear_id, cluster(recall_id)
eststo: xi: regress log_index foreign central_report regional_commercial_report log_recall_size airbag brake electrical engine powertrain steering structure i.province i.halfyear_id, cluster(recall_id)
eststo: xi: regress log_index foreign central_report regional_official_report regional_commercial_report log_recall_size airbag brake electrical engine powertrain steering structure i.province i.halfyear_id, cluster(recall_id)

esttab using "Table6.tex", booktabs label mtitles ("" "" "" "" "" "") keep (foreign central_report regional_report regional_official_report regional_commercial_report) order (foreign central_report regional_report regional_official_report regional_commercial_report) nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps indicate("Province FE = *province*" "Halfyear FE = *half*") 
esttab using "TableA6.tex", booktabs label mtitles ("" "" "" "" "" "") keep (foreign central_report regional_report regional_official_report regional_commercial_report log_recall_size airbag brake electrical engine powertrain steering structure) order (foreign central_report regional_report regional_official_report regional_commercial_report log_recall_size airbag brake electrical engine powertrain steering structure) nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps indicate("Province FE = *province*" "Halfyear FE = *half*") 

********************************************************************************
**** Table 7: Regression Models Estimating Effect of News Coverage on Sales **** 
********************************************************************************

use "Sales.dta", clear

tab company_id, gen(company_id_dummy)

forvalues i = 1(1)79 {
	generate company_trend`i' = company_id_dummy`i' * time
}

eststo clear
eststo: xi: xtreg D1unit L1recall_yearly if year > 2006, fe cluster(company_id)
eststo: xi: xtreg D1unit L1recall_yearly L1recall_yearly_f  if year > 2006, fe cluster(company_id)
eststo: xi: xtreg D1unit L1recall_yearly L1recall_yearly_f L1central_report if year > 2006, fe cluster(company_id)
eststo: xi: xtreg D1unit L1recall_yearly L1recall_yearly_f L1central_report time*  if year > 2006, fe cluster(company_id)
eststo: xi: xtreg D1unit L1recall_yearly L1recall_yearly_f L1central_report time* company_trend1 - company_trend79 if year > 2006, fe cluster(company_id)

esttab using "Table7.tex", booktabs label mtitles ("" "" "" "" "") keep (L1recall_yearly L1recall_yearly_f L1central_report) order (L1recall_yearly L1recall_yearly_f L1central_report) nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps indicate("Yearly Trend = time*" "Firm-specific Trend = *trend*")

**************************************************************************************
**** Figure 1: Predicted Probability of Reporting a Recall Event by Nespaper Type **** /* one should have drarea package & grc1leg package installed; type "findit drarea" and "findit grc1leg" for installation before running the following code*/
**************************************************************************************

use "RecallReporting.dta", clear

set matsize 800, perm
xtset newspaper_id recall_id

gen x = (_n-1)/2

gen pr_central_domestic = .
gen pr_central_foreign = . 
gen pr_regional_domestic = .
gen pr_regional_foreign = . 
gen pr_commercial_domestic = .
gen pr_commercial_foreign = .

gen u_pr_central_domestic = .
gen u_pr_central_foreign = . 
gen u_pr_regional_domestic = .
gen u_pr_regional_foreign = . 
gen u_pr_commercial_domestic = .
gen u_pr_commercial_foreign = .

gen l_pr_central_domestic = .
gen l_pr_central_foreign = . 
gen l_pr_regional_domestic = .
gen l_pr_regional_foreign = . 
gen l_pr_commercial_domestic = .
gen l_pr_commercial_foreign = .

probit report official_central official_regional foreign official_central_foreign official_regional_foreign log_recallsize airbag brake electrical engine powertrain steering, cluster(recall_id)
preserve

drawnorm _b1-_b13, n(1000) means(e(b)) cov(e(V)) clear

save simulated_betas, replace
restore

merge using simulated_betas
summarize _merge
drop _merge
summarize official_central official_regional foreign official_central_foreign official_regional_foreign log_recallsize airbag brake electrical engine powertrain steering

forvalues i = 0(1)28 {

* Central Official Paper & Foreign

scalar h_official_central = 1
scalar h_official_regional = 0
scalar h_foreign = 1
scalar h_official_central_foreign = 1
scalar h_official_regional_foreign = 0
scalar h_log_recallsize = `i'/2
scalar h_airbag = 0
scalar h_brake = 0
scalar h_electrical = 0
scalar h_engine = 1
scalar h_powertrain = 0
scalar h_steering = 0
scalar h_constant = 1

generate x_betahat = _b1*h_official_central + _b2*h_official_regional + _b3*h_foreign + _b4*h_official_central_foreign + _b5*h_official_regional_foreign + _b6* h_log_recallsize + _b7*h_airbag + _b8*h_brake + _b9*h_electrical + _b10*h_engine + _b11*h_powertrain + _b12*h_steering + _b13*h_constant
generate prob_hat = normal(x_betahat)
sum prob_hat
centile prob_hat, centile(2.5 50 97.5)

replace pr_central_foreign= r(c_2) if x == `i'/2
replace u_pr_central_foreign = r(c_3) if x == `i'/2
replace l_pr_central_foreign = r(c_1) if x == `i'/2

drop x_betahat prob_hat

* Central Official Paper & Domestic

scalar h_official_central = 1
scalar h_official_regional = 0
scalar h_foreign = 0
scalar h_official_central_foreign = 0
scalar h_official_regional_foreign = 0
scalar h_log_recallsize = `i'/2
scalar h_airbag = 0
scalar h_brake = 0
scalar h_electrical = 0
scalar h_engine = 1
scalar h_powertrain = 0
scalar h_steering = 0
scalar h_constant = 1

generate x_betahat = _b1*h_official_central + _b2*h_official_regional + _b3*h_foreign + _b4*h_official_central_foreign + _b5*h_official_regional_foreign + _b6* h_log_recallsize + _b7*h_airbag + _b8*h_brake + _b9*h_electrical + _b10*h_engine + _b11*h_powertrain + _b12*h_steering + _b13*h_constant
generate prob_hat = normal(x_betahat)
sum prob_hat
centile prob_hat, centile(2.5 50 97.5)

replace pr_central_domestic= r(c_2) if x == `i'/2
replace u_pr_central_domestic = r(c_3) if x == `i'/2
replace l_pr_central_domestic = r(c_1) if x == `i'/2

drop x_betahat prob_hat

* Regional Official Paper & Foreign

scalar h_official_central = 0
scalar h_official_regional = 1
scalar h_foreign = 1
scalar h_official_central_foreign = 0
scalar h_official_regional_foreign = 1
scalar h_log_recallsize = `i'/2
scalar h_airbag = 0
scalar h_brake = 0
scalar h_electrical = 0
scalar h_engine = 1
scalar h_powertrain = 0
scalar h_steering = 0
scalar h_constant = 1

generate x_betahat = _b1*h_official_central + _b2*h_official_regional + _b3*h_foreign + _b4*h_official_central_foreign + _b5*h_official_regional_foreign + _b6* h_log_recallsize + _b7*h_airbag + _b8*h_brake + _b9*h_electrical + _b10*h_engine + _b11*h_powertrain + _b12*h_steering + _b13*h_constant
generate prob_hat = normal(x_betahat)
sum prob_hat
centile prob_hat, centile(2.5 50 97.5)

replace pr_regional_foreign= r(c_2) if x == `i'/2
replace u_pr_regional_foreign = r(c_3) if x == `i'/2
replace l_pr_regional_foreign = r(c_1) if x == `i'/2

drop x_betahat prob_hat

* Regional Official Paper & Domestic

scalar h_official_central = 0
scalar h_official_regional = 1
scalar h_foreign = 0
scalar h_official_central_foreign = 0
scalar h_official_regional_foreign = 0
scalar h_log_recallsize = `i'/2
scalar h_airbag = 0
scalar h_brake = 0
scalar h_electrical = 0
scalar h_engine = 1
scalar h_powertrain = 0
scalar h_steering = 0
scalar h_constant = 1

generate x_betahat = _b1*h_official_central + _b2*h_official_regional + _b3*h_foreign + _b4*h_official_central_foreign + _b5*h_official_regional_foreign + _b6* h_log_recallsize + _b7*h_airbag + _b8*h_brake + _b9*h_electrical + _b10*h_engine + _b11*h_powertrain + _b12*h_steering + _b13*h_constant
generate prob_hat = normal(x_betahat)
sum prob_hat
centile prob_hat, centile(2.5 50 97.5)

replace pr_regional_domestic= r(c_2) if x == `i'/2
replace u_pr_regional_domestic = r(c_3) if x == `i'/2
replace l_pr_regional_domestic = r(c_1) if x == `i'/2

drop x_betahat prob_hat

* Commercial Paper & Foreign

scalar h_official_central = 0
scalar h_official_regional = 0
scalar h_foreign = 1
scalar h_official_central_foreign = 0
scalar h_official_regional_foreign = 0
scalar h_log_recallsize = `i'/2
scalar h_airbag = 0
scalar h_brake = 0
scalar h_electrical = 0
scalar h_engine = 1
scalar h_powertrain = 0
scalar h_steering = 0
scalar h_constant = 1

generate x_betahat = _b1*h_official_central + _b2*h_official_regional + _b3*h_foreign + _b4*h_official_central_foreign + _b5*h_official_regional_foreign + _b6* h_log_recallsize + _b7*h_airbag + _b8*h_brake + _b9*h_electrical + _b10*h_engine + _b11*h_powertrain + _b12*h_steering + _b13*h_constant
generate prob_hat = normal(x_betahat)
sum prob_hat
centile prob_hat, centile(2.5 50 97.5)

replace pr_commercial_foreign= r(c_2) if x == `i'/2
replace u_pr_commercial_foreign = r(c_3) if x == `i'/2
replace l_pr_commercial_foreign = r(c_1) if x == `i'/2

drop x_betahat prob_hat

* Commercial Paper & Domestic

scalar h_official_central = 0
scalar h_official_regional = 0
scalar h_foreign = 0
scalar h_official_central_foreign = 0
scalar h_official_regional_foreign = 0
scalar h_log_recallsize = `i'/2
scalar h_airbag = 0
scalar h_brake = 0
scalar h_electrical = 0
scalar h_engine = 1
scalar h_powertrain = 0
scalar h_steering = 0
scalar h_constant = 1

generate x_betahat = _b1*h_official_central + _b2*h_official_regional + _b3*h_foreign + _b4*h_official_central_foreign + _b5*h_official_regional_foreign + _b6* h_log_recallsize + _b7*h_airbag + _b8*h_brake + _b9*h_electrical + _b10*h_engine + _b11*h_powertrain + _b12*h_steering + _b13*h_constant
generate prob_hat = normal(x_betahat)
sum prob_hat
centile prob_hat, centile(2.5 50 97.5)

replace pr_commercial_domestic= r(c_2) if x == `i'/2
replace u_pr_commercial_domestic = r(c_3) if x == `i'/2
replace l_pr_commercial_domestic = r(c_1) if x == `i'/2

drop x_betahat prob_hat

}

label var x "Log (Recall Size)"

label var pr_central_domestic "Domestic Recalls" 
label var pr_central_foreign "Foreign Recalls"

drarea u_pr_central_foreign l_pr_central_foreign u_pr_central_domestic l_pr_central_domestic x if x<=14, color(gs8 gs12) ///
	   twoway((line pr_central_domestic x if x <=14, lcolor(black) lpattern(dash) lwidth(medthick)) (line pr_central_foreign x if x <=14, lcolor(black) lpattern(solid) lwidth(medthick))) ///
	   yline(0.6, lcolor(gs15)) ylabel(0(0.1)0.6, labsize(medlarge)) xscale(range(0 14) titlegap(1)) xlabel(0(2)14, labsize(large)) legend(on order(5 4)) graphregion(color(white)) legend(size(small)  region(lcolor(white))) title(Central Party Official, size(large) color(black)) ytitle("Predicted Probability of News Coverage", size(large)) ysize(4) xsize(8)

graph save "CentralOfficial.gph", replace

drarea u_pr_regional_foreign l_pr_regional_foreign u_pr_regional_domestic l_pr_regional_domestic x if x<=14, color(gs8 gs12) ///
	   twoway((line pr_regional_domestic x if x <=14, lcolor(black) lpattern(dash) lwidth(medthick)) (line pr_regional_foreign x if x <=14, lcolor(black) lpattern(solid) lwidth(medthick))) ///
	   yline(0.6, lcolor(gs15)) ylabel(0(0.1)0.6, labsize(medlarge)) xscale(range(0 14) titlegap(1)) xlabel(0(2)14, labsize(large)) legend(off) graphregion(color(white)) legend(size(small)  region(lcolor(white))) title(Regional Party Official, size(large) color(black)) ytitle("Predicted Probability of News Coverage", size(large)) ysize(4) xsize(8)
	   
graph save "RegionalOfficial.gph", replace
	   
drarea u_pr_commercial_foreign l_pr_commercial_foreign u_pr_commercial_domestic l_pr_commercial_domestic x if x<=14, color(gs8 gs12) ///
	   twoway((line pr_commercial_domestic x if x <=14, lcolor(black) lpattern(dash) lwidth(medthick)) (line pr_commercial_foreign x if x <=14, lcolor(black) lpattern(solid) lwidth(medthick))) ///
	   yline(0.6, lcolor(gs15)) ylabel(0(0.1)0.6, labsize(medlarge)) xscale(range(0 14) titlegap(1)) xlabel(0(2)14, labsize(large)) legend(off) graphregion(color(white)) legend(size(small)  region(lcolor(white))) title(Non-Official, size(large) color(black)) ytitle("Predicted Probability of News Coverage", size(large)) ysize(4) xsize(10)

graph save "Commercial.gph", replace

grc1leg "CentralOfficial.gph" "RegionalOfficial.gph" "Commercial.gph", col(3) graphregion(color(white)) legendfrom("CentralOfficial.gph") 

graph save "Figure1.gph", replace

rm "CentralOfficial.gph"
rm "RegionalOfficial.gph"
rm "Commercial.gph"
 
********************************************************************
**** Table A1: Summary Statistics of Recalls Announced in China ****
********************************************************************

bysort recall_id: gen id = _n

eststo clear
estpost tabstat recall_size airbag brake electrical engine powertrain steering structure others if id == 1, statistics(mean sd) columns(statistics) by(classification) nototal
esttab using "TableA1.tex", replace f cells("mean(fmt(2)) sd(fmt(2))")  label unstack 
	
drop id 
 
************************************************************
**** Table A8: Split-Sample Analysis by Newspaper Types ****
************************************************************

eststo clear

eststo: xi: dprobit report foreign log_recallsize airbag brake electrical engine powertrain steering i.newspaper if official_central == 1, cluster(recall_id) 
eststo: xi: dprobit report foreign log_recallsize airbag brake electrical engine powertrain steering i.newspaper i.halfyear_id  if official_central == 1, cluster(recall_id) 

eststo: xi: dprobit report foreign log_recallsize airbag brake electrical engine powertrain steering i.newspaper if official_regional == 1, cluster(recall_id) 
eststo: xi: dprobit report foreign log_recallsize airbag brake electrical engine powertrain steering i.newspaper i.halfyear_id  if official_regional == 1, cluster(recall_id) 

eststo: xi: dprobit report foreign log_recallsize airbag brake electrical engine powertrain steering i.newspaper if official == 0, cluster(recall_id) 
eststo: xi: dprobit report foreign log_recallsize airbag brake electrical engine powertrain steering i.newspaper i.halfyear_id  if official == 0, cluster(recall_id) 

esttab using "TableA8.tex", booktabs margin label keep (foreign log_recallsize airbag brake electrical engine powertrain steering) order (foreign log_recallsize airbag brake electrical engine powertrain steering) indicate("Newspaper FE = *newspaper*" "Halfyear FE = *halfyear*") nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps

********************************************
**** Table A9: Aggregate-Level Analysis ****
********************************************

egen report_count_f = total(report / (foreign == 1)), by(newspaper_id)
egen report_count_d = total(report / (foreign == 0)), by(newspaper_id)
gen percentage = report_count_f/(report_count_f+report_count_d)

bysort newspaper_id: gen id = _n

eststo clear
eststo: regress percentage official_central official_regional if id == 1
eststo: regress percentage official_auto_soe official_non_auto_soe if official_central == 0 & id == 1

esttab using "TableA9.tex", booktabs label keep (official_central official_regional official_auto_soe official_non_auto_soe) nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps 

************************************************************************************
**** Table A10: Robustness Analysis of Recall Reporting with Auto Price Control ****
************************************************************************************

eststo clear

eststo: xi: dprobit report official foreign official_foreign log_recallsize airbag brake electrical engine powertrain steering price i.province i.halfyear_id, cluster(recall_id)
eststo: xi: dprobit report official foreign official_foreign log_recallsize airbag brake electrical engine powertrain steering luxury_dummy i.province i.halfyear_id, cluster(recall_id)
eststo: xi: dprobit report official foreign official_foreign log_recallsize airbag brake electrical engine powertrain steering i.province i.halfyear_id if luxury_dummy == 0, cluster(recall_id)

esttab using "TableA10_1.tex", booktabs margin label keep (official foreign official_foreign) order (foreign official official_foreign) mtitles ("Auto Price Control" "Luxury Model Control" "Non-Luxury Only") pr2(3) nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps nonotes

eststo clear
eststo: xi: dprobit report official_central official_regional foreign official_central_foreign official_regional_foreign  log_recallsize airbag brake electrical engine powertrain steering price i.province i.halfyear_id, cluster(recall_id)
eststo: xi: dprobit report official_central official_regional foreign official_central_foreign official_regional_foreign  log_recallsize airbag brake electrical engine powertrain steering luxury_dummy i.province i.halfyear_id, cluster(recall_id)
eststo: xi: dprobit report official_central official_regional foreign official_central_foreign official_regional_foreign  log_recallsize airbag brake electrical engine powertrain steering i.province i.halfyear_id if luxury_dummy == 0,  cluster(recall_id)

esttab using "TableA10_2.tex", booktabs margin label keep (official_central official_regional foreign official_central_foreign official_regional_foreign) order (foreign official_central official_regional official_central_foreign official_regional_foreign) mtitles ("Auto Price Control" "Luxury Model Control" "Non-Luxury Only") pr2(3) nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps nonotes

eststo clear
eststo: xi: dprobit report official_auto_soe official_non_auto_soe foreign official_auto_soe_f official_non_auto_soe_f log_recallsize airbag brake electrical engine powertrain steering  log_gdp pop fdi log_advertising cars log_retail_auto log_passengercars i.province i.halfyear_id price if official_central == 0, cluster(recall_id)
eststo: xi: dprobit report official_auto_soe official_non_auto_soe foreign official_auto_soe_f official_non_auto_soe_f log_recallsize airbag brake electrical engine powertrain steering  log_gdp pop fdi log_advertising cars log_retail_auto log_passengercars i.province i.halfyear_id luxury_dummy if official_central == 0, cluster(recall_id)
eststo: xi: dprobit report official_auto_soe official_non_auto_soe foreign official_auto_soe_f official_non_auto_soe_f log_recallsize airbag brake electrical engine powertrain steering  log_gdp pop fdi log_advertising cars log_retail_auto log_passengercars i.province i.halfyear_id if luxury_dummy == 0 & official_central == 0, cluster(recall_id)

esttab using "TableA10_3.tex", booktabs margin label keep (foreign official_auto_soe official_non_auto_soe official_auto_soe_f official_non_auto_soe_f) order (foreign official_auto_soe official_non_auto_soe official_auto_soe_f official_non_auto_soe_f) mtitles ("Auto Price Control" "Luxury Model Control" "Non-Luxury Only") pr2(3) nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01)  compress nogaps

******************************************************************************************
**** Table A11: Robustness Analysis of Recall Reporting with Recall Frequency Control ****
******************************************************************************************

eststo clear
eststo: xi: dprobit report official foreign official_foreign log_recallsize airbag brake electrical engine powertrain steering recall_frequency i.province i.halfyear_id, cluster(recall_id)

esttab using "TableA11_1.tex", booktabs margin label keep (official foreign official_foreign) order (foreign official official_foreign) mtitles ("Recall Frequency Control") pr2(3) nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps nonotes

eststo clear
eststo: xi: dprobit report official_central official_regional foreign official_central_foreign official_regional_foreign  log_recallsize airbag brake electrical engine powertrain steering recall_frequency i.province i.halfyear_id, cluster(recall_id)

esttab using "TableA11_2", booktabs margin label keep (official_central official_regional foreign official_central_foreign official_regional_foreign) order (foreign official_central official_regional official_central_foreign official_regional_foreign) mtitles ("Recall Frequency Control") pr2(3) nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps nonotes

eststo clear
eststo: xi: dprobit report official_auto_soe official_non_auto_soe foreign official_auto_soe_f official_non_auto_soe_f log_recallsize airbag brake electrical engine powertrain steering  log_gdp pop fdi log_advertising cars log_retail_auto log_passengercars i.province i.halfyear_id recall_frequency, cluster(recall_id)

esttab using "TableA11_3.tex", booktabs margin label keep (foreign official_auto_soe official_non_auto_soe official_auto_soe_f official_non_auto_soe_f) order (foreign official_auto_soe official_non_auto_soe official_auto_soe_f official_non_auto_soe_f) mtitles ("Recall Frequency Control") pr2(3) nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01)  compress nogaps

***********************************************************************************
**** Table A12: Robustness Analysis of Recall Reporting with Region Exclusions ****
***********************************************************************************


eststo clear
eststo: xi: dprobit report official foreign official_foreign log_recallsize airbag brake electrical engine powertrain steering i.province i.halfyear_id if province!="Beijing" | official_central == 1, cluster(recall_id)
eststo: xi: dprobit report official foreign official_foreign log_recallsize airbag brake electrical engine powertrain steering i.province i.halfyear_id if province!="Guangdong", cluster(recall_id)
eststo: xi: dprobit report official foreign official_foreign log_recallsize airbag brake electrical engine powertrain steering i.province i.halfyear_id if province!="Hubei", cluster(recall_id)
eststo: xi: dprobit report official foreign official_foreign log_recallsize airbag brake electrical engine powertrain steering i.province i.halfyear_id if province!="Shanghai", cluster(recall_id)	
eststo: xi: dprobit report official foreign official_foreign log_recallsize airbag brake electrical engine powertrain steering i.province i.halfyear_id if province!="Sichuan", cluster(recall_id)		
	
esttab using "TableA12_1.tex", booktabs margin label keep (official foreign official_foreign) order (foreign official official_foreign) mtitles ("Beijing" "Guangdong" "Hubei" "Shanghai" "Sichuan") pr2(3) nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps nonotes
 
eststo clear
eststo: xi: dprobit report official_central official_regional foreign official_central_foreign official_regional_foreign  log_recallsize airbag brake electrical engine powertrain steering i.province i.halfyear_id if province!="Beijing" | official_central == 1, cluster(recall_id)
eststo: xi: dprobit report official_central official_regional foreign official_central_foreign official_regional_foreign  log_recallsize airbag brake electrical engine powertrain steering i.province i.halfyear_id if province!="Guangdong", cluster(recall_id)
eststo: xi: dprobit report official_central official_regional foreign official_central_foreign official_regional_foreign  log_recallsize airbag brake electrical engine powertrain steering i.province i.halfyear_id if province!="Hubei", cluster(recall_id)
eststo: xi: dprobit report official_central official_regional foreign official_central_foreign official_regional_foreign  log_recallsize airbag brake electrical engine powertrain steering i.province i.halfyear_id if province!="Shanghai", cluster(recall_id)
eststo: xi: dprobit report official_central official_regional foreign official_central_foreign official_regional_foreign  log_recallsize airbag brake electrical engine powertrain steering i.province i.halfyear_id if province!="Sichuan", cluster(recall_id)

esttab using "TableA12_2.tex", booktabs margin label keep (official_central official_regional foreign official_central_foreign official_regional_foreign) order (foreign official_central official_regional official_central_foreign official_regional_foreign) mtitles ("Beijing" "Guangdong" "Hubei" "Shanghai" "Sichuan") pr2(3) nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps nonotes
 
eststo clear
eststo: xi: dprobit report official_auto_soe official_non_auto_soe foreign official_auto_soe_f official_non_auto_soe_f log_recallsize airbag brake electrical engine powertrain steering  log_gdp pop fdi log_advertising cars log_retail_auto log_passengercars i.province i.halfyear_id if official_central == 0 & province!="Beijing", cluster(recall_id)
eststo: xi: dprobit report official_auto_soe official_non_auto_soe foreign official_auto_soe_f official_non_auto_soe_f log_recallsize airbag brake electrical engine powertrain steering  log_gdp pop fdi log_advertising cars log_retail_auto log_passengercars i.province i.halfyear_id if official_central == 0 & province!="Guangdong", cluster(recall_id)
eststo: xi: dprobit report official_auto_soe official_non_auto_soe foreign official_auto_soe_f official_non_auto_soe_f log_recallsize airbag brake electrical engine powertrain steering  log_gdp pop fdi log_advertising cars log_retail_auto log_passengercars i.province i.halfyear_id if official_central == 0 & province!="Hubei", cluster(recall_id)
eststo: xi: dprobit report official_auto_soe official_non_auto_soe foreign official_auto_soe_f official_non_auto_soe_f log_recallsize airbag brake electrical engine powertrain steering  log_gdp pop fdi log_advertising cars log_retail_auto log_passengercars i.province i.halfyear_id if official_central == 0 & province!="Shanghai", cluster(recall_id)
eststo: xi: dprobit report official_auto_soe official_non_auto_soe foreign official_auto_soe_f official_non_auto_soe_f log_recallsize airbag brake electrical engine powertrain steering  log_gdp pop fdi log_advertising cars log_retail_auto log_passengercars i.province i.halfyear_id if official_central == 0 & province!="Sichuan", cluster(recall_id)

esttab using "TableA12_3.tex", booktabs margin label keep (foreign official_auto_soe official_non_auto_soe official_auto_soe_f official_non_auto_soe_f) order (foreign official_auto_soe official_non_auto_soe official_auto_soe_f official_non_auto_soe_f) mtitles ("Beijing" "Guangdong" "Hubei" "Shanghai" "Sichuan") pr2(3) nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01)  compress nogaps   

************************************************************************************
**** Table A13: Robustness Analysis of Recall Reporting with Country Exclusions ****
************************************************************************************

eststo clear
eststo: xi: dprobit report official foreign official_foreign log_recallsize airbag brake electrical engine powertrain steering i.province i.halfyear_id if france == 0, cluster(recall_id)
eststo: xi: dprobit report official foreign official_foreign log_recallsize airbag brake electrical engine powertrain steering i.province i.halfyear_id if germany == 0, cluster(recall_id)
eststo: xi: dprobit report official foreign official_foreign log_recallsize airbag brake electrical engine powertrain steering i.province i.halfyear_id if japan == 0, cluster(recall_id)
eststo: xi: dprobit report official foreign official_foreign log_recallsize airbag brake electrical engine powertrain steering i.province i.halfyear_id if uk == 0, cluster(recall_id)
eststo: xi: dprobit report official foreign official_foreign log_recallsize airbag brake electrical engine powertrain steering i.province i.halfyear_id if us == 0, cluster(recall_id)

esttab using "TableA13_1.tex", booktabs margin label keep (official foreign official_foreign) order (foreign official official_foreign) mtitles ("France" "Germany" "Japan" "UK" "US") pr2(3) nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps nonotes
 
eststo clear
eststo: xi: dprobit report official_central official_regional foreign official_central_foreign official_regional_foreign  log_recallsize  airbag brake electrical engine powertrain steering i.province i.halfyear_id if france == 0, cluster(recall_id)
eststo: xi: dprobit report official_central official_regional foreign official_central_foreign official_regional_foreign  log_recallsize  airbag brake electrical engine powertrain steering i.province i.halfyear_id if germany == 0, cluster(recall_id)
eststo: xi: dprobit report official_central official_regional foreign official_central_foreign official_regional_foreign  log_recallsize  airbag brake electrical engine powertrain steering i.province i.halfyear_id if japan == 0, cluster(recall_id)
eststo: xi: dprobit report official_central official_regional foreign official_central_foreign official_regional_foreign  log_recallsize  airbag brake electrical engine powertrain steering i.province i.halfyear_id if uk == 0, cluster(recall_id)
eststo: xi: dprobit report official_central official_regional foreign official_central_foreign official_regional_foreign  log_recallsize  airbag brake electrical engine powertrain steering i.province i.halfyear_id if us == 0, cluster(recall_id)

esttab using "TableA13_2.tex", booktabs margin label keep (official_central official_regional foreign official_central_foreign official_regional_foreign) order (foreign official_central official_regional official_central_foreign official_regional_foreign) mtitles ("France" "Germany" "Japan" "UK" "US") pr2(3) nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps nonotes
 
eststo clear
eststo: xi: dprobit report official_auto_soe official_non_auto_soe foreign official_auto_soe_f official_non_auto_soe_f log_recallsize airbag brake electrical engine powertrain steering log_gdp pop fdi log_advertising cars log_retail_auto log_passengercars i.province i.halfyear_id if official_central == 0 & france ==0, cluster(recall_id)
eststo: xi: dprobit report official_auto_soe official_non_auto_soe foreign official_auto_soe_f official_non_auto_soe_f log_recallsize airbag brake electrical engine powertrain steering log_gdp pop fdi log_advertising cars log_retail_auto log_passengercars i.province i.halfyear_id if official_central == 0 & germany == 0, cluster(recall_id)
eststo: xi: dprobit report official_auto_soe official_non_auto_soe foreign official_auto_soe_f official_non_auto_soe_f log_recallsize airbag brake electrical engine powertrain steering log_gdp pop fdi log_advertising cars log_retail_auto log_passengercars i.province i.halfyear_id if official_central == 0 & japan == 0, cluster(recall_id)
eststo: xi: dprobit report official_auto_soe official_non_auto_soe foreign official_auto_soe_f official_non_auto_soe_f log_recallsize airbag brake electrical engine powertrain steering log_gdp pop fdi log_advertising cars log_retail_auto log_passengercars i.province i.halfyear_id if official_central == 0 & uk == 0, cluster(recall_id)
eststo: xi: dprobit report official_auto_soe official_non_auto_soe foreign official_auto_soe_f official_non_auto_soe_f log_recallsize airbag brake electrical engine powertrain steering log_gdp pop fdi log_advertising cars log_retail_auto log_passengercars i.province i.halfyear_id if official_central == 0 & us == 0, cluster(recall_id)

esttab using "TableA13_3.tex", booktabs margin label keep (foreign official_auto_soe official_non_auto_soe official_auto_soe_f official_non_auto_soe_f) order (foreign official_auto_soe official_non_auto_soe official_auto_soe_f official_non_auto_soe_f) mtitles ("France" "Germany" "Japan" "UK" "US") pr2(3) nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps 

**************************************************************************************
**** Table A14: Robustness Analysis of Recall Reporting with Newspaper Exclusions ****
**************************************************************************************

eststo clear
eststo: xi: dprobit report foreign official official_foreign log_recallsize airbag brake electrical engine powertrain steering  i.province i.halfyear_id if newspaper != "China Youth Daily", cluster(recall_id)
eststo: xi: dprobit report foreign official official_foreign log_recallsize airbag brake electrical engine powertrain steering  i.province i.halfyear_id if newspaper != "Economic Daily", cluster(recall_id)
eststo: xi: dprobit report foreign official official_foreign log_recallsize airbag brake electrical engine powertrain steering  i.province i.halfyear_id if newspaper != "Guangming Daily", cluster(recall_id)
eststo: xi: dprobit report foreign official official_foreign log_recallsize airbag brake electrical engine powertrain steering  i.province i.halfyear_id if newspaper != "Legal Daily", cluster(recall_id)
eststo: xi: dprobit report foreign official official_foreign log_recallsize airbag brake electrical engine powertrain steering  i.province i.halfyear_id if newspaper != "People's Daily", cluster(recall_id)
eststo: xi: dprobit report foreign official official_foreign log_recallsize airbag brake electrical engine powertrain steering  i.province i.halfyear_id if newspaper != "Xinhua News Daily", cluster(recall_id)

esttab using "TableA14_1.tex", booktabs margin label keep (official foreign official_foreign) order (official foreign official_foreign) nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps 
   
eststo clear
eststo: xi: dprobit report official_central official_regional foreign official_central_foreign official_regional_foreign log_recallsize airbag brake electrical engine powertrain steering  i.province i.halfyear_id if newspaper != "China Youth Daily", cluster(recall_id)
eststo: xi: dprobit report official_central official_regional foreign official_central_foreign official_regional_foreign log_recallsize airbag brake electrical engine powertrain steering  i.province i.halfyear_id if newspaper != "Economic Daily", cluster(recall_id)
eststo: xi: dprobit report official_central official_regional foreign official_central_foreign official_regional_foreign log_recallsize airbag brake electrical engine powertrain steering  i.province i.halfyear_id if newspaper != "Guangming Daily", cluster(recall_id)
eststo: xi: dprobit report official_central official_regional foreign official_central_foreign official_regional_foreign log_recallsize airbag brake electrical engine powertrain steering  i.province i.halfyear_id if newspaper != "Legal Daily", cluster(recall_id)
eststo: xi: dprobit report official_central official_regional foreign official_central_foreign official_regional_foreign log_recallsize airbag brake electrical engine powertrain steering  i.province i.halfyear_id if newspaper != "People's Daily", cluster(recall_id)
eststo: xi: dprobit report official_central official_regional foreign official_central_foreign official_regional_foreign log_recallsize airbag brake electrical engine powertrain steering  i.province i.halfyear_id if newspaper != "Xinhua News Daily", cluster(recall_id)

esttab using "TableA14_2.tex", booktabs margin label keep (official_central official_regional foreign official_central_foreign official_regional_foreign) order (foreign official_central official_regional official_central_foreign official_regional_foreign) nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps   

***************************************
**** Table A15: Two-way Clustering **** /* One should run probit2.ado (available at http://www.kellogg.northwestern.edu/faculty/petersen/htm/papers/se/probit2.ado) file before running the below lines */ 
***************************************

* Model (1) 

xi: dprobit report foreign official official_foreign log_recallsize airbag brake electrical engine powertrain steering i.province i.halfyear_id /* estimating marginal effects and standard errors (not-clustered) */
mat model1_full_df = e(dfdx)
mat model1_selected_df = model1_full_df[1,1..3]

xi: probit2 report foreign official official_foreign log_recallsize airbag brake electrical engine powertrain steering i.province i.halfyear_id, fcluster(province_id) tcluster(recall_id) /* estimating two-way clustered models */
mat model1_full_b = e(b)
mat model1_full_V = e(V)

scalar z1_foreign = model1_full_b[1,1]/sqrt(model1_full_V[1,1])
scalar z1_official = model1_full_b[1,2]/sqrt(model1_full_V[2,2])
scalar z1_official_foreign = model1_full_b[1,3]/sqrt(model1_full_V[3,3])

scalar se_1_foreign = model1_selected_df[1,1]/z1_foreign /* calculating clustered standard errors for marginal effects */
scalar se_1_official = model1_selected_df[1,2]/z1_official
scalar se_1_official_foreign = model1_selected_df[1,3]/z1_official_foreign


* Model (2)

xi: dprobit report foreign official_central official_regional official_central_foreign official_regional_foreign  log_recallsize  airbag brake electrical engine powertrain steering i.province i.halfyear_id, cluster(newspaper_id) /* estimating marginal effects and standard errors (not-clustered) */
mat model2_full_df = e(dfdx)
mat model2_selected_df = model2_full_df[1,1..5]

xi: probit2 report foreign official_central official_regional official_central_foreign official_regional_foreign  log_recallsize  airbag brake electrical engine powertrain steering i.province i.halfyear_id, fcluster(province_id) tcluster(recall_id) /* estimating two-way clustered models */
mat model2_full_b = e(b)
mat model2_full_V = e(V)

scalar z2_foreign = model2_full_b[1,1]/sqrt(model2_full_V[1,1])
scalar z2_official_central = model2_full_b[1,2]/sqrt(model2_full_V[2,2])
scalar z2_official_regional = model2_full_b[1,3]/sqrt(model2_full_V[3,3])
scalar z2_official_central_foreign = model2_full_b[1,4]/sqrt(model2_full_V[4,4])
scalar z2_official_regional_foreign = model2_full_b[1,5]/sqrt(model2_full_V[5,5])

scalar se_2_foreign = model2_selected_df[1,1]/z2_foreign /* calculating clustered standard errors for marginal effects */
scalar se_2_official_central = model2_selected_df[1,2]/z2_official_central
scalar se_2_official_regional = model2_selected_df[1,3]/z2_official_regional
scalar se_2_official_central_foreign = model2_selected_df[1,3]/z2_official_central_foreign
scalar se_2_official_regional_foreign = model2_selected_df[1,3]/z2_official_regional_foreign

* Model (3)

xi: dprobit report foreign official_auto_soe official_non_auto_soe official_auto_soe_f official_non_auto_soe_f log_recallsize airbag brake electrical engine powertrain steering  log_gdp pop fdi log_advertising cars log_retail_auto log_passengercars i.province i.halfyear_id if official_central == 0 /* estimating marginal effects and standard errors (not-clustered) */
mat model3_full_df = e(dfdx)
mat model3_selected_df = model3_full_df[1,1..5]

xi: probit2 report foreign official_auto_soe official_non_auto_soe official_auto_soe_f official_non_auto_soe_f log_recallsize airbag brake electrical engine powertrain steering  log_gdp pop fdi log_advertising cars log_retail_auto log_passengercars i.province i.halfyear_id if official_central == 0, fcluster(province_id) tcluster(recall_id) /* estimating two-way clustered models */
mat model3_full_b = e(b)
mat model3_full_V = e(V)

scalar z3_foreign = model3_full_b[1,1]/sqrt(model3_full_V[1,1])
scalar z3_official_auto_soe = model3_full_b[1,2]/sqrt(model3_full_V[2,2])
scalar z3_official_non_auto_soe = model3_full_b[1,3]/sqrt(model3_full_V[3,3])
scalar z3_official_auto_soe_f = model3_full_b[1,4]/sqrt(model3_full_V[4,4])
scalar z3_official_non_auto_soe_f = model3_full_b[1,5]/sqrt(model3_full_V[5,5])

scalar se_3_foreign = model3_selected_df[1,1]/z3_foreign /* calculating clustered standard errors for marginal effects */
scalar se_3_official_auto_soe = model3_selected_df[1,2]/z3_official_auto_soe
scalar se_3_official_non_auto_soe = model3_selected_df[1,3]/z3_official_non_auto_soe
scalar se_3_official_auto_soe_f = model3_selected_df[1,4]/z3_official_auto_soe_f
scalar se_3_official_non_auto_soe_f = model3_selected_df[1,5]/z3_official_non_auto_soe_f

scalar list
 

************************************************************
**** Table A16: Different Coding of Official Newspapers **** 
************************************************************

gen official_semi = 0 
replace official_semi = 1 if newspaper_type == "Official" | newspaper_type == "Semi-official"
label var official_semi "Official"

gen official_semi_regional = 0 
replace official_semi_regional = 1 if official_central == 0 & (newspaper_type == "Official" | newspaper_type == "Semi-official") 
label var official_semi_regional "Regional Party Official"

gen official_semi_f = official_semi * foreign
label var official_semi_f "Official * Foreign"

gen official_semi_regional_f = official_semi_regional * foreign
label var official_semi_regional_f "Regional Party Official * Foreign"

gen official_semi_auto_soe = 0
replace official_semi_auto_soe = 1 if official_semi == 1 & auto_soe_province == 1
label var official_semi_auto_soe "Officials with Auto"

gen official_semi_non_auto_soe = 0
replace official_semi_non_auto_soe = 1 if official_semi == 1 & auto_soe_province == 0
label var official_semi_non_auto_soe "Officials without Auto"

gen official_semi_auto_soe_f = official_semi_auto_soe * foreign
label var official_semi_auto_soe_f "Officials with Auto * Foreign"

gen official_semi_non_auto_soe_f = official_semi_non_auto_soe * foreign
label var official_semi_non_auto_soe_f "Officials without Auto * Foreign"

eststo clear
eststo: xi: dprobit report official_semi foreign official_semi_f log_recallsize  airbag brake electrical engine powertrain steering i.province i.halfyear_id, cluster(recall_id)
esttab using "TableA16_1.tex", booktabs margin label keep (official_semi foreign official_semi_f) order (foreign official_semi official_semi_f) mtitles ("") pr2(3) nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps nonotes

eststo clear
eststo: xi: dprobit report official_central official_semi_regional foreign official_central_foreign official_semi_regional_f log_recallsize airbag brake electrical engine powertrain steering  i.province i.halfyear_id, cluster(recall_id)
esttab using "TableA16_2.tex", booktabs margin label keep (foreign official_central official_semi_regional official_central_foreign official_semi_regional_f) order (foreign official_central official_semi_regional official_central_foreign official_semi_regional_f) mtitles ("") pr2(3) nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps nonotes

eststo clear
eststo: xi: dprobit report official_semi_auto_soe official_semi_non_auto_soe foreign official_semi_auto_soe_f official_semi_non_auto_soe_f log_recallsize airbag brake electrical engine powertrain steering  log_gdp pop fdi log_advertising cars log_retail_auto log_passengercars i.province i.halfyear_id if official_central == 0, cluster(recall_id)
esttab using "TableA16_3.tex", booktabs margin label keep (foreign official_semi_auto_soe official_semi_non_auto_soe official_semi_auto_soe_f official_semi_non_auto_soe_f) order (foreign official_semi_auto_soe official_semi_non_auto_soe official_semi_auto_soe_f official_semi_non_auto_soe_f) mtitles ("") pr2(3) nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps nonotes

**************************************************************************
**** Table A17: Distinguishing Joint Venture from Domestic Automakers ****
**************************************************************************

eststo clear

eststo: xi: dprobit report foreign joint official official_foreign official_joint log_recallsize airbag brake electrical engine powertrain steering, cluster(recall_id) 
eststo: xi: dprobit report foreign joint official official_foreign official_joint log_recallsize airbag brake electrical engine powertrain steering i.province i.halfyear_id, cluster(recall_id)

eststo: xi: dprobit report foreign joint official official_foreign official_joint log_recallsize airbag brake electrical engine powertrain steering if auto_soe_province == 1 & official_central == 0, cluster(recall_id)
eststo: xi: dprobit report foreign joint official official_foreign official_joint log_recallsize airbag brake electrical engine powertrain steering i.province i.halfyear_id if auto_soe_province == 1 & official_central == 0, cluster(recall_id)

eststo: xi: dprobit report foreign joint official official_foreign official_joint log_recallsize airbag brake electrical engine powertrain steering if auto_soe_province == 0 & official_central == 0, cluster(recall_id)
eststo: xi: dprobit report foreign joint official official_foreign official_joint log_recallsize airbag brake electrical engine powertrain steering i.province i.halfyear_id if auto_soe_province == 0 & official_central == 0, cluster(recall_id)

esttab using "TableA17.tex", booktabs margin label keep (foreign joint official official_foreign official_joint) order (foreign joint official official_foreign official_joint) mtitles ("" "" "" "" "" "") nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps indicate ("Province FE = *province*" "Halfyear FE = *half*")
 
******************************************************************
**** Table A19: WTO Dispute and News Coverage of Auto Recalls ****
******************************************************************

eststo clear 

eststo: dprobit report official foreign log_recallsize airbag brake electrical engine powertrain steering if after_dispute == 0, cluster(recall_id)
eststo: dprobit report official foreign official_foreign log_recallsize airbag brake electrical engine powertrain steering if after_dispute == 0, cluster(recall_id)
eststo: xi: dprobit report official foreign official_foreign log_recallsize airbag brake electrical engine powertrain steering i.province_id i.halfyear_id if after_dispute == 0, cluster(recall_id)
eststo: xi: dprobit report official foreign official_foreign log_recallsize airbag brake electrical engine powertrain steering i.newspaper_id i.recall_id if after_dispute == 0, cluster(recall_id)

eststo: dprobit report official foreign log_recallsize airbag brake electrical engine powertrain steering if after_dispute == 1, cluster(recall_id)
eststo: dprobit report official foreign official_foreign log_recallsize airbag brake electrical engine powertrain steering if after_dispute == 1, cluster(recall_id)
eststo: xi: dprobit report official foreign official_foreign log_recallsize airbag brake electrical engine powertrain steering i.province_id i.halfyear_id if after_dispute == 1, cluster(recall_id)
eststo: xi: dprobit report official foreign official_foreign log_recallsize airbag brake electrical engine powertrain steering i.newspaper_id i.recall_id if after_dispute == 1, cluster(recall_id)

esttab using "TableA19.tex", booktabs margin label keep (official official_foreign foreign log_recallsize airbag brake electrical engine powertrain steering) order (foreign official official_foreign log_recallsize airbag brake electrical engine powertrain steering) nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps indicate ("Province FE = *province*" "Newspaper FE = *newspaper*" "Halfyear FE = *half*" "Recall FE = *recall_id*")

****************************************************************************************
**** Table A20: WTO Dispute and News Coverage of Auto Recalls, Central vs. Regional ****
****************************************************************************************

eststo clear

eststo: xi: dprobit report official_central official_regional foreign log_recallsize airbag brake electrical engine powertrain steering if after_dispute == 0, cluster(recall_id)
eststo: xi: dprobit report official_central official_regional foreign official_central_foreign official_regional_foreign log_recallsize airbag brake electrical engine powertrain steering if after_dispute == 0, cluster(recall_id)
eststo: xi: dprobit report official_central official_regional foreign official_central_foreign official_regional_foreign log_recallsize airbag brake electrical engine powertrain steering i.province_id i.halfyear_id if after_dispute == 0, cluster(recall_id)
eststo: xi: dprobit report official_central official_regional foreign official_central_foreign official_regional_foreign log_recallsize airbag brake electrical engine powertrain steering i.newspaper_id i.recall_id if after_dispute == 0, cluster(recall_id)

eststo: xi: dprobit report official_central official_regional foreign log_recallsize airbag brake electrical engine powertrain steering if after_dispute == 1, cluster(recall_id)
eststo: xi: dprobit report official_central official_regional foreign official_central_foreign official_regional_foreign log_recallsize airbag brake electrical engine powertrain steering if after_dispute == 1, cluster(recall_id)
eststo: xi: dprobit report official_central official_regional foreign official_central_foreign official_regional_foreign log_recallsize airbag brake electrical engine powertrain steering i.province_id i.halfyear_id if after_dispute == 1, cluster(recall_id)
eststo: xi: dprobit report official_central official_regional foreign official_central_foreign official_regional_foreign log_recallsize airbag brake electrical engine powertrain steering i.newspaper_id i.recall_id if after_dispute == 1, cluster(recall_id)

esttab using "TableA20.tex", booktabs margin label keep (official_central official_regional foreign official_central_foreign official_regional_foreign log_recallsize airbag brake electrical engine powertrain steering) order (foreign official_central official_central_foreign official_regional official_regional_foreign log_recallsize airbag brake electrical engine powertrain steering) mtitles ("" "" "" "" "" "" "" "") nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps indicate ("Province FE = *province*" "Newspaper FE = *newspaper*" "Halfyear FE = *half*" "Recall FE = *recall_id*")
 
****************************************************************************************
**** Table A21: WTO Dispute and News Coverage of Auto Recalls, By Auto SOE Ownership ***
****************************************************************************************
 
eststo clear

eststo: xi: dprobit report official_auto_soe official_non_auto_soe foreign official_auto_soe_f official_non_auto_soe_f log_recallsize airbag brake electrical engine powertrain steering log_gdp pop fdi i.province i.halfyear_id  if official_central == 0 & after_dispute == 0, cluster(recall_id)
eststo: xi: dprobit report official_auto_soe official_non_auto_soe foreign official_auto_soe_f official_non_auto_soe_f log_recallsize airbag brake electrical engine powertrain steering log_gdp pop fdi log_advertising i.province i.halfyear_id  if official_central == 0 & after_dispute == 0, cluster(recall_id)
eststo: xi: dprobit report official_auto_soe official_non_auto_soe foreign official_auto_soe_f official_non_auto_soe_f log_recallsize airbag brake electrical engine powertrain steering log_gdp pop fdi log_advertising cars log_retail_auto log_passengercars i.province i.halfyear_id   if official_central == 0 & after_dispute == 0, cluster(recall_id)
eststo: xi: dprobit report official_auto_soe official_non_auto_soe foreign official_auto_soe_f official_non_auto_soe_f log_recallsize airbag brake electrical engine powertrain steering log_gdp pop fdi log_advertising cars log_retail_auto log_passengercars i.newspaper_id i.recall_id   if official_central == 0 & after_dispute == 0, cluster(recall_id)

eststo: xi: dprobit report official_auto_soe official_non_auto_soe foreign official_auto_soe_f official_non_auto_soe_f log_recallsize airbag brake electrical engine powertrain steering log_gdp pop fdi i.province i.halfyear_id  if official_central == 0 & after_dispute == 1, cluster(recall_id)
eststo: xi: dprobit report official_auto_soe official_non_auto_soe foreign official_auto_soe_f official_non_auto_soe_f log_recallsize airbag brake electrical engine powertrain steering log_gdp pop fdi log_advertising i.province i.halfyear_id  if official_central == 0 & after_dispute == 1, cluster(recall_id)
eststo: xi: dprobit report official_auto_soe official_non_auto_soe foreign official_auto_soe_f official_non_auto_soe_f log_recallsize airbag brake electrical engine powertrain steering log_gdp pop fdi log_advertising cars log_retail_auto log_passengercars i.province i.halfyear_id   if official_central == 0 & after_dispute == 1, cluster(recall_id)
eststo: xi: dprobit report official_auto_soe official_non_auto_soe foreign official_auto_soe_f official_non_auto_soe_f log_recallsize airbag brake electrical engine powertrain steering log_gdp pop fdi log_advertising cars log_retail_auto log_passengercars i.newspaper_id i.recall_id   if official_central == 0 & after_dispute == 1, cluster(recall_id)

esttab using "TableA21.tex", booktabs margin label keep (official_auto_soe official_non_auto_soe foreign official_auto_soe_f official_non_auto_soe_f log_recallsize airbag brake electrical engine powertrain steering log_gdp pop fdi log_advertising cars log_retail_auto log_passengercars ) order (foreign official_auto_soe official_non_auto_soe official_auto_soe_f official_non_auto_soe_f log_recallsize airbag brake electrical engine powertrain steering log_gdp pop fdi log_advertising cars log_retail_auto log_passengercars ) mtitles ("" "" "" "" "" "" "" "") nodepvars se(3) b(3) replace star(+ 0.10 * 0.05 ** 0.01) compress nogaps indicate ("Province FE = *province*" "Newspaper FE = *newspaper*" "Halfyear FE = *half*" "Recall FE = *recall_id*")
