clear

use "anes_mergedfile_1992to1997.dta", clear
set more off

drop if VPARTIC>40
gen id = VID92
gen weight = V923008b
*gen state = V923017
*replace state = .  if V923017==99
label define yesno 0 "No" 1 "Yes"

**********************
** Survey difficulty, cooperation variables
**********************

tab V924204
gen precooperate92 = V924204
recode precooperate92 9=.
tab V926249
gen postcooperate92 = V926249
recode postcooperate92 9=.

tab V924205
gen prepolsoph92 = V924205
recode prepolsoph92 9=.
tab V926250
gen postpolsoph92 = V926250
recode postpolsoph92 9=.

tab V924206
gen intel92 = V924206
recode intel92 9=.
tab V924207
gen suspicious92 = V924207
recode suspicious92 3=2 5=3 9=.
tab V924208
gen interest92 = V924208
recode interest92 9=.
tab V924209
gen sincerity92 = V924209
recode sincerity92 9=.

*tab V923052
*gen prerefuse92 = V923052
*recode prerefuse92 5=0 9=. 
*tab V925027
*gen postrefuse92 = V925027
*recode postrefuse92 5=0 9=. 
*tab V925028
*gen break92 = V925028
*recode break92 9=.


tab V941437
gen cooperate94 = V941437
recode cooperate94 9=.
tab V941438
gen polsoph94 = V941438
recode polsoph94 9=.
tab V941439
gen intel94 = V941439
recode intel94 9=.
tab V941440
gen suspicious94 = V941440
recode suspicious94 3=2 5=3 9=.
tab V941441
gen interest94 = V941441
recode interest94 9=.
tab V941442
gen sincerity94 = V941442
recode sincerity94 9=.

*tab V940081
*gen refuse94 = V940081
*recode refuse94 5=0 9=. 
*tab refuse94 V940092
*tab V940082
*gen break94 = V940082
*recode break94 9=.


tab V960069
gen precooperate96 = V960069
recode precooperate96 9=.
tab V960939
gen postcooperate96 = V960939
recode postcooperate96 9=.

tab V960070
gen prepolsoph96 = V960070
recode prepolsoph96 9=.
tab V960940
gen postpolsoph96 = V960940
recode postpolsoph96 9=.

tab V960941
gen intel96 = V960941
recode intel96 9=. 0=.
tab V960942
gen suspicious96 = V960942
recode suspicious96 0=. 3=2 5=3 9=.
tab V960943
gen interest96 = V960943
recode interest96 0=. 9=.
tab V960944
gen sincerity96 = V960944
recode sincerity96 0=. 9=.

tab prepolsoph96 prepolsoph92, col


***********
** Voted
***********

** Voted Pres in 92
tab V925601 
tab V925608

gen votedin92 = .
replace votedin92 = 0 if V925601==5
replace votedin92 = 0 if V925608==5
replace votedin92 = 1 if V925608==1
tab votedin92 V925601


** Voted in 94
tab V940601

gen votedin94=.
replace votedin94=0 if  V940601==5
replace votedin94=1 if  V940601==1
tab votedin94

** Vote in 96
tab V961074 
tab V961081

gen votedin96 = .
replace votedin96 = 0 if V961074==5
replace votedin96 = 0 if V961081==5
replace votedin96 = 1 if V961081==1
tab votedin96 V961074

label values votedin92-votedin96 yesno


** 93 opinions

* Approval
tab V937104
gen presapprove93 = V937104
recode presapprove93 0=. 7=2 4=3 5=4 8=3

* Clinton therm
gen clintontherm93 = .
replace clintontherm93 = V937130 if V937130<101

* Perot therm
gen perottherm93 = .
replace perottherm93 = V937131 if V937131<101

* Limbaugh therm
gen limbaughtherm93 = .
replace limbaughtherm93 = V937139 if V937139<101

* therm dem party
gen demtherm93 = .
replace demtherm93 = V937141 if V937141<101

* therm rep party
gen reptherm93 = .
replace reptherm93 = V937142 if V937142<101

* therm parties 
gen partiestherm93 = .
replace partiestherm93 = V937143 if V937143<101

* Hypo vote
tab V937161
gen hypovote93 = V937161
recode hypovote93 0=. 9=. 3=2 5=3 7=0 8=0
tab hypovote93 V937161


** Econ/Finances 93
gen persfin93 = V937241
recode persfin93 7=2 8=4 0=.

* retrospective
gen natecon93 = V937253
recode natecon93 7=2 8=4 0=.

* Congress approval
gen congressapp93 = V937300
recode congressapp93 0=. 7=2 4=3 5=4 8=3

** Health insurance
gen healthins93 = V937373
recode healthins93 0=. 7=2 4=3 8=3 5=4




*******
** Thermometers
*******


** Dem Cand therm 72
tab V923306
** Dem therm 72
tab V923317

gen demcandtherm_pre92 = .
gen demcandtherm_post92 = .
replace demcandtherm_pre92 = V923306 if V923306<101
replace demcandtherm_post92 = V925302 if V925302<101

gen demtherm92= .
replace demtherm92 = V923317 if V923317<101

** Dem therm 94
tab V940301 

gen demtherm94=.
replace demtherm94 = V940301 if V940301<101

** Dem Cand Therm 76
tab V960272
** Dem therm 76
tab V960292

gen demcandtherm_pre96 = .
replace demcandtherm_pre96 = V960272 if V960272 <101
gen demcandtherm_post96 = .
replace demcandtherm_post96 = V961019  if V961019  <101
 
gen demtherm96 = .
replace demtherm96 = V960292 if V960292<101


** Rep Cand therm 92
tab V923305
** Rep Therm 92
tab V923318 

gen repcandtherm_pre92 = .
gen repcandtherm_post92 = .
replace repcandtherm_pre92 = V923305 if V923305<101
replace repcandtherm_post92 = V925301 if V925301<101

gen reptherm92 = .
replace reptherm92 = V923318 if V923318<101

** Rep therm 94
tab V940302

gen reptherm94=.
replace reptherm94 = V940302 if V940302<101



** Rep Cand Therm 76
tab V960273 
** Rep therm 76
tab V960293

gen repcandtherm_pre96 = .
gen repcandtherm_post96 = .
replace repcandtherm_pre96 = V960273  if V960273 <101
replace repcandtherm_post96 = V961020   if V961020 <101

gen reptherm96 = .
replace reptherm96 = V960293 if V960293<101
		
		
** Other thermometers, these are coded for the purposes of predicting missing data

** Cand/Party Thermdiff

gen repthermdiff94 =reptherm94-reptherm92
gen repthermdiff96 = reptherm96-reptherm94
gen repthermdifffull = reptherm96-reptherm92

gen demthermdiff94 =demtherm94-demtherm92
gen demthermdiff96 = demtherm96-demtherm94
gen demthermdifffull =demtherm96-demtherm92

gen partythermdiff92 = demtherm92-reptherm92
gen partythermdiff94 = demtherm94-reptherm94
gen partythermdiff96 = demtherm96-reptherm96

gen fdpartythermdiff94 = partythermdiff94-partythermdiff92
gen fdpartythermdiff96 = partythermdiff96-partythermdiff94
gen fdpartythermdifffull = partythermdiff96-partythermdiff92

gen candthermdiff92=demcandtherm_post92-repcandtherm_post92
gen candthermdiff96=demcandtherm_post96-repcandtherm_post96

gen repcandthermdifffull = repcandtherm_post96-repcandtherm_post92
gen demcandthermdifffull = demcandtherm_post96-demcandtherm_post92
gen fdcandthermdifffull = candthermdiff96-candthermdiff92

drop repthermdiff94-fdpartythermdiff96
drop candthermdiff92-demcandthermdifffull

** Perot therm 92, 3rd party cand
tab V923307 

gen perottherm_pre92 = .
replace perottherm_pre92 = V923307 if V923307<101
gen perottherm_post92 = .
replace perottherm_post92 = V925303 if V925303<101

gen perottherm94 = .
replace perottherm94 = V940224 if V940224 <101

gen perottherm_pre96 = .
replace perottherm_pre96 = V960274 if V960274<101
gen perottherm_post96 = .
replace perottherm_post96 = V961021  if V961021<101

** Liberals 

gen liberalstherm92 = .
replace liberalstherm92 = V925326 if V925326<101

gen liberalstherm94 = .
replace liberalstherm94 = V940311 if V940311<101

gen liberalstherm96 = .
replace liberalstherm96 = V961032 if V961032<101

** Conservatives 

gen conservtherm92 = .
replace conservtherm92 = V925319 if V925319<101

gen conservtherm94 = .
replace conservtherm94 = V940306 if V940306<101

gen conservtherm96 = .
replace conservtherm96 = V961031 if V961031<101


** Black therm

gen blackstherm92 = .
replace blackstherm92 = V925323 if V925323<101

gen blackstherm94 = .
replace blackstherm94 = V940305 if V940305<101

gen blackstherm96 = .
replace blackstherm96 = V961029 if V961029<101

** Homosexuals

gen homotherm92 = .
replace homotherm92 = V925335 if V925335<101

gen homotherm94 = .
replace homotherm94 = V940318 if V940318<101

gen homotherm96 = .
replace homotherm96 = V961042 if V961042<101

** Fed Gov Therm
gen fedgovtherm92 =.
replace fedgovtherm92 = V925325 if V925325<101

gen fedgovtherm96 =.
replace fedgovtherm96 = V961028 if V961028<101

** Clinton therm 94

gen clintontherm94 = .
replace clintontherm94=V940223 if V940223 <101

** Dole therm 94

gen doletherm94 = .
replace doletherm94 = V940225 if V940225<101


** Pres Approve
tab V923320 V923319 
gen presapprove92 = V923320
recode presapprove92 1=4 2=3 4=2 5=1 8=. 9=. 0=.
replace presapprove92 = 2 if V923319==5 & presapprove92==.
replace presapprove92 = 3 if V923319==1 & presapprove92==.

tab V940202 V940201
gen presapprove94 = V940202
recode presapprove94 1=4 2=3 4=2 5=1 8=. 9=. 0=.
replace presapprove94 = 2 if V940201==5 & presapprove94==.
replace presapprove94 = 3 if V940201==1 & presapprove94==.

tab V960296  V960295
gen presapprove96 = V960296
recode presapprove96 1=4 2=3 4=2 5=1 8=. 9=. 0=.
replace presapprove96 = 2 if V960295==5 & presapprove96==.
replace presapprove96 = 3 if V960295==1 & presapprove96==.


** econ conditions

gen econ92 = .
replace econ92 = 0 if V926148 ==3
replace econ92 = 1 if V926148==1
replace econ92 = -1 if V926148==5

gen econ94 = .
replace econ94 = 0 if V940908  ==3
replace econ94 = 1 if V940908 ==1
replace econ94 = -1 if V940908 ==5

gen econ96 = .
replace econ96 = 0 if V960385==3
replace econ96 = 1 if V960385==1
replace econ96 = -1 if V960385==5

label define econ -1 "Worse" 0 "Same" 1 "Better"
label values econ92 econ94 econ96 econ



** Preferences

tab V925609
tab V925634

gen pref92 = .
*Dem
replace pref92 = 1 if V925609==2
replace pref92 = 1 if V925634==2
*Rep
replace pref92 = 2 if V925609==1
replace pref92 = 2 if V925634==1
*Other
replace pref92 = 3 if V925609==3
replace pref92 = 3 if V925609==7
replace pref92 = 3 if V925634==3
replace pref92 = 3 if V925634==7

** only 6 respondents reported no preference in both 92 and 96

tab V961082
tab V961099

gen pref96 = .
*Dem
replace pref96 = 1 if V961082==1
replace pref96 = 1 if V961099==1
*Rep
replace pref96 = 2 if V961082==2
replace pref96 = 2 if V961099==3
*Other
replace pref96 = 3 if V961082==3
replace pref96 = 3 if V961082==7
replace pref96 = 3 if V961099==5

tab pref96 pref92, col

label define prepref  0 "Undecided" 1 "Dem" 2 "Rep" 3 "Other"
label define pref  1 "Dem" 2 "Rep" 3 "Other"
label values pref92 pref96 pref


** Predictors

** intraelection swing
tab V923805
tab V923807
gen prepref92 =.
replace prepref92 = 1 if V923805==2
replace prepref92 = 1 if V923807==2
replace prepref92 = 0 if V923805==8
replace prepref92 = 0 if V923807==8
replace prepref92 = 2 if V923805==1
replace prepref92 = 2 if V923807==1
replace prepref92 = 3 if V923805==5
replace prepref92 = 3 if V923807==5
replace prepref92 = 3 if V923805==7
replace prepref92 = 3 if V923807==7


gen swing92 = .
replace swing92 = 0 if prepref92!=. & pref92!=.
replace swing92 = 1 if prepref92==1 & pref92==2
replace swing92 = 1 if prepref92==1 & pref92==3
replace swing92 = 1 if prepref92==2 & pref92==1
replace swing92 = 1 if prepref92==2 & pref92==3
replace swing92 = 1 if prepref92==3 & pref92==1
replace swing92 = 1 if prepref92==3 & pref92==2

tab V960548
tab V960550

gen prepref96 =.
replace prepref96 = 1 if V960548==1
replace prepref96 = 1 if V960550==1
replace prepref96 = 0 if V960548==5
replace prepref96 = 0 if V960548==8
replace prepref96 = 0 if V960550==5
replace prepref96 = 0 if V960550==8
replace prepref96 = 2 if V960548==2
replace prepref96 = 2 if V960550==2
replace prepref96 = 3 if V960548==3
replace prepref96 = 3 if V960548==7
replace prepref96 = 3 if V960550==3
replace prepref96 = 3 if V960550==7

gen swing96 = .
replace swing96 = 0 if prepref96!=. & pref96!=.
replace swing96 = 1 if prepref96==1 & pref96==2
replace swing96 = 1 if prepref96==1 & pref96==3
replace swing96 = 1 if prepref96==2 & pref96==1
replace swing96 = 1 if prepref96==2 & pref96==3
replace swing96 = 1 if prepref96==3 & pref96==1
replace swing96 = 1 if prepref96==3 & pref96==2

label values prepref92 prepref96 prepref
label values swing92 swing96 yesno



** Sex
tab V924201
gen female = 0 if V924201!=9
replace female=1 if V924201==2

label values female yesno

** race
gen black = 0 if V924202!=9
replace black=1 if V924202==2

label values black yesno

** catholic
gen catholic = 0 if V923850<998
replace catholic = 1 if V923850==400
label values catholic yesno


** Party ID, 7 Missing??, why?
gen pid92 = V923634
recode pid92 9=. 7=3 8=3
gen thirdparty92 = 0 if pid92!=.
replace thirdparty92 = 1 if V923634==7
gen apolitical92 = 0 if pid92!=.
replace apolitical92 = 1 if V923634==8

gen pid93 = V937370
recode pid93 9=. 7=3 8=3
gen thirdparty93 = 0 if pid92!=.
replace thirdparty93 = 1 if V937370==7
gen apolitical93 = 0 if pid92!=.
replace apolitical93 = 1 if V937370==8

gen pid94 = V940655
recode pid94 9=. 7=3 8=3
gen thirdparty94 = 0 if pid94!=.
replace thirdparty94 = 1 if V940655==7
gen apolitical94 = 0 if pid94!=.
replace apolitical94 = 1 if V940655==8

gen pid96 = V960420 
recode pid96 9=. 7=3 8=3
gen thirdparty96 = 0 if pid96!=.
replace thirdparty96 = 1 if V960420==7
gen apolitical96 = 0 if pid96!=.
replace apolitical96 = 1 if V960420==8

label define pid 0 "Strong Dem" 1 "Weak Dem" 2 "Lean Dem" 3 "Ind" 4 "Lean Rep" 5 "Weak Rep" 6 "Strong Rep"
label values pid92 pid93 pid94 pid96 pid
label values thirdparty92 apolitical92 thirdparty94 apolitical94 thirdparty96 apolitical96 yesno



** Party Mentions
gen dempos92 = 0 if V923401!=0 & V923401<9
replace dempos92=dempos92+1 if  V923402!=0 &   V923402<9998
replace dempos92=dempos92+1 if  V923403!=0 &   V923403<9998
replace dempos92=dempos92+1 if  V923404!=0 &   V923404<9998
replace dempos92=dempos92+1 if  V923405!=0 &   V923405<9998
replace dempos92=dempos92+1 if  V923406!=0 &   V923406<9998
gen demneg92 = 0 if V923407!=0 & V923407<9
replace demneg92=demneg92+1 if  V923408!=0 &   V923408<9998
replace demneg92=demneg92+1 if  V923409!=0 &   V923409<9998
replace demneg92=demneg92+1 if  V923410!=0 &   V923410<9998
replace demneg92=demneg92+1 if  V923411!=0 &   V923411<9998
replace demneg92=demneg92+1 if  V923412!=0 &   V923412<9998

gen reppos92 = 0 if V923413!=0 & V923413<9
replace reppos92=reppos92+1 if  V923414!=0 &   V923414<9998
replace reppos92=reppos92+1 if  V923415!=0 &   V923415<9998
replace reppos92=reppos92+1 if  V923416!=0 &   V923416<9998
replace reppos92=reppos92+1 if  V923417!=0 &   V923417<9998
replace reppos92=reppos92+1 if  V923418!=0 &   V923418<9998
gen repneg92 = 0 if V923419!=0 & V923419<9
replace repneg92=repneg92+1 if  V923420!=0 &   V923420<9998
replace repneg92=repneg92+1 if  V923421!=0 &   V923421<9998
replace repneg92=repneg92+1 if  V923422!=0 &   V923422<9998
replace repneg92=repneg92+1 if  V923423!=0 &   V923423<9998
replace repneg92=repneg92+1 if  V923424!=0 &   V923424<9998

gen dempos96 = 0 if V960325!=0 & V960325<9
replace dempos96=dempos96+1 if  V960326!=0 &   V960326<9998
replace dempos96=dempos96+1 if  V960327!=0 &   V960327<9998
replace dempos96=dempos96+1 if  V960328!=0 &   V960328<9998
replace dempos96=dempos96+1 if  V960329!=0 &   V960329<9998
replace dempos96=dempos96+1 if  V960330!=0 &   V960330<9998
gen demneg96 = 0 if V960331!=0 & V960331<9
replace demneg96=demneg96+1 if  V960332!=0 &   V960332<9998
replace demneg96=demneg96+1 if  V960333!=0 &   V960333<9998
replace demneg96=demneg96+1 if  V960334!=0 &   V960334<9998
replace demneg96=demneg96+1 if  V960335!=0 &   V960335<9998
replace demneg96=demneg96+1 if  V960336!=0 &   V960336<9998

gen reppos96 = 0 if V960313!=0 & V960313<9
replace reppos96=reppos96+1 if  V960314!=0 &   V960314<9998
replace reppos96=reppos96+1 if  V960315!=0 &   V960315<9998
replace reppos96=reppos96+1 if  V960316!=0 &   V960316<9998
replace reppos96=reppos96+1 if  V960317!=0 &   V960317<9998
replace reppos96=reppos96+1 if  V960318!=0 &   V960318<9998

gen repneg96 = 0 if V960319!=0 & V960319<9
replace repneg96=repneg96+1 if  V960320!=0 &   V960320<9998
replace repneg96=repneg96+1 if  V960321!=0 &   V960321<9998
replace repneg96=repneg96+1 if  V960322!=0 &   V960322<9998
replace repneg96=repneg96+1 if  V960323!=0 &   V960323<9998
replace repneg96=repneg96+1 if  V960324!=0 &   V960324<9998

** Candidate ambiv

gen demcandpos92 = 0 if V923121!=0 & V923121<9
replace demcandpos92=demcandpos92+1 if V923122!=0 & V923122<9998
replace demcandpos92=demcandpos92+1 if V923123!=0 & V923123<9998
replace demcandpos92=demcandpos92+1 if V923124!=0 & V923124<9998
replace demcandpos92=demcandpos92+1 if V923125!=0 & V923125<9998
replace demcandpos92=demcandpos92+1 if V923126!=0 & V923126<9998

gen demcandneg92 = 0  if V923127!=0 & V923127<9
replace demcandneg92=demcandneg92+1 if V923128!=0 &  V923128<9998
replace demcandneg92=demcandneg92+1 if V923129!=0 &  V923129<9998
replace demcandneg92=demcandneg92+1 if V923130!=0 &  V923130<9998
replace demcandneg92=demcandneg92+1 if V923131!=0 &  V923131<9998
replace demcandneg92=demcandneg92+1 if V923132!=0 &  V923132<9998

gen repcandpos92 = 0  if V923109!=0 & V923109<9
replace repcandpos92=repcandpos92+1 if V923110!=0 & V923110<9998
replace repcandpos92=repcandpos92+1 if V923111!=0 & V923111<9998
replace repcandpos92=repcandpos92+1 if V923112!=0 & V923112<9998
replace repcandpos92=repcandpos92+1 if V923113!=0 & V923113<9998
replace repcandpos92=repcandpos92+1 if V923114!=0 & V923114<9998

gen repcandneg92 = 0  if V923115!=0 & V923115<9
replace repcandneg92=repcandneg92+1 if V923116!=0 & V923116<9998
replace repcandneg92=repcandneg92+1 if V923117!=0 & V923117<9998
replace repcandneg92=repcandneg92+1 if V923118!=0 & V923118<9998
replace repcandneg92=repcandneg92+1 if V923119!=0 & V923119<9998
replace repcandneg92=repcandneg92+1 if V923120!=0 & V923120<9998

gen demcandpos96 = 0 if V960205!=0 & V960205<9
replace demcandpos96=demcandpos96+1 if V960206!=0 & V960206<9998
replace demcandpos96=demcandpos96+1 if V960207!=0 & V960207<9998
replace demcandpos96=demcandpos96+1 if V960208!=0 & V960208<9998
replace demcandpos96=demcandpos96+1 if V960209!=0 & V960209<9998
replace demcandpos96=demcandpos96+1 if V960210!=0 & V960210<9998

gen demcandneg96 = 0  if V960211!=0 & V960211<9
replace demcandneg96=demcandneg96+1 if V960212!=0 &  V960212<9998
replace demcandneg96=demcandneg96+1 if V960213!=0 &  V960213<9998
replace demcandneg96=demcandneg96+1 if V960214!=0 &  V960214<9998
replace demcandneg96=demcandneg96+1 if V960215!=0 &  V960215<9998
replace demcandneg96=demcandneg96+1 if V960216!=0 &  V960216<9998

gen repcandpos96 = 0  if V960217!=0 &  V960217<9
replace repcandpos96=repcandpos96+1 if V960218!=0 &  V960218<9998
replace repcandpos96=repcandpos96+1 if V960219!=0 &  V960219<9998
replace repcandpos96=repcandpos96+1 if V960220!=0 &  V960220<9998
replace repcandpos96=repcandpos96+1 if V960221!=0 &  V960221<9998
replace repcandpos96=repcandpos96+1 if V960222!=0 &  V960222<9998

gen repcandneg96 = 0  if V960223!=0 & V960223<9
replace repcandneg96=repcandneg96+1 if V960224!=0 & V960224<9998
replace repcandneg96=repcandneg96+1 if V960225!=0 & V960225<9998
replace repcandneg96=repcandneg96+1 if V960226!=0 & V960226<9998
replace repcandneg96=repcandneg96+1 if V960227!=0 & V960227<9998
replace repcandneg96=repcandneg96+1 if V960228!=0 & V960228<9998


** Perot (for amelia, not for analysis)

gen perotpos92 = 0 if V923133!=0 &  V923133<7
replace perotpos92=perotpos92+1 if V923134!=0 & V923134<9998
replace perotpos92=perotpos92+1 if V923135!=0 & V923135<9998
replace perotpos92=perotpos92+1 if V923136!=0 & V923136<9998
replace perotpos92=perotpos92+1 if V923137!=0 & V923137<9998
replace perotpos92=perotpos92+1 if V923138!=0 & V923138<9998

gen perotneg92 = 0 if V923139!=0 &  V923139<7
replace perotneg92=perotneg92+1 if V923140!=0 & V923140<9998
replace perotneg92=perotneg92+1 if V923141!=0 & V923141<9998
replace perotneg92=perotneg92+1 if V923142!=0 & V923142<9998
replace perotneg92=perotneg92+1 if V923143!=0 & V923143<9998
replace perotneg92=perotneg92+1 if V923144!=0 & V923144<9998

gen perotpos96 = 0 if V960229!=0 &  V960229<7
replace perotpos96=perotpos96+1 if V960230!=0 & V960230<9998
replace perotpos96=perotpos96+1 if V960231!=0 & V960231<9998
replace perotpos96=perotpos96+1 if V960232!=0 & V960232<9998
replace perotpos96=perotpos96+1 if V960233!=0 & V960233<9998
replace perotpos96=perotpos96+1 if V960234!=0 & V960234<9998

gen perotneg96 = 0 if V960235!=0 &  V960235<7
replace perotneg96=perotneg96+1 if V960236!=0 & V960236<9998
replace perotneg96=perotneg96+1 if V960237!=0 & V960237<9998
replace perotneg96=perotneg96+1 if V960238!=0 & V960238<9998
replace perotneg96=perotneg96+1 if V960239!=0 & V960239<9998
replace perotneg96=perotneg96+1 if V960240!=0 & V960240<9998



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


** Efficacy

* have any say
gen efficacy1_92 = V926102-1 if  V926102>0 &  V926102<6
* too complicated
gen efficacy2_92 = V926104-1 if  V926104>0 &  V926104<6
* don't think public officials care
gen efficacy3_92 = V926103-1 if  V926103>0 &  V926103<6

* have any say
gen efficacy1_96 = V961245-1 if  V961245>0 &  V961245<6
* too complicated
gen efficacy2_96 = V961246-1 if V961246>0 & V961246<6
* don't think public officials care
gen efficacy3_96 = V961244-1 if  V961244>0 &  V961244<6

** party differences
gen impdiff92 = V925901
recode impdiff92 5=0 8=0 9=. 
gen impdiff94 = V940708
recode impdiff94 5=0 8=0 9=. 
gen impdiff96 = V961182 if V961182!=0 
recode impdiff96 5=0 8=0 9=. 

gen conservpartydk92 = 0 if V925914!=0 &  V925914<9
replace conservpartydk92 = 1 if V925914==8
replace conservpartydk92 = 1 if V925915==8
gen conservrepordem92 = 0 if V925915!=0 & V925915<6
replace conservrepordem92 = 1 if V925915==5

** Issue voting
* Gov spend/services V923701-3
gen haveopinion11 = 0 if V923701<9
replace haveopinion11 = 1 if V923701>=1 & V923701<=7
gen seediff11 = 0 if haveopinion11 ==0
replace seediff11 = 0 if V923702==8
replace seediff11 = 0 if V923703==8
replace seediff11 = 0 if V923702==V923703 & V923702<=8 & V923703<=8
replace seediff11 = 1 if 1<=V923702 & V923702<=7 & 1<=V923703 & V923703<=7 & V923702!=V923703
replace seediff11 = . if V923702==9
replace seediff11 = . if V923703==9
replace seediff11 = . if haveopinion11==. 

* Defense spending V923707-9
gen haveopinion12 = 0 if V923701<9
replace haveopinion12 = 1 if V923701>=1 & V923701<=7
gen seediff12 = 0 if haveopinion12 ==0
replace seediff12 = 0 if V923708==8
replace seediff12 = 0 if V923709==8
replace seediff12 = 0 if V923708==V923709 & V923708<=8 & V923709<=8
replace seediff12 = 1 if 1<=V923708 & V923708<=7 & 1<=V923709 & V923709<=7 & V923708!=V923709
replace seediff12 = . if V923708==9
replace seediff12 = . if V923709==9
replace seediff12 = . if haveopinion12==. 

* Job/Std. Living V923718
gen haveopinion13 = 0 if V923718<9
replace haveopinion13 = 1 if V923718>=1 & V923718<=7
gen seediff13 = 0 if haveopinion13 ==0
replace seediff13 = 0 if V923719==8
replace seediff13 = 0 if V923720==8
replace seediff13 = 0 if V923719==V923720 & V923719<=8 & V923720<=8
replace seediff13 = 1 if 1<=V923719 & V923719<=7 & 1<=V923720 & V923720<=7 & V923719!=V923720
replace seediff13 = . if V923719==9
replace seediff13 = . if V923720==9
replace seediff13 = . if haveopinion13==. 


** Abortion 92
gen haveopinion14 = 0 if V923732<9
replace haveopinion14 = 1 if V923732>=1 & V923732<=7
gen seediff14 = 0 if haveopinion14 ==0
replace seediff14 = 0 if V923733==8
replace seediff14 = 0 if V923734==8
replace seediff14 = 0 if V923733==V923734 & V923733<=8 & V923734<=8
replace seediff14 = 1 if 1<=V923733 & V923734<=7 & 1<=V923733 & V923734<=7 & V923733!=V923734
replace seediff14 = . if V923733==9
replace seediff14 = . if V923734==9
replace seediff14 = . if haveopinion14==. 


* abortion 2
tab V960503 
gen haveopinion21 = 0 if V960503<9
replace haveopinion21 = 1 if V960503<8
gen seediff21 = 0 if haveopinion21 ==0
replace seediff21 = 0 if V960506==8
replace seediff21 = 0 if V960509==8
replace seediff21 = 0 if V960506==V960509 & V960506<=8 & V960509<=8
replace seediff21 = 1 if 1<=V960506 & V960506<=7 & 1<=V960509 & V960509<=7 & V960506!=V960509
replace seediff21 = . if V960506==9
replace seediff21 = . if V960509==9
replace seediff21 = . if haveopinion21==. 

* Women's Role 19
tab V960543
gen haveopinion22 = 0 if V960543<9
replace haveopinion22 = 1 if V960543>=1 & V960543<=7
gen seediff22 = 0 if V960544==8
replace seediff22 = 0 if V960545==8
replace seediff22 = 0 if V960544==V960545 & V960544<=8 & V960545<=8
replace seediff22 = 1 if 1<=V960544 & V960544<=7 & 1<=V960545 & V960545<=7 & V960544!=V960545
replace seediff22 = . if V960544==9
replace seediff22 = . if V960545==9
replace seediff22 = . if haveopinion22==. 
replace seediff22 = 0 if haveopinion22==0 

* Crime 22
tab V960519
gen haveopinion23 = 0 if V960519<9
replace haveopinion23 = 1 if V960519>=1 & V960519<=7
gen seediff23 = 0 if V960520==8
replace seediff23 = 0 if V960521==8
replace seediff23 = 0 if V960520==V960521 & V960520<=8 & V960521<=8
replace seediff23 = 1 if 1<=V960520 & V960520<=7 & 1<=V960521 & V960521<=7 & V960520!=V960521
replace seediff23 = . if V960520==9
replace seediff23 = . if V960521==9
replace seediff23 = . if haveopinion23==. 
replace seediff23 = 0 if haveopinion23==0 

* Job/Std. living 47
tab V960483
gen haveopinion24 = 0 if V960483<9
replace haveopinion24 = 1 if V960483>=1 & V960483<=7
gen seediff24 = 0 if V960484==8
replace seediff24 = 0 if V960485==8
replace seediff24 = 0 if V960484==V960485 & V960484<=8 & V960485<=8
replace seediff24 = 1 if 1<=V960484 & V960484<=7 & 1<=V960485 & V960485<=7 & V960484!=V960485
replace seediff24 = . if V960484==9
replace seediff24 = . if V960485==9
replace seediff24 = . if haveopinion24==. 
replace seediff24 = 0 if haveopinion24==0 

** aid to Blacks 48
tab V960487
gen haveopinion25 = 0 if V960487<9
replace haveopinion25 = 1 if V960487>=1 & V960487<=7
gen seediff25 = 0 if V960490==8
replace seediff25 = 0 if V960492==8
replace seediff25 = 0 if V960490==V960492 & V960490<=8 & V960492<=8
replace seediff25 = 1 if 1<=V960490 & V960490<=7 & 1<=V960492 & V960492<=7 & V960490!=V960492
replace seediff25 = . if V960490==9
replace seediff25 = . if V960492==9
replace seediff25 = . if haveopinion25==. 
replace seediff25 = 0 if haveopinion25==0 

* Defense spending 63
*tab V960463 
* Gov services V960450 68 453/55
*tab V960450
* health insurance 58
*tab V960479 
* Jobs/environ 81
*tab V960523
* Bus. reg/environ 89
*tab V960537



** Age
gen age = V923903
recode age 0=.
replace age = V941203-2 if age==. & V941203!=0
replace age = V960605-4 if age==. & V960605!=0 &  V960605<98 


** Education, seek achieved by 76

gen education = V923908
recode education 98=. 99=. 0=.
* 1 <=8, 2 HS no dip, 3 HS dip, 4 Some college 5 Comm College Grad 6 College 7 Advanced
replace education = V941209 if education<V941209 & V941207<98 
replace education = V960610 if education<V960610 & V960610<98 


** Income
gen income92 = V924105
recode income92  88=. 98=. 99=. 66=14 77=15
gen income96 = V960702
recode income96  88=. 98=. 99=.


** Region

gen south = 0 
replace south = 1 if V923014==3

gen midwest = 0 
replace midwest = 1 if V923014==2

gen west = 0
replace west = 1 if V923014==4

label values south midwest west yesno

keep id-west
sort id
save observed90s.dta, replace

drop pref92 pref96 thirdparty93 thirdparty94

** Ready for Amelia
save amelia90s.dta, replace
