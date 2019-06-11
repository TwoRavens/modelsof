* Who Profits from Patents? Rent-Sharing at Innovative Firms
* Table 4
* Owners: Patrick Kline, Neviana Petkova, Heidi Williams and Owen Zidar
* Date: January 29, 2019


* This .do file creates the dosage table 



*--------- TABLE 4 ---------*

  ** dosage table
  import delimited using "$data/QJEtables1/dose.txt", clear delimiter(tab)
  keep if (_n>=4 & _n<=29) | (_n>=31 & _n<=33)

  * drop and rename
  keep v3 v4
  rename v3 xi
  rename v4 sigma

  * clean the data
  foreach vv of varlist _all {
    replace `vv' = subinstr(`vv',"(","",.)
    replace `vv' = subinstr(`vv',")","",.)
    replace `vv' = subinstr(`vv',"*","",.)
    replace `vv' = subinstr(`vv',",","",.)
  }

  destring *, replace
  loc sig1 = sigma[25]
  loc sig2 = sigma[26]
  drop sigma

  * put the standard errors next to the coeffs
  gen id = ceil(_n/2)
  sort id, stable
  by id: gen n = _n
  replace id = 15 in 28
  replace id = 16 in 29
  replace n = 1 in 28

  * replace id for the non reshape vars
  reshape wide xi, i(id) j(n)
  * add in the sigma
  set obs 17
  replace xi1 = `sig1' in 17
  replace xi2 = `sig2' in 17
  replace id = 13.5 in 17
  sort id
  drop id

  * get the correct ordering
  order xi1 xi2

  * save matrix then append stayers and cohorts
  mkmat *, mat(dose)
  matrix_to_txt, saving("$tables/table4.txt") mat(dose) title(<tab:table4>) replace

