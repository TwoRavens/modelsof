#delim ;
set more off;
capture log close;
capture clear;
*log using , text replace;
set memory 200m;

/***!***!***!***!***!*** [National_banks3.do ] ***!***!***!***!***!
*
* Project: National Banks  		
* Programmer:  Scott Fulford
*
* Date:    	 7/1/2010
*
* Auditor:      
* Audit Date:   
*
* Purpose:      
* 1) Create county level economic data from census
* 2) 
* 3)
* Inputs: Various years of NHGIS http://www.nhgis.org/
		      
*
* Ouputs: census_`year'_county
*		
*
*
***!***!***!***!***!***!***!***!***!***!***!***!***!***!***!***!***/


/***Define Global Directory ****/
	local INDIR "C:\Scott\Research\National_Banks\Data\GIS\NHGIS";
	local PROGDIR  "C:\Scott\Research\National_Banks\Programs";
	local OUTDIR  "C:\Scott\Research\National_Banks\Intermediate";
	local GRAPHDIR "C:\Scott\Research\National_Banks\Intermediate";
/*******************************/
pause on;
cd `INDIR';
/*All census years in 19th century*/
local allyears 1860 1870 1880 1890 1900 1910 1920 ;
tempfile temp1 statenames ;
/*Load in county data*/
foreach year in `allyears' 1970 1970_2 {;
	tempfile county`year';
	insheet using "NHGIS_county_`year'_gis.csv", clear case;
	rename STATE statename;
	rename COUNTY countyname;
	replace statename = upper(trim(itrim(statename)));
 	replace countyname = upper(itrim(trim(countyname)));
 	gen Vmissing = .; /*Create a missing variable to assign*/
	sort GISJOIN;
	save `county`year'', replace;
	
	/*Load in a new extract on population
	  not included in 1970 or 1970_2*/
	if ("`year'" != "1970" ) & ("`year'" != "1970_2" )  {;
	
		if `year' == 1860 {;
			local specname ds14;
		};
		else if `year' == 1870 {;
			local specname ds17;
		};
		else if `year' == 1880 {;
			local specname ds23;
		};
		else if `year' == 1890 {;
			local specname ds27;
		};
		else if `year' == 1900 {;
			local specname ds31;
		};
		else if `year' == 1910 {;
			local specname ds37;
		};
		else if `year' == 1920 {;
			local specname ds43;
		};
		
		insheet using "nhgis0006_`specname'_`year'_county.csv", clear case;
		drop YEAR STATE STATEA COUNTY COUNTYA AREANAME;
		merge 1:1 GISJOIN using `county`year'';
		drop _merge;
		save `county`year'', replace;
	};
};

use `county1970', clear;
merge 1:1 statename countyname using `county1970_2';
tab _merge;
drop _merge;
rename C1I001 tpop1970;

/*Checked against Census 1974 Supplementary report on county per capita income
income is off by a factor of 10, otherwise pop and income close to published numbers
not sure what the discrepancy is*/
gen totinc1970 =
C32001+
C32002+
C32003+
C32004+
C32005+
C32006+
C32007+
C32008+
C32009+
C32010+
C32011+
C32012;
replace totinc1970 = totinc1970*10;

gen incperperson1970 = totinc1970/tpop1970;
label var incperperson1970 "Income per person 1970";

save `count1970', replace;

/*Rename variables*/
local allvariables tpop manuf_est;



foreach setofvariables in 

/*Total Population in County*/
`"
"tpop"
"Total Population in County"
`"
"1860  V0030001"
"1870  V0000001"
"1880  V0010001"
"1890  V0080001"
"1900  V0050001"
"1910  V0040001"
"1920  V0050001"
"'"'

/*Manufacturing Establishments*/
`"
"manuf_estb"
"Manufacturing Establishments"
`"
"1860 V0070001"
"1870 V0060001"
"1880 V0130001"
"1890 V0210001"
"1900 V0200001"
"1910 Vmissing"
"1920 V0120001"
"'"'

/*Total Value of All Livestock*/
`"
"livestock_val"
"Total Value of All Livestock"
`"
"1860 V0200001"
"1870 V0090001"
"1880 V0560001"
"1890 V0640001"
"1900 V0990004"
"1910 V1270007"
"1920 V0140004"
"'"'

/*Estimated value of all farm productions */
`"
"farmprod_val"
"Estimated value of all farm productions or crops"
`"
"1860 V0280001" 
"1870 V0110001"
"1880 V0470001"
"1890 V0820001"
"1900 V0790001"
"1910 V0590001"
"1920 V0270001"
"'"'

/*Total Annual Wages in Manufacturing*/ 
`"
"manuf_wages"
"Total Annual Wages in Manufacturing"
`"
"1860 V0140001" 
"1870 V0150001"
"1880 V0110001"
"1890 V0130001"
"1900 V0160001"
"1910 Vmissing"
"1920 V0110001"
"'"'

/*Urban population*/
`"
"pop_urban"
"Urban Population in places 2,500 and Over"
`"
"1860 V0040001" 
"1870 V0050001"
"1880 V0030001"
"1890 V0100001"
"1900 V0000001"
"1910 V0070001"
"1920 V0080001"
"'"'

/*Value of Manufacturing Output*/ 
`"
"manuf_val"
"Value of Manufacturing Output"
`"
"1860 V0080001" 
"1870 V0320001"
"1880 V0180001"
"1890 V0270001"
"1900 V0270001"
"1910 Vmissing"
"1920 V0160001"
"'"'

/*Value of Materials Used in Manufacturing
V0130001: NT19 (HIST1860_CNTY): Cost of raw materials 
V0310001: NT10 (HIST1870_MFG): Value of materials used in manufacturing 
V0200001: NT15 (HIST1880_CNTY): Value of raw materials 
V0250001: NT42 (HIST1890_CNTY): Cost of materials 
V0240001: NT43 (HIST1900_CNTY): Total
V0220001: NT44 (HIST1900_CNTY): Cost of principle materials 
V0220002: NT44 (HIST1900_CNTY): Cost of fuel and rent of power and heat  
V0170001: NT36B (HIST1920_CNTY): Rent and taxes 
V0170002: NT36B (HIST1920_CNTY): Materials 
*/

{;
	gettoken varroot setofvariables: setofvariables;
	gettoken varlabel setofvariables: setofvariables;
	gettoken setofvariables: setofvariables;
	foreach year_var in `setofvariables' {;
		gettoken year varname: year_var;
		use `county`year'', clear;
		gen `varroot'`year'=`varname' ;

		
		label var `varroot'`year' "`varlabel' `year'";
		save `county`year'', replace;
	};
};


/** Farming Calculations ***

Calculate improved land in farms, and percent improved
Farm value (including improvements and buildings)
Farm implements and machinery*/
local areavar	area_farm;
local label_areavar "Area (acres) farm land";
local improvedvar area_imp_farm;
local label_improvedvar "Area (acres) improved farm land";
local pimprovedvar p_imp_farm;
local label_pimprovedvar "Fraction of improved farm land";
local farmval_var farm_val;
local label_farmval_var "Value of farms including land, fences, and buildings";
local farmmach_var farm_mach_val;
local label_farmmach_var "Value of farming Implements and Machinery";
local male_popvar male_pop;
local label_male_popvar "Male population 21 years and older";

foreach year in `allyears' {;
	use `county`year'', clear;
	if `year' == 1860 {;
		/*
		AHV006:      Male >> 20 to 29 years of age
    AHV007:      Male >> 30 to 39 years of age
    AHV008:      Male >> 40 to 49 years of age
    AHV009:      Male >> 50 to 59 years of age
    AHV010:      Male >> 60 to 69 years of age
    AHV011:      Male >> 70 to 79 years of age
    AHV012:      Male >> 80 to 89 years of age
    AHV013:      Male >> 90 to 99 years of age
    AHV014:      Male >> 100 years of age and over
    */
    gen `male_popvar'`year' = 
    AHV006+
		AHV007+
		AHV008+
		AHV009+
		AHV010+
		AHV011+
		AHV012+
		AHV013+
		AHV014+
		AHV015;
		
		/*
		V0230001: NT10 (HIST1860_CNTY): Improved 
		V0230002: NT10 (HIST1860_CNTY): Unimproved 
		*/
		gen `improvedvar'`year' = V0230001;
		gen `areavar'`year' = V0230001+V0230002;
		gen `pimprovedvar'`year' = `improvedvar'`year'/`areavar'`year';
		
		/*
		V0290001: NT2 (HIST1860_AG): Farms 
		V0290002: NT2 (HIST1860_AG): Implements and machinery
		*/
		gen `farmval_var'`year' =V0290001;
		gen `farmmach_var'`year' = V0290002;
	}; else if `year' == 1870 {;
		/*
		Table 4:     Male Population 21 Years of Age and Over
		Universe:    Males 21 Years and Over
		Source code: NT22
		NHGIS code:  AKH
    AKH001:      Total
    */
    gen `male_popvar'`year' = AKH001;
    
		/*
		V0130001: NT24 (HIST1870_CNTY): Improved land 
		V0130002: NT24 (HIST1870_CNTY): Unimproved land: Woodland 
		V0130003: NT24 (HIST1870_CNTY): Unimproved land: Other land  
		*/
		gen `improvedvar'`year' = V0130001;
		gen `areavar'`year' = V0130001+V0130002+V0130003;
		gen `pimprovedvar'`year' = `improvedvar'`year'/`areavar'`year';
		
		/*
		V0360001: NT3 (HIST1870_AG): Farms 
		V0360002: NT3 (HIST1870_AG): Implements and machinery 
		*/
		gen `farmval_var'`year' =V0360001;
		gen `farmmach_var'`year' = V0360002;
	}; else if `year' == 1880 {;
		/*
		Table 4:     Males 21 Years of Age and Over
		Universe:    Males 21 Years and Over
		Source code: NT8
		NHGIS code:  AP8
    AP8001:      Total
    */
    gen `male_popvar'`year' = AP8;

		/*
		V0380001: NT36 (HIST1880_CNTY): Improved: Tilled land 
		V0380002: NT36 (HIST1880_CNTY): Improved: Improved meadows, pastures, etc. 
		V0380003: NT36 (HIST1880_CNTY): Unimproved: Woodlands and forests 
		V0380004: NT36 (HIST1880_CNTY): Unimproved: Other unimproved land 
		*/
		gen `improvedvar'`year' = V0380001;
		gen `areavar'`year' = V0380001+V0380002+V0380003+V0380004;
		gen `pimprovedvar'`year' = `improvedvar'`year'/`areavar'`year';
		
		/*
		V0310001: NT11 (HIST1880_AG): Farmland and improvements 
		V0310002: NT11 (HIST1880_AG): Implements and machinery 
		V0310003: NT11 (HIST1880_AG): Livestock 
		*/
		gen `farmval_var'`year' =V0310001;
		gen `farmmach_var'`year' = V0310002;
	}; else	if `year' == 1890 {;
		
		/*
		Table 4:     Male Population 21 Years of Age and Over by Race/Nativity
		Universe:    Males 21 Years and Over
		Source code: NT14
		NHGIS code:  AUP
    AUP001:      White: Native-born
    AUP002:      White: Foreign-born
    AUP003:      Colored
    */
    gen `male_popvar'`year' = AUP001 + AUP002 +AUP003;
    
		/*
		V0770001: NT8 (HIST1890_AG): Improved land 
		V0770002: NT8 (HIST1890_AG): Unimproved land 
		*/
		gen `improvedvar'`year' = V0770001;
		gen `areavar'`year' = V0770001+V0770002;
		gen `pimprovedvar'`year' = `improvedvar'`year'/`areavar'`year';
		
		/* Incorrectly labeled in NHGIS, actual census doc reads Land, Fences and Buildings
		V0790001: NT9A (HIST1890_AG): Fences and buildings 
		V0790002: NT9A (HIST1890_AG): Implements and machinery 
		V0790003: NT9A (HIST1890_AG): Livestock on land 
		*/
		gen `farmval_var'`year' =V0790001;
		gen `farmmach_var'`year' = V0790002;
		
		
	}; else	if `year' == 1900 {;
		/*
		Table 5:     Males 21 Years of Age and Over
		Universe:    Males 21 Years and Over
		Source code: NT9
		NHGIS code:  AZ4
    AZ4001:      Total
    */
    gen `male_popvar'`year' = AZ4001;
    
		/*
		V0600001: NT55 (HIST1900_CNTY): Improved land in farms 
		V0620001: NT54 (HIST1900_CNTY): Land in farms 
		*/
		gen `improvedvar'`year' = V0600001;
		gen `areavar'`year' = V0620001;
		gen `pimprovedvar'`year' = `improvedvar'`year'/`areavar'`year';
		
		/* 
		V0990001: NT13 (HIST1900_AG): Farm land and improvements (except buildings) 
		V0990002: NT13 (HIST1900_AG): Farm buildings 
		V0990003: NT13 (HIST1900_AG): Farm implements and machinery 
		V0990004: NT13 (HIST1900_AG): Livestock 
		*/
		gen `farmval_var'`year' =V0990001+V0990002;
		gen `farmmach_var'`year' = V0990003;
		
	}; else	if `year' == 1910 {;
		/*
		Table 1:     Total Males of Voting Age
		Universe:    Males of Voting Age
		Source code: NT12
		NHGIS code:  A31
    A31001:      Total
    */
    gen `male_popvar'`year' = A31001;
    
		/*
		V1080001: NT8 (HIST1910_AG): Improved acres in farms 
		V1080002: NT8 (HIST1910_AG): Unimproved Acres in Farms: Woodland 
		V1080003: NT8 (HIST1910_AG): Unimproved Acres in Farms: Other unimproved
		*/
		gen `improvedvar'`year' = V1080001;
		gen `areavar'`year' = V1080001+V1080002+V1080003;
		gen `pimprovedvar'`year' = `improvedvar'`year'/`areavar'`year';
		
		/* 
		V1270001: NT11 (HIST1910_AG): Value of farmland/improvements (excluding buildings), 1910 
		V1270003: NT11 (HIST1910_AG): Value of farm buildings, 1910 
		V1270005: NT11 (HIST1910_AG): Value of farm implements/machinery, 1910 
		V1270007: NT11 (HIST1910_AG): Value of farm livestock, 1910 
		*/
		gen `farmval_var'`year' =V1270001+V1270003;
		gen `farmmach_var'`year' = V1270005;
	}; else	if `year' == 1920 {;
		/*
		Table 2:     Population 21 Years of Age and Over by Sex
		Universe:    Persons 21 Years and Over
		Source code: NT12
		NHGIS code:  A7O
    A7O001:      Male
    A7O002:      Female
    */
    gen `male_popvar'`year' = A7O001;
		/*
		V0290001: NT51 (HIST1920_CNTY): Improved 
		V0290002: NT51 (HIST1920_CNTY): Unimproved: Woodland 
		V0290003: NT51 (HIST1920_CNTY): Unimproved: Other unimproved 
		*/
		gen `improvedvar'`year' = V0290001;
		gen `areavar'`year' = V0290001+V0290002+V0290003;
		gen `pimprovedvar'`year' = `improvedvar'`year'/`areavar'`year';
		
		/* 
		V0140001: NT53 (HIST1920_CNTY): Land in farms 
		V0140002: NT53 (HIST1920_CNTY): Farm buildings 
		V0140003: NT53 (HIST1920_CNTY): Implements and machinery 
		V0140004: NT53 (HIST1920_CNTY): Livestock on farms 
		*/
		gen `farmval_var'`year' =V0140001+V0140002;
		gen `farmmach_var'`year' = V0140003;
	};	else {;
		display "Year `year' not set up.";
	};
	label var `improvedvar'`year' "`label_improvedvar' `year'";
	label var `areavar'`year' "`label_areavar' `year'";
	label var `pimprovedvar'`year' "`label_pimprovedvar' `year'";
	
	label var `farmval_var'`year' "`label_farmval_var' `year'";
	label var `farmmach_var'`year' "`label_farmmach_var' `year'";
	label var `male_popvar'`year' "`label_male_popvar' `year'";
	save `county`year'', replace;
};


/***Calculate Person employed in manufacturing*/
local employvar	manuf_emp;
local label_employvar "Persons employed in manufacturing";
local pemployvar p_manuf_emp;
local label_pemployvar "Fraction of total population employed in manufacturing";
foreach year in `allyears' {;
	use `county`year'', clear;
	if `year' == 1860 {;
		/*1860 does not have*/
		gen `employvar'`year' =.;

	}; else if `year' == 1870 {;
		/*
		V0250001: NT33 (HIST1870_CNTY): Total 
		*/
		gen `employvar'`year' = V0250001;
	}; else	if `year' == 1880 {;
		/* These are called averages but inspecting the numbers
		confirms that they are totals
		Average Number of Females 15 Years of Age and Over Employed in Manufacturing (NT12)
		V0040001: NT12 (HIST1880_CNTY): Total
		Average Number of Males 16 Years of Age and Over Employed in Manufacturing (NT11)
		V0050001: NT11 (HIST1880_CNTY): Total 
		Average Number of Youths and Children Employed in Manufacturing (NT13)
		V0060001: NT13 (HIST1880_CNTY): Total 
		*/
		gen `employvar'`year' = V0040001+V0050001 +V0040001;
	}; else if `year' == 1890 {;
		/*
		Females Over 15 Years of Age Employed in Manufacturing Establishments
		V0200001: NT38 (HIST1890_CNTY): Officers, firm members, and clerks 
		V0200002: NT38 (HIST1890_CNTY): Skilled and unskilled operatives 
		V0200003: NT38 (HIST1890_CNTY): Pieceworkers 
		Males Over 16 Years of Age Employed in Manufacturing Establishments
		V0190001: NT36 (HIST1890_CNTY): Officers, firm members, and clerks 
		V0190002: NT36 (HIST1890_CNTY): Skilled and unskilled operatives 
		V0190003: NT36 (HIST1890_CNTY): Pieceworkers 
		Number of Children Employed in Manufacturing Establishments by Type of Worker (NT40)
		V0120001: NT40 (HIST1890_CNTY): Skilled and unskilled operatives 
		V0120002: NT40 (HIST1890_CNTY): Pieceworkers    
		*/
		gen `employvar'`year' =V0190001+V0190002+V0190003+
							 V0200001+V0200002+V0200003+
							 V0120001+V0120002;
	}; else	if `year' == 1900 {;
		/*
		V0260001: NT32 (HIST1900_CNTY): Total   
		*/
		gen `employvar'`year' = V0260001;
	}; else	if `year' == 1910 {;
		/*
		Does not have
		*/
		gen `employvar'`year' =.;
	}; else	if `year' == 1920 {;
		/*
		V0010001: NT35 (HIST1920_CNTY): Number of wage earners 
		*/
		gen `employvar'`year' = V0010001;
	};	else {;
		display "Year `year' not set up.";

	};
	label var `employvar'`year' "`label_employvar' `year'";
	/*Must have already defined total population*/
	gen `pemployvar'`year' = `employvar'`year'/tpop`year';
	label var `pemployvar'`year' "`label_pemployvar' `year'";
	save `county`year'', replace;
};



/****** Calculate gini for farm size ****/

/*How much assign the topcoded 1000 acre or more farms?*/
local gt1000 = 1500;
local label_ginifarms "Approximate Gini of farm size";
local label_meanfarmsize "Mean farm size";
local label_numfarms "Number of farms";
foreach year in `allyears' {;
	use `county`year'', clear;
	if `year' == 1860 {;
		local ncat =7;
		local size1 =	6;
		local size2 = 14.5;
		local size3 = 20 +(49-20)/2;
		local size4 = 50+ (99-50)/2;
		local size5 = 100+ (499-100)/2;
		local size6 = 500+(999-500)/2;
		local size7 = `gt1000'; 
			
		local varsize1   V0220001;
		local varsize2   V0220002;
		local varsize3   V0220003;
		local varsize4   V0220004;
		local varsize5   V0220005;
		local varsize6   V0220006;
		local varsize7   V0220007;
	};
	else if `year' == 1870 {;
		local ncat =8;
		local size1 =	2;
		local size2 =	6;
		local size3 = 14.5;
		local size4 = 20 +(49-20)/2;
		local size5 = 50+ (99-50)/2;
		local size6 = 100+ (499-100)/2;
		local size7 = 500+(999-500)/2;
		local size8 = `gt1000'; 
		
		local varsize1   V0140001;
		local varsize2   V0140002;
		local varsize3   V0140003;
		local varsize4   V0140004;
		local varsize5   V0140005;
		local varsize6   V0140006;
		local varsize7   V0140007;
		local varsize8   V0140008;
	}; 
	else if `year' == 1880 {;
		local ncat =8;
		local size1 =	2;
		local size2 =	6;
		local size3 = 14.5;
		local size4 = 20 +(49-20)/2;
		local size5 = 50+ (99-50)/2;
		local size6 = 100+ (499-100)/2;
		local size7 = 500+(999-500)/2;
		local size8 = `gt1000';  
		
		local varsize1   V0360001;
		local varsize2   V0360002;
		local varsize3   V0360003;
		local varsize4   V0360004;
		local varsize5   V0360005;
		local varsize6   V0360006;
		local varsize7   V0360007;
		local varsize8   V0360008;
	};
	else if `year' == 1890 {;
		local ncat =7;
		local size1 =	6;
		local size2 = 14.5;
		local size3 = 20 +(49-20)/2;
		local size4 = 50+ (99-50)/2;
		local size5 = 100+ (499-100)/2;
		local size6 = 500+(999-500)/2;
		local size7 = `gt1000'; 
			
		local varsize1   V0760001;
		local varsize2   V0760002;
		local varsize3   V0760003;
		local varsize4   V0760004;
		local varsize5   V0760005;
		local varsize6   V0760006;
		local varsize7   V0760007;
	};  
	else if `year' == 1900 {;
		local ncat =10;
		local size1 =	1.5;
		local size2 =	6;
		local size3 = 14.5;
		local size4 = 20 +(49-20)/2;
		local size5 = 50+ (99-50)/2;
		local size6 = 100+ (174-100)/2;
		local size7 = 175+ (259-175)/2;
		local size8 = 260+ (499-260)/2;
		local size9 = 500+(999-500)/2;
		local size10 = `gt1000';  
		
		local varsize1   V0610001;
		local varsize2   V0610002;
		local varsize3   V0610003;
		local varsize4   V0610004;
		local varsize5   V0610005;
		local varsize6   V0610006;
		local varsize7   V0610007;
		local varsize8   V0610008;
		local varsize9   V0610009;
		local varsize10  V0610010;
	};
	else if `year' == 1910 {;
		local ncat =10;
		local size1 =	1.5;
		local size2 =	6;
		local size3 = 14.5;
		local size4 = 20 +(49-20)/2;
		local size5 = 50+ (99-50)/2;
		local size6 = 100+ (174-100)/2;
		local size7 = 175+ (259-175)/2;
		local size8 = 260+ (499-260)/2;
		local size9 = 500+(999-500)/2;
		local size10 = `gt1000';  
		
		local varsize1   V1070001;
		local varsize2   V1070002;
		local varsize3   V1070003;
		local varsize4   V1070004;
		local varsize5   V1070005;
		local varsize6   V1070006;
		local varsize7   V1070007;
		local varsize8   V1070008;
		local varsize9   V1070009;
		local varsize10  V1070010;
	};
	else if `year' == 1920 {;
		local ncat =10;
		local size1 =	1.5;
		local size2 =	6;
		local size3 = 14.5;
		local size4 = 20 +(49-20)/2;
		local size5 = 50+ (99-50)/2;
		local size6 = 100+ (174-100)/2;
		local size7 = 175+ (259-175)/2;
		local size8 = 260+ (499-260)/2;
		local size9 = 500+(999-500)/2;
		local size10 = `gt1000';  
		
		local varsize1   V0300001;
		local varsize2   V0300002;
		local varsize3   V0300003;
		local varsize4   V0300004;
		local varsize5   V0300005;
		local varsize6   V0300006;
		local varsize7   V0300007;
		local varsize8   V0300008;
		local varsize9   V0300009;
		local varsize10  V0300010;
	};
	else {;
		local ncat =0;
		display "Year `year' not set up.";
	};
	gen gini_farmsize`year' = 0;
	
	forvalues ii= 1/`ncat' {;
		forvalues jj=1/`ncat' {;
			replace gini_farmsize`year' = gini_farmsize`year'
				+ `varsize`ii'' * `varsize`jj'' * abs(`size`ii''-`size`jj'');
		};
	};
	gen numfarms =0;
	forvalues ii= 1/`ncat' {;
		replace numfarms = `varsize`ii''+ numfarms;
	};
	gen meanfarmsize =0;
	forvalues ii= 1/`ncat' {;
		replace meanfarmsize = `varsize`ii''*`size`ii'' + meanfarmsize;
	};
	replace meanfarmsize = meanfarmsize/numfarms;
	replace gini_farmsize`year' = gini_farmsize`year'/(2*meanfarmsize*numfarms^2);
	
	gen numfarms`year' = numfarms;
	gen meanfarmsize`year' = meanfarmsize;
	drop numfarms meanfarmsize;
	label var gini_farmsize "`label_ginifarms' `year'";
	label var meanfarmsize "`label_meanfarmsize' `year'";
	label var numfarms "`label_numfarms' `year'";
	save `county`year'', replace;
};


/*** Standardize and save***/
cd "`OUTDIR'";
foreach year in `allyears' 1970 {;
	use `county`year'', clear;
	/*For some reason District of Columbia is missing information in 1900*/
	if `year' == 1900 {;
		/*Have to get total population from agriculture*/
		replace tpop1900 = V0030001 if countyname =="DISTRICT OF COLUMBIA";
		replace pop_urban1900 = tpop1900 if countyname =="DISTRICT OF COLUMBIA";
	}; 
	
	/*Drop variables that have not been renamed or transformed
	Can add in if need them
	*/
	drop V* A*;
	save county`year', replace;
	outsheet using "county`year'.csv", comma replace;
};


exit;

