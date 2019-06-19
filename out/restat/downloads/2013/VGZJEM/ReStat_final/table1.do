/*** Albouy (REStat, 2013), Table 1 ***/
/* Need to download "cluster2" command */

# delimit ;

version 11.2 ;
set output error ;
set matsize 1000 ;
set more off ;
cd c:\data\political ;

local styear = "1983";
local endyear = "2004";

local convars0 = "year1983-year2003 fipsst2-fipsst56   lpop lpop2 pct* med* h_t h_i s_t s_i  " ;


local wgt = "1 " ;

local list ="tot dod gg_tot gg_dot gg_doed gg_hud gg_hew gg_oth";

use spend_panel_restat, replace ;

rename h_avgten h_t ;
rename s_avgten s_t ;

g dot = airdot +hwydot +umtdot;
g dod = pcdod + swdodmil + swdodciv ;
g gg_oth = gg_tot - gg_doed - gg_hud - gg_hew - gg_dot ;
replace dod=. if year<1971;

g lpop = log(pop) ;
g lpop2 = lpop^2;
g sqrtpop = sqrt(pop) ;


keep if inrange(year,`styear',`endyear');
qui for N in num `styear' (1) `endyear' : 
	g byte yearN = year==N ;


qui for N in num 
	1 2 4 5   
	8 9 10 12 13 15 16 17 18 19 20 21 22
	23 24 25 26 27 28 29 30 31 32 33 34 35 36 37
	38 39 40 41 42 44 45 46 47 48 49 50 51 53
	54 55 56 :
	g fipsstN = fipsst==N ;

save temp, replace ;

for V in any `list' :
replace V = V/pop ;
	
noi su `list' [aw=pop] if year==2004 ;

use temp, replace ;

for V in any `list' :
replace V = ln(V/pop/cpi) ;

noi su `list' ;

use temp, replace ;




foreach V in  `list' { ;
replace `V' = ln(`V'/cpi/pop) ;
regress `V' lpop lpop2 pct* med* fipsst* year*, robust ;
scalar r2`V' = e(r2) ;
scalar rmse`V' = e(rmse) ;
} ;
noi scalar list ;
