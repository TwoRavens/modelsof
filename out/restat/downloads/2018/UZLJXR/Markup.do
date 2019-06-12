** Berkowitz, Ma and Nishioka (Updated 12-25-2015) Table 4


///*** Markup ***///

  cd C:\Users\shuichiro\Documents\Research\_Berkowitz&Ma&Nishioka\_RIRB\_Data
  use _LS_dta.dta, clear
  
  /* Use the GMM parameters */
  clear
  import excel "_GMM.xlsx", sheet("sectors") firstrow
  save _GMM.dta, replace
  
  use _LS_dta.dta, clear
  merge m:m cic_3 using "_GMM.dta"
  drop _merge
  erase _GMM.dta
  
  gen markup = (1-bs_1)/(input/gross_output)
  gen ln_markup = ln(markup)
	

  //** Table 5 **//
  
	/* All sample */
	preserve
	char owner_n[omit] 2
	xi: regress ln_markup i.owner_n i.cic_3 i.province i.year, cluster(cic_3)
	outreg2 using _results_m.xls, ctitle(Owner1 98-07) excel dec(3) keep(_Iowner_n_0 _Iowner_n_1 _Iowner_n_3) replace
	restore
	
	preserve
	keep if year < 2003
	char owner_n[omit] 2
	xi: regress ln_markup i.owner_n i.cic_3 i.province i.year, cluster(cic_3)
	outreg2 using _results_m.xls, ctitle(Owner1 98-02) excel dec(3) keep(_Iowner_n_0 _Iowner_n_1 _Iowner_n_3) append
	restore
	
	preserve
	keep if year > 2002
	char owner_n[omit] 2
	xi: regress ln_markup i.owner_n i.cic_3 i.province i.year, cluster(cic_3)
	outreg2 using _results_m.xls, ctitle(Owner1 03-07) excel dec(3) keep(_Iowner_n_0 _Iowner_n_1 _Iowner_n_3) append
	restore
	
	/* All sample SOE vs CC-SOE */
	preserve
	replace owner_n = 4 if central_enterprise_def2 == 1 & owner_n == 0
	char owner_n[omit] 2
	xi: regress ln_markup i.owner_n i.cic_3 i.province i.year, cluster(cic_3)
	outreg2 using _results_m.xls, ctitle(Owner1 98-07) excel dec(3) keep(_Iowner_n_0 _Iowner_n_1 _Iowner_n_3 _Iowner_n_4) append
	restore
	
	preserve
	keep if year < 2003
	replace owner_n = 4 if central_enterprise_def2 == 1 & owner_n == 0
	char owner_n[omit] 2
	xi: regress ln_markup i.owner_n i.cic_3 i.province i.year, cluster(cic_3)
	outreg2 using _results_m.xls, ctitle(Owner1 98-02) excel dec(3) keep(_Iowner_n_0 _Iowner_n_1 _Iowner_n_3 _Iowner_n_4) append
	restore
	
	preserve
	keep if year > 2002
	replace owner_n = 4 if central_enterprise_def2 == 1 & owner_n == 0
	char owner_n[omit] 2
	xi: regress ln_markup i.owner_n i.cic_3 i.province i.year, cluster(cic_3)
	outreg2 using _results_m.xls, ctitle(Owner1 03-07) excel dec(3) keep(_Iowner_n_0 _Iowner_n_1 _Iowner_n_3 _Iowner_n_4) append
	restore
	
	/* Balanced sample SOE vs CC-SOE */
	preserve
	keep if bp_dum == 1
	replace owner_n = 4 if central_enterprise_def2 == 1 & owner_n == 0
	char owner_n[omit] 2
	xi: regress ln_markup i.owner_n i.cic_3 i.province i.year, cluster(cic_3)
	outreg2 using _results_m.xls, ctitle(Owner2 98-07) excel dec(3) keep(_Iowner_n_0 _Iowner_n_1 _Iowner_n_3 _Iowner_n_4) append
	restore
	
	preserve
	keep if year < 2003 & bp_dum == 1
	replace owner_n = 4 if central_enterprise_def2 == 1 & owner_n == 0
	char owner_n[omit] 2
	xi: regress ln_markup i.owner_n i.cic_3 i.province i.year, cluster(cic_3)
	outreg2 using _results_m.xls, ctitle(Owner2 98-02) excel dec(3) keep(_Iowner_n_0 _Iowner_n_1 _Iowner_n_3 _Iowner_n_4) append
	restore
	
	preserve
	keep if year > 2002 & bp_dum == 1
	replace owner_n = 4 if central_enterprise_def2 == 1 & owner_n == 0
	char owner_n[omit] 2
	xi: regress ln_markup i.owner_n i.cic_3 i.province i.year, cluster(cic_3)
	outreg2 using _results_m.xls, ctitle(Owner2 03-07) excel dec(3) keep(_Iowner_n_0 _Iowner_n_1 _Iowner_n_3 _Iowner_n_4) append
	restore
	

clear
