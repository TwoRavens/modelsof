**CREATE TABLES 8,13,14

**BENCHMARK MNE SURVEY ANALYSIS**

 /* set data directory */
global filepath "DIRECTORY MASKED"

*************************
*EXTRACT WAGES AND BENEFITS IN BENCHMARK SURVEY YEARS
*1989 db
clear
odbc load, table("11A89RF") dsn("be11_1989")
rename ind_sic sic_ind
gen period_year=1989
rename period_year year
keep us_id year emp_benefits wages_salaries emp
destring us_id, replace
sort us_id
save "$filepath\wages_benefits_89.dta", replace
*1994 db
clear
odbc load if (version=="r" & period_year==1994), table("be10_rep_data4") dsn("sqlprodb_2008") dialog(required)
insheet using "$filepath\1994_wages_benes.csv"
rename period_year year
keep us_id year emp_benefits wages_salaries emp
destring us_id, replace
sort us_id
save "$filepath\wages_benefits_94.dta", replace
**LOADS 1999 and 2004
clear
odbc load if (version=="r" & [period_year==1999|period_year==2004]), table("be10_rep_misc") dsn("sqlprodb_2008") dialog(required)
insheet using "$filepath\1999_wages_benes.csv"
destring emp us_id, replace
rename period_year year
keep us_id year emp_benefits wages_salaries emp
sort us_id 
save "$filepath\wages_benefits_99.dta", replace
*2004
clear
insheet using "$filepath\2004_wages_benes.csv"
destring emp us_id, replace
rename period_year year
keep us_id year emp_benefits wages_salaries emp
sort us_id 
save "$filepath\wages_benefits_04.dta", replace
**
*NOW APPEND ALL WAGES_BENES DBS
append using "$filepath\wages_benefits_99.dta"
append using "$filepath\wages_benefits_94.dta"
append using "$filepath\wages_benefits_89.dta"
sort us_id year
save "$filepath\wages_benefits_89_94_99_04.dta", replace
****************************************

**START HERE FOR BENCHMARK ANALYSIS
clear
use "$filepath\unions_with_us_ids.dta"
sort us_id year
*tab year if _merge==3
*browse us_id year type votes_for vote_share outcome numberelig emp emp_compen naics_id sic_ind net_income
replace outcome = "WON" if votes_for>votes_against & year>=2009
replace outcome = "LOST" if votes_for<=votes_against & year>=2009 & votes_for!=.
gen win=1 if outcome=="WON" & type=="RC"
replace win=0 if outcome=="LOST" & type=="RC"
replace win=0 if outcome=="WON" & type=="RD"
replace win=1 if outcome=="LOST" & type=="RD"
keep if year>=1983
keep if type==""|type=="RC"|type=="RD"
sort us_id year
**MERGE WITH BENCHMARK YEAR WAGES AND BENEFITS DATA**
merge m:1 us_id year using "$filepath\wages_benefits_89_94_99_04.dta", update replace
gen wages_per = wages/emp
gen benes_per = emp_benefits/emp
sort us_id year
gen election=1 if win!=.
replace election= 0 if election!=1
sort us_id year
by us_id, sort: gen tot_elec = sum(election)
by us_id, sort: gen total_elec = tot_elec[_N]
by us_id, sort: gen tot_win = sum(win)
by us_id, sort: gen total_win = tot_win[_N]
gen ever_elec = 1 if total_elec>0
replace ever_elec=0 if total_elec==0
gen benes_share = benes_per/(wages_per + benes_per)
summ benes_share if ever_elec==1
summ benes_share if ever_elec==0
gen large = emp>=9270

*TABLE 13 
reg benes_share ever_elec, cluster(us_id)
reg benes_share ever_elec large i.year, cluster(us_id)
reg benes_share ever_elec large i.year i.indus, cluster(us_id)
reg benes_share ever_elec large i.year##i.indus, cluster(us_id)

*ADJUST FOR INFLATION (base year= 2016)
gen cpi = 37.875 if year==1981
replace cpi = 40.208 if year==1982
replace cpi = 41.5 if year==1983
replace cpi = 43.29 if year==1984
replace cpi = 44.83 if year==1985
replace cpi = 45.67 if year==1986
replace cpi = 47.33 if year==1987
replace cpi = 49.29 if year==1988
replace cpi = 51.67 if year==1989
replace cpi = 54.46 if year==1990
replace cpi = 56.75 if year==1991
replace cpi = 58.46 if year==1992
replace cpi = 60.21 if year==1993
replace cpi = 61.75 if year==1994
replace cpi = 63.5 if year==1995
replace cpi = 65.375 if year==1996
replace cpi = 66.875 if year==1997
replace cpi = 67.92 if year==1998
replace cpi = 69.42 if year==1999
replace cpi = 71.75 if year==2000
replace cpi = 73.792 if year==2001
replace cpi = 74.96 if year==2002
replace cpi = 76.67 if year==2003
replace cpi = 78.71 if year==2004
replace cpi = 81.375 if year==2005
replace cpi = 84 if year==2006
replace cpi = 86.375 if year==2007
replace cpi = 89.71 if year==2008
replace cpi = 89.375 if year==2009
replace cpi = 90.875 if year==2010
replace cpi = 93.71 if year==2011
replace cpi = 95.67 if year==2012
replace cpi = 97.08 if year==2013
replace cpi = 98.625 if year==2014
replace cpi = 98.75 if year==2015
replace cpi = 100 if year==2016

gen p = cpi/100

gen wages_per_def = wages_per/p
gen benes_per_def = benes_per/p

gen wages_per_def_89 = wages_per_def if year==1989
gen wages_per_def_94 = wages_per_def if year==1994
gen wages_per_def_99 = wages_per_def if year==1999
gen wages_per_def_04 = wages_per_def if year==2004
gen benes_per_def_89 = benes_per_def if year==1989
gen benes_per_def_94 = benes_per_def if year==1994
gen benes_per_def_99 = benes_per_def if year==1999
gen benes_per_def_04 = benes_per_def if year==2004
by us_id, sort: egen wages_perdef89 = max(wages_per_def_89)
by us_id, sort: egen wages_perdef94 = max(wages_per_def_94)
by us_id, sort: egen wages_perdef99 = max(wages_per_def_99)
by us_id, sort: egen wages_perdef04 = max(wages_per_def_04)
by us_id, sort: egen benes_perdef89 = max(benes_per_def_89)
by us_id, sort: egen benes_perdef94 = max(benes_per_def_94)
by us_id, sort: egen benes_perdef99 = max(benes_per_def_99)
by us_id, sort: egen benes_perdef04 = max(benes_per_def_04)

gen emp_89 = emp if year==1989
gen emp_94 = emp if year==1994
gen emp_99 = emp if year==1999
gen emp_04 = emp if year==2004

by us_id, sort: egen emp89 = max(emp_89)
by us_id, sort: egen emp94 = max(emp_94)
by us_id, sort: egen emp99 = max(emp_99)
by us_id, sort: egen emp04 = max(emp_04)

by us_id, sort: gen next_emp = emp94 if year>=1990&year<=1993
by us_id, sort: gen prior_emp = emp89 if year>=1990&year<=1993
by us_id, sort: replace next_emp = emp99 if year>=1995&year<=1998
by us_id, sort: replace prior_emp = emp94 if year>=1995&year<=1998 
by us_id, sort: replace next_emp = emp04 if year>=2000&year<=2003
by us_id, sort: replace prior_emp = emp99 if year>=2000&year<=2003

by us_id, sort: gen next_benes_per_def = benes_perdef94 if year>=1990&year<=1993
by us_id, sort: gen prior_benes_per_def = benes_perdef89 if year>=1990&year<=1993
by us_id, sort: gen next_wages_per_def = wages_perdef94 if year>=1990&year<=1993
by us_id, sort: gen prior_wages_per_def = wages_perdef89 if year>=1990&year<=1993

by us_id, sort: replace next_benes_per_def = benes_perdef99 if year>=1995&year<=1998
by us_id, sort: replace prior_benes_per_def = benes_perdef94 if year>=1995&year<=1998
by us_id, sort: replace next_wages_per_def = wages_perdef99 if year>=1995&year<=1998
by us_id, sort: replace prior_wages_per_def = wages_perdef94 if year>=1995&year<=1998

by us_id, sort: replace next_benes_per_def = benes_perdef04 if year>=2000&year<=2003
by us_id, sort: replace prior_benes_per_def = benes_perdef99 if year>=2000&year<=2003
by us_id, sort: replace next_wages_per_def = wages_perdef04 if year>=2000&year<=2003
by us_id, sort: replace prior_wages_per_def = wages_perdef99 if year>=2000&year<=2003

gen ln_diff_wages_per_def = ln(next_wages_per_def) - ln(prior_wages_per_def)
gen ln_diff_benes_per_def = ln(next_benes_per_def) - ln(prior_benes_per_def)
gen ln_diff_emp = ln(next_emp) - ln(prior_emp)

gen ln_diff_comp_per = ln(next_wages_per + next_benes_per) - ln(prior_wages_per + prior_benes_per)

gen benes_share_next = next_benes_per/(next_benes_per + next_wages_per)
gen benes_share_prior = prior_benes_per/(prior_benes_per + prior_wages_per)

gen change_benes_share = benes_share_next - benes_share_prior

gen num_votes = votes_for + votes_against

summ ln_diff_wages_per_def if win==1& num_votes>=20&abs(vote_share-.5)<=.5

summ ln_diff_wages_per_def if win==0& num_votes>=20&abs(vote_share-.5)<=.5

*SUMM STATS- BENCHMARK SURVEY

gen rtw=.
global non_right "AK CA CO CT DE DC HI IL IN MI KY MD MA ME MN MO NH NJ NM NY OH OR PA RI VT WA WV WI"
global right "AL AZ AR FL GA ID IA KS LA MS MT NE NC ND NV OK SC SD TN TX UT VA WY"
foreach st in $right {
	replace rtw=1 if employerstate=="`st'"
}
foreach st in $non_right {
	replace rtw=0 if employerstate=="`st'"
}
replace rtw=0 if employerstate=="OK" & year<=2001
replace rtw=1 if employerstate=="IN" & year>=2012
replace rtw=1 if employerstate=="MI" & year>=2012

summ prior_wages_per_def if win==0 & rtw!=. & total_elec<=15 & num_votes>=20&abs(vote_share-.5)<=.5
summ next_wages_per_def if win==0 & rtw!=. & total_elec<=15 & num_votes>=20&abs(vote_share-.5)<=.5

summ prior_wages_per_def if win==1 & rtw!=. & total_elec<=15 & num_votes>=20&abs(vote_share-.5)<=.5
summ next_wages_per_def if win==1 & rtw!=. & total_elec<=15 & num_votes>=20&abs(vote_share-.5)<=.5

summ prior_wages_per_def if win!=. & rtw!=. & total_elec<=15 & num_votes>=20&abs(vote_share-.5)<=.5
summ next_wages_per_def if win!=. & rtw!=. & total_elec<=15 & num_votes>=20&abs(vote_share-.5)<=.5

summ prior_emp if win==0 & rtw!=. & total_elec<=15 & num_votes>=20&abs(vote_share-.5)<=.5
summ next_emp if win==0 & rtw!=. & total_elec<=15 & num_votes>=20&abs(vote_share-.5)<=.5

summ prior_emp if win==1 & rtw!=. & total_elec<=15 & num_votes>=20&abs(vote_share-.5)<=.5
summ next_emp if win==1 & rtw!=. & total_elec<=15 & num_votes>=20&abs(vote_share-.5)<=.5

summ prior_emp if win!=. & rtw!=. & total_elec<=15 & num_votes>=20&abs(vote_share-.5)<=.5
summ next_emp if win!=. & rtw!=. & total_elec<=15 & num_votes>=20&abs(vote_share-.5)<=.5

summ win if ln_diff_wages_per_def!=. & rtw!=. & total_elec<=15 & num_votes>=20&abs(vote_share-.5)<=.5
summ vote_share if ln_diff_wages_per_def!=. & rtw!=. & total_elec<=15 & num_votes>=20&abs(vote_share-.5)<=.5
summ vote_share if win==0 & ln_diff_wages_per_def!=. & rtw!=. & total_elec<=15 & num_votes>=20&abs(vote_share-.5)<=.5
summ vote_share if win==1 & ln_diff_wages_per_def!=. & rtw!=. & total_elec<=15 & num_votes>=20&abs(vote_share-.5)<=.5
summ num_votes if ln_diff_wages_per_def!=. & rtw!=. & total_elec<=15 & num_votes>=20&abs(vote_share-.5)<=.5
summ num_votes if win==0 & ln_diff_wages_per_def!=. & rtw!=. & total_elec<=15 & num_votes>=20&abs(vote_share-.5)<=.5
summ num_votes if win==1 & ln_diff_wages_per_def!=. & rtw!=. & total_elec<=15 & num_votes>=20&abs(vote_share-.5)<=.5

ttest ln_diff_wages_per_def if rtw!=. & total_elec<=15 & num_votes>=20&abs(vote_share-.5)<=.5, by(win)

ttest ln_diff_emp if rtw!=. & total_elec<=15 & num_votes>=20&abs(vote_share-.5)<=.5, by(win)

by us_id, sort: gen Lln_diff_wages_per_def = ln_diff_wages_per_def[_n-1]

gen win_x_elec = 1==win==1 &type=="RC"
by us_id, sort: gen tot_wins = sum(win_x_elec)
by us_id, sort: gen elec_tally = election[_n-1]*election + 1
gen wages_recorded =1 ==wages_salaries!=.
by us_id, sort: gen elec_first = wages_record[_n-1]*election 

**UNIONIZATION AND WAGES, EXCLUDING BENEFITS**

**TABLE 8**
*replace industry codes with 99999 for missing ones
replace indus=99999 if indus==. & num_votes>=10& abs(vote_share-.5)<=.5
gen rtwxwin = rtw*win

*.2 bandwidth (close elections)
reg ln_diff_wages_per_def win if rtw!=. & total_elec<=15 & num_votes>=20&abs(vote_share-.5)<=.2, cluster(us_id)
reg ln_diff_wages_per_def win rtw if total_elec<=15 & num_votes>=20&abs(vote_share-.5)<=.2, cluster(us_id)
reg ln_diff_wages_per_def win rtw i.year if total_elec<=15 & num_votes>=20&abs(vote_share-.5)<=.2, cluster(us_id)
reg ln_diff_wages_per_def win rtw i.year i.indus if total_elec<=15 & num_votes>=20&abs(vote_share-.5)<=.2, cluster(us_id)

*.35 bandwidth (moderately close elections)
reg ln_diff_wages_per_def win if rtw!=. & total_elec<=15 & num_votes>=20&abs(vote_share-.5)<=.35, cluster(us_id)
reg ln_diff_wages_per_def win rtw if total_elec<=15 & num_votes>=20&abs(vote_share-.5)<=.35, cluster(us_id)
reg ln_diff_wages_per_def win rtw i.year if total_elec<=15 & num_votes>=20&abs(vote_share-.5)<=.35, cluster(us_id)
reg ln_diff_wages_per_def win rtw i.year i.indus if total_elec<=15 & num_votes>=20&abs(vote_share-.5)<=.35, cluster(us_id)

*all elections
reg ln_diff_wages_per_def win if rtw!=. & total_elec<=15 & num_votes>=20&abs(vote_share-.5)<=.5, cluster(us_id)
reg ln_diff_wages_per_def win rtw if total_elec<=15 & num_votes>=20&abs(vote_share-.5)<=.5, cluster(us_id)
reg ln_diff_wages_per_def win rtw i.year if total_elec<=15 & num_votes>=20&abs(vote_share-.5)<=.5, cluster(us_id)
reg ln_diff_wages_per_def win rtw i.year i.indus if total_elec<=15 & num_votes>=20&abs(vote_share-.5)<=.5, cluster(us_id)

**TABLE 14**
*MINIMUM 10 VOTES
*.2 bandwidth (close elections)
reg ln_diff_wages_per_def win if rtw!=. & total_elec<=15 & num_votes>=10&abs(vote_share-.5)<=.2, cluster(us_id)
reg ln_diff_wages_per_def win rtw if total_elec<=15 & num_votes>=10&abs(vote_share-.5)<=.2, cluster(us_id)
reg ln_diff_wages_per_def win rtw i.year if total_elec<=15 & num_votes>=10&abs(vote_share-.5)<=.2, cluster(us_id)
reg ln_diff_wages_per_def win rtw i.year i.indus if total_elec<=15 & num_votes>=10&abs(vote_share-.5)<=.2, cluster(us_id)

*.35 bandwidth (moderately close elections)
reg ln_diff_wages_per_def win if rtw!=. & total_elec<=15 & num_votes>=10&abs(vote_share-.5)<=.35, cluster(us_id)
reg ln_diff_wages_per_def win rtw if total_elec<=15 & num_votes>=10&abs(vote_share-.5)<=.35, cluster(us_id)
reg ln_diff_wages_per_def win rtw i.year if total_elec<=15 & num_votes>=10&abs(vote_share-.5)<=.35, cluster(us_id)
reg ln_diff_wages_per_def win rtw i.year i.indus if total_elec<=15 & num_votes>=10&abs(vote_share-.5)<=.35, cluster(us_id)

*all elections
reg ln_diff_wages_per_def win if rtw!=. & total_elec<=15 & num_votes>=10&abs(vote_share-.5)<=.5, cluster(us_id)
reg ln_diff_wages_per_def win rtw if total_elec<=15 & num_votes>=10&abs(vote_share-.5)<=.5, cluster(us_id)
reg ln_diff_wages_per_def win rtw i.year if total_elec<=15 & num_votes>=10&abs(vote_share-.5)<=.5, cluster(us_id)
reg ln_diff_wages_per_def win rtw i.year i.indus if total_elec<=15 & num_votes>=10&abs(vote_share-.5)<=.5, cluster(us_id)

