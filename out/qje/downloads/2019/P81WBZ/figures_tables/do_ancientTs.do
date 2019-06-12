// Retrieve T's from estimated alpha's. Generates city sizes reported in table 3 and used in figures 10-12
clear

/*******************************/
// Load estimated ancient city T's
/*******************************/
cd ..
import delimited "estimate/results/ancient/v20170924/twostep/noc/qa01Dropma02Known/main/report_table_twostepse.csv", encoding(ISO-8859-1)
cd "figures_tables"

rename name anccity
/*************************************/
/* Estimated coordinates (baseline)  */
/*************************************/
capture drop long_x lat_y
rename varphi_est long_x
rename lambda_est lat_y 

/*************************************/
gen  sigma = 2*sigma_est_se[1] // estimate of sigma (zeta in notes)

drop sigma_est_se

save temp_results.dta,replace

rename anccity anccity_o
rename long_x long_x_o
rename lat_y lat_y_o
rename alpha alpha_o

cross using temp_results
rename long_x long_x_d
rename lat_y lat_y_d
rename alpha alpha_d
rename anccity anccity_d

// Distance
*vincenty lat_y_o long_x_o lat_y_d long_x_d , h(dist2) inkm
 // if vincenty package is not available, use latitude adjusted Euclidean formula:
gen dist = sqrt((cos(37.9/180*_pi)*(long_x_o-long_x_d))^2  + (lat_y_o-lat_y_d)^2)
replace dist = dist*10000/90

replace dist = 30 if anccity_o == anccity_d // internal distance. see text footnote 8.

// 
sort anccity_o anccity_d
drop lat* long*

gen theta = 4

gen Tsum_o = dist^(-sigma) * alpha_d  //*(1/numcity) //because we will sum over anccity_o below

collapse (sum) Tsum_o (mean) theta alpha_o , by(anccity_o)
 
gen T_anc =  ( alpha_o^(1+1/theta) * Tsum_o) // ^theta

rename anccity_o anccity
sort  anccity

keep anccity T_anc

// Normalize wrt Kanes
gen T_anc_norm = .
replace T_anc_norm = T_anc if anccity=="Kanes"
sort T_anc_norm
replace T_anc_norm = T_anc_norm[_n-1] if T_anc_norm==.
replace T_anc = 100* T_anc / T_anc_norm
sort anccity
drop T_anc_norm

erase temp_results.dta
