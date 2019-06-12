*Author: Geoff Sheagley & Logan Dancey

*Creation Date: 6/20/2012

*Purpose: Variable Coding for Replication 

*Input Files -  CCES_2006_CommonContent.dta (A clean version of the 2006 CCES)

*Output Files - Modified Version of the 2006 CCES.  

*******************************************************************

****Initial Data Coding 
*id 

gen id = _n

sum id

*State

encode(v1002), generate(state)

*Pty ID

gen ptyid=v3007
replace ptyid=. if ptyid==8
tab1 v3007 ptyid

gen ptyid2=1 if ptyid > 0 & ptyid < 4
replace ptyid2=2 if ptyid==4
replace ptyid2=3 if ptyid > 4 & ptyid < 8
tab1 ptyid2 v3007

label define ptyid2 1 "Democrat" 2 "Independent" 3 "Republican"
label values ptyid2 ptyid2
tab1 ptyid2 v3007 if v3007 <=7


gen pidstrength=abs(4-ptyid)
tab1 pidstrength v3007

*Ideology 
gen ideo=v2021
replace ideo=. if ideo==6
tab1 ideo v2021

gen ideoextreme=abs(3-v2021)
replace ideoextreme=0 if ideoextreme==3

*Education 

gen educ=v2018
tab1 educ v2018

*Gender 

gen gender=v2004
gen woman=gender-1
tab1 woman v2004

*Race 

gen race=v2005
gen white=1 if race==1 
replace white=0 if race!=1
tab1 white v2005

*Political Interest

gen interest=1 if v2042==3
replace interest=2 if v2042==2
replace interest=3 if v2042==1
tab1 interest v2042


*News Consumption 
*Nat news
*gen evenews =  v2046

*Local news

*gen mornnews=v2047
*gen levenews=v2048

*Composite 
*gen newscon = (evenews+mornnews+levenews)/3

*Age

gen age=2006-v2020
tab1 age v2020

*Income

gen income=v2032
replace income=. if income==15
tab1 income v2032

****
*Knowledge of Senator's Roll Call Votes 
****

************************************
**Partian Birth Abortion Roll Call**
************************************

*Checked - 5/27/2011

gen knowabortsen1 = 1 if v3061==1 & v5022==1
replace knowabortsen1 =1 if v3061==2 & v5022==2
replace knowabortsen1 =0 if v3061==1 & v5022==2
replace knowabortsen1 =0 if v3061==2 & v5022==1
replace knowabortsen1 =2 if v3061==3

gen knowabortsen2 = 1 if v3062==1 & v5023==1
replace knowabortsen2 =1 if v3062==2 & v5023==2
replace knowabortsen2 =0 if v3062==1 & v5023==2
replace knowabortsen2 =0 if v3062==2 & v5023==1
replace knowabortsen2 =2 if v3062==3

gen knowdevabort=knowabortsen2 if state==30
replace knowdevabort=knowabortsen2 if state==16
replace knowdevabort=knowabortsen2 if state==40
replace knowdevabort=knowabortsen2 if state==9
replace knowdevabort=knowabortsen1 if state==19
replace knowdevabort=knowabortsen1 if state==34
replace knowdevabort=knowabortsen1 if state==47
replace knowdevabort=knowabortsen1 if state==42
replace knowdevabort=knowabortsen1 if state==50

gen knownondevabort=knowabortsen1 if state==30
replace knownondevabort=knowabortsen1 if state==16
replace knownondevabort=knowabortsen1 if state==40
replace knownondevabort=knowabortsen1 if state==9
replace knownondevabort=knowabortsen2 if state==19
replace knownondevabort=knowabortsen2 if state==34
replace knownondevabort=knowabortsen2 if state==42
replace knownondevabort=knowabortsen2 if state==47
replace knownondevabort=knowabortsen2 if state==50


***********
**Stem Cell
***********

*Checked - 5/26/2011

gen knowstemsen1 = 1 if v3064==1 & v5024==1
replace knowstemsen1 =1 if v3064==2 & v5024==2
replace knowstemsen1 =0 if v3064==1 & v5024==2
replace knowstemsen1 =0 if v3064==2 & v5024==1
replace knowstemsen1 =2 if v3064==3

gen knowstemsen2 = 1 if v3065==1 & v5025==1
replace knowstemsen2 =1 if v3065==2 & v5025==2
replace knowstemsen2 =0 if v3065==1 & v5025==2
replace knowstemsen2 =0 if v3065==2 & v5025==1
replace knowstemsen2 =2 if v3065==3

gen knowdevstem=knowstemsen1 if state==39
replace knowdevstem=knowstemsen2 if state==30
replace knowdevstem=knowstemsen2 if state==38
replace knowdevstem=knowstemsen1 if state==4
replace knowdevstem=knowstemsen1 if state==46
replace knowdevstem=knowstemsen1 if state==31
replace knowdevstem=knowstemsen1 if state==44
replace knowdevstem=knowstemsen2 if state==40
replace knowdevstem=knowstemsen2 if state==28
replace knowdevstem=knowstemsen1 if state==16

gen knownondevstem=knowstemsen2 if state==39
replace knownondevstem=knowstemsen1 if state==30
replace knownondevstem=knowstemsen1 if state==38
replace knownondevstem=knowstemsen2 if state==4
replace knownondevstem=knowstemsen2 if state==46
replace knownondevstem=knowstemsen2 if state==31
replace knownondevstem=knowstemsen2 if state==44
replace knownondevstem=knowstemsen1 if state==40
replace knownondevstem=knowstemsen1 if state==28
replace knownondevstem=knowstemsen2 if state==16


****************
**Iraq Withdrawl
****************

*Checked - 5/26/2011

gen knowiraqsen1 = 1 if v3067==1 & v5026==1
replace knowiraqsen1 =1 if v3067==2 & v5026==2
replace knowiraqsen1 =0 if v3067==1 & v5026==2
replace knowiraqsen1 =0 if v3067==2 & v5026==1
replace knowiraqsen1 =2 if v3067==3

gen knowiraqsen2 = 1 if v3068==1 & v5027==1
replace knowiraqsen2 =1 if v3068==2 & v5027==2
replace knowiraqsen2 =0 if v3068==1 & v5027==2
replace knowiraqsen2 =0 if v3068==2 & v5027==1
replace knowiraqsen2 =2 if v3068==3

gen knowdeviraq=knowiraqsen2 if state==30
replace knowdeviraq=knowiraqsen1 if state==19
replace knowdeviraq=knowiraqsen1 if state==10
replace knowdeviraq=knowiraqsen2 if state==7
replace knowdeviraq=knowiraqsen2 if state==40
replace knowdeviraq=knowiraqsen1 if state==24
replace knowdeviraq=knowiraqsen2 if state==3

gen knownondeviraq=knowiraqsen1 if state==30
replace knownondeviraq=knowiraqsen2 if state==19
replace knownondeviraq=knowiraqsen2 if state==10
replace knownondeviraq=knowiraqsen1 if state==7
replace knownondeviraq=knowiraqsen1 if state==40
replace knownondeviraq=knowiraqsen2 if state==24
replace knownondeviraq=knowiraqsen1 if state==3


*************
**Immigration 
*************

*Checked - 5/26/2011

gen knowimmigratesen1 = 1 if v3070==1 & v5028==1
replace knowimmigratesen1 =1 if v3070==2 & v5028==2
replace knowimmigratesen1 =0 if v3070==1 & v5028==2
replace knowimmigratesen1 =0 if v3070==2 & v5028==1
replace knowimmigratesen1 =2 if v3070==3

gen knowimmigratesen2 = 1 if v3071==1 & v5029==1
replace knowimmigratesen2 =1 if v3071==2 & v5029==2
replace knowimmigratesen2 =0 if v3071==1 & v5029==2
replace knowimmigratesen2 =0 if v3071==2 & v5029==1
replace knowimmigratesen2 =2 if v3071==3

gen knowdevimm=.
replace knowdevimm=knowimmigratesen1 if state==4
replace knowdevimm=knowimmigratesen1 if state==10
replace knowdevimm=knowimmigratesen1 if state==14
replace knowdevimm=knowimmigratesen1 if state==16
replace knowdevimm=knowimmigratesen1 if state==17
replace knowdevimm=knowimmigratesen1 if state==18
replace knowdevimm=knowimmigratesen1 if state==31
replace knowdevimm=knowimmigratesen1 if state==33
replace knowdevimm=knowimmigratesen1 if state==39
replace knowdevimm=knowimmigratesen1 if state==41
replace knowdevimm=knowimmigratesen1 if state==43
replace knowdevimm=knowimmigratesen1 if state==46
replace knowdevimm=knowimmigratesen1 if state==50
replace knowdevimm=knowimmigratesen2 if state==10
replace knowdevimm=knowimmigratesen2 if state==23
replace knowdevimm=knowimmigratesen2 if state==24
replace knowdevimm=knowimmigratesen2 if state==29
replace knowdevimm=knowimmigratesen2 if state==38
replace knowdevimm=knowimmigratesen2 if state==40
replace knowdevimm=knowimmigratesen2 if state==45

gen knownondevimm=.
replace knownondevimm=knowimmigratesen2 if state==4
replace knownondevimm=knowimmigratesen2 if state==10
replace knownondevimm=knowimmigratesen2 if state==14
replace knownondevimm=knowimmigratesen2 if state==16
replace knownondevimm=knowimmigratesen2 if state==17
replace knownondevimm=knowimmigratesen2 if state==18
replace knownondevimm=knowimmigratesen2 if state==31
replace knownondevimm=knowimmigratesen2 if state==33
replace knownondevimm=knowimmigratesen2 if state==39
replace knownondevimm=knowimmigratesen2 if state==41
replace knownondevimm=knowimmigratesen2 if state==43
replace knownondevimm=knowimmigratesen2 if state==46
replace knownondevimm=knowimmigratesen2 if state==50
replace knownondevimm=knowimmigratesen1 if state==10
replace knownondevimm=knowimmigratesen1 if state==23
replace knownondevimm=knowimmigratesen1 if state==24
replace knownondevimm=knowimmigratesen1 if state==29
replace knownondevimm=knowimmigratesen1 if state==38
replace knownondevimm=knowimmigratesen1 if state==40
replace knownondevimm=knowimmigratesen1 if state==45

**************
**Minimum Wage
**************

*Checked - 5/26/2011

gen knowminwagesen1 = 1 if v3073==1 & v5030==1
replace knowminwagesen1 =1 if v3073==2 & v5030==2
replace knowminwagesen1 =0 if v3073==1 & v5030==2
replace knowminwagesen1 =0 if v3073==2 & v5030==1
replace knowminwagesen1 =2 if v3073==3

gen knowminwagesen2 = 1 if v3074==1 & v5031==1
replace knowminwagesen2 =1 if v3074==2 & v5031==2
replace knowminwagesen2 =0 if v3074==1 & v5031==2
replace knowminwagesen2 =0 if v3074==2 & v5031==1
replace knowminwagesen2 =2 if v3074==3

gen knowdevminwage=knowminwagesen1 if state==36
replace knowdevminwage=knowminwagesen2 if state==40

gen knownondevminwage=knowminwagesen2 if state==36
replace knownondevminwage=knowminwagesen1 if state==40

****************
**Capital  Gains 
****************

*Checked - 5/26/2011

gen knowcapgainsen1 = 1 if v3076==1 & v5032==1
replace knowcapgainsen1 =1 if v3076==2 & v5032==2
replace knowcapgainsen1 =0 if v3076==1 & v5032==2
replace knowcapgainsen1 =0 if v3076==2 & v5032==1
replace knowcapgainsen1 =2 if v3076==3

gen knowcapgainsen2 = 1 if v3077==1 & v5033==1
replace knowcapgainsen2 =1 if v3077==2 & v5033==2
replace knowcapgainsen2 =0 if v3077==1 & v5033==2
replace knowcapgainsen2 =0 if v3077==2 & v5033==1
replace knowcapgainsen2 =2 if v3077==3

gen knowdevcap=knowcapgainsen2 if state==30
replace knowdevcap=knowcapgainsen2 if state==36
replace knowdevcap=knowcapgainsen2 if state==40
replace knowdevcap=knowcapgainsen2 if state==3
replace knowdevcap=knowcapgainsen1 if state==10
replace knowdevcap=knowcapgainsen1 if state==22

gen knownondevcap=knowcapgainsen1 if state==30
replace knownondevcap=knowcapgainsen1 if state==36
replace knownondevcap=knowcapgainsen1 if state==40
replace knownondevcap=knowcapgainsen1 if state==3
replace knownondevcap=knowcapgainsen2 if state==10
replace knownondevcap=knowcapgainsen2 if state==22

**CAFTA 

gen knowcaftasen1 = 1 if v3079==1 & v5034==1
replace knowcaftasen1 =1 if v3079==2 & v5034==2
replace knowcaftasen1 =0 if v3079==1 & v5034==2
replace knowcaftasen1 =0 if v3079==2 & v5034==1
replace knowcaftasen1 =2 if v3079==3

gen knowcaftasen2 = 1 if v3080==1 & v5035==1
replace knowcaftasen2 =1 if v3080==2 & v5035==2
replace knowcaftasen2 =0 if v3080==1 & v5035==2
replace knowcaftasen2 =0 if v3080==2 & v5035==1
replace knowcaftasen2 =2 if v3080==3

gen knowdevcafta=knowcaftasen1 if state==39
replace knowdevcafta=knowcaftasen2 if state==30
replace knowdevcafta=knowcaftasen1 if state==10
replace knowdevcafta=knowcaftasen2 if state==27
replace knowdevcafta=knowcaftasen2 if state==19
replace knowdevcafta=knowcaftasen1 if state==5
replace knowdevcafta=knowcaftasen2 if state==47
replace knowdevcafta=knowcaftasen2 if state==33
replace knowdevcafta=knowcaftasen2 if state==7
replace knowdevcafta=knowcaftasen2 if state==42
replace knowdevcafta=knowcaftasen1 if state==41
replace knowdevcafta=knowcaftasen1 if state==2
replace knowdevcafta=knowcaftasen1 if state==38
replace knowdevcafta=knowcaftasen2 if state==9

gen knownondevcafta=knowcaftasen2 if state==39
replace knownondevcafta=knowcaftasen1 if state==30
replace knownondevcafta=knowcaftasen2 if state==10
replace knownondevcafta=knowcaftasen1 if state==27
replace knownondevcafta=knowcaftasen1 if state==19
replace knownondevcafta=knowcaftasen2 if state==5
replace knownondevcafta=knowcaftasen1 if state==47
replace knownondevcafta=knowcaftasen1 if state==33
replace knownondevcafta=knowcaftasen1 if state==7
replace knownondevcafta=knowcaftasen1 if state==42
replace knownondevcafta=knowcaftasen2 if state==41
replace knownondevcafta=knowcaftasen2 if state==2
replace knownondevcafta=knowcaftasen2 if state==38
replace knownondevcafta=knowcaftasen1 if state==9

***
*Gen a dummy variable for each state
****

tab state, gen(statedum)


******
**Iraq (CHECKED FOR ACCURACY)
******

*Deviator 

tab v5017 if state==30  
gen ptyagdiraq=1 if ptyid2==1 & state==30
replace ptyagdiraq=0 if ptyid2==2 & state==30
replace ptyagdiraq=0 if ptyid2==3 & state==30

tab v5015 if state==10
replace ptyagdiraq=1 if ptyid2==1 & state==10
replace ptyagdiraq=0 if ptyid2==3 & state==10
replace ptyagdiraq=0 if ptyid2==2 & state==10

tab v5017 if state==7
replace ptyagdiraq=1 if ptyid2==1 & state==7
replace ptyagdiraq=0 if ptyid2==3 & state==7
replace ptyagdiraq=0 if ptyid2==2 & state==7

tab v5017 if state==40
replace ptyagdiraq=1 if ptyid2==3 & state==40
replace ptyagdiraq=0 if ptyid2==2 & state==40
replace ptyagdiraq=0 if ptyid2==1 & state==40

tab v5015 if state==24
replace ptyagdiraq=1 if ptyid2==1 & state==24
replace ptyagdiraq=0 if ptyid2==3 & state==24
replace ptyagdiraq=0 if ptyid2==2 & state==24

tab v5017 if state==3
replace ptyagdiraq=1 if ptyid2==1 & state==3
replace ptyagdiraq=0 if ptyid2==3 & state==3
replace ptyagdiraq=0 if ptyid2==2 & state==3

tab v5015 if state==19
replace ptyagdiraq=1 if ptyid2==1 & state==19
replace ptyagdiraq=0 if ptyid2==3 & state==19
replace ptyagdiraq=0 if ptyid2==2 & state==19

*Non-Deviator 

tab v5015 if state==30  
gen ptyagndiraq=1 if ptyid2==3 & state==30
replace ptyagndiraq=0 if ptyid2==2 & state==30
replace ptyagndiraq=0 if ptyid2==1 & state==30

tab v5017 if state==10
replace ptyagndiraq=1 if ptyid2==3 & state==10
replace ptyagndiraq=0 if ptyid2==2 & state==10
replace ptyagndiraq=0 if ptyid2==1 & state==10

tab v5015 if state==7
replace ptyagndiraq=1 if ptyid2==1 & state==7
replace ptyagndiraq=0 if ptyid2==3 & state==7
replace ptyagndiraq=0 if ptyid2==2 & state==7

tab v5015 if state==40
replace ptyagndiraq=1 if ptyid2==1 & state==40
replace ptyagndiraq=0 if ptyid2==2 & state==40
replace ptyagndiraq=0 if ptyid2==3 & state==40

tab v5017 if state==24
replace ptyagndiraq=1 if ptyid2==3 & state==24
replace ptyagndiraq=0 if ptyid2==2 & state==24
replace ptyagndiraq=0 if ptyid2==1 & state==24

tab v5015 if state==3
replace ptyagndiraq=1 if ptyid2==1 & state==3
replace ptyagndiraq=0 if ptyid2==3 & state==3
replace ptyagndiraq=0 if ptyid2==2 & state==3

tab v5017 if state==19
replace ptyagndiraq=1 if ptyid2==3 & state==19
replace ptyagndiraq=0 if ptyid2==2 & state==19
replace ptyagndiraq=0 if ptyid2==1 & state==19

**********
**Abortion (CHECKED FOR ACCURACY)
**********

tab v5017 if state==30  
gen ptyagdabort=1 if ptyid2==1 & state==30
replace ptyagdabort=0 if ptyid2==2 & state==30
replace ptyagdabort=0 if ptyid2==3 & state==30

tab v5017 if state==16
replace ptyagdabort=1 if ptyid2==3 & state==16
replace ptyagdabort=0 if ptyid2==2 & state==16
replace ptyagdabort=0 if ptyid2==1 & state==16

tab v5017 if state==40
replace ptyagdabort=1 if ptyid2==3 & state==40
replace ptyagdabort=0 if ptyid2==2 & state==40
replace ptyagdabort=0 if ptyid2==1 & state==40

tab v5017 if state==9
replace ptyagdabort=1 if ptyid2==1 & state==9
replace ptyagdabort=0 if ptyid2==3 & state==9
replace ptyagdabort=0 if ptyid2==2 & state==9

tab v5015 if state==34
replace ptyagdabort=1 if ptyid2==1 & state==34
replace ptyagdabort=0 if ptyid2==3 & state==34
replace ptyagdabort=0 if ptyid2==2 & state==34

tab v5015 if state==19
replace ptyagdabort=1 if ptyid2==1 & state==19
replace ptyagdabort=0 if ptyid2==3 & state==19
replace ptyagdabort=0 if ptyid2==2 & state==19

tab v5015 if state==47
replace ptyagdabort=1 if ptyid2==1 & state==47
replace ptyagdabort=0 if ptyid2==3 & state==47
replace ptyagdabort=0 if ptyid2==2 & state==47

tab v5015 if state==50
replace ptyagdabort=1 if ptyid2==1 & state==50
replace ptyagdabort=0 if ptyid2==3 & state==50
replace ptyagdabort=0 if ptyid2==2 & state==50

tab v5015 if state==42
replace ptyagdabort=1 if ptyid2==1 & state==42
replace ptyagdabort=0 if ptyid2==3 & state==42
replace ptyagdabort=0 if ptyid2==2 & state==42

tab v5017 if state==3
replace ptyagdabort=1 if ptyid2==1 & state==3
replace ptyagdabort=0 if ptyid2==3 & state==3
replace ptyagdabort=0 if ptyid2==2 & state==3

tab v5015 if state==3
replace ptyagdabort=1 if ptyid2==1 & state==3
replace ptyagdabort=0 if ptyid2==3 & state==3
replace ptyagdabort=0 if ptyid2==2 & state==3

tab v5015 if state==22
replace ptyagdabort=1 if ptyid2==3 & state==22
replace ptyagdabort=0 if ptyid2==2 & state==22
replace ptyagdabort=0 if ptyid2==1 & state==22

tab v5017 if state==22
replace ptyagdabort=1 if ptyid2==3 & state==22
replace ptyagdabort=0 if ptyid2==2 & state==22
replace ptyagdabort=0 if ptyid2==1 & state==22

tab v5015 if state==29
replace ptyagdabort=1 if ptyid2==1 & state==29
replace ptyagdabort=0 if ptyid2==2 & state==29
replace ptyagdabort=0 if ptyid2==3 & state==29

tab v5017 if state==29
replace ptyagdabort=1 if ptyid2==1 & state==29
replace ptyagdabort=0 if ptyid2==2 & state==29
replace ptyagdabort=0 if ptyid2==3 & state==29



*Non-Deviator 

tab v5015 if state==30  
gen ptyagndabort=1 if ptyid2==3 & state==30
replace ptyagndabort=0 if ptyid2==2 & state==30
replace ptyagndabort=0 if ptyid2==1 & state==30

tab v5015 if state==16
replace ptyagndabort=1 if ptyid2==3 & state==16
replace ptyagndabort=0 if ptyid2==1 & state==16
replace ptyagndabort=0 if ptyid2==2 & state==16

tab v5015 if state==40
replace ptyagndabort=1 if ptyid2==1 & state==40
replace ptyagndabort=0 if ptyid2==2 & state==40
replace ptyagndabort=0 if ptyid2==3 & state==40

tab v5015 if state==9
replace ptyagndabort=1 if ptyid2==1 & state==9
replace ptyagndabort=0 if ptyid2==2 & state==9
replace ptyagndabort=0 if ptyid2==3 & state==9

tab v5017 if state==34
replace ptyagndabort=1 if ptyid2==3 & state==34
replace ptyagndabort=0 if ptyid2==1 & state==34
replace ptyagndabort=0 if ptyid2==2 & state==34

tab v5017 if state==19
replace ptyagndabort=1 if ptyid2==3 & state==19
replace ptyagndabort=0 if ptyid2==1 & state==19
replace ptyagndabort=0 if ptyid2==2 & state==19

tab v5017 if state==47
replace ptyagndabort=0 if ptyid2==1 & state==47
replace ptyagndabort=0 if ptyid2==3 & state==47
replace ptyagndabort=1 if ptyid2==2 & state==47

tab v5017 if state==50
replace ptyagndabort=1 if ptyid2==1 & state==50
replace ptyagndabort=0 if ptyid2==3 & state==50
replace ptyagndabort=0 if ptyid2==2 & state==50

tab v5017 if state==42
replace ptyagndabort=1 if ptyid2==3 & state==42
replace ptyagndabort=0 if ptyid2==2 & state==42
replace ptyagndabort=0 if ptyid2==1 & state==42


**************
**Minimum Wage (CHECKED FOR ACCURACY)
**************

*Deviator

tab v5015 if state==36
gen ptyagdwage=1 if ptyid2==3 & state==36
replace ptyagdwage=0 if ptyid2==2 & state==36
replace ptyagdwage=0 if ptyid2==1 & state==36

tab v5017 if state==40
replace ptyagdwage=1 if ptyid2==3 & state==40
replace ptyagdwage=0 if ptyid2==2 & state==40
replace ptyagdwage=0 if ptyid2==1 & state==40


*Non-Deviator

tab v5017 if state==36
gen ptyagndwage=1 if ptyid2==3 & state==36
replace ptyagndwage=0 if ptyid2==2 & state==36
replace ptyagndwage=0 if ptyid2==1 & state==36

tab v5015 if state==40
replace ptyagndwage=1 if ptyid2==1 & state==40
replace ptyagndwage=0 if ptyid2==2 & state==40
replace ptyagndwage=0 if ptyid2==3 & state==40

***********
**Cap Gains (CHECKED FOR ACCURACY)
***********

*Deviator

tab v5017 if state==30
gen ptyagdcap=1 if ptyid2==1 & state==30
replace ptyagdcap=0 if ptyid2==2 & state==30
replace ptyagdcap=0 if ptyid2==3 & state==30

tab v5017 if state==36
replace ptyagdcap=1 if ptyid2==3 & state==36
replace ptyagdcap=0 if ptyid2==2 & state==36
replace ptyagdcap=0 if ptyid2==1 & state==36

tab v5017 if state==40
replace ptyagdcap=1 if ptyid2==3 & state==40
replace ptyagdcap=0 if ptyid2==2 & state==40
replace ptyagdcap=0 if ptyid2==1 & state==40

tab v5017 if state==3
replace ptyagdcap=1 if ptyid2==1 & state==3
replace ptyagdcap=0 if ptyid2==2 & state==3
replace ptyagdcap=0 if ptyid2==3 & state==3

tab v5015 if state==10
replace ptyagdcap=1 if ptyid2==1 & state==10
replace ptyagdcap=0 if ptyid2==2 & state==10
replace ptyagdcap=0 if ptyid2==3 & state==10

tab v5015 if state==22
replace ptyagdcap=1 if ptyid2==3 & state==22
replace ptyagdcap=0 if ptyid2==2 & state==22
replace ptyagdcap=0 if ptyid2==1 & state==22


*Non-Deviator 

tab v5015 if state==30
gen ptyagndcap=1 if ptyid2==3 & state==30
replace ptyagndcap=0 if ptyid2==2 & state==30
replace ptyagndcap=0 if ptyid2==1 & state==30

tab v5015 if state==36
replace ptyagndcap=1 if ptyid2==3 & state==36
replace ptyagndcap=0 if ptyid2==2 & state==36
replace ptyagndcap=0 if ptyid2==1 & state==36

tab v5015 if state==40
replace ptyagndcap=1 if ptyid2==1 & state==40
replace ptyagndcap=0 if ptyid2==2 & state==40
replace ptyagndcap=0 if ptyid2==3 & state==40

tab v5015 if state==3
replace ptyagndcap=1 if ptyid2==1 & state==3
replace ptyagndcap=0 if ptyid2==2 & state==3
replace ptyagndcap=0 if ptyid2==3 & state==3

tab v5017 if state==10
replace ptyagndcap=1 if ptyid2==3 & state==10
replace ptyagndcap=0 if ptyid2==2 & state==10
replace ptyagndcap=0 if ptyid2==1 & state==10

tab v5017 if state==22
replace ptyagndcap=1 if ptyid2==3 & state==22
replace ptyagndcap=0 if ptyid2==2 & state==22
replace ptyagndcap=0 if ptyid2==1 & state==22


*******
**CAFTA (CHECKED FOR ACCURACY)
*******

*Deviator 

tab v5015 if state==39
gen ptyagdcafta=1 if ptyid2==3 & state==39
replace ptyagdcafta=0 if ptyid2==1 & state==39
replace ptyagdcafta=0 if ptyid2==2 & state==39

tab v5017 if state==30
replace ptyagdcafta=1 if ptyid2==1 & state==30
replace ptyagdcafta=0 if ptyid2==2 & state==30
replace ptyagdcafta=0 if ptyid2==3 & state==30

tab v5015 if state==10
replace ptyagdcafta=1 if ptyid2==1 & state==10
replace ptyagdcafta=0 if ptyid2==2 & state==10
replace ptyagdcafta=0 if ptyid2==3 & state==10

tab v5017 if state==27
replace ptyagdcafta=1 if ptyid2==3 & state==27
replace ptyagdcafta=0 if ptyid2==2 & state==27
replace ptyagdcafta=0 if ptyid2==1 & state==27

tab v5017 if state==19
replace ptyagdcafta=1 if ptyid2==3 & state==19
replace ptyagdcafta=0 if ptyid2==2 & state==19
replace ptyagdcafta=0 if ptyid2==1 & state==19

tab v5015 if state==5
replace ptyagdcafta=1 if ptyid2==1 & state==5
replace ptyagdcafta=0 if ptyid2==2 & state==5
replace ptyagdcafta=0 if ptyid2==3 & state==5

tab v5017 if state==47
replace ptyagdcafta=1 if ptyid2==2 & state==47
replace ptyagdcafta=0 if ptyid2==1 & state==47
replace ptyagdcafta=0 if ptyid2==3 & state==47

tab v5017 if state==33
replace ptyagdcafta=1 if ptyid2==1 & state==33
replace ptyagdcafta=0 if ptyid2==2 & state==33
replace ptyagdcafta=0 if ptyid2==3 & state==33

tab v5017 if state==7
replace ptyagdcafta=1 if ptyid2==1 & state==7
replace ptyagdcafta=0 if ptyid2==2 & state==7
replace ptyagdcafta=0 if ptyid2==3 & state==7

tab v5017 if state==42
replace ptyagdcafta=1 if ptyid2==3 & state==42
replace ptyagdcafta=0 if ptyid2==2 & state==42
replace ptyagdcafta=0 if ptyid2==1 & state==42

tab v5015 if state==41
replace ptyagdcafta=1 if ptyid2==3 & state==41
replace ptyagdcafta=0 if ptyid2==2 & state==41
replace ptyagdcafta=0 if ptyid2==1 & state==41

tab v5015 if state==2
replace ptyagdcafta=1 if ptyid2==3 & state==2
replace ptyagdcafta=0 if ptyid2==2 & state==2
replace ptyagdcafta=0 if ptyid2==1 & state==2

tab v5015 if state==38
replace ptyagdcafta=1 if ptyid2==1 & state==38
replace ptyagdcafta=0 if ptyid2==2 & state==38
replace ptyagdcafta=0 if ptyid2==3 & state==38

tab v5017 if state==9
replace ptyagdcafta=1 if ptyid2==1 & state==9
replace ptyagdcafta=0 if ptyid2==2 & state==9
replace ptyagdcafta=0 if ptyid2==3 & state==9

tab v5017 if state==3
replace ptyagdcafta=1 if ptyid2==1 & state==3
replace ptyagdcafta=0 if ptyid2==2 & state==3
replace ptyagdcafta=0 if ptyid2==3 & state==3

tab v5015 if state==14
replace ptyagdcafta=1 if ptyid2==3 & state==14
replace ptyagdcafta=0 if ptyid2==2 & state==14
replace ptyagdcafta=0 if ptyid2==1 & state==14

tab v5017 if state==14
replace ptyagdcafta=1 if ptyid2==3 & state==14
replace ptyagdcafta=0 if ptyid2==2 & state==14
replace ptyagdcafta=0 if ptyid2==1 & state==14

tab v5015 if state==22
replace ptyagdcafta=1 if ptyid2==3 & state==22
replace ptyagdcafta=0 if ptyid2==2 & state==22
replace ptyagdcafta=0 if ptyid2==1 & state==22

tab v5017 if state==22
replace ptyagdcafta=1 if ptyid2==3 & state==22
replace ptyagdcafta=0 if ptyid2==2 & state==22
replace ptyagdcafta=0 if ptyid2==1 & state==22

tab v5015 if state==48
replace ptyagdcafta=1 if ptyid2==1 & state==48
replace ptyagdcafta=0 if ptyid2==2 & state==48
replace ptyagdcafta=0 if ptyid2==3 & state==48

tab v5017 if state==48
replace ptyagdcafta=1 if ptyid2==1 & state==48
replace ptyagdcafta=0 if ptyid2==2 & state==48
replace ptyagdcafta=0 if ptyid2==3 & state==48

tab v5015 if state==51
replace ptyagdcafta=1 if ptyid2==3 & state==51
replace ptyagdcafta=0 if ptyid2==2 & state==51
replace ptyagdcafta=0 if ptyid2==1 & state==51

tab v5017 if state==51
replace ptyagdcafta=1 if ptyid2==3 & state==51
replace ptyagdcafta=0 if ptyid2==2 & state==51
replace ptyagdcafta=0 if ptyid2==1 & state==51


*Non-Deviator

tab v5017 if state==39
gen ptyagndcafta=1 if ptyid2==3 & state==39
replace ptyagndcafta=0 if ptyid2==1 & state==39
replace ptyagndcafta=0 if ptyid2==2 & state==39

tab v5015 if state==30
replace ptyagndcafta=1 if ptyid2==3 & state==30
replace ptyagndcafta=0 if ptyid2==1 & state==30
replace ptyagndcafta=0 if ptyid2==2 & state==30

tab v5017 if state==10
replace ptyagndcafta=1 if ptyid2==3 & state==10
replace ptyagndcafta=0 if ptyid2==1 & state==10
replace ptyagndcafta=0 if ptyid2==2 & state==10

tab v5015 if state==27
replace ptyagndcafta=1 if ptyid2==1 & state==27
replace ptyagndcafta=0 if ptyid2==2 & state==27
replace ptyagndcafta=0 if ptyid2==3 & state==27

tab v5015 if state==19
replace ptyagndcafta=1 if ptyid2==1 & state==19
replace ptyagndcafta=0 if ptyid2==2 & state==19
replace ptyagndcafta=0 if ptyid2==3 & state==19

tab v5017 if state==5
replace ptyagndcafta=1 if ptyid2==1 & state==5
replace ptyagndcafta=0 if ptyid2==2 & state==5
replace ptyagndcafta=0 if ptyid2==3 & state==5

tab v5015 if state==47
replace ptyagndcafta=1 if ptyid2==1 & state==47
replace ptyagndcafta=0 if ptyid2==2 & state==47
replace ptyagndcafta=0 if ptyid2==3 & state==47

tab v5015 if state==33
replace ptyagndcafta=1 if ptyid2==3 & state==33
replace ptyagndcafta=0 if ptyid2==2 & state==33
replace ptyagndcafta=0 if ptyid2==1 & state==33

tab v5015 if state==7
replace ptyagndcafta=1 if ptyid2==1 & state==7
replace ptyagndcafta=0 if ptyid2==2 & state==7
replace ptyagndcafta=0 if ptyid2==3 & state==7

tab v5015 if state==42
replace ptyagndcafta=1 if ptyid2==1 & state==42
replace ptyagndcafta=0 if ptyid2==2 & state==42
replace ptyagndcafta=0 if ptyid2==3 & state==42

tab v5017 if state==41
replace ptyagndcafta=1 if ptyid2==3 & state==41
replace ptyagndcafta=0 if ptyid2==2 & state==41
replace ptyagndcafta=0 if ptyid2==1 & state==41

tab v5017 if state==2
replace ptyagndcafta=1 if ptyid2==3 & state==2
replace ptyagndcafta=0 if ptyid2==2 & state==2
replace ptyagndcafta=0 if ptyid2==1 & state==2

tab v5017 if state==38
replace ptyagndcafta=1 if ptyid2==3 & state==38
replace ptyagndcafta=0 if ptyid2==2 & state==38
replace ptyagndcafta=0 if ptyid2==1 & state==38

tab v5015 if state==9
replace ptyagndcafta=1 if ptyid2==1 & state==9
replace ptyagndcafta=0 if ptyid2==2 & state==9
replace ptyagndcafta=0 if ptyid2==3 & state==9

***********
**Stem Cell (CHECKED FOR ACCURACY) 
***********

tab v5015 if state==39
gen ptyagdstem=1 if ptyid2==3 & state==39
replace ptyagdstem=0 if ptyid2==1 & state==39
replace ptyagdstem=0 if ptyid2==2 & state==39

tab v5017 if state==30
replace ptyagdstem=1 if ptyid2==1 & state==30
replace ptyagdstem=0 if ptyid2==2 & state==30
replace ptyagdstem=0 if ptyid2==3 & state==30

tab v5017 if state==38
replace ptyagdstem=1 if ptyid2==1 & state==38
replace ptyagdstem=0 if ptyid2==2 & state==38
replace ptyagdstem=0 if ptyid2==3 & state==38

tab v5015 if state==4
replace ptyagdstem=1 if ptyid2==3 & state==4
replace ptyagdstem=0 if ptyid2==2 & state==4
replace ptyagdstem=0 if ptyid2==1 & state==4

tab v5015 if state==46
replace ptyagdstem=1 if ptyid2==3 & state==46
replace ptyagdstem=0 if ptyid2==2 & state==46
replace ptyagdstem=0 if ptyid2==1 & state==46

tab v5015 if state==31
replace ptyagdstem=1 if ptyid2==3 & state==31
replace ptyagdstem=0 if ptyid2==2 & state==31
replace ptyagdstem=0 if ptyid2==1 & state==31

tab v5015 if state==44
replace ptyagdstem=1 if ptyid2==3 & state==44
replace ptyagdstem=0 if ptyid2==2 & state==44
replace ptyagdstem=0 if ptyid2==1 & state==44

tab v5017 if state==40
replace ptyagdstem=1 if ptyid2==3 & state==40
replace ptyagdstem=0 if ptyid2==2 & state==40
replace ptyagdstem=0 if ptyid2==1 & state==40

tab v5017 if state==28
replace ptyagdstem=1 if ptyid2==3 & state==28
replace ptyagdstem=0 if ptyid2==2 & state==28
replace ptyagdstem=0 if ptyid2==1 & state==28

tab v5015 if state==16
replace ptyagdstem=1 if ptyid2==3 & state==16
replace ptyagdstem=0 if ptyid2==2 & state==16
replace ptyagdstem=0 if ptyid2==1 & state==16

tab v5015 if state==1
replace ptyagdstem=1 if ptyid2==3 & state==1
replace ptyagdstem=0 if ptyid2==2 & state==1
replace ptyagdstem=0 if ptyid2==1 & state==1

tab v5017 if state==1
replace ptyagdstem=1 if ptyid2==3 & state==1
replace ptyagdstem=0 if ptyid2==2 & state==1
replace ptyagdstem=0 if ptyid2==1 & state==1

tab v5015 if state==22
replace ptyagdstem=1 if ptyid2==3 & state==22
replace ptyagdstem=0 if ptyid2==2 & state==22
replace ptyagdstem=0 if ptyid2==1 & state==22

tab v5017 if state==22
replace ptyagdstem=1 if ptyid2==3 & state==22
replace ptyagdstem=0 if ptyid2==2 & state==22
replace ptyagdstem=0 if ptyid2==1 & state==22

tab v5017 if state==26
replace ptyagdstem=1 if ptyid2==3 & state==26
replace ptyagdstem=0 if ptyid2==2 & state==26
replace ptyagdstem=0 if ptyid2==1 & state==26

tab v5015 if state==26
replace ptyagdstem=1 if ptyid2==3 & state==26
replace ptyagdstem=0 if ptyid2==2 & state==26
replace ptyagdstem=0 if ptyid2==1 & state==26

tab v5015 if state==43
replace ptyagdstem=1 if ptyid2==3 & state==43
replace ptyagdstem=0 if ptyid2==1 & state==43
replace ptyagdstem=0 if ptyid2==2 & state==43

tab v5017 if state==43
replace ptyagdstem=1 if ptyid2==3 & state==43
replace ptyagdstem=0 if ptyid2==2 & state==43
replace ptyagdstem=0 if ptyid2==1 & state==43

tab v5017 if state==45
replace ptyagdstem=1 if ptyid2==3 & state==45
replace ptyagdstem=0 if ptyid2==2 & state==45
replace ptyagdstem=0 if ptyid2==1 & state==45

tab v5015 if state==45
replace ptyagdstem=1 if ptyid2==3 & state==45
replace ptyagdstem=0 if ptyid2==2 & state==45
replace ptyagdstem=0 if ptyid2==1 & state==45

*Non-Deviator

tab v5017 if state==39
gen ptyagndstem=1 if ptyid2==3 & state==39
replace ptyagndstem=0 if ptyid2==1 & state==39
replace ptyagndstem=0 if ptyid2==2 & state==39

tab v5015 if state==30
replace ptyagndstem=1 if ptyid2==3 & state==30
replace ptyagndstem=0 if ptyid2==1 & state==30
replace ptyagndstem=0 if ptyid2==2 & state==30

tab v5015 if state==38
replace ptyagndstem=1 if ptyid2==1 & state==38
replace ptyagndstem=0 if ptyid2==2 & state==38
replace ptyagndstem=0 if ptyid2==3 & state==38

tab v5017 if state==4
replace ptyagndstem=1 if ptyid2==3 & state==4
replace ptyagndstem=0 if ptyid2==2 & state==4
replace ptyagndstem=0 if ptyid2==1 & state==4

tab v5017 if state==46
replace ptyagndstem=1 if ptyid2==3 & state==46
replace ptyagndstem=0 if ptyid2==2 & state==46
replace ptyagndstem=0 if ptyid2==1 & state==46

tab v5017 if state==31
replace ptyagndstem=1 if ptyid2==3 & state==31
replace ptyagndstem=0 if ptyid2==2 & state==31
replace ptyagndstem=0 if ptyid2==1 & state==31

tab v5017 if state==44
replace ptyagndstem=1 if ptyid2==3 & state==44
replace ptyagndstem=0 if ptyid2==2 & state==44
replace ptyagndstem=0 if ptyid2==1 & state==44

tab v5015 if state==40
replace ptyagndstem=1 if ptyid2==1 & state==40
replace ptyagndstem=0 if ptyid2==2 & state==40
replace ptyagndstem=0 if ptyid2==3 & state==40

tab v5015 if state==28
replace ptyagndstem=1 if ptyid2==3 & state==28
replace ptyagndstem=0 if ptyid2==2 & state==28
replace ptyagndstem=0 if ptyid2==1 & state==28

tab v5017 if state==16
replace ptyagndstem=1 if ptyid2==1 & state==16
replace ptyagndstem=0 if ptyid2==2 & state==16
replace ptyagndstem=0 if ptyid2==3 & state==16


****************
*****Immigration (CHECKED FOR ACCURACY) 
****************

tab v5015 if state==39
gen ptyid2agdimm=1 if ptyid2==3 & state==39
replace ptyid2agdimm=0 if ptyid2==2 & state==39
replace ptyid2agdimm=0 if ptyid2==1 & state==39

tab v5015 if state==43
replace ptyid2agdimm=1 if ptyid2==3 & state==43
replace ptyid2agdimm=0 if ptyid2==2 & state==43
replace ptyid2agdimm=0 if ptyid2==1 & state==43

tab v5017 if state==29
replace ptyid2agdimm=1 if ptyid2==1 & state==29
replace ptyid2agdimm=0 if ptyid2==2 & state==29
replace ptyid2agdimm=0 if ptyid2==3 & state==29

tab v5017 if state==23
replace ptyid2agdimm=1 if ptyid2==1 & state==23
replace ptyid2agdimm=0 if ptyid2==2 & state==23
replace ptyid2agdimm=0 if ptyid2==3 & state==23


tab v5017 if state==38
replace ptyid2agdimm=1 if ptyid2==1 & state==38
replace ptyid2agdimm=0 if ptyid2==2 & state==38
replace ptyid2agdimm=0 if ptyid2==3 & state==38

tab v5015 if state==4
replace ptyid2agdimm=1 if ptyid2==3 & state==4
replace ptyid2agdimm=0 if ptyid2==2 & state==4
replace ptyid2agdimm=0 if ptyid2==1 & state==4

tab v5015 if state==46
replace ptyid2agdimm=1 if ptyid2==3 & state==46
replace ptyid2agdimm=0 if ptyid2==2 & state==46
replace ptyid2agdimm=0 if ptyid2==1 & state==46

tab v5015 if state==31
replace ptyid2agdimm=1 if ptyid2==3 & state==31
replace ptyid2agdimm=0 if ptyid2==2 & state==31
replace ptyid2agdimm=0 if ptyid2==1 & state==31

tab v5015 if state==14
replace ptyid2agdimm=1 if ptyid2==3 & state==14
replace ptyid2agdimm=0 if ptyid2==2 & state==14
replace ptyid2agdimm=0 if ptyid2==1 & state==14

tab v5017 if state==40
replace ptyid2agdimm=1 if ptyid2==3 & state==40
replace ptyid2agdimm=0 if ptyid2==2 & state==40
replace ptyid2agdimm=0 if ptyid2==1 & state==40

tab v5015 if state==41
replace ptyid2agdimm=1 if ptyid2==3 & state==41
replace ptyid2agdimm=0 if ptyid2==2 & state==41
replace ptyid2agdimm=0 if ptyid2==1 & state==41

tab v5017 if state==10
replace ptyid2agdimm=1 if ptyid2==3 & state==10
replace ptyid2agdimm=0 if ptyid2==2 & state==10
replace ptyid2agdimm=0 if ptyid2==1 & state==10

tab v5017 if state==24
replace ptyid2agdimm=1 if ptyid2==3 & state==24
replace ptyid2agdimm=0 if ptyid2==2 & state==24
replace ptyid2agdimm=0 if ptyid2==1 & state==24

tab v5015 if state==33
replace ptyid2agdimm=1 if ptyid2==3 & state==33
replace ptyid2agdimm=0 if ptyid2==2 & state==33
replace ptyid2agdimm=0 if ptyid2==1 & state==33

tab v5015 if state==16
replace ptyid2agdimm=1 if ptyid2==3 & state==16
replace ptyid2agdimm=0 if ptyid2==2 & state==16
replace ptyid2agdimm=0 if ptyid2==1 & state==16

tab v5017 if state==45
replace ptyid2agdimm=1 if ptyid2==3 & state==45
replace ptyid2agdimm=0 if ptyid2==2 & state==45
replace ptyid2agdimm=0 if ptyid2==1 & state==45

tab v5015 if state==50
replace ptyid2agdimm=1 if ptyid2==1 & state==50
replace ptyid2agdimm=0 if ptyid2==2 & state==50
replace ptyid2agdimm=0 if ptyid2==3 & state==50

tab v5015 if state==17
replace ptyid2agdimm=1 if ptyid2==3 & state==17
replace ptyid2agdimm=0 if ptyid2==2 & state==17
replace ptyid2agdimm=0 if ptyid2==1 & state==17

tab v5015 if state==18
replace ptyid2agdimm=1 if ptyid2==3 & state==18
replace ptyid2agdimm=0 if ptyid2==2 & state==18
replace ptyid2agdimm=0 if ptyid2==1 & state==18

tab v5017 if state==1
replace ptyid2agdimm=1 if ptyid2==3 & state==1
replace ptyid2agdimm=0 if ptyid2==2 & state==1
replace ptyid2agdimm=0 if ptyid2==1 & state==1

tab v5015 if state==1
replace ptyid2agdimm=1 if ptyid2==3 & state==1
replace ptyid2agdimm=0 if ptyid2==2 & state==1
replace ptyid2agdimm=0 if ptyid2==1 & state==1

tab v5017 if state==22
replace ptyid2agdimm=1 if ptyid2==3 & state==22
replace ptyid2agdimm=0 if ptyid2==1 & state==22
replace ptyid2agdimm=0 if ptyid2==2 & state==22

tab v5015 if state==22
replace ptyid2agdimm=1 if ptyid2==3 & state==22
replace ptyid2agdimm=0 if ptyid2==2 & state==22
replace ptyid2agdimm=0 if ptyid2==1 & state==22

tab v5017 if state==30
replace ptyid2agdimm=1 if ptyid2==1 & state==30
replace ptyid2agdimm=0 if ptyid2==2 & state==30
replace ptyid2agdimm=0 if ptyid2==3 & state==30

tab v5015 if state==30
replace ptyid2agdimm=1 if ptyid2==3 & state==30
replace ptyid2agdimm=0 if ptyid2==2 & state==30
replace ptyid2agdimm=0 if ptyid2==1 & state==30

tab v5015 if state==36
replace ptyid2agdimm=1 if ptyid2==3 & state==36
replace ptyid2agdimm=0 if ptyid2==2 & state==36
replace ptyid2agdimm=0 if ptyid2==1 & state==36

tab v5017 if state==36
replace ptyid2agdimm=1 if ptyid2==3 & state==36
replace ptyid2agdimm=0 if ptyid2==2 & state==36
replace ptyid2agdimm=0 if ptyid2==1 & state==36


*Non-Deviators

tab v5017 if state==39
gen ptyid2atndimm=1 if ptyid2==3 & state==39
replace ptyid2atndimm=0 if ptyid2==2 & state==39
replace ptyid2atndimm=0 if ptyid2==1 & state==39

tab v5017 if state==43
replace ptyid2atndimm=1 if ptyid2==3 & state==43
replace ptyid2atndimm=0 if ptyid2==2 & state==43
replace ptyid2atndimm=0 if ptyid2==1 & state==43

tab v5015 if state==29
replace ptyid2atndimm=1 if ptyid2==1 & state==29
replace ptyid2atndimm=0 if ptyid2==2 & state==29
replace ptyid2atndimm=0 if ptyid2==3 & state==29

tab v5015 if state==23
replace ptyid2atndimm=1 if ptyid2==1 & state==23
replace ptyid2atndimm=0 if ptyid2==2 & state==23
replace ptyid2atndimm=0 if ptyid2==3 & state==23

tab v5015 if state==38
replace ptyid2atndimm=1 if ptyid2==1 & state==38
replace ptyid2atndimm=0 if ptyid2==2 & state==38
replace ptyid2atndimm=0 if ptyid2==3 & state==38

tab v5017 if state==4
replace ptyid2atndimm=1 if ptyid2==3 & state==4
replace ptyid2atndimm=0 if ptyid2==2 & state==4
replace ptyid2atndimm=0 if ptyid2==1 & state==4

tab v5017 if state==46
replace ptyid2atndimm=1 if ptyid2==3 & state==46
replace ptyid2atndimm=0 if ptyid2==2 & state==46
replace ptyid2atndimm=0 if ptyid2==1 & state==46

tab v5017 if state==31
replace ptyid2atndimm=1 if ptyid2==3 & state==31
replace ptyid2atndimm=0 if ptyid2==2 & state==31
replace ptyid2atndimm=0 if ptyid2==1 & state==31

tab v5017 if state==14
replace ptyid2atndimm=1 if ptyid2==3 & state==14
replace ptyid2atndimm=0 if ptyid2==2 & state==14
replace ptyid2atndimm=0 if ptyid2==1 & state==14

tab v5015 if state==40
replace ptyid2atndimm=1 if ptyid2==3 & state==40
replace ptyid2atndimm=0 if ptyid2==2 & state==40
replace ptyid2atndimm=0 if ptyid2==1 & state==40

tab v5017 if state==41
replace ptyid2atndimm=1 if ptyid2==3 & state==41
replace ptyid2atndimm=0 if ptyid2==2 & state==41
replace ptyid2atndimm=0 if ptyid2==1 & state==41

tab v5015 if state==24
replace ptyid2atndimm=1 if ptyid2==1 & state==24
replace ptyid2atndimm=0 if ptyid2==2 & state==24
replace ptyid2atndimm=0 if ptyid2==3 & state==24

tab v5017 if state==33
replace ptyid2atndimm=1 if ptyid2==3 & state==33
replace ptyid2atndimm=0 if ptyid2==2 & state==33
replace ptyid2atndimm=0 if ptyid2==1 & state==33

tab v5017 if state==16
replace ptyid2atndimm=1 if ptyid2==1 & state==16
replace ptyid2atndimm=0 if ptyid2==2 & state==16
replace ptyid2atndimm=0 if ptyid2==3 & state==16

tab v5015 if state==45
replace ptyid2atndimm=1 if ptyid2==3 & state==45
replace ptyid2atndimm=0 if ptyid2==2 & state==45
replace ptyid2atndimm=0 if ptyid2==1 & state==45

tab v5017 if state==50
replace ptyid2atndimm=1 if ptyid2==1 & state==50
replace ptyid2atndimm=0 if ptyid2==2 & state==50
replace ptyid2atndimm=0 if ptyid2==3 & state==50

tab v5017 if state==17
replace ptyid2atndimm=1 if ptyid2==3 & state==17
replace ptyid2atndimm=0 if ptyid2==2 & state==17
replace ptyid2atndimm=0 if ptyid2==1 & state==17

tab v5017 if state==18
replace ptyid2atndimm=1 if ptyid2==3 & state==18
replace ptyid2atndimm=0 if ptyid2==2 & state==18
replace ptyid2atndimm=0 if ptyid2==1 & state==18

tab v5015 if state==10
replace ptyid2atndimm=1 if ptyid2==1 & state==10
replace ptyid2atndimm=0 if ptyid2==2 & state==10
replace ptyid2atndimm=0 if ptyid2==3 & state==10

***
*Awareness measure
****

gen knhouse=1 if v3018==1 & v5014==1
replace knhouse=1 if v3018==2 & v5014==2
replace knhouse=0 if v3018==2 & v5014==1
replace knhouse=0 if v3018==1 & v5014==2
replace knhouse=1 if v3018==3 & v5014==4
replace knhouse=0 if v3018==3 & v5014==1
replace knhouse=0 if v3018==3 & v5014==2
replace knhouse=0 if v3018==4


**Gov

gen kngov=1 if v3012==1 & v5020==1
replace kngov=1 if v3012==2 & v5020==2
replace kngov=0 if v3012==2 & v5020==1
replace kngov=0 if v3012==1 & v5020==2
replace kngov=0 if v3012==4

label define kngov 0 "Incorrect" 1 "Correct"
label value kngov kngov

**Senator 1 

tab v5016
tab v5016, nolab
tab v3014
tab v3014, nolab

gen knowptysen1b = 1 if v5016==1 & v3014==1
replace knowptysen1b=1 if v5016==2 & v3014==2
replace knowptysen1b=0 if v5016==2 & v3014==1
replace knowptysen1b=0 if v5016==1 & v3014==2
replace knowptysen1b=0 if v3014==3
replace knowptysen1b=0 if v3014==4
tab knowptysen1b

**Senator 2

tab v5018
tab v5018, nolab
tab v3016
tab v3016,nolab

gen knowptysen2b = 1 if v5018==1 & v3016==1
replace knowptysen2b=1 if v5018==2 & v3016==2
replace knowptysen2b=1 if v5018==3 & v3016==3
replace knowptysen2b=0 if v5018==2 & v3016==1
replace knowptysen2b=0 if v5018==1 & v3016==2
replace knowptysen2b=0 if v5018==1 & v3016==3
replace knowptysen2b=0 if v5018==2 & v3016==3
replace knowptysen2b=0 if v5018==3 & v3016==1
replace knowptysen2b=0 if v5018==3 & v3016==2
replace knowptysen2b=0 if v3016==4
tab knowptysen2

gen knowall=knowptysen1+knowptysen2+knhouse+kngov


***Dropping Variables 

drop  v2007-v2017
drop  v2033 v2034 v2038 v2039 v2040 v2041 v2043 v2044 v2045 v2050 v2051 v2052 v2053 v2054 v2055 v2056 v2057 v2058 v2059 v2060 v2061 v2062 v2066 v2065 v2064
drop  v2063 v2067 v2068 v2069 v2070 v2071 v2072 v2073 v2074 v2075 v2076 v2077 v2078 v2079 v2080 v2081 v2082 v2083 v2084 v2085 v2091 v2092 v2093 v2094 v2095 v2096 v2097 v2100 v2101 v2106 v2107 v2108 v2109 v2110 v2111 v2114 v2115 v2116 v2117 v2118 v2119 v2120 v2121 v2122 v2123 v2124 v2125 v2127 v2128 v2126 v2129 v2134 v2133 v2132
drop v3001-	v4071
drop v2022-v2135

