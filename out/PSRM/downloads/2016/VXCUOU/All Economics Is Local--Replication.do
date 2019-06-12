*********************************************************************************
*** Replication file for "All Economics Is Local: Spatial Aggregations of Economic Information"
***
*** Created: 3-2-16
*** Modified:
***
*********************************************************************************


*** RUN THE FOLLOWING PROGRAM FIRST!
***************************************************************
cap program drop fit
program define fit, rclass
syntax , [auc cv(integer 0)]
preserve
	quietly {
		if "`cv'" == "0" {
			keep if e(sample)
		}
		if "`cv'" != "0" {
			keep if year == `cv'
			local cmd `e(cmdline)'

			gettoken part cmd : cmd, parse(" !=") quotes
			while `"`part'"' != "!=" & `"`part'"' != "" {
				local left `"`left' `part'"'
				gettoken part cmd : cmd, parse("!=") quotes
			}
			qui `left' == `cv'
			keep if e(sample)
		}
		
		if "`auc'" != "" {	
			tempvar w aucpr3
			gen `w' = retnat
			recode `w' (1/2=0) (3=1)
		
			predict `aucpr3', pr outcome(3)

			replace `aucpr3' = round(`aucpr3', 0.001)
			roctab `w' `aucpr3'
			cap drop `w' `aucpr3'
			
			local auc = round(r(area), 0.001)
			local lo = round(r(lb), 0.001)
			local hi = round(r(ub), 0.001)	
			return local auc = `auc'
			return local auc_lo = `lo'
			return local auc_hi = `hi'
		}
		
		estat ic
		mat S = r(S)
		local aic = S[1,5]
		return local aic = round(`aic', .1)
		local bic = S[1,6]
		return local bic = round(`bic', .1)
		
		foreach o of numlist 1(1)3 {
			tempvar pr`o' sum_pr`o'
		
			predict `pr`o'', pr outcome(`o')
			bys retnat: egen `sum_pr`o'' = sum(`pr`o'')
			qui sum `sum_pr`o'' if retnat == `o'
			local s`o' = r(mean)
		}
		
		tempvar cl max mo
		egen `max' = rowmax(`pr1' `pr2' `pr3')
		gen `cl' = .
		replace `cl' = cond(`max'==`pr1', 1, cond(`max'==`pr2', 2, 3))

		nois tab2 `cl' retnat, col chi2

		qui tab retnat
		local den = r(N)
	
		egen `mo' = mode(retnat)
		qui sum `mo'
		local mode = r(mean)
		qui tab retnat if retnat == `mode'
		local num = r(N)

		qui tab retnat if retnat == `cl'
		local num2 = r(N)
		
		qui tab retnat if retnat == 3
		local denw = r(N)
		
		qui tab retnat if (retnat == 3 & `cl' == 3)
		local numw = r(N)		
		
		return local ePCP = round((`s1' + `s2' + `s3') / _N, .001)
		local ePCP = round((`s1' + `s2' + `s3') / _N, .001)
		
		return local naive_class = 100*(round(`num'/`den', .001))
		return local model_class = 100*(round(`num2'/`den', .001))
		return local worse_class = 100*(round(`numw'/`denw'), .001)
	}
	di _newline(2)
	di "AIC = " `aic'
	di "BIC = " `bic'
	di "Naive classification = " 100*(round(`num'/`den', .001))
	di "Model classification = " 100*(round(`num2'/`den', .001))
	di "ePCP = " 100*`ePCP'
	di "% of worse correctly classified = " 100*(round(`numw'/`denw'), .001)
	if "`auc'" != "" {	
		di "Area under the curve (AUC) = " `auc' "  95% CI = [" `lo' ", " `hi' "]"
	}
restore
end
***************************************************************



*************************************************************************************
*** Load the data and create a couple of variables.
*************************************************************************************
clear
clear matrix
set matsize 1200
set mem 2000m

use "All Economics Is Local.dta", clear

* Simplify the name for the directed W10
rename sp_W10U_gsp_pc2_ch sp_W10_gsp_pc2_ch
rename sp_W10U_gsp_pc2_ch_tm1 sp_W10_gsp_pc2_ch_tm1

tempfile data
save `data', replace

cap log close
log using "All Economics Is Local--Replication.smcl", replace 

*************************************************************************************
*** National Specification
*************************************************************************************
ologit retnat gsp_pc2_ch gdppc_growth ch_unem inflation approve age male nonwhite union college married unemployed own_home ppid noppid


*************************************************************************************
*** NOTE: 
*** W10: Undirected conomic mentions in media (row-standardized)
*** W14: Economic similarity (row-standardized)
*************************************************************************************

*************************************************************************************
*** Table 1: Ordered logit estimates of national economic evaluations using media mentions (W10) and economic similarity (W14) W specifications
*************************************************************************************
foreach W in 10 14 {
	di _newline(2) "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
	di "W`W'"
	ologit retnat age male nonwhite union college married unemployed own_home ppid noppid approve inflation ch_unem gsp_pc2_ch sp_W`W'_gsp_pc2_ch
	
	di "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
}


*************************************************************************************
*** Table 2: Substantive effects of the explanatory variables on the predicted probaiblity of evaluating the national economy as having gotten "worse" over the last 12 months
*************************************************************************************
use `data', clear

tempname wm
tempfile wresults
postfile `wm' model outcome str20 w str20 v d lo hi /*
*/	epcp worse_class model_class naive_class aic bic auc auc_lo auc_hi using `wresults', replace

foreach W in W10 W14 {
	di _newline(3)
	nois display "**************************************"

	nois display "Weights matrix = `W'"

	tempvar pr1_1 pr2_1 pr3_1 g_pr1_2 g_pr2_2 g_pr3_2 gsp_pr1_2 gsp_pr2_2 gsp_pr3_2 dg_pr1 dg_pr2 dg_pr3 dgsp_pr1 dgsp_pr2 dgsp_pr3

	qui ologit retnat age male nonwhite union college married unemployed own_home ppid noppid approve inflation ch_unem gsp_pc2_ch sp_`W'_gsp_pc2_ch
	fit, auc

	local epcp = r(ePCP)
	local worse_class = r(worse_class)
	local model_class = r(model_class)
	local naive_class = r(naive_class)
	local aic = r(aic)
	local bic = r(bic)
		
	local auc = r(auc)
	local auc_lo = r(auc_lo)
	local auc_hi = r(auc_hi)	
	
	set seed 648
	qui estsimp ologit retnat age male nonwhite union college married unemployed own_home ppid noppid approve inflation ch_unem gsp_pc2_ch sp_`W'_gsp_pc2_ch, genname(ggg)	

	setx (age) mean (inflation ch_unem) p25 (male nonwhite union college married unemployed own_home) p50 (ppid noppid) min (approve) max
	simqi, prval(1 2 3)

	setx gsp_pc2_ch 3 sp_`W'_gsp_pc2_ch 3
	simqi, prval(1 2 3) genpr(`pr1_1' `pr2_1' `pr3_1')
	
	setx gsp_pc2_ch 1 sp_`W'_gsp_pc2_ch 3
	simqi, prval(1 2 3) genpr(`g_pr1_2' `g_pr2_2' `g_pr3_2')
	
	setx gsp_pc2_ch 3 sp_`W'_gsp_pc2_ch 1
	simqi, prval(1 2 3) genpr(`gsp_pr1_2' `gsp_pr2_2' `gsp_pr3_2')
	
	*** GSP per capita
	gen `dg_pr1' = `g_pr1_2' - `pr1_1'
	qui sum `dg_pr1'
	local mn_p_1 = round(r(mean), 0.001)
	qui _pctile `dg_pr1', perc(2.5 97.5)
	local lo_p_1 = round(r(r1), 0.001)
	local hi_p_1 = round(r(r2), 0.001)

	gen `dg_pr2' = `g_pr2_2' - `pr2_1'
	qui sum `dg_pr2'
	local mn_p_2 = round(r(mean), 0.001)
	qui _pctile `dg_pr2', perc(2.5 97.5)
	local lo_p_2 = round(r(r1), 0.001)
	local hi_p_2 = round(r(r2), 0.001)

	gen `dg_pr3' = `g_pr3_2' - `pr3_1'
	qui sum `dg_pr3'
	local mn_p_3 = round(r(mean), 0.001)
	qui _pctile `dg_pr3', perc(2.5 97.5)
	local lo_p_3 = round(r(r1), 0.001)
	local hi_p_3 = round(r(r2), 0.001)

	foreach n of numlist 1(1)3 {
		if `n' == 1 { 
			post `wm' (1) (`n') ("`W'") ("GSP") (`mn_p_`n'') (`lo_p_`n'') (`hi_p_`n'') (`epcp') (`worse_class') (`model_class') (`naive_class') (`aic') (`bic') (`auc') (`auc_lo') (`auc_hi') 
		}
		else {
			post `wm' (1) (`n') ("`W'") ("GSP") (`mn_p_`n'') (`lo_p_`n'') (`hi_p_`n'') (.) (.) (.) (.) (.) (.) (.) (.) (.)
		}
	}	
	
	*** GSP per capita: spatial lag
	gen `dgsp_pr1' = `gsp_pr1_2' - `pr1_1'
	qui sum `dgsp_pr1'
	local mn_p_1 = round(r(mean), 0.001)
	qui _pctile `dgsp_pr1', perc(2.5 97.5)
	local lo_p_1 = round(r(r1), 0.001)
	local hi_p_1 = round(r(r2), 0.001)

	gen `dgsp_pr2' = `gsp_pr2_2' - `pr2_1'
	qui sum `dgsp_pr2'
	local mn_p_2 = round(r(mean), 0.001)
	qui _pctile `dgsp_pr2', perc(2.5 97.5)
	local lo_p_2 = round(r(r1), 0.001)
	local hi_p_2 = round(r(r2), 0.001)

	gen `dgsp_pr3' = `gsp_pr3_2' - `pr3_1'
	qui sum `dgsp_pr3'
	local mn_p_3 = round(r(mean), 0.001)
	qui _pctile `dgsp_pr3', perc(2.5 97.5)
	local lo_p_3 = round(r(r1), 0.001)
	local hi_p_3 = round(r(r2), 0.001)
	
	foreach n of numlist 1(1)3 {
		post `wm' (1) (`n') ("`W'") ("GSP SL") (`mn_p_`n'') (`lo_p_`n'') (`hi_p_`n'') (.) (.) (.) (.) (.) (.) (.) (.) (.)  
	}	

	drop ggg*
	nois display _newline(3) "**************************************"
}

postclose `wm'


use `wresults', clear

gen w2 = w
replace w2 = "Media Mentions" if w2 == "W10"
replace w2 = "Economic Similarity" if w2 == "W14"

save "wmodels.dta", replace 

*** Substantive effects of the control variables
use `data', clear

foreach W in W10 W14 {
	di _newline(3)
	nois display "**************************************"
	nois display "Weights matrix = `W'"

	set seed 648
	qui estsimp ologit retnat age male nonwhite union college married unemployed own_home ppid noppid approve inflation ch_unem gsp_pc2_ch sp_`W'_gsp_pc2_ch, genname(ggg)	

	setx (age) mean (inflation ch_unem) p25 (male nonwhite union college married unemployed own_home) p50 (ppid noppid) min (approve) max
	simqi, prval(1 2 3)
	
	simqi, fd(prval(1 2 3)) changex(gsp_pc2_ch 3 1)
	simqi, fd(prval(1 2 3)) changex(sp_`W'_gsp_pc2_ch 3 1)
	simqi, fd(prval(1 2 3)) changex(age 51 67)
	simqi, fd(prval(1 2 3)) changex(male 0 1)
	simqi, fd(prval(1 2 3)) changex(nonwhite 0 1)
	simqi, fd(prval(1 2 3)) changex(union 0 1)
	simqi, fd(prval(1 2 3)) changex(college 0 1)
	simqi, fd(prval(1 2 3)) changex(married 0 1)
	simqi, fd(prval(1 2 3)) changex(unemployed 0 1)	
	simqi, fd(prval(1 2 3)) changex(own_home 0 1)
	simqi, fd(prval(1 2 3)) changex(ppid 0 1)
	simqi, fd(prval(1 2 3)) changex(noppid 0 1)
	simqi, fd(prval(1 2 3)) changex(approve 0 1)
	simqi, fd(prval(1 2 3)) changex(inflation 2.4 3.5)
	simqi, fd(prval(1 2 3)) changex(ch_unem 0 1)

	drop ggg*
	nois display _newline(3) "**************************************"
}

*************************************************************************************
*************************************************************************************
*** Robustness Checks
*************************************************************************************
*************************************************************************************

*************************************************************************************
*** Table 1: Ordered logit estimates of national economic evaluations using media mentions (W10) and economic similarity (W14) W specifications: Excluding 2009 and 2010
*************************************************************************************
foreach W in 10 14 {
	di _newline(2) "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
	di "W`W'"
	ologit retnat age male nonwhite union college married unemployed own_home ppid noppid approve inflation ch_unem gsp_pc2_ch sp_W`W'_gsp_pc2_ch if inlist(year, 2006, 2008, 2011, 2012)
	estat ic
	
	di "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
}


*************************************************************************************
*** Table 2: Ordered logit estimates of national economic evaluations using media mentions (W10) and economic similarity (W14) W specifications: lagging state-level conditions
*************************************************************************************
foreach W in 10 14 {
	di _newline(2) "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
	di "W`W'"
	ologit retnat age male nonwhite union college married unemployed own_home ppid noppid approve inflation ch_unem gsp_pc2_ch_tm1 sp_W`W'_gsp_pc2_ch_tm1
	estat ic

	di "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
}

log close


