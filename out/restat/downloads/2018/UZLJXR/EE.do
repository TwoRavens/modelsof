 ** Berkowitz, Ma and Nishioka (Updated 12-25-2015) Table 1
 
 
  ///*** Data file developed for Exit and Entry ***///
  
  cd C:\Users\shuichiro\Documents\Research\_Berkowitz&Ma&Nishioka\_RIRB\_Data
  use _LS_dta.dta, clear
  
  preserve
  collapse (count)ln_real_output, by(year)
  drop ln_real_output
  save year_dta.dta, replace
  restore
  
  collapse (count)ln_real_output, by(firm_id)
  drop ln_real_output
  cross using year_dta.dta

  merge m:m firm_id year using _LS_dta.dta
  drop _merge
  erase year_dta.dta

  tsset firm_id year
  
  
  //** Table 1 (all) **//
  
    preserve
	
	keep firm_id owner_1 owner_2
	collapse (mean)owner_1 (mean)owner_2, by(firm_id)
    export excel firm_id owner_1 owner_2 using _aggregates_irb.xlsx, sheet("count (all)", replace) firstrow(variables)
	
	restore
	
	
  //** Table 1 (bp) **//
  
    preserve
	
	keep if bp_dum == 1
	keep firm_id owner_1 owner_2
	collapse (mean)owner_1 (mean)owner_2, by(firm_id)
    export excel firm_id owner_1 owner_2 using _aggregates_irb.xlsx, sheet("count (bp)", replace) firstrow(variables)
	
	restore


clear
