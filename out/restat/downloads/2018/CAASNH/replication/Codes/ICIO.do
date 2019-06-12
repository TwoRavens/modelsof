* ----------------------------------------------------------------
* Imports ICP data
* http://icp.worldbank.org/
* Source: http://www.oecd.org/sti/ind/input-outputtables.htm
* http://stats.oecd.org/Index.aspx?DataSetCode=IOTS
* ----------------------------------------------------------------

clear

local listall c01t05 c10t14 c15t16 c17t19 c20 c21t22 c23 c24 c25 c26 c27 c28 c29 c30t33x c31 c34 c35 c36t37 c40t41 c45 c50t52 c55 c60t63 c64 c65t67 c70 c71 c72 c73t74 c75 c80 c85 c90t93 c95

*Define tradable vs. nontradable sectors, consistent with Feenstra
local tlist c01t05 c10t14 c15t16 c17t19 c20 c21t22 c23 c24 c25 c26 c27 c28 c29 c30t33x c31 c34 c35 c36t37
local nlist c40t41 c45 c50t52 c55 c60t63 c64 c65t67 c70 c71 c72 c73t74 c75 c80 c85 c90t93 c95
	
* ----------------------------------------------------------------
*1. ICIO Data - thetas, sigmas, and omegas
* ----------------------------------------------------------------
*Loop over all available countries and all years

foreach cnt in ARG AUS AUT BEL BGR BRA BRN CAN CHE CHL CHN COL CRI CYP CZE DEU DNK ESP EST FIN FRA GBR GRC HKG HRV HUN IDN IND IRL ISL ISR ITA JPN KHM KOR LTU LUX LVA MEX MLT MYS NLD NOR NZL PHL POL PRT ROU ROW RUS SAU SGP SVK SVN SWE THA TUN TUR TWN USA VNM ZAF { 
	forvalues i = 1995(1)2011 {
		import delimited using "$datadir/Data/ICIO/domimp/`cnt'`i'domimp.csv", varnames(1) clear
				
		*Theta
			*Tradable
			egen temp1 = rowtotal(`tlist') if v1 == "VALU"
			sum temp1
			scalar theta_T_num = r(mean)
			egen temp2 = rowtotal(`tlist') if v1 == "OUTPUT"
			sum temp2
			scalar theta_T_denom = r(mean)
			scalar theta_T = theta_T_num/theta_T_denom
			*Non-tradable
			egen temp3 = rowtotal(`nlist') if v1 == "VALU"
			sum temp3
			scalar theta_N_num = r(mean)
			egen temp4 = rowtotal(`nlist') if v1 == "OUTPUT"
			sum temp4
			scalar theta_N_denom = r(mean)
			scalar theta_N = theta_N_num/theta_N_denom
			
			scalar theta_bar = (theta_T_num + theta_N_num)/(theta_T_denom + theta_N_denom)

			drop temp*
		
		*Create industry-specific values of VA and GO to make industry-level thetas later
		replace v1 = strlower(v1)
		gen va_ind = .
		gen go_ind = .
		foreach ind in `tlist' `nlist' { 
			qui sum `ind' if v1 == "valu"
			local va_ind = r(mean)
			qui sum `ind' if v1 == "output"
			local go_ind = r(mean)
			
			*Populate
			replace va_ind = `va_ind' if v1 == "dom_`ind'"
			replace go_ind = `go_ind' if v1 == "dom_`ind'"
		}
			
		*Sigma
		*This is a little bit harder than in WIOD. We need total intermediates less taxes.
		
		egen temp1a = rowtotal(`tlist') if v1 == "ttl_int_fnl"
		sum temp1a
		scalar T_int_denom = r(mean)
		egen temp1b = rowtotal(`tlist') if v1 == "txs_int_fnl"
		sum temp1b
		scalar T_tax_denom = r(mean)
		egen temp2a = rowtotal(`nlist') if v1 == "ttl_int_fnl"
		sum temp2a
		scalar N_int_denom = r(mean)
		egen temp2b = rowtotal(`nlist') if v1 == "txs_int_fnl"
		sum temp2b
		scalar N_tax_denom = r(mean)
		
		scalar T_denom = T_int_denom - T_tax_denom
		scalar N_denom = N_int_denom - N_tax_denom
		drop temp*
		
		*Clean up and set up data for computing sigmas
		rename v1 sector
		keep if substr(sector,1,3) == "dom" | substr(sector,1,3) == "imp" | substr(sector,9,3) == "fnl"
		
		*Match sectors
		replace sector = "xxxxttl_fnl" if sector == "ttl_int_fnl"
		replace sector = "xxxxtsx_fnl" if sector == "txs_int_fnl"
		replace sector = substr(sector,5,.)
		gen sector_match = 1 if sector == "c01t05"
		replace sector_match = 2 if sector == "c10t14"
		replace sector_match = 3 if sector == "c15t16"
		replace sector_match = 4 if sector == "c17t19"
		replace sector_match = 5 if sector == "c20"
		replace sector_match = 6 if sector == "c21t22"
		replace sector_match = 7 if sector == "c23"
		replace sector_match = 7 if sector == "c24"
		replace sector_match = 7 if sector == "c25"
		replace sector_match = 8 if sector == "c26"
		replace sector_match = 9 if sector == "c27"
		replace sector_match = 9 if sector == "c28"
		replace sector_match = 10 if sector == "c29"
		replace sector_match = 11 if sector == "c30t33x"
		replace sector_match = 11 if sector == "c31"
		replace sector_match = 12 if sector == "c34"
		replace sector_match = 12 if sector == "c35"
		replace sector_match = 13 if sector == "c36t37"
		replace sector_match = 14 if sector == "c40t41"
		replace sector_match = 15 if sector == "c45"
		replace sector_match = 16 if sector == "c50t52"
		replace sector_match = 17 if sector == "c55"
		replace sector_match = 18 if sector == "c60t63"
		replace sector_match = 19 if sector == "c64"
		replace sector_match = 20 if sector == "c65t67"
		replace sector_match = 21 if sector == "c70"
		replace sector_match = 21 if sector == "c71"
		replace sector_match = 21 if sector == "c72"
		replace sector_match = 21 if sector == "c73t74"
		replace sector_match = 22 if sector == "c75"
		replace sector_match = 22 if sector == "c80"
		replace sector_match = 22 if sector == "c85"
		replace sector_match = 22 if sector == "c90t93"
		
		*Generate tradable status
		replace sector = strlower(sector)
		gen tradable = .
		foreach varn in `tlist' {
			replace tradable = 1 if sector == "`varn'"
		}
		*Redundancy check
		foreach varn in `nlist' {
			replace tradable = 0 if sector == "`varn'"
		}
		
			*Share of nontradable in non-labor input of nontradable production
			egen temp1 = rowtotal(`nlist') if tradable == 0
			egen temp2 = sum(temp1)
			sum temp2
			scalar NN_num = r(mean)
			scalar sigma_NN = NN_num/N_denom
			drop temp*
			
			*Share of nontradable in non-labor input of tradable production
			egen temp1 = rowtotal(`tlist') if tradable == 0
			egen temp2 = sum(temp1)
			sum temp2
			scalar NT_num = r(mean)
			scalar sigma_NT = NT_num/T_denom
			drop temp*
			
			*Share of tradable in non-labor input of tradable production
			egen temp1 = rowtotal(`tlist') if tradable == 1
			egen temp2 = sum(temp1)
			sum temp2
			scalar TT_num = r(mean)
			scalar sigma_TT = TT_num/T_denom
			drop temp*
			
			*Share of tradable in non-labor input of nontradable production
			egen temp1 = rowtotal(`nlist') if tradable == 1
			egen temp2 = sum(temp1)
			sum temp2
			scalar TN_num = r(mean)
			scalar sigma_TN = TN_num/N_denom
			drop temp*
			
			gen j_denom = .
			gen Nj_num = .
			gen Tj_num = .
			
			foreach varn in `listall' {
				*Denominators
				egen temp1a = rowtotal(`varn') if sector == "ttl_fnl"
				sum temp1a
				gen `varn'_int_denom = r(mean)
				egen temp1b = rowtotal(`varn') if sector == "tsx_fnl"
				sum temp1b
				gen `varn'_tax_denom = r(mean)
				
				replace j_denom = `varn'_int_denom - `varn'_tax_denom if sector == "`varn'"
				drop `varn'_int_denom `varn'_tax_denom
				
				*Numerators
				egen temp2 = sum(`varn') if tradable == 1
				sum temp2
				replace Tj_num = r(mean) if sector == "`varn'"
				
				drop temp2
				
				egen temp2 = sum(`varn') if tradable == 0
				sum temp2
				replace Nj_num = r(mean) if sector == "`varn'"
				
				drop temp*
			}
		drop if sector == "ttl_fnl" | sector == "tsx_fnl"

		*Set up dataset
		keep sector va_ind go_ind j_denom Tj_num Nj_num
		keep if va_ind != . & go_ind != .
		
		gen ctyc = "`cnt'"
		gen year = `i'
		
		*Industries, as they match the ICP data
		gen sector_match_icp = 1 if sector == "c40t41" | sector == "c70"
		replace sector_match_icp = 2 if sector == "c85"
		replace sector_match_icp = 3 if sector == "c60t63"
		replace sector_match_icp = 4 if sector == "c64"
		replace sector_match_icp = 5 if sector == "c90t93"
		replace sector_match_icp = 6 if sector == "c80"
		replace sector_match_icp = 7 if sector == "c55"
		replace sector_match_icp = 8 if sector == "c45"
		replace sector_match_icp = 9 if sector == "c15t16"
		replace sector_match_icp = 10 if sector == "c15t16"
		replace sector_match_icp = 11 if sector == "c17t19"
		drop if sector_match_icp == .
		
		preserve
		keep if sector_match_icp == 10
		replace sector_match_icp = 9
		tempfile a
		save `a'
		restore
		append using `a'
		
		*Generate industry-specific thetas
		collapse (sum) va_ind go_ind j_denom Tj_num Nj_num, by(sector_match_icp ctyc year)
		gen theta_ind = va_ind/go_ind
		gen sigma_Tj = Tj_num/j_denom
		gen sigma_Nj = Nj_num/j_denom
		
		gen theta_T = theta_T
		gen theta_N = theta_N
		gen theta_bar = theta_bar
		gen sigma_NN = sigma_NN
		gen sigma_NT = sigma_NT
		gen sigma_TT = sigma_TT
		gen sigma_TN = sigma_TN
		
		gen va_T = theta_T_num
		gen va_N = theta_N_num
		gen va_tot = theta_T_num + theta_N_num
		gen go_T = theta_T_denom
		gen go_N = theta_N_denom
		gen go_tot = theta_T_denom + theta_N_denom
		
		*Generate expenditure weights (omegas)
		gen omega_T = va_T/va_tot
		gen omega_N = va_N/va_tot
		
		save "$datadir/Data/ICIO/domimp/`cnt'_`i'.dta", replace
	}
}

*Put together master file
clear
foreach cnt in ARG AUS AUT BEL BGR BRA BRN CAN CHE CHL CHN COL CRI CYP CZE DEU DNK ESP EST FIN FRA GBR GRC HKG HRV HUN IDN IND IRL ISL ISR ITA JPN KHM KOR LTU LUX LVA MEX MLT MYS NLD NOR NZL PHL POL PRT ROU ROW RUS SAU SGP SVK SVN SWE THA TUN TUR TWN USA VNM ZAF { 
	forvalues i = 1995(1)2011 {
		append using "$datadir/Data/ICIO/domimp/`cnt'_`i'.dta"
	}
}

*Output these files for merging with labor data below
save "$datadir/Data/ICIO/icio_temp.dta", replace

*Data file for just the sector-level coefficients
keep ctyc year theta_T theta_N theta_bar sigma_NN sigma_NT sigma_TT sigma_TN omega_T omega_N
duplicates drop
save "$datadir/Data/ICIO/icio_temp2.dta", replace

* --------------------------------------------------------------------------------------------------------------------------------
*2. Prepare ICIO Labor Data
* ----------------------------------------------------------------

import delimited using "$datadir/Data/ICIO/OECD_IO2015_VALU.csv", varnames(1) clear

*Keep only the labor compensation data and value added data
keep if row == "LABR" | row == "VALU"
rename country ctyc
rename col icio_sector

*Reshape to separate LAB and VA
reshape wide value, i(ctyc year icio_sector) j(row, string)
rename valueLABR LAB_ind
rename valueVALU VA_ind

*Match sectors
gen sector_match = 1 if icio_sector == "C01T05"
replace sector_match = 2 if icio_sector == "C10T14"
replace sector_match = 3 if icio_sector == "C15T16"
replace sector_match = 4 if icio_sector == "C17T19"
replace sector_match = 5 if icio_sector == "C20"
replace sector_match = 6 if icio_sector == "C21T22"
replace sector_match = 7 if icio_sector == "C23"
replace sector_match = 7 if icio_sector == "C24"
replace sector_match = 7 if icio_sector == "C25"
replace sector_match = 8 if icio_sector == "C26"
replace sector_match = 9 if icio_sector == "C27"
replace sector_match = 9 if icio_sector == "C28"
replace sector_match = 10 if icio_sector == "C29"
replace sector_match = 11 if icio_sector == "C30T33X"
replace sector_match = 11 if icio_sector == "C31"
replace sector_match = 12 if icio_sector == "C34"
replace sector_match = 12 if icio_sector == "C35"
replace sector_match = 13 if icio_sector == "C36T37"
replace sector_match = 14 if icio_sector == "C40T41"
replace sector_match = 15 if icio_sector == "C45"
replace sector_match = 16 if icio_sector == "C50T52"
replace sector_match = 17 if icio_sector == "C55"
replace sector_match = 18 if icio_sector == "C60T63"
replace sector_match = 19 if icio_sector == "C64"
replace sector_match = 20 if icio_sector == "C65T67"
replace sector_match = 21 if icio_sector == "C70"
replace sector_match = 21 if icio_sector == "C71"
replace sector_match = 21 if icio_sector == "C72"
replace sector_match = 21 if icio_sector == "C73T74"
replace sector_match = 22 if icio_sector == "C75"
replace sector_match = 22 if icio_sector == "C80"
replace sector_match = 22 if icio_sector == "C85"
replace sector_match = 22 if icio_sector == "C90T93"
*Get rid of personal sector, which is all labor
drop if sector_match == .

*Generate tradable status
replace icio_sector = strlower(icio_sector)
gen tradable = .
foreach varn in `tlist' {
	replace tradable = 1 if icio_sector == "`varn'"
}
*Redundancy check
foreach varn in `nlist' {
	replace tradable = 0 if icio_sector == "`varn'"
}
	
*For each country-year, generate tradable and nontradable labor/va ratios (the alphas)
foreach varn in LAB VA {
	bysort ctyc year: egen xx`varn'_t = sum(`varn'_ind) if tradable == 1
	bysort ctyc year: egen `varn'_t = mean(xx`varn'_t)
	bysort ctyc year: egen xx`varn'_n = sum(`varn'_ind) if tradable == 0
	bysort ctyc year: egen `varn'_n = mean(xx`varn'_n)
	drop xx*
}

*Generate and collapse to ICP data level
gen sector_match_icp = 1 if icio_sector == "c40t41" | icio_sector == "c70"
replace sector_match_icp = 2 if icio_sector == "c85"
replace sector_match_icp = 3 if icio_sector == "c60t63"
replace sector_match_icp = 4 if icio_sector == "c64"
replace sector_match_icp = 5 if icio_sector == "c90t93"
replace sector_match_icp = 6 if icio_sector == "c80"
replace sector_match_icp = 7 if icio_sector == "c55"
replace sector_match_icp = 8 if icio_sector == "c45"
replace sector_match_icp = 9 if icio_sector == "c15t16"
	*Duplicate, will be dealt with below
replace sector_match_icp = 10 if icio_sector == "c15t16"
replace sector_match_icp = 11 if icio_sector == "c17t19"
drop if sector_match_icp == .
collapse (sum) LAB_ind VA_ind (mean) LAB_t LAB_n VA_t VA_n, by(ctyc year sector_match_icp tradable)

*Note: because c15t16 isn't split, we're duplicating it here
preserve
keep if sector_match_icp == 10
replace sector_match_icp = 9
tempfile a
save `a'
restore
append using `a'

*Generate alphas
gen alpha_T = 1 - LAB_t/VA_t
gen alpha_N = 1 - LAB_n/VA_n
gen alpha_ind = 1 - LAB_ind/VA_ind
gen alpha_total = (LAB_t + LAB_n)/(VA_t + VA_n)

*Clean up, output industry-level data
keep year ctyc alpha* sector_match_icp tradable
save "$datadir/Data/ICIO/icio_labor_ind.dta", replace

*Output sector-level data
drop tradable sector_match_icp alpha_ind
duplicates drop
save "$datadir/Data/ICIO/icio_labor.dta", replace

*----------------------------------------------------------------
*3. Create master datasets
*----------------------------------------------------------------

*Create master dataset for industry-level variables
use "$datadir/Data/ICIO/icio_temp.dta", clear
merge 1:1 ctyc year sector_match_icp using "$datadir/Data/ICIO/icio_labor_ind.dta"
drop _merge
save "$datadir/Data/ICIO/icio_master_ind.dta", replace

*Create master dataset for sector-level variables
use "$datadir/Data/ICIO/icio_temp2.dta", clear
merge 1:1 ctyc year using "$datadir/Data/ICIO/icio_labor.dta"
drop _merge
save "$datadir/Data/ICIO/icio_master_sect.dta", replace

* ----------------------------------------------------------------
*4. Delete auxiliary  datasets
* ----------------------------------------------------------------

foreach cnt in ARG AUS AUT BEL BGR BRA BRN CAN CHE CHL CHN COL CRI CYP CZE DEU DNK ESP EST FIN FRA GBR GRC HKG HRV HUN IDN IND IRL ISL ISR ITA JPN KHM KOR LTU LUX LVA MEX MLT MYS NLD NOR NZL PHL POL PRT ROU ROW RUS SAU SGP SVK SVN SWE THA TUN TUR TWN USA VNM ZAF { 
	forvalues i = 1995(1)2011 {
		capture erase "$datadir/Data/ICIO/domimp/`cnt'_`i'.dta"	
	}
}
capture erase "$datadir/Data/ICIO/icio_temp.dta"
capture erase "$datadir/Data/ICIO/icio_temp2.dta"
capture erase "$datadir/Data/ICIO/icio_labor_ind.dta"
capture erase "$datadir/Data/ICIO/icio_labor.dta"
