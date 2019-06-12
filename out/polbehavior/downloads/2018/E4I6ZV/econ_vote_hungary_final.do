clear

cd XXXX

use elections.dta
merge 1:1 telkod year using unemp_rate_election.dta




*** Table 1
xtset telkod year, delta(4)

replace mszp_share=mszp_share*100
replace fidesz_share=fidesz_share*100
replace unemployment_rate=100*unemployment_rate


reg mszp_share l.mszp_s d.unemployment_rate if y==2010 [w=population_total], r
outreg2 using aggregate_ldv.xls, bdec(3) sdec(3) br 

reg fidesz_share l.fidesz_s d.unemployment_rate if y==2014 [w=population_total], r
outreg2 using aggregate_ldv.xls, bdec(3) sdec(3) br append




*** TABLE 2 - Indiv level, survey data

clear

use survey.dta, clear

merge m:1 telkod year month using unemp_rate_all.dta


egen incumbent_vote_mean=mean(incumbent_vote), by (wave)
gen interaction_unemp=unemployment_rate*unemployed


areg incumbent_vote unemployment_rate incumbent_vote_mean [w=weight] if cycle==2 , a(telk) cl(telk)
outreg2 using micro.xls, bdec(3) sdec(3) br 
areg incumbent_vote unemployment_rate incumbent_vote_mean [w=weight] if cycle==3 , a(telk) cl(telk)
outreg2 using micro.xls, bdec(3) sdec(3) br append

areg incumbent_vote unemployment_rate unemployed retired inactive student incumbent_vote_mean  [w=weight] if cycle==2 , a(telk) cl(telk)
outreg2 using micro.xls, bdec(3) sdec(3) br append
areg incumbent_vote unemployment_rate unemployed retired inactive student incumbent_vote_mean  [w=weight] if cycle==3 , a(telk) cl(telk)
outreg2 using micro.xls, bdec(3) sdec(3) br append

areg incumbent_vote unemployment_rate   incumbent_vote_mean  [w=weight] if cycle==2 & works==1 , a(telk) cl(telk)
outreg2 using micro.xls, bdec(3) sdec(3) br append
areg incumbent_vote unemployment_rate   incumbent_vote_mean  [w=weight] if cycle==3 & works==1 , a(telk) cl(telk)
outreg2 using micro.tex, bdec(3) sdec(3) br append

** Appendix

*** TABLE A1 - 


use elections.dta, clear

bysort year: sum incumbent

*** TABLE A2

use unemp_rate_election.dta, clear

bysort  teltip8: sum population_total if year==2014

*** TABLE A3

bysort year: sum unemployment_rate
bysort year: sum unemployment_rate [w= population_total]

*** TABLE A4

use survey.dta, clear
sum incumbent_vote perceived_economy roma young middleaged old female works unemployed retired inactive student elementary vocational secondary tertiary [w=weight]


*** TABLE A5


clear

use elections.dta
merge 1:1 telkod year using  unemp_rate_election.dta


replace mszp_share=mszp_share*100
replace fidesz_share=fidesz_share*100
replace unemployment_rate=100*unemployment_rate
gen pop_less_1000= population_total<1000


xtset telkod year, delta(4)


reg mszp_share l.mszp_s d.unemployment_rate if y==2010 , r
outreg2 using aggregate_ldv_unweighted.xls, bdec(3) sdec(3) br

reg mszp_share l.mszp_s d.unemployment_rate if y==2010 & pop_less_1000==1, r
outreg2 using aggregate_ldv_unweighted.xls, bdec(3) sdec(3) br append

reg mszp_share l.mszp_s d.unemployment_rate if y==2010 & pop_less_1000==0, r
outreg2 using aggregate_ldv_unweighted.xls, bdec(3) sdec(3) br append

reg fidesz_share l.fidesz_s d.unemployment_rate if y==2014 , r
outreg2 using aggregate_ldv_unweighted.xls, bdec(3) sdec(3) br append

reg fidesz_share l.fidesz_s d.unemployment_rate if y==2014 & pop_less_1000==1 , r
outreg2 using aggregate_ldv_unweighted.xls, bdec(3) sdec(3) br append

reg fidesz_share l.fidesz_s d.unemployment_rate if y==2014 & pop_less_1000==0, r
outreg2 using aggregate_ldv_unweighted.xls, bdec(3) sdec(3) br append

*** Table A6

use unemp_rate_all.dta, clear
keep if month==3
xtset telk y
gen unemployment_rate_change_yearly=100*d.unemployment_rate
keep telk year unemployment_rate_change_yearly

save unemp_rate_change_yearly.dta, replace

use elections.dta, clear
merge 1:1 telkod year using  unemp_rate_election.dta
keep if _==3
drop _
merge 1:1 telkod year using  unemp_rate_change_yearly.dta

keep if _==3
drop _
xtset telkod year, delta(4)

replace mszp_share=mszp_share*100
replace fidesz_share=fidesz_share*100
gen unemployment_rate_change_cycle=100*d.unemployment_rate


reg mszp_share l.mszp_s unemployment_rate_change_cycle if y==2010 [w=population_total], r
outreg2 using aggregate_ldv_timing.xls, bdec(3) sdec(3) br 

reg mszp_share l.mszp_s unemployment_rate_change_yearly if y==2010 [w=population_total], r
outreg2 using aggregate_ldv_timing.xls, bdec(3) sdec(3) br append

reg fidesz_share l.fidesz_s unemployment_rate_change_cycle if y==2014 [w=population_total], r
outreg2 using aggregate_ldv_timing.xls, bdec(3) sdec(3) br append

reg fidesz_share l.fidesz_s unemployment_rate_change_yearly if y==2014 [w=population_total], r
outreg2 using aggregate_ldv_timing.xls, bdec(3) sdec(3) br append

*** Figure

use unemp_monthly.dta, clear
merge m:m telkod year using  demography.dta
collapse (sum) population_18_59 unemployed_count, by (year month)
keep if year>2001
gen date=mdy(month, 1, year)
gen date_m=ym(year ,month)
tsset date_, monthl
gen national_unemp_rate= unemployed_count/ population_18_59
tssmooth ma national_unemp_rate_smooth = national_unemp_rate, window(12 1 12)
replace national_unemp_rate_smooth=100*national_unemp_rate_smooth
tsset date, daily
tsline  national_unemp_rate_smooth ,  tline(9apr2006 11apr2010 6apr2014) tlabel(, format(%dm-CY))
