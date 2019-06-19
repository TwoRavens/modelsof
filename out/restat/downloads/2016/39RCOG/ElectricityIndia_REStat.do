** Author: Ama Baafra Abeberese;
** Program for creating tables and figures in "Electricity Cost and Firm Performance: Evidence from India", Ama Baafra Abeberese, Review of Economics and Statistics;


#d, perm;
version 10;
set more off, perm;
set trace off;
clear;
capture log close;
set matsize 4000;


**Set directories;
global folder "C:\Users\aabebere\Desktop\Columbia\My Research\ElectricityIndia\REStat\REStat_Accept0616\";
**Folder where datasets and output are saved;
**Code will run once all the datasets are saved in this folder;


log using "${folder}\ElectricityIndia.log", replace;


***********************************************;
**PROGRAM FOR FORMATTING REGRESSION TABLES;
***********************************************;
**Table Variable Formats;
global strformatmed "%9.3f";
global strformatbig "%9.6f";

**Table Format Program;
capture program drop sig_p;
program sig_p;
   args obj_var point_est_var point_sd_var p_val row_id_var row_num;
   local point_est `point_est_var';
   local point_sd `point_sd_var';
   if `p_val' > 0.1 {;
      replace `obj_var' = string(`point_est', "$strformatmed") if `row_id_var' == `row_num';
      };
   if `p_val' > 0.05 & `p_val' <= 0.1  {;
      replace `obj_var' = string(`point_est', "$strformatmed")+"*" if `row_id_var' == `row_num';
      };
   if `p_val' > 0.01 & `p_val' <= 0.05  {;
      replace `obj_var' = string(`point_est', "$strformatmed")+"**" if `row_id_var' == `row_num';
      };
   if `p_val' <= 0.01 {;
      replace `obj_var' = string(`point_est', "$strformatmed")+"***" if `row_id_var' == `row_num';
      };
   replace `obj_var' = string(`point_sd', "$strformatbig") + " " if `row_id_var' == `row_num' + 1;
   end;

**************************************************************;
**REGRESSION PROGRAM - IV (ONE ENDOGENOUS VARIABLE);
**************************************************************;
capture program drop myIV;
program myIV;
args depvars indvar instr controls part group name;

gen row_num = _n;
forvalues i = 0(1)12 {;
   gen col`i' = "";
   };
local row = 2;

foreach depvar in $`depvars'{;
local c = 0;
replace col0 = "`depvar'" if row_num == `row';


reghdfe `depvar' $`controls' $`part' (`indvar' = `instr') [pweight=MULT], absorb(id) cluster(`group') stages(first reduced);
foreach s in `indvar' $`controls'{;
local c = `c'+1;
test `s';
sig_p col`c' _b[`s'] _se[`s'] r(p) row_num `row';
};
replace col8 = string(e(N)) if row_num == `row';
replace col9 = string(e(df_a)) if row_num == `row';
replace col10 = string(e(r2), "$strformatbig") if row_num == `row';
test `indvar';
replace col12 = string(r(p), "$strformatbig") if row_num == `row';


local row=`row'+2;

estimates restore reghdfe_first1;
local c = 0;
replace col0 = "`indvar'" if row_num == `row';
foreach s in `instr' $`controls'{;
local c = `c'+1;
test `s';
sig_p col`c' _b[`s'] _se[`s'] r(p) row_num `row';
};
replace col8 = string(e(N)) if row_num == `row';
replace col9 = string(e(df_a)) if row_num == `row';
replace col10 = string(e(r2), "$strformatbig") if row_num == `row';
test `instr';
replace col11 = string(r(F), "$strformatbig") if row_num == `row';
replace col12 = string(r(p), "$strformatbig") if row_num == `row';

local row=`row'+2;

estimates restore reghdfe_reduced;
local c = 0;
replace col0 = "`depvar'" if row_num == `row';
foreach s in `instr'  $`controls'{;
local c = `c'+1;
test `s';
sig_p col`c' _b[`s'] _se[`s'] r(p) row_num `row';
};
replace col8 = string(e(N)) if row_num == `row';
replace col9 = string(e(df_a)) if row_num == `row';
replace col10 = string(e(r2), "$strformatbig") if row_num == `row';

local row=`row'+2;
};
sort row_num;
outsheet col* using "${folder}\`name'.csv" if row_num <= `row', replace comma;
drop col* row_num;

end;


**************************************************************;
**REGRESSION PROGRAM - IV (TWO ENDOGENOUS VARIABLES);
**************************************************************;
capture program drop myIV2;
program myIV2;
args depvars indvar1 instr1 indvar2 instr2 controls part group name;

gen row_num = _n;
forvalues i = 0(1)14 {;
   gen col`i' = "";
   };
local row = 2;

foreach depvar in $`depvars'{;
local c = 0;
replace col0 = "`depvar'" if row_num == `row';


reghdfe `depvar' $`controls' $`part' (`indvar1' `indvar2' = `instr1' `instr2') [pweight=MULT], absorb(id) cluster(`group') stages(first reduced);
foreach s in `indvar1' `indvar2' $`controls'{;
local c = `c'+1;
test `s';
sig_p col`c' _b[`s'] _se[`s'] r(p) row_num `row';
};
replace col8 = string(e(N)) if row_num == `row';
replace col9 = string(e(df_a)) if row_num == `row';
replace col10 = string(e(r2), "$strformatbig") if row_num == `row';
replace col11 = string(e(rkf), "$strformatbig") if row_num == `row';

local row=`row'+2;

estimates restore reghdfe_first1;
local c = 0;
replace col0 = "`indvar1'" if row_num == `row';
foreach s in `instr1' `instr2' $`controls'{;
local c = `c'+1;
test `s';
sig_p col`c' _b[`s'] _se[`s'] r(p) row_num `row';
};
replace col8 = string(e(N)) if row_num == `row';
replace col9 = string(e(df_a)) if row_num == `row';
replace col10 = string(e(r2), "$strformatbig") if row_num == `row';
test `instr1' `instr2';
replace col11 = string(r(F), "$strformatbig") if row_num == `row';
replace col12 = string(r(p), "$strformatbig") if row_num == `row';

local row=`row'+2;

estimates restore reghdfe_first2;
local c = 0;
replace col0 = "`indvar2'" if row_num == `row';
foreach s in `instr1' `instr2' $`controls'{;
local c = `c'+1;
test `s';
sig_p col`c' _b[`s'] _se[`s'] r(p) row_num `row';
};
replace col8 = string(e(N)) if row_num == `row';
replace col9 = string(e(df_a)) if row_num == `row';
replace col10 = string(e(r2), "$strformatbig") if row_num == `row';
test `instr1' `instr2';
replace col11 = string(r(F), "$strformatbig") if row_num == `row';
replace col12 = string(r(p), "$strformatbig") if row_num == `row';

local row=`row'+2;

estimates restore reghdfe_reduced;
local c = 0;
replace col0 = "`depvar'" if row_num == `row';
foreach s in `instr1' `instr2' $`controls'{;
local c = `c'+1;
test `s';
sig_p col`c' _b[`s'] _se[`s'] r(p) row_num `row';
};
replace col8 = string(e(N)) if row_num == `row';
replace col9 = string(e(df_a)) if row_num == `row';
replace col10 = string(e(r2), "$strformatbig") if row_num == `row';

local row=`row'+2;
};
sort row_num;
outsheet col* using "${folder}\`name'.csv" if row_num <= `row', replace comma;
drop col* row_num;

end;


**************************************************************;
**REGRESSION PROGRAM - OLS;
**************************************************************;
capture program drop myOLS;
program myOLS;
args depvars indvar controls part group name;

gen row_num = _n;
forvalues i = 0(1)12 {;
   gen col`i' = "";
   };
local row = 2;

foreach depvar in $`depvars'{;
local c = 0;
replace col0 = "`depvar'" if row_num == `row';


reghdfe `depvar' `indvar' $`controls' $`part' [pweight=MULT], absorb(id) cluster(`group');
foreach s in `indvar' $`controls'{;
local c = `c'+1;
test `s';
sig_p col`c' _b[`s'] _se[`s'] r(p) row_num `row';
};
replace col8 = string(e(N)) if row_num == `row';
replace col9 = string(e(N_clust)) if row_num == `row';
replace col10 = string(e(r2), "$strformatbig") if row_num == `row';

local row=`row'+2;
};
sort row_num;
outsheet col* using "${folder}\`name'.csv" if row_num <= `row', replace comma;
drop col* row_num;

end;



***********************************************;
**CREATE VARIABLES;
***********************************************;
use "${folder}asi9899_2008_ds_R", clear;

**Drop variables that are not needed to conserve space;
drop H_I324- J_I1393 I_I324- J_I1348;
keep if A12==1;  **These are the firms which are open per the status code.;

**Years and firm IDs;
replace YR = "1999" if YR=="9899"; **Fiscal year ending March 31, 1999;
replace YR = "2000" if YR=="9900"; **Fiscal year ending March 31, 2000;
destring YR, gen(year) force;
egen id = group(FACTORYId);

**Note:  Three states (Jharkand, Chhatisgarh, Uttaranchal) were carved out of Bihar, Madhya Pradesh, and Uttar Pradesh, respectively in late 2000.;
**Change all state codes for firms in these new states to the new state codes (that is, treat these firms as having always belonged to the new state);
bysort FACTORYId: gen state5 = (state_new==5);
bysort FACTORYId: egen maxstate5 = max(state5);
count if state_new~=5&state_new~=9&state_new~=.&maxstate5==1;
assert r(N) == 0;
replace state_new=5 if maxstate5==1;

bysort FACTORYId: gen state20 = (state_new==20);
bysort FACTORYId: egen maxstate20 = max(state20);
count if state_new~=20&state_new~=10&state_new~=.&maxstate20==1;
assert r(N) == 0;
replace state_new=20 if maxstate20==1;

bysort FACTORYId: gen state22 = (state_new==22);
bysort FACTORYId: egen maxstate22 = max(state22);
count if state_new~=22&state_new~=23&state_new~=.&maxstate22==1;
assert r(N) == 0;
replace state_new=22 if maxstate22==1;

drop state5 state20 state22 maxstate5 maxstate20 maxstate22;


** Regions;
/*
	The Northern region, comprising the States of Haryana, Himachal Pradesh, Jammu & Kashmir, Punjab, Rajasthan, National Capital Territory of Delhi and Union Territory of Chandigarh;
    The Central region, comprising the States of Chhattisgarh, Uttarakhand, Uttar Pradesh and Madhya Pradesh;
    The Eastern region, comprising the States of Bihar, Jharkhand, Orissa, SIKKIM* (part of North Eastern states since 2002), and West Bengal;
    The Western region, comprising the States of Goa, Gujarat, Maharashtra and the Union Territories of Daman & Diu and Dadra & Nagar Haveli;
    The Southern region, comprising the States of Andhra Pradesh, Karnataka, Kerala, Tamil Nadu and the Union Territory of Puducherry.
	The North Eastern States, comprising Assam, Arunachal Pradesh, Manipur, Tripura, Mizoram, Meghalaya and Nagaland;
	*/
gen region = .;
replace region=1 if inlist(state_new, 6, 2, 1, 3, 8, 7, 4);
replace region=2 if inlist(state_new, 22, 5, 9, 23);
replace region=3 if inlist(state_new, 10, 20, 21, 19);
replace region=4 if inlist(state_new, 30, 24, 27, 25, 26);
replace region=5 if inlist(state_new, 28, 29, 32, 33, 34);
replace region=6 if inlist(state_new, 18, 12, 14, 16, 15, 17, 13, 11);


**Industry codes and dummy variables;
**Note: Industry code was changed from NIC 1998 (based on ISIC Rev. 3) to NIC 2004 (based on ISIC Rev. 3.1) beginning with the 2004-05 survey;
**Therefore, link the industry codes from 2004-05 onwards to the NIC 98 codes using the NIC 1998 and NIC 2004 concordance provided with the ASI dataset;
destring A5, gen(ind5) force;
gen nic04 = ind5 if year>=2005;
sort nic04;
merge nic04 using "${folder}NIC04_NIC98_Concordance", _merge(mergeNIC) keep(nic98);
drop if mergeNIC==2;
drop mergeNIC;
replace ind5 = nic98 if year>=2005;
tostring ind5, gen(ind5str);
gen ind4 = substr(ind5str,1,4);
destring ind4, force replace;
gen ind3 = substr(ind5str,1,3);
destring ind3, force replace;
gen ind2 = substr(ind5str,1,2);
destring ind2, force replace;
drop ind5str;
keep if ind5>=15000&ind5<40000;  **Restrict to manufacturing firms;
drop if ind4<1500|ind4>4000;
 
**Merge with price indices;
**For NIC code 155 (beverages) use WPI for Beverages, Tobacco, & Tobacco Products since the other industries in NIC code 15 are all classified as Food Products (excluding beverages);
**In India_WPI file, NIC code 16 is linked to the WPI for Beverages, Tobacco, & Tobacco Products;
gen ind2_wpi = ind2;
replace ind2_wpi = 16 if ind3==155;
sort ind2_wpi year;
merge ind2_wpi year using "${folder}India_WPI", _merge(mergeWPI);
drop if mergeWPI == 2;
drop mergeWPI;


**Merge with state and region data;
***********************************;
sort state_new year;
merge state_new year using "${folder}India_StateData", keep(statecpi_ind_9394 plf gsdp_pc popn thermal thermal2003 thermal2007 state_newname distcoal) _merge(mergeState);
drop if mergeState==2;
drop mergeState;


**Coal Prices;
sort year;
merge year using "${folder}India_CoalPrice", _merge(mergeCoal);
drop if mergeCoal==2;
drop mergeCoal;
gen cp = coalprice/(statecpi_ind_9394/100);
gen lcp = log(cp);
gen leff_cp = thermal*lcp;

**Capital, as reported;
gen land = C_I121/(wpi_mach/100);
gen bldg = C_I122/(wpi_mach/100);
gen mach = C_I123/(wpi_mach/100);
gen transp = C_I124/(wpi_mach/100);
gen comp = C_I125/(wpi_mach/100);
gen poll = C_I126/(wpi_mach/100);
gen othcap = C_I127/(wpi_mach/100);
gen caprog = C_I129/(wpi_mach/100);
foreach v of varlist land bldg mach transp comp poll othcap caprog{; **Replacing negative values;
replace `v' = 0 if `v'<0;
};
egen capt = rowtotal(land bldg mach transp comp poll othcap caprog), missing;

**Investment;
**Use linear interpolation to get investment and retirement in missing years as in e.g. Amiti, Mary, and Jozef Konings. 2007. "Trade Liberalization, Intermediate Inputs, and Productivity: Evidence from Indonesia." American Economic Review, 97(5): 1611-1638.;
**Note: interpolation keeps non-missing values as is and only fills in missing values;
foreach v of varlist C_I51 C_I52 C_I53 C_I54 C_I55 C_I56 C_I57 C_I59{;  **Replacing negative values;
replace `v' = 0 if `v'<0;
};
foreach v of varlist C_I51 C_I52 C_I53 C_I54 C_I55 C_I56 C_I57 C_I59{;
bysort id: ipolate `v' year, generate(`v'_ip);
};

gen iland = C_I51_ip;
gen ibldg = C_I52_ip;
gen imach = C_I53_ip;
gen itransp = C_I54_ip;
gen icomp = C_I55_ip;
gen ipoll = C_I56_ip;
gen iothcap = C_I57_ip;
gen icaprog = C_I59_ip;
egen icapt = rowtotal(iland ibldg imach itransp icomp ipoll iothcap icaprog), missing;

**Labour;
gen lab = E_I610;
gen wages = E_I810/(wpi_out/100);

**Electricity;
gen eg_qty = H_I515;
gen eb_qty = H_I516;
gen eb_val = H_I616/(statecpi_ind_9394/100);
gen ep = eb_val/eb_qty;
gen gendummy = (eg_qty>0&eg_qty~=.);
gen eg_val = eg_qty*ep;
	
**Inputs;
gen input_basic = H_I612/(wpi_inp/100);
gen input_chem = H_I613/(wpi_inp/100);
gen input_pack = H_I614/(wpi_inp/100);
gen oil = H_I617/(wpi_inp/100);
gen coal = (H_I618/(10^6))/(wpi_inp/100);  **In millions of rupees;
gen coal0 = H_I618/(wpi_inp/100);  **In rupees;
gen othfuel = H_I619/(wpi_inp/100);
gen constore = H_I620/(wpi_inp/100);
foreach v of varlist input_basic input_chem input_pack eb_val oil coal0 coal othfuel constore{; **Replacing negative values;
replace `v' = 0 if `v'<0;
};
egen dominput = rowtotal(input_basic input_chem input_pack eg_val eb_val oil coal0 othfuel constore), missing;
gen forinput = I_I67/(wpi_inp/100);
egen input = rowtotal(dominput forinput), missing;


**Output;
gen output = J_I1312/(wpi_out/100);
egen prodno = rownonmiss(J_I31 J_I32 J_I33 J_I34 J_I35 J_I36 J_I37 J_I38 J_I39 J_I310);

	
**Winsorize generated variables: replace values in the lower or upper 1% tails with values at the 1st and 99th percentiles;
foreach v in ep eb_val eg_val eb_qty eg_qty J_I131 J_I132 J_I133 J_I134 J_I135 J_I136 J_I137 J_I138 J_I139 J_I1310 output input lab mach capt wages{;
rename `v' `v'w;
gen `v' = .;
foreach y of numlist 1999(1)2008{;
capture winsor `v'w if year == `y', gen(`v'`y') p(0.01);
capture replace `v' = `v'`y' if year == `y';
capture drop `v'`y';
};
drop `v'w;
};


**Create other variables;
gen ebg_qty = eb_qty + eg_qty;
gen genshare = eg_qty/ebg_qty;
gen labprod = output/lab;
gen ML = mach/lab;
gen KLt = capt/lab;

**Create logs of variables;
foreach v of varlist ML labprod capt icapt ep* *_val *_qty output input lab popn gsdp_pc plf{;
gen l`v' = log(`v');
};



	**Electricity Intensity by Industry, 1999;
	foreach i of numlist 3(1)5{;
	preserve;
	keep if year==1999;
	keep if ebg_qty~=. & output~=.;
	gen eint = ebg_qty/output;
	collapse (mean) eint [pweight=MULT], by(ind`i');
	gen indint`i' = eint;
	tempfile indint`i';
	sort ind`i';
	drop eint*;
	save "`indint`i''";
	restore;
	sort ind`i';
	merge ind`i' using "`indint`i''";
	drop _merge;
	gen lindint`i' = log(indint`i');
	};
	
	**Number of firms used in electricity intensity calculations, to be used as weights for comparing Indian and UK electricity intensities;
	gen n = 1;
	bys ind4:  egen no4 = sum(n) if ebg_qty~=.&output~=.&year==1999;
	bys ind4: egen maxno4 = max(no4);
	drop no4;
	rename maxno4 no4;


	**Electricity Intensity by Product (using single-product firms), in 2001;
	preserve;
	keep if year==2001;
	keep if prodno==1;
	gen prodint = ebg_qty/output;
	rename prodint prodintuw;
	winsor prodintuw, gen(prodint) p(0.01);
	collapse (mean) prodint [pweight=MULT], by(J_I31);
	label var prodint "Electricity intensity (kWh per rupee of output) for product (ASICC)";
	label var J_I31 "Product code per ASICC";
	drop if J_I31==.|J_I31==99211|J_I31==99950; **99211 is other products/by-products, 99950 is total;
	rename J_I31 code;
	sort code;
	save "${folder}Product_Intensity", replace;
	restore;


	forvalues p = 1(1)10 {;
	rename J_I3`p' code;
	sort code;
	merge code using "${folder}Product_Intensity", keep(prodint) _merge(mergeProd);
	drop if mergeProd == 2;
	rename prodint prodint`p';
	rename code J_I3`p';
	drop mergeProd;
	};


	egen prodintno = rownonmiss(prodint1 prodint2 prodint3 prodint4 prodint5 prodint6 prodint7 prodint8 prodint9 prodint10);
	egen fprodint = rowmean(prodint1 prodint2 prodint3 prodint4 prodint5 prodint6 prodint7 prodint8 prodint9 prodint10);
	replace fprodint=. if prodintno~=prodno;
	gen lfprodint = log(fprodint);

	forvalues p = 1(1)10 {;
	gen d`p' = (prodint`p'~=.);
	gen J_I13_p`p' = J_I13`p'*d`p';
	gen wprodint`p' = J_I13_p`p'*prodint`p';
	};
	egen wfprodint_calc1 = rowtotal(wprodint*), missing;
	egen wfprodint_calc2 = rowtotal(J_I13_p*), missing;
	gen wfprodint = wfprodint_calc1/wfprodint_calc2;
	replace wfprodint=. if prodintno~=prodno;
	drop d1-d10 J_I13_p* wfprodint_calc*;
	gen lwfprodint = log(wfprodint);

	replace lfprodint = . if lfprodint==.|lwfprodint==.;
	replace lwfprodint = . if lfprodint==.|lwfprodint==.;

	
	************************************************;
	**Merging with UK electricity intensity measures;
	************************************************;
	sort ind4;
	merge ind4 using "${folder}UK_Power", _merge(mergeuk);
	drop mergeuk;

	
	*************************************************************************************************;
	**Estimating Productivity as Residuals from Industry-Specific OLS Regressions;
	*************************************************************************************************;
	**Two 2-digit industries, 30(Manufacture of office, accounting and computing machinery) and 37 (Recycling) have too few observations for separate Olley-Pakes estimations;
	**Therefore, add industry 30 to 29 (Manufacture of machinery and equipment n.e.c.) and 37 to 36 (Manufacture of furniture, manufacturing n.e.c.);
	global sind2op "15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 31 32 33 34 35 36";
	gen ind2op = ind2;
	replace ind2op = 29 if ind2op==30;
	replace ind2op = 36 if ind2op==37;
	gen ltfp=.;
	foreach i in $sind2op{;
	disp `i';
	capture reg loutput llab lcapt linput if ind2op==`i';
	capture predict ltfp`i' if ind2op==`i', residuals;
	capture replace ltfp = ltfp`i' if ind2op==`i';
	capture drop ltfp`i';
	};

	
	*********************************************************************************************
	**Estimating Productivity using the Solow accounting Method
	*********************************************************************************************;
	**Variables for Solow method for TFP;
	*Wages as a share of output;
	bys ind2op: egen swages = sum(wages) if year==2001&wages~=.&capt~=.&input~=.&output~=.;
	bys ind2op: egen soutput = sum(output) if year==2001&wages~=.&capt~=.&input~=.&output~=.;
	gen malphaL = swages/soutput;
	bys ind2op: egen alphaL = max(malphaL);
	*Capital as a share of output;
	bys ind2op: egen scapt = sum(capt) if year==2001&wages~=.&capt~=.&input~=.&output~=.;
	gen malphaK = scapt/soutput;
	bys ind2op: egen alphaK = max(malphaK);
	*Other inputs as a share of output;
	bys ind2op: egen sinput = sum(input) if year==2001&wages~=.&capt~=.&input~=.&output~=.;
	gen malphaM = sinput/soutput;
	bys ind2op: egen alphaM = max(malphaM);

	gen ltfpS = loutput - alphaK*lcapt - alphaL*llab - alphaM*linput;
	

	*********************************************************************************************
	**Estimating Productivity Using the Levinsohn-Petrin (2003) Method
	*********************************************************************************************;
	preserve;
	set seed 459887871;
	gen ltfpLP=.;
	foreach i in $sind2op{;
	disp `i';
	capture levpet loutput  if ind2op==`i', free(llab) proxy(linput) capital(lcapt) revenue i(id) t(year) reps(250);
	capture predict hat`i' if ind2op==`i', omega;
	capture gen ltfpLP`i' = log(hat`i');
	capture replace ltfpLP = ltfpLP`i' if ind2op==`i';
	capture drop ltfpLP`i';
	};
	
	keep id year ind2op ltfpLP;
	sort id year ind2op;
	save "${folder}LP", replace;;
	restore;

	sort id year ind2op;
	merge id year ind2op using "${folder}LP", update;
	drop _merge;
	

	*************************************************************************************************;
	**Estimating Productivity Using the Olley-Pakes Method;
	*************************************************************************************************;
	set seed 749563567;
	*** define non-linear program;
	capture program drop nlop2;
	program define nlop2;
		version 8;
		if "`1'"=="?" {
			global S_2 "non-linear estimation, interacting (phihat-bk*k-b0) and p";
			global S_1 "B0 BK B1 B2 B3 B4 B5 B6 B7 B8 B9 B10 B11 B12 B13 B14 B15";
					global BK = $STARTBK;
					global B0 = $STARTB0;
					global B1 = $STARTB1;
					global B2 = $STARTB2;
					global B3 = $STARTB3;
			global B4 = 0;
			global B5 = 0;
			global B6 = 0;
			global B7 = 0;
			global B8 = 0;
			global B9 = 0;
			global B10 = 0;
			global B11 = 0;
			global B12 = 0;
			global B13 = 0;
			global B14 = 0;
			global B15 = 0;
			exit;
		};
		replace `1' = $B0 + $BK*`2' + $B1*(`3'-$B0-$BK*`5') + $B2*(`3'-$B0-$BK*`5')^2 +
			$B3*(`3'-$B0-$BK*`5')^3 + $B4*`4' + $B5*`4'^2 + $B6*`4'^3 + $B7*(`3'-$B0-$BK*`5')*`4'+
			$B8*((`3'-$B0-$BK*`5')^2)*`4' + $B9*((`3'-$B0-$BK*`5')^3)*`4' + $B10*(`3'-$B0-$BK*`5')*((`4')^2) +
			$B11*((`3'-$B0-$BK*`5')^2)*((`4')^2) + $B12*((`3'-$B0-$BK*`5')^3)*((`4')^2) + $B13*(`3'-$B0-$BK*`5')*((`4')^3) +
			$B14*((`3'-$B0-$BK*`5')^2)*((`4')^3) + $B15*((`3'-$B0-$BK*`5')^3)*((`4')^3);
	end;

	* create variables for flexible polynomial in log of capital and investment;
	gen lcapt2 = lcapt^2;
	gen lcapt3 = lcapt^3;
	gen licapt2 = licapt^2;
	gen licapt3 = licapt^3;
	gen lcapt1licapt1 = lcapt*licapt;
	gen lcapt2licapt1 = lcapt2*licapt;
	gen lcapt3licapt1 = lcapt3*licapt;
	gen lcapt1licapt2 = lcapt*licapt2;
	gen lcapt2licapt2 = lcapt2*licapt2;
	gen lcapt3licapt2 = lcapt3*licapt2;
	gen lcapt1licapt3 = lcapt*licapt3;
	gen lcapt2licapt3 = lcapt2*licapt3;
	gen lcapt3licapt3 = lcapt3*licapt3;

	**Select 2-digit industry;
	foreach i in $sind2op{;
	disp `i';
	preserve;
	keep if ind2op==`i';

	**Fill in years for lagged variables;
	duplicates drop id year, force;
	tsset id year;
	tsfill;

	* create lagged variables;
	sort id year;
	by id: gen lcapt_lag = lcapt[_n-1];

	* create survival variable;
	gen exit = (YR == "");
	gen survive = 1-exit;
	sort id year;
	by id: gen survivenextyear = survive[_n+1]; *will be useful when running probits below;

	* create indicator for whether plant ever exits;
	sort id year;
	egen everexit = max(exit), by(id);


	**Using the unbalanced panel, regress log value added on log total hours and a flexible third-order polynomial in log capital stock and investment, including interaction terms between the various powers of the two variables and excluding any observation with zero investment;
	reg loutput linput llab lcapt licapt lcapt2 lcapt3 licapt2 licapt3 lcapt1licapt1 lcapt2licapt1 
		lcapt3licapt1 lcapt1licapt2 lcapt2licapt2 lcapt3licapt2 lcapt1licapt3 
		lcapt2licapt3 lcapt3licapt3 if licapt>0 & licapt~=.;

	predict loutputhat;
	local bihat_3_1 = _b[linput];
	local blhat_3_1 = _b[llab];
	local bkhat_3_1 = _b[lcapt];
	display "bihat_3_1 = " `bihat_3_1';
	display "blhat_3_1 = " `blhat_3_1';
	display "bkhat_3_1 = " `bkhat_3_1';
	gen phihat = loutputhat- `bihat_3_1'*linput - `blhat_3_1'*llab if e(sample);
	sort id year;
	by id: gen phihat_lag = phihat[_n-1];
	gen yminusbl = loutput - linput*`bihat_3_1' - llab*`blhat_3_1';

	* calculate predicted survival probability based on log of capital, log of investment from previous period;
	capture drop p p_lag;
	probit survivenextyear lcapt licapt lcapt2 lcapt3 licapt2 licapt3 lcapt1licapt1 lcapt2licapt1 
		lcapt3licapt1 lcapt1licapt2 lcapt2licapt2 lcapt3licapt2 lcapt1licapt3 
		lcapt2licapt3 lcapt3licapt3 if licapt>0 & licapt~=.;
	predict p if e(sample);
	by id: gen p_lag = p[_n-1];

	* take results from above as starting values;
	global STARTBK = `bkhat_3_1';
	global STARTB0 = 0;
	global STARTB1 = 0;
	global STARTB2 = 0;
	global STARTB3 = 0;

	capture nl op2 yminusbl lcapt phihat_lag p_lag lcapt_lag if licapt>0 & licapt~=. & year>=2002, iter(200);

	display "BK = " $BK;
	display "B0 = " $B0;
	display "B1 = " $B1;
	display "B2 = " $B2;
	display "B3 = " $B3;

	local bkhat_3_2_3 = $BK;
	display "bkhat_3_2_3 = " `bkhat_3_2_3';

	gen ltfpOP = loutput - linput*`bihat_3_1' - llab*`blhat_3_1' - lcapt*`bkhat_3_2_3';

	keep id year ind2op ltfpOP;
	sort id year ind2op;
	save "${folder}/OP_`i'", replace;;
	restore;
	};

	foreach i in $sind2op{;
	sort id year ind2op;
	merge id year ind2op using "${folder}/OP_`i'", update;
	drop _merge;
	};
	***************************************************************************************************;
	**End of Olley-Pakes estimation;
	
		drop if state_new==.;

	**Save formatted data;
	save "${folder}asi9899_2008_ds_R_Electricity", replace;

	
	***********************************************;
	**REGRESSION TABLES AND FIGURES;
	***********************************************;
	use "${folder}asi9899_2008_ds_R_Electricity", clear;

	egen group1 = group(state_new year); **For clustering at the state-year level;

	**Drop remaining variables that are not needed to conserve space;
	drop if E_I610==0; **Zero labor firms;
	drop E* G*;
	drop if thermal==0;
	duplicates drop id year, force;


	foreach v of varlist year state_new ind5 lep leff_cp lebg_qty leb_qty gendummy genshare loutput llab llabprod lML lindint5 coal ltfp ltfpOP ltfpLP ltfpS{;
	drop if `v'==.;
	};

	drop if year<2000|year>2008;

	global controls "coal lgsdp_pc lpopn";

	**Tsset data for growth calculations;
	****************************************;
	duplicates drop id year, force;
	tsset id year;
	sort id year;
	
	*Switching variables;
	bys id: gen switch = lindint5<l1.lindint5;
	bys id: replace switch = . if l1.lindint5==.|lindint5==.;
	
	**Growth variables;
	foreach v of varlist loutput llab ltfp*{;
	foreach i of numlist 1(1)1{;
	bys id: gen `v'growth`i'l = `v' - l`i'.`v';
	};
	};
	gen llabprodgrowth1l = loutputgrowth1l - llabgrowth1l;

	foreach v of varlist lep leff_cp $controls{;
	foreach i of numlist 1(1)1{;
	gen `v'`i'l = l`i'.`v';
	};
	};

	drop if YR=="";  **These are blank rows created from the tsfill command;
	drop if year<2001;


	********************************************************************************;
	*Drop singletons (firms with only one observation) as they cannot be used in firm fixed effects regressions;
	bys id: egen sumn =sum(n);
	drop if sumn==1;
	drop sumn;

	capture drop t;
	gen t = year-2001;
	xi i.region*i.t;
	xi i.state_new*t, prefix(_S) noomit;

	xtset id;


**COLUMNS 3 and 5 of TABLE 4; 
**IV Growth regression with no controls;
*********************************************;
global depvars "loutputgrowth1l llabgrowth1l llabprodgrowth1l ltfpgrowth1l ltfpOPgrowth1l ltfpLPgrowth1l ltfpSgrowth1l";
global part "_SstaXt* _IregXt*";
global controls "";
myIV depvars lep1l leff_cp1l controls part group1 TableSGR;

**COLUMNS 4 and 6 of TABLE 4; 
**IV Growth regression with controls;
***************************************;
global depvars "loutputgrowth1l llabgrowth1l llabprodgrowth1l ltfpgrowth1l ltfpOPgrowth1l ltfpLPgrowth1l ltfpSgrowth1l";
global part "_SstaXt* _IregXt*";
global controls "coal1l lgsdp_pc1l lpopn1l";
myIV depvars lep1l leff_cp1l controls part group1 TableSGR_C;

**COLUMN 1 of TABLE 4; 
**OLS Growth regression with no controls;
***********************************************;
global depvars "loutputgrowth1l llabgrowth1l llabprodgrowth1l ltfpgrowth1l ltfpOPgrowth1l ltfpLPgrowth1l ltfpSgrowth1l";
global part "_SstaXt* _IregXt*";
global controls "";
myOLS depvars lep1l controls part id TableSGR_OLS;

**COLUMN 2 of TABLE 4; 
**OLS Growth regression with controls;
*******************************************;
global depvars "loutputgrowth1l llabgrowth1l llabprodgrowth1l ltfpgrowth1l ltfpOPgrowth1l ltfpLPgrowth1l ltfpSgrowth1l";
global part "_SstaXt* _IregXt*";
global controls "coal1l lgsdp_pc1l lpopn1l";
myOLS depvars lep1l controls part id TableSGR_C_OLS;



**Define dependent variables and controls;
global depvars "leb_qty lebg_qty gendummy genshare lindint5 lfprodint lwfprodint lML loutput llab llabprod ltfp ltfpOP ltfpLP ltfpS switch";
global fdepvars "leb_qty";
global part "_SstaXt* _IregXt*";
global part2 "_IregXt*";
global controls "coal lgsdp_pc lpopn";
global nocontrols "";

**COLUMN 1 of TABLE 2;
**First Stage Regression With No State-Time Trends and Controls;
***************************************************************;
myIV fdepvars lep leff_cp nocontrols part2 group1 TableFS;

**COLUMN 2 of TABLE 2 and COLUMNS 3 and 5 of TABLES 3 and 5; 
**IV Regressions Without Controls;
************************************;
myIV depvars lep leff_cp nocontrols part group1 TableIV;

**COLUMN 3 of TABLE 2 and COLUMNS 4 and 6 of TABLES 3 and 5;
**IV Regressions With Controls;
************************************;
myIV depvars lep leff_cp controls part group1 TableIV_C;

**COLUMN 1 of TABLES 3 and 5;
**OLS Regressions Without Controls
**********************************;
myOLS depvars lep nocontrols part id TableOLS;

**COLUMN 2 of TABLES 3 and 5;
**OLS Regressions With Controls
**********************************;
myOLS depvars lep controls part id TableOLS_C;

***********************************************************************;
**Robustness;
***********************************************************************;
global depvars "leb_qty lebg_qty lindint5 lML loutput llab llabprod ltfpOP";
**COLUMN 2 of ONLINE APPENDIX TABLE B9;
**IV Regressions With Controls, excluding coal control;
***********************************************************************;
global controls "lgsdp_pc lpopn";
myIV depvars lep leff_cp controls part group1 TableIV_C_NoCoalControl;

**COLUMN 3 of ONLINE APPENDIX TABLE B9;
**IV Regressions With Controls, excluding coal control, including PLF;
***********************************************************************;
global controls "lgsdp_pc lpopn lplf";
myIV depvars lep leff_cp controls part group1 TableIV_C_NoCoalControl_PLF;

**COLUMN 4 of ONLINE APPENDIX TABLE B9;
**IV Regressions With Controls, including PLF;
***********************************************************************;
global controls "coal lgsdp_pc lpopn lplf";
myIV depvars lep leff_cp controls part group1 TableIV_C_PLF;


***********************************************************************;
**COLUMN 5 of ONLINE APPENDIX TABLE B9;
**IV Regressions With Controls, excluding sectors dependent on coal;
***********************************************************************;
global controls "coal lgsdp_pc lpopn";
preserve;
**Exclude sectors that are heavily dependent on coal as an input;
bys ind2: sum coal;
*Sectors with highest coal consumption are 	;
drop if ind2==21|ind2==26|ind2==27;
*Drop singletons (firms with only one observation) as they cannot be used in firm fixed effects regressions;
bys id: egen sumnb =sum(n);
drop if sumnb==1;
drop sumnb;

myIV depvars lep leff_cp controls part group1 TableIV_NoCoalInd3_C;
restore;


***********************************************************************;
**COLUMN 6 of ONLINE APPENDIX TABLE B9;
**Using Distance to Coal Mines Instead of Thermal Share;
***********************************************************************;
gen proximity = 1/log(distcoal);
gen leff_cpD = proximity*lcp;
global controls "coal lgsdp_pc lpopn";
myIV depvars lep leff_cpD controls part group1 TableIV_C_Distance;


***********************************************************************;
**COLUMN 7 of ONLINE APPENDIX TABLE B9;
**Regressions for balanced panel;
***********************************************************************;
preserve;
gen i = 1;
bys id: egen sbalanced = sum(i);
gen balanced = sbalanced==8;
keep if balanced==1;
global controls "coal lgsdp_pc lpopn";
myIV depvars lep leff_cp controls part group1 TableIV_C_Balanced;
restore;


***********************************************************************;
**TABLE 6;
**Firm Heterogeneity;
***********************************************************************;
**Multiproduct firms;
sort id year;
bys id: gen mprodno =prodno[1];
gen multi = prodno>1&mprodno~=.;
gen leff_cp_multi = leff_cp*multi;
gen lep_multi = lep*multi;
global depvars "leb_qty lebg_qty lindint5 lML loutput llab llabprod ltfpOP";
global part "_SstaXt* _IregXt*";
global controls "coal lgsdp_pc lpopn";
myIV2 depvars lep leff_cp lep_multi leff_cp_multi controls part group1 TableIV_C_Prodno;


*********************************;
**TABLE 1;
**Summary statistics by firm size;
*********************************;
sort id year;
gen size=.;
bys id: replace size = 1 if lab[1]<50;
bys id: replace size = 2 if lab[1]>=50&lab[1]<100;
bys id: replace size = 3 if lab[1]>=100;
foreach i of numlist 1(1)3{;
mean ebg_qty eb_qty eg_qty eb_val gendummy genshare ep output lab labprod mach ML KLt ltfpOP [pweight = MULT] if size==`i';
};
mean ebg_qty eb_qty eg_qty eb_val gendummy genshare ep output lab labprod mach ML KLt ltfpOP [pweight=MULT];
foreach i of numlist 1(1)3{;
count if size==`i';
codebook id if size==`i';
};

**************************************************;
**ONLINE APPENDIX TABLE B6;
**Summary statistics for growth regressions sample;
**************************************************;
reghdfe loutputgrowth1 lgsdp_pc1l lpopn1l coal1l  _IregXt* _SstaXt* (lep1l = leff_cp1l) [pweight=MULT], absorb(id) cluster(group1) stages(first reduced);
mean ebg_qty eb_qty eg_qty eb_val gendummy genshare ep output lab labprod mach ML KLt ltfpOP [pweight=MULT] if e(sample);

****************************************************;
**FIGURE 1;
**Coal price for power utilities;
****************************************************;
preserve;
collapse coalprice*, by(year);
twoway scatter coalprice year if year>=2001, xtitle("") xscale(r(2001(1)2008)) xlabel(2001(1)2008)  connect(l) mfcolor(none) graphregion(color(white)) scheme(sj) ylabel(, tposition(inside) nogrid) legend(off) ytitle(price of coal for power utilities (Rs. per tonne));
graph export "${folder}GraphCoal.emf", replace;
restore;

************************************************************;
**ONLINE APPENDIX FIGURE B3;
**Chart showing thermal shares do not change much over time;
************************************************************;
preserve;
keep state_new state_newname thermal thermal2003 thermal2007;
collapse state_new thermal thermal2003 thermal2007, by(state_newname );
rename thermal y1998;
rename thermal2003 y2003;
rename thermal2007 y2007;
reshape long y, i(state_new) j(year);
rename y thermal;
replace thermal = thermal*100;
sort state_newname year;
twoway scatter thermal year, by(state_newname , rows(5) xrescale note("")) connect(l) scheme(sj) ylabel(, tposition(inside) nogrid) legend(off) ytitle(thermal share of generation capacity (%), size(small)) xtitle("", size(small)) xscale(r(1998 2007)) xlabel(1998 2003 2007) yscale(r(0 100)) ylabel(0 50 100);
graph export "${folder}ThermalTrend.emf", replace;
restore;


*************************************************************************************************************************;
**Comparison chart between electricity intensity and UK electricity intensity;
*************************************************************************************************************************;
**ONLINE APPENDIX FIGURE B5;
*Chart with UK electricity intensity at 4-digit industry level;
preserve;
collapse indint4 ukindint4 no4, by(ind4);
foreach v in indint4 ukindint4{;
gen l`v' = log(`v');
};

twoway scatter lindint4 lukindint4, mfcolor(none) graphregion(color(white)) scheme(sj) ylabel(, tposition(inside) nogrid) legend(off) ytitle(log India electricity intensity) xtitle(log UK electricity intensity)||lfit lindint4 lukindint4 [aweight=no4];
graph export "${folder}GraphUK.emf", replace;

gen row_num = _n;
forvalues i = 0(1)10 {;
   gen col`i' = "";
   };
local row = 2;

foreach u of varlist lukindint4{;
	
foreach v in lindint4{;
local c = 0;
replace col0 = "`v'" if row_num == `row';
reg `v' `u' [aweight=no4];
foreach s in `u'{;
local c = `c'+1;
test `s';
sig_p col`c' _b[`s'] _se[`s'] r(p) row_num `row';
};
replace col8 = string(e(N)) if row_num == `row';
replace col9 = string(e(N_clust)) if row_num == `row';
replace col10 = string(e(r2), "$strformatbig") if row_num == `row';

local row=`row'+2;
};
};
sort row_num;
outsheet col* using "${folder}TableUK.csv" if row_num <= `row', replace comma;
drop col* row_num;

restore;

log close;
