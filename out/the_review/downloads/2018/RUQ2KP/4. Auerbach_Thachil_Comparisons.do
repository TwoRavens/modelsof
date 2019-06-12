****************************************************************
* Replication code for Supplement Table S.16 and Figure S.9
* "How Clients Select Brokers"
* Adam Auerbach and Tariq Thachil
* May 2018
****************************************************************


use "AuerbachThachilSlumLeadersResidents.dta"

** install special Stata package 'cibar' for generating bars with confidence intervals for comparisons in Figure S.9
ssc install cibar

************************************************* Table S.16: COMPARING RESIDENTS AND SLUM LEADER JOBS******************************************************************

***Coding job categories
generate laborers = .
generate home_maker = .
generate vocational_job = .
generate driver = .
generate artisan = .
generate government_job = .
generate professional_job = .
generate religious_work = .
generate small_business_low = .
generate small_business_medium = .
generate private_sector = .
generate skilled_labor = .
generate unemployed_retired = .
generate contractor = .
generate real_estate = .
generate student = .
generate educator = .
generate social_worker = .

replace laborers = 1 if general_code == "laborer"
replace laborers = 0 if general_code !=  "laborer"
replace home_maker = 1 if general_code == "home maker"
replace home_maker = 0 if general_code !=  "home maker"
replace vocational_job = 1 if general_code == "vocational job"
replace vocational_job = 0 if general_code !=  "vocational job"
replace driver = 1 if general_code == "driver"
replace driver = 0 if general_code !=  "driver"
replace artisan = 1 if general_code == "artisan"
replace artisan = 0 if general_code !=  "artisan"
replace government_job = 1 if general_code == "government job"
replace government_job = 0 if general_code !=  "government job"
replace professional_job = 1 if general_code == "professional job"
replace professional_job = 0 if general_code !=  "professional job"
replace religious_work = 1 if general_code == "religious work"
replace religious_work = 0 if general_code !=  "religious work"
replace small_business_low = 1 if general_code == "small business (low status)"
replace small_business_low = 0 if general_code !=  "small business (low status)"
replace small_business_medium = 1 if general_code == "small business (medium status)"
replace small_business_medium = 0 if general_code !=  "small business (medium status)"
replace private_sector = 1 if general_code == "private sector (salaried)"
replace private_sector = 0 if general_code !=  "private sector (salaried)"
replace skilled_labor = 1 if general_code == "skilled labor"
replace skilled_labor = 0 if general_code !=  "skilled labor"
replace unemployed_retired = 1 if general_code == "unemployed and retired"
replace unemployed_retired = 0 if general_code !=  "unemployed and retired"
replace contractor = 1 if general_code == "contractor"
replace contractor = 0 if general_code !=  "contractor"
replace real_estate = 1 if general_code == "real estate"
replace real_estate = 0 if general_code !=  "real estate"
replace student = 1 if general_code == "student"
replace student = 0 if general_code !=  "student"
replace educator = 1 if general_code == "educator"
replace educator = 0 if general_code !=  "educator"
replace social_worker = 1 if general_code == "social worker"
replace social_worker = 0 if general_code !=  "social worker"

* comparison of residents and leaders in particular job categories 
ttest laborer, by(leader) welch
ttest government_job, by(leader) welch
ttest home_maker, by(leader) welch
ttest small_business_low, by(leader) welch
ttest small_business_medium, by(leader) welch
ttest professional_job, by(leader) welch
ttest private_sector, by(leader) welch
ttest vocational_job, by(leader) welch
ttest driver, by(leader) welch
ttest artisan, by(leader) welch
ttest skilled_labor, by(leader) welch
ttest contractor, by(leader) welch
ttest student, by(leader) welch
ttest educator, by(leader) welch
ttest real_estate, by(leader) welch
ttest religious_work, by(leader) welch
ttest unemployed_retired, by(leader) welch
ttest social_worker, by(leader) welch

************************************************* FIGURE S.9: COMPARING RESIDENTS AND SLUM LEADER EDUCATION******************************************************************

** create Education tiers
generate Educ0=1 if education==0
recode Educ0 (.=0)

generate Educ1to5=1 if education>=1&education<=5
recode Educ1to5 (.=0)

generate Educ6to8=1 if education>=6&education<=8
recode Educ6to8 (.=0)

generate Educ9to12=1 if education>=9&education<=12
recode Educ9to12 (.=0)

generate EducCollege=1 if education>12
recode EducCollege (.=0)

*comparisons of educational achievement
ttest Educ0, by(leader) welch
ttest Educ1to5, by(leader) welch
ttest Educ6to8, by(leader) welch
ttest Educ9to12, by(leader) welch
ttest EducCollege, by(leader) welch

*graphical comparisons of educational achievement
cibar Educ0, over1(leader) graphopts(yscale(range(0 .4)) title("Comparison of Leader and Resident Education (0 Years)") ytitle("Mean Proportion of Respondents") graphregion(color(white)) ylabel (0(.1).4)) barcolor(blue green) bargap(50)
cibar Educ1to5, over1(leader) graphopts(yscale(range(0 .4)) title("Comparison of Leader and Resident Education (1-5 Years)") ytitle("Mean Proportion of Respondents") graphregion(color(white)) ylabel (0(.1).4)) barcolor(blue green) bargap(50)
cibar Educ6to8, over1(leader) graphopts(yscale(range(0 .4)) title("Comparison of Leader and Resident Education (6-8 Years)") ytitle("Mean Proportion of Respondents") graphregion(color(white)) ylabel (0(.1).4)) barcolor(blue green) bargap(50)
cibar Educ9to12, over1(leader) graphopts(yscale(range(0 .4)) title("Comparison of Leader and Resident Education (9-12 Years)") ytitle("Mean Proportion of Respondents") graphregion(color(white)) ylabel (0(.1).4)) barcolor(blue green) bargap(50)
cibar EducCollege, over1(leader) graphopts(yscale(range(0 .4)) title("Comparison of Leader and Resident Education (Some College Education)") ytitle("Mean Proportion of Respondents") graphregion(color(white)) ylabel (0(.1).4)) barcolor(blue green) bargap(50)

