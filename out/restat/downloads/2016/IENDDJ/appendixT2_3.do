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


*Online Appendix Table 2
**regression of prot classification dummy on student status, age, log income
*student status
gen student = .
replace student = 1 if q16 == "1"
replace student = 0 if q16 == "2"

*age

replace q17 = "28" if q17 == "28 years old"
replace q17 = "." if q17 == "I never tell"
replace q17 = "." if q17 == "None of your business"
replace q17 = "59" if q17 == "fifty nine"
gen age = real(q17)

*income
gen income = .
replace income = (0 + 25000)/2 if q18 == "1"
replace income = (25000 + 49999)/2 if q18 == "2"
replace income = (50000 + 74999)/2 if q18 == "3"
replace income = (75000 + 99999)/2 if q18 == "4"
replace income = (100000 + 149999)/2 if q18 == "5"
replace income = (150000 + 199999)/2 if q18 == "6"
replace income = 200000 if q18 == "7"
gen lincome = log(income)

*prot classification dummy
gen protDum = 0
replace protDum = 1 if relig == "3" | relig == "1"
tab protDum

*cath classification dummy
gen cathDum = 0
replace cathDum = 1 if relig == "2"
tab cathDum

*create interaction variables
gen studenttreatR = student*treatR
gen agetreatR = age * treatR
gen lincometreatR = lincome*treatR

reg protDum student age lincome studenttreatR agetreatR lincometreatR treatR
test (studenttreatR = 0) (agetreatR = 0) (lincometreatR = 0)

reg cathDum student age lincome studenttreatR agetreatR lincometreatR treatR
test (studenttreatR = 0) (agetreatR = 0) (lincometreatR = 0) 

*Online Appendix Table 3
reg religion treatR student age lincome studenttreatR agetreatR lincometreatR
