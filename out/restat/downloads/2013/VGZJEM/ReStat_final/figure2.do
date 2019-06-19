/*** Albouy (REStat, 2013), Figure 2 ***/
/** Produces data only, map hand-made */

# delimit ;
version 11.2;
cd c:\data\political;

version 8.2 ;

set more off;
clear;
use spend_panel_restat, replace;

sort fipsst year ;

for N in num 1 2:
g nochgN = partyN==partyN[_n-1] &  fipsst==fipsst[_n-1] \
g chgN = 1-nochgN ;

g dem1 = party1=="D" ;
g dem2 = party2=="D" ;

g dem1983 = 0;
replace dem1983 = dem1 + dem2 if year==1983 ;
g dem2004 = 0;
replace dem2004 = dem1 + dem2 if year==2004 ;


g chg = chg1 + chg2 ;

keep if inrange(year,1983,2004);
drop if fipsst==11;

collapse (sum) chg dem1983 dem2004, by(fipsst state statename) ;

g demchg = dem2004-dem1983 ;

list statename chg demchg;


rename fipsst fips ;
sort fips;

cd map ;
save temp, replace ;

tostring fips, g(state_fips) ;

replace state_fips = "0" + state_fips if fips<10 ;

rename chg chg1 ;
rename demchg demchg1 ;

outsheet state_fips chg1 demchg1 using chg1.txt ,names replace;
