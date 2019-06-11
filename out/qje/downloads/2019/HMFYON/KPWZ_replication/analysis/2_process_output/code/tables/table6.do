* Who Profits from Patents? Rent-Sharing at Innovative Firms
* Table 6
* Owners: Patrick Kline, Neviana Petkova, Heidi Williams and Owen Zidar
* Date: January 29, 2019


* This .do file creates the workforce composition impacts table 



*--------- TABLE 6 ---------*


  use "$data/dta/DID_vals.dta", clear
 
  loc compvars shr_f shr_inv rat_prior wage_sep rat_stay_appyr age log_quality log_quality2_
  
  * No % impact if a log dependent variable
  foreach vv in "log_quality" "log_quality2_"{
      cap replace `vv' = . if variables == "Elasticity"
  }
      

  keep `compvars'
  order `compvars'
 
  
  mkmat *, mat(tabcomppanel)

  matrix_to_txt, saving("$tables/table6.txt") mat(tabcomppanel) title(<tab:table6>) replace

