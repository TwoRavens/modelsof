
///graphs for the descriptive statistics

version 11.2

capture log close
clear
set mem 20g
log using 
set more off

//local path = "Z:\Localization\"

log using descr_naics6_sept13, text replace

//use "Z:\Localization\loc_master.dta", clear

//change cdf name on employment weighted files
use "Z:\Localization\computations_noweight\computations1990\results\naics6_cdf_90_99_08_09.dta", clear

//dropping unused files
drop kd2009 kd2008 kd1999 kd1990 cdf_2009_1999 cdf_2008_1999 cdf_1999_1990 pdf_2009_1999 pdf_2008_1999 pdf_1999_1990
save "Z:\Localization\computations_noweight\computations1990\results\naics6_cdf_90_99_08_09_r.dta", replace


//change cdf name on employment weighted files
use "Z:\Localization\computations_empweight\computations1990\results\naics6_cdf_emp_90_99_08_09.dta", clear
//dropping unused files
drop kd2009 kd2008 kd1999 kd1990 cdf_2009_1999 cdf_2008_1999 cdf_1999_1990 pdf_2009_1999 pdf_2008_1999 pdf_1999_1990
//changing name
ren  cdf1990 cdf1990_emp
ren cdf1999 cdf1999_emp
ren cdf2008 cdf2008_emp
ren cdf2009 cdf2009_emp
gen id=_n
order id naics dist cdf1990_emp cdf1999_emp cdf2008_emp cdf2009_emp
save "Z:\Localization\computations_empweight\computations1990\results\naics6_cdf_emp_90_99_08_09_r.dta", replace


//change cdf name on sales weighted files
use "Z:\Localization\computations_vstweight\computations1990\results\naics6_cdf_vst_90_99_08_09.dta", clear
//dropping unused files
drop kd2009 kd2008 kd1999 kd1990 cdf_2009_1999 cdf_2008_1999 cdf_1999_1990 pdf_2009_1999 pdf_2008_1999 pdf_1999_1990
//changing name
ren  cdf1990 cdf1990_vst
ren cdf1999 cdf1999_vst
ren cdf2008 cdf2008_vst
ren cdf2009 cdf2009_vst
gen id=_n
order id naics dist cdf1990_vst cdf1999_vst cdf2008_vst cdf2009_vst
save "Z:\Localization\computations_vstweight\computations1990\results\naics6_cdf_vst_90_99_08_09_r.dta", replace

//merging dataset

use "Z:\Localization\computations_noweight\computations1990\results\naics6_cdf_90_99_08_09_r.dta"
gen id=_n
order id naics dist cdf1990 cdf1999 cdf2008 cdf2009
merge 1:1 id using "Z:\Localization\computations_empweight\computations1990\results\naics6_cdf_emp_90_99_08_09_r.dta"
drop _merge

sort id
merge 1:1 id using "Z:\Localization\computations_vstweight\computations1990\results\naics6_cdf_vst_90_99_08_09_r.dta"
drop _merge
sort id

save "Z:\Localization\results\naics6_cdf_90_99_08_09.dta", replace
 
///Generate cdf ratio for different year
gen cdf_emp_count_90= cdf1990_emp/cdf1990
gen cdf_vst_count_90= cdf1990_vst/cdf1990

gen cdf_emp_count_99= cdf1999_emp/cdf1999
gen cdf_vst_count_99= cdf1999_vst/cdf1999

gen cdf_emp_count_08= cdf2008_emp/cdf2008
gen cdf_vst_count_08= cdf2008_vst/cdf2008

gen cdf_emp_count_09= cdf2009_emp/cdf2009
gen cdf_vst_count_09= cdf2009_vst/cdf2009
save "Z:\Localization\results\naics6_cdf_90_99_08_09_1.dta", replace

//making graph ratio for employment and sales weighted by distance
use "Z:\Localization\results\naics6_cdf_90_99_08_09_1.dta", replace

//graph ratio of average CDF_emp and average CDF_sales vs average CDF_count by distance

//year 1990
preserve 
collapse cdf_emp_count_90 cdf_vst_count_90 naics, by(dist)
//twoway (line cdf_emp_count_90 dist, lcolor(red))
twoway (line cdf_emp_count_90 dist, lcolor(black)) (line cdf_vst_count_90 dist, lcolor(red))
graph save "Z:\Localization\results\graph\graph_ratio_90", replace
restore

//median
preserve 
collapse(median) cdf_emp_count_90 cdf_vst_count_90 naics, by(dist)
//twoway (line cdf_emp_count_90 dist, lcolor(red))
twoway (line cdf_emp_count_90 dist, lcolor(black)) (line cdf_vst_count_90 dist, lcolor(red))
graph save "Z:\Localization\results\graph\graph_ratio_90_median", replace
restore

//percentiles p10
preserve 
collapse(p10) cdf_emp_count_90 cdf_vst_count_90 naics, by(dist)
twoway (line cdf_emp_count_90 dist, lcolor(black)) (line cdf_vst_count_90 dist, lcolor(red))
graph save "Z:\Localization\results\graph\graph_ratio_90_p10", replace
restore

//percentiles p90
preserve 
collapse(p2) cdf_emp_count_90 cdf_vst_count_90 naics, by(dist)
twoway (line cdf_emp_count_90 dist, lcolor(black)) (line cdf_vst_count_90 dist, lcolor(red))
graph save "Z:\Localization\results\graph\graph_ratio_90_p2", replace
restore

//year 1999

preserve 
collapse cdf_emp_count_99 cdf_vst_count_99 naics, by(dist)
twoway (line cdf_emp_count_99 dist, lcolor(black)) (line cdf_vst_count_99 dist, lcolor(red))
graph save "Z:\Localization\results\graph\graph_ratio_99", replace
restore
 

//median
preserve
collapse(median) cdf_emp_count_99 cdf_vst_count_99 naics, by(dist)
twoway (line cdf_emp_count_99 dist, lcolor(black)) (line cdf_vst_count_99 dist, lcolor(red))
graph save "Z:\Localization\results\graph\graph_ratio_99_median", replace
restore

//percentiles p10
preserve 
collapse(p10) cdf_emp_count_99 cdf_vst_count_99 naics, by(dist)
twoway (line cdf_emp_count_99 dist, lcolor(black)) (line cdf_vst_count_99 dist, lcolor(red))
graph save "Z:\Localization\results\graph\graph_ratio_99_p10", replace
restore
preserve 

//p90
collapse(p90) cdf_emp_count_99 cdf_vst_count_99 naics, by(dist)
twoway (line cdf_emp_count_99 dist, lcolor(black)) (line cdf_vst_count_99 dist, lcolor(red))
graph save "Z:\Localization\results\graph\graph_ratio_99_p90", replace
restore

//year 2008

preserve 
collapse cdf_emp_count_08 cdf_vst_count_08 naics, by(dist)
twoway (line cdf_emp_count_08 dist, lcolor(black)) (line cdf_vst_count_08 dist, lcolor(red))
graph save "Z:\Localization\results\graph\graph_ratio_08", replace
restore

//median
preserve 
collapse (median) cdf_emp_count_08 cdf_vst_count_08 naics, by(dist)
twoway (line cdf_emp_count_08 dist, lcolor(black)) (line cdf_vst_count_08 dist, lcolor(red))
graph save "Z:\Localization\results\graph\graph_ratio_08_median", replace
restore


//percentiles p10
preserve 
collapse (p10) cdf_emp_count_08 cdf_vst_count_08 naics, by(dist)
twoway (line cdf_emp_count_08 dist, lcolor(black)) (line cdf_vst_count_08 dist, lcolor(red))
graph save "Z:\Localization\results\graph\graph_ratio_08_p10", replace
restore

//p90
preserve 
collapse (p2) cdf_emp_count_08 cdf_vst_count_08 naics, by(dist)
twoway (line cdf_emp_count_08 dist, lcolor(black)) (line cdf_vst_count_08 dist, lcolor(red))
graph save "Z:\Localization\results\graph\graph_ratio_08_p2", replace
restore

//year 2009

preserve 
collapse cdf_emp_count_09 cdf_vst_count_09 naics, by(dist)
twoway (line cdf_emp_count_09 dist, lcolor(black)) (line cdf_vst_count_09 dist, lcolor(red))
graph save "Z:\Localization\results\graph\graph_ratio_09", replace
restore

//median
preserve 
collapse (median) cdf_emp_count_09 cdf_vst_count_09 naics, by(dist)
twoway (line cdf_emp_count_09 dist, lcolor(black)) (line cdf_vst_count_09 dist, lcolor(red))
graph save "Z:\Localization\results\graph\graph_ratio_09_median", replace
restore

///percentiles
//p10
preserve 
collapse (p10) cdf_emp_count_09 cdf_vst_count_09 naics, by(dist)
twoway (line cdf_emp_count_09 dist, lcolor(black)) (line cdf_vst_count_09 dist, lcolor(red))
graph save "Z:\Localization\results\graph\graph_ratio_09_p10", replace
restore

//p90
preserve 
collapse (p90) cdf_emp_count_09 cdf_vst_count_09 naics, by(dist)
twoway (line cdf_emp_count_09 dist, lcolor(black)) (line cdf_vst_count_09 dist, lcolor(red))
graph save "Z:\Localization\results\graph\graph_ratio_09_p90", replace
restore

clear


///
//making graph ratio for employment and sales weighted by year
use "Z:\Localization\NAICS6_panel\cdf_emp_rhs.dta", clear
//generate CDF at 10 km emp weighted data
preserve
gen id=_n 
keep id year naics cdf10 cdf25 cdf50 cdf100 cdf200 cdf500 cdf800
ren cdf10 cdf10_emp
ren cdf25 cdf125_emp
ren cdf50 cdf50_emp
ren cdf100 cdf100_emp
ren cdf200 cdf200_emp
ren cdf500 cdf500_emp
ren cdf800 cdf800_emp

save "F:\graph\cdf_emp_rhs1.dta", replace
restore


//generate CDF at 10 km, sales weighted data
use "Z:\Localization\NAICS6_panel\cdf_vst_rhs.dta", clear
preserve
gen id=_n 
keep id year naics cdf10 cdf25 cdf50 cdf100 cdf200 cdf500 cdf800
ren cdf10 cdf10_vst
ren cdf25 cdf125_vst
ren cdf50 cdf50_vst
ren cdf100 cdf100_vst
ren cdf200 cdf200_vst
ren cdf500 cdf500_vst
ren cdf800 cdf800_vst
save "F:\graph\cdf_vst_rhs1.dta", replace
restore

//merging dataset

use "Z:\Localization\NAICS6_panel\cdf_rhs.dta", clear
preserve
gen id=_n 
keep id year naics cdf10 cdf25 cdf50 cdf100 cdf200 cdf500 cdf800
ren cdf10 cdf10_count
ren cdf25 cdf125_count
ren cdf50 cdf50_count
ren cdf100 cdf100_count
ren cdf200 cdf200_count
ren cdf500 cdf500_count
ren cdf800 cdf800_count

merge 1:1 id using "F:\graph\cdf_emp_rhs1.dta"
drop _merge

sort id
merge 1:1 id using "F:\graph\cdf_vst_rhs1.dta"
drop _merge
sort id
save "F:\graph\cdf_rhs_2.dta", replace
restore


use "F:\graph\cdf_rhs_2.dta", clear
preserve
destring naics, replace
//generate CDF ratio 
///Generate cdf ratio for different year
/////distance of 10km
gen cdf10_emp_count=cdf10_emp/cdf10_count
gen cdf10_vst_count=cdf10_vst/cdf10_count
su cdf10_vst_count cdf10_emp_count

collapse cdf10_emp_count cdf10_vst_count naics, by(year)
twoway (line cdf10_emp_count year, lcolor(black))(line cdf10_vst_count year, lcolor(red))
graph save "Z:\Localization\results\graph\graph_ratio_year", replace

//median
use "F:\graph\cdf_rhs_2.dta", clear
preserve
destring naics, replace
//generate CDF ratio 
///Generate cdf ratio for different year
gen cdf10_emp_count=cdf10_emp/cdf10_count
gen cdf10_vst_count=cdf10_vst/cdf10_count
su cdf10_vst_count cdf10_emp_count

collapse (median) cdf10_emp_count cdf10_vst_count naics, by(year)
twoway (line cdf10_emp_count year, lcolor(black))(line cdf10_vst_count year, lcolor(red))
graph save "Z:\Localization\results\graph\graph_ratio_year_", replace


//percentiles
use "F:\graph\cdf_rhs_2.dta", clear
preserve
destring naics, replace
//generate CDF ratio 
///Generate cdf ratio for different year
gen cdf10_emp_count=cdf10_emp/cdf10_count
gen cdf10_vst_count=cdf10_vst/cdf10_count
su cdf10_vst_count cdf10_emp_count

collapse (p10) cdf10_emp_count cdf10_vst_count naics, by(year)
twoway (line cdf10_emp_count year, lcolor(black))(line cdf10_vst_count year, lcolor(red))
graph save "Z:\Localization\results\graph\graph_ratio_year_p10", replace



/////distance of 500km

use "F:\graph\cdf_rhs_2.dta", clear
preserve
destring naics, replace
gen cdf500_emp_count=cdf500_emp/cdf500_count
gen cdf500_vst_count=cdf500_vst/cdf500_count
su cdf500_vst_count cdf500_emp_count

collapse cdf500_emp_count cdf500_vst_count naics, by(year)
twoway (line cdf500_emp_count year, lcolor(black))(line cdf500_vst_count year, lcolor(red))
graph save "Z:\Localization\results\graph\graph_ratio_year_500km", replace



/////unit transport cost by industry

//Exemple, Graph at 10km distance

//unweighted case
//recall the percentage change cdf variable 
clear all
use "F:\temp\naics6_pccdf.dta"
keep if dist==10
keep  naics cdf1990 cdf1999 cdf2008 cdf2009 pccdf_1999_1990 pccdf_2008_1999 pccdf_2009_1999
merge 1:1 naics using "F:\temp\pc_av_klems.dta"
drop _merge

//identifying outlayers
scatter av_klems_90_99  pccdf_1999_1990, mlabel(naics)
//Excluding naics 315299 and naics 334110

twoway (scatter av_klems_90_99  pccdf_1999_1990 if naics!=315299 & naics!=334110)
graph save "Z:\Localization\results\graph\Graph_pcccdf_transport_90-99_10km", replace

twoway (scatter av_klems_99_08  pccdf_2008_1999 if naics!=312210 & naics!=3152232 & naics!=334110)
graph save "Z:\Localization\results\graph\Graph_pcccdf_transport_99-08_10km", replace
scatter av_klems_99_08  pccdf_2008_1999 if naics!=3152232 & naics!=334110, mlabel(naics)
//employment weighted case

//recall the percentage change cdf variable employment weighted
clear all
use "F:\temp\naics6_pccdf_emp.dta"
keep if dist==10
keep  naics cdf1990 cdf1999 cdf2008 cdf2009 pccdf_1999_1990 pccdf_2008_1999 pccdf_2009_1999
merge 1:1 naics using "F:\temp\pc_av_klems.dta"
drop _merge

//identifying outlayers
scatter av_klems_90_99  pccdf_1999_1990, mlabel(naics)
//Excluding naics 315299 and naics 334110
twoway (scatter av_klems_90_99  pccdf_1999_1990 if naics!=315299 & naics!=334110)
graph save "Z:\Localization\results\graph\Graph_emp_pcccdf_transport_90-99_10km", replace

//identifying outlayers
scatter av_klems_99_08  pccdf_2008_1999, mlabel(naics)
//Excluding naics 315232 and naics 334110
twoway (scatter av_klems_99_08  pccdf_2008_1999 if naics!=315232 & naics!=334110)
graph save "Z:\Localization\results\graph\Graph_emp_pcccdf_transport_99-08_10km", replace

//recall the percentage change cdf variable sales weighted
clear all
use "F:\temp\naics6_pccdf_vst.dta"
keep if dist==100
keep  naics cdf1990 cdf1999 cdf2008 cdf2009 pccdf_1999_1990 pccdf_2008_1999 pccdf_2009_1999
merge 1:1 naics using "F:\temp\pc_av_klems.dta"
drop _merge

//identifying outlayers
scatter av_klems_90_99  pccdf_1999_1990, mlabel(naics)

//Excluding naics 315299 and naics 334110
twoway (scatter av_klems_90_99  pccdf_1999_1990 if naics!=315299 & naics!=334110)
graph save "Z:\Localization\results\graph\Graph_vst_pcccdf_transport_90-99_10km", replace

//identifying outlayers
scatter av_klems_99_08  pccdf_2008_1999, mlabel(naics)
//Excluding naics 315232 and naics 334110
twoway scatter av_klems_99_08  pccdf_2008_1999 if naics!=315232 & naics!=334110
graph save "Z:\Localization\results\graph\Graph_vst_pcccdf_transport_99-08_10km", replace


///specific graphs ratio 

use "F:\temp\data_table.dta", clear

//above and below the entry and exit ratio
twoway (line above_med_exit below_med_exit year) (line  above_med_entry below_med_entry year)
graph save Graph "Z:\Localization\results\graphs\graph_entry_exit_year.gph", replace

//unit transport cost 
twoway (line above_med_transport_cost below_med_transport_cost year)
 graph save Graph "Z:\Localization\results\graphs\graph_transp_year.gph", replace

//high vs low tech 
twoway (line hightech lowtech year)
graph save Graph "Z:\Localization\results\graphs\graph_hightech_year.gph", replace

 
 // import and export intensity ratio
////sales
twoway (line above_med_import_int_s below_med_import_int_s year) (line above_med_export_int_s below_med_export_int_s year)
graph save Graph "Z:\Localization\results\graphs\graph_M_X_intensity_sales_year.gph", replace

twoway (line above_med_import_int_s below_med_import_int_s year)
graph save Graph "Z:\Localization\results\graphs\graph_M_intensity_sales_year.gph", replace

gen ratio_m=below_med_import_int_s/above_med_import_int_s
twoway (line ratio_m year)
graph save Graph "Z:\Localization\results\graphs\graph_ratio_M_intensity_sales_year.gph", replace


twoway (line above_med_export_int_s below_med_export_int_s year)
graph save Graph "Z:\Localization\results\graphs\graph_X_intensity_sales_year.gph", replace

gen ratio_m=below_med_import_int_s/above_med_import_int_s


////value added
twoway (line above_med_import_int_va below_med_import_int_va year) (line above_med_export_int_va below_med_export_int_va year)
graph save Graph "Z:\Localization\results\graphs\graph_M_X_intensity_va_year.gph", replace

//OECD sector
twoway (line naturalresource productdifferentiated year) (line labourintensive scalebased sciencebased year)
graph save Graph "Z:\Localization\results\graphs\graph_oecd_year.gph", replace

//twoway (line naturalresource labourintensive year) 
//graph save Graph "Z:\Localization\results\graphs\graph_cdf_labornrs_year.gph", replace

//twoway (line naturalresource year)
//graph save Graph "Z:\Localization\results\graphs\graph_cdf_nrs_year.gph", replace

//R&D intensity

twoway (line  above_med_rd_va below_med_rd_va year) (line above_med_rd_sales below_med_rd_sales year)
graph save Graph "Z:\Localization\results\graphs\graph_RD_intensity_year_full.gph", replace

//R&D intensity to sales only

twoway (line above_med_rdl_sales below_med_rdl_sales year)
graph save Graph "Z:\Localization\results\graphs\graph_RD_intensity_year_sales.gph", replace


////Smooth R&D intensity

twoway (line above_med_rds_va below_med_rd_va year) (line above_med_rds_sales below_med_rds_sales year)
graph save Graph "Z:\Localization\results\graphs\graph_RDS_intensity_year_full.gph", replace

////IO-Linkages
twoway (line above_med_l_odist_n5i below_med_l_odist_n5i year)
graph save Graph "Z:\Localization\results\graphs\graph_0_linkages_year.gph", replace

twoway (line above_med_l_idist_n5i below_med_l_idist_n5i year)
graph save Graph "Z:\Localization\results\graphs\graph_I-linkages_year.gph", replace


////labour pooling (nprdprd)
twoway (line  above_med_ifqh3shr below_med_ifqh3shr year) 
graph save Graph "Z:\Localization\results\graphs\graph_labor_year.gph", replace

//natural resource based industries

twoway (line  above_med_nrs below_med_nrs year)
graph save Graph "Z:\Localization\results\graphs\graph_cdf_nrs_year.gph", replace

///graph average IO, transport and trade by year

use "\\ead02\ead_uquam\Localization\NAICS6_panel\cdf_rhs", clear


//average IO linkages n5
preserve 
collapse (mean)  export_tot import_tot l_idist_n3 l_odist_n3 l_idist_n5 l_odist_n5 av_klems l_idist_n7 l_odist_n7 l_idist_n10 l_odist_n10 l_idist_n3i l_odist_n3i l_idist_n5i l_odist_n5i l_idist_n7i l_odist_n7i l_idist_n10i l_odist_n10i, by(year)
twoway (line l_idist_n5i l_odist_n5i year, lcolor(black))
graph save "Z:\Localization\results\graph\graph_IO_linkages_year", replace
restore

preserve 
collapse (mean) export_tot import_tot l_idist_n3 l_odist_n3 l_idist_n5 l_odist_n5 av_klems l_idist_n7 l_odist_n7 l_idist_n10 l_odist_n10 l_idist_n3i l_odist_n3i l_idist_n5i l_odist_n5i l_idist_n7i l_odist_n7i l_idist_n10i l_odist_n10i, by(year)
twoway (line av_klems year, lcolor(black))
graph save "Z:\Localization\results\graph\graph_transport_year", replace
restore


preserve 
collapse (mean) export_tot import_tot l_idist_n3 l_odist_n3 l_idist_n5 l_odist_n5 av_klems l_idist_n7 l_odist_n7 l_idist_n10 l_odist_n10 l_idist_n3i l_odist_n3i l_idist_n5i l_odist_n5i l_idist_n7i l_odist_n7i l_idist_n10i l_odist_n10i, by(year)
twoway (line import_tot export_tot year, lcolor(black))
graph save "Z:\Localization\results\graph\graph_trade_year", replace
restore

log close
