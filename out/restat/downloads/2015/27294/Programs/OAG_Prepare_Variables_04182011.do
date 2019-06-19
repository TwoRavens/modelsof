#delimit;
clear;
set mem 3g;
set more off;

cd "../Data";

cap log close;
log using oag.smcl, replace;


****************************************************************;

foreach  yr in 97 98 99 00 01 {;

use oag`yr'v1, clear;
keep if stops == "00";
drop if opcar == "N";
drop if  dep_arpt ==  arr_arpt;

cap keep if depiatactryname == "USA" & arriatactryname == "USA";
cap keep if carrdom1 == "US";

cap rename carrier1 carrier;
cap rename flightno1 flt_num;
cap rename localarrtime arr_time;
cap rename localdaysofop days_op;
cap rename efffrom eff_from;
cap rename effto eff_to;
cap rename flyingtime flt_time;
cap rename specificacft acft_type;

keep carrier flt_num dep_arpt arr_arpt dep_time arr_time days_op eff_from
                         eff_to flt_time acft_type year qr shair;

replace carrier = "AA" if carrier == "TW" & (year >= 2002 | (year == 2001 & qr >= 2));
replace shairldes = "AA" if shairldes == "TW" & (year >= 2002 | (year == 2001 & qr >= 2));

replace carrier = "US" if carrier == "HP" & (year >= 2006 | (year == 2005 & qr >= 4));
replace shairldes = "US" if shairldes == "HP" & (year >= 2006 | (year == 2005 & qr >= 4));

gen diff =  eff_to- eff_from + 1;

gen x = _n;
qui compress;

expand diff;

bysort x: gen day = eff_from + _n - 1;
format day %td;
drop x;

drop if year(day) != year;

gen dow = dow(day);
replace dow = 7 if dow == 0;

tostring dow, replace;
keep if strpos(days_op,dow) > 0;

keep if month(day) == 1 | month(day) == 4 |  month(day) == 7 | month(day) == 10; 
gen month = month(day);
drop diff;
duplicates drop;

xcollapse (min) d1 = day if dow == "1", by(year month) saving (ash, replace);
dmerge year month using ash, nokeep;

xcollapse (min) d2 = day, by(year month) saving (ash1, replace);
dmerge year month using ash1, nokeep;

keep if day >= (d1+7)*(year<=2001)+d2*(year>2001) & day <= (d1 + 13)*(year<=2001)+(d2+6)*(year>2001);

tab day;

drop d1 d2 _merge eff* days_op dow;

keep if quarter(day) == qr;

***** eliminate duplicate flights - that appear under different carriers but with same operating carrier and same flight number *****;

gen opcarrier = shair if length(shair) == 2;
replace opcarrier = carrier if opcarrier == "";

bysort flt_num dep_arpt arr_arpt opcarrier day: gen x =[_n];
display "Duplicate Flights, `yr'";
tab x;
bysort flt_num dep_arpt arr_arpt opcarrier day: egen y = max(x);
display "Carrier/Op. Carrier for Duplicate Observations, `yr'";
tab carrier opcarrier if y>1;
keep if y == 1 | (y>1 & shair != "");    ***** keep if operating carrier is not missing *****;
drop x y;

bysort flt_num dep_arpt arr_arpt opcarrier day: gen x =[_n];
bysort flt_num dep_arpt arr_arpt opcarrier day: egen y = max(x);
keep if y == 1 | (y>1 & x==2);           ***** if more than one has opcar or none has, then keep only #2 ****;

drop x y;
qui compress;
save help`yr', replace;

};

************* 2002 - 2003 - include seats **********;

foreach  yr in 02 03 {;

use oag`yr'v1, clear;
keep if stops == "00";
drop if opcar == "N";
drop if  dep_arpt ==  arr_arpt;

cap keep if depiatactryname == "USA" & arriatactryname == "USA";
cap keep if carrdom1 == "US";

cap rename carrier1 carrier;
cap rename flightno1 flt_num;
cap rename localarrtime arr_time;
cap rename localdaysofop days_op;
cap rename efffrom eff_from;
cap rename effto eff_to;
cap rename flyingtime flt_time;
cap rename specificacft acft_type;

keep carrier flt_num dep_arpt arr_arpt dep_time arr_time days_op eff_from *seats*
                         eff_to flt_time acft_type shair year qr;

replace carrier = "AA" if carrier == "TW" & (year >= 2002 | (year == 2001 & qr >= 2));
replace shairldes = "AA" if shairldes == "TW" & (year >= 2002 | (year == 2001 & qr >= 2));

replace carrier = "US" if carrier == "HP" & (year >= 2006 | (year == 2005 & qr >= 4));
replace shairldes = "US" if shairldes == "HP" & (year >= 2006 | (year == 2005 & qr >= 4));

gen diff =  eff_to- eff_from + 1;

gen x = _n;
qui compress;

expand diff;

bysort x: gen day = eff_from + _n - 1;
format day %td;
drop x;

drop if year(day) != year;

gen dow = dow(day);
replace dow = 7 if dow == 0;

tostring dow, replace;
keep if strpos(days_op,dow) > 0;

keep if month(day) == 1 | month(day) == 4 |  month(day) == 7 | month(day) == 10; 
gen month = month(day);
drop diff;
duplicates drop;

xcollapse (min) d1 = day if dow == "1", by(year month) saving (ash, replace);
dmerge year month using ash, nokeep;

xcollapse (min) d2 = day, by(year month) saving (ash1, replace);
dmerge year month using ash1, nokeep;

keep if day >= (d1+7)*(year<=2001)+d2*(year>2001) & day <= (d1 + 13)*(year<=2001)+(d2+6)*(year>2001);

tab day;

drop d1 d2 _merge eff* days_op dow;

keep if quarter(day) == qr;

***** eliminate duplicate flights - that appear under different carriers but with same operating carrier and same flight number *****;

gen opcarrier = shair if length(shair) == 2;
replace opcarrier = carrier if opcarrier == "";

bysort flt_num dep_arpt arr_arpt opcarrier day: gen x =[_n];
display "Duplicate Flights, `yr'";
tab x;
bysort flt_num dep_arpt arr_arpt opcarrier day: egen y = max(x);
display "Carrier/Op. Carrier for Duplicate Observations, `yr'";
tab carrier opcarrier if y>1;
keep if y == 1 | (y>1 & shair != "");    ***** keep if operating carrier is not missing *****;
drop x y;

bysort flt_num dep_arpt arr_arpt opcarrier day: gen x =[_n];
bysort flt_num dep_arpt arr_arpt opcarrier day: egen y = max(x);
keep if y == 1 | (y>1 & x==2);           ***** if more than one has opcar or none has, then keep only #2 ****;

drop x y;
qui compress;
save help`yr', replace;

};

************* 2007 *********************************;

#delimit;

use OAG_2007_access04152011, clear;

rename EFFECTIVE_DATE y;
gen z = "20";
gen x = reverse(y);
gen m = reverse(substr(x,1,2));
egen year = concat(z m);
gen mo = reverse(substr(x,3,3));
gen month = 1 if mo == "JAN";
replace month = 2 if mo == "FEB";
replace month = 3 if mo == "MAR";
replace month = 4 if mo == "APR";
replace month = 5 if mo == "MAY";
replace month = 6 if mo == "JUN";
replace month = 7 if mo == "JUL";;
replace month = 8 if mo == "AUG";
replace month = 9 if mo == "SEP";
replace month = 10 if mo == "OCT";
replace month = 11 if mo == "NOV";
replace month = 12 if mo == "DEC";
gen day = reverse(substr(x,6,2));
destring year day, replace;
gen EFFECTIVE_DATE = mdy(month,day,year);
drop y z x m year mo day month;
format EFFECTIVE_DATE %td;

rename DISCONTINUE_DATE y;
gen z = "20";
gen x = reverse(y);
gen m = reverse(substr(x,1,2));
egen year = concat(z m);
gen mo = reverse(substr(x,3,3));
gen month = 1 if mo == "JAN";
replace month = 2 if mo == "FEB";
replace month = 3 if mo == "MAR";
replace month = 4 if mo == "APR";
replace month = 5 if mo == "MAY";
replace month = 6 if mo == "JUN";
replace month = 7 if mo == "JUL";
replace month = 8 if mo == "AUG";
replace month = 9 if mo == "SEP";
replace month = 10 if mo == "OCT";
replace month = 11 if mo == "NOV";
replace month = 12 if mo == "DEC";
gen day = reverse(substr(x,6,2));
destring year day, replace;
gen DISCONTINUE_DATE = mdy(month,day,year);
drop y z x m year mo day month;
format DISCONTINUE_DATE %td;

keep if stops == 0;
rename origin dep_arpt;
rename destination arr_arpt;
drop if  dep_arpt ==  arr_arpt;

cap rename PUBLISHED_CARRIER carrier;
cap rename FLIGHT_NUMBER flt_num;
cap rename ARRIVAL_TIME arr_time;
cap rename DEPARTURE_TIME dep_time;
cap rename DAYS_OF_OPERATION days_op;
cap rename EFFECTIVE_DATE eff_from;
cap rename DISCONTINUE_DATE eff_to;
cap rename ELAPSED_TIME flt_time;
cap rename EQUIPMENT_TYPE acft_type;
cap rename operator shairldes;
cap rename SEATS_CONFIGURATION seats;

keep carrier flt_num dep_arpt arr_arpt dep_time arr_time days_op eff_from *seats*
                         eff_to flt_time acft_type shairldes;


gen hour = hh(dep_time);
gen minute = mm(dep_time);

tostring hour minute, replace;
gen x = "0";

egen x1 = concat(x hour) if length(hour)==1;
replace hour = x1 if x1 != "";
drop x1;

egen x1 = concat(x minute) if length(minute)==1;
replace minute = x1 if x1 != "";
drop x1;

drop dep_time;
egen dep_time = concat(hour minute);
drop hour minute x; 

*********;

gen hour = hh(arr_time);
gen minute = mm(arr_time);

tostring hour minute, replace;
gen x = "0";

egen x1 = concat(x hour) if length(hour)==1;
replace hour = x1 if x1 != "";
drop x1;

egen x1 = concat(x minute) if length(minute)==1;
replace minute = x1 if x1 != "";
drop x1;

drop arr_time;
egen arr_time = concat(hour minute);
drop hour minute x; 

**********************************;

tostring flt_num, replace;

**********************************;

gen diff =  eff_to- eff_from + 1;

gen x = _n;
qui compress;

expand diff;

bysort x: gen day = eff_from + _n - 1;
format day %td;
drop x;

#delimit;
gen y = year(day);
tab y;
drop y;

gen dow = dow(day);
replace dow = 7 if dow == 0;

tostring dow days_op, replace;

keep if strpos(days_op,dow) > 0;

keep if month(day) == 1 | month(day) == 4 |  month(day) == 7 | month(day) == 10; 
gen month = month(day);
drop diff;
duplicates drop;

gen year = year(day);
gen qr = quarter(day);

replace carrier = "AA" if carrier == "TW" & (year >= 2002 | (year == 2001 & qr >= 2));
replace shairldes = "AA" if shairldes == "TW" & (year >= 2002 | (year == 2001 & qr >= 2));

replace carrier = "US" if carrier == "HP" & (year >= 2006 | (year == 2005 & qr >= 4));
replace shairldes = "US" if shairldes == "HP" & (year >= 2006 | (year == 2005 & qr >= 4));
duplicates drop;

keep if (day >= mdy(1,8,2007) & day <= mdy(1,14,2007)) | 
        (day >= mdy(4,9,2007) & day <= mdy(4,15,2007)) | 
        (day >= mdy(7,9,2007) & day <= mdy(7,15,2007)) | 
        (day >= mdy(10,8,2007) & day <= mdy(10,14,2007)); 

tab day;

gen a = subinstr(acft_type,"'","",1);

drop eff* days_op dow acft_type;
rename a acft_type;

***** eliminate duplicate flights - that appear under different carriers but with same operating carrier and same flight number *****;

gen opcarrier = shair if length(shair) == 2;
replace opcarrier = carrier if opcarrier == "";

bysort flt_num dep_arpt arr_arpt opcarrier day: gen x =[_n];
display "Duplicate Flights, 07";
tab x;
bysort flt_num dep_arpt arr_arpt opcarrier day: egen y = max(x);
display "Carrier/Op. Carrier for Duplicate Observations, 07";
tab carrier opcarrier if y>1;
keep if y == 1 | (y>1 & shair != "");    ***** keep if operating carrier is not missing *****;
drop x y;

bysort flt_num dep_arpt arr_arpt opcarrier day: gen x =[_n];
bysort flt_num dep_arpt arr_arpt opcarrier day: egen y = max(x);
keep if y == 1 | (y>1 & x==2);           ***** if more than one has opcar or none has, then keep only #2 ****;

drop x y;
tostring flt_time, replace;
qui compress;
save help07, replace;


************************************************************************************;
************************************************************************************;
************************************************************************************;
************************************************************************************;
************************************************************************************;

foreach  yr in 97 98 99 00 01 02 03 07 {;

************************************************************************************;
********  CREATE VARIABLES          ************************************************;
************************************************************************************;

use help`yr', clear;

**** I. Competition Measures *************;
**** I.1 # carriers on a route - more than 5 round-trips per week (1 round-trip per day for 2007) ********;
gen z = "-";
egen x = concat(dep_arpt z arr_arpt);
egen y = concat(arr_arpt z dep_arpt);
gen OD = x if dep_arpt <= arr_arpt;
replace OD = y if arr_arpt < dep_arpt;
drop x y z;

sort carrier;
merge carrier using "domestic_airlines.dta", nokeep;
display "Foreign Carriers, `yr'";
tab carrier if _m != 3;

gen US = (_m == 3);
drop _m;

gen x = 1;
xcollapse (sum) nr_flights = x if US == 1, by(year month OD carrier) saving (ash, replace);
dmerge year month OD carrier using ash, nokeep;
replace nr_flights = 0 if nr_flights == .;
replace nr_flights = nr_flights / 2;
* replace nr_flights = nr_flights * 5 if year == 2007; *** we only have one day per week in 2007 ***;
drop x _m;
sort year month OD;
save help`yr'a, replace;

keep if nr_flights >= 5;
egen nr_carriers = nvals(carrier), by(year month OD);
keep year month OD nr_carriers;
duplicates drop;
sort year month OD;
save ash, replace;

use help`yr'a, clear;
sort year month OD;
dmerge year month OD using ash, nokeep;
replace nr_carriers = 0 if nr_car == .;
drop _m nr_flights;
save help`yr'a, replace;

**** I.2. HHI on a route (using # flights) ****;
gen x = 1;
collapse (sum) nr_flights = x if US == 1, by(year month dep_arpt arr_arpt carrier);

xcollapse (sum) tot_nr_flights = nr_flights, by(year month  dep_arpt arr_arpt) saving (ash, replace);
dmerge year month  dep_arpt arr_arpt using ash, nokeep;

gen share = nr_flights / tot_nr_flights;
gen share2 = share * share;

*** check that shares sum up to 1 ***;
egen tr = sum(share),by(year month dep_arpt arr_arpt);
display "Distribution of Sum of Shares (Should add to 1), `yr'";
sum tr, d;

collapse (sum) HHI = share2, by(year month dep_arpt arr_arpt);
sort year month  dep_arpt arr_arpt;
save ash, replace;

use help`yr'a, clear;
sort year month  dep_arpt arr_arpt;
dmerge year month  dep_arpt arr_arpt using ash, nokeep;
drop _m;
qui compress;
save help`yr'a, replace;

**** II. Congestion Measures *************;
**** II.1 # flights/day at origin and destination  ********;

gen x = 1;
xcollapse (sum) nr_deps_day = x, by(day dep_arpt) saving(ash, replace);
dmerge day dep_arpt using ash, nokeep;
rename nr_deps_day nr_deps_day_orig;
replace nr_deps_day_orig = 0 if nr_deps_day_orig == .;

rename dep_arpt help;
rename arr_arpt dep_arpt;
dmerge day dep_arpt using ash, nokeep;
rename nr_deps_day nr_deps_day_dest;
replace nr_deps_day_dest = 0 if nr_deps_day_dest == .;

rename dep_arpt arr_arpt;
rename help dep_arpt;

xcollapse (sum) nr_arrs_day = x, by(day arr_arpt) saving(ash, replace);
dmerge day arr_arpt using ash, nokeep;
rename nr_arrs_day nr_arrs_day_dest;
replace nr_arrs_day_dest = 0 if nr_arrs_day_dest == .;

rename arr_arpt help;
rename dep_arpt arr_arpt;
dmerge day arr_arpt using ash, nokeep;
rename nr_arrs_day nr_arrs_day_orig;
replace nr_arrs_day_orig = 0 if nr_arrs_day_orig == .;

rename arr_arpt dep_arpt;
rename help arr_arpt;

**** II.2 # flights/hour at origin and destination  ********;

gen hour = substr(dep_time,1,2);
destring hour, replace;

xcollapse (sum) nr_deps_hour = x, by(day hour dep_arpt) saving(ash, replace);
dmerge day hour dep_arpt using ash, nokeep;
rename nr_deps_hour nr_deps_hour_orig;
replace nr_deps_hour_orig = 0 if nr_deps_hour_orig == .;

rename dep_arpt help;
rename arr_arpt dep_arpt;
dmerge day hour dep_arpt using ash, nokeep;
rename nr_deps_hour nr_deps_hour_dest;
replace nr_deps_hour_dest = 0 if nr_deps_hour_dest == .;

rename dep_arpt arr_arpt;
rename help dep_arpt;

xcollapse (sum) nr_arrs_hour = x, by(day hour arr_arpt) saving(ash, replace);
dmerge day hour arr_arpt using ash, nokeep;
rename nr_arrs_hour nr_arrs_hour_dest;
replace nr_arrs_hour_dest = 0 if nr_arrs_hour_dest == .;

rename arr_arpt help;
rename dep_arpt arr_arpt;
dmerge day hour arr_arpt using ash, nokeep;
rename nr_arrs_hour nr_arrs_hour_orig;
replace nr_arrs_hour_orig = 0 if nr_arrs_hour_orig == .;

rename arr_arpt dep_arpt;
rename help arr_arpt;
drop x hour _m;
qui compress;
save help`yr'a, replace;


**** III.3 airport HHI - origin/dest       ********;
**** III.4  define hubs at origin/dest   ********;

gen x = 1;
collapse (sum) nr_f = x, by(year month dep_arpt carrier);
xcollapse (sum) tot_nr_f = nr_f, by(year month dep_arpt) saving(ash, replace);
dmerge year month dep_arpt using ash, nokeep;
gen share = nr_f / tot_nr_f;
gen hub = (share >= 0.5);
gen share2 = share * share;
collapse (sum) HH = share2 (max) hub, by(year month dep_arpt);
save ash, replace;

use help`yr'a, clear;
dmerge year month dep_arpt using ash, nokeep;
rename HH HHI_dep_arpt;
rename hub hub_dep_arpt;

rename dep_arpt help;
rename arr_arpt dep_arpt;
dmerge year month dep_arpt using ash, nokeep;
rename HH HHI_arr_arpt;
rename hub hub_arr_arpt;

rename dep_arpt arr_arpt;
rename help dep_arpt;
qui compress;
save help`yr'a, replace;

**** III.5  #flights on route ********;

gen x = 1;
xcollapse (sum) nr_flights_route_day = x if US == 1, by(year day dep_arpt arr_arpt) saving(ash, replace);
dmerge year day dep_arpt arr_arpt using ash, nokeep;
drop  _m x;
save help`yr'a, replace;

******* IV. Presence of LCCs *****************;

gen x = 1;
xcollapse (sum) help = x, by(year month OD carrier) saving (ash, replace);
dmerge year month OD carrier using ash, nokeep;
replace help = help / 2;
* replace help = help * 5 if year == 2007;
gen LCC = (help >= 5 & (carrier == "WN" | carrier == "FL" | carrier == "B6" | carrier == "F9" | carrier == "TZ" | carrier == "G4" |
                  carrier == "SX" | carrier == "NK" | carrier == "SY"  | carrier == "J7" |  carrier == "N7" | carrier == "DH" ));
gen WN = (help >= 5 & carrier == "WN");
xcollapse (max) LCC WN, by(year month OD) saving(ash, replace);
drop LCC WN help;

dmerge year month OD using ash, nokeep;
replace LCC = 0 if LCC == .;
replace WN = 0 if WN == .;
drop _m;
save help`yr'a, replace;

/******* V. Network Variables   ****************
******* V.1 - #flihgts of airline arriving to the
         origin prior to departure of a given flight
         (30 mins - 1h 30 mins, 1h 30 mins - 2h 30 mins; 2h 30 mins - 3h 30 mins)  ********/

keep  carrier arr_arpt arr_time day;
duplicates drop;
gen hour = substr(arr_time,1,2);
gen min = substr(arr_time,3,2);
destring hour min, replace;
gen time = hour * 60 + min;
keep carrier arr_arpt day time;
sort carrier arr_arpt day time;
bysort  day carrier arr_arpt: gen x = _n;
reshape wide  time, i(day carrier arr_arpt) j(x);
qui compress;
rename arr_arpt dep_arpt;
sort day carrier dep_arpt;
save ash, replace;

use help`yr'a, clear;
sort day carrier dep_arpt;
merge day carrier dep_arpt using ash, nokeep;
gen hour = substr(dep_time,1,2);
gen min = substr(dep_time,3,2);
destring hour min, replace;
gen time = hour * 60 + min;
egen nr_flt_arr_Origin_30_130 = rcount(time*), c (@ <= time - 30 & @ > time - 90);
egen nr_flt_arr_Origin_130_230 = rcount(time*), c (@ <= time - 90 & @ > time - 150);
egen nr_flt_arr_Origin_230_330 = rcount(time*), c (@ <= time - 150 & @ >= time - 210);

drop time* hour min _m;
qui compress;
save help`yr'a, replace;


keep  carrier dep_arpt dep_time day;
duplicates drop;
gen hour = substr(dep_time,1,2);
gen min = substr(dep_time,3,2);
destring hour min, replace;
gen time = hour * 60 + min;
keep carrier dep_arpt day time;
sort carrier dep_arpt day time;
bysort  day carrier dep_arpt: gen x = _n;
reshape wide  time, i(day carrier dep_arpt) j(x);
qui compress;
rename dep_arpt arr_arpt;
sort day carrier arr_arpt;
save ash, replace;

use help`yr'a, clear;
sort day carrier arr_arpt;
merge day carrier arr_arpt using ash, nokeep;
gen hour = substr(arr_time,1,2);
gen min = substr(arr_time,3,2);
destring hour min, replace;
gen time = hour * 60 + min;
egen nr_flt_dep_Dest_30_130 = rcount(time*), c (@ >= time + 30 & @ < time + 90);
egen nr_flt_dep_Dest_130_230 = rcount(time*), c (@ >= time + 90 & @ < time + 150);
egen nr_flt_dep_Dest_230_330 = rcount(time*), c (@ >= time + 150 & @ <= time + 210);

drop time* hour min _m US;
qui compress;
save help`yr'a, replace;

};


***********************************************************;
use help97a.dta, clear;
append using help98a.dta;
append using help99a.dta;
append using help00a.dta;
append using help01a.dta;
append using help02a.dta;
append using help03a.dta;
append using help07a.dta;


rename qr quarter;
rename dep_arpt origin;
rename arr_arpt dest;

drop carrier shair;
duplicates drop;

save "oag_04192011.dta", replace;

display "# obs: OAG data 1997-2003, 2007";
count;

use origin dest year quarter HHI using
        "oag_04192011.dta", clear;
duplicates drop;
egen trend = group(year quarter);
egen od = group(origin dest);
tsset od trend;
gen HHI_1yr_future = f4.HHI;
gen HHI_halfyear_future = f2.HHI;
gen HHI_1qr_future = f1.HHI;
drop trend od HHI;
sort origin dest year quarter;
save ash, replace;

use "oag_04192011.dta", clear;
sort origin dest year quarter;
merge origin dest year quarter using ash, nokeep;
drop _m;
save, replace;

use "oag_04192011.dta", clear;
sort origin dest;
dmerge origin dest using
     "DistNS.dta", nokeep;
drop _m;

display "# obs with missing distances";
count if distance == .;

gen hour = substr(flt_time,1,3) if  length(flt_time)==5;
replace hour = substr(flt_time,1,2) if length(flt_time)==4;  
replace hour = "0" if year == 2007;

gen min = substr(flt_time,4,2) if  length(flt_time)==5;
replace min = substr(flt_time,3,2) if length(flt_time)==4; 
replace min = flt_time if year == 2007;

destring hour min, replace;
gen flt_time1 = hour * 60 + min;

gen mpm = distance / flt_time1;
gen outliers = (flt_time1 >= 890 | flt_time1 == 0 | mpm >= 10);
drop mpm;

xcollapse (min) min_flt_time = flt_time1 if outliers == 0, by(origin dest year quarter) saving(ash, replace);
dmerge origin dest year quarter using ash;
drop _m hour min;


drop year month quarter flt_time ;
save "oag_04192011.dta", replace;


cap erase ash.dta;
cap erase ash1.dta;
cap erase help97.dta;
cap erase help98.dta;
cap erase help99.dta;
cap erase help00.dta;
cap erase help01.dta;
cap erase help02.dta;
cap erase help03.dta;
cap erase help07.dta;

cap erase help97a.dta;
cap erase help98a.dta;
cap erase help99a.dta;
cap erase help00a.dta;
cap erase help01a.dta;
cap erase help02a.dta;
cap erase help03a.dta;
cap erase help07a.dta;

log close;
exit;
