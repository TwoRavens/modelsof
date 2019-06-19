* Table 11 - p-values and family wise adjusted p-values

* Modified from our files and appendix in Katz, Kling and Liebman

* First Save True p-values and True parameters

#delimit;
version 10;
set more off;

cd c:\otherresearch\pacificislands\Tonga\Omnibuspaper\ReStatFinalFiles\MS13241Dataarchive\;


clear;
set memory 100m;

use ReStatDataFile.dta, clear;
svyset [pweight=svyweight], psu(houseid);

* Table 2: Change in household composition;

foreach lhs of varlist hhsize num_adult18to45 num_child num_olderadult {;
ivreg `lhs' (mig_family=ballotwin) ann_hhstayerearnings2004 stayerfem higheststayered  num_childstayer num_adultstayer onTongatapu [pw=svyweight] if one , robust;
gen beta_`lhs'=_b[mig_family];
test mig_family;
gen pval_`lhs' = r(p);
};

* Table 3 - impact on total household income and components;
local vars1 "lny_broad_pc y_broad_pc ann_earnings_hh_pc ag_income_hh_pc grow_value_hh_pc net_remit_pc"; 
local vars2 "lny_broad_pae y_broad_pae ann_earnings_hh_pae ag_income_hh_pae grow_value_hh_pae net_remit_pae"; 
foreach lhs of varlist `vars1' `vars2' {;
ivreg `lhs' (mig_family=ballotwin) ann_hhstayerearnings2004 stayerfem higheststayered num_childstayer num_adultstayer onTongatapu [pw=svyweight] if one , robust;
gen beta_`lhs'=_b[mig_family];
test mig_family;
gen pval_`lhs' = r(p);
};

* Table 4 - household assets;
#delimit ;
local vardis "ownhome house_improve bankaccount atmcard";
local varcon "wealth_nocar numcars  s8q2a_pigs s8q2b_chicken s8q2c_cattle"; 
foreach lhs of varlist `varcon' `vardis' {;
ivreg `lhs' (mig_family=ballotwin) ann_hhstayerearnings2004 stayerfem higheststayered num_childstayer num_adultstayer onTongatapu [pw=svyweight] if one , robust;
gen beta_`lhs'=_b[mig_family];
test mig_family;
gen pval_`lhs' = r(p);
};
 
* Table 5 - diet;

foreach lhs of varlist food_rice food_roots food_fruitveg food_fish food_fats food_meat food_milk {;
ivreg `lhs' (mig_family=ballotwin) ann_hhstayerearnings2004 stayerfem higheststayered num_childstayer num_adultstayer onTongatapu dday2-dday7 [pw=svyweight] if one , robust;
gen beta_`lhs'=_b[mig_family];
test mig_family;
gen pval_`lhs' = r(p);
};

* Table 6 - Outcomes for Adults;
#delimit ;
local vardis "businessowner main_agriculture studying vghealth cursmokes";  * vghealth = convergence problem;
local varcon "alcohol_cont bmi  waist_hip diabp mental"; 
ivreg employed (mig_family=ballotwin) age yearsed height inc04 inc04miss onTongatapu [pw=svyweight] if adultstayer & female==0, cluster(houseid);
gen betaemploymale=_b[mig_family];
test mig_family;
gen pvalemploymale = r(p);
ivreg employed (mig_family=ballotwin) age yearsed height inc04 inc04miss onTongatapu [pw=svyweight] if adultstayer & female==1, cluster(houseid);
gen betaemployfemale=_b[mig_family];
test mig_family;
gen pvalemployfemale = r(p);
foreach lhs of varlist `varcon' `vardis' {;
ivreg `lhs' (mig_family=ballotwin) female age yearsed height inc04 inc04miss onTongatapu [pw=svyweight] if adultstayer, cluster(houseid);
gen betaadult_`lhs'=_b[mig_family];
test mig_family;
gen pvaladult_`lhs' = r(p);
};

#delimit ;
* Table 7 - Outcomes for Children;
local vardis "litenglish littongan studying vghealth";  
local varcon "yearsed h_a bmi_a"; 
foreach lhs of varlist `varcon' `vardis' {;
ivreg `lhs' (mig_family=ballotwin) female age_months age_months_2 parity stayermaleheight stayerfemheight stayermaleage stayerfemage  stayermaleadultyearsed stayerfemaleadultyearsed onTongatapu [pw=svyweight] if childstayer, cluster(houseid);
gen betakid_`lhs'=_b[mig_family];
test mig_family;
gen pvalkid_`lhs' = r(p);
};

* Table 8 - Outcomes for Older Adults;
#delimit ;
local vardis "businessowner main_agriculture vghealth cursmokes";  
local varcon "alcohol_cont bmi waist_hip diabp mental"; 
ivreg employed (mig_family=ballotwin) age yearsed height inc04 inc04miss onTongatapu [pw=svyweight] if olderstayer & female==0, cluster(houseid);
gen betaemploymale_oa=_b[mig_family];
test mig_family;
gen pvalemploymale_oa = r(p);
ivreg employed (mig_family=ballotwin) age yearsed height inc04 inc04miss onTongatapu [pw=svyweight] if olderstayer & female==1, cluster(houseid);
gen betaemployfemale_oa=_b[mig_family];
test mig_family;
gen pvalemployfemale_oa = r(p);
foreach lhs of varlist `varcon' `vardis' {;
ivreg `lhs' (mig_family=ballotwin) female age yearsed height inc04 inc04miss onTongatapu [pw=svyweight] if olderstayer, cluster(houseid);
gen betaoa_`lhs'=_b[mig_family];
test mig_family;
gen pvaloa_`lhs' = r(p);
};
collapse beta_hhsize- pvaloa_cursmokes;
save  truepvalues.dta, replace;


*******************
* Bootstrap replications
#delimit ;
capture program drop pvaluesOmnibus;
program define pvaluesOmnibus;

* make beta scalar, merge in 1.

#delimit ;
use  ReStatDataFile.dta, clear;
bsample;
merge using  truepvalues.dta;
qui svyset [pweight=svyweight], psu(houseid);
gsort -_merge;
#delimit ;
* Table 2: Change in household composition;

foreach lhs of varlist hhsize num_adult18to45 num_child num_olderadult {;
qui scalar b_`lhs'=beta_`lhs';
qui ivreg `lhs' (mig_family=ballotwin) ann_hhstayerearnings2004 stayerfem higheststayered  num_childstayer num_adultstayer onTongatapu [pw=svyweight] if one , robust;
qui test mig_family==b_`lhs';
qui gen bpval_`lhs' = r(p);
};

* Table 3 - impact on total household income and components;
local vars1 "lny_broad_pc y_broad_pc ann_earnings_hh_pc ag_income_hh_pc grow_value_hh_pc net_remit_pc"; 
local vars2 "lny_broad_pae y_broad_pae ann_earnings_hh_pae ag_income_hh_pae grow_value_hh_pae net_remit_pae"; 
foreach lhs of varlist `vars1' `vars2' {;
qui scalar b_`lhs'=beta_`lhs';
qui ivreg `lhs' (mig_family=ballotwin) ann_hhstayerearnings2004 stayerfem higheststayered num_childstayer num_adultstayer onTongatapu [pw=svyweight] if one , robust;
qui test mig_family==b_`lhs';
qui gen bpval_`lhs' = r(p);
};

* Table 4 - household assets;
#delimit ;
local vardis "ownhome house_improve bankaccount atmcard";
local varcon "wealth_nocar numcars  s8q2a_pigs s8q2b_chicken s8q2c_cattle"; 
foreach lhs of varlist `varcon' `vardis' {;
qui scalar b_`lhs'=beta_`lhs';
qui ivreg `lhs' (mig_family=ballotwin) ann_hhstayerearnings2004 stayerfem higheststayered num_childstayer num_adultstayer onTongatapu [pw=svyweight] if one , robust;
qui test mig_family==b_`lhs';
qui gen bpval_`lhs' = r(p);
};
 
* Table 5 - diet;

foreach lhs of varlist food_rice food_roots food_fruitveg food_fish food_fats food_meat food_milk {;
qui scalar b_`lhs'=beta_`lhs';
qui ivreg `lhs' (mig_family=ballotwin) ann_hhstayerearnings2004 stayerfem higheststayered num_childstayer num_adultstayer onTongatapu dday2-dday7 [pw=svyweight] if one , robust;
qui test mig_family==b_`lhs';
qui gen bpval_`lhs' = r(p);
};

* Table 6 - Outcomes for Adults;
#delimit ;
local vardis "businessowner main_agriculture studying vghealth cursmokes";  * vghealth = convergence problem;
local varcon "alcohol_cont bmi  waist_hip diabp mental"; 
qui scalar b_employmale=betaemploymale;
qui scalar b_employfemale=betaemployfemale;
qui ivreg employed (mig_family=ballotwin) age yearsed height inc04 inc04miss onTongatapu [pw=svyweight] if adultstayer & female==0, cluster(houseid);
qui test mig_family==b_employmale;
qui gen bpvalemploymale = r(p);
qui ivreg employed (mig_family=ballotwin) age yearsed height inc04 inc04miss onTongatapu [pw=svyweight] if adultstayer & female==1, cluster(houseid);
qui test mig_family==b_employfemale;
qui gen bpvalemployfemale = r(p);
foreach lhs of varlist `varcon' `vardis' {;
qui scalar b_`lhs'=betaadult_`lhs';
qui ivreg `lhs' (mig_family=ballotwin) female age yearsed height inc04 inc04miss onTongatapu [pw=svyweight] if adultstayer, cluster(houseid);
qui test mig_family==b_`lhs';
qui gen bpvaladult_`lhs' = r(p);
};

* Table 7 - Outcomes for Children;
local vardis "litenglish littongan studying vghealth";  
local varcon "yearsed h_a bmi_a"; 
foreach lhs of varlist `varcon' `vardis' {;
qui scalar b_`lhs'=betakid_`lhs';
qui ivreg `lhs' (mig_family=ballotwin) female age_months age_months_2 parity stayermaleheight stayerfemheight stayermaleage stayerfemage  stayermaleadultyearsed stayerfemaleadultyearsed onTongatapu [pw=svyweight] if childstayer, cluster(houseid);
qui test mig_family==b_`lhs';
qui gen bpvalkid_`lhs' = r(p);
};

* Table 8 - Outcomes for Older Adults;
#delimit ;
local vardis "businessowner main_agriculture vghealth cursmokes";  
local varcon "alcohol_cont bmi waist_hip diabp mental"; 
qui scalar b_employmale_oa=betaemploymale_oa;
qui scalar b_employfemale_oa=betaemployfemale_oa;
qui ivreg employed (mig_family=ballotwin) age yearsed height inc04 inc04miss onTongatapu [pw=svyweight] if olderstayer & female==0, cluster(houseid);
qui test mig_family==b_employmale_oa;
qui gen bpvalemploymale_oa = r(p);
qui ivreg employed (mig_family=ballotwin) age yearsed height inc04 inc04miss onTongatapu [pw=svyweight] if olderstayer & female==1, cluster(houseid);
qui test mig_family==b_employfemale_oa;
qui gen bpvalemployfemale_oa = r(p);
foreach lhs of varlist `varcon' `vardis' {;
qui scalar boa_`lhs'=betaoa_`lhs';
qui ivreg `lhs' (mig_family=ballotwin) female age yearsed height inc04 inc04miss onTongatapu [pw=svyweight] if olderstayer, cluster(houseid);
qui test mig_family==boa_`lhs';
qui gen bpvaloa_`lhs' = r(p);
};
collapse bpval_hhsize- bpvaloa_cursmokes;
end;

* Bootstrap replications
#delimit ;
set seed 123456;
pvaluesOmnibus;
gen iteration=1;
save  bootpvals.dta, replace;

#delimit ;
local maxiter = 10000;
local iter = 2;
while `iter' <= `maxiter'
{;
	pvaluesOmnibus;
	gen iteration=`iter';
	append using  bootpvals.dta;
	save  bootpvals.dta, replace;
	disp "***ITERATION `iter'***";
	local iter = `iter' + 1;
};

***** Generate minimum bootstrap values
* first sort bootstrap p-values in increasing order of actual p-values
#delimit ;
order bpval_num_adult18to45 bpval_hhsize  bpval_net_remit_pc bpval_atmcard
bpval_net_remit_pae  bpval_food_fruitveg bpval_ann_earnings_hh_pae
bpval_ann_earnings_hh_pc
bpvaladult_waist_hip  bpval_s8q2b_chicken
bpval_food_roots bpval_food_fats  bpvaladult_bmi
bpval_bankaccount bpvalkid_litenglish bpvaladult_main_agriculture
bpval_lny_broad_pae bpvaladult_businessowner  ;

* merge in actual p-values
#delimit ;
cross using  truepvalues.dta;

* generate successive minimums, for all 62 first
#delimit ;
egen min_num_adult18to45=rowmin(bpval_num_adult18to45-bpvaloa_cursmokes);
count if min_num_adult18to45<pval_num_adult18to45;
#delimit ;
egen min_hhsize=rowmin(bpval_hhsize-bpvaloa_cursmokes);
count if min_hhsize<pval_hhsize;
egen min_num_child=rowmin(bpval_num_child-bpvaloa_cursmokes);
count if min_num_child<pval_num_child;
egen min_net_remit_pc=rowmin(bpval_net_remit_pc-bpvaloa_cursmokes);
count if min_net_remit_pc<pval_net_remit_pc;
egen min_net_remit_pae=rowmin(bpval_net_remit_pae-bpvaloa_cursmokes);
count if min_net_remit_pae<pval_net_remit_pae;
egen min_atmcard=rowmin(bpval_atmcard-bpvaloa_cursmokes);
count if min_atmcard<pval_atmcard;
egen min_food_fruitveg=rowmin(bpval_food_fruitveg-bpvaloa_cursmokes);
count if min_food_fruitveg<pval_food_fruitveg;
egen min_ann_earnings_hh_pae=rowmin(bpval_ann_earnings_hh_pae-bpvaloa_cursmokes);
count if min_ann_earnings_hh_pae<pval_ann_earnings_hh_pae;

# now look at families
#delimit ;
egen min_num_adult18to45a=rowmin(bpval_num_adult18to45 bpval_hhsize bpval_num_child bpval_num_older);
count if min_num_adult18to45a<pval_num_adult18to45;
#delimit ;
egen min_hhsizea=rowmin(bpval_hhsize bpval_num_child bpval_num_older);
count if min_hhsizea<pval_hhsize;
#delimit ;
egen min_num_childa=rowmin(bpval_num_child bpval_num_older);
count if min_num_childa<pval_num_child;

#delimit ;
egen min_bpval_net_remit_pc=rowmin(bpval_net_remit_pc bpval_net_remit_pae bpval_ann_earnings_hh_pae
bpval_ann_earnings_hh_pc bpval_lny_broad_pae bpval_lny_broad_pc bpval_y_broad_pae bpval_y_broad_pc
bpval_ag_income_hh_pae bpval_ag_income_hh_pc bpval_grow_value_hh_pae bpval_grow_value_hh_pc);
count if min_bpval_net_remit_pc<pval_net_remit_pc;

#delimit ;
egen min_bpval_net_remit_pae=rowmin( bpval_net_remit_pae bpval_ann_earnings_hh_pae
bpval_ann_earnings_hh_pc bpval_lny_broad_pae bpval_lny_broad_pc bpval_y_broad_pae bpval_y_broad_pc
bpval_ag_income_hh_pae bpval_ag_income_hh_pc bpval_grow_value_hh_pae bpval_grow_value_hh_pc);
count if min_bpval_net_remit_pae<pval_net_remit_pae;

#delimit ;
corr bpval_net_remit_pc bpval_net_remit_pae bpval_ann_earnings_hh_pae
bpval_ann_earnings_hh_pc bpval_lny_broad_pae bpval_lny_broad_pc bpval_y_broad_pae bpval_y_broad_pc
bpval_ag_income_hh_pae bpval_ag_income_hh_pc bpval_grow_value_hh_pae bpval_grow_value_hh_pc;

#delimit ;
egen min_bpval_net_remit_pae=rowmin( bpval_net_remit_pae bpval_ann_earnings_hh_pae
bpval_ann_earnings_hh_pc bpval_lny_broad_pae bpval_lny_broad_pc bpval_y_broad_pae bpval_y_broad_pc
bpval_ag_income_hh_pae bpval_ag_income_hh_pc bpval_grow_value_hh_pae bpval_grow_value_hh_pc);
count if min_bpval_net_remit_pae<pval_net_remit_pae;

#delimit ;
egen min_bpval_ann_earnings_hh_pae=rowmin(bpval_ann_earnings_hh_pae
bpval_ann_earnings_hh_pc bpval_lny_broad_pae bpval_lny_broad_pc bpval_y_broad_pae bpval_y_broad_pc
bpval_ag_income_hh_pae bpval_ag_income_hh_pc bpval_grow_value_hh_pae bpval_grow_value_hh_pc);
count if min_bpval_ann_earnings_hh_pae<pval_ann_earnings_hh_pae;

#delimit ;
egen min_bpval_ann_earnings_hh_pc=rowmin(
bpval_ann_earnings_hh_pc bpval_lny_broad_pae bpval_lny_broad_pc bpval_y_broad_pae bpval_y_broad_pc
bpval_ag_income_hh_pae bpval_ag_income_hh_pc bpval_grow_value_hh_pae bpval_grow_value_hh_pc);
count if min_bpval_ann_earnings_hh_pc<pval_ann_earnings_hh_pc;

#delimit ;
egen min_bpval_lny_broad_pae=rowmin(
 bpval_lny_broad_pae bpval_lny_broad_pc bpval_y_broad_pae bpval_y_broad_pc
bpval_ag_income_hh_pae bpval_ag_income_hh_pc bpval_grow_value_hh_pae bpval_grow_value_hh_pc);
count if min_bpval_lny_broad_pae<pval_lny_broad_pae;

#delimit ;
egen min_bpval_atmcard=rowmin(bpval_atmcard bpval_bankaccount 
bpval_ownhome bpval_house_improve 
bpval_wealth_nocar bpval_numcars  bpval_s8q2a_pigs bpval_s8q2b_chicken bpval_s8q2c_cattle);
count if min_bpval_atmcard<pval_atmcard;

#delimit ;
corr bpval_atmcard bpval_bankaccount 
bpval_ownhome bpval_house_improve 
bpval_wealth_nocar bpval_numcars  bpval_s8q2a_pigs bpval_s8q2b_chicken bpval_s8q2c_cattle;

#delimit ;
egen min_bpval_bankaccount =rowmin(bpval_bankaccount 
bpval_ownhome bpval_house_improve 
bpval_wealth_nocar bpval_numcars  bpval_s8q2a_pigs bpval_s8q2b_chicken bpval_s8q2c_cattle);
count if min_bpval_bankaccount <pval_bankaccount ;

#delimit ;
egen min_bpvaladult_waist_hip=rowmin(bpvaladult_waist_hip bpvaladult_bmi
bpvaladult_main_agriculture bpvaladult_businessowner  
bpvaladult_studying bpvaladult_vghealth 
bpvaladult_cursmokes
bpvaladult_alcohol_cont    bpvaladult_diabp bpvaladult_mental 
bpvalemploymale bpvalemployfemale);
count if min_bpvaladult_waist_hip<pvaladult_waist_hip;

#delimit ;
egen min_bpvaladult_bmi=rowmin(bpvaladult_bmi
bpvaladult_main_agriculture bpvaladult_businessowner  
bpvaladult_studying bpvaladult_vghealth 
bpvaladult_cursmokes
bpvaladult_alcohol_cont    bpvaladult_diabp bpvaladult_mental 
bpvalemploymale bpvalemployfemale);
count if min_bpvaladult_bmi<pvaladult_bmi;

#delimit ;
egen min_bpvaladult_main_agriculture=rowmin(
bpvaladult_main_agriculture bpvaladult_businessowner  
bpvaladult_studying bpvaladult_vghealth 
bpvaladult_cursmokes
bpvaladult_alcohol_cont    bpvaladult_diabp bpvaladult_mental 
bpvalemploymale bpvalemployfemale);
count if min_bpvaladult_main_agriculture<pvaladult_main_agriculture;

#delimit ;
egen min_bpvaladult_businessowner  =rowmin(
bpvaladult_businessowner  
bpvaladult_studying bpvaladult_vghealth 
bpvaladult_cursmokes
bpvaladult_alcohol_cont    bpvaladult_diabp bpvaladult_mental 
bpvalemploymale bpvalemployfemale);
count if min_bpvaladult_businessowner  <pvaladult_businessowner  ;

#delimit ;
egen min_bpvalkid_litenglish=rowmin(
bpvalkid_litenglish bpvalkid_littongan bpvalkid_studying bpvalkid_vghealth  
bpvalkid_yearsed bpvalkid_h_a bpvalkid_bmi_a);
count if min_bpvalkid_litenglish<pvalkid_litenglish;
