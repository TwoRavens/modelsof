use "/Users/efetokdemir/Downloads/bdm2s2_nation_year_data_may2002.dta"
keep ccode year Legselec xrcomp xropen parcomp S W WoverS RegimeType
gen S=Legselec/2
gen W=0
replace W=W+1 if (xrcomp>=2)
replace W=W+1 if (xropen>2)
replace W=W+1 if parcomp==5
gen W_extend = W
replace W=W + 1 if (RegimeType~=. & RegimeType~=2 & RegimeType~=3)
replace W=W/4
gen WoverS=W/(log((S+1)*10)/3)
