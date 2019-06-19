*THIS FILE RUNS ANALYSES OF DIFFERENCES BETWEEN CHARTER & NON-CHARTER ATTRITERS

clear
set mem 4g
set more off

use /home/s/simberman/lusd/charter1/infracs.dta


*THERE WAS A SUBSTANTIAL CHANGE IN CODING B/W 1996 & 1997, SO DROP PRIOR TO 1997
drop if year < 1997
sort id year
merge id year using /home/s/simberman/lusd/charter1/lusd_data_b.dta, keep(startup_unzoned convert_zoned ever_magnet_chart) nokeep

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


drop if ever_magnet_chart == 1


*MERGE IN SCHOOL CHARACTERISTICS
sort campus year
drop _merge
merge campus year using /home/s/simberman/lusd/charter1/lusd_resources.dta, keep(exp_func_pupil* enroll ) nokeep
replace exp_func_pupil_instr_instrld = exp_func_pupil_instr + exp_func_pupil_instrlead if exp_func_pupil_instr_instrld == .
replace exp_func_pupil_other = exp_func_pupil_totoper - exp_func_pupil_schlead - exp_func_pupil_instr_instrld


*GENERATE SUMMARY STATISTICS FOR CHARTER & NON-CHARTER STUDENTS

   # delimit ;
   postfile charter1_sumstats int (indicator) str40 (variable grouping statname) float (statistic) 
	using /home/s/simberman/lusd/postfiles/charter1_sumstats.dta, replace;
   

*IDENTIFY ETHNICITIES;
gen other = ethnicity == 1 | ethnicity == 2;
gen black = ethnicity == 3;
gen hisp = ethnicity == 4;
gen white = ethnicity == 5;

   *NONCHARTER;
   foreach var of varlist female white black hisp other grade year freelunch redlunch othecon lep atrisk speced exp_func_pupil_instr_instrld 
	exp_func_pupil_schlead exp_func_pupil_other enroll
        gifted immigrant stanford_math_sd stanford_read_sd stanford_lang_sd  infractions infrac_substance infrac_crime_violent infrac_fighting perc_attn {;
	sum `var' if charter  == 0;
	post charter1_sumstats (0) ("`var'") ("nonchart") ("mean") (r(mean));
        post charter1_sumstats (0) ("`var'") ("nonchart") ("sd") (r(sd));
	post charter1_sumstats (0) ("`var'") ("") ("") (.);
   };

   *STARTUP;
   foreach var of varlist  female white black hisp other grade year freelunch redlunch othecon lep atrisk speced exp_func_pupil_instr_instrld 
	exp_func_pupil_schlead exp_func_pupil_other enroll
        gifted immigrant stanford_math_sd stanford_read_sd stanford_lang_sd  infractions infrac_substance infrac_crime_violent infrac_fighting perc_attn {;
	sum `var' if startup_unzoned  == 1;
	post charter1_sumstats (1) ("`var'") ("startup_unzoned") ("mean") (r(mean));
	post charter1_sumstats (1) ("`var'") ("startup_unzoned") ("sd") (r(sd));
	reg `var' startup_unzoned convert_zoned, cluster(schoolid);
	post charter1_sumstats (1) ("`var'") ("startup_unzoned") ("t-stat") (_b[startup_unzoned]/_se[startup_unzoned]);

   };

   *CONVERT;
   foreach var of varlist  female white black hisp other grade year freelunch redlunch othecon lep atrisk speced exp_func_pupil_instr_instrld 
	exp_func_pupil_schlead exp_func_pupil_other enroll
        gifted immigrant stanford_math_sd stanford_read_sd stanford_lang_sd  infractions infrac_substance infrac_crime_violent infrac_fighting perc_attn{;
	sum `var' if convert_zoned  == 1;
	post charter1_sumstats (2) ("`var'") ("convert_zoned") ("mean") (r(mean));
	post charter1_sumstats (2) ("`var'") ("convert_zoned") ("sd") (r(sd));
	reg `var' startup_unzoned convert_zoned, cluster(schoolid);
	post charter1_sumstats (2) ("`var'") ("convert_zoned") ("t-stat") (_b[convert_zoned]/_se[convert_zoned]);
  };



      
# delimit cr
postclose charter1_sumstats
use /home/s/simberman/lusd/postfiles/charter1_sumstats.dta, clear 
outsheet using /home/s/simberman/lusd/postfiles/charter1_sumstats.dat, replace

log close

