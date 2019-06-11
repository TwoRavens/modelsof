tempfile data
save `data', replace

***construct scores in cases where they are missing

**insheet decision tables
insheet using hes71_dectab_2way.csv, comma clear names
tempfile t2
save `t2', replace

insheet using hes71_dectab_3way.csv, comma clear names
tempfile t3
save `t3', replace

**mod 5a
*mod5a <-  list("MOD5A", "MOD1A", "MOD1B")
use `data', clear
rename mod1a input1 
rename mod1b input2
merge n:1 input1 input2 using `t2'
drop if _merge==2
drop _merge
rename input1 mod1a
rename input2 mod1b
rename output mod5a
save `data', replace

**mod5b
*mod5b <-  list("MOD5B", "MOD1E", "MOD1D", "MOD1G")
use `data', clear
rename mod1e input1 
rename mod1d input2
rename mod1g input3
merge n:1 input1 input2 input3 using `t3'
drop if _merge==2
drop _merge
rename input1 mod1e
rename input2 mod1d
rename input3 mod1g
rename output mod5b
save `data', replace

**mod5c
*mod5c <-  list("MOD5C", "MOD1H","MOD1I")
use `data', clear
rename mod1h input1 
rename mod1i input2
merge n:1 input1 input2 using `t2'
drop if _merge==2
drop _merge
rename input1 mod1h
rename input2 mod1i
rename output mod5c
save `data', replace

**mod5d
*mod5d <-  list("MOD5D", ("MOD1J", MOD1F), "MOD1M")
use `data', clear
rename mod1j input1 
rename mod1f input2
merge n:1 input1 input2 using `t2'
drop if _merge==2
drop _merge
rename input1 mod1j
rename input2 mod1f
rename output input1
rename mod1m input2
merge n:1 input1 input2 using `t2'
drop if _merge==2
drop _merge
rename input2 mod1m
drop input1
rename output mod5d
save `data', replace

**mod5f
*mod5f <- list("MOD5F", "MOD1O", "MOD1N","MOD1P")
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
rename output mod5f
save `data', replace

**mod5e
*mod5e <- list("MOD5E", ("MOD1Q", "MOD1S"), ("MOD1G", "MOD1L", "MOD1K"))
**If land tenure=N, use development assistance only
**If RD cadre=N, use a two way table rather than a three way table

use `data', clear
keep if (mod1s!="N" & mod1k!="N") 
rename mod1q input1 
rename mod1s input2
merge n:1 input1 input2 using `t2'
drop if _merge==2
drop _merge
rename input1 mod1q
rename input2 mod1s
rename output later_input1

rename mod1g input1
rename mod1l input2
rename mod1k input3

merge n:1 input1 input2 input3 using `t3'
drop if _merge==2
drop _merge
rename input1 mod1g
rename input2 mod1l
rename input3	mod1k
rename output input2
rename later_input1 input1

merge n:1 input1 input2 using `t2'
drop if _merge==2
drop _merge input1 input2
rename output mod5e

tempfile d1
save `d1', replace		


use `data', clear
keep if (mod1s=="N" & mod1k!="N") 

rename mod1g input1
rename mod1l input2
rename mod1k input3

merge n:1 input1 input2 input3 using `t3'
drop if _merge==2
drop _merge
rename input1 mod1g
rename input2 mod1l
rename input3	mod1k
rename output input2
rename mod1q input1

merge n:1 input1 input2 using `t2'
drop if _merge==2
drop _merge input2
rename input1 mod1q
rename output mod5e

tempfile d2
save `d2', replace		

use `data', clear
keep if (mod1s!="N" & mod1k=="N") 
rename mod1q input1 
rename mod1s input2
merge n:1 input1 input2 using `t2'
drop if _merge==2
drop _merge
rename input1 mod1q
rename input2 mod1s
rename output later_input1

rename mod1g input1
rename mod1l input2

merge n:1 input1 input2 using `t2'
drop if _merge==2
drop _merge
rename input1 mod1g
rename input2 mod1l
rename output input2
rename later_input1 input1

merge n:1 input1 input2 using `t2'
drop if _merge==2
drop _merge input1 input2
rename output mod5e

tempfile d3
save `d3', replace				

use `data', clear
keep if (mod1s=="N" & mod1k=="N") 

rename mod1g input1
rename mod1l input2

merge n:1 input1 input2 using `t2'
drop if _merge==2
drop _merge
rename input1 mod1g
rename input2 mod1l
rename output input2
rename mod1q input1

merge n:1 input1 input2 using `t2'
drop if _merge==2
drop _merge input2
rename input1 mod1q
rename output mod5e

append using `d1'
append using `d2'
append using `d3'
save `data', replace			

**mod6b
*mod6b<- list("MOD6B","MOD5A","MOD5B","MOD1C")

use `data', clear
rename mod5a input1 
rename mod5b input2
rename mod1c input3
merge n:1 input1 input2 input3 using `t3'
drop if _merge==2
drop _merge
rename input1 mod5a
rename input2 mod5b
rename input3 mod1c
rename output mod6b
save `data', replace

**mod6a
*mod6a <- list("MOD6A","MOD5C","MOD5D")

use `data', clear
rename mod5d input1 
rename mod5c input2
merge n:1 input1 input2 using `t2'
drop if _merge==2
drop _merge
rename input1 mod5d
rename input2 mod5c
rename output mod6a
save `data', replace

**mod7a <- list(MOD7A, MOD6B, MOD6A)

use `data', clear
rename mod6a input1 
rename mod6b input2
merge n:1 input1 input2 using `t2'
drop if _merge==2
drop _merge
rename input1 mod6a
rename input2 mod6b
rename output mod7a
save `data', replace

**mod7b <- list(MO7B, (MOD5D, MOD5E), (MOD5F, MOD1R))

use `data', clear
rename mod5d input1 
rename mod5e input2
merge n:1 input1 input2 using `t2'
drop if _merge==2
drop _merge
rename input1 mod5d
rename input2 mod5e
rename output later_input1

rename mod5f input1
rename mod1r input2

merge n:1 input1 input2 using `t2'
drop if _merge==2
drop _merge
rename input1 mod5f
rename input2 mod1r
rename output input2
rename later_input1 input1

merge n:1 input1 input2 using `t2'
drop if _merge==2
drop _merge input1 input2
rename output mod7b
save `data', replace

**mod8
*mod8 <- list("mod8", "MOD6b_gen","MOD6a_gen","MOD3C_gen") 
use `data', clear

g mod8=mod7a
replace mod8="D" if (mod7a=="E" & mod7b=="B")
replace mod8="D" if (mod7a=="E" & mod7b=="A")
replace mod8="C" if (mod7a=="D" & mod7b=="A")
replace mod8="B" if (mod7a=="A" & mod7b=="D")
replace mod8="B" if (mod7a=="A" & mod7b=="E")
replace mod8="C" if (mod7a=="B" & mod7b=="E")
replace mod8="D" if (mod7a=="C" & mod7b=="N")
*replace mod8="V" if (hmb1==1 | hmb1==2)

*keep mod1a mod1b mod1c mod1d mod1e mod1f mod1g mod1h mod1i mod1j mod1k mod1l mod1m mod1n mod1o mod1p mod1q mod1r mod1s mod8
rename mod8 mod8_perturb

