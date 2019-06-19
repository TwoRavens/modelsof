clear
cd "C:\Users\Hernan\Dropbox\Documents\Leah\census 2000 - 2"
set mem 500m
insheet using dc_dec_2000_sf3_u_data1.txt


label var geo_id		"Geography Identifier                                                          "
label var geo_id2		"Geography Identifier							       "
label var sumlevel		"Geographic Summary Level						       "
label var geo_name		"Geography								       "
label var p076001		"Families: Total                              "
label var p076002		"Families: Family income; Less than $10;000   "
label var p076003		"Families: Family income; $10;000 to $14;999  "
label var p076004		"Families: Family income; $15;000 to $19;999  "
label var p076005		"Families: Family income; $20;000 to $24;999  "
label var p076006		"Families: Family income; $25;000 to $29;999  "
label var p076007		"Families: Family income; $30;000 to $34;999  "
label var p076008		"Families: Family income; $35;000 to $39;999  "
label var p076009		"Families: Family income; $40;000 to $44;999  "
label var p076010		"Families: Family income; $45;000 to $49;999  "
label var p076011		"Families: Family income; $50;000 to $59;999  "
label var p076012		"Families: Family income; $60;000 to $74;999  "
label var p076013		"Families: Family income; $75;000 to $99;999  "
label var p076014		"Families: Family income; $100;000 to $124;999"
label var p076015		"Families: Family income; $125;000 to $149;999"
label var p076016		"Families: Family income; $150;000 to $199;999"
label var p076017		"Families: Family income; $200;000 or more    "
label var p078001		"Families: Aggregate family income in 1999    "


label var p008035	"Total population: Male; 65 and 66 years                                                     "
label var p008036	"Total population: Male; 67 to 69 years							     "
label var p008037	"Total population: Male; 70 to 74 years							     "
label var p008038	"Total population: Male; 75 to 79 years							     "
label var p008039	"Total population: Male; 80 to 84 years							     "
label var p008040	"Total population: Male; 85 years and over						     "
label var p008074	"Total population: Female; 65 and 66 years						     "
label var p008075	"Total population: Female; 67 to 69 years						     "
label var p008076	"Total population: Female; 70 to 74 years						     "
label var p008077	"Total population: Female; 75 to 79 years						     "
label var p008078	"Total population: Female; 80 to 84 years						     "
label var p008079	"Total population: Female; 85 years and over						     "
label var p001001	"Total population: Total								     "
label var p087001	"Population for whom poverty status is determined: Total				     "
label var p087002	"Population for whom poverty status is determined: Income in 1999 below poverty level	     "
label var p006003	"Total population: Black or African American alone					     "
label var p007010	"Total population: Hispanic or Latino							     "


* Population over 65 years

egen aux=rsum(p008035 p008036 p008037 p008038 p008039 p008040 p008074 p008075 p008076 p008077 p008078 p008079)
gen share65=aux/p001001

* Mean income

gen mean_income=p078001/p076001

*Share blacks

gen share_black=p006003/p001001


*share hispanic
gen share_hisp=p007010/p001001

* Poverty

gen poverty_rate= p087002/p087001 

*population
rename p001001 population


keep geo_id2    geo_name        p076001 p076002 p076003 p076004 p076005 p076006 p076007 p076008 p076009 p076010 p076011 p076012 p076013 p076014 p076015 p076016 p076017 p078001  p087001 p087002 p006003 p007010 share65 mean_income share_black share_hisp poverty_rate population


compress
save dc_dec_2000_sf3_u_data1.dta, replace





