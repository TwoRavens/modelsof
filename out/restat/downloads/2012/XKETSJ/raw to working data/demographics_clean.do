clear
set mem 900m
set more off
cd Demographics


*GET ALL DEMOGRAPHIC FILES INTO ONE DATASET
  use demog_1993
  gen year = 1993

  forvalues year = 1994/2006 {
      append using demog_`year'.dta
	replace year = `year' if year == .
  }
compress
destring, replace
drop schlname


*FIX VARIABLES THAT HAVE DIFFERNT NAMES ACROSS YEARS
replace campus = camp if campus == .
replace campus = campus_int if campus == .
drop campus_int camp

replace id = local_id if year >= 2005
drop local_id

replace ethnicity = ethnicit if ethnicity == .
replace ethnicity = ethnic if ethnicity == .
drop ethnicit ethnic

gen female = .
replace female = 1 if gender == "F" | sex == "F"
replace female = 0 if gender == "M" | sex == "M"
drop gender sex

replace immigrant = immigran if immigrant == .
replace immigrant = immig if immigrant == .
drop immigran immig

gen bilingual = .
replace bilingual = bilingua
replace bilingual = bil if bilingual == .
replace bilingual = biling if bilingual == .
drop bilingua bil biling

replace dob = dob6 if dob == .
replace dob = dob_6 if dob == .
drop dob6 dob_6

replace econdis = econ if econdis == .
replace econdis = econ_disadv if econdis == .
drop econ econ_disadv

replace gifted = gift_talent if gifted == .
drop gift_talent

replace speced = special_ed if speced == .
replace speced = sped if speced == .
drop special_ed sped

order id year campus grade
drop school_short_name

*MAKE GRADES NUMERIC
gen temp = grade
drop grade
gen grade = real(temp)
replace grade = 0 if temp == "KG"
replace grade = -1 if temp == "PK"
replace grade = -2 if temp == "EE"
tab grade, missing
drop temp
drop if grade == .


*IDENTIFY WHETHER "ECON" REFERS TO FREE LUNCH, REDUCED LUNCH, OR OTHER
gen byte freelunch = econ == 1 if econ != .
gen byte redlunch = econ == 2 if econ != .
gen byte othecon = econ == 99 if econ != .

*TITLE1 DATA APPEARS FAULTY --> NEED TO MATCH STUDENTS TO TITLE1 BY SCHOOL IF NECESSARY
drop title1

*DROP IF ESL = 1 OR BIL = 1 & LEP = 0 (2 OBS)
drop if esl == 1 & lep == 0
drop if bil == 1 & lep == 0


label	variable lep "limited English proficiency"
label variable atrisk "at-risk due to low achievement, overage, previous dropout, or personal probs"
label variable esl "enrolled in ESL (mutually exclusive with biling; must be LEP)"
label variable gifted "student is enrolled in a gifted & talented program"
label variable migrant "parent(s) are migrant workers"
label variable immigrant "student has immigrated to the US within 3 years"
label variable bilingual "enrolled in bilingual education (mutually exclusive with ESL; must be LEP)"
label variable grade "grade-level"
label variable freelunch "eligible for Federal free-lunch program"
label variable redlunch	"eligible for Federal reduced-price lunch"
label variable othecon "eligible for other anti-poverty progs but not free/red-price lunch"
label variable econdis "student is economically disadvantaged (freelunch, redlunch, or othecon = 1)"
label variable dob "date of birth"

*IDENTIFY IDS W/ INCONSISTENT TIME INVARIANT STATISITCS (2.4% of observations, 1.6% of id's)
*CREATE NEW VARIABLE WITH IMPUTED RACE & GENDER
gen byte  baddatid = 0
		
	*GENDER
	egen byte  minfem = min(female), by (id)
	egen byte  maxfem = max(female), by (id)
	gen byte flag_multgen = minfem != maxfem
	label variable flag_multgen "gender is not consistent across time periods for this id"
	drop minfem maxfem	

	*RACE
	egen maxrace = max(ethnicit), by (id)
	egen minrace = min(ethnicit), by (id)
	gen flag_multrace = maxrace != minrace
	drop  maxrace minrace
	label variable flag_multrace "race/ethnicity is not consitent across time periods for this id"

	*DOB
	egen maxdob = max(dob), by(id)
	egen mindob = min(dob), by(id)
	gen flag_dob = maxdob != mindob
	drop maxdob mindob
	label variable flag_dob "date of birth is not consistent across time periods for this id"

		*SINCE THE MOST RECENT DOB IS LIKELY MOST ACCURATE, USE THAT ONE
		gen dob_2 = dob
		tsset (id) year
		forvalues t= 1/15 {
			replace dob_2 = f.dob_2 if f.dob_2 != . & year >= 1996
		}
		label variable dob_2 "date of birth adjusted for multiple values - use most recent"

	*THE IMMIGRATION VARIABLE IS SUPPOSED TO REFLECT RECENT IMMIGRATION (WITHIN 3 YEARS) BUT IT APPEARS TO SHOW UP AS 0 FOR SOME YEARS
	*AND THEN 1 FOR OTHERS LATER ON... THIS MAY BE STUDENTS LEAVING FOR ANOTHER COUNTRY THEN RETURNING
	*PERHAPS SOME ARE ILLEGALS WHO DON'T WANT TO REPORT THAT THEY'RE IMMIGRANTS
	*BETTER TO USE AN INDICATOR FOR WHETHER STUDENT WAS EVER REPORTED TO BE AN IMMIGRANT
	rename immigrant recent_immigrant
 	label variable recent_immigrant "student was an immigrant within past 3 years... this data seems suspect"
	egen immigrant = max(recent_immigrant), by(id)
	label variable immigrant "student recent immig at some time in the data - calc from recent_immig"

	*IF MULTIPLE RACE OR MULTIPLE GENDERS LISTED FOR 1 ID, USE THE ONE THAT OCCURS MOST OFTEN
	*IF TIED THEN USE MOST RECENT ONE IN A NEW VARIABLE
	
	*ETHNICITY
	gen ethnic_1 = ethnicity == 1 if ethnicity != .
	gen ethnic_2 = ethnicity == 2 if ethnicity != .
	gen ethnic_3 = ethnicity == 3 if ethnicity != .
	gen ethnic_4 = ethnicity == 4 if ethnicity != .
	gen ethnic_5 = ethnicity == 5 if ethnicity != .
	

	forvalues ethnic = 1/5 {
		egen ethnic_`ethnic'_tot = sum(ethnic_`ethnic'), by(id)
	}

	egen temp1 =  rowmax(ethnic_1_tot ethnic_2_tot  ethnic_3_tot  ethnic_4_tot  ethnic_5_tot )
	gen temp2 = 0
	forvalues k = 1/5 {
		replace temp2 = temp2 + 1 if  ethnic_`k'_tot  == temp1
	}


		*FIX OBS WHERE ONE ETHNICITY OCCURS MORE OFTEN
		gen ethnicity_2 = ethnicity
		label variable ethnicity_2 "ethinicity adjusted to correct for multiple ethnicities in 1 ID"
		forvalues k = 1/5 {
			replace ethnicity_2 = `k' if ethnic_`k'_tot == temp1 & temp2 == 1
		}
				
		*FIX OBS WHERE MULTIPLE ETHNICITYS OCCUR THE SAME AMOUNT OF TIMES BY TAKING MOST RECENT
		*NOTE THAT TWO OBSERVATIOSN 3 ETHNICITIES PROVIDED OVER 3 YEARS BUT ARE FIXED BY THIS PROCEDURE
		tsset (id) year
		forvalues k = 1/12 {
			replace ethnicity_2 = f.ethnicity_2 if f.ethnicity_2 != .
		}
		drop temp1 temp2 ethnic_*	


	*GENDER
	gen gender_0 = female == 0
	gen gender_1 = female == 1

	forvalues gender = 0/1 {
		egen gender_`gender'_tot = sum(gender_`gender'), by(id)
	}

	egen temp1 =  rowmax(gender_0_tot gender_1_tot)
	gen temp2 = 0
	forvalues k = 0/1 {
		replace temp2 = temp2 + 1 if  gender_`k'_tot  == temp1
	}

		*FIX OBS WHERE ONE GENDER OCCURS MORE OFTEN
		gen female_2 = female
		label variable female_2 "gender adjusted to correct for multiple genders in 1 ID"
		forvalues k = 0/1 {
			replace female_2 = `k' if gender_`k'_tot == temp1 & temp2 == 1
		}
				
		*FIX OBS WHERE MULTIPLE ETHNICITYS OCCUR THE SAME AMOUNT OF TIMES BY TAKING MOST RECENT
		*NOTE THAT TWO OBSERVATIOSN 3 ETHNICITIES PROVIDED OVER 3 YEARS BUT ARE FIXED BY THIS PROCEDURE
		tsset (id) year
		forvalues k = 1/15 {
			replace female_2 = f.female_2 if f.female_2 != .
		}
		drop temp1 temp2 gender_*	



	*SAVE 
	sort id year
	compress
	label data "demographics with individuals with muiltple races or genders kept but identified"
	save demog_new.dta, replace