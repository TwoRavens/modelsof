clear
use "anes2000to2004merged.dta"
set more off
label define yesno 0 "No" 1 "Yes"

gen id = _n

**********************
** Survey difficulty, cooperation variables
**********************


gen numbercallspre00 = M000027
gen numbervisitspre00 = M000028
gen numbercallspost00 = M000150
recode numbercallspost00 99=.
gen numbervisitspost00 = M000151
recode numbervisitspost00 99=.

gen numbercalls02 = M022003
gen numbercalls04 = M044004

gen interviewlength00 = M000010
replace interviewlength00 = . if interviewlength00>=999

gen interviewlength02 = M022018
replace interviewlength02 = . if M022018==0

gen interviewlength04 = M044016

gen conversion00 = 0 
replace conversion00 = 1 if M000022==1
label values conversion00 yesno

gen polsoph00 = M001033
recode polsoph00 0=.

gen cooperate00 = M001032
recode cooperate00 0=.

gen polsoph04 = M045202
recode polsoph04 0=.

gen cooperate04 = M045201
recode cooperate04 0=.

tab polsoph04 polsoph00, col
tab cooperate04 cooperate00, col


***********
** Voted
***********

** Voted in 00
tab M001241
tab  M001248

gen votedin00 = .
replace votedin00 = 0 if M001248==5
replace votedin00 = 0 if M001241==1
replace votedin00 = 0 if M001241==2
replace votedin00 = 0 if M001241==3
replace votedin00 = 1 if M001248==1

** Fill in with 2002 recall if missing
replace votedin00 = 0 if M023110==5 & votedin00==.
replace votedin00 = 1 if M023110==1 & votedin00==.

tab votedin00

** Voted in 02 
tab M025020

gen votedin02=.
replace votedin02=0 if  M025020==3
replace votedin02=1 if  M025020==1
replace votedin02=1 if  M025020==2

tab votedin02


** Vote in 04
tab M045045x

gen votedin04 = .
replace votedin04 = 0 if M045045x==5
replace votedin04 = 1 if M045045x==1

label values votedin00-votedin04 yesno


***************
** Preferences
***************

**2000

gen pref00 = .
*Dem
replace pref00 = 1 if M001249==1
replace pref00 = 1 if M001277==1
*Rep
replace pref00 = 2 if M001249==3
replace pref00 = 2 if M001277==3
*Other
replace pref00 = 3 if M001249==5
replace pref00 = 3 if M001249==6
replace pref00 = 3 if M001249==2
replace pref00 = 3 if M001249==4
replace pref00 = 3 if M001249==7
replace pref00 = 3 if M001277==5
replace pref00 = 3 if M001277==6
replace pref00 = 3 if M001277==7
** No Pref, Did not vote
replace pref00 = 4 if M001276==5

tab  M023111 pref00, col
tab M045003a pref00 , col

** Fill in 2000 with 2002 recall if 2000 post is missing
replace pref00 = 1 if M023111 == 1 & pref00==.
replace pref00 = 2 if M023111 == 3 & pref00==.
replace pref00 = 3 if M023111 == 5 & pref00==.
replace pref00 = 3 if M023111 == 7 & pref00==.


* Pre-pref

* Make 4 - does not intend to vote
gen prepref00 = .
replace prepref00 = 0 if M000793==8
replace prepref00 = 0 if M000795==8
* Dem
replace prepref00 = 1 if M000793==1
replace prepref00 = 1 if M000795==1
* Rep
replace prepref00 = 2 if M000793==2
replace prepref00 = 2 if M000795==2
* Other
replace prepref00 = 3 if M000793==3
replace prepref00 = 3 if M000795==3
replace prepref00 = 3 if M000793==4
replace prepref00 = 3 if M000795==4
replace prepref00 = 3 if M000793==7
replace prepref00 = 3 if M000795==7
* No intent
replace prepref00 = 0 if M000793==5
replace prepref00 = 0 if M000795==5

tab pref00 prepref00

label define prepref  0 "Undecided" 1 "Dem" 2 "Rep" 3 "Other"
label define pref  1 "Dem" 2 "Rep" 3 "Other" 4 "No Pref"
label values pref00 pref
label values prepref00 prepref 

**2004

gen pref04 = .
*Dem
replace pref04 = 1 if M045049a==1
*Rep
replace pref04 = 2 if M045049a==3
*Other
replace pref04 = 3 if M045049a==5
replace pref04 = 3 if M045049a==7
label values pref04 pref  


*******
** Thermometers
*******

** Dem Cand therm 00
tab M000360 
** Dem therm 00
tab M000369

gen demcandtherm_pre00 = .
gen demcandtherm_post00 = .
replace demcandtherm_pre00 = M000360
replace demcandtherm_post00 = M001293
replace demcandtherm_pre00= . if demcandtherm_pre00>100
replace demcandtherm_post00=. if demcandtherm_post00>100

gen demtherm00= .
replace demtherm00 = M000369
replace demtherm00 = . if demtherm00>100

** Dem Cand Therm 04
tab M045008

gen demcandtherm04 = M045008
replace demcandtherm04 =. if demcandtherm04>100

** Rep Cand therm 00
tab M000361 
** Rep Therm 00
tab M000370


gen repcandtherm_pre00 = M000361
gen repcandtherm_post00 = M001294
replace repcandtherm_pre00= . if repcandtherm_pre00>100
replace repcandtherm_post00= . if repcandtherm_post00>100

gen reptherm00 = M000370
replace reptherm00 = . if reptherm00>100

** Bush therm 02
gen repcandtherm02 = M023010 
replace repcandtherm02 = . if repcandtherm02>100
replace repcandtherm02 = M025043 if repcandtherm02==.

** Rep Cand Therm 20004
tab M045007
gen repcandtherm04 = M045007
replace repcandtherm04 = . if repcandtherm04>100


** Other thermometers, these are coded for the purposes of predicting missing data

** Cand/Party Thermdiff

gen repcandthermdifffull = repcandtherm04-repcandtherm_pre00
gen demcandthermdifffull =demcandtherm04-demcandtherm_pre00

gen candthermdiff00=demcandtherm_post00-repcandtherm_post00
gen candthermdiff04=demcandtherm04-repcandtherm04

gen fdcandthermdifffull = candthermdiff04-candthermdiff00


** Buchanan therm 00

gen buchanantherm00 = M000362
replace buchanantherm00 = . if buchanantherm00>100

* Reform Party

gen reformpartytherm = M000371
replace reformpartytherm = . if reformpartytherm>100

** Nader therm 00

gen nadertherm_pre00 = M000363
replace nadertherm_pre00 = . if nadertherm_pre00>100
gen nadertherm_post00 = M001295
replace nadertherm_post00 = . if nadertherm_post00>100
gen nadertherm_post04 = M045012
replace nadertherm_post04 = . if nadertherm_post04>100

** Liberals M025058 M045026

gen liberalstherm02 = M025058
replace liberalstherm02 = . if liberalstherm02>100

gen liberalstherm04 = M045026
replace liberalstherm04 = . if liberalstherm04>100

** Conservatives M025057 M045025

gen conservtherm02 = M025057
replace conservtherm02 = . if conservtherm02>100

gen conservtherm04 = M045025
replace conservtherm04 = . if conservtherm04>100

** 04 specific
gen fundtherm04 = M045032
replace fundtherm04 = . if fundtherm04>100
gen homotherm04 = M045035
replace homotherm04 = . if homotherm04>100
gen uniontherm04 = M045027
replace uniontherm04 = . if uniontherm04>100


** Clinton therm M000359 M023015 M045013

gen clintontherm00 = M000359
replace clintontherm00 = . if clintontherm00>100
gen clintontherm02 = M023015
replace clintontherm02 = . if clintontherm02>100
gen clintontherm04 = M045013
replace clintontherm04 = . if clintontherm04>100


** Military therm M001306 M045021

gen militarytherm00 = M001306 
replace militarytherm00 = . if militarytherm00>100
gen militarytherm02 = M045021 
replace militarytherm02 = . if militarytherm02>100

** Pres Approve M000341 M023006x M045005x

gen presapprove00 = M000341
replace presapprove00=. if presapprove00>7
gen presapprove02 = M023006X
replace presapprove02=. if presapprove02>7
gen presapprove04 = M045005x
replace presapprove04=. if presapprove04>7

label values presapprove00 presapprove02 presapprove04 yesno

** Iraq attitudes
gen iraqaction = M023123X
recode iraqaction 6=3 7=3 8=3 9=. 0=.
gen iraqworth = M045087
label values iraqworth yesno
recode iraqworth 5=0 8=. 9=.


** econ conditions

gen econ00 = M000491
replace econ00 = . if econ00>7
gen econ02 = M023028
replace econ02 = . if econ02>7
gen econ04 = M045091x
replace econ04 = . if econ04>7

gen betterworse00 = M001412a
replace betterworse00 = . if betterworse00>7

gen betterworse04 = M045089x
replace betterworse04 = . if betterworse04>7

**  Other predictors

gen bushwarterrorapprove = M045085x
recode bushwarterrorapprove 4=3 5=4 8=. 9=.

gen haveopinion21 = 0 if M045104<=8
replace haveopinion21 = 1 if M045104>0 & M045104<=7
gen diplomacyscale04 = M045104 if haveopinion21==1

gen haveopinion22 = 0 if M045110<=8
replace haveopinion22 = 1 if M045110<=7
gen abortion04 = M045110 if haveopinion22==1
recode abortion04 7=.

gen haveopinion23 = 0 if M045123x<=8
replace haveopinion23 = 1 if M045123x>=1 & M045123x<=7
gen favtaxcut04 = M045123x if haveopinion23==1
recode favtaxcut04 7=3

gen haveopinion24 = 0 if M045130<=8
replace haveopinion24 = 1 if M045130<=7
gen govserv04 = M045130 if haveopinion24==1

gen swing00 = .
replace swing00 = 0 if prepref00<=3 & pref00<=3
replace swing00 = 1 if prepref00==1 & pref00==2
replace swing00 = 1 if prepref00==1 & pref00==3
*replace swing00 = 1 if prepref00==1 & pref00==4

replace swing00 = 1 if prepref00==2 & pref00==1
replace swing00 = 1 if prepref00==2 & pref00==3
*replace swing00 = 1 if prepref00==2 & pref00==4

replace swing00 = 1 if prepref00==3 & pref00==1
replace swing00 = 1 if prepref00==3 & pref00==2
*replace swing00 = 1 if prepref00==3 & pref00==4

*replace swing00 = 1 if prepref00==4 & pref00==1
*replace swing00 = 1 if prepref00==4 & pref00==2
*replace swing00 = 1 if prepref00==4 & pref00==3

label values swing00 yesno

gen female= M001029
recode female 1=0 2=1
label values female yesno

gen black = 0 if M001006a!=. & M001006a<97
replace black = 0 if M001030==1
replace black = 1 if M001030==2
replace black = 1 if M001006a==10
replace black = 1 if M001006b==10
replace black = 1 if M001006c==10
label values black yesno

gen catholic = 0 if M000877!=0 & M000877!=9
replace catholic = 1 if M000882==2
replace catholic = . if M000882==8
replace catholic = . if M000882==9
replace catholic = 1 if M000883==2
replace catholic = . if M000883==8
replace catholic = . if M000883==9
label values catholic yesno

gen pid00 = M000523 if M000523<9
recode pid00 8=3 7=3
gen thirdparty00 = 0 if pid00!=.
replace thirdparty00 = 1 if M000523==7
label values thirdparty00 yesno
gen apolitical00 = 0 if pid00!=.
replace apolitical00 = 1 if M000523==8
label values apolitical00 yesno

gen pid02 = M023038X if M023038X<9
recode pid02 8=3 7=3
gen thirdparty02 = 0 if pid02!=.
replace thirdparty02 = 1 if M023038X==7
label values thirdparty02 yesno
gen apolitical02 = 0 if pid02!=.
replace apolitical02 = 1 if M023038X==8
label values apolitical02 yesno

gen pid04 = M045058x if M045058x<9
recode pid04 8=3 7=3
gen thirdparty04 = 0 if pid04!=.
replace thirdparty04 = 1 if M045058x==7
label values thirdparty04 yesno



** Party mentions

gen demcandpos00 = 0 if M000305>0 & M000305<9
replace demcandpos00 = demcandpos00+1 if M000306>0 & M000306<9995
replace demcandpos00 = demcandpos00+1 if M000307>0 & M000307<9995
replace demcandpos00 = demcandpos00+1 if M000308>0 & M000308<9995
replace demcandpos00 = demcandpos00+1 if M000309>0 & M000309<9995
replace demcandpos00 = demcandpos00+1 if M000310>0 & M000310<9995

gen demcandneg00 = 0 if M000311>0 & M000311<9
replace demcandneg00 = demcandneg00+1 if M000312>0 & M000312<9995
replace demcandneg00 = demcandneg00+1 if M000313>0 & M000313<9995
replace demcandneg00 = demcandneg00+1 if M000314>0 & M000314<9995
replace demcandneg00 = demcandneg00+1 if M000315>0 & M000315<9995
replace demcandneg00 = demcandneg00+1 if M000316>0 & M000316<9995

gen repcandpos00 = 0 if M000317>0 & M000317<9
replace repcandpos00 = repcandpos00+1 if M000318>0 & M000318<9995
replace repcandpos00 = repcandpos00+1 if M000319>0 & M000319<9995
replace repcandpos00 = repcandpos00+1 if M000320>0 & M000320<9995
replace repcandpos00 = repcandpos00+1 if M000321>0 & M000321<9995
replace repcandpos00 = repcandpos00+1 if M000322>0 & M000322<9995

gen repcandneg00 = 0 if M000323>0 & M000323<9
replace repcandneg00 = repcandneg00+1 if M000324>0 & M000324<9995
replace repcandneg00 = repcandneg00+1 if M000325>0 & M000325<9995
replace repcandneg00 = repcandneg00+1 if M000326>0 & M000326<9995
replace repcandneg00 = repcandneg00+1 if M000327>0 & M000327<9995
replace repcandneg00 = repcandneg00+1 if M000328>0 & M000328<9995

gen dempos00 = 0 if M000373>0 & M000373<9
replace dempos00 = dempos00+1 if M000374>0 & M000374<9995
replace dempos00 = dempos00+1 if M000375>0 & M000375<9995
replace dempos00 = dempos00+1 if M000376>0 & M000376<9995
replace dempos00 = dempos00+1 if M000377>0 & M000377<9995
replace dempos00 = dempos00+1 if M000378>0 & M000378<9995

gen demneg00 = 0 if M000379>0 & M000379<9
replace demneg00 = demneg00+1 if M000380>0 & M000380<9995
replace demneg00 = demneg00+1 if M000381>0 & M000381<9995
replace demneg00 = demneg00+1 if M000382>0 & M000382<9995
replace demneg00 = demneg00+1 if M000383>0 & M000383<9995
replace demneg00 = demneg00+1 if M000384>0 & M000384<9995

gen reppos00 = 0 if M000385>0 & M000385<9
replace reppos00 = reppos00+1 if M000386>0 & M000386<9995
replace reppos00 = reppos00+1 if M000387>0 & M000387<9995
replace reppos00 = reppos00+1 if M000388>0 & M000388<9995
replace reppos00 = reppos00+1 if M000389>0 & M000389<9995
replace reppos00 = reppos00+1 if M000390>0 & M000390<9995

gen repneg00 = 0 if M000391>0 & M000391<9
replace repneg00 = repneg00+1 if M000392>0 & M000392<9995
replace repneg00 = repneg00+1 if M000393>0 & M000393<9995
replace repneg00 = repneg00+1 if M000394>0 & M000394<9995
replace repneg00 = repneg00+1 if M000395>0 & M000395<9995
replace repneg00 = repneg00+1 if M000396>0 & M000396<9995


** party placement

gen impdiff00 = M001435
recode impdiff00 5=0 8=0 9=. 0=.
tab impdiff00


tab M001383 M001382, col

gen conservdem = M001382
recode conservdem 0=. 9=. 8=.
tab conservdem

gen conservdemdk = 0 if conservdem!=.
replace conservdemdk = 1 if M001382==8

gen conservrep = M001383
recode conservrep 0=. 9=. 8=.
tab conservrep
gen conservrepdk = 0 if conservrep!=.
replace conservrepdk = 1 if M001383==8

** Issue voting scale

* Gov serv/spending
gen haveopinion11 = 0 if M000550==0
replace haveopinion11 = 0 if M000550==8
replace haveopinion11 = 1 if M000550>=1 & M000550<=5
tab haveopinion11 M000550 [iw=WT00PRE], col

gen seediff11 = 0 if haveopinion11==0
replace seediff11 = 0 if M000557==8
replace seediff11 = 0 if M000561==8
replace seediff11 = . if M000557==9
replace seediff11 = . if M000561==9
replace seediff11 = 0 if M000563==8
replace seediff11 = 0 if M000567==8
replace seediff11 = . if M000563==9
replace seediff11 = . if M000567==9
replace seediff11 = 0 if M000557==M000563 & M000557>=1 & M000557<=7  & M000563>=1 & M000563<=7
replace seediff11 = 1 if M000557!=M000563 & M000557>=1 & M000557<=7  & M000563>=1 & M000563<=7
replace seediff11 = 0 if M000561==M000567 & M000561>=1 & M000561<=5  & M000567>=1 & M000567<=5
replace seediff11 = 1 if M000561!=M000567 & M000561>=1 & M000561<=5  & M000567>=1 & M000567<=5
replace seediff11 = 0 if haveopinion11==0
tab seediff11 haveopinion11
tab M000557 M000563 if seediff11==1
tab M000561 M000567 if seediff11==1


* Def. Spending
gen haveopinion12 = 0 if M000587==0
replace haveopinion12 = 0 if M000587==8
replace haveopinion12 = 1 if M000587>=1 & M000587<=5
tab haveopinion12 M000587 [iw=WT00PRE], col

gen seediff12 = 0 if haveopinion12==0
replace seediff12 = 0 if M000588==8
replace seediff12 = 0 if M000591==8
replace seediff12 = . if M000588==9
replace seediff12 = . if M000591==9
replace seediff12 = 0 if M000593==8
replace seediff12 = 0 if M000596==8
replace seediff12 = . if M000593==9
replace seediff12 = . if M000596==9
replace seediff12 = 0 if M000588==M000593 & M000588>=1 & M000588<=7  & M000593>=1 & M000593<=7
replace seediff12 = 1 if M000588!=M000593 & M000588>=1 & M000588<=7  & M000593>=1 & M000593<=7
replace seediff12 = 0 if M000591==M000596 & M000591>=1 & M000591<=5  & M000596>=1 & M000596<=5
replace seediff12 = 1 if M000591!=M000596 & M000591>=1 & M000591<=5  & M000596>=1 & M000596<=5
replace seediff12 = 0 if haveopinion12==0
tab seediff12 haveopinion12
tab M000588 M000593 if seediff12==1
tab M000591 M000596 if seediff12==1

* Gov Jobs/Std Living
gen haveopinion13 = 0 if M000620==0
replace haveopinion13 = 0 if M000620==8
replace haveopinion13 = 1 if M000620>=1 & M000620<=5
tab haveopinion13 M000620 [iw=WT00PRE], col

gen seediff13 = 0 if haveopinion13==0
replace seediff13 = 0 if M000621==8
replace seediff13 = 0 if M000624==8
replace seediff13 = . if M000621==9
replace seediff13 = . if M000624==9
replace seediff13 = 0 if M000626==8
replace seediff13 = 0 if M000629==8
replace seediff13 = . if M000626==9
replace seediff13 = . if M000629==9
replace seediff13 = 0 if M000621==M000626 & M000621>=1 & M000621<=7  & M000626>=1 & M000626<=7
replace seediff13 = 1 if M000621!=M000626 & M000621>=1 & M000621<=7  & M000626>=1 & M000626<=7
replace seediff13 = 0 if M000624==M000629 & M000624>=1 & M000624<=5  & M000629>=1 & M000629<=5
replace seediff13 = 1 if M000624!=M000629 & M000624>=1 & M000624<=5  & M000629>=1 & M000629<=5
replace seediff13 = 0 if haveopinion13==0

tab seediff13 haveopinion13
tab M000621 M000626 if seediff13==1
tab M000624 M000629 if seediff13==1

* Aid to blacks
gen haveopinion14 = 0 if M000645==0
replace haveopinion14 = 0 if M000645==8
replace haveopinion14 = 1 if M000645>=1 & M000645<=5
tab haveopinion14 M000645 [iw=WT00PRE], col

gen seediff14 = 0 if haveopinion14==0
replace seediff14 = 0 if M000651==8
replace seediff14 = 0 if M000654==8
replace seediff14 = . if M000651==9
replace seediff14 = . if M000654==9
replace seediff14 = 0 if M000656==8
replace seediff14 = 0 if M000659==8
replace seediff14 = . if M000656==9
replace seediff14 = . if M000659==9
replace seediff14 = 0 if M000651==M000656 & M000651>=1 & M000651<=7  & M000656>=1 & M000656<=7
replace seediff14 = 1 if M000651!=M000656 & M000651>=1 & M000651<=7  & M000656>=1 & M000656<=7
replace seediff14 = 0 if M000654==M000659 & M000654>=1 & M000654<=5  & M000659>=1 & M000659<=5
replace seediff14 = 1 if M000654!=M000659 & M000654>=1 & M000654<=5  & M000659>=1 & M000659<=5
replace seediff14 = 0 if haveopinion14==0

tab seediff14 haveopinion14
tab M000651 M000656 if seediff14==1
tab M000654 M000659 if seediff14==1

* Jobs/Environ
gen haveopinion15 = 0 if M000713==0
replace haveopinion15 = 0 if M000713==8
replace haveopinion15 = 1 if M000713>=1 & M000713<=5
tab haveopinion15 M000713 [iw=WT00PRE], col

gen seediff15 = 0 if haveopinion15==0
replace seediff15 = 0 if M000714==8
replace seediff15 = 0 if M000717==8
replace seediff15 = . if M000714==9
replace seediff15 = . if M000717==9
replace seediff15 = 0 if M000719==8
replace seediff15 = 0 if M000722==8
replace seediff15 = . if M000719==9
replace seediff15 = . if M000722==9
replace seediff15 = 0 if M000714==M000719 & M000714>=1 & M000714<=7  & M000719>=1 & M000719<=7
replace seediff15 = 1 if M000714!=M000719 & M000714>=1 & M000714<=7  & M000719>=1 & M000719<=7
replace seediff15 = 0 if M000717==M000722 & M000717>=1 & M000717<=5  & M000722>=1 & M000722<=5
replace seediff15 = 1 if M000717!=M000722 & M000717>=1 & M000717<=5  & M000722>=1 & M000722<=5
replace seediff15 = 0 if haveopinion15==0

tab seediff15 haveopinion15
tab M000714 M000719 if seediff15==1
tab M000717 M000722 if seediff15==1

* Women Equal Role
*gen haveopinion12 = 0 if M000760==0
*replace haveopinion12 = 0 if M000760==8
*replace haveopinion12 = 1 if M000760>=1 & M000760<=5
*tab haveopinion12 M000760 [iw=WT00PRE], col

*gen seediff12 = 0 if haveopinion12==0
*replace seediff12 = 0 if M000761==8
*replace seediff12 = 0 if M000764==8
*replace seediff12 = . if M000761==9
*replace seediff12 = . if M000764==9
*replace seediff12 = 0 if M000766==8
*replace seediff12 = 0 if M000769==8
*replace seediff12 = . if M000766==9
*replace seediff12 = . if M000769==9
*replace seediff12 = 0 if M000761==M000766 & M000761>=1 & M000761<=7  & M000766>=1 & M000766<=7
*replace seediff12 = 1 if M000761!=M000766 & M000761>=1 & M000761<=7  & M000766>=1 & M000766<=7
*replace seediff12 = 0 if M000764==M000769 & M000764>=1 & M000764<=5  & M000769>=1 & M000769<=5
*replace seediff12 = 1 if M000764!=M000769 & M000764>=1 & M000764<=5  & M000769>=1 & M000769<=5
*replace seediff12 = 0 if haveopinion12==0
*tab seediff12 haveopinion12

* Enviro Regulations
*gen haveopinion17 = 0 if M000776==0
*replace haveopinion17 = 0 if M000776==8
*replace haveopinion17 = 1 if M000776>=1 & M000776<=5
*tab haveopinion17 M000776 [iw=WT00PRE], col
*gen seediff17 = 0 if haveopinion17==0
*replace seediff17 = 0 if M000778==8
*replace seediff17 = 0 if M000782==8
*replace seediff17 = . if M000778==9
*replace seediff17 = . if M000782==9
*replace seediff17 = 0 if M000785==8
*replace seediff17 = 0 if M000789==8
*replace seediff17 = . if M000785==9
*replace seediff17 = . if M000789==9
*replace seediff17 = 0 if M000778==M000785 & M000778>=1 & M000778<=7  & M000785>=1 & M000785<=7
*replace seediff17 = 1 if M000778!=M000785 & M000778>=1 & M000778<=7  & M000785>=1 & M000785<=7
*replace seediff17 = 0 if M000782==M000789 & M000782>=1 & M000782<=5  & M000789>=1 & M000789<=5
*replace seediff17 = 1 if M000782!=M000789 & M000782>=1 & M000782<=5  & M000789>=1 & M000789<=5
*replace seediff17 = 0 if haveopinion17==0
*tab seediff17 haveopinion17


** Efficacy

** officials don't care
gen efficacy1_00 = M001527 if M001527<8 & M001527!=0
** Have any say
gen efficacy2_00 = M001528 if M001528<8 & M001528!=0
** too complicated
gen efficacy3_00 = M001529 if M001529<8 & M001529!=0

** officials don't care
gen efficacy1_04 = M045147 if M045147<=5
recode efficacy1_04 1=0 3=1 5=2
** Have any say
gen efficacy2_04 = M045148 if M045148<=5
recode efficacy2_04 1=0 3=1 5=2


** church attendance
gen attend00 = 0 if M000877==5
replace attend00 = -1*(M000879-5) if M000877==1 & M000879>=1 & M000879<=5
gen attend04 = 0 if M045174==5
replace attend04 = -1*(M045174a-5) if M045174==1 & M045174a<8

** Age, 2000
gen age = M000908
recode age 00=.

** Education
gen education00 = M000913
recode education00 8=. 9=.
gen education02 = M023131
recode education02 9=. 0=.
replace education00 = education02 if education00==. & education02!=.
replace education00 = education02 if education02>education00 & education02!=.
drop education02
rename education00 education

** Income
gen income00 = M000994
replace income00=. if M000994>97
replace income00=. if M000994==0

gen income02 = M023149
replace income02=. if M023149>9
replace income02=. if M023149==0
recode income02 8=3 9=5

gen income04 = M045180x
recode income04 8=3 9=5 88=. 89=.

** Region
gen south = 0
replace south=1 if M000092==3
gen midwest = 0
replace midwest=1 if M000092==2
gen west = 0 
replace west = 1 if M000092==4
label values south midwest west yesno


keep VERSION-WT04 id-west

save observed00s.dta, replace

tab pref00 pref04

drop VERSION-WT04 pref00 pref04
** Ready for Amelia
save amelia00s.dta, replace
