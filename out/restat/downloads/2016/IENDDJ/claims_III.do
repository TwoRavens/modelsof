********************************************************
********************************************************
**********Claims in III. The Priming Instrument*********
********************************************************
********************************************************

***FOOTNOTE 10
clear
set more off
insheet using "/Users/gwf25/Dropbox/research/religion/final code/OnlineQuests.txt"
drop if v1 == "ResponseID"
gen treatR = .
replace treatR = 1 if q5 ~= ""
replace treatR = 0 if q7 ~= ""
tab treatR

drop if classification1_1 == "" & id ~= 215

drop if treatR == .
count if treatR == 1
count if treatR == 0


tab classification1_1
replace classification1_1 = "Political orientation" if classification1_1 == "Political Orientation"
tab classification1_2
tab classification1_3

tab classification2_1
tab classification2_2
tab classification2_3

tab classification3_1
replace classification3_1 = "Sexual orientation" if classification3_1 == "sexual orientation"
tab classification3_2
tab classification3_3

tab classification4_1
replace classification4_1 = "Other" if classification4_1 == "other"
tab classification4_2
tab classification4_3

tab classification5_1
tab classification5_2
tab classification5_3

***RESULTS***

*RELIGION
generate religion = 0
replace religion = 1 if classification1_1 == "Religion, morality, and philosophy"
replace religion = 1 if classification1_2 == "Religion, morality, and philosophy"
replace religion = 1 if classification2_1 == "Religion, morality, and philosophy" 
replace religion = 1 if classification2_2 == "Religion, morality, and philosophy" 
replace religion = 1 if classification2_3 == "Religion, morality, and philosophy" 
replace religion = 1 if classification3_1 == "Religion, morality, and philosophy" 
replace religion = 1 if classification3_2 == "Religion, morality, and philosophy" 
replace religion = 1 if classification3_3 == "Religion, morality, and philosophy" 
replace religion = 1 if classification4_1 == "Religion, morality, and philosophy" 
replace religion = 1 if classification4_2 == "Religion, morality, and philosophy" 
replace religion = 1 if classification4_3 == "Religion, morality, and philosophy" 
replace religion = 1 if classification5_1 == "Religion, morality, and philosophy" 
replace religion = 1 if classification5_2 == "Religion, morality, and philosophy"

*by religion
*q19 asks about religion
*1 = christian-protestant
*2 = christian-catholic
*3 = christian other
*4 = jewish
*5 = muslim
*6 = buddhist
*7 = hindu
*8 = agnostic
*9 = atheist
*10 = other
rename q19 relig

count if treatR == 0 //903
count if treatR == 1 // 895

count if religion == 1 & treatR == 0 //227
count if religion == 1 & treatR == 1 //268

di 227/903
di 268/895

prtesti 903 .251 895 .299

*GENDER
generate gender = 0
replace gender = 1 if classification1_1 == "Gender"
replace gender = 1 if classification1_2 == "Gender"
replace gender = 1 if classification2_1 == "Gender"
replace gender = 1 if classification2_2 == "Gender"
replace gender = 1 if classification2_3 == "Gender"
replace gender = 1 if classification3_1 == "Gender"
replace gender = 1 if classification3_2 == "Gender"
replace gender = 1 if classification3_3 == "Gender"
replace gender = 1 if classification4_1 == "Gender"
replace gender = 1 if classification4_2 == "Gender"
replace gender = 1 if classification4_3 == "Gender"
replace gender = 1 if classification5_1 == "Gender"
replace gender = 1 if classification5_2 == "Gender"

count if gender == 1 & treatR == 0 //279
count if gender == 1 & treatR == 1 //252

di 279/903
di 252/895

prtesti 903 .309 895 .282

*Political Orientation
generate polo = 0
replace polo = 1 if classification1_1 == "Political orientation"
replace polo = 1 if classification1_2 == "Political orientation"
replace polo = 1 if classification2_1 == "Political orientation"
replace polo = 1 if classification2_2 == "Political orientation"
replace polo = 1 if classification2_3 == "Political orientation"
replace polo = 1 if classification3_1 == "Political orientation"
replace polo = 1 if classification3_2 == "Political orientation"
replace polo = 1 if classification3_3 == "Political orientation"
replace polo = 1 if classification4_1 == "Political orientation"
replace polo = 1 if classification4_2 == "Political orientation"
replace polo = 1 if classification4_3 == "Political orientation"
replace polo = 1 if classification5_1 == "Political orientation"
replace polo = 1 if classification5_2 == "Political orientation"

count if polo == 1 & treatR == 0 //90
count if polo == 1 & treatR == 1 //82

di 90/903
di 82/895

prtesti 903 .1 895 .092

*Professional interest/profession
generate profi = 0
replace profi = 1 if classification1_1 == "Professional interest/profession"
replace profi = 1 if classification1_2 == "Professional interest/profession"
replace profi = 1 if classification2_1 == "Professional interest/profession"
replace profi = 1 if classification2_2 == "Professional interest/profession"
replace profi = 1 if classification2_3 == "Professional interest/profession"
replace profi = 1 if classification3_1 == "Professional interest/profession"
replace profi = 1 if classification3_2 == "Professional interest/profession"
replace profi = 1 if classification3_3 == "Professional interest/profession"
replace profi = 1 if classification4_1 ==  "Professional interest/profession"
replace profi = 1 if classification4_2 == "Professional interest/profession"
replace profi = 1 if classification4_3 == "Professional interest/profession"
replace profi = 1 if classification5_1 == "Professional interest/profession"
replace profi = 1 if classification5_2 == "Professional interest/profession"

count if profi == 1 & treatR == 0 //274
count if profi == 1 & treatR == 1 //283

di 274/903
di 283/895

prtesti 903 .303 895 .316

*Athletics/sports
generate athl = 0
replace athl = 1 if classification1_1 == "Athletics/sports"
replace athl = 1 if classification1_2 == "Athletics/sports"
replace athl = 1 if classification2_1 == "Athletics/sports"
replace athl = 1 if classification2_2 == "Athletics/sports"
replace athl = 1 if classification2_3 == "Athletics/sports"
replace athl = 1 if classification3_1 == "Athletics/sports"
replace athl = 1 if classification3_2 == "Athletics/sports"
replace athl = 1 if classification3_3 == "Athletics/sports"
replace athl = 1 if classification4_1 ==  "Athletics/sports"
replace athl = 1 if classification4_2 == "Athletics/sports"
replace athl = 1 if classification4_3 == "Athletics/sports"
replace athl = 1 if classification5_1 == "Athletics/sports"
replace athl = 1 if classification5_2 == "Athletics/sports"

count if athl == 1 & treatR == 0 //135
count if athl == 1 & treatR == 1 //137

di 135/903
di 137/895

prtesti 903 .150 895 .153

*Non-spousal family relationship
generate nonsfrel= 0
replace nonsfrel = 1 if classification1_1 == "Non-spousal family relationship"
replace nonsfrel = 1 if classification1_2 == "Non-spousal family relationship"
replace nonsfrel = 1 if classification2_1 == "Non-spousal family relationship"
replace nonsfrel = 1 if classification2_2 == "Non-spousal family relationship"
replace nonsfrel = 1 if classification2_3 == "Non-spousal family relationship"
replace nonsfrel = 1 if classification3_1 == "Non-spousal family relationship"
replace nonsfrel = 1 if classification3_2 == "Non-spousal family relationship"
replace nonsfrel = 1 if classification3_3 == "Non-spousal family relationship"
replace nonsfrel = 1 if classification4_1 == "Non-spousal family relationship"
replace nonsfrel = 1 if classification4_2 == "Non-spousal family relationship"
replace nonsfrel = 1 if classification4_3 == "Non-spousal family relationship"
replace nonsfrel = 1 if classification5_1 == "Non-spousal family relationship"
replace nonsfrel = 1 if classification5_2 == "Non-spousal family relationship"

count if nonsfrel == 1 & treatR == 0 //426
count if nonsfrel == 1 & treatR == 1 //452

di 426/903
di 452/895

prtesti 903 .472 895 .505

*Socioeconomic class
generate sociocl= 0
replace sociocl = 1 if classification1_1 == "Socioeconomic class"
replace sociocl = 1 if classification1_2 == "Socioeconomic class"
replace sociocl = 1 if classification2_1 == "Socioeconomic class"
replace sociocl = 1 if classification2_2 == "Socioeconomic class"
replace sociocl = 1 if classification2_3 == "Socioeconomic class"
replace sociocl = 1 if classification3_1 == "Socioeconomic class"
replace sociocl = 1 if classification3_2 == "Socioeconomic class"
replace sociocl = 1 if classification3_3 == "Socioeconomic class"
replace sociocl = 1 if classification4_1 == "Socioeconomic class"
replace sociocl = 1 if classification4_2 == "Socioeconomic class"
replace sociocl = 1 if classification4_3 == "Socioeconomic class"
replace sociocl = 1 if classification5_1 == "Socioeconomic class"
replace sociocl = 1 if classification5_2 == "Socioeconomic class"

count if sociocl == 1 & treatR == 0 //34
count if sociocl == 1 & treatR == 1 //37

di 34/903
di 37/895

prtesti 903 .038 895 .041

*Nationality/ethnicity/race/language
generate nerl= 0
replace nerl = 1 if classification1_1 == "Nationality/ethnicity/race/language"
replace nerl = 1 if classification1_2 == "Nationality/ethnicity/race/language"
replace nerl = 1 if classification2_1 == "Nationality/ethnicity/race/language"
replace nerl = 1 if classification2_2 == "Nationality/ethnicity/race/language"
replace nerl = 1 if classification2_3 == "Nationality/ethnicity/race/language"
replace nerl = 1 if classification3_1 == "Nationality/ethnicity/race/language"
replace nerl = 1 if classification3_2 == "Nationality/ethnicity/race/language"
replace nerl = 1 if classification3_3 == "Nationality/ethnicity/race/language"
replace nerl = 1 if classification4_1 == "Nationality/ethnicity/race/language"
replace nerl = 1 if classification4_2 == "Nationality/ethnicity/race/language"
replace nerl = 1 if classification4_3 == "Nationality/ethnicity/race/language"
replace nerl = 1 if classification5_1 == "Nationality/ethnicity/race/language"
replace nerl = 1 if classification5_2 == "Nationality/ethnicity/race/language"

count if nerl == 1 & treatR == 0 //259
count if nerl == 1 & treatR == 1 //271

di 259/903
di 271/895

prtesti 903 .287 895 .303

*Student (e.g. Cornell, major, year in school)
generate stud = 0
replace stud = 1 if classification1_1 == "Student (e.g. Cornell, major, year in school)"
replace stud = 1 if classification1_2 == "Student (e.g. Cornell, major, year in school)"
replace stud = 1 if classification2_1 == "Student (e.g. Cornell, major, year in school)"
replace stud = 1 if classification2_2 == "Student (e.g. Cornell, major, year in school)"
replace stud = 1 if classification2_3 == "Student (e.g. Cornell, major, year in school)"
replace stud = 1 if classification3_1 == "Student (e.g. Cornell, major, year in school)"
replace stud = 1 if classification3_2 == "Student (e.g. Cornell, major, year in school)"
replace stud = 1 if classification3_3 == "Student (e.g. Cornell, major, year in school)"
replace stud = 1 if classification4_1 == "Student (e.g. Cornell, major, year in school)"
replace stud = 1 if classification4_2 == "Student (e.g. Cornell, major, year in school)"
replace stud = 1 if classification4_3 == "Student (e.g. Cornell, major, year in school)"
replace stud = 1 if classification5_1 == "Student (e.g. Cornell, major, year in school)"
replace stud = 1 if classification5_2 == "Student (e.g. Cornell, major, year in school)"

count if stud == 1 & treatR == 0 //224
count if stud == 1 & treatR == 1 //246

di 224/903
di 246/895

prtesti 903 .248 895 .275

*Pro-social personality trait
generate prospt = 0
replace prospt = 1 if classification1_1 == "Pro-social personality trait"
replace prospt = 1 if classification1_2 == "Pro-social personality trait"
replace prospt = 1 if classification2_1 == "Pro-social personality trait"
replace prospt = 1 if classification2_2 == "Pro-social personality trait"
replace prospt = 1 if classification2_3 == "Pro-social personality trait"
replace prospt = 1 if classification3_1 == "Pro-social personality trait"
replace prospt = 1 if classification3_2 == "Pro-social personality trait"
replace prospt = 1 if classification3_3 == "Pro-social personality trait"
replace prospt = 1 if classification4_1 == "Pro-social personality trait"
replace prospt = 1 if classification4_2 == "Pro-social personality trait"
replace prospt = 1 if classification4_3 == "Pro-social personality trait"
replace prospt = 1 if classification5_1 == "Pro-social personality trait"
replace prospt = 1 if classification5_2 == "Pro-social personality trait"

count if prospt == 1 & treatR == 0 //101
count if prospt == 1 & treatR == 1 //90

di 101/903
di 90/895

prtesti 903 .112 895 .101

*Human being
generate hubng = 0
replace hubng = 1 if classification1_1 == "Human being"
replace hubng = 1 if classification1_2 == "Human being"
replace hubng = 1 if classification2_1 == "Human being"
replace hubng = 1 if classification2_2 == "Human being"
replace hubng = 1 if classification2_3 == "Human being"
replace hubng = 1 if classification3_1 == "Human being"
replace hubng = 1 if classification3_2 == "Human being"
replace hubng = 1 if classification3_3 == "Human being"
replace hubng = 1 if classification4_1 == "Human being"
replace hubng = 1 if classification4_2 == "Human being"
replace hubng = 1 if classification4_3 == "Human being"
replace hubng = 1 if classification5_1 == "Human being"
replace hubng = 1 if classification5_2 == "Human being"

count if hubng == 1 & treatR == 0 //42
count if hubng == 1 & treatR == 1 //36

di 42/903
di 36/895

prtesti 903 .047 895 .040

*Mental feature/personality trait
generate menfpert = 0
replace menfpert = 1 if classification1_1 == "Mental feature/personality trait"
replace menfpert = 1 if classification1_2 == "Mental feature/personality trait"
replace menfpert = 1 if classification2_1 == "Mental feature/personality trait"
replace menfpert = 1 if classification2_2 == "Mental feature/personality trait"
replace menfpert = 1 if classification2_3 == "Mental feature/personality trait"
replace menfpert = 1 if classification3_1 == "Mental feature/personality trait"
replace menfpert = 1 if classification3_2 == "Mental feature/personality trait"
replace menfpert = 1 if classification3_3 == "Mental feature/personality trait"
replace menfpert = 1 if classification4_1 == "Mental feature/personality trait"
replace menfpert = 1 if classification4_2 == "Mental feature/personality trait"
replace menfpert = 1 if classification4_3 == "Mental feature/personality trait"
replace menfpert = 1 if classification5_1 == "Mental feature/personality trait"
replace menfpert = 1 if classification5_2 == "Mental feature/personality trait"

count if menfpert == 1 & treatR == 0 //206
count if menfpert == 1 & treatR == 1 //175

di 206/903
di 175/895

prtesti 903 .228 895 .196

*Non-professional interest/dislike/activity group/possession
generate npidagp = 0
replace npidagp = 1 if classification1_1 == "Non-professional interest/dislike/activity group/possession"
replace npidagp = 1 if classification1_2 == "Non-professional interest/dislike/activity group/possession"
replace npidagp = 1 if classification2_1 == "Non-professional interest/dislike/activity group/possession"
replace npidagp = 1 if classification2_2 == "Non-professional interest/dislike/activity group/possession"
replace npidagp = 1 if classification2_3 == "Non-professional interest/dislike/activity group/possession"
replace npidagp = 1 if classification3_1 == "Non-professional interest/dislike/activity group/possession"
replace npidagp = 1 if classification3_2 == "Non-professional interest/dislike/activity group/possession"
replace npidagp = 1 if classification3_3 == "Non-professional interest/dislike/activity group/possession"
replace npidagp = 1 if classification4_1 == "Non-professional interest/dislike/activity group/possession"
replace npidagp = 1 if classification4_2 == "Non-professional interest/dislike/activity group/possession"
replace npidagp = 1 if classification4_3 == "Non-professional interest/dislike/activity group/possession"
replace npidagp = 1 if classification5_1 == "Non-professional interest/dislike/activity group/possession"
replace npidagp = 1 if classification5_2 == "Non-professional interest/dislike/activity group/possession"

count if npidagp == 1 & treatR == 0 //222
count if npidagp == 1 & treatR == 1 //243

di 222/903
di 243/895

prtesti 903 .246 895 .272

*Non-family non-romantic relationship
generate nfnrr = 0
replace nfnrr = 1 if classification1_1 == "Non-family non-romantic relationship"
replace nfnrr = 1 if classification1_2 == "Non-family non-romantic relationship"
replace nfnrr = 1 if classification2_1 == "Non-family non-romantic relationship"
replace nfnrr = 1 if classification2_2 == "Non-family non-romantic relationship"
replace nfnrr = 1 if classification2_3 == "Non-family non-romantic relationship"
replace nfnrr = 1 if classification3_1 == "Non-family non-romantic relationship"
replace nfnrr = 1 if classification3_2 == "Non-family non-romantic relationship"
replace nfnrr = 1 if classification3_3 == "Non-family non-romantic relationship"
replace nfnrr = 1 if classification4_1 == "Non-family non-romantic relationship"
replace nfnrr = 1 if classification4_2 == "Non-family non-romantic relationship"
replace nfnrr = 1 if classification4_3 == "Non-family non-romantic relationship"
replace nfnrr = 1 if classification5_1 == "Non-family non-romantic relationship"
replace nfnrr = 1 if classification5_2 == "Non-family non-romantic relationship"

count if nfnrr == 1 & treatR == 0 //253
count if nfnrr == 1 & treatR == 1 //265

di 253/903
di 265/895

prtesti 903 .280 895 .296

*Age or age group
generate aoag = 0
replace aoag = 1 if classification1_1 == "Age or age group"
replace aoag = 1 if classification1_2 == "Age or age group"
replace aoag = 1 if classification2_1 == "Age or age group"
replace aoag = 1 if classification2_2 == "Age or age group"
replace aoag = 1 if classification2_3 == "Age or age group"
replace aoag = 1 if classification3_1 == "Age or age group"
replace aoag = 1 if classification3_2 == "Age or age group"
replace aoag = 1 if classification3_3 == "Age or age group"
replace aoag = 1 if classification4_1 == "Age or age group"
replace aoag = 1 if classification4_2 == "Age or age group"
replace aoag = 1 if classification4_3 == "Age or age group"
replace aoag = 1 if classification5_1 == "Age or age group"
replace aoag = 1 if classification5_2 == "Age or age group"

count if aoag == 1 & treatR == 0 //110
count if aoag == 1 & treatR == 1 //76

di 110/903
di 76/895

prtesti 903 .122 895 .085

*split of age or age group by religious affiliation

*Protestant
*drop those who aren't protestant in the other christian category
replace relig = "." if relig == "3" & q20 == "Christian-Orthodox"
replace relig = "." if relig == "3" & q20 == "my business"
replace relig = "." if relig == "3" & q20 == "orthodoxy"
replace relig = "." if relig == "3" & q20 == "LDS/Mormon"
replace relig = "." if relig == "3" & q20 == "Jehovah's Witness :)"
replace relig = "." if relig == "3" & q20 == "Orthodox"
replace relig = "." if relig == "3" & q20 == "I don't affiliate with any church"
replace relig = "." if relig == "3" & q20 == "Jehovah's Witness"
replace relig = "." if relig == "3" & q20 == "I see myself as a Christian however I draw spiritual inspiration from many religious traditions"
replace relig = "." if relig == "3" & q20 == "Unity School of Christianity"
replace relig = "." if relig == "3" & q20 == "Greek Orthodox"
replace relig = "." if relig == "3" & q20 == "Spiritual"
replace relig = "." if relig == "3" & q20 == "independent"
replace relig = "." if relig == "3" & q20 == "none"
replace relig = "." if relig == "3" & q20 == "unity/new age"
replace relig = "." if relig == "3" & q20 == "afro-christian called UMBANDA"
replace relig = "." if relig == "3" & q20 == "no group or religion"
replace relig = "." if relig == "3" & q20 == "LDS"
replace relig = "." if relig == "3" & q20 == "Christian nature lover"
replace relig = "." if relig == "3" & q20 == "Believer but not praticing"
replace relig = "." if relig == "3" & q20 == "Spirtulist"
replace relig = "." if relig == "3" & q20 == "Greek Orthodox"
replace relig = "." if relig == "3" & q20 == "Kardecist Spiritism"
replace relig = "." if relig == "3" & q20 == "latter-day saint (Mormon)"
replace relig = "." if relig == "3" & q20 == "Coptic, Orthodox"
replace relig = "." if relig == "3" & q20 == "I believe in God, and I pray but I don't follow any kind of organized church, nor do I profess my beliefs."
replace relig = "." if relig == "3" & q20 == "Jehovah's Witness"
replace relig = "." if relig == "3" & q20 == "Greek Orthodox"
replace relig = "." if relig == "3" & q20 == "Orthdox"
replace relig = "." if relig == "3" & q20 == "lds"
replace relig = "." if relig == "3" & q20 == "Messianic Judiasm"
replace relig = "." if relig == "3" & q20 == "I am Orthodox Christian"
replace relig = "." if relig == "3" & q20 == "Coptic Orthodox Christian"
replace relig = "." if relig == "3" & q20 == "not very religious"
replace relig = "." if relig == "3" & q20 == "latter day saints"
replace relig = "." if relig == "3" & q20 == "LDS"
replace relig = "." if relig == "3" & q20 == "Orthodox"
replace relig = "." if relig == "3" & q20 == "Latter Day Saint"
replace relig = "." if relig == "3" & q20 == "Jehovah's Witness"
replace relig = "." if relig == "3" & q20 == "I love jesus and god but religion is a scam and has not contributed anything to humanity."
replace relig = "." if relig == "3" & q20 == "LDS"
replace relig = "." if relig == "3" & q20 == "Jehovah's Witnesses"
replace relig = "." if relig == "3" & q20 == "Jehovah's Witness"
replace relig = "." if relig == "3" & q20 == "Jehovah's Witnesses"
replace relig = "." if relig == "3" & q20 == "The Church of Jesus Christ of Latter-day Saints"

count if relig == "3" & treatR == 0 //83
count if relig == "3" & treatR == 1 //93
count if relig == "1" & treatR == 0 //156
count if relig == "1" & treatR == 1 //178

count if aoag == 1 & relig == "3" & treatR == 0 //7
count if aoag == 1 & relig == "3" & treatR == 1 //5
count if aoag == 1 & relig == "1" & treatR == 0 //16
count if aoag == 1 & relig == "1" & treatR == 1 //13

di (7+16)/(83+156) //23,239, =.096
di (5+13)/(93+178) //18,271, =.066

prtesti 239 .096 271 .066

*Catholic
count if relig == "2" & treatR == 0 //176
count if relig == "2" & treatR == 1 //138

count if aoag == 1 & relig == "2" & treatR == 0 //12
count if aoag == 1 & relig == "2" & treatR == 1 //12

di 12/176 //.068
di 12/138 //.087

prtesti 176 .068 138 .087

*Jewish
count if relig == "4" & treatR == 0 //43
count if relig == "4" & treatR == 1 //46

count if aoag == 1 & relig == "4" & treatR == 0 //9
count if aoag == 1 & relig == "4" & treatR == 1 //5

di 9/43 //.209
di 5/46 //.109

prtesti 43 .209 46 .109

*Agnostic/Atheist
count if relig == "8" & treatR == 0 //150
count if relig == "8" & treatR == 1 //126
count if relig == "9" & treatR == 0 //150
count if relig == "9" & treatR == 1 //144

count if aoag == 1 & relig == "8" & treatR == 0 //30
count if aoag == 1 & relig == "8" & treatR == 1 //7
count if aoag == 1 & relig == "9" & treatR == 0 //19
count if aoag == 1 & relig == "9" & treatR == 1 //14

di (30+19)/(150+150) //49,300, =.163
di (7+14)/(126+144) //21,270, =.078

prtesti 300 .163 270 .078

*Arts in general (visual art, music, theater, cinema, literature, etc.)
generate aig = 0
replace aig = 1 if classification1_1 == "Arts in general (visual art, music, theater, cinema, literature, etc.)"
replace aig = 1 if classification1_2 == "Arts in general (visual art, music, theater, cinema, literature, etc.)"
replace aig = 1 if classification2_1 == "Arts in general (visual art, music, theater, cinema, literature, etc.)"
replace aig = 1 if classification2_2 == "Arts in general (visual art, music, theater, cinema, literature, etc.)"
replace aig = 1 if classification2_3 == "Arts in general (visual art, music, theater, cinema, literature, etc.)"
replace aig = 1 if classification3_1 == "Arts in general (visual art, music, theater, cinema, literature, etc.)"
replace aig = 1 if classification3_2 == "Arts in general (visual art, music, theater, cinema, literature, etc.)"
replace aig = 1 if classification3_3 == "Arts in general (visual art, music, theater, cinema, literature, etc.)"
replace aig = 1 if classification4_1 == "Arts in general (visual art, music, theater, cinema, literature, etc.)"
replace aig = 1 if classification4_2 == "Arts in general (visual art, music, theater, cinema, literature, etc.)"
replace aig = 1 if classification4_3 == "Arts in general (visual art, music, theater, cinema, literature, etc.)"
replace aig = 1 if classification5_1 == "Arts in general (visual art, music, theater, cinema, literature, etc.)"
replace aig = 1 if classification5_2 == "Arts in general (visual art, music, theater, cinema, literature, etc.)"

count if aig == 1 & treatR == 0 //155
count if aig == 1 & treatR == 1 //150

di 155/903
di 150/895

prtesti 903 .172 895 .168

*Other
generate other = 0
replace other = 1 if classification1_1 == "Other"
replace other = 1 if classification1_2 == "Other"
replace other = 1 if classification2_1 == "Other"
replace other = 1 if classification2_2 == "Other"
replace other = 1 if classification2_3 == "Other"
replace other = 1 if classification3_1 == "Other"
replace other = 1 if classification3_2 == "Other"
replace other = 1 if classification3_3 == "Other"
replace other = 1 if classification4_1 == "Other"
replace other = 1 if classification4_2 == "Other"
replace other = 1 if classification4_3 == "Other"
replace other = 1 if classification5_1 == "Other"
replace other = 1 if classification5_2 == "Other"

count if other == 1 & treatR == 0 //30
count if other == 1 & treatR == 1 //23

di 30/903
di 23/895

prtesti 903 .033 895 .026

*Sexual orientation
generate sexor = 0
replace sexor = 1 if classification1_1 == "Sexual orientation"
replace sexor = 1 if classification1_2 == "Sexual orientation"
replace sexor = 1 if classification2_1 == "Sexual orientation"
replace sexor = 1 if classification2_2 == "Sexual orientation"
replace sexor = 1 if classification2_3 == "Sexual orientation"
replace sexor = 1 if classification3_1 == "Sexual orientation"
replace sexor = 1 if classification3_2 == "Sexual orientation"
replace sexor = 1 if classification3_3 == "Sexual orientation"
replace sexor = 1 if classification4_1 == "Sexual orientation"
replace sexor = 1 if classification4_2 == "Sexual orientation"
replace sexor = 1 if classification4_3 == "Sexual orientation"
replace sexor = 1 if classification5_1 == "Sexual orientation"
replace sexor = 1 if classification5_2 == "Sexual orientation"

count if sexor == 1 & treatR == 0 //39
count if sexor == 1 & treatR == 1 //41

di 39/903
di 41/895

prtesti 903 .043 895 .046

*Food and drink (excluding beer and liquor)
generate fad = 0
replace fad = 1 if classification1_1 == "Food and drink (excluding beer and liquor)"
replace fad = 1 if classification1_2 == "Food and drink (excluding beer and liquor)"
replace fad = 1 if classification2_1 == "Food and drink (excluding beer and liquor)"
replace fad = 1 if classification2_2 == "Food and drink (excluding beer and liquor)"
replace fad = 1 if classification2_3 == "Food and drink (excluding beer and liquor)"
replace fad = 1 if classification3_1 == "Food and drink (excluding beer and liquor)"
replace fad = 1 if classification3_2 == "Food and drink (excluding beer and liquor)"
replace fad = 1 if classification3_3 == "Food and drink (excluding beer and liquor)"
replace fad = 1 if classification4_1 == "Food and drink (excluding beer and liquor)"
replace fad = 1 if classification4_2 == "Food and drink (excluding beer and liquor)"
replace fad = 1 if classification4_3 == "Food and drink (excluding beer and liquor)"
replace fad = 1 if classification5_1 == "Food and drink (excluding beer and liquor)"
replace fad = 1 if classification5_2 == "Food and drink (excluding beer and liquor)"

count if fad == 1 & treatR == 0 //32
count if fad == 1 & treatR == 1 //24

di 32/903
di 24/895

prtesti 903 .035 895 .027

*Romantic relationship/status
generate romrels = 0
replace romrels = 1 if classification1_1 == "Romantic relationship/status"
replace romrels = 1 if classification1_2 == "Romantic relationship/status"
replace romrels = 1 if classification2_1 == "Romantic relationship/status"
replace romrels = 1 if classification2_2 == "Romantic relationship/status"
replace romrels = 1 if classification2_3 == "Romantic relationship/status"
replace romrels = 1 if classification3_1 == "Romantic relationship/status"
replace romrels = 1 if classification3_2 == "Romantic relationship/status"
replace romrels = 1 if classification3_3 == "Romantic relationship/status"
replace romrels = 1 if classification4_1 == "Romantic relationship/status"
replace romrels = 1 if classification4_2 == "Romantic relationship/status"
replace romrels = 1 if classification4_3 == "Romantic relationship/status"
replace romrels = 1 if classification5_1 == "Romantic relationship/status"
replace romrels = 1 if classification5_2 == "Romantic relationship/status"

count if romrels == 1 & treatR == 0 //133
count if romrels == 1 & treatR == 1 //128

di 133/903
di 128/895

prtesti 903 .147 895 .143

*Birthplace/hometown/place of residence
generate bhpor = 0
replace bhpor = 1 if classification1_1 == "Birthplace/hometown/place of residence"
replace bhpor = 1 if classification1_2 == "Birthplace/hometown/place of residence"
replace bhpor = 1 if classification2_1 == "Birthplace/hometown/place of residence"
replace bhpor = 1 if classification2_2 == "Birthplace/hometown/place of residence"
replace bhpor = 1 if classification2_3 == "Birthplace/hometown/place of residence"
replace bhpor = 1 if classification3_1 == "Birthplace/hometown/place of residence"
replace bhpor = 1 if classification3_2 == "Birthplace/hometown/place of residence"
replace bhpor = 1 if classification3_3 == "Birthplace/hometown/place of residence"
replace bhpor = 1 if classification4_1 == "Birthplace/hometown/place of residence"
replace bhpor = 1 if classification4_2 == "Birthplace/hometown/place of residence"
replace bhpor = 1 if classification4_3 == "Birthplace/hometown/place of residence"
replace bhpor = 1 if classification5_1 == "Birthplace/hometown/place of residence"
replace bhpor = 1 if classification5_2 == "Birthplace/hometown/place of residence"

count if bhpor == 1 & treatR == 0 //101
count if bhpor == 1 & treatR == 1 //103

di 101/903
di 103/895

prtesti 903 .112 895 .115

*Physical feature
generate physft = 0
replace physft = 1 if classification1_1 == "Physical feature"
replace physft = 1 if classification1_2 == "Physical feature"
replace physft = 1 if classification2_1 == "Physical feature"
replace physft = 1 if classification2_2 == "Physical feature"
replace physft = 1 if classification2_3 == "Physical feature"
replace physft = 1 if classification3_1 == "Physical feature"
replace physft = 1 if classification3_2 == "Physical feature"
replace physft = 1 if classification3_3 == "Physical feature"
replace physft = 1 if classification4_1 == "Physical feature"
replace physft = 1 if classification4_2 == "Physical feature"
replace physft = 1 if classification4_3 == "Physical feature"
replace physft = 1 if classification5_1 == "Physical feature"
replace physft = 1 if classification5_2 == "Physical feature"

count if physft == 1 & treatR == 0 //36
count if physft == 1 & treatR == 1 //25

di 36/903
di 25/895

prtesti 903 .040 895 .028

*Environmentalism
generate envtm = 0
replace envtm = 1 if classification1_1 == "Environmentalism"
replace envtm = 1 if classification1_2 == "Environmentalism"
replace envtm = 1 if classification2_1 == "Environmentalism"
replace envtm = 1 if classification2_2 == "Environmentalism"
replace envtm = 1 if classification2_3 == "Environmentalism"
replace envtm = 1 if classification3_1 == "Environmentalism"
replace envtm = 1 if classification3_2 == "Environmentalism"
replace envtm = 1 if classification3_3 == "Environmentalism"
replace envtm = 1 if classification4_1 == "Environmentalism"
replace envtm = 1 if classification4_2 == "Environmentalism"
replace envtm = 1 if classification4_3 == "Environmentalism"
replace envtm = 1 if classification5_1 == "Environmentalism"
replace envtm = 1 if classification5_2 == "Environmentalism"

count if envtm == 1 & treatR == 0 //19
count if envtm == 1 & treatR == 1 //14

di 19/903
di 14/895

prtesti 903 .021 895 .016

*Leisure travel
generate lestrvl = 0
replace lestrvl = 1 if classification1_1 == "Leisure travel"
replace lestrvl = 1 if classification1_2 == "Leisure travel"
replace lestrvl = 1 if classification2_1 == "Leisure travel"
replace lestrvl = 1 if classification2_2 == "Leisure travel"
replace lestrvl = 1 if classification2_3 == "Leisure travel"
replace lestrvl = 1 if classification3_1 == "Leisure travel"
replace lestrvl = 1 if classification3_2 == "Leisure travel"
replace lestrvl = 1 if classification3_3 == "Leisure travel"
replace lestrvl = 1 if classification4_1 == "Leisure travel"
replace lestrvl = 1 if classification4_2 == "Leisure travel"
replace lestrvl = 1 if classification4_3 == "Leisure travel"
replace lestrvl = 1 if classification5_1 == "Leisure travel"
replace lestrvl = 1 if classification5_2 == "Leisure travel"

count if lestrvl == 1 & treatR == 0 //13
count if lestrvl == 1 & treatR == 1 //14

di 13/903
di 14/895

prtesti 903 .014 895 .016

*Specific work of non-religious art or artist
generate swonraoa = 0
replace swonraoa = 1 if classification1_1 == "Specific work of non-religious art or artist"
replace swonraoa = 1 if classification1_2 == "Specific work of non-religious art or artist"
replace swonraoa = 1 if classification2_1 == "Specific work of non-religious art or artist"
replace swonraoa = 1 if classification2_2 == "Specific work of non-religious art or artist"
replace swonraoa = 1 if classification2_3 == "Specific work of non-religious art or artist"
replace swonraoa = 1 if classification3_1 == "Specific work of non-religious art or artist"
replace swonraoa = 1 if classification3_2 == "Specific work of non-religious art or artist"
replace swonraoa = 1 if classification3_3 == "Specific work of non-religious art or artist"
replace swonraoa = 1 if classification4_1 == "Specific work of non-religious art or artist"
replace swonraoa = 1 if classification4_2 == "Specific work of non-religious art or artist"
replace swonraoa = 1 if classification4_3 == "Specific work of non-religious art or artist"
replace swonraoa = 1 if classification5_1 == "Specific work of non-religious art or artist"
replace swonraoa = 1 if classification5_2 == "Specific work of non-religious art or artist"

count if swonraoa == 1 & treatR == 0 //11
count if swonraoa == 1 & treatR == 1 //11

di 11/903
di 11/895

prtesti 903 .012 895 .012

*Partying/nightclubs/bars (including beer and liquor)
generate pnbibal = 0
replace pnbibal = 1 if classification1_1 == "Partying/nightclubs/bars (including beer and liquor)"
replace pnbibal = 1 if classification1_2 == "Partying/nightclubs/bars (including beer and liquor)"
replace pnbibal = 1 if classification2_1 == "Partying/nightclubs/bars (including beer and liquor)"
replace pnbibal = 1 if classification2_2 == "Partying/nightclubs/bars (including beer and liquor)"
replace pnbibal = 1 if classification2_3 == "Partying/nightclubs/bars (including beer and liquor)"
replace pnbibal = 1 if classification3_1 == "Partying/nightclubs/bars (including beer and liquor)"
replace pnbibal = 1 if classification3_2 == "Partying/nightclubs/bars (including beer and liquor)"
replace pnbibal = 1 if classification3_3 == "Partying/nightclubs/bars (including beer and liquor)"
replace pnbibal = 1 if classification4_1 == "Partying/nightclubs/bars (including beer and liquor)"
replace pnbibal = 1 if classification4_2 == "Partying/nightclubs/bars (including beer and liquor)"
replace pnbibal = 1 if classification4_3 == "Partying/nightclubs/bars (including beer and liquor)"
replace pnbibal = 1 if classification5_1 == "Partying/nightclubs/bars (including beer and liquor)"
replace pnbibal = 1 if classification5_2 == "Partying/nightclubs/bars (including beer and liquor)"

count if pnbibal == 1 & treatR == 0 //6
count if pnbibal == 1 & treatR == 1 //14

di 6/903
di 14/895

prtesti 903 .007 895 .016

**FOOTNOTE 11
clear
set more off
insheet using "/Users/gwf25/Dropbox/research/religion/final code/OnlineQuests.txt"
drop if v1 == "ResponseID"
gen treatR = .
replace treatR = 1 if q5 ~= ""
replace treatR = 0 if q7 ~= ""
tab treatR

drop if classification1_1 == "" & id ~= 215

drop if treatR == .
count if treatR == 1
count if treatR == 0


tab classification1_1
replace classification1_1 = "Political orientation" if classification1_1 == "Political Orientation"
tab classification1_2
tab classification1_3

tab classification2_1
tab classification2_2
tab classification2_3

tab classification3_1
replace classification3_1 = "Sexual orientation" if classification3_1 == "sexual orientation"
tab classification3_2
tab classification3_3

tab classification4_1
replace classification4_1 = "Other" if classification4_1 == "other"
tab classification4_2
tab classification4_3

tab classification5_1
tab classification5_2
tab classification5_3

generate religion = 0
replace religion = 1 if classification1_1 == "Religion, morality, and philosophy"
replace religion = 1 if classification1_2 == "Religion, morality, and philosophy"
replace religion = 1 if classification2_1 == "Religion, morality, and philosophy" 
replace religion = 1 if classification2_2 == "Religion, morality, and philosophy" 
replace religion = 1 if classification2_3 == "Religion, morality, and philosophy" 
replace religion = 1 if classification3_1 == "Religion, morality, and philosophy" 
replace religion = 1 if classification3_2 == "Religion, morality, and philosophy" 
replace religion = 1 if classification3_3 == "Religion, morality, and philosophy" 
replace religion = 1 if classification4_1 == "Religion, morality, and philosophy" 
replace religion = 1 if classification4_2 == "Religion, morality, and philosophy" 
replace religion = 1 if classification4_3 == "Religion, morality, and philosophy" 
replace religion = 1 if classification5_1 == "Religion, morality, and philosophy" 
replace religion = 1 if classification5_2 == "Religion, morality, and philosophy"

gen religionO = 6
replace religionO = 1 if classification1_1 == "Religion, morality, and philosophy"
replace religionO = 1 if classification1_2 == "Religion, morality, and philosophy"
replace religionO = 2 if classification2_1 == "Religion, morality, and philosophy" 
replace religionO = 2 if classification2_2 == "Religion, morality, and philosophy" 
replace religionO = 2 if classification2_3 == "Religion, morality, and philosophy" 
replace religionO = 3 if classification3_1 == "Religion, morality, and philosophy" 
replace religionO = 3 if classification3_2 == "Religion, morality, and philosophy" 
replace religionO = 3 if classification3_3 == "Religion, morality, and philosophy" 
replace religionO = 4 if classification4_1 == "Religion, morality, and philosophy" 
replace religionO = 4 if classification4_2 == "Religion, morality, and philosophy" 
replace religionO = 4 if classification4_3 == "Religion, morality, and philosophy" 
replace religionO = 5 if classification5_1 == "Religion, morality, and philosophy" 
replace religionO = 5 if classification5_2 == "Religion, morality, and philosophy"

tobit religionO treatR, ul

*Pooling Catholics and Protestants together, the priming effect is significant at the 5 percent level (p = 0.017).
di (27+71+46)/(83+156+176) //144,415, =.347 control
di (40+89+46)/(93+178+138) //175,409, =.428 treatment

prtesti 415 .347 409 .428

*CHI-SQUARE TEST online experiment
clear
set more off
insheet using "/Users/gwf25/Dropbox/research/religion/final code/OnlineQuests.txt"
drop if v1 == "ResponseID"
gen treatR = .
replace treatR = 1 if q5 ~= ""
replace treatR = 0 if q7 ~= ""
tab treatR

drop if classification1_1 == "" & id ~= 215

drop if treatR == .
count if treatR == 1
count if treatR == 0


tab classification1_1
replace classification1_1 = "Political orientation" if classification1_1 == "Political Orientation"
tab classification1_2
tab classification1_3

tab classification2_1
tab classification2_2
tab classification2_3

tab classification3_1
replace classification3_1 = "Sexual orientation" if classification3_1 == "sexual orientation"
tab classification3_2
tab classification3_3

tab classification4_1
replace classification4_1 = "Other" if classification4_1 == "other"
tab classification4_2
tab classification4_3

tab classification5_1
tab classification5_2
tab classification5_3

***RESULTS***

*RELIGION
generate religion = 0
replace religion = 1 if classification1_1 == "Religion, morality, and philosophy"
replace religion = 1 if classification1_2 == "Religion, morality, and philosophy"
replace religion = 1 if classification2_1 == "Religion, morality, and philosophy" 
replace religion = 1 if classification2_2 == "Religion, morality, and philosophy" 
replace religion = 1 if classification2_3 == "Religion, morality, and philosophy" 
replace religion = 1 if classification3_1 == "Religion, morality, and philosophy" 
replace religion = 1 if classification3_2 == "Religion, morality, and philosophy" 
replace religion = 1 if classification3_3 == "Religion, morality, and philosophy" 
replace religion = 1 if classification4_1 == "Religion, morality, and philosophy" 
replace religion = 1 if classification4_2 == "Religion, morality, and philosophy" 
replace religion = 1 if classification4_3 == "Religion, morality, and philosophy" 
replace religion = 1 if classification5_1 == "Religion, morality, and philosophy" 
replace religion = 1 if classification5_2 == "Religion, morality, and philosophy"

*by religion
*q19 asks about religion
*1 = christian-protestant
*2 = christian-catholic
*3 = christian other
*4 = jewish
*5 = muslim
*6 = buddhist
*7 = hindu
*8 = agnostic
*9 = atheist
*10 = other
rename q19 relig

*drop those who aren't protestant in the other christian category
replace relig = "." if relig == "3" & q20 == "Christian-Orthodox"
replace relig = "." if relig == "3" & q20 == "my business"
replace relig = "." if relig == "3" & q20 == "orthodoxy"
replace relig = "." if relig == "3" & q20 == "LDS/Mormon"
replace relig = "." if relig == "3" & q20 == "Jehovah's Witness :)"
replace relig = "." if relig == "3" & q20 == "Orthodox"
replace relig = "." if relig == "3" & q20 == "I don't affiliate with any church"
replace relig = "." if relig == "3" & q20 == "Jehovah's Witness"
replace relig = "." if relig == "3" & q20 == "I see myself as a Christian however I draw spiritual inspiration from many religious traditions"
replace relig = "." if relig == "3" & q20 == "Unity School of Christianity"
replace relig = "." if relig == "3" & q20 == "Greek Orthodox"
replace relig = "." if relig == "3" & q20 == "Spiritual"
replace relig = "." if relig == "3" & q20 == "independent"
replace relig = "." if relig == "3" & q20 == "none"
replace relig = "." if relig == "3" & q20 == "unity/new age"
replace relig = "." if relig == "3" & q20 == "afro-christian called UMBANDA"
replace relig = "." if relig == "3" & q20 == "no group or religion"
replace relig = "." if relig == "3" & q20 == "LDS"
replace relig = "." if relig == "3" & q20 == "Christian nature lover"
replace relig = "." if relig == "3" & q20 == "Believer but not praticing"
replace relig = "." if relig == "3" & q20 == "Spirtulist"
replace relig = "." if relig == "3" & q20 == "Greek Orthodox"
replace relig = "." if relig == "3" & q20 == "Kardecist Spiritism"
replace relig = "." if relig == "3" & q20 == "latter-day saint (Mormon)"
replace relig = "." if relig == "3" & q20 == "Coptic, Orthodox"
replace relig = "." if relig == "3" & q20 == "I believe in God, and I pray but I don't follow any kind of organized church, nor do I profess my beliefs."
replace relig = "." if relig == "3" & q20 == "Jehovah's Witness"
replace relig = "." if relig == "3" & q20 == "Greek Orthodox"
replace relig = "." if relig == "3" & q20 == "Orthdox"
replace relig = "." if relig == "3" & q20 == "lds"
replace relig = "." if relig == "3" & q20 == "Messianic Judiasm"
replace relig = "." if relig == "3" & q20 == "I am Orthodox Christian"
replace relig = "." if relig == "3" & q20 == "Coptic Orthodox Christian"
replace relig = "." if relig == "3" & q20 == "not very religious"
replace relig = "." if relig == "3" & q20 == "latter day saints"
replace relig = "." if relig == "3" & q20 == "LDS"
replace relig = "." if relig == "3" & q20 == "Orthodox"
replace relig = "." if relig == "3" & q20 == "Latter Day Saint"
replace relig = "." if relig == "3" & q20 == "Jehovah's Witness"
replace relig = "." if relig == "3" & q20 == "I love jesus and god but religion is a scam and has not contributed anything to humanity."
replace relig = "." if relig == "3" & q20 == "LDS"
replace relig = "." if relig == "3" & q20 == "Jehovah's Witnesses"
replace relig = "." if relig == "3" & q20 == "Jehovah's Witness"
replace relig = "." if relig == "3" & q20 == "Jehovah's Witnesses"
replace relig = "." if relig == "3" & q20 == "The Church of Jesus Christ of Latter-day Saints"

gen religt = "other"
replace religt = "prot" if relig == "3" | relig == "1"
replace religt = "catholic" if relig == "2"
replace religt = "jewish" if relig == "4"
replace religt = "ath/agno" if relig == "8" | relig == "9"

tabulate treatR religt, chi2

*CHI-SQUARE TEST main results

clear all
set mem 30m

use "/Users/gwf25/Dropbox/research/religion/final code/religion_all.dta"

//  Begin definition of variables

***Drop subjects who thought the experiment was about religion
gen id = _n
drop if id == 98 | id == 176 | id == 194 | id == 383

***Drop subjects who incorrectly completed the priming task. This includes subjects who leave more than half the responses blank. The following subjects
***all left at least questions #2-#7 blank in the sentence unscrambling task. 
drop if id==7 | id==719 | id==740 | id==762 | id==940

***An error led to some subjects seeing both the control and religion salient sentence unscrambling tasks. Here, we drop those subjects.
drop if prime_diff == 1

***"skipped" is a dummy variable for whether subjects skip the question that asks their religion. If they skip this question, we drop them from the sample 
***and if not, we assign a dummy variable to indicate the treatment group (religion salient or control) that subject belongs to.
gen skipped=0
replace skipped=1 if  s10q15==""
gen treatR=.
replace treatR=religion if skipped==0
drop if skipped==1

***Define religion
gen relig=5

***Note: 1 = protestant or other christian, 2 = catholic, 3 = jewish, 4 = agnostic/atheist
replace relig=1 if (s10q15=="Christian - Other (please specify below)" | s10q15=="Christian - Protestant (please specify denomination below)")
replace relig=2 if s10q15=="Christian - Catholic"
replace relig=3 if s10q15=="Jewish (Orthodox/Reformed/etc.)" | s10q15=="Jewish (Orthodox/Reform/etc.)"
replace relig=4 if (s10q15=="Agnostic" | s10q15=="Atheist")

***Drop Mormon/Othodox Christians from the sample
replace relig = 5 if s10q15sp == "Greek Orthodox"
replace relig = 5 if s10q15sp == "Russian Othrodox"
replace relig = 5 if s10q15sp == "greek orthodox"
replace relig = 5 if s10q15sp == "Orthodox Christian"
replace relig = 5 if s10q15sp == "Greek Orthdox"
replace relig = 5 if s10q15sp == "christian orthodox"
replace relig = 5 if s10q15sp == "Greek Orthodox Christian"
replace relig = 5 if s10q15sp == "Russian orthodox"
replace relig = 5 if s10q15sp == "Church of Jesus Christ of Latter Day Saints"
replace relig = 5 if s10q15sp == "Greek Orthodox"

// End of variables

tabulate treatR relig, chi2

*REJECTION OF IDENTITY NORMS
clear
set more off
insheet using "/Users/gwf25/Dropbox/research/religion/final code/OnlineQuests.txt"
drop if v1 == "ResponseID"
gen treatR = .
replace treatR = 1 if q5 ~= ""
replace treatR = 0 if q7 ~= ""
tab treatR

drop if classification1_1 == "" & id ~= 215

drop if treatR == .
count if treatR == 1
count if treatR == 0


tab classification1_1
replace classification1_1 = "Political orientation" if classification1_1 == "Political Orientation"
tab classification1_2
tab classification1_3

tab classification2_1
tab classification2_2
tab classification2_3

tab classification3_1
replace classification3_1 = "Sexual orientation" if classification3_1 == "sexual orientation"
tab classification3_2
tab classification3_3

tab classification4_1
replace classification4_1 = "Other" if classification4_1 == "other"
tab classification4_2
tab classification4_3

tab classification5_1
tab classification5_2
tab classification5_3

***RESULTS***

*RELIGION
generate religion = 0
replace religion = 1 if classification1_1 == "Religion, morality, and philosophy"
replace religion = 1 if classification1_2 == "Religion, morality, and philosophy"
replace religion = 1 if classification2_1 == "Religion, morality, and philosophy" 
replace religion = 1 if classification2_2 == "Religion, morality, and philosophy" 
replace religion = 1 if classification2_3 == "Religion, morality, and philosophy" 
replace religion = 1 if classification3_1 == "Religion, morality, and philosophy" 
replace religion = 1 if classification3_2 == "Religion, morality, and philosophy" 
replace religion = 1 if classification3_3 == "Religion, morality, and philosophy" 
replace religion = 1 if classification4_1 == "Religion, morality, and philosophy" 
replace religion = 1 if classification4_2 == "Religion, morality, and philosophy" 
replace religion = 1 if classification4_3 == "Religion, morality, and philosophy" 
replace religion = 1 if classification5_1 == "Religion, morality, and philosophy" 
replace religion = 1 if classification5_2 == "Religion, morality, and philosophy"

*by religion
*q19 asks about religion
*1 = christian-protestant
*2 = christian-catholic
*3 = christian other
*4 = jewish
*5 = muslim
*6 = buddhist
*7 = hindu
*8 = agnostic
*9 = atheist
*10 = other
rename q19 relig

gen rejRel = 0
replace rejRel = 1 if q152_1_1_text == "Woman, American, Christian, Southerner"replace rejRel = 1 if q152_1_1_text == "The Catholic Church"replace rejRel = 1 if q152_1_1_text == "spiritual"replace rejRel = 1 if q152_1_1_text == "Some sectors of the Jewish & New Haven communities"replace rejRel = 1 if q152_1_1_text == "republicans, catholics, misogynists"replace rejRel = 1 if q152_1_1_text == "religious groups"replace rejRel = 1 if q152_1_1_text == "religious group, special needs group"replace rejRel = 1 if q152_1_1_text == "Religious community"replace rejRel = 1 if q152_1_1_text == "religious"replace rejRel = 1 if q152_1_1_text == "religion"replace rejRel = 1 if q152_1_1_text == "Religion"replace rejRel = 1 if q152_1_1_text == "religion"replace rejRel = 1 if q152_1_1_text == "Non religious group / American group / Jeep owners group"replace rejRel = 1 if q152_1_1_text == "my religious group, family, and work"replace rejRel = 1 if q152_1_1_text == "my Jewish community, friend group, Yale undergrads"replace rejRel = 1 if q152_1_1_text == "Muslims, Asians, Blacks"replace rejRel = 1 if q152_1_1_text == "Judaism (some); college student"replace rejRel = 1 if q152_1_1_text == "Judaism"replace rejRel = 1 if q152_1_1_text == "Jews (to some extent)"replace rejRel = 1 if q152_1_1_text == "Jews"replace rejRel = 1 if q152_1_1_text == "Jews"replace rejRel = 1 if q152_1_1_text == "Jew(s), Student(s)"replace rejRel = 1 if q152_1_1_text == "i reject their God"replace rejRel = 1 if q152_1_1_text == "I reject some of the norms of my church"replace rejRel = 1 if q152_1_1_text == "I reject some norms of the religious community I belong to. I reject many of the norms of my friend community."replace rejRel = 1 if q152_1_1_text == "I reject a lot of the norms in my religious group"replace rejRel = 1 if q152_1_1_text == "I mean, it's a mixed bag, right? I'm a pro-choice Catholic, for example. I don't think there's any group to which I belong whose norms I totally accept or reject."replace rejRel = 1 if q152_1_1_text == "I am Roman Catholic but I reject some norms set by the Church."replace rejRel = 1 if q152_1_1_text == "I am from a Jewish family, but I am atheist."replace rejRel = 1 if q152_1_1_text == "I am an atheist.  I often find other atheists to be combative, dismissive, and arrogant.  /  / I am also an avid computer gamer.  I hate how hostile gaming culture is towards women."replace rejRel = 1 if q152_1_1_text == "I am a Christian. There are many kinds of Christians, and I reject the norms of some of those kinds."replace rejRel = 1 if q152_1_1_text == "Higher education, religious organizations, a social fraternity, the american political system,  to name a few."replace rejRel = 1 if q152_1_1_text == "grupo religioso"replace rejRel = 1 if q152_1_1_text == "Gender religion race"replace rejRel = 1 if q152_1_1_text == "gays; Jews"replace rejRel = 1 if q152_1_1_text == "female, multi-racial, educated, enlightened, 30-something"replace rejRel = 1 if q152_1_1_text == "family, friends, co-workers, church"replace rejRel = 1 if q152_1_1_text == "church group (I don't reject ALL the norms, but many of them)"replace rejRel = 1 if q152_1_1_text == "church"replace rejRel = 1 if q152_1_1_text == "Church"replace rejRel = 1 if q152_1_1_text == "church"replace rejRel = 1 if q152_1_1_text == "Church"replace rejRel = 1 if q152_1_1_text == "church"replace rejRel = 1 if q152_1_1_text == "Church"replace rejRel = 1 if q152_1_1_text == "Christians, College graduates, teen mothers"replace rejRel = 1 if q152_1_1_text == "Christians / Scientists"replace rejRel = 1 if q152_1_1_text == "Christians"replace rejRel = 1 if q152_1_1_text == "Christians"replace rejRel = 1 if q152_1_1_text == "Christians"replace rejRel = 1 if q152_1_1_text == "Christians"replace rejRel = 1 if q152_1_1_text == "Christians"replace rejRel = 1 if q152_1_1_text == "Christians"replace rejRel = 1 if q152_1_1_text == "Christianity."replace rejRel = 1 if q152_1_1_text == "Christianity, America, Democrat, my family,"replace rejRel = 1 if q152_1_1_text == "Christianity"replace rejRel = 1 if q152_1_1_text == "Christian, Quiet"replace rejRel = 1 if q152_1_1_text == "christian, male, gay"replace rejRel = 1 if q152_1_1_text == "Christian, gay"replace rejRel = 1 if q152_1_1_text == "Christian, Asian-American"replace rejRel = 1 if q152_1_1_text == "Christian"replace rejRel = 1 if q152_1_1_text == "Christian"replace rejRel = 1 if q152_1_1_text == "Catholics"replace rejRel = 1 if q152_1_1_text == "Catholics"replace rejRel = 1 if q152_1_1_text == "catholics"replace rejRel = 1 if q152_1_1_text == "Catholics"replace rejRel = 1 if q152_1_1_text == "Catholicism, but just certain norms."replace rejRel = 1 if q152_1_1_text == "Catholic's views on social issues."replace rejRel = 1 if q152_1_1_text == "Catholic, woman, Christian"replace rejRel = 1 if q152_1_1_text == "Catholic, Republicans"replace rejRel = 1 if q152_1_1_text == "Catholic, American"replace rejRel = 1 if q152_1_1_text == "catholic religion"replace rejRel = 1 if q152_1_1_text == "Catholic Church... I wrestle with and sometimes reject some of their tenents.  Not the dogmas, but some of their disciplines."replace rejRel = 1 if q152_1_1_text == "Catholic church, traditional arabs"replace rejRel = 1 if q152_1_1_text == "Catholic Church"replace rejRel = 1 if q152_1_1_text == "Catholic Church"replace rejRel = 1 if q152_1_1_text == "Catholic church"replace rejRel = 1 if q152_1_1_text == "catholic"replace rejRel = 1 if q152_1_1_text == "catholic"replace rejRel = 1 if q152_1_1_text == "atheist democrat father husband"replace rejRel = 1 if q152_1_1_text == "Atheist"replace rejRel = 1 if q152_1_1_text == "As a Christian, there are many, many people around the world who may identify themselves as Christians, but whose norms I reject."replace rejRel = 1 if q152_1_1_text == "Any religious groups really."replace rejRel = 1 if q152_1_1_text == "American (some norms) Republican (some norms) Church (some norms)"replace rejRel = 1 if q152_1_1_text == "Agnostics. A norm from agnosticism I reject is not speaking out in question of religious beliefs."replace rejRel = 1 if q152_1_1_text == "agnostic"replace rejRel = 1 if q152_1_1_text == "/ Christains"
su rejRel

gen reject = 0
replace reject = 1 if q151_1 == "2"
su reject

*new dependent variable = fraction list - fraction reject
*treatment
su rejRel if treatR == 1 //.051
di .299 - .051 //.248
*control
su rejRel if treatR == 0 //.043
di .251 - .043 //.208
prtesti 895 .248 903 .208

*prot/catholics combined
*drop those who aren't protestant in the other christian category
replace relig = "." if relig == "3" & q20 == "Christian-Orthodox"
replace relig = "." if relig == "3" & q20 == "my business"
replace relig = "." if relig == "3" & q20 == "orthodoxy"
replace relig = "." if relig == "3" & q20 == "LDS/Mormon"
replace relig = "." if relig == "3" & q20 == "Jehovah's Witness :)"
replace relig = "." if relig == "3" & q20 == "Orthodox"
replace relig = "." if relig == "3" & q20 == "I don't affiliate with any church"
replace relig = "." if relig == "3" & q20 == "Jehovah's Witness"
replace relig = "." if relig == "3" & q20 == "I see myself as a Christian however I draw spiritual inspiration from many religious traditions"
replace relig = "." if relig == "3" & q20 == "Unity School of Christianity"
replace relig = "." if relig == "3" & q20 == "Greek Orthodox"
replace relig = "." if relig == "3" & q20 == "Spiritual"
replace relig = "." if relig == "3" & q20 == "independent"
replace relig = "." if relig == "3" & q20 == "none"
replace relig = "." if relig == "3" & q20 == "unity/new age"
replace relig = "." if relig == "3" & q20 == "afro-christian called UMBANDA"
replace relig = "." if relig == "3" & q20 == "no group or religion"
replace relig = "." if relig == "3" & q20 == "LDS"
replace relig = "." if relig == "3" & q20 == "Christian nature lover"
replace relig = "." if relig == "3" & q20 == "Believer but not praticing"
replace relig = "." if relig == "3" & q20 == "Spirtulist"
replace relig = "." if relig == "3" & q20 == "Greek Orthodox"
replace relig = "." if relig == "3" & q20 == "Kardecist Spiritism"
replace relig = "." if relig == "3" & q20 == "latter-day saint (Mormon)"
replace relig = "." if relig == "3" & q20 == "Coptic, Orthodox"
replace relig = "." if relig == "3" & q20 == "I believe in God, and I pray but I don't follow any kind of organized church, nor do I profess my beliefs."
replace relig = "." if relig == "3" & q20 == "Jehovah's Witness"
replace relig = "." if relig == "3" & q20 == "Greek Orthodox"
replace relig = "." if relig == "3" & q20 == "Orthdox"
replace relig = "." if relig == "3" & q20 == "lds"
replace relig = "." if relig == "3" & q20 == "Messianic Judiasm"
replace relig = "." if relig == "3" & q20 == "I am Orthodox Christian"
replace relig = "." if relig == "3" & q20 == "Coptic Orthodox Christian"
replace relig = "." if relig == "3" & q20 == "not very religious"
replace relig = "." if relig == "3" & q20 == "latter day saints"
replace relig = "." if relig == "3" & q20 == "LDS"
replace relig = "." if relig == "3" & q20 == "Orthodox"
replace relig = "." if relig == "3" & q20 == "Latter Day Saint"
replace relig = "." if relig == "3" & q20 == "Jehovah's Witness"
replace relig = "." if relig == "3" & q20 == "I love jesus and god but religion is a scam and has not contributed anything to humanity."
replace relig = "." if relig == "3" & q20 == "LDS"
replace relig = "." if relig == "3" & q20 == "Jehovah's Witnesses"
replace relig = "." if relig == "3" & q20 == "Jehovah's Witness"
replace relig = "." if relig == "3" & q20 == "Jehovah's Witnesses"
replace relig = "." if relig == "3" & q20 == "The Church of Jesus Christ of Latter-day Saints"

su rejRel if treatR == 0 & (relig == "1" | relig == "3" | relig == "2") //.06
di .347 - .060 //0.287 //415 total

su rejRel if treatR == 1 & (relig == "1" | relig == "3" | relig == "2") //.068
di .428 - .068 //.36 //409 total

prtesti 415 .287 409 .36


