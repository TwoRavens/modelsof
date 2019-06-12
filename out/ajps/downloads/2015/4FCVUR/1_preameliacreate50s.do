use "anes_mergedfile_1956to1960.dta", clear
set more off

** Get 1956 respondents
drop if V600841==0

label define yesno 0 "No" 1 "Yes"

gen id = _n

gen pre56 = 1
replace pre56 = 0 if V560009==0
gen post56 = 1
replace post56 = 0 if V580306==3

gen pre60 = 1 
replace pre60 = 0 if V600582==2
gen post60 = 1 
replace post60 = 0 if V600582==1


***** Voting

** Voted in 56
tab  V560203

gen votedin56 = .
replace votedin56 = 0 if V560203>=21 & V560203<=30
replace votedin56 = 1 if V560203==11
replace votedin56 = 1 if V560203==12
replace votedin56 = 1 if V560203==13
replace votedin56 = 1 if V560203==14
label values votedin56 yesno

** Voted in 58
tab V580375

gen votedin58 = .
replace votedin58 = 0 if V580375==5
replace votedin58 = 1 if V580375==1
replace votedin58 = 1 if V580375==3
replace votedin58 = 1 if V580375==6
label values votedin58 yesno

** Vote in 60
tab  V600767

gen votedin60 = .
replace votedin60 = 0 if V600767>=70 & V600767<99
replace votedin60 = 1 if V600767==10
replace votedin60 = 1 if V600767==20
replace votedin60 = 1 if V600767==30
replace votedin60 = 1 if V600767==40
label values votedin60 yesno

** Pres preference

gen pref56 = .
*Dem
replace pref56 = 1 if V560203==11 
replace pref56 = 1 if V560203==21 
*Rep
replace pref56 = 2 if V560203==12
replace pref56 = 2 if V560203==22
*Other
replace pref56 = 3 if V560203==13
replace pref56 = 3 if V560203==23

gen prepref56 = .
* Undecided
replace prepref56 = 0 if V560100==3
replace prepref56 = 0 if V560100==8
replace prepref56 = 0 if V560104==3
replace prepref56 = 0 if V560104==8
* Dem
replace prepref56 = 1 if V560100==1
replace prepref56 = 1 if V560100==2
replace prepref56 = 1 if V560104==1
replace prepref56 = 1 if V560104==2
* Rep
replace prepref56 = 2 if V560100==4
replace prepref56 = 2 if V560100==5
replace prepref56 = 2 if V560104==4
replace prepref56 = 2 if V560104==5
* Other
replace prepref56 = 3 if V560100==7
replace prepref56 = 3 if V560104==7

gen swing56 = .
replace swing56 = 0 if prepref56!=. & pref56!=.
replace swing56 = 1 if prepref56==1 & pref56==2
replace swing56 = 1 if prepref56==1 & pref56==3
replace swing56 = 1 if prepref56==2 & pref56==1
replace swing56 = 1 if prepref56==2 & pref56==1
replace swing56 = 1 if prepref56==2 & pref56==3
replace swing56 = 1 if prepref56==3 & pref56==1
replace swing56 = 1 if prepref56==3 & pref56==2



gen pref60 = .
* Dem
replace pref60 = 1 if V600767==10
replace pref60 = 1 if V600767==70
* Rep
replace pref60 = 2 if V600767==20
replace pref60 = 2 if V600767==80
* Other
replace pref60 = 3 if V600767==30
replace pref60 = 3 if V600767==30

gen prepref60 = .
* Undecided
replace prepref60 = 0 if V600667==3
replace prepref60 = 0 if V600667==8
replace prepref60 = 0 if V600670==3
replace prepref60 = 0 if V600670==8
* Dem
replace prepref60 = 1 if V600667==1
replace prepref60 = 1 if V600667==2
replace prepref60 = 1 if V600670==1
replace prepref60 = 1 if V600670==2
* Rep
replace prepref60 = 2 if V600667==4
replace prepref60 = 2 if V600667==5
replace prepref60 = 2 if V600670==4
replace prepref60 = 2 if V600670==5
* Other
replace prepref60 = 3 if V600667==6
replace prepref60 = 3 if V600670==6

gen swing60 = .
replace swing60 = 0 if prepref60!=. & pref60!=.
replace swing60 = 1 if prepref60==1 & pref60==2
replace swing60 = 1 if prepref60==1 & pref60==3
replace swing60 = 1 if prepref60==2 & pref60==1
replace swing60 = 1 if prepref60==2 & pref60==1
replace swing60 = 1 if prepref60==2 & pref60==3
replace swing60 = 1 if prepref60==3 & pref60==1
replace swing60 = 1 if prepref60==3 & pref60==2



** Finance Sit, Better or Worse
gen finsit56 = V560078
recode finsit56 3=2 5=3 8=. 9=.
gen finsit58 = V580347
recode finsit58 3=2 5=3 8=. 9=.
gen finsit60 = V600641
recode finsit60 3=2 5=3 8=. 9=.

** War
gen warchances56 = V560085
recode warchances56 3=2 5=3 8=. 9=.
gen warchances60 = V600652
recode warchances60 3=2 5=3 8=. 9=.

** Vote plan
gen voteplan56 = V560099
recode voteplan56 8=. 9=.
gen voteplan60 = V600666
recode voteplan60 8=. 9=.


** Catholic
gen catholic = 0 if V560132<8
replace catholic = 1 if V560132==2

** Sex
gen female = 0 if V560171!=9
replace female=1 if V560171==2

** race
gen black = 0 if V560172!=9
replace black=1 if V560172==2

** Party ID
gen pid56 = V560088
recode pid56 9=. 7=3 8=3
gen thirdparty56 = 0 if pid56!=.
replace thirdparty56 = 1 if V560088==7
gen apolitical56 = 0 if pid56!=.
replace apolitical56 = 1 if V560088==8

gen pid58 = V580360
recode pid58 9=. 7=3 8=3
gen thirdparty58 = 0 if pid58!=.
replace thirdparty58 = 1 if V580360==7
gen apolitical58 = 0 if pid58!=.
replace apolitical58 = 1 if V580360==8

gen pid60 = V600657
recode pid60 9=. 7=3 8=3
gen thirdparty60 = 0 if pid60!=.
replace thirdparty60 = 1 if V600657==7
gen apolitical60 = 0 if pid60!=.
replace apolitical60 = 1 if V600657==8

** Party Mentions, 

gen dempos56 = 0 if pre56==1
replace dempos56=1 if V560015a<990
replace dempos56=2 if V560015b<990
replace dempos56=3 if V560015c<990
replace dempos56=4 if V560015d<990
replace dempos56=5 if V560015e<990
gen demneg56 = 0 if pre56==1
replace demneg56=1 if V560016a<990
replace demneg56=2 if V560016b<990
replace demneg56=3 if V560016c<990
replace demneg56=4 if V560016d<990
replace demneg56=5 if V560016e<990

gen reppos56 = 0 if pre56==1
replace reppos56=1 if V560017a<990
replace reppos56=2 if V560017b<990
replace reppos56=3 if V560017c<990
replace reppos56=4 if V560017d<990
replace reppos56=5 if V560017e<990
gen repneg56 = 0 if pre56==1
replace repneg56=1 if V560018a<990
replace repneg56=2 if V560018b<990
replace repneg56=3 if V560018c<990
replace repneg56=4 if V560018d<990
replace repneg56=5 if V560018e<990

gen dempos58 = 0 if V580306!=9
replace dempos58=1 if V580313a<990
replace dempos58=2 if V580313b<990
replace dempos58=3 if V580313c<990
replace dempos58=4 if V580313d<990
replace dempos58=5 if V580313e<990
gen demneg58 = 0 if V580306!=9
replace demneg58=1 if V580314a<990
replace demneg58=2 if V580314b<990
replace demneg58=3 if V580314c<990
replace demneg58=4 if V580314d<990
replace demneg58=5 if V580314e<990

gen reppos58 = 0 if V580306!=9
replace reppos58=1 if V580315a<990
replace reppos58=2 if V580315b<990
replace reppos58=3 if V580315c<990
replace reppos58=4 if V580315d<990
replace reppos58=5 if V580315e<990
gen repneg58 = 0 if V580306!=9
replace repneg58=1 if V580316a<990
replace repneg58=2 if V580316b<990
replace repneg58=3 if V580316c<990
replace repneg58=4 if V580316d<990
replace repneg58=5 if V580316e<990

gen dempos60 = 0 if pre60==1
replace dempos60=1 if V600586a<990
replace dempos60=2 if V600586b<990
replace dempos60=3 if V600586c<990
replace dempos60=4 if V600586d<990
replace dempos60=5 if V600586e<990
gen demneg60 = 0 if pre60==1
replace demneg60=1 if V600587a<990
replace demneg60=2 if V600587b<990
replace demneg60=3 if V600587c<990
replace demneg60=4 if V600587d<990
replace demneg60=5 if V600587e<990

gen reppos60 = 0 if pre60==1
replace reppos60=1 if V600588a<990
replace reppos60=2 if V600588e<990
replace reppos60=3 if V600588c<990
replace reppos60=4 if V600588d<990
replace reppos60=5 if V600588e<990
gen repneg60 = 0 if pre60==1
replace repneg60=1 if V600589a<990
replace repneg60=2 if V600589b<990
replace repneg60=3 if V600589c<990
replace repneg60=4 if V600589d<990
replace repneg60=5 if V600589e<990

** Candidate Mentions, Ambiv

gen demcandpos56 = 0 if pre56==1
replace demcandpos56=1 if V560019a<990
replace demcandpos56=2 if V560019b<990
replace demcandpos56=3 if V560019c<990
replace demcandpos56=4 if V560019d<990
replace demcandpos56=5 if V560019e<990

gen demcandneg56 = 0  if pre56==1
replace demcandneg56=1 if V560020a<990
replace demcandneg56=2 if V560020b<990
replace demcandneg56=3 if V560020c<990
replace demcandneg56=4 if V560020d<990
replace demcandneg56=5 if V560020e<990

gen repcandpos56 = 0  if pre56==1
replace repcandpos56=1 if V560021a<990
replace repcandpos56=2 if V560021b<990
replace repcandpos56=3 if V560021c<990
replace repcandpos56=4 if V560021d<990
replace repcandpos56=5 if V560021e<990

gen repcandneg56 = 0  if pre56==1
replace repcandneg56=1 if V560022a<990
replace repcandneg56=2 if V560022b<990
replace repcandneg56=3 if V560022c<990
replace repcandneg56=4 if V560022d<990
replace repcandneg56=5 if V560022e<990

gen demcandpos60 = 0 if pre60==1
replace demcandpos60=1 if V600590a<990
replace demcandpos60=2 if V600590b<990
replace demcandpos60=3 if V600590c<990
replace demcandpos60=4 if V600590d<990
replace demcandpos60=5 if V600590e<990

gen demcandneg60 = 0 if pre60==1
replace demcandneg60=1 if V600591a<990
replace demcandneg60=2 if V600591b<990
replace demcandneg60=3 if V600591c<990
replace demcandneg60=4 if V600591d<990
replace demcandneg60=5 if V600591e<990

gen repcandpos60 = 0 if pre60==1
replace repcandpos60=1 if V600592a<990
replace repcandpos60=2 if V600592b<990
replace repcandpos60=3 if V600592c<990
replace repcandpos60=4 if V600592d<990
replace repcandpos60=5 if V600592e<990

gen repcandneg60 = 0 if pre60==1
replace repcandneg60=1 if V600593a<990
replace repcandneg60=2 if V600593b<990
replace repcandneg60=3 if V600593c<990
replace repcandneg60=4 if V600593d<990
replace repcandneg60=5 if V600593e<990

** Issue placement, 5 issues with fewest DK+No Opinions
* 1. Help build schools V53 * 124
gen haveopinion11 = 0 if V560053!=9 
replace haveopinion11 = 1 if V560053>=1 & V560053<=5
gen seediff11 = 0 if V560053!=9 & V560055!=9
replace seediff11 = 1 if V560055==1
replace seediff11 = 1 if V560055==5
* 2. See to it Job V32 * 131
gen haveopinion12 = 0 if V560032!=9 
replace haveopinion12 = 1 if V560032>=1 & V560032<=5
gen seediff12 = 0 if V560032!=9 & V560034!=9
replace seediff12 = 1 if V560034==1
replace seediff12 = 1 if V560034==5
* 3. Halfway with countries V65 * 132
gen haveopinion13 = 0 if V560065!=9 
replace haveopinion13 = 1 if V560065>=1 & V560065<=5
gen seediff13 = 0 if V560065!=9 & V560067!=9
replace seediff13 = 1 if V560067==1
replace seediff13 = 1 if V560067==5
* 4. School integration V74 * 159
gen haveopinion14 = 0 if V560074!=9 
replace haveopinion14 = 1 if V560074>=1 & V560074<=5
gen seediff14 = 0 if V560074!=9 & V560076!=9
replace seediff14 = 1 if V560076==1
replace seediff14 = 1 if V560076==5
* 5. Hospital care low cost V38 * 159
gen haveopinion15 = 0 if V560038!=9 
replace haveopinion15 = 1 if V560038>=1 & V560038<=5
gen seediff15 = 0 if V560038!=9 & V560040!=9
replace seediff15 = 1 if V560040==1
replace seediff15 = 1 if V560040==5

* 6. Stayed home (isolationism) V35 * 167
* 7. Equal treatment for negros V44 * 171
* fire communists V68 * 190
* gen issue1_56 = V560029
* Tax cut V29 * 236
* Foreign aid V41 * 209
* Limit big business influence V47 * 348
* Get tough wiht Russia V50 * 232
* soldiers overseas V56 * 240
* gov. utilities  V59 * 366
* labor unions V62 * 311
* help to foreign count V71 * 353

*60
* 1. 624 Aid Education * 174
gen haveopinion21 = 0 if V600624!=9
replace haveopinion21 = 1 if V600624>=1 & V600624<=5
gen seediff21 = 0 if V600624!=9 & V600625!=9
replace seediff21 = 1 if V600625==1
replace seediff21 = 1 if V600625==5
* 2. 620 Govt Guarantee emplymnt *178
gen haveopinion22 = 0 if V600620!=9
replace haveopinion22 = 1 if V600620>=1 & V600620<=5
gen seediff22 = 0 if V600620!=9 & V600621!=9
replace seediff22 = 1 if V600621==1
replace seediff22 = 1 if V600621==5
* 3. 632 Subsidize medical care * 181
gen haveopinion23 = 0 if V600632!=9
replace haveopinion23 = 1 if V600632>=1 & V600632<=5
gen seediff23 = 0 if V600632!=9 & V600634!=9
replace seediff23 = 1 if V600634==1
replace seediff23 = 1 if V600634==5
* 4. 622 Isolationism * 195
gen haveopinion24 = 0 if V600622!=9
replace haveopinion24 = 1 if V600622>=1 & V600622<=5
gen seediff24 = 0 if V600622!=9 & V600623!=9
replace seediff24 = 1 if V600623==1
replace seediff24 = 1 if V600623==5
* 5. 628 Help Blacks * 218
gen haveopinion25 = 0 if V600628!=9
replace haveopinion25 = 1 if V600628>=1 & V600628<=5
gen seediff25 = 0 if V600628!=9 & V600629!=9
replace seediff25 = 1 if V600629==1
replace seediff25 = 1 if V600629==5

* 618 Hsg & Pwr * 383
* 626 Aid Poor Countries * 258
* 630 Fight communism overseas * 296
* 636 School integration * 249


* Important differences
gen impdiff60 = V600795
recode impdiff60 3/5=0 8=0 9=.
* Party more conservative
gen conservparty = V600798
recode conservparty 1/3=-1 8=0 4/6=1 9=.

** Mobilization

gen partycontact56 = .
replace partycontact56 = 0 if V560221==5
replace partycontact56 = 1 if V560221==1
replace partycontact56 = 2 if V560221==2
replace partycontact56 = 3 if V560221==3
gen partycontact60 = .
replace partycontact60 = 0 if V600787==5
replace partycontact60 = 1 if V600787==1
replace partycontact60 = 2 if V600787==2
replace partycontact60 = 3 if V600787==3




** Media
gen newspaper56 = 0 if V560196!=9
replace newspaper56 = 1 if V560196==1
gen radio56 = 0 if V560198!=9
replace radio56 = 1 if V560198==1
gen tv56 = 0 if V560199!=9
replace tv56=1 if V560199==1
gen mag56 = 0 if V560200!=9
replace mag56=1 if V560200==1


gen newspaper60 = 0 if V600756!=9
replace newspaper60 = 1 if V600756<5
gen radio60 = 0 if V600758!=9
replace radio60 = 1 if V600758<5
gen tv60 = 0 if V600759!=9
replace tv60=1 if V600759<5
gen mag60 = 0 if V600760!=9
replace mag60=1 if V600760<5

** Efficacy

gen efficacy561 = .
replace efficacy561 =0 if V560108==1
replace efficacy561 =1 if V560108==5
gen efficacy562 = . 
replace efficacy562 =0 if V560112==1
replace efficacy562 =1 if V560112==5
gen efficacy563 = . 
replace efficacy563 =0 if V560115==1
replace efficacy563 =1 if V560115==5


gen efficacy601 = .
replace efficacy601 =0 if V600673==1
replace efficacy601 =1 if V600673==5
gen efficacy602 = . 
replace efficacy602 =0 if V600677==1
replace efficacy602 =1 if V600677==5
gen efficacy603 = . 
replace efficacy603 =0 if V600680==1
replace efficacy603 =1 if V600680==5

** Age
gen age = V560295
recode age 99=. 98=.
replace age = 22.5 if age==. & V560175==1
replace age = 30 if age==. & V560175==2
replace age = 40 if age==. & V560175==3
replace age = 50 if age==. & V560175==4
replace age = 60 if age==. & V560175==5
replace age = 70 if age==. & V560175==6
replace age = . if V560175==0

** Education, seek achieved by 60

gen education = V560181
recode education 9=.
replace education = 0 if V600694==0 & education==. 
replace education = 1 if V600694>0 & V600694<17 & education==. 
replace education = 1 if V600694>0 & V600694<17 & education<1 
replace education = 2 if V600694==21 & education==. 
replace education = 2 if V600694==21 & education<1 
replace education = 3 if V600694>21 & V600694<41 & education==. 
replace education = 3 if V600694>21 & V600694<41 & education<2 
replace education = 4 if V600694>40 & V600694<44 & education==. 
replace education = 4 if V600694>40 & V600694<44 & education<3 
replace education = 5 if V600694==51 & education==. 
replace education = 5 if V600694==51 & education<5 
replace education = 6 if V600694==61 & education==. 
replace education = 6 if V600694==61 & education<6 
replace education = 7 if V600694==71 & education==. 
replace education = 7 if V600694==71 & education<7 
replace education = 8 if V600694==81 & education==. 
replace education = 8 if V600694==81 & education<8 


*gen gradeschool = 0 if education!=.
*replace gradeschool = 1 if education==1
*replace gradeschool = 1 if education==2
*replace gradeschool = 1 if education==3
*replace gradeschool = 1 if education==4
*gen highschool = 0 if education!=.
*replace highschool=1 if education==5
*replace highschool=1 if education==6
*gen college = 0 if education!=.
*replace college = 1 if education==7
*replace college = 1 if education==8

** Income 1956 & 60
gen income56 = V560190
replace income56 = . if income56>=97
recode income56 10=0 11=1 12=2 13=3 20=4 21=5 22=6 30=7 31=8
gen income58 = V580501
replace income58 = . if income58>=95
recode income58 10=0 11=1 12=2 13=3 20=4 21=5 22=6 30=7 31=8 32=9
gen income60 = V600755
replace income60 = . if income60>=95
recode income60  10=1 20=2 30=3 40=4 50=5 60=6 70=7 80=8 90=9


gen nixonstate = 0 if V600608!=.
replace nixonstate = 1 if V600608==71
replace nixonstate = . if V600608==98

** Kennedy State
*tab V600612, missing

gen kennedystate = 0 if V600612!=.
replace kennedystate = 1 if V600612==3
replace kennedystate = . if V600612==98

** Party hold Majority

*tab V600792, missing

gen knowmajority = 0 if V600792<=8
replace knowmajority = 1 if V600792==1

** Region

gen midwest=0 
replace midwest = 1 if V560007>20 & V560007<40

gen south = 0 
replace south  =1 if V560007>39 & V560007<69

keep V560003 id-south

save observed50s.dta, replace

drop V560003 pref56 pref60

save amelia50s.dta, replace

