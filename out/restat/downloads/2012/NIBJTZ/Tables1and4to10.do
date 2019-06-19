** Note: this file carries out Table 1, and panels A and B of Tables 4 to 10.

#delimit;
version 10;
set more off;

cd c:\otherresearch\pacificislands\Tonga\Omnibuspaper\ReStatFinalFiles\MS13241Dataarchive\;


clear;
set memory 100m;

use ReStatDataFile.dta, clear;
svyset [pweight=svyweight], psu(houseid);

** Table 1 - check of randomization;

foreach var of varlist hhsizestayers num_adultstayer num_childstayer num_olderadult stayerfem ann_hhstayerearnings2004 {;

svy: mean `var' if one, over(ballotwin);
test [`var']1 = [`var']0;
};

foreach var of varlist female age_months {;

svy: mean `var' if childstayer, over(ballotwin);
test [`var']1 = [`var']0;
};

foreach var of varlist female age height bornTongatapu yearsed inNZbefore2000 inc04 {;

svy: mean `var' if adultstayer, over(ballotwin);
test [`var']1 = [`var']0;
};

foreach var of varlist female age height bornTongatapu yearsed inNZbefore2000 {;

svy: mean `var' if olderadult, over(ballotwin);
test [`var']1 = [`var']0;
};

#delimit ;
* Table 4: Change in household composition;

foreach lhs of varlist hhsize num_adult18to45 num_child num_olderadult {;

if "`lhs'" == "hhsize" {; local ra "replace"; };
else {; local ra "append"; };

ivreg `lhs' (mig_family=ballotwin) [pw=svyweight] if one, robust;
outreg2 using table4.out, nonotes bdec(2) `ra';

};

#delimit ;
foreach lhs of varlist hhsize num_adult18to45 num_child num_olderadult {;

ivreg `lhs' (mig_family=ballotwin) ann_hhstayerearnings2004 stayerfem higheststayered   onTongatapu [pw=svyweight] if one , robust;

outreg2 using table4.out, nonotes bdec(2) append;

};

#delimit ;
* Table 5 - impact on total household income and components;

gen num_alladults= num_adult18to45 + num_olderadult;

qui for var y_broad ann_earnings_hh ag_income_hh grow_value_hh net_remit: gen X_pc = X/hhsize \ gen X_pae = X/(num_alladults + 0.5*num_child);

gen lny_broad_pc = log(y_broad_pc);
gen lny_broad_pae = log(y_broad_pae);


local vars1 "lny_broad_pc y_broad_pc ann_earnings_hh_pc ag_income_hh_pc grow_value_hh_pc net_remit_pc"; 
local vars2 "lny_broad_pae y_broad_pae ann_earnings_hh_pae ag_income_hh_pae grow_value_hh_pae net_remit_pae"; 

foreach lhs of varlist `vars1' {;

if "`lhs'" == "lny_broad_pc" {; local ra "replace"; local dec "3"; };
else {; local ra "append"; local dec "0"; };

ivreg `lhs' (mig_family=ballotwin) [pw=svyweight] if one, robust;
outreg2 using table5.out, nonotes bdec(`dec') `ra';

};

foreach lhs of varlist `vars1' {;
if "`lhs'" == "lny_broad_pc" {; local dec "3"; };
else {; local dec "0"; };

ivreg `lhs' (mig_family=ballotwin) ann_hhstayerearnings2004 stayerfem higheststayered num_childstayer num_adultstayer onTongatapu [pw=svyweight] if one , robust;

outreg2 using table5.out, nonotes bdec(`dec') append;

};

foreach lhs of varlist `vars2' {;
if "`lhs'" == "lny_broad_pae" {; local dec "3"; };
else {; local dec "0"; };

ivreg `lhs' (mig_family=ballotwin) [pw=svyweight] if one, robust;
outreg2 using table5.out, nonotes bdec(`dec') append;

};

foreach lhs of varlist `vars2' {;
if "`lhs'" == "lny_broad_pae" {; local dec "3"; };
else {; local dec "0"; };

ivreg `lhs' (mig_family=ballotwin) ann_hhstayerearnings2004 stayerfem higheststayered num_childstayer num_adultstayer onTongatapu [pw=svyweight] if one , robust;

outreg2 using table5.out, nonotes bdec(`dec') append;

};

* Table 6 - household assets;
#delimit ;
local varcon "ownhome  house_improve  wealth_nocar numcars  s8q2a_pigs s8q2b_chicken s8q2c_cattle bankaccount atmcard"; 


foreach lhs of varlist `varcon'   {;

if "`lhs'" == "ownhome" {; local ra "replace"; };
else {; local ra "append"; };

ivreg `lhs' (mig_family=ballotwin) [pw=svyweight] if one , robust;

outreg2 using table6.out, nonotes bdec(3) `ra';

};

foreach lhs of varlist `varcon'  {;

ivreg `lhs' (mig_family=ballotwin) ann_hhstayerearnings2004 stayerfem higheststayered num_childstayer num_adultstayer onTongatapu [pw=svyweight] if one , robust;

outreg2 using table6.out, nonotes bdec(3) append;

};


* Table 7 - diet;
#delimit ;
foreach lhs of varlist food_rice food_roots food_fruitveg food_fish food_fats food_meat food_milk {;

if "`lhs'" == "food_rice" {; local ra "replace"; };
else {; local ra "append"; };

ivreg `lhs' (mig_family=ballotwin) [pw=svyweight] if one, robust;
outreg2 using table7.out, nonotes bdec(3) `ra';

};

foreach lhs of varlist food_rice food_roots food_fruitveg food_fish food_fats food_meat food_milk {;

ivreg `lhs' (mig_family=ballotwin) ann_hhstayerearnings2004 stayerfem higheststayered num_childstayer num_adultstayer onTongatapu dday2-dday7 [pw=svyweight] if one , robust;

outreg2 using table7.out, nonotes bdec(3) append;

};

* Table 8 - Outcomes for Adults;
gen male=s1q2;
replace male=0 if male==2;

#delimit ;
local vardis "businessowner main_agriculture studying vghealth cursmokes";  
local varcon "alcohol_cont bmi  waist_hip"; 
ivreg employed (mig_family=ballotwin) [pw=svyweight] if adultstayer & male==1, cluster(houseid);
ivreg employed (mig_family=ballotwin) [pw=svyweight] if adultstayer & male==0, cluster(houseid);


foreach lhs of varlist  `vardis' `varcon' {;

if "`lhs'" == "businessowner" {; local ra "replace"; };
else {; local ra "append"; };

ivreg `lhs' (mig_family=ballotwin) [pw=svyweight] if adultstayer, cluster(houseid);

outreg2 using table8.out, nonotes bdec(3) `ra';

};
#delimit ;

ivreg employed (mig_family=ballotwin) female age yearsed height inc04 inc04miss onTongatapu [pw=svyweight] if adultstayer & male==1, cluster(houseid);
ivreg employed (mig_family=ballotwin) female age yearsed height inc04 inc04miss onTongatapu [pw=svyweight] if adultstayer & male==0, cluster(houseid);


local vardis "businessowner main_agriculture studying vghealth cursmokes";  
local varcon "alcohol_cont bmi waist_hip "; 

foreach lhs of varlist  `vardis' `varcon' {;

ivreg `lhs' (mig_family=ballotwin) female age yearsed height inc04 inc04miss onTongatapu [pw=svyweight] if adultstayer, cluster(houseid);

outreg2 using table8.out, nonotes bdec(3) append;

};



* Table 9 - Outcomes for Children;
#delimit ;
replace h_a = . if age_months>36;
gen age_months_c = age_months if age<18 & childstayer;
bys houseid (age_months_c personid): gen parity = _n;

#delimit ;
local vardis "litenglish littongan studying yearsed vghealth bmi_a";  

foreach lhs of varlist  `vardis' {;

if "`lhs'" == "litenglish" {; local ra "replace"; };
else {; local ra "append"; };

ivreg `lhs' (mig_family=ballotwin) [pw=svyweight] if childstayer, cluster(houseid);

outreg2 using table9.out, nonotes bdec(3) `ra';

};

foreach lhs of varlist  `vardis' {;

ivreg `lhs' (mig_family=ballotwin) female age_months age_months_2 parity stayermaleheight stayerfemheight stayermaleage stayerfemage  stayermaleadultyearsed stayerfemaleadultyearsed onTongatapu [pw=svyweight] if childstayer, cluster(houseid);

outreg2 using table9.out, nonotes bdec(3) append;

};



* Table 10 - Outcomes for Older Adults;
#delimit ;
local vardis "businessowner main_agriculture vghealth cursmokes";  
local varcon "alcohol_cont bmi waist_hip diabp"; 

foreach lhs of varlist  `vardis' `varcon' {;

if "`lhs'" == "businessowner" {; local ra "replace"; };
else {; local ra "append"; };

ivreg `lhs' (mig_family=ballotwin) [pw=svyweight] if olderstayer, cluster(houseid);

outreg2 using table11.out, nonotes bdec(3) `ra';

};

#delimit ;
ivreg employed (mig_family=ballotwin) female age yearsed height inc04 inc04miss onTongatapu [pw=svyweight] if olderstayer & male==1, cluster(houseid);
ivreg employed (mig_family=ballotwin) female age yearsed height inc04 inc04miss onTongatapu [pw=svyweight] if olderstayer & male==0, cluster(houseid);


foreach lhs of varlist `vardis' `varcon'  {;

ivreg `lhs' (mig_family=ballotwin) female age yearsed height inc04 inc04miss onTongatapu [pw=svyweight] if olderstayer, cluster(houseid);

outreg2 using table11.out, nonotes bdec(3) append;

};




