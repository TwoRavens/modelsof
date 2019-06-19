// ---------------------------------------
// Mincer regression
// ---------------------------------------

clear all
set mem 32g
set more off

global data "e:/Dropbox/Data/Frisch"
global work "e:/Dropbox/Work/Input_quality"
global tmp "e:/Dropbox/Work/Input_quality/Data"
global tmplocal "c:/tmp"
capture mkdir $tmp

// -------------------------------
// Split up experience data
// -------------------------------

forvalues year = 1996/2005 {
  use "$work/Data/experience9605", clear
  keep idnr experience`year'
  gen aar=`year'
  rename experience`year' experience
  save "$tmplocal/experience_`year'", replace
}

// -------------------------------
// Worker data : Preliminaries
// -------------------------------

set more off
forvalues year = 1996/2005 {
  use "$data/panel_ansatte/panel_ansatte_`year'", clear
  destring nace2, replace force
  rename ar aar

  // Joint experience data
  joinby idnr aar using "$tmplocal/experience_`year'", unmatched(master)
  tab _merge
  drop _merge
  
  // ---------------------------------------------------
  // Make sure that there is only 1 (employee,employer) combination per year
  // ---------------------------------------------------

  // Only use full-time workers (over 30 hours work/week)
  keep if forv_arb=="3"

  // There are duplicates if a firm/worker has multiple nace codes. 
  duplicates drop org_f idnr forv_arb arbtid_type start stopp, force

  // Find the main workplace
  egen maxerf = max(f_erfaring_ar), by(idnr)
  bysort idnr: gen keepv = f_erfaring_ar==maxerf
  drop if keepv==0
  drop keepv maxerf

  // In a few cases there is a tie. Pick the first one
  duplicates drop idnr, force

  // Wages for people quitting in the first days of the year is very high. Drop these.
  drop if stopp<date("2101`year'","DMY")

  // -------------------------------
  // Make variables etc
  // -------------------------------
  
  // arslonn is yearly wages irrespective of hours, or if they worked the whole year
  gen lnw = log(arslonn)
  
  // Drop missing
  drop if lnw==. | f_erfaring ==. | experience==.
  
  keep org_f idnr start stopp aar arslonn nace2 f_erfaring* ant_levfodt kjonn fdato kltrinn* experience lnw
  compress
  save $tmp/tmp_mincer2_`year', replace
}


// -------------------------------
// Regressions
// -------------------------------
clear all
set mem 8g		

set more off
log using "$work/logs/mincer7", replace

use "$tmp/tmp_mincer2_1996", clear
forvalues year = 1997/2005 {
  append using "$tmp/tmp_mincer2_`year'"
}

gen E = experience
gen E2 = E^2/100
gen E3 = E^3/1000
gen E4 = E^4/10000
gen T = f_erfaring
gen T2 = T^2/100

// Create deviations from grand mean
foreach vvar of varlist lnw E E2 E3 E4 T T2 {
  egen m_`vvar' = mean(`vvar')
  replace `vvar' = `vvar' - m_`vvar' 
}

// Clean up
keep idnr org_f* aar lnw E* T* nace2

label var E "Experience, relative to grand mean"
label var T "Tenure, relative to grand mean"

forvalues yy = 1997/2005 {
  gen D`yy' = aar==`yy'
}

compress

save $tmplocal/tmp, replace

// ----------------------------------
// Regression with person and firm FE
// ----------------------------------
use $tmplocal/tmp, clear
keep if nace2>14 & nace2<38
a2reg lnw E* T* D*, individual(idnr) unit(org_f_lopenr) indeffect(personefx) uniteffect(firmefx) xb(xb) resid(res)

matrix B = get(_b)
gen xb2 = B[1,1]*E + B[1,2]*E2 + B[1,3]*E3 + B[1,4]*E4 + B[1,5]*T + B[1,6]*T2

gen w_hat2 = xb2 + personefx
bysort aar: corr personefx firmefx
bysort aar: sum w_hat w_hat2 firmefx xb

label var w_hat2 "Person efx + timevarying covariates"
label var personefx "Person efx"
label var firmefx "Firm efx"
label var xb "Timevarying covariates with year fixed efx"
label var xb2 "Timevarying covariates without year fixed efx"

// Clean up
drop D* E* T*
sort idnr aar
save "$tmplocal/AKM_est2", replace

// Split sample into years
forvalues yy = 1996/2005 {
  use "$tmplocal/AKM_est2", clear
  keep if aar==`yy'
  save "$work/data/AKM_est2`yy'", replace
}

log close
