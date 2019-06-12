* .do file to process input files for Who Profits from Patents? Rent-Sharing at Innovative Firms
* Owners: Patrick Kline, Neviana Petkova, Heidi Williams and Owen Zidar
* Date: January 29, 2019

   

  * location of baseline outcomes
    foreach dataset in "basic" "gap" "gap_bal" "quartiles" "stay" "entwage" "comp" "pay3" "gap2" "dose" "size" "taxes"{
      local path_`dataset' = "$data/QJEtables1/`dataset'.txt"
	  di "path_`dataset'"
    }
	
  * location for pay/stayers variables and quality tables
    foreach dataset in "pay" "stayers" "quality" {
      local path_`dataset' = "$data/QJEtables2/`dataset'.txt"
	  di "path_`dataset'"
    }

  * location for closely held firms
    foreach dataset in "basic" "quartiles" "stay" "pay3" "pay" "stayers" "gap_bal" {
      local path_pt_`dataset' = "$data/QJEtables_form/`dataset'.txt"
	  di "path_pt_`dataset'"
    }

  * location for officer earnings
    foreach dataset in "wage1" "wage1_pass" {
	  loc prefix ""
      if "`dataset'"=="wage1_pass" {
        loc prefix "pt_"
      }
	  
      local path_`prefix'wage1 = "$data/QJEtables_officers/`dataset'.txt"
	   di "path_`prefix'wage1'"
    }
	
	
  * assemble it into one data set with columns that can be called as desired
  clear
  set obs 7
  gen variables = ""
  replace variables = "win_<Q5"      in 1
  replace variables = "win_<Q5_se"   in 2
  replace variables = "win_Q5"       in 3
  replace variables = "win_Q5_se"    in 4
  replace variables = "Mean dep var" in 5
  replace variables = "Elasticity"   in 6
  replace variables = "Observations" in 7


  tempfile wkfile
  save `wkfile'

  tempfile level
  * loop over all needed tables, grabbing column names and merging to a working file
  foreach t in "basic" "gap" "gap_bal" "quartiles"  "stay" "entwage" "comp" "pay3" "gap2" "pay" "stayers" "quality" "wage1" "taxes" "pt_basic" "pt_quartiles" "pt_stay" "pt_pay3" "pt_pay" "pt_stayers" "pt_gap_bal" "pt_wage1" {

    *** load level table
	di "`path_`t''"
    import delimited using "`path_`t''", varn(2) clear
    drop labels

    * rename rows
    qui{
    replace variables = "win_<Q5"     if variables == "postW_nQ5"
    replace variables = "win_<Q5_se"  if variables[_n-1] == "win_<Q5"
    replace variables = "win_Q5"      if variables == "postW_Q5"
    replace variables = "win_Q5_se"   if variables[_n-1] == "win_Q5"
    replace variables = "lose_<Q5"    if variables == "post_nQ5"
    replace variables = "lose_<Q5_se" if variables[_n-1] == "lose_<Q5"
    replace variables = "lose_Q5"     if variables == "post_Q5"
    replace variables = "lose_Q5_se"  if variables[_n-1] == "lose_Q5"

    * clean up numbers (stripping commas, parens, and asterisks) then destring
    foreach vv of varlist _all {
      replace `vv' = subinstr(`vv',"(","",.)
      replace `vv' = subinstr(`vv',")","",.)
      replace `vv' = subinstr(`vv',"*","",.)
      replace `vv' = subinstr(`vv',",","",.)
    }
    }
   
   * keep necessary rows
    keep if inlist(variables,"win_<Q5","win_<Q5_se","win_Q5","win_Q5_se","Mean dep var", "Elasticity", "Observations")

   * If closely held, rename variable
    if regexm("`t'", "pt_"){
    qui ds variables, not
    foreach var of varlist `r(varlist)'{
      rename `var' pt_`var'
    }
    }
  
   * If balanced, rename variable
    if regexm("`t'", "_bal"){
    qui ds variables, not
    foreach var of varlist `r(varlist)'{
      rename `var' `var'_bal
    }
    }
  

    destring *, replace

    * convert to a matrix
    save `level', replace

    * for now, keep 2 for quality
    if "`t"=="quality"{
	local keep2 = `2'
    }
    
    merge 1:1 variables using `wkfile', keep(3) nogen
    save `wkfile', replace
  }
  
  * replace the elasticity row with % impact by multiplying by 100
  cap {
    foreach vv of varlist * {
      if "`vv'"!="variables" {
        replace `vv' = 100*`vv' if variables=="Elasticity"
      }
    }
  }

  gen sortorder = .
  replace sortorder = 1  if variables=="win_Q5"
  replace sortorder = 2  if variables=="win_Q5_se"
  replace sortorder = 3 if variables=="Mean dep var"
  replace sortorder = 4 if variables=="Elasticity"
  replace sortorder = 5  if variables=="win_<Q5"
  replace sortorder = 6  if variables=="win_<Q5_se"
  replace sortorder = 7 if variables=="Observations"
  sort sortorder
  drop sortorder
  
  ! mkdir -p "$data/dta"
  
  save "$data/dta/DID_vals.dta", replace
