* This program generates a new variable called "iso_num" and displays is as ISO standard country names.

/*
generate iso_num = .

replace iso_num = 4 if iso3 == "AFG"
replace iso_num = 8 if iso3 == "ALB"
replace iso_num = 10 if iso3 == "ATA"
replace iso_num = 12 if iso3 == "DZA"
replace iso_num = 16 if iso3 == "ASM"
replace iso_num = 20 if iso3 == "AND"
replace iso_num = 24 if iso3 == "AGO"
replace iso_num = 28 if iso3 == "ATG"
replace iso_num = 31 if iso3 == "AZE"
replace iso_num = 32 if iso3 == "ARG"
replace iso_num = 36 if iso3 == "AUS"
replace iso_num = 40 if iso3 == "AUT"
replace iso_num = 44 if iso3 == "BHS"
replace iso_num = 48 if iso3 == "BHR"
replace iso_num = 50 if iso3 == "BGD"
replace iso_num = 51 if iso3 == "ARM"
replace iso_num = 52 if iso3 == "BRB"
replace iso_num = 56 if iso3 == "BEL"
replace iso_num = 60 if iso3 == "BMU"
replace iso_num = 64 if iso3 == "BTN"
replace iso_num = 68 if iso3 == "BOL"
replace iso_num = 70 if iso3 == "BIH"
replace iso_num = 72 if iso3 == "BWA"
replace iso_num = 74 if iso3 == "BVT"
replace iso_num = 76 if iso3 == "BRA"
replace iso_num = 84 if iso3 == "BLZ"
replace iso_num = 86 if iso3 == "IOT"
replace iso_num = 90 if iso3 == "SLB"
replace iso_num = 92 if iso3 == "VGB"
replace iso_num = 96 if iso3 == "BRN"
replace iso_num = 100 if iso3 == "BGR"
replace iso_num = 104 if iso3 == "MMR"
replace iso_num = 108 if iso3 == "BDI"
replace iso_num = 112 if iso3 == "BLR"
replace iso_num = 116 if iso3 == "KHM"
replace iso_num = 120 if iso3 == "CMR"
replace iso_num = 124 if iso3 == "CAN"
replace iso_num = 132 if iso3 == "CPV"
replace iso_num = 136 if iso3 == "CYM"
replace iso_num = 140 if iso3 == "CAF"
replace iso_num = 144 if iso3 == "LKA"
replace iso_num = 148 if iso3 == "TCD"
replace iso_num = 152 if iso3 == "CHL"
replace iso_num = 156 if iso3 == "CHN"
replace iso_num = 158 if iso3 == "TWN"
replace iso_num = 162 if iso3 == "CXR"
replace iso_num = 166 if iso3 == "CCK"
replace iso_num = 170 if iso3 == "COL"
replace iso_num = 174 if iso3 == "COM"
replace iso_num = 175 if iso3 == "MYT"
replace iso_num = 178 if iso3 == "COG"
replace iso_num = 180 if iso3 == "COD"
replace iso_num = 184 if iso3 == "COK"
replace iso_num = 188 if iso3 == "CRI"
replace iso_num = 191 if iso3 == "HRV"
replace iso_num = 192 if iso3 == "CUB"
replace iso_num = 196 if iso3 == "CYP"
replace iso_num = 203 if iso3 == "CZE"
replace iso_num = 204 if iso3 == "BEN"
replace iso_num = 208 if iso3 == "DNK"
replace iso_num = 212 if iso3 == "DMA"
replace iso_num = 214 if iso3 == "DOM"
replace iso_num = 218 if iso3 == "ECU"
replace iso_num = 222 if iso3 == "SLV"
replace iso_num = 226 if iso3 == "GNQ"
replace iso_num = 231 if iso3 == "ETH"
replace iso_num = 232 if iso3 == "ERI"
replace iso_num = 233 if iso3 == "EST"
replace iso_num = 234 if iso3 == "FRO"
replace iso_num = 238 if iso3 == "FLK"
replace iso_num = 239 if iso3 == "SGS"
replace iso_num = 242 if iso3 == "FJI"
replace iso_num = 246 if iso3 == "FIN"
replace iso_num = 248 if iso3 == "ALA"
replace iso_num = 250 if iso3 == "FRA"
replace iso_num = 254 if iso3 == "GUF"
replace iso_num = 258 if iso3 == "PYF"
replace iso_num = 260 if iso3 == "ATF"
replace iso_num = 262 if iso3 == "DJI"
replace iso_num = 266 if iso3 == "GAB"
replace iso_num = 268 if iso3 == "GEO"
replace iso_num = 270 if iso3 == "GMB"
replace iso_num = 275 if iso3 == "PSE"
replace iso_num = 276 if iso3 == "DEU"
replace iso_num = 288 if iso3 == "GHA"
replace iso_num = 292 if iso3 == "GIB"
replace iso_num = 296 if iso3 == "KIR"
replace iso_num = 300 if iso3 == "GRC"
replace iso_num = 304 if iso3 == "GRL"
replace iso_num = 308 if iso3 == "GRD"
replace iso_num = 312 if iso3 == "GLP"
replace iso_num = 316 if iso3 == "GUM"
replace iso_num = 320 if iso3 == "GTM"
replace iso_num = 324 if iso3 == "GIN"
replace iso_num = 328 if iso3 == "GUY"
replace iso_num = 332 if iso3 == "HTI"
replace iso_num = 334 if iso3 == "HMD"
replace iso_num = 336 if iso3 == "VAT"
replace iso_num = 340 if iso3 == "HND"
replace iso_num = 344 if iso3 == "HKG"
replace iso_num = 348 if iso3 == "HUN"
replace iso_num = 352 if iso3 == "ISL"
replace iso_num = 356 if iso3 == "IND"
replace iso_num = 360 if iso3 == "IDN"
replace iso_num = 364 if iso3 == "IRN"
replace iso_num = 368 if iso3 == "IRQ"
replace iso_num = 372 if iso3 == "IRL"
replace iso_num = 376 if iso3 == "ISR"
replace iso_num = 380 if iso3 == "ITA"
replace iso_num = 384 if iso3 == "CIV"
replace iso_num = 388 if iso3 == "JAM"
replace iso_num = 392 if iso3 == "JPN"
replace iso_num = 398 if iso3 == "KAZ"
replace iso_num = 400 if iso3 == "JOR"
replace iso_num = 404 if iso3 == "KEN"
replace iso_num = 408 if iso3 == "PRK"
replace iso_num = 410 if iso3 == "KOR"
replace iso_num = 414 if iso3 == "KWT"
replace iso_num = 417 if iso3 == "KGZ"
replace iso_num = 418 if iso3 == "LAO"
replace iso_num = 422 if iso3 == "LBN"
replace iso_num = 426 if iso3 == "LSO"
replace iso_num = 428 if iso3 == "LVA"
replace iso_num = 430 if iso3 == "LBR"
replace iso_num = 434 if iso3 == "LBY"
replace iso_num = 438 if iso3 == "LIE"
replace iso_num = 440 if iso3 == "LTU"
replace iso_num = 442 if iso3 == "LUX"
replace iso_num = 446 if iso3 == "MAC"
replace iso_num = 450 if iso3 == "MDG"
replace iso_num = 454 if iso3 == "MWI"
replace iso_num = 458 if iso3 == "MYS"
replace iso_num = 462 if iso3 == "MDV"
replace iso_num = 466 if iso3 == "MLI"
replace iso_num = 470 if iso3 == "MLT"
replace iso_num = 474 if iso3 == "MTQ"
replace iso_num = 478 if iso3 == "MRT"
replace iso_num = 480 if iso3 == "MUS"
replace iso_num = 484 if iso3 == "MEX"
replace iso_num = 492 if iso3 == "MCO"
replace iso_num = 496 if iso3 == "MNG"
replace iso_num = 498 if iso3 == "MDA"
replace iso_num = 499 if iso3 == "MNE"
replace iso_num = 500 if iso3 == "MSR"
replace iso_num = 504 if iso3 == "MAR"
replace iso_num = 508 if iso3 == "MOZ"
replace iso_num = 512 if iso3 == "OMN"
replace iso_num = 516 if iso3 == "NAM"
replace iso_num = 520 if iso3 == "NRU"
replace iso_num = 524 if iso3 == "NPL"
replace iso_num = 528 if iso3 == "NLD"
replace iso_num = 530 if iso3 == "ANT"
replace iso_num = 533 if iso3 == "ABW"
replace iso_num = 540 if iso3 == "NCL"
replace iso_num = 548 if iso3 == "VUT"
replace iso_num = 554 if iso3 == "NZL"
replace iso_num = 558 if iso3 == "NIC"
replace iso_num = 562 if iso3 == "NER"
replace iso_num = 566 if iso3 == "NGA"
replace iso_num = 570 if iso3 == "NIU"
replace iso_num = 574 if iso3 == "NFK"
replace iso_num = 578 if iso3 == "NOR"
replace iso_num = 580 if iso3 == "MNP"
replace iso_num = 581 if iso3 == "UMI"
replace iso_num = 583 if iso3 == "FSM"
replace iso_num = 584 if iso3 == "MHL"
replace iso_num = 585 if iso3 == "PLW"
replace iso_num = 586 if iso3 == "PAK"
replace iso_num = 591 if iso3 == "PAN"
replace iso_num = 598 if iso3 == "PNG"
replace iso_num = 600 if iso3 == "PRY"
replace iso_num = 604 if iso3 == "PER"
replace iso_num = 608 if iso3 == "PHL"
replace iso_num = 612 if iso3 == "PCN"
replace iso_num = 616 if iso3 == "POL"
replace iso_num = 620 if iso3 == "PRT"
replace iso_num = 624 if iso3 == "GNB"
replace iso_num = 626 if iso3 == "TLS"
replace iso_num = 630 if iso3 == "PRI"
replace iso_num = 634 if iso3 == "QAT"
replace iso_num = 638 if iso3 == "REU"
replace iso_num = 642 if iso3 == "ROU"
replace iso_num = 643 if iso3 == "RUS"
replace iso_num = 646 if iso3 == "RWA"
replace iso_num = 652 if iso3 == "BLM"
replace iso_num = 654 if iso3 == "SHN"
replace iso_num = 659 if iso3 == "KNA"
replace iso_num = 660 if iso3 == "AIA"
replace iso_num = 662 if iso3 == "LCA"
replace iso_num = 663 if iso3 == "MAF"
replace iso_num = 666 if iso3 == "SPM"
replace iso_num = 670 if iso3 == "VCT"
replace iso_num = 674 if iso3 == "SMR"
replace iso_num = 678 if iso3 == "STP"
replace iso_num = 682 if iso3 == "SAU"
replace iso_num = 686 if iso3 == "SEN"
replace iso_num = 688 if iso3 == "SRB"
replace iso_num = 690 if iso3 == "SYC"
replace iso_num = 694 if iso3 == "SLE"
replace iso_num = 702 if iso3 == "SGP"
replace iso_num = 703 if iso3 == "SVK"
replace iso_num = 704 if iso3 == "VNM"
replace iso_num = 705 if iso3 == "SVN"
replace iso_num = 706 if iso3 == "SOM"
replace iso_num = 710 if iso3 == "ZAF"
replace iso_num = 716 if iso3 == "ZWE"
replace iso_num = 724 if iso3 == "ESP"
replace iso_num = 732 if iso3 == "ESH"
replace iso_num = 736 if iso3 == "SDN"
replace iso_num = 740 if iso3 == "SUR"
replace iso_num = 744 if iso3 == "SJM"
replace iso_num = 748 if iso3 == "SWZ"
replace iso_num = 752 if iso3 == "SWE"
replace iso_num = 756 if iso3 == "CHE"
replace iso_num = 760 if iso3 == "SYR"
replace iso_num = 762 if iso3 == "TJK"
replace iso_num = 764 if iso3 == "THA"
replace iso_num = 768 if iso3 == "TGO"
replace iso_num = 772 if iso3 == "TKL"
replace iso_num = 776 if iso3 == "TON"
replace iso_num = 780 if iso3 == "TTO"
replace iso_num = 784 if iso3 == "ARE"
replace iso_num = 788 if iso3 == "TUN"
replace iso_num = 792 if iso3 == "TUR"
replace iso_num = 795 if iso3 == "TKM"
replace iso_num = 796 if iso3 == "TCA"
replace iso_num = 798 if iso3 == "TUV"
replace iso_num = 800 if iso3 == "UGA"
replace iso_num = 804 if iso3 == "UKR"
replace iso_num = 807 if iso3 == "MKD"
replace iso_num = 818 if iso3 == "EGY"
replace iso_num = 826 if iso3 == "GBR"
replace iso_num = 831 if iso3 == "GGY"
replace iso_num = 832 if iso3 == "JEY"
replace iso_num = 833 if iso3 == "IMN"
replace iso_num = 834 if iso3 == "TZA"
replace iso_num = 840 if iso3 == "USA"
replace iso_num = 850 if iso3 == "VIR"
replace iso_num = 854 if iso3 == "BFA"
replace iso_num = 858 if iso3 == "URY"
replace iso_num = 860 if iso3 == "UZB"
replace iso_num = 862 if iso3 == "VEN"
replace iso_num = 876 if iso3 == "WLF"
replace iso_num = 882 if iso3 == "WSM"
replace iso_num = 887 if iso3 == "YEM"
replace iso_num = 894 if iso3 == "ZMB"
*/

label define iso_num 4 "Afghanistan" ///
     8 "Albania" ///
     10 "Antarctica" ///
     12 "Algeria" ///
     16 "American Samoa" ///
     20 "Andorra" ///
     24 "Angola" ///
     28 "Antigua and Barbuda" ///
     31 "Azerbaijan" ///
     32 "Argentina" ///
     36 "Australia" ///
     40 "Austria" ///
     44 "Bahamas" ///
     48 "Bahrain" ///
     50 "Bangladesh" ///
     51 "Armenia" ///
     52 "Barbados" ///
     56 "Belgium" ///
     60 "Bermuda" ///
     64 "Bhutan" ///
     68 "Bolivia, Plurinational State of" ///
     70 "Bosnia and Herzegovina" ///
     72 "Botswana" ///
     74 "Bouvet Island" ///
     76 "Brazil" ///
     84 "Belize" ///
     86 "British Indian Ocean Territory" ///
     90 "Solomon Islands" ///
     92 "Virgin Islands, British" ///
     96 "Brunei Darussalam" ///
     100 "Bulgaria" ///
     104 "Myanmar" ///
     108 "Burundi" ///
     112 "Belarus" ///
     116 "Cambodia" ///
     120 "Cameroon" ///
     124 "Canada" ///
     132 "Cape Verde" ///
     136 "Cayman Islands" ///
     140 "Central African Republic" ///
     144 "Sri Lanka" ///
     148 "Chad" ///
     152 "Chile" ///
     156 "China" ///
     158 "Taiwan, Province of China" ///
     162 "Christmas Island" ///
     166 "Cocos (Keeling) Islands" ///
     170 "Colombia" ///
     174 "Comoros" ///
     175 "Mayotte" ///
     178 "Congo" ///
     180 "Congo, the Democratic Republic of the" ///
     184 "Cook Islands" ///
     188 "Costa Rica" ///
     191 "Croatia" ///
     192 "Cuba" ///
     196 "Cyprus" ///
     203 "Czech Republic" ///
     204 "Benin" ///
     208 "Denmark" ///
     212 "Dominica" ///
     214 "Dominican Republic" ///
     218 "Ecuador" ///
     222 "El Salvador" ///
     226 "Equatorial Guinea" ///
     231 "Ethiopia" ///
     232 "Eritrea" ///
     233 "Estonia" ///
     234 "Faroe Islands" ///
     238 "Falkland Islands (Malvinas)" ///
     239 "South Georgia and the South Sandwich Islands" ///
     242 "Fiji" ///
     246 "Finland" ///
     248 "Åland Islands" ///
     250 "France" ///
     254 "French Guiana" ///
     258 "French Polynesia" ///
     260 "French Southern Territories" ///
     262 "Djibouti" ///
     266 "Gabon" ///
     268 "Georgia" ///
     270 "Gambia" ///
     275 "Palestinian Territory, Occupied" ///
     276 "Germany" ///
     288 "Ghana" ///
     292 "Gibraltar" ///
     296 "Kiribati" ///
     300 "Greece" ///
     304 "Greenland" ///
     308 "Grenada" ///
     312 "Guadeloupe" ///
     316 "Guam" ///
     320 "Guatemala" ///
     324 "Guinea" ///
     328 "Guyana" ///
     332 "Haiti" ///
     334 "Heard Island and McDonald Islands" ///
     336 "Holy See (Vatican City State)" ///
     340 "Honduras" ///
     344 "Hong Kong" ///
     348 "Hungary" ///
     352 "Iceland" ///
     356 "India" ///
     360 "Indonesia" ///
     364 "Iran, Islamic Republic of" ///
     368 "Iraq" ///
     372 "Ireland" ///
     376 "Israel" ///
     380 "Italy" ///
     384 "Côte d'Ivoire" ///
     388 "Jamaica" ///
     392 "Japan" ///
     398 "Kazakhstan" ///
     400 "Jordan" ///
     404 "Kenya" ///
     408 "Korea, Democratic People's Republic of" ///
     410 "Korea, Republic of" ///
     414 "Kuwait" ///
     417 "Kyrgyzstan" ///
     418 "Lao People's Democratic Republic" ///
     422 "Lebanon" ///
     426 "Lesotho" ///
     428 "Latvia" ///
     430 "Liberia" ///
     434 "Libyan Arab Jamahiriya" ///
     438 "Liechtenstein" ///
     440 "Lithuania" ///
     442 "Luxembourg" ///
     446 "Macao" ///
     450 "Madagascar" ///
     454 "Malawi" ///
     458 "Malaysia" ///
     462 "Maldives" ///
     466 "Mali" ///
     470 "Malta" ///
     474 "Martinique" ///
     478 "Mauritania" ///
     480 "Mauritius" ///
     484 "Mexico" ///
     492 "Monaco" ///
     496 "Mongolia" ///
     498 "Moldova, Republic of" ///
     499 "Montenegro" ///
     500 "Montserrat" ///
     504 "Morocco" ///
     508 "Mozambique" ///
     512 "Oman" ///
     516 "Namibia" ///
     520 "Nauru" ///
     524 "Nepal" ///
     528 "Netherlands" ///
     530 "Netherlands Antilles" ///
     531 "Curacao" ///
     533 "Aruba" ///
     534 "Sint Maarten (Dutch Port)" ///
     540 "New Caledonia" ///
     548 "Vanuatu" ///
     554 "New Zealand" ///
     558 "Nicaragua" ///
     562 "Niger" ///
     566 "Nigeria" ///
     570 "Niue" ///
     574 "Norfolk Island" ///
     578 "Norway" ///
     580 "Northern Mariana Islands" ///
     581 "United States Minor Outlying Islands" ///
     583 "Micronesia, Federated States of" ///
     584 "Marshall Islands" ///
     585 "Palau" ///
     586 "Pakistan" ///
     591 "Panama" ///
     598 "Papua New Guinea" ///
     600 "Paraguay" ///
     604 "Peru" ///
     608 "Philippines" ///
     612 "Pitcairn" ///
     616 "Poland" ///
     620 "Portugal" ///
     624 "Guinea-Bissau" ///
     626 "Timor-Leste" ///
     630 "Puerto Rico" ///
     634 "Qatar" ///
     638 "Réunion" ///
     642 "Romania" ///
     643 "Russian Federation" ///
     646 "Rwanda" ///
     652 "Saint Barthélemy" ///
     654 "Saint Helena" ///
     659 "Saint Kitts and Nevis" ///
     660 "Anguilla" ///
     662 "Saint Lucia" ///
     663 "Saint Martin (French part)" ///
     666 "Saint Pierre and Miquelon" ///
     670 "Saint Vincent and the Grenadines" ///
     674 "San Marino" ///
     678 "Sao Tome and Principe" ///
     682 "Saudi Arabia" ///
     686 "Senegal" ///
     688 "Serbia" ///
     690 "Seychelles" ///
     694 "Sierra Leone" ///
     702 "Singapore" ///
     703 "Slovakia" ///
     704 "Viet Nam" ///
     705 "Slovenia" ///
     706 "Somalia" ///
     710 "South Africa" ///
     716 "Zimbabwe" ///
     724 "Spain" ///
     728 "Republic of South Sudan" ///
     732 "Western Sahara" ///
     736 "Sudan" ///
     740 "Suriname" ///
     744 "Svalbard and Jan Mayen" ///
     748 "Swaziland" ///
     752 "Sweden" ///
     756 "Switzerland" ///
     760 "Syrian Arab Republic" ///
     762 "Tajikistan" ///
     764 "Thailand" ///
     768 "Togo" ///
     772 "Tokelau" ///
     776 "Tonga" ///
     780 "Trinidad and Tobago" ///
     784 "United Arab Emirates" ///
     788 "Tunisia" ///
     792 "Turkey" ///
     795 "Turkmenistan" ///
     796 "Turks and Caicos Islands" ///
     798 "Tuvalu" ///
     800 "Uganda" ///
     804 "Ukraine" ///
     807 "Macedonia, the former Yugoslav Republic of" ///
     818 "Egypt" ///
     826 "United Kingdom" ///
     831 "Guernsey" ///
     832 "Jersey" ///
     833 "Isle of Man" ///
     834 "Tanzania" ///
     840 "United States" ///
     850 "Virgin Islands, U.S." ///
     854 "Burkina Faso" ///
     858 "Uruguay" ///
     860 "Uzbekistan" ///
     862 "Venezuela, Bolivarian Republic of" ///
     876 "Wallis and Futuna" ///
     882 "Samoa" ///
     887 "Yemen" ///
     894 "Zambia", modify
label values iso_num iso_num
