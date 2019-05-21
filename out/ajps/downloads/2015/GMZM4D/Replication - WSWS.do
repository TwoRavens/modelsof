*Author:	Geoff Sheagley and Logan Dancey

*Date:		6/24/2012

*Input:		Dataset formatted for main paper replication 

*Output:	Models for the WSWS Analysis reported in table A6 in the SI. Also reproduces figure A1 in SI. 


**Step 1 - Code Senator Deviation 

/*Abortion Deviators*/
gen dabortsen1=0
replace dabortsen1=1 if state==3
replace dabortsen1=1 if state==19
replace dabortsen1=1 if state==22
replace dabortsen1=1 if state==29
replace dabortsen1=1 if state==34
replace dabortsen1=1 if state==42
replace dabortsen1=1 if state==47
replace dabortsen1=1 if state==50

gen dabortsen2=0
replace dabortsen2=1 if state==3
replace dabortsen2=1 if state==9
replace dabortsen2=1 if state==16
replace dabortsen2=1 if state==22
replace dabortsen2=1 if state==29
replace dabortsen2=1 if state==30
replace dabortsen2=1 if state==40

/*Capital Gains Deviators*/
gen dcapsen1=0
replace dcapsen1=1 if state==10
replace dcapsen1=1 if state==22

gen dcapsen2=0
replace dcapsen2=1 if state==3
replace dcapsen2=1 if state==30
replace dcapsen2=1 if state==36
replace dcapsen2=1 if state==40

/*CAFTA Deviators*/
gen dcaftasen1=0
replace dcaftasen1=1 if state==2
replace dcaftasen1=1 if state==3
replace dcaftasen1=1 if state==5
replace dcaftasen1=1 if state==10
replace dcaftasen1=1 if state==14
replace dcaftasen1=1 if state==22
replace dcaftasen1=1 if state==38
replace dcaftasen1=1 if state==39
replace dcaftasen1=1 if state==41
replace dcaftasen1=1 if state==48
replace dcaftasen1=1 if state==51

gen dcaftasen2=0
replace dcaftasen2=1 if state==3
replace dcaftasen2=1 if state==9
replace dcaftasen2=1 if state==14
replace dcaftasen2=1 if state==19
replace dcaftasen2=1 if state==22
replace dcaftasen2=1 if state==27
replace dcaftasen2=1 if state==30
replace dcaftasen2=1 if state==33
replace dcaftasen2=1 if state==42
replace dcaftasen2=1 if state==47
replace dcaftasen2=1 if state==48
replace dcaftasen2=1 if state==51

/*Stem Cell*/
gen dstemsen1=0
replace dstemsen1=1 if state==1
replace dstemsen1=1 if state==4
replace dstemsen1=1 if state==16
replace dstemsen1=1 if state==22
replace dstemsen1=1 if state==26
replace dstemsen1=1 if state==31
replace dstemsen1=1 if state==39
replace dstemsen1=1 if state==43
replace dstemsen1=1 if state==44
replace dstemsen1=1 if state==45
replace dstemsen1=1 if state==46

gen dstemsen2=0
replace dstemsen2=1 if state==1
replace dstemsen2=1 if state==22
replace dstemsen2=1 if state==26
replace dstemsen2=1 if state==28
replace dstemsen2=1 if state==30
replace dstemsen2=1 if state==38
replace dstemsen2=1 if state==40
replace dstemsen2=1 if state==43
replace dstemsen2=1 if state==45

/*Iraq*/
gen diraqsen1=0
replace diraqsen1=1 if state==10
replace diraqsen1=1 if state==19
replace diraqsen1=1 if state==24

gen diraqsen2=0
replace diraqsen2=1 if state==3
replace diraqsen2=1 if state==7
replace diraqsen2=1 if state==30
replace diraqsen2=1 if state==40

/*Immigration*/
gen dimmsen1=0
replace dimmsen1=1 if state==1
replace dimmsen1=1 if state==4
replace dimmsen1=1 if state==14
replace dimmsen1=1 if state==16
replace dimmsen1=1 if state==17
replace dimmsen1=1 if state==18
replace dimmsen1=1 if state==22
replace dimmsen1=1 if state==30
replace dimmsen1=1 if state==31
replace dimmsen1=1 if state==33
replace dimmsen1=1 if state==36
replace dimmsen1=1 if state==39
replace dimmsen1=1 if state==43
replace dimmsen1=1 if state==46
replace dimmsen1=1 if state==50

gen dimmsen2=0 
replace dimmsen2=1 if state==1
replace dimmsen2=1 if state==10
replace dimmsen2=1 if state==22
replace dimmsen2=1 if state==23
replace dimmsen2=1 if state==24
replace dimmsen2=1 if state==29
replace dimmsen2=1 if state==30
replace dimmsen2=1 if state==36
replace dimmsen2=1 if state==38
replace dimmsen2=1 if state==40
replace dimmsen2=1 if state==45


/*Minimum Wage*/
gen dminsen1=0
replace dminsen1=1 if state==36
replace dminsen1=1 if state==39

gen dminsen2=0
replace dminsen2=1 if state==39
replace dminsen2=1 if state==40


**Create the binary knowledge measures. 

gen knowabortsen1b=knowabortsen1
replace knowabortsen1b=0 if knowabortsen1==2

gen knowabortsen2b=knowabortsen2
replace knowabortsen2b=0 if knowabortsen2==2

gen knowstemsen1b=knowstemsen1
replace knowstemsen1b=0 if knowstemsen1==2

gen knowstemsen2b=knowstemsen2
replace knowstemsen2b=0 if knowstemsen2==2

gen knowcaftasen1b=knowcaftasen1
replace knowcaftasen1b=0 if knowcaftasen1==2

gen knowcaftasen2b=knowcaftasen2
replace knowcaftasen2b=0 if knowcaftasen2==2

gen knowimmsen1b=knowimmigratesen1
replace knowimmsen1b=0 if knowimmigratesen1==2

gen knowimmsen2b=knowimmigratesen2
replace knowimmsen2b=0 if knowimmigratesen2==2

gen knowiraqsen1b=knowiraqsen1
replace knowiraqsen1b=0 if knowiraqsen1==2

gen knowiraqsen2b=knowiraqsen2
replace knowiraqsen2b=0 if knowiraqsen2==2

gen knowcapsen1b=knowcapgainsen1
replace knowcapsen1b=0 if knowcapgainsen1==2

gen knowcapsen2b=knowcapgainsen2
replace knowcapsen2b=0 if knowcapgainsen2==2

gen knowminsen1b=knowminwagesen1
replace knowminsen1b=0 if knowminwagesen1==2

gen knowminsen2b=knowminwagesen2
replace knowminsen2b=0 if knowminwagesen2==2

*Generate knowledge difference variables for all seven votes. 

gen knowabortdiff=knowabortsen1b-knowabortsen2b
gen knowiraqdiff=knowiraqsen1b-knowiraqsen2b
gen knowimmdiff=knowimmsen1b-knowimmsen2b
gen knowmindiff=knowminsen1b-knowminsen2b
gen knowcaftadiff=knowcaftasen1b-knowcaftasen2b
gen knowstemdiff=knowstemsen1b-knowstemsen2b
gen knowcapdiff=knowcapsen1b-knowcapsen2b

*Interact interest with the deviation variables 

gen intdabort1=interest*dabortsen1
gen intdabort2=interest*dabortsen2

gen intdiraq1=interest*diraqsen1
gen intdiraq2=interest*diraqsen2

gen intdimm1=interest*dimmsen1
gen intdimm2=interest*dimmsen2

gen intdmin1=interest*dminsen1
gen intdmin2=interest*dminsen2

gen intdcafta1=interest*dcaftasen1
gen intdcafta2=interest*dcaftasen2

gen intdstem1=interest*dstemsen1
gen intdstem2=interest*dstemsen2

gen intdcap1=interest*dcapsen1
gen intdcap2=interest*dcapsen2


**Step 2 - Code Party Agreement 

*Abortion 

tab ptyid2

tab v5018
tab v5016

gen ptyagreesen1=.

replace ptyagreesen1 = 1 if ptyid2==1 & v5016==1
replace ptyagreesen1 = 1 if ptyid2==3 & v5016==2

replace ptyagreesen1 = 0 if ptyid2==1 & v5016==2
replace ptyagreesen1 = 0 if ptyid2==3 & v5016==1
replace ptyagreesen1 = 0 if ptyid2==2

tab ptyagreesen1

gen ptyagreesen2=.

replace ptyagreesen2 = 1 if ptyid2==1 & v5018==1
replace ptyagreesen2 = 1 if ptyid2==3 & v5018==2

replace ptyagreesen2 = 0 if ptyid2==1 & v5018==2
replace ptyagreesen2 = 0 if ptyid2==3 & v5018==1
replace ptyagreesen2 = 0 if ptyid2==2
replace ptyagreesen2 = 0 if v5018==3

tab ptyagreesen2

tab ptyagreesen1 ptyagreesen2

**Step 3 - Models for table  A6. 

*Abortion 

ologit knowabortdiff dabortsen1 dabortsen2 interest intdabort1 intdabort2 ///
educ age woman income pidstrength ptyagreesen1 ptyagreesen2 white [pw=v1001] if v5022 !=3 & v5022 !=4 & v5023 !=3 & v5023 !=4, cluster(state)



forvalues count = 1/3 {
prvalue, x(interest=`count' dabortsen1=1 intdabort1=`count' dabortsen2=0 intdabort2=0) rest(median)
}

forvalues count = 1/3 {
prvalue, x(interest=`count' dabortsen1=0 intdabort1=0 dabortsen2=1 intdabort2=`count') rest(median)
}

*Iraq

ologit knowiraqdiff diraqsen1 diraqsen2 interest intdiraq1 intdiraq2 ///
educ age woman income pidstrength ptyagreesen1 ptyagreesen2 white [pw=v1001] if v5027 != 3 , cluster(state)


forvalues count = 1/3 {
prvalue, x(interest=`count' diraqsen1=1 intdiraq1=`count' diraqsen2=0 intdiraq2=0) rest(median)
}

forvalues count = 1/3 {
prvalue, x(interest=`count' diraqsen1=0 intdiraq1=0 diraqsen2=1 intdiraq2=`count') rest(median)
}



*CAFTA

ologit knowcaftadiff dcaftasen1 dcaftasen2 interest intdcafta1 intdcafta2 ///
educ age woman income pidstrength ptyagreesen1 ptyagreesen2 white [pw=v1001] if v5034 !=3 & v5035!=3, cluster(state)

forvalues count = 1/3 {
prvalue, x(interest=`count' dcaftasen1=1 intdcafta1=`count' dcaftasen2=0 intdcafta2=0) rest(median)
}

forvalues count = 1/3 {
prvalue, x(interest=`count' dcaftasen1=0 intdcafta1=0 dcaftasen2=1 intdcafta2=`count') rest(median)
}


*Immigration 

ologit knowimmdiff dimmsen1 dimmsen2 interest intdimm1 intdimm2 ///
educ age woman income pidstrength ptyagreesen1 ptyagreesen2 white [pw=v1001] if v5029 !=3, cluster(state)


forvalues count = 1/3 {
prvalue, x(interest=`count' dimmsen1=1 intdimm1=`count' dimmsen2=0 intdimm2=0) rest(median)
}

forvalues count = 1/3 {
prvalue, x(interest=`count' dimmsen1=0 intdimm1=0 dimmsen2=1 intdimm2=`count') rest(median)
}


*Cap Gains

ologit knowcapdiff dcapsen1 dcapsen2 interest intdcap1 intdcap2 ///
educ age woman income pidstrength ptyagreesen1 ptyagreesen2 white [pw=v1001] if v5032 != 3 & v5033 != 3, cluster(state)

forvalues count = 1/3 {
prvalue, x(interest=`count' dcapsen1=1 intdcap1=`count' dcapsen2=0 intdcap2=0) rest(median)
}

forvalues count = 1/3 {
prvalue, x(interest=`count' dcapsen1=0 intdcap1=0 dcapsen2=1 intdcap2=`count') rest(median)
}


*Min Wage 

ologit knowmindiff dminsen1 dminsen2 interest intdmin1 intdmin2 ///
educ age woman income pidstrength ptyagreesen1 ptyagreesen2 white [pw=v1001], cluster(state)


forvalues count = 1/3 {
prvalue, x(interest=`count' dminsen1=1 intdmin1=`count' dminsen2=0 intdmin2=0) rest(median)
}

forvalues count = 1/3 {
prvalue, x(interest=`count' dminsen1=0 intdmin1=0 dminsen2=1 intdmin2=`count') rest(median)
}


