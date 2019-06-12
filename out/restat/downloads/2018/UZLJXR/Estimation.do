** Berkowitz, Ma and Nishioka (Updated 12-25-2015) Table 5


  cd C:\Users\shuichiro\Documents\Research\_Berkowitz&Ma&Nishioka\_RIRB\_Data
  
  clear
  import excel "_GMM.xlsx", sheet("sectors") firstrow
  save _GMM.dta, replace
  
  use _LS_dta.dta, clear
  merge m:m cic_3 using "_GMM.dta"
  drop _merge
  erase _GMM.dta


  ///*** Labor share estimation ***///
  
    /* Labor share variables */
	tsset firm_id year
	gen ln_markup = ln((1-bs_1)/(input/gross_output))
    gen ln_mt = ln(exp(ln_markup)-1+bs_1)
	gen ln_et = ln(bs_1) - ln(1+((1-bs_3)/bs_3)*(aemployee/real_cap)^((1-bs_2)/bs_2))
	gen ln_pw = ln_ls + ln_mt - ln_et
	gen soe_year=0
	replace soe_year=year if soe_dum == 1
	
	/* Eliminate 0.5% outlier values (wL/VA) */
	sort year firm_id
    by year: egen ls_min = pctile(ln_ls), p(0.25)
    by year: egen ls_max = pctile(ln_ls), p(99.75)
    gen outliers_ls = 0
    replace outliers_ls = 1 if ln_ls > ls_max | ln_ls < ls_min
    drop ls_min ls_max
	
	/* Eliminate 0.5% outlier values */
	sort year firm_id
	by year: egen mt_min = pctile(ln_mt), p(0.25)
    by year: egen mt_max = pctile(ln_mt), p(99.75)
    gen outliers_mt = 0
    replace outliers_mt = 1 if ln_mt > mt_max | ln_mt < mt_min
    drop mt_min mt_max
	
	/* Eliminate 0.5% outlier values */
	sort year firm_id
    by year: egen et_min = pctile(ln_et), p(0.25)
    by year: egen et_max = pctile(ln_et), p(99.75)
    gen outliers_et = 0
    replace outliers_et = 1 if ln_et > et_max | ln_et < et_min
    drop et_min et_max
	
	drop if outliers_ls == 1 | outliers_mt == 1 | outliers_et == 1
	tsset firm_id year


  //** Political weights (Entire sample) **//
	
	xi: reg ln_pw i.soe_year i.year i.cic_3 i.province, cluster(cic_3)
	outreg2 using _results_pw.xls, ctitle(Entire) noparen noaster replace
	mat junk = e(b)
	mat _pw_1 = (junk[1,1..10])'
	mat _year = (1998\1999\2000\2001\2002\2003\2004\2005\2006\2007)
	mat _pw_1 = _year,_pw_1
	mat colnames _pw_1 = year pw_1
	putexcel set "_pw.xlsx", sheet("pw_1", replace)
	putexcel A1 = matrix(_pw_1, colnames) using _pw, sheet("_pw_1") replace
	
	forvalues r = 1/4{
       preserve
       keep if region == `r'
	   xi: reg ln_pw i.soe_year i.year i.cic_3 i.province, cluster(cic_3)
	   outreg2 using _results_pw.xls, ctitle(Region `r') noparen noaster append
	   restore
	}

	
  //** Political weights (Balanced panel) **//
	
	drop if sw_dum == .
	xi: reg ln_pw i.soe_year i.year i.cic_3 i.province, cluster(cic_3)
	outreg2 using _results_pw.xls, ctitle(Balance) noparen noaster append
	mat junk = e(b)
	mat _pw_2 = (junk[1,1..10])'
	mat _year = (1998\1999\2000\2001\2002\2003\2004\2005\2006\2007)
	mat _pw_2 = _year,_pw_2
	mat colnames _pw_2 = year pw_2
	putexcel set "_pw.xlsx", sheet("pw_2", replace)
	putexcel A1 = matrix(_pw_2, colnames) using _pw, sheet("_pw_2") modify
	
	forvalues r = 1/4{
       preserve
       keep if region == `r'
	   xi: reg ln_pw i.soe_year i.year i.cic_3 i.province, cluster(cic_3)
	   outreg2 using _results_pw.xls, ctitle(Region `r') noparen noaster append
	   mat junk = e(b)
	   mat _pw_`r' = (junk[1,1..10])'
	   restore
	}
	
	mat _pw_r = _year,_pw_1,_pw_2,_pw_3,_pw_4
	mat colnames _pw_r = year north east south west 
	putexcel set "_pw_r.xlsx", sheet("year", replace)
	putexcel A1 = matrix(_pw_r, colnames) using _pw_r, sheet("year") replace
	
	
clear
