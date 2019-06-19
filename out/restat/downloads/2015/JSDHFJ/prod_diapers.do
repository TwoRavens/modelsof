*****************************************************************************
*** prod_diapers.do
***
*****************************************************************************


*** Load product-specific information and read size

capture use Original_Data\Diapers_prod_db, clear

tab producttype l2
keep if producttype=="DISPOSABLE DIAPER" 
drop stubspec1828rc00004 

*** Count ***
gen count=vol_eq

*gen CT = regexs(0) if regexm(l9,"[0-9]CT")==1
*replace CT = regexs(0) if regexm(l9,"[0-9][0-9]CT")==1
*replace CT = regexs(0) if regexm(l9,"[0-9][0-9][0-9]CT")==1
*replace CT = regexs(0) if regexm(l9,"[0-9][0-9][0-9][0-9]CT")==1
*gen int count = real(subinstr(CT,"CT","",1))


gen brand=l5

replace brand = "DRYPERS" 	  					if regexm(brand,"^DRYPERS") & regexm(l4,"^ASSG")
replace brand = "FITTI" 	  					if regexm(brand,"^FITTI") & regexm(l4,"^ASSG")
replace brand = "HUGGIES" 	  					if regexm(brand,"^HUGGIES") & regexm(l4,"^KIMBERLY")
replace brand = "LUVS" 	  						if regexm(brand,"^LUVS") & regexm(l4,"^PROCTER")
replace brand = "PAMPERS" 	  					if regexm(brand,"^PAMPERS") & regexm(l4,"^PROCTER")
replace brand = "CUDDLES" 	  					if regexm(brand,"CUDDLES") & regexm(l4,"^UNIV")



*********************************************
gen lastword=word(l9,-1)
gen product = rtrim(subinstr(l9,lastword,"",1))
*********************************************


*********************************************
*********************************************
**************    stagephase     ************ 
**************    Incl. in Def.  ************
*********************************************
*********************************************

gen abbrSTG=word(product,2) if stagephase!="MISSING"
replace abbrSTG=word(product,3) if abbrSTG=="*"
*bysort stagephase: tab abbrSTG

* 1 one stage 2 was recorded as stage 1 *
drop abbrSTG

*********************************************
*********************************************
**************    flavorscent    ************ 
**************    irrelevant 	 ************
*********************************************
*********************************************

*tab flavorscent


*********************************************
*********************************************
**************    weight	     ************ 
**************              	 ************
*********************************************
*********************************************
encode weightofbaby, gen(babyweight)
mvdecode babyweight, mv(36)
decode babyweight, gen(weightbaby)
drop babyweight

*********************************************
*********************************************
**************    color	     	 ************ 
**************              	 ************
*********************************************
*********************************************
encode color, gen(colour)
mvdecode colour, mv(4)
decode colour, gen (colourstr)
drop colour



*********************************************
*********************************************
**************    thickness	   	 ************ 
**************              	 ************
*********************************************
*********************************************
encode thickness, gen(thick)
mvdecode thick, mv(6)
decode thick, gen (thickstr)
drop thick


*********************************************
*********************************************
**************    userinfo	   	 ************ 
**************    inc in def     ************
*********************************************
*********************************************
gen abbrBOY=regexm(product,"BOY")
gen abbrGIRL=regexm(product,"GIRL")
gen abbrBYGRL=regexm(product,"BYGRL")

drop abbr*


********************************************************
*************							****************
*************   Definition of a product ****************
*************							****************
********************************************************

*** All strings ****
gen product1=product+" - "+(weightbaby)+"-"+(colourstr)+"-"+(thickstr)
encode product1, gen(prodcode)
codebook prodcode
replace product=product1
sort product1 count
keep upc count product1 prodcode  brand
sort upc
isid upc product1

sort prodcode


