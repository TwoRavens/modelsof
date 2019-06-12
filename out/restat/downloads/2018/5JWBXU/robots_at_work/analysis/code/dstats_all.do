** robots: descriptive statistics

	* common options 
	local opt "elements_lev(\`elements_lev') elements_ch(\`elements_ch')"
	
	* robots and basic outcomes
u "$maindataset", clear
		
	local vars "rob prod va h"
	
	local lab_rob "$\text{\#robots/H}$"
	local lab_prod "$\ln(\text{VA/H})$"
	local lab_va "$\ln(\text{VA})$" 
	local lab_h "$\ln(\text{H})$" 
	
	local elements_lev ""
	local elements_ch ""
	
	foreach var in `vars' {
		
		local elements_lev "`elements_lev' `var'0(f(2) label(`lab_`var''))"
		local elements_ch "`elements_ch' ch_`var'(f(2) label(`lab_`var''))"
	}
		
	dstats `vars',  `opt' aggregvar(country) wt($weights) outfile(basic_country)
	dstats `vars',  `opt' aggregvar(industry) wt(1) outfile(basic_industry)
	
	* additional variables
	gen tfp0 = . 
	
	local vars "wh lw lshare kl kitsh tfp"
	
	local lab_wh "$\ln(\text{wH})$"
	local lab_lw "$\ln(\text{w})$"
	local lab_lshare "$\text{wH/VA}$"
	local lab_kl "$\text{rK/wH}$"
	local lab_kitsh "$\text{ICT/K}$"
	local lab_tfp "$\ln(\text{TFP})$"
	
	local elements_lev ""
	local elements_ch ""
	
	foreach var in `vars' {
		
		local elements_lev "`elements_lev' `var'0(f(2) label(`lab_`var''))"
		local elements_ch "`elements_ch' ch_`var'(f(2) label(`lab_`var''))"
	}
		
	dstats `vars', `opt' aggregvar(country) wt($weights) outfile(additional_country)
	dstats `vars', `opt' aggregvar(industry) wt(1) outfile(additional_industry)
	
	* country-level dstats
	foreach case in all robot_using {
u "..\temp\robots_country", clear	
		
		local prefix "c_`case'_"
		
		so country year
		
		local rob_formula "`prefix'stock_pim_10/`prefix'H_EMP"
			local rob_label "\text{\#robots/H}"
		local va_formula "log(`prefix'VA_QI)"
			local va_label "\ln(\text{VA})"
		local h_formula "log(`prefix'H_EMP)"
			local h_label "\ln(\text{H})"
		local prod_formula "log(`prefix'VA_QI/`prefix'H_EMP)"
			local prod_label "\ln(\text{VA/H})"
		local k_formula "log(`prefix'CAP_QI)"
			local k_label "\ln(\text{K})"
		local kitsh_formula "`prefix'CAPITSHR"
			local kitsh_label "\text{ICT/K}"
		local wh_formula "log(`prefix'LAB_QI)"
			local wh_label "\ln(\text{wH})"
		local lshare_formula "`prefix'LAB/`prefix'VA"
			local lshare_label "\text{wH/VA}"
		local lw_formula "log(`prefix'LAB_QI/`prefix'H_EMP)"
			local lw_label "\ln(\text{w})"
		local robsrvcshare_formula "100*0.15*price_robots_real*`prefix'stock_pim_10/`prefix'CAP_QI"
			local robsrvcshare_label "100\times\text{robsrvcs/K}"
		local robshare_formula "100*price_robots*`prefix'stock_pim_10/`prefix'CAP"
			local robshare_label "100\times\rho\text{R/rK}"	
		
		if "`case'"=="all" {
			
			gen c_all_stock_pim_10 = c_robot_using_stock_pim_10
			local vars "rob robsrvcshare robshare va h prod k kitsh wh lshare lw"
		}
		
		if "`case'"=="robot_using" {
		
			local vars "rob robsrvcshare robshare va h prod k wh lshare lw"
		}
		
		foreach var in `vars' {
		
			gen `var' = ``var'_formula'
			by country: gen `var'0 = `var'[1]
			by country: gen ch_`var' = `var'[2]-`var'[1]
		}
	
		keep if year==2007
		
		local elements_lev ""
		local elements_ch ""
	
		foreach var in `vars' {
		
			local elements_lev = "`elements_lev' `var'0(f(2) label(\begin{math}``var'_label'\end{math}))"
			local elements_ch "`elements_ch' ch_`var'(f(2) label(\begin{math}``var'_label'\end{math}))"
		}
		
		dstats `vars', `opt' aggregvar(country) wt(1) outfile(country_`case')
	}
