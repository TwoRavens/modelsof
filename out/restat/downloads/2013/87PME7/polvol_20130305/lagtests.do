
#delimit;
use "$startdir\$outputdata\alleconconds.dta", clear;
keep year recmonth lnRmkt lnR rr gdpbeta spirr spibeta neggrowth nipadgdp_neg dsgdp2 nipadgdp recsty dgdp nipadgdp_nsq2 fips;
replace recmonth=recmonth/12;
replace nipadgdp=nipadgdp/100;
replace nipadgdp_nsq2=nipadgdp_nsq2/10000;

quietly tab fips, generate(fipsis);
sort fips year;
by fips: gen lagnipadgdp=nipadgdp[_n-1];
by fips: gen leadnipadgdp=nipadgdp[_n+1];
by fips: gen lag2nipadgdp=nipadgdp[_n-2];
by fips: gen lead2nipadgdp=nipadgdp[_n+2];
by fips: gen lag3nipadgdp=nipadgdp[_n-3];
by fips: gen lead3nipadgdp=nipadgdp[_n+3];
forvalues i=1/48{;
gen lagnipadgdpfipsis`i'=lagnipadgdp*fipsis`i';
gen nipadgdpfipsis`i'=nipadgdp*fipsis`i';
gen leadnipadgdpfipsis`i'=leadnipadgdp*fipsis`i';
gen lag2nipadgdpfipsis`i'=lag2nipadgdp*fipsis`i';
gen lead2nipadgdpfipsis`i'=lead2nipadgdp*fipsis`i';
gen lag3nipadgdpfipsis`i'=lag3nipadgdp*fipsis`i';
gen lead3nipadgdpfipsis`i'=lead3nipadgdp*fipsis`i';
};

global lag       "lagnipadgdpfipsis1  lagnipadgdpfipsis2  lagnipadgdpfipsis3 lagnipadgdpfipsis4 lagnipadgdpfipsis5 lagnipadgdpfipsis6 lagnipadgdpfipsis7 lagnipadgdpfipsis8 lagnipadgdpfipsis9 lagnipadgdpfipsis10 lagnipadgdpfipsis11 lagnipadgdpfipsis12 lagnipadgdpfipsis13 lagnipadgdpfipsis14 lagnipadgdpfipsis15 lagnipadgdpfipsis16 lagnipadgdpfipsis17 lagnipadgdpfipsis18 lagnipadgdpfipsis19 lagnipadgdpfipsis20 lagnipadgdpfipsis21 lagnipadgdpfipsis22 lagnipadgdpfipsis23 lagnipadgdpfipsis24 lagnipadgdpfipsis25 lagnipadgdpfipsis26 lagnipadgdpfipsis27 lagnipadgdpfipsis28 lagnipadgdpfipsis29 lagnipadgdpfipsis30 lagnipadgdpfipsis31 lagnipadgdpfipsis32 lagnipadgdpfipsis33 lagnipadgdpfipsis34 lagnipadgdpfipsis35 lagnipadgdpfipsis36 lagnipadgdpfipsis37 lagnipadgdpfipsis38 lagnipadgdpfipsis39 lagnipadgdpfipsis40 lagnipadgdpfipsis41 lagnipadgdpfipsis42 lagnipadgdpfipsis43 lagnipadgdpfipsis44 lagnipadgdpfipsis45 lagnipadgdpfipsis46 lagnipadgdpfipsis47 lagnipadgdpfipsis48"; 
global lagtwo    "lag2nipadgdpfipsis1  lag2nipadgdpfipsis2  lag2nipadgdpfipsis3 lag2nipadgdpfipsis4 lag2nipadgdpfipsis5 lag2nipadgdpfipsis6 lag2nipadgdpfipsis7 lag2nipadgdpfipsis8 lag2nipadgdpfipsis9 lag2nipadgdpfipsis10 lag2nipadgdpfipsis11 lag2nipadgdpfipsis12 lag2nipadgdpfipsis13 lag2nipadgdpfipsis14 lag2nipadgdpfipsis15 lag2nipadgdpfipsis16 lag2nipadgdpfipsis17 lag2nipadgdpfipsis18 lag2nipadgdpfipsis19 lag2nipadgdpfipsis20 lag2nipadgdpfipsis21 lag2nipadgdpfipsis22 lag2nipadgdpfipsis23 lag2nipadgdpfipsis24 lag2nipadgdpfipsis25 lag2nipadgdpfipsis26 lag2nipadgdpfipsis27 lag2nipadgdpfipsis28 lag2nipadgdpfipsis29 lag2nipadgdpfipsis30 lag2nipadgdpfipsis31 lag2nipadgdpfipsis32 lag2nipadgdpfipsis33 lag2nipadgdpfipsis34 lag2nipadgdpfipsis35 lag2nipadgdpfipsis36 lag2nipadgdpfipsis37 lag2nipadgdpfipsis38 lag2nipadgdpfipsis39 lag2nipadgdpfipsis40 lag2nipadgdpfipsis41 lag2nipadgdpfipsis42 lag2nipadgdpfipsis43 lag2nipadgdpfipsis44 lag2nipadgdpfipsis45 lag2nipadgdpfipsis46 lag2nipadgdpfipsis47 lag2nipadgdpfipsis48 ";
global lagthree  "lag3nipadgdpfipsis1  lag3nipadgdpfipsis2  lag3nipadgdpfipsis3 lag3nipadgdpfipsis4 lag3nipadgdpfipsis5 lag3nipadgdpfipsis6 lag3nipadgdpfipsis7 lag3nipadgdpfipsis8 lag3nipadgdpfipsis9 lag3nipadgdpfipsis10 lag3nipadgdpfipsis11 lag3nipadgdpfipsis12 lag3nipadgdpfipsis13 lag3nipadgdpfipsis14 lag3nipadgdpfipsis15 lag3nipadgdpfipsis16 lag3nipadgdpfipsis17 lag3nipadgdpfipsis18 lag3nipadgdpfipsis19 lag3nipadgdpfipsis20 lag3nipadgdpfipsis21 lag3nipadgdpfipsis22 lag3nipadgdpfipsis23 lag3nipadgdpfipsis24 lag3nipadgdpfipsis25 lag3nipadgdpfipsis26 lag3nipadgdpfipsis27 lag3nipadgdpfipsis28 lag3nipadgdpfipsis29 lag3nipadgdpfipsis30 lag3nipadgdpfipsis31 lag3nipadgdpfipsis32 lag3nipadgdpfipsis33 lag3nipadgdpfipsis34 lag3nipadgdpfipsis35 lag3nipadgdpfipsis36 lag3nipadgdpfipsis37 lag3nipadgdpfipsis38 lag3nipadgdpfipsis39 lag3nipadgdpfipsis40 lag3nipadgdpfipsis41 lag3nipadgdpfipsis42 lag3nipadgdpfipsis43 lag3nipadgdpfipsis44 lag3nipadgdpfipsis45 lag3nipadgdpfipsis46 lag3nipadgdpfipsis47 lag3nipadgdpfipsis48 ";
global lead      "leadnipadgdpfipsis1  leadnipadgdpfipsis2  leadnipadgdpfipsis3 leadnipadgdpfipsis4 leadnipadgdpfipsis5 leadnipadgdpfipsis6 leadnipadgdpfipsis7 leadnipadgdpfipsis8 leadnipadgdpfipsis9 leadnipadgdpfipsis10 leadnipadgdpfipsis11 leadnipadgdpfipsis12 leadnipadgdpfipsis13 leadnipadgdpfipsis14 leadnipadgdpfipsis15 leadnipadgdpfipsis16 leadnipadgdpfipsis17 leadnipadgdpfipsis18 leadnipadgdpfipsis19 leadnipadgdpfipsis20 leadnipadgdpfipsis21 leadnipadgdpfipsis22 leadnipadgdpfipsis23 leadnipadgdpfipsis24 leadnipadgdpfipsis25 leadnipadgdpfipsis26 leadnipadgdpfipsis27 leadnipadgdpfipsis28 leadnipadgdpfipsis29 leadnipadgdpfipsis30 leadnipadgdpfipsis31 leadnipadgdpfipsis32 leadnipadgdpfipsis33 leadnipadgdpfipsis34 leadnipadgdpfipsis35 leadnipadgdpfipsis36 leadnipadgdpfipsis37 leadnipadgdpfipsis38 leadnipadgdpfipsis39 leadnipadgdpfipsis40 leadnipadgdpfipsis41 leadnipadgdpfipsis42 leadnipadgdpfipsis43 leadnipadgdpfipsis44 leadnipadgdpfipsis45 leadnipadgdpfipsis46 leadnipadgdpfipsis47 leadnipadgdpfipsis48 ";
global leadtwo   "lead2nipadgdpfipsis1  lead2nipadgdpfipsis2  lead2nipadgdpfipsis3 lead2nipadgdpfipsis4 lead2nipadgdpfipsis5 lead2nipadgdpfipsis6 lead2nipadgdpfipsis7 lead2nipadgdpfipsis8 lead2nipadgdpfipsis9 lead2nipadgdpfipsis10 lead2nipadgdpfipsis11 lead2nipadgdpfipsis12 lead2nipadgdpfipsis13 lead2nipadgdpfipsis14 lead2nipadgdpfipsis15 lead2nipadgdpfipsis16 lead2nipadgdpfipsis17 lead2nipadgdpfipsis18 lead2nipadgdpfipsis19 lead2nipadgdpfipsis20 lead2nipadgdpfipsis21 lead2nipadgdpfipsis22 lead2nipadgdpfipsis23 lead2nipadgdpfipsis24 lead2nipadgdpfipsis25 lead2nipadgdpfipsis26 lead2nipadgdpfipsis27 lead2nipadgdpfipsis28 lead2nipadgdpfipsis29 lead2nipadgdpfipsis30 lead2nipadgdpfipsis31 lead2nipadgdpfipsis32 lead2nipadgdpfipsis33 lead2nipadgdpfipsis34 lead2nipadgdpfipsis35 lead2nipadgdpfipsis36 lead2nipadgdpfipsis37 lead2nipadgdpfipsis38 lead2nipadgdpfipsis39 lead2nipadgdpfipsis40 lead2nipadgdpfipsis41 lead2nipadgdpfipsis42 lead2nipadgdpfipsis43 lead2nipadgdpfipsis44 lead2nipadgdpfipsis45 lead2nipadgdpfipsis46 lead2nipadgdpfipsis47 lead2nipadgdpfipsis48"; 
global leadthree "lead3nipadgdpfipsis1  lead3nipadgdpfipsis2  lead3nipadgdpfipsis3 lead3nipadgdpfipsis4 lead3nipadgdpfipsis5 lead3nipadgdpfipsis6 lead3nipadgdpfipsis7 lead3nipadgdpfipsis8 lead3nipadgdpfipsis9 lead3nipadgdpfipsis10 lead3nipadgdpfipsis11 lead3nipadgdpfipsis12 lead3nipadgdpfipsis13 lead3nipadgdpfipsis14 lead3nipadgdpfipsis15 lead3nipadgdpfipsis16 lead3nipadgdpfipsis17 lead3nipadgdpfipsis18 lead3nipadgdpfipsis19 lead3nipadgdpfipsis20 lead3nipadgdpfipsis21 lead3nipadgdpfipsis22 lead3nipadgdpfipsis23 lead3nipadgdpfipsis24 lead3nipadgdpfipsis25 lead3nipadgdpfipsis26 lead3nipadgdpfipsis27 lead3nipadgdpfipsis28 lead3nipadgdpfipsis29 lead3nipadgdpfipsis30 lead3nipadgdpfipsis31 lead3nipadgdpfipsis32 lead3nipadgdpfipsis33 lead3nipadgdpfipsis34 lead3nipadgdpfipsis35 lead3nipadgdpfipsis36 lead3nipadgdpfipsis37 lead3nipadgdpfipsis38 lead3nipadgdpfipsis39 lead3nipadgdpfipsis40 lead3nipadgdpfipsis41 lead3nipadgdpfipsis42 lead3nipadgdpfipsis43 lead3nipadgdpfipsis44 lead3nipadgdpfipsis45 lead3nipadgdpfipsis46 lead3nipadgdpfipsis47 lead3nipadgdpfipsis48"; 



*******ONE LAG;
quietly reg dgdp fipsis*  lagnipadgdpfipsis* nipadgdpfipsis* leadnipadgdpfipsis*  if dgdp!=. & dgdp!=0, nocons;

test "$lag";
test "$lead";
test "$lag" "$lead";


*******TWO LAGS;
quietly reg dgdp fipsis* lag2nipadgdpfipsis*  lagnipadgdpfipsis* nipadgdpfipsis* leadnipadgdpfipsis* lead2nipadgdpfipsis* if dgdp!=. & dgdp!=0, nocons;

test "$lag";
test "$lead";
test "$lag" "$lead";
test "$lagtwo";
test "$leadtwo";
test "$lagtwo" "$leadtwo";
test "$lag" "$lead" "$lagtwo" "$leadtwo";


*******THREE LAGS;
quietly reg dgdp fipsis* lag3nipadgdpfipsis* lag2nipadgdpfipsis*  lagnipadgdpfipsis* nipadgdpfipsis* leadnipadgdpfipsis* lead2nipadgdpfipsis* lead3nipadgdpfipsis* if dgdp!=. & dgdp!=0, nocons;

test "$lag";
test "$lead";
test "$lag" "$lead";
test "$lagtwo";
test "$leadtwo";
test "$lagtwo" "$leadtwo";
test "$lagthree";
test "$leadthree";
test "$lagthree" "$leadthree";
test "$lag" "$lead" "$lagtwo" "$leadtwo" "$lagthree" "$leadthree";



