


cap cd "C:\Users\ejm5\Dropbox\PartipationCompliance\AER-QJE-The Moon\Replication"

#delimit;
import excel "Data\data_output_code_ANON.xls", sheet("Sheet1") firstrow clear;
set more off;

#delimit;
foreach x in
province_code district_code province district  sector isic_rev4_4digitcode lg_form f_capital group 
director_CEO_gender director_CEO_position respondent respondent_position c1 c2 c2k c3 c4 c5a1 c5a2 c5ak1 
c5ak2 c5b1 c5b2 c5bk1 c5bk2 c6_1 c6_2 c6_3 c6_4 c6_5 c6_6 c6_7 c6_8 c6_9 c7 c8 c9 c9a c10a c10b c10c c11 c12a c12b c12c c13 
c14 c15a c15b c15c c16_1 c16_2 c16_3 c16_4 c16_5 c16_6 c17_1 c17_2 c17_3 c17_4 c17_5 c17_6 c17_7 c17_8 c17_9 c17_10 c17k c18 
c19 c20 c21 c22 c23 c24 c25 c26 c27 c27k c28 c28k c29 c30 c31_1 c31_2 c31_3 c31_4 c31k c32_1 c32_2 c32_3 c32_4 c32k c33 c34 c35 
c36 c37 cm1a cm1b cm1c cm1k cm2a cm2b cm2c cm2k cm3a cm3b cm3c cm3k cm4a cm4b cm4c cm4k cm5a cm5b cm5c cm5k cm6a cm6b cm6c cm6k 
cm7a cm7b cm7c cm7k cm8a cm8b cm8c cm8k cm9a cm9b cm9c cm9k cm10a cm10b cm10c cm10k cm11a cm11b cm11c cm11k cm12 z1 z1k z2 z2k z3 
z3k z4 z4k z5 z6 z6a z6b z7 SubmissionDate start end today text_audit audio_audit 
 meta_instanceID KEY   regis_product new_product {;

rename `x' r1_`x';
};

sort firm_code;
save Round1_data_ANON.dta, replace;


#delimit;
use "Data\Round3_data_ANON", clear;
merge 1:1 firm_code using Round1_data_ANON;
rename _merge _ROUND1;
save "Data\20181106_RCT.dta", replace;

#delimit;
clear all;
import excel using "Data\Round2.xlsx", sheet("value- T2 comment only") firstrow;

#delimit;
foreach x in
P1 cmk1 Re1 P2 cmk2 Re2 P3 cmk3 Re3 P4 cmk4 Re4 P5 cmk5 Re5 P6 cmk6 Re6 P7 cmk7 Re7 P8 cmk8 Re8 P9 cmk9 Re9 P10 cmk10 Re10 P11 cmk11 Re11{;
gen n_`x'=1 if `x' !="";
replace n_`x'=0 if `x' =="";
};

egen r2_no_comment=rowtotal(n_cmk*);
generate r2_comment=1 if r2_no_comment>0;
replace r2_comment=0 if r2_no_comment==0;
egen r2_no_response=rowtotal(n_Re*);
generate r2_response=1 if r2_no_response>0;
replace r2_response=0 if r2_no_response==0;
sort firm_code;
save "Data\Round2_data_ANON", replace;


#delimit;
use "Data\20181106_RCT.dta", clear;
merge 1:1 firm_code using "Data\Round2_data_ANON";
rename _merge _ROUND2;
replace r2_no_comment=0 if r2_no_comment==.;
replace r2_comment=0 if r2_comment==.;
replace r2_no_response=0 if r2_no_response==.;
replace r2_response=0 if r2_response==.;

#delimit;
merge 1:1 firm_code using "Data\Round2_data_Report.dta";
rename _merge _ROUND2_T1;
generate r2_report=0 if t1_round2==.;
replace r2_report=1 if r1_group==3;
replace r2_report=1 if t1_round2==1;



merge 1:1 firm_code using "Data\Round3_data_FieldReport.dta", force;



save "Data\20181106_RCT_Working.dta", replace;






