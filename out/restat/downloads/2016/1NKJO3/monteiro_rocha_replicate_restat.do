
*************************************************************************************************
*************************************************************************************************
*THIS DO-FILE CREATES ALL THE TABLES AND FIGURES SHOWN 
*IN THE PAPER "DRUG BATTLES AND SCHOOL ACHIEVEMENT: EVIDENCE FROM RIO DE JANEIRO´S FAVELAS"
*************************************************************************************************
*************************************************************************************************

cd "write directory path here"
set matsize 1000
set more off

*************************************************************************************************
*************************************************************************************************
*PAPER
*************************************************************************************************
*************************************************************************************************


********************************************************************************************************************************************
* TABLE 1 - MAIN RESULTS: EFFECTS ON STUDENT ACHIEVEMENT
********************************************************************************************************************************************

insheet using "Databases\data_students.txt", comma clear case
global controls "i.age i.boy i.mother_educ i.white i.repeated i.dropped  kitchen principal_office science_lab computer_lab  school_lunch teacher_office boys_class nonwhite_class age_class work_class repeated_class dropped_class"

foreach y of varlist math_score language_score {

xi: reg  `y'  d2 i.year if d250m==1 , cluster(id_school) 
	outreg2 using Tables/Table1.xls, aster(se) dec(3)  label keep(d2) nocons  addtext(Year FE, Y, Student and Class Charact, N, Infrastructure, N, School FE, N)

xi: reg `y'   d2 i.year $controls if d250m==1, cluster(id_school) 
	outreg2 using Tables/Table1.xls, aster(se) dec(3)  label keep(d2) nocons   addtext(Year FE, Y, Student and Class Charact, Y, Infrastructure, Y, School FE, N)

xi: areg `y'   d2 i.year $controls if d250m==1, cluster(id_school)  abs(id_school)
	outreg2 using Tables/Table1.xls, aster(se) dec(3)  label keep(d2) nocons   addtext(Year FE, Y, Student and Class Charact, Y, Infrastructure, Y, School FE, Y)
}



********************************************************************************************************************************************
* TABLE 2 - VIOLENCE EFFECTS ON TEACHERS' ABSENTEEISM AND MEDICAL LEAVES
********************************************************************************************************************************************

insheet using "Databases\data_schools.txt", comma clear case
global school  "number_teachers kitchen principal_office science_lab computer_lab  school_lunch teacher_office"
global teachers  "age_teachers male_teachers undergrad_teachers grad_teachers"

foreach y in  share_absent absences_average share_onleave onleave_average   {
xi: areg  `y' d2 i.year $teachers $school  if count==2, r abs(id_school)
	sum `y' if e(sample)==1
	eret2 scalar y_mean=r(mean)
	outreg2 using Tables/Table2.xls, aster(se) dec(3)  label nocons e(y_mean) keep(d2) addtext(Year FE, Y, School FE,Y)
}

foreach y in  share_absent absences_average share_onleave onleave_average   {
xi: areg  `y' dcontiguous  d2Ncontiguous i.year $teachers $school if count==2, r abs(id_school)
	sum  `y' if e(sample)==1
	eret2 scalar y_mean=r(mean)
	outreg2 using Tables/Table2.xls, aster(se) dec(3) e(y_mean)  label nocons keep (dcontiguous  d2Ncontiguous) addtext(Year FE, Y, School FE,Y)
}
*

********************************************************************************************************************************************
* TABLE 3 - CHANNELS: VIOLENCE EFFECT ON SCHOOL ROUTINE
********************************************************************************************************************************************

insheet using "Databases\data_schools.txt", comma clear case
global infra  "kitchen principal_office science_lab computer_lab  school_lunch teacher_office"
global teachers  "age_teachers male_teachers undergrad_teachers grad_teachers"
global students_test "number_stud_school males_test white_test higheduc_mother_test age_test dropped_test repeated_test"


*PANEL A
foreach y in interrup student_absence turnover new_principal threat_teacher threat_student {
xi: areg  `y'_yes d2  `y'_miss i.year $teachers $infra $students_test if count==2, r abs(id_school)	
	sum  `y'_yes if e(sample)==1
	eret2 scalar y_mean=r(mean)
	outreg2 using Tables\Table3.xls, aster(se) dec(3) e(y_mean) label nocons keep (d2) addtext(Year FE, Y, School FE,Y)
}

*PANEL B
foreach y in interrup student_absence turnover new_principal threat_teacher threat_student {
xi: areg  `y'_yes  dcontiguous  d2Ncontiguous `y'_miss i.year $teachers $infra $students_test if count==2, r abs(id_school)
	sum  `y'_yes if e(sample)==1
	eret2 scalar y_mean=r(mean)
	outreg2 using Tables\Table3.xls, aster(se) dec(3) e(y_mean) label nocons keep (dcontiguous  d2Ncontiguous) addtext(Year FE, Y, School FE,Y)
}
*



********************************************************************************************************************************************
*Figure 1a: Impact on Math Test Scores by Violence Distance (buffer of distance from the school to the conflict location, in meters)
********************************************************************************************************************************************

insheet using "Databases\data_students.txt", comma clear case
global controls "i.age i.boy i.mother_educ i.white i.repeated i.dropped  kitchen principal_office science_lab computer_lab  school_lunch teacher_office boys_class nonwhite_class age_class work_class repeated_class dropped_class"

tempfile tf250 tf300 tf350 tf400 tf450 tf500 tf750  
foreach x in 250 300 350 400 450 500 750 {
parmby "xi: areg math_score d2_`x'm  $controls  i.year if  d`x'm==1, cluster(id_school) abs(id_school)", ///
	   level(90 95) cln(rank) for(estimate min* max* stderr %8.3f) list(parm estimate min2 min1 max1 max2, clean noobs) ///
	   saving(`"`tf`x''"', replace) idn(`x') 
}
drop _all
append using `"`tf250'"' `"`tf300'"' `"`tf350'"' `"`tf400'"' `"`tf450'"' `"`tf500'"' `"`tf750'"' 
keep if parmseq==1

gen n=_n
label define n 1 "250" 2 "300" 3 "350" 4 "400" 5 "450" 6 "500" 7 "750"
label values n n

twoway (connect estimate n, sort scheme(s1mono) mcolor(black) yline(0, lwidth(vvvthin)) xlabel(#8) xtick(#8) xlabel(, valuelabel)  ///
		xtitle("Distance between the school and the favela exposed to violence (meters)") ytitle("Effect in standard deviation") ylabel(,format(%3.2f)) ///
		legend(order(1 "Point estimate" 2 "90% Confidence Interval" 4 "95% Confidence Interval")) legend(region(lwidth(none)))) ///
	   (line min1 n, sort lcolor(gs6) lpattern(vshortdash)) (line max1 n, sort lcolor(gs6) lpattern(vshortdash)) ///
	   (line min2 n, sort lcolor(gs4) lpattern(longdash)) (line max2 n, sort lcolor(gs4) lpattern(longdash))
graph export Figures\Figure1a.eps, replace	   


**************************************************************************************************************************
*Figure 1b: Impact on Math Test Scores by Violence Intensity (number of days during the school period)
**************************************************************************************************************************

insheet using "Databases\data_students.txt", comma clear case
global controls "i.age i.boy i.mother_educ i.white i.repeated i.dropped  kitchen principal_office science_lab computer_lab  school_lunch teacher_office boys_class nonwhite_class age_class work_class repeated_class dropped_class"
keep if d250m==1

tempfile tf1 tf2  tf3 tf4 tf5 tf6 tf7 tf8 tf9
foreach x in 1 2 3 4 5 6 7 8 9  {
parmby "xi: areg math_score d`x' i.year  $controls, cluster(id_school) abs(id_school)", ///
	   level(90 95) cln(rank) for(estimate min* max* stderr %8.3f) list(parm estimate min2 min1 max1 max2, clean noobs) ///
	   saving(`"`tf`x''"', replace) idn(`x') 
}
drop _all
append using `"`tf1'"' `"`tf2'"' `"`tf3'"' `"`tf4'"' `"`tf5'"' `"`tf6'"' `"`tf7'"' `"`tf8'"' `"`tf9'"'
keep if parmseq==1

label define idnum 1 "1+" 2 "2+" 3 "3+" 4 "4+" 5 "5+" 6 "6+" 7 "7+" 8 "8+" 9 "+9"
label values idnum idnum

twoway (connect estimate idnum, sort scheme(s1mono) mcolor(black) yline(0, lwidth(vvvthin)) xlabel(#9) xtick(#9)  xlabel(, valuelabel) ///
		xtitle("Number of days with conflict during the academic year") ytitle("Effect in standard deviation") ylabel(,format(%3.2f)) ///
		legend(order(1 "Point estimate" 2 "90% Confidence Interval" 4 "95% Confidence Interval")) legend(region(lwidth(none)))) ///
	   (line min1 idnum, sort lcolor(gs6) lpattern(vshortdash)) (line max1 idnum, sort lcolor(gs6) lpattern(vshortdash)) ///
	   (line min2 idnum, sort lcolor(gs4) lpattern(longdash)) (line max2 idnum, sort lcolor(gs4) lpattern(longdash))
graph export Figures\Figure1b.eps, replace	   
	   

**************************************************************************************************************************
*Figure 1c: Impact on Math Test Scores by the Timing of the Violence (violence indicator computed by trimester)
**************************************************************************************************************************

insheet using "Databases\data_students.txt", comma clear case
global controls "i.age i.boy i.mother_educ i.white i.repeated i.dropped  kitchen principal_office science_lab computer_lab  school_lunch teacher_office boys_class nonwhite_class age_class work_class repeated_class dropped_class"

tempfile tflag3_d2_1trim tflag3_d2_2trim  tflag3_d2_3trim tflag3_d2_4trim tflag2_d2_1trim tflag2_d2_2trim tflag2_d2_3trim tflag2_d2_4trim tflag1_d2_1trim tflag1_d2_2trim tflag1_d2_3trim tflag1_d2_4trim tfd2_1trim tfd2_2trim tfd2_3trim tfd2_4trim tflead1_d2_1trim tflead1_d2_2trim tflead1_d2_3trim tflead1_d2_4trim
parmby "xi: areg math_score lag3_d2_1trim   $controls  i.year if d250m==1 , cluster(id_school) abs(id_school)", ///
	   level(90 95) cln(rank) for(estimate min* max* stderr %8.3f) list(parm estimate min2 min1 max1 max2, clean noobs) ///
	   saving(`"`tflag3_d2_1trim'"', replace)  

foreach x in lag3_d2_2trim lag3_d2_3trim lag3_d2_4trim lag2_d2_1trim lag2_d2_2trim lag2_d2_3trim lag2_d2_4trim lag1_d2_1trim lag1_d2_2trim lag1_d2_3trim lag1_d2_4trim d2_1trim d2_2trim d2_3trim d2_4trim lead1_d2_1trim lead1_d2_2trim lead1_d2_3trim lead1_d2_4trim {
parmby "xi: areg math_score `x'   $controls  i.year , cluster(id_school) abs(id_school)", ///
	   level(90 95) cln(rank) for(estimate min* max* stderr %8.3f) list(parm estimate min2 min1 max1 max2, clean noobs) ///
	   saving(`"`tf`x''"', replace) 
}
drop _all
append using `"`tflag3_d2_1trim'"' `"`tflag3_d2_2trim'"' `"`tflag3_d2_3trim'"' `"`tflag3_d2_4trim'"' `"`tflag2_d2_1trim '"' `"`tflag2_d2_2trim'"' `"`tflag2_d2_3trim'"' `"`tflag2_d2_4trim'"' `"`tflag1_d2_1trim'"' `"`tflag1_d2_2trim'"' `"`tflag1_d2_3trim'"' `"`tflag1_d2_4trim'"' `"`tfd2_1trim'"' `"`tfd2_2trim'"' `"`tfd2_3trim'"' `"`tfd2_4trim'"' `"`tflead1_d2_1trim'"' `"`tflead1_d2_2trim'"' `"`tflead1_d2_3trim'"' `"`tflead1_d2_4trim'"'
keep if parmseq==1

gen n=_n
label define n 1 "1st Q (Year -3)" 2 "2nd Q (Year -3)" 3 "3rd Q (Year -3)" 4 "4th Q (Year -3)" ///
5 "1st Q (Year -2)" 6 "2nd Q (Year -2)" 7 "3rd Q (Year -2)" 8 "4th Q (Year -2)" 9 "1st Q (Year -1)" ///
10 "2nd Q (Year -1)" 11 "3rd Q (Year -1)" 12 "4th Q (Year -1)" 13 "1st Q" 14 "2nd Q" 15 "3rd Q" ///
16 "4th Q" 17 "1st Q (Year +1)" 18 "2nd Q (Year +1)" 19 "3rd Q (Year +1)" 20 "4th Q (Year +1)"
label values n n

twoway (connect estimate n, sort scheme(s1mono) mcolor(black) yline(0, lwidth(vvvthin)) xline(16, lwidth(vvvthin)) xlabel(#20) xtick(#20) xlabel(, valuelabel angle(90) labsize(small))  ///
		xtitle("") ytitle("") ylabel(,format(%3.2f)) ///
		legend(order(1 "Point estimate" 2 "90% Confidence Interval" 4 "95% Confidence Interval")) legend(region(lwidth(none)))) ///
	   (line min1 n, sort lcolor(gs6) lpattern(vshortdash)) (line max1 n, sort lcolor(gs6) lpattern(vshortdash)) ///
	   (line min2 n, sort lcolor(gs4) lpattern(longdash)) (line max2 n, sort lcolor(gs4) lpattern(longdash))
graph export Figures\Figure1c.eps, replace	   
	   
	   

	   
	   

	   

*************************************************************************************************
*************************************************************************************************
*WEB-APPENDIX
*************************************************************************************************
*************************************************************************************************


***********************************************************************************
* TABLE B1 - DISQUE-DENUNCIA DATABASE SUMMARY STATISTICS
***********************************************************************************

* PANEL A 
insheet using "Databases\data_reports_favela.txt", comma clear case

*Total number of reports between 2003-2009
tabstat total_reports_favela, stat(sum)
*Reporting gunfight
tabstat  gun_reports_favela, stat(sum)
*Reporting gunfight on favelas 
tabstat  gun_reports_favela if id_favela~=8888, stat(sum)
*Reporting gunfight other places
tabstat  gun_reports_favela if id_favela==8888, stat(sum)
*Total number of favelas with reports (max of group indicates the number)
egen group=group(id_favela)
sum group


*PANEL B
*Create a balanced panel to analyze frequency of reports at violent favela
collapse (sum)   gun_reports_favela days_gun_reports_favela, by(id_favela year)

reshape wide  gun_reports_favela days_gun_reports_favela, i(id_favela) j(year)
reshape long  gun_reports_favela days_gun_reports_favela, i(id_favela) j(year)
recode  gun_reports_favela days_gun_reports_favela (.=0)
*drop reports that are not located in favelas
drop if id_favela==8888
sort id_favela year

*Generate Panel B
*column 1
sum  gun_reports_favela, detail 
*column 2
egen sum_reports=sum( gun_reports_favela), by(id_favela)
egen tag_favela=tag(id_favela)
sum sum_report if tag_favela==1, detail
*column 3
sum days_gun_reports_favela, detail 
*column 4
egen sum_days_reports=sum(days_gun_reports_favela), by(id_favela)
sum sum_days_reports if tag_favela==1, detail


**************************************************************************************************************************
*Figure B1: DISTRIBUTION OF THE NUMBER OF REPORTS AND THE NUMBER OF DAYS WITH CONFLICT
**************************************************************************************************************************

insheet using "Databases\data_reports_favela.txt", comma clear case

*Create a balanced panel to analyze frequency of reports at violent favela
collapse (sum)   gun_reports_favela days_gun_reports_favela, by(id_favela year)

reshape wide  gun_reports_favela days_gun_reports_favela, i(id_favela) j(year)
reshape long  gun_reports_favela days_gun_reports_favela, i(id_favela) j(year)
recode  gun_reports_favela days_gun_reports_favela (.=0)
*drop reports that are not located in favelas
sort id_favela year

foreach i in 2005 2007 2009 {
hist gun_reports_favela if year==`i' , percent width(1) title(`i') xtitle("Number of reports") ytitle("Percentage of favelas") scheme(s1mono) name(fig_reports_favela`i', replace) nodraw
hist days_gun_reports_favela if year==`i' , percent width(1) title(`i') xtitle("Number of days with reports") ytitle("Percentage of favelas") scheme(s1mono) name(fig_days_reports_favela`i', replace) nodraw
}

graph combine fig_reports_favela2005 fig_reports_favela2007 fig_reports_favela2009 fig_days_reports_favela2005 fig_days_reports_favela2007 fig_days_reports_favela2009, scheme(s1mono)
graph export Figures\FigureB1.eps, replace	   




**************************************************************************************************************************
*Figure B2: NUMBER OF DAYS WITH GUNFIGHTS PER YEAR IN SELECTED FAVELAS - 2003-2009
**************************************************************************************************************************

insheet using "Databases\data_reports_favela.txt", comma clear case

*Create a balanced panel to analyze frequency of reports at violent favela
collapse (sum)   gun_reports_favela days_gun_reports_favela, by(id_favela year)

tostring year, replace
gen year2=substr(year,3,4)

gen name="V Pinheiro" if id_favela==1076
replace name="Sao Carlos" if id_favela==12
replace name="Morro do Urubu" if id_favela==146
replace name="Moquico" if id_favela==871
replace name="Morro Sao Joao" if id_favela==176
replace name="Morro Juramento" if id_favela==195
replace name="Morro dos Macacos" if id_favela==80
replace name="Nova Kennedy" if id_favela==381
replace name="Fumace" if id_favela==1324
replace name="Catumbi" if id_favela==13

gen sample1=( id_favela==146 |   id_favela==871 |  id_favela==176 |  id_favela==1076 |   id_favela==12)
gen sample2=( id_favela==195 |   id_favela==80 |  id_favela==381 |  id_favela==1324 |   id_favela==13)

graph bar (sum) days_gun_reports_favela if sample2 ==1,  over(year2, label(labsize(2))) scheme(s1mono) over(name, label(labsize(2.5) alternate)) ytitle("Number of days with conflicts")  yscale(range(0 40))  ylab(,nogrid)
graph export Figures\FigureB2a.eps, replace

graph bar (sum) days_gun_reports_favela if sample1 ==1,  over(year2, label(labsize(2))) scheme(s1mono) over(name, label(labsize(2.5) alternate)) ytitle("Number of days with conflicts")  yscale(range(0 40)) ytick(#5) ylabel(#5) ylab(,nogrid)
graph export Figures\FigureB2b.eps, replace



*********************************************************************
* TABLE B2 - EDUCATION SUMMARY STATISTICS
*********************************************************************

* PANELS A AND B 

	* A - Student-level variables (Prova Brasil takers - 5th graders) 
	insheet using "Databases\data_students.txt", comma clear case
	keep if d250m==1 
	
	egen tag_school_year=tag(id_school year)
	egen sum_violence=sum(d2) if tag_school_year==1, by(id_school)
	egen x1=max(sum_violence), by(id_school)
	gen d_violence=(x1>0)

	tabout d_violence using Tables/TableB2a.xls, c(N language_score_250 N math_score_250 N age_m N boy_m N nonwhite_m N mother_educ_low_m  N repeated_m N dropped_m ) clab()   f(0) sum append 
	tabout d_violence using Tables/TableB2a.xls, c(mean language_score_250 mean math_score_250 mean age_m mean boy_m mean nonwhite_m mean mother_educ_low_m  mean repeated_m mean dropped_m) clab()   f(3) sum append 
	tabout d_violence using Tables/TableB2a.xls, c(sd language_score_250 sd math_score_250 sd age_m sd boy_m sd nonwhite_m sd mother_educ_low_m sd repeated_m sd dropped_m) clab()   f(3) sum append 

	* B - School-level variables (1st to 5th graders)
	insheet using "Databases\data_movements.txt", comma clear case
	
	egen tag_school_year=tag(id_school year)
	egen sum_violence=sum(d2) if tag_school_year==1, by(id_school)
	egen x1=max(sum_violence), by(id_school)
	gen d_violence=(x1>0)

	tabout d_violence using Tables/TableB2b.xls, c(N transf_within N dropout_within  N transf_end N dropout_end N number_stud_school N age  N  boy N nonwhite_m  N mother_educ_low N  live_close) clab()   f(0) sum append 
	tabout d_violence using Tables/TableB2b.xls, c(mean transf_within mean dropout_within  mean transf_end mean dropout_end mean number_stud_school mean age  mean  boy mean nonwhite_m  mean mother_educ_low mean  live_close) clab()   f(3) sum append 
	tabout d_violence using Tables/TableB2b.xls, c(sd transf_within sd dropout_within  sd transf_end sd dropout_end sd number_stud_school sd age  sd  boy sd nonwhite_m  sd mother_educ_low sd  live_close) clab()   f(3) sum append 


* PANELS C AND E 
	insheet using "Databases\data_schools.txt", comma clear case

	egen tag_school_year=tag(id_school year)
	egen sum_violence=sum(d2) if tag_school_year==1, by(id_school)
	egen x1=max(sum_violence), by(id_school)
	gen d_violence=(x1>0)

	* C - School level variables
	tabout d_violence using Tables/TableB2c.xls, c(N d_violence_250m_classes  N day_contiguous  N kitchen N principal_office N science_lab N computer_lab N school_lunch N teacher_office N number_teachers N share_absent N absences_average N share_onleave N onleave_average) clab()  f(0) sum append 
	tabout d_violence using Tables/TableB2c.xls, c(mean d_violence_250m_classes  mean day_contiguous  mean kitchen mean principal_office mean science_lab mean computer_lab mean school_lunch mean teacher_office mean number_teachers mean share_absent mean absences_average mean share_onleave mean onleave_average) clab()   f(3) sum append 
	tabout d_violence using Tables/TableB2c.xls, c(sd d_violence_250m_classes  sd day_contiguous  sd kitchen sd principal_office sd science_lab sd computer_lab sd school_lunch sd teacher_office sd number_teachers sd share_absent sd absences_average sd share_onleave sd onleave_average) clab()   f(3) sum append 

	* E - Principal reported problem with
	tabout d_violence using Tables/TableB2e.xls if year==2007 | year==2009, c(N interrup N student_absence N turnover N new_principal N threat_teacher N threat_student) clab()  f(0) sum append 
	tabout d_violence using Tables/TableB2e.xls if year==2007 | year==2009, c(mean interrup mean student_absence mean turnover mean new_principal mean threat_teacher mean threat_student) clab()   f(3) sum append 
	tabout d_violence using Tables/TableB2e.xls if year==2007 | year==2009, c(sd interrup sd student_absence sd turnover sd new_principal sd threat_teacher sd threat_student) clab()   f(3) sum append 

	
* PANEL D - Teacher level variables
	insheet using "Databases\data_teachers.txt", comma clear case
	
	egen tag_school_year=tag(id_school year)
	egen sum_violence=sum(d2) if tag_school_year==1, by(id_school)
	egen x1=max(sum_violence), by(id_school)
	gen d_violence=(x1>0)
	keep if n_teachers!=.
	
	gen attrition=(left_school==1 & changed_school==0)

	tabout d_violence using Tables/TableB2d.xls, c(N left_school N changed_school N attrition N age N male N white N undergraduated N graduated) clab()   f(3) sum append 
	tabout d_violence using Tables/TableB2d.xls, c(mean left_school mean changed_school mean attrition mean age mean male mean white mean undergraduated mean graduated) clab()   f(3) sum append 
	tabout d_violence using Tables/TableB2d.xls, c(sd left_school sd changed_school sd attrition sd age sd male sd white sd undergraduated sd graduated) clab()   f(3) sum append 
	

**************************************************************************************************************************
* FIGURE C1: HOMICIDE AND NUMBER OF DAYS WITH CONFLICTS 2003-2009
**************************************************************************************************************************

insheet using "Databases\data_reports_aisp.txt", comma clear case

egen tag=tag(year)
corr homicides_year days_reports_year if tag==1 
local corr : di %5.3g r(rho) 

twoway (connect  homicides_year year,  sort xtitle("") subtitle("(correlation `corr')") legend(region(lwidth(none))) ///
        legend(label(1 "Homicide rate")) yscale(range(2000 2800)) ytick(#4) ylabel(#4)) (connect days_reports_year year, yaxis(2) ///
		scheme(s1mono) yscale(range(200 800) axis(2)) ytick(#4, axis(2)) ylabel(#4, axis(2)) sort legend(label(2 "Days with reports")) ///
		ytitle("Number of homicides per year at state level") ytitle("Number of days with reports per year at state level", axis(2)))
graph export Figures\FigureC1.eps, replace	   


**************************************************************************************************************************
* FIGURE C2: HOMICIDE AND NUMBER OF DAYS WITH CONFLICTS PER AISP 
**************************************************************************************************************************

insheet using "Databases\data_reports_aisp.txt", comma clear case

tempfile homic2004 homic2005 homic2006 homic2007
foreach x of numlist 2004 (1) 2007 {
corr homicides days_reports if year==`x' 
local corr: di %5.3g r(rho) 

twoway (scatter  homicides days_reports if year==`x' , subtitle("(correlation `corr')") ///
        legend(off)  ytitle("Number of homicides") xtitle("Days with reports") nodraw  ///
		title(`x') mlabel(aisp) scheme(s1mono) yscale(range(0 600)) ytick(#4) ylabel(#4) /// 
		saving(`"homic`x'"', replace)) (lfit homicides days_reports if year==`x') 
}

graph combine `"homic2004"' `"homic2005"' `"homic2006"' `"homic2007"' , scheme(s1mono)
graph export Figures\FigureC2.eps, replace	   


**************************************************************************************************************************
*TABLE C1: TESTING FOR UNDER-REPORTING
**************************************************************************************************************************

insheet using "Databases\data_reports_aisp.txt", comma clear case

foreach x of numlist 2004 (1) 2007 {
reg homicides days_reports  if year==`x'
predict homic_pred`x' if year==`x'
recode homic_pred`x' (.=0)
}
gen homic_pred=homic_pred2004+homic_pred2005 + homic_pred2006 + homic_pred2007
gen under_reporting= (homicides - homic_pred>0)

table aisp year if year>=2004 & year<=2007, c(mean homicides mean homic_pred mean under_reporting )



********************************************************************************************************************************************
* FIGURE C3: CONFLICT DYNAMICS AT THE FAVELA-MONTH LEVEL: CORRELOGRAM FOR THE PACF UP TO THE 15TH LAG
********************************************************************************************************************************************

insheet using "Databases\data_reports_favela.txt", comma clear case

*Create a balanced panel to analyze frequency of reports at violent favela
gen ym=ym(year, month)
format ym %tm

collapse (sum)   gun_reports_favela days_gun_reports_favela (max) month year, by(id_favela ym)


* Identificando a FACP

foreach i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24  {
bysort id_favela (ym): gen days_reports_favela_`i' = days_gun_reports_favela[_n-`i'] 
}

tempfile tf1 tf2 tf3 tf4 tf5 tf6 tf7 tf8 tf9 tf10 tf11 tf12 tf13 tf14 tf15
parmby "xi: areg days_gun_reports_favela days_reports_favela_1 i.month i.year , cluster(id_favela) abs(id_favela)", ///
	   level(95) list(parm estimate min95 max95, clean noobs) saving(`"`tf1'"', replace) idn(1)   
	   
parmby "xi: areg days_gun_reports_favela days_reports_favela_2 days_reports_favela_1  i.month i.year  , cluster(id_favela) abs(id_favela)", ///
	   level(95) list(parm estimate min95 max95, clean noobs) saving(`"`tf2'"', replace) idn(2)   
	   
parmby "xi: areg days_gun_reports_favela days_reports_favela_3 days_reports_favela_1 days_reports_favela_2  i.month i.year  , cluster(id_favela) abs(id_favela) ", ///
	   level(95) list(parm estimate min95 max95, clean noobs) saving(`"`tf3'"', replace) idn(3)   
	   
parmby "xi: areg days_gun_reports_favela days_reports_favela_4 days_reports_favela_1 days_reports_favela_2 days_reports_favela_3  i.month i.year   , cluster(id_favela) abs(id_favela) ", ///
	   level(95) list(parm estimate min95 max95, clean noobs) saving(`"`tf4'"', replace) idn(4)      

parmby "xi: areg days_gun_reports_favela days_reports_favela_5 days_reports_favela_1 days_reports_favela_2 days_reports_favela_3 days_reports_favela_4  i.month i.year   , cluster(id_favela) abs(id_favela) ", ///
	   level(95) list(parm estimate min95 max95, clean noobs) saving(`"`tf5'"', replace) idn(5) 
 
parmby "xi: areg days_gun_reports_favela days_reports_favela_6 days_reports_favela_1 days_reports_favela_2 days_reports_favela_3 days_reports_favela_4 days_reports_favela_5  i.month i.year   , cluster(id_favela) abs(id_favela)", ///
	   level(95) list(parm estimate min95 max95, clean noobs) saving(`"`tf6'"', replace) idn(6)

parmby "xi: areg days_gun_reports_favela days_reports_favela_7 days_reports_favela_1 days_reports_favela_2 days_reports_favela_3 days_reports_favela_4 days_reports_favela_5 days_reports_favela_6  i.month i.year   , cluster(id_favela) abs(id_favela)", ///
	   level(95) list(parm estimate min95 max95, clean noobs) saving(`"`tf7'"', replace) idn(7)

parmby "xi: areg days_gun_reports_favela days_reports_favela_8 days_reports_favela_1 days_reports_favela_2 days_reports_favela_3 days_reports_favela_4 days_reports_favela_5 days_reports_favela_6 days_reports_favela_7  i.month i.year   , cluster(id_favela) abs(id_favela)", ///
	   level(95) list(parm estimate min95 max95, clean noobs) saving(`"`tf8'"', replace) idn(8) 	   
	   
parmby "xi: areg days_gun_reports_favela days_reports_favela_9 days_reports_favela_1 days_reports_favela_2 days_reports_favela_3 days_reports_favela_4 days_reports_favela_5 days_reports_favela_6 days_reports_favela_7 days_reports_favela_8  i.month i.year   , cluster(id_favela) abs(id_favela) ", ///
	   level(95) list(parm estimate min95 max95, clean noobs) saving(`"`tf9'"', replace) idn(9)  	   
	   
parmby "xi: areg days_gun_reports_favela days_reports_favela_10 days_reports_favela_1 days_reports_favela_2 days_reports_favela_3 days_reports_favela_4 days_reports_favela_5 days_reports_favela_6 days_reports_favela_7 days_reports_favela_8 days_reports_favela_9  i.month i.year   , cluster(id_favela) abs(id_favela)", ///
	   level(95) list(parm estimate min95 max95, clean noobs) saving(`"`tf10'"', replace) idn(10) 	   
	   
parmby "xi: areg days_gun_reports_favela days_reports_favela_11 days_reports_favela_1 days_reports_favela_2 days_reports_favela_3 days_reports_favela_4 days_reports_favela_5 days_reports_favela_6 days_reports_favela_7 days_reports_favela_8 days_reports_favela_9 days_reports_favela_10  i.month i.year   , cluster(id_favela) abs(id_favela)", ///
	   level(95) list(parm estimate min95 max95, clean noobs) saving(`"`tf11'"', replace) idn(11)  	   
	   
parmby "xi: areg days_gun_reports_favela days_reports_favela_12 days_reports_favela_1 days_reports_favela_2 days_reports_favela_3 days_reports_favela_4 days_reports_favela_5 days_reports_favela_6 days_reports_favela_7 days_reports_favela_8 days_reports_favela_9 days_reports_favela_10 days_reports_favela_11  i.month i.year   , cluster(id_favela) abs(id_favela)", ///
	   level(95) list(parm estimate min95 max95, clean noobs) saving(`"`tf12'"', replace) idn(12) 	   
	   
parmby "xi: areg days_gun_reports_favela days_reports_favela_13 days_reports_favela_1 days_reports_favela_2 days_reports_favela_3 days_reports_favela_4 days_reports_favela_5 days_reports_favela_6 days_reports_favela_7 days_reports_favela_8 days_reports_favela_9 days_reports_favela_10 days_reports_favela_11 days_reports_favela_12  i.month i.year   , cluster(id_favela) abs(id_favela)", ///
	   level(95) list(parm estimate min95 max95, clean noobs) saving(`"`tf13'"', replace) idn(13) 	   
	   
parmby "xi: areg days_gun_reports_favela days_reports_favela_14 days_reports_favela_1 days_reports_favela_2 days_reports_favela_3 days_reports_favela_4 days_reports_favela_5 days_reports_favela_6 days_reports_favela_7 days_reports_favela_8 days_reports_favela_9 days_reports_favela_10 days_reports_favela_11 days_reports_favela_12 days_reports_favela_13  i.month i.year   , cluster(id_favela) abs(id_favela) ", ///
	   level(95) list(parm estimate min95 max95, clean noobs) saving(`"`tf14'"', replace) idn(14) 	   
	   
parmby "xi: areg days_gun_reports_favela days_reports_favela_15 days_reports_favela_1 days_reports_favela_2 days_reports_favela_3 days_reports_favela_4 days_reports_favela_5 days_reports_favela_6 days_reports_favela_7 days_reports_favela_8 days_reports_favela_9 days_reports_favela_10 days_reports_favela_11 days_reports_favela_12 days_reports_favela_13 days_reports_favela_14  i.month i.year   , cluster(id_favela) abs(id_favela) ", ///
	   level(95) list(parm estimate min95 max95, clean noobs) saving(`"`tf15'"', replace) idn(15) 	   
	   
drop _all
append using `"`tf1'"' `"`tf2'"' `"`tf3'"' `"`tf4'"' `"`tf5'"' `"`tf6'"' `"`tf7'"' `"`tf8'"' `"`tf9'"' `"`tf10'"' `"`tf11'"' `"`tf12'"' `"`tf13'"' `"`tf14'"' `"`tf15'"' 
keep if parmseq==1
 
twoway (scatter estimate idnum, scheme(s1mono) yscale(range(-0.5 0.5)) ytick(#10) ylabel(#10) xtick(#15) xlabel(#15)  ///
	    yline(0, lwidth(vvvthin)) xtitle("") ytitle("") symbol(d) msize(medlarge) /// 
		yline(.23433003, lpat(dash) lwid(vvvthin)) yline(-.23433003, lpat(dash) lwid(vvvthin)))
graph export Figures\FigureC3.eps, replace


********************************************************************************************************************************************
* TABLE D1 - VIOLENCE EFFECTS BY DISTANCE BETWEEN SCHOOLS AND CONFLICT LOCATION
********************************************************************************************************************************************

insheet using "Databases\data_students.txt", comma clear case
global controls "i.age i.boy i.mother_educ i.white i.repeated i.dropped  kitchen principal_office science_lab computer_lab  school_lunch teacher_office boys_class nonwhite_class age_class work_class repeated_class dropped_class"

* MATH
foreach i in 5 250 500 750 {
xi: areg math_score d2_`i'm  $controls  i.year if  d`i'm==1, cluster(id_school) abs(id_school)
	outreg2 using Tables\TableD1.xls, aster(se) dec(3) label keep(d2_`i'm) nocons addtext(Sample of Schools, Within, Year FE, Y, Student and Class Charact, Y, Infrastructure, Y, School FE, Y)
}




********************************************************************************************************************************************
* TABLE D1* - VIOLENCE EFFECTS AT SMALL BUFFERS: ADDITIONAL EVIDENCE
********************************************************************************************************************************************

insheet using "Databases\data_students.txt", comma clear case
global controls "i.age i.boy i.mother_educ i.white i.repeated i.dropped  kitchen principal_office science_lab computer_lab  school_lunch teacher_office boys_class nonwhite_class age_class work_class repeated_class dropped_class"

* MATH
foreach i in 5 50 100 150 200 250 300 500 {
xi: areg math_score d2_`i'm  $controls  i.year if  d`i'm==1, cluster(id_school) abs(id_school)
	outreg2 using Tables\TableD1_STAR.xls, aster(se) dec(3) label keep(d2_`i'm) nocons addtext(Sample of Schools, Within, Year FE, Y, Student and Class Charact, Y, Infrastructure, Y, School FE, Y)
}



********************************************************************************************************************************************
* TABLE D2 - VIOLENCE EFFECTS BY CONFLICT INTENSITY AND LENGTH
********************************************************************************************************************************************

insheet using "Databases\data_students.txt", comma clear case
global controls "i.age i.boy i.mother_educ i.white i.repeated i.dropped  kitchen principal_office science_lab computer_lab  school_lunch teacher_office boys_class nonwhite_class age_class work_class repeated_class dropped_class"

* MATH
foreach i in 1 2 7 9 {
xi: areg math_score  d`i'  i.year $controls if d250m==1, cluster(id_school)  abs(id_school)
outreg2 using Tables\TableD2.xls, aster(se) dec(3)  label keep(d`i') nocons  
}

xi: areg math_score  intensity_contn i.year $controls if d250m==1, cluster(id_school)  abs(id_school)
outreg2 using Tables\TableD2.xls, aster(se) dec(3)  label keep(intensity_contn) nocons   addtext(Year FE, Y, Student and Class Charact, Y, Infrastructure, Y, School FE, Y)

xi: areg math_score  dcontiguous  i.year $controls if d250m==1, cluster(id_school)  abs(id_school)
outreg2 using Tables\TableD2.xls, aster(se) dec(3)  label keep(dcontiguous d2Ncontiguous) nocons   addtext(Year FE, Y, Student and Class Charact, Y, Infrastructure, Y, School FE, Y)

xi: areg math_score   d2Ncontiguous i.year $controls if d250m==1, cluster(id_school)  abs(id_school)
outreg2 using Tables\TableD2.xls, aster(se) dec(3)  label keep(dcontiguous d2Ncontiguous) nocons   addtext(Year FE, Y, Student and Class Charact, Y, Infrastructure, Y, School FE, Y)



********************************************************************************************************************************************
* TABLE D3 - TIMING OF THE VIOLENCE EFFECT ON STUDENT ACHIEVEMENT
********************************************************************************************************************************************

insheet using "Databases\data_students.txt", comma clear case
global controls "i.age i.boy i.mother_educ i.white i.repeated i.dropped  kitchen principal_office science_lab computer_lab  school_lunch teacher_office boys_class nonwhite_class age_class work_class repeated_class dropped_class"

* MATH
xi: areg math_score d2_fall d2_spring  d2_vacation i.year $controls if d250m==1, cluster(id_school)  abs(id_school)
	outreg2 using Tables\TableD3.xls, aster(se) dec(3)  label keep(d2_spring d2_vacation d2_fall) nocons   addtext(Year FE, Y, Student and Class Charact, Y, Infrastructure, Y, School FE, Y)

xi: areg math_score   d2 lead1_d2 i.year $controls if d250m==1, cluster(id_school)  abs(id_school)
	outreg2 using Tables\TableD3.xls, aster(se) dec(3)  label keep(d2 lead1_d2) nocons   addtext(Year FE, Y, Student and Class Charact, Y, Infrastructure, Y, School FE, Y)

xi: areg math_score   d2 lag1_d2 i.year $controls if d250m==1, cluster(id_school)  abs(id_school)
	outreg2 using Tables\TableD3.xls, aster(se) dec(3)  label keep(d2 lag1_d2) nocons   addtext(Year FE, Y, Student and Class Charact, Y, Infrastructure, Y, School FE, Y)


********************************************************************************************************************************************
* TABLE D4 - HETEROGENEITY IN THE VIOLENCE EFFECT BY STUDENTS' SOCIOECONOMIC CHARACTERISTICS
********************************************************************************************************************************************

insheet using "Databases\data_students.txt", comma clear case
global controls "i.age i.boy i.mother_educ i.white i.repeated i.dropped  kitchen principal_office science_lab computer_lab  school_lunch teacher_office boys_class nonwhite_class age_class work_class repeated_class dropped_class"

* MATH
xi: areg math_score  d2  $controls  i.year if d250m==1, cluster(id_school) abs(id_school)
	outreg2 using Tables\TableD4.xls, aster(se) dec(3) keep(d2) label nocons   

foreach i in boy_m nonwhite_m  mother_educ_low_m age_incorrect repeated_m dropped_m {
xi: areg math_score  d2 c.d2#c.`i' $controls  i.year if d250m==1, cluster(id_school) abs(id_school)
	outreg2 using Tables\TableD4.xls, aster(se) dec(3) keep(d2 c.d2#c.`i') label nocons  
}



**************************************************************************************************************************
* TABLE D5: VIOLENCE EFFECTS AND DISTANCE BETWEEN SCHOOLS AND CONFLICT LOCATION - LANGUAGE SCORES
**************************************************************************************************************************

insheet using "Databases\data_students.txt", comma clear case
global controls "i.age i.boy i.mother_educ i.white i.repeated i.dropped kitchen principal_office science_lab computer_lab school_lunch teacher_office boys_class nonwhite_class age_class work_class  repeated_class dropped_class"

foreach i in 5 250 500 750 {
xi: areg language_score d2_`i'm  $controls  i.year if  d`i'm==1, cluster(id_school) abs(id_school)
	outreg2 using Tables\TableD5.xls, aster(se) dec(3) label keep(d2_`i'm) nocons addtext(Sample of Schools, Within, Year FE, Y, Student and Class Charact, Y, Infrastructure, Y, School FE, Y)
}

**************************************************************************************************************************
* TABLE D6: VIOLENCE EFFECTS BY CONFLICT INTENSITY AND LENGTH - LANGUAGE SCORES
**************************************************************************************************************************

insheet using "Databases\data_students.txt", comma clear case
global controls "i.age i.boy i.mother_educ i.white i.repeated i.dropped kitchen principal_office science_lab computer_lab school_lunch teacher_office boys_class nonwhite_class age_class work_class  repeated_class dropped_class"
keep if d250m==1


foreach i in 1 2 7 9 {
xi: areg  language_score  d`i'  i.year $controls if d250m==1, cluster(id_school)  abs(id_school)
outreg2 using Tables\TableD6.xls, aster(se) dec(3)  label keep(d`i') nocons  
}
xi: areg  language_score  intensity_contn i.year $controls if d250m==1, cluster(id_school)  abs(id_school)
outreg2 using Tables\TableD6.xls, aster(se) dec(3)  label keep(intensity_contn) nocons   addtext(Year FE, Y, Student and Class Charact, Y, Infrastructure, Y, School FE, Y)

xi: areg  language_score  dcontiguous  i.year $controls if d250m==1, cluster(id_school)  abs(id_school)
outreg2 using Tables\TableD6.xls, aster(se) dec(3)  label keep(dcontiguous d2Ncontiguous) nocons   addtext(Year FE, Y, Student and Class Charact, Y, Infrastructure, Y, School FE, Y)
xi: areg  language_score   d2Ncontiguous i.year $controls if d250m==1, cluster(id_school)  abs(id_school)
outreg2 using Tables\TableD6.xls, aster(se) dec(3)  label keep(dcontiguous d2Ncontiguous) nocons   addtext(Year FE, Y, Student and Class Charact, Y, Infrastructure, Y, School FE, Y)

**************************************************************************************************************************
* TABLE D7: THE TIMING OF VIOLENCE EFFECT ON STUDENT ACHIEVEMENT - LANGUAGE SCORES
**************************************************************************************************************************

insheet using "Databases\data_students.txt", comma clear case
global controls "i.age i.boy i.mother_educ i.white i.repeated i.dropped kitchen principal_office science_lab computer_lab school_lunch teacher_office boys_class nonwhite_class age_class work_class  repeated_class dropped_class"
keep if d250m==1

xi: areg language_score d2_fall d2_spring  d2_vacation i.year $controls if d250m==1, cluster(id_school)  abs(id_school)
	outreg2 using Tables\TableD7.xls, aster(se) dec(3)  label keep(d2_spring d2_vacation d2_fall) nocons   addtext(Year FE, Y, Student and Class Charact, Y, Infrastructure, Y, School FE, Y)
xi: areg language_score d2 lead1_d2  i.year $controls if d250m==1, cluster(id_school)  abs(id_school)
	outreg2 using Tables\TableD7.xls, aster(se) dec(3)  label keep(d2 lead1_d2) nocons   addtext(Year FE, Y, Student and Class Charact, Y, Infrastructure, Y, School FE, Y)
xi: areg language_score d2 lag1_d2   i.year $controls if d250m==1, cluster(id_school)  abs(id_school)
	outreg2 using Tables\TableD7.xls, aster(se) dec(3)  label keep(d2 lag1_d2) nocons   addtext(Year FE, Y, Student and Class Charact, Y, Infrastructure, Y, School FE, Y)

**************************************************************************************************************************
* TABLE D8 - HETEROGENEITY IN THE VIOLENCE EFFECT BY STUDENTS' SOCIOECONOMIC CHARACTERISTICS  - LANGUAGE SCORES
**************************************************************************************************************************

insheet using "Databases\data_students.txt", comma clear case
global controls "i.age i.boy i.mother_educ i.white i.repeated i.dropped kitchen principal_office science_lab computer_lab school_lunch teacher_office boys_class nonwhite_class age_class work_class  repeated_class dropped_class"
keep if d250m==1

xi: areg language_score  d2  $controls  i.year if d250m==1, cluster(id_school) abs(id_school)
	outreg2 using Tables\TableD9.xls, aster(se) dec(3) keep(d2) label nocons   
foreach i in boy_m nonwhite_m mother_educ_low_m age_incorrect repeated_m dropped_m {
xi: areg language_score  d2 c.d2#c.`i' $controls  i.year if d250m==1, cluster(id_school) abs(id_school)
	outreg2 using Tables\TableD9.xls, aster(se) dec(3) keep(d2 c.d2#c.`i') label nocons  
}

********************************************************************************************************************************************
*FIGURE D1: IMPACT ON LANGUAGE TEST SCORES BY VIOLENCE DISTANCE (buffer of distance from the school to the conflict location, in meters)
********************************************************************************************************************************************

insheet using "Databases\data_students.txt", comma clear case
global controls "i.age i.boy i.mother_educ i.white i.repeated i.dropped  kitchen principal_office science_lab computer_lab  school_lunch teacher_office boys_class nonwhite_class age_class work_class repeated_class dropped_class"

tempfile tf250 tf300 tf350 tf400 tf450 tf500 tf750  
foreach x in  250 300 350 400 450 500 750 {
parmby "xi: areg language_score d2_`x'm  $controls  i.year if  d`x'm==1, cluster(id_school) abs(id_school)", ///
	   level(90 95) cln(rank) for(estimate min* max* stderr %8.3f) list(parm estimate min2 min1 max1 max2, clean noobs) ///
	   saving(`"`tf`x''"', replace) idn(`x') 
}
drop _all
append using  `"`tf250'"' `"`tf300'"' `"`tf350'"' `"`tf400'"' `"`tf450'"' `"`tf500'"' `"`tf750'"' 
keep if parmseq==1

gen n=_n
label define n 1  "250" 2 "300" 3 "350" 4 "400" 5 "450" 6 "500" 7 "750"
label values n n

twoway (connect estimate n, sort scheme(s1mono) mcolor(black) yline(0, lwidth(vvvthin)) xlabel(#8) xtick(#8) xlabel(, valuelabel)  ///
		xtitle("Distance between the school and the favela exposed to violence (meters)") ytitle("Effect in standard deviation") ylabel(,format(%3.2f)) ///
		legend(order(1 "Point estimate" 2 "90% Confidence Interval" 4 "95% Confidence Interval")) legend(region(lwidth(none)))) ///
	   (line min1 n, sort lcolor(gs6) lpattern(vshortdash)) (line max1 n, sort lcolor(gs6) lpattern(vshortdash)) ///
	   (line min2 n, sort lcolor(gs4) lpattern(longdash)) (line max2 n, sort lcolor(gs4) lpattern(longdash))
graph export Figures\FigureD1.eps, replace
	   

********************************************************************************************************************************************
*FIGURE D2 - IMPACT ON LANGUAGE TEST SCORES BY VIOLENCE INTENSITY (number of days during the school period)
********************************************************************************************************************************************

insheet using "Databases\data_students.txt", comma clear case
global controls "i.age i.boy i.mother_educ i.white i.repeated i.dropped  kitchen principal_office science_lab computer_lab  school_lunch teacher_office boys_class nonwhite_class age_class work_class repeated_class dropped_class"
keep if d250m==1


tempfile tf1 tf2  tf3 tf4 tf5 tf6 tf7 tf8 tf9
foreach x in 1 2 3 4 5 6 7 8 9  {
parmby "xi: areg language_score d`x' i.year  $controls, cluster(id_school) abs(id_school)", ///
	   level(90 95) cln(rank) for(estimate min* max* stderr %8.3f) list(parm estimate min2 min1 max1 max2, clean noobs) ///
	   saving(`"`tf`x''"', replace) idn(`x') 
}
drop _all
append using `"`tf1'"' `"`tf2'"' `"`tf3'"' `"`tf4'"' `"`tf5'"' `"`tf6'"' `"`tf7'"' `"`tf8'"' `"`tf9'"'
keep if parmseq==1

label define idnum 1 "1+" 2 "2+" 3 "3+" 4 "4+" 5 "5+" 6 "6+" 7 "7+" 8 "8+" 9 "+9"
label values idnum idnum

twoway (connect estimate idnum, sort scheme(s1mono) mcolor(black) yline(0, lwidth(vvvthin)) xlabel(#9) xtick(#9)  xlabel(, valuelabel) ///
		xtitle("Number of days with conflict during the academic year") ytitle("Effect in standard deviation") ylabel(,format(%3.2f)) ///
		legend(order(1 "Point estimate" 2 "90% Confidence Interval" 4 "95% Confidence Interval")) legend(region(lwidth(none)))) ///
	   (line min1 idnum, sort lcolor(gs6) lpattern(vshortdash)) (line max1 idnum, sort lcolor(gs6) lpattern(vshortdash)) ///
	   (line min2 idnum, sort lcolor(gs4) lpattern(longdash)) (line max2 idnum, sort lcolor(gs4) lpattern(longdash))
graph export Figures\FigureD2.eps, replace
	   
	   
********************************************************************************************************************************************
*FIGURE D3: IMPACT ON LANGUAGE TEST SCORES BY THE TIMING OF THE VIOLENCE (violence indicator computed by trimester)
********************************************************************************************************************************************

insheet using "Databases\data_students.txt", comma clear case
global controls "i.age i.boy i.mother_educ i.white i.repeated i.dropped  kitchen principal_office science_lab computer_lab  school_lunch teacher_office boys_class nonwhite_class age_class work_class repeated_class dropped_class"

tempfile tflag3_d2_1trim tflag3_d2_2trim  tflag3_d2_3trim tflag3_d2_4trim tflag2_d2_1trim tflag2_d2_2trim tflag2_d2_3trim tflag2_d2_4trim tflag1_d2_1trim tflag1_d2_2trim tflag1_d2_3trim tflag1_d2_4trim tfd2_1trim tfd2_2trim tfd2_3trim tfd2_4trim tflead1_d2_1trim tflead1_d2_2trim tflead1_d2_3trim tflead1_d2_4trim
parmby "xi: areg language_score lag3_d2_1trim   $controls  i.year if d250m==1 , cluster(id_school) abs(id_school)", ///
	   level(90 95) cln(rank) for(estimate min* max* stderr %8.3f) list(parm estimate min2 min1 max1 max2, clean noobs) ///
	   saving(`"`tflag3_d2_1trim'"', replace)  

foreach x in lag3_d2_2trim lag3_d2_3trim lag3_d2_4trim lag2_d2_1trim lag2_d2_2trim lag2_d2_3trim lag2_d2_4trim lag1_d2_1trim lag1_d2_2trim lag1_d2_3trim lag1_d2_4trim d2_1trim d2_2trim d2_3trim d2_4trim lead1_d2_1trim lead1_d2_2trim lead1_d2_3trim lead1_d2_4trim {
parmby "xi: areg language_score `x'   $controls  i.year , cluster(id_school) abs(id_school)", ///
	   level(90 95) cln(rank) for(estimate min* max* stderr %8.3f) list(parm estimate min2 min1 max1 max2, clean noobs) ///
	   saving(`"`tf`x''"', replace) 
}
drop _all
append using `"`tflag3_d2_1trim'"' `"`tflag3_d2_2trim'"' `"`tflag3_d2_3trim'"' `"`tflag3_d2_4trim'"' `"`tflag2_d2_1trim '"' `"`tflag2_d2_2trim'"' `"`tflag2_d2_3trim'"' `"`tflag2_d2_4trim'"' `"`tflag1_d2_1trim'"' `"`tflag1_d2_2trim'"' `"`tflag1_d2_3trim'"' `"`tflag1_d2_4trim'"' `"`tfd2_1trim'"' `"`tfd2_2trim'"' `"`tfd2_3trim'"' `"`tfd2_4trim'"' `"`tflead1_d2_1trim'"' `"`tflead1_d2_2trim'"' `"`tflead1_d2_3trim'"' `"`tflead1_d2_4trim'"'
keep if parmseq==1

gen n=_n
label define n 1 "1st Q (Year -3)" 2 "2nd Q (Year -3)" 3 "3rd Q (Year -3)" 4 "4th Q (Year -3)" ///
5 "1st Q (Year -2)" 6 "2nd Q (Year -2)" 7 "3rd Q (Year -2)" 8 "4th Q (Year -2)" 9 "1st Q (Year -1)" ///
10 "2nd Q (Year -1)" 11 "3rd Q (Year -1)" 12 "4th Q (Year -1)" 13 "1st Q" 14 "2nd Q" 15 "3rd Q" ///
16 "4th Q" 17 "1st Q (Year +1)" 18 "2nd Q (Year +1)" 19 "3rd Q (Year +1)" 20 "4th Q (Year +1)"
label values n n

twoway (connect estimate n, sort scheme(s1mono) mcolor(black) yline(0, lwidth(vvvthin)) xline(16, lwidth(vvvthin)) xlabel(#20) xtick(#20) xlabel(, valuelabel angle(90) labsize(small))  ///
		xtitle("") ytitle("") ylabel(,format(%3.2f)) ///
		legend(order(1 "Point estimate" 2 "90% Confidence Interval" 4 "95% Confidence Interval")) legend(region(lwidth(none)))) ///
	   (line min1 n, sort lcolor(gs6) lpattern(vshortdash)) (line max1 n, sort lcolor(gs6) lpattern(vshortdash)) ///
	   (line min2 n, sort lcolor(gs4) lpattern(longdash)) (line max2 n, sort lcolor(gs4) lpattern(longdash))
graph export Figures\FigureD3.eps, replace



********************************************************************************************************************************************
* Table D9: VIOLENCE EFFECTS ON STUDENT MOBILITY
*******************************************************************************************************************************************

insheet using "Databases\data_movements.txt", comma clear case
global students " i.age i.boy i.mother_educ  i.white   first_grade second_grade third_grade forth_grade fifth_grade  i.live_close"
global students2 " i.age i.boy i.white   first_grade second_grade third_grade forth_grade fifth_grade  i.live_close"

*PANEL A

	*Columns 1-4
	xi: areg transf_within d2  $students i.year, cluster(id_school) abs(id_school)
		sum transf_within if e(sample)==1
		eret2 scalar y_mean=r(mean)
		outreg2 using Tables\TableD9.xls, aster(se) dec(4) e(y_mean) label keep(d2) nocons addtext(Grades, 1-5)
	
	xi: areg dropout_within d2  $students i.year, cluster(id_school) abs(id_school)
		sum dropout_within if e(sample)==1
		eret2 scalar y_mean=r(mean)
		outreg2 using Tables\TableD9.xls, aster(se) dec(4) e(y_mean) label keep(d2) nocons addtext(Grades, 1-5)		
	
	xi: areg transf_end d2  $students i.year, cluster(id_school) abs(id_school)
		sum transf_within if e(sample)==1
		eret2 scalar y_mean=r(mean)
		outreg2 using Tables\TableD9.xls, aster(se) dec(4) e(y_mean) label keep(d2) nocons addtext(Grades, 1-5)
	
	xi: areg dropout_end d2  $students i.year, cluster(id_school) abs(id_school)
		sum dropout_within if e(sample)==1
		eret2 scalar y_mean=r(mean)	
		outreg2 using Tables\TableD9.xls, aster(se) dec(4) e(y_mean) label keep(d2) nocons addtext(Grades, 1-5)
		
	
	*Columns 5-8
	preserve
	keep if fifth_grade==1
	xi: areg transf_within d2  $students i.year, cluster(id_school) abs(id_school)
		sum transf_within if e(sample)==1
		eret2 scalar y_mean=r(mean)
		outreg2 using Tables\TableD9.xls, aster(se) dec(4) e(y_mean) label keep(d2) nocons addtext(Grades, 5)
	
	xi: areg dropout_within d2  $students i.year, cluster(id_school) abs(id_school)
		sum dropout_within if e(sample)==1
		eret2 scalar y_mean=r(mean)
		outreg2 using Tables\TableD9.xls, aster(se) dec(4) e(y_mean) label keep(d2) nocons addtext(Grades, 5)
	
	xi: areg transf_end d2  $students i.year, cluster(id_school) abs(id_school)
		sum transf_within if e(sample)==1
		eret2 scalar y_mean=r(mean)
		outreg2 using Tables\TableD9.xls, aster(se) dec(4) e(y_mean)  label keep(d2) nocons addtext(Grades, 5)
	
	xi: areg dropout_end d2  $students i.year, cluster(id_school) abs(id_school)
		sum dropout_within if e(sample)==1
		eret2 scalar y_mean=r(mean)	
		outreg2 using Tables\TableD9.xls, aster(se) dec(4) e(y_mean) label keep(d2) nocons addtext(Grades, 5)	
	restore

*PANEL B

	*Columns 1-4
	gen d2mother_educ_low=d2*mother_educ_low

	xi: areg transf_within d2 d2mother_educ_low  mother_educ_low $students2 i.year, cluster(id_school) abs(id_school)
		sum transf_within if e(sample)==1
		eret2 scalar y_mean=r(mean)
		outreg2 using Tables\TableD9.xls, aster(se) dec(4) e(y_mean)  label keep(d2mother_educ_low d2  mother_educ_low) nocons addtext(Grades, 1-5)

	xi: areg dropout_within d2 d2mother_educ_low   mother_educ_low $students2 i.year, cluster(id_school) abs(id_school)
		sum dropout_within if e(sample)==1
		eret2 scalar y_mean=r(mean)
		outreg2 using Tables\TableD9.xls, aster(se) dec(4) e(y_mean)  label keep(d2mother_educ_low d2  mother_educ_low) nocons addtext(Grades, 1-5)

	xi: areg transf_end d2  d2mother_educ_low  mother_educ_low $students2 i.year, cluster(id_school) abs(id_school)
		sum transf_end if e(sample)==1
		eret2 scalar y_mean=r(mean)
		outreg2 using Tables\TableD9.xls, aster(se) dec(4) e(y_mean)  label keep(d2mother_educ_low d2  mother_educ_low) nocons addtext(Grades, 1-5)
	
	xi: areg dropout_end d2  d2mother_educ_low mother_educ_low $students2 i.year, cluster(id_school) abs(id_school)
		sum dropout_end if e(sample)==1
		eret2 scalar y_mean=r(mean)
		outreg2 using Tables\TableD9.xls, aster(se) dec(4) e(y_mean)  label keep(d2mother_educ_low d2  mother_educ_low) nocons addtext(Grades, 1-5)

	*Columns 5-8
	preserve
	keep if fifth_grade==1
	xi: areg transf_within d2 d2mother_educ_low  mother_educ_low $students2 i.year, cluster(id_school) abs(id_school)
		sum transf_within if e(sample)==1
		eret2 scalar y_mean=r(mean)
		outreg2 using Tables\TableD9.xls, aster(se) dec(4) e(y_mean)  label keep(d2mother_educ_low d2  mother_educ_low) nocons addtext(Grades, 5)
	
	xi: areg dropout_within d2 d2mother_educ_low   mother_educ_low $students2 i.year, cluster(id_school) abs(id_school)
		sum dropout_within if e(sample)==1
		eret2 scalar y_mean=r(mean)
		outreg2 using Tables\TableD9.xls, aster(se) dec(4) e(y_mean)  label keep(d2mother_educ_low d2  mother_educ_low) nocons addtext(Grades, 5)
	
	xi: areg transf_end d2  d2mother_educ_low  mother_educ_low $students2 i.year, cluster(id_school) abs(id_school)
		sum transf_end if e(sample)==1
		eret2 scalar y_mean=r(mean)
		outreg2 using Tables\TableD9.xls, aster(se) dec(4) e(y_mean)  label keep(d2mother_educ_low d2  mother_educ_low) nocons addtext(Grades, 5)
	
	xi: areg dropout_end d2  d2mother_educ_low mother_educ_low $students2 i.year, cluster(id_school) abs(id_school)
		sum dropout_end if e(sample)==1
		eret2 scalar y_mean=r(mean)
		outreg2 using Tables\TableD9.xls, aster(se) dec(4) e(y_mean)  label keep(d2mother_educ_low d2  mother_educ_low) nocons addtext(Grades, 5)
	restore


*PANEL C

foreach x of varlist d9  d2Ncontiguous dcontiguous {
foreach y of varlist transf_within dropout_within transf_end dropout_end {

xi: areg `y' `x' $students i.year, cluster(id_school) abs(id_school)
	sum `y' if e(sample)==1
	eret2 scalar y_mean=r(mean)
	outreg2 using Tables\TableD9.xls, aster(se) dec(4) e(y_mean) label keep(`x') nocons addtext(Grades, 1-5)


preserve
keep if fifth_grade==1
xi: areg `y' `x' $students i.year, cluster(id_school) abs(id_school)
	sum `y' if e(sample)==1
	eret2 scalar y_mean=r(mean)
	outreg2 using Tables\TableD9.xls, aster(se) dec(4) e(y_mean) label keep(`x') nocons addtext(Grades, 5)
restore
}
}


********************************************************************************************************************************************
*TABLE D10: STUDENT SELECTION AT THE PROVA BRASIL EXAM
********************************************************************************************************************************************

insheet using "Databases\data_students.txt", comma clear case
global infra  "kitchen principal_office science_lab computer_lab  school_lunch teacher_office"
global classroom "boys_class nonwhite_class age_class work_class repeated_class dropped_class"
keep if d250m==1

xi: areg n_took_test  d2 i.age i.mother_educ i.white i.repeated i.dropped  $infra $classroom i.year , cluster(id_school) abs(id_school)
	sum n_took_test if e(sample)==1
	eret2 scalar y_mean=r(mean)
	outreg2 using Tables/TableD10.xls, aster(se) dec(3) e(y_mean) label keep(d2) nocons  

xi: areg boy_m  d2 i.age i.mother_educ i.white i.repeated i.dropped  $infra $classroom i.year , cluster(id_school) abs(id_school)
	sum boy_m if e(sample)==1
	eret2 scalar y_mean=r(mean)
	outreg2 using Tables/TableD10.xls, aster(se) dec(3) e(y_mean) label keep(d2) nocons   

xi: areg nonwhite_m  d2  i.boy i.age i.mother_educ  i.repeated i.dropped  $infra $classroom i.year, cluster(id_school) abs(id_school)
	sum nonwhite_m if e(sample)==1
	eret2 scalar y_mean=r(mean)
	outreg2 using Tables/TableD10.xls, aster(se) dec(3) e(y_mean) label keep(d2) nocons  

xi: areg mother_educ_low_m  d2  i.boy i.age  i.white i.repeated i.dropped  $infra $classroom i.year , cluster(id_school) abs(id_school)
	sum mother_educ_low_m if e(sample)==1
	eret2 scalar y_mean=r(mean)
	outreg2 using Tables/TableD10.xls, aster(se) dec(3) e(y_mean) label keep(d2) nocons  

xi: areg repeated_m d2   i.boy i.age i.mother_educ i.white i.dropped $infra $classroom i.year , cluster(id_school) abs(id_school)
	sum repeated_m if e(sample)==1
	eret2 scalar y_mean=r(mean)
	outreg2 using Tables/TableD10.xls, aster(se) dec(3) e(y_mean) label keep(d2) nocons  

xi: areg dropped_m  d2   i.boy i.age i.mother_educ i.white i.repeated  $infra $classroom i.year, cluster(id_school) abs(id_school)
	sum dropped_m if e(sample)==1
	eret2 scalar y_mean=r(mean)
	outreg2 using Tables/TableD10.xls, aster(se) dec(3) e(y_mean) label keep(d2) nocons  

xi: areg age_incorrect  d2  i.boy  i.mother_educ i.white i.repeated i.dropped  $infra $classroom i.year , cluster(id_school) abs(id_school)
	sum age_incorrect if e(sample)==1
	eret2 scalar y_mean=r(mean)
	outreg2 using Tables/TableD10.xls, aster(se) dec(3) e(y_mean) label keep(d2) nocons  




	
********************************************************************************************************************************************
* TABLE E1: VIOLENCE EFFECTS ON TEACHERS' TURNOVER BETWEEN YEARS
********************************************************************************************************************************************

insheet using "Databases\data_teachers.txt", comma clear case
global school  "n_teachers  n_classes_school "
global teachers  "age male  white undergraduated graduated n_classes_teacher"


xi: areg left_school d2  $teachers $school i.year   , abs(id_school) cluster(id_school)
outreg2 using Tables\TableE1.xls, aster(se) dec(3) nocons  label keep(d2)	

foreach z of varlist age male  white undergraduated graduated  {
xi: areg left_school d2 c.d2#c.`z'  $teachers $school i.year , abs(id_school) cluster(id_school)
outreg2 using Tables\TableE1.xls, aster(se) dec(3) label nocons keep(d2 c.d2#c.`z')
}

xi: areg left_school d2 c.d2#c.age c.d2#c.male c.d2#c.white c.d2#c.undergraduated c.d2#c.graduated  $teachers $school i.year , abs(id_school) cluster(id_school)
outreg2 using Tables\TableE1.xls, aster(se) dec(3) label nocons keep(d2 c.d2#c.age c.d2#c.male c.d2#c.white c.d2#c.undergraduated c.d2#c.graduated)

	   
	   
