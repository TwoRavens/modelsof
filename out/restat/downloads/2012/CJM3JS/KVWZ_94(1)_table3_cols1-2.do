clear all

set more 1
set mat 800
set mem 150M
set logtype text

cd "C:\Data\PSID\Injury\RESTAT files"

capture log close

log using "KVWZ_94(1)_table3_cols1-2.txt",replace

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


/* 1-yr changes in annual and 3-year fatality rate */


g pct_chng=100*(fatalrate_ - lagfatal_)/lagfatal_
g pct_chng3b=100*(fatalrate3b_ - lagfatal3b_)/lagfatal3b_



/* @@@@@@@@@@@ FIRST DIFFERENCES for column 1 of Table 3 @@@@@@@@@@*/



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

g dcendiv1=cendiv1-l2.cendiv1
g dcendiv2=cendiv2-l2.cendiv2
g dcendiv3=cendiv3-l2.cendiv3
g dcendiv4=cendiv4-l2.cendiv4
g dcendiv5=cendiv5-l2.cendiv5
g dcendiv6=cendiv6-l2.cendiv6
g dcendiv7=cendiv7-l2.cendiv7
g dcendiv8=cendiv8-l2.cendiv8
g dcendiv9=cendiv9-l2.cendiv9

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


/* 2-yr lag difference and difference in difference for column 2 of Table 3 */

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

g d2cendiv1=l2.cendiv1-l4.cendiv1
g d2cendiv2=l2.cendiv2-l4.cendiv2
g d2cendiv3=l2.cendiv3-l4.cendiv3
g d2cendiv4=l2.cendiv4-l4.cendiv4
g d2cendiv5=l2.cendiv5-l4.cendiv5
g d2cendiv6=l2.cendiv6-l4.cendiv6
g d2cendiv7=l2.cendiv7-l4.cendiv7
g d2cendiv8=l2.cendiv8-l4.cendiv8
g d2cendiv9=l2.cendiv9-l4.cendiv9

g d2sic1=l2.sic1-l4.sic1
g d2sic2=l2.sic2-l4.sic2
g d2sic3=l2.sic3-l4.sic3
g d2sic4=l2.sic4-l4.sic4
g d2sic5=l2.sic5-l4.sic5
g d2sic6=l2.sic6-l4.sic6
g d2sic7=l2.sic7-l4.sic7
g d2sic8=l2.sic8-l4.sic8
g d2sic9=l2.sic9-l4.sic9
g d2sic10=l2.sic10-l4.sic10
g d2sic11=l2.sic11-l4.sic11
g d2sic12=l2.sic12-l4.sic12
g d2sic13=l2.sic13-l4.sic13
g d2sic14=l2.sic14-l4.sic14
g d2sic15=l2.sic15-l4.sic15
g d2sic16=l2.sic16-l4.sic16
g d2sic17=l2.sic17-l4.sic17
g d2sic18=l2.sic18-l4.sic18
g d2sic19=l2.sic19-l4.sic19
g d2sic20=l2.sic20-l4.sic20
g d2sic21=l2.sic21-l4.sic21
g d2sic22=l2.sic22-l4.sic22
g d2sic23=l2.sic23-l4.sic23
g d2sic24=l2.sic24-l4.sic24
g d2sic25=l2.sic25-l4.sic25
g d2sic26=l2.sic26-l4.sic26
g d2sic27=l2.sic27-l4.sic27
g d2sic28=l2.sic28-l4.sic28
g d2sic29=l2.sic29-l4.sic29
g d2sic30=l2.sic30-l4.sic30
g d2sic31=l2.sic31-l4.sic31
g d2sic32=l2.sic32-l4.sic32
g d2sic33=l2.sic33-l4.sic33
g d2sic34=l2.sic34-l4.sic34
g d2sic35=l2.sic35-l4.sic35
g d2sic36=l2.sic36-l4.sic36
g d2sic37=l2.sic37-l4.sic37
g d2sic38=l2.sic38-l4.sic38
g d2sic39=l2.sic39-l4.sic39
g d2sic40=l2.sic40-l4.sic40
g d2sic41=l2.sic41-l4.sic41
g d2sic42=l2.sic42-l4.sic42
g d2sic43=l2.sic43-l4.sic43
g d2sic44=l2.sic44-l4.sic44
g d2sic45=l2.sic45-l4.sic45
g d2sic46=l2.sic46-l4.sic46
g d2sic47=l2.sic47-l4.sic47
g d2sic48=l2.sic48-l4.sic48
g d2sic49=l2.sic49-l4.sic49
g d2sic50=l2.sic50-l4.sic50
g d2sic51=l2.sic51-l4.sic51
g d2sic52=l2.sic52-l4.sic52
g d2sic53=l2.sic53-l4.sic53
g d2sic54=l2.sic54-l4.sic54
g d2sic55=l2.sic55-l4.sic55
g d2sic56=l2.sic56-l4.sic56
g d2sic57=l2.sic57-l4.sic57
g d2sic58=l2.sic58-l4.sic58
g d2sic59=l2.sic59-l4.sic59
g d2sic60=l2.sic60-l4.sic60
g d2sic61=l2.sic61-l4.sic61
g d2sic62=l2.sic62-l4.sic62
g d2sic63=l2.sic63-l4.sic63
g d2sic64=l2.sic64-l4.sic64
g d2sic65=l2.sic65-l4.sic65
g d2sic66=l2.sic66-l4.sic66
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

g d2fatal=l2.fatal-l4.fatal
g d2fatal3=l2.fatal3-l4.fatal3


g ddwage=dwage-d2wage
g ddfatal=dfatal-d2fatal
g ddfatal3=dfatal3-d2fatal3

g ddeduc=deduc-d2educ
g ddage=dage-d2age
g ddage2=dage2-d2age2
g ddneast=dneast-d2neast
g ddncent=dncent-d2ncent
g ddwest=dwest-d2west
g ddunion=dunion-d2union
g ddmarry=dmarry-d2marry
g ddwhite=dwhite-d2white
g ddocc1=docc1-d2occ1
g ddocc2=docc2-d2occ2
g ddocc3=docc3-d2occ3
g ddocc4=docc4-d2occ4
g ddocc5=docc5-d2occ5
g ddocc6=docc6-d2occ6
g ddocc7=docc7-d2occ7
g ddocc8=docc8-d2occ8
g ddocc9=docc9-d2occ9
g ddocc10=docc10-d2occ10

g ddcendiv1=dcendiv1-d2cendiv1
g ddcendiv2=dcendiv2-d2cendiv2
g ddcendiv3=dcendiv3-d2cendiv3
g ddcendiv4=dcendiv4-d2cendiv4
g ddcendiv5=dcendiv5-d2cendiv5
g ddcendiv6=dcendiv6-d2cendiv6
g ddcendiv7=dcendiv7-d2cendiv7
g ddcendiv8=dcendiv8-d2cendiv8
g ddcendiv9=dcendiv9-d2cendiv9

g ddsic1=dsic1-d2sic1
g ddsic2=dsic2-d2sic2
g ddsic3=dsic3-d2sic3
g ddsic4=dsic4-d2sic4
g ddsic5=dsic5-d2sic5
g ddsic6=dsic6-d2sic6
g ddsic7=dsic7-d2sic7
g ddsic8=dsic8-d2sic8
g ddsic9=dsic9-d2sic9
g ddsic10=dsic10-d2sic10
g ddsic11=dsic11-d2sic11
g ddsic12=dsic12-d2sic12
g ddsic13=dsic13-d2sic13
g ddsic14=dsic14-d2sic14
g ddsic15=dsic15-d2sic15
g ddsic16=dsic16-d2sic16
g ddsic17=dsic17-d2sic17
g ddsic18=dsic18-d2sic18
g ddsic19=dsic19-d2sic19
g ddsic20=dsic20-d2sic20
g ddsic21=dsic21-d2sic21
g ddsic22=dsic22-d2sic22
g ddsic23=dsic23-d2sic23
g ddsic24=dsic24-d2sic24
g ddsic25=dsic25-d2sic25
g ddsic26=dsic26-d2sic26
g ddsic27=dsic27-d2sic27
g ddsic28=dsic28-d2sic28
g ddsic29=dsic29-d2sic29
g ddsic30=dsic30-d2sic30
g ddsic31=dsic31-d2sic31
g ddsic32=dsic32-d2sic32
g ddsic33=dsic33-d2sic33
g ddsic34=dsic34-d2sic34
g ddsic35=dsic35-d2sic35
g ddsic36=dsic36-d2sic36
g ddsic37=dsic37-d2sic37
g ddsic38=dsic38-d2sic38
g ddsic39=dsic39-d2sic39
g ddsic40=dsic40-d2sic40
g ddsic41=dsic41-d2sic41
g ddsic42=dsic42-d2sic42
g ddsic43=dsic43-d2sic43
g ddsic44=dsic44-d2sic44
g ddsic45=dsic45-d2sic45
g ddsic46=dsic46-d2sic46
g ddsic47=dsic47-d2sic47
g ddsic48=dsic48-d2sic48
g ddsic49=dsic49-d2sic49
g ddsic50=dsic50-d2sic50
g ddsic51=dsic51-d2sic51
g ddsic52=dsic52-d2sic52
g ddsic53=dsic53-d2sic53
g ddsic54=dsic54-d2sic54
g ddsic55=dsic55-d2sic55
g ddsic56=dsic56-d2sic56
g ddsic57=dsic57-d2sic57
g ddsic58=dsic58-d2sic58
g ddsic59=dsic59-d2sic59
g ddsic60=dsic60-d2sic60
g ddsic61=dsic61-d2sic61
g ddsic62=dsic62-d2sic62
g ddsic63=dsic63-d2sic63
g ddsic64=dsic64-d2sic64
g ddsic65=dsic65-d2sic65
g ddsic66=dsic66-d2sic66
g ddindd1=dindd1-d2indd1
g ddindd2=dindd2-d2indd2
g ddindd3=dindd3-d2indd3
g ddindd4=dindd4-d2indd4
g ddindd5=dindd5-d2indd5
g ddindd6=dindd6-d2indd6
g ddindd7=dindd7-d2indd7
g ddindd8=dindd8-d2indd8
g ddindd9=dindd9-d2indd9
g ddindd10=dindd10-d2indd10
g ddstate1=dstate1-d2state1
g ddstate2=dstate2-d2state2
g ddstate3=dstate3-d2state3
g ddstate4=dstate4-d2state4
g ddstate5=dstate5-d2state5
g ddstate6=dstate6-d2state6
g ddstate7=dstate7-d2state7
g ddstate8=dstate8-d2state8
g ddstate9=dstate9-d2state9
g ddstate10=dstate10-d2state10
g ddstate11=dstate11-d2state11
g ddstate12=dstate12-d2state12
g ddstate13=dstate13-d2state13
g ddstate14=dstate14-d2state14
g ddstate15=dstate15-d2state15
g ddstate16=dstate16-d2state16
g ddstate17=dstate17-d2state17
g ddstate18=dstate18-d2state18
g ddstate19=dstate19-d2state19
g ddstate20=dstate20-d2state20
g ddstate21=dstate21-d2state21
g ddstate22=dstate22-d2state22
g ddstate23=dstate23-d2state23
g ddstate24=dstate24-d2state24
g ddstate25=dstate25-d2state25
g ddstate26=dstate26-d2state26
g ddstate27=dstate27-d2state27
g ddstate28=dstate28-d2state28
g ddstate29=dstate29-d2state29
g ddstate30=dstate30-d2state30
g ddstate31=dstate31-d2state31
g ddstate32=dstate32-d2state32
g ddstate33=dstate33-d2state33
g ddstate34=dstate34-d2state34
g ddstate35=dstate35-d2state35
g ddstate36=dstate36-d2state36
g ddstate37=dstate37-d2state37
g ddstate38=dstate38-d2state38
g ddstate39=dstate39-d2state39
g ddstate40=dstate40-d2state40
g ddstate41=dstate41-d2state41
g ddstate42=dstate42-d2state42
g ddstate43=dstate43-d2state43
g ddstate44=dstate44-d2state44
g ddstate45=dstate45-d2state45
g ddstate46=dstate46-d2state46
g ddstate47=dstate47-d2state47
g ddstate48=dstate48-d2state48
g ddstate49=dstate49-d2state49
g ddstate50=dstate50-d2state50

/* COLUMN 1 TABLE 3 */

/* annual fatality model */

reg dwage dfatal dage dage2 dcendiv2-dcendiv9 dunion dmarry docc1 docc2 docc3 ///
docc4 docc5 docc6 docc7 docc8 docc9 dsic2-dsic66 yr_2-yr_5 dstate2-dstate50 ///
if pct_chng>-75 & pct_chng<300, noconstant robust cluster(indocc)


g n=e(N)
matrix v=e(V)
matrix varf=el(v,1,1)
g var_fatal=trace(varf)
means rwage if e(sample)
gen mnwage=r(mean)
gen varwage=r(Var) 

sum mnwage varwage var_fatal

means ttl_work_hrs if e(sample)
g mnhrs=r(mean)
g varhrs=r(Var)
correlate rwage ttl_work_hrs, covariance
g cov_wghrs=r(cov_12)

/* ivl1 uses fixed hours = 2000; ivl1_alt uses sample hours */


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

sum ivl1 var_ivl1 sd_ivl1 ci95lower ci95upper  ivl1_alt var_ivl1_alt sd_ivl1_alt ci95lower_alt ci95upper_alt if e(sample)

drop mnwage varwage mnhrs varhrs cov_wghrs var_fatal ivl1 var_ivl1 sd_ivl1 ci95lower ci95upper ivl1_alt var_ivl1_alt sd_ivl1_alt ci95lower_alt ci95upper_alt n
matrix drop v varf



/* 3-year fatality models (B) */



reg dwage dfatal3 dage dage2 dcendiv2-dcendiv9 dunion dmarry docc1 docc2 docc3 ///
docc4 docc5 docc6 docc7 docc8 docc9 dsic2-dsic66 yr_2-yr_5 dstate2-dstate50 ///
if pct_chng3b>-75 & pct_chng3b<300, noconstant robust cluster(indocc)


g n=e(N)
matrix v=e(V)
matrix varf=el(v,1,1)
g var_fatal=trace(varf)
means rwage if e(sample)
gen mnwage=r(mean)
gen varwage=r(Var) 

sum mnwage varwage var_fatal

means ttl_work_hrs if e(sample)
g mnhrs=r(mean)
g varhrs=r(Var)
correlate rwage ttl_work_hrs, covariance
g cov_wghrs=r(cov_12)


/* ivl1 uses fixed hours = 2000; ivl1_alt uses sample hours */


g ivl1=_b[dfatal3]*mnwage*2000*100000
g var_ivl1=(2000^2)*(100000^2)*(mnwage^2*var_fatal)
g sd_ivl1=sqrt(var_ivl1)
g ci95lower=ivl1-1.96*(sd_ivl1)
g ci95upper=ivl1+1.96*(sd_ivl1/sqrt(n))

g ivl1_alt=_b[dfatal3]*mnwage*mnhrs*100000
g var_ivl1_alt = (100000^2)*( mnwage^2*mnhrs^2*var_fatal)
g sd_ivl1_alt=sqrt(var_ivl1_alt)
g ci95lower_alt=ivl1_alt-1.96*(sd_ivl1_alt)
g ci95upper_alt=ivl1_alt+1.96*(sd_ivl1_alt)

sum ivl1 var_ivl1 sd_ivl1 ci95lower ci95upper  ivl1_alt var_ivl1_alt sd_ivl1_alt ci95lower_alt ci95upper_alt if e(sample)

drop mnwage varwage mnhrs varhrs cov_wghrs var_fatal ivl1 var_ivl1 sd_ivl1 ci95lower ci95upper ivl1_alt var_ivl1_alt sd_ivl1_alt ci95lower_alt ci95upper_alt n
matrix drop v varf





/* @@@@@@@@@@@ DIFFERENCE IN DIFFERENCES ESTIMATOR Column 2 of Table 3 @@@@@@@@@@@ */


/* annual fatality models */

reg ddwage ddfatal ddage ddage2 ddcendiv2-ddcendiv9 ddunion ddmarry ddocc1 ///
ddocc2 ddocc3 ddocc4 ddocc5 ddocc6 ddocc7 ddocc8 ddocc9 ddsic2-ddsic66 ///
ddstate2-ddstate50 yr_2-yr_5 if pct_chng>-75 & pct_chng<300, noconstant robust cluster(indocc)

g n=e(N)
matrix v=e(V)
matrix varf=el(v,1,1)
g var_fatal=trace(varf)
means rwage if e(sample)
gen mnwage=r(mean)
gen varwage=r(Var) 

sum mnwage varwage var_fatal

means ttl_work_hrs if e(sample)
g mnhrs=r(mean)
g varhrs=r(Var)
correlate rwage ttl_work_hrs, covariance
g cov_wghrs=r(cov_12)


/* ivl1 uses fixed hours = 2000; ivl1_alt uses sample hours */


g ivl1=_b[ddfatal]*mnwage*2000*100000
g var_ivl1=(2000^2)*(100000^2)*(mnwage^2*var_fatal)
g sd_ivl1=sqrt(var_ivl1)
g ci95lower=ivl1-1.96*(sd_ivl1)
g ci95upper=ivl1+1.96*(sd_ivl1)

g ivl1_alt=_b[ddfatal]*mnwage*mnhrs*100000
g var_ivl1_alt = (100000^2)*( mnwage^2*mnhrs^2*var_fatal)
g sd_ivl1_alt=sqrt(var_ivl1_alt)
g ci95lower_alt=ivl1_alt-1.96*(sd_ivl1_alt)
g ci95upper_alt=ivl1_alt+1.96*(sd_ivl1_alt)

sum ivl1 var_ivl1 sd_ivl1 ci95lower ci95upper  ivl1_alt var_ivl1_alt sd_ivl1_alt ci95lower_alt ci95upper_alt if e(sample)

drop mnwage varwage mnhrs varhrs cov_wghrs var_fatal ivl1 var_ivl1 sd_ivl1 ci95lower ci95upper ivl1_alt var_ivl1_alt sd_ivl1_alt ci95lower_alt ci95upper_alt n
matrix drop v varf


/* 3 year avg fatality models */


reg ddwage ddfatal3 ddage ddage2 ddcendiv2-ddcendiv9 ddunion ddmarry ///
ddocc1 ddocc2 ddocc3 ddocc4 ddocc5 ddocc6 ddocc7 ddocc8 ddocc9 ddsic2-ddsic66 ///
ddstate2-ddstate50 yr_2-yr_5 if pct_chng3b>-75 & pct_chng<300, noconstant robust cluster(indocc)

g n=e(N)
matrix v=e(V)
matrix varf=el(v,1,1)
g var_fatal=trace(varf)
means rwage if e(sample)
gen mnwage=r(mean)
gen varwage=r(Var) 

sum mnwage varwage var_fatal

means ttl_work_hrs if e(sample)
g mnhrs=r(mean)
g varhrs=r(Var)
correlate rwage ttl_work_hrs, covariance
g cov_wghrs=r(cov_12)


/* ivl1 uses fixed hours = 2000; ivl1_alt uses sample hours */

g ivl1=_b[ddfatal3]*mnwage*2000*100000
g var_ivl1=(2000^2)*(100000^2)*(mnwage^2*var_fatal)
g sd_ivl1=sqrt(var_ivl1)
g ci95lower=ivl1-1.96*(sd_ivl1)
g ci95upper=ivl1+1.96*(sd_ivl1)

g ivl1_alt=_b[ddfatal3]*mnwage*mnhrs*100000
g var_ivl1_alt = (100000^2)*( mnwage^2*mnhrs^2*var_fatal)
g sd_ivl1_alt=sqrt(var_ivl1_alt)
g ci95lower_alt=ivl1_alt-1.96*(sd_ivl1_alt)
g ci95upper_alt=ivl1_alt+1.96*(sd_ivl1_alt)

sum ivl1 var_ivl1 sd_ivl1 ci95lower ci95upper  ivl1_alt var_ivl1_alt sd_ivl1_alt ci95lower_alt ci95upper_alt if e(sample)

drop mnwage varwage mnhrs varhrs cov_wghrs var_fatal ivl1 var_ivl1 sd_ivl1 ci95lower ci95upper ivl1_alt var_ivl1_alt sd_ivl1_alt ci95lower_alt ci95upper_alt n
matrix drop v varf



log close

