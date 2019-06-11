/*
** last changes: August 2017  by: J. Spenkuch (j-spenkuch@kellogg.northwestern.edu)
*/
if c(os) == "Unix" {
	global PATH "/projects/p30061"
	global PATHdata "/projects/p30061/data"
	global PATHcode "/projects/p30061/code"
	global PATHlogs "/projects/p30061/logs"
	
	cd $PATH
}
else if c(os) == "Windows" {
	global PATH "R:/Dropbox/research/advertising_paper/analysis"
	global PATHdata "R:/Dropbox/research/advertising_paper/analysis/input"
	global PATHcode "R:/Dropbox/research/advertising_paper/analysis/code"
	global PATHlogs "R:/Dropbox/research/advertising_paper/analysis/output"
	
	cd $PATH
}
else {
    display "unable to recognize OS -> abort!"
    exit
}


include code/preamble.do

#delim;



/**********************************************************
***
***		Table 8
***
**********************************************************/;


global SAMPLE "r_registered==1 & r_matched_none==0 & r_MD_ptyd_base==0";
global VARs "r_*female r_*age r_*house_tenure r_vote r_dem r_rep r_other_none r_distance r_matched_street r_matched_zip r_matched_city ID YEAR";
global SampleVars "r_registered r_matched_none r_MD_ptyd_base";


log using $PATHlogs/log_table8.txt, replace;

putexcel set "$PATHlogs/RDresults", sheet("summ_stats") modify;

cd $PATHcode;


use $VARs $SampleVars if $SAMPLE using $PATHdata/voterpanel.dta;
drop $SampleVars;


*** summary stats;
sum r_female if r_Mfemale==0;
putexcel A1=("female") B1=(r(mean)) C1=(r(sd)),;
sum r_female if r_Mfemale==0 & abs(r_distance)<25000;
putexcel D1=(r(mean)) E1=(r(sd)),;
sum r_female if r_Mfemale==0 & abs(r_distance)<5000;
putexcel F1=(r(mean)) G1=(r(sd)),;

sum r_age if r_Mage==0;
putexcel A2=("age") B2=(r(mean)) C2=(r(sd)),;
sum r_age if r_Mage==0 & abs(r_distance)<25000;
putexcel D2=(r(mean)) E2=(r(sd)),;
sum r_age if r_Mage==0 & abs(r_distance)<5000;
putexcel F2=(r(mean)) G2=(r(sd)),;

sum r_house_tenure if r_Mhouse_tenure==0;
putexcel A3=("house_tenure") B3=(r(mean)) C3=(r(sd)),;
sum r_house_tenure if r_Mhouse_tenure==0 & abs(r_distance)<25000;
putexcel D3=(r(mean)) E3=(r(sd)),;
sum r_house_tenure if r_Mhouse_tenure==0 & abs(r_distance)<5000;
putexcel F3=(r(mean)) G3=(r(sd)),;

sum r_vote if YEAR==2008;
putexcel A4=("vote_2008") B4=(r(mean)) C4=(r(sd)),;
sum r_vote if YEAR==2008 & abs(r_distance)<25000;
putexcel D4=(r(mean)) E4=(r(sd)),;
sum r_vote if YEAR==2008 & abs(r_distance)<5000;
putexcel F4=(r(mean)) G4=(r(sd)),;

sum r_vote if YEAR==2012;
putexcel A5=("vote_2012") B5=(r(mean)) C5=(r(sd)),;
sum r_vote if YEAR==2012 & abs(r_distance)<25000;
putexcel D5=(r(mean)) E5=(r(sd)),;
sum r_vote if YEAR==2012 & abs(r_distance)<5000;
putexcel F5=(r(mean)) G5=(r(sd)),;

sum r_dem;
putexcel A6=("dem") B6=(r(mean)) C6=(r(sd)),;
sum r_dem if abs(r_distance)<25000;
putexcel D6=(r(mean)) E6=(r(sd)),;
sum r_dem if abs(r_distance)<5000;
putexcel F6=(r(mean)) G6=(r(sd)),;

sum r_rep;
putexcel A7=("rep") B7=(r(mean)) C7=(r(sd)),;
sum r_rep if abs(r_distance)<25000;
putexcel D7=(r(mean)) E7=(r(sd)),;
sum r_rep if abs(r_distance)<5000;
putexcel F7=(r(mean)) G7=(r(sd)),;

sum r_other_none;
putexcel A8=("other_none") B8=(r(mean)) C8=(r(sd)),;
sum r_other_none if abs(r_distance)<25000;
putexcel D8=(r(mean)) E8=(r(sd)),;
sum r_other_none if abs(r_distance)<5000;
putexcel F8=(r(mean)) G8=(r(sd)),;

sum r_distance;
putexcel A9=("distance") B9=(r(mean)) C9=(r(sd)),;
sum r_distance if abs(r_distance)<25000;
putexcel D9=(r(mean)) E9=(r(sd)),;
sum r_distance if abs(r_distance)<5000;
putexcel F9=(r(mean)) G9=(r(sd)),;

sum r_matched_street;
putexcel A10=("matched_street") B10=(r(mean)) C10=(r(sd)),;
sum r_matched_street if abs(r_distance)<25000;
putexcel D10=(r(mean)) E10=(r(sd)),;
sum r_matched_street if abs(r_distance)<5000;
putexcel F10=(r(mean)) G10=(r(sd)),;

sum r_matched_zip;
putexcel A11=("matched_zip") B11=(r(mean)) C11=(r(sd)),;
sum r_matched_zip if abs(r_distance)<25000;
putexcel D11=(r(mean)) E11=(r(sd)),;
sum r_matched_zip if abs(r_distance)<5000;
putexcel F11=(r(mean)) G11=(r(sd)),;

sum r_matched_city;
putexcel A12=("matched_city") B12=(r(mean)) C12=(r(sd)),;
sum r_matched_city if abs(r_distance)<25000;
putexcel D12=(r(mean)) E12=(r(sd)),;
sum r_matched_city if abs(r_distance)<5000;
putexcel F12=(r(mean)) G12=(r(sd)),;


distinct ID;
putexcel A13=("individuals") B13=(r(ndistinct)),;
distinct ID if abs(r_distance)<25000;
putexcel D13=(r(ndistinct)),;
distinct ID if abs(r_distance)<5000;
putexcel F13=(r(ndistinct)),;

count;
putexcel A14=("obs") B14=(r(N)),;
count if abs(r_distance)<25000;
putexcel D14=(r(N)),;
count if abs(r_distance)<5000;
putexcel F14=(r(N)),;


log close;

