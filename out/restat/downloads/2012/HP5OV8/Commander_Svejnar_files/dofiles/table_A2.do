program drop _all

/*use of the consolidated database with panel dummy*/
use  "$data\final_data.dta", clear 

log using "$logs/tableA2.txt", text replace


drop if owner_new4==1

* models 
local mod1  = "numcomp3 BI_constrqB BI_constrqD BI_constrqF BI_constrqG BI_constrqK BI_constrqM"
local mod2  = "BI_constrqB numcomp3 BI_constrqD BI_constrqF BI_constrqG BI_constrqK BI_constrqM"
local mod3  = "BI_constrqD numcomp3 BI_constrqB BI_constrqF BI_constrqG BI_constrqK BI_constrqM"
local mod4  = "BI_constrqF numcomp3 BI_constrqB BI_constrqD BI_constrqG BI_constrqK BI_constrqM"
local mod5  = "BI_constrqG numcomp3 BI_constrqB BI_constrqD BI_constrqF BI_constrqK BI_constrqM"
local mod6  = "BI_constrqK numcomp3 BI_constrqB BI_constrqD BI_constrqF BI_constrqG BI_constrqM"
local mod7  = "BI_constrqM numcomp3 BI_constrqB BI_constrqD BI_constrqF BI_constrqG BI_constrqK "

local out1  = "BI_constrqB BI_constrqD BI_constrqF BI_constrqG BI_constrqK BI_constrqM"
local out2  = "numcomp3 BI_constrqD BI_constrqF BI_constrqG BI_constrqK BI_constrqM"
local out3  = "numcomp3 BI_constrqB BI_constrqF BI_constrqG BI_constrqK BI_constrqM"
local out4  = "numcomp3 BI_constrqB BI_constrqD BI_constrqG BI_constrqK BI_constrqM"
local out5  = "numcomp3 BI_constrqB BI_constrqD BI_constrqF BI_constrqK BI_constrqM"
local out6  = "numcomp3 BI_constrqB BI_constrqD BI_constrqF BI_constrqG BI_constrqM"
local out7  = "numcomp3 BI_constrqB BI_constrqD BI_constrqF BI_constrqG BI_constrqK "

/* Variables */
local variables1 = "logE logA logExp numcomp3 owner_new1 owner_new2 owner_new3 owner_new4 owner_new5" 
local variables2 = "constrqB constrqD constrqF constrqG constrqK constrqM constrqN constrqP constrqC " 
local variables3 = "labunsec labunsec2 age labunsec_age Q2_3perm_full_empR Q2_3part_tm_empR citytown perfqH perfqI sect1-sect7" 

/* For models */

local endogen  = "logE logA owner_new1 owner_new2 owner_new5 logExp" 
global ENDOGEN  = "logE_hat logA_hat owner_new1_hat owner_new2_hat owner_new5_hat logExp_hat" 
global EXOGEN   = "BI_constrqB BI_constrqC BI_constrqD BI_constrqF BI_constrqG BI_constrqK BI_constrqM  BI_constrqN BI_constrqP" 
global DUMMIES  = "sect1-sect2  sect4-sect7 i.year i.country" 
global INDUSTRY = "sect1-sect2  sect4-sect7" 

global INSTRUMENTS    = "labunsec labunsec2 age labunsec_age Q2_3perm_full_empR Q2_3part_tm_empR citytown perfqH perfqI" 
local instruments   = "labunsec_1 labunsec_2 labunsec_3 labunsec_age_1 labunsec_age_2 labunsec_age_3 age Q2_3perm_full_empR citytown perfqH perfqI" 


egen clstr = group(country prod2DIG sizeb year)
egen re    = group(country year)


/* Create more flexible instruments */
local i = 1 
while `i' <= 3 { 
        foreach var of global INSTRUMENTS { 
                gen `var'_`i' = 0 
                replace `var'_`i' = `var' if regmac == `i' 
        } 
        local i = `i' + 1 
} 

egen obs = count(year), by(country prod2DIG sizeb year)
foreach var of local variables2 {
   cap drop BI_`var'
   egen m =mean(`var'), by(country prod2DIG sizeb year)
   gen BI_`var' = (m*obs - `var')/(obs - 1)
   drop m
  }

local variables4 = "BI_constrqB BI_constrqC BI_constrqD BI_constrqF BI_constrqG BI_constrqK BI_constrqM BI_constrqN BI_constrqP"

sum `variables1' `variables2' `variables3' `variables4' prod2DIG
 
egen ms = rmiss(`variables1' `variables3' `variables4')
drop if ms > 0


local dummies  = "sect1-sect2  sect4-sect7 i.year i.country" 


local model "numcomp3 BI_constrqB BI_constrqC BI_constrqD BI_constrqF BI_constrqG BI_constrqK BI_constrqM BI_constrqN BI_constrqP"

program define rgr
	syntax varlist, [dummies(string)] tab(string)
		local i = 1
		local vars = "`varlist' `dvar'"
	foreach var in `varlist'{
		if `i' == 1 local rep "replace"
		if `i' != 1 local rep ""
		disp `i'
		disp `replace'
		gettoken dvar ivars : vars
		xi: regress `dvar' `ivars' `dummies', robust cluster(clstr)
		outreg2 `ivars' using `tab', se bracket label `rep' aster(se) sortvar(`varlist')
		local i = `i' + 1
		
		local vars = "`ivars' `dvar'"
		}
end

program define rgr2
	syntax varlist, [dummies(string)] tab(string) endog(string) instr(string)
		local i = 1
		local vars = "`varlist' `dvar'"
	foreach var in `varlist'{
		if `i' == 1 local rep "replace"
		if `i' != 1 local rep ""
		disp `i'
		disp `replace'
		gettoken dvar ivars : vars
		
		foreach vr in `endog'{
			cap drop `vr'_hat
			xi: regress `vr' `ivars' `dummies' 
			predict `vr'_hat
			}
		xi: regress `dvar' `ivars' *_hat `dummies' `instr', robust cluster(clstr)					
		outreg2 `ivars' using `tab', se bracket label `rep' aster(se) sortvar(`varlist')
		local i = `i' + 1
		
		local vars = "`ivars' `dvar'"
		}
end


rgr `model', tab(tables\tableA2a)

rgr `model', dummies(`dummies') tab(tables\tableA2b)
rgr2 `model', dummies(`dummies') endog(`endogen') instr(`instruments') tab(tables\tableA2c)

log close

