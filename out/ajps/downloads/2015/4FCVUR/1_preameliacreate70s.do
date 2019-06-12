clear

use "NES72_76.dta", clear
set more off

drop if V764002==0
gen form1 = 0 
replace form1 = 1 if 10<=V720003 & V720003<=13
gen form2 = 0 
replace form2 = 1 if 20<=V720003 & V720003<=24

label define yesno 0 "No" 1 "Yes"

gen id = _n

**********************
** Survey difficulty, cooperation variables
**********************

gen cooperate72 = V720428
recode cooperate72 9=.
gen polsoph72 = V720429
recode polsoph72 9=.
gen intel72 = V720430
recode intel72 9=.
gen suspicious72 = V720431
recode suspicious72 3=2 5=3 9=.
gen interest72 = V720432
recode interest72 9=.
gen sincerity72 = V720435
recode sincerity72 9=.

gen cooperate74 = V742557
recode cooperate74 9=.
gen polsoph74 = V742558
recode polsoph74 9=.
gen intel74 = V742559
recode intel74 9=.
gen suspicious74 = V742560
recode suspicious74 3=2 5=3 9=.
gen interest74 = V742561
recode interest74 9=.
gen sincerity74 = V742562
recode sincerity74 9=.

gen cooperate76 = V763516
recode cooperate76 9=.
gen polsoph76 = V763517
recode polsoph76 9=.
gen intel76 = V763518
recode intel76 9=.
gen suspicious76 = V763519
recode suspicious76 3=2 5=3 9=.
gen interest76 = V763520
recode interest76 9=.
gen sincerity76 = V763521
recode sincerity76 9=.

tab polsoph76 polsoph72, col

gen votevalidate76 = V765012
recode votevalidate76 5=0 8/9=. 0=.
gen votevalidate74 = V765016
recode votevalidate74 5=0 8/9=. 0=.
gen votevalidate72 = V765020
recode votevalidate72 5=0 8/9=. 0=.
label values votevalidate76-votevalidate72 yesno

***********
** Voted
***********

** Voted in 72
tab  V720477

gen votedin72 = .
replace votedin72 = 0 if V720477==5
replace votedin72 = 1 if V720477==1
tab votedin72


** Voted in 74 
tab V742319

gen votedin74=.
replace votedin74=0 if  V742319==5
replace votedin74=1 if  V742319==1
tab votedin74

** Vote in 76
tab  V763655

gen votedin76 = .
replace votedin76 = 0 if V763655==5
replace votedin76 = 0 if V763665==7
replace votedin76 = 1 if V763655==1

tab votedin76

label values votedin72-votedin76 yesno

*******
** Thermometers
*******

** Dem Cand therm 72
tab V720703
** Dem therm 72
tab V720719

gen demcandtherm_pre72 = .
gen demcandtherm_post72 = .
replace demcandtherm_pre72 = V720254
replace demcandtherm_post72 = V720703
recode demcandtherm_pre72  98=. 99=.
recode demcandtherm_post72  98=. 99=.

gen demtherm72= .
replace demtherm72 = V720719
recode demtherm72  98=. 99=.

** Dem therm 74
tab V742364

gen demtherm74=.
replace demtherm74 = V742364
recode demtherm74 98=. 99=.
sum demtherm74

** Dem Cand Therm 76
tab V763298 
** Dem therm 76
tab V763833

gen demcandtherm76 = .
replace demcandtherm76 = V763298 
recode demcandtherm76 98=. 99=.
gen demtherm76 = .
replace demtherm76 = V763833
recode demtherm76 98=. 99=.
sum demtherm76 demcandtherm76

** Rep Cand therm 72
tab V720702
** Rep Therm 72
tab V720721

gen repcandtherm_pre72 = .
gen repcandtherm_post72 = .
replace repcandtherm_pre72 = V720255
replace repcandtherm_post72 = V720702
recode repcandtherm_pre72 98=. 99=.
recode repcandtherm_post72 98=. 99=.

gen reptherm72 = .
replace reptherm72 = V720721
recode reptherm72 98=. 99=.

** Rep therm 74
tab V742366

gen reptherm74=.
replace reptherm74 = V742366
recode reptherm74 98=. 99=.
sum reptherm74

** Rep Cand Therm 76
tab V763299
** Rep therm 76
tab V763835

gen repcandtherm76 = .
replace repcandtherm76 = V763299
recode repcandtherm76 98=. 99=.
gen reptherm76 = .
replace reptherm76 = V763835
recode reptherm76 98=. 99=.
sum reptherm76 repcandtherm76

** Other thermometers, these are coded for the purposes of predicting missing data

** Cand/Party Thermdiff

gen repthermdiff74 =reptherm74-reptherm72
gen repthermdiff76 = reptherm76-reptherm74
gen repthermdifffull = reptherm76-reptherm72

gen demthermdiff74 =demtherm74-demtherm72
gen demthermdiff76 = demtherm76-demtherm74
gen demthermdifffull =demtherm76-demtherm72

gen partythermdiff72 = demtherm72-reptherm72
gen partythermdiff74 = demtherm74-reptherm74
gen partythermdiff76 = demtherm76-reptherm76

gen fdpartythermdiff74 = partythermdiff74-partythermdiff72
gen fdpartythermdiff76 = partythermdiff76-partythermdiff74
gen fdpartythermdifffull = partythermdiff76-partythermdiff72

gen candthermdiff72=demcandtherm_post72-repcandtherm_post72
gen candthermdiff76=demcandtherm76-repcandtherm76

gen repcandthermdifffull = repcandtherm76-repcandtherm_post72
gen demcandthermdifffull = demcandtherm76-demcandtherm_post72
gen fdcandthermdifffull = candthermdiff76-candthermdiff72

drop repthermdiff74-fdpartythermdiff76
drop candthermdiff72-demcandthermdifffull

** Wallace therm 72, 3rd party cand
tab V720701

gen wallacetherm72 = .
replace wallacetherm72 = V720701
recode wallacetherm72 98=. 99=.

** Wallace therm 74
tab V742338

gen wallacetherm74 = .
replace wallacetherm74 = V742338
recode wallacetherm74 98=. 99=.


** Schmitz therm 72, 3rd party cand
*tab V720706

gen schmitztherm72 = .
replace schmitztherm72 = V720706
recode schmitztherm72 98=. 99=.

** Liberals 

gen liberalstherm72 = .
replace liberalstherm72 = V720709
recode liberalstherm72 98=. 99=.

gen liberalstherm74 = .
replace liberalstherm74 = V742358
recode liberalstherm74 98=. 99=.

gen liberalstherm76 = .
replace liberalstherm76 = V763823
recode liberalstherm76 98=. 99=.

** Conservatives 

gen conservtherm72 = .
replace conservtherm72 = V720724
recode conservtherm72 98=. 99=.

gen conservtherm74 = .
replace conservtherm74 = V720724
recode conservtherm74 98=. 99=.

gen conservtherm76 = .
replace conservtherm76 = V763838
recode conservtherm76 98=. 99=.

** Black therm

gen blackstherm72 = .
replace blackstherm72 = V720720
recode blackstherm72 98=. 99=.

gen blackstherm74 = .
replace blackstherm74 = V742365
recode blackstherm74 98=. 99=.


** Southerners

gen souththerm72 = .
replace souththerm72 = V720710
recode souththerm72 98=. 99=.

** Nixon therm 76
gen nixontherm76 = .
replace nixontherm76=V763307
recode nixontherm76 98=. 99=.

** Pres Approve
tab V720046
gen presapprove72 = .
replace presapprove72=1 if V720046==1
replace presapprove72=0 if V720046==5

tab V742157
gen presapprove74 = .
replace presapprove74=1 if V742157==1
replace presapprove74=0 if V742157==5

tab V763135
gen presapprove76 = .
replace presapprove76=1 if V763135==1
replace presapprove76=0 if V763135==5

label values presapprove72 presapprove74 presapprove76 yesno

** pardon approve
gen pardon74 = .
replace pardon74 = 0 if V742166==5
replace pardon74 = 1 if V742166==1

gen pardon76 = .
replace pardon76 = 0 if V763137==5
replace pardon76 = 1 if V763137==1

label values pardon74 pardon76 yesno

** econ conditions
gen econ72 = .
replace econ72 = 0 if V720507==3
replace econ72 = 1 if V720507==1
replace econ72 = -1 if V720507==5

gen econ76 = .
replace econ76 = 0 if V763139==3
replace econ76 = 1 if V763139==1
replace econ76 = -1 if V763139==5

label define econ -1 "Worse" 0 "Same" 1 "Better"
label values econ72 econ76 econ

** Preferences

gen pref72 = .
*Dem
replace pref72 = 1 if V720478==2
replace pref72 = 1 if V720478==4
*Rep
replace pref72 = 2 if V720478==1
replace pref72 = 2 if V720478==5
*Other
replace pref72 = 3 if V720478==3


gen pref76 = .
* Dem
replace pref76 = 1 if V763665==2
* Rep
replace pref76 = 2 if V763665==1
* Other
replace pref76 = 3 if V763665==3
replace pref76 = 3 if V763665==4
replace pref76 = 3 if V763665==5

label define prepref  0 "Undecided" 1 "Dem" 2 "Rep" 3 "Other"
label define pref  1 "Dem" 2 "Rep" 3 "Other"
label values pref72 pref76 pref


** Predictors

** intraelection swing
gen prepref72 =.
replace prepref72 = 1 if V720170==1
replace prepref72 = 1 if V720170==2
replace prepref72 = 0 if V720170==3
replace prepref72 = 0 if V720170==8
replace prepref72 = 2 if V720170==4
replace prepref72 = 2 if V720170==5
replace prepref72 = 3 if V720170==6
replace prepref72 = 3 if V720170==7
replace prepref72 = 1 if V720171==1
replace prepref72 = 1 if V720171==2
replace prepref72 = 0 if V720171==3
replace prepref72 = 0 if V720171==8
replace prepref72 = 2 if V720171==4
replace prepref72 = 2 if V720171==5


gen swing72 = .
replace swing72 = 0 if prepref72!=. & pref72!=.
*replace swing72 = 1 if prepref72==0
replace swing72 = 1 if prepref72==1 & pref72==2
replace swing72 = 1 if prepref72==1 & pref72==3
replace swing72 = 1 if prepref72==2 & pref72==1
replace swing72 = 1 if prepref72==2 & pref72==3
replace swing72 = 1 if prepref72==3 & pref72==1
replace swing72 = 1 if prepref72==3 & pref72==2

gen prepref76 =.
replace prepref76 = 1 if V763044==1
replace prepref76 = 1 if V763044==2
replace prepref76 = 0 if V763044==3
replace prepref76 = 0 if V763044==8
replace prepref76 = 2 if V763044==4
replace prepref76 = 2 if V763044==5
replace prepref76 = 3 if V763044==6
replace prepref76 = 3 if V763044==7
replace prepref76 = 1 if V763045==1
replace prepref76 = 1 if V763045==2
replace prepref76 = 0 if V763045==3
replace prepref76 = 0 if V763045==8
replace prepref76 = 2 if V763045==4
replace prepref76 = 2 if V763045==5
replace prepref76 = 3 if V763045==6
replace prepref76 = 3 if V763045==7

gen swing76 = .
replace swing76 = 0 if prepref76!=. & pref76!=.
*replace swing76 = 1 if prepref76==0
replace swing76 = 1 if prepref76==1 & pref76==2
replace swing76 = 1 if prepref76==1 & pref76==3
replace swing76 = 1 if prepref76==2 & pref76==1
replace swing76 = 1 if prepref76==2 & pref76==3
replace swing76 = 1 if prepref76==3 & pref76==1
replace swing76 = 1 if prepref76==3 & pref76==2

label values prepref72 prepref76 prepref
label values swing72 swing76 yesno

** Sex
gen female = 0 if V720424!=9
replace female=1 if V720424==2
replace female=0 if female==. & V742553!=9
replace female=1 if female==0 & V742553==2
replace female=0 if female==. & V763512!=9
replace female=1 if female==0 & V763512==2
label values female yesno

** race
gen black = 0 if V720425!=9
replace black=1 if V720425==2
replace black=0 if black==. & V742554!=9
replace black=1 if black==0 & V742554==2
replace black=0 if black==. & V763513!=9
replace black=1 if black==0 & V763513==2
label values black yesno

** catholic
gen catholic = 0 if V720422<999
replace catholic = 1 if V720422==200
label values catholic yesno

** Party ID, 7 Missing??, why?
gen pid72 = V720140
recode pid72 9=. 7=3 8=3
gen thirdparty72 = 0 if pid72!=.
replace thirdparty72 = 1 if V720140==7
gen apolitical72 = 0 if pid72!=.
replace apolitical72 = 1 if V720140==8

gen pid74 = V742204
recode pid74 9=. 7=3 8=3
gen thirdparty74 = 0 if pid74!=.
replace thirdparty74 = 1 if V742204==7
gen apolitical74 = 0 if pid74!=.
replace apolitical74 = 1 if V742204==8

gen pid76 = V763174
recode pid76 9=. 7=3 8=3
gen thirdparty76 = 0 if pid76!=.
replace thirdparty76 = 1 if V763174==7
gen apolitical76 = 0 if pid76!=.
replace apolitical76 = 1 if V763174==8

label define pid 0 "Strong Dem" 1 "Weak Dem" 2 "Lean Dem" 3 "Ind" 4 "Lean Rep" 5 "Weak Rep" 6 "Strong Rep"
label values pid72 pid74 pid76 pid



** Party Mentions
gen dempos72 = 0 if V720030!=0 & V720030<9
replace dempos72=1 if V720031a!=0 &  V720031a<9996
replace dempos72=2 if V720031b!=0 &  V720031b<9996
replace dempos72=3 if V720031c!=0 &  V720031c<9996
*replace dempos72=4 if V720031d!=0 &  V720031d<9996
*replace dempos72=5 if V720031e!=0 &  V720031e<9996
gen demneg72 = 0 if V720032!=0 & V720032<9
replace demneg72=1 if V720033a!=0 &  V720033a<9996
replace demneg72=2 if V720033b!=0 &  V720033b<9996
replace demneg72=3 if V720033c!=0 &  V720033c<9996
*replace demneg72=4 if V720033d!=0 &  V720033d<9996
*replace demneg72=5 if V720033e!=0 &  V720033e<9996

gen reppos72 = 0 if V720034!=0 & V720034<9
replace reppos72=1 if V720035a!=0 & V720035a<9996
replace reppos72=2 if V720035b!=0 & V720035b<9996
replace reppos72=3 if V720035c!=0 & V720035c<9996
*replace reppos72=4 if V720035d!=0 & V720035d<9996
*replace reppos72=5 if V720035e!=0 & V720035e<9996
gen repneg72 = 0 if V720036!=0 & V720034<9
replace repneg72=1 if V720037a!=0 & V720037a<9996
replace repneg72=2 if V720037b!=0 & V720037b<9996
replace repneg72=3 if V720037c!=0 & V720037c<9996
*replace repneg72=4 if V720037d!=0 & V720037d<9000
*replace repneg72=5 if V720037e!=0 & V720037e<9000


gen dempos76 = 0 if V763087!=9
replace dempos76=1 if V763088!=0 & V763088<=9995
replace dempos76=2 if V763089!=0 & V763089<=9995
replace dempos76=3 if V763090!=0 & V763090<=9995
replace dempos76=4 if V763091!=0 & V763091<=9995
replace dempos76=5 if V763092!=0 & V763092<=9995
gen demneg76 = 0 if V763093!=9
replace demneg76=1 if V763094!=0 & V763094<=9995
replace demneg76=2 if V763095!=0 & V763095<=9995
replace demneg76=3 if V763096!=0 & V763096<=9995
replace demneg76=4 if V763097!=0 & V763097<=9995
replace demneg76=5 if V763098!=0 & V763098<=9995

gen reppos76 = 0 if V763099!=9
replace reppos76=1 if V763100!=0 & V763100<=9995
replace reppos76=2 if V763101!=0 & V763101<=9995
replace reppos76=3 if V763102!=0 & V763102<=9995
replace reppos76=4 if V763103!=0 & V763103<=9995
replace reppos76=5 if V763104!=0 & V763104<=9995
gen repneg76 = 0 if V763105!=9
replace repneg76=1 if V763106!=0 & V763106<=9995
replace repneg76=2 if V763107!=0 & V763107<=9995
replace repneg76=3 if V763108!=0 & V763108<=9995
replace repneg76=4 if V763109!=0 & V763109<=9995
replace repneg76=5 if V763110!=0 & V763110<=9995


** Candidate ambiv
gen demcandpos72 = 0 if V720038!=0 & V720038<9
replace demcandpos72=1 if V720039a!=0 & V720039a<9996
replace demcandpos72=2 if V720039b!=0 & V720039b<9996
replace demcandpos72=3 if V720039c!=0 & V720039c<9996
*replace demcandpos72=4 if V720039d!=0 & V720039d<9996
*replace demcandpos72=5 if V720039e!=0 & V720039e<9996
gen demcandneg72 = 0  if V720040!=0 & V720040<9
replace demcandneg72=1 if V720041a!=0 & V720041a<9996
replace demcandneg72=2 if V720041b!=0 & V720041b<9996
replace demcandneg72=3 if V720041c!=0 & V720041c<9996
*replace demcandpos72=1 if V720041d!=0 & V720041d<9996
*replace demcandpos72=1 if V720041e!=0 & V720041e<9996

gen repcandpos72 = 0  if V720042!=0 & V720042<9
replace repcandpos72=1 if V720043a!=0 & V720043a<9996
replace repcandpos72=2 if V720043b!=0 & V720043b<9996
replace repcandpos72=3 if V720043c!=0 & V720043c<9996 
*replace repcandpos72=4 if V720043d!=0 & V720043d<9996
*replace repcandpos72=5 if V720043e!=0 & V720043e<9996
gen repcandneg72 = 0 if V720044!=0 & V720044<9
replace repcandneg72=1 if V720045a!=0 & V720045a<9996
replace repcandneg72=2 if V720045b!=0 & V720045b<9996
replace repcandneg72=3 if V720045c!=0 & V720045c<9996
*replace repcandneg72=4 if V720045d!=0 & V720045d<9996
*replace repcandneg72=5 if V720045e!=0 & V720045e<9996

gen demcandpos76 = 0 if V763111<9
replace demcandpos76=1 if V763112!=0 & V763112<=9995
replace demcandpos76=2 if V763113!=0 & V763113<=9995
replace demcandpos76=3 if V763114!=0 & V763114<=9995
replace demcandpos76=4 if V763115!=0 & V763115<=9995
replace demcandpos76=5 if V763116!=0 & V763116<=9995
gen demcandneg76 = 0 if V763117<9
replace demcandneg76=1 if V763118!=0 & V763118<=9995
replace demcandneg76=2 if V763119!=0 & V763119<=9995
replace demcandneg76=3 if V763120!=0 & V763120<=9995
replace demcandneg76=4 if V763121!=0 & V763121<=9995
replace demcandneg76=5 if V763122!=0 & V763122<=9995

gen repcandpos76 = 0 if V763123<9
replace repcandpos76=1 if V763124!=0 & V763124<=9995
replace repcandpos76=2 if V763125!=0 & V763125<=9995
replace repcandpos76=3 if V763126!=0 & V763126<=9995
replace repcandpos76=4 if V763127!=0 & V763127<=9995
replace repcandpos76=5 if V763128!=0 & V763128<=9995
gen repcandneg76 = 0 if V763129<9
replace repcandneg76=1 if V763130!=0 & V763130<=9995
replace repcandneg76=2 if V763131!=0 & V763131<=9995
replace repcandneg76=3 if V763132!=0 & V763132<=9995
replace repcandneg76=4 if V763133!=0 & V763133<=9995
replace repcandneg76=5 if V763134!=0 & V763134<=9995


** Mobilization

*gen partycontact72 = .
*replace partycontact72 = 0 if V720466==5
*replace partycontact72 = 1 if V720467==5
*replace partycontact72 = 2 if V720467==1
*replace partycontact72 = 3 if V720467==3
*gen partycontact76 = .
*replace partycontact76 = 0 if V763539==5
*replace partycontact76 = 1 if V763540==5
*replace partycontact76 = 2 if V763540==1
*replace partycontact76 = 3 if V763540==3
*replace partycontact76 = 3 if V763540==7


** Battleground

*gen battleground=0
*replace battleground = 1 if V600576==81
*replace battleground = 1 if V600576==21
*replace battleground = 1 if V600576==34
*replace battleground = 1 if V600576==71
*replace battleground = 1 if V600576==66
*replace battleground = 1 if V600576==12
*replace battleground = 1 if V600576==33
*replace battleground = 1 if V600576==11
*replace battleground = 1 if V600576==80
*replace battleground = 1 if V600576==49
*replace battleground = 1 if V600576==23
*replace battleground = 1 if V600576==65
*replace battleground = 1 if V600576==14
*replace battleground = 1 if V600576==73
*replace battleground = 1 if V600576==48
*replace battleground = 1 if V600576==64
*replace battleground = 1 if V600576==46
*replace battleground = 1 if V600576==43
*replace battleground = 1 if V600576==25
*replace battleground = 1 if V600576==47



** Media
*gen newspaper72 = 0 if V720456!=9 & V720456!=0
*replace newspaper72 = 1 if V720456==1
*gen radio72 = 0 if V720459!=9 & V720459!=0
*replace radio72 = 1 if V720459==1
*gen tv72 = 0 if V720463!=9 &  V720463!=0
*replace tv72=1 if V720463==1
*gen mag72 = 0 if V720461!=9 &  V720461!=0 
*replace mag72=1 if V720461==1

*label values newspaper72-mag72 yesno


*gen newspaper76 = 0 if V763645!=9 &  V763645!=0
*replace newspaper76 = 1 if  V763645==1
*gen radio76 = 0 if V763600!=9 &  V763600!=0
*replace radio76 = 1 if V763600==1
*gen tv76 = 0 if V763604!=9 &  V763604!=0
*replace tv76=1 if V763604==1
*gen mag76 = 0 if V763602!=9 & V763602!=0
*replace mag76=1 if V763602==1

*label values newspaper76-mag76 yesno


** Issues 72
* form1, Health Insurance, 95 DK/haven't thought
*tab V720208 if form1==1
* form2, Gov inflation, 63 DK/haven't thought
*tab V720190 if form2==1

* form1, gov see to job, 72 DK/haven't thought
tab V720172 if form1==1
gen haveopinion11 = 0 if form1==1
replace haveopinion11 = . if V720172==9
replace haveopinion11 = 1 if V720172>0 & V720172<=7
gen seediff11 = 0 if haveopinion11!=.
replace seediff11 = 1 if V720173!=0 & V720173!=V720174 & V720173!=8 & V720174!=8
replace seediff11 = . if V720173==9
replace seediff11 = . if V720174==9
* form1, tax rate scale, 74 DK/haven't thought
tab V720178 if form1==1
gen haveopinion12 = 0  if form1==1
replace haveopinion12 = . if V720178==9
replace haveopinion12 = 1 if V720178>0 & V720178<=7
gen seediff12 = 0 if haveopinion12!=.
replace seediff12 = 1 if V720179!=0 & V720179!=V720180 & V720179!=8 & V720180!=8
replace seediff12 = . if V720179==9
replace seediff12 = . if V720180==9

* form2, Vietnam withdrawal, 37 DK/haven't thought
tab V720184 if form2==1
replace haveopinion11 = 0 if form2==1 & V720184!=9
replace haveopinion11 = 1 if V720184>0 & V720184<=7
replace seediff11 = 0 if V720185==8
replace seediff11 = 0 if V720186==8
replace seediff11 = 0 if V720185==V720186
replace seediff11 = 1 if V720185!=0 & V720185!=V720186 & seediff11==.
replace seediff11 = . if V720185==9
replace seediff11 = . if V720186==9
* form2, Gov polution, 50 DK/haven't thought
tab V720214 if form2==1
replace haveopinion12 = 0 if form2==1 & V720214!=9
replace haveopinion12 = 1 if V720214>0 & V720214<=7
replace seediff12 = 0 if V720215==8
replace seediff12 = 0 if V720216==8
replace seediff12 = 0 if V720215==V720216
replace seediff12 = 1 if V720215!=0 & V720215!=V720216 & seediff12==.
replace seediff12 = . if V720215==9
replace seediff12 = . if V720216==9

* Marijuana, 61 Dk/Haven't thought
tab V720196
gen haveopinion13 = 0 if V720196<=8
replace haveopinion13 = 1 if V720196>=1 & V720196<=7
gen seediff13 = 0 if haveopinion13==0
replace seediff13 = 0 if V720197==8
replace seediff13 = 0 if V720198==8
replace seediff13 = 0 if V720198==V720197 & V720197<=8 & V720198<=8
replace seediff13 = 1 if 1<=V720198 & V720198<=7 & 1<=V720197 & V720197<=7 & V720197!=V720198
replace seediff13 = . if V720197==9
replace seediff13 = . if V720198==9

* School Busing, 60 DK/Haven't thought
tab V720202
gen haveopinion14 = 0 if V720202<=8
replace haveopinion14 = 1 if V720202>=1 & V720202<=7
gen seediff14 = 0 if haveopinion14==0
replace seediff14 = 0 if V720203==8
replace seediff14 = 0 if V720204==8
replace seediff14 = 0 if V720203==V720204 & V720203<=8 & V720204<=8
replace seediff14 = 1 if 1<=V720203 & V720203<=7 & 1<=V720204 & V720204<=7 & V720203!=V720204
replace seediff14 = . if V720203==9
replace seediff14 = . if V720204==9

* Women's rights, 45 DK/Haven't thought
tab V720232 
gen haveopinion15 = 0 if V720232<=8
replace haveopinion15 = 1 if V720232>=1 & V720232<=7
gen seediff15 = 0 if haveopinion15==0
replace seediff15 = 0 if V720233==8
replace seediff15 = 0 if V720234==8
replace seediff15 = 0 if V720233==V720234 & V720233<=8 & V720234<=8
replace seediff15 = 1 if 1<=V720233 & V720233<=7 & 1<=V720234 & V720234<=7 & V720233!=V720234
replace seediff15 = . if V720233==9
replace seediff15 = . if V720234==9

** Issues 76
* Guar job
tab V763241
gen haveopinion21 = 0 if V763241<=8 & V763004!=3
replace haveopinion21 =1 if V763241>0 & V763241<=7
gen seediff21 = 0 if haveopinion21 ==0
replace seediff21 = 0 if V763242==8
replace seediff21 = 0 if V763243==8
replace seediff21 = 0 if V763243==V763242 & V763243<=8 & V763242<=8
replace seediff21 = 1 if 1<=V763242 & V763242<=7 & 1<=V763243 & V763243<=7 & V763242!=V763243
replace seediff21 = . if V763242==9
replace seediff21 = . if V763243==9
replace seediff21 = . if haveopinion21==.

* Crime/Rights 
tab V763248
gen haveopinion22 = 0 if V763248<=8 & V763004!=3
replace haveopinion22 =1 if V763248>0 & V763248<=7
gen seediff22 = 0 if haveopinion22 ==0
replace seediff22 = 0 if V763249==8
replace seediff22 = 0 if V763250==8
replace seediff22 = 0 if V763249==V763250 & V763249<=8 & V763250<=8
replace seediff22 = 1 if 1<=V763249 & V763249<=7 & 1<=V763250 & V763250<=7 & V763249!=V763250
replace seediff22 = . if V763249==9
replace seediff22 = . if V763250==9
replace seediff22 = . if haveopinion22==.

* Bussing
tab V763257
gen haveopinion23 = 0 if V763257<=8 & V763004!=3
replace haveopinion23 =1 if V763257>0 & V763257<=7
gen seediff23 = 0 if haveopinion23 ==0
replace seediff23 = 0 if V763258==8
replace seediff23 = 0 if V763259==8
replace seediff23 = 0 if V763258==V763259 & V763258<=8 & V763259<=8
replace seediff23 = 1 if 1<=V763258 & V763258<=7 & 1<=V763259 & V763259<=7 & V763258!=V763259
replace seediff23 = . if V763258==9
replace seediff23 = . if V763259==9
replace seediff23 = . if haveopinion23==.

* Minority Aid
tab V763264
gen haveopinion24 = 0 if V763264<=8 & V763004!=3
replace haveopinion24 =1 if V763264>0 & V763264<=7
gen seediff24 = 0 if haveopinion24 ==0
replace seediff24 = 0 if V763265==8
replace seediff24 = 0 if V763266==8
replace seediff24 = 0 if V763265==V763266 & V763265<=8 & V763266<=8
replace seediff24 = 1 if 1<=V763265 & V763265<=7 & 1<=V763266 & V763266<=7 & V763265!=V763266
replace seediff24 = . if V763265==9
replace seediff24 = . if V763266==9
replace seediff24 = . if haveopinion24==.

* Medical insurance
tab V763273
gen haveopinion25 = 0 if V763273<=8 & V763004!=3
replace haveopinion25 =1 if V763273>0 & V763273<=7
gen seediff25 = 0 if haveopinion25 ==0
replace seediff25 = 0 if V763274==8
replace seediff25 = 0 if V763275==8
replace seediff25 = 0 if V763274==V763275 & V763274<=8 & V763275<=8
replace seediff25 = 1 if 1<=V763274 & V763274<=7 & 1<=V763275 & V763275<=7 & V763274!=V763275
replace seediff25 = . if V763274==9
replace seediff25 = . if V763275==9
replace seediff25 = . if haveopinion25==.


* Party perceptions
gen impdiff72 = 0 if form1==1 & V720498<=8
replace impdiff72 =1 if V720498==1
gen impdiff76 = 0 if V763184<=8
replace impdiff76 = 1 if V763184==1

tab V720499
gen conservparty72 = 0 if form1==1 & V720499<9
replace conservparty72 = -1 if V720500==1
replace conservparty72 = -1 if V720500==3
replace conservparty72 = 1 if V720500==2
replace conservparty72 = 1 if V720500==4
replace conservparty72 = . if V720500==9

tab V763193
gen conservparty76 = 0 if form1==1 & V763193<9
replace conservparty76 = -1 if V763194==1
replace conservparty76 = -1 if V763194==3
replace conservparty76 = 1 if V763194==2
replace conservparty76 = 1 if V763194==4
replace conservparty76 = . if V763194==9

** Efficacy

* have any say
gen efficacy1_72 = .
replace efficacy1_72 =0 if V720269==1
replace efficacy1_72 =1 if V720269==5
* too complicated
gen efficacy2_72 = .
replace efficacy2_72 =0 if V720271==1
replace efficacy2_72 =1 if V720271==5
* don't think public officials care
gen efficacy3_72 = .
replace efficacy3_72 =0 if V720272==1
replace efficacy3_72 =1 if V720272==5


gen efficacy1_76 = .
replace efficacy1_76 =0 if V763815==1
replace efficacy1_76 =1 if V763815==5
gen efficacy2_76 = .
replace efficacy2_76 =0 if V763817==1
replace efficacy2_76 =1 if V763817==5
gen efficacy3_76 = .
replace efficacy3_76 =0 if V763818==1
replace efficacy3_76 =1 if V763818==5
label values thirdparty72 apolitical72 thirdparty74 apolitical74 thirdparty76 apolitical76 efficacy1_72 efficacy2_72 efficacy3_72 efficacy1_76 efficacy2_76 efficacy3_76 yesno

** Age
gen age = V720294
recode age 0=.
replace age = V742406-2 if age==. & V742406!=0
replace age = V763369-4 if age==. & V763369!=0
*recode age 0=.
*replace age = age-18


** Education, seek achieved by 76

gen education72 = V720300
recode education72 98=. 99=.
recode education72 11/17=1 18=2 21=1 22=2 31/33=3 41/43=4 50/52=5 61=6 71=7 81=9 82/87=10
gen education = V763389 if V763389<98
replace education = education72 if education==.
drop education72

*gen gradeschool = 0 if education!=.
*replace gradeschool = 1 if education>=3 & education!=.

*gen highschool = 0 if education!=.
*replace highschool=1 if education>=5 & education!=.

*gen college = 0 if education!=.
*replace college = 1 if education>=7 & education!=.

*label values gradeschool highschool college yesno

** Income
gen income72 = V721095
recode income72 99=.
gen income76 = V763958
recode income76 98=. 99=.


** Region

gen south = 0 
replace south = 1 if V720005==4
replace south = 1 if V720005==5


gen midwest = 0 
replace midwest = 1 if V720005==2
replace midwest = 1 if V720005==3

label values south midwest yesno
*drop pid*

keep id-midwest
sort id
save observed70s.dta, replace


drop pref72 pref76 

** Ready for Amelia
save amelia70s.dta, replace
