*******************************************************************************************************************
*
* To run this datamanagement-file you need the three replication datasets provided by    
* Collier and Hoeffler (2004) - g&g , Fearon and Laitin (2003) - repdata Humphreys (2005) - MH8JCR05.
* Detailed references can be found below. 
*                                                                                        
* In addition, the authors have compiled two additional datasets (available on the website):                        
*
* 1. Civil war onset dataset (onset_variables.dta) with 
*    a) the Collier-Hoeffler onset variable and
*    b) two new onset variables constructed from the UCDP/PRIO conflict database following the 
*       Collier-Hoeffler setup (5-year-periods): The first onset variable is coded 1 for the onset 
*       of any conflict with more than 25 battle-related deaths in at least one of the years of 
*       the 5-year-spell (all conflicts); the second variable only for those with at least 1000 
*       battle-related deaths in one of the years (war).
*       For details on the underlying dataset see          
*       - Gleditsch, Nils Petter, Peter Wallensteen, Mikael Eriksson, Margareta Sollenberg, 
*         and Håvard Strand, 2002. Armed conflict 1946-2001: A new dataset. Journal of Peace Research 39 (5): 615-37.
*    Name of the datafile: 
*
* 2. Dataset that matches the main dataset with the PRIO country-codes: match_country_ch_prio.dta
*
*******************************************************************************************************************

*******************************************************************************************************************
* Matthias Basedau, German Institute for Global and Area Studies, Hamburg, Germany
* Jann Lay, Kiel Institute for the World Economy, Germany (Author of the STATA-codes)
*******************************************************************************************************************

#delimit;
clear;
set mem 400m;
set more off;

tempfile fearlait fearlait_right1 fearlait_right2
         humphreys humphreys_oil1 humphreys_oil2 
         collhoeff
         temp1 temp2 temp3; 

*** Collier, Paul & Anke Hoeffler, 2004. ‘Greed and grievance in civil war’
*** Oxford Economic Papers 56(4): 563-595.
*** dataset available at http://users.ox.uk/~ball0144/g&g.zip ;

use g&g, clear;

drop if 
country == "Bahamas" |
country == "Barbados" |
country == "Belize" |
country == "Cape Verde" |
country == "Comoros" |
country == "Grenada" |
country == "Hong Kong" |
country == "Iceland" |
country == "Luxembourg" |
country == "Malta" |
country == "Puerto Rico" |
country == "Qatar" |
country == "Reunion" |
country == "Seychelles" |
country == "Solomon Islands" |
country == "St. Kitts and Nevis" |
country == "St. Lucia" |
country == "St. Vincent" |
country == "Suriname" | 
country == "Tonga" |
country == "Vanuatu" |
country == "West Samoa" |
country == "Zaire" |
country == "Yemen";

replace country = "Burma" if country == "Myanmar/Burma";
replace country = "Uk" if country == "United Kingdom";
replace country = "U. Arab Emirates" if country == "United Arab Emirates";
replace country = "Us" if country == "U.S.A.";
replace country = "Germanyfed. Rep." if country == "Germany";

sort id;
save `temp1', replace; 

collapse (mean) id, by(country);
sort country;
tab country;
gen ide = _n;
sort id;
save `temp2', replace;

merge id using `temp1';
tab _merge; drop _merge;

gen double ideyear = year*1000+ide;
sort ideyear;
rename country country_ch;

save `collhoeff', replace;

*** Fearon, James D. and David Laitin, 2003. ‘Ethnicity, Insurgency, and Civil War’
*** American Political Science Review 97 (1): 75-90.
*** dataset available at http://stanford.edu/~jfearon/data/ap;

use repdata, clear;

drop if 
country == "ALBANIA" |
country == "ARMENIA" |
country == "BELARUS" |
country == "CROATIA" |
country == "CUBA" |
country == "CZECHREP" |
country == "ESTONIA" |
country == "DEM. REP. CONGO" |
country == "GERMAN DEM. REP." |
country == "KAZAKHSTAN" |
country == "KYRGYZSTAN" |
country == "LATVIA" |
country == "LIBYA" |
country == "LITHUANIA" |
country == "N. KOREA" |
country == "SLOVAKIA" |
country == "TURKMENISTAN" |
country == "UKRAINE" |             
country == "UZBEKISTAN" |
country == "ERITREA" |
country == "MACEDONIA" |
country == "SLOVENIA" |
country == "VIETNAM, S." |
country == "YEMEN";
    
sort ccode;
save `temp1', replace; 

collapse ccode, by(country);
sort country;
tab country;
gen ide = _n;
sort ccode;
save `temp2', replace;

merge ccode using `temp1';
tab _merge; drop _merge;

sort ide;
save `fearlait', replace;

*** Humphreys, Macartan, 2005. ‘Natural Resources, Conflict and Conflict Resolution’,
*** Journal of Conflict Resolution 49(4): 508-537.
*** dataset available at http://columbia.edu/~mh2245/papers1/MH8JCR05.zip;

use MH8JCR05, clear;

drop if 
country == "ALBANIA" |
country == "ARMENIA" |
country == "BELARUS" |
country == "CROATIA" |
country == "CUBA" |
country == "CZECHREP" |
country == "ESTONIA" |
country == "DEM. REP. CONGO" |
country == "GERMAN DEM. REP." |
country == "KAZAKHSTAN" |
country == "KYRGYZSTAN" |
country == "LATVIA" |
country == "LIBYA" |
country == "LITHUANIA" |
country == "N. KOREA" |
country == "SLOVAKIA" |
country == "TURKMENISTAN" |
country == "UKRAINE" |             
country == "UZBEKISTAN" |
country == "YEMEN";

*unify Germany;
replace iso = 280 if iso == 276;
*and Ethiopia;
replace iso = 230 if iso == 231;

sort iso;
save `temp1', replace; 

collapse iso, by(country);
sort country;
tab country;
gen ide = _n;
sort iso;
save `temp2', replace;

merge iso using `temp1';
tab _merge; drop _merge;

sort ide;
save `humphreys', replace;


*** Manipulating Fearon and Laitin's (2003) data;

use `fearlait', clear;

gen period = 1 if year >= 1960 & year <= 1964;
replace period = 2 if year >= 1965 & year <= 1969;
replace period = 3 if year >= 1970 & year <= 1974;
replace period = 4 if year >= 1975 & year <= 1979;
replace period = 5 if year >= 1980 & year <= 1984;
replace period = 6 if year >= 1985 & year <= 1989;
replace period = 7 if year >= 1990 & year <= 1994;
replace period = 8 if year >= 1995 & year <= 1999;

gen double period_ide = period*1000+ide;

rename country country_fl;

* average growth based on FL GDP data;
gen d1960 = year == 1960;
gen d1964 = year == 1964;
gen d1965 = year == 1965;
gen d1969 = year == 1969;
gen d1970 = year == 1970;
gen d1974 = year == 1974;
gen d1975 = year == 1975;
gen d1979 = year == 1979;
gen d1980 = year == 1980;
gen d1984 = year == 1984;
gen d1985 = year == 1985;
gen d1989 = year == 1989;
gen d1990 = year == 1990;
gen d1994 = year == 1994;

egen gdp1960 = sum(gdpen*d1960), by(period_ide);
egen gdp1964 = sum(gdpen*d1964), by(period_ide);
egen gdp1965 = sum(gdpen*d1965), by(period_ide);
egen gdp1969 = sum(gdpen*d1969), by(period_ide);
egen gdp1970 = sum(gdpen*d1970), by(period_ide);
egen gdp1974 = sum(gdpen*d1974), by(period_ide);
egen gdp1975 = sum(gdpen*d1975), by(period_ide);
egen gdp1979 = sum(gdpen*d1979), by(period_ide);
egen gdp1980 = sum(gdpen*d1980), by(period_ide);
egen gdp1984 = sum(gdpen*d1984), by(period_ide);
egen gdp1985 = sum(gdpen*d1985), by(period_ide);
egen gdp1989 = sum(gdpen*d1989), by(period_ide);
egen gdp1990 = sum(gdpen*d1990), by(period_ide);
egen gdp1994 = sum(gdpen*d1994), by(period_ide);

gen growth_fl = ln(gdp1964/gdp1960)/4 if year == 1960;
replace growth_fl = ln(gdp1969/gdp1965)/4 if year == 1965;
replace growth_fl = ln(gdp1974/gdp1970)/4 if year == 1970;
replace growth_fl = ln(gdp1979/gdp1975)/4 if year == 1975;
replace growth_fl = ln(gdp1984/gdp1980)/4 if year == 1980;
replace growth_fl = ln(gdp1989/gdp1985)/4 if year == 1985;
replace growth_fl = ln(gdp1994/gdp1990)/4 if year == 1990;

replace growth_fl = growth_fl*100;

* new states (nwstate, is 1 for the first two years of state existence): sum over 5 years
* for non-noncontiguous state (ncontig) and polity (polity2) we use means over the preceding 5 years;

global rhs_vars "nwstate_FL_mod gdp_FL_mod ncontig_FL_mod polity2_FL_mod";

egen nwstate_FL_mod = sum(nwstate), by(period_ide);
replace nwstate_FL_mod = 1 if nwstate_FL_mod > 1;
egen gdp_FL_mod = mean(gdpenl), by(period_ide);
egen ncontig_FL_mod = sum(ncontig), by(period_ide);
replace ncontig_FL_mod = 1 if ncontig_FL_mod > 1;
egen polity2_FL_mod = mean(polity2), by(period_ide);


keep if year == 1960 | year == 1965 | year == 1970 | year == 1975 | year == 1980 | year == 1985
                     | year == 1990;

keep ide year $rhs_vars growth_fl;

replace year = 1995 if year == 1990;            
replace year = 1990 if year == 1985;
replace year = 1985 if year == 1980;
replace year = 1980 if year == 1975;
replace year = 1975 if year == 1970;
replace year = 1970 if year == 1965;
replace year = 1965 if year == 1960;

gen double ideyear = year*1000+ide;

sort ideyear;

save `fearlait_right1', replace;

use `fearlait', clear;

keep if year == 1960 | year == 1965 | year == 1970 | year == 1975 | year == 1980 | year == 1985
                     | year == 1990 | year == 1995;

gen double ideyear = year*1000+ide;

keep mtnest lmtnest lpopl1 ethfrac relfrac ef instab eeurop  lamerica ssafrica asia nafrme ideyear;

sort ideyear;

save `fearlait_right2', replace;

*** Manipilating Humphreys' (2004) data;

use `humphreys', clear;

keep if year == 1960 | year == 1965 | year == 1970 | year == 1975 | year == 1980 | year == 1985
                     | year == 1990 | year == 1995;

gen double ideyear = year*1000+ide;

keep L_PC_PRODUCTION L_PC_PRODopi L_PC_RESERVES L_PC_RESERVopi ideyear;

sort ideyear;

save `humphreys_oil1', replace;


use `humphreys', clear;

*remember! oil production/reserves given as lagged values;
gen period = 1 if year >= 1961 & year <= 1965;
replace period = 2 if year >= 1966 & year <= 1970;
replace period = 3 if year >= 1971 & year <= 1975;
replace period = 4 if year >= 1976 & year <= 1980;
replace period = 5 if year >= 1981 & year <= 1985;
replace period = 6 if year >= 1986 & year <= 1990;
replace period = 7 if year >= 1991 & year <= 1995;
replace period = 8 if year >= 1996 & year <= 1999;

gen double period_ide = period*1000+ide;

rename country country_h;

gen d1 = L_PC_PRODUCTION != .;
egen d2 = sum(d1), by(period_ide);
egen L_PC_PRODUCTION_mod = sum(L_PC_PRODUCTION/d2), by(period_ide);
drop d1 d2;
gen d1 = L_PC_PRODopi != .;
egen d2 = sum(d1), by(period_ide);
egen L_PC_PRODopi_mod = sum(L_PC_PRODopi/d2), by(period_ide);
drop d1 d2;
gen d1 = L_PC_RESERVES != .;
egen d2 = sum(d1), by(period_ide);
egen L_PC_RESERVES_mod = sum(L_PC_RESERVES/d2), by(period_ide);
drop d1 d2;
gen d1 = L_PC_RESERVopi != .;
egen d2 = sum(d1), by(period_ide);
egen L_PC_RESERVopi_mod = sum(L_PC_RESERVopi/d2), by(period_ide);
drop d1 d2;

keep if year == 1961 | year == 1966 | year == 1971 | year == 1976 | year == 1981 | year == 1986
                     | year == 1991 | year == 1996;

replace year = 1965 if year == 1961;
replace year = 1970 if year == 1966;
replace year = 1975 if year == 1971;
replace year = 1980 if year == 1976;
replace year = 1985 if year == 1981;
replace year = 1990 if year == 1986;
replace year = 1995 if year == 1991;

drop if year == 1996;

keep ide year L_PC_PRODUCTION_mod L_PC_PRODopi_mod L_PC_RESERVES_mod L_PC_RESERVopi_mod;
                     
gen double ideyear = year*1000+ide;

sort ideyear;

save `humphreys_oil2', replace;

use `fearlait_right1', clear;
sort ideyear;
merge ideyear using `fearlait_right2';
tab _merge; drop _merge;
sort ideyear;
merge ideyear using `humphreys_oil1';
tab _merge; drop _merge;
sort ideyear;
merge ideyear using `humphreys_oil2';
tab _merge; drop _merge;
sort ideyear;

merge ideyear using `collhoeff';
tab _merge;
gen only_ch = _merge == 2;
drop _merge;

***Some more data manipulation and creation of additional variables;

*replace; 
replace L_PC_PRODUCTION = 0 if L_PC_PRODUCTION < 0;
replace L_PC_RESERVES = 0 if L_PC_RESERVES < 0;
replace L_PC_PRODUCTION_mod = 0 if L_PC_PRODUCTION_mod < 0; 

*replace; 
replace L_PC_PRODopi = 0 if L_PC_PRODopi < 0;
replace L_PC_RESERVopi = 0 if L_PC_RESERVopi < 0;
replace L_PC_PRODopi_mod = 0 if L_PC_PRODopi_mod < 0; 

*Create additional variables;
gen L_PC_PRODUCTION2 = L_PC_PRODUCTION*L_PC_PRODUCTION;
gen L_PC_PRODUCTION_mod2 = L_PC_PRODUCTION_mod*L_PC_PRODUCTION_mod;
gen L_PC_RESERVES2 = L_PC_RESERVES*L_PC_RESERVES;
gen L_PC_RESERVES_mod2 = L_PC_RESERVES_mod*L_PC_RESERVES;

*Create additional variables;
gen L_PC_PRODopi2 = L_PC_PRODopi*L_PC_PRODopi;
gen L_PC_PRODopi_mod2 = L_PC_PRODopi_mod*L_PC_PRODopi_mod;
gen L_PC_RESERVopi2 = L_PC_RESERVopi*L_PC_RESERVopi;
gen L_PC_RESERVopi_mod2 = L_PC_RESERVopi_mod*L_PC_RESERVopi;

*complete/correct the dataset on oilsxp;
replace oilsxp = 0 if L_PC_PRODUCTION == 0;
replace oilsxp2 = 0 if L_PC_PRODUCTION == 0;

gen d = L_PC_PRODUCTION > 0 &
( (country_ch == "Algeria" & year == 1965)
| (country_ch == "Angola" & year == 1975)
| country_ch == "Azerbaijan"
| country_ch == "Bahrain"
| country_ch == "Kuwait"
| country_ch == "Oman"
| country_ch == "Russia"
| country_ch == "Trinidad and Tobago"
| country_ch == "U. Arab Emirates");

replace oilsxp = sxp if d == 1;
replace oilsxp2 = sxp2 if d == 1; drop d;


replace oilsxp = 0 if country_ch == "Bangladesh"
| country_ch == "Benin"
| country_ch == "Bhutan"
| country_ch == "Bosnia"
| country_ch == "Botswana"
| country_ch == "Bulgaria"                        
| country_ch == "Botswana"
| country_ch == "Bulgaria"
| country_ch == "Burundi"
| country_ch == "Cambodia"
| country_ch == "China"
| country_ch == "Czechoslovakia"
| country_ch == "Djibouti"
| country_ch == "Fiji"
| country_ch == "Gambia"
| country_ch == "Georgia"
| country_ch == "Guinea-Bissau"
| country_ch == "Guyana"
| country_ch == "Hungary"
| country_ch == "Israel"
| country_ch == "Jamaica"
| country_ch == "Kenya"
| country_ch == "Lebanon"
| country_ch == "Lesotho"
| country_ch == "Malawi"
| country_ch == "Mauritius"
| country_ch == "Moldova"
| country_ch == "Mozambique"
| country_ch == "Namibia"
| country_ch == "PapuaNG"
| country_ch == "Poland"
| country_ch == "Romania"
| country_ch == "Rwanda"
| country_ch == "SierraLeone"
| country_ch == "Singapore"
| country_ch == "Swaziland"
| country_ch == "Tajikistan"
| country_ch == "Tanzania"
| country_ch == "Uganda"
| country_ch == "Vietnam"
| country_ch == "YemenAR"
| country_ch == "YemenPR"
| country_ch == "Yugoslavia"
| country_ch == "Zambia"
| country_ch == "Zimbabwe";

replace oilsxp2 = 0 if oilsxp == 0;

sort country_ch year;

merge country_ch using match_country_ch_prio;

tab _merge; drop _merge;

sort gwno year;

merge gwno year using onset_variables;

order country_ch year;
      
rename gdp_FL_mod gdp;
rename warsa onset_ch;
rename warsa_prio onset_prio_all;
rename warsa_prio_3 onset_prio_war;
rename L_PC_PRODUCTION pc_oilprod;
rename L_PC_PRODUCTION2 pc_oilprod2;
rename L_PC_PRODUCTION_mod av_pc_oil_prod;
rename L_PC_PRODUCTION_mod2 av_pc_oil_prod2;
rename L_PC_RESERVES pc_reserves;
rename L_PC_RESERVES2 pc_reserves2;
rename L_PC_PRODopi pc_oilprodv;
rename L_PC_PRODopi2 pc_oilprodv2;
rename L_PC_PRODopi_mod av_pc_oilprodv;
rename L_PC_PRODopi_mod2 av_pc_oilprodv2;
rename L_PC_RESERVopi pc_reservesv;
rename L_PC_RESERVopi2 pc_reservesv2;


lab var country_ch "Country code as used in CH";
lab var gdp "gdp/pop based on pwt5.6, wdi2001, cow energy data, mean preceding 5-year-period";
lab var onset_ch "CH civil war onset";
lab var onset_prio_all "civil war onset, CH format, all conflicts, UCDP/PRIO";
lab var onset_prio_war "civil war onset, CH format, war only, UCDP/PRIO";
lab var sxp "primary commodity exports as share of GDP";
lab var sxp2 "sxp squared";
lab var oilsxp "oil exporter dummy interacted with sxp";
lab var oilsxp2 "oilsxp squared";
lab var pc_oilprod "per capita oil production in preceding year";
lab var pc_oilprod2 "squared pc_oiprod";
lab var av_pc_oil_prod "average per capita oil production in preceding 5-year-period";
lab var av_pc_oil_prod2 "av_pc_oil_prod squared";
lab var pc_reserves "per capita oil reserves of preceding year";
lab var pc_reserves2 "pc_reserves squared"; 
lab var pc_oilprodv "value of per capita oil production in preceding year";
lab var pc_oilprodv2 "pc_oilprodv squared";
lab var av_pc_oilprodv "value of per capita oil production in preceding year";
lab var av_pc_oilprodv2 "value of per capita oil production in preceding year";
lab var pc_reservesv "value of per capita oil reserves of preceding year";
lab var pc_reservesv2 "pc_reservesv squared"; 
lab var secm "male secondary schooling";
lab var gy1 "GDP growth in preceding 5-year-period";
lab var peace "peace duration";
lab var geogia "geographic dispersion";
lab var lnpop "log population";
lab var frac "social fractionalization";
lab var etdo4590 "ethnic dominance";
lab var lpop "log population in preceding year";
lab var ncontig "noncontiguous state in preceding 5-year-period";
lab var instab "> 2 change in Polity measure in last 3 yrs before year";
lab var polity2 "polity2, mean over 5 preceding years";
lab var ethfrac "ethnic frac. based on Soviet Atlas, plus est's for missing in 1964";
lab var relfrac "religious fractionalization";
lab var nwstate "1 if state exists for less than 6 years";
lab var mtnest "Estimated % mountainous terrain";
lab var lmtnest "log of mtnest";
lab var ef "ethnic fractionalization based on Fearon 2002 APSA paper";
lab var eeurop "Dummy for Eastern Europe";
lab var lamerica "Dummy for Latin America";
lab var ssafrica "Dummy for Sub-Saharan Africa";
lab var asia "Dummy for Asia (-Japan)";
lab var nafrme "Dummy for North Africa/Middle East";

*some more variable cleaning;
drop if year == .;
keep gdp growth_fl lnpop lmtnest peace ncontig ethfrac etdo4590 sxp sxp2 
     secm gy1 peace geogia lnpop frac etdo4590 sxp sxp2 oilsxp oilsxp2 
     pc_oilprodv pc_oilprodv2 country_ch year ideyear onset*; 

notes drop _dta;
label data "Dataset for Basedau/Lay";

save BasedauLay, replace;






