* NOTE: You need to set the Stata working directory to the path
* where the data file is located.

version 14
clear all
set more off
set varabbrev off

global topdir "YOURFILEPATH/Deming_2017_SocialSkills_Replication"
local importdir "${topdir}/Data/census-acs/import"
local rawdir "${topdir}/Data/census-acs/raw"

clear
quietly infix               ///
  int     year       1-4    ///
  byte    datanum    5-6    ///
  double  serial     7-14   ///
  float   hhwt       15-24  ///
  byte    gq         25-25  ///
  byte    gqtype     26-26  ///
  int     gqtyped    27-29  ///
  int     pernum     30-33  ///
  float   perwt      34-43  ///
  byte    sex        44-44  ///
  int     age        45-47  ///
  byte    educ       48-49  ///
  int     educd      50-52  ///
  byte    empstat    53-53  ///
  byte    empstatd   54-55  ///
  int     occ        56-59  ///
  int     occ1990    60-62  ///
  int     ind        63-66  ///
  int     ind1990    67-69  ///
  byte    classwkr   70-70  ///
  byte    classwkrd  71-72  ///
  byte    wkswork1   73-74  ///
  byte    wkswork2   75-75  ///
  byte    uhrswork   76-77  ///
  long    incwage    78-83  ///
  using "`importdir'/census_1990.dat"

replace hhwt      = hhwt      / 100
replace perwt     = perwt     / 100

format serial    %8.0f
format hhwt      %10.2f
format perwt     %10.2f

label var year      `"Census year"'
label var datanum   `"Data set number"'
label var serial    `"Household serial number"'
label var hhwt      `"Household weight"'
label var gq        `"Group quarters status"'
label var gqtype    `"Group quarters type [general version]"'
label var gqtyped   `"Group quarters type [detailed version]"'
label var pernum    `"Person number in sample unit"'
label var perwt     `"Person weight"'
label var sex       `"Sex"'
label var age       `"Age"'
label var educ      `"Educational attainment [general version]"'
label var educd     `"Educational attainment [detailed version]"'
label var empstat   `"Employment status [general version]"'
label var empstatd  `"Employment status [detailed version]"'
label var occ       `"Occupation"'
label var occ1990   `"Occupation, 1990 basis"'
label var ind       `"Industry"'
label var ind1990   `"Industry, 1990 basis"'
label var classwkr  `"Class of worker [general version]"'
label var classwkrd `"Class of worker [detailed version]"'
label var wkswork1  `"Weeks worked last year"'
label var wkswork2  `"Weeks worked last year, intervalled"'
label var uhrswork  `"Usual hours worked per week"'
label var incwage   `"Wage and salary income"'

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
label values year year_lbl

label define gq_lbl 0 `"Vacant unit"'
label define gq_lbl 1 `"Households under 1970 definition"', add
label define gq_lbl 2 `"Additional households under 1990 definition"', add
label define gq_lbl 3 `"Group quarters--Institutions"', add
label define gq_lbl 4 `"Other group quarters"', add
label define gq_lbl 5 `"Additional households under 2000 definition"', add
label define gq_lbl 6 `"Fragment"', add
label values gq gq_lbl

label define gqtype_lbl 0 `"NA (non-group quarters households)"'
label define gqtype_lbl 1 `"Institution (1990, 2000, ACS/PRCS)"', add
label define gqtype_lbl 2 `"Correctional institutions"', add
label define gqtype_lbl 3 `"Mental institutions"', add
label define gqtype_lbl 4 `"Institutions for the elderly, handicapped, and poor"', add
label define gqtype_lbl 5 `"Non-institutional GQ"', add
label define gqtype_lbl 6 `"Military"', add
label define gqtype_lbl 7 `"College dormitory"', add
label define gqtype_lbl 8 `"Rooming house"', add
label define gqtype_lbl 9 `"Other non-institutional GQ and unknown"', add
label values gqtype gqtype_lbl

label define gqtyped_lbl 000 `"NA (non-group quarters households)"'
label define gqtyped_lbl 010 `"Family group, someone related to head"', add
label define gqtyped_lbl 020 `"Unrelated individuals, no one related to head"', add
label define gqtyped_lbl 100 `"Institution (1990, 2000, ACS/PRCS)"', add
label define gqtyped_lbl 200 `"Correctional institution"', add
label define gqtyped_lbl 210 `"Federal/state correctional"', add
label define gqtyped_lbl 211 `"Prison"', add
label define gqtyped_lbl 212 `"Penitentiary"', add
label define gqtyped_lbl 213 `"Military prison"', add
label define gqtyped_lbl 220 `"Local correctional"', add
label define gqtyped_lbl 221 `"Jail"', add
label define gqtyped_lbl 230 `"School juvenile delinquents"', add
label define gqtyped_lbl 240 `"Reformatory"', add
label define gqtyped_lbl 250 `"Camp or chaingang"', add
label define gqtyped_lbl 260 `"House of correction"', add
label define gqtyped_lbl 300 `"Mental institutions"', add
label define gqtyped_lbl 400 `"Institutions for the elderly, handicapped, and poor"', add
label define gqtyped_lbl 410 `"Homes for elderly"', add
label define gqtyped_lbl 411 `"Aged, dependent home"', add
label define gqtyped_lbl 412 `"Nursing/convalescent home"', add
label define gqtyped_lbl 413 `"Old soldiers home"', add
label define gqtyped_lbl 420 `"Other Instits (Not Aged)"', add
label define gqtyped_lbl 421 `"Other Institution nec"', add
label define gqtyped_lbl 430 `"Homes neglected/depend children"', add
label define gqtyped_lbl 431 `"Orphan school"', add
label define gqtyped_lbl 432 `"Orphans home, asylum"', add
label define gqtyped_lbl 440 `"Other instits for children"', add
label define gqtyped_lbl 441 `"Childrens home, asylum"', add
label define gqtyped_lbl 450 `"Homes physically handicapped"', add
label define gqtyped_lbl 451 `"Deaf, blind school"', add
label define gqtyped_lbl 452 `"Deaf, blind, epilepsy"', add
label define gqtyped_lbl 460 `"Mentally handicapped home"', add
label define gqtyped_lbl 461 `"School for feeblemind"', add
label define gqtyped_lbl 470 `"TB and chronic disease hospital"', add
label define gqtyped_lbl 471 `"Chronic hospitals"', add
label define gqtyped_lbl 472 `"Sanataria"', add
label define gqtyped_lbl 480 `"Poor houses and farms"', add
label define gqtyped_lbl 481 `"Poor house, almshouse"', add
label define gqtyped_lbl 482 `"Poor farm, workhouse"', add
label define gqtyped_lbl 491 `"Maternity homes for unmarried mothers"', add
label define gqtyped_lbl 492 `"Homes for widows, single, fallen women"', add
label define gqtyped_lbl 493 `"Detention homes"', add
label define gqtyped_lbl 494 `"Misc asylums"', add
label define gqtyped_lbl 495 `"Home, other dependent"', add
label define gqtyped_lbl 496 `"Instit combo or unknown"', add
label define gqtyped_lbl 500 `"Non-institutional group quarters"', add
label define gqtyped_lbl 501 `"Family formerly in institutional group quarters"', add
label define gqtyped_lbl 502 `"Unrelated individual residing with family formerly in institutional group quarters"', add
label define gqtyped_lbl 600 `"Military"', add
label define gqtyped_lbl 601 `"U.S. army installation"', add
label define gqtyped_lbl 602 `"Navy, marine installation"', add
label define gqtyped_lbl 603 `"Navy ships"', add
label define gqtyped_lbl 604 `"Air service"', add
label define gqtyped_lbl 700 `"College dormitory"', add
label define gqtyped_lbl 701 `"Military service academies"', add
label define gqtyped_lbl 800 `"Rooming house"', add
label define gqtyped_lbl 801 `"Hotel"', add
label define gqtyped_lbl 802 `"House, lodging apartments"', add
label define gqtyped_lbl 803 `"YMCA, YWCA"', add
label define gqtyped_lbl 804 `"Club"', add
label define gqtyped_lbl 900 `"Other Non-Instit GQ"', add
label define gqtyped_lbl 901 `"Other Non-Instit GQ"', add
label define gqtyped_lbl 910 `"Schools"', add
label define gqtyped_lbl 911 `"Boarding schools"', add
label define gqtyped_lbl 912 `"Academy, institute"', add
label define gqtyped_lbl 913 `"Industrial training"', add
label define gqtyped_lbl 914 `"Indian school"', add
label define gqtyped_lbl 920 `"Hospitals"', add
label define gqtyped_lbl 921 `"Hospital, charity"', add
label define gqtyped_lbl 922 `"Infirmary"', add
label define gqtyped_lbl 923 `"Maternity hospital"', add
label define gqtyped_lbl 924 `"Childrens hospital"', add
label define gqtyped_lbl 931 `"Church, Abbey"', add
label define gqtyped_lbl 932 `"Convent"', add
label define gqtyped_lbl 933 `"Monastery"', add
label define gqtyped_lbl 934 `"Mission"', add
label define gqtyped_lbl 935 `"Seminary"', add
label define gqtyped_lbl 936 `"Religious commune"', add
label define gqtyped_lbl 937 `"Other religious"', add
label define gqtyped_lbl 940 `"Work sites"', add
label define gqtyped_lbl 941 `"Construction, except rr"', add
label define gqtyped_lbl 942 `"Lumber"', add
label define gqtyped_lbl 943 `"Mining"', add
label define gqtyped_lbl 944 `"Railroad"', add
label define gqtyped_lbl 945 `"Farms, ranches"', add
label define gqtyped_lbl 946 `"Ships, boats"', add
label define gqtyped_lbl 947 `"Other industrial"', add
label define gqtyped_lbl 948 `"Other worksites"', add
label define gqtyped_lbl 950 `"Nurses home, dorm"', add
label define gqtyped_lbl 955 `"Passenger ships"', add
label define gqtyped_lbl 960 `"Other group quarters"', add
label define gqtyped_lbl 999 `"Fragment (boarders and lodgers, 1900)"', add
label values gqtyped gqtyped_lbl

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

label define occ1990_lbl 003 `"Legislators"'
label define occ1990_lbl 004 `"Chief executives and public administrators"', add
label define occ1990_lbl 007 `"Financial managers"', add
label define occ1990_lbl 008 `"Human resources and labor relations managers"', add
label define occ1990_lbl 013 `"Managers and specialists in marketing, advertising, and public relations"', add
label define occ1990_lbl 014 `"Managers in education and related fields"', add
label define occ1990_lbl 015 `"Managers of medicine and health occupations"', add
label define occ1990_lbl 016 `"Postmasters and mail superintendents"', add
label define occ1990_lbl 017 `"Managers of food-serving and lodging establishments"', add
label define occ1990_lbl 018 `"Managers of properties and real estate"', add
label define occ1990_lbl 019 `"Funeral directors"', add
label define occ1990_lbl 021 `"Managers of service organizations, n.e.c."', add
label define occ1990_lbl 022 `"Managers and administrators, n.e.c."', add
label define occ1990_lbl 023 `"Accountants and auditors"', add
label define occ1990_lbl 024 `"Insurance underwriters"', add
label define occ1990_lbl 025 `"Other financial specialists"', add
label define occ1990_lbl 026 `"Management analysts"', add
label define occ1990_lbl 027 `"Personnel, HR, training, and labor relations specialists"', add
label define occ1990_lbl 028 `"Purchasing agents and buyers, of farm products"', add
label define occ1990_lbl 029 `"Buyers, wholesale and retail trade"', add
label define occ1990_lbl 033 `"Purchasing managers, agents and buyers, n.e.c."', add
label define occ1990_lbl 034 `"Business and promotion agents"', add
label define occ1990_lbl 035 `"Construction inspectors"', add
label define occ1990_lbl 036 `"Inspectors and compliance officers, outside construction"', add
label define occ1990_lbl 037 `"Management support occupations"', add
label define occ1990_lbl 043 `"Architects"', add
label define occ1990_lbl 044 `"Aerospace engineer"', add
label define occ1990_lbl 045 `"Metallurgical and materials engineers, variously phrased"', add
label define occ1990_lbl 047 `"Petroleum, mining, and geological engineers"', add
label define occ1990_lbl 048 `"Chemical engineers"', add
label define occ1990_lbl 053 `"Civil engineers"', add
label define occ1990_lbl 055 `"Electrical engineer"', add
label define occ1990_lbl 056 `"Industrial engineers"', add
label define occ1990_lbl 057 `"Mechanical engineers"', add
label define occ1990_lbl 059 `"Not-elsewhere-classified engineers"', add
label define occ1990_lbl 064 `"Computer systems analysts and computer scientists"', add
label define occ1990_lbl 065 `"Operations and systems researchers and analysts"', add
label define occ1990_lbl 066 `"Actuaries"', add
label define occ1990_lbl 067 `"Statisticians"', add
label define occ1990_lbl 068 `"Mathematicians and mathematical scientists"', add
label define occ1990_lbl 069 `"Physicists and astronomers"', add
label define occ1990_lbl 073 `"Chemists"', add
label define occ1990_lbl 074 `"Atmospheric and space scientists"', add
label define occ1990_lbl 075 `"Geologists"', add
label define occ1990_lbl 076 `"Physical scientists, n.e.c."', add
label define occ1990_lbl 077 `"Agricultural and food scientists"', add
label define occ1990_lbl 078 `"Biological scientists"', add
label define occ1990_lbl 079 `"Foresters and conservation scientists"', add
label define occ1990_lbl 083 `"Medical scientists"', add
label define occ1990_lbl 084 `"Physicians"', add
label define occ1990_lbl 085 `"Dentists"', add
label define occ1990_lbl 086 `"Veterinarians"', add
label define occ1990_lbl 087 `"Optometrists"', add
label define occ1990_lbl 088 `"Podiatrists"', add
label define occ1990_lbl 089 `"Other health and therapy"', add
label define occ1990_lbl 095 `"Registered nurses"', add
label define occ1990_lbl 096 `"Pharmacists"', add
label define occ1990_lbl 097 `"Dietitians and nutritionists"', add
label define occ1990_lbl 098 `"Respiratory therapists"', add
label define occ1990_lbl 099 `"Occupational therapists"', add
label define occ1990_lbl 103 `"Physical therapists"', add
label define occ1990_lbl 104 `"Speech therapists"', add
label define occ1990_lbl 105 `"Therapists, n.e.c."', add
label define occ1990_lbl 106 `"Physicians' assistants"', add
label define occ1990_lbl 113 `"Earth, environmental, and marine science instructors"', add
label define occ1990_lbl 114 `"Biological science instructors"', add
label define occ1990_lbl 115 `"Chemistry instructors"', add
label define occ1990_lbl 116 `"Physics instructors"', add
label define occ1990_lbl 118 `"Psychology instructors"', add
label define occ1990_lbl 119 `"Economics instructors"', add
label define occ1990_lbl 123 `"History instructors"', add
label define occ1990_lbl 125 `"Sociology instructors"', add
label define occ1990_lbl 127 `"Engineering instructors"', add
label define occ1990_lbl 128 `"Math instructors"', add
label define occ1990_lbl 139 `"Education instructors"', add
label define occ1990_lbl 145 `"Law instructors"', add
label define occ1990_lbl 147 `"Theology instructors"', add
label define occ1990_lbl 149 `"Home economics instructors"', add
label define occ1990_lbl 150 `"Humanities profs/instructors, college, nec"', add
label define occ1990_lbl 154 `"Subject instructors (HS/college)"', add
label define occ1990_lbl 155 `"Kindergarten and earlier school teachers"', add
label define occ1990_lbl 156 `"Primary school teachers"', add
label define occ1990_lbl 157 `"Secondary school teachers"', add
label define occ1990_lbl 158 `"Special education teachers"', add
label define occ1990_lbl 159 `"Teachers , n.e.c."', add
label define occ1990_lbl 163 `"Vocational and educational counselors"', add
label define occ1990_lbl 164 `"Librarians"', add
label define occ1990_lbl 165 `"Archivists and curators"', add
label define occ1990_lbl 166 `"Economists, market researchers, and survey researchers"', add
label define occ1990_lbl 167 `"Psychologists"', add
label define occ1990_lbl 168 `"Sociologists"', add
label define occ1990_lbl 169 `"Social scientists, n.e.c."', add
label define occ1990_lbl 173 `"Urban and regional planners"', add
label define occ1990_lbl 174 `"Social workers"', add
label define occ1990_lbl 175 `"Recreation workers"', add
label define occ1990_lbl 176 `"Clergy and religious workers"', add
label define occ1990_lbl 178 `"Lawyers "', add
label define occ1990_lbl 179 `"Judges"', add
label define occ1990_lbl 183 `"Writers and authors"', add
label define occ1990_lbl 184 `"Technical writers"', add
label define occ1990_lbl 185 `"Designers"', add
label define occ1990_lbl 186 `"Musician or composer"', add
label define occ1990_lbl 187 `"Actors, directors, producers"', add
label define occ1990_lbl 188 `"Art makers: painters, sculptors, craft-artists, and print-makers"', add
label define occ1990_lbl 189 `"Photographers"', add
label define occ1990_lbl 193 `"Dancers"', add
label define occ1990_lbl 194 `"Art/entertainment performers and related"', add
label define occ1990_lbl 195 `"Editors and reporters"', add
label define occ1990_lbl 198 `"Announcers"', add
label define occ1990_lbl 199 `"Athletes, sports instructors, and officials"', add
label define occ1990_lbl 200 `"Professionals, n.e.c."', add
label define occ1990_lbl 203 `"Clinical laboratory technologies and technicians"', add
label define occ1990_lbl 204 `"Dental hygenists"', add
label define occ1990_lbl 205 `"Health record tech specialists"', add
label define occ1990_lbl 206 `"Radiologic tech specialists"', add
label define occ1990_lbl 207 `"Licensed practical nurses"', add
label define occ1990_lbl 208 `"Health technologists and technicians, n.e.c."', add
label define occ1990_lbl 213 `"Electrical and electronic (engineering) technicians"', add
label define occ1990_lbl 214 `"Engineering technicians, n.e.c."', add
label define occ1990_lbl 215 `"Mechanical engineering technicians"', add
label define occ1990_lbl 217 `"Drafters"', add
label define occ1990_lbl 218 `"Surveyors, cartographers, mapping scientists and technicians"', add
label define occ1990_lbl 223 `"Biological technicians"', add
label define occ1990_lbl 224 `"Chemical technicians"', add
label define occ1990_lbl 225 `"Other science technicians"', add
label define occ1990_lbl 226 `"Airplane pilots and navigators"', add
label define occ1990_lbl 227 `"Air traffic controllers"', add
label define occ1990_lbl 228 `"Broadcast equipment operators"', add
label define occ1990_lbl 229 `"Computer software developers"', add
label define occ1990_lbl 233 `"Programmers of numerically controlled machine tools"', add
label define occ1990_lbl 234 `"Legal assistants, paralegals, legal support, etc"', add
label define occ1990_lbl 235 `"Technicians, n.e.c."', add
label define occ1990_lbl 243 `"Supervisors and proprietors of sales jobs"', add
label define occ1990_lbl 253 `"Insurance sales occupations"', add
label define occ1990_lbl 254 `"Real estate sales occupations"', add
label define occ1990_lbl 255 `"Financial services sales occupations"', add
label define occ1990_lbl 256 `"Advertising and related sales jobs"', add
label define occ1990_lbl 258 `"Sales engineers"', add
label define occ1990_lbl 274 `"Salespersons, n.e.c."', add
label define occ1990_lbl 275 `"Retail sales clerks"', add
label define occ1990_lbl 276 `"Cashiers"', add
label define occ1990_lbl 277 `"Door-to-door sales, street sales, and news vendors"', add
label define occ1990_lbl 283 `"Sales demonstrators / promoters / models"', add
label define occ1990_lbl 303 `"Office supervisors"', add
label define occ1990_lbl 308 `"Computer and peripheral equipment operators"', add
label define occ1990_lbl 313 `"Secretaries"', add
label define occ1990_lbl 314 `"Stenographers"', add
label define occ1990_lbl 315 `"Typists"', add
label define occ1990_lbl 316 `"Interviewers, enumerators, and surveyors"', add
label define occ1990_lbl 317 `"Hotel clerks"', add
label define occ1990_lbl 318 `"Transportation ticket and reservation agents"', add
label define occ1990_lbl 319 `"Receptionists"', add
label define occ1990_lbl 323 `"Information clerks, nec"', add
label define occ1990_lbl 326 `"Correspondence and order clerks"', add
label define occ1990_lbl 328 `"Human resources clerks, except payroll and timekeeping"', add
label define occ1990_lbl 329 `"Library assistants"', add
label define occ1990_lbl 335 `"File clerks"', add
label define occ1990_lbl 336 `"Records clerks"', add
label define occ1990_lbl 337 `"Bookkeepers and accounting and auditing clerks"', add
label define occ1990_lbl 338 `"Payroll and timekeeping clerks"', add
label define occ1990_lbl 343 `"Cost and rate clerks (financial records processing)"', add
label define occ1990_lbl 344 `"Billing clerks and related financial records processing"', add
label define occ1990_lbl 345 `"Duplication machine operators / office machine operators"', add
label define occ1990_lbl 346 `"Mail and paper handlers"', add
label define occ1990_lbl 347 `"Office machine operators, n.e.c."', add
label define occ1990_lbl 348 `"Telephone operators"', add
label define occ1990_lbl 349 `"Other telecom operators"', add
label define occ1990_lbl 354 `"Postal clerks, excluding mail carriers"', add
label define occ1990_lbl 355 `"Mail carriers for postal service"', add
label define occ1990_lbl 356 `"Mail clerks, outside of post office"', add
label define occ1990_lbl 357 `"Messengers"', add
label define occ1990_lbl 359 `"Dispatchers"', add
label define occ1990_lbl 361 `"Inspectors, n.e.c."', add
label define occ1990_lbl 364 `"Shipping and receiving clerks"', add
label define occ1990_lbl 365 `"Stock and inventory clerks"', add
label define occ1990_lbl 366 `"Meter readers"', add
label define occ1990_lbl 368 `"Weighers, measurers, and checkers"', add
label define occ1990_lbl 373 `"Material recording, scheduling, production, planning, and expediting clerks"', add
label define occ1990_lbl 375 `"Insurance adjusters, examiners, and investigators"', add
label define occ1990_lbl 376 `"Customer service reps, investigators and adjusters, except insurance"', add
label define occ1990_lbl 377 `"Eligibility clerks for government programs; social welfare"', add
label define occ1990_lbl 378 `"Bill and account collectors"', add
label define occ1990_lbl 379 `"General office clerks"', add
label define occ1990_lbl 383 `"Bank tellers"', add
label define occ1990_lbl 384 `"Proofreaders"', add
label define occ1990_lbl 385 `"Data entry keyers"', add
label define occ1990_lbl 386 `"Statistical clerks"', add
label define occ1990_lbl 387 `"Teacher's aides"', add
label define occ1990_lbl 389 `"Administrative support jobs, n.e.c."', add
label define occ1990_lbl 405 `"Housekeepers, maids, butlers, stewards, and lodging quarters cleaners"', add
label define occ1990_lbl 407 `"Private household cleaners and servants"', add
label define occ1990_lbl 415 `"Supervisors of guards"', add
label define occ1990_lbl 417 `"Fire fighting, prevention, and inspection"', add
label define occ1990_lbl 418 `"Police, detectives, and private investigators"', add
label define occ1990_lbl 423 `"Other law enforcement: sheriffs, bailiffs, correctional institution officers"', add
label define occ1990_lbl 425 `"Crossing guards and bridge tenders"', add
label define occ1990_lbl 426 `"Guards, watchmen, doorkeepers"', add
label define occ1990_lbl 427 `"Protective services, n.e.c."', add
label define occ1990_lbl 434 `"Bartenders"', add
label define occ1990_lbl 435 `"Waiter/waitress"', add
label define occ1990_lbl 436 `"Cooks, variously defined"', add
label define occ1990_lbl 438 `"Food counter and fountain workers"', add
label define occ1990_lbl 439 `"Kitchen workers"', add
label define occ1990_lbl 443 `"Waiter's assistant"', add
label define occ1990_lbl 444 `"Misc food prep workers"', add
label define occ1990_lbl 445 `"Dental assistants"', add
label define occ1990_lbl 446 `"Health aides, except nursing"', add
label define occ1990_lbl 447 `"Nursing aides, orderlies, and attendants"', add
label define occ1990_lbl 448 `"Supervisors of cleaning and building service"', add
label define occ1990_lbl 453 `"Janitors"', add
label define occ1990_lbl 454 `"Elevator operators"', add
label define occ1990_lbl 455 `"Pest control occupations"', add
label define occ1990_lbl 456 `"Supervisors of personal service jobs, n.e.c."', add
label define occ1990_lbl 457 `"Barbers"', add
label define occ1990_lbl 458 `"Hairdressers and cosmetologists"', add
label define occ1990_lbl 459 `"Recreation facility attendants"', add
label define occ1990_lbl 461 `"Guides"', add
label define occ1990_lbl 462 `"Ushers"', add
label define occ1990_lbl 463 `"Public transportation attendants and inspectors"', add
label define occ1990_lbl 464 `"Baggage porters"', add
label define occ1990_lbl 465 `"Welfare service aides"', add
label define occ1990_lbl 468 `"Child care workers"', add
label define occ1990_lbl 469 `"Personal service occupations, nec"', add
label define occ1990_lbl 473 `"Farmers (owners and tenants)"', add
label define occ1990_lbl 474 `"Horticultural specialty farmers"', add
label define occ1990_lbl 475 `"Farm managers, except for horticultural farms"', add
label define occ1990_lbl 476 `"Managers of horticultural specialty farms"', add
label define occ1990_lbl 479 `"Farm workers"', add
label define occ1990_lbl 483 `"Marine life cultivation workers"', add
label define occ1990_lbl 484 `"Nursery farming workers"', add
label define occ1990_lbl 485 `"Supervisors of agricultural occupations"', add
label define occ1990_lbl 486 `"Gardeners and groundskeepers"', add
label define occ1990_lbl 487 `"Animal caretakers except on farms"', add
label define occ1990_lbl 488 `"Graders and sorters of agricultural products"', add
label define occ1990_lbl 489 `"Inspectors of agricultural products"', add
label define occ1990_lbl 496 `"Timber, logging, and forestry workers"', add
label define occ1990_lbl 498 `"Fishers, hunters, and kindred"', add
label define occ1990_lbl 503 `"Supervisors of mechanics and repairers"', add
label define occ1990_lbl 505 `"Automobile mechanics"', add
label define occ1990_lbl 507 `"Bus, truck, and stationary engine mechanics"', add
label define occ1990_lbl 508 `"Aircraft mechanics"', add
label define occ1990_lbl 509 `"Small engine repairers"', add
label define occ1990_lbl 514 `"Auto body repairers"', add
label define occ1990_lbl 516 `"Heavy equipment and farm equipment mechanics"', add
label define occ1990_lbl 518 `"Industrial machinery repairers"', add
label define occ1990_lbl 519 `"Machinery maintenance occupations"', add
label define occ1990_lbl 523 `"Repairers of industrial electrical equipment "', add
label define occ1990_lbl 525 `"Repairers of data processing equipment"', add
label define occ1990_lbl 526 `"Repairers of household appliances and power tools"', add
label define occ1990_lbl 527 `"Telecom and line installers and repairers"', add
label define occ1990_lbl 533 `"Repairers of electrical equipment, n.e.c."', add
label define occ1990_lbl 534 `"Heating, air conditioning, and refigeration mechanics"', add
label define occ1990_lbl 535 `"Precision makers, repairers, and smiths"', add
label define occ1990_lbl 536 `"Locksmiths and safe repairers"', add
label define occ1990_lbl 538 `"Office machine repairers and mechanics"', add
label define occ1990_lbl 539 `"Repairers of mechanical controls and valves"', add
label define occ1990_lbl 543 `"Elevator installers and repairers"', add
label define occ1990_lbl 544 `"Millwrights"', add
label define occ1990_lbl 549 `"Mechanics and repairers, n.e.c."', add
label define occ1990_lbl 558 `"Supervisors of construction work"', add
label define occ1990_lbl 563 `"Masons, tilers, and carpet installers"', add
label define occ1990_lbl 567 `"Carpenters"', add
label define occ1990_lbl 573 `"Drywall installers"', add
label define occ1990_lbl 575 `"Electricians"', add
label define occ1990_lbl 577 `"Electric power installers and repairers"', add
label define occ1990_lbl 579 `"Painters, construction and maintenance"', add
label define occ1990_lbl 583 `"Paperhangers"', add
label define occ1990_lbl 584 `"Plasterers"', add
label define occ1990_lbl 585 `"Plumbers, pipe fitters, and steamfitters"', add
label define occ1990_lbl 588 `"Concrete and cement workers"', add
label define occ1990_lbl 589 `"Glaziers"', add
label define occ1990_lbl 593 `"Insulation workers"', add
label define occ1990_lbl 594 `"Paving, surfacing, and tamping equipment operators"', add
label define occ1990_lbl 595 `"Roofers and slaters"', add
label define occ1990_lbl 596 `"Sheet metal duct installers"', add
label define occ1990_lbl 597 `"Structural metal workers"', add
label define occ1990_lbl 598 `"Drillers of earth"', add
label define occ1990_lbl 599 `"Construction trades, n.e.c."', add
label define occ1990_lbl 614 `"Drillers of oil wells"', add
label define occ1990_lbl 615 `"Explosives workers"', add
label define occ1990_lbl 616 `"Miners"', add
label define occ1990_lbl 617 `"Other mining occupations"', add
label define occ1990_lbl 628 `"Production supervisors or foremen"', add
label define occ1990_lbl 634 `"Tool and die makers and die setters"', add
label define occ1990_lbl 637 `"Machinists"', add
label define occ1990_lbl 643 `"Boilermakers"', add
label define occ1990_lbl 644 `"Precision grinders and filers"', add
label define occ1990_lbl 645 `"Patternmakers and model makers"', add
label define occ1990_lbl 646 `"Lay-out workers"', add
label define occ1990_lbl 649 `"Engravers"', add
label define occ1990_lbl 653 `"Tinsmiths, coppersmiths, and sheet metal workers"', add
label define occ1990_lbl 657 `"Cabinetmakers and bench carpenters"', add
label define occ1990_lbl 658 `"Furniture and wood finishers"', add
label define occ1990_lbl 659 `"Other precision woodworkers"', add
label define occ1990_lbl 666 `"Dressmakers and seamstresses"', add
label define occ1990_lbl 667 `"Tailors"', add
label define occ1990_lbl 668 `"Upholsterers"', add
label define occ1990_lbl 669 `"Shoe repairers"', add
label define occ1990_lbl 674 `"Other precision apparel and fabric workers"', add
label define occ1990_lbl 675 `"Hand molders and shapers, except jewelers "', add
label define occ1990_lbl 677 `"Optical goods workers"', add
label define occ1990_lbl 678 `"Dental laboratory and medical appliance technicians"', add
label define occ1990_lbl 679 `"Bookbinders"', add
label define occ1990_lbl 684 `"Other precision and craft workers"', add
label define occ1990_lbl 686 `"Butchers and meat cutters"', add
label define occ1990_lbl 687 `"Bakers"', add
label define occ1990_lbl 688 `"Batch food makers"', add
label define occ1990_lbl 693 `"Adjusters and calibrators"', add
label define occ1990_lbl 694 `"Water and sewage treatment plant operators"', add
label define occ1990_lbl 695 `"Power plant operators"', add
label define occ1990_lbl 696 `"Plant and system operators, stationary engineers "', add
label define occ1990_lbl 699 `"Other plant and system operators"', add
label define occ1990_lbl 703 `"Lathe, milling, and turning machine operatives"', add
label define occ1990_lbl 706 `"Punching and stamping press operatives"', add
label define occ1990_lbl 707 `"Rollers, roll hands, and finishers of metal"', add
label define occ1990_lbl 708 `"Drilling and boring machine operators"', add
label define occ1990_lbl 709 `"Grinding, abrading, buffing, and polishing workers"', add
label define occ1990_lbl 713 `"Forge and hammer operators"', add
label define occ1990_lbl 717 `"Fabricating machine operators, n.e.c."', add
label define occ1990_lbl 719 `"Molders, and casting machine operators"', add
label define occ1990_lbl 723 `"Metal platers"', add
label define occ1990_lbl 724 `"Heat treating equipment operators"', add
label define occ1990_lbl 726 `"Wood lathe, routing, and planing machine operators"', add
label define occ1990_lbl 727 `"Sawing machine operators and sawyers"', add
label define occ1990_lbl 728 `"Shaping and joining machine operator (woodworking)"', add
label define occ1990_lbl 729 `"Nail and tacking machine operators  (woodworking)"', add
label define occ1990_lbl 733 `"Other woodworking machine operators"', add
label define occ1990_lbl 734 `"Printing machine operators, n.e.c."', add
label define occ1990_lbl 735 `"Photoengravers and lithographers"', add
label define occ1990_lbl 736 `"Typesetters and compositors"', add
label define occ1990_lbl 738 `"Winding and twisting textile/apparel operatives"', add
label define occ1990_lbl 739 `"Knitters, loopers, and toppers textile operatives"', add
label define occ1990_lbl 743 `"Textile cutting machine operators"', add
label define occ1990_lbl 744 `"Textile sewing machine operators"', add
label define occ1990_lbl 745 `"Shoemaking machine operators"', add
label define occ1990_lbl 747 `"Pressing machine operators (clothing)"', add
label define occ1990_lbl 748 `"Laundry workers"', add
label define occ1990_lbl 749 `"Misc textile machine operators"', add
label define occ1990_lbl 753 `"Cementing and gluing maching operators"', add
label define occ1990_lbl 754 `"Packers, fillers, and wrappers"', add
label define occ1990_lbl 755 `"Extruding and forming machine operators"', add
label define occ1990_lbl 756 `"Mixing and blending machine operatives"', add
label define occ1990_lbl 757 `"Separating, filtering, and clarifying machine operators"', add
label define occ1990_lbl 759 `"Painting machine operators"', add
label define occ1990_lbl 763 `"Roasting and baking machine operators (food)"', add
label define occ1990_lbl 764 `"Washing, cleaning, and pickling machine operators"', add
label define occ1990_lbl 765 `"Paper folding machine operators"', add
label define occ1990_lbl 766 `"Furnace, kiln, and oven operators, apart from food"', add
label define occ1990_lbl 768 `"Crushing and grinding machine operators"', add
label define occ1990_lbl 769 `"Slicing and cutting machine operators"', add
label define occ1990_lbl 773 `"Motion picture projectionists"', add
label define occ1990_lbl 774 `"Photographic process workers"', add
label define occ1990_lbl 779 `"Machine operators, n.e.c."', add
label define occ1990_lbl 783 `"Welders and metal cutters"', add
label define occ1990_lbl 784 `"Solderers"', add
label define occ1990_lbl 785 `"Assemblers of electrical equipment"', add
label define occ1990_lbl 789 `"Hand painting, coating, and decorating occupations"', add
label define occ1990_lbl 796 `"Production checkers and inspectors"', add
label define occ1990_lbl 799 `"Graders and sorters in manufacturing"', add
label define occ1990_lbl 803 `"Supervisors of motor vehicle transportation"', add
label define occ1990_lbl 804 `"Truck, delivery, and tractor drivers"', add
label define occ1990_lbl 808 `"Bus drivers"', add
label define occ1990_lbl 809 `"Taxi cab drivers and chauffeurs"', add
label define occ1990_lbl 813 `"Parking lot attendants"', add
label define occ1990_lbl 823 `"Railroad conductors and yardmasters"', add
label define occ1990_lbl 824 `"Locomotive operators (engineers and firemen)"', add
label define occ1990_lbl 825 `"Railroad brake, coupler, and switch operators"', add
label define occ1990_lbl 829 `"Ship crews and marine engineers"', add
label define occ1990_lbl 834 `"Water transport infrastructure tenders and crossing guards"', add
label define occ1990_lbl 844 `"Operating engineers of construction equipment"', add
label define occ1990_lbl 848 `"Crane, derrick, winch, and hoist operators"', add
label define occ1990_lbl 853 `"Excavating and loading machine operators"', add
label define occ1990_lbl 859 `"Misc material moving occupations"', add
label define occ1990_lbl 865 `"Helpers, constructions"', add
label define occ1990_lbl 866 `"Helpers, surveyors"', add
label define occ1990_lbl 869 `"Construction laborers"', add
label define occ1990_lbl 874 `"Production helpers"', add
label define occ1990_lbl 875 `"Garbage and recyclable material collectors"', add
label define occ1990_lbl 876 `"Materials movers: stevedores and longshore workers"', add
label define occ1990_lbl 877 `"Stock handlers"', add
label define occ1990_lbl 878 `"Machine feeders and offbearers"', add
label define occ1990_lbl 883 `"Freight, stock, and materials handlers"', add
label define occ1990_lbl 885 `"Garage and service station related occupations"', add
label define occ1990_lbl 887 `"Vehicle washers and equipment cleaners"', add
label define occ1990_lbl 888 `"Packers and packagers by hand"', add
label define occ1990_lbl 889 `"Laborers outside construction"', add
label define occ1990_lbl 905 `"Military"', add
label define occ1990_lbl 991 `"Unemployed"', add
label define occ1990_lbl 999 `"Unknown"', add
label values occ1990 occ1990_lbl

label define ind1990_lbl 000 `"N/A (not applicable)†"'
label define ind1990_lbl 010 `"Agricultural production, crops"', add
label define ind1990_lbl 011 `"Agricultural production, livestock"', add
label define ind1990_lbl 012 `"Veterinary services"', add
label define ind1990_lbl 020 `"Landscape and horticultural services"', add
label define ind1990_lbl 030 `"Agricultural services, n.e.c."', add
label define ind1990_lbl 031 `"Forestry"', add
label define ind1990_lbl 032 `"Fishing, hunting, and trapping†"', add
label define ind1990_lbl 040 `"Metal mining"', add
label define ind1990_lbl 041 `"Coal mining"', add
label define ind1990_lbl 042 `"Oil and gas extraction"', add
label define ind1990_lbl 050 `"Nonmetallic mining and quarrying, except fuels†"', add
label define ind1990_lbl 060 `"All construction†"', add
label define ind1990_lbl 100 `"Meat products"', add
label define ind1990_lbl 101 `"Dairy products"', add
label define ind1990_lbl 102 `"Canned, frozen, and preserved fruits and vegetables"', add
label define ind1990_lbl 110 `"Grain mill products"', add
label define ind1990_lbl 111 `"Bakery products"', add
label define ind1990_lbl 112 `"Sugar and confectionery products"', add
label define ind1990_lbl 120 `"Beverage industries"', add
label define ind1990_lbl 121 `"Misc. food preparations and kindred products"', add
label define ind1990_lbl 122 `"Food industries, n.s."', add
label define ind1990_lbl 130 `"Tobacco manufactures"', add
label define ind1990_lbl 132 `"Knitting mills"', add
label define ind1990_lbl 140 `"Dyeing and finishing textiles, except wool and knit goods"', add
label define ind1990_lbl 141 `"Carpets and rugs"', add
label define ind1990_lbl 142 `"Yarn, thread, and fabric mills"', add
label define ind1990_lbl 150 `"Miscellaneous textile mill products"', add
label define ind1990_lbl 151 `"Apparel and accessories, except knit"', add
label define ind1990_lbl 152 `"Miscellaneous fabricated textile products"', add
label define ind1990_lbl 160 `"Pulp, paper, and paperboard mills"', add
label define ind1990_lbl 161 `"Miscellaneous paper and pulp products"', add
label define ind1990_lbl 162 `"Paperboard containers and boxes"', add
label define ind1990_lbl 171 `"Newspaper publishing and printing"', add
label define ind1990_lbl 172 `"Printing, publishing, and allied industries, except newspapers"', add
label define ind1990_lbl 180 `"Plastics, synthetics, and resins"', add
label define ind1990_lbl 181 `"Drugs"', add
label define ind1990_lbl 182 `"Soaps and cosmetics"', add
label define ind1990_lbl 190 `"Paints, varnishes, and related products"', add
label define ind1990_lbl 191 `"Agricultural chemicals"', add
label define ind1990_lbl 192 `"Industrial and miscellaneous chemicals"', add
label define ind1990_lbl 200 `"Petroleum refining"', add
label define ind1990_lbl 201 `"Miscellaneous petroleum and coal products"', add
label define ind1990_lbl 210 `"Tires and inner tubes"', add
label define ind1990_lbl 211 `"Other rubber products, and plastics footwear and belting"', add
label define ind1990_lbl 212 `"Miscellaneous plastics products"', add
label define ind1990_lbl 220 `"Leather tanning and finishing"', add
label define ind1990_lbl 221 `"Footwear, except rubber and plastic"', add
label define ind1990_lbl 222 `"Leather products, except footwear"', add
label define ind1990_lbl 230 `"Logging"', add
label define ind1990_lbl 231 `"Sawmills, planing mills, and millwork"', add
label define ind1990_lbl 232 `"Wood buildings and mobile homes"', add
label define ind1990_lbl 241 `"Miscellaneous wood products"', add
label define ind1990_lbl 242 `"Furniture and fixtures"', add
label define ind1990_lbl 250 `"Glass and glass products"', add
label define ind1990_lbl 251 `"Cement, concrete, gypsum, and plaster products"', add
label define ind1990_lbl 252 `"Structural clay products"', add
label define ind1990_lbl 261 `"Pottery and related products"', add
label define ind1990_lbl 262 `"Misc. nonmetallic mineral and stone products"', add
label define ind1990_lbl 270 `"Blast furnaces, steelworks, rolling and finishing mills"', add
label define ind1990_lbl 271 `"Iron and steel foundries"', add
label define ind1990_lbl 272 `"Primary aluminum industries"', add
label define ind1990_lbl 280 `"Other primary metal industries"', add
label define ind1990_lbl 281 `"Cutlery, handtools, and general hardware"', add
label define ind1990_lbl 282 `"Fabricated structural metal products"', add
label define ind1990_lbl 290 `"Screw machine products"', add
label define ind1990_lbl 291 `"Metal forgings and stampings"', add
label define ind1990_lbl 292 `"Ordnance"', add
label define ind1990_lbl 300 `"Miscellaneous fabricated metal products"', add
label define ind1990_lbl 301 `"Metal industries, n.s."', add
label define ind1990_lbl 310 `"Engines and turbines"', add
label define ind1990_lbl 311 `"Farm machinery and equipment"', add
label define ind1990_lbl 312 `"Construction and material handling machines"', add
label define ind1990_lbl 320 `"Metalworking machinery"', add
label define ind1990_lbl 321 `"Office and accounting machines"', add
label define ind1990_lbl 322 `"Computers and related equipment"', add
label define ind1990_lbl 331 `"Machinery, except electrical, n.e.c."', add
label define ind1990_lbl 332 `"Machinery, n.s."', add
label define ind1990_lbl 340 `"Household appliances"', add
label define ind1990_lbl 341 `"Radio, TV, and communication equipment"', add
label define ind1990_lbl 342 `"Electrical machinery, equipment, and supplies, n.e.c."', add
label define ind1990_lbl 350 `"Electrical machinery, equipment, and supplies, n.s."', add
label define ind1990_lbl 351 `"Motor vehicles and motor vehicle equipment"', add
label define ind1990_lbl 352 `"Aircraft and parts"', add
label define ind1990_lbl 360 `"Ship and boat building and repairing"', add
label define ind1990_lbl 361 `"Railroad locomotives and equipment"', add
label define ind1990_lbl 362 `"Guided missiles, space vehicles, and parts"', add
label define ind1990_lbl 370 `"Cycles and miscellaneous transportation equipment"', add
label define ind1990_lbl 371 `"Scientific and controlling instruments"', add
label define ind1990_lbl 372 `"Medical, dental, and optical instruments and supplies"', add
label define ind1990_lbl 380 `"Photographic equipment and supplies"', add
label define ind1990_lbl 381 `"Watches, clocks, and clockwork operated devices"', add
label define ind1990_lbl 390 `"Toys, amusement, and sporting goods"', add
label define ind1990_lbl 391 `"Miscellaneous manufacturing industries"', add
label define ind1990_lbl 392 `"Manufacturing industries, n.s.†"', add
label define ind1990_lbl 400 `"Railroads"', add
label define ind1990_lbl 401 `"Bus service and urban transit"', add
label define ind1990_lbl 402 `"Taxicab service"', add
label define ind1990_lbl 410 `"Trucking service"', add
label define ind1990_lbl 411 `"Warehousing and storage"', add
label define ind1990_lbl 412 `"U.S. Postal Service"', add
label define ind1990_lbl 420 `"Water transportation"', add
label define ind1990_lbl 421 `"Air transportation"', add
label define ind1990_lbl 422 `"Pipe lines, except natural gas"', add
label define ind1990_lbl 432 `"Services incidental to transportation"', add
label define ind1990_lbl 440 `"Radio and television broadcasting and cable"', add
label define ind1990_lbl 441 `"Telephone communications"', add
label define ind1990_lbl 442 `"Telegraph and miscellaneous communications services"', add
label define ind1990_lbl 450 `"Electric light and power"', add
label define ind1990_lbl 451 `"Gas and steam supply systems"', add
label define ind1990_lbl 452 `"Electric and gas, and other combinations"', add
label define ind1990_lbl 470 `"Water supply and irrigation"', add
label define ind1990_lbl 471 `"Sanitary services"', add
label define ind1990_lbl 472 `"Utilities, n.s.†"', add
label define ind1990_lbl 500 `"Motor vehicles and equipment"', add
label define ind1990_lbl 501 `"Furniture and home furnishings"', add
label define ind1990_lbl 502 `"Lumber and construction materials"', add
label define ind1990_lbl 510 `"Professional and commercial equipment and supplies"', add
label define ind1990_lbl 511 `"Metals and minerals, except petroleum"', add
label define ind1990_lbl 512 `"Electrical goods"', add
label define ind1990_lbl 521 `"Hardware, plumbing and heating supplies"', add
label define ind1990_lbl 530 `"Machinery, equipment, and supplies"', add
label define ind1990_lbl 531 `"Scrap and waste materials"', add
label define ind1990_lbl 532 `"Miscellaneous wholesale, durable goods"', add
label define ind1990_lbl 540 `"Paper and paper products"', add
label define ind1990_lbl 541 `"Drugs, chemicals, and allied products"', add
label define ind1990_lbl 542 `"Apparel, fabrics, and notions"', add
label define ind1990_lbl 550 `"Groceries and related products"', add
label define ind1990_lbl 551 `"Farm-product raw materials"', add
label define ind1990_lbl 552 `"Petroleum products"', add
label define ind1990_lbl 560 `"Alcoholic beverages"', add
label define ind1990_lbl 561 `"Farm supplies"', add
label define ind1990_lbl 562 `"Miscellaneous wholesale, nondurable goods"', add
label define ind1990_lbl 571 `"Wholesale trade, n.s.†"', add
label define ind1990_lbl 580 `"Lumber and building material retailing"', add
label define ind1990_lbl 581 `"Hardware stores"', add
label define ind1990_lbl 582 `"Retail nurseries and garden stores"', add
label define ind1990_lbl 590 `"Mobile home dealers"', add
label define ind1990_lbl 591 `"Department stores"', add
label define ind1990_lbl 592 `"Variety stores"', add
label define ind1990_lbl 600 `"Miscellaneous general merchandise stores"', add
label define ind1990_lbl 601 `"Grocery stores"', add
label define ind1990_lbl 602 `"Dairy products stores"', add
label define ind1990_lbl 610 `"Retail bakeries"', add
label define ind1990_lbl 611 `"Food stores, n.e.c."', add
label define ind1990_lbl 612 `"Motor vehicle dealers"', add
label define ind1990_lbl 620 `"Auto and home supply stores"', add
label define ind1990_lbl 621 `"Gasoline service stations"', add
label define ind1990_lbl 622 `"Miscellaneous vehicle dealers"', add
label define ind1990_lbl 623 `"Apparel and accessory stores, except shoe"', add
label define ind1990_lbl 630 `"Shoe stores"', add
label define ind1990_lbl 631 `"Furniture and home furnishings stores"', add
label define ind1990_lbl 632 `"Household appliance stores"', add
label define ind1990_lbl 633 `"Radio, TV, and computer stores"', add
label define ind1990_lbl 640 `"Music stores"', add
label define ind1990_lbl 641 `"Eating and drinking places"', add
label define ind1990_lbl 642 `"Drug stores"', add
label define ind1990_lbl 650 `"Liquor stores"', add
label define ind1990_lbl 651 `"Sporting goods, bicycles, and hobby stores"', add
label define ind1990_lbl 652 `"Book and stationery stores"', add
label define ind1990_lbl 660 `"Jewelry stores"', add
label define ind1990_lbl 661 `"Gift, novelty, and souvenir shops"', add
label define ind1990_lbl 662 `"Sewing, needlework, and piece goods stores"', add
label define ind1990_lbl 663 `"Catalog and mail order houses"', add
label define ind1990_lbl 670 `"Vending machine operators"', add
label define ind1990_lbl 671 `"Direct selling establishments"', add
label define ind1990_lbl 672 `"Fuel dealers"', add
label define ind1990_lbl 681 `"Retail florists"', add
label define ind1990_lbl 682 `"Miscellaneous retail stores"', add
label define ind1990_lbl 691 `"Retail trade, n.s.†"', add
label define ind1990_lbl 700 `"Banking"', add
label define ind1990_lbl 701 `"Savings institutions, including credit unions"', add
label define ind1990_lbl 702 `"Credit agencies, n.e.c."', add
label define ind1990_lbl 710 `"Security, commodity brokerage, and investment companies"', add
label define ind1990_lbl 711 `"Insurance"', add
label define ind1990_lbl 712 `"Real estate, including real estate-insurance offices†"', add
label define ind1990_lbl 721 `"Advertising"', add
label define ind1990_lbl 722 `"Services to dwellings and other buildings"', add
label define ind1990_lbl 731 `"Personnel supply services"', add
label define ind1990_lbl 732 `"Computer and data processing services"', add
label define ind1990_lbl 740 `"Detective and protective services"', add
label define ind1990_lbl 741 `"Business services, n.e.c."', add
label define ind1990_lbl 742 `"Automotive rental and leasing, without drivers"', add
label define ind1990_lbl 750 `"Automobile parking and carwashes"', add
label define ind1990_lbl 751 `"Automotive repair and related services"', add
label define ind1990_lbl 752 `"Electrical repair shops"', add
label define ind1990_lbl 760 `"Miscellaneous repair services†"', add
label define ind1990_lbl 761 `"Private households"', add
label define ind1990_lbl 762 `"Hotels and motels"', add
label define ind1990_lbl 770 `"Lodging places, except hotels and motels"', add
label define ind1990_lbl 771 `"Laundry, cleaning, and garment services"', add
label define ind1990_lbl 772 `"Beauty shops"', add
label define ind1990_lbl 780 `"Barber shops"', add
label define ind1990_lbl 781 `"Funeral service and crematories"', add
label define ind1990_lbl 782 `"Shoe repair shops"', add
label define ind1990_lbl 790 `"Dressmaking shops"', add
label define ind1990_lbl 791 `"Miscellaneous personal services†"', add
label define ind1990_lbl 800 `"Theaters and motion pictures"', add
label define ind1990_lbl 801 `"Video tape rental"', add
label define ind1990_lbl 802 `"Bowling centers"', add
label define ind1990_lbl 810 `"Miscellaneous entertainment and recreation services†"', add
label define ind1990_lbl 812 `"Offices and clinics of physicians"', add
label define ind1990_lbl 820 `"Offices and clinics of dentists"', add
label define ind1990_lbl 821 `"Offices and clinics of chiropractors"', add
label define ind1990_lbl 822 `"Offices and clinics of optometrists"', add
label define ind1990_lbl 830 `"Offices and clinics of health practitioners, n.e.c."', add
label define ind1990_lbl 831 `"Hospitals"', add
label define ind1990_lbl 832 `"Nursing and personal care facilities"', add
label define ind1990_lbl 840 `"Health services, n.e.c."', add
label define ind1990_lbl 841 `"Legal services"', add
label define ind1990_lbl 842 `"Elementary and secondary schools"', add
label define ind1990_lbl 850 `"Colleges and universities"', add
label define ind1990_lbl 851 `"Vocational schools"', add
label define ind1990_lbl 852 `"Libraries"', add
label define ind1990_lbl 860 `"Educational services, n.e.c."', add
label define ind1990_lbl 861 `"Job training and vocational rehabilitation services"', add
label define ind1990_lbl 862 `"Child day care services"', add
label define ind1990_lbl 863 `"Family child care homes"', add
label define ind1990_lbl 870 `"Residential care facilities, without nursing"', add
label define ind1990_lbl 871 `"Social services, n.e.c."', add
label define ind1990_lbl 872 `"Museums, art galleries, and zoos"', add
label define ind1990_lbl 873 `"Labor unions"', add
label define ind1990_lbl 880 `"Religious organizations"', add
label define ind1990_lbl 881 `"Membership organizations, n.e.c."', add
label define ind1990_lbl 882 `"Engineering, architectural, and surveying services"', add
label define ind1990_lbl 890 `"Accounting, auditing, and bookkeeping services"', add
label define ind1990_lbl 891 `"Research, development, and testing services"', add
label define ind1990_lbl 892 `"Management and public relations services"', add
label define ind1990_lbl 893 `"Miscellaneous professional and related services†"', add
label define ind1990_lbl 900 `"Executive and legislative offices"', add
label define ind1990_lbl 901 `"General government, n.e.c."', add
label define ind1990_lbl 910 `"Justice, public order, and safety"', add
label define ind1990_lbl 921 `"Public finance, taxation, and monetary policy"', add
label define ind1990_lbl 922 `"Administration of human resources programs"', add
label define ind1990_lbl 930 `"Administration of environmental quality and housing programs"', add
label define ind1990_lbl 931 `"Administration of economic programs"', add
label define ind1990_lbl 932 `"National security and international affairs†"', add
label define ind1990_lbl 940 `"Army"', add
label define ind1990_lbl 941 `"Air Force"', add
label define ind1990_lbl 942 `"Navy"', add
label define ind1990_lbl 950 `"Marines"', add
label define ind1990_lbl 951 `"Coast Guard"', add
label define ind1990_lbl 952 `"Armed Forces, branch not specified"', add
label define ind1990_lbl 960 `"Military Reserves or National Guard†"', add
label define ind1990_lbl 992 `"Last worked 1984 or earlier"', add
label define ind1990_lbl 999 `"DID NOT RESPOND"', add
label values ind1990 ind1990_lbl

label define classwkr_lbl 0 `"N/A"'
label define classwkr_lbl 1 `"Self-employed"', add
label define classwkr_lbl 2 `"Works for wages"', add
label values classwkr classwkr_lbl

label define classwkrd_lbl 00 `"N/A"'
label define classwkrd_lbl 10 `"Self-employed"', add
label define classwkrd_lbl 11 `"Employer"', add
label define classwkrd_lbl 12 `"Working on own account"', add
label define classwkrd_lbl 13 `"Self-employed, not incorporated"', add
label define classwkrd_lbl 14 `"Self-employed, incorporated"', add
label define classwkrd_lbl 20 `"Works for wages"', add
label define classwkrd_lbl 21 `"Works on salary (1920)"', add
label define classwkrd_lbl 22 `"Wage/salary, private"', add
label define classwkrd_lbl 23 `"Wage/salary at non-profit"', add
label define classwkrd_lbl 24 `"Wage/salary, government"', add
label define classwkrd_lbl 25 `"Federal govt employee"', add
label define classwkrd_lbl 26 `"Armed forces"', add
label define classwkrd_lbl 27 `"State govt employee"', add
label define classwkrd_lbl 28 `"Local govt employee"', add
label define classwkrd_lbl 29 `"Unpaid family worker"', add
label values classwkrd classwkrd_lbl

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

save "`rawdir'/1990.dta", replace
