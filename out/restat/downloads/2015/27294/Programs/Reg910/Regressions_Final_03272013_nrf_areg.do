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

***** Table 3 *****;

collapse (mean) schelapsedtime arrdelay depdelay, by (opcarrier);
list;

***** Table 4 *****;

use `temp', clear;
sum schelapsedtime arrdelay depdelay total_actual_time 
        InterCPSadj log_incpc log_pop empl_perc HHI late_arrival scheduled_buffer flight_in_day
         Fare load_factor nr_deps_hour_orig nr_deps_hour_dest nr_arrs_hour_dest nr_arrs_hour_orig;
         
**************** Different Fixed Effects ************;

foreach fe in segment {;

****  Demean w instruments ************;

use `temp', clear;

gen log_instrum1_fare = log(instrum1_fare);
gen log_instrum1_lf = log(instrum1_lf);
gen log_instrum2_fare = log(instrum2_fare);
gen log_instrum2_lf = log(instrum2_lf);

keep if log_instrum2_lf * log_instrum2_fare !=. ;

foreach name in InterCPSadj HHI inter_HHI LCC Fare log_Fare load_factor log_LF
                log_instrum2_lf log_instrum2_fare log_instrum1_lf log_instrum1_fare
                instrum1 instrum2 instrum4 instrum1_inter instrum2_inter instrum4_inter
                empl_perc log_incpc log_pop nr_flights_route_day log_total_actual_time
                nr_flt_arr_Origin_30_130 nr_flt_arr_Origin_130_230 nr_flt_arr_Origin_230_330 nr_flt_dep_Dest_30_130 
                nr_flt_dep_Dest_130_230 nr_flt_dep_Dest_230_330 HHI_dep_arpt hub_dep_arpt HHI_arr_arpt hub_arr_arpt 
                nr_deps_day_orig nr_deps_day_dest nr_arrs_day_dest nr_arrs_day_orig nr_deps_hour_orig nr_deps_hour_dest 
                nr_arrs_hour_dest nr_arrs_hour_orig
                late_arrival scheduled_buffer flight_in_day
                arrdelay depdelay schelapsedtime actualelapsedtime total_actual_time 
                monop_w duop_w comp_w inter_monop_w inter_duop_w inter_comp_w
                log_InterCPS log_inter_HHI log_inter_monop_w log_inter_duop_w log_inter_comp_w 
                arrdelayDum log_schelapsedtime {;
                        sort `fe';
                        by `fe': gen x = sum(`name' * z) / sum(z);
                        by `fe': replace x = x[_N];
                        replace `name' = `name' - x;
                        drop x;
};

/**capture for X in num 1/1000:  sort `fe' \
                        by `fe': gen x = sum(mdtX * z) / sum(z) \
                        by `fe': replace x = x[_N] \
                        replace mdtX = mdtX - x \
                        drop x**; */
                        
capture for X in num 1/1000:  sort `fe' \
                        by `fe': gen x = sum(ymX * z) / sum(z) \
                        by `fe': replace x = x[_N] \
                        replace ymX = ymX - x \
                        drop x;                        

capture for X in num 1/1000:  sort `fe' \
                        by `fe': gen x = sum(ocX * z) / sum(z) \
                        by `fe': replace x = x[_N] \
                        replace ocX = ocX - x \
                        drop x;                        

capture for X in num 1/1000:  sort `fe' \
                        by `fe': gen x = sum(cymX * z) / sum(z) \
                        by `fe': replace x = x[_N] \
                        replace cymX = cymX - x \
                        drop x;                        

capture for X in num 1/1000:  sort `fe' \
                        by `fe': gen x = sum(crX * z) / sum(z) \
                        by `fe': replace x = x[_N] \
                        replace crX = crX - x \
                        drop x;         

capture for X in num 1/1000:  sort `fe' \
                        by `fe': gen x = sum(arcftX * z) / sum(z) \
                        by `fe': replace x = x[_N] \
                        replace arcftX = arcftX - x \
                        drop x;                                                

drop z;

display "`fe', W/Instrum";
sum arrdelay schelapsedtime log_schelapsedtime total_actual_time depdelay log_total_actual_time  arrdelayDum 
        log_InterCPS log_Fare log_LF empl_perc log_incpc log_pop     
         monop_w comp_w duop_w log_inter_monop_w log_inter_comp_w log_inter_duop_w nr_flights_route_day 
         nr_deps_hour_orig nr_deps_hour_dest nr_arrs_hour_dest nr_arrs_hour_orig HHI_dep_arpt hub_dep_arpt 
         HHI_arr_arpt hub_arr_arpt  nr_flt_arr_Origin_130_230 nr_flt_arr_Origin_230_330 nr_flt_dep_Dest_30_130 
         nr_flt_dep_Dest_130_230 nr_flt_arr_Origin_30_130 nr_flt_dep_Dest_230_330 nr_deps_day_orig nr_deps_day_dest
                late_arrival scheduled_buffer flight_in_day
         nr_arrs_day_dest nr_arrs_day_orig ;
save `temp'w_instrum, replace;

******* regressions  *******************;

foreach name in /* arrdelay total_actual_time */ depdelay arrdelayDum   {;

foreach name1 in segment /* car_yr_month org_day_car */ {;

use `temp', clear;

qui areg `name' InterCPS empl_perc log_incpc log_pop
                late_arrival scheduled_buffer flight_in_day
                HHI
                log_LF
                nr_deps_hour_orig nr_deps_hour_dest nr_arrs_hour_dest nr_arrs_hour_orig
                HHI_dep_arpt HHI_arr_arpt nr_flt_arr_Origin_130_230 nr_flt_arr_Origin_230_330 nr_flt_dep_Dest_30_130 
                nr_flt_dep_Dest_130_230 nr_flt_arr_Origin_30_130 nr_flt_dep_Dest_230_330 nr_deps_day_orig nr_deps_day_dest 
                nr_arrs_day_dest nr_arrs_day_orig
                oc* cym* arcft*, r cluster(`name1') absorb(segment) ;
estimates store m0, title(Model 0);

qui areg `name' InterCPS empl_perc log_incpc log_pop
                late_arrival scheduled_buffer flight_in_day
                HHI inter_HHI
                log_LF
                nr_deps_hour_orig nr_deps_hour_dest nr_arrs_hour_dest nr_arrs_hour_orig
                HHI_dep_arpt HHI_arr_arpt nr_flt_arr_Origin_130_230 nr_flt_arr_Origin_230_330 nr_flt_dep_Dest_30_130 
                nr_flt_dep_Dest_130_230 nr_flt_arr_Origin_30_130 nr_flt_dep_Dest_230_330 nr_deps_day_orig nr_deps_day_dest 
                nr_arrs_day_dest nr_arrs_day_orig
                oc* cym* arcft*, r cluster(`name1') absorb(segment) ;
estimates store m1, title(Model 1);
display "`name', Model 1";
test InterCPS + inter_HHI = 0;
test InterCPS + 0.5 * inter_HHI = 0;
test InterCPS + 0.25 * inter_HHI = 0;

qui areg `name' InterCPS empl_perc log_incpc log_pop
                late_arrival scheduled_buffer flight_in_day
                HHI inter_HHI
                log_Fare log_LF
                nr_deps_hour_orig nr_deps_hour_dest nr_arrs_hour_dest nr_arrs_hour_orig
                HHI_dep_arpt HHI_arr_arpt nr_flt_arr_Origin_130_230 nr_flt_arr_Origin_230_330 nr_flt_dep_Dest_30_130 
                nr_flt_dep_Dest_130_230 nr_flt_arr_Origin_30_130 nr_flt_dep_Dest_230_330 nr_deps_day_orig nr_deps_day_dest 
                nr_arrs_day_dest nr_arrs_day_orig
                oc* cym* arcft*, r cluster(`name1') absorb(segment);
estimates store m2, title(Model 2);
display "`name', Model 2";
test InterCPS + inter_HHI = 0;
test InterCPS + 0.5 * inter_HHI = 0;
test InterCPS + 0.25 * inter_HHI = 0;

use `temp'w_instrum, clear;

qui ivreg `name' InterCPS (log_Fare log_LF = log_instrum2_lf log_instrum2_fare )
                empl_perc log_incpc log_pop
                late_arrival scheduled_buffer flight_in_day
                HHI inter_HHI
                nr_deps_hour_orig nr_deps_hour_dest nr_arrs_hour_dest nr_arrs_hour_orig
                HHI_dep_arpt HHI_arr_arpt nr_flt_arr_Origin_130_230 nr_flt_arr_Origin_230_330 nr_flt_dep_Dest_30_130 
                nr_flt_dep_Dest_130_230 nr_flt_arr_Origin_30_130 nr_flt_dep_Dest_230_330 nr_deps_day_orig nr_deps_day_dest 
                nr_arrs_day_dest nr_arrs_day_orig
                oc* cym* arcft*, r cluster(`name1');
estimates store m3, title(Model 3);
display "`name', Model 3";
test InterCPS + inter_HHI = 0;
test InterCPS + 0.5 * inter_HHI = 0;
test InterCPS + 0.25 * inter_HHI = 0;

**************************;

use `temp', clear;

qui areg `name' InterCPS empl_perc log_incpc log_pop
                late_arrival scheduled_buffer flight_in_day
                HHI inter_HHI
                log_LF
                nr_deps_hour_orig nr_deps_hour_dest nr_arrs_hour_dest nr_arrs_hour_orig
                HHI_dep_arpt HHI_arr_arpt nr_flt_arr_Origin_130_230 nr_flt_arr_Origin_230_330 nr_flt_dep_Dest_30_130 
                nr_flt_dep_Dest_130_230 nr_flt_arr_Origin_30_130 nr_flt_dep_Dest_230_330 nr_deps_day_orig nr_deps_day_dest 
                nr_arrs_day_dest nr_arrs_day_orig
                cym* arcft*, r cluster(`name1') absorb(segment);
estimates store m4, title(Model 4);
display "`name', Model 4";
test InterCPS + inter_HHI = 0;
test InterCPS + 0.5 * inter_HHI = 0;
test InterCPS + 0.25 * inter_HHI = 0;

qui areg `name' InterCPS empl_perc log_incpc log_pop
                late_arrival scheduled_buffer flight_in_day
                HHI inter_HHI
                log_LF  log_Fare
                nr_deps_hour_orig nr_deps_hour_dest nr_arrs_hour_dest nr_arrs_hour_orig
                HHI_dep_arpt HHI_arr_arpt nr_flt_arr_Origin_130_230 nr_flt_arr_Origin_230_330 nr_flt_dep_Dest_30_130 
                nr_flt_dep_Dest_130_230 nr_flt_arr_Origin_30_130 nr_flt_dep_Dest_230_330 nr_deps_day_orig nr_deps_day_dest 
                nr_arrs_day_dest nr_arrs_day_orig
                cym* arcft*, r cluster(`name1') absorb(segment);
estimates store m5, title(Model 5);
display "`name', Model 5";
test InterCPS + inter_HHI = 0;
test InterCPS + 0.5 * inter_HHI = 0;
test InterCPS + 0.25 * inter_HHI = 0;

use `temp'w_instrum, clear;

qui ivreg `name' InterCPS (log_Fare log_LF = log_instrum2_lf log_instrum2_fare )
                empl_perc log_incpc log_pop
                late_arrival scheduled_buffer flight_in_day
                HHI inter_HHI
                nr_deps_hour_orig nr_deps_hour_dest nr_arrs_hour_dest nr_arrs_hour_orig
                HHI_dep_arpt HHI_arr_arpt nr_flt_arr_Origin_130_230 nr_flt_arr_Origin_230_330 nr_flt_dep_Dest_30_130 
                nr_flt_dep_Dest_130_230 nr_flt_arr_Origin_30_130 nr_flt_dep_Dest_230_330 nr_deps_day_orig nr_deps_day_dest 
                nr_arrs_day_dest nr_arrs_day_orig
                cym* arcft*, r cluster(`name1');
estimates store m6, title(Model 6);
display "`name', Model 6";
test InterCPS + inter_HHI = 0;
test InterCPS + 0.5 * inter_HHI = 0;
test InterCPS + 0.25 * inter_HHI = 0;

**************************;

estout m0 m1 m2 m3 m4 m5 m6
        using "Reg910/`name'_`fe'_large100_fnl_`name1'_nrf.xls",
        replace cells(b(star fmt(%9.3f)) se(par(`"="("' `")""') fmt(%9.6f))) stats(N, fmt(%9.0g %9.3f %9.2f %9.2f) 
        labels(Observations R-squared AIC BIC)) legend collabels(none) varlabels(_cons Constant)
        keep (InterCPSadj log_Fare log_LF
                empl_perc log_incpc log_pop
                late_arrival scheduled_buffer flight_in_day
                HHI inter_HHI
                nr_deps_hour_orig nr_deps_hour_dest nr_arrs_hour_dest nr_arrs_hour_orig
                HHI_dep_arpt HHI_arr_arpt nr_flt_arr_Origin_130_230 nr_flt_arr_Origin_230_330 nr_flt_dep_Dest_30_130 
                nr_flt_dep_Dest_130_230 nr_flt_arr_Origin_30_130 nr_flt_dep_Dest_230_330 nr_deps_day_orig nr_deps_day_dest 
                nr_arrs_day_dest nr_arrs_day_orig )
        order (InterCPSadj HHI inter_HHI
               nr_deps_hour_orig nr_deps_hour_dest nr_arrs_hour_dest nr_arrs_hour_orig
               log_Fare
               log_LF
               scheduled_buffer late_arrival flight_in_day);

};
};

};
