cd $outdir/summ

*INDUSTRY (FULL SAMPLE)
use $dtadir/summstats_bld5_largest_dosage_v3.dta, clear
g id=1
keep naic D id
egen tot_firms=total(id)
collapse (sum) id (first) tot_firms, by(naics D)
rename naics2D naics2d
destring naics2d, force replace

 * label industries
   gen indtitle_naics = ""
   qui replace indtitle_naics = "Agriculture, Forestry, Fishing and Hunting" if inlist(naics2d, 11)
   qui replace indtitle_naics = "Mining" if inlist(naics2d, 21)
   qui replace indtitle_naics = "Utilities" if inlist(naics2d, 22)
   qui replace indtitle_naics = "Construction" if inlist(naics2d, 23)
   qui replace indtitle_naics = "Manufacturing" if inlist(naics2d, 31, 32, 33)
   qui replace indtitle_naics = "Wholesale Trade" if inlist(naics2d, 42)
   qui replace indtitle_naics = "Retail Trade" if inlist(naics2d, 44, 45)
   qui replace indtitle_naics = "Transportation and Warehousing" if inlist(naics2d, 48, 49)
   qui replace indtitle_naics = "Information" if inlist(naics2d, 51)
   qui replace indtitle_naics = "Finance and Insurance" if inlist(naics2d, 52)
   qui replace indtitle_naics = "Real Estate Rental and Leasing" if inlist(naics2d, 53)
   qui replace indtitle_naics = "Professional Scientific and Technical Services" if inlist(naics2d, 54)
   qui replace indtitle_naics = "Management of Companies and Enterprises" if inlist(naics2d, 55)
   qui replace indtitle_naics = "Admin, Support, Waste Mgmt, Remediation" if inlist(naics2d, 56)
   qui replace indtitle_naics = "Educational Services" if inlist(naics2d, 61)
   qui replace indtitle_naics = "Health Care and Social Assistance" if inlist(naics2d, 62)
   qui replace indtitle_naics = "Arts, Entertainment, and Recreation" if inlist(naics2d, 71)
   qui replace indtitle_naics = "Accommodation and Food Services" if inlist(naics2d, 72)
   qui replace indtitle_naics = "Other" if inlist(naics2d, 81, 99)

collapse (sum) id , by(indtitle_naics D)

drop if id<10
rename id count
list
export delimited stats_fullsample_ind2D.csv, replace

*INDUSTRY (WINNER)
use $dtadir/summstats_bld5_largest_dosage_v3.dta, clear
keep if winner
g id=1
keep naic D id
egen tot_firms=total(id)
collapse (sum) id (first) tot_firms, by(naics D)
rename naics2D naics2d
destring naics2d, force replace

 * label industries
   gen indtitle_naics = ""
   qui replace indtitle_naics = "Agriculture, Forestry, Fishing and Hunting" if inlist(naics2d, 11)
   qui replace indtitle_naics = "Mining" if inlist(naics2d, 21)
   qui replace indtitle_naics = "Utilities" if inlist(naics2d, 22)
   qui replace indtitle_naics = "Construction" if inlist(naics2d, 23)
   qui replace indtitle_naics = "Manufacturing" if inlist(naics2d, 31, 32, 33)
   qui replace indtitle_naics = "Wholesale Trade" if inlist(naics2d, 42)
   qui replace indtitle_naics = "Retail Trade" if inlist(naics2d, 44, 45)
   qui replace indtitle_naics = "Transportation and Warehousing" if inlist(naics2d, 48, 49)
   qui replace indtitle_naics = "Information" if inlist(naics2d, 51)
   qui replace indtitle_naics = "Finance and Insurance" if inlist(naics2d, 52)
   qui replace indtitle_naics = "Real Estate Rental and Leasing" if inlist(naics2d, 53)
   qui replace indtitle_naics = "Professional Scientific and Technical Services" if inlist(naics2d, 54)
   qui replace indtitle_naics = "Management of Companies and Enterprises" if inlist(naics2d, 55)
   qui replace indtitle_naics = "Admin, Support, Waste Mgmt, Remediation" if inlist(naics2d, 56)
   qui replace indtitle_naics = "Educational Services" if inlist(naics2d, 61)
   qui replace indtitle_naics = "Health Care and Social Assistance" if inlist(naics2d, 62)
   qui replace indtitle_naics = "Arts, Entertainment, and Recreation" if inlist(naics2d, 71)
   qui replace indtitle_naics = "Accommodation and Food Services" if inlist(naics2d, 72)
   qui replace indtitle_naics = "Other" if inlist(naics2d, 81, 99)

collapse (sum) id , by(indtitle_naics D)


drop if id<10
rename id count
list
export delimited stats_winner_ind2D.csv, replace

cd $dodir