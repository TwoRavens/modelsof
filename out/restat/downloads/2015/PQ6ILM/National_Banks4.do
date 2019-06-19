#delim ;
set more off;
capture log close;
capture clear;
*log using , text replace;
set memory 200m;

/***!***!***!***!***!*** [National_banks4.do ] ***!***!***!***!***!
*
* Project: National Banks 		
* Programmer:  Scott Fulford
*
* Date:    	 7/5/2010
*
* Auditor:      
* Audit Date:   
*
* Purpose:      
* 1) Load GIS county data created in ArcMap. It is compared to 1890 counties,
		so merge in data from county files and combine using the area.
* 2) 
* 3)
* Inputs: 
	county1860.dta through county1920.dta
	union1890_1860.dta through union1890_1920.dta
	
	National_Bank_city1870_county1890
	National_Bank_city1880_county1890
	National_Bank_city1890_county1890
	National_Bank_city1900_county1890.txt
	National_Bank_city1902_county1890.txt
	
	City_pop_1880_county1890	      
*
* Ouputs: 
*	National_Banks_counties1890	
*
*
***!***!***!***!***!***!***!***!***!***!***!***!***!***!***!***!***/


/***Define Global Directory ****/
	local INDIR "C:\Scott\Research\National_Banks\Intermediate";
	local ORIGINALDIR "C:\Scott\Research\National_Banks\Data";
	local PROGDIR  "C:\Scott\Research\National_Banks\Programs";
	local OUTDIR  "C:\Scott\Research\National_Banks\Intermediate";
	local GRAPHDIR "C:\Scott\Research\National_Banks\Intermediate";
/*******************************/

/*****Load in a data set of banks that open with less than 50 before 1900
Use this data to change the capital of banks which open with less before 1900
*/
tempfile capital_below50;
cd `ORIGINALDIR';

import excel using "National_Bank_Accounts.xls", sheet("Capital_below_50") firstrow clear;

rename Year year;
rename  Capitalnextyear  Capital_next_year;
sort banknumber;
save `capital_below50', replace;
pause on;
/***** Load and create county data ****/
cd `INDIR';
/*Which years to do*/
local allyears 1860 1870 1880 1900 1910 1920 1970; /*Except 1890 the base year*/


foreach myear in `allyears' {;
	if (`myear' == 1860) | (`myear' == 1870) | (`myear' == 1880) | (`myear' == 1900) | (`myear' == 1910) | (`myear' == 1920) {;
		
		/*Variables to add up when combining county fragments*/
		local totalvariables tpop male_pop manuf_estb livestock_val farmprod_val manuf_wages pop_urban manuf_val area_imp_farm area_farm farm_val farm_mach_val manuf_emp numfarms;

		/*Variables to combine using population weights*/
		local meanvariables p_imp_farm p_manuf_emp gini_farmsize meanfarmsize;
	}; 
	if (`myear' == 1970) {;
		
		/*Variables to add up when combining county fragments*/
		local totalvariables tpop totinc;

		/*Variables to combine using population weights*/
		local meanvariables incperperson;
	}; 

	tempfile union`myear' county`myear' county_1890_`myear';
	use county`myear', clear;
	
	rename GISJOIN gisjoin`myear';
	sort gisjoin`myear';
	save `county`myear'', replace;
	
	insheet using union1890_`myear'.txt, clear;
	drop if area < 1;
	rename gisjoin_1 gisjoin`myear';
	rename gisjoin gisjoin1890;
	sort gisjoin`myear';
	merge m:1 gisjoin`myear' using `county`myear'';
	/*The non-matched are either Indian Territory/Oklahoma or an odd strip of Minnesota, the unmatched data is from Alaska and a piece of Dakota Territory*/

	drop if _merge <3; 
	save `union`myear'', replace;
	

	by gisjoin1890, sort: egen tarea1890=total(area);
	by gisjoin`myear', sort: egen tarea`myear'=total(area);
	
	/*In 1860 and 1870 St Louis is not separated from St Louis County
	 and in 1870 Baltimore City is included in Baltimore county
	 and area based approach works poorly for these since it allocates too
	 little pop to the city because of smaller area. Instead allocate based
	 on the ratio of population:
	 
				 	Baltimore	Baltimore City	Ratio of total
			1860	52754	213801	0.197910375
			1870			
			1880	81209	334442	0.195377853
			1890	72910	434440	0.1437075
			1900	90756	508958	0.151332135
			1910	150545	530292	0.221117536
			Mean			0.18188908
						
				Baltimore	Baltimore City	Ratio of total
			1860			
			1870			
			1880	31889	350519	0.083389992
			1890	36308	451771	0.074389597
			1900	50041	575239	0.080029747
			1910	82418	687030	0.107113151
			Mean			0.086230622
		*/ 

	tempvar area; /*Only use this for weights, since modify it*/
	gen `area' = area;
	if `myear' == 1860 | `myear' == 1870 {;
		replace `area' = .0862*tarea`myear' if gisjoin1890 =="G2901890";
		replace `area' = (1-.0862)*tarea`myear' if gisjoin1890 =="G2905100";
	};
	if `myear' == 1870 {;
		
		replace `area' = .182*tarea`myear' if gisjoin1890 =="G2400050";
		replace `area' = (1-.182)*tarea`myear' if gisjoin1890 =="G2405100";
	};
	
	/*Allocate totals by area to the `myear' pieces of counties.
	These will be summed to create 1890 counties*/
	foreach var in `totalvariables' {; 
		replace `var' =`var' * `area'/tarea`myear';
	};
	/*Mean variables are averaged based on the area they contribute to 
	the 1890  counties.
	These will be summed to create 1890 counties*/
	foreach var in `meanvariables' {; 
		replace `var' =`var' * area/tarea1890;
	};
	/*Store labels*/
	foreach v of var * {;
		local l`v' : variable label `v';
	       if `"`l`v''"' == "" {;
			local l`v' "`v'";
	 	};
	};
	collapse (sum) tarea1890 `totalvariables' `meanvariables', by(gisjoin1890);
	
	foreach v of var * {;
		label var `v' "`l`v''";
	};

	sort gisjoin1890;
	save `county_1890_`myear'', replace;
};

use county1890, clear;
rename GISJOIN gisjoin1890;
sort gisjoin1890;
foreach myear in `allyears' {;
	merge 1:1 gisjoin1890 using `county_1890_`myear'';
	drop _merge;
};
/*The tarea is the only common variable and it is left missing from
missing counties in 1860*/
drop tarea1890;
merge 1:1 gisjoin1890 using `county_1890_1900', keepusing(tarea1890); 
drop _merge;

/***Change later decades variables***/
/*although calculate income per person, better to base on consistent total income and tpop figures*/
drop incperperson1970;

label var tarea1890 "County area (sq miles) 1890";
tempfile allcounties_1890;
sort gisjoin1890;
save `allcounties_1890', replace;

/***Load in banks which have been spatially joined to 1890 counties*/
cd "`INDIR'";



/**Special 1902 section  create 1902 data which is a combination
of 1900 and 1902 data. Drop all 1900 banks with 50, and add all of the 1902
banks with 50 or under and call it 1902 capital stock. Derive all statistics
about banks and capital stock the same way, but have an indicator
for banks at 25 as well as for banks at 50 (and total banks . . . )

**/


foreach year in 1870 1880 1890 1900 1902 {;
	tempfile nb`year' capital_below50_`year';
	
	use `capital_below50', clear;
	keep if year == `year';
	sort banknumber;
	save `capital_below50_`year'', replace;
	
	insheet using National_Bank_city`year'_county1890.txt, clear;
	if `year' <= 1900 {;	
		rename totalliabi liabilities`year';
		rename loansanddi loans`year';
	};
	rename capitalsto capitalstock`year';
	rename gisjoin  gisjoin1890;
	/******
	Before 1900, some banks enter with less than 50, and pay it in over the next year. The excel spreadsheet intro page details these banks. All go to 50 or above by the next year, or close. I replace their capital here with the actual capital they have the next year, since being below 50 is transient. 
	*/
	merge 1:1 banknumber using `capital_below50_`year'';
	replace capitalstock`year' =  Capital_next_year if _merge ==3;
	drop if Closes_next_year ==1;
	drop _merge;
	/*Only 1900 should now have any banks with capital less than 50*/
	if (`year' ==1870 | `year' == 1880 | `year' == 1890) {;
			assert capitalstock`year' >=50;
		};
	/*Create a new variable for the 1900 banks that are less than 50, but do not include them in total capital, loans or liabilities since they represent new banks.*/
	if (`year' == 1900) {;
		gen bankslt50c`year' = (capitalstock`year' <50);
		/*Take out less than 50 banks from all totals*/
		gen capitallt50c`year' =capitalstock`year' if bankslt50c`year';
		replace capitalstock`year' = 0 if bankslt50c`year'; /*Don't include lt 50 capital banks in total capital*/
		replace banknumber =. if bankslt50c`year'; /*So not included in count.*/
		gen loanslt50c`year' =loans`year' if bankslt50c`year';
		replace loans`year' = 0 if bankslt50c`year';
		gen liabilitieslt50c`year' =liabilities`year' if bankslt50c`year';
		replace liabilities`year' = 0 if bankslt50c`year';
		local includethesevarialbes_lt50c  bankslt50c`year'  capitallt50c`year' liabilitieslt50c`year';
	};
	
	/*
	Create indicator if bank has capital stock at 50,000 (include less than to capture the one bank that was incompletely capitalized at measurement*/
	gen banks50c`year' = (capitalstock`year' ==50);
	/*Indicator for  25, which should only happen in 1900, but useful to have 0's for other years*/
	gen banks25c`year' = (capitalstock`year' ==25);
	
	rename banknumber banks`year';
	/*There are some small projection problems and combination problems which put some cities/banks just outside the boundaries of county (such as in a river (Chester) or the Bay (Alameda). These should now be fixed in the orginal data*/
	if `year' == 1870 {;
		replace gisjoin1890 = "G4200450" if cityname =="CHESTER" & statename =="PENNYSLVANIA";
	}; else if `year' == 1880 {;
		replace gisjoin1890 = "G0600010" if cityname =="ALAMEDA" & statename =="CALIFORNIA";
	};

	sort  gisjoin1890;
	if `year' <=1900 {;
		collapse (count) banks`year' (sum) liabilities`year' capitalstock`year' loans`year' banks50c`year'  banks25c`year' `includethesevarialbes_lt50c', by(gisjoin1890);
		label var loans`year' "Loans and discounts of banks in county `year'";
		label var liabilities`year' "Liabilities of banks in county `year'";
	}; else {; /*1902*/
		collapse (count) banks`year' (sum)  capitalstock`year'  banks50c`year'  banks25c`year' , by(gisjoin1890);	
	};

	label var banks50c`year' "Banks with 50K capital in county `year'";	
	label var banks25c`year' "Banks with 25K capital in county `year'";	
	label var banks`year' "Number of banks in county `year'";
	label var capitalstock`year' "Capital stocks of banks in county `year'";
	
	/* Only for 1900
	label var bankslt50c`year' "Banks with less than 50K capital in county `year'";
	label var capitallt50c`year' "Capital of banks with less than 50K capital in county `year'";
	*/
	
	save `nb`year'', replace;
	use `allcounties_1890', clear;
	merge 1:1 gisjoin1890 using `nb`year'';
	drop _merge;
	save `allcounties_1890', replace;
};

/****Merge in distance average distance to nearest bank ****
This calculation asks for each 1890 county, what is the the average (over the area of the county) distance to the nearest bank. For counties with a bank, the average will be small, although if a county does not have a bank but has banks on the borders the distance may be small as well. 

The exact calculation should be
Int_{all x} Int_{B(y|x)} (distance nearest bank from x,y) dy dx
where B(y|x) is the boundary along the y axis of the county for a given x. (The lower and upper bound for each x, which might be the same if there is no county at that x coordinate). 

To calculate this value in practice in ArcGIS I do a two dimensional Reiman sum. First I create a raster with small box sizes, each of which contains the shortest distance to a bank for each year (using the Euclidean Distance tool in the Distance section of the Spatial Analyst tools). Using the 1890 county shapefile, I average over the raster values which fall within each 1890 county (using the Zonal Statistics as Table tool in the Zonal section of the Spatial Analyst Tools). These Tables must then be exported to text files to be read by any other program.

This approach is better than the much easier calculation of distance to nearest bank from the centroid since it more acurately captures how the coverage of banks. For example, a county with no banks, but with banks along all of its borders may be covered very well, even if its centroid gives a long distance to the nearest bank.
*****/
foreach year in 1870 1880 1890 1900 {;
	insheet using "`INDIR'\mean_distbank`year'.txt", comma clear;
	keep  gisjoin mean;
	rename mean mean_dist_bank`year';
	replace mean_dist_bank`year'=mean_dist_bank`year'/1000;
	label var mean_dist_bank`year' "Average distance (km) to nearest bank (county area average)";
	rename gisjoin gisjoin1890;
	sort gisjoin1890;
	tempfile distance`year';
	save `distance`year'', replace;
	use `allcounties_1890', clear;
	merge 1:1 gisjoin1890 using `distance`year'';
	drop _merge;
	save `allcounties_1890', replace;
};


/***Merge in 1880 cities ***/
insheet using City_pop_1880_county1890.txt, comma clear;
rename gisjoin gisjoin1890;

gen city4to6_1880 = (pop1880>=4000 & pop1880<6000);
gen city6to8_1880 = (pop1880>=6000 & pop1880<=8000);
gen citygt4_1880 = 1;
gen city4to6_1870 = (pop1870>=4000 & pop1870<6000);
gen city6to8_1870 = (pop1870>=6000 & pop1870<=8000);
gen citygt4_1870 = (pop1870>=4000);

sort gisjoin1890;

collapse (sum) city4to6_1880 city6to8_1880 citygt4_1880 city4to6_1870 city6to8_1870 citygt4_1870, by(gisjoin1890);
label var city4to6_1880 "Number of cities beween 4 and 6 thousand in county 1880";
label var city6to8_1880 "Number of cities beween 6 and 8 thousand in county 1880";
label var citygt4_1880 "Number of cities greater than 4 thousand in county 1880";
label var city4to6_1870 "Number of cities beween 4 and 6 thousand in county 1870";
label var city6to8_1870 "Number of cities beween 6 and 8 thousand in county 1870";
label var citygt4_1870 "Number of cities greater than 4 thousand in county 1870";
tempfile citypop1880;
save `citypop1880';

/*Do some final cleanup*/
use `allcounties_1890', clear;
sort gisjoin1890;
merge 1:1 gisjoin1890 using `citypop1880';
drop _merge;
drop YEAR;
drop if statename =="ALASKA TERRITORY"; /*No data, but still included*/
replace statename = "WYOMING" if gisjoin1890 =="G5600470";
replace countyname = "YELLOWSTONE NATIONAL PARK" if gisjoin1890 =="G5600470";

rename STATEA statenum;
rename COUNTYA countynum;
label var statenum "NHGIS state number 1890";
label var countynum "NHGIS county number 1890";
label var gisjoin1890 "NHGIS county join 1890";


/*Change missing variables to zeros so that a place with no banks has 0 banks rather than missing banks*/
foreach varname of varlist 	
banks*
loans* 
liabilities* 
capitalstock*
city4to6_*
city6to8_*
citygt4_*
{;
	replace `varname' = 0 if `varname' >=.;
};
save National_Banks_counties1890, replace;

exit;	
