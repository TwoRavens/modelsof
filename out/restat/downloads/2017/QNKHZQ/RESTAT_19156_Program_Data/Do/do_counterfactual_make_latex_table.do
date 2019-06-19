* Paper: "The Economics of Attribute-Based Regulation: Theory and Evidence from Fuel-Economy Standards"
* Authors: Koichiro Ito and James Sallee 
* Also see "readme.txt" file 

*********************
*** Analysis 
*********************

loc safetylossperkg = 18.4181818182
scalar drop _all

* Get estimates
foreach rc in 0 1  {
loc filename "counterfactual_rc`rc'"
insheet using "TableText/Results_`filename'.txt",clear case
foreach v of varlist* {
scalar s`rc'_`v' = `v'[1]
}
foreach y in ABR Flat Efficient {
scalar s`rc'_da_`y' = 100*s`rc'_da_`y'
scalar s`rc'_totalpayoff_`y' = `safetylossperkg'*s`rc'_da_`y'
scalar s`rc'_payoff_`y' = - s`rc'_payoff_`y'
}
scalar list
}

* Get SE
foreach rc in 0 1  {
loc filename "counterfactual_rc`rc'"
use "TableText/bootstrap_`filename'",clear 
* make some variables  
foreach y in ABR Flat Efficient {
replace da_`y' = 100*da_`y'
g totalpayoff_`y' = `safetylossperkg'*da_`y'
replace payoff_`y' = - payoff_`y'
}
foreach p in Efficient Flat ABR {
g payoffratio_`p' = payoff_`p'/payoff_Efficient
}
collapse (sd) _all 
foreach v of varlist* {
scalar se`rc'_`v' = `v'[1]
}
}
scalar list

* Make tex file
loc vlist "de da payoff payoffratio mc_sd totalpayoff"
capture file close myfile
file open myfile using "Paper/tables/counterfactual.tex", write replace
foreach rc in 0 1  {
loc panelname0 "Panel A: Based on logit estimates"
loc panelname1 "Panel B: Based on random-coefficient logit estimates"
if `rc'==0 file write myfile "\\ \multicolumn{7}{l}{`panelname`rc''} \\ \\"
if `rc'==1 file write myfile "\\ \multicolumn{7}{l}{`panelname`rc''} \\ \\"
foreach p in Efficient Flat ABR {
foreach se in 0 1 {
scalar s`rc'_payoffratio_`p' = s`rc'_payoff_`p'/s`rc'_payoff_Efficient
if `se'==0 file write myfile _n "`p'"
if `se'==1 file write myfile _n ""
foreach v in `vlist' {
if `se'==0 {
if "`v'"=="payoff" | "`v'"=="cost_de" | "`v'"=="cost_da" | "`v'"=="mc_sd" | "`v'"=="totalpayoff" file write myfile " & "  %12.0f (s`rc'_`v'_`p') " "
if "`v'"=="de"  file write myfile " & "  %12.2f (s`rc'_`v'_`p') " "
if "`v'"=="da" file write myfile " & "  %12.2f (s`rc'_`v'_`p') " "
if "`v'"=="payoffratio" file write myfile " & "  %12.2f (s`rc'_`v'_`p') " "
}
if `se'==1 {
if "`v'"=="payoff" | "`v'"=="cost_de" | "`v'"=="cost_da" | "`v'"=="mc_sd" | "`v'"=="totalpayoff" file write myfile " & " "("  %1.0f (se`rc'_`v'_`p') ") "
if "`v'"=="da" file write myfile " & " "("  %3.2f (se`rc'_`v'_`p') ") "
if "`v'"=="de" file write myfile " & " "("  %3.2f (se`rc'_`v'_`p') ") "
if "`v'"=="payoffratio" file write myfile " & " "(" %3.2f (se`rc'_`v'_`p') ") "
}
*v
}
file write myfile "\\ "
if `se'==1 file write myfile "\addlinespace "
}
}
}
*file write myfile "\addlinespace "
capture file close myfile

*** END
