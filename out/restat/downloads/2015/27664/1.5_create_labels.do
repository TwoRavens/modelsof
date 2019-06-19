* VARIABLE LABELS

cap lab var year Year
cap lab var racefull "Detailed race"
cap lab var race "Race constructed"
cap lab var white White
cap lab var black Black
cap lab var hisp Hispanic
cap lab var other "Other race"

cap lab var color "Skin color"
cap lab var coloryear "Year color asked"
cap lab var bxcolor "Black*Color"
cap lab var b1t3 "Black, 1-3"
cap lab var b4 "Black, 4"
cap lab var b5 "Black, 5"
cap lab var b6 "Black, 6"
cap lab var b7 "Black, 7"
cap lab var b8 "Black, 8"
cap lab var b9t10 "Black, 9-10"
cap lab var bl "Black, 1-5"
cap lab var bm "Black, 6-7"
cap lab var bd "Black, 8-10"

cap lab var male "Male"
cap lab var age "Age"
cap lab var region1_ "N. East"
cap lab var region2_ "N. Central"
cap lab var region3_ "South"
cap lab var region4_ "West"
cap lab var region_m "Region missing"
cap lab var msa1_ "Not in MSA"
cap lab var msa2_ "In MSA not city"
cap lab var msa3_ "In MSA, city"
cap lab var msa_m "MSA missing"

cap lab var afqt "AFQT"
cap lab var hgc "HGC"
cap lab var degreenone "< H.S."
cap lab var degree2yr "2-Year"
cap lab var degree4yr "4-Year"
cap lab var degree "Highest degree"
cap lab var hgcever "HGC ever"
cap lab var hdcever "Highest degree ever" 

cap lab var aid_ "Ever gov't aid"
cap lab var aid_m "Aid missing"
cap lab var parents6_ "Live w/ parents, age 6"
cap lab var parents6_m "Parents 6 missing"
cap lab var hgcmom1_ "Mom HGC < H.S."
cap lab var hgcmom3_ "Mom HGC > H.S."
cap lab var hgcmom_m "Mom HGC missing"
cap lab var rural12_ "Rural, age 12"
cap lab var rural12_m "Rural 12 missing"
cap lab var south12_ "South, age 12"
cap lab var south12_m "South 12 missing"
cap lab var povratio_ "Poverty ratio 1997"
cap lab var povratio_m "Poverty ratio missing"

cap lab var intvid		"Interviewer ID"
cap lab var intvwhite_ "White intvwr"
cap lab var intvblack_ "Black intvwr"
cap lab var intvother_ "Other intvwr"
cap lab var intv50_ "Intvwr > 50"
cap lab var intvmale_ "Intvwr male"
cap lab var intv_m "Intvwr info missing"
cap lab var _intv "No interviewer data"

cap lab var wage "Ln real hrly wage"
note wage: Ln real hourly wage in $2010
cap lab var potexp "Potential experience"
cap lab var empwks30 "Weeks employed 30+ hours"
cap lab var wage "Log wage"
cap lab var hrly "Hourly wage"
cap lab var hrs  "Hours worked"
cap lab var tenure "Tenure"
cap lab var ifenr "Enrolled"
cap lab var new_entry "Labor mkt entry year"
cap lab var entryage "Labor mkt entry age"
cap lab var entryhgc "Labor mkt entry HGC"
cap lab var pca1_ "Behaviorial PCA 1"
cap lab var pca2_ "Behaviorial PCA 1"
cap lab var pca_m "Behaviorial PCA missing"
cap lab var height97_ "Height 1997"
cap lab var height97_m "Height missing"
cap lab var weight97_ "Height 1997"
cap lab var weight97_m "Weight missing"

cap lab var nonblack_parent "Any parent not Black only"
cap lab var nonwhite_parent "Any parent not White only"
cap lab var mixed "Black & non-Black parent | White & non-White parent"

forvalues i=1999(1)2009 {
	cap lab var yr`i' "`i'"
}


lab var bl "Black, light"
lab var bm "Black, medium"
lab var bd "Black, dark"




















