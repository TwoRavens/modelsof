#delimit;
clear;
set memory 450m;

cd "C:\Documents and Settings\Krishna Patel\My Documents\thesis_topic occdist\native and immigrants\";

/*********2000*******/
use census00_5pc_2a_all.dta;
keep serial datanum pernum wkswork1; 
sort datanum serial pernum;
save census00_5pc_wks.dta, replace;
clear;
use census00_5pc_2b_all.dta;
keep serial datanum pernum incwage;
sort datanum serial pernum;
save census00_5pc_incwage.dta, replace;
clear;
use census00_5pc_uhrswork.dta;
sort datanum serial pernum;
merge datanum serial pernum using census00_5pc_wks.dta;
drop _merge;
sort datanum serial pernum;
merge datanum serial pernum using census00_5pc_incwage_all.dta;
drop _merge;
generate wage_hr= (incwage/ wkswork1)/ uhrswork;
drop wkswork1 incwage;
sort datanum serial pernum;
save census00_5pc_wghr.dta, replace;

clear;
use census00_5pc_all.dta;
drop  bpl1 bpld educ99 metaread statefip empstatd ;
sort datanum serial pernum;
merge datanum serial pernum using census00_5pc_wghr.dta ;
drop datanum serial pernum;
keep if _merge==3;
drop _merge;
save census00_5pc_wage_all.dta, replace;

clear;

/********1990*********/
#delimit;
use census90_5pc_2a_all.dta;
keep serial datanum pernum wkswork1; 
sort datanum serial pernum;
save census90_5pc_wks.dta, replace;
clear;
use census90_5pc_2b_all.dta;
keep serial datanum pernum incwage;
sort datanum serial pernum;
save census90_5pc_incwage.dta, replace;
clear;
use census90_5pc_uhrswork.dta;
sort datanum serial pernum;
merge datanum serial pernum using census90_5pc_wks.dta;
drop _merge;
sort datanum serial pernum;
merge datanum serial pernum using census90_5pc_incwage.dta;
drop _merge;
generate wage_hr= (incwage/ wkswork1)/ uhrswork;
drop wkswork1 incwage;
sort datanum serial pernum;
save census90_5pc_wghr.dta, replace;

clear;
use census90_5pc_all.dta;
drop  bpl1 bpld educ99 metaread  statefip empstatd ;
sort datanum serial pernum;
merge datanum serial pernum using census90_5pc_wghr.dta ;
drop datanum serial pernum;
keep if _merge==3;
drop _merge;
save census90_5pc_wage_all.dta, replace;


/*************1980************/
#delimit;
use census80_5pc_2a_all.dta;
keep serial datanum pernum wkswork1; 
sort datanum serial pernum;
save census80_5pc_wks.dta, replace;
clear;
use census80_5pc_2b_all.dta;
keep serial datanum pernum incwage;
sort datanum serial pernum;
save census80_5pc_incwage.dta, replace;
clear;
use census80_5pc_uhrswork.dta;
sort datanum serial pernum;
merge datanum serial pernum using census80_5pc_wks.dta;
drop _merge;
sort datanum serial pernum;
merge datanum serial pernum using census80_5pc_incwage.dta;
drop _merge;
generate wage_hr= (incwage/ wkswork1)/ uhrswork;
drop wkswork1 incwage;
sort datanum serial pernum;
save census80_5pc_wghr.dta, replace;

clear;
use census80_5pc_all.dta;
drop  bpl1 bpld educrec metaread  statefip empstatd ;
sort datanum serial pernum;
merge datanum serial pernum using census80_5pc_wghr.dta ;
drop datanum serial pernum;
keep if _merge==3;
drop _merge;
save census80_5pc_wage_all.dta, replace;



