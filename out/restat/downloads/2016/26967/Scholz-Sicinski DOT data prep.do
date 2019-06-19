*MAKE A NEW VERSION BASED ON THE ICPSR CPS+DOT DATA

use "07845-0001-Data.dta"

log using "Scholz-Sicinski DOT data prep.log",replace

*** Retain raw variables of interest

* Limit sample to match the WLS respondents
*keep if V003==2	//Northcentral
keep if V012==1 | V012==2	//Working
keep if V020>=28 & V020<=45 //Age
keep if V023==1	//Male
drop if V025<13 | V025==13 & V026==2	//Not completed high school
keep if V032==1	//White

rename V029 WeightCPS
rename V076 GED_3ed
rename V077 SVP_3ed
rename V080 abcode
rename V081 DOTcode
rename V082 GED_R
rename V083 GED_M
rename V084 GED_L
rename V085 SVP_4ed
rename V086 Apt_IQ
rename V087 Apt_Verbal
rename V088 Apt_Numerical
rename V091 Apt_Clerical
rename V097 Temperament1
rename V098 Temperament2
rename V099 Temperament3
rename V100 Temperament4
rename V101 Temperament5
rename V115 Interest1
rename V116 Interest2
rename V117 Interest3
rename V118 Interest4
rename V119 Interest5
*rename V126 DOT_Title
drop V*

*** Construct measures of interest
gen DOTstr=string(DOTcode,"%12.0g")
gen DOTlength=strlen(strtrim(DOTstr))
replace DOTstr="00"+DOTstr if DOTlength==7
replace DOTstr = "0"+DOTstr if DOTlength==8
gen data=substr(DOTstr,4,1)
destring data,replace
gen people=substr(DOTstr,5,1)
destring people,replace
gen things=substr(DOTstr,6,1)
destring things,replace

gen DCP=0	//Adaptability to Direct, Control or Plan
gen FIF=0	//Adaptability to interpret Feelings, Idea or Facts
gen INFLU=0	//Adaptability to Influence people
gen DEPL=0	//Adaptability to Dealing with people
gen VARCH=0	//Adaptability to perform Variaty of Changing tasks

gen BUSC=0	//Preference for business contact
gen PREST=0	//Preference for prestige

gen Mentor=0
gen Negotiate=0
gen Instruct=0
gen Supervise=0
gen Divert=0
gen Persuade=0
gen SpeakSig=0
gen NoPeop=0	//Serve,Take Instructions,No

foreach var in 1 2 3 4 5 {
replace DCP=1 if Temperament`var'=="D"
replace FIF=1 if Temperament`var'=="F"
replace INFLU=1 if Temperament`var'=="I"
replace DEPL=1 if Temperament`var'=="P"
replace VARCH=1 if Temperament`var'=="V" 
replace BUSC=1 if Interest`var'=="2A"
replace PREST=1 if Interest`var'=="5A"
replace Mentor=1 if people==0
replace Negotiate=1 if people==1
replace Instruct=1 if people==2
replace Supervise=1 if people==3
replace Divert=1 if people==4
replace Persuade=1 if people==5
replace SpeakSig=1 if people==6 
replace NoPeop=1 if people==7 | people==8 | people==9
}

*** Take averages of measures of interest across abcode groups
sort abcode

gen datam=0
gen peoplem=0
gen thingsm=0
gen DCPm=0
gen FIFm=0
gen INFLUm=0
gen DEPLm=0
gen VARCHm=0
gen BUSCm=0
gen PRESTm=0
gen GED_Rm=0
gen GED_Mm=0
gen GED_Lm=0
gen SVP_4edm=0
gen Apt_IQm=0
gen Apt_Verbalm=0
gen Apt_Numericalm=0
gen Apt_Clericalm=0
gen Mentorm=0
gen Negotiatem=0
gen Instructm=0
gen Supervisem=0
gen Divertm=0
gen Persuadem=0
gen SpeakSigm=0
gen NoPeopm=0

quietly levelsof abcode,local(codelist)	
foreach group of local codelist {
di "Abcode #`group' " 
foreach var of varlist data people things DCP FIF INFLU DEPL VARCH BUSC PREST /// 
GED_R GED_M GED_L SVP_4ed Apt_IQ Apt_Verbal Apt_Numerical Apt_Clerical ///
Mentor Negotiate Instruct Supervise Divert Persuade SpeakSig NoPeop {
sum `var' if abcode==`group' [aweight=WeightCPS],mean
qui replace `var'm=r(mean) if abcode==`group'
}
}
keep abcode datam-NoPeopm

duplicates drop abcode,force

save "DOT_1970_v2.dta",replace

log c



/* LOOK AT ABCODE'S THAT WERE NOT MATCHED

use "07845-0001-Data.dta"
rename V080 abcode
foreach code in 540000 630000 810000 820000 840000 1160000 1310000 1430000 1750000 2620000 2800000 3030000 3420000 ///
3440000 3500000 ///
3700000 3710000 3820000 4110000 4230000 4350000 4410000 4430000 5010000 5050000 5120000 5400000 6130000 6250000 ///
6640000 6720000 6901870 6902280 6902390 6903890 6903970 6903980 6906000 7110000 7802390 7802590 7802980 7803790 ///
7809990 9010000 9130000 9160000 9210000 9260000 9400000 9520000 9540000 9600000 9700000 9710000 9730000 9800000 ///
9820000 9840000 {
di "Abcode is `code'"
list abcode V012 V020 V023 V025 V026 V032 V126 if abcode==`code'

}

*/


