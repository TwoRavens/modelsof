/*Selection in observables*/
/*Do not use age or schooling groups but raw data*/
clear
capture log close
set matsize 1000
set memory 2g
set more off
log using ageeducation.log, replace

use agegroup schoolgroup schoolyears edad FAC mujer binmigr using dataset, clear

gen include = 1 if edad > 15 & edad < 66

/*Age histograms*/
histogram edad [fweight=FAC] if binmigr==0 & mujer==0 & include==1, discrete fraction xlabel(20 25 30 35 40 45 50 55 60 65) title("Male Age Distribution (2000-2004)") xtitle("Age") ytitle("Frequency") legend(label(1 "Non-migrants")) plot(histogram edad [fweight=FAC] if binmigr==1 & mujer==0 & include==1, discrete fraction gap(50) bcolor(red) legend(label(2 "Migrants")))
graph save histagedetmale, replace
histogram edad [fweight=FAC] if binmigr==0 & mujer==1 & include==1, discrete fraction xlabel(20 25 30 35 40 45 50 55 60 65) title("Female Age Distribution (2000-2004)") xtitle("Age") ytitle("Frequency") legend(label(1 "Non-migrants")) plot(histogram edad [fweight=FAC] if binmigr==1 & mujer==1 & include==1, discrete fraction gap(50) bcolor(red) legend(label(2 "Migrants")))
graph save histagedetfemale, replace
histogram agegroup [fweight=FAC] if binmigr==0 & mujer==0 & include==1, discrete fraction xlabel(2(1)11) title("Male Age Distribution (2000-2004)") xtitle("Age") ytitle("Frequency") legend(label(1 "Non-migrants")) plot(histogram agegroup [fweight=FAC] if binmigr==1 & mujer==0 & include==1, discrete fraction gap(50) bcolor(red) legend(label(2 "Migrants")))
graph save histagemale, replace
histogram agegroup [fweight=FAC] if binmigr==0 & mujer==1 & include==1, discrete fraction xlabel(2(1)11) title("Female Age Distribution (2000-2004)") xtitle("Age") ytitle("Frequency") legend(label(1 "Non-migrants")) plot(histogram agegroup [fweight=FAC] if binmigr==1 & mujer==1 & include==1, discrete fraction gap(50) bcolor(red) legend(label(2 "Migrants")))
graph save histagefemale, replace

/*Schooling years histograms*/
histogram schoolyears [fweight=FAC] if binmigr==0 & mujer==0 & include==1, discrete fraction xlabel(0(1)23) title("Male Schooling Distribution (2000-2004)") xtitle("Schooling years") ytitle("Frequency") legend(label(1 "Non-migrants")) plot(histogram schoolyears [fweight=FAC] if binmigr==1 & mujer==0 & include==1, discrete fraction gap(50) bcolor(red) legend(label(2 "Migrants")))
graph save histschooldetmale, replace
histogram schoolyears [fweight=FAC] if binmigr==0 & mujer==1 & include==1, discrete fraction xlabel(0(1)23) title("Female Schooling Distribution (2000-2004)") xtitle("Schooling years") ytitle("Frequency") legend(label(1 "Non-migrants")) plot(histogram schoolyears [fweight=FAC] if binmigr==1 & mujer==1 & include==1, discrete fraction gap(50) bcolor(red) legend(label(2 "Migrants")))
graph save histschooldetfemale, replace
histogram schoolgroup [fweight=FAC] if binmigr==0 & mujer==0 & include==1, discrete fraction xlabel(1(1)6) title("Male Schooling Distribution (2000-2004)") xtitle("Schooling years") ytitle("Frequency") legend(label(1 "Non-migrants")) plot(histogram schoolgroup [fweight=FAC] if binmigr==1 & mujer==0 & include==1, discrete fraction gap(50) bcolor(red) legend(label(2 "Migrants")))
graph save histschoolmale, replace
histogram schoolgroup [fweight=FAC] if binmigr==0 & mujer==1 & include==1, discrete fraction xlabel(1(1)6) title("Female Schooling Distribution (2000-2004)") xtitle("Schooling years") ytitle("Frequency") legend(label(1 "Non-migrants")) plot(histogram schoolgroup [fweight=FAC] if binmigr==1 & mujer==1 & include==1, discrete fraction gap(50) bcolor(red) legend(label(2 "Migrants")))
graph save histschoolfemale, replace
