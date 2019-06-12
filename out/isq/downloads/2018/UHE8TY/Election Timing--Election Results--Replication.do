* 11-5-11
* Estimates the probability of an election for the "Flexible Election Timing and International Conflict" ISQ.

* NOTE: the "inre" program must be ran before running the rest of the do file.
* Run this do file first.  It creates a data set ("Election Hazard--Logit Clarify.dta") containing the predicted probabilities of an election (first stage).  
* Next, run the "Election Timing--Conflict--Replication.do" file to estimate the conflict models (second stage).

******************************************************************************
*** Program to automate in-sample predictions for logit (Clarify) by country.
******************************************************************************
capture program drop inre
program define inre 
syntax, n(real) model(string)
	qui logit `model'
	local obs = e(N)
	quietly foreach i of numlist 1(1)1000 {
		gen pr_`i' = .
	}
	quietly {
		preserve
			keep if e(sample)
			estsimp logit `model'
			foreach x of numlist 1(1)`obs' {
				setx [`x']
				simqi, prval(1) genpr(v_`x')
				foreach i of numlist 1(1)1000 {
					replace pr_`i' = v_`x'[`i'] in `x'
				}
				drop v_`x'
			}
			keep ccode ts failure pr_* 
			keep in 1/`obs'
			save cc`n'.dta, replace
		restore
	}
	drop pr_1 - pr_1000
end

****************************************************************************************************************************
* Estimate the probability of an election.
****************************************************************************************************************************
cd "C:\Users\\$D\Documents\Research\Projects\Election Cycles and Conflict\Midwest 2011\TeX\ISQ\Final Submission\Replication\"
use "Election Timing.dta", clear

gen full_sample = .
replace full_sample = 1 if (year>=1960 & year<=2001) & (ccode== 20 | ccode== 200 | ccode== 205 | ccode== 210 | ccode== 211 | ccode== 220 | ccode== 225 | ccode== 230 | ccode== 235 | ccode== 255 | ccode== 305 | ccode== 325 | ccode== 350 | ccode== 375 | ccode== 380 | ccode== 385 | ccode== 390 | ccode== 395 | ccode== 666 | ccode== 740 | ccode== 900 | ccode== 920)

gen fullnois_sample = .
replace fullnois_sample = 1 if (year>=1960 & year<=2001) & (ccode== 20 | ccode== 200 | ccode== 205 | ccode== 210 | ccode== 211 | ccode== 220 | ccode== 225 | ccode== 230 | ccode== 235 | ccode== 255 | ccode== 305 | ccode== 325 | ccode== 350 | ccode== 375 | ccode== 380 | ccode== 385 | ccode== 390 | ccode== 395 | ccode== 740 | ccode== 900 | ccode== 920)

gen th_sample = .
replace th_sample = 1 if (year>=1960 & year<=2001) & (ccode== 20 | ccode== 200 | ccode== 205 | ccode== 210 | ccode== 211 | ccode== 220 | ccode== 230 | ccode== 235 | ccode== 255 | ccode== 305 | ccode== 325 | ccode== 350 | ccode== 375 | ccode== 390 | ccode== 395 | ccode== 666 | ccode== 740 | ccode== 900 | ccode== 920)

gen nois_sample = .
replace nois_sample = 1 if (year>=1960 & year<=2001) & (ccode== 20 | ccode== 200 | ccode== 205 | ccode== 210 | ccode== 211 | ccode== 220 | ccode== 230 | ccode== 235 | ccode== 255 | ccode== 305 | ccode== 325 | ccode== 350 | ccode== 375 | ccode== 390 | ccode== 395 | ccode== 740 | ccode== 900 | ccode== 920)

sort ccode intime
replace endtime = (intime + 1) if (ccode==ccode[_n+1] & intime==intime[_n+1]) & failure==1
replace intime = (intime + 2) if (ccode==ccode[_n-1] & intime==intime[_n-1])

stset endtime, id(id) failure(failure==1) origin(time intime) scale(365.25)

global S "if nois_sample==1"
global St "nois_sample"

cd "C:\Users\\$D\Documents\Research\Projects\Election Cycles and Conflict\Midwest 2011\TeX\ISQ\Final Submission\Replication\"


* Estimate the logit on each country
* Australia
logit failure sing_party eff_par ts_call rgdppc_growth ciep_perc ts_govt if ccode == 900, nolog

* Austria
logit failure majority sing_party eff_par ts_call rgdppc_growth ciep_perc ts_govt if ccode == 305, nolog

* Belgium
logit failure eff_par ts_call rgdppc_growth ciep_perc ts_govt if ccode == 211, nolog

* Canada
logit failure majority eff_par ts_call rgdppc_growth ciep_perc maj_ciep_perc ts_govt if ccode == 20, nolog

* Denmark 
logit failure majority sing_party eff_par ts_call rgdppc_growth ciep_perc ts_govt if ccode == 390, nolog

* Finland
logit failure majority sing_party eff_par ts_call rgdppc_growth ciep_perc ts_govt if ccode == 375, nolog

* France
logit failure majority sing_party eff_par ts_call rgdppc_growth ciep_perc ts_govt if ccode == 220, nolog

* Germany
logit failure eff_par ts_call rgdppc_growth ciep_perc ts_govt if ccode == 255, nolog

* Great Britain
logit failure eff_par ts_call rgdppc_growth ciep_perc ts_govt if ccode == 200, nolog

* Greece 
logit failure majority sing_party eff_par ts_call rgdppc_growth ciep_perc ts_govt if ccode == 350, nolog

* Iceland
logit failure majority eff_par ts_call rgdppc_growth ciep_perc ts_govt if ccode == 395, nolog

* Ireland
logit failure majority sing_party eff_par ts_call rgdppc_growth ciep_perc maj_ciep_perc ts_govt if ccode == 205, nolog

* Italy 
logit failure majority sing_party eff_par ts_call rgdppc_growth ciep_perc ts_govt if ccode == 325, nolog

* Japan
logit failure majority sing_party eff_par ts_call rgdppc_growth ciep_perc ts_govt if ccode == 740, nolog

* Netherlands
logit failure majority eff_par ts_call rgdppc_growth ciep_perc ts_govt if ccode == 210, nolog

* New Zealand
logit failure sing_party eff_par rgdppc_growth ciep_perc if ccode == 920, nolog

* Portugal 
logit failure majority sing_party eff_par rgdppc_growth ciep_perc ts_govt if ccode == 235, nolog

* Spain
logit failure majority eff_par ts_call rgdppc_growth ciep_perc ts_govt if ccode == 230, nolog

********************************************
* Median duration and number of failures per country.
********************************************
preserve
	keep if e(sample)
	keep if failure==1
	bys ccode: sum _t, det
	bys majority: sum _t, det
restore

preserve
	keep if e(sample)
	keep if failure==1
	collapse (count) number=failure, by(ccode)
	list ccode number
restore

preserve
	keep if e(sample)
	collapse (sum) failure
	list
restore

preserve
	keep if e(sample)
	keep if failure == 1
	collapse (median) med_dur = _t
	list
restore

********************************************
* Descriptive statistics.
********************************************
preserve
	keep if e(sample)
	sum pm_diss constrained_diss pres_diss majority caretaker sing_party maj_sing eff_par ts_call rgdppc_growth ciep_perc maj_ciep_perc ts_govt maj_ts_govt ciep_4 ciep_5 ciep_perc_4 ciep_perc_5
	tab majority
	tab caretaker
	tab sing_party
	tab ciep_4
	tab ciep_5
	tab pm_diss
	tab constrained_diss
	tab pres_diss
	tab failure
	collapse (min) min_time=ts (max) max_time=ts (count) obs=govtseq (sum) failure, by(ccode)
	list ccode min_time max_time failure obs
restore

*** Election Timing Model
* Use clarify to generate 1000 in-sample predictions of each observation (with the "inre" code produced above), by country (Correlates of War country code).
*20
global M "failure majority eff_par ts_call rgdppc_growth ciep_perc maj_ciep_perc ts_govt if ccode == 20"
inre, n(20) model($M)

* 200 
global M "failure eff_par ts_call rgdppc_growth ciep_perc ts_govt if ccode == 200"
inre, n(200) model($M)

* 205
global M "failure majority sing_party maj_sing eff_par ts_call rgdppc_growth ciep_perc maj_ciep_perc ts_govt maj_ts_govt if ccode == 205"
inre, n(205) model($M)

* 210
global M "failure majority eff_par ts_call rgdppc_growth ciep_perc ts_govt if ccode == 210"
inre, n(210) model($M)

* 211
global M "failure eff_par ts_call rgdppc_growth ciep_perc ts_govt if ccode == 211"
inre, n(211) model($M)

* 220
global M "failure majority sing_party eff_par ts_call rgdppc_growth ciep_perc ts_govt if ccode == 220"
inre, n(220) model($M)

* 230
global M "failure majority eff_par ts_call rgdppc_growth ciep_perc ts_govt if ccode == 230"
inre, n(230) model($M)

* 235 
global M "failure majority sing_party eff_par rgdppc_growth ciep_perc ts_govt if ccode == 235"
inre, n(235) model($M)

* 255
global M "failure eff_par ts_call rgdppc_growth ciep_perc ts_govt if ccode == 255"
inre, n(255) model($M)

* 305 
global M "failure majority sing_party eff_par ts_call rgdppc_growth ciep_perc ts_govt if ccode == 305"
inre, n(305) model($M)

* 325 
global M "failure majority sing_party eff_par ts_call rgdppc_growth ciep_perc ts_govt if ccode == 325"
inre, n(325) model($M)

* 350 
global M "failure majority sing_party eff_par ts_call rgdppc_growth ciep_perc ts_govt if ccode == 350"
inre, n(350) model($M)

* 375
global M "failure majority sing_party eff_par ts_call rgdppc_growth ciep_perc ts_govt if ccode == 375"
inre, n(375) model($M)

* 390 
global M "failure majority sing_party eff_par ts_call rgdppc_growth ciep_perc ts_govt if ccode == 390"
inre, n(390) model($M)

* 395
global M "failure majority eff_par ts_call rgdppc_growth ciep_perc ts_govt if ccode == 395"
inre, n(395) model($M)

* 740
global M "failure majority sing_party eff_par ts_call rgdppc_growth ciep_perc ts_govt if ccode == 740"
inre, n(740) model($M)

* 900
global M "failure sing_party eff_par ts_call rgdppc_growth ciep_perc ts_govt if ccode == 900"
inre, n(900) model($M)

*920
global M "failure majority sing_party maj_sing eff_par rgdppc_growth ciep_perc if ccode == 920"
inre, n(920) model($M)

*** Put all these individual-country data sets into a master data set.
use cc20.dta, clear
foreach i of numlist 200 205 210 211 220 230 235 255 305 325 350 375 390 395 740 900 920 {
	append using cc`i'.dta
}

*** Create the future election hazard and save the data set.
preserve
	quietly {
		collapse (max) failure (sum) pr_*, by(ccode ts)
		tsset ccode ts
		foreach i of varlist pr_* {
			recode `i' (0=.) 
			recode `i' (1.0/max=1)
			by ccode: gen past_`i'_1 = L.`i'
			by ccode: gen future_`i'_1 = F.`i'
		}
		sort ccode ts
		save "Election Hazard--Logit Clarify.dta", replace
	}
restore

********************************************
* Model Fit
********************************************
preserve
	use "Election Hazard--Logit Clarify.dta", clear
	capture drop pr_mean pr_fail
	egen pr_mean = rowmean(pr_1 - pr_1000)
	gen pr_fail = pr_mean
	recode pr_fail (0/.2999=0) (.30000/1=1)
	tab2 pr_fail failure
	di 2776/3006 /* Modal fit */
	di (2720+193)/3006 /* Model fit */
	di 193/249 /* Percent correct when I predict fail */
	di 193/230 /* Percentage of failures correctly predicted */
restore

