#delim ;
set more off;
capture log close;
capture clear;
*log using , text replace;
set memory 300m;

/***!***!***!***!***!*** [National_banks2.do ] ***!***!***!***!***!
*
* Project: National Banks 
* Programmer:    Scott Fulford
	(inital work by Shahed Khan)
*
* Date:    	 6/20/2010
*
* Auditor:
* Audit Date:
*
* Purpose:
* 1)  Match cities/towns
	in banking data with cities/towns in census data to get county of bank city
* 2) Combine National Banking data with demography data by county
* 3)
* Inputs: National_Bank_Accounts.dta
		GNIS_places


*
* Ouputs: National_Bank_city.dta 
	Load these into ArcMap to get the county, 
		National_Bank_city1870.csv
		National_Bank_city1880.csv
		National_Bank_city1890.csv
		National_Bank_city1900.csv
		National_Bank_city1902.csv
 	use them to create 					 
		National_Bank_city1870_county1890
		National_Bank_city1880_county1890
		National_Bank_city1890_county1890
	  National_Bank_city1900_county1890
	  National_Bank_city1902_county1890 
	which are loaded in National_banks4.do 
	In ARCGIS first create a shapefile from the National bank CSV files that includes the points for National_Bank_cityxxxx (export when right click on National Bank). Then do a spatial join of target National_Bank_cityxxxx with 1890 County boundary files as the join using "is within" Then export the resulting attribute table (from options in the attribute table) using text. ArcGIS is a poor program, and usually cannot deal with overwriting, so generally have to delete files before join or creating shapefile. 
	
		
		City_pop1880
		City_pop_6to8_1880.csv 
		City_pop_4to6_1880.csv
*
*
***!***!***!***!***!***!***!***!***!***!***!***!***!***!***!***!***/


/***Define Global Directory ****/
	local INDIR "C:\Scott\Research\National_Banks\Data\";
	local PROGDIR  "C:\Scott\Research\National_Banks\Programs";
	local OUTDIR  "C:\Scott\Research\National_Banks\Intermediate";
	local GRAPHDIR "C:\Scott\Research\National_Banks\Intermediate";
	local GNISDIR "C:\Scott\Research\National_Banks\Data\GIS\GNIS"; /*This data is from the Geographic Names Information System compiled by the USGS available at
	http://geonames.usgs.gov/domestic/download_data.htm */
/*******************************/

cd `INDIR';
tempfile temp1 demo1860 statenames countydata demo1880 banks_pop1880 largestpop matchedbanks notmatched state_abbreviations GNIS_places;

/*	Load Census 1880 data for cities and towns with population over 4000 */
odbc load, connectionstring("Driver={Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)};DBQ=`INDIR'\Cenus_pop_1880.xls") table("Census_pop_1880$") clear dialog(complete);
drop F6;
compress;

 /*Standardize data*/
 replace statename = upper(trim(itrim(statename)));
 replace cityname = upper(itrim(trim(cityname)));
 replace countyname = upper(itrim(trim(countyname)));
 replace statename = "DIST COLUMBIA" if statename == "DISTRICT OF COLUMBIA" ;

 /*Add county names for those that are their own counties*/
 replace countyname = "ST. LOUIS" if cityname == `"ST. LOUIS"'  & statename == "MISSOURI";
 replace countyname = "DIST COLUMBIA" if  statename == "DIST COLUMBIA";


 /*Change naming to match Banks (and current usage)*/
  replace cityname =  subinstr(cityname,"ST.","SAINT",.); /*Change all St. to SAINT*/
  replace cityname = "LAPORTE" if cityname == `"LA PORTE"'  & statename == "INDIANA";
  replace cityname = "LAFAYETTE" if cityname == `"LA FAYETTE"'  & statename == "INDIANA";
  replace cityname = "TERRE HAUTE" if cityname == `"TERRA HAUTE"'  & statename == "INDIANA";
	replace cityname = "LYONS" if cityname == `"LYON"'  & statename == "IOWA"; /*There appears to be a LYON county, but Lyons is a big town in Clinton county*/
	replace cityname = "MARSHALLTOWN" if cityname == `"MARSHALL"'  & statename == "IOWA"; /*MARSHALLTOWN exists today and is the big town in MARSHALL County*/
	replace cityname = "BAY CITY" if cityname == `"BAY"'  & statename == "MICHIGAN";

  replace statename = "NEW MEXICO" if statename == `"NEW MEXICO TERRITORY"';
  replace statename = "UTAH" if statename == `"UTAH TERRITORY"';
  replace cityname = "MAHANOY CITY" if cityname == `"MAHANOY"'  & statename == "PENNSYLVANIA";
  replace cityname = "WILKES-BARRE" if cityname == `"WILKESBARRE"'  & statename == "PENNSYLVANIA"; /*Dash is the way spelled today*/
  replace cityname = "ATTLEBORO" if cityname == `"ATTLEBOROUGH"'  & statename == "MASSACHUSETTS";
  replace cityname = "OWENSBORO" if cityname == `"OWENSBORO'"'  & statename == "KENTUCKY";
  replace cityname = "BRATTLEBORO" if cityname == `"BRATTLEBORO'"'  & statename == "VERMONT";
  replace cityname = "BEACON" if cityname == `"MATTEAWAN"'  & statename == "NEW YORK"; /*Does not have a bank in 1880, merges with Fishkill Landing to form Beacon in 1913, change to Beacon for current coordinates*/


  
  /*Combine cities which  merged*/
  /*West Bay City (which does not have banks in 1880, with Bay city. The two merge in 1905*/
  replace cityname = "BAY CITY" if cityname == `"WEST BAY"'  & statename == "MICHIGAN";
  /*Chambersburg merges with Trenton in 1888*/
  replace cityname = "TRENTON" if cityname == `"CHAMBERSBURG"'  & statename == "NEW JERSEY";
  sort statename countyname cityname;
  collapse (sum)  pop1880 pop1870, by(statename countyname cityname);


 sort statename cityname;
 save `demo1880', replace;


/*
 |
 |                    STATA SETUP FILE FOR ICPSR 09424
 |        POPULATION OF COUNTIES, TOWNS, AND CITIES IN THE UNITED
 |                         STATES, 1850 AND 1860
 |

*/

infile using "`INDIR'\ICPSR_09424_Dictionary.dct", using ("`INDIR'\ICPSR_09424_Dat.txt") clear;
gen cityname = upper(TOWN);
rename COUNTY countyid;
rename CNAME countyname_1860;
rename STATE stateid;
rename POPCTY countypop;
rename AGG pop1860;
rename AGG50 pop1850;

keep  ID countyname stateid cityname TLAT TLONG countypop pop1860 pop1850;
sort stateid cityname;
save `demo1860', replace;


/* Create state-county data file */

use "ICPSR_02896-0009-Data.dta", clear;
drop if county!=0;
keep state name;
rename state stateid;
rename name statename;
drop if statename=="UNITED STATES";
sort stateid;
save `statenames', replace;

use "ICPSR_02896-0009-Data.dta", clear;
drop if county==0;
rename state stateid;
rename name countyname;
sort stateid;
save `countydata', replace;

merge m:1 stateid using `statenames';
drop _merge;
save `countydata', replace;


/*Load modern place name data*/
/*
insheet statename state_alpha using "`GNISDIR'\state_abbreviations.csv", delimiter(",") clear;
sort state_alpha;
save `state_abbreviations', replace;

/*Split National file into two parts to read in*/
insheet using "`GNISDIR'\NationalFile_20100607_1.txt", delimiter("|") clear;
keep if  feature_class == "Populated Place" | feature_class == "Civil";
compress;
save `temp1', replace;
insheet using "`GNISDIR'\NationalFile_20100607_2.txt", delimiter("|") clear;
keep if  feature_class == "Populated Place" | feature_class == "Civil";
compress;
append using `temp1';
drop map_name date_created date_edited;

sort state_alpha;
merge m:1 state_alpha using `state_abbreviations';
drop _merge;
save `GNISDIR'\GNIS_places, replace;
*/

use `GNISDIR'\GNIS_places, clear;
rename feature_name cityname;
rename county_name countyname_GNIS;

replace cityname = upper(trim(itrim(cityname)));
replace countyname_GNIS = upper(trim(itrim(countyname_GNIS)));
replace cityname = subinstr(cityname,"TOWNSHIP OF","",.);
replace cityname = subinstr(cityname,"TOWN OF","",.);
replace cityname = subinstr(cityname,"CITY OF","",.);
replace cityname = subinstr(cityname,"(HISTORICAL)","",.);
replace cityname = trim(itrim(cityname));

/*Adjust some of the places which have bad geographical coordinates*/
drop if strmatch(cityname, "SAN FRANCISCO") & state_alpha =="CA" & feature_id != 277593; /*Populated place has correct version*/
drop if strmatch(cityname, "DUNKIRK") & state_alpha =="NY" & feature_id != 978912; 
drop if strmatch(cityname, "CHESTER") & state_alpha =="PA" & feature_id != 1171694;  /*Match to Township of Chester, rather than City which is in the Delaware*/
drop if strmatch(cityname, "ALAMEDA") & state_alpha =="CA" & feature_id != 277468; 
drop if feature_id == 2411459; /*Port Angeles, Washington happens to be in the sound, us the "populated place"*/
drop if strmatch(cityname, "KEY WEST") & state_alpha =="FL" & feature_id != 294048; 
drop if strmatch(cityname, "PORTSMOUTH") & state_alpha =="VA" & feature_id != 1497102;
drop if state_alpha=="NY" &  cityname =="Brooklyn" &  countyname_GNIS != "Kings"; /*More than one Brooklyn in New York, but only one on Long Island*/


/*replace statename = "DAKOTA" if statename == "NORTH DAKOTA" |statename == "SOUTH DAKOTA"; */
replace statename = "DIST COLUMBIA" if statename == "DISTRICT OF COLUMBIA";
drop if statename =="OHIO" & cityname == "CENTERVILLE" & countyname_GNIS != "GALLIA";
duplicates tag statename cityname, gen(dup);
drop if dup>0 &  prim_lat_dec ==0;
duplicates drop statename cityname, force;
drop dup;
sort statename cityname;
save `GNIS_places', replace;

/***** Place bank cities into counties*/

/* Merge using 1880 cities and towns over 4000*/
use "`OUTDIR'/National_Bank_Accounts.dta", replace;

replace cityname =  subinstr(cityname,"ST.","SAINT",.); /*Change Saint to St. as in bank data*/
/* National Bank Accounts used boro' to abbreviate borough, some went to boro by itself. These are changed individually below*/
replace cityname= regexr(cityname,`"BORO'"', "BOROUGH");


/*Change naming to match census*/

/*Make changes based on unmatched, lookup current places
First gives bank city name, second census city name to change to
*/
foreach names_state in
`""HAVANA" "MONTOUR FALLS" "NEW YORK""' /*It seems Havana is Montour Falls*/
`""DECKERTOWN" "SUSSEX" "NEW JERSEY""' /*Deckertown changed name to Sussex in 1902*/
`""GREAT FALLS" "ROLLINSFORD" "NEW HAMPSHIRE""' /*GREAT FALLS appears to have becom Rollinsford*/
`""WAKEFIELD" "SOUTH KINGSTON" "RHODE ISLAND""' /*WAKEFIELD IS A TOWN IN SOUTH KINGSTON*/
`""WINSTED" "WINCHESTER" "CONNECTICUT""' /*WINSTEAD is part of Winchester township*/
`""RED BANK" "SHREWSBURY" "NEW JERSEY""' /*RED BANK is sometimes part of Shrewburry*/
`""MYSTIC" "GROTON" "CONNECTICUT""' /*MYSTIC, MYSTIC RIVER AND MYSTIC BRIDGE ALL APPEAR TO BE PART OF GROTON TOWNSHIP*/
`""MYSTIC RIVER" "GROTON" "CONNECTICUT""'
`""MYSTIC BRIDGE" "GROTON" "CONNECTICUT""'
`""WILLIMANTIC" "WINDHAM" "CONNECTICUT""'
`""BIRMINGHAM" "DERBY" "CONNECTICUT""' /*Birmingham appears to be in Derby*/
`""CASTLETON" "CASTLETON-ON-HUDSON" "NEW YORK""'  /*Castleton on Staten Island is not the right Castleton according to http://www.scripophily.com/nybankhistoryn.htm*/
`""FISHKILL LANDING" "BEACON" "NEW YORK""'  /*Fiskill Landing and Matteawan merge to form Beacon in 1913. They appear to be names for the same city*/
`""MATTEAWAN" "BEACON" "NEW YORK""'  /*Fiskill Landing and Matteawan merge to form Beacon in 1913. They appear to be names for the same city*/
`""SIEGFRIED" "NORTHAMPTON" "PENNSYLVANIA""' /*Siegfried merges with other villages in 1902*/
`""WEST SUPERIOR" "SUPERIOR" "WISCONSIN""' /*Appears to be part of Superior*/

/*These appear to be simple name changes*/
/*From 1900*/
`""CUSTER CITY" "CUSTER" "SOUTH DAKOTA""'
`""PITTSBURG" "PITTSBURGH" "PENNSYLVANIA""'
`""NEWCASTLE" "NEW CASTLE" "PENNSYLVANIA""'
`""BROCKWAYVILLE" "BROCKWAY" "PENNSYLVANIA""' /*Name shortened to Brockway in 1925*/
`""SOUTH MCALESTER" "MCALESTER" "INDIAN TERRITORY""' /*Still Indian territory in 1900*/
`""OKLAHOMA" "OKLAHOMA CITY" "OKLAHOMA""'
`""WASHINGTON COURT-HOUSE" "WASHINGTON COURT HOUSE" "OHIO""' 
`""GREENBURG" "GREENSBURG" "INDIANA""' /*Appears to be just a misspelling, 1901 has Greensburg*/
`""RIDGEFARM" "RIDGE FARM" "ILLINOIS""'
`""DUQUOIN" "DU QUOIN" "ILLINOIS""'
`""FERNANDINA" "FERNANDINA BEACH" "FLORIDA""'
`""BERKLEY" "BERKELEY" "CALIFORNIA""'
`""LA PORTE" "LAPORTE" "INDIANA""'
`""LA FAYETTE" "LAFAYETTE" "INDIANA""'
`""BRATTLEBOROUGH" "BRATTLEBORO" "VERMONT""' /*Modern usage*/
`""LARAMIE CITY" "LARAMIE" "WYOMING""'
`""ELK HORN" "ELKHORN" "WISCONSIN""'
`""HATBOROUGH" "HATBORO" "PENNSYLVANIA""'
`""WINNSBOROUGH" "WINNSBORO" "SOUTH CAROLINA""'
`""GREEN CASTLE" "GREENCASTLE" "PENNSYLVANIA""'
`""WILLIAMSBURGH" "WILLIAMSBURG" "OHIO""'
`""MOUNTPLEASANT" "MOUNT PLEASANT" "OHIO""'
`""GREEN SPRING" "GREEN SPRINGS" "OHIO""'
`""SANDY HILL" "SAND HILL" "NEW YORK""'
`""WINSTON" "WINSTON-SALEM" "NORTH CAROLINA""'
`""WATKINS" "WATKINS GLEN" "NEW YORK""'
`""BREWSTERS" "BREWSTER" "NEW YORK""'
`""TOM'S RIVER" "TOMS RIVER" "NEW JERSEY""'
`""TURNER'S FALLS" "TURNERS FALLS" "MASSACHUSETTS""'
`""TAMA CITY" "TAMA" "IOWA""'
`""LA GRANGE" "LAGRANGE" "INDIANA""'
`""GREENSBURGH" "GREENSBURG" "INDIANA""'
`""GREEN CASTLE" "GREENCASTLE" "INDIANA""'
`""CENTREVILLE" "CENTERVILLE" "INDIANA""'
`""KAN" "KANSAS" "ILLINOIS""' /*KAN in 1880 but same bank is KANSAS in 1890*/
`""BOISE CITY" "BOISE" "IDAHO""'
`""TUSKALOOSA" "TUSCALOOSA" "ALABAMA""'
`""NORTH BENNINGTON" "BENNINGTON" "VERMONT""'
`""WEST RANDOLPH" "RANDOLPH" "VERMONT""'
`""NORTH HAMPTON" "NORTHAMPTON" "NEW JERSEY""'

`""WHITINSVILLE" "NORTHBRIDGE" "MASSACHUSETTS""'
`""EAST JAFFREY" "JAFFREY" "NEW HAMPSHIRE""'
`""NEW CASTLE" "NEWCASTLE" "MAINE""'
`""DERBY LINE" "DERBY" "VERMONT""'
`""MOUNT HOLLY" "NORTHAMPTON" "NEW JERSEY""'
`""SOUTH NORWALK" "NORWALK" "CONNECTICUT""'
`""STAFFORD SPRINGS" "STAFFORD" "CONNECTICUT""'
`""WEST KILLINGLY" "KILLINGLY" "CONNECTICUT""'
`""WEST MERIDEN" "MERIDEN" "CONNECTICUT""'
`""WEST WATERVILLE" "WATERVILLE" "MAINE""'
`""EAST CAMBRIDGE" "CAMBRIDGE" "MASSACHUSETTS""'
`""SOUTH FRAMINGHAM" "FRAMINGHAM" "MASSACHUSETTS""'
`""SOUTH WEYMOUTH" "WEYMOUTH" "MASSACHUSETTS""'
`""KINGSTON" "SOUTH KINGSTON" "RHODE ISLAND""'
`""MICHIGAN CITY" "MICHIGAN" "INDIANA""'
`""CHARLESTOWN" "BOSTON" "MASSACHUSETTS""' /*Boston absorbs Charleston and Brighton in 1874*/
`""BRIGHTON" "BOSTON" "MASSACHUSETTS""'
`""EAST HAMPTON" "EASTHAMPTON" "MASSACHUSETTS""'
`""MARLBORO'" "MARLBOROUGH" "MASSACHUSETTS""'
`""WESTBORO'" "WESTBOROUGH" "MASSACHUSETTS""'
`""GLEN'S FALLS" "GLENS FALLS" "NEW YORK""'
`""WILKES BARRE" "WILKES-BARRE" "PENNSYLVANIA""' /*Dash is the way spelled today*/
`""CHARLESTOWN" "CHARLESTON" "WEST VIRGINIA""'
`""LYNCHBURGH" "LYNCHBURG" "VIRGINIA""'
`""STEVENS' POINT" "STEVENS POINT" "WISCONSIN""'
`""OWENSBOROUGH" "OWENSBORO" "KENTUCKY""'
`""PETERSBURGH" "PETERSBURG" "VIRGINIA""'
	{;
	gettoken orig names_state: names_state;
	gettoken change names_state: names_state;
	replace cityname = `"`change'"' if cityname ==`"`orig'"' & statename ==`names_state' ;
};

/*Change state name for Dakotas
only necessary for 1880 when Dakota still territory*/
replace statename = "NORTH DAKOTA" if (statename == "DAKOTA") &
	(cityname=="FARGO" |
		cityname =="BISMARCK");
replace statename = "SOUTH DAKOTA" if (statename == "DAKOTA") &
	(cityname =="SIOUX FALLS"  |
	cityname =="DEADWOOD" |
	cityname =="YANKTON");
/*Change Indian Territory to Oklahoma*/
replace statename = "OKLAHOMA" if statename == "INDIAN TERRITORY";

/***** Merge in 1880 cities and towns over 4000 ****/
sort statename cityname;
merge m:1 statename cityname using `demo1880';
drop _merge;
sort statename cityname;
save `banks_pop1880', replace;


sum  pop1880 if pop1880>=6000 & pop1880<=8000;
local pop6to8 = r(sum)/1000;
sum  LoansAndDiscount1880 if pop1880>=6000 & pop1880<=8000;
local banks6to8 = r(N);
sum  pop1880 if pop1880>=4000 & pop1880<=6000;
local pop4to6 = r(sum)/1000;
sum  LoansAndDiscount1880 if pop1880>=4000 & pop1880<=6000;
local banks4to6 = r(N);
display "Banks per person 4000 to 6000: " `banks4to6'/`pop4to6';
display "Banks per person 6000 to 8000: " `banks6to8'/`pop6to8';


/***** Merge 1860 demo data to help find counties ****/
/*Keep only largest pop from 1860 city data when there are more than
one city/state combination*/
use `demo1860';

/*Standardize*/
/*Census seems to use - to separate New and North, remove*/
replace cityname =  subinstr(cityname,"-"," ",.) ;
/*New London City is New London in Connecticut*/

/*Make changes based on unmatched, lookup current places
First gives census city name, second city name to change to
*/

foreach names_state in
`""NEW LONDON CITY" "NEW LONDON" 1"'
`""BALLSTON" "BALLSTON SPA" 13"'
`""PHILIPS" "PHILLIPS" 2"'
`""WALDOBORO'" "WALDOBORO" 2"'
`""FRANCISTOWN" "FRANCESTOWN" 4"'
`""BRATTLEBOROUGH" "BRATTLEBORO" 6"'
`""BOONEVILLE" "BOONVILLE" 13"'
`""COBBLESKILL" "COBLESKILL" 13"'
`""MIDDLEBURG" "MIDDLEBURGH" 13"'
	{;
	gettoken orig names_state: names_state;
	gettoken change names_state: names_state;
	replace cityname = `"`change'"' if cityname ==`"`orig'"' & stateid ==`names_state' ;
};

/*Some census city names abbreviated*/
replace cityname= regexr(cityname,`"BORO'"', "BOROUGH");

duplicates report stateid cityname;
sort stateid cityname pop1860;

by stateid cityname: keep if _n==_N;

save `largestpop', replace;

/*Turn statename into stateid*/
use `banks_pop1880', replace;
/*Standardize*/



merge m:1 statename using `statenames';

drop if _merge ==2;
drop _merge;

/*Merge based on cityname/statename (largest city with that name in state)*/
sort stateid cityname ;

merge m:1 stateid cityname using `largestpop';
drop if _merge ==2;
drop _merge;
replace countyname = countyname_1860 if countyname =="";

/* Make changes to match with current data*/

foreach names_state in
`""SING SING" "OSSINING" "NEW YORK""' /*Changed its name in 1901 to separate itself from the prison*/
`""SOUTH READING" "WAKEFIELD" "MASSACHUSETTS""' /*Changed its name in 1868*/
`""EAST SAGINAW" "SAGINAW" "MICHIGAN""' /*Joined in 1890*/
`""NEW MARKET" "NEWMARKET" "NEW HAMPSHIRE""'
`""WOLFBOROUGH" "WOLFEBORO" "NEW HAMPSHIRE""'
`""NORTHAMPTON" "MOUNT HOLLY" "NEW JERSEY""' /*Changed name in 1931*/
`""NEW MARKET" "NEW MARKET" "NEW HAMPSHIRE""'
`""SOUTH EAST" "SOUTHEAST" "NEW YORK""'
`""WEST TROY" "WATERVLIET" "NEW YORK""' /*Absorbed*/
`""NEW BERNE" "NEW BERN" "NORTH CAROLINA""'
`""HILLSBOROUGH" "HILLSBORO" "OHIO""'
`""NEW LISBON" "LISBON" "OHIO""'
`""HONEYBROOK" "HONEY BROOK" "PENNSYLVANIA""'
`""MAUCH CHUNK" "JIM THORPE" "PENNSYLVANIA""' /*Changed name in 1950's*/
`""SELIN'S GROVE" "SELINSGROVE" "PENNSYLVANIA""'
`""SUSQUEHANNA DEPOT" "SUSQUEHANNA" "PENNSYLVANIA""'
`""WAYNESBOROUGH" "WAYNESBORO" "PENNSYLVANIA""'
`""WELLSBOROUGH" "WELLSBORO" "PENNSYLVANIA""'
`""WAYNESBOROUGH" "WAYNESBORO" "PENNSYLVANIA""'
`""WEST GREENVILLE" "GREENVILLE" "PENNSYLVANIA""'
`""SOUTH KINGSTON" "SOUTH KINGSTOWN" "RHODE ISLAND""'
`""MURFREESBOROUGH" "MURFREESBORO" "TENNESSEE""'
`""CENTREVILLE" "CENTERVILLE" "OHIO""' /*Centreville exists, but Thurman National Bank of Centreville is in
Centerville, Gallia County, Ohio*/
`""SEHOME" "BELLINGHAM" "WASHINGTON""' /*Sehome appears to be neighbourhood in Bellingham*/
`""SPOKANE FALLS" "SPOKANE" "WASHINGTON""' /*Changes name in 1888*/
`""DE KALB" "DEKALB" "ILLINOIS""'
`""DELEVAN" "DELAVAN" "ILLINOIS""'
`""HAYS CITY" "HAYS" "KANSAS""'
`""JEWELL CITY" "JEWELL" "KANSAS""'
`""SAINT MARY'S" "SAINT MARYS" "KANSAS""'
`""SMITH CENTRE" "SMITH CENTER" "KANSAS""'
`""WA KEENEY" "WAKEENEY" "KANSAS""'
`""RED JACKET" "CALUMET" "MICHIGAN""' /*Changed name in 1929*/
`""SAINT JOHN'S" "SAINT JOHNS" "MICHIGAN""' /*Changed name in 1929*/
`""SAULT STE. MARIE" "SAULT SAINTE MARIE" "MICHIGAN""' 
`""DETROIT CITY" "DETROIT" "MINNESOTA""'
`""BUTTE CITY" "BUTTE" "MONTANA""'
`""COLD SPRING ON HUDSON" "COLD SPRING" "NEW YORK""'
`""CANAL DOVER" "DOVER" "OHIO""'	
`""SAINT MARY'S" "SAINT MARYS" "OHIO""'
`""TIPPECANOE CITY" "TIPPECANOE" "OHIO""'
`""GRANT'S PASS" "GRANTS PASS" "OREGON""'
`""CENTREVILLE" "CENTERVILLE" "TENNESSEE""'
`""GRAND VIEW" "GRANDVIEW" "TEXAS""'
`""PROVO CITY" "PROVO" "UTAH""'
`""MANCHESTER CENTRE" "MANCHESTER CENTER" "VERMONT""'
`""BEDFORD CITY" "BEDFORD" "VIRGINIA""'
`""NORTH YAKIMA" "YAKIMA" "WASHINGTON""'
`""PALOUSE CITY" "PALOUSE" "WASHINGTON""'
`""WHATCOM" "BELLINGHAM" "WASHINGTON""' /*It seems that Whatcom is the county, the largest city of which is Bellingham*/
`""MUSCOGEE" "MUSKOGEE" "OKLAHOMA""' /*Originally in Indian Territory*/
/*These don't appear to have banks in 1880, but match so have location*/
`""WYANDOTTE" "KANSAS CITY" "KANSAS""' /*Merged with Kansas City in 1886*/
/*1902 corrections*/
`""CUBA" "CUBA CITY" "WISCONSIN""' 
`""WILLIAMTOWN" "WILLIAMSTOWN" "WEST VIRGINIA""' 
`""WILLSPOINT" "WILLS POINT" "TEXAS""'
`""TROUPE" "TROUP" "TEXAS""'
`""PARKERS LANDING" "PARKER" "PENNSYLVANIA""'
`""EDENBURG" "EDINBURG" "PENNSYLVANIA""'
`""PARKERS LANDING" "PARKER" "PENNSYLVANIA""'
`""LEGER" "ALTUS" "OKLAHOMA""'
`""HERMAN" "HERMON" "NEW YORK""'
`""SEABRIGHT" "SEA BRIGHT" "NEW JERSEY""'
`""LE ROY" "LEROY" "KANSAS""'
`""PAWPAW" "PAW PAW" "ILLINOIS""'
`""FREDRICA" "FREDERICA" "DELAWARE""'
`""NEW DECATUR" "DECATUR" "ALABAMA""'
`""PLATTSBURG" "PLATTSBURGH" "NEW YORK""'
`""WHITEPLAINS" "WHITE PLAINS" "NEW YORK""'
`""MONONGAHELA CITY" "MONONGAHELA" "PENNSYLVANIA""'
`""SHERIDANVILLE" "SHERIDAN" "PENNSYLVANIA""' /*IT SEEMS SHERIDAN IS THE CORRECT CHANGE, BUT IT COULD ALSO BE SHERADEN*/
`""MONONGAHELA CITY" "MONONGAHELA" "PENNSYLVANIA""'

	{;
	gettoken orig names_state: names_state;
	gettoken change names_state: names_state;
	replace cityname = `"`change'"' if cityname ==`"`orig'"' & statename ==`names_state' ;
};

/*Replace *burgh with *burg */
foreach names_state in
`""GALESBURGH"          "ILLINOIS""'
`""HARRISBURGH"           "ILLINOIS""'
`""PETERSBURGH"           "ILLINOIS""'
`""LAWRENCEBURGH"         "INDIANA""'
`""EMMETSBURGH"           "IOWA""'
`""PHILLIPSBURGH"         "KANSAS""'
`""PITTSBURGH"            "KANSAS""'
`""CATLETTSBURGH"         "KENTUCKY""'
`""HARRODSBURGH"          "KENTUCKY""'
`""PLATTSBURGH"           "MISSOURI""'
`""MIAMISBURGH"           "OHIO""'
`""CHAMBERSBURGH"         "PENNSYLVANIA""'
`""EAST STROUDSBURGH"     "PENNSYLVANIA""'
`""GREENSBURGH"           "PENNSYLVANIA""'
`""GREENSBURGH"           "PENNSYLVANIA""'
`""HOLLIDAYSBURGH"        "PENNSYLVANIA""'
`""MIDDLEBURGH"           "PENNSYLVANIA""'
`""ORWIGSBURGH"           "PENNSYLVANIA""'
`""SALTSBURGH"            "PENNSYLVANIA""'
`""STRASBURGH"            "PENNSYLVANIA""'
`""STROUDSBURGH"          "PENNSYLVANIA""'
`""STROUDSBURGH"          "PENNSYLVANIA""'
`""WAYNESBURGH"           "PENNSYLVANIA""'
`""LEESBURGH"             "VIRGINIA""'
`""ELLENSBURGH"           "WASHINGTON""'
`""PARKERSBURGH"          "WEST VIRGINIA""'
`""SHULLSBURGH"           "WISCONSIN""'
	{;
	gettoken orig names_state: names_state;
	gettoken state names_state: names_state;
	replace cityname = subinstr("`orig'","BURGH","BURG",.) if cityname ==`"`orig'"' & statename =="`state'"	 ;
};

/*Replace *borough with *boro */
foreach names_state in
`""HILLSBOROUGH"         "ILLINOIS""'
`""MURPHYSBOROUGH"       "ILLINOIS""'
`""GLASSBOROUGH"         "NEW JERSEY""'
`""SWEDESBOROUGH"        "NEW JERSEY""'
`""HILLSBOROUGH"         "OREGON""'
`""BIRDSBOROUGH"         "PENNSYLVANIA""'
`""HILLSBOROUGH"         "TEXAS""'
	{;
	gettoken orig names_state: names_state;
	gettoken state names_state: names_state;
	replace cityname = subinstr("`orig'","BOROUGH","BORO",.) if cityname ==`"`orig'"' & statename =="`state'"	 ;
};

sort statename cityname;
merge m:1 statename cityname using `GNIS_places';
replace  countyname =  countyname_GNIS if countyname =="";
sort statename cityname;
list if _merge ==1; /*Unmatched!*/

drop if _merge ==2;

drop _merge;
foreach year in 1850 1860 1870 1880 {;
	label var pop`year' "`year' pop of City or Town";
};
cd `OUTDIR';
drop  ID countyname_1860 countypop TLAT TLONG source_lat_dms source_long_dms source_lat_dec source_long_dec;

save `matchedbanks', replace;
drop if BankName =="";

save National_Bank_city, replace;

/*Output a new file for each year for GIS*/
foreach year in 1870 1880 1890 1900 {;
	use National_Bank_city, clear;
	keep  statename BankName cityname BankNumber LoansAndDiscount`year' CapitalStock`year' TotalLiabilities`year' CloseYear countyname pop1880 pop1870 pop1860 pop1850 prim_lat_dec prim_long_dec elevation;
	keep if CapitalStock`year'<.;
	outsheet using 	National_Bank_city`year'.csv, comma replace;
};
/*1902*/
	use National_Bank_city, clear;
	keep  statename BankName cityname BankNumber  CapitalStock1902  prim_lat_dec prim_long_dec elevation;
	keep if CapitalStock1902<.;
	outsheet using 	National_Bank_city1902.csv, comma replace;
	
use `matchedbanks', clear;
keep if pop1880 <. | pop1870<.; 
keep  pop1850 pop1860 pop1870 pop1880  feature_id primary_lat_dms prim_long_dms prim_lat_dec prim_long_dec  state_alpha state_numeric countyname_GNIS county_numeric cityname statename countyname;
duplicates drop; 
save City_pop_1880, replace;
outsheet using City_pop_1880.csv, comma replace;
/*
keep if pop1880<=6000 & pop1880>=4000;
outsheet using City_pop_4to6_1880.csv, comma replace;
use City_pop_1880, clear;
keep if pop1880<=8000 & pop1880>=6000;
outsheet using City_pop_6to8_1880.csv, comma replace;
*/
exit;


save `notmatched', replace;
keep if countyname != "" & BankName != "";
save `matchedbanks', replace;
use `notmatched', clear;
keep if countyname =="" & BankName !="";
drop _merge;
save `notmatched', replace;
sort statename cityname;
merge m:1 statename cityname using `GNIS_places';
sort statename cityname;
list  statename BankName cityname if  BankName != "";


merge m:1 stateid cityname using `largestpop';
rename _merge _merge1;
sort statename cityname;
merge m:1 statename cityname using `demo1880';

sort  stateid cityname BankName;
order stateid cityname BankName;



exit;
