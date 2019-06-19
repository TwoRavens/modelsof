/*** Albouy (REStat, 2013), Table 2 ***/
/* Need to download "cluster2" command */

# delimit ;

version 11.2 ;
set output error ;
set matsize 1000 ;
set more off ;
cd c:\data\political ;

local styear = "1983";
local endyear = "2004";

local intvars = "s_m h_m s_r h_r s_p h_p  ";

local convars0 = "year1983-year2003 fipsst2-fipsst56   lpop lpop2 pct* med* h_t h_i s_t s_i  " ;
local convars1 = "year1983-year2003 fipsst2-fipsst56  reg1-reg3 year1983_r1-year2003_r3 lpop lpop2 pct* med* h_t h_i s_t s_i  " ;
local convars2 = "year1983-year2003 fipsst2-fipsst56  div1-div8 year1983_d1-year2003_d8 lpop lpop2 pct* med* h_t h_i s_t s_i  " ;


local wgt = "1 " ;

local listgg1 ="dod gg_tot";

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

/* Region and Division dummies */

for R in num 1 2 3 4: 
	g byte regR = region==R \
	qui for N in num 1983 (1) 2003 : 
		g byte yearN_rR = (year==N)*(region==R)  ;
		
for R in num 1(1)9: 
	g byte divR = division==R \
	qui for N in num 1983 (1) 2003 : 
		g byte yearN_dR = (year==N)*(division==R)  ;
			

qui for N in num 
	1 2 4 5   
	8 9 10 12 13 15 16 17 18 19 20 21 22
	23 24 25 26 27 28 29 30 31 32 33 34 35 36 37
	38 39 40 41 42 44 45 46 47 48 49 50 51 53
	54 55 56 :
	g fipsstN = fipsst==N ;

/** Share Republican **/
	
g s_r = 1-s_d;
g h_r = 1-h_d;

/** Presidential Match **/

g s_p = s_r*(1-dempres) + (1-s_r)*dempres ;
g h_p = h_r*(1-dempres) + (1-h_r)*dempres  ;


/** Senate Vote Polynomial **/

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

/** Other adjustments **/


g y=.;
keep if year>=`styear';

g wgt=`wgt';


save temp, replace ;


foreach Y of varlist `listgg1'  { ;

use temp, replace;
qui replace y =  log(`Y')  ;
drop if y==.;

noi disp "`Y'" ;

cluster2 y `intvars'  `convars0'  , fcluster(fipsst) tcluster(year) ;
*qui reg y `intvars'   `convars0'   [aw=wgt], cluster(fipsst) ;
estimates store `Y' ;
parmest , saving(est`Y', replace) idstr(`Y') ;

cluster2 y `intvars'  `convars0' `polydem' , fcluster(fipsst) tcluster(year) ;
*qui reg y `intvars'   `convars0' `polydem'   [aw=wgt], cluster(fipsst) ;
estimates store `Y'0 ;
parmest , saving(est`Y', replace) idstr(`Y') ;

cluster2 y `intvars'  `convars1' `polydem' , fcluster(fipsst) tcluster(year) ;
*qui reg y `intvars'  `convars1' `polydem'  [aw=wgt], cluster(fipsst) ;
estimates store `Y'1 ;
parmest , saving(est`Y', replace) idstr(`Y') ;

cluster2 y `intvars'  `convars2' `polydem' , fcluster(fipsst) tcluster(year) ;
*qui reg y `intvars'   `convars2' `polydem'  [aw=wgt], cluster(fipsst) ;
estimates store `Y'2 ;
parmest , saving(est`Y', replace) idstr(`Y') ;


} ;


/**** LINEAR ***/


local list1=" gg_tot gg_tot0 gg_tot1 gg_tot2 dod dod0 dod1 dod2   ";

noi estimates table `list1', keep(`intvars' )  b(%5.3f)  star(.1 .05 .01)   modelwidth(8) stats(N) ;
noi estimates table `list1', keep(`intvars' )  b(%5.3f)  se(%5.3f) p(%5.3f)  modelwidth(8) stats(N) ;

