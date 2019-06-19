#delimit;
clear;
set seed 123456789;
set mem 3000m; 
set matsize 300;
set more off;
cd "/rdcprojects/mc1/mc00595/temp/RESTAT_revision/clean";
*log using "/rdcprojects/mc1/mc00595/temp/RESTAT_revision/clean/May3rd2009.log", replace;

local states ak al ar az ca co ct dc de fl ga hi ia id il in ks ky la ma md me mi mn mo ms mt nc nd ne nh nj nm nv ny oh ok or pa ri sc sd tn tx ut va vt wa wi wv wy;

/*;
*CLEAR ALL CENSUS FILES -- CAREFUL! DO NOT UNCOMMENT THIS;
foreach x of local states {; clear; gen temp=1;
save "/rdcprojects/mc1/mc00595/temp/RESTAT_revision/censusValidityTest/census`x'.dta", replace; 
*save "/rdcprojects/mc1/mc00595/temp/RESTAT_revision/census/census`x'.dta", replace;};
*/;

*-----------------------------------------------------------*
*----KEEP LATITUDE AND LONGITUDE OF NEAREST FACILITY--------*
*-----------------------------------------------------------*;
*KEEP PLANT INFORMATION AS LOCAL MACROS;
use "/rdcprojects/mc1/mc00595/data/Egrid_Original_Data/plants.dta", clear;
*keep if decade==1990; 
keep if decade!=1990;  *FOR VALIDITY TEST ONLY;
keep latitude longitude; 
local vars latitude longitude; local n=_N; gen n=_n; 
forvalues y=1/`n' {; foreach z of local vars {; quietly sum `z' if n==`y'; local `z'`y'=r(mean); }; };

*LOOP OVER ALL STATES;
foreach x of local states {;  display "STARTING WITH `x'";

*-----------------------------------------------------------*
*-------------PREPARE GEOGRAPHY FILES-----------------------*
*-----------------------------------------------------------*;
*LOAD GEOGRAPHIC VARIABLES FOR 2000;
use "/rdcprojects/mc1/mc00595/data/Census_2000_Original_Data/sedf`x'01.dta", clear;
keep bcseq block county intplat intplon tract state; destring, replace;  
save temp1.dta, replace;

*LOAD GEOGRAPHIC VARIABLES FOR 1990;
use "/rdcprojects/mc1/mc00595/data/Census_1990_Original_Data/cen1990`x'sg.dta", clear;
keep do bcseq block blkpart county tract state; sort county tract block blkpart; drop if bcseq==.;
drop if state==6  & county==XXX  & tract==XXXXXX    & block==XXX & blkpart==X & bcseq==XXXX;  *An odd duplicate for CA with no hhs;
drop if state==36 & county==XXX  & tract==XXXXXX  & block==XXX & blkpart==X & bcseq==XXXX;  *An odd duplicate for NY with no hhs;
drop if state==39 & county==XXX & tract==XXXXXX & block==XXX & blkpart==X & bcseq==XXXX;  *An odd duplicate for OH with no hhs;
drop if state==51 & county==XXX & tract==XXX    & block==XXX & blkpart==X & bcseq==XXXX;  *An odd duplicate for VA with no hhs;
sort county tract block blkpart; save temp2.dta, replace;

*LOAD GEOCORR90 VARIABLES FOR 1990;
use "/rdcprojects/mc1/mc00595/data/Geocorr90_Original_Data/`x'.dta", clear;
gen length1=length(block); gen temp=substr(block,length1,length1); gen blkpart=0;  
replace blkpart=1  if temp=="A";  replace blkpart=2  if temp=="B";  replace blkpart=3  if temp=="C";  
replace blkpart=4  if temp=="D";  replace blkpart=5  if temp=="E";  replace blkpart=6  if temp=="F";  
replace blkpart=7  if temp=="G";  replace blkpart=8  if temp=="H";  replace blkpart=9  if temp=="I";  
replace blkpart=10 if temp=="J";  replace blkpart=11 if temp=="K";  replace blkpart=12 if temp=="L";  
replace blkpart=13 if temp=="M";  replace blkpart=14 if temp=="N";  replace blkpart=15 if temp=="O";  
replace blkpart=16 if temp=="P";  replace blkpart=17 if temp=="Q";  replace blkpart=18 if temp=="R";  
replace blkpart=19 if temp=="S";  replace blkpart=20 if temp=="T";  replace blkpart=21 if temp=="U";  
replace blkpart=22 if temp=="V";  replace blkpart=23 if temp=="W";  replace blkpart=24 if temp=="X";  
replace blkpart=25 if temp=="Y";  replace blkpart=26 if temp=="Z";  replace tract=round(tract*100);  
gen length2=length1-1 if blkpart>0; replace block=substr(block,1,length2); destring block, replace;
sort county tract block blkpart; merge county tract block blkpart using temp2.dta, unique; drop if _merge!=3;   
drop _merge temp length1 length2 pop cntyname; rename intptlng intplon; sort do bcseq;

*APPEND YEAR 2000 DATA;
gen year=1990; append using append using temp1.dta; replace year=2000 if year==.;

*CLEAN DISTANCE VARIABLES;
replace intplat=intplat/1000000 if year==2000; 
replace intplon=intplon/1000000 if year==2000; 
replace intplon=-intplon if year==1990; 
gen distance=9999; gen latitude=9999; gen longitude=9999; 
recast double distance; format distance %12.6f;

*FIND CLOSEST PLANT;
foreach i of numlist 1/`n' {; 
gen distance`i'=sqrt((69.1*(intplat-`latitude`i''))^2+(69.1*(intplon-`longitude`i'')*cos(intplat/57.3))^2);
quietly replace distance=distance`i' if distance`i'<=distance; 
quietly replace latitude=`latitude`i'' if distance`i'<=distance; 
quietly replace longitude=`longitude`i'' if distance`i'<=distance; 
drop distance`i';  };

*REPORT FRACTION OF BLOCKS NEAR PLANT;
quietly sum distance; display "OUT OF `r(N)' TOTAL CENSUS BLOCKS IN `x'"; 
quietly sum distance if distance<=10.5; display "THERE WERE `r(N)' BLOCKS WITHIN TEN MILES: "; 
sort year state county tract block blkpart; save tempblocks.dta, replace;

*---------------------------------------------------*
*-------CREATE BLOCK IDENTIFIERS--------------------*
*---------------------------------------------------*;
*MERGE RELATIONSHIP FILES WITH BLOCKS FROM 2000 CENSUS;
use "/rdcprojects/mc1/mc00595/temp/relationship/RELATIONSHIP`x'.dta", clear;
rename state00 state; rename county00 county; rename tract00 tract; rename block00 block; gen year=2000;
sort year state county tract block; merge year state county tract block using tempblocks.dta;
rename state state00; rename county county00; rename tract tract00; rename block block00; rename bcseq bcseq00; drop blkpart; 
keep if _merge==3; drop _merge; save temp0.dta, replace;
*note(1): the idea is to keep the observations in the relationship files corresponding to blocks within 10.5 miles;
*note(2): here we drop observations farther away than 10.5 miles and those for 1990;

*MERGE RELATIONSHIP FILES WITH BLOCKS FROM 1990 CENSUS;
use "/rdcprojects/mc1/mc00595/temp/relationship/RELATIONSHIP`x'.dta", clear;
rename state90 state; rename county90 county; rename tract90 tract; rename block90 block; rename blkpart90 blkpart; gen year=1990;
sort year state county tract block blkpart; merge year state county tract block blkpart using tempblocks.dta, uniqusing;
rename state state90; rename county county90; rename tract tract90; rename block block90; rename blkpart blkpart90; rename bcseq bcseq90;
keep if _merge==3; drop _merge; append using temp0.dta;

*ASSIGN A UNIQUE ID NUMBER TO THE SMALLEST CONSISTENT GEOGRAPHIC UNITS ACROSS 1990 and 2000;
gen uniqueid=.; recast double uniqueid; format uniqueid %15.3f;
egen n90=group(state90 county90 tract90 block90 blkpart90);
egen n00=group(state00 county00 tract00 block00);
replace uniqueid=n90+.1 if (bflag90!="p" & bflag00!="p");
replace uniqueid=n90+.2 if (bflag90=="p" & bflag00!="p");
replace uniqueid=n00+.3 if (bflag90!="p" & bflag00=="p");
save temp.dta, replace;

*MANY-TO-MANY MATCHES ARE IDENTIFIED WITH Ps IN BOTH FLAG POSITIONS;
display "currently working on state `x'";
keep if bflag90=="p" & bflag00=="p";     
local y=1; while `y'>0 {;
bysort n90: egen max=max(n00); 
bysort n90: egen min=min(n00);
bysort county90 tract90: egen maxval=max(max*(max!=min));
bysort county90 tract90: egen minval=min(min*(max==maxval)+1000000000*(max!=maxval));
replace n00=minval if n00==maxval; 
sum state90 if max!=min; local y=r(N); drop max min maxval minval; };
egen temp=group(n00); replace uniqueid=temp+.4; drop temp;
save temp0.dta, replace; 

*MERGE MANY-TO-MANY LINKS WITH OTHER LINK TYPES;
use temp.dta, clear; keep if bflag90!="p" | bflag00!="p"; append using temp0.dta;
replace uniqueid=state00*10000000+uniqueid; save temp.dta, replace;
gen temp=.;  format temp %15.3f; replace temp=int(uniqueid); replace temp=uniqueid-temp; tab temp; drop temp;

*SAVE GEOGRAPHIC VARIABLES FOR 2000, NOW WITH UNIQUE ID;
rename state00 state; rename county00 county; rename tract00 tract; rename block00 block; rename bcseq00 bcseq;
keep if year==2000; keep bcseq block county intplat intplon tract state uniqueid distance latitude longitude;
bysort bcseq: egen sd=sd(uniqueid); replace sd=1 if sd>0 & sd!=.; tab sd; drop sd;  *THIS SHOULD BE MOSTLY ZEROS; 
bysort bcseq: egen mm=mode(uniqueid), minmode; replace uniqueid=mm; drop mm;        *KEEP MOST COMMON UNIQUEID FOR EACH BCSEQ;
duplicates drop bcseq, force; sort bcseq; save yr2000geography.dta, replace;

*SAVE GEOGRAPHIC VARIABLES FOR 1990, NOW WITH UNIQUE ID;
use temp.dta, clear; rename state90 state; rename county90 county; rename tract90 tract; 
		       rename block90 block; rename blkpart90 blkpart; rename bcseq90 bcseq;
keep if year==1990; keep do bcseq block blkpart county tract state uniqueid distance latitude longitude intplat intplon;
bysort do bcseq: egen sd=sd(uniqueid); replace sd=1 if sd>0 & sd!=.; tab sd; drop sd;  *THIS SHOULD BE MOSTLY ZEROS; 
bysort do bcseq: egen mm=mode(uniqueid), minmode; replace uniqueid=mm; drop mm;        *KEEP MOST COMMON UNIQUEID FOR EACH BCSEQ;
duplicates drop do bcseq, force; sort do bcseq; save yr1990geography.dta, replace;

*------------------------------------------------*
*---------MERGE WITH HOUSEHOLD VARIABLES---------*
*------------------------------------------------*;
*LOAD HOUSEHOLD VARIABLES FOR 2000;
use "/rdcprojects/mc1/mc00595/data/Census_2000_Original_Data/sedf`x'02.dta", clear;
keep bcseq hseq hinc nphu grnt sbedrm svalue hwt sbldgsz syrblt scplumb sacres nrc p65 stenure;  
sort bcseq; merge bcseq using yr2000geography.dta, uniqusing; 
keep if _merge==3; drop _merge; sort hseq; save temp3.dta, replace;

*LOAD PERSON VARIABLES FOR 2000;
use "/rdcprojects/mc1/mc00595/data/Census_2000_Original_Data/sedf`x'03.dta", clear;
gen ind=real(indlong); gen employedinenergy=0; replace employedinenergy=1 if ind==57 | ind==58 | ind==59; 
bysort hseq: egen energyworkers=sum(employedinenergy); 
keep if pporder==1; keep hseq qsex qspan qhigh qmig raceb qrace1 energyworkers;
sort hseq; merge hseq using temp3.dta, unique; drop if _merge==1; drop _merge hseq; gen year=2000; save temp4.dta, replace;

*LOAD HOUSEHOLD VARIABLES FOR 1990;
use "/rdcprojects/mc1/mc00595/data/Census_1990_Original_Data/cen1990`x'sh.dta", clear;
keep do bcseq hseq hinc np h2 h4 h5a h6 ha6 h7a ha7a h9 h10 h17 h19a hwt nrc p65 grnt; sort do bcseq;
merge do bcseq using yr1990geography.dta, uniqusing; drop if _merge!=3; drop _merge; sort do hseq; save temp6.dta, replace;

*LOAD PERSON VARIABLES FOR 1990;
use "/rdcprojects/mc1/mc00595/data/Census_1990_Original_Data/cen1990`x'sp.dta", clear;
rename q28 ind; gen employedinenergy=0; replace employedinenergy=1 if ind==450 | ind==451 | ind==452;
bysort hseq: egen energyworkers=sum(employedinenergy);
sort do hseq q2; by do hseq: gen n=_n; keep if n==1; 
keep do hseq q3 q4 q7 q12 q14a energyworkers;
sort do hseq; merge do hseq using temp6.dta, unique; drop if _merge==1; drop _merge do hseq; gen year=1990;
destring, replace; append using temp4.dta; destring, replace; 

*CLEAN PROPERTY VALUES;
replace svalue=h6 if year==1990; drop h6; gen value=.; 
replace value=5000    if svalue==1  & year==1990; replace value=12500   if svalue==2  & year==1990;
replace value=17500   if svalue==3  & year==1990; replace value=22500   if svalue==4  & year==1990;
replace value=27500   if svalue==5  & year==1990; replace value=32500   if svalue==6  & year==1990;
replace value=37500   if svalue==7  & year==1990; replace value=42500   if svalue==8  & year==1990;
replace value=47500   if svalue==9  & year==1990; replace value=52500   if svalue==10 & year==1990;
replace value=57500   if svalue==11 & year==1990; replace value=62500   if svalue==12 & year==1990;
replace value=67500   if svalue==13 & year==1990; replace value=72500   if svalue==14 & year==1990;
replace value=77500   if svalue==15 & year==1990; replace value=85000   if svalue==16 & year==1990;
replace value=95000   if svalue==17 & year==1990; replace value=112500  if svalue==18 & year==1990;
replace value=137500  if svalue==19 & year==1990; replace value=162500  if svalue==20 & year==1990;
replace value=187500  if svalue==21 & year==1990; replace value=225000  if svalue==22 & year==1990;
replace value=275000  if svalue==23 & year==1990; replace value=350000  if svalue==24 & year==1990;
replace value=450000  if svalue==25 & year==1990; replace value=550000  if svalue==26 & year==1990;
replace value=5000    if svalue==1  & year==2000; replace value=12500   if svalue==2  & year==2000;
replace value=17500   if svalue==3  & year==2000; replace value=22500   if svalue==4  & year==2000;
replace value=27500   if svalue==5  & year==2000; replace value=32500   if svalue==6  & year==2000;
replace value=37500   if svalue==7  & year==2000; replace value=45000   if svalue==8  & year==2000;
replace value=55000   if svalue==9  & year==2000; replace value=65000   if svalue==10 & year==2000;
replace value=75000   if svalue==11 & year==2000; replace value=85000   if svalue==12 & year==2000;
replace value=95000   if svalue==13 & year==2000; replace value=112500  if svalue==14 & year==2000;
replace value=132500  if svalue==15 & year==2000; replace value=162500  if svalue==16 & year==2000;
replace value=175000  if svalue==17 & year==2000; replace value=225000  if svalue==18 & year==2000;
replace value=275000  if svalue==19 & year==2000; replace value=350000  if svalue==20 & year==2000;
replace value=450000  if svalue==21 & year==2000; replace value=625000  if svalue==22 & year==2000;
replace value=875000  if svalue==23 & year==2000; replace value=1125000 if svalue==24 & year==2000; drop svalue;

*DROP BLOCKS WITHOUT PEOPLE, DROP SOME VA
*PREPARE COVARIATES;
replace nphu=np if year==1990; drop np; 
replace sbldgsz=h2 if year==1990; drop h2;
replace sbedrm=h9-1 if year==1990; drop h9; replace sbedrm=0 if sbedrm==-1;
replace scplumb=h10 if year==1990; drop h10;
replace syrblt=h17 if year==1990; drop h17;
replace stenure=h4 if year==1990; drop h4;
replace scplumb=0 if scplumb==2;
rename grnt rent;
gen acre1=0; replace acre1=1 if (year==1990 & h19a==2 & h5a!=1) | (year==2000 & sacres==2); drop h19a;
gen acre10=0; replace acre10=1 if (year==1990 & h5a==1) | (year==2000 & sacres==3); drop h5a sacres;
gen femalehead=0; replace femalehead=1 if (year==1990 & q3==2) | (year==2000 & qsex==2); drop qsex q3;
gen hsgrad=0; replace hsgrad=1 if (year==1990 & q12>=10) | (year==2000 & qhigh>=9); 
gen collegegrad=0; replace collegegrad=1 if (year==1990 & q12>=14) | (year==2000 & qhigh>=13); drop q12 qhigh;
gen movedlast5=0; replace movedlast5=1 if (year==1990 & q14a!=1) | (year==2000 & qmig!=1); drop q14a qmig;
gen black=0; replace black=1 if (year==1990 & q4==972) | (year==2000 & raceb==1); drop q4 raceb qrace1;
gen hispanic=0; replace hispanic=1 if (year==1990 & q7!=1) | (year==2000 & qspan!=100); drop q7 qspan;
gen occupied=0; replace occupied=1 if nphu!=0;
gen owneroccupied=0; replace owneroccupied=1 if stenure==1 | stenure==2; drop stenure;
gen multiunit=0; replace multiunit=1 if sbldgsz>=4; compress;

*-----------------------------------------------*
*---CREATE DEMOGRAPHIC AND HOUSING INDICATORS---*
*-----------------------------------------------*;
replace syrblt=syrblt-1 if year==2000; 
rename acre1 Bacre1; rename acre10 Bacre10; rename scplumb Bscplumb;
forvalues i=1/5 {; gen BR`i'=0;   replace BR`i'=1 if sbedrm==`i'; };
forvalues i=1/8 {; gen BAGE`i'=0; replace BAGE`i'=1 if syrblt==`i'; };
forvalues i=1/9 {; gen BTP`i'=0;  replace BTP`i'=1 if sbldgsz==`i'; };  
drop sbedrm syrblt sbldgsz; compress;

*-------------------------------------------*
*-----CREATE 1990 AND 2000 VARIABLES--------*
*-------------------------------------------*;
local Y90only="Bscplumb Bacre1 Bacre10 femalehead movedlast5 multiunit BR1 BR2 BR3 BR4 BR5 BAGE1 BAGE2 
	       BAGE3 BAGE4 BAGE5 BAGE6 BAGE7 BAGE8 BTP1 BTP2 BTP3 BTP4 BTP5 BTP6 BTP7 BTP8 BTP9";
local Y00only="energyworkers";
local Yboth="p65 nrc hinc rent nphu value hsgrad collegegrad black hispanic occupied owneroccupied";
foreach y of local Y90only {; gen Y90`y'=.; replace Y90`y'=`y' if year==1990; drop `y'; };
foreach y of local Y00only {; gen Y00`y'=.; replace Y00`y'=`y' if year==2000; drop `y'; };
foreach y of local Yboth {; gen Y90`y'=.; replace Y90`y'=`y' if year==1990; 
			    gen Y00`y'=.; replace Y00`y'=`y' if year==2000; drop `y'; };
save temp7.dta, replace;

*-------------------------------------------*
*-----COLLAPSE SEPARATELY 1990 AND 2000-----*
*-------------------------------------------*;
keep if year==1990;
collapse (mean) Y90* (rawsum) hwt_tot90=hwt [weight=hwt], by(uniqueid); sort uniqueid; save temp8.dta, replace;
use temp7.dta, clear; keep if year==2000;
collapse (max) state county tract distance intplat intplon latitude longitude 
         (mean) Y00* (rawsum) hwt_tot=hwt [weight=hwt], by(uniqueid);
sort uniqueid; merge uniqueid using temp8.dta; drop _merge;

sort intplat intplon; compress; 
save "/rdcprojects/mc1/mc00595/temp/RESTAT_revision/censusValidityTest/census`x'.dta", replace; 
*save "/rdcprojects/mc1/mc00595/temp/RESTAT_revision/census/census`x'.dta", replace; };

*--------------------------------------------*
*-------KEEP PLANTS WE NEED------------------*
*--------------------------------------------*;
use "/rdcprojects/mc1/mc00595/data/Egrid_Original_Data/plants.dta";
*keep if decade==1990; 
keep if decade!=1990; *FOR VALIDITY TEST ONLY;
drop pstatabb pname numgen scrubber scr decade;
sort latitude longitude; save tempPLANTS.dta, replace;

*--------------------------------------------*
*-------APPEND STATES------------------------*
*--------------------------------------------*;
use "/rdcprojects/mc1/mc00595/temp/RESTAT_revision/censusValidityTest/censusak.dta";
*use "/rdcprojects/mc1/mc00595/temp/RESTAT_revision/census/censusak.dta", clear;
local states al ar az ca co ct dc de fl ga hi ia id il in ks ky la ma md me mi mn mo ms mt nc nd ne nh nj nm nv ny oh ok or pa ri sc sd tn tx ut va vt wa wi wv wy;

foreach x of local states {;
append using "/rdcprojects/mc1/mc00595/temp/RESTAT_revision/censusValidityTest/census`x'.dta"; 
*append using "/rdcprojects/mc1/mc00595/temp/RESTAT_revision/census/census`x'.dta";};

*--------------------------------------------*
*-------MERGE IN PLANT CHARACTERISTICS-------*
*--------------------------------------------*;
sort latitude longitude;
merge latitude longitude using tempPLANTS.dta; 
keep if _merge==3;
drop _merge; erase tempPLANTS.dta;

*-------------------------------------------*
*-------CREATE DOWNWIND VARIABLE------------*
*-------------------------------------------*;
gen HHlatRAD=intplat*_pi/180; gen PLANTlatRAD=latitude*_pi/180;
gen HHlonRAD=intplon*_pi/180; gen PLANTlonRAD=longitude*_pi/180;
gen bearing=atan2(sin(PLANTlonRAD-HHlonRAD)*cos(PLANTlatRAD),cos(HHlatRAD)*sin(PLANTlatRAD)-sin(HHlatRAD)*cos(PLANTlatRAD)*cos(PLANTlonRAD-HHlonRAD));
replace bearing=bearing*180/_pi+180;  *BEARING FROM PLANT TO HOME, e.g. 180 HOME IS DUE SOUTH OF PLANT;
gen diff1=abs(wind-bearing); gen diff2=360-diff1; gen difference=min(diff1,diff2); 
gen downwind=0; replace downwind=1 if difference>90; 
gen downwind45=0; replace downwind45=1 if difference>135;
drop bearing wind diff* HH* PLANT* latitude longitude intplat intplon;

*-------------------------------------------------*
*---CREATE LOGS AND OTHER CONSTRUCTED VARIABLES---*
*-------------------------------------------------*;
replace Y90value=. if Y90value==0; gen logY90value=log(Y90value);
replace Y90rent=.  if Y90rent==0;  gen logY90rent=log(Y90rent);  
replace Y00value=. if Y00value==0; gen logY00value=log(Y00value);
replace Y00rent=.  if Y00rent==0;  gen logY00rent=log(Y00rent);  
drop Y90value Y90rent;

*CREATE NEAR VARIABLE;
gen near=0; replace near=1 if distance<=2; 

*ADD INTERACTIONS;
replace Y90hinc=Y90hinc/1000;
gen Y90hinc2=Y90hinc^2;    gen Y90hinc3=Y90hinc^3;
gen Y90nphu2=Y90nphu^2;    gen Y90nphu3=Y90nphu^3; 
gen Y90nrc2=Y90nrc^2;      gen Y90nrc3=Y90nrc^3; 
gen Y90p65_2=Y90p65^2;     gen Y90p65_3=Y90p65^3;  

*POPULATION UNDER 18 AND OVER 65 AS PERCENT, CREATE TOTAL BLOCK POPULATION;
replace Y00nrc=Y00nrc/Y00nphu;
replace Y00p65=Y00p65/Y00nphu;
gen totpop=(hwt_tot)*Y00nphu;

*DROP BLOCKS WITHOUT PEOPLE, DROP SOME VARIABLES WE DON'T NEED;
drop if Y00black==. | Y90black==.;
gen gasplant=0; replace gasplant=1 if plfuelct=="GAS";
drop Y00energyworkers;

*MERGE WITH NCDB DATA;
*Note: Geo2000 is a unique tract identifier created by geolytics as fn of state, county and tract;
gen geo2000=0; recast double geo2000; format geo2000 %12.0f; 
replace geo2000=state*1000000000+county*1000000+tract; 
sort geo2000; merge geo2000 using "/rdcprojects/mc1/mc00595/data/NCDB_Original_Data/Controls.dta";
drop if _merge==2; drop _merge; *DROP OBSERVATIONS IN NCDB WITHOUT MATCH;

save "/rdcprojects/mc1/mc00595/temp/RESTAT_revision/RegressionSampleValidityMay.dta", replace;
*save "/rdcprojects/mc1/mc00595/temp/RESTAT_revision/RegressionSampleFullSampleApril.dta", replace;

