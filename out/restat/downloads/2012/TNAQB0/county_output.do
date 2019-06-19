clear
set more off
set mem 2500m
set maxvar 32000

**************************************
** reshape both the dumping file and
** output file from wide(year on the 
** x-axis) to long (year on the y-axis
***************************************

#delimit;

*************************************************************************;
* These data are from "manufacturing points full join no bad" from scott ;
*************************************************************************;

use ~/research/pollution/GIS/county_output/manufacturing_points_basins.dta;
drop output*;                    
capture drop _merge;
sort county;
save /Sastemp/manufacturing_points_basins, replace;

***reshape jing's file;
clear;
use ~/data/china/manufacturing/caojing/countyoutput.dta;
rename output98 output1998;
rename output99 output1999;
rename output00 output2000;
rename output01 output2001;
rename output02 output2002;
rename output03 output2003;
rename output05 output2005;

reshape long output ,i(county industry) j(year);
rename output output_;
reshape wide output_,i(county year) j(industry);

#delimit;
label var output_6 "Coal mining and washing";
label var output_7 "Oil and natural gas mining industry";
label var output_8 "Ferrous (containing iron) ore mining industry";
label var output_9 "Non-ferrous ore mining industry";
label var output_10 "Non-metal ore mining industry";
label var output_11 "Other mining";
label var output_13 "Agriculture and foodstuff processing industry";
label var output_14 "Food manufacturing";
label var output_15 "Beverage manufacturing";
label var output_16 "Tobacco manufacturing industry";
label var output_17 "Sewing/textile industry";
label var output_18 "Apparel/shoes/hats manufacturing industry";
label var output_19 "Leather/fur/feather industry";
label var output_20 "Timber processing, plus wood, bamboo, rattan etc";
label var output_21 "Furniture manufacturing";
label var output_22 "Paper and paper products industry";
label var output_23 "Printing and media recording reproduction industry";
label var output_24 "Stationery and sporting goods manufacturing industry";
label var output_25 "Petroleum processing, refining and nuclear fuel industry";
label var output_26 "Chemical materials and chemical products manufacturing industry";
label var output_27 "Medicine production industry";
label var output_28 "Chemical fibre manufacturing industry";
label var output_29 "Rubber products industry";
label var output_30 "Plastic products industry";
label var output_31 "Non metallic mineral products industry";
label var output_32 "Ferrous metal smelting and rolling processing industry";
label var output_33 "Non-ferrous metal smelting and rolling processing industry";
label var output_34 "Fabricating metal products (creating metallic products)";
label var output_35 "General equipment manufacturing";
label var output_36 "Specialized equipment manufacturing";
label var output_37 "Traportation equipment manufacturing";
label var output_39 "Electrical machinery and equipment manufacturing";
label var output_40 "Communications devices, computers and other electronics manufacturing";
label var output_41 "Instuments, meters and office equipment manufacturing";
label var output_42 "Handicraft manufacturing and others";
label var output_43 "Waste materials recycling industry";
label var output_44 "Producer and supplier of electricity and thermal energy ";
label var output_45 "Producer and supplier of natural gas";
label var output_46 "Producer and supplier of water";

sort county;
merge county using /Sastemp/manufacturing_points_basins;
tab _merge;

save ~/research/pollution/datafiles/county_output.dta, replace;
