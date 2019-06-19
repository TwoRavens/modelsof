#delimit;
clear;
set more off;

global temp /Sastemp;
global path ~;
set mem 500m;

/*================================================
 Program: census_data.do
 Author:  Avi Ebenstein modified Alison Flamm
 Created: August 2007 modified August 2008
 Purpose: Gather information about the counties from census
=================================================*/

use ~/data/china/china2000/gis2000/datafiles/ch2000_counties.dta;
bysort CNTYGB: keep if _n==1;

****************************;

rename A2000001 pop; label var pop "Total Population";
rename A2000002 pop_male; label var pop_male "Total population-male";
rename A2000003 pop_female; label var pop_female "Total
population-female";
rename A2000006 minority_prc; label var minority_prc "The percentage
of minority population";
rename A2000007 minority_total; label var minority_total "Total
minority population";
rename A2000008 non_ag_prc; label var non_ag_prc "The percentage of
non-agriculture population";
rename A2000009 non_ag_pop; label var non_ag_pop "Total
non-agriculture population ";
rename A2000010  urban; label var urban "Urban population";
rename A2000011 rural; label var rural "Rural population";
rename A2000058 kids; label var kids "The percentage of population
1-14 years old (%)";
rename A2000059 adults; label var adults "The percentage of population
15-64 years old (%)";
rename A2000060  elderly; label var elderly "The percentage of
population 65 and over (%)";
rename A2000066 birthrate; label var birthrate "Birth rate (per
thousand)";
rename A2000067 deathrate; label var deathrate "Death rate (per
thousand)";
rename A2000091  education; label var education "Average years at
schools";
rename A2000092  education_male; label var education_male "Average
years at schools - male";
rename A2000093 education_female; label var education_female "Average
years at schools - female";
rename A2000094 illiterate; label var illiterate "Illiterate
population for age 15 and over";
rename A2000101 rooms1; label var rooms1 "Average rooms per household
(rooms/household)";
rename ECITY city; label var city "Prefecture City name in English";
rename ECNTY county; label var county "County name in English";
rename EPROV province; label var province "Province name in English";
rename L2000166 farming1; label var farming1 "Employed population of
Farming, forestry, husbandry, fishing and";
rename L2000167 production; label var production "Employed population
of production and transportation";
rename L2000177 industries; label var industries "Total employed
population in industries";
rename L2000178 farming2; label var farming2 "Total employed
population in Farming, Forestry, Animal Husbandry, and Fishery";
rename L2000180 manufacturing1; label var manufacturing1 "Total
employed population in Manufacturing";
rename L2000220 tap_water1; label var tap_water1 "Total family
households with tap water";
rename L2000221 no_tap_water1; label var no_tap_water1 "Total family
households with no tap water";
rename L401001 totemployed; label var totemployed "P Total employed";
rename L401007 farming3; label var farming3 "P Farming";
rename L401010 forestry; label var forestry "P Forestry";
rename L401013 husbandry; label var husbandry "P Animal Husbandry";
rename L401016 fishery; label var fishery "P Fishery";
rename L401019 ag_services; label var ag_services "P Agricultural
Services";
rename L401022 mining; label var mining "P Mining and Quarrying";
rename L401025 coal_mining; label var coal_mining "P Coal Mining and
Dressing";
rename L401028 petroleum1; label var petroleum1 "P Extraction of
petroleum and Natural Gas";
rename L401031 ferrous; label var ferrous "P Mining and Dressing of
Ferrous Metals";
rename L401034 nonferrous; label var nonferrous "P Mining and Dressing
of Nonferrous Metals";
rename L401037 nonmetal; label var nonmetal "P Mining and Dressing of
Nonmetal Minerals";
rename L401040 other_minerals; label var other_minerals "P Mining and
Dressing of Other Minerals";
rename L401043 logging; label var logging "P Logging and Transport of
Wood and Bamboo";
rename L401046 manufacturing2; label var manufacturing2 "P
Manufacturing";
rename L401049 food_processing; label var food_processing "P Food
Processing";
rename L401052 food_prod; label var food_prod "P Food Production";
rename L401055 beverages; label var beverages "P Beverages";
rename L401058 tobacco; label var tobacco "P Tobacco";
rename L401061 textiles1; label var textiles1 "P Textiles";
rename L401064 garments; label var garments "P Garments and Other
Fiber Products";
rename L401067 leather; label var leather "P Leather, Furs, Down and
Related Products";
rename L401070 timber; label var timber "P Timber Processing, Bamboo,
Cane, Palm Fiber and Straw Products";
rename L401073 furniture; label var furniture "P Furniture
Manufacturing";
rename L401076 paper; label var paper "P Papermaking and Paper
Products";
rename L401079 printing; label var printing "P Printing and Record
Medium Reproduction";
rename L401082 cultural; label var cultural "P Cultural, Educational
and Sports Goods";
rename L401085 petroleum2; label var petroleum2 "P Petroleum
Processing and Coking";
rename L401088 chemicals; label var chemicals "P Raw Chemical
Materials and Chemical Products";
rename L401091 medical; label var medical "P Medical and
Pharmaceutical Products";
rename L401094 fiber; label var fiber "P Chemical Fiber";
rename L401097 rubber; label var rubber "P Rubber Products";
rename L401100 plastic; label var plastic "P Plastic Products";
rename L401103 mineral; label var mineral "P Nonmetal Mineral
Products";
rename L401106 ferrous2; label var ferrous2 "P Smelting and Pressing
of Ferrous Metals";
rename L401109 nonferrous2; label var nonferrous2 "P Smelting and
Pressing of Nonferrous Metals";
rename L401112 metal; label var metal "P Metal Products";
rename L401115 machinery; label var machinery "P Ordinary Machinery";
rename L401118 equipment; label var equipment "P Equipment for Special
Purposes";
rename L401121 transport; label var transport "P Transport Equipment";
rename L401124 weapons; label var weapons "P Weapons and ammunitions";
rename L401127 electric; label var electric "P Electric Equipment and
Machinery";
rename L401130 electronic; label var electronic "P Electronic and
Telecommunications Equipment";
rename L401133 instruments; label var instruments "P Instruments,
Meters, Cultural and Office Machinery";
rename L401136 manufacturing_other; label var manufacturing_other "P
Other Manufacturing";
rename L401181 pipeline; label var pipeline "P Pipeline Transport";
rename L401184 waterway; label var waterway "P Waterway Transport";
rename L401277 health_care; label var health_care "P Health Care";
rename L402160 textiles2; label var textiles2 "Employed population of
Textile,Knitting,Prints and Dye Personnel";
rename L802002 rooms2; label var rooms2 "Total No. of Room";
rename L802003 floor_space; label var floor_space "Total No. of Floor
Space";
rename L803005 gas; label var gas "Number of H of Main Cooking Fuel:
Gas";
rename L803006 electricity; label var electricity "Number of H of Main
Cooking Fuel: Electricity";
rename L803007 coal; label var coal "Number of H of Main Cooking Fuel:
Coal";
rename L803008 firewood; label var firewood "Number of H of Main
Cooking Fuel: Firewood";
rename L803009 fuel_other; label var fuel_other "Number of H of Main
Cooking Fuel: Other";
rename L803010 tap_water2; label var tap_water2 "Number of H :Using
Tap Water";
rename L803011 no_tap_water2; label var no_tap_water2 "Number of H :No
Tap Water";
rename L803012 central_hot; label var central_hot "Number of H
:Centralized Support the Hot Water";
rename L803013 water_heater; label var water_heater "Number of H :the
family installs the water H eater by oneself";
rename L805003 yuan1; label var yuan1 "No. of Family
households:10,000-20,000 Yuan";
rename L805004 yuan2; label var yuan2 "No. of Family
households:20,000-30,000 Yuan";
rename L805005 yuan3; label var yuan3 "No. of Family
households:30,000-50,000 Yuan";
rename L805006 yuan4; label var yuan4 "No. of Family
households:50,000-100,000 Yuan";
rename L805007 yuan5; label var yuan5 "No. of Family
households:100,000-200,000 Yuan";
rename L805008 yuan6; label var yuan6 "No. of Family
households:200,000-300,000 Yuan";
rename L805009 yuan7; label var yuan7 "No. of Family
households:300,000-500,000 Yuan";
rename L805010 yuan8; label var yuan8 "No. of Family
households:500,000 Yuan and Over";
rename L806002 yuanA; label var yuanA "No. of Family households: Under
20 Yuan";
rename L806003 yuanB; label var yuanB "No. of Family households:20-50
Yuan";
rename L806004 yuanC; label var yuanC "No. of Family households:50-100
Yuan";
rename L806005 yuanD; label var yuanD "No. of Family
households:100-200 Yuan";
rename L806006 yuanE; label var yuanE "No. of Family
households:200-500 Yuan";
rename L806007 yuanF; label var yuanF "No. of Family
households:500-1000 Yuan";
rename L806008 yuanG; label var yuanG "No. of Family
households:1000-1500 Yuan";
rename L806009 yuanH; label var yuanH "No. of Family
households:1500-2000 Yuan";
rename L806010 yuanI; label var yuanI "No. of Family households:2000
Yuan and Over";


/*
Here are a few extra variables to consider keeping
rename A2000020 m0to1;
rename A2000021 f0to1;
rename A2000022 m1to4;
rename A2000023 f1to4;
rename A2000024 m5to9;
rename A2000025 f5to9;
rename A2000026 m10to14;
rename A2000027 f10to14;
rename A2000028 m15to19;
rename A2000029 f15to19;
rename A2000069 tfr;

rename L102004 empmale;
rename L102005 empfmale;
rename L102011 manumale;
rename L102012 manufmale;
rename L101007 srpop;
rename L107008 sr1;
rename L107012 sr2;
rename L107016 sr3;
rename L107020 sr4;
rename L107024 sr5;
rename L107009 secondbirth;
rename L107013 thirdbirth;
rename L107017 fourthbirth;
rename L107021 fifthbirth;

gen sr0to1=(m0to1/f0to1*100);
gen sr1to4=(m1to4/f1to4*100);
gen sr5to9=(m5to9/f5to9*100);
gen sr10to14=(m10to14/f10to14*100);
gen sr15to19=(m15to19/f15to19*100);
gen sr0to9=((m0to1+m1to4+m5to9)/(f0to1+f1to4+f5to9)*100);
gen sr10to19=((m10to14+m15to19)/(f10to14+f15to19)*100);
*/
  
drop A* L*;

******************************;
* Create percentage variables ;
******************************;

gen manu_share=manufacturing1/totemployed;
gen yuan_num=yuan1+yuan2+yuan3+yuan4+yuan5+yuan6+yuan7+yuan8;
gen
yuan_letters=yuanA+yuanB+yuanC+yuanD+yuanE+yuanF+yuanG+yuanH+yuanI;

*****************************;


**************;
* Find shares ;
**************;

gen share_gas=(gas/(gas+electricity+coal+firewood+other));
gen
share_electricity=(electricity/(gas+electricity+coal+firewood+other));
gen share_coal=(coal/(gas+electricity+coal+firewood+other));
gen share_firewood=(firewood/(gas+electricity+coal+firewood+other));
gen share_other_cooking=(other/(gas+electricity+coal+firewood+other));
gen share_tap_water1=tap_water1/(tap_water1+no_tap_water1);
gen share_no_tap_water1=no_tap_water1/(tap_water1+no_tap_water1);
gen share_totemployed=totemployed/totemployed;
gen share_farming3=farming3/totemployed;
gen share_forestry=forestry/totemployed;
gen share_husbandry=husbandry/totemployed;
gen share_fishery=fishery/totemployed;
gen share_ag_services=ag_services/totemployed;
gen share_mining=mining/totemployed;
gen share_coal_mining=coal_mining/totemployed;
gen share_petroleum1=petroleum1/totemployed;
gen share_ferrous=ferrous/totemployed;
gen share_nonferrous=nonferrous/totemployed;
gen share_nonmetal=nonmetal/totemployed;
gen share_other_minerals=other_minerals/totemployed;
gen share_logging=logging/totemployed;
gen share_manufacturing2=manufacturing2/totemployed;
gen share_food_processing=food_processing/totemployed;
gen share_food_prod=food_prod/totemployed;
gen share_beverages=beverages/totemployed;
gen share_tobacco=tobacco/totemployed;
gen share_textiles1=textiles1/totemployed;
gen share_garments=garments/totemployed;
gen share_leather=leather/totemployed;
gen share_timber=timber/totemployed;
gen share_furniture=furniture/totemployed;
gen share_paper=paper/totemployed;
gen share_printing=printing/totemployed;
gen share_cultural=cultural/totemployed;
gen share_petroleum2=petroleum2/totemployed;
gen share_chemicals=chemicals/totemployed;
gen share_medical=medical/totemployed;
gen share_fiber=fiber/totemployed;
gen share_rubber=rubber/totemployed;
gen share_plastic=plastic/totemployed;
gen share_mineral=mineral/totemployed;
gen share_ferrous2=ferrous2/totemployed;
gen share_nonferrous2=nonferrous2/totemployed;
gen share_metal=metal/totemployed;
gen share_machinery=machinery/totemployed;
gen share_equipment=equipment/totemployed;
gen share_transport=transport/totemployed;
gen share_weapons=weapons/totemployed;
gen share_electric=electric/totemployed;
gen share_electronic=electronic/totemployed;
gen share_instruments=instruments/totemployed;
gen share_manufacturing_other=manufacturing_other/totemployed;
gen share_pipeline=pipeline/totemployed;
gen share_waterway=waterway/totemployed;
gen share_health_care=health_care/totemployed;
gen share_textiles2=textiles2/(health_care+textiles2);
gen share_tap_water2=tap_water2/(tap_water2+no_tap_water2);
gen share_no_tap_water2=no_tap_water2/(tap_water2+no_tap_water2);
gen share_central_hot=central_hot/(central_hot+water_heater);
gen share_water_heater=water_heater/(central_hot+water_heater);
gen share_yuan1=yuan1/yuan_num;
gen share_yuan2=yuan2/yuan_num;
gen share_yuan3=yuan3/yuan_num;
gen share_yuan4=yuan4/yuan_num;
gen share_yuan5=yuan5/yuan_num;
gen share_yuan6=yuan6/yuan_num;
gen share_yuan7=yuan7/yuan_num;
gen share_yuan8=yuan8/yuan_num;
gen share_yuanA=yuanA/yuan_letters;
gen share_yuanB=yuanB/yuan_letters;
gen share_yuanC=yuanC/yuan_letters;
gen share_yuanD=yuanD/yuan_letters;
gen share_yuanE=yuanE/yuan_letters;
gen share_yuanF=yuanF/yuan_letters;
gen share_yuanG=yuanG/yuan_letters;
gen share_yuanH=yuanH/yuan_letters;
gen share_yuanI=yuanI/yuan_letters;



*********************;
* repeated variable! ;
*********************;

rename production prodworkers;
rename urban urbpop;

drop _merge;
sort CNTYGB;

do ~/data/china/china2000/gis2000/dofiles/cntygb_gbcode.do;

save ~/pollution/datafiles/census_data, replace;
