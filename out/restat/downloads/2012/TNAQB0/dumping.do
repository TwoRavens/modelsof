clear
#delimit;
set mem 50m;
set more off;
global path ~;

/*========================================================================
 Program: dumping.do
 Author:  Alison Flamm
 Created: August 2008
 Purpose: Preliminary analysis of the effect of levies on pollution/output
	    1. Read in dumping data from .csv files
            2. Pool all dumping data and add province codes
	    3. Calculate levies per unit pollution
	    3. Read in levy data from .csv files, pool
	    4. Provide lables for dumping data
	    5. Merge levy and dumping data
	    6. Regressions
========================================================================*/


**************************************;
* Read in dumping data from .csv files;
**************************************;
insheet using $path/research/pollution/dumping/2006data.csv;
save $path/research/pollution/dumping/2006data.dta, replace;
clear;

insheet using $path/research/pollution/dumping/2005data.csv;
save $path/research/pollution/dumping/2005data.dta, replace;
clear;

insheet using $path/research/pollution/dumping/2004data.csv;
save $path/research/pollution/dumping/2004data.dta, replace;
clear;

insheet using $path/research/pollution/dumping/2003data.csv;
save $path/research/pollution/dumping/2003data.dta, replace;
clear;

insheet using $path/research/pollution/dumping/2002data.csv;
save $path/research/pollution/dumping/2002data.dta, replace;
clear;

insheet using $path/research/pollution/dumping/2001data.csv;
save $path/research/pollution/dumping/2001data.dta, replace;
clear;

insheet using $path/research/pollution/dumping/2000data.csv;
save $path/research/pollution/dumping/2000data.dta, replace;
clear;

insheet using $path/research/pollution/dumping/1999data.csv;
save $path/research/pollution/dumping/1999data.dta, replace;
clear;

insheet using $path/research/pollution/dumping/1998data.csv;
save $path/research/pollution/dumping/1998data.dta, replace;
clear;

insheet using $path/research/pollution/dumping/1997data.csv;
save $path/research/pollution/dumping/1997data.dta, replace;
clear;

insheet using $path/research/pollution/dumping/1996data.csv;
save $path/research/pollution/dumping/1996data.dta, replace;
clear;

insheet using $path/research/pollution/dumping/1996data.csv;
save $path/research/pollution/dumping/1996data.dta, replace;
clear;

insheet using $path/research/pollution/dumping/1995data.csv;
save $path/research/pollution/dumping/1995data.dta, replace;
clear;

insheet using $path/research/pollution/dumping/1994data.csv;
save $path/research/pollution/dumping/1994data.dta, replace;
clear;

insheet using $path/research/pollution/dumping/1993data.csv;
save $path/research/pollution/dumping/1993data.dta, replace;
clear;

insheet using $path/research/pollution/dumping/1992data.csv;
save $path/research/pollution/dumping/1992data.dta, replace;
clear;

insheet using $path/research/pollution/dumping/1991data.csv;
save $path/research/pollution/dumping/1991data.dta, replace;
clear;

insheet using $path/research/pollution/dumping/1990data.csv;
save $path/research/pollution/dumping/1990data.dta, replace;
clear;

**********************************************;
* Pool all dumping data and add province codes;
**********************************************;

use $path/research/pollution/dumping/1990data.dta;
append using $path/research/pollution/dumping/1991data.dta; 
append using $path/research/pollution/dumping/1992data.dta; 
append using $path/research/pollution/dumping/1993data.dta; 
append using $path/research/pollution/dumping/1994data.dta; 
append using $path/research/pollution/dumping/1995data.dta; 
append using $path/research/pollution/dumping/1996data.dta; 
append using $path/research/pollution/dumping/1997data.dta; 
append using $path/research/pollution/dumping/1998data.dta; 
append using $path/research/pollution/dumping/1999data.dta; 
append using $path/research/pollution/dumping/2000data.dta; 
append using $path/research/pollution/dumping/2001data.dta; 
append using $path/research/pollution/dumping/2002data.dta;
append using $path/research/pollution/dumping/2003data.dta; 
append using $path/research/pollution/dumping/2004data.dta; 
append using $path/research/pollution/dumping/2005data.dta; 
append using $path/research/pollution/dumping/2006data.dta; 

global mylist
"companies	total_dumping	ocean	lakes	dumping_standard	disposal_standard	mercury	cadmium	chromium	lead	arsenic	volitized_phenol	cyanide	petroleum_types	chemical_oxygen	suspended	sulphide	total_facilities	functioning	equipment_value	operating_expenses	waste_water_disposal	waste_water_recycling	mercury_cleanup	cadmium_cleanup	chromium_cleanup	lead_cleanup	arsenic_cleanup	volitized_phenol_cleanup	cyanide_cleanup	petroleum_cleanup	chemical_oxygen_cleanup	suspended_cleanup	sulphide_cleanup
cleanup_facilities	water_control_projects	waste_control_projects_value		units_fees	fees_exceeding	fees_creating		cities_registered	businesses_registered		problems	problems_value		enterprises	output_value_1990	output_value_current";
foreach i of global mylist{;
destring `i',replace force;
};

gen provnum=0;
replace provnum=11 if province=="Beijing";
replace provnum=12 if province=="Tianjin";
replace provnum=13 if province=="Hebei";
replace provnum=14 if province=="Shanxi";
replace provnum=15 if province=="Inner Mongolia";
replace provnum=21 if province=="Liaoning";
replace provnum=22 if province=="Jilin";
replace provnum=23 if province=="Heilongjiang";
replace provnum=31 if province=="Shanghai";
replace provnum=32 if province=="Jiangsu";
replace provnum=33 if province=="Zhejiang";
replace provnum=34 if province=="Anhui";
replace provnum=35 if province=="Fujian";
replace provnum=36 if province=="Jiangxi";
replace provnum=37 if province=="Shandong";
replace provnum=41 if province=="Henan";
replace provnum=42 if province=="Hubei";
replace provnum=43 if province=="Hunan";
replace provnum=44 if province=="Guangdong";
replace provnum=45 if province=="Guangxi";
replace provnum=46 if province=="Hainan";
replace provnum=50 if province=="Chongqing";
replace provnum=51 if province=="Sichuan";
replace provnum=52 if province=="Guizhou";
replace provnum=53 if province=="Yunnan";
replace provnum=54 if province=="Tibet";
replace provnum=61 if province=="Shaanxi";
replace provnum=62 if province=="Gansu";
replace provnum=63 if province=="Qinghai";
replace provnum=64 if province=="Ningxia";
replace provnum=65 if province=="Xinjiang";


*****************************************;
* Drop variables that were empty columns ;
*****************************************;

drop v1* v2* v3* v4* v5* v6* v7* v8* v9* mj;

drop if year==.;

sort provnum year;

**********************************;
* Provide lables for dumping data ;
**********************************;

label var year "Year";
label var province "Province";
label var companies "# industrial enterprises in pollution survey";
label var total_dumping "Waste water dumping (10,000s tons)";
label var ocean "Waste water dumping into ocean (10,000s tons)";
label var lakes "Waste water dumping into rivers and lakes (10,000s tons)";
label var dumping_standard "Waste water meeting dumping standards (10,000s tons)";
label var disposal_standard "Treated waste water meeting dumping standards (10,000s tons)";
label var mercury "Mercury dumped (tons)";
label var cadmium "Cadmium dumped (tons)";
label var chromium "Hexavalent Chrome dumped (tons)";
label var lead "Lead dumped (tons)";
label var arsenic "Arsenic dumped (tons)";
label var volitized_phenol "Volatile Hydroxybenzene dumped (tons)";
label var cyanide "Cyanide dumped (tons)";
label var petroleum_types "Petroleum dumped (tons)";
label var chemical_oxygen "COD dumped (tons)";
label var ammonium "Ammonium Nitrogen dumped (tons)";
label var suspended "Suspended solids dumped (tons)";
label var sulphide "Sulphide dumped (tons)";
label var total_facilities "# waste water treatment facilities";
label var functioning "# functioning waste water treatment facilities";
label var investment "Total investment quota (10,000s yuan)";
label var equipment_value "Waste water control equipment worth (10,000s yuan)";
label var operating_expenses "Waste water control facilities current year operating expenses (10,000s yuan)";
label var waste_water_disposal "Waste water being treated (10,000s tons)";
label var waste_water_recycling "Waste water being recycled (10,000s tons)";
label var mercury_cleanup "Mercury cleaned up (tons)";
label var cadmium_cleanup "Cadmium cleaned up (tons)";
label var chromium_cleanup "Hexavalent Chrome cleaned up (tons)";
label var lead_cleanup "Lead cleaned up (tons)";
label var arsenic_cleanup "Arsenic cleaned up (tons)";
label var volitized_phenol_cleanup "Volatile Hydroxybenzene cleaned up (tons)";
label var cyanide_cleanup "Cyanide cleaned up (tons)";
label var petroleum_cleanup "Petroleum cleaned up (tons)";
label var chemical_oxygen_cleanup "COD cleaned up (tons)";
label var suspended_cleanup "Suspended solids cleaned up (tons)";
label var ammonium_cleanup "Ammonium Nitrogen cleaned up (tons)";
label var sulphide_cleanup "Sulphide cleaned up (tons)";
label var cleanup_facilities "# overall pollution treatment facilities (???)";
label var water_control_projects "# waste water treatment projects";
label var waste_control_projects_value "Investment completed in waste water treatment projects (10,000s yuan)";
label var units_fees "# units paying levies";
label var fees_exceeding "Levies paid for excessive dumping";
label var fees_creating "Levies paid for all pollution";
label var cities_registered "# cities implementing permit system";
label var businesses_registered "# businesses registered with permit to dump";
label var problems "# water pollution accidents";
label var problems_value "Economic losses from water pollution accidents (10,000s yuan)";
label var enterprises "# industrial enterprises (only those over certain size for 99-02)";
label var output_value_1990 "Output value of industrial enterprises at 1990 prices";
label var output_value_current "Output value of industrial enterprises at current prices";
label var investment "Total investment quota (10,000s yuan)";

save $path/research/pollution/dumping/dumping1990to2006.dta, replace;

*******************************;
* Merge output and dumping data;
*******************************;

insheet using $path/research/pollution/dumping/outputdata.csv,clear;
gen provnum=0;
replace provnum=11 if province=="Beijing";
replace provnum=12 if province=="Tianjin";
replace provnum=13 if province=="Hebei";
replace provnum=14 if province=="Shanxi";
replace provnum=15 if province=="Inner Mongolia";
replace provnum=21 if province=="Liaoning";
replace provnum=22 if province=="Jilin";
replace provnum=23 if province=="Heilongjiang";
replace provnum=31 if province=="Shanghai";
replace provnum=32 if province=="Jiangsu";
replace provnum=33 if province=="Zhejiang";
replace provnum=34 if province=="Anhui";
replace provnum=35 if province=="Fujian";
replace provnum=36 if province=="Jiangxi";
replace provnum=37 if province=="Shandong";
replace provnum=41 if province=="Henan";
replace provnum=42 if province=="Hubei";
replace provnum=43 if province=="Hunan";
replace provnum=44 if province=="Guangdong";
replace provnum=45 if province=="Guangxi";
replace provnum=46 if province=="Hainan";
replace provnum=50 if province=="Chongqing";
replace provnum=51 if province=="Sichuan";
replace provnum=52 if province=="Guizhou";
replace provnum=53 if province=="Yunnan";
replace provnum=54 if province=="Tibet";
replace provnum=61 if province=="Shaanxi";
replace provnum=62 if province=="Gansu";
replace provnum=63 if province=="Qinghai";
replace provnum=64 if province=="Ningxia";
replace provnum=65 if province=="Xinjiang";

sort year provnum;
gen tyear=substr(year,3,6);
drop year;
destring tyear, gen(year);
drop if year<1950|year>2006;
replace provnum=51 if provnum==50;
collapse (sum) gross_output,by(provnum year);
keep if year>=1990;

label var gross_output "Gross industrial output value (100 million yuan)";
label data "Industrial output from the China Data Center by province X year";
sort provnum year;
save $path/research/pollution/dumping/outputdata.dta, replace;

*****************************************;
* Read in levy data from .csv files, pool;
*****************************************;

insheet using $path/research/pollution/dumping/levies92to96.csv,clear;
save $path/research/pollution/dumping/levies92to96.dta, replace;

insheet using $path/research/pollution/dumping/levies97to02.csv,clear;
save $path/research/pollution/dumping/levies97to02.dta, replace;

use $path/research/pollution/dumping/levies92to96.dta;
append using $path/research/pollution/dumping/levies97to02.dta;

label var efflevy_water "Effective Levy=Excess Fine/Excess Discharge Volume (water)";
label var efflevy_gas   "Effective Levy=Excess Fine/Excess Discharge Volume (gas)";
label data "Jing Cao fine levy data by province X year";
sort provnum year;

save $path/research/pollution/dumping/levies1992to2002.dta, replace;

******************************;
* Merge levy and dumping data ;
******************************;

use $path/research/pollution/dumping/dumping1990to2006.dta;

sort provnum year;
merge provnum year using $path/research/pollution/dumping/levies1992to2002.dta;
tab _merge;
keep if _merge==1|_merge==3;
drop _merge;

sort provnum year;
merge provnum year using $path/research/pollution/dumping/outputdata.dta;
tab _merge;
keep if _merge==1|_merge==3;
drop _merge;

***********************;
* Rainfall by province ;
***********************;

sort provnum;
merge provnum using $path/research/pollution/datafiles/rainfall_province;
drop if provnum==0|provnum==50;
tab _merge;
drop _merge;

***************************************************************;
* Data set that forms the basis of the dumping/levies analysis ;
***************************************************************;

sort provnum year;
save $path/research/pollution/dumping/levies_dumping_output_1992to2002.dta, replace;
