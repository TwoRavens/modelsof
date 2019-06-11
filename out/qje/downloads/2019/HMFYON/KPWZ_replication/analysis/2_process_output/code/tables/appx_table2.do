* Who Profits from Patents? Rent-Sharing at Innovative Firms
* Appendix Table 2
* Owners: Patrick Kline, Neviana Petkova, Heidi Williams and Owen Zidar
* Date: January 29, 2019


* This .do file creates the mean xi-hat by technology center table



*--------- APPENDIX TABLE 2 ---------*

   *import the xi hat by tech center values
  import delimited using "$data/QJEtables1/xiTC.csv", varn(1) clear case(preserve)
  
  * Note that, for the sake of SSN privacy, all tech centers with fewer than 10
  * observations were omitted from the .csv. Total observations is N=6,402. 
  
  rename tech_center number
  
  * get the mean and N values
  preserve
    import delimited using "$data/dta/tech_center_names.csv", varn(1) clear
    tempfile names
    save `names'
  restore

  * attach values to names
  merge 1:1 number using `names', keep(match) nogen
  gsort -meanxihat

  * keep necessary vars
  keep tech_center meanxihat Nxihat

  * reshape to two columns
  gen i = _n
  replace i = i - 23 if i >=24
  sort i, stable
  by i: gen j = _n
  reshape wide tech_center meanxihat Nxihat, i(i) j(j)

  drop i

  *ordering
  order tech_center1 meanxihat1 Nxihat1 tech_center2 meanxihat2 Nxihat2

  * export to tab delimited file and then clean for autofill
  tempfile body
  export delimited using `body', delimiter(tab) novar replace
  tempfile header
  ! echo "<tab:appx_table2>" > `header' && rm -f "$tables/appx_table2.txt" && cat `header' `body' > "$tables/appx_table2.txt"
