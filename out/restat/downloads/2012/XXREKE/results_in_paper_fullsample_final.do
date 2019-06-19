# delimit;
set more off;

* this program generates the vast majority of the results;
* in Evans/Garthwaite, "Estimating heterogeneity in the benefits;
* of medical treatment intensity," Review of Economics and Statistics;
* 2012, 94(3), 635-649;

* there are three stata programs.  This one produces any result;
* in the paper that uses the full sample, which is most of the results;
* in the paper.  There are two very simlar programs that;
* produce estimates using only c-section and vaginal births;
* these programs produce estimates for the subsamples in tables 3 and5;


set mem 1000m;
set matsize 800;

log using results_in_paper_fullsample_final.log, replace;
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

********************************************************************;
********************************************************************;
************ means for table 1 *************************************;
********************************************************************;
********************************************************************;

sum early readmission28i medicaid csec bw1 all_problems lths hsgrad colgrad educmiss if fedlaw==0;
sum early readmission28i medicaid csec bw1 all_problems lths hsgrad colgrad educmiss if fedlaw==1;

tab mrace_new fedlaw, row column;
tab agegroup fedlaw, row column;

* we need to reduce the size of the data set to free up some space so;
* we keep only those variables used in the analysis;
keep readmission28i hospidm bw1-bw2 gest1-gest2 fedlaw statelaw meduc
early ins_csec hsa trend deliverysize agegroup sex mrace_new 
hisphm birth_hour admdaym admmnthi hospital_owner previous_birth prob0* prob1*
prob2* prob3* prob4* vfedpriv vfedmed vmedmed cfedpriv cfedmed cmedmed
typebth all_problems;

* generate fixed effects for the insurance/type interaction, separate trends;
* for these variables, hsa, tye size of the hospital, the age group of the mom, the;
* set of the child, the type of birth (twin or singleton), the race of the mom;
* whether the mom is hispanic, moms educatio, the birth hour, the birth day (sunday, monday, etc.);
* the month, whether the hospital is profit or non profit, and indicators for the number of;
* previous births;
xi i.ins_csec*trend i.ins_csec i.hsa i.deliverysize i.agegroup i.sex i.typebth
i.mrace_new i.hisphm i.meduc i.birth_hour i.admdaym i.admmnthi i.hospital_owner i.previous_birth;


* ok here is a stata trick -- if y is missing and you ask for a ;
* predicted value, stata will produce a predicted value for all;
* observations with a valid set of x.  we only want to run the;
* propensity score more on births prior to august if 1996 which is;
* the period before any state or federal law.  therefore, we take the;
* early indicator, define a new aroiable and set it equal to missing;
* after the state law is introduced.  this will allow us to produce;
* a propensity score for the after law period based on only pre-law;
* betas;
this is the sample;
* that will be used for the propensity score estimation;
gen morebefore=early;
replace morebefore=. if (fedlaw==1|statelaw==1);

destring admmnthi, replace;
drop if admmnthi==.;


********************************************************************;
********************************************************************;
*get the propensity score of released early based on pre-law data;
********************************************************************;
********************************************************************;

probit morebefore _Iins_csec* _Ihsa* _Ideliv* _Iagegroup* _Isex* _Itype*
_Imrace* _Ihisphm* _Imed* _Ibirth_h* _Iadm* _Ihospi* _Iprev* 
bw1-bw2 gest1-gest2 prob0* prob1* prob2* prob3* prob4*;
predict propscore;
xtile thirds=propscore, nq(3);
xtile fourths=propscore, nq(4);


local xvars "_I* bw1-bw2 gest1-gest2 prob0* prob1* prob2* prob3* prob4* trend";
local ivars "vfedpriv vfedmed vmedmed cfedpriv cfedmed cmedmed";

********************************************************************;
********************************************************************;
* here we produce the basic results for table 2;
* we produce OLS without covariates, OLS with covariates;
* and the 2SLS estimates using the 6 instruments;
* as a note -- we run the IV estimates twice.  IVREG does not do;
* the tets of over identifying restrictions but it clusteres.  IVREG2;
* gives the test of over identifying restrictions but it does not;
* cluster;
* the results below are also the results in the 1st row of table 3;
* and the 1st row of table 4;
********************************************************************;
********************************************************************;
sum readmission28i early if fedlaw==0;
reg readmission28i `xvars' early if fedlaw==0;
ivreg2 readmission28i `xvars' (early=`ivars'), first;
ivreg readmission28i `xvars' (early=`ivars'), cluster(hospidm);




********************************************************************;
********************************************************************;
*basic model, zero problems;
* fouth row of table 3;
********************************************************************;
********************************************************************;
sum readmission28i early if fedlaw==0&all_problems==0;
reg readmission28i `xvars' early if fedlaw==0&all_problems==0;
ivreg2 readmission28i `xvars' (early=`ivars') if all_problems==0, first;
ivreg readmission28i `xvars' (early=`ivars') if all_problems==0, cluster(hospidm);




********************************************************************;
********************************************************************;
*basic model, 1+ problems;
* fifth row of table 3;
********************************************************************;
********************************************************************;
sum readmission28i early if fedlaw==0&all_problems>0;
reg readmission28i `xvars' early if fedlaw==0&all_problems>0;
ivreg2 readmission28i `xvars' (early=`ivars') if all_problems>0, first;
ivreg readmission28i `xvars' (early=`ivars') if all_problems>0, cluster(hospidm);




********************************************************************;
********************************************************************;
*basic model, 2+ problems;
* sixth row of table 3;
********************************************************************;
********************************************************************;
sum readmission28i early if fedlaw==0&all_problems>1;
reg readmission28i `xvars' early if fedlaw==0&all_problems>1;
ivreg2 readmission28i `xvars' (early=`ivars') if all_problems>1, first;
ivreg readmission28i `xvars' (early=`ivars') if all_problems>1, cluster(hospidm);



********************************************************************;
********************************************************************;
*basic model, 3+ problems;
* seventh row of table 3;
********************************************************************;
********************************************************************;
sum readmission28i early if fedlaw==0&all_problems>2;
reg readmission28i `xvars' early if fedlaw==0&all_problems>2;
ivreg2 readmission28i `xvars' (early=`ivars') if all_problems>2, first;
ivreg readmission28i `xvars' (early=`ivars') if all_problems>2, cluster(hospidm);





gen preeclamp=prob01==1 | prob02==1;
********************************************************************;
********************************************************************;
*basic model, preclampsia or eclampsia;
* 4th row of table 4;
********************************************************************;
********************************************************************;
sum readmission28i early if fedlaw==0&preeclamp==1;
reg readmission28i `xvars' early if fedlaw==0&preeclamp==1;
ivreg2 readmission28i `xvars' (early=`ivars') if preeclamp==1, first;
ivreg readmission28i `xvars' (early=`ivars') if preeclamp==1, cluster(hospidm);





********************************************************************;
********************************************************************;
*basic model, diabetes;
* 5th row of table 4;
********************************************************************;
********************************************************************;
sum readmission28i early if fedlaw==0&prob09==1;
reg readmission28i `xvars' early if fedlaw==0&prob09==1;
ivreg2 readmission28i `xvars' (early=`ivars') if prob09==1, first;
ivreg readmission28i `xvars' (early=`ivars') if prob09==1, cluster(hospidm);



********************************************************************;
********************************************************************;
*basic model, meconium;
* 2nd row of table 4;
********************************************************************;
********************************************************************;
sum readmission28i early if fedlaw==0&prob45==1;
reg readmission28i `xvars' early if fedlaw==0&prob45==1;
ivreg2 readmission28i `xvars' (early=`ivars') if prob45==1, first;
ivreg readmission28i `xvars' (early=`ivars') if prob45==1, cluster(hospidm);




********************************************************************;
********************************************************************;
*basic model, fetal distress;
* 3rd row of table 4;
********************************************************************;
********************************************************************;
sum readmission28i early if fedlaw==0&prob47==1;
reg readmission28i `xvars' early if fedlaw==0&prob47==1;
ivreg2 readmission28i `xvars' (early=`ivars') if prob47==1, first;
ivreg readmission28i `xvars' (early=`ivars') if prob47==1, cluster(hospidm);




********************************************************************;
********************************************************************;
*basic model, other dysfunctiona;
* 6th row of table 4;
********************************************************************;
********************************************************************;
sum readmission28i early if fedlaw==0&prob37==1;
reg readmission28i `xvars' early if fedlaw==0&prob37==1;
ivreg2 readmission28i `xvars' (early=`ivars') if prob37==1, first;
ivreg readmission28i `xvars' (early=`ivars') if prob37==1, cluster(hospidm);




********************************************************************;
********************************************************************;
*basic model, < 5lbs;
* 7th row of table 4;
********************************************************************;
********************************************************************;
sum readmission28i early if fedlaw==0&bw1<80;
reg readmission28i `xvars' early if fedlaw==0&bw1<80;
ivreg2 readmission28i `xvars' (early=`ivars') if bw1<80, first;
ivreg readmission28i `xvars' (early=`ivars') if bw1<80, cluster(hospidm);




********************************************************************;
********************************************************************;
*basic model, >= 5lbs, <7 lbs;
* 8th row of table 4;
********************************************************************;
********************************************************************;
sum readmission28i early if fedlaw==0&(bw1>=80);
reg readmission28i `xvars' early if fedlaw==0&(bw1>=80);
ivreg2 readmission28i `xvars' (early=`ivars') if (bw1>=80), first;
ivreg readmission28i `xvars' (early=`ivars') if (bw1>=80), cluster(hospidm);





********************************************************************;
********************************************************************;
*basic model, thirds=1;
* 1st row of table 5;
********************************************************************;
********************************************************************;
sum readmission28i early if fedlaw==0&(thirds==1);
reg readmission28i `xvars' early if fedlaw==0&(thirds==1);
ivreg2 readmission28i `xvars' (early=`ivars') if (thirds==1), first;
ivreg readmission28i `xvars' (early=`ivars') if (thirds==1), cluster(hospidm);





********************************************************************;
********************************************************************;
*basic model, thirds=2;
* 2nd row of table 5;
********************************************************************;
********************************************************************;
sum readmission28i early if fedlaw==0&(thirds==1);
reg readmission28i `xvars' early if fedlaw==0&(thirds==1);
ivreg2 readmission28i `xvars' (early=`ivars') if (thirds==2), first;
ivreg readmission28i `xvars' (early=`ivars') if (thirds==2), cluster(hospidm);






********************************************************************;
********************************************************************;
*basic model, thirds=3;
* 3rd row of table 3;
********************************************************************;
********************************************************************;
sum readmission28i early if fedlaw==0&(thirds==1);
reg readmission28i `xvars' early if fedlaw==0&(thirds==1);
ivreg2 readmission28i `xvars' (early=`ivars') if (thirds==3), first;
ivreg readmission28i `xvars' (early=`ivars') if (thirds==3), cluster(hospidm);




log close;

















