******
*Working with the industry-level price data from ICP
*
*http://icp.worldbank.org/
******

clear 



**********************************************************
*1. Pull real GDP/capita and nominal GDP/capita from the ICP tables.
*
*NOTE: we do not use the ICP gdppc variables in our sector-level results.
*However, we use them in the industry-specific exercise
**********************************************************
*Import excel spreadsheets
import excel "$datadir/Data/ICP_WB/2011ICP.xlsx", sheet("TABLE D6") cellrange(C4:Z212) firstrow clear
save "$datadir/Data/ICP_WB/rgdppc_usd.dta", replace
import excel "$datadir/Data/ICP_WB/2011ICP.xlsx", sheet("TABLE D10") cellrange(C4:Z212) firstrow clear
save "$datadir/Data/ICP_WB/ngdppc_usd.dta", replace

foreach varname in rgdppc_usd ngdppc_usd {
	use "$datadir/Data/ICP_WB/`varname'.dta", clear

	*Clean up things (drop empty columns, rename country name column)
	drop D
	drop if C == ""
	rename C ctyn
	*Egypt, Sudan, and the Russian Federation all have double-regionality
		*Drop these copies that have to do with footnotes
	drop if ctyn == "Egypt, Arab Rep.a" | ctyn == "Egypt, Arab Rep.b" | ctyn == "Sudanb" | ctyn == "Sudanc" | ctyn == "Russian Federationd" | ctyn == "Russian Federatione"
	replace ctyn = "China" if ctyn == "Chinac" | ctyn == "Chinad"
	
	*Reshape, E is the column for gdp
	rename E `varname'
	keep ctyn `varname'
	
	*Replace missing and strings, if necessary
	capture replace `varname' = "." if `varname' == "…"
	capture destring `varname', replace
	
	save "$datadir/Data/ICP_WB/`varname'_clean.dta", replace
}









**********************************************************
*2. Pull industry-level price and expenditure data
**********************************************************
*Import excel spreadsheets
import excel "$datadir/Data/ICP_WB/2011ICP.xlsx", sheet("TABLE D8") cellrange(C4:Z212) firstrow clear
save "$datadir/Data/ICP_WB/price.dta", replace
import excel "$datadir/Data/ICP_WB/2011ICP.xlsx", sheet("TABLE D10") cellrange(C4:Z212) firstrow clear
save "$datadir/Data/ICP_WB/exp.dta", replace


foreach varname in price exp {
	use "$datadir/Data/ICP_WB/`varname'.dta", clear

	*Clean up things
	drop D
	drop if C == ""
	rename C ctyn
	*Egypt, Sudan, and the Russian Federation all have double-regionality
	drop if ctyn == "Egypt, Arab Rep.a" | ctyn == "Sudanb" | ctyn == "Russian Federationd"
	replace ctyn = "China" if ctyn == "Chinac"
	
	*Reshape, assign generic sector numbers
	rename E `varname'1
	rename F `varname'2
	rename G `varname'3
	rename H `varname'4
	rename I `varname'5
	rename J `varname'6
	rename K `varname'7
	rename L `varname'8
	rename M `varname'9
	rename N `varname'10
	rename O `varname'11
	rename P `varname'12
	rename Q `varname'13
	rename R `varname'14
	rename S `varname'15
	rename T `varname'16
	rename U `varname'17
	rename V `varname'18
	rename W `varname'19
	rename X `varname'20
	rename Y `varname'21
	rename Z `varname'22
	reshape long `varname', i(ctyn) j(snum)

	*Form sectoral concordance with other datasets
	gen sector_match_icp = 1 if snum == 6
	replace sector_match_icp = 2 if snum == 8
	replace sector_match_icp = 3 if snum == 9
	replace sector_match_icp = 4 if snum == 10
	replace sector_match_icp = 5 if snum == 11
	replace sector_match_icp = 6 if snum == 12
	replace sector_match_icp = 7 if snum == 13
	replace sector_match_icp = 8 if snum == 20
	replace sector_match_icp = 9 if snum == 3
	replace sector_match_icp = 10 if snum == 4
	replace sector_match_icp = 11 if snum == 5
	drop if sector_match_icp == .
	drop snum
	
	save "$datadir/Data/ICP_WB/`varname'_clean.dta", replace
}

*Merge
use "$datadir/Data/ICP_WB/price_clean.dta", clear
merge 1:1 ctyn sector_match_icp using "$datadir/Data/ICP_WB/exp_clean.dta"
drop _merge
merge m:1 ctyn using "$datadir/Data/ICP_WB/rgdppc_usd_clean.dta"
drop _merge
merge m:1 ctyn using "$datadir/Data/ICP_WB/ngdppc_usd_clean.dta"
drop _merge

*Generate sector names just to keep ourselves straight
gen sector_n = "Housing, Water, Electricity, & Gas" if sector_match_icp == 1
replace sector_n = "Health" if sector_match_icp == 2
replace sector_n = "Transport" if sector_match_icp == 3
replace sector_n = "Communication" if sector_match_icp == 4
replace sector_n = "Recreation & Culture" if sector_match_icp == 5
replace sector_n = "Education" if sector_match_icp == 6
replace sector_n = "Restaurants & Hotels" if sector_match_icp == 7
replace sector_n = "Construction" if sector_match_icp == 8
replace sector_n = "Food & Non-Alcohol" if sector_match_icp == 9
replace sector_n = "Alcohol, Tobacco, & Narcotics" if sector_match_icp == 10
replace sector_n = "Clothing & Footwear" if sector_match_icp == 11

*We will pull tradability from the ICIO data, so we don't have to define it here
*These data are 2011, and we'll match to the ICIO 2011 data
gen year = 2011

*The country names aren't standardized. Merge in as many 3-digit country codes as we can
merge m:1 ctyn using "$datadir/Data/ICP_WB/countrynames.dta"
drop if _merge == 2
drop _merge

*Replace the ones that don't merge
replace ctyc = "BHS" if ctyn == "Bahamas, The"
replace ctyc = "BES" if ctyn == "Bonairef"
replace ctyc = "COD" if ctyn == "Congo, Dem. Rep."
replace ctyc = "COG" if ctyn == "Congo, Rep."
replace ctyc = "CUB" if ctyn == "Cubae"
replace ctyc = "CUW" if ctyn == "Curaçao"
replace ctyc = "GMB" if ctyn == "Gambia, The"
replace ctyc = "HKG" if ctyn == "Hong Kong SAR, China"
replace ctyc = "IRN" if ctyn == "Iran, Islamic Rep."
replace ctyc = "KOR" if ctyn == "Korea, Rep."
replace ctyc = "MAC" if ctyn == "Macao SAR, China"
replace ctyc = "MKD" if ctyn == "Macedonia, FYR"
replace ctyc = "PSE" if ctyn == "Palestinian Territory"
replace ctyc = "SXM" if ctyn == "Sint Maarten"
replace ctyc = "KNA" if ctyn == "St. Kitts and Nevis"
replace ctyc = "LCA" if ctyn == "St. Lucia"
replace ctyc = "VCT" if ctyn == "St. Vincent and the Grenadines"
replace ctyc = "SUR" if ctyn == "Suriname"
replace ctyc = "STP" if ctyn == "São Tomé and Principe"
replace ctyc = "TWN" if ctyn == "Taiwan, China"
replace ctyc = "TZA" if ctyn == "Tanzania"
replace ctyc = "USA" if ctyn == "United States"
replace ctyc = "VEN" if ctyn == "Venezuela, RB"
replace ctyc = "VNM" if ctyn == "Vietnam"
replace ctyc = "VGB" if ctyn == "Virgin Islands, British"

*Merge in alphas from ICIO (see icio_data.do)
merge 1:1 ctyc year sector_match_icp using "$datadir/Data/ICIO/icio_master_ind.dta"
	*Missing for sector 5, "recreation and culture", for a couple countries
	*RoW, Russia (in two subsections, treated differently), and Argentina (no argentina in ICP!) don't merge
drop if _merge == 2
drop _merge

*Assign tradable status (coming from ICIO) to all appropriate observations
forvalues i = 1(1)11 { 
	sum tradable if sector_match_icp == `i'
	local mv = r(mean)
	replace tradable = `mv' if sector_match_icp == `i'
}

*Assign average coefficients for countries not available from ICIO
	*First, try to assign to countries that have ICIO for some sectors, but missing for others
	foreach varname in sigma_NN sigma_NT sigma_TN sigma_TT alpha_T alpha_N theta_N theta_T {
		bysort year ctyc: egen mean_`varname' = mean(`varname')
		replace `varname' = mean_`varname' if `varname' == .
		drop mean_`varname'
	}
	
	*Now, if truly missing for every sector in a country, assign the overall mean
	foreach varname in sigma_NN sigma_NT sigma_TN sigma_TT alpha_T alpha_N theta_N theta_T {
		bysort year: egen mean_`varname' = mean(`varname')
		replace `varname' = mean_`varname' if `varname' == .
		drop mean_`varname'
	}
	
	

*Similarly, assign average sector-sepcfic ICIO alphas/thetas/sigmas if missing
replace alpha_ind = . if alpha_ind < 0

	foreach varname in alpha_ind theta_ind sigma_Tj sigma_Nj {
		bysort year sector_match_icp: egen mean_`varname' = mean(`varname')
		replace `varname' = mean_`varname' if `varname' == .

		*Fix if any still missing
		replace `varname' = . if `varname' == 0
		drop mean_`varname'
	}


	
*Clean up, form desired variables for analysis
drop ctyn
order year ctyc sector_n sector_match_icp tradable price exp

*Prices and sector prices
replace price = log(price)
bysort year ctyc tradable: egen exp_tot_TNT = sum(exp)
gen exp_share = exp/exp_tot_TNT
gen price_times_exp_share = price*exp_share
bysort year ctyc tradable: egen p_TNT_ICP = sum(price_times_exp_share)
	*Create two separate variables for tradables and nontradables
	gen xxpn_ICP = p_TNT_ICP if tradable == 0
	bysort year ctyc: egen pn_ICP = mean(xxpn_ICP)
	gen xxpt_ICP = p_TNT_ICP if tradable == 1
	bysort year ctyc: egen pt_ICP = mean(xxpt_ICP)
	drop xx* p_TNT_ICP price_times_exp_share exp_tot_TNT
	

	
*Generate p^l - p^(NT) for both tradables and nontradables
gen price_sect_dif = price - pn_ICP
gen pt_minus_pn = pt_ICP - pn_ICP

*Clean
drop go_* va_*
order year ctyc sector* price pn_ICP pt_ICP price_sect_dif pt_minus_pn sigma_NN sigma_NT sigma_TN sigma_TT alpha_T alpha_N theta_T theta_N alpha_ind theta_ind sigma_Nj sigma_Tj

*Merge in labor share and capital share data from the PWT
merge m:1 ctyc year using "$datadir/Data/PWT/pwt_data.dta", keepusing(ctyc year labsh cap_pc)
drop if _merge == 2
drop _merge

*Rescale for those with labsh data - make note of the countries that have no scaling factor of their own
gen alpha_scaling = labsh/alpha_total
gen noscale = alpha_scaling == .
*If we don't have the appropriate data, give avg rescaling factor
foreach var in alpha_scaling {
	bysort year: egen xx`var' = mean(`var')
	replace `var' = xx`var' if `var' == .
	drop xx`var'
}


*Rearrange alphas (we later decided alpha to be (1 - alpha), switching labor and capital
replace alpha_T = 1 - alpha_scaling*(1 - alpha_T)
replace alpha_N = 1 - alpha_scaling*(1 - alpha_N)
replace alpha_ind = 1 - alpha_scaling*(1 - alpha_ind)

replace alpha_ind = . if alpha_ind < 0



************************************************************************************************
**********************************************************
*5. Output Table A.3, country-specific values for share of tradable intermediates, sigma TN, TT, Tj
**********************************************************
************************************************************************************************
preserve


keep ctyc sector_n sector_match_icp sigma_TN sigma_TT sigma_Tj

*Keep only the unique values
egen temp1 = mean(sigma_TN)
drop if sigma_TN == temp1
drop temp1


*Reshape
drop if sector_match_icp == 9
drop sector_n
reshape wide sigma_Tj, i(ctyc sigma_TN sigma_TT) j(sector_match_icp)

*Clean up
rename sigma_Tj1 sigma_Thousing
rename sigma_Tj2 sigma_Thealth
rename sigma_Tj3 sigma_Ttrans
rename sigma_Tj4 sigma_Tcomm
rename sigma_Tj5 sigma_Trec
rename sigma_Tj6 sigma_Teduc
rename sigma_Tj7 sigma_Trest
rename sigma_Tj8 sigma_Tcons
rename sigma_Tj10 sigma_Talc
rename sigma_Tj11 sigma_Tcloth

order ctyc sigma_TT sigma_TN sigma_Thealth sigma_Ttrans sigma_Tcomm sigma_Trec sigma_Teduc sigma_Trest sigma_Tcons sigma_Thousing sigma_Talc sigma_Tcloth


*Create averages
local obsnum = _N + 1
set obs `obsnum'
replace ctyc = "Average" if _n == `obsnum'
local varlist T N housing health trans comm rec educ rest cons alc cloth 
foreach varn in `varlist' {
	egen avgvarn = mean(sigma_T`varn')
	replace sigma_T`varn' = avgvarn if _n == `obsnum'
	drop avgvarn
}




*Output
if $ameco_list == 0 { 
	save "$datadir/Tables/table_A3.dta", replace
	export excel using "$datadir/Tables/table_A3.xlsx", firstrow(var) replace
}




************
*End Table A.3
************
restore



************************************************************************************************
**********************************************************
*4. Output Table A.2, country-specific values for input share, theta
**********************************************************
************************************************************************************************
preserve
keep ctyc sector* theta* omega_N 

*Reshape nicely for table
tempfile a b c
save `a', replace

*Grab NT shares
keep ctyc theta_N omega_N
duplicates drop
gen sector_n = "Total non-tradables"
gen sector_match_icp = 0
rename theta_N theta_ind
save `b', replace

*Grab T shares
use `a', clear
keep ctyc theta_T omega_N
duplicates drop
gen sector_n = "Total tradables"
gen sector_match_icp = 100
rename theta_T theta_ind
save `c', replace

*Append back in
use `a', clear
keep ctyc sector* theta_ind omega_N 
append using `b'
append using `c'

*Reshape
drop if sector_match_icp == 9
drop sector_n
reshape wide theta_ind, i(ctyc omega_N) j(sector_match_icp)

*Clean up
rename theta_ind0 theta_N
rename theta_ind1 theta_housing
rename theta_ind2 theta_health
rename theta_ind3 theta_trans
rename theta_ind4 theta_comm
rename theta_ind5 theta_rec
rename theta_ind6 theta_educ
rename theta_ind7 theta_rest
rename theta_ind8 theta_cons
rename theta_ind10 theta_alc
rename theta_ind11 theta_cloth
rename theta_ind100 theta_T

order ctyc theta_T theta_N omega_N theta_health theta_trans theta_comm theta_rec theta_educ theta_rest theta_cons theta_housing theta_alc theta_cloth


*Create averages
local obsnum = _N + 1
set obs `obsnum'
replace ctyc = "Average" if _n == `obsnum'
local varlist N housing health trans comm rec educ rest cons alc cloth T
foreach varn in `varlist' {
	egen avgvarn = mean(theta_`varn')
	replace theta_`varn' = avgvarn if _n == `obsnum'
	drop avgvarn
}
egen avgvarn = mean(omega_N)
replace omega_N = avgvarn if _n == `obsnum'
drop avgvarn

*Keep only the countries for which we have unique values
drop if omega_N == .

*Output
if $ameco_list == 0 { 
	save "$datadir/Tables/table_A2.dta", replace
	export excel using "$datadir/Tables/table_A2.xlsx", firstrow(var) replace
}

************
*End Table 2
************
restore






************************************************************************************************
**********************************************************
*5. Begin clean-up for graphs
**********************************************************
************************************************************************************************
gen theta_N_bar = theta_N + sigma_TN*(1 - theta_N) + sigma_NT*(1 - theta_T)

*Simplified betas using sigma_NN, alpha_N
*Betas for gdp and k for computing the relative price of p^l
gen beta_gdp = (theta_ind - theta_N)*(1 - sigma_NN*(theta_N - theta_T)/theta_N_bar) + (theta_N - theta_T)/theta_N_bar
*gen beta_ky = - ( (theta_N_bar - sigma_NN*theta_N + (alpha_T*theta_T*sigma_NN)/alpha_N)*alpha_N*(theta_ind - theta_N)/theta_N_bar - (alpha_T*theta_T - alpha_N*theta_N)/theta_N_bar )
gen beta_ky = - ( alpha_N*(theta_ind - theta_N) + sigma_NN*(theta_N - theta_ind)*(alpha_N*theta_N - alpha_T*theta_T)/theta_N_bar + (alpha_N*theta_N - alpha_T*theta_T)/theta_N_bar     )


*Betas for gdp and k for computing the relative price of p^l - p^N
gen beta_gdp_bar = beta_gdp - (theta_N - theta_T)/theta_N_bar
gen beta_ky_bar = beta_ky - (alpha_T*theta_T - alpha_N*theta_N)/theta_N_bar


*Betas using the full set of individual parameters
*Betas for gdp and k for computing the relative price of p^l
gen beta_gdp2 = (theta_ind - theta_N) + sigma_Nj*(1 - theta_ind)*(theta_N - theta_T)/theta_N_bar - sigma_NN*(1 - theta_N)*(theta_N - theta_T)/theta_N_bar + (theta_N - theta_T)/theta_N_bar
gen beta_ky2 = - ((alpha_ind*theta_ind - alpha_N*theta_N) + sigma_Nj*(1 - theta_ind)*(alpha_N*theta_N - alpha_T*theta_T)/theta_N_bar - sigma_NN*(1 - theta_N)*(alpha_N*theta_N - alpha_T*theta_T)/theta_N_bar + (alpha_N*theta_N - alpha_T*theta_T)/theta_N_bar)


*Betas for gdp and k for computing the relative price of p^l - p^N
gen beta_gdp_bar2 = beta_gdp2 - (theta_N - theta_T)/theta_N_bar
gen beta_ky_bar2 = beta_ky2 + (alpha_N*theta_N - alpha_T*theta_T)/theta_N_bar




*Compute relative-to-US variables (everything is already in logs)
foreach var in price price_sect_dif ngdppc_usd rgdppc_usd cap_pc pt_minus_pn pn_ICP pt_ICP {
	gen xx`var'_US=`var' if ctyc == "USA"
	bysort year sector_match_icp: egen `var'_US = mean(xx`var'_US)
	drop xx`var'_US
}
gen price_relUS = price - price_US
gen price_sect_dif_relUS = price_sect_dif - price_sect_dif_US
gen pt_minus_pn_relUS = pt_minus_pn - pt_minus_pn_US
gen pn_relUS = pn_ICP - pn_ICP_US
gen pt_relUS = pt_ICP - pt_ICP_US

*Model for p^l - p^N vs. the same in US
gen price_sect_dif_model = beta_ky_bar*(log(cap_pc) - log(cap_pc_US)) + beta_gdp_bar*(log(ngdppc_usd) - log(ngdppc_usd_US))
gen price_sect_dif_ky = beta_ky_bar*(log(cap_pc) - log(cap_pc_US))
gen price_sect_dif_gdp = beta_gdp_bar*(log(ngdppc_usd) - log(ngdppc_usd_US))

*Sector-specific alphas and sigmas
*Model for p^l - p^N vs. the same in US
gen price_sect_dif_model2 = beta_ky_bar2*(log(cap_pc) - log(cap_pc_US)) + beta_gdp_bar2*(log(ngdppc_usd) - log(ngdppc_usd_US))
gen price_sect_dif_ky2 = beta_ky_bar2*(log(cap_pc) - log(cap_pc_US))
gen price_sect_dif_gdp2 = beta_gdp_bar2*(log(ngdppc_usd) - log(ngdppc_usd_US))


*Model for price of industry l vs. price of industry l in US
gen model_sector = beta_ky*(log(cap_pc)) + beta_gdp*(log(ngdppc_usd))
gen model_sector_relUS = beta_ky*(log(cap_pc) - log(cap_pc_US)) + beta_gdp*(log(ngdppc_usd) - log(ngdppc_usd_US))
gen model_sector_relUS_gdp = beta_gdp*(log(ngdppc_usd) - log(ngdppc_usd_US))
gen model_sector_relUS_ky = beta_ky*(log(cap_pc) - log(cap_pc_US))
gen model_sector_relUS_resid = price_relUS - model_sector_relUS

*Sector-specific alphas and sigmas
*Model for price of industry l vs. price of industry l in US
gen model_sector2 = beta_ky2*(log(cap_pc)) + beta_gdp2*(log(ngdppc_usd))
gen model_sector_relUS2 = beta_ky2*(log(cap_pc) - log(cap_pc_US)) + beta_gdp2*(log(ngdppc_usd) - log(ngdppc_usd_US))
gen model_sector_relUS_gdp2 = beta_gdp2*(log(ngdppc_usd) - log(ngdppc_usd_US))
gen model_sector_relUS_ky2 = beta_ky2*(log(cap_pc) - log(cap_pc_US))
gen model_sector_relUS_resid2 = price_relUS - model_sector_relUS2

gen gdp_curr_logdifUS = log(ngdppc_usd) - log(ngdppc_usd_US)
gen gdp_const_logdifUS = log(rgdppc_usd) - log(rgdppc_usd_US)


*Clean up, output
la var year "2011 ICP Data"
la var sector_n "Sector Name"
la var sector_match_icp "ID used to match ICP"
la var price "2011 ICP Price data, industry-specific, in logs"
la var price_relUS "2011 ICP Price data, industry-specific, in logs (rel. to US)"
la var pn_ICP "Non-tradable aggregate price level, expenditure-weighted"
la var price_sect_dif "p^l - p^N "
la var price_sect_dif_relUS "(p^l - p^N) - (p^l_US - p^N_US)"
la var pt_minus_pn "p^T - p^N"
la var pt_minus_pn_relUS "(p^T - p^N) - (p^T_US - p^N_US)"
la var pn_relUS "p^N - p^N_US"
la var pt_relUS "p^T - p^T_US"
la var gdp_curr_logdifUS "log(ngdppc_usd) - log(ngdppc_usd_US)"
la var gdp_const_logdifUS "log(rgdppc_usd) - log(rgdppc_usd_US)"

*Keep only the countries for which we have data
keep if gdp_curr_logdifUS != . & price_relUS != . & model_sector_relUS != .

save "$datadir/Data/ICP_WB/ICP_master.dta", replace



**********************************************************
*6. Clean up extra datasets
**********************************************************
foreach varname in price exp rgdppc_usd ngdppc_usd {
	capture erase "$datadir/Data/ICP_WB/`varname'.dta"
	capture erase "$datadir/Data/ICP_WB/`varname'_clean.dta"
}

*Conclusion of file.
