* Who Profits from Patents? Rent-Sharing at Innovative Firms
* Appendix Table 1
* Owners: Patrick Kline, Neviana Petkova, Heidi Williams and Owen Zidar
* Date: January 29, 2019


* This .do file creates the spatial correlation in allowances table



*--------- APPENDIX TABLE 1 ---------*

    * first the state-zip one
    import delimited using "$data/QJEtables_balance/ICC.txt", clear varn(1) delimiter(tab)

    * shuffle geography information
    loc tot = _N
    forvalues i = 1(1)`tot'{
      if v1=="Number of fips" in `i' {
        loc fip = `i'
      }
      if v1=="Number of zip" in `i' {
        loc zip = `i'
      }
    }

    foreach v in "v5" "v6" "v9" "v10" {
      replace `v'=`v'[`zip'] in `fip'
    }

    * keep only required rows
    keep if inlist(v1,"Observations","Number of fips","rho","p-val")

    * reorder rows
    gen sortorder = _n
    replace sortorder = .3 if v1=="rho"
    replace sortorder = .6 if v1=="p-val"
    sort sortorder
    drop sortorder

    * keep only necessary columns
    drop v1 v2

    * clean up numbers (stripping commas, parens, and asterisks) then destring
    foreach vv of varlist _all {
      replace `vv' = subinstr(`vv',"(","",.)
      replace `vv' = subinstr(`vv',")","",.)
      replace `vv' = subinstr(`vv',"*","",.)
      replace `vv' = subinstr(`vv',",","",.)
    }

    destring *, replace

    * convert to a matrix (stack them)
    rename (v3 v4 v5 v6 v7 v8 v9 v10) (a1 b1 c1 d1 a2 b2 c2 d2)
    gen i = _n
    reshape long a b c d, i(i) j(j)
    sort j i
    mkmat a b c d, mat(tabICC_stzip)

    * then the NAICS one
    import delimited using "$data/QJEtables_balance/ICC2.txt", clear varn(1) delimiter(tab)

    * shuffle geography information
    loc tot = _N
    forvalues i = 1(1)`tot'{
      if v1=="Number of naics4d" in `i' {
        loc naics4d = `i'
      }
      if v1=="Number of naicsfips" in `i' {
        loc naicsfips = `i'
      }
    }

    * be careful here! the order of variables is different for this one
    foreach v in "v7" "v8" "v9" "v10" {
      replace `v'=`v'[`naicsfips'] in `naics4d'
    }

    * keep only required rows
    keep if inlist(v1,"Observations","Number of naics4d","rho","p-val")

     * reorder rows
    gen sortorder = _n
    replace sortorder = .3 if v1=="rho"
    replace sortorder = .6 if v1=="p-val"
    sort sortorder
    drop sortorder

    * keep only necessary columns
    drop v1 v2

    * clean up numbers (stripping commas, parens, and asterisks) then destring
    foreach vv of varlist _all {
      replace `vv' = subinstr(`vv',"(","",.)
      replace `vv' = subinstr(`vv',")","",.)
      replace `vv' = subinstr(`vv',"*","",.)
      replace `vv' = subinstr(`vv',",","",.)
    }

    destring *, replace

    * convert to a matrix (stack them) -- be careful again! the variable ordering is different from the first
    rename (v3 v4 v5 v6 v7 v8 v9 v10) (a1 b1 a2 b2 c1 d1 c2 d2)
    gen i = _n
    reshape long a b c d, i(i) j(j)
    sort j i
    mkmat a b c d, mat(tabICC_naics)

    mat tabICC = tabICC_stzip , tabICC_naics
    matrix_to_txt, saving("$tables/appx_table1.txt") mat(tabICC) title(<tab:appx_table1>) replace


