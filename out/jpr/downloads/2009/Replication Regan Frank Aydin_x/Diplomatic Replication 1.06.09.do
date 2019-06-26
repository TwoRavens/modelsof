/*******************************************************************************************/
/*                                                                                         */
/*  Replication of Regan et al.'s "Diplomatic Intervention and Civil War: A New Dataset"   */
/*  Journal of Peace Research vol. 46, no. 1 (January 2009): 135-146.                      */
/*                                                                                         */
/*******************************************************************************************/

	version 9.2
	set more off

/*** paste correct pathways below ***/

	use "C:\Diplomatic\Diplomatic Interventions.dta", clear

*** Introduction (p. 135)***

	***438 diplomatic interventions***
	tab diplomatic

	***year range: 1945-1999***
	codebook year if diplomatic==1

	***68 conflicts***
	codebook conflict

*** Patterns in the Data (p. 139) ***

*** Types of Diplomatic Intervention ***

	***352 Mediations***
	tab mediation

	***23 Forum***
	tab forum

	***5 Recall***
	tab recall

	***44 Offers***
	tab offer	

	*** 12 Requests ***
	tab request

	*** 86 units were counted in Excel ***


*** Figure 1: Interventions by region ***
*** Created using diplomatic data merged with Regan (2002) ***

	use "C:\Diplomatic\replication.10.26.01.dta", clear

	append using "C:\Diplomatic\Diplomatic Interventions.dta"

	sort conflict time

	gen str2 strttempmnth= substr(startdate, 1,index (startdate, "/")-1)

	gen str2 strttempyr = substr(startdate, -2, .)

	destring strttempmnth, replace
	destring strttempyr, replace

	gen yrmo = (strttempyr*100) + strttempmnth
	replace _yearmo=yrmo if _yearmo==.

	replace opposing=0 if conflict==conflict[_n-1]
	replace neutral=0 if conflict==conflict[_n-1]
	replace opp=0 if conflict==conflict[_n-1] & diplomatic==1
	replace govt=0 if conflict==conflict[_n-1] & diplomatic==1
	replace govt=0 if conflict==conflict[_n-1]& diplomatic==1
	replace target=0 if conflict==conflict[_n-1]& diplomatic==1
	replace died=died[_n-1] if conflict==conflict[_n-1] & _yearmo==_yearmo[_n-1] & diplomatic==1
	replace group1=group1[_n-1] if conflict==conflict[_n-1] & diplomatic==1 
	replace group2=group2[_n-1] if conflict==conflict[_n-1] & diplomatic==1 
	replace group3=group3[_n-1] if conflict==conflict[_n-1] & diplomatic==1 
	replace group4=group4[_n-1] if conflict==conflict[_n-1] & diplomatic==1 
	replace refugees=refugees[_n-1] if conflict==conflict[_n-1] & diplomatic==1 
	replace coldwar=coldwar[_n-1] if conflict==conflict[_n-1] & diplomatic==1
	replace typeIden=typeIden[_n-1] if conflict==conflict[_n-1] & diplomatic==1
	replace fatal=fatal[_n-1] if conflict==conflict[_n-1] & diplomatic==1
	replace sizeopp=sizeopp[_n-1] if conflict==conflict[_n-1] & diplomatic==1
	replace military=0 if diplomatic==1
	replace economic=0 if diplomatic==1
	replace ethnic_=ethnic_[_n-1] if conflict==conflict[_n-1] & diplomatic==1
	replace ethn_nam=ethn_nam[_n-1] if conflict==conflict[_n-1] & diplomatic==1
	replace troops=0 if diplomatic==1
	replace navy=0 if diplomatic==1
	replace equip=0 if diplomatic==1
	replace intel=0 if diplomatic==1
	replace airforce=0 if diplomatic==1
	replace credit=0 if diplomatic==1
	replace relief=0 if diplomatic==1
	replace sanction=0 if diplomatic==1
	replace force=0 if diplomatic==1
	replace avefrac=avefrac[_n-1] if conflict==conflict[_n-1] & diplomatic==1
	replace ideology=ideology[_n-1] if conflict==conflict[_n-1] & diplomatic==1
	replace religion=religion[_n-1] if conflict==conflict[_n-1] & diplomatic==1
	replace ethnic=ethnic[_n-1] if conflict==conflict[_n-1] & diplomatic==1
	replace intense=intense[_n-1] if conflict==conflict[_n-1] & diplomatic==1
	replace avemnth=avemnth[_n-1] if conflict==conflict[_n-1] & diplomatic==1
	replace milint=0 if diplomatic==1
	replace econint=0 if diplomatic==1
	replace govmil=0 if diplomatic==1
	replace govecon=0 if diplomatic==1
	replace oppmil=0 if diplomatic==1
	replace neutmil=0 if diplomatic==1
	replace neutecon=0 if diplomatic==1
	replace grant=0 if diplomatic==1
	replace loan=0 if diplomatic==1
	replace aid=0 if diplomatic==1


*** Figure 1: Interventions by region***

	* region 1 has 8 conflicts
	codebook conflict if region==1
	* region 2 has 11  conflicts
	codebook conflict if region==2
	* region 3 has 20  conflicts
	codebook conflict if region==3
	* region 4 has 13  conflicts
	codebook conflict if region==4
	* region 5 has 16  conflicts
	codebook conflict if region==5

	sort region
	by region: tab conflict if diplomatic==1

	* divide each region total frequency by the region conflict total above
	* e.g. the Americas has 66 diplomatic interventions in 8 conflicts
	* 66/8=8.25

	by region: tab conflict if military==1

	by region: tab conflict if economic==1

	save "C:\Diplomatic\DME.dta", replace

*** Page 140 statistics mentioned in the text ***

	use "C:\Diplomatic\Diplomatic Interventions.dta", clear
	
	***UN Interventions: look for unitcode= 0.18***

	tab unitcode  
	codebook unitcode /*76*/
	tab unitcode1 /*9*/
	tab unitcode2 /*1*/ 
	***total= 86***

	sort unitcode
	tab ccode region if unitcode>.17 & unitcode<.181
	tab ccode region if unitcode1>.17 & unitcode1<.181
	tab ccode region if unitcode2>.17 & unitcode2<.181

	tab conflict if unitcode>.17 & unitcode<.181
	tab conflict if unitcode>.17 & unitcode<.181
	tab conflict if unitcode>.17 & unitcode<.181

	/*22 ccodes:
	1. 90; 2. 92; 3. 230; 4. 345; 5. 346; 6. 352; 7. 359; 8. 372; 9. 450; 10. 484; 11. 516; 12. 520; 13. 540; 14. 640; 15. 700; 16. 702; 17. 775; 18. 811; 19. 817; 20. 850; 21. 51; 22. 660 */

	*** USA Interventions = 56 ***
	tab conflict region if unitcode==2    /*51*/
	count if unitcode1==2   /*4*/
	count if unitcode4==2   /*1*/

	***Catholic Church = 30 ***
	count if unitcode>.39 & unitcode<.41   /*29*/
	count if unitcode1>.39 & unitcode1<.41
	count if unitcode2>.39 & unitcode2<.41 /*1*/
	count if unitcode3>.39 & unitcode3<.41
	count if unitcode4>.39 & unitcode4<.41
	count if unitcode5>.39 & unitcode5<.41

	***Mediators from same region***
	gen mregion=.
	replace mregion=1 if unitcode>1 & unitcode<200
	replace mregion=2 if unitcode<400 & unitcode>199
	replace mregion=3 if unitcode>399 & unitcode<600
	replace mregion=4 if unitcode>599 & unitcode<700
	replace mregion=5 if unitcode>700
	tab region mregion


	***UN unilateral 75% of the time***
	sort unitcode
	tab unilat if unitcode>0.18 & unitcode<.183
	tab unilat if unitcode1>0.18 & unitcode1<.183
	tab unilat if unitcode2>0.18 & unitcode2<.183
	/* 66 of 86*/


*** Figure 2: Frequent Interveners ***

	***UK = 21 ***
	count if unitcode==200 /* 18 */
	count if unitcode1==200 /* 2  */
	count if unitcode2==200
	count if unitcode3==200 /* 1 */
	count if unitcode4==200
	count if unitcode5==200

	***EC = 15***
	count if unitcode>.65 & unitcode<.71 /* 7 */
	count if unitcode1>.65 & unitcode1<.71 /* 8 */
	count if unitcode2>.65 & unitcode2<.71
	count if unitcode3>.65 & unitcode3<.71
	count if unitcode4>.65 & unitcode4<.71

	***Tanzania = 15***
	count if unitcode==510  /* 12 */
	count if unitcode1==510 /* 3 */
	count if unitcode2==510
	count if unitcode3==510
	count if unitcode4==510

	***Kenya = 14***
	count if unitcode==501 	/* 8 */
	count if unitcode1==501 /* 3 */
	count if unitcode2==501 /* 3 */
	count if unitcode3==501
	count if unitcode4==501
	count if unitcode5==501

	***OAU = 17***
	count if unitcode>.145 & unitcode<.155  	/* 15 */
	count if unitcode1>.145 & unitcode1<.155 	/* 1 */
	count if unitcode2>.145 & unitcode2<.155 	/* 1 */
	count if unitcode3>.145 & unitcode3<.155
	count if unitcode4>.145 & unitcode4<.155
	count if unitcode5>.145 & unitcode5<.155

	***IGADD = 14***
	count if unitcode>.1 & unitcode<.12 	/* 14 */
	count if unitcode1>.1 & unitcode1<.12
	count if unitcode2>.1 & unitcode2<.12
	count if unitcode3>.1 & unitcode3<.12
	count if unitcode4>.1 & unitcode4<.12

	***Russia = 13***
	count if unitcode==365	/* 12 */
	count if unitcode1==365 /* 1 */
	count if unitcode2==365 /* 1 */
	count if unitcode3==365
	count if unitcode4==365

	***ECOWAS = 12***
	count if unitcode>.79 & unitcode<.81 	/* 11 */
	count if unitcode1>.79 & unitcode1<.81	/* 1 */
	count if unitcode2>.79 & unitcode2<.81
	count if unitcode3>.79 & unitcode3<.81
	count if unitcode4>.79 & unitcode4<.81

	***Italy = 11***
	count if unitcode==325	/* 10*/
	count if unitcode1==325
	count if unitcode2==325
	count if unitcode3==325	/* 1 */
	count if unitcode4==325

	***India = 11***
	count if unitcode==750	/* 11 */
	count if unitcode1==750
	count if unitcode2==750
	count if unitcode3==750
	count if unitcode4==750

	***South Africa = 11***
	count if unitcode==560	/* 8 */
	count if unitcode1==560 /* 3 */
	count if unitcode2==560
	count if unitcode3==560
	count if unitcode4==560


*** Page 140.  In-text statistics ***

	***Mediation Success***
	count if mediation==1 & success==1
	/* 133 of 352 = 37.78% */

	***Ceasefire***
	count if outcome==1 & mediation==1
	/* 201 of 352 = 57.10% */

	***Failure***
	count if outcome==0 & mediation==1
	count if outcome==4 & mediation==1
	/* 15 of 352 = 4.26% */


*** Figure 3: Unilateral and Multilateral Interventions ***

	***UN  67 of 89= 75% unilateral***
	count if unitcode>.17 & unitcode<.181 & unitcode1==. 

	***US 42 of 56 = 75%***
	count if unitcode==2 & unitcode1==.   /*42*/

	***Catholic Church 24 of 30 = 80%***
	count if unitcode>.39 & unitcode<.41 & unitcode1==.

	***UK 12 of 21= 57%***
	count if unitcode==200 & unitcode1==.
	
	***Tanzania 10 of 15= 67%***
	count if unitcode==510 & unitcode1==.

	***Kenya 6 of 14= 43%***
	count if unitcode==501 & unitcode1==.

	***Russia 9 of 13= 70%***
	count if unitcode==365 & unitcode1==.

	***Italy 10 of 11= 91%***
	count if unitcode==325 & unitcode1==.

	***India 11 of 11=100%***
	count if unitcode==750 & unitcode1==.

	***South Africa 8 of 11= 73%***
	count if unitcode==560 & unitcode1==.


*** Figure 4: Mediation Outcomes ***

	***1=201 = 58%; 2=44 = 13%; 3=89 = 25%; 4=15 = 4%***
	***total=349; three outcomes are missing ***
	tab outcome if mediation==1 & outcome>0


*** Figure 5: Mediator Rank ***

	tab negrank success if mediation==1


*** Figure 6: Frequent Mediatiors and p. 142 in-text ***

	gen idcode=.

	***Moi 21 in 5***
	replace idcode=1 if identity=="IGAD (Chair Kenyan Pres. Moi) Committee for Sudan"
	replace idcode=1 if identity=="Moi, Kenyan President"
	replace idcode=1 if identity=="President Moi"
	replace idcode=1 if identity=="President Moi and President Mugabe"
	replace idcode=1 if identity=="President Moi, President Miseveni, President Zenawi, President Aferivoki"
	replace idcode=1 if identity=="President Moi, President Mugabe, Sant Edidio"
	replace idcode=1 if identity=="President Moi, President Mugabe, Sant Edidio Comm."
	replace idcode=1 if identity=="President Moi, President Mugabe, and Sant Edidio"
	replace idcode=1 if identity=="Comm of Sant Edidio, President Moi, and President Mugabe"
	replace idcode=1 if identity=="President Moi, Mugabe, Sant Edidio Comm."
	count if idcode==1
	tab conflict if idcode==1
	
	***Carter 12 in 5***
	replace idcode=2 if identity=="Carter"
	replace idcode=2 if identity=="Carter & Former Pres. Nyerere"
	replace idcode=2 if identity=="Carter, former US Pres."
	replace idcode=2 if identity=="Jimmy Carter, US President"
	count if idcode==2
	tab conflict if idcode==2

	***Lord Owen 11 in 2***
	replace idcode=3 if identity=="D. Owen, UK Minister of State for Foreign and Commonwealth Affairs"
	replace idcode=3 if identity=="Lord Owen & UN Rep. Stoltenberg"
	replace idcode=3 if identity=="Lord Owen & Vance"
	replace idcode=3 if identity=="Owen, UK Sec of State for Foreign and Commonweath Affairs; Young, US Perm Rep at"
	replace idcode=3 if identity=="Vance, US Sec of State; Owen, UK Minister of State for Foreign and Commonwealth "
	count if idcode==3
	tab conflict if idcode==3

	***UN Rep. Arnault 11 in 1***
	replace idcode=4 if identity=="UN Arnault"
	replace idcode=4 if identity=="UN Obs Arnault"	
	replace idcode=4 if identity=="UN Rep Jean Arnault"
	count if idcode==4
	tab conflict if idcode==4

	***Rajiv Gandhi 10 in 1***
	replace idcode=5 if identity=="Prime Minister Ghandi"
	replace idcode=5 if identity=="Prime Minister Ghandi, Foreign Min Bhandari"
	replace idcode=5 if identity=="Prime Minister Ghandi, Indian Min of State For Aff Sugh, Min of State For Aff Ch"
	count if idcode==5
	tab conflict if idcode==5

	***Conclaves 10 in 1***
	replace idcode=6 if identity=="Mgr. Jaime Conclaves"
	replace idcode=6 if identity=="Mgr. Jaime Conclaves (Roman Catholic Archbishop of Beira)"
	replace idcode=6 if identity=="Mgr. Jaime Conclaves (the Roman Archbishop of Beira)"
	replace idcode=6 if identity=="Mgr. Jaime conclaves"
	replace idcode=6 if identity=="Mgr. jaime Conclaves"
	count if idcode==6
	tab conflict if idcode==6

	***Mugabe 10 in 1***
	replace idcode=7 if identity=="Comm of Sant Edidio, President Moi, and President Mugabe"
	replace idcode=7 if identity=="President Moi and President Mugabe" 
	replace idcode=7 if identity=="President Moi, Mugabe, Sant Edidio Comm."
	replace idcode=7 if identity=="President Moi, President Mugabe, Sant Edidio"
	replace idcode=7 if identity=="President Moi, President Mugabe, Sant Edidio Comm."
	replace idcode=7 if identity=="President Moi, President Mugabe, and Sant Edidio"
	replace idcode=7 if identity=="President Mugabe"
	replace idcode=7 if identity=="President Mugabe, Botswana President Maise"
	replace idcode=7 if identity=="President Mugabe, President Maise"
	count if idcode==7
	tab conflict if idcode==7


*** page 142. In text statistics ***

	***68 of 153 (44%) conflicts have diplo***
	codebook conflict	
	tab conflict if diplomatic==1

	***Sudan 32***
	tab conflict if ccode==625 & diplomatic==1

	***Sudan 75% negrank=1 (21 of 28)***
	tab negrank if ccode==625 & mediation==1

	***Guatemala 26***
	tab conflict if ccode==90 & diplomatic==1

	***Guatemala negrank=2 56% (13 of 23)***
	tab negrank if ccode==90 & mediation==1

	***El Salvador 20***
	tab conflict if ccode==92 & diplomatic==1

	***Liberia 23***
	tab conflict if ccode==450 & diplomatic==1

	***Mozambique 22***
	tab conflict if ccode==541 & diplomatic==1

	***Afghanistan 19***
	tab conflict if ccode==700 & diplomatic==1

	***Colombia 3***
	tab conflict if ccode==100 & diplomatic==1



*** Figure 7: Intervention by Decade ***
*** This figure uses the diplomatic data merged with Regan (2002) ***

	use "C:\Diplomatic\DME.dta", clear

	gen str2 Year = substr(start, -2, .)
	destring Year, replace
	replace Year=Year+1900
	replace year=Year if year==.

	gen decade=.
	replace decade=4 if year>1940 & year<1950
	replace decade=5 if year>1949 & year<1960
	replace decade=6 if year>1959 & year<1970
	replace decade=7 if year>1969 & year<1980
	replace decade=8 if year>1979 & year<1990
	replace decade=9 if year>1989 & year<2000
	sort decade

	by decade: count if diplomatic==1
	by decade: count if military>0
	by decade: count if economic>0

*** Table I: Predicted Probability of Post-Conflict Stability ***

	set more off
	gen cnumb=.
	replace cnumb=1  if conflict==901
	replace cnumb=2  if conflict==977
	replace cnumb=3  if conflict==844
	replace cnumb=4  if conflict==984
	replace cnumb=6  if conflict==897
	replace cnumb=7  if conflict==982
	replace cnumb=9  if conflict==786
	replace cnumb=10  if conflict==962
	replace cnumb=13  if conflict==785
	replace cnumb=14  if conflict==799
	replace cnumb=15  if conflict==869
	replace cnumb=16  if conflict==933
	replace cnumb=18  if conflict==886
	replace cnumb=19  if conflict==946
	replace cnumb=20  if conflict==610
	replace cnumb=20  if conflict==970
	replace cnumb=20  if conflict==983
	replace cnumb=21  if conflict==871
	replace cnumb=22  if conflict==908
	replace cnumb=24  if conflict==858
	replace cnumb=24  if conflict==903
	replace cnumb=25  if conflict==934
	replace cnumb=25  if conflict==989
	replace cnumb=26  if conflict==788
	replace cnumb=26  if conflict==784
	replace cnumb=28  if conflict==827
	replace cnumb=29  if conflict==796
	replace cnumb=29  if conflict==802
	replace cnumb=30  if conflict==936
	replace cnumb=31  if conflict==620
	replace cnumb=33  if conflict==838
	replace cnumb=35  if conflict==866
	replace cnumb=36  if conflict==899
	replace cnumb=36  if conflict==902
	replace cnumb=39  if conflict==793
	replace cnumb=40  if conflict==829
	replace cnumb=41  if conflict==857
	replace cnumb=42  if conflict==892
	replace cnumb=43  if conflict==957
	replace cnumb=44  if conflict==859
	replace cnumb=47  if conflict==910
	replace cnumb=48  if conflict==845
	replace cnumb=50  if conflict==898
	replace cnumb=51  if conflict==948
	replace cnumb=52  if conflict==956
	replace cnumb=53  if conflict==992
	replace cnumb=53  if conflict==993
	replace cnumb=54  if conflict==781
	replace cnumb=55  if conflict==817
	replace cnumb=56  if conflict==863
	replace cnumb=57  if conflict==863
	replace cnumb=63  if conflict==994
	replace cnumb=64  if conflict==942
	replace cnumb=65  if conflict==805
	replace cnumb=66  if conflict==814
	replace cnumb=67  if conflict==823
	replace cnumb=68  if conflict==896
	replace cnumb=70  if conflict==904
	replace cnumb=71  if conflict==922
	replace cnumb=72  if conflict==832
	replace cnumb=73  if conflict==842
	replace cnumb=74  if conflict==941
	replace cnumb=73  if conflict==891
	replace cnumb=75  if conflict==971
	replace cnumb=77  if conflict==874
	replace cnumb=78  if conflict==975
	replace cnumb=80  if conflict==841
	replace cnumb=80  if conflict==850
	replace cnumb=81  if conflict==826
	replace cnumb=82  if conflict==882
	replace cnumb=83  if conflict==882
	replace cnumb=84  if conflict==997
	replace cnumb=85  if conflict==949
	replace cnumb=86  if conflict==789
	replace cnumb=87  if conflict==954
	replace cnumb=88  if conflict==985
	replace cnumb=89  if conflict==974
	replace cnumb=90  if conflict==894
	replace cnumb=91  if conflict==913
	replace cnumb=93  if conflict==907
	replace cnumb=94  if conflict==928
	replace cnumb=95  if conflict==864
	replace cnumb=96  if conflict==917
	replace cnumb=96  if conflict==939
	replace cnumb=97  if conflict==872
	replace cnumb=99  if conflict==880
	replace cnumb=100  if conflict==890
	replace cnumb=101  if conflict==947
	replace cnumb=102  if conflict==787
	replace cnumb=103  if conflict==925
	replace cnumb=104  if conflict==808
	replace cnumb=105  if conflict==887
	replace cnumb=106  if conflict==888
	replace cnumb=107  if conflict==950
	replace cnumb=109  if conflict==988
	replace cnumb=110  if conflict==855
	replace cnumb=111  if conflict==952
	replace cnumb=112  if conflict==996
	replace cnumb=114  if conflict==931
	replace cnumb=115  if conflict==966
	replace cnumb=116  if conflict==878
	replace cnumb=116  if conflict==955
	replace cnumb=117  if conflict==883
	replace cnumb=118  if conflict==930
	replace cnumb=119  if conflict==944
	replace cnumb=120  if conflict==853
	replace cnumb=121  if conflict==937
	replace cnumb=122  if conflict==976
	replace cnumb=123  if conflict==861
	replace cnumb=124  if conflict==967
	replace cnumb=125  if conflict==862
	replace cnumb=126  if conflict==995
	replace cnumb=127  if conflict==919
	replace cnumb=128  if conflict==835
	replace cnumb=129  if conflict==790
	replace cnumb=130  if conflict==847
	replace cnumb=131  if conflict==943
	replace cnumb=132  if conflict==986
	replace cnumb=133  if conflict==973
	replace cnumb=134  if conflict==964
	replace cnumb=137  if conflict==889
	replace cnumb=138  if conflict==920

	gen str2 endtempmnth=substr( endate, 1,index (endate, "/")-1)
	gen str2 endtempyr = substr(endate, -2, .)
	gen tempstrtyear=strttempyr
	gen tempendyear=real(endtempyr)

	gen dipend = date(enddate,"md19y")
	format dipend %d

	gen Startdate = date(startdate, "md19y")
	format Startdate %d
	gen conflictnum=cnumb
	gen conflict1=conflict

*** Collapsing to the conflict unit of observation ***

	collapse ccode (min)  tempstrtyear time (max) conflictnum  conflict1 negrank negmed medstrat medstmed outcomemed outcome dipcount medcount unilatcount moi carter owen arnault rajivg conclaves mugabe UN US cch timing mediation diplomatic tempendyear offer dipend , by (cnumb)

	rename tempstrtyear yrbeg
	rename tempendyear yrend
	gen yearongoing= yrbeg
	sort ccode yearongoing
	sort cnumb

	save "C:\Diplomatic\DME collapsed.dta", replace



*** Paste pathway for Doyle and Sambanis (2000) data from World Bank below ***

	clear
	set more off
	use "C:\Diplomatic\peacebuilding.dta"


	gen COW=.
	replace COW=700 if cluster=="AFG"
	replace COW=615 if cluster=="ALG"
	replace COW=540 if cluster=="ANG"
	replace COW=160 if cluster=="ARG"
	replace COW=373 if cluster=="AZE"
	replace COW=771 if cluster=="BGL"
	replace COW=145 if cluster=="BOL"
	replace COW=345 if cluster=="BOS"
	replace COW=775 if cluster=="BRM"
	replace COW=516 if cluster=="BUR"
	replace COW=811 if cluster=="CAM"
	replace COW=482 if cluster=="CAF"
	replace COW=483 if cluster=="CHD"
	replace COW=710 if cluster=="CHI"
	replace COW=100 if cluster=="COL"
	replace COW=484 if cluster=="CON"
	replace COW=345 if cluster=="CRO"
	replace COW=490 if cluster=="ZAI"
	replace COW=94 if cluster=="COS"
	replace COW=40 if cluster=="CUB"
	replace COW=352 if cluster=="CYP"
	replace COW=522 if cluster=="DJI"
	replace COW=42 if cluster=="DOM"
	replace COW=92 if cluster=="SAL"
	replace COW=530 if cluster=="ETH"
	replace COW=372 if cluster=="GRG"
	replace COW=350 if cluster=="GRE"
	replace COW=90 if cluster=="GUA"
	replace COW=41 if cluster=="HAI"
	replace COW=750 if cluster=="IND"
	replace COW=850 if cluster=="IDN"
	replace COW=630 if cluster=="IRN"
	replace COW=645 if cluster=="IRQ"
	replace COW=666 if cluster=="ISR"
	replace COW=663 if cluster=="JRD"
	replace COW=501 if cluster=="KEN"
	replace COW=730 if cluster=="KOR"
	replace COW=812 if cluster=="LAO"
	replace COW=660 if cluster=="LEB"
	replace COW=450 if cluster=="LBR"
	replace COW=820 if cluster=="MAL"
	replace COW=432 if cluster=="MLI"
	replace COW=70 if cluster=="MEX"
	replace COW=359 if cluster=="MLD"
	replace COW=600 if cluster=="MOR"
	replace COW=541 if cluster=="MOZ"
	replace COW=565 if cluster=="NAM"
	replace COW=93 if cluster=="NIC"
	replace COW=475 if cluster=="NIG"
	replace COW=200 if cluster=="IRE"
	replace COW=770 if cluster=="PAK"
	replace COW=910 if cluster=="PNG"
	replace COW=150 if cluster=="PAR"
	replace COW=135 if cluster=="PER"
	replace COW=840 if cluster=="PHL"
	replace COW=360 if cluster=="ROM"
	replace COW=365 if cluster=="RUS"
	replace COW=517 if cluster=="RWA"
	replace COW=451 if cluster=="SIE"
	replace COW=520 if cluster=="SOM"
	replace COW=560 if cluster=="SAF"
	replace COW=780 if cluster=="SRI"
	replace COW=625 if cluster=="SUD"
	replace COW=702 if cluster=="TAJ"
	replace COW=800 if cluster=="THA"
	replace COW=640 if cluster=="TUR"
	replace COW=500 if cluster=="UGA"
	replace COW=816 if cluster=="VTN"
	replace COW=679 if cluster=="YEM"
	replace COW=552 if cluster=="ZMB"

	collapse ccode (max) COW UNop2 UNop3 UNop4 pbs2s3 wartype logcost wardur factnum factnum2 trnsfcap treaty develop exp decade, by (cnumb)



	merge cnumb using "C:\Diplomatic\DME collapsed.dta", sort
	tab _merge


***replication of Doyle and Sambanis (2000: 788), Table 2, Model A****

	gen UNPKO=0
	replace UNPKO=1 if UNop2==1 | UNop3==1 | UNop4==1

	replace diplomatic=0 if diplomatic==. & _merge==3
	replace cch=0 if diplomatic==0 & _merge==3
	replace UN=0 if diplomatic==0 & UN==. & _merge==3
	replace medcount=0 if medcount==. & diplomatic==0 & _merge==3

 
	set seed 123456789
	set more off
	logit pbs2s3 wartype logcost wardur factnum factnum2 trnsfcap UNPKO treaty develop exp decade,robust cluster(COW)
	estsimp logit pbs2s3 wartype logcost wardur factnum factnum2 trnsfcap UNPKO treaty develop exp decade,robust cluster(COW)

	setx mean
	setx wartype 1  UNPKO 1 
	simqi, listx       
	/* p=.367 */

	drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 

*** Adding Diplomatic Intervention Variables ***

*** fixing variable outcome ***

	replace outcome=0 if outcome==.


	estsimp logit pbs2s3 wartype logcost wardur factnum factnum2 trnsfcap UNPKO treaty develop exp decade UN outcome cch medcount,robust cluster(COW)

	setx mean
	setx wartype 1 UN  1 medcount 10 UNPKO 1 cch 0
	simqi, listx 
   	 /* p=.47 */
	 /* (.47-.36)/(.36) = .30 */ 

	setx  UN  0 medcount 10 UNPKO 1 cch 1
	simqi, listx     
	/* p=.986 */

	drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14 b15 b16 









