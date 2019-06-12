** Berkowitz, Ma and Nishioka (Updated 12-25-2015) Figure 1 & Table 2

 
  cd C:\Users\shuichiro\Documents\Research\_Berkowitz&Ma&Nishioka\_RIRB\_Data
  use _LS_dta.dta, clear


  ///*** Summary statistics (all) ***///

    //** By ownerships **//
    preserve
	
	gen count_d = 1
	gen def_d = 0
	replace def_d = 1 if profit < 0
	gen real_wage = 100*wage/OutputDefl
    collapse (sum)count_d (sum)real_output (sum)aemployee (sum)employee (sum)real_cap (sum)real_wage (sum)value_added ///
	(sum)def_d (sum)profit (sum)wage (sum)input (sum)gross_output, by(owner_n year)

	replace real_output = real_output/1000000
	replace employee = employee/1000
	replace real_cap = real_cap/1000000
	gen shareD = def_d/count_d
	gen shareP = profit/value_added
	gen shareL = wage/value_added
	gen shareM = input/gross_output
	replace real_wage = real_wage/employee
	gen kl = 1000000*real_cap/aemployee
	keep owner_n year count_d real_output aemployee employee real_cap shareP shareD shareL shareM real_wage kl
	export excel using _aggregates_irb.xlsx, sheet("ownership (all)", replace) firstrow(variables)
	
	restore
	
	
    //** By year **//
    preserve
	
	gen count_d = 1
	gen def_d = 0
	replace def_d = 1 if profit < 0
	gen real_wage = 100*wage/OutputDefl
    collapse (sum)count_d (sum)real_output (sum)aemployee (sum)employee (sum)real_cap (sum)real_wage (sum)value_added ///
	(sum)def_d (sum)profit (sum)wage (sum)input (sum)gross_output, by(year)

	replace real_output = real_output/1000000
	replace employee = employee/1000
	replace real_cap = real_cap/1000000
	gen shareD = def_d/count_d
	gen shareP = profit/value_added
	gen shareL = wage/value_added
	gen shareM = input/gross_output
	replace real_wage = real_wage/employee
	gen kl = 1000000*real_cap/aemployee
	keep year count_d real_output aemployee employee real_cap shareP shareD shareL shareM real_wage kl
	export excel using _aggregates_irb.xlsx, sheet("year (all)", replace) firstrow(variables)
	
	restore
	
	
  ///*** Summary statistics (balanced panel) ***///

    //** By ownerships **//
    preserve
	
	keep if bp_dum == 1
	gen count_d = 1
	gen def_d = 0
	replace def_d = 1 if profit < 0
	gen real_wage = 100*wage/OutputDefl
    collapse (sum)count_d (sum)real_output (sum)aemployee (sum)employee (sum)real_cap (sum)real_wage (sum)value_added ///
	(sum)def_d (sum)profit (sum)wage (sum)input (sum)gross_output, by(owner_n year)

	replace real_output = real_output/1000000
	replace employee = employee/1000
	replace real_cap = real_cap/1000000
	gen shareD = def_d/count_d
	gen shareP = profit/value_added
	gen shareL = wage/value_added
	gen shareM = input/gross_output
	replace real_wage = real_wage/employee
	gen kl = 1000000*real_cap/aemployee
	keep owner_n year count_d real_output aemployee employee real_cap shareP shareD shareL shareM real_wage kl
	export excel using _aggregates_irb.xlsx, sheet("ownership (bp)", replace) firstrow(variables)
	
	restore
	
	
    //** By year **//
    preserve
	
	keep if bp_dum == 1
	gen count_d = 1
	gen def_d = 0
	replace def_d = 1 if profit < 0
	gen real_wage = 100*wage/OutputDefl
    collapse (sum)count_d (sum)real_output (sum)aemployee (sum)employee (sum)real_cap (sum)real_wage (sum)value_added ///
	(sum)def_d (sum)profit (sum)wage (sum)input (sum)gross_output, by(year)

	replace real_output = real_output/1000000
	replace employee = employee/1000
	replace real_cap = real_cap/1000000
	gen shareD = def_d/count_d
	gen shareP = profit/value_added
	gen shareL = wage/value_added
	gen shareM = input/gross_output
	replace real_wage = real_wage/employee
	gen kl = 1000000*real_cap/aemployee
	keep year count_d real_output aemployee employee real_cap shareP shareD shareL shareM real_wage kl
	export excel using _aggregates_irb.xlsx, sheet("year (bp)", replace) firstrow(variables)
	
	restore
	
	
	//** Figures 1&2 **//
    preserve
	
	gen profit_o = profit*(1-soe_dum)
	gen profit_all = profit*soe_dum
	gen profit_bp = profit*soe_dum*bp_dum
	gen value_added_o = value_added*(1-soe_dum)
	gen value_added_all = value_added*soe_dum
	gen value_added_bp = value_added*soe_dum*bp_dum

    collapse (sum)profit_o (sum)profit_all (sum)profit_bp (sum)value_added_o (sum)value_added_all (sum)value_added_bp, by(year)
	
	gen shareP_o = profit_o/value_added_o
	gen shareP_all = profit_all/value_added_all
	gen shareP_bp = profit_bp/value_added_bp

	/* Figure 1: Trends in profit/value added by ownerships (all firms) */
	twoway (tsline shareP_o, lcolor(green) lwidth(medthick)) (tsline shareP_all, lcolor(blue) lwidth(medthick)) (tsline shareP_bp, lcolor(blue) lpattern(dash_dot) lwidth(medthick)), ///
	legend(order(1 "non-SOEs" 2 "SOEs (all)" 3 "SOEs (balanced)") rows(1)) title("Fig 1. Profit shares (aggregate)") ytitle(profit shares) xtitle("")
	graph export _intro_ps.emf, replace
	
	restore
	

  clear
