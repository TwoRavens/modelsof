use "Winner_Trade_high_dataset_new.dta", clear
list
xpose, clear varname
list
gen varname=_n

#delimit;
label define varlab 1 "winner_high_open_low" 2 "winner_low_open_low " 3 "winner_high_open_high" 4 "winner_low_open_high" ;
#delimit cr
label values varname varlab

#delimit;
twoway (rspike v1 v3 varname, horizontal ytitle("") ylabel(1(1)4,valuelabel angle(0)) 
xlabel(.2(.2)1) xtitle("Predicted Probability" )) , scheme(s2mono) legend(off);
#delimit cr
graph export  "Winner_Trade_4_new.pdf", replace


use "Winner_ALM_high_dataset_new.dta", clear
list
xpose, clear varname
list
gen varname=_n

#delimit;
label define varlab 1 "winner_high_alm_low" 2 "winner_low_alm_low " 3 "winner_high_alm_high" 4 "winner_low_alm_high" ;
#delimit cr
label values varname varlab

#delimit;
twoway (rspike v1 v3 varname, horizontal ytitle("") ylabel(1(1)4,valuelabel angle(0)) 
xlabel(.2(.2)1) xtitle("Predicted Probability" )) , scheme(s2mono) legend(off);
#delimit cr
graph export  "Winner_ALM_4_new.pdf", replace




use "income_Trade_high_dataset_new.dta", clear
list
xpose, clear varname
list
gen varname=_n

#delimit;
label define varlab 1 "income_high_open_low" 2 "income_low_open_low " 3 "income_high_open_high" 4 "income_low_open_high" ;
#delimit cr
label values varname varlab

#delimit;
twoway (rspike v1 v3 varname, horizontal ytitle("") ylabel(1(1)4,valuelabel angle(0)) 
xlabel(.2(.2)1) xtitle("Predicted Probability" )) , scheme(s2mono) legend(off);
#delimit cr
graph export  "Income_Trade_4_new.pdf", replace


use "income_ALM_high_dataset_new.dta", clear
list
xpose, clear varname
list
gen varname=_n

#delimit;
label define varlab 1 "income_high_alm_low" 2 "income_low_alm_low " 3 "income_high_alm_high" 4 "income_low_alm_high" ;
#delimit cr
label values varname varlab

#delimit;
twoway (rspike v1 v3 varname, horizontal ytitle("") ylabel(1(1)4,valuelabel angle(0)) 
xlabel(.2(.2)1) xtitle("Predicted Probability" )) , scheme(s2mono) legend(off);
#delimit cr
graph export  "income_ALM_4_new.pdf", replace




use "educ_Trade_high_dataset_new.dta", clear
list
xpose, clear varname
list
gen varname=_n

#delimit;
label define varlab 1 "education_high_open_low" 2 "education_low_open_low " 3 "education_high_open_high" 4 "education_low_open_high" ;
#delimit cr
label values varname varlab

#delimit;
twoway (rspike v1 v3 varname, horizontal ytitle("") ylabel(1(1)4,valuelabel angle(0)) 
xlabel(.2(.2)1) xtitle("Predicted Probability" )) , scheme(s2mono) legend(off);
#delimit cr
graph export  "education_Trade_4_new.pdf", replace




use "educ_ALM_high_dataset_new.dta", clear
list
xpose, clear varname
list
gen varname=_n

#delimit;
label define varlab 1 "education_high_alm_low" 2 "education_low_alm_low " 3 "education_high_alm_high" 4 "education_low_alm_high" ;
#delimit cr
label values varname varlab


#delimit;
twoway (rspike v1 v3 varname, horizontal ytitle("") ylabel(1(1)4,valuelabel angle(0)) 
xlabel(.2(.2)1) xtitle("Predicted Probability" )) 
, scheme(s2mono) legend(off);
#delimit cr
graph export  "education_ALM_4_new.pdf", replace

