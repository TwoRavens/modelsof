
set more off
tsset ccode year

*Table 1
xtpcse milgdp parcomp2mod  lnage  bdthpct cwdthpct srivalcap allycap gdp emppop if year >= 1950 & year <= 1997 & demcgx == 0, corr(ar1) pairwise
sum milgdp if parcomp2twocat==0 & age3cat==1 & e(sample)
sum milgdp if parcomp2twocat==0 & age3cat==2 & e(sample)
sum milgdp if parcomp2twocat==0 & age3cat==3 & e(sample)
sum milgdp if parcomp2twocat==1 & age3cat==1 & e(sample)
sum milgdp if parcomp2twocat==1 & age3cat==2 & e(sample)
sum milgdp if parcomp2twocat==1 & age3cat==3 & e(sample)

* Table 2, Column 1: Fordham and Walker Original model on autocratic subsample
xtpcse milgdp polity bdthpct cwdthpct srivalcap allycap gdp emppop if year > 1949 & year < 1998 & demcgx == 0, corr(ar1) pairwise

* Table 2, Model 1
xtpcse milgdp parcomp2mod  lnage  bdthpct cwdthpct srivalcap allycap gdp emppop if year >= 1950 & year <= 1997 & demcgx == 0, corr(ar1) pairwise

* Table 2, Model 2
xtpcse milgdp parcomp2mod  lntimesincecoup_pt bdthpct cwdthpct srivalcap allycap gdp emppop if year >= 1950 & year <= 1997 & demcgx == 0, corr(ar1) pairwise

* Table 2, Model 3
xtpcse milgdp lparty2 lnage civx milx bdthpct cwdthpct srivalcap allycap gdp emppop if year >= 1950 & year <= 1997 & demcgx == 0, corr(ar1) pairwise

* Table 2, Model 4
xtpcse milgdp lparty2 lntimesincecoup_pt civx milx bdthpct cwdthpct srivalcap allycap gdp emppop if year >= 1950 & year <= 1997 & demcgx == 0, corr(ar1) pairwise

* Table 5, Model 9
xtpcse milgdp xconst2 parcomp2mod  lnage  bdthpct cwdthpct srivalcap allycap gdp emppop if year >= 1950 & year <= 1997 & demcgx == 0, corr(ar1) pairwise

* Table 5, Model 10
xtpcse milgdp xconst2 parcomp2mod  lntimesincecoup_pt  bdthpct cwdthpct srivalcap allycap gdp emppop if year >= 1950 & year <= 1997 & demcgx == 0, corr(ar1) pairwise
