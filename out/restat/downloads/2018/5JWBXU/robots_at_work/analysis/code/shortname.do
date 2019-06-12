* renaming for presentational purposes
* syntax: do shortname variable

	if "`1'"=="industry" {
		
		cap gen industry_name = ""
		
		replace industry_name="Agriculture" if ind_robots=="Agriculture, hunting, forestry and fishing"
		replace industry_name="Transport equipment" if ind_robots=="Transport equipment"
		replace industry_name="Construction" if ind_robots=="Construction"
		replace industry_name="Electronics" if ind_robots=="Electrical and optical equipment"
		replace industry_name="Utilities" if ind_robots=="Electricity, gas, water supply"
		replace industry_name="Food products" if ind_robots=="Food products, beverages and tobacco"
		replace industry_name="Other Mineral" if ind_robots=="Other non-metallic mineral products"
		replace industry_name="Metal" if ind_robots=="Basic metals and fabricated metal products"
		replace industry_name="Mining" if ind_robots=="Mining and quarrying"
		replace industry_name="Paper" if ind_robots=="Pulp, paper, paper products, printing and publishing"
		replace industry_name="Chemical" if ind_robots=="Chemical, rubber, plastics and fuel"
		replace industry_name="Textiles" if ind_robots=="Textiles, textile products, leather and footwear"
		replace industry_name="Wood products" if ind_robots=="Wood and products of wood and cork"
		replace industry_name="Other manuf." if ind_robots=="All other manufacturing branches"
		
		if "`2'"=="LaTeX" {
			replace industry_name="Education, R\&D" if ind_robots=="Education/research/development"
		}
		if "`2'"!="LaTeX" {
			replace industry_name="Education, R&D" if ind_robots=="Education/research/development"
		}
	}
	
	if "`1'"=="country" {
		
		cap gen country_name = ""
		
		replace country_name = "Australia" if country=="AUS"
		replace country_name = "Austria" if country=="AUT"
		replace country_name = "Belgium" if country=="BEL"
		replace country_name = "Denmark" if country=="DNK"
		replace country_name = "Spain" if country=="ESP"
		replace country_name = "Finland" if country=="FIN"
		replace country_name = "France" if country=="FRA"
		replace country_name = "Germany" if country=="GER"
		replace country_name = "Greece" if country=="GRC"
		replace country_name = "Hungary" if country=="HUN"
		replace country_name = "Ireland" if country=="IRL"
		replace country_name = "Italy" if country=="ITA"
		replace country_name = "South Korea" if country=="KOR"
		replace country_name = "Netherlands" if country=="NLD"
		replace country_name = "Sweden" if country=="SWE"
		replace country_name = "United Kingdom" if country=="UK"
		replace country_name = "United States" if country=="US"
	}
