* extracting country names

	split cntry_name, parse(-) gen(c)
	replace cntry_name = c2 + c3
	replace cntry_name = trim(cntry_name)
	drop c1 c2 c3

* harmonizing country codes

	gen country = ""
	replace country = "AUS" if cntry_name=="Australia"
	replace country = "AUT" if cntry_name=="Austria"
	replace country = "BEL" if cntry_name=="Belgium"
	replace country = "CZE" if cntry_name=="Czech Republic"
	replace country = "DNK" if cntry_name=="Denmark"
	replace country = "EST" if cntry_name=="Estonia"
	replace country = "ESP" if cntry_name=="Spain"
	replace country = "FIN" if cntry_name=="Finland"
	replace country = "FRA" if cntry_name=="France"
	replace country = "GER" if cntry_name=="Germany"
	replace country = "GRC" if cntry_name=="Greece"
	replace country = "HUN" if cntry_name=="Hungary"
	replace country = "IRL" if cntry_name=="Ireland"
	replace country = "ITA" if cntry_name=="Italy"
	replace country = "JPN" if cntry_name=="Japan"
	replace country = "KOR" if cntry_name=="Rep. of Korea"
	replace country = "LTU" if cntry_name=="Lithunia"
	replace country = "LVA" if cntry_name=="Latvia"
	replace country = "MLT" if cntry_name=="Malta"
	replace country = "NLD" if cntry_name=="Netherlands"
	replace country = "POL" if cntry_name=="Poland"
	replace country = "PRT" if cntry_name=="Portugal"
	replace country = "SVK" if cntry_name=="Slovakia"
	replace country = "SVN" if cntry_name=="Slovenia"
	replace country = "SWE" if cntry_name=="Sweden"
	replace country = "UK" if cntry_name=="United Kingdom"
	replace country = "US" if cntry_name=="United States (North America)"
	
	replace country = "CAN" if cntry_name=="Canada Until 2010 included in US (North America)"
	replace country = "MEX" if cntry_name=="Mexico Until 2010 included in US (North America)"
	
	replace country = "JPN" if cntry_name=="Japan"
	replace country = "RUS" if cntry_name=="Russian Federation"
	replace country = "CHN" if cntry_name=="China"
	
	
