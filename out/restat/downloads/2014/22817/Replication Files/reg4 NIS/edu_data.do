#delimit;
clear;
set memory 500m;

cd "C:\Documents and Settings\Krishna Patel\My Documents\thesis_topic occdist\";

/*****2000****/
#delimit;
use "native and immigrants\census00_5pc_all.dta", clear;

drop empstatd;


/** create state variables **/

generate 	state 	 = 	1	 if 	statefip	 == 	4	;
replace 	state 	 = 	2	 if 	statefip	 == 	9	;
replace 	state 	 = 	3	 if 	statefip	 == 	13	;
replace 	state 	 = 	4	 if 	statefip	 == 	30	;
replace 	state 	 = 	5	 if 	statefip	 == 	32	;
replace 	state 	 = 	6	 if 	statefip	 == 	42	;
replace 	state 	 = 	7	 if 	statefip	 == 	6 | statefip==19 | statefip==21 | statefip==29	;
replace 	state 	 = 	8	 if 	statefip	 == 	38 |statefip==44|statefip==46	;
replace 	state 	 = 	9	 if 	statefip	 == 	7|statefip==8|statefip==10|statefip==20|statefip==33|statefip==39	;
replace 	state 	 = 	10	 if 	statefip	 == 	1|statefip==17|statefip==24|statefip==41	;
replace 	state 	 = 	11	 if 	statefip	 == 	14|statefip==22|statefip==35|statefip==47	;
replace 	state 	 = 	12	 if 	statefip	 == 	15|statefip==16|statefip==23|statefip==25|statefip==27|statefip==34|statefip==40	;
replace 	state 	 = 	13	 if 	statefip	 == 	3|statefip==18|statefip==36	;
replace 	state 	 = 	14	 if 	statefip	 == 	2|statefip==5|statefip==12|statefip==26|statefip==28|statefip==31|statefip==43|statefip==48	;
replace 	state 	 = 	15	 if 	statefip	 == 	11|statefip==37|statefip==45	;


label define state 
1	"California"
2	"Florida"
3	"Illinois"
4	"New Jersey"
5	"New York"
6	"Texas"
7	"New England"
8	"Middle Atlantic"
9	"South Atlantic"
10	"East South Central"
11	"East North Central"
12	"West North Central"
13	"West South Central"
14	"Mountain"
15	"Pacific" ;

label values state state;
drop if state >20;

generate edu=1 if educ99>=0 & educ99<=9;
replace edu=2 if educ99==10;
replace edu=3 if educ99==11;
replace edu=4 if educ99==12| educ99==13;
replace edu=5 if educ99==14;
replace edu=6 if educ99==15| educ99==16| educ99==17;

generate wt_sum=edu*perwt;
generate pop=1;
collapse (sum) perwt pop wt_sum (mean) edu, by (state occ1990);

rename edu mean_occ_edu;
rename wt_sum sum_statocc1_wt ;
rename perwt sum_statocc2_wt;
by state occ1990, sort:  egen occ_edu_count=sum(pop);
generate mean_occ_edu_wt=sum_statocc1_wt/sum_statocc2_wt;
keep  occ1990 state mean_occ_edu mean_occ_edu_wt occ_edu_count;
sort occ1990 state;
generate year=2000;
save "reg4 NIS\census00_edu", replace;


/*****1990****/
#delimit;
use "native and immigrants\census90_5pc_all.dta", clear;


drop empstatd;

/** create state variables **/

generate 	state 	 = 	1	 if 	statefip	 == 	4	;
replace 	state 	 = 	2	 if 	statefip	 == 	9	;
replace 	state 	 = 	3	 if 	statefip	 == 	13	;
replace 	state 	 = 	4	 if 	statefip	 == 	30	;
replace 	state 	 = 	5	 if 	statefip	 == 	32	;
replace 	state 	 = 	6	 if 	statefip	 == 	42	;
replace 	state 	 = 	7	 if 	statefip	 == 	6 | statefip==19 | statefip==21 | statefip==29	;
replace 	state 	 = 	8	 if 	statefip	 == 	38 |statefip==44|statefip==46	;
replace 	state 	 = 	9	 if 	statefip	 == 	7|statefip==8|statefip==10|statefip==20|statefip==33|statefip==39	;
replace 	state 	 = 	10	 if 	statefip	 == 	1|statefip==17|statefip==24|statefip==41	;
replace 	state 	 = 	11	 if 	statefip	 == 	14|statefip==22|statefip==35|statefip==47	;
replace 	state 	 = 	12	 if 	statefip	 == 	15|statefip==16|statefip==23|statefip==25|statefip==27|statefip==34|statefip==40	;
replace 	state 	 = 	13	 if 	statefip	 == 	3|statefip==18|statefip==36	;
replace 	state 	 = 	14	 if 	statefip	 == 	2|statefip==5|statefip==12|statefip==26|statefip==28|statefip==31|statefip==43|statefip==48	;
replace 	state 	 = 	15	 if 	statefip	 == 	11|statefip==37|statefip==45	;


label define state 
1	"California"
2	"Florida"
3	"Illinois"
4	"New Jersey"
5	"New York"
6	"Texas"
7	"New England"
8	"Middle Atlantic"
9	"South Atlantic"
10	"East South Central"
11	"East North Central"
12	"West North Central"
13	"West South Central"
14	"Mountain"
15	"Pacific" ;

label values state state;
drop if state >20;


generate edu=1 if educ99>=0 & educ99<=9;
replace edu=2 if educ99==10;
replace edu=3 if educ99==11;
replace edu=4 if educ99==12| educ99==13;
replace edu=5 if educ99==14;
replace edu=6 if educ99==15| educ99==16| educ99==17;

generate wt_sum=edu*perwt;
generate pop=1;
collapse (sum) perwt pop wt_sum (mean) edu, by (state occ1990);

rename edu mean_occ_edu;
rename wt_sum sum_statocc1_wt ;
rename perwt sum_statocc2_wt;
by state occ1990, sort:  egen occ_edu_count=sum(pop);
generate mean_occ_edu_wt=sum_statocc1_wt/sum_statocc2_wt;
keep  occ1990 state mean_occ_edu mean_occ_edu_wt occ_edu_count;
sort occ1990 state;
generate year=1990;
save "reg4 NIS\census90_edu", replace;

/*****1980****/
#delimit;
clear;
use "native and immigrants\census80_5pc_all.dta", clear;


drop empstatd;

/** create state variables **/

generate 	state 	 = 	1	 if 	statefip	 == 	4	;
replace 	state 	 = 	2	 if 	statefip	 == 	9	;
replace 	state 	 = 	3	 if 	statefip	 == 	13	;
replace 	state 	 = 	4	 if 	statefip	 == 	30	;
replace 	state 	 = 	5	 if 	statefip	 == 	32	;
replace 	state 	 = 	6	 if 	statefip	 == 	42	;
replace 	state 	 = 	7	 if 	statefip	 == 	6 | statefip==19 | statefip==21 | statefip==29	;
replace 	state 	 = 	8	 if 	statefip	 == 	38 |statefip==44|statefip==46	;
replace 	state 	 = 	9	 if 	statefip	 == 	7|statefip==8|statefip==10|statefip==20|statefip==33|statefip==39	;
replace 	state 	 = 	10	 if 	statefip	 == 	1|statefip==17|statefip==24|statefip==41	;
replace 	state 	 = 	11	 if 	statefip	 == 	14|statefip==22|statefip==35|statefip==47	;
replace 	state 	 = 	12	 if 	statefip	 == 	15|statefip==16|statefip==23|statefip==25|statefip==27|statefip==34|statefip==40	;
replace 	state 	 = 	13	 if 	statefip	 == 	3|statefip==18|statefip==36	;
replace 	state 	 = 	14	 if 	statefip	 == 	2|statefip==5|statefip==12|statefip==26|statefip==28|statefip==31|statefip==43|statefip==48	;
replace 	state 	 = 	15	 if 	statefip	 == 	11|statefip==37|statefip==45	;


label define state 
1	"California"
2	"Florida"
3	"Illinois"
4	"New Jersey"
5	"New York"
6	"Texas"
7	"New England"
8	"Middle Atlantic"
9	"South Atlantic"
10	"East South Central"
11	"East North Central"
12	"West North Central"
13	"West South Central"
14	"Mountain"
15	"Pacific" ;

label values state state;
drop if state >20;

generate edu=1 if educrec>=0 & educrec<=6;
replace edu=2 if educrec==7;
replace edu=3 if educrec==8;
replace edu=5 if educrec==9;

generate wt_sum=edu*perwt;
generate pop=1;
collapse (sum) perwt pop wt_sum (mean) edu, by (state occ1990);

rename edu mean_occ_edu;
rename wt_sum sum_statocc1_wt ;
rename perwt sum_statocc2_wt;
by state occ1990, sort:  egen occ_edu_count=sum(pop);
generate mean_occ_edu_wt=sum_statocc1_wt/sum_statocc2_wt;
keep  occ1990 state mean_occ_edu mean_occ_edu_wt occ_edu_count;
sort occ1990 state;
generate year=1980;
save "reg4 NIS\census80_edu", replace;

append using "reg4 NIS\census90_edu";
append using "reg4 NIS\census00_edu";
sort occ1990 state year;
save "reg4 NIS\census_edu", replace;

collapse (mean)  mean_occ_edu mean_occ_edu_wt, by(year occ1990);
sort occ1990 year;
save "reg4 NIS\census_edu_national.dta", replace;
