* Who Profits from Patents? Rent-Sharing at Innovative Firms
* Table 1
* Owners: Patrick Kline, Neviana Petkova, Heidi Williams and Owen Zidar
* Date: January 29, 2019


* This .do file creates the waterfall table 



*--------- TABLE 1 ---------*

  ** waterfall sample size table
  cap ssc install distinct

  * create program to create waterfall summary matrix
  cap program drop wfall_summary
  program define wfall_summary
    * distinct appnum-org pairs
    distinct appnum std_assigneeorgname, joint
    local pairs = r(ndistinct)
    * distinct appnums
    distinct appnum
    local appnums = r(ndistinct)
    * distinct orgs
    distinct std_assigneeorgname
    local orgs = r(ndistinct)

    matrix waterfall = nullmat(waterfall) \ `pairs', `appnums', `orgs'
    matlist waterfall
  end

  * start the sieve
  use "$data/dta/KPWZ_waterfall.dta", clear
  replace std_assigneeorgname = "!@#$%" if mi(std_assigneeorgname)
  cap mat drop waterfall
  wfall_summary

  * apply restriction: keep only in years 2000-2010
  keep if inrange(applicationyear, 2000, 2010)
  wfall_summary

  * apply restriction: missing orgnames
  drop if std_assigneeorgname == "!@#$%"
  wfall_summary

  * apply restriction: child status
  drop if child_status == 1
  wfall_summary

  * apply restriction utility patents only
  keep if kindcode == "A1"
  wfall_summary

  * select first application
  bysort std_assigneeorgname (applicationdate): keep if applicationdate==applicationdate[1]
  *break tie by smaller application number
  bysort std_assigneeorgname (appnum): keep if _n==1
  wfall_summary

  * select assignees with no prior grants
  keep if num_grants_filedbef_112900 == 0
  wfall_summary

  *** had to hardcode some of the numbers
  mat waterfall = nullmat(waterfall) , (. \ . \ . \ . \ . \ . \ .)
  mat waterfall = nullmat(waterfall) \ (. , 39452 , 39814 , 81934)
  mat waterfall = nullmat(waterfall) \ (. , 37714 , . , 81877)
  mat waterfall = nullmat(waterfall) \ (. , 35643 , . , 78291)
  mat waterfall = nullmat(waterfall) \ (. , 35643 , . , 35643)
  mat waterfall = nullmat(waterfall) \ (. , 9732 , . , 9732)

  mat li waterfall
  matrix_to_txt, saving("$tables/table1.txt") mat(waterfall) title(<tab:table1>) replace

