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



*Panel A: All
count if treatR == 0 //903
count if treatR == 1 // 895

count if religion == 1 & treatR == 0 //227
count if religion == 1 & treatR == 1 //268

di 227/903
di 268/895

prtesti 903 .251 895 .299

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

*Panel A: Protestant
count if relig == "3" & treatR == 0 //83
count if relig == "3" & treatR == 1 //93
count if relig == "1" & treatR == 0 //156
count if relig == "1" & treatR == 1 //178

count if religion == 1 & relig == "3" & treatR == 0 //27
count if religion == 1 & relig == "3" & treatR == 1 //40
count if religion == 1 & relig == "1" & treatR == 0 //71
count if religion == 1 & relig == "1" & treatR == 1 //89

di (27+71)/(83+156) //98,239, =.410
di (40+89)/(93+178) //129,271, =.476

prtesti 239 .410 271 .476
di 239 +271

*Panel A: Catholic
count if relig == "2" & treatR == 0 //176
count if relig == "2" & treatR == 1 //138
di 176 + 138

count if religion == 1 & relig == "2" & treatR == 0 //46
count if religion == 1 & relig == "2" & treatR == 1 //46

di 46/176 //.261
di 46/138 //.333

prtesti 176 .261 138 .333

*Panel A: Jewish
count if relig == "4" & treatR == 0 //43
count if relig == "4" & treatR == 1 //46
di 43 + 46

count if religion == 1 & relig == "4" & treatR == 0 //29
count if religion == 1 & relig == "4" & treatR == 1 //27

di 29/43 //.674
di 27/46 //.587

prtesti 43 .674 46 .587

*Panel A: Agnostic/Atheist
count if relig == "8" & treatR == 0 //150
count if relig == "8" & treatR == 1 //126
count if relig == "9" & treatR == 0 //150
count if relig == "9" & treatR == 1 //144
di 150+126+150+144

count if religion == 1 & relig == "8" & treatR == 0 //10
count if religion == 1 & relig == "8" & treatR == 1 //10
count if religion == 1 & relig == "9" & treatR == 0 //20
count if religion == 1 & relig == "9" & treatR == 1 //20

di (10+20)/(150+150) //30,300, =.1
di (10+20)/(126+144) //30,270, =.111

prtesti 300 .1 270 .111

*Now examine only Yale eLab sample

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

gen id = _n
drop if id > 1192

*Panel B: All
count if treatR == 0 //603
count if treatR == 1 // 589
di 603+589

count if religion == 1 & treatR == 0 //147
count if religion == 1 & treatR == 1 //184

di 147/603 //.244
di 184/589 //.312

prtesti 603 .244 589 .312

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

*Panel A: Protestant
count if relig == "3" & treatR == 0 //58
count if relig == "3" & treatR == 1 //67
count if relig == "1" & treatR == 0 //107
count if relig == "1" & treatR == 1 //119
di 58+67+107+119

count if religion == 1 & relig == "3" & treatR == 0 //17
count if religion == 1 & relig == "3" & treatR == 1 //32
count if religion == 1 & relig == "1" & treatR == 0 //49
count if religion == 1 & relig == "1" & treatR == 1 //58

di (17+49)/(58+107) //66,165, =.4
di (32+58)/(67+119) //90,186, =.484

prtesti 165 .4 186 .484

*Panel B: Catholic
count if relig == "2" & treatR == 0 //126
count if relig == "2" & treatR == 1 //97
di 126 + 97

count if religion == 1 & relig == "2" & treatR == 0 //35
count if religion == 1 & relig == "2" & treatR == 1 //35

di 35/126 //.278
di 35/97 //.361
prtesti 126 .278 97 .361

*Panel B: Jewish
count if relig == "4" & treatR == 0 //39
count if relig == "4" & treatR == 1 //36
di 39 + 36

count if religion == 1 & relig == "4" & treatR == 0 //25
count if religion == 1 & relig == "4" & treatR == 1 //22

di 25/39 //.641
di 22/36 //.611

prtesti 39 .641 36 .611

*Panel B: Agnostic/Atheist
count if relig == "8" & treatR == 0 //93
count if relig == "8" & treatR == 1 //73
count if relig == "9" & treatR == 0 //75
count if relig == "9" & treatR == 1 //77
di 93+73+75+77

count if religion == 1 & relig == "8" & treatR == 0 //3
count if religion == 1 & relig == "8" & treatR == 1 //5
count if religion == 1 & relig == "9" & treatR == 0 //3
count if religion == 1 & relig == "9" & treatR == 1 //8

di (3+3)/(93+75) //6,168, =.036
di (5+8)/(73+77) //13,150, =.087

prtesti 168 .036 150 .087


*Now examine only MTurk sample

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

gen id = _n
drop if id <= 1192

*Panel C: All
count if treatR == 0 //300
count if treatR == 1 // 306
di 300+306

count if religion == 1 & treatR == 0 //80
count if religion == 1 & treatR == 1 //84

di 80/300 //.267
di 84/306 //.275

prtesti 300 .267 306 .275

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

*Panel C: Protestant
count if relig == "3" & treatR == 0 //25
count if relig == "3" & treatR == 1 //26
count if relig == "1" & treatR == 0 //49
count if relig == "1" & treatR == 1 //59
di 25+26+49+59

count if religion == 1 & relig == "3" & treatR == 0 //10
count if religion == 1 & relig == "3" & treatR == 1 //8
count if religion == 1 & relig == "1" & treatR == 0 //22
count if religion == 1 & relig == "1" & treatR == 1 //31

di (10+22)/(25+49) //32,74, =.432
di (8+31)/(26+59) //39,85, =.459
prtesti 74 .432 85 .459

*Panel C: Catholic
count if relig == "2" & treatR == 0 //50
count if relig == "2" & treatR == 1 //41
di 50 + 41

count if religion == 1 & relig == "2" & treatR == 0 //11
count if religion == 1 & relig == "2" & treatR == 1 //11

di 11/50 //.22
di 11/41 //.268
prtesti 50 .22 41 .268

*Panel C: Jewish
count if relig == "4" & treatR == 0 //4
count if relig == "4" & treatR == 1 //10
di 4 + 10

count if religion == 1 & relig == "4" & treatR == 0 //4
count if religion == 1 & relig == "4" & treatR == 1 //5

di 4/4 //1
di 5/10 //.5

prtesti 4 1 10 .5

*Panel C: Agnostic/Atheist
count if relig == "8" & treatR == 0 //57
count if relig == "8" & treatR == 1 //53
count if relig == "9" & treatR == 0 //75
count if relig == "9" & treatR == 1 //67
di 57+53+75+67

count if religion == 1 & relig == "8" & treatR == 0 //7
count if religion == 1 & relig == "8" & treatR == 1 //5
count if religion == 1 & relig == "9" & treatR == 0 //17
count if religion == 1 & relig == "9" & treatR == 1 //12

di (7+17)/(57+75) //24,132, =.182
di (5+12)/(53+67) //17,120, =.142

prtesti 132 .182 120 .142
