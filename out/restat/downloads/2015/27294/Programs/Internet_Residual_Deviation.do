#delimit;
clear;
set mem 2g;
set more off;
set matsize 2000;

cd "../Data";

tempfile temp;
use Sample_04192011, clear;
cap drop x;
keep if opcarrier == "AA" | opcarrier == "AS" | opcarrier == "CO" | opcarrier == "DL" |
        opcarrier == "NW" | opcarrier == "UA" | opcarrier == "US" | opcarrier == "WN" |
        opcarrier == "HP";

drop if opcarrier == "WN" & year <= 1999;

count;

save `temp', replace;
collapse (sum) passengers, by(origin);
gsort -passengers;
keep in 1/100;

keep origin;
sort origin;
save `temp'1, replace;

use `temp', clear;
dmerge origin using `temp'1;
keep if _m==3;
drop _m;

rename origin x;
rename dest origin;
dmerge origin using `temp'1;
keep if _m==3;
drop _m;

rename origin dest;
rename x origin;
count;
**** regressions ********;

dmerge origin dest using "DistNS.dta", nokeep;
drop _m;

gen month = month(flightdate);
egen segment = group(origin dest);
egen seg_day = group(segment year month);

egen org_day = group(origin year month);
egen org_day_car = group(origin opcarrier year month);
egen org_car = group(origin opcarrier);
egen yr_month = group(year month);
egen car_yr_month = group(opcarrier year month);
drop  min_flt_time month;
compress;

qui tab opcarrier, gen (cr);
egen aircraft = group(acft_type);
qui tab acft_type, gen(arcft);


qui tab yr_month, gen(ym);
qui tab car_yr_month, gen(cym);
qui tab org_car, gen(oc);

gen z = 1;

drop if depdelay > 360;

gen arrdelayDum = (arrdelay >= 15);

drop if  InterCPSadj == .;
drop if arrdelay == . ;
drop if depdelay == . ;
drop if actualelaps == . ;
gen inter_HHI = InterCPSadj * HHI;
gen inter_monop_w = InterCPSadj * monop_w;
gen inter_duop_w = InterCPSadj * duop_w;
gen inter_comp_w = InterCPSadj * comp_w;

gen log_InterCPS = log(InterCPSadj);
gen log_inter_HHI = log_InterCPS * HHI;
gen log_inter_monop_w = log_InterCPS * monop_w;
gen log_inter_duop_w = log_InterCPS * duop_w;
gen log_inter_comp_w = log_InterCPS * comp_w;

gen empl_perc = empl_adj / popul_adj;
gen log_incpc = log(incpc_adj);
gen log_pop = log(popul_adj);

gen log_schelapsedtime = log(schelapsedtime);
gen arredelayDum = (arrdelay >= 15);
gen log_total_actual_time = log(total_actual_time);

gen log_Fare = log(Fare);
gen log_LF = log(load_factor);

count;

save `temp', replace;


*** Instruments for fare and load factors - 
Airline's average fare/LF on reverse segment, i.e. if we look at the airline X on segment A-B,
 then the instrument is airline's average fare on B-A. ****;


keep origin dest opcarrier year quarter Fare load_factor;
rename origin x;
rename dest origin;
rename x dest;
rename Fare instrum1_fare;
rename load_factor instrum1_lf;
sort origin dest opcarrier year quarter;
duplicates drop;
save `temp'reverse, replace;

use `temp', clear;
sort origin dest opcarrier year quarter;
merge origin dest opcarrier year quarter using `temp'reverse, nokeep;
drop _merge;   /*** note that there are missing values in instrum1  ***/

count;
save `temp', replace;

*** Instrument2  ******************;

keep origin dest distance;
duplicates drop;

egen p20 = pctile(distance), p(20);
egen p40 = pctile(distance), p(40);
egen p60 = pctile(distance), p(60);
egen p80 = pctile(distance), p(80);

gen quantile = 1 if distance <= p20;
replace quantile = 2 if quantile == . & distance <= p40;
replace quantile = 3 if quantile == . & distance <= p60;
replace quantile = 4 if quantile == . & distance <= p80;
replace quantile = 5 if quantile == . ;

keep origin dest quantile;
sort origin dest;
save `temp'dist_q,  replace;

use `temp', clear;
sort origin dest;
merge origin dest using `temp'dist_q, nokeep;
drop _merge;
gen revenue = Fare * passengers;

count;
save `temp', replace;

keep quantile opcarrier revenue Fare passengers passengers_t100 seats_t100 year quarter;
duplicates drop;

collapse (sum) revenue_q = revenue pass_q1 = passengers pass_q2 = passengers_t100 seats_q = seats_t100 ,
     by(year quarter opcarrier quantile);
save `temp'1, replace;

use `temp', clear;
sort year quarter opcarrier quantile;
merge year quarter opcarrier quantile using `temp'1, nokeep;
drop _m;

gen instrum2_fare = (revenue_q - revenue) / (pass_q1 - passengers);
gen instrum2_lf = (pass_q2 - passengers_t100) / (seats_q - seats_t100);

drop quantile revenue_q pass_q* seats_q revenue revenue;

keep if log_schelapsedtime *  arrdelay *   depdelay * log_total_actual_time  * arrdelayDum * Fare * load_factor != .;

codebook segment seg_day org_car;
count;

label var InterCPS "INTERNET";
label var HHI "HHI";
label var inter_HHI "INTERNET * HHI";
label var late_arrival "LATE ARRIVAL"; 
label var scheduled_buffer "SCHEDULED BUFFER";
label var flight_in_day "FLIGHT IN DAY";
label var log_Fare "LOG (AVG. FARE)";
label var log_LF "LOG (LOAD FACTOR)";

dmerge year quarter origin dest opcarrier using instruments1, nokeep;

* dmerge year quarter arpcode opcarrier using instruments2, nokeepe;

gen instrum1_inter = instrum1 * InterCPS;
gen instrum2_inter = instrum2 * InterCPS;
gen instrum4_inter = instrum4 * InterCPS;


save `temp', replace;

***** Table 4 *****;

use `temp', clear;
display "Table 3";
sum schelapsedtime arrdelay depdelay total_actual_time 
        InterCPSadj log_incpc log_pop empl_perc HHI late_arrival scheduled_buffer flight_in_day
         Fare load_factor nr_deps_hour_orig nr_deps_hour_dest nr_arrs_hour_dest nr_arrs_hour_orig
	 HHI_dep_arpt HHI_arr_arpt;
         
**************** Different Fixed Effects ************;

qui areg InterCPS arcft*, r absorb(segment) ;
predict resid1, resid;
display "Distribution of Internet residuals, With Aircraft and Segment Fixed Effects";
sum resid1, d;

qui areg InterCPS cym* arcft*, r absorb(segment) ;
predict resid2, resid;
display "Distribution of Internet residuals, With Time, Aircraft and Segment Fixed Effects";
sum resid2, d;
