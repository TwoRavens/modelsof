set mem 300m

**Variables**

rename R0000100 id
rename R0001100 nonnative_eng
rename R0006500 hgc_mom
rename R0007900 hgc_dad
rename R0009400 origin
rename R0190310 faminc79
rename R0214700 race
rename R0214800 sex
rename R0410500 age81
rename R0416800 enrolled81
rename R0416900 grade81
rename R0419000 typecoll
rename R0419100 major
rename R0419200 ch_enrolled81
rename R0419400 ftptcol
rename R0419500 loans81
rename R0443500 work81
rename R0443600 hrswork81
rename R0443800 workft81
rename R0505500 timeuse_typical
rename R0614600 hgc81
rename R0620200 ACT_v
rename R0620100 ACT_m
rename R0620000 SAT_v
rename R0619900 SAT_m
rename R0619800 PSAT_v
rename R0619700 PSAT_m
rename R0618300 AFQT_rev
rename R0618200 AFQT
rename R0527300 dorm
rename R0530400 goal_work
rename R0443400 main_activity
rename R0492900 ed_benefits
rename R0493000 amount_ed_ben
rename R0494200 live_with_fam
rename R0505400 total_hours_at_sch
rename R0505700 typical_mins_perweek_at_school
rename R0508500 time_spent_travek_school_min
rename R0508600 miles_from_school
rename R0536800 workstudy
rename R0549900 workstudy_2nd_job
rename R0602810 region
rename R0613810 family_income81
rename R0614600 sampleweight81
rename R0619010 age_at_interviewdate
rename R0505600 usual_hrs_sch
rename R0505800 ch_hrs_sch_zero
rename R0506000 hrs_class
rename R0506100 min_class
rename R0506200 hrs_study
rename R0506300 min_study
rename R0506400 hrs_class_col
rename R0506500 min_class_col
rename R0506600 hrs_study_col
rename R0506700 min_study_col
rename R0506800 hrs_study_offcampus
rename R0506900 min_study_offcampus
rename R0507000 time_study_typ

* these variables are only available with the Geocode data
rename R0648114 state81
rename R0418600 samecol81
rename R0665700 samecol82
rename R0907100 samecol83
rename R1207300 samecol84
rename R1523071 fice1st84
rename R1523073 fice2nd84
rename R1523075 fice3rd84
rename R1606200 incol85
rename R1893071 fice1st85
rename R1893073 fice2nd85
rename R1893075 fice3rd85

****Data Cleaning***

gen keep=1
replace keep=0 if hrs_class_col<-3
replace keep=0 if ftpt==2
replace keep=0 if typecoll==1
replace keep=0 if hgc81==10
replace keep=0 if hgc81==11

replace keep=0 if grade81==18
replace keep=0 if grade81==19

**time use variables**

replace  min_class_col=  min_class_col/60
gen total_hrs_class =  hrs_class_col + min_class_col if hrs_class_col>-1 & keep==1

replace  min_study_col=  min_study_col/60
gen total_hrs_study_oncampus =hrs_study_col + min_study_col if hrs_study_col>-1

replace min_study_offcampus = min_study_offcampus/60
gen total_hrs_study_offcampus =hrs_study_offcampus+ min_study_offcampus if hrs_study_offcampus>-1 & keep==1

gen total_hrs_study = total_hrs_study_oncampus+ total_hrs_study_offcampus if total_hrs_study_oncampus>-1 & keep==1

gen total_hours= total_hrs_class+ total_hrs_study if total_hrs_class>-1 & keep==1

drop min_*

/*
gen hrs_study_Heri = 0 if total_hrs_study==0
replace hrs_study_Heri = .5 if total_hrs_study>0 & total_hrs_study<1
replace hrs_study_Heri = 1.5 if total_hrs_study>.99 & total_hrs_study<2.501
replace hrs_study_Heri = 4 if total_hrs_study>2.5 & total_hrs_study<5.501
replace hrs_study_Heri = 8 if total_hrs_study>5.5 & total_hrs_study<10.501
replace hrs_study_Heri = 13 if total_hrs_study>10.5 & total_hrs_study<15.501
replace hrs_study_Heri = 18 if total_hrs_study>15.5 & total_hrs_study<20
replace hrs_study_Heri = 24 if total_hrs_study>19.99
replace hrs_study_Heri=. if total_hrs_study==.

gen hrs_class_Heri = 0 if total_hrs_class==0
replace hrs_class_Heri = .5 if total_hrs_class>0 & total_hrs_class<1
replace hrs_class_Heri = 1.5 if total_hrs_class>.99 & total_hrs_class<2.501
replace hrs_class_Heri = 4 if total_hrs_class>2.5 & total_hrs_class<5.501
replace hrs_class_Heri = 8 if total_hrs_class>5.5 & total_hrs_class<10.501
replace hrs_class_Heri = 13 if total_hrs_class>10.5 & total_hrs_class<15.501
replace hrs_class_Heri = 18 if total_hrs_class>15.5 & total_hrs_class<20
replace hrs_class_Heri = 24 if total_hrs_class>19.99
replace hrs_class_Heri=. if total_hrs_class==.
*/

gen study16up = 1 if total_hrs_study>15.99 & total_hrs_study !=.
replace study16up=0 if study16up==.
gen study20up = 1 if total_hrs_study>19.99 & total_hrs_study !=.
replace study20up=0 if study20up==.

/*
*Generating a work variable that will take 1 if you reported working at least on hour in the last week
gen worked = 1 if main_activity==1
* all those that report their main activity as working
replace worked = 1 if work_check==1
*plus those that said they worked some hours last week
replace worked=0 if worked==.
replace hours_worked=0 if worked==0

gen workedls20 =1 if hours_worked>0 & hours_worked<20
replace workedls20=0 if workedls20==.
gen work2034 =1 if hours_worked>19 & hours_worked<35
replace work2034=0 if work2034==.
gen work35plus =1 if hours_worked>34
replace work35plus=0 if work35plus==.

**demographic variables**

gen female=1 if sex==2
replace female=0 if female==.

gen hispanic =1 if race==1
replace hispanic = 0 if hispanic==.
gen black =1 if race==2
replace black=0 if black==.

*** since the other datasets contain information on asian we turned to the ethnic origin variable to determine race
gen black2==(origin==1)
gen indian2==(origin==9)
gen asian2=0
replace asian2=1 if origin==2 */Chinese/*
replace asian2=1 if origin==4 */ Fillipino/*
replace asian2=1 if origin==8 */Hawaiian/*
replace asian2=1 if origin==10 */Asian Indian/*
replace asian2=1 if origin==13 */Japanese/*
replace asian2=1 if origin==14 */Korean/*
replace asian2=1 if origin==26 */Vietnamese/*
gen hispanic2=0
replace hispanic2=1 if origin>14 & origin<20
replace hispanic2=1 if origin==21 */Other Spanish/*
gen white2=0
replace white2=1 if origin==3
replace white2=1 if origin>4 & origin<8
replace white2=1 if origin==11
replace white2=1 if origin==12
replace white2=1 if origin>21 & origin<26
replace white2=1 if origin==27

gen momhsgrad =1 if hgc_mom==12
gen momscollege= 1 if hgc_mom>12 & hgc_mom<16
gen momcol= 1 if hgc_mom>15
replace momcol=0 if momcol==.
replace momscol=0 if momscol==.
replace momhs=0 if momhs==.

gen dadhsgrad =1 if hgc_dad==12
gen dadscollege= 1 if hgc_dad>12 & hgc_dad<16
gen dadcol= 1 if hgc_dad>15
replace dadcol=0 if dadcol==.
replace dadscol=0 if dadscol==.
replace dadhs=0 if dadhs==.
gen dadedmis= 1 if hgc_dad<0
replace dadedmis=0 if dadedmis==.

gen satm_mis=1 if SAT_m<0
replace satm_mis=0 if satm_mis==.
gen satv_mis=1 if SAT_v<0
replace satv_mis=0 if satv_mis==.

replace grade81=13 if grade81==95 & keep==1
gen fresh81 =1 if grade81==13
gen soph81=1 if grade81==14
gen junior81=1 if grade81==15
gen senior81=1 if grade81==16
replace fresh81=0 if fresh81==.
replace soph81=0 if soph81==.
replace junior81=0 if junior81==.
replace senior81=0 if senior81==.
replace senior81=1 if grade81==17

gen collegeloan=1 if college_loan==1
replace collegeloan=0 if collegeloan==.

gen logwage= ln(hourly_wage)

gen married=1 if marital_2002==1
replace married=0 if married==.

*** adding majors***

sort id

do "Effort and Ed\NLSY\NLSY_majors.do"

******college locations*******
*/the NLSY only asks students about the FICE code of the last three colleges they attended starting in 1984 I used this information in conjunction with their reported college attendance history to best match the students to the school they attended in 1981/*

gen ficecode= fice1st84 if fice2nd84==-4 & fice1st85==-4
replace ficecode=-4 if fice1st84==-4 
replace ficecode= -5 if fice1st84==-5 & fice1st85==-5  
replace ficecode=fice1st84 if fice1st84>0 & fice2nd84==-4
replace ficecode= fice1st85 if fice1st84==-5 & fice2nd85==-4
replace ficecode= fice1st84 if fice2nd84==-4 & fice1st85==-5
replace ficecode=fice1st84 if fice1st84==fice1st85 & fice2nd84==-4 & fice1st84>0
replace ficecode=fice1st84 if samecol82==1 & samecol83==1 & samecol84==1
replace ficecode=fice1st84 if samecol82==-5 & samecol83==1 & samecol84==1
replace ficecode=fice1st84 if samecol82==1 & samecol83==-5 & samecol84==1
replace ficecode=fice1st84 if samecol82==-5 & samecol83==-5 & samecol84==1
replace ficecode=fice2nd84 if fice2nd84>0 & fice3rd84==-4 & samecol84==0
replace ficecode=fice2nd84 if fice2nd84>0 & fice3rd84==-4 & samecol83==0
replace ficecode=fice2nd84 if fice2nd84>0 & fice3rd84==-4 & samecol82==0
replace ficecode=fice2nd84 if samecol82==0 & samecol83==1 & samecol84==1 & fice3rd84>0
replace ficecode=fice2nd84 if samecol82==1 & samecol83==0 & samecol84==1 & fice3rd84>0
replace ficecode=fice2nd84 if samecol82==1 & samecol83==1 & samecol84==0 & fice3rd84>0
replace ficecode=fice3rd84 if samecol82==0 & samecol83==0 & samecol84==1 & fice3rd84>0
replace ficecode=fice3rd84 if samecol82==0 & samecol83==1 & samecol84==0 & fice3rd84>0
replace ficecode=fice3rd84 if samecol82==1 & samecol83==0 & samecol84==0 & fice3rd84>0

*/There were students where we were unable assign them a FICE code to because they were missing from the sample when the question was asked, or they have a very complicated school history./*
  
drop fice1st* fice2nd* fice3rd* samecol*

***after getting the geocoded data**

sort fice
merge fice using fice_merge.dta

*/Note: We did some checking to see if these matches seem plausible. There areclearly some schools that are wrong (i.e. student attending two year collegewho we don't think attend two year colleges) but by and large the matches seem plausible. 
The variable state81 (which is an NLSY variable) can be used as a check/*

save NLSY_big3, replace
