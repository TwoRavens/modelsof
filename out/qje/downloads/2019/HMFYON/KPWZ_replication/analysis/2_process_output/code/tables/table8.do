* Who Profits from Patents? Rent-Sharing at Innovative Firms
* Table 8
* Owners: Patrick Kline, Neviana Petkova, Heidi Williams and Owen Zidar
* Date: January 29, 2019


* This .do file creates the pass-through estimates



*--------- TABLE 8 ---------*

  foreach t in "RS" "RS_VA" {
    ** Import actual table
    import delimited using "$data/QJEtables_rent/`t'.txt", clear varn(2) delimiter(tab)

    if "`t'"=="RS_VA"{
       local addv = "_va"
    }
    
    foreach vv of varlist wb_emp rat_m rat_noninv rat_stay rat_stay_diff rat_stay_noninv {
      rename `vv' `vv'`addv'_ols
    }
    rename v4  wb_emp`addv'_iv
    rename v6  rat_m`addv'_iv
    rename v12 rat_noninv`addv'_iv
    rename v14 rat_stay`addv'_iv
    rename v16 rat_stay_diff`addv'_iv
    rename v18 rat_stay_noninv`addv'_iv
    
    *Anderson-Rubin CI
    set obs `=_N+1'
    replace variables = "Anderson-Rubin 90% CI" in `=_N'
    assert variables[16] == "AR LL"
    assert variables[17] == "AR UL"
    foreach vv in wb_emp rat_m rat_noninv rat_stay rat_stay_diff rat_stay_noninv {   
    replace `vv'`addv'_iv = "(" + string(real(`vv'`addv'_iv[16]), "%12.2f") + "," + string(real(`vv'`addv'_iv[17]), "%12.2f") + ")" in `=_N'
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
    keep wb_emp`addv'* rat_m`addv'* rat_noninv`addv'* rat_stay`addv'* rat_stay_diff`addv'* rat_stay_noninv`addv'*
 
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

      if "`t'"=="RS"{
      local title = "title(<tab:table8>)"
      }
      else{
      local title = " "
      }
	
      mkmat *, mat(tab`t'_panel)
      mat li tab`t'_panel
      tempfile `t'_panel
      matrix_to_txt, saving(``t'_panel') mat(tab`t'_panel) `title' replace

    restore

    * append the last row
    keep in 7
    tempfile `t'_lastrow
    export delimited using ``t'_lastrow', delim(tab) novar replace
	}
	
   ! rm -f "$tables/table8.txt" && cat `RS_panel' `RS_lastrow' `RS_VA_panel' `RS_VA_lastrow'  > "$tables/table8.txt"
    

