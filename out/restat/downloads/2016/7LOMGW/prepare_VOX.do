
********************************************************************************************************
*THIS DO-FILE PREPARES THE VOX SURVEY DATA:                                                  			   
* PATRICIA FUNK: 							                       	
* "HOW ACCURATE ARE SURVEYED PREFERENCES FOR PUBLIC POLICIES? EVIDENCE FROM
* A UNIQUE INSTITUTIONAL SETUP"                                                                                         
********************************************************************************************************

global data ="[your path]"


clear all
set more off
set matsize 2000

use "$data\VOX", clear 

rename sexe gender
rename confess religion
rename annee year
rename regiling language
rename ouix yes_official
rename partx turnout_official

gen turnout=a01
recode turnout 9=.
recode turnout 8=.

gen yes=.
replace yes=1 if turnout==1 & a02x==1
replace yes=0 if turnout==1 & a02x==3

gen votenr=projetx

***Calculate Reported Share_Yes per Vote

bysort votenr: egen nrvoters=count(votenr) if turnout==1
bysort votenr: egen nryesvoters=count(yes) if yes==1
bysort  votenr: egen nryesvoters2=max(nryesvoters)
bysort  votenr: egen nrvoters2=max(nrvoters)

drop nrvoters nryesvoters
rename  nryesvoters2 nryesvoters
rename nrvoters2 nrvoters

bysort votenr: egen nrvoters_yesno=count(votenr) if turnout==1 & yes!=.
bysort votenr: egen nrvoters_yesno2=max(nrvoters_yesno)
drop nrvoters_yesno
rename  nrvoters_yesno2 nrvoters_yesno

gen share_yes_reported=(nryesvoters/nrvoters_yesno)*100

drop nryesvoters nrvoters_yesno


*order votenr turnout yes nryesvoters nrvoters share_yes_reported, first

save "$data\VOX_prepared"
 
****Clean data - cross check with data from Swissvotes

use "$data\swissvotes", clear

rename jalager yes_parties

gen votenr=.
recode votenr .=321 if anr==344
recode votenr .=322 if anr==345
recode votenr .=323 if anr==346
recode votenr .=324 if anr==347
recode votenr .=342 if anr==349
recode votenr .=343 if anr==350
recode votenr .=351 if anr==351
recode votenr .=352 if anr==352
recode votenr .=363 if anr==355
recode votenr .=371 if anr==356
recode votenr .=382 if anr==357
recode votenr .=381 if anr==358
recode votenr .=391 if anr==359
recode votenr .=392 if anr==360
recode votenr .=393 if anr==361
recode votenr .=394 if anr==362	
recode votenr .=395 if anr==363
recode votenr .=396 if anr==364	
recode votenr .=401 if anr==365
recode votenr .=402 if anr==366
recode votenr .=403 if anr==367
recode votenr .=404 if anr==368
recode votenr .=411 if anr==369
recode votenr .=412 if anr==370
recode votenr .=421 if anr==371	
recode votenr .=422 if anr==372
recode votenr .=431 if anr==373
recode votenr .=432 if anr==374
recode votenr .=441 if anr==375
recode votenr .=442 if anr==377
recode votenr .=443 if anr==378
recode votenr .=444 if anr==379
recode votenr .=445 if anr==380
recode votenr .=446 if anr==381
recode votenr .=461 if anr==382
recode votenr .=462 if anr==383
recode votenr .=463 if anr==384
recode votenr .=464 if anr==385
recode votenr .=465 if anr==386
recode votenr .=466 if anr==387
recode votenr .=471 if anr==388
recode votenr .=481 if anr==389
recode votenr .=482 if anr==390
recode votenr .=483 if anr==391
recode votenr .=491 if anr==392
recode votenr .=492 if anr==393
recode votenr .=501 if anr==394
recode votenr .=502 if anr==395
recode votenr .=503 if anr==396
recode votenr .=504 if anr==397
recode votenr .=505 if anr==398
recode votenr .=511 if anr==399
recode votenr .=513 if anr==401
recode votenr .=514 if anr==402
recode votenr .=515 if anr==403
recode votenr .=516 if anr==404
recode votenr .=521 if anr==405
recode votenr .=522 if anr==406
recode votenr .=523 if anr==407
recode votenr .=524 if anr==408
recode votenr .=525 if anr==409
recode votenr .=532 if anr==410		
recode votenr .=533 if anr==411
recode votenr .=531 if anr==412
recode votenr .=541 if anr==413
recode votenr .=542 if anr==414
recode votenr .=551 if anr==415
recode votenr .=552 if anr==416
recode votenr .=553 if anr==417
recode votenr .=561 if anr==418
recode votenr .=562 if anr==419
recode votenr .=563 if anr==420
recode votenr .=564 if anr==421
recode votenr .=571 if anr==422
recode votenr .=572 if anr==423
recode votenr .=573 if anr==424
recode votenr .=581 if anr==425
recode votenr .=582 if anr==426
recode votenr .=583 if anr==427
recode votenr .=584 if anr==428
recode votenr .=585 if anr==429
recode votenr .=591 if anr==430
recode votenr .=592 if anr==431
recode votenr .=602 if anr==433
recode votenr .=611 if anr==434
recode votenr .=612 if anr==435
recode votenr .=613 if anr==436
recode votenr .=622 if anr==437
recode votenr .=621 if anr==438
recode votenr .=632 if anr==439
recode votenr .=631 if anr==440
recode votenr .=633 if anr==441
recode votenr .=641 if anr==442	
recode votenr .=642 if anr==443
recode votenr .=643 if anr==444
recode votenr .=651 if anr==445
recode votenr .=652 if anr==446
recode votenr .=653 if anr==447
recode votenr .=654 if anr==448
recode votenr .=661 if anr==449
recode votenr .=664 if anr==450
recode votenr .=662 if anr==451
recode votenr .=663 if anr==452
recode votenr .=671 if anr==453
recode votenr .=681 if anr==454
recode votenr .=682 if anr==455
recode votenr .=683 if anr==456	
recode votenr .=684 if anr==457
recode votenr .=685 if anr==458
recode votenr .=691 if anr==459
recode votenr .=692 if anr==460
recode votenr .=693 if anr==461
recode votenr .=694 if anr==462
recode votenr .=695 if anr==463
recode votenr .=701 if anr==464
recode votenr .=711 if anr==465.1
recode votenr .=712 if anr==465.2
recode votenr .=713 if anr==466	
recode votenr .=714 if anr==467
recode votenr .=715 if anr==468
recode votenr .=721 if anr==469	
recode votenr .=722 if anr==470
recode votenr .=723 if anr==471
recode votenr .=724 if anr==472	
recode votenr .=725 if anr==473	
recode votenr .=731 if anr==474
recode votenr .=732 if anr==475
recode votenr .=733 if anr==476
recode votenr .=741 if anr==477
recode votenr .=742 if anr==478
recode votenr .=743 if anr==479
recode votenr .=751 if anr==480
recode votenr .=752 if anr==481
recode votenr .=753 if anr==482
recode votenr .=754 if anr==483	
recode votenr .=755 if anr==484
recode votenr .=761 if anr==485
recode votenr .=762 if anr==486	
recode votenr .=771 if anr==487
recode votenr .=772 if anr==488
recode votenr .=781 if anr==489.1	
recode votenr .=782 if anr==489.2
recode votenr .=783 if anr==490
recode votenr .=791 if anr==491
recode votenr .=801 if anr==493
recode votenr .=802 if anr==494	
recode votenr .=811 if anr==495
recode votenr .=812 if anr==496
recode votenr .=813 if anr==497
recode votenr .=815 if anr==498
recode votenr .=814 if anr==499
recode votenr .=821 if anr==500
recode votenr .=822 if anr==501
recode votenr .=823 if anr==502
recode votenr .=824 if anr==503
recode votenr .=831 if anr==504
recode votenr .=832 if anr==505	
recode votenr .=833 if anr==506
recode votenr .=841 if anr==507
recode votenr .=842 if anr==508
recode votenr .=843 if anr==509
recode votenr .=851 if anr==510
recode votenr .=852 if anr==511
recode votenr .=853 if anr==512	
recode votenr .=854 if anr==513
recode votenr .=861 if anr==514
recode votenr .=862 if anr==515
recode votenr .=863 if anr==516
recode votenr .=871 if anr==517
recode votenr .=872 if anr==518
recode votenr .=881 if anr==519
recode votenr .=891 if anr==520
recode votenr .=892 if anr==521
recode votenr .=901 if anr==522
recode votenr .=911 if anr==523
recode votenr .=912 if anr==524
recode votenr .=913 if anr==525
recode votenr .=921 if anr==526		
recode votenr .=922 if anr==527
recode votenr .=931 if anr==528
recode votenr .=941 if anr==529

gen turnoutSW=bet
gen yesSW=volkjaproz

drop if votenr==.

sort votenr

save "$data\swissvotes_prepared"

use "$data\VOX_prepared"
 
 sort votenr

 merge votenr using "$data\swissvotes_prepared"

 save "$data\VOX_prepared", replace 
 

bysort votenr: sum  share_yes_reported
 
*votes 462, 463 and 464 have identical share yes --> flag them! 
 
gen flag=0
replace flag=1 if votenr==462  |  votenr==463 |  votenr==464

**double check official voting results (share yes votes, turnout) from VOX data with swissvotes data


bysort votenr: sum  turnoutSW turnout_official

**Correct data bugs 
replace turnout_official=43.75 if votenr==552
replace turnout_official=36.8 if votenr==862

bysort votenr: sum  yesSW yes_official  
  
**Correct yes bugs  (votes 941, 813, 821) 

replace yes_official=yesSW if votenr==941
replace yes_official=yesSW if votenr==813
replace yes_official=yesSW if votenr==821

**Generate measure for survey_bias
gen survey_bias=share_yes_reported-yes_official

gen survey_biasabs=survey_bias
replace survey_biasabs=-survey_bias if survey_bias<0

drop if flag==1
drop flag _m

***Socio-demographics****

gen female=0
replace female=1 if gender==2

gen prot=0
replace prot=1 if  religion==1

gen cath=0
replace cath=1 if  religion==2

gen age2039=0
replace age2039=1 if age>19 & age<40

gen age4059=0
replace age4059=1 if age>39 & age<60

gen age60plus=0
replace  age60plus=1 if age>59

gen dummy65plus=0 
replace dummy65plus=1 if age>64 

gen German=0
replace German=1 if language==1 

gen French=0
replace French=1  if language==2 

gen Italian=0
replace Italian=1 if language==3 

gen highedu=0
replace highedu=1 if (educ==3   |educ==4 |educ==5|educ==6)

****************Party Recommendations

***Recommendation FDP
gen rec_FDP=.
replace rec_FDP=1 if motPRDx==1
replace rec_FDP=0 if motPRDx==2

***Recommendation SP
gen rec_SP=.
replace rec_SP=1 if motPSx==1
replace rec_SP=0 if motPSx==2

***Recommendation SVP
gen rec_SVP=.
replace rec_SVP=1 if motUDCx==1
replace rec_SVP=0 if motUDCx==2

***Recommendation CVP
gen rec_CVP=.
replace rec_CVP=1 if motPDCx==1
replace rec_CVP=0 if motPDCx==2


**********Parti-Identification (measured by the variable p02)
 gen CVPVoter=0
 replace CVPVoter=1 if p02==2
 replace CVPVoter=1 if p02==0 & year<1992
 
 gen SVPVoter=0
 replace SVPVoter=1 if p02==13
  
 gen SPVoter=0
 replace SPVoter=1 if p02==12

  gen FDPVoter=0
 replace FDPVoter=1 if p02==4

 ***Dummy=1 if individual identifies with a party
 gen Party_Identification=1
 replace Party_Identification=0 if (p02==30|  p02==31|  p02==32|  p02==33|  p02==98|  p02==99)

**Nr of Voters who identify with a party
 bysort votenr: egen NrParty_Identification=count(Party_Identification) if (turnout==1 & Party_Identification==1)
 bysort votenr:egen NrParty_Identification2= max(NrParty_Identification)
 drop NrParty_Identification
 rename NrParty_Identification2 NrParty_Identification
 
 **Per vote: Nr. SP voters (among those who identify with a party)
 bysort votenr: egen NrSPVoter=count(SPVoter) if (turnout==1 & SPVoter==1)
 bysort votenr:egen NrSPVoter2= max(NrSPVoter)
 drop NrSPVoter
 rename NrSPVoter2 NrSPVoter
 
 bysort votenr: egen NrSVPVoter=count(SVPVoter) if (turnout==1 & SVPVoter==1)
 bysort votenr:egen NrSVPVoter2= max(NrSVPVoter)
 drop NrSVPVoter
 rename NrSVPVoter2 NrSVPVoter
 
 bysort votenr: egen NrFDPVoter=count(FDPVoter) if (turnout==1 & FDPVoter==1)
 bysort votenr:egen NrFDPVoter2= max(NrFDPVoter)
 drop NrFDPVoter
 rename NrFDPVoter2 NrFDPVoter
 
bysort votenr: egen NrCVPVoter=count(CVPVoter) if (turnout==1 & CVPVoter==1)
bysort votenr:egen NrCVPVoter2= max(NrCVPVoter)
drop NrCVPVoter
rename NrCVPVoter2 NrCVPVoter
 

 gen ShareSPSurvey=(NrSPVoter/NrParty_Identification)*100
 gen ShareSVPSurvey=(NrSVPVoter/NrParty_Identification)*100
 gen ShareFDPSurvey=(NrFDPVoter/NrParty_Identification)*100
 gen ShareCVPSurvey=(NrCVPVoter/NrParty_Identification)*100
 
drop NrParty_Identification - NrCVPVoter

************Construction Share Empty Votes (of voters)

*bysort votenr: egen NRSurveyed= count(id)

levelsof votenr, local(levels) 
foreach l of local levels {
  count if (yes==. & turnout==1 & votenr==`l')
  gen miss`l'=`r(N)' if votenr==`l'
}

levelsof votenr, local(levels) 
foreach l of local levels {
egen maxmiss`l'=max(miss`l') if votenr==`l'
}

egen nrmiss=rsum(maxmiss321-maxmiss941) 
drop maxmiss* 
drop miss* 

gen shareleersurvey=(nrmiss/nrvoters)*100
gen revrate=100-shareleersurvey


****create non-cooperation rates 
gen coop=.
replace coop=(1-0.6) if datum=="07.06.1998"
replace coop=(1-0.57) if datum=="27.09.1998"
replace coop=(1-0.64) if datum=="29.11.1998"
replace coop=(1-0.65) if datum=="27.02.1999" 
replace coop=(1-0.7) if datum=="18.04.1999" 
replace coop=(1-0.61) if datum=="13.06.1999" 
replace coop=(1-0.57) if datum=="12.03.2000" 
replace coop=(1-0.55) if datum=="21.05.2000" 
replace coop=(1-0.59) if datum=="24.09.2000" 
replace coop=(1-0.59) if datum=="24.09.2000" 
replace coop=(1-0.59) if datum=="24.09.2000" 
replace coop=(1-0.61) if datum=="26.11.2000" 
replace coop=(1-0.54) if datum=="04.03.2001" 
replace coop=(1-0.58) if datum=="10.06.2001" 
replace coop=(1-0.63) if datum=="02.12.2001" 
replace coop=(1-0.52) if datum=="03.03.2002" 
replace coop=(1-0.66) if datum=="02.06.2002" 
replace coop=(1-0.68) if datum=="22.09.2002" 
replace coop=(1-0.71) if datum=="24.11.2002" 
replace coop=(1-0.72) if datum=="09.03.2003" 
**VOX 82**
replace coop=(1-0.69) if datum=="08.02.2004" 
replace coop=(1-0.65) if datum=="16.05.2004" 
replace coop=(1-0.72) if datum=="26.09.2004" 
**+VOX 85
replace coop=(1-0.70) if datum=="28.11.2004" 
replace coop=(1-0.71) if datum=="05.06.2005"
replace coop=(1-0.67) if datum=="25.09.2005" 
replace coop=(1-0.705) if datum=="27.11.2005" 
replace coop=(1-0.732) if datum=="21.05.2006" 
replace coop=(1-0.748) if datum=="24.09.2006" 
replace coop=(1-0.718) if datum=="26.11.2006" 
replace coop=(1-0.673) if datum=="11.03.2007" 
replace coop=(1-0.656) if datum=="17.06.2007" 

gen cooprate=coop*100 



***generate date_identifier
gen datumyear=substr(datum, 7, 4)
gen datummonth=substr(datum, 4, 2)
gen datumday=substr(datum, 1, 2)
 
gen datumnew=datumyear +datummonth +datumday
egen datum_id = group(datumnew)

** fill in by hand missing data
recode  datum_id .=2 if votenr==341
recode  datum_id .=4 if votenr==361
recode  datum_id .=4 if votenr==362
recode  datum_id .=18 if votenr==512
recode  datum_id .=27 if votenr==601
recode  datum_id .=38 if votenr==711
recode  datum_id .=38 if votenr==712
recode  datum_id .=45 if votenr==781
recode  datum_id .=45 if votenr==782
recode  datum_id .=46 if votenr==792
 
 


**gen measure turnoutgap

bysort votenr: egen nrsurveyed=count(votenr)
gen turnout_rep=(nrvoters/nrsurveyed)*100
gen turnoutgap=turnout_rep-turnout_official
 
**dummy for vote accepted/rejected
gen vote_passed=0
replace  vote_passed=1 if yes_official>=50
 



************Policy Areas

gen Pro_Integration=0
replace Pro_Integration=1 if votenr==441 | votenr==  471 | votenr==531   | votenr==701 | votenr==731  | votenr== 761   | votenr==871  | votenr==881   | votenr==921  

gen Pro_Immigration=0
replace Pro_Immigration=1 if votenr==533 | votenr==  851 | votenr==852   

gen Contra_Immigration=0
replace Contra_Immigration=1 if votenr== 363 |votenr== 553 |votenr== 601 |votenr==  681 |votenr== 682 |votenr==  714 |votenr== 791 |votenr==913

gen Contra_Military=0
replace Contra_Military=1 if votenr==382  |votenr==422 |votenr==445  |votenr==491   |votenr==492   |votenr==612  |votenr==723  |votenr==753 |votenr==754 |votenr==811 


gen Pro_Environmenta=0
replace Pro_Environment=1 if votenr==341  |	votenr==343	 |votenr==391	 |votenr==392 |	votenr==393 |	votenr==394 |	votenr==403 |	votenr==412 |	votenr==442	 |votenr==443	 |votenr==461 ///
	| votenr==481 |	votenr==521 |	votenr==522|	votenr==523|	votenr==524	|votenr==641|	votenr==651|	votenr==695|	votenr==711|	votenr==712|	votenr==713|	votenr==815


gen Contra_Nuclear=0
replace Contra_Nuclear=1 if votenr==401 | votenr==402 | votenr==822 | votenr==	823

gen Budget_Balance=0	
replace  Budget_Balance=1	if votenr==564	| votenr==632			

gen Direct_Democracy=0	
replace  Direct_Democracy=1	if votenr==323 | votenr==324 | votenr==692 | votenr==715 | votenr==801	

gen Pro_Health_Liberal=0
replace Pro_Health_Liberal=1 if votenr==342 | votenr==653	| votenr==683	| votenr==685	| votenr==771		
			
gen Contra_Health_Liberal=0
replace Contra_Health_Liberal=1 if votenr==515 | votenr==516		| votenr==772		
	
gen Pro_Redistribution=0	
replace Pro_Redistribution=1 if votenr==431	 | votenr==431	| votenr==551	| votenr==552	| votenr==813	| votenr==814	| votenr==853	| votenr==931	

gen Pro_Retirement_Age=0	
replace Pro_Retirement_Age=1 if votenr== 571	 | votenr==841		

gen Contra_Retirement_Age=0	
replace Contra_Retirement_Age=1 if votenr== 352	| votenr==572	| votenr==643	| votenr==721	| votenr==722	
		
gen Pro_Liberal=0			
replace Pro_Liberal=1	if votenr==446	| votenr==872						
								
								
gen Pro_Gender=1 if (votenr==685  | votenr==854   | votenr==693)
recode Pro_Gender .=0

gen policyarea=1 if Pro_Integration==1 | Pro_Immigration==1 | Contra_Immigration==1 | Contra_Military==1 |  Pro_Environment==1 | Contra_Nuclear==1 | Budget_Balance==1 | Direct_Democracy==1 | Pro_Health_Liberal==1 ///
| Contra_Health_Liberal==1  | Pro_Redistribution==1  | Pro_Retirement_Age==1  | Contra_Retirement_Age==1   | Pro_Liberal==1   | Pro_Gender==1  


***Important Votes

gen importancev=a88x
recode importancev 98=. 
recode importancev 99=. 
bysort votenr: egen importancev2=mean(importancev)


gen important=0
replace important=1 if importancev2> 6.751162 
replace important=. if importancev2==.

*************************
***Look at deviations from party recommendations: big 4 parties 
**************** 


gen DEVSP=0 if (turnout==1 & SPVoter==1 & rec_SP==0 & yes==0) 
replace DEVSP=1 if (turnout==1 & rec_SP==0 & yes==1 & SPVoter==1)

ttest DEVSP, by(vote_passed)


gen DEVSVP=0 if (turnout==1 & SVPVoter==1 & rec_SVP==0 & yes==0)
replace DEVSVP=1 if (turnout==1 & rec_SVP==0 & yes==1  & SVPVoter==1)

ttest DEVSP, by(vote_passed)

 

gen DEVFDP=0 if (turnout==1 & rec_FDP==0 & yes==0 & FDPVoter==1)
replace DEVFDP=1 if (turnout==1 & rec_FDP==0 & yes==1  & FDPVoter==1)
ttest DEVFDP, by(vote_passed)



gen DEVCVP=0 if (turnout==1 & rec_CVP==0 & yes==0 & CVPVoter==1)
replace DEVCVP=1 if (turnout==1 & rec_CVP==0 & yes==1  & CVPVoter==1)
ttest DEVCVP, by(vote_passed)


egen Deviationsbig4=rsum(DEVSP DEVFDP DEVSVP DEVCVP)
recode Deviationsbig4 0=. if (DEVSP==. & DEVFDP==. & DEVSVP==. & DEVCVP==.)



drop a01 a02x a88x-projetx anr-volkjaproz turnoutSW yesSW nrmiss datumyear datummonth datumday importancev importancev2 turnout_rep

save "$data\VOX_prepared", replace



******************************************
****Do the rake procedure*******************
*****************************************


use "$data\PUS", clear 
  

rename zjhr year
rename altj agegroup
rename gesl gender
rename konf religion
rename spr93 language


***step 1: drop respondents younger than 20
drop if agegroup<5
drop if year==1970 
 
 ***variable names: year protPUSi age65PUSi higheduPUSi TotalPUSi
*Citizens older than 20

count if year==1980

gen TotalPUS=r(N) if year==1980

count if year==1990 

replace TotalPUS=r(N) if year==1990

count if year==2000 

replace TotalPUS=r(N) if year==2000


*Number Protestants:

count if religion==1 & year==1980 

gen protPUS=r(N) if year==1980

count if religion==1 & year==1990 

replace protPUS=r(N) if year==1990

count if religion==1 & year==2000 

replace protPUS=r(N) if year==2000


*Age 65plus


count if agegroup>13  & year==1980 

gen age65PUS=r(N) if year==1980

count if agegroup>13  & year==1990 

replace age65PUS=r(N) if year==1990

count if agegroup>13 & year==2000

replace age65PUS=r(N) if year==2000


keep year TotalPUS- age65PUS

duplicates drop year, force

gen higheduPUS=.
replace higheduPUS=20350 if year==1980
replace higheduPUS=40373 if year==1990
replace higheduPUS=60396 if year==2000

set obs 4

replace year = 2007 in 4

tsset year

tsfill, full

ipolate TotalPUS year, gen(TotalPUSi) epolate
ipolate protPUS year, gen(protPUSi) epolate
ipolate age65PUS year, gen(age65PUSi) epolate
ipolate higheduPUS year, gen(higheduPUSi) epolate

keep year TotalPUSi- higheduPUSi

drop if year<1987

sort year

save "$data\IPOLATE_PUS"



use "$data\VOX_prepared"

sort year
merge year using "$data\IPOLATE_PUS"

drop _m

gen NUMPUS=TotalPUS if (year==1990  |  year==2000)

gen old_wt=1


gen prot_tot=protPUSi if prot==1
replace prot_tot= (TotalPUSi- protPUSi) if prot==0


gen age65_tot=age65PUSi if dummy65plus==1 
replace age65_tot=(TotalPUSi-  age65PUSi) if dummy65plus==0 

 
gen highedu_tot=  higheduPUSi if highedu==1
replace highedu_tot= (TotalPUSi-higheduPUSi) if highedu==0


gen electionshare_SP=.
replace electionshare_SP=18.416928 if year<1991
* tab  votenr if annee<1991 (votes 321 - 404)
replace electionshare_SP=18.490692 if (year> 1990 & year<1995)
* tab votenr if annee> 1990 & annee<1995 (votes 411-553)
replace electionshare_SP=21.792927 if (year> 1994 & year<1999)
* tab votenr if annee> 1994 & annee<1999 (votes 561-654)
replace electionshare_SP=22.47346 if (year> 1998 & year<2003)
* tab votenr if (annee> 1998 & annee<2003) (votes 661-792)
replace electionshare_SP=23.322699 if (year> 2002 & year<2007)
* tab votenr if annee> 2002 & annee<2007 (801-922)
replace electionshare_SP=19.5 if (year==2007)
* tab votenr if annee==2007 (931, 941)

gen SP_tot1=(electionshare_SP*TotalPUSi)/100 if  SPVoter==1
replace SP_tot1=TotalPUSi*((100-electionshare_SP)/100)  if SPVoter==0 &  Party_Identification==1 

gen SPVoter1=SPVoter
replace SPVoter1=. if Party_Identification==0


*gen SP_tot2=electionshare_SP*TotalPUSi/100 if  SPVoter==1
*replace SP_tot2=TotalPUSi*((100-electionshare_SP)/100) if SPVoter==0

 
**************************
*********DO THE RAKING
***************************
*ssc install survwgt
 
keep year id turnout yes prot dummy65plus highedu NUMPUS- SP_tot1 SPVoter SPVoter1  datumnew votenr
 

sort votenr id 
egen groupvotenr = group(votenr)

save "$data\rake"

************Do Raking with regard to age, religion and education

foreach i of num 1/184 {
use   "$data\rake" if groupvotenr==`i', clear
survwgt rake old_wt, by(prot dummy65plus highedu) totvars(prot_tot age65_tot highedu_tot) gen(newwt) 
svyset _n [pweight=newwt]  
svy: mean yes if (turnout==1)
matrix rakeyes = e(b)
matrix list rakeyes
svmat rakeyes
egen rakeyes=max(rakeyes1)
save "$data\groupvotenr`i'"
  }



use   "$data\groupvotenr1"
foreach i of num 2/184 {
append using "$data\groupvotenr`i'"
save "$data\rake", replace
  }


foreach i of num 1/184  {
erase "$data\groupvotenr`i'.dta"
}


************Do Raking with regard to left-wing party affiliation


foreach i of num 1/184 {
use   "$data\rake" if groupvotenr==`i', clear
survwgt rake old_wt, by(SPVoter1) totvars(SP_tot1) gen(newwtSP) 
svyset _n [pweight=newwtSP]  
svy: mean yes if (turnout==1)
matrix rakeyesSP = e(b)
matrix list rakeyesSP
svmat rakeyesSP
egen rakeyesSP_v1=max(rakeyesSP1)
save "$data\groupvotenr`i'"
  }



use   "$data\groupvotenr1"
foreach i of num 2/184 {
append using "$data\groupvotenr`i'"
save "$data\rake", replace
  }
 
keep votenr rakeyes rakeyesSP_v1
 
duplicates drop votenr, force

sort votenr

foreach i of num 1/184  {
erase "$data\groupvotenr`i'.dta"
}

 
 save "$data\rake", replace
 
 
 use "$data\VOX_prepared"
 
 sort votenr
 
 merge votenr using  "$data\rake"
 
 drop _m
 
 
gen rakeyesp=rakeyes*100
 
gen survey_bias_weighted=rakeyesp-yes_official

gen rakeSP1= rakeyesSP_v1*100
 
gen survey_bias_weighted_left=rakeSP1-yes_official

gen survey_bias_weighteda=survey_bias_weighted if survey_bias_weighted>0
replace survey_bias_weighteda=-survey_bias_weighted if survey_bias_weighted<0


drop rakeyes rakeyesSP_v1 rakeyesp rakeSP1 Party_Identification datumnew

save "$data\VOX_prepared", replace





