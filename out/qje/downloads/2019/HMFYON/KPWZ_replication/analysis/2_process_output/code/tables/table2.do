* Who Profits from Patents? Rent-Sharing at Innovative Firms
* Table 2
* Owners: Patrick Kline, Neviana Petkova, Heidi Williams and Owen Zidar
* Date: January 29, 2019


* This .do file creates the summary stats table 



*--------- TABLE 2 ---------*

  foreach pref in "fullsample" "doseQ5" {
  
    * import the file and merge it to the working copy
    import delimited using "$data/summ/stats_`pref'100.csv", clear
    
    *Set up last row as number of observations 
    set obs `=_N+1'
    g samplesize  =  n[1]
    replace varname = "N" in `=_N'
    foreach item in mean p10 p50 p90{
	replace `item' = 100*`item' if (strpos(varname, "shr") | strpos(varname, "winner"))
	replace `item' = 1000*`item' if varname=="dose"
	rename `item' `item'_`pref'
	replace `item'_`pref' = samplesize in `=_N'
    }

    drop samplesize n
	
    tempfile data_`pref'
    save `data_`pref''
    }
    
    clear
    use `data_fullsample'
    merge 1:1 varname using `data_doseQ5'
    assert _merge==3
    drop _merge

    ******************
    *Label Variables 
    ******************
    gen count = .
    local tempcount = 1
    *Worker outcomes
    replace count = `tempcount' if varname== "(sum) rev"
    replace varname = "Revenue" if varname== "(sum) rev"
    local ++tempcount

    replace count = `tempcount' if varname== "(sum) va"
    replace varname = "Value added" if varname== "(sum) va"
    local ++tempcount

    replace count = `tempcount' if varname== "(sum) ebitd"
    replace varname = "EBITD" if varname== "(sum) ebitd"
    local ++tempcount

    replace count = `tempcount' if varname== "(sum) emp"
    replace varname = "Employment" if varname== "(sum) emp"
    local ++tempcount

    replace count = `tempcount' if varname== "va_emp"
    replace varname = "Value added/ worker" if varname== "va_emp"
    local ++tempcount
    
    replace count = `tempcount' if varname== "ebitd_emp"
    replace varname = "EBITD / worker" if varname== "ebitd_emp"
    local ++tempcount

    replace count = `tempcount' if varname== "dose"
    replace varname = "Predicted patent value" if varname== "dose"
    local ++tempcount

    replace count = `tempcount' if varname== "winner"
    replace varname = "% Patents initially allowed" if varname== "winner"
    local ++tempcount

    *Worker outcomes
    replace count = `tempcount' if varname== "(sum) lcomp"
    replace varname = "Labor compensation" if varname== "(sum) lcomp"
    local ++tempcount

    replace count = `tempcount' if varname== "(sum) wb"
    replace varname = "Wage bill" if varname== "(sum) wb"
    local ++tempcount

    replace count = `tempcount' if varname== "lcomp_emp"
    replace varname = "Labor compensation / worker" if varname== "lcomp_emp"
    local ++tempcount

    replace count = `tempcount' if varname== "wb_emp"
    replace varname = "Wage bill / worker" if varname== "wb_emp"
    local ++tempcount
    
    replace count = `tempcount' if varname== "(mean) wage_ent3"
    replace varname = "Entrant wage" if varname== "(mean) wage_ent3"
    local ++tempcount
    
    replace count = `tempcount' if varname== "wage_4p"
    replace varname = "Incumbent wage" if varname== "wage_4p"
    local ++tempcount

    replace count = `tempcount' if varname== "shr_f"
    replace varname = "% Female employment" if varname== "shr_f"
    local ++tempcount

    replace count = `tempcount' if varname== "shr_jani"
    replace varname = "% Custodial/clerical employment" if varname== "shr_jani"
    local ++tempcount

    replace count = `tempcount' if varname== "shr_contract"
    replace varname = "% Contractors" if varname== "shr_contract"
    local ++tempcount

    replace count = `tempcount' if varname== "shr_ent"
    replace varname = "% Entrants " if varname== "shr_ent"
    local ++tempcount

    replace count = `tempcount' if varname== "shr_stay"
    replace varname = "% Stayers" if varname==  "shr_stay"
    local ++tempcount

    replace count = `tempcount' if varname== "shr_inv"
    replace varname = "% Inventors" if varname== "shr_inv"
    local ++tempcount

    replace count = 0 if varname== "N"

    *Only keep the variables we are tabulating
    drop if count==.

  * clean up slightly
  order varname mean_fullsample p10_fullsample p50_fullsample p90_fullsample mean_doseQ5 p10_doseQ5 p50_doseQ5 p90_doseQ5
  foreach vv of varlist p*{
    replace `vv' = . if inlist(varname, "% Patents initially allowed", "N")
  }

  * gen a firm vs worker indicator
  gen work = !inlist(varname, "Revenue", "Value added", "EBITD", "Employment", ///
             "Value added/ worker", "EBITD / worker", "Predicted patent value", "% Patents initially allowed")

  * get the correct order
  gen sortorder = .
  replace sortorder = 1  if varname == "Revenue"
  replace sortorder = 2  if varname == "Value added"
  replace sortorder = 3  if varname == "Labor compensation"
  replace sortorder = 4  if varname == "EBITD"
  replace sortorder = 5  if varname == "Wage bill"
  replace sortorder = 6  if varname == "Employment"
  replace sortorder = 7  if varname == "Labor compensation / worker"
  replace sortorder = 8  if varname == "Wage bill / worker"
  replace sortorder = 9  if varname == "Value added/ worker"
  replace sortorder = 10 if varname == "EBITD / worker"
  replace sortorder = 11 if varname == "Entrant wage"
  replace sortorder = 12 if varname == "Incumbent wage"
  replace sortorder = 13 if varname == "% Female employment"
  replace sortorder = 14 if varname == "% Contractors"
  replace sortorder = 15 if varname == "% Entrants "
  replace sortorder = 16 if varname == "% Inventors"
  replace sortorder = 17 if varname == "Predicted patent value"
  replace sortorder = 18 if varname == "% Patents initially allowed"
  replace sortorder = 19 if varname == "N"
  sort work sortorder
  drop if mi(sortorder)
  drop sortorder

  mkmat mean_fullsample p10_fullsample p50_fullsample p90_fullsample mean_doseQ5 p10_doseQ5 p50_doseQ5 p90_doseQ5, mat(sumstat)
 
 * save matrices
  matrix_to_txt, saving("$tables/table2.txt") mat(sumstat) title(<tab:table2>) replace
