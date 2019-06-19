***************************
***** ANALYSIS  ***********
***************************
clear all 
set more off 

*** Once the data and code are in the same folder, the folder contains a subfolder entitled "output", the output folder contains a folder entitled "logs"
	* and the directory has been changed in line 11 then the entire code should run. 

*** Put Directory Here: 
cd "INSERT DIRECTORY HERE"



***** No code should be changed beyond this point *****

use figtemp.dta, clear

keep if f2period == 1 | l2period == 1

****************************************
***** Table 1: Summary Statistics ******
****************************************
cap log close
log using "output/logs/table1_summary.smcl", replace

file open table1_sum using "output/table1_sum", write replace

**** Math GPA Row
sum gpaavg if department == "math" & f2period == 1
file write table1_sum "Math GPA" _tab %9.2fc (r(mean)) _tab %9.2fc (r(sd)) 

sum gpaavg if department == "math" & l2period == 1
file write table1_sum _tab %9.2fc (r(mean)) _tab %9.2fc (r(sd)) _n

**** Math CST Row
sum cstscoremath if department == "math" & f2period == 1
file write table1_sum "Math CST" _tab %9.2fc (r(mean)) _tab %9.2fc (r(sd)) 

sum cstscoremath if department == "math" & l2period == 1
file write table1_sum _tab %9.2fc (r(mean)) _tab %9.2fc (r(sd)) _n

**** English GPA Row
sum gpaavg if department == "english" & f2period == 1
file write table1_sum "English GPA" _tab %9.2fc (r(mean)) _tab %9.2fc (r(sd)) 

sum gpaavg if department == "english" & l2period == 1
file write table1_sum _tab %9.2fc (r(mean)) _tab %9.2fc (r(sd)) _n

**** English CST Rows
sum cstscoreela if department == "english" & f2period == 1
file write table1_sum "ELA CST" _tab %9.2fc (r(mean)) _tab %9.2fc (r(sd)) 

sum cstscoreela if department == "english" & l2period == 1
file write table1_sum _tab %9.2fc (r(mean)) _tab %9.2fc (r(sd)) _n

preserve
egen person = group(stuid year)  
sort person 
drop if person == person[_n-1]

global sumvar female lesshs hsgrad somecol colgrad gradschool educdecline ell

foreach var in $sumvar {
	sum `var' if f2period == 1 
	file write table1_sum "`var'" _tab %9.2fc (r(mean)) _tab %9.2fc (r(sd))
	
	sum `var' if l2period == 1 
	file write table1_sum _tab %9.2fc (r(mean)) _tab %9.2fc (r(sd)) _n
}

sum female if f2period == 1 
file write table1_sum "Number of Observations" _tab %9.2fc (r(N)) _tab  

sum female if l2period == 1 
file write table1_sum  _tab %9.2fc (r(N)) _tab _n 

restore

file close table1_sum

log close


*****************************************
***** Tables 2 and 3: Main Results ******
*****************************************
cap log close
log using "output/logs/table2_mainb.smcl", replace

*** Math GPA   
reg gpatotal f2period if department == "math", cluster(classid)
outreg2 using "output/table2", replace se bdec(3) bracket nocons

reg gpatotal f2period zcstscoremathprior zcstscoreelaprior gpaavgprior if department == "math", cluster(classid)
outreg2 using "output/table2", append se bdec(3) bracket nocons

xi:reg gpatotal f2period zcstscoremathprior zcstscoreelaprior gpaavgprior female lesshs hsgrad somecol colgrad gradschool ///
	ell i.year i.grade if department == "math", cluster(classid)
outreg2 using "output/table2", append se bdec(3) bracket nocons

xi:areg gpatotal f2period zcstscoremathprior zcstscoreelaprior gpaavgprior female lesshs hsgrad somecol colgrad gradschool ///
	ell i.year i.grade if department == "math", a(crstchs) cluster(classid)
outreg2 using "output/table2", append se bdec(3) bracket nocons

xi:areg diffgpa f2period female lesshs hsgrad somecol colgrad gradschool ell ///
	zcstscoremathprior zcstscoreelaprior i.year i.grade if department == "math", a(crstchs) cluster(classid)
outreg2 using "output/table2", append se bdec(3) bracket nocons

***** Math CST Scores 
reg zcstscoremath f2period if department == "math", cluster(classid)
outreg2 using "output/table2", append se bdec(3) bracket nocons

reg zcstscoremath f2period zcstscoremathprior zcstscoreelaprior gpaavgprior if department == "math", cluster(classid)
outreg2 using "output/table2", append se bdec(3) bracket nocons

xi:reg zcstscoremath f2period zcstscoremathprior zcstscoreelaprior gpaavgprior female lesshs hsgrad somecol colgrad gradschool ///
	ell i.year i.grade if department == "math", cluster(classid)
outreg2 using "output/table2", append se bdec(3) bracket nocons

xi:areg zcstscoremath f2period zcstscoremathprior zcstscoreelaprior gpaavgprior female lesshs hsgrad somecol colgrad gradschool ///
	ell i.year i.grade if department == "math", a(crstchs) cluster(classid)
outreg2 using "output/table2", append se bdec(3) bracket nocons

xi:areg diffcstmath f2period female lesshs hsgrad somecol colgrad gradschool ell ///
	zcstscoreelaprior gpaavgprior i.year i.grade if department == "math", a(crstchs) cluster(classid)
outreg2 using "output/table2", append se bdec(3) bracket nocons

***** English GPA 
reg gpatotal f2period if department == "english", cluster(classid)
outreg2 using "output/table2", append se bdec(3) bracket nocons

reg gpatotal f2period zcstscoremathprior zcstscoreelaprior gpaavgprior if department == "english", cluster(classid)
outreg2 using "output/table2", append se bdec(3) bracket nocons

xi:reg gpatotal f2period zcstscoremathprior zcstscoreelaprior gpaavgprior female lesshs hsgrad somecol colgrad gradschool ///
	ell i.year i.grade if department == "english", cluster(classid)
outreg2 using "output/table2", append se bdec(3) bracket nocons

xi:areg gpatotal f2period zcstscoremathprior zcstscoreelaprior gpaavgprior female lesshs hsgrad somecol colgrad gradschool ///
	ell i.year i.grade if department == "english", a(crstchs) cluster(classid)
outreg2 using "output/table2", append se bdec(3) bracket nocons

xi:areg diffgpa f2period female lesshs hsgrad somecol colgrad gradschool ell ///
	zcstscoremathprior zcstscoreelaprior i.year i.grade if department == "english", a(crstchs) cluster(classid)
outreg2 using "output/table2", append se bdec(3) bracket nocons

***** English CST Scores 
reg zcstscoreela f2period if department == "english", cluster(classid)
outreg2 using "output/table2", append se bdec(3) bracket nocons

reg zcstscoreela f2period zcstscoremathprior zcstscoreelaprior gpaavgprior if department == "english", cluster(classid)
outreg2 using "output/table2", append se bdec(3) bracket nocons

xi:reg zcstscoreela f2period zcstscoremathprior zcstscoreelaprior gpaavgprior female lesshs hsgrad somecol colgrad gradschool ///
	ell i.year i.grade if department == "english", cluster(classid)
outreg2 using "output/table2", append se bdec(3) bracket nocons

xi:areg zcstscoreela f2period zcstscoremathprior zcstscoreelaprior gpaavgprior female lesshs hsgrad somecol colgrad gradschool ///
	ell i.year i.grade if department == "english", a(crstchs) cluster(classid)
outreg2 using "output/table2", append se bdec(3) bracket nocons

xi:areg diffcstela f2period female lesshs hsgrad somecol colgrad gradschool ell ///
	zcstscoremathprior gpaavgprior i.year i.grade if department == "english", a(crstchs) cluster(classid)
outreg2 using "output/table2", append se bdec(3) bracket nocons

log close


*****************************************************************
***** Table 4: Results by Male versus Female and Education ******
*****************************************************************
use figtemp.dta, clear

keep if f2period == 1 | l2period == 1

cap log close
log using "output/logs/table4_gendereducdiff.smcl", replace

file open table4_femalediff using "output/table4_femalediff.txt", write replace

file write table4_femalediff "variable" _tab "femalepoint" _tab "femalese" _n 

***** Results by males and females *****

** Female students 
xi:areg diffgpa f2period lesshs hsgrad somecol colgrad gradschool  ///
	ell zcstscoreelaprior zcstscoremathprior i.year i.grade if department == "math" & female == 1, a(crstchs) cluster(classid)
outreg2 f2period using "output/table4_gen_educdifff", replace se bdec(3) bracket nocons
file write table4_femalediff "mathgpa" _tab %9.7fc (_b[f2period]) _tab %5.7fc (_se[f2period]) _n

xi:areg diffcstmath f2period lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior gpaavgprior i.year i.grade if department == "math" & female == 1, a(crstchs) cluster(classid)
outreg2 f2period using "output/table4_gen_educdifff", append se bdec(3) bracket nocons
file write table4_femalediff "mathcst" _tab %9.7fc (_b[f2period]) _tab %5.7fc (_se[f2period]) _n

xi:areg diffgpa f2period lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior zcstscoremathprior i.year i.grade if department == "english" & female == 1, a(crstchs) cluster(classid)
outreg2 f2period using "output/table4_gen_educdifff", append se bdec(3) bracket nocons
file write table4_femalediff "englishgpa" _tab %9.7fc (_b[f2period]) _tab %5.7fc (_se[f2period]) _n 

xi:areg diffcstela f2period lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoremathprior gpaavgprior i.year i.grade if department == "english" & female == 1, a(crstchs) cluster(classid)
outreg2 f2period using "output/table4_gen_educdifff", append se bdec(3) bracket nocons
file write table4_femalediff "englishcst" _tab %9.7fc (_b[f2period]) _tab %5.7fc (_se[f2period]) _n

file close table4_femalediff

** Male students 
file open table4_malediff using "output/table4_malediff.txt", write replace

file write table4_malediff "variable" _tab "malepoint" _tab "malese" _n 

xi:areg diffgpa f2period lesshs hsgrad somecol colgrad gradschool  ///
	ell zcstscoreelaprior zcstscoremathprior i.year i.grade if department == "math" & female == 0, a(crstchs) cluster(classid)
outreg2 f2period using "output/table4_gen_educdifff", append se bdec(3) bracket nocons
file write table4_malediff "mathgpa" _tab %9.7fc (_b[f2period]) _tab %5.7fc (_se[f2period]) _n

xi:areg diffcstmath f2period lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior gpaavgprior i.year i.grade if department == "math" & female == 0, a(crstchs) cluster(classid)
outreg2 f2period using "output/table4_gen_educdifff", append se bdec(3) bracket nocons
file write table4_malediff "mathcst" _tab %9.7fc (_b[f2period]) _tab %5.7fc (_se[f2period]) _n

xi:areg diffgpa f2period lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior zcstscoremathprior i.year i.grade if department == "english" & female == 0, a(crstchs) cluster(classid)
outreg2 f2period using "output/table4_gen_educdifff", append se bdec(3) bracket nocons
file write table4_malediff "englishgpa" _tab %9.7fc (_b[f2period]) _tab %5.7fc (_se[f2period]) _n

xi:areg diffcstela f2period lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoremathprior gpaavgprior i.year i.grade if department == "english" & female == 0, a(crstchs) cluster(classid)
outreg2 f2period using "output/table4_gen_educdifff", append se bdec(3) bracket nocons
file write table4_malediff "englishcst" _tab %9.7fc (_b[f2period]) _tab %5.7fc (_se[f2period]) _n

file close table4_malediff

***** Results by low and high educated parents  *****

** Low educated parents (< some college)
file open table4_educlowdiff using "output/table4_educlowdiff.txt", write replace

file write table4_educlowdiff "variable" _tab "loweducpoint" _tab "loweducse" _n 

xi:areg diffgpa f2period female lesshs hsgrad somecol colgrad gradschool  ///
	ell zcstscoreelaprior zcstscoremathprior i.year i.grade if department == "math" & somcolplus == 0, a(crstchs) cluster(classid)
outreg2 f2period using "output/table4_gen_educdifff", append se bdec(3) bracket nocons
file write table4_educlowdiff "mathgpa" _tab %9.7fc (_b[f2period]) _tab %5.7fc (_se[f2period]) _n

xi:areg diffcstmath f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior gpaavgprior i.year i.grade if department == "math" & somcolplus == 0, a(crstchs) cluster(classid)
outreg2 f2period using "output/table4_gen_educdifff", append se bdec(3) bracket nocons
file write table4_educlowdiff "mathcst" _tab %9.7fc (_b[f2period]) _tab %5.7fc (_se[f2period]) _n

xi:areg diffgpa f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior zcstscoremathprior i.year i.grade if department == "english" & somcolplus == 0, a(crstchs) cluster(classid)
outreg2 f2period using "output/table4_gen_educdifff", append se bdec(3) bracket nocons
file write table4_educlowdiff "englishgpa" _tab %9.7fc (_b[f2period]) _tab %5.7fc (_se[f2period]) _n

xi:areg diffcstela f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoremathprior gpaavgprior i.year i.grade if department == "english" & somcolplus == 0, a(crstchs) cluster(classid)
outreg2 f2period using "output/table4_gen_educdifff", append se bdec(3) bracket nocons
file write table4_educlowdiff "englishcst" _tab %9.7fc (_b[f2period]) _tab %5.7fc (_se[f2period]) _n

file close table4_educlowdiff

** High Educated Parents (> high school)
file open table4_educhighdiff using "output/table4_educhighdiff.txt", write replace

file write table4_educhighdiff "variable" _tab "higheducpoint" _tab "higheducse" _n 

xi:areg diffgpa f2period female lesshs hsgrad somecol colgrad gradschool  ///
	ell zcstscoreelaprior zcstscoremathprior i.year i.grade if department == "math" & somcolplus == 1, a(crstchs) cluster(classid)
outreg2 f2period using "output/table4_gen_educdifff", append se bdec(3) bracket nocons
file write table4_educhighdiff "mathgpa" _tab %9.7fc (_b[f2period]) _tab %5.7fc (_se[f2period]) _n

xi:areg diffcstmath f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior gpaavgprior i.year i.grade if department == "math" & somcolplus == 1, a(crstchs) cluster(classid)
outreg2 f2period using "output/table4_gen_educdifff", append se bdec(3) bracket nocons
file write table4_educhighdiff "mathcst" _tab %9.7fc (_b[f2period]) _tab %5.7fc (_se[f2period]) _n

xi:areg diffgpa f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior zcstscoremathprior i.year i.grade if department == "english" & somcolplus == 1, a(crstchs) cluster(classid)
outreg2 f2period using "output/table4_gen_educdifff", append se bdec(3) bracket nocons
file write table4_educhighdiff "englishgpa" _tab %9.7fc (_b[f2period]) _tab %5.7fc (_se[f2period]) _n

xi:areg diffcstela f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoremathprior gpaavgprior i.year i.grade if department == "english" & somcolplus == 1, a(crstchs) cluster(classid)
outreg2 f2period using "output/table4_gen_educdifff", append se bdec(3) bracket nocons
file write table4_educhighdiff "englishcst" _tab %9.7fc (_b[f2period]) _tab %5.7fc (_se[f2period]) _n

file close table4_educhighdiff

log close

**** Calculate Difference and the P-Value for the Difference ****
**** Male and Female Performance 
preserve

insheet using "output/table4_femalediff.txt", clear
save "output/table4_femalediff.dta", replace 

insheet using "output/table4_malediff.txt", clear
merge 1:1 variable using "output/table4_femalediff.dta", nogen

gen pointdiff = femalepoint - malepoint 
gen sediff = sqrt((femalese^2) + (malese^2)) 
gen tstat = pointdiff/sediff
gen pvalue = ttail(100000, tstat)
replace pvalue = 1 - pvalue if tstat < 0
replace pvalue = 2*pvalue

****** write difference and p-values 
file open table4_pvaldiff_diff using "output/table4_pvaldiff_diff.txt", write replace

file write table4_pvaldiff_diff "variable" _tab "mathgpa" _tab "mathcst" _tab "englishgpa" _tab "englishcst" _n 

sum pointdiff if variable == "mathgpa"
file write table4_pvaldiff_diff "Difference" _tab %9.3fc (r(mean)) _tab 
sum pointdiff if variable == "mathcst"
file write table4_pvaldiff_diff %9.3fc (r(mean)) _tab 
sum pointdiff if variable == "englishgpa"
file write table4_pvaldiff_diff %9.3fc (r(mean)) _tab 
sum pointdiff if variable == "englishcst"
file write table4_pvaldiff_diff %9.3fc (r(mean)) _n 
 
sum pvalue if variable == "mathgpa"
file write table4_pvaldiff_diff "P-value of Difference" _tab %9.3fc (r(mean)) _tab 
sum pvalue if variable == "mathcst"
file write table4_pvaldiff_diff %9.3fc (r(mean)) _tab 
sum pvalue if variable == "englishgpa"
file write table4_pvaldiff_diff %9.3fc (r(mean)) _tab 
sum pvalue if variable == "englishcst"
file write table4_pvaldiff_diff %9.3fc (r(mean)) _n 
 
file close table4_pvaldiff_diff

**** Low and high education  
insheet using "output/table4_educlowdiff.txt", clear
save "output/table4_educlowdiff.dta", replace 

insheet using "output/table4_educhighdiff.txt", clear
merge 1:1 variable using "output/table4_educlowdiff.dta", nogen

gen pointdiff = loweducpoint - higheducpoint 
gen sediff = sqrt((loweducse^2) + (higheducse^2)) 
gen tstat = pointdiff/sediff
gen pvalue = ttail(100000, tstat)
replace pvalue = 1 - pvalue if tstat < 0
replace pvalue = 2*pvalue

****** Write Difference and P-Values 
file open table4_grade_pvaldiff_diff using "output/table4_grade_pvaldiff_diff.txt", write replace

file write table4_grade_pvaldiff_diff "variable" _tab "mathgpa" _tab "mathcst" _tab "englishgpa" _tab "englishcst" _n 

sum pointdiff if variable == "mathgpa"
file write table4_grade_pvaldiff_diff "Grade Estimates Difference" _tab %9.3fc (r(mean)) _tab 
sum pointdiff if variable == "mathcst"
file write table4_grade_pvaldiff_diff %9.3fc (r(mean)) _tab 
sum pointdiff if variable == "englishgpa"
file write table4_grade_pvaldiff_diff %9.3fc (r(mean)) _tab 
sum pointdiff if variable == "englishcst"
file write table4_grade_pvaldiff_diff %9.3fc (r(mean)) _n 
 
sum pvalue if variable == "mathgpa"
file write table4_grade_pvaldiff_diff "P-value of Difference" _tab %9.3fc (r(mean)) _tab 
sum pvalue if variable == "mathcst"
file write table4_grade_pvaldiff_diff %9.3fc (r(mean)) _tab 
sum pvalue if variable == "englishgpa"
file write table4_grade_pvaldiff_diff %9.3fc (r(mean)) _tab 
sum pvalue if variable == "englishcst"
file write table4_grade_pvaldiff_diff %9.3fc (r(mean)) _n 
 
file close table4_grade_pvaldiff_diff

restore


****************************************************************
***** Table 5: Results by Prior Performance and by Grade  ******
****************************************************************
cap log close
log using "output/logs/table5_grade_performancediff.smcl", replace

file open table5_perflowdiff using "output/table5_perflowdiff.txt", write replace

file write table5_perflowdiff "variable" _tab "lowpoint" _tab "lowse" _n 

***** Results by high and low prior performance *****

** Low performing students 
xi:areg diffgpa f2period female lesshs hsgrad somecol colgrad gradschool  ///
	ell zcstscoreelaprior zcstscoremathprior i.year i.grade if department == "math" & abovemedgpa == 0, a(crstchs) cluster(classid)
outreg2 f2period using "output/table5_per_gradediff", replace se bdec(3) bracket nocons
file write table5_perflowdiff "mathgpa" _tab %9.7fc (_b[f2period]) _tab %5.7fc (_se[f2period]) _n

xi:areg diffcstmath f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior gpaavgprior i.year i.grade if department == "math" & abovemedgpa == 0, a(crstchs) cluster(classid)
outreg2 f2period using "output/table5_per_gradediff", append se bdec(3) bracket nocons
file write table5_perflowdiff "mathcst" _tab %9.7fc (_b[f2period]) _tab %5.7fc (_se[f2period]) _n

xi:areg diffgpa f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior zcstscoremathprior i.year i.grade if department == "english" & abovemedgpa == 0, a(crstchs) cluster(classid)
outreg2 f2period using "output/table5_per_gradediff", append se bdec(3) bracket nocons
file write table5_perflowdiff "englishgpa" _tab %9.7fc (_b[f2period]) _tab %5.7fc (_se[f2period]) _n 

xi:areg diffcstela f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoremathprior gpaavgprior i.year i.grade if department == "english" & abovemedgpa == 0, a(crstchs) cluster(classid)
outreg2 f2period using "output/table5_per_gradediff", append se bdec(3) bracket nocons
file write table5_perflowdiff "englishcst" _tab %9.7fc (_b[f2period]) _tab %5.7fc (_se[f2period]) _n

file close table5_perflowdiff

** High performing students 
file open table5_perfhighdiff using "output/table5_perfhighdiff.txt", write replace

file write table5_perfhighdiff "variable" _tab "highpoint" _tab "highse" _n 

xi:areg diffgpa f2period female lesshs hsgrad somecol colgrad gradschool  ///
	ell zcstscoreelaprior zcstscoremathprior i.year i.grade if department == "math" & abovemedgpa == 1, a(crstchs) cluster(classid)
outreg2 f2period using "output/table5_per_gradediff", append se bdec(3) bracket nocons
file write table5_perfhighdiff "mathgpa" _tab %9.7fc (_b[f2period]) _tab %5.7fc (_se[f2period]) _n

xi:areg diffcstmath f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior gpaavgprior i.year i.grade if department == "math" & abovemedgpa == 1, a(crstchs) cluster(classid)
outreg2 f2period using "output/table5_per_gradediff", append se bdec(3) bracket nocons
file write table5_perfhighdiff "mathcst" _tab %9.7fc (_b[f2period]) _tab %5.7fc (_se[f2period]) _n

xi:areg diffgpa f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior zcstscoremathprior i.year i.grade if department == "english" & abovemedgpa == 1, a(crstchs) cluster(classid)
outreg2 f2period using "output/table5_per_gradediff", append se bdec(3) bracket nocons
file write table5_perfhighdiff "englishgpa" _tab %9.7fc (_b[f2period]) _tab %5.7fc (_se[f2period]) _n

xi:areg diffcstela f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoremathprior gpaavgprior i.year i.grade if department == "english" & abovemedgpa == 1, a(crstchs) cluster(classid)
outreg2 f2period using "output/table5_per_gradediff", append se bdec(3) bracket nocons
file write table5_perfhighdiff "englishcst" _tab %9.7fc (_b[f2period]) _tab %5.7fc (_se[f2period]) _n

file close table5_perfhighdiff

***** Results by young and old grade  *****

** Young grades (ie grades 6 to 8)
file open table5_gradelowdiff using "output/table5_gradelowdiff.txt", write replace

file write table5_gradelowdiff "variable" _tab "lowgradepoint" _tab "lowgradese" _n 

 
xi:areg diffgpa f2period female lesshs hsgrad somecol colgrad gradschool  ///
	ell zcstscoreelaprior zcstscoremathprior i.year i.grade if department == "math" & grade >= 6 & grade <= 8, a(crstchs) cluster(classid)
outreg2 f2period using "output/table5_per_gradediff", append se bdec(3) bracket nocons
file write table5_gradelowdiff "mathgpa" _tab %9.7fc (_b[f2period]) _tab %5.7fc (_se[f2period]) _n

xi:areg diffcstmath f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior gpaavgprior i.year i.grade if department == "math" & grade >= 6 & grade <= 8, a(crstchs) cluster(classid)
outreg2 f2period using "output/table5_per_gradediff", append se bdec(3) bracket nocons
file write table5_gradelowdiff "mathcst" _tab %9.7fc (_b[f2period]) _tab %5.7fc (_se[f2period]) _n

xi:areg diffgpa f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior zcstscoremathprior i.year i.grade if department == "english" & grade >= 6 & grade <= 8, a(crstchs) cluster(classid)
outreg2 f2period using "output/table5_per_gradediff", append se bdec(3) bracket nocons
file write table5_gradelowdiff "englishgpa" _tab %9.7fc (_b[f2period]) _tab %5.7fc (_se[f2period]) _n

xi:areg diffcstela f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoremathprior gpaavgprior i.year i.grade if department == "english" & grade >= 6 & grade <= 8, a(crstchs) cluster(classid)
outreg2 f2period using "output/table5_per_gradediff", append se bdec(3) bracket nocons
file write table5_gradelowdiff "englishcst" _tab %9.7fc (_b[f2period]) _tab %5.7fc (_se[f2period]) _n

file close table5_gradelowdiff

** Old grades (ie grades 9 to 11)
file open table5_gradehighdiff using "output/table5_gradehighdiff.txt", write replace

file write table5_gradehighdiff "variable" _tab "highgradepoint" _tab "highgradese" _n 

xi:areg diffgpa f2period female lesshs hsgrad somecol colgrad gradschool  ///
	ell zcstscoreelaprior zcstscoremathprior i.year i.grade if department == "math" & grade >= 9 & grade <= 11, a(crstchs) cluster(classid)
outreg2 f2period using "output/table5_per_gradediff", append se bdec(3) bracket nocons
file write table5_gradehighdiff "mathgpa" _tab %9.7fc (_b[f2period]) _tab %5.7fc (_se[f2period]) _n

xi:areg diffcstmath f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior gpaavgprior i.year i.grade if department == "math" & grade >= 9 & grade <= 11, a(crstchs) cluster(classid)
outreg2 f2period using "output/table5_per_gradediff", append se bdec(3) bracket nocons
file write table5_gradehighdiff "mathcst" _tab %9.7fc (_b[f2period]) _tab %5.7fc (_se[f2period]) _n

xi:areg diffgpa f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior zcstscoremathprior i.year i.grade if department == "english" & grade >= 9 & grade <= 11, a(crstchs) cluster(classid)
outreg2 f2period using "output/table5_per_gradediff", append se bdec(3) bracket nocons
file write table5_gradehighdiff "englishgpa" _tab %9.7fc (_b[f2period]) _tab %5.7fc (_se[f2period]) _n

xi:areg diffcstela f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoremathprior gpaavgprior i.year i.grade if department == "english" & grade >= 9 & grade <= 11, a(crstchs) cluster(classid)
outreg2 f2period using "output/table5_per_gradediff", append se bdec(3) bracket nocons
file write table5_gradehighdiff "englishcst" _tab %9.7fc (_b[f2period]) _tab %5.7fc (_se[f2period]) _n

file close table5_gradehighdiff

log close

**** Calculate Difference and the P-Value for the Difference

**** Low and High Performance 
preserve

insheet using "output/table5_perflowdiff.txt", clear
save "output/table5_perflowdiff.dta", replace 

insheet using "output/table5_perfhighdiff.txt", clear
merge 1:1 variable using "output/table5_perflowdiff.dta", nogen

gen pointdiff = lowpoint - highpoint 
gen sediff = sqrt((lowse^2) + (highse^2)) 
gen tstat = pointdiff/sediff
gen pvalue = ttail(100000, tstat)
replace pvalue = 1 - pvalue if tstat < 0
replace pvalue = 2*pvalue

****** Write Difference and P-Values 
file open table5_pvaldiff_diff using "output/table5_pvaldiff_diff.txt", write replace

file write table5_pvaldiff_diff "variable" _tab "mathgpa" _tab "mathcst" _tab "englishgpa" _tab "englishcst" _n 

sum pointdiff if variable == "mathgpa"
file write table5_pvaldiff_diff "Difference" _tab %9.3fc (r(mean)) _tab 
sum pointdiff if variable == "mathcst"
file write table5_pvaldiff_diff %9.3fc (r(mean)) _tab 
sum pointdiff if variable == "englishgpa"
file write table5_pvaldiff_diff %9.3fc (r(mean)) _tab 
sum pointdiff if variable == "englishcst"
file write table5_pvaldiff_diff %9.3fc (r(mean)) _n 
 
sum pvalue if variable == "mathgpa"
file write table5_pvaldiff_diff "P-value of Difference" _tab %9.3fc (r(mean)) _tab 
sum pvalue if variable == "mathcst"
file write table5_pvaldiff_diff %9.3fc (r(mean)) _tab 
sum pvalue if variable == "englishgpa"
file write table5_pvaldiff_diff %9.3fc (r(mean)) _tab 
sum pvalue if variable == "englishcst"
file write table5_pvaldiff_diff %9.3fc (r(mean)) _n 
 
file close table5_pvaldiff_diff

**** Low (6 to 8) and High (9 to 11) grades 
insheet using "output/table5_gradelowdiff.txt", clear
save "output/table5_gradelowdiff.dta", replace 

insheet using "output/table5_gradehighdiff.txt", clear
merge 1:1 variable using "output/table5_gradelowdiff.dta", nogen

gen pointdiff = lowgradepoint - highgradepoint 
gen sediff = sqrt((lowgradese^2) + (highgradese^2)) 
gen tstat = pointdiff/sediff
gen pvalue = ttail(100000, tstat)
replace pvalue = 1 - pvalue if tstat < 0
replace pvalue = 2*pvalue

****** Write Difference and P-Values 
file open table5_grade_pvaldiff_diff using "output/table5_grade_pvaldiff_diff.txt", write replace

file write table5_grade_pvaldiff_diff "variable" _tab "mathgpa" _tab "mathcst" _tab "englishgpa" _tab "englishcst" _n 

sum pointdiff if variable == "mathgpa"
file write table5_grade_pvaldiff_diff "Grade Estimates Difference" _tab %9.3fc (r(mean)) _tab 
sum pointdiff if variable == "mathcst"
file write table5_grade_pvaldiff_diff %9.3fc (r(mean)) _tab 
sum pointdiff if variable == "englishgpa"
file write table5_grade_pvaldiff_diff %9.3fc (r(mean)) _tab 
sum pointdiff if variable == "englishcst"
file write table5_grade_pvaldiff_diff %9.3fc (r(mean)) _n 
 
sum pvalue if variable == "mathgpa"
file write table5_grade_pvaldiff_diff "P-value of Difference" _tab %9.3fc (r(mean)) _tab 
sum pvalue if variable == "mathcst"
file write table5_grade_pvaldiff_diff %9.3fc (r(mean)) _tab 
sum pvalue if variable == "englishgpa"
file write table5_grade_pvaldiff_diff %9.3fc (r(mean)) _tab 
sum pvalue if variable == "englishcst"
file write table5_grade_pvaldiff_diff %9.3fc (r(mean)) _n 
 
file close table5_grade_pvaldiff_diff

restore


**************************************
***** Table 6: Robustness Check ******
**************************************
cap log close
log using "output/logs/table6_robust.smcl", replace

file open table6_robust using "output/table6_robust", write replace

******* Math GPA  (Baseline first diff, polynomial, 2 prior years, fixed effects, three falsification tests).  
xi:areg gpaavg f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior zcstscoremathprior gpaavgprior i.year i.grade if department == "math", a(crstchs) cluster(classid)
file write table6_robust "Math GPA" _tab %9.4fc (_b[f2period]) _tab "[" %5.3fc (_se[f2period]) "]" _tab      

xi:areg diffgpa f2period female lesshs hsgrad somecol colgrad gradschool ell ///
	zcstscoreelaprior zcstscoremathprior i.year i.grade if department == "math", a(crstchs) cluster(classid)
file write table6_robust %9.4fc (_b[f2period]) _tab "[" %5.3fc (_se[f2period]) "]" _tab

xi:areg gpaavg f2period female lesshs hsgrad somecol colgrad gradschool ell ///
	zcstscoreelaprior zcstscoremathprior gpaavgprior zcstscoreelaprior_to2 zcstscoremathprior_to2 gpaavgprior_to2 ///
	zcstscoreelaprior_to3 zcstscoremathprior_to3 gpaavgprior_to3 zcstscoreelaprior_to4 zcstscoremathprior_to4 gpaavgprior_to4 ///
	zcstscoreelaprior_to5 zcstscoremathprior_to5 gpaavgprior_to5 ///
	i.year i.grade if department == "math", a(crstchs) cluster(classid)
file write table6_robust %9.4fc (_b[f2period]) _tab "[" %5.3fc (_se[f2period]) "]" _tab      

xi:areg gpaavg f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior zcstscoremathprior gpaavgprior zcstscoreelaprior2 zcstscoremathprior2 gpaavgprior2 ///
	i.year i.grade if department == "math", a(crstchs) cluster(classid)
file write table6_robust %9.4fc (_b[f2period]) _tab "[" %5.3fc (_se[f2period]) "]" _tab      

xi:felsdvreg gpatotal f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior zcstscoremathprior gpaavgprior i.year i.grade if department == "math", i(stuid) j(crstchs) ///
	peff(aa) feff(bb) xb(cc) res(dd) mover(ee) group(gg) mnum(hh) pobs(ii)
file write table6_robust %9.4fc (_b[f2period]) _tab "[" %5.3fc (_se[f2period]) "]" _tab

xi:areg gpaavgprior f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior2 zcstscoremathprior2 gpaavgprior2 i.yearprior i.grade if department == "math", a(crstchs) cluster(classid)
file write table6_robust %9.4fc (_b[f2period]) _tab "[" %5.3fc (_se[f2period]) "]" _tab      

xi:areg gpaavgprior2 f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior3 zcstscoremathprior3 gpaavgprior3 i.yearprior2 i.grade if department == "math", a(crstchs) cluster(classid)
file write table6_robust %9.4fc (_b[f2period]) _tab "[" %5.3fc (_se[f2period]) "]" _tab      

xi:areg gpaavgprior3 f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior4 zcstscoremathprior4 gpaavgprior4 i.yearprior3 i.grade if department == "math", a(crstchs) cluster(classid)
file write table6_robust %9.4fc (_b[f2period]) _tab "[" %5.3fc (_se[f2period]) "]" _n     

***** Math CST scores
xi:areg zcstscoremath f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior zcstscoremathprior gpaavgprior i.year i.grade if department == "math", a(crstchs) cluster(classid)
file write table6_robust "Math CST" _tab %9.4fc (_b[f2period]) _tab "[" %5.3fc (_se[f2period]) "]" _tab

xi:areg diffcstmath f2period female lesshs hsgrad somecol colgrad gradschool ell ///
	zcstscoreelaprior gpaavgprior i.year i.grade if department == "math", a(crstchs) cluster(classid)
file write table6_robust %9.4fc (_b[f2period]) _tab "[" %5.3fc (_se[f2period]) "]" _tab

xi:areg zcstscoremath f2period female lesshs hsgrad somecol colgrad gradschool ell ///
	zcstscoreelaprior zcstscoremathprior gpaavgprior zcstscoreelaprior_to2 zcstscoremathprior_to2 gpaavgprior_to2 ///
	zcstscoreelaprior_to3 zcstscoremathprior_to3 gpaavgprior_to3 zcstscoreelaprior_to4 zcstscoremathprior_to4 gpaavgprior_to4 ///
	zcstscoreelaprior_to5 zcstscoremathprior_to5 gpaavgprior_to5 ///
	i.year i.grade if department == "math", a(crstchs) cluster(classid)
file write table6_robust %9.4fc (_b[f2period]) _tab "[" %5.3fc (_se[f2period]) "]" _tab

xi:areg zcstscoremath f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior zcstscoremathprior gpaavgprior zcstscoreelaprior2 zcstscoremathprior2 gpaavgprior2 ///
	i.year i.grade if department == "math", a(crstchs) cluster(classid)
file write table6_robust %9.4fc (_b[f2period]) _tab "[" %5.3fc (_se[f2period]) "]" _tab

xi:felsdvreg zcstscoremath f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior zcstscoremathprior gpaavgprior i.year i.grade if department == "math", i(stuid) j(crstchs) ///
	peff(aa) feff(bb) xb(cc) res(dd) mover(ee) group(gg) mnum(hh) pobs(ii)
file write table6_robust %9.4fc (_b[f2period]) _tab "[" %5.3fc (_se[f2period]) "]" _tab

xi:areg zcstscoremathprior f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior2 zcstscoremathprior2 gpaavgprior2 i.yearprior i.grade if department == "math", a(crstchs) cluster(classid)
file write table6_robust %9.4fc (_b[f2period]) _tab "[" %5.3fc (_se[f2period]) "]" _tab

xi:areg zcstscoremathprior2 f2period female lesshs hsgrad somecol colgrad gradschool /// 
	ell zcstscoreelaprior3 zcstscoremathprior3 gpaavgprior3 i.yearprior2 i.grade if department == "math", a(crstchs) cluster(classid)
file write table6_robust %9.4fc (_b[f2period]) _tab "[" %5.3fc (_se[f2period]) "]" _tab

xi:areg zcstscoremathprior3 f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior4 zcstscoremathprior4 gpaavgprior4 i.yearprior3 i.grade if department == "math", a(crstchs) cluster(classid)
file write table6_robust %9.4fc (_b[f2period]) _tab "[" %5.3fc (_se[f2period]) "]" _n

**** English GPA
xi:areg gpaavg f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior zcstscoremathprior gpaavgprior i.year i.grade if department == "english", a(crstchs) cluster(classid)
file write table6_robust "English GPA" _tab %9.4fc (_b[f2period]) _tab "[" %5.3fc (_se[f2period]) "]" _tab

xi:areg diffgpa f2period female lesshs hsgrad somecol colgrad gradschool ell ///
	zcstscoreelaprior zcstscoremathprior i.year i.grade if department == "english", a(crstchs) cluster(classid)
file write table6_robust %9.4fc (_b[f2period]) _tab "[" %5.3fc (_se[f2period]) "]" _tab

xi:areg gpaavg f2period female lesshs hsgrad somecol colgrad gradschool ell ///
	ell zcstscoreelaprior zcstscoremathprior gpaavgprior zcstscoreelaprior_to2 zcstscoremathprior_to2 gpaavgprior_to2 ///
	zcstscoreelaprior_to3 zcstscoremathprior_to3 gpaavgprior_to3 zcstscoreelaprior_to4 zcstscoremathprior_to4 gpaavgprior_to4 ///
	zcstscoreelaprior_to5 zcstscoremathprior_to5 gpaavgprior_to5 ///
	i.year i.grade if department == "english", a(crstchs) cluster(classid)
file write table6_robust %9.4fc (_b[f2period]) _tab "[" %5.3fc (_se[f2period]) "]" _tab

xi:areg gpaavg f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior zcstscoremathprior gpaavgprior zcstscoreelaprior2 zcstscoremathprior2 gpaavgprior2 ///
	i.year i.grade if department == "english", a(crstchs) cluster(classid)
file write table6_robust %9.4fc (_b[f2period]) _tab "[" %5.3fc (_se[f2period]) "]" _tab

xi:felsdvreg gpatotal f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior zcstscoremathprior gpaavgprior i.year i.grade if department == "english", i(stuid) j(crstchs) ///
	peff(aa) feff(bb) xb(cc) res(dd) mover(ee) group(gg) mnum(hh) pobs(ii)
file write table6_robust %9.4fc (_b[f2period]) _tab "[" %5.3fc (_se[f2period]) "]" _tab

xi:areg gpaavgprior f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior2 zcstscoremathprior2 gpaavgprior2 i.yearprior i.grade if department == "english", a(crstchs) cluster(classid)
file write table6_robust %9.4fc (_b[f2period]) _tab "[" %5.3fc (_se[f2period]) "]" _tab

xi:areg gpaavgprior2 f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior3 zcstscoremathprior3 gpaavgprior3 i.yearprior2 i.grade if department == "english", a(crstchs) cluster(classid)
file write table6_robust %9.4fc (_b[f2period]) _tab "[" %5.3fc (_se[f2period]) "]" _tab

xi:areg gpaavgprior3 f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior4 zcstscoremathprior4 gpaavgprior4 i.yearprior3 i.grade if department == "english", a(crstchs) cluster(classid)
file write table6_robust %9.4fc (_b[f2period]) _tab "[" %5.3fc (_se[f2period]) "]" _n

**** English CST Score 
xi:areg zcstscoreela f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior zcstscoremathprior gpaavgprior i.year i.grade if department == "english", a(crstchs) cluster(classid)
file write table6_robust "English CST" _tab %9.4fc (_b[f2period]) _tab "[" %5.3fc (_se[f2period]) "]" _tab

xi:areg diffcstela f2period female lesshs hsgrad somecol colgrad gradschool ell ///
	zcstscoremathprior gpaavgprior i.year i.grade if department == "english", a(crstchs) cluster(classid)
file write table6_robust %9.4fc (_b[f2period]) _tab "[" %5.3fc (_se[f2period]) "]" _tab
	
xi:areg zcstscoreela f2period female lesshs hsgrad somecol colgrad gradschool ell ///
	zcstscoreelaprior zcstscoremathprior gpaavgprior zcstscoreelaprior_to2 zcstscoremathprior_to2 gpaavgprior_to2 ///
	zcstscoreelaprior_to3 zcstscoremathprior_to3 gpaavgprior_to3 zcstscoreelaprior_to4 zcstscoremathprior_to4 gpaavgprior_to4 ///
	zcstscoreelaprior_to5 zcstscoremathprior_to5 gpaavgprior_to5 ///
	i.year i.grade if department == "english", a(crstchs) cluster(classid)
file write table6_robust %9.4fc (_b[f2period]) _tab "[" %5.3fc (_se[f2period]) "]" _tab

xi:areg zcstscoreela f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior zcstscoremathprior gpaavgprior zcstscoreelaprior2 zcstscoremathprior2 gpaavgprior2 ///
	i.year i.grade if department == "english", a(crstchs) cluster(classid)
file write table6_robust %9.4fc (_b[f2period]) _tab "[" %5.3fc (_se[f2period]) "]" _tab

xi:felsdvreg zcstscoreela f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior zcstscoremathprior gpaavgprior i.year i.grade if department == "english", i(stuid) j(crstchs) ///
	peff(aa) feff(bb) xb(cc) res(dd) mover(ee) group(gg) mnum(hh) pobs(ii)
file write table6_robust %9.4fc (_b[f2period]) _tab "[" %5.3fc (_se[f2period]) "]" _tab

xi:areg zcstscoreelaprior f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior2 zcstscoremathprior2 gpaavgprior2 i.yearprior i.grade if department == "english", a(crstchs) cluster(classid)
file write table6_robust %9.4fc (_b[f2period]) _tab "[" %5.3fc (_se[f2period]) "]" _tab

xi:areg zcstscoreelaprior2 f2period female lesshs hsgrad somecol colgrad gradschool /// 
	ell zcstscoreelaprior3 zcstscoremathprior3 gpaavgprior3 i.yearprior2 i.grade if department == "english", a(crstchs) cluster(classid)
file write table6_robust %9.4fc (_b[f2period]) _tab "[" %5.3fc (_se[f2period]) "]" _tab

xi:areg zcstscoreelaprior3 f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior4 zcstscoremathprior4 gpaavgprior4 i.yearprior3 i.grade if department == "english", a(crstchs) cluster(classid)
file write table6_robust %9.4fc (_b[f2period]) _tab "[" %5.3fc (_se[f2period]) "]" _tab
	
file close table6_robust


log close 


*********************
*********************
***** Figures  ******
*********************
*********************

*******************************************************************
***** Figure 1: Dynamic Table in Graph Format, Years -3 to 4 ******
*******************************************************************
use figtemp.dta, clear

keep if f2period == 1 | l2period == 1

file open figure1_table using "output/figure1_table.txt", write replace

file write figure1_table "year" _tab "mathgpapoint" _tab "mathgpase" _tab "mathcstpoint" _tab "mathcstse" _tab ///
		"englishgpapoint" _tab "englishgpase" _tab "englishcstpoint" _tab "englishcstse" _n

***** Three years prior 
xi:areg gpaavgprior3 f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior4 zcstscoremathprior4 gpaavgprior4 i.yearprior3 i.grade if department == "math", a(crstchs) cluster(classid)
file write figure1_table "3 Years Prior" _tab %9.4fc (_b[f2period]) _tab %5.3fc (_se[f2period]) _tab      

xi:areg zcstscoremathprior3 f2period female lesshs hsgrad somecol colgrad gradschool /// 
	ell zcstscoreelaprior4 zcstscoremathprior4 gpaavgprior4 i.yearprior3 i.grade if department == "math", a(crstchs) cluster(classid)
file write figure1_table %9.4fc (_b[f2period]) _tab %5.3fc (_se[f2period]) _tab

xi:areg gpaavgprior3 f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior4 zcstscoremathprior4 gpaavgprior4 i.yearprior3 i.grade if department == "english", a(crstchs) cluster(classid)
file write figure1_table %9.4fc (_b[f2period]) _tab %5.3fc (_se[f2period]) _tab

xi:areg zcstscoreelaprior3 f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior4 zcstscoremathprior4 gpaavgprior4 i.yearprior3 i.grade if department == "english", a(crstchs) cluster(classid)
file write figure1_table %9.4fc (_b[f2period]) _tab %5.3fc (_se[f2period]) _n

***** Two years prior 
xi:areg gpaavgprior2 f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior3 zcstscoremathprior3 gpaavgprior3 i.yearprior2 i.grade if department == "math", a(crstchs) cluster(classid)
file write figure1_table "2 Years Prior" _tab %9.4fc (_b[f2period]) _tab %5.3fc (_se[f2period]) _tab      

xi:areg zcstscoremathprior2 f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior3 zcstscoremathprior3 gpaavgprior3 i.yearprior2 i.grade if department == "math", a(crstchs) cluster(classid)
file write figure1_table %9.4fc (_b[f2period]) _tab %5.3fc (_se[f2period]) _tab

xi:areg gpaavgprior2 f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior3 zcstscoremathprior3 gpaavgprior3 i.yearprior2 i.grade if department == "english", a(crstchs) cluster(classid)
file write figure1_table %9.4fc (_b[f2period]) _tab %5.3fc (_se[f2period]) _tab

xi:areg zcstscoreelaprior2 f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior3 zcstscoremathprior3 gpaavgprior3 i.yearprior2 i.grade if department == "english", a(crstchs) cluster(classid)
file write figure1_table %9.4fc (_b[f2period]) _tab %5.3fc (_se[f2period]) _n

**** One year prior 
xi:areg gpaavgprior f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior2 zcstscoremathprior2 gpaavgprior2 i.yearprior i.grade if department == "math", a(crstchs) cluster(classid)
file write figure1_table "Prior Year" _tab %9.4fc (_b[f2period]) _tab %5.3fc (_se[f2period]) _tab      

xi:areg zcstscoremathprior f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior2 zcstscoremathprior2 gpaavgprior2 i.yearprior i.grade if department == "math", a(crstchs) cluster(classid)
file write figure1_table %9.4fc (_b[f2period]) _tab %5.3fc (_se[f2period]) _tab

xi:areg gpaavgprior f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior2 zcstscoremathprior2 gpaavgprior2 i.yearprior i.grade if department == "english", a(crstchs) cluster(classid)
file write figure1_table %9.4fc (_b[f2period]) _tab %5.3fc (_se[f2period]) _tab

xi:areg zcstscoreelaprior f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior2 zcstscoremathprior2 gpaavgprior2 i.yearprior i.grade if department == "english", a(crstchs) cluster(classid)
file write figure1_table %9.4fc (_b[f2period]) _tab %5.3fc (_se[f2period]) _n

**** Current Year
xi:areg gpaavg f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior zcstscoremathprior gpaavgprior i.year i.grade if department == "math", a(crstchs) cluster(classid)
file write figure1_table "Current Year" _tab %9.4fc (_b[f2period]) _tab %5.3fc (_se[f2period]) _tab      

xi:areg zcstscoremath f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior zcstscoremathprior gpaavgprior i.year i.grade if department == "math", a(crstchs) cluster(classid)
file write figure1_table %9.4fc (_b[f2period]) _tab %5.3fc (_se[f2period]) _tab

xi:areg gpaavg f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior zcstscoremathprior gpaavgprior i.year i.grade if department == "english", a(crstchs) cluster(classid)
file write figure1_table %9.4fc (_b[f2period]) _tab %5.3fc (_se[f2period]) _tab

xi:areg zcstscoreela f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior zcstscoremathprior gpaavgprior i.year i.grade if department == "english", a(crstchs) cluster(classid)
file write figure1_table %9.4fc (_b[f2period]) _tab %5.3fc (_se[f2period]) _n

**** Next Year
xi:areg gpaavgnext f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior zcstscoremathprior gpaavgprior i.year i.grade if department == "math", a(crstchs) cluster(classid)
file write figure1_table "Next Year" _tab %9.4fc (_b[f2period]) _tab %5.3fc (_se[f2period]) _tab 

xi:areg zcstscoremathnext f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior zcstscoremathprior gpaavgprior i.year i.grade if department == "math", a(crstchs) cluster(classid)
file write figure1_table %9.4fc (_b[f2period]) _tab %5.3fc (_se[f2period]) _tab

xi:areg gpaavgnext f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior zcstscoremathprior gpaavgprior i.year i.grade if department == "english", a(crstchs) cluster(classid)
file write figure1_table %9.4fc (_b[f2period]) _tab %5.3fc (_se[f2period]) _tab

xi:areg zcstscoreelanext f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior zcstscoremathprior gpaavgprior i.year i.grade if department == "english", a(crstchs) cluster(classid)
file write figure1_table %9.4fc (_b[f2period]) _tab %5.3fc (_se[f2period]) _n

**** 2 Years in the future
xi:areg gpaavgnext2 f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior zcstscoremathprior gpaavgprior i.year i.grade if department == "math", a(crstchs) cluster(classid)
file write figure1_table "Next2 Year" _tab %9.4fc (_b[f2period]) _tab %5.3fc (_se[f2period]) _tab 

xi:areg zcstscoremathnext2 f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior zcstscoremathprior gpaavgprior i.year i.grade if department == "math", a(crstchs) cluster(classid)
file write figure1_table %9.4fc (_b[f2period]) _tab %5.3fc (_se[f2period]) _tab

xi:areg gpaavgnext2 f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior zcstscoremathprior gpaavgprior i.year i.grade if department == "english", a(crstchs) cluster(classid)
file write figure1_table %9.4fc (_b[f2period]) _tab %5.3fc (_se[f2period]) _tab

xi:areg zcstscoreelanext2 f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior zcstscoremathprior gpaavgprior i.year i.grade if department == "english", a(crstchs) cluster(classid)
file write figure1_table %9.4fc (_b[f2period]) _tab %5.3fc (_se[f2period]) _n

**** 3 Years in the future
xi:areg gpaavgnext3 f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior zcstscoremathprior gpaavgprior i.year i.grade if department == "math", a(crstchs) cluster(classid)
file write figure1_table "Next3 Year" _tab %9.4fc (_b[f2period]) _tab %5.3fc (_se[f2period]) _tab 

xi:areg zcstscoremathnext3 f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior zcstscoremathprior gpaavgprior i.year i.grade if department == "math", a(crstchs) cluster(classid)
file write figure1_table %9.4fc (_b[f2period]) _tab %5.3fc (_se[f2period]) _tab

xi:areg gpaavgnext3 f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior zcstscoremathprior gpaavgprior i.year i.grade if department == "english", a(crstchs) cluster(classid)
file write figure1_table %9.4fc (_b[f2period]) _tab %5.3fc (_se[f2period]) _tab

xi:areg zcstscoreelanext3 f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior zcstscoremathprior gpaavgprior i.year i.grade if department == "english", a(crstchs) cluster(classid)
file write figure1_table %9.4fc (_b[f2period]) _tab %5.3fc (_se[f2period]) _n

**** 4 Years in the future
xi:areg gpaavgnext4 f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior zcstscoremathprior gpaavgprior i.year i.grade if department == "math", a(crstchs) cluster(classid)
file write figure1_table "Next4 Year" _tab %9.4fc (_b[f2period]) _tab %5.3fc (_se[f2period]) _tab 

xi:areg zcstscoremathnext4 f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior zcstscoremathprior gpaavgprior i.year i.grade if department == "math", a(crstchs) cluster(classid)
file write figure1_table %9.4fc (_b[f2period]) _tab %5.3fc (_se[f2period]) _tab

xi:areg gpaavgnext4 f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior zcstscoremathprior gpaavgprior i.year i.grade if department == "english", a(crstchs) cluster(classid)
file write figure1_table %9.4fc (_b[f2period]) _tab %5.3fc (_se[f2period]) _tab

xi:areg zcstscoreelanext4 f2period female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior zcstscoremathprior gpaavgprior i.year i.grade if department == "english", a(crstchs) cluster(classid)
file write figure1_table %9.4fc (_b[f2period]) _tab %5.3fc (_se[f2period]) _n

file close figure1_table

insheet using "output/figure1_table.txt", clear

gen mathgpaub = mathgpapoint + 2*mathgpase
gen mathgpalb = mathgpapoint - 2*mathgpase
gen mathcstub = mathcstpoint + 2*mathcstse
gen mathcstlb = mathcstpoint - 2*mathcstse
gen englishgpaub = englishgpapoint + 2*englishgpase
gen englishgpalb = englishgpapoint - 2*englishgpase
gen englishcstub = englishcstpoint + 2*englishcstse
gen englishcstlb = englishcstpoint - 2*englishcstse

gen year1 = _n - 4 
replace year1 = year1 - .05
gen year2 = year1 + 0.1 

twoway (scatter mathgpapoint year1, c(1) msymbol(circle) mcolor(black) lcolor(black) lpattern(solid) graphregion(color(white))) /// 
    (scatter englishgpapoint year2, c(1) msymbol(square) mcolor(gs6) lcolor(gs6) lpattern(dash) graphregion(color(white))) /// 
    (rcap mathgpaub  mathgpalb year1, lcolor(black)) ///
    (rcap englishgpaub  englishgpalb year2, lcolor(gs6)), ///
    legend(label(1 "Math GPA") label(3 "Math GPA CI") label(2 "English GPA") label(4 "English GPA CI")) ///
    ytitle(Coefficient on Morning) xtitle(Years After) 
graph export "output/figure1a.png", replace

twoway (scatter mathcstpoint year1, c(1) msymbol(circle) mcolor(black) lcolor(black) lpattern(solid) graphregion(color(white))) /// 
    (scatter englishcstpoint year2, c(1) msymbol(square) mcolor(gs6) lcolor(gs6) lpattern(dash) graphregion(color(white))) /// 
    (rcap mathcstub  mathcstlb year1, lcolor(black)) ///
    (rcap englishcstub  englishcstlb year2, lcolor(gs6)), ///
    legend(label(1 "Math CST Score") label(3 "Math CST CI") label(2 "English CST Score") label(4 "English CST CI")) ///
    ytitle(Coefficient on Morning) xtitle(Years After)
graph export "output/figure1b.png", replace


*****************************************
***** Figure 2: Each Period Effect ******
*****************************************
use figtemp.dta, clear

*** Create data set for the figure
file open figure2_table using "output/figure2_table.txt", write replace

file write figure2_table ///
	"mathgpapoint1" _tab "mathgpaperse1" _tab "mathgpapoint2" _tab "mathgpaperse2" _tab "mathgpapoint3" _tab "mathgpaperse3" _tab ///
	"mathgpapoint4" _tab "mathgpaperse4" _tab "mathgpapoint5" _tab "mathgpaperse5" _tab "mathgpapoint6" _tab "mathgpaperse6" _tab /// 
	"mathcstpoint1" _tab "mathcstperse1" _tab "mathcstpoint2" _tab "mathcstperse2" _tab "mathcstpoint3" _tab "mathcstperse3" _tab ///
	"mathcstpoint4" _tab "mathcstperse4" _tab "mathcstpoint5" _tab "mathcstperse5" _tab "mathcstpoint6" _tab "mathcstperse6" _tab /// 
	"englishgpapoint1" _tab "englishgpaperse1" _tab "englishgpapoint2" _tab "englishgpaperse2" _tab "englishgpapoint3" _tab "englishgpaperse3" _tab ///
	"englishgpapoint4" _tab "englishgpaperse4" _tab "englishgpapoint5" _tab "englishgpaperse5" _tab "englishgpapoint6" _tab "englishgpaperse6" _tab /// 
	"englishcstpoint1" _tab "englishcstperse1" _tab "englishcstpoint2" _tab "englishcstperse2" _tab "englishcstpoint3" _tab "englishcstperse3" _tab ///
	"englishcstpoint4" _tab "englishcstperse4" _tab "englishcstpoint5" _tab "englishcstperse5" _tab "englishcstpoint6" _tab "englishcstperse6" _n 

**** Math GPA
char periods[omit] 6
xi:areg gpaavg i.periods female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior zcstscoremathprior gpaavgprior i.year i.grade if department == "math", a(crstchs) cluster(classid)
file write figure2_table %9.6fc (_b[_Iperiods_1]) _tab %5.6fc (_se[_Iperiods_1]) _tab ///
	 %9.6fc (_b[_Iperiods_2]) _tab %5.6fc (_se[_Iperiods_2]) _tab %9.6fc (_b[_Iperiods_3]) _tab %5.6fc (_se[_Iperiods_3]) _tab ///
	  %9.6fc (_b[_Iperiods_4]) _tab %5.6fc (_se[_Iperiods_4]) _tab %9.6fc (_b[_Iperiods_5]) _tab %5.6fc (_se[_Iperiods_5]) _tab      

char periods[omit] 1
xi:areg gpaavg i.periods female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior zcstscoremathprior gpaavgprior i.year i.grade if department == "math", a(crstchs) cluster(classid)
file write figure2_table %9.6fc (0) _tab (_se[_Iperiods_6]) _tab

**** Math CST
char periods[omit] 6
xi:areg zcstscoremath i.periods female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior zcstscoremathprior gpaavgprior i.year i.grade if department == "math", a(crstchs) cluster(classid)
file write figure2_table %9.6fc (_b[_Iperiods_1]) _tab %5.6fc (_se[_Iperiods_1]) _tab ///
	 %9.6fc (_b[_Iperiods_2]) _tab %5.6fc (_se[_Iperiods_2]) _tab %9.6fc (_b[_Iperiods_3]) _tab %5.6fc (_se[_Iperiods_3]) _tab ///
	  %9.6fc (_b[_Iperiods_4]) _tab %5.6fc (_se[_Iperiods_4]) _tab %9.6fc (_b[_Iperiods_5]) _tab %5.6fc (_se[_Iperiods_5]) _tab      

char periods[omit] 1
xi:areg zcstscoremath i.periods female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior zcstscoremathprior gpaavgprior i.year i.grade if department == "math", a(crstchs) cluster(classid)
file write figure2_table %9.6fc (0) _tab (_se[_Iperiods_6]) _tab

**** Engilsh GPA	  
char periods[omit] 6
xi:areg gpaavg i.periods female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior zcstscoremathprior gpaavgprior i.year i.grade if department == "english", a(crstchs) cluster(classid)
file write figure2_table %9.6fc (_b[_Iperiods_1]) _tab %5.6fc (_se[_Iperiods_1]) _tab ///
	 %9.6fc (_b[_Iperiods_2]) _tab %5.6fc (_se[_Iperiods_2]) _tab %9.6fc (_b[_Iperiods_3]) _tab %5.6fc (_se[_Iperiods_3]) _tab ///
	  %9.6fc (_b[_Iperiods_4]) _tab %5.6fc (_se[_Iperiods_4]) _tab %9.6fc (_b[_Iperiods_5]) _tab %5.6fc (_se[_Iperiods_5]) _tab      

char periods[omit] 1
xi:areg gpaavg i.periods female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior zcstscoremathprior gpaavgprior i.year i.grade if department == "english", a(crstchs) cluster(classid)
file write figure2_table %9.6fc (0) _tab (_se[_Iperiods_6]) _tab

**** English CST	  
char periods[omit] 6
xi:areg zcstscoreela i.periods female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior zcstscoremathprior gpaavgprior i.year i.grade if department == "english", a(crstchs) cluster(classid)
file write figure2_table %9.6fc (_b[_Iperiods_1]) _tab %5.6fc (_se[_Iperiods_1]) _tab ///
	 %9.6fc (_b[_Iperiods_2]) _tab %5.6fc (_se[_Iperiods_2]) _tab %9.6fc (_b[_Iperiods_3]) _tab %5.6fc (_se[_Iperiods_3]) _tab ///
	  %9.6fc (_b[_Iperiods_4]) _tab %5.6fc (_se[_Iperiods_4]) _tab %9.6fc (_b[_Iperiods_5]) _tab %5.6fc (_se[_Iperiods_5]) _tab      

char periods[omit] 1
xi:areg zcstscoreela i.periods female lesshs hsgrad somecol colgrad gradschool ///
	ell zcstscoreelaprior zcstscoremathprior gpaavgprior i.year i.grade if department == "english", a(crstchs) cluster(classid)
file write figure2_table %9.6fc (0) _tab (_se[_Iperiods_6]) _n

file close figure2_table

insheet using "output/figure2_table.txt", clear
gen place = 1 
reshape long mathgpapoint mathgpaperse mathcstpoint mathcstperse englishgpapoint englishgpaperse ///
	englishcstpoint englishcstperse, i(place) j(period)

gen mathgpaub = mathgpapoint + 2*mathgpaperse
gen mathgpalb = mathgpapoint - 2*mathgpaperse
gen mathcstub = mathcstpoint + 2*mathcstperse
gen mathcstlb = mathcstpoint - 2*mathcstperse
gen englishgpaub = englishgpapoint + 2*englishgpaperse
gen englishgpalb = englishgpapoint - 2*englishgpaperse
gen englishcstub = englishcstpoint + 2*englishcstperse
gen englishcstlb = englishcstpoint - 2*englishcstperse

gen period1 = period - .05
gen period2 = period + .05 

twoway (scatter mathgpapoint period1, ylabel(-0.02(.02)0.08) c(1) msymbol(circle) mcolor(black) lcolor(black) lpattern(solid) graphregion(color(white))) /// 
    (scatter englishgpapoint period2, c(1) msymbol(square) mcolor(gs6) lcolor(gs6) lpattern(dash) graphregion(color(white))) /// 
    (rcap mathgpaub  mathgpalb period1, lcolor(black)) ///
    (rcap englishgpaub  englishgpalb period2, lcolor(gs6)), ///
    legend(label(1 "Math GPA") label(3 "Math GPA CI") label(2 "English GPA") label(4 "English GPA CI")) ///
    ytitle(Coefficient on Period Dummy) xtitle(Period)
graph export "output/figure2a.png", replace

twoway (scatter mathcstpoint period1, c(1) msymbol(circle) mcolor(black) lcolor(black) lpattern(solid) graphregion(color(white))) /// 
    (scatter englishcstpoint period2, c(1) msymbol(square) mcolor(gs6) lcolor(gs6) lpattern(dash) graphregion(color(white))) /// 
    (rcap mathcstub  mathcstlb period1, lcolor(black)) ///
    (rcap englishcstub  englishcstlb period2, lcolor(gs6)), ///
    legend(label(1 "Math CST Score") label(3 "Math CST CI") label(2 "English CST Score") label(4 "English CST CI")) ///
    ytitle(Coefficient on Period Dummy) xtitle(Period)
graph export "output/figure2b.png", replace



