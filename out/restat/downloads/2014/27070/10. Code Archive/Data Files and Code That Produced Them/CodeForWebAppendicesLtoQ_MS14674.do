*******************************************************************************************************;
*Researchers must apply/pay for remote access to the confidential 2001, 2003, and 2005 CHIS data;
*For information on how to do so, contact the corresponding author or UCLA directly at dacchpr@ucla.edu;
*These data will produce web Appendices L-Q;
*******************************************************************************************************;

capture log close
clear


#delimit;
set mem 1200m;
set matsize 2000;
set more off;
version 8;

****************************************************************************************************************************;
*UCLA Data Access Center will provide pooled 2001, 2003, and 2005 CHIS datafile with restricted birthdate and interivew date;
****************************************************************************************************************************;

keep if age>=18 & age<=23;

************************************************;
*create age in months, months since drinking age;
************************************************;

*Note CHIS maksed day of birth but gives month and year;
gen aa1day=15;

keep if aa1day>=1 & aa1day<=31;
keep if aa1mon>=1 & aa1mon<=12;
keep if aa1yr>=0 & aa1yr~=.;
gen aa1yrplus21=aa1yr+21;

gen birthdateplus21yrs=mdy(aa1mon, aa1day, aa1yrplus21);
drop if birthdateplus21yrs==.;

gen yearstr=substr(aadate,1,4);
gen monthstr=substr(aadate,5,2);
gen daystr=substr(aadate,7,2);

gen newyear=real(yearstr);
gen newmonth=real(monthstr);
gen newday=real(daystr);

gen newinterviewdate=mdy(newmonth, newday, newyear);

gen relativeageindays=newinterviewdate-birthdateplus21yrs;

gen overda=relativeageindays>=0;

gen dayssinceda=relativeageindays;


*assess how bad the misclassification problem is around age 21;
tab dayssinceda age if dayssinceda>=-30 & dayssinceda<=30;

*birthday interview month dummy;
gen samemonth=newmonth==aa1mon;
gen bmonth=(age==21 & samemonth==1);



*Use the information for ppl born & interviewed in same month around each age to assign "expected" age in days;
gen correcteddayssinceda=dayssinceda;

replace correcteddayssinceda=-1087 if samemonth==1 & age==18 & dayssinceda==-1095;
replace correcteddayssinceda=-1087 if samemonth==1 & age==18 & dayssinceda==-1096;
replace correcteddayssinceda=-1088 if samemonth==1 & age==18 & dayssinceda==-1097;
replace correcteddayssinceda=-1088 if samemonth==1 & age==18 & dayssinceda==-1098;
replace correcteddayssinceda=-1089 if samemonth==1 & age==18 & dayssinceda==-1099;
replace correcteddayssinceda=-1089 if samemonth==1 & age==18 & dayssinceda==-1100;
replace correcteddayssinceda=-1090 if samemonth==1 & age==18 & dayssinceda==-1101;
replace correcteddayssinceda=-1090 if samemonth==1 & age==18 & dayssinceda==-1102;
replace correcteddayssinceda=-1091 if samemonth==1 & age==18 & dayssinceda==-1103;
replace correcteddayssinceda=-1091 if samemonth==1 & age==18 & dayssinceda==-1104;
replace correcteddayssinceda=-1092 if samemonth==1 & age==18 & dayssinceda==-1105;
replace correcteddayssinceda=-1092 if samemonth==1 & age==18 & dayssinceda==-1106;
replace correcteddayssinceda=-1093 if samemonth==1 & age==18 & dayssinceda==-1107;
replace correcteddayssinceda=-1093 if samemonth==1 & age==18 & dayssinceda==-1108;


replace correcteddayssinceda=-722 if samemonth==1 & age==19 & dayssinceda==-730;
replace correcteddayssinceda=-722 if samemonth==1 & age==19 & dayssinceda==-731;
replace correcteddayssinceda=-723 if samemonth==1 & age==19 & dayssinceda==-732;
replace correcteddayssinceda=-723 if samemonth==1 & age==19 & dayssinceda==-733;
replace correcteddayssinceda=-724 if samemonth==1 & age==19 & dayssinceda==-734;
replace correcteddayssinceda=-724 if samemonth==1 & age==19 & dayssinceda==-735;
replace correcteddayssinceda=-725 if samemonth==1 & age==19 & dayssinceda==-736;
replace correcteddayssinceda=-725 if samemonth==1 & age==19 & dayssinceda==-737;
replace correcteddayssinceda=-726 if samemonth==1 & age==19 & dayssinceda==-738;
replace correcteddayssinceda=-726 if samemonth==1 & age==19 & dayssinceda==-739;
replace correcteddayssinceda=-727 if samemonth==1 & age==19 & dayssinceda==-740;
replace correcteddayssinceda=-727 if samemonth==1 & age==19 & dayssinceda==-741;
replace correcteddayssinceda=-728 if samemonth==1 & age==19 & dayssinceda==-742;
replace correcteddayssinceda=-728 if samemonth==1 & age==19 & dayssinceda==-743;
replace correcteddayssinceda=-736 if samemonth==1 & age==18 & dayssinceda==-729;
replace correcteddayssinceda=-736 if samemonth==1 & age==18 & dayssinceda==-728;
replace correcteddayssinceda=-737 if samemonth==1 & age==18 & dayssinceda==-727;
replace correcteddayssinceda=-737 if samemonth==1 & age==18 & dayssinceda==-726;
replace correcteddayssinceda=-738 if samemonth==1 & age==18 & dayssinceda==-725;
replace correcteddayssinceda=-738 if samemonth==1 & age==18 & dayssinceda==-724;
replace correcteddayssinceda=-739 if samemonth==1 & age==18 & dayssinceda==-723;
replace correcteddayssinceda=-739 if samemonth==1 & age==18 & dayssinceda==-722;
replace correcteddayssinceda=-740 if samemonth==1 & age==18 & dayssinceda==-721;
replace correcteddayssinceda=-740 if samemonth==1 & age==18 & dayssinceda==-720;
replace correcteddayssinceda=-741 if samemonth==1 & age==18 & dayssinceda==-719;
replace correcteddayssinceda=-741 if samemonth==1 & age==18 & dayssinceda==-718;
replace correcteddayssinceda=-742 if samemonth==1 & age==18 & dayssinceda==-717;
replace correcteddayssinceda=-742 if samemonth==1 & age==18 & dayssinceda==-716;
replace correcteddayssinceda=-743 if samemonth==1 & age==18 & dayssinceda==-715;
replace correcteddayssinceda=-743 if samemonth==1 & age==18 & dayssinceda==-714;
replace correcteddayssinceda=-744 if samemonth==1 & age==18 & dayssinceda==-713;
replace correcteddayssinceda=-744 if samemonth==1 & age==18 & dayssinceda==-712;

replace correcteddayssinceda=-357 if samemonth==1 & age==20 & dayssinceda==-365;
replace correcteddayssinceda=-357 if samemonth==1 & age==20 & dayssinceda==-366;
replace correcteddayssinceda=-358 if samemonth==1 & age==20 & dayssinceda==-367;
replace correcteddayssinceda=-358 if samemonth==1 & age==20 & dayssinceda==-368;
replace correcteddayssinceda=-359 if samemonth==1 & age==20 & dayssinceda==-369;
replace correcteddayssinceda=-359 if samemonth==1 & age==20 & dayssinceda==-370;
replace correcteddayssinceda=-360 if samemonth==1 & age==20 & dayssinceda==-371;
replace correcteddayssinceda=-360 if samemonth==1 & age==20 & dayssinceda==-372;
replace correcteddayssinceda=-361 if samemonth==1 & age==20 & dayssinceda==-373;
replace correcteddayssinceda=-361 if samemonth==1 & age==20 & dayssinceda==-374;
replace correcteddayssinceda=-362 if samemonth==1 & age==20 & dayssinceda==-375;
replace correcteddayssinceda=-362 if samemonth==1 & age==20 & dayssinceda==-376;
replace correcteddayssinceda=-363 if samemonth==1 & age==20 & dayssinceda==-377;
replace correcteddayssinceda=-363 if samemonth==1 & age==20 & dayssinceda==-378;
replace correcteddayssinceda=-371 if samemonth==1 & age==19 & dayssinceda==-364;
replace correcteddayssinceda=-371 if samemonth==1 & age==19 & dayssinceda==-363;
replace correcteddayssinceda=-372 if samemonth==1 & age==19 & dayssinceda==-362;
replace correcteddayssinceda=-372 if samemonth==1 & age==19 & dayssinceda==-361;
replace correcteddayssinceda=-373 if samemonth==1 & age==19 & dayssinceda==-360;
replace correcteddayssinceda=-373 if samemonth==1 & age==19 & dayssinceda==-359;
replace correcteddayssinceda=-374 if samemonth==1 & age==19 & dayssinceda==-358;
replace correcteddayssinceda=-374 if samemonth==1 & age==19 & dayssinceda==-357;
replace correcteddayssinceda=-375 if samemonth==1 & age==19 & dayssinceda==-356;
replace correcteddayssinceda=-375 if samemonth==1 & age==19 & dayssinceda==-355;
replace correcteddayssinceda=-376 if samemonth==1 & age==19 & dayssinceda==-354;
replace correcteddayssinceda=-376 if samemonth==1 & age==19 & dayssinceda==-353;
replace correcteddayssinceda=-377 if samemonth==1 & age==19 & dayssinceda==-352;
replace correcteddayssinceda=-377 if samemonth==1 & age==19 & dayssinceda==-351;
replace correcteddayssinceda=-378 if samemonth==1 & age==19 & dayssinceda==-350;
replace correcteddayssinceda=-378 if samemonth==1 & age==19 & dayssinceda==-349;
replace correcteddayssinceda=-379 if samemonth==1 & age==19 & dayssinceda==-348;
replace correcteddayssinceda=-379 if samemonth==1 & age==19 & dayssinceda==-347;

replace correcteddayssinceda=7 if samemonth==1 & age==21 & dayssinceda==-1;
replace correcteddayssinceda=7 if samemonth==1 & age==21 & dayssinceda==-2;
replace correcteddayssinceda=6 if samemonth==1 & age==21 & dayssinceda==-3;
replace correcteddayssinceda=6 if samemonth==1 & age==21 & dayssinceda==-4;
replace correcteddayssinceda=5 if samemonth==1 & age==21 & dayssinceda==-5;
replace correcteddayssinceda=5 if samemonth==1 & age==21 & dayssinceda==-6;
replace correcteddayssinceda=4 if samemonth==1 & age==21 & dayssinceda==-7;
replace correcteddayssinceda=4 if samemonth==1 & age==21 & dayssinceda==-8;
replace correcteddayssinceda=3 if samemonth==1 & age==21 & dayssinceda==-9;
replace correcteddayssinceda=3 if samemonth==1 & age==21 & dayssinceda==-10;
replace correcteddayssinceda=2 if samemonth==1 & age==21 & dayssinceda==-11;
replace correcteddayssinceda=2 if samemonth==1 & age==21 & dayssinceda==-12;
replace correcteddayssinceda=1 if samemonth==1 & age==21 & dayssinceda==-13;
replace correcteddayssinceda=1 if samemonth==1 & age==21 & dayssinceda==-14;
replace correcteddayssinceda=-7 if samemonth==1 & age==20 & dayssinceda==0;
replace correcteddayssinceda=-7 if samemonth==1 & age==20 & dayssinceda==1;
replace correcteddayssinceda=-8 if samemonth==1 & age==20 & dayssinceda==2;
replace correcteddayssinceda=-8 if samemonth==1 & age==20 & dayssinceda==3;
replace correcteddayssinceda=-9 if samemonth==1 & age==20 & dayssinceda==4;
replace correcteddayssinceda=-9 if samemonth==1 & age==20 & dayssinceda==5;
replace correcteddayssinceda=-10 if samemonth==1 & age==20 & dayssinceda==6;
replace correcteddayssinceda=-10 if samemonth==1 & age==20 & dayssinceda==7;
replace correcteddayssinceda=-11 if samemonth==1 & age==20 & dayssinceda==8;
replace correcteddayssinceda=-11 if samemonth==1 & age==20 & dayssinceda==9;
replace correcteddayssinceda=-12 if samemonth==1 & age==20 & dayssinceda==10;
replace correcteddayssinceda=-12 if samemonth==1 & age==20 & dayssinceda==11;
replace correcteddayssinceda=-13 if samemonth==1 & age==20 & dayssinceda==12;
replace correcteddayssinceda=-13 if samemonth==1 & age==20 & dayssinceda==13;
replace correcteddayssinceda=-14 if samemonth==1 & age==20 & dayssinceda==14;
replace correcteddayssinceda=-14 if samemonth==1 & age==20 & dayssinceda==15;
replace correcteddayssinceda=-15 if samemonth==1 & age==20 & dayssinceda==16;
replace correcteddayssinceda=-15 if samemonth==1 & age==20 & dayssinceda==17;

replace correcteddayssinceda=372 if samemonth==1 & age==22 & dayssinceda==364;
replace correcteddayssinceda=372 if samemonth==1 & age==22 & dayssinceda==363;
replace correcteddayssinceda=371 if samemonth==1 & age==22 & dayssinceda==362;
replace correcteddayssinceda=371 if samemonth==1 & age==22 & dayssinceda==361;
replace correcteddayssinceda=370 if samemonth==1 & age==22 & dayssinceda==360;
replace correcteddayssinceda=370 if samemonth==1 & age==22 & dayssinceda==359;
replace correcteddayssinceda=369 if samemonth==1 & age==22 & dayssinceda==358;
replace correcteddayssinceda=369 if samemonth==1 & age==22 & dayssinceda==357;
replace correcteddayssinceda=368 if samemonth==1 & age==22 & dayssinceda==356;
replace correcteddayssinceda=368 if samemonth==1 & age==22 & dayssinceda==355;
replace correcteddayssinceda=367 if samemonth==1 & age==22 & dayssinceda==354;
replace correcteddayssinceda=367 if samemonth==1 & age==22 & dayssinceda==353;
replace correcteddayssinceda=366 if samemonth==1 & age==22 & dayssinceda==352;
replace correcteddayssinceda=366 if samemonth==1 & age==22 & dayssinceda==351;
replace correcteddayssinceda=358 if samemonth==1 & age==21 & dayssinceda==365;
replace correcteddayssinceda=358 if samemonth==1 & age==21 & dayssinceda==366;
replace correcteddayssinceda=357 if samemonth==1 & age==21 & dayssinceda==367;
replace correcteddayssinceda=357 if samemonth==1 & age==21 & dayssinceda==368;
replace correcteddayssinceda=356 if samemonth==1 & age==21 & dayssinceda==369;
replace correcteddayssinceda=356 if samemonth==1 & age==21 & dayssinceda==370;
replace correcteddayssinceda=355 if samemonth==1 & age==21 & dayssinceda==371;
replace correcteddayssinceda=355 if samemonth==1 & age==21 & dayssinceda==372;
replace correcteddayssinceda=354 if samemonth==1 & age==21 & dayssinceda==373;
replace correcteddayssinceda=354 if samemonth==1 & age==21 & dayssinceda==374;
replace correcteddayssinceda=352 if samemonth==1 & age==21 & dayssinceda==375;
replace correcteddayssinceda=352 if samemonth==1 & age==21 & dayssinceda==376;
replace correcteddayssinceda=351 if samemonth==1 & age==21 & dayssinceda==377;
replace correcteddayssinceda=351 if samemonth==1 & age==21 & dayssinceda==378;
replace correcteddayssinceda=350 if samemonth==1 & age==21 & dayssinceda==379;
replace correcteddayssinceda=350 if samemonth==1 & age==21 & dayssinceda==380;
replace correcteddayssinceda=349 if samemonth==1 & age==21 & dayssinceda==381;
replace correcteddayssinceda=349 if samemonth==1 & age==21 & dayssinceda==382;

replace correcteddayssinceda=737 if samemonth==1 & age==23 & dayssinceda==729;
replace correcteddayssinceda=737 if samemonth==1 & age==23 & dayssinceda==728;
replace correcteddayssinceda=736 if samemonth==1 & age==23 & dayssinceda==727;
replace correcteddayssinceda=736 if samemonth==1 & age==23 & dayssinceda==726;
replace correcteddayssinceda=735 if samemonth==1 & age==23 & dayssinceda==725;
replace correcteddayssinceda=735 if samemonth==1 & age==23 & dayssinceda==724;
replace correcteddayssinceda=734 if samemonth==1 & age==23 & dayssinceda==723;
replace correcteddayssinceda=734 if samemonth==1 & age==23 & dayssinceda==722;
replace correcteddayssinceda=733 if samemonth==1 & age==23 & dayssinceda==721;
replace correcteddayssinceda=733 if samemonth==1 & age==23 & dayssinceda==720;
replace correcteddayssinceda=732 if samemonth==1 & age==23 & dayssinceda==719;
replace correcteddayssinceda=732 if samemonth==1 & age==23 & dayssinceda==718;
replace correcteddayssinceda=731 if samemonth==1 & age==23 & dayssinceda==717;
replace correcteddayssinceda=731 if samemonth==1 & age==23 & dayssinceda==716;
replace correcteddayssinceda=723 if samemonth==1 & age==22 & dayssinceda==730;
replace correcteddayssinceda=723 if samemonth==1 & age==22 & dayssinceda==731;
replace correcteddayssinceda=722 if samemonth==1 & age==22 & dayssinceda==732;
replace correcteddayssinceda=722 if samemonth==1 & age==22 & dayssinceda==733;
replace correcteddayssinceda=721 if samemonth==1 & age==22 & dayssinceda==734;
replace correcteddayssinceda=721 if samemonth==1 & age==22 & dayssinceda==735;
replace correcteddayssinceda=720 if samemonth==1 & age==22 & dayssinceda==736;
replace correcteddayssinceda=720 if samemonth==1 & age==22 & dayssinceda==737;
replace correcteddayssinceda=719 if samemonth==1 & age==22 & dayssinceda==738;
replace correcteddayssinceda=719 if samemonth==1 & age==22 & dayssinceda==739;
replace correcteddayssinceda=718 if samemonth==1 & age==22 & dayssinceda==740;
replace correcteddayssinceda=718 if samemonth==1 & age==22 & dayssinceda==741;
replace correcteddayssinceda=717 if samemonth==1 & age==22 & dayssinceda==742;
replace correcteddayssinceda=717 if samemonth==1 & age==22 & dayssinceda==743;
replace correcteddayssinceda=716 if samemonth==1 & age==22 & dayssinceda==744;
replace correcteddayssinceda=716 if samemonth==1 & age==22 & dayssinceda==745;
replace correcteddayssinceda=715 if samemonth==1 & age==22 & dayssinceda==746;
replace correcteddayssinceda=715 if samemonth==1 & age==22 & dayssinceda==747;

replace correcteddayssinceda=1087 if samemonth==1 & age==23 & dayssinceda==1095;
replace correcteddayssinceda=1087 if samemonth==1 & age==23 & dayssinceda==1096;
replace correcteddayssinceda=1086 if samemonth==1 & age==23 & dayssinceda==1097;
replace correcteddayssinceda=1086 if samemonth==1 & age==23 & dayssinceda==1098;
replace correcteddayssinceda=1085 if samemonth==1 & age==23 & dayssinceda==1099;
replace correcteddayssinceda=1085 if samemonth==1 & age==23 & dayssinceda==1100;
replace correcteddayssinceda=1084 if samemonth==1 & age==23 & dayssinceda==1101;
replace correcteddayssinceda=1084 if samemonth==1 & age==23 & dayssinceda==1102;
replace correcteddayssinceda=1083 if samemonth==1 & age==23 & dayssinceda==1103;
replace correcteddayssinceda=1083 if samemonth==1 & age==23 & dayssinceda==1104;
replace correcteddayssinceda=1082 if samemonth==1 & age==23 & dayssinceda==1105;
replace correcteddayssinceda=1082 if samemonth==1 & age==23 & dayssinceda==1106;
replace correcteddayssinceda=1081 if samemonth==1 & age==23 & dayssinceda==1107;
replace correcteddayssinceda=1081 if samemonth==1 & age==23 & dayssinceda==1108;
replace correcteddayssinceda=1080 if samemonth==1 & age==23 & dayssinceda==1109;
replace correcteddayssinceda=1080 if samemonth==1 & age==23 & dayssinceda==1110;
replace correcteddayssinceda=1079 if samemonth==1 & age==23 & dayssinceda==1111;
replace correcteddayssinceda=1079 if samemonth==1 & age==23 & dayssinceda==1112;


gen correctedmonthssinceda=-37 if correcteddayssinceda>=-1124.8 & correcteddayssinceda<-1094.4;
replace correctedmonthssinceda=-36 if correcteddayssinceda>=-1094.4 & correcteddayssinceda<-1064;
replace correctedmonthssinceda=-35 if correcteddayssinceda>=-1064 & correcteddayssinceda<-1033.6;
replace correctedmonthssinceda=-34 if correcteddayssinceda>=-1033.6 & correcteddayssinceda<-1003.2;
replace correctedmonthssinceda=-33 if correcteddayssinceda>=-1003.2 & correcteddayssinceda<-972.8;
replace correctedmonthssinceda=-32 if correcteddayssinceda>=-972.8 & correcteddayssinceda<-942.4;
replace correctedmonthssinceda=-31 if correcteddayssinceda>=-942.4 & correcteddayssinceda<-912;
replace correctedmonthssinceda=-30 if correcteddayssinceda>=-912 & correcteddayssinceda<-881.6;
replace correctedmonthssinceda=-29 if correcteddayssinceda>=-881.6 & correcteddayssinceda<-851.2;
replace correctedmonthssinceda=-28 if correcteddayssinceda>=-851.2 & correcteddayssinceda<-820.8;
replace correctedmonthssinceda=-27 if correcteddayssinceda>=-820.8 & correcteddayssinceda<-790.4;
replace correctedmonthssinceda=-26 if correcteddayssinceda>=-790.4 & correcteddayssinceda<-760;
replace correctedmonthssinceda=-25 if correcteddayssinceda>=-760 & correcteddayssinceda<-729.6;
replace correctedmonthssinceda=-24 if correcteddayssinceda>=-729.6 & correcteddayssinceda<-699.2;
replace correctedmonthssinceda=-23 if correcteddayssinceda>=-699.2 & correcteddayssinceda<-668.8;
replace correctedmonthssinceda=-22 if correcteddayssinceda>=-668.8 & correcteddayssinceda<-638.4;
replace correctedmonthssinceda=-21 if correcteddayssinceda>=-638.4 & correcteddayssinceda<-608;
replace correctedmonthssinceda=-20 if correcteddayssinceda>=-608 & correcteddayssinceda<-577.6;
replace correctedmonthssinceda=-19 if correcteddayssinceda>=-577.6 & correcteddayssinceda<-547.2;
replace correctedmonthssinceda=-18 if correcteddayssinceda>=-547.2 & correcteddayssinceda<-516.8;
replace correctedmonthssinceda=-17 if correcteddayssinceda>=-516.8 & correcteddayssinceda<-486.4;
replace correctedmonthssinceda=-16 if correcteddayssinceda>=-486.4 & correcteddayssinceda<-456;
replace correctedmonthssinceda=-15 if correcteddayssinceda>=-456 & correcteddayssinceda<-425.6;
replace correctedmonthssinceda=-14 if correcteddayssinceda>=-425.6 & correcteddayssinceda<-395.2;
replace correctedmonthssinceda=-13 if correcteddayssinceda>=-395.2 & correcteddayssinceda<-364.8;
replace correctedmonthssinceda=-12 if correcteddayssinceda>=-364.8 & correcteddayssinceda<-334.4;
replace correctedmonthssinceda=-11 if correcteddayssinceda>=-334.4 & correcteddayssinceda<-304;
replace correctedmonthssinceda=-10 if correcteddayssinceda>=-304 & correcteddayssinceda<-273.6;
replace correctedmonthssinceda=-9 if correcteddayssinceda>=-273.6 & correcteddayssinceda<-243.2;
replace correctedmonthssinceda=-8 if correcteddayssinceda>=-243.2 & correcteddayssinceda<-212.8;
replace correctedmonthssinceda=-7 if correcteddayssinceda>=-212.8 & correcteddayssinceda<-182.4;
replace correctedmonthssinceda=-6 if correcteddayssinceda>=-182.4 & correcteddayssinceda<-152;
replace correctedmonthssinceda=-5 if correcteddayssinceda>=-152 & correcteddayssinceda<-121.6;
replace correctedmonthssinceda=-4 if correcteddayssinceda>=-121.6 & correcteddayssinceda<-91.2;
replace correctedmonthssinceda=-3 if correcteddayssinceda>=-91.2 & correcteddayssinceda<-60.8;
replace correctedmonthssinceda=-2 if correcteddayssinceda>=-60.8 & correcteddayssinceda<-30.4;
replace correctedmonthssinceda=-1 if correcteddayssinceda>=-30.4 & correcteddayssinceda<0;
replace correctedmonthssinceda=0 if correcteddayssinceda>=0 & correcteddayssinceda<30.4;
replace correctedmonthssinceda=1 if correcteddayssinceda>=30.4 & correcteddayssinceda<60.8;
replace correctedmonthssinceda=2 if correcteddayssinceda>=60.8 & correcteddayssinceda<91.2;
replace correctedmonthssinceda=3 if correcteddayssinceda>=91.2 & correcteddayssinceda<121.6;
replace correctedmonthssinceda=4 if correcteddayssinceda>=121.6 & correcteddayssinceda<152;
replace correctedmonthssinceda=5 if correcteddayssinceda>=152 & correcteddayssinceda<182.4;
replace correctedmonthssinceda=6 if correcteddayssinceda>=182.4 & correcteddayssinceda<212.8;
replace correctedmonthssinceda=7 if correcteddayssinceda>=212.8 & correcteddayssinceda<243.2;
replace correctedmonthssinceda=8 if correcteddayssinceda>=243.2 & correcteddayssinceda<273.6;
replace correctedmonthssinceda=9 if correcteddayssinceda>=273.6 & correcteddayssinceda<304;
replace correctedmonthssinceda=10 if correcteddayssinceda>=304 & correcteddayssinceda<334.4;
replace correctedmonthssinceda=11 if correcteddayssinceda>=334.4 & correcteddayssinceda<364.8;
replace correctedmonthssinceda=12 if correcteddayssinceda>=364.8 & correcteddayssinceda<395.2;
replace correctedmonthssinceda=13 if correcteddayssinceda>=395.2 & correcteddayssinceda<425.6;
replace correctedmonthssinceda=14 if correcteddayssinceda>=425.6 & correcteddayssinceda<456;
replace correctedmonthssinceda=15 if correcteddayssinceda>=456 & correcteddayssinceda<486.4;
replace correctedmonthssinceda=16 if correcteddayssinceda>=486.4 & correcteddayssinceda<516.8;
replace correctedmonthssinceda=17 if correcteddayssinceda>=516.8 & correcteddayssinceda<547.2;
replace correctedmonthssinceda=18 if correcteddayssinceda>=547.2 & correcteddayssinceda<577.6;
replace correctedmonthssinceda=19 if correcteddayssinceda>=577.6 & correcteddayssinceda<608;
replace correctedmonthssinceda=20 if correcteddayssinceda>=608 & correcteddayssinceda<638.4;
replace correctedmonthssinceda=21 if correcteddayssinceda>=638.4 & correcteddayssinceda<668.8;
replace correctedmonthssinceda=22 if correcteddayssinceda>=668.8 & correcteddayssinceda<699.2;
replace correctedmonthssinceda=23 if correcteddayssinceda>=699.2 & correcteddayssinceda<729.6;
replace correctedmonthssinceda=24 if correcteddayssinceda>=729.6 & correcteddayssinceda<760;
replace correctedmonthssinceda=25 if correcteddayssinceda>=760 & correcteddayssinceda<790.4;
replace correctedmonthssinceda=26 if correcteddayssinceda>=790.4 & correcteddayssinceda<820.8;
replace correctedmonthssinceda=27 if correcteddayssinceda>=820.8 & correcteddayssinceda<851.2;
replace correctedmonthssinceda=28 if correcteddayssinceda>=851.2 & correcteddayssinceda<881.6;
replace correctedmonthssinceda=29 if correcteddayssinceda>=881.6 & correcteddayssinceda<912;
replace correctedmonthssinceda=30 if correcteddayssinceda>=912 & correcteddayssinceda<942.4;
replace correctedmonthssinceda=31 if correcteddayssinceda>=942.4 & correcteddayssinceda<972.8;
replace correctedmonthssinceda=32 if correcteddayssinceda>=972.8 & correcteddayssinceda<1003.2;
replace correctedmonthssinceda=33 if correcteddayssinceda>=1003.2 & correcteddayssinceda<1033.6;
replace correctedmonthssinceda=34 if correcteddayssinceda>=1033.6 & correcteddayssinceda<1064;
replace correctedmonthssinceda=35 if correcteddayssinceda>=1064 & correcteddayssinceda<1094.4;
replace correctedmonthssinceda=36 if correcteddayssinceda>=1094.4 & correcteddayssinceda<1124.8;
replace correctedmonthssinceda=37 if correcteddayssinceda>=1124.8 & correcteddayssinceda<1155.2;



*Above age corrections assume we've caught all "true" off diagonals, so remaining ones must be false data;
drop if correctedmonthssinceda>=-24 & age==18;
drop if correctedmonthssinceda<=-25 & age==19;
drop if correctedmonthssinceda>=-12 & age==19;
drop if correctedmonthssinceda<=-13 & age==20;
drop if correctedmonthssinceda>=0 & age==20;
drop if correctedmonthssinceda<=-1 & age==21;
drop if correctedmonthssinceda>=12 & age==21;
drop if correctedmonthssinceda<=11 & age==22;
drop if correctedmonthssinceda>=24 & age==22;
drop if correctedmonthssinceda<=23 & age==23;


gen correctedyearssinceda=correcteddayssinceda/365;

********************************;
*generate relative age variables;
********************************;

gen relative1=correctedyearssinceda;
gen relative2=relative1*relative1;
gen relative3=relative1*relative1*relative1;
gen inter1=overda*relative1;
gen inter2=overda*relative2;
gen inter3=overda*relative3;


********************;
*generate covariates;
********************;

gen male=srsex==1;
gen female=srsex==2;

gen newrace=racehpr;
gen black=newrace==5;
gen latino=newrace==1;
gen othermultrace=newrace==7;
gen white=newrace==6;
gen api=newrace==4 | newrace==2;
gen nonwhite=white==0;

gen newed=aheduc;
gen lesshs=(aheduc==1 | aheduc==2);
gen hs=aheduc==3;
gen somecoll=aheduc==4 | aheduc==5 | aheduc==6;
gen collegeormore=aheduc==7 | aheduc==8 | aheduc==9 | aheduc==10;
gen somecoll2=(aheduc>=4 & aheduc<=10);
gen college=(aheduc==7 | aheduc==8);
gen masters=aheduc==9;

gen atleasths=(aheduc>=3 & aheduc<=10);

gen mastersphd=aheduc==9 | aheduc==10;
gen phd=aheduc==10;

gen married=ah43==1;
gen partner=ah43==2;
gen wds=(ah43==3 | ah43==4 | ah43==5);
gen nevermd=ah43==6;

gen emp1=(ak1==1 | ak1==2);

gen healthins=(insure==1 | ins==1);

gen liveswithaparent=ah43a==1;

gen m1=newmonth==1;
gen m2=newmonth==2;
gen m3=newmonth==3;
gen m4=newmonth==4;
gen m5=newmonth==5;
gen m6=newmonth==6;
gen m7=newmonth==7;
gen m8=newmonth==8;
gen m9=newmonth==9;
gen m10=newmonth==10;
gen m11=newmonth==11;
gen m12=newmonth==12;

gen y1=year==2001;
gen y2=year==2003;
gen y3=year==2005;


******************;
*generate outcomes;
******************;

gen dranklm=ae11==1;
gen newbinge=1 if binge2==1 & year==2001;
replace newbinge=1 if binge==1 & year==2003;
replace newbinge=1 if binge_mf==1 & year==2005;
replace newbinge=0 if newbinge==.;

gen propdaysdrank=ae12/7 if ae12unt==1;
replace propdaysdrank=ae12/30 if ae12unt==2;
*recode ppl whose propdaysdrank will be greater than one if state 31/30;
replace propdaysdrank=1 if ae12==31 & ae12unt==2;
replace propdaysdrank=0 if dranklm==0;
replace propdaysdrank=0 if ae_daydr<0;
drop if propdaysdrank==.;

gen numbinge30=ae14;
replace numbinge30=ae14a if year==2005 & male==0;
replace numbinge30=0 if dranklm==0;
replace numbinge30=0 if ae14<0 & (year==2001 | year==2003);
replace numbinge30=0 if ae14<0 & male==1 & year==2005;
replace numbinge30=0 if ae14a<0 & male==0 & year==2005;

gen propdaysbinge=numbinge30/30;





*two year window for analysis;

keep if correctedmonthssinceda>=-24 & correctedmonthssinceda<=23;

sort correctedmonthssinceda;

*Appendix L - unweighted means of drank last month and binged last month by month of age;
tab correctedmonthssinceda, su(dranklm);
tab correctedmonthssinceda, su(newbinge);

*Appendix M - unweighted means of proportion days drank and binged last month by month of age;
tab correctedmonthssinceda, su(propdaysdrank);
tab correctedmonthssinceda, su(propdaysbinge);

*Appendix N, top row: weighted regressions of drinking outcomes using quadratic in relative age, no covariates;
svy: reg dranklm overda relative1 relative2 inter1 inter2;
svy: reg newbinge overda relative1 relative2 inter1 inter2;
svy: reg propdaysdrank overda relative1 relative2 inter1 inter2;
svy: reg propdaysbinge overda relative1 relative2 inter1 inter2;

*Appendix N, bottom row: weighted regressions of drinking outcomes using quadratic in relative age, with covariates;

global covars "male black latino api lesshs somecoll2 married emp1 healthins bmonth m2-m12 y2-y3";

svy: reg dranklm overda relative1 relative2 inter1 inter2 $covars;
svy: reg newbinge overda relative1 relative2 inter1 inter2 $covars;
svy: reg propdaysdrank overda relative1 relative2 inter1 inter2 $covars;
svy: reg propdaysbinge overda relative1 relative2 inter1 inter2 $covars;

*Appendix Q: weighted regressions of covariates using quadratic in relative age, no covariates;
svy: reg married overda relative1 relative2 inter1 inter2;
svy: reg emp1 overda relative1 relative2 inter1 inter2;
svy: reg lesshs overda relative1 relative2 inter1 inter2;
svy: reg atleasths overda relative1 relative2 inter1 inter2;
svy: reg somecoll2 overda relative1 relative2 inter1 inter2;
svy: reg healthins overda relative1 relative2 inter1 inter2;


clear

exit

