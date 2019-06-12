#delimit;
cd "C:\Users\ejm5\Dropbox\PartipationCompliance\AER-QJE-The Moon\Replication";
use "Data\20181106_RCT_Working.dta", clear;
set more off;


/**********************Recoding and New Variables****************/

#delimit;
codebook status;
label variable status "Field Status for Firm";
label values status status;
label define status 1 "Success" 2 "Pilot" 3 "Closed" 4 "Inactive" 5 "Not in Chemicals" 6 "Refused"; 
tab status;

/*Treatment 1*/
generate treatment1=1 if r1_group==2;
replace treatment1=1 if r1_group==3;
replace treatment1=0 if r1_group==1;

/*Treatment 2*/
#delimit;
generate treatment2=1 if r1_group==3;
replace treatment2=0 if r1_group!=3;

/*Heard of Law*/
#delimit;
generate aware=2-c0;

/*Understanding*/
#delimit;
generate understanding=6 if c0a==.;
replace understanding =7-c0a;
lab var understanding "Understanding of Draft Law (6=A Lot; 1=None)";


/*Quality*/
#delimit;
replace c0b=1 if c0b==-888 & group !=.;
generate female=1 if r1_director_CEO_gender==2;
replace female=0 if r1_director_CEO_gender==1;


/*Generate Hanoi Dummy*/
generate hanoi=1 if province_code==1;
replace hanoi=0 if province_code !=1;

/*Consolidating Size Scales*/
generate r1_emp=r1_c12a;
replace r1_emp=5 if r1_c12a>6 & r1_c12a<=8;


/*Knowledge of Law*/
gen knowledge=2-c0;
lab var knowledge "Knowledge of Draft Law=1";

/*Understanding of Law*/
drop understanding;
replace c0a=5 if c0a==.;
gen understanding =6-c0a;
lab var understanding "Understanding of Draft Law (5=A Lot; 1=None)";

/*Original Treatment Conditions*/
replace group=1 if treatment1==0 & treatment2==0;
replace group=2 if treatment1==1 & treatment2==0;
replace group=3 if treatment1==1 & treatment2==1;


/*Quality*/
#delimit;
replace c0b=1 if c0b==.|c0b<0;

/*Agreed to Interview*/
#delimit;
generate success=1 if status==1;
replace success=0 if status !=1;


/*Access to Factory Floor*/
#delimit;
generate access=1 if c7a==1;
replace access=0 if c7a !=1;

/*Province Categorized Sector Clusters*/
gen r1_catsector=r1_sector;
replace r1_catsector="other" if r1_catsector=="D" | r1_catsector=="J" | r1_catsector=="N" | r1_catsector=="S" | r1_catsector=="";

/*Generate Groups for Fixed Effects*/
egen fe_provcatsector=group(r1_province r1_catsector);


#delimit;
/*Generate CEO*/
generate ceo=2- r1_respondent;
encode r1_catsector, gen(cat_sector);
lab var ceo "Respondent is CEO or General Manager of Company=1";
sum ceo;

/*Generate New Groups*/
generate new_group=group;
replace new_group=4 if r2_comment==1;
#delimit;
label variable new_group "Treatment Conditions (Including Providing Comment)";
label values new_group;
label define new_group 1 "Placebo" 2 "T1" 3 "T2" 4 "Provided Comment"; 
cibar access, over1(new_group);

#delimit;
/*No Response*/
generate no_comment=1-r2_response;
lab var no_comment "Firm DID NOT provide substantive comments on regulation=1";

/*Legitimacy*/
#delimit;
replace c79 =. if c79<0;
sum c79;
label variable c79 "R3: Officials Use Regulations to Extract Rents";




/*Sector Codes*/
#delimit;
generate isic_dig1=regexs(1) if regexm(r1_isic_rev4_4digitcode, "([0-9])([0-9])([0-9])([0-9])");
generate isic_dig2=regexs(2) if regexm(r1_isic_rev4_4digitcode, "([0-9])([0-9])([0-9])([0-9])");
generate isic_dig3=regexs(3) if regexm(r1_isic_rev4_4digitcode, "([0-9])([0-9])([0-9])([0-9])");
generate isic_dig4=regexs(4) if regexm(r1_isic_rev4_4digitcode, "([0-9])([0-9])([0-9])([0-9])");
#delimit;
egen sect_plus = concat(r1_catsector isic_dig1 isic_dig2) if r1_catsector=="C";
replace sect_plus=r1_catsector if r1_catsector !="C";
rename sect_plus sector_plus;
lab var sector_plus "Broad Sector and 2-Digit Manufacturing";
tab sector_plus if r1_catsector=="C";

/*Legitimacy*/
#delimit;
generate gov_understands=5-c78;
replace gov_understands =. if gov_understands>4;
label variable gov_understands "R3: Government Officials Understand Needs of Business";
label values gov_understands gov_understands;
label define gov_understands 4 "Strongly Agree" 3 "Agree" 2 "Disagree" 1 "Strongly Disagree"; 

#delimit;
generate gov_understands_bl=5-r1_c20;
replace gov_understands_bl =. if gov_understands_bl>4;
label variable gov_understands_bl "R1: Government Officials Understand Needs of Business";
label values gov_understands_bl gov_understands;

#delimit;
generate quality=1 if c0b>=4;
replace quality=0 if c0b<4;
label variable quality "Regulators are High Quality";
label values quality agree;

/*Dichotomous Measure*/
#delimit;
generate gov_understands_dich=1 if c78==1|c78==2;
replace gov_understands_dich=0 if c78==3|c78==4;
label variable gov_understands_dich "Regulators Understand Business";
label values gov_understands_dich agree;

#delimit;
/*Regulations Used to Extract Rents*/
replace r1_c21 =. if r1_c21<0;
label variable r1_c21 "R1: Officials Use Regulations to Extract Rents";
label values r1_c21 legitimacy;
label define legitimacy 1 "Strongly Agree" 2 "Agree" 3 "Disagree" 4 "Strongly Disagree"; 

generate rents=1 if c79==1|c79==2;
replace rents=0 if c79==3|c79==4;
label variable rents "R3: Officials Use Regulations to Extract Rents";
label values rents agree;
label define agree 1 "Agree" 0 "Disagree"; 

/*Access to Factory Floor*/
label variable access "Access to Factory Floor";
label values access access2;
label define access2 0"No" 1"Yes"; 
generate access2=access*100;
lab var access2 "Firms Providing Access to Factory (%)";
label values access2 access3;
label define access3 0 "No" 100 "Yes"; 

/*District Codes*/
#delimit;
by district_code, sort: egen district_access=mean(access);

/*Compliant*/
label define compliant  0 "Non-Compliant" 1 "Compliant" .b "NA_Access" .a "NA_NoAccess"; 

#delimit; 
set more off;
foreach x in c14 c19 c28 c34 c38 c42 c48 c51 c54 c58 c62 c68 c73 c77{;
replace `x'=0 if access==0;
replace `x'=0 if `x'<3;
replace `x'=1 if `x'>=3 & `x'<=5 ;
replace `x'=. if `x'==.  & access==1;
generate ineligible_`x'=1 if `x'==. & access==1;
replace ineligible_`x'=0 if `x'!=. & access==1;
by sector_plus, sort: egen avg_ineligible_`x'=mean(ineligible_`x');
replace `x'=.b if avg_ineligible_`x'>.8;
label values `x' compliant;
tab `x', missing;
};
drop ineligible*;
drop avg_ineligible*;

#delimit;
egen subjective_mean=rowmean(c14 c19 c28 c34  c48 c51 c54 c58 c62 c68);
egen costly_compliance2=rowmean(c28 c34 c54 c58 c68);
egen easy_compliance2=rowmean(c14 c19 c51 c48 c62 );

#delimit;
replace r1_emp=r1_c12a;
replace r1_emp=5 if r1_c12a>6 & r1_c12a<=8;

replace r1_catsector=r1_sector;
replace r1_catsector="other" if r1_catsector=="D" | r1_catsector=="J" | r1_catsector=="N" | r1_catsector=="S" | r1_catsector=="";
drop fe_provcatsector;
egen fe_provcatsector=group(r1_province r1_catsector);

lab var c2 "Performance of Company in 2015";
replace c2=. if c2==-888;

label variable r1_c11 "Equity capital at time of experiment";
label values r1_c11 r1_c11;
label define r1_c11 1 "Under 0.5 billion VND" 2 "0.5-1 billion VND" 3 "1-5 billion VND" 4 "5-10 billion VND" 5 "10-50 billion VND" 6 "50-200 billion VND" 7 "200-500 billion VND" 8 "Above 500 billion VND";

label variable r1_lg_form  "Legal form";
label values r1_lg_form  r1_lg_form ;
label define r1_lg_form  1 "Sole Proprietorship" 2 "Partnership" 3 "Limited Liability" 4 "Joint Stock" 5 "JS - State Minority" 6 "JS - State Majority" 7 "Collective" 8 "Other";


label variable r1_emp "Employment size at time of experiment";
label values r1_emp  r1_emp;
label define r1_emp 1 "Less than 5 people" 2 "5-9 people" 3 "10-49 people" 4 "50-199 people" 5 "200-299 people" 6 "300-499 people" 7 "500-1000 people" 8 "More than 1000 people"; 

label variable r1_c12a "Employment size at time of experiment";
label values r1_c12a  r1_emp;


lab var province_code "Province Code";
lab var district_code "District Code";
lab var group "Original Treatment Conditions";
lab var r1_group "Original Treatment Conditions (All Round 1 Firms)";
lab var treatment1 "Exposed to Information Treatment=1";
lab var treatment2 "Exposed to Participation Treatment=1";
lab var access "Access to Factory Floor=1";
lab var access2 "Access to Factory Floor (Yes=100)";
lab var success "Agreed to Endline Interview=1";
label values success access2;
lab var subjective_mean "Average Compliance with Chemical Regulation (0-1)";
lab var female "CEO is female=1";
label values female access2;
lab var hanoi "Form is in Hanoi=1";
label values hanoi access2;
lab var fe_provcatsector "Province-Sector Pairs";
lab var enumerator "Chemical Auditor ID";
lab var c3 "Did you change the number of employees in 2015?";
label values c3 access2;
lab var r1_catsector "Broad Sector of Operations at time of Experiment ISIC Rev 4";
lab var cat_sector "Numerial ISIC Broad Code";
lab var r2_response "Respondent Offered Substantive Comment on Regulation=1";
label values r2_response access2;
lab var r2_report "Respondent Received Response Report from Bureau of Labor=1";
label values r2_report access2;
lab var costly_compliance "Average Compliance on Difficult Clauses";
lab var easy_compliance "Average Compliance on Easy Clauses";
label values ceo access2;
label values no_comment access2;

label var district_access "Average Firm Access within Administrative District (PSU)";

lab var c14 "Compliance with Fire Prevention Provision";
lab var c19 "Compliance with Safety Signs Provision";
lab var c51 "Compliance with Fuses/Sockets Provision";
lab var c48 "Compliance with Chemical Transport Provision";
lab var c62 "Compliance with Welding Equipment Provision";
lab var c28 "Compliance with Lightning Prevention Provision";
lab var c34 "Compliance with Washing Facility Provision";
lab var c54 "Compliance with Lighting System Provision";
lab var c34 "Compliance with Washing Facility Provision";
lab var c58 "Compliance with Lighting System Provision";
lab var c68 "Compliance with Mixing Equipment Provision";


keep province_code district_code firm_code province district firm_code gov_understands gov_understands_bl access access2 success subjective_mean status group treatment1 treatment2 r1_emp 
female hanoi fe_provcatsector enumerator cat_sector r1_catsector district_access r2_response r2_report no_comment knowledge understanding c0b quality rents gov_understands_dich c3 c3a  c3b 
costly_compliance2 easy_compliance2 c14 c19 c28 c34  c48 c51 c54 c58 c62 c68 ceo c2 r1_c11 r1_lg_form r1_group r1_c12a sector_plus;

order firm_code ceo province province_code district district_code status group r1_group treatment1 treatment2 gov_understands gov_understands_bl access access2 success subjective_mean status  r1_emp  
female hanoi fe_provcatsector enumerator cat_sector r1_catsector district_access r2_response r2_report no_comment knowledge understanding c0b quality rents gov_understands_dich r1_c11 r1_lg_form  c2  c3 c3a  c3b 
c14 c19 c28 c34  c48 c51 c54 c58 c62 c68 costly_compliance2 easy_compliance2 r1_c12a sector_plus;


#delimit;
save "Data\20181106_RCT_Clean.dta", replace;
codebookout "Data\20181106_RCT_Clean_Codebook.xls", replace;
