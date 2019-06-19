clear all

set more 1
set mat 800
set mem 150M
set logtype text

cd "C:\Data\PSID\Injury\RESTAT files"

capture log close

log using "KVWZ_94(1)_table5_cols3-6.txt",replace

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
tab cendiv, gen(cendiv)


/* 1-yr changes in fatality rate */


g pct_chng=100*(fatalrate_ - lagfatal_)/lagfatal_
g pct_chng3b=100*(fatalrate3b_ - lagfatal3b_)/lagfatal3b_

g lagpct_chng=100*(lagfatal_ - lag2fatal_)/lag2fatal_
g lagpct_chng3b=100*(lagfatal3b_ - lag2fatal3b_)/lag2fatal3b_

g fatal=fatalrate_
g fatal3=fatalrate3b_

g cfatal=lagfatal_
g cfatal3=lagfatal3b_

/* @@@@@@@@@@@ Grilliches-Hausman IV @@@@@@@@@@@ */

tsset id year

g dwage=lnrwage-l2.lnrwage
g did=id-l2.id

g dfatal=fatal-l2.fatal
g dfatal3=fatal3-l2.fatal3

g dcfatal=cfatal-l2.cfatal
g dcfatal3=cfatal3-l2.cfatal3

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


/* @@@ use 2 & 3 yr lag as instrument for 2 yr difference @@@ */
/* i.e. use 93 & 92 rates to IV for 95-93 rate */

g l_fatal=lag2fatal_
g l2_fatal=l2.lagfatal_


ivreg dwage (dfatal = l_fatal l2_fatal) dage dage2 dcendiv2-dcendiv9 dunion ///
dmarry docc1 docc2 docc3 docc4 docc5 docc6 docc7 docc8 docc9 dsic2-dsic66 ///
dstate2-dstate50 yr_2-yr_5 if pct_chng>-75 & pct_chng<300, noconstant robust cluster(indocc) first

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



* @@@ use 2 & 3 yr lag differences as instrument for 2 yr difference @@@ */
/* i.e. use (93 - 92) rates to IV for (95 - 93) rate */

g ld_fatal=l_fatal - l2_fatal


ivreg dwage (dfatal=ld_fatal) dage dage2 dcendiv2-dcendiv9 dunion dmarry ///
docc1 docc2 docc3 docc4 docc5 docc6 docc7 docc8 docc9 dsic2-dsic66 ///
dstate2-dstate50 yr_2-yr_5 if pct_chng>-75 & pct_chng<300, noconstant robust cluster(indocc) first

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


/* @@@ use 2 & 4 yr lag as instrument for 2 yr difference @@@ */
/* i.e. use 95 & 93 rates to IV for 97-95 rate */


replace l_fatal=lag2fatal_
replace l2_fatal=l2.lag2fatal_

ivreg dwage (dfatal = l_fatal l2_fatal) dage dage2 dcendiv2-dcendiv9 /// 
dunion dmarry docc1 docc2 docc3 docc4 docc5 docc6 docc7 docc8 docc9 /// 
dsic2-dsic66 dstate2-dstate50 yr_2-yr_5 if pct_chng>-75 & pct_chng<300, noconstant robust cluster(indocc) first

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

/* @@@ use 2 & 4 yr lag difference as instrument for 2 yr difference @@@ */
/* i.e. use 95-93 rates to IV for 97-95 rate */


replace ld_fatal=l_fatal - l2_fatal

ivreg dwage (dfatal=ld_fatal) dage dage2 dcendiv2-dcendiv9 dunion dmarry /// 
docc1 docc2 docc3 docc4 docc5 docc6 docc7 docc8 docc9 dsic2-dsic66 /// 
dstate2-dstate50 yr_2-yr_5 if pct_chng>-75 & pct_chng<300, noconstant robust cluster(indocc) first

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



log close

