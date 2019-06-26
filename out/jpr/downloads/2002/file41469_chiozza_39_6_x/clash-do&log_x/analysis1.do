#delimit ;
clear;
set mem 32m;
set more off;

use "C:\My Documents\ps299\paper4\data\samplefin.dta";


log using "C:\My Documents\ps299\paper4\log\analysis1.log", replace;
#delimit ;
* table 2 model 1;
relogit kosimo intcivdy postcold diffbloc border mindem mod peaceyrs _spline1 
        _spline2 _spline3 dymilbal majpow distance, wc(.0079) cluster(dyad);


* table 2 model 2;
relogit kosimo intcivdy postcold diffbloc border mindem mod postciv blocciv
        bordeciv demciv modciv peaceyrs _spline1 _spline2 _spline3 dymilbal 
        majpow distance, wc(.0079) cluster(dyad);


* table 3;
lincom postcold+postciv;
lincom diffbloc+blocciv;
lincom border+bordeciv;
lincom mindem+demciv;
lincom mod+modciv;

lincom border+bordeciv+intcivdy;


* table 4;
* alpha: same-civilization, Cold War period, same bloc, no border;
setx mean;
setx intcivdy min 
     postcold min postciv min 
     diffbloc min blocciv min
     border min bordeciv min 
     mindem 10 demciv min
     mod mean modciv 0
     dymilbal mean 
     majpow 1 
     distance mean
     peaceyrs 18 _spline1 -3700.529 _spline2 -3887 _spline3 -2630.118;
relogitq, listx;

* beta: same-civilization, Cold War period, different bloc, no border;
setx diffbloc max;
relogitq, listx;

* gamma: same-civilization, Post-Cold War period, no border;
setx diffbloc min
     postcold max;
relogitq, listx;

* delta: different-civilization, Cold War period, same bloc, no border;
setx intcivdy max
     postcold min postciv min
     diffbloc min blocciv min   
     bordeciv min 
     demciv 10 
     modciv .3105353;
relogitq, listx;

* epsilon: different-civilization, Cold War period, different bloc, no border;
setx diffbloc max blocciv max;
relogitq, listx;

* zeta: different-civilization, Post-Cold War period, no border;
setx diffbloc min blocciv min
     postcold max postciv max;
relogitq, listx;


* eta: same-civilization, Cold War period, same bloc, with border;
setx intcivdy min 
     postcold min postciv min 
     diffbloc min blocciv min
     border max bordeciv min 
     mindem 10 demciv min
     mod mean modciv 0
     dymilbal mean 
     majpow 1 
     distance mean
     peaceyrs 18 _spline1 -3700.529 _spline2 -3887 _spline3 -2630.118;
relogitq, listx;

* theta: same-civilization, Cold War period, different bloc, with border;
setx diffbloc max;
relogitq, listx;

* iota: same-civilization, Post-Cold War period, with border;
setx diffbloc min
     postcold max;
relogitq, listx;

* kappa: different-civilization, Cold War period, same bloc, with border;
setx intcivdy max
     postcold min postciv min
     diffbloc min blocciv min   
     bordeciv max 
     demciv 10 
     modciv .3105353;
relogitq, listx;

* lambda: different-civilization, Cold War period, different bloc, with border;
setx diffbloc max blocciv max;
relogitq, listx;

* mu: different-civilization, Post-Cold War period, with border;
setx diffbloc min blocciv min
     postcold max postciv max;
relogitq, listx;


* figure 1;
* democracy graph;

#delimit ;
gen prdem=.;
gen demaxis=_n-1 in 1/21;

setx intcivdy min 
     postcold max postciv min 
     diffbloc min blocciv min 
     border max bordeciv min 
     demciv 0
     mod mean modciv 0
     dymilbal mean 
     majpow 1 
     distance mean 
     peaceyrs 18 _spline1 -3700.529 _spline2 -3887 _spline3 -2630.118;
#delimit cr
local a = 0
while `a' <=20 {
      setx mindem `a'
      relogitq, listx
      replace prdem  = r(Pr)  if demaxis==`a'
      local a = `a' + 1
      }

#delimit ; 

gen prdemciv=.;

setx mean;
setx intcivdy max 
     postcold max postciv max 
     diffbloc min blocciv min 
     border max bordeciv max 
     mod mean modciv .3105353
     dymilbal mean 
     majpow 1 
     distance mean 
     peaceyrs 18 _spline1 -3700.529 _spline2 -3887 _spline3 -2630.118;
#delimit cr
local b = 0
while `b' <=20 {
      setx mindem `b' demciv `b'
      relogitq, listx
      replace prdemciv  = r(Pr)  if demaxis==`b'
      local b = `b' + 1
      }

#delimit ;
replace prdem=prdem*100;
replace prdemciv=prdemciv*100;

sort demaxis;
graph prdem prdemciv demaxis, connect(ll) s(ST) xlabel(0,2,4,6,8,10,12,14,16,18,20)
      ylabel(0,1,2,3,4,5) l1title("Pr(Conflict)") title("                   Regime Type") 
      b2title(" ") l2title(" ") 
      saving("C:\My Documents\ps299\paper4\paper\figure1.gph", replace);


* figure 2;
* modernization graph;

#delimit ;
gen pr=.;
gen modaxis=(_n/100)*5+.1 in 1/8;

setx intcivdy min 
     postcold max postciv min 
     diffbloc min blocciv min 
     border max bordeciv min 
     mindem 10 demciv min 
     modciv 0
     dymilbal mean 
     majpow 1 
     distance mean 
     peaceyrs 18 _spline1 -3700.529 _spline2 -3887 _spline3 -2630.118;
#delimit cr
local c = .15
while `c' <=.5 {
      setx mod `c'
      relogitq, listx
      replace pr  = r(Pr)  if modaxis==float(`c')
      local c = `c' + .05
      }

#delimit ; 

gen pr1=.;

setx mean;
setx intcivdy max 
     postcold max postciv max 
     diffbloc min blocciv min 
     border max bordeciv max 
     mindem 10 demciv 10 
     dymilbal mean 
     majpow 1 
     distance mean 
     peaceyrs 18 _spline1 -3700.529 _spline2 -3887 _spline3 -2630.118;
#delimit cr
local d = .15
while `d' <=.5 {
      setx mod `d' modciv `d'
      relogitq, listx
      replace pr1  = r(Pr)  if modaxis==float(`d')
      local d = `d' + .05
      }

#delimit ;

replace pr=pr*100;
replace pr1=pr1*100;
#delimit ;
sort modaxis;
graph pr pr1 modaxis, connect(ll) s(ST) xlabel(.15,.20,.25,.30,.35,.40,.45,.50) 
      ylabel 
      l1title("Pr(Conflict)") title("              Level of Modernization") b2title(" ") 
      l2title(" ") saving("C:\My Documents\ps299\paper4\paper\figure2.gph", replace);


log close;

#delimit ;
log using "C:\My Documents\ps299\paper4\log\priorcorr.log", replace;
* table 12;
* prior correction;

relogit kosimo intcivdy postcold diffbloc border mindem mod peaceyrs _spline1 
        _spline2 _spline3 dymilbal majpow distance, pc(.0079) cluster(dyad);


relogit kosimo intcivdy postcold diffbloc border mindem mod postciv blocciv
        bordeciv demciv modciv peaceyrs _spline1 _spline2 _spline3 dymilbal 
        majpow distance, pc(.0079) cluster(dyad);


lincom postcold+postciv;
lincom diffbloc+blocciv;
lincom border+bordeciv;
lincom mindem+demciv;
lincom mod+modciv;

log close;

#delimit ;
* Modernization checks;

log using "C:\My Documents\ps299\paper4\log\moderchecks.log", replace;

* table 10;

#delimit ;
* log of energy consumption per capita;
relogit kosimo intcivdy postcold diffbloc border mindem logen postciv blocciv
        bordeciv demciv civen peaceyrs _spline1 _spline2 _spline3 dymilbal 
        majpow distance, wc(.0079) cluster(dyad);


#delimit ;
gen pren=.;
gen enaxis=_n+4 in 1/6;

setx intcivdy min 
     postcold max postciv min 
     diffbloc min blocciv min 
     border max bordeciv min 
     mindem 10 demciv min 
     civen 0
     dymilbal mean 
     majpow 1 
     distance mean 
     peaceyrs 18 _spline1 -3700.529 _spline2 -3887 _spline3 -2630.118;
#delimit cr
local e = 5
while `e' <=10 {
      setx logen `e'
      relogitq, listx
      replace pren  = r(Pr)  if enaxis==float(`e')
      local e = `e' + 1
      }

#delimit ; 

gen pren1=.;

setx mean;
setx intcivdy max 
     postcold max postciv max 
     diffbloc min blocciv min 
     border max bordeciv max 
     mindem 10 demciv 10 
     dymilbal mean 
     majpow 1 
     distance mean 
     peaceyrs 18 _spline1 -3700.529 _spline2 -3887 _spline3 -2630.118;
#delimit cr
local f = 5
while `f' <=10 {
      setx logen `f' civen `f'
      relogitq, listx
      replace pren1  = r(Pr)  if enaxis==float(`f')
      local f = `f' + 1
      }

#delimit ;

replace pren=pren*100;
replace pren1=pren1*100;
#delimit ;
sort enaxis;
graph pren pren1 enaxis, connect(ll) s(ST) xlabel(5,6,7,8,9,10) ylabel 
      l1title("Pr(Conflict)") title("              Energy Consumption") 
      b2title(" ") l2title(" ") t1(" ") 
      saving("C:\My Documents\ps299\paper4\paper\figure3a.gph", replace);


***
#delimit ;
* urbanization;
relogit kosimo intcivdy postcold diffbloc border mindem urb postciv blocciv
        bordeciv demciv civurb peaceyrs _spline1 _spline2 _spline3 dymilbal 
        majpow distance, wc(.0079) cluster(dyad);


#delimit ;
gen prur=.;
gen urbaxis=(_n-1)*5 in 1/12;

setx intcivdy min 
     postcold max postciv min 
     diffbloc min blocciv min 
     border max bordeciv min 
     mindem 10 demciv min 
     civurb 0
     dymilbal mean 
     majpow 1 
     distance mean 
     peaceyrs 18 _spline1 -3700.529 _spline2 -3887 _spline3 -2630.118;
#delimit cr
local g = 0
while `g' <=55 {
      setx urb `g'
      relogitq, listx
      replace prur  = r(Pr)  if urbaxis==float(`g')
      local g = `g' + 5
      }

#delimit ; 

gen prur1=.;

setx mean;
setx intcivdy max 
     postcold max postciv max 
     diffbloc min blocciv min 
     border max bordeciv max 
     mindem 10 demciv 10 
     dymilbal mean 
     majpow 1 
     distance mean 
     peaceyrs 18 _spline1 -3700.529 _spline2 -3887 _spline3 -2630.118;
#delimit cr
local h = 0
while `h' <=55 {
      setx urb `h' civurb `h'
      relogitq, listx
      replace prur1  = r(Pr)  if urbaxis==float(`h')
      local h = `h' + 5
      }

#delimit ;

replace prur=prur*100;
replace prur1=prur1*100;
#delimit ;
sort urbaxis;
graph prur prur1 urbaxis, connect(ll) s(ST) xlabel(0,10,20,30,40,50) ylabel 
      l1title("Pr(Conflict)") title("           Urbanization") 
      b2title(" ") l2title(" ") t1(" ") 
      saving("C:\My Documents\ps299\paper4\paper\figure3b.gph", replace);



***
#delimit ;
* education;
relogit kosimo intcivdy postcold diffbloc border mindem peduc postciv blocciv
        bordeciv demciv civeduc peaceyrs _spline1 _spline2 _spline3 dymilbal 
        majpow distance, wc(.0079) cluster(dyad);


#delimit ;
gen pred=.;
gen edaxis=_n*2 in 1/8;

setx intcivdy min 
     postcold max postciv min 
     diffbloc min blocciv min 
     border max bordeciv min 
     mindem 10 demciv min 
     civeduc 0
     dymilbal mean 
     majpow 1 
     distance mean 
     peaceyrs 18 _spline1 -3700.529 _spline2 -3887 _spline3 -2630.118;
#delimit cr
local i = 2
while `i' <=16 {
      setx peduc `i'
      relogitq, listx
      replace pred  = r(Pr)  if edaxis==float(`i')
      local i = `i' + 2
      }

#delimit ; 

gen pred1=.;

setx mean;
setx intcivdy max 
     postcold max postciv max 
     diffbloc min blocciv min 
     border max bordeciv max 
     mindem 10 demciv 10 
     dymilbal mean 
     majpow 1 
     distance mean 
     peaceyrs 18 _spline1 -3700.529 _spline2 -3887 _spline3 -2630.118;
#delimit cr
local l = 2
while `l' <=16 {
      setx peduc `l' civeduc `l'
      relogitq, listx
      replace pred1  = r(Pr)  if edaxis==float(`l')
      local l = `l' + 2
      }

#delimit ;

replace pred=pred*100;
replace pred1=pred1*100;
#delimit ;
sort edaxis;
graph pred pred1 edaxis, connect(ll) s(ST) xlabel(2,4,6,8,10,12,14,16) ylabel 
      l1title("Pr(Conflict)") title("           Education") 
      b2title(" ") l2title(" ") t1(" ") 
      saving("C:\My Documents\ps299\paper4\paper\figure3c.gph", replace);


***
#delimit ;
* radio;
relogit kosimo intcivdy postcold diffbloc border mindem radio postciv blocciv
        bordeciv demciv civradio peaceyrs _spline1 _spline2 _spline3 dymilbal 
        majpow distance, wc(.0079) cluster(dyad);


#delimit ;
gen prrd=.;
gen rdaxis=(_n-1)*500+50 in 1/10;

setx intcivdy min 
     postcold max postciv min 
     diffbloc min blocciv min 
     border max bordeciv min 
     mindem 10 demciv min 
     civradio 0
     dymilbal mean 
     majpow 1 
     distance mean 
     peaceyrs 18 _spline1 -3700.529 _spline2 -3887 _spline3 -2630.118;
#delimit cr
local m = 50
while `m' <=4550 {
      setx radio `m'
      relogitq, listx
      replace prrd  = r(Pr)  if rdaxis==float(`m')
      local m = `m' + 500
      }

#delimit ; 

gen prrd1=.;

setx mean;
setx intcivdy max 
     postcold max postciv max 
     diffbloc min blocciv min 
     border max bordeciv max 
     mindem 10 demciv 10 
     dymilbal mean 
     majpow 1 
     distance mean 
     peaceyrs 18 _spline1 -3700.529 _spline2 -3887 _spline3 -2630.118;
#delimit cr
local n = 50
while `n' <=4550 {
      setx radio `n' civradio `n'
      relogitq, listx
      replace prrd1  = r(Pr)  if rdaxis==float(`n')
      local n = `n' + 500
      }

#delimit ;

replace prrd=prrd*100;
replace prrd1=prrd1*100;
#delimit ;
sort rdaxis;
graph prrd prrd1 rdaxis, connect(ll) s(ST) xlabel(50,1050,2050,3050,4050) ylabel 
      l1title("Pr(Conflict)") title("           Radios") 
      b2title(" ") l2title(" ") t1(" ") 
      saving("C:\My Documents\ps299\paper4\paper\figure3d.gph", replace);



#delimit ;
graph using "C:\My Documents\ps299\paper4\paper\figure3a.gph" 
            "C:\My Documents\ps299\paper4\paper\figure3b.gph"
            "C:\My Documents\ps299\paper4\paper\figure3c.gph"
            "C:\My Documents\ps299\paper4\paper\figure3d.gph",
            margin(5)
            saving("C:\My Documents\ps299\paper4\paper\figure3.gph", replace);


#delimit ;

* table 11;
* Modernization checks: "strong link" assumption;

relogit kosimo intcivdy postcold diffbloc border mindem hmod postciv blocciv
        bordeciv demciv hmodciv peaceyrs _spline1 _spline2 _spline3 dymilbal 
        majpow distance, wc(.0079) cluster(dyad);

log close;





#delimit ;
log using "C:\My Documents\ps299\paper4\log\checks.log", replace;


* specification checks;

* table 5;
#delimit ;
* kosimo data excluding latent crises;
relogit crisis intcivdy postcold diffbloc border mindem mod postciv blocciv
        bordeciv demciv modciv crisisyrs crisisyrs1 crisisyrs2 crisisyrs3 dymilbal 
        majpow distance, wc(.0031) cluster(dyad);


log close;


#delimit ;
clear;
set mem 32m;
set more off;

use "C:\My Documents\ps299\paper4\data\icbfin.dta";

log using "C:\My Documents\ps299\paper4\log\checks.log", append;

* icb model;

relogit icb intcivdy postcold diffbloc border mindem mod postciv blocciv
        bordeciv demciv modciv icbyrs icbyrs1 icbyrs2 icbyrs3 dymilbal 
        majpow distance, wc(.0013) cluster(dyad);


log close;


#delimit ;
clear;
set mem 32m;
set more off;

use "C:\My Documents\ps299\paper4\data\midfin.dta";


log using "C:\My Documents\ps299\paper4\log\checks.log", append;

* mid model;

relogit mid intcivdy postcold diffbloc border mindem mod postciv blocciv
        bordeciv demciv modciv midyrs midyrs1 midyrs2 midyrs3 dymilbal 
        majpow distance, wc(.0056) cluster(dyad);

log close;


#delimit ;
clear;
set mem 32m;
set more off;

use "C:\My Documents\ps299\paper4\data\samplefin.dta";


log using "C:\My Documents\ps299\paper4\log\rmod.log", replace;

gen rpostciv=postcold*rintcivdy;
gen rblocciv=diffbloc*rintcivdy;
gen rbordeciv=border*rintcivdy;
gen rdemciv=mindem*rintcivdy;
gen rmodciv=mod*rintcivdy;


* table 8;

tab intcivdy rintcivdy;


* table 9;
relogit kosimo rintcivdy postcold diffbloc border mindem mod rpostciv rblocciv
        rbordeciv rdemciv rmodciv peaceyrs _spline1 _spline2 _spline3 dymilbal 
        majpow distance, wc(.0079) cluster(dyad);

log close;


#delimit ;
clear;
set mem 32m;
set more off;

use "C:\My Documents\ps299\paper4\data\confdyads.dta";

* table 6 and table 7;

#delimit ;
log using "C:\My Documents\ps299\paper4\log\depvars.log", replace;

#delimit ;

tab icb kosimo if year<=1994;

tab mid kosimo if year<=1992;

tab mid icb if year<=1992;

tab icb crisis if year<=1994;

tab mid crisis if year<=1992;

log close;
