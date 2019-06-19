 /***********************************
* other_outcomes.do          *
***********************************/
u $data\edex_data_analytic, clear
#delimit;

eststo clear;

/* Full-Time Employment, F3 */;
replace Y = f3empstat==1 | f3empstat==2; 
sum Y;
qui eststo: reghdfe Y T1 T2 $spec3, a(sch_id) cluster(sch_id);
estadd local tc "Yes"; estadd local ss "Yes"; estadd local gpa "Yes"; 
estadd local sfe "Yes"; estadd local tfe "No"; estadd scalar nst = round(e(N),10);
test T1 T2;
estadd scalar fs = r(F);
estadd scalar ps = r(p);
/* At Least Some Employment, F3 */;
replace Y = f3empstat>=1 & f3empstat<=5; 
sum Y;
qui eststo: reghdfe Y T1 T2 $spec3, a(sch_id) cluster(sch_id);
estadd local tc "Yes"; estadd local ss "Yes"; estadd local gpa "Yes"; 
estadd local sfe "Yes"; estadd local tfe "No"; estadd scalar nst = round(e(N),10);
test T1 T2;
estadd scalar fs = r(F);
estadd scalar ps = r(p);
/* Being Married, F3 */;
replace Y = f3marrstatus==1; 
sum Y;
qui eststo: reghdfe Y T1 T2 $spec3, a(sch_id) cluster(sch_id);
estadd local tc "Yes"; estadd local ss "Yes"; estadd local gpa "Yes"; 
estadd local sfe "Yes"; estadd local tfe "No"; estadd scalar nst = round(e(N),10);
test T1 T2;
estadd scalar fs = r(F);
estadd scalar ps = r(p);

/* Ever Married, F3 */;
replace Y = f3marrstatus==1 | (f3marrstatus>=4 & f3marrstatus<=9); 
sum Y;
qui eststo: reghdfe Y T1 T2 $spec3, a(sch_id) cluster(sch_id);
estadd local tc "Yes"; estadd local ss "Yes"; estadd local gpa "Yes"; 
estadd local sfe "Yes"; estadd local tfe "No"; estadd scalar nst = round(e(N),10);
test T1 T2;
estadd scalar fs = r(F);
estadd scalar ps = r(p);

/* Biological Children, F3 */;
capture drop Y;
gen Y = f3d06 if f3d06>=0; 
sum Y;
qui eststo: reghdfe Y T1 T2 $spec3, a(sch_id) cluster(sch_id);
estadd local tc "Yes"; estadd local ss "Yes"; estadd local gpa "Yes"; 
estadd local sfe "Yes"; estadd local tfe "No"; estadd scalar nst = round(e(N),10);
test T1 T2;
estadd scalar fs = r(F);
estadd scalar ps = r(p);
/* Public Assistance, F3 */;
capture drop Y;
gen Y = f3d24 if f3d24>=0; 
sum Y;
qui eststo: reghdfe Y T1 T2 $spec3, a(sch_id) cluster(sch_id);
estadd local tc "Yes"; estadd local ss "Yes"; estadd local gpa "Yes"; 
estadd local sfe "Yes"; estadd local tfe "No"; estadd scalar nst = round(e(N),10);
test T1 T2;
estadd scalar fs = r(F);
estadd scalar ps = r(p);
/* Own Home, F3 */;
capture drop Y;
gen Y= f3d30==1 if f3d30>=0; 
sum Y;
qui eststo: reghdfe Y T1 T2 $spec3, a(sch_id) cluster(sch_id);
estadd local tc "Yes"; estadd local ss "Yes"; estadd local gpa "Yes"; 
estadd local sfe "Yes"; estadd local tfe "No"; estadd scalar nst = round(e(N),10);
test T1 T2;
estadd scalar fs = r(F);
estadd scalar ps = r(p);

esttab using $tables\table_s17.tex, append label collabels(none) nomtitles mgroups("Enroll" "Drop-out" "Emp, Full" "Emp" "Married" "Ever Married" "Child" "Assis." "Own Home", pattern(1 1 1 1 1 1 1 1))  keep(T1 T2) cells(b(fmt(2) star) se(fmt(2) par)) starlevels(* 0.10 ** 0.05 *** 0.01) noobs stats(tc ss gpa sfe tfe nst r2 r2_a ps, fmt(0 0 0 0 0 0 2 2 2) labels("Teacher Controls" "Student SES" "9th Grade GPA" "School FE" "Teacher Dyad FE" "Observations" " $ R^2 $ " "Adjusted $ R^2 $" "Joint Significance")) title("Other Outcomes");

