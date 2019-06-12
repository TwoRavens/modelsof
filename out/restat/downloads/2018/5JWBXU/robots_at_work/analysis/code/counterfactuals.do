* VA per hour in the absence of robots (no value added anymore)
	
	local beta_prod = `1' // coefficient in productivity regressions 
	if "`2'"!="" {
		local beta_va = `2' // coefficient in value added regressions  
	}
	if "`2'"=="" {
		local beta_va = 0 // coefficient in value added regressions  
	}
	
		// value added share of robot-using industries
u "..\temp\robots_country.dta", clear	
	
	so country year
	by country: gen H0 = c_robot_using_smpl_H_EMP[1]
	by country: gen H1 = c_robot_using_smpl_H_EMP[2]
	
	keep if year==2007
	gen robotsshare = c_robot_using_smpl_VA_QI/c_all_VA_QI
	keep country robotsshare H0 H1

merge 1:m country using "$maindataset", nogen
	
	keep if ind_rob!=""
	
		// percentile corresponding to zero robots growth
	sum ch_rob_pctile if ch_rob==0 
	gen ch_rob_pctile_0 = r(mean)
	
		// counterfactual growth
	foreach var in prod va {
	
		gen ch_`var'_robots93 = ch_`var' - `beta_`var''*( ch_rob_pctile-ch_rob_pctile_0 )
		gen `var'_level_1_robots93 = exp( `var'0 + ch_`var'_robots93 )
	}

		// compute levels
	foreach var in prod va h {
		
		gen `var'_level_0 = exp( `var'0 )
		gen `var'_level_1 = exp( `var'0 + ch_`var' )
	}
		
		// aggregate at country level
	so country ind_rob
			
	gen h_share0 = h_level_0/H0
	gen h_share1 = h_level_1/H1

preserve	
	collapse robotsshare (sum) prod_level_0 (rawsum) va_level_0 h_level_0 [ w=h_share0 ], by(country)
	
	tempfile temp
	
sa `temp', replace

restore 	

	collapse (sum) prod_level_1* (rawsum) va_level_1* h_level_1 [ w=h_share1 ], by(country)
		
	merge 1:1 country using `temp', nogen
		
		// loss in levels
	foreach var in prod va {
		
		gen `var'_loss = 100*( 1 - `var'_level_1_robots93/`var'_level_1 )
		gen `var'_loss_all = `var'_loss*robotsshare
	}
	
	if "`2'"!="" {
		local vars "prod_loss va_loss prod_loss_all va_loss_all"
	
		local elements "prod_loss(f(1) label(VA/H))"
		local elements "`elements' va_loss(f(1) label(VA))"
		local elements "`elements' prod_loss_all(f(1) label(VA/H))"
		local elements "`elements' va_loss_all(f(1) label(VA))"
	
		dstats `vars', elements_lev(`elements') elements_ch(nothing) aggregvar(country) wt(1) outfile(counterfactual) nochanges
	}	
	if "`2'"=="" {
		local vars "prod_loss prod_loss_all"
	
		local elements "prod_loss(f(1) label(VA/H))"
		local elements "`elements' prod_loss_all(f(1) label(VA/H))"
	
		dstats `vars', elements_lev(`elements') elements_ch(nothing) aggregvar(country) wt(1) outfile(counterfactual_prod) nochanges
	}
