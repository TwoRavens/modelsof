* this program generates the results from Table 6 of;
* Evans and Moore, Liquidity, Economic Activity, Mortality:
* RESTAT.  The data is from the 1996-2004 CEX;
* there are three data sets necessary.  The CEX data, a monthly;
* CPI and the data set that identifies special days like;
* Christmas, New Years, etc.;

* this line defines the semicolon as the line delimiter;
# delimit ;

set more off;

* set memork for 920 meg;
set memory 920m;

log using table_6_results_cex_data_evans_moore.log,replace;

* read in the federal holidays data;
* sort by year month day, then save, replace, clear;
insheet using federal_holidays.csv, comma;
label var month "month of year, 1-12";
label var day "day of the month, 1-31";
label var year "year, 1973-2006";
label var memorial_0 "=1 if Memorial day, 0 otherwise";
label var memorial_1 "=1 if Sunday before Memorial day, 0 otherwise";
label var memorial_2 "=1 if Saturday before Memorial day, 0 otherwise";
label var memorial_3 "=1 if Friday before Memorial day, 0 otherwise";
label var labor_0 "=1 if Labor day, 0 otherwise";
label var labor_1 "=1 if Sunday before Labor day, 0 otherwise";
label var labor_2 "=1 if Saturday before Labor day, 0 otherwise";
label var labor_3 "=1 if Friday before Labor day, 0 otherwise";
label var columbus_0 "=1 if Columbus day, 0 otherwise";
label var columbus_1 "=1 if Sunday before Columbus day, 0 otherwise";
label var columbus_2 "=1 if Saturday before Columbus day, 0 otherwise";
label var columbus_3 "=1 if Friday before Columbus day, 0 otherwise";
label var mlking_0 "=1 if mlking day, 0 otherwise";
label var mlking_1 "=1 if Sunday before mlking day, 0 otherwise";
label var mlking_2 "=1 if Saturday before mlking day, 0 otherwise";
label var mlking_3 "=1 if Friday before mlking day, 0 otherwise";
label var easter_0 "=1 if Easter sunday, =0 otherwise";
label var easter_1 "=1 if Easter vigil, =0 otherwise";
label var easter_2 "=1 if Good Friday, =0 otherwise";
label var easter_3 "=1 if Holy Thursday, =0 otherwise"; 
label var xmas_season "=1 from Thanksgiving to New Years, =0 otherwise";
label var veterans_0 "=1 if veterans day, =0 otherwise";
label var presidents_0 "=1 if presidents day, 0 otherwise";
label var presidents_1 "=1 if Sunday before presidents day, 0 otherwise";
label var presidents_2 "=1 if Saturday before presidents day, 0 otherwise";
label var presidents_3 "=1 if Friday before presidents day, 0 otherwise";
label var july4 "=1 if 4th of July, =0 otherwise";
label var xmas_0 "=1 if Christmas, =0 otherwise";
label var xmas_1 "=1 if day before Christmas, =0 otherwise";
label var xmas_2 "=1 if 2 days before Christmas, =0 otherwise";
label var xmas_3 "=1 if 3 days before Christmas, =0 otherwise";
label var superbowl_0 "=1 if superbowl sunday, =0 otherwise";
label var superbowl_1 "=1 if day after superbowl, =0 otherwise";
label var newyear_0 "=1 if new years day, =0 otherwise";
label var newyear_1 "=1 if new years eve, =0 otherwise";
label var jan2 "=1 if january 2nd, =0 otherwise";
label var tgiving_0 "=1 if Thanksgiving Day, =0 otherwise";
label var tgiving_1 "=1 if Friday after Thanksgiving Day, =0 otherwise";  
label var tgiving_2 "=1 if Saturday after Thanksgiving Day, =0 otherwise";  
label var tgiving_3 "=1 if Sunday after Thanksgiving Day, =0 otherwise";  
label var tgiving_4 "=1 if Wednesday before Thanksgiving Day, =0 otherwise";  
label var tgiving_5 "=1 if Tuesday before Thanksgiving Day, =0 otherwise";  
label var tgiving_6 "=1 if Monday before Thanksgiving Day, =0 otherwise";  
sort year month day;
save federal_holidays, replace;
clear;

* read in cpi data, sort by yyear mmonth;
* the save, replace, clear;
insheet using cpi_data.csv, comma;
* becase we will be merging this bvased on synthetic months;
* and years, define these as yyear and mmonths;
sort yyear mmonth;
label var cpi "cpi level";
save cpi, replace;
clear;

*read in raw data from the cex;
insheet using cex_data.csv, comma;
label var id1 "id for household, #1";                   
label var id2 "id for household, #2";                   
label var weeki "week of the diary";
label var state  "state identifier";
label var smsastat "does cu reside inside a msa?";
label var region    "region";
label var educ_ref  "education of reference person";
label var marital1  "marital status of reference person";
label var strtyear "diary start date - year";
label var strtmnth "diary start date - month";
label var strtday  "diary start date - date";
label var cutenure "housing tenure";
label var welfrx "ttl inc by all from:publc assist/welfare";
label var bls_urbn "urban/rural";
label var popsize  "population size of the psu";
label var fam_size "number of members in cu";
label var inclass  "income class of cu before taxes";
label var povlev "poverty level threshold for this cu";
label var age_ref "age of reference person";
label var ref_race "race of reference person";
label var sex_ref  "sex of reference person";
label var origin1  "origin or ancestry of reference person";
label var finlwt21  "cu replicate weight # 45 (ttl sample wt)";
label var foodtot "food, total";
label var foodhome  "food at home, total";
label var purchasedate "puschase date in stata date form";                
label var journalday   "journal date in stata date form";                  
label var weekday "day of the week, 0=sunday, 6=saturday";    
label var food1 "daily spending food at home";
label var food2 "daily spending food away from home";          
label var alc "daily spending on alcohol";   
label var utils "daily spending on utilities";                 
label var apparel "daily spending on apparel";            
label var gas "daily spending on gasonline";          
label var cig "daily spending on cigarettes";            
label var home "daily spending on home (rent+mortgage)";              
label var rent "daily spending on rent";
label var mortgage "daily spending on mortgages";
label var gifts "daily spending on gifts";
label var paychildcare "daily spending on childcare";              
label var otcdrugs "daily spending on otc drugs";   
label var carlease "daily spending on automobile lease";
label var entertain "daily spending on entertainment";        
label var healthins "daily spending on health insurance";   
label var personalserv "daily spending on personal services (e.g.,haircuts)";
label var personalprod "daily spending on personal products";                 
label var grospayx "gross amount of member's last pay?";
label var gros_ayx "grospayx flag";
label var payperd "time period covered for last pay";
label var payperd_ "payperd flag";
label var socrrx "annual amt of soc sec & rr ret income";
label var ss_rrx "amt of last ss or rr payment recd";
label var suppx "ttl supplemntl sec inc:us/state/locl gov";


* this next set of variables generates the 14 days before and after the 1st of the month;
gen leap=((year==1976)|(year==1980)|(year==1984)|(year==1988)|(year==1992)|(year==1996)|(year==2000)|(year==2004));
gen day30=((month==9)|(month==4)|(month==6)|(month==11));
gen day28=((leap==0)&(month==2));
gen day29=((leap==1)&(month==2));
gen day31=1-day30-day29-day28;
gen mday=28*day28+29*day29+30*day30+31*day31;

gen counter=.;
replace counter =(day-29) if (mday==28&day>=15);
replace counter =(day-30) if (mday==29&day>=16);
replace counter =(day-31) if (mday==30&day>=17);
replace counter =(day-32) if (mday==31&day>=18);
replace counter=day if day<=14;
drop if counter==.;

* mmonth is a synthetic month, yyear is a synthetic year;
* see the text for their definition;
* counter equals -1 for the day before the 1st, 1 for the 1st, etc;

gen mmonth=1;
replace mmonth=2 if (counter<0&month==1)|(counter>0&month==2);
replace mmonth=3 if (counter<0&month==2)|(counter>0&month==3);
replace mmonth=4 if (counter<0&month==3)|(counter>0&month==4);
replace mmonth=5 if (counter<0&month==4)|(counter>0&month==5);
replace mmonth=6 if (counter<0&month==5)|(counter>0&month==6);
replace mmonth=7 if (counter<0&month==6)|(counter>0&month==7);
replace mmonth=8 if (counter<0&month==7)|(counter>0&month==8);
replace mmonth=9 if (counter<0&month==8)|(counter>0&month==9);
replace mmonth=10 if (counter<0&month==9)|(counter>0&month==10);
replace mmonth=11 if (counter<0&month==10)|(counter>0&month==11);
replace mmonth=12 if (counter<0&month==11)|(counter>0&month==12);

gen yyear=year;
replace yyear=year+1 if (mmonth==1&month==12);



sort yyear mmonth;
merge yyear mmonth using cpi.dta;
drop day30 day28 day29 day31 leap mday;
if day==. then delete;

drop _merge;

sort year month day;
merge year month day using federal_holidays;
* this just cleans out missing data;
drop if rent==.;

* turn cpi into real values for teh end of 2006;
gen cpir=cpi/210.228;

* turn the spending categories into real values;
gen food1r=food1/(cpir);
gen food2r=food2/(cpir);
gen foodtotr=food1r+food2r;
gen alcr=alc/(cpir);
gen cigr=cig/(cpir);
gen apparelr=apparel/(cpir);
gen gasr=gas/(cpir);
gen entertainr=entertain/(cpir);
gen personalprodr=personalprod/(cpir);
gen personalservr=personalserv/(cpir);
gen otcdrugsr=otcdrugs/(cpir);
gen giftsr=gifts/(cpir);
gen nonfoodr=alcr+cigr+apparelr+gasr+entertainr+personalprodr+personalservr;


sum foodtotr if foodtotr>0, detail;
sum nonfoodr if nonfoodr>0, detail;


* delete 2 times the 99th percentile of positive values;
replace foodtotr=. if foodtotr>2*210.63;
replace nonfoodr=. if nonfoodr>2*341.38;

gen totalr=nonfoodr+foodtotr;

* generate dummy variables for two weeks before the 1st;
* the 1st week, and the 2nd week of the month;
* the reference week is the week before the 1st;
gen week1=counter<-7;
gen week3=(counter>0&counter<8);
gen week4=(counter>7);
label var week1 "two weeks before 1st of month";
label var week3 "1st week of month";
label var week4 "2nd week of month";


*destring payperd, replace;
gen monthly=(payperd<=7&payperd>2);
*put in a dummy for christmas week;
gen xmasweek=(month==12)&((day>26)&(day<31));

gen famsize=fam_size;
* cap family size at 6;
replace famsize=6 if famsize>6;


* generate dummies for the categorical variables;
xi i.weekday i.mmonth i.yyear i.bls_urbn I.famsize i.educ_ref i.marital1
i.region i.inclass i.age_ref i.ref_race i.sex_ref;


* there are three income groups, < $25K, < $25K and missing;
gen income_group=1;
replace income_group=2 if (inclass>7)&(inclass<10);
replace income_group=3 if (inclass==10);
label var income_group "=1 if no income/not reported, =2 if ";

* there are three income groups, < hs, hs and some college;
* plus college;
gen educ_group=1;
replace educ_group=2 if (educ_ref>11&educ_ref<14);
replace educ_group=3 if educ_ref>13;
label var educ_group "=1 if educ of ref person <hs, =2 if HS, =3 if > hs";

replace suppx=0 if suppx==.;
replace welfrx=0 if welfrx==.;
replace ss_rrx=0 if ss_rrx==.;

gen any_ss=ss_rrx>0;
gen any_other=((welfrx>0)|(suppx>0));
label var any_ss "=1 if household has SS income";
label var any_other "=1 if household has no SS but other welfare";

gen public_grp=3;
replace public_grp=1 if any_ss==1;
replace public_grp=2 if any_other==1;


local holidays mlking_0-mlking_3 presidents_0-presidents_3 
easter_0-easter_3 memorial_0-memorial_3 
july4 labor_0-labor_3 veterans_0 columbus_0-columbus_3 tgiving_0-tgiving_6
xmas_0-xmas_3 xmas_ny xmas_season newyear_1 jan2 superbowl_0 superbowl_1;


* full sample models -- row 1 column 1 in Table 6;
reg foodtotr `holidays' _I* week1 week3 week4, cluster(id1);
reg nonfoodr `holidays' _I* week1 week3 week4, cluster(id1);
reg totalr `holidays' _I* week1 week3 week4, cluster(id1);
sum foodtotr nonfoodr totalr;


* results by income subgroup;
* this is the rest of row 1 in Table 6;
sort income_group;
by income_group: reg foodtotr `holidays' _I* week1 week3 week4, cluster(id1);
by income_group: reg nonfoodr `holidays' _I* week1 week3 week4, cluster(id1);
by income_group: reg totalr `holidays' _I* week1 week3 week4, cluster(id1);
by income_group: sum foodtotr nonfoodr totalr;


* results by education group;
* this is row 2 in Table 6;
sort educ_group;
by educ_group: reg foodtotr `holidays' _I* week1 week3 week4, cluster(id1);
by educ_group: reg nonfoodr `holidays' _I* week1 week3 week4, cluster(id1);
by educ_group: reg totalr `holidays' _I* week1 week3 week4, cluster(id1);
by educ_group: sum foodtotr nonfoodr totalr;

* by public welfare enrollment;
* this is row 3 in table 6;
sort public_grp;
tab public_grp;
by public_grp: reg foodtotr `holidays' _I* week1 week3 week4, cluster(id1);
by public_grp: reg nonfoodr `holidays' _I* week1 week3 week4, cluster(id1);
by public_grp: reg totalr `holidays' _I* week1 week3 week4, cluster(id1);
by public_grp: sum foodtotr nonfoodr totalr;
log close;