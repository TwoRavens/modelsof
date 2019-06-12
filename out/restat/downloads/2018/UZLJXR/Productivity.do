** Berkowitz, Ma and Nishioka (Updated 12-25-2015) Figure 5 & Tables 6-7


///*** Productivity ***///

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

  gen bss_2 = (bs_2-1)/bs_2
  gen ln_TFP = ln_real_output-(bs_1/bss_2)*ln(bs_3*aemployee^(bss_2)+(1-bs_3)*real_cap^(bss_2))-(1-bs_1)*ln_real_input


  //** TFP by ownershp (Table 7.1) **//
  
	/* All sample */
	preserve
	char owner_n[omit] 2
	xi: regress ln_TFP i.owner_n i.cic_3 i.province i.year, cluster(cic_3)
	outreg2 using _results_w.xls, ctitle(Owner1 98-07) excel dec(3) keep(_Iowner_n_0 _Iowner_n_1 _Iowner_n_3) replace
	restore
	
	preserve
	keep if year < 2003
	char owner_n[omit] 2
	xi: regress ln_TFP i.owner_n i.cic_3 i.province i.year, cluster(cic_3)
	outreg2 using _results_w.xls, ctitle(Owner1 98-02) excel dec(3) keep(_Iowner_n_0 _Iowner_n_1 _Iowner_n_3) append
	restore
	
	preserve
	keep if year > 2002
	char owner_n[omit] 2
	xi: regress ln_TFP i.owner_n i.cic_3 i.province i.year, cluster(cic_3)
	outreg2 using _results_w.xls, ctitle(Owner1 03-07) excel dec(3) keep(_Iowner_n_0 _Iowner_n_1 _Iowner_n_3) append
	restore
	
	/* All sample SOE vs CC-SOE */
	preserve
	replace owner_n = 4 if central_enterprise_def2 == 1 & owner_n == 0
	char owner_n[omit] 2
	xi: regress ln_TFP i.owner_n i.cic_3 i.province i.year, cluster(cic_3)
	outreg2 using _results_w.xls, ctitle(Owner1 98-07) excel dec(3) keep(_Iowner_n_0 _Iowner_n_1 _Iowner_n_3 _Iowner_n_4) append
	restore
	
	preserve
	keep if year < 2003
	replace owner_n = 4 if central_enterprise_def2 == 1 & owner_n == 0
	char owner_n[omit] 2
	xi: regress ln_TFP i.owner_n i.cic_3 i.province i.year, cluster(cic_3)
	outreg2 using _results_w.xls, ctitle(Owner1 98-02) excel dec(3) keep(_Iowner_n_0 _Iowner_n_1 _Iowner_n_3 _Iowner_n_4) append
	restore
	
	preserve
	keep if year > 2002
	replace owner_n = 4 if central_enterprise_def2 == 1 & owner_n == 0
	char owner_n[omit] 2
	xi: regress ln_TFP i.owner_n i.cic_3 i.province i.year, cluster(cic_3)
	outreg2 using _results_w.xls, ctitle(Owner1 03-07) excel dec(3) keep(_Iowner_n_0 _Iowner_n_1 _Iowner_n_3 _Iowner_n_4) append
	restore
	
	/* Balanced sample SOE vs CC-SOE */
	preserve
	keep if bp_dum == 1
	replace owner_n = 4 if central_enterprise_def2 == 1 & owner_n == 0
	char owner_n[omit] 2
	xi: regress ln_TFP i.owner_n i.cic_3 i.province i.year, cluster(cic_3)
	outreg2 using _results_w.xls, ctitle(Owner2 98-07) excel dec(3) keep(_Iowner_n_0 _Iowner_n_1 _Iowner_n_3 _Iowner_n_4) append
	restore
	
	preserve
	keep if year < 2003 & bp_dum == 1
	replace owner_n = 4 if central_enterprise_def2 == 1 & owner_n == 0
	char owner_n[omit] 2
	xi: regress ln_TFP i.owner_n i.cic_3 i.province i.year, cluster(cic_3)
	outreg2 using _results_w.xls, ctitle(Owner2 98-02) excel dec(3) keep(_Iowner_n_0 _Iowner_n_1 _Iowner_n_3 _Iowner_n_4) append
	restore
	
	preserve
	keep if year > 2002 & bp_dum == 1
	replace owner_n = 4 if central_enterprise_def2 == 1 & owner_n == 0
	char owner_n[omit] 2
	xi: regress ln_TFP i.owner_n i.cic_3 i.province i.year, cluster(cic_3)
	outreg2 using _results_w.xls, ctitle(Owner2 03-07) excel dec(3) keep(_Iowner_n_0 _Iowner_n_1 _Iowner_n_3 _Iowner_n_4) append
	restore
	
	
  //** TFP by status change (Table 7.2) **//
  
	/* All sample */
	preserve
	keep if owner_1 == 0 & year < 2003
	char owner_2[omit] 3
	xi: regress ln_TFP i.owner_2 i.cic_3 i.province i.year, cluster(cic_3)
	outreg2 using _results_w.xls, ctitle(Change 98-02) excel dec(3) keep(_Iowner_2_0 _Iowner_2_1 _Iowner_2_2 _Iowner_2_4) append
	restore
	
	preserve
	keep if owner_1 == 0 & year > 2002 & owner_2 != 4
	char owner_2[omit] 3
	xi: regress ln_TFP i.owner_2 i.cic_3 i.province i.year, cluster(cic_3)
	outreg2 using _results_w.xls, ctitle(Change 03-07) excel dec(3) keep(_Iowner_2_0 _Iowner_2_1 _Iowner_2_2) append
	restore
	
	/* All sample SOE vs CC-SOE */
	preserve
	keep if owner_1 == 0 & year < 2003
	replace owner_2 = 5 if central_enterprise_def2 == 1 & owner_2 == 0
	char owner_2[omit] 3
	xi: regress ln_TFP i.owner_2 i.cic_3 i.province i.year, cluster(cic_3)
	outreg2 using _results_w.xls, ctitle(Change 98-02) excel dec(3) keep(_Iowner_2_0 _Iowner_2_1 _Iowner_2_2 _Iowner_2_4 _Iowner_2_5) append
	restore
	
	preserve
	keep if owner_1 == 0 & year > 2002 & owner_2 != 4
	replace owner_2 = 5 if central_enterprise_def2 == 1 & owner_2 == 0
	char owner_2[omit] 3
	xi: regress ln_TFP i.owner_2 i.cic_3 i.province i.year, cluster(cic_3)
	outreg2 using _results_w.xls, ctitle(Change 03-07) excel dec(3) keep(_Iowner_2_0 _Iowner_2_1 _Iowner_2_2 _Iowner_2_5) append
	restore
	
	/* Balanced sample SOE vs CC-SOE */
	preserve
	keep if owner_1 == 0 & year < 2003 & bp_dum == 1
	replace owner_2 = 5 if central_enterprise_def2 == 1 & owner_2 == 0
	char owner_2[omit] 3
	xi: regress ln_TFP i.owner_2 i.cic_3 i.province i.year, cluster(cic_3)
	outreg2 using _results_w.xls, ctitle(Change 98-02) excel dec(3) keep(_Iowner_2_0 _Iowner_2_1 _Iowner_2_2 _Iowner_2_5) append
	restore
	
	preserve
	keep if owner_1 == 0 & year > 2002 & owner_2 != 4 & bp_dum == 1
	replace owner_2 = 5 if central_enterprise_def2 == 1 & owner_2 == 0
	char owner_2[omit] 3
	xi: regress ln_TFP i.owner_2 i.cic_3 i.province i.year, cluster(cic_3)
	outreg2 using _results_w.xls, ctitle(Change 03-07) excel dec(3) keep(_Iowner_2_0 _Iowner_2_1 _Iowner_2_2 _Iowner_2_5) append
	restore


  //** Figure 5 **//

	keep if bp_dum == 1
   	xi: regress ln_TFP owner_n#year i.cic_3 i.province, cluster(cic_3)
	mat junk = e(b)
    scalar cns=_b[_cons]
    mat _w = (junk[1,1..10]\junk[1,11..20]\junk[1,21..30]\[cns,cns,cns,cns,cns,cns,cns,cns,cns,cns])'
	mat _year = (1998\1999\2000\2001\2002\2003\2004\2005\2006\2007)
	mat _w = _year,_w
	mat colnames _w = year soe private foreign constant
	putexcel set "_w.xlsx", sheet("year", replace)
	putexcel A1 = matrix(_w, colnames) using _w, sheet("year") replace
	
	clear
    import excel "_w.xlsx", sheet("year") firstrow
	replace soe = soe + constant
	replace private = private + constant
	replace foreign = foreign + constant

	tsset year
    twoway (tsline soe, lcolor(blue) lwidth(medthick)) (tsline private, lcolor(green) lpattern(dash)) (tsline foreign, lcolor(black) lpattern(dash_dot) lwidth(thick)), ///
	legend(order(1 "SOE" 2 "private" 3 "foreign") rows(1)) title("Fig 5. Log productivity" "(conditional mean and balanced sample)") ytitle(log productivity by ownership) xtitle("")
	graph export _trend_w.emf, replace


clear
