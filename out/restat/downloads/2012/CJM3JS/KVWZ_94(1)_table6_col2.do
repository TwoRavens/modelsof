clear all

set more 1
set mat 800
set mem 150M
set logtype text

cd "C:\Data\PSID\Injury\RESTAT files"

capture log close

log using "KVWZ_94(1)_table6_col2.txt",replace

use "C:\Data\PSID\Injury\Feb10\pandat_mar08.dta"

drop if lagfatal_==.
g lagfatal=lagfatal_

*****************************
*****************************
* identifying individuals in sample only once
*****************************

sort id

g one=1

by id: g vsum=sum(one)

tsset id year

by id: egen tempvar=max(vsum)

gen solo=1 if tempvar==1
replace solo=0 if tempvar~=1

drop tempvar



*****************************
*****************************



gen lnhours=log(ttl_work_hrs)

/* define panel id variables */

iis id
tis year

/* define year dummies and other vars for regression */

quietly tab year, gen(yr_)
g age2=age^2
quietly tab state_fips, gen(state)

quietly tab sic, gen(sic)

/* Census Divisions --- http://www.census.gov/geo/www/us_regdiv.pdf */
/* State FIPS Codes --- http://www.bls.gov/lau/lausfips.htm */

g cendiv=1 if state_fips==9 | state_fips==23 | state_fips==25 | state_fips==33 | state_fips==44 | state_fips==50
replace cendiv=2 if state_fips==34 | state_fips==36 | state_fips==42
replace cendiv=3 if state_fips==17 | state_fips==18 | state_fips==26 | state_fips==39 | state_fips==55
replace cendiv=4 if state_fips==19 | state_fips==20 | state_fips==27 | state_fips==29 | state_fips==31 | state_fips==38 | state_fips==46
replace cendiv=5 if state_fips==10 | state_fips==11 | state_fips==12 | state_fips==13 | state_fips==24 | state_fips==37 | state_fips==45 | state_fips==51 | state_fips==54
replace cendiv=6 if state_fips==1 | state_fips==21 | state_fips==28 | state_fips==47
replace cendiv=7 if state_fips==5 | state_fips==22 | state_fips==40 | state_fips==48
replace cendiv=8 if state_fips==4 | state_fips==8 | state_fips==16 | state_fips==30 | state_fips==32 | state_fips==35 | state_fips==49 | state_fips==56
replace cendiv=9 if state_fips==2 | state_fips==6 | state_fips==15 | state_fips==41 | state_fips==53
quietly tab cendiv, gen(cendiv)

/* 1-yr changes in fatality rate */

tsset id year
g pct_chng=100*(fatalrate_ - lagfatal_)/lagfatal_
g pct_chng3b=100*(fatalrate3b_ - lagfatal3b_)/lagfatal3b_

g lpct_chng=100*(lagfatal_ - lag2fatal_)/lag2fatal_
g lpct_chng3b=100*(lagfatal3b_ - lag2fatal3b_)/lag2fatal3b_


/* @@@@@@@@@@@ XTABOND FIRST DIFFERENCES  @@@@@@@@@@*/


/* annual fatality models */

g fatal=fatalrate_
g fatal3=fatalrate3b_

tsset id year

g dwage=lnrwage-l2.lnrwage
g did=id-l2.id

g dfatal=fatal-l2.fatal


g dfatal3=fatal3-l2.fatal3

g deduc=educ-l2.educ
g dage=age-l2.age
g dage2=age2-l2.age2
g dneast=neast-l2.neast
g dncent=ncent-l2.ncent
g dwest=west-l2.west

g dcendiv1=cendiv1-l2.cendiv1
g dcendiv2=cendiv2-l2.cendiv2
g dcendiv3=cendiv3-l2.cendiv3
g dcendiv4=cendiv4-l2.cendiv4
g dcendiv5=cendiv5-l2.cendiv5
g dcendiv6=cendiv6-l2.cendiv6
g dcendiv7=cendiv7-l2.cendiv7
g dcendiv8=cendiv8-l2.cendiv8
g dcendiv9=cendiv9-l2.cendiv9

g dunion=union-l2.union
g dmarry=marry-l2.marry
g dwhite=white-l2.white
g docc1=occ1-l2.occ1
g docc2=occ2-l2.occ2
g docc3=occ3-l2.occ3
g docc4=occ4-l2.occ4
g docc5=occ5-l2.occ5
g docc6=occ6-l2.occ6
g docc7=occ7-l2.occ7
g docc8=occ8-l2.occ8
g docc9=occ9-l2.occ9
g docc10=occ10-l2.occ10
g dindd1=indd1-l2.indd1
g dindd2=indd2-l2.indd2
g dindd3=indd3-l2.indd3
g dindd4=indd4-l2.indd4
g dindd5=indd5-l2.indd5
g dindd6=indd6-l2.indd6
g dindd7=indd7-l2.indd7
g dindd8=indd8-l2.indd8
g dindd9=indd9-l2.indd9
g dindd10=indd10-l2.indd10

g dsic1=sic1-l2.sic1
g dsic2=sic2-l2.sic2
g dsic3=sic3-l2.sic3
g dsic4=sic4-l2.sic4
g dsic5=sic5-l2.sic5
g dsic6=sic6-l2.sic6
g dsic7=sic7-l2.sic7
g dsic8=sic8-l2.sic8
g dsic9=sic9-l2.sic9
g dsic10=sic10-l2.sic10
g dsic11=sic11-l2.sic11
g dsic12=sic12-l2.sic12
g dsic13=sic13-l2.sic13
g dsic14=sic14-l2.sic14
g dsic15=sic15-l2.sic15
g dsic16=sic16-l2.sic16
g dsic17=sic17-l2.sic17
g dsic18=sic18-l2.sic18
g dsic19=sic19-l2.sic19
g dsic20=sic20-l2.sic20
g dsic21=sic21-l2.sic21
g dsic22=sic22-l2.sic22
g dsic23=sic23-l2.sic23
g dsic24=sic24-l2.sic24
g dsic25=sic25-l2.sic25
g dsic26=sic26-l2.sic26
g dsic27=sic27-l2.sic27
g dsic28=sic28-l2.sic28
g dsic29=sic29-l2.sic29
g dsic30=sic30-l2.sic30
g dsic31=sic31-l2.sic31
g dsic32=sic32-l2.sic32
g dsic33=sic33-l2.sic33
g dsic34=sic34-l2.sic34
g dsic35=sic35-l2.sic35
g dsic36=sic36-l2.sic36
g dsic37=sic37-l2.sic37
g dsic38=sic38-l2.sic38
g dsic39=sic39-l2.sic39
g dsic40=sic40-l2.sic40
g dsic41=sic41-l2.sic41
g dsic42=sic42-l2.sic42
g dsic43=sic43-l2.sic43
g dsic44=sic44-l2.sic44
g dsic45=sic45-l2.sic45
g dsic46=sic46-l2.sic46
g dsic47=sic47-l2.sic47
g dsic48=sic48-l2.sic48
g dsic49=sic49-l2.sic49
g dsic50=sic50-l2.sic50
g dsic51=sic51-l2.sic51
g dsic52=sic52-l2.sic52
g dsic53=sic53-l2.sic53
g dsic54=sic54-l2.sic54
g dsic55=sic55-l2.sic55
g dsic56=sic56-l2.sic56
g dsic57=sic57-l2.sic57
g dsic58=sic58-l2.sic58
g dsic59=sic59-l2.sic59
g dsic60=sic60-l2.sic60
g dsic61=sic61-l2.sic61
g dsic62=sic62-l2.sic62
g dsic63=sic63-l2.sic63
g dsic64=sic64-l2.sic64
g dsic65=sic65-l2.sic65
g dsic66=sic66-l2.sic66

g dstate1=state1-l2.state1
g dstate2=state2-l2.state2
g dstate3=state3-l2.state3
g dstate4=state4-l2.state4
g dstate5=state5-l2.state5
g dstate6=state6-l2.state6
g dstate7=state7-l2.state7
g dstate8=state8-l2.state8
g dstate9=state9-l2.state9
g dstate10=state10-l2.state10
g dstate11=state11-l2.state11
g dstate12=state12-l2.state12
g dstate13=state13-l2.state13
g dstate14=state14-l2.state14
g dstate15=state15-l2.state15
g dstate16=state16-l2.state16
g dstate17=state17-l2.state17
g dstate18=state18-l2.state18
g dstate19=state19-l2.state19
g dstate20=state20-l2.state20
g dstate21=state21-l2.state21
g dstate22=state22-l2.state22
g dstate23=state23-l2.state23
g dstate24=state24-l2.state24
g dstate25=state25-l2.state25
g dstate26=state26-l2.state26
g dstate27=state27-l2.state27
g dstate28=state28-l2.state28
g dstate29=state29-l2.state29
g dstate30=state30-l2.state30
g dstate31=state31-l2.state31
g dstate32=state32-l2.state32
g dstate33=state33-l2.state33
g dstate34=state34-l2.state34
g dstate35=state35-l2.state35
g dstate36=state36-l2.state36
g dstate37=state37-l2.state37
g dstate38=state38-l2.state38
g dstate39=state39-l2.state39
g dstate40=state40-l2.state40
g dstate41=state41-l2.state41
g dstate42=state42-l2.state42
g dstate43=state43-l2.state43
g dstate44=state44-l2.state44
g dstate45=state45-l2.state45
g dstate46=state46-l2.state46
g dstate47=state47-l2.state47
g dstate48=state48-l2.state48
g dstate49=state49-l2.state49
g dstate50=state50-l2.state50

global dxx="dfatal dage dage2 dcendiv2-dcendiv9 dunion dmarry docc1 docc2 docc3 docc4 docc5 docc6 docc7 docc8 docc9 dsic2-dsic66 dstate2-dstate50"


/* @@@@@@@@@@@ DYNAMIC FIRST DIFFERENCES @@@@@@@@@@*/

/* Constructing Instruments */

g negnly=0
replace negnly=1 if rnly <=0
g lnegnly=l2.negnly

replace rnly=1 if rnly <= 0
g lnrnly=ln(rnly)
g lgnly=l2.lnrnly

g leduc=l2.educ
g lage=l2.age
g lage2=l2.age2
g lneast=l2.neast
g lncent=l2.ncent
g lwest=l2.west
g lunion=l2.union
g lmarry=l2.marry
g lwhite=l2.white
g locc1=l2.occ1
g locc2=l2.occ2
g locc3=l2.occ3
g locc4=l2.occ4
g locc5=l2.occ5
g locc6=l2.occ6
g locc7=l2.occ7
g locc8=l2.occ8
g locc9=l2.occ9
g locc10=l2.occ10
g lindd1=l2.indd1
g lindd2=l2.indd2
g lindd3=l2.indd3
g lindd4=l2.indd4
g lindd5=l2.indd5
g lindd6=l2.indd6
g lindd7=l2.indd7
g lindd8=l2.indd8
g lindd9=l2.indd9
g lindd10=l2.indd10
g llnhours=l2.lnhours

g lcendiv1=l2.cendiv1
g lcendiv2=l2.cendiv2
g lcendiv3=l2.cendiv3
g lcendiv4=l2.cendiv4
g lcendiv5=l2.cendiv5
g lcendiv6=l2.cendiv6
g lcendiv7=l2.cendiv7
g lcendiv8=l2.cendiv8
g lcendiv9=l2.cendiv9
g lsic1=l2.sic1
g lsic2=l2.sic2
g lsic3=l2.sic3
g lsic4=l2.sic4
g lsic5=l2.sic5
g lsic6=l2.sic6
g lsic7=l2.sic7
g lsic8=l2.sic8
g lsic9=l2.sic9
g lsic10=l2.sic10
g lsic11=l2.sic11
g lsic12=l2.sic12
g lsic13=l2.sic13
g lsic14=l2.sic14
g lsic15=l2.sic15
g lsic16=l2.sic16
g lsic17=l2.sic17
g lsic18=l2.sic18
g lsic19=l2.sic19
g lsic20=l2.sic20
g lsic21=l2.sic21
g lsic22=l2.sic22
g lsic23=l2.sic23
g lsic24=l2.sic24
g lsic25=l2.sic25
g lsic26=l2.sic26
g lsic27=l2.sic27
g lsic28=l2.sic28
g lsic29=l2.sic29
g lsic30=l2.sic30
g lsic31=l2.sic31
g lsic32=l2.sic32
g lsic33=l2.sic33
g lsic34=l2.sic34
g lsic35=l2.sic35
g lsic36=l2.sic36
g lsic37=l2.sic37
g lsic38=l2.sic38
g lsic39=l2.sic39
g lsic40=l2.sic40
g lsic41=l2.sic41
g lsic42=l2.sic42
g lsic43=l2.sic43
g lsic44=l2.sic44
g lsic45=l2.sic45
g lsic46=l2.sic46
g lsic47=l2.sic47
g lsic48=l2.sic48
g lsic49=l2.sic49
g lsic50=l2.sic50
g lsic51=l2.sic51
g lsic52=l2.sic52
g lsic53=l2.sic53
g lsic54=l2.sic54
g lsic55=l2.sic55
g lsic56=l2.sic56
g lsic57=l2.sic57
g lsic58=l2.sic58
g lsic59=l2.sic59
g lsic60=l2.sic60
g lsic61=l2.sic61
g lsic62=l2.sic62
g lsic63=l2.sic63
g lsic64=l2.sic64
g lsic65=l2.sic65
g lsic66=l2.sic66

g lstate1=l2.state1
g lstate2=l2.state2
g lstate3=l2.state3
g lstate4=l2.state4
g lstate5=l2.state5
g lstate6=l2.state6
g lstate7=l2.state7
g lstate8=l2.state8
g lstate9=l2.state9
g lstate10=l2.state10
g lstate11=l2.state11
g lstate12=l2.state12
g lstate13=l2.state13
g lstate14=l2.state14
g lstate15=l2.state15
g lstate16=l2.state16
g lstate17=l2.state17
g lstate18=l2.state18
g lstate19=l2.state19
g lstate20=l2.state20
g lstate21=l2.state21
g lstate22=l2.state22
g lstate23=l2.state23
g lstate24=l2.state24
g lstate25=l2.state25
g lstate26=l2.state26
g lstate27=l2.state27
g lstate28=l2.state28
g lstate29=l2.state29
g lstate30=l2.state30
g lstate31=l2.state31
g lstate32=l2.state32
g lstate33=l2.state33
g lstate34=l2.state34
g lstate35=l2.state35
g lstate36=l2.state36
g lstate37=l2.state37
g lstate38=l2.state38
g lstate39=l2.state39
g lstate40=l2.state40
g lstate41=l2.state41
g lstate42=l2.state42
g lstate43=l2.state43
g lstate44=l2.state44
g lstate45=l2.state45
g lstate46=l2.state46
g lstate47=l2.state47
g lstate48=l2.state48
g lstate49=l2.state49
g lstate50=l2.state50

global ixx="lage lage2 lcendiv2-lcendiv9 lunion lmarry locc1 locc2 locc3 locc4 locc5 locc6 locc7 locc8 locc9 lsic2-lsic66 lstate2-lstate50"


g l2wage=l4.lnrwage
g l2educ=l4.educ
g l2age=l4.age
g l2age2=l4.age2
g l2neast=l4.neast
g l2ncent=l4.ncent
g l2west=l4.west
g l2union=l4.union
g l2marry=l4.marry
g l2white=l4.white
g l2occ1=l4.occ1
g l2occ2=l4.occ2
g l2occ3=l4.occ3
g l2occ4=l4.occ4
g l2occ5=l4.occ5
g l2occ6=l4.occ6
g l2occ7=l4.occ7
g l2occ8=l4.occ8
g l2occ9=l4.occ9
g l2occ10=l4.occ10
g l2indd1=l4.indd1
g l2indd2=l4.indd2
g l2indd3=l4.indd3
g l2indd4=l4.indd4
g l2indd5=l4.indd5
g l2indd6=l4.indd6
g l2indd7=l4.indd7
g l2indd8=l4.indd8
g l2indd9=l4.indd9
g l2indd10=l4.indd10
g l2rnly=l4.lnrnly
g l2negnly=l4.negnly
g l2hours=l4.lnhours

g l2cendiv1=l4.cendiv1
g l2cendiv2=l4.cendiv2
g l2cendiv3=l4.cendiv3
g l2cendiv4=l4.cendiv4
g l2cendiv5=l4.cendiv5
g l2cendiv6=l4.cendiv6
g l2cendiv7=l4.cendiv7
g l2cendiv8=l4.cendiv8
g l2cendiv9=l4.cendiv9
g l2sic1=l4.sic1
g l2sic2=l4.sic2
g l2sic3=l4.sic3
g l2sic4=l4.sic4
g l2sic5=l4.sic5
g l2sic6=l4.sic6
g l2sic7=l4.sic7
g l2sic8=l4.sic8
g l2sic9=l4.sic9
g l2sic10=l4.sic10
g l2sic11=l4.sic11
g l2sic12=l4.sic12
g l2sic13=l4.sic13
g l2sic14=l4.sic14
g l2sic15=l4.sic15
g l2sic16=l4.sic16
g l2sic17=l4.sic17
g l2sic18=l4.sic18
g l2sic19=l4.sic19
g l2sic20=l4.sic20
g l2sic21=l4.sic21
g l2sic22=l4.sic22
g l2sic23=l4.sic23
g l2sic24=l4.sic24
g l2sic25=l4.sic25
g l2sic26=l4.sic26
g l2sic27=l4.sic27
g l2sic28=l4.sic28
g l2sic29=l4.sic29
g l2sic30=l4.sic30
g l2sic31=l4.sic31
g l2sic32=l4.sic32
g l2sic33=l4.sic33
g l2sic34=l4.sic34
g l2sic35=l4.sic35
g l2sic36=l4.sic36
g l2sic37=l4.sic37
g l2sic38=l4.sic38
g l2sic39=l4.sic39
g l2sic40=l4.sic40
g l2sic41=l4.sic41
g l2sic42=l4.sic42
g l2sic43=l4.sic43
g l2sic44=l4.sic44
g l2sic45=l4.sic45
g l2sic46=l4.sic46
g l2sic47=l4.sic47
g l2sic48=l4.sic48
g l2sic49=l4.sic49
g l2sic50=l4.sic50
g l2sic51=l4.sic51
g l2sic52=l4.sic52
g l2sic53=l4.sic53
g l2sic54=l4.sic54
g l2sic55=l4.sic55
g l2sic56=l4.sic56
g l2sic57=l4.sic57
g l2sic58=l4.sic58
g l2sic59=l4.sic59
g l2sic60=l4.sic60
g l2sic61=l4.sic61
g l2sic62=l4.sic62
g l2sic63=l4.sic63
g l2sic64=l4.sic64
g l2sic65=l4.sic65
g l2sic66=l4.sic66

g l2state1=l4.state1
g l2state2=l4.state2
g l2state3=l4.state3
g l2state4=l4.state4
g l2state5=l4.state5
g l2state6=l4.state6
g l2state7=l4.state7
g l2state8=l4.state8
g l2state9=l4.state9
g l2state10=l4.state10
g l2state11=l4.state11
g l2state12=l4.state12
g l2state13=l4.state13
g l2state14=l4.state14
g l2state15=l4.state15
g l2state16=l4.state16
g l2state17=l4.state17
g l2state18=l4.state18
g l2state19=l4.state19
g l2state20=l4.state20
g l2state21=l4.state21
g l2state22=l4.state22
g l2state23=l4.state23
g l2state24=l4.state24
g l2state25=l4.state25
g l2state26=l4.state26
g l2state27=l4.state27
g l2state28=l4.state28
g l2state29=l4.state29
g l2state30=l4.state30
g l2state31=l4.state31
g l2state32=l4.state32
g l2state33=l4.state33
g l2state34=l4.state34
g l2state35=l4.state35
g l2state36=l4.state36
g l2state37=l4.state37
g l2state38=l4.state38
g l2state39=l4.state39
g l2state40=l4.state40
g l2state41=l4.state41
g l2state42=l4.state42
g l2state43=l4.state43
g l2state44=l4.state44
g l2state45=l4.state45
g l2state46=l4.state46
g l2state47=l4.state47
g l2state48=l4.state48
g l2state49=l4.state49
g l2state50=l4.state50

g d2wage=l2.lnrwage-l4.lnrwage
g d2educ=l2.educ-l4.educ
g d2age=l2.age-l4.age
g d2age2=l2.age2-l4.age2
g d2neast=l2.neast-l4.neast
g d2ncent=l2.ncent-l4.ncent
g d2west=l2.west-l4.west
g d2union=l2.union-l4.union
g d2marry=l2.marry-l4.marry
g d2white=l2.white-l4.white
g d2occ1=l2.occ1-l4.occ1
g d2occ2=l2.occ2-l4.occ2
g d2occ3=l2.occ3-l4.occ3
g d2occ4=l2.occ4-l4.occ4
g d2occ5=l2.occ5-l4.occ5
g d2occ6=l2.occ6-l4.occ6
g d2occ7=l2.occ7-l4.occ7
g d2occ8=l2.occ8-l4.occ8
g d2occ9=l2.occ9-l4.occ9
g d2occ10=l2.occ10-l4.occ10
g d2indd1=l2.indd1-l4.indd1
g d2indd2=l2.indd2-l4.indd2
g d2indd3=l2.indd3-l4.indd3
g d2indd4=l2.indd4-l4.indd4
g d2indd5=l2.indd5-l4.indd5
g d2indd6=l2.indd6-l4.indd6
g d2indd7=l2.indd7-l4.indd7
g d2indd8=l2.indd8-l4.indd8
g d2indd9=l2.indd9-l4.indd9
g d2indd10=l2.indd10-l4.indd10
g d2rnly=l2.lnrnly-l4.lnrnly
g d2negnly=l2.negnly-l4.negnly
g d2hours=l2.lnhours-l4.lnhours
g d2state1=l2.state1-l4.state1
g d2state2=l2.state2-l4.state2
g d2state3=l2.state3-l4.state3
g d2state4=l2.state4-l4.state4
g d2state5=l2.state5-l4.state5
g d2state6=l2.state6-l4.state6
g d2state7=l2.state7-l4.state7
g d2state8=l2.state8-l4.state8
g d2state9=l2.state9-l4.state9
g d2state10=l2.state10-l4.state10
g d2state11=l2.state11-l4.state11
g d2state12=l2.state12-l4.state12
g d2state13=l2.state13-l4.state13
g d2state14=l2.state14-l4.state14
g d2state15=l2.state15-l4.state15
g d2state16=l2.state16-l4.state16
g d2state17=l2.state17-l4.state17
g d2state18=l2.state18-l4.state18
g d2state19=l2.state19-l4.state19
g d2state20=l2.state20-l4.state20
g d2state21=l2.state21-l4.state21
g d2state22=l2.state22-l4.state22
g d2state23=l2.state23-l4.state23
g d2state24=l2.state24-l4.state24
g d2state25=l2.state25-l4.state25
g d2state26=l2.state26-l4.state26
g d2state27=l2.state27-l4.state27
g d2state28=l2.state28-l4.state28
g d2state29=l2.state29-l4.state29
g d2state30=l2.state30-l4.state30
g d2state31=l2.state31-l4.state31
g d2state32=l2.state32-l4.state32
g d2state33=l2.state33-l4.state33
g d2state34=l2.state34-l4.state34
g d2state35=l2.state35-l4.state35
g d2state36=l2.state36-l4.state36
g d2state37=l2.state37-l4.state37
g d2state38=l2.state38-l4.state38
g d2state39=l2.state39-l4.state39
g d2state40=l2.state40-l4.state40
g d2state41=l2.state41-l4.state41
g d2state42=l2.state42-l4.state42
g d2state43=l2.state43-l4.state43
g d2state44=l2.state44-l4.state44
g d2state45=l2.state45-l4.state45
g d2state46=l2.state46-l4.state46
g d2state47=l2.state47-l4.state47
g d2state48=l2.state48-l4.state48
g d2state49=l2.state49-l4.state49
g d2state50=l2.state50-l4.state50


global i2xx="l2wage l2age l2age2 l2cendiv2-l2cendiv9 l2union l2marry l2occ1 l2occ2 l2occ3 l2occ4 l2occ5 l2occ6 l2occ7 l2occ8 l2occ9 l2sic2-l2sic66 l2state2-l2state50"

/* @@@@@@@@@@@ ARRELLANO-BOND DYNAMIC FIRST DIFFERENCES  @@@@@@@@@@*/


/* annual fatality models */


xtset id year,delta(2)

xtabond lnrwage yr_3-yr_5 if pct_chng>-75 & pct_chng<300, lags(1) noconstant diffvars($dxx) inst($i2xx)

g oid=e(sargan)
sum oid

drop oid

estat sargan

g n=e(N)
matrix v=e(V)
matrix varf=el(v,5,5)
g var_fatal=trace(varf)
matrix varl=el(v,1,1)
g var_lagwage=trace(varl)
matrix covfl=el(v,1,5)
g cov_betagamma=trace(covfl)

means rwage if e(sample)
gen mnwage=r(mean)
gen varwage=r(Var) 

sum mnwage varwage var_fatal

means ttl_work_hrs if e(sample)
g mnhrs=r(mean)
g varhrs=r(Var)
correlate rwage ttl_work_hrs, covariance
g cov_wghrs=r(cov_12)

g ivl1=_b[dfatal]*mnwage*2000*100000
g var_ivl1=(2000^2)*(100000^2)*(mnwage^2*var_fatal + _b[dfatal]^2*varwage + var_fatal*varwage)
g sd_ivl1=sqrt(var_ivl1)
g ci95lower=ivl1-1.96*(sd_ivl1)
g ci95upper=ivl1+1.96*(sd_ivl1)

g ivl1_alt=_b[dfatal]*mnwage*mnhrs*100000
g var_ivl1_alt = (100000^2)*( mnwage^2*mnhrs^2*var_fatal + _b[dfatal]^2*mnhrs^2*varwage + _b[dfatal]^2*mnwage^2*varhrs + 2*_b[dfatal]*cov_wghrs + var_fatal*varwage*varhrs + cov_wghrs^2)
g sd_ivl1_alt=sqrt(var_ivl1_alt)
g ci95lower_alt=ivl1_alt-1.96*(sd_ivl1_alt)
g ci95upper_alt=ivl1_alt+1.96*(sd_ivl1_alt)

g lrfr=(_b[dfatal]/(1-_b[L1.lnrwage]))

g ivl1_dyn=(_b[dfatal]/(1-_b[L1.lnrwage]))*mnwage*2000*100000
g var_ivl1_dyn=(2000^2)*(100000^2)*((mnwage/(1-_b[L1.lnrwage]))^2*var_fatal + ///
(_b[dfatal]/(1-_b[L1.lnrwage]))^2*varwage + ((mnwage*_b[dfatal]/(1-_b[L1.lnrwage])^2)^2)*var_lagwage + ///
2*((_b[dfatal]/(1-_b[L1.lnrwage]))^2)*(1/(1-_b[L1.lnrwage]))*(mnwage)^2*cov_betagamma)+ var_fatal*varwage
g sd_ivl1_dyn=sqrt(var_ivl1_dyn)
g ci95lower_dyn=ivl1_dyn-1.96*(sd_ivl1_dyn)
g ci95upper_dyn=ivl1_dyn+1.96*(sd_ivl1_dyn)



sum ivl1 var_ivl1 sd_ivl1 ci95lower ci95upper  ivl1_alt var_ivl1_alt ///
sd_ivl1_alt ci95lower_alt ci95upper_alt  ivl1_dyn var_ivl1_dyn sd_ivl1_dyn ///
ci95lower_dyn ci95upper_dyn if e(sample)
sum lrfr
testnl _b[dfatal]/(1-_b[L1.lnrwage]) =0

/* Assume regressors are fixed constants in calculation of C.I. */

drop ivl1 var_ivl1 sd_ivl1 ci95lower ci95upper ivl1_alt var_ivl1_alt sd_ivl1_alt ci95lower_alt ci95upper_alt ivl1_dyn var_ivl1_dyn sd_ivl1_dyn ci95lower_dyn ci95upper_dyn

g ivl1=_b[dfatal]*mnwage*2000*100000
g var_ivl1=(2000^2)*(100000^2)*(mnwage^2*var_fatal)
g sd_ivl1=sqrt(var_ivl1)
g ci95lower=ivl1-1.96*(sd_ivl1)
g ci95upper=ivl1+1.96*(sd_ivl1)

g ivl1_alt=_b[dfatal]*mnwage*mnhrs*100000
g var_ivl1_alt = (100000^2)*( mnwage^2*mnhrs^2*var_fatal)
g sd_ivl1_alt=sqrt(var_ivl1_alt)
g ci95lower_alt=ivl1_alt-1.96*(sd_ivl1_alt)
g ci95upper_alt=ivl1_alt+1.96*(sd_ivl1_alt)

g ivl1_dyn=(_b[dfatal]/(1-_b[L1.lnrwage]))*mnwage*mnhrs*100000
g var_ivl1_dyn=(100000^2)*(((mnwage*mnhrs)/(1-_b[L1.lnrwage]))^2*var_fatal + ((mnhrs*mnwage*_b[dfatal]/(1-_b[L1.lnrwage])^2)^2)*var_lagwage + 2*((_b[dfatal]/(1-_b[L1.lnrwage]))^2)*(1/(1-_b[L1.lnrwage]))*(mnwage*mnhrs)^2*cov_betagamma)
g sd_ivl1_dyn=sqrt(var_ivl1_dyn)
g ci95lower_dyn=ivl1_dyn-1.96*(sd_ivl1_dyn)
g ci95upper_dyn=ivl1_dyn+1.96*(sd_ivl1_dyn)


sum ivl1 var_ivl1 sd_ivl1 ci95lower ci95upper ivl1_alt var_ivl1_alt ///
sd_ivl1_alt ci95lower_alt ci95upper_alt ivl1_dyn var_ivl1_dyn sd_ivl1_dyn ///
ci95lower_dyn ci95upper_dyn if e(sample)

drop mnwage varwage mnhrs varhrs cov_wghrs var_fatal ivl1 var_ivl1 sd_ivl1 ///
ci95lower ci95upper ivl1_alt var_ivl1_alt sd_ivl1_alt ci95lower_alt ///
ci95upper_alt n  ivl1_dyn var_ivl1_dyn sd_ivl1_dyn ci95lower_dyn ci95upper_dyn ///
var_lagwage cov_betagamma lrfr
matrix drop v varf varl covfl


/* 3-year fatality models */


global dxx="dfatal3 dage dage2 dcendiv2-dcendiv9 dunion dmarry docc1 docc2 docc3 docc4 docc5 docc6 docc7 docc8 docc9 dsic2-dsic66 dstate2-dstate50"

xtabond lnrwage yr_3-yr_5 if pct_chng3b>-75 & pct_chng3b<300, lags(1) noconstant diffvars($dxx) inst($i2xx)

g oid=e(sargan)
sum oid

drop oid

estat sargan

g n=e(N)
matrix v=e(V)
matrix varf=el(v,5,5)
g var_fatal=trace(varf)
matrix varl=el(v,1,1)
g var_lagwage=trace(varl)
matrix covfl=el(v,1,5)
g cov_betagamma=trace(covfl)

means rwage if e(sample)
gen mnwage=r(mean)
gen varwage=r(Var) 

sum mnwage varwage var_fatal

means ttl_work_hrs if e(sample)
g mnhrs=r(mean)
g varhrs=r(Var)
correlate rwage ttl_work_hrs, covariance
g cov_wghrs=r(cov_12)

g ivl1=_b[dfatal3]*mnwage*2000*100000
g var_ivl1=(2000^2)*(100000^2)*(mnwage^2*var_fatal + _b[dfatal3]^2*varwage + var_fatal*varwage)
g sd_ivl1=sqrt(var_ivl1)
g ci95lower=ivl1-1.96*(sd_ivl1)
g ci95upper=ivl1+1.96*(sd_ivl1)

g ivl1_alt=_b[dfatal3]*mnwage*mnhrs*100000
g var_ivl1_alt = (100000^2)*( mnwage^2*mnhrs^2*var_fatal + _b[dfatal3]^2*mnhrs^2*varwage + _b[dfatal3]^2*mnwage^2*varhrs + 2*_b[dfatal3]*cov_wghrs + var_fatal*varwage*varhrs + cov_wghrs^2)
g sd_ivl1_alt=sqrt(var_ivl1_alt)
g ci95lower_alt=ivl1_alt-1.96*(sd_ivl1_alt)
g ci95upper_alt=ivl1_alt+1.96*(sd_ivl1_alt)

g lrfr=(_b[dfatal3]/(1-_b[L1.lnrwage]))

g ivl1_dyn=(_b[dfatal3]/(1-_b[L1.lnrwage]))*mnwage*2000*100000
g var_ivl1_dyn=(2000^2)*(100000^2)*((mnwage/(1-_b[L1.lnrwage]))^2*var_fatal + ///
(_b[dfatal3]/(1-_b[L1.lnrwage]))^2*varwage + ((mnwage*_b[dfatal3]/(1-_b[L1.lnrwage])^2)^2)*var_lagwage + ///
2*((_b[dfatal3]/(1-_b[L1.lnrwage]))^2)*(1/(1-_b[L1.lnrwage]))*(mnwage)^2*cov_betagamma)+ var_fatal*varwage
g sd_ivl1_dyn=sqrt(var_ivl1_dyn)
g ci95lower_dyn=ivl1_dyn-1.96*(sd_ivl1_dyn)
g ci95upper_dyn=ivl1_dyn+1.96*(sd_ivl1_dyn)


sum ivl1 var_ivl1 sd_ivl1 ci95lower ci95upper  ivl1_alt var_ivl1_alt ///
sd_ivl1_alt ci95lower_alt ci95upper_alt  ivl1_dyn var_ivl1_dyn sd_ivl1_dyn ///
ci95lower_dyn ci95upper_dyn if e(sample)
sum lrfr
testnl _b[dfatal3]/(1-_b[L1.lnrwage]) =0

/* Assume regressors are fixed constants in calculation of C.I. */

drop ivl1 var_ivl1 sd_ivl1 ci95lower ci95upper ivl1_alt var_ivl1_alt sd_ivl1_alt ci95lower_alt ci95upper_alt ivl1_dyn var_ivl1_dyn sd_ivl1_dyn ci95lower_dyn ci95upper_dyn

g ivl1=_b[dfatal3]*mnwage*2000*100000
g var_ivl1=(2000^2)*(100000^2)*(mnwage^2*var_fatal)
g sd_ivl1=sqrt(var_ivl1)
g ci95lower=ivl1-1.96*(sd_ivl1)
g ci95upper=ivl1+1.96*(sd_ivl1)

g ivl1_alt=_b[dfatal3]*mnwage*mnhrs*100000
g var_ivl1_alt = (100000^2)*( mnwage^2*mnhrs^2*var_fatal)
g sd_ivl1_alt=sqrt(var_ivl1_alt)
g ci95lower_alt=ivl1_alt-1.96*(sd_ivl1_alt)
g ci95upper_alt=ivl1_alt+1.96*(sd_ivl1_alt)

g ivl1_dyn=(_b[dfatal3]/(1-_b[L1.lnrwage]))*mnwage*mnhrs*100000
g var_ivl1_dyn=(100000^2)*(((mnwage*mnhrs)/(1-_b[L1.lnrwage]))^2*var_fatal + ((mnhrs*mnwage*_b[dfatal3]/(1-_b[L1.lnrwage])^2)^2)*var_lagwage + 2*((_b[dfatal3]/(1-_b[L1.lnrwage]))^2)*(1/(1-_b[L1.lnrwage]))*(mnwage*mnhrs)^2*cov_betagamma)
g sd_ivl1_dyn=sqrt(var_ivl1_dyn)
g ci95lower_dyn=ivl1_dyn-1.96*(sd_ivl1_dyn)
g ci95upper_dyn=ivl1_dyn+1.96*(sd_ivl1_dyn)

sum ivl1 var_ivl1 sd_ivl1 ci95lower ci95upper ivl1_alt var_ivl1_alt ///
sd_ivl1_alt ci95lower_alt ci95upper_alt ivl1_dyn var_ivl1_dyn ///
sd_ivl1_dyn ci95lower_dyn ci95upper_dyn if e(sample)

drop mnwage varwage mnhrs varhrs cov_wghrs var_fatal ivl1 var_ivl1 ///
sd_ivl1 ci95lower ci95upper ivl1_alt var_ivl1_alt sd_ivl1_alt ci95lower_alt ///
ci95upper_alt n  ivl1_dyn var_ivl1_dyn sd_ivl1_dyn ci95lower_dyn ci95upper_dyn ///
var_lagwage cov_betagamma lrfr
matrix drop v varf varl covfl



log close
