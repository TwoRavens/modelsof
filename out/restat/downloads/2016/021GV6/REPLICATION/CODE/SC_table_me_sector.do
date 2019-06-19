

clear
foreach country in argentina brazil chile colombia usa usa_all usa1 usa2 usa3 usa5 usa_all_q1 usa_all_q2 usa_all_q3 usa_all_q4 usa_all_q5 usa_all_sec100 usa_all_sec200 usa_all_sec300 usa_all_sec400 usa_all_sec500 usa_all_sec600 usa_all_sec800  usa_all_sec900  usa_all_sec1200   {
global database `country'
capture use ${dir_tables}\table_${sales}_${database}.dta
merge 1:1 name using "${dir_tables}\table_${sales}_${database}.dta", keepusing(${database})
drop _merge
}
gen source="online"
save "${dir_tables}\table_${sales}.dta", replace
