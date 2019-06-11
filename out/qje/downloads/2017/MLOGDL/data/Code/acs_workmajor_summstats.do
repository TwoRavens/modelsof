/*
Preference for the Workplace, Investment in Human Capital, and Gender
 - Matthew Wiswall and Basit Zafar

Overview:
1) Create ACS table for the paper

*/
set matsize 1000
*global maindir /san/RDS/Work/mms/b1jxc50/Basit/NYU_Hypotheticals/Files_To_QJE/
global maindir "C:\Users\b1bxz01\Desktop\Temp\Tables NYU Updating\Job Hypotheticals\Draft\Revision June 2016\Resubmission April 2017\Files_To_QJE\"
global datadir   "${maindir}Data/"
global outputdir "${maindir}Output/"

local redo_acs_data = 1

if `redo_acs_data' == 1 {
#delimit cr;
* NOTE: You need to set the Stata working directory to the path
* where the data file is located.

set more off

clear
quietly infix                ///
  int     year        1-4    ///
  byte    datanum     5-6    ///
  double  serial      7-14   ///
  float   hhwt        15-24  ///
  byte    gq          25-25  ///
  int     pernum      26-29  ///
  float   perwt       30-39  ///
  byte    sex         40-40  ///
  int     age         41-43  ///
  byte    marst       44-44  ///
  byte    race        45-45  ///
  int     raced       46-48  ///
  byte    racesing    49-49  ///
  byte    racesingd   50-51  ///
  byte    racother    52-52  ///
  byte    educ        53-54  ///
  int     educd       55-57  ///
  byte    degfield    58-59  ///
  int     degfieldd   60-63  ///
  byte    degfield2   64-65  ///
  int     degfield2d  66-69  ///
  byte    empstat     70-70  ///
  byte    empstatd    71-72  ///
  int     occ         73-76  ///
  int     ind         77-80  ///
  str     indnaics    81-88  ///
  byte    wkswork2    89-89  ///
  byte    uhrswork    90-91  ///
  long    incwage     92-97  ///
  using `"${datadir}ACS_2013.dat"'

replace hhwt       = hhwt       / 100
replace perwt      = perwt      / 100

format serial     %8.0f
format hhwt       %10.2f
format perwt      %10.2f

label var year       `"Census year"'
label var datanum    `"Data set number"'
label var serial     `"Household serial number"'
label var hhwt       `"Household weight"'
label var gq         `"Group quarters status"'
label var pernum     `"Person number in sample unit"'
label var perwt      `"Person weight"'
label var sex        `"Sex"'
label var age        `"Age"'
label var marst      `"Marital status"'
label var race       `"Race [general version]"'
label var raced      `"Race [detailed version]"'
label var racesing   `"Race: Single race identification [general version]"'
label var racesingd  `"Race: Single race identification [detailed version]"'
label var racother   `"Race: some other race"'
label var educ       `"Educational attainment [general version]"'
label var educd      `"Educational attainment [detailed version]"'
label var degfield   `"Field of degree [general version]"'
label var degfieldd  `"Field of degree [detailed version]"'
label var degfield2  `"Field of degree (2) [general version]"'
label var degfield2d `"Field of degree (2) [detailed version]"'
label var empstat    `"Employment status [general version]"'
label var empstatd   `"Employment status [detailed version]"'
label var occ        `"Occupation"'
label var ind        `"Industry"'
label var indnaics   `"Industry, NAICS classification"'
label var wkswork2   `"Weeks worked last year, intervalled"'
label var uhrswork   `"Usual hours worked per week"'
label var incwage    `"Wage and salary income"'

label define year_lbl 1850 `"1850"'
label define year_lbl 1860 `"1860"', add
label define year_lbl 1870 `"1870"', add
label define year_lbl 1880 `"1880"', add
label define year_lbl 1900 `"1900"', add
label define year_lbl 1910 `"1910"', add
label define year_lbl 1920 `"1920"', add
label define year_lbl 1930 `"1930"', add
label define year_lbl 1940 `"1940"', add
label define year_lbl 1950 `"1950"', add
label define year_lbl 1960 `"1960"', add
label define year_lbl 1970 `"1970"', add
label define year_lbl 1980 `"1980"', add
label define year_lbl 1990 `"1990"', add
label define year_lbl 2000 `"2000"', add
label define year_lbl 2001 `"2001"', add
label define year_lbl 2002 `"2002"', add
label define year_lbl 2003 `"2003"', add
label define year_lbl 2004 `"2004"', add
label define year_lbl 2005 `"2005"', add
label define year_lbl 2006 `"2006"', add
label define year_lbl 2007 `"2007"', add
label define year_lbl 2008 `"2008"', add
label define year_lbl 2009 `"2009"', add
label define year_lbl 2010 `"2010"', add
label define year_lbl 2011 `"2011"', add
label define year_lbl 2012 `"2012"', add
label define year_lbl 2013 `"2013"', add
label define year_lbl 2014 `"2014"', add
label define year_lbl 2015 `"2015"', add
label values year year_lbl

label define gq_lbl 0 `"Vacant unit"'
label define gq_lbl 1 `"Households under 1970 definition"', add
label define gq_lbl 2 `"Additional households under 1990 definition"', add
label define gq_lbl 3 `"Group quarters--Institutions"', add
label define gq_lbl 4 `"Other group quarters"', add
label define gq_lbl 5 `"Additional households under 2000 definition"', add
label define gq_lbl 6 `"Fragment"', add
label values gq gq_lbl

label define sex_lbl 1 `"Male"'
label define sex_lbl 2 `"Female"', add
label values sex sex_lbl

label define age_lbl 000 `"Less than 1 year old"'
label define age_lbl 001 `"1"', add
label define age_lbl 002 `"2"', add
label define age_lbl 003 `"3"', add
label define age_lbl 004 `"4"', add
label define age_lbl 005 `"5"', add
label define age_lbl 006 `"6"', add
label define age_lbl 007 `"7"', add
label define age_lbl 008 `"8"', add
label define age_lbl 009 `"9"', add
label define age_lbl 010 `"10"', add
label define age_lbl 011 `"11"', add
label define age_lbl 012 `"12"', add
label define age_lbl 013 `"13"', add
label define age_lbl 014 `"14"', add
label define age_lbl 015 `"15"', add
label define age_lbl 016 `"16"', add
label define age_lbl 017 `"17"', add
label define age_lbl 018 `"18"', add
label define age_lbl 019 `"19"', add
label define age_lbl 020 `"20"', add
label define age_lbl 021 `"21"', add
label define age_lbl 022 `"22"', add
label define age_lbl 023 `"23"', add
label define age_lbl 024 `"24"', add
label define age_lbl 025 `"25"', add
label define age_lbl 026 `"26"', add
label define age_lbl 027 `"27"', add
label define age_lbl 028 `"28"', add
label define age_lbl 029 `"29"', add
label define age_lbl 030 `"30"', add
label define age_lbl 031 `"31"', add
label define age_lbl 032 `"32"', add
label define age_lbl 033 `"33"', add
label define age_lbl 034 `"34"', add
label define age_lbl 035 `"35"', add
label define age_lbl 036 `"36"', add
label define age_lbl 037 `"37"', add
label define age_lbl 038 `"38"', add
label define age_lbl 039 `"39"', add
label define age_lbl 040 `"40"', add
label define age_lbl 041 `"41"', add
label define age_lbl 042 `"42"', add
label define age_lbl 043 `"43"', add
label define age_lbl 044 `"44"', add
label define age_lbl 045 `"45"', add
label define age_lbl 046 `"46"', add
label define age_lbl 047 `"47"', add
label define age_lbl 048 `"48"', add
label define age_lbl 049 `"49"', add
label define age_lbl 050 `"50"', add
label define age_lbl 051 `"51"', add
label define age_lbl 052 `"52"', add
label define age_lbl 053 `"53"', add
label define age_lbl 054 `"54"', add
label define age_lbl 055 `"55"', add
label define age_lbl 056 `"56"', add
label define age_lbl 057 `"57"', add
label define age_lbl 058 `"58"', add
label define age_lbl 059 `"59"', add
label define age_lbl 060 `"60"', add
label define age_lbl 061 `"61"', add
label define age_lbl 062 `"62"', add
label define age_lbl 063 `"63"', add
label define age_lbl 064 `"64"', add
label define age_lbl 065 `"65"', add
label define age_lbl 066 `"66"', add
label define age_lbl 067 `"67"', add
label define age_lbl 068 `"68"', add
label define age_lbl 069 `"69"', add
label define age_lbl 070 `"70"', add
label define age_lbl 071 `"71"', add
label define age_lbl 072 `"72"', add
label define age_lbl 073 `"73"', add
label define age_lbl 074 `"74"', add
label define age_lbl 075 `"75"', add
label define age_lbl 076 `"76"', add
label define age_lbl 077 `"77"', add
label define age_lbl 078 `"78"', add
label define age_lbl 079 `"79"', add
label define age_lbl 080 `"80"', add
label define age_lbl 081 `"81"', add
label define age_lbl 082 `"82"', add
label define age_lbl 083 `"83"', add
label define age_lbl 084 `"84"', add
label define age_lbl 085 `"85"', add
label define age_lbl 086 `"86"', add
label define age_lbl 087 `"87"', add
label define age_lbl 088 `"88"', add
label define age_lbl 089 `"89"', add
label define age_lbl 090 `"90 (90+ in 1980 and 1990)"', add
label define age_lbl 091 `"91"', add
label define age_lbl 092 `"92"', add
label define age_lbl 093 `"93"', add
label define age_lbl 094 `"94"', add
label define age_lbl 095 `"95"', add
label define age_lbl 096 `"96"', add
label define age_lbl 097 `"97"', add
label define age_lbl 098 `"98"', add
label define age_lbl 099 `"99"', add
label define age_lbl 100 `"100 (100+ in 1960-1970)"', add
label define age_lbl 101 `"101"', add
label define age_lbl 102 `"102"', add
label define age_lbl 103 `"103"', add
label define age_lbl 104 `"104"', add
label define age_lbl 105 `"105"', add
label define age_lbl 106 `"106"', add
label define age_lbl 107 `"107"', add
label define age_lbl 108 `"108"', add
label define age_lbl 109 `"109"', add
label define age_lbl 110 `"110"', add
label define age_lbl 111 `"111"', add
label define age_lbl 112 `"112 (112+ in the 1980 internal data)"', add
label define age_lbl 113 `"113"', add
label define age_lbl 114 `"114"', add
label define age_lbl 115 `"115 (115+ in the 1990 internal data)"', add
label define age_lbl 116 `"116"', add
label define age_lbl 117 `"117"', add
label define age_lbl 118 `"118"', add
label define age_lbl 119 `"119"', add
label define age_lbl 120 `"120"', add
label define age_lbl 121 `"121"', add
label define age_lbl 122 `"122"', add
label define age_lbl 123 `"123"', add
label define age_lbl 124 `"124"', add
label define age_lbl 125 `"125"', add
label define age_lbl 126 `"126"', add
label define age_lbl 129 `"129"', add
label define age_lbl 130 `"130"', add
label define age_lbl 135 `"135"', add
label values age age_lbl

label define marst_lbl 1 `"Married, spouse present"'
label define marst_lbl 2 `"Married, spouse absent"', add
label define marst_lbl 3 `"Separated"', add
label define marst_lbl 4 `"Divorced"', add
label define marst_lbl 5 `"Widowed"', add
label define marst_lbl 6 `"Never married/single"', add
label values marst marst_lbl

label define race_lbl 1 `"White"'
label define race_lbl 2 `"Black/Negro"', add
label define race_lbl 3 `"American Indian or Alaska Native"', add
label define race_lbl 4 `"Chinese"', add
label define race_lbl 5 `"Japanese"', add
label define race_lbl 6 `"Other Asian or Pacific Islander"', add
label define race_lbl 7 `"Other race, nec"', add
label define race_lbl 8 `"Two major races"', add
label define race_lbl 9 `"Three or more major races"', add
label values race race_lbl

label define raced_lbl 100 `"White"'
label define raced_lbl 110 `"Spanish write_in"', add
label define raced_lbl 120 `"Blank (white) (1850)"', add
label define raced_lbl 130 `"Portuguese"', add
label define raced_lbl 140 `"Mexican (1930)"', add
label define raced_lbl 150 `"Puerto Rican (1910 Hawaii)"', add
label define raced_lbl 200 `"Black/Negro"', add
label define raced_lbl 210 `"Mulatto"', add
label define raced_lbl 300 `"American Indian/Alaska Native"', add
label define raced_lbl 302 `"Apache"', add
label define raced_lbl 303 `"Blackfoot"', add
label define raced_lbl 304 `"Cherokee"', add
label define raced_lbl 305 `"Cheyenne"', add
label define raced_lbl 306 `"Chickasaw"', add
label define raced_lbl 307 `"Chippewa"', add
label define raced_lbl 308 `"Choctaw"', add
label define raced_lbl 309 `"Comanche"', add
label define raced_lbl 310 `"Creek"', add
label define raced_lbl 311 `"Crow"', add
label define raced_lbl 312 `"Iroquois"', add
label define raced_lbl 313 `"Kiowa"', add
label define raced_lbl 314 `"Lumbee"', add
label define raced_lbl 315 `"Navajo"', add
label define raced_lbl 316 `"Osage"', add
label define raced_lbl 317 `"Paiute"', add
label define raced_lbl 318 `"Pima"', add
label define raced_lbl 319 `"Potawatomi"', add
label define raced_lbl 320 `"Pueblo"', add
label define raced_lbl 321 `"Seminole"', add
label define raced_lbl 322 `"Shoshone"', add
label define raced_lbl 323 `"Sioux"', add
label define raced_lbl 324 `"Tlingit (Tlingit_Haida, 2000/ACS)"', add
label define raced_lbl 325 `"Tohono O Odham"', add
label define raced_lbl 326 `"All other tribes (1990)"', add
label define raced_lbl 328 `"Hopi"', add
label define raced_lbl 329 `"Central American Indian"', add
label define raced_lbl 330 `"Spanish American Indian"', add
label define raced_lbl 350 `"Delaware"', add
label define raced_lbl 351 `"Latin American Indian"', add
label define raced_lbl 352 `"Puget Sound Salish"', add
label define raced_lbl 353 `"Yakama"', add
label define raced_lbl 354 `"Yaqui"', add
label define raced_lbl 355 `"Colville"', add
label define raced_lbl 356 `"Houma"', add
label define raced_lbl 357 `"Menominee"', add
label define raced_lbl 358 `"Yuman"', add
label define raced_lbl 359 `"South American Indian"', add
label define raced_lbl 360 `"Mexican American Indian"', add
label define raced_lbl 361 `"Other Amer. Indian tribe (2000,ACS)"', add
label define raced_lbl 362 `"2+ Amer. Indian tribes (2000,ACS)"', add
label define raced_lbl 370 `"Alaskan Athabaskan"', add
label define raced_lbl 371 `"Aleut"', add
label define raced_lbl 372 `"Eskimo"', add
label define raced_lbl 373 `"Alaskan mixed"', add
label define raced_lbl 374 `"Inupiat"', add
label define raced_lbl 375 `"Yup'ik"', add
label define raced_lbl 379 `"Other Alaska Native tribe(s) (2000,ACS)"', add
label define raced_lbl 398 `"Both Am. Ind. and Alaska Native (2000,ACS)"', add
label define raced_lbl 399 `"Tribe not specified"', add
label define raced_lbl 400 `"Chinese"', add
label define raced_lbl 410 `"Taiwanese"', add
label define raced_lbl 420 `"Chinese and Taiwanese"', add
label define raced_lbl 500 `"Japanese"', add
label define raced_lbl 600 `"Filipino"', add
label define raced_lbl 610 `"Asian Indian (Hindu 1920_1940)"', add
label define raced_lbl 620 `"Korean"', add
label define raced_lbl 630 `"Hawaiian"', add
label define raced_lbl 631 `"Hawaiian and Asian (1900,1920)"', add
label define raced_lbl 632 `"Hawaiian and European (1900,1920)"', add
label define raced_lbl 634 `"Hawaiian mixed"', add
label define raced_lbl 640 `"Vietnamese"', add
label define raced_lbl 641 `"   Bhutanese"', add
label define raced_lbl 642 `"   Mongolian "', add
label define raced_lbl 643 `"   Nepalese"', add
label define raced_lbl 650 `"Other Asian or Pacific Islander (1920,1980)"', add
label define raced_lbl 651 `"Asian only (CPS)"', add
label define raced_lbl 652 `"Pacific Islander only (CPS)"', add
label define raced_lbl 653 `"Asian or Pacific Islander, n.s. (1990 Internal Census files)"', add
label define raced_lbl 660 `"Cambodian"', add
label define raced_lbl 661 `"Hmong"', add
label define raced_lbl 662 `"Laotian"', add
label define raced_lbl 663 `"Thai"', add
label define raced_lbl 664 `"Bangladeshi"', add
label define raced_lbl 665 `"Burmese"', add
label define raced_lbl 666 `"Indonesian"', add
label define raced_lbl 667 `"Malaysian"', add
label define raced_lbl 668 `"Okinawan"', add
label define raced_lbl 669 `"Pakistani"', add
label define raced_lbl 670 `"Sri Lankan"', add
label define raced_lbl 671 `"Other Asian, n.e.c."', add
label define raced_lbl 672 `"Asian, not specified"', add
label define raced_lbl 673 `"Chinese and Japanese"', add
label define raced_lbl 674 `"Chinese and Filipino"', add
label define raced_lbl 675 `"Chinese and Vietnamese"', add
label define raced_lbl 676 `"Chinese and Asian write_in"', add
label define raced_lbl 677 `"Japanese and Filipino"', add
label define raced_lbl 678 `"Asian Indian and Asian write_in"', add
label define raced_lbl 679 `"Other Asian race combinations"', add
label define raced_lbl 680 `"Samoan"', add
label define raced_lbl 681 `"Tahitian"', add
label define raced_lbl 682 `"Tongan"', add
label define raced_lbl 683 `"Other Polynesian (1990)"', add
label define raced_lbl 684 `"1+ other Polynesian races (2000,ACS)"', add
label define raced_lbl 685 `"Guamanian/Chamorro"', add
label define raced_lbl 686 `"Northern Mariana Islander"', add
label define raced_lbl 687 `"Palauan"', add
label define raced_lbl 688 `"Other Micronesian (1990)"', add
label define raced_lbl 689 `"1+ other Micronesian races (2000,ACS)"', add
label define raced_lbl 690 `"Fijian"', add
label define raced_lbl 691 `"Other Melanesian (1990)"', add
label define raced_lbl 692 `"1+ other Melanesian races (2000,ACS)"', add
label define raced_lbl 698 `"2+ PI races from 2+ PI regions"', add
label define raced_lbl 699 `"Pacific Islander, n.s."', add
label define raced_lbl 700 `"Other race, n.e.c."', add
label define raced_lbl 801 `"White and Black"', add
label define raced_lbl 802 `"White and AIAN"', add
label define raced_lbl 810 `"White and Asian"', add
label define raced_lbl 811 `"White and Chinese"', add
label define raced_lbl 812 `"White and Japanese"', add
label define raced_lbl 813 `"White and Filipino"', add
label define raced_lbl 814 `"White and Asian Indian"', add
label define raced_lbl 815 `"White and Korean"', add
label define raced_lbl 816 `"White and Vietnamese"', add
label define raced_lbl 817 `"White and Asian write_in"', add
label define raced_lbl 818 `"White and other Asian race(s)"', add
label define raced_lbl 819 `"White and two or more Asian groups"', add
label define raced_lbl 820 `"White and PI  "', add
label define raced_lbl 821 `"White and Native Hawaiian"', add
label define raced_lbl 822 `"White and Samoan"', add
label define raced_lbl 823 `"White and Guamanian"', add
label define raced_lbl 824 `"White and PI write_in"', add
label define raced_lbl 825 `"White and other PI race(s)"', add
label define raced_lbl 826 `"White and other race write_in"', add
label define raced_lbl 827 `"White and other race, n.e.c."', add
label define raced_lbl 830 `"Black and AIAN"', add
label define raced_lbl 831 `"Black and Asian"', add
label define raced_lbl 832 `"Black and Chinese"', add
label define raced_lbl 833 `"Black and Japanese"', add
label define raced_lbl 834 `"Black and Filipino"', add
label define raced_lbl 835 `"Black and Asian Indian"', add
label define raced_lbl 836 `"Black and Korean"', add
label define raced_lbl 837 `"Black and Asian write_in"', add
label define raced_lbl 838 `"Black and other Asian race(s)"', add
label define raced_lbl 840 `"Black and PI"', add
label define raced_lbl 841 `"Black and PI write_in"', add
label define raced_lbl 842 `"Black and other PI race(s)"', add
label define raced_lbl 845 `"Black and other race write_in"', add
label define raced_lbl 850 `"AIAN and Asian"', add
label define raced_lbl 851 `"AIAN and Filipino (2000 1%)"', add
label define raced_lbl 852 `"AIAN and Asian Indian"', add
label define raced_lbl 853 `"AIAN and Asian write_in (2000 1%)"', add
label define raced_lbl 854 `"AIAN and other Asian race(s)"', add
label define raced_lbl 855 `"AIAN and PI"', add
label define raced_lbl 856 `"AIAN and other race write_in"', add
label define raced_lbl 860 `"Asian and PI"', add
label define raced_lbl 861 `"Chinese and Hawaiian"', add
label define raced_lbl 862 `"Chinese, Filipino, Hawaiian (2000 1%)"', add
label define raced_lbl 863 `"Japanese and Hawaiian (2000 1%)"', add
label define raced_lbl 864 `"Filipino and Hawaiian"', add
label define raced_lbl 865 `"Filipino and PI write_in"', add
label define raced_lbl 866 `"Asian Indian and PI write_in (2000 1%)"', add
label define raced_lbl 867 `"Asian write_in and PI write_in"', add
label define raced_lbl 868 `"Other Asian race(s) and PI race(s)"', add
label define raced_lbl 869 `"Japanese and Korean (ACS)"', add
label define raced_lbl 880 `"Asian and other race write_in"', add
label define raced_lbl 881 `"Chinese and other race write_in"', add
label define raced_lbl 882 `"Japanese and other race write_in"', add
label define raced_lbl 883 `"Filipino and other race write_in"', add
label define raced_lbl 884 `"Asian Indian and other race write_in"', add
label define raced_lbl 885 `"Asian write_in and other race write_in"', add
label define raced_lbl 886 `"Other Asian race(s) and other race write_in"', add
label define raced_lbl 887 `"      Chinese and Korean"', add
label define raced_lbl 890 `"PI and other race write_in: "', add
label define raced_lbl 891 `"PI write_in and other race write_in"', add
label define raced_lbl 892 `"Other PI race(s) and other race write_in"', add
label define raced_lbl 893 `"         Native Hawaiian or PI other race(s)"', add
label define raced_lbl 899 `"API and other race write_in"', add
label define raced_lbl 901 `"White, Black, AIAN"', add
label define raced_lbl 902 `"White, Black, Asian"', add
label define raced_lbl 903 `"White, Black, PI"', add
label define raced_lbl 904 `"White, Black, other race write_in"', add
label define raced_lbl 905 `"White, AIAN, Asian"', add
label define raced_lbl 906 `"White, AIAN, PI"', add
label define raced_lbl 907 `"White, AIAN, other race write_in"', add
label define raced_lbl 910 `"White, Asian, PI "', add
label define raced_lbl 911 `"White, Chinese, Hawaiian"', add
label define raced_lbl 912 `"White, Chinese, Filipino, Hawaiian (2000 1%)"', add
label define raced_lbl 913 `"White, Japanese, Hawaiian (2000 1%)"', add
label define raced_lbl 914 `"White, Filipino, Hawaiian"', add
label define raced_lbl 915 `"Other White, Asian race(s), PI race(s)"', add
label define raced_lbl 916 `"      White, AIAN and Filipino"', add
label define raced_lbl 917 `"      White, Black, and Filipino"', add
label define raced_lbl 920 `"White, Asian, other race write_in"', add
label define raced_lbl 921 `"White, Filipino, other race write_in (2000 1%)"', add
label define raced_lbl 922 `"White, Asian write_in, other race write_in (2000 1%)"', add
label define raced_lbl 923 `"Other White, Asian race(s), other race write_in (2000 1%)"', add
label define raced_lbl 925 `"White, PI, other race write_in"', add
label define raced_lbl 930 `"Black, AIAN, Asian"', add
label define raced_lbl 931 `"Black, AIAN, PI"', add
label define raced_lbl 932 `"Black, AIAN, other race write_in"', add
label define raced_lbl 933 `"Black, Asian, PI"', add
label define raced_lbl 934 `"Black, Asian, other race write_in"', add
label define raced_lbl 935 `"Black, PI, other race write_in"', add
label define raced_lbl 940 `"AIAN, Asian, PI"', add
label define raced_lbl 941 `"AIAN, Asian, other race write_in"', add
label define raced_lbl 942 `"AIAN, PI, other race write_in"', add
label define raced_lbl 943 `"Asian, PI, other race write_in"', add
label define raced_lbl 944 `"Asian (Chinese, Japanese, Korean, Vietnamese); and Native Hawaiian or PI; and Other"', add
label define raced_lbl 949 `"2 or 3 races (CPS)"', add
label define raced_lbl 950 `"White, Black, AIAN, Asian"', add
label define raced_lbl 951 `"White, Black, AIAN, PI"', add
label define raced_lbl 952 `"White, Black, AIAN, other race write_in"', add
label define raced_lbl 953 `"White, Black, Asian, PI"', add
label define raced_lbl 954 `"White, Black, Asian, other race write_in"', add
label define raced_lbl 955 `"White, Black, PI, other race write_in"', add
label define raced_lbl 960 `"White, AIAN, Asian, PI"', add
label define raced_lbl 961 `"White, AIAN, Asian, other race write_in"', add
label define raced_lbl 962 `"White, AIAN, PI, other race write_in"', add
label define raced_lbl 963 `"White, Asian, PI, other race write_in"', add
label define raced_lbl 964 `"White, Chinese, Japanese, Native Hawaiian"', add
label define raced_lbl 970 `"Black, AIAN, Asian, PI"', add
label define raced_lbl 971 `"Black, AIAN, Asian, other race write_in"', add
label define raced_lbl 972 `"Black, AIAN, PI, other race write_in"', add
label define raced_lbl 973 `"Black, Asian, PI, other race write_in"', add
label define raced_lbl 974 `"AIAN, Asian, PI, other race write_in"', add
label define raced_lbl 975 `"AIAN, Asian, PI, Hawaiian other race write_in"', add
label define raced_lbl 976 `"Two specified Asian  (Chinese and other Asian, Chinese and Japanese, Japanese and other Asian, Korean and other Asian); Native Hawaiian/PI; and Other Race"', add
label define raced_lbl 980 `"White, Black, AIAN, Asian, PI"', add
label define raced_lbl 981 `"White, Black, AIAN, Asian, other race write_in"', add
label define raced_lbl 982 `"White, Black, AIAN, PI, other race write_in"', add
label define raced_lbl 983 `"White, Black, Asian, PI, other race write_in"', add
label define raced_lbl 984 `"White, AIAN, Asian, PI, other race write_in"', add
label define raced_lbl 985 `"Black, AIAN, Asian, PI, other race write_in"', add
label define raced_lbl 986 `"Black, AIAN, Asian, PI, Hawaiian, other race write_in"', add
label define raced_lbl 989 `"4 or 5 races (CPS)"', add
label define raced_lbl 990 `"White, Black, AIAN, Asian, PI, other race write_in"', add
label define raced_lbl 991 `"White race; Some other race; Black or African American race and/or American Indian and Alaska Native race and/or Asian groups and/or Native Hawaiian and Other Pacific Islander groups"', add
label define raced_lbl 996 `"2+ races, n.e.c. (CPS)"', add
label values raced raced_lbl

label define racesing_lbl 1 `"White"'
label define racesing_lbl 2 `"Black"', add
label define racesing_lbl 3 `"American Indian/Alaska Native"', add
label define racesing_lbl 4 `"Asian and/or Pacific Islander"', add
label define racesing_lbl 5 `"Other race, non-Hispanic"', add
label values racesing racesing_lbl

label define racesingd_lbl 10 `"White"'
label define racesingd_lbl 12 `""Other race", Hispanic"', add
label define racesingd_lbl 20 `"Black"', add
label define racesingd_lbl 21 `"Mulatto"', add
label define racesingd_lbl 30 `"AI (American Indian)"', add
label define racesingd_lbl 31 `"AN (Alaskan Native)"', add
label define racesingd_lbl 32 `"AI/AN (American Indian/Alaskan Native)"', add
label define racesingd_lbl 40 `"Asian Indian"', add
label define racesingd_lbl 41 `"Chinese"', add
label define racesingd_lbl 42 `"Filipino"', add
label define racesingd_lbl 43 `"Japanese"', add
label define racesingd_lbl 44 `"Korean"', add
label define racesingd_lbl 45 `"Asian  "', add
label define racesingd_lbl 46 `"Hawaiian"', add
label define racesingd_lbl 47 `"PI (Pacific Islander)"', add
label define racesingd_lbl 48 `"Asian and PI (Pacific Islander)"', add
label define racesingd_lbl 50 `"Other race, non-Hispanic"', add
label define racesingd_lbl 51 `"Other race"', add
label values racesingd racesingd_lbl

label define racother_lbl 1 `"No"'
label define racother_lbl 2 `"Yes"', add
label values racother racother_lbl

label define educ_lbl 00 `"N/A or no schooling"'
label define educ_lbl 01 `"Nursery school to grade 4"', add
label define educ_lbl 02 `"Grade 5, 6, 7, or 8"', add
label define educ_lbl 03 `"Grade 9"', add
label define educ_lbl 04 `"Grade 10"', add
label define educ_lbl 05 `"Grade 11"', add
label define educ_lbl 06 `"Grade 12"', add
label define educ_lbl 07 `"1 year of college"', add
label define educ_lbl 08 `"2 years of college"', add
label define educ_lbl 09 `"3 years of college"', add
label define educ_lbl 10 `"4 years of college"', add
label define educ_lbl 11 `"5+ years of college"', add
label values educ educ_lbl

label define educd_lbl 000 `"N/A or no schooling"'
label define educd_lbl 001 `"N/A"', add
label define educd_lbl 002 `"No schooling completed"', add
label define educd_lbl 010 `"Nursery school to grade 4"', add
label define educd_lbl 011 `"Nursery school, preschool"', add
label define educd_lbl 012 `"Kindergarten"', add
label define educd_lbl 013 `"Grade 1, 2, 3, or 4"', add
label define educd_lbl 014 `"Grade 1"', add
label define educd_lbl 015 `"Grade 2"', add
label define educd_lbl 016 `"Grade 3"', add
label define educd_lbl 017 `"Grade 4"', add
label define educd_lbl 020 `"Grade 5, 6, 7, or 8"', add
label define educd_lbl 021 `"Grade 5 or 6"', add
label define educd_lbl 022 `"Grade 5"', add
label define educd_lbl 023 `"Grade 6"', add
label define educd_lbl 024 `"Grade 7 or 8"', add
label define educd_lbl 025 `"Grade 7"', add
label define educd_lbl 026 `"Grade 8"', add
label define educd_lbl 030 `"Grade 9"', add
label define educd_lbl 040 `"Grade 10"', add
label define educd_lbl 050 `"Grade 11"', add
label define educd_lbl 060 `"Grade 12"', add
label define educd_lbl 061 `"12th grade, no diploma"', add
label define educd_lbl 062 `"High school graduate or GED"', add
label define educd_lbl 063 `"Regular high school diploma"', add
label define educd_lbl 064 `"GED or alternative credential"', add
label define educd_lbl 065 `"Some college, but less than 1 year"', add
label define educd_lbl 070 `"1 year of college"', add
label define educd_lbl 071 `"1 or more years of college credit, no degree"', add
label define educd_lbl 080 `"2 years of college"', add
label define educd_lbl 081 `"Associate's degree, type not specified"', add
label define educd_lbl 082 `"Associate's degree, occupational program"', add
label define educd_lbl 083 `"Associate's degree, academic program"', add
label define educd_lbl 090 `"3 years of college"', add
label define educd_lbl 100 `"4 years of college"', add
label define educd_lbl 101 `"Bachelor's degree"', add
label define educd_lbl 110 `"5+ years of college"', add
label define educd_lbl 111 `"6 years of college (6+ in 1960-1970)"', add
label define educd_lbl 112 `"7 years of college"', add
label define educd_lbl 113 `"8+ years of college"', add
label define educd_lbl 114 `"Master's degree"', add
label define educd_lbl 115 `"Professional degree beyond a bachelor's degree"', add
label define educd_lbl 116 `"Doctoral degree"', add
label define educd_lbl 999 `"Missing"', add
label values educd educd_lbl

label define degfield_lbl 00 `"N/A"'
label define degfield_lbl 11 `"Agriculture"', add
label define degfield_lbl 13 `"Environment and Natural Resources"', add
label define degfield_lbl 14 `"Architecture"', add
label define degfield_lbl 15 `"Area, Ethnic, and Civilization Studies"', add
label define degfield_lbl 19 `"Communications"', add
label define degfield_lbl 20 `"Communication Technologies"', add
label define degfield_lbl 21 `"Computer and Information Sciences"', add
label define degfield_lbl 22 `"Cosmetology Services and Culinary Arts"', add
label define degfield_lbl 23 `"Education Administration and Teaching"', add
label define degfield_lbl 24 `"Engineering"', add
label define degfield_lbl 25 `"Engineering Technologies"', add
label define degfield_lbl 26 `"Linguistics and Foreign Languages"', add
label define degfield_lbl 29 `"Family and Consumer Sciences"', add
label define degfield_lbl 32 `"Law"', add
label define degfield_lbl 33 `"English Language, Literature, and Composition"', add
label define degfield_lbl 34 `"Liberal Arts and Humanities"', add
label define degfield_lbl 35 `"Library Science"', add
label define degfield_lbl 36 `"Biology and Life Sciences"', add
label define degfield_lbl 37 `"Mathematics and Statistics"', add
label define degfield_lbl 38 `"Military Technologies"', add
label define degfield_lbl 40 `"Interdisciplinary and Multi-Disciplinary Studies (General)"', add
label define degfield_lbl 41 `"Physical Fitness, Parks, Recreation, and Leisure"', add
label define degfield_lbl 48 `"Philosophy and Religious Studies"', add
label define degfield_lbl 49 `"Theology and Religious Vocations"', add
label define degfield_lbl 50 `"Physical Sciences"', add
label define degfield_lbl 51 `"Nuclear, Industrial Radiology, and Biological Technologies"', add
label define degfield_lbl 52 `"Psychology"', add
label define degfield_lbl 53 `"Criminal Justice and Fire Protection"', add
label define degfield_lbl 54 `"Public Affairs, Policy, and Social Work"', add
label define degfield_lbl 55 `"Social Sciences"', add
label define degfield_lbl 56 `"Construction Services"', add
label define degfield_lbl 57 `"Electrical and Mechanic Repairs and Technologies"', add
label define degfield_lbl 58 `"Precision Production and Industrial Arts"', add
label define degfield_lbl 59 `"Transportation Sciences and Technologies"', add
label define degfield_lbl 60 `"Fine Arts"', add
label define degfield_lbl 61 `"Medical and Health Sciences and Services"', add
label define degfield_lbl 62 `"Business"', add
label define degfield_lbl 64 `"History"', add
label values degfield degfield_lbl

label define degfieldd_lbl 0000 `"N/A"'
label define degfieldd_lbl 1100 `"General Agriculture"', add
label define degfieldd_lbl 1101 `"Agriculture Production and Management"', add
label define degfieldd_lbl 1102 `"Agricultural Economics"', add
label define degfieldd_lbl 1103 `"Animal Sciences"', add
label define degfieldd_lbl 1104 `"Food Science"', add
label define degfieldd_lbl 1105 `"Plant Science and Agronomy"', add
label define degfieldd_lbl 1106 `"Soil Science"', add
label define degfieldd_lbl 1199 `"Miscellaneous Agriculture"', add
label define degfieldd_lbl 1300 `"Environment and Natural Resources"', add
label define degfieldd_lbl 1301 `"Environmental Science"', add
label define degfieldd_lbl 1302 `"Forestry"', add
label define degfieldd_lbl 1303 `"Natural Resources Management"', add
label define degfieldd_lbl 1401 `"Architecture"', add
label define degfieldd_lbl 1501 `"Area, Ethnic, and Civilization Studies"', add
label define degfieldd_lbl 1900 `"Communications"', add
label define degfieldd_lbl 1901 `"Communications"', add
label define degfieldd_lbl 1902 `"Journalism"', add
label define degfieldd_lbl 1903 `"Mass Media"', add
label define degfieldd_lbl 1904 `"Advertising and Public Relations"', add
label define degfieldd_lbl 2001 `"Communication Technologies"', add
label define degfieldd_lbl 2100 `"Computer and Information Systems"', add
label define degfieldd_lbl 2101 `"Computer Programming and Data Processing"', add
label define degfieldd_lbl 2102 `"Computer Science"', add
label define degfieldd_lbl 2105 `"Information Sciences"', add
label define degfieldd_lbl 2106 `"Computer Information Management and Security"', add
label define degfieldd_lbl 2107 `"Computer Networking and Telecommunications"', add
label define degfieldd_lbl 2201 `"Cosmetology Services and Culinary Arts"', add
label define degfieldd_lbl 2300 `"General Education"', add
label define degfieldd_lbl 2301 `"Educational Administration and Supervision"', add
label define degfieldd_lbl 2303 `"School Student Counseling"', add
label define degfieldd_lbl 2304 `"Elementary Education"', add
label define degfieldd_lbl 2305 `"Mathematics Teacher Education"', add
label define degfieldd_lbl 2306 `"Physical and Health Education Teaching"', add
label define degfieldd_lbl 2307 `"Early Childhood Education"', add
label define degfieldd_lbl 2308 `"Science  and Computer Teacher Education"', add
label define degfieldd_lbl 2309 `"Secondary Teacher Education"', add
label define degfieldd_lbl 2310 `"Special Needs Education"', add
label define degfieldd_lbl 2311 `"Social Science or History Teacher Education"', add
label define degfieldd_lbl 2312 `"Teacher Education:  Multiple Levels"', add
label define degfieldd_lbl 2313 `"Language and Drama Education"', add
label define degfieldd_lbl 2314 `"Art and Music Education"', add
label define degfieldd_lbl 2399 `"Miscellaneous Education"', add
label define degfieldd_lbl 2400 `"General Engineering"', add
label define degfieldd_lbl 2401 `"Aerospace Engineering"', add
label define degfieldd_lbl 2402 `"Biological Engineering"', add
label define degfieldd_lbl 2403 `"Architectural Engineering"', add
label define degfieldd_lbl 2404 `"Biomedical Engineering"', add
label define degfieldd_lbl 2405 `"Chemical Engineering"', add
label define degfieldd_lbl 2406 `"Civil Engineering"', add
label define degfieldd_lbl 2407 `"Computer Engineering"', add
label define degfieldd_lbl 2408 `"Electrical Engineering"', add
label define degfieldd_lbl 2409 `"Engineering Mechanics, Physics, and Science"', add
label define degfieldd_lbl 2410 `"Environmental Engineering"', add
label define degfieldd_lbl 2411 `"Geological and Geophysical Engineering"', add
label define degfieldd_lbl 2412 `"Industrial and Manufacturing Engineering"', add
label define degfieldd_lbl 2413 `"Materials Engineering and Materials Science"', add
label define degfieldd_lbl 2414 `"Mechanical Engineering"', add
label define degfieldd_lbl 2415 `"Metallurgical Engineering"', add
label define degfieldd_lbl 2416 `"Mining and Mineral Engineering"', add
label define degfieldd_lbl 2417 `"Naval Architecture and Marine Engineering"', add
label define degfieldd_lbl 2418 `"Nuclear Engineering"', add
label define degfieldd_lbl 2419 `"Petroleum Engineering"', add
label define degfieldd_lbl 2499 `"Miscellaneous Engineering"', add
label define degfieldd_lbl 2500 `"Engineering Technologies"', add
label define degfieldd_lbl 2501 `"Engineering and Industrial Management"', add
label define degfieldd_lbl 2502 `"Electrical Engineering Technology"', add
label define degfieldd_lbl 2503 `"Industrial Production Technologies"', add
label define degfieldd_lbl 2504 `"Mechanical Engineering Related Technologies"', add
label define degfieldd_lbl 2599 `"Miscellaneous Engineering Technologies"', add
label define degfieldd_lbl 2600 `"Linguistics and Foreign Languages"', add
label define degfieldd_lbl 2601 `"Linguistics and Comparative Language and Literature"', add
label define degfieldd_lbl 2602 `"French, German, Latin and Other Common Foreign Language Studies"', add
label define degfieldd_lbl 2603 `"Other Foreign Languages"', add
label define degfieldd_lbl 2901 `"Family and Consumer Sciences"', add
label define degfieldd_lbl 3200 `"Law"', add
label define degfieldd_lbl 3201 `"Court Reporting"', add
label define degfieldd_lbl 3202 `"Pre-Law and Legal Studies"', add
label define degfieldd_lbl 3300 `"English Language, Literature, and Composition"', add
label define degfieldd_lbl 3301 `"English Language and Literature"', add
label define degfieldd_lbl 3302 `"Composition and Speech"', add
label define degfieldd_lbl 3400 `"Liberal Arts and Humanities"', add
label define degfieldd_lbl 3401 `"Liberal Arts"', add
label define degfieldd_lbl 3402 `"Humanities"', add
label define degfieldd_lbl 3501 `"Library Science"', add
label define degfieldd_lbl 3600 `"Biology"', add
label define degfieldd_lbl 3601 `"Biochemical Sciences"', add
label define degfieldd_lbl 3602 `"Botany"', add
label define degfieldd_lbl 3603 `"Molecular Biology"', add
label define degfieldd_lbl 3604 `"Ecology"', add
label define degfieldd_lbl 3605 `"Genetics"', add
label define degfieldd_lbl 3606 `"Microbiology"', add
label define degfieldd_lbl 3607 `"Pharmacology"', add
label define degfieldd_lbl 3608 `"Physiology"', add
label define degfieldd_lbl 3609 `"Zoology"', add
label define degfieldd_lbl 3611 `"Neuroscience"', add
label define degfieldd_lbl 3699 `"Miscellaneous Biology"', add
label define degfieldd_lbl 3700 `"Mathematics"', add
label define degfieldd_lbl 3701 `"Applied Mathematics"', add
label define degfieldd_lbl 3702 `"Statistics and Decision Science"', add
label define degfieldd_lbl 3801 `"Military Technologies"', add
label define degfieldd_lbl 4000 `"Interdisciplinary and Multi-Disciplinary Studies (General)"', add
label define degfieldd_lbl 4001 `"Intercultural and International Studies"', add
label define degfieldd_lbl 4002 `"Nutrition Sciences"', add
label define degfieldd_lbl 4003 `"Neuroscience"', add
label define degfieldd_lbl 4005 `"Mathematics and Computer Science"', add
label define degfieldd_lbl 4006 `"Cognitive Science and Biopsychology"', add
label define degfieldd_lbl 4007 `"Interdisciplinary Social Sciences"', add
label define degfieldd_lbl 4008 `"Multi-disciplinary or General Science"', add
label define degfieldd_lbl 4101 `"Physical Fitness, Parks, Recreation, and Leisure"', add
label define degfieldd_lbl 4801 `"Philosophy and Religious Studies"', add
label define degfieldd_lbl 4901 `"Theology and Religious Vocations"', add
label define degfieldd_lbl 5000 `"Physical Sciences"', add
label define degfieldd_lbl 5001 `"Astronomy and Astrophysics"', add
label define degfieldd_lbl 5002 `"Atmospheric Sciences and Meteorology"', add
label define degfieldd_lbl 5003 `"Chemistry"', add
label define degfieldd_lbl 5004 `"Geology and Earth Science"', add
label define degfieldd_lbl 5005 `"Geosciences"', add
label define degfieldd_lbl 5006 `"Oceanography"', add
label define degfieldd_lbl 5007 `"Physics"', add
label define degfieldd_lbl 5008 `"Materials Science"', add
label define degfieldd_lbl 5098 `"Multi-disciplinary or General Science"', add
label define degfieldd_lbl 5102 `"Nuclear, Industrial Radiology, and Biological Technologies"', add
label define degfieldd_lbl 5200 `"Psychology"', add
label define degfieldd_lbl 5201 `"Educational Psychology"', add
label define degfieldd_lbl 5202 `"Clinical Psychology"', add
label define degfieldd_lbl 5203 `"Counseling Psychology"', add
label define degfieldd_lbl 5205 `"Industrial and Organizational Psychology"', add
label define degfieldd_lbl 5206 `"Social Psychology"', add
label define degfieldd_lbl 5299 `"Miscellaneous Psychology"', add
label define degfieldd_lbl 5301 `"Criminal Justice and Fire Protection"', add
label define degfieldd_lbl 5400 `"Public Affairs, Policy, and Social Work"', add
label define degfieldd_lbl 5401 `"Public Administration"', add
label define degfieldd_lbl 5402 `"Public Policy"', add
label define degfieldd_lbl 5403 `"Human Services and Community Organization"', add
label define degfieldd_lbl 5404 `"Social Work"', add
label define degfieldd_lbl 5500 `"General Social Sciences"', add
label define degfieldd_lbl 5501 `"Economics"', add
label define degfieldd_lbl 5502 `"Anthropology and Archeology"', add
label define degfieldd_lbl 5503 `"Criminology"', add
label define degfieldd_lbl 5504 `"Geography"', add
label define degfieldd_lbl 5505 `"International Relations"', add
label define degfieldd_lbl 5506 `"Political Science and Government"', add
label define degfieldd_lbl 5507 `"Sociology"', add
label define degfieldd_lbl 5599 `"Miscellaneous Social Sciences"', add
label define degfieldd_lbl 5601 `"Construction Services"', add
label define degfieldd_lbl 5701 `"Electrical and Mechanic Repairs and Technologies"', add
label define degfieldd_lbl 5801 `"Precision Production and Industrial Arts"', add
label define degfieldd_lbl 5901 `"Transportation Sciences and Technologies"', add
label define degfieldd_lbl 6000 `"Fine Arts"', add
label define degfieldd_lbl 6001 `"Drama and Theater Arts"', add
label define degfieldd_lbl 6002 `"Music"', add
label define degfieldd_lbl 6003 `"Visual and Performing Arts"', add
label define degfieldd_lbl 6004 `"Commercial Art and Graphic Design"', add
label define degfieldd_lbl 6005 `"Film, Video and Photographic Arts"', add
label define degfieldd_lbl 6006 `"Art History and Criticism"', add
label define degfieldd_lbl 6007 `"Studio Arts"', add
label define degfieldd_lbl 6099 `"Miscellaneous Fine Arts"', add
label define degfieldd_lbl 6100 `"General Medical and Health Services"', add
label define degfieldd_lbl 6102 `"Communication Disorders Sciences and Services"', add
label define degfieldd_lbl 6103 `"Health and Medical Administrative Services"', add
label define degfieldd_lbl 6104 `"Medical Assisting Services"', add
label define degfieldd_lbl 6105 `"Medical Technologies Technicians"', add
label define degfieldd_lbl 6106 `"Health and Medical Preparatory Programs"', add
label define degfieldd_lbl 6107 `"Nursing"', add
label define degfieldd_lbl 6108 `"Pharmacy, Pharmaceutical Sciences, and Administration"', add
label define degfieldd_lbl 6109 `"Treatment Therapy Professions"', add
label define degfieldd_lbl 6110 `"Community and Public Health"', add
label define degfieldd_lbl 6199 `"Miscellaneous Health Medical Professions"', add
label define degfieldd_lbl 6200 `"General Business"', add
label define degfieldd_lbl 6201 `"Accounting"', add
label define degfieldd_lbl 6202 `"Actuarial Science"', add
label define degfieldd_lbl 6203 `"Business Management and Administration"', add
label define degfieldd_lbl 6204 `"Operations, Logistics and E-Commerce"', add
label define degfieldd_lbl 6205 `"Business Economics"', add
label define degfieldd_lbl 6206 `"Marketing and Marketing Research"', add
label define degfieldd_lbl 6207 `"Finance"', add
label define degfieldd_lbl 6209 `"Human Resources and Personnel Management"', add
label define degfieldd_lbl 6210 `"International Business"', add
label define degfieldd_lbl 6211 `"Hospitality Management"', add
label define degfieldd_lbl 6212 `"Management Information Systems and Statistics"', add
label define degfieldd_lbl 6299 `"Miscellaneous Business and Medical Administration"', add
label define degfieldd_lbl 6402 `"History"', add
label define degfieldd_lbl 6403 `"United States History"', add
label values degfieldd degfieldd_lbl

label define degfield2_lbl 00 `"N/A"'
label define degfield2_lbl 11 `"Agriculture"', add
label define degfield2_lbl 13 `"Environment and Natural Resources"', add
label define degfield2_lbl 14 `"Architecture"', add
label define degfield2_lbl 15 `"Area, Ethnic, and Civilization Studies"', add
label define degfield2_lbl 19 `"Communications"', add
label define degfield2_lbl 20 `"Communication Technologies"', add
label define degfield2_lbl 21 `"Computer and Information Sciences"', add
label define degfield2_lbl 22 `"Cosmetology Services and Culinary Arts"', add
label define degfield2_lbl 23 `"Education Administration and Teaching"', add
label define degfield2_lbl 24 `"Engineering"', add
label define degfield2_lbl 25 `"Engineering Technologies"', add
label define degfield2_lbl 26 `"Linguistics and Foreign Languages"', add
label define degfield2_lbl 29 `"Family and Consumer Sciences"', add
label define degfield2_lbl 32 `"Law"', add
label define degfield2_lbl 33 `"English Language, Literature, and Composition"', add
label define degfield2_lbl 34 `"Liberal Arts and Humanities"', add
label define degfield2_lbl 35 `"Library Science"', add
label define degfield2_lbl 36 `"Biology and Life Sciences"', add
label define degfield2_lbl 37 `"Mathematics and Statistics"', add
label define degfield2_lbl 38 `"Military Technologies"', add
label define degfield2_lbl 40 `"Interdisciplinary and Multi-Disciplinary Studies (General)"', add
label define degfield2_lbl 41 `"Physical Fitness, Parks, Recreation, and Leisure"', add
label define degfield2_lbl 48 `"Philosophy and Religious Studies"', add
label define degfield2_lbl 49 `"Theology and Religious Vocations"', add
label define degfield2_lbl 50 `"Physical Sciences"', add
label define degfield2_lbl 51 `"Nuclear, Industrial Radiology, and Biological Technologies"', add
label define degfield2_lbl 52 `"Psychology"', add
label define degfield2_lbl 53 `"Criminal Justice and Fire Protection"', add
label define degfield2_lbl 54 `"Public Affairs, Policy, and Social Work"', add
label define degfield2_lbl 55 `"Social Sciences"', add
label define degfield2_lbl 56 `"Construction Services"', add
label define degfield2_lbl 57 `"Electrical and Mechanic Repairs and Technologies"', add
label define degfield2_lbl 58 `"Precision Production and Industrial Arts"', add
label define degfield2_lbl 59 `"Transportation Sciences and Technologies"', add
label define degfield2_lbl 60 `"Fine Arts"', add
label define degfield2_lbl 61 `"Medical and Health Sciences and Services"', add
label define degfield2_lbl 62 `"Business"', add
label define degfield2_lbl 64 `"History"', add
label values degfield2 degfield2_lbl

label define degfield2d_lbl 0000 `"N/A"'
label define degfield2d_lbl 1100 `"General Agriculture"', add
label define degfield2d_lbl 1101 `"Agriculture Production and Management"', add
label define degfield2d_lbl 1102 `"Agricultural Economics"', add
label define degfield2d_lbl 1103 `"Animal Sciences"', add
label define degfield2d_lbl 1104 `"Food Science"', add
label define degfield2d_lbl 1105 `"Plant Science and Agronomy"', add
label define degfield2d_lbl 1106 `"Soil Science"', add
label define degfield2d_lbl 1199 `"Miscellaneous Agriculture"', add
label define degfield2d_lbl 1300 `"Environment and Natural Resources"', add
label define degfield2d_lbl 1301 `"Environmental Science"', add
label define degfield2d_lbl 1302 `"Forestry"', add
label define degfield2d_lbl 1303 `"Natural Resources Management"', add
label define degfield2d_lbl 1401 `"Architecture"', add
label define degfield2d_lbl 1501 `"Area, Ethnic, and Civilization Studies"', add
label define degfield2d_lbl 1900 `"Communications"', add
label define degfield2d_lbl 1901 `"Communications"', add
label define degfield2d_lbl 1902 `"Journalism"', add
label define degfield2d_lbl 1903 `"Mass Media"', add
label define degfield2d_lbl 1904 `"Advertising and Public Relations"', add
label define degfield2d_lbl 2001 `"Communication Technologies"', add
label define degfield2d_lbl 2100 `"Computer and Information Systems"', add
label define degfield2d_lbl 2101 `"Computer Programming and Data Processing"', add
label define degfield2d_lbl 2102 `"Computer Science"', add
label define degfield2d_lbl 2105 `"Information Sciences"', add
label define degfield2d_lbl 2106 `"Computer Information Management and Security"', add
label define degfield2d_lbl 2107 `"Computer Networking and Telecommunications"', add
label define degfield2d_lbl 2201 `"Cosmetology Services and Culinary Arts"', add
label define degfield2d_lbl 2300 `"General Education"', add
label define degfield2d_lbl 2301 `"Educational Administration and Supervision"', add
label define degfield2d_lbl 2303 `"School Student Counseling"', add
label define degfield2d_lbl 2304 `"Elementary Education"', add
label define degfield2d_lbl 2305 `"Mathematics Teacher Education"', add
label define degfield2d_lbl 2306 `"Physical and Health Education Teaching"', add
label define degfield2d_lbl 2307 `"Early Childhood Education"', add
label define degfield2d_lbl 2308 `"Science  and Computer Teacher Education"', add
label define degfield2d_lbl 2309 `"Secondary Teacher Education"', add
label define degfield2d_lbl 2310 `"Special Needs Education"', add
label define degfield2d_lbl 2311 `"Social Science or History Teacher Education"', add
label define degfield2d_lbl 2312 `"Teacher Education:  Multiple Levels"', add
label define degfield2d_lbl 2313 `"Language and Drama Education"', add
label define degfield2d_lbl 2314 `"Art and Music Education"', add
label define degfield2d_lbl 2399 `"Miscellaneous Education"', add
label define degfield2d_lbl 2400 `"General Engineering"', add
label define degfield2d_lbl 2401 `"Aerospace Engineering"', add
label define degfield2d_lbl 2402 `"Biological Engineering"', add
label define degfield2d_lbl 2403 `"Architectural Engineering"', add
label define degfield2d_lbl 2404 `"Biomedical Engineering"', add
label define degfield2d_lbl 2405 `"Chemical Engineering"', add
label define degfield2d_lbl 2406 `"Civil Engineering"', add
label define degfield2d_lbl 2407 `"Computer Engineering"', add
label define degfield2d_lbl 2408 `"Electrical Engineering"', add
label define degfield2d_lbl 2409 `"Engineering Mechanics, Physics, and Science"', add
label define degfield2d_lbl 2410 `"Environmental Engineering"', add
label define degfield2d_lbl 2411 `"Geological and Geophysical Engineering"', add
label define degfield2d_lbl 2412 `"Industrial and Manufacturing Engineering"', add
label define degfield2d_lbl 2413 `"Materials Engineering and Materials Science"', add
label define degfield2d_lbl 2414 `"Mechanical Engineering"', add
label define degfield2d_lbl 2415 `"Metallurgical Engineering"', add
label define degfield2d_lbl 2416 `"Mining and Mineral Engineering"', add
label define degfield2d_lbl 2417 `"Naval Architecture and Marine Engineering"', add
label define degfield2d_lbl 2418 `"Nuclear Engineering"', add
label define degfield2d_lbl 2419 `"Petroleum Engineering"', add
label define degfield2d_lbl 2499 `"Miscellaneous Engineering"', add
label define degfield2d_lbl 2500 `"Engineering Technologies"', add
label define degfield2d_lbl 2501 `"Engineering and Industrial Management"', add
label define degfield2d_lbl 2502 `"Electrical Engineering Technology"', add
label define degfield2d_lbl 2503 `"Industrial Production Technologies"', add
label define degfield2d_lbl 2504 `"Mechanical Engineering Related Technologies"', add
label define degfield2d_lbl 2599 `"Miscellaneous Engineering Technologies"', add
label define degfield2d_lbl 2600 `"Linguistics and Foreign Languages"', add
label define degfield2d_lbl 2601 `"Linguistics and Comparative Language and Literature"', add
label define degfield2d_lbl 2602 `"French, German, Latin and Other Common Foreign Language Studies"', add
label define degfield2d_lbl 2603 `"Other Foreign Languages"', add
label define degfield2d_lbl 2901 `"Family and Consumer Sciences"', add
label define degfield2d_lbl 3200 `"Law"', add
label define degfield2d_lbl 3201 `"Court Reporting"', add
label define degfield2d_lbl 3202 `"Pre-Law and Legal Studies"', add
label define degfield2d_lbl 3300 `"English Language, Literature, and Composition"', add
label define degfield2d_lbl 3301 `"English Language and Literature"', add
label define degfield2d_lbl 3302 `"Composition and Speech"', add
label define degfield2d_lbl 3400 `"Liberal Arts and Humanities"', add
label define degfield2d_lbl 3401 `"Liberal Arts"', add
label define degfield2d_lbl 3402 `"Humanities"', add
label define degfield2d_lbl 3501 `"Library Science"', add
label define degfield2d_lbl 3600 `"Biology"', add
label define degfield2d_lbl 3601 `"Biochemical Sciences"', add
label define degfield2d_lbl 3602 `"Botany"', add
label define degfield2d_lbl 3603 `"Molecular Biology"', add
label define degfield2d_lbl 3604 `"Ecology"', add
label define degfield2d_lbl 3605 `"Genetics"', add
label define degfield2d_lbl 3606 `"Microbiology"', add
label define degfield2d_lbl 3607 `"Pharmacology"', add
label define degfield2d_lbl 3608 `"Physiology"', add
label define degfield2d_lbl 3609 `"Zoology"', add
label define degfield2d_lbl 3611 `"Neuroscience"', add
label define degfield2d_lbl 3699 `"Miscellaneous Biology"', add
label define degfield2d_lbl 3700 `"Mathematics"', add
label define degfield2d_lbl 3701 `"Applied Mathematics"', add
label define degfield2d_lbl 3702 `"Statistics and Decision Science"', add
label define degfield2d_lbl 3801 `"Military Technologies"', add
label define degfield2d_lbl 4000 `"Interdisciplinary and Multi-Disciplinary Studies (General)"', add
label define degfield2d_lbl 4001 `"Intercultural and International Studies"', add
label define degfield2d_lbl 4002 `"Nutrition Sciences"', add
label define degfield2d_lbl 4003 `"Neuroscience"', add
label define degfield2d_lbl 4004 `"Accounting and Computer Science"', add
label define degfield2d_lbl 4005 `"Mathematics and Computer Science"', add
label define degfield2d_lbl 4006 `"Cognitive Science and Biopsychology"', add
label define degfield2d_lbl 4007 `"Interdisciplinary Social Sciences"', add
label define degfield2d_lbl 4008 `"Multi-disciplinary or General Science"', add
label define degfield2d_lbl 4101 `"Physical Fitness, Parks, Recreation, and Leisure"', add
label define degfield2d_lbl 4801 `"Philosophy and Religious Studies"', add
label define degfield2d_lbl 4901 `"Theology and Religious Vocations"', add
label define degfield2d_lbl 5000 `"Physical Sciences"', add
label define degfield2d_lbl 5001 `"Astronomy and Astrophysics"', add
label define degfield2d_lbl 5002 `"Atmospheric Sciences and Meteorology"', add
label define degfield2d_lbl 5003 `"Chemistry"', add
label define degfield2d_lbl 5004 `"Geology and Earth Science"', add
label define degfield2d_lbl 5005 `"Geosciences"', add
label define degfield2d_lbl 5006 `"Oceanography"', add
label define degfield2d_lbl 5007 `"Physics"', add
label define degfield2d_lbl 5008 `"Materials Science"', add
label define degfield2d_lbl 5098 `"Multi-disciplinary or General Science"', add
label define degfield2d_lbl 5102 `"Nuclear, Industrial Radiology, and Biological Technologies"', add
label define degfield2d_lbl 5200 `"Psychology"', add
label define degfield2d_lbl 5201 `"Educational Psychology"', add
label define degfield2d_lbl 5202 `"Clinical Psychology"', add
label define degfield2d_lbl 5203 `"Counseling Psychology"', add
label define degfield2d_lbl 5205 `"Industrial and Organizational Psychology"', add
label define degfield2d_lbl 5206 `"Social Psychology"', add
label define degfield2d_lbl 5299 `"Miscellaneous Psychology"', add
label define degfield2d_lbl 5301 `"Criminal Justice and Fire Protection"', add
label define degfield2d_lbl 5400 `"Public Affairs, Policy, and Social Work"', add
label define degfield2d_lbl 5401 `"Public Administration"', add
label define degfield2d_lbl 5402 `"Public Policy"', add
label define degfield2d_lbl 5403 `"Human Services and Community Organization"', add
label define degfield2d_lbl 5404 `"Social Work"', add
label define degfield2d_lbl 5500 `"General Social Sciences"', add
label define degfield2d_lbl 5501 `"Economics"', add
label define degfield2d_lbl 5502 `"Anthropology and Archeology"', add
label define degfield2d_lbl 5503 `"Criminology"', add
label define degfield2d_lbl 5504 `"Geography"', add
label define degfield2d_lbl 5505 `"International Relations"', add
label define degfield2d_lbl 5506 `"Political Science and Government"', add
label define degfield2d_lbl 5507 `"Sociology"', add
label define degfield2d_lbl 5599 `"Miscellaneous Social Sciences"', add
label define degfield2d_lbl 5601 `"Construction Services"', add
label define degfield2d_lbl 5701 `"Electrical and Mechanic Repairs and Technologies"', add
label define degfield2d_lbl 5801 `"Precision Production and Industrial Arts"', add
label define degfield2d_lbl 5901 `"Transportation Sciences and Technologies"', add
label define degfield2d_lbl 6000 `"Fine Arts"', add
label define degfield2d_lbl 6001 `"Drama and Theater Arts"', add
label define degfield2d_lbl 6002 `"Music"', add
label define degfield2d_lbl 6003 `"Visual and Performing Arts"', add
label define degfield2d_lbl 6004 `"Commercial Art and Graphic Design"', add
label define degfield2d_lbl 6005 `"Film, Video and Photographic Arts"', add
label define degfield2d_lbl 6006 `"Art History and Criticism"', add
label define degfield2d_lbl 6007 `"Studio Arts"', add
label define degfield2d_lbl 6008 `"Video Game Design and Development"', add
label define degfield2d_lbl 6099 `"Miscellaneous Fine Arts"', add
label define degfield2d_lbl 6100 `"General Medical and Health Services"', add
label define degfield2d_lbl 6102 `"Communication Disorders Sciences and Services"', add
label define degfield2d_lbl 6103 `"Health and Medical Administrative Services"', add
label define degfield2d_lbl 6104 `"Medical Assisting Services"', add
label define degfield2d_lbl 6105 `"Medical Technologies Technicians"', add
label define degfield2d_lbl 6106 `"Health and Medical Preparatory Programs"', add
label define degfield2d_lbl 6107 `"Nursing"', add
label define degfield2d_lbl 6108 `"Pharmacy, Pharmaceutical Sciences, and Administration"', add
label define degfield2d_lbl 6109 `"Treatment Therapy Professions"', add
label define degfield2d_lbl 6110 `"Community and Public Health"', add
label define degfield2d_lbl 6199 `"Miscellaneous Health Medical Professions"', add
label define degfield2d_lbl 6200 `"General Business"', add
label define degfield2d_lbl 6201 `"Accounting"', add
label define degfield2d_lbl 6202 `"Actuarial Science"', add
label define degfield2d_lbl 6203 `"Business Management and Administration"', add
label define degfield2d_lbl 6204 `"Operations, Logistics and E-Commerce"', add
label define degfield2d_lbl 6205 `"Business Economics"', add
label define degfield2d_lbl 6206 `"Marketing and Marketing Research"', add
label define degfield2d_lbl 6207 `"Finance"', add
label define degfield2d_lbl 6209 `"Human Resources and Personnel Management"', add
label define degfield2d_lbl 6210 `"International Business"', add
label define degfield2d_lbl 6211 `"Hospitality Management"', add
label define degfield2d_lbl 6212 `"Management Information Systems and Statistics"', add
label define degfield2d_lbl 6299 `"Miscellaneous Business and Medical Administration"', add
label define degfield2d_lbl 6402 `"History"', add
label define degfield2d_lbl 6403 `"United States History"', add
label values degfield2d degfield2d_lbl

label define empstat_lbl 0 `"N/A"'
label define empstat_lbl 1 `"Employed"', add
label define empstat_lbl 2 `"Unemployed"', add
label define empstat_lbl 3 `"Not in labor force"', add
label values empstat empstat_lbl

label define empstatd_lbl 00 `"N/A"'
label define empstatd_lbl 10 `"At work"', add
label define empstatd_lbl 11 `"At work, public emerg"', add
label define empstatd_lbl 12 `"Has job, not working"', add
label define empstatd_lbl 13 `"Armed forces"', add
label define empstatd_lbl 14 `"Armed forces--at work"', add
label define empstatd_lbl 15 `"Armed forces--not at work but with job"', add
label define empstatd_lbl 20 `"Unemployed"', add
label define empstatd_lbl 21 `"Unemp, exper worker"', add
label define empstatd_lbl 22 `"Unemp, new worker"', add
label define empstatd_lbl 30 `"Not in Labor Force"', add
label define empstatd_lbl 31 `"NILF, housework"', add
label define empstatd_lbl 32 `"NILF, unable to work"', add
label define empstatd_lbl 33 `"NILF, school"', add
label define empstatd_lbl 34 `"NILF, other"', add
label values empstatd empstatd_lbl

label define wkswork2_lbl 0 `"N/A"'
label define wkswork2_lbl 1 `"1-13 weeks"', add
label define wkswork2_lbl 2 `"14-26 weeks"', add
label define wkswork2_lbl 3 `"27-39 weeks"', add
label define wkswork2_lbl 4 `"40-47 weeks"', add
label define wkswork2_lbl 5 `"48-49 weeks"', add
label define wkswork2_lbl 6 `"50-52 weeks"', add
label values wkswork2 wkswork2_lbl

label define uhrswork_lbl 00 `"N/A"'
label define uhrswork_lbl 01 `"1"', add
label define uhrswork_lbl 02 `"2"', add
label define uhrswork_lbl 03 `"3"', add
label define uhrswork_lbl 04 `"4"', add
label define uhrswork_lbl 05 `"5"', add
label define uhrswork_lbl 06 `"6"', add
label define uhrswork_lbl 07 `"7"', add
label define uhrswork_lbl 08 `"8"', add
label define uhrswork_lbl 09 `"9"', add
label define uhrswork_lbl 10 `"10"', add
label define uhrswork_lbl 11 `"11"', add
label define uhrswork_lbl 12 `"12"', add
label define uhrswork_lbl 13 `"13"', add
label define uhrswork_lbl 14 `"14"', add
label define uhrswork_lbl 15 `"15"', add
label define uhrswork_lbl 16 `"16"', add
label define uhrswork_lbl 17 `"17"', add
label define uhrswork_lbl 18 `"18"', add
label define uhrswork_lbl 19 `"19"', add
label define uhrswork_lbl 20 `"20"', add
label define uhrswork_lbl 21 `"21"', add
label define uhrswork_lbl 22 `"22"', add
label define uhrswork_lbl 23 `"23"', add
label define uhrswork_lbl 24 `"24"', add
label define uhrswork_lbl 25 `"25"', add
label define uhrswork_lbl 26 `"26"', add
label define uhrswork_lbl 27 `"27"', add
label define uhrswork_lbl 28 `"28"', add
label define uhrswork_lbl 29 `"29"', add
label define uhrswork_lbl 30 `"30"', add
label define uhrswork_lbl 31 `"31"', add
label define uhrswork_lbl 32 `"32"', add
label define uhrswork_lbl 33 `"33"', add
label define uhrswork_lbl 34 `"34"', add
label define uhrswork_lbl 35 `"35"', add
label define uhrswork_lbl 36 `"36"', add
label define uhrswork_lbl 37 `"37"', add
label define uhrswork_lbl 38 `"38"', add
label define uhrswork_lbl 39 `"39"', add
label define uhrswork_lbl 40 `"40"', add
label define uhrswork_lbl 41 `"41"', add
label define uhrswork_lbl 42 `"42"', add
label define uhrswork_lbl 43 `"43"', add
label define uhrswork_lbl 44 `"44"', add
label define uhrswork_lbl 45 `"45"', add
label define uhrswork_lbl 46 `"46"', add
label define uhrswork_lbl 47 `"47"', add
label define uhrswork_lbl 48 `"48"', add
label define uhrswork_lbl 49 `"49"', add
label define uhrswork_lbl 50 `"50"', add
label define uhrswork_lbl 51 `"51"', add
label define uhrswork_lbl 52 `"52"', add
label define uhrswork_lbl 53 `"53"', add
label define uhrswork_lbl 54 `"54"', add
label define uhrswork_lbl 55 `"55"', add
label define uhrswork_lbl 56 `"56"', add
label define uhrswork_lbl 57 `"57"', add
label define uhrswork_lbl 58 `"58"', add
label define uhrswork_lbl 59 `"59"', add
label define uhrswork_lbl 60 `"60"', add
label define uhrswork_lbl 61 `"61"', add
label define uhrswork_lbl 62 `"62"', add
label define uhrswork_lbl 63 `"63"', add
label define uhrswork_lbl 64 `"64"', add
label define uhrswork_lbl 65 `"65"', add
label define uhrswork_lbl 66 `"66"', add
label define uhrswork_lbl 67 `"67"', add
label define uhrswork_lbl 68 `"68"', add
label define uhrswork_lbl 69 `"69"', add
label define uhrswork_lbl 70 `"70"', add
label define uhrswork_lbl 71 `"71"', add
label define uhrswork_lbl 72 `"72"', add
label define uhrswork_lbl 73 `"73"', add
label define uhrswork_lbl 74 `"74"', add
label define uhrswork_lbl 75 `"75"', add
label define uhrswork_lbl 76 `"76"', add
label define uhrswork_lbl 77 `"77"', add
label define uhrswork_lbl 78 `"78"', add
label define uhrswork_lbl 79 `"79"', add
label define uhrswork_lbl 80 `"80"', add
label define uhrswork_lbl 81 `"81"', add
label define uhrswork_lbl 82 `"82"', add
label define uhrswork_lbl 83 `"83"', add
label define uhrswork_lbl 84 `"84"', add
label define uhrswork_lbl 85 `"85"', add
label define uhrswork_lbl 86 `"86"', add
label define uhrswork_lbl 87 `"87"', add
label define uhrswork_lbl 88 `"88"', add
label define uhrswork_lbl 89 `"89"', add
label define uhrswork_lbl 90 `"90"', add
label define uhrswork_lbl 91 `"91"', add
label define uhrswork_lbl 92 `"92"', add
label define uhrswork_lbl 93 `"93"', add
label define uhrswork_lbl 94 `"94"', add
label define uhrswork_lbl 95 `"95"', add
label define uhrswork_lbl 96 `"96"', add
label define uhrswork_lbl 97 `"97"', add
label define uhrswork_lbl 98 `"98"', add
label define uhrswork_lbl 99 `"99 (Topcode)"', add
label values uhrswork uhrswork_lbl




save "${datadir}raw_acs_data.dta", replace

}

use "${datadir}raw_acs_data.dta", clear
keep if age >= 22


//create spouse/edu vars
foreach person in per {
	if "`person'"=="per" local stub
	if "`person'"=="sp" local stub _sp
	gen some_college`stub' = 1 if educd`stub' >= 65 & educd`stub' <= 100
	gen college`stub' = 1 if educd`stub' >= 101 & educd`stub' <= 113
	gen grad_school`stub' = 1 if educd`stub' >= 114 & educd`stub' <= 116
	keep if some_college == 1 | college == 1 | grad_school == 1

	gen field1`stub' = . 
	replace field1`stub' = 1 if (degfield`stub' == 62 | degfieldd`stub' == 5501) & (college`stub' == 1 | grad_school`stub' == 1) //bus, econ
	replace field1`stub' = 2 if (degfield`stub' == 11 | degfield`stub' == 13 | degfield`stub' == 36 | degfield`stub' == 50 | degfield`stub' == 61) & (college`stub' == 1 | grad_school`stub' == 1) // *nat sci
	replace field1`stub' = 3 if (degfield`stub' == 21 | degfield`stub' == 24 | degfield`stub' == 25 | degfield`stub' == 37 | degfield`stub' == 38   ///
	| degfield`stub' == 51 | degfield`stub' == 56 | degfield`stub' == 57 | degfield`stub' == 58 | degfield`stub' == 59) & (college`stub' == 1 | grad_school`stub' == 1) // *comp sci, engineering, mathematics
	replace field1`stub' = 4 if field1`stub' == . & (college`stub' == 1 | grad_school`stub' == 1) // *humanities is residual;
	replace field1`stub' = 5 if some_college`stub' == 1 //somecollege

	*field codes same as in expectations data;
	gen field2`stub' = 1 if field1`stub' == 1 | field1`stub' == 2 | field1`stub' == 3 // *bus/sci
	replace field2`stub' = 2 if field1`stub' == 4 //hum
	replace field2`stub' = 3 if field1`stub' == 5 //no grad, some college
	replace field2`stub' = 4 if mi(field1`stub')
}

gen male = 1 if sex == 1
replace male = 0 if sex == 2
gen female = !male
replace incwage = . if incwage == 999998 | incwage == 999999

keep if wkswork2 ~= .
keep if uhrswork ~= .

gen full_time = 1 if (wkswork2 == 5 | wkswork2 == 6) & uhrswork >= 35 & incwage >= 10000
replace full_time = 0 if full_time == .

gen part_time = 1 if wkswork2 > 0 & uhrswork > 0 & full_time == 0
replace part_time = 0 if part_time == .

gen not_work = 1 if full_time == 0 & part_time == 0
replace not_work = 0 if not_work == .

bysort not_work: tab full_time part_time, m

gen unemployed = empstat==2

gen weeksworked_num = .
replace weeksworked_num = 7 if wkswork2==1
replace weeksworked_num = 20 if wkswork2==2
replace weeksworked_num = 33 if wkswork2==3
replace weeksworked_num = 44 if wkswork2==4
replace weeksworked_num = 48.5 if wkswork2==5
replace weeksworked_num = 51 if wkswork2==6



gen married = 1 if marst == 1 | marst == 2 | marst == 3
replace married = 0 if married == .


gen field = field2
tab field, gen(field_dum)

save "${datadir}acs_data", replace



////////////////////
use "${datadir}acs_data", clear


gen occ_cat = .
replace occ_cat = 1 if inrange(occ, 0010, 0430) // Management, Business, Science, and Arts Occupations
replace occ_cat = 2 if inrange(occ, 0500, 0740) // Business Operations Specialists
replace occ_cat = 3 if inrange(occ, 0800, 0950) // Financial Specialists
replace occ_cat = 4 if inrange(occ, 1000, 1240) // Computer and Mathematical Occupations
replace occ_cat = 5 if inrange(occ, 1300, 1560) // Architecture and Engineering Occupations
replace occ_cat = 6 if inrange(occ, 1600, 1965) // Life, Physical, and Social Science Occupations
replace occ_cat = 7 if inrange(occ, 2000, 2060) // Community and Social Services Occupations
replace occ_cat = 8 if inrange(occ, 2100, 2145) // Legal Occupations
replace occ_cat = 9 if inrange(occ, 2200, 2550) // Education, Training, and Library Occupations
replace occ_cat = 10 if inrange(occ, 2600, 2920) // Arts, Design, Entertainment, Sports, and Media Occupations
replace occ_cat = 11 if inrange(occ, 3000, 3540) // Healthcare Support Occupations
replace occ_cat = 12 if inrange(occ, 3600, 3955) // Protective Service Occupations
replace occ_cat = 13 if inrange(occ, 4000, 4150) // Food Preparation and Serving Occupations
replace occ_cat = 14 if inrange(occ, 4200, 4250) // Building and Grounds Cleaning and Maintainance Occupations
replace occ_cat = 15 if inrange(occ, 4300, 4650) // Personal Care and Service Occupations
replace occ_cat = 16 if inrange(occ, 4700, 4965) // Sales and Related Occupations
replace occ_cat = 17 if inrange(occ, 5000, 5940) // Office and Administrative Support Occupations
replace occ_cat = 18 if inrange(occ, 6005, 6130) // Farming, Fishing, and Forestry Occupations
replace occ_cat = 19 if inrange(occ, 6005, 6765) // Construction and Extraction Occupations
replace occ_cat = 20 if inrange(occ, 6800, 6940) // Extraction Workers
replace occ_cat = 21 if inrange(occ, 7000, 7610) // Installation, Maintenance, and Repair Workers
replace occ_cat = 22 if inrange(occ, 7700, 8950) // Production Occupations
replace occ_cat = 23 if inrange(occ, 9000, 9750) // Transportations and Material Moving Occupations
replace occ_cat = 24 if inrange(occ, 9800, 9920) // Military-Specific Occupations



//Table 2_acs: active worker summ stats by major
preserve
//create sample restrictions
keep if inrange(age,25,40)
drop if field1 == 5
count if empstat==1 & !missing(incwage)

replace uhrswork=. if !full_time
replace part_time=. if !(full_time | part_time)
replace unemployed=. if !(full_time | part_time | unemployed)
local majwords Business Science Engineering Humanities
gen ln_earnings = log(incwage)
local cols 9
local header "\begin{table}\caption{`caption'}\label{`label'} \centering \begin{tabular}{l*{`cols'}{c}}"
local footer "\end{tabular}\end{table}"

file open resultsfile using "${outputdir}table02b_acs.csv", write replace
file open texfile using "${outputdir}table02b_acs.tex", write replace

file write resultsfile "Table 2b: Job Attributes by Major (ACS 2013)" _n 
file write texfile "`header'"
file write texfile "Table 2b: Job Attributes by Major (ACS 2013) \\" _n 
file write resultsfile "Major, Pct male working in, Pct female working in, Annual Earnings, Annual Earnings (Cond. FT empl), Hrs/wk for full-time, Prop. Part time workers, UE Rate, Prop. Not Working, Annual % Raise in earnings" _n 
file write texfile "Major & Pct male working in & Pct female working in & Annual Earnings & Annual Earnings (Cond. FT empl & Hrs/wk for full-time & Prop. Part time workers & UE Rate & Prop. Not Working & Annual \% Raise in earnings \\" _n 

local comma file write resultsfile ","
local texcomma file write texfile " & "
//A
forval d=1/4{
	//basic summ stats
	file write resultsfile "`:word `d' of `majwords'',"
	file write texfile "`:word `d' of `majwords'' & "
	qui count if male &  field1==`d'
	local num = r(N)
	qui count if male
	local den = r(N)
	local frac = `num'/`den'*100
	file write resultsfile %9.4g (`frac')
	file write texfile %9.4g (`frac')
	`comma'
	`texcomma'
	qui count if !male & field1==`d'
	local num = r(N)
	qui count if !male
	local den = r(N)
	local frac = `num'/`den'*100
	file write resultsfile %9.4g (`frac')
	file write texfile %9.4g (`frac')
	`comma'	
	`texcomma'
	su incwage if field1==`d'
	file write resultsfile %9.4g (`r(mean)')
	file write texfile %9.4g (`r(mean)')
	`comma'	
	`texcomma'
	su incwage if field1==`d' & full_time
	file write resultsfile %9.4g (`r(mean)')
	file write texfile %9.4g (`r(mean)')
	`comma'	
	`texcomma'
	su uhrswork if field1==`d' & full_time
	file write resultsfile %9.4g (`r(mean)')
	file write texfile %9.4g (`r(mean)')
	`texcomma'
	`comma'	
	qui count if field1==`d' & part_time
	local num = r(N)
	qui count if field1==`d' & (full_time | part_time)
	local den = r(N)
	local frac = `num'/`den'*100
	file write resultsfile %9.4g (`frac')
	file write texfile %9.4g (`frac')
	`texcomma'
	`comma'	
	//Insert UE data-UE duration and % UE
	qui count if field1==`d' & unemployed
	local num = r(N)
	qui count if field1==`d' & (full_time | part_time | unemployed)
	local den = r(N)
	local frac = `num'/`den'*100
	file write resultsfile %9.4g (`frac')
	file write texfile %9.4g (`frac')
	`comma'		
	`texcomma'
	qui count if field1==`d' & not_work
	local num = r(N)
	qui count if field1==`d' 
	local den = r(N)
	local frac = `num'/`den'*100
	file write resultsfile %9.4g (`frac')
	file write texfile %9.4g (`frac')
	`comma'		
	`texcomma'
	
	reg ln_earnings age if field1==`d'
	file write resultsfile %9.4g (_b[age]*100)
	file write texfile %9.4g (_b[age]*100)
	`comma'			
	`texcomma'
	
	file write resultsfile _n
	file write texfile " \\" _n
	`comma' 
	`texcomma'
	`comma' 
	`texcomma'
	`comma'
	`texcomma'
	//write SDs of earnings/hours
	su incwage if field1==`d'
	file write resultsfile %9.4g (`r(sd)')
	file write texfile %9.4g (`r(sd)')
	`comma'
	`texcomma'
	su incwage if field1==`d' & full_time==1
	file write resultsfile %9.4g (`r(sd)')
	file write texfile %9.4g (`r(sd)')
	`comma'
	`texcomma'
	su uhrswork if field1==`d'
	file write resultsfile %9.4g (`r(sd)')
	file write texfile %9.4g (`r(sd)')
	file write resultsfile _n
	file write texfile " \\" _n
}

//write Ftests from equality of means
file write resultsfile "F-test of Equal means (P-value):,"
file write texfile "F-test of Equal means (P-value): & "
foreach x in male female incwage uhrswork part_time unemployed not_work{ 

	oneway `x' field1
	local pval: display %9.3f 1-F(`r(df_m)', `r(df_r)', `r(F)')
	//di `r(F)'
	di "`pval'"
	return list
	file write resultsfile "`pval'"
	file write texfile "`pval'"
	`comma'		
	`texcomma'
}
//for last one, need to test equality of coefficients
reg ln_earnings i.field1#c.age, noconstant
test 1b.field1#c.age=2.field1#c.age=3.field1#c.age=4.field1#c.age

local pval: display %4.3f 1-F(`r(df)',`r(df_r)',`r(F)')
	file write resultsfile "`pval'"
	file write texfile "`pval'"
	`comma'		
	`texcomma'
file close resultsfile
file write texfile  " \\" _n "`footer'"
file close texfile

restore

preserve
label define maj_lab 1 "Business" 2 "Science" 3 "Engineering" 4 "Humanities" , replace
label values field1 maj_lab

keep if inrange(age, 25, 40) & empstat == 1 & field1 != 5
gen ln_hrly_earnings = log(incwage/(uhrswork*52))


estimates clear
eststo: reg ln_hrly_earnings female
qui estadd ysumm, mean
eststo: reg ln_hrly_earnings female full_time
qui estadd ysumm, mean
eststo: reg ln_hrly_earnings female full_time age
qui estadd ysumm, mean
eststo: reg ln_hrly_earnings female full_time age i.field1
qui estadd ysumm, mean

esttab using "${outputdir}ACS_gender_gap_regs_hrly_earnings.csv",				///
		b(3) se(3) replace drop(1.field1) r2 scalars(ymean)		///
		star(* 0.10 ** 0.05 *** 0.01)
esttab using "${outputdir}ACS_gender_gap_regs_hrly_earnings.tex",				///
		b(3) se(3) replace drop(1.field1) r2 scalars(ymean)		///
		star(* 0.10 ** 0.05 *** 0.01)

restore
