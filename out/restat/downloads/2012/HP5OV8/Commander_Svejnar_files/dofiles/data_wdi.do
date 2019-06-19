clear

insheet using "data\WDI (educ & health data).csv"

rename v1 country_name
rename v2 country_code
rename v3 x
rename v17 y2002
rename v20 y2005

drop v*
destring y*, force replace

keep if country_name == "Albania" | country_name == "Armenia" | country_name == "Azerbaijan" | country_name == "Belarus" | /*
	*/ country_name == "Bosnia and Herzegovina" | country_name == "Bulgaria" | country_name == "Croatia" | country_name == "Czech Republic" /*
	*/ | country_name == "Estonia" | country_name == "Georgia" | country_name == "Hungary" | country_name == "Kazakhstan" | /*
	*/ country_name == "Kyrgyz Republic" | country_name == "Latvia" | country_name == "Lithuania" | country_name == "Macedonia, FYR" | /*
	*/ country_name == "" | country_name == "Moldova" | country_name == "Poland" | country_name == "Romania" | country_name == "Russia" | /*
	*/ country_name == "Serbia and Montenegro" | country_name == "Slovak Republic" | country_name == "Slovenia" | country_name == "Tajikistan" | /*
	*/ country_name == "Ukraine" | country_name == "Uzbekistan"
	
keep if x == "Health expenditure, total (% of GDP)" | x == "Health expenditure per capita (current US$)"

replace x = "_gdp" if x == "Health expenditure, total (% of GDP)"
replace x = "_cap" if x == "Health expenditure per capita (current US$)"

reshape long y, i(country_name x) j(year)
rename y health
reshape wide health, i(country_name year) j(x) string


replace country_name = "Kyrgyzstan" if country_name == "Kyrgyz Republic"
replace country_name = "Macedonia" if country_name == "Macedonia, FYR"
replace country_name = "Slovakia" if country_name == "Slovak Republic"

sort country_name year

save data\wdi_data, replace
