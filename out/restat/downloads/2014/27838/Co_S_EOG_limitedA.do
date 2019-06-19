* Co_S_EOG_limitedA.do is the file that combines all student End of Grade raw data files together.
* In particular it creates a single file from years 1995-2006 for 
* EOG. A year variable is added.
* It is labeled limitedA because only a subset of all variables found in the raw EOG
* files are retained due to data storage limitations (RAAM memory in stata).
* NOTE: year is always the second year of the school year so 1999 is for the 1998-1999 school year

#delimit;
clear;
pause off;
set more off;
set mem 800m;
capture log close;

* output File name;
local outfile S_EOG_limitedA;

***********************************************************************************
* First, we merge together all grade data for each year and keep the variables of interest.;
* Each year is saved as a separate file. In the end all of the separate year files ;
* are compiled together. This is done partly to reduce memory costs.; 

**below are the variables we want to keep from the raw data files;
* No tv varaible in 1995;
local keepers95 ethnic grade lea mastid mathscal 
	pared readscal schlcode sex teachid year mathach readach except limeng
	ldmath ldoth ldread ldwrite makeup;
* freeread missing in g7 in year 1999 and for all grades prior to 1999;
local keepers9698 ethnic grade lea mastid mathscal 
	pared readscal schlcode sex teachid tv year mathach readach except limeng
	ldmath ldoth ldread ldwrite makeup;
local keepers99 ethnic grade lea mastid mathscal 
	pared readscal schlcode sex teachid tv year mathach readach except limeng
	ldmath ldoth ldread ldwrite makeup title1;
* Year 2000 Variables;
local keepers9900 ethnic grade lea mastid mathscal
	pared readscal schlcode sex teachid tv year mathach readach 
	freeread except schlunch limeng
	ldmath ldoth ldread ldwrite makeup title1;
* Added adminst variable in 2001;
local keepers0102 ethnic grade lea mastid mathscal
	pared readscal schlcode sex teachid tv year mathach readach 
	freeread except schlunch limeng
	ldmath ldoth ldread ldwrite administ makeup title1;
* No limeng, use lep (2003);
local keepers03 ethnic grade lea mastid mathscal 
	pared readscal schlcode sex teachid tv year mathach readach 
	freeread except schlunch lep
	ldmath ldoth ldread ldwrite administ makeup title1;
* No lep, use lepstat (2004-2005);
local keepers0405 ethnic grade lea mastid mathscal 
	pared readscal schlcode sex teachid tv year mathach readach 
	freeread except schlunch lepstat
	ldmath ldoth ldread ldwrite administ makeup title1;
* No lepstat, use lepcurrent, no schlunch use frl (2006);
local keepers06 ethnic grade lea mastid mathscal 
	pared readscal schlcode sex teachid tv year mathach readach 
	freeread except frl lep_current
	ldmath ldoth ldread ldwrite administ makeup title1;


use eog3pub95_1; 
gen year=1995;
keep `keepers95';
**start with the above file;
*First, 3rd-8th grade 1995;
foreach num2 of numlist 4/8{;
	append using eog`num2'pub95_1;
	replace year=1995 if year==.;
	keep `keepers95';
};
save Co_`outfile'_95, replace;

* 3rd-4th grade 1996;
use eog3pub96_1, clear; 
gen year=1996;
keep `keepers9698';
**start with the above file;
append using eog4pub96_1;
replace year=1996 if year==.;
keep `keepers9698';
save Co_`outfile'_96, replace;

foreach num3 in 97 98{;
	use eog3pub`num3'_1; 
	gen year=19`num3';
	keep `keepers9698';
	**start with the above file;
	*Next, 4th-8th grade;
	foreach num2 of numlist 4/8{;
		append using eog`num2'pub`num3'_1;
		replace year=19`num3' if year==.;
		keep `keepers9698';
	};
	save Co_`outfile'_`num3', replace;
};

use eog3pub99_1; 
gen year=1999;
keep `keepers9900';
**start with the above file;
*Next, 4th-8th grade;
foreach num2 of numlist 4/8{;
	append using eog`num2'pub99_1;
	replace year=1999 if year==.;
	keep `keepers9900';
};
save Co_`outfile'_99, replace;

use eog3pub00_1; 
gen year=2000;
keep `keepers9900';
**start with the above file;
*Next, 4th-8th grade;
foreach num2 of numlist 4/8{;
	append using eog`num2'pub00_1;
	replace year=2000 if year==.;
	keep `keepers9900';
};
save Co_`outfile'_00, replace;

foreach num3 in 01 02 {;
	use eog3pub`num3'_1; 
	gen year=20`num3';
	keep `keepers0102';
	**start with the above file;
	*Next, 4th-8th grade;
	foreach num2 of numlist 4/8{;
		append using eog`num2'pub`num3'_1;
		replace year=20`num3' if year==.;
		keep `keepers0102';
	};
	save Co_`outfile'_`num3', replace;
};

use eog3pub03_1; 
gen year=2003;
keep `keepers03';
**start with the above file;
*Next, 4th-8th grade;
foreach num2 of numlist 4/8{;
	append using eog`num2'pub03_1;
	replace year=2003 if year==.;
	keep `keepers03';
};
save Co_`outfile'_03, replace;

foreach num3 in 04 05{;
	use eog3pub`num3'_1; 
	gen year=20`num3';
	keep `keepers0405';
	**start with the above file;
	*Next, 4th-8th grade;
	foreach num2 of numlist 4/8{;
		append using eog`num2'pub`num3'_1;
		replace year=20`num3' if year==.;
		keep `keepers0405';
	};
	save Co_`outfile'_`num3', replace;
};

use eog3pub06_1; 
gen year=2006;
keep `keepers06';
**start with the above file;
*Next, 4th-8th grade;
foreach num2 of numlist 4/8{;
	append using eog`num2'pub06_1;
	replace year=2006 if year==.;
	keep `keepers06';
	};
save Co_`outfile'_06, replace;


* Next, we merge together all the years of data into a single ;
* longitudinal file;
use Co_`outfile'_95;
foreach num in 96 97 98 99 00 01 02 03 04 05 06{;
	append using Co_`outfile'_`num';
};
* Added variable labels 8/22/08;
label variable year "end of school-year";
label variable grade "grade";
save Co_`outfile', replace;

log close;




