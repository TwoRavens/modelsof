** robots: industry-level graphs of OLS, reduced form, and 1st stage

u "$maindataset", clear 
		
* shorten industry names
	
	do shortname industry
			
	local ivdescr "`0'"
	
	collapse prod = ch_prod ch_rob repl = hours_replace arms = robots_dot91_phs, by(industry_name)
	
	xtile rdcile = ch_rob, nq(10)
		
	la var repl "Fraction of hours replaceable"
	la var arms "Task intensity: reaching & handling" 
	la var rdcile "Decile of change in #robots/hours"
	la var prod "Change in log(VA/hours)"
	
	local yaxis_prod "ysc(r(-0.5 1.5)) ylab(-0.5 0 0.5 1 1.5)"
	local yaxis_rdcile ""
	local yaxis_arms ""
	local yaxis_repl ""
	
	local xaxis_prod ""
	local xaxis_rdcile "xsc(r(-0.5 11.75))"
	local xaxis_arms "xsc(r(0.275 0.525))"
	local xaxis_repl "xsc(r(-0.05 0.425))"
	
	local sctopt `"m(none) sch(s2mono) graphregion(c(white)) mlabel(industry_name)"'
	local sctopt `"`sctopt' mlabsize(medsmall) mlabpos(0) legend(off)"' 
	local sctopt `"`sctopt' ytitle("\`ytitle'") \`yaxis_\`yvar'' \`xaxis_\`xvar''"' 
		
	local yvars_1 "prod prod prod" 
	local xvars_1 "rdcile repl arms" 
	local yvars_2 "arms rdcile rdcile" 
	local xvars_2 "repl repl arms" 
	
	forval i = 1/2 {
		forval j = 1/3 {
			local xvar : word `j' of `xvars_`i'' 
			local yvar : word `j' of `yvars_`i'' 
			local ytitle : variable label `yvar'
			
			twoway (lfit `yvar' `xvar')(scatter `yvar' `xvar', `sctopt')
			graph export "$outpath/`yvar'_`xvar'.pdf", replace
		}
	}
