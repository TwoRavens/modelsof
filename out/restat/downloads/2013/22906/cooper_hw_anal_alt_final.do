/* This program generates some of the appendix results using alternative consumption measures  ---
specifically tables A.3 to A.6.  The setup is very similar to the main program (cooper_hw_anal_final.do)
and the same caveats apply regarding needing the restricted PSID geocode data in order to merge in MSA
level data to run the regressions.   These variables can also be removed from the specifications
and the regressions can be run as is. */

drop _all
clear matrix
set memory 2g
set more off


use ~/restat_rev/data/revdat_419_wmdebt_fin


* do some data manipulation/conversion

gen rnhcons_pc      = rnhcons/famsize


gen ln_cons_fullxh = log(cons_psid_full/def)
gen ln_cons_bpp_adj    = log(cons_ndbpp_adj/def)
gen ln_cons_merge_psid = log(cons_mergepsid_b/def)

replace ln_famincrat = log(famincrat) if year ==1997

sort unique year

*need to create "1989" data b/c food consumption not available in that year
by unique:  replace ln_cons_fullxh    = ln_cons_fullxh[_n+1] if year ==1989 & year == year[_n+1] -1
by unique:  replace ln_cons_bpp_adj   = ln_cons_bpp_adj[_n+1] if year ==1989 & year == year[_n+1] -1
*by unique:  replace ln_cons_psid      = ln_cons_psid[_n+1] if year ==1989 & year == year[_n+1] -1


* set up a few demographic variables

gen age2 = ageh^2
gen age3 = ageh^3


gen ln_psidc = log(pexpn)
replace ln_psidc = log(pexpnf) if year >=2005


* set up the wealth ratios

gen fwr = l_totalfw/famincrat
gen fwr1 = l_totalfw1/famincrat
gen hewr = lalt_rhequity/famincrat
gen ayr3  =  l_rotherincma3/famincrat

gen lnypp = log(YPP)

*need hewr variable consistent with timing in sample for Table A.6;

gen hewra6 = l_rhequity/famincrat






drop if region >4 | ageh ==999  



xi year
xi region
xi famsize
xi coh


* want to trim outliers 


_pctile hewra6, percentiles(1(98)99)

gen  hea6min = r(r1)
gen  hea6max = r(r2)



_pctile fwr, percentiles(1(98)99)

gen  fmin = r(r1)
gen  fmax = r(r2)

_pctile hewr, percentiles(1(98)99)

gen  hemin = r(r1)
gen  hemax = r(r2)


_pctile fwr1, percentiles(1(98)99)

gen  f1min = r(r1)
gen  f1max = r(r2)

_pctile ln_rnhcons, percentiles(1(98)99)

gen  cmin = r(r1)
gen  cmax = r(r2)

_pctile ln_famincrat, percentiles(1(98)99)

gen  ymin = r(r1)
gen  ymax = r(r2)

_pctile dl_le2_labincr, percentiles(1(98)99)

gen  ygmin = r(r1)
gen  ygmax = r(r2)

_pctile dl_le2_hlabincr, percentiles(1(98)99)

gen  yghmin = r(r1)
gen  yghmax = r(r2)

_pctile ln_cons_fullxh, percentiles(1(98)99)

gen  camin = r(r1)
gen  camax = r(r2)

_pctile ln_cons_bpp_adj, percentiles(1(98)99)

gen  cadmin = r(r1)
gen  cadmax = r(r2)


_pctile ln_psidc, percentiles(1(98)99)

gen  pcmin = r(r1)
gen  pcmax = r(r2)

_pctile ln_cons_merge_psid , percentiles(1(98)99)

gen  pcmmin = r(r1)
gen  pcmmax = r(r2)


sort unique year

#delimit ;




by unique:  gen     lltv = ltv[_n-1];
by unique:  replace lltv = ltv[_n-4] if year ==1999 & year == year[_n-4]+5;   *  have one skipped year (1998) b/c have dropped heads;
by unique:  replace lltv = ltv[_n-5] if year <1999 & year == year[_n-5]+5;  

gen lltvh = 1 if lltv >.8 & lltv <2;
replace lltvh = 0 if lltv <=.8 & lltv >0;


* SELECT WHAT TO RUN;
* In the code for tables A.3 to A.5 the relevant depedent variable must also be chosen.  ;

local interactions =0;
local tablea6 = 1;

local tablea3 = 0;
local tablea4 = 0;
local tablea5 = 1;







* CREATES TABLES  A.3 to A.5 The consumption measure (depedent variable) has to be chosen as well;

if `interactions' {;


drop if ln_famincrat <ymin | ln_famincrat >ymax;

drop if ltv >2;


/* select consumption meaure and releveant outlier trimming */


if `tablea3' {;

gen cut1 = pcmin;
gen cut2 = pcmax;

};

if `tablea4' {;

replace ln_psidc = ln_cons_merge_psid;

gen cut1 = pcmmin;
gen cut2 = pcmmax;

};


if `tablea5' {;

replace ln_psidc = ln_cons_bpp_adj;

gen cut1 = cadmin;
gen cut2 = cadmax;

};






* calculate debt service ratio;

* debt service ratio based on johnson and li (2010);
* assumes paying 2.5% of credit card debt monthly...they also look at DPI;

gen dsr     = (mortpay + lopcar + (.025*w_odebt)*12)/avg_hlabincr_nol;




gen dsr_80 = 0;

#delimit cr
forvalues x= 1999(2)2007 {
centile dsr if year == `x', centile(20(20)80) 
replace dsr_80 = r(c_4) if year ==`x'
}

#delimit ;


sort unique year;

* off year income data/observations have been removed;
by unique:  gen l_dsr = dsr[_n-1] if year == year[_n-1] +2;
by unique:  gen l_dsr_80 = dsr_80[_n-1] if year == year[_n-1] +2;

gen     l_bc = 1 if l_dsr > l_dsr_80 & l_dsr <=2;
replace l_bc = 0 if l_dsr < l_dsr_80 & l_dsr >0;

gen llwy_jl = l_liqw_jl/avg_labincr_nol;
gen llwy    = l_liqw/avg_labincr_nol;


* calculate quartiles for certain variables-- these are taken over all years for now;

gen diff = dl_le2_hlabincr_adj- avg_d2hlabincr_adj;


local vars "dl_le2_labincr dl_le2_hlabincr l_dsr l_liqw l_liqw_jl llwy diff llwy_jl l_totalfw";

#delimit cr
foreach y of local vars {

_pctile `y' if `y' !=. , percentiles(25(25)75)

gen  i`y'_p1 = r(r1)
gen  i`y'_p2 = r(r2)
gen  i`y'_p3 = r(r3)

gen ips_`y'=1 if `y' !=.
replace ips_`y'=2 if (`y'>i`y'_p1 & `y'<=i`y'_p2) & `y' !=.
replace ips_`y'=3 if (`y'>i`y'_p2 & `y'<=i`y'_p3) & `y' !=.
replace ips_`y'=4 if `y'>i`y'_p3 & `y'!=.	

* also want above and below median variable

gen       am_`y' = 1 if `y'>i`y'_p2  & `y' !=.
replace   am_`y' = 0 if `y'<=i`y'_p2  & `y' !=.

}


#delimit ;

* constaint measues based on liquid wealth holdings;

gen bm_lw = 1 if ips_l_liqw <=2;
replace bm_lw = 0 if ips_l_liqw >2 & ips_l_liqw ~=.;

gen bm_lwy = 1 if ips_llwy <=2;
replace bm_lwy = 0 if ips_llwy >2 & ips_llwy ~=.;

* high income constraint measure;

gen highy = 1 if ips_dl_le2_labincr ==4;
replace highy = 0 if ips_dl_le2_labincr ~=4 & ips_dl_le2_labincr ~=.;


*replace hewr = lalt_rhequity/famincrat;
replace fwr = fwr/100;



xtreg ln_psidc ln_famincrat fwr hewr famsize ageh age2 age3 ib1989.year dl_le2_labincr_adj  
if moved ==0  & howner ==1  & l_howner ==1 & fwr >fmin & fwr <fmax  & hewr >hemin & hewr <hemax & dl_le2_labincr < ygmax
& dl_le2_labincr >ygmin & ageh <65 & ln_psidc >cut1 & ln_psidc < cut2 , fe robust;

estimates store l0a;



xtreg ln_psidc ln_famincrat fwr hewr famsize ageh age2 age3 ib1989.year dl_le2_labincr_adj  
if moved ==0  & howner ==1  & l_howner ==1 & fwr >fmin & fwr <fmax  & hewr >hemin & hewr <hemax & dl_le2_labincr < ygmax
& dl_le2_labincr >ygmin & ageh <65 & ln_psidc >cut1 & ln_psidc < cut2 & year >1999, fe robust;

estimates store l0;


xtreg ln_psidc ln_famincrat fwr hewr famsize ageh age2 age3 ib1989.year dl_le2_labincr_adj  
if moved ==0  & howner ==1  & l_howner ==1 & fwr >fmin & fwr <fmax  & hewr >hemin & hewr <hemax & dl_le2_labincr < ygmax
& dl_le2_labincr >ygmin & ageh <65  & bm_lwy ==1 &year >1999 & ln_psidc >cut1 & ln_psidc < cut2  , fe robust;

estimates store l1;

xtreg ln_psidc ln_famincrat fwr hewr famsize ageh age2 age3 ib1989.year dl_le2_labincr_adj  
if moved ==0  & howner ==1  & l_howner ==1 & fwr >fmin & fwr <fmax  & hewr >hemin & hewr <hemax & dl_le2_labincr < ygmax
& dl_le2_labincr >ygmin & ageh <65  & bm_lwy ==0 &year >1999 & ln_psidc >cut1 & ln_psidc < cut2 , fe robust;

estimates store l2;

xtreg ln_psidc ln_famincrat fwr hewr famsize ageh age2 age3 ib1989.year dl_le2_labincr_adj  
if moved ==0  & howner ==1  & l_howner ==1 & fwr >fmin & fwr <fmax  & hewr >hemin & hewr <hemax & dl_le2_labincr < ygmax
& dl_le2_labincr >ygmin & ageh <65  & highy ==1 &year >1999 & ln_psidc >cut1 & ln_psidc < cut2 , fe robust;

estimates store hy;

xtreg ln_psidc ln_famincrat fwr hewr famsize ageh age2 age3 ib1989.year dl_le2_labincr_adj  
if moved ==0  & howner ==1  & l_howner ==1 & fwr >fmin & fwr <fmax  & hewr >hemin & hewr <hemax & dl_le2_labincr < ygmax
& dl_le2_labincr >ygmin & ageh <65  & highy==0 &year >1999 & ln_psidc >cut1 & ln_psidc < cut2 , fe robust;

estimates store ly;


* debt-service ratios;

xtreg ln_psidc ln_famincrat fwr hewr famsize ageh age2 age3 ib1989.year dl_le2_labincr_adj  
if moved ==0  & howner ==1  & l_howner ==1 & fwr >fmin & fwr <fmax  & hewr >hemin & hewr <hemax & dl_le2_labincr < ygmax
& dl_le2_labincr >ygmin & ageh <65 & am_l_dsr ==0 &year >1999 & ln_psidc >cut1 & ln_psidc < cut2 , fe robust;

estimates store dlow;

xtreg ln_psidc ln_famincrat fwr hewr famsize ageh age2 age3 ib1989.year dl_le2_labincr_adj  
if moved ==0  & howner ==1  & l_howner ==1 & fwr >fmin & fwr <fmax  & hewr >hemin & hewr <hemax & dl_le2_labincr < ygmax
& dl_le2_labincr >ygmin & ageh <65 & am_l_dsr ==1  &year >1999 & ln_psidc >cut1 & ln_psidc < cut2, fe robust;

estimates store dhigh;


xtreg ln_psidc ln_famincrat fwr hewr famsize ageh age2 age3 ib1989.year dl_le2_labincr_adj  
if moved ==0  & howner ==1  & l_howner ==1 & fwr >fmin & fwr <fmax  & hewr >hemin & hewr <hemax & dl_le2_labincr < ygmax
& dl_le2_labincr >ygmin & ageh <65 & am_l_dsr ==1 & bm_lwy ==1 &year >1999 & ln_psidc >cut1 & ln_psidc < cut2 , fe robust;

estimates store dhigh1;


xtreg ln_psidc ln_famincrat fwr hewr famsize ageh age2 age3 ib1989.year dl_le2_labincr_adj  
if moved ==0  & howner ==1  & l_howner ==1 & fwr >fmin & fwr <fmax  & hewr >hemin & hewr <hemax & dl_le2_labincr < ygmax
& dl_le2_labincr >ygmin & ageh <65 & am_l_dsr ==1 & bm_lwy ==0 &year >1999 & ln_psidc >cut1 & ln_psidc < cut2, fe robust;

estimates store dhigh2;


if `tablea3' | `tablea4' {;

estout  l0 l1 l2  dlow dhigh dhigh1 dhigh2 hy ly using ~/restat_rev/results/inter_altc_test.out, replace margin style(tex) starlevels(* 0.10 ** 0.05 ***
0.01) cells(b(star fmt(%5.2fc)) se(par fmt(%5.2fc)))  keep (ln_famincrat fwr hewr dl_le2_labincr_adj)   stats(N r2_a rmse, fmt(%5.0f %5.2f %5.2f)) 
  varlabels(ln_famincrat "Log Income" fwr "(Financial Wealth)/Income" hewr "(Housing Equity)/Income"
		dl_le2_labincr_adj "Expected Labor Income Growth" avg_labincr "Average (permanent) Income" 
        lnypp "MSA Income (p.c.)" R "MSA Unemployment Rate"  yppg "MSA Income Growth (p.c)"  yppgf "Expected MSA Income Growth (p.c)")     varwidth(45);

};


if `tablea5' {;

estout  l0a l0 l1 l2  dlow dhigh dhigh1 dhigh2 hy ly using ~/restat_rev/results/inter_altc_test.out, replace margin style(tex) starlevels(* 0.10 ** 0.05 ***
0.01) cells(b(star fmt(%5.2fc)) se(par fmt(%5.2fc)))  keep (ln_famincrat fwr hewr dl_le2_labincr_adj)   stats(N r2_a rmse, fmt(%5.0f %5.2f %5.2f)) 
  varlabels(ln_famincrat "Log Income" fwr "(Financial Wealth)/Income" hewr "(Housing Equity)/Income"
		dl_le2_labincr_adj "Expected Labor Income Growth" avg_labincr "Average (permanent) Income" 
        lnypp "MSA Income (p.c.)" R "MSA Unemployment Rate"  yppg "MSA Income Growth (p.c)"  yppgf "Expected MSA Income Growth (p.c)")     varwidth(45);

};

};



* CREATES TABLES  A.6  which has a slightly different setup;
* THIS CODE SINCE IT REPLICATES some of the baseline setup uses some of the MSA based data;

if `tablea6' {;

* because want all years need to use proxy for financial wealth based on asset income;




*trim consumption outliers;

drop if ln_cons_fullxh <camin | ln_cons_fullxh > camax;
drop if ln_famincrat <ymin | ln_famincrat >ymax;

drop if ltv >2;


replace hewr = hewra6;
replace hemin = hea6min;
replace hemax = hea6max;



* keep data in two year blocks...;
keep if year >=1999 | year ==1997 | year ==1995 | year ==1993 | year ==1991 | year ==1989 | year ==1987 | year ==1985;


reg ln_cons_fullxh  ln_famincrat ayr3 hewr dl_le2_labincr_adj avg_labincr ib1984.year  i.state   i.coh famsize ageh age2 age3  
if moved ==0  & howner ==1  & l_howner ==1  & hewr >hemin & hewr <hemax & dl_le2_labincr < ygmax
& dl_le2_labincr >ygmin & ageh <65 & ayr3>=0 & ayr3<1, robust ;
estimates store b1;



reg ln_cons_fullxh  ln_famincrat ayr3 hewr dl_le2_labincr_adj avg_labincr ib1984.year  i.state   i.coh famsize ageh age2 age3  yppg R lnypp yppgf
if moved ==0  & howner ==1  & l_howner ==1  & hewr >hemin & hewr <hemax & dl_le2_labincr < ygmax
& dl_le2_labincr >ygmin & ageh <65 & ayr3>=0 & ayr3<1, robust ;
estimates store b2;


xtreg ln_cons_fullxh ln_famincrat ayr3 hewr famsize ageh age2 age3 ib1984.year dl_le2_labincr_adj  
if moved ==0  & howner ==1  & l_howner ==1   & hewr >hemin & hewr <hemax & dl_le2_labincr < ygmax
& dl_le2_labincr >ygmin & ageh <65 & ayr3>=0 & ayr3<1, fe robust;
estimates store bb1;

xtreg ln_cons_fullxh  ln_famincrat ayr3 hewr famsize ageh age2 age3 ib1984.year dl_le2_labincr_adj 
if moved ==0  & howner ==1  & l_howner ==1  & hewr >hemin & hewr <hemax & dl_le2_labincr < ygmax
& dl_le2_labincr >ygmin & ageh <65 & ayr3>=0 & ayr3<1 & year <=1999, fe robust;
estimates store bb2;



xtreg ln_cons_fullxh ln_famincrat ayr3 hewr famsize ageh age2 age3 ib1984.year dl_le2_labincr_adj  
if moved ==0  & howner ==1  & l_howner ==1   & hewr >hemin & hewr <hemax & dl_le2_labincr < ygmax
& dl_le2_labincr >ygmin & ageh <65  & year >1999 & ayr3>=0 & ayr3<1 , fe robust;
estimates store bb3;


xtreg ln_cons_fullxh  ln_famincrat ayr3 hewr famsize ageh age2 age3 ib1984.year dl_le2_labincr_adj  
if moved ==0  & howner ==1  & l_howner ==1  & hewr >hemin & hewr <hemax & dl_le2_labincr < ygmax
& dl_le2_labincr >ygmin & ageh <65  & year <=1999 & ayr3>=0 & ayr3<.00056 , fe robust;
estimates store bb5d;


xtreg ln_cons_fullxh  ln_famincrat ayr3 hewr famsize ageh age2 age3 ib1984.year dl_le2_labincr_adj  
if moved ==0  & howner ==1  & l_howner ==1  & hewr >hemin & hewr <hemax & dl_le2_labincr < ygmax
& dl_le2_labincr >ygmin & ageh <65  & year <=1999 & ayr3>=.00056 & ayr3<1 , fe robust;
estimates store bb6d;



xtreg ln_cons_fullxh  ln_famincrat ayr3 hewr famsize ageh age2 age3 ib1984.year dl_le2_labincr_adj  
if moved ==0  & howner ==1  & l_howner ==1  & hewr >hemin & hewr <hemax & dl_le2_labincr < ygmax
& dl_le2_labincr >ygmin & ageh <65  & year >1999 & ayr3>=0 & ayr3<.00056 , fe robust;
estimates store bb7d;


xtreg ln_cons_fullxh  ln_famincrat ayr3 hewr famsize ageh age2 age3 ib1984.year dl_le2_labincr_adj  
if moved ==0  & howner ==1  & l_howner ==1  & hewr >hemin & hewr <hemax & dl_le2_labincr < ygmax
& dl_le2_labincr >ygmin & ageh <65  & year >1999 & ayr3>=.00056 & ayr3<1 , fe robust;
estimates store bb8d;


local vars "dl_le2_labincr dl_le2_hlabincr";

#delimit cr
foreach y of local vars {

_pctile `y' if `y' !=. , percentiles(25(25)75)

gen  i`y'_p1 = r(r1)
gen  i`y'_p2 = r(r2)
gen  i`y'_p3 = r(r3)

gen ips_`y'=1 if `y' !=.
replace ips_`y'=2 if (`y'>i`y'_p1 & `y'<=i`y'_p2) & `y' !=.
replace ips_`y'=3 if (`y'>i`y'_p2 & `y'<=i`y'_p3) & `y' !=.
replace ips_`y'=4 if `y'>i`y'_p3 & `y'!=.	

* also want above and below median variable

gen       am_`y' = 1 if `y'>i`y'_p2  & `y' !=.
replace   am_`y' = 0 if `y'<=i`y'_p2  & `y' !=.

}


#delimit ;
gen highy = 1 if ips_dl_le2_labincr ==4;
replace highy = 0 if ips_dl_le2_labincr ~=4 & ips_dl_le2_labincr ~=.;



xtreg ln_cons_fullxh  ln_famincrat ayr3 hewr famsize ageh age2 age3 ib1984.year dl_le2_labincr_adj  
if moved ==0  & howner ==1  & l_howner ==1  & hewr >hemin & hewr <hemax & dl_le2_labincr < ygmax
& dl_le2_labincr >ygmin & ageh <65  & highy ==1 , fe robust;
estimates store bb9d;


xtreg ln_cons_fullxh  ln_famincrat ayr3 hewr famsize ageh age2 age3 ib1984.year dl_le2_labincr_adj  
if moved ==0  & howner ==1  & l_howner ==1  & hewr >hemin & hewr <hemax & dl_le2_labincr < ygmax
& dl_le2_labincr >ygmin & ageh <65  & highy ==0 , fe robust;
estimates store bb10d;



estout    bb1 bb2 bb3 bb5d bb6d bb7d bb8d bb9d bb10d using ~/restat_rev/results/baseline_altct.tex, replace margin style(tex) starlevels(* 0.10 ** 0.05 ***
0.01) cells(b(star fmt(%5.2fc)) se(par fmt(%5.2fc)))  keep (ln_famincrat  hewr dl_le2_labincr_adj  ayr3 
 )   stats(N r2_a rmse, fmt(%5.0f %5.2f %5.2f)) 
  varlabels(ln_famincrat "Log Income" ayr3 "(asset income)/Income" hewr "(Housing Wealth)/Income"
		dl_le2_labincr_adj "Expected Labor Income Growth" 
        lnypp "MSA Income (p.c.)" R "MSA Unemployment Rate"  yppg "MSA Income Growth (p.c)"  yppgf "Expected MSA Income Growth (p.c)")     varwidth(45);


};



