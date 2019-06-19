 /***********************************
* MNL.do          *
***********************************/
/* MNP or MNL on school enrollment vs college */
use $data\edex_data_analytic, clear

#delimit;
capture gen catY = 0; replace catY = 1 if f3attainment>=3 & f3attainment<=5 ;replace catY = 2 if Y==1;



eststo clear;
qui eststo A: mlogit catY T1 if sample, cluster(sch_id) base(0);
estadd local tc "No"; estadd local ss "No"; estadd local gpa "No"; 
estadd local sfe "No"; estadd local tfe "No"; estadd scalar nst = round(e(N),10);
foreach o in 0 1 2 {;
qui margins, dydx(*) predict(outcome(`o')) post;
eststo A`o', title(Outcome `o');
estadd local tc "No"; estadd local ss "No"; estadd local gpa "No"; 
estadd local sfe "No"; estadd local tfe "No"; estadd scalar nst = round(e(N),10);
estimates restore A;
};
qui eststo B: mlogit catY T2 if sample , cluster(sch_id) base(0);
estadd local tc "No"; estadd local ss "No"; estadd local gpa "No"; 
estadd local sfe "No"; estadd local tfe "No"; estadd scalar nst = round(e(N),10);
foreach o in 0 1 2 {;
qui margins, dydx(*) predict(outcome(`o')) post;
eststo B`o', title(Outcome `o');
estadd local tc "No"; estadd local ss "No"; estadd local gpa "No"; 
estadd local sfe "No"; estadd local tfe "No"; estadd scalar nst = round(e(N),10);
estimates restore B;
};
qui eststo C: mlogit catY T1 T2 if sample, cluster(sch_id) base(0);
estadd local tc "No"; estadd local ss "No"; estadd local gpa "No"; 
estadd local sfe "No"; estadd local tfe "No"; estadd scalar nst = round(e(N),10);
foreach o in 0 1 2 {;
qui margins, dydx(*) predict(outcome(`o')) post;
eststo C`o', title(Outcome `o');
estadd local tc "No"; estadd local ss "No"; estadd local gpa "No"; 
estadd local sfe "No"; estadd local tfe "No"; estadd scalar nst = round(e(N),10);
estimates restore C;
};
qui eststo D: mlogit catY T1 T2 $spec1 if sample, cluster(sch_id) base(0);
estadd local tc "Yes"; estadd local ss "No"; estadd local gpa "No"; 
estadd local sfe "No"; estadd local tfe "No"; estadd scalar nst = round(e(N),10);
foreach o in 0 1 2 {;
qui margins, dydx(*) predict(outcome(`o')) post;
estadd local tc "Yes"; estadd local ss "No"; estadd local gpa "No"; 
estadd local sfe "No"; estadd local tfe "No"; estadd scalar nst = round(e(N),10);
eststo D`o', title(Outcome `o');
estimates restore D;
};
qui eststo E: mlogit catY T1 T2 $spec2 if sample, base(0) cluster(sch_id);
estadd local tc "Yes"; estadd local ss "Yes"; estadd local gpa "No"; 
estadd local sfe "No"; estadd local tfe "No"; estadd scalar nst = round(e(N),10);
foreach o in 0 1 2 {;
qui margins, dydx(*) predict(outcome(`o')) post;
estadd local tc "Yes"; estadd local ss "Yes"; estadd local gpa "No"; 
estadd local sfe "No"; estadd local tfe "No"; estadd scalar nst = round(e(N),10);
eststo E`o', title(Outcome `o');
estimates restore E;
};
qui eststo F: mlogit catY T1 T2 $spec3 if sample, base(0) cluster(sch_id);
estadd local tc "Yes"; estadd local ss "Yes"; estadd local gpa "Yes"; 
estadd local sfe "No"; estadd local tfe "No"; estadd scalar nst = round(e(N),10);
foreach o in 0 1 2 {;
qui margins, dydx(*) predict(outcome(`o')) post;
estadd local tc "Yes"; estadd local ss "Yes"; estadd local gpa "Yes"; 
estadd local sfe "No"; estadd local tfe "No"; estadd scalar nst = round(e(N),10);
eststo F`o', title(Outcome `o');
estimates restore F;
};
qui eststo G: mlogit catY T1 T2 $spec3 if cbyrace6==1 & sample, base(0) cluster(sch_id);
estadd local tc "Yes"; estadd local ss "Yes"; estadd local gpa "Yes"; 
estadd local sfe "No"; estadd local tfe "No"; estadd scalar nst = round(e(N),10);
foreach o in 0 1 2 {;
qui margins, dydx(*) predict(outcome(`o')) post;
estadd local tc "Yes"; estadd local ss "Yes"; estadd local gpa "Yes"; 
estadd local sfe "No"; estadd local tfe "No"; estadd scalar nst = round(e(N),10);
eststo G`o', title(Outcome `o');
estimates restore G;
};
qui eststo H: mlogit catY T1 T2 $spec3 if cbyrace3==1 & sample, base(0) cluster(sch_id);
estadd local tc "Yes"; estadd local ss "Yes"; estadd local gpa "Yes"; 
estadd local sfe "No"; estadd local tfe "No"; estadd scalar nst = round(e(N),10);
foreach o in 0 1 2 {;
qui margins, dydx(*) predict(outcome(`o')) post;
estadd local tc "Yes"; estadd local ss "Yes"; estadd local gpa "Yes"; 
estadd local sfe "No"; estadd local tfe "No"; estadd scalar nst = round(e(N),10);
eststo H`o', title(Outcome `o');
estimates restore H;
};

esttab A B C D E F G H , label collabels(none) nomtitles mgroups("All Students" "White" "Black", pattern(1 0 0 0 0 0 1 1) prefix(\multicolumn{@span}{c}{) suffix(}) span) keep(T1 T2) cells(b(fmt(2) star) se(fmt(2) par)) starlevels(* 0.10 ** 0.05 *** 0.01) noobs stats(tc ss gpa sfe tfe nst r2 r2_a, fmt(0 0 0 0 0 0 2 2) labels("Teacher Controls" "Student SES" "9th Grade GPA" "School FE" "Teacher Dyad FE" "Observations" " $ R^2 $ " "Adjusted $ R^2 $")) title("Probit, no college as base" \label{table3});
foreach o in 0 1 2 {;
esttab A`o' B`o' C`o' D`o' E`o' F`o' G`o' H`o' , a label collabels(none) nomtitles mgroups("All Students" "White" "Black", pattern(1 0 0 0 0 0 1 1) prefix(\multicolumn{@span}{c}{) suffix(}) span) keep(T1 T2) cells(b(fmt(2) star) se(fmt(2) par)) starlevels(* 0.10 ** 0.05 *** 0.01) noobs stats(tc ss gpa sfe tfe nst r2 r2_a, fmt(0 0 0 0 0 0 2 2) labels("Teacher Controls" "Student SES" "9th Grade GPA" "School FE" "Teacher Dyad FE" "Observations" " $ R^2 $ " "Adjusted $ R^2 $")) title("Probit, no college as base" \label{table3});
};


esttab A B C D E F G H using $tables\table_s16.tex, replace label collabels(none) nomtitles mgroups("All Students" "White" "Black", pattern(1 0 0 0 0 0 1 1) prefix(\multicolumn{@span}{c}{) suffix(}) span) keep(T1 T2) cells(b(fmt(2) star) se(fmt(2) par)) starlevels(* 0.10 ** 0.05 *** 0.01) noobs stats(tc ss gpa sfe tfe nst r2 r2_a, fmt(0 0 0 0 0 0 2 2) labels("Teacher Controls" "Student SES" "9th Grade GPA" "School FE" "Teacher Dyad FE" "Observations" " $ R^2 $ " "Adjusted $ R^2 $")) title("Probit, no college as base" \label{tab:mnl});
foreach o in 0 1 2 {;
esttab A`o' B`o' C`o' D`o' E`o' F`o' G`o' H`o' using $tables\table_s16.tex, append label collabels(none) nomtitles mgroups("All Students" "White" "Black", pattern(1 0 0 0 0 0 1 1) prefix(\multicolumn{@span}{c}{) suffix(}) span) keep(T1 T2) cells(b(fmt(2) star) se(fmt(2) par)) starlevels(* 0.10 ** 0.05 *** 0.01) noobs stats(tc ss gpa sfe tfe nst r2 r2_a, fmt(0 0 0 0 0 0 2 2) labels("Teacher Controls" "Student SES" "9th Grade GPA" "School FE" "Teacher Dyad FE" "Observations" " $ R^2 $ " "Adjusted $ R^2 $")) title("Logit, Marginal Effects" \label{tab:marginal});
};

