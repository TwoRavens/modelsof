
#delimit;
clear; capture clear matrix;
set memory 3000m;
set matsize 2000;



use "$startdir/$outputdata\cohorts_prepped", clear;
gen black=0;
replace black=1 if race==2;

gen mygrade=0 if educ==0;
replace mygrade=3 if educ==1; *if you got nursery to grade 4, you get 3rd grade, unless i know more about you from higrade;
replace mygrade=1 if higrade==4;
replace mygrade=2 if higrade==5;
replace mygrade=4 if higrade==7;

replace mygrade=7 if educ==2; *if you got 5th to 8th, you get 7th grade, unless i know exact grade from higrade;
replace mygrade=5 if higrade==8;
replace mygrade=6 if higrade==9;
replace mygrade=8 if higrade==11;
replace mygrade=9 if educ==3;
replace mygrade=10 if educ==4;
replace mygrade=11 if educ==5;
replace mygrade=12 if educ==6;
replace mygrade=13 if educ==7;
replace mygrade=14 if educ==8;
replace mygrade=15 if educ==9;
replace mygrade=16 if educ==10;
replace mygrade=17 if educ==11;
gen hsgrad=0;
replace hsgrad=1 if educ>=6;
gen collegegrad=0;
replace collegegrad=1 if educ>=10; *checking against educ99, anyone who was recorded as having a bachelor's there got 4yrs of college in educ;
* a note on missings - after dropping people with missing loginc, there are 5000 people with 0 "N/A or none" for educ, and they seem to really have zero.  no one is missing;
/*
educlbl:
           0 N/A or no schooling
           1 Nursery school to grade 4
           2 Grade 5, 6, 7, or 8
           3 Grade 9
           4 Grade 10
           5 Grade 11
           6 Grade 12
           7 1 year of college
           8 2 years of college
           9 3 years of college
          10 4 years of college
          11 5+ years of college
higradelbl:
           0 N/A  (or None, 1980)
           1 None
           2 Nursery school
           3 Kindergarten
           4 1st grade
           5 2nd grade
           6 3rd grade
           7 4th grade
           8 5th grade
           9 6th grade
          10 7th grade
          11 8th grade
          12 9th grade
          13 10th grade
          14 11th grade
          15 12th grade
          16 1st year
          17 2nd year
          18 3rd year
          19 4th year
          20 5th year or more (40-50)
          21 6th year or more (60,70)
          22 7th year
          23 8th year or more

*/;

gen hhwtround=round(hhwt/20);
keep if loginc!=. | logwage!=. | logincfam!=.;
keep if hhwt!=0;
drop hhwt;
keep educ educd  hhwtround loginc hsgrad collegegrad mygrade C A fips year black;
compress;
expand hhwtround;



sort C A fips year;

collapse educ educd meanrawloginc=loginc hsgrad collegegrad mygrade black, by(C A fips year);

save "$startdir/$outputdata\stateincomeeducation", replace;








use "$startdir/$outputdata\cohorts_prepped", clear;
gen black=0;
replace black=1 if race==2;

gen mygrade=0 if educ==0;
replace mygrade=3 if educ==1; *if you got nursery to grade 4, you get 3rd grade, unless i know more about you from higrade;
replace mygrade=1 if higrade==4;
replace mygrade=2 if higrade==5;
replace mygrade=4 if higrade==7;

replace mygrade=7 if educ==2; *if you got 5th to 8th, you get 7th grade, unless i know exact grade from higrade;
replace mygrade=5 if higrade==8;
replace mygrade=6 if higrade==9;
replace mygrade=8 if higrade==11;
replace mygrade=9 if educ==3;
replace mygrade=10 if educ==4;
replace mygrade=11 if educ==5;
replace mygrade=12 if educ==6;
replace mygrade=13 if educ==7;
replace mygrade=14 if educ==8;
replace mygrade=15 if educ==9;
replace mygrade=16 if educ==10;
replace mygrade=17 if educ==11;
gen hsgrad=0;
replace hsgrad=1 if educ>=6;
gen collegegrad=0;
replace collegegrad=1 if educ>=10; *checking against educ99, anyone who was recorded as having a bachelor's there got 4yrs of college in educ;


gen hhwtround=round(hhwt/20);
keep if loginc!=. | logwage!=. | logincfam!=.;
keep if hhwt!=0;
drop hhwt;
keep educ educd  hhwtround loginc hsgrad collegegrad mygrade C A year black;
compress;
expand hhwtround;
sort C A year;
collapse educ educd meanrawloginc=loginc hsgrad collegegrad mygrade, by(C A year);

save "$startdir/$outputdata\natincomeeducation", replace;
