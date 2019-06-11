  /*To replicate the descriptive statistics and figures, you will need the following datafiles: 
  1. election_level_data101813.dta 
  2. bjps_powell_tucker_dataset.dta
  3. party_level_data101813.dta
  4. Fig1.xlsx*/
  
  /*Input the location of the directory where you have saved the datafiles (e.g., C:\Users\username\Downloads)*/
  cd " "
  
  use election_level_data101813.dta, clear
  describe
  
  /*This merges the EIP data with Powell and Tucker's data on electoral volatility (BJPS, 2013)*/
  merge m:1 country t using bjps_powell_tucker_dataset.dta
  
  /*Next few lines generate descriptive statistics reported in the text (pp. 17-21)*/
  sum EIP 
  by Region_1, sort: sum EIP 
  cor EIP EIP_w EIP_n percent_changing
  by Region_1, sort: cor EIP Type* Total* 
  cor EIP EIP_w EIP_n percent_changing
  
  /*Replicates Fig. 3 in Text*/
  /*Generate a scatterplot for each region separately; then use .combine to generate a single graph*/
  gen EIP_E = EIP if Region_1 == 0
  graph twoway (scatter TotalVol EIP if Region_1==0 ), xtitle("Party Instability") ytitle("Electoral Volatility") title("Central and Eastern Europe") legend(off) ylabel(0 5 10 15 20)
  graph save scatter_vol_CEE, replace
  graph use scatter_vol_CEE
  graph export scatter_vol_CEE.eps, replace
  gen EIP_W = EIP if Region_1 == 1
  *Trick to equalize x-axes for East and West*
  replace EIP_W = 17 if TotalVol==.
  graph twoway (scatter TotalVol EIP if Region_1==1 ), xtitle("Party Instability") ytitle("Electoral Volatility") title("Western Europe") legend(off) ylabel(0 5 10 15 20)
  graph save scatter_vol_WE, replace
  graph use scatter_vol_WE
  graph export scatter_vol_WE.eps, replace
  graph twoway (scatter TotalVol EIP if Region_1==0 ), ytitle("Electoral Volatility") title("Central and Eastern Europe") xtitle(" ") legend(off) name(vol_CEE, replace) nodraw yscale(range(0 80)) ylabel(0 20 40 60 80, nogrid) xscale(range(0 20)) xlabel(0 5 10 15 20, nogrid) scheme(s2mono)
  graph twoway (scatter TotalVol EIP if Region_1==1), ytitle("Electoral Volatility") title("Western Europe") xtitle(" ") ytitle(" ") legend(off) name(vol_WE, replace) nodraw yscale(range(0 80)) ylabel(0 20 40 60 80, nogrid) xscale(range(0 20)) xlabel(0 5 10 15 20, nogrid) scheme(s2mono)
  graph combine  vol_CEE vol_WE, cols(2) b1("Electoral instability in parties") note("Source for data on electoral volatility: Powell & Tucker (2013)")
  graph save scatter_vol_CEE, replace
  graph use scatter_vol_CEE
  graph export scatter_vol.eps, replace
   

  
  /*Replicates Fig. 2 in Text*/
  /*Generate separate time-series graphs for each of the four countries; then use .combine to generate a single graph*/
  preserve
  keep EIP t country
  keep if country == 21
  duplicates drop
  tsset t
  tsline EIP if country == 21, xtitle(" ") ytitle(" ") title("Belgium") legend(off) yscale(range(0 20)) ylabel(0 5 10 15 20, nogrid)  scheme(s2mono)
  graph save Belgium, replace
  restore

  preserve
  keep EIP t country
  keep if country == 32
  duplicates drop
  tsset t
  tsline EIP if country == 32, xtitle(" ") ytitle(" ") title("Italy") legend(off) yscale(range(0 20)) ylabel(0 5 10 15 20, nogrid)  scheme(s2mono)
  graph save Italy, replace
  restore

  preserve
  keep EIP t country
  keep if country == 83
  duplicates drop
  tsset t
  tsline EIP if country == 83, xtitle(" ") ytitle(" ") title("Estonia") legend(off) yscale(range(0 20)) ylabel(0 5 10 15 20, nogrid) xscale(range(1988 2012)) xlabel(1990 1995 2000 2005 2010, nogrid)  scheme(s2mono)
  graph save Estonia, replace
  restore

  preserve
  keep EIP t country
  keep if country == 92
  duplicates drop
  tsset t
  tsline EIP if country == 92, xtitle(" ") ytitle(" ") title("Poland") legend(off) yscale(range(0 20)) ylabel(0 5 10 15 20, nogrid)  scheme(s2mono)
  graph save Poland, replace
  
  graph combine Belgium.gph Italy.gph Estonia.gph Poland.gph , title("Electoral instability in parties") col(2) scheme(s2mono)
  graph save eip_combined, replace
  graph use eip_combined
  graph export eip_combined.eps, replace
  restore
  
  
  /*Replicates Table A.1, first three columns*/
  sort countryname t_1
  list countryname t_1 t
  
  
  /*Replicates Table A.2 and last column of Table A.1*/
  by countryname, sort: sum EIP
  
  *Replicates Fig. 1 in Text*
  use party_level_data101813.dta, clear
  /*Replicates statistics for Fig. 1*/
  by election, sort: egen pc_new = mean(b001)
  by election: egen pc_disb = mean(b002)
  by election: egen pc_merg = mean(d001)
  by election: egen pc_splt = mean(e001)
  by election: egen pc_jlent = mean(d002)
  by election: egen pc_jlexit = mean(e002)
  
  by Region_1, sort: sum pc_* /*These stats are exported to Fig1.xlsx*/
  
  /*Generating Fig. 1 in Text*/
  import excel Fig1.xlsx, sheet("Sheet1") firstrow clear

  label define Regionl 0 "Central and Eastern Europe" 1 "Western Europe"
  label values Region Regionl
  graph bar new disb merg split entry exit , over(Region) blabel(total) legend(label(1 "New Party") label(2 "Disbanded") label(3 "Merger") label(4 "Splinter") label(5 "Joint list, entry") label(6 "Joint list, exit")) scheme(s2mono)

  graph save barchart, replace
  