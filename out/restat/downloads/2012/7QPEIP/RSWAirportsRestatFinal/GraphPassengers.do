
#delimit ;
clear all;
capture log close;
set mem 200m;
set matsize 800;
version 10;
set scheme s1mono;
set more off;

log using logs\GraphPassengers.log,replace;

***************************************************;
**** THIS FILE GENERATES FIGURE 1 IN THE PAPER ****;
***************************************************;

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

drop iata;

** Drop after 2002;

drop if year>2002;

** Drop East German airports;

drop if airport=="Dresden"|airport=="Erfurt"|airport=="Leipzig";

** Drop small West German airports;

drop if airport=="Dortmund"|airport=="Friedrichshafen"|airport=="Hahn"|airport=="Karlsruhe"
|airport=="Lübeck"|airport=="Münster"|airport=="Paderborn"|airport=="Saarbrücken";

so airport year;
sa temp\graphtimeseries.dta,replace;

** Insert year gap for second world war;

keep if year==1938;
replace depart=.;
replace arrival=.;
replace f_depart=.;
replace f_arrival=.;
replace year=1939;
so airport year;
sa temp\temp.dta,replace;
clear;
u temp\graphtimeseries.dta;
append using temp\temp.dta;
so airport year;

** Define periods;

gen period=1 if year<1950;
replace period=2 if year>=1950&year<=1989;
replace period=3 if year>=1990;

** Variables;

gen mda=min(depart,arrival);
gen fmda=min(f_depart,f_arrival);
gen sda=max(depart,arrival);

** Passenger totals;

egen temp=sum(depart) if airport~="Total",by(year);
egen sum_depart=max(temp),by(year);
so airport year;
drop temp;
gen temp=depart if airport=="Total";
egen tot_depart=max(temp),by(year);
so airport year;
drop temp;

egen temp=sum(arrival) if airport~="Total",by(year);
egen sum_arrival=max(temp),by(year);
so airport year;
drop temp;
gen temp=arrival if airport=="Total";
egen tot_arrival=max(temp),by(year);
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

** Freight Totals ;

egen temp=sum(f_depart) if airport~="Total",by(year);
egen sum_fdepart=max(temp),by(year);
so airport year;
drop temp;
gen temp=f_depart if airport=="Total";
egen tot_fdepart=max(temp),by(year);
so airport year;
drop temp;

egen temp=sum(f_arrival) if airport~="Total",by(year);
egen sum_farrival=max(temp),by(year);
so airport year;
drop temp;
gen temp=f_arrival if airport=="Total";
egen tot_farrival=max(temp),by(year);
so airport year;
drop temp;

egen temp=sum(fmda) if airport~="Total",by(year);
egen sum_fmda=max(temp),by(year);
so airport year;
drop temp;
gen temp=fmda if airport=="Total";
egen tot_fmda=max(temp),by(year);
so airport year;
drop temp;

** Schoenefeld is aggregation of Berlin and Schoenefeld;

gen temp=depart if airport=="Berlin";
egen berlin=max(temp),by(year);
so airport year;
replace depart=depart+berlin if airport=="Schoenefeld";
drop temp berlin;

gen temp=arrival if airport=="Berlin";
egen berlin=max(temp),by(year);
so airport year;
replace arrival=arrival+berlin if airport=="Schoenefeld";
drop temp berlin;

gen temp=f_depart if airport=="Berlin";
egen berlin=max(temp),by(year);
so airport year;
replace f_depart=f_depart+berlin if airport=="Schoenefeld";
drop temp berlin;

gen temp=f_arrival if airport=="Berlin";
egen berlin=max(temp),by(year);
so airport year;
replace f_arrival=f_arrival+berlin if airport=="Schoenefeld";
drop temp berlin;

gen temp=mda if airport=="Berlin";
egen berlin=max(temp),by(year);
so airport year;
replace mda=mda+berlin if airport=="Schoenefeld";
drop temp berlin;

gen temp=fmda if airport=="Berlin";
egen berlin=max(temp),by(year);
so airport year;
replace fmda=fmda+berlin if airport=="Schoenefeld";
drop temp berlin;

** Transform variables;

gen ds=(depart/sum_depart)*100;
*gen ds=(depart/tot_depart)*100;

gen ds_total=(sum_depart/tot_depart)*100;

gen as=(arrival/sum_arrival)*100;
*gen as=(arrival/tot_arrival)*100;

gen ms=(mda/sum_mda)*100;
*gen ms=(mda/tot_mda)*100;

gen fds=(f_depart/sum_fdepart)*100;
*gen fds=(f_depart/tot_fdepart)*100;

gen fas=(f_arrival/sum_farrival)*100;
*gen fas=(f_arrival/tot_farrival)*100;

gen fms=(fmda/sum_fmda)*100;
*gen fms=(fmda/tot_fmda)*100;

gen net=depart-arrival;
gen n=(depart-arrival)*100/sda;
     
********************;
** Refugees table **;
********************;

** Source: Senator fuer Sozialwesen, Berlin;
** (from the footnotes of the Statistical Yearbook of Germany);

gen refugees=. if airport=="Berlin"&year==1950;
replace refugees=. if airport=="Berlin"&year==1951;
replace refugees=. if airport=="Berlin"&year==1952;
replace refugees=257308 if airport=="Berlin"&year==1953;
replace refugees=73739 if airport=="Berlin"&year==1954;
replace refugees=102725 if airport=="Berlin"&year==1955;
replace refugees=109776 if airport=="Berlin"&year==1956;
replace refugees=85714 if airport=="Berlin"&year==1957;
replace refugees=94685 if airport=="Berlin"&year==1958;
replace refugees=72825 if airport=="Berlin"&year==1959;
replace refugees=121778 if airport=="Berlin"&year==1960;

gen refdep=refugees/depart;

gen decade=1 if year>=1950&year<=1959;
replace decade=2 if year>=1962&year<=1969;

egen temp1=mean(net) ,by(airport decade);
egen temp2=mean(n) ,by(airport decade);
egen temp3=mean(refugees) if year>=1954&year<=1960,by(airport);
egen temp4=mean(refdep) if year>=1954&year<=1960,by(airport);
so airport year;

format depart arrival net n %10.2f;
list airport year depart arrival refugees refdep if (airport=="Berlin"&year>=1950&year<=1970)
|(airport=="Hannover"&year>=1950&year<=1970)|(airport=="Total"&year>=1950&year<=1970);

* Net surplus in 1950s;
by airport: su temp1 if decade==1;
* Net surplus in 1950s as % of max(depart,arrive);
by airport: su temp2 if decade==1;
* Net surplus in 1960s;
by airport: su temp1 if decade==2;
* Mean refugees during 1954-60;
su temp3 temp4;
drop temp1 temp2 temp3 temp4 decade;

***********************************************;
**** Change in airport shares 1938 to 2002 ****; 
***********************************************;

egen temp=mean(ds) if year>=1929&year<=1938,by(airport);
egen ds1938=max(temp),by(airport);
so airport year;
drop temp;

egen temp=mean(ds) if year>=1993&year<=2002,by(airport);
egen ds2002=max(temp),by(airport);
so airport year;
drop temp;

egen temp=mean(fds) if year>=1929&year<=1938,by(airport);
egen fds1938=max(temp),by(airport);
so airport year;
drop temp;

egen temp=mean(fds) if year>=1993&year<=2002,by(airport);
egen fds2002=max(temp),by(airport);
so airport year;
drop temp;

gen ds_38_02=ds2002-ds1938;
gen fds_38_02=fds2002-fds1938;

gen ads_38_02=abs(ds_38_02);
gen afds_38_02=abs(fds_38_02);

gsort year -ads_38_02;
list airport year ds_38_02 if year==1938;
drop ads_38_02;

gsort year -afds_38_02;
list airport year fds_38_02 fds2002 fds1938 if year==1938;
drop afds_38_02;

** Reshape data for graphing;

keep airport year ds as ms fds fas fms n;
reshape wide ds as ms fds fas fms n, i(year) j(airport) string;
so year;
                                                                   
lab var year " ";

****************************************;
**** Graph all West German Airports ****;
****************************************;

* Graph for paper;

gen dsBerlinAll=dsBerlin;
replace dsBerlinAll=dsSchoenefeld if year>=1990;

twoway (scatter dsBerlinAll year, c(l) cmissing(n) clpattern(solid) msymbol(O)) 
(scatter dsFrankfurt year, c(l) cmissing(n) clpattern(solid) msymbol(T))
(scatter dsMunich year, c(l) cmissing(n) clpattern(solid) mlcolor(black) msymbol(smsquare_hollow))
(scatter dsDusseldorf year, c(l) cmissing(n) clpattern(solid) mlcolor(black) msymbol(X)) 
(scatter dsHamburg year, c(l) cmissing(n) clpattern(solid) mlcolor(black) msymbol(+)) 
(scatter dsCologne year, c(l) cmissing(n) clpattern (shortdash) mlcolor(black) msymbol(i)) 
(scatter dsBremen year, c(l) cmissing(n) clpattern(shortdash) msymbol(i)) 
(scatter dsHannover year, c(l) cmissing(n) clpattern(shortdash) msymbol(i)) 
(scatter dsNurenberg year, c(l) cmissing(n) clpattern(shortdash) msymbol(i)) 
(scatter dsStuttgart year, c(l) cmissing(n) clpattern(shortdash) msymbol(i)),
xline(1939 1949 1971 1990) xlabel(1925(10)2005)
legend(order(1 2 3 4 5 6) cols(3) lab(1 "Berlin") lab(2 "Frankfurt") lab(3 "Munich") 
lab(4 "Dusseldorf") lab(5 "Hamburg") lab(6 "Other Airports"))
ytitle("Passenger Share (%)",margin(medium)) 
note("Note: share of airports in departing passengers at the ten main German airports", size(vsmall))
ti("Figure 1: Airport Passenger Shares",margin(medium));

graph export graphs\Figure1.eps , as(eps) preview(off) replace;

* Graph for presentation;

****set scheme s1color;

****twoway (scatter dsBerlinAll year, c(l) cmissing(n) clpattern(solid) msymbol(O)) 
(scatter dsFrankfurt year, c(l) cmissing(n) clpattern(solid) msymbol(T))
(scatter dsHamburg year, c(l) cmissing(n) msymbol(i)) 
(scatter dsMunich year, c(l) cmissing(n) clcolor(black) msymbol(i))
(scatter dsCologne year, c(l) cmissing(n) msymbol(i)) 
(scatter dsDusseldorf year, c(l) cmissing(n) msymbol(i)) 
(scatter dsBremen year, c(l) cmissing(n) msymbol(i)) 
(scatter dsHannover year, c(l) cmissing(n) msymbol(i)) 
(scatter dsNurenberg year, c(l) cmissing(n) msymbol(i)) 
(scatter dsStuttgart year, c(l) cmissing(n) msymbol(i)),
xline(1939 1949 1971 1990, lcolor(black)) xlabel(1925(10)2005)
legend(cols(4) lab(1 "Berlin") lab(2 "Frankfurt") lab(3 "Hamburg") lab(4 "Munich")
lab(5 "Cologne") lab(6 "Dusseldorf") lab(7 "Bremen") lab(8 "Hannover") lab(9 "Nurenberg")
lab(10 "Stuttgart") size(small)) 
ytitle("Passenger Share (%)",margin(small) size(small)) 
note("Note: airport departing passengers as share of total departing passengers")
ti("Figure 1: Airport Passenger Shares",margin(small));

****graph export graphs\Figure1_present.eps , as(eps) preview(off) replace;

*****************;
**** Freight ****;
*****************;

gen fdsBerlinAll=fdsBerlin;
replace fdsBerlinAll=fdsSchoenefeld if year>=1990;

****twoway (scatter fdsBerlinAll year, c(l) cmissing(n) clpattern(solid) msymbol(O)) 
(scatter fdsFrankfurt year, c(l) cmissing(n) clpattern(solid) msymbol(T))
(scatter fdsHamburg year, c(l) cmissing(n) msymbol(i)) 
(scatter fdsMunich year, c(l) cmissing(n) clcolor(black) msymbol(i))
(scatter fdsCologne year, c(l) cmissing(n) msymbol(i)) 
(scatter fdsDusseldorf year, c(l) cmissing(n) msymbol(i)) 
(scatter fdsBremen year, c(l) cmissing(n) msymbol(i)) 
(scatter fdsHannover year, c(l) cmissing(n) msymbol(i)) 
(scatter fdsNurenberg year, c(l) cmissing(n) msymbol(i)) 
(scatter fdsStuttgart year, c(l) cmissing(n) msymbol(i)),
xline(1939 1949 1971 1990, lcolor(black)) xlabel(1925(10)2005)
legend(cols(4) lab(1 "Berlin") lab(2 "Frankfurt") lab(3 "Hamburg") lab(4 "Munich")
lab(5 "Cologne") lab(6 "Dusseldorf") lab(7 "Bremen") lab(8 "Hannover") lab(9 "Nurenberg")
lab(10 "Stuttgart")) 
ytitle("Passenger Share (%)",margin(medlarge)) 
note("Note: airport departing freight as share of total departing freight")
ti("Airport Freight Shares",margin(medium));

log close;
