#delimit;
clear;
set more off;
capture log close;
clear matrix;
set mem 500m;
capture program drop _all;
set scheme s2mono;
cd "C:\Users\sfreedm\Documents\My Dropbox\toy-replication-files\pgm";

*----------------------------------;
*Appendix Table 2: Description of Recalls to Publicly Traded Firms;
*----------------------------------;
use ../data/event-study-data, clear;
bysort group_id: keep if date==d(2jan2004);
keep if toy_producer==1;
gen marketcap = stock_price*shrout;
format recall_value %12.0g;
sort event_date;
outsheet ticker event_date recall_value lead magnets made_in_china articles_neg30toneg1 articles_0to30 marketcap top15 using ../output/appendix2.csv, comma replace;
***NOTE: News data used to create articles_neg30toneg1 and articles_0to30 were collected starting in 2005 and for firms in sales data. Therefore, for this table, 2004 recalls and the recall to Sony, which isn't in sales data, were filled in by hand from LexisNexis;

*----------------------------------;
/*	Run Event Study and calculate ARs and CARs for various windows
	Estimation Window Ends 10 days prior to Event Window
	Using 10 Days, because the longest event window will be 21 days, and we want a consistent Estimation Window
	for all results	*/ 
*----------------------------------;

use ../data/event-study-data, clear;
/*	Only keep events to toy producers	*/
keep if toy_producer==1;
drop group_id;
egen group_id=group(ticker event_date);
sort group_id;
by group_id: gen event_window_10_10=1 if dif>=-10 & dif<=10;
egen count_event_obs_10_10=count(event_window_10_10), by(group_id);
by group_id: gen estimation_window_10_10=1 if dif<-10 & dif>=-265;
egen count_est_obs_10_10=count(estimation_window_10_10), by(group_id);
replace event_window_10_10=0 if event_window_10_10==.;
replace estimation_window_10_10=0 if estimation_window_10_10==.;
count if count_event_obs_10_10 != 21;
count if count_est_obs_10_10 != 255;
gen day_0 = dif==0;
foreach x of numlist 1/10 {;
	gen day_neg`x' = dif==-`x';
	gen day_`x' = dif==`x';
};


gen AR = .;
gen se_AR = .;
foreach i of numlist 1/25 {;
	display `i';
	ta ticker event_date if group_id==`i';
	reg retrf mktrf smb hml day_* if group_id==`i' & (estimation_window==1 | event_window==1);
	assert e(N)==276;
	replace AR = _b[day_0] if group_id==`i' & dif==0;
	replace se_AR = _se[day_0] if group_id==`i' & dif==0;
	forvalues x=1/10{;
		replace AR = _b[day_neg`x'] if group_id==`i' & dif==-`x';
		replace se_AR = _se[day_neg`x'] if group_id==`i' & dif==-`x';
		replace AR = _b[day_`x'] if group_id==`i' & dif==`x';
		replace se_AR = _se[day_`x'] if group_id==`i' & dif==`x';
	};
};
keep if event_window==1;
assert AR !=.;
rename dif day;

/*-------------------------------------------------------------------*/
/*	Program To Aggregate AR's to CAR's	*/
program define CARs;
	gen var_AR = se_AR*se_AR;
	by group_id: gen CAR = sum(AR);
	gen var_CAR = var_AR*day_number;
	gen se_CAR = sqrt(var_CAR);
	sort day;	
	by day: gen total_N = _N;
	by day: gen year_0406 = year(event_date)<=2006;
	by day: gen year_2007 = year(event_date)==2007;
	by day: egen year0406_N = sum(year_0406);
	by day: egen year07_N = sum(year_2007);
	
	by day: egen avg_CAR_0406 = mean(CAR) if year_0406==1;
	by day: egen min_CAR_0406 = min(CAR) if year_0406==1;
	by day: egen max_CAR_0406 = max(CAR) if year_0406==1;
	by day: egen avg_AR_0406 = mean(AR) if year_0406==1;
	by day: egen min_AR_0406 = min(AR) if year_0406==1;
	by day: egen max_AR_0406 = max(AR) if year_0406==1;
	by day: egen sumofvariances_0406 = total(var_CAR) if year_0406==1;
	by day: gen var_CAR_0406 = sumofvariances_0406/(year0406_N*year0406_N) if year_0406==1;
	by day: gen se_CAR_0406 = sqrt(var_CAR_0406) if year_0406==1;
	by day: egen sumofvariances_0406_AR = total(var_AR) if year_0406==1;
	by day: gen var_AR_0406 = sumofvariances_0406_AR/(year0406_N*year0406_N) if year_0406==1;
	by day: gen se_AR_0406 = sqrt(var_AR_0406) if year_0406==1;
	by day: gen positive_0406 = CAR>0 if year_0406==1;
	by day: egen num_positive_0406 = sum(positive_0406) if year_0406==1;
	by day: gen sign_test_0406 = ((num_positive_0406/year0406_N)-.5)*(sqrt(year0406_N)/.5) if year_0406==1;
	
	by day: egen avg_CAR_2007 = mean(CAR) if year_2007==1;
	by day: egen min_CAR_2007 = min(CAR) if year_2007==1;
	by day: egen max_CAR_2007 = max(CAR) if year_2007==1;
	by day: egen avg_AR_2007 = mean(AR) if year_2007==1;
	by day: egen min_AR_2007 = min(AR) if year_2007==1;
	by day: egen max_AR_2007 = max(AR) if year_2007==1;
	by day: egen sumofvariances_2007 = total(var_CAR) if year_2007==1;
	by day: gen var_CAR_2007 = sumofvariances_2007/(year07_N*year07_N) if year_2007==1;
	by day: gen se_CAR_2007 = sqrt(var_CAR_2007) if year_2007==1;
	by day: egen sumofvariances_2007_AR = total(var_AR) if year_2007==1;
	by day: gen var_AR_2007 = sumofvariances_2007_AR/(year07_N*year07_N) if year_2007==1;
	by day: gen se_AR_2007 = sqrt(var_AR_2007) if year_2007==1;
	by day: gen positive_2007 = CAR>0 if year_2007==1;
	by day: egen num_positive_2007 = sum(positive_2007) if year_2007==1;
	by day: gen sign_test_2007 = ((num_positive_2007/year07_N)-.5)*(sqrt(year07_N)/.5) if year_2007==1;
end;
/*----------------------------------------------------------------------*/

/**************/
/*21 Day Window*/
/**************/
preserve;		
keep if day>=-20 & day <=20;
sort group_id day;
by group_id: gen day_number = _n; 
save ../data/event-study-result-data/21day, replace;
CARs;
collapse avg_AR_* min_AR_* max_AR_* se_AR_* avg_CAR_* min_CAR_* max_CAR_* se_CAR_* total_N year0406_N year07_N num_positive* sign_test*, by(day);
gen window = "21-Day";
save ../data/event-study-result-data/CAR-21day, replace;
restore;
/**************/
/*2 Day Window*/
/**************/
preserve;		
keep if day>=0 & day <=1; 
sort group_id day;
by group_id: gen day_number = _n;
CARs;
collapse avg_AR_* min_AR_* max_AR_* se_AR_* avg_CAR_* min_CAR_* max_CAR_* se_CAR_* total_N year0406_N year07_N num_positive* sign_test*, by(day);
gen window = "2-Day";
save ../data/event-study-result-data/CAR-2day, replace;
restore;
/**************/
/*3 Day Window*/
/**************/
preserve;
keep if day >=-1 & day <=1;
sort group_id day;
by group_id: gen day_number = _n;
CARs;
collapse avg_AR_* min_AR_* max_AR_* se_AR_* avg_CAR_* min_CAR_* max_CAR_* se_CAR_* total_N year0406_N year07_N num_positive* sign_test*, by(day);
gen window = "3-Day";
save ../data/event-study-result-data/CAR-3day, replace;
restore;


*----------------------------------;
*Appendix 3: FIGURES OF ARs OVER 21 DAY WINDOW FOR 2007 RECALLS;
*----------------------------------;
use ../data/event-study-result-data/CAR-21day, clear;
gen upper_AR_2007 =  avg_AR_2007+1.96* se_AR_2007;
gen lower_AR_2007 =  avg_AR_2007-1.96* se_AR_2007;
tw (connect lower_AR_2007 day, lpattern(dash) m(o) mc(black)) (connect avg_AR_2007 day, lpattern(solid) m(o) mc(black)) (connect upper_AR_2007 day, lpattern(dash) m(o) mc(black)), legend(off) xline(0) ytitle("Abnormal Return");
graph export ../output/appendix3.tif, as(tif) replace;

*----------------------------------;
*Appendix 4: TABLE OF CARs for 2004-2006 recalls and 2007 recalls for 2 and 3 day windows;
*----------------------------------;
use ../data/event-study-result-data/CAR-2day, clear;
append using ../data/event-study-result-data/CAR-3day;

bysort window: egen maxday = max(day);
keep if day == maxday;
keep window avg_CAR* se_CAR* *N num_positive*;
gen tstat_0406= avg_CAR_0406/se_CAR_0406;
gen pctneg_0406=(year0406_N-num_positive_0406)/year0406_N;
gen tstat_2007= avg_CAR_2007/se_CAR_2007;
gen pctneg_2007=(year07_N-num_positive_2007)/year07_N;
drop num_positive*;
rename year0406_N N_0406;
rename year07_N N_2007;
sort window;

reshape long avg_CAR se_CAR tstat N pctneg, i(window) j(sample) string;
sort sample window;
order sample window;
outsheet using ../output/appendix4.csv, comma replace;


*----------------------------------;
*Appendix 5: TABLE OF ARs and 11 Day CARs by event;
*----------------------------------;
use ../data/event-study-result-data/21day, clear;
keep ticker event_date AR se_AR day group_id;
gen var_AR = se_AR*se_AR;
sort day;	
keep if year(event_date)==2007;
sort group_id;
by group_id: egen CAR11 = total(AR) if day>=0 & day <=10;
by group_id: egen var_CAR11 = total(var_AR) if day>=0 & day <=10;
gen se_CAR11 = sqrt(var_CAR11);
sort day;
drop var_CAR* var_AR*;
keep if day >=-1 & day <=1;
sort group_id day;
foreach var of varlist CAR11 se_CAR11 {;
	by group_id: replace `var' = `var'[_n+1] if `var'==.;
};
gen days = "neg1" if day == -1;
replace days = "0" if day == 0;
replace days = "1" if day == 1;
drop day;
reshape wide AR se_AR, i(group_id) j(days) string;
rename AR0 AR0_p;
rename AR1 AR1_p;
rename ARneg1 ARneg1_p;
rename se_AR0 AR0_se;
rename se_AR1 AR1_se;
rename se_ARneg1 ARneg1_se;
rename CAR11 CAR11_p;
rename se_CAR11 CAR11_se;
reshape long ARneg1 AR0 AR1 CAR11, i(group_id) j(type) string;
order group_id ticker event_date type ARneg1 AR0 AR1 CAR11;
sort event_date ticker type;
outsheet using ../output/appendix5.csv, comma replace;


