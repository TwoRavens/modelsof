Ignore the information encapsulated by /**/ and run the code after in order to replicate the files
/*
set more off
forvalues i=1890(10)1930 {
	use "/Users/rramcharan/Research/Inequality and Schooling/Master Data/census_tiebout_weather_elevation_political_spatial_long.dta", clear
	ivreg2 st_icg (st_giniy=st_totrain_anstd st_growdegdys_anstd)  NS st_ttlpy state_area region if year==`i' ,r  liml 
	predict e`i' if e(sample)
	keep e`i' st_icg st_giniy st_totrain_anstd st_growdegdys_anstd NS st_ttlpy state_area region 
	drop if e`i'==. 
	drop e`i'
	save Table_12_A`i'.dta, replace  
	outsheet using Table_12_A`i'.raw, replace  
} 

set more off
forvalues i=1890(10)1930 {
	use "/Users/rramcharan/Research/Inequality and Schooling/Master Data/census_tiebout_weather_elevation_political_spatial_long.dta", clear
	ivreg2 st_pdg (st_giniy=st_totrain_anstd st_growdegdys_anstd)  NS st_ttlpy state_area region if year==`i' ,r  liml 
	predict e`i' if e(sample)
	keep e`i' st_pdg st_giniy st_totrain_anstd st_growdegdys_anstd  NS st_ttlpy state_area region 
	drop if e`i'==. 
	drop e`i'
	save Table_12_B`i'.dta, replace 
	outsheet using Table_12_B`i'.raw, replace
}  

set more off
foreach v in  st_atp_log st_slxp_log st_slwp_log st_sexp_log {
	use "/Users/rramcharan/Research/Inequality and Schooling/Master Data/census_tiebout_weather_elevation_political_spatial_long.dta", clear
	ivreg2 `v'  (st_comp_cong_absy =st_totrain_anstd st_growdegdys_anstd) st_ttlpy state_area region if year==1900 ,r first  
	predict e`v' if e(sample) 
	keep `v'  e`v' st_comp_cong_absy st_totrain_anstd st_growdegdys_anstd st_ttlpy state_area region
    drop if e`v'==.
	drop e`v'
	save "Table13_`v'1900.dta", replace 
	outsheet using "Table13_`v'1900.raw", replace 
} 

set more off
foreach v in st_slxp_log st_slwp_log st_sexp_log {
	use "/Users/rramcharan/Research/Inequality and Schooling/Master Data/census_tiebout_weather_elevation_political_spatial_long.dta", clear
	ivreg2 `v'  (st_icg=st_totrain_anstd st_growdegdys_anstd) st_ttlpy state_area region if year==1910 ,r first  
    predict e`v' if e(sample) 
    keep `v' e`v' st_icg st_totrain_anstd st_growdegdys_anstd st_ttlpy state_area region
	drop if e`v'==.
	drop e`v' 
save "Table13_`v'1910.dta", replace   
outsheet using "Table13_`v'1910.raw", replace 
} 
*/
*************************************run code from here
*Table 12

set more off
forvalues i=1890(10)1930 {
	insheet using Table_12_A`i'.raw, clear
	ivreg2 st_icg (st_giniy=st_totrain_anstd st_growdegdys_anstd)  ns st_ttlpy state_area region  ,r  liml 
 }
set more off
forvalues i=1890(10)1930 {
	insheet using Table_12_B`i'.raw, clear
	ivreg2 st_pdg (st_giniy=st_totrain_anstd st_growdegdys_anstd)  ns st_ttlpy state_area region ,r  liml 
}

*Table 13
set more off
foreach v in  st_atp_log st_slxp_log st_slwp_log st_sexp_log {
	insheet using "Table13_`v'1900.raw", clear 
	ivreg2 `v'  (st_comp_cong_absy =st_totrain_anstd st_growdegdys_anstd) st_ttlpy state_area region ,r first  
}
set more off
foreach v in st_slxp_log st_slwp_log st_sexp_log {
	insheet using "Table13_`v'1910.raw", clear 
	ivreg2 `v'  (st_icg=st_totrain_anstd st_growdegdys_anstd) st_ttlpy state_area region ,r first  
}





