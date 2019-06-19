

clear
foreach country in argentina brazil chile colombia usa_all usa1 usa2 usa3 usa5 {
global database `country'
capture use ${dir_tables}\table_${sales}_${database}.dta
merge 1:1 name using "${dir_tables}\table_${sales}_${database}.dta", keepusing(${database})
drop _merge
}
gen source="online"
save "${dir_tables}\table_${sales}.dta", replace

*Simulated Data - add source to each individual files
foreach simulation in cpi_bppcat cpi_url weekly_average cpi_month weekly cpi_month_1 cpi_month_30 {
foreach country in argentina brazil chile colombia usa_all usa1 usa2 usa3 usa5 {
global country `country'
global simulation `simulation'
global database ${simulation}_${sales}_${country}
display "Starting $database"
use ${dir_tables}\table_${sales}_${database}.dta, clear
ren ${database} ${country}
gen source="${simulation}_${sales}"
replace source="${simulation}_${sales}"
save "${dir_tables}\table_${sales}_${database}_ws.dta", replace
}
}

*now merge simulated data
clear
foreach simulation in cpi_bppcat cpi_url weekly_average cpi_month weekly cpi_month_1 cpi_month_30 {
clear
foreach country in argentina brazil chile colombia usa_all usa1 usa2 usa3 usa5 {
global simulation `simulation'
global country `country'
global database ${simulation}_${sales}_${country}
display "Starting $database"
capture use ${dir_tables}\table_${sales}_${database}_ws.dta
 merge 1:1 name source using "${dir_tables}\table_${sales}_${database}_ws.dta"
 drop _merge
}

save "${dir_tables}\table_${sales}_${simulation}.dta", replace
}

*now merge them all
clear
append using "${dir_tables}\table_${sales}.dta"
foreach simulation in cpi_bppcat cpi_url weekly_average cpi_month weekly cpi_month_1 cpi_month_30 {
append using "${dir_tables}\table_${sales}_`simulation'.dta"
}

duplicates drop

* ******Round numerical variables
*Millions
foreach database in argentina brazil chile colombia usa_all usa1 usa2 usa3 usa5 {
* replace `database'=round(`database'/1000000,1) if name=="unique_obs_nonmiss"

*2 decimal places for the rest
replace `database'=round(`database',.01)

* *Now make string and dates format
* tostring `database', gen(s_`database') force usedisplayformat

*dates
* replace s_`database'=string(`database',"%tdNN/DD/YY") if name=="maxdate"
* replace s_`database'=string(`database',"%tdNN/DD/YY") if name=="mindate"


}



*Export as latex table
gen order=.
replace order=1 if source=="online"
replace order=2 if source=="weekly_${sales}"
replace order=3 if source=="cpi_month_${sales}"
replace order=4 if source=="weekly_average_${sales}"
replace order=5 if source=="cpi_bppcat_${sales}"
replace order=6 if source=="cpi_month_1_${sales}"

sort name order
order name source 

* *Keep only the variables that you want to show
gen keep=.
replace keep=1 if inlist(name,"implied_dur_months_wmedian", "implied_duration_months", "mean_abs_gr_mprice", "share_obs_w_sales", "share_prod_w_sales")==1
replace keep=1 if inlist(name,"implied_duration_months", "mean_abs_gr_mprice", "share_under_1", "share_under_5")==1

keep if keep==1

*drop the ones you are not using
*drop if source=="cpi_url_${sales}" 
*drop if source=="online" 

*Table
label var name "Statistic"
label var source "Source"
label var argentina "Argentina"
label var brazil "Brazil"
label var chile "Chile"
label var colombia "Colombia"
label var usa_all "USA"
label var usa1 "USA1"
label var usa2 "USA2"
label var usa3 "USA3"
label var usa4 "USA4"
label var usa5 "USA5"

replace name="Duration (months)" if name=="implied_duration_months"
replace name="Changes below 1% " if name=="share_under_1"
replace name="Change below 5%" if name=="share_under_5"
replace name="Obs. with Sales" if name=="share_obs_w_sales"
replace name="Prod. with Sales" if name=="share_prod_w_sales"
replace name="Mean Abs. Size" if name=="mean_abs_gr_mprice"
replace source="Daily Online Data" if source=="online"
replace source="Weekly Online Data" if source=="weekly_${sales}"
replace source="Monthly Online Data" if source=="cpi_month_${sales}"
replace source="Simulated Weekly Average" if source=="weekly_average_${sales}"
replace source="Simulated CPI Imputation" if source=="cpi_bppcat_${sales}"
replace source="Simulated CPI Imputation (narrow)" if source=="cpi_url_${sales}"



global typeofsales ""
if "${sales}"=="nsfull" {
global typeofsales " - Regular Prices"
}


*ALL VARIABLES

* **Table can compile by itself and frag (to put via \input in latex)
foreach frag in "" "frag" {
texsave name source usa_all argentina brazil chile colombia using ${dir_tables}\table_me_${sales}`frag'.tex , align(lrCCCCC) title("Stickiness Statistics  and Measurement Error  ${typeofsales}") size(small) location(h)  marker(tab:datadesc)  footnote("Note:",  size(footnotesize) align(l))  varlabels  replace width(\textwidth)  `frag'
}

* **Table can compile by itself and frag (to put via \input in latex)
foreach frag in "" "frag" {
texsave name source usa_all usa1 usa2 usa3  usa5  using ${dir_tables}\table_me_usa_${sales}`frag'.tex , align(lrCCCCCC) title("Stickiness Statistics  and Measurement Error  ${typeofsales}") size(small) location(h)  marker(tab:datadesc)  footnote("Note:",  size(footnotesize) align(l))  varlabels  replace width(\textwidth)  `frag'
}

****Robustness - diffferent days of week/month
preserve
keep if source=="cpi_month_1_${sales}" | source=="Monthly Online Data" | source=="cpi_month_30_${sales}"
replace source="Monthly Online Data (day 1)" if source=="cpi_month_1_${sales}"
replace source="Monthly Online Data (day 15)" if source=="Monthly Online Data"
replace source="Monthly Online Data (day 30)" if source=="cpi_month_30_${sales}"

sort name source

* **Table can compile by itself and frag (to put via \input in latex)
foreach frag in "" "frag" {
texsave name source usa_all argentina brazil chile colombia using ${dir_tables}\table_me_monthday_${sales}`frag'.tex , align(lrCCCCC) title("Stickiness Statistics  and Measurement Error  ${typeofsales}") size(small) location(h)  marker(tab:datadesc)  footnote("Note:",  size(footnotesize) align(l))  varlabels  replace width(\textwidth)  `frag'
}
restore
