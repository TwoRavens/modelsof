* Who Profits from Patents? Rent-Sharing at Innovative Firms
* Table 5
* Owners: Patrick Kline, Neviana Petkova, Heidi Williams and Owen Zidar
* Date: January 29, 2019


* This .do file creates the basic impacts table (all firms and closely held only)



*--------- TABLE 5 ---------*


  use "$data/dta/DID_vals.dta", clear
 
  loc basicvars posemp lnemp_cop rev_emp va_emp ebitd_emp wb_emp s1_emp lcomp_emp rat_broad avg_tax

  * No % impact if a log dependent variable
  foreach vv in "lnemp_cop"{
      cap replace `vv' = . if variables == "Elasticity"
  }
      
  keep `basicvars'
  order `basicvars'
  mkmat *, mat(tabbasicall)

	  
  mat tabbasicpanel = tabbasicall 

  matrix_to_txt, saving("$tables/table5.txt") mat(tabbasicpanel) title(<tab:table5>) replace


