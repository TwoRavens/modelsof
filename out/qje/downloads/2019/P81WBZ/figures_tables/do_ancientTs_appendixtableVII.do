clear
capture log close
/***************************************/
cd ..
import delimited "analysis/tables/tobler_weinburg/report_table_whitese_naive.csv", encoding(ISO-8859-1) // naive gravity location estimates using a distance elasticity of -2 and mentions as city size

keep name varphi_est lambda_est mentions
rename name anccity
rename varphi_est long_x // Estimated coordinates for lost cities, known coordinates for others.
rename lambda_est lat_y
gen validity = .
replace validity = 0 if lat_y!=.
save temp.dta,replace

clear
import delimited "estimate/results/ancient/v20170924/twostep/noc/qa01Dropma02Known/main/report_table_twostepse.csv", encoding(ISO-8859-1)
keep if lambda_se == 0
keep name varphi_est lambda_est validity
rename name anccity
rename varphi_est long_x_known // Estimated coordinates for lost cities, known coordinates for others.
rename lambda_est lat_y_known 

merge 1:1  anccity using temp
replace long_x = long_x_known if long_x==.
replace lat_y = lat_y_known if lat_y==.

drop long_x_known lat_y_known _merge

rename long_x long_x
rename lat_y lat_y

rename mentions T_anc
keep anccity T_anc validity
/***************************************/
erase temp.dta
cd "figures_tables"



