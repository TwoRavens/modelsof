#delimit;

gl coaggl
gl lbd10
gl census
gl cmf
gl data
gl programs

cap n log close; 
log using gr-sic1-5yr-3-discloseprep.log, replace;
set more off;
chdir $coaggl/growth/cmf;

clear all; set matsize 10000;

* William Kerr;
* Growth Paper CMF File Prep;
* See xxx-2.do in 2011 folder for initial development;
* Last Modified: May 2012;

***********************************************************;
*** MERGE EXTENDED MINE DATA INTO SIC1 FILES             **;
***********************************************************;

*** Open prep file;
use ./data/gr-sic1-5yr-2, clear; drop if JanTemp==.;
sum GR* if pmsa==5000; *replace GRemp8202T=ln(892198/724890) if pmsa==5000;
gen cl=r9; set seed 1;

*** Add coal estimates;
sort st; merge st using ./data/stlbl, nok; tab _m; drop _m;
gen coal=0;
replace coal=68.66 if stlbl=="AL";
replace coal=0.06 if stlbl=="AZ";
replace coal=1.85 if stlbl=="AR";
replace coal=371.6 if stlbl=="CO";
replace coal=0.99 if stlbl=="CA";
replace coal=0.98 if stlbl=="GA";
replace coal=0.60 if stlbl=="ID";
replace coal=239.03 if stlbl=="IL";
replace coal=43.93 if stlbl=="IN";
replace coal=28.95 if stlbl=="IA";
replace coal=6.88 if stlbl=="KS";
replace coal=103.84 if stlbl=="KY";
replace coal=7.82 if stlbl=="MD";
replace coal=11.98 if stlbl=="MI";
replace coal=39.85 if stlbl=="MO";
replace coal=303.02 if stlbl=="MT";
replace coal=163.75 if stlbl=="NM";
replace coal=0.20 if stlbl=="NC";
replace coal=500.00 if stlbl=="ND";
replace coal=85.29 if stlbl=="OH";
replace coal=79.22 if stlbl=="OK";
replace coal=0.99 if stlbl=="OR";
replace coal=117.59 if stlbl=="PA";
replace coal=10.00 if stlbl=="SD";
replace coal=25.54 if stlbl=="TN";
replace coal=30.98 if stlbl=="TX";
replace coal=196.43 if stlbl=="UT";
replace coal=22.42 if stlbl=="VA";
replace coal=19.94 if stlbl=="WA";
replace coal=230.39 if stlbl=="WV";
replace coal=423.97 if stlbl=="WY";
gen area=100;
replace area=52 if stlbl=="AL";
replace area=114 if stlbl=="AZ";
replace area=53 if stlbl=="AR";
replace area=104 if stlbl=="CO";
replace area=164 if stlbl=="CA";
replace area=59 if stlbl=="GA";
replace area=84 if stlbl=="ID";
replace area=58 if stlbl=="IL";
replace area=36 if stlbl=="IN";
replace area=56 if stlbl=="IA";
replace area=82 if stlbl=="KS";
replace area=40 if stlbl=="KY";
replace area=12 if stlbl=="MD";
replace area=97 if stlbl=="MI";
replace area=70 if stlbl=="MO";
replace area=147 if stlbl=="MT";
replace area=122 if stlbl=="NM";
replace area=54 if stlbl=="NC";
replace area=71 if stlbl=="ND";
replace area=45 if stlbl=="OH";
replace area=70 if stlbl=="OK";
replace area=98 if stlbl=="OR";
replace area=46 if stlbl=="PA";
replace area=77 if stlbl=="SD";
replace area=42 if stlbl=="TN";
replace area=269 if stlbl=="TX";
replace area=85 if stlbl=="UT";
replace area=43 if stlbl=="VA";
replace area=71 if stlbl=="WA";
replace area=24 if stlbl=="WV";
replace area=98 if stlbl=="WY";
replace coal=coal/area; format coal %5.3f;
replace coal=9 if (coal>9 | pmsa==6280); 
replace coal=0.01 if coal<1;
gsort -coal pmsal; list pmsal coal; 

*** Add 1869 coal estimates;
sort st; merge st using ./data/stlbl, nok; tab _m; drop _m;
gen coal69=0;
replace coal69=13800+7798 if stlbl=="PA";
replace coal69=2629 if stlbl=="IL";
replace coal69=2527 if stlbl=="OH";
replace coal69=1820 if stlbl=="MD";
replace coal69=621 if stlbl=="MO";
replace coal69=609 if stlbl=="WV";
replace coal69=439 if stlbl=="IN";
replace coal69=263 if stlbl=="IA";
replace coal69=151 if stlbl=="KY";
replace coal69=133 if stlbl=="TN";
replace coal69=62 if stlbl=="VA";
replace coal69=33 if stlbl=="KS";
replace coal69=27 if stlbl=="OR";
replace coal69=21 if stlbl=="MI";
replace coal69=17 if stlbl=="CA";
replace coal69=14 if stlbl=="RI";
replace coal69=11 if stlbl=="AL";
replace coal69=1 if stlbl=="NE";
replace coal69=50 if stlbl=="WY";
replace coal69=18 if stlbl=="WA";
replace coal69=6 if stlbl=="UT";
replace coal69=5 if stlbl=="CO";
replace coal69=coal69/area; format coal69 %5.3f;
replace coal69=0.01 if coal69<0.01;
gsort -coal69 pmsal; list pmsal coal69; 

*** Add 1909 mines estimates;
gen ent09=0; gen emp09=0;
replace ent09=510 if stlbl=="ME"; replace emp09=17048 if stlbl=="ME";
replace ent09=45 if stlbl=="NH"; replace emp09=1418 if stlbl=="NH";
replace ent09=137 if stlbl=="VT"; replace emp09=8145 if stlbl=="VT";
replace ent09=139 if stlbl=="MA"; replace emp09=3291 if stlbl=="MA";
replace ent09=21 if stlbl=="RI"; replace emp09=665 if stlbl=="RI";
replace ent09=71 if stlbl=="CT"; replace emp09=1385 if stlbl=="CT";
replace ent09=1351 if stlbl=="NY"; replace emp09=9305 if stlbl=="NY";
replace ent09=131 if stlbl=="NJ"; replace emp09=6315 if stlbl=="NJ";
replace ent09=4851 if stlbl=="PA"; replace emp09=361013 if stlbl=="PA";
replace ent09=1876 if stlbl=="OH"; replace emp09=50567 if stlbl=="OH";
replace ent09=1010 if stlbl=="IN"; replace emp09=23936 if stlbl=="IN";
replace ent09=915 if stlbl=="IL"; replace emp09=72086 if stlbl=="IL";
replace ent09=83 if stlbl=="MI"; replace emp09=39169 if stlbl=="MI";
replace ent09=268 if stlbl=="WI"; replace emp09=4710 if stlbl=="WI";
replace ent09=153 if stlbl=="MN"; replace emp09=16586 if stlbl=="MN";
replace ent09=373 if stlbl=="IA"; replace emp09=16480 if stlbl=="IA";
replace ent09=1021 if stlbl=="MO"; replace emp09=23420 if stlbl=="MO";
replace ent09=53 if stlbl=="ND"; replace emp09=562 if stlbl=="ND";
replace ent09=39 if stlbl=="SD"; replace emp09=3456 if stlbl=="SD";
replace ent09=18 if stlbl=="NE"; replace emp09=349 if stlbl=="NE";
replace ent09=643 if stlbl=="KS"; replace emp09=14343 if stlbl=="KS";
replace ent09=9 if stlbl=="DE"; replace emp09=493 if stlbl=="DE";
replace ent09=126 if stlbl=="MD"; replace emp09=7190 if stlbl=="MD";
replace ent09=150 if stlbl=="VA"; replace emp09=15257 if stlbl=="VA";
replace ent09=798 if stlbl=="WV"; replace emp09=73410 if stlbl=="WV";
replace ent09=118 if stlbl=="NC"; replace emp09=2215 if stlbl=="NC";
replace ent09=29 if stlbl=="SC"; replace emp09=1814 if stlbl=="SC";
replace ent09=92 if stlbl=="GA"; replace emp09=3383 if stlbl=="GA";
replace ent09=36 if stlbl=="FL"; replace emp09=5548 if stlbl=="FL";
replace ent09=437 if stlbl=="KY"; replace emp09=18297 if stlbl=="KY";
replace ent09=216 if stlbl=="TN"; replace emp09=16338 if stlbl=="TN";
replace ent09=177 if stlbl=="AL"; replace emp09=28271 if stlbl=="AL";
replace ent09=96 if stlbl=="AR"; replace emp09=4935 if stlbl=="AR";
replace ent09=33 if stlbl=="LA"; replace emp09=926 if stlbl=="LA";
replace ent09=33 if stlbl=="MS"; replace emp09=926 if stlbl=="MS";
replace ent09=864 if stlbl=="OK"; replace emp09=11658 if stlbl=="OK";
replace ent09=236 if stlbl=="TX"; replace emp09=6379 if stlbl=="TX";
replace ent09=373 if stlbl=="MT"; replace emp09=18846 if stlbl=="MT";
replace ent09=174 if stlbl=="ID"; replace emp09=3246 if stlbl=="ID";
replace ent09=66 if stlbl=="WY"; replace emp09=7742 if stlbl=="WY";
replace ent09=672 if stlbl=="CO"; replace emp09=21483 if stlbl=="CO";
replace ent09=98 if stlbl=="NM"; replace emp09=5107 if stlbl=="NM";
replace ent09=135 if stlbl=="AZ"; replace emp09=12838 if stlbl=="AZ";
replace ent09=188 if stlbl=="UT"; replace emp09=10089 if stlbl=="UT";
replace ent09=266 if stlbl=="NV"; replace emp09=4642 if stlbl=="NV";
replace ent09=93 if stlbl=="WA"; replace emp09=6904 if stlbl=="WA";
replace ent09=116 if stlbl=="OR"; replace emp09=860 if stlbl=="OR";
replace ent09=1329 if stlbl=="CA"; replace emp09=20517 if stlbl=="CA";
for any ent09 emp09: ren X Xa;

*** Add 1909 top products;
gen top09=0;
for any PA IN IL MI MN ND MD VA WV KY TN AL CO WA: replace top09=1 if stlbl=="X";
gen top00=top09;
*replace top00=1 if (coal>2.5); 
*replace top00=1 if (MI250_00>=200 & MI250_00/MT250_00>0.5);
replace top00=0 if MT250_00<100 | MI250_00<30;
pwcorr top*; gsort -MI250_00; list pmsal top* MI250_00 MT250_00;

*** Add 1919 mines estimates;
gen ent09=0; gen emp09=0;
replace ent09=51 if stlbl=="ME"; replace emp09=979 if stlbl=="ME";
replace ent09=33 if stlbl=="NH"; replace emp09=682 if stlbl=="NH";
replace ent09=109 if stlbl=="VT"; replace emp09=2936 if stlbl=="VT";
replace ent09=79 if stlbl=="MA"; replace emp09=1704 if stlbl=="MA";
replace ent09=15 if stlbl=="RI"; replace emp09=369 if stlbl=="RI";
replace ent09=47 if stlbl=="CT"; replace emp09=543 if stlbl=="CT";
replace ent09=147 if stlbl=="NY"; replace emp09=5334 if stlbl=="NY";
replace ent09=102 if stlbl=="NJ"; replace emp09=4576 if stlbl=="NJ";
replace ent09=3508 if stlbl=="PA"; replace emp09=314332 if stlbl=="PA";
replace ent09=1064 if stlbl=="OH"; replace emp09=44175 if stlbl=="OH";
replace ent09=398 if stlbl=="IN"; replace emp09=26348 if stlbl=="IN";
replace ent09=590 if stlbl=="IL"; replace emp09=76371 if stlbl=="IL";
replace ent09=165 if stlbl=="MI"; replace emp09=31292 if stlbl=="MI";
replace ent09=107 if stlbl=="WI"; replace emp09=3547 if stlbl=="WI";
replace ent09=196 if stlbl=="MN"; replace emp09=17265 if stlbl=="MN";
replace ent09=226 if stlbl=="IA"; replace emp09=11274 if stlbl=="IA";
replace ent09=494 if stlbl=="MO"; replace emp09=14857 if stlbl=="MO";
replace ent09=107 if stlbl=="ND"; replace emp09=2559 if stlbl=="ND";
replace ent09=107 if stlbl=="SD"; replace emp09=2559 if stlbl=="SD";
replace ent09=9 if stlbl=="NE"; replace emp09=162 if stlbl=="NE";
replace ent09=238 if stlbl=="KS"; replace emp09=9831 if stlbl=="KS";
replace ent09=11 if stlbl=="DE"; replace emp09=128 if stlbl=="DE";
replace ent09=161 if stlbl=="MD"; replace emp09=5628 if stlbl=="MD";
replace ent09=216 if stlbl=="VA"; replace emp09=14547 if stlbl=="VA";
replace ent09=1325 if stlbl=="WV"; replace emp09=88510 if stlbl=="WV";
replace ent09=106 if stlbl=="NC"; replace emp09=1890 if stlbl=="NC";
replace ent09=20 if stlbl=="SC"; replace emp09=933 if stlbl=="SC";
replace ent09=82 if stlbl=="GA"; replace emp09=2307 if stlbl=="GA";
replace ent09=55 if stlbl=="FL"; replace emp09=3372 if stlbl=="FL";
replace ent09=864 if stlbl=="KY"; replace emp09=41444 if stlbl=="KY";
replace ent09=263 if stlbl=="TN"; replace emp09=14470 if stlbl=="TN";
replace ent09=348 if stlbl=="AL"; replace emp09=32579 if stlbl=="AL";
replace ent09=126 if stlbl=="AR"; replace emp09=3614 if stlbl=="AR";
replace ent09=4 if stlbl=="LA"; replace emp09=387 if stlbl=="LA";
replace ent09=4 if stlbl=="MS"; replace emp09=387 if stlbl=="MS";
replace ent09=284 if stlbl=="OK"; replace emp09=12734 if stlbl=="OK";
replace ent09=81 if stlbl=="TX"; replace emp09=4565 if stlbl=="TX";
replace ent09=269 if stlbl=="MT"; replace emp09=16091 if stlbl=="MT";
replace ent09=83 if stlbl=="ID"; replace emp09=2455 if stlbl=="ID";
replace ent09=87 if stlbl=="WY"; replace emp09=7532 if stlbl=="WY";
replace ent09=523 if stlbl=="CO"; replace emp09=16710 if stlbl=="CO";
replace ent09=103 if stlbl=="NM"; replace emp09=7100 if stlbl=="NM";
replace ent09=172 if stlbl=="AZ"; replace emp09=15268 if stlbl=="AZ";
replace ent09=154 if stlbl=="UT"; replace emp09=9847 if stlbl=="UT";
replace ent09=207 if stlbl=="NV"; replace emp09=4231 if stlbl=="NV";
replace ent09=93 if stlbl=="WA"; replace emp09=5050 if stlbl=="WA";
replace ent09=52 if stlbl=="OR"; replace emp09=740 if stlbl=="OR";
replace ent09=357 if stlbl=="CA"; replace emp09=7000 if stlbl=="CA";
tab stlbl if ent09==.;
gen size09=(emp09a+emp09)/(ent09a+ent09); format size09 %8.1f;
gsort -size09; list pmsal size09; *replace size09=150 if size09>150 & size!=.; 
replace ent09=(ent09+ent09a)/2/area; replace ent09=1 if ent09<1; *replace ent09=40 if ent09>40;
for any ent09 size09 emp09: gen lX=ln(X);

*** Add coal mines data;
ren pmsa msa; sort msa; merge msa using ./data/msamines_coal, nok;
tab _m; drop _m centralcity msaname; ren msa pmsa;
sum mines_*; renpfix mines_ COAL;
for any 25 50 75 100 150 250 500: ren COALX_ COALX;
for any 50 100 250 500: gen TOTX=COALX+MTX_00b;
for var COAL*: gen lX=ln(1+X);
for var TOT*: gen lX=ln(X);
sum COAL* TOT*; gen COALIRON100=COAL100+MI100_00;

*** Add anthracite/bit share estimates;
log off; gen CSH150=0;
for any 80 160 200 240 280 440 450 480 500 520 560 720 860 870 875 880 960 1000 1020 1040 1080 1123 1125 1150 1280
1320 1350 1360 1400 1480 1520 1540 1560 1580 1600 1640 1660 1680 1720 1740 1800 1840 1900 1920 1950 1960 2000 2040
2080 2120 2160 2200 2320 2330 2335 2340 2360 2440 2580 2640 2650 2670 2720 2760 2880 2960 3000 3040 3060 3120 3160
3180 3200 3240 3283 3290 3400 3440 3480 3500 3520 3580 3620 3640 3660 3680 3710 3720 3740 3760 3840 3850 3920 4000
4040 4100 4150 4280 4320 4360 4400 4420 4520 4640 4720 4800 4920 5015 5190 5240 5280 5360 5380 5483 5523 5600 5640 5720
5880 5910 5920 5990 6020 6120 6160 6240 6280 6323 6403 6440 6483 6520 6560 6640 6660 6680 6740 6760 6800 6840 6880
6960 7000 7040 7080 7160 7490 7560 7600 7610 7490 7560 7600 7610 7640 7680 7720 7800 7880 7920 8003 8050 8080 8160
8200 8320 8360 8400 8440 8480 8560 8600 8640 8680 8760 8840 8920 9000 9040 9140 9160 9260 9280 9320:
\ replace CSH150=1 if pmsa==X; 
gen CSH250=CSH150; for any 120 220 320 460 600 733 920 1010 1303 1760 2180 2290 2400 2560 2655 2750 2800 2975 3080 
3560 3605 3800 3870 4120 4200 4243 4600 4680 5080 5120 5160 5200 5800 6015 6080 6200 6600 6820 7620 7760 7840 8240
8520 8800 9080 9200: replace CSH250=1 if pmsa==X; 
log on; tab CSH150; tab CSH250;

*** Add trend;
sort pmsa; merge pmsa using ./data/CMF6382, nok; tab _m; drop _m;

***********************************************************;
*** DESCRIBE DATA AND UNDERTAKE FINAL PREPARATIONS       **;
***********************************************************;

*** Correlations of entr metrics;
pwcorr lALsize8202 lALMsize8202 lALNsize8202 lBSHempT8202 lBSHctT8202 lSH1982, star(.1);
plot GRemp8202T lALsize8202; plot GRemp8202T lBSHempT8202; plot GRemp8202T lBSHctT8202;
plot lALsize8202 lBSHempT8202; plot lALNsize8202 lBSHempT8202; plot lALNsize8202 lBSHctT8202;
plot lALsize8202 MT500_00b; plot lBSHempT8202 MT500_00b;

*** Summarize mining data - Table A2;
gen COAL250d=COAL250-COAL100; gen COAL500d=COAL500-COAL250;
*for var MT100_00b MT250_00b MT500_00b MT250_00d MT500_00d
        MI100_00 MI250_00 MI500_00 MI250_00d MI500_00d
        MO100_00 MO250_00 MO500_00 MO250_00d MO500_00d
        COAL100 COAL250 COAL500 COAL250d COAL500d:
\ sum X \ gsort -X \ list pmsal X in 1/5;
drop COAL250d COAL500d;

*** Apply 2% trim to OLS data and generate squares;
gen lMT250_00b=ln(1+MT250_00b);
log off;
for var GRemp* GRct* GRpay* GRwage* lSZ* lC63* lC67rt lAL* lB* lSH*
        lbaPct1970 lhou lden lpop lJul lJan lret*
        lMT500_00b top09 MI100_00
        MT500_00b MT250_00b MT100_00b MT50_00b MT500_00c2 MO100_00 lMT500b lMT250_00b lMT500_00
        MT500_00d MT250_00d MT100_00d MI100
        lMT500b coal coal69 COAL* lCOAL*:
\ egen temp1=pctile(X), p(98) \ replace X=temp1 if X>temp1 & X!=. \ drop temp1
\ egen temp1=pctile(X), p(02) \ replace X=temp1 if X<temp1 & X!=. \ drop temp1;
for var lALemp*: gen XSQ=X^2;
log on;

*** Prepare residuals;
* Common IV variants: lMT500_00b MT500_00c2 MT100_00b/MT500_00b MI100_00 coal69>400
                      lent09 lsize09 coal top09 MT100_00b==0;
gen CIV1=CSH150; gen CIV2=lCOAL150; gen CIV3=1; 
log off;
for any GRemp8202T GRpaytr8202T GRwage28202T
        GRemp8202M GRemp8202N GRemp8202A1 GRemp8202A2 GRemp8202A3 GRemp8202A4
        lALsize8202 lBSHempT8202 lALMsize8202 lALNsize8202 lC63sz lT0_emp_500
        lMT500_00b top09 MI100_00
	MT100_00b MT500_00c2 MT500_00d MT250_00d MT100_00d MT50_00b lMT500b lMT250_00b
	CSH150 CIV1 CIV2 CIV3:
\ regress X lALemp8202 lALemp8202SQ _I* \ predict R1X, residual
\ regress X lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I* \ predict R2X, residual;
for any GRemp8292T lALsize8292 lBSHempT8292:
\ regress X lALemp8292 lALemp8292SQ _I* \ predict R1X, residual
\ regress X lALemp8292 lALemp8292SQ lbaPct1970 lhou lden lpop lJul lJan _I* \ predict R2X, residual;
for any GRemp9202T lALsize9202 lBSHempT9202:
\ regress X lALemp9202 lALemp9202SQ _I* \ predict R1X, residual
\ regress X lALemp9202 lALemp9202SQ lbaPct1970 lhou lden lpop lJul lJan _I* \ predict R2X, residual;
log on;

*** Correlations of entr metrics - Table 1;
pwcorr lALsize8202 lALMsize8202 lALNsize8202 lBSHempT8202 lBSHctT8202 lSH1982, star(.1);
plot GRemp8202T lALsize8202; plot GRemp8202T lBSHempT8202; plot GRemp8202T lBSHctT8202;
plot lALsize8202 lBSHempT8202; plot lALNsize8202 lBSHempT8202; plot lALNsize8202 lBSHctT8202;
plot lALsize8202 MT500_00b; plot lBSHempT8202 MT500_00b;

log close;
log using gr-sic1-5yr-3-disclose.log, replace;

***********************************************************;
*** OLS REGRESSIONS - NON-PROJECTED, BOOTSTRAP           **;
***********************************************************;
* Archive contains many sub-variants;

*** OLS Estimates - Table 2 and A1;
set seed 1;
for any 8202:
\ regress GRempXT lALsizeX, vce(boot, rep(100))
\ areg GRempXT lALsizeX lALempX lALempXSQ, a(r9) vce(boot, rep(100))
\ areg GRempXT lALsizeX lALempX lALempXSQ lbaPct1970 lhou lden lpop lJul lJan, a(r9) vce(boot, rep(100))
\ regress GRpaytrXT lALsizeX, vce(boot, rep(100))
\ areg GRpaytrXT lALsizeX lALempX lALempXSQ, a(r9) vce(boot, rep(100))
\ areg GRpaytrXT lALsizeX lALempX lALempXSQ lbaPct1970 lhou lden lpop lJul lJan, a(r9) vce(boot, rep(100))
\ regress GRwage2XT lALsizeX, vce(boot, rep(100))
\ areg GRwage2XT lALsizeX lALempX lALempXSQ, a(r9) vce(boot, rep(100))
\ areg GRwage2XT lALsizeX lALempX lALempXSQ lbaPct1970 lhou lden lpop lJul lJan, a(r9) vce(boot, rep(100))
\ regress GRempXT lBSHempTX, vce(boot, rep(100))
\ areg GRempXT lBSHempTX lALempX lALempXSQ, a(r9) vce(boot, rep(100))
\ areg GRempXT lBSHempTX lALempX lALempXSQ lbaPct1970 lhou lden lpop lJul lJan, a(r9) vce(boot, rep(100))
\ regress GRpaytrXT lBSHempTX, vce(boot, rep(100))
\ areg GRpaytrXT lBSHempTX lALempX lALempXSQ, a(r9) vce(boot, rep(100))
\ areg GRpaytrXT lBSHempTX lALempX lALempXSQ lbaPct1970 lhou lden lpop lJul lJan, a(r9) vce(boot, rep(100))
\ regress GRwage2XT lBSHempTX, vce(boot, rep(100))
\ areg GRwage2XT lBSHempTX lALempX lALempXSQ, a(r9) vce(boot, rep(100))
\ areg GRwage2XT lBSHempTX lALempX lALempXSQ lbaPct1970 lhou lden lpop lJul lJan, a(r9) vce(boot, rep(100));
for any 8292 9202:
\ regress GRempXT lALsizeX, vce(boot, rep(100))
\ areg GRempXT lALsizeX lALempX lALempXSQ, a(r9) vce(boot, rep(100))
\ areg GRempXT lALsizeX lALempX lALempXSQ lbaPct1970 lhou lden lpop lJul lJan, a(r9) vce(boot, rep(100))
\ regress GRempXT lBSHempTX, vce(boot, rep(100))
\ areg GRempXT lBSHempTX lALempX lALempXSQ, a(r9) vce(boot, rep(100))
\ areg GRempXT lBSHempTX lALempX lALempXSQ lbaPct1970 lhou lden lpop lJul lJan, a(r9) vce(boot, rep(100));

*** OLS Estimates - Table 3;
set seed 1;
for any lALsize8202 lBSHempT8202: gen WX=warm*X;
for any lALsize8202 lBSHempT8202:
\ areg GRemp8202T X lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan, a(r9) vce(boot, rep(100))
\ areg GRemp8202T X WX lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan, a(r9) vce(boot, rep(100)) \ lincom X+WX
\ areg GRemp8202M X lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan, a(r9) vce(boot, rep(100))
\ areg GRemp8202M X WX lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan, a(r9) vce(boot, rep(100)) \ lincom X+WX
\ areg GRemp8202N X lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan, a(r9) vce(boot, rep(100))
\ areg GRemp8202N X WX lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan, a(r9) vce(boot, rep(100)) \ lincom X+WX
\ areg GRemp8202A1 X lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan, a(r9) vce(boot, rep(100))
\ areg GRemp8202A1 X WX lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan, a(r9) vce(boot, rep(100)) \ lincom X+WX
\ areg GRemp8202A2 X lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan, a(r9) vce(boot, rep(100))
\ areg GRemp8202A2 X WX lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan, a(r9) vce(boot, rep(100)) \ lincom X+WX
\ areg GRemp8202A3 X lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan, a(r9) vce(boot, rep(100))
\ areg GRemp8202A3 X WX lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan, a(r9) vce(boot, rep(100)) \ lincom X+WX
\ areg GRemp8202A4 X lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan, a(r9) vce(boot, rep(100))
\ areg GRemp8202A4 X WX lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan, a(r9) vce(boot, rep(100)) \ lincom X+WX;

*** OLS Estimates - Table 3 with warm;
set seed 1;
for any lALsize8202 lBSHempT8202:
\ areg GRemp8202T X lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop warm, a(r9) vce(boot, rep(100))
\ areg GRemp8202T X WX lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop warm, a(r9) vce(boot, rep(100)) \ lincom X+WX
\ areg GRemp8202M X lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop warm, a(r9) vce(boot, rep(100))
\ areg GRemp8202M X WX lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop warm, a(r9) vce(boot, rep(100)) \ lincom X+WX
\ areg GRemp8202N X lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop warm, a(r9) vce(boot, rep(100))
\ areg GRemp8202N X WX lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop warm, a(r9) vce(boot, rep(100)) \ lincom X+WX
\ areg GRemp8202A1 X lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop warm, a(r9) vce(boot, rep(100))
\ areg GRemp8202A1 X WX lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop warm, a(r9) vce(boot, rep(100)) \ lincom X+WX
\ areg GRemp8202A2 X lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop warm, a(r9) vce(boot, rep(100))
\ areg GRemp8202A2 X WX lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop warm, a(r9) vce(boot, rep(100)) \ lincom X+WX
\ areg GRemp8202A3 X lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop warm, a(r9) vce(boot, rep(100))
\ areg GRemp8202A3 X WX lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop warm, a(r9) vce(boot, rep(100)) \ lincom X+WX
\ areg GRemp8202A4 X lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop warm, a(r9) vce(boot, rep(100))
\ areg GRemp8202A4 X WX lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop warm, a(r9) vce(boot, rep(100)) \ lincom X+WX;

***********************************************************;
*** RF AND INTERMEDIATE FS REGRESSIONS - BOOTSTRAP       **;
***********************************************************;
* RF Estimates Archived / Not Reported;

*** Intermediate FS Estimates - Table 6;
set seed 1;
for any lC63sz lT0_emp_500 lALsize8202 lALMsize8202 lALNsize8202 lBSHempT8202:
\ regress X lMT500_00b lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ regress X lMT500_00b top09 lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ regress X MT500_00c2 MT100_00b lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ regress X CSH150 lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100));
for any lALsize8202 lBSHempT8202:
\ regress X MT500_00d MT250_00d MT100_00d MT50_00b lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ regress X MT500_00d MT250_00d MT100_00b lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100));
set seed 1;
for any lC63sz lT0_emp_500 lALsize8202 lALMsize8202 lALNsize8202 lBSHempT8202:
\ regress X lMT250_00b lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100));

***********************************************************;
*** PRIMARY IV APPROACH - NON-PROJECTED, BOOTSTRAP, 500  **;
***********************************************************;

*** Triple IV Base - Table 7/8 full sample;
set seed 1;
for any lALsize8202 lBSHempT8202:
\ * Basics 
\ ivregress 2sls GRemp8202T (X=lMT500_00b) 
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust
\ ivregress 2sls GRemp8202T (X=lMT500_00b top09) 
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust
\ ivregress 2sls GRemp8202T (X=lMT500_00b top09 MI100_00) 
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust
\ ivregress 2sls GRemp8202M (X=lMT500_00b top09 MI100_00) 
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust
\ ivregress 2sls GRemp8202N (X=lMT500_00b top09 MI100_00) 
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust
\ ivregress 2sls GRemp8202A1 (X=lMT500_00b top09 MI100_00) 
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust
\ ivregress 2sls GRemp8202A2 (X=lMT500_00b top09 MI100_00) 
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust
\ ivregress 2sls GRemp8202A3 (X=lMT500_00b top09 MI100_00) 
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust
\ ivregress 2sls GRemp8202A4 (X=lMT500_00b top09 MI100_00) 
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust;

*** Triple IV Base - Xtra;
set seed 1;
for any lALsize8202 lBSHempT8202:
\ * Basics 
\ ivregress 2sls GRemp8202T (X=top09) 
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust
\ ivregress 2sls GRemp8202T (X=MI100_00) 
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust
\ ivregress 2sls GRemp8202T (X=top09 MI100_00) 
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust
\ ivregress 2sls GRemp8202T (X=lMT500_00b MI100_00) 
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust;

*** Triple IV Base - App Table Warm/Cold Joint;
set seed 1;
preserve; 
for any lALsize8202 lBSHempT8202:
\ ivregress 2sls GRemp8202T (X WX=lMT500_00b top09 MI100_00)
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust \ lincom X+WX
\ ivregress 2sls GRemp8202M (X WX=lMT500_00b top09 MI100_00)
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust \ lincom X+WX
\ ivregress 2sls GRemp8202N (X WX=lMT500_00b top09 MI100_00)
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust \ lincom X+WX
\ ivregress 2sls GRemp8202A1 (X WX=lMT500_00b top09 MI100_00)
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust \ lincom X+WX
\ ivregress 2sls GRemp8202A2 (X WX=lMT500_00b top09 MI100_00)
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust \ lincom X+WX
\ ivregress 2sls GRemp8202A3 (X WX=lMT500_00b top09 MI100_00)
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust \ lincom X+WX
\ ivregress 2sls GRemp8202A4 (X WX=lMT500_00b top09 MI100_00)
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust \ lincom X+WX;
restore;

*** Triple IV Base - App Table Warm/Cold Joint;
set seed 1;
preserve; 
for any lALsize8202 lBSHempT8202:
\ ivregress 2sls GRemp8202T (X WX=lMT500_00b top09 MI100_00)
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop warm _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust \ lincom X+WX
\ ivregress 2sls GRemp8202M (X WX=lMT500_00b top09 MI100_00)
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop warm _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust \ lincom X+WX
\ ivregress 2sls GRemp8202N (X WX=lMT500_00b top09 MI100_00)
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop warm _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust \ lincom X+WX
\ ivregress 2sls GRemp8202A1 (X WX=lMT500_00b top09 MI100_00)
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop warm _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust \ lincom X+WX
\ ivregress 2sls GRemp8202A2 (X WX=lMT500_00b top09 MI100_00)
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop warm _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust \ lincom X+WX
\ ivregress 2sls GRemp8202A3 (X WX=lMT500_00b top09 MI100_00)
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop warm _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust \ lincom X+WX
\ ivregress 2sls GRemp8202A4 (X WX=lMT500_00b top09 MI100_00)
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop warm _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust \ lincom X+WX;
restore;

***********************************************************;
*** PRIMARY IV APPROACH - NON-PROJECTED, BOOTSTRAP, 250  **;
***********************************************************;

*** Triple IV Base - Table 7/8 full sample;
set seed 1;
for any lALsize8202 lBSHempT8202:
\ * Basics 
\ ivregress 2sls GRemp8202T (X=lMT250_00b) 
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust
\ ivregress 2sls GRemp8202T (X=lMT250_00b top09) 
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust
\ ivregress 2sls GRemp8202T (X=lMT250_00b top09 MI100_00) 
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust
\ ivregress 2sls GRemp8202M (X=lMT250_00b top09 MI100_00) 
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust
\ ivregress 2sls GRemp8202N (X=lMT250_00b top09 MI100_00) 
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust
\ ivregress 2sls GRemp8202A1 (X=lMT250_00b top09 MI100_00) 
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust
\ ivregress 2sls GRemp8202A2 (X=lMT250_00b top09 MI100_00) 
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust
\ ivregress 2sls GRemp8202A3 (X=lMT250_00b top09 MI100_00) 
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust
\ ivregress 2sls GRemp8202A4 (X=lMT250_00b top09 MI100_00) 
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust;

*** Triple IV Base - Xtra;
set seed 1;
for any lALsize8202 lBSHempT8202:
\ * Basics 
\ ivregress 2sls GRemp8202T (X=top09) 
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust
\ ivregress 2sls GRemp8202T (X=MI100_00) 
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust
\ ivregress 2sls GRemp8202T (X=top09 MI100_00) 
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust
\ ivregress 2sls GRemp8202T (X=lMT250_00b MI100_00) 
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust;

*** Triple IV Base - App Table Warm/Cold Joint;
set seed 1;
preserve; 
for any lALsize8202 lBSHempT8202:
\ ivregress 2sls GRemp8202T (X WX=lMT250_00b top09 MI100_00)
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust \ lincom X+WX
\ ivregress 2sls GRemp8202M (X WX=lMT250_00b top09 MI100_00)
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust \ lincom X+WX
\ ivregress 2sls GRemp8202N (X WX=lMT250_00b top09 MI100_00)
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust \ lincom X+WX
\ ivregress 2sls GRemp8202A1 (X WX=lMT250_00b top09 MI100_00)
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust \ lincom X+WX
\ ivregress 2sls GRemp8202A2 (X WX=lMT250_00b top09 MI100_00)
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust \ lincom X+WX
\ ivregress 2sls GRemp8202A3 (X WX=lMT250_00b top09 MI100_00)
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust \ lincom X+WX
\ ivregress 2sls GRemp8202A4 (X WX=lMT250_00b top09 MI100_00)
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust \ lincom X+WX;
restore;

*** Triple IV Base - App Table Warm/Cold Joint;
set seed 1;
preserve; 
for any lALsize8202 lBSHempT8202:
\ ivregress 2sls GRemp8202T (X WX=lMT250_00b top09 MI100_00)
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop warm _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust \ lincom X+WX
\ ivregress 2sls GRemp8202M (X WX=lMT250_00b top09 MI100_00)
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop warm _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust \ lincom X+WX
\ ivregress 2sls GRemp8202N (X WX=lMT250_00b top09 MI100_00)
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop warm _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust \ lincom X+WX
\ ivregress 2sls GRemp8202A1 (X WX=lMT250_00b top09 MI100_00)
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop warm _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust \ lincom X+WX
\ ivregress 2sls GRemp8202A2 (X WX=lMT250_00b top09 MI100_00)
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop warm _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust \ lincom X+WX
\ ivregress 2sls GRemp8202A3 (X WX=lMT250_00b top09 MI100_00)
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop warm _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust \ lincom X+WX
\ ivregress 2sls GRemp8202A4 (X WX=lMT250_00b top09 MI100_00)
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop warm _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust \ lincom X+WX;
restore;

***********************************************************;
*** IV FINALES                                           **;
***********************************************************;

*** Triple IV Base - Table 7 Variants;
set seed 1;
*for any lALsize8202 lBSHempT8202:
\ * Basics 
\ ivregress 2sls GRemp8202T (X=top09) 
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust
\ ivregress 2sls GRemp8202T (X=lCOAL250) 
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust
\ ivregress 2sls GRemp8202T (X=CSH150) 
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust
\ ivregress 2sls GRemp8202T (X=lMT500_00b lCOAL250 MI100_00) 
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust
\ ivregress 2sls GRemp8202T (X=lMT500_00b CSH150 MI100_00) 
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust
\ ivregress 2sls GRemp8202T (X=lMT500b CSH150) 
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust
\ ivregress 2sls GRemp8202T (X=lMT500b CSH150 MI100) 
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust
\ ivregress 2sls GRemp8202T (X=lMT500_00 top09 MI100_00 lMT250_00b) 
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust;
set seed 1;

set seed 1;
for any lALsize8202 lBSHempT8202:
\ ivregress 2sls GRemp8202T (X=lMT250_00b)
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust;

***********************************************************;
*** IV EXTRAS FROM THE XXX-4.do FILE                     **;
***********************************************************;

**** Use final file;
use ./data/gr-sic1-5yr-3-save3, clear;

*** Merge in covariates again;
for any pop dens hous baPct: cap n sum X* \ cap n drop X*;
sort pmsa; merge pmsa using ./data/pmsa-covariates, nok keep(pop* dens* hous* baPct*);
tab _m; drop if _m==2; drop _m;
for var pop* dens* hous* baPct*: gen zlX=ln(X);

*** Merge in other employment growth data;
sort pmsa; merge pmsa using ./data-panel/pmsa-inc100gr2, keep(incIgr); tab _m; drop _m;

*** Apply 2% trim to OLS data and generate squares;
log off;
for var lT0_*: replace X=0 if X==.;
for var zl* lT0_* incIgr:
\ egen temp1=pctile(X), p(98) \ replace X=temp1 if X>temp1 & X!=. \ drop temp1
\ egen temp1=pctile(X), p(02) \ replace X=temp1 if X<temp1 & X!=. \ drop temp1;
log on;

*** Extended outcomes;
xi i.r9;
set seed 1;
for any incNgr incIgr:
\ areg X lALsize8202 lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan, a(r9) vce(boot, rep(100))
\ ivregress 2sls X (lALsize8202=lMT500_00b top09 MI100_00)
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust
\ ivregress 2sls X (lALsize8202=lMT250_00b top09 MI100_00)
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust
\ areg X lBSHempT8202 lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan, a(r9) vce(boot, rep(100))
\ ivregress 2sls X (lBSHempT8202=lMT500_00b top09 MI100_00)
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust
\ ivregress 2sls X (lBSHempT8202=lMT250_00b top09 MI100_00)
       lALemp8202 lALemp8202SQ lbaPct1970 lhou lden lpop lJul lJan _I*, vce(boot, rep(100))
\ estat endogenous, forcenonrobust \ estat firststage, forcenonrobust \ cap n estat overid, forcenonrobust;

*** End of Program;
cap n log close; 

***********************************************************;
***********************************************************;
*** SAVED MATERIALS                                      **;
***********************************************************;
***********************************************************;
