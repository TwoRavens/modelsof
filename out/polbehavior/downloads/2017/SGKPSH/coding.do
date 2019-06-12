
/// This do file constructs the dataset used for Bittner and Goodyear-Grant’s Political Behavior article, 
/// “Sex Isn’t Gender: Reforming Concepts and Measurements in the Study of Public Opinion,” using Stata 14.2.
/// for more information or with any questions, contact Bittner at: abittner@mun.ca 


cd "/Users/amandabittner1/Dropbox/professional/Research/Better than Sex/Political Behavior/replication/"

/*Quebec*/

use Quebec.dta, clear

/*gender questions*/
/*100=feminine, 0=masculine*/

tab Q46
gen selfplacegen=Q46
tab selfplacegen
recode selfplacegen 80/998=.
replace selfplacegen=selfplacegen+50
tab selfplacegen
replace selfplacegen=selfplacegen*(-1)
tab selfplacegen
replace selfplacegen=selfplacegen+100
tab selfplacegen

gen selfplacegenmiddle=selfplacegen
tab selfplacegenmiddle
recode selfplacegenmiddle 0/10=0 11/89=1 90/100=0
tab selfplacegenmiddle



gen selfplacegenmid10=selfplacegenmiddle

gen selfplacegenmid20=selfplacegen
recode selfplacegenmid20 0/20=0 21/79=1 80/100=0
tab selfplacegenmid20

gen selfplacegenmid25=selfplacegen
recode selfplacegenmid25 0/25=0 26/74=1 75/100=0
tab selfplacegenmid25

gen selfplacegenmid30=selfplacegen
recode selfplacegenmid30 0/30=0 31/69=1 70/100=0
tab selfplacegenmid30


tab Q47
gen otherplacegen=Q47
tab otherplacegen
recode otherplacegen 80/998=.
replace otherplacegen=otherplacegen+50
tab otherplacegen
replace otherplacegen=otherplacegen*(-1)
tab otherplacegen
replace otherplacegen=otherplacegen+100
tab otherplacegen

gen otherplacegenmiddle=otherplacegen
tab otherplacegenmiddle
recode otherplacegenmiddle 0/10=0 11/89=1 90/100=0
tab otherplacegenmiddle

tab Q48
gen genderid=Q48
tab genderid
recode genderid 998=.
tab genderid


*recoding attitudes and issues variables*/
/*all coded on 0-1 scale so that 1=most liberal/progressive perspective*/

tab Q17_1
gen healthcarespending=Q17_1
tab healthcarespending
recode healthcarespending 1=0 2=0.5 3=1 9=.
tab healthcarespending

tab Q17_2
gen welfarespending=Q17_2
tab welfarespending
recode welfarespending 1=0 2=0.5 3=1 9=.
tab welfarespending

tab Q32_2
gen layoffwomen=Q32_2
tab layoffwomen
recode layoffwomen 4=0 3=1 2=2 1=3
replace layoffwomen=layoffwomen/3
tab layoffwomen

tab Q32_3
gen socialprogs=Q32_3
tab socialprogs
recode socialprogs 4=0 3=1 2=2 1=3
replace socialprogs=socialprogs/3
tab socialprogs

tab Q32_5
gen discrimjobs=Q32_5
tab discrimjobs
replace discrimjobs=discrimjobs-1
replace discrimjobs=discrimjobs/3
tab discrimjobs

tab Q32_6
gen adaptmoral=Q32_6
tab adaptmoral
replace adaptmoral=adaptmoral-1
replace adaptmoral=adaptmoral/3
tab adaptmoral

tab Q32_7
gen tradfamvalues=Q32_7
tab tradfamvalues
recode tradfamvalues 4=0 3=1 2=2 1=3
replace tradfamvalues=tradfamvalues/3
tab tradfamvalues

tab Q32_9
gen wantworkfindjob=Q32_9
tab wantworkfindjob
recode wantworkfindjob 4=0 3=1 2=2 1=3
replace wantworkfindjob=wantworkfindjob/3
tab wantworkfindjob

tab Q32_11
gen womenhofc=Q32_11
tab womenhofc
replace womenhofc=womenhofc-1
replace womenhofc=womenhofc/3
tab womenhofc

tab Q35
gen samesexmarriage=Q35
tab samesexmarriage
recode samesexmarriage 1=1 2=0 9=0.5
tab samesexmarriage
/*no opinion coded in the middle - it was a response option that 30% of sample chose*/

tab Q37
gen abortion=Q37
tab abortion
replace abortion=abortion-1
replace abortion=abortion/3
tab abortion

tab Q38
gen govinvolvement=Q38
tab govinvolvement
recode govinvolvement 2=0
tab govinvolvement

tab Q51
gen ideology=Q51
tab ideology
replace ideology=ideology-10
tab ideology
replace ideology=ideology*(-1)
tab ideology
replace ideology=ideology/10
tab ideology

gen leftright=ideology
recode leftright 0/0.4=0 .6/1=1
tab leftright




tab Q88
gen fedintent=Q88
tab fedintent

gen libintent=Q88
recode libintent 2/99=0
tab libintent

gen consintent=Q88
recode consintent 1=0 2=1 3/99=0
tab consintent

gen ndpintent=Q88
recode ndpintent 1/2=0 3=1 4/99=0
tab ndpintent

gen greenintent=Q88
recode greenintent 1/4=0 5=1 6/99=0
tab greenintent

gen blocintent=Q88
recode blocintent 1/3=0 4=1 5/99=0


/*demos*/


tab gend
gen woman=gend
tab woman
recode woman 1=0 2=1
tab woman

tab Q76
gen degreeholder=Q76
tab degreeholder
recode degreeholder 1/5=0 6=1 7=0 8/11=1
tab degreeholder

tab Q77
gen fulltimework=Q77
tab fulltimework
recode fulltimework 2=0 3=1 4/8=0
tab fulltimework

tab Q78
gen union=Q78
tab union
recode union 1/3=1 4=0
tab union

tab Q79
gen partnered=Q79
tab partnered
recode partnered 1=0 2=1 3=1 4/5=0
tab partnered

tab Q82
gen religiousity=Q82
tab religiousity
recode religiousity 6=0 5=1 4=2 3=3 2=4 1=5
replace religiousity=religiousity/5
tab religiousity

tab Q85
gen income=Q85
tab income
replace income=income-1
replace income=income/4
tab income

gen agecategory=QT1B
tab agecategory

tab Q46
gen gender=Q46

gen gencrossers=.
replace gencrossers=0 if woman==1 & gender<0
replace gencrossers=0 if woman==0 & gender>0
replace gencrossers=1 if woman==1 & gender>=1
replace gencrossers=1 if woman==0 & gender<0
tab gencrossers woman
replace gencrossers=. if gender==.
tab gencrossers woman






gen newgender=woman
replace newgender=0.5 if selfplacegenmiddle==1
tab newgender
replace newgender=0.5 if gencrossers==1
recode newgender 0.5=1 1=2
tab newgender

tab newgender woman

replace newgender=. if gencrossers==1
tab newgender

gen fourgen=newgender
recode fourgen 2=3
recode fourgen 1=2 if woman==1
tab fourgen

gen selfplacegenmiddlecross=selfplacegenmiddle
replace selfplacegenmiddlecross=1 if gencrossers==1
tab selfplacegenmiddlecross

tab selfplacegenmiddle gencrossers
replace selfplacegenmiddle=. if gencrossers==1
tab selfplacegenmiddle


gen mascmale=fourgen
recode mascmale 0=1 1/3=0

gen midmale=fourgen
recode midmale 2/3=0

gen midfemale=fourgen
recode midfemale 1=0 2=1 3=0

gen femfemale=fourgen
recode femfemale 1/2=0 3=1



keep respid selfplacegen selfplacegenmiddle selfplacegenmid10 selfplacegenmid20 selfplacegenmid25 selfplacegenmid30/*
*/ otherplacegen otherplacegenmiddle genderid healthcarespending welfarespending layoffwomen/*
*/ socialprogs discrimjobs adaptmoral tradfamvalues wantworkfindjob womenhofc samesexmarriage/*
*/ abortion govinvolvement ideology leftright fedintent libintent consintent ndpintent greenintent/*
*/ blocintent woman degreeholder fulltimework union partnered religiousity income agecategory/*
*/ prov gender gencrossers newgender fourgen selfplacegenmiddlecross mascmale midmale midfemale femfemale 

save Quebec1.dta, replace


/*BC*/

use BC.dta, clear


/*gender questions*/
/*100=feminine, 0=masculine*/

tab Q42
gen selfplacegen=Q42
tab selfplacegen
recode selfplacegen 80/998=.
replace selfplacegen=selfplacegen+50
tab selfplacegen
replace selfplacegen=selfplacegen*(-1)
tab selfplacegen
replace selfplacegen=selfplacegen+100
tab selfplacegen

gen selfplacegenmiddle=selfplacegen
tab selfplacegenmiddle
recode selfplacegenmiddle 0/10=0 11/89=1 90/100=0
tab selfplacegenmiddle



gen selfplacegenmid10=selfplacegenmiddle

gen selfplacegenmid20=selfplacegen
recode selfplacegenmid2 0/20=0 21/79=1 80/100=0
tab selfplacegenmid20

gen selfplacegenmid25=selfplacegen
recode selfplacegenmid25 0/25=0 26/74=1 75/100=0
tab selfplacegenmid25

gen selfplacegenmid30=selfplacegen
recode selfplacegenmid30 0/30=0 31/69=1 70/100=0
tab selfplacegenmid30



tab Q43
gen otherplacegen=Q43
tab otherplacegen
recode otherplacegen 80/998=.
replace otherplacegen=otherplacegen+50
tab otherplacegen
replace otherplacegen=otherplacegen*(-1)
tab otherplacegen
replace otherplacegen=otherplacegen+100
tab otherplacegen

gen otherplacegenmiddle=otherplacegen
tab otherplacegenmiddle
recode otherplacegenmiddle 0/10=0 11/89=1 90/100=0
tab otherplacegenmiddle

tab Q44
gen genderid=Q44
tab genderid
recode genderid 998=.
tab genderid



*recoding attitudes and issues variables*/
/*all coded on 0-1 scale so that 1=most liberal/progressive perspective*/

tab Q17A
gen healthcarespending=Q17A
tab healthcarespending
recode healthcarespending 1=0 2=0.5 3=1 9=.
tab healthcarespending

tab Q17B
gen welfarespending=Q17B
tab welfarespending
recode welfarespending 1=0 2=0.5 3=1 9=.
tab welfarespending

tab Q32B
gen layoffwomen=Q32B
tab layoffwomen
recode layoffwomen 4=0 3=1 2=2 1=3
replace layoffwomen=layoffwomen/3
tab layoffwomen

tab Q32C
gen socialprogs=Q32C
tab socialprogs
recode socialprogs 4=0 3=1 2=2 1=3
replace socialprogs=socialprogs/3
tab socialprogs

tab Q32E
gen discrimjobs=Q32E
tab discrimjobs
replace discrimjobs=discrimjobs-1
replace discrimjobs=discrimjobs/3
tab discrimjobs

tab Q32F
gen adaptmoral=Q32F
tab adaptmoral
replace adaptmoral=adaptmoral-1
replace adaptmoral=adaptmoral/3
tab adaptmoral

tab Q32G
gen tradfamvalues=Q32G
tab tradfamvalues
recode tradfamvalues 4=0 3=1 2=2 1=3
replace tradfamvalues=tradfamvalues/3
tab tradfamvalues

tab Q32I
gen wantworkfindjob=Q32I
tab wantworkfindjob
recode wantworkfindjob 4=0 3=1 2=2 1=3
replace wantworkfindjob=wantworkfindjob/3
tab wantworkfindjob

tab Q32K
gen womenhofc=Q32K
tab womenhofc
replace womenhofc=womenhofc-1
replace womenhofc=womenhofc/3
tab womenhofc

tab Q35
gen samesexmarriage=Q35
tab samesexmarriage
recode samesexmarriage 1=1 2=0 9=0.5
tab samesexmarriage
/*no opinion coded in the middle - it was a response option that 30% of sample chose*/

tab Q37
gen abortion=Q37
tab abortion
replace abortion=abortion-1
replace abortion=abortion/3
tab abortion

tab Q38
gen govinvolvement=Q38
tab govinvolvement
recode govinvolvement 2=0
tab govinvolvement

tab Q47
gen ideology=Q47
tab ideology
replace ideology=ideology-10
tab ideology
replace ideology=ideology*(-1)
tab ideology
replace ideology=ideology/10
tab ideology

gen leftright=ideology
recode leftright 0/0.4=0 .6/1=1
tab leftright

/*federal vote intention - so that it's a common question */

tab Q84
gen fedintent=Q84
tab fedintent

gen libintent=Q84
recode libintent 2/99=0
tab libintent

gen consintent=Q84
recode consintent 1=0 2=1 3/99=0
tab consintent

gen ndpintent=Q84
recode ndpintent 1/2=0 3=1 4/99=0
tab ndpintent

gen greenintent=Q84
recode greenintent 1/3=0 4=1 5/99=0
tab greenintent


/*demos*/


tab QT1C
gen woman=QT1C
tab woman
recode woman 1=0 2=1
tab woman

tab Q72
gen degreeholder=Q72
tab degreeholder
recode degreeholder 1/5=0 6=1 7=0 8/11=1
tab degreeholder

tab Q73
gen fulltimework=Q73
tab fulltimework
recode fulltimework 2=0 3=1 4/8=0
tab fulltimework

tab Q74
gen union=Q74
tab union
recode union 1/3=1 4=0
tab union

tab Q75
gen partnered=Q75
tab partnered
recode partnered 1=0 2=1 3=1 4/5=0
tab partnered

tab Q78
gen religiousity=Q78
tab religiousity
recode religiousity 6=0 5=1 4=2 3=3 2=4 1=5
replace religiousity=religiousity/5
tab religiousity

tab Q81
gen income=Q81
tab income
replace income=income-1
replace income=income/4
tab income

gen agecategory=QT1B
tab agecategory


gen gender=Q42
tab gender
recode gender 80=. 998=.
tab gender


tab Q42
gen gencrossers=.
replace gencrossers=0 if woman==1 & gender<0
replace gencrossers=0 if woman==0 & gender>0
replace gencrossers=1 if woman==1 & gender>=1
replace gencrossers=1 if woman==0 & gender<0
tab gencrossers woman
replace gencrossers=. if gender==.
tab gencrossers woman


gen newgender=woman
replace newgender=0.5 if selfplacegenmiddle==1
tab newgender
replace newgender=0.5 if gencrossers==1
recode newgender 0.5=1 1=2
tab newgender

tab newgender woman

replace newgender=. if gencrossers==1
tab newgender

gen fourgen=newgender
recode fourgen 2=3
recode fourgen 1=2 if woman==1
tab fourgen

gen selfplacegenmiddlecross=selfplacegenmiddle
replace selfplacegenmiddlecross=1 if gencrossers==1
tab selfplacegenmiddlecross

tab selfplacegenmiddle gencrossers
replace selfplacegenmiddle=. if gencrossers==1
tab selfplacegenmiddle


gen mascmale=fourgen
recode mascmale 0=1 1/3=0

gen midmale=fourgen
recode midmale 2/3=0

gen midfemale=fourgen
recode midfemale 1=0 2=1 3=0

gen femfemale=fourgen
recode femfemale 1/2=0 3=1


keep respid selfplacegen selfplacegenmiddle selfplacegenmid10 selfplacegenmid20 selfplacegenmid25 selfplacegenmid30/*
*/ otherplacegen otherplacegenmiddle genderid healthcarespending welfarespending layoffwomen/*
*/ socialprogs discrimjobs adaptmoral tradfamvalues wantworkfindjob womenhofc samesexmarriage/*
*/ abortion govinvolvement ideology leftright fedintent libintent consintent ndpintent greenintent/*
*/ woman degreeholder fulltimework union partnered religiousity income agecategory/*
*/ prov gender gencrossers newgender fourgen selfplacegenmiddlecross mascmale midmale midfemale femfemale 



save BC1.dta, replace


///AB, MB, ON, and NL have identical raw data files (same Q#s and everything), so here, combining them before coding them 

use Alberta.dta, clear
append using Manitoba.dta
append using Ontario.dta
append using Newfoundland.dta


save fourprovs.dta, replace


/*gender questions*/
/*100=feminine, 0=masculine*/

tab Q42
gen selfplacegen=Q42
tab selfplacegen
recode selfplacegen 80/998=.
replace selfplacegen=selfplacegen+50
tab selfplacegen
replace selfplacegen=selfplacegen*(-1)
tab selfplacegen
replace selfplacegen=selfplacegen+100
tab selfplacegen

gen selfplacegenmiddle=selfplacegen
tab selfplacegenmiddle
recode selfplacegenmiddle 0/10=0 11/89=1 90/100=0
tab selfplacegenmiddle



gen selfplacegenmid10=selfplacegenmiddle

gen selfplacegenmid20=selfplacegen
recode selfplacegenmid2 0/20=0 21/79=1 80/100=0
tab selfplacegenmid20

gen selfplacegenmid25=selfplacegen
recode selfplacegenmid25 0/25=0 26/74=1 75/100=0
tab selfplacegenmid25

gen selfplacegenmid30=selfplacegen
recode selfplacegenmid30 0/30=0 31/69=1 70/100=0
tab selfplacegenmid30



tab Q43
gen otherplacegen=Q43
tab otherplacegen
recode otherplacegen 80/998=.
replace otherplacegen=otherplacegen+50
tab otherplacegen
replace otherplacegen=otherplacegen*(-1)
tab otherplacegen
replace otherplacegen=otherplacegen+100
tab otherplacegen

gen otherplacegenmiddle=otherplacegen
tab otherplacegenmiddle
recode otherplacegenmiddle 0/10=0 11/89=1 90/100=0
tab otherplacegenmiddle

tab Q44
gen genderid=Q44
tab genderid
recode genderid 998=.
tab genderid



*recoding attitudes and issues variables*/
/*all coded on 0-1 scale so that 1=most liberal/progressive perspective*/

tab Q17A
gen healthcarespending=Q17A
tab healthcarespending
recode healthcarespending 1=0 2=0.5 3=1 97=.
tab healthcarespending

tab Q17B
gen welfarespending=Q17B
tab welfarespending
recode welfarespending 1=0 2=0.5 3=1 97=.
tab welfarespending

tab Q32B
gen layoffwomen=Q32B
tab layoffwomen
recode layoffwomen 4=0 3=1 2=2 1=3
replace layoffwomen=layoffwomen/3
tab layoffwomen

tab Q32C
gen socialprogs=Q32C
tab socialprogs
recode socialprogs 4=0 3=1 2=2 1=3
replace socialprogs=socialprogs/3
tab socialprogs

tab Q32E
gen discrimjobs=Q32E
tab discrimjobs
replace discrimjobs=discrimjobs-1
replace discrimjobs=discrimjobs/3
tab discrimjobs

tab Q32F
gen adaptmoral=Q32F
tab adaptmoral
replace adaptmoral=adaptmoral-1
replace adaptmoral=adaptmoral/3
tab adaptmoral

tab Q32G
gen tradfamvalues=Q32G
tab tradfamvalues
recode tradfamvalues 4=0 3=1 2=2 1=3
replace tradfamvalues=tradfamvalues/3
tab tradfamvalues

tab Q32I
gen wantworkfindjob=Q32I
tab wantworkfindjob
recode wantworkfindjob 4=0 3=1 2=2 1=3
replace wantworkfindjob=wantworkfindjob/3
tab wantworkfindjob

tab Q32K
gen womenhofc=Q32K
tab womenhofc
replace womenhofc=womenhofc-1
replace womenhofc=womenhofc/3
tab womenhofc

tab Q35
gen samesexmarriage=Q35
tab samesexmarriage
recode samesexmarriage 1=1 2=0 3=0.5
tab samesexmarriage
/*no opinion coded in the middle - it was a response option that 30% of sample chose*/

tab Q37
gen abortion=Q37
tab abortion
replace abortion=abortion-1
replace abortion=abortion/3
tab abortion

tab Q38
gen govinvolvement=Q38
tab govinvolvement
recode govinvolvement 2=0
tab govinvolvement

tab Q47
gen ideology=Q47
tab ideology
replace ideology=ideology-10
tab ideology
replace ideology=ideology*(-1)
tab ideology
replace ideology=ideology/10
tab ideology

gen leftright=ideology
recode leftright 0/0.4=0 .6/1=1
tab leftright

/*federal vote intention - so that it's a common question */

tab Q84
gen fedintent=Q84
tab fedintent

gen libintent=Q84
recode libintent 2/97=0
tab libintent

gen consintent=Q84
recode consintent 1=0 2=1 3/97=0
tab consintent

gen ndpintent=Q84
recode ndpintent 1/2=0 3=1 4/97=0
tab ndpintent

gen greenintent=Q84
recode greenintent 1/3=0 4=1 5/97=0
tab greenintent


/*demos*/


tab QT1C
gen woman=QT1C
tab woman
recode woman 1=0 2=1
tab woman

tab Q72
gen degreeholder=Q72
tab degreeholder
recode degreeholder 1/5=0 6=1 7=0 8/11=1
tab degreeholder

tab Q73
gen fulltimework=Q73
tab fulltimework
recode fulltimework 2=0 3=1 4/8=0
tab fulltimework

tab Q74
gen union=Q74
tab union
recode union 1/3=1 4=0
tab union

tab Q75
gen partnered=Q75
tab partnered
recode partnered 1=0 2=1 3=1 4/5=0
tab partnered

tab Q78
gen religiousity=Q78
tab religiousity
recode religiousity 6=0 5=1 4=2 3=3 2=4 1=5
replace religiousity=religiousity/5
tab religiousity

tab Q81
gen income=Q81
tab income
replace income=income-1
replace income=income/4
tab income

gen agecategory=QT1B
tab agecategory

gen gender=Q42
recode gender 80=. 998=.
tab gender


tab Q42
gen gencrossers=.
replace gencrossers=0 if woman==1 & gender<0
replace gencrossers=0 if woman==0 & gender>0
replace gencrossers=1 if woman==1 & gender>=1
replace gencrossers=1 if woman==0 & gender<0
tab gencrossers woman
replace gencrossers=. if gender==.
tab gencrossers woman


gen newgender=woman
replace newgender=0.5 if selfplacegenmiddle==1
tab newgender
replace newgender=0.5 if gencrossers==1
recode newgender 0.5=1 1=2
tab newgender

tab newgender woman

replace newgender=. if gencrossers==1
tab newgender

gen fourgen=newgender
recode fourgen 2=3
recode fourgen 1=2 if woman==1
tab fourgen

gen selfplacegenmiddlecross=selfplacegenmiddle
replace selfplacegenmiddlecross=1 if gencrossers==1
tab selfplacegenmiddlecross

tab selfplacegenmiddle gencrossers
replace selfplacegenmiddle=. if gencrossers==1
tab selfplacegenmiddle


gen mascmale=fourgen
recode mascmale 0=1 1/3=0

gen midmale=fourgen
recode midmale 2/3=0

gen midfemale=fourgen
recode midfemale 1=0 2=1 3=0

gen femfemale=fourgen
recode femfemale 1/2=0 3=1

save fourprovs.dta, replace


keep respid selfplacegen selfplacegenmiddle selfplacegenmid10 selfplacegenmid20 selfplacegenmid25 selfplacegenmid30/*
*/ otherplacegen otherplacegenmiddle genderid healthcarespending welfarespending layoffwomen/*
*/ socialprogs discrimjobs adaptmoral tradfamvalues wantworkfindjob womenhofc samesexmarriage/*
*/ abortion govinvolvement ideology leftright fedintent libintent consintent ndpintent greenintent/*
*/ woman degreeholder fulltimework union partnered religiousity income agecategory/*
*/ prov gender gencrossers newgender fourgen selfplacegenmiddlecross mascmale midmale midfemale femfemale 

save fourprovs.dta, replace

use fourprovs.dta, clear
append using Quebec1.dta
append using BC1.dta

save sixprovs.dta, replace



gen province=prov
tab province

recode province 2/4=. 8=. 12/99=.
tab province

gen NL=province
recode NL 5/10=0
tab NL

gen QC=province
recode QC 1=0 5=1 6/10=0

gen ON=province
recode ON 1/5=0 6=1 7/10=0
tab ON

gen MB=province
recode MB 1/6=0 7=1 9/10=0
tab MB

gen AB=province
recode AB 1/7=0 9=1 10=0
tab AB

gen BC=province
recode BC 1/9=0 10=1


recode province 1=10 5=24 6=35 7=46 9=48 10=59
tab province

save sixprovs.dta, replace
