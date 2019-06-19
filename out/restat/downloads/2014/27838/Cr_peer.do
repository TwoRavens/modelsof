*Creates peer variables;

#delimit;

clear;
pause on;
set more off;
set mem 1200m;
capture log close;

************************;
* First we open the cleaned data;

use Cr_eog.dta, clear;

drop nclb-nclb_rach3 sa_mach1-sa_rach3 mach1_1-mach3_1;

local myvars "w n black hisp male pared2 pared3 lunch rach1_1 rach2_1 rach3_1";
foreach var of local myvars{;
    egen tot=count(`var'), by(school grade year);
    egen totv=sum(`var'), by(school grade year);
    gen g`var'=(totv-`var')/(tot-1);
    drop tot totv;
};


**Create classroom level peer variable for achievement scores;
local myvars3 "read read_1 read_2 ";

foreach var of local myvars3{;
    egen tot=count(`var'), by(school grade year);
    egen totv=sum(`var'), by(school grade year);
    gen g`var'=(totv-`var')/(tot-1);
    drop tot totv;
    
 };

   

drop if teachid==.;

egen csize=count(mastid), by(peergroup);
sum csize, det;

*Drops bottom and top 1pctle;
*egen smallclass=pctile(csize), p(1);
*egen largeclass=pctile(csize), p(99);
*pause;
*drop if csize<smallclass| csize>largeclass;

* Teachid's less than 6 digits indicate teachid;
* is not consistent across years;
gen bad_teachid = teachid<100000;
drop if bad_teachid==1;

drop if read_1==.;
drop if pared==.;

gen grade5 = grade==5;
label value grade5 dum;

* Labels
    label variable read "Reading score (stadardized)";
    label variable gread "Avg. peer reading score";
    label variable gread_1 "Avg. 1-lag peer reading score";    
    label variable gread_2 "Avg. 2-lag peer reading score";
    


label variable csize "Class size";
label variable male "Male";
label variable black "Black";
label variable hisp "Hispanic";
label variable amind "American Indian";
label variable pared2 "Parent HS/some post-sec.";
label variable pared3 "Parent 4-year degree+";
label variable lunch "Free/reduced price lunch";
label variable freadhr "Free reading hours per week";
label variable tvhr "TV hours per week";
label variable gn "% nonwhite";
label variable gpared2 "% Parents HS Degree";
label variable gpared3 "% parents 4-year degree";
label variable glunch "% FRP lunch";
label variable n "Nonwhite";
label variable gmale "% male";
label variable grade5 "5th Grade";


compress;
aorder;
order mastid year grade school teachid;
sort school year grade teachid mastid;
save Cr_peer.dta, replace;
log close;

