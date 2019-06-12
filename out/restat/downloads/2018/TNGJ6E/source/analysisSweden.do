/* Sweden.do v1.00              Clarke/Bhalotra            yyyy-mm-dd:2015-07-24
----|----1----|----2----|----3----|----4----|----5----|----6----|----7----|----8

  This file uses all births from Sweden's Medical Birth Registry to run tests of
twinning on maternal characteristics. The use of Sweden's Medical Birth Registry
data requries previous approval. Once this approval has been sought, the below c
an be run. The only locations that need to be set are the globals in lines 22-24
which are currently set relative to this code directory.  The local "data" on li
ne 26 refers to the name of the Medical Birth Registry file saved in dta format.

The only non-Stata library required is estout.  If this is not installed on the 
computer/server, it will be installed. If it is not installed and the computer 
does not have internet access, this file will fail to export results.
*/

vers 11
clear all
set more off
cap log close


********************************************************************************
*** (1) Globals and locals
********************************************************************************
global DAT "./../data"
global OUT "./../results"
global LOG "./../log"

local data mfr

log using "$LOG/Sweden.txt", text replace

cap which estout
if _rc!=0 ssc install estout

********************************************************************************
**** (2) Define variables
********************************************************************************
use "$DAT/`data'", clear

*** Multiple Births
gen Birth		=1
gen AliveBirth		=missing(dodfod)
gen StillBorn		=!AliveBirth
gen Singlebirth		=BORDF2=="1"
gen MultipleBirth	=BORDF2=="2"
gen TwinBirth		=BORDNRF2=="22"|BORDNRF2=="12"
gen twin100		=TwinBirth*100


**** Gender (male==1, female==0), mother's age, gestational age (weeks), 
**** birth weight, birth year
gen gender		=kon=="1"
gen motherAge		=malder
gen motherAgeSqa	=malder^2
gen gestAge		=grvbs
gen birthweight		=bviktbs
gen year		=ar

**** Nationality
gen native		=mfodland=="SVERIGE"

**** Health
gen motherHeight	=mlangd
gen motherHeightSqa	=mlangd^2
gen motherWeight	=mvikt
gen asthma		=astma=="1"|astma=="2" 
gen ulcolitis		=ulcolit=="1"|ulcolit=="2" 
gen epilepsy		=epilepsi=="1"|epilepsi=="2" 
gen diabetis		=diabetes=="1"|diabetes=="2"
gen kidney		=njursjuk=="1"|njursjuk=="2"
gen hypertensia		=hyperton=="1"|hyperton=="2"
gen BMI                 = (motherWeight/1000)/((motherHeight*100)^2)
gen underweight         = BMI<18.5 if BMI<99
gen obese               = BMI>=30 if BMI<99

**** Smoking   
gen smoke_3tri		=ROK2=="2"|ROK2=="3"
replace smoke_3tri 	=. if missing(ROK2)

gen smoke_1tri 		=ROK1=="2"|ROK1=="3"
replace smoke_1tri 	=. if missing(ROK1) 

**** Birth order
gen birthOrder=paritet
replace birthOrder=. if paritet==0


**** Label vars
la var motherHeight 	 "Mother's Height"
la var motherHeightSqa   "Mother's Height Square"
la var motherWeight 	 "Mother's Weight"
la var motherAge 	 "Mother's Age"
la var motherAgeSqa	 "Mother's Age Square"
la var native 		 "Native"
la var smoke_1tri	 "Smoking 1 trimester"
la var smoke_3tri	 "Smoking 3 trimetser"
la var asthma 		 "Asthma"
la var diabetis 	 "Diabetes"
la var ulcolitis 	 "Ulcerative colitis"
la var kidney 		 "Kidney Disease"
la var epilepsy 	 "Epilepsy" 
la var hypertensia 	 "Hypertension"
la var gender 		 "Gender" 
la var gestAge 		 "Gestational Age" 
la var birthweight 	 "Birth Weight" 
la var twin100  	 "Twin Birth"
la var AliveBirth 	 "Born Alive" 
la var MultipleBirth	 "Multiple Birth"
la var Singlebirth	 "Single Birth" 
la var StillBorn	 "Stillborn"


********************************************************************************
* (2) Variable lists 
********************************************************************************
local health asthma diabetis kidney hypertensia smoke_1tri smoke_3tri /*
*/           motherHeight underweight obese
local FEs    i.year i.birthOrder i.motherAge i.gestAge


********************************************************************************
*** (3a) Sum Stats
********************************************************************************
gen a=1

estpost sum `health' twin100 motherAge a, casewise
estout using "$OUT/appendix/SweSum.tex", replace label style(tex) `statform'

********************************************************************************
*** (3b) Sweden Regressions: Conditional and Unconditional, Standardised and Not
********************************************************************************
preserve
local Zvar
foreach var of varlist `health' {
    egen mean_`var' = mean(`var')
    egen sd_`var'   = sd(`var')
                 
    gen Z_`var' = (`var' - mean_`var')/sd_`var'
    drop mean_`var' sd_`var'

    local Zvar `Zvar' Z_`var'
}

gen varname = ""
foreach estimand in beta se uCI lCI obs {
    gen `estimand'_std_cond  = .
    gen `estimand'_non_cond  = .
    gen `estimand'_std_ucond = .
    gen `estimand'_non_ucond = .
}


reg twin100 `Zvar' `FEs'
keep if e(sample)
local counter = 1
foreach var of varlist `Zvar' {
    local nobs = e(N)
    local beta = round( _b[`var']*1000)/1000
    local se   = round(_se[`var']*1000)/1000
    local uCI  = round((`beta'+invttail(`nobs',0.025)*`se')*1000)/1000
    local lCI  = round((`beta'-invttail(`nobs',0.025)*`se')*1000)/1000

    qui replace  obs_std_cond = `nobs' in `counter'
    qui replace beta_std_cond = `beta' in `counter'
    qui replace   se_std_cond = `se'   in `counter'
    qui replace  uCI_std_cond = `uCI'  in `counter'
    qui replace  lCI_std_cond = `lCI'  in `counter'

    local ++counter
}
outsheet varname beta_std_cond se_std_cond uCI_std_cond lCI_std_cond /*
*/ in 1/`counter' using "$OUT/appendix/SWE_est_std_cond.csv", delimit(";") replace
    
    
local counter = 1
dis "Unstandardised Unconditional"
dis "varname;beta;sd;lower-bound;upper-bound;N"
foreach var of varlist `health' {
    qui reg twin100 `var' `FEs'
    local nobs = e(N)
    local beta = round( _b[`var']*1000)/1000
    local se   = round(_se[`var']*1000)/1000
    local uCI  = round((`beta'+invttail(`nobs',0.025)*`se')*1000)/1000
    local lCI  = round((`beta'-invttail(`nobs',0.025)*`se')*1000)/1000

    qui replace  obs_non_ucond = `nobs' in `counter'
    qui replace beta_non_ucond = `beta' in `counter'
    qui replace   se_non_ucond = `se'   in `counter'
    qui replace  uCI_non_ucond = `uCI'  in `counter'
    qui replace  lCI_non_ucond = `lCI'  in `counter'

    dis "`var';`beta';`se';`lCI';`uCI';`nobs'"    
    local ++counter
}
outsheet varname beta_non_ucond se_non_ucond uCI_non_ucond lCI_non_ucond in /*
*/ 1/`counter' using "$OUT/appendix/SWE_est_non_ucond.csv", delimit(";") replace
    
    
local counter = 1
dis "Standardised Unconditional"
dis "varname;beta;sd;lower-bound;upper-bound;N"
foreach var of varlist `Zvar' {
    qui reg twin100 `var' `FEs'
    local nobs = e(N)
    local beta = round( _b[`var']*1000)/1000
    local se   = round(_se[`var']*1000)/1000
    local uCI  = round((`beta'+invttail(`nobs',0.025)*`se')*1000)/1000
    local lCI  = round((`beta'-invttail(`nobs',0.025)*`se')*1000)/1000

    qui replace  obs_std_ucond = `nobs' in `counter'
    qui replace beta_std_ucond = `beta' in `counter'
    qui replace   se_std_ucond = `se'   in `counter'
    qui replace  uCI_std_ucond = `uCI'  in `counter'
    qui replace  lCI_std_ucond = `lCI'  in `counter'

    dis "`var';`beta';`se';`lCI';`uCI';`nobs'"        
    local ++counter
}
outsheet varname beta_std_ucond se_std_ucond uCI_std_ucond lCI_std_ucond in /*
*/ 1/`counter' using "$OUT/main/SWE_est_std_ucond.csv", delimit(";") replace

restore


********************************************************************************
*** (3d) Sweden Regressions: Twin Dif
********************************************************************************
gen countryName = "Sweden"
gen surveyYear  = 2011
rename motherHeight height

foreach var in height {
    gen `var'Est     = .
    gen `var'LB      = .
    gen `var'UB      = .

    egen Mean = mean(`var')
    egen SDev = sd(`var')
    gen `var'_std = (`var'-Mean)/SDev
    drop Mean SDev
}
foreach var in height_std {
    gen `var'Est     = .
    gen `var'LB      = .
    gen `var'UB      = .
}
gen twinProp = .
gen twind = twin100/100

gen yearint = 2011

sum twind 
replace twinProp = `r(mean)' 
gen fert = birthOrder
foreach var in height height_std {
    qui areg `var' twind i.fert, abs(motherAge)
    local nobs  = e(N)
    local estl `=_b[twind]-invttail(`nobs',0.025)*_se[twind]'
    local estu `=_b[twind]+invttail(`nobs',0.025)*_se[twind]'
    dis "95% CI for `var' is [`estl',`estu']"
        
    qui replace `var'Est   = _b[twind] in 1
    qui replace `var'LB    = `estl'    in 1
    qui replace `var'UB    = `estu'    in 1
}

keep in 1
keep countryName heightEst heightLB heightUB height_stdEst /*
*/ height_stdLB  height_stdUB twinProp surveyYear
outsheet using "$OUT/appendix/countryEstimatesSWE.csv", comma replace


********************************************************************************
*** (X) Clean
********************************************************************************
log close
