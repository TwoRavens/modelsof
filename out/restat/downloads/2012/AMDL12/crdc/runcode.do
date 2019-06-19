#delimit;
clear;
set more off;
set mem 2000m; 
set matsize 200;
cd "/rdcprojects/mc1/mc00595/temp/RESTAT_revision";

*program drop allcode;
program allcode, rclass;

*--------------------------------------------------*
*-------- GENERATE PROPENSITY SCORES --------------*
*--------------------------------------------------*;
*COMBINE SOME OF INDICATORS;
gen Y90bedrooms12=Y90BR1+Y90BR2;
gen Y90bedrooms34=Y90BR3+Y90BR4;
gen Y90builtlast5yrs=Y90BAGE1+Y90BAGE2;
gen Y90builtlast10yrs=Y90BAGE1+Y90BAGE2+Y90BAGE3; 

*USE SUBSET OF AVAILABLE YEARS;
replace near=0; replace near=1 if distance<2 & yearonline>=1993 & yearonline<=2000;

*RUN LOGIT REGRESSION;
logit near Y90hinc* Y90nphu* Y90nrc* Y90p65* Y90hsgrad Y90collegegrad Y90black Y90hispanic 
	           Y90occupied Y90owneroccupied Y90bedrooms12 Y90bedrooms34 Y90builtlast5yrs 
	           Y90builtlast10yrs Y90Bscplumb Y90Bacre1 Y90Bacre10 Y90multiunit;
predict pr, pr; 
drop Y90bedrooms12 Y90bedrooms34 Y90builtlast5yrs Y90builtlast10yrs;

*CALCULATE PROPENSITY WEIGHTS;
quietly gen zweight=pr/(1-pr); quietly replace zweight=hwt_tot if near==1; 
quietly sum zweight if near==1; quietly replace zweight=zweight/r(mean) if near==1;  
quietly sum zweight if near==0; quietly replace zweight=zweight/r(mean) if near==0;

*--------------------------------------------------*
*----TABLE 1: COMPARISON OF COVARIATES, 1990-------*
*--------------------------------------------------*;

*COMBINE SOME OF INDICATORS;
gen Y90bedrooms12=Y90BR1+Y90BR2;
gen Y90bedrooms34=Y90BR3+Y90BR4;
gen Y90builtlast5yrs=Y90BAGE1+Y90BAGE2;
gen Y90builtlast10yrs=Y90BAGE1+Y90BAGE2+Y90BAGE3; 
gen Y90value=exp(logY90value);
gen Y90rent=exp(logY90rent);

*CREATE A LOCAL FOR ALL RELEVANT COVARIATES;
local vars Y90hinc Y90nphu Y90nrc Y90p65 Y90hsgrad Y90collegegrad Y90black Y90hispanic 
      Y90value Y90rent Y90occupied Y90owneroccupied Y90bedrooms12 Y90bedrooms3
      Y90builtlast5yrs Y90builtlast10yrs Y90Bscplumb Y90Bacre1 Y90Bacre10 Y90multiunit;

*REPORT COVARIATES FOR 0-2 MILE NEIGHBORHOODS;
tabstat `vars' if near==1, stats(mean) column(stats);

*REPORT NUMBER OF HOUSING UNITS IN 1990 WITHIN TWO MILES;
sum hwt_tot90 if near==1;

*REPORT COVARIATES FOR POPULATION;
tabstat `vars' if near==0, stats(mean) column(stats);
quietly foreach x of local vars {; sum `x'; local PU`x'=r(mean); };

*REPORT COVARIATES FOR POPULATION, WEIGHTED;
tabstat `vars' [aweight=zweight] if near==0, stats(mean) column(stats);
quietly foreach x of local vars {; sum `x' [aweight=zweight]; local PW`x'=r(mean); };

*PERFORM T-TEST WITH RESPECT TO POPULATION;
foreach x of local vars {;   
quietly ttest `x'=`PU`x'' if near==1; 
display ""; display "Compare Mean of `x' to Population Mean"; 
display "P-Value Under Two Sided Test: ", round(`r(p)',.01); };

*PERFORM T-TEST WITH RESPECT TO POPULATION, WEIGHTED;
foreach x of local vars {; 
quietly ttest `x'=`PW`x'' if near==1; 
display ""; display "Compare Mean of `x' to Population Mean (Weighted)"; 
display "P-Value Under Two Sided Test: ", round(`r(p)',.01); };

*DROP COVARIATES YOU DON'T NEED;
drop Y90bedrooms12 Y90bedrooms34 Y90builtlast5yrs Y90builtlast10yrs Y90value Y90rent;

*--------------------------------------------------*
*-----------TABLE 2: MAIN RESULTS------------------*
*--------------------------------------------------*;

*REPORT NUMBER OF PLANTS;
quietly tab orispl if yearonline>=1993 & yearonline<=2000; local nplants=r(r); display "THE FOLLOWING REGRESSIONS ARE BASED ON `nplants' PLANTS";

*HOUSING VALUES;
quietly reg  logY00value near logY90value                [aweight=zweight], cluster(trct); lincom _b[near]; display e(N); display round(e(r2),.01); return scalar value1=r(estimate);
quietly areg logY00value near logY90value Y90*           [aweight=zweight], absorb(cnty) cluster(trct); lincom _b[near]; display e(N); display round(e(r2),.01); return scalar value2=r(estimate);
quietly areg logY00value near logY90value Y90* Y80* Y70* [aweight=zweight], absorb(cnty) cluster(trct); lincom _b[near]; display e(N); display round(e(r2),.01); return scalar value3=r(estimate);   

*RENTS;
quietly reg  logY00rent near logY90rent                 [aweight=zweight], cluster(trct); lincom _b[near]; display e(N); display round(e(r2),.01); return scalar rent1=r(estimate);
quietly areg logY00rent near logY90rent  Y90*           [aweight=zweight], absorb(cnty) cluster(trct); lincom _b[near]; display e(N); display round(e(r2),.01); return scalar rent2=r(estimate);
quietly areg logY00rent near logY90rent  Y90* Y80* Y70* [aweight=zweight], absorb(cnty) cluster(trct); lincom _b[near]; display e(N); display round(e(r2),.01); return scalar rent3=r(estimate);


*---------------------------------------*
*---- A. ALTERNATIVE SPECIFICATIONS-----*
*---------------------------------------*;
display "GAS PLANTS ONLY";
quietly tab orispl if gasplant==1 & yearonline>=1993 & yearonline<=2000; local nplants=r(r); display "THE FOLLOWING REGRESSIONS ARE BASED ON `nplants' PLANTS";
quietly areg logY00value near logY90value Y90* [aweight=zweight] if gasplant==1 | distance>2, absorb(cnty) cluster(trct); lincom _b[near]; display e(N); return scalar value4=r(estimate);
quietly areg logY00rent  near logY90rent  Y90* [aweight=zweight] if gasplant==1 | distance>2, absorb(cnty) cluster(trct); lincom _b[near]; display e(N); return scalar rent4=r(estimate);

display "PLANTS OPENED 1993-1999";
gen nearALT=0; replace nearALT=1 if distance<2 & yearonline>=1993 & yearonline<=1999;
quietly tab orispl if yearonline>=1993 & yearonline<=1999; local nplants=r(r); display "THE FOLLOWING REGRESSIONS ARE BASED ON `nplants' PLANTS";
quietly areg logY00value nearALT logY90value Y90* [aweight=zweight], absorb(cnty) cluster(trct); lincom _b[nearALT]; display e(N); return scalar value5=r(estimate);
quietly areg logY00rent  nearALT logY90rent  Y90* [aweight=zweight], absorb(cnty) cluster(trct); lincom _b[nearALT]; display e(N); return scalar rent5=r(estimate);

display "PLANTS OPENED 1994-2000";
replace nearALT=0; replace nearALT=1 if distance<2 & yearonline>=1994 & yearonline<=2000;
quietly tab orispl if yearonline>=1994 & yearonline<=2000; local nplants=r(r); display "THE FOLLOWING REGRESSIONS ARE BASED ON `nplants' PLANTS";
quietly areg logY00value nearALT logY90value Y90* [aweight=zweight], absorb(cnty) cluster(trct); lincom _b[nearALT]; display e(N); return scalar value6=r(estimate);
quietly areg logY00rent  nearALT logY90rent  Y90* [aweight=zweight], absorb(cnty) cluster(trct); lincom _b[nearALT]; display e(N); return scalar rent6=r(estimate);
quietly drop nearALT;

display "LARGE CAPACITY PLANTS ONLY";
bysort orispl: gen n=_n; quietly sum namepcap if n==1 & yearonline>=1993 & yearonline<=2000, detail;
local mediancap=r(p50); drop n;
quietly tab orispl if yearonline>=1993 & yearonline<=2000 & namepcap>`mediancap'; local nplants=r(r); display `nplants';
quietly areg logY00value near logY90value Y90* [aweight=zweight] if namepcap>`mediancap' | distance>2, absorb(cnty) cluster(trct); lincom _b[near]; display e(N); return scalar valueBIG=r(estimate);
quietly areg logY00rent  near logY90rent  Y90* [aweight=zweight] if namepcap>`mediancap' | distance>2, absorb(cnty) cluster(trct); lincom _b[near]; display e(N); return scalar rentBIG=r(estimate);

display "SMALL CAPACITY PLANTS ONLY";
quietly tab orispl if yearonline>=1993 & yearonline<=2000 & namepcap<=`mediancap'; local nplants=r(r); display `nplants';
quietly areg logY00value near logY90value Y90* [aweight=zweight] if namepcap<=`mediancap' | distance>2, absorb(cnty) cluster(trct); lincom _b[near]; display e(N); return scalar valueSMALL=r(estimate);
quietly areg logY00rent  near logY90rent  Y90* [aweight=zweight] if namepcap<=`mediancap' | distance>2, absorb(cnty) cluster(trct); lincom _b[near]; display e(N); return scalar rentSMALL=r(estimate);

*-----------------------------------*
*---- C. BY TYPE OF HOUSEHOLD-------*
*-----------------------------------*;
display "DOWNWIND HOUSEHOLDS";
quietly areg logY00value near logY90value Y90* [aweight=zweight] if downwind45==1 | distance>2, absorb(cnty) cluster(trct); lincom _b[near]; display e(N); return scalar value7=r(estimate);
quietly areg logY00rent  near logY90rent  Y90* [aweight=zweight] if downwind45==1 | distance>2, absorb(cnty) cluster(trct); lincom _b[near]; display e(N); return scalar rent7=r(estimate);

display "UPWIND HOUSEHOLDS";
quietly areg logY00value near logY90value Y90* [aweight=zweight] if downwind45==0 | distance>2, absorb(cnty) cluster(trct); lincom _b[near]; display e(N); return scalar value8=r(estimate);
quietly areg logY00rent  near logY90rent  Y90* [aweight=zweight] if downwind45==0 | distance>2, absorb(cnty) cluster(trct); lincom _b[near]; display e(N); return scalar rent8=r(estimate);

display "CENSUS BLOCKS WITH HIGH HOUSEHOLD INCOME";
egen TopThird=pctile(Y90hinc) if near==1, p(66.66); sum TopThird; local TopThird=r(mean); drop TopThird;
egen BotThird=pctile(Y90hinc) if near==1, p(33.33); sum BotThird; local BotThird=r(mean); drop BotThird;
quietly areg logY00value near logY90value Y90* [aweight=zweight] if Y90hinc>`TopThird', absorb(cnty) cluster(trct); lincom _b[near]; display e(N); return scalar value9=r(estimate);
quietly areg logY00rent  near logY90rent  Y90* [aweight=zweight] if Y90hinc>`TopThird', absorb(cnty) cluster(trct); lincom _b[near]; display e(N); return scalar rent9=r(estimate);

display "CENSUS BLOCKS WITH MEDIUM HOUSEHOLD INCOME";
quietly areg logY00value near logY90value Y90* [aweight=zweight] if Y90hinc>`BotThird' & Y90hinc<`TopThird', absorb(cnty) cluster(trct); lincom _b[near]; display e(N); return scalar value10=r(estimate);
quietly areg logY00rent  near logY90rent  Y90* [aweight=zweight] if Y90hinc>`BotThird' & Y90hinc<`TopThird', absorb(cnty) cluster(trct); lincom _b[near]; display e(N); return scalar rent10=r(estimate);

display "CENSUS BLOCKS WITH LOW HOUSEHOLD INCOME";
quietly areg logY00value near logY90value Y90* [aweight=zweight] if Y90hinc<`BotThird', absorb(cnty) cluster(trct); lincom _b[near]; display e(N); return scalar value11=r(estimate);
quietly areg logY00rent  near logY90rent  Y90* [aweight=zweight] if Y90hinc<`BotThird', absorb(cnty) cluster(trct); lincom _b[near]; display e(N); return scalar rent11=r(estimate);

quietly reg Y00hsgrad Y00collegegrad;  *JUST TO MAKE SURE ALL OBSERVATIONS INCLUDED IN SAMPLE;

*------------------------------------------*
*----LOCAL NEIGHBORHOOD CHARACTERISTICS----*
*------------------------------------------*;
display "HOUSEHOLD AND HOUSING CHARACTERISTICS";
local varlist hinc hsgrad collegegrad nphu nrc p65 black hispanic occupied owneroccupied;
foreach x of local varlist {;
quietly  reg Y00`x' near Y90`x' [aweight=zweight], cluster(trct); lincom _b[near]; display e(N); return scalar `x'1=r(estimate);
quietly areg Y00`x' near Y90*   [aweight=zweight], absorb(cnty) cluster(trct); lincom _b[near]; display e(N); return scalar `x'2=r(estimate); 
quietly areg Y00`x' near Y90* Y80* Y70* [aweight=zweight], absorb(cnty) cluster(trct); lincom _b[near]; display e(N); return scalar `x'3=r(estimate); };

display "HOUSING SUPPLY AND TOTAL POPULATION"; 
local varlist hwt_tot totpop;    
gen Y90hwt_tot=hwt_tot90; gen Y90totpop=Y90nphu*Y90hwt_tot; replace zweight=1 if near==1;
foreach x of local varlist {; tabstat Y90`x', stats(mean) column(stats); };
foreach x of local varlist {;
quietly  reg `x' near Y90`x' [aweight=zweight], cluster(trct); lincom _b[near]; display e(N); return scalar `x'1=r(estimate); 
quietly areg `x' near Y90*   [aweight=zweight], absorb(cnty) cluster(trct); lincom _b[near]; display e(N); return scalar `x'2=r(estimate); 
quietly areg `x' near Y90* Y80* Y70* [aweight=zweight], absorb(cnty) cluster(trct); lincom _b[near]; display e(N); return scalar `x'3=r(estimate); };
drop Y90hwt_tot Y90totpop;

drop pr zweight;
end program;           	 	                          


*---------------------------------------------------*
*--------RUN BOOTSTRAP OVER ENTIRE CODE-------------*
*---------------------------------------------------*;
use RegressionSampleFullSampleJune.dta, clear;
allcode;
set seed 12345; gen u=uniform(); keep if near==1 | u<.05; drop u;
egen cnty=group(state county); egen trct=group(state county tract);
bootstrap r(value1)  r(rent1)
	  r(value2)  r(rent2)
	  r(value3)  r(rent3)
	  r(value4)  r(rent4)
	  r(value5)  r(rent5)
	  r(value6)  r(rent6)
	  r(valueBIG) r(rentBIG)
	  r(valueSMALL) r(rentSMALL)
          r(value7)  r(rent7)
	  r(value8)  r(rent8)
 	  r(value9)  r(rent9)
	  r(value10) r(rent10)
	  r(value11) r(rent11)
	  r(hinc1) r(hinc2) r(hinc3)
	  r(hsgrad1) r(hsgrad2) r(hsgrad3)  
	  r(collegegrad1) r(collegegrad2) r(collegegrad3)
	  r(nphu1) r(nphu2) r(nphu3)
	  r(nrc1) r(nrc2) r(nrc3)
	  r(p651) r(p652) r(p653)
	  r(black1) r(black2) r(black3)
	  r(hispanic1) r(hispanic2) r(hispanic3)
	  r(occupied1) r(occupied2) r(occupied3)
	  r(owneroccupied1) r(owneroccupied2) r(owneroccupied3)
	  r(hwt_tot1) r(hwt_tot2) r(hwt_tot3)
	  r(totpop1) r(totpop2) r(totpop3),
	  reps(100) cluster(trct) seed(123456789) dots  
          saving(bsmain.dta, every(1) replace): allcode;
use bsmain.dta, clear;
tabstat _bs*, stats(sd) column(stats);

*----------------------------------------*;
*--------PREPARE DATA VALIDITY-----------*;
*----------------------------------------*;
use RegressionSampleValidityJune.dta, clear;
drop Y80* Y70*; egen cnty=group(state county); egen trct=group(state county tract);
save temp4.dta, replace;

*-----------------------------*
*-----VALIDITY TEST 1970s-----*
*-----------------------------*;
program valid70, rclass;  
local x="near70";
gen Y90bedrooms12=Y90BR1+Y90BR2; gen Y90bedrooms34=Y90BR3+Y90BR4;
gen Y90builtlast5yrs=Y90BAGE1+Y90BAGE2; gen Y90builtlast10yrs=Y90BAGE1+Y90BAGE2+Y90BAGE3; 
quietly logit `x'  Y90hinc* Y90nphu* Y90nrc* Y90p65* Y90hsgrad Y90collegegrad Y90black Y90hispanic 
	           Y90occupied Y90owneroccupied Y90bedrooms12 Y90bedrooms34 Y90builtlast5yrs 
	           Y90builtlast10yrs Y90Bscplumb Y90Bacre1 Y90Bacre10 Y90multiunit;
predict pr, pr; drop Y90bedrooms12 Y90bedrooms34 Y90builtlast5yrs Y90builtlast10yrs;
quietly gen zweight=pr/(1-pr); quietly replace zweight=hwt_tot if `x'==1; 
quietly sum zweight if `x'==1; quietly replace zweight=zweight/r(mean) if `x'==1;  
quietly sum zweight if `x'==0; quietly replace zweight=zweight/r(mean) if `x'==0;
quietly tab orispl if yearonline>=1970 & yearonline<1980;
local nplants=r(r); display "THE FOLLOWING REGRESSIONS ARE BASED ON `nplants' PLANTS";
quietly areg logY00value `x' logY90value Y90* [aweight=zweight], absorb(cnty) cluster(trct); lincom _b[`x']; display e(N); return scalar value`x'=r(estimate); 
quietly areg logY00rent  `x' logY90rent  Y90* [aweight=zweight], absorb(cnty) cluster(trct); lincom _b[`x']; display e(N); return scalar rent`x'=r(estimate); 
quietly reg Y00hsgrad Y00collegegrad;  
drop pr zweight; end program; 
use temp4.dta, clear;
gen near70=0; replace near70=1 if distance<2 & yearonline>=1970 & yearonline<1980;
valid70; gen u=uniform(); keep if near70==1 | u<.05; drop u; 
bootstrap r(valuenear70) r(rentnear70), 
	  reps(100) cluster(trct) seed(123456789) dots noheader: valid70;

*-----------------------------*
*-----VALIDITY TEST 1980s-----*
*-----------------------------*;
program valid80, rclass;  
local x="near80";
gen Y90bedrooms12=Y90BR1+Y90BR2; gen Y90bedrooms34=Y90BR3+Y90BR4;
gen Y90builtlast5yrs=Y90BAGE1+Y90BAGE2; gen Y90builtlast10yrs=Y90BAGE1+Y90BAGE2+Y90BAGE3; 
quietly logit `x'  Y90hinc* Y90nphu* Y90nrc* Y90p65* Y90hsgrad Y90collegegrad Y90black Y90hispanic 
	           Y90occupied Y90owneroccupied Y90bedrooms12 Y90bedrooms34 Y90builtlast5yrs 
	           Y90builtlast10yrs Y90Bscplumb Y90Bacre1 Y90Bacre10 Y90multiunit;
predict pr, pr; drop Y90bedrooms12 Y90bedrooms34 Y90builtlast5yrs Y90builtlast10yrs;
quietly gen zweight=pr/(1-pr); quietly replace zweight=hwt_tot if `x'==1; 
quietly sum zweight if `x'==1; quietly replace zweight=zweight/r(mean) if `x'==1;  
quietly sum zweight if `x'==0; quietly replace zweight=zweight/r(mean) if `x'==0;
quietly tab orispl if yearonline>=1980 & yearonline<1990;
local nplants=r(r); display "THE FOLLOWING REGRESSIONS ARE BASED ON `nplants' PLANTS";
quietly areg logY00value `x' logY90value Y90* [aweight=zweight], absorb(cnty) cluster(trct); lincom _b[`x']; display e(N); return scalar value`x'=r(estimate); 
quietly areg logY00rent  `x' logY90rent  Y90* [aweight=zweight], absorb(cnty) cluster(trct); lincom _b[`x']; display e(N); return scalar rent`x'=r(estimate); 
quietly reg Y00hsgrad Y00collegegrad;
drop pr zweight; end program; 
use temp4.dta, clear;
gen near80=0; replace near80=1 if distance<2 & yearonline>=1980 & yearonline<1990;
valid80; gen u=uniform(); keep if near80==1 | u<.05; drop u; 
bootstrap r(valuenear80) r(rentnear80), 
	  reps(100) cluster(trct) seed(123456789) dots noheader: valid80;

*-----------------------------*
*-----VALIDITY TEST 2000s-----*
*-----------------------------*;
program valid00, rclass;  
local x="near00";
gen Y90bedrooms12=Y90BR1+Y90BR2; gen Y90bedrooms34=Y90BR3+Y90BR4;
gen Y90builtlast5yrs=Y90BAGE1+Y90BAGE2; gen Y90builtlast10yrs=Y90BAGE1+Y90BAGE2+Y90BAGE3; 
quietly logit `x'  Y90hinc* Y90nphu* Y90nrc* Y90p65* Y90hsgrad Y90collegegrad Y90black Y90hispanic 
	           Y90occupied Y90owneroccupied Y90bedrooms12 Y90bedrooms34 Y90builtlast5yrs 
	           Y90builtlast10yrs Y90Bscplumb Y90Bacre1 Y90Bacre10 Y90multiunit;
predict pr, pr; drop Y90bedrooms12 Y90bedrooms34 Y90builtlast5yrs Y90builtlast10yrs;
quietly gen zweight=pr/(1-pr); quietly replace zweight=hwt_tot if `x'==1; 
quietly sum zweight if `x'==1; quietly replace zweight=zweight/r(mean) if `x'==1;  
quietly sum zweight if `x'==0; quietly replace zweight=zweight/r(mean) if `x'==0;
quietly tab orispl if yearonline>=2003;
local nplants=r(r); display "THE FOLLOWING REGRESSIONS ARE BASED ON `nplants' PLANTS";
quietly areg logY00value `x' logY90value Y90* [aweight=zweight], absorb(cnty) cluster(trct); lincom _b[`x']; display e(N); return scalar value`x'=r(estimate); 
quietly areg logY00rent  `x' logY90rent  Y90* [aweight=zweight], absorb(cnty) cluster(trct); lincom _b[`x']; display e(N); return scalar rent`x'=r(estimate); 
quietly reg Y00hsgrad Y00collegegrad;
drop pr zweight; end program; 
use temp4.dta, clear;
gen near00=0; replace near00=1 if distance<2 & yearonline>=2003;
*valid00; gen u=uniform(); keep if near00==1 | u<.05; drop u; 
bootstrap r(valuenear00) r(rentnear00), 
	  reps(100) cluster(trct) seed(123456789) noisily dots noheader: valid00;

*-------------------------------------------*
*--KERNEL WEIGHTED LOCAL LINEAR REGRESSION--*
*-------WITH BOOTSTRAP STANDARD ERRORS------*
*-------------------------------------------*;
program localpolynomial, rclass;

*FIRST STEP -- BACK OUT OBSERVABLES;
quietly areg logY00value logY90value Y90* [aweight=hwt_tot], absorb(cnty); predict ev, resid; 
quietly areg logY00rent  logY90rent  Y90* [aweight=hwt_tot], absorb(cnty); predict er, resid;

*SECOND STEP -- KERNEL WEIGHTED LOCAL POLYNOMIAL SMOOTHING;
gen smooth=_n-1; replace smooth=. if smooth>100; replace smooth=smooth/10; 
lpoly ev distance [aweight=hwt_tot], bwidth(1) degree(1) gen(betav) at(smooth) n(101) nograph;
lpoly er distance [aweight=hwt_tot], bwidth(1) degree(1) gen(betar) at(smooth) n(101) nograph;

*SAVE COEFFICIENT ESTIMATES AS SCALARS;
replace smooth=smooth*10; ereturn clear;
foreach x of numlist 0/100 {; 
sum betav if smooth==`x'; return scalar bv`x'=r(mean); 
sum betar if smooth==`x'; return scalar br`x'=r(mean); };
drop betav betar smooth ev er; end program;

use RegressionSampleFullSampleJune.dta, clear;
keep if yearonline>=1993 & yearonline<=2000; keep if distance<30;
egen cnty=group(state county); egen trct=group(state county tract);
bootstrap r(bv0)  r(bv1)  r(bv2)  r(bv3)  r(bv4)  r(bv5)  r(bv6)  r(bv7)  r(bv8)  r(bv9)  r(bv10)
	  r(bv11) r(bv12) r(bv13) r(bv14) r(bv15) r(bv16) r(bv17) r(bv18) r(bv19) r(bv20)
	  r(bv21) r(bv22) r(bv23) r(bv24) r(bv25) r(bv26) r(bv27) r(bv28) r(bv29) r(bv30)
	  r(bv31) r(bv32) r(bv33) r(bv34) r(bv35) r(bv36) r(bv37) r(bv38) r(bv39) r(bv40)
	  r(bv41) r(bv42) r(bv43) r(bv44) r(bv45) r(bv46) r(bv47) r(bv48) r(bv49) r(bv50)
	  r(bv51) r(bv52) r(bv53) r(bv54) r(bv55) r(bv56) r(bv57) r(bv58) r(bv59) r(bv60)
	  r(bv61) r(bv62) r(bv63) r(bv64) r(bv65) r(bv66) r(bv67) r(bv68) r(bv69) r(bv70)
	  r(bv71) r(bv72) r(bv73) r(bv74) r(bv75) r(bv76) r(bv77) r(bv78) r(bv79) r(bv80)
	  r(bv81) r(bv82) r(bv83) r(bv84) r(bv85) r(bv86) r(bv87) r(bv88) r(bv89) r(bv90)
	  r(bv91) r(bv92) r(bv93) r(bv94) r(bv95) r(bv96) r(bv97) r(bv98) r(bv99) r(bv100)
	  r(br0)  r(br1)  r(br2)  r(br3)  r(br4)  r(br5)  r(br6)  r(br7)  r(br8)  r(br9)  r(br10)
	  r(br11) r(br12) r(br13) r(br14) r(br15) r(br16) r(br17) r(br18) r(br19) r(br20)
	  r(br21) r(br22) r(br23) r(br24) r(br25) r(br26) r(br27) r(br28) r(br29) r(br30)
	  r(br31) r(br32) r(br33) r(br34) r(br35) r(br36) r(br37) r(br38) r(br39) r(br40)
	  r(br41) r(br42) r(br43) r(br44) r(br45) r(br46) r(br47) r(br48) r(br49) r(br50)
	  r(br51) r(br52) r(br53) r(br54) r(br55) r(br56) r(br57) r(br58) r(br59) r(br60)
	  r(br61) r(br62) r(br63) r(br64) r(br65) r(br66) r(br67) r(br68) r(br69) r(br70)
	  r(br71) r(br72) r(br73) r(br74) r(br75) r(br76) r(br77) r(br78) r(br79) r(br80)
	  r(br81) r(br82) r(br83) r(br84) r(br85) r(br86) r(br87) r(br88) r(br89) r(br90)
	  r(br91) r(br92) r(br93) r(br94) r(br95) r(br96) r(br97) r(br98) r(br99) r(br100),
          reps(100) seed(12345) cluster(trct) dots notable: localpolynomial;

*SAVE AS VARIABLES;
matrix beta=e(b)'; svmat beta, names(beta);
matrix se=e(se)';  svmat se,   names(se);
keep beta se; keep if beta!=.; 
gen c1=beta-2*se; gen c2=beta+2*se; gen dvar=_n; replace dvar=dvar/10-.1;

*PLOT RESULTS HOUSING VALUES;
scatter beta dvar if dvar<=10, color(black) ms(p) mcolor(black) connect(l) lpattern(solid) 
	title() xtitle("Miles from Power Plant") legend(off) ytitle("Housing Value Residual (in logs)") 
	plotregion(style(none)) graphregion(fcolor(white)) ylabel(-.20(.05).10,nogrid) ||
	line c1 c2 dvar if dvar<=10, connect(l l) clpattern(dash dash) clcolor(gs13 gs13);
graph export semiparValueJune, as(tif) replace; graph save semiparValueJune, replace;

*PLOT RESULTS RENTS;
drop if dvar<=10; drop dvar; gen dvar=_n; replace dvar=dvar/10-.1;
scatter beta dvar, color(black) ms(p) mcolor(black) connect(l) lpattern(solid) 
	title() xtitle("Miles from Power Plant") legend(off) ytitle("Rental Price Residual (in logs)") 
	plotregion(style(none)) graphregion(fcolor(white)) ylabel(-.20(.05).10,nogrid) ||
	line c1 c2 dvar, connect(l l) clpattern(dash dash) clcolor(gs13 gs13);
graph export semiparRentJune, as(tif) replace; graph save semiparRentJune, replace;
