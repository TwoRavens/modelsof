***Analysis Vietnam

**load dataset
use "Vietnam.dta", clear



**** forced choice
***results using linear estimator as suggested by Hainmueller et al.
** AMCEs: forced choice outcome with differences in means estimator (attribute by attribute)



*labor standards
reg country i.labor, cl(respondent) 

foreach x of numlist 1(1)3 {
lincom  `x'.labor 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.labor"
matrix resmat = nullmat(resmat) \ coef
}

*environmental standards
reg country i.env, cl(respondent) 

foreach x of numlist 1(1)3 {
lincom  `x'.env
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.env"
matrix resmat = nullmat(resmat) \ coef
}
*alliance
reg country i.military, cl(respondent) 
foreach x of numlist 1(1)2 {
lincom  `x'.military 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.military"
matrix resmat = nullmat(resmat) \ coef
}
*democracy
reg country i.democracy, cl(respondent) 
foreach x of numlist 1(1)3 {
lincom  `x'.democracy 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.democracy"
matrix resmat = nullmat(resmat) \ coef
}

*religion
reg country i.religion, cl(respondent)
foreach x of numlist 1(1)4 {
lincom  `x'.religion 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.religion"
matrix resmat = nullmat(resmat) \ coef
}
*Culture (lunar year)
reg country i.culture, cl(respondent) 

foreach x of numlist 1(1)2 {
lincom  `x'.culture 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.culture"
matrix resmat = nullmat(resmat) \ coef
}

*economy size
reg country i.econ_size, cl(respondent)
foreach x of numlist 1(1)3 {
lincom  `x'.econ_size
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.econ_size"
matrix resmat = nullmat(resmat) \ coef
}
*distance
reg country i.distance, cl(respondent)
foreach x of numlist 1(1)3 {
lincom  `x'.distance 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.distance"
matrix resmat = nullmat(resmat) \ coef
}


mat2txt , matrix(resmat) saving("Vietnam.txt") replace
matrix drop resmat


**graph
set more off
clear
insheet using "Vietnam.txt",  clear


gen varname=_n
list


#delimit;
label define varlab 
1"Lower labor standards" 2 "Similar labor standards" 3 "Higher labor standards"
4 "Lower environmental standards" 5 "Similar environmental standards" 6 "Higher environmental standards"
7 "Military ally" 8 "No military ally" 
9 "Autocratic" 10 "Semi-democratic" 11 "Democratic"
12 "Islam" 13 "Christian" 14 "Diverse" 15 "Buddhism"
16 "Same culture" 17 "Different culture" 
18 "Smaller econonomic size" 19 "Same economic size" 20 "Larger economic size"
21 "1 000 km" 22 "5 000 km" 23 "10 000 km" ;

#delimit cr

label values varname varlab
list

 
gen clo=c1-1.96*c2
gen chi=c1+1.96*c2

list

 

#delimit;
twoway (rspike clo chi varname, horizontal ytitle("") ylabel(1(1)23,valuelabel angle(0)) xlabel(-.1(.1).3) xtitle("Change in Pr (Country preferred as partner)") 
xline(0, lcolor(black))) (scatter varname c1, mcolor(black) msymbol(circle) msize(small) ytitle("")), legend(off) scheme(s2mono);
#delimit cr

graph export "Vietnam_choice.pdf", replace







***Figure 2: overall support
use "Nicaragua.dta", clear
hist like, percent xlabel(1(1)7) ylabel(0(5)25) scheme(s2mono) xtitle("Support PTA with this partner 1-7 (1 no support)")

graph save "NICARAGUA_support.gph", replace







***Figure 3 - best and worst case scenario

**** Single model regression
***results using linear estimator as suggested by Hainmueller et al.
** AMCEs: rating outcome with differences in means estimator (single model regression)


use "Vietnam.dta", clear


  #delimit;
regress like2 lab_sim lab_stro env_sim env_stro no_alli sem_dem dem rel_div rel_bud
rel_chri cult_dif econ_size_sim econ_size_large short middle, cl(respondent);
  #delimit cr

**since worst case does not exist, we need to create one more observation that looks like this
set obs `=_N + 1'

replace lab_sim=0 in 7001
replace lab_stro=0 in 7001
replace lab_weak=1 in 7001
replace env_sim=0 in 7001
replace env_stro=0 in 7001
replace env_weak=1 in 7001
replace econ_size_sim=0 in 7001
replace econ_size_large=0 in 7001
replace econ_size_sma=1 in 7001
replace no_alli=1 in 7001
replace alliance=0 in 7001
replace no_dem=1 in 7001
replace sem_dem=0 in 7001
replace dem=0 in 7001
replace rel_div=0 in 7001
replace rel_chri=0 in 7001
replace rel_bud=0 in 7001
replace islam=1 in 7001
replace cult_dif=1 in 7001
replace cult_sim=0 in 7001
replace short=0 in 7001
replace middle=0 in 7001
replace far=1 in 7001




***predicted values

predict like3, xb



summ like3
**worst case
*Here the country is relatively far away (more than 10 000 km), is a small economy, 
*has lower labor and environmental standards, is not a military ally and not a democracy
*Islam predominant religion, and the country is not culturally similar 
*(language for Costa Rica and Nicaragua, or does not celebrate Lunar Year, for Vietnam).
  
  #delimit;
  sum like3 if lab_sim==0 & lab_stro==0 & env_sim==0 & env_stro==0 & econ_size_sim==0 & rel_bud==0
  & econ_size_large==0 & no_alli==1 & sem_dem==0 & dem==0 & rel_div==0 &
  rel_chri==0 & cult_dif==1 & short==0 & middle==0;
  #delimit cr
 
   **best case
  *Here the potential trade partner is relatively close by (less than 1 000 km away), 
  *is a large economy, has stronger environmental and labor standards, is a military ally and a democracy, 
  *Christianity (Buddhism for Vietnam) is the predominant religion, and the country is culturally similar 
  *(language for Costa Rica and Nicaragua, or Lunar Year celebration for Vietnam

  #delimit;
  sum like3 if lab_sim==0 & lab_stro==1 & env_sim==0 & env_stro==1 & econ_size_sim==0 & rel_bud==1
  & econ_size_large==1 & no_alli==0 & sem_dem==0 & dem==1 & rel_div==0 &
  rel_chri==0 & cult_dif==0 & short==1 & middle==0;
  #delimit cr
 


predict sylike3, stdp
gen lowerpred=like3-1.96*sylike3
gen upperpred=like3+1.96*sylike3

*worst case
#delimit;
summ upperpred lowerpred if lab_sim==0 & lab_stro==0 & env_sim==0 & env_stro==0 & econ_size_sim==0
  & econ_size_large==0 & no_alli==1 & sem_dem==0 & dem==0 & rel_div==0 & rel_bud==0 &
  rel_chri==0 & cult_dif==1 & short==0 & middle==0;
  #delimit cr

  *best case
#delimit;
summ upperpred lowerpred if lab_sim==0 & lab_stro==1 & env_sim==0 & env_stro==1 & econ_size_sim==0
  & econ_size_large==1 & no_alli==0 & sem_dem==0 & dem==1 & rel_div==0 &
  rel_bud==1 & rel_chri==0 & cult_dif==0 & short==1 & middle==0;
  #delimit cr

***These numbers are saved in Excel File "Scenarios"




*********Supplementary Material********************************************




**** rating task
***results using linear estimator as suggested by Hainmueller et al.
** AMCEs: rating outcome with differences in means estimator (attribute by attribute)

use "Vietnam.dta", clear



capture matrix drop resmat

*labor standards
reg like2 i.labor, cl(respondent) 

foreach x of numlist 1(1)3 {
lincom  `x'.labor 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.labor"
matrix resmat = nullmat(resmat) \ coef
}

*environmental standards
reg like2 i.env, cl(respondent) 

foreach x of numlist 1(1)3 {
lincom  `x'.env
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.env"
matrix resmat = nullmat(resmat) \ coef
}
*alliance
reg like2 i.military, cl(respondent) 
foreach x of numlist 1(1)2 {
lincom  `x'.military 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.military"
matrix resmat = nullmat(resmat) \ coef
}
*democracy
reg like2 i.democracy, cl(respondent) 
foreach x of numlist 1(1)3 {
lincom  `x'.democracy 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.democracy"
matrix resmat = nullmat(resmat) \ coef
}

*religion
reg like2 i.religion, cl(respondent)
foreach x of numlist 1(1)4 {
lincom  `x'.religion 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.religion"
matrix resmat = nullmat(resmat) \ coef
}
*Culture (lunar year)
reg like2 i.culture, cl(respondent) 

foreach x of numlist 1(1)2 {
lincom  `x'.culture 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.culture"
matrix resmat = nullmat(resmat) \ coef
}

*economy size
reg like2 i.econ_size, cl(respondent)
foreach x of numlist 1(1)3 {
lincom  `x'.econ_size
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.econ_size"
matrix resmat = nullmat(resmat) \ coef
}
*distance
reg like2 i.distance, cl(respondent)
foreach x of numlist 1(1)3 {
lincom  `x'.distance 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.distance"
matrix resmat = nullmat(resmat) \ coef
}



mat2txt , matrix(resmat) saving("Vietnam_like.txt") replace
matrix drop resmat


**graph

insheet using "Vietnam_like.txt",  clear


gen varname=_n
list


#delimit;
label define varlab 
1"Lower labor standards" 2 "Similar labor standards" 3 "Higher labor standards"
4 "Lower environmental standards" 5 "Similar environmental standards" 6 "Higher environmental standards"
7 "Military ally" 8 "No military ally" 
9 "Autocratic" 10 "Semi-democratic" 11 "Democratic"
12 "Islam" 13 "Christian" 14 "Diverse" 15 "Buddhism"
16 "Same culture" 17 "Different culture" 
18 "Smaller econonomic size" 19 "Same economic size" 20 "Larger economic size"
21 "1 000 km" 22 "5 000 km" 23 "10 000 km" ;
#delimit cr

label values varname varlab
list

 
gen clo=c1-1.96*c2
gen chi=c1+1.96*c2

 

#delimit;
twoway (rspike clo chi varname, horizontal ytitle("") ylabel(1(1)23,valuelabel angle(0)) xtitle("Change in Pr (Country preference rate task)") 
xline(0, lcolor(black))) (scatter varname c1, mcolor(black) msymbol(circle) msize(small) ytitle("")), legend(off);
#delimit cr


graph export "Vietnam_like.pdf", replace




**** forced choice education low
***results using linear estimator as suggested by Hainmueller et al.
** AMCEs: forced choice with differences in means estimator (attribute by attribute)


use "Vietnam.dta", clear

sum education,d

*labor standards
reg country i.labor if education<6, cl(respondent) 

foreach x of numlist 1(1)3 {
lincom  `x'.labor 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.labor"
matrix resmat = nullmat(resmat) \ coef
}

*environmental standards
reg country i.env if education<6, cl(respondent) 

foreach x of numlist 1(1)3 {
lincom  `x'.env
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.env"
matrix resmat = nullmat(resmat) \ coef
}
*alliance
reg country i.military if education<6, cl(respondent) 
foreach x of numlist 1(1)2 {
lincom  `x'.military 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.military"
matrix resmat = nullmat(resmat) \ coef
}
*democracy
reg country i.democracy if education<6, cl(respondent) 
foreach x of numlist 1(1)3 {
lincom  `x'.democracy 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.democracy"
matrix resmat = nullmat(resmat) \ coef
}

*religion
reg country i.religion if education<6, cl(respondent)
foreach x of numlist 1(1)4 {
lincom  `x'.religion 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.religion"
matrix resmat = nullmat(resmat) \ coef
}
*Culture (lunar year)
reg country i.culture if education<6, cl(respondent) 

foreach x of numlist 1(1)2 {
lincom  `x'.culture 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.culture"
matrix resmat = nullmat(resmat) \ coef
}

*economy size
reg country i.econ_size if education<6, cl(respondent)
foreach x of numlist 1(1)3 {
lincom  `x'.econ_size
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.econ_size"
matrix resmat = nullmat(resmat) \ coef
}
*distance
reg country i.distance if education<6, cl(respondent)
foreach x of numlist 1(1)3 {
lincom  `x'.distance 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.distance"
matrix resmat = nullmat(resmat) \ coef
}

mat2txt , matrix(resmat) saving("Vietnam_educaction_low.txt") replace
matrix drop resmat


**graph

insheet using "Vietnam_educaction_low.txt",  clear


gen varname=_n
list


#delimit;
label define varlab_viet 
1"Lower labor standards" 2 "Similar labor standards" 3 "Higher labor standards"
4 "Lower environmental standards" 5 "Similar environmental standards" 6 "Higher environmental standards"
7 "Military ally" 8 "No military ally" 
9 "Autocratic" 10 "Semi-democratic" 11 "Democratic"
12 "Islam" 13 "Christian" 14 "Diverse" 15 "Buddhism"
16 "Same culture" 17 "Different culture" 
18 "Smaller econonomic size" 19 "Same economic size" 20 "Larger economic size"
21 "1 000 km" 22 "5 000 km" 23 "10 000 km" ;
#delimit cr
label values varname varlab_viet
list

 
gen clo=c1-1.96*c2
gen chi=c1+1.96*c2

 

#delimit;
twoway (rspike clo chi varname, horizontal ytitle("") ylabel(1(1)23,valuelabel angle(0)) xlabel(-.1(.1).3) xtitle("Change in Pr (Country preferred as partner)") 
xline(0, lcolor(black))) (scatter varname c1, mcolor(black) msymbol(circle) msize(small) ytitle("")), title(No college) legend(off);
#delimit cr


graph export "Vietnam_educaction_low.pdf", replace





**** forced choice education high
***results using linear estimator as suggested by Hainmueller et al.
** AMCEs: forced choice with differences in means estimator (attribute by attribute)


use "Vietnam.dta", clear

sum education,d

*labor standards
reg country i.labor if education>5, cl(respondent) 

foreach x of numlist 1(1)3 {
lincom  `x'.labor 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.labor"
matrix resmat = nullmat(resmat) \ coef
}

*environmental standards
reg country i.env if education>5, cl(respondent) 

foreach x of numlist 1(1)3 {
lincom  `x'.env
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.env"
matrix resmat = nullmat(resmat) \ coef
}
*alliance
reg country i.military if education>5, cl(respondent) 
foreach x of numlist 1(1)2 {
lincom  `x'.military 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.military"
matrix resmat = nullmat(resmat) \ coef
}
*democracy
reg country i.democracy if education>5, cl(respondent) 
foreach x of numlist 1(1)3 {
lincom  `x'.democracy 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.democracy"
matrix resmat = nullmat(resmat) \ coef
}

*religion
reg country i.religion if education>5, cl(respondent)
foreach x of numlist 1(1)4 {
lincom  `x'.religion 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.religion"
matrix resmat = nullmat(resmat) \ coef
}
*Culture (lunar year)
reg country i.culture if education>5, cl(respondent) 

foreach x of numlist 1(1)2 {
lincom  `x'.culture 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.culture"
matrix resmat = nullmat(resmat) \ coef
}

*economy size
reg country i.econ_size if education>5, cl(respondent)
foreach x of numlist 1(1)3 {
lincom  `x'.econ_size
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.econ_size"
matrix resmat = nullmat(resmat) \ coef
}
*distance
reg country i.distance if education>5, cl(respondent)
foreach x of numlist 1(1)3 {
lincom  `x'.distance 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.distance"
matrix resmat = nullmat(resmat) \ coef
}


mat2txt , matrix(resmat) saving("Vietnam_educaction_high.txt") replace
matrix drop resmat


**graph

insheet using "Vietnam_educaction_high.txt",  clear


gen varname=_n
list


#delimit;
label define varlab_viet 
1"Lower labor standards" 2 "Similar labor standards" 3 "Higher labor standards"
4 "Lower environmental standards" 5 "Similar environmental standards" 6 "Higher environmental standards"
7 "Military ally" 8 "No military ally" 
9 "Autocratic" 10 "Semi-democratic" 11 "Democratic"
12 "Islam" 13 "Christian" 14 "Diverse" 15 "Buddhism"
16 "Same culture" 17 "Different culture" 
18 "Smaller econonomic size" 19 "Same economic size" 20 "Larger economic size"
21 "1 000 km" 22 "5 000 km" 23 "10 000 km" ;

#delimit cr


label values varname varlab_viet
list

 
gen clo=c1-1.96*c2
gen chi=c1+1.96*c2

 

#delimit;
twoway (rspike clo chi varname, horizontal ytitle("") ylabel(1(1)23,valuelabel angle(0)) xlabel(-.1(.1).3) xtitle("Change in Pr (Country preferred as partner)") 
xline(0, lcolor(black))) (scatter varname c1, mcolor(black) msymbol(circle) msize(small) ytitle("")), title(College) legend(off);
#delimit cr


graph export "Vietnam_educaction_high.pdf", replace








**** forced choice income high
***results using linear estimator as suggested by Hainmueller et al.
** AMCEs: forced choice with differences in means estimator (attribute by attribute)


use "Vietnam.dta", clear


*labor standards
reg country i.labor if income>2, cl(respondent) 

foreach x of numlist 1(1)3 {
lincom  `x'.labor 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.labor"
matrix resmat = nullmat(resmat) \ coef
}

*environmental standards
reg country i.env if income>2, cl(respondent) 

foreach x of numlist 1(1)3 {
lincom  `x'.env
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.env"
matrix resmat = nullmat(resmat) \ coef
}
*alliance
reg country i.military if income>2, cl(respondent) 
foreach x of numlist 1(1)2 {
lincom  `x'.military 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.military"
matrix resmat = nullmat(resmat) \ coef
}
*democracy
reg country i.democracy if income>2, cl(respondent) 
foreach x of numlist 1(1)3 {
lincom  `x'.democracy 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.democracy"
matrix resmat = nullmat(resmat) \ coef
}

*religion
reg country i.religion if income>2, cl(respondent)
foreach x of numlist 1(1)4 {
lincom  `x'.religion 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.religion"
matrix resmat = nullmat(resmat) \ coef
}
*Culture (lunar year)
reg country i.culture if income>2, cl(respondent) 

foreach x of numlist 1(1)2 {
lincom  `x'.culture 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.culture"
matrix resmat = nullmat(resmat) \ coef
}

*economy size
reg country i.econ_size if income>2, cl(respondent)
foreach x of numlist 1(1)3 {
lincom  `x'.econ_size
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.econ_size"
matrix resmat = nullmat(resmat) \ coef
}
*distance
reg country i.distance if income>2, cl(respondent)
foreach x of numlist 1(1)3 {
lincom  `x'.distance 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.distance"
matrix resmat = nullmat(resmat) \ coef
}



mat2txt , matrix(resmat) saving("Vietnam_income_high.txt") replace
matrix drop resmat


**graph

insheet using "Vietnam_income_high.txt",  clear


gen varname=_n
list


#delimit;
label define varlab 
1"Lower labor standards" 2 "Similar labor standards" 3 "Higher labor standards"
4 "Lower environmental standards" 5 "Similar environmental standards" 6 "Higher environmental standards"
7 "ally" 8 "not ally" 
9 "autocratic" 10 "semi-democratic" 11 "democracy"
12 "Islam" 13 "Christian" 14 "Diverse" 15 "Buddhism"
16 "same culture" 17 "dif culture" 
18 "Smaller econonomic size" 19 "Same economic size" 20 "Larger economic size"
21 "1 000 km" 22 "5 000 km" 23 "10 000 km" ;

#delimit cr
label values varname varlab
list

 
gen clo=c1-1.96*c2
gen chi=c1+1.96*c2

 

#delimit;
twoway (rspike clo chi varname, horizontal ytitle("") ylabel(1(1)23,valuelabel angle(0)) xlabel(-.1(.1).3) xtitle("Change in Pr (Country preferred as partner)") 
xline(0, lcolor(black))) (scatter varname c1, mcolor(black) msymbol(circle) msize(small) ytitle("")), legend(off);
#delimit cr

graph export "Vietnam_income_high.pdf", replace




**** forced choice income low
***results using linear estimator as suggested by Hainmueller et al.
** AMCEs: forced choice with differences in means estimator (attribute by attribute)



use "Vietnam.dta", clear

*labor standards
reg country i.labor if income<3, cl(respondent) 

foreach x of numlist 1(1)3 {
lincom  `x'.labor 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.labor"
matrix resmat = nullmat(resmat) \ coef
}

*environmental standards
reg country i.env if income<3, cl(respondent) 

foreach x of numlist 1(1)3 {
lincom  `x'.env
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.env"
matrix resmat = nullmat(resmat) \ coef
}
*alliance
reg country i.military if income<3, cl(respondent) 
foreach x of numlist 1(1)2 {
lincom  `x'.military 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.military"
matrix resmat = nullmat(resmat) \ coef
}
*democracy
reg country i.democracy if income<3, cl(respondent) 
foreach x of numlist 1(1)3 {
lincom  `x'.democracy 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.democracy"
matrix resmat = nullmat(resmat) \ coef
}

*religion
reg country i.religion if income<3, cl(respondent)
foreach x of numlist 1(1)4 {
lincom  `x'.religion 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.religion"
matrix resmat = nullmat(resmat) \ coef
}
*Culture (lunar year)
reg country i.culture if income<3, cl(respondent) 

foreach x of numlist 1(1)2 {
lincom  `x'.culture 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.culture"
matrix resmat = nullmat(resmat) \ coef
}

*economy size
reg country i.econ_size if income<3, cl(respondent)
foreach x of numlist 1(1)3 {
lincom  `x'.econ_size
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.econ_size"
matrix resmat = nullmat(resmat) \ coef
}
*distance
reg country i.distance if income<3, cl(respondent)
foreach x of numlist 1(1)3 {
lincom  `x'.distance 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.distance"
matrix resmat = nullmat(resmat) \ coef
}


mat2txt , matrix(resmat) saving("Vietnam_income_low.txt") replace
matrix drop resmat


**graph

insheet using "Vietnam_income_low.txt",  clear


gen varname=_n
list


#delimit;
label define varlab 
1"Lower labor standards" 2 "Similar labor standards" 3 "Higher labor standards"
4 "Lower environmental standards" 5 "Similar environmental standards" 6 "Higher environmental standards"
7 "Military ally" 8 "No military ally" 
9 "Autocratic" 10 "Semi-democratic" 11 "Democratic"
12 "Islam" 13 "Christian" 14 "Diverse" 15 "Buddhism"
16 "Same culture" 17 "Different culture" 
18 "Smaller econonomic size" 19 "Same economic size" 20 "Larger economic size"
21 "1 000 km" 22 "5 000 km" 23 "10 000 km" ;

#delimit cr
label values varname varlab
list

 
gen clo=c1-1.96*c2
gen chi=c1+1.96*c2

 

#delimit;
twoway (rspike clo chi varname, horizontal ytitle("") ylabel(1(1)23,valuelabel angle(0)) xlabel(-.1(.1).3) xtitle("Change in Pr (Country preferred as partner)") 
xline(0, lcolor(black))) (scatter varname c1, mcolor(black) msymbol(circle) msize(small) ytitle("")), legend(off);
#delimit cr

graph export "Vietnam_income_low.pdf", replace



**** forced choice salience high
***results using linear estimator as suggested by Hainmueller et al.
** AMCEs: rating outcome with differences in means estimator (attribute by attribute)


use "Vietnam.dta", clear

*labor standards
reg country i.labor if salience==1, cl(respondent) 

foreach x of numlist 1(1)3 {
lincom  `x'.labor 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.labor"
matrix resmat = nullmat(resmat) \ coef
}

*environmental standards
reg country i.env if salience==1, cl(respondent) 

foreach x of numlist 1(1)3 {
lincom  `x'.env
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.env"
matrix resmat = nullmat(resmat) \ coef
}
*alliance
reg country i.military if salience==1, cl(respondent) 
foreach x of numlist 1(1)2 {
lincom  `x'.military 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.military"
matrix resmat = nullmat(resmat) \ coef
}
*democracy
reg country i.democracy if salience==1, cl(respondent) 
foreach x of numlist 1(1)3 {
lincom  `x'.democracy 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.democracy"
matrix resmat = nullmat(resmat) \ coef
}

*religion
reg country i.religion if salience==1, cl(respondent)
foreach x of numlist 1(1)4 {
lincom  `x'.religion 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.religion"
matrix resmat = nullmat(resmat) \ coef
}
*Culture (lunar year)
reg country i.culture if salience==1, cl(respondent) 

foreach x of numlist 1(1)2 {
lincom  `x'.culture 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.culture"
matrix resmat = nullmat(resmat) \ coef
}

*economy size
reg country i.econ_size if salience==1, cl(respondent)
foreach x of numlist 1(1)3 {
lincom  `x'.econ_size
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.econ_size"
matrix resmat = nullmat(resmat) \ coef
}
*distance
reg country i.distance if salience==1, cl(respondent)
foreach x of numlist 1(1)3 {
lincom  `x'.distance 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.distance"
matrix resmat = nullmat(resmat) \ coef
}


mat2txt , matrix(resmat) saving("Vietnam_salience_high.txt") replace
matrix drop resmat


**graph

insheet using "Vietnam_salience_high.txt",  clear


gen varname=_n
list

#delimit;
label define varlab 
1"Lower labor standards" 2 "Similar labor standards" 3 "Higher labor standards"
4 "Lower environmental standards" 5 "Similar environmental standards" 6 "Higher environmental standards"
7 "Military ally" 8 "No military ally" 
9 "Autocratic" 10 "Semi-democratic" 11 "Democratic"
12 "Islam" 13 "Christian" 14 "Diverse" 15 "Buddhism"
16 "Same culture" 17 "Different culture" 
18 "Smaller econonomic size" 19 "Same economic size" 20 "Larger economic size"
21 "1 000 km" 22 "5 000 km" 23 "10 000 km" ;

#delimit cr
label values varname varlab
list

 
gen clo=c1-1.96*c2
gen chi=c1+1.96*c2

 

#delimit;
twoway (rspike clo chi varname, horizontal ytitle("") ylabel(1(1)23,valuelabel angle(0)) xlabel(-.1(.1).3) xtitle("Change in Pr (Country preferred as partner)") 
xline(0, lcolor(black))) (scatter varname c1, mcolor(black) msymbol(circle) msize(small) ytitle("")), legend(off);
#delimit cr

graph export "Vietnam_salience_high.pdf", replace



**** forced choice salience low
***results using linear estimator as suggested by Hainmueller et al.
** AMCEs: rating outcome with differences in means estimator (attribute by attribute)
*for all variables without restrictions

use "Vietnam.dta", clear

*labor standards
reg country i.labor if salience>1, cl(respondent) 

foreach x of numlist 1(1)3 {
lincom  `x'.labor 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.labor"
matrix resmat = nullmat(resmat) \ coef
}

*environmental standards
reg country i.env if salience>1, cl(respondent) 

foreach x of numlist 1(1)3 {
lincom  `x'.env
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.env"
matrix resmat = nullmat(resmat) \ coef
}
*alliance
reg country i.military if salience>1, cl(respondent) 
foreach x of numlist 1(1)2 {
lincom  `x'.military 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.military"
matrix resmat = nullmat(resmat) \ coef
}
*democracy
reg country i.democracy if salience>1, cl(respondent) 
foreach x of numlist 1(1)3 {
lincom  `x'.democracy 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.democracy"
matrix resmat = nullmat(resmat) \ coef
}

*religion
reg country i.religion if salience>1, cl(respondent)
foreach x of numlist 1(1)4 {
lincom  `x'.religion 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.religion"
matrix resmat = nullmat(resmat) \ coef
}
*Culture (lunar year)
reg country i.culture if salience>1, cl(respondent) 

foreach x of numlist 1(1)2 {
lincom  `x'.culture 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.culture"
matrix resmat = nullmat(resmat) \ coef
}

*economy size
reg country i.econ_size if salience>1, cl(respondent)
foreach x of numlist 1(1)3 {
lincom  `x'.econ_size
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.econ_size"
matrix resmat = nullmat(resmat) \ coef
}
*distance
reg country i.distance if salience>1, cl(respondent)
foreach x of numlist 1(1)3 {
lincom  `x'.distance 
mat    coef = r(estimate) , r(se)
matrix rownames coef = 	"`x'.distance"
matrix resmat = nullmat(resmat) \ coef
}


mat2txt , matrix(resmat) saving("Vietnam_salience_low.txt") replace
matrix drop resmat


**graph

insheet using "Vietnam_salience_low.txt",  clear


gen varname=_n
list


#delimit;
label define varlab 
1"Lower labor standards" 2 "Similar labor standards" 3 "Higher labor standards"
4 "Lower environmental standards" 5 "Similar environmental standards" 6 "Higher environmental standards"
7 "Military ally" 8 "No military ally" 
9 "Autocratic" 10 "Semi-democratic" 11 "Democratic"
12 "Islam" 13 "Christian" 14 "Diverse" 15 "Buddhism"
16 "Same culture" 17 "Different culture" 
18 "Smaller econonomic size" 19 "Same economic size" 20 "Larger economic size"
21 "1 000 km" 22 "5 000 km" 23 "10 000 km" ;

#delimit cr
label values varname varlab
list

 
gen clo=c1-1.96*c2
gen chi=c1+1.96*c2

 

#delimit;
twoway (rspike clo chi varname, horizontal ytitle("") ylabel(1(1)23,valuelabel angle(0)) xlabel(-.1(.1).3) xtitle("Change in Pr (Country preferred as partner)") 
xline(0, lcolor(black))) (scatter varname c1, mcolor(black) msymbol(circle) msize(small) ytitle("")), legend(off);
#delimit cr

graph export "Vietnam_salience_low.pdf", replace
