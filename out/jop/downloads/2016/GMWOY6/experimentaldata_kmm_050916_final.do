********************************************************************************************************
* Study Title: Social Exclusion and Political Identity: The Case of Asian American Partisanship
* Replication File for Experimental Study
* Date: May 9, 2016
* Written By: Alexander Kuo, Neil Malhotra, and Cecilia Hyunjung Mo
* Dataset: experimentaldata_kmm_050916.dta
********************************************************************************************************

use experimentaldata_kmm_050916.dta, clear




********************************************************************************************************
********************************************************************************************************
****                                           CLEAN DATA                                           **** 
********************************************************************************************************
********************************************************************************************************

**************************
**** SURVEY LOGISTICS ****
**************************

rename v1 responseid
label var responseid "Qualtrics Response ID"
rename v8 startdate
label var startdate "Survey Start Date"
rename v9 enddate
label var enddate "Survey End Date"
rename v10 finished
label var finished "Survey Completed"
rename q11 assigned_id
label var assigned_id "Assigned ID - Linked with Treatment Condition"
rename q12 agreed_to_participate
label var agreed_to_participate "Agreed to Participate"
label var q263 "Finished Survey"

egen start = ends(startdate), tail
egen ends = ends(enddate), tail
gen start_min=substr(start,-2,2)
gen end_min=substr(ends,-2,2)
egen start_hr=ends(start), punct(:)
egen end_hr=ends(ends), punct(:)
destring start_min, replace
destring start_hr, replace
destring end_min, replace
destring end_hr, replace
gen time_start  = 60*start_hr + start_min
gen time_end = 60*end_hr + end_min
gen time = time_end - time_start

move time finished
label var time "Time to Complete Survey"


**************************
****** DEMOGRAPHICS ******
**************************

*** Gender (Female = 1)
label var q21 "Female (RAW)"
gen female=q21
recode female (2=0)
label var female "Female"
label define female 0 "Male" 1 "Female"
label value female female
move female q21

*** Year Born
label var q22 "Year Born (RAW)"
gen yborn =1900+q22
label var yborn "Year Born"
move yborn q22

*** Age
gen years =2013-(yborn+1)
label var years "Age"
*rescaling
gen age=(years-16)/39
label var age "Age (Recoded)"
label var years "Age"
move age yborn
move years age

*** Highest Level of Education
label var q23 "Level of Education (RAW)"
label define ed 1 "Did not graduate from high school" 2 "High School graduate" 3 "Some college, but no degree (yet)" 4 "2-year college degree" 5 "4-year college degree" 6 "Postgraduate degree (MA, MBA, MD, JD, PhD, etc.)"
label value q23 ed
*rescaling
gen ed=(q23-2)/4
label var ed "Level of Education"
label value ed ed2
move ed q23 
g hs = 0 if q23 !=.
replace hs = 1 if q23 == 2
g somecol = 0 if q23 !=.
replace somecol = 1 if q23 == 3
g col = 0 if q23 !=.
replace col = 1 if q23 == 5
g post = 0 if q23 !=.
replace post = 1 if q23 == 6

*** Main Categories of Ethnicity
label var q249 "Ethnicity"
label define ethnicity 1 "White" 2 "Black" 3 "Hispanic/Latino" 4 "Asian/Asian American" 5 "Other"
label value q249 ethnicity

egen ethnicity_check = ends(ethnicitywhiteblackhispaniclatin), punct(" ")
g asian = 1 if q249 == 4 
recode asian (.=1) if ethnicity_check == "Asian" | ethnicity_check == "Asian-" | ethnicity_check == "Asian/Mixed" | ethnicity_check == "Indian"
recode asian (.=1) if q249_text == "Filipino" | q249_text == "Hispanic/ Asian" | q249_text == "Vietnamese Iranian" 
recode asian (.=0)
label var asian "Asian"
g white = 1 if q249 == 1
recode white (.=0)
label var white "White"
move asian q249
move white q249

*Asian Ethnicities
gen asian_ethnicity=.
replace asian_ethnicity=1 if q250_1==1
replace asian_ethnicity=2 if q250_2==1
replace asian_ethnicity=3 if q250_3==1
replace asian_ethnicity=4 if q250_4==1
replace asian_ethnicity=5 if q250_5==1
replace asian_ethnicity=6 if q250_6==1
replace asian_ethnicity=7 if q250_7==1
replace asian_ethnicity=8 if q250_8==1
replace asian_ethnicity=9 if q250_9==1
replace asian_ethnicity=10 if q250_10==1
replace asian_ethnicity=11 if q250_11==1
replace asian_ethnicity=12 if q250_12==1
replace asian_ethnicity=13 if q250_13==1
replace asian_ethnicity=14 if q250_14==1
replace asian_ethnicity=15 if q250_15==1
replace asian_ethnicity=16 if q250_16==1
replace asian_ethnicity=17 if q250_17==1
replace asian_ethnicity=18 if q250_18==1
replace asian_ethnicity=19 if q250_19==1
replace asian_ethnicity=20 if q250_20==1
replace asian_ethnicity=21 if q250_21==1
replace asian_ethnicity=22 if q250_22==1
replace asian_ethnicity=23 if q250_23==1
replace asian_ethnicity=24 if q250_24==1
replace asian_ethnicity=25 if q250_25==1
replace asian_ethnicity=26 if q250_26==1
replace asian_ethnicity=27 if q250_27==1
replace asian_ethnicity=28 if q250_28==1
replace asian_ethnicity=29 if q250_29==1

label var asian_ethnicity "Respondent's Asian Ethnicity (q250_1-29)"
label define asian_ethnicity 1 "Chinese" 2 "Indian" 3 "South Asian" 4 "Filipino" 5 "Vietnamese" 6 "Korean" 7 "Japanese" 8 "Hmong" 9 "Asiatic" 10 "Bangladeshi" 11 "Bhutanese" 12 "Burmese" 13 "Cambodian (Kampuchean)" 14 "Indochinese" 15 "Indonesian" 16 "Iwo Jiman" 17 "Laotian" 18 "Madagascar" 19 "Malaysian" 20 "Maldivian" 21 "Nepalese" 22 "Okinawan" 23 "Pakistani" 24 "Singaporean" 25 "Sri Lankan" 26 "Taiwanese" 27 "Thai" 28 "Other" 29 "Don't know"
label value asian_ethnicity asian_ethnicity
move asian_ethnicity q250_1

*** Party identification
label var q227 "Party ID (RAW)"
label define partyid 1 "Republican" 2 "Democrat" 3 "Independent" 4 "Other"
label value q227 partyid

*Strong Partisans
label var q228 "Strong Republican? (RAW)"
gen strongrep=q228
recode strongrep (2=0)
label var strongrep "Strong Republican?"
move strongrep q228

label var q229 "Strong Democrat? (RAW)"
gen strongdem=q229
recode strongdem (2=0)
label var strongdem "Strong Democrat?"
move strongdem q229

*Independents
label var q230 "Independent Leaning? (RAW)"
gen liberal_leaning_rep=q230
recode liberal_leaning_rep (2=0)
label define liberal_leaning_rep 0 "Lean Dem" 1 "Lean Rep"
label value liberal_leaning_rep liberal_leaning_rep
label var liberal_leaning_rep "Independent Leaning"
move liberal_leaning_rep q230

*6-point scale partisanship
gen pID=.
replace pID=1 if strongdem==1
replace pID=2 if strongdem==0
replace pID=3 if liberal_leaning_rep==0
replace pID=4 if liberal_leaning_rep==1
replace pID=5 if strongrep==0
replace pID=6 if strongrep==1

label var pID "Party Identification Scale"
label define pID 1 "Strong Democrat" 2 "Not very strong Democrat" 3 "Independent Leaning Democrat" 4 "Independent Leaning Republican" 5 "Not very strong Republican" 6 "Strong Republican"
label value pID pID
*inverting & rescaling (1: strong democrat)
gen pid=(6-pID)/5
label var pid "Party Identification Scale (Recoded; High: Democrat)"
move pid q227
move pID q227

*** Ideology scale 
label var q231 "Ideology (RAW)"
label define ideology 1 "Extremely liberal" 2 "Liberal" 3 "Slightly Liberal" 4 "Moderate; middle-of-the-road" 5 "Slightly conservative" 6 "Conservative" 7 "Extremely Conservative"
label value q231 ideology
*inverting & rescaling (1: extremely liberal)
gen ideo=(7-q231)/6
label var ideo "Ideology (Recoded; High: Liberal)"
move ideo q231
g ideo2 = 8-q231
move ideo2 q231

*** Citizenship
label var q254 "Citizen of the United States (RAW)"
gen citizen=q254
label var citizen "Citizen of the United States (INVERTED)"
replace citizen=5-q254
label define citizen 1 "No, not a U.S. citizen" 2 "Yes, U.S. citizen by naturalization" 3 "Yes, born abroad of U.S. citizen parent or parents" 4 "Yes, born in the United States"
label val citizen citizen
move citizen q254
gen us=citizen
recode us (1=0) (2 3 4=1)
label var us "Citizens of the United States"
label define us 0 "No" 1 "Yes"
label var us "Citizen of the United States"
label val us us
move us citizen
g citizen2 = 1 if citizen>=2
replace citizen2= 0 if citizen == 1
move us citizen2

*** Religious
label var q257 "Religious Affiliation"
label define religion 1 "Protestant" 2 "Catholic" 3 "Another type of Christian" 4 "Jewish" 5 "Muslim" 6 "Hindu" 7 "Buddhist" 8 "None" 9 "Some other religion"
label value q257 religion
g relig = 0 if q257!=.
replace relig = 1 if q257 !=8 & q257 != .


****************************
********* OUTCOMES *********
****************************

label define well 1 "Very well" 2 "Somewhat well" 3 "Slightly well" 4 "Not well at all"

*** Republican: Close-minded
label var q29_1 "Republicans Closed-Minded (RAW)"
label value q29_1 well
*rescaling
gen rep1=(q29_1-1)/3
label var rep1 "Republicans Closed-Minded"
move rep1 q29_1

*** Democrat: Close-minded
label var q210_1 "Democrats Close-Minded (RAW)"
label value q210_1 well
*rescaling
gen dem1=(q210_1-1)/3
label var dem1 "Democrats Close-Minded"
move dem1 q210_1

*** Republican: Ignorant
label var q29_11 "Republicans Ignorant (RAW)"
label value q29_11 well
*rescaling
gen rep9=(q29_11-1)/3
label var rep9 "Republicans Ignorant"
move rep9 q29_11

*** Democrat: Ignorant
label var q210_11 "Democrats Ignorant (RAW)"
label value q210_11 well
*rescaling
gen dem9=(q210_11-1)/3
label var dem9 "Democrats Ignorant"
move dem9 q210_11

*** Republican Party Represents Interest of people like yourself
label var q211 "Republican Represent Interest (RAW)"
label value q211 well
*inverting and rescaling
gen frep1=(4-q211)/3
label var frep1 "Republican Represent Interest"
move frep1 q211

*** Democratic Party Represents Interest of people like yourself
label var q212 "Democrats Represent Interest (RAW)"
label value q212 well
*inverting & rescaling
gen fdem1=(4-q212)/3
tab fdem1
label var fdem1 "Democrats Represent Interest"
move fdem1 q212

*** Republican Party Thermometer
sum q213_1
label var q213_1 "Republican Party Thermometer (RAW)"
*rescaling
gen frep2=q213_1/89
label var frep2 "Republican Party Thermometer"
move frep2 q213_1

*** Democratic Party Thermometer
sum q214_1
label var q214_1 "Democratic Party Thermometer (RAW)"
*rescaling
gen fdem2=(q214_1-5)/91
label var fdem2 "Democratic Party Thermometer"
move fdem2 q214_1

*** Net Closed Minded
gen v1 = rep1-dem1
replace v1 = (v1-1)/-2

*** Net Ignorant
gen v2 = rep9-dem9
replace v2 = (v2-1)/-2

*** Net Likes
egen dem_likes = rownonmiss(q219*), strok
egen dem_dislikes = rownonmiss(q221*), strok
egen rep_likes = rownonmiss(q223*), strok
egen rep_dislikes = rownonmiss(q225*), strok
gen rep_netlikes = rep_likes-rep_dislikes
gen dem_netlikes = dem_likes-dem_dislikes
gen netlikes = dem_netlikes-rep_netlikes
gen v3 = netlikes
replace v3 = (v3+11)/28

*** PID
gen v4 = pid

*** Thermometer
gen v5 = fdem2 - frep2
replace v5 = (v5+1)/2

*** Represent
gen v6 = fdem1 - frep1
replace v6 = (v6+1)/2

*** Time
egen timetask = rownonmiss(q261*), strok
gen ln_timetask = log(timetask+1)
gen v7 = ln_timetask

gen ln_timetaken= log(q262_3)
gen v8 = ln_timetaken

*** Pro-Democratic Party Index
order v1 v2 v3 v4 v5 v6 v7 v8
gen study2_avg = (v1+v2+v3+v4+v5+v6)/6


*************************
******* TREATMENT *******
*************************

gen treatment_cit = 1 if treatmentran == "T"
recode treatment_cit (.=0) if treatmentran == "C"

* restrict data to Asians and whites
gen group1 = (q249==4|q249==1) 
gen asiant = asian==1 if asian==1|q249==1
gen asiant_treat = asiant*treatment_cit




********************************************************************************************************
********************************************************************************************************
****                                            ANALYSIS                                            **** 
********************************************************************************************************
********************************************************************************************************

*** LABELS
label var treatment_cit "$\beta_{1}$: Microaggression Treatment"
label var asiant "$\beta_{2}$: Asian Respondent"
label var asiant_treat "$\beta_{3}$: Treatment X Asian"


*** TABLE 2
foreach var of varlist study2_avg v1 v2 v6 v3 v5 v4 v8 timetask {
eststo: reg `var' treatment_cit asiant asiant_treat if group1==1
}
esttab using output_tab2.tex, ar2(2) b(2) se(2) starlevels(* 0.1 ** .02 *** .002) label replace
eststo clear


*** FIGURE 1 (Run R Code "figure1" to Make Figure Based on results matrices)
set more off
mat results = J(7,3,0)

local a=1
foreach var of varlist study2_avg v1 v2 v6 v3 v5 v4{
reg `var' treatment_cit asiant asiant_treat if group1==1
mat results[`a',1] = _b[asiant_treat]
mat results[`a',2] = _se[asiant_treat]
mat results[`a',3] = `a'
local ++a
}
 
mat2txt, matrix(results) saving(fig1) replace 


*** TABLE C.1
*A few DVs are not between 0 and 1 (because recode was done before filtering on our white/asian respondents). Rescaled just for the purposes of the summary statistics to show the range.
g v1_2 = (v1-0.1666667)/(1-.1666667)
g v2_2 = (v2-0.1666667)/(1-.1666667)
g v5_2 = (v5-.077417 )/(.9269663 -.077417)

su study2_avg v1_2 v2_2 v6 v3 v5_2 v4 v8 timetask if group1==1
su white asiant female somecol col post years relig citizen2 ideo2 if group1==1


*** TABLE C.2
orth_out white asiant female somecol col post years relig citizen2 using balance if group1==1, by(treatment_cit) bdec(2) compare proportion test stars count replace


*** FOOTNOTE 22
gen citizen_dummy = citizen>1
gen treatment_cit_citizen = citizen_dummy*treatment_cit
reg study2_avg treatment_cit citizen_dummy treatment_cit_citizen if group1==1&asiant==1


*** FOOTNOTE 26
reg q262_3 treatment_cit asiant asiant_treat if group1==1


*** FOOTNOTE 27
pwcorr v1 v2 v6 v3 v5 v4 if group1==1, sig
