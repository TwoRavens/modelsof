


***Step 1: create Subfigure for those with high levels of education

set more off

***Use Data for Vietnam
use "VI_agree_final.dta", clear

capture matrix drop resmat

*low skill
reg agree i.job_low_skills if education>4, cl(respondent)
foreach x of numlist 1(1)2 {
lincom  `x'.job_low_skills
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.job_low_skills"
matrix resmat = nullmat(resmat) \ coef
}

* med skill
reg agree i.job_med_skills if education>4, cl(respondent)
foreach x of numlist 1(1)2 {
lincom  `x'.job_med_skills
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.job_med_skills"
matrix resmat = nullmat(resmat) \ coef
}

* high skill
reg agree i.job_high_skills if education>4, cl(respondent)
foreach x of numlist 1(1)2 {
lincom  `x'.job_high_skills
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'. job_high_skills"
matrix resmat = nullmat(resmat) \ coef
}

*work
reg agree i.work if education>4, cl(respondent) 

foreach x of numlist 1(1)3 {
lincom  `x'.work 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.work"
matrix resmat = nullmat(resmat) \ coef
}

*Environment
reg agree i.env if education>4, cl(respondent) 

foreach x of numlist 1(1)3 {
lincom  `x'.env 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.env"
matrix resmat = nullmat(resmat) \ coef
}

*job man
reg agree i.job_man if education>4, cl(respondent) 

foreach x of numlist 1(1)3 {
lincom  `x'.job_man
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.job_man"
matrix resmat = nullmat(resmat) \ coef
}

*job ser
reg agree i.job_ser if education>4, cl(respondent) 

foreach x of numlist 1(1)3 {
lincom  `x'.job_ser
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.job_ser"
matrix resmat = nullmat(resmat) \ coef
}

*job ag
reg agree i.job_ag if education>4, cl(respondent) 

foreach x of numlist 1(1)3 {
lincom  `x'.job_ag
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.job_ag"
matrix resmat = nullmat(resmat) \ coef
}

*price
reg agree i.price if education>4, cl(respondent) 

foreach x of numlist 1(1)3 {
lincom  `x'.price
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.price"
matrix resmat = nullmat(resmat) \ coef
}

**origin
reg agree i.origin if education>4, cl(respondent) 

foreach x of numlist 1(1)6 {
lincom  `x'.origin
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.origin"
matrix resmat = nullmat(resmat) \ coef
}



*count
reg agree i.count if education>4, cl(respondent) 

foreach x of numlist 1(1)5 {
lincom  `x'.count
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.count"
matrix resmat = nullmat(resmat) \ coef
}


mat2txt , matrix(resmat) saving("educ_high_VI.txt") replace
matrix drop resmat

**making graphs

insheet using "educ_high_VI.txt", clear


gen varname=_n
list



#delimit ;
label define varlab 31 "2 countries" 32 "5 countries" 33 "10 countries" 34 "50 countries" 35 "150 countries" 
25 "EU"  26 "India" 27 "Russia" 28 "Brasil" 29 "China" 30 "US" 
22 "increases prices"  23 "no effect prices"  24 "reduces prices" 
19 "ag less"  20  "ag same" 21 "ag more" 
16 "services less"  17 "services same" 18 "services more"
13 "manufacturing less"  14 "manufacturing same" 15 "manufacturing more" 
10 "reduce environment"  11 "maintain environment"  12 "increase environment" 
7 "reduce worker rights"  8  "maintain worker rights" 9 "increase worker rights" 
6 "high skills yes" 5 "high skill no" 
4 "med skill yes" 3 "med skill no"
2 "low skill yes" 1 "low skill no", replace;
#delimit cr

label values varname varlab
list

 
gen clo=c1-1.96*c2
gen chi=c1+1.96*c2
*list


*edit

#delimit;
graph twoway (rspike clo chi varname, horizontal ytitle("") ylabel(1(1)35, labsize(small) valuelabel angle(0)) xtitle("Change in Pr (VN: high-skilled)") 
xline(0, lcolor(black))) (scatter varname c1, mcolor(black) msymbol(circle) msize(vsmall) ytitle("")), scheme(s2mono) legend(off);
#delimit cr


graph export "edu_high_VN.pdf", replace
graph save "edu_high_VN.gph", replace


***Step 2: create Subfigure for those with low levels of education

set more off
***Use Data for Vietnam

use "VI_agree_final.dta", clear




capture matrix drop resmat

*low skill
reg agree i.job_low_skills if education<5, cl(respondent)
foreach x of numlist 1(1)2 {
lincom  `x'.job_low_skills
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.job_low_skills"
matrix resmat = nullmat(resmat) \ coef
}

* med skill
reg agree i.job_med_skills if education<5, cl(respondent)
foreach x of numlist 1(1)2 {
lincom  `x'.job_med_skills
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.job_med_skills"
matrix resmat = nullmat(resmat) \ coef
}

* high skill
reg agree i.job_high_skills if education<5, cl(respondent)
foreach x of numlist 1(1)2 {
lincom  `x'.job_high_skills
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'. job_high_skills"
matrix resmat = nullmat(resmat) \ coef
}

*work
reg agree i.work if education<5, cl(respondent) 

foreach x of numlist 1(1)3 {
lincom  `x'.work 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.work"
matrix resmat = nullmat(resmat) \ coef
}

*Environment
reg agree i.env if education<5, cl(respondent) 

foreach x of numlist 1(1)3 {
lincom  `x'.env 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.env"
matrix resmat = nullmat(resmat) \ coef
}

*job man
reg agree i.job_man if education<5, cl(respondent) 

foreach x of numlist 1(1)3 {
lincom  `x'.job_man
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.job_man"
matrix resmat = nullmat(resmat) \ coef
}

*job ser
reg agree i.job_ser if education<5, cl(respondent) 

foreach x of numlist 1(1)3 {
lincom  `x'.job_ser
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.job_ser"
matrix resmat = nullmat(resmat) \ coef
}

*job ag
reg agree i.job_ag if education<5, cl(respondent) 

foreach x of numlist 1(1)3 {
lincom  `x'.job_ag
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.job_ag"
matrix resmat = nullmat(resmat) \ coef
}

*price
reg agree i.price if education<5, cl(respondent) 

foreach x of numlist 1(1)3 {
lincom  `x'.price
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.price"
matrix resmat = nullmat(resmat) \ coef
}

**origin
reg agree i.origin if education<5, cl(respondent) 

foreach x of numlist 1(1)6 {
lincom  `x'.origin
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.origin"
matrix resmat = nullmat(resmat) \ coef
}



*count
reg agree i.count if education<5, cl(respondent) 

foreach x of numlist 1(1)5 {
lincom  `x'.count
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.count"
matrix resmat = nullmat(resmat) \ coef
}


mat2txt , matrix(resmat) saving("educ_low_VI.txt") replace
matrix drop resmat

**making graphs

insheet using "educ_low_VI.txt", clear


gen varname=_n
list



#delimit ;
label define varlab 31 "2 countries" 32 "5 countries" 33 "10 countries" 34 "50 countries" 35 "150 countries" 
25 "EU"  26 "India" 27 "Russia" 28 "Brasil" 29 "China" 30 "US" 
22 "increases prices"  23 "no effect prices"  24 "reduces prices" 
19 "ag less"  20  "ag same" 21 "ag more" 
16 "services less"  17 "services same" 18 "services more"
13 "manufacturing less"  14 "manufacturing same" 15 "manufacturing more" 
10 "reduce environment"  11 "maintain environment"  12 "increase environment" 
7 "reduce worker rights"  8  "maintain worker rights" 9 "increase worker rights" 
6 "high skills yes" 5 "high skill no" 
4 "med skill yes" 3 "med skill no"
2 "low skill yes" 1 "low skill no", replace;
#delimit cr

label values varname varlab
list

 
gen clo=c1-1.96*c2
gen chi=c1+1.96*c2


#delimit;
graph twoway (rspike clo chi varname, horizontal ytitle("") ylabel(1(1)35, labsize(small) valuelabel angle(0)) xtitle("Change in Pr (VN: low-skilled)") 
xline(0, lcolor(black))) (scatter varname c1, mcolor(black) msymbol(circle) msize(vsmall) ytitle("")), scheme(s2mono) legend(off);
#delimit cr


graph export "edu_low_VN.pdf", replace
graph save "edu_low_VN.gph", replace


**graph combine two educations
graph combine "edu_low_VN.gph" "edu_high_VN.gph"
*edit within Stata graph editor to add titles and change position of subgraph 3


graph export "education_VN.pdf", replace







*** Employment agriculture


set more off

***Use Data for Vietnam
use "VI_agree_final.dta", clear

capture matrix drop resmat

*low skill
reg agree i.job_low_skills if sector==1, cl(respondent)
foreach x of numlist 1(1)2 {
lincom  `x'.job_low_skills
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.job_low_skills"
matrix resmat = nullmat(resmat) \ coef
}

* med skill
reg agree i.job_med_skills if sector==1, cl(respondent)
foreach x of numlist 1(1)2 {
lincom  `x'.job_med_skills
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.job_med_skills"
matrix resmat = nullmat(resmat) \ coef
}

* high skill
reg agree i.job_high_skills if sector==1, cl(respondent)
foreach x of numlist 1(1)2 {
lincom  `x'.job_high_skills
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'. job_high_skills"
matrix resmat = nullmat(resmat) \ coef
}

*work
reg agree i.work if sector==1, cl(respondent) 

foreach x of numlist 1(1)3 {
lincom  `x'.work 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.work"
matrix resmat = nullmat(resmat) \ coef
}

*Environment
reg agree i.env if sector==1, cl(respondent) 

foreach x of numlist 1(1)3 {
lincom  `x'.env 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.env"
matrix resmat = nullmat(resmat) \ coef
}

*job man
reg agree i.job_man if sector==1, cl(respondent) 

foreach x of numlist 1(1)3 {
lincom  `x'.job_man
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.job_man"
matrix resmat = nullmat(resmat) \ coef
}

*job ser
reg agree i.job_ser if sector==1, cl(respondent) 

foreach x of numlist 1(1)3 {
lincom  `x'.job_ser
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.job_ser"
matrix resmat = nullmat(resmat) \ coef
}

*job ag
reg agree i.job_ag if sector==1, cl(respondent) 

foreach x of numlist 1(1)3 {
lincom  `x'.job_ag
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.job_ag"
matrix resmat = nullmat(resmat) \ coef
}

*price
reg agree i.price if sector==1, cl(respondent) 

foreach x of numlist 1(1)3 {
lincom  `x'.price
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.price"
matrix resmat = nullmat(resmat) \ coef
}

**origin
reg agree i.origin if  sector==1, cl(respondent) 

foreach x of numlist 1(1)6 {
lincom  `x'.origin
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.origin"
matrix resmat = nullmat(resmat) \ coef
}



*count
reg agree i.count if sector==1, cl(respondent) 

foreach x of numlist 1(1)5 {
lincom  `x'.count
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.count"
matrix resmat = nullmat(resmat) \ coef
}


mat2txt , matrix(resmat) saving("agri_VI.txt") replace
matrix drop resmat

**making graphs

insheet using "agri_VI.txt", clear


gen varname=_n
list



#delimit ;
label define varlab 31 "2 countries" 32 "5 countries" 33 "10 countries" 34 "50 countries" 35 "150 countries" 
25 "EU"  26 "India" 27 "Russia" 28 "Brasil" 29 "China" 30 "US" 
22 "increases prices"  23 "no effect prices"  24 "reduces prices" 
19 "ag less"  20  "ag same" 21 "ag more" 
16 "services less"  17 "services same" 18 "services more"
13 "manufacturing less"  14 "manufacturing same" 15 "manufacturing more" 
10 "reduce environment"  11 "maintain environment"  12 "increase environment" 
7 "reduce worker rights"  8  "maintain worker rights" 9 "increase worker rights" 
6 "high skills yes" 5 "high skill no" 
4 "med skill yes" 3 "med skill no"
2 "low skill yes" 1 "low skill no", replace;
#delimit cr

label values varname varlab
list

 
gen clo=c1-1.96*c2
gen chi=c1+1.96*c2
*list


*edit

#delimit;
graph twoway (rspike clo chi varname, horizontal ytitle("") ylabel(1(1)35, labsize(small) valuelabel angle(0)) xtitle("Change in Pr (Vietnam: Agriculture)") 
xline(0, lcolor(black))) (scatter varname c1, mcolor(black) msymbol(circle) msize(vsmall) ytitle("")), scheme(s2mono) legend(off);
#delimit cr


graph export "agri_VN.pdf", replace
graph save "agri_VN.gph", replace





*** Employment manufacturing


set more off

***Use Data for Vietnam
use "VI_agree_final.dta", clear


capture matrix drop resmat

*low skill
reg agree i.job_low_skills if sector==2 | sector==3 | sector==4 , cl(respondent)
foreach x of numlist 1(1)2 {
lincom  `x'.job_low_skills
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.job_low_skills"
matrix resmat = nullmat(resmat) \ coef
}

* med skill
reg agree i.job_med_skills if sector==2 | sector==3 | sector==4 , cl(respondent)
foreach x of numlist 1(1)2 {
lincom  `x'.job_med_skills
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.job_med_skills"
matrix resmat = nullmat(resmat) \ coef
}

* high skill
reg agree i.job_high_skills if sector==2 | sector==3 | sector==4 , cl(respondent)
foreach x of numlist 1(1)2 {
lincom  `x'.job_high_skills
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'. job_high_skills"
matrix resmat = nullmat(resmat) \ coef
}

*work
reg agree i.work if sector==2 | sector==3 | sector==4  , cl(respondent) 

foreach x of numlist 1(1)3 {
lincom  `x'.work 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.work"
matrix resmat = nullmat(resmat) \ coef
}

*Environment
reg agree i.env if sector==2 | sector==3 | sector==4  , cl(respondent) 

foreach x of numlist 1(1)3 {
lincom  `x'.env 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.env"
matrix resmat = nullmat(resmat) \ coef
}

*job man
reg agree i.job_man if sector==2 | sector==3 | sector==4 , cl(respondent) 

foreach x of numlist 1(1)3 {
lincom  `x'.job_man
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.job_man"
matrix resmat = nullmat(resmat) \ coef
}

*job ser
reg agree i.job_ser if sector==2 | sector==3 | sector==4  , cl(respondent) 

foreach x of numlist 1(1)3 {
lincom  `x'.job_ser
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.job_ser"
matrix resmat = nullmat(resmat) \ coef
}

*job ag
reg agree i.job_ag if sector==2 | sector==3 | sector==4 , cl(respondent) 

foreach x of numlist 1(1)3 {
lincom  `x'.job_ag
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.job_ag"
matrix resmat = nullmat(resmat) \ coef
}

*price
reg agree i.price if sector==2 | sector==3 | sector==4 , cl(respondent) 

foreach x of numlist 1(1)3 {
lincom  `x'.price
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.price"
matrix resmat = nullmat(resmat) \ coef
}

**origin
reg agree i.origin if sector==2 | sector==3 | sector==4 , cl(respondent) 

foreach x of numlist 1(1)6 {
lincom  `x'.origin
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.origin"
matrix resmat = nullmat(resmat) \ coef
}



*count
reg agree i.count if sector==2 | sector==3 | sector==4  , cl(respondent) 

foreach x of numlist 1(1)5 {
lincom  `x'.count
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.count"
matrix resmat = nullmat(resmat) \ coef
}


mat2txt , matrix(resmat) saving("manu_VI.txt") replace
matrix drop resmat

**making graphs

insheet using "manu_VI.txt", clear


gen varname=_n
list


#delimit ;
label define varlab 31 "2 countries" 32 "5 countries" 33 "10 countries" 34 "50 countries" 35 "150 countries" 
25 "EU"  26 "India" 27 "Russia" 28 "Brasil" 29 "China" 30 "US" 
22 "increases prices"  23 "no effect prices"  24 "reduces prices" 
19 "ag less"  20  "ag same" 21 "ag more" 
16 "services less"  17 "services same" 18 "services more"
13 "manufacturing less"  14 "manufacturing same" 15 "manufacturing more" 
10 "reduce environment"  11 "maintain environment"  12 "increase environment" 
7 "reduce worker rights"  8  "maintain worker rights" 9 "increase worker rights" 
6 "high skills yes" 5 "high skill no" 
4 "med skill yes" 3 "med skill no"
2 "low skill yes" 1 "low skill no", replace;
#delimit cr

label values varname varlab
list

 
gen clo=c1-1.96*c2
gen chi=c1+1.96*c2
*list


*edit

#delimit;
graph twoway (rspike clo chi varname, horizontal ytitle("") ylabel(1(1)35, labsize(small) valuelabel angle(0)) xtitle("Change in Pr (Vietnam: Manufacturing)") 
xline(0, lcolor(black))) (scatter varname c1, mcolor(black) msymbol(circle) msize(vsmall) ytitle("")), scheme(s2mono) legend(off);
#delimit cr


graph export "manu_VN.pdf", replace
graph save "manu_VN.gph", replace







*** Employment services


set more off

***Use Data for Vietnam
use "VI_agree_final.dta", clear


capture matrix drop resmat

*low skill
reg agree i.job_low_skills if sector<21, cl(respondent)
foreach x of numlist 1(1)2 {
lincom  `x'.job_low_skills
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.job_low_skills"
matrix resmat = nullmat(resmat) \ coef
}

* med skill
reg agree i.job_med_skills if sector<21, cl(respondent)
foreach x of numlist 1(1)2 {
lincom  `x'.job_med_skills
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.job_med_skills"
matrix resmat = nullmat(resmat) \ coef
}

* high skill
reg agree i.job_high_skills if sector<21, cl(respondent)
foreach x of numlist 1(1)2 {
lincom  `x'.job_high_skills
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'. job_high_skills"
matrix resmat = nullmat(resmat) \ coef
}

*work
reg agree i.work if sector<21, cl(respondent) 

foreach x of numlist 1(1)3 {
lincom  `x'.work 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.work"
matrix resmat = nullmat(resmat) \ coef
}

*Environment
reg agree i.env if sector<21, cl(respondent) 

foreach x of numlist 1(1)3 {
lincom  `x'.env 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.env"
matrix resmat = nullmat(resmat) \ coef
}

*job man
reg agree i.job_man if sector<21, cl(respondent) 

foreach x of numlist 1(1)3 {
lincom  `x'.job_man
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.job_man"
matrix resmat = nullmat(resmat) \ coef
}

*job ser
reg agree i.job_ser if sector<21, cl(respondent) 

foreach x of numlist 1(1)3 {
lincom  `x'.job_ser
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.job_ser"
matrix resmat = nullmat(resmat) \ coef
}

*job ag
reg agree i.job_ag if sector<21, cl(respondent) 

foreach x of numlist 1(1)3 {
lincom  `x'.job_ag
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.job_ag"
matrix resmat = nullmat(resmat) \ coef
}

*price
reg agree i.price if sector<21, cl(respondent) 

foreach x of numlist 1(1)3 {
lincom  `x'.price
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.price"
matrix resmat = nullmat(resmat) \ coef
}

**origin
reg agree i.origin if sector<21, cl(respondent) 

foreach x of numlist 1(1)6 {
lincom  `x'.origin
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.origin"
matrix resmat = nullmat(resmat) \ coef
}



*count
reg agree i.count if sector<21 , cl(respondent) 

foreach x of numlist 1(1)5 {
lincom  `x'.count
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.count"
matrix resmat = nullmat(resmat) \ coef
}


mat2txt , matrix(resmat) saving("serv_VI.txt") replace
matrix drop resmat

**making graphs

insheet using "serv_VI.txt", clear


gen varname=_n
list


#delimit ;
label define varlab 31 "2 countries" 32 "5 countries" 33 "10 countries" 34 "50 countries" 35 "150 countries" 
25 "EU"  26 "India" 27 "Russia" 28 "Brasil" 29 "China" 30 "US" 
22 "increases prices"  23 "no effect prices"  24 "reduces prices" 
19 "ag less"  20  "ag same" 21 "ag more" 
16 "services less"  17 "services same" 18 "services more"
13 "manufacturing less"  14 "manufacturing same" 15 "manufacturing more" 
10 "reduce environment"  11 "maintain environment"  12 "increase environment" 
7 "reduce worker rights"  8  "maintain worker rights" 9 "increase worker rights" 
6 "high skills yes" 5 "high skill no" 
4 "med skill yes" 3 "med skill no"
2 "low skill yes" 1 "low skill no", replace;
#delimit cr

label values varname varlab
list

 
gen clo=c1-1.96*c2
gen chi=c1+1.96*c2
*list


*edit

#delimit;
graph twoway (rspike clo chi varname, horizontal ytitle("") ylabel(1(1)35, labsize(small) valuelabel angle(0)) xtitle("Change in Pr (Vietnam: Services)") 
xline(0, lcolor(black))) (scatter varname c1, mcolor(black) msymbol(circle) msize(vsmall) ytitle("")), scheme(s2mono) legend(off);
#delimit cr


graph export "serv_VN.pdf", replace
graph save "serv_VN.gph", replace


