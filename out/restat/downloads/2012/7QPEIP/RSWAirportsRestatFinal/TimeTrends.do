
#delimit ;
clear all;
capture log close;
set mem 200m;
set matsize 800;
version 10;
set scheme s1mono;
set more off;

log using logs\TimeTrends.log,replace;

************************************************************************;
**** THIS FILE GENERATES THE RESULTS IN TABLES 1 AND 2 IN THE PAPER ****;
************************************************************************;

**********************************;
**** Read in Time Series Data ****;
**********************************;

use data\airports-time-series-final.dta;
so airport year;

***********************;
**** Clean Up Data ****;
***********************;

** Names;

replace airport="Schoenefeld" if airport=="Berlin-Schönefeld";
replace airport="Dusseldorf"  if airport=="Düsseldorf";
replace airport="Cologne"     if airport=="Köln";
replace airport="Munich"      if airport=="München";
replace airport="Nurenberg"   if airport=="Nürnberg";

** Aggregate Berlin and Schoenefeld post 1990;

gen temp=depart if airport=="Schoenefeld";
egen Schoenefeld=max(temp),by(year);
so airport year;
replace depart=depart+Schoenefeld if airport=="Berlin"&year>=1990;
drop temp Schoenefeld;

gen temp=arrival if airport=="Schoenefeld";
egen Schoenefeld=max(temp),by(year);
so airport year;
replace arrival=arrival+Schoenefeld if airport=="Berlin"&year>=1990;
drop temp Schoenefeld;

gen temp=f_depart if airport=="Schoenefeld";
egen Schoenefeld=max(temp),by(year);
so airport year;
replace f_depart=f_depart+Schoenefeld if airport=="Berlin"&year>=1990;
drop temp Schoenefeld;

gen temp=f_arrival if airport=="Schoenefeld";
egen Schoenefeld=max(temp),by(year);
so airport year;
replace f_arrival=f_arrival+Schoenefeld if airport=="Berlin"&year>=1990;
drop temp Schoenefeld;

*** Drop after 2002;

drop if year>2002;

** Drop Schoenefeld;

drop if airport=="Schoenefeld";

** Drop East German airports;

drop if airport=="Dresden"|airport=="Erfurt"|airport=="Leipzig";

** Drop small West German airports;

drop if airport=="Dortmund"|airport=="Friedrichshafen"|airport=="Hahn"|airport=="Karlsruhe"
|airport=="Lübeck"|airport=="Münster"|airport=="Paderborn"|airport=="Saarbrücken";

** Variables;

gen mda=min(depart,arrival);

egen temp=sum(depart) if airport~="Total",by(year);
egen sum_depart=max(temp),by(year);
so airport year;
drop temp;

gen temp=depart if airport=="Total";
egen tot_depart=max(temp),by(year);
so airport year;
drop temp;

egen temp=sum(mda) if airport~="Total",by(year);
egen sum_mda=max(temp),by(year);
so airport year;
drop temp;

gen temp=mda if airport=="Total";
egen tot_mda=max(temp),by(year);
so airport year;
drop temp;

drop if airport=="Total";

**************************************;
**** Prepare data for regressions ****;
**************************************;

gen pshare=(depart/sum_depart)*100;

gen era=1 if year>=1927&year<=1938;
replace era=2 if year>=1950&year<=1989;
replace era=3 if year>=1990;

gen decade=1 if year>=1927&year<=1938;
replace decade=2 if year>=1950&year<=1959;
replace decade=3 if year>=1960&year<=1969;
replace decade=4 if year>=1970&year<=1979;
replace decade=5 if year>=1980&year<=1989;
replace decade=6 if year>=1990;

tab year, gen(yy);
tab era, gen(ee);

encode airport,gen(nair);

gen fairera=(era*100)+nair;
tab fairera,gen(fe);
gen nairera=(nair*100)+era;

gen fairdec=(decade*100)+nair;
tab fairdec,gen(ffe);
gen nairdec=(nair*100)+decade;

gen ldepart=ln(depart);

****************************;
**** Create time trends ****;
****************************;

* Period time trends;

gen time27=0;
gen time50=0;
gen time90=0;

replace time27=year-1926 if year>=1927&year<=1938;
replace time50=year-1949 if year>=1950&year<=1989;
replace time90=year-1989 if year>=1990;

* Decade time trends;

gen dec50=0;
gen dec60=0;
gen dec70=0;
gen dec80=0;

replace dec50=year-1949 if year>=1950&year<=1959;
replace dec60=year-1959 if year>=1960&year<=1969;
replace dec70=year-1969 if year>=1970&year<=1979;
replace dec80=year-1979 if year>=1980&year<=1989;

* Airport time trends;

local x=1;

while `x'<=10 {;

gen time27_`x'=0;
gen time50_`x'=0;
gen time90_`x'=0;

gen dec50_`x'=0;
gen dec60_`x'=0;
gen dec70_`x'=0;
gen dec80_`x'=0;

replace time27_`x'=time27 if nair==`x';
replace time50_`x'=time50 if nair==`x';
replace time90_`x'=time90 if nair==`x';

replace dec50_`x'=dec50 if nair==`x';
replace dec60_`x'=dec60 if nair==`x';
replace dec70_`x'=dec70 if nair==`x';
replace dec80_`x'=dec80 if nair==`x';

local x = `x' + 1;

};

***********************************************;
**** Non-parametric time trends            ****;
**** Results in Columns (1)-(3) of Table 1 ****;
***********************************************;

areg pshare time27_* time50_* time90_*, abs(nairera) robust;

*outreg time27_* using tables\timetrend27.out , se coefastr 10pct sigsymb(***,**,*) 
bdec(3) title(Table 1: Time Trends 27) replace;
*outreg time50_* using tables\timetrend50.out , se coefastr 10pct sigsymb(***,**,*) 
bdec(3) title(Table 1: Time Trends 50) replace;
*outreg time90_* using tables\timetrend90.out , se coefastr 10pct sigsymb(***,**,*) 
bdec(3) title(Table 1: Time Trends 90) replace;

predict nonpara, xbd;

* Size of division treatment;

gen div_trend    =_b[time27_1] -_b[time50_1]  if nair==1;
replace div_trend=_b[time27_2] -_b[time50_2]  if nair==2;
replace div_trend=_b[time27_3] -_b[time50_3]  if nair==3;
replace div_trend=_b[time27_4] -_b[time50_4]  if nair==4;
replace div_trend=_b[time27_5] -_b[time50_5]  if nair==5;
replace div_trend=_b[time27_6] -_b[time50_6]  if nair==6;
replace div_trend=_b[time27_7] -_b[time50_7]  if nair==7;
replace div_trend=_b[time27_8] -_b[time50_8]  if nair==8;
replace div_trend=_b[time27_9] -_b[time50_9]  if nair==9;
replace div_trend=_b[time27_10]-_b[time50_10] if nair==10;

replace div_trend=abs(div_trend);

gsort year -div_trend;
list airport div_trend if year==1938;
sort airport year;

* Size of reunification treatment;

gen ren_trend    =_b[time50_1] -_b[time90_1]  if nair==1;
replace ren_trend=_b[time50_2] -_b[time90_2]  if nair==2;
replace ren_trend=_b[time50_3] -_b[time90_3]  if nair==3;
replace ren_trend=_b[time50_4] -_b[time90_4]  if nair==4;
replace ren_trend=_b[time50_5] -_b[time90_5]  if nair==5;
replace ren_trend=_b[time50_6] -_b[time90_6]  if nair==6;
replace ren_trend=_b[time50_7] -_b[time90_7]  if nair==7;
replace ren_trend=_b[time50_8] -_b[time90_8]  if nair==8;
replace ren_trend=_b[time50_9] -_b[time90_9]  if nair==9;
replace ren_trend=_b[time50_10]-_b[time90_10] if nair==10;

replace ren_trend=abs(ren_trend);

gsort year -ren_trend;
list airport ren_trend if year==1938;
sort airport year;

************************************;
**** Results in Table 2 Panel A ****;
************************************;

* Before-after tests;

* Berlin;
lincom time27_1-time50_1;

* Frankfurt;
lincom time27_5-time50_5;

* Within era tests;

lincom time27_1-time27_5;
lincom time50_1-time50_5;

* Diff in Diffs;

* Division;
lincom time27_1-time50_1-time27_5+time50_5;

* Graph fitted values;

****twoway scatter nonpara year , cmissing(n) by(airport);

*******************************************;
**** Non-parametric decade time trends ****;
**** Results in Column (4) of Table 1  ****;
*******************************************;

areg pshare time27_* dec50_* dec60_* dec70_* dec80_* time90_* , abs(nairdec) robust;

*outreg dec80_* using tables\timetrend80.out , se coefastr 10pct sigsymb(***,**,*) 
bdec(3) title(Table 1: Time Trends 80) replace;

predict nonparadec,xbd;

* Size of 1980s treatment;

gen r80_trend    =_b[dec80_1] -_b[time90_1]  if nair==1;
replace r80_trend=_b[dec80_2] -_b[time90_2]  if nair==2;
replace r80_trend=_b[dec80_3] -_b[time90_3]  if nair==3;
replace r80_trend=_b[dec80_4] -_b[time90_4]  if nair==4;
replace r80_trend=_b[dec80_5] -_b[time90_5]  if nair==5;
replace r80_trend=_b[dec80_6] -_b[time90_6]  if nair==6;
replace r80_trend=_b[dec80_7] -_b[time90_7]  if nair==7;
replace r80_trend=_b[dec80_8] -_b[time90_8]  if nair==8;
replace r80_trend=_b[dec80_9] -_b[time90_9]  if nair==9;
replace r80_trend=_b[dec80_10]-_b[time90_10] if nair==10;

replace r80_trend=abs(r80_trend);

gsort year -r80_trend;
list airport r80_trend if year==1938;
sort airport year;

************************************;
**** Results in Table 2 Panel B ****;
************************************;

* Before-after tests;

* Berlin;
lincom dec80_1-time90_1;
* Frankfurt;
lincom dec80_5-time90_5;

* Within era tests;

lincom dec80_1-dec80_5;
lincom time90_1-time90_5;

* Diff in Diffs;

lincom dec80_1-time90_1-dec80_5+time90_5;

* Graph fitted values;

****twoway scatter nonparadec year , cmissing(n) by(airport);

**************************************;
**** Non-parametric fixed effects ****;
**************************************;

reg pshare fe* , noconstant robust;

*outreg fe1-fe10 using tables\fe27.out , se coefastr 10pct sigsymb(***,**,*) 
bdec(3) title(Table 1: Intercepts 27) replace;
*outreg fe11-fe20 using tables\fe50.out , se coefastr 10pct sigsymb(***,**,*) 
bdec(3) title(Table 1: Intercepts 50) replace;
*outreg fe21-fe30 using tables\fe90.out , se coefastr 10pct sigsymb(***,**,*) 
bdec(3) title(Table 1: Intercepts 90) replace;

* Size of division treatment;

gen div_inter    =_b[fe1] -_b[fe11]  if nair==1;
replace div_inter=_b[fe2] -_b[fe12]  if nair==2;
replace div_inter=_b[fe3] -_b[fe13]  if nair==3;
replace div_inter=_b[fe4] -_b[fe14]  if nair==4;
replace div_inter=_b[fe5] -_b[fe15]  if nair==5;
replace div_inter=_b[fe6] -_b[fe16]  if nair==6;
replace div_inter=_b[fe7] -_b[fe17]  if nair==7;
replace div_inter=_b[fe8] -_b[fe18]  if nair==8;
replace div_inter=_b[fe9] -_b[fe19]  if nair==9;
replace div_inter=_b[fe10]-_b[fe20] if nair==10;

replace div_inter=abs(div_inter);

gsort year -div_inter;
list airport div_inter if year==1938;
sort airport year;

* Size of reunification treatment;

gen ren_inter    =_b[fe11] -_b[fe21]  if nair==1;
replace ren_inter=_b[fe12] -_b[fe22]  if nair==2;
replace ren_inter=_b[fe13] -_b[fe23]  if nair==3;
replace ren_inter=_b[fe14] -_b[fe24]  if nair==4;
replace ren_inter=_b[fe15] -_b[fe25]  if nair==5;
replace ren_inter=_b[fe16] -_b[fe26]  if nair==6;
replace ren_inter=_b[fe17] -_b[fe27]  if nair==7;
replace ren_inter=_b[fe18] -_b[fe28]  if nair==8;
replace ren_inter=_b[fe19] -_b[fe29]  if nair==9;
replace ren_inter=_b[fe20]-_b[fe30] if nair==10;

replace ren_inter=abs(ren_inter);

gsort year -ren_inter;
list airport ren_inter if year==1938;
sort airport year;

* Before-after tests;

lincom fe1-fe11;
lincom fe5-fe15;

lincom fe11-fe21;
lincom fe15-fe25;

* Within era tests;

lincom fe1-fe5;
lincom fe11-fe15;
lincom fe21-fe25;

* Difference in Differences;

lincom fe1-fe11-fe5+fe15;
lincom fe11-fe21-fe15+fe25;

*********************************************;
**** Non-parametric decade fixed effects ****;
*********************************************;

reg pshare fe1-fe10 fe21-fe30 ffe11-ffe50 , noconstant robust;

*outreg ffe41-ffe50 using tables\fe80.out , se coefastr 10pct sigsymb(***,**,*) 
bdec(3) title(Table 1: Intercepts 80) replace;

* Size of 1980s treatment;

gen r80_inter    =_b[ffe41] -_b[fe21]  if nair==1;
replace r80_inter=_b[ffe42] -_b[fe22]  if nair==2;
replace r80_inter=_b[ffe43] -_b[fe23]  if nair==3;
replace r80_inter=_b[ffe44] -_b[fe24]  if nair==4;
replace r80_inter=_b[ffe45] -_b[fe25]  if nair==5;
replace r80_inter=_b[ffe46] -_b[fe26]  if nair==6;
replace r80_inter=_b[ffe47] -_b[fe27]  if nair==7;
replace r80_inter=_b[ffe48] -_b[fe28]  if nair==8;
replace r80_inter=_b[ffe49] -_b[fe29]  if nair==9;
replace r80_inter=_b[ffe50] -_b[fe30] if nair==10;

replace r80_inter=abs(r80_inter);

gsort year -r80_inter;
list airport r80_inter if year==1938;
sort airport year;

* Before-after tests;

lincom ffe41-fe21;
lincom ffe45-fe25;

* Within era tests;

lincom ffe41-ffe45;
lincom fe21-fe25;

* Difference in Differences;

lincom ffe41-fe21-ffe45+fe25;

log close;



