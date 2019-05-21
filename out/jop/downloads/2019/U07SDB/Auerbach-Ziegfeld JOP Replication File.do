************************************************************************************
*Replication Code (STATA 15) 
*
*How Do Electoral Quotas Influence Political Competition? Evidence from Municipal, State, and National Elections in India
*
*Adam Auerbach and Adam Ziegfeld 
*
*Journal of Politics
*************************************************************************************


******NOTES******
*
*
*Below, we provide the code to replicate Figures 1 and 2 in the main text.
*After that, we provide the code to replicate the tables and figures in the online supplement.
*Note that the tables on which Figure 1 is based are Tables A4, A5, and A6.
*The table on which Figure 2 is based is Table A9. 
*Models 1, 3, and 5 from each of the respective tables are used to generate Figures 1 and 2.
*
*
*****************






*********************
******MAIN TEXT******
*********************


********************
******FIGURE 1******
********************
*We begin by capturing the coefficients and 95% confidence intervals for the local-level results found in Table A4.
use "aa_az_JOP_local.dta"

gen X=1

*We capture the coefficients in Table A4 associated with the different reservation types in local elections, in which the dependent variable is the effective number of candidates (or parties)
foreach i of numlist 1 2 3 4 5 6 7 {
preserve
regress enc general_sc_res general_st_res general_obc_res female_sc_res female_st_res female_obc_res female_gen_res city_dummy population percent_sc percent_st election_99 election_04 election_09, robust
mat B =r(table)
gen y=.
gen upper=.
gen lower=.
gen iv=`i'
gen dv=1
gen level=1
replace y=B[1,`i']
replace upper=B[6,`i']
replace lower=B[5,`i']
collapse y upper lower iv dv level, by(X)
save "temp_`i'_local_enc.dta", replace
restore
}

*We capture the coefficients in Table A4 associated with the different reservation types in local elections, in which the dependent variable is the vote share won by independent candidates
foreach i of numlist 1 2 3 4 5 6 7 {
preserve
regress indep_vote_share general_sc_res general_st_res general_obc_res female_sc_res female_st_res female_obc_res female_gen_res city_dummy population percent_sc percent_st election_04 election_09 if year !=1994, robust
mat B =r(table)
gen y=.
gen upper=.
gen lower=.
gen iv=`i'
gen dv=2
gen level=1
replace y=B[1,`i']
replace upper=B[6,`i']
replace lower=B[5,`i']
collapse y upper lower iv dv level, by(X)
save "temp_`i'_local_ind.dta", replace
restore
}

*We capture the coefficients in Table A4 associated with the different reservation types in local elections, in which the dependent variable is the vote share won by major parties (or Congress and the BJP)
foreach i of numlist 1 2 3 4 5 6 7 {
preserve
regress bjp_inc_vote_share general_sc_res general_st_res general_obc_res female_sc_res female_st_res female_obc_res female_gen_res city_dummy population percent_sc percent_st election_04 election_09 if year !=1994, robust
mat B =r(table)
gen y=.
gen upper=.
gen lower=.
gen iv=`i'
gen dv=3
gen level=1
replace y=B[1,`i']
replace upper=B[6,`i']
replace lower=B[5,`i']
collapse y upper lower iv dv level, by(X)
save "temp_`i'_local_major.dta", replace
restore
}

clear

*We next capture the coefficients and 95% confidence intervals for the state-level results found in Table A5.
use "aa_az_JOP_state_national.dta"

gen X=1

*We capture the coefficients in Table A5 associated with the different reservation types in state elections, in which the dependent variable is the effective number of candidates (or parties)
foreach i of numlist 1 2 {
preserve
reg ENP d_sc d_st scper stper i.st_num i.year elect_100K if type=="VS" & res_old==res_new, cl(st_num)
mat B =r(table)
gen y=.
gen upper=.
gen lower=.
gen iv=`i'
gen dv=1
gen level=2
replace y=B[1,`i']
replace upper=B[6,`i']
replace lower=B[5,`i']
collapse y upper lower iv dv level, by(X)
save "temp_`i'_vs_enc.dta", replace
restore
}

*We capture the coefficients in Table A5 associated with the different reservation types in state elections, in which the dependent variable is the vote share won by independent candidates
foreach i of numlist 1 2 {
preserve
reg ind_tot d_sc d_st scper stper i.st_num i.year elect_100K if type=="VS" & res_old==res_new, cl(st_num)
mat B =r(table)
gen y=.
gen upper=.
gen lower=.
gen iv=`i'
gen dv=2
gen level=2
replace y=B[1,`i']
replace upper=B[6,`i']
replace lower=B[5,`i']
collapse y upper lower iv dv level, by(X)
save "temp_`i'_vs_ind.dta", replace
restore
}

*We capture the coefficients in Table A5 associated with the different reservation types in state elections, in which the dependent variable is the vote share won by major parties (or those winning more than 10% of the state-wide vote)
foreach i of numlist 1 2 {
preserve
reg total10 d_sc d_st scper stper i.st_num i.year elect_100K if type=="VS" & res_old==res_new, cl(st_num)
mat B =r(table)
gen y=.
gen upper=.
gen lower=.
gen iv=`i'
gen dv=3
gen level=2
replace y=B[1,`i']
replace upper=B[6,`i']
replace lower=B[5,`i']
collapse y upper lower iv dv level, by(X)
save "temp_`i'_vs_major.dta", replace
restore
}


*We finally capture the coefficients and 95% confidence intervals for the national-level results found in Table A6.


*We capture the coefficients in Table A6 associated with the different reservation types in national elections, in which the dependent variable is the effective number of candidates (or parties)
foreach i of numlist 1 2 {
preserve
reg ENP d_sc d_st scper stper i.st_num i.year elect_100K if type=="LS", cl(st_num)
mat B =r(table)
gen y=.
gen upper=.
gen lower=.
gen iv=`i'
gen dv=1
gen level=3
replace y=B[1,`i']
replace upper=B[6,`i']
replace lower=B[5,`i']
collapse y upper lower iv dv level, by(X)
save "temp_`i'_ls_enc.dta", replace
restore
}

*We capture the coefficients in Table A6 associated with the different reservation types in national elections, in which the dependent variable is the vote share won by independent candidates
foreach i of numlist 1 2 {
preserve
reg ind_tot d_sc d_st scper stper i.st_num i.year elect_100K if type=="LS", cl(st_num)
mat B =r(table)
gen y=.
gen upper=.
gen lower=.
gen iv=`i'
gen dv=2
gen level=3
replace y=B[1,`i']
replace upper=B[6,`i']
replace lower=B[5,`i']
collapse y upper lower iv dv level, by(X)
save "temp_`i'_ls_ind.dta", replace
restore
}

*We capture the coefficients in Table A6 associated with the different reservation types in national elections, in which the dependent variable is the vote share won by major parties (or those winning more than 10% of the state-wide vote)
foreach i of numlist 1 2 {
preserve
reg total10 d_sc d_st scper stper i.st_num i.year elect_100K if type=="LS", cl(st_num)
mat B =r(table)
gen y=.
gen upper=.
gen lower=.
gen iv=`i'
gen dv=3
gen level=3
replace y=B[1,`i']
replace upper=B[6,`i']
replace lower=B[5,`i']
collapse y upper lower iv dv level, by(X)
save "temp_`i'_ls_major.dta", replace
restore
}

clear

*We combine these coefficients and 95% confidence intervals into a dataset with all of the coefficients from the various modles
use "temp_1_local_enc.dta"
append using "temp_2_local_enc.dta"
append using "temp_3_local_enc.dta"
append using "temp_4_local_enc.dta"
append using "temp_5_local_enc.dta"
append using "temp_6_local_enc.dta"
append using "temp_7_local_enc.dta"
append using "temp_1_local_ind.dta"
append using "temp_2_local_ind.dta"
append using "temp_3_local_ind.dta"
append using "temp_4_local_ind.dta"
append using "temp_5_local_ind.dta"
append using "temp_6_local_ind.dta"
append using "temp_7_local_ind.dta"
append using "temp_1_local_major.dta"
append using "temp_2_local_major.dta"
append using "temp_3_local_major.dta"
append using "temp_4_local_major.dta"
append using "temp_5_local_major.dta"
append using "temp_6_local_major.dta"
append using "temp_7_local_major.dta"
append using "temp_1_vs_enc.dta"
append using "temp_2_vs_enc.dta"
append using "temp_1_vs_ind.dta"
append using "temp_2_vs_ind.dta"
append using "temp_1_vs_major.dta"
append using "temp_2_vs_major.dta"
append using "temp_1_ls_enc.dta"
append using "temp_2_ls_enc.dta"
append using "temp_1_ls_ind.dta"
append using "temp_2_ls_ind.dta"
append using "temp_1_ls_major.dta"
append using "temp_2_ls_major.dta"

drop X
replace iv=8 if iv==1 & level==2
replace iv=9 if iv==2 & level==2
replace iv=10 if iv==1 & level==3
replace iv=11 if iv==2 & level==3

set scheme s1mono

*We plot the coefficients along with bars representing 95% confidence intervals
twoway (scatter iv y, yline(7.5 9.5, lwidth(medium) lpattern(dash) lcolor(black)) ytitle(, size(zero)) ylabel(1(1)11, labels angle(horizontal) valuelabel noticks) mcolor(black) msymbol(circle) mlabcolor(black mlabposition(12) mlabgap(vsmall)) by(dv, rows(1) xrescale)) (rbar lower upper iv, sort fcolor(black) lcolor(black) horizontal barwidth(.01)), yscale(noline) ylabel(, format(%9.0g)) xtitle(Coefficient) xtitle(, margin(medsmall)) xline(0, lwidth(medium) lpattern(dot) lcolor(black)) legend(off) plotregion(lcolor(white)) 
clear


********************
******FIGURE 2******
********************
use "aa_az_JOP_state_national", clear
set scheme s1mono

*We plot the average marginal effects of SC and ST reservation on the effective number of candidates (or parties) in state versus national elections
reg ENP i.VS##i.d_sc i.VS##i.d_st scper stper elect_100K i.st_num i.year if res_old==res_new, cl(st_num)
qui margins, dydx(d_sc) at(VS=(0 1) d_st=0)
marginsplot, yline(0, lpattern(dash) lcolor(black)) ylabel(-0.3(0.1).1, labsize(medium)) ytitle(Effect of SC Reservation) ytitle(, size(large) margin(small)) xtitle("") xlabel(, labsize(medium)) title(Effective # of Cands., size(large)) plotregion(lcolor(white)) level(95)
graph save Graph "graph1.gph"
qui margins, dydx(d_st) at(VS=(0 1) d_sc=0)
marginsplot, yline(0, lpattern(dash) lcolor(black)) ylabel(-0.3(0.1).1, labsize(medium)) ytitle(Effect of ST Reservation) ytitle(, size(large) margin(small)) xtitle("") xlabel(, labsize(medium)) title(Effective # of Cands., size(large)) plotregion(lcolor(white)) level(95)
graph save Graph "graph2.gph"

*We plot the average marginal effects of SC and ST reservation on the share of the vote won by independent candidates in state versus national elections
reg ind_tot  i.VS##i.d_sc i.VS##i.d_st scper stper elect_100K i.st_num i.year if res_old==res_new, cl(st_num)
qui margins, dydx(d_sc) at(VS=(0 1) d_st=0)
marginsplot, yline(0, lpattern(dash) lcolor(black)) ylabel(-0.08(0.04).08, labsize(medium)) ytitle("") xtitle("") xlabel(, labsize(medium)) title(Independent Vote, size(large)) plotregion(lcolor(white)) level(95)
graph save Graph "graph3.gph"
qui margins, dydx(d_st) at(VS=(0 1) d_sc=0)
marginsplot, yline(0, lpattern(dash) lcolor(black)) ylabel(-0.08(0.04).08, labsize(medium)) ytitle("") xtitle("") xlabel(, labsize(medium)) title(Independent Vote, size(large)) plotregion(lcolor(white)) level(95)
graph save Graph "graph4.gph"

*We plot the average marginal effects of SC and ST reservation on the share of the vote won by major-party candidates (whose parties won more than 10% of the state-wide vote) in state versus national elections
reg total10  i.VS##i.d_sc i.VS##i.d_st scper stper elect_100K i.st_num i.year if res_old==res_new, cl(st_num)
qui margins, dydx(d_sc) at(VS=(0 1) d_st=0)
marginsplot, yline(0, lpattern(dash) lcolor(black)) ylabel(-0.08(0.04).08, labsize(medium)) ytitle("") xtitle("") xlabel(, labsize(medium)) title(Major-Party Vote, size(large)) plotregion(lcolor(white)) level(95)
graph save Graph "graph5.gph"
qui margins, dydx(d_st) at(VS=(0 1) d_sc=0)
marginsplot, yline(0, lpattern(dash) lcolor(black)) ylabel(-0.08(0.04).08, labsize(medium)) ytitle("") xtitle("") xlabel(, labsize(medium)) title(Major-Party Vote, size(large)) plotregion(lcolor(white)) level(95)
graph save Graph "graph6.gph"

*We combine the marginal effets plots
graph combine "graph1.gph" "graph3.gph" "graph5.gph" "graph2.gph" "graph4.gph" "graph6.gph" 
clear





*****************************
******ONLINE SUPPLEMENT******
*****************************


********************
******TABLE A1******
********************
use "aa_az_JOP_local.dta", clear
sum enc
sum indep_vote_share bjp_inc_vote_share if year!=1994
sum population percent_sc percent_st if year==1999 
sum population percent_sc percent_st if year==2009 
clear



********************
******TABLE A2******
********************
use "aa_az_JOP_state_national.dta", clear
sum ENP ind_tot total10 scper stper elect_100K if type=="VS" & res_old==res_new & scper!=. & stper!=.
sum ENP ind_tot total10 scper stper elect_100K if type=="LS" & res_old==res_new & scper!=. & stper!=.
clear



*********************
******TABLE A3A******
*********************
use "aa_az_JOP_state_national.dta", clear
bysort st_name: tab year if type=="VS"
tab year if type=="LS"
clear



*********************
******TABLE A3B******
*********************
use "aa_az_JOP_state_national.dta", clear
bysort st_name: tab year if type=="VS" & scper!=. & stper!=.
tab year if type=="LS" & scper!=. & stper!=.
clear



********************
******TABLE A4******
********************
use "aa_az_JOP_local.dta", clear
regress enc general_sc_res general_st_res general_obc_res female_sc_res female_st_res female_obc_res female_gen_res city_dummy population percent_sc percent_st election_99 election_04 election_09, robust
regress enc general_sc_res general_st_res general_obc_res female_sc_res female_st_res female_obc_res female_gen_res city_dummy population election_99 election_04 election_09, robust
regress indep_vote_share general_sc_res general_st_res general_obc_res female_sc_res female_st_res female_obc_res female_gen_res city_dummy population percent_sc percent_st election_04 election_09 if year !=1994, robust
regress indep_vote_share general_sc_res general_st_res general_obc_res female_sc_res female_st_res female_obc_res female_gen_res city_dummy population election_04 election_09 if year !=1994, robust
regress bjp_inc_vote_share general_sc_res general_st_res general_obc_res female_sc_res female_st_res female_obc_res female_gen_res city_dummy population percent_sc percent_st election_04 election_09 if year !=1994, robust
regress bjp_inc_vote_share general_sc_res general_st_res general_obc_res female_sc_res female_st_res female_obc_res female_gen_res city_dummy population election_04 election_09 if year !=1994, robust
clear



********************
******TABLE A5******
********************
use "aa_az_JOP_state_national.dta", clear
reg ENP d_sc d_st scper stper elect_100K i.st_num i.year if type=="VS" & res_old==res_new, cl(st_num)
reg ENP d_sc d_st elect_100K i.st_num i.year if type=="VS" & res_old==res_new, cl(st_num)
reg ind_tot d_sc d_st scper stper elect_100K i.st_num i.year if type=="VS" & res_old==res_new, cl(st_num)
reg ind_tot d_sc d_st elect_100K i.st_num i.year if type=="VS" & res_old==res_new, cl(st_num)
reg total10 d_sc d_st scper stper elect_100K i.st_num i.year if type=="VS" & res_old==res_new, cl(st_num)
reg total10 d_sc d_st elect_100K i.st_num i.year if type=="VS" & res_old==res_new, cl(st_num)
clear



********************
******TABLE A6******
********************
use "aa_az_JOP_state_national.dta", clear
reg ENP d_sc d_st scper stper elect_100K i.st_num i.year if type=="LS", cl(st_num)
reg ENP d_sc d_st elect_100K i.st_num i.year if type=="LS", cl(st_num)
reg ind_tot d_sc d_st scper stper elect_100K i.st_num i.year if type=="LS", cl(st_num)
reg ind_tot d_sc d_st  elect_100K i.st_num i.year if type=="LS", cl(st_num)
reg total10 d_sc d_st scper stper elect_100K i.st_num i.year if type=="LS", cl(st_num)
reg total10 d_sc d_st  elect_100K i.st_num i.year if type=="LS", cl(st_num)
clear



********************
******TABLE A7******
********************
use "aa_az_JOP_state_national.dta", clear
reg ENP d_sc d_st scper stper elect_100K time i.st_num if type=="VS" & res_old==res_new, cl(st_num)
reg ind_tot d_sc d_st scper stper elect_100K time i.st_num if type=="VS" & res_old==res_new, cl(st_num)
reg total10 d_sc d_st scper stper elect_100K time i.st_num if type=="VS" & res_old==res_new, cl(st_num)
reg ENP d_sc d_st scper stper elect_100K time i.st_num if type=="LS", cl(st_num)
reg ind_tot d_sc d_st scper stper elect_100K time i.st_num if type=="LS", cl(st_num)
reg total10 d_sc d_st scper stper elect_100K time i.st_num if type=="LS", cl(st_num)
clear



********************
******TABLE A8******
********************
use "aa_az_JOP_state_national.dta", clear
reg total5 d_sc d_st scper stper elect_100K i.st_num i.year if type=="VS" & res_old==res_new, cl(st_num)
reg total10 d_sc d_st scper stper elect_100K i.st_num i.year if type=="VS" & res_old==res_new, cl(st_num)
reg total20 d_sc d_st scper stper elect_100K i.st_num i.year if type=="VS" & res_old==res_new, cl(st_num)
reg total5 d_sc d_st scper stper elect_100K i.st_num i.year if type=="LS", cl(st_num)
reg total10 d_sc d_st scper stper elect_100K i.st_num i.year if type=="LS", cl(st_num)
reg total20 d_sc d_st scper stper elect_100K i.st_num i.year if type=="LS", cl(st_num)
clear


********************
******TABLE A9******
********************
use "aa_az_JOP_state_national.dta", clear
reg ENP i.VS##i.d_sc i.VS##i.d_st scper stper elect_100K i.st_num i.year if res_old==res_new, cl(st_num)
reg ENP i.VS##i.d_sc i.VS##i.d_st elect_100K i.st_num i.year if res_old==res_new, cl(st_num)
reg ind_tot i.VS##i.d_sc i.VS##i.d_st scper stper elect_100K i.st_num i.year if res_old==res_new, cl(st_num)
reg ind_tot i.VS##i.d_sc i.VS##i.d_st elect_100K i.st_num i.year if res_old==res_new, cl(st_num)
reg total10 i.VS##i.d_sc i.VS##i.d_st scper stper elect_100K i.st_num i.year if res_old==res_new, cl(st_num)
reg total10 i.VS##i.d_sc i.VS##i.d_st elect_100K i.st_num i.year if res_old==res_new, cl(st_num)
clear



*********************
******TABLE A10******
*********************
use "aa_az_JOP_state_national.dta", clear
reg ENP c.elect_100K##i.d_sc c.elect_100K##i.d_st scper stper i.st_num i.year  if res_old==res_new, cl(st_num)
reg ind_tot  c.elect_100K##i.d_sc c.elect_100K##i.d_st scper stper i.st_num i.year  if res_old==res_new, cl(st_num)
reg total10  c.elect_100K##i.d_sc c.elect_100K##i.d_st scper stper i.st_num i.year  if res_old==res_new, cl(st_num)
clear



********************
******FIGURE A1*****
********************
use "aa_az_JOP_state_national.dta", clear

*We plot the average marginal effects of SC/ST reservation on the effective number of candidates (parties) as constituency size (population) increases
reg ENP c.elect_100K##i.d_sc c.elect_100K##i.d_st scper stper i.st_num i.year  if res_old==res_new, cl(st_num)
qui margins, dydx(d_sc) at(elect_100K=(0(1)16) d_st=0)
marginsplot, yline(0, lpattern(dash) lcolor(black)) ylabel(-0.4(0.2).4, labsize(medium)) ytitle(Effect of SC Reservation) ytitle(, size(large) margin(small)) xtitle("Electorate in 100,000s") xlabel(, labsize(medium)) title(ENC, size(large)) plotregion(lcolor(white)) level(95)
graph save Graph "temp1.gph", replace
qui margins, dydx(d_st) at(elect_100K=(0(1)16) d_sc=0)
marginsplot, yline(0, lpattern(dash) lcolor(black)) ylabel(-0.4(0.2).4, labsize(medium)) ytitle(Effect of ST Reservation) ytitle(, size(large) margin(small)) xtitle("Electorate in 100,000s") xlabel(, labsize(medium)) title(ENC, size(large)) plotregion(lcolor(white)) level(95)
graph save Graph "temp2.gph", replace

*We plot the average marginal effects of SC/ST reservation on the the vote share for independent candidatesas constituency size (population) increases
reg ind_tot  c.elect_100K##i.d_sc c.elect_100K##i.d_st scper stper i.st_num i.year  if res_old==res_new, cl(st_num)
qui margins, dydx(d_sc) at(elect_100K=(0(1)16) d_st=0)
marginsplot, yline(0, lpattern(dash) lcolor(black)) ylabel(-0.2(0.05).05, labsize(medium)) ytitle("") xtitle("Electorate in 100,000s") xlabel(, labsize(medium)) title(Independent Vote, size(large)) plotregion(lcolor(white)) level(95)
graph save Graph "temp3.gph", replace
qui margins, dydx(d_st) at(elect_100K=(0(1)16) d_sc=0)
marginsplot, yline(0, lpattern(dash) lcolor(black)) ylabel(-0.2(0.05).05, labsize(medium)) ytitle("") xtitle("Electorate in 100,000s") xlabel(, labsize(medium)) title(Independent Vote, size(large)) plotregion(lcolor(white)) level(95)
graph save Graph "temp4.gph", replace

*We plot the average marginal effects of SC/ST reservation on the vote share for major-party candidates as constituency size (population) increases
reg total10  c.elect_100K##i.d_sc c.elect_100K##i.d_st scper stper i.st_num i.year  if res_old==res_new, cl(st_num)
qui margins, dydx(d_sc) at(elect_100K=(0(1)16) d_st=0)
marginsplot, yline(0, lpattern(dash) lcolor(black)) ylabel(-0.2(0.05).05, labsize(medium)) ytitle("") xtitle("Electorate in 100,000s") xlabel(, labsize(medium)) title(Major-Party Vote, size(large)) plotregion(lcolor(white)) level(95)
graph save Graph "temp5.gph", replace
qui margins, dydx(d_st) at(elect_100K=(0(1)16) d_sc=0)
marginsplot, yline(0, lpattern(dash) lcolor(black)) ylabel(-0.2(0.05).05, labsize(medium)) ytitle("") xtitle("Electorate in 100,000s") xlabel(, labsize(medium)) title(Major-Party Vote, size(large)) plotregion(lcolor(white)) level(95)
graph save Graph "temp6.gph", replace

*We combine the marginal effects plots
graph combine "temp1.gph" "temp3.gph" "temp5.gph" "temp2.gph" "temp4.gph" "temp6.gph"

clear



*********************
******FIGURE A2******
*********************
use "aa_az_JOP_state_national.dta", clear

*We plot the average marginal effects of SC/ST reservation on the effective number of candidates (parties) as the number of elections after delimitation increases
reg ENP i.d_sc##i.postdelim i.d_st##i.postdelim scper stper i.st_num i.year elect_100K if type=="VS" & res_old==res_new, cl(st_num)
qui margins, dydx(d_sc) at(postdelim=(1(1)10) d_st=0)
marginsplot, ytitle(SC Reservation) ytitle(, size(large) margin(small)) yline(0, lpattern(dash) lcolor(black)) ylabel(-0.6(0.2)0.8, labsize(medium)) xtitle(# of Elections) xtitle(, size(large) margin(small)) xlabel(1(1)10, labsize(medium)) title(ENP, size(large)) plotregion(lcolor(white)) level(95)
graph save Graph "temp1.gph", replace
qui margins, dydx(d_st) at(postdelim=(1(1)10) d_sc=0)
marginsplot, ytitle(ST Reservation) ytitle(, size(large) margin(small)) yline(0, lpattern(dash) lcolor(black)) ylabel(-0.6(0.2)0.8, labsize(medium)) xtitle(# of Elections) xtitle(, size(large) margin(small)) xlabel(1(1)8, labsize(medium)) title(ENP, size(large)) plotregion(lcolor(white)) level(95)
graph save Graph "temp2.gph", replace

*We plot the average marginal effects of SC/ST reservation on the vote share won by independent candidates as the number of elections after delimitation increases
reg ind_tot i.d_sc##i.postdelim i.d_st##i.postdelim scper stper i.st_num i.year elect_100K if type=="VS" & res_old==res_new, cl(st_num)
qui margins, dydx(d_sc) at(postdelim=(1(1)10) d_st=0)
marginsplot, ytitle("") yline(0, lpattern(dash) lcolor(black)) ylabel(-0.1(0.05).1, labsize(medium)) xtitle(# of Elections) xtitle(, size(large) margin(small)) xlabel(1(1)10, labsize(medium)) title(Independent Vote, size(large)) plotregion(lcolor(white)) level(95)
graph save Graph "temp3.gph", replace
qui margins, dydx(d_st) at(postdelim=(1(1)10) d_sc=0)
marginsplot, ytitle("") yline(0, lpattern(dash) lcolor(black)) ylabel(-0.1(0.05).1, labsize(medium)) xtitle(# of Elections) xtitle(, size(large) margin(small)) xlabel(1(1)8, labsize(medium)) title(Independent Vote, size(large)) plotregion(lcolor(white)) level(95)
graph save Graph "temp4.gph", replace

*We plot the average marginal effects of SC/ST reservation on the vote share won by major-party candidates as the number of elections after delimitation increases
reg total10 i.d_sc##i.postdelim i.d_st##i.postdelim scper stper i.st_num i.year elect_100K if type=="VS" & res_old==res_new, cl(st_num)
qui margins, dydx(d_sc) at(postdelim=(1(1)10) d_st=0)
marginsplot, ytitle("")  yline(0, lpattern(dash) lcolor(black)) ylabel(-0.1(0.05).1, labsize(medium)) xtitle(# of Elections) xtitle(, size(large) margin(small)) xlabel(1(1)10, labsize(medium)) title(Major-Party Vote, size(large)) plotregion(lcolor(white)) level(95)
graph save Graph "temp5.gph", replace
qui margins, dydx(d_st) at(postdelim=(1(1)10) d_sc=0)
marginsplot, ytitle("") yline(0, lpattern(dash) lcolor(black)) ylabel(-0.1(0.05).1, labsize(medium)) xtitle(# of Elections) xtitle(, size(large) margin(small)) xlabel(1(1)8, labsize(medium)) title(Major-Party Vote, size(large)) plotregion(lcolor(white)) level(95)
graph save Graph "temp6.gph", replace

*We combine the marginal effects plots
graph combine "temp1.gph" "temp3.gph" "temp5.gph" "temp2.gph" "temp4.gph" "temp6.gph"
clear



**********************
******FIGURE A3A******
**********************
use "aa_az_JOP_state_national.dta", clear
gen X=1
*Create a new variable for the states included in the state-wise analysis
gen state=15 if st_name=="Andhra Pradesh"
replace state=14 if st_name=="Bihar"
replace state=13 if st_name=="Gujarat"
replace state=12 if st_name=="Haryana"
replace state=11 if st_name=="Himachal Pradesh"
replace state=10 if st_name=="Karnataka"
replace state=9 if st_name=="Kerala"
replace state=8 if st_name=="Madhya Pradesh"
replace state=7 if st_name=="Maharashtra"
replace state=6 if st_name=="Odisha"
replace state=5 if st_name=="Punjab"
replace state=4 if st_name=="Rajasthan"
replace state=3 if st_name=="Tamil Nadu"
replace state=2 if st_name=="Uttar Pradesh"
replace state=1 if st_name=="West Bengal"

*Capture coefficients for SC reservation
foreach i of num 1/15 {
preserve
reg ENP d_sc d_st scper stper i.year elect_100K if type=="VS" & res_old==res_new & state==`i'
mat B =r(table)
gen y=.
gen upper=.
gen lower=.
gen obs=`i'
gen reserve=1
replace y=B[1,1]
replace upper=B[6,1]
replace lower=B[5,1]
collapse y upper lower obs reserve, by(X)
save "temp_`i'_sc.dta", replace
restore
}

*Capture coefficients for ST reservation
foreach i of num 1/15 {
preserve
reg ENP d_sc d_st scper stper i.year elect_100K if type=="VS" & res_old==res_new & state==`i'
mat B =r(table)
gen y=.
gen upper=.
gen lower=.
gen obs=`i'
gen reserve=2
replace y=B[1,2]
replace upper=B[6,2]
replace lower=B[5,2]
collapse y upper lower obs reserve, by(X)
save "temp_`i'_st.dta", replace
restore
}

clear

*Create a new dataset with the coefficients and 95% confidence intervals
use "temp_1_st.dta"
foreach i of num 2/15{
append using "temp_`i'_st.dta"
}

foreach i of num 1/15{
append using "temp_`i'_sc.dta"
}

save "temp_scst_enp.dta", replace
recode y 0=.

*Drop UP because of the huge confidence intervals (based on only one seat)
replace y=. if obs==2 & reserve==2
replace lower=. if obs==2 & reserve==2
replace upper=. if obs==2 & reserve==2

gen name="Andhra Pradesh" if obs==15
replace name="Bihar" if obs==14
replace name="Gujarat" if obs==13
replace name="Haryana" if obs==12
replace name="Himachal Pradesh" if obs==11
replace name="Karnataka" if obs==10
replace name="Kerala" if obs==9
replace name="Madhya Pradesh" if obs==8
replace name="Maharashtra" if obs==7
replace name="Odisha" if obs==6
replace name="Punjab" if obs==5
replace name="Rajasthan" if obs==4
replace name="Tamil Nadu" if obs==3
replace name="Uttar Pradesh" if obs==2
replace name="West Bengal" if obs==1

gsort -name
encode name, gen(st_name)
set scheme s1mono
twoway (scatter st_name y, ytitle(, size(zero)) ylabel(1(1)15, labels angle(horizontal) valuelabel noticks) mcolor(black) msymbol(circle) mlabcolor(black mlabposition(12) mlabgap(vsmall)) by(reserve, rows(1))) (rbar lower upper st_name, sort fcolor(black) lcolor(black) horizontal barwidth(.01)), yscale(noline) ylabel(, format(%9.0g)) xtitle(Coefficient) xtitle(, margin(medsmall)) xline(0, lwidth(medium) lpattern(dot) lcolor(black)) legend(off) plotregion(lcolor(white)) 
clear



**********************
******FIGURE A3B******
**********************
use "aa_az_JOP_state_national.dta", clear
gen X=1
*Create a new variable for the states included in the state-wise analysis
gen state=15 if st_name=="Andhra Pradesh"
replace state=14 if st_name=="Bihar"
replace state=13 if st_name=="Gujarat"
replace state=12 if st_name=="Haryana"
replace state=11 if st_name=="Himachal Pradesh"
replace state=10 if st_name=="Karnataka"
replace state=9 if st_name=="Kerala"
replace state=8 if st_name=="Madhya Pradesh"
replace state=7 if st_name=="Maharashtra"
replace state=6 if st_name=="Odisha"
replace state=5 if st_name=="Punjab"
replace state=4 if st_name=="Rajasthan"
replace state=3 if st_name=="Tamil Nadu"
replace state=2 if st_name=="Uttar Pradesh"
replace state=1 if st_name=="West Bengal"

*Capture coefficients for SC reservation
foreach i of num 1/15 {
preserve
reg ind_tot d_sc d_st scper stper i.year elect_100K if type=="VS" & res_old==res_new & state==`i'
mat B =r(table)
gen y=.
gen upper=.
gen lower=.
gen obs=`i'
gen reserve=1
replace y=B[1,1]
replace upper=B[6,1]
replace lower=B[5,1]
collapse y upper lower obs reserve, by(X)
save "/Users/tuh33624/Desktop/temp/temp_`i'_sc.dta", replace
restore
}

*Capture coefficients for ST reservation
foreach i of num 1/15 {
preserve
reg ind_tot d_sc d_st scper stper i.year elect_100K if type=="VS" & res_old==res_new & state==`i'
mat B =r(table)
gen y=.
gen upper=.
gen lower=.
gen obs=`i'
gen reserve=2
replace y=B[1,2]
replace upper=B[6,2]
replace lower=B[5,2]
collapse y upper lower obs reserve, by(X)
save "/Users/tuh33624/Desktop/temp/temp_`i'_st.dta", replace
restore
}

clear

*Create a new dataset with the coefficients and 95% confidence intervals
use "/Users/tuh33624/Desktop/temp/temp_1_st.dta"
foreach i of num 2/15{
append using "/Users/tuh33624/Desktop/temp/temp_`i'_st.dta"
}
foreach i of num 1/15{
append using "/Users/tuh33624/Desktop/temp/temp_`i'_sc.dta"
}
save "/Users/tuh33624/Desktop/temp/temp_scst_major.dta", replace
recode y 0=.

*Drop UP because of the huge confidence intervals (based on only one seat)
replace y=. if obs==2 & reserve==2
replace lower=. if obs==2 & reserve==2
replace upper=. if obs==2 & reserve==2

gen name="Andhra Pradesh" if obs==15
replace name="Bihar" if obs==14
replace name="Gujarat" if obs==13
replace name="Haryana" if obs==12
replace name="Himachal Pradesh" if obs==11
replace name="Karnataka" if obs==10
replace name="Kerala" if obs==9
replace name="Madhya Pradesh" if obs==8
replace name="Maharashtra" if obs==7
replace name="Odisha" if obs==6
replace name="Punjab" if obs==5
replace name="Rajasthan" if obs==4
replace name="Tamil Nadu" if obs==3
replace name="Uttar Pradesh" if obs==2
replace name="West Bengal" if obs==1

sort name
encode name, gen(st_name)
set scheme s1mono
twoway (scatter st_name y, ytitle(, size(zero)) ylabel(1(1)15, labels angle(horizontal) valuelabel noticks) mcolor(black) msymbol(circle) mlabcolor(black mlabposition(12) mlabgap(vsmall)) by(reserve, rows(1))) (rbar lower upper st_name, sort fcolor(black) lcolor(black) horizontal barwidth(.01)), yscale(noline) ylabel(, format(%9.0g)) xtitle(Coefficient) xtitle(, margin(medsmall)) xline(0, lwidth(medium) lpattern(dot) lcolor(black)) legend(off) plotregion(lcolor(white)) 
clear



**********************
******FIGURE A3C******
**********************
use "aa_az_JOP_state_national.dta", clear
gen X=1
*Create a new variable for the states included in the state-wise analysis
gen state=15 if st_name=="Andhra Pradesh"
replace state=14 if st_name=="Bihar"
replace state=13 if st_name=="Gujarat"
replace state=12 if st_name=="Haryana"
replace state=11 if st_name=="Himachal Pradesh"
replace state=10 if st_name=="Karnataka"
replace state=9 if st_name=="Kerala"
replace state=8 if st_name=="Madhya Pradesh"
replace state=7 if st_name=="Maharashtra"
replace state=6 if st_name=="Odisha"
replace state=5 if st_name=="Punjab"
replace state=4 if st_name=="Rajasthan"
replace state=3 if st_name=="Tamil Nadu"
replace state=2 if st_name=="Uttar Pradesh"
replace state=1 if st_name=="West Bengal"

*Capture coefficients for SC reservation
foreach i of num 1/15 {
preserve
reg total10 d_sc d_st scper stper i.year elect_100K if type=="VS" & res_old==res_new & state==`i'
mat B =r(table)
gen y=.
gen upper=.
gen lower=.
gen obs=`i'
gen reserve=1
replace y=B[1,1]
replace upper=B[6,1]
replace lower=B[5,1]
collapse y upper lower obs reserve, by(X)
save "/Users/tuh33624/Desktop/temp/temp_`i'_sc.dta", replace
restore
}

*Capture coefficients for ST reservation
foreach i of num 1/15 {
preserve
reg total10 d_sc d_st scper stper i.year elect_100K if type=="VS" & res_old==res_new & state==`i'
mat B =r(table)
gen y=.
gen upper=.
gen lower=.
gen obs=`i'
gen reserve=2
replace y=B[1,2]
replace upper=B[6,2]
replace lower=B[5,2]
collapse y upper lower obs reserve, by(X)
save "/Users/tuh33624/Desktop/temp/temp_`i'_st.dta", replace
restore
}

clear

*Create a new dataset with the coefficients and 95% confidence intervals
use "/Users/tuh33624/Desktop/temp/temp_1_st.dta"
foreach i of num 2/15{
append using "/Users/tuh33624/Desktop/temp/temp_`i'_st.dta"
}
foreach i of num 1/15{
append using "/Users/tuh33624/Desktop/temp/temp_`i'_sc.dta"
}
save "/Users/tuh33624/Desktop/temp/temp_scst_major.dta", replace
recode y 0=.

*Drop UP because of the huge confidence intervals (based on only one seat)
replace y=. if obs==2 & reserve==2
replace lower=. if obs==2 & reserve==2
replace upper=. if obs==2 & reserve==2

gen name="Andhra Pradesh" if obs==15
replace name="Bihar" if obs==14
replace name="Gujarat" if obs==13
replace name="Haryana" if obs==12
replace name="Himachal Pradesh" if obs==11
replace name="Karnataka" if obs==10
replace name="Kerala" if obs==9
replace name="Madhya Pradesh" if obs==8
replace name="Maharashtra" if obs==7
replace name="Odisha" if obs==6
replace name="Punjab" if obs==5
replace name="Rajasthan" if obs==4
replace name="Tamil Nadu" if obs==3
replace name="Uttar Pradesh" if obs==2
replace name="West Bengal" if obs==1

sort name
encode name, gen(st_name)
set scheme s1mono
twoway (scatter st_name y, ytitle(, size(zero)) ylabel(1(1)15, labels angle(horizontal) valuelabel noticks) mcolor(black) msymbol(circle) mlabcolor(black mlabposition(12) mlabgap(vsmall)) by(reserve, rows(1))) (rbar lower upper st_name, sort fcolor(black) lcolor(black) horizontal barwidth(.01)), yscale(noline) ylabel(, format(%9.0g)) xtitle(Coefficient) xtitle(, margin(medsmall)) xline(0, lwidth(medium) lpattern(dot) lcolor(black)) legend(off) plotregion(lcolor(white)) 
clear



*********************
******FIGURE A4******
*********************
use "aa_az_JOP_state_national.dta", clear

*Drop observations so that we only have one observation for each state election constituency (in the most recent state eletion)
drop if type=="LS" | year<2008
gsort st_name const_no -year
drop if st_name==st_name[_n-1] & const_no==const_no[_n-1]

*Create the kernel density plots for the SC and ST populations in reserved and unreserved seats
twoway (kdensity scper if d_sc==1, lcolor(black) lwidth(medium) lpattern(dash)) (kdensity scper if d_sc==0 & d_st==0, lcolor(gray) lwidth(medium) lpattern(solid))
graph save Graph "temp1.gph", replace

twoway (kdensity stper if d_st==1, lcolor(black) lwidth(medium) lpattern(dash)) (kdensity stper if d_st==0 & d_st==0, lcolor(gray) lwidth(medium) lpattern(solid))
graph save Graph "temp2.gph", replace

*Combine the plot for SCs and STs
graph combine "temp1.gph" "temp2.gph"
clear



*********************
******TABLE A11******
*********************
use "aa_az_JOP_state_national.dta", clear
reg ENP i.d_sc##c.scper i.d_st##c.stper elect_100K i.st_num i.year  if type=="VS" & res_old==res_new, cl(st_num)
reg ind_tot i.d_sc##c.scper i.d_st##c.stper elect_100K i.st_num i.year  if type=="VS" & res_old==res_new, cl(st_num)
reg total10 i.d_sc##c.scper i.d_st##c.stper elect_100K i.st_num i.year  if type=="VS" & res_old==res_new, cl(st_num)
reg ENP i.d_sc##c.scper i.d_st##c.stper  elect_100K i.st_num i.year  if type=="LS", cl(st_num)
reg ind_tot i.d_sc##c.scper i.d_st##c.stper elect_100K i.st_num i.year  if type=="LS", cl(st_num)
reg total10 i.d_sc##c.scper i.d_st##c.stper elect_100K i.st_num i.year  if type=="LS", cl(st_num)
clear
