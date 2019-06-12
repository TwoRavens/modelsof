***This file imports the LCA data from R

clear
set more off

**Security
insheet using sec_lca_all.csv, comma clear
keep usid date *prob* *class*
tempfile sec
save `sec', replace

**Economic
insheet using econ_lca_all.csv, comma clear
keep usid date *prob* *class*
tempfile econ
save `econ', replace

**Social capital
insheet using soccap_lca_all.csv, comma clear
keep usid date *prob* *class*
tempfile soccap
save `soccap', replace

**State capacity and public goods
insheet using health_lca_all.csv, comma clear
keep usid date *prob* *class*
tempfile health
save `health', replace

**State capacity and public goods
insheet using educ_lca_all.csv, comma clear
keep usid date *prob* *class*
tempfile educ
save `educ', replace

**State capacity and public goods
insheet using admin_lca_all.csv, comma clear
keep usid date *prob* *class*
tempfile admin
save `admin', replace

*merge data together

merge 1:1 usid date using `health'
drop _merge
merge 1:1 usid date using `educ'
drop _merge
merge 1:1 usid date using `soccap'
drop _merge
merge 1:1 usid date using `econ'
drop _merge
merge 1:1 usid date using `sec'
drop _merge

*give vars shorter names
foreach V in health educ admin soccap econ sec {
	rename `V'_prob2_1 `V'_p1
	rename `V'_prob2_2 `V'_p2
	rename `V'_class_2 `V'_c
}

*destring date variable
split date, p(m)
destring date1 date2, replace
g mdate=ym(date1, date2) 
format mdate %tm
rename date1 yr
rename date2 mth
drop date
rename mdate date

**Create a quarter variable
*quarters
g q=.
replace q=1 if (mth==1 | mth==2 | mth==3)
replace q=2 if (mth==4 | mth==5 | mth==6)
replace q=3 if (mth==7 | mth==8 | mth==9)
replace q=4 if (mth==10 | mth==11 | mth==12)
	
g qdate=yq(yr, q)
format qdate %tq

*make so p1 is probability of being in high (good) group
drop econ_p1
rename econ_p2 econ_p1

drop health_p1
rename health_p2 health_p1

drop admin_p1
rename admin_p2 admin_p1

drop soccap_p1
rename soccap_p2 soccap_p1

tempfile lca_all
save `lca_all', replace

**Collapse to quarterly level
collapse (mean) admin_p1-sec_c, by(usid qdate)
save lca_q_all, replace

**Marines only until they withdraw
use `lca_all', clear
keep if date<=ym(1971, 3)

collapse (mean) admin_p1-sec_c, by(usid)
save lca_marines_all6971, replace



