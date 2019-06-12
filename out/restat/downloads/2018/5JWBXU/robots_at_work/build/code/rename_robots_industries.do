* naming robots industries

gen ind_robots=""
	
	replace ind_robots = "Food products, beverages and tobacco" 				if code_robots=="10-12"
	replace ind_robots = "Textiles, textile products, leather and footwear"	 	if code_robots=="13-15"
	replace ind_robots = "Wood and products of wood and cork"	 				if code_robots=="16"
	replace ind_robots = "Pulp, paper, paper products, printing and publishing" if code_robots=="17-18"
	replace ind_robots = "Chemical, rubber, plastics and fuel" 					if code_robots=="19-22"
	replace ind_robots = "Other non-metallic mineral products"	 				if code_robots=="23"
	replace ind_robots = "Basic metals and fabricated metal products"	 		if code_robots=="24-28"
	replace ind_robots = "Electrical and optical equipment"						if code_robots=="26-27"
	replace ind_robots = "Transport equipment"	 								if code_robots=="29a"
	replace ind_robots = "Other vehicles"	  									if code_robots=="30"
	replace ind_robots = "All other manufacturing branches"	 					if code_robots=="90"
	replace ind_robots = "Agriculture, hunting, forestry and fishing"		 	if code_robots=="A-B"
	replace ind_robots = "Mining and quarrying"	 			 					if code_robots=="C"
	replace ind_robots = "Electricity, gas, water supply"	 					if code_robots=="E"
	replace ind_robots = "Construction"	 										if code_robots=="F"
	replace ind_robots = "All other non-manufacturing branches"					if code_robots=="91"
	replace ind_robots = "Unspecified"	 										if code_robots=="99"
	replace ind_robots = "Education/research/development"						if code_robots=="M"
  