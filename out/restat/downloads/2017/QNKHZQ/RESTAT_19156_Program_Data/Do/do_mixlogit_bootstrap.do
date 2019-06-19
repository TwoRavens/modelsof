* Paper: "The Economics of Attribute-Based Regulation: Theory and Evidence from Fuel-Economy Standards"
* Authors: Koichiro Ito and James Sallee 
* Also see "readme.txt" file 

*********************
*** Analysis 
*********************

forval b=1/100 {	

* Datafile
use "DataStata/bootstrap/mixlogit_b`b'", clear

foreach nrep in 50  {
foreach rc in 1 0 {
foreach compliance in 0 {

* Compliance
if `compliance'==0 loc compvar ""
if `compliance'==1 loc compvar "comp_at_old compliance"

* Functional form for cost functions 
loc quadratic "d_weight_min_2 d_liter_km_2"
loc int "d_liter_km_weight_min"
loc costvar "`quadratic' `int'"

eststo clear

if `rc'==0 {
* DCM (no random coef)
loc rhs "`costvar'  `compvar'  subsidy"
clogit choice `rhs',group(id)
}

if `rc'==1 {
loc rand "`costvar'"
loc rhs " `compvar'  subsidy"
}

if `rc'==2 {
loc rand "`costvar' `compvar'"
loc rhs "subsidy"
}

if `rc'>=1 mixlogit choice `rhs' , rand(`rand') group(id) nrep(`nrep') 

* Est filename
loc estfile "b`b'_result_mixlogit_rc`rc'_nrep`nrep'_compliance`compliance'"

* Save estimate
est save Temp/`estfile',replace

*compliance
}
*rc
}
*nrep
}
*b
}


