*****************************************************************************
*** prod_blades.do
***
*****************************************************************************

*** Load product-specific information and read size

capture use "Original_Data\Blades_prod_db", clear


tab producttype l2 /* Maybe pool one pice with disposable */
keep if l2=="CARTRIDGES" 

*** Count ***
gen CT = regexs(0) if regexm(l9,"[0-9]CT")==1
replace CT = regexs(0) if regexm(l9,"[0-9][0-9]CT")==1
replace CT = regexs(0) if regexm(l9,"[0-9][0-9][0-9]CT")==1
replace CT = regexs(0) if regexm(l9,"[0-9][0-9][0-9][0-9]CT")==1


gen int count = real(subinstr(CT,"CT","",1))


gen brand=l5

replace brand = "GILLETTE" 	  	if regexm(brand,"GILLETTE")
replace brand = "BIC" 		  	if regexm(brand,"BIC") 
replace brand = "BUENOS DIAS" 	if regexm(brand,"BUENOS DIAS")
replace brand = "GEM" 		  	if regexm(brand,"GEM") 
replace brand = "PERSONNA" 	  	if regexm(brand,"PERSONNA")
replace brand = "NOXZEMA" 	  	if regexm(brand,"NOXZEMA")
replace brand = "OLD SPICE"   	if regexm(brand,"OLD SPICE")
replace brand = "SCHICK"	  	if regexm(brand,"SCHICK")
replace brand = "SHAVEMATE"		if regexm(brand,"SHAVEMATE")
replace brand = "SUPERMAX"		if regexm(brand,"SUPER")
replace brand = "WILKINSON"		if regexm(brand,"WILKINSON")


gen productline=rtrim(subinstr(l5,brand,"",1))

*********************************************
gen product = rtrim(subinstr(l9,CT,"",1))
*********************************************

gen abbr1=regexm(product, "CRTRG") if producttype=="RAZOR CARTRIDGE"
gen abbr2=regexm(product, "RZBD") if producttype=="RAZOR BLADE"
drop abbr1  abbr2

************************************************************

*egen NumDiffPacks=count(count), by(product)
*drop if NumDiffPacks ==1


*** Form already included in definition ***
tab form


*** Mechanism ***
encode mechanism, gen(mech)
mvdecode mech, mv(5)
decode mech, gen(mechstr)
gen abbr=regexm(product, "PVTNG")

tab mechstr abbr

drop abbr mech mechanism
rename mechstr mechanism


*********************************************
replace product=subinstr(product,"PVTNG","",1)
*********************************************

*** shape ***
tab shape /* 80% missing */
encode shape, gen(nshape)
mvdecode nshape, mv(2)
decode nshape, gen(shapestr)

drop nshape shape
rename shapestr shape


*** treatment ****
tab treatment /* all are private labels*/


********************************************************
*************							****************
*************   Definition of a product ****************
*************							****************
********************************************************

*** All strings ****
gen product1=product+" - "+(mechanism)+"-"+(shape)
encode product1, gen(prodcode)
codebook prodcode

********************************************************
********************************************************

replace product=product1

sort product1 count


keep upc count product1 prodcode package brand
label variable package "package type"
label variable product1 "product description, and mechanism"

sort upc
isid upc product1


encode package, gen(packagecode)
egen sdpackagecode=sd(packagecode), by (prodcode)
egen sdpackagecode_size=sd(packagecode), by (prodcode count)
label var sdpackagecode "if greater than 0 then a product line comes in different packages"
label variable sdpackagecode_size "if greater than 0 then a specific size comes in different packages"
gen sdpackagecode_size_dum=sdpackagecode_size>0 & sdpackagecode_size!=.
label var sdpackagecode_size_dum "1 if a pack comes in different packages in general"

sort prodcode



