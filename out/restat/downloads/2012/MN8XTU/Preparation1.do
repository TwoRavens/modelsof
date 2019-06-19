clear all
set more off
set mem 800m
set matsize 900

use "/Users/paulinegrosjean/LITS/Research/MarkDemocPaper/RESTAT/LITS 2006 data.dta"
cd "/Users/paulinegrosjean/LITS/Research/MarkDemocPaper/RESTAT"

set more off

*** DEPENDENT VARIABLES ********
gen favmarket=1 if q310==1
replace favmarket=0 if (q310==2|q310==3)
label define favmarket 0 planeco_or_not_matter 1 market_best
label values favmarket favmarket

gen favcomm=1 if q310==2
replace favcomm=0 if (q310==1|q310==3)
label define favcomm 0 market_or_not_matter 1 planeco_best
label values favcomm favcomm

gen favdemoc=1 if q311==1  
replace favdemoc=0 if (q311==2|q311==3) 
label define favdemoc 0 autho_or_not_matter 1 democ_best 
label values favdemoc favdemoc 

gen favautho=1 if q311==2 
replace favautho=0 if (q311==1|q311==3) 
tab favautho 
label define favautho 0 demo_or_not_matter 1 authorit 
label values favautho favautho  

********** alternative measure of political preferences: importance of democratic institutions ****
cap drop imp* 
gen imp_freelection=(q312_1>3) if q312_1!=.  
gen imp_laworder=(q312_2>4) if q312_2!=.  
gen imp_freespeech=(q312_3>4) if q312_2!=.  
gen imp_indepress=(q312_5>4) if q312_5!=.  
gen imp_polopp=(q312_6>4) if q312_6!=.  
gen imp_courtindep=(q312_7>4) if q312_7!=.  
gen imp_courtequal=(q312_8>4) if q312_8!=.  
gen imp_minor=(q312_9>4) if q312_9!=.  
gen imp_freeabroad=(q312_10>4) if q312_10!=.  
egen impdemo=rowtotal(imp_*) 

*** INDEPENDENT VARIABLES *****
*/ age groups*/
gen young=0
replace young=1 if (ageB>=17 & ageB<35)

gen adult=0
replace adult=1 if (ageB>=35 & ageB<50)

gen midage=0
replace midage=1 if (ageB>=50 & ageB<65)

gen old=0
replace old=1 if (ageB>=65)

*/ gen income groups*/
gen rich=(igroup==3) 
gen medium=(igroup==2) 
gen poor=(igroup==1) 

*/ rural vs. urban */
label drop tablec 
label define tablec 1 urban 2 rural 3 metropol  
label values tablec tablec 

*/ gen occupation groups*/

rename q405a q405_1
rename q405b q405_2
rename q405c q405_3
rename q405d q405_4
rename q405e q405_5

gen mainjob=q407a if (q414==.|q414==1)
replace mainjob=q407b if q414==2
replace mainjob=q407c if q414==3
replace mainjob=q407d  if q414==4
replace mainjob=q407e  if q414==5

gen mainjoboccup=q405_1 if (q414==.|q414==1)
replace mainjoboccup=q405_2 if q414==2
replace mainjoboccup=q405_3 if q414==3
replace mainjoboccup=q405_4 if q414==4
replace mainjoboccup=q405_5 if q414==5

* generate variable for selfemployed: all those who answer work for self at question q407 
cap drop selfemp
gen selfemp= (mainjob==2)

* generate occupations* 
gen whnow=0
replace whnow=1 if (mainjoboccup==1 | mainjoboccup==2 |mainjoboccup==3)
gen blnow=0
replace blnow=1 if (mainjoboccup==7 | mainjoboccup==8 |mainjoboccup==9)
gen servnow=0
replace servnow=1 if (mainjoboccup==4 | mainjoboccup==5)
gen farmnow=0
replace farmnow=1 if (mainjoboccup==6)
gen armynow=0
replace armynow=1 if (mainjoboccup==10)
gen farmfarmworker=0
replace farmfarmworker=1 if (farmnow==1 | mainjob==3)
gen otheract_miss=0
replace otheract_miss=1 if (q401==1 & mainjob==.)
gen otherworkwage_miss=0
replace otherworkwage_miss=1 if (q401==1 & mainjoboccup==.)
cap drop unemp*
gen unemp=0 
replace unemp=1 if (q401==0 & q508==0 & (q510==1 | (q510==0 & (q512==5 | q512==4))))
cap drop pensioner
gen pensioner=0
replace pensioner=1 if (q401==0 & q512==7)
tab pensioner 
cap drop student
gen student=0
replace student=1 if (q401==0 & q507==0 & q512==6)
tab student
cap drop housewife
gen housewife=0
replace housewife=1 if (q401==0 & q512==1)
tab housewife

** education **
gen educ=0 if q501==1
replace educ=1 if q501==2
replace educ=2 if q501==3
replace educ=3 if q501==4
replace educ=4 if q501==5
replace educ=5 if q501==6
cap label drop educ
label define educ 0 noeduc 1 comp_educ 2 seec_educ 3 prof_train 4 univ 5 post_grad
label values educ educ

**  FRONTIER ZONES from map of PSUs ******

*/ Generate identifier psu*/
gen psu=country*1000+tabled
su psu
*1 estonia russia
gen fronteer1=.
for num 20022 20023 20024 20025 20026 20027 27004 27005  : replace fronteer1=1 if psu==X
*2 estonia latvia
gen fronteer2=.
for num 20029 20045 24050 : replace fronteer2=1 if psu==X
*3 latvia lituania
gen fronteer3=.
for num 24017 24018 24019 24020 25016 25015 25028 25022: replace fronteer3=1 if psu==X
*/ 4 ALBANIA MONTENEGRO*/
gen fronteer4=.
for num 1025 1026 1046 1047 10031 10050 10012 10032 10033 10001/10011 10046 10047 10044: replace fronteer4=1 if psu==X
*/  ARMENIA GEORGIA*/
gen fronteer5=.
for num  18030 21048 21043 21042 21024 21041 : replace fronteer5=1 if psu==X
*/  AZERBAIJAN GEORGIA*/
gen fronteer6=.
for num 19041 19021 19037 19034 21040 21038 21023 : replace fronteer6=1 if psu==X
*/ BELARUS POLAND*/
gen fronteer7=.
for num 2022 2036 2007 2008 2020 2021 11043 11033 : replace fronteer7=1 if psu==X
*/ BELARUS UKRAINE*/
gen fronteer8=.
for num 2015 2016 2014 2040 2009 2006 2041 2042 2018 17011 17025 17017 17031 : replace fronteer8=1 if psu==X
*/ BELARUS RUSSIA*/
gen fronteer9=.
for num 2014 2015 2040 2017 2049 2034 2011 2013 2038 2010 2050 27040: replace fronteer9=1 if psu==X
*/ BELARUS LITHUANIA*/
gen fronteer10=.
for num 2020 2043 25038/25046 25048 25050: replace fronteer10=1 if psu==X
*/ BOSNIA CROATIA*/
gen fronteer11=.
for num 3048 3043 3044 3039 3033 3024 3002 3003 3005 3045 5039 5033 5028 5009 5020 5021 5022 5029 5031 : replace fronteer11=1 if psu==X
*/ BOSNIA SERBIA*/
gen fronteer12=.
for num 3037 3050 3010 3048 13030 13022 13026 : replace fronteer12=1 if psu==X
*/ BULG MACEDONIA*/
gen fronteer13=.
for num 4014 4015 7016 7017 : replace fronteer13=1 if psu==X
*/ BULG ROMANIA*/
gen fronteer14=.
for num 4049 4043 4039 4042 4040 4041 12045 12040 12035 12023 : replace fronteer14=1 if psu==X
*/ croat sloven*/
gen fronteer15=.
for num 5037 5016 5017 5001 5008 5042/5049 5050 5004 5010 15015 15016 15034 15031 15013 15039 15004 15049: replace fronteer15=1 if psu==X
*/ Croat hung*/
gen fronteer16=.
for num 5041 5019 5014 8050 8027 8012: replace fronteer16=1 if psu==X
*/ croat serb*/
gen fronteer17=.
for num 5026 5027 5024 5030 13008 13045 : replace fronteer17=1 if psu==X
*/ CZECH slovak*/
gen fronteer18=.
for num 6044 6038 6042 14038 14010 14008 14032 14014 : replace fronteer18=1 if psu==X
*/ cezch poland*/
gen fronteer19=.
for num 6023 6024 6041 6048 6049 6047 6050 11025 11024 11009 11031 : replace fronteer19=1 if psu==X
*/ HUNG ROMANIA*/
gen fronteer20=.
for num 8020 8040 8021 12010 12012 : replace fronteer20=1 if psu==X
*/ HUNG SERB*/
gen fronteer21=.
for num 8017 13046 13024 : replace fronteer21=1 if psu==X
*/ HUNG SLOVAK*/
gen fronteer22=.
for num 8042 8024 8026 8023 8019 8039 8037 8014 14003 14004 14005 14029 14011 14013 14050 : replace fronteer22=1 if psu==X
*/ KAZAK KYRGYZ*/
gen fronteer23=.
for num 22050 22015 22034 22003 22004 22005 22006 22035 23050 23010 23001 23002 23003 23004 23005 23006 23007 23008 23022 23027 23018 : replace fronteer23=1 if psu==X
*/ KAZAK RUSSIA*/
gen fronteer24=.
for num 22012 22013 22014 22025 22027 22021 22022 22042 22043 22008 22009 22040 27031 27032 27048 27046 27017 27025 27026: replace fronteer24=1 if psu==X
*/ KYRGYZ TAJIK*/
gen fronteer25=.
for num 23019 23020 23021 28027/28030 28024 28033/28025: replace fronteer25=1 if psu==X
*/ LITH RUSSIA*/
gen fronteer26=.
for num 25019 25032 27015 : replace fronteer26=1 if psu==X
*/ MOLDOVA ROMANIA*/
gen fronteer27=.
for num 9049 9044 9020 9018 9042 9038 9013 9022 12017 12018 12015 12025 12022 : replace fronteer27=1 if psu==X
*/ MONG RUSSIA*/
gen fronteer28=.
for num 26049 26046 26020 26021 26050 26026 26027 26031 26033 26030 26036 27041 27020 27042: replace fronteer28=1 if psu==X
*/ SERBIA ROMANIA*/
gen fronteer29=.
for num 13034 13011 13044 13042 13049 13048 13048 13038 13050 13029 12048 12047 : replace fronteer29=1 if psu==X
*/ SERBIA MACEDONIA*/
gen fronteer30=.
for num 13047 7029 7009 7043 7048 7049 7039 7001/7008 7035 7036 : replace fronteer30=1 if psu==X
*/ POLAND RUSSIA*/
gen fronteer31=.
for num 11047 27015 : replace fronteer31=1 if psu==X
*/ POLAND UKRAINE*/
gen fronteer32=.
for num 11011 11012 17042 17021 17022 17039: replace fronteer32=1 if psu==X
*/ POLAND SLOVAK*/
gen fronteer33=.
for num 11037 11038 14046 14045 14021 14040 14016 14014 : replace fronteer33=1 if psu==X
*/ ROMANIA UKRAINE*/
gen fronteer34=.
for num 12006 12013 17048 : replace fronteer34=1 if psu==X
*/ SLOVAK UKRAINE*/
gen fronteer35=.
for num 14027 17039 : replace fronteer35=1 if psu==X
*/ UKRAINE RUSSIA*/
gen fronteer36=.
for num 17026 17007 17045 17015 27006 27012 27007 27010 27022 27021 27023 27024: replace fronteer36=1 if psu==X

*******************closed frontiers  ********************************************

*/ 6 ARMENIA AZERBAIJAN*/
gen fronteer37=.
for num 18050 18025 18045 18046 19038 19023 : replace fronteer37=1 if psu==X
*/ Georgia russia (not good)*/
gen fronteer38=.
for num 21022 21037 21039 27044 : replace fronteer38=1 if psu==X
*/ KAZAKH UZBEK */
gen fronteer39=.
for num 22048 22028 29024 29041 29014 29044 29001 29002 29003 29004 29016: replace fronteer39=1 if psu==X
*/KYRGYZ UZBEK*/
gen fronteer40=.
for num 23009 23048 23042 23040 23032 23033 23037 29011 29031 29032 29033 29019 29005 29021 29048 29020 29017 29045: replace fronteer40=1 if psu==X
*/ MOLDOVA UKRAINE*/
gen fronteer41=.
for num 9048 9019 9026 17043 17006 17008 : replace fronteer41=1 if psu==X
*/ TAJIK UZBEK*/
gen fronteer42=.
for num 28033 28034 28035 28032 28031 28025 28023 28026 28027 28028 28029 28030 28036 28037 28048 28047 28042 28021 28041 29045 29047 29042 29015 29035 29037 29013 29038 29039: replace fronteer42=1 if psu==X

gen fronteer=0
forvalues i=1/36 {
 	replace fronteer=1 if fronteer`i'==1
}

*/ generate Dummy more democracy according to country democracy ranking by Freedom House*/
gen moredemocracy=.
replace moredemocracy=0 if fronteer>0
replace moredemocracy=1 if fronteer1==1 & country==20
replace moredemocracy=1 if fronteer2==1 & country==20
replace moredemocracy=1 if fronteer3==1 & country==24
replace moredemocracy=1 if fronteer4==1 & country==1
replace moredemocracy=1 if fronteer5==1 & country==21 
replace moredemocracy=1 if fronteer6==1 & country==21
replace moredemocracy=1 if fronteer7==1 & country==11
replace moredemocracy=1 if fronteer8==1 & country==17
replace moredemocracy=1 if fronteer9==1 & country==27
replace moredemocracy=1 if fronteer10==1 & country==25
replace moredemocracy=1 if fronteer11==1 & country==5
replace moredemocracy=1 if fronteer12==1 & country==13
replace moredemocracy=1 if fronteer13==1 & country==4
replace moredemocracy=1 if fronteer14==1 & country==4
replace moredemocracy=1 if fronteer15==1 & country==15
replace moredemocracy=1 if fronteer16==1 & country==8
replace moredemocracy=1 if fronteer17==1 & country==5
replace moredemocracy=1 if fronteer18==1 & country==14
replace moredemocracy=1 if fronteer19==1 & country==11
replace moredemocracy=1 if fronteer20==1 & country==8
replace moredemocracy=1 if fronteer21==1 & country==8
replace moredemocracy=1 if fronteer22==1 & country==14
replace moredemocracy=1 if fronteer23==1 & country==23
replace moredemocracy=1 if fronteer24==1 & country==27
replace moredemocracy=1 if fronteer25==1 & country==23
replace moredemocracy=1 if fronteer26==1 & country==25
replace moredemocracy=1 if fronteer27==1 & country==12
replace moredemocracy=1 if fronteer28==1 & country==26 
replace moredemocracy=1 if fronteer29==1 & country==12
replace moredemocracy=1 if fronteer30==1 & country==13
replace moredemocracy=1 if fronteer31==1 & country==11
replace moredemocracy=1 if fronteer32==1 & country==11
replace moredemocracy=1 if fronteer33==1 & country==14
replace moredemocracy=1 if fronteer34==1 & country==12
replace moredemocracy=1 if fronteer35==1 & country==14
replace moredemocracy=1 if fronteer36==1 & country==17
** closed*****
*replace moredemocracy=1 if fronteer37==1 & country==18
*replace moredemocracy=1 if fronteer38==1 & country==21
*replace moredemocracy=1 if fronteer39==1 & country==22
*replace moredemocracy=1 if fronteer40==1 & country==23
*replace moredemocracy=1 if fronteer41==1 & country==17
*replace moredemocracy=1 if fronteer42==1 & country==28


*/ replace dummy by qualitative variable to reflect ddifferences in extent of democracy*/
gen moredemocracy2=.
replace moredemocracy2=0 if fronteer>0
replace moredemocracy2=4 if fronteer==1 & country==20
replace moredemocracy2=1 if fronteer2==1 & country==20
replace moredemocracy2=1 if fronteer3==1 & country==24
replace moredemocracy2=1 if fronteer4==1 & country==1
replace moredemocracy2=2 if fronteer5==1 & country==16 
replace moredemocracy2=2 if fronteer6==1 & country==21
replace moredemocracy2=5 if fronteer7==1 & country==11
replace moredemocracy2=3 if fronteer8==1 & country==17
replace moredemocracy2=2 if fronteer9==1 & country==27
replace moredemocracy2=5 if fronteer10==1 & country==25
replace moredemocracy2=2 if fronteer11==1 & country==5
replace moredemocracy2=2 if fronteer12==1 & country==13
replace moredemocracy2=2 if fronteer13==1 & country==4
replace moredemocracy2=2 if fronteer14==1 & country==4
replace moredemocracy2=2 if fronteer15==1 & country==15
replace moredemocracy2=2 if fronteer16==1 & country==8
replace moredemocracy2=1 if fronteer17==1 & country==5
replace moredemocracy2=1 if fronteer18==1 & country==14
replace moredemocracy2=1 if fronteer19==1 & country==11
replace moredemocracy2=2 if fronteer20==1 & country==8
replace moredemocracy2=2 if fronteer21==1 & country==8
replace moredemocracy2=1 if fronteer22==1 & country==14
replace moredemocracy2=2 if fronteer23==1 & country==23
replace moredemocracy2=2 if fronteer24==1 & country==27
replace moredemocracy2=1 if fronteer25==1 & country==23
replace moredemocracy2=4 if fronteer26==1 & country==25
replace moredemocracy2=2 if fronteer27==1 & country==12
replace moredemocracy2=3 if fronteer28==1 & country==26 
replace moredemocracy2=1 if fronteer29==1 & country==12
replace moredemocracy2=1 if fronteer30==1 & country==13
replace moredemocracy2=4 if fronteer31==1 & country==11
replace moredemocracy2=3 if fronteer32==1 & country==11
replace moredemocracy2=1 if fronteer33==1 & country==14
replace moredemocracy2=2 if fronteer34==1 & country==12
replace moredemocracy2=3 if fronteer35==1 & country==14
replace moredemocracy2=2 if fronteer36==1 & country==17

gen numfront=.
local i=1
while `i'<37{
replace numfront=`i' if fronteer`i'==1
local i=`i' +1
}

* GENERATE CULTURAL ZONES**

gen transylvania=0
for num 12001/12013 12042 12043 12046/12050: replace transylvania=1 if psu==X
label var transylvania "Transylvania 1831"

gen wallachia=0
for num 12021 12024 12028/12041 12044 12045: replace wallachia=1 if psu==X
label var wallachia "Wallachia"

gen bessarabia=0
for num 17006 17008 17043 9013 9022 9021 9023 9026 12023 : replace bessarabia=1 if psu==X
label var bessarabia "Bessarabia"


gen moldavia=0
for num 12014/12020 12022 12025/12027: replace moldavia=1 if psu==X
replace moldavia =1 if (country==9 & bessarabia==0)
label var moldavia "Moldavia"

replace bessarabia=1 if moldavia==1

gen silesia_pol=0
for num 11008 11009 11036 11031 11041 11018: replace silesia_pol=1 if psu==X
label var silesia_pol "Silesia_Poland"

gen silesia_czech=0
for num 6041 6045/6050: replace silesia_czech=1 if psu==X
label var silesia_czech "Silesia_Czech"

gen silesia=silesia_pol+silesia_czech

gen center_mont=0
replace center_mont=0 if country==10
for num  1022/1025 1049 1020 1018 1039 1018/1039 : replace center_mont=1 if psu==X

gen dalmatia=0
for num 5036 5023 5028 5034 5035 5032 5033 5040 5039:  replace dalmatia=1 if psu==X

gen vojvodina=0
for num 13008 13018 13028 13042 13029 13049 13044 13050 13025/13027 13040 13045 13046 13024 13034 130110 : replace vojvodina=1 if psu==X
label var vojvodina "Vojvodina_Serbia"

***** Ottoman Empire  *****
gen zone_ottoman=0
replace zone_ottoman=1 if (country==1|country==4|country==12|country==10|country==13|country==3|country==7)
replace zone_ottoman=1  if (country==10 & center_mont==0) | wallachia==1 | moldavia==1
replace zone_ottoman=0 if vojvodina==1
for num 17023 17047 17034 17028 17035 17009 17002 17014 17015 17016 17032 : replace zone_ottoman=1 if psu==X
for num 9013 9021 9022 9023 9026 12023: replace zone_ottoman=1 if psu==X
for num 17043 17006 17008: replace zone_ottoman=1 if psu==X

***** Habsburg Empire  *****
gen zone_austro=0
replace zone_austro=1 if ((country==5 & dalmatia==0)| silesia_pol==1|country==6|country==14|country==8|country==15|vojvodina==1|transylvania==1 )

***** Prussian Empire  *****
gen prussia_15=0
replace prussia_15=1 if country==24 | country==20
for num 27015 11030 11006 11050 25013 25014 25016 11044 11021 11027 11047 11020  : replace prussia_15=1 if psu==X 
gen prussia_1812=0
for num 27015 11030 11050 11006 11008 11031 11009 11041 11018 11036 11044 11021 11047 11020 11027 25013 25014 25016 : replace prussia_1812=1 if psu==X
replace prussia_1812=1 if silesia_pol==1

gen prussia_1914=0
for num 11030 11050 11006 11008 11031 11009 11041 11018 11036 11044 11021 11047 11020 11027 11039 11010 11032 11028 11049 11007 11029: replace prussia_1914=1 if psu==X
replace prussia_1914=1 if prussia_1812==1

gen zone_prussia=0
replace zone_prussia=1 if prussia_15==1 & prussia_1812==1 & prussia_1914==1 

*** Polish Lithuanian Commonwealth *****
gen zone_pol=0
replace zone_pol=1 if (country==2|country==11|country==17|country==27|country==25)

***central Asia without Russia **

gen zone_cafsu=0
replace zone_cafsu=1 if (country==22|country==23|country==28|country==29)

** Yugoslavia ** 
gen zone_yougo=0
replace zone_yougo=1 if (country==3|country==5|country==7|country==10|country==13|country==15)

** EU**
gen zone_EU=0
replace zone_EU=1 if (country==4|country==6|country==8|country==11|country==12|country==14|country==15|country==20|country==24|country==25)

** USSR ***
gen zone_USSR=0
replace zone_USSR=1 if (country==2|country==9|country==17|country==18|country==19|country==20|country==21|country==22|country==23|country==24|country==25|country==27|country==28|country==29 )

**CIS***
gen zone_CIS=0
replace zone_CIS=1 if (country==2|country==9|country==17|country==18|country==19|country==21|country==22|country==23|country==27|country==28|country==29 )


/***INDUSTRIAL INDEX: small medium size newly (after 1989) created private enterprises or self employed with more than 5 employees****/ 

gen smallent=0 if (q411a!=.|q411b!=.|q411c!=.|q411d!=.|q411e!=.) 
replace smallent=1 if (q411a==1|q411b==1|q411c==1|q411d==1|q411e==1) 
for num 2/15: replace smallent=1 if q413a==X 
tab smallent 

gen medent=0 if (q411a!=.|q411b!=.|q411c!=.|q411d!=.|q411e!=.) 
replace medent=1 if (q411a==2|q411b==2|q411c==2|q411d==2|q411e==2) 
for num 16/100: replace medent=1 if q413a==X 
tab medent 

gen largent=0 if (q411a!=.|q411b!=.|q411c!=.|q411d!=.|q411e!=.) 
replace medent=1 if (q411a==3|q411b==3|q411c==3|q411d==3|q411e==3) 

gen privateent=0 if (q408a2!=.|q408a3!=.|q408b2!=.|q408b3!=.|q408c2!=.|q408c3!=.|q408d2!=.|q408d3!=.|q408e2!=.|q408e3!=.) 
replace privateent=1 if (q408a2==1|q408a3==1|q408b2==1|q408b3==1|q408c2==1|q408c3==1|q408d2==1|q408d3==1|q408e2==1|q408e3==1) 
label var privateent "private or foreign ent" 

gen newent=0 if q409a!=. 
replace newent=1 if (q409a==0|q409b==0|q409c==0|q409d==0|q409e==0) 
 
gen workcontract=0 if (q410a!=.|q410b!=.|q410c!=.|q410d!=.|q410e!=.) 
replace workcontract=1 if (q410a==1|q410b==1|q410c==1|q410d==1|q410e==1) 
tab workcontract 

gen active=0 
replace active=1 if (q512!=1 | q512!=3 |q512!=6| q512!=7) 

*create synthetic indices** 

egen laborindex=rsum(smallent medent privateent newent workcontract) if (smallent!=. | medent!=. | privateent!=. | newent!=. | workcontract!=.) 
egen laborindex2=rsum(smallent medent privateent newent ) if (smallent!=. | medent!=. | privateent!=. | newent!=. ) 
egen laborindex3=rsum(smallent medent privateent largent newent workcontract ) if (smallent!=. | medent!=. | privateent!=. | newent!=. ) 

save "/Users/paulinegrosjean/LITS/amont/LIT2006_clo0.dta", replace 

collapse (mean) laborindex laborindex2 active, by(country region) 
gen laborindex_prop= laborindex/ active 
sort country region 
save "/Users/paulinegrosjean/LITS/amont/laborindex.dta", replace 

use "/Users/paulinegrosjean/LITS/amont/LIT2006_clo0.dta", clear 
drop laborindex* 
sort country region 
merge country region using  "/Users/paulinegrosjean/LITS/amont/laborindex.dta" 
tab _merge 
  
drop _merge 

*******generate indicator of regional development from expenditure data******* 
egen exp_region=mean(pcexp), by(region) 
egen exp_country=mean(pcexp), by (country) 
gen relexp_region=exp_region/exp_country 
gen logrelexp_region=log(relexp_region) 
sort country 
save "/Users/paulinegrosjean/LITS/amont/LIT2006_clo0.dta", replace 
  
** merge with other indicators of democracy ******
set more off 
use demo_indic2006.dta, clear 
sort country 
save, replace

use "/Users/paulinegrosjean/LITS/amont/LIT2006_clo0.dta", clear
merge country using demo_indic2006.dta
tab _merge 
drop if _merge!=3
drop _merge 
label var bti "BTI index of freedom - Higher number indicates less freedom"
label var polity4_demo  "Polity IV democracy index"
label var polity4_pol "Polity IV - political index"
label var free_world "Freedom in the World index"
label var freehouse "Freedom House index"

** drop Turkey **
drop if country==16
save LIT2006_RESTAT.dta, replace  


save LIT2006_RESTAT.dta, replace  

