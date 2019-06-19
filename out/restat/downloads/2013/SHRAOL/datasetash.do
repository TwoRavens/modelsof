/*Full dataset: directory DATA*/
clear
capture log close
set matsize 800
set memory 4g
set more off
log using datasetash.log, replace

use mayash200m, clear
local quarters "300 400 101 201 301 401 102 202 302 402 103 203 303 403"
foreach quarter of local quarters {
	append using mayash`quarter'm
}
compress

/*Generating a total migration variable*/
gen binmigr = binmigrp
replace binmigr = 1 if binmigrt == 1

forvalues n = 2/4 {
	gen binmigr`n' = binmigrp`n'
	replace binmigr`n' = 1 if binmigrt`n' == 1
}

/*Creating labels for the Mexican states*/
generate nent = real(ENT)
label values nent states
lab def states 1 "Aguascalientes"
lab def states 2 "Baja California", add
lab def states 3 "Baja California Sur", add
lab def states 4 "Campeche", add
lab def states 5 "Coahuila", add
lab def states 6 "Colima", add
lab def states 7 "Chiapas", add
lab def states 8 "Chihuahua", add
lab def states 9 "Distrito Federal", add
lab def states 10 "Durango", add
lab def states 11 "Guanajuato", add
lab def states 12 "Guerrero", add
lab def states 13 "Hidalgo", add
lab def states 14 "Jalisco", add
lab def states 15 "México", add
lab def states 16 "Michoacán", add
lab def states 17 "Morelos", add
lab def states 18 "Nayarit", add
lab def states 19 "Nuevo León", add
lab def states 20 "Oaxaca", add
lab def states 21 "Puebla", add
lab def states 22 "Querétaro", add
lab def states 23 "Quintana Roo", add
lab def states 24 "San Luis Potosí", add
lab def states 25 "Sinaloa", add
lab def states 26 "Sonora", add
lab def states 27 "Tabasco", add
lab def states 28 "Tamaulipas", add
lab def states 29 "Tlaxcala", add
lab def states 30 "Veracruz", add
lab def states 31 "Yucatán", add
lab def states 32 "Zacatecas", add

/*Creating the schooling variables*/
/*Create schooling years variable*/
gen schoolyears = 0
replace schoolyears = . if real(ESC) == 99000
replace schoolyears = 3 if real(ESC) == 96000
replace schoolyears = 1 if real(ESC) == 11000
replace schoolyears = 2 if real(ESC) == 12000
replace schoolyears = 3 if real(ESC) == 13000
replace schoolyears = 4 if real(ESC) == 14000
replace schoolyears = 5 if real(ESC) == 15000
replace schoolyears = 6 if real(ESC) == 16000
replace schoolyears = 7.5 if real(ESC) == 17000
replace schoolyears = 3 if real(ESC) == 19000
replace schoolyears = 7.5 if match(ESC,"1N000") == 1
replace schoolyears = 9 if match(ESC,"1T000") == 1
replace schoolyears = 7 if real(ESC) == 21000
replace schoolyears = 8 if real(ESC) == 22000
replace schoolyears = 9 if real(ESC) == 23000
replace schoolyears = 7.5 if real(ESC) == 29000
replace schoolyears = 10.5 if match(substr(ESC,1,2),"2N") == 1
replace schoolyears = 12 if match(substr(ESC,1,2),"2T") == 1
replace schoolyears = 10 if real(ESC) == 31000
replace schoolyears = 11 if real(ESC) == 32000
replace schoolyears = 12 if real(ESC) == 33000
replace schoolyears = 11.5 if real(ESC) == 39000
replace schoolyears = 13.5 if match(substr(ESC,1,2),"3N") == 1
replace schoolyears = 15 if match(substr(ESC,1,2),"3T") == 1
replace schoolyears = 13 if match(substr(ESC,1,2),"41") == 1
replace schoolyears = 14 if match(substr(ESC,1,2),"42") == 1
replace schoolyears = 15 if match(substr(ESC,1,2),"43") == 1
replace schoolyears = 16 if match(substr(ESC,1,2),"44") == 1
replace schoolyears = 17 if match(substr(ESC,1,2),"45") == 1
replace schoolyears = 17 if match(substr(ESC,1,2),"4T") == 1
replace schoolyears = 18 if match(substr(ESC,1,2),"51") == 1
replace schoolyears = 19 if match(substr(ESC,1,2),"52") == 1
replace schoolyears = 20 if match(substr(ESC,1,2),"53") == 1
replace schoolyears = 20 if match(substr(ESC,1,2),"5T") == 1
replace schoolyears = 21 if match(substr(ESC,1,2),"61") == 1
replace schoolyears = 22 if match(substr(ESC,1,2),"62") == 1
replace schoolyears = 23 if match(substr(ESC,1,2),"63") == 1
replace schoolyears = 23 if match(substr(ESC,1,2),"6T") == 1

/*Sexo*/
gen mujer = 0
replace mujer = 1 if real(SEX) == 2

/*Married*/
gen married = 0
replace married = . if real(E_CIV) == 9
replace married = 1 if real(E_CIV) == 2
replace married = 1 if real(E_CIV) == 3

/*Labor force participation*/
gen laborforce = 0
/*People who work*/
replace laborforce = 1 if real(P3) > 0
/*People who looked for work in the last month*/
replace laborforce = 1 if real(P2B1_2) == 1
/*People who looked for work in the last two months and are ready to join a firm*/
replace laborforce = 1 if (real(P2B1_2) == 2 & real(P2C) ~= 1 & real(P2C) ~= 8)

/*Unemployed*/
gen paro = 0
replace paro = 1 if (laborforce == 1 & real(P3)==0)

/*Grouping the age variable*/
destring EDA, generate(edad) force
gen agegroup = .
replace agegroup = 1 if (edad >= 12 & edad < 18)
replace agegroup = 2 if (edad > 17 & edad < 28)
replace agegroup = 3 if (edad > 27 & edad < 38)
replace agegroup = 4 if (edad > 37 & edad < 48)
replace agegroup = 5 if (edad > 47 & edad < 58)
replace agegroup = 6 if (edad > 57 & edad < 68)
replace agegroup = 7 if (edad > 67 & edad < 98)

label values agegroup age
lab def age 1 "12 to 17"
lab def age 2 "18 to 27", add
lab def age 3 "28 to 37", add
lab def age 4 "38 to 47", add
lab def age 5 "48 to 57", add
lab def age 6 "58 to 67", add
lab def age 7 "68 or more", add

/*Grouping the schooling variable*/
gen schoolgroup = .
replace schoolgroup = 1 if schoolyears == 0
replace schoolgroup = 2 if (schoolyears > 0 & schoolyears < 5)
replace schoolgroup = 3 if (schoolyears >= 5 & schoolyears < 9)
replace schoolgroup = 4 if (schoolyears >= 9 & schoolyears < 12)
replace schoolgroup = 5 if (schoolyears >= 12 & schoolyears < 16)
replace schoolgroup = 6 if schoolyears >= 16

label values schoolgroup schooling
lab def schooling 1 "None"
lab def schooling 2 "1 to 4", add
lab def schooling 3 "5 to 8", add
lab def schooling 4 "9 to 11", add
lab def schooling 5 "12 to 15", add
lab def schooling 6 "16 or plus", add

/*Municipios*/
gen municipio = ENT + MUN

/*Dummy de area metropolitana*/
gen ametdum = 0
replace ametdum = 1 if strmatch("09010",municipio) == 1
replace ametdum = 1 if strmatch("09002",municipio) == 1
replace ametdum = 1 if strmatch("09014",municipio) == 1
replace ametdum = 1 if strmatch("09003",municipio) == 1
replace ametdum = 1 if strmatch("09004",municipio) == 1
replace ametdum = 1 if strmatch("09015",municipio) == 1
replace ametdum = 1 if strmatch("09005",municipio) == 1
replace ametdum = 1 if strmatch("09006",municipio) == 1
replace ametdum = 1 if strmatch("09007",municipio) == 1
replace ametdum = 1 if strmatch("09008",municipio) == 1
replace ametdum = 1 if strmatch("09016",municipio) == 1
replace ametdum = 1 if strmatch("09009",municipio) == 1
replace ametdum = 1 if strmatch("09011",municipio) == 1
replace ametdum = 1 if strmatch("09012",municipio) == 1
replace ametdum = 1 if strmatch("09017",municipio) == 1
replace ametdum = 1 if strmatch("09013",municipio) == 1
replace ametdum = 1 if strmatch("15002",municipio) == 1
replace ametdum = 1 if strmatch("15011",municipio) == 1
replace ametdum = 1 if strmatch("15013",municipio) == 1
replace ametdum = 1 if strmatch("15020",municipio) == 1
replace ametdum = 1 if strmatch("15024",municipio) == 1
replace ametdum = 1 if strmatch("15025",municipio) == 1
replace ametdum = 1 if strmatch("15028",municipio) == 1
replace ametdum = 1 if strmatch("15029",municipio) == 1
replace ametdum = 1 if strmatch("15030",municipio) == 1
replace ametdum = 1 if strmatch("15031",municipio) == 1
replace ametdum = 1 if strmatch("15033",municipio) == 1
replace ametdum = 1 if strmatch("15037",municipio) == 1
replace ametdum = 1 if strmatch("15039",municipio) == 1
replace ametdum = 1 if strmatch("15044",municipio) == 1
replace ametdum = 1 if strmatch("15053",municipio) == 1
replace ametdum = 1 if strmatch("15057",municipio) == 1
replace ametdum = 1 if strmatch("15058",municipio) == 1
replace ametdum = 1 if strmatch("15059",municipio) == 1
replace ametdum = 1 if strmatch("15060",municipio) == 1
replace ametdum = 1 if strmatch("15069",municipio) == 1
replace ametdum = 1 if strmatch("15070",municipio) == 1
replace ametdum = 1 if strmatch("15081",municipio) == 1
replace ametdum = 1 if strmatch("15091",municipio) == 1
replace ametdum = 1 if strmatch("15092",municipio) == 1
replace ametdum = 1 if strmatch("15093",municipio) == 1
replace ametdum = 1 if strmatch("15095",municipio) == 1
replace ametdum = 1 if strmatch("15099",municipio) == 1
replace ametdum = 1 if strmatch("15100",municipio) == 1
replace ametdum = 1 if strmatch("15104",municipio) == 1
replace ametdum = 1 if strmatch("15108",municipio) == 1
replace ametdum = 1 if strmatch("15109",municipio) == 1
replace ametdum = 1 if strmatch("15120",municipio) == 1
replace ametdum = 1 if strmatch("15121",municipio) == 1
replace ametdum = 1 if strmatch("15122",municipio) == 1
replace ametdum = 1 if strmatch("24028",municipio) == 1
replace ametdum = 1 if strmatch("24035",municipio) == 1
replace ametdum = 1 if strmatch("11020",municipio) == 1
replace ametdum = 1 if strmatch("11031",municipio) == 1
replace ametdum = 1 if strmatch("14039",municipio) == 1
replace ametdum = 1 if strmatch("14070",municipio) == 1
replace ametdum = 1 if strmatch("14097",municipio) == 1
replace ametdum = 1 if strmatch("14098",municipio) == 1
replace ametdum = 1 if strmatch("14101",municipio) == 1
replace ametdum = 1 if strmatch("14120",municipio) == 1
replace ametdum = 1 if strmatch("08019",municipio) == 1
replace ametdum = 1 if strmatch("19006",municipio) == 1
replace ametdum = 1 if strmatch("19018",municipio) == 1
replace ametdum = 1 if strmatch("19019",municipio) == 1
replace ametdum = 1 if strmatch("19021",municipio) == 1
replace ametdum = 1 if strmatch("19026",municipio) == 1
replace ametdum = 1 if strmatch("19031",municipio) == 1
replace ametdum = 1 if strmatch("19039",municipio) == 1
replace ametdum = 1 if strmatch("19046",municipio) == 1
replace ametdum = 1 if strmatch("19048",municipio) == 1
replace ametdum = 1 if strmatch("28003",municipio) == 1
replace ametdum = 1 if strmatch("28009",municipio) == 1
replace ametdum = 1 if strmatch("28038",municipio) == 1
replace ametdum = 1 if strmatch("30123",municipio) == 1
replace ametdum = 1 if strmatch("30133",municipio) == 1
replace ametdum = 1 if strmatch("10007",municipio) == 1
replace ametdum = 1 if strmatch("10012",municipio) == 1
replace ametdum = 1 if strmatch("05035",municipio) == 1
replace ametdum = 1 if strmatch("21015",municipio) == 1
replace ametdum = 1 if strmatch("21034",municipio) == 1
replace ametdum = 1 if strmatch("21041",municipio) == 1
replace ametdum = 1 if strmatch("21090",municipio) == 1
replace ametdum = 1 if strmatch("21106",municipio) == 1
replace ametdum = 1 if strmatch("21114",municipio) == 1
replace ametdum = 1 if strmatch("21119",municipio) == 1
replace ametdum = 1 if strmatch("21125",municipio) == 1
replace ametdum = 1 if strmatch("21136",municipio) == 1
replace ametdum = 1 if strmatch("21140",municipio) == 1
replace ametdum = 1 if strmatch("21181",municipio) == 1
replace ametdum = 1 if strmatch("30028",municipio) == 1
replace ametdum = 1 if strmatch("30193",municipio) == 1
replace ametdum = 1 if strmatch("30014",municipio) == 1
replace ametdum = 1 if strmatch("30030",municipio) == 1
replace ametdum = 1 if strmatch("30044",municipio) == 1
replace ametdum = 1 if strmatch("30068",municipio) == 1
replace ametdum = 1 if strmatch("30074",municipio) == 1
replace ametdum = 1 if strmatch("30081",municipio) == 1
replace ametdum = 1 if strmatch("30085",municipio) == 1
replace ametdum = 1 if strmatch("30101",municipio) == 1
replace ametdum = 1 if strmatch("30115",municipio) == 1
replace ametdum = 1 if strmatch("30118",municipio) == 1
replace ametdum = 1 if strmatch("30135",municipio) == 1
replace ametdum = 1 if strmatch("30138",municipio) == 1
replace ametdum = 1 if strmatch("31041",municipio) == 1
replace ametdum = 1 if strmatch("31050",municipio) == 1
replace ametdum = 1 if strmatch("31059",municipio) == 1
replace ametdum = 1 if strmatch("31101",municipio) == 1

/*Generate years and quarters*/
gen year = 2000 + real(substr(PER,2,2))
replace year = . if year < 2000
replace year = . if year > 2004
gen quarter = real(substr(PER,1,1))

/*Mexican regions: follow Ibarraran and Lubotsky (2006)*/
gen region = .
/*Central Mexico: Aguascalientes, Colima, Durango, Guanajuato, Hidalgo, Jalisco, Michoacán de Ocampo, Morelos, Nayarit,
Puebla, Querétaro de Arteaga, San Luis Potosí, Sinaloa, and Tlaxcala and Zacatecas (not included in I-L 2006)*/
replace region = 1 if nent == 1
replace region = 1 if nent == 6
replace region = 1 if nent == 10
replace region = 1 if nent == 11
replace region = 1 if nent == 13
replace region = 1 if nent == 14
replace region = 1 if nent == 16
replace region = 1 if nent == 17
replace region = 1 if nent == 18
replace region = 1 if nent == 21
replace region = 1 if nent == 22
replace region = 1 if nent == 24
replace region = 1 if nent == 25
replace region = 1 if nent == 29
replace region = 1 if nent == 32
/*Southern Mexico: Campeche, Chiapas, Guerrero, Oaxaca, Quintana Roo, Tabasco,
Veracruz-Llave, and Yucatán*/
replace region = 2 if nent == 4
replace region = 2 if nent == 7
replace region = 2 if nent == 12
replace region = 2 if nent == 20
replace region = 2 if nent == 23
replace region = 2 if nent == 27
replace region = 2 if nent == 30
replace region = 2 if nent == 31
/*Northern Mexico: Baja California, Baja California Sur, Coahuila de
Zaragoza, Chihuahua, Nuevo León, Sonora and Tamaulipas*/
replace region = 3 if nent == 2
replace region = 3 if nent == 3
replace region = 3 if nent == 5
replace region = 3 if nent == 8
replace region = 3 if nent == 19
replace region = 3 if nent == 26
replace region = 3 if nent == 28
/*Mexico City and state: D.F. and Mexico*/
replace region = 4 if nent == 9
replace region = 4 if nent == 15

/*Subregions subdivision*/
gen subregion = .
/*Northwest: Baja California, Baja California Sur, Chihuahua, Durango, Sinaloa and Sonora*/
replace subregion = 1 if nent == 2
replace subregion = 1 if nent == 3
replace subregion = 1 if nent == 8
replace subregion = 1 if nent == 10
replace subregion = 1 if nent == 25
replace subregion = 1 if nent == 26
/*Northeast: Coahuila, Nuevo Leon and Tamaulipas*/
replace subregion = 2 if nent == 5
replace subregion = 2 if nent == 19
replace subregion = 2 if nent == 28
/*Center: Aguascalientes, Guanajuato, Queretaro, San Luis Potosi and Zacatecas*/
replace subregion = 3 if nent == 1
replace subregion = 3 if nent == 11
replace subregion = 3 if nent == 22
replace subregion = 3 if nent == 24
replace subregion = 3 if nent == 32
/*West: Colima, Jalisco, Michoacan and Nayarit*/
replace subregion = 4 if nent == 6
replace subregion = 4 if nent == 14
replace subregion = 4 if nent == 16
replace subregion = 4 if nent == 18
/*East: Hidalgo, Puebla, Veracruz and Tlaxcala*/
replace subregion = 5 if nent == 13
replace subregion = 5 if nent == 21
replace subregion = 5 if nent == 29
replace subregion = 5 if nent == 30
/*Center South: D.F., Mexico and Morelos*/
replace subregion = 6 if nent == 9
replace subregion = 6 if nent == 15
replace subregion = 6 if nent == 17
/*South: Chiapas, Guerrero and Oaxaca*/
replace subregion = 7 if nent == 7
replace subregion = 7 if nent == 12
replace subregion = 7 if nent == 20
/*South East: Campeche, Quintana Roo, Tabasco and Yucatan*/
replace subregion = 8 if nent == 4
replace subregion = 8 if nent == 23
replace subregion = 8 if nent == 27
replace subregion = 8 if nent == 31

label values region regions
lab def regions 1 "Central Mexico"
lab def regions 2 "Southern Mexico", add
lab def regions 3 "Northern Mexico", add
lab def regions 4 "Mexico City and state", add

label values subregion subregions
lab def subregions 1 "Northwest", add
lab def subregions 2 "Northeast", add
lab def subregions 3 "Center", add
lab def subregions 4 "West", add
lab def subregions 5 "East", add
lab def subregions 6 "Center South", add
lab def subregions 7 "South", add
lab def subregions 8 "South East", add

/*Creating the wage variable as hourly wages following Chiquiar and Hanson (2005)*/
gen hwage = .
replace hwage = real(P7A_2)/(4.5*real(P6_1)) if (real(P7A_2) < 999999 & real(P7A_2) > 0)
/*Erase wage observations from people who did not work in the previous week*/
replace hwage = . if real(P7A_1) == 6
/*Erase people who work less than 20 or more than 84 hours a week*/
replace hwage = . if real(P6_1) < 20
replace hwage = . if real(P6_1) > 84
/*Erase observations for people who worked in the US*/
replace hwage = . if real(P5) == 7

/*Erase wage observations from people qualified as unemployed or not in the labor force*/
replace hwage = . if paro == 1
replace hwage = . if laborforce == 0

/*Calculate the percentage of wage earners in the data*/
gen wageearner = 0
replace wageearner = 1 if hwage ~= .
replace wageearner = . if laborforce ~=1

/*Create real wage series (1 January 2006 dollars) Exchange rate from IFS=10.7777*/
/*Use inflation data from the INPC series in Banxico (quarterly averages base June 2002) and bring them to December 2005=116.301*/
gen rhwage = 0
replace rhwage = (hwage*116.301)/(10.7777*88.88073) if real(PER) == 200
replace rhwage = (hwage*116.301)/(10.7777*90.23838) if real(PER) == 300
replace rhwage = (hwage*116.301)/(10.7777*92.32166) if real(PER) == 400
replace rhwage = (hwage*116.301)/(10.7777*93.92162) if real(PER) == 101
replace rhwage = (hwage*116.301)/(10.7777*94.99226) if real(PER) == 201
replace rhwage = (hwage*116.301)/(10.7777*95.63867) if real(PER) == 301
replace rhwage = (hwage*116.301)/(10.7777*97.14296) if real(PER) == 401
replace rhwage = (hwage*116.301)/(10.7777*98.37834) if real(PER) == 102
replace rhwage = (hwage*116.301)/(10.7777*99.52692) if real(PER) == 202
replace rhwage = (hwage*116.301)/(10.7777*100.6597) if real(PER) == 302
replace rhwage = (hwage*116.301)/(10.7777*102.3327) if real(PER) == 402
replace rhwage = (hwage*116.301)/(10.7777*103.7293) if real(PER) == 103
replace rhwage = (hwage*116.301)/(10.7777*104.243) if real(PER) == 203
replace rhwage = (hwage*116.301)/(10.7777*104.7553) if real(PER) == 303
replace rhwage = (hwage*116.301)/(10.7777*106.3983) if real(PER) == 403
replace rhwage = (hwage*116.301)/(10.7777*108.2127) if real(PER) == 104
replace rhwage = (hwage*116.301)/(10.7777*108.712) if real(PER) == 204
replace rhwage = (hwage*116.301)/(10.7777*109.773) if real(PER) == 304

_pctile rhwage [pw=FAC], percentiles(.5 99.5)

/* Suppressing the .5% largest and smallest values following Hanson (2006)*/
replace rhwage = . if rhwage < r(r1)
replace rhwage = . if rhwage > r(r2)

/*Creating the monthly wage variable*/
gen mwage = .
replace mwage = real(P7A_2) if (real(P7A_2) < 999999 & real(P7A_2) > 0)
/*Erase wage observations from people who did not work in the previous week*/
replace mwage = . if real(P7A_1) == 6
/*Erase people who work less than 20 or more than 84 hours a week*/
replace mwage = . if real(P6_1) < 20
replace mwage = . if real(P6_1) > 84
/*Erase observations for people who worked in the US*/
replace mwage = . if real(P5) == 7

/*Erase wage observations from people qualified as unemployed or not in the labor force*/
replace mwage = . if paro == 1
replace mwage = . if laborforce == 0

/*Create real wage series (1 January 2006 dollars) Exchange rate from IFS=10.7777*/
/*Use inflation data from the INPC series in Banxico (quarterly averages base June 2002) and bring them to December 2005=116.301*/
gen rmwage = 0
replace rmwage = (mwage*116.301)/(10.7777*88.88073) if real(PER) == 200
replace rmwage = (mwage*116.301)/(10.7777*90.23838) if real(PER) == 300
replace rmwage = (mwage*116.301)/(10.7777*92.32166) if real(PER) == 400
replace rmwage = (mwage*116.301)/(10.7777*93.92162) if real(PER) == 101
replace rmwage = (mwage*116.301)/(10.7777*94.99226) if real(PER) == 201
replace rmwage = (mwage*116.301)/(10.7777*95.63867) if real(PER) == 301
replace rmwage = (mwage*116.301)/(10.7777*97.14296) if real(PER) == 401
replace rmwage = (mwage*116.301)/(10.7777*98.37834) if real(PER) == 102
replace rmwage = (mwage*116.301)/(10.7777*99.52692) if real(PER) == 202
replace rmwage = (mwage*116.301)/(10.7777*100.6597) if real(PER) == 302
replace rmwage = (mwage*116.301)/(10.7777*102.3327) if real(PER) == 402
replace rmwage = (mwage*116.301)/(10.7777*103.7293) if real(PER) == 103
replace rmwage = (mwage*116.301)/(10.7777*104.243) if real(PER) == 203
replace rmwage = (mwage*116.301)/(10.7777*104.7553) if real(PER) == 303
replace rmwage = (mwage*116.301)/(10.7777*106.3983) if real(PER) == 403
replace rmwage = (mwage*116.301)/(10.7777*108.2127) if real(PER) == 104
replace rmwage = (mwage*116.301)/(10.7777*108.712) if real(PER) == 204
replace rmwage = (mwage*116.301)/(10.7777*109.773) if real(PER) == 304

_pctile rmwage [pw=FAC], percentiles(.5 99.5)

/* Suppressing the .5% largest and smallest values following Hanson (2006)*/
replace rmwage = . if rmwage < r(r1)
replace rmwage = . if rmwage > r(r2)

gen lmwage = log(rmwage)
gen lhwage = log(rhwage)

save datasetash, replace
