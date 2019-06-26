**************************************
***** Replication Do-File for:
***** The Build-up of Coercive Capacities: Arms Imports and the Outbreak of Violent Intrastate Conflicts
***** Oliver Pamp,  Lukas Rudolph, Paul W. Thurner, Andreas Mehltretter, Simon Primus
**************************************


***** Load dataset
*cd "PATH/TO/DATASET/"

capture log close _all
log using Pamp_et_al_2017.log, name("Replication of Pamp et al 2017")
set linesize 255
use Pamp_et_al_2017.dta


**Note that there have been some coding errors in the miltary expenditure values for Haiti, Somalia and Cuba. The data set provided for replication has been updated to contain the correct values. As a result, there are some minor differences in some coefficient sizes compared to the results presented in the article.



***** TABLE II: Instrumental Variable Probit Regression: Weapon Imports and Onsets

ivprobit /// 
onset ///
///
(logimports = logimports_unrelated) /// 
, twostep

ivprobit /// 
onset ///
  onset_last5y loggdppc logpop redistr mid anoc logmountain noncontiguous instability capacity excl_pop   t t2 t3 ///
(logimports = logimports_unrelated) /// 
, twostep

ivprobit /// 
onset ///
///
(logimports_avg5 = logimports_unrelated_avg5) /// 
, twostep

ivprobit /// 
onset ///
  onset_last5y loggdppc logpop redistr mid anoc logmountain noncontiguous instability capacity excl_pop   t t2 t3 ///
(logimports_avg5 = logimports_unrelated_avg5) /// 
, twostep



***** TABLE III: Second Stage Results of SEM: Onsets

cdsimeq (logimports logimports_unrelated logmilex logexport loggdppc  west eastern_europe latin_america subsaharan_africa asia capacity) ///
 (onset  onset_last5y loggdppc logpop redistr mid anoc logmountain noncontiguous instability capacity excl_pop   t t2 t3)
 
cdsimeq (logimports_avg5 logimports_unrelated_avg5 logmilex logexport loggdppc  west eastern_europe latin_america subsaharan_africa asia capacity) ///
 (onset  onset_last5y loggdppc logpop redistr mid anoc logmountain noncontiguous instability capacity excl_pop   t t2 t3)
 
cdsimeq (logimports_avg10 logimports_unrelated_avg10 logmilex logexport loggdppc  west eastern_europe latin_america subsaharan_africa asia capacity) ///
 (onset  onset_last5y loggdppc logpop redistr mid anoc logmountain noncontiguous instability capacity excl_pop   t t2 t3)
 

***** TABLE IV: Marginal effects of Arms Imports on Conflict Onset in Different Scenarios

* logimports

	capture drop I_*
	capture _estimates unhold model_1
	capture _estimates unhold model_2

	cdsimeq (logimports logimports_unrelated logmilex logexport loggdppc  west eastern_europe latin_america subsaharan_africa asia capacity) (onset  onset_last5y loggdppc logpop redistr mid anoc logmountain noncontiguous instability capacity excl_pop   t t2 t3), estimates_hold

	_estimates unhold model_2

	// High Risk
	mfx, dydx at(onset_last5y=1 anoc=1  instability=1 noncontiguous=0 redistr=.9306297 excl_pop=0.458 capacity=0.478 logmountain=3.985273 loggdppc=11.33362 mid=4)

	// Low Risk
	mfx, dydx at(onset_last5y=0 anoc=0  instability=0 noncontiguous=1 redistr=16.62126 excl_pop=0 capacity=1.495 logmountain=0 loggdppc=14.60336 mid=0)

	// Angola
	mfx, dydx at(onset_last5y=0.5 anoc=.5897  instability=.111 noncontiguous=1 redistr=2.805 excl_pop=0.62 capacity= 1.782 logmountain=2.370244 loggdppc=12.60593 mid=0)


* logimports 5 year

	capture drop I_*
	capture _estimates unhold model_1
	capture _estimates unhold model_2

	cdsimeq (logimports_avg5 logimports_unrelated_avg5 logmilex logexport loggdppc  west eastern_europe latin_america subsaharan_africa asia capacity) (onset  onset_last5y loggdppc logpop redistr mid anoc logmountain noncontiguous instability capacity excl_pop   t t2 t3), estimates_hold

	_estimates unhold model_2

	// High Risk
	mfx, dydx at(onset_last5y=1 anoc=1  instability=1 noncontiguous=0 redistr=.9306297 excl_pop=0.458 capacity=0.478 logmountain=3.985273 loggdppc=11.33362 mid=4)

	// Low Risk
	mfx, dydx at(onset_last5y=0 anoc=0  instability=0 noncontiguous=1 redistr=16.62126 excl_pop=0 capacity=1.495  logmountain=0 loggdppc=14.60336 mid=0)

	// Angola
	mfx, dydx at(onset_last5y=0.5 anoc=.5897  instability=.111 noncontiguous=1 redistr=2.805 excl_pop=0.62 capacity= 1.782 logmountain=2.370244 loggdppc=12.60593 mid=0)


* logimports 10 year

	capture drop I_*
	capture _estimates unhold model_1
	capture _estimates unhold model_2

	cdsimeq (logimports_avg10 logimports_unrelated_avg5 logmilex logexport loggdppc  west eastern_europe latin_america subsaharan_africa asia capacity) (onset  onset_last5y loggdppc logpop redistr mid anoc logmountain noncontiguous instability capacity excl_pop   t t2 t3), estimates_hold

	_estimates unhold model_2

	// High Risk
	mfx, dydx at(onset_last5y=1 anoc=1  instability=1 noncontiguous=0 redistr=.9306297 excl_pop=0.458 capacity=0.478 logmountain=3.985273 loggdppc=11.33362 mid=4)

	// Low Risk
	mfx, dydx at(onset_last5y=0 anoc=0  instability=0 noncontiguous=1 redistr=16.62126 excl_pop=0 capacity=1.495 logmountain=0 loggdppc=14.60336 mid=0)

	// Angola
	mfx, dydx at(onset_last5y=0.5 anoc=.5897  instability=.111 noncontiguous=1 redistr=2.805 excl_pop=0.62 capacity=1.782 logmountain=2.370244 loggdppc=12.60593 mid=0)

eststo clear
ereturn clear
capture drop I_*
capture _estimates unhold model_1
capture _estimates unhold model_2



***** Figure I: Predicted probabilities of yearly arms imports in high risk and low risk scenarios

ivprobit onset onset_last5y loggdppc logpop redistr mid anoc logmountain noncontiguous instability capacity excl_pop t t2 t3 (logimports = logimports_unrelated)

margins if logimports, at(logimports=(0(1)14) onset_last5y=1 anoc=1  instability=1 noncontiguous=0 redistr=.9306297 excl_pop=0.458 capacity=0.478 logmountain=3.985273 loggdppc=11.33362 mid=4) noatlegend atmeans predict(pr) saving(graph1, replace) noci
margins if logimports, at(logimports=(0(1)14) onset_last5y=0 anoc=0  instability=0 noncontiguous=1 redistr=16.62126 excl_pop=0 capacity=1.495  logmountain=0 loggdppc=14.60336 mid=0) noatlegend atmeans predict(pr) saving(graph2, replace) noci

combomarginsplot graph1 graph2, noci scheme(s1mono) labels("High Risk Scenario" "Low Risk Scenario")


***** TABLE A1: Second Stage Results of SEM: Imports

cdsimeq (logimports logimports_unrelated logmilex logexport loggdppc  capacity west eastern_europe latin_america subsaharan_africa asia) ///
 (onset  onset_last5y loggdppc logpop redistr mid anoc logmountain noncontiguous instability capacity excl_pop   t t2 t3)

cdsimeq (logimports_avg5 logimports_unrelated_avg5 logmilex logexport loggdppc  capacity west eastern_europe latin_america subsaharan_africa asia) ///
 (onset  onset_last5y loggdppc logpop redistr mid anoc logmountain noncontiguous instability capacity excl_pop   t t2 t3)

cdsimeq (logimports_avg10 logimports_unrelated_avg10 logmilex logexport loggdppc  capacity west eastern_europe latin_america subsaharan_africa asia) ///
 (onset  onset_last5y loggdppc logpop redistr mid anoc logmountain noncontiguous instability capacity excl_pop   t t2 t3)


***** TABLE A2: Summary of Robustness Tests
* See references to other tables


***** TABLE A3: First stage results: Influence of unrelated on civil-war-related major conventional weapons imports

local onset = "onset_last5y loggdppc logpop redistr mid anoc logmountain noncontiguous instability capacity excl_pop  t t2 t3"
local imports = "logmilex logexport  west eastern_europe latin_america subsaharan_africa asia"

* logimports
reg logimports logimports_unrelated , r
reg logimports logimports_unrelated `onset', r
reg logimports logimports_unrelated `onset' `imports', r

* logimports 5 year
reg logimports_avg5 logimports_unrelated_avg5, r
reg logimports_avg5 logimports_unrelated_avg5 `onset', r
reg logimports_avg5 logimports_unrelated_avg5 `onset' `imports',  r

* logimports 10 year
reg logimports_avg10 logimports_unrelated_avg10, r
reg logimports_avg10 logimports_unrelated_avg10 `onset', r
reg logimports_avg10 logimports_unrelated_avg10 `onset' `imports',  r


***** TABLE A4: SEM model with and without control for civil-war-unrelated arms

cdsimeq (logimports  logmilex logexport loggdppc  west eastern_europe latin_america subsaharan_africa asia capacity) ///
 (onset  onset_last5y loggdppc logpop redistr mid anoc logmountain noncontiguous instability capacity excl_pop t t2 t3)

cdsimeq (logimports  logmilex logexport loggdppc  west eastern_europe latin_america subsaharan_africa asia capacity) ///
 (onset logimports_unrelated onset_last5y loggdppc logpop redistr mid anoc logmountain noncontiguous instability capacity excl_pop t t2 t3)


***** TABLE A5: SEM with less restrictive specifications

* Baseline

	// contained in both
	local both = "loggdppc capacity"
	local imports = "logmilex logexport   west eastern_europe latin_america subsaharan_africa asia "
	local onset = "onset_last5y  logpop redistr mid anoc logmountain noncontiguous instability excl_pop   t t2 t3" 
 
	// modified
	local endog_imports = ""
	local endog_onset = ""   
 
	cdsimeq (logimports_avg5 logimports_unrelated_avg5 `both' `imports') ///
	 (onset `both' `onset')
 
* SEM Variant 1

	// contained in both
	local both = "loggdppc capacity"
	local imports = "logmilex logexport   west eastern_europe latin_america subsaharan_africa asia "
	local onset = "onset_last5y  logpop redistr mid anoc logmountain noncontiguous instability excl_pop   t t2 t3" 
 
	// modified
	local endog_imports = ""
	local endog_onset = ""   
 
	cdsimeq (logimports_avg5  `both' `imports' `endog_onset') ///
	 (onset `both' `onset' `endog_imports')
 
* SEM Variant 2

	// contained in both
	local both = "loggdppc capacity"
	local imports = "logmilex logexport west eastern_europe latin_america subsaharan_africa asia" // loggdppc2
	local onset = "onset_last5y  logpop redistr mid anoc logmountain noncontiguous instability excl_pop   t t2 t3" 
 
	// modified
	local endog_imports = "logmilex"
	local endog_onset = "onset_last5y mid instability"  

	cdsimeq (logimports_avg5 logimports_unrelated_avg5 `both' `imports' `endog_onset') ///
	 (onset `both' `onset' `endog_imports')
 
* SEM Variant 3

	// contained in both
	local both = "loggdppc capacity"
	local imports = "logmilex logexport   west eastern_europe latin_america subsaharan_africa asia " // loggdppc2
	local onset = "onset_last5y  logpop redistr mid anoc logmountain noncontiguous instability excl_pop   t t2 t3" 
 
	// modified
	local endog_imports = "logexport west eastern_europe latin_america subsaharan_africa asia"
	local endog_onset = "onset_last5y mid instability anoc logmountain noncontiguous  excl_pop t t2 t3 " ///   redistr   
 
	cdsimeq (logimports_avg5 logimports_unrelated_avg5 `both' `imports' `endog_onset') ///
	 (onset `both' `onset' `endog_imports')

	 
	 
***** TABLE A6: SEM with different weapons types

cdsimeq (logimports_avg5 logimports_unrelated_avg5 logmilex logexport loggdppc west eastern_europe latin_america subsaharan_africa asia capacity) ///
 (onset  onset_last5y loggdppc logpop redistr mid anoc logmountain noncontiguous instability capacity excl_pop   t t2 t3)
 
cdsimeq (logimports_alt_avg5 logimports_unrelated_avg5 logmilex logexport loggdppc west eastern_europe latin_america subsaharan_africa asia capacity) ///
 (onset  onset_last5y loggdppc logpop redistr mid anoc logmountain noncontiguous instability capacity excl_pop   t t2 t3)
 
cdsimeq (logimports_all_avg5  logmilex logexport loggdppc west eastern_europe latin_america subsaharan_africa asia capacity) ///
 (onset  onset_last5y loggdppc logpop redistr mid anoc logmountain noncontiguous instability capacity excl_pop   t t2 t3)
 

***** TABLE A7: Instrumental Variable 2sls Regression: Weapons Imports and Onsets

* Instrument: Unrelated weapons

	ivregress 2sls /// 
	onset ///
	(logimports_avg5 = logimports_unrelated_avg5)

	ivregress 2sls /// 
	onset ///
	onset_last5y loggdppc logpop redistr mid anoc logmountain noncontiguous instability capacity excl_pop   t t2 t3 ///
	(logimports_avg5 = logimports_unrelated_avg5)
	
* Instrument: SEM import variables

	ivregress 2sls ///
	onset ///
	(logimports_avg5 = logimports_unrelated_avg5 logmilex logexport loggdppc  west eastern_europe latin_america subsaharan_africa asia capacity)
	
	ivregress 2sls /// 
	onset ///
	onset_last5y loggdppc logpop redistr mid anoc logmountain noncontiguous instability capacity excl_pop   t t2 t3 ///
	(logimports_avg5 = logimports_unrelated_avg5 logmilex logexport loggdppc  west eastern_europe latin_america subsaharan_africa asia capacity)

	
***** TABLE A8: Instrumental Variable 2sls Regression: Weapons Imports and Onsets

* Normal se's

	ivregress 2sls /// 
	onset ///
	onset_last5y loggdppc logpop redistr mid anoc logmountain noncontiguous instability capacity excl_pop   t t2 t3 ///
	(logimports = logimports_unrelated)
	
	ivregress 2sls /// 
	onset ///
	onset_last5y loggdppc logpop redistr mid anoc logmountain noncontiguous instability capacity excl_pop   t t2 t3 ///
	(logimports_avg5 = logimports_unrelated_avg5)
	
* Robust se's

	ivregress 2sls /// 
	onset ///
	onset_last5y loggdppc logpop redistr mid anoc logmountain noncontiguous instability capacity excl_pop   t t2 t3 ///
	(logimports = logimports_unrelated) ///
	, vce(robust)
	
	ivregress 2sls /// 
	onset ///
	onset_last5y loggdppc logpop redistr mid anoc logmountain noncontiguous instability capacity excl_pop   t t2 t3 ///
	(logimports_avg5 = logimports_unrelated_avg5) ///
	, vce(robust)

* Country clustered se's

	ivregress 2sls /// 
	onset ///
	onset_last5y loggdppc logpop redistr mid anoc logmountain noncontiguous instability capacity excl_pop   t t2 t3 ///
	(logimports = logimports_unrelated) ///
	, vce(cluster cname)

	ivregress 2sls /// 
	onset ///
	onset_last5y loggdppc logpop redistr mid anoc logmountain noncontiguous instability capacity excl_pop   t t2 t3 ///
	(logimports_avg5 = logimports_unrelated_avg5) ///
	, vce(cluster cname)

	
***** TABLE A9: Fixed effects logit: Weapon Imports and Onsets

xtlogit onset onset_last5y logimports loggdppc logpop redistr mid anoc logmountain noncontiguous instability capacity excl_pop   t t2 t3 , fe 
xtlogit onset onset_last5y logimports logmilex loggdppc logpop redistr mid anoc logmountain noncontiguous instability capacity excl_pop   t t2 t3 , fe  

xtlogit onset onset_last5y logimports_avg5 loggdppc logpop redistr mid anoc logmountain noncontiguous instability capacity excl_pop   t t2 t3 , fe  
xtlogit onset onset_last5y logimports_avg5  logmilex loggdppc logpop redistr mid anoc logmountain noncontiguous instability capacity excl_pop   t t2 t3 , fe
	

***** TABLE A10: Alternative Operationalizations of Conflict Onset

* IV probit

	ivprobit /// 
	onset_alt ///
	(logimports_avg5 = logimports_unrelated_avg5) /// 
	, twostep
	
	ivprobit /// 
	onset_alt ///
	onset_last5y loggdppc logpop redistr mid anoc logmountain noncontiguous instability capacity excl_pop   t t2 t3 ///
	(logimports_avg5 = logimports_unrelated_avg5) /// 
	, twostep
	
	ivprobit /// 
	onset_zeros ///
	(logimports_avg5 = logimports_unrelated_avg5) /// 
	, twostep
	
	ivprobit /// 
	onset_zeros ///
	onset_last5y loggdppc logpop redistr mid anoc logmountain noncontiguous instability capacity excl_pop   t t2 t3 ///
	(logimports_avg5 = logimports_unrelated_avg5) /// 
	, twostep


* SEM

	cdsimeq (logimports_avg5 logimports_unrelated_avg5 logmilex logexport loggdppc west eastern_europe latin_america subsaharan_africa asia capacity) ///
	(onset_alt  onset_last5y loggdppc logpop redistr mid anoc logmountain noncontiguous instability capacity excl_pop   t t2 t3)
	
	cdsimeq (logimports_avg5 logimports_unrelated_avg5 logmilex logexport loggdppc west eastern_europe latin_america subsaharan_africa asia capacity) ///
	(onset_zeros  onset_last5y loggdppc logpop redistr mid anoc logmountain noncontiguous instability capacity excl_pop   t t2 t3), estimates_hold


***** Close log
capture log close _all
