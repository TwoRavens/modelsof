* Who Profits from Patents? Rent-Sharing at Innovative Firms
* Table 3
* Owners: Patrick Kline, Neviana Petkova, Heidi Williams and Owen Zidar
* Date: January 29, 2019


* This .do file creates the balance table 



*--------- TABLE 3 ---------*

    import delimited using "$data/QJEtables_balance/tableB.txt", clear varn(1) delimiter(tab)

    loc tot = _N
    forvalues i = 1(1)`tot'{
      if v1=="Observations" in `i' {
        loc obs = `i'
      }
    }

    * keep only required rows
    loc obsm2 = `obs'-2
    keep if (_n>=3 & _n<=`obsm2') | inlist(v1,"Observations","p-val","Exogeneity","1st Stage F")

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

    * convert to a matrix
    mkmat v*, mat(tableB)
	
    matrix_to_txt, saving("$tables/table3.txt") mat(tableB) title(<tab:table3>) replace
 
