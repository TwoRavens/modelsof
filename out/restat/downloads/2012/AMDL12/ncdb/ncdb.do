#delimit;
clear;
set more off;
set memory 1500m;
set matsize 1000;
cd "C:\Files\pp\restat\ncdb";
graph set eps fontface Garamond;
graph set print logo off;

*I CREATED THIS EXTRACT FROM GEOLYTICS NCDB ON JANUARY 9, 2009;
*THE FILE CAN BE USED WITH GEOLYTICS SOFTWARE TO RUN ALTERNATIVE EXTRACTION;
*THESE DATA DESCRIBE ALL 65,000+ CENSUS TRACTS IN THE UNITED STATES;
*THE .DBF FILES CREATED BY ARCMAP WERE THEN BROUGHT INTO EXCEL AND SAVED AS CSV FILES;

insheet using ncdb.csv;

*---------------------------------------------*
*-------CALCULATE DEPENDENT VARIABLES---------*
*---------------------------------------------*;
*CREATE MEAN HOUSE VALUE AND MEAN RENT;
foreach x of numlist 7 8 9 0 {; gen meanprice`x'=aggval`x'/spownoc`x';  };
foreach x of numlist   8 9 0 {; gen meanrent`x'=aggrent`x'/rentrto`x';  };
gen meanrent7=agcrtr07/rentrto7;


*-------------------------------------------*
*------CREATE HOUSING CHARACTERISTICS-------*
*-------------------------------------------*;
*BEDROOMS; foreach x of numlist 7 8 9 0 {;
gen bed0`x'=bdtot0`x'/tothsun`x';
gen bed1`x'=bdtot1`x'/tothsun`x';
gen bed2`x'=bdtot2`x'/tothsun`x';
gen bed3`x'=bdtot3`x'/tothsun`x';
gen bed4`x'=bdtot4`x'/tothsun`x';
gen bed5`x'=bdtot5`x'/tothsun`x';  }; drop bdtot*; 

*NUMBER OF UNITS; foreach x of numlist 7 8 9 0 {;
gen units1`x'=ttunit1`x'/tothsun`x';
gen units2`x'=ttunit2`x'/tothsun`x';
gen units3`x'=ttunit3`x'/tothsun`x';
gen units4`x'=ttunit4`x'/tothsun`x';
gen units5`x'=ttunit5`x'/tothsun`x'; 
gen unitsm`x'=ttunitm`x'/tothsun`x'; }; drop ttunit*;

*YEAR BUILT  --- 1990s;
gen built19=bltyr909/tothsun9; *Built within last year;
gen built29=bltyr889/tothsun9; *Built two to five years ago;
gen built39=bltyr849/tothsun9; *Built six to ten years ago;
gen built49=bltyr799/tothsun9; *Built ten to twenty years ago;
gen built59=bltyr699/tothsun9; *Built twenty to thirty years ago;
gen built69=bltyr599/tothsun9; *Built thirty to forty years ago;
gen built79=(bltyr499+bltyr399)/tothsun9; *Built forty or more years ago;

*YEAR BUILT  --- 1980s;
gen built18=bltyr808/tothsun8; *Built within last year;
gen built28=bltyr788/tothsun8; *Built two to five years ago;
gen built38=bltyr748/tothsun8; *Built six to ten years ago;
gen built48=bltyr698/tothsun8; *Built ten to twenty years ago;
gen built58=bltyr598/tothsun8; *Built twenty to thirty years ago;
gen built68=bltyr498/tothsun8; *Built thirty to forty years ago;
gen built78=bltyr398/tothsun8; *Built forty or more years ago;

*YEAR BUILT  --- 1970s;                                                         
gen built17=bltto707/tothsun7; *Built within last year;
gen built27=bltto687/tothsun7; *Built two to five years ago;
gen built37=bltto647/tothsun7; *Built six to ten years ago;
gen built47=bltto597/tothsun7; *Built ten to twenty years ago;
gen built57=bltto497/tothsun7; *Built twenty to thirty years ago;
gen built67=bltto397/tothsun7; *Built thirty to forty years ago;
gen built77=bltto397/tothsun7; *Built forty or more years ago;
drop bltto*;

*OTHER; foreach x of numlist 7 8 9 0 {;
gen occupied`x'=occhu`x'/tothsun`x';
gen ownoccup`x'=ownocc`x'/tothsun`x';
gen plumbing`x'=plmbt`x'/tothsun`x';}; drop plmb*;

foreach x of numlist 7 8 9 {;
local HousingCharacteristics19`x'0="occhu`x' rntocc`x' ownoccup`x' occupied`x' bed0`x' bed1`x' bed2`x' bed3`x' bed4`x' bed5`x' units1`x' units2`x' 
						units3`x' units4`x' units5`x' unitsm`x' built1`x' built2`x' built3`x' built4`x' built5`x'
						built6`x' built7`x' plumbing`x'"; };

/*; Housing Characteristics: total owner-occupied housing units; total renter-occupied housing units;
percent of total housing units that are owner occupied; percent of total housing units that are occupied; 
percent of housing units with 0, 1, 2, 3, 4, and 5 or more bedrooms; percent of total housing units that 
are single-unit detached; percent of total housing units that are single-unit attached; percent of total 
housing units that consist of 2, 3-4, and 5+ units, percent of total housing units that are mobile homes; 
percent of total housing units built within the past year, 2 to 5 years ago, 6 to 10 years ago, 10 to 20 
years ago, 20 to 30 years ago, 30 to 40 years ago, more than 40 years ago; and percent of total housing 
units with all plumbing facilities. */;


*-------------------------------------------*
*---------CREATE ECONOMIC CONDITIONS--------*
*-------------------------------------------*;
*PERCENT PERSONS BELOW POVERTY LINE;
foreach x of numlist 8 9 0 {;
gen poverty`x'=ltpovl`x'/trctpop`x'; };
gen poverty7=povrat7n/povrat7d; drop ltpovl* povrat*;

*DOLLAR AMOUNTS ARE IN YEAR 2000 DOLLARS (CPI BLS);
*116.3 (1970), 246.8 (1980), 391.4 (1990), 515.8 (2000);
foreach x in "meanprice" "meanrent" "avhhin" {;
replace `x'7=`x'7*515.8/116.3;
replace `x'8=`x'8*515.8/246.8;
replace `x'9=`x'9*515.8/391.4; };

*GENERATE CUBIC IN AVERAGE HOUSEHOLD INCOME;
foreach x of numlist 7 8 9 {;
gen avhhinsq`x'=(avhhin`x')^2; 
gen avhhincu`x'=(avhhin`x')^3; };

foreach x of numlist 7 8 9 {;
local EconomicConditions19`x'0="avhhin`x' avhhinsq`x' avhhincu`x' poverty`x' welfare`x'"; };

/*; Economic Conditions: Mean household income (cubic), percent of total persons with income below the poverty line,
unemployment rate, and percent of households with public assistance income last year. */;


*-------------------------------------------*
*-------------CREATE DEMOGRAPHICS-----------*
*-------------------------------------------*;
*POPULATION DENSITY AND EDUCATIONAL ATTAINMENT;
foreach x of numlist 7 8 9 0 {;
gen popdensity`x'=trctpop`x'/arealanm;
gen hsgrad`x'=educ12`x'/educpp`x';  
gen college`x'=educ16`x'/educpp`x'; };
drop educ*;

foreach x of numlist 7 8 9 {;
local Demographics19`x'0="popdensity`x' shrblk`x' shrhsp`x' child`x' old`x' hsgrad`x' college`x'"; };

/*; Demographics: Population density, percent of population Black, percent of population Hispanic,
percent of population under age 18, percent of population 65 or older, percent of population
over age 25 without a high school degree, percent of population over age 25 with a college degree.; */;

save ncdb.dta, replace;

