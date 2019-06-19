* Paper: "The Economics of Attribute-Based Regulation: Theory and Evidence from Fuel-Economy Standards"
* Authors: Koichiro Ito and James Sallee 
* Also see "readme.txt" file 

*********************
*** Analysis 
*********************

forval b=1/100 {	
foreach nrep in 50  {
foreach rc in 0 1 {
foreach compliance in 0 {

* Compliance
if `compliance'==0 loc compvar ""
if `compliance'==1 loc compvar "comp_at_old compliance"

* Functional form for cost functions 
loc quadratic "d_weight_min_2 d_liter_km_2"
loc int "d_liter_km_weight_min"
loc costvar "`quadratic' `int'"

if `rc'==0 {
* DCM (no random coef)
loc rhs "`costvar'  `compvar'  subsidy"
}

if `rc'==1 {
loc rand "`costvar'"
loc rhs " `compvar'  subsidy"
}

if `rc'==2 {
loc rand "`costvar' `compvar'"
loc rhs "subsidy"
}

if `rc'==0 {
* Datafile
use "DataStata/bootstrap/mixlogit_b`b'", clear

* Est filename
loc estfile "b`b'_result_mixlogit_rc`rc'_nrep`nrep'_compliance`compliance'"
eststo clear
est use Temp/`estfile'
eststo
esttab,star(* 0.1 ** 0.05 *** 0.01)
esttab using Temp/test.csv,nostar noobs replace
insheet using Temp/test.csv,clear
destring v2,replace force
drop if v1=="" | v2==.
count
forval v = 1/`r(N)' {
loc vname = v1[`v']
g b_`vname' = v2[`v']
}
drop v1 v2
keep if _n==1
expand 1000
g id = _n
sort id
compress
save "TableText/b_para_`estfile'",replace
}

if `rc'>=1 {
* Datafile
use "DataStata/bootstrap/mixlogit_b`b'", clear

* Est filename
loc estfile "b`b'_result_mixlogit_rc`rc'_nrep`nrep'_compliance`compliance'"
eststo clear
est use Temp/`estfile'
eststo
esttab,star(* 0.1 ** 0.05 *** 0.01)
mixlbeta `rhs' `rand', saving("Temp/para_`estfile'") replace
preserve 
use "Temp/para_`estfile'",clear
foreach v in `rhs' `rand' {
rename `v' b_`v'
}
sort id
compress
save "TableText/b_para_`estfile'",replace
restore 
}
*compliance
}
*rc
}
*nrep
}
*b
}
* END
