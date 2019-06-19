clear
set memory 300m

/* Important: you need to put the .dat and .do files in one folder/
   directory and then set the working folder to that folder. */

set more off

clear
infix ///
 byte    year          1-2 ///
 byte    statefip      3-4 ///
 int     metaread      5-8 ///
 int     cityd         9-12 ///
 long    citypop      13-17 ///
 int     perwt        18-21 ///
 int     age          22-24 ///
 byte    sex          25 ///
 long    bpld         26-30 ///
 byte    educ99       31-32 ///
 byte    empstatd     33-34 ///
 int     occ          35-37 ///
 int     occ1990      38-40 ///
 int     ind1990      41-43 ///
 byte    wkswork1     44-45 ///
 byte    uhrswork     46-47 ///
 long    incwage      48-53 ///
 byte    movedin      54 ///
 int     pwmetro      55-58 ///
 int     pwcity       59-62 ///
  using "C:\Users\kp\Documents\thesis_topic occdist\census\kp49_georgetown_edu_052.dat"

keep datanum serial pernum year educ99


label var year "Census year"
label var educ99 "Educational attainment, 1990"





label values perwt perwtlbl



label define educ99lbl 00 "Not applicable"
label define educ99lbl 01 "No school completed", add
label define educ99lbl 02 "Nursery school", add
label define educ99lbl 03 "Kindergarten", add
label define educ99lbl 04 "1st-4th grade", add
label define educ99lbl 05 "5th-8th grade", add
label define educ99lbl 06 "9th grade", add
label define educ99lbl 07 "10th grade", add
label define educ99lbl 08 "11th grade", add
label define educ99lbl 09 "12th grade, no diploma", add
label define educ99lbl 10 "High school graduate, or GED", add
label define educ99lbl 11 "Some college, no degree", add
label define educ99lbl 12 "Associate degree, occupational program", add
label define educ99lbl 13 "Associate degree, academic program", add
label define educ99lbl 14 "Bachelors degree", add
label define educ99lbl 15 "Masters degree", add
label define educ99lbl 16 "Professional degree", add
label define educ99lbl 17 "Doctorate degree", add
label values educ99 educ99lbl



save "C:\Users\kp\Documents\thesis_topic occdist\immigrants\census00_all_engedu.dta", replace", replace

