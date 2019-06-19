/*** Albouy (REStat, 2013), Figure 3 ***/
/** Produces data only, map hand-made */

# delimit ;
version 11.2;
cd c:\data\political;

set more off;
clear;
use spend_panel_restat, replace;

sort fipsst year ;

g chg = abs(h_d - h_d[_n-1]) if  fipsst==fipsst[_n-1] ;

g dem1983 = 0;
replace dem1983 = h_d if year==1983 ;
g dem2004 = 0;
replace dem2004 = h_d if year==2004 ;


keep if inrange(year,1983,2004);
drop if fipsst==11;

collapse (sum) chg dem1983 dem2004, by(fipsst state statename) ;

g demchg = dem2004-dem1983 ;

egen chg2 = cut(chg),  at(0,0.0001,.5,1,1.5,2.5) icodes;

egen demchg2 = cut(demchg),  at(-2,-.499995,-0.0001,0.00001,.49995,2) icodes;

list statename chg chg2 demchg demchg2;

rename fipsst fips ;
sort fips;

cd map ;

tostring fips, g(state_fips) ;

replace state_fips = "0" + state_fips if fips<10 ;

outsheet state_fips chg2 demchg2 

