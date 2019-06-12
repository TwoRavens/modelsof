cd "c:\users\\`c(username)'\dropbox\TingleyCostaRica\ISQ\data"
use CR_ISQdistrict.dta  , clear

*** APPENDIX 2
local targetind2 "AgricExports ManufExports PcntTextile "
local targetind " ManufExports   "
local rv "BrozExport BrozImport"
local ss "PcntLowSocEcon_SD"
local control "totalunemp pubempperc"
local controlfe "pubempperc"
local edu "colortv"
local ftz "ftzbusinesses_dum"
local cluster "cl(cantonid)"

qui xtreg perc_yes pct_PLN_leg06 pct_PAC_leg06 pct_PUSC_leg06 pct_Libertario_leg06  `targetind' `ss' `controlfe' `edu' `ftz'  , robust  `cluster' fe
gen samp = e(sample)
sum `ss' pct_Libertario_leg06 pct_PUSC_leg06 pct_PAC_leg06 pct_PLN_leg06 ManufExports totalunemp pubempperc colortv ftzbusinesses_dum if samp   
corr pct_Libertario_leg06 pct_PUSC_leg06 pct_PAC_leg06 pct_PLN_leg06 ManufExports PcntLowSocEcon_SD totalunemp pubempperc colortv ftzbusinesses_dum if samp   

*** APPENDIX 4
local targetind2 "AgricExports ManufExports PcntTextile "
local targetind " ManufExports   "
local rv "BrozExport BrozImport"
local ss "PcntLowSocEcon_SD"
local control "totalunemp pubempperc"
local controlfe "pubempperc"
*local edu "universityeduc"
*local edu "colortv universityeduc"
local edu "colortv"
local ftz "ftzbusinesses_dum"
local cluster "cl(cantonid)"

local j=1
estimates clear

reg perc_yes pct_PLN_pres06 pct_PAC_pres06 pct_PUSC_pres06  pct_Libertario_pres06 `targetind' `ftz' `ss' `control' `edu', robust `cluster'
est store Prez`j'
local j=`j'+1
xtreg perc_yes pct_PLN_pres06 pct_PAC_pres06 pct_PUSC_pres06  pct_Libertario_pres06 `targetind' `ss' `controlfe' `edu' `ftz'  , robust  `cluster' fe
est store Prez`j'
local j=`j'+1

reg perc_yes diffpres_PLN_centered diffpres_PAC_centered diffpres_PUSC_centered diffpres_Libertario_centered  `targetind' `ss' `control' `edu' `ftz'  , robust  `cluster' 
est store Prez`j'
local j=`j'+1

xtreg perc_yes diffpres_PLN_centered diffpres_PAC_centered diffpres_PUSC_centered diffpres_Libertario_centered  `targetind' `ss' `controlfe' `edu' `ftz'  , robust  `cluster' fe
est store Prez`j'
local j=`j'+1
local order "order(pct* diff*)"

preserve
use CR_ISQ_ED.dta , clear
local targetind2 "AgricExports ManufExports PcntTextile "
local targetind " ManufExports   "
local rv "BrozExport BrozImport"
local ss "PcntLowSocEcon_SD"
local control "totalunemp pubempperc"
local controlfe "pubempperc"
*local edu "universityeduc"
*local edu "colortv universityeduc"
local edu "colortv"
local ftz "ftzbusinesses_dum"
local cluster "cl(cantonnumb)"

areg perc_yes pct_PLN_pres06 pct_PAC_pres06 pct_PUSC_pres06  pct_Libertario_pres06 `targetind' `ss' `controlfe' `edu' `ftz'  , robust  `cluster' abs(cantonnumb)
est store pres_cfe


areg perc_yes pct_PLN_pres06 pct_PAC_pres06 pct_PUSC_pres06  pct_Libertario_pres06 /*`targetind' `ss' `controlfe' `edu' `ftz' */ , robust  `cluster' abs(distnum)
est store pres_dfe

areg perc_yes diffpres_PLN_centered diffpres_PAC_centered diffpres_PUSC_centered diffpres_Libertario_centered `targetind' `ss' `controlfe' `edu' `ftz'  , robust  `cluster' abs(cantonnumb)
est store pres_dcfe

areg perc_yes diffpres_PLN_centered diffpres_PAC_centered diffpres_PUSC_centered diffpres_Libertario_centered /*`targetind' `ss' `controlfe' `edu' `ftz' */ , robust  `cluster' abs(provnum)
est store pres_ddfe
restore


	estout Prez*  pres_cfe pres_dcfe pres_dfe using "supplement/appendix4.txt" , /*
	*/ cells(b(star fmt(%8.2f)) se(par)) starlevels(+ .1 * .05 ** .01) 	/*
	*/ stats(N bic r2 r2_b, fmt(%9.0f %8.2f) labels(Observations BIC)) legend 	/*
	*/ collabels(, none) `order' label varlabels(_cons Constant) replace
	
*** APPENDIX 3
	preserve
estimates clear
local targetind2 "AgricExports ManufExports PcntTextile "
local targetind " ManufExports   "
local rv "BrozExport BrozImport"
local ss "PcntLowSocEcon_SD"
local control "totalunemp pubempperc"
local controlfe "pubempperc"
*local edu "universityeduc"
*local edu "colortv universityeduc"
local edu "colortv"
local ftz "ftzbusinesses_dum"
local cluster "cl(cantonid)"

local j  leg
foreach k of local j { 
xtreg perc_yes pct_Libertario_`k'06 pct_PUSC_`k'06 pct_PAC_`k'06 pct_PLN_`k'06 `targetind' `ss' `controlfe' `edu' `ftz'  , robust  `cluster' fe
gen PAC`k'effect=.
gen PLN`k'effect=.
gen eff`k'_ptile=.
replace eff`k'_ptile = 5 if _n==1
replace eff`k'_ptile = 10 if _n==2
replace eff`k'_ptile = 25 if _n==3
replace eff`k'_ptile = 50 if _n==4
replace eff`k'_ptile = 75 if _n==5
replace eff`k'_ptile = 90 if _n==6
replace eff`k'_ptile = 95 if _n==7
foreach i of newlist PAC PLN {
sum  pct_`i'_`k'06 if e(sample), d
replace `i'`k'eff = (r(p5)*_b[pct_`i'_`k'06])*100 if _n==1
replace `i'`k'eff = (r(p10)*_b[pct_`i'_`k'06])*100 if _n==2
replace `i'`k'eff = (r(p25)*_b[pct_`i'_`k'06])*100 if _n==3
replace `i'`k'eff = (r(p50)*_b[pct_`i'_`k'06])*100 if _n==4
replace `i'`k'eff = (r(p75)*_b[pct_`i'_`k'06])*100 if _n==5
replace `i'`k'eff = (r(p90)*_b[pct_`i'_`k'06])*100 if _n==6
replace `i'`k'eff = (r(p95)*_b[pct_`i'_`k'06])*100 if _n==7
}
gen effect`k'dif = PLN`k'effect+PAC`k'effect
}

scatter effectlegdif effleg_ptile , ylabel(0(5)20) xlabel(5 10 25 50 75 90 95) c(l) ytitle("Yes vote percent difference") ///
  title("Difference in yes vote at percentiles" "of PLN/PAC legislative vote share (model 2)") yline(0) xtitle("Percentile")
 restore
 
 
 ** BOUNDS
gen PLNbdmin = max(0, ((perc_yes-(1-pct_PLN_leg06 ))/pct_PLN_leg06))
gen PLNbdmax = min(1, (perc_yes/pct_PLN_leg06))
gen nonPLNbdmin  = max(0, (perc_yes-pct_PLN_leg06)/(1-pct_PLN_leg06)) 
gen nonPLNbdmax = min(1, (perc_yes/(1-pct_PLN_leg06)))

gen PACbdmin = max(0, ((perc_yes-(1-pct_PAC_leg06))/pct_PAC_leg06))
gen PACbdmax = min(1, (perc_yes/pct_PAC_leg06))
sum PLNbdmin PLNbdmax
sum PACbdmin PACbdmax
