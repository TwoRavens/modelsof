clear
set more off

if regexm(c(os),"Mac") == 1 {
	cd "~/Dropbox/Corporate Returns to Campaign Contributions/JOP/qpq_replication"
	}
	else if regexm(c(os),"Windows") == 1 {
	cd "~\Dropbox\Corporate Returns to Campaign Contributions\JOP/qpq_replication"
}

********************************************************************************
********************* APPENDIX TABLE A.1: SELECTION  ***************************
********************************************************************************

use "qpq_main_dataset", clear

****** Money Donated by Firm to Candidate in Race *******

g totaldollars_cand       = totalrep
replace totaldollars_cand = totaldem if dem==1
g logdollars_cand         = log(totaldollars_cand)

* Full Sample
su logdollars_cand if victory == 0 
su logdollars_cand if victory == 1
reghdfe logdollars_cand victory, absorb(constant) vce(cluster cycle)

************ Supporting Incumbent ********************

* Incumbent and Challenger dummy
g incumbent = dem == 1 & deminc == 1
replace incumbent = 1 if dem == 0 & repinc == 1
g challenger = dem == 1 & repinc == 1
replace challenger = 1 if dem == 0 & deminc == 1
* Include contenders to open seat as challengers too
replace challenger = 1 if deminc == 0 & repinc == 0

* Full Sample
su incumbent if victory == 0
su incumbent if victory == 1      
reghdfe incumbent victory, absorb(constant) vce(cluster cycle)

****** Market Value of the Company in Year Before the Election *******

g marketvalue_lag = market_cap_lag*1000000
g logmv_lag = log(marketvalue_lag)

* Full Sample
su logmv_lag if victory == 0
su logmv_lag if victory == 1   
reghdfe logmv_lag victory, absorb(constant) vce(cluster cycle)

****** ROA (Return on Assets) of the Company in Year Before Election *******

* Return on Assets: Net Income over Total Assets

g roa_lag = ni_lag/at_lag
replace roa_lag = roa_lag*100

preserve
* Remove outlier observations
keep if abs(roa_lag) < 100

* Full Sample
su roa_lag if victory == 0
su roa_lag if victory == 1
reghdfe roa_lag victory, absorb(constant) vce(cluster cycle)

restore

****** Earnings of the Company the Year Before the Election *******

g log_ni_lag = log(ni_lag*1000000)

* Full Sample
su log_ni_lag if victory == 0
su log_ni_lag if victory == 1
reghdfe log_ni_lag victory, absorb(constant) vce(cluster cycle)

****** P/E: Price of Share over Earnings per Share of the Company the Year Before the Election *******

* First, calculate Earnings per Share (both earnings and number of common
* shares are in millions of units, thus no need to transform to calculate 
* the ratio)

g e_per_s_lag = ni_lag/csho_lag

* Then, calculate price over earnings per share. 

g p_e_lag = prcc_f_lag/e_per_s_lag

* Remove outliers. P/E can be huge when earnings are very small

preserve

keep if p_e_lag < 200
* Keep only observations with positive earnings
keep if ni_lag > 0

* Full Sample
su p_e_lag if victory == 0
su p_e_lag if victory == 1       
reghdfe p_e_lag victory, absorb(constant) vce(cluster cycle)

restore

****** Number of Other Candidates Supported by Firm in Cycle *******

egen totalcandidates = sum(constant), by(firm_cycle)
replace totalcandidates = totalcandidates - 1

* Full Sample
su totalcandidates if victory == 0
su totalcandidates if victory == 1
reghdfe totalcandidates victory, absorb(constant) vce(cluster cycle)

****** Fraction of Winners Supported By Firm in Cycle *******

egen otherwinners = sum(victory), by(firm_cycle)
replace otherwinners = otherwinners - victory

* The totalcandidates variable already disregards own observation (see above)
gen fracwinners = otherwinners/totalcandidates

* Full Sample
su fracwinners if victory == 0  
su fracwinners if victory == 1
reghdfe fracwinners victory, absorb(constant) vce(cluster cycle)

**************** CAR(-7, -1) ***********************

* Full Sample
replace CAR_minus7_minus1 = CAR_minus7_minus1 - 1

su CAR_minus7_minus1 if victory == 0
su CAR_minus7_minus1 if victory == 1       
reghdfe CAR_minus7_minus1 victory, absorb(constant) vce(cluster cycle)


********************************************************************************
*************** APPENDIX TABLE A.2: BALANCE TESTS, RD SAMPLE *******************
********************************************************************************

use "qpq_main_dataset", clear

egen totalcandidates = sum(constant), by(firm_cycle)
replace totalcandidates = totalcandidates - 1

egen otherwinners = sum(victory), by(firm_cycle)
replace otherwinners = otherwinners - victory

gen fracwinners = otherwinners/totalcandidates

* Close Elections Sample
drop if abs(rv)>0.05 

****** Money Donated by Firm to Candidate in Race *******

g totaldollars_cand       = totalrep
replace totaldollars_cand = totaldem if dem==1
g logdollars_cand         = log(totaldollars_cand)
    
reghdfe logdollars_cand victory rv rv_victory, absorb(constant) vce(cluster cycle)

************ Supporting Incumbent ********************

* Incumbent and Challenger dummy
g incumbent = dem == 1 & deminc == 1
replace incumbent = 1 if dem == 0 & repinc == 1
g challenger = dem == 1 & repinc == 1
replace challenger = 1 if dem == 0 & deminc == 1
* Include contenders to open seat as challengers too
replace challenger = 1 if deminc == 0 & repinc == 0
 
reghdfe incumbent victory rv rv_victory, absorb(constant) vce(cluster cycle)

****** Market Value of the Company in Year Before Election *******
g marketvalue_lag = market_cap_lag*1000000
g logmv_lag = log(marketvalue_lag)
    
reghdfe logmv_lag victory rv rv_victory, absorb(constant) vce(cluster cycle)

****** ROA (Return on Assets) of the Company in Year Before Election *******

* Return on Assets: Net Income over Total Assets

g roa_lag = ni_lag/at_lag
replace roa_lag = roa_lag*100

preserve
* Remove outlier observations
keep if abs(roa_lag) < 100
    
reghdfe roa_lag victory rv rv_victory, absorb(constant) vce(cluster cycle)

restore

****** Earnings of the Company the Year Before the Election *******
g log_ni_lag = log(ni_lag*1000000)

reghdfe log_ni_lag victory rv rv_victory, absorb(constant) vce(cluster cycle)

****** P/E: Price of Share over Earnings per Share of the Company the Year Before the Election *******

* First, calculate Earnings per Share (both earnings and number of common
* shares are in millions of units, thus no need to transform to calculate 
* the ratio)

g e_per_s_lag = ni_lag/csho_lag

* Then, calculate price over earnings per share. 

g p_e_lag = prcc_f_lag/e_per_s_lag

* Remove outliers. P/E can be huge when earnings are very small

preserve

keep if p_e_lag < 200
* Keep only observations with positive earnings
keep if ni_lag > 0
    
reghdfe p_e_lag victory rv rv_victory, absorb(constant) vce(cluster cycle)

restore

****** Number of Other Candidates Supported By Firm in Cycle *******
reghdfe totalcandidates victory rv rv_victory, absorb(constant) vce(cluster cycle)

****** Fraction of Winners Supported by Firm in Cycle *******
reghdfe fracwinners victory rv rv_victory, absorb(constant) vce(cluster cycle)

**************** CAR(-7, -1) ***********************
replace CAR_minus7_minus1 = CAR_minus7_minus1 - 1
    
reghdfe CAR_minus7_minus1 victory rv rv_victory, absorb(constant) vce(cluster cycle)

********************************************************************************
************ APPENDIX TABLE A.3: RD ESTIMATES  *********************************
********************************************************************************

********************** PANEL A: CAR(-1, 1) *************************************

use "qpq_main_dataset", clear

*******************************************
* Close election threshold: 1 pp
*******************************************

preserve

drop if abs(rv) > 0.005

reghdfe CAR_minus1_1 victory, absorb(constant) vce(cluster cycle) /* Local constant */

reghdfe CAR_minus1_1 victory rv rv_victory, absorb(constant) vce(cluster cycle) /* Local linear */

gen rv_2     = rv^2
gen rv_vic_2 = rv_2*victory
reghdfe CAR_minus1_1 victory rv rv_victory rv_2 rv_vic_2, absorb(constant) vce(cluster cycle) /* Quadratic */

gen rv_3     = rv^3
gen rv_vic_3 = rv_3*victory
reghdfe CAR_minus1_1 victory rv rv_victory rv_2 rv_vic_2 ///
rv_3 rv_vic_3, absorb(constant) vce(cluster cycle) /* Cubic */

restore


*******************************************
* Close election threshold: 2.5 pp
*******************************************

preserve

drop if abs(rv) > 0.0125

reghdfe CAR_minus1_1 victory, absorb(constant) vce(cluster cycle) /* Local constant */

reghdfe CAR_minus1_1 victory rv rv_victory, absorb(constant) vce(cluster cycle) /* Local linear */

gen rv_2     = rv^2
gen rv_vic_2 = rv_2*victory
reghdfe CAR_minus1_1 victory rv rv_victory rv_2 rv_vic_2, absorb(constant) vce(cluster cycle) /* Quadratic */

gen rv_3     = rv^3
gen rv_vic_3 = rv_3*victory
reghdfe CAR_minus1_1 victory rv rv_victory rv_2 rv_vic_2 ///
rv_3 rv_vic_3, absorb(constant) vce(cluster cycle) /* Cubic */

restore

*******************************************
* Close election threshold: 5 pp
*******************************************

preserve

drop if abs(rv) > 0.025

reghdfe CAR_minus1_1 victory, absorb(constant) vce(cluster cycle) /* Local constant */

reghdfe CAR_minus1_1 victory rv rv_victory, absorb(constant) vce(cluster cycle) /* Local linear */

gen rv_2     = rv^2
gen rv_vic_2 = rv_2*victory
reghdfe CAR_minus1_1 victory rv rv_victory rv_2 rv_vic_2, absorb(constant) vce(cluster cycle) /* Quadratic */

gen rv_3     = rv^3
gen rv_vic_3 = rv_3*victory
reghdfe CAR_minus1_1 victory rv rv_victory rv_2 rv_vic_2 ///
rv_3 rv_vic_3, absorb(constant) vce(cluster cycle) /* Cubic */

restore

*******************************************
* Close election threshold: 10 pp
*******************************************

preserve

drop if abs(rv) > 0.05

reghdfe CAR_minus1_1 victory, absorb(constant) vce(cluster cycle) /* Local constant */

reghdfe CAR_minus1_1 victory rv rv_victory, absorb(constant) vce(cluster cycle) /* Local linear */

gen rv_2     = rv^2
gen rv_vic_2 = rv_2*victory
reghdfe CAR_minus1_1 victory rv rv_victory rv_2 rv_vic_2, absorb(constant) vce(cluster cycle) /* Quadratic */

gen rv_3     = rv^3
gen rv_vic_3 = rv_3*victory
reghdfe CAR_minus1_1 victory rv rv_victory rv_2 rv_vic_2 ///
rv_3 rv_vic_3, absorb(constant) vce(cluster cycle) /* Cubic */

restore

*******************************************
* Imbens-Kalyanaraman optimal bandwidth
*******************************************

preserve 

rdob CAR_minus1_1 rv, c(0)

* h_opt: .0993

reghdfe CAR_minus1_1 victory if abs(rv) < .0993, absorb(constant) vce(cluster cycle) /* Local constant */

reghdfe CAR_minus1_1 victory rv rv_victory if abs(rv) < .0993, absorb(constant) vce(cluster cycle) /* Local linear */

gen rv_2     = rv^2
gen rv_vic_2 = rv_2*victory
reghdfe CAR_minus1_1 victory rv rv_victory rv_2 rv_vic_2 if abs(rv) < .0993, absorb(constant) vce(cluster cycle) /* Quadratic */

gen rv_3     = rv^3
gen rv_vic_3 = rv_3*victory
reghdfe CAR_minus1_1 victory rv rv_victory rv_2 rv_vic_2 ///
rv_3 rv_vic_3 if abs(rv) < .0993, absorb(constant) vce(cluster cycle) /* Cubic */

restore 

*******************************************
* Calonico, Cattaneo, and Titiunik (2014)
*******************************************

preserve 

rdbwselect CAR_minus1_1 rv, c(0) p(0) vce(cluster cycle)
local CCT_bw = `e(h_mserd)'

reghdfe CAR_minus1_1 victory if abs(rv) < `CCT_bw', absorb(constant) vce(cluster cycle) /* Local constant */

rdbwselect CAR_minus1_1 rv, c(0) p(1) vce(cluster cycle)
local CCT_bw = `e(h_mserd)'

reghdfe CAR_minus1_1 victory rv rv_victory if abs(rv) < `CCT_bw', absorb(constant) vce(cluster cycle) /* Local linear */

rdbwselect CAR_minus1_1 rv, c(0) p(2) vce(cluster cycle)
local CCT_bw = `e(h_mserd)'

gen rv_2     = rv^2
gen rv_vic_2 = rv_2*victory
reghdfe CAR_minus1_1 victory rv rv_victory rv_2 rv_vic_2 if abs(rv) < `CCT_bw', absorb(constant) vce(cluster cycle) /* Quadratic */

rdbwselect CAR_minus1_1 rv, c(0) p(3) vce(cluster cycle)
local CCT_bw = `e(h_mserd)'

gen rv_3     = rv^3
gen rv_vic_3 = rv_3*victory
reghdfe CAR_minus1_1 victory rv rv_victory rv_2 rv_vic_2 ///
rv_3 rv_vic_3 if abs(rv) < `CCT_bw', absorb(constant) vce(cluster cycle) /* Cubic */

restore 


********************** PANEL B: CAR(-1, 5) *************************************

*******************************************
* Close election threshold: 1 pp
*******************************************

preserve

drop if abs(rv) > 0.005

reghdfe CAR_minus1_5 victory, absorb(constant) vce(cluster cycle) /* Local constant */

reghdfe CAR_minus1_5 victory rv rv_victory, absorb(constant) vce(cluster cycle) /* Local linear */

gen rv_2     = rv^2
gen rv_vic_2 = rv_2*victory
reghdfe CAR_minus1_5 victory rv rv_victory rv_2 rv_vic_2, absorb(constant) vce(cluster cycle) /* Quadratic */

gen rv_3     = rv^3
gen rv_vic_3 = rv_3*victory
reghdfe CAR_minus1_5 victory rv rv_victory rv_2 rv_vic_2 ///
rv_3 rv_vic_3, absorb(constant) vce(cluster cycle) /* Cubic */

restore

*******************************************
* Close election threshold: 2.5 pp
*******************************************

preserve

drop if abs(rv) > 0.0125

reghdfe CAR_minus1_5 victory, absorb(constant) vce(cluster cycle) /* Local constant */


reghdfe CAR_minus1_5 victory rv rv_victory, absorb(constant) vce(cluster cycle) /* Local linear */

gen rv_2     = rv^2
gen rv_vic_2 = rv_2*victory
reghdfe CAR_minus1_5 victory rv rv_victory rv_2 rv_vic_2, absorb(constant) vce(cluster cycle) /* Quadratic */

gen rv_3     = rv^3
gen rv_vic_3 = rv_3*victory
reghdfe CAR_minus1_5 victory rv rv_victory rv_2 rv_vic_2 ///
rv_3 rv_vic_3, absorb(constant) vce(cluster cycle) /* Cubic */

restore

*******************************************
* Close election threshold: 5 pp
*******************************************

preserve

drop if abs(rv) > 0.025

reghdfe CAR_minus1_5 victory, absorb(constant) vce(cluster cycle) /* Local constant */

reghdfe CAR_minus1_5 victory rv rv_victory, absorb(constant) vce(cluster cycle) /* Local linear */

gen rv_2     = rv^2
gen rv_vic_2 = rv_2*victory
reghdfe CAR_minus1_5 victory rv rv_victory rv_2 rv_vic_2, absorb(constant) vce(cluster cycle) /* Quadratic */

gen rv_3     = rv^3
gen rv_vic_3 = rv_3*victory
reghdfe CAR_minus1_5 victory rv rv_victory rv_2 rv_vic_2 ///
rv_3 rv_vic_3, absorb(constant) vce(cluster cycle) /* Cubic */

restore

*******************************************
* Close election threshold: 10 pp
*******************************************

preserve

drop if abs(rv) > 0.05

reghdfe CAR_minus1_5 victory, absorb(constant) vce(cluster cycle) /* Local constant */

reghdfe CAR_minus1_5 victory rv rv_victory, absorb(constant) vce(cluster cycle) /* Local linear */

gen rv_2     = rv^2
gen rv_vic_2 = rv_2*victory
reghdfe CAR_minus1_5 victory rv rv_victory rv_2 rv_vic_2, absorb(constant) vce(cluster cycle) /* Quadratic */

gen rv_3     = rv^3
gen rv_vic_3 = rv_3*victory
reghdfe CAR_minus1_5 victory rv rv_victory rv_2 rv_vic_2 ///
rv_3 rv_vic_3, absorb(constant) vce(cluster cycle) /* Cubic */

restore

*******************************************
* Imbens-Kalyanaraman optimal bandwidth
*******************************************

preserve 

rdob CAR_minus1_5 rv, c(0)

* h_opt: .0924

reghdfe CAR_minus1_5 victory if abs(rv) < .0924, absorb(constant) vce(cluster cycle) /* Local constant */

reghdfe CAR_minus1_5 victory rv rv_victory if abs(rv) < .0924, absorb(constant) vce(cluster cycle) /* Local linear */

gen rv_2     = rv^2
gen rv_vic_2 = rv_2*victory
reghdfe CAR_minus1_5 victory rv rv_victory rv_2 rv_vic_2 if abs(rv) < .0924, absorb(constant) vce(cluster cycle) /* Quadratic */

gen rv_3     = rv^3
gen rv_vic_3 = rv_3*victory
reghdfe CAR_minus1_5 victory rv rv_victory rv_2 rv_vic_2 ///
rv_3 rv_vic_3 if abs(rv) < .0924, absorb(constant) vce(cluster cycle) /* Cubic */

restore

*******************************************
* Calonico, Cattaneo, and Titiunik (2014)
*******************************************

preserve 

rdbwselect CAR_minus1_5 rv, c(0) p(0) vce(cluster cycle)
local CCT_bw = `e(h_mserd)'

reghdfe CAR_minus1_5 victory if abs(rv) < `CCT_bw', absorb(constant) vce(cluster cycle) /* Local constant */

rdbwselect CAR_minus1_5 rv, c(0) p(1) vce(cluster cycle)
local CCT_bw = `e(h_mserd)'

reghdfe CAR_minus1_5 victory rv rv_victory if abs(rv) < `CCT_bw', absorb(constant) vce(cluster cycle) /* Local linear */

rdbwselect CAR_minus1_5 rv, c(0) p(2) vce(cluster cycle)
local CCT_bw = `e(h_mserd)'

gen rv_2     = rv^2
gen rv_vic_2 = rv_2*victory
reghdfe CAR_minus1_5 victory rv rv_victory rv_2 rv_vic_2 if abs(rv) < `CCT_bw', absorb(constant) vce(cluster cycle) /* Quadratic */

rdbwselect CAR_minus1_5 rv, c(0) p(3) vce(cluster cycle)
local CCT_bw = `e(h_mserd)'

gen rv_3     = rv^3
gen rv_vic_3 = rv_3*victory
reghdfe CAR_minus1_5 victory rv rv_victory rv_2 rv_vic_2 ///
rv_3 rv_vic_3 if abs(rv) < `CCT_bw', absorb(constant) vce(cluster cycle) /* Cubic */

restore 


********************************************************************************
************ APPENDIX TABLE A.4: RD ESTIMATES  *********************************
********************************************************************************

use "qpq_main_dataset", clear

********************** PANEL A: CR(-1, 1) *************************************

*******************************************
* Close election threshold: 1 pp
*******************************************

preserve

drop if abs(rv) > 0.005

reghdfe CR_minus1_1 victory if !mi(CAR_minus1_1), absorb(constant) vce(cluster cycle) /* Local constant */

reghdfe CR_minus1_1 victory rv rv_victory if !mi(CAR_minus1_1), absorb(constant) vce(cluster cycle) /* Local linear */

gen rv_2     = rv^2
gen rv_vic_2 = rv_2*victory
reghdfe CR_minus1_1 victory rv rv_victory rv_2 rv_vic_2 if !mi(CAR_minus1_1), absorb(constant) vce(cluster cycle) /* Quadratic */

gen rv_3     = rv^3
gen rv_vic_3 = rv_3*victory
reghdfe CR_minus1_1 victory rv rv_victory rv_2 rv_vic_2 ///
rv_3 rv_vic_3 if !mi(CAR_minus1_1), absorb(constant) vce(cluster cycle) /* Cubic */

restore

*******************************************
* Close election threshold: 2.5 pp
*******************************************

preserve

drop if abs(rv) > 0.0125

reghdfe CR_minus1_1 victory if !mi(CAR_minus1_1), absorb(constant) vce(cluster cycle) /* Local constant */

reghdfe CR_minus1_1 victory rv rv_victory if !mi(CAR_minus1_1), absorb(constant) vce(cluster cycle) /* Local linear */

gen rv_2     = rv^2
gen rv_vic_2 = rv_2*victory
reghdfe CR_minus1_1 victory rv rv_victory rv_2 rv_vic_2 if !mi(CAR_minus1_1), absorb(constant) vce(cluster cycle) /* Quadratic */

gen rv_3     = rv^3
gen rv_vic_3 = rv_3*victory
reghdfe CR_minus1_1 victory rv rv_victory rv_2 rv_vic_2 ///
rv_3 rv_vic_3 if !mi(CAR_minus1_1), absorb(constant) vce(cluster cycle) /* Cubic */

restore

*******************************************
* Close election threshold: 5 pp
*******************************************

preserve

drop if abs(rv) > 0.025

reghdfe CR_minus1_1 victory if !mi(CAR_minus1_1), absorb(constant) vce(cluster cycle) /* Local constant */

reghdfe CR_minus1_1 victory rv rv_victory if !mi(CAR_minus1_1), absorb(constant) vce(cluster cycle) /* Local linear */

gen rv_2     = rv^2
gen rv_vic_2 = rv_2*victory
reghdfe CR_minus1_1 victory rv rv_victory rv_2 rv_vic_2 if !mi(CAR_minus1_1), absorb(constant) vce(cluster cycle) /* Quadratic */

gen rv_3     = rv^3
gen rv_vic_3 = rv_3*victory
reghdfe CR_minus1_1 victory rv rv_victory rv_2 rv_vic_2 ///
rv_3 rv_vic_3 if !mi(CAR_minus1_1), absorb(constant) vce(cluster cycle) /* Cubic */

restore

*******************************************
* Close election threshold: 10 pp
*******************************************

preserve

drop if abs(rv) > 0.05

reghdfe CR_minus1_1 victory if !mi(CAR_minus1_1), absorb(constant) vce(cluster cycle) /* Local constant */

reghdfe CR_minus1_1 victory rv rv_victory if !mi(CAR_minus1_1), absorb(constant) vce(cluster cycle) /* Local linear */

gen rv_2     = rv^2
gen rv_vic_2 = rv_2*victory
reghdfe CR_minus1_1 victory rv rv_victory rv_2 rv_vic_2 if !mi(CAR_minus1_1), absorb(constant) vce(cluster cycle) /* Quadratic */

gen rv_3     = rv^3
gen rv_vic_3 = rv_3*victory
reghdfe CR_minus1_1 victory rv rv_victory rv_2 rv_vic_2 ///
rv_3 rv_vic_3 if !mi(CAR_minus1_1), absorb(constant) vce(cluster cycle) /* Cubic */

restore

*******************************************
* Imbens-Kalyanaraman optimal bandwidth
*******************************************

preserve 

rdob CR_minus1_1 rv, c(0)

* h_opt: .09

reghdfe CR_minus1_1 victory if abs(rv) < .09 & !mi(CAR_minus1_1), absorb(constant) vce(cluster cycle) /* Local constant */

reghdfe CR_minus1_1 victory rv rv_victory if abs(rv) < .09 & !mi(CAR_minus1_1), absorb(constant) vce(cluster cycle) /* Local linear */

gen rv_2     = rv^2
gen rv_vic_2 = rv_2*victory
reghdfe CR_minus1_1 victory rv rv_victory rv_2 rv_vic_2 if abs(rv) < .09 & !mi(CAR_minus1_1), absorb(constant) vce(cluster cycle) /* Quadratic */

gen rv_3     = rv^3
gen rv_vic_3 = rv_3*victory
reghdfe CR_minus1_1 victory rv rv_victory rv_2 rv_vic_2 ///
rv_3 rv_vic_3 if abs(rv) < .09 & !mi(CAR_minus1_1), absorb(constant) vce(cluster cycle) /* Cubic */

restore

*******************************************
* Calonico, Cattaneo, and Titiunik (2014)
*******************************************

preserve 

rdbwselect CR_minus1_1 rv, c(0) p(0) vce(cluster cycle)
local CCT_bw = `e(h_mserd)'

reghdfe CR_minus1_1 victory if abs(rv) < `CCT_bw', absorb(constant) vce(cluster cycle) /* Local constant */

rdbwselect CR_minus1_1 rv, c(0) p(1) vce(cluster cycle)
local CCT_bw = `e(h_mserd)'

reghdfe CR_minus1_1 victory rv rv_victory if abs(rv) < `CCT_bw', absorb(constant) vce(cluster cycle) /* Local linear */

rdbwselect CR_minus1_1 rv, c(0) p(2) vce(cluster cycle)
local CCT_bw = `e(h_mserd)'

gen rv_2     = rv^2
gen rv_vic_2 = rv_2*victory
reghdfe CR_minus1_1 victory rv rv_victory rv_2 rv_vic_2 if abs(rv) < `CCT_bw', absorb(constant) vce(cluster cycle) /* Quadratic */

rdbwselect CR_minus1_1 rv, c(0) p(3) vce(cluster cycle)
local CCT_bw = `e(h_mserd)'

gen rv_3     = rv^3
gen rv_vic_3 = rv_3*victory
reghdfe CR_minus1_1 victory rv rv_victory rv_2 rv_vic_2 ///
rv_3 rv_vic_3 if abs(rv) < `CCT_bw', absorb(constant) vce(cluster cycle) /* Cubic */

restore 


********************** PANEL B: CR(-1, 5) *************************************

*******************************************
* Close election threshold: 1 pp
*******************************************

preserve

drop if abs(rv) > 0.005

reghdfe CR_minus1_5 victory if !mi(CAR_minus1_5), absorb(constant) vce(cluster cycle) /* Local constant */

reghdfe CR_minus1_5 victory rv rv_victory if !mi(CAR_minus1_5), absorb(constant) vce(cluster cycle) /* Local linear */

gen rv_2     = rv^2
gen rv_vic_2 = rv_2*victory
reghdfe CR_minus1_5 victory rv rv_victory rv_2 rv_vic_2 if !mi(CAR_minus1_5), absorb(constant) vce(cluster cycle) /* Quadratic */

gen rv_3     = rv^3
gen rv_vic_3 = rv_3*victory
reghdfe CR_minus1_5 victory rv rv_victory rv_2 rv_vic_2 ///
rv_3 rv_vic_3 if !mi(CAR_minus1_5), absorb(constant) vce(cluster cycle) /* Cubic */

restore

*******************************************
* Close election threshold: 2.5 pp
*******************************************

preserve

drop if abs(rv) > 0.0125

reghdfe CR_minus1_5 victory if !mi(CAR_minus1_5), absorb(constant) vce(cluster cycle) /* Local constant */

reghdfe CR_minus1_5 victory rv rv_victory if !mi(CAR_minus1_5), absorb(constant) vce(cluster cycle) /* Local linear */

gen rv_2     = rv^2
gen rv_vic_2 = rv_2*victory
reghdfe CR_minus1_5 victory rv rv_victory rv_2 rv_vic_2 if !mi(CAR_minus1_5), absorb(constant) vce(cluster cycle) /* Quadratic */

gen rv_3     = rv^3
gen rv_vic_3 = rv_3*victory
reghdfe CR_minus1_5 victory rv rv_victory rv_2 rv_vic_2 ///
rv_3 rv_vic_3 if !mi(CAR_minus1_5), absorb(constant) vce(cluster cycle) /* Cubic */

restore

*******************************************
* Close election threshold: 5 pp
*******************************************

preserve

drop if abs(rv) > 0.025

reghdfe CR_minus1_5 victory if !mi(CAR_minus1_5), absorb(constant) vce(cluster cycle) /* Local constant */

reghdfe CR_minus1_5 victory rv rv_victory if !mi(CAR_minus1_5), absorb(constant) vce(cluster cycle) /* Local linear */

gen rv_2     = rv^2
gen rv_vic_2 = rv_2*victory
reghdfe CR_minus1_5 victory rv rv_victory rv_2 rv_vic_2 if !mi(CAR_minus1_5), absorb(constant) vce(cluster cycle) /* Quadratic */

gen rv_3     = rv^3
gen rv_vic_3 = rv_3*victory
reghdfe CR_minus1_5 victory rv rv_victory rv_2 rv_vic_2 ///
rv_3 rv_vic_3 if !mi(CAR_minus1_5), absorb(constant) vce(cluster cycle) /* Cubic */

restore

*******************************************
* Close election threshold: 10 pp
*******************************************

preserve

drop if abs(rv) > 0.05

reghdfe CR_minus1_5 victory if !mi(CAR_minus1_5), absorb(constant) vce(cluster cycle) /* Local constant */

reghdfe CR_minus1_5 victory rv rv_victory if !mi(CAR_minus1_5), absorb(constant) vce(cluster cycle) /* Local linear */

gen rv_2     = rv^2
gen rv_vic_2 = rv_2*victory
reghdfe CR_minus1_5 victory rv rv_victory rv_2 rv_vic_2 if !mi(CAR_minus1_5), absorb(constant) vce(cluster cycle) /* Quadratic */

gen rv_3     = rv^3
gen rv_vic_3 = rv_3*victory
reghdfe CR_minus1_5 victory rv rv_victory rv_2 rv_vic_2 ///
rv_3 rv_vic_3 if !mi(CAR_minus1_5), absorb(constant) vce(cluster cycle) /* Cubic */

restore

*******************************************
* Imbens-Kalyanaraman optimal bandwidth
*******************************************

preserve 

rdob CR_minus1_5 rv, c(0)

* h_opt: .0934

reghdfe CR_minus1_5 victory if abs(rv) < .0934 & !mi(CAR_minus1_5), absorb(constant) vce(cluster cycle) /* Local constant */

reghdfe CR_minus1_5 victory rv rv_victory if abs(rv) < .0934 & !mi(CAR_minus1_5), absorb(constant) vce(cluster cycle) /* Local linear */

gen rv_2     = rv^2
gen rv_vic_2 = rv_2*victory
reghdfe CR_minus1_5 victory rv rv_victory rv_2 rv_vic_2 if abs(rv) < .0934 & !mi(CAR_minus1_5), absorb(constant) vce(cluster cycle) /* Quadratic */

gen rv_3     = rv^3
gen rv_vic_3 = rv_3*victory
reghdfe CR_minus1_5 victory rv rv_victory rv_2 rv_vic_2 ///
rv_3 rv_vic_3 if abs(rv) < .0934 & !mi(CAR_minus1_5), absorb(constant) vce(cluster cycle) /* Cubic */

restore

*******************************************
* Calonico, Cattaneo, and Titiunik (2014)
*******************************************

preserve 

rdbwselect CR_minus1_5 rv, c(0) p(0) vce(cluster cycle)
local CCT_bw = `e(h_mserd)'

reghdfe CR_minus1_5 victory if abs(rv) < `CCT_bw', absorb(constant) vce(cluster cycle) /* Local constant */

rdbwselect CR_minus1_5 rv, c(0) p(1) vce(cluster cycle)
local CCT_bw = `e(h_mserd)'

reghdfe CR_minus1_5 victory rv rv_victory if abs(rv) < `CCT_bw', absorb(constant) vce(cluster cycle) /* Local linear */

rdbwselect CR_minus1_5 rv, c(0) p(2) vce(cluster cycle)
local CCT_bw = `e(h_mserd)'

gen rv_2     = rv^2
gen rv_vic_2 = rv_2*victory
reghdfe CR_minus1_5 victory rv rv_victory rv_2 rv_vic_2 if abs(rv) < `CCT_bw', absorb(constant) vce(cluster cycle) /* Quadratic */

rdbwselect CR_minus1_5 rv, c(0) p(3) vce(cluster cycle)
local CCT_bw = `e(h_mserd)'

gen rv_3     = rv^3
gen rv_vic_3 = rv_3*victory
reghdfe CR_minus1_5 victory rv rv_victory rv_2 rv_vic_2 ///
rv_3 rv_vic_3 if abs(rv) < `CCT_bw', absorb(constant) vce(cluster cycle) /* Cubic */

restore 

********************************************************************************
************ APPENDIX TABLE A.5: RD ESTIMATES  *********************************
********************************************************************************

use "qpq_main_dataset", clear

******************** PANEL A: RACE FIXED EFFECTS *******************************

*******************************************
* Close election threshold: 1 pp
*******************************************

preserve

drop if abs(rv) > 0.005

areg CAR_minus1_1 victory, absorb(election) vce(cluster cycle) /* Local constant */

areg CAR_minus1_1 victory rv, absorb(election) vce(cluster cycle) /* Local linear */

gen rv_2     = rv^2
gen rv_vic_2 = rv_2*victory
areg CAR_minus1_1 victory rv rv_2 , absorb(election) vce(cluster cycle) /* Quadratic */

gen rv_3     = rv^3
gen rv_vic_3 = rv_3*victory
areg CAR_minus1_1 victory rv  rv_2 ///
rv_3 , absorb(election) vce(cluster cycle) /* Cubic */

restore

*******************************************
* Close election threshold: 2.5 pp
*******************************************

preserve

drop if abs(rv) > 0.0125

areg CAR_minus1_1 victory, absorb(election) vce(cluster cycle) /* Local constant */

areg CAR_minus1_1 victory rv, absorb(election) vce(cluster cycle) /* Local linear */

gen rv_2     = rv^2
gen rv_vic_2 = rv_2*victory
areg CAR_minus1_1 victory rv  rv_2 , absorb(election) vce(cluster cycle) /* Quadratic */

gen rv_3     = rv^3
gen rv_vic_3 = rv_3*victory
areg CAR_minus1_1 victory rv  rv_2  ///
rv_3 , absorb(election) vce(cluster cycle) /* Cubic */

restore

*******************************************
* Close election threshold: 5 pp
*******************************************

preserve

drop if abs(rv) > 0.025

areg CAR_minus1_1 victory, absorb(election) vce(cluster cycle) /* Local constant */

areg CAR_minus1_1 victory rv , absorb(election) vce(cluster cycle) /* Local linear */

gen rv_2     = rv^2
gen rv_vic_2 = rv_2*victory
areg CAR_minus1_1 victory rv  rv_2 , absorb(election) vce(cluster cycle) /* Quadratic */

gen rv_3     = rv^3
gen rv_vic_3 = rv_3*victory
areg CAR_minus1_1 victory rv  rv_2  ///
rv_3 , absorb(election) vce(cluster cycle) /* Cubic */

restore

*******************************************
* Close election threshold: 10 pp
*******************************************

preserve

drop if abs(rv) > 0.05

areg CAR_minus1_1 victory, absorb(election) vce(cluster cycle) /* Local constant */

areg CAR_minus1_1 victory rv , absorb(election) vce(cluster cycle) /* Local linear */

gen rv_2     = rv^2
gen rv_vic_2 = rv_2*victory
areg CAR_minus1_1 victory rv  rv_2 , absorb(election) vce(cluster cycle) /* Quadratic */

gen rv_3     = rv^3
gen rv_vic_3 = rv_3*victory
areg CAR_minus1_1 victory rv rv_2 ///
rv_3 , absorb(election) vce(cluster cycle) /* Cubic */

restore

*******************************************
* Imbens-Kalyanaraman optimal bandwidth
*******************************************

preserve 

rdob CAR_minus1_1 rv, c(0)

* h_opt: .0993

reghdfe CAR_minus1_1 victory if abs(rv) < .0993, absorb(election) vce(cluster cycle) /* Local constant */

reghdfe CAR_minus1_1 victory rv rv_victory if abs(rv) < .0993, absorb(election) vce(cluster cycle) /* Local linear */

gen rv_2     = rv^2
gen rv_vic_2 = rv_2*victory
reghdfe CAR_minus1_1 victory rv rv_victory rv_2 rv_vic_2 if abs(rv) < .0993, absorb(election) vce(cluster cycle) /* Quadratic */

gen rv_3     = rv^3
gen rv_vic_3 = rv_3*victory
reghdfe CAR_minus1_1 victory rv rv_victory rv_2 rv_vic_2 ///
rv_3 rv_vic_3 if abs(rv) < .0993, absorb(election) vce(cluster cycle) /* Cubic */

restore


*******************************************
* Calonico, Cattaneo, and Titiunik (2014)
*******************************************

preserve 

rdbwselect CAR_minus1_1 rv, c(0) p(0) vce(cluster cycle)
local CCT_bw = `e(h_mserd)'

reghdfe CAR_minus1_1 victory if abs(rv) < `CCT_bw', absorb(election) vce(cluster cycle) /* Local constant */

rdbwselect CAR_minus1_1 rv, c(0) p(1) vce(cluster cycle)
local CCT_bw = `e(h_mserd)'

reghdfe CAR_minus1_1 victory rv rv_victory if abs(rv) < `CCT_bw', absorb(election) vce(cluster cycle) /* Local linear */

rdbwselect CAR_minus1_1 rv, c(0) p(2) vce(cluster cycle)
local CCT_bw = `e(h_mserd)'

gen rv_2     = rv^2
gen rv_vic_2 = rv_2*victory
reghdfe CAR_minus1_1 victory rv rv_victory rv_2 rv_vic_2 if abs(rv) < `CCT_bw', absorb(election) vce(cluster cycle) /* Quadratic */

rdbwselect CAR_minus1_1 rv, c(0) p(3) vce(cluster cycle)
local CCT_bw = `e(h_mserd)'

gen rv_3     = rv^3
gen rv_vic_3 = rv_3*victory
reghdfe CAR_minus1_1 victory rv rv_victory rv_2 rv_vic_2 ///
rv_3 rv_vic_3 if abs(rv) < `CCT_bw', absorb(election) vce(cluster cycle) /* Cubic */

restore 

************************* PANEL B: PARTY_CYCLE FIXED EFFECTS *******************


*******************************************
* Close election threshold: 1 pp
*******************************************

preserve

drop if abs(rv) > 0.005

reghdfe CAR_minus1_1 victory, absorb(party_cycle) vce(cluster cycle) /* Local constant */

reghdfe CAR_minus1_1 victory rv rv_victory, absorb(party_cycle) vce(cluster cycle) /* Local linear */

gen rv_2     = rv^2
gen rv_vic_2 = rv_2*victory
reghdfe CAR_minus1_1 victory rv rv_victory rv_2 rv_vic_2, absorb(party_cycle) vce(cluster cycle) /* Quadratic */

gen rv_3     = rv^3
gen rv_vic_3 = rv_3*victory
reghdfe CAR_minus1_1 victory rv rv_victory rv_2 rv_vic_2 ///
rv_3 rv_vic_3, absorb(party_cycle) vce(cluster cycle) /* Cubic */

restore

*******************************************
* Close election threshold: 2.5 pp
*******************************************

preserve

drop if abs(rv) > 0.0125

reghdfe CAR_minus1_1 victory, absorb(party_cycle) vce(cluster cycle) /* Local constant */

reghdfe CAR_minus1_1 victory rv rv_victory, absorb(party_cycle) vce(cluster cycle) /* Local linear */

gen rv_2     = rv^2
gen rv_vic_2 = rv_2*victory
reghdfe CAR_minus1_1 victory rv rv_victory rv_2 rv_vic_2, absorb(party_cycle) vce(cluster cycle) /* Quadratic */

gen rv_3     = rv^3
gen rv_vic_3 = rv_3*victory
reghdfe CAR_minus1_1 victory rv rv_victory rv_2 rv_vic_2 ///
rv_3 rv_vic_3, absorb(party_cycle) vce(cluster cycle) /* Cubic */

restore

*******************************************
* Close election threshold: 5 pp
*******************************************

preserve

drop if abs(rv) > 0.025

reghdfe CAR_minus1_1 victory, absorb(party_cycle) vce(cluster cycle) /* Local constant */

reghdfe CAR_minus1_1 victory rv rv_victory, absorb(party_cycle) vce(cluster cycle) /* Local linear */

gen rv_2     = rv^2
gen rv_vic_2 = rv_2*victory
reghdfe CAR_minus1_1 victory rv rv_victory rv_2 rv_vic_2, absorb(party_cycle) vce(cluster cycle) /* Quadratic */

gen rv_3     = rv^3
gen rv_vic_3 = rv_3*victory
reghdfe CAR_minus1_1 victory rv rv_victory rv_2 rv_vic_2 ///
rv_3 rv_vic_3, absorb(party_cycle) vce(cluster cycle) /* Cubic */

restore

*******************************************
* Close election threshold: 10 pp
*******************************************

preserve

drop if abs(rv) > 0.05

reghdfe CAR_minus1_1 victory, absorb(party_cycle) vce(cluster cycle) /* Local constant */

reghdfe CAR_minus1_1 victory rv rv_victory, absorb(party_cycle) vce(cluster cycle) /* Local linear */

gen rv_2     = rv^2
gen rv_vic_2 = rv_2*victory
reghdfe CAR_minus1_1 victory rv rv_victory rv_2 rv_vic_2, absorb(party_cycle) vce(cluster cycle) /* Quadratic */

gen rv_3     = rv^3
gen rv_vic_3 = rv_3*victory
reghdfe CAR_minus1_1 victory rv rv_victory rv_2 rv_vic_2 ///
rv_3 rv_vic_3, absorb(party_cycle) vce(cluster cycle) /* Cubic */

restore

*******************************************
* Imbens-Kalyanaraman optimal bandwidth
*******************************************

preserve 

rdob CAR_minus1_1 rv, c(0) 

* h_opt: .0993

reghdfe CAR_minus1_1 victory if abs(rv) < .0993, absorb(party_cycle) vce(cluster cycle) /* Local constant */

reghdfe CAR_minus1_1 victory rv rv_victory if abs(rv) < .0993, absorb(party_cycle) vce(cluster cycle) /* Local linear */

gen rv_2     = rv^2
gen rv_vic_2 = rv_2*victory
reghdfe CAR_minus1_1 victory rv rv_victory rv_2 rv_vic_2 if abs(rv) < .0993, absorb(party_cycle) vce(cluster cycle) /* Quadratic */

gen rv_3     = rv^3
gen rv_vic_3 = rv_3*victory
reghdfe CAR_minus1_1 victory rv rv_victory rv_2 rv_vic_2 ///
rv_3 rv_vic_3 if abs(rv) < .0993, absorb(party_cycle) vce(cluster cycle) /* Cubic */

restore

*******************************************
* Calonico, Cattaneo, and Titiunik (2014)
*******************************************

preserve 

rdbwselect CAR_minus1_1 rv, c(0) p(0) vce(cluster cycle)
local CCT_bw = `e(h_mserd)'

reghdfe CAR_minus1_1 victory if abs(rv) < `CCT_bw', absorb(party_cycle) vce(cluster cycle) /* Local constant */

rdbwselect CAR_minus1_1 rv, c(0) p(1) vce(cluster cycle)
local CCT_bw = `e(h_mserd)'

reghdfe CAR_minus1_1 victory rv rv_victory if abs(rv) < `CCT_bw', absorb(party_cycle) vce(cluster cycle) /* Local linear */

rdbwselect CAR_minus1_1 rv, c(0) p(2) vce(cluster cycle)
local CCT_bw = `e(h_mserd)'

gen rv_2     = rv^2
gen rv_vic_2 = rv_2*victory
reghdfe CAR_minus1_1 victory rv rv_victory rv_2 rv_vic_2 if abs(rv) < `CCT_bw', absorb(party_cycle) vce(cluster cycle) /* Quadratic */

rdbwselect CAR_minus1_1 rv, c(0) p(3) vce(cluster cycle)
local CCT_bw = `e(h_mserd)'

gen rv_3     = rv^3
gen rv_vic_3 = rv_3*victory
reghdfe CAR_minus1_1 victory rv rv_victory rv_2 rv_vic_2 ///
rv_3 rv_vic_3 if abs(rv) < `CCT_bw', absorb(party_cycle) vce(cluster cycle) /* Cubic */

restore 

********************************************************************************
************ APPENDIX TABLE A.6: HETEROGENEITY  ********************************
********************************************************************************

*************** CLOSE ELECTION: MARGIN OF VICTORY SMALLER THAN 10 PP ***********
*************** DEPENDENT VARIABLES: CAR(-1, X), X = 1, 5, 10, 30 ************** 

use "qpq_main_dataset", clear

*******************************************
* ROW 1: Full sample
*******************************************

drop if abs(rv) > 0.05

reghdfe CAR_minus1_1 victory rv rv_victory, absorb(constant) vce(cluster cycle)  /* CAR(-1, 1) */

reghdfe CAR_minus1_5 victory rv rv_victory, absorb(constant) vce(cluster cycle) /* CAR(-1, 5) */

reghdfe CAR_minus1_10 victory rv rv_victory, absorb(constant) vce(cluster cycle) /* CAR(-1, 10) */

reghdfe CAR_minus1_30 victory rv rv_victory, absorb(constant) vce(cluster cycle) /* CAR(-1, 30) */

*******************************************
* ROWS 2, 3, 4, 5 and 6: BY OFFICE
*******************************************

*******************************************
* ROW 2: U.S. HOUSE
*******************************************

reghdfe CAR_minus1_1 victory rv rv_victory if setting=="house", ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 1) */

reghdfe CAR_minus1_5 victory rv rv_victory if setting=="house", ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 5) */

reghdfe CAR_minus1_10 victory rv rv_victory if setting=="house", ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 10) */

reghdfe CAR_minus1_30 victory rv rv_victory if setting=="house", ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 30) */

*******************************************
* ROW 3: U.S. SENATE
*******************************************

reghdfe CAR_minus1_1 victory rv rv_victory if setting=="senate", ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 1) */

reghdfe CAR_minus1_5 victory rv rv_victory if setting=="senate", ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 5) */

reghdfe CAR_minus1_10 victory rv rv_victory if setting=="senate", ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 10) */

reghdfe CAR_minus1_30 victory rv rv_victory if setting=="senate", ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 30) */

*******************************************
* ROW 4: GOVERNOR
*******************************************

reghdfe CAR_minus1_1 victory rv rv_victory if setting=="gov", ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 1) */

reghdfe CAR_minus1_5 victory rv rv_victory if setting=="gov", ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 5) */

reghdfe CAR_minus1_10 victory rv rv_victory if setting=="gov", ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 10) */

reghdfe CAR_minus1_30 victory rv rv_victory if setting=="gov", ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 30) */

*******************************************
* ROW 5: STATE HOUSE 
*******************************************

reghdfe CAR_minus1_1 victory rv rv_victory if setting=="stleglower", ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 1) */

reghdfe CAR_minus1_5 victory rv rv_victory if setting=="stleglower", ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 5) */

reghdfe CAR_minus1_10 victory rv rv_victory if setting=="stleglower", ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 10) */

reghdfe CAR_minus1_30 victory rv rv_victory if setting=="stleglower", ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 30) */

*******************************************
* ROW 6: STATE SENATE 
*******************************************

reghdfe CAR_minus1_1 victory rv rv_victory if setting=="stlegupper", ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 1) */

reghdfe CAR_minus1_5 victory rv rv_victory if setting=="stlegupper", ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 5) */

reghdfe CAR_minus1_10 victory rv rv_victory if setting=="stlegupper", ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 10) */

reghdfe CAR_minus1_30 victory rv rv_victory if setting=="stlegupper", ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 30) */

*******************************************
* ROWS 7, 8 and 9: By Size of Donation
*******************************************

gen donation     = 0
replace donation = totaldem if dem == 1
replace donation = totalrep if dem == 0

centile (donation), centile (33 66)


*******************************************
* ROW 7: 1st Tercile of Amount of Donation
*******************************************

reghdfe CAR_minus1_1 victory rv rv_victory if donation <= 500, ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 1) */

reghdfe CAR_minus1_5 victory rv rv_victory if donation <= 500, ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 5) */

reghdfe CAR_minus1_10 victory rv rv_victory if donation <= 500, ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 10) */

reghdfe CAR_minus1_30 victory rv rv_victory if donation <= 500, ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 30) */

*******************************************
* ROW 8: 2nd Tercile of Amount of Donation
*******************************************

reghdfe CAR_minus1_1 victory rv rv_victory if donation <= 1000 & donation > 500, ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 1) */

reghdfe CAR_minus1_5 victory rv rv_victory if donation <= 1000 & donation > 500, ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 5) */

reghdfe CAR_minus1_10 victory rv rv_victory if donation <= 1000 & donation > 500, ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 10) */

reghdfe CAR_minus1_30 victory rv rv_victory if donation <= 1000 & donation > 500, ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 30) */

*******************************************
* ROW 9: Last Tercile of Amount of Donation
*******************************************

reghdfe CAR_minus1_1 victory rv rv_victory if donation > 1000, ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 1) */

reghdfe CAR_minus1_5 victory rv rv_victory if donation > 1000, ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 5) */

reghdfe CAR_minus1_10 victory rv rv_victory if donation > 1000, ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 10) */

reghdfe CAR_minus1_30 victory rv rv_victory if donation > 1000, ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 30) */

*******************************************
* ROWS 10, 11 and 12: By Decade
*******************************************

*******************************************
* ROW 10: 1980's
*******************************************

reghdfe CAR_minus1_1 victory rv rv_victory if cycle >= 1980 & cycle <= 1988, ///
 absorb(constant) vce(cluster cycle) /* CAR(-1, 1) */

reghdfe CAR_minus1_5 victory rv rv_victory if cycle >= 1980 & cycle <= 1988, ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 5) */

reghdfe CAR_minus1_10 victory rv rv_victory if cycle >= 1980 & cycle <= 1988, ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 10) */

reghdfe CAR_minus1_30 victory rv rv_victory if cycle >= 1980 & cycle <= 1988, ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 30) */

*******************************************
* ROW 11: 1990's
*******************************************

reghdfe CAR_minus1_1 victory rv rv_victory if cycle >= 1990 & cycle <= 1998, ///
 absorb(constant) vce(cluster cycle) /* CAR(-1, 1) */

reghdfe CAR_minus1_5 victory rv rv_victory if cycle >= 1990 & cycle <= 1998, ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 5) */

reghdfe CAR_minus1_10 victory rv rv_victory if cycle >= 1990 & cycle <= 1998, ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 10) */

reghdfe CAR_minus1_30 victory rv rv_victory if cycle >= 1990 & cycle <= 1998, ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 30) */

*******************************************
* ROW 12: 2000's
*******************************************

reghdfe CAR_minus1_1 victory rv rv_victory if cycle >= 2000 & cycle <= 2010, ///
 absorb(constant) vce(cluster cycle) /* CAR(-1, 1) */

reghdfe CAR_minus1_5 victory rv rv_victory if cycle >= 2000 & cycle <= 2010, ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 5) */

reghdfe CAR_minus1_10 victory rv rv_victory if cycle >= 2000 & cycle <= 2010, ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 10) */

reghdfe CAR_minus1_30 victory rv rv_victory if cycle >= 2000 & cycle <= 2010, ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 30) */

******************************************************
* ROWS 13 and 14: BY MARKET CAP OF THE COMPANY
******************************************************

* In the dataset of close elections, the median market cap is 6.792 billion $

su market_cap if !mi(market_cap) & abs(rv) < 0.05, detail

**************************************************************
* ROW 13: FIRST HALF BY MARKET CAP (LOWER THAN THE MEDIAN: 6.792 BILLION)
**************************************************************

reghdfe CAR_minus1_1 victory rv rv_victory if market_cap < 6792 & !missing(market_cap), ///
 absorb(constant) vce(cluster cycle) /* CAR(-1, 1) */

reghdfe CAR_minus1_5 victory rv rv_victory if market_cap < 6792 & !missing(market_cap), ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 5) */

reghdfe CAR_minus1_10 victory rv rv_victory if market_cap < 6792 & !missing(market_cap), ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 10) */

reghdfe CAR_minus1_30 victory rv rv_victory if market_cap < 6792 & !missing(market_cap), ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 30) */

*******************************************
* ROW 14: MARKET CAP HIGHER THAN THE MEDIAN 
*******************************************

reghdfe CAR_minus1_1 victory rv rv_victory if market_cap >= 6792 & !missing(market_cap), ///
 absorb(constant) vce(cluster cycle) /* CAR(-1, 1) */

reghdfe CAR_minus1_5 victory rv rv_victory if market_cap >= 6792 & !missing(market_cap), ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 5) */

reghdfe CAR_minus1_10 victory rv rv_victory if market_cap >= 6792 & !missing(market_cap), ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 10) */

reghdfe CAR_minus1_30 victory rv rv_victory if market_cap >= 6792 & !missing(market_cap), ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 30) */


*******************************************
* ROWS 15, 16, 17 and 18: BY SECTOR
*******************************************

gen agri_mining         = 0
replace agri_mining     = 1 if siccd > 99 & siccd < 1500
gen construction        = 0
replace construction    = 1 if siccd > 1499 & siccd < 1800
gen manuf               = 0
replace manuf           = 1 if siccd > 1999 & siccd < 4000
gen transp_elec         = 0
replace transp_elec     = 1 if siccd > 3999 & siccd < 5000
gen whole_ret_trade     = 0
replace whole_ret_trade = 1 if siccd > 4999 & siccd < 6000
gen finance             = 0
replace finance         = 1 if siccd > 5999 & siccd < 6800
gen services            = 0
replace services        = 1 if siccd > 6999 & siccd < 9000
gen public_adm          = 0
replace public_adm      = 1 if siccd > 9099 & siccd < 9730
gen other               = 0
replace other           = 1 if finance==0 & manuf==0 & transp_elec==0

*******************************************
* ROW 15: MANUFACTURING (DIVISION D)
*******************************************

reghdfe CAR_minus1_1 victory rv rv_victory if manuf==1, ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 1) */

reghdfe CAR_minus1_5 victory rv rv_victory if manuf==1, ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 5) */

reghdfe CAR_minus1_10 victory rv rv_victory if manuf==1, ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 10) */

reghdfe CAR_minus1_30 victory rv rv_victory if manuf==1, ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 30) */

*****************************************************
* ROW 16: TRANSPORTATION, ELECTRICITY... (DIVISION E)
*****************************************************

reghdfe CAR_minus1_1 victory rv rv_victory if transp_elec==1, ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 1) */

reghdfe CAR_minus1_5 victory rv rv_victory if transp_elec==1, ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 5) */

reghdfe CAR_minus1_10 victory rv rv_victory if transp_elec==1, ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 10) */

reghdfe CAR_minus1_30 victory rv rv_victory if transp_elec==1, ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 30) */

**********************************************************
* ROW 17: FINANCE: INSURANCE AND REAL ESTATE (DIVISION H)
**********************************************************

reghdfe CAR_minus1_1 victory rv rv_victory if finance==1, ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 1) */

reghdfe CAR_minus1_5 victory rv rv_victory if finance==1, ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 5) */

reghdfe CAR_minus1_10 victory rv rv_victory if finance==1, ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 10) */

reghdfe CAR_minus1_30 victory rv rv_victory if finance==1, ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 30) */

**********************************************************
* ROW 18: OTHER
**********************************************************

reghdfe CAR_minus1_1 victory rv rv_victory if other==1, ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 1) */

reghdfe CAR_minus1_5 victory rv rv_victory if other==1, ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 5) */

reghdfe CAR_minus1_10 victory rv rv_victory if other==1, ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 10) */

reghdfe CAR_minus1_30 victory rv rv_victory if other==1, ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 30) */

******************************************************
* ROWS 19 and 20: BY INCUMBENCY STATUS OF THE CANDIDATE
******************************************************

g incumbent = dem == 1 & deminc == 1
replace incumbent = 1 if dem == 0 & repinc == 1
g challenger = dem == 1 & repinc == 1
replace challenger = 1 if dem == 0 & deminc == 1
replace challenger = 1 if deminc == 0 & repinc == 0

*******************************************
* ROW 19: INCUMBENTS 
*******************************************

reghdfe CAR_minus1_1 victory rv rv_victory if incumbent == 1, ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 1) */

reghdfe CAR_minus1_5 victory rv rv_victory if incumbent == 1, ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 5) */

reghdfe CAR_minus1_10 victory rv rv_victory if incumbent == 1, ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 10) */

reghdfe CAR_minus1_30 victory rv rv_victory if incumbent == 1, ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 30) */

*******************************************
* ROW 20: CHALLENGERS 
*******************************************

reghdfe CAR_minus1_1 victory rv rv_victory if challenger == 1, ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 1) */

reghdfe CAR_minus1_5 victory rv rv_victory if challenger == 1, ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 5) */

reghdfe CAR_minus1_10 victory rv rv_victory if challenger == 1, ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 10) */

reghdfe CAR_minus1_30 victory rv rv_victory if challenger == 1, ///
absorb(constant) vce(cluster cycle) /* CAR(-1, 30) */



********************************************************************************
************ APPENDIX TABLE A.7: SUBSAMPLES  ***********************************
********************************************************************************

use "qpq_main_dataset", clear

* Other Candidates Supported by Firm in Cycle
egen totalcandidates = sum(constant), by(firm_cycle)

* Full Sample
areg CAR_minus1_1 victory rv rv_victory if abs(rv) < .05, absorb(constant) cluster(cycle)

**** Market cap *******************

su market_cap, detail

su totalcandidates, detail

* Exclude firms in the top 10 pctile in terms of market cap
areg CAR_minus1_1 victory rv rv_victory if abs(rv) < .05 & market_cap != . & market_cap <= 104403, absorb(constant) cluster(cycle)
* Exclude firms in the top 25 pctile in terms of market cap
areg CAR_minus1_1 victory rv rv_victory if abs(rv) < .05 & market_cap != . & market_cap <= 48606, absorb(constant) cluster(cycle)
* Exclude firms in the bottom 10 pctile in terms of market cap
areg CAR_minus1_1 victory rv rv_victory if abs(rv) < .05 & market_cap != . & market_cap >= 492, absorb(constant) cluster(cycle)
* Exclude firms in the bottom 25 pctile in terms of market cap
areg CAR_minus1_1 victory rv rv_victory if abs(rv) < .05 & market_cap != . & market_cap >= 1800, absorb(constant) cluster(cycle)

**** Candidates supported *********

* Exclude firms in the top 10 pctile in terms of candidates supported in cycle
areg CAR_minus1_1 victory rv rv_victory if abs(rv) < .05 & totalcandidates < 535, absorb(constant) cluster(cycle)
* Exclude firms in the top 25 pctile in terms of candidates supported in cycle
areg CAR_minus1_1 victory rv rv_victory if abs(rv) < .05 & totalcandidates < 227, absorb(constant) cluster(cycle)
* Exclude firms in the bottom 10 pctile in terms of candidates supported in cycle
areg CAR_minus1_1 victory rv rv_victory if abs(rv) < .05 & totalcandidates > 12, absorb(constant) cluster(cycle)
* Exclude firms in the bottom 25 pctile in terms of candidates supported in cycle
areg CAR_minus1_1 victory rv rv_victory if abs(rv) < .05 & totalcandidates > 34, absorb(constant) cluster(cycle)

****** Years **********************

* Create dummies for odd, presidential and midterm years
g presi = 0
replace presi = 1 if year == 2008 | year == 2004 | year == 2000 | year == 1996 | year == 1992 | year == 1988 | year == 1984 | year == 1980

g midterm = 0
replace midterm = 1 if year == 2010 | year == 2006 | year == 2002 | year == 1998 | year == 1994 | year == 1990 | year == 1986 | year == 1982

* Presidential
areg CAR_minus1_1 victory rv rv_victory if abs(rv) < .05 & presi==1, absorb(constant) cluster(cycle)
* Midterm
areg CAR_minus1_1 victory rv rv_victory if abs(rv) < .05 & midterm==1, absorb(constant) cluster(cycle)
* Odd-year
gen oddyear = mod(year,2) 
areg CAR_minus1_1 victory rv rv_victory if abs(rv) < .05 & oddyear==1, absorb(constant) cluster(cycle)

********************************************************************************
****************** APPENDIX TABLE A.8: AKEY (2015) DATA **********************
********************************************************************************

******* PANEL A ****************

use "Akey_RFS_Table_4", clear

******* CAR(-1, 5) FAMA FRENCH ****************

* Generate rv and rv_victory
gen rv = won__by/2
rename won_close victory
gen rv_victory = rv*victory

* Firm identifiers
egen firm = group(permno)

gen constant = 1

keep if double_donor==0


*******************************************
* Close election threshold: 1 pp
*******************************************

preserve

drop if abs(rv) > 0.005

reghdfe car_window_1 victory, absorb(constant) vce(cluster firm) /* Local constant */

reghdfe car_window_1 victory rv rv_victory, absorb(constant) vce(cluster firm) /* Local linear */

gen rv_2     = rv^2
gen rv_vic_2 = rv_2*victory
reghdfe car_window_1 victory rv rv_victory rv_2 rv_vic_2, absorb(constant) vce(cluster firm) /* Quadratic */

gen rv_3     = rv^3
gen rv_vic_3 = rv_3*victory
reghdfe car_window_1 victory rv rv_victory rv_2 rv_vic_2 ///
rv_3 rv_vic_3, absorb(constant) vce(cluster firm) /* Cubic */

restore


*******************************************
* Close election threshold: 2.5 pp
*******************************************

preserve

drop if abs(rv) > 0.0125

reghdfe car_window_1 victory, absorb(constant) vce(cluster firm) /* Local constant */

reghdfe car_window_1 victory rv rv_victory, absorb(constant) vce(cluster firm) /* Local linear */

gen rv_2     = rv^2
gen rv_vic_2 = rv_2*victory
reghdfe car_window_1 victory rv rv_victory rv_2 rv_vic_2, absorb(constant) vce(cluster firm) /* Quadratic */

gen rv_3     = rv^3
gen rv_vic_3 = rv_3*victory
reghdfe car_window_1 victory rv rv_victory rv_2 rv_vic_2 ///
rv_3 rv_vic_3, absorb(constant) vce(cluster firm) /* Cubic */

restore

*******************************************
* Close election threshold: 5 pp
*******************************************

preserve

drop if abs(rv) > 0.025

reghdfe car_window_1 victory, absorb(constant) vce(cluster firm) /* Local constant */

reghdfe car_window_1 victory rv rv_victory, absorb(constant) vce(cluster firm) /* Local linear */

gen rv_2     = rv^2
gen rv_vic_2 = rv_2*victory
reghdfe car_window_1 victory rv rv_victory rv_2 rv_vic_2, absorb(constant) vce(cluster firm) /* Quadratic */

gen rv_3     = rv^3
gen rv_vic_3 = rv_3*victory
reghdfe car_window_1 victory rv rv_victory rv_2 rv_vic_2 ///
rv_3 rv_vic_3, absorb(constant) vce(cluster firm) /* Cubic */

restore


*******************************************
* Imbens-Kalyanaraman optimal bandwidth
*******************************************

preserve 

drop if mi(rv)

rdob car_window_1 rv, c(0) 

* h_opt: .017

gen rv_2     = rv^2
gen rv_vic_2 = rv_2*victory

gen rv_3     = rv^3
gen rv_vic_3 = rv_3*victory

reghdfe car_window_1 victory if abs(rv) < .017, absorb(constant) vce(cluster firm) /* Local constant */

reghdfe car_window_1 victory rv rv_victory if abs(rv) < .017, absorb(constant) vce(cluster firm) /* Local linear */

reghdfe car_window_1 victory rv rv_victory rv_2 rv_vic_2 if abs(rv) < .017, absorb(constant) vce(cluster firm) /* Quadratic */

reghdfe car_window_1 victory rv rv_victory rv_2 rv_vic_2 ///
rv_3 rv_vic_3 if abs(rv) < .017, absorb(constant) vce(cluster firm) /* Cubic */

restore

******* PANEL B ****************

use "Akey_RFS_Table_4", clear

******* CAR(-1, 1) FAMA FRENCH ****************

* Generate rv and rv_victory
gen rv = won__by/2
rename won_close victory
gen rv_victory = rv*victory

* Firm identifies
egen firm = group(permno)

gen constant = 1

keep if double_donor==0

*******************************************
* Close election threshold: 1 pp
*******************************************

preserve

drop if abs(rv) > 0.005

reghdfe car_window_2 victory, absorb(constant) vce(cluster firm) /* Local constant */

reghdfe car_window_2 victory rv rv_victory, absorb(constant) vce(cluster firm) /* Local linear */

gen rv_2     = rv^2
gen rv_vic_2 = rv_2*victory
reghdfe car_window_2 victory rv rv_victory rv_2 rv_vic_2, absorb(constant) vce(cluster firm) /* Quadratic */

gen rv_3     = rv^3
gen rv_vic_3 = rv_3*victory
reghdfe car_window_2 victory rv rv_victory rv_2 rv_vic_2 ///
rv_3 rv_vic_3, absorb(constant) vce(cluster firm) /* Cubic */

restore


*******************************************
* Close election threshold: 2.5 pp
*******************************************

preserve

drop if abs(rv) > 0.0125

reghdfe car_window_2 victory, absorb(constant) vce(cluster firm) /* Local constant */

reghdfe car_window_2 victory rv rv_victory, absorb(constant) vce(cluster firm) /* Local linear */

gen rv_2     = rv^2
gen rv_vic_2 = rv_2*victory
reghdfe car_window_2 victory rv rv_victory rv_2 rv_vic_2, absorb(constant) vce(cluster firm) /* Quadratic */

gen rv_3     = rv^3
gen rv_vic_3 = rv_3*victory
reghdfe car_window_2 victory rv rv_victory rv_2 rv_vic_2 ///
rv_3 rv_vic_3, absorb(constant) vce(cluster firm) /* Cubic */

restore

*******************************************
* Close election threshold: 5 pp
*******************************************

preserve

drop if abs(rv) > 0.025

reghdfe car_window_2 victory, absorb(constant) vce(cluster firm) /* Local constant */

reghdfe car_window_2 victory rv rv_victory, absorb(constant) vce(cluster firm) /* Local linear */

gen rv_2     = rv^2
gen rv_vic_2 = rv_2*victory
reghdfe car_window_2 victory rv rv_victory rv_2 rv_vic_2, absorb(constant) vce(cluster firm) /* Quadratic */

gen rv_3     = rv^3
gen rv_vic_3 = rv_3*victory
reghdfe car_window_2 victory rv rv_victory rv_2 rv_vic_2 ///
rv_3 rv_vic_3, absorb(constant) vce(cluster firm) /* Cubic */

restore

*******************************************
* Imbens-Kalyanaraman optimal bandwidth
*******************************************

preserve 

drop if mi(rv)

rdob car_window_2 rv, c(0) 

* h_opt: .0119

gen rv_2     = rv^2
gen rv_vic_2 = rv_2*victory

gen rv_3     = rv^3
gen rv_vic_3 = rv_3*victory

reghdfe car_window_2 victory if abs(rv) < .0119, absorb(constant) vce(cluster firm) /* Local constant */

reghdfe car_window_2 victory rv rv_victory if abs(rv) < .0119, absorb(constant) vce(cluster firm) /* Local linear */

reghdfe car_window_2 victory rv rv_victory rv_2 rv_vic_2 if abs(rv) < .0119, absorb(constant) vce(cluster firm) /* Quadratic */

reghdfe car_window_2 victory rv rv_victory rv_2 rv_vic_2 ///
rv_3 rv_vic_3 if abs(rv) < .0119, absorb(constant) vce(cluster firm) /* Cubic */

restore


********************************************************************************
******* APPENDIX TABLE A.9: ANALYSIS OF SUBSAMPLES WITH RAW RETURNS ***********
********************************************************************************

use "qpq_main_dataset", clear

* Calculate money donated by firm to candidate
g totaldollars_cand = totalrep
replace totaldollars_cand = totaldem if dem==1

* Sectors
g sector = "other"
replace sector = "agri_mining" if siccd > 99 & siccd < 1500
replace sector = "construction" if siccd > 1499 & siccd < 1800
replace sector = "manufacturing" if siccd > 1999 & siccd < 4000
replace sector = "trans_elec" if siccd > 3999 & siccd < 5000
replace sector = "whole_ret_trade" if siccd > 4999 & siccd < 6000
replace sector = "finance" if siccd > 5999 & siccd < 6800
replace sector = "services" if siccd > 6999 & siccd < 9000
replace sector = "public_adm" if siccd > 9099 & siccd < 9730
g other = sector != "finance" & sector != "manufacturing" & sector != "trans_elec"

* Number of other winners supported by firm in cycle
egen otherwinners = sum(victory), by(firm_cycle)
replace otherwinners = otherwinners - victory

* Full Sample
areg CR_minus1_1 victory rv rv_victory if abs(rv) < .05 & !mi(CAR_minus1_1), absorb(constant) cluster(cycle)

* Donut
areg CR_minus1_1 victory rv rv_victory if abs(rv) < .05 & abs(rv) > .001 & !mi(CAR_minus1_1), absorb(constant) cluster(cycle)

**** BY OFFICE *******

* Governors
areg CR_minus1_1 victory rv rv_victory if abs(rv) < .05 & !mi(CAR_minus1_1) & setting == "gov", absorb(constant) cluster(cycle)
* U.S. Senate
areg CR_minus1_1 victory rv rv_victory if abs(rv) < .05 & !mi(CAR_minus1_1) & setting == "senate", absorb(constant) cluster(cycle)
* U.S. House
areg CR_minus1_1 victory rv rv_victory if abs(rv) < .05 & !mi(CAR_minus1_1) & setting == "house", absorb(constant) cluster(cycle)
* State Senate
areg CR_minus1_1 victory rv rv_victory if abs(rv) < .05 & !mi(CAR_minus1_1) & setting == "stlegupper", absorb(constant) cluster(cycle)
* State House
areg CR_minus1_1 victory rv rv_victory if abs(rv) < .05 & !mi(CAR_minus1_1) & setting == "stleglower", absorb(constant) cluster(cycle)

**** BY DONATION SIZE *******

* Donations >= $500
areg CR_minus1_1 victory rv rv_victory if abs(rv) < .05 & !mi(CAR_minus1_1) & totaldollars_cand >= 500, absorb(constant) cluster(cycle)
* Donations >= $1000
areg CR_minus1_1 victory rv rv_victory if abs(rv) < .05 & !mi(CAR_minus1_1) & totaldollars_cand >= 1000, absorb(constant) cluster(cycle)
* Donations >= $2500
areg CR_minus1_1 victory rv rv_victory if abs(rv) < .05 & !mi(CAR_minus1_1) & totaldollars_cand >= 2500, absorb(constant) cluster(cycle)

**** BY FIRM VALUE *******

* < 200 M
areg CR_minus1_1 victory rv rv_victory if abs(rv) < .05 & !mi(CAR_minus1_1) & market_cap < 200 & market_cap != ., absorb(constant) cluster(cycle)
* 200M-1B
areg CR_minus1_1 victory rv rv_victory if abs(rv) < .05 & !mi(CAR_minus1_1) & market_cap >= 200 & market_cap <= 1000 & market_cap != ., absorb(constant) cluster(cycle)
* 1-5B
areg CR_minus1_1 victory rv rv_victory if abs(rv) < .05 & !mi(CAR_minus1_1) & market_cap > 1000 & market_cap <= 5000 & market_cap != ., absorb(constant) cluster(cycle)
* > 5B
areg CR_minus1_1 victory rv rv_victory if abs(rv) < .05 & !mi(CAR_minus1_1) & market_cap >= 5000 & market_cap != ., absorb(constant) cluster(cycle)

**** BY SECTOR *******

* Manufacturing (Division D)
areg CR_minus1_1 victory rv rv_victory if abs(rv) < .05 & !mi(CAR_minus1_1) & sector == "manufacturing", absorb(constant) cluster(cycle)
* Transportation (Division E)
areg CR_minus1_1 victory rv rv_victory if abs(rv) < .05 & !mi(CAR_minus1_1) & sector == "trans_elec", absorb(constant) cluster(cycle)
* Finance (Division H)
areg CR_minus1_1 victory rv rv_victory if abs(rv) < .05 & !mi(CAR_minus1_1) & sector == "finance", absorb(constant) cluster(cycle)
* Other Industry
areg CR_minus1_1 victory rv rv_victory if abs(rv) < .05 & !mi(CAR_minus1_1) & other == 1, absorb(constant) cluster(cycle)

**** PRE-POST CITIZENS UNITED *******

* Pre Citizens United (<2010)
areg CR_minus1_1 victory rv rv_victory if abs(rv) < .05 & !mi(CAR_minus1_1) & year < 2010, absorb(constant) cluster(cycle)
* Post Citizens United (2010)
areg CR_minus1_1 victory rv rv_victory if abs(rv) < .05 & !mi(CAR_minus1_1) & year == 2010, absorb(constant) 

**** BY # OF OTHER WINNERS SUPPORTED *******

* 0 Other Winners Supported by Firm in Cycle
areg CR_minus1_1 victory rv rv_victory if abs(rv) < .05 & !mi(CAR_minus1_1) & otherwinners == 0, absorb(constant) cluster(cycle)

* 1-5 Other Winners Supported by Firm in Cycle
areg CR_minus1_1 victory rv rv_victory if abs(rv) < .05 & !mi(CAR_minus1_1) & otherwinners >= 1 & otherwinners <= 5, absorb(constant) cluster(cycle)

* 6-10 Other Winners Supported by Firm in Cycle
areg CR_minus1_1 victory rv rv_victory if abs(rv) < .05 & !mi(CAR_minus1_1) & otherwinners >= 6 & otherwinners <= 10, absorb(constant) cluster(cycle)

* 11-20 Other Winners Supported by Firm in Cycle
areg CR_minus1_1 victory rv rv_victory if abs(rv) < .05 & !mi(CAR_minus1_1) & otherwinners >= 11 & otherwinners <= 20, absorb(constant) cluster(cycle)

* 21-100 Other Winners Supported by Firm in Cycle
areg CR_minus1_1 victory rv rv_victory if abs(rv) < .05 & !mi(CAR_minus1_1) & otherwinners >= 21 & otherwinners <= 100, absorb(constant) cluster(cycle)

* > 100 Other Winners Supported by Firm in Cycle
areg CR_minus1_1 victory rv rv_victory if abs(rv) < .05 & !mi(CAR_minus1_1) & otherwinners > 100, absorb(constant) cluster(cycle)

**** BY # OF CANDIDATES SUPPORTED *******

* Candidates Supported by Firm in Cycle
egen totalcandidates = sum(constant), by(firm_cycle)

* Summary statistics for candidates supported by firm in cycle (full sample)
su totalcandidates, detail

* <= 5 Candidates Supported by Firm in Cycle
areg CR_minus1_1 victory rv rv_victory if abs(rv) < .05 & !mi(CAR_minus1_1) & totalcandidates <= 5, absorb(constant) cluster(cycle)
* 6-50 Candidates Supported by Firm in Cycle
areg CR_minus1_1 victory rv rv_victory if abs(rv) < .05 & !mi(CAR_minus1_1) & totalcandidates >= 6 & totalcandidates <= 50, absorb(constant) cluster(cycle)
* >50 Candidates Supported by Firm in Cycle
areg CR_minus1_1 victory rv rv_victory if abs(rv) < .05 & !mi(CAR_minus1_1) & totalcandidates > 50, absorb(constant) cluster(cycle)


* By Quartiles
* 1st quartile (Less than 34 candidates supported in cycle)
areg CR_minus1_1 victory rv rv_victory if abs(rv) < .05 & !mi(CAR_minus1_1) & totalcandidates<34, absorb(constant) cluster(cycle)
* 2nd quartile (Between 34 and 84 candidates supported in cycle)
areg CR_minus1_1 victory rv rv_victory if abs(rv) < .05 & !mi(CAR_minus1_1) & totalcandidates>=34 & totalcandidates<84, absorb(constant) cluster(cycle)
* 3rd quartile (Between 84 and 227 candidates supported in cycle)
areg CR_minus1_1 victory rv rv_victory if abs(rv) < .05 & !mi(CAR_minus1_1) & totalcandidates>=84 & totalcandidates<227, absorb(constant) cluster(cycle)
* 4th quartile (More than 227 candidates supported in cycle)
areg CR_minus1_1 victory rv rv_victory if abs(rv) < .05 & !mi(CAR_minus1_1) & totalcandidates>=227, absorb(constant) cluster(cycle)


**** BY SHARE OF SAME-CYCLE DONATIONS GIVEN TO DEMS *******

* Frac to dem in cycle
egen number_supp = sum(constant), by(firm cycle)
egen number_dem  = sum(dem), by(firm cycle)
gen frac_dem_supp = number_dem/number_supp

* < 1/3 to Dem in cycle
areg CR_minus1_1 victory rv rv_victory if abs(rv) < .05 & !mi(CAR_minus1_1) & frac_dem_supp <= 1/3, absorb(constant) cluster(cycle)
* 1/3 < x < 2/3 to Dem in cycle
areg CR_minus1_1 victory rv rv_victory if abs(rv) < .05 & !mi(CAR_minus1_1) & frac_dem_supp > 1/3 & frac_dem_supp < 2/3, absorb(constant) cluster(cycle)
* > 1/2 to Dem in cycle
areg CR_minus1_1 victory rv rv_victory if abs(rv) < .05 & !mi(CAR_minus1_1) & frac_dem_supp >= 2/3, absorb(constant) cluster(cycle)

**** BY # OF FIRMS SUPPORTING THE WINNER *******

* Number of firms supporting the winner
egen num_f_win = sum(victory), by(election)

* 1 firm supported the winner
areg CR_minus1_1 victory rv rv_victory if abs(rv) < .05 & !mi(CAR_minus1_1) & num_f_win == 1, absorb(constant) cluster(cycle)
* 2-4 firms supported the winner 
areg CR_minus1_1 victory rv rv_victory if abs(rv) < .05 & !mi(CAR_minus1_1) & num_f_win < 5 & num_f_win > 1, absorb(constant) cluster(cycle)
* 5 <= x < 15 firms supported the winner
areg CR_minus1_1 victory rv rv_victory if abs(rv) < .05 & !mi(CAR_minus1_1) & num_f_win >= 5 & num_f_win < 15, absorb(constant) cluster(cycle)
* >= 15 firms supported the winner
areg CR_minus1_1 victory rv rv_victory if abs(rv) < .05 & !mi(CAR_minus1_1) & num_f_win >= 15, absorb(constant) cluster(cycle)

**** BY CONTROL OF CHAMBER *******

* Winner will belong to majority party in chamber
areg CR_minus1_1 victory rv rv_victory if abs(rv) < .05 & !mi(CAR_minus1_1) & winner_control==1, absorb(constant) cluster(cycle)
* Winner will belong to minority party in chamber
areg CR_minus1_1 victory rv rv_victory if abs(rv) < .05 & !mi(CAR_minus1_1) & winner_control==0, absorb(constant) cluster(cycle)

**** BY INCUMBENCY STATUS OF SUPPORTED CANDIDATES *******

g incumbent = dem == 1 & deminc == 1
replace incumbent = 1 if dem == 0 & repinc == 1
g challenger = dem == 1 & repinc == 1
replace challenger = 1 if dem == 0 & deminc == 1
replace challenger = 1 if deminc == 0 & repinc == 0

areg CR_minus1_1 victory rv rv_victory if abs(rv) < .05 & !mi(CAR_minus1_1) & incumbent == 1, absorb(constant) vce(cluster cycle) 
areg CR_minus1_1 victory rv rv_victory if abs(rv) < .05 & !mi(CAR_minus1_1) & challenger == 1, absorb(constant) vce(cluster cycle) 


********************************************************************************
********* APPENDIX TABLE A.10: TABLE 2 WITH FAMA-FRENCH CAR(-1, 1)  ************
********************************************************************************

use "qpq_main_dataset", clear

* Calculate money donated by firm to candidate
g totaldollars_cand = totalrep
replace totaldollars_cand = totaldem if dem==1

* Sectors
g sector = "other"
replace sector = "agri_mining" if siccd > 99 & siccd < 1500
replace sector = "construction" if siccd > 1499 & siccd < 1800
replace sector = "manufacturing" if siccd > 1999 & siccd < 4000
replace sector = "trans_elec" if siccd > 3999 & siccd < 5000
replace sector = "whole_ret_trade" if siccd > 4999 & siccd < 6000
replace sector = "finance" if siccd > 5999 & siccd < 6800
replace sector = "services" if siccd > 6999 & siccd < 9000
replace sector = "public_adm" if siccd > 9099 & siccd < 9730
g other = sector != "finance" & sector != "manufacturing" & sector != "trans_elec"

* Number of other winners supported by firm in cycle
egen otherwinners = sum(victory), by(firm_cycle)
replace otherwinners = otherwinners - victory

* Full Sample
areg CAR_ff_minus1_1 victory rv rv_victory if abs(rv) < .05, absorb(constant) cluster(cycle)

* Donut
areg CAR_ff_minus1_1 victory rv rv_victory if abs(rv) < .05 & abs(rv) > .001, absorb(constant) cluster(cycle)

**** BY OFFICE *******

* Governors
areg CAR_ff_minus1_1 victory rv rv_victory if abs(rv) < .05 & setting == "gov", absorb(constant) cluster(cycle)
* U.S. Senate
areg CAR_ff_minus1_1 victory rv rv_victory if abs(rv) < .05 & setting == "senate", absorb(constant) cluster(cycle)
* U.S. House
areg CAR_ff_minus1_1 victory rv rv_victory if abs(rv) < .05 & setting == "house", absorb(constant) cluster(cycle)
* State Senate
areg CAR_ff_minus1_1 victory rv rv_victory if abs(rv) < .05 & setting == "stlegupper", absorb(constant) cluster(cycle)
* State House
areg CAR_ff_minus1_1 victory rv rv_victory if abs(rv) < .05 & setting == "stleglower", absorb(constant) cluster(cycle)

**** BY DONATION SIZE *******

* Donations >= $500
areg CAR_ff_minus1_1 victory rv rv_victory if abs(rv) < .05 & totaldollars_cand >= 500, absorb(constant) cluster(cycle)
* Donations >= $1000
areg CAR_ff_minus1_1 victory rv rv_victory if abs(rv) < .05 & totaldollars_cand >= 1000, absorb(constant) cluster(cycle)
* Donations >= $2500
areg CAR_ff_minus1_1 victory rv rv_victory if abs(rv) < .05 & totaldollars_cand >= 2500, absorb(constant) cluster(cycle)

**** BY FIRM VALUE *******

* < 200 M
areg CAR_ff_minus1_1 victory rv rv_victory if abs(rv) < .05 & market_cap < 200 & market_cap != ., absorb(constant) cluster(cycle)
* 200M-1B
areg CAR_ff_minus1_1 victory rv rv_victory if abs(rv) < .05 & market_cap >= 200 & market_cap <= 1000 & market_cap != ., absorb(constant) cluster(cycle)
* 1-5B
areg CAR_ff_minus1_1 victory rv rv_victory if abs(rv) < .05 & market_cap > 1000 & market_cap <= 5000 & market_cap != ., absorb(constant) cluster(cycle)
* > 5B
areg CAR_ff_minus1_1 victory rv rv_victory if abs(rv) < .05 & market_cap >= 5000 & market_cap != ., absorb(constant) cluster(cycle)

**** BY SECTOR *******

* Manufacturing (Division D)
areg CAR_ff_minus1_1 victory rv rv_victory if abs(rv) < .05 & sector == "manufacturing", absorb(constant) cluster(cycle)
* Transportation (Division E)
areg CAR_ff_minus1_1 victory rv rv_victory if abs(rv) < .05 & sector == "trans_elec", absorb(constant) cluster(cycle)
* Finance (Division H)
areg CAR_ff_minus1_1 victory rv rv_victory if abs(rv) < .05 & sector == "finance", absorb(constant) cluster(cycle)
* Other Industry
areg CAR_ff_minus1_1 victory rv rv_victory if abs(rv) < .05 & other == 1, absorb(constant) cluster(cycle)

**** PRE-POST CITIZENS UNITED *******

* Pre Citizens United (<2010)
areg CAR_ff_minus1_1 victory rv rv_victory if abs(rv) < .05 & year < 2010, absorb(constant) cluster(cycle)
* Post Citizens United (2010)
areg CAR_ff_minus1_1 victory rv rv_victory if abs(rv) < .05 & year == 2010, absorb(constant) 

**** BY # OF OTHER WINNERS SUPPORTED *******

* 0 Other Winners Supported by Firm in Cycle
areg CAR_ff_minus1_1 victory rv rv_victory if abs(rv) < .05 & otherwinners == 0, absorb(constant) cluster(cycle)

* 1-5 Other Winners Supported by Firm in Cycle
areg CAR_ff_minus1_1 victory rv rv_victory if abs(rv) < .05 & otherwinners >= 1 & otherwinners <= 5, absorb(constant) cluster(cycle)

* 6-10 Other Winners Supported by Firm in Cycle
areg CAR_ff_minus1_1 victory rv rv_victory if abs(rv) < .05 & otherwinners >= 6 & otherwinners <= 10, absorb(constant) cluster(cycle)

* 11-20 Other Winners Supported by Firm in Cycle
areg CAR_ff_minus1_1 victory rv rv_victory if abs(rv) < .05 & otherwinners >= 11 & otherwinners <= 20, absorb(constant) cluster(cycle)

* 21-100 Other Winners Supported by Firm in Cycle
areg CAR_ff_minus1_1 victory rv rv_victory if abs(rv) < .05 & otherwinners >= 21 & otherwinners <= 100, absorb(constant) cluster(cycle)

* > 100 Other Winners Supported by Firm in Cycle
areg CAR_ff_minus1_1 victory rv rv_victory if abs(rv) < .05 & otherwinners > 100, absorb(constant) cluster(cycle)

**** BY # OF CANDIDATES SUPPORTED *******

* Candidates Supported by Firm in Cycle
egen totalcandidates = sum(constant), by(firm_cycle)

* Summary statistics for candidates supported by firm in cycle (full sample)
su totalcandidates, detail

* < 5 Candidates Supported by Firm in Cycle
areg CAR_ff_minus1_1 victory rv rv_victory if abs(rv) < .05 & totalcandidates < 6, absorb(constant) cluster(cycle)
* < 5 Candidates Supported by Firm in Cycle
areg CAR_ff_minus1_1 victory rv rv_victory if abs(rv) < .05 & totalcandidates >= 6 & totalcandidates < 51, absorb(constant) cluster(cycle)
* > 50 Candidates Supported by Firm in Cycle
areg CAR_ff_minus1_1 victory rv rv_victory if abs(rv) < .05 & totalcandidates > 50, absorb(constant) cluster(cycle)

* By Quartiles
* 1st quartile (Less than 34 candidates supported in cycle)
areg CAR_ff_minus1_1 victory rv rv_victory if abs(rv) < .05 & totalcandidates<34, absorb(constant) cluster(cycle)
* 2nd quartile (Between 34 and 84 candidates supported in cycle)
areg CAR_ff_minus1_1 victory rv rv_victory if abs(rv) < .05 & totalcandidates>=34 & totalcandidates<84, absorb(constant) cluster(cycle)
* 3rd quartile (Between 84 and 227 candidates supported in cycle)
areg CAR_ff_minus1_1 victory rv rv_victory if abs(rv) < .05 & totalcandidates>=84 & totalcandidates<227, absorb(constant) cluster(cycle)
* 4th quartile (More than 227 candidates supported in cycle)
areg CAR_ff_minus1_1 victory rv rv_victory if abs(rv) < .05 & totalcandidates>=227, absorb(constant) cluster(cycle)

**** BY SHARE OF SAME-CYCLE DONATIONS GIVEN TO DEMS *******

* Frac to dem in cycle
egen number_supp = sum(constant), by(firm cycle)
egen number_dem  = sum(dem), by(firm cycle)
gen frac_dem_supp = number_dem/number_supp

* < 1/3 to Dem in cycle
areg CAR_ff_minus1_1 victory rv rv_victory if abs(rv) < .05 & frac_dem_supp <= 1/3, absorb(constant) cluster(cycle)
* 1/3 < x < 2/3 to Dem in cycle
areg CAR_ff_minus1_1 victory rv rv_victory if abs(rv) < .05 & frac_dem_supp > 1/3 & frac_dem_supp < 2/3, absorb(constant) cluster(cycle)
* > 1/2 to Dem in cycle
areg CAR_ff_minus1_1 victory rv rv_victory if abs(rv) < .05 & frac_dem_supp >= 2/3, absorb(constant) cluster(cycle)

**** BY # OF FIRMS SUPPORTING THE WINNER *******

* Number of firms supporting the winner
egen num_f_win = sum(victory), by(election)

* 1 firm supported the winner
areg CAR_ff_minus1_1 victory rv rv_victory if abs(rv) < .05 & num_f_win == 1, absorb(constant) cluster(cycle)

* 2-4 firms supported the winner 
areg CAR_ff_minus1_1 victory rv rv_victory if abs(rv) < .05 & num_f_win < 5 & num_f_win > 1, absorb(constant) cluster(cycle)

* 5 <= x < 15 firms supported the winner
areg CAR_ff_minus1_1 victory rv rv_victory if abs(rv) < .05 & num_f_win >= 5 & num_f_win < 15, absorb(constant) cluster(cycle)

* >= 15 firms supported the winner
areg CAR_ff_minus1_1 victory rv rv_victory if abs(rv) < .05 & num_f_win >= 15, absorb(constant) cluster(cycle)

**** BY CONTROL OF CHAMBER *******

* Winner will belong to majority party in chamber
areg CAR_ff_minus1_1 victory rv rv_victory if abs(rv) < .05 & winner_control==1, absorb(constant) cluster(cycle)
* Winner will belong to minority party in chamber
areg CAR_ff_minus1_1 victory rv rv_victory if abs(rv) < .05 & winner_control==0, absorb(constant) cluster(cycle)

**** BY INCUMBENCY STATUS OF SUPPORTED CANDIDATES *******

g incumbent = dem == 1 & deminc == 1
replace incumbent = 1 if dem == 0 & repinc == 1
g challenger = dem == 1 & repinc == 1
replace challenger = 1 if dem == 0 & deminc == 1
replace challenger = 1 if deminc == 0 & repinc == 0

areg CAR_ff_minus1_1 victory rv rv_victory if abs(rv) < .05 & incumbent == 1, absorb(constant) vce(cluster cycle) 
areg CAR_ff_minus1_1 victory rv rv_victory if abs(rv) < .05 & challenger == 1, absorb(constant) vce(cluster cycle) 
