** Replication files for Hemker/Rink AJPS
** anselm.rink@gmail.com


*#*#*#*#*#*#*#*#*#*#*#**#*#*#*#*#*#*#*#*#*#*#**#
*#*#*# Table 2: Benchmark without CTRLS  *#*#*#*
*#*#*#*#*#*#*#*#*#*#*#**#*#*#*#*#*#*#*#*#*#*#**#

* ssc install estout
* set global accordingly, for example:

global data "/Users/anselmrink/Desktop/AJPS/1 Repl Arch"

* change "/" to "\" when using a PC
clear
set more off
use "$data/data.dta", clear
eststo: reg responsedummy foreign female unskilled unendorsed informal
eststo: reg responsequality_pap_avg foreign female unskilled unendorsed informal
eststo: reg responsequality_pap_avg foreign female unskilled unendorsed informal if responsedummy==1
eststo: reg responsequality_linear_avg foreign female unskilled unendorsed informal if responsedummy==1
eststo: reg friendlinessavg  foreign female unskilled unendorsed informal  if responsedummy==1
eststo: reg formalityavg foreign female unskilled unendorsed informal  if responsedummy==1
eststo: reg responselength foreign female unskilled unendorsed informal  if responsedummy==1
eststo: reg mistakes foreign female unskilled unendorsed informal  if responsedummy==1
esttab using "$data\t2.tex", se label  star(* 0.05 ** 0.01) b(3) replace
drop _est*

estimates clear

*#*#*#*#*#*#*#*#*#*#*#**#*#*#*#*#*#*#*#*#*#
*#*#*# Table 3: Quality robustness  *#*#*#*
*#*#*#*#*#*#*#*#*#*#*#**#*#*#*#*#*#*#*#*#*#

clear
use "$data/data.dta", clear
tab state, gen(statestate)
drop state
set more off
gl controls "ALQ2013 independent migrantshare"
eststo: reg responsequality_linear_avg foreign female unskilled unendorsed informal if responsedummy==1 
eststo: reg responsequality_linear_avg foreign female unskilled unendorsed informal $controls state* if responsedummy==1 
eststo: reg responsequality_pap_avg foreign female unskilled unendorsed informal
eststo: reg responsequality_pap_avg foreign female unskilled unendorsed informal $controls state*
eststo: reg responsequality_pap_avg foreign female unskilled unendorsed informal if responsedummy==1
eststo: reg responsequality_pap_avg foreign female unskilled unendorsed informal $controls state* if responsedummy==1
eststo: reg responsequality_allnothing_avg foreign female unskilled unendorsed informal if responsedummy==1
eststo: reg responsequality_allnothing_avg foreign female unskilled unendorsed informal $controls state* if responsedummy==1
eststo: reg responsequality_submission_avg foreign female unskilled unendorsed informal if responsedummy==1
eststo: reg responsequality_submission_avg foreign female unskilled unendorsed informal $controls state* if responsedummy==1
esttab using "$data\t3.tex", se label  star(* 0.05 ** 0.01) b(3) replace
drop _est*

estimates clear



*#*#*#*#*#*#*#*#*#*#*#**#*#*#*#*#*#*#*#*#*#
*#*#*# Table 4: Splitting up quality *#*#*#*
*#*#*#*#*#*#*#*#*#*#*#**#*#*#*#*#*#*#*#*#*#

clear
use "$data/data.dta", clear
tab state, gen(statestate)
set more off
drop state
gl controls "ALQ2013 independent migrantshare"
eststo: reg q1_avg foreign female unskilled unendorsed informal if responsedummy==1
eststo: reg q2_linear_avg foreign female unskilled unendorsed informal  if responsedummy==1
eststo: reg q1_avg turkish romanian female unskilled unendorsed informal  if responsedummy==1
eststo: reg q2_linear_avg turkish romanian female unskilled unendorsed informal  if responsedummy==1
eststo: reg q1_avg foreign female unskilled unendorsed informal $controls state* if responsedummy==1
eststo: reg q2_linear_avg foreign female unskilled unendorsed informal $controls state* if responsedummy==1
eststo: reg q1_avg turkish romanian female unskilled unendorsed informal $controls state* if responsedummy==1
eststo: reg q2_linear_avg turkish romanian female unskilled unendorsed informal $controls state* if responsedummy==1
esttab using "$data/t4.tex", se label  star(* 0.05 ** 0.01) b(3) replace


estimates clear


*#*#*#*#*#*#*#*#*#*#*#**#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*
*#*#*# Table 9: Benchmark with CTRLS and FE and Pretest *#*#*#
*#*#*#*#*#*#*#*#*#*#*#**#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*

clear
use "$data/data.dta", clear
tab state, gen(statestate)
drop state
set more off
gl controls "ALQ2013 independent migrantshare"
eststo: reg responsedummy foreign female unskilled unendorsed informal $controls state*
eststo: reg responsedummy foreign female unskilled unendorsed informal $controls state* if pretest==0
eststo: reg responsequality_linear_avg foreign female unskilled unendorsed informal $controls state* if responsedummy==1
eststo: reg responsequality_linear_avg foreign female unskilled unendorsed informal $controls state* if pretest==0 & responsedummy==1
eststo: reg friendlinessavg  foreign female unskilled unendorsed informal  $controls state* if responsedummy==1
eststo: reg friendlinessavg  foreign female unskilled unendorsed informal  $controls state* if pretest==0 & responsedummy==1
eststo: reg formalityavg foreign female unskilled unendorsed informal   $controls state* if responsedummy==1
eststo: reg formalityavg foreign female unskilled unendorsed informal   $controls state* if pretest==0 & responsedummy==1
eststo: reg responselength foreign female unskilled unendorsed informal   $controls state* if responsedummy==1
eststo: reg responselength foreign female unskilled unendorsed informal   $controls state* if pretest==0 & responsedummy==1
eststo: reg mistakes foreign female unskilled unendorsed informal   $controls state* if responsedummy==1
eststo: reg mistakes foreign female unskilled unendorsed informal   $controls state* if pretest==0 & responsedummy==1
esttab using "$data/t9.tex", se label  star(* 0.05 ** 0.01) b(3) replace
drop _est*

estimates clear




*#*#*#*#*#*#*#*#*#*#*#**#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#
*#*#*# Table 10: Independent vs. centralized agencies *#*#*#*
*#*#*#*#*#*#*#*#*#*#*#**#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#*#

clear
use "$data/data.dta", clear
tab state, gen(statestate)
drop state
set more off
gl controls "ALQ2013 independent migrantshare"
eststo: reg responsedummy foreign female unskilled unendorsed informal if independent==1
eststo: reg responsedummy foreign female unskilled unendorsed informal $controls state* if independent==1
eststo: reg responsedummy foreign female unskilled unendorsed informal if independent==0
eststo: reg responsedummy foreign female unskilled unendorsed informal $controls state* if independent==0
eststo: reg responsequality_linear_avg foreign female unskilled unendorsed informal if independent==1  & responsedummy==1
eststo: reg responsequality_linear_avg foreign female unskilled unendorsed informal  $controls state* if independent==1  & responsedummy==1
eststo: reg responsequality_linear_avg foreign female unskilled unendorsed informal if independent==0  & responsedummy==1
eststo: reg responsequality_linear_avg foreign female unskilled unendorsed informal $controls state* if independent==0  & responsedummy==1
eststo: reg friendlinessavg  foreign female unskilled unendorsed informal if independent==1  & responsedummy==1
eststo: reg friendlinessavg  foreign female unskilled unendorsed informal $controls state* if independent==1  & responsedummy==1
eststo: reg friendlinessavg  foreign female unskilled unendorsed informal if independent==0  & responsedummy==1
eststo: reg friendlinessavg  foreign female unskilled unendorsed informal $controls state* if independent==0  & responsedummy==1
esttab using "$data/t10.tex", se label  star(* 0.05 ** 0.01) b(3) replace
drop _est*


estimates clear



*#*#*#*#*#*#*#*#*#*#*#**#*#*#*#*#*#*#
*#*#*# East Germany *#*#*#*
*#*#*#*#*#*#*#*#*#*#*#**#*#*#*#*#*#*#

clear
use "$data/data.dta", clear
set more off
tab state, gen(statestate)
drop state
gl controls "ALQ2013 independent migrantshare"
eststo: reg responsedummy foreign female unskilled unendorsed informal if east==1
eststo: reg responsedummy foreign female unskilled unendorsed informal $controls state* if east==1
eststo: reg responsedummy foreign female unskilled unendorsed informal if east==0
eststo: reg responsedummy foreign female unskilled unendorsed informal $controls state* if east==0
eststo: reg responsequality_linear_avg foreign female unskilled unendorsed informal if east==1 & responsedummy==1
eststo: reg responsequality_linear_avg foreign female unskilled unendorsed informal  $controls state* if east==1 & responsedummy==1
eststo: reg responsequality_linear_avg foreign female unskilled unendorsed informal if east==0 & responsedummy==1
eststo: reg responsequality_linear_avg foreign female unskilled unendorsed informal $controls state* if east==0 & responsedummy==1
eststo: reg friendlinessavg  foreign female unskilled unendorsed informal if east==1 & responsedummy==1
eststo: reg friendlinessavg  foreign female unskilled unendorsed informal $controls state* if east==1 & responsedummy==1
eststo: reg friendlinessavg  foreign female unskilled unendorsed informal if east==0 & responsedummy==1
eststo: reg friendlinessavg  foreign female unskilled unendorsed informal $controls state* if east==0 & responsedummy==1
esttab using "$data/eg.tex", se label  star(* 0.05 ** 0.01) b(3) replace
drop _est*

estimates clear



*#*#*#*#*#*#*#*#*#*#*#**#*#*#*#*#*#*#*#*#*#
*#*#*# Table 12: Interaction Formal *#*#*#*
*#*#*#*#*#*#*#*#*#*#*#**#*#*#*#*#*#*#*#*#*#

clear
use "$data/data.dta", clear
tab state, gen(statestate)
drop state
gl controls "ALQ2013 independent migrantshare"
eststo: reg responsedummy foreign female unskilled unendorsed if informal==1 
eststo: reg responsedummy foreign female unskilled unendorsed $controls state* if informal==1
eststo: reg responsedummy foreign female unskilled unendorsed if informal==0
eststo: reg responsedummy foreign female unskilled unendorsed $controls state* if informal==0
eststo: reg responsequality_linear_avg foreign female unskilled unendorsed if informal==1 & responsedummy==1
eststo: reg responsequality_linear_avg foreign female unskilled unendorsed $controls state* if informal==1 & responsedummy==1
eststo: reg responsequality_linear_avg foreign female unskilled unendorsed if informal==0 & responsedummy==1
eststo: reg responsequality_linear_avg foreign female unskilled unendorsed $controls state* if informal==0 & responsedummy==1
eststo: reg friendlinessavg  foreign female unskilled unendorsed if informal==1 & responsedummy==1
eststo: reg friendlinessavg  foreign female unskilled unendorsed $controls state* if informal==1 & responsedummy==1
eststo: reg friendlinessavg  foreign female unskilled unendorsed if informal==0 & responsedummy==1
eststo: reg friendlinessavg  foreign female unskilled unendorsed $controls state* if informal==0 & responsedummy==1
esttab using "$data/t12.tex", se label  star(* 0.05 ** 0.01) b(3) replace
drop _est*

estimates clear


*#*#*#*#*#*#*#*#*#*#*#**#*#*#*#*#*#*#*#*#*#*#
*#*#*# Table 13: Interaction Endorsed *#*#*#*
*#*#*#*#*#*#*#*#*#*#*#**#*#*#*#*#*#*#*#*#*#*#


clear
use "$data/data.dta", clear
set more off
tab state, gen(statestate)
drop state
gl controls "ALQ2013 independent migrantshare"

eststo: reg responsedummy foreign female unskilled informal if unendorsed==1
eststo: reg responsedummy foreign female unskilled informal $controls state* if unendorsed==1
eststo: reg responsedummy foreign female unskilled informal if unendorsed==0
eststo: reg responsedummy foreign female unskilled informal $controls state* if unendorsed==0
eststo: reg responsequality_linear_avg foreign female unskilled informal if unendorsed==1 & responsedummy==1
eststo: reg responsequality_linear_avg foreign female unskilled informal $controls state* if unendorsed==1 & responsedummy==1
eststo: reg responsequality_linear_avg foreign female unskilled informal if unendorsed==0 & responsedummy==1
eststo: reg responsequality_linear_avg foreign female unskilled informal $controls state* if unendorsed==0 & responsedummy==1
eststo: reg friendlinessavg  foreign female unskilled informal if unendorsed==1 & responsedummy==1
eststo: reg friendlinessavg  foreign female unskilled informal $controls state* if unendorsed==1 & responsedummy==1
eststo: reg friendlinessavg  foreign female unskilled informal if unendorsed==0 & responsedummy==1
eststo: reg friendlinessavg  foreign female unskilled informal $controls state* if unendorsed==0 & responsedummy==1
esttab using "$data/t13.tex", se label  star(* 0.05 ** 0.01) b(3) replace
drop _est*

estimates clear


*#*#*#*#*#*#*#*#*#*#*#**#*#*#*#*#*#*#*#*#*
*#*#*# Table 14: Interaction Skill *#*#*#*
*#*#*#*#*#*#*#*#*#*#*#**#*#*#*#*#*#*#*#*#*

clear
use "$data/data.dta", clear
set more off
tab state, gen(statestate)
drop state
gl controls "ALQ2013 independent migrantshare"

eststo: reg responsedummy foreign female unendorsed informal if unskilled==1
eststo: reg responsedummy foreign female unendorsed informal $controls state*  if unskilled==1
eststo: reg responsedummy foreign female unendorsed informal if unskilled==0
eststo: reg responsedummy foreign female unendorsed informal $controls state* if unskilled==0
eststo: reg responsequality_linear_avg foreign female unendorsed informal if unskilled==1 & responsedummy==1
eststo: reg responsequality_linear_avg foreign female unendorsed informal $controls state* if unskilled==1 & responsedummy==1
eststo: reg responsequality_linear_avg foreign female unendorsed informal if unskilled==0 & responsedummy==1
eststo: reg responsequality_linear_avg foreign female unendorsed informal $controls state* if unskilled==0 & responsedummy==1
eststo: reg friendlinessavg  foreign female unendorsed informal if unskilled==1 & responsedummy==1
eststo: reg friendlinessavg  foreign female unendorsed informal $controls state* if unskilled==1 & responsedummy==1
eststo: reg friendlinessavg  foreign female unendorsed informal if unskilled==0 & responsedummy==1
eststo: reg friendlinessavg  foreign female unendorsed informal $controls state* if unskilled==0 & responsedummy==1

esttab using "$data\t14.tex", se label  star(* 0.05 ** 0.01) b(3) replace
drop _est*

estimates clear


*#*#*#*#*#*#*#*#*#*#*#**#*#*#*#*#*#*#*#*#*#
*#*#*# Table 15: Interaction Female *#*#*#*
*#*#*#*#*#*#*#*#*#*#*#**#*#*#*#*#*#*#*#*#*#

clear
use "$data/data.dta", clear
set more off
tab state, gen(statestate)
drop state
gl controls "ALQ2013 independent migrantshare"
eststo: reg responsedummy foreign unskilled unendorsed informal if female==1
eststo: reg responsedummy foreign unskilled unendorsed informal $controls state* if female==1
eststo: reg responsedummy foreign unskilled unendorsed informal if female==0
eststo: reg responsedummy foreign unskilled unendorsed informal $controls state* if female==0
eststo: reg responsequality_linear_avg foreign unskilled unendorsed informal if female==1 & responsedummy==1
eststo: reg responsequality_linear_avg foreign unskilled unendorsed informal $controls state* if female==1 & responsedummy==1
eststo: reg responsequality_linear_avg foreign unskilled unendorsed informal if female==0 & responsedummy==1
eststo: reg responsequality_linear_avg foreign unskilled unendorsed informal $controls state* if female==0 & responsedummy==1
eststo: reg friendlinessavg  foreign unskilled unendorsed informal if female==1 & responsedummy==1
eststo: reg friendlinessavg  foreign unskilled unendorsed informal $controls state* if female==1 & responsedummy==1
eststo: reg friendlinessavg  foreign unskilled unendorsed informal if female==0 & responsedummy==1
eststo: reg friendlinessavg  foreign unskilled unendorsed informal $controls state* if female==0 & responsedummy==1

esttab using "$data\t15.tex", se label  star(* 0.05 ** 0.01) b(3) replace
drop _est*

estimates clear


*#*#*#*#*#*#*#*#*#*#*#**#*#*#*#*#*#*#*#*#*#*#**#*#*#*#
*#*#*# Table 16: Benchmark compared to appeals *#*#*#*
*#*#*#*#*#*#*#*#*#*#*#**#*#*#*#*#*#*#*#*#*#*#**#*#*#*#

clear
use "$data/data.dta", clear
tab state, gen(statestate)
drop state
set more off
gl controls "ALQ2013 independent migrantshare"

eststo: reg responsedummy foreign female unskilled unendorsed informal $controls 
eststo: reg responsedummy foreign female unskilled unendorsed informal $controls appeals_accept
eststo: reg responsedummy foreign female unskilled unendorsed informal $controls if appeals !=.

eststo: reg responsequality_linear_avg  foreign female unskilled unendorsed informal $controls if responsedummy==1
eststo: reg responsequality_linear_avg foreign female unskilled unendorsed informal $controls appeals_accept if responsedummy==1
eststo: reg responsequality_linear_avg foreign female unskilled unendorsed informal  $controls if appeals !=. & responsedummy==1

eststo: reg friendlinessavg  foreign female unskilled unendorsed informal $controls  if responsedummy==1
eststo: reg friendlinessavg  foreign female unskilled unendorsed informal $controls appeals_accept if responsedummy==1
eststo: reg friendlinessavg foreign female unskilled unendorsed informal $controls if appeals !=. & responsedummy==1

esttab using "$data\t16.tex", se label  star(* 0.05 ** 0.01) b(3) replace

estimates clear





*#*#*#*#*#*#*#*#*#*#*#**#*#*#*#*#*#*#*#*
*#*#*# Table 17: Mean imputation *#*#*#*
*#*#*#*#*#*#*#*#*#*#*#**#*#*#*#*#*#*#*#*




*** Two imputation methods: mean imputation, multiple imputation via OLS ***


*#*#*#*#*#*#* For responsequality 

clear
set more off
set matsize 10000, perm
use "$data/data.dta", clear


*** 1. Without covariate with missingness ***
eststo: reg responsequality_linear_avg foreign female unskilled unendorsed informal  ALQ2013 independent migrantshare if responsedummy==1

*** 2. With missing covariate, without any imputation ***
eststo: reg responsequality_linear_avg foreign female unskilled unendorsed informal  ALQ2013 independent migrantshare appeals_accept if responsedummy==1

*** 3. With covariate with missingness, but mean imputation for missing data ***

egen m_appeals_accept = mean(appeals_accept)
gen appeals_accept_a = appeals_accept
replace appeals_accept_a = m_appeals_accept if appeals_accept ==.
reg responsequality_linear_avg foreign female unskilled unendorsed informal ALQ2013 independent migrantshare appeals_accept_a if responsedummy==1
eststo: reg responsequality_linear_avg foreign female unskilled unendorsed informal ALQ2013 independent migrantshare appeals_accept_a if responsedummy==1

drop appeals_accept_a m_appeals_accept

esttab using "$data/impute1.tex", se label  star(* 0.05 ** 0.01) b(3) replace
drop _est*

estimates clear


*** 4. With covariate with missingness, but multiple imputation via OLS for missing data***

* Impute appeals_accept using all other vars (including dep var)

* set mi (REQUIRED)
mi set wide

* register var as imputed
mi register imputed appeals_accept

* imputation 
* syntax: mi impute *METHOD* *IMPUTED VAR* *ALL OTHER VARS*, *ARGUMENTS

* arguments: add(x): x is number of imputations. recommended: 10
*            force: force imputation when missings are present in indep. vars
*            rseed(123): set seed for sampling
*            dots: show progress bar

mi impute reg appeals_accept responsequality_linear_avg foreign female ///
 unskilled unendorsed informal ALQ2013 independent migrantshare if responsedummy==1, ///
 rseed(123) add(10) dots force  
 
* estimation
* syntax: mi estimate: *METHOD* *DEP VAR* *INDEP VARS*, *ARGUMENTS*
 
mi estimate: reg responsequality_linear_avg foreign female unskilled unendorsed informal  ALQ2013 independent migrantshare appeals_accept  if responsedummy==1

* store 
 
eststo m_1

esttab using "$data/impute2.tex", se label  star(* 0.05 ** 0.01) b(3) replace


* unset mi (REQUIRED)

mi unset

estimates clear




*#*#*#*#*#*#* For friendliness 

clear
set more off
set matsize 10000, perm
use "$data/data.dta", clear


*** 1. Without covariate with missingness *** 
eststo: reg friendlinessavg foreign female unskilled unendorsed informal  ALQ2013 independent migrantshare if responsedummy==1

*** 2. With missing covariate, without any imputation ***
eststo: reg friendlinessavg foreign female unskilled unendorsed informal  ALQ2013 independent migrantshare appeals_accept if responsedummy==1

*** 3. With covariate with missingness, but mean imputation for missing data ***

egen m_appeals_accept = mean(appeals_accept)
gen appeals_accept_a = appeals_accept
replace appeals_accept_a = m_appeals_accept if appeals_accept ==.

eststo: reg friendlinessavg foreign female unskilled unendorsed informal ALQ2013 independent migrantshare appeals_accept_a if responsedummy==1

drop appeals_accept_a m_appeals_accept

esttab using "$data/impute3.tex", se label  star(* 0.05 ** 0.01) b(3) replace
drop _est*


estimates clear


*** 4. With covariate with missingness, but multiple imputation via OLS for missing data***

* Impute appeals_accept using all other vars (including dep var)

* set mi (REQUIRED)
mi set wide

* register var as imputed
mi register imputed appeals_accept

* imputation 
* syntax: mi impute *METHOD* *IMPUTED VAR* *ALL OTHER VARS*, *ARGUMENTS

* arguments: add(x): x is number of imputations. recommended: 10
*            force: force imputation when missings are present in indep. vars
*            rseed(123): set seed for sampling
*            dots: show progress bar

mi impute reg appeals_accept friendlinessavg foreign female ///
 unskilled unendorsed informal ALQ2013 independent migrantshare if responsedummy==1, ///
 rseed(123) add(10) dots force
 
* estimation
* syntax: mi estimate: *METHOD* *DEP VAR* *INDEP VARS*, *ARGUMENTS*
 
mi estimate: reg friendlinessavg foreign female unskilled unendorsed informal  ALQ2013 independent migrantshare appeals_accept if responsedummy==1

* store 
 
eststo m_1

* unset mi (REQUIRED)

mi unset

estimates clear






