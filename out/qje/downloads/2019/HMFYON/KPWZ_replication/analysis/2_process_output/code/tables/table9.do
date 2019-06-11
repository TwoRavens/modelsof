* Who Profits from Patents? Rent-Sharing at Innovative Firms
* Table 9
* Owners: Patrick Kline, Neviana Petkova, Heidi Williams and Owen Zidar
* Date: January 29, 2019


* This .do file creates the retention table



*--------- TABLE 9 ---------*
* load the required table
    import delimited using "$data/QJEtables_ret/ret_IV_FX.txt", clear varn(2) delimiter(tab)

    * keep only required rows
    keep if inrange(_n,2,11) | inlist(variables,"Observations","Sep Elasticity","1st Stage F","Exogeneity","AR LL","AR UL")

    * create a confidence interval
    set obs 17
    replace variables = "AR" in 17
    foreach vv of varlist ln_* {
      replace `vv' = "(" + `vv'[15] + ", " + `vv'[16] + ")" in 17
    }
    drop in 15/16
    
    *Reformat table by moving separation elasticities below the point estimates
    g order = _n
    replace order = order+1 if order>10
    replace order = order+1 if order>8
    replace order = order+1 if order>6    
    replace order = order+1 if order>4
    replace order = order+1 if order>2  
      
    set obs `=_N+5'
    replace order = 3 in `=_N-4'
    replace order = 6 in `=_N-3'
    replace order = 9 in `=_N-2'
    replace order = 12 in `=_N-1'
    replace order = 15 in `=_N'
    
    sort order
    
    replace ln_retrate = ln_retrate[17] in 3
    replace ln_retrate_q6 = ln_retrate_q6[17] in 6
    replace ln_retrate_m = ln_retrate_m[17] in 9
    replace ln_retrate_f = ln_retrate_f[17] in 12
    replace ln_retrate_noninv = ln_retrate_noninv[17] in 15
    
    drop if variables=="Sep Elasticity"

    * keep only necessary columns (already in correct order)
    keep ln_*

    * convert to a matrix (need to accomodate string observation and reorg of the table)
    preserve

      drop in 16/19

      * clean up numbers (stripping commas, parens, and asterisks) then destring
      foreach vv of varlist ln_* {
        replace `vv' = subinstr(`vv',"(","",.)
        replace `vv' = subinstr(`vv',")","",.)
        replace `vv' = subinstr(`vv',"*","",.)
        replace `vv' = subinstr(`vv',",","",.)
      }

      destring *, replace
      
      g row = mod(_n, 3)
      replace row = 3 if row==0
      
      collapse (sum) ln_*, by(row)
      
      drop row

      tempfile tabret_top
      save `tabret_top'
      
    restore
    
    preserve
      keep in 16/18
      
      * clean up numbers (stripping commas, parens, and asterisks) then destring
      foreach vv of varlist ln_* {
        replace `vv' = subinstr(`vv',"(","",.)
        replace `vv' = subinstr(`vv',")","",.)
        replace `vv' = subinstr(`vv',"*","",.)
        replace `vv' = subinstr(`vv',",","",.)
      }

      destring *, replace
      
      tempfile tabret_bot
      save `tabret_bot'
      
      clear
      use `tabret_top'
      append using `tabret_bot'
      
      mkmat *, mat(tabret)    
      mat li tabret
      tempfile basetable
      matrix_to_txt, saving(`basetable') mat(tabret) title(<tab:table9>) replace

    restore

    * append the last row
    keep in 19
    tempfile lastrow
    export delimited using `lastrow', delim(tab) novar replace

    ! rm -f "$tables/table9.txt" && cat `basetable' `lastrow' > "$tables/table9.txt"
