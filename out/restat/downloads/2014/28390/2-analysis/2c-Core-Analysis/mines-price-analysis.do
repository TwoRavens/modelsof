#delimit;
clear all;
set more off;
cap n log close;
log using "mines2c.log", replace;

insheet using mines.txt, clear;
des; sum; gen const=1;

ren pmsa msa; sort msa; merge msa using msamines_coal_cat;
tab _m; drop if _m==2; drop _m centralcity msaname; ren msa pmsa; 
for any 25 50 75 100 150 250 500: 
\ gen TX=mines_X_miles
\ gen AX=ANTHRACITE_X_miles+SEMIANTHRACITE_X_miles
\ gen BX=BITUMINOUS_X_miles+SUBBITUMINOUS_X_miles
\ gen CX=AX+BX
\ gen LX=LIGNITE_X_miles+COAL_X_miles;
drop mines_* ANTHRACITE* SEMIANTHRACITE* BITUMINOUS* SUBBITUMINOUS* LIGNITE* COAL*; des;
for any 25 50 75 100 150 250 500: gen CSHX=(CX>0) \ gen LSHX=(LX>0)  \ gen DTX=(TX==0);
for var C* L*: egen temp1=pctile(X), p(98) \ replace X=temp1 if X>temp1 \ drop temp1; 

ren pmsa msa;
sort msa; merge msa using coal_price_1925_1930.dta;
tab _m; keep if _m==3; drop if city=="Bridgeport, Conn" | city=="St. Paul Minn"; drop _m;
reshape long anthracite_chestnut_ bituminous_, i(msa) j(year);
ren anthracite_chestnut_ pricea;
ren bituminous_ priceb;

*** Price analysis;
*replace pricea=. if pmsal=="Charleston, SC" | pmsal=="Indianapolis, IN" | pmsal=="Savannah, GA";
drop if pricea==. & priceb==.;
xi i.r9;
for var price*: gen DX=(X!=.) \ gen lX=ln(X);
for any A B C L: replace X500=X500-X250 \ replace X250=X250-X100 \ replace X100=X100-X50; sum A* B* C* L*;
for var A* B* C* L*: gen DX=(X>0 & X!=.) \ egen temp1=std(X) \ replace X=temp1 \ drop temp1;
for any Dpricea lpricea:
\ areg X A50 A100 A250 A500, a(year) cl(pmsa)
\ areg X A50 A100 A250 A500 _I*, a(year) cl(pmsa);
for any Dpriceb lpriceb:
\ areg X B50 B100 B250 B500, a(year) cl(pmsa)
\ areg X B50 B100 B250 B500 _I*, a(year) cl(pmsa);
log close; 
stop;
