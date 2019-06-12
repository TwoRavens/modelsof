* Who Profits from Patents? Rent-Sharing at Innovative Firms
* Appendix Table 4
* Owners: Patrick Kline, Neviana Petkova, Heidi Williams and Owen Zidar
* Date: January 29, 2019


* This .do file creates the diff-in-diff results by firm size



*--------- APPENDIX TABLE 4 ---------*

    import delimited using "$data/QJEtables1/size.txt", clear varn(2) delimiter(tab)

    * keep only required rows
    gl postWrows ""
    * look for the input
    forvalues i = 1(1)`=_N' {
      if regexm(variables[`i'],"postW_n?Q5")==1 {
        loc next = `i'+1
        gl postWrows = "${postWrows},`i',`next'"
      }
    }
	
    keep if inlist(_n${postWrows}) | ///
        inlist(variables,"Observations","Mean dep var (Big)" ,"Mean dep var (SM)", ///
                                        "Elasticity (Big)","Elasticity (SM)")

    * keep only necessary columns, and order them
    keep  posemp lnemp_cop rev_emp va_emp ebitd_emp wb_emp s1_emp rat_stay lcomp_emp rat_broad
    order posemp lnemp_cop rev_emp va_emp ebitd_emp wb_emp s1_emp lcomp_emp rat_broad rat_stay

    * clean up numbers (stripping commas, parens, and asterisks) then destring
    foreach vv of varlist _all {
      replace `vv' = subinstr(`vv',"(","",.)
      replace `vv' = subinstr(`vv',")","",.)
      replace `vv' = subinstr(`vv',"*","",.)
      replace `vv' = subinstr(`vv',",","",.)
    }

    destring *, replace

    * replace the elasticity row with % impact by multiplying by 100
    foreach vv of varlist * {
      replace `vv' = 100*`vv' if inlist(_n,12,13) & "`vv'"!="lnemp_cop"
	  replace `vv' = . if inlist(_n,12,13) & "`vv'"=="lnemp_cop"
    }

    * resort the rows
    gen sortorder = _n
    * big firms
    replace sortorder = 4.3 in 1
    replace sortorder = 4.6 in 2
    replace sortorder = 4.1 in 10
    replace sortorder = 4.2 in 12
    * small firms
    replace sortorder = 8.3 in 5
    replace sortorder = 8.6 in 6
    replace sortorder = 8.1 in 11
    replace sortorder = 8.2 in 13
    * observations
    replace sortorder = 100 in 9
    sort sortorder
    drop sortorder

    mkmat *, mat(tabsize)
    mat li tabsize
    matrix_to_txt, saving("$tables/appx_table4.txt") mat(tabsize) title(<tab:appx_table4>) replace
