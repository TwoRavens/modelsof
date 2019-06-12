* robots - main OLS and IV results - robustness; no interacted IV! 
	
		// specifications
	local outcomes "prod"
		
	local robvar "ch_rob_pctile"
	
	local basic "i.num_c lw0 kl0"
	local capvars "ch_kl ch_kitsh"
	local skillvars "ch_h_sh_MS ch_h_sh_HS"
	
	#delimit ;
	local xvars1 ""; local xvars2 "`skillvars'"; local xvars3 "`skillvars' ch_lw"; 
	local xvars4 "i.num_ind"; local xvars5 "`xvars3' `xvars4'"; local xvars6 
	"`xvars5' `capvars'";
			
	local cntr_cap_1 ""; local cntr_cap_2 ""; local cntr_cap_3 ""; 
	local cntr_cap_4 ""; local cntr_cap_5 ""; local cntr_cap_6 "$\checkmark$"; 
		
	local cntr_skill_1 ""; local cntr_skill_2 "$\checkmark$"; local cntr_skill_3
	"$\checkmark$"; local cntr_skill_4 ""; local cntr_skill_5 "$\checkmark$"; 
	local cntr_skill_6 "$\checkmark$";
	
	local cntr_lw_1 ""; local cntr_lw_2 ""; local cntr_lw_3 "$\checkmark$"; 
	local cntr_lw_4 ""; local cntr_lw_5 "$\checkmark$"; local cntr_lw_6 
	"$\checkmark$"; 
	
	local cntr_ind_1 ""; local cntr_ind_2 ""; local cntr_ind_3 ""; 
	local cntr_ind_4 "$\checkmark$"; local cntr_ind_5 "$\checkmark$"; 
	local cntr_ind_6 "$\checkmark$"; 
		
	#delimit cr		
	local regopt "`basic' \`xvars\`i'' [w=$weights], partial(`basic' \`xvars\`i'') $se" 
		
		// table options 
	local extracols "1"
		
	#delimit ;
	local stats `"cntr_basic cntr_skill cntr_lw cntr_ind cntr_cap N, l("Country 
	trends \& controls" "Changes in skill mix" "Changes in log wage" "Industry trends" 
	"Changes in other capital" "Observations")"';
	#delimit cr		
	
	local tabopt `"fragment booktabs nolines nomtitles nonotes nostar noobs se b(a2) extracols(`extracols') substitute(ch_rob_pctile "Robot adoption")"'
	
	local tabopt_ols `"`tabopt' replace keep(`robvar') `mgroups'  posthead(\`header')"'
	local tabopt_iv `"`tabopt' append nonum keep(`robvar') stats(rkf, l(F-statistic) fmt(1))  posthead(\`header')"'  
	local tabopt_iv2 `"`tabopt' append nonum keep(`robvar') stats(rkf jp, l("F-statistic" "J-statistic (\emph{p}-value)") fmt(1 2))  posthead(\`header')"'  
	local tabopt_btm `"`tabopt' append nonum keep("") stats(`stats') posthead(\`header')"'
	
		// regressions
	eststo clear
	
	local imax = 6 
	
u if ind_rob!="" using "$maindataset", clear
	
	cap desc arms arms_trans // new IV
	if _rc!=0 {
		gen arms = robots_dot91_phs
		gen arms_trans = robots_dot91_phs*( country=="GER" | country=="US" | country=="SWE" )
	}
	
	foreach y in `outcomes' {
		forval i = 1/`imax' {
			
			ivreg2 ch_`y' `robvar' `regopt' 
			eststo ols_`y'_`i'
			
			if `i'<=3 {
				
				local iv hours_replace
				ivreg2 ch_`y' ( `robvar' = `iv' ) `regopt' 
				eststo hours_replace_`y'_`i'
			
				local iv arms
				ivreg2 ch_`y' ( `robvar' = `iv' ) `regopt' 
				eststo arms_`y'_`i'
			
				local iv hours_replace arms
				ivreg2 ch_`y' ( `robvar' = `iv' ) `regopt' 
				eststo repl_arms_`y'_`i'
			}
			if `i'>=4 {
				
				ivreg2 ch_`y' 
				eststo hours_replace_`y'_`i'
			
				ivreg2 ch_`y' 
				eststo arms_`y'_`i'
			
				ivreg2 ch_`y' 
				eststo repl_arms_`y'_`i'
			}			
			
			qui reg ch_prod `xvars`i''		
			estadd local cntr_basic "$\checkmark$"
			estadd local cntr_cap "`cntr_cap_`i''"
			estadd local cntr_skill "`cntr_skill_`i''"
			estadd local cntr_lw "`cntr_lw_`i''"
			estadd local cntr_ind "`cntr_ind_`i''"
			eststo bottom_`y'_`i'
		}
	}
	
	#delimit ; 
	local list_ols ""; local list_hours_replace ""; local list_arms ""; local list_bottom "";
	#delimit cr
	foreach case in ols hours_replace arms repl_arms bottom {
		local list_`case' ""
		foreach y in `outcomes' {
			forval i = 1/`imax' {
			
				local list_`case' "`list_`case'' `case'_`y'_`i'"
			}
		}
	}	
	
	local file "mainRobust"
	
	local header "\midrule\addlinespace\multicolumn{@span}{l}{\emph{A. OLS}} \\"
	esttab `list_ols' using "$outpath\reg_`file'.tex", `tabopt_ols'
	
	local header "\midrule\addlinespace\multicolumn{@span}{l}{\emph{B. IV: replaceable hours}} \\"
	esttab `list_hours_replace' using "$outpath\reg_`file'.tex", `tabopt_iv'
	
	local header "\midrule\addlinespace\multicolumn{@span}{l}{\emph{C. IV: reaching \& handling}} \\"
	esttab `list_arms' using "$outpath\reg_`file'.tex", `tabopt_iv'
	
	local header "\midrule\addlinespace\multicolumn{@span}{l}{\emph{D. IV: replaceable hours, reaching \& handling entered jointly}} \\"
	esttab `list_repl_arms' using "$outpath\reg_`file'.tex", `tabopt_iv2'
	
	local header "\midrule"
	esttab `list_bottom' using "$outpath\reg_`file'.tex", `tabopt_btm'
	
