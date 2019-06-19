*-----------------------------------------------------------------------------------------------------------------------------*
* This do file constructs Table A1 of the web appendix of Berman and Couttenier (2014)										  *
* This version: january 29, 2014																							  *
*-----------------------------------------------------------------------------------------------------------------------------*
*
clear all
cd "$Results"
							*--------------------------------------------*
							*--------------------------------------------*
							* TABLE A1 - MISSINGNESS FAO AND CONFLICT    *
							*--------------------------------------------*
							*--------------------------------------------*
*
log using Table_A1.log, replace
cd "$Output_data"
use "$Output_data\data_BC_Restat2014", clear
*drop countries with no FAO data 
bys iso3: egen max_coverage = max(fao_coverage)
keep if max_coverage == 1
*drop pre FAO Agro-Maps time period
drop if year < 1982
save temp, replace
/*How many cells with only missing values over the period */
bys gid: egen mean_missing = mean(missing)
distinct gid /* total number of cells */
distinct gid if mean_missing == 1 /* cells with only missing values*/
*
foreach c in c3 c1 c2{
	use temp, clear
	drop if conflict_`c' == .
	collapse (sum) conflict_`c' (mean) missing, by(region_fao year)
	*
	tab year, gen(yeard)
	tsset region year
	*
	xtreg missing conflict_`c' yeard*, fe ro
}
erase temp.dta
log close
