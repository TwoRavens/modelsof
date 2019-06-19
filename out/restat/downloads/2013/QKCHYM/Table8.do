#delimit ;
clear all;
set mem 600m;
set more off;
* Replace with your local working directory name;
local dir "C:\Users\hchor\Documents\Projects\InstEd\wvsmerge\Replication";
cd "`dir'";

use crosscountrymerge_RESTAT_replication.dta, clear;
local ofile Table8.out;
local logfile Table8.log;

cap erase `ofile';
cap erase `logfile';
cap log close;

local defoptions "bdec(3,3) coefastr se 3aster bracket nocons addstat("No. of countries", e(N))";

log using `logfile', replace;

	local s tyr15;
	
	display "*(i) Baseline";
	reg diff_`s'_0075 `s'_1975 democ_1975, robust;
	outreg `s'_1975 democ_1975 using `ofile', replace `defoptions' ctitle(i);
	
	display "*(ii) Add larable_pop1564_1975";
	reg diff_`s'_0075 `s'_1975 democ_1975 larable_pop1564_1975, robust;
	outreg `s'_1975 democ_1975 larable_pop1564_1975 using `ofile', append `defoptions' ctitle(ii);

	display "*(iii) Add democ X larable_pop1564_1975";
	reg diff_`s'_0075 `s'_1975 democ_1975 larable_pop1564_1975 interT_1975, robust;
	outreg `s'_1975 democ_1975 larable_pop1564_1975 interT_1975 using `ofile', append `defoptions' ctitle(iii);
	
	display "*(iv) Add lK62s_pop1564_1975";
	reg diff_`s'_0075 `s'_1975 democ_1975 larable_pop1564_1975 lK62s_pop1564_1975, robust;
	outreg `s'_1975 democ_1975 larable_pop1564_1975 lK62s_pop1564_1975 using `ofile', append `defoptions' ctitle(iv);
	
	display "*(v) Add democ X lK62s_pop1564_1975";
	reg diff_`s'_0075 `s'_1975 democ_1975 larable_pop1564_1975 interT_1975 lK62s_pop1564_1975 interK_1975, robust;
	outreg `s'_1975 democ_1975 larable_pop1564_1975 interT_1975 lK62s_pop1564_1975 interK_1975 using `ofile', append `defoptions' ctitle(v);
	
	/* Outlier tests */
	quietly reg diff_`s'_0075 `s'_1975 democ_1975 larable_pop1564_1975, robust;
	cap drop insample;
	gen insample = 1 if e(sample);
	replace insample = 2 if insample==.;

	cap drop outlier;
	gen outlier = 0;
	summ larable_pop1564_1975 if insample==1, det;
	tab isocode if insample==1 & abs((larable_pop1564_1975 - r(mean))/r(sd))>3 & abs((larable_pop1564_1975 - r(mean))/r(sd))~=.;
	quietly summ larable_pop1564_1975 if insample==1, det;
	replace outlier = 1 if abs((larable_pop1564_1975 - r(mean))/r(sd))>3 & abs((larable_pop1564_1975 - r(mean))/r(sd))~=.;
	summ lK62s_pop1564_1975 if insample==1, det;
	tab isocode if insample==1 & abs((lK62s_pop1564_1975 - r(mean))/r(sd))>3 & abs((lK62s_pop1564_1975 - r(mean))/r(sd))~=.;
	quietly summ lK62s_pop1564_1975 if insample==1, det;
	replace outlier = 1 if abs((lK62s_pop1564_1975 - r(mean))/r(sd))>3 & abs((lK62s_pop1564_1975 - r(mean))/r(sd))~=.;

	display "*(vi) Drop outliers";
	reg diff_`s'_0075 `s'_1975 democ_1975 larable_pop1564_1975 interT_1975 lK62s_pop1564_1975 interK_1975 if outlier==0, robust;
	outreg `s'_1975 democ_1975 larable_pop1564_1975 interT_1975 lK62s_pop1564_1975 interK_1975 using `ofile', append `defoptions' ctitle(vi);
	
	display "*(vii) Primary schooling";
	local s pyr15;
	reg diff_`s'_0075 `s'_1975 democ_1975 larable_pop1564_1975 interT_1975 lK62s_pop1564_1975 interK_1975 if outlier==0, robust;
	outreg `s'_1975 democ_1975 larable_pop1564_1975 interT_1975 lK62s_pop1564_1975 interK_1975 using `ofile', append `defoptions' ctitle(vii);
	
	display "*(viii) Secondary schooling";
	local s syr15;
	reg diff_`s'_0075 `s'_1975 democ_1975 larable_pop1564_1975 interT_1975 lK62s_pop1564_1975 interK_1975 if outlier==0, robust;
	outreg `s'_1975 democ_1975 larable_pop1564_1975 interT_1975 lK62s_pop1564_1975 interK_1975 using `ofile', append `defoptions' ctitle(viii);
	
	display "*(ix) Tertiary schooling";
	local s hyr15;
	reg diff_`s'_0075 `s'_1975 democ_1975 larable_pop1564_1975 interT_1975 lK62s_pop1564_1975 interK_1975 if outlier==0, robust;
	outreg `s'_1975 democ_1975 larable_pop1564_1975 interT_1975 lK62s_pop1564_1975 interK_1975 using `ofile', append `defoptions' ctitle(ix);
	
log close;
