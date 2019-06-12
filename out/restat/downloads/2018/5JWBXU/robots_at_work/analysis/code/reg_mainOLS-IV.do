* robots - main OLS and IV results
	
		// specifications
	local outcomes1 "prod"
	local outcomes2 "va h"
	local groups1 `""$\Delta\ln(\text{VA/H})$""'
	local groups2 `""$\Delta\ln(\text{VA})$" "$\Delta\ln(\text{H})$""'
	local file1 `"mainOLS-IV"'
	local file2 `"VA-H"'
			
	local robvar "ch_rob_pctile"
	
	#delimit ;
	local xvars1 ""; local xvars2 "i.num_c"; 
	local xvars3 "`xvars2' lw0 kl0"; local xvars4 "`xvars3' ch_kl ch_kitsh";
		
	local iv1 "\`iv'"; local iv2 "\`iv'"; local iv3 "\`iv'"; local iv4 "\`iv'";
	
	local cntr_c_1 ""; local cntr_c_2 "$\checkmark$"; local cntr_c_3 "$\checkmark$";
	local cntr_c_4 "$\checkmark$"; local cntr_basic_1 ""; local cntr_basic_2 ""; local cntr_basic_3 "$\checkmark$";
	local cntr_basic_4 "$\checkmark$"; local cntr_cap_1 "";
	local cntr_cap_2 ""; local cntr_cap_3 ""; local cntr_cap_4 "$\checkmark$";
	
	#delimit cr		
	local regopt "\`xvars\`i'' [w=$weights], partial(\`xvars\`i'') $se"
		
		// table options - flexible 
	local colpattern "1"
	local extracols "1"
	local imax = 4
	forval i = 2/`imax' {
		local colpattern "`colpattern' 0"
	}
	local tblpattern "`colpattern'"
	
	forval k = 1/2 {
	
		tokenize "`outcomes`k''"
		local j = 2
		while "``j''"!="" {
					
			local tblpattern "`tblpattern' `colpattern'"
			local extracol = 1 + (`j'-1)*`imax'
			
			local extracols "`extracols' `extracol'"
			local++j
		}
		
		local mgroups `"mgroups(`groups`k'', pattern(`tblpattern') span prefix(\multicolumn{@span}{c}{) suffix(}))"'
		
		local tabopt `"fragment booktabs nolines nomtitles nonotes nostar noobs se b(2) extracols(`extracols') substitute(ch_rob_pctile "Robot adoption")"'
		
		local tabopt_ols `"`tabopt' replace keep(`robvar') `mgroups'  posthead(\`header')"'
		local tabopt_iv `"`tabopt' append nonum keep(`robvar') stats(rkf, l(F-statistic) fmt(1))  posthead(\`header')"'  
		local tabopt_iv2 `"`tabopt' append nonum keep(`robvar') stats(rkf jp, l("F-statistic" "J-statistic (\emph{p}-value)") fmt(1 2))  posthead(\`header')"'  
		local tabopt_btm `"`tabopt' append nonum keep("") stats(cntr_c cntr_basic cntr_cap N, l("Country trends" "Controls" "Changes in other capital" "Observations") fmt(0 0 0 0)) posthead(\`header')"'
		
			// regressions
		eststo clear
	
u if ind_rob!="" using "$maindataset", clear
	
		cap desc arms arms_trans // new IV
		if _rc!=0 {
			gen arms = robots_dot91_phs
			gen arms_trans = robots_dot91_phs*( country=="GER" | country=="US" | country=="SWE" )
		}
	
		foreach y in `outcomes`k'' {
			forval i = 1/`imax' {
				
				ivreg2 ch_`y' `robvar' `regopt' 
				eststo ols_`y'_`i'
				
				local iv hours_replace
				ivreg2 ch_`y' ( `robvar' = `iv`i'' ) `regopt' 
				eststo hours_replace_`y'_`i'
				
				local iv arms
				ivreg2 ch_`y' ( `robvar' = `iv`i'' ) `regopt' 
				eststo arms_`y'_`i'
				
				local iv hours_replace arms
				ivreg2 ch_`y' ( `robvar' = `iv`i'' ) `regopt' 
				eststo repl_arms_`y'_`i'
				
				qui reg ch_prod `xvars`i''		
				estadd local cntr_c "`cntr_c_`i''"
				estadd local cntr_basic "`cntr_basic_`i''"
				estadd local cntr_cap "`cntr_cap_`i''"
				eststo bottom_`y'_`i'
			}
		}
		
		#delimit ; 
		local list_ols ""; local list_hours_replace ""; local list_arms ""; local list_bottom "";
		#delimit cr
		foreach case in ols hours_replace arms repl_arms bottom {
			local list_`case' ""
			foreach y in `outcomes`k'' {
				forval i = 1/`imax' {
				
					local list_`case' "`list_`case'' `case'_`y'_`i'"
				}
			}
		}	
		
		local header "\midrule\addlinespace\multicolumn{@span}{l}{\emph{A. OLS}} \\"
		esttab `list_ols' using "$outpath\reg_`file`k''.tex", `tabopt_ols'
		
		local header "\midrule\addlinespace\multicolumn{@span}{l}{\emph{B. IV: replaceable hours}} \\"
		esttab `list_hours_replace' using "$outpath\reg_`file`k''.tex", `tabopt_iv'
		
		local header "\midrule\addlinespace\multicolumn{@span}{l}{\emph{C. IV: reaching \& handling}} \\"
		esttab `list_arms' using "$outpath\reg_`file`k''.tex", `tabopt_iv'
		
		local header "\midrule\addlinespace\multicolumn{@span}{l}{\emph{D. IV: replaceable hours, reaching \& handling entered jointly}} \\"
		esttab `list_repl_arms' using "$outpath\reg_`file`k''.tex", `tabopt_iv2'
				
		local header "\midrule"
		esttab `list_bottom' using "$outpath\reg_`file`k''.tex", `tabopt_btm'
	}
