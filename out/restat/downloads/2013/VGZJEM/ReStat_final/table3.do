/*** Albouy (REStat, 2013), Table 3 ***/
/* Need to download "cluster2" and "multproc" command */


# delimit ;
version 11.2;
set output error ;
set more off ;
cd c:\data\political ;

local styear = "1983";
local endyear = "2004";

local intvars = "s_m h_m s_r h_r s_p h_p  ";

local convars0 = "year1983-year2003 fipsst2-fipsst56   lpop lpop2 pct* med* h_t h_i s_t s_i  " ;
local convars1 = "year1983-year2003 fipsst2-fipsst56  reg1-reg3 year1983_r1-year2003_r3 lpop lpop2 pct* med* h_t h_i s_t s_i  " ;
local convars2 = "year1983-year2003 fipsst2-fipsst56  div1-div8 year1983_d1-year2003_d8 lpop lpop2 pct* med* h_t h_i s_t s_i  " ;
local wgt = "1 " ;

local listgg1 ="dot gg_doed gg_hud gg_hew gg_oth";


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



cluster2 y `intvars'  `convars1' `polydem' , fcluster(fipsst) tcluster(year) ;
*qui reg y `intvars'  `convars1' `polydem'  [aw=wgt], cluster(fipsst) ;
estimates store `Y'1 ;
parmest , saving(est`Y', replace) idstr(`Y') ;

} ;


local list1=" dot1 gg_doed1 gg_hud1 gg_hew1 gg_oth1   ";



noi estimates table `list1', keep(`intvars' )  b(%5.3f)  star(.1 .05 .01)   modelwidth(8) stats(N) ;
noi estimates table `list1', keep(`intvars' )  b(%5.3f)  se(%5.3f) p(%5.3f)  modelwidth(8) stats(N) ;


/*** MULTIPLE HYPOTHESES TESTS ****/

drop _all ;
dsconcat estgg_tot.dta estdot.dta estgg_doed.dta estgg_hud.dta estgg_hew.dta estgg_oth.dta estdod.dta ; 

drop if substr(parm,1,4)=="year" | substr(parm,1,4)=="fips" ;
sort p ;
save est_temp, replace ;

drop _all ;
dsconcat estgg_tot1.dta estdot1.dta estgg_doed1.dta estgg_hud1.dta estgg_hew1.dta estgg_oth1.dta estdod1.dta ; 

drop if substr(parm,1,4)=="year" | substr(parm,1,4)=="fips" ;
sort p ;
save est_temp1, replace ;

set level 90 ;


foreach V in s_m h_m s_r h_r s_p h_p {;

use est_temp, replace ;
keep if  inlist(substr(parm,1,3),"`V'") &  inlist(substr(idstr,1,7),"gg_hud","gg_doed","gg_hew","gg_oth","dot")  ;
su p ;
scalar num = r(N) ;

noi multproc, method(simes) rank(p_rank) critical(p_crit) gpcor(p_cor) ;
g p_max = p*num/p_rank ;

gsort -p_rank ;
g p_bh = p if p_rank==num ;
replace p_bh = min(p_max ,p_bh[_n-1] ) ;

g idsort = 1 if idstr=="dot";
replace idsort = 2 if idstr=="gg_doed" ;
replace idsort = 3 if idstr=="gg_hud" ;
replace idsort = 4 if idstr=="gg_hew" ;
replace idsort = 5 if idstr=="gg_oth" ;

sort idsort ;

format estimate stderr %5.3f ;
format p p_max p_bh %5.2f ;

noi list idstr parm estimate stderr p p_max p_bh  ;
} ;

