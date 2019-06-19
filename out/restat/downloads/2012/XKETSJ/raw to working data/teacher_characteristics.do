clear
set mem 400m
set more off


*PUT ALL TEACHER CHARACTERISTICS INTO ONE DATASET
cd Teachers
use teacher_1995
gen year = 1995
forvalues year = 1996/2006 {
  append using teacher_`year'
  replace year = `year' if year == .
}
destring, replace
drop academic_year

*COMBINE SCHOOL IDS INTO ONE VARIABLE

  *CAMPUS VARIABLE FOR 1995 INCOMPLETE... USE T_9596TEACHER_INFO_CAMPUS
  *APPROXIMATELY 600 TEACHERS HAVE CAMPUS & T_9596TEACHER_INFO_CAMPUS CONFLICTING --> USE T_9596TEACHER_INFO_CAMPUS ONLY
  replace campus =  t_9596teacher_info_campus if year == 1995
  drop t_9596teacher_info_campus

  *CAMPUS VARIABLE FOR 1996 INCOMPLETE... USE  t_96_87_teachers_demographics_ca
  *APPROXIMATELY 500 TEACHERS HAVE CAMPUS &  t_96_87_teachers_demographics_ca CONFLICTING --> USE  t_96_87_teachers_demographics_ca ONLY
  replace campus =  t_96_87_teachers_demographics_ca if year == 1996
  drop  t_96_87_teachers_demographics_ca

  replace campus = sch if year >= 2000
  drop sch

*COMBINE FIRST AND LAST NAMES INTO ONE VARIABLE
*LAST_NAME1 APPEARS MORE COMPLETE THAN LNAME FOR 1996, SO USE THAT
*NO OBSERVATIONS HAVE LAST_NAME BUT NOT LAST_NAME1 IN 1996 & SIMILAR FOR FIRST NAMES
  replace lname = last_name if year < 2000
  replace lname = last_name1 if year == 1996

  replace fname = first_name if year < 2000
  replace fname = first_name1 if year == 1996

  drop first_name last_name first_name1 last_name1
  rename lname teacher_lname
  rename fname teacher_fname

*DROP MIDDLE INITIALS SINCE DATA NOT AVAILABLE FOR SOME YEARS
  drop mi middle_initial mid middle

*COMBINE GENDER INTO ONE VARIABLE AND MAKE NUMERICAL
  replace gender = sex if year < 2000
  drop sex
  gen teacher_female = .
  replace teacher_female = 1 if gender == "F"
  replace teacher_female = 0 if gender == "M"
  drop gender

*COMBINE ETHNICITY INTO ONE VARIABLE
  replace  ethnic = ethnicity if year < 2000
  drop ethnicity
  rename ethnic teacher_ethnic

*COMBINE TEACHER EXPERIENCE INTO ONE VARIABLE
  egen teacher_exp = rsum(totalyearsprofexp  yrs_prof_exp  prof_yrs)
  drop totalyearsprofexp  yrs_prof_exp  prof_yrs

*COMBINE HIGHEST DEGREE INTO ONE VARIABLE
  egen teacher_degree = rsum(degree highestdegreeid)
  drop degree highestdegreeid

*COMBINE OLD TEACHER NUMBERS INTO ONE VARIABLE (THESE ARE SCHOOL SPECIFIC NUMBERS)
  egen teacher_oldid = rsum(tch_number tch_number0506 teacher_number0506)
  replace teacher_oldid = . if teacher_oldid == 0
  drop tch_number tch_number0506 teacher_number0506

*COMBINE NEW TEACHER NUMBERS INTO ONE VARIABLE(THESE ARE NEW SYSTEM-WIDE NUMBERS STARTING IN 2006)
  egen teacher_newid = rsum(tch_number0607 teacher_number0607)
  replace teacher_newid = . if teacher_newid == 0
  drop tch_number0607 teacher_number0607


aorder
order year campus teacher_oldid teacher_newid


*FILE IS CURRENTLY ONE RECORD PER YEAR-TEACHER-CERTIFICATION COMBINATION
*GET FILE INTO ONE RECORD PER YEAR-TEACHER

  *GENERATE AN INDICATOR FOR WHETHER A RECORD INCLUDES A CERTIFICATION FOR 1997 & LATER
  gen cert_temp = 0 if year > 1996
  replace cert_temp = 1 if certification != "" & year > 1996
  egen teacher_cert = max(cert_temp), by(year campus teacher_oldid teacher_newid)
  drop certification cert_temp

  *DROP OBSERVATIONS WITH NO TEACHER IDS OLD OR NEW
  drop if teacher_oldid == . & teacher_newid == .

  *DROP IF FROM CAMPUS #999 WHICH APPEARS TO BE NONE OR UNKNOWN
  drop if campus == 999

  *DROP TEACHERS MISSING OLD IDS FROM 2005 & EARLIER
  drop if teacher_oldid == . & year <= 2005

  *DROP 1995 SINCE FIRST NAMES ARE MISSING IN MOST CASES
  drop if year == 1995

  duplicates drop

  *CLEAN TEACHER NAMES
   
    *CUT OFF FIRST NAMES AT 13 CHARS, LAST NAMES AT 15 CHARS SO NAMES ARE CONSISTENT ACROSS YEARS
    replace teacher_fname = substr(teacher_fname,1,13)
    replace teacher_lname = substr(teacher_lname,1,15)

    *MAKE NAMES CONSISTENT BY REMOVING NON-LETTER CHARACTERS EXCEPT APOSTROPHE
    foreach name in "fname" "lname" {
      foreach char in "." "-" " " {
      replace teacher_`name' = subinstr(teacher_`name', "`char'", "", .)
      }
    }
    foreach name in "fname" "lname" {
      replace teacher_`name' = subinstr(teacher_`name', "0", "O", .)
    }
    replace teacher_lname = substr(teacher_lname, 1, strpos(teacher_lname, ",") - 1) if strpos(teacher_lname, ",") != 0
    duplicates drop

    *ONE TEACHER APPEARS TO HAVE DIFFERENT VALUES FOR DEMOGRAPHICS IN SAME YEAR --> DROP
    duplicates tag campus year teacher_oldid teacher_newid teacher_fname teacher_lname, gen(dup)
    drop if dup == 1
    drop dup

    *DROP IF TWO TEACHERS WERE ASSIGNED THE SAME ID WITHIN A YEAR
    duplicates tag campus year teacher_oldid teacher_newid, gen(dup)
    drop if dup > 0
    save temp.dta, replace

   *CREATE SIMPLE DATASET WITH TEACHER NAME, GENDER, ETHNICITY, EXPERIENCE, EDUCATION, CAMPUS YEAR
   keep year campus teacher_ethnic teacher_exp teacher_female teacher_fname teacher_lname teacher_cert teacher_degree
   duplicates drop
   save teacher_small, replace

   *GENERATE AVERAGES BY CAMPUS YEAR
   gen teacher_nopostHS = teacher_degree == 0
   gen teacher_bac = teacher_degree == 1
   gen teacher_graduate = teacher_degree == 2 | teacher_degree == 3

   collapse (mean) teacher_exp teacher_cert teacher_nopostHS teacher_bac teacher_graduate, by(campus year)
   save teacher_summary, replace

f
   *LINK TEACHERS ACCROSS YEARS

       *SINCE DIFFERENT TEACHERS MAY HAVE SAME NAME USE TWO MATCHING STRATEGIES

  		*STRATEGY 1 - MATCH TEACHERS ON FIRST NAME, LAST NAME, GENDER, ETHNICITY, AND EXPERIENCE - DROP OBS OF MULTIPLE TEACHERS 
		use temp.dta, clear

			*GENERATE UNIQUE NAME, GENDER, ETHNICITY IDS
			sort teacher_fname teacher_lname teacher_female teacher_ethnic year
			egen teacher_uniqueid = group(teacher_fname teacher_lname teacher_female teacher_ethnic)

			*IDENTIFY ID'S THAT APPEAR TO INCLUDE MULTIPLE TEACHERS (ID'S WITH 2 DIFFERENT EXPERIENCE OR EDUC LEVELS IN 1 YEAR)
			egen year_min_exp = min(teacher_exp), by(teacher_uniqueid year)
			egen year_max_exp = max(teacher_exp), by(teacher_uniqueid year)
			egen year_min_deg = min(teacher_deg), by(teacher_uniqueid year)
			egen year_max_deg = max(teacher_deg), by(teacher_uniqueid year)
			gen mult_teacher_year = year_min_exp != year_max_exp | year_min_deg != year_max_deg
			egen mult_teacher = max(mult_teacher_year), by(teacher_uniqueid)

			*DROP ALL OBS WITH ID BETWEEN MULTIPLE TEACHERS
			drop if mult_teacher == 1
			sort teacher_uniqueid year
			save temp2.dta, replace

			*NOTE THAT APPROXIMATELY 1.2% OF ID'S GENERATED HERE APPEAR TO INCLUDE MULTIPLE TEACHERS (3.3% OF OBSERVATIONS AT THIS POINT)

			*IN ORDER TO ADDRESS THE POSSIBILITY THAT A NEW TEACHER WITH THE SAME NAME WILL ENTER LATER, FIRST 
				*COLLAPSE DATASET BY TEACHER_UNIQUEID YEAR
			use temp2.dta, clear
			collapse (mean) teacher_ethnic teacher_degree teacher_exp teacher_female, by(teacher_uniqueid year teacher_fname teacher_lname)

			*IDENTIFY IF EXPERIENCE INCREASES BY MORE THAN ONE AFTER A YEAR OR DROPS (OR STAYS THE SAME)
			tsset (teacher_uniqueid) year			
			gen diffexp =  f.teacher_exp < teacher_exp
			egen anydiffexp = max(diffexp), by(teacher_uniqueid)

			*NOTE ALSO THAT I DO NOT ACCOUNT FOR THE POSSIBILITY THAT A TEACHER WITH THE SAME NAME WILL BE HIRED AFTER
				*THE ORIGINAL TEACHER HAD LEFT (THUS THEY WOULD NOT SHOW UP IN THE SAME YEAR AND WOULD NOT BE MARKED WITH A MULT_TEACHER
				*INDICATOR.  THIS SEEMS VERY UNLIKELY 







			*GENERATE AN INDICATOR FOR WHETHER A TEACHER HAS MULTIPLE IDS WITHIN A YEAR
			qui unique campus teacher_oldid teacher_newid, by(teacher_uniqueid year) gen(temp)
			egen teacher_multid = max(temp), by(teacher_uniqueid year)
			drop temp
			label teacher_multid "number of unique lusd provided ids a teacher has within a year"

			*9.7% OF TEACHER_UNIQUEIDS REMAINING ARE TEACHERS WITH MULTIPLE IDS IN A YEAR

			


			*WITHIN EACH ID-YEAR IF THERE ARE MULTIPLE EXPERIENCE VALUES THEN SEPARATE INTO MULTIPLE TEACHERS
			sort year teacher_uniqueid 
			by year teacher_uniqueid: egen exp_year_id = group(teacher_exp)
