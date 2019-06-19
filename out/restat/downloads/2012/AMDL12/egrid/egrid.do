#delimit;
clear;
set more off;
set memory 150m;
set matsize 200;
graph set eps fontface Garamond;
cd "C:\Files\pp\restat\egrid";

*The power plant characteristics and opening and closings dates used in the study come from the EPA's 
*Emissions and Generation Resource Integrated Database (eGrid) for 2007.  
*This database is a comprehensive inventory of the the generation and environmental attributes of power plants.  
*Much of the information in eGrid, including plant opening years, come from the U.S. Department of Energy's 
*Annual Electric Generator Report'' compiled from responses to the EIA-860, a form completed annually by all 
*electric-generating plants.  In addition, eGRID includes plant identification information, geographic coordinates, 
*number of generators, primary fuel, plant nameplate capacity, plant annual net generation, annual NOx, SO2, and 
*mercury emissions, as well as whether or not the plant is a cogeneration plant and whether or not it has installed 
*NOx and/or SO2 control devices.;
*Note: After downloading Egrid, I deleted the header information (leaving variable names), converted everything to
*numbers (to eliminate commas) and saved each sheet as a .csv file;
*Note: capfac=plngenan/(namepcap*8760);

*-------------------------------------------------*;
*---------------BRING IN EGRID DATA---------------*;
*-------------------------------------------------*;
*PREPARE BOILER-LEVEL DATA;
insheet using eGRID2007V1_boiler.csv, clear;
keep orispl so2ctldv noxctldv;
gen scrubber1=0; replace scrubber1=1 if so2ctldv!="";
gen scr1=0; replace scr1=1 if noxctldv=="SCR" | noxctldv=="SR";
replace orispl=round(orispl);
bysort orispl: egen scrubber=max(scrubber1);
bysort orispl: egen scr=max(scr1); drop scrubber1 scr1;
drop if orispl==.; duplicates drop orispl, force; sort orispl;
save temp1.dta, replace;

*PREPARE GENERATOR-LEVEL DATA;
insheet using eGRID2007V1_generator.csv, clear;

keep orispl genyronl namepcap; 
replace orispl=round(orispl);
bysort orispl: egen yearonline=min(genyronl); drop genyronl;
drop if orispl==.; duplicates drop orispl, force; sort orispl;
save temp2.dta, replace;

*PREPARE PLANT-LEVEL DATA;
insheet using eGRID2007V1_plant.csv, clear;
keep pstatabb pname orispl fipsst cntyname lat lon numgen plprmfl plfuelct capfac namepcap chpflag plngenan plnoxan plso2an plhgan plngenan;
replace plhgan="0" if plhgan=="N/A"; rename lat latitude; rename lon longitude;
replace orispl=round(orispl);
drop if orispl==.; duplicates drop orispl, force; destring, replace; sort orispl;

*MERGE BOILER-LEVEL, GENERATOR-LEVEL, AND PLANT-LEVEL DATA;
merge orispl using temp1.dta; assert _merge!=2; drop _merge; sort orispl; 
merge orispl using temp2.dta, unique; assert _merge==3;  drop _merge;
erase temp1.dta; erase temp2.dta;

*USING eGRID DEFINITIONS, KEEP ONLY OIL, GAS, AND COAL PLANTS;
keep if plfuelct=="COAL" | plfuelct=="GAS" | plfuelct=="OIL";

*KEEP PLANTS OVER 100 MEGAWATTS, NON-COGENERATION PLANTS;
keep if namepcap>=100;

*ELIMINATE COGENERATION PLANTS;
drop if chpflag==1;

*FIND CLOSEST PLANT TO ANN ARBOR -- APPROXIMATE;
gen distance=sqrt((latitude-42.22)^2+(longitude+83.75)^2); drop distance;

*KEEP PLANTS BUILT AFTER 1970;
keep if yearonline>1970;

*CREATE DECADE GROUPS;
gen decade=.;
replace decade=2000 if yearonline>2000;
replace decade=1990  if yearonline>1990 & yearonline<=2000;
replace decade=1980  if yearonline>1980 & yearonline<=1990;
replace decade=1970  if yearonline>1970 & yearonline<=1980;
label define decade 2000 "After 2000" 1990 "1991-2000" 1980 "1981-1990" 1970 "1971-1980";
sort decade; by decade: tab plfuelct;

save egrid.dta, replace;

*REPORT COMPLETE LIST OF PLANTS;
sort orispl; replace pname=proper(abbrev(pname,30));
list pname orispl pstatabb latitude longitude plfuelct namepcap if yearonline>2000;
list pname orispl pstatabb latitude longitude plfuelct namepcap if yearonline>1990 & yearonline<=2000;
list pname orispl pstatabb latitude longitude plfuelct namepcap if yearonline>1980 & yearonline<=1990;
list pname orispl pstatabb latitude longitude plfuelct namepcap if yearonline>1970 & yearonline<=1980;

sum if yearonline>=1970 & yearonline<1980;
sum if yearonline>=1980 & yearonline<1990;
sum if yearonline>1992 & yearonline<=2000;
sum if yearonline>=2003;
sum if yearonline==2000;

*MAKE FIGURE FOR 1970s;
use usdb.dta, clear; destring, replace; drop if FIPS==0 | FIPS==2 | FIPS==15 | FIPS>56; 
spmap using "uscoord.dta", id(id) ocolor(gs9) 
	point(data(egrid.dta) xcoord(longitude) ycoord(latitude) size(medium) osize(thick) ocolor(blue) shape(oh)
	select(keep if yearonline>=1970 & yearonline<1980 & pstatabb!="AK" & pstatabb!="HI"));

*MAKE FIGURE FOR 1980s;
use usdb.dta, clear; destring, replace; drop if FIPS==0 | FIPS==2 | FIPS==15 | FIPS>56; 
spmap using "uscoord.dta", id(id) ocolor(gs9) 
	point(data(egrid.dta) xcoord(longitude) ycoord(latitude) size(medium) osize(thick) ocolor(blue) shape(oh)
	select(keep if yearonline>=1980 & yearonline<1990 & pstatabb!="AK" & pstatabb!="HI"));

*MAKE FIGURE FOR 1993-2000;
use usdb.dta, clear; destring, replace; drop if FIPS==0 | FIPS==2 | FIPS==15 | FIPS>56; 
spmap using "uscoord.dta", id(id) ocolor(gs9) 
	point(data(egrid.dta) xcoord(longitude) ycoord(latitude) size(medium) osize(thick) ocolor(blue) shape(oh)
	select(keep if yearonline>1992 & yearonline<=2000 & pstatabb!="AK" & pstatabb!="HI"));

*MAKE FIGURE FOR 1993-2000;
use usdb.dta, clear; destring, replace; drop if FIPS==0 | FIPS==2 | FIPS==15 | FIPS>56; 
spmap using "uscoord.dta", id(id) ocolor(gs9) 
	point(data(egrid.dta) xcoord(longitude) ycoord(latitude) size(medium) osize(thick) ocolor(blue) shape(oh)
	select(keep if yearonline>=2003 & pstatabb!="AK" & pstatabb!="HI"));

