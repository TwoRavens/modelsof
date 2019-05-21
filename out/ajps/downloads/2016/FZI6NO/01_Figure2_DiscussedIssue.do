clear all
cd "~/Dropbox/EconNationalism_Union/UnionInformation/ReplicationPackage"
use "UnionInformation_ReplicationData.dta"

keep union_name union8* /* Keep Relevant Variables for the Figure */
keep if union_name =="American Federation of Teachers (AFT)" | union_name == "Communication Workers of America (CWA)" | union_name=="Machinists (IAM)" | union_name =="Service Employees Intl Union (SEIU)" | 	union_name=="United Auto Workers (UAW)" | union_name == "United Steelworkers (USW)" /* Keep Observations for Major Unions */
sort union_name 
egen union_id = group(union_name)

gen politics = 0 /* Generating Variables for Categories of Discussion Topics */
gen trade = 0 
gen wage = 0 
gen contract = 0 
gen job_security = 0
gen union_benefit = 0 
gen immigration = 0
gen healthcare= 0

foreach var in union8a_1 union8b_1 union8c_1{ /* Capitalize Open-ended Answers */
replace `var'= upper(`var')
}

/* If open-ended answers contain the specific words, then they are classified as the given category */

replace politics = 1 if regexm(union8a_1, "POLITIC*|VOTE|ELECTION|DEMOCRA|CONGRES|OBAMA")==1 | regexm(union8b_1, "POLITIC*|VOTE|ELECTION|DEMOCRA|CONGRES|OBAMA")==1 | regexm(union8c_1, "POLITIC*|VOTE|ELECTION|DEMOCRA|CONGRES|OBAMA")==1

replace trade = 1 if regexm(union8a_1, "TRADE")==1 | regexm(union8b_1, "TRADE")==1 | regexm(union8c_1, "TRADE")==1
replace trade = 0 if regexm(union8a_1, "CAP AND TRADE")==1 | regexm(union8b_1, "CAP AND TRADE")==1 | regexm(union8c_1, "CAP AND TRADE")==1
replace trade = 1 if regexm(union8a_1, "SHORE|SOUR|JOBS BEING SHIPPED|NAFTA|WORK GOING OVERSEAS|OVERSEAS JOBS|BUYING AMERICAN")==1 | regexm(union8b_1, "SHORE|SOUR|JOBS BEING SHIPPED|NAFTA|WORK GOING OVERSEAS|OVERSEAS JOBS|BUYING AMERICAN")==1 | regexm(union8c_1, "SHORE|SOUR|JOBS BEING SHIPPED|NAFTA|WORK GOING OVERSEAS|OVERSEAS JOBS|BUYING AMERICAN")==1

replace wage = 1 if regexm(union8a_1, "WAGE|PAY|SALAR")==1 | regexm(union8b_1, "WAGE")==1 | regexm(union8c_1, "WAGE")==1
replace wage = 1 if regexm(union8a_1, "PAY")==1 | regexm(union8b_1, "PAY")==1 | regexm(union8c_1, "PAY")==1
replace wage = 1 if regexm(union8a_1, "SALAR")==1 | regexm(union8b_1, "SALAR")==1 | regexm(union8c_1, "SALAR")==1

replace contract = 1 if regexm(union8a_1, "CONTRACT|DUE")==1 | regexm(union8b_1, "CONTRACT|DUE")==1 | regexm(union8c_1, "CONTRACT|DUE")==1

replace job_security= 1 if regexm(union8a_1, "SECURITY")==1 | regexm(union8b_1, "SECURITY")==1 | regexm(union8c_1, "SECURITY")==1
replace job_security= 1 if (regexm(union8a_1, "JOB")==1 | regexm(union8b_1, "JOB")==1 | regexm(union8c_1, "JOB")==1) & trade!=1
replace job_security= 1 if regexm(union8a_1, "KEEPING US JOBS")==1 | regexm(union8b_1, "KEEPING US JOBS")==1 | regexm(union8c_1, "KEEPING US JOBS")==1 

replace union_benefit = 1 if regexm(union8a_1, "BEN|PENSION|RETIREMENT")==1 | regexm(union8b_1, "BEN|PENSION|RETIREMENT")==1 | regexm(union8c_1, "BEN|PENSION|RETIREMENT")==1

replace immigration = 1 if regexm(union8a_1, "MIGRA|IMMAGRATION|ALIEN|IMAGRATION")==1 | regexm(union8b_1, "MIGRA|IMMAGRATION|ALIEN|IMAGRATION")==1 | regexm(union8c_1, "MIGRA|IMMAGRATION|ALIEN|IMAGRATION")==1

replace health = 1 if regexm(union8a_1, "HEALTH")==1 | regexm(union8b_1, "HEALTH")==1 | regexm(union8c_1, "HEALTH")==1

/* We only consider those who answer the question */
drop if regexm(union8a_1, "__NA__")==1 & regexm(union8b_1, "__NA__")==1 & regexm(union8c_1, "__NA__")==1
drop if union8a_1 == "NONE" | union8a_1 == "NA" | union8a_1 == "NOTHING" | union8a_1 == "JACK SHIT" | union8a_1 == "THE UNION HAS'NT TALKED TO" | union8a_1 == "NO IDEA"

/* The following codes calculate the proportion of each category by each union */

gen member = 1

foreach var in politics trade wage contract job_security union_benefit immigration health member{
by union_name: egen t_`var' = total(`var')
}

foreach var in t_politics t_trade t_wage t_contract t_job_security t_union_benefit t_immigration t_health{
by union_name: gen s_`var' = `var'/t_member
}

duplicates drop union_name, force
keep union_name s_t_politics s_t_trade s_t_wage s_t_contract s_t_job_security s_t_union_benefit s_t_immigration s_t_health

gen union_id = _n

rename s_t_politics s_t_1
rename s_t_trade s_t_2
rename s_t_wage s_t_3
rename s_t_contract s_t_4
rename s_t_job_security s_t_5
rename s_t_union_benefit s_t_6
rename s_t_immigration s_t_7
rename s_t_health s_t_8

reshape long s_t_, i(union_id) j(issue)

rename s_t_ discussion

gen issue1 = "Politics" if issue == 1
replace issue1 = "Trade" if issue == 2
replace issue1 = "Wage" if issue == 3
replace issue1 = "Contract" if issue == 4
replace issue1 = "Job Security" if issue == 5
replace issue1 = "Union Benefit" if issue == 6
replace issue1 = "Immigration" if issue == 7
replace issue1 = "Health Care" if issue == 8

graph hbar (asis) discussion if union_id==1, over(issue1, sort(discussion) descending) stack title(American Federation of Teachers, size(medsmall)) scheme(s2mono) yscale(range(0 0.7)) ylabel(0(0.1)0.7, labsize(medsmall)) 
graph save Graph "AFT.gph", replace
graph hbar (asis) discussion if union_id==2, over(issue1, sort(discussion) descending) stack title(Communication Workers of America, size(medsmall)) scheme(s2mono) yscale(range(0 0.7)) ylabel(0(0.1)0.7, labsize(medsmall)) 
graph save Graph "CWA.gph", replace
graph hbar (asis) discussion if union_id==3, over(issue1, sort(discussion) descending) stack title(IAM: Machinists, size(medsmall)) scheme(s2mono)  yscale(range(0 0.7)) ylabel(0(0.1)0.7, labsize(medsmall)) 
graph save Graph "IAM.gph", replace
graph hbar (asis) discussion if union_id==4, over(issue1, sort(discussion) descending) stack title(Service Employees International Union, size(medsmall)) scheme(s2mono)  yscale(range(0 0.7)) ylabel(0(0.1)0.7, labsize(medsmall)) 
graph save Graph "SEIU.gph", replace
graph hbar (asis) discussion if union_id==5, over(issue1, sort(discussion) descending) stack title(United Auto Workers, size(medsmall)) scheme(s2mono)  yscale(range(0 0.7)) ylabel(0(0.1)0.7, labsize(medsmall)) 
graph save Graph "UAW.gph", replace
graph hbar (asis) discussion if union_id==6, over(issue1, sort(discussion) descending) stack title(United Steelworkers, size(medsmall)) scheme(s2mono)  yscale(range(0 0.7)) ylabel(0(0.1)0.7, labsize(medsmall)) 
graph save Graph "USW.gph", replace

graph combine UAW.gph IAM.gph USW.gph CWA.gph AFT.gph SEIU.gph
