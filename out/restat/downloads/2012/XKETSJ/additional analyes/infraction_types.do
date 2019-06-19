***IDENTIFIES TYPES OF INFRACTIONS AND PROVIDES SUMMARY STATISTICS AND DATASET***

clear
set mem 4g
set more off

log using /home/s/simberman/lusd/charter1/dofiles/infraction_types.log, replace
use /home/s/simberman/lusd/charter1/infracs.dta


*THERE WAS A SUBSTANTIAL CHANGE IN CODING B/W 1996 & 1997, SO DROP PRIOR TO 1997
drop if year < 1997
sort id year
merge id year using /home/s/simberman/lusd/charter1/lusd_data_b.dta, keep(startup_unzoned convert_zoned) nokeep

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


gen charttype = 0
replace charttype = 1 if convert_zoned  == 1
replace charttype = 2 if startup_unzoned == 1

tab infr_simple charttype


*COLLAPSE SIMPLIFIED INFRACTIONS
gen infrac_unspecified = infr_simple == 0
gen infrac_substance = infr_simple == 1
gen infrac_crime_violent = infr_simple == 2
gen infrac_crime_nonviolent = infr_simple == 3
gen infrac_fighting = infr_simple == 4
gen infrac_truancy = infr_simple == 5
collapse (sum) infrac_* , by(id year)
merge id year using /home/s/simberman/lusd/charter1/lusd_data_b.dta
foreach var of varlist infrac_* {
  replace `var' = 0 if `var' == . & year >= 1997
  replace `var' = . if year < 1997
}

replace infrac_fighting = . if year < 2003
replace infrac_truancy = . if year < 2004

*DROP G&T MAGNET CHARTER
drop 

*RUN REGRESSIONS OF INFRACTIONS BY TYPE
  
  *TIME VARIANT VARIABLES USED IN REGRESSIONS
  local febase "freel redl othecon recent_immi migrant _I*"

xi i.year*i.grade i.grade*structural i.grade*nonstructural i.grade*outofdist
xtset id year
foreach var of varlist infrac_* {
  gen d`var' = d.`var'
}

***LEVELS***
foreach var of varlist infrac_substance infrac_crime_violent infrac_fighting {
  xtreg `var' convert_zoned startup_unzoned `febase', fe cluster(schoolid) nonest
}



***VA***
foreach var of varlist dinfrac_substance dinfrac_crime_violent dinfrac_fighting {
  xtreg `var' convert_zoned startup_unzoned `febase', fe cluster(schoolid) nonest
}



log close
