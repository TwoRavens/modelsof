/*** Albouy (REStat, 2013), Table 4 ***/
/* Need to download "cluster2" command */

# delimit ;

version 11.2;
set output error ;
set more off ;
cd c:\data\political ;

local styear = "1983";
local endyear = "2004";

local intvars = "s_m h_m s_r h_r s_i h_i s_t h_t s_p h_p  ";

local convars = "year1983-year2003  fipsst2-fipsst56 reg1-reg3 year1983_r1-year2003_r3  lpop lpop2 med* pct*  " ;

local wgt = "1 " ;
local listgg1 ="dod gg_tot dot gg_doed gg_hud gg_hew gg_oth";


use spend_panel_restat, replace ;

rename h_avgten h_t ;
rename s_avgten s_t ;

g dot = airdot +hwydot +umtdot;
g dod = pcdod + swdodmil + swdodciv ;
g gg_oth = gg_tot - gg_doed - gg_hud - gg_hew - dot ;
replace dod=. if year<1971;

g lpop = log(pop) ;
g lpop2 = lpop^2;
g sqrtpop = sqrt(pop) ;

keep if inrange(year,`styear',`endyear');
qui for N in num `styear' (1) `endyear' : 
	g byte yearN = year==N ;

for R in num 1 2 3 4: g byte regR = region==R ;

qui for N in num 1983 (1) 2003 : 
	g byte yearN_r1 = (year==N)*(region==1)  \
	g byte yearN_r2 = (year==N)*(region==2)  \
	g byte yearN_r3 = (year==N)*(region==3)  ;


qui for N in num 
	1 2 4 5   
	8 9 10 12 13 15 16 17 18 19 20 21 22
	23 24 25 26 27 28 29 30 31 32 33 34 35 36 37
	38 39 40 41 42 44 45 46 47 48 49 50 51 53
	54 55 56 :
	g fipsstN = fipsst==N ;

g s_r = 1-s_d;
g h_r = 1-h_d;

g s_p = s_r*(1-dempres) + (1-s_r)*dempres ;
g h_p = h_r*(1-dempres) + (1-h_r)*dempres  ;


rename s_sh_m s_s;
rename h_sh_m h_s;

g s_mt = s_m*s_t ;
g h_mt = h_m*h_t ;
g s_rt = s_r*s_t ;
g h_rt = h_r*h_t ;


for N in num 1 2:
g fNdeml = fracNdem*(fracNdem<.5) \
g fNdemr = fracNdem*(fracNdem>=.5) \
g fNdeml2 = fNdeml^2 \
g fNdemr2 = fNdemr^2 \
g fNdem1 = fracNdem \
g fNdem2 = fracNdem^2 \
g fNdem3 = fracNdem^3 \
g fNdem4 = fracNdem^4 \
g fNdem_0 = fracNdem==0 \
g fNdem_1 = fracNdem==1 ;

local polydem = "f1dem1 f1dem2 f1dem3 f1dem4 f1dem_0 f1dem_1 f2dem1 f2dem2 f2dem3 f2dem4 f2dem_0 f2dem_1" ;


g y=.;
keep if year>=`styear';

g wgt=`wgt';

save temp, replace ;


g s_sm = s_m*(s_s-.5) ;
g h_sm = h_m*(h_s-.5) ;

set output proc ;

replace gg_tot = ln(gg_tot) ;
replace dot = ln(dot) ;
replace dod = ln(dod) ;


cluster2 gg_tot s_sm h_sm `intvars'   `convars' `polydem' , fcluster(fipsst) tcluster(year) ;
noi nlcom alpha: _b[s_m] ;
noi nlcom _b[s_sm] ;
noi nlcom phi: (sqrt(1+4*_b[s_sm])-1)/2 ;

cluster2 dot s_sm h_sm `intvars'   `convars' `polydem' , fcluster(fipsst) tcluster(year) ;
noi nlcom alpha: _b[s_m] ;
noi nlcom _b[s_sm] ;
noi nlcom phi: (sqrt(1+4*_b[s_sm])-1)/2 ;

reg dod s_sm h_sm `intvars'   `convars' `polydem' [aw=wgt], cluster(fipsst) ;
cluster2 dod s_sm h_sm `intvars'   `convars' `polydem' , fcluster(fipsst) tcluster(year) ;
noi nlcom alpha: _b[s_m] ;
noi nlcom _b[s_sm] ;
noi nlcom phi: (sqrt(1+4*_b[s_sm])-1)/2 ;


