clear
set memory 500m

/* Important: you need to put the .dat and .do files in one folder/
   directory and then set the working folder to that folder. */

set more off

clear
infix ///
 byte    datanum       1-2 ///
 double  serial        3-10 ///
 byte    pernum       11-12 ///
 long    bpld         13-17 ///
 int     occ1990      18-20 ///
 int     pwmetro      21-24 ///
 using "C:\Documents and Settings\Krishna Patel\My Documents\thesis_topic occdist\census\kp49_georgetown_edu_081.dat"

label var datanum "Data set number"
label var serial "Household serial number"
label var pernum "Person number in sample unit"
label var bpld "Birthplace [detailed version]"
label var occ1990 "Occupation, 1990 basis"
label var pwmetro "Place of work: metropolitan area"

label values datanum datanumlbl

label values serial seriallbl

label values pernum pernumlbl

label define bpldlbl 00100 "Alabama", add
label define bpldlbl 00200 "Alaska", add
label define bpldlbl 00400 "Arizona", add
label define bpldlbl 00500 "Arkansas", add
label define bpldlbl 00600 "California", add
label define bpldlbl 00800 "Colorado", add
label define bpldlbl 00900 "Connecticut", add
label define bpldlbl 01000 "Delaware", add
label define bpldlbl 01100 "District of Columbia", add
label define bpldlbl 01200 "Florida", add
label define bpldlbl 01300 "Georgia", add
label define bpldlbl 01500 "Hawaii", add
label define bpldlbl 01600 "Idaho", add
label define bpldlbl 01610 "Idaho Territory", add
label define bpldlbl 01700 "Illinois", add
label define bpldlbl 01800 "Indiana", add
label define bpldlbl 01900 "Iowa", add
label define bpldlbl 02000 "Kansas", add
label define bpldlbl 02100 "Kentucky", add
label define bpldlbl 02200 "Louisiana", add
label define bpldlbl 02300 "Maine", add
label define bpldlbl 02400 "Maryland", add
label define bpldlbl 02500 "Massachusetts", add
label define bpldlbl 02600 "Michigan", add
label define bpldlbl 02700 "Minnesota", add
label define bpldlbl 02800 "Mississippi", add
label define bpldlbl 02900 "Missouri", add
label define bpldlbl 03000 "Montana", add
label define bpldlbl 03100 "Nebraska", add
label define bpldlbl 03200 "Nevada", add
label define bpldlbl 03300 "New Hampshire", add
label define bpldlbl 03400 "New Jersey", add
label define bpldlbl 03500 "New Mexico", add
label define bpldlbl 03510 "New Mexico Territory", add
label define bpldlbl 03600 "New York", add
label define bpldlbl 03700 "North Carolina", add
label define bpldlbl 03800 "North Dakota", add
label define bpldlbl 03900 "Ohio", add
label define bpldlbl 04000 "Oklahoma", add
label define bpldlbl 04010 "Indian Territory", add
label define bpldlbl 04100 "Oregon", add
label define bpldlbl 04200 "Pennsylvania", add
label define bpldlbl 04400 "Rhode Island", add
label define bpldlbl 04500 "South Carolina", add
label define bpldlbl 04600 "South Dakota", add
label define bpldlbl 04610 "Dakota Territory", add
label define bpldlbl 04700 "Tennessee", add
label define bpldlbl 04800 "Texas", add
label define bpldlbl 04900 "Utah", add
label define bpldlbl 04910 "Utah Territory", add
label define bpldlbl 05000 "Vermont", add
label define bpldlbl 05100 "Virginia", add
label define bpldlbl 05300 "Washington", add
label define bpldlbl 05400 "West Virginia", add
label define bpldlbl 05500 "Wisconsin", add
label define bpldlbl 05600 "Wyoming", add
label define bpldlbl 05610 "Wyoming Territory", add
label define bpldlbl 09000 "Native American", add
label define bpldlbl 09900 "United States, ns", add
label define bpldlbl 10000 "American Samoa", add
label define bpldlbl 10010 "Samoa, 1940-1950", add
label define bpldlbl 10500 "Guam", add
label define bpldlbl 11000 "Puerto Rico", add
label define bpldlbl 11500 "U.S. Virgin Islands", add
label define bpldlbl 11510 "St. Croix", add
label define bpldlbl 11520 "St. John", add
label define bpldlbl 11530 "St. Thomas", add
label define bpldlbl 12000 "Other US Possessions:", add
label define bpldlbl 12010 "Johnston Atoll", add
label define bpldlbl 12020 "Midway Islands", add
label define bpldlbl 12030 "Wake Island", add
label define bpldlbl 12040 "Other US Caribbean Islands", add
label define bpldlbl 12041 "Navassa Island", add
label define bpldlbl 12050 "Other US Pacific Islands", add
label define bpldlbl 12051 "Baker Island", add
label define bpldlbl 12052 "Howland Island", add
label define bpldlbl 12053 "Jarvis Island", add
label define bpldlbl 12054 "Kingman Reef", add
label define bpldlbl 12055 "Palmyra Atoll", add
label define bpldlbl 12060 "Marshall Islands", add
label define bpldlbl 12090 "US outlying areas, ns", add
label define bpldlbl 12091 "US possessions, ns", add
label define bpldlbl 12092 "US territory, ns", add
label define bpldlbl 15000 "Canada", add
label define bpldlbl 15010 "English Canada", add
label define bpldlbl 15011 "British Columbia", add
label define bpldlbl 15013 "Alberta", add
label define bpldlbl 15015 "Saskatchewan", add
label define bpldlbl 15017 "Northwest", add
label define bpldlbl 15019 "Ruperts Land", add
label define bpldlbl 15020 "Manitoba", add
label define bpldlbl 15021 "Red River", add
label define bpldlbl 15030 "Ontario/Upper Canada", add
label define bpldlbl 15031 "Upper Canada", add
label define bpldlbl 15032 "Canada West", add
label define bpldlbl 15040 "New Brunswick", add
label define bpldlbl 15050 "Nova Scotia", add
label define bpldlbl 15051 "Cape Breton", add
label define bpldlbl 15052 "Halifax", add
label define bpldlbl 15060 "Prince Edward Island", add
label define bpldlbl 15070 "Newfoundland", add
label define bpldlbl 15080 "French Canada", add
label define bpldlbl 15081 "Quebec", add
label define bpldlbl 15082 "Lower Canada", add
label define bpldlbl 15083 "Canada East", add
label define bpldlbl 15500 "St. Pierre and Miquelon", add
label define bpldlbl 16000 "Atlantic Islands", add
label define bpldlbl 16010 "Bermuda", add
label define bpldlbl 16020 "Cape Verde", add
label define bpldlbl 16030 "Falkland Islands", add
label define bpldlbl 16040 "Greenland", add
label define bpldlbl 16050 "St. Helena and Ascension", add
label define bpldlbl 16060 "Canary Islands", add
label define bpldlbl 19900 "North America, ns", add
label define bpldlbl 20000 "Mexico", add
label define bpldlbl 21000 "Central America", add
label define bpldlbl 21010 "Belize/British Honduras", add
label define bpldlbl 21020 "Costa Rica", add
label define bpldlbl 21030 "El Salvador", add
label define bpldlbl 21040 "Guatemala", add
label define bpldlbl 21050 "Honduras", add
label define bpldlbl 21060 "Nicaragua", add
label define bpldlbl 21070 "Panama", add
label define bpldlbl 21071 "Canal Zone", add
label define bpldlbl 21090 "Central America, ns", add
label define bpldlbl 25000 "Cuba", add
label define bpldlbl 26000 "West Indies", add
label define bpldlbl 26010 "Dominican Republic", add
label define bpldlbl 26020 "Haiti", add
label define bpldlbl 26030 "Jamaica", add
label define bpldlbl 26040 "British West Indies", add
label define bpldlbl 26041 "Anguilla", add
label define bpldlbl 26042 "Antigua-Barbuda", add
label define bpldlbl 26043 "Bahamas", add
label define bpldlbl 26044 "Barbados", add
label define bpldlbl 26045 "British Virgin Islands", add
label define bpldlbl 26046 "Anegada", add
label define bpldlbl 26047 "Cooper", add
label define bpldlbl 26048 "Jost Van Dyke", add
label define bpldlbl 26049 "Peter", add
label define bpldlbl 26050 "Tortola", add
label define bpldlbl 26051 "Virgin Gorda", add
label define bpldlbl 26052 "Br. Virgin Islands, ns", add
label define bpldlbl 26053 "Cayman Islands", add
label define bpldlbl 26054 "Dominica", add
label define bpldlbl 26055 "Grenada", add
label define bpldlbl 26056 "Montserrat", add
label define bpldlbl 26057 "St. Kitts-Nevis", add
label define bpldlbl 26058 "St. Lucia", add
label define bpldlbl 26059 "St. Vincent", add
label define bpldlbl 26060 "Trinidad and Tobago", add
label define bpldlbl 26061 "Turks and Caicos", add
label define bpldlbl 26069 "British West Indies, ns", add
label define bpldlbl 26070 "Other West Indies", add
label define bpldlbl 26071 "Aruba", add
label define bpldlbl 26072 "Netherlands Antilles", add
label define bpldlbl 26073 "Bonaire", add
label define bpldlbl 26074 "Curacao", add
label define bpldlbl 26075 "Dutch St. Maarten", add
label define bpldlbl 26076 "Saba", add
label define bpldlbl 26077 "St. Eustatius", add
label define bpldlbl 26079 "Dutch Caribbean, ns", add
label define bpldlbl 26080 "French St. Maarten", add
label define bpldlbl 26081 "Guadeloupe", add
label define bpldlbl 26082 "Martinique", add
label define bpldlbl 26083 "St. Barthelemy", add
label define bpldlbl 26089 "French Caribbean, ns", add
label define bpldlbl 26090 "Antilles, n.s.", add
label define bpldlbl 26091 "Caribbean, ns", add
label define bpldlbl 26092 "Latin America, ns", add
label define bpldlbl 26093 "Leeward Islands, ns", add
label define bpldlbl 26094 "West Indies, ns", add
label define bpldlbl 26095 "Windward Islands, ns", add
label define bpldlbl 29999 "Americas, ns", add
label define bpldlbl 30000 "South America", add
label define bpldlbl 30005 "Argentina", add
label define bpldlbl 30010 "Bolivia", add
label define bpldlbl 30015 "Brazil", add
label define bpldlbl 30020 "Chile", add
label define bpldlbl 30025 "Colombia", add
label define bpldlbl 30030 "Ecuador", add
label define bpldlbl 30035 "French Guiana", add
label define bpldlbl 30040 "Guyana/British Guiana", add
label define bpldlbl 30045 "Paraguay", add
label define bpldlbl 30050 "Peru", add
label define bpldlbl 30055 "Suriname", add
label define bpldlbl 30060 "Uruguay", add
label define bpldlbl 30065 "Venezuela", add
label define bpldlbl 30090 "South America, ns", add
label define bpldlbl 30091 "South and Central America, n.s.", add
label define bpldlbl 40000 "Denmark", add
label define bpldlbl 40010 "Faeroe Islands", add
label define bpldlbl 40100 "Finland", add
label define bpldlbl 40200 "Iceland", add
label define bpldlbl 40300 "Lapland, ns", add
label define bpldlbl 40400 "Norway", add
label define bpldlbl 40410 "Svalbard and Jan Meyen", add
label define bpldlbl 40411 "Svalbard", add
label define bpldlbl 40412 "Jan Meyen", add
label define bpldlbl 40500 "Sweden", add
label define bpldlbl 41000 "England", add
label define bpldlbl 41010 "Channel Islands", add
label define bpldlbl 41011 "Guernsey", add
label define bpldlbl 41012 "Jersey", add
label define bpldlbl 41020 "Isle of Man", add
label define bpldlbl 41100 "Scotland", add
label define bpldlbl 41200 "Wales", add
label define bpldlbl 41300 "United Kingdom, ns", add
label define bpldlbl 41400 "Ireland", add
label define bpldlbl 41410 "Northern Ireland", add
label define bpldlbl 41900 "Northern Europe, ns", add
label define bpldlbl 42000 "Belgium", add
label define bpldlbl 42100 "France", add
label define bpldlbl 42110 "Alsace-Lorraine", add
label define bpldlbl 42111 "Alsace", add
label define bpldlbl 42112 "Lorraine", add
label define bpldlbl 42200 "Liechtenstein", add
label define bpldlbl 42300 "Luxembourg", add
label define bpldlbl 42400 "Monaco", add
label define bpldlbl 42500 "Netherlands", add
label define bpldlbl 42600 "Switerland", add
label define bpldlbl 42900 "Western Europe, ns", add
label define bpldlbl 43000 "Albania", add
label define bpldlbl 43100 "Andorra", add
label define bpldlbl 43200 "Gibraltar", add
label define bpldlbl 43300 "Greece", add
label define bpldlbl 43310 "Dodecanese Islands", add
label define bpldlbl 43320 "Turkey Greece", add
label define bpldlbl 43330 "Macedonia", add
label define bpldlbl 43400 "Italy", add
label define bpldlbl 43500 "Malta", add
label define bpldlbl 43600 "Portugal", add
label define bpldlbl 43610 "Azores", add
label define bpldlbl 43620 "Madeira Islands", add
label define bpldlbl 43630 "Cape Verde Islands", add
label define bpldlbl 43640 "St. Miguel", add
label define bpldlbl 43700 "San Marino", add
label define bpldlbl 43800 "Spain", add
label define bpldlbl 43900 "Vatican City", add
label define bpldlbl 44000 "Southern Europe, ns", add
label define bpldlbl 45000 "Austria", add
label define bpldlbl 45010 "Austria-Hungary", add
label define bpldlbl 45020 "Austria-Graz", add
label define bpldlbl 45030 "Austria-Linz", add
label define bpldlbl 45040 "Austria-Salzburg", add
label define bpldlbl 45050 "Austria-Tyrol", add
label define bpldlbl 45060 "Austria-Vienna", add
label define bpldlbl 45070 "Austria-Kaernsten", add
label define bpldlbl 45080 "Austria-Neustadt", add
label define bpldlbl 45100 "Bulgaria", add
label define bpldlbl 45200 "Czechoslovakia", add
label define bpldlbl 45210 "Bohemia", add
label define bpldlbl 45211 "Bohemia-Moravia", add
label define bpldlbl 45212 "Slovakia", add
label define bpldlbl 45213 "Czech Republic", add
label define bpldlbl 45300 "Germany", add
label define bpldlbl 45301 "Berlin", add
label define bpldlbl 45310 "West Germany", add
label define bpldlbl 45311 "Baden", add
label define bpldlbl 45312 "Bavaria", add
label define bpldlbl 45313 "Bremen", add
label define bpldlbl 45314 "Brunswick", add
label define bpldlbl 45315 "Hamburg", add
label define bpldlbl 45316 "Hanover", add
label define bpldlbl 45317 "Hessen", add
label define bpldlbl 45318 "Hessen Nassau", add
label define bpldlbl 45319 "Holstein", add
label define bpldlbl 45320 "Lippe", add
label define bpldlbl 45321 "Lubeck", add
label define bpldlbl 45322 "Oldenburg", add
label define bpldlbl 45323 "Rhine Province", add
label define bpldlbl 45324 "Schleswig", add
label define bpldlbl 45325 "Schleswig-Holstein", add
label define bpldlbl 45326 "Schwarzburg", add
label define bpldlbl 45327 "Waldeck", add
label define bpldlbl 45328 "West Berlin", add
label define bpldlbl 45329 "Westphalia", add
label define bpldlbl 45330 "Wurttemberg", add
label define bpldlbl 45331 "Frankfurt", add
label define bpldlbl 45332 "Saarland", add
label define bpldlbl 45333 "Nordrheim-Westfalen", add
label define bpldlbl 45340 "East Germany", add
label define bpldlbl 45341 "Anhalt", add
label define bpldlbl 45342 "Brandenburg", add
label define bpldlbl 45343 "East Berlin", add
label define bpldlbl 45344 "Mecklenburg", add
label define bpldlbl 45345 "Sachsen-Altenburg", add
label define bpldlbl 45346 "Sachsen-Coburg", add
label define bpldlbl 45347 "Sachsen-Gotha", add
label define bpldlbl 45348 "Sachsen-Meiningen", add
label define bpldlbl 45349 "Sachsen-Weimar-Eisenach", add
label define bpldlbl 45350 "Saxony", add
label define bpldlbl 45351 "Schwerin", add
label define bpldlbl 45352 "Strelitz", add
label define bpldlbl 45353 "Thuringian States", add
label define bpldlbl 45360 "Prussia, nec", add
label define bpldlbl 45361 "Hohenzollern", add
label define bpldlbl 45362 "Niedersachsen", add
label define bpldlbl 45400 "Hungary", add
label define bpldlbl 45500 "Poland", add
label define bpldlbl 45510 "Austrian Poland", add
label define bpldlbl 45511 "Galicia", add
label define bpldlbl 45520 "German Poland", add
label define bpldlbl 45521 "East Prussia", add
label define bpldlbl 45522 "Pomerania", add
label define bpldlbl 45523 "Posen", add
label define bpldlbl 45524 "Prussian Poland", add
label define bpldlbl 45525 "Silesia", add
label define bpldlbl 45526 "West Prussia", add
label define bpldlbl 45530 "Russian Poland", add
label define bpldlbl 45600 "Romania", add
label define bpldlbl 45610 "Transylvania", add
label define bpldlbl 45700 "Yugoslavia", add
label define bpldlbl 45710 "Croatia", add
label define bpldlbl 45720 "Montenegro", add
label define bpldlbl 45730 "Serbia", add
label define bpldlbl 45740 "Bosnia", add
label define bpldlbl 45750 "Dalmatia", add
label define bpldlbl 45760 "Slovonia", add
label define bpldlbl 45770 "Carniola", add
label define bpldlbl 45780 "Slovenia", add
label define bpldlbl 45790 "Kosovo", add
label define bpldlbl 45800 "Central Europe, ns", add
label define bpldlbl 45900 "Eastern Europe, ns", add
label define bpldlbl 46000 "Estonia", add
label define bpldlbl 46100 "Latvia", add
label define bpldlbl 46200 "Lithuania", add
label define bpldlbl 46300 "Baltic States, ns", add
label define bpldlbl 46500 "Other USSR/Russia", add
label define bpldlbl 46510 "Byelorussia", add
label define bpldlbl 46520 "Moldavia", add
label define bpldlbl 46521 "Bessarabia", add
label define bpldlbl 46530 "Ukraine", add
label define bpldlbl 46540 "Armenia", add
label define bpldlbl 46541 "Azerbaijan", add
label define bpldlbl 46542 "Georgia", add
label define bpldlbl 46543 "Kazakhstan", add
label define bpldlbl 46544 "Kirghizia", add
label define bpldlbl 46545 "Tadzhik", add
label define bpldlbl 46546 "Turkmenistan", add
label define bpldlbl 46547 "Uzbekistan", add
label define bpldlbl 46548 "Siberia", add
label define bpldlbl 46590 "USSR, ns", add
label define bpldlbl 49900 "Europe, ns.", add
label define bpldlbl 50000 "China", add
label define bpldlbl 50010 "Hong Kong", add
label define bpldlbl 50020 "Macau", add
label define bpldlbl 50030 "Mongolia", add
label define bpldlbl 50040 "Taiwan", add
label define bpldlbl 50100 "Japan", add
label define bpldlbl 50200 "Korea", add
label define bpldlbl 50210 "North Korea", add
label define bpldlbl 50220 "South Korea", add
label define bpldlbl 50900 "East Asia, ns", add
label define bpldlbl 51000 "Brunei", add
label define bpldlbl 51100 "Cambodia (Kampuchea)", add
label define bpldlbl 51200 "Indonesia", add
label define bpldlbl 51210 "East Indies", add
label define bpldlbl 51220 "East Timor", add
label define bpldlbl 51300 "Laos", add
label define bpldlbl 51400 "Malaysia", add
label define bpldlbl 51500 "Philippines", add
label define bpldlbl 51600 "Singapore", add
label define bpldlbl 51700 "Thailand", add
label define bpldlbl 51800 "Vietnam", add
label define bpldlbl 51900 "Southeast Asia, ns", add
label define bpldlbl 51910 "Indochina, ns", add
label define bpldlbl 52000 "Afghanistan", add
label define bpldlbl 52100 "India", add
label define bpldlbl 52110 "Bangladesh", add
label define bpldlbl 52120 "Bhutan", add
label define bpldlbl 52130 "Burma (Myanmar)", add
label define bpldlbl 52140 "Pakistan", add
label define bpldlbl 52150 "Sri Lanka (Ceylon)", add
label define bpldlbl 52200 "Iran", add
label define bpldlbl 52300 "Maldives", add
label define bpldlbl 52400 "Nepal", add
label define bpldlbl 53000 "Bahrain", add
label define bpldlbl 53100 "Cyprus", add
label define bpldlbl 53200 "Iraq", add
label define bpldlbl 53210 "Mesopotamia", add
label define bpldlbl 53300 "Iraq/Saudi Arabia", add
label define bpldlbl 53400 "Israel/Palestine", add
label define bpldlbl 53410 "Gaza Strip", add
label define bpldlbl 53420 "Palestine", add
label define bpldlbl 53430 "West Bank", add
label define bpldlbl 53440 "Israel", add
label define bpldlbl 53500 "Jordan", add
label define bpldlbl 53600 "Kuwait", add
label define bpldlbl 53700 "Lebanon", add
label define bpldlbl 53800 "Oman", add
label define bpldlbl 53900 "Qatar", add
label define bpldlbl 54000 "Saudi Arabia", add
label define bpldlbl 54100 "Syria", add
label define bpldlbl 54200 "Turkey", add
label define bpldlbl 54210 "European Turkey", add
label define bpldlbl 54220 "Asian Turkey", add
label define bpldlbl 54300 "United Arab Emirates", add
label define bpldlbl 54400 "Yemen Arab Republic (North)", add
label define bpldlbl 54500 "Yemen, PDR (South)", add
label define bpldlbl 54600 "Persian Gulf States, ns", add
label define bpldlbl 54700 "Middle East, ns", add
label define bpldlbl 54800 "Southwest Asia, nec/ns", add
label define bpldlbl 54900 "Asia Minor, ns", add
label define bpldlbl 55000 "South Asia, nec", add
label define bpldlbl 59900 "Asia, nec/ns", add
label define bpldlbl 60000 "Africa", add
label define bpldlbl 60010 "Northern Africa", add
label define bpldlbl 60011 "Algeria", add
label define bpldlbl 60012 "Egypt/United Arab Rep.", add
label define bpldlbl 60013 "Libya", add
label define bpldlbl 60014 "Morocco", add
label define bpldlbl 60015 "Sudan", add
label define bpldlbl 60016 "Tunisia", add
label define bpldlbl 60017 "Western Sahara", add
label define bpldlbl 60019 "North Africa, ns", add
label define bpldlbl 60020 "Benin", add
label define bpldlbl 60021 "Burkina Faso", add
label define bpldlbl 60022 "Gambia", add
label define bpldlbl 60023 "Ghana", add
label define bpldlbl 60024 "Guinea", add
label define bpldlbl 60025 "Guinea-Bissau", add
label define bpldlbl 60026 "Ivory Coast", add
label define bpldlbl 60027 "Liberia", add
label define bpldlbl 60028 "Mali", add
label define bpldlbl 60029 "Mauritania", add
label define bpldlbl 60030 "Niger", add
label define bpldlbl 60031 "Nigeria", add
label define bpldlbl 60032 "Senegal", add
label define bpldlbl 60033 "Sierra Leone", add
label define bpldlbl 60034 "Togo", add
label define bpldlbl 60038 "Western Africa, ns", add
label define bpldlbl 60039 "French West Africa, ns", add
label define bpldlbl 60040 "British Indian Ocean Territory", add
label define bpldlbl 60041 "Burundi", add
label define bpldlbl 60042 "Comoros", add
label define bpldlbl 60043 "Djibouti", add
label define bpldlbl 60044 "Ethiopia", add
label define bpldlbl 60045 "Kenya", add
label define bpldlbl 60046 "Madagascar", add
label define bpldlbl 60047 "Malawi", add
label define bpldlbl 60048 "Mauritius", add
label define bpldlbl 60049 "Mozambique", add
label define bpldlbl 60050 "Reunion", add
label define bpldlbl 60051 "Rwanda", add
label define bpldlbl 60052 "Seychelles", add
label define bpldlbl 60053 "Somalia", add
label define bpldlbl 60054 "Tanzania", add
label define bpldlbl 60055 "Uganda", add
label define bpldlbl 60056 "Zambia", add
label define bpldlbl 60057 "Zimbabwe", add
label define bpldlbl 60058 "Bassas de India", add
label define bpldlbl 60059 "Europa", add
label define bpldlbl 60060 "Gloriosos", add
label define bpldlbl 60061 "Juan de Nova", add
label define bpldlbl 60062 "Mayotte", add
label define bpldlbl 60063 "Tromelin", add
label define bpldlbl 60064 "Eastern Africa, nec/ns", add
label define bpldlbl 60065 "Eritrea", add
label define bpldlbl 60070 "Central Africa", add
label define bpldlbl 60071 "Angola", add
label define bpldlbl 60072 "Cameroon", add
label define bpldlbl 60073 "Central African Republic", add
label define bpldlbl 60074 "Chad", add
label define bpldlbl 60075 "Congo", add
label define bpldlbl 60076 "Equatorial Guinea", add
label define bpldlbl 60077 "Gabon", add
label define bpldlbl 60078 "Sao Tome and Principe", add
label define bpldlbl 60079 "Zaire", add
label define bpldlbl 60080 "Central Africa, ns", add
label define bpldlbl 60081 "Equatorial Africa, ns", add
label define bpldlbl 60082 "French Equatorial Africa, ns", add
label define bpldlbl 60090 "Southern Africa:", add
label define bpldlbl 60091 "Botswana", add
label define bpldlbl 60092 "Lesotho", add
label define bpldlbl 60093 "Namibia", add
label define bpldlbl 60094 "South Africa (Union of)", add
label define bpldlbl 60095 "Swaziland", add
label define bpldlbl 60096 "Southern Africa, ns", add
label define bpldlbl 60099 "Africa, ns/nec", add
label define bpldlbl 70000 "Australia and New Zealand", add
label define bpldlbl 70010 "Australia", add
label define bpldlbl 70011 "Ashmore and Cartier Islands", add
label define bpldlbl 70012 "Coral Sea Islands Territory", add
label define bpldlbl 70020 "New Zealand", add
label define bpldlbl 71000 "Pacific Islands", add
label define bpldlbl 71010 "New Caledonia", add
label define bpldlbl 71011 "Norfolk Islands", add
label define bpldlbl 71012 "Papua New Guinea", add
label define bpldlbl 71013 "Solomon Islands", add
label define bpldlbl 71014 "Vanuatu (New Hebrides)", add
label define bpldlbl 71019 "Melanesia, ns", add
label define bpldlbl 71020 "Cook Islands", add
label define bpldlbl 71021 "Fiji", add
label define bpldlbl 71022 "French Polynesia", add
label define bpldlbl 71023 "Tonga", add
label define bpldlbl 71024 "Wallis and Futuna Islands", add
label define bpldlbl 71025 "Western Samoa", add
label define bpldlbl 71029 "Polynesia, ns", add
label define bpldlbl 71030 "Christmas Island", add
label define bpldlbl 71031 "Cocos Islands", add
label define bpldlbl 71032 "Kiribati", add
label define bpldlbl 71033 "Canton and Enderbury", add
label define bpldlbl 71034 "Nauru", add
label define bpldlbl 71035 "Niue", add
label define bpldlbl 71036 "Pitcairn Island", add
label define bpldlbl 71037 "Tokelau", add
label define bpldlbl 71038 "Tuvalu", add
label define bpldlbl 71039 "Micronesia, ns", add
label define bpldlbl 71040 "US Pacific Trust Territories", add
label define bpldlbl 71041 "Marshall Islands", add
label define bpldlbl 71042 "Micronesia", add
label define bpldlbl 71043 "Kosrae", add
label define bpldlbl 71044 "Pohnpei", add
label define bpldlbl 71045 "Truk", add
label define bpldlbl 71046 "Yap", add
label define bpldlbl 71047 "Northern Mariana Islands", add
label define bpldlbl 71048 "Palau", add
label define bpldlbl 71049 "Pacific Trust Terr, ns", add
label define bpldlbl 71050 "Clipperton Island", add
label define bpldlbl 71090 "Oceania, ns/nec", add
label define bpldlbl 80000 "Antarctica, ns/nec", add
label define bpldlbl 80010 "Bouvet Islands", add
label define bpldlbl 80020 "British Antarctic Terr.", add
label define bpldlbl 80030 "Dronning Maud Land", add
label define bpldlbl 80040 "French Southern and Antarctic Lands", add
label define bpldlbl 80050 "Heard and McDonald Islands", add
label define bpldlbl 90000 "Abroad (unknown) or at sea", add
label define bpldlbl 90010 "Abroad, ns", add
label define bpldlbl 90011 "Abroad (US citizen)", add
label define bpldlbl 90020 "At sea", add
label define bpldlbl 90021 "At sea (US citizen)", add
label define bpldlbl 90022 "At sea or abroad (U.S. citizen)", add
label define bpldlbl 95000 "Other, nec", add
label values bpld bpldlbl

label define occ1990lbl 003 "Legislators", add
label define occ1990lbl 004 "Chief executives and public administrators", add
label define occ1990lbl 007 "Financial managers", add
label define occ1990lbl 008 "Human resources and labor relations managers", add
label define occ1990lbl 013 "Managers and specialists in marketing, advertising, and public relations", add
label define occ1990lbl 014 "Managers in education and related fields", add
label define occ1990lbl 015 "Managers of medicine and health occupations", add
label define occ1990lbl 016 "Postmasters and mail superintendents", add
label define occ1990lbl 017 "Managers of food-serving and lodging establishments", add
label define occ1990lbl 018 "Managers of properties and real estate", add
label define occ1990lbl 019 "Funeral directors", add
label define occ1990lbl 021 "Managers of service organizations, n.e.c.", add
label define occ1990lbl 022 "Managers and administrators, n.e.c.", add
label define occ1990lbl 023 "Accountants and auditors", add
label define occ1990lbl 024 "Insurance underwriters", add
label define occ1990lbl 025 "Other financial specialists", add
label define occ1990lbl 026 "Management analysts", add
label define occ1990lbl 027 "Personnel, HR, training, and labor relations specialists", add
label define occ1990lbl 028 "Purchasing agents and buyers, of farm products", add
label define occ1990lbl 029 "Buyers, wholesale and retail trade", add
label define occ1990lbl 033 "Purchasing managers, agents and buyers, n.e.c.", add
label define occ1990lbl 034 "Business and promotion agents", add
label define occ1990lbl 035 "Construction inspectors", add
label define occ1990lbl 036 "Inspectors and compliance officers, outside construction", add
label define occ1990lbl 037 "Management support occupations", add
label define occ1990lbl 043 "Architects", add
label define occ1990lbl 044 "Aerospace engineer", add
label define occ1990lbl 045 "Metallurgical and materials engineers, variously phrased", add
label define occ1990lbl 047 "Petroleum, mining, and geological engineers", add
label define occ1990lbl 048 "Chemical engineers", add
label define occ1990lbl 053 "Civil engineers", add
label define occ1990lbl 055 "Electrical engineer", add
label define occ1990lbl 056 "Industrial engineers", add
label define occ1990lbl 057 "Mechanical engineers", add
label define occ1990lbl 059 "Not-elsewhere-classified engineers", add
label define occ1990lbl 064 "Computer systems analysts and computer scientists", add
label define occ1990lbl 065 "Operations and systems researchers and analysts", add
label define occ1990lbl 066 "Actuaries", add
label define occ1990lbl 067 "Statisticians", add
label define occ1990lbl 068 "Mathematicians and mathematical scientists", add
label define occ1990lbl 069 "Physicists and astronomers", add
label define occ1990lbl 073 "Chemists", add
label define occ1990lbl 074 "Atmospheric and space scientists", add
label define occ1990lbl 075 "Geologists", add
label define occ1990lbl 076 "Physical scientists, n.e.c.", add
label define occ1990lbl 077 "Agricultural and food scientists", add
label define occ1990lbl 078 "Biological scientists", add
label define occ1990lbl 079 "Foresters and conservation scientists", add
label define occ1990lbl 083 "Medical scientists", add
label define occ1990lbl 084 "Physicians", add
label define occ1990lbl 085 "Dentists", add
label define occ1990lbl 086 "Veterinarians", add
label define occ1990lbl 087 "Optometrists", add
label define occ1990lbl 088 "Podiatrists", add
label define occ1990lbl 089 "Other health and therapy", add
label define occ1990lbl 095 "Registered nurses", add
label define occ1990lbl 096 "Pharmacists", add
label define occ1990lbl 097 "Dietitians and nutritionists", add
label define occ1990lbl 098 "Respiratory therapists", add
label define occ1990lbl 099 "Occupational therapists", add
label define occ1990lbl 103 "Physical therapists", add
label define occ1990lbl 104 "Speech therapists", add
label define occ1990lbl 105 "Therapists, n.e.c.", add
label define occ1990lbl 106 "Physicians' assistants", add
label define occ1990lbl 113 "Earth, environmental, and marine science instructors", add
label define occ1990lbl 114 "Biological science instructors", add
label define occ1990lbl 115 "Chemistry instructors", add
label define occ1990lbl 116 "Physics instructors", add
label define occ1990lbl 118 "Psychology instructors", add
label define occ1990lbl 119 "Economics instructors", add
label define occ1990lbl 123 "History instructors", add
label define occ1990lbl 125 "Sociology instructors", add
label define occ1990lbl 127 "Engineering instructors", add
label define occ1990lbl 128 "Math instructors", add
label define occ1990lbl 139 "Education instructors", add
label define occ1990lbl 145 "Law instructors", add
label define occ1990lbl 147 "Theology instructors", add
label define occ1990lbl 149 "Home economics instructors", add
label define occ1990lbl 150 "Humanities profs/instructors, college, nec", add
label define occ1990lbl 154 "Subject instructors (HS/college)", add
label define occ1990lbl 155 "Kindergarten and earlier school teachers", add
label define occ1990lbl 156 "Primary school teachers", add
label define occ1990lbl 157 "Secondary school teachers", add
label define occ1990lbl 158 "Special education teachers", add
label define occ1990lbl 159 "Teachers , n.e.c.", add
label define occ1990lbl 163 "Vocational and educational counselors", add
label define occ1990lbl 164 "Librarians", add
label define occ1990lbl 165 "Archivists and curators", add
label define occ1990lbl 166 "Economists, market researchers, and survey researchers", add
label define occ1990lbl 167 "Psychologists", add
label define occ1990lbl 168 "Sociologists", add
label define occ1990lbl 169 "Social scientists, n.e.c.", add
label define occ1990lbl 173 "Urban and regional planners", add
label define occ1990lbl 174 "Social workers", add
label define occ1990lbl 175 "Recreation workers", add
label define occ1990lbl 176 "Clergy and religious workers", add
label define occ1990lbl 178 "Lawyers", add
label define occ1990lbl 179 "Judges", add
label define occ1990lbl 183 "Writers and authors", add
label define occ1990lbl 184 "Technical writers", add
label define occ1990lbl 185 "Designers", add
label define occ1990lbl 186 "Musician or composer", add
label define occ1990lbl 187 "Actors, directors, producers", add
label define occ1990lbl 188 "Art makers: painters, sculptors, craft-artists, and print-makers", add
label define occ1990lbl 189 "Photographers", add
label define occ1990lbl 193 "Dancers", add
label define occ1990lbl 194 "Art/entertainment performers and related", add
label define occ1990lbl 195 "Editors and reporters", add
label define occ1990lbl 198 "Announcers", add
label define occ1990lbl 199 "Athletes, sports instructors, and officials", add
label define occ1990lbl 200 "Professionals, n.e.c.", add
label define occ1990lbl 203 "Clinical laboratory technologies and technicians", add
label define occ1990lbl 204 "Dental hygenists", add
label define occ1990lbl 205 "Health record tech specialists", add
label define occ1990lbl 206 "Radiologic tech specialists", add
label define occ1990lbl 207 "Licensed practical nurses", add
label define occ1990lbl 208 "Health technologists and technicians, n.e.c.", add
label define occ1990lbl 213 "Electrical and electronic (engineering) technicians", add
label define occ1990lbl 214 "Engineering technicians, n.e.c.", add
label define occ1990lbl 215 "Mechanical engineering technicians", add
label define occ1990lbl 217 "Drafters", add
label define occ1990lbl 218 "Surveyors, cartographers, mapping scientists and technicians", add
label define occ1990lbl 223 "Biological technicians", add
label define occ1990lbl 224 "Chemical technicians", add
label define occ1990lbl 225 "Other science technicians", add
label define occ1990lbl 226 "Airplane pilots and navigators", add
label define occ1990lbl 227 "Air traffic controllers", add
label define occ1990lbl 228 "Broadcast equipment operators", add
label define occ1990lbl 229 "Computer software developers", add
label define occ1990lbl 233 "Programmers of numerically controlled machine tools", add
label define occ1990lbl 234 "Legal assistants, paralegals, legal support, etc", add
label define occ1990lbl 235 "Technicians, n.e.c.", add
label define occ1990lbl 243 "Supervisors and proprietors of sales jobs", add
label define occ1990lbl 253 "Insurance sales occupations", add
label define occ1990lbl 254 "Real estate sales occupations", add
label define occ1990lbl 255 "Financial services sales occupations", add
label define occ1990lbl 256 "Advertising and related sales jobs", add
label define occ1990lbl 258 "Sales engineers", add
label define occ1990lbl 274 "Salespersons, n.e.c.", add
label define occ1990lbl 275 "Retail sales clerks", add
label define occ1990lbl 276 "Cashiers", add
label define occ1990lbl 277 "Door-to-door sales, street sales, and news vendors", add
label define occ1990lbl 283 "Sales demonstrators / promoters / models", add
label define occ1990lbl 303 "Office supervisors", add
label define occ1990lbl 308 "Computer and peripheral equipment operators", add
label define occ1990lbl 313 "Secretaries", add
label define occ1990lbl 314 "Stenographers", add
label define occ1990lbl 315 "Typists", add
label define occ1990lbl 316 "Interviewers, enumerators, and surveyors", add
label define occ1990lbl 317 "Hotel clerks", add
label define occ1990lbl 318 "Transportation ticket and reservation agents", add
label define occ1990lbl 319 "Receptionists", add
label define occ1990lbl 323 "Information clerks, nec", add
label define occ1990lbl 326 "Correspondence and order clerks", add
label define occ1990lbl 328 "Human resources clerks, except payroll and timekeeping", add
label define occ1990lbl 329 "Library assistants", add
label define occ1990lbl 335 "File clerks", add
label define occ1990lbl 336 "Records clerks", add
label define occ1990lbl 337 "Bookkeepers and accounting and auditing clerks", add
label define occ1990lbl 338 "Payroll and timekeeping clerks", add
label define occ1990lbl 343 "Cost and rate clerks (financial records processing)", add
label define occ1990lbl 344 "Billing clerks and related financial records processing", add
label define occ1990lbl 345 "Duplication machine operators / office machine operators", add
label define occ1990lbl 346 "Mail and paper handlers", add
label define occ1990lbl 347 "Office machine operators, n.e.c.", add
label define occ1990lbl 348 "Telephone operators", add
label define occ1990lbl 349 "Other telecom operators", add
label define occ1990lbl 354 "Postal clerks, excluding mail carriers", add
label define occ1990lbl 355 "Mail carriers for postal service", add
label define occ1990lbl 356 "Mail clerks, outside of post office", add
label define occ1990lbl 357 "Messengers", add
label define occ1990lbl 359 "Dispatchers", add
label define occ1990lbl 361 "Inspectors, n.e.c.", add
label define occ1990lbl 364 "Shipping and receiving clerks", add
label define occ1990lbl 365 "Stock and inventory clerks", add
label define occ1990lbl 366 "Meter readers", add
label define occ1990lbl 368 "Weighers, measurers, and checkers", add
label define occ1990lbl 373 "Material recording, scheduling, production, planning, and expediting clerks", add
label define occ1990lbl 375 "Insurance adjusters, examiners, and investigators", add
label define occ1990lbl 376 "Customer service reps, investigators and adjusters, except insurance", add
label define occ1990lbl 377 "Eligibility clerks for government programs; social welfare", add
label define occ1990lbl 378 "Bill and account collectors", add
label define occ1990lbl 379 "General office clerks", add
label define occ1990lbl 383 "Bank tellers", add
label define occ1990lbl 384 "Proofreaders", add
label define occ1990lbl 385 "Data entry keyers", add
label define occ1990lbl 386 "Statistical clerks", add
label define occ1990lbl 387 "Teacher's aides", add
label define occ1990lbl 389 "Administrative support jobs, n.e.c.", add
label define occ1990lbl 405 "Housekeepers, maids, butlers, stewards, and lodging quarters cleaners", add
label define occ1990lbl 407 "Private household cleaners and servants", add
label define occ1990lbl 415 "Supervisors of guards", add
label define occ1990lbl 417 "Fire fighting, prevention, and inspection", add
label define occ1990lbl 418 "Police, detectives, and private investigators", add
label define occ1990lbl 423 "Other law enforcement: sheriffs, bailiffs, correctional institution officers", add
label define occ1990lbl 425 "Crossing guards and bridge tenders", add
label define occ1990lbl 426 "Guards, watchmen, doorkeepers", add
label define occ1990lbl 427 "Protective services, n.e.c.", add
label define occ1990lbl 434 "Bartenders", add
label define occ1990lbl 435 "Waiter/waitress", add
label define occ1990lbl 436 "Cooks, variously defined", add
label define occ1990lbl 438 "Food counter and fountain workers", add
label define occ1990lbl 439 "Kitchen workers", add
label define occ1990lbl 443 "Waiter's assistant", add
label define occ1990lbl 444 "Misc food prep workers", add
label define occ1990lbl 445 "Dental assistants", add
label define occ1990lbl 446 "Health aides, except nursing", add
label define occ1990lbl 447 "Nursing aides, orderlies, and attendants", add
label define occ1990lbl 448 "Supervisors of cleaning and building service", add
label define occ1990lbl 453 "Janitors", add
label define occ1990lbl 454 "Elevator operators", add
label define occ1990lbl 455 "Pest control occupations", add
label define occ1990lbl 456 "Supervisors of personal service jobs, n.e.c.", add
label define occ1990lbl 457 "Barbers", add
label define occ1990lbl 458 "Hairdressers and cosmetologists", add
label define occ1990lbl 459 "Recreation facility attendants", add
label define occ1990lbl 461 "Guides", add
label define occ1990lbl 462 "Ushers", add
label define occ1990lbl 463 "Public transportation attendants and inspectors", add
label define occ1990lbl 464 "Baggage porters", add
label define occ1990lbl 465 "Welfare service aides", add
label define occ1990lbl 468 "Child care workers", add
label define occ1990lbl 469 "Personal service occupations, nec", add
label define occ1990lbl 473 "Farmers (owners and tenants)", add
label define occ1990lbl 474 "Horticultural specialty farmers", add
label define occ1990lbl 475 "Farm managers, except for horticultural farms", add
label define occ1990lbl 476 "Managers of horticultural specialty farms", add
label define occ1990lbl 479 "Farm workers", add
label define occ1990lbl 483 "Marine life cultivation workers", add
label define occ1990lbl 484 "Nursery farming workers", add
label define occ1990lbl 485 "Supervisors of agricultural occupations", add
label define occ1990lbl 486 "Gardeners and groundskeepers", add
label define occ1990lbl 487 "Animal caretakers except on farms", add
label define occ1990lbl 488 "Graders and sorters of agricultural products", add
label define occ1990lbl 489 "Inspectors of agricultural products", add
label define occ1990lbl 496 "Timber, logging, and forestry workers", add
label define occ1990lbl 498 "Fishers, hunters, and kindred", add
label define occ1990lbl 503 "Supervisors of mechanics and repairers", add
label define occ1990lbl 505 "Automobile mechanics", add
label define occ1990lbl 507 "Bus, truck, and stationary engine mechanics", add
label define occ1990lbl 508 "Aircraft mechanics", add
label define occ1990lbl 509 "Small engine repairers", add
label define occ1990lbl 514 "Auto body repairers", add
label define occ1990lbl 516 "Heavy equipment and farm equipment mechanics", add
label define occ1990lbl 518 "Industrial machinery repairers", add
label define occ1990lbl 519 "Machinery maintenance occupations", add
label define occ1990lbl 523 "Repairers of industrial electrical equipment", add
label define occ1990lbl 525 "Repairers of data processing equipment", add
label define occ1990lbl 526 "Repairers of household appliances and power tools", add
label define occ1990lbl 527 "Telecom and line installers and repairers", add
label define occ1990lbl 533 "Repairers of electrical equipment, n.e.c.", add
label define occ1990lbl 534 "Heating, air conditioning, and refigeration mechanics", add
label define occ1990lbl 535 "Precision makers, repairers, and smiths", add
label define occ1990lbl 536 "Locksmiths and safe repairers", add
label define occ1990lbl 538 "Office machine repairers and mechanics", add
label define occ1990lbl 539 "Repairers of mechanical controls and valves", add
label define occ1990lbl 543 "Elevator installers and repairers", add
label define occ1990lbl 544 "Millwrights", add
label define occ1990lbl 549 "Mechanics and repairers, n.e.c.", add
label define occ1990lbl 558 "Supervisors of construction work", add
label define occ1990lbl 563 "Masons, tilers, and carpet installers", add
label define occ1990lbl 567 "Carpenters", add
label define occ1990lbl 573 "Drywall installers", add
label define occ1990lbl 575 "Electricians", add
label define occ1990lbl 577 "Electric power installers and repairers", add
label define occ1990lbl 579 "Painters, construction and maintenance", add
label define occ1990lbl 583 "Paperhangers", add
label define occ1990lbl 584 "Plasterers", add
label define occ1990lbl 585 "Plumbers, pipe fitters, and steamfitters", add
label define occ1990lbl 588 "Concrete and cement workers", add
label define occ1990lbl 589 "Glaziers", add
label define occ1990lbl 593 "Insulation workers", add
label define occ1990lbl 594 "Paving, surfacing, and tamping equipment operators", add
label define occ1990lbl 595 "Roofers and slaters", add
label define occ1990lbl 596 "Sheet metal duct installers", add
label define occ1990lbl 597 "Structural metal workers", add
label define occ1990lbl 598 "Drillers of earth", add
label define occ1990lbl 599 "Construction trades, n.e.c.", add
label define occ1990lbl 614 "Drillers of oil wells", add
label define occ1990lbl 615 "Explosives workers", add
label define occ1990lbl 616 "Miners", add
label define occ1990lbl 617 "Other mining occupations", add
label define occ1990lbl 628 "Production supervisors or foremen", add
label define occ1990lbl 634 "Tool and die makers and die setters", add
label define occ1990lbl 637 "Machinists", add
label define occ1990lbl 643 "Boilermakers", add
label define occ1990lbl 644 "Precision grinders and filers", add
label define occ1990lbl 645 "Patternmakers and model makers", add
label define occ1990lbl 646 "Lay-out workers", add
label define occ1990lbl 649 "Engravers", add
label define occ1990lbl 653 "Tinsmiths, coppersmiths, and sheet metal workers", add
label define occ1990lbl 657 "Cabinetmakers and bench carpenters", add
label define occ1990lbl 658 "Furniture and wood finishers", add
label define occ1990lbl 659 "Other precision woodworkers", add
label define occ1990lbl 666 "Dressmakers and seamstresses", add
label define occ1990lbl 667 "Tailors", add
label define occ1990lbl 668 "Upholsterers", add
label define occ1990lbl 669 "Shoe repairers", add
label define occ1990lbl 674 "Other precision apparel and fabric workers", add
label define occ1990lbl 675 "Hand molders and shapers, except jewelers", add
label define occ1990lbl 677 "Optical goods workers", add
label define occ1990lbl 678 "Dental laboratory and medical appliance technicians", add
label define occ1990lbl 679 "Bookbinders", add
label define occ1990lbl 684 "Other precision and craft workers", add
label define occ1990lbl 686 "Butchers and meat cutters", add
label define occ1990lbl 687 "Bakers", add
label define occ1990lbl 688 "Batch food makers", add
label define occ1990lbl 693 "Adjusters and calibrators", add
label define occ1990lbl 694 "Water and sewage treatment plant operators", add
label define occ1990lbl 695 "Power plant operators", add
label define occ1990lbl 696 "Plant and system operators, stationary engineers", add
label define occ1990lbl 699 "Other plant and system operators", add
label define occ1990lbl 703 "Lathe, milling, and turning machine operatives", add
label define occ1990lbl 706 "Punching and stamping press operatives", add
label define occ1990lbl 707 "Rollers, roll hands, and finishers of metal", add
label define occ1990lbl 708 "Drilling and boring machine operators", add
label define occ1990lbl 709 "Grinding, abrading, buffing, and polishing workers", add
label define occ1990lbl 713 "Forge and hammer operators", add
label define occ1990lbl 717 "Fabricating machine operators, n.e.c.", add
label define occ1990lbl 719 "Molders, and casting machine operators", add
label define occ1990lbl 723 "Metal platers", add
label define occ1990lbl 724 "Heat treating equipment operators", add
label define occ1990lbl 726 "Wood lathe, routing, and planing machine operators", add
label define occ1990lbl 727 "Sawing machine operators and sawyers", add
label define occ1990lbl 728 "Shaping and joining machine operator (woodworking)", add
label define occ1990lbl 729 "Nail and tacking machine operators  (woodworking)", add
label define occ1990lbl 733 "Other woodworking machine operators", add
label define occ1990lbl 734 "Printing machine operators, n.e.c.", add
label define occ1990lbl 735 "Photoengravers and lithographers", add
label define occ1990lbl 736 "Typesetters and compositors", add
label define occ1990lbl 738 "Winding and twisting textile/apparel operatives", add
label define occ1990lbl 739 "Knitters, loopers, and toppers textile operatives", add
label define occ1990lbl 743 "Textile cutting machine operators", add
label define occ1990lbl 744 "Textile sewing machine operators", add
label define occ1990lbl 745 "Shoemaking machine operators", add
label define occ1990lbl 747 "Pressing machine operators (clothing)", add
label define occ1990lbl 748 "Laundry workers", add
label define occ1990lbl 749 "Misc textile machine operators", add
label define occ1990lbl 753 "Cementing and gluing maching operators", add
label define occ1990lbl 754 "Packers, fillers, and wrappers", add
label define occ1990lbl 755 "Extruding and forming machine operators", add
label define occ1990lbl 756 "Mixing and blending machine operatives", add
label define occ1990lbl 757 "Separating, filtering, and clarifying machine operators", add
label define occ1990lbl 759 "Painting machine operators", add
label define occ1990lbl 763 "Roasting and baking machine operators (food)", add
label define occ1990lbl 764 "Washing, cleaning, and pickling machine operators", add
label define occ1990lbl 765 "Paper folding machine operators", add
label define occ1990lbl 766 "Furnace, kiln, and oven operators, apart from food", add
label define occ1990lbl 768 "Crushing and grinding machine operators", add
label define occ1990lbl 769 "Slicing and cutting machine operators", add
label define occ1990lbl 773 "Motion picture projectionists", add
label define occ1990lbl 774 "Photographic process workers", add
label define occ1990lbl 779 "Machine operators, n.e.c.", add
label define occ1990lbl 783 "Welders and metal cutters", add
label define occ1990lbl 784 "Solderers", add
label define occ1990lbl 785 "Assemblers of electrical equipment", add
label define occ1990lbl 789 "Hand painting, coating, and decorating occupations", add
label define occ1990lbl 796 "Production checkers and inspectors", add
label define occ1990lbl 799 "Graders and sorters in manufacturing", add
label define occ1990lbl 803 "Supervisors of motor vehicle transportation", add
label define occ1990lbl 804 "Truck, delivery, and tractor drivers", add
label define occ1990lbl 808 "Bus drivers", add
label define occ1990lbl 809 "Taxi cab drivers and chauffeurs", add
label define occ1990lbl 813 "Parking lot attendants", add
label define occ1990lbl 823 "Railroad conductors and yardmasters", add
label define occ1990lbl 824 "Locomotive operators (engineers and firemen)", add
label define occ1990lbl 825 "Railroad brake, coupler, and switch operators", add
label define occ1990lbl 829 "Ship crews and marine engineers", add
label define occ1990lbl 834 "Water transport infrastructure tenders and crossing guards", add
label define occ1990lbl 844 "Operating engineers of construction equipment", add
label define occ1990lbl 848 "Crane, derrick, winch, and hoist operators", add
label define occ1990lbl 853 "Excavating and loading machine operators", add
label define occ1990lbl 859 "Misc material moving occupations", add
label define occ1990lbl 865 "Helpers, constructions", add
label define occ1990lbl 866 "Helpers, surveyors", add
label define occ1990lbl 869 "Construction laborers", add
label define occ1990lbl 873 "Production helpers", add
label define occ1990lbl 875 "Garbage and recyclable material collectors", add
label define occ1990lbl 876 "Materials movers: stevedores and longshore workers", add
label define occ1990lbl 877 "Stock handlers", add
label define occ1990lbl 878 "Machine feeders and offbearers", add
label define occ1990lbl 883 "Freight, stock, and materials handlers", add
label define occ1990lbl 885 "Garage and service station related occupations", add
label define occ1990lbl 887 "Vehicle washers and equipment cleaners", add
label define occ1990lbl 888 "Packers and packagers by hand", add
label define occ1990lbl 889 "Laborers outside construction", add
label define occ1990lbl 905 "Military", add
label define occ1990lbl 991 "Unemployed", add
label define occ1990lbl 999 "Unknown", add
label values occ1990 occ1990lbl

label define pwmetrolbl 0000 "N/A or not identifiable"
label define pwmetrolbl 0040 "Abilene, TX", add
label define pwmetrolbl 0060 "Aguadilla, PR", add
label define pwmetrolbl 0080 "Akron, OH", add
label define pwmetrolbl 0120 "Albany, GA", add
label define pwmetrolbl 0160 "Albany-Schenectady-Troy, NY", add
label define pwmetrolbl 0200 "Albuquerque, NM", add
label define pwmetrolbl 0220 "Alexandria, LA", add
label define pwmetrolbl 0240 "Allentown-Bethlehem-Easton, PA/NJ", add
label define pwmetrolbl 0280 "Altoona, PA", add
label define pwmetrolbl 0320 "Amarillo, TX", add
label define pwmetrolbl 0380 "Anchorage, AK", add
label define pwmetrolbl 0400 "Anderson, IN", add
label define pwmetrolbl 0440 "Ann Arbor, MI", add
label define pwmetrolbl 0450 "Anniston, AL", add
label define pwmetrolbl 0460 "Appleton-Oskosh-Neenah, WI", add
label define pwmetrolbl 0470 "Arecibo, PR", add
label define pwmetrolbl 0480 "Asheville, NC", add
label define pwmetrolbl 0500 "Athens, GA", add
label define pwmetrolbl 0520 "Atlanta, GA", add
label define pwmetrolbl 0560 "Atlantic City, NJ", add
label define pwmetrolbl 0580 "Auburn-Opekika, AL", add
label define pwmetrolbl 0600 "Augusta-Aiken, GA-SC", add
label define pwmetrolbl 0640 "Austin, TX", add
label define pwmetrolbl 0680 "Bakersfield, CA", add
label define pwmetrolbl 0720 "Baltimore, MD", add
label define pwmetrolbl 0730 "Bangor, ME", add
label define pwmetrolbl 0740 "Barnstable-Yarmouth, MA", add
label define pwmetrolbl 0760 "Baton Rouge, LA", add
label define pwmetrolbl 0780 "Battle Creek, MI", add
label define pwmetrolbl 0840 "Beaumont-Port Arthur-Orange, TX", add
label define pwmetrolbl 0860 "Bellingham, WA", add
label define pwmetrolbl 0870 "Benton Harbor, MI", add
label define pwmetrolbl 0880 "Billings, MT", add
label define pwmetrolbl 0920 "Biloxi-Gulfport, MS", add
label define pwmetrolbl 0960 "Binghamton, NY", add
label define pwmetrolbl 1000 "Birmingham, AL", add
label define pwmetrolbl 1010 "Bismarck, ND", add
label define pwmetrolbl 1020 "Bloomington, IN", add
label define pwmetrolbl 1040 "Bloomington-Normal, IL", add
label define pwmetrolbl 1080 "Boise City, ID", add
label define pwmetrolbl 1120 "Boston, MA", add
label define pwmetrolbl 1121 "Lawrence-Haverhill, MA/NH", add
label define pwmetrolbl 1122 "Lowell, MA/NH", add
label define pwmetrolbl 1123 "Salem-Gloucester, MA", add
label define pwmetrolbl 1140 "Bradenton, FL", add
label define pwmetrolbl 1150 "Bremerton, WA", add
label define pwmetrolbl 1160 "Bridgeport, CT", add
label define pwmetrolbl 1200 "Brockton, MA", add
label define pwmetrolbl 1240 "Brownsville - Harlingen-San Benito, TX", add
label define pwmetrolbl 1260 "Bryan-College Station, TX", add
label define pwmetrolbl 1280 "Buffalo-Niagara Falls, NY", add
label define pwmetrolbl 1281 "Niagara Falls, NY", add
label define pwmetrolbl 1290 "Caguas, PR", add
label define pwmetrolbl 1300 "Burlington, NC", add
label define pwmetrolbl 1310 "Burlington, VT", add
label define pwmetrolbl 1320 "Canton, OH", add
label define pwmetrolbl 1350 "Casper, WY", add
label define pwmetrolbl 1360 "Cedar Rapids, IA", add
label define pwmetrolbl 1400 "Champaign-Urbana-Rantoul, IL", add
label define pwmetrolbl 1440 "Charleston-N.Charleston,SC", add
label define pwmetrolbl 1480 "Charleston, WV", add
label define pwmetrolbl 1520 "Charlotte-Gastonia-Rock Hill, SC", add
label define pwmetrolbl 1521 "Rock Hill, SC", add
label define pwmetrolbl 1540 "Charlottesville, VA", add
label define pwmetrolbl 1560 "Chattanooga, TN/GA", add
label define pwmetrolbl 1580 "Cheyenne, WY", add
label define pwmetrolbl 1600 "Chicago-Gary-Lake IL", add
label define pwmetrolbl 1601 "Aurora-Elgin, IL", add
label define pwmetrolbl 1602 "Gary-Hammond-East Chicago, IN", add
label define pwmetrolbl 1603 "Joliet, IL", add
label define pwmetrolbl 1604 "Lake County, IL", add
label define pwmetrolbl 1620 "Chico, CA", add
label define pwmetrolbl 1640 "Cincinnati, OH/KY/IN", add
label define pwmetrolbl 1660 "Clarksville- Hopkinsville, TN/KY", add
label define pwmetrolbl 1680 "Cleveland, OH", add
label define pwmetrolbl 1720 "Colorado Springs, CO", add
label define pwmetrolbl 1740 "Columbia, MO", add
label define pwmetrolbl 1760 "Columbia, SC", add
label define pwmetrolbl 1800 "Columbus, GA/AL", add
label define pwmetrolbl 1840 "Columbus, OH", add
label define pwmetrolbl 1880 "Corpus Christi, TX", add
label define pwmetrolbl 1900 "Cumberland, MD/WV", add
label define pwmetrolbl 1920 "Dallas-Fort Worth, TX", add
label define pwmetrolbl 1921 "Fort Worth-Arlington, TX", add
label define pwmetrolbl 1930 "Danbury, CT", add
label define pwmetrolbl 1950 "Danville, VA", add
label define pwmetrolbl 1960 "Davenport, IA-Rock Island-Moline, IL", add
label define pwmetrolbl 2000 "Dayton-Springfield, OH", add
label define pwmetrolbl 2001 "Springfield, OH", add
label define pwmetrolbl 2020 "Daytona Beach, FL", add
label define pwmetrolbl 2030 "Decatur, AL", add
label define pwmetrolbl 2040 "Decatur, IL", add
label define pwmetrolbl 2080 "Denver-Boulder-Longmont, CO", add
label define pwmetrolbl 2081 "Boulder-Longmont, CO", add
label define pwmetrolbl 2120 "Des Moines, IA", add
label define pwmetrolbl 2160 "Detroit, MI", add
label define pwmetrolbl 2180 "Dothan, AL", add
label define pwmetrolbl 2190 "Dover, DE", add
label define pwmetrolbl 2200 "Dubuque, IA", add
label define pwmetrolbl 2240 "Duluth-Superior, MN/WI", add
label define pwmetrolbl 2281 "Dutchess Co., NY", add
label define pwmetrolbl 2290 "Eau Claire, WI", add
label define pwmetrolbl 2310 "El Paso, TX", add
label define pwmetrolbl 2320 "Elkhart-Goshen, IN", add
label define pwmetrolbl 2330 "Elmira, NY", add
label define pwmetrolbl 2340 "Enid, OK", add
label define pwmetrolbl 2360 "Erie, PA", add
label define pwmetrolbl 2400 "Eugene-Springfield, OR", add
label define pwmetrolbl 2440 "Evansville, IN/KY", add
label define pwmetrolbl 2520 "Fargo-Moorhead, ND/MN", add
label define pwmetrolbl 2560 "Fayetteville, NC", add
label define pwmetrolbl 2580 "Fayetteville-Springdale, AR", add
label define pwmetrolbl 2600 "Fitchburg-Leominster, MA", add
label define pwmetrolbl 2620 "Flagstaff, AZ-UT", add
label define pwmetrolbl 2640 "Flint, MI", add
label define pwmetrolbl 2650 "Florence, AL", add
label define pwmetrolbl 2660 "Florence, SC", add
label define pwmetrolbl 2670 "Fort Collins-Loveland, CO", add
label define pwmetrolbl 2680 "Fort Lauderdale-Hollywood-Pompano Beach, FL", add
label define pwmetrolbl 2700 "Fort Myers-Cape Coral, FL", add
label define pwmetrolbl 2710 "Fort Pierce, FL", add
label define pwmetrolbl 2720 "Fort Smith, AR/OK", add
label define pwmetrolbl 2750 "Fort Walton Beach, FL", add
label define pwmetrolbl 2760 "Fort Wayne, IN", add
label define pwmetrolbl 2840 "Fresno, CA", add
label define pwmetrolbl 2880 "Gadsden, AL", add
label define pwmetrolbl 2900 "Gainesville, FL", add
label define pwmetrolbl 2920 "Galveston-Texas City, TX", add
label define pwmetrolbl 2970 "Glens Falls, NY", add
label define pwmetrolbl 2980 "Goldsboro, NC", add
label define pwmetrolbl 2990 "Grand Forks, ND/MN", add
label define pwmetrolbl 3000 "Grand Rapids, MI", add
label define pwmetrolbl 3040 "Great Falls, MT", add
label define pwmetrolbl 3060 "Greeley, CO", add
label define pwmetrolbl 3080 "Green Bay, WI", add
label define pwmetrolbl 3120 "Greensboro-Winston Salem-High Point, NC", add
label define pwmetrolbl 3150 "Greenville, NC", add
label define pwmetrolbl 3160 "Greenville-Spartenburg-Anderson, SC", add
label define pwmetrolbl 3161 "Anderson, SC", add
label define pwmetrolbl 3180 "Hagerstown, MD", add
label define pwmetrolbl 3200 "Hamilton-Middleton, OH", add
label define pwmetrolbl 3240 "Harrisburg-Lebanon-Carlisle, PA", add
label define pwmetrolbl 3280 "Hartford-Bristol-Middleton-New Britian, CT", add
label define pwmetrolbl 3281 "Bristol, CT", add
label define pwmetrolbl 3283 "New Britain, CT", add
label define pwmetrolbl 3285 "Hattiesburg, MS", add
label define pwmetrolbl 3290 "Hickory-Morgantown, NC", add
label define pwmetrolbl 3320 "Honolulu, HI", add
label define pwmetrolbl 3350 "Houma-Thibodoux, LA", add
label define pwmetrolbl 3360 "Houston-Brazoria, TX", add
label define pwmetrolbl 3361 "Brazoria, TX", add
label define pwmetrolbl 3400 "Huntington-Ashland,WV/KY/OH", add
label define pwmetrolbl 3440 "Huntsville, AL", add
label define pwmetrolbl 3480 "Indianapolis, IN", add
label define pwmetrolbl 3500 "Iowa City, IA", add
label define pwmetrolbl 3520 "Jackson, MI", add
label define pwmetrolbl 3560 "Jackson, MS", add
label define pwmetrolbl 3580 "Jackson, TN", add
label define pwmetrolbl 3590 "Jacksonville, FL", add
label define pwmetrolbl 3600 "Jacksonville, NC", add
label define pwmetrolbl 3610 "Jamestown-Dunkirk, NY", add
label define pwmetrolbl 3620 "Janesville-Beloit, WI", add
label define pwmetrolbl 3660 "Johnson City-Kingsport-Bristol, TN/VA", add
label define pwmetrolbl 3680 "Johnstown, PA", add
label define pwmetrolbl 3710 "Joplin, MO", add
label define pwmetrolbl 3720 "Kalamazoo-Portage, MI", add
label define pwmetrolbl 3740 "Kankakee, IL", add
label define pwmetrolbl 3760 "Kansas City, MO-KS", add
label define pwmetrolbl 3800 "Kenosha, WI", add
label define pwmetrolbl 3810 "Killeen-Temple, TX", add
label define pwmetrolbl 3840 "Knoxville, TN", add
label define pwmetrolbl 3850 "Kokomo, IN", add
label define pwmetrolbl 3870 "LaCrosse, WI", add
label define pwmetrolbl 3880 "Lafayette, LA", add
label define pwmetrolbl 3920 "Lafayette-W. Lafayette,IN", add
label define pwmetrolbl 3960 "Lake Charles, LA", add
label define pwmetrolbl 3980 "Lakeland-Winterhaven, FL", add
label define pwmetrolbl 4000 "Lancaster, PA", add
label define pwmetrolbl 4040 "Lansing-E. Lansing, MI", add
label define pwmetrolbl 4080 "Laredo, TX", add
label define pwmetrolbl 4100 "Las Cruces, NM", add
label define pwmetrolbl 4120 "Las Vegas, NV", add
label define pwmetrolbl 4150 "Lawrence, KS", add
label define pwmetrolbl 4200 "Lawton, OK", add
label define pwmetrolbl 4240 "Lewiston-Auburn, ME", add
label define pwmetrolbl 4280 "Lexington-Fayette, KY", add
label define pwmetrolbl 4320 "Lima, OH", add
label define pwmetrolbl 4360 "Lincoln, NE", add
label define pwmetrolbl 4400 "Little Rock-North Little Rock, AR", add
label define pwmetrolbl 4410 "Long Branch-Asbury Park, NJ", add
label define pwmetrolbl 4420 "Longview-Marshall, TX", add
label define pwmetrolbl 4440 "Lorain-Elyria, OH", add
label define pwmetrolbl 4480 "Los Angeles-Long Beach, CA", add
label define pwmetrolbl 4481 "Anaheim-Santa Ana-Garden Grove, CA", add
label define pwmetrolbl 4482 "Orange County, CA", add
label define pwmetrolbl 4520 "Louisville, KY/IN", add
label define pwmetrolbl 4600 "Lubbock, TX", add
label define pwmetrolbl 4640 "Lynchburg, VA", add
label define pwmetrolbl 4680 "Macon-Warner Robins, GA", add
label define pwmetrolbl 4720 "Madison, WI", add
label define pwmetrolbl 4760 "Manchester, NH", add
label define pwmetrolbl 4800 "Mansfield, OH", add
label define pwmetrolbl 4880 "McAllen-Edinburg-Pharr-Mission, TX", add
label define pwmetrolbl 4890 "Medford, OR", add
label define pwmetrolbl 4900 "Melbourne-Titusville-Cocoa-Palm Bay, FL", add
label define pwmetrolbl 4920 "Memphis, TN/AR/MS", add
label define pwmetrolbl 4940 "Merced, CA", add
label define pwmetrolbl 5000 "Miami-Hialeah, FL", add
label define pwmetrolbl 5040 "Midland, TX", add
label define pwmetrolbl 5080 "Milwaukee, WI", add
label define pwmetrolbl 5120 "Minneapolis-St. Paul, MN", add
label define pwmetrolbl 5160 "Mobile, AL", add
label define pwmetrolbl 5170 "Modesto, CA", add
label define pwmetrolbl 5190 "Monmouth-Ocean, NJ", add
label define pwmetrolbl 5200 "Monroe, LA", add
label define pwmetrolbl 5240 "Montgomery, AL", add
label define pwmetrolbl 5280 "Muncie, IN", add
label define pwmetrolbl 5320 "Muskegon-Norton Shores-Muskegon Heights, MI", add
label define pwmetrolbl 5330 "Myrtle Beach, SC", add
label define pwmetrolbl 5340 "Naples, FL", add
label define pwmetrolbl 5350 "Nashua, NH", add
label define pwmetrolbl 5360 "Nashville, TN", add
label define pwmetrolbl 5400 "New Bedford, MA", add
label define pwmetrolbl 5460 "New Brunswick-Perth Amboy-Sayreville, NJ", add
label define pwmetrolbl 5480 "New Haven-Meriden, CT", add
label define pwmetrolbl 5520 "New London-Norwich, CT/RI", add
label define pwmetrolbl 5560 "New Orleans, LA", add
label define pwmetrolbl 5600 "New York-Northeastern NJ", add
label define pwmetrolbl 5601 "Nassau-Suffolk, NY", add
label define pwmetrolbl 5602 "Bergen-Passaic, NJ", add
label define pwmetrolbl 5603 "Jersey City, NJ", add
label define pwmetrolbl 5604 "Middlesex-Somerset-Hunterdon, NJ", add
label define pwmetrolbl 5605 "Newark, NJ", add
label define pwmetrolbl 5640 "Newark, OH", add
label define pwmetrolbl 5660 "Newburgh-Middletown, NY", add
label define pwmetrolbl 5720 "Norfolk-VA Beach-Newport News, VA", add
label define pwmetrolbl 5760 "Norwalk, CT", add
label define pwmetrolbl 5790 "Ocala, FL", add
label define pwmetrolbl 5800 "Odessa, TX", add
label define pwmetrolbl 5880 "Oklahoma City, OK", add
label define pwmetrolbl 5910 "Olympia, WA", add
label define pwmetrolbl 5920 "Omaha, NE/IA", add
label define pwmetrolbl 5950 "Orange County, NY", add
label define pwmetrolbl 5960 "Orlando, FL", add
label define pwmetrolbl 5990 "Owensboro, KY", add
label define pwmetrolbl 6010 "Panama City, FL", add
label define pwmetrolbl 6020 "Parkersburg-Marietta,WV/OH", add
label define pwmetrolbl 6030 "Pascagoula-Moss Point, MS", add
label define pwmetrolbl 6080 "Pensacola, FL", add
label define pwmetrolbl 6120 "Peoria, IL", add
label define pwmetrolbl 6160 "Philadelphia, PA/NJ", add
label define pwmetrolbl 6200 "Phoenix, AZ", add
label define pwmetrolbl 6240 "Pine Bluff, AR", add
label define pwmetrolbl 6280 "Pittsburgh-Beaver Valley, PA", add
label define pwmetrolbl 6320 "Pittsfield, MA", add
label define pwmetrolbl 6360 "Ponce, PR", add
label define pwmetrolbl 6400 "Portland, ME", add
label define pwmetrolbl 6440 "Portland-Vancouver, OR", add
label define pwmetrolbl 6441 "Vancouver, WA", add
label define pwmetrolbl 6450 "Portsmouth-Dover-Rochester, NH/ME", add
label define pwmetrolbl 6460 "Poughkeepsie, NY", add
label define pwmetrolbl 6480 "Providence-Fall River-Pawtuckett, MA", add
label define pwmetrolbl 6481 "Fall River, MA/RI", add
label define pwmetrolbl 6482 "Pawtucket-Woonsocket-Attleboro, RI/MA", add
label define pwmetrolbl 6520 "Provo-Orem, UT", add
label define pwmetrolbl 6560 "Pueblo, CO", add
label define pwmetrolbl 6580 "Punta Gorda, FL", add
label define pwmetrolbl 6600 "Racine, WI", add
label define pwmetrolbl 6640 "Raleigh-Durham, NC", add
label define pwmetrolbl 6660 "Rapid City, SD", add
label define pwmetrolbl 6680 "Reading, PA", add
label define pwmetrolbl 6690 "Redding, CA", add
label define pwmetrolbl 6720 "Reno, NV", add
label define pwmetrolbl 6740 "Richland-Kennewick-Pasco, WA", add
label define pwmetrolbl 6760 "Richmond-Petersburg, VA", add
label define pwmetrolbl 6761 "Petersburg-Colonial He.", add
label define pwmetrolbl 6780 "Riverside-San Bernadino,CA", add
label define pwmetrolbl 6800 "Roanoke, VA", add
label define pwmetrolbl 6820 "Rochester, MN", add
label define pwmetrolbl 6840 "Rochester, NY", add
label define pwmetrolbl 6880 "Rockford, IL", add
label define pwmetrolbl 6895 "Rocky Mount, NC", add
label define pwmetrolbl 6920 "Sacramento, CA", add
label define pwmetrolbl 6960 "Saginaw-Bay City-Midland, MI", add
label define pwmetrolbl 6961 "Bay City, MI", add
label define pwmetrolbl 6980 "St. Cloud, MN", add
label define pwmetrolbl 7000 "St. Joseph, MO", add
label define pwmetrolbl 7040 "St. Louis, MO", add
label define pwmetrolbl 7080 "Salem, OR", add
label define pwmetrolbl 7120 "Salinas-Sea Side-Monterey, CA", add
label define pwmetrolbl 7140 "Salisbury-Concord, NC", add
label define pwmetrolbl 7160 "Salt Lake City-Ogden, UT", add
label define pwmetrolbl 7200 "San Angelo, TX", add
label define pwmetrolbl 7240 "San Antonio, TX", add
label define pwmetrolbl 7320 "San Diego, CA", add
label define pwmetrolbl 7360 "San Francisco-Oakland-Vallejo, CA", add
label define pwmetrolbl 7361 "Oakland, CA", add
label define pwmetrolbl 7362 "Vallejo-Fairfield-Napa, CA", add
label define pwmetrolbl 7400 "San Jose, CA", add
label define pwmetrolbl 7440 "San Juan, PR", add
label define pwmetrolbl 7460 "San Luis Obispo-Atascad-P Robles, CA", add
label define pwmetrolbl 7470 "Santa Barbara-Santa Maria-Lompoc, CA", add
label define pwmetrolbl 7480 "Santa Cruz, CA", add
label define pwmetrolbl 7490 "Santa Fe, NM", add
label define pwmetrolbl 7500 "Santa Rosa-Petaluma, CA", add
label define pwmetrolbl 7510 "Sarasota, FL", add
label define pwmetrolbl 7520 "Savannah, GA", add
label define pwmetrolbl 7560 "Scranton-Wilkes-Barre, PA", add
label define pwmetrolbl 7600 "Seattle-Everett, WA", add
label define pwmetrolbl 7610 "Sharon, PA", add
label define pwmetrolbl 7620 "Sheboygan, WI", add
label define pwmetrolbl 7640 "Sherman-Denison, TX", add
label define pwmetrolbl 7680 "Shreveport, LA", add
label define pwmetrolbl 7720 "Sioux City, IA/NE", add
label define pwmetrolbl 7760 "Sioux Falls, SD", add
label define pwmetrolbl 7800 "South Bend-Mishawaka, IN", add
label define pwmetrolbl 7840 "Spokane, WA", add
label define pwmetrolbl 7880 "Springfield, IL", add
label define pwmetrolbl 7920 "Springfield, MO", add
label define pwmetrolbl 8000 "Springfield-Holyoke-Chicopee, MA", add
label define pwmetrolbl 8040 "Stamford, CT", add
label define pwmetrolbl 8050 "State College, PA", add
label define pwmetrolbl 8080 "Steubenville-Weirton,OH/WV", add
label define pwmetrolbl 8120 "Stockton, CA", add
label define pwmetrolbl 8140 "Sumter, SC", add
label define pwmetrolbl 8160 "Syracuse, NY", add
label define pwmetrolbl 8200 "Tacoma, WA", add
label define pwmetrolbl 8240 "Tallahassee, FL", add
label define pwmetrolbl 8280 "Tampa-St. Petersburg-Clearwater, FL", add
label define pwmetrolbl 8320 "Terre Haute, IN", add
label define pwmetrolbl 8360 "Texarkana, TX/AR", add
label define pwmetrolbl 8400 "Toledo, OH/MI", add
label define pwmetrolbl 8440 "Topeka, KS", add
label define pwmetrolbl 8480 "Trenton, NJ", add
label define pwmetrolbl 8520 "Tucson, AZ", add
label define pwmetrolbl 8560 "Tulsa, OK", add
label define pwmetrolbl 8600 "Tuscaloosa, AL", add
label define pwmetrolbl 8640 "Tyler, TX", add
label define pwmetrolbl 8680 "Utica-Rome, NY", add
label define pwmetrolbl 8730 "Ventura-Oxnard-Simi Valley", add
label define pwmetrolbl 8750 "Victoria, TX", add
label define pwmetrolbl 8760 "Vineland-Milville-Bridgetown, NJ", add
label define pwmetrolbl 8780 "Visalia-Tulare -Porterville, CA", add
label define pwmetrolbl 8800 "Waco, TX", add
label define pwmetrolbl 8840 "Washington, DC/MD/VA", add
label define pwmetrolbl 8880 "Waterbury, CT", add
label define pwmetrolbl 8920 "Waterloo-Cedar Falls, IA", add
label define pwmetrolbl 8940 "Wausau, WI", add
label define pwmetrolbl 8960 "West Palm Beach-Boca Raton-Delray Beach, FL", add
label define pwmetrolbl 9000 "Wheeling, WV/OH", add
label define pwmetrolbl 9040 "Wichita, KS", add
label define pwmetrolbl 9080 "Wichita Falls, TX", add
label define pwmetrolbl 9140 "Williamsport, PA", add
label define pwmetrolbl 9160 "Wilmington, DE/NJ/MD", add
label define pwmetrolbl 9200 "Wilmington, NC", add
label define pwmetrolbl 9240 "Worcester, MA", add
label define pwmetrolbl 9260 "Yakima, WA", add
label define pwmetrolbl 9270 "Yolo, CA", add
label define pwmetrolbl 9280 "York, PA", add
label define pwmetrolbl 9320 "Youngstown-Warren, OH-PA", add
label define pwmetrolbl 9340 "Yuba City, CA", add
label define pwmetrolbl 9360 "Yuma, AZ", add
label values pwmetro pwmetrolbl

save "C:\Documents and Settings\Krishna Patel\My Documents\thesis_topic occdist\immigrants\census90_all_bpld.dta", replace



drop occ1990 pwmetro
save "C:\Documents and Settings\Krishna Patel\My Documents\thesis_topic occdist\native and immigrants\census90_3a.dta", replace

