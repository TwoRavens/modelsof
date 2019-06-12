* Date: February 8, 2019
* Description: Report descriptive statistics for police study

clear


import excel "...\1903 JOP\police1.xlsx", sheet("Sheet1") firstrow


* Demograpic variables

gen college2 = 0
replace college2 = 1 if educ==1 | educ==2
replace college2 = 2 if educ==3
replace college2 = 3 if educ==4 | educ==5
replace college2 = . if educ==.


* Table A12.  Descriptive characteristics

* Partisanship
* 1=Republican, 2=Democrat, 3=Independent, 4=Other

tab partyid county, column
tab partyid if county!="sacramento"


* Race/Ethnicity
* 1=White, 2=Black, 3=Latino, 4=Asian, 5=Other

tab race county, column
tab race if county!="sacramento"


* Education
* 1=High School Degree or Less, 2=Some College, 3=College Degree or More

tab college2 county, column
tab college2 if county!="sacramento"


* Work in Law Enforcement
* 1=Yes, 2=No

tab work4law county, column
tab work4law if county!="sacramento"


* Ideological rating
* 1=Extremely Liberal, 2=Liberal, 3=Slightly Liberal, 4=Moderate, 
* 5=Slightly Conservative, 6=Conservative, 7=Extremely Conservative

tab ideo_rating county, column
tab ideo_rating if county!="sacramento"

* End
