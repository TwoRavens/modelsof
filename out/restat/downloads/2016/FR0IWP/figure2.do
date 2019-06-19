#delimit ;
set more off;

/*NOTE: For a Mac, file path names use a forward slash (/) but for 
PC's they require a backward slash (\). Make these changes below 
if necessary depending on your computer type. 
*/

*Dropbox paths by user;
if c(username)=="shayaksarkar" {;
	local path "/Users/shayaksarkar/Desktop/ReStat_Data_Publication";
};


/*FIGURE 2*/;

cd `path';

use "`path'/dta/final_disclosure.dta", clear;

* MAKE A PLOT, BY WEEKS OF THE FRACTION OF AUDITS WITH A ULIP RECOMMENDATION;

tostring monthofaudit dayofaudit yearofaudit, gen(monthstr daystr yearstr);
gen datestr2 = monthstr + "/" + daystr + "/" + yearstr;
gen date2 = date(datestr2, "MDY");
gen week2 = wofd(date2);
 
collapse anyulip post (count) yearofaudit (semean) anyulipse=anyulip, by(week2);

gen week_raw = week2;
format week2 %tw;

gen anyulip_upper_ci = anyulip + 1.96*anyulipse;
gen anyulip_lower_ci = anyulip - 1.96*anyulipse;

export excel using "`path'/out/figure2.xls", replace;

