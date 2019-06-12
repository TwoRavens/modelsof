* robots: prep country-industry-level data
* create all variables used in analysis 

u "..\temp\robots_country-industry_merged", clear
		
	so country code_rob year	
		
	* create variables: levels, initial values, and changes
		
		// basic
	local rawvarlist "VA_QI H_EMP PROD P LAB_QI W LABSHARE CAPLAB CAPITSHR TFPva_I"
		local namelist "va h prod p wh lw lshare kl kitsh tfp"
	
	local varlist_logdiff "VA_QI H_EMP PROD P LAB_QI W TFPva_I" 
	local varlist_diff "LABSHARE CAPLAB CAPITSHR"
		
			gen PROD = VA_QI/H_EMP
			gen P = VA/VA_QI
			
			gen W = LAB_QI/H_EMP
			gen LABSHARE = LAB/VA
	
		// skill breakdowns
	local rawvarlist "`rawvarlist' H_HS H_MS H_LS LAB_HS LAB_MS LAB_LS"
		local namelist "`namelist' h_HS h_MS h_LS wh_HS wh_MS wh_LS"
	local rawvarlist "`rawvarlist' H_SH_HS H_SH_MS H_SH_LS LAB_SH_HS LAB_SH_MS LAB_SH_LS"
		local namelist "`namelist' h_sh_HS h_sh_MS h_sh_LS wh_sh_HS wh_sh_MS wh_sh_LS"
	
	local varlist_logdiff "`varlist_logdiff' H_HS H_MS H_LS LAB_HS LAB_MS LAB_LS" 
	local varlist_diff "`varlist_diff' H_SH_HS H_SH_MS H_SH_LS LAB_SH_HS LAB_SH_MS LAB_SH_LS" 
	
			foreach skill in HS MS LS {
							
				gen H_`skill' = H_SH_`skill'*H_EMP/100 
				gen LAB_`skill' = LAB_SH_`skill'*LAB_QI/100 
			}
		
		// robots
	local rawvarlist "`rawvarlist' stock_pim_10 price_robots_real ROB ROB_INITL LROB ROBSRVC ROB5 ROB15"
		local namelist "`namelist' robstock robp rob rob_initl lrob robsrvc rob5 rob15"
	
	local varlist_diff "`varlist_diff' stock_pim_10 price_robots_real ROB ROB_INITL LROB ROBSRVC ROB5 ROB15"
	
		gen ROB = stock_pim_10/H_EMP
		by country code_rob: gen ROB_INITL = stock_pim_10/H_EMP[1]
		gen LROB = log(1+stock_pim_10/H_EMP)
		gen ROBSRVC = 0.15*price_robots_real*stock_pim_10/LAB_QI
		gen ROB5 = stock_pim_5/H_EMP
		gen ROB15 = stock_pim_15/H_EMP
	
	di "`rawvarlist'"
	di "`namelist'"
		
	local n : word count `rawvarlist'
	
	forvalues i = 1/`n' {
		
		local a : word `i' of `rawvarlist'
		local b : word `i' of `namelist'
		
		local name_`a' "`b'"
	}
	
	encode code_euklems, gen(num_ind)
	encode country, gen(num_c)
	egen id = group(country code_euklems)
	
	so id year 
	
	foreach var in `varlist_logdiff' {
	
		by id: gen ch_`name_`var'' = log(`var'[_n]/`var'[_n-1])
		by id: gen `name_`var''0 = log(`var'[1])
	}	
	foreach var in `varlist_diff' {
	
		by id: gen ch_`name_`var'' = `var'[_n] - `var'[_n-1]
		by id: gen `name_`var''0 = `var'[1]			
	}
		
	by id: gen c_rob0 = c_robot_using_rob[1]
	by id: gen c_rob0_pctile = c_robot_using_rob_pctile[1]
	
	by id: gen c_w0 = log(c_all_LAB_QI[1]/c_all_H_EMP[1])
	
	* construct further variables
		
		// weights
	bys country year: egen helper = total(H_EMP) 
	so id year 
	by id: gen share0 = H_EMP[1]/helper[1]
		drop helper 
	
	by id: gen share0_rob = H_EMP[1]/c_robot_using_smpl_H_EMP[1] if code_rob!=""
		
		// percentiles of robot adoption 
			// 1a) robot-using industries 
	gen rob1 = rob0 + ch_rob
	
	foreach var in rob0 rob1 ch_rob {
		
		xtile `var'_pctile = `var' [ w=share0_rob ], nq(100)
			replace `var'_pctile = `var'_pctile/100
	}
	
	gen rob_ch_pctile = rob1_pctile - rob0_pctile 
			
	foreach drate in 5 15 {
		xtile ch_rob`drate'_pctile = ch_rob`drate' [ w=share0 ], nq(100)
			replace ch_rob`drate'_pctile = ch_rob`drate'_pctile/100	
	}
		
	xtile ch_rob_qrt = ch_rob [ w=share0_rob ], n(4)
		qui tab ch_rob_qrt, gen(ch_rob_qrt_)
		
	drop ch_rob_qrt				
			// 2a) all industries 
	foreach var in rob0 ch_rob {
		gen gen_`var' = `var'
			replace gen_`var' = 0 if gen_`var'==.
						
		xtile gen_`var'_pctile = gen_`var' [ w=share0 ], nq(100)
			replace gen_`var'_pctile = gen_`var'_pctile/100
	}	
	
	local varlist "country num_c code_robots ind_robots num_ind code_euklems desc id"
	local varlist "`varlist' hours_replace robots_dot91_phs task_* year share0* c_rob* c_w0"
	
	foreach name in `namelist' {
	
		local varlist "`varlist' ch_`name' `name'0"
	}
	
	local varlist "`varlist' ch_rob_pctile ch_rob5_pctile ch_rob15_pctile rob0_pctile ch_rob_qrt_1 ch_rob_qrt_2 ch_rob_qrt_3 ch_rob_qrt_4 gen_* pre_*"
		
	keep `varlist' 
	order `varlist'
		drop tfp0 rob_initl0 rob50 rob150
	
	keep if year==2007
		
	* label variables 
	la var share0 "1993 within-country hours share"
	la var share0_rob "1993 within-country hours share - robot-using industries"
	la var ch_va "change in log of value added"
	la var va0 "log of value added in 1993"
	la var ch_h "change in log of hours worked"
	la var h0 "log of hours worked in 1993"
	la var ch_prod "change in log labor productivity" 
	la var prod0 "log of initial labor productivity" 
	la var ch_p "change in log of output price level"
	la var p0 "log of output price level in 1993"
	la var ch_wh "change in log of wage bill"
	la var wh0 "log of wage bill in 1993"
	la var ch_lw "change in log of average wage"
	la var lw0 "log of average wage in 1993"
	la var ch_lshare "change in labor share"
	la var lshare0 "labor share in 1993"
	la var ch_kl "change in capital services to wage bill ratio"
	la var kl0 "capital services to wage bill ratio in 1993"
	la var ch_kitsh "change in share of ICT capital in all capital"
	la var kitsh0 "share of ICT capital in all capital in 1993"
	la var ch_tfp "change in log of TFP"
	
	foreach skill in HS MS LS {
		
		la var ch_h_`skill' "change in log of hours worked by `skill'"
		la var h_`skill'0 "log of hours worked by `skill' in 1993"
		la var ch_h_sh_`skill' "change in share of hours worked by `skill'"
		la var h_sh_`skill'0 "share of hours worked by `skill' in 1993"
		
		la var ch_wh_`skill' "change in log of wage bill of `skill'"
		la var wh_`skill'0 "log of wage bill of `skill' in 1993"
		la var ch_wh_sh_`skill' "change in share of wage bill of `skill'"
		la var wh_sh_`skill'0 "share of wage bill of `skill' in 1993"
	}
		
	la var ch_robstock "change in number of robots"
	la var robstock0 "number of robots in 1993"
	la var ch_robp "change in robot price"
	la var robp0 "robot price in 1993"	
	la var ch_rob "change in number of robots per million hours worked"
	la var rob0 "number of robots per million hours worked in 1993"
	la var ch_rob_initl "change in number of robots, divided by hours worked in 1993"
	la var ch_lrob "change in the log of one plus the number of robots per million hours"
	la var lrob0 "log of one plus the number of robots per million hours in 1993"
	la var ch_robsrvc "change in robot services" 
	la var robsrvc0 "robot services in 1993"
	la var ch_rob5 "change in number of robots per million hours worked, 5 percent depreciation"
	la var ch_rob15 "change in number of robots per million hours worked, 15 percent depreciation"
		
	la data ""
	
	foreach var in hours inc {
		cap gen `var'_replace_transport = `var'_replace*( country=="GER" | country=="SWE" | country=="US" ) 
	}
	
	gen full = 1
		la var full "full sample"
		
	gen nimpute = country!="AUS" & country!="AUT" & country!="BEL" 	///
				& country!="DNK" & country!="GRC" & country!="HUN" 	///
				& country!="IRL" & country!="KOR" & country!="NLD" 	///
				& country!="US"
		la var nimpute "baseline stocks not imputed"
	
	gen trade = ( ind_r!="Construction" 							///
					& ind_r!="Education/research/development" 		///
					& ind_r!="Electricity, gas, water supply"  )
		la var trade "tradable industries"
		
	compress 
	
sa "..\temp\robots_country-industry_final", replace
