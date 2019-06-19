clear 
set more off
set mem 150m

*version 9.1
#delimit;
adopath + C:\ado\egenodd;


*cd "`basepath'stata";
local basepath "C:\Jirka\Research\g7expectations\g7expectations\";

cd "`basepath'stata/dataManagement";

* compiles aggregate measures of disagreement for the updated data and the euro area and merges into a single data set;

do doAllDataManagement_post2004;
do doAllDataManagement_ea;

/*
* Non-stacked data set;
use "`basepath'Data/dataUpdate_april15/disagreementAggr_ea.dta";
sort year month;
save "`basepath'Data/dataUpdate_april15/disagreementAggr_ea.dta", replace;

* Add euro area;
merge year month using "`basepath'Data/dataUpdate_april15/disagreementAggr.dta", _merge(_merge);
drop _merge;
sort year month;
save "`basepath'Data/dataUpdate_april15/disagreementAggr_all.dta", replace;

* Stacked data set;
use "`basepath'Data/dataUpdate_april15/disagreementAggrStacked_ea.dta";
sort country year month;
save "`basepath'Data/dataUpdate_april15/disagreementAggrStacked_ea.dta", replace;

* Add euro area;
merge country year month using "`basepath'Data/dataUpdate_april15/disagreementAggrStacked.dta", _merge(_merge);
drop _merge;
sort country year month;
save "`basepath'Data/dataUpdate_april15/disagreementAggrStacked_all.dta", replace;
*/;


set more on;
