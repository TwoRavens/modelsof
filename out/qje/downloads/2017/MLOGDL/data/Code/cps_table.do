/*******************************************************************************
Preference for the Workplace, Investment in Human Capital, and Gender
 - Matthew Wiswall and Basit Zafar

Overview:
1) Create CPS table for the paper

*******************************************************************************/

clear all
set more off

*global maindir /san/RDS/Work/mms/b1jxc50/Basit/NYU_Hypotheticals/Files_To_QJE/
global maindir "C:\Users\b1bxz01\Desktop\Temp\Tables NYU Updating\Job Hypotheticals\Draft\Revision June 2016\Resubmission April 2017\Files_To_QJE\"
global output "${maindir}Output/"
global datadir "${maindir}Data/"
 
use "${datadir}monthly_cps"
********************************************************************************
* Part I: CPS Job Attributes
********************************************************************************
*--Create occupation groups
// These categories are not comprehensive - we omit a number of CPS industries
gen category = 1 if ind==7290  | ind==7380 | ind==7460 | ind==9570 | ind==6695
replace category = 2 if ind==7970 | ind==7980 | ind==7990 | ind==8070 | ind==8080 | ///
	ind==8090 | ind==8170 | ind==8180 | ind==8190 | ind==8270 | ind==8290 | ///
	ind==8370 | ind==8380 | ind==8390 | ind==8470 // | ind==5080
replace category = 3 if ind==6870 | ind==6880 | ind==6890 | ind==6970 | ind==6990 | ///
	ind==7070 | ind==7280 | ind==7390 | ind==7470 | ind==7570 
replace category = 4 if ind==9370 | ind==9380 | ind==9390 | ind==9470 | ind==9480 | ///
	ind==9490 | ind==9590 
replace category = 5 if ind==7860 | ind==7870 | ind==7880 | ind==7890
replace category = 6 if (ind >= 1070 & ind <= 3990) | (ind >= 6070 & ind <= 6390)	///
		| (ind >=370 & ind <= 770) | (ind >=170 & ind <= 290) 
replace category = 7 if (ind >= 4070 & ind <= 5790) | (ind >= 6470 & ind <= 6780) ///
		| (ind >= 7080 & ind <= 7190) | inlist(ind, 7270, 7370, 7480, 7490) ///
		| inrange(ind, 7580, 7790) | inrange(ind, 8560, 9290)
label define category 1 "science" 2 "health" 3 "business" 4 "government" 5 "education" 6 "blue collar and agriculture" 7 "other services and trade"
label value category category

tab ind if category == . & ind != -1
*************

keep if category!=.

gen count = 1
bysort month: egen total = sum(count)


*--Create job attributes
// Earnings 
gen employed = 1 if mlr==1 | mlr==2

// Number of hours worked
rename  ernush hoursusu
rename  hours hoursact
replace ernwk = ernwk/100

// Definining education 
gen educ = 1 if grdatn<39
replace educ = 2 if grdatn==39
replace educ = 3 if grdatn>39 & grdatn<=42
replace educ = 4 if grdatn>42


*************************PART TIME**********************************
/// Full/part time indicator
gen fulltime = 1 if inlist(wkstat,2,5,8,9)
replace fulltime = 0 if inlist(wkstat,3,4,6,7,10)

// Pct of people working part time
gen count_part =1 if fulltime==0
gen count_full= 1 if inlist(fulltime,1,0) 
bysort category month year: egen num_part=sum(count_part) // number of PT workers 
bysort category month year: egen num_full = sum(count_full) // total number of workers
bysort category month year: gen pct_part = num_part/num_full

// Pct college grads working part time 
bysort category month year: egen num_part_grad=sum(count_part) if educ==4
bysort category month year: egen num_full_grad = sum(count_full) if educ==4
bysort category month year: egen num_full_grad_fem = sum(count_full) if educ==4 & sex==2
bysort category month year: egen num_full_grad_male = sum(count_full) if educ==4 & sex==1
bysort category month year: gen pct_part_grad = num_part_grad/num_full_grad



************************* GENDER COUNTS ****************************
// Gender counts
gen find = 1 if sex==2
gen mind = 1 if sex==1
bysort category month year: egen female = sum(find)
bysort category month year: egen male = sum(mind)
bysort category month year: gen all = female + male
gen pct_female = female/all
// Gender counts for college graduates
bysort category month year: egen female_grad = sum(find) if educ==4
bysort category month year: egen male_grad = sum(mind) if educ==4
bysort category month year: gen total_grad = female_grad + male_grad
gen pct_female_grad = female_grad/total_grad


gen month_n = (year - 2010)*12 + month

************************* PROBABILITY OF BEING FIRED *****  ********
// Probability of being fired in each industry/occupation
gen fired = 1 if untype==2 & undur<=5 // laid off and unemploymed for less than a month means the person got fired this month
replace fired = 0 if fired!=1
bysort category month year: egen num_fired = sum(fired) // total number of people fired

gen unemp = 1 if mlr==3 | mlr==4
replace unemp = 0 if unemp!=1
gen emp = 1 if mlr==1 | mlr==2 // =1 if employed at beginning of this month
replace emp = 0 if emp!=1


bysort category month year: egen num_unemp = sum(unemp)
bysort category month year:  egen num_emp = sum(emp)
gen num_emp_lastmonth = .

levelsof month_n, local(months)
levelsof category, local(cats)
foreach m in `months' {
foreach cat in `cats' {
count if emp == 1 & category == `cat' & month_n == `m'
replace num_emp_lastmonth = r(N) if category == `cat' & month_n == `m' + 1
}
}
gen prob_fired = num_fired/num_emp_lastmonth // Number of fired (in this month)/number employed last month

// Prob of being fired in each industry
gen prob_fired_year = 1-(1-prob_fired)^12

// Prob of percent male in each industry
gen pct_male = 1- pct_female

************************* EARNINGS**************** *****************
sum hoursact if hoursact>=0, d
replace hoursact= . if hoursact<=r(p1) | hoursact>=r(p99)
rename ernwk earnwk

sum earnwk if earnwk>=0, d
replace earnwk= . if earnwk<=r(p1) 

gen earnyr = earnwk * 52
replace earnwk = . if earnwk < (7.25*hoursact)
drop earnyr
gen earnyr = earnwk * 52

// rounding frequency weights
rename wgt indwgt
rename hhwgt wgt
replace wgt = wgt/10000
replace wgt =  round(wgt,1)


tempfile cleaned_data
save `cleaned_data', replace


********************************************************************************
* Part II: Job Attributes by Industry, by Gender
********************************************************************************
*--Look at college educated workers, age 25-60
use `cleaned_data', clear

keep if age>=25 & age<=60
keep if educ==4 // restrict to college grads

// Logearning
replace earnyr = .001 if earnyr == 0
gen logearning = ln(earnyr)
replace logearning =. if missing(earnyr)

// Number of years of education
gen education = 12 + educ

// Generate experience
gen exper = age - education - 6
gen age2 = age^2


*--Proportion of Males/Females
tab category, gen(category)
tab category sex if emp == 1, chi2


*** UPDATED 11/27/15: Create bonus variable
gen bonus = hoursact*(ernhr - ernhr1)/100  if ernhr1!=-1  // hourly overtime * hours worked last week = weekly overtime
replace bonus = . if bonus == 0
replace bonus = ernoth if mi(bonus) | ernhr1 == -1  // weekly overtime
replace bonus = . if bonus == -1


********************************************************************************
* Job Attributes across industry (pool males and females)
********************************************************************************

file open results using "${output}table1_cps_25to60_$S_DATE.csv", write replace
file write results "CPS Table: 25 to 60" _n
file write results ",Prop. of Males, Prop. of Females, Earnings, Logearnings, Hours, Parttime, Fired, Pct Male, Raise" _n

forvalues num = 1/7{

	// Prob of logearning in each industry, fulltime only
	sum earnyr if earnyr>=0 & fulltime==1 & category == `num' [aw = wgt], d
	local cate`num'_earn = round(r(mean),1)
	local cate`num'_earn_sd = round(r(sd),1)
	
	// Logearnings
	sum logearning if earnyr>=0 & fulltime==1 & category == `num' [aw = wgt], d
	local cate`num'_logearn = round(r(mean),.01)
	local cate`num'_logearn_sd = round(r(sd),.01)

	// Prob of number of hours in each industry, fulltime only
	sum hoursact if hoursact>=0 & fulltime==1 & category == `num' [aw = wgt], d
	local cate`num'_hours = round(r(mean),.01)
	local cate`num'_hours_sd = round(r(sd),.01)
	
	// Prob of parttime option in each industry
	sum pct_part if category == `num' [aw = wgt], d
	local cate`num'_parttime = 100*round(r(mean),.0001)
	local cate`num'_parttime_sd = 100*round(r(sd),.0001)
	
	// Prob of being fired in each industry -- manually convert to percentage
	sum prob_fired_year if category == `num' [aw = wgt], d
	local cate`num'_fired = 100*round(r(mean),.0001)
	local cate`num'_fired_sd = 100*round(r(sd),.00001)	
	
	// Prob of percent male in each industry -- manually convert to percentage
	sum pct_male if emp==1 & category == `num' [aw = wgt], d
	local cate`num'_fracmale = 100*round(r(mean),.0001)
	local cate`num'_fracmale_sd = 100*round(r(sd),.00001)	
}
mvtest means earnyr if earnyr>=0 & fulltime==1 [aw = wgt], by(category)
local p_earn = round(r(p_F), .01)

mvtest means logearning if earnyr>=0 & fulltime==1 [aw = wgt], by(category)
local p_logearn = round(r(p_F), .01)

mvtest means hoursact if hoursact>=0 & fulltime==1 [aw = wgt], by(category)
local p_hours = round(r(p_F), .01)

mvtest means pct_part [aw = wgt], by(category)
local p_parttime = round(r(p_F), .01)

mvtest means prob_fired_year [aw = wgt], by(category)
local p_fired = round(r(p_F), .01)

mvtest means pct_male if emp == 1 [aw = wgt], by(category)
local p_fracmale = round(r(p_F), .01)

mvtest means category? if sex == 1 [aw = wgt]
local p_cats_male = round(r(p_F), .01)

mvtest means category? if sex == 2 [aw = wgt]
local p_cats_female = round(r(p_F), .01)

preserve
use "${datadir}/matched_for_year_raise.dta", clear
keep if age >= 25 & age <= 60
rename grdatn0 grdatn
// Definining education 
gen educ = 1 if grdatn<39
replace educ = 2 if grdatn==39
replace educ = 3 if grdatn>39 & grdatn<=42
replace educ = 4 if grdatn>42
keep if educ==4 // restrict to college grads
gen ind = ind0 if ind0 == ind1
gen wgt = wgt1
*--Create occupation groups
// These categories are not comprehensive - we omit a number of CPS industries
gen category = 1 if ind==7290  | ind==7380 | ind==7460 | ind==9570 | ind==6695
replace category = 2 if ind==7970 | ind==7980 | ind==7990 | ind==8070 | ind==8080 | ///
	ind==8090 | ind==8170 | ind==8180 | ind==8190 | ind==8270 | ind==8290 | ///
	ind==8370 | ind==8380 | ind==8390 | ind==8470 // | ind==5080
replace category = 3 if ind==6870 | ind==6880 | ind==6890 | ind==6970 | ind==6990 | ///
	ind==7070 | ind==7280 | ind==7390 | ind==7470 | ind==7570 
replace category = 4 if ind==9370 | ind==9380 | ind==9390 | ind==9470 | ind==9480 | ///
	ind==9490 | ind==9590 
replace category = 5 if ind==7860 | ind==7870 | ind==7880 | ind==7890
replace category = 6 if (ind >= 1070 & ind <= 3990) | (ind >= 6070 & ind <= 6390)	///
		| (ind >=370 & ind <= 770) | (ind >=170 & ind <= 290) 
replace category = 7 if (ind >= 4070 & ind <= 5790) | (ind >= 6470 & ind <= 6780) ///
		| (ind >= 7080 & ind <= 7190) | inlist(ind, 7270, 7370, 7480, 7490) ///
		| inrange(ind, 7580, 7790) | inrange(ind, 8560, 9290) | inrange(ind, 8560, 8690)
label define category 1 "science" 2 "health" 3 "business" 4 "government" 5 "education" 6 "blue collar and agriculture" 7 "other services and trade"
label value category category
drop if missing(category)
rename  hours0 hoursact0
rename  hours1 hoursact1

sum hoursact0 if hoursact0>=0, d
replace hoursact0= . if hoursact0<=r(p1) | hoursact0>=r(p99)
sum hoursact1 if hoursact1>=0, d
replace hoursact1= . if hoursact1<=r(p1) | hoursact1>=r(p99)

replace ernwk0 = . if ernwk0/100 < (7.25*hoursact0)
replace ernwk1 = . if ernwk1/100 < (7.25*hoursact1)

sum ernwk0 if ernwk0>=0, d
replace ernwk0= . if ernwk0<=r(p1) 

sum ernwk1 if ernwk1>=0, d
replace ernwk1= . if ernwk1<=r(p1) 

gen ernyr0 = 52*ernwk0/100 if ernwk0 > 0
gen ernyr1 = 52*ernwk1/100 if ernwk1 > 0

sum ernyr0 ernyr1 if hoursact0 >= 35 & hoursact1 >= 35
gen raise = (ernyr1-ernyr0)/ernyr0

sum raise if hoursact0 >= 35 & hoursact1 >= 35, d

replace raise = . if raise < r(p10) | raise > r(p90)

forvalues num = 1/7{
	sum raise if category == `num' & hoursact0 >= 35 & hoursact1 >= 35 [aw = wgt], d
	local cate`num'_raise = round(100*r(mean),.01)
	local cate`num'_raise_sd = round(100*r(sd),.01)
}

mvtest means raise if hoursact0 >= 35 & hoursact1 >= 35 [aw = wgt], by(category)
local p_raise = round(r(p_F), .01)


restore

foreach cat of numlist 1/7 {
sum category`cat' if sex == 1
local cate`cat'_pct_male = round(100*r(mean), .01)
sum category`cat' if sex == 2
local cate`cat'_pct_female = round(100*r(mean), .01)
display "`cate`num'_pct_male',`cate`num'_pct_female'"
}
forvalues num = 1/7{

	file write results `"="`:label category `num''",="`cate`num'_pct_male'",="`cate`num'_pct_female'",="`cate`num'_earn'",="`cate`num'_logearn'",="`cate`num'_hours'",="`cate`num'_parttime'",="`cate`num'_fired'",="`cate`num'_fracmale'",="`cate`num'_raise'","' _n
	file write results `",,,="(`cate`num'_earn_sd')",="(`cate`num'_logearn_sd')",="(`cate`num'_hours_sd')",="(`cate`num'_parttime_sd')",="(`cate`num'_fired_sd')",="(`cate`num'_fracmale_sd')",="(`cate`num'_raise_sd')","' _n	
}
	file write results `"="p-value",="`p_cats_male'",="`p_cats_female'",="`p_earn'",="`p_logearn'",="`p_hours'",="`p_parttime'",="`p_fired'",="`p_fracmale'",="`p_raise'""'

file close results

file open results using "${output}table1_cps_25to60.tex", write replace
local cols 8
local header "\begin{table}\caption{`caption'}\label{`label'} \centering \begin{tabular}{l*{`cols'}{c}}"
local footer "\end{tabular}\end{table}"
file write results "`header' \hline \hline" _n
file write results " & Prop. of Males & Prop. of Females & Earnings & Hours & Parttime & Fired & Pct Male & Raise \\ \hline" _n

forvalues num = 1/7{

	file write results "`:label category `num'' & `cate`num'_pct_male' & `cate`num'_pct_female' & `cate`num'_earn' & `cate`num'_hours' & `cate`num'_parttime' & `cate`num'_fired' & `cate`num'_fracmale' & `cate`num'_raise' \\" _n
	file write results "& & & (`cate`num'_earn_sd') & (`cate`num'_hours_sd') & (`cate`num'_parttime_sd') & (`cate`num'_fired_sd') & (`cate`num'_fracmale_sd') & (`cate`num'_raise_sd') \\" _n	
}
file write results "p-value & `p_cats_male' & `p_cats_female' & `p_earn' & `p_hours' & `p_parttime' & `p_fired' & `p_fracmale' & `p_raise' \\" _n
file write results "`footer'"
file close results

