use "/Users/spencerpiston/Dropbox/Yanna stuff/ambiguity/KrupnikovPistonRyan/JOP/JOP RR/Final RR Submission/OFFICIAL FINAL/conditional acceptance/replication/SSI_merged_dataset.dta", clear
set more off

*respondent race/ethnicity
gen rwhite=0
recode rwhite 0=1 if q308_1==1
gen rasian=0
recode rasian 0=1 if q308_5==1
*hispanic
gen rhisp=0
replace rhisp=1 if q310==1

gen whitecontrol=1 if q45==1
gen whiteambig=1 if q50==1
gen whiteprecise=1 if q63==1
gen blackcontrol=1 if q54a==1
gen blackambig=1 if q71a==1
gen blackprecise=1 if q77a==1

replace whitecontrol=0 if whitecontrol==.
replace whiteambig=0 if whiteambig==.
replace whiteprecise=0 if whiteprecise==.

replace blackcontrol=0 if blackcontrol==.
replace blackambig=0 if blackambig==.
replace blackprecise=0 if blackprecise==.

gen black=1 if blackcontrol==1
replace black=1 if blackambig==1
replace black=1 if blackprecise==1
replace black=0 if whitecontrol==1
replace black=0 if whiteambig==1
replace black=0 if whiteprecise==1

gen ambig=0 if blackcontrol==1
replace ambig=1 if blackambig==1
replace ambig=0 if blackprecise==1
replace ambig=0 if whitecontrol==1
replace ambig=1 if whiteambig==1
replace ambig=0 if whiteprecise==1

gen precise=0 if blackcontrol==1
replace precise=0 if blackambig==1
replace precise=1 if blackprecise==1
replace precise=0 if whitecontrol==1
replace precise=0 if whiteambig==1
replace precise=1 if whiteprecise==1

gen silent=1 if blackcontrol==1
replace silent=0 if blackambig==1
replace silent=0 if blackprecise==1
replace silent=1 if whitecontrol==1
replace silent=0 if whiteambig==1
replace silent=0 if whiteprecise==1

gen treatnum=0 if silent==1
replace treatnum=1 if precise==1
replace treatnum=2 if ambig==1


gen votename="Larson" if votechoice1==1
replace votename="McCann" if votechoice1==2
replace votename="Neither" if votechoice1==3

replace votename="Larson" if votechoice2==1
replace votename="McCann" if votechoice2==2
replace votename="Neither" if votechoice2==3

replace votename="Larson" if votechoice3==1
replace votename="McCann" if votechoice3==2
replace votename="Neither" if votechoice3==3

replace votename="Larson" if votechoice4==1
replace votename="McCann" if votechoice4==2
replace votename="Neither" if votechoice4==3

replace votename="Larson" if votechoice5==1
replace votename="McCann" if votechoice5==2
replace votename="Neither" if votechoice5==3

replace votename="Larson" if votechoice6==1
replace votename="McCann" if votechoice6==2
replace votename="Neither" if votechoice6==3


gen larsonvote=0 if votename=="McCann"
replace larsonvote=1 if votename=="Larson"
replace larsonvote=0 if votename=="Neither"

gen votenum=-1 if votename=="McCann"
replace votenum=1 if votename=="Larson"
replace votenum=0 if votename=="Neither"

gen larson=0 if votename=="McCann"
replace larson=1 if votename=="Larson"
replace larson=. if votename=="Neither"

*thermometer ratings of candidates
egen larsontherm = rowmean(q41_1 v26 q58_1 q66_1 q74_1 v80)
gen larsontherm0to1=larsontherm/100
egen mccanntherm = rowmean(q41_2 v27 q58_2 q66_2 q74_2 v81)
gen lmtherm=larsontherm-mccanntherm
gen lmtherm0to1=(lmtherm+100)/200

*environmental positions (higher values more conservative)
gen envrespw1=q264_1
gen envrespw10to1=(envrespw1-1)/6
gen envrespw2=q2_1
egen envlars=rowmean(q79_1a q80_1 q81_1 q82_1 q83_1a q84_1)
gen envlars0to1=(envlars-1)/6

gen environment=q264_1 if q264_1!=-99

*racial stereotypes
gen whitework=q276 if q276!=-99
gen blackwork=q278 if q278!=-99
gen whitesmart=q284 if q284!=-99
gen blacksmart=q286 if q286!=-99
gen prowhite=(whitework-blackwork)+(whitesmart-blacksmart)
gen stindex0to1=(prowhite+12)/24

gen party3=q31
recode party3 2=1 3=1 4=1 5=0 6=-1 7=-1 8=-1

replace party3=1 if party3==. & q32==1
replace party3=1 if party3==. & q32==2
replace party3=1 if party3==. & q32==3
replace party3=-1 if party3==. & q32==5
replace party3=-1 if party3==. & q32==6
replace party3=-1 if party3==. & q32==7

gen pidrep3cat=party3
recode pidrep3cat 0=2 -1=3

*party id
gen pidrep0to1=(q31-2)/6

*ideology
gen ideo0to1=(q164-1)/6

*male
gen male=0
replace male=1 if q161==1

*education
gen educ0to1=q162
replace educ0to1=(educ0to1-1)/5

*income
gen inc0to1=q163
replace inc0to1=(inc0to1-1)/8

keep larsonvote lmtherm0to1 black precise ambig silent treatnum rwhite rasian rhisp male educ0to1 inc0to1 envlars0to1 envrespw10to1 ideo0to1 pidrep0to1 stindex0to1 pidrep3cat

save "/Users/spencerpiston/Dropbox/Yanna stuff/ambiguity/KrupnikovPistonRyan/JOP/JOP RR/Final RR Submission/OFFICIAL FINAL/conditional acceptance/replication/SSI_merged_dataset_coded.dta", replace

