clear
set mem 700m
set more off	 

*MAKE INTO STATA DATASETS
foreach year in "1993-94" "1994-95" {
 clear
  odbc load, dialog(complete) dsn("ada_discip_b") table("`year'-ADA-ZIP") lowercase 
  keep year id zip_code sch* status per_attd gender eth f_lun dob t_*
  replace year = "`year'"
  rename per_attd perc_attn
  rename eth ethnicity
  rename f_lun lunch
  destring perc_attn t_*, replace
  compress
  sort id
  save ada-`year', replace
}


foreach year in "1995-96" "1996-97" "1997-98" "1998-99" "1999-00" "2000-01" "2001-02" "2002-03" "2003-04" "2004-05" {
  clear
  odbc load, dialog(complete) dsn("ada_discip_b") table("`year'-ADA-ZIP") lowercase
  if "`year'" == "2003-04" gen year = "2003-04" 
  keep year id zip_code enter_date leave_date sch* status perc_attn gender ethnicity lunch dob t_*
  replace year = "`year'"
  rename perc_attnd perc_attn
  destring perc_attn t_*, replace
  compress
  sort id
  save ada-`year', replace
}


foreach year in  "2005-06"  "2006-07" {
  clear
  odbc load, dialog(complete) dsn("ada_discip_b") table("`year'-ADA-ZIP") lowercase
  keep year id zip_code enter_date leave_date sch* status perc_attn gender ethnicity lunch dob katrina t_d*
  rename perc_attnd perc_attn
  replace year = "`year'"
  destring perc_attn t_*,  replace
  compress
  sort id
  save ada-`year', replace
}

foreach year in "1993-94" "1994-95" "1995-96" "1996-97" "1997-98" "1998-99" "1999-00" "2000-01" "2001-02" "2002-03" "2003-04" "2004-05" "2005-06" {
  append using ada-`year'
}

*CLEAN UP VARIABLES
replace year = substr(year,1,4)
destring year id zip_code sch* gender ethnicity lunch , replace

  *SOME PERC_ATTN IS MISSING... REPLACE WITH DAYS PRESENT DIVIDED BY DAYS ENROLLED
  count if perc_attn != . & t_days_t == .
  count if perc_attn == . & t_days_t != .
  replace perc_attn = 100*t_days_p/t_days_t
  sum perc_attn

  *ENTER DATES & LEAVE DATES ARE ODD FOR PRE 1995, SO SET THOSE TO MISSING
   replace enter_date = "" if year < 1995
   replace leave_date = "" if year < 1995

  *STATUS & ZIP CODE VARIABLES GENERATE DUPLICATES IN 1993 & 1994, SO DROP FOR THOSE YEARS
   replace status = "" if year < 1995
   replace zip_code = . if year < 1995

  *THERE ARE 4 OBS IN 2006 WITH SAME ID BUT DIFFERENT ENTRY DATES... WILL SET THESE ENTRY DATES TO MISSING
  duplicates drop
  duplicates tag id year, gen(dup)
  replace enter_date = "" if dup == 1
  duplicates drop

  *IN ADDITION FOR SOME OF THESE OBS THE ZIP CODE IS MISSING IN ONE AND NOT THE OTHER... DROP THE ONE WITH A MISSING ZIP CODE
  drop dup
  duplicates tag id year, gen(dup)
  drop if dup == 1 & zip == .
  
  *IN ONE ID FOR 2006 THERE ARE TWO ZIP CODES --> SET TO MISSING
  replace zip_code = . if id == 9001312142 & year == 2006
  drop dup
  duplicates drop
  duplicates tag id year, gen(dup)
  tab dup
  drop dup

  *KATRINA INDICATORS MISSING FOR 2006, SO PULL FROM 2005 DATA
  sort id year
  rename katrina katrina_code
  replace katrina_code = "" if katrina_code == " "
  replace status = "" if status == " "
  label variable katrina_code "location code for Katrina\Rita students"
  gen katrina = katrina_code != ""
  tsset (id) year
  replace katrina = l.katrina if year == 2006 & l.katrina != .
  label variable katrina "indicator for whether student was an evacuee due to Hurricanes Katrina or Rita"
  replace katrina = . if year < 2005

  *GENERATE HOW LONG KATRINA STUDENTS STAYED IN HISD THROUGH 2005
  gen katrina_timeinhisd = date(leave, "MD20Y") - date(enter, "MD20Y") if year == 2005 & katrina == 1
  replace katrina_timeinhisd = 9999 if katrina == 1 & year == 2005 & leave == "000000"
  label variable katrina_timeinhisd "number of days evacuees spend in HISD in 2005 --> 9999 - stayed until end of yr"

  *DROP ETHNICITY, GENDER, LUNCH, DOB --> USE DEMOGRAPHIC FILE
  drop ethnicity gender lunch dob
  sort id year

  *RENAME DAYS ENROLLED, PRESENT, ABSENT
  rename t_days_t days_enrolled
  rename t_days_p days_present
  rename t_days_a days_absent

save attend_zip_katrina.dta", replace

