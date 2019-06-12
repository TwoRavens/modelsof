***********************************************************************************
*DATA SETUP
***********************************************************************************

set more off

*****************************
*
* This block of code just loads the tables that have the variable labels
*
*****************************

*Create variable labels from a series of tables
insheet using rawdata\age.csv, delimiter(";") names 
qui count
forvalues i = 1/`r(N)' {
  local num = id[`i']
  local lab = age[`i']
  di "`num' `lab'"
  label define agelabel `num' `lab', add
}
label save agelabel using varlabels\agelabel, replace
clear

insheet using rawdata\educ.csv, delimiter(";") names
qui count
forvalues i = 1/`r(N)' {
  local num = id[`i']
  local lab = educ[`i']
  di "`num' `lab'"
  label define educlabel `num' "`lab'", add
}
label save educlabel using varlabels\educlabel, replace
clear

insheet using rawdata\height.csv, delimiter(";") names
*Height crashes this because of quotes
drop height
gen height=""
replace height = "5 7" if id==4
replace height = "5 4" if id==3
replace height = "6 0" if id==2
replace height = "5 9" if id==1
qui count
forvalues i = 1/`r(N)' {
  local num = id[`i']
  local lab = height[`i']
  di "`num' `lab'"
  label define heightlabel `num' "`lab'", add
}
label save heightlabel using varlabels\heightlabel, replace
clear

insheet using rawdata\ideo.csv, delimiter(";") names
replace ideo = "Blank" if id==5
qui count
forvalues i = 1/`r(N)' {
  local num = id[`i']
  local lab = ideo[`i']
  di "`num' `lab'"
  label define ideolabel `num' "`lab'", add
}
label save ideolabel using varlabels\ideolabel, replace
clear

insheet using rawdata\religion.csv, delimiter(";") names
qui count
forvalues i = 1/`r(N)' {
  local num = id[`i']
  local lab = religion[`i']
  di "`num' `lab'"
  label define religionlabel `num' "`lab'", add
}
label save religionlabel using varlabels\religionlabel, replace
clear

*Load query table; holds profiles displayed
insheet using rawdata\query.csv, delimiter(";") names
drop queryid
rename querynum profilenumber
save recodeddata\d_profilesdisplayed.dta, replace
clear

*Load user table
* This is anonymized user data--no ip address/etc.
insheet using "rawdata\user_anonymized.txt", names

*get rid of noncompletes
drop if timecomplete =="NULL"

*get rid of duplicate people, keeping last entry
sort ssid userid
drop if ssid ==ssid[_n+1]

keep userid timestart numqueries male
destring male, replace force
label var male "Male (1=yes)"
sort userid
save recodeddata\d_user.dta, replace
clear

*Load survey table
insheet using rawdata\survey.csv, delimiter("~") names
sort userid questionname timesubmitted
drop if userid==userid[_n+1] & questionname==questionname[_n+1]
keep surveyid userid questionname response

*There are actually two sets of questions, one is the demographics/etc, the other is the evaluations
*This is the code to do the demographics/etc.
local demos1 = "consent preYearOfBirth preIdeology preRelationship preGender preRace partnerpref preEducation prePoliInterest preReligion preUseDatingSites"
local demos2 = "activityFollowingpoliticscurrentevents activityPlayingfollowingsports activityTVmovies activityTravel activityDiningoutcooking"
local demos3 = "activityHangingoutwithfriends activityConcertsmusic activityGoingtochurchorreligiousservices activityKids activityPolitics"
local demos4 = "activityPets activityJob activityEducation activitySmokes activityDrinks activityAppearance activityReligion activityDrugs"
local demos5 = "postWhyConduct Feedback postLearnFromProfile"

gen keep=0
gen qid=.
local qstnctr=1

foreach var of local demos1 {
 replace keep=1 if questionname=="`var'"
 replace qid=`qstnctr' if questionname=="`var'"
 local qstnctr=`qstnctr' + 1
}
foreach var of local demos2 {
 replace keep=1 if questionname=="`var'"
 replace qid=`qstnctr' if questionname=="`var'"
 local qstnctr=`qstnctr' + 1
}
foreach var of local demos3 {
 replace keep=1 if questionname=="`var'"
 replace qid=`qstnctr' if questionname=="`var'"
 local qstnctr=`qstnctr' + 1
}
foreach var of local demos4 {
 replace keep=1 if questionname=="`var'"
 replace qid=`qstnctr' if questionname=="`var'"
 local qstnctr=`qstnctr' + 1
}
foreach var of local demos5 {
 replace keep=1 if questionname=="`var'"
 replace qid=`qstnctr' if questionname=="`var'"
 local qstnctr=`qstnctr' + 1
}

drop if questionname=="Feedback"
keep if keep==1
drop keep questionname surveyid

drop if qid==.

reshape wide response, i(userid) j(qid)

rename response1 consent
rename response2 preYearOfBirth
rename response3 preIdeology
rename response4 preRelationship
rename response5 preGender
rename response6 preRace
rename response7 prepartnerpref
rename response8 preEducation
rename response9 prePoliInterest
rename response10 preReligion
rename response11  preUseDatingSites
rename response12  activitypoliticscurrentevents
rename response13  activitysports
rename response14  activityTVmovies
rename response15  activityTravel
rename response16  activityDiningoutcooking
rename response17  activityHangingoutwithfriends
rename response18  activityConcertsmusic
rename response19  activityGoingtochurch
rename response20  activityKids
rename response21  activityPolitics
rename response22  activityPets
rename response23  activityJob
rename response24  activityEducation
rename response25  activitySmokes
rename response26  activityDrinks
rename response27  activityAppearance
rename response28  activityReligion
rename response29  activityDrugs
rename response30  postWhyConduct
*rename response31 Feedback
rename response32  postLearnFromProfile

/* Question Recodes */

destring(consent), replace
label var consent "consent"

destring(preYearOfBirth), replace
label var preYearOfBirth yearofbirth

gen ideology = .
recode ideology (.=0) if preIdeology=="0Liberal"
recode ideology (.=1) if preIdeology=="1Moderate"
recode ideology (.=2) if preIdeology=="2Conservative"
label define ideology 0 "Liberal" 1 "Moderate" 2 "Conservative"
label values ideology ideology
label var ideology ideology

gen relstatus = .
recode relstatus (.=0) if preRelationship=="Single"
recode relstatus (.=1) if preRelationship=="InARelationship"
label define relstatus 0 "single" 1 "in a relationship"
label values relstatus relstatus
label var relstatus relstatus

gen gender = .
recode gender (.=0) if preGender=="Female"
recode gender (.=1) if preGender=="Male"
label define gender 0 "Female" 1 "Male"
label values gender gender
label var gender gender

gen race = .
recode race (.=0) if preRace=="AsianPI"
recode race (.=1) if preRace=="Black"
recode race (.=2) if preRace=="Hispanic"
recode race (.=3) if preRace=="NativeAmerican"
recode race (.=4) if preRace=="Other"
recode race (.=5) if preRace=="White"
label define race 0 "AsianPI" 1 "Black" 2 "Hispanic" 3 "NativeAmerican" 4 "Other" 5 "White"
label values race race
label var race race

* Eliminate people only interested in dating same sex
drop if prepartnerpref=="Men" & gender==1
drop if prepartnerpref =="Women" & gender==0

gen education = .
recode education (.=0) if preEducation=="1HS"
recode education (.=1) if preEducation=="2SomeColl"
recode education (.=2) if preEducation=="3College"
recode education (.=3) if preEducation=="4SomeGraduate"
recode education (.=4) if preEducation=="5GraduateSchool"
label define education 0 "high school" 1 "some college" 2 "college" 3 "some grad school" 4 "grad school"
label values education education
label var education education

gen poliinterest = .
recode poliinterest (.=0) if prePoliInterest=="1HardlyAtAll"
recode poliinterest (.=1) if prePoliInterest=="2OnlyNowAndThen"
recode poliinterest (.=2) if prePoliInterest=="3SomeOfTheTime"
recode poliinterest (.=3) if prePoliInterest=="4MostOfTheTime"
label define poliinterest 0 "hardly at all" 1 "only now and then" 2 "some of the time" 3 "most of the time"
label values poliinterest poliinterest
label var poliinterest poliinterest

gen religion = .
recode religion (.=0) if preReligion=="Buddhist"
recode religion (.=1) if preReligion=="Catholic"
recode religion (.=2) if preReligion=="Hindu"
recode religion (.=3) if preReligion=="Jewish"
recode religion (.=4) if preReligion=="Muslim"
recode religion (.=5) if preReligion=="None"
recode religion (.=6) if preReligion=="Other"
recode religion (.=7) if preReligion=="Protestant"
label define religion 0 "Buddhist" 1 "Catholic" 2 "Hindu" 3 "Jewish" 4 "Muslim" 5 "None" 6 "Other" 7 "Protestant"
label values religion religion
label var religion religion

gen usedatingsites = .
recode usedatingsites (.=0) if preUseDatingSites=="0Never"
recode usedatingsites (.=1) if preUseDatingSites=="1Rarely"
recode usedatingsites (.=2) if preUseDatingSites=="2Sometimes"
recode usedatingsites (.=3) if preUseDatingSites=="3VeryOften"
recode usedatingsites (.=4) if preUseDatingSites=="4AllTheTime"
label define usedatingsites 0 "never" 1 "rarely" 2 "sometimes" 3 "very often" 4 "all the time"
label values usedatingsites usedatingsites
label var usedatingsites usedatingsites

gen activity_politics1 = .
recode activity_politics1 (.=0) if  activitypoliticscurrentevents=="0NotAtAll"
recode activity_politics1 (.=1) if activitypoliticscurrentevents=="1ALittle"
recode activity_politics1 (.=2) if activitypoliticscurrentevents=="2AModerateAmount"
recode activity_politics1 (.=3) if activitypoliticscurrentevents=="3ALot"
recode activity_politics1 (.=4) if activitypoliticscurrentevents=="4AGreatDeal"
label define activity_politics1 0 "not at all" 1 "a little" 2 "a moderate amount" 3 "a lot" 4 "a great deal"
label values activity_politics1 activity_politics1
label var activity_politics1 activity_politics1

gen activity_sports = .
recode activity_sports (.=0) if  activitysports=="0NotAtAll"
recode activity_sports (.=1) if activitysports=="1ALittle"
recode activity_sports (.=2) if activitysports=="2AModerateAmount"
recode activity_sports (.=3) if activitysports=="3ALot"
recode activity_sports (.=4) if activitysports=="4AGreatDeal"
label define activity_sports 0 "not at all" 1 "a little" 2 "a moderate amount" 3 "a lot" 4 "a great deal"
label values activity_sports activity_sports
label var activity_sports activity_sports

gen activity_TVmovies = .
recode activity_TVmovies (.=0) if  activityTVmovies=="0NotAtAll"
recode activity_TVmovies (.=1) if activityTVmovies=="1ALittle"
recode activity_TVmovies (.=2) if activityTVmovies=="2AModerateAmount"
recode activity_TVmovies (.=3) if activityTVmovies=="3ALot"
recode activity_TVmovies (.=4) if activityTVmovies=="4AGreatDeal"
label define activity_TVmovies 0 "not at all" 1 "a little" 2 "a moderate amount" 3 "a lot" 4 "a great deal"
label values activity_TVmovies activity_TVmovies
label var activity_TVmovies activity_TVmovies

gen activity_Travel = .
recode activity_Travel (.=0) if  activityTravel=="0NotAtAll"
recode activity_Travel (.=1) if activityTravel=="1ALittle"
recode activity_Travel (.=2) if activityTravel=="2AModerateAmount"
recode activity_Travel (.=3) if activityTravel=="3ALot"
recode activity_Travel (.=4) if activityTravel=="4AGreatDeal"
label define activity_Travel 0 "not at all" 1 "a little" 2 "a moderate amount" 3 "a lot" 4 "a great deal"
label values activity_Travel activity_Travel
label var activity_Travel activity_Travel

gen activity_Diningoutcooking = .
recode activity_Diningoutcooking (.=0) if  activityDiningoutcooking=="0NotAtAll"
recode activity_Diningoutcooking (.=1) if activityDiningoutcooking=="1ALittle"
recode activity_Diningoutcooking (.=2) if activityDiningoutcooking=="2AModerateAmount"
recode activity_Diningoutcooking (.=3) if activityDiningoutcooking=="3ALot"
recode activity_Diningoutcooking (.=4) if activityDiningoutcooking=="4AGreatDeal"
label define activity_Diningoutcooking 0 "not at all" 1 "a little" 2 "a moderate amount" 3 "a lot" 4 "a great deal"
label values activity_Diningoutcooking activity_Diningoutcooking
label var activity_Diningoutcooking activity_Diningoutcooking

gen activity_Hangingoutwithfriends = .
recode activity_Hangingoutwithfriends (.=0) if  activityHangingoutwithfriends=="0NotAtAll"
recode activity_Hangingoutwithfriends (.=1) if activityHangingoutwithfriends=="1ALittle"
recode activity_Hangingoutwithfriends (.=2) if activityHangingoutwithfriends=="2AModerateAmount"
recode activity_Hangingoutwithfriends (.=3) if activityHangingoutwithfriends=="3ALot"
recode activity_Hangingoutwithfriends (.=4) if activityHangingoutwithfriends=="4AGreatDeal"
label define activity_Hangingoutwithfriends 0 "not at all" 1 "a little" 2 "a moderate amount" 3 "a lot" 4 "a great deal"
label values activity_Hangingoutwithfriends activity_Hangingoutwithfriends
label var activity_Hangingoutwithfriends activity_Hangingoutwithfriends

gen activity_Concertsmusic = .
recode activity_Concertsmusic (.=0) if  activityConcertsmusic=="0NotAtAll"
recode activity_Concertsmusic (.=1) if activityConcertsmusic=="1ALittle"
recode activity_Concertsmusic (.=2) if activityConcertsmusic=="2AModerateAmount"
recode activity_Concertsmusic (.=3) if activityConcertsmusic=="3ALot"
recode activity_Concertsmusic (.=4) if activityConcertsmusic=="4AGreatDeal"
label define activity_Concertsmusic 0 "not at all" 1 "a little" 2 "a moderate amount" 3 "a lot" 4 "a great deal"
label values activity_Concertsmusic activity_Concertsmusic
label var activity_Concertsmusic activity_Concertsmusic

gen activity_Goingtochurch = .
recode activity_Goingtochurch (.=0) if  activityGoingtochurch=="0NotAtAll"
recode activity_Goingtochurch (.=1) if activityGoingtochurch=="1ALittle"
recode activity_Goingtochurch (.=2) if activityGoingtochurch=="2AModerateAmount"
recode activity_Goingtochurch (.=3) if activityGoingtochurch=="3ALot"
recode activity_Goingtochurch (.=4) if activityGoingtochurch=="4AGreatDeal"
label define activity_Goingtochurch 0 "not at all" 1 "a little" 2 "a moderate amount" 3 "a lot" 4 "a great deal"
label values activity_Goingtochurch activity_Goingtochurch
label var activity_Goingtochurch activity_Goingtochurch

gen activity_Kids = .
recode activity_Kids (.=0) if  activityKids=="1NotAtAll"
recode activity_Kids (.=1) if activityKids=="2NotVery"
recode activity_Kids (.=2) if activityKids=="3Somewhat"
recode activity_Kids (.=3) if activityKids=="4Very"
label define activity_Kids 0 "not at all" 1 "not very" 2 "somewhat" 3 "very"
label values activity_Kids activity_Kids
label var activity_Kids activity_Kids

gen activity_Politics = .
recode activity_Politics (.=0) if  activityPolitics=="1NotAtAll"
recode activity_Politics (.=1) if activityPolitics=="2NotVery"
recode activity_Politics (.=2) if activityPolitics=="3Somewhat"
recode activity_Politics (.=3) if activityPolitics=="4Very"
label define activity_Politics 0 "not at all" 1 "not very" 2 "somewhat" 3 "very"
label values activity_Politics activity_Politics
label var activity_Politics activity_Politics

gen activity_Pets = .
recode activity_Pets (.=0) if  activityPets=="1NotAtAll"
recode activity_Pets (.=1) if activityPets=="2NotVery"
recode activity_Pets (.=2) if activityPets=="3Somewhat"
recode activity_Pets (.=3) if activityPets=="4Very"
label define activity_Pets 0 "not at all" 1 "not very" 2 "somewhat" 3 "very"
label values activity_Pets activity_Pets
label var activity_Pets activity_Pets

gen activity_Job = .
recode activity_Job (.=0) if  activityJob=="1NotAtAll"
recode activity_Job (.=1) if activityJob=="2NotVery"
recode activity_Job (.=2) if activityJob=="3Somewhat"
recode activity_Job (.=3) if activityJob=="4Very"
label define activity_Job 0 "not at all" 1 "not very" 2 "somewhat" 3 "very"
label values activity_Job activity_Job
label var activity_Job activity_Job

gen activity_Education = .
recode activity_Education (.=0) if  activityEducation=="1NotAtAll"
recode activity_Education (.=1) if activityEducation=="2NotVery"
recode activity_Education (.=2) if activityEducation=="3Somewhat"
recode activity_Education (.=3) if activityEducation=="4Very"
label define activity_Education 0 "not at all" 1 "not very" 2 "somewhat" 3 "very"
label values activity_Education activity_Education
label var activity_Education activity_Education

gen activity_Smokes = .
recode activity_Smokes (.=0) if  activitySmokes=="1NotAtAll"
recode activity_Smokes (.=1) if activitySmokes=="2NotVery"
recode activity_Smokes (.=2) if activitySmokes=="3Somewhat"
recode activity_Smokes (.=3) if activitySmokes=="4Very"
label define activity_Smokes 0 "not at all" 1 "not very" 2 "somewhat" 3 "very"
label values activity_Smokes activity_Smokes
label var activity_Smokes activity_Smokes

gen activity_Drinks = .
recode activity_Drinks (.=0) if  activityDrinks=="1NotAtAll"
recode activity_Drinks (.=1) if activityDrinks=="2NotVery"
recode activity_Drinks (.=2) if activityDrinks=="3Somewhat"
recode activity_Drinks (.=3) if activityDrinks=="4Very"
label define activity_Drinks 0 "not at all" 1 "not very" 2 "somewhat" 3 "very"
label values activity_Drinks activity_Drinks
label var activity_Drinks activity_Drinks

gen activity_Appearance = .
recode activity_Appearance (.=0) if  activityAppearance=="1NotAtAll"
recode activity_Appearance (.=1) if activityAppearance=="2NotVery"
recode activity_Appearance (.=2) if activityAppearance=="3Somewhat"
recode activity_Appearance (.=3) if activityAppearance=="4Very"
label define activity_Appearance 0 "not at all" 1 "not very" 2 "somewhat" 3 "very"
label values activity_Appearance activity_Appearance
label var activity_Appearance activity_Appearance

gen activity_Religion = .
recode activity_Religion (.=0) if  activityReligion=="1NotAtAll"
recode activity_Religion (.=1) if activityReligion=="2NotVery"
recode activity_Religion (.=2) if activityReligion=="3Somewhat"
recode activity_Religion (.=3) if activityReligion=="4Very"
label define activity_Religion 0 "not at all" 1 "not very" 2 "somewhat" 3 "very"
label values activity_Religion activity_Religion
label var activity_Religion activity_Religion

gen activity_Drugs = .
recode activity_Drugs (.=0) if  activityDrugs=="1NotAtAll"
recode activity_Drugs (.=1) if activityDrugs=="2NotVery"
recode activity_Drugs (.=2) if activityDrugs=="3Somewhat"
recode activity_Drugs (.=3) if activityDrugs=="4Very"
label define activity_Drugs 0 "not at all" 1 "not very" 2 "somewhat" 3 "very"
label values activity_Drugs activity_Drugs
label var activity_Drugs activity_Drugs

drop  activitysports activityTVmovies activityTravel activityDiningoutcooking activityHangingoutwithfriends activityConcertsmusic activityGoingtochurch activityKids activityPets activityJob activityEducation activitySmokes activityDrinks activityAppearance activityReligion activityDrugs  activitypoliticscurrentevents activityPolitics

drop  preIdeology preRelationship preGender preRace prepartnerpref preEducation prePoliInterest preReligion preUseDatingSites

*/

save recodeddata\d_surveydemos.dta, replace
clear

*Load survey table
*This code just takes the evaluations
insheet using rawdata\survey.csv, delimiter("~") names
sort userid questionname timesubmitted
drop if userid==userid[_n+1] & questionname==questionname[_n+1]
keep userid questionname response
gen temp=substr(questionname,1,5)
keep if temp=="Query"
drop temp
gen profilenumber=real(substr(questionname,6,2))
replace profilenumber=real(substr(questionname,6,1)) if profilenumber==.
gen outcome=substr(questionname,8,100)
replace outcome=substr(questionname,7,100) if profilenumber <10
drop questionname

gen qid=.
replace qid=1 if outcome=="Interested"
replace qid=2 if outcome=="Attractive"
replace qid=3 if outcome=="LongTerm"
replace qid=4 if outcome=="Respond"
replace qid=5 if outcome=="Values"
replace qid=6 if outcome=="Friends"
drop outcome

reshape wide response, i(userid profilenumber) j(qid)
rename response1 O_Interested
rename response2 O_Attractive
rename response3 O_LongTerm
rename response4 O_Respond
rename response5 O_Values
rename response6 O_Friends

save recodeddata\d_surveyprofileevals.dta, replace
joinby userid profilenumber using recodeddata\d_profilesdisplayed
save  recodeddata\d_surveyprofileevals.dta, replace

do varlabels\agelabel.do
do varlabels\educlabel.do
do varlabels\heightlabel.do
do varlabels\ideolabel.do
do varlabels\religionlabel.do

label values ageid agelabel
label values educid educlabel
label values heightid heightlabel
label values ideoid ideolabel
label values religionid religionlabel

gen lookingatwomen=heightid==3 | heightid==4

joinby userid using recodeddata\d_surveydemos

gen mention_pol_purpose_study=0
replace mention_pol_purpose_study=1 if strpos(postWhyConduct,"politic")~=0
label var mention_pol_purpose_study "Use word politics in describing purpose of study"

rename O_Interested temp
gen O_Interested=real(substr(temp,1,1))
drop temp
label var O_Interested "Interest in dating"
label define interested 1 "not at all" 2 "slightly interested" 3 "moderately interested" 4 "very interested" 5 "extremely interested"
label values O_Interested interested

rename O_Attractive temp
gen O_Attractive=real(substr(temp,1,1))
drop temp
label var O_Attractive "Attractiveness"
label define attractive 1 "not at all" 2 "slightly attractive" 3 "moderately attractive" 4 "very attractive" 5 "extremely attractive"
label values O_Attractive attractive

rename O_LongTerm temp
gen O_LongTerm=real(substr(temp,1,1))
drop temp
label var O_LongTerm "Interest in LT Dating"
label define longterm 1 "not at all" 2 "a little well" 3 "somewhat well" 4 "very well" 5 "extremely well"
label values O_LongTerm longterm

rename O_Respond temp
gen O_Respond=real(substr(temp,1,1))
drop temp
label var O_Respond "Would you respond to person?"
label define respond 1 "definitely not" 2 "probably not" 3 "probably" 4 "definitely" 
label values O_Respond respond

rename O_Values temp
gen O_Values=real(substr(temp,1,1))
drop temp
label var O_Values "Do they share your values?"
label define values 1 "strongly disagree" 2 "somewhat disagree" 3 "somewhat agree" 4 "strongly agree" 
label values O_Values values

rename O_Friends temp
gen O_Friends=real(substr(temp,1,1))
drop temp
label var O_Friends "Would you like to be friends?"
label define friends 1 "not at all" 2 "slightly likely" 3 "somewhat likely" 4 "very likely" 5 "extremely likely"
label values O_Friends friends

label var pictureid "Picture #"
tab pictureid, gen(picindicator_)
drop picindicator_1

label var profileid "Profile #"
tab profileid, gen(profileindicator_)
drop profileindicator_1

* Note age range is expanded
gen man25 = ageid==1
gen man28 = ageid==2
gen man31 = ageid==3
gen woman22 = ageid==4
gen woman25 = ageid==5
gen woman28 = ageid==6

gen tall = heightid==2|heightid==4
label var tall "Taller profile"

/*
     Catholic |      2,629       25.33       25.33
   Protestant |      2,555       24.62       49.95
       Jewish |      2,664       25.67       75.61
Not Religious |      2,531       24.39      100.00
*/
gen prof_catholic = religionid==1
label var prof_catholic "Profile=Catholic"
gen prof_christian = religionid==2
label var prof_christian "Profile=Protestant"
gen prof_jewish = religionid==3
label var prof_jewish "Profile=Jewish"

/*
    High School |      3,440       33.14       33.14
        College |      3,458       33.32       66.46
Graduate school |      3,481       33.54      100.00
*/

gen prof_hs = educid==1
gen prof_college = educid==2
label var prof_hs "Profile Education=HS"
label var prof_college "Profile Education=College"

gen prof_lib = ideoid==1
gen prof_con = ideoid==2
gen prof_mod = ideoid==3
gen prof_ni = ideoid==4
gen prof_blank = ideoid==5

*Eliminate people who refused consent
drop if consent~=1
 
outsheet postWhyConduct using "recodeddata\OpenEndedResponses.txt" if mention_pol_purpose_study==1 & profilenumber==1, replace

*Remove extra questions
drop postWhyConduct postLearnFromProfile

compress

save recodeddata\data_for_analysis.dta, replace
