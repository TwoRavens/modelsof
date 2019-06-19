/* Important: you need to put the .dat and .do files in one folder/
   directory and then set the working folder to that folder. */

set more off

clear
infix ///
 byte    urban                                1 ///
 byte    statemx                              2-3 ///
 int     age                                  4-6 ///
 byte    sex                                  7 ///
 int     marst                                8 ///
 byte    yrschl                               9-10 ///
 int     educmx                              11-13 ///
 int     empstat                             14 ///
 int     classwk                             15 ///
 int     hrswrk1                             16-18 ///
 double  incearn                             19-26 ///
 using ipumsi_00017.dat

label var urban `"Urban-rural status"'
label var statemx `"State, Mexico"'
label var age `"Age"'
label var sex `"Sex"'
label var marst `"Marital status [general version]"'
label var yrschl `"Years of schooling"'
label var educmx `"Educational attainment, Mexico"'
label var empstat `"Employment status [general version]"'
label var classwk `"Class of worker [general version]"'
label var hrswrk1 `"Hours worked per week"'
label var incearn `"Earned income"'

label define urbanlbl 0 `"NIU (not in universe)"'
label define urbanlbl 1 `"Rural"', add
label define urbanlbl 2 `"Urban"', add
label define urbanlbl 9 `"Unknown"', add
label values urban urbanlbl

label define statemxlbl 01 `"Aguascalientes"'
label define statemxlbl 02 `"Baja California"', add
label define statemxlbl 03 `"Baja California Sur"', add
label define statemxlbl 04 `"Campeche"', add
label define statemxlbl 05 `"Coahuila"', add
label define statemxlbl 06 `"Colima"', add
label define statemxlbl 07 `"Chiapas"', add
label define statemxlbl 08 `"Chihuahua"', add
label define statemxlbl 09 `"Distrito Federal"', add
label define statemxlbl 10 `"Durango"', add
label define statemxlbl 11 `"Guanajuato"', add
label define statemxlbl 12 `"Guerrero"', add
label define statemxlbl 13 `"Hidalgo"', add
label define statemxlbl 14 `"Jalisco"', add
label define statemxlbl 15 `"México"', add
label define statemxlbl 16 `"Michoacán"', add
label define statemxlbl 17 `"Morelos"', add
label define statemxlbl 18 `"Nayarit"', add
label define statemxlbl 19 `"Nuevo León"', add
label define statemxlbl 20 `"Oaxaca"', add
label define statemxlbl 21 `"Puebla"', add
label define statemxlbl 22 `"Querétaro"', add
label define statemxlbl 23 `"Quintana Roo"', add
label define statemxlbl 24 `"San Luis Potosí"', add
label define statemxlbl 25 `"Sinaloa"', add
label define statemxlbl 26 `"Sonora"', add
label define statemxlbl 27 `"Tabasco"', add
label define statemxlbl 28 `"Tamaulipas"', add
label define statemxlbl 29 `"Tlaxcala"', add
label define statemxlbl 30 `"Veracruz"', add
label define statemxlbl 31 `"Yucatán"', add
label define statemxlbl 32 `"Zacatecas"', add
label values statemx statemxlbl

label define agelbl 000 `"Less than 1 year"'
label define agelbl 001 `"1 year"', add
label define agelbl 002 `"2 years"', add
label define agelbl 003 `"3"', add
label define agelbl 004 `"4"', add
label define agelbl 005 `"5"', add
label define agelbl 006 `"6"', add
label define agelbl 007 `"7"', add
label define agelbl 008 `"8"', add
label define agelbl 009 `"9"', add
label define agelbl 010 `"10"', add
label define agelbl 011 `"11"', add
label define agelbl 012 `"12"', add
label define agelbl 013 `"13"', add
label define agelbl 014 `"14"', add
label define agelbl 015 `"15"', add
label define agelbl 016 `"16"', add
label define agelbl 017 `"17"', add
label define agelbl 018 `"18"', add
label define agelbl 019 `"19"', add
label define agelbl 020 `"20"', add
label define agelbl 021 `"21"', add
label define agelbl 022 `"22"', add
label define agelbl 023 `"23"', add
label define agelbl 024 `"24"', add
label define agelbl 025 `"25"', add
label define agelbl 026 `"26"', add
label define agelbl 027 `"27"', add
label define agelbl 028 `"28"', add
label define agelbl 029 `"29"', add
label define agelbl 030 `"30"', add
label define agelbl 031 `"31"', add
label define agelbl 032 `"32"', add
label define agelbl 033 `"33"', add
label define agelbl 034 `"34"', add
label define agelbl 035 `"35"', add
label define agelbl 036 `"36"', add
label define agelbl 037 `"37"', add
label define agelbl 038 `"38"', add
label define agelbl 039 `"39"', add
label define agelbl 040 `"40"', add
label define agelbl 041 `"41"', add
label define agelbl 042 `"42"', add
label define agelbl 043 `"43"', add
label define agelbl 044 `"44"', add
label define agelbl 045 `"45"', add
label define agelbl 046 `"46"', add
label define agelbl 047 `"47"', add
label define agelbl 048 `"48"', add
label define agelbl 049 `"49"', add
label define agelbl 050 `"50"', add
label define agelbl 051 `"51"', add
label define agelbl 052 `"52"', add
label define agelbl 053 `"53"', add
label define agelbl 054 `"54"', add
label define agelbl 055 `"55"', add
label define agelbl 056 `"56"', add
label define agelbl 057 `"57"', add
label define agelbl 058 `"58"', add
label define agelbl 059 `"59"', add
label define agelbl 060 `"60"', add
label define agelbl 061 `"61"', add
label define agelbl 062 `"62"', add
label define agelbl 063 `"63"', add
label define agelbl 064 `"64"', add
label define agelbl 065 `"65"', add
label define agelbl 066 `"66"', add
label define agelbl 067 `"67"', add
label define agelbl 068 `"68"', add
label define agelbl 069 `"69"', add
label define agelbl 070 `"70"', add
label define agelbl 071 `"71"', add
label define agelbl 072 `"72"', add
label define agelbl 073 `"73"', add
label define agelbl 074 `"74"', add
label define agelbl 075 `"75"', add
label define agelbl 076 `"76"', add
label define agelbl 077 `"77"', add
label define agelbl 078 `"78"', add
label define agelbl 079 `"79"', add
label define agelbl 080 `"80"', add
label define agelbl 081 `"81"', add
label define agelbl 082 `"82"', add
label define agelbl 083 `"83"', add
label define agelbl 084 `"84"', add
label define agelbl 085 `"85"', add
label define agelbl 086 `"86"', add
label define agelbl 087 `"87"', add
label define agelbl 088 `"88"', add
label define agelbl 089 `"89"', add
label define agelbl 090 `"90"', add
label define agelbl 091 `"91"', add
label define agelbl 092 `"92"', add
label define agelbl 093 `"93"', add
label define agelbl 094 `"94"', add
label define agelbl 095 `"95"', add
label define agelbl 096 `"96"', add
label define agelbl 097 `"97"', add
label define agelbl 098 `"98"', add
label define agelbl 099 `"99"', add
label define agelbl 100 `"100+"', add
label define agelbl 999 `"Not reported/missing"', add
label values age agelbl

label define sexlbl 1 `"Male"'
label define sexlbl 2 `"Female"', add
label define sexlbl 9 `"Unknown"', add
label values sex sexlbl

label define marstlbl 0 `"NIU (not in universe)"'
label define marstlbl 1 `"Single/never married"', add
label define marstlbl 2 `"Married/in union"', add
label define marstlbl 3 `"Separated/divorced/spouse absent"', add
label define marstlbl 4 `"Widowed"', add
label define marstlbl 9 `"Unknown/missing"', add
label values marst marstlbl

label define yrschllbl 00 `"None or pre-school"'
label define yrschllbl 01 `"1 year"', add
label define yrschllbl 02 `"2 years"', add
label define yrschllbl 03 `"3 years"', add
label define yrschllbl 04 `"4 years"', add
label define yrschllbl 05 `"5 years"', add
label define yrschllbl 06 `"6 years"', add
label define yrschllbl 07 `"7 years"', add
label define yrschllbl 08 `"8 years"', add
label define yrschllbl 09 `"9 years"', add
label define yrschllbl 10 `"10 years"', add
label define yrschllbl 11 `"11 years"', add
label define yrschllbl 12 `"12 years"', add
label define yrschllbl 13 `"13 years"', add
label define yrschllbl 14 `"14 years"', add
label define yrschllbl 15 `"15 years"', add
label define yrschllbl 16 `"16 years"', add
label define yrschllbl 17 `"17 years"', add
label define yrschllbl 18 `"18 years or more"', add
label define yrschllbl 90 `"Not specified"', add
label define yrschllbl 91 `"Some primary"', add
label define yrschllbl 92 `"Some technical after primary"', add
label define yrschllbl 93 `"Some secondary"', add
label define yrschllbl 94 `"Some tertiary"', add
label define yrschllbl 95 `"Adult literacy"', add
label define yrschllbl 96 `"Special education (Venezuela)"', add
label define yrschllbl 97 `"Response suppressed"', add
label define yrschllbl 98 `"Unknown/missing"', add
label define yrschllbl 99 `"NIU (not in universe)"', add
label values yrschl yrschllbl

label define educmxlbl 000 `"Less than primary"'
label define educmxlbl 010 `"None, or never attended school"', add
label define educmxlbl 020 `"Preschool or kindergarten"', add
label define educmxlbl 021 `"Preschool, 1 year"', add
label define educmxlbl 022 `"Preschool, 2 years"', add
label define educmxlbl 023 `"Preschool, 3 years"', add
label define educmxlbl 029 `"Preschool, unspecified years"', add
label define educmxlbl 100 `"Primary"', add
label define educmxlbl 101 `"Primary, 1 year"', add
label define educmxlbl 102 `"Primary, 2 years"', add
label define educmxlbl 103 `"Primary, 3 years"', add
label define educmxlbl 104 `"Primary, 4 years"', add
label define educmxlbl 105 `"Primary, 5 years"', add
label define educmxlbl 106 `"Primary, 6 years"', add
label define educmxlbl 109 `"Primary, years unspecified"', add
label define educmxlbl 200 `"Lower secondary (middle or junior high school)"', add
label define educmxlbl 210 `"Lower secondary, tech/commercial"', add
label define educmxlbl 211 `"Lower secondary, tech/commercial, 1 year"', add
label define educmxlbl 212 `"Lower secondary, tech/commercial, 2 years"', add
label define educmxlbl 213 `"Lower secondary, tech/commercial, 3 years"', add
label define educmxlbl 214 `"Lower secondary, tech/commercial, 4 years"', add
label define educmxlbl 219 `"Lower secondary, tech/commercial, years unspec."', add
label define educmxlbl 220 `"Lower secondary, general track"', add
label define educmxlbl 221 `"Lower secondary, general track, 1 year"', add
label define educmxlbl 222 `"Lower secondary, general track, 2 years"', add
label define educmxlbl 223 `"Lower secondary, general track, 3 years"', add
label define educmxlbl 229 `"Lower secondary, general track, years unspec."', add
label define educmxlbl 230 `"Lower secondary, track unspec."', add
label define educmxlbl 231 `"Lower secondary, track unspec., 1 year"', add
label define educmxlbl 232 `"Lower secondary, track unspec., 2 years"', add
label define educmxlbl 233 `"Lower secondary, track unspec., 3 years"', add
label define educmxlbl 239 `"Years unspecified"', add
label define educmxlbl 300 `"Secondary (high school)"', add
label define educmxlbl 310 `"Secondary tech/commercial"', add
label define educmxlbl 311 `"Secondary tech/commercial, 1 year"', add
label define educmxlbl 312 `"Secondary tech/commercial, 2 years"', add
label define educmxlbl 313 `"Secondary tech/commercial, 3 years"', add
label define educmxlbl 314 `"Secondary tech/commercial, 4 years"', add
label define educmxlbl 315 `"5 years"', add
label define educmxlbl 319 `"Secondary tech/commercial, years unspec."', add
label define educmxlbl 320 `"Secondary, general track"', add
label define educmxlbl 321 `"Secondary, general track, 1 year"', add
label define educmxlbl 322 `"Secondary, general track, 2 years"', add
label define educmxlbl 323 `"Secondary, general track, 3 years"', add
label define educmxlbl 329 `"Secondary, general track, years unspec."', add
label define educmxlbl 390 `"Secondary, track unspec."', add
label define educmxlbl 391 `"Secondary, track unspec., 1 year"', add
label define educmxlbl 392 `"Secondary, track unspec., 2 years"', add
label define educmxlbl 393 `"Secondary, track unspec., 3 years"', add
label define educmxlbl 399 `"Years unspecified"', add
label define educmxlbl 400 `"Normal school (teacher-training)"', add
label define educmxlbl 401 `"Normal, 1 year"', add
label define educmxlbl 402 `"Normal, 2 years"', add
label define educmxlbl 403 `"Normal, 3 years"', add
label define educmxlbl 404 `"Normal, 4 years"', add
label define educmxlbl 409 `"Normal, years unspec."', add
label define educmxlbl 500 `"Post-secondary technical"', add
label define educmxlbl 501 `"Post-secondary technical, 1 year"', add
label define educmxlbl 502 `"Post-secondary technical, 2 years"', add
label define educmxlbl 503 `"Post-secondary technical, 3 years"', add
label define educmxlbl 504 `"Post-secondary technical, 4 years"', add
label define educmxlbl 505 `"Post-secondary technical, 5 years"', add
label define educmxlbl 509 `"Post-secondary technical, years unspec."', add
label define educmxlbl 600 `"University"', add
label define educmxlbl 610 `"University undergraduate"', add
label define educmxlbl 611 `"University undergraduate, 1 year"', add
label define educmxlbl 612 `"University undergraduate, 2 years"', add
label define educmxlbl 613 `"University undergraduate, 3 years"', add
label define educmxlbl 614 `"University undergraduate, 4 years"', add
label define educmxlbl 615 `"University undergraduate, 5 years"', add
label define educmxlbl 616 `"University undergraduate, 6 years"', add
label define educmxlbl 617 `"University undergraduate, 7 years"', add
label define educmxlbl 618 `"University undergraduate, 8+ years"', add
label define educmxlbl 619 `"University undergraduate, years unspec."', add
label define educmxlbl 620 `"University graduate"', add
label define educmxlbl 621 `"University graduate, 1 year"', add
label define educmxlbl 622 `"University graduate, 2 years"', add
label define educmxlbl 623 `"University graduate, 3 years"', add
label define educmxlbl 624 `"University graduate, 4 years"', add
label define educmxlbl 625 `"University graduate, 5 years"', add
label define educmxlbl 626 `"University graduate, 6 years"', add
label define educmxlbl 627 `"University graduate, 7 years"', add
label define educmxlbl 628 `"University graduate, 8+ years"', add
label define educmxlbl 629 `"University graduate, years unspec."', add
label define educmxlbl 630 `"Masters degree (2005)"', add
label define educmxlbl 631 `"Masters, 1 year"', add
label define educmxlbl 632 `"Masters, 2 years"', add
label define educmxlbl 639 `"Masters, year unspecified"', add
label define educmxlbl 640 `"Doctoral degree (2005)"', add
label define educmxlbl 641 `"Doctoral, 1 year"', add
label define educmxlbl 642 `"Doctoral, 2 years"', add
label define educmxlbl 643 `"Doctoral, 3 years"', add
label define educmxlbl 644 `"Doctoral, 4 years"', add
label define educmxlbl 645 `"Doctoral, 5 years"', add
label define educmxlbl 646 `"Doctoral, 6 years"', add
label define educmxlbl 649 `"Doctoral, years unspecified"', add
label define educmxlbl 700 `"Unspecified post-secondary"', add
label define educmxlbl 701 `"Unspecified post-secondary, 1 year"', add
label define educmxlbl 702 `"Unspecified post-secondary, 2 years"', add
label define educmxlbl 703 `"Unspecified post-secondary, 3 years"', add
label define educmxlbl 704 `"Unspecified post-secondary, 4 years"', add
label define educmxlbl 705 `"Unspecified post-secondary, 5 years"', add
label define educmxlbl 706 `"Unspecified post-secondary, 6 years"', add
label define educmxlbl 707 `"Unspecified post-secondary, 7 years"', add
label define educmxlbl 708 `"Unspecified post-secondary, 8+ years"', add
label define educmxlbl 800 `"Unknown/missing"', add
label define educmxlbl 999 `"NIU (not in universe)"', add
label values educmx educmxlbl

label define empstatlbl 0 `"NIU"'
label define empstatlbl 1 `"Employed"', add
label define empstatlbl 2 `"Unemployed"', add
label define empstatlbl 3 `"Inactive"', add
label define empstatlbl 9 `"Unknown/missing"', add
label values empstat empstatlbl

label define classwklbl 0 `"NIU"'
label define classwklbl 1 `"Self-employed"', add
label define classwklbl 2 `"Wage/salary worker"', add
label define classwklbl 3 `"Unpaid worker"', add
label define classwklbl 4 `"Other"', add
label define classwklbl 9 `"Unknown/missing"', add
label values classwk classwklbl

label define hrswrk1lbl 000 `"0 hours"'
label define hrswrk1lbl 001 `"1 hour"', add
label define hrswrk1lbl 002 `"2 hours"', add
label define hrswrk1lbl 003 `"3 hours"', add
label define hrswrk1lbl 004 `"4 hours"', add
label define hrswrk1lbl 005 `"5 hours"', add
label define hrswrk1lbl 006 `"6 hours"', add
label define hrswrk1lbl 007 `"7 hours"', add
label define hrswrk1lbl 008 `"8 hours"', add
label define hrswrk1lbl 009 `"9 hours"', add
label define hrswrk1lbl 010 `"10 hours"', add
label define hrswrk1lbl 011 `"11 hours"', add
label define hrswrk1lbl 012 `"12 hours"', add
label define hrswrk1lbl 013 `"13 hours"', add
label define hrswrk1lbl 014 `"14 hours"', add
label define hrswrk1lbl 015 `"15 hours"', add
label define hrswrk1lbl 016 `"16 hours"', add
label define hrswrk1lbl 017 `"17 hours"', add
label define hrswrk1lbl 018 `"18 hours"', add
label define hrswrk1lbl 019 `"19 hours"', add
label define hrswrk1lbl 020 `"20 hours"', add
label define hrswrk1lbl 021 `"21 hours"', add
label define hrswrk1lbl 022 `"22 hours"', add
label define hrswrk1lbl 023 `"23 hours"', add
label define hrswrk1lbl 024 `"24 hours"', add
label define hrswrk1lbl 025 `"25 hours"', add
label define hrswrk1lbl 026 `"26 hours"', add
label define hrswrk1lbl 027 `"27 hours"', add
label define hrswrk1lbl 028 `"28 hours"', add
label define hrswrk1lbl 029 `"29 hours"', add
label define hrswrk1lbl 030 `"30 hours"', add
label define hrswrk1lbl 031 `"31 hours"', add
label define hrswrk1lbl 032 `"32 hours"', add
label define hrswrk1lbl 033 `"33 hours"', add
label define hrswrk1lbl 034 `"34 hours"', add
label define hrswrk1lbl 035 `"35 hours"', add
label define hrswrk1lbl 036 `"36 hours"', add
label define hrswrk1lbl 037 `"37 hours"', add
label define hrswrk1lbl 038 `"38 hours"', add
label define hrswrk1lbl 039 `"39 hours"', add
label define hrswrk1lbl 040 `"40 hours"', add
label define hrswrk1lbl 041 `"41 hours"', add
label define hrswrk1lbl 042 `"42 hours"', add
label define hrswrk1lbl 043 `"43 hours"', add
label define hrswrk1lbl 044 `"44 hours"', add
label define hrswrk1lbl 045 `"45 hours"', add
label define hrswrk1lbl 046 `"46 hours"', add
label define hrswrk1lbl 047 `"47 hours"', add
label define hrswrk1lbl 048 `"48 hours"', add
label define hrswrk1lbl 049 `"49 hours"', add
label define hrswrk1lbl 050 `"50 hours"', add
label define hrswrk1lbl 051 `"51 hours"', add
label define hrswrk1lbl 052 `"52 hours"', add
label define hrswrk1lbl 053 `"53 hours"', add
label define hrswrk1lbl 054 `"54 hours"', add
label define hrswrk1lbl 055 `"55 hours"', add
label define hrswrk1lbl 056 `"56 hours"', add
label define hrswrk1lbl 057 `"57 hours"', add
label define hrswrk1lbl 058 `"58 hours"', add
label define hrswrk1lbl 059 `"59 hours"', add
label define hrswrk1lbl 060 `"60 hours"', add
label define hrswrk1lbl 061 `"61 hours"', add
label define hrswrk1lbl 062 `"62 hours"', add
label define hrswrk1lbl 063 `"63 hours"', add
label define hrswrk1lbl 064 `"64 hours"', add
label define hrswrk1lbl 065 `"65 hours"', add
label define hrswrk1lbl 066 `"66 hours"', add
label define hrswrk1lbl 067 `"67 hours"', add
label define hrswrk1lbl 068 `"68 hours"', add
label define hrswrk1lbl 069 `"69 hours"', add
label define hrswrk1lbl 070 `"70 hours"', add
label define hrswrk1lbl 071 `"71 hours"', add
label define hrswrk1lbl 072 `"72 hours"', add
label define hrswrk1lbl 073 `"73 hours"', add
label define hrswrk1lbl 074 `"74 hours"', add
label define hrswrk1lbl 075 `"75 hours"', add
label define hrswrk1lbl 076 `"76 hours"', add
label define hrswrk1lbl 077 `"77 hours"', add
label define hrswrk1lbl 078 `"78 hours"', add
label define hrswrk1lbl 079 `"79 hours"', add
label define hrswrk1lbl 080 `"80 hours"', add
label define hrswrk1lbl 081 `"81 hours"', add
label define hrswrk1lbl 082 `"82 hours"', add
label define hrswrk1lbl 083 `"83 hours"', add
label define hrswrk1lbl 084 `"84 hours"', add
label define hrswrk1lbl 085 `"85 hours"', add
label define hrswrk1lbl 086 `"86 hours"', add
label define hrswrk1lbl 087 `"87 hours"', add
label define hrswrk1lbl 088 `"88 hours"', add
label define hrswrk1lbl 089 `"89 hours"', add
label define hrswrk1lbl 090 `"90 hours"', add
label define hrswrk1lbl 091 `"91 hours"', add
label define hrswrk1lbl 092 `"92 hours"', add
label define hrswrk1lbl 093 `"93 hours"', add
label define hrswrk1lbl 094 `"94 hours"', add
label define hrswrk1lbl 095 `"95 hours"', add
label define hrswrk1lbl 096 `"96 hours"', add
label define hrswrk1lbl 097 `"97 hours"', add
label define hrswrk1lbl 098 `"98 hours"', add
label define hrswrk1lbl 099 `"99 hours"', add
label define hrswrk1lbl 100 `"100 hours"', add
label define hrswrk1lbl 101 `"101 hours"', add
label define hrswrk1lbl 102 `"102 hours"', add
label define hrswrk1lbl 103 `"103 hours"', add
label define hrswrk1lbl 104 `"104 hours"', add
label define hrswrk1lbl 105 `"105 hours"', add
label define hrswrk1lbl 106 `"106 hours"', add
label define hrswrk1lbl 107 `"107 hours"', add
label define hrswrk1lbl 108 `"108 hours"', add
label define hrswrk1lbl 109 `"109 hours"', add
label define hrswrk1lbl 110 `"110 hours"', add
label define hrswrk1lbl 111 `"111 hours"', add
label define hrswrk1lbl 112 `"112 hours"', add
label define hrswrk1lbl 113 `"113 hours"', add
label define hrswrk1lbl 114 `"114 hours"', add
label define hrswrk1lbl 115 `"115 hours"', add
label define hrswrk1lbl 116 `"116 hours"', add
label define hrswrk1lbl 117 `"117 hours"', add
label define hrswrk1lbl 118 `"118 hours"', add
label define hrswrk1lbl 119 `"119 hours"', add
label define hrswrk1lbl 120 `"120 hours"', add
label define hrswrk1lbl 121 `"121 hours"', add
label define hrswrk1lbl 122 `"122 hours"', add
label define hrswrk1lbl 123 `"123 hours"', add
label define hrswrk1lbl 124 `"124 hours"', add
label define hrswrk1lbl 125 `"125 hours"', add
label define hrswrk1lbl 126 `"126 hours"', add
label define hrswrk1lbl 127 `"127 hours"', add
label define hrswrk1lbl 128 `"128 hours"', add
label define hrswrk1lbl 129 `"129 hours"', add
label define hrswrk1lbl 130 `"130 hours"', add
label define hrswrk1lbl 131 `"131 hours"', add
label define hrswrk1lbl 132 `"132 hours"', add
label define hrswrk1lbl 133 `"133 hours"', add
label define hrswrk1lbl 134 `"134 hours"', add
label define hrswrk1lbl 135 `"135 hours"', add
label define hrswrk1lbl 136 `"136 hours"', add
label define hrswrk1lbl 137 `"137 hours"', add
label define hrswrk1lbl 138 `"138 hours"', add
label define hrswrk1lbl 139 `"139 hours"', add
label define hrswrk1lbl 140 `"140+ hours"', add
label define hrswrk1lbl 998 `"Unknown"', add
label define hrswrk1lbl 999 `"NIU (not in universe)"', add
label values hrswrk1 hrswrk1lbl

save using mexico2000, replace

