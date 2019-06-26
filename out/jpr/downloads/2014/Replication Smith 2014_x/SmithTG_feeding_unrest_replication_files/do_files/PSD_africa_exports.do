import delimited "/Users/tgsmitty/Downloads/psd_grains_pulses.csv", clear
drop if attribute_description != "TY Exports"
drop if market_year != 2012
encode commodity_description, gen(commodity)
egen global_exports = sum(value), by(commodity)
rename value exports
gen pct_global = exports / global_exports * 100
encode country_name, gen(country)
keep if country_name == "Algeria" | ///
	country_name == "Angola" | ///
	country_name == "Benin" | ///
	country_name == "Botswana" | ///
	country_name == "Burkina" | ///
	country_name == "Burundi" | ///
	country_name == "Cameroon" | ///
	country_name == "Cape Verde" | ///
	country_name == "Central African Republic" | ///
	country_name == "Chad" | ///
	country_name == "Congo (Brazzaville)" | ///
	country_name == "Congo (Kinshasa)" | ///
	country_name == "Cote d'Ivoire" | ///
	country_name == "Djibouti" | ///
	country_name == "Egypt" | ///
	country_name == "Eritrea" | ///
	country_name == "Ethiopia" | ///
	country_name == "Gabon" | ///
	country_name == "Gambia, The" | ///
	country_name == "Ghana" | ///
	country_name == "Guinea" | ///
	country_name == "Guinea-Bissau" | ///
	country_name == "Kenya" | ///
	country_name == "Lesotho" | ///
	country_name == "Liberia" | ///
	country_name == "Libya" | ///
	country_name == "Madagascar" | ///
	country_name == "Malawi" | ///
	country_name == "Mali" | ///
	country_name == "Mauritania" | ///
	country_name == "Mauritius" | ///
	country_name == "Morocco" | ///
	country_name == "Mozambique" | ///
	country_name == "Namibia" | ///
	country_name == "Niger" | ///
	country_name == "Nigeria" | ///
	country_name == "Reunion" | ///
	country_name == "Rwanda" | ///
	country_name == "Senegal" | ///
	country_name == "Sierra Leone" | ///
	country_name == "Somalia" | ///
	country_name == "South Africa" | ///
	country_name == "South Sudan" | ///
	country_name == "Sudan" | ///
	country_name == "Swaziland" | ///
	country_name == "Tanzania" | ///
	country_name == "Togo" | ///
	country_name == "Tunisia" | ///
	country_name == "Uganda" | ///
	country_name == "Zambia" | ///
	country_name == "Zimbabwe"
drop if commodity == (3 | 4)
lab var exports "Total exports"
lab var pct_global "Percentage of global exports"
format pct_global %4.3f
keep country commodity exports pct_global
reshape wide exports pct_global, i(country) j(commodity)
*rename exports1 Barley
rename exports2 Corn
rename exports3 Millet
*rename exports4 Mixed_Grain
rename exports5 Oats
rename exports6 Rice
rename exports7 Rye
rename exports8 Sorghum
rename exports9 Wheat
*rename pct_global1 Barley_pct
rename pct_global2 Corn_pct
rename pct_global3 Millet_pct
*rename pct_global4 Mixed_Grain_pct
rename pct_global5 Oats_pct
rename pct_global6 Rice_pct
rename pct_global7 Rye_pct
rename pct_global8 Sorghum_pct
rename pct_global9 Wheat_pct

exit
table country commodity, c(sum exports mean pct_global) format(%6.0f %5.3f)
