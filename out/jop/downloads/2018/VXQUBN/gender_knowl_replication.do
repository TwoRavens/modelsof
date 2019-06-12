cd "/Users/paulschuler/Dropbox/projects/gender knowledge"
set more off 
clear

use papi_gender

*Table 2
tab know_any  if nac==1 & year==2015 & female==1
tab know_any  if nac==0 & year==2015 & female==1
tab know_any  if nac==1 & year==2016 & female==1
tab know_any  if nac==0 & year==2016 & female==1
tab know_any  if nac==1 & year==2017 & female==1
tab know_any  if nac==0 & year==2017 & female==1
tab know_any  if nac==1 & year==2015 & female==0
tab know_any  if nac==0 & year==2015 & female==0
tab know_any  if nac==1 & year==2016 & female==0
tab know_any  if nac==0 & year==2016 & female==0
tab know_any  if nac==1 & year==2017 & female==0
tab know_any  if nac==0 & year==2017 & female==0

*Appendix 2
tab know_any female, col
tab aware_corruption female, col
tab aware_term female, col
tab aware_tpp female, col
tab propose female, col
tab contact female, col
tab attend_meeting female, col
tab vote female, col

*Table 3/Appendix 5
prob know_any i.female##i.nac##i.yearx  read_news  civil_society2 kinh age poor education_pc, cluster(xa)
outreg2 using t3, e(all) replace
margins female, dydx(yearx) at(nac=(0(1)1))
marginsplot, ytitle("Effect of 2016 Transition on Leader Awareness") title("") xtitle("") xlabel(-.2 "." 0 `""President/PM""General Secretary""' 1 `""VNA""Chair""' 1.2 ".", labsize(vsmall))  ///
  graphregion(color(white)) 
graph save f1, replace

prob know_any i.female##i.nac##i.year  read_news  civil_society2 kinh age poor education_pc if year!=2017, cluster(xa)
outreg2 using t3, e(all) 

prob know_any i.female##i.nac##i.year  read_news  civil_society2 kinh age poor education_pc if year!=2016, cluster(xa)
outreg2 using female_knowledge, e(all) excel


* Appendix 6.1/Interactions
prob know_any c.education_pc##i.nac##i.yearx    civil_society2 read_news kinh age poor if female==1, cluster(xa)
outreg2 using a6_1, e(all) replace

prob know_any i.read_news##i.nac##i.yearx    civil_society2  kinh age education_pc poor if female==1, cluster(xa)
outreg2 using a6_1, e(all) 

prob know_any c.age##i.nac##i.yearx  civil_society2  read_news kinh  poor education_pc if female==1, cluster(xa)
outreg2 using a6_1, e(all) 

prob know_any i.civil_society2##i.nac##i.yearx  read_news   kinh age poor education_pc if female==1, cluster(xa)
outreg2 using a6_1, e(all) excel

prob know_any i.civil_society2##i.nac##i.yearx  read_news   kinh age poor education_pc if female==1, cluster(xa)
margins civil_society2, dydx(yearx) at(nac=(0(1)1))
marginsplot, ytitle("Effect of 2016 Transition on Leader Awareness") title("") xtitle("") ///
xlabel(-.2 "." 0 `""President/PM""General Secretary""' 1 `""VNA""Chair""' 1.2 ".", labsize(vsmall))  graphregion(color(white))
graph save f6_2, replace

prob know_any i.civil_society2##i.nac##i.year   read_news  kinh age poor education_pc if female==1 & year!=2017, cluster(xa)
margins civil_society2, dydx(year) at(nac=(0(1)1))

prob know_any i.civil_society2##i.nac##i.year  read_news   kinh age poor education_pc if female==1 & year!=2016, cluster(xa)
margins civil_society2, dydx(year) at(nac=(0(1)1))



*Appenedix 7.1
prob watch_na i.female##i.yearx  civil_society2 read_news   kinh age poor education_pc, cluster(xa)
outreg2 using a7_1, e(all) replace
margins female, dydx(yearx)
marginsplot, ytitle("Effect of 2016 Transition on Watching VNA Queries") title("") xtitle("") xlabel(-.2 "." 0 "Male" 1 "Female" 1.2 ".", labsize(vsmall))  ///
legend( size(vsmall)) graphregion(color(white))
graph save f7_2, replace

prob watch_na i.female##i.yearx  civil_society2 read_news   kinh age poor education_pc if year!=2017, cluster(xa)
outreg2 using a7_1, e(all) 


prob watch_na i.female##i.yearx  civil_society2 read_news   kinh age poor education_pc if year!=2016, cluster(xa)
outreg2 using a7_1, e(all) excel




