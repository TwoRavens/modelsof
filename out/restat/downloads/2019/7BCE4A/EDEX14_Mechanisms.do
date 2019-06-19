use $data\edex_data_analytic, clear

#delimit;

capture gen mathhwkinschool = bys35a if bys35a>=0;
capture gen mathhwkoutschool = bys35b if bys35b>=0;
capture gen elahwkinschool = bys36a if bys36a>=0;
capture gen elahwkoutschool = bys36b if bys36b>=0;

capture gen totmathhwk = mathhwkinschool+mathhwkoutschool;
capture gen totelahwk = elahwkinschool+elahwkoutschool;
 
capture gen mathhwkinschool12 = f1s32a if f1s32a>=0;
capture gen mathhwkoutschool12 = f1s32b if f1s32b>=0;

capture gen tothwk12 = f1s31 if f1s31>=0;
capture gen tothwk = byhmwrk if byhmwrk>=0; 
replace tothwk = . if tothwk>90;


replace tothwk12 = 0 if f1s31==1;
replace tothwk12 = 0.5 if f1s31==2;
replace tothwk12 = 2 if f1s31==3;
replace tothwk12 = 5 if f1s31==4;
replace tothwk12 = 8 if f1s31==5;
replace tothwk12 = 11 if f1s31==6;
replace tothwk12 = 14 if f1s31==7;
replace tothwk12 = 17.5 if f1s31==8;
replace tothwk12 = 21 if f1s31==9;

capture gen tothwkc = tothwk;
replace tothwkc = 21 if tothwk>=20 & tothwk~=.;


replace mathhwkinschool12 = 0 if f1s32a==1;
replace mathhwkinschool12 = 0.5 if f1s32a==2;
replace mathhwkinschool12 = 2 if f1s32a==3;
replace mathhwkinschool12 = 5 if f1s32a==4;
replace mathhwkinschool12 = 8 if f1s32a==5;
replace mathhwkinschool12 = 11 if f1s32a==6;
replace mathhwkinschool12 = 14 if f1s32a==7;
replace mathhwkinschool12 = 17.5 if f1s32a==8;
replace mathhwkinschool12 = 21 if f1s32a==9;
replace mathhwkoutschool12 = 0 if f1s32b==1;
replace mathhwkoutschool12 = 0.5 if f1s32b==2;
replace mathhwkoutschool12 = 2 if f1s32b==3;
replace mathhwkoutschool12 = 5 if f1s32b==4;
replace mathhwkoutschool12 = 8 if f1s32b==5;
replace mathhwkoutschool12 = 11 if f1s32b==6;
replace mathhwkoutschool12 = 14 if f1s32b==7;
replace mathhwkoutschool12 = 17.5 if f1s32b==8;
replace mathhwkoutschool12 = 21 if f1s32b==9;
capture gen totmathhwk12 = mathhwkinschool12+mathhwkoutschool12;



capture gen gpa12 = f1rgp12 if f1rgp12>=0;
capture gen f1exp1 = f1stexp>=6 if f1stexp>=0;
capture gen b1exp1 = bystexp>=5 if bystexp>=0;
capture gen gpa10 = f1rgp10 if f1rgp10>=0;

eststo clear;

qui reghdfe f1exp1  T1 T2 b1exp1 $spec3 if sample, a(sch_id) cluster(sch_id);
capture gen samplem2 = e(sample);

qui reghdfe gpa12  T1 T2 f1rgp9 $spec2 if sample, a(sch_id) cluster(sch_id);
capture gen samplem4 = e(sample);

qui reghdfe tothwk12  T1 T2 tothwk $spec3 if sample, a(sch_id) cluster(sch_id);
capture gen samplem6 = e(sample);


eststo clear;



qui eststo: reghdfe gpa12  T1 T2 $spec3 if samplem4, a(sch_id) cluster(sch_id);
qui eststo: reghdfe gpa12  T1 T2 gpa10 $spec3 if samplem4, a(sch_id) cluster(sch_id);

qui eststo: reghdfe tothwk12 T1 T2 $spec3 if samplem6, a(sch_id) cluster(sch_id);
qui eststo: reghdfe tothwk12  T1 T2 tothwkc $spec3 if samplem6, a(sch_id) cluster(sch_id);

qui eststo: reghdfe f1exp1  T1 T2 $spec3 if samplem2, a(sch_id) cluster(sch_id);
qui eststo: reghdfe f1exp1  T1 T2 b1exp1 $spec3 if samplem2, a(sch_id) cluster(sch_id);

esttab;

esttab using $tables\table_s18.tex, append label nomtitles mgroups("Exp." "GPA" "Hwk", pattern(1 0 1 0 1 0))
cells(b(fmt(2) star) se(fmt(2) par)) keep(T1 T2) 
starlevels(* 0.10 ** 0.05 *** 0.01) title("Mechanisms" \label{tab:mech});

sum f1exp1 b1exp1 if samplem2;
sum gpa12 f1rgp9 if samplem4;
sum tothwk12 tothwk tothwkc if samplem6;






