/*===========================================================================
Replication code for: 
"Using Violence, Seeking Votes: Introducing the Militant Group Electoral 
Participation (MGEP) Dataset"
Aila M. Matanock
---------------------------------------------------------------------------
Creation Date: February 11, 2015 
Modification Date: June 20 , 2016
Do-file version: 06
Output: Database, Descriptive Statistics, Map and Figures
===========================================================================*/

/*===============================================================================================
                                  0: Program set up
===============================================================================================*/
drop _all
set more off, perm

/* NOTE: Users will need to create three folders and set them to excel, root, and results, 
		 and will need to place MGEP_S2016 in the folder defined as global "excel" and top.tex and bot.tex 
		 (from tabout command in Stata --see http://www.ianwatson.com.au/stata/tabout_tutorial.pdf) 
		 in the folder defined as global "results". Here is a brief description of the contents of each folder
		 
	1. "root": contains all original and generated Stata data files. 
	2. "results": contains all figures and files saved in excel formats.
	3. "excel": contains all raw datasets saved as excel files. 
*/

* Directory Paths -- Copy and paste directory paths to desired folders

global root        "mydirectorypath1"
global results     "mydirectorypath2"
global excel	   "mydirectorypath3"

/*===============================================================================================
                             1: Cleanning and producgin master dataset 
===============================================================================================*/

import delimited using "$excel/MGEP_S2016_Release.csv", varnames(1) case(lower) clear 
drop v25

* Number of militant groups participating in at least one type of electoral participation between 1970 and 2010

* Information in the paper

preserve
	keep if year >=1970 & year <=2010
	collapse (sum) part, by(groupid)
	count 
restore

preserve
	keep if year >=1970 & year <=2010
	tab viop
	collapse (sum) viop, by(groupid)
	count if viop>0 & viop<. 
restore

preserve
	keep if year >=1970 & year <=2010
	tab peacep
	collapse (sum) peacep, by(groupid)
	count if peacep>0 & peacep<. 
restore

preserve
	keep if year >=1970 & year <=2010
	tab winner
	collapse (sum) winner, by(groupid)
	count if winner>0 & winner<. 
restore

*------------------------------------1.1: Cleaning variables ------------------------------------
format %-100s name

encode region, gen(region_code)
lab var name "Name of group or organization"
lab var year "Date of elections (year)"

* Cleaning month

replace month="" if month=="-99" | month=="."
egen month_1 = ends(month), punct(,) h
egen month_2aux = ends(month), punct(,) trim t
egen month_2 = ends(month_2aux), punct(,) h
egen month_3 = ends(month_2aux), punct(,) t
drop month_2aux

* Cleaning base states 
clonevar original_state=basestate
lab var original_state "Original base state involved (original name)"
lab var basestate "Original base state involved (current name)"

replace basestate = "Democratic Republic of the Congo" if original_state=="Democratic Republic of Congo"
replace basestate = "Bosnia and Herzegovina" if original_state=="Bosnia & Herzegovina"
replace basestate = "Myanmar" if original_state=="Buma"
replace basestate = "Myanmar" if original_state=="Burma"
replace basestate = "Republic of Congo" if original_state=="Congo (Brazzaville)"
replace basestate = "Croatia" if original_state=="Croatia (Yugoslavia)"
replace basestate = "Germany,Belgium" if original_state=="Germany, Belgium?"
replace basestate = "Haiti, United States of America" if original_state=="Haiti, United States"
replace basestate = "Indonesia" if original_state=="Indonesia/Papua"
replace basestate = "Israel" if original_state=="Israel/Palestinian Territories"
replace basestate = "Pakistan" if original_state=="Pakistan "
replace basestate = "Israel" if original_state=="Palestine"
replace basestate = "Israel" if original_state=="Israel/Palestine"
replace basestate = "Namibia" if original_state=="Namibia/South West Africa"
replace basestate = "Kosovo, Serbia, Montenegro" if original_state=="Kosovo/Serbia & Montenegro/Yugoslavia"
replace basestate = "United Kingdom" if original_state=="Northern Ireland/United Kingdom"
replace basestate = "Pakistan" if original_state=="Pakistan,Baluchistan"
replace basestate = "Russia" if original_state=="Russia "
replace basestate = "Russia,Armenia" if original_state == "Russia/Armenia"
replace basestate = "Azerbaijan,Russia" if original_state == "Russia/Azerbaijan"
replace basestate = "Russia" if original_state == "Russia/Chechnya"
replace basestate = "Russia" if original_state == "Russia/Chechnya/Dagestan"
replace basestate = "Russia" if original_state == "Russia/Dagestan"
replace basestate = "Russia" if original_state == "Russia/North Ossetia"
replace basestate = "Russia,Tajikistan" if original_state == "Russia/Tajikistan"
replace basestate = "United Kingdom" if original_state=="UK"
replace basestate = "Uganda,Democratic Republic of the Congo" if original_state=="Uganda, DRC"
replace basestate = "United Kingdom, United States of America, Canada" if original_state=="United Kingdom, US, Canada"
replace basestate = "United States of America" if original_state=="United States/Puerto Rico"
replace basestate = "United States of America" if original_state=="United States"
replace basestate = "United States of America, Portugal, Canada, New Zeland" if original_state=="United States, Portugal, Canada, New Zealand "
replace basestate = "Bosnia and Herzegovina" if original_state=="Yugoslavia/Bosnia & Herzegovina"
replace basestate = "Slovenia" if original_state=="Yugoslavia/Slovenia"
replace basestate = "United States of America" if original_state=="united States"
replace basestate = "Zimbabwe" if original_state=="Zimbabwe (Rhodesia)"
replace basestate = "Djibouti,Somalia" if original_state=="Djibouti/Somalia"
replace basestate = "France,Djibouti,Somalia" if original_state=="France/Djibouti/Somalia"
replace basestate = "France, Guadeloupe" if original_state=="France/Guadeloupe"
replace basestate = "Guinea-Bissau" if original_state=="Guinea-Bissau "
replace basestate = "India" if original_state == "India/ Bodoland"
replace basestate = "India" if original_state == "India/Andhra Pradesh"
replace basestate = "India" if original_state == "India/Assam"
replace basestate = "India" if original_state == "India/Assam/Manipur"
replace basestate = "India" if original_state == "India/Assam/Meghalaya"
replace basestate = "India" if original_state == "India/Kashmir"
replace basestate = "India" if original_state == "India/Manipur"
replace basestate = "India" if original_state == "India/Nagaland"
replace basestate = "India" if original_state == "India/Punjab"
replace basestate = "India" if original_state == "India/Punjab/Khalistan"
replace basestate = "India" if original_state == "India/Tripura"
replace basestate = "India" if original_state == "India/West Bengal/Assam"
replace basestate = "Indonesia,East Timor" if original_state == "Indonesia/East Timor"
replace basestate = "Morocco, Algeria" if original_state == "Morocco/Western Sahara, Algeria"
replace basestate = "Philippines" if original_state == "Philipines "
replace basestate = "Bangladesh" if original_state == "Bangladesh "
replace basestate = "Uganda" if original_state == "Uganda "
replace basestate = "Turkey" if original_state == "Turkey "
replace basestate = "Tajikistan" if original_state == "Tajikistan "
replace basestate = "Sudan" if original_state == "Sudan "
replace basestate = "Portugal, Angola" if original_state == "Portugal/Angola"
replace basestate = "Lebanon" if original_state == "Lebanon "
replace basestate = "Cambodia" if original_state == "Cambodia "

egen basestate_1 = ends(basestate), punct(,) trim h
egen basestate_2aux = ends(basestate), punct(,) trim t
egen basestate_2 = ends(basestate_2aux), punct(,) h
egen basestate_3aux = ends(basestate_2aux), punct(,) trim t
egen basestate_3 = ends(basestate_3aux), punct(,) h
egen basestate_4 = ends(basestate_3aux), punct(,) trim t

drop basestate_2aux
drop basestate_3aux

* Clean target state

clonevar targetstate_new=targetstate
lab var targetstate "Target states involved (original name)"
lab var targetstate_new "Target states involved (current name)"

replace targetstate_new = "Argentina" if targetstate=="Argentina, International"
replace targetstate_new = "Austria, United States of America" if targetstate=="Austria, USA"
replace targetstate_new = "Azerbaijan, Russia" if targetstate=="Azerbaijan, Russia/Dagestan"
replace targetstate_new = "Bahrain, United States of America" if targetstate=="Bahrain, United States"
replace targetstate_new = "Belgium, United States of America" if targetstate=="Belgium, USA"
replace targetstate_new = "Myanmar" if targetstate=="Buma"
replace targetstate_new = "Myanmar" if targetstate=="Burma"
replace targetstate_new = "Bosnia and Herzegovina" if targetstate=="Bosnia & Herzegovina"
replace targetstate_new = "Republic of Congo" if targetstate=="Congo (Brazzaville)"
replace targetstate_new = "Colombia, United States of America, Honduras" if targetstate=="Colombia, United States, Honduras"
replace targetstate_new = "Dominican Republic, United States of America" if targetstate=="Dominican Republic, United States"
replace targetstate_new = "Ecuador, United Kingdom" if targetstate=="Ecuador, UK"
replace targetstate_new = "Egypt, Somalia, Iraq, United States of America" if targetstate=="Egypt, Somalia, Iraq, United States"
replace targetstate_new = "Egypt, Switzerland, Israel, United States of America" if targetstate=="Egypt, Switzerland, Israel, United States"
replace targetstate_new = "Egypt, United States of America" if targetstate=="Egypt, United States"
replace targetstate_new = "Egypt, United States of America, Israel" if targetstate=="Egypt, United States, Israel"
replace targetstate_new = "El Salvador, United States of America, United Kingdom" if targetstate=="El Salvador, US, UK"
replace targetstate_new = "Germany ,United States of America" if targetstate=="Germany ,USA"
replace targetstate_new = "Greece, United Kingdom" if targetstate=="Greece, England"
replace targetstate_new = "Greece, United States of America" if targetstate=="Greece, USA"
replace targetstate_new = "Greece, United States of America, Israel" if targetstate=="Greece, USA, Israel"
replace targetstate_new = "Greece, United States of America, Turkey" if targetstate=="Greece, USA, Turkey"
replace targetstate_new = "Guatemala, Russia" if targetstate=="Guatemala, USSR"
replace targetstate_new = "Haiti, United States of America" if targetstate=="Haiti, United States"
replace targetstate_new = "Honduras, United States of America" if targetstate=="Honduras, US"
replace targetstate_new = "Honduras, United States of America" if targetstate=="Honduras, United States"
replace targetstate_new = "India" if targetstate=="India/Andhra Pradesh"
replace targetstate_new = "India" if targetstate=="India/Assam"
replace targetstate_new = "India" if targetstate=="India/Assam/Manipur"
replace targetstate_new = "India" if targetstate=="India/Assam/Meghalaya"
replace targetstate_new = "India" if targetstate=="India/Bodoland"
replace targetstate_new = "India" if targetstate=="India/Kashmir"
replace targetstate_new = "India" if targetstate=="India/Manipur"
replace targetstate_new = "India" if targetstate=="India/Nagaland"
replace targetstate_new = "India" if targetstate=="India/Punjab"
replace targetstate_new = "India" if targetstate=="India/Punjab/Khalistan"
replace targetstate_new = "India" if targetstate=="India/Tripura"
replace targetstate_new = "India" if targetstate=="India/West Bengal/Assam"
replace targetstate_new = "Indonesia" if targetstate=="Indonesia "
replace targetstate_new = "Iran, Norway, United States of America" if targetstate=="Iran, Norway, United States"
replace targetstate_new = "Iraq, United States of America" if targetstate=="Iraq, United States"
replace targetstate_new = "Iraq, United States of America, Philippines" if targetstate=="Iraq, United States, Philippines"
replace targetstate_new = "Iraq, United States of America, Russia" if targetstate=="Iraq, United States, Russia"
replace targetstate_new = "Iraq, United States of America, Spain" if targetstate=="Iraq, United States, Spain"
replace targetstate_new = "Italy, United States of America" if targetstate=="Italy, USA"
replace targetstate_new = "Israel,Palestine" if targetstate=="Israel/Palestinian Territories"
replace targetstate_new = "Kosovo, Serbia, Montenegro," if targetstate=="Kosovo/Serbia & Montenegro/Yugoslavia"
replace targetstate_new = "Macedonia,Kosovo" if targetstate=="Macedonia, Kosovo, Serbia"
replace targetstate_new = "Mexico, Belgium, United States of America" if targetstate=="Mexico, Belgium, US"
replace targetstate_new = "Mexico, United States of America" if targetstate=="Mexico, US"
replace targetstate_new = "United Kingdom" if targetstate=="Northern Ireland/United Kingdom"
replace targetstate_new = "Pakistan" if targetstate=="Pakistan "
replace targetstate_new = "Pakistan" if targetstate=="Pakistan,Baluchistan"
replace targetstate_new = "Pakistan, Bangladesh" if targetstate == "Pakistan /Bangladesh"
replace targetstate_new = "Peru, United States of America, Japan" if targetstate=="Peru, US, Japan"
replace targetstate_new = "Philippines" if targetstate=="Phillipines"  
replace targetstate_new = "Portugal, United States of America" if targetstate=="Portugal, USA"
replace targetstate_new = "Russia" if targetstate=="Russia/Chechnya"
replace targetstate_new = "Russia" if targetstate=="Russia/Chechnya/Dagestan"
replace targetstate_new = "Russia" if targetstate=="Russia/Dagestan"
replace targetstate_new = "Russia" if targetstate=="Russia/North Ossetia"
replace targetstate_new = "Saudi Arabia, United States of America" if targetstate=="Saudi Arabia, United States"
replace targetstate_new = "Spain, United States of America" if targetstate=="Spain, USA"
replace targetstate_new = "Serbia,Bosnia and Herzegovina" if targetstate=="Serbia/Bosnia & Herzegovina"
replace targetstate_new = "United Kingdom, United States of America" if targetstate=="UK, USA"
replace targetstate_new = "Uganda, Democratic Republic of the Congo" if targetstate=="Uganda, DRC"
replace targetstate_new = "United States of America" if targetstate=="United States"
replace targetstate_new = "United States of America" if targetstate=="United States, International"
replace targetstate_new = "United States of America, Portugal, Canada, New Zeland" if targetstate=="United States, Portugal, Canada, New Zealand "
replace targetstate_new = "United States of America, Israel" if targetstate=="United States, Israel"
replace targetstate_new = "United States of America, Canada" if targetstate=="United States, Canada"
replace targetstate_new = "United States of America" if targetstate=="United States, Puerto Rico"
replace targetstate_new = "Turkey, United States of America" if targetstate=="Turkey, United States"
replace targetstate_new = "Yemen, United States of America" if targetstate=="Yemen, US"
replace targetstate_new = "Bosnia and Herzegovina" if targetstate=="Yugoslavia/Bosnia & Herzegovina"
replace targetstate_new = "Croatia" if targetstate=="Yugoslavia/Croatia"
replace targetstate_new = "Slovenia" if targetstate=="Yugoslavia/Slovenia"
replace targetstate_new = "Zimbabwe" if targetstate=="Zimbabwe (Rhodesia)"
replace targetstate_new = "Morocco" if targetstate=="Morocco "

tab targetstate_new
egen targetstate_new1 = ends(targetstate_new), punct(,) trim h
egen targetstate_new2aux = ends(targetstate_new), punct(,) trim t
egen targetstate_new2 = ends(targetstate_new2aux), punct(,) h
egen targetstate_new3aux = ends(targetstate_new2aux), punct(,) trim t
egen targetstate_new3 = ends(targetstate_new3aux), punct(,) h
egen targetstate_new4 = ends(targetstate_new3aux), punct(,) trim t

drop targetstate_new2aux
drop targetstate_new3aux

sort basestate_1 
tab basestate_1

sort targetstate_new1 
tab targetstate_new1

* Create labels for country (ISO)

lab define labcountry /// 
	1 "Afghanistan" /// 
	2 "Albania" /// 
	3 "Algeria" /// 
	4 "Andorra" /// 
	5 "Angola" /// 
	6 "Antarctica" /// 
	7 "Antigua and Barbuda" /// 
	8 "Argentina" /// 
	9 "Armenia" /// 
	10 "Australia" /// 
	11 "Austria" /// 
	12 "Azerbaijan" /// 
	13 "Bahrain" /// 
	14 "Bajo Nuevo Bank (Petrel Is.)" /// 
	15 "Bangladesh" /// 
	16 "Barbados" /// 
	17 "Belarus" /// 
	18 "Belgium" /// 
	19 "Belize" /// 
	20 "Benin" /// 
	21 "Bhutan" /// 
	22 "Bolivia" /// 
	23 "Bosnia and Herzegovina" /// 
	24 "Botswana" /// 
	25 "Brazil" /// 
	26 "Brunei" /// 
	27 "Bulgaria" /// 
	28 "Burkina Faso" /// 
	29 "Burundi" /// 
	30 "Cambodia" /// 
	31 "Cameroon" /// 
	32 "Canada" /// 
	33 "Cape Verde" /// 
	34 "Central African Republic" /// 
	35 "Chad" /// 
	36 "Chile" /// 
	37 "China" /// 
	38 "Colombia" /// 
	39 "Comoros" /// 
	40 "Costa Rica" /// 
	41 "Croatia" /// 
	42 "Cuba" /// 
	43 "Cyprus" /// 
	44 "Cyprus No Mans Area" /// 
	45 "Czech Republic" /// 
	46 "Democratic Republic of the Congo" /// 
	47 "Denmark" /// 
	48 "Djibouti" /// 
	49 "Dominica" /// 
	50 "Dominican Republic" /// 
	51 "East Timor" /// 
	52 "Ecuador" /// 
	53 "Egypt" /// 
	54 "El Salvador" /// 
	55 "Equatorial Guinea" /// 
	56 "Eritrea" /// 
	57 "Estonia" /// 
	58 "Ethiopia" /// 
	59 "Federated States of Micronesia" /// 
	60 "Fiji" /// 
	61 "Finland" /// 
	62 "France" /// 
	63 "Gabon" /// 
	64 "Gambia" /// 
	65 "Georgia" /// 
	66 "Germany" /// 
	67 "Ghana" /// 
	68 "Greece" /// 
	69 "Grenada" /// 
	70 "Guatemala" /// 
	71 "Guinea" /// 
	72 "Guinea-Bissau" /// 
	73 "Guyana" /// 
	74 "Haiti" /// 
	75 "Honduras" /// 
	76 "Hungary" /// 
	77 "Iceland" /// 
	78 "India" /// 
	79 "Indonesia" /// 
	80 "Iran" /// 
	81 "Iraq" /// 
	82 "Ireland" /// 
	83 "Israel" /// 
	84 "Italy" /// 
	85 "Cote d'Ivoire" /// 
	86 "Jamaica" /// 
	87 "Japan" /// 
	88 "Jordan" /// 
	89 "Kazakhstan" /// 
	90 "Kenya" /// 
	91 "Kiribati" /// 
	92 "Kosovo" /// 
	93 "Kuwait" /// 
	94 "Kyrgyzstan" /// 
	95 "Laos" /// 
	96 "Latvia" /// 
	97 "Lebanon" /// 
	98 "Lesotho" /// 
	99 "Liberia" /// 
	100 "Libya" /// 
	101 "Liechtenstein" /// 
	102 "Lithuania" /// 
	103 "Luxembourg" /// 
	104 "Macedonia" /// 
	105 "Madagascar" /// 
	106 "Malawi" /// 
	107 "Malaysia" /// 
	108 "Maldives" /// 
	109 "Mali" /// 
	110 "Malta" /// 
	111 "Marshall Islands" /// 
	112 "Mauritania" /// 
	113 "Mauritius" /// 
	114 "Mexico" /// 
	115 "Moldova" /// 
	116 "Monaco" /// 
	117 "Mongolia" /// 
	118 "Montenegro" /// 
	119 "Morocco" /// 
	120 "Mozambique" /// 
	121 "Myanmar" /// 
	122 "Namibia" /// 
	123 "Nauru" /// 
	124 "Nepal" /// 
	125 "Netherlands" /// 
	126 "New Zealand" /// 
	127 "Nicaragua" /// 
	128 "Niger" /// 
	129 "Nigeria" /// 
	130 "North Korea" /// 
	131 "Northern Cyprus" /// 
	132 "Norway" /// 
	133 "Oman" /// 
	134 "Pakistan" /// 
	135 "Palau" /// 
	136 "Panama" /// 
	137 "Papua New Guinea" /// 
	138 "Paraguay" /// 
	139 "Peru" /// 
	140 "Philippines" /// 
	141 "Poland" /// 
	142 "Portugal" /// 
	143 "Qatar" /// 
	144 "Republic of Congo" /// 
	145 "Serbia" /// 
	146 "Romania" /// 
	147 "Russia" /// 
	148 "Rwanda" /// 
	149 "Saint Kitts and Nevis" /// 
	150 "Saint Lucia" /// 
	151 "Saint Vincent and the Grenadines" /// 
	152 "Samoa" /// 
	153 "San Marino" /// 
	154 "Sao Tome and Principe" /// 
	155 "Saudi Arabia" /// 
	156 "Scarborough Reef" /// 
	157 "Senegal" /// 
	158 "Serranilla Bank" /// 
	159 "Seychelles" /// 
	160 "Siachen Glacier" /// 
	161 "Sierra Leone" /// 
	162 "Singapore" /// 
	163 "Slovakia" /// 
	164 "Slovenia" /// 
	165 "Solomon Islands" /// 
	166 "Somalia" /// 
	167 "Somaliland" /// 
	168 "South Africa" /// 
	169 "South Korea" /// 
	170 "South Sudan" /// 
	171 "Spain" /// 
	172 "Spratly Islands" /// 
	173 "Sri Lanka" /// 
	174 "Sudan" /// 
	175 "Suriname" /// 
	176 "Swaziland" /// 
	177 "Sweden" /// 
	178 "Switzerland" /// 
	179 "Syria" /// 
	180 "Taiwan" /// 
	181 "Tajikistan" /// 
	182 "Thailand" /// 
	183 "The Bahamas" /// 
	184 "Togo" /// 
	185 "Tonga" /// 
	186 "Trinidad and Tobago" /// 
	187 "Tunisia" /// 
	188 "Turkey" /// 
	189 "Turkmenistan" /// 
	190 "Tuvalu" /// 
	191 "Uganda" /// 
	192 "Ukraine" /// 
	193 "United Arab Emirates" /// 
	194 "United Kingdom" /// 
	195 "United Republic of Tanzania" /// 
	196 "United States of America" /// 
	197 "Uruguay" /// 
	198 "Uzbekistan" /// 
	199 "Vanuatu" /// 
	200 "Vatican" /// 
	201 "Venezuela" /// 
	202 "Vietnam" /// 
	203 "Western Sahara" /// 
	204 "Yemen" /// 
	205 "Zambia" /// 
	206 "Zimbabwe" 

* Assingning codes to countries for future labelling
		
local country basestate_1 basestate_2 basestate_3 basestate_4 targetstate_new1 targetstate_new2 targetstate_new3 targetstate_new4

foreach var of loc country {

	gen code`var'=.
	replace code`var' = 1 if `var' == "Afghanistan"
	replace code`var' = 2 if `var' == "Albania"
	replace code`var' = 3 if `var' == "Algeria"
	replace code`var' = 4 if `var' == "Andorra"
	replace code`var' = 5 if `var' == "Angola"
	replace code`var' = 6 if `var' == "Antarctica"
	replace code`var' = 7 if `var' == "Antigua and Barbuda"
	replace code`var' = 8 if `var' == "Argentina"
	replace code`var' = 9 if `var' == "Armenia"
	replace code`var' = 10 if `var' == "Australia"
	replace code`var' = 11 if `var' == "Austria"
	replace code`var' = 12 if `var' == "Azerbaijan"
	replace code`var' = 13 if `var' == "Bahrain"
	replace code`var' = 14 if `var' == "Bajo Nuevo Bank (Petrel Is.)"
	replace code`var' = 15 if `var' == "Bangladesh"
	replace code`var' = 16 if `var' == "Barbados"
	replace code`var' = 17 if `var' == "Belarus"
	replace code`var' = 18 if `var' == "Belgium"
	replace code`var' = 19 if `var' == "Belize"
	replace code`var' = 20 if `var' == "Benin"
	replace code`var' = 21 if `var' == "Bhutan"
	replace code`var' = 22 if `var' == "Bolivia"
	replace code`var' = 23 if `var' == "Bosnia and Herzegovina"
	replace code`var' = 24 if `var' == "Botswana"
	replace code`var' = 25 if `var' == "Brazil"
	replace code`var' = 26 if `var' == "Brunei"
	replace code`var' = 27 if `var' == "Bulgaria"
	replace code`var' = 28 if `var' == "Burkina Faso"
	replace code`var' = 29 if `var' == "Burundi"
	replace code`var' = 30 if `var' == "Cambodia"
	replace code`var' = 31 if `var' == "Cameroon"
	replace code`var' = 32 if `var' == "Canada"
	replace code`var' = 33 if `var' == "Cape Verde"
	replace code`var' = 34 if `var' == "Central African Republic"
	replace code`var' = 35 if `var' == "Chad"
	replace code`var' = 36 if `var' == "Chile"
	replace code`var' = 37 if `var' == "China"
	replace code`var' = 38 if `var' == "Colombia"
	replace code`var' = 39 if `var' == "Comoros"
	replace code`var' = 40 if `var' == "Costa Rica"
	replace code`var' = 41 if `var' == "Croatia"
	replace code`var' = 42 if `var' == "Cuba"
	replace code`var' = 43 if `var' == "Cyprus"
	replace code`var' = 44 if `var' == "Cyprus No Mans Area"
	replace code`var' = 45 if `var' == "Czech Republic"
	replace code`var' = 46 if `var' == "Democratic Republic of the Congo"
	replace code`var' = 47 if `var' == "Denmark"
	replace code`var' = 48 if `var' == "Djibouti"
	replace code`var' = 49 if `var' == "Dominica"
	replace code`var' = 50 if `var' == "Dominican Republic"
	replace code`var' = 51 if `var' == "East Timor"
	replace code`var' = 52 if `var' == "Ecuador"
	replace code`var' = 53 if `var' == "Egypt"
	replace code`var' = 54 if `var' == "El Salvador"
	replace code`var' = 55 if `var' == "Equatorial Guinea"
	replace code`var' = 56 if `var' == "Eritrea"
	replace code`var' = 57 if `var' == "Estonia"
	replace code`var' = 58 if `var' == "Ethiopia"
	replace code`var' = 59 if `var' == "Federated States of Micronesia"
	replace code`var' = 60 if `var' == "Fiji"
	replace code`var' = 61 if `var' == "Finland"
	replace code`var' = 62 if `var' == "France"
	replace code`var' = 63 if `var' == "Gabon"
	replace code`var' = 64 if `var' == "Gambia"
	replace code`var' = 65 if `var' == "Georgia"
	replace code`var' = 66 if `var' == "Germany"
	replace code`var' = 67 if `var' == "Ghana"
	replace code`var' = 68 if `var' == "Greece"
	replace code`var' = 69 if `var' == "Grenada"
	replace code`var' = 70 if `var' == "Guatemala"
	replace code`var' = 71 if `var' == "Guinea"
	replace code`var' = 72 if `var' == "Guinea-Bissau"
	replace code`var' = 73 if `var' == "Guyana"
	replace code`var' = 74 if `var' == "Haiti"
	replace code`var' = 75 if `var' == "Honduras"
	replace code`var' = 76 if `var' == "Hungary"
	replace code`var' = 77 if `var' == "Iceland"
	replace code`var' = 78 if `var' == "India"
	replace code`var' = 79 if `var' == "Indonesia"
	replace code`var' = 80 if `var' == "Iran"
	replace code`var' = 81 if `var' == "Iraq"
	replace code`var' = 82 if `var' == "Ireland"
	replace code`var' = 83 if `var' == "Israel"
	replace code`var' = 84 if `var' == "Italy"
	replace code`var' = 85 if `var' == "Cote d'Ivoire"
	replace code`var' = 86 if `var' == "Jamaica"
	replace code`var' = 87 if `var' == "Japan"
	replace code`var' = 88 if `var' == "Jordan"
	replace code`var' = 89 if `var' == "Kazakhstan"
	replace code`var' = 90 if `var' == "Kenya"
	replace code`var' = 91 if `var' == "Kiribati"
	replace code`var' = 92 if `var' == "Kosovo"
	replace code`var' = 93 if `var' == "Kuwait"
	replace code`var' = 94 if `var' == "Kyrgyzstan"
	replace code`var' = 95 if `var' == "Laos"
	replace code`var' = 96 if `var' == "Latvia"
	replace code`var' = 97 if `var' == "Lebanon"
	replace code`var' = 98 if `var' == "Lesotho"
	replace code`var' = 99 if `var' == "Liberia"
	replace code`var' = 100 if `var' == "Libya"
	replace code`var' = 101 if `var' == "Liechtenstein"
	replace code`var' = 102 if `var' == "Lithuania"
	replace code`var' = 103 if `var' == "Luxembourg"
	replace code`var' = 104 if `var' == "Macedonia"
	replace code`var' = 105 if `var' == "Madagascar"
	replace code`var' = 106 if `var' == "Malawi"
	replace code`var' = 107 if `var' == "Malaysia"
	replace code`var' = 108 if `var' == "Maldives"
	replace code`var' = 109 if `var' == "Mali"
	replace code`var' = 110 if `var' == "Malta"
	replace code`var' = 111 if `var' == "Marshall Islands"
	replace code`var' = 112 if `var' == "Mauritania"
	replace code`var' = 113 if `var' == "Mauritius"
	replace code`var' = 114 if `var' == "Mexico"
	replace code`var' = 115 if `var' == "Moldova"
	replace code`var' = 116 if `var' == "Monaco"
	replace code`var' = 117 if `var' == "Mongolia"
	replace code`var' = 118 if `var' == "Montenegro"
	replace code`var' = 119 if `var' == "Morocco"
	replace code`var' = 120 if `var' == "Mozambique"
	replace code`var' = 121 if `var' == "Myanmar"
	replace code`var' = 122 if `var' == "Namibia"
	replace code`var' = 123 if `var' == "Nauru"
	replace code`var' = 124 if `var' == "Nepal"
	replace code`var' = 125 if `var' == "Netherlands"
	replace code`var' = 126 if `var' == "New Zealand"
	replace code`var' = 127 if `var' == "Nicaragua"
	replace code`var' = 128 if `var' == "Niger"
	replace code`var' = 129 if `var' == "Nigeria"
	replace code`var' = 130 if `var' == "North Korea"
	replace code`var' = 131 if `var' == "Northern Cyprus"
	replace code`var' = 132 if `var' == "Norway"
	replace code`var' = 133 if `var' == "Oman"
	replace code`var' = 134 if `var' == "Pakistan"
	replace code`var' = 135 if `var' == "Palau"
	replace code`var' = 136 if `var' == "Panama"
	replace code`var' = 137 if `var' == "Papua New Guinea"
	replace code`var' = 138 if `var' == "Paraguay"
	replace code`var' = 139 if `var' == "Peru"
	replace code`var' = 140 if `var' == "Philippines"
	replace code`var' = 141 if `var' == "Poland"
	replace code`var' = 142 if `var' == "Portugal"
	replace code`var' = 143 if `var' == "Qatar"
	replace code`var' = 144 if `var' == "Republic of Congo"
	replace code`var' = 145 if `var' == "Serbia"
	replace code`var' = 146 if `var' == "Romania"
	replace code`var' = 147 if `var' == "Russia"
	replace code`var' = 148 if `var' == "Rwanda"
	replace code`var' = 149 if `var' == "Saint Kitts and Nevis"
	replace code`var' = 150 if `var' == "Saint Lucia"
	replace code`var' = 151 if `var' == "Saint Vincent and the Grenadines"
	replace code`var' = 152 if `var' == "Samoa"
	replace code`var' = 153 if `var' == "San Marino"
	replace code`var' = 154 if `var' == "Sao Tome and Principe"
	replace code`var' = 155 if `var' == "Saudi Arabia"
	replace code`var' = 156 if `var' == "Scarborough Reef"
	replace code`var' = 157 if `var' == "Senegal"
	replace code`var' = 158 if `var' == "Serranilla Bank"
	replace code`var' = 159 if `var' == "Seychelles"
	replace code`var' = 160 if `var' == "Siachen Glacier"
	replace code`var' = 161 if `var' == "Sierra Leone"
	replace code`var' = 162 if `var' == "Singapore"
	replace code`var' = 163 if `var' == "Slovakia"
	replace code`var' = 164 if `var' == "Slovenia"
	replace code`var' = 165 if `var' == "Solomon Islands"
	replace code`var' = 166 if `var' == "Somalia"
	replace code`var' = 167 if `var' == "Somaliland"
	replace code`var' = 168 if `var' == "South Africa"
	replace code`var' = 169 if `var' == "South Korea"
	replace code`var' = 170 if `var' == "South Sudan"
	replace code`var' = 171 if `var' == "Spain"
	replace code`var' = 172 if `var' == "Spratly Islands"
	replace code`var' = 173 if `var' == "Sri Lanka"
	replace code`var' = 174 if `var' == "Sudan"
	replace code`var' = 175 if `var' == "Suriname"
	replace code`var' = 176 if `var' == "Swaziland"
	replace code`var' = 177 if `var' == "Sweden"
	replace code`var' = 178 if `var' == "Switzerland"
	replace code`var' = 179 if `var' == "Syria"
	replace code`var' = 180 if `var' == "Taiwan"
	replace code`var' = 181 if `var' == "Tajikistan"
	replace code`var' = 182 if `var' == "Thailand"
	replace code`var' = 183 if `var' == "The Bahamas"
	replace code`var' = 184 if `var' == "Togo"
	replace code`var' = 185 if `var' == "Tonga"
	replace code`var' = 186 if `var' == "Trinidad and Tobago"
	replace code`var' = 187 if `var' == "Tunisia"
	replace code`var' = 188 if `var' == "Turkey"
	replace code`var' = 189 if `var' == "Turkmenistan"
	replace code`var' = 190 if `var' == "Tuvalu"
	replace code`var' = 191 if `var' == "Uganda"
	replace code`var' = 192 if `var' == "Ukraine"
	replace code`var' = 193 if `var' == "United Arab Emirates"
	replace code`var' = 194 if `var' == "United Kingdom"
	replace code`var' = 195 if `var' == "United Republic of Tanzania"
	replace code`var' = 196 if `var' == "United States of America"
	replace code`var' = 197 if `var' == "Uruguay"
	replace code`var' = 198 if `var' == "Uzbekistan"
	replace code`var' = 199 if `var' == "Vanuatu"
	replace code`var' = 200 if `var' == "Vatican"
	replace code`var' = 201 if `var' == "Venezuela"
	replace code`var' = 202 if `var' == "Vietnam"
	replace code`var' = 203 if `var' == "Western Sahara"
	replace code`var' = 204 if `var' == "Yemen"
	replace code`var' = 205 if `var' == "Zambia"
	replace code`var' = 206 if `var' == "Zimbabwe"


	lab val code`var' labcountry 	
	
	clonevar aux = `var'
	drop `var' 
	clonevar `var' = code`var'
	drop code`var'
	drop aux
} 


* Create value labels for COW codes (variable cow)

decode basestate_1, generate(cow_code)
gen aux = .   

replace aux = 700 if cow_code == "Afghanistan"
replace aux = 615 if cow_code == "Algeria"
replace aux = 540 if cow_code == "Angola"
replace aux = 160 if cow_code == "Argentina"
replace aux = 371 if cow_code == "Armenia"
replace aux = 305 if cow_code == "Austria"
replace aux = 373 if cow_code == "Azerbaijan"
replace aux = 692 if cow_code == "Bahrain"
replace aux = 771 if cow_code == "Bangladesh"
replace aux = 211 if cow_code == "Belgium"
replace aux = 145 if cow_code == "Bolivia"
replace aux = 346 if cow_code == "Bosnia and Herzegovina"
replace aux = 140 if cow_code == "Brazil"
replace aux = 516 if cow_code == "Burundi"
replace aux = 811 if cow_code == "Cambodia"
replace aux = 20  if cow_code == "Canada"
replace aux = 482 if cow_code == "Central African Republic"
replace aux = 483 if cow_code == "Chad"
replace aux = 155 if cow_code == "Chile"
replace aux = 710 if cow_code == "China"
replace aux = 100 if cow_code == "Colombia"
replace aux = 581 if cow_code == "Comoros"
replace aux = 344 if cow_code == "Croatia"
replace aux = 490 if cow_code == "Democratic Republic of the Congo"
replace aux = 522 if cow_code == "Djibouti"
replace aux = 42  if cow_code == "Dominican Republic"
replace aux = 860 if cow_code == "East Timor"
replace aux = 130 if cow_code == "Ecuador"
replace aux = 651 if cow_code == "Egypt"
replace aux = 92  if cow_code == "El Salvador"
replace aux = 531 if cow_code == "Eritrea"
replace aux = 530 if cow_code == "Ethiopia"
replace aux = 220 if cow_code == "France"
replace aux = 372 if cow_code == "Georgia"
replace aux = 255 if cow_code == "Germany"
replace aux = 350 if cow_code == "Greece"
replace aux = 90  if cow_code == "Guatemala"
replace aux = 438 if cow_code == "Guinea"
replace aux = 41  if cow_code == "Haiti"
replace aux = 91  if cow_code == "Honduras"
replace aux = 750 if cow_code == "India"
replace aux = 850 if cow_code == "Indonesia"
replace aux = 630 if cow_code == "Iran"
replace aux = 645 if cow_code == "Iraq"
replace aux = 666 if cow_code == "Israel"
replace aux = 325 if cow_code == "Italy"
replace aux = 437 if cow_code == "Cote d'Ivoire"
replace aux = 740 if cow_code == "Japan"
replace aux = 663 if cow_code == "Jordan"
replace aux = 347 if cow_code == "Kosovo"
replace aux = 812 if cow_code == "Laos"
replace aux = 367 if cow_code == "Latvia"
replace aux = 660 if cow_code == "Lebanon"
replace aux = 450 if cow_code == "Liberia"
replace aux = 620 if cow_code == "Libya"
replace aux = 343 if cow_code == "Macedonia"
replace aux = 820 if cow_code == "Malaysia"
replace aux = 432 if cow_code == "Mali"
replace aux =  70 if cow_code == "Mexico"
replace aux = 359 if cow_code == "Moldova"
replace aux = 600 if cow_code == "Morocco"
replace aux = 541 if cow_code == "Mozambique"
replace aux = 775 if cow_code == "Myanmar"
replace aux = 565 if cow_code == "Namibia"
replace aux = 790 if cow_code == "Nepal"
replace aux =  93 if cow_code == "Nicaragua"
replace aux = 436 if cow_code == "Niger"
replace aux = 475 if cow_code == "Nigeria"
replace aux = 698 if cow_code == "Oman"
replace aux = 770 if cow_code == "Pakistan"
replace aux =  95 if cow_code == "Panama"
replace aux = 910 if cow_code == "Papua New Guinea"
replace aux = 135 if cow_code == "Peru"
replace aux = 840 if cow_code == "Philippines"
replace aux = 235 if cow_code == "Portugal"
replace aux = 484 if cow_code == "Republic of Congo"
replace aux = 365 if cow_code == "Russia"
replace aux = 517 if cow_code == "Rwanda"
replace aux = 670 if cow_code == "Saudi Arabia"
replace aux = 433 if cow_code == "Senegal"
replace aux = 451 if cow_code == "Sierra Leone"
replace aux = 349 if cow_code == "Slovenia"
replace aux = 520 if cow_code == "Somalia"
replace aux = 560 if cow_code == "South Africa"
replace aux = 626 if cow_code == "South Sudan"
replace aux = 230 if cow_code == "Spain"
replace aux = 780 if cow_code == "Sri Lanka"
replace aux = 625 if cow_code == "Sudan"
replace aux = 115 if cow_code == "Suriname"
replace aux = 380 if cow_code == "Sweden"
replace aux = 652 if cow_code == "Syria"
replace aux = 702 if cow_code == "Tajikistan"
replace aux = 800 if cow_code == "Thailand"
replace aux = 640 if cow_code == "Turkey"
replace aux = 500 if cow_code == "Uganda"
replace aux = 200 if cow_code == "United Kingdom"
replace aux =   2 if cow_code == "United States of America"
replace aux = 165 if cow_code == "Uruguay"
replace aux = 704 if cow_code == "Uzbekistan"
replace aux = 101 if cow_code == "Venezuela"
replace aux = 816 if cow_code == "Vietnam"
replace aux = 679 if cow_code == "Yemen"
replace aux = 552 if cow_code == "Zimbabwe"

drop cow_code
clonevar cow_code = aux
drop aux

lab define labcow ///
	58 "Antigua & Barbuda" ///
	700 "Afghanistan" ///
	339 "Albania" ///
	339 "Albania" ///
	615 "Algeria" ///
	232 "Andorra" ///
	540 "Angola" ///
	160 "Argentina" ///
	371 "Armenia" ///
	300 "Austria-Hungary" ///
	900 "Australia" ///
	305 "Austria" ///
	305 "Austria" ///
	373 "Azerbaijan" ///
	267 "Baden" ///
	692 "Bahrain" ///
	53 "Barbados" ///
	245 "Bavaria" ///
	211 "Belgium" ///
	211 "Belgium" ///
	434 "Benin" ///
	439 "Burkina Faso" ///
	31 "Bahamas" ///
	760 "Bhutan" ///
	370 "Belarus" ///
	80 "Belize" ///
	771 "Bangladesh" ///
	145 "Bolivia" ///
	346 "Bosnia and Herzegovina" ///
	571 "Botswana" ///
	140 "Brazil" ///
	835 "Brunei" ///
	516 "Burundi" ///
	355 "Bulgaria" ///
	811 "Cambodia" ///
	20 "Canada" ///
	471 "Cameroon" ///
	402 "Cape Verde" ///
	437 "Ivory Coast" ///
	482 "Central African Republic" ///
	483 "Chad" ///
	155 "Chile" ///
	710 "China" ///
	100 "Colombia" ///
	581 "Comoros" ///
	484 "Republic of Congo" ///
	94 "Costa Rica" ///
	344 "Croatia" ///
	40 "Cuba" ///
	40 "Cuba" ///
	352 "Cyprus" ///
	315 "Czechoslovakia" ///
	315 "Czechoslovakia" ///
	316 "Czech Republic" ///
	390 "Denmark" ///
	390 "Denmark" ///
	522 "Djibouti" ///
	54 "Dominica" ///
	42 "Dominican Republic" ///
	42 "Dominican Republic" ///
	490 "Democratic Republic of the Congo" ///
	816 "Vietnam" ///
	130 "Ecuador" ///
	651 "Egypt" ///
	651 "Egypt" ///
	411 "Equatorial Guinea" ///
	531 "Eritrea" ///
	366 "Estonia" ///
	366 "Estonia" ///
	530 "Ethiopia" ///
	530 "Ethiopia" ///
	860 "East Timor" ///
	950 "Fiji" ///
	375 "Finland" ///
	220 "France" ///
	220 "France" ///
	987 "Federated States of Micronesia" ///
	481 "Gabon" ///
	420 "Gambia" ///
	265 "German Democratic Republic" ///
	260 "German Federal Republic" ///
	452 "Ghana" ///
	255 "Germany" ///
	255 "Germany" ///
	404 "Guinea-Bissau" ///
	350 "Greece" ///
	350 "Greece" ///
	372 "Georgia" ///
	55 "Grenada" ///
	90 "Guatemala" ///
	438 "Guinea" ///
	110 "Guyana" ///
	41 "Haiti" ///
	41 "Haiti" ///
	240 "Hanover" ///
	91 "Honduras" ///
	273 "Hesse Electoral" ///
	275 "Hesse Grand Ducal" ///
	310 "Hungary" ///
	395 "Iceland" ///
	750 "India" ///
	850 "Indonesia" ///
	205 "Ireland" ///
	630 "Iran" ///
	645 "Iraq" ///
	666 "Israel" ///
	325 "Italy" ///
	51 "Jamaica" ///
	663 "Jordan" ///
	740 "Japan" ///
	740 "Japan" ///
	501 "Kenya" ///
	946 "Kiribati" ///
	730 "Korea" ///
	347 "Kosovo" ///
	690 "Kuwait" ///
	703 "Kyrgyzstan" ///
	705 "Kazakhstan" ///
	812 "Laos" ///
	367 "Latvia" ///
	367 "Latvia" ///
	450 "Liberia" ///
	660 "Lebanon" ///
	570 "Lesotho" ///
	620 "Libya" ///
	223 "Liechtenstein" ///
	368 "Lithuania" ///
	368 "Lithuania" ///
	212 "Luxembourg" ///
	212 "Luxembourg" ///
	435 "Mauritania" ///
	343 "Macedonia" ///
	781 "Maldives" ///
	580 "Madagascar" ///
	820 "Malaysia" ///
	590 "Mauritius" ///
	553 "Malawi" ///
	280 "Mecklenburg Schwerin" ///
	70 "Mexico" ///
	359 "Moldova" ///
	432 "Mali" ///
	338 "Malta" ///
	221 "Monaco" ///
	341 "Montenegro" ///
	332 "Modena" ///
	712 "Mongolia" ///
	600 "Morocco" ///
	600 "Morocco" ///
	983 "Marshall Islands" ///
	775 "Myanmar" ///
	541 "Mozambique" ///
	565 "Namibia" ///
	970 "Nauru" ///
	790 "Nepal" ///
	920 "New Zealand" ///
	93 "Nicaragua" ///
	475 "Nigeria" ///
	436 "Niger" ///
	385 "Norway" ///
	385 "Norway" ///
	210 "Netherlands" ///
	210 "Netherlands" ///
	698 "Oman" ///
	770 "Pakistan" ///
	986 "Palau" ///
	95 "Panama" ///
	327 "Papal States" ///
	150 "Paraguay" ///
	150 "Paraguay" ///
	135 "Peru" ///
	840 "Philippines" ///
	335 "Parma" ///
	910 "Papua New Guinea" ///
	290 "Poland" ///
	290 "Poland" ///
	235 "Portugal" ///
	731 "North Korea" ///
	694 "Qatar" ///
	732 "South Korea" ///
	360 "Romania" ///
	365 "Russia" ///
	817 "Republic of Vietnam" ///
	517 "Rwanda" ///
	560 "South Africa" ///
	92 "El Salvador" ///
	670 "Saudi Arabia" ///
	269 "Saxony" ///
	433 "Senegal" ///
	591 "Seychelles" ///
	329 "Two Sicilies" ///
	451 "Sierra Leone" ///
	830 "Singapore" ///
	60 "St. Kitts and Nevis" ///
	317 "Slovakia" ///
	56 "St. Lucia" ///
	349 "Slovenia" ///
	331 "San Marino" ///
	940 "Solomon Islands" ///
	520 "Somalia" ///
	230 "Spain" ///
	780 "Sri Lanka" ///
	626 "South Sudan" ///
	403 "Sao Tome and Principe" ///
	625 "Sudan" ///
	115 "Suriname" ///
	57 "St. Vincent and the Grenadines" ///
	572 "Swaziland" ///
	380 "Sweden" ///
	225 "Switzerland" ///
	652 "Syria" ///
	652 "Syria" ///
	702 "Tajikistan" ///
	713 "Taiwan" ///
	510 "Tanzania" ///
	800 "Thailand" ///
	701 "Turkmenistan" ///
	461 "Togo" ///
	955 "Tonga" ///
	52 "Trinidad and Tobago" ///
	616 "Tunisia" ///
	616 "Tunisia" ///
	640 "Turkey" ///
	337 "Tuscany" ///
	947 "Tuvalu" ///
	696 "United Arab Emirates" ///
	500 "Uganda" ///
	200 "United Kingdom" ///
	369 "Ukraine" ///
	165 "Uruguay" ///
	2 "United States of America" ///
	704 "Uzbekistan" ///
	935 "Vanuatu" ///
	101 "Venezuela" ///
	271 "Wuerttemburg" ///
	990 "Samoa" ///
	678 "Yemen Arab Republic" ///
	679 "Yemen" ///
	680 "Yemen People's Republic" ///
	345 "Yugoslavia" ///
	345 "Yugoslavia" ///
	551 "Zambia" ///
	511 "Zanzibar" ///
	552 "Zimbabwe" ///

lab val countryid cow_code labcow 

* Labelling final variables
lab var month_1 "Month of elections 1"
lab var month_2 "Month of elections 2"
lab var month_3 "Month of elections 3"

lab var basestate_1 "Base State 1"
lab var basestate_2 "Base State 2"
lab var basestate_3 "Base State 3"
lab var basestate_4 "Base State 4"
lab var targetstate_new1 "Target State 1"
lab var targetstate_new2 "Target State 2"
lab var targetstate_new3 "Target State 3"
lab var targetstate_new4 "Target State 4"

lab var countryid "ORIGINAL state Correlates of War code"
lab var cow_code "Corresponding Correlates of War code for basestate_1"

br countryid basestate_1

br if countryid==625 &	basestate_1==1  /* Taliban changes base state briefly (Sudan from Afghanistan), but we choose a consistent base state for these summary statistics. We change to Afghanistan.*/
replace countryid = 700 if countryid==625 &	basestate_1==1 

*------------------------------------1.2: Saving groupid identifiers ------------------------------------

preserve
	sort groupid
	collapse (first) name (count) appearance=year, by(groupid)
	save "$root/group_id.dta", replace
	export excel using "$results/Group_id.xlsx", sheetmodify sheet("group_id") cell(B3)  first(var)
restore

*------------------------------------1.3: Saving BD ------------------------------------

save "$root/dta_summer2016.dta", replace

/*===============================================================================================
								2: Preparing datasets for figures and map 
===============================================================================================*/

*-------------------------------2.1: Data file for the map in Appendix 2-------------------------------

* NOTES: 
* 1. The following code produces the input to generate the map in Appendix 2. 
* 2. Original shapefile used for map can be found in the following link: http://www.diva-gis.org/Data
* 3. Map produced using open source QGIS.  

use "$root/dta_summer2016.dta", clear

* Reshape from wide to long (only 1970-2010)

preserve
	tempfile state1
	keep if year>=1970 & year<=2010 /*we only keep 1970-2010*/
	keep year basestate_1 active viop peacep winner part year election ucdp
	rename basestate_1 country
	save `state1'
	save "$root/Basestate_1.dta", replace
restore
	
preserve
	tempfile state2
	keep year basestate_2 active viop peacep winner part year election
	rename basestate_2 country
	save `state2'
restore
	
preserve
	tempfile state3
	keep year basestate_3 active viop peacep winner part year election
	rename basestate_3 country
	save `state3'
restore

preserve
	tempfile state4
	keep year basestate_4 active viop peacep winner part year election
	rename basestate_4 country
	save `state4'
restore

* Append all basestates to produce a dataset with country/year as unit of analysis: 

preserve
	use "`state1'", clear
	append using "`state2'" 
	append using "`state3'" 
	append using "`state4'"
	save "$root/dataset_long_map.dta", replace
restore

/* Note: the map uses first country listed in variable "basestate" 
(since this is the main base state (as in Colombia, Venezuela) or the breakaway 
region (as in Kosovo/...)
*/

use "$root/Basestate_1.dta", clear

preserve
	
	order country year active election viop peacep winner ucdp

	sort country year 
	gen election_aux = (active == 1 & election == 1)
	gen low = (active == 1 & ucdp == 0)
	gen high = (active == 1 & ucdp == 1)
	
	bys country: egen lowr = max(low)
	bys country: egen highr = max(high)	
	bys country: egen activer = max(active)
	bys country: egen electr = max(election_aux)
	bys country: egen viopr = max(viop)
	bys country: egen peacepr = max(peacep)
	bys country: egen winnerr = max(winner)

	sort country year activer lowr highr electr viopr peacepr winnerr 

	collapse (max) activer lowr highr electr viopr peacepr winnerr, by(country)

	* Create categories to be mapped: 
	
	gen category = .
	replace category = 1 if (viopr == 1 & peacepr == 0 & winnerr == 0)
	replace category = 2 if (viopr == 0 & peacepr == 1 & winnerr == 0)
	replace category = 3 if (viopr == 0 & peacepr == 0 & winnerr == 1)
	replace category = 4 if (viopr == 1 & peacepr == 1 & winnerr == 0)
	replace category = 5 if (viopr == 1 & peacepr == 0 & winnerr == 1)
	replace category = 6 if (viopr == 0 & peacepr == 1 & winnerr == 1)
	replace category = 7 if (viopr == 1 & peacepr == 1 & winnerr == 1)
	lab var category "Category by conflict status"
	lab define category 1"Violent participation" 2"Peaceful participation" 3"Won participation" ///
	4"Violent and peaceful participation" 5"Violent participation and won participation" 6"Peaceful participation and won participation" ///
	7"Violent and peaceful participation, and won participation" 		
	lab val category category

	gen level = .
	replace level = 0 if lowr == 1 & activer == 1
	replace level = 1 if highr == 1	& activer == 1
	lab var level "Category by conflict status"
	lab define level 0"Low-level militant groups" 1"High-level militant groups"
	lab val level level
	
	* Input countries that appear in the map but that were not independent during period (1970-2010): 
	
	* 1. Western Sahara
	expand 2 if country == 119, gen(duplicated)
	replace country = 203 if duplicated==1 
	drop duplicated
	
	* Input data on LEVEL (not category) of conflict for Mauritania, Kenya, Cuba, Norht Korea 
	input
    112 . . . . . . . . 0
	90  . . . . . . . . 1
	42  . . . . . . . . 0
	130 . . . . . . . . 0
	end
	
	drop if country == .
	
	save "$root/dataset_long_map.dta", replace 
	
	* Saving CSV file for map (input for QGIS)
	
	outsheet using "$excel/long_maps_category@4.csv", comma replace 
	
	keep country level
	
	* Saving CSV file with level of conflict by country (Not used in the the map).
	
	outsheet using "$excel/long_maps_level@1.csv", comma replace 
restore

*-------------------------------2.2: Data for Figure 1 (in main text)-------------------------------

* NOTES: 
* 1. This code produces the input to replicate Figure 1. See R code to actually generate figure. 
* 2. Database by year with COUNTRY as unit of analysis
* 3. Still using the first listed state in variable basestate (as in the map)

preserve
	order country year active viop peacep winner ucdp

	sort country year 

	gen election_aux = (active == 1 & election == 1)
	
	* Level of conflict using UCDP data
	gen low = (active == 1 & ucdp == 0)
	gen high = (active == 1 & ucdp == 1)	
		
	bys year: egen activer = total(active)
	bys year: egen electr = total(election_aux)
	bys year: egen viopr = total(viop)
	bys year: egen peacepr = total(peacep)
	bys year: egen winnerr = total(winner)
	bys year: egen partr = total(part)
	bys year: egen lowr = total(low)
	bys year: egen highr = total(high)
	
	sort country year partr electr activer viopr peacepr winnerr lowr highr

	collapse (max) partr activer electr viopr peacepr winnerr lowr highr, by(year)

	* Checking consistency of variable part

	br if activer<(viop+peacep+winner) /*We're good*/

	tabout year partr viopr peacepr winnerr using "$results/Participation_across_time.txt", ///
	cells(freq cell) format(0 1) clab(No. Cell_%) ///
	replace ///
	style(tex) bt cl1(1-5) font(bold) ///
	topf("$results/top.tex") botf("$results/bot.tex") topstr(14cm) botstr(Author's calculations) 

	* Creating shares (electoral participation years as a share of all militant group active years)

	gen any = viopr + peacepr + winnerr

	local x viopr peacepr winnerr any 

	foreach var of local x{

		gen `var'perc_active = (`var'/activer)*100
		replace `var'perc_active  = 0 if `var'perc_active == .
		gen `var'perc_elect  = (`var'/electr)*100
		replace `var'perc_elect  = 0 if `var'perc_elect == .
		
		lab var `var'perc_active "`var' as a share of all active militant groups in that year"
		lab var `var'perc_elect "`var' as a share of all all militant groups election in that year"
	} 

	order year activer lowr highr electr viopr vioprperc_active vioprperc_elect peacepr peaceprperc_active peaceprperc_elect winnerr winnerrperc_active winnerrperc_elect any anyperc_active anyperc_elect 

	export excel using "$results/conflict_data1.xlsx", sheetmodify sheet("dynamic_conflict0") cell(B3)  first(var)
	
	* Saving Stata file that will be the input to run the R code to replicate Figure 1.
	
	save "$root/dynamic_conflict0.dta", replace 
restore

*-------------------------------2.3: Data for figures in Appendix 2-------------------------------

* NOTES: 
* 1. This code produces the input to replicate Figures 2 and 3. See R code to actually generate figures. 
* 2. Database by year with GROUP as unit of analysis
* 3. Shares of electoral participation instances as a share of all militant group election years

use "$root/dta_summer2016.dta", clear 

* Creating denominator 1: all "Militant group years"  

sort groupid year active

cap drop mgy 
gen mgy = .
replace mgy = 1 if active==1
by groupid: carryforward mgy, replace  

* Creating denominator 2: all "Militant group-election years"
 
cap drop mgey 
gen mgey = .
replace mgey = 1 if mgy == 1 & election == 1

* checking consistency
br year groupid viop peacep winner active part election mgy mgey if groupid==924 /*OK*/
br year groupid viop peacep winner active part election mgy mgey if groupid==5404

* Creating numerators 

sort groupid year part

*1a. carrying viop, peacep and winner forward only if part ==1

by groupid (year), sort: gen byte aux_viop = (sum(viop) >= 1)
gen viopr_a = (aux_viop == 1 & part == 1)
drop aux_viop 

by groupid (year), sort: gen byte aux_peacep = (sum(peacep) >= 1)
gen peacepr_a = (aux_peacep == 1 & part == 1)
drop aux_peacep 

by groupid (year), sort: gen byte aux_winner = (sum(winner) >= 1)
gen winnerr_a = (aux_winner == 1 & part == 1)
drop aux_winner 

*1b. carrying viop, peacep and winner forward if part ==1 for the first time and from then on. 

cap drop viopr_b 
gen viopr_b = .
replace viopr_b = 1 if (part==1 & viop == 1)
by groupid: carryforward viopr_b, replace 

cap drop peacepr_b 
gen peacepr_b = .
replace peacepr_b = 1 if (part==1 & peacep == 1)
by groupid: carryforward peacepr_b, replace 

cap drop winnerr_b 
gen winnerr_b = .
replace winnerr_b = 1 if (part==1 & winner == 1) 
by groupid: carryforward winnerr_b, replace  

* checking for consistency
br year groupid viop peacep winner active part election mgy mgey viopr_a viopr_b peacepr_a peacepr_b winnerr_a winnerr_b if groupid==924 /*OK*/
br year groupid viop peacep winner active part election mgy mgey viopr_a viopr_b peacepr_a peacepr_b winnerr_a winnerr_b if groupid==5404 /*OK*/
br year groupid viop peacep winner active part election mgy mgey viopr_a viopr_b peacepr_a peacepr_b winnerr_a winnerr_b if groupid==62511 /*OK*/

* Creating any count of viop, peacep or winner

gen any_a = (viopr_a == 1 | peacepr_a == 1 | winnerr_a == 1) & (mgey == 1)   /*Notice that this variable will only be usable for MGEY*/
gen any_b = (viopr_b == 1 | peacepr_b == 1 | winnerr_b == 1)

* Creating any participation which should be exactly the same as any_a:

gen part_r = (part == 1 & mgey == 1)
compare any_a part_r	/*Only two instances where these two variables do not coincide, which are instances of prior participation ("priorp") in the same year but before fighting begins.*/
list part year groupid viop peacep winner mgy-part_r if any_a != part_r

/*

       +------------------------------------------------------------------------------------------------------------------+
 3949. | part | year | groupid | viop | peacep | winner | mgy | mgey | viopr_a | peacep~a | winner~a | viopr_b | peacep~b |
       |    1 | 1990 |    3442 |    0 |      0 |      0 |   1 |    1 |       0 |        0 |        0 |       . |        . |
       |------------------------------------------------------------------------------------------------------------------|
       |          winner~b           |           any_a           |           any_b           |           part_r           |
       |                 .           |               0           |               0           |                1           |
       +------------------------------------------------------------------------------------------------------------------+

       +------------------------------------------------------------------------------------------------------------------+
 5441. | part | year | groupid | viop | peacep | winner | mgy | mgey | viopr_a | peacep~a | winner~a | viopr_b | peacep~b |
       |    1 | 1993 |    4842 |    0 |      0 |      0 |   1 |    1 |       0 |        0 |        0 |       . |        . |
       |------------------------------------------------------------------------------------------------------------------|
       |          winner~b           |           any_a           |           any_b           |           part_r           |
       |                 .           |               0           |               0           |                1           |
       +------------------------------------------------------------------------------------------------------------------+

*/

* We recode the two cases, where part = 1 but winner=peacep=viop=0, with part = 0 and flag them. 

replace part = 0 if (year == 1990 & groupid == 3442) | (year == 1993 & groupid == 4842) 
replace part_r = 0 if (year == 1990 & groupid == 3442) | (year == 1993 & groupid == 4842) 
 
replace any_a = 0 if (year == 1990 & groupid == 3442) | (year == 1993 & groupid == 4842)  
replace any_b = 0 if (year == 1990 & groupid == 3442) | (year == 1993 & groupid == 4842) 

gen flag1 = ((year == 1990 & groupid == 3442) | (year == 1993 & groupid == 4842) )
lab var flag1 "Recoded part=0 (since viop=peacep=winner=0 and part = 1)"

* Creating shares and counts

preserve

	collapse (sum) viop peacep winner active part_r election mgy mgey viopr_a viopr_b peacepr_a peacepr_b winnerr_a winnerr_b any_a any_b, by(year)
	local variables part_r viopr_a viopr_b peacepr_a peacepr_b winnerr_a winnerr_b any_a any_b
	foreach var of local variables {
		gen `var'_mgey = (`var'/mgey)*100
		replace `var'_mgey = round(`var'_mgey,0.1) 
		gen `var'_mgy = (`var'/mgy)*100
		replace `var'_mgy = round(`var'_mgy,0.1)
	}

	order year viop peacep winner active part_r election mgey mgy
	export excel using "$results/conflict_data1.xlsx", sheetmodify sheet("dynamic_conflict1") cell(B3)  first(var)
	
	* Saving Stata file that will be the input to run the R code to replicate Figures 2.2 and 2.3 in Appendix 2.
	
	save "$root/dynamic_conflict1.dta", replace

restore

use "$root/dynamic_conflict1.dta", clear
 
/*===============================================================================================
                             3: Replication Flores & Nooruddin (2012)
===============================================================================================*/

* NOTES: 
* 1. Original data and full code can be found at: https://dataverse.harvard.edu/dataset.xhtml?persistentId=hdl:1902.1/19212
* 2. Store replication data in folder defined as global "root". 

*------------------------------------3.1:Clean and prepare data ------------------------------------

use "$root/Flores&Nooruddin.JOP2012.Replication data file.dta", clear

list cowcode ctryname year if recovery_num2==. & recover_time2 != .

replace recovery_num2=1 if recovery_num2==. & recover_time2!=. & cowcode==373
replace recovery_num2=2 if recovery_num2==. & recover_time2!=. & cowcode==522
replace recovery_num2=1 if recovery_num2==. & recover_time2!=. & cowcode==372
keep recovery_num2 cowcode year
sort cowcode year

save "$root/FNPostConflict.dta", replace

import delimited using "$excel/MGEP_S2016_Release.csv", varnames(1) case(lower) clear 
drop v25

* Identify all years of peaceful and won participation:

gen peacepyear=year if peacep==1
by groupid, sort: egen peacepyearall=max(peacepyear)
gen peacepall=1 if part==1 & year>=peacepyearall

* Add Angola in 1992 since it has two peaceful participation events:
replace peacepall=1 if peacep==1
replace peacepall=0 if peacepall==.

gen winneryear=year if winner==1
by groupid, sort: egen winneryearall=max(winneryear)
gen winnerall=1 if part==1 & year>=winneryearall
replace winnerall=0 if winnerall==.

* Generate country-year indicators instead of group-year indicators:
by countryid year, sort: egen cpeacepall=max(peacepall)
by countryid year, sort: egen cwinnerall=max(winnerall)

* Reduce to country-years:
sort countryid year
quietly by countryid year:  gen dup = cond(_N==1,0,_n)
tab dup
drop if dup>1

* Ready for merge:
rename countryid cowcode
sort cowcode year

* Generate dummies for each recovery period in FN instead of country-year indicators:
sort cowcode year
sum cowcode
merge m:m cowcode year using "$root/FNPostConflict.dta"

drop if _merge==2
sum cowcode
drop _merge
by cowcode recovery_num2, sort: egen speacepall=max(cpeacepall)
by cowcode recovery_num2, sort: egen swinnerall=max(cwinnerall)
replace speacepall=. if recovery_num2==.
replace swinnerall=. if recovery_num2==.
drop recovery_num2
sort cowcode year

save "$root/MGEPvf.dta", replace

use "$root/Flores&Nooruddin.JOP2012.Replication data file.dta", clear 
sort cowcode year
merge m:m cowcode year using "$root/MGEPvf.dta" 
list cowcode basestate year if _merge==2&year<2002&year>1959
list cowcode ctryname year if _merge==1&year&year>1970& recover_time2 !=.
drop if _merge==2
drop _merge

* Extend the countries that have not recovered within 10 years
replace speacepall=0 if cowcode==490&year==1989
replace swinnerall=0 if cowcode==490&year==1989
replace speacepall=0 if cowcode==580&year==1982
replace swinnerall=0 if cowcode==580&year==1982
replace speacepall=0 if cowcode==580&year==1983
replace swinnerall=0 if cowcode==580&year==1983
replace speacepall=0 if cowcode==580&year==1984
replace swinnerall=0 if cowcode==580&year==1984
replace speacepall=0 if cowcode==580&year==1985
replace swinnerall=0 if cowcode==580&year==1985
replace speacepall=0 if cowcode==580&year==1986
replace swinnerall=0 if cowcode==580&year==1986
replace speacepall=0 if cowcode==580&year==1987
replace swinnerall=0 if cowcode==580&year==1987
replace speacepall=0 if cowcode==580&year==1988
replace swinnerall=0 if cowcode==580&year==1988
replace speacepall=0 if cowcode==580&year==1989
replace swinnerall=0 if cowcode==580&year==1989
replace speacepall=0 if cowcode==580&year==1990
replace swinnerall=0 if cowcode==580&year==1990
replace speacepall=0 if cowcode==580&year==1991
replace swinnerall=0 if cowcode==580&year==1991
replace speacepall=0 if cowcode==580&year==1992
replace swinnerall=0 if cowcode==580&year==1992
replace speacepall=0 if cowcode==580&year==1993
replace swinnerall=0 if cowcode==580&year==1993
replace speacepall=0 if cowcode==580&year==1994
replace swinnerall=0 if cowcode==580&year==1994
replace speacepall=0 if cowcode==580&year==1995
replace swinnerall=0 if cowcode==580&year==1995
replace speacepall=0 if cowcode==580&year==1996
replace swinnerall=0 if cowcode==580&year==1996
replace speacepall=0 if cowcode==580&year==1997
replace swinnerall=0 if cowcode==580&year==1997
replace speacepall=0 if cowcode==580&year==1998
replace swinnerall=0 if cowcode==580&year==1998
replace speacepall=0 if cowcode==580&year==1999
replace swinnerall=0 if cowcode==580&year==1999
replace speacepall=0 if cowcode==580&year==2000
replace swinnerall=0 if cowcode==580&year==2000
replace speacepall=0 if cowcode==580&year==2001
replace swinnerall=0 if cowcode==580&year==2001
replace speacepall=0 if cowcode==580&year==2002
replace swinnerall=0 if cowcode==580&year==2002
replace speacepall=0 if cowcode==670&year==1990
replace swinnerall=0 if cowcode==670&year==1990
replace speacepall=0 if cowcode==670&year==1991
replace swinnerall=0 if cowcode==670&year==1991
replace speacepall=0 if cowcode==670&year==1992
replace swinnerall=0 if cowcode==670&year==1992
replace speacepall=0 if cowcode==670&year==1993
replace swinnerall=0 if cowcode==670&year==1993
replace speacepall=0 if cowcode==670&year==1994
replace swinnerall=0 if cowcode==670&year==1994
replace speacepall=0 if cowcode==670&year==1995
replace swinnerall=0 if cowcode==670&year==1995
replace speacepall=0 if cowcode==670&year==1996
replace swinnerall=0 if cowcode==670&year==1996
replace speacepall=0 if cowcode==670&year==1997
replace swinnerall=0 if cowcode==670&year==1997
replace speacepall=0 if cowcode==360&year==2000
replace swinnerall=0 if cowcode==360&year==2000
replace speacepall=0 if cowcode==360&year==2001
replace swinnerall=0 if cowcode==360&year==2001
replace speacepall=0 if cowcode==360&year==2002
replace swinnerall=0 if cowcode==360&year==2002

save "$root/FN-MGEP-analysisvf.dta", replace


*------------------------------------3.2: Repicate Analysis (Table A.3.1 in Appendix 3) ------------------------------------

/****************************************************************************
*   NOTE: The following code borrows from the original replicationn code    *
*	provided by the authors. 										        *
****************************************************************************/

/*REPLICATION OF TABLE 2 IN ORIGINAL PAPER (PAGE 564): POST-CONFLICT ELECTIONS WORK DIFFERENTLY 
IN NEW DEMOCRACIES */

gen esample=e(sample)
by esample, sort: tab elec_recperiod speacepall
by esample, sort: tab elec_recperiod swinnerall

gen elec=elec_recperiod
replace elec=2 if speacepall==1
replace elec=3 if swinnerall==1
replace elec=. if swinnerall==.

* Prepare variables labels for outreg2: 
lab var prewar_lngdppc2 "Pre-conflict GDP per capita (high)"
lab var ln_oda_constant_new "Official development assistance (log)"
lab var issue_territory_lag "Secessionist conflict"
lab var cw_duration_lag "Conflict duration" 
lab var damage "Damage"
lab var victory_lag "Termination: victory"
lab var peace_agreement_lag "Termination: peace agreement"
lab var recovery_num2 "Recovery number" 
lab var ln_unpkos "UN Peacekeeping Forces (Log)"
lab var wb_dummy "World Bank project"
lab var elec_recperiod "Election during recovery episode"
lab def elec 0"NA" 1"Recovery Election - No MG Participation" 2"Recovery Election - Peaceful MG Participation" 3"Recovery Election - Won MG Participation"
lab val elec elec

* Replication of baseline models 

* 1. Replicated models:

* Recovery:
stset recover_time2, f(recover2==1) exit(exit_year2==1) id(testnewid_lag)
streg prewar_lngdppc2 ln_oda_constant_new issue_territory_lag cw_duration_lag damage victory_lag peace_agreement_lag recovery_num2 ln_unpkos wb_dummy elec_recperiod if west==0, dist(lnormal) nolog cluster(id) 
outreg2 using "$results/ReplicationF&N", addstat(Log pseudolikelihood, `e(ll)', Sigma, `e(sigma)') ctitle(Recovery*) dec(2) label ///
word title(Table A3.1: Effects of Post-Conflict ElectionsÑwith MGEP Indicators) ///
addnote("*These are the exact replication of F&N. Running these models in the same sample of matched data as the new models produces very similar results (281 rather than 364 cases): the election indicator remains negative in both, although the effect is slightly smaller and only statistically significant at the 0.10 level in the recurrence model.") replace

* Recurrence 
stset recover_time2, f(recur2==1) exit(exit_year2==1) id(testnewid_lag)
streg prewar_lngdppc2 ln_oda_constant_new issue_territory_lag cw_duration_lag damage victory_lag peace_agreement_lag recovery_num2 ln_unpkos wb_dummy elec_recperiod if west==0, dist(lnormal) nolog cluster(id) 
outreg2 using "$results/ReplicationF&N", addstat(Log pseudolikelihood, `e(ll)', Sigma, `e(sigma)') ctitle(Recurrence*) dec(2) label ///
word title(Table A3.1: Effects of Post-Conflict ElectionsÑwith MGEP Indicators) ///
addnote("*These are the exact replication of F&N. Running these models in the same sample of matched data as the new models produces very similar results (281 rather than 364 cases): the election indicator remains negative in both, although the effect is slightly smaller and only statistically significant at the 0.10 level in the recurrence model.") append

* 2. New models (with MGEP variables)

* Recovery 
stset recover_time2, f(recover2==1) exit(exit_year2==1) id(testnewid_lag)
streg prewar_lngdppc2 ln_oda_constant_new issue_territory_lag cw_duration_lag damage victory_lag peace_agreement_lag recovery_num2 ln_unpkos wb_dummy i.elec if west==0, dist(lnormal) nolog cluster(id) 
outreg2 using "$results/ReplicationF&N", addstat(Log pseudolikelihood, `e(ll)', Sigma, `e(sigma)') ctitle(Recovery) dec(2) label ///
word title(Table A3.1: Effects of Post-Conflict ElectionsÑwith MGEP Indicators) ///
addnote("*These are the exact replication of F&N. Running these models in the same sample of matched data as the new models produces very similar results (281 rather than 364 cases): the election indicator remains negative in both, although the effect is slightly smaller and only statistically significant at the 0.10 level in the recurrence model.") append

* Recurrence 
stset recover_time2, f(recur2==1) exit(exit_year2==1) id(testnewid_lag)
streg prewar_lngdppc2 ln_oda_constant_new issue_territory_lag cw_duration_lag damage victory_lag peace_agreement_lag recovery_num2 ln_unpkos wb_dummy i.elec if west==0, dist(lnormal) nolog cluster(id) 
outreg2 using "$results/ReplicationF&N", addstat(Log pseudolikelihood, `e(ll)', Sigma, `e(sigma)') ctitle(Recurrence) dec(2) label ///
word title(Table A3.1: Effects of Post-Conflict ElectionsÑwith MGEP Indicators) ///
addnote("*These are the exact replication of F&N. Running these models in the same sample of matched data as the new models produces very similar results (281 rather than 364 cases): the election indicator remains negative in both, although the effect is slightly smaller and only statistically significant at the 0.10 level in the recurrence model.") append

exit
/* End of do-file */

><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><

Notes:
1. Do file (section 3.2) uses replication code from Flores & Nooruddin (2012)
2. Database version "MGEP_S2016_Release.csv"


Version Control: 6


