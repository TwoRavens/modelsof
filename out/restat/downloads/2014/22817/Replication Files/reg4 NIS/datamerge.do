#delimit ;
clear ;
set memory 300m ;

cd "C:\Documents and Settings\Krishna Patel\My Documents\thesis_topic occdist\reg4 NIS" ;

use nis_data.dta, clear;

generate occ1990=b78oc90;
generate year=b78year;
generate state=b78state;

sort ciscobinsmo occ1990 state year;

merge  ciscobinsmo occ1990 state year using census_5pc_occstate.dta; 
drop if _merge==2;
drop _merge;
drop occ1990 year state;
save data_nis_census, replace;


