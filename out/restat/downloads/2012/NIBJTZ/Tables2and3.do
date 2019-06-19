*** This file carries out Tables 2 and 3, and panel C of Tables 4-10 for the PINZMS data


#delimit;
version 10;
set more off;

cd c:\otherresearch\pacificislands\Tonga\Omnibuspaper\ReStatFinalFiles\MS13241Dataarchive\;


clear;
set memory 100m;

use ReStatDataFile2.dta, clear;
svyset [pweight=svyweight], psu(houseid);


** Table 2 - Household Selection;
replace ballotsample=0 if ballotsample==.;


*** household composition variables;
* compare ballot losers by whether all move or not;
#delimit ;
foreach lhs of varlist hhsize num_adult18to45 num_child num_olderadult {;
ttest `lhs' if ballotsample==1 & ballotwin==0 & one==1, by(all_move);
};
* compare non-applicant stayers to ballot loser stayers;
#delimit ;
foreach lhs of varlist hhsize num_adult18to45 num_child num_olderadult {;
ttest `lhs' if ((ballotsample==1 & ballotwin==0 & all_move==0)|(ballotsample==0 & all_move==0)) & one==1, by(ballotsample);
};
* compare all non-applicants to ballot loser stayers;
#delimit ;
foreach lhs of varlist hhsize num_adult18to45 num_child num_olderadult {;
ttest `lhs' if ((ballotsample==1 & ballotwin==0 & all_move==0)|(ballotsample==0)) & one==1, by(ballotsample);
};

*** household income and consumption;
#delimit ;

#delimit ;
local vars1 "lny_broad_pc y_broad_pc ann_earnings_hh_pc ag_income_hh_pc grow_value_hh_pc net_remit_pc"; 
* compare ballot losers by whether all move or not;
foreach lhs of varlist `vars1' {;
ttest `lhs' if ballotsample==1 & ballotwin==0 & one==1, by(all_move);
};
* compare non-applicant stayers to ballot loser stayers
#delimit ;
local vars1 "lny_broad_pc y_broad_pc ann_earnings_hh_pc ag_income_hh_pc grow_value_hh_pc net_remit_pc"; 
foreach lhs of varlist `vars1'  {;
ttest `lhs' if ((ballotsample==1 & ballotwin==0 & all_move==0)|(ballotsample==0 & all_move==0)) & one==1, by(ballotsample);
};
* compare all non-applicants to ballot loser stayers
#delimit ;
local vars1 "lny_broad_pc y_broad_pc ann_earnings_hh_pc ag_income_hh_pc grow_value_hh_pc net_remit_pc"; 
foreach lhs of varlist `vars1' {;
ttest `lhs' if ((ballotsample==1 & ballotwin==0 & all_move==0)|(ballotsample==0)) & one==1, by(ballotsample);
};

*** durables and assets;
#delimit ;
local vars1 "ownhome house_improve wealth_nocar numcars s8q2a_pigs s8q2b_chicken s8q2c_cattle bankaccount atmcard";
* compare ballot losers by whether all move or not;
foreach lhs of varlist `vars1' {;
ttest `lhs' if ballotsample==1 & ballotwin==0 & one==1, by(all_move);
};
* compare non-applicant stayers to ballot loser stayers
#delimit ;
local vars1 "ownhome house_improve wealth_nocar numcars s8q2a_pigs s8q2b_chicken s8q2c_cattle bankaccount atmcard";
foreach lhs of varlist `vars1'  {;
ttest `lhs' if ((ballotsample==1 & ballotwin==0 & all_move==0)|(ballotsample==0 & all_move==0)) & one==1, by(ballotsample);
};
* compare all non-applicants to ballot loser stayers
#delimit ;
local vars1 "ownhome house_improve wealth_nocar numcars s8q2a_pigs s8q2b_chicken s8q2c_cattle bankaccount atmcard";
foreach lhs of varlist `vars1' {;
ttest `lhs' if ((ballotsample==1 & ballotwin==0 & all_move==0)|(ballotsample==0)) & one==1, by(ballotsample);
};

*** diet;

#delimit ;
* compare ballot losers by whether all move or not;
foreach lhs of varlist food_rice food_roots food_fruitveg food_fish food_fats food_meat food_milk {;
ttest `lhs' if ballotsample==1 & ballotwin==0 & one==1, by(all_move);
};
* compare non-applicant stayers to ballot loser stayers
#delimit ;
foreach lhs of varlist food_rice food_roots food_fruitveg food_fish food_fats food_meat food_milk {;
ttest `lhs' if ((ballotsample==1 & ballotwin==0 & all_move==0)|(ballotsample==0 & all_move==0)) & one==1, by(ballotsample);
};
* compare all non-applicants to ballot loser stayers
#delimit ;
foreach lhs of varlist food_rice food_roots food_fruitveg food_fish food_fats food_meat food_milk {;
ttest `lhs' if ((ballotsample==1 & ballotwin==0 & all_move==0)|(ballotsample==0)) & one==1, by(ballotsample);
};



*** Table 3;
gen employedmale=employed if female==0
gen employedfemale=employed if female==1
gen workincome= s4cq7
replace workincome=0 if workincome==.

#delimit ;
* compare ballot losers by whether mover or not;
local vars1 "employedmale employedfemale businessowner main_agriculture studying yearsed workincome vghealth cursmokes alcohol_cont bmi waist_hip diabp mental";  
foreach lhs of varlist `vars1' {;
ttest `lhs' if ballotsample==1 & ballotwin==0 & age>=18 & age<=45, by(stayer);
};

* compare non-applicant stayers to ballot loser stayers
#delimit ;
local vars1 "employedmale employedfemale businessowner main_agriculture studying yearsed workincome vghealth cursmokes alcohol_cont bmi waist_hip diabp mental";  
foreach lhs of varlist `vars1' {;
ttest `lhs' if (ballotsample==1 & ballotwin==0 & age>=18 & age<=45 & all_move==0 & stayer==1)|(ballotsample==0 & all_move==0  & age>=18 & age<=45 &  stayer==1) ,by(ballotsample);
};

* compare all non-applicants to ballot loser stayers
#delimit ;
local vars1 "employedmale employedfemale businessowner main_agriculture studying yearsed workincome vghealth cursmokes alcohol_cont bmi waist_hip diabp mental";  
foreach lhs of varlist `vars1' {;
ttest `lhs' if (ballotsample==1 & ballotwin==0 & age>=18 & age<=45 & all_move==0 & stayer==1)|(ballotsample==0 & age>=18 & age<=45) ,by(ballotsample);
};


*** Children's outcomes;
#delimit ;
bys houseid (age_months_c personid): gen parity = _n;

* compare ballot losers by whether mover or not;
local vars1 "litenglish littongan studying yearsed vghealth bmi_a";  
foreach lhs of varlist `vars1' {;
ttest `lhs' if ballotsample==1 & ballotwin==0 & age<18, by(stayer);
};

* compare non-applicant stayers to ballot loser stayers
#delimit ;
local vars1 "litenglish littongan studying yearsed vghealth bmi_a";  
foreach lhs of varlist `vars1' {;
ttest `lhs' if (ballotsample==1 & ballotwin==0 & age<18 & all_move==0 & stayer==1)|(ballotsample==0 & all_move==0  & age<18 &  stayer==1) ,by(ballotsample);
};

* compare all non-applicants to ballot loser stayers
#delimit ;
local vars1 "litenglish littongan studying yearsed vghealth bmi_a";  
foreach lhs of varlist `vars1' {;
ttest `lhs' if (ballotsample==1 & ballotwin==0 & age<18 & all_move==0 & stayer==1)|(ballotsample==0 & age<18) ,by(ballotsample);
};

*** Older adults;
* note: no movers among older adults;

* compare non-applicant stayers to ballot loser stayers
#delimit ;
local vars1 "employedmale employedfemale businessowner main_agriculture vghealth cursmokes alcohol_cont bmi waist_hip diabp mental";  
foreach lhs of varlist `vars1' {;
ttest `lhs' if (ballotsample==1 & ballotwin==0 & age>45 & age~=. & all_move==0 & stayer==1)|(ballotsample==0 & all_move==0  & age>45 & age~=. &  stayer==1) ,by(ballotsample);
};
* compare all non-applicants to ballot loser stayers
#delimit ;
local vars1 "employedmale employedfemale businessowner main_agriculture vghealth cursmokes alcohol_cont bmi waist_hip diabp mental";  
foreach lhs of varlist `vars1' {;
ttest `lhs' if (ballotsample==1 & ballotwin==0 & age>45 & age~=. & all_move==0 & stayer==1)|(ballotsample==0 & age>45 & age~=.) ,by(ballotsample);
};

*** PANEL C of Tables 4 to 10;
**** Table 4 ;

#delimit ;
foreach lhs of varlist hhsize num_adult18to45 num_child num_olderadult {;
if "`lhs'" == "hhsize" {; local ra "replace"; };
else {; local ra "append"; };

* Experimental comparison with same controls;
ivreg `lhs' (mig_family=ballotwin)   [pw=svyweight] if one & all_move==0, robust;
outreg2 using table2new1.out, nonotes bdec(2) `ra';
* Experimental estimate if ignored whole households which moved;
ivreg `lhs' (mig_family=ballotwin)   [pw=svyweight] if one, robust;
outreg2 using table2new2.out, nonotes bdec(2) `ra';
* OLS estimate using non-applicant stayers;
reg `lhs' mig_family onTongatapu maxhhed loghhinc if one & ((ballotsample==1 & ballotwin==1 & all_move==0)|(ballotsample==0 & all_move==0)), robust;
outreg2 using table2new3.out, nonotes bdec(2) `ra';
* OLS estimates using all non-applicants;
reg `lhs' mig_family onTongatapu maxhhed loghhinc if one & ((ballotsample==1 & ballotwin==1 & all_move==0)|(ballotsample==0)), robust;
outreg2 using table2new4.out, nonotes bdec(2) `ra';

};


*** Table 5;

#delimit ;
local vars1 "lny_broad_pc y_broad_pc ann_earnings_hh_pc ag_income_hh_pc grow_value_hh_pc net_remit_pc"; 
foreach lhs of varlist `vars1' {;

if "`lhs'" == "lny_broad_pc" {; local ra "replace"; local dec "3"; };
else {; local ra "append"; local dec "0"; };

* Experimental comparison with same controls;
ivreg `lhs' (mig_family=ballotwin)   [pw=svyweight] if one & all_move==0, robust;
outreg2 using table3new1.out, nonotes bdec(`dec') `ra';
* Experimental estimate if ignored whole households which moved;
ivreg `lhs' (mig_family=ballotwin)   [pw=svyweight] if one, robust;
outreg2 using table3new2.out, nonotes bdec(`dec') `ra';
* OLS estimate using non-applicant stayers;
reg `lhs' mig_family onTongatapu maxhhed loghhinc if one & ((ballotsample==1 & ballotwin==1 & all_move==0)|(ballotsample==0 & all_move==0)), robust;
outreg2 using table3new3.out, nonotes bdec(`dec') `ra';
* OLS estimates using all non-applicants;
reg `lhs' mig_family onTongatapu maxhhed loghhinc if one & ((ballotsample==1 & ballotwin==1 & all_move==0)|(ballotsample==0)), robust;
outreg2 using table3new4.out, nonotes bdec(`dec') `ra';

};


*** Table 6
#delimit ;
local vars1 "ownhome house_improve wealth_nocar numcars s8q2a_pigs s8q2b_chicken s8q2c_cattle bankaccount atmcard";
foreach lhs of varlist `vars1' {;

if "`lhs'" == "ownhome" {; local ra "replace"; };
else {; local ra "append"; };

* Experimental comparison with same controls;
ivreg `lhs' (mig_family=ballotwin)   [pw=svyweight] if one & all_move==0, robust;
outreg2 using table4new1.out, nonotes bdec(3) `ra';
* Experimental estimate if ignored whole households which moved;
ivreg `lhs' (mig_family=ballotwin)   [pw=svyweight] if one, robust;
outreg2 using table4new2.out, nonotes bdec(3) `ra';
* OLS estimate using non-applicant stayers;
reg `lhs' mig_family onTongatapu maxhhed loghhinc if one & ((ballotsample==1 & ballotwin==1 & all_move==0)|(ballotsample==0 & all_move==0)), robust;
outreg2 using table4new3.out, nonotes bdec(3) `ra';
* OLS estimates using all non-applicants;
reg `lhs' mig_family onTongatapu maxhhed loghhinc if one & ((ballotsample==1 & ballotwin==1 & all_move==0)|(ballotsample==0)), robust;
outreg2 using table4new4.out, nonotes bdec(3) `ra';

};

*** Table 7

#delimit ;
foreach lhs of varlist food_rice food_roots food_fruitveg food_fish food_fats food_meat food_milk {;

if "`lhs'" == "food_rice" {; local ra "replace"; };
else {; local ra "append"; };

* Experimental comparison with same controls;
ivreg `lhs' (mig_family=ballotwin)   [pw=svyweight] if one & all_move==0, robust;
outreg2 using table5new1.out, nonotes bdec(3) `ra';
* Experimental estimate if ignored whole households which moved;
ivreg `lhs' (mig_family=ballotwin)   [pw=svyweight] if one, robust;
outreg2 using table5new2.out, nonotes bdec(3) `ra';
* OLS estimate using non-applicant stayers;
reg `lhs' mig_family onTongatapu maxhhed loghhinc if one & ((ballotsample==1 & ballotwin==1 & all_move==0)|(ballotsample==0 & all_move==0)), robust;
outreg2 using table5new3.out, nonotes bdec(3) `ra';
* OLS estimates using all non-applicants;
reg `lhs' mig_family onTongatapu maxhhed loghhinc if one & ((ballotsample==1 & ballotwin==1 & all_move==0)|(ballotsample==0)), robust;
outreg2 using table5new4.out, nonotes bdec(3) `ra';

};


*** Table 8

#delimit ;
local vars1 "employedmale employedfemale businessowner main_agriculture studying vghealth cursmokes alcohol_cont bmi waist_hip diabp mental";  
foreach lhs of varlist `vars1' {;

if "`lhs'" == "employedmale" {; local ra "replace"; };
else {; local ra "append"; };

* Experimental comparison with same controls;
ivreg `lhs' (mig_family=ballotwin) female age yearsed height inc04 inc04miss onTongatapu   [pw=svyweight] if ballotsample==1 & all_move==0 & stayer==1 & age>=18 & age<=45, cluster(houseid);;
outreg2 using table6new1.out, nonotes bdec(3) `ra';
* Experimental estimate if ignored movers;
ivreg `lhs' (mig_family=ballotwin)  female age yearsed height inc04 inc04miss onTongatapu  [pw=svyweight] if ballotsample==1 & age>=18 & age<=45, cluster(houseid);;
outreg2 using table6new2.out, nonotes bdec(3) `ra';
* OLS estimate using non-applicant stayers;
reg `lhs' mig_family female age yearsed height inc04 inc04miss onTongatapu   if (ballotsample==1 & ballotwin==1 & age>=18 & age<=45 & all_move==0 & stayer==1)|(ballotsample==0 & all_move==0  & age>=18 & age<=45 &  stayer==1), cluster(houseid);;
outreg2 using table6new3.out, nonotes bdec(3) `ra';
* OLS estimates using all non-applicants;
reg `lhs' mig_family female age yearsed height inc04 inc04miss onTongatapu   if (ballotsample==1 & ballotwin==1 & age>=18 & age<=45 & all_move==0 & stayer==1)|(ballotsample==0 &  age>=18 & age<=45), cluster(houseid);;
outreg2 using table6new4.out, nonotes bdec(3) `ra';
};


**** Table 9
#delimit ;
local vars1 "litenglish littongan studying yearsed vghealth bmi_a";  
foreach lhs of varlist `vars1' {;

if "`lhs'" == "litenglish" {; local ra "replace"; };
else {; local ra "append"; };

* Experimental comparison with same controls;
ivreg `lhs' (mig_family=ballotwin) female age_months age_months_2 parity onTongatapu maxhhed loghhinc   [pw=svyweight] if ballotsample==1 & all_move==0 & stayer==1 & age<18, cluster(houseid);;
outreg2 using table7new1.out, nonotes bdec(3) `ra';
* Experimental estimate if ignored movers;
ivreg `lhs' (mig_family=ballotwin)  female age_months age_months_2 parity onTongatapu maxhhed loghhinc  [pw=svyweight] if ballotsample==1 & age<18, cluster(houseid);;
outreg2 using table7new2.out, nonotes bdec(3) `ra';
* OLS estimate using non-applicant stayers;
reg `lhs' mig_family female age_months age_months_2 parity onTongatapu maxhhed loghhinc   if (ballotsample==1 & ballotwin==1 & age<18 & all_move==0 & stayer==1)|(ballotsample==0 & all_move==0  &  age<18 &  stayer==1), cluster(houseid);;
outreg2 using table7new3.out, nonotes bdec(3) `ra';
* OLS estimates using all non-applicants;
reg `lhs' mig_family female age_months age_months_2 parity onTongatapu maxhhed loghhinc   if (ballotsample==1 & ballotwin==1 & age<18 & all_move==0 & stayer==1)|(ballotsample==0 &  age<18), cluster(houseid);;
outreg2 using table7new4.out, nonotes bdec(3) `ra';

};

*** Table 10
#delimit ;
local vars1 "employedmale employedfemale businessowner main_agriculture vghealth cursmokes alcohol_cont bmi waist_hip diabp mental";  
foreach lhs of varlist `vars1' {;

if "`lhs'" == "employedmale" {; local ra "replace"; };
else {; local ra "append"; };

* Experimental comparison with same controls;
ivreg `lhs' (mig_family=ballotwin) female age yearsed height inc04 inc04miss onTongatapu    [pw=svyweight] if ballotsample==1 & all_move==0 & stayer==1 & age>45 & age~=., cluster(houseid);;
outreg2 using table8new1.out, nonotes bdec(3) `ra';
* OLS estimate using non-applicant stayers;
reg `lhs' mig_family female age yearsed height inc04 inc04miss onTongatapu    if (ballotsample==1 & ballotwin==1 & age>45 & age~=. & all_move==0 & stayer==1)|(ballotsample==0 & all_move==0  & age>45 & age~=. &  stayer==1), cluster(houseid);;
outreg2 using table8new3.out, nonotes bdec(3) `ra';
};


