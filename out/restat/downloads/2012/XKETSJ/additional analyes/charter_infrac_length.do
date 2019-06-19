**STUDIES HOW DISCIPLINE TYPES & LENGTHS OF PUNISHMENTS VARY WITH CHARTER STATUS***

clear
set mem 6g
set more off
set matsize 2000

use /home/s/simberman/lusd/charter1/infracs.dta
sort id year
merge id year using /home/s/simberman/lusd/charter1/lusd_data_b, keep(convert_zoned startup_unzoned schoolid female ethnicity freelunch redlunch othecon migrant immigrant recent_immigrant grade) nokeep

*LIMIT TO AFTER LAST MAJOR CODING CHANGE
keep if year >= 1999

*IDENTIFY INFRACTION TYPE
gen type = 0

   *EXPULSION
   replace type = 1 if (dis_code >= 1 & dis_code <= 4) | (dis_code >= 50 & dis_code <= 53)

   *PLACEMENT IN DAEP W/O EXPULSION
   replace type = 2 if (dis_code == 7) | (dis_code == 54)

   *OUT OF SCHOOL SUSPENSION
   replace type = 3 if (dis_code == 5) | (dis_code == 25)

   *IN SCHOOL SUSPENSION
   replace type = 4 if (dis_code == 6) | (dis_code == 26)

   *CONTINUATION OF PREVIOUS ORDER, COURT PLACEMENT, OR TRUANCY
   replace type = 5 if (dis_code >= 8 & dis_code <=17) | (dis_code >= 55 & dis_code <= 61)

*DROP UNKNOWN INFRACTION TYPE (ONLY 12 OF THESE IN SAMPLE)
drop if type == 0

*DROP INFRACTIONS THAT ARE NOT IMPOSED BY SCHOOL
drop if type == 5

*DUE TO SMALL INCIDENCES, COMBINE SOME SIMILAR INFRACTIONS TOGETHER

*COMBINE MURDER (2 INCIDENCES) WITH AGGRAVATED ASSAULT AGAINST A NON-EMPLOYEE
replace infr_code = 30 if infr_code == 17

*COMBINE SEXUAL ASSUALT ON EMPLOYEE (1 INCIDENCE) WITH SEXUAL ASSAULT ON OTHER
replace infr_code = 32 if infr_code == 31

*COMBINE ALL TRUANCY
replace infr_code = 41 if infr_code >= 42 & infr_code <= 45

*COMBINE AGGRAVATED ROBBERY (4 INCIDENCES) AND ENGAGING IN DEADLY CONDUCT (8 INCIDENCES) WITH AGGRAVATED ASSAULT AGAINST A NON-EMPLOYEE
replace infr_code = 30 if infr_code == 46 | infr_code == 49


*SIMPLIFY CODING
  label define infractions 0 "Unspecified Violation" 1 "Substance Abuse (Excluding Cigarettes)" 2 "Violent Crime" 3 "Non-Violent Crime" 4 "Fighting" 5 "Truancy"
  gen infr_simple = 0

  *SUBSTANCE ABUSE
  foreach code of numlist 4 5 6 36 37 {
 	replace infr_simple = 1 if infr_code == `code'
  }

  *VIOLENT CRIMINAL BEHAVIOR - ASSAULT, MURDER, TERRORISTIC THREATS, GANG VIOLENCE, ARSON, WEAPONS POSSESSION, KIDNAPPING, SEXUAL ASSAULT, ROBBERY
  foreach code of numlist  3 11/17 19 26 27/32 34 46/50 {
 	replace infr_simple = 2 if infr_code == `code'
  }

  *NON-VIOLENT CRIMINAL BEHAVIOR - UNSPECIFIED CONDUCT PUNISHABLE AS A FELONY, INDECENT EXPOSURE, RETALIATION AGAINST EMPLOYEE, 
 	*INDECENCY WITH CHILD, CRIMINAL MISCHIEF, FALSE ALARM
   foreach code of numlist  2 7 8 10 11 18 22 35{
 	replace infr_simple = 3 if infr_code == `code'
  }

  *FIGHTING - 2002 & LATER ONLY
 foreach code of numlist  41 {
 	replace infr_simple = 4 if infr_code == `code'
  }


  *TRUANCY - 2003 & LATER ONLY
 foreach code of numlist  42/45 {
 	replace infr_simple = 5 if infr_code == `code'
  }

f

gsample 10, percent wor


*IDENTIFY HOW PUNISHMENTS VARY ACROSS SCHOOL TYPES
*xi i.grade*i.year i.ethnicity

*mlogit type startup_unzoned convert_zoned female freelunch redlunch othecon recent_immig immig migrant _I*, cluster(schoolid)

xi i.grade*i.year i.ethnicity i.infr_simple

mlogit type startup_unzoned convert_zoned female freelunch redlunch othecon recent_immig immig migrant _I*, cluster(schoolid)


