
* Generate variables

set type double
gen highcosts=1 if costs==45
replace highcosts=0 if costs==15

gen goodsignal=0
replace goodsignal=1 if signal==1

gen highbonus=0
replace highbonus=1 if bonus==20

gen principal=0
replace principal=1 if role==1
gen agent=1-principal

gen maintreatment=0
replace maintreatment=1 if informed==1
gen controltreatment=1-maintreatment

bys groupid: gen flaggroup=1 if _n==1
bys groupid subjectid: gen flagsubjectgroup=1 if _n==1

gen effort_own  =guess
gen effort_joint  =effort
gen badsignal=1-goodsignal
gen highbonusgoodsignal=highbonus*goodsignal

rename return0 r0
label var r0 "return[0] when sent by subject"
rename return5 r5
label var r5 "return[5] when sent by subject"
rename return10 r10
label var r10 "return[10] when sent by subject"
rename return15 r15
label var r15 "return[15] when sent by subject"
rename return20 r20
label var r20 "return[20] when sent by subject"

rename return_comp0 rc0
label var rc0 "return_comp[0] when sent by computer"
rename return_comp5 rc5
label var rc5 "return_comp[5] when sent by computer"
rename return_comp10 rc10
label var rc10 "return_comp[10] when sent by computer"
rename return_comp15 rc15
label var rc15 "return_comp[15] when sent by computer"
rename return_comp20 rc20
label var rc20 "return_comp[20] when sent by computer"

label var investment "investment  if sender can return"
label var invest_wo_return "investment if no return possible"
rename invest_wo_return investmentdictator

gen fractionr0=0
gen fractionr5=r5/15
gen fractionr10=r10/30
gen fractionr15=r15/45
gen fractionr20=r20/60

gen fractionrc0=0
gen fractionrc5=rc5/15
gen fractionrc10=rc10/30
gen fractionrc15=rc15/45
gen fractionrc20=rc20/60

gen meanfractionr=(fractionr5+fractionr10+fractionr15+fractionr20)/4
gen meanfractionrc=(fractionrc5+fractionrc10+fractionrc15+fractionrc20)/4

gen altruism=investmentdictator/20
gen trust=(investment-investmentdictator)/20
gen fairness=meanfractionrc
gen reciprocity=meanfractionr-meanfractionrc

gen mhighaltruism=0 if altruism~=.
replace mhighaltruism=1 if altruism>=0.5 & altruism~=.

gen mhightrust=0 if trust~=.
replace mhightrust=1 if trust>=0.25 & trust~=.

gen mhighfairness=0 if fairness~=.
replace mhighfairness=1 if fairness>=0.045 & fairness~=.

gen mhighreciprocity=0 if reciprocity~=.
replace mhighreciprocity=1 if reciprocity>=0.008 & reciprocity~=.

gen Altruist=mhighaltruism
gen Trusting=mhightrust
gen Fair=mhighfairness
gen Reciprocal=mhighreciprocity


gen Rounds11_20=1 if informed==1 & period>10
replace Rounds11_20=0 if informed==1 & period<=10

gen HighbonusRounds11_20=1 if Rounds11_20==1 & highbonus==1
replace HighbonusRounds11_20=0 if Rounds11_20==0 | highbonus==0

gen SOmissing=0
replace SOmissing=1 if groupid==5 | groupid==6 |groupid==9| groupid==10

gen wage5=0
replace wage5=1 if wage==5

gen wage10=0
replace wage10=1 if wage==10

gen round_total=round
gen round_treatment=period
sort subjectid maintreatment agent period
bys subjectid maintreatment agent: gen round_role=_n

gen s1=0 if round_treatment==1
replace s1=1 if round_treatment==1 & agent==1
bys subjectid stage: egen startagent=max(s1)
drop s1

gen secondhalf=0
replace secondhalf=1 if (maintreatment==1 & period>=11) | (controltreatment==1 & period>=7)
 
sort round_total
bys subjectid maintreatment : gen flagsubjecttreatment=1 if _n==1
sort round_treatment
bys subjectid maintreatment secondhalf : gen flagsubjecttreatmentpart=1 if _n==1

* Dropping uninteresting vars

drop  subject group  profit totalprofit participate n time* round   subjects period role type cyclerank reservation project signal costs bonus guess  ///
effort realization r0 r5 r10 r15 r20 rc0 rc5 rc10 rc15 rc20 s randomnumber randomorder investment investmentdictator ///
random invest_comp receiving return receiving_wo_return return_comp taken fractionr0 fractionr5 fractionr10 fractionr15 /// 
fractionr20 fractionrc0 fractionrc5 fractionrc10 fractionrc15 fractionrc20 meanfractionr meanfractionrc  /// 
altruism trust fairness reciprocity  /// 
mhighaltruism mhightrust mhighfairness mhighreciprocity 


