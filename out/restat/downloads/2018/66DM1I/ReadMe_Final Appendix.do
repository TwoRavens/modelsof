****Do-file for Online Appendix "Infant Health Care and Long-Term Outcomes"
set matsize 1600
clear
cd "/home1/katrine/AlineKatrineKjell/data/170215"

************************
*Figure A1**************
*Rollout of Mother and Child Health Care Centers
************************
use "data_municipality_level.dta"

g open_year=0
replace open_year=3 if open<=1935
replace open_year=2 if open>1935 & open<=1945
replace open_year=1 if open>1945 & open<=1955
spmap open_year using "/data/gis/norge/kommune/koordinatkommune.dta", id(kommune) fcolor(white gs13 gs9 gs0) title() legend(ring(0) position(4)) plotregion(icolor(white)) clmethod(custom)  clbreaks(0 0.99 1.99 2.99 3) 
graph export "map_opening.eps", as(eps) preview(off) replace 

************************
*Figure A2**************
*Number of Openings per Year
************************
drop if open==.
collapse (count) open_year, by(open)
twoway (line open_year open), xtitle(Year) ytitle(Number of openings) scheme(s2mono) graphregion(fcolor(white) ifcolor(white) ilcolor(white))
graph export "openings.eps", as(eps) preview(off) replace 

************************
*Figure A3**************
*Uptake Relative to the Opening Years of Mother and Child Health Care Centers
************************
clear 
use "uptake_figure.dta"
g time=0 if year==open_year
replace time=-1 if year==open_year+1
replace time=-2 if year==open_year+2
replace time=-3 if year==open_year+3
replace time=-4 if year==open_year+4
replace time=1 if year==open_year-1
replace time=2 if year==open_year-2
replace time=3 if year==open_year-3
replace time=4 if year==open_year-4
collapse (mean) uptake, by(time)
twoway (scatter uptake time), xtitle(Year relative to opening of health care center) ytitle(Uptake rate) scheme(s2mono) graphregion(fcolor(white) ifcolor(white) ilcolor(white))
graph export "uptake_rawdata.eps", as(eps) preview(off) replace 

************************
*Table A1***************
*Descriptive Statistics
************************
clear
use "data_individual_level.dta"
*keep individuals bron from 1936-1960
keep if yob>1935 & yob<1961
*drop Oslo and Bergen
drop if fodes==301|fodes==1201
*drop municiaplities outside of mainland Norway (e.g. Svalbard)
drop if fodes>2000
*drop if gender is missing
drop if female<0 | female==.
*drop if mother's id is missing
drop if nmpid==.
drop if open==. 
*outcomes
*(column 1 - whole sample)
sum eduy pearnallyears pearn3150 bmi bloodp_s height
*(column 2 - men)
sum eduy pearnallyears pearn3150 bmi bloodp_s height if female==0
*(column 3 - women)
sum eduy pearnallyears pearn3150 bmi bloodp_s height if female==1

*Municipality-level controls
clear
use "data_municipality_level.dta"
*(column 1 - whole sample)
sum lege_pop jmor_pop HS1930 someHS1930 snittinntekt_m snittinntekt_f by pop tbpop30 infant_mort30 stratio6



************************
*Figure B1**************
*Event-Study Estimates of the Impact of Exposure to a Mother and Child Health Care Center on Education and Income
************************
clear
use "data_individual_level.dta"
*keep individuals bron from 1936-1960
keep if yob>1935 & yob<1961
*drop Oslo and Bergen
drop if fodes==301|fodes==1201
*drop municiaplities outside of mainland Norway (e.g. Svalbard)
drop if fodes>2000
*drop if gender is missing
drop if female<0 | female==.
*drop if mother's id is missing
drop if nmpid==.

*generating leads and lags
g t_b1=1 if yob==open-1 & yob!=. & open!=.
replace t_b1=0 if t_b1==. & yob!=.
g t_b2=1 if yob==open-2 & yob!=. & open!=.
replace t_b2=0 if t_b2==. & yob!=.
g t_b3=1 if yob==open-3 & yob!=. & open!=.
replace t_b3=0 if t_b3==. & yob!=.
g t_b4=1 if yob==open-4 & yob!=. & open!=.
replace t_b4=0 if t_b4==. & yob!=.
g t_b5=1 if yob==open-5 & yob!=. & open!=.
replace t_b5=0 if t_b5==. & yob!=.
g t_b6=1 if yob==open-6 & yob!=. & open!=.
replace t_b6=0 if t_b6==. & yob!=.
g t_b7=1 if yob==open-7 & yob!=. & open!=.
replace t_b7=0 if t_b7==. & yob!=.
g t_b8=1 if yob==open-8 & yob!=. & open!=.
replace t_b8=1 if yob>open-8 & yob!=. & open!=.
replace t_b8=0 if t_b8==. & yob!=.


g t_a1=1 if yob==open+1 & yob!=. & open!=.
replace t_a1=0 if t_a1==. & yob!=.
g t_a2=1 if yob==open+2 & yob!=. & open!=.
replace t_a2=0 if t_a2==. & yob!=.
g t_a3=1 if yob==open+3 & yob!=. & open!=.
replace t_a3=0 if t_a3==. & yob!=.
g t_a4=1 if yob==open+4 & yob!=. & open!=.
replace t_a4=0 if t_a4==. & yob!=.
g t_a5=1 if yob==open+5 & yob!=. & open!=.
replace t_a5=0 if t_a5==. & yob!=.
g t_a6=1 if yob==open+6 & yob!=. & open!=.
replace t_a6=0 if t_a6==. & yob!=.
g t_a7=1 if yob==open+7 & yob!=. & open!=.
replace t_a7=0 if t_a7==. & yob!=.
g t_a8=1 if yob==open+8 & yob!=. & open!=.
replace t_a8=1 if yob<open+8 & yob!=. & open!=.
replace t_a8=0 if t_a8==. & yob!=.


gen main_b1=treat_mun*t_b1
gen main_b2=treat_mun*t_b2
gen main_b3=treat_mun*t_b3
gen main_b4=treat_mun*t_b4
gen main_b5=treat_mun*t_b5
gen main_b6=treat_mun*t_b6
gen main_b7=treat_mun*t_b7
gen main_b8=treat_mun*t_b8

gen main_a1=treat_mun*t_a1
gen main_a2=treat_mun*t_a2
gen main_a3=treat_mun*t_a3
gen main_a4=treat_mun*t_a4
gen main_a5=treat_mun*t_a5
gen main_a6=treat_mun*t_a6
gen main_a7=treat_mun*t_a7
gen main_a8=treat_mun*t_a8

*Education
preserve
*keep eventually open center 
drop if open==. 
xi: quietly reg eduy main_b8 main_b7 main_b6 main_b5 main_b4 main_b3 main_b2 main main_a1 main_a2 main_a3 main_a4 main_a5 main_a6 main_a7 main_a8 i.yob i.fodes female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss, cluster(fodes)
est store AKK1
restore
esttab AKK1, keep(main_b8 main_b7 main_b6 main_b5 main_b4 main_b3 main_b2 main main_a1 main_a2 main_a3 main_a4 main_a5 main_a6 main_a7 main_a8) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)
coefplot (AKK1, label(Education)), ///
	keep(main_b8 main_b7 main_b6 main_b5 main_b4 main_b3 main_b2 main main_a1 main_a2 main_a3 main_a4 main_a5 main_a6 main_a7 main_a8) vertical yline(0) ciopts(recast(rcap)) ///
	coeflabel (main_b8= "-8" main_b7= "-7" main_b6= "-6" main_b5= "-5" main_b4= "-4" main_b3= "-3" main_b2= "-2" main= "0" main_a4= "4" main_a3= "3" main_a2= "2" main_a1= "1" main_a5= "5" main_a6= "6" main_a7= "7" main_a8= "8") ///
	levels(90 95) scheme(s1mono)
graph export "granger_edu8.eps", as(eps) preview(off) replace

*Earnings 1967-2010, conditional on observing education
preserve
*keep eventually open center 
drop if open==. 
xi: quietly reg pearnallyears main_b8 main_b7 main_b6 main_b5 main_b4 main_b3 main_b2 main main_a1 main_a2 main_a3 main_a4 main_a5 main_a6 main_a7 main_a8 i.yob i.fodes female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if eduy!=., cluster(fodes)
est store AKK1
restore
esttab AKK1, keep(main_b8 main_b7 main_b6 main_b5 main_b4 main_b3 main_b2 main main_a1 main_a2 main_a3 main_a4 main_a5 main_a6 main_a7 main_a8) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)
coefplot (AKK1, label(Income)), ///
	keep(main_b8 main_b7 main_b6 main_b5 main_b4 main_b3 main_b2 main main_a1 main_a2 main_a3 main_a4 main_a5 main_a6 main_a7 main_a8) vertical yline(0) ciopts(recast(rcap)) ///
	coeflabel (main_b8= "-8" main_b7= "-7" main_b6= "-6" main_b5= "-5" main_b4= "-4" main_b3= "-3" main_b2= "-2" main= "0" main_a4= "4" main_a3= "3" main_a2= "2" main_a1= "1" main_a5= "5" main_a6= "6" main_a7= "7" main_a8= "8") ///
	levels(90 95) scheme(s1mono)
graph export "granger_inc8.eps", as(eps) preview(off) replace


************************
*Table B1***************
*Robustness Test: Municipality-Specific Time Trends, World War II and School Reform
************************
*generate squard and cubic trend variables
gen trend2=trend*trend
gen trend3=trend*trend*trend
*education
preserve
*keep eventually open center 
drop if open==. 
*(column 1 - baseline)
xi: quietly reg eduy main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss, cluster(fodes)
est store AKK1
*(column 2 - quadratic trend)
xi: quietly reg eduy main i.yob i.fodes i.fodes*trend2 female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss, cluster(fodes)
est store AKK2
*(column 3 - quadratic trend)
xi: quietly reg eduy main i.yob i.fodes i.fodes*trend3 female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss, cluster(fodes)
est store AKK3
*(column 4 - no trend)
xi: quietly reg eduy main i.yob i.fodes female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss, cluster(fodes)
est store AKK4
*(column 5 - WWII)
xi: quietly reg eduy main i.yob i.fodes female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if yob<1940 | yob>1944, cluster(fodes)
est store AKK5
*(column 6 - school reform)
xi: quietly reg eduy main i.yob i.fodes female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss reform miss_reform, cluster(fodes)
est store AKK6
restore
esttab AKK1 AKK2 AKK3 AKK4 AKK5 AKK6, keep(main) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)


*earnings all years conditional on observing education
preserve
*keep eventually open center 
drop if open==. 
*(column 1 - baseline)
xi: quietly reg pearnallyears main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if eduy!=., cluster(fodes)
est store AKK1
*(column 2 - quadratic trend)
xi: quietly reg pearnallyears main i.yob i.fodes i.fodes*trend2 female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if eduy!=., cluster(fodes)
est store AKK2
*(column 3 - quadratic trend)
xi: quietly reg pearnallyears main i.yob i.fodes i.fodes*trend3 female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if eduy!=., cluster(fodes)
est store AKK3
*(column 4 - no trend)
xi: quietly reg pearnallyears main i.yob i.fodes female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if eduy!=., cluster(fodes)
est store AKK4
*(column 5 - WWII)
xi: quietly reg pearnallyears main i.yob i.fodes female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if yob<1940 | yob>1944 & eduy!=., cluster(fodes)
est store AKK5
*(column 6 - school reform)
xi: quietly reg pearnallyears main i.yob i.fodes female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss reform miss_reform if eduy!=., cluster(fodes)
est store AKK6
restore
esttab AKK1 AKK2 AKK3 AKK4 AKK5 AKK6, keep(main) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)

*earnings age 31-50 conditional on observing education
preserve
*keep eventually open center 
drop if open==. 
*(column 1 - baseline)
xi: quietly reg pearn3150 main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if eduy!=., cluster(fodes)
est store AKK1
*(column 2 - quadratic trend)
xi: quietly reg pearn3150 main i.yob i.fodes i.fodes*trend2 female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if eduy!=., cluster(fodes)
est store AKK2
*(column 3 - quadratic trend)
xi: quietly reg pearn3150 main i.yob i.fodes i.fodes*trend3 female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if eduy!=., cluster(fodes)
est store AKK3
*(column 4 - no trend)
xi: quietly reg pearn3150 main i.yob i.fodes female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if eduy!=., cluster(fodes)
est store AKK4
*(column 5 - WWII)
xi: quietly reg pearn3150 main i.yob i.fodes female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if yob<1940 | yob>1944 & eduy!=., cluster(fodes)
est store AKK5
*(column 6 - school reform)
xi: quietly reg pearn3150 main i.yob i.fodes female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss reform miss_reform if eduy!=., cluster(fodes)
est store AKK6
restore
esttab AKK1 AKK2 AKK3 AKK4 AKK5 AKK6, keep(main) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)


************************
*Table B2***************
*Bounds Accounting for Infant Mortality
************************
preserve
*keep eventually open center 
drop if open==. 
xi: quietly reg eduy main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss, cluster(fodes)
predict eduy1

egen p59=pctile(eduy1), p(59)
egen p56=pctile(eduy1), p(56)
egen p60=pctile(eduy1), p(60)
egen p69=pctile(eduy1), p(69)
egen p66=pctile(eduy1), p(66)
egen p70=pctile(eduy1), p(70)
egen p79=pctile(eduy1), p(79)
egen p76=pctile(eduy1), p(76)
egen p80=pctile(eduy1), p(80)
egen p89=pctile(eduy1), p(89)
egen p86=pctile(eduy1), p(86)
egen p90=pctile(eduy1), p(90)
egen p99=pctile(eduy1), p(99)
egen p96=pctile(eduy1), p(96)
egen p100=pctile(eduy1), p(99.9)

gen drop60=1 if eduy1>=p59 & main==1 & eduy1<=p60
gen drop70=1 if eduy1>=p69 & main==1 & eduy1<=p70
gen drop80=1 if eduy1>=p79 & main==1 & eduy1<=p80
gen drop90=1 if eduy1>=p89 & main==1 & eduy1<=p90
gen drop100=1 if eduy1>=p99 & main==1 & eduy1<=p100

*(column 1 - baseline)
xi: quietly  reg eduy main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss, cluster(fodes)
est store AKK1
*(column 2 - 60th percentile)
xi: quietly  reg eduy main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if drop60!=1, cluster(fodes)
est store AKK2
*(column 3 - 70th percentile)
xi: quietly  reg eduy main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if drop70!=1, cluster(fodes)
est store AKK3
*(column 4 - 80th percentile)
xi: quietly  reg eduy main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if drop80!=1, cluster(fodes)
est store AKK4
*(column 5 - 90th percentile)
xi: quietly  reg eduy main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if drop90!=1, cluster(fodes)
est store AKK5
*(column 6 - 100th percentile)
xi: quietly  reg eduy main i.yob i.fodes i.fodes*trend female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss if drop100!=1, cluster(fodes)
est store AKK6
esttab AKK1 AKK2 AKK3 AKK4 AKK5 AKK6, keep(main) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)
restore

************************
*Figure C1**************
*Event-Study Estimates of the Impact of Exposure to a Mother and Child Health Care Center on Health Outcomes
************************
*Health Index
preserve
*keep observations included in the health surveys
keep if conor==1 | age40==1
*keep eventually open center 
drop if open==. 
xi: quietly reg health_index main_b8 main_b7 main_b6 main_b5 main_b4 main_b3 main_b2 main main_a1 main_a2 main_a3 main_a4 main_a5 main_a6 main_a7 main_a8 i.yob i.fodes female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss, cluster(fodes)
est store AKK1
restore
esttab AKK1, keep(main_b8 main_b7 main_b6 main_b5 main_b4 main_b3 main_b2 main main_a1 main_a2 main_a3 main_a4 main_a5 main_a6 main_a7 main_a8) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)
coefplot (AKK1, label(Health Index)), ///
	keep(main_b8 main_b7 main_b6 main_b5 main_b4 main_b3 main_b2 main main_a1 main_a2 main_a3 main_a4 main_a5 main_a6 main_a7 main_a8) vertical yline(0) ciopts(recast(rcap)) ///
	coeflabel (main_b8= "-8" main_b7= "-7" main_b6= "-6" main_b5= "-5" main_b4= "-4" main_b3= "-3" main_b2= "-2" main= "0" main_a4= "4" main_a3= "3" main_a2= "2" main_a1= "1" main_a5= "5" main_a6= "6" main_a7= "7" main_a8= "8") ///
	levels(90 95) scheme(s1mono)
graph export "granger_index8.eps", as(eps) preview(off) replace

*Height
preserve
*keep observations included in the health surveys
keep if conor==1 | age40==1
*keep eventually open center 
drop if open==. 
xi: quietly reg height main_b8 main_b7 main_b6 main_b5 main_b4 main_b3 main_b2 main main_a1 main_a2 main_a3 main_a4 main_a5 main_a6 main_a7 main_a8 i.yob i.fodes female m_eduy70 miss_m_eduy70 m_agebirth miss_m_agebirth f_eduy70 miss_f_eduy70 f_agebirth miss_f_agebirth m_married miss_m_married border miss_border legepop miss_legepop stratio6 miss_stratio pop pop_miss, cluster(fodes)
est store AKK1
restore
esttab AKK1, keep(main_b8 main_b7 main_b6 main_b5 main_b4 main_b3 main_b2 main main_a1 main_a2 main_a3 main_a4 main_a5 main_a6 main_a7 main_a8) cells(b(star fmt(3)) se(par fmt(3))) star(* 0.10 ** 0.05 *** 0.01)
coefplot (AKK1, label(Income)), ///
	keep(main_b8 main_b7 main_b6 main_b5 main_b4 main_b3 main_b2 main main_a1 main_a2 main_a3 main_a4 main_a5 main_a6 main_a7 main_a8) vertical yline(0) ciopts(recast(rcap)) ///
	coeflabel (main_b8= "-8" main_b7= "-7" main_b6= "-6" main_b5= "-5" main_b4= "-4" main_b3= "-3" main_b2= "-2" main= "0" main_a4= "4" main_a3= "3" main_a2= "2" main_a1= "1" main_a5= "5" main_a6= "6" main_a7= "7" main_a8= "8") ///
	levels(90 95) scheme(s1mono)
graph export "granger_height8.eps", as(eps) preview(off) replace



************************
*Table C1***************
*Test of the Identifying Assumption: the Effect of Municipality Characteristics on the Timing of a Center Opening
************************
clear
use "data_municipality_level.dta"
*column 1
reg open_ever HS1930 someHS1930 snittinntekt_m snittinntekt_f lege_pop jmor_pop by pop tbpop30 infant_mort30 
*column 2
reg open_year HS1930 someHS1930 snittinntekt_m snittinntekt_f lege_pop jmor_pop by pop tbpop30 infant_mort30 if open_ever==1
*column 3
reg open_ever c_HS c_someHS c_legepop c_jmorpop c_by c_pop c_tb c_infm 
*column 2
reg open_year c_HS c_someHS c_legepop c_jmorpop c_by c_pop c_tb c_infm if open_ever==1

 
