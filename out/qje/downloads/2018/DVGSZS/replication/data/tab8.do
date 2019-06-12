clear all
set more off

/*************************************************************************************************************
This do-file runs unemployment vintage horse race regressions using the Michigan Survey of Consumers
*************************************************************************************************************/

run paths
local load
local overwrite on

/*************************************************************************************************************
Load data set
*************************************************************************************************************/
if `"`load'"'!=`""' {
	run load-MSC /*Must have already saved raw data. See load-MSC.do file for details*/
	run for-msc-data-merge /*File with relevant state identifiers purchased from MSC*/
	tempfile state
	qui save `state'
	use $DataPath/msc, clear
	merge 1:1 YYYYMM ID using `state', keepusing(state abbreviation FIPS) assert(master matched) nogenerate
	gen monthly = monthly(substr(string(YYYYMM),1,4)+"m"+substr(string(YYYYMM),5,2),"YM")
	qui format monthly %tm
	preserve
	qui use ../../ui/data/TUR, clear
	foreach var of varlist TUR {
		foreach l in 1 2 12 {
			qui gen L`l'_`var' = L`l'.`var'
		}
	}
	tempfile tur 
	qui save `tur'
	restore
	merge m:1 monthly abbreviation using `tur', keep(master matched) nogenerate
	preserve
	qui use ../../ui/data/realtime-TUR, clear
	foreach var of varlist RealtimeTUR Month12revisedTUR {
		foreach l in 1 2 12 {
			qui gen L`l'_`var' = L`l'.`var'
		}
	}
	qui save `tur', replace
	restore
	merge m:1 monthly state using `tur', keep(master matched) nogenerate
	preserve
	qui use ../../ui/data/state-data-from-BLS if seasonal=="sa" & year(dofc(vintage))==2014, clear
	rename UR Vintage2014TUR
	qui tsset FIPS monthly
	foreach var of varlist Vintage2014TUR {
		foreach l in 1 2 12 {
			qui gen L`l'_`var' = L`l'.`var'
		}
	}
	qui save `tur', replace
	restore
	merge m:1 monthly FIPS using `tur', keep(master matched) nogenerate keepusing(*Vintage2014TUR)
	
	qui saveold expectations_dataset, replace
	qui gzipfile expectations_dataset.dta, saving("$DataPath/expectations_dataset") replace erase
	label data "Chodorow-Reich, Coglianese, and Karabarbounis (2018) Macro UI Expectations Data Set"
	notes drop _all
	notes: Variables used in Chodorow-Reich, Coglianese, and Karabarbounis, The Macroeconomic Effects of Unemployment Benefit Extensions.
	desc
	saveold $DataPath/crck_ui_macro_expectations_dataset, replace	
	foreach var of varlist abbreviation-state LFN-L12_Vintage2014TUR {
		cap replace `var' = .
		cap replace `var' = ""
	}
	saveold $DataPath/crck_ui_macro_expectations_dataset_publicversion, replace	
}
qui gunzipfile $DataPath/expectations_dataset.7z, replace use erase


gen S_RealtimeTUR = RealtimeTUR-RealtimeL12_TUR /*Note: this is the 12 month change an agent in month t would report*/
gen S_TUR = TUR - L12_TUR
gen S_Month12revisedTUR = Month12revisedTUR - L12_Month12revisedTUR
gen S_Vintage2014TUR = Vintage2014TUR - L12_Vintage2014TUR
egen statemonth = group(FIPS monthly)
lab var TUR "Revised UR"
lab var S_TUR "Revised 12 mo. change"
lab var RealtimeTUR "Real-time UR"
lab var S_RealtimeTUR "Real-time 12 mo. change"
lab var Month12revisedTUR "Annual revision UR"
lab var S_Month12revisedTUR "Annual revision 12 mo. change"
lab var Vintage2014TUR "Vintage 2014 TUR"
lab var S_Vintage2014TUR "Vintage 2014 12 mo. change"
qui gen ErrorTUR = RealtimeTUR - TUR
lab var ErrorTUR `"Real-time error"'
qui gen S_ErrorTUR = S_RealtimeTUR - S_TUR
lab var S_ErrorTUR `"Real-time error 12 mo. change"'
gen lninc = ln(INCOME)

/*Variables for regressions*/
local level_depvars "PJOB PEXP PINC2 INEX DUR CAR BUS12 BUS5" /*Variables where U should enter in levels*/
local backward_depvars "BAGO PAGO" /*Variables where U should enter in changes from year ago*/

/*Normalize  variables*/
foreach var in `level_depvars' `backward_depvars' {
	qui levelsof `var', local(levels)
	foreach level of local levels {
		cap assert !regexm(`"`:label `var' `level''"',`"(DK)|(NA)|(Volunteered)"') /*DK, NA already dropped from data set*/
		if _rc!=0 {
			di `"`var': `level'"'
			qui replace `var' = . if `var'==`level'
		}
	}
	qui sum `var' if !missing(TUR)
	qui gen z_`var' = (`var'-r(mean))/r(sd)
}

/*Composite indicators*/
foreach var in z_PINC2 z_INEX {
	qui replace `var' = `var' * (-1) /*Normalization so that higher is worse*/
}
foreach var of local level_depvars {
	local zlevel_depvars `"`zlevel_depvars' z_`var'"'
}
/*Simple average*/
qui egen AVG = rowmean(`zlevel_depvars')
sum AVG if !missing(TUR)
qui replace AVG = AVG/r(sd)
lab var AVG `"Simple mean of normalized variables."'
gen POOLED = .
lab var POOLED `"pooled regression on normalized variables"'

local level_depvars `"AVG `level_depvars'"'

/*************************************************************************************************************
Regressions
*************************************************************************************************************/
qui gen AGE2 = AGE^2
qui gen AGE3 = AGE^3
local controls "i.SEX AGE AGE2 AGE3 i.EDUC i.MARRY lninc"

local depvars `"`level_depvars'"'

foreach depvar of local depvars {
	local depvarlabel = lower(regexr(`"`:variable label `depvar''"',`"%"',`"\%"'))
	local depvarnotes `"`depvarnotes' `depvar': `depvarlabel'."'
	if !inlist(`"`depvar'"',`"PJOB"',`"PINC2"',`"INEX"',`"AVG"',`"POOLED"') {
		qui levelsof `depvar', local(levels)
		foreach level of local levels {
			if !inlist(`"`:label `depvar' `level''"',`"DK"',`"NA"') {
				local depvarnotes `"`depvarnotes' `level': `:label `depvar' `level''."'	
			}
		}	
	}	
}
local sample `"if !missing(monthly)"' /*Dummy placeholder*/
local weighted "& WT>0 [aw=WT]"
local unweighted ""

*foreach control in bivariate controls TVcontrols {
foreach control in TVcontrols {
	local filenames "`filenames' \clearpage"
	*foreach wt in weighted unweighted {
	foreach wt in weighted {
		*foreach vintage in only Realtimeonly Erroronly Realtime Vintage2014 Month12revised {
		foreach vintage in Realtime {
			foreach absorb in "state_n monthly" monthly "" {
			
				if (inlist(`"`control'"',`"controls"',`"TVcontrols"') & `"`absorb'"'==`""') | (!inlist(`"`vintage'"',`"only"',`"Realtime"') & `"`absorb'"'!=`"state_n monthly"') { 
					continue
				}
				
				local filename msc-`vintage'-`control'-`=regexr(`"`absorb'"',`" "',`"-"')'-`wt'-regressions
				local filenames `"`filenames' \begin{landscape} \input{input-files/`filename'.tex} \end{landscape}"'
				if regexm(`"`: dir `"$OutputPath/input-files"' files `"*.tex"', respectcase'"', `"`filename'.tex"') & `"`overwrite'"'==`""' {
					continue /*Regression table already exists*/
				}			
			
				if `"`control'"'==`"TVcontrols"' {
					local absorb = regexr(`"`absorb'"',`"monthly"',`""')
					foreach var of local controls {
						if regexm(`"`var'"',"^[ic]\.") {
							local absorb `"`absorb' i.monthly#`var'"'
						}
						else {
							local absorb `"`absorb' i.monthly#c.`var'"'
						}
					}
				}
									
				estimates drop _all
				local nregs
				local groups2
				local midrules2
				foreach depvar of local depvars {
				
					if regexm(`"`vintage'"',`"only"') & regexm(`"`level_depvars'"',`"`depvar'"') {
						local Uvars = regexr(`"`vintage'"',`"only$"',`""') + `"TUR"'
					}
					else if regexm(`"`vintage'"',`"only"') & regexm(`"`backward_depvars'"',`"`depvar'"') {
						local Uvars = `"S_"' + regexr(`"`vintage'"',`"only$"',`""') + `"TUR"'
					}					
					else if regexm(`"`level_depvars'"',`"`depvar'"') {
						local Uvars "L2_TUR L2_`vintage'TUR"
					}
					else if regexm(`"`backward_depvars'"',`"`depvar'"') {
						local Uvars "S_TUR S_`vintage'TUR"
					}
								
					if `"`control'"'==`"controls"' {
						local rhs `"`Uvars' `controls'"'
					}
					else {
						local rhs `"`Uvars'"'
					}
					
					if `"`depvar'"'==`"POOLED"' {
						preserve
						qui keep state_n monthly `zlevel_depvars' SEX AGE* MARRY EDUC lninc `Uvars' CASEID WT
						qui reshape long z_, i(state_n monthly CASEID) j(Q) string
						rename z_ POOLED
						lab var POOLED `"pooled regression on normalized variables"'
					}
						
					if `"`absorb'"'!=`""' {
						di `"reghdfe `depvar' `rhs' `sample' ``wt'', absorb(`absorb') cluster(state_n monthly)"'
						qui reghdfe `depvar' `rhs' `sample' ``wt'', absorb(`absorb') cluster(state_n monthly)
					}
					else {
						di `"ivreg2 `depvar' `rhs' `sample' ``wt'', cluster(state_n monthly)"'
						qui ivreg2 `depvar' `rhs' `sample' ``wt'', cluster(state_n monthly)
					}
					
					local nregs = `nregs' + 1
					local groups2 `"`groups2' & \multicolumn{1}{c}{`depvar'}"'
					local midrules2 `"`midrules2' \cmidrule(lr{.75em}){`=`nregs'+1'-`=`nregs'+1'}"'
						
					foreach absorbvar in state_n monthly {
						if regexm(`"`e(absvars)'"',`"`absorbvar'"') {
							qui estadd local `absorbvar'FE `"Yes"' 
						}
						else {
							qui estadd local `absorbvar'FE `"No"'
						}
					}
					if regexm(`"`control'"',`"controls"') {
						qui estadd local controlsYN "Yes"
					}
					else {
						qui estadd local controlsYN "No"
					}
					if `"`wt'"'==`"weighted"' {
						qui estadd local weightYN "Yes"
					}
					else {
						qui estadd local weightYN "No"
					}
					qui sum `depvar' if e(sample)
					foreach stat in mean sd {
						qui estadd sca `stat'depvar = r(`stat')
					}
					qui eststo
					
					if `"`depvar'"'==`"POOLED"' {
						restore
					}

				}

				/*Regression tables*/
				#delimit;
				local groups1 `"& \multicolumn{`nregs'}{c}{Dependent variable:}"';
				local midrules1 `"\cmidrule(l{.75em}){2-`=`nregs'+1'}"';
				local groups `" "`groups1'\\ `midrules1'" "`groups2'\\ `midrules2'" "';	
				local stats "state_nFE monthlyFE weightYN controlsYN meandepvar sddepvar r2 N";
				local stats_fmt "%3s %3s %3s %3s %9.2f %9.2f %12.2f %12.0fc";
				local stats_label `" `"State FE"' `"Time FE"' `"Weighted"' `"Individual controls"' `"Dep. var. mean"' `"Dep. var. sd"' `"\$ R^2$"' `"Observations"' "';
				local num_stats: word count `stats'; 
				local layout;
				forvalues l = 1/`num_stats' {;
					local layout `"`layout' "\multicolumn{1}{c}{@}" "';
				};
				local dropvars `" _I* o.* 0b.* _cons *.year `controls' *EDUC *SEX *MARRY"';
				local varlabels `"L_TUR `"\$ \text{Revised UR}_{s,t-1}$"' L_RealtimeTUR `"\$ \text{Real-time UR}_{s,t-1}$"' L2_TUR `"\$ \text{Revised UR}_{s,t-2}$"' L2_RealtimeTUR `"\$ \text{Real-time UR}_{s,t-2}$"' "';
				local title `"Do Beliefs Correspond to Revised or Real-time Data?"';
				local table_preamble `" "\begin{table}[!t] \centering \sisetup{table-format=1.2} \def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}" "\caption{`title'}" "\begin{tabularx}{\hsize}{@{\hskip\tabcolsep\extracolsep\fill}l*{`nregs'}{S}}" "\\" "\hline\hline" "';
				local prehead `"prehead(`table_preamble' `groups')"';			
				local posthead `"posthead(`"\hline"' `"\multicolumn{`=`nregs'+1'}{l}{Right hand side variables:}\\"' `"\\"')"';
				local notes `"Notes: the dependent variable is indicated in the table header.`depvarnotes' Controls: ``control''. Regressions exclude observations with a response of "DK" or "NA". Standard errors clustered by state and month in parentheses."';
				local prefoot(" ");
				local postfoot `"postfoot(`"\hline\hline \\ \end{tabularx} \begin{minipage}{\hsize} \rule{0pt}{9pt} \footnotesize `notes'  \end{minipage} \label{tab:`filename'} \end{table}"')"';
				esttab * using "$OutputPath/input-files/`filename'.tex",  replace cells(b(star fmt(%9.3f)) se(par fmt(%9.3f) abs)) starlevels(\$^{+}$ 0.1 \$^{*}$ 0.05 \$^{**}$ 0.01) drop(`dropvars', relax) keep(`keepvars') `prehead' `posthead' `postfoot' order(`order') label varlabel(`varlabels') stats(`stats', layout(`layout') fmt(`stats_fmt') labels(`stats_label')) collabels(,none) numbers nomtitles substitute(# `" X "' tabular* tabularx `"{1}{c}{("' `"{1}{L}{("') width(\hsize);	
				estimates drop _all;
				#delimit cr
			}
		}
	}
}

EmbedTex `"`filenames'"' using `"$OutputPath/MSC Regressions.tex"', title(Results) pdflscape replace

						
