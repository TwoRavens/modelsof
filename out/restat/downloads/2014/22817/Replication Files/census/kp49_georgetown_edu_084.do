clear
set memory 500m


/* Important: you need to put the .dat and .do files in one folder/
   directory and then set the working folder to that folder. */

set more off

clear
infix ///
 byte    datanum       1-2 ///
 double  serial        3-10 ///
 byte    nfams        11-12 ///
 byte    pernum       13-14 ///
 byte    nchild       15 ///
 byte    marst        16 ///
 long    bpl          17-19 ///
 int     languagd     20-23 ///
 using "C:\Documents and Settings\Krishna Patel\My Documents\thesis_topic occdist\census\kp49_georgetown_edu_084.dat"
drop if bpl>=1 & bpl<=99

label var datanum "Data set number"
label var serial "Household serial number"
label var nfams "Number of families in household"
label var pernum "Person number in sample unit"
label var nchild "Number of own children in the household"
label var marst "Marital status"
label var bpl "Birthplace [general version]"
label var languagd "Language spoken [detailed version]"

label values datanum datanumlbl

label values serial seriallbl

label define nfamslbl 01 "1 family or N/A"
label define nfamslbl 02 "2 families", add
label define nfamslbl 03 "3", add
label define nfamslbl 04 "4", add
label define nfamslbl 05 "5", add
label define nfamslbl 06 "6", add
label define nfamslbl 07 "7", add
label define nfamslbl 08 "8", add
label define nfamslbl 09 "9", add
label define nfamslbl 10 "10", add
label define nfamslbl 11 "11", add
label define nfamslbl 12 "12", add
label define nfamslbl 13 "13", add
label define nfamslbl 14 "14", add
label define nfamslbl 15 "15", add
label define nfamslbl 16 "16", add
label define nfamslbl 17 "17", add
label define nfamslbl 18 "18", add
label define nfamslbl 19 "19", add
label define nfamslbl 20 "20", add
label define nfamslbl 21 "21", add
label define nfamslbl 22 "22", add
label define nfamslbl 23 "23", add
label define nfamslbl 24 "24", add
label define nfamslbl 25 "25", add
label define nfamslbl 26 "26", add
label define nfamslbl 27 "27", add
label define nfamslbl 28 "28", add
label define nfamslbl 29 "29", add
label values nfams nfamslbl

label values pernum pernumlbl

label define nchildlbl 0 "0 children present"
label define nchildlbl 1 "1 child present", add
label define nchildlbl 2 "2", add
label define nchildlbl 3 "3", add
label define nchildlbl 4 "4", add
label define nchildlbl 5 "5", add
label define nchildlbl 6 "6", add
label define nchildlbl 7 "7", add
label define nchildlbl 8 "8", add
label define nchildlbl 9 "9+", add
label values nchild nchildlbl

label define marstlbl 1 "Married, spouse present"
label define marstlbl 2 "Married, spouse absent", add
label define marstlbl 3 "Separated", add
label define marstlbl 4 "Divorced", add
label define marstlbl 5 "Widowed", add
label define marstlbl 6 "Never married/single", add
label values marst marstlbl

label define bpllbl 001 "Alabama", add
label define bpllbl 002 "Alaska", add
label define bpllbl 004 "Arizona", add
label define bpllbl 005 "Arkansas", add
label define bpllbl 006 "California", add
label define bpllbl 008 "Colorado", add
label define bpllbl 009 "Connecticut", add
label define bpllbl 010 "Delaware", add
label define bpllbl 011 "District of Columbia", add
label define bpllbl 012 "Florida", add
label define bpllbl 013 "Georgia", add
label define bpllbl 015 "Hawaii", add
label define bpllbl 016 "Idaho", add
label define bpllbl 017 "Illinois", add
label define bpllbl 018 "Indiana", add
label define bpllbl 019 "Iowa", add
label define bpllbl 020 "Kansas", add
label define bpllbl 021 "Kentucky", add
label define bpllbl 022 "Louisiana", add
label define bpllbl 023 "Maine", add
label define bpllbl 024 "Maryland", add
label define bpllbl 025 "Massachusetts", add
label define bpllbl 026 "Michigan", add
label define bpllbl 027 "Minnesota", add
label define bpllbl 028 "Mississippi", add
label define bpllbl 029 "Missouri", add
label define bpllbl 030 "Montana", add
label define bpllbl 031 "Nebraska", add
label define bpllbl 032 "Nevada", add
label define bpllbl 033 "New Hampshire", add
label define bpllbl 034 "New Jersey", add
label define bpllbl 035 "New Mexico", add
label define bpllbl 036 "New York", add
label define bpllbl 037 "North Carolina", add
label define bpllbl 038 "North Dakota", add
label define bpllbl 039 "Ohio", add
label define bpllbl 040 "Oklahoma", add
label define bpllbl 041 "Oregon", add
label define bpllbl 042 "Pennsylvania", add
label define bpllbl 044 "Rhode Island", add
label define bpllbl 045 "South Carolina", add
label define bpllbl 046 "South Dakota", add
label define bpllbl 047 "Tennessee", add
label define bpllbl 048 "Texas", add
label define bpllbl 049 "Utah", add
label define bpllbl 050 "Vermont", add
label define bpllbl 051 "Virginia", add
label define bpllbl 053 "Washington", add
label define bpllbl 054 "West Virginia", add
label define bpllbl 055 "Wisconsin", add
label define bpllbl 056 "Wyoming", add
label define bpllbl 090 "Native American", add
label define bpllbl 099 "United States, ns", add
label define bpllbl 100 "American Samoa", add
label define bpllbl 105 "Guam", add
label define bpllbl 110 "Puerto Rico", add
label define bpllbl 115 "U.S. Virgin Islands", add
label define bpllbl 120 "Other US Possessions", add
label define bpllbl 150 "Canada", add
label define bpllbl 155 "St. Pierre and Miquelon", add
label define bpllbl 160 "Atlantic Islands", add
label define bpllbl 199 "North America, ns", add
label define bpllbl 200 "Mexico", add
label define bpllbl 210 "Central America", add
label define bpllbl 250 "Cuba", add
label define bpllbl 260 "West Indies", add
label define bpllbl 300 "SOUTH AMERICA", add
label define bpllbl 400 "Denmark", add
label define bpllbl 401 "Finland", add
label define bpllbl 402 "Iceland", add
label define bpllbl 403 "Lapland, n.s.", add
label define bpllbl 404 "Norway", add
label define bpllbl 405 "Sweden", add
label define bpllbl 410 "England", add
label define bpllbl 411 "Scotland", add
label define bpllbl 412 "Wales", add
label define bpllbl 413 "United Kingdom, ns", add
label define bpllbl 414 "Ireland", add
label define bpllbl 419 "Northern Europe, ns", add
label define bpllbl 420 "Belgium", add
label define bpllbl 421 "France", add
label define bpllbl 422 "Liechtenstein", add
label define bpllbl 423 "Luxembourg", add
label define bpllbl 424 "Monaco", add
label define bpllbl 425 "Netherlands", add
label define bpllbl 426 "Switerland", add
label define bpllbl 429 "Western Europe, ns", add
label define bpllbl 430 "Albania", add
label define bpllbl 431 "Andorra", add
label define bpllbl 432 "Gibraltar", add
label define bpllbl 433 "Greece", add
label define bpllbl 434 "Italy", add
label define bpllbl 435 "Malta", add
label define bpllbl 436 "Portugal", add
label define bpllbl 437 "San Marino", add
label define bpllbl 438 "Spain", add
label define bpllbl 439 "Vatican City", add
label define bpllbl 440 "Southern Europe, ns", add
label define bpllbl 450 "Austria", add
label define bpllbl 451 "Bulgaria", add
label define bpllbl 452 "Czechoslovakia", add
label define bpllbl 453 "Germany", add
label define bpllbl 454 "Hungary", add
label define bpllbl 455 "Poland", add
label define bpllbl 456 "Romania", add
label define bpllbl 457 "Yugoslavia", add
label define bpllbl 458 "Central Europe, ns", add
label define bpllbl 459 "Eastern Europe, ns", add
label define bpllbl 460 "Estonia", add
label define bpllbl 461 "Latvia", add
label define bpllbl 462 "Lithuania", add
label define bpllbl 463 "Baltic States, ns", add
label define bpllbl 465 "Other USSR/Russia", add
label define bpllbl 499 "Europe, ns", add
label define bpllbl 500 "China", add
label define bpllbl 501 "Japan", add
label define bpllbl 502 "Korea", add
label define bpllbl 509 "East Asia, ns", add
label define bpllbl 510 "Brunei", add
label define bpllbl 511 "Cambodia (Kampuchea)", add
label define bpllbl 512 "Indonesia", add
label define bpllbl 513 "Laos", add
label define bpllbl 514 "Malaysia", add
label define bpllbl 515 "Philippines", add
label define bpllbl 516 "Singapore", add
label define bpllbl 517 "Thailand", add
label define bpllbl 518 "Vietnam", add
label define bpllbl 519 "Southeast Asia, ns", add
label define bpllbl 520 "Afghanistan", add
label define bpllbl 521 "India", add
label define bpllbl 522 "Iran", add
label define bpllbl 523 "Maldives", add
label define bpllbl 524 "Nepal", add
label define bpllbl 530 "Bahrain", add
label define bpllbl 531 "Cyprus", add
label define bpllbl 532 "Iraq", add
label define bpllbl 533 "Iraq/Saudi Arabia", add
label define bpllbl 534 "Israel/Palestine", add
label define bpllbl 535 "Jordan", add
label define bpllbl 536 "Kuwait", add
label define bpllbl 537 "Lebanon", add
label define bpllbl 538 "Oman", add
label define bpllbl 539 "Qatar", add
label define bpllbl 540 "Saudi Arabia", add
label define bpllbl 541 "Syria", add
label define bpllbl 542 "Turkey", add
label define bpllbl 543 "United Arab Emirates", add
label define bpllbl 544 "Yemen Arab Republic (North)", add
label define bpllbl 545 "Yemen, PDR (South)", add
label define bpllbl 546 "Persian Gulf States, n.s.", add
label define bpllbl 547 "Middle East, ns", add
label define bpllbl 548 "Southwest Asia, nec/ns", add
label define bpllbl 549 "Asia Minor, ns", add
label define bpllbl 550 "South Asia, nec", add
label define bpllbl 599 "Asia, nec/ns", add
label define bpllbl 600 "AFRICA", add
label define bpllbl 700 "Australia and New Zealand", add
label define bpllbl 710 "Pacific Islands", add
label define bpllbl 800 "Antarctica, ns/nec", add
label define bpllbl 900 "Abroad (unknown) or at sea", add
label define bpllbl 950 "Other, nec", add
label values bpl bpllbl

label define languagdlbl 0000 "N/A or blank", add
label define languagdlbl 0100 "English", add
label define languagdlbl 0110 "Jamaican Creole", add
label define languagdlbl 0120 "Krio, Pidgin Krio", add
label define languagdlbl 0130 "Hawaiian Pidgin", add
label define languagdlbl 0140 "Pidgin", add
label define languagdlbl 0150 "Gullah, Geechee", add
label define languagdlbl 0160 "Saramacca", add
label define languagdlbl 0200 "German", add
label define languagdlbl 0210 "Austrian", add
label define languagdlbl 0220 "Swiss", add
label define languagdlbl 0230 "Luxembourgian", add
label define languagdlbl 0240 "Pennsylvania Dutch", add
label define languagdlbl 0300 "Yiddish, Jewish", add
label define languagdlbl 0400 "Dutch", add
label define languagdlbl 0410 "Dutch, Flemish, Belgian", add
label define languagdlbl 0420 "Afrikaans", add
label define languagdlbl 0430 "Frisian", add
label define languagdlbl 0460 "Belgian", add
label define languagdlbl 0470 "Flemish", add
label define languagdlbl 0500 "Swedish", add
label define languagdlbl 0600 "Danish", add
label define languagdlbl 0700 "Norwegian", add
label define languagdlbl 0800 "Icelandic", add
label define languagdlbl 0810 "Faroese", add
label define languagdlbl 1000 "Italian", add
label define languagdlbl 1010 "Rhaeto-Romanic, Ladin", add
label define languagdlbl 1100 "French", add
label define languagdlbl 1110 "French, Walloon", add
label define languagdlbl 1120 "Provencal", add
label define languagdlbl 1130 "Patois", add
label define languagdlbl 1140 "French or Haitian Creole", add
label define languagdlbl 1150 "Cajun", add
label define languagdlbl 1200 "Spanish", add
label define languagdlbl 1210 "Catalonian, Valencian", add
label define languagdlbl 1220 "Ladino, Sefaradit, Spanol", add
label define languagdlbl 1230 "Pachuco", add
label define languagdlbl 1240 "Papia Mentae", add
label define languagdlbl 1250 "Mexican", add
label define languagdlbl 1300 "Portuguese", add
label define languagdlbl 1400 "Rumanian", add
label define languagdlbl 1500 "Celtic", add
label define languagdlbl 1520 "Welsh", add
label define languagdlbl 1530 "Breton", add
label define languagdlbl 1540 "Irish Gaelic, Gaelic", add
label define languagdlbl 1550 "Gaelic", add
label define languagdlbl 1560 "Irish", add
label define languagdlbl 1570 "Scottish Gaelic", add
label define languagdlbl 1600 "Greek", add
label define languagdlbl 1700 "Albanian", add
label define languagdlbl 1800 "Russian", add
label define languagdlbl 1810 "Russian, Great Russian", add
label define languagdlbl 1820 "Bielo-, White Russian", add
label define languagdlbl 1900 "Ukrainian, Ruthenian, Little Russian", add
label define languagdlbl 1910 "Ruthenian", add
label define languagdlbl 1920 "Little Russian", add
label define languagdlbl 2000 "Czech", add
label define languagdlbl 2010 "Bohemian", add
label define languagdlbl 2020 "Moravian", add
label define languagdlbl 2100 "Polish", add
label define languagdlbl 2110 "Kashubian, Slovincian", add
label define languagdlbl 2200 "Slovak", add
label define languagdlbl 2300 "Serbo-Croatian, Yugoslavian, Slavonian", add
label define languagdlbl 2310 "Croatian", add
label define languagdlbl 2320 "Serbian", add
label define languagdlbl 2331 "Dalmatian", add
label define languagdlbl 2332 "Montenegrin", add
label define languagdlbl 2400 "Slovene", add
label define languagdlbl 2500 "Lithuanian", add
label define languagdlbl 2510 "Lettish", add
label define languagdlbl 2610 "Bulgarian", add
label define languagdlbl 2620 "Lusatian, Sorbian,  Wendish", add
label define languagdlbl 2630 "Macedonian", add
label define languagdlbl 2700 "Slavic unknown", add
label define languagdlbl 2800 "Armenian", add
label define languagdlbl 2900 "Persian, Iranian, Farssi", add
label define languagdlbl 3010 "Pashto, Afghan", add
label define languagdlbl 3020 "Kurdish", add
label define languagdlbl 3030 "Balochi", add
label define languagdlbl 3040 "Tadzhik", add
label define languagdlbl 3050 "Ossete", add
label define languagdlbl 3100 "Hindi and related", add
label define languagdlbl 3101 "Hindi, Hindustani, Indic, Jaipuri, Pali, Urdu", add
label define languagdlbl 3102 "Hindi", add
label define languagdlbl 3103 "Urdu", add
label define languagdlbl 3111 "Sanskrit", add
label define languagdlbl 3112 "Bengali", add
label define languagdlbl 3113 "Panjabi", add
label define languagdlbl 3114 "Marathi", add
label define languagdlbl 3115 "Gujarathi", add
label define languagdlbl 3116 "Bihari", add
label define languagdlbl 3117 "Rajasthani", add
label define languagdlbl 3118 "Oriya", add
label define languagdlbl 3119 "Assamese", add
label define languagdlbl 3120 "Kashmiri", add
label define languagdlbl 3121 "Sindhi", add
label define languagdlbl 3122 "Maldivian", add
label define languagdlbl 3123 "Sinhalese", add
label define languagdlbl 3130 "Kannada", add
label define languagdlbl 3140 "India nec", add
label define languagdlbl 3150 "Pakistan nec", add
label define languagdlbl 3190 "Other Indo-European languages", add
label define languagdlbl 3200 "Romany, Gypsy", add
label define languagdlbl 3300 "Finnish", add
label define languagdlbl 3400 "Magyar, Hungarian", add
label define languagdlbl 3500 "Uralic", add
label define languagdlbl 3510 "Estonian, Ingrian, Livonian, Vepsian,  Votic", add
label define languagdlbl 3520 "Lapp, Inari, Kola, Lule, Pite, Ruija, Skolt, Ume", add
label define languagdlbl 3530 "Other Uralic", add
label define languagdlbl 3600 "Turkish", add
label define languagdlbl 3700 "Other Altaic", add
label define languagdlbl 3701 "Chuvash", add
label define languagdlbl 3702 "Karakalpak", add
label define languagdlbl 3703 "Kazakh", add
label define languagdlbl 3704 "Kirghiz", add
label define languagdlbl 3705 "Karachay, Tatar, Balkar, Bashkir, Kumyk", add
label define languagdlbl 3706 "Uzbek, Uighur", add
label define languagdlbl 3707 "Azerbaijani", add
label define languagdlbl 3708 "Turkmen", add
label define languagdlbl 3709 "Yakut", add
label define languagdlbl 3710 "Mongolian", add
label define languagdlbl 3711 "Tungus", add
label define languagdlbl 3800 "Caucasian, Georgian, Avar", add
label define languagdlbl 3900 "Basque", add
label define languagdlbl 4000 "Dravidian", add
label define languagdlbl 4001 "Brahui", add
label define languagdlbl 4002 "Gondi", add
label define languagdlbl 4003 "Telugu", add
label define languagdlbl 4004 "Malayalam", add
label define languagdlbl 4005 "Tamil", add
label define languagdlbl 4010 "Bhili", add
label define languagdlbl 4011 "Nepali", add
label define languagdlbl 4100 "Kurukh", add
label define languagdlbl 4110 "Munda", add
label define languagdlbl 4200 "Burashaski", add
label define languagdlbl 4300 "Chinese", add
label define languagdlbl 4301 "Chinese, Cantonese, Min, Yueh", add
label define languagdlbl 4302 "Cantonese", add
label define languagdlbl 4303 "Mandarin", add
label define languagdlbl 4311 "Hakka, Fukien, Kechia", add
label define languagdlbl 4312 "Kan, Nan Chang", add
label define languagdlbl 4313 "Hsiang, Chansa, Hunan,  Iyan", add
label define languagdlbl 4314 "Fuchow, Min Pei", add
label define languagdlbl 4315 "Wu", add
label define languagdlbl 4400 "Tibetan", add
label define languagdlbl 4410 "Miao-Yao, Mien", add
label define languagdlbl 4420 "Miao, Hmong", add
label define languagdlbl 4500 "Burmese, Lisu, Lolo", add
label define languagdlbl 4510 "Karen", add
label define languagdlbl 4600 "Kachin", add
label define languagdlbl 4700 "Thai, Siamese, Lao", add
label define languagdlbl 4710 "Thai", add
label define languagdlbl 4720 "Laotian", add
label define languagdlbl 4800 "Japanese", add
label define languagdlbl 4900 "Korean", add
label define languagdlbl 5000 "Vietnamese", add
label define languagdlbl 5110 "Ainu", add
label define languagdlbl 5120 "Mon-Khmer, Cambodian", add
label define languagdlbl 5130 "Siberian, n.e.c.", add
label define languagdlbl 5140 "Yukagir", add
label define languagdlbl 5150 "Muong", add
label define languagdlbl 5200 "Indonesian", add
label define languagdlbl 5210 "Buginese", add
label define languagdlbl 5220 "Moluccan", add
label define languagdlbl 5230 "Achinese", add
label define languagdlbl 5240 "Balinese", add
label define languagdlbl 5250 "Cham", add
label define languagdlbl 5260 "Madurese", add
label define languagdlbl 5270 "Malay", add
label define languagdlbl 5280 "Minangkabau", add
label define languagdlbl 5290 "Other Asian languages", add
label define languagdlbl 5310 "Formosan, Taiwanese", add
label define languagdlbl 5320 "Javanese", add
label define languagdlbl 5330 "Malagasy", add
label define languagdlbl 5340 "Sundanese", add
label define languagdlbl 5400 "Filipino, Tagalog", add
label define languagdlbl 5410 "Bisayan", add
label define languagdlbl 5420 "Sebuano", add
label define languagdlbl 5430 "Pangasinan", add
label define languagdlbl 5440 "Llocano, Hocano", add
label define languagdlbl 5450 "Bikol", add
label define languagdlbl 5460 "Pampangan", add
label define languagdlbl 5470 "Gorontalo", add
label define languagdlbl 5480 "Palau", add
label define languagdlbl 5501 "Micronesian", add
label define languagdlbl 5502 "Carolinian", add
label define languagdlbl 5503 "Chamorro, Guamanian", add
label define languagdlbl 5504 "Gilbertese", add
label define languagdlbl 5505 "Kusaiean", add
label define languagdlbl 5506 "Marshallese", add
label define languagdlbl 5507 "Mokilese", add
label define languagdlbl 5508 "Mortlockese", add
label define languagdlbl 5509 "Nauruan", add
label define languagdlbl 5510 "Ponapean", add
label define languagdlbl 5511 "Trukese", add
label define languagdlbl 5512 "Ulithean, Fais", add
label define languagdlbl 5513 "Woleai-Ulithi", add
label define languagdlbl 5514 "Yapese", add
label define languagdlbl 5520 "Melanesian", add
label define languagdlbl 5521 "Polynesian", add
label define languagdlbl 5522 "Samoan", add
label define languagdlbl 5523 "Tongan", add
label define languagdlbl 5524 "Niuean", add
label define languagdlbl 5525 "Tokelauan", add
label define languagdlbl 5526 "Fijian", add
label define languagdlbl 5527 "Marquesan", add
label define languagdlbl 5528 "Rarotongan", add
label define languagdlbl 5529 "Maori", add
label define languagdlbl 5530 "Nukuoro, Kapingarangan", add
label define languagdlbl 5590 "Other Pacific Island languages", add
label define languagdlbl 5600 "Hawaiian", add
label define languagdlbl 5700 "Arabic", add
label define languagdlbl 5750 "Maltese", add
label define languagdlbl 5810 "Syriac, Aramaic,  Chaldean", add
label define languagdlbl 5900 "Hebrew, Israeli", add
label define languagdlbl 6000 "Amharic, Ethiopian, etc.", add
label define languagdlbl 6110 "Berber", add
label define languagdlbl 6120 "Chadic, Hamitic, Hausa", add
label define languagdlbl 6130 "Cushite, Beja, Somali", add
label define languagdlbl 6300 "Nilotic", add
label define languagdlbl 6301 "Nilo-Hamitic", add
label define languagdlbl 6302 "Nubian", add
label define languagdlbl 6303 "Saharan", add
label define languagdlbl 6304 "Nilo-Saharan, Fur, Songhai", add
label define languagdlbl 6305 "Khoisan", add
label define languagdlbl 6306 "Sudanic", add
label define languagdlbl 6307 "Bantu (many subheads)", add
label define languagdlbl 6308 "Swahili", add
label define languagdlbl 6309 "Mande", add
label define languagdlbl 6310 "Fulani", add
label define languagdlbl 6311 "Gur", add
label define languagdlbl 6312 "Kru", add
label define languagdlbl 6313 "Efik, Ibibio, Tiv", add
label define languagdlbl 6314 "Mbum, Gbaya, Sango, Zande", add
label define languagdlbl 6390 "Other specified African languages", add
label define languagdlbl 6400 "African, n.s.", add
label define languagdlbl 7000 "American Indian (all)", add
label define languagdlbl 7100 "Aleut, Eskimo", add
label define languagdlbl 7110 "Aleut", add
label define languagdlbl 7120 "Pacific Gulf Yupik", add
label define languagdlbl 7130 "Eskimo", add
label define languagdlbl 7140 "Inupik, Innuit", add
label define languagdlbl 7150 "St Lawrence Isl. Yupik", add
label define languagdlbl 7160 "Yupik", add
label define languagdlbl 7200 "Algonquian", add
label define languagdlbl 7201 "Arapaho", add
label define languagdlbl 7202 "Atsina, Gros Ventre", add
label define languagdlbl 7203 "Blackfoot", add
label define languagdlbl 7204 "Cheyenne", add
label define languagdlbl 7205 "Cree", add
label define languagdlbl 7206 "Delaware, Lenni-Lenape", add
label define languagdlbl 7207 "Fox, Sac", add
label define languagdlbl 7208 "Kickapoo", add
label define languagdlbl 7209 "Menomini", add
label define languagdlbl 7210 "Metis, French Cree", add
label define languagdlbl 7211 "Miami", add
label define languagdlbl 7212 "Micmac", add
label define languagdlbl 7213 "Ojibwa, Chippewa", add
label define languagdlbl 7214 "Ottawa", add
label define languagdlbl 7215 "Passamaquoddy, Malecite", add
label define languagdlbl 7216 "Penobscot", add
label define languagdlbl 7217 "Abnaki", add
label define languagdlbl 7218 "Potawatomi", add
label define languagdlbl 7219 "Shawnee", add
label define languagdlbl 7300 "Salish, Flathead", add
label define languagdlbl 7301 "Lower Chehalis", add
label define languagdlbl 7302 "Upper Chehalis, Chehalis, Satsop", add
label define languagdlbl 7303 "Clallam", add
label define languagdlbl 7304 "Coeur dAlene, Skitsamish", add
label define languagdlbl 7305 "Columbia, Chelan, Wenatchee", add
label define languagdlbl 7306 "Cowlitz", add
label define languagdlbl 7307 "Nootsack", add
label define languagdlbl 7308 "Okanogan", add
label define languagdlbl 7309 "Puget Sound Salish", add
label define languagdlbl 7310 "Quinault, Queets", add
label define languagdlbl 7311 "Tillamook", add
label define languagdlbl 7312 "Twana", add
label define languagdlbl 7313 "Kalispel", add
label define languagdlbl 7314 "Spokane", add
label define languagdlbl 7400 "Athapascan", add
label define languagdlbl 7401 "Ahtena", add
label define languagdlbl 7402 "Han", add
label define languagdlbl 7403 "Ingalit", add
label define languagdlbl 7404 "Koyukon", add
label define languagdlbl 7405 "Kuchin", add
label define languagdlbl 7406 "Upper Kuskokwim", add
label define languagdlbl 7407 "Tanaina", add
label define languagdlbl 7408 "Tanana, Minto", add
label define languagdlbl 7409 "Tanacross", add
label define languagdlbl 7410 "Upper Tanana, Nabesena, Tetlin", add
label define languagdlbl 7411 "Tutchone", add
label define languagdlbl 7412 "Chasta Costa, Chetco, Coquille, Smith, River Athapascan", add
label define languagdlbl 7413 "Hupa", add
label define languagdlbl 7420 "Apache", add
label define languagdlbl 7421 "Jicarilla, Lipan", add
label define languagdlbl 7422 "Chiricahua, Mescalero", add
label define languagdlbl 7423 "San Carlos, Cibecue, White Mountain", add
label define languagdlbl 7424 "Kiowa-Apache", add
label define languagdlbl 7430 "Kiowa", add
label define languagdlbl 7440 "Eyak", add
label define languagdlbl 7450 "Other Athapascan-Eyak, Cahto, Mattole, Wailaki", add
label define languagdlbl 7490 "Other Algonquin languages", add
label define languagdlbl 7500 "Navajo", add
label define languagdlbl 7610 "Klamath, Modoc", add
label define languagdlbl 7620 "Nez Perce", add
label define languagdlbl 7630 "Sahaptian, Celilo, Klikitat, Palouse, Tenino, Umatilla, Warm", add
label define languagdlbl 7700 "Mountain Maidu, Maidu", add
label define languagdlbl 7701 "Northwest Maidu, Concow", add
label define languagdlbl 7702 "Southern Maidu, Nisenan", add
label define languagdlbl 7703 "Coast Miwok, Bodega, Marin", add
label define languagdlbl 7704 "Plains Mowak", add
label define languagdlbl 7705 "Sierra Miwok, Miwok", add
label define languagdlbl 7706 "Nomlaki, Tehama", add
label define languagdlbl 7707 "Patwin, Colouse, Suisun", add
label define languagdlbl 7708 "Wintun", add
label define languagdlbl 7709 "Foothill North Yokuts", add
label define languagdlbl 7710 "Tachi", add
label define languagdlbl 7711 "Santiam, Calapooya, Waputa", add
label define languagdlbl 7712 "Siuslaw, Coos, Lower Umpqua", add
label define languagdlbl 7713 "Tsimshian", add
label define languagdlbl 7714 "Upper Chinook, Clackamas, Multnomah, Wasco, Wishram", add
label define languagdlbl 7715 "Chinook Jargon", add
label define languagdlbl 7800 "Zuni", add
label define languagdlbl 7900 "Yuman", add
label define languagdlbl 7910 "Upriver Yuman", add
label define languagdlbl 7920 "Cocomaricopa", add
label define languagdlbl 7930 "Mohave", add
label define languagdlbl 7940 "Diegueno", add
label define languagdlbl 7950 "Delta River Yuman", add
label define languagdlbl 7960 "Upland Yuman", add
label define languagdlbl 7970 "Havasupai", add
label define languagdlbl 7980 "Walapai", add
label define languagdlbl 7990 "Yavapai", add
label define languagdlbl 8000 "Achumawi", add
label define languagdlbl 8010 "Atsugewi", add
label define languagdlbl 8020 "Karok", add
label define languagdlbl 8030 "Pomo", add
label define languagdlbl 8040 "Shastan", add
label define languagdlbl 8050 "Washo", add
label define languagdlbl 8060 "Chumash", add
label define languagdlbl 8101 "Crow, Absaroke", add
label define languagdlbl 8102 "Hidatsa", add
label define languagdlbl 8103 "Mandan", add
label define languagdlbl 8104 "Dakota, Lakota, Nakota, Sioux", add
label define languagdlbl 8105 "Chiwere", add
label define languagdlbl 8106 "Winnebago", add
label define languagdlbl 8107 "Kansa, Kaw", add
label define languagdlbl 8108 "Omaha", add
label define languagdlbl 8109 "Osage", add
label define languagdlbl 8110 "Ponca", add
label define languagdlbl 8111 "Quapaw, Arkansas", add
label define languagdlbl 8210 "Alabama", add
label define languagdlbl 8220 "Choctaw, Chickasaw", add
label define languagdlbl 8230 "Mikasuki", add
label define languagdlbl 8240 "Hichita, Apalachicola", add
label define languagdlbl 8250 "Koasati", add
label define languagdlbl 8260 "Muskogee, Creek, Seminole", add
label define languagdlbl 8300 "Keres", add
label define languagdlbl 8400 "Iroquoian", add
label define languagdlbl 8410 "Mohawk", add
label define languagdlbl 8420 "Oneida", add
label define languagdlbl 8430 "Onandaga", add
label define languagdlbl 8440 "Cayuga", add
label define languagdlbl 8450 "Seneca", add
label define languagdlbl 8460 "Tuscarora", add
label define languagdlbl 8470 "Wyando, Huran", add
label define languagdlbl 8480 "Cherokee", add
label define languagdlbl 8500 "Caddoan", add
label define languagdlbl 8510 "Arikara", add
label define languagdlbl 8520 "Pawnee", add
label define languagdlbl 8530 "Wichita", add
label define languagdlbl 8601 "Comanche", add
label define languagdlbl 8602 "Mono, Owens Valley Paiute", add
label define languagdlbl 8603 "Paiute", add
label define languagdlbl 8604 "Northern Paiute, Bannock, Num, Snake", add
label define languagdlbl 8605 "Southern Paiute", add
label define languagdlbl 8606 "Chemehuevi", add
label define languagdlbl 8607 "Kawaiisu", add
label define languagdlbl 8608 "Ute", add
label define languagdlbl 8609 "Shoshoni", add
label define languagdlbl 8610 "Panamint", add
label define languagdlbl 8620 "Hopi", add
label define languagdlbl 8630 "Cahuilla", add
label define languagdlbl 8631 "Cupeno", add
label define languagdlbl 8632 "Luiseno", add
label define languagdlbl 8633 "Serrano", add
label define languagdlbl 8640 "Tubatulabal", add
label define languagdlbl 8700 "Pima, Papago", add
label define languagdlbl 8800 "Yaqui", add
label define languagdlbl 8810 "Sonoran n.e.c., Cahita, Guassave, Huichole, Nayit, Tarahumar", add
label define languagdlbl 8910 "Aztecan, Mexicano, Nahua", add
label define languagdlbl 9010 "Picuris, Northern Tiwa, Taos", add
label define languagdlbl 9020 "Tiwa, Isleta", add
label define languagdlbl 9030 "Sandia", add
label define languagdlbl 9040 "Tewa, Hano, Hopi-Tewa, San Ildefonso, San Juan, Santa Clara", add
label define languagdlbl 9050 "Towa", add
label define languagdlbl 9100 "Wiyot", add
label define languagdlbl 9101 "Yurok", add
label define languagdlbl 9110 "Kwakiutl", add
label define languagdlbl 9111 "Nootka", add
label define languagdlbl 9112 "Makah", add
label define languagdlbl 9120 "Kutenai", add
label define languagdlbl 9130 "Haida", add
label define languagdlbl 9131 "Tlingit, Chilkat, Sitka, Tongass, Yakutat", add
label define languagdlbl 9140 "Tonkawa", add
label define languagdlbl 9150 "Yuchi", add
label define languagdlbl 9160 "Chetemacha", add
label define languagdlbl 9170 "Yuki", add
label define languagdlbl 9171 "Wappo", add
label define languagdlbl 9200 "Misumalpan", add
label define languagdlbl 9210 "Mayan languages", add
label define languagdlbl 9220 "Tarascan", add
label define languagdlbl 9230 "Mapuche", add
label define languagdlbl 9240 "Oto-Manguen", add
label define languagdlbl 9250 "Quechua", add
label define languagdlbl 9260 "Aymara", add
label define languagdlbl 9270 "Arawakian", add
label define languagdlbl 9280 "Chibchan", add
label define languagdlbl 9290 "Tupi-Guarani", add
label define languagdlbl 9300 "American Indian, n.s.", add
label define languagdlbl 9410 "Other specified American Indian languages", add
label define languagdlbl 9420 "South/Central American Indian", add
label define languagdlbl 9500 "No language", add
label define languagdlbl 9600 "Other or not reported", add
label define languagdlbl 9601 "Other n.e.c.", add
label define languagdlbl 9602 "Other n.s.", add
label values languagd languagdlbl

save "C:\Documents and Settings\Krishna Patel\My Documents\thesis_topic occdist\immigrants\census90_3_foreignborn.dta", replace
