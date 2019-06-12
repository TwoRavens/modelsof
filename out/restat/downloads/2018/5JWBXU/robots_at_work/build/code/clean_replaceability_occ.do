* generating replaceability variable at occupation level (1980 employment structure)

u "..\temp\us_census_1980", clear

	drop if ind1990==0 | ind1990>960
	
merge m:1 occ1990 using "..\input\Robot tasks\replaceability_occ_2000" 
	
	tab occ1990 if _merg==1
	
	/* extending replaceability variable to census 1990 occupations that do not 
	appear in 2000 census, but in 1980 census */
	
	replace replaceable = 0 if _mer==1
	
	replace replaceable = 1 if occ1990==717 // Fabricating machine operators, n.e.c.
	replace replaceable = 1 if occ1990==728 // Shaping and joining machine operators
	replace replaceable = 1 if occ1990==768 // Crushing and grinding machine operators
	
	collapse (max) replaceable, by(occ1990)
				
	la var replaceable "occupation is replaceable"
	
sa "..\temp\replaceability_occ_1980", replace
