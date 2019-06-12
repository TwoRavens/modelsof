
cd "C:\Dropbox\Kenya ICC\Infotrak Data\Politrak Data\"

local files "Jan2011 Aug2011 Feb2012 Jul2011 Jun2011 Jun2012 Mar2012 May2012 Oct2011 Oct2012 Dec2010"
*local files "Jan2011 Mar2011 Aug2011 Feb2012 Jul2011 Jun2011 Jun2012 Mar2012 May2012 Oct2011 Oct2012"
foreach file of local files {
	use `file'.dta, clear
	gen date = "`file'"
	label drop _all
	saveold `file'_alt.dta, replace
	}
*

local test: dir "" files "*_alt.dta"
local j = 1
foreach f of local test {
	di "`f'"
	use `f', clear
	*
	if `j'==1 {
		saveold kenya_data_date.dta , replace
		}
	*
	if `j'>1 {
		di "`f'"
		append using kenya_data_date.dta 
		saveold kenya_data_date.dta , replace
		}
	*
	local j = `j'+1
}
*

saveold politrak_raw, replace

*****************************************************************************************
cd "C:\Dropbox\Kenya ICC\Infotrak Data\Politrak Data\"

use politrak_raw, clear
order date
sort date
gen year = substr(date, 4, 4)
destring year, replace
gen month = substr(date, 1, 3)
replace month = "8" if month=="Aug"
replace month = "2" if month=="Feb"
replace month = "1" if month=="Jan"
replace month = "7" if month=="Jul"
replace month = "6" if month=="Jun"
replace month = "3" if month=="Mar"
replace month = "5" if month=="May"
replace month = "10" if month=="Oct"
replace month = "12" if month=="Dec"
destring month, replace
order date month year
sort year month

* Region variable, standardized to the first surveys mentioned in David's email, using the labels in the email
gen region_full = region if date=="Jun2011" | date=="Jul2011" | date=="Oct2011"

foreach v in Jan2011 Aug2011 Feb2012 Dec2010 {
	replace region_full = province if date=="`v'"
	}
*
* Manually matching the Mar2011 region to David's email
replace region_full=5 if province==2 & date=="Mar2011"
replace region_full=2 if province==3 & date=="Mar2011"
replace region_full=3 if province==5 & date=="Mar2011"
replace region_full=8 if province==6 & date=="Mar2011"
replace region_full=6 if province==7 & date=="Mar2011"
replace region_full=7 if province==8 & date=="Mar2011"
* Manually matching the Jun2012 region to David's email
replace region_full=2 if region==1 & date=="Jun2012"
replace region_full=3 if region==2 & date=="Jun2012"
replace region_full=4 if region==3 & date=="Jun2012"
replace region_full=5 if region==4 & date=="Jun2012"
replace region_full=6 if region==5 & date=="Jun2012"
replace region_full=7 if region==6 & date=="Jun2012"
replace region_full=8 if region==7 & date=="Jun2012"
replace region_full=1 if region==8 & date=="Jun2012"
* Manually matching the Oct2012 region to David's email
replace region_full=2 if region==1 & date=="Oct2012"
replace region_full=3 if region==2 & date=="Oct2012"
replace region_full=4 if region==3 & date=="Oct2012"
replace region_full=5 if region==4 & date=="Oct2012"
replace region_full=6 if region==5 & date=="Oct2012"
replace region_full=8 if region==6 & date=="Oct2012"
replace region_full=1 if region==8 & date=="Oct2012"

* Region identifiers, set to the first set of David's email
label define reg 1 "Nairobi" 2 "Coast" 3 "N. Eastern" 4 "Eastern" 5 "Central" 6 "R. Valley" 7 "Western" 8 "Nyanza"
label values region_full reg
quietly tab region_full, gen(reg_)

drop region
rename region_full region
gen region_text="."
replace region_text="Nairobi" if region==1
replace region_text="Coast" if region==2
replace region_text="NEastern" if region==3
replace region_text="Eastern" if region==4
replace region_text="Central" if region==5
replace region_text="RiftValley" if region==6
replace region_text="Western" if region==7
replace region_text="Nyanza" if region==8

drop if region==.
	* Note this drops all the March and May 2012 data.  David's email says the May12 data is bad.  And I can't yet verify the Mar12 region labels



***
* Presidential Choice
***
	* These are the codings I'll use.  I'm going to make each of the datasets conform to this coding.
* 1: Odinga
* 2: Ruto
* 3: Kenyatta
* 4: Other
* 5: Undecided
gen pres = .
gen vpres = .

label define presidents 1 "Odinga" 2 "Ruto" 3 "Kenyatta" 4 "Other" 5 "Undecided"
label values pres presidents

*local presvar "Q18_PREZY president Q9 Q23_PRESIDENT Q57_Presidential_Candidate Q46_PRESIDENT P11 Q13_PRESIDENTIAL_CANDIDATE Q29_PRESIDENT Q22 Q17"
*foreach v of local presvar {
*	tab date if `v'!=.
*	tab `v', mi
*	tab `v', nolabel
*	}
*

*** Jan2011				[double checked 7-22-13]
* Possibly an undecided category? 88
replace pres = 1 if Q18_PREZY==4
replace pres = 2 if Q18_PREZY==5
replace pres = 3 if Q18_PREZY==7
replace pres = 4 if Q18_PREZY!=4 & Q18_PREZY!=5 & Q18_PREZY!=7 & Q18_PREZY!=. 
drop Q18_PREZY
*** Jun2011				[double checked 7-22-13]
* No undecided category
replace pres = 1 if president==4 & date=="Jun2011"
replace pres = 2 if president==5 & date=="Jun2011"
replace pres = 3 if president==7 & date=="Jun2011"
replace pres = 4 if president!=4 & president!=5 & president!=7 & president!=. & date=="Jun2011"
drop president
*** Jul2011				[double checked 7-22-13]
* Possibly an undecided category? 22
replace pres = 1 if Q9==4 & date=="Jul2011"
replace pres = 2 if Q9==5 & date=="Jul2011"
replace pres = 3 if Q9==7 & date=="Jul2011"
replace pres = 4 if Q9!=4 & Q9!=5 & Q9!=7 & Q9!=. & date=="Jul2011"
drop Q9
*** Aug2011				[double checked 7-22-13]
* No undecided category
replace pres = 1 if Q23_PRESIDENT==4 & date=="Aug2011"
replace pres = 2 if Q23_PRESIDENT==5 & date=="Aug2011"
replace pres = 3 if Q23_PRESIDENT==7 & date=="Aug2011"
replace pres = 4 if Q23_PRESIDENT!=4 & Q23_PRESIDENT!=5 & Q23_PRESIDENT!=7 & Q23_PRESIDENT!=. & date=="Aug2011"
drop Q23_PRESIDENT
*** Oct2011
* No undecided category				[double checked 7-22-13]
replace pres = 1 if Q57_Presidential_Candidate==4 & date=="Oct2011"
replace pres = 2 if Q57_Presidential_Candidate==5 & date=="Oct2011"
replace pres = 3 if Q57_Presidential_Candidate==7 & date=="Oct2011"
replace pres = 4 if Q57_Presidential_Candidate!=4 & Q57_Presidential_Candidate!=5 & Q57_Presidential_Candidate!=7 & Q57_Presidential_Candidate!=.  & date=="Oct2011"
drop Q57_Presidential_Candidate
*** Feb2012				[double checked 7-22-13]
* Yes undecided, 94
replace pres = 1 if Q46_PRESIDENT==4 & date=="Feb2012"
replace pres = 2 if Q46_PRESIDENT==5 & date=="Feb2012"
replace pres = 3 if Q46_PRESIDENT==7 & date=="Feb2012"
replace pres = 4 if Q46_PRESIDENT!=4 & Q46_PRESIDENT!=5 & Q46_PRESIDENT!=7 & Q46_PRESIDENT!=. & Q46_PRESIDENT!=94 & date=="Feb2012"
replace pres = 5 if Q46_PRESIDENT==94 & date=="Feb2012"
drop Q46_PRESIDENT
*** Mar2012				[CANT VERIFY REGION]
* Yes undecided
*replace pres = 1 if P11==2
*replace pres = 2 if P11==4
*replace pres = 3 if P11==3
*replace pres = 4 if P11!=2 & P11!=3 & P11!=4 & P11!=. & P11!=15
*replace pres = 5 if P11==15
drop P11
*** May2012				[BAD DATA]
* Yes undecided
*replace pres = 1 if Q13_PRESIDENTIAL_CANDIDATE==2
*replace pres = 2 if Q13_PRESIDENTIAL_CANDIDATE==4
*replace pres = 3 if Q13_PRESIDENTIAL_CANDIDATE==3
*replace pres = 4 if Q13_PRESIDENTIAL_CANDIDATE!=2 & Q13_PRESIDENTIAL_CANDIDATE!=3 & Q13_PRESIDENTIAL_CANDIDATE!=4 & Q13_PRESIDENTIAL_CANDIDATE!=. & Q13_PRESIDENTIAL_CANDIDATE!=15
*replace pres = 5 if Q13_PRESIDENTIAL_CANDIDATE==15
drop Q13_PRESIDENTIAL_CANDIDATE
*** Jun2012				[double checked 7-22-13]
* Doesn't have an undecided
replace pres = 1 if Q29_PRESIDENT==4 & date=="Jun2012"
replace pres = 2 if Q29_PRESIDENT==5 & date=="Jun2012"
replace pres = 3 if Q29_PRESIDENT==7 & date=="Jun2012"
replace pres = 4 if Q29_PRESIDENT!=4 & Q29_PRESIDENT!=5 & Q29_PRESIDENT!=7 & Q29_PRESIDENT!=. & date=="Jun2012"
drop Q29_PRESIDENT
*** Oct2012				[double checked 7-22-13]
* Yes undecided
replace pres = 1 if Q22==2 & date=="Oct2012"
replace pres = 2 if Q22==4 & date=="Oct2012"
replace pres = 3 if Q22==3 & date=="Oct2012"
replace pres = 4 if Q22!=2 & Q22!=3 & Q22!=4 & Q22!=. & Q22!=17 & date=="Oct2012"
replace pres = 5 if Q22==17 & date=="Oct2012"
drop Q22
*** Dec2010				[double checked 7-22-13]
* Yes undecided
replace pres = 1 if Q17==4 & date=="Dec2010"
replace pres = 2 if Q17==5 & date=="Dec2010"
replace pres = 3 if Q17==7 & date=="Dec2010"
replace pres = 4 if Q17!=4 & Q17!=5 & Q17!=7 & Q17!=. & Q17!=99 & date=="Dec2010"
replace pres = 5 if Q17==9 & date=="Dec2010"
drop Q17

* President variables and labels
gen kenyatta = .
replace kenyatta=1 if pres==3
replace kenyatta=0 if pres!=3 & pres!=.
gen odinga = .
replace odinga=1 if pres==1
replace odinga=0 if pres!=1 & pres!=.
gen ruto = .
replace ruto=1 if pres==2
replace ruto=0 if pres!=2 & pres!=.



***
* Standardizing the Controls
***
* Need to standardize the control variables
*local controls "gender age location education marital religion sec employment tribe"
*order year month region_full county constituency `controls' region province

* Gender
gen male = .
replace male=1 if gender==1 | gendes==1
replace male=0 if gender==2 | gendes==2

* Age
* age is in brackets, 1-8, some missing.  Brackets in original age var labels
gen agebracket = age

* Urban/Rural
gen urban = .
replace urban = 1 if location==1
replace urban = 0 if location==2

* Education
recode education (6=0)
	* education = 0 is "None"
	* educ is education brackets, 0-5, some missing.  Brackets in original education var labels
gen educ=education

* Married
gen married=.
replace married = 1 if marital==2
replace married = 0 if marital==1 | marital==3 | marital==4 | marital==5
replace married = 1 if MARITAL_STATUS==2
replace married = 0 if MARITAL_STATUS==1 | MARITAL_STATUS==3 | MARITAL_STATUS==4 | MARITAL_STATUS==5

* Religion
* I'm not sure what the main important religious divides are in Kenya... They have data on Cath, Prot, Mus, Hin, Other
	* So dummy variables for each
gen catholic = .
replace catholic = 1 if religion==1
replace catholic = 0 if religion!=1 & religion!=.
gen protestant = .
replace protestant = 1 if religion==2
replace protestant = 0 if religion!=2 & religion!=.
gen muslim = .
replace muslim = 1 if religion==3
replace muslim = 0 if religion!=3 & religion!=.
gen hindu = .
replace hindu = 1 if religion==4
replace hindu = 0 if religion!=4 & religion!=.
gen otherrel = .
replace otherrel = 1 if religion==5
replace otherrel = 0 if religion!=5 & religion!=.
gen missrel = .
replace missrel = 1 if religion==.
replace missrel = 0 if religion!=.
local relvar "catholic protestant muslim hindu otherrel"

*** sec?

* Employment
gen working = .
replace working = 1 if employment>=1 & employment<=4
replace working = 0 if employment==5 | employment==6

* Tribe
* Kenyatta is Kikuyu
gen kikuyu = .
replace kikuyu = 1 if tribe==1
replace kikuyu = 0 if tribe!=1 & tribe!=.
* Odinga is Luo
gen luo = .
replace luo = 1 if tribe==4
replace luo = 0 if tribe!=4 & tribe!=.
* Ruto is Kalenjin
gen kalenjin = .
replace kalenjin = 1 if tribe==3
replace kalenjin = 0 if tribe!=3 & tribe!=.



* Dropping old variables
drop  Q24_RUNNING_MATE Weight_R CMDDICT_ID EDUCATION_LEVEL MARITAL_STATUS Q57_Running_Mate district Q57_Running_Mate province LEVEL_OF_EDUCATION Q11 Q13_RUNMATE POLITRAKDICT_ID P12 WEIGHT_GENDER COUNTYDICT_ID Q27 Q28_1 Q28_2
drop EMPLOYMENT_STATUS Q28_3 Q29_RUNNINGMATE Q29_REASON_1 Q29_REASON_2 Q29_REASON_3 Q30 Weight_G RUNNING_MATE Q9_RUNNING_MATE Q18_RUNNING OMNIBUSICCDICT_ID Q46_RUNNIN_MATE Weight_Region Weight AUGUSTDICT_ID counstituency Q23_VP weight
drop gender age location  education marital employment

sort year month
bysort date: egen kenyatta_perc = mean(kenyatta)
bysort date: egen ruto_perc = mean(ruto)
bysort date: egen odinga_perc = mean(odinga)

bysort date region: egen kenyatta_reg_perc = mean(kenyatta)
bysort date region: egen ruto_reg_perc = mean(ruto)
bysort date region: egen odinga_reg_perc = mean(odinga)

gen monthnum = (year-2010)*12+month
sort monthnum





* Pre- Post- Indictments Dummy
gen pre_ICC1 = 0
replace pre_ICC1=1 if date=="Dec2010" | date=="Jan2011"
* Pre- Post- Confirmation Dummy
gen pre_ICC2 = 0
replace pre_ICC2=1 if date!="Feb2012" & date!="Jun2012" & date!="Mar2012" & date!="May2012" & date!="Oct2012"
* ICC Period Dummies
gen ICCperiod=.
replace ICCperiod=1 if pre_ICC1==1
replace ICCperiod=2 if pre_ICC1==0 & pre_ICC2==1
replace ICCperiod=3 if pre_ICC1==0 & pre_ICC2==0
quietly tab ICCperiod, gen(ICCphase_)

* Fixing inconsistent age coding
rename agebracket age
bysort date: egen maxage=max(age)
* January 2011 claims to have no one in 51+
replace maxage = 8 if maxage==7

gen age5pt = .
replace age5pt = age if maxage==5
replace age5pt = 1 if maxage==8 & age==1
replace age5pt = 1 if maxage==8 & age==2
replace age5pt = 2 if maxage==8 & age==3
replace age5pt = 2 if maxage==8 & age==4
replace age5pt = 3 if maxage==8 & age==5
replace age5pt = 3 if maxage==8 & age==6
replace age5pt = 4 if maxage==8 & age==7
replace age5pt = 5 if maxage==8 & age==8


saveold kenya_working_2013_11_11.dta, replace


