clear
set more off
cap log close
log using read.log,replace


/* level 1*/

insheet using LEVEL1_20151221.csv,comma names

desc
destring,replace 
gen male_level1=sex=="M"

tab mother_race
destring mother_race, force replace

gen mom_white=mother_race==1
gen mom_black=mother_race==2 | mother_race==8
gen mom_hisp=mother_race==3
replace mom_hisp=mother_lang=="2"
gen mom_asian=mother_race>=4 & mother_race<=5
gen mom_mult=mother_race==17

gen mom_race=1 if mother_race==1
replace mom_race=2 if mom_black==1
replace mom_race=3 if mom_hisp==1
replace mom_race=4 if mom_asian==1
replace mom_race=6 if mom_mult==1
replace mom_race=5 if mother_race==. 

label define mother_racel 1 white 2 black 3 Hispanic 4 Asian 5 other 6 "Multiple race"
label values mom_race mother_racel

destring mother_edu,replace force
replace mother_edu=. if mother_edu==99
rename mother_edu momedu

destring birth_weight,replace force
replace birth_weight=. if birth_weight==9999
rename birth_weight bw

tab mother_marital


gen married=mother_marital=="2" 

gen gestat=gestational if gestational~="?"
tab gestat
destring gestat,replace force
replace gestat=. if gestat==99

gen bo=real(num_births)+1
replace bo=. if num_births=="99"

destring birth_year,replace force

gen momage=real(mother_age)
replace momage=round(momage,.1)
replace momage=. if momage>50
replace momage=. if momage<10

label var married "Married at Birth"
label var mom_black "Mother African-American"
label var mom_hisp "Mother Hispanic"
label var mom_white "Mother White"
label var momedu "Maternal education in years"
label var momage "Maternal age at birth"
label var mom_race "Maternal Race"

destring apgar_1, replace force
destring apgar_5, replace force

replace apgar_1=. if apgar_1>10
replace apgar_5=. if apgar_5>10

destring num_visits,replace force
destring mth_pren,replace force
replace num_visits=. if num_visits>50
gen month_prenatal=mth_pren if mth_pren<=9
replace month_prenatal=1 if month_prenatal==0
label var num_visit "Number prenatal visits"
label var month_prenatal "Month prenatal care initiated"


keep  mom* bo bw gestat male married mother_race ///
pid apgar* num_visits month_prenatal birth_year mother_id risk_disp male_level1

tab birth_year
count

gen level1=1
sort pid
save level1.dta,replace





/* LEAD*/
clear
import delimited LESS_20151221.csv
desc


drop if no_link==1
drop no_link

/* drop duplicates*/

sort pid address_id draw_date test_result
quietly by pid address_id draw_date test_result: gen dup=cond(_N==1,0,_n)
 
tab dup
drop if dup>1

 
gen lead_date=date(draw_date, "YMD")
format lead_date %d
gen lead_year=year(lead_date)
list lead_date draw_date in 1/10
drop draw_date


gen approxdob=(lead_date)-30.5*age_at_test
format approxdob %d

rename pid pid_num
gen pid=string(pid_num)

drop if pid==""
drop if test_result==.

sort pid age_at test_method
by pid age_at: gen n=_n
by pid age_at: gen N=n[_N]
gen keep=1 if N==1
* keep all with one test per month

replace keep=1 if test_method=="V" & N>1
* keep all those with a venous sample

gen venous=test_method=="V"
gen capillary=test_method=="C"

by pid age_at: egen sumv=sum(venous)
by pid age_at: gen hasv=1 if sumv>=1 & sumv~=. 

by pid age_at: replace keep=0 if test_meth=="C" & hasv==1
* drop capillary if have a venous sample in same month

gen vtest_result=test_result
replace vtest_result=. if venous==0
label var vtest_result "Venous test result"


gen ctest_result=test_result
replace ctest_result=. if capillary==0
label var ctest_result "Capillary test result"


sort pid age_at test_result
by pid age_at: replace keep=1 if sumv==0 & _n==1
by pid age_at: replace keep=0 if sumv==0 & _n~=1
*if only capillary test results, keep lowest one

tab keep
drop if keep==0


by pid age_at: egen haskeep=sum(keep)

tab haskeep
bysort pid age_at: egen maxvtest=max(test_result) if sumv>1 & sumv~=.
bysort pid age_at: egen avgvtest=mean(test_result) if sumv>1 & sumv~=. 
*if more than one venous sample in same month, measure the max and the average

gen maxlead=test_result
replace maxlead=maxvtest if maxvtest~=. 

gen avglead=test_result
replace avglead=avgvtest if avgvtest~=. 

bysort pid age_at: keep if _n==1
summ avglead maxlead

gen num=1
gen over5= maxlead>=5 if maxlead!=. 
gen over10=maxlead>=10 & maxlead~=. 

gen over5b=avglead>=5 & avglead~=. 
gen over10b=avglead>=10 & avglead~=. 

table lead_year, c (mean avglead mean maxlead mean over5 mean over10 count num)
table lead_year, c (mean over5b mean over10b)


sort pid lead_date
by pid:replace approxdob=approxdob[1]

gen birth_year=year(approxdob)

gen fips=substr(geo,-8,1)
tab fips


keep pid address_id age_at_test fips test_method sumv test_result vtest_result ctest_result maxlead lead_year geo approxdob lead_date

/* geometric mean*/

gen avglead_forg=test_result+1
replace avglead_forg=1 if avglead_forg==. 

*egen lead_geom=gmean(avglead_forg), by(pid)

gen lead_geom=. 



/* means*/

sort pid age_at_test

by pid: gen firsttract=geo[1]
by pid: gen firstaddress=address_id[1]
by pid: gen firstfips=fips[1]
by pid: gen firstdatetest=lead_date[1]

drop fips avglead_forg lead_year

reshape wide test_result vtest_result ctest_result maxlead sumv test_method geo lead_date lead_geom* address_id, i(pid) j(age_at_test)



egen leadlevel=rowmean(test_result*)
egen leadvenous=rowmean(vtest_result*)
egen leadcapil=rowmean(ctest_result*)
summ leadlevel leadvenous leadcapil
label var leadlevel "Average Lead Level"
label var leadvenous "Average of all venous tests"
label var leadcapil "Average of all capillary tests"
label var firstdatetest "Date of first lead test"
 


format firstdatetest %d
gen lead_year=year(firstdatetest)

gen less=1
sort firstaddress
save less.dta,replace




/* clean education data*/
clear

import delimited RIDE_NECAP_20151221.csv
desc

tab no_link
keep if no_link=="0"
drop no_link

codebook pid
count
count if pid=="NA"


gen math_score=real(math_ss) 
gen read_score=real(rdg_ss)


rename math_grade math_grade_orig
gen math_grade=2 if math_grade_orig=="Grade 02"
replace math_grade=3 if math_grade_orig=="Grade 03"
replace math_grade=4 if math_grade_orig=="Grade 04"
replace math_grade=5 if math_grade_orig=="Grade 05"
replace math_grade=6 if math_grade_orig=="Grade 06"
replace math_grade=7 if math_grade_orig=="Grade 07"
replace math_grade=8 if math_grade_orig=="Grade 08"
replace math_grade=9 if math_grade_orig=="Grade 09"
replace math_grade=10 if math_grade_orig=="Grade 10"
replace math_grade=11 if math_grade_orig=="Grade 11"
replace math_grade=12 if math_grade_orig=="Grade 12"


rename rdg_grade rdg_grade_orig
gen rdg_grade=2 if rdg_grade_orig=="Grade 02"
replace rdg_grade=3 if rdg_grade_orig=="Grade 03"
replace rdg_grade=4 if rdg_grade_orig=="Grade 04"
replace rdg_grade=5 if rdg_grade_orig=="Grade 05"
replace rdg_grade=6 if rdg_grade_orig=="Grade 06"
replace rdg_grade=7 if rdg_grade_orig=="Grade 07"
replace rdg_grade=8 if rdg_grade_orig=="Grade 08"
replace rdg_grade=9 if rdg_grade_orig=="Grade 09"
replace rdg_grade=10 if rdg_grade_orig=="Grade 10"
replace rdg_grade=11 if rdg_grade_orig=="Grade 11"
replace rdg_grade=12 if rdg_grade_orig=="Grade 12"

rename rdg_grade read_grade

gen freelunch=lunch=="Free"
gen redlunch=lunch=="Reduced"
gen free_reduc=freelunch==1 | redlunch==1

rename iep x
gen iep=1 if x=="IEP Yes"
drop x
rename ell x
gen ell=x=="ELL Yes"
drop x

rename p504 x
gen p504=x=="Plan 504 Yes"
drop x

rename grade x
gen grade=1 if x=="Grade 01"
replace grade=2 if x=="Grade 02"
replace grade=3 if x=="Grade 03"
replace grade=4 if x=="Grade 04"
replace grade=5 if x=="Grade 05"
replace grade=6 if x=="Grade 06"
replace grade=7 if x=="Grade 07"
replace grade=8 if x=="Grade 08"
replace grade=9 if x=="Grade 09"
replace grade=10 if x=="Grade 10"
replace grade=11 if x=="Grade 11"
replace grade=12 if x=="Grade 12"
replace grade=0 if x=="Kindergarten (Full Day)" | x=="Kindergarten (Half Day)"
replace grade=-1 if x=="Pre-Kindergarten (Full Da" | x=="Pre-Kindergarten (Half Da"
gen prek=grade==-1
tab grade
replace grade=0 if grade==-1

tab school_year

gen schoolyear=2004 if school_year=="2004-2005"
replace schoolyear=2005 if school_year=="2005-2006"
replace schoolyear=2006 if school_year=="2006-2007"
replace schoolyear=2007 if school_year=="2007-2008"
replace schoolyear=2008 if school_year=="2008-2009"
replace schoolyear=2009 if school_year=="2009-2010"
replace schoolyear=2010 if school_year=="2010-2011"
replace schoolyear=2011 if school_year=="2011-2012"
replace schoolyear=2012 if school_year=="2012-2013"
replace schoolyear=2013 if school_year=="2013-2014"

gen z=string(read_score)
gen y=string(math_score)


gen grade2=substr(z,1,1) if read_score<1000
replace grade2=substr(z,1,2) if read_score>=1000
destring grade2,replace

count if grade~=grade2
tab grade grade2 if grade~=grade2

gen read_score2=substr(z,-2,2)
gen math_score2=substr(y,-2,2)

rename read_score read_score_orig
rename math_score math_score_orig

destring read_score2,replace
destring math_score2,replace
rename read_score2 read_score
rename math_score2 math_score

gen exitdate=date(exit_date, "MDY")
gen enrolldate=date(enroll_date, "MDY")

format exitdate enrolldate %d
gen exityear=year(exitdate)

tab grade

gen raceb=2 if black=="1"
replace raceb=1 if white=="1" & raceb==. 
replace raceb=3 if hispanic=="1" & raceb~=2
replace raceb=4 if asian=="1" & raceb==.
replace raceb=5 if pacific=="1" | native=="1"

label define racebl 1 White 2 Black 3 Hispanic 4 Asian 5 Other 
label values raceb racebl

tab raceb
tab race if raceb==. 

tab race if raceb==1
tab race if raceb==2
tab race if raceb==3
tab race if raceb==4
tab race if raceb==5
tab race if raceb==. 

replace raceb=1 if race=="E" & raceb==. 
replace raceb=2 if race=="C" & raceb==. 
replace raceb=3 if race=="D" & raceb==. 
replace raceb=4 if race=="B" & raceb==. 



keep pid p504 iep freelunch redlunch free_reduc grade grade2 ///
math_score school_year read_score schoolyear new_school_id raceb sex ada adm *_achlv

count if pid=="NA"

drop if pid=="NA"
sort pid grade schoolyear read_score
by pid grade schoolyear read_score: gen n=_n
by pid grade schoolyear read_score: gen N=n[_N]
tab N

list pid grade school_year race read_score if N==2 in 1/1000


/* drop perfect duplicates*/

bysort pid grade school_year read_score: keep if _n==1


drop n N

sort pid grade school_year read_score
by pid grade school_year: gen n=_n
by pid grade school_year: gen N=n[_N]
tab N

list pid grade grade2 school_year race read_score if N==2
drop n N



/* don't drop missings*/

*drop if math_score==. & read_score==. 


/* 9% of the records are same ID, grade and school year but different scores - just keep the first*/

sort pid grade school_year
by pid grade school_year: keep if _n==1


sort pid grade
by pid grade: gen n=_n
by pid grade: gen N=n[_N]
tab N
gen repeat=0
replace repeat=1 if N>1
tab repeat
label var repeat "repeated grade"

set more off
count
sort pid grade schoolyear
by pid grade: keep if _n==1
/* keep the test in the first time attempted the grade*/

cap drop n N
sort pid grade
by pid: gen n=_n
by pid: gen N=n[_N]
by pid: gen lastgrade=grade[_N]
by pid: gen firstgrade=grade[1]
tab lastgrade
sort pid school_year
by pid: gen lastyear=school_year[_N]
by pid: gen firstyear=school_year[1]
tab lastyear
tab firstyear


rename N numgrades
drop n



drop if grade==. 
drop grade2

reshape wide raceb new_school_id p504 iep freelunch redlunch free_reduc math_score read_score school_year schoolyear repeat sex ada adm *_achlv, i(pid) j(grade)
local x=0
while `x'<=12 {
label var freelunch`x' "Free lunch eligible in grade `x'"
label var redlunch`x' "Reduced lunch eligible in grade `x'"
label var math_score`x' "Math Score in grade `x'"
label var read_score`x' "Reading Score in grade `x'"
local x=`x'+1
}


label var lastgrade "Last grade student enrolled"
label var lastyear "Last school year student enrolled"
label var firstyear "First school year student enrolled"
label var numgrades "Number of grades present in data"
label var firstgrade "First grade student enrolled"

gen leaver12=lastgrade<12 & lastyear~="2013-2014"
label var leaver12 "Student left before graduating"
gen leaver8=lastgrade<8 & lastyear~="2013-2014"
label var leaver8 "Student left before completing grade 8"
gen nonleaver8=lastyear=="2013-2014" | lastgrade>=8
label var nonleaver8 "Student not censored at grade 8"

gen status8=1 if read_score8~=. 
replace status8=2 if read_score8==. & lastgrade>=8
replace status8=3 if read_score8==. & leaver8==1
replace status8=4 if read_score8==. & lastyear=="2013-2014" & lastgrade<8
label define status8l 1 "8th grade score non-missing" 2 "Present, but score missing" 3 "Left before grade 8 " 4 "Not yet completed 8th grade"
label values status8 status8l
label var status8 "Enrollment/Test Score Status in 8th Grade"
tab status

/* free lunch*/

egen sumfree=rsum(freelunch*)
egen sumfreered=rsum(free_reduc*)
gen sharefree_red=sumfreered/numgrades

gen alwaysfree=sharefree_red>=.9
gen neverfree=sharefree_red==0
gen somefree=sharefree_red>0 & sharefree_red<.9
label var alwaysfree "Always free/reduced lunch"
label var neverfree "Never free/reduced lunch"
label var somefree "Sometimes free/reduced lunch"


/* race from RIDE DATA*/
gen black=.
gen white=. 
gen hisp=. 
gen asian=. 
gen other=. 
gen hispanic=. 

local x=0 
while `x'<=12 {
replace black=1 if raceb`x'==2 & black==. 
replace white=1 if raceb`x'==1 & white==. 
replace hispanic=1 if raceb`x'==3 & hispanic==. 
replace asian=1 if raceb`x'==4 & asian==. 
replace other=1 if raceb`x'==5 & other==.  
local x=`x'+1
}

replace black=0 if black==. 
replace white=0 if white==. 
replace hispanic=0 if hispanic==. 
replace other=0 if other==.
replace asian=0 if asian==.


gen male_ride=.
local x=0
while `x'<=12 {
replace male_ride=1 if sex`x'=="Male" & male_ride==. 
replace male_ride=0 if sex`x'=="Female" & male_ride==. 
local x=`x'+1
}

drop sex*

sort pid
save ride_necap.dta,replace



/*ride infractions*/


clear

import delimited using INFRACTIONS_20151221.csv

keep if no_link=="0"
drop no_link

tab infraction

/* generate any infraction/# infractions/severity of the infraction/suspension*/

gen numinfract=1


gen suspendout=disposition=="Suspended/Out of School" | disposition=="Suspended/Out-of-School"
tab suspendout

gen altplace=strpos(disposition, "Alternate")

gen suspendin=disposition=="Suspended/In School" | disposition=="Suspended/In-School"
tab suspendin


gen schoolyear=7 if school_year=="2007-2008"
replace schoolyear=8 if school_year=="2008-2009"
replace schoolyear=9 if school_year=="2009-2010"
replace schoolyear=10 if school_year=="2010-2011"
replace schoolyear=11 if school_year=="2011-2012"
replace schoolyear=12 if school_year=="2012-2013"
replace schoolyear=13 if school_year=="2013-2014"

/* categorize the infractions*/


gen str var="alc" if infraction=="Alcohol"
replace var="arson" if infraction=="Arson"
replace var="ass_stu" if infraction=="Assault of Student" | infraction=="Assult/Battery of Student"
replace var="ass_tea" if infraction=="Assault of Teacher" | infraction=="Assult/Battery of Teacher"
replace var="skip_class" if infraction=="Attendance-Cut/Skipped Class"
replace var="skip_det" if infraction=="Attendance-Cut/Skipped Detention"
replace var="skip_school" if infraction=="Attendance-Left School Grounds"
replace var="truant" if infraction=="Attendance-Truant"
replace var="tardy" if infraction=="Attendance-Tardy" | infraction=="Attendance-Tardy/Late"
replace var="bomb" if infraction=="Bomb Threat"
replace var="cheat" if infraction=="Cheating/Plagiarism"
replace var="phone" if infraction=="Communication/Electronic Devices"
replace var="breakent" if infraction=="Breaking & Entering"
replace var="dc" if infraction=="Disorderly Conduct"
replace var="extort" if infraction=="Extortion"
replace var="fight" if infraction=="Fighting" | infraction=="Fighting/Physical Altercation"
replace var="fire" if infraction=="Fire Regulations Violation"
replace var="forgery" if infraction=="Forgery"
replace var="gamble" if infraction=="Gambling"
replace var="gang" if infraction=="Gang Activity" | infraction=="Gang Activity-Non-Violent Incident"
replace var="harr_sex" if infraction=="Harrassment-Sexual"
replace var="stalk" if infraction=="Harrassment-Stalking"
replace var="harrass" if infraction=="Harrassment-Verbal/Physical"
replace var="hate" if infraction=="Hate Crimes"
replace var="haze" if infraction=="Hazing"
replace var="disrespect" if infraction=="Insubordination/Disrespect"
replace var="kidnap" if infraction=="Kidnapping/Abduction"
replace var="theft" if infraction=="Larceny" | infraction=="Larceny/Theft" | infraction=="Robberty"
replace var="smoke" if infraction=="Tobacco" | infraction=="Tobacco-Possession or Use"
replace var="trespass" if infraction=="Trespassing"
replace var="vandal" if infraction=="Vandalism"
replace var="weapon" if infraction=="Weapon Possession"
replace var="threat" if infraction=="Threat/Intimidation"
replace var="other" if infraction=="Other"
replace var="sexass" if infraction=="Sexual Assault/Battery"
replace var="sexmis" if infraction=="Sexual Misconduct"
replace var="lang_stu" if infraction=="Obscene/Abusive Language toward Student"
replace var="lang_tea" if infraction=="Obscene/Abusive Language toward Teacher"

gen computer=strpos(infraction,"Technology")
gen drugs=strpos(infraction, "Controlled Substances")
replace var="computer" if computer==1
replace var="drugs" if drugs==1

drop computer drugs
sort var

/* collapse per person year*/

collapse (sum) numinfract suspendout suspendin altplace (max) coef, by(pid schoolyear)
preserve

reshape wide numinfract suspendout suspendin altplace coef, i(pid) j(schoolyear)

gen firstinfract=.
label var firstinfract "Year of First Infraction"

local x=7
while `x'<=13 {
replace firstinfract=`x' if numinfract`x'>0 & numinfract`x'~=. & firstinfract==.
local x=`x'+1
}

sort pid
save infractbyyear.dta,replace


/* collapse per person*/

restore
collapse (sum) numinfract suspendout suspendin altplace (max) coef, by(pid)

label var numinfract "Total number of infractions"
label var suspendout "Total number of out of school suspensions"
label var suspendin "Total number of in school suspensions"
label var altplace "Total number of alternative placements"
label var coef "Severity of max infraction"

drop if pid=="NA"

gen anyinfract=1
label var anyinfract "Any infraction"

sort pid
merge pid using infractbyyear.dta
tab _merge
drop _merge

sort pid
save infractsum.dta,replace

clear

use ride_necap
sort pid
merge pid using infractsum.dta
tab _merge
drop if _merge==2
replace anyinfract=0 if _merge==1
replace numinfract=0 if _merge==1
replace suspendout=0 if _merge==1
replace suspendin=0 if _merge==1
replace altplace=0 if _merge==1


cap drop _merge

gen ride=1
sort pid
save ride_full.dta,replace



/* add mean test score of school*grade*year */

gen double school3_year=new_school_id3*100+(schoolyear3-2003)

gen read_fail3=read_score3<30 if read_score3~=. 

sort school3_year
by school3_year: egen meanread3=mean(read_score3)
by school3_year: egen sum3=total(read_score3)
by school3_year: egen fail3=mean(read_fail3)

gen meanread3_1=(meanread3*sum3-read_score3)/(sum3-1)
summ meanread3*

gen meanfail3_1=(fail3*sum3-read_fail3)/(sum3-1)
summ meanfail3_1 read_fail3

gen double school6_year=new_school_id6*100+(schoolyear6-2003)

gen double school8_year=new_school_id8*100+(schoolyear8-2003)


gen read_fail6=read_score6<30 if read_score6~=. 

sort school6_year
by school6_year: egen meanread6=mean(read_score6)
by school6_year: egen sum6=total(read_score6)
by school6_year: egen fail6=mean(read_fail6)

local x=7
while `x'<=13 {
local z=`x'+2000
sort school8_year
by school8_year: egen meaninfract8_`x'=mean(numinfract`x') if schoolyear8==`z'
local x=`x'+1
}


gen meaninfract8_1=. 

gen f=1
bysort school8_year: egen infsum8=total(f)

local x=7
while `x'<=13 {
local z=`x'+2000
replace meaninfract8_1=(meaninfract8_`x'*infsum8 - numinfract`x')/(infsum8-1) if schoolyear8==`z'
local x=`x'+1
}


gen meanread6_1=(meanread6*sum6-read_score6)/(sum6-1)
summ meanread6*

gen meanfail6_1=(fail6*sum6-read_fail6)/(sum6-1)
summ meanfail6_1 read_fail6

label var meanread6_1 "Average reading score in grade 6"
label var meanread3_1 "Average reading score in grade 3"
label var meanfail3_1 "Share Failing to Read in grade 3"
label var meanfail6_1 "Share Failing to Read in grade 6"
label var meaninfract8_1 "Average infractions in grade 8"


/* get number of years in school for infraction data*/



gen firstyear_r=substr(firstyear,-9,4)
tab firstyear_r

gen lastyear_r=substr(lastyear,-9,4)
tab lastyear_r
destring lastyear_r, replace
destring firstyear_r, replace

gen numyears_inf=.
replace numyears_inf=lastyear_r-firstyear_r +1 if firstyear_r>=2007
replace numyears_inf=lastyear_r-2007 +1 if firstyear_r<2007 & lastyear_r>2007
replace numyears_inf=0 if lastyear_r<2007
replace numyears_inf=1 if lastyear_r==2007

tab numyears_inf

label var numyears_inf "Number of years for infractions data"

local x=7
while `x'<=13 {
rename numinfract`x' numinfract_schyr`x'
rename suspendout`x' suspendout_schyr`x'
local x=`x'+1
}



local y=0
while `y'<=12 {
gen suspendout`y'=0 
gen numinfract`y'=0
local y=`y'+1
}



local y=0
while `y'<=12 {
local x=7
while `x'<=13 {
local z=2000+`x'
replace numinfract`y'=numinfract_schyr`x' if `z'==schoolyear`y' & numinfract_schyr`x'~=. 
replace suspendout`y'=suspendout_schyr`x' if `z'==schoolyear`y' & suspendout_schyr`x'~=.

local x=`x'+1
}
local y=`y'+1
}


sort pid
save ride_full.dta,replace

list numinfract* in 1/10



/* traffic scores data*/
clear
insheet using ../TRAFFIC_20160122.csv

desc
rename m15_score m15_traffic
rename m30_score m30_traffic
rename m50_score m50_traffic
rename m75_score m75_traffic
rename m100_score m100_traffic

gen certdate=date(certificate_date, "MDY")
format certdate %d


gen certificate=1 if certdate~=.
replace certificate=0 if certdate==.

rename addressid firstaddress
sort firstaddress certdate
by firstaddress: gen certnum=_n
replace certnum=0 if certdate==.

tab certnum
preserve
keep if certificate==0
save nocert.dta,replace
restore
keep if certificate==1

drop certificate_date
drop if certdate<0
reshape wide certdate, i(firstaddress) j(certnum)
sort firstaddress
append using nocert.dta
count

gen numcerts=.
local x=1
while `x'<=247 {
replace numcerts=`x' if certdate`x'~=.
local x=`x'+1
}

label var numcerts "Number of Certificates"
label var certdate1 "Date of First Certificate"
label var certdate2 "Date of Second Certificate"
label var certdate3 "Date of Third Certificate"
label var firstaddress "Address of first lead test"

drop certdate6-certdate247 certdate certificate_date
sort firstaddress


save traffic.dta,replace
