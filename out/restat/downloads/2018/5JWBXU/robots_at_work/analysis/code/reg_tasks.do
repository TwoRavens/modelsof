* robots - contorlling for task variables 
	
		// specifications
	local outcome "prod"
	local iv "hours_replace" 
	local file `"tasks"'
				
	local robvar "ch_rob_pctile"
	
	#delimit ;
	local cntrls "i.num_c lw0 kl0"; 
	local xvars1 ""; local xvars2 "`xvars1' ch_kl ch_kitsh"; 
	local xvars3 "`xvars1' task_*"; local xvars4 "`xvars2' task_*";
		
	#delimit cr		
	local regopt "`cntrls' [w=$weights], partial(`cntrls') $se"
		
		// table options 
	local extracols "1 5"
	
	local mgroups `"mgroups("OLS" "IV", pattern(1 0 0 0 1 0 0 0) span prefix(\multicolumn{@span}{c}{) suffix(}))"'
		
	local substitute `"ch_rob_pctile "Robot adoption" ch_kl "$\Delta K$" ch_kitsh "$\Delta(K_{ICT}/K)$""'	
	local substitute `"`substitute' task_abstract "Abstract" task_routine "Routine" task_manual "Manual""'	
	local substitute `"`substitute' task_offshorability "Offshoreability""'	
	
	local keepvars "ch_rob_pctile ch_kl ch_kitsh task_*"
	
	local tabopt `"replace fragment booktabs nomtitles nonotes nostar noobs se b(2) `mgroups' extracols(`extracols') substitute(`substitute')"'
	local tabopt `"`tabopt' keep(`keepvars') order(`keepvars') stats(rkf N, l(F-statistic Observations) fmt(1 0))"'  
		
		// regressions
	eststo clear
	
u if ind_rob!="" using "$maindataset", clear
	
			// normalize DD task measures
	foreach var in task_routine task_abstract task_manual task_offsh {
		sum `var' [w=share0_rob]
		replace `var' = ( `var' - r(mean) )/r(sd)
		sum `var' [w=share0_rob]
	}
	
	local regli_ols ""
	local regli_iv ""
	forval i = 1/4 {
				
		ivreg2 ch_`outcome' `robvar' `xvars`i'' `regopt' 
		eststo ols_`i'
		local regli_ols "`regli_ols' ols_`i'"
		
		ivreg2 ch_`outcome' ( `robvar' = `iv' ) `xvars`i'' `regopt' 
		eststo iv_`i'
		local regli_iv "`regli_iv' iv_`i'"		
	}
		
	local regli "`regli_ols' `regli_iv'"
	
	esttab `regli' using "$outpath\reg_`file'.tex", `tabopt'
		
