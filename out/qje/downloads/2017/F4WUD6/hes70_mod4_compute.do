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
use `data', clear
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
use `data', clear
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

*keep mod1a mod1b mod1c mod1d mod1e mod1f mod1g mod1h mod1i mod1j mod1k mod1l mod1m mod1n mod1o mod1p mod1q mod1r mod1s mod4
rename mod4 mod4_perturb




