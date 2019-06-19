/*** Albouy (REStat, 2013), Figure 4 ***/


# delimit ;

version 11.2;
set output error ;
set more off ;
cd c:\data\political ;

local styear = "1970";
local endyear = "2004";

local intvars = "s_m h_m s_r h_r";
local intvars1 = "m r ";

local convars = "year1970-year2003 fipsst2-fipsst56 lpop lpop2 med* pct*  *_avgten *_i" ;
local wgt = "1" ;

use spend_panel_restat, replace ;

g dot = airdot +hwydot +umtdot;
g dod = pcdod + swdodmil + swdodciv ;
replace dod=. if year<1971;

g lpop = log(pop) ;
g lpop2 = lpop^2;
g sqrtpop = sqrt(pop) ;

keep if inrange(year,1970,2004);
qui for N in num 1970 (1) 2003 : 
	g byte yearN = year==N ;

qui for N in num 
	1 2 4 5   
	8 9 10 12 13 15 16 17 18 19 20 21 22
	23 24 25 26 27 28 29 30 31 32 33 34 35 36 37
	38 39 40 41 42 44 45 46 47 48 49 50 51 53
	54 55 56 :
	g fipsstN = fipsst==N ;

g s_r = 1-s_d;
g h_r = 1-h_d;

g d = h_d + s_d ;
g r = h_r + s_r ;
g m = h_m + s_m ;


rename s_sh_m s_s;
rename h_sh_m h_s;

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
keep if year>=1983;


save temp, replace ;

/**** START LOOP HERE ***/

foreach Y in "dod" "gg_hud" { ;

if "`Y'"=="dod" { ; 
	local type="Defense"   ;
	local fignum = "4a" ;
	 };
else if "`Y'"=="gg_hew" { ; 
	local type="Human Services"  ;
	local fignum = "4b" ;
	 };
else if "`Y'"=="gg_doed" { ; 
	local type="Education"  ;
	local fignum = "5b" ;
	 };
else if "`Y'"=="gg_hud" { ; 
	local type="Urban Development"  ;
	local fignum = "4b" ;
	 };



use temp, replace;
qui replace y =  log(`Y')  ;
drop if y==.;
g wgt=`wgt';
qui reg y s_m h_r h_m `convars' [aw=wgt], cluster(fipsst) ;
predict `Y'_r, resid ;


reg `Y'_r s_r , cluster(fipsst) ;

reg `Y'_r s_r  `polydem', cluster(fipsst) ;

keep f1dem1 f2dem1 `Y'_r fipsst year ;

for N in num 1 2:
rename fNdem1 fdemN\
g frepN = 1 - fdemN\
drop fdemN \
g rN=frepN>.5;

g wgt = 1;




reshape long frep r , i(fipsst year) j(seat) ;

g fl = 0;
replace fl = frep if frep<.5 ;
g fr = 0;
replace fr = frep if frep>.5 ;

replace r = frep>.5;

for N in num 1 2 3 4:
g fN = frep^N \
g flN = fl^N \
g frN = fr^N ;

reg `Y'_r r  , cluster(fipsst) ;

predict fit_fe, xb;
predict se_fe, stdp ;
g band_fe1 = fit_fe - 1.96*se_fe;
g band_fe2 = fit_fe + 1.96*se_fe;

reg `Y'_r r f1 f2 f3 f4 if abs(f1- .5)<.4 , cluster(fipsst) ;

predict fit_rd, xb;
predict se_rd, stdp ;
g band_rd1 = fit_rd - 1.96*se_rd;
g band_rd2 = fit_rd + 1.96*se_rd;

g samp = e(sample);
for V in var fit_rd-band_rd2:
	replace V=. if samp==0;
drop samp;

save temp2, replace ;

local step = "4" ;
local step2 = "5" ;

g frepbin = 2.5*int(100/2.5*(frep) ) + 1.25 ;


sort frepbin;
qui by frepbin: egen n= count(`Y'_r) ;


/**** START COLLAPSING HERE ***/

collapse (mean) `Y'_r r fit_fe band_fe1 band_fe2 fit_rd band_rd1 band_rd2  (count) n=`Y'_r , by(frepbin);

save temp3, replace ;

use temp2, replace;

g frepbin = 0.25*int(100/0.25*frep ) + 0.125 ;

collapse (mean) r fit_fe band_fe1 band_fe2 fit_rd band_rd1 band_rd2 , by(frepbin);

append using temp3 ;

for V in var `Y'_r fit_fe band_fe1 band_fe2 fit_rd band_rd1 band_rd2 :
replace V =. if abs(V)>.1 \
replace V = 2*V ;


qui for X in any fe rd:

g fit_Xl = fit_X if r==0 \
g fit_Xr = fit_X if r==1 \
g bandl_X1 = band_X1 if r==0\
g bandl_X2 = band_X2 if r==0\
g bandr_X1 = band_X1 if r==1\
g bandr_X2 = band_X2 if r==1;

g type = 4 ;
replace type = 3 if n>50 ;
replace type = 2 if n>100 ;
replace type = 1 if n>200 ;
replace type =. if n==.;

g `Y'_r1 = `Y'_r if type==1;
g `Y'_r2 = `Y'_r if type==2;
g `Y'_r3 = `Y'_r if type==3;
g `Y'_r4 = `Y'_r if type==4;






keep if inrange(frepbin,25,75);

sort frepbin;

twoway 
(line fit_fel fit_fer bandl_fe1 bandl_fe2 bandr_fe1 bandr_fe2 fit_rdl fit_rdr bandl_rd1 bandl_rd2 bandr_rd1 bandr_rd2 frepbin, 
clw(medium medium thin thin thin thin medthick medthick medthin medthin medthin medthin) 
clp(longdash longdash longdash longdash longdash longdash shortdash shortdash shortdash shortdash shortdash shortdash )  
clc(black black black black black black black black black black black black black black black black )  )
(scatter `Y'_r1 `Y'_r2 `Y'_r3 `Y'_r4 frepbin, xline(50, lp(dot)) legend(off)  
xlabel(25 (25) 75, grid) 
xtick(25 (5) 75)
msymbol(Oh oh oh o) msize(large large medium small) mcolor(black black black black)


graphregion(fcolor(white) lcolor(white))
	saving(gr`Y', replace) legend(off)
	l2("Spending Residual") 
	xti(" " "Republican Vote-Share") 
	ti("Figure `fignum': Republican Effect on `type' Spending", size(2.5))
 ) ;

} ;

graph combine grdod.gph grgg_hud.gph ,
	iscale(.9)
	col(1) 
	xsize(6.5)
	ysize(9) 
graphregion(fcolor(white) lcolor(white))
ti("Figure 4: Estimates of Party-Taste Effects for the Senate", size(3.5))
t2("Fixed-Effect and Regression-Discontinuity Estimates Compared", size(2.5)) ;
