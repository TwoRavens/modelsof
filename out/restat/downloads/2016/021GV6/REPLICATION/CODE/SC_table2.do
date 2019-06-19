
clear
foreach country in argentina brazil chile colombia usa_all usa1 usa2 usa3 usa5 {
global database `country'
capture use ${dir_tables}\table_${sales}_${database}.dta
merge 1:1 name using "${dir_tables}\table_${sales}_${database}.dta", keepusing(${database})
drop _merge
}


* ******Round numerical variables
*Millions
foreach database in argentina brazil chile colombia usa_all usa1 usa2 usa3 usa5 {
replace `database'=round(`database'/1000000,1) if name=="unique_obs_nonmiss"

*2 decimal places for the rest
replace `database'=round(`database',1)

*Now make string and dates format
tostring `database', gen(s_`database') force usedisplayformat

*dates
replace s_`database'=string(`database',"%tdNN/DD/YY") if name=="maxdate"
replace s_`database'=string(`database',"%tdNN/DD/YY") if name=="mindate"


}


*Keep only the variables that you want to show
gen keep=.
replace keep=1 if inlist(name,"unique_obs_nonmiss", "unique_id", "mindate", "maxdate", "periods", "unique_category", "unique_cat_url", "share_obs_w_sales", "share_prod_w_sales")==1
replace keep=1 if inlist(name,"median_life", "share_obs_missing")==1
keep if keep==1

*Export as latex table
gen order=.
replace order=1 if name=="unique_obs_nonmiss"
replace name="Total Observations (Millions)" if name=="unique_obs_nonmiss"
replace order=2 if name=="unique_id"
replace name="Total Products" if name=="unique_id"
replace order=3 if name=="mindate"
replace name="Initial Date" if name=="mindate"
replace order=4 if name=="maxdate"
replace name="Final Date" if name=="maxdate"
replace order=5 if name=="periods"
replace name="Days" if name=="periods"
replace order=6 if name=="unique_category"
replace name="Categories" if name=="unique_category"
replace order=7 if name=="unique_cat_url"
replace name="Urls" if name=="unique_cat_url"
replace order=8 if name=="share_obs_w_sales"
replace name="Obs. with Sales (% of total)" if name=="share_obs_w_sales"
replace order=9 if name=="share_prod_w_sales"
replace name="Products with Sales (% of total)" if name=="share_prod_w_sales"
replace order=10 if name=="median_life"
replace name="Median Life of Products (days)" if name=="median_life"
replace order=11 if name=="share_obs_missing"
replace name="Missing Obs (\%}" if name=="share_obs_missing"

sort order



label var name ""
label var s_argentina "Argentina"
label var s_brazil "Brazil"
label var s_chile "Chile"
label var s_colombia "Colombia"
label var s_usa_all "USAALL"
label var s_usa1 "USA1"
label var s_usa2 "USA2"
label var s_usa3 "USA3"
label var s_usa5 "USA5"


global typeofsales ""
if "${sales}"=="nsfull" {
global typeofsales " - Regular Prices"
}

**Table can compile by itself
foreach frag in "" "frag" {
texsave name  s_usa_all s_argentina  s_brazil s_chile  s_colombia   using ${dir_tables}\table2_${sales}`frag'.tex , align(lCCCCC) title("Database Description ${typeofsales}") size(small) location(h)  marker(tab:datadesc)  footnote("Note: Preliminary Results",  size(footnotesize) align(l))  varlabels  replace width(\linewidth)  `frag'
}

**Table can compile by itself
foreach frag in "" "frag" {
texsave name  s_usa1 s_usa2 s_usa3 s_usa5 using ${dir_tables}\table2_usa_${sales}`frag'.tex , align(lCCCC) title("Database Description ${typeofsales}") size(small) location(h)  marker(tab:datadesc)  footnote("Note: Preliminary Results",  size(footnotesize) align(l))  varlabels  replace width(\linewidth)  `frag'
}


**FINAL TABLE
foreach frag in "" "frag" {
texsave name  s_usa_all s_argentina  s_brazil s_chile  s_colombia using ${dir_tables}\table2_final_${sales}`frag'.tex , align(lCCCCC) title("Database Description ${typeofsales}") size(small) location(h)  marker(tab:datadesc)  footnote("Note: Preliminary Results",  size(footnotesize) align(l))  varlabels  replace width(\linewidth)  `frag'
}
