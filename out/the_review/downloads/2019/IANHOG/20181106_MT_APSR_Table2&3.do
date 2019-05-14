#delimit;
cap cd "C:\Users\ejm5\Dropbox\PartipationCompliance\AER-QJE-The Moon\Replication";
use "Data\20181106_RCT_Clean.dta", clear;
set more off;

/*Round 3*/
#delimit;
keep treatment1 treatment2 firm_code r1_emp c3 c3a  c3b female hanoi fe_provcatsector enumerator  r1_catsector access r2_response gov_understands group;
generate round3=1;
save round3_legit.dta, replace;

/*Round 1*/
use "Data\20181106_RCT_Clean.dta", clear;
keep firm_code treatment1 treatment2 firm_code r1_emp c3 c3a c3b female hanoi fe_provcatsector enumerator  r1_catsector access r2_response gov_understands_bl* group;
generate round3=0;
rename gov_understands_bl gov_understands;
save round1_legit.dta, replace;
append using round3_legit.dta;
tab gov_understands round3;

/*********************************************************************/
/*Table 2 with Oprobit*/
#delimit;
set more off;
oprobit gov_understands  i.treatment2##i.round3, cluster(fe_provcatsector);
outreg2 using "Tables\Table2", tdec(3) bdec(3) e(all) replace;
oprobit gov_understands  i.treatment2##i.round3 female hanoi, cluster(fe_provcatsector);
outreg2 using"Tables\Table2", tdec(3) bdec(3) e(all);
xi: oprobit gov_understands  treatment2##round3 female hanoi i.r1_emp i.r1_catsector, cluster(fe_provcatsector);
outreg2 using "Tables\Table2", tdec(3) bdec(3) e(all);
xi: oprobit gov_understands treatment2##round3 female hanoi i.r1_emp i.r1_catsector if access==1, cluster(fe_provcatsector);
outreg2 using "Tables\Table2", tdec(3) bdec(3) e(all);
xi: oprobit gov_understands treatment1##round3 treatment2##round3 female hanoi i.r1_emp i.r1_catsector, cluster(fe_provcatsector);
outreg2 using "Tables\Table2", tdec(3) bdec(3) e(all);
xi: oprobit gov_understands treatment1##round3 treatment2##round3 female hanoi i.r1_emp i.r1_catsector if access==1, cluster(fe_provcatsector);
outreg2 using "Tables\Table2", tdec(3) bdec(3) e(all) excel;

/*********************************************************************/
/*Table 3 Predicted Probabilities*/

#delimit;
xi: oprobit gov_understands  treatment2##round3 female hanoi i.r1_emp i.r1_catsector, cluster(fe_provcatsector);
margins treatment2, predict(outcome(3)) at(round3=(0(1)1));
margins treatment2, predict(outcome(4)) at(round3=(0(1)1));
margins ,dydx(round3) predict(outcome(4)) at(treatment2=(0(1)1));


/*********************************************************************/
/*Appendix I1: Table 2 with OLS*/
#delimit;
set more off;
reg gov_understands  i.treatment2##i.round3, cluster(fe_provcatsector);
outreg2 using "Tables\TableI1", tdec(3) bdec(3) e(all) replace;
reg gov_understands  i.treatment2##i.round3 female hanoi, cluster(fe_provcatsector);
outreg2 using "Tables\TableI1", tdec(3) bdec(3) e(all);
areg gov_understands  i.treatment2##i.round3 female hanoi i.r1_emp, cluster(fe_provcatsector) absorb(r1_catsector);
outreg2 using "Tables\TableI1", tdec(3) bdec(3) e(all);
areg gov_understands i.treatment2##i.round3 female hanoi i.r1_emp if access==1, cluster(fe_provcatsector) absorb(r1_catsector);
outreg2 using "Tables\TableI1", tdec(3) bdec(3) e(all);
areg gov_understands i.treatment1##i.round3 i.treatment2##i.round3 female hanoi i.r1_emp, cluster(fe_provcatsector) absorb(r1_catsector);
outreg2 using "Tables\TableI1", tdec(3) bdec(3) e(all);
areg gov_understands i.treatment1##i.round3 i.treatment2##i.round3 female hanoi i.r1_emp if access==1, cluster(fe_provcatsector) absorb(r1_catsector);
outreg2 using "Tables\TableI1", tdec(3) bdec(3) e(all) excel;



/*********************************************************************/
/*Appendix I2: Table 2 with Original Treatment Conditions*/

#delimit;
set more off;
xi: reg gov_understands group##i.round3 female hanoi i.r1_emp i.r1_catsector, cluster(fe_provcatsector);
outreg2 using "Tables\TableI2", tdec(3) bdec(3) e(all) replace;
xi: reg gov_understands group##i.round3 female hanoi i.r1_emp i.r1_catsector if access==1, cluster(fe_provcatsector);
outreg2 using "Tables\TableI2", tdec(3) bdec(3) e(all);

#delimit;
set more off;
xi: oprobit gov_understands group##i.round3  female hanoi i.r1_emp i.r1_catsector, cluster(fe_provcatsector);
outreg2 using "Tables\TableI2", tdec(3) bdec(3) e(all);
xi: oprobit gov_understands group##i.round3  female hanoi i.r1_emp i.r1_catsector if access==1, cluster(fe_provcatsector);
outreg2 using "Tables\TableI2", tdec(3) bdec(3) e(all) excel;



/*********************************************************************/
/*Appendix I4: Table 2 Dropping Substantive Comments*/

#delimit;
set more off;
oprobit gov_understands  i.treatment2##i.round3 if r2_response==0, cluster(fe_provcatsector);
outreg2 using "Tables\TableI4", tdec(3) bdec(3) e(all) replace;
oprobit gov_understands  i.treatment2##i.round3 female hanoi if r2_response==0, cluster(fe_provcatsector);
outreg2 using"Tables\TableI4", tdec(3) bdec(3) e(all);
xi: oprobit gov_understands  treatment2##round3 female hanoi i.r1_emp i.r1_catsector if r2_response==0, cluster(fe_provcatsector);
outreg2 using "Tables\TableI4", tdec(3) bdec(3) e(all);
xi: oprobit gov_understands treatment2##round3 female hanoi i.r1_emp i.r1_catsector if access==1 & r2_response==0, cluster(fe_provcatsector);
outreg2 using "Tables\TableI4", tdec(3) bdec(3) e(all);
xi: oprobit gov_understands treatment1##round3 treatment2##round3 female hanoi i.r1_emp i.r1_catsector if r2_response==0, cluster(fe_provcatsector);
outreg2 using "Tables\TableI4", tdec(3) bdec(3) e(all);
xi: oprobit gov_understands treatment1##round3 treatment2##round3 female hanoi i.r1_emp i.r1_catsector if access==1 & r2_response==0, cluster(fe_provcatsector);
outreg2 using "Tables\TableI4", tdec(3) bdec(3) e(all) excel;


