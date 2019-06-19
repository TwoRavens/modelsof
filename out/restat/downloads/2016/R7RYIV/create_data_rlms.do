*  Creates RLMS data set for RF women/sex ratios project


clear
capture log close
set more 1
log using create_data_rlms.log, replace

# delimit ;
use c:\rlms\round5\r5hhrost;
keep site5 family5 rural;
sort site5 family5;
save temphouse, replace;

use c:\rlms\round5\r5inwgt;
keep site5 family5 person5 inwgt_5;
sort site5 family5 person5;
save temp, replace;

use c:\rlms\round5\r5inwomn;
sort site5 family5 person5;
assert aid !=.;

merge 1:1 site5 family5 person5 using temp;
assert _merge==3;
save temp, replace;

use temphouse;
joinby site5 family5 using temp;

*  Creating year of birth variable;
gen byear5=i5birthy;

keep if i5gender==2;
gen inrd5=1;
sort aid;
assert aid !=.;
assert aid!=aid[_n-1];
save round5, replace;


*  Round 6;
use c:\rlms\round6\r6inwomn;
sort site censusd family person;
sort site censusd family person;
ren site site6;
save temp, replace;

use c:\rlms\round6\r6inwgt;
keep site6 censusd6 family6 person6 inwgt_6;
ren censusd6 censusd;
ren family6 family;
ren person6 person;
sort site censusd family person;

merge 1:1 site6 censusd family person using temp;
keep if _merge==3;
drop _merge;
sort bid;
assert bid !=bid[_n-1];

*  Creating year of birth variable;
gen byear6=i6birthy;

keep if i6gender==2;
keep if i6rpin94==2;
gen inrd6=1;
assert bid !=.;
sort bid;
assert bid!=bid[_n-1];
save round6, replace;



*  Round 7;
use c:\rlms\round7\r7inwomn;
sort site7 censusd7 family7 person7;
save temp, replace;

use c:\rlms\round7\r7inwork;
keep site7 censusd7 family7 person7 i7birthy;;
sort site7 censusd7 family7 person7;
save temp2, replace;

use c:\rlms\round7\r7inwgt;
keep site7 censusd7 family7 person7 inwgt_7;
sort site7 censusd7 family7 person7;
drop if site7==133 & censusd7==0 & family7==51 & person7==7;

merge 1:1 site7 censusd7 family7 person7 using temp;
keep if _merge==3;
drop _merge;
sort site7 censusd7 family7 person7;
merge 1:1 site7 censusd7 family7 person7 using temp2;
keep if _merge==3;
drop _merge;

*  Creating year of birth variable;
gen byear7=i7birthy;

keep if i7rpinbf==3;
keep if i7gender==2;

gen inrd7=1;
sort cid;
assert cid !=.;
assert cid !=cid[_n-1];
save round7, replace;



*  Round 8;
use c:\rlms\round8\r8inwomn;
sort site8 censusd8 family8 person8;
save temp, replace;

use c:\rlms\round8\r8inwgt;
keep site8 censusd8 family8 person8 inwgt_8 did;
sort site8 censusd8 family8 person8;

merge 1:1 site8 censusd8 family8 person8 using temp;
keep if _merge==3;
drop _merge;


*  Creating year of birth variable;
gen byear8=i8birthy;

keep if i8rpinbf==4;
keep if i8gender==2;

gen inrd8=1;
sort did;
assert did !=.;
assert did!=did[_n-1];
save round8, replace;

*  Appending rounds;
use round5;
append using round6;
append using round7;
append using round8;

gen age94=1994-byear5 if inrd5==1;
gen age95=1995-byear6 if inrd6==1;
gen age96=1996-byear7 if inrd7==1;
gen age98=1998-byear8 if inrd8==1;

gen byear=byear5;
replace byear=byear6 if byear==.;
replace byear=byear7 if byear==.;
replace byear=byear8 if byear==.;

gen site=site5;
replace site=site6 if site==.;
replace site=site7 if site==.;
replace site=site8 if site==.;

gen psu=.;
replace psu=1 if site==141 & psu==.;
replace psu=2 if site >=138 & site <=140 & psu==.;
replace psu=3 if site>=142 & site <=160 & psu==.;
replace psu=4 if site==105 & psu==.;
replace psu=5 if site==89 & psu==. | site==90 & psu==. | site==91 & psu==.;
replace psu=6 if site >=1 & site <=8 & psu==.;
replace psu=7 if site==135 & psu==.;
replace psu=8 if site==67 & psu==. | site==68 & psu==. | site==69 & psu==.;
replace psu=9 if site==136 & psu==.;
replace psu=10 if site>=14 & site <=32 & psu==.;
replace psu=11 if site==116 & psu==.;
replace psu=12 if site>=48 & site <=51 & psu==.;
replace psu=13 if site>=117 & site <=128 & psu==.;
replace psu=14 if site==72 & psu==.;
replace psu=15 if site>=33 & site <=38 & psu==.;
replace psu=16 if site==45 & psu==.;
replace psu=17 if site==70 & psu==.;
replace psu=18 if site>=100 & site <=104 & psu==.;
replace psu=19 if site>=39 & site <=44 & psu==.;
replace psu=20 if site>=77 & site <=83 & psu==.;
replace psu=21 if site==137 & psu==.;
replace psu=22 if site==9 & psu==.;
replace psu=23 if site>=52 & site <=57 & psu==.;
replace psu=24 if site>=129 & site <=134 & psu==.;
replace psu=25 if site==106 & psu==.;
replace psu=26 if site==46 & psu==.;
replace psu=27 if site==10 & psu==. | site==11 & psu==.;
replace psu=28 if site==47 & psu==.;
replace psu=29 if site==12 & psu==. | site==13 & psu==.;
replace psu=30 if site>=107 & site <=115 & psu==.;
replace psu=31 if site==71 & psu==.;
replace psu=32 if site>=86 & site <=88 & psu==.;
replace psu=33 if site==84 | site==85 & psu==.;
replace psu=34 if site >=58 & site <=65 & psu==.;
replace psu=35 if site==66 & psu==.;
replace psu=36 if site==92 & psu==.;
replace psu=37 if site>=73 & site <=76 & psu==.;
replace psu=38 if site>=93 & site <=99 & psu==.;
assert psu !=0 & psu !=.;

*  Creating oblast dummy variables;
gen regno=0;
replace regno=7 if site==141;
replace regno=16 if site==138 | site==139 | site==140;
replace regno=17 if site>=142 & site<=160;
replace regno=2 if site==105 | site==89 | site==90 | site==91;
replace regno=8 if site >=1 & site<=8;
replace regno=20 if site==135;
replace regno=21 if site==67 | site==68 | site==69;
replace regno=22 if site==136;
replace regno=14 if site>=14 & site<=32;
replace regno=28 if site==116;
replace regno=26 if site>=48 & site<=51;
replace regno=38 if site>=117 & site<=128;
replace regno=32 if site==72;
replace regno=33 if site>=33 & site<=38;
replace regno=35 if site==45;
replace regno=40 if site==70 | site>=100 & site<=104;
replace regno=37 if site>=39 & site<=44;
replace regno=44 if site>=77 & site<=83;
replace regno=51 if site==137;
replace regno=49 if site==9 | site>=129 & site<=134;
replace regno=50 if site>=52 & site<=57;
replace regno=59 if site==106;
replace regno=54 if site==46;
replace regno=53 if site==10 | site==11;
replace regno=55 if site==47;
replace regno=56 if site==12 | site==13;
replace regno=59 if site>=107 & site<=115;
replace regno=65 if site==71;
replace regno=67 if site>=86 & site<=88;
replace regno=61 if site==84 | site==85;
replace regno=61 if site>=58 & site<=65;
replace regno=72 if site==66;
replace regno=82 if site==92;
replace regno=72 if site>=73 & site<=76;
replace regno=84 if site>=93 & site<=99;
assert regno !=.;

*  Only have rural information for Round 5;
*  Using codes for Round5 to assign urban/rural for other rounds;
replace rural=0 if rural==1 | rural==2;
replace rural=1 if rural==3;
replace rural=0 if regno==16 & rural==.;
replace rural=0 if regno==7 & rural==.;
replace rural=1 if site==144 & rural==.;
replace rural=1 if site==151 & rural==.;
replace rural=1 if site==152 & rural==.;
replace rural=1 if site==158 & rural==.;
replace rural=1 if site==90 & rural==.;
replace rural=1 if site==91 & rural==.;
replace rural=1 if site>=2 & site<=8 & rural==.;
replace rural=1 if site==68 & rural==.;
replace rural=1 if site==69 & rural==.;
replace rural=1 if site>=14 & site<=32 & rural==.;
replace rural=1 if site==49 & rural==.;
replace rural=1 if site==50 & rural==.;
replace rural=1 if site>=118 & site<=128 & rural==.;
replace rural=1 if site>=34 & site<=38 & rural==.;
replace rural=1 if site==101 & rural==.;
replace rural=1 if site==102 & rural==.;
replace rural=1 if site>=40 & site<=44 & rural==.;
replace rural=1 if site>=78 & site<=83 & rural==.;
replace rural=1 if site>=53 & site<=57 & rural==.;
replace rural=1 if site>=129 & site<=137 & rural==.;
replace rural=1 if site==11 & rural==.;
replace rural=1 if site==13 & rural==.;
replace rural=1 if site>=107 & site<=115 & rural==.;
replace rural=1 if site==85 & rural==.;
replace rural=1 if site>=58 & site<=65 & rural==.;
replace rural=1 if site>=74 & site<=76 & rural==.;
replace rural=1 if site>=93 & site<=99 & rural==.;
replace rural=0 if rural==.;

*  Merging in oblast and republic sex ratios by year of birth;
replace regno=66 if regno==67;
sort regno byear;
drop _merge;
merge m:1 regno byear using sexratios_ussr;
keep if _merge==3;
drop _merge;

drop if inrd5==. & inrd6==. & inrd7==. & inrd8==. ;

drop if sr10a==.;
keep if byear >=1915 & byear <=1941;

gen age=age94;
replace age=age95 if inrd6==1;
replace age=age96 if inrd7==1;
replace age=age98 if inrd8==1;

*  Number of births;
replace i6totbir=. if i6totbir==99;
replace i5totbir=0 if i5hadbab==2;
replace i6totbir=0 if i6hadbab==2;
replace i7totbir=0 if i7hadbab==2;
replace i8totbir=0 if i8hadbab==2;

replace i5totbir=1 if i5hadbab==1 & i5totbir==.;
replace i6totbir=1 if i6hadbab==1 & i6totbir==.;
replace i7totbir=1 if i7hadbab==1 & i7totbir==.;
replace i8totbir=1 if i8hadbab==1 & i8totbir==.;

*  Child death variable only in Round 5;
*  Have to compute it for Rounds 6-8;
egen bornliv6=rowtotal(i6bbaliv *i6gbaliv) if inrd6==1;
gen i6chddie=1 if i6totbir > bornliv6 & inrd6==1;
replace i6chddie=0 if i6totbir==bornliv6 & inrd6==1;
egen bornliv7=rowtotal(i7bbaliv i7gbaliv) if inrd7==1;
gen i7chddie=1 if i7totbir > bornliv7 & inrd7==1;
replace i7chddie=0 if i7totbir==bornliv7 & inrd7==1;
egen bornliv8=rowtotal(i8bbaliv i8gbaliv) if inrd8==1;
gen i8chddie=1 if i8totbir > bornliv8 & inrd8==1;
replace i8chddie=0 if i7totbir==bornliv7 & inrd7==1;
replace i5totbir=1 if i5chddie==1 & i5totbir==.;
replace i6totbir=1 if i6chddie==1 & i6totbir==.;
replace i7totbir=1 if i7chddie==1 & i7totbir==.;
replace i8totbir=1 if i8chddie==1 & i8totbir==.;

gen totbir=i5totbir if inrd5==1;
replace totbir=i6totbir if inrd6==1;
replace totbir=i7totbir if inrd7==1;
replace totbir=i8totbir if inrd8==1;
count if totbir==.;

*  Abortions;
*  Have you ever had an abortion;
*  1  yes  2 no;
gen everabo=.;
replace everabo=1 if i5evrabo==1 | i6evrabo==1 | i7evrabo==1 | i8evrabo==1;
replace everabo=0 if i5evrabo==2 | i6evrabo==2 | i7evrabo==2 | i8evrabo==2;
tab everabo;

*  How many abortions in all have you had?;
assert i5numabo != 97 & i5numabo !=98;
assert i6numabo != 97 & i6numabo !=98;
assert i7numabo != 97 & i7numabo !=98;
assert i8numabo != 97 & i8numabo !=98;
gen numabo=.;
replace numabo=i5numabo if inrd5==1;
replace numabo=i6numabo if inrd6==1;
replace numabo=i7numabo if inrd7==1;
replace numabo=i8numabo if inrd8==1;
assert numabo==0 | numabo==. if everabo==0;
replace numabo=0 if everabo==0;
replace numabo=1 if everabo==1 & numabo==.;
replace everabo=1 if numabo >=1 & numabo !=.;

gen popm=popmu+popmr;
replace popm=popmu if regno==7 | regno==16;
gen lnpopm=log(popm);

gen yr94=0;
replace yr94=1 if inrd5==1;
gen yr95=0;
replace yr95=1 if inrd6==1;
gen yr96=0;
replace yr96=1 if inrd7==1;
gen yr98=0;
replace yr98=1 if inrd8==1;

gen inwgt=.;
replace inwgt=inwgt_5;
replace inwgt=inwgt_6 if inwgt==.;
replace inwgt=inwgt_7 if inwgt==.;
replace inwgt=inwgt_8 if inwgt==.;

save data_rlms, replace;
log close;

