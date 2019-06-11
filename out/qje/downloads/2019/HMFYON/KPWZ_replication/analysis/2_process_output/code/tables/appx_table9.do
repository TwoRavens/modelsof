* Who Profits from Patents? Rent-Sharing at Innovative Firms
* Appebndix Table 9
* Owners: Patrick Kline, Neviana Petkova, Heidi Williams and Owen Zidar
* Date: January 29, 2019


* This .do file creates the 3-year-average pass-through estimates



*--------- APPENDIX TABLE 9 ---------*

    import delimited using "$data/QJEtables_rent/RS_avg.txt", clear varn(2) delimiter(tab)

    foreach vv of varlist wb_emp_avg rat_m_avg rat_noninv_avg rat_stay_avg rat_stay_diff_avg rat_stay_noninv_avg {
      rename `vv' `vv'_ols
    }
    rename v4  wb_emp_avg_iv
    rename v6  rat_m_avg_iv
    rename v12 rat_noninv_avg_iv
    rename v14 rat_stay_avg_iv
    rename v16 rat_stay_diff_avg_iv
    rename v18 rat_stay_noninv_avg_iv

	 *Anderson-Rubin CI
    set obs `=_N+1'
    replace variables = "Anderson-Rubin 90% CI" in `=_N'
    assert variables[16] == "AR LL"
    assert variables[17] == "AR UL"
    foreach vv in wb_emp rat_m rat_noninv rat_stay rat_stay_diff rat_stay_noninv {   
    replace `vv'_avg_iv = "(" + string(real(`vv'_avg_iv[16]), "%12.2f") + "," + string(real(`vv'_avg_iv[17]), "%12.2f") + ")" in `=_N'
    }

	
    * Calculate elasticities for differenced variables
	foreach vv of varlist rat_stay_diff* {
	di "`vv'"
		assert variables[10] == "Elasticity"
        loc nondiff = subinstr("`vv'","_diff","",1)
		destring `vv', ignore("*NOYES") force g(temp_diff)
		destring `nondiff', ignore("*NOYES") force g(temp_nondiff)
        replace `vv' = string( temp_diff[2]*(temp_nondiff[10]/temp_nondiff[2]), "%12.2f")  if variables == "Elasticity"
		drop temp*
      }

    * keep only required rows
    keep if inlist(_n,2,3,5,10,14, 15, 20)

    * Reorder
    g order = _n
    replace order = order - 1 if variables=="Elasticity"
    replace order = order + 1 if variables =="Observations"
    sort order
    
    * keep only necessary columns (already in correct order)
    keep wb_emp_avg* rat_m_avg* rat_noninv_avg* rat_stay_avg* rat_stay_diff_avg* rat_stay_noninv_avg*

	* convert to a matrix (need to accomodate string observation)
    preserve

      drop in 7

      * clean up numbers (stripping commas, parens, and asterisks) then destring
      foreach vv of varlist _all {
        replace `vv' = subinstr(`vv',"(","",.)
        replace `vv' = subinstr(`vv',")","",.)
        replace `vv' = subinstr(`vv',"*","",.)
        replace `vv' = subinstr(`vv',",","",.)
      }

      destring *, replace
	
      mkmat *, mat(tabRS_avgpanel)
      mat li tabRS_avgpanel
      tempfile RS_avg_panel
      matrix_to_txt, saving(`RS_avg_panel') mat(tabRS_avgpanel) title(<tab:appx_table9>) replace

    restore

    * append the last row
    keep in 7
    tempfile RS_avg_lastrow
    export delimited using `RS_avg_lastrow', delim(tab) novar replace
	
	
   ! rm -f "$tables/appx_table9.txt" && cat `RS_avg_panel' `RS_avg_lastrow'  > "$tables/appx_table9.txt"
   
   

