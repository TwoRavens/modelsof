* robots: country-industry-level graphs of OLS, reduced form, and 1st stage

u "$maindataset", clear

* variable choices and descriptions
	
	global iv "hours_replace"
	
	local robvars "ch_rob ch_rob_pctile ch_lrob"
		
	local descr_ch_rob "Change in #robots/hours"
	local descr_ch_rob_pctile "Percentile of change in #robots/hours"
	local descr_ch_lrob "Change in log(1+#robots/hours)"
	
	local ivdescr "`0'" // description of IV
	
* variable transformation
	replace ch_rob_pctile = 100*ch_rob_pctile
	
* regress out country fixed effects
	foreach var in ch_prod $iv `robvars' {
			
		qui reg `var' i.num_c [ w=$weights ]
		predict `var'_res, resid
	}		

* graph options	
	local scatteropt "[w=$weights], msymbol(oh)"
	local graphopt "[w=$weights], legend(off) sch(s2mono) graphregion(color(white))"
	local graphopt "`graphopt' ls(foreground) lp(solid) lw(medthick)"
	
	local spec "(scatter \`yvar' \`xvar' `scatteropt')(lfit \`yvar' \`xvar' `graphopt' xtitle(\`xdescr', size(medlarge)) ytitle(\`ydescr', size(medlarge)))"
	local outfile "$outpath\micro_\`filename'.pdf"

* graphs 	
	local ch_prod_raw "ch_prod"
	local ch_prod_partial "ch_prod_res"
		
	local iv_raw "$iv"
	local iv_partial "${iv}_res"
	
	
	foreach case in raw partial {
		
		foreach robvar in `robvars' {
			
			if "`case'"=="raw" {
				local userobvar "`robvar'"
			}
			if "`case'"=="partial" {
				local userobvar "`robvar'_res"
			}			
			
			* OLS
			local yvar "`ch_prod_`case''"
			local ydescr "Change in log(VA/hours)"
			local xvar "`userobvar'"
			local xdescr "`descr_`robvar''"
			local filename "`case'_prod_`robvar'"
			
			di "`spec'"
						
			twoway `spec' 
			graph export "`outfile'", replace
			
			* first stage 
			local yvar "`userobvar'"
			local ydescr "`descr_`robvar''"
			local xvar "`iv_`case''"
			local xdescr "`ivdescr'"
			local filename "`case'_`robvar'_replace"
						
			twoway `spec' 
			graph export "`outfile'", replace
		}
		
		* reduced form
		local yvar "`ch_prod_`case''"
		local ydescr "Change in log(VA/hours)"
		local xvar "`iv_`case''"
		local xdescr "`ivdescr'"
		local filename "`case'_prod_replace"
			
		twoway `spec' 
		graph export "`outfile'", replace
	}	
