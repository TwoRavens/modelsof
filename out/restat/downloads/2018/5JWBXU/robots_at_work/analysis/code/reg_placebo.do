* robots: analysis of "basic" outcomes, i.e. VA, hours worked, productivity 
* falsification tests for IV (automation propensity)
	
	local smpls "93t07_all 93t07_norob93 93t07_norob07 79t93_all 79t93_norob93"
	local ivs "hours_replace robots_dot91_phs" 
* 1) stack data for seemingly unrelated regressions
	local vars "ch_prod ch_va ch_h pre_ch* num_c country code_euklems `ivs'"
	local vars "`vars' ch_rob_pctile ch_rob rob0 share0_rob"
	
	local baselinesmpl "share0_rob!=. using "$maindataset", clear"
	
		// baseline sample
u `vars' if `baselinesmpl' 
	gen smpl = "93t07_all"
sa "..\temp\placebo", replace
		// non-adopters in 1993
u `vars' if rob0==0 & `baselinesmpl' 
	gen smpl = "93t07_norob93"
append using "..\temp\placebo"
sa "..\temp\placebo", replace
		// non-adopters in 2007
u `vars' if rob0==0 & ch_rob==0 & `baselinesmpl' 
	gen smpl = "93t07_norob07"
append using "..\temp\placebo"
sa "..\temp\placebo", replace
		// pre period, all
u `vars' if pre_ch_prod!=. & `baselinesmpl' 
	gen smpl = "79t93_all"
append using "..\temp\placebo"
sa "..\temp\placebo", replace
		// pre period, non-adopters in 1993 
u `vars' if pre_ch_prod!=. & rob0==0 & `baselinesmpl' 
	gen smpl = "79t93_norob93"
append using "..\temp\placebo"
sa "..\temp\placebo", replace

	tab smpl 
	
	foreach outcome in prod va h {
	
		gen sur_`outcome' = ch_`outcome' if substr(smpl,1,2)=="93"
			replace sur_`outcome' = pre_ch_`outcome' if substr(smpl,1,2)=="79"
	}
	
	encode smpl, gen(num_smpl)
		
	foreach iv in `ivs' {
		foreach smpl in `smpls' {
			gen `iv'_`smpl' = `iv'*( smpl=="`smpl'" )
		}
		drop `iv'_93t07_all
	}
	
sa "..\temp\placebo", replace 
	
	* 2) regressions 
u "..\temp\placebo", clear
		
	local regopt "\`xvars' \`if' [w=share0_rob], cluster(country code_euklems) partial(\`xvars')" 
	
		// stacked, to obtain p-values for coefficient comparisons 
	local xvars "num_c##num_smpl"
	local smpls_p "93t07_norob93 93t07_norob07 79t93_all 79t93_norob93"
	
	local hours_replace "repl"
	local robots_dot91_phs "arms"
	
	foreach iv in `ivs' {
		foreach outcome in prod /*va h*/ {
			ivreg2 sur_`outcome' `iv' `iv'_* `regopt' 
			
			foreach smpl in `smpls_p' {
								
				local p_``iv''_`outcome'_`smpl': di %9.2f  2*normal(-abs(_b[`iv'_`smpl']/_se[`iv'_`smpl']))
				di "``p_``iv''_`outcome'_`smpl''"
			}
		}
	}
	
		// individual regressions 
	local xvars "i.num_c"
	eststo clear 
	
	gen iv = . 
	
	foreach iv in `ivs' {
		
		replace iv = `iv'
		
		foreach outcome in prod /*va h*/ {
			foreach smpl in `smpls' {
				
				local if `"if smpl=="`smpl'""'
				ivreg2 sur_`outcome' iv `regopt' 
				eststo ``iv''_`outcome'_`smpl'
			}
			// dummy regression for bottom of table
			reg hours_replace
			foreach smpl in `smpls_p' {
				estadd local p_`smpl' "`p_``iv''_`outcome'_`smpl''"
			}
			eststo ``iv''_`outcome'_bottom
		}
	}
	foreach smpl in `smpls' bottom {
		
		local regli_`smpl' ""
		foreach iv in `ivs' {
			foreach outcome in prod /*va h*/ {
				local regli_`smpl' "`regli_`smpl'' ``iv''_`outcome'_`smpl'"
			}
		}
	}	
	local pvals ""
	foreach smpl in `smpls_p' {
		local pvals "`pvals' p_`smpl'"
	}	
	
	* 3) table
	
		// options common to all groups
	local tabopt "fragment nostar label nonotes nolines booktabs se nogaps b(2)"
	local tabopt "`tabopt' extracols(1 2)" // number of IVs, outcomes? 
		
		// options for top group of results
	local mgroup1 "Replaceable hours"
	local mgroup2 "Reaching \& handling"
	local subst `"iv "Instrumental variable" sur_prod "$\Delta\ln(\text{VA/H})$" sur_va "$\Delta\ln(\text{VA})$" sur_h "$\Delta\ln(\text{H})$""'
	
	local tabopt_t "`tabopt' replace subst(`subst') mgroups("`mgroup1'" "`mgroup2'""
	local tabopt_t "`tabopt_t', pattern(1 1) span prefix(\multicolumn{@span}{c}{) suffix(}))"
	
		// options for middle groups
	local tabopt_m `"`tabopt' append nonum nomtitles keep(iv) subst(iv "Instrumental variable") \`posthead'"'
		
	local posthead_93t07_norob93 `"posthead("\midrule\addlinespace\multicolumn{@span}{l}{ \emph{B. Growth in outcome 1993-2007, non-adopters (1993)}} \\")"' 
	local posthead_93t07_norob07 `"posthead("\midrule\addlinespace\multicolumn{@span}{l}{ \emph{C. Growth in outcome 1993-2007, non-adopters (2007)}} \\")"' 
	local posthead_79t93_all `"posthead("\midrule\addlinespace\multicolumn{@span}{l}{ \emph{D. Growth in outcome 1979-1993}} \\")"' 
	local posthead_79t93_norob93 `"posthead("\midrule\addlinespace\multicolumn{@span}{l}{ \emph{E. Growth in outcome 1979-1993, non-adopters (1993)}} \\")"' 
		
		// option for (empty) bottom group
	local tabopt_b "`tabopt' append nonum nomtitles noobs keep("")"
		local labl1 "\emph{p}-value of test for equality, \emph{A} versus \emph{B}"
		local labl2 "\emph{p}-value of test for equality, \emph{A} versus \emph{C}"
		local labl3 "\emph{p}-value of test for equality, \emph{A} versus \emph{D}"
		local labl4 "\emph{p}-value of test for equality, \emph{A} versus \emph{E}"
		local stats "stats(`pvals', fmt(3) l("`labl1'" "`labl2'" "`labl3'" "`labl4'")) "
	local tabopt_b `"`tabopt_b' `stats' posthead("\midrule\addlinespace")"'
				
		// create table
	local posthead `"posthead("\midrule\addlinespace\multicolumn{@span}{l}{ \emph{A. Growth in outcome 1993-2007 (benchmark)}} \\")"'
	esttab `regli_93t07_all' using "$outpath\reg_placebo.tex", `tabopt_t' `posthead' 
	
	foreach smpl in `smpls_p' {
		local posthead `"`posthead_`smpl''"' 
		esttab `regli_`smpl'' using "$outpath\reg_placebo.tex", `tabopt_m'  
	}
	esttab `regli_bottom' using "$outpath\reg_placebo.tex", `tabopt_b'

