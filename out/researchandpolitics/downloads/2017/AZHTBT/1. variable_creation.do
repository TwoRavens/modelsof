*****************************************************************************
************************ Replication package for ****************************
*** Twitter and Facebook are not representative of the General Population ***
********************Variable creation and cleaning **************************
*****************************************************************************


***Set working directory***
cd "C:\Dropbox\BES backup\Social media paper\replication package\data"
use bes_f2f_original_v3.0.dta, clear 

***Social Media usage***
label define binaryYesNo 0 "No" 1 "Yes", replace

recode k06 -1=. 2=0, into( twitterUse)
label variable twitterUse "Uses Twitter"
label values twitterUse binaryYesNo

recode k08 -1=. 2=0, into(fbUse)
label values fbUse binaryYesNo
label variable fbUse "Uses Facebook"

*** Generate Education level variable ***
gen edlevel = .
replace edlevel =	1 if education==12
replace edlevel =	2 if education==10
replace edlevel =	2 if education==11
replace edlevel =	3 if education==7
replace edlevel =	3 if education==8
replace edlevel =	4 if education==3
replace edlevel =	4 if education==2
replace edlevel =	5 if education==1
replace edlevel =	0 if education==0
replace edlevel =	1 if education==17
replace edlevel =	1 if education==15
replace edlevel =	2 if education==16
replace edlevel =	2 if education==14
replace edlevel =	3 if education==13
replace edlevel =	4 if education==5
replace edlevel =	4 if education==4
replace edlevel =	. if education==18
replace edlevel =	3 if education==6
replace edlevel =	3 if education==9

label variable edlevel "Education level" 
label define edlevel 0 "No qualifications" 1 "GCSE D-G" 2 "GCSE A*-C" 3 "A-level" 4 "Undergraduate" 5 "Postgrad"
label values edlevel edlevel

***Gender***
recode y09 1=0 2=1, into(gender)
label variable gender "Gender"
label define gender 0 "Male" 1 "Female"
label values gender gender

***2015 General Election vote***
rename b01 genElecTurnoutRetro 
recode genElecTurnoutRetro 2=0 -2/-1=.
label define retroturn 1 "Yes, voted" 0 "No, did not vote"
label values genElecTurnoutRetro retroturn 

rename b02 generalElectionVote
recode generalElectionVote 1=2 2=1 6=7 7=6 8=9 10=9999 11=. -1 =. -2=.
label define generalElecVote 1   "Conservative" 2   "Labour" 3   "Liberal Democrat"  ///
	4  "Scottish National Party (SNP)" 5 "Plaid Cymru" ///
	6 "United Kingdom Independence Party (UKIP)" 7   "Green Party" ///
	 9   "Other" 
label values generalElectionVote generalElecVote

recode generalElectionVote 4/5=9, into(vote2015)
label values vote2015 generalElecVote

recode validatedTurnout 2/3=0
label define validatedTurnout 0 "Not voted" 1 "Voted"
label values validatedTurnout validatedTurnout

***Attention to politics***
rename k01 polAttention
recode polAttention -2/-1=.

***Political values scales***
foreach x in f01_1 f01_2 f01_5 f01_6 f01_7 f01_8 f01_3 f01_4 f01_9 f01_10 {
recode `x' -1 = .
}

gen lr_scale = f01_1 + ((f01_2-6)*-1) + f01_5 + f01_6 + ((f01_7 -6)*-1) + ((f01_8-6)*-1)
egen zLR = std(lr_scale)

gen al_scale = f01_3 + f01_4 + ((f01_9-6)*-1) + ((f01_10-6)*-1)
egen zAL = std(al_scale)

***Remove missing Age data***
recode Age -1=.
label variable Age "Age"

***Scotland & Wales dummy variables***
gen scotland = 0
replace scotland = 1 if gor==11
gen wales = 0
replace wales = 1 if gor==1

saveold bes_f2f_using.dta, replace version(12)


