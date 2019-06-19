# delimit;
set more off;

* this program generates the results for c-section births for tables 3 and 5;
* from in Evans/Garthwaite, "Estimating heterogeneity in the benefits;
* of medical treatment intensity," Review of Economics and Statistics;
* 2012, 94(3), 635-649;

* there is a virtually identical program for vaginal births;

set mem 1000m;
set matsize 800;

log using results_in_paper_final_csection.log, replace;
use stata_all_2;

*sample 5;

********* redo problem 22 and 23;
drop prob22 prob23;
gen prob22=bthwght>=4000;
gen prob23=bthwght<2500;

destring typebth, replace;


* construct bw in ounces;
gen bwounce=int(bthwght/28.3495231);

drop if bwounce<68;
drop if bwounce>180;
drop if statelaw==1;
* delete transfers;
destring disstat95i, replace;
keep if disstat95i==1 | disstat95i==12 | disstat95i==10 | disstat95i==9;
gen medicaid=payer_delivery==2;
gen private=payer_delivery==1;

drop disstat95i;
destring admmnthi, replace;
drop if admmnthi==.;

* delete < 26 weeks;
* top code all the outliers;
* delete the 999s;

replace gest=. if gest==999;
replace gest=. if gest>45*7;
replace gest=. if gest<26*7;
drop if gest==.;

* create cubic in gestation weeks;
gen gest1=gest;
gen gest2=gest1*gest1/1000;
gen gest3=gest1*gest1*gest1/10000;
drop gest;

* 
destring hplhsa,generate(hsa);

* define a variable that identifies when the;
* law was extended to medicaid patients in CA;
gen med1397=trend>48;

* construct indicators for csection and;
* vaginal deliveries;
gen csec=delivery==2;
gen vag=csec==0;


* an early discharge is one that is < two nights;
* stay for vaginal deliveries, 4 nights stay for;
* csections;
gen early1=_losi<2 & vag==1;
gen early2=_losi<4 & csec==1;
gen early=early1+early2;

* free up some space by dropping some variables;
drop _losi early1 early2;

* generate a 2 digit variable that identifies;
* delivery and payer;
gen ins_csec=10*medicaid+csec;

* construct quadratic in birthweight;
gen bw1=bwounce;
gen bw2=bw1*bw1/100;
gen bw3=bw1*bw1*bw1/10000;

* these are the law interactions;
* we have three treatments -- the state law, the federal;
* law and the expansion of the state law to medicaid patients;
* we allow for the laws to impact c-section and vaginal births;
* differently and for these effects to vary by payer;
* (private insurance or medicaid); 
gen cfedpriv=fedlaw*private*csec;
gen cfedmed=fedlaw*medicaid*csec;
gen cmedmed=med1397*medicaid*csec;
gen cstatepriv=statelaw*private*csec;
gen cstatemed=statelaw*medicaid*csec;

gen vfedpriv=fedlaw*private*(1-csec);
gen vfedmed=fedlaw*medicaid*(1-csec);
gen vmedmed=med1397*medicaid*(1-csec);
gen vstatepriv=statelaw*private*(1-csec);
gen vstatemed=statelaw*medicaid*(1-csec);


* destring the hospital id;
destring hospidm, replace;

compress;

* keep singletons and twins but delete triplets and higher;
destring typebth, replace;
drop if typebth>3;

* there are a bunch of different problems recorded at the;
* time of the birth or during pregnancy.  the list is in;
* the paper.  prob(j) equals 1 if the mother or child;
* presents with problem (j).  all problems is the sum and ;
* no problems equals 1 if all_problems sums ot zero;
gen all_problems=prob01+prob02+prob03+prob05+prob07
+prob09+prob11+prob14+prob15+prob16+prob18
+prob19+prob13+prob20+prob25+prob29+prob23
+prob32+prob38+prob39+prob30+prob40+prob41+prob43+prob44
+prob45+prob46+prob47+prob48;

gen no_problems=all_problems==0;

* generate dummies for mothers education;
destring meduc, replace;
gen lths=meduc<12;
gen hsgrad=meduc==12;
gen colgrad=(meduc>=16 & meduc<99);
gen educmiss=meduc==99;


*****************************************************************************;
*****************************************************************************;
****************** keep only c-section deliveries *****************************;
*****************************************************************************;
*****************************************************************************;

drop if vag==1;


keep readmission28i hospidm bw1-bw3 gest gest2 fedlaw statelaw meduc
early ins_csec hsa trend deliverysize agegroup sex mrace_new 
hisphm birth_hour admdaym admmnthi hospital_owner previous_birth prob0* prob1*
prob2* prob3* prob4* vfedpriv vfedmed vmedmed cfedpriv cfedmed cmedmed
typebth;

xi i.ins_csec*trend i.ins_csec i.hsa i.deliverysize i.agegroup i.sex i.typebth
i.mrace_new i.hisphm i.meduc i.birth_hour i.admdaym i.admmnthi i.hospital_owner i.previous_birth;
gen morebefore=early;

replace morebefore=. if (fedlaw==1|statelaw==1);


gen all_problems=prob01+prob02+prob03+prob05+prob07
+prob09+prob11+prob14+prob15+prob16+prob18
+prob19+prob13+prob20+prob25+prob29+prob23
+prob32+prob38+prob39+prob30+prob40+prob41+prob43+prob44
+prob45+prob46+prob47+prob48;

destring admmnthi, replace;
drop if admmnthi==.;


********************************************************************;
********************************************************************;
*run the propensity score more but -- only c-sections;
********************************************************************;
********************************************************************;

probit morebefore _Iins_csec* _Ihsa* _Ideliv* _Iagegroup* _Isex* _Itype*
_Imrace* _Ihisphm* _Imed* _Ibirth_h* _Iadm* _Ihospi* _Iprev* 
bw1-bw2 gest1-gest2 prob0* prob1* prob2* prob3* prob4*;
predict propscore;

xtile halves=propscore, nq(2);
xtile thirds=propscore, nq(3);
xtile fourths=propscore, nq(4);


local xvars "_I* bw1-bw2 gest1-gets2 prob0* prob1* prob2* prob3* prob4* trend";
local ivars "vfedpriv vfedmed vmedmed cfedpriv cfedmed cmedmed";

********************************************************************;
********************************************************************;
*basic model;
* these are the basic OLS, 1st stage, and 2sls results for the;
* births that were delivered by c-section;
* these results are inrow 2 of table 3;
********************************************************************;
********************************************************************;
sum readmission28i early if fedlaw==0;
reg readmission28i `xvars' early if fedlaw==0;
ivreg2 readmission28i `xvars' (early=`ivars'), first;
ivreg readmission28i `xvars' (early=`ivars'), cluster(hospidm);

* next, we run the same set of models for thirds of the;
* propensity score;


********************************************************************;
********************************************************************;
*basic model, thirds=1;
* row 4 of table 5;
********************************************************************;
********************************************************************;
sum readmission28i early if fedlaw==0&(thirds==1);
reg readmission28i `xvars' early if fedlaw==0&(thirds==1);
ivreg2 readmission28i `xvars' (early=`ivars') if (thirds==1), first;
ivreg readmission28i `xvars' (early=`ivars') if (thirds==1), cluster(hospidm);





********************************************************************;
********************************************************************;
*basic model, thirds=2;
* row 5 of table 5;
********************************************************************;
********************************************************************;
sum readmission28i early if fedlaw==0&(thirds==1);
reg readmission28i `xvars' early if fedlaw==0&(thirds==1);
ivreg2 readmission28i `xvars' (early=`ivars') if (thirds==2), first;
ivreg readmission28i `xvars' (early=`ivars') if (thirds==2), cluster(hospidm);






********************************************************************;
********************************************************************;
*basic model, thirds=3;
* row 6 of table 5;
********************************************************************;
********************************************************************;
sum readmission28i early if fedlaw==0&(thirds==1);
reg readmission28i `xvars' early if fedlaw==0&(thirds==1);
ivreg2 readmission28i `xvars' (early=`ivars') if (thirds==3), first;
ivreg readmission28i `xvars' (early=`ivars') if (thirds==3), cluster(hospidm);
log close;

