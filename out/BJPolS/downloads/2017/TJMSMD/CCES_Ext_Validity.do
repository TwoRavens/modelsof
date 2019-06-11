#delimit;
*Validity of CCES Ideology Measures;
clear all;
set mem 800m;

use "Ext_Validity_House.dta", replace;

eststo: reg cfscore Voter_House_Ideol_Hat_ if Inc_For_Reg == 1, robust;
eststo: reg cfscore Voter_House_Ideol_Hat_ if ExpChall_For_Reg == 1, robust;
eststo: reg cfscore Voter_House_Ideol_Hat_ if InExpChall_For_Reg == 1, robust;

esttab using House_Accuracy_ExpLevel.tex, mlabels("Incumbents" "Exp. Chall" "Inexp. Chall") note("Heteroskedasticity robust standard errors") keep(Voter_House_Ideol_Hat_ _cons) label se star(+ 0.10 * 0.05 ** 0.01 *** 0.001)  r2 title(Ideology Estimate Accuracy Regression for House Candidates) replace ;
eststo clear;

reg cfscore Voter_House_Ideol_Hat_ if Inc_For_Reg == 1 & Democrat == 1, robust;
reg cfscore Voter_House_Ideol_Hat_ if ExpChall_For_Reg == 1 & Democrat == 1, robust;
reg cfscore Voter_House_Ideol_Hat_ if InExpChall_For_Reg == 1 & Democrat == 1, robust;

reg cfscore Voter_House_Ideol_Hat_ if Inc_For_Reg == 1 & Republican == 1, robust;
reg cfscore Voter_House_Ideol_Hat_ if ExpChall_For_Reg == 1 & Republican == 1, robust;
reg cfscore Voter_House_Ideol_Hat_ if InExpChall_For_Reg == 1 & Republican == 1, robust;

corr Voter_House_Ideol_Hat_ cfscore;
reg Voter_House_Ideol_Hat_ cfscore, robust;
scatter cfscore Voter_House_Ideol_Hat_, ytitle("Estimated Candidate Ideology (Bonica's CF Score)") xtitle("Mean CCES Respondent Candidate Ideology") graphregion(color(white)) bgcolor(white);
graph export cfscore_v_cces_house.eps, replace;


#delimit;
clear all;
use "Ext_Validity_Senate.dta", replace;

eststo: reg cfscore Voter_Sen_Ideol_Hat_ if Inc_For_Reg == 1, robust;
eststo: reg cfscore Voter_Sen_Ideol_Hat_ if ExpChall_For_Reg == 1, robust;

esttab using Sen_Accuracy_ExpLevel.tex, mlabels("Incumbents" "Chall") note("Heteroskedasticity robust standard errors") keep(Voter_Sen_Ideol_Hat_ _cons) label se star(+ 0.10 * 0.05 ** 0.01 *** 0.001)  r2 title(Ideology Estimate Accuracy Regression for Senate Candidates) replace ;
eststo clear;

reg cfscore Voter_Sen_Ideol_Hat_ if Inc_For_Reg == 1 & Republican == 1, robust;
reg cfscore Voter_Sen_Ideol_Hat_ if ExpChall_For_Reg == 1 & Republican == 1, robust;

reg cfscore Voter_Sen_Ideol_Hat_ if Inc_For_Reg == 1 & Democrat == 1, robust;
reg cfscore Voter_Sen_Ideol_Hat_ if ExpChall_For_Reg == 1 & Democrat == 1, robust;


corr Voter_Sen_Ideol_Hat_ cfscore;
reg Voter_Sen_Ideol_Hat_ cfscore, robust;
scatter cfscore Voter_Sen_Ideol_Hat_ , ytitle("Estimated Candidate Ideology (Bonica's CF Score)") xtitle("Mean CCES Respondent Candidate Ideology") graphregion(color(white)) bgcolor(white);
graph export cfscore_v_cces_senate.eps, replace;
