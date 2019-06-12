* robots - productivity - functional form 
		
	local outcomes "prod"
	local groups `""$\Delta\ln(\text{VA/H})$""'
			
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
	
	tokenize "`outcomes'"
	local j = 2
	while "``j''"!="" {
					
		local tblpattern "`tblpattern' `colpattern'"
		local extracol = 1 + (`j'-1)*`imax'
			
		local extracols "`extracols' `extracol'"
		local++j
	}
		
	local mgroups `"mgroups(`groups', pattern(`tblpattern') span prefix(\multicolumn{@span}{c}{) suffix(}))"'
	
	local tabopt `"fragment booktabs nolines nomtitles nonotes nostar noobs se b(3) extracols(`extracols')"'
		
	/*local tabopt_npm `"`tabopt' replace keep(ch_rob_qrt_2 ch_rob_qrt_3 ch_rob_qrt_4) subst(ch_rob_qrt "Quartile" _2 " 2" _3 " 3" _4 " 4")"'	
	local tabopt_npm `"`tabopt_npm' `mgroups'  posthead(\`header')"'	
	local tabopt_ols `"`tabopt' append nonum keep(robvar) posthead(\`header') subst(robvar "OLS")"'*/
	
	local tabopt_olstop `"`tabopt' replace `mgroups' keep(robvar) posthead(\`header') subst(robvar "OLS")"'
	local tabopt_ols `"`tabopt' append nonum keep(robvar) posthead(\`header') subst(robvar "OLS")"'
	local tabopt_iv `"`tabopt' append nonum keep(robvar) stats(rkf, l(F-statistic) fmt(1))  posthead(\`header') subst(robvar "IV: replaceable hours")"'  
	local tabopt_btm `"`tabopt' append nonum keep("") stats(cntr_c cntr_basic cntr_cap N, l("Country trends" "Controls" "Changes in other capital" "Observations") fmt(0 0 0 0)) posthead(\`header')"'
		
		// regressions
	eststo clear
	local iv "hours_replace"
		
u if ind_rob!="" using "$maindataset", clear
	
	replace ch_robsrvc = 1000*ch_robsrvc 
	
	cap desc arms arms_trans // new IV
	if _rc!=0 {
		gen arms = robots_dot91_phs
		gen arms_trans = robots_dot91_phs*( country=="GER" | country=="US" | country=="SWE" )
	}
		
	foreach y in `outcomes' {
		forval i = 1/`imax' {
			
			ivreg2 ch_`y' ch_rob_qrt_2 ch_rob_qrt_3 ch_rob_qrt_4 `regopt' 
			eststo ols_npm_`y'_`i'			
			
			foreach var in rob lrob robsrvc {
				
				gen robvar = ch_`var'
				ivreg2 ch_`y' robvar `regopt' 
				eststo ols_`var'_`y'_`i'
			
				ivreg2 ch_`y' ( robvar = `iv`i'' ) `regopt' 
				eststo iv_`var'_`y'_`i'
				
				drop robvar
			}
			qui reg ch_prod `xvars`i''		
			estadd local cntr_c "`cntr_c_`i''"
			estadd local cntr_basic "`cntr_basic_`i''"
			estadd local cntr_cap "`cntr_cap_`i''"
			eststo bottom_`y'_`i'
		}
	}
	
	foreach y in `outcomes' {
		forval i = 1/`imax' {
						
			foreach var in npm rob lrob robsrvc {
			
				local list_ols_`var' "`list_ols_`var'' ols_`var'_`y'_`i'"
				local list_iv_`var' "`list_iv_`var'' iv_`var'_`y'_`i'"
			}
		local list_bottom "`list_bottom' bottom_`y'_`i'"	
		}
	}	
	
	local file "fform"
	
	/*local header "\midrule\addlinespace\multicolumn{@span}{l}{\emph{A. Indicators for quartiles of changes in robot density, OLS}} \\"
	esttab `list_ols_npm' using "$outpath\reg_`file'.tex", `tabopt_npm'*/
	
	local header "\midrule\addlinespace\multicolumn{@span}{l}{\emph{A. Change in robot density,} $\text{\#Robots}/\text{Hours}$} \\"
	esttab `list_ols_rob' using "$outpath\reg_`file'.tex", `tabopt_olstop'
	local header ""
	esttab `list_iv_rob' using "$outpath\reg_`file'.tex", `tabopt_iv'
	
	local header "\midrule\addlinespace\multicolumn{@span}{l}{\emph{B. Change in} $\ln(1+\text{\#Robots}/\text{Hours})$} \\"
	esttab `list_ols_lrob' using "$outpath\reg_`file'.tex", `tabopt_ols' 
	local header ""
	esttab `list_iv_lrob' using "$outpath\reg_`file'.tex", `tabopt_iv'
	
	local header "\midrule\addlinespace\multicolumn{@span}{l}{\emph{C. Change in} $1,000\times(\text{Robot services})/(\text{Wage bill})$} \\"
	esttab `list_ols_robsrvc' using "$outpath\reg_`file'.tex", `tabopt_ols' 
	local header ""
	esttab `list_iv_robsrvc' using "$outpath\reg_`file'.tex", `tabopt_iv'
		
	local header "\midrule"
	esttab `list_bottom' using "$outpath\reg_`file'.tex", `tabopt_btm'
	
		// standard error for quartile 2 
	local regopt "\`xvars\`i'' [w=$weights], partial(\`xvars\`i'') r"
	local xvars "`xvars1'"
	ivreg2 ch_prod ch_rob_qrt_2 ch_rob_qrt_3 ch_rob_qrt_4 `regopt' 

