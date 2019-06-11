clear
set more off

*construction of HES70 score described in 

***merge in HES70-HES71 scores
use hes_numscores, clear
drop mod4-mod2f

*generate an HES70 dummy
g hes70=0
replace hes70=1 if yr<1971

tempfile data
save `data', replace

***construct scores in cases where they are missing

**insheet decision tables
insheet using hes70_dectab_2way.csv, comma clear names
tempfile t2
save `t2', replace

insheet using hes70_dectab_3way.csv, comma clear names
tempfile t3
save `t3', replace

**mod 2a
*mod2a <- list("MOD2A", "MOD1A", "MOD1B")
use `data', clear
rename mod1a input1 
rename mod1b input2
merge n:1 input1 input2 using `t2'
drop if _merge==2
drop _merge
rename input1 mod1a
rename input2 mod1b
rename output mod2a
save `data', replace

**mod2b
*mod2b <- list("MOD2B", "MOD1E", "MOD1D", c("MOD1F", "MOD1G"))
use `data', clear
rename mod1f input1 
rename mod1g input2
merge n:1 input1 input2 using `t2'
drop if _merge==2
drop _merge
rename input1 mod1f
rename input2 mod1g
rename output input3
rename mod1e input1 
rename mod1d input2
merge n:1 input1 input2 input3 using `t3'
drop if _merge==2
drop _merge
rename input1 mod1e
rename input2 mod1d
drop input3
rename output mod2b
save `data', replace

**mod2c
*mod2c <- list("MOD2C", "MOD1H","MOD1I")
use `data', clear
rename mod1h input1 
rename mod1i input2
merge n:1 input1 input2 using `t2'
drop if _merge==2
drop _merge
rename input1 mod1h
rename input2 mod1i
rename output mod2c
save `data', replace

**mod2d
*mod2d <- list("MOD2D", "MOD1J", c("MOD1L", "MOD1K"), "MOD1G")
*RD cadre !="N"
use `data', clear
keep if mod1k!="N"
rename mod1l input1 
rename mod1k input2
merge n:1 input1 input2 using `t2'
drop if _merge==2
drop _merge
rename input1 mod1l
rename input2 mod1k
rename output input2
rename mod1j input1 
rename mod1g input3
merge n:1 input1 input2 input3 using `t3'
drop if _merge==2
drop _merge
rename input1 mod1j
rename input3 mod1g
drop input2
rename output mod2d
tempfile d1
save `d1', replace

*RD cadre=="N"
use `data', clear
keep if mod1k=="N"
rename mod1j input1 
rename mod1l input2
rename mod1g input3
merge n:1 input1 input2 input3 using `t3'
drop if _merge==2
drop _merge
rename input1 mod1j
rename input2 mod1l
rename input3 mod1g
rename output mod2d
append using `d1'
save `data', replace

**mod2e
*mod2e <- list("MOD2E", "MOD1O", "MOD1N","MOD1P")
use `data', clear
rename mod1o input1 
rename mod1n input2
rename mod1p input3
merge n:1 input1 input2 input3 using `t3'
drop if _merge==2
drop _merge
rename input1 mod1o
rename input2 mod1n
rename input3 mod1p
rename output mod2e
save `data', replace

**mod2f
*mod2f <- list("MOD2F", "MOD1R", "MOD1Q","MOD1S")

*mod1s!="N"
use `data', clear
keep if mod1s!="N"
rename mod1r input1 
rename mod1q input2
rename mod1s input3
merge n:1 input1 input2 input3 using `t3'
drop if _merge==2
drop _merge
rename input1 mod1r
rename input2 mod1q
rename input3 mod1s
rename output mod2f
tempfile d1
save `d1', replace

*mod1s=="N"
use `data', clear
keep if mod1s=="N"
rename mod1r input1 
rename mod1q input2
merge n:1 input1 input2 using `t2'
drop if _merge==2
drop _merge
rename input1 mod1r
rename input2 mod1q
rename output mod2f
append using `d1'
save `data', replace


**mod3a
*mod3a <- list("MOD3A","MOD2A_gen","MOD2B_gen","MOD1C")

use `data', clear
rename mod2a input1 
rename mod2b input2
rename mod1c input3
merge n:1 input1 input2 input3 using `t3'
drop if _merge==2
drop _merge
rename input1 mod2a
rename input2 mod2b
rename input3 mod1c
rename output mod3a
save `data', replace

**mod3b
*mod3b <- list("MOD3B","MOD2D_gen","MOD2C_gen","MOD1M")

use `data', clear
rename mod2d input1 
rename mod2c input2
rename mod1m input3
merge n:1 input1 input2 input3 using `t3'
drop if _merge==2
drop _merge
rename input1 mod2d
rename input2 mod2c
rename input3 mod1m
rename output mod3b
save `data', replace

**mod3c
*mod3c <- list("MOD3C", "MOD2E_gen","MOD2F_gen")
use `data', clear
rename mod2e input1 
rename mod2f input2
merge n:1 input1 input2 using `t2'
drop if _merge==2
drop _merge
rename input1 mod2e
rename input2 mod2f
rename output mod3c
save `data', replace

**mod4
*mod4 <- list("MOD4", "MOD3A_gen","MOD3B_gen","MOD3C_gen") 
use `data', clear
rename mod3a input1 
rename mod3b input2
rename mod3c input3
merge n:1 input1 input2 input3 using `t3'
drop if _merge==2
drop _merge
rename input1 mod3a
rename input2 mod3b
rename input3 mod3c
rename output mod4
replace mod4="V" if (hmb1==1 | hmb1==2)

label var 	mod8 "HES Rating Model"
label var 	mod7a "Security Macromodel"
label var	mod7b "Community Development Macromodel"
label var 	mod6a "Political Control Macromodel"
label var	mod6b "Military Control Macromodel"
label var	mod5a "Enemy Military Model"
label var	mod5b "Friendly Military Model"
label var	mod5c "Enemy Political Model"
label var	mod5d "Friendly Political Model"
label var	mod5e "Political Programs Model"
label var	mod5f "Social Programs Model"
label var 	mod4  "Pacification Model"
label var 	mod3a  "Security Macro Model"
label var 	mod3b  "Political Macro Model"
label var 	mod3c  "Socio Economic Macro Model"
label var 	mod2a  "Enemy Military Model"
label var 	mod2b  "Friendly Security Model"
label var 	mod2c  "Enemy Political Model"
label var 	mod2d  "GVN Political Model"
label var 	mod2e  "Social Model"
label var 	mod2f  "Economic Model"
label var	mod1a "Enemy Military Presence Submodel"
label var	mod1b "Enemy Military Activity Submodel"
label var	mod1c "Impact of Military Activity Submodel"
label var	mod1d "Friendly Military Presence Submodel"
label var	mod1e "Friendly Military Activity Submodel"
label var	mod1f "Law Enforcement Submodel"
label var	mod1g "PSDF Activity Submodel"
label var	mod1h "Enemy Political Presence Submodel"
label var	mod1i "Enemy Political Activity Submodel"
label var	mod1j "Administration Submodel"
label var	mod1k "RD Cadre Submodel"
label var	mod1l "Information PSYOPS Submodel"
label var	mod1m "Political Mobilization Submodel"
label var	mod1n "Public Health Submodel"
label var	mod1o "Education Submodel"
label var	mod1p "Social Welfare Submodel"
label var	mod1q "Development Assistance Submodel"
label var	mod1r "Economic Activity Submodel"
label var	mod1s "Land Tenure Submodel"

g obs_num=_n

save hes_all_models, replace

