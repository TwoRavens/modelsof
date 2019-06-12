/*************************************************************************************************************
This .do file makes table 7 in Chodorow-Reich, Coglianese, and Karabarbounis, "The Macro Effects of Unemployment Benefit Extensions"
*************************************************************************************************************/

clear all
set more off
discard

/*************************************************************************************************************
Load data
*************************************************************************************************************/
use $spendingdataset

/*************************************************************************************************************
Regressions
*************************************************************************************************************/
local lag = 2
local filename tab7
local sample `"if !inlist(abbrev,"DC")"'
local absorb `"FIPS timevar"'

foreach depvar in autosales permits {

	local c = 0
	
	foreach rhs in L`lag'.TUR L`lag'.RealtimeTUR "L`lag'.`revised'TUR L`lag'.RealtimeTUR" {
		local c = `c'+1
		local nregs = `nregs' + 1
				
		if `"`absorb'"'!=`""' {
			di `"reghdfe `depvar'_pc `rhs' `sample', absorb(`absorb') cluster(FIPS timevar)"'
			qui reghdfe `depvar'_pc `rhs' `sample', absorb(`absorb') cluster(FIPS timevar)
		}
		else {
			di `"ivreg2 `depvar'_pc `rhs' `sample' , cluster(FIPS timevar)"'
			qui ivreg2 `depvar'_pc `rhs' `sample' , cluster(FIPS timevar)
		}
					
		foreach absorbvar in FIPS timevar {
			if regexm(`"`e(absvars)'"',`"`absorbvar'"') {
				qui estadd local `absorbvar'FE `"Yes"' 
			}
			else {
				qui estadd local `absorbvar'FE `"No"'
			}
		}

		qui sum `e(depvar)' if e(sample)
		foreach stat in mean sd {
			qui estadd sca `stat'depvar = r(`stat')
		}
		qui eststo
	}
	local groups2 `"`groups2' & \multicolumn{`c'}{c}{`: variable label `e(depvar)''}"'
	local midrules2 `"`midrules2' \cmidrule(lr{.75em}){`=`nregs'+2-`c''-`=`nregs'+1'}"'
}

/*Regression tables*/
local groups1 `"& \multicolumn{`nregs'}{c}{Dependent variable:}"'
local midrules1 `"\cmidrule(l{.75em}){2-`=`nregs'+1'}"'
local groups `" "`groups1'\\ `midrules1'" "`groups2'\\ `midrules2'" "'	
local stats "FIPSFE timevarFE meandepvar sddepvar r2 N"
local stats_fmt "%3s %3s %9.1f %9.1f %12.2f %12.0fc"
local stats_label `" `"State FE"' `"Time FE"' `"Dep. var. mean"' `"Dep. var. sd"' `"\$ R^2$"' `"Observations"' "'
local num_stats: word count `stats' 
local layout
forvalues l = 1/`num_stats' {
	local layout `"`layout' "\multicolumn{1}{c}{@}" "'
}
local dropvars `" _I* o.* 0b.* _cons *.year `controls' *EDUC *SEX"'
local varlabels `"L.`revised'TUR `"\$ \text{Revised UR}_{s,t-1}$"' L.RealtimeTUR `"\$ \text{Real-time UR}_{s,t-1}$"' L2.`revised'TUR `"\$ \text{Revised UR}_{s,t-2}$"' L2.RealtimeTUR `"\$ \text{Real-time UR}_{s,t-2}$"' "'
local title `"Does Spending Correspond to Revised or Real-time Data?"'
local table_preamble `" "\begin{table}[!t] \centering \sisetup{table-format=1.2} \def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" "\caption{`title'}" "\begin{tabularx}{\hsize}{@{\hskip\tabcolsep\extracolsep\fill}l*{`nregs'}{S}}" "\\" "\hline\hline" "'
local prehead `"prehead(`table_preamble' `groups')"'			
local posthead `"posthead(`"\hline"' `"\multicolumn{`=`nregs'+1'}{l}{Right hand side variables:}\\"' `"\\"')"'
local notes `"Notes: the dependent variable is indicated in the table header. The auto sales data come from R.L. Polk and correspond to the state of residency of the purchaser. The permits data are for new private housing units and come from the Census Bureau. Standard errors clustered by state and month in parentheses."'
local prefoot(" ")
local postfoot `"postfoot(`"\hline\hline \\ \end{tabularx} \begin{minipage}{\hsize} \rule{0pt}{9pt} \footnotesize `notes'  \end{minipage} \label{tab:`filename'} \end{table}"')"'
esttab * using output/`filename'.tex,  replace cells(b(star fmt(%9.2f)) se(par fmt(%9.2f) abs)) starlevels(\$^{+}$ 0.1 \$^{*}$ 0.05 \$^{**}$ 0.01) drop(`dropvars', relax) keep(`keepvars') `prehead' `posthead' `postfoot' order(`order') label varlabel(`varlabels') stats(`stats', layout(`layout') fmt(`stats_fmt') labels(`stats_label')) collabels(,none) numbers nomtitles substitute(# `" X "' tabular* tabularx `"{1}{c}{("' `"{1}{L}{("') width(\hsize)	
estimates drop _all

						
